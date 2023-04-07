#!/bin/bash

if [[ -z "${ANDROID_BUILD_TOP}" ]]; then
  echo "AOSP env has not been setup, which is required for riscv test!!!"
  exit 1
else
  echo "ANDROID_BUILD_TOP:${ANDROID_BUILD_TOP}"
fi

PATH_BASE=$ANDROID_BUILD_TOP/test/test-riscv
echo "PATH_BASE:${PATH_BASE}"
export PATH_BASE

################################################################################
# Following PATH_* are all can be customized
################################################################################
PATH_QEMU_BIN=
if [[ -z "${PATH_QEMU_BIN}" ]]; then
  echo "PATH_QEMU_BIN has not been setup, which is required for riscv test!!!"
  exit 1
else
  echo "PATH_QEMU_BIN:${PATH_QEMU_BIN}"
  export PATH_QEMU_BIN
fi

PATH_GNUTOOLS_BIN=
if [[ -z "${PATH_GNUTOOLS_BIN}" ]]; then
  echo "PATH_GNUTOOLS_BIN has not been setup, which is required for riscv test!!!"
  exit 1
else
  echo "PATH_GNUTOOLS_BIN:${PATH_GNUTOOLS_BIN}"
  export PATH_GNUTOOLS_BIN
fi

PATH_KERNEL=$PATH_BASE/bin/kernel/Image
echo "PATH_KERNEL:${PATH_KERNEL}"
export PATH_KERNEL

PATH_ROOTFS_TEMPLATE=$PATH_BASE/bin/busybox/_install
echo "PATH_ROOTFS_TEMPLATE:${PATH_ROOTFS_TEMPLATE}"
export PATH_ROOTFS_TEMPLATE

export PATH="$PATH_QEMU_BIN:$PATH"

