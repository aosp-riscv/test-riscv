#!/bin/bash

# debug bionic-unit-tests-static

source ./.envsetup

# we have to use --no_isolate on host due to we lack the same rootfs env as that on target

COMMAND_QEMU="$PATH_EXE_STATIC --no_isolate --gtest_filter=$GTEST_FILTER"

DEBUG=yes
COMMAND_GDB="$PATH_EXE_STATIC"

source ./.run.exec
