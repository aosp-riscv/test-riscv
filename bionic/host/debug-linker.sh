#!/bin/bash

# debug dynamic linker

source $PATH_BASE/bionic/host/.env.init

COMMAND_QEMU="$PATH_LINKER $PATH_EXE --no_isolate --gtest_filter=$GTEST_FILTER"
#COMMAND_QEMU="$PATH_LINKER --list $PATH_EXE"

DEBUG=yes
COMMAND_GDB="$PATH_LINKER"

source $PATH_BASE/bionic/host/.run.exec
