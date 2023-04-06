#!/bin/bash

# run linker directly

source $PATH_BASE/bionic/host/.env.init

COMMAND_QEMU="$PATH_LINKER $PATH_EXE --no_isolate --gtest_filter=$GTEST_FILTER"
#COMMAND_QEMU="$PATH_LINKER --list $PATH_EXE"

source $PATH_BASE/bionic/host/.run.exec

