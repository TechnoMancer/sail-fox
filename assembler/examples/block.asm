#include "../fox.asm"

block (0, #2)
add r0, r1
sub r2, r3

start:
block (0, end)
add r2, 4
sub r3, 6
end:

block (#2)
sub r4, r5
add r5, r6

start2:
block (end2)
xor r6, r7
lt r7, r6
subf r8, r7
add r9, 3
end2:

block (#3) start
nop
or r10, r11
andc r11, r3

block (end3) start2
nop
nop
nop
end3: