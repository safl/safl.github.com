Getting 4.3 M IOPS with an emulated NVMe device in a qemu guest
===============================================================

These are initial notes on exploring the use of ``vfio-user`` for NVMe device
emulation in QEMU, backed by an SPDK block device (e.g., ``bdev_malloc``).
The goal is to assess whether such a setup is viable as a test vehicle for
evaluating the performance characteristics of the host software stack atop a
PCIe endpoint.

Traditional approaches rely on physical hardware, which introduces challenges
such as opaque, black-box behavior of real-world SSDs, pre-conditioning
requirements, and QoS variations due to garbage collection—all of which impact
I/O latency in ways that cannot readily be attributed to either host-side or
device-side effects.

Alternatives include NVMeVirt and QEMU’s built-in NVMe emulation.

To date, 4.3M IOPS has been achieved without tuning, using a single CPU core
for the SPDK target application. The next steps is to determine viability of the
method are:

- Can a single SPDK target provide a single emulated NVMe device capable of
  100 million IOPS?
- Alternatively, can this be scaled out—e.g., by providing 24 emulated devices
  to collectively reach 100 million IOPS?

The notes contain the steps needed to reproduce setup and numbers from using it.

System Setup
------------

In this system the host-side software consists of Debian Bookworm with misc.
packages and the main actors: **SPDK** and **qemu**. The guest-side consists of
Debian Bookworm, misc. packages, and the main actors to driving I/O efficiently
are: **xNVMe / uPCIe** and **fio**.

For the misc. packages then **SPDK** provides ``spdk/scripts/pkgdep.sh``,
**xNVMe** provides ``./toolbox/pkgs/debian-bookworm.sh``, **qemu** provides
errors indicating what is missing, and **fio** just need what is provided by
the others. For details on building and running the main actors, then details
follow.

cijoe and guest-data (host)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Install cijoe and rehash paths::

	pipx install cijoe
	pipx ensurepath

After logging in again, you should be able to::

	cijoe --example qemu.guest_x86_64
	cd cijoe-example-qemu.guest_x86_64/
	cijoe --monitor

By doing so a Debian Bookworm guest is provisioned using cloud-init, the purpose
of which is to have a boot.img to use later on, it should be available here::

	/root/guests/generic-bios-kvm-x86_64/boot.img

With this, done, then please do continue.

Variability (host)
~~~~~~~~~~~~~~~~~~

The configuration provided here is for an CPU with eight cores. The kernel is
instrumented for reduced variability via:

* Symmetric Multi-threading is disabled
* Processor power state is set to max
* Idle state is busy
* Cores 0-1 are for the host OS and interrupts
* Cores 2-7 are for qemu and the SPDK target app

This is done with the following kernel arguments::

	nosmt processor.max_cstate=1 idle=poll isolcpus=2-7 nohz_full=2-7 rcu_nocbs=2-7 irqaffinity=0-1

Then the following packages do::

	apt-get install -fy \
		linux-cpupower \
		linux-perf \
		lm-sensors

Then additionally via userspace tooling then the CPU frequency is fixed, the
governor is set for performance and boost is turned off::

	# Use the performance governor
	cpupower frequency-set -g performance

	# For reference, this shows what is available, should have
	# available frequency steps:  3.65 GHz, 2.20 GHz, 1.60 GHz
	cpupower frequency-info

	# Lock it at 3.65
	cpupower frequency-set -f 3.65GHz

	# Disable turbo boost
	echo 0 | tee /sys/devices/system/cpu/cpufreq/boost

This should provide a reliable core frequency and thus less variability on the
IOPS rate. Since the IOPS rate is directly proportional to th CPU-frequency,
then we want to reduce this.

Hugepages ... disable limits

SPDK (host)
~~~~~~~~~~~

Retrieving and build the, at the time of writing, latest release::

	# Grab the source
	git clone https://github.com/spdk/spdk.git ~/git/spdk
	cd ~/git/spdk
	git checkout v25.05
	git submodule update --init --recursive

	# System Packages
	./scripts/pkgdep.sh
	apt-get install python3-pyelftools

	# Configure and build (do not install)
	./configure \
	 --enable-lto \
	 --with-vfio-user \
	 --disable-unit-tests
	make -j

.. literalinclude:: setup_tgt.sh
   :language: bash

qemu (host)
~~~~~~~~~~~

Retrieving and build the, at the time of writing, latest release::

	# System Packages
	apt-get -fy install libcurl4

	git clone https://github.com/qemu/qemu.git ~/git/qemu
	cd ~/git/qemu
	git checkout v10.1.0
	git submodule update --init --recursive
	mkdir build
	cd build
	../configure \
	 --target-list=x86_64-softmmu \
	 --enable-kvm \
	 --enable-numa \
	 --enable-curl \
	 --enable-virtfs \
	 --enable-slirp
	make -j


.. literalinclude:: setup_qemu.sh
   :language: bash


Misc. (guest)
~~~~~~~~~~~~~

Fire up the guest to add a couple of things::

	qemu-system-x86_64 \
	  -enable-kvm \
	  -M q35,accel=kvm \
	  -m 8G -smp 4 -cpu host \
	  -drive file=/root/guests/generic-bios-kvm-x86_64/boot.img,format=qcow2,if=virtio \
	  -nographic

Install::

	apt-get install -fy \
		build-essential \
		git \
		meson \
		pkg-config

uPCIe (guest)
~~~~~~~~~~~~~

The uPCIe driver itself it embedded in **xNVMe**, however, the repository
provides a couple of useful tools (``devbind`` and ``hugepages``), so build and
install it::

	git clone https://github.com/safl/upcie ~/git/upcie
	cd ~/git/upcie
	git checkout v0.3.2
	make clean config build install

xNVMe (guest)
~~~~~~~~~~~~~

**xNVMe** has the **uPCIe** NVMe driver embedded, thus it can be utilized via
the **xNVMe** fio io-engine. The **uPCIe** driver is not available upstream
**xNVMe** yet, so get it from the fork as described below::

	git clone https://github.com/safl/xnvme ~/git/xnvme
	cd ~/git/xnvme
	git checkout upcie
	make config-slim
	make -j
	make install
	ldconfig

fio (guest)
~~~~~~~~~~~

Then to utilize this I/O path, build fio from source::

	git clone https://github.com/axboe/fio ~/git/fio
	cd ~/git/fio
	git checkout v3.40
	./configure
	make -j

In the output above, verify that the xNVMe ioengine is enabled.

Evaluation
----------

Inside the guest, one has to manually bind the driver one wants to use with the
PCIe device. In this case I want to use the NVMe driver embedded in **xNVMe**,
thus ``uio_pci_generic`` is loaded, associated with the device, and hugepages
are reserved::

	modprobe uio_pci_generic
	echo 4e58 0001 | sudo tee /sys/bus/pci/drivers/uio_pci_generic/new_id
	hugepages setup --count 512

With this in place then ``fio`` can be executed making use of the **xNVMe** fio
io-engine and the **upcie** backend in **xNVMe**. Thus, you must provide the
PCIe address on the domain-bus-device-function form as shown below as well as
tell it which namespace to make use of::

	./fio \
		--name=randread \
		--rw=randread \
		--bs=512 \
		--iodepth=16 \
		--numjobs=1 \
		--filename="0000\\:01\\:00.0" \
		--ioengine=xnvme \
		--xnvme_dev_nsid=0x1 \
		--thread=1 \
		--time_based \
		--runtime=60s

Numbers from different systems provided below.

Intel
~~~~~

cpu
	Core i5-12500 CPU
mb
	PRIME Z690M-HZ
mem
	2x 32GB DDR4 @ 3200 MHz - Samsung M378A4G43AB2-CWE

I got the following numbers::

	randread: (g=0): rw=randread, bs=(R) 512B-512B, (W) 512B-512B, (T) 512B-512B, ioengine=xnvme, iodepth=16
	fio-3.40-88-gd6ac
	Starting 1 thread
	Jobs: 1 (f=1): [r(1)][100.0%][r=2105MiB/s][r=4311k IOPS][eta 00m:00s]
	randread: (groupid=0, jobs=1): err= 0: pid=484: Tue Sep  2 12:17:29 2025
	  read: IOPS=4299k, BW=2099MiB/s (2201MB/s)(123GiB/60000msec)
	    slat (nsec): min=41, max=62633, avg=46.68, stdev=17.72
	    clat (nsec): min=1521, max=3768.9k, avg=3550.21, stdev=1419.48
	     lat (nsec): min=1568, max=3769.0k, avg=3596.88, stdev=1419.84
	    clat percentiles (nsec):
	     |  1.00th=[ 3280],  5.00th=[ 3344], 10.00th=[ 3376], 20.00th=[ 3408],
	     | 30.00th=[ 3440], 40.00th=[ 3472], 50.00th=[ 3472], 60.00th=[ 3504],
	     | 70.00th=[ 3536], 80.00th=[ 3600], 90.00th=[ 3696], 95.00th=[ 3856],
	     | 99.00th=[ 4512], 99.50th=[ 5920], 99.90th=[14272], 99.95th=[16320],
	     | 99.99th=[17280]
	   bw (  MiB/s): min= 2057, max= 2129, per=100.00%, avg=2100.85, stdev=18.03, samples=119
	   iops        : min=4212818, max=4362210, avg=4302538.20, stdev=36931.60, samples=119
	  lat (usec)   : 2=0.01%, 4=96.61%, 10=3.26%, 20=0.12%, 50=0.01%
	  lat (usec)   : 100=0.01%
	  lat (msec)   : 4=0.01%
	  cpu          : usr=99.99%, sys=0.00%, ctx=298, majf=1, minf=0
	  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
	     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
	     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
	     issued rwts: total=257932731,0,0,0 short=0,0,0,0 dropped=0,0,0,0
	     latency   : target=0, window=0, percentile=100.00%, depth=16

	Run status group 0 (all jobs):
	   READ: bw=2099MiB/s (2201MB/s), 2099MiB/s-2099MiB/s (2201MB/s-2201MB/s), io=123GiB (132GB), run=60000-60000msec

The key metrics being to observe above is the avg. latency of **3600ns** **and
4.3M IOPS**. Do not that this was without core-isolation and with a single
device emulated pinned on a single core. Thus, the i5 core was able to do a
dramatic turbo-boost.

AMD
~~~

cpu
	Ryzen 7 PRO 8700GE
mb
	ASRock Rack B665D4U-1L
mem
	2x 32GB DDR5 @ 5600 MHz - Micron MTC20C2085S1EC56BD1 KC