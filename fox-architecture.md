# Fox ISA version n #

The design is meant to primarily be a 16-bit ISA for a fantasy console or something like a PDP-11, but one that can in theory be extended to 32/64 bits and can have capabilities retrofitted to it.

I also want to long-term sneak in floating-point support.


## Registers ##

 - 16 registers, `r0` - `r15`
 - 8 predicates, `p0` - `p7`
 - 8 target registers, `t0` - `t7`
 - 256 system registers, `csr[0]` - `csr[255]`

### Integer ###

There are 16 integer registers named `r0` to `r15`.

 - `r0` to `r7` are used for function arguments / return values
 - `r8` to `r11` are temporaries
 - `r12` to `r17` are callee saved


### Predicates ###

There are 8 predicate registers named `p0` - `p7`. The negations named `!p0` to `!p6` are also available in the encoding. All the predicate registers are considered temporary, none are callee saved.

`p7` is hardwired to true and therefore has the alternative name `true`, the negation of `p7` is reserved for now.


### Target Registers ###

There are 8 branch target registers named `t0` to `t7` that are used to both compress the encoding for branches, but also to allow the branch predictor to have an easier time. All the target registers are considered temporary, none are callee saved.

 - `t0` to `t4` are temporaries
 - `t5` is used as the link register, also named `link`
 - `t6` is the next sequential block after the current one, also named `next`
 - `t7` is the current block, also named `current`


### CSRs ###

The following CSRs are defined, the there are in theory 256 of them but all of the other ones should fail. 

 - `csr[0]` or `sp` is the stack pointer.


## Single-word ISA ##

Note: I am not sure if reserving half or a quarter of the instruction space for longer instructions makes more sense?
Note: Is a 3-operand add/sub here worth it? It costs one eight of the entire encoding space, I added a 3-op add for now.

| 0000 0000 dddd aaaa | mov rd, ra (rd = ra is reserved)
| 0000 0001 dddd aaaa | not rd, ra
| 0000 0010 dddd aaaa | neg rd, ra
| 0000 0011 dddd aaaa | byteswap rd, ra
| 0000 0100 dddd aaaa | mov rd, ra if p0 (rd = ra is reserved)
| 0000 0101 dddd aaaa | mov rd, ra unless p0 (rd = ra is reserved)
| 0000 0110 0ddd aaaa | read rd, ta
| 0000 0110 1ddd aaaa | target td, ra
| 0000 0111 0ddd aaaa | b td if ra == 0 
| 0000 0111 1ddd aaaa | b td if ra != 0
| 0000 1000 dddd aaaa | eq p0, rd, ra
| 0000 1001 dddd aaaa | gt.s p0, rd, ra
| 0000 1010 dddd aaaa | gt.u p0, rd, ra
| 0000 1011 0ddd pppp | b td (predicated)
| 0000 1011 1ddd pppp | call td (predicated)
| 0000 1100 dddd aaaa | inc rd, ra
| 0000 1101 dddd aaaa | dec rd, ra
| 0000 1110 dddd aaaa | inc.c rd, ra, p1 (carry in/out in p1)
| 0000 1111 dddd aaaa | dec.c rd, ra, p1 (carry in/out in p1)
| 0001 0000 dddd aaaa | and rd, ra
| 0001 0001 dddd aaaa | or rd, ra
| 0001 0010 dddd aaaa | xor rd, ra
| 0001 0011 dddd aaaa | andc rd, ra
| 0001 0100 xxxx xxxx | reserved
| 0001 0101 xxxx xxxx | reserved
| 0001 0110 xxxx xxxx | reserved
| 0001 0111 xxxx xxxx | reserved
| 0001 1000 xxxx xxxx | reserved
| 0001 1001 xxxx xxxx | reserved
| 0001 1010 xxxx xxxx | reserved
| 0001 1011 xxxx xxxx | reserved
| 0001 1100 xxxx xxxx | reserved
| 0001 1101 xxxx xxxx | reserved
| 0001 1110 xxxx xxxx | reserved
| 0001 1111 00ii iiii | allocate imm (sp -= imm)
| 0001 1111 01ii iiii | deallocate imm (sp += imm)
| 0001 1111 10ii iiii | reserved
| 0001 1111 11ii iiii | reserved
| 0010 0000 dddd iiii | set rd, imm + 1
| 0010 0001 dddd iiii | set rd, -(imm + 1)
| 0010 0010 dddd iiii | inc rd, imm + 1
| 0010 0011 dddd iiii | dec rd, imm + 1
| 0010 0100 dddd iiii | inc rd, imm + 1 if p0
| 0010 0101 dddd iiii | dec rd, imm + 1 if p0
| 0010 0110 dddd iiii | reserved
| 0010 0111 dddd iiii | reserved
| 0010 1000 dddd iiii | shl rd, imm + 1
| 0010 1001 dddd iiii | shr.a rd, imm + 1
| 0010 1010 dddd iiii | shr.l rd, imm + 1
| 0010 1100 dddd iiii | ror rd, imm + 1
| 0010 1101 dddd iiii | load rd, sp[imm]
| 0010 1110 dddd iiii | store rd, sp[imm]
| 0010 1111 bbnn nnnn | block (b = branch count, n = instruction word count - 1)
| 0011 xxxx xxxx xxxx | reserved
| 0100 bbbb aaaa dddd | add rd, ra, rb
| 0101 xxxx xxxx xxxx | reserved
| 0110 iiii dddd aaaa | load rd, ra[imm]
| 0111 iiii dddd aaaa | store rd, ra[imm]


## Double-word ISA ##

Note: We assume here that only a quarter of the instruction space is reserved for double-word or longer instructions, renumber them to 10 if this is not true in the future.
Note: We can probably make a CPU that is useful without supporting any of these since they are somewhat synthesisable.

| 1100 0000 dddd aaaa bbbb pppp 0000 0000 | eq pd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 0001 | gt.s pd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 0010 | gt.u pd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 0011 | reserved
| 1100 0000 dddd aaaa bbbb pppp 0000 0100 | add rd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 0101 | sub rd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 0110 | add.c rd, ra, rb, p1 (predicated, carry in/out in p1)
| 1100 0000 dddd aaaa bbbb pppp 0000 0111 | sub.c rd, ra, rb, p1 (predicated, carry in/out in p1)
| 1100 0000 dddd aaaa bbbb pppp 0000 1000 | and rd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 1001 | or rd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 1010 | xor rd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 1011 | andc rd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 1100 | reserved
| 1100 0000 dddd aaaa bbbb pppp 0000 1101 | reserved
| 1100 0000 dddd aaaa bbbb pppp 0000 1110 | reserved
| 1100 0000 dddd aaaa bbbb pppp 0000 1111 | reserved

| 1100 0000 dddd iiii iiii 0111 1111 1100 | read rd, csr[imm]
| 1100 0000 dddd iiii iiii 0111 1111 1101 | write rd, csr[imm]
| 1100 0000 dddd iiii iiii 0111 1111 1110 | reserved
| 1100 0000 dddd iiii iiii 0111 1111 1111 | reserved

| 1100 0001 dddd aaaa iiii iiii iiii 0000 | add rd, ra, simm
| 1100 0001 dddd aaaa iiii iiii iiii 0001 | reserved
| 1100 0001 dddd aaaa iiii iiii iiii 0010 | reserved
| 1100 0001 dddd aaaa iiii iiii iiii 0011 | reserved
| 1100 0001 dddd aaaa iiii iiii iiii 0100 | and rd, ra, simm
| 1100 0001 dddd aaaa iiii iiii iiii 0101 | or rd, ra, simm
| 1100 0001 dddd aaaa iiii iiii iiii 0110 | xor rd, ra, simm
| 1100 0001 dddd aaaa iiii iiii iiii 1000 | eq pd, ra, simm
| 1100 0001 dddd aaaa iiii iiii iiii 1001 | lt.s pd, ra, simm
| 1100 0001 dddd aaaa iiii iiii iiii 1010 | lt.u pd, ra, simm
| 1100 0001 dddd aaaa iiii iiii iiii 1011 | gt.s pd, ra, simm
| 1100 0001 dddd aaaa iiii iiii iiii 1100 | gt.u pd, ra, simm
| 1100 0001 dddd aaaa iiii iiii iiii 1101 | reserved
| 1100 0001 dddd aaaa iiii iiii iiii 1110 | reserved
| 1100 0001 dddd aaaa iiii iiii iiii 1111 | reserved
| 1100 0010 bbnn nnnn iiii iiii iiii iiii | block (b = branch count, n = instruction word count - 1), t0 = block + simm << 1
| 1100 0011 0ddd iiii iiii iiii iiii iiii | target td, block + simm << 1
| 1100 0011 1ddd iiii iiii iiii iiii iiii | reserved
| 1100 0100 dddd 0000 iiii iiii iiii iiii | reserved
| 1100 0100 dddd 0001 iiii iiii iiii iiii | set rd, simm
| 1100 0100 dddd 0010 iiii iiii iiii iiii | reserved
| 1100 0100 dddd 0011 iiii iiii iiii iiii | reserved
| 1100 0100 dddd 0100 iiii iiii iiii iiii | reserved
| 1100 0100 dddd 0101 iiii iiii iiii iiii | reserved
| 1100 0100 dddd 0110 iiii iiii iiii iiii | reserved
| 1100 0100 dddd 0111 iiii iiii iiii iiii | reserved
| 1100 0100 dddd 1000 iiii iiii iiii iiii | reserved
| 1100 0100 dddd 1001 iiii iiii iiii iiii | reserved
| 1100 0100 dddd 1010 iiii iiii iiii iiii | reserved
| 1100 0100 dddd 1011 iiii iiii iiii iiii | reserved
| 1100 0100 dddd 1100 iiii iiii iiii iiii | reserved
| 1100 0100 dddd 1101 iiii iiii iiii iiii | reserved
| 1100 0100 dddd 1110 iiii iiii iiii iiii | reserved
| 1100 0100 dddd 1111 iiii iiii iiii iiii | reserved
