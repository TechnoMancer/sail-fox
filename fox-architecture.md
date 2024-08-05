# Fox ISA version n #

The design is meant to primarily be a 16-bit ISA for a fantasy console or something like a PDP-11, but one that can in theory be extended to 32/64 bits and can have capabilities retrofitted to it.

I also want to long-term sneak in floating-point support.

## Registers ##

- 16 registers, r0 - r15
- 8 predicates, p0 - p7 (the 4th bit in the encoding is a "not" bit, p7 is always true, !p7 is reserved)
- 8 target registers, t0 - t7 (t7 is the link register)
- block-address

## Single-word ISA ##

Note: I am not sure if reserving half or a quarter of the instruction space for longer instructions makes more sense?
Note: I want to retrofit a stack to this design, or possibly one stack for return addresses and one for data.
Note: Is adding a 3-operand add/sub here worth it? It costs one eight of the entire encoding space.

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
| 0000 1110 dddd aaaa | reserved
| 0000 1111 dddd aaaa | reserved
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
| 0001 1111 xxxx xxxx | reserved
| 0010 0000 dddd iiii | set rd, imm + 1
| 0010 0001 dddd iiii | set rd, -(imm + 1)
| 0010 0010 dddd iiii | inc rd, imm + 1
| 0010 0011 dddd iiii | dec rd, imm + 1
| 0010 0100 dddd iiii | inc rd, imm + 1 if p0
| 0010 0101 dddd iiii | dec rd, imm + 1 if p0
| 0010 0110 dddd iiii | inc rd, imm + 1 unless p0
| 0010 0111 dddd iiii | dec rd, imm + 1 unless p0
| 0010 1000 dddd iiii | shl rd, imm + 1
| 0010 1001 dddd iiii | shr.a rd, imm + 1
| 0010 1010 dddd iiii | shr.l rd, imm + 1
| 0010 1100 dddd iiii | ror rd, imm + 1
| 0010 1101 xxxx xxxx | reserved
| 0010 1110 xxxx xxxx | reserved
| 0010 1111 bbnn nnnn | block (b = branch count, n = instruction word count)
| 0011 0000 xxxx xxxx | reserved
| 0011 0001 xxxx xxxx | reserved
| 0011 0010 xxxx xxxx | reserved
| 0011 0011 xxxx xxxx | reserved
| 0011 0100 xxxx xxxx | reserved
| 0011 0101 xxxx xxxx | reserved
| 0011 0110 xxxx xxxx | reserved
| 0011 0111 xxxx xxxx | reserved
| 0011 1000 xxxx xxxx | reserved
| 0011 1001 xxxx xxxx | reserved
| 0011 1010 xxxx xxxx | reserved
| 0011 1011 xxxx xxxx | reserved
| 0011 1100 xxxx xxxx | reserved
| 0011 1101 xxxx xxxx | reserved
| 0011 1110 xxxx xxxx | reserved
| 0011 1111 xxxx xxxx | reserved
| 0100 dddd aaaa iiii | load rd, ra[imm]
| 0101 dddd aaaa iiii | store rd, ra[imm]
| 0110 dddd aaaa bbbb | load rd, ra[rb]
| 0111 dddd aaaa bbbb | store rd, ra[rb]

## Double-word ISA ##

Note: We assume here that only a quarter of the instruction space is reserved for double-word or longer instructions, renumber them to 10 if this is not true in the future.
Note: We can probably make a CPU that is useful without supporting any of these since they are somewhat synthesisable.

| 1100 0000 dddd aaaa bbbb pppp 0000 0000 | eq pd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 0001 | gt.s pd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 0010 | gt.u pd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 0011 | reserved
| 1100 0000 dddd aaaa bbbb pppp 0000 0100 | add rd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 0101 | sub rd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 0110 | reserved
| 1100 0000 dddd aaaa bbbb pppp 0000 0111 | reserved
| 1100 0000 dddd aaaa bbbb pppp 0000 1000 | and rd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 1001 | or rd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 1010 | xor rd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 1011 | andc rd, ra, rb (predicated)
| 1100 0000 dddd aaaa bbbb pppp 0000 1100 | reserved
| 1100 0000 dddd aaaa bbbb pppp 0000 1101 | reserved
| 1100 0000 dddd aaaa bbbb pppp 0000 1110 | reserved
| 1100 0000 dddd aaaa bbbb pppp 0000 1111 | reserved

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
| 1100 0001 dddd aaaa iiii iiii iiii 1011 | reserved
| 1100 0001 dddd aaaa iiii iiii iiii 1100 | reserved
| 1100 0001 dddd aaaa iiii iiii iiii 1101 | reserved
| 1100 0001 dddd aaaa iiii iiii iiii 1110 | reserved
| 1100 0001 dddd aaaa iiii iiii iiii 1111 | reserved
| 1100 0010 bbnn nnnn iiii iiii iiii iiii | block (b = branch count, n = instruction word count), t1 = block + simm << 1
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


