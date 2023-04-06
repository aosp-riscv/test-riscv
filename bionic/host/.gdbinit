#display/z $x5
#display/z $x6
#display/z $x7

set disassemble-next-line on

#set detach-on-fork off

# set breakpoints below ......
b main

target remote : 1234

# now stop and the very begin of the program
# don't continue here, type "c" in gdb manually