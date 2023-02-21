#include "../../fox.asm"

main:
    ; set r0 (iterator) to 0
    set.w r0, 0
    ; set r1 (limit) to 1000 (1111101000)
    ; TODO: Use double-word instruction to save two words
    set.w r1, 0x7
    ; TODO: use shift-left
    ; sl r1, 3
    add r1, r1
    add r1, r1
    add r1, r1
    add r1, 0xE
    ; sl r1, 3
    add r1, r1
    add r1, r1
    add r1, r1
    ; set r2 (modulo 3 checker) to 0
    set.w r2, 0
    ; set r3 (modulo 5 checker) to 0
    set.w r3, 0
    ; set r4 (sum) to 0
    set.w r4, 0

loop:
    ; check if r0 (iterator) is divisible by 3 or 5
    eq r2, 0
    eq r3, 0 unless p0
    b check3 unless p0
    ; add iterator (r0) to sum (r4)
    add r4, r0

check3:
    eq r2, 0
    b check5 unless p0
    set.w r2, 3

check5:
    eq r3, 0
    b epilogue unless p0
    set.w r3, 5

epilogue:
    ; update the modulo
    sub r2, 1
    sub r3, 1
    ; check if r0 (iterator) has hit the limit
    add r0, 1
    lt r0, r1
    b loop if p0

    halt
