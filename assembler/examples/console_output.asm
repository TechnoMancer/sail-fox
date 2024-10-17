#include "../fox.asm"

test:
    block (.end)
    set r0, 0xfffc
    set r1, hello
    set r8, helloLen
    ld.w r8, r8[0]
    set r9, 0
    ld.w r3, r8[0]
    .end:
    loop:
    block (1, .end)
    ld.w r2, r1[0]
    byteswap r2, r2
    st.w r2, r0[0]
    byteswap r2, r2
    st.w r2, r0[0]
    dec r8, 2
    inc r1, 2
    gt.s p0, r8, r9
    b current if p0
    .end:
    exit:
    block (.end)
    halt
    .end:

hello:
#d "Hello\n"

hello_len = $ - hello

helloLen:
#d16 hello_len