#!/usr/bin/env bash
set -euo pipefail

# --- Paths (intentionally separate) ---
SPDK_TGT_BIN="${SPDK_TGT_BIN:-/root/git/spdk/build/bin/spdk_tgt}" # installed binary
SPDK_RPC_PY="${SPDK_RPC_PY:-/root/git/spdk/scripts/rpc.py}"       # from repo checkout

# --- Config ---
SUBSYSTEM_NQN="${SUBSYSTEM_NQN:-nqn.2016-06.io.spdk:cnode1}"
SUBSYSTEM_SN="${SUBSYSTEM_SN:-SPDK00}"
BDEV_NAME="${BDEV_NAME:-Malloc0}"
SIZE_MB="${SIZE_MB:-4092}"       # 4 GiB
BLKSZ="${BLKSZ:-512}"            # 512-byte LBA
VFIO_DIR="${VFIO_DIR:-/tmp/vfu}" # directory; socket(s) created inside (cntrl)
COREMASK="${COREMASK:-0x10}"

# --- Sanity checks ---
[ -x "$SPDK_TGT_BIN" ] || { echo "spdk_tgt not executable: $SPDK_TGT_BIN" >&2; exit 1; }
[ -r "$SPDK_RPC_PY" ]  || { echo "rpc.py not readable:     $SPDK_RPC_PY" >&2; exit 1; }

RPC() { "$SPDK_RPC_PY" "$@"; }

echo "[+] Killing any existing spdk_tgt..."
pkill -f spdk_tgt || true
sleep 4

echo "[+] Dedicating 32GB to hugepages etc."
HUGEMEM=$((32 * 1024)) ~/git/spdk/scripts/setup.sh

echo "[+] Resetting vfio-user dir: $VFIO_DIR"
rm -rf -- "$VFIO_DIR"
mkdir -p -- "$VFIO_DIR"

echo "[+] Starting spdk_tgt (COREMASK=$COREMASK)..."
"$SPDK_TGT_BIN" -m "$COREMASK" &
SPDK_PID=$!

# Give RPC a moment then block until framework ready
sleep 0.5
RPC framework_wait_init >/dev/null

echo "[+] Creating malloc bdev: $BDEV_NAME (${SIZE_MB}MB, LBA=${BLKSZ})"
RPC bdev_malloc_create "$SIZE_MB" "$BLKSZ" -b "$BDEV_NAME"

echo "[+] Creating VFIOUSER transport"
RPC nvmf_create_transport -t VFIOUSER

echo "[+] Creating subsystem: $SUBSYSTEM_NQN (SN=$SUBSYSTEM_SN)"
RPC nvmf_create_subsystem "$SUBSYSTEM_NQN" -s "$SUBSYSTEM_SN" -a

echo "[+] Adding namespace: $BDEV_NAME"
RPC nvmf_subsystem_add_ns "$SUBSYSTEM_NQN" "$BDEV_NAME"

echo "[+] Adding VFIO-user listener at $VFIO_DIR"
RPC nvmf_subsystem_add_listener "$SUBSYSTEM_NQN" -t VFIOUSER -a "$VFIO_DIR" -s 0

echo "[✓] Ready: NQN=$SUBSYSTEM_NQN  BDEV=$BDEV_NAME  LBA=$BLKSZ  SIZE=${SIZE_MB}MB  PID=$SPDK_PID"
