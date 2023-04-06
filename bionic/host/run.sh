#!/bin/bash

source $PATH_BASE/bionic/host/.env.init

COMMAND_QEMU="$PATH_EXE --no_isolate --gtest_filter=$GTEST_FILTER"

source $PATH_BASE/bionic/host/.run.exec