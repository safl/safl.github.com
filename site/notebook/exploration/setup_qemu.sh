#!/usr/bin/env bash
set -euo pipefail

taskset -c 8-11 \
qemu-system-x86_64 \
  -enable-kvm \
  -M q35,accel=kvm \
  -object memory-backend-memfd,id=mem,size=8G,share=on,prealloc=on \
  -numa node,memdev=mem \
  -m 8G -smp 4 -cpu host \
  -device pcie-root-port,id=rp0,bus=pcie.0,chassis=1,slot=1 \
  -device '{"driver":"vfio-user-pci","bus":"rp0","addr":"0x0","socket":{"type":"unix","path":"/tmp/vfu/cntrl"}}' \
  -drive file=/root/guests/generic-bios-kvm-x86_64/boot.img,format=qcow2,if=virtio \
  -nographic
