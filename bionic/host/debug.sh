#!/bin/bash

# debug bionic-unit-tests

source $PATH_BASE/bionic/host/.env.init

COMMAND_QEMU="$PATH_EXE --no_isolate --gtest_filter=$GTEST_FILTER"

DEBUG=yes
COMMAND_GDB="$PATH_EXE"

source $PATH_BASE/bionic/host/.run.exec

