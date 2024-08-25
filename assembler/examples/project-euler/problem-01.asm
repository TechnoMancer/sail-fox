#include "../../fox.asm"

main:
    block (loop)
    ; set r0 (iterator) to 0
    set r0, 0
    ; set r1 (limit) to 1000 (1111101000)
    set r1, 1000
    ; set r2 (modulo 3 checker) to 0
    set r2, 0
    ; set r3 (modulo 5 checker) to 0
    set r3, 0
    ; set r4 (sum) to 0
    set r4, 0
    ; set r5 (upper half of sum) to 0
    set r5, 0

loop:
    block (3, .end) check3
    ; check if r0 (iterator) is divisible by 3 or 5
    b t6, if r2 eq 0
    b t6, if r3 eq 0
    b t0
    .end:
    block (1, .end2) check3
    ; add iterator (r0) to sum (r4)
    add r4, r0
    ; check fro carry
    lt.u p0, r4, r0
    b t0 if !p0
    .end2:
    block (.end3)
    ; apply carry
    inc r5, 1
    .end3:

check3:
    block (1, .end) check5
    b t0, if r2 neq 0
    .end:
    block (.end2)
    set r2, 3
    .end2:

check5:
    block (1, .end) epilogue
    b t0, if r3 neq 0
    .end:
    block (.end2)
    set r3, 5
    .end2:

epilogue:
    block (1, .end) loop
    ; update the modulo
    dec r2, 1
    dec r3, 1
    ; check if r0 (iterator) has hit the limit
    inc r0, 1
    lt.u p0, r0, r1
    b t0 if p0
    .end:

end_of_program:
    block (.end)
    halt
    .end: