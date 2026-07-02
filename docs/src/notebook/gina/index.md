# GPU-initiated NVMe (GPUDirect on AMD)

Notes from getting a HIP `__global__` kernel on an AMD GPU to drive an NVMe
device directly: the kernel builds submission-queue entries, rings the doorbell,
and reaps completions from device code, while the SSD DMAs payload straight into
GPU VRAM. This is the "accelerator-initiated I/O" idea: the CPU is not on the
per-I/O path at all. The work was done in uPCIe (a header-only user-space PCIe
library) and validated on a consumer Radeon card. Most of the value here is the
list of traps, because almost none of them are documented in one place.

## The test box

- AMD Radeon RX 7800 XT (Navi 32, `gfx1101`, RDNA3), consumer card.
- Samsung PM9E1 NVMe, bound to `uio_pci_generic` (raw physical DMA, no IOMMU
  translation), `iommu=pt`.
- Ubuntu 26.04, ROCm 7.1 (and 7.2 tried via a container).
- Payload buffers in GPU VRAM via a small hipmem allocator; queues in host
  memory.

The short version: it works and it is 100% reliable across single-IO,
multi-queue, and queue-wrapping workloads. It is not fast: ~600 us per 1-LBA
I/O, which is roughly an order of magnitude slower than the PM9E1's native
single-command latency (~50-80 us). That overhead is the CPU-relayed
bridge and the device-side reap loop, not the SSD, so the number says nothing
about the hardware ceiling. The result here is functional and reliable, not
fast. It is a consumer card, so getting there required working around several
AMD/ROCm specifics rather than using a documented GPUDirect path.

## Architecture

Three data structures, each placed where its coherence direction actually
works on this hardware:

- **Submission queue (SQ): host memory.** The GPU writes SQEs and the controller
  reads them; both sides touch host DRAM coherently. A VRAM SQE write is *not*
  visible to the controller's peer read mid-kernel, so the SQ cannot live in
  VRAM.
- **Completion queue (CQ): host memory, CPU-relayed.** The controller DMAs
  completions into a host CQ that the CPU sees coherently, and a host poller
  mirrors it into a GPU-coherent shadow the reap reads. The GPU cannot read the
  controller's completion write directly (see the coherence trap below).
- **Data buffers: VRAM.** This is the GPUDirect win. The SSD reads/writes payload
  straight to/from GPU memory over PCIe P2P. Buffers are filled before launch,
  so their transfer is not subject to mid-kernel coherence.

The doorbell is relayed by a host "bridge": the kernel writes the tail/head into
a GPU-writable shadow cell and a CPU poller thread mirrors that to the real BAR0
MMIO doorbell. The GPU still *owns* submission and completion logic; only the
4-byte MMIO write is relayed. This exists because the GPU cannot map the NVMe's
BAR into its own address space on this stack (below). The GPU-resident code is
identical whether the doorbell is bridged or written directly, so the same
kernel works on hardware that can do direct MMIO.

## Why the doorbell is bridged, not direct

Direct GPU-to-BAR MMIO needs the NVMe BAR mapped into the GPU's virtual address
space. On this stack every user-space route fails, and it fails entirely inside
the ROCm runtime with no kernel involvement:

- `hipHostRegister(bar, size, hipHostRegisterMapped)` and `...IoMemory`:
  `hipErrorInvalidValue`.
- `hsa_amd_memory_lock` and `hsa_amd_memory_lock_to_pool` (across every
  memory pool): generic `HSA_STATUS_ERROR`, `dev=(nil)`.

This is with `iommu=pt` and a healthy KFD, so it is not the IOMMU or the
kernel. ROCm 7.2 (tested via the `rocm/dev-ubuntu-24.04:7.2-complete`
container over the same kernel) behaves identically, so it is not a userspace
version gap either. The host-registration APIs simply do not map a peer
device's MMIO here. It is not a hardware limit: consumer RDNA can master MMIO to
a peer BAR, it just needs the mapping set up by a mechanism these APIs do not
provide (a dma-buf import of the BAR, or a small kernel helper). The bridge
sidesteps the whole question.

## CDNA vs RDNA

The friction is consumer RDNA vs datacenter CDNA, and it shows up in three
places worth remembering:

- **Fine-grained coherent memory.** On CDNA (MI200/MI300) it is the default. On
  consumer RDNA it exists only with `HSA_FORCE_FINE_GRAIN_PCIE=1` in the
  environment; without it the GPU faults accessing host memory. Every run here
  needs that variable.
- **Memory ordering.** `__threadfence()` is enough for cross-device ordering
  on MI300X; RDNA needs `__threadfence_system()`.
- **Peer P2P / doorbell.** Direct BAR0 doorbell writes are documented to work on
  RDNA but with coherence caveats that need aggressive fencing (below). The
  turnkey, no-workaround path is a CDNA property.

Practical read: a consumer RX 7800 XT is enough to demonstrate GPU-initiated I/O.
The datacenter "just works" behaviour is CDNA (lowest-cost being an MI210 PCIe
card; MI300A has unified coherent memory). No hardware change is required for
capability, only for convenience.

## The traps (this is the useful part)

### clock64() is not the wall clock on gfx1101

The device-side reap used a timeout built from `clock64()` scaled by
`hipDeviceAttributeClockRate`. On `gfx1101` `clock64()` advances at roughly
0.6 MHz while the attribute reports 2.25 GHz, so a 1-second timeout became about
an hour. A missing completion then span the kernel past the GPU ring lockup
watchdog and *reset the whole GPU*, which cascaded into every later run. Use
`wall_clock64()`, a fixed-frequency counter whose rate is reported by
`hipDeviceAttributeWallClockRate` (100 MHz here, and it measures out exactly).
Cap the wait well under the ~10s watchdog so a miss fails fast instead of
resetting the device.

### The RDNA doorbell fence, and the macro that silently disables it

The default doorbell store (`__threadfence_system()` then an atomic release
store) leaves the write lingering in the GPU write path on consumer RDNA: it is
not seen by the CPU poller (or a peer) until near kernel exit. The fix is the
ISA-level sequence AMD uses for this: drain outstanding memory ops, store
bypassing all caches (`glc slc dlc`), then invalidate `GL0`/`GL1`:

```text
s_waitcnt lgkmcnt(0) vmcnt(0)
s_waitcnt_vscnt null, 0x0
global_store_dword %0, %1, off glc slc dlc
s_waitcnt lgkmcnt(0) vmcnt(0)
s_waitcnt_vscnt null, 0x0
buffer_gl1_inv
buffer_gl0_inv
```

The trap: gating this on the specific `__gfx1101__` macro looks right but
compiles to nothing. Kernels are built with `--offload-arch=native`, which on
this box resolves to the *generic* `gfx11-generic` target, where the specific
`__gfxNNNN__` macros are undefined; the fence silently fell through to the weak
path (confirmed by zero `buffer_gl1_inv` in the disassembly). Gate on the
*family* macros `__GFX10__` / `__GFX11__` / `__GFX12__` instead, which are
defined for both specific and generic targets. Always verify the instruction is
actually in the compiled object; do not trust the `#if`.

### Do not flood the doorbell

This was the big one. A naive poller mirrors the shadow doorbell to the real BAR
every loop iteration. That is a few million MMIO writes per second flooding the
NVMe's PCIe ingress, and it starves the controller's *completion DMA* so the
completion lands after the reap deadline. Instrumenting the poller made it
obvious: the doorbell was delivered fine, the completion was posted fine, it
just arrived too late. Ring a doorbell only when its value changes. This alone
took the thing from "almost always fails" to "mostly works", multi-queue
included.

### Peer DMA does not snoop the GPU cache

A CPU write to fine-grained host memory invalidates the GPU's cached copy, so
the GPU sees it. A PCIe *peer's* DMA write to that same host memory does not
snoop the GPU cache, so a GPU poll keeps reading a stale line. This is why the
CQ is CPU-relayed: the CPU reads the controller's completion (coherent for the
CPU) and re-writes it into a shadow the GPU can see. On the read side, invalidate
`GL0`/`GL1` before the poll load so the reap re-fetches rather than hitting a
stale per-CU line. System-scope atomic loads and non-temporal loads were *not*
sufficient on `gfx1101` (the non-temporal load returned the stale zero).

### Do not re-ring a stale doorbell across a queue wrap

The last flaky case was queue-wrap: submit a batch, then submit another that
wraps the ring (reusing slots). It failed intermittently, and per-slot dumps
showed the controller processing only the *first* command of the wrapping batch
while the submission-queue contents were correct. It was a doorbell race, not a
completion bug. The poller had been started and stopped around each kernel
launch; on the second launch it reset its "last value written" tracking and
re-rang the *stale* tail from the previous batch just before the real wrapped
tail, and the controller's fetch raced that pair of rings and saw only one new
entry. The fix is to run one poller for the whole queue lifetime rather than per
launch, so it only ever rings on a genuine change. A relay that re-emits a stale
doorbell value is not harmless.

## Results

After the above, GPU-initiated NVMe read+write on the RX 7800 XT is 100%
reliable across every tested configuration:

- ~600 us per 1-LBA I/O (doorbell ring to completion). This is slow: the PM9E1
  services a single command in ~50-80 us, so the round-trip is
  dominated by the bridge poller and the device-side reap, not by the SSD.
  Reducing it means removing the bridge (direct doorbell) and tightening or
  interrupt-driving the reap; the current path optimizes for correctness, not
  latency.
- 48/48 in a sweep spanning single-IO, wrapping queues, multi-queue (2 and 4
  queues), and multi-round submission (one queue, eight rounds).
- Multi-queue and queue-wrap both work, neither of which did before the fixes.

There is no remaining known-flaky case. The feature is functional and reliable
on a consumer RX 7800 XT via the CPU-relayed bridge; a CDNA card would allow the
direct-doorbell variant and drop the bridge entirely.

### Putting 600 us in context

The numbers below mix order-of-magnitude reference points with two figures
measured in this lab (marked *measured*). All latencies are in microseconds
(us) for comparison. They exist to show that 600 us is not near any physical
floor; it is a software round-trip that happens to sit far above the media it is
reading.

| Step | Latency (us) | Notes |
| --- | --- | --- |
| DRAM reference | ~0.1 | host memory load |
| PCIe TLP round trip | ~0.5-1 | e.g. an MMIO register read from the device |
| NVMe 1-LBA read, QD1, Optane M10, host user-space driver | ~3.5 | *measured*; 3D XPoint media, no NAND page-read floor, tight poll-mode user-space path. This is genuinely fast |
| NAND page read (media, tR) | ~40-100 | the actual flash-read time on TLC; the hard floor for a cache miss on a NAND SSD |
| NVMe 1-LBA read, QD1, TLC NAND SSD | ~50-80 | what a well-tuned host driver sees end to end on a PCIe 5 client NAND SSD like the PM9E1; dominated by NAND tR plus controller |
| GPU-initiated 1-LBA via bridge | ~600 | *measured*, this work: doorbell ring to completion observed |

Two things stand out. First, the media matters enormously: the Optane M10's 3D
XPoint answers in ~3.5 us end to end through a tight host user-space driver,
roughly 15-20x faster than a TLC NAND SSD, because there is no ~50 us NAND
page-read to wait on. That 3.5 us path is the standard to beat.

Second, our ~600 us is nowhere near either floor. It is about 8-12x slower than a
NAND SSD and roughly 170x slower than the Optane user-space path on the same
class of host. The gap is not the media and not the PCIe fabric; it is the CPU
bridge poller's iteration granularity plus the device-side reap loop polling for
the completion, both polling constructs chosen for correctness. Removing the
bridge (direct doorbell) and making the reap interrupt- or fence-driven rather
than spin-polled is where the microseconds would come back; none of it is
bounded by the hardware.

## Two process lessons

- **Verify the binary you are testing.** A test compile error made the build
  fail; with fail-fast the install step was skipped and the *stale* binary kept
  running, so several "results" were old code. Check the build succeeded and the
  installed artifact is fresh (`strings ... | grep` for a known symbol) before
  trusting a measurement.
- **Instrument the mechanism; do not infer it.** A pile of plausible coherence
  theories evaporated the moment the poller was made to report its iteration
  count, the max doorbell value it observed, and host timestamps. The real cause
  (a PCIe write flood) was nothing like the guesses.

## Can the bridge be removed? (open direction)

The CPU-relayed bridge is not fundamental; it does two separable jobs, each a
workaround for a coherence gap on this stack:

1. **Doorbell relay** because the GPU cannot write the NVMe BAR (the BAR is not
   mapped into GPU virtual address space).
2. **CQ mirror** because a peer's DMA write into host memory does not snoop the
   GPU cache, so the reap cannot read the controller's completion directly.

What is actually proven is narrow: *user-space peer-MMIO registration* fails
here. `hipHostRegister` (Mapped and IoMemory), `hsa_amd_memory_lock`, and
`hsa_amd_memory_lock_to_pool` all reject the NVMe BAR, on ROCm 7.1 and on 7.2
userspace running over this kernel, entirely in the runtime with no kernel
involvement. That is a real blocker for those APIs on this box, not a proof that
the GPU cannot ring the doorbell.

Routes that would eliminate the doorbell relay, none yet tried here:

- **BAR-as-dma-buf import (the decisive test).** Bind the NVMe to `vfio-pci`,
  export BAR0 as a dma-buf (VFIO's `DMA_BUF` device feature, or PCI P2PDMA), and
  import it with `hipImportExternalMemory` / `hipExternalMemoryGetMappedBuffer`.
  If that yields a GPU-usable device pointer to the BAR, the kernel writes the
  doorbell directly and the relay is gone. This is the single experiment that
  settles "can the bridge be removed" on this hardware.
- A small kernel helper that maps the BAR pages into the GPU VM (rocm-xio ships
  a DKMS module for its VRAM-address side; a doorbell mapping is the analogue).
- A native ROCm 7.2 install on an AMD-supported kernel (rocm-xio's `mapPciBar`
  uses these same calls and requires 7.2+, so on the right stack they succeed),
  or a CDNA card, where direct BAR0 doorbell is the documented path.

The CQ mirror is separately avoidable: rocm-xio polls the real CQ directly with
plain volatile loads and no mirror. Ours exists only because the CQ is in host
memory. Put the CQ in device memory (or a coherent mapping the GPU can read) and
the mirror goes away too.

Resume plan for a fresh session: start with the vfio dma-buf BAR import. If the
GPU gets a usable BAR pointer, point `qp->sqdb`/`qp->cqdb` at it (the device
code is unchanged), drop the doorbell relay, move the CQ to device memory, and
the poller disappears. If the import path is also blocked, the bridge stays as
the correct consumer-RDNA answer and direct-doorbell is a CDNA / newer-stack
feature. All of this lives in uPCIe under `include/upcie/nvme/*_hip.h` and
`tests/test_hip_nvme_readwrite.c`; the bridge, poller, and reap are in
`nvme_controller_hip.h` and `nvme_qpair_hip.h`.
