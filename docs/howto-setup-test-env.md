**How to setup testing environment**

**NOTE: Latest version please click [HERE(github)][100] or [HERE(gitee)][101](both in Chinese).**

This text is just remained for archivement.

[100]:https://github.com/aosp-riscv/working-group/blob/master/articles/20230407-test-riscv.md
[101]:https://gitee.com/aosp-riscv/working-group/blob/master/articles/20230407-test-riscv.md

<!-- TOC -->

- [1. Precondition](#1-precondition)
	- [1.1. Hardware environment](#11-hardware-environment)
	- [1.2. software dependencies](#12-software-dependencies)
- [2. compile tools](#2-compile-tools)
- [3. qemu](#3-qemu)
- [4. kernel](#4-kernel)
- [5. rootfs (busybox)](#5-rootfs-busybox)
- [6. How to use our test tools](#6-how-to-use-our-test-tools)
	- [6.1. Bionic unit tests](#61-bionic-unit-tests)
		- [6.1.1. Run test on host](#611-run-test-on-host)
		- [6.1.2. Run test on target](#612-run-test-on-target)
			- [6.1.2.1. Make minimal rootfs for testing](#6121-make-minimal-rootfs-for-testing)
			- [6.1.2.2. Dump the minimal rootfs](#6122-dump-the-minimal-rootfs)
			- [6.1.2.3. Launch the minial system with qemu](#6123-launch-the-minial-system-with-qemu)
			- [6.1.2.4. Run bionic test.](#6124-run-bionic-test)

<!-- /TOC -->

# 1. Precondition

Before continue, we default you have setup AOSP-RISCV development environment 
following this article ["How to build aosp-riscv"][1].

This document is located under `$AOSP/test/riscv/docs`, where $AOSP is the aosp
source tree path in your local machine.

## 1.1. Hardware environment

This experiment is based on Ubuntu 18.04 LTS.

```
$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 18.04.6 LTS
Release:        18.04
Codename:       bionic
$ uname -a
Linux u-OptiPlex-7080 5.4.0-91-generic #102~18.04.1-Ubuntu SMP Thu Nov 11 14:46:36 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

## 1.2. software dependencies

```
$ sudo apt install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev \
                 gawk build-essential bison flex texinfo gperf libtool patchutils bc \
                 zlib1g-dev libexpat-dev git \
                 libglib2.0-dev libfdt-dev libpixman-1-dev \
                 libncurses5-dev libncursesw5-dev libssl-dev
```

# 2. compile tools

It is required if you want to build qemu/kernel/busybox yourself. Due to we have
provided pre-built qemu/kernel/busybox binaries, so we don't details how to 
create the compile tools here.

If you met any problems, please contact us.

# 3. qemu

We have provided pre-built qemu binaries under `bin/qemu/install`. If you met 
any problems, please contact us.

# 4. kernel

We have provided pre-built kernel image under `bin/kernel`. If you met any 
problems, please contact us.

Following are introduction on how we build the aosp kenrel, FYI.


Download Android kernel source code:

```
$ git clone https://android.googlesource.com/kernel/common
$ cd common
$ git checkout 5.10-android12-9
```

Download Android kernel configuration:
```
$ git clone https://android.googlesource.com/kernel/configs
$ cd configs
$ git checkout android-12.0.0_r3
```

Merge config and build kernel:
```
$ cd common
$ make ARCH=riscv distclean
$ ARCH=riscv ./scripts/kconfig/merge_config.sh arch/riscv/configs/defconfig ../configs/android-5.10/android-base.config
$ make ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- -j $(nproc)
```

# 5. rootfs (busybox)

We have provided pre-built busybox binaries under `bin/busybox/_install/`. If 
you met any problems, please contact us.

Following are introduction on how we build the rootfs based on busybox, FYI.

Download busybox:
```
$ git clone git@github.com:mirror/busybox.git
```

Configure busybox
```
$ cd busybox
$ CROSS_COMPILE=riscv64-unknown-linux-gnu- make menuconfig
```

Open the configuration menu and enter "Settings" on the first line. In the 
"Build Options" section, select "Build static binary (no shared libs)", and exit
to save the configuration after setting.

Build:
```
$ CROSS_COMPILE=riscv64-unknown-linux-gnu- make -j $(nproc)
$ CROSS_COMPILE=riscv64-unknown-linux-gnu- make install
```
At this time, observe that a new `_install` directory appears under the source 
code directory busybox, and you can see the generated things.
```
$ ls _install
bin  linuxrc  sbin  usr
```

Make a minial rootfs:

Goto test folder for riscv, assume $AOSP points to the AOSP source tree folder.
```
$ cd $AOSP/test/riscv
```
Before run `make_rootfs.sh`, make sure you have edited envsetup and filled the 
correct path to some files.

Then you can run `make_rootfs.sh` to create the rootfs image file, note `sudo` 
is required to execute this script.
```
$ sudo ./make_rootfs.sh
```

`rootfs.img` will be created under out directory.
```
$ cd $AOSP/test/riscv
$ ls out
rootfs.img
```

# 6. How to use our test tools

## 6.1. Bionic unit tests

Read [bionic's README.md][2] first, specially the
section "Running the tests".

Official aosp test requires aosp system is ready and run test with adb. But till
now, we have not them available, so we have to setup temporary test environment
by ourselves. Folllowing are description about how to setup and run.

We have two methods to run bionic tests:
- Run on host: use qemu user mode and run test executable on host linux, which
  doesn't require making rootfs image (which requires sudo) but have some 
  limitation for testing.
- Run on target: use qemu system mode and run test executable on target system,
  which emulate a full target riscv system.

Note: before running bionic tests, make sure you have run `mmm bionic` and `mmm external/icu`.

### 6.1.1. Run test on host

We provides some scripts to make testing easy:

- `test/riscv/bionic/host/run.sh`: run bionic-unit-tests
- `test/riscv/bionic/host/run-static.sh`: run bionic-unit-tests-static
- `test/riscv/bionic/host/run-linker.sh`: run linker directly

Some corresponding debug scripts are also provided, so we can run gdb and debug 
upon testing. **Note**, please configure `test/riscv/bionic/host/.gdbinit` before
debugging.

- `test/riscv/bionic/host/debug.sh`: debug bionic-unit-tests
- `test/riscv/bionic/host/debug-static.sh`: debug bionic-unit-tests-static
- `test/riscv/bionic/host/debug-linker.sh`: debug linker directly

**Note**: running test on host doesn't support running **ALL** cases, and only 
supports running one case or all cases of one suite. Examples:
```
cd $AOSP/test/riscv/bionic/host
./run.sh wctype.wctype_l
./run-static.sh wctype.*
```

### 6.1.2. Run test on target

#### 6.1.2.1. Make minimal rootfs for testing

```
$ cd $AOSP/test/riscv
$ ./make_rootfs.sh
```

#### 6.1.2.2. Dump the minimal rootfs

If you make some changes in your minimal system, for example, you have created 
testing log and want fetch it out.

```
$ cd $AOSP/test/riscv
$ sudo ./dump_rootfs.sh
```
Note, root privilege is required to run this script.

A folder `out/rootfs_dump/` would be created and it contains all that in your 
minimal system.

#### 6.1.2.3. Launch the minial system with qemu

```
$ cd $AOSP/test/riscv
$ ./run.sh
```

#### 6.1.2.4. Run bionic test.

Press Enter to acitivate the console and go to bionic testing folder. We provide
scripts for quick launching of bionic tests.

```
Please press Enter to activate this console. 
/ # cd tests/bionic/
```

To run static link version for bionic unit tests
```
/tests/bionic # ./bionic-unit-tests-static.sh 
```

To run dynamic link version for bionic unit tests
```
/tests/bionic # ./bionic-unit-tests.sh 
```

To test specific suite/cases, run the script with positive/negative pattern. For
example, if you want to test all static bionic unit cases in suite "unistd" 
but exclude cases "execvpe_ENOEXEC" and "getpid_caching_and_pthread_create" of 
suite "unistd", you can input as below:
```
/tests/bionic # ./bionic-unit-tests-static.sh unistd.*-unistd.execvpe_ENOEXEC:unistd.getpid_caching_and_pthread_create
```

For more details on how to use the bionic-unit-tests-static, run:
```
/tests/bionic # /data/nativetest64/bionic-unit-tests-static/bionic-unit-tests-static -h
```

For more details on how to use the bionic-unit-tests, run:
```
/tests/bionic # /data/nativetest64/bionic-unit-tests/bionic-unit-tests -h
```


[1]: https://github.com/aosp-riscv/working-group/blob/master/docs/howto-setup-build-env.md
[2]: https://android.googlesource.com/platform/bionic/+/refs/heads/master/README.md
