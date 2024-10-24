# Fox ISA version n #

The design is meant to primarily be a 16-bit ISA for a fantasy console or something like a PDP-11, but one that can in theory be extended to 32/64 bits and can have capabilities retrofitted to it.

I also want to long-term sneak in floating-point support.


## Registers ##

 - 16 integer registers, `r0` - `r15`
 - 16 capability registers `c0` - `c15`
 - 8 predicates, `p0` - `p7`
 - 8 target registers, `t0` - `t7`
 - 256 system registers, `csr[0]` - `csr[255]`

### Integer Registers ###

There are 16 integer registers named `r0` to `r15`.

 - `r0` to `r7` are used for function arguments / return values
 - `r8` to `r11` are temporaries
 - `r12` to `r17` are callee saved


### Capability Registers ###

There are 16 capability registers named `c0` to `c15`.

 - `c0` to `c7` are used for function arguments / return values
 - `c8` to `c11` are temporaries
 - `c12` to `c17` are callee saved

A capability is stored in a 32-bit register with the following format.

 - Address: a 22 bit double-word address, giving you 24-bits of effective address (16 MB of address space)
 - Length: a 7 bit length, giving the number of words of length of the capability
 - Shift: a 3 bit count of extra number of length bits taken from the address and how many 1-bits should be shifted in from the right. If this is non-zero add an implicit 1-bit in front of the length. This allows a capability to cover the entire address space (1 + 7 + 7 bits length with 2-9 alignment bits)

At bootup `c0` is initialised with a capability that covers the entire valid address space.


### Predicate Registers ###

There are 8 predicate registers named `p0` - `p7`. The negations named `!p0` to `!p6` are also available in the encoding. All the predicate registers are considered temporary, none are callee saved.

`p7` is hardwired to true and therefore has the alternative name `true`, the negation of `p7` is reserved for now.


### Target Registers ###

There are 16 branch target registers named `t0` to `t15` that are used to both compress the encoding for branches, but also to allow the branch predictor to have an easier time. All the target registers are considered temporary, none are callee saved.

 - `t0` to `t3` are used for function arguments / return values
 - `t4` to `t9` are temporary
 - `t10` to `t12` are callee saved
 - `t13` is used as the link register, also named `link`
 - `t14` is the next sequential block after the current one, also named `next`
 - `t15` is the current block, also named `current`


### CSRs ###

The following CSRs are defined, the there are in theory 256 of them but all of the other ones should fail. 

 - `csr[0]` or `status` is a status register. At reset its value is undefined.
 - `csr[1]` or `sp` is the stack pointer. At reset its value is undefined. The stack grows upward.
 - `csr[2]` contains a copy of the predicate registers in the lower 8 bits, the upper 8 bits are reserved for now and should be preserved.


### CSCs ###

The following CSCs are defined, the there are in theory 256 of them but all of the other ones should fail. 

 - `csc[0]` or `pc` is the current program capability which all target registers and instruction fetches are relative to. At reset it contains a capability that covers the entire valid address space.
 - `csc[1]` or `sc` is the current stack capability that stack accesses are relative to. At reset its value is undefined.

## Single-word ISA ##

Note: Is a 3-operand add/sub here worth it? It costs one eight of the entire encoding space, I added a 3-op add for now.
| Extension | Encoding | Operation |
| --- | ------- | --- |
| CORE | 0000 0000 dddd aaaa | mov rd, ra (rd = ra is reserved)
| CORE | 0000 0001 dddd aaaa | not rd, ra
| CORE | 0000 0010 dddd aaaa | neg rd, ra
| CORE | 0000 0011 dddd aaaa | byteswap rd, ra
| CMOV | 0000 0100 dddd aaaa | mov rd, ra if p0 (rd = ra is reserved)
| CMOV | 0000 0101 dddd aaaa | mov rd, ra unless p0 (rd = ra is reserved)
| CORE | 0000 0110 dddd aaaa | mov rd, ta (previously called read)
| CORE | 0000 0111 dddd aaaa | mov td, ra (previously called target)
| CORE | 0000 1000 dddd aaaa | eq p0, rd, ra
| CORE | 0000 1001 dddd aaaa | gt.s p0, rd, ra
| CORE | 0000 1010 dddd aaaa | gt.u p0, rd, ra
| CORE | 0000 1011 dddd pppp | mov pd, ra (pd is set to ra != 0)
| CORE | 0000 1100 dddd aaaa | inc rd, ra
| CORE | 0000 1101 dddd aaaa | dec rd, ra
| CORE | 0000 1110 dddd aaaa | inc.c rd, ra, p1 (carry in/out in p1)
| CORE | 0000 1111 dddd aaaa | dec.c rd, ra, p1 (carry in/out in p1)
| CORE | 0001 0000 dddd aaaa | and rd, ra
| CORE | 0001 0001 dddd aaaa | or rd, ra
| CORE | 0001 0010 dddd aaaa | xor rd, ra
| CORE | 0001 0011 dddd aaaa | andc rd, ra
| CORE | 0001 0100 0ddd aaaa | mov pd, pa
| CORE | 0001 0100 1ddd aaaa | reserved
| CORE | 0001 0101 dddd aaaa | mov td, ta
| CORE | 0001 0110 dddd aaaa | b td if ra == 0
| CORE | 0001 0111 dddd aaaa | b td if ra != 0
| CORE | 0001 1000 dddd pppp | b rd (predicated)
| CORE | 0001 1001 dddd pppp | call td (predicated)
|      | 0001 1010 xxxx xxxx | reserved
|      | 0001 1011 xxxx xxxx | reserved
|      | 0001 1100 xxxx xxxx | reserved
|      | 0001 1101 xxxx xxxx | reserved
|      | 0001 1110 xxxx xxxx | reserved
| SP   | 0001 1111 00ii iiii | allocate imm (sp += imm)
| SP   | 0001 1111 01ii iiii | deallocate imm (sp -= imm)
|      | 0001 1111 10ii iiii | reserved
|      | 0001 1111 11ii iiii | reserved
| CORE | 0010 0000 dddd iiii | set rd, imm + 1
| CORE | 0010 0001 dddd iiii | set rd, -(imm + 1)
| CORE | 0010 0010 dddd iiii | inc rd, imm + 1
| CORE | 0010 0011 dddd iiii | dec rd, imm + 1
| CMOV | 0010 0100 dddd iiii | inc rd, imm + 1 if p0
| CMOV | 0010 0101 dddd iiii | dec rd, imm + 1 if p0
|      | 0010 0110 dddd iiii | reserved
|      | 0010 0111 dddd iiii | reserved
| CORE | 0010 1000 dddd iiii | shl rd, imm + 1
| CORE | 0010 1001 dddd iiii | shr.a rd, imm + 1
| CORE | 0010 1010 dddd iiii | shr.l rd, imm + 1
| CORE | 0010 1011 dddd iiii | ror rd, imm + 1
| SP   | 0010 1100 dddd iiii | load rd, sp[imm]
| SP   | 0010 1101 dddd iiii | store rd, sp[imm]
| CAP  | 0010 1110 dddd iiii | load cd, sp[imm]
| CAP  | 0010 1111 dddd iiii | store cd, sp[imm]
|      | 0011 0000 xxxx xxxx | reserved
|      | 0011 0001 xxxx xxxx | reserved
|      | 0011 0010 xxxx xxxx | reserved
|      | 0011 0011 xxxx xxxx | reserved
|      | 0011 0100 xxxx xxxx | reserved
|      | 0011 0101 xxxx xxxx | reserved
|      | 0011 0110 xxxx xxxx | reserved
|      | 0011 0111 xxxx xxxx | reserved
|      | 0011 1000 xxxx xxxx | reserved
|      | 0011 1001 xxxx xxxx | reserved
|      | 0011 1010 xxxx xxxx | reserved
|      | 0011 1011 xxxx xxxx | reserved
|      | 0011 1100 xxxx xxxx | reserved
|      | 0011 1101 xxxx xxxx | reserved
|      | 0011 1110 xxxx xxxx | reserved
| CORE | 0011 1111 bbnn nnnn | block (b = branch count, n = instruction word count - 1)
| CORE | 0100 iiii dddd aaaa | add rd, ra, rb
|      | 0101 xxxx xxxx xxxx | reserved
|      | 0110 xxxx xxxx xxxx | reserved
|      | 0111 xxxx xxxx xxxx | reserved
| CORE | 1000 iiii dddd aaaa | load rd, ra[imm] (relative to c0)
| CORE | 1001 iiii dddd aaaa | store rd, ra[imm] (relative to c0)
| CAP  | 1010 iiii dddd aaaa | load.c cd, ra[imm] (relative to c0)
| CAP  | 1011 iiii dddd aaaa | store.c cd, ra[imm] (relative to c0)

## Double-word ISA ##

Note: We assume here that only a quarter of the instruction space is reserved for double-word or longer instructions, renumber them to 10 if this is not true in the future.
Note: We can probably make a CPU that is useful without supporting any of these since they are somewhat synthesisable.

| Extension | Encoding | Operation 
| --- | ------- | --- 
| CORE | 1100 0000 dddd aaaa bbbb pppp 0000 0000 | eq pd, ra, rb (predicated)
| CORE | 1100 0000 dddd aaaa bbbb pppp 0000 0001 | gt.s pd, ra, rb (predicated)
| CORE | 1100 0000 dddd aaaa bbbb pppp 0000 0010 | gt.u pd, ra, rb (predicated)
|      | 1100 0000 dddd aaaa bbbb pppp 0000 0011 | reserved
| CORE | 1100 0000 dddd aaaa bbbb pppp 0000 0100 | add rd, ra, rb (predicated)
| CORE | 1100 0000 dddd aaaa bbbb pppp 0000 0101 | sub rd, ra, rb (predicated)
| CORE | 1100 0000 dddd aaaa bbbb pppp 0000 0110 | add.c rd, ra, rb, p1 (predicated, carry in/out in p1)
| CORE | 1100 0000 dddd aaaa bbbb pppp 0000 0111 | sub.c rd, ra, rb, p1 (predicated, carry in/out in p1)
| CORE | 1100 0000 dddd aaaa bbbb pppp 0000 1000 | and rd, ra, rb (predicated)
| CORE | 1100 0000 dddd aaaa bbbb pppp 0000 1001 | or rd, ra, rb (predicated)
| CORE | 1100 0000 dddd aaaa bbbb pppp 0000 1010 | xor rd, ra, rb (predicated)
| CORE | 1100 0000 dddd aaaa bbbb pppp 0000 1011 | andc rd, ra, rb (predicated)
|      | 1100 0000 dddd aaaa bbbb pppp 0000 1100 | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 0000 1101 | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 0000 1110 | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 0000 1111 | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 0001 xxxx | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 0010 xxxx | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 0011 xxxx | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 0100 xxxx | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 0101 xxxx | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 0110 xxxx | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 0111 xxxx | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 1000 xxxx | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 1001 xxxx | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 1010 xxxx | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 1011 xxxx | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 1100 xxxx | reserved
|      | 1100 0000 dddd aaaa bbbb pppp 1101 xxxx | reserved
|      | 1100 0000 dddd iiii iiii pppp 1110 0000 | load.b rd, sp[imm] (predicated)
| CORE | 1100 0000 dddd iiii iiii pppp 1110 0001 | load.w rd, sp[imm] (predicated)
|      | 1100 0000 dddd iiii iiii pppp 1110 0010 | load.d rd, sp[imm] (predicated)
|      | 1100 0000 dddd iiii iiii pppp 1110 0011 | load.q rd, sp[imm] (predicated)
|      | 1100 0000 dddd iiii iiii pppp 1110 0100 | store.b rd, sp[imm] (predicated)
| CORE | 1100 0000 dddd iiii iiii pppp 1110 0101 | store.w rd, sp[imm] (predicated)
|      | 1100 0000 dddd iiii iiii pppp 1110 0110 | store.d rd, sp[imm] (predicated)
|      | 1100 0000 dddd iiii iiii pppp 1110 0111 | store.q rd, sp[imm] (predicated)
|      | 1100 0000 dddd iiii iiii pppp 1110 1000 | load.c rd, sp[imm] (predicated)
|      | 1100 0000 dddd iiii iiii pppp 1110 1001 | store.c rd, sp[imm] (predicated)
|      | 1100 0000 dddd iiii iiii pppp 1110 1010 | reserved
|      | 1100 0000 dddd iiii iiii pppp 1110 1011 | reserved
|      | 1100 0000 dddd iiii iiii pppp 1110 1100 | reserved
|      | 1100 0000 dddd iiii iiii pppp 1110 1101 | reserved
|      | 1100 0000 dddd iiii iiii pppp 1110 1110 | reserved
|      | 1100 0000 dddd iiii iiii pppp 1110 1111 | reserved
|      | 1100 0000 dddd iiii iiii pppp 1111 0000 | reserved
|      | 1100 0000 dddd iiii iiii pppp 1111 0001 | reserved
|      | 1100 0000 dddd iiii iiii pppp 1111 0010 | reserved
|      | 1100 0000 dddd iiii iiii pppp 1111 0011 | reserved
| CORE | 1100 0000 dddd iiii iiii 0111 1111 1100 | read rd, csr[imm]
| CORE | 1100 0000 dddd iiii iiii 0111 1111 1101 | write rd, csr[imm]
| CAP  | 1100 0000 dddd iiii iiii 0111 1111 1110 | read cd, csd[imm]
| CAP  | 1100 0000 dddd iiii iiii 0111 1111 1111 | write cd, csd[imm]
| CORE | 1100 0001 dddd aaaa iiii iiii iiii 0000 | add rd, ra, simm
|      | 1100 0001 dddd aaaa iiii iiii iiii 0001 | reserved
|      | 1100 0001 dddd aaaa iiii iiii iiii 0010 | reserved
|      | 1100 0001 dddd aaaa iiii iiii iiii 0011 | reserved
| CORE | 1100 0001 dddd aaaa iiii iiii iiii 0100 | and rd, ra, simm
| CORE | 1100 0001 dddd aaaa iiii iiii iiii 0101 | or rd, ra, simm
| CORE | 1100 0001 dddd aaaa iiii iiii iiii 0110 | xor rd, ra, simm
| CORE | 1100 0001 dddd aaaa iiii iiii iiii 1000 | eq pd, ra, simm
| CORE | 1100 0001 dddd aaaa iiii iiii iiii 1001 | lt.s pd, ra, simm
| CORE | 1100 0001 dddd aaaa iiii iiii iiii 1010 | lt.u pd, ra, simm
| CORE | 1100 0001 dddd aaaa iiii iiii iiii 1011 | gt.s pd, ra, simm
| CORE | 1100 0001 dddd aaaa iiii iiii iiii 1100 | gt.u pd, ra, simm
|      | 1100 0001 dddd aaaa iiii iiii iiii 1101 | reserved
|      | 1100 0001 dddd aaaa iiii iiii iiii 1110 | reserved
|      | 1100 0001 dddd aaaa iiii iiii iiii 1111 | reserved
|      | 1100 0010 xxxx xxxx xxxx xxxx xxxx xxxx | reserved
|      | 1100 0011 xxxx xxxx xxxx xxxx xxxx xxxx | reserved
|      | 1100 0100 xxxx xxxx xxxx xxxx xxxx xxxx | reserved
|      | 1100 0101 xxxx xxxx xxxx xxxx xxxx xxxx | reserved
|      | 1100 0110 xxxx xxxx xxxx xxxx xxxx xxxx | reserved
|      | 1100 0111 xxxx xxxx xxxx xxxx xxxx xxxx | reserved
|      | 1100 1000 xxxx xxxx xxxx xxxx xxxx xxxx | reserved
|      | 1100 1001 xxxx xxxx xxxx xxxx xxxx xxxx | reserved
|      | 1100 1010 xxxx xxxx xxxx xxxx xxxx xxxx | reserved
|      | 1100 1011 xxxx xxxx xxxx xxxx xxxx xxxx | reserved
|      | 1100 1100 xxxx xxxx xxxx xxxx xxxx xxxx | reserved
| CORE | 1100 1101 bbnn nnnn iiii iiii iiii iiii | block (b = branch count, n = instruction word count - 1), t0 = block + simm << 1
| CORE | 1100 1110 dddd iiii iiii iiii iiii iiii | target td, block + simm << 1
|      | 1100 1111 dddd 0000 iiii iiii iiii iiii | reserved
| CORE | 1100 1111 dddd 0001 iiii iiii iiii iiii | set rd, simm
|      | 1100 1111 dddd 0010 iiii iiii iiii iiii | reserved
|      | 1100 1111 dddd 0011 iiii iiii iiii iiii | reserved
|      | 1100 1111 dddd 0100 iiii iiii iiii iiii | reserved
|      | 1100 1111 dddd 0101 iiii iiii iiii iiii | reserved
|      | 1100 1111 dddd 0110 iiii iiii iiii iiii | reserved
|      | 1100 1111 dddd 0111 iiii iiii iiii iiii | reserved
|      | 1100 1111 dddd 1000 iiii iiii iiii iiii | reserved
|      | 1100 1111 dddd 1001 iiii iiii iiii iiii | reserved
|      | 1100 1111 dddd 1010 iiii iiii iiii iiii | reserved
|      | 1100 1111 dddd 1011 iiii iiii iiii iiii | reserved
|      | 1100 1111 dddd 1100 iiii iiii iiii iiii | reserved
|      | 1100 1111 dddd 1101 iiii iiii iiii iiii | reserved
|      | 1100 1111 dddd 1110 iiii iiii iiii iiii | reserved
|      | 1100 1111 dddd 1111 iiii iiii iiii iiii | reserved
|      | 1101 xxxx xxxx xxxx xxxx xxxx xxxx xxxx | reserved
|      | 1110 0000 dddd aaaa bbbb iiii iiii iiii | load.b rd, ca[rb + imm]
| CAP  | 1110 0001 dddd aaaa bbbb iiii iiii iiii | load.w rd, ca[rb + imm]
|      | 1110 0010 dddd aaaa bbbb iiii iiii iiii | load.d rd, ca[rb + imm]
|      | 1110 0011 dddd aaaa bbbb iiii iiii iiii | load.q rd, ca[rb + imm]
|      | 1110 0100 dddd aaaa bbbb iiii iiii iiii | store.b rd, ca[rb + imm]
| CAP  | 1110 0101 dddd aaaa bbbb iiii iiii iiii | store.w rd, ca[rb + imm]
|      | 1110 0110 dddd aaaa bbbb iiii iiii iiii | store.d rd, ca[rb + imm]
|      | 1110 0111 dddd aaaa bbbb iiii iiii iiii | store.q rd, ca[rb + imm]
|      | 1110 1000 dddd aaaa bbbb iiii iiii iiii | load.c cd, ca[rb + imm]
|      | 1110 1001 dddd aaaa bbbb iiii iiii iiii | store.c cd, ca[rb + imm]
|      | 1110 1000 dddd aaaa bbbb iiii iiii iiii | reserved
|      | 1110 1001 dddd aaaa bbbb iiii iiii iiii | reserved
|      | 1110 1010 dddd aaaa bbbb iiii iiii iiii | reserved
|      | 1110 1100 dddd aaaa bbbb iiii iiii iiii | reserved
|      | 1110 1101 dddd aaaa bbbb iiii iiii iiii | reserved
|      | 1110 1110 dddd aaaa bbbb iiii iiii iiii | reserved
|      | 1110 1111 dddd aaaa 0000 iiii iiii iiii | load.b rd, ca[imm]
| CAP  | 1110 1111 dddd aaaa 0001 iiii iiii iiii | load.w rd, ca[imm]
|      | 1110 1111 dddd aaaa 0010 iiii iiii iiii | load.d rd, ca[imm]
|      | 1110 1111 dddd aaaa 0011 iiii iiii iiii | load.q rd, ca[imm]
|      | 1110 1111 dddd aaaa 0100 iiii iiii iiii | store.b rd, ca[imm]
| CAP  | 1110 1111 dddd aaaa 0101 iiii iiii iiii | store.w rd, ca[imm]
|      | 1110 1111 dddd aaaa 0110 iiii iiii iiii | store.d rd, ca[imm]
|      | 1110 1111 dddd aaaa 0111 iiii iiii iiii | store.q rd, ca[imm]
| CAP  | 1110 1111 dddd aaaa 1000 iiii iiii iiii | load.c cd, ca[imm]
| CAP  | 1110 1111 dddd aaaa 1001 iiii iiii iiii | store.c cd, ca[imm]
|      | 1110 1111 dddd aaaa 1010 iiii iiii iiii | reserved
|      | 1110 1111 dddd aaaa 1011 iiii iiii iiii | reserved
|      | 1110 1111 dddd aaaa 1100 iiii iiii iiii | reserved
|      | 1110 1111 dddd aaaa 1101 iiii iiii iiii | reserved
|      | 1110 1111 dddd aaaa 1110 iiii iiii iiii | reserved
|      | 1110 1111 dddd aaaa 1111 iiii iiii iiii | reserved
