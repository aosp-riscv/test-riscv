#display/z $x5
#display/z $x6
#display/z $x7

#set disassemble-next-line on

# setup debug source path env
set sysroot /aosp/wangchen/dev-aosp12/aosp-riscv/out/target/product/emulator_riscv64/symbols
set solib-search-path /aosp/wangchen/dev-aosp12/aosp-riscv/out/target/product/emulator_riscv64/symbols/system/lib64/
dir /aosp/wangchen/dev-aosp12/aosp-riscv
#set sysroot /home/u/ws/dev-aosp12/aosp-riscv/out/target/product/emulator_riscv64/symbols
#set solib-search-path /home/u/ws/dev-aosp12/aosp-riscv/out/target/product/emulator_riscv64/symbols/system/lib64/
#dir /home/u/ws/dev-aosp12/aosp-riscv

#set detach-on-fork off

# set breakpoints below ......
#b bionic/tests/clang_fortify_tests.cpp:144
#b bionic/tests/glob_test.cpp:245
#b bionic/tests/time_test.cpp:115
#b bionic/tests/sys_ptrace_test.cpp:229
#b bionic/tests/sys_ptrace_test.cpp:180
#b __linker_cannot_link
#b bionic/tests/pthread_test.cpp:2640
#b bionic/libc/stdio/stdio.cpp:1213
#b bionic/libc/bionic/spawn.cpp:170
#b vfork
#b _start_main
#b layout_static_tls
#b StaticTlsLayout::reserve
b main
#b __linker_init
#b __linker_init_post_relocation
#b bionic/linker/linker_main.cpp:310
#b bionic/linker/linker.cpp:1516
#b bionic/linker/linker.cpp:1578
#b get_ld_config_file_path
#b bionic/tests/stdio_test.cpp:941
#b init_default_namespaces
#b bionic/tests/elftls_test.cpp:52
#b bionic/linker/linker_main.cpp:662


target remote : 1234

# now stop and the very begin of the program
# don't continue here, type "c" in gdb manually