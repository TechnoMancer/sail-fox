val code_word : word <-> (ast, instruction_predicate)
scattered mapping code_word

/* Bidirectional Mapping */

mapping clause code_word = 0b0000 @ 0b0000 @ 0b0000 @ 0b0000 <-> (UNALLOCATED(0b0000 @ 0b0000 @ 0b0000 @ 0b0000), always)
mapping clause code_word = 0b0000 @ 0b0000 @ 0b0000 @ 0b0001 <-> (HALT(), always)
mapping clause code_word = 0b0000 @ 0b0000 @ 0b0000 @ x : bits(4) <-> (UNALLOCATED(0b0000 @ 0b0000 @ 0b0000 @ x), always)
mapping clause code_word = 0b0000 @ 0b0000 @ 0b0001 @ 0b0000 <-> (NOP(), always)
mapping clause code_word = 0b0000 @ 0b0000 @ 0b0001 @ x : bits(4) <-> (HINT(x), always)

/* 
| add sp, imm             | 0000 0000 0010 iiii |                     |        |
| sub sp, imm             | 0000 0000 0011 iiii |                     |        |
| reserved                | 0000 0000 01xx xxxx |                     |        |
| reserved                | 0000 0000 1xxx xxxx |                     |        |
*/
mapping clause code_word = 0b0000 @ 0b0000 @ x : bits(8)     <-> (UNALLOCATED(0b0000 @ 0b0000 @ x), always)

mapping clause code_word = 0b0000 @ 0b0001 @ imm             <-> (BRANCH_S(imm), always)
mapping clause code_word = 0b0000 @ 0b001 @ expected @ imm   <-> (BRANCH_S(imm), (0b0000, expected))
mapping clause code_word = 0b0000 @ 0b0100 @ seq @ l0 @ imm  <-> (BLOCK_S(seq, l0, imm), always)
mapping clause code_word = 0b0000 @ 0b0101 @ imm             <-> (BRANCHL_S(imm), always)
mapping clause code_word = 0b0000 @ 0b011 @ expected @ imm   <-> (BRANCHL_S(imm), (0b0000, expected))
mapping clause code_word = 0b0001 @ 0b0000 @ imm    @ rd     <-> (ADD_S(rd, imm), always)
mapping clause code_word = 0b0001 @ 0b0001 @ imm    @ rd     <-> (SUB_S(rd, imm), always)
mapping clause code_word = 0b0001 @ 0b0010 @ imm    @ rd     <-> (AND_S(rd, imm), always)
mapping clause code_word = 0b0001 @ 0b0011 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0011 @ x), always)
mapping clause code_word = 0b0001 @ 0b0100 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0100 @ x), always)
mapping clause code_word = 0b0001 @ 0b0101 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0101 @ x), always)
mapping clause code_word = 0b0001 @ 0b0110 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0110 @ x), always)
mapping clause code_word = 0b0001 @ 0b0111 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0111 @ x), always)

/*
| sl rd, imm              | 0001 1000 iiii dddd |                     | FOX-1  |
| sra rd, imm             | 0001 1001 iiii dddd |                     | FOX-1  |
| srl rd, imm             | 0001 1010 iiii dddd |                     | FOX-1  |
*/
mapping clause code_word = 0b0001 @ 0b1000 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1000 @ x), always)
mapping clause code_word = 0b0001 @ 0b1001 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1001 @ x), always)
mapping clause code_word = 0b0001 @ 0b1010 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1010 @ x), always)

mapping clause code_word = 0b0001 @ 0b1011 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1011 @ x), always)
mapping clause code_word = 0b0001 @ 0b1100 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1100 @ x), always)
mapping clause code_word = 0b0001 @ 0b1101 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1101 @ x), always)

/*
| mov sr[imm], rd         | 0001 1110 iiii dddd |                     | FOX-1  |
| mov rd, sr[imm]         | 0001 1111 iiii dddd |                     | FOX-1  |
*/
mapping clause code_word = 0b0001 @ 0b1110 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1110 @ x), always)
mapping clause code_word = 0b0001 @ 0b1111 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1111 @ x), always)

mapping clause code_word = 0b0010 @ 0b0000 @     ra @     rd <-> (MOV(rd, ra), always)

/*
| mov cd, ca              | 0010 0001 aaaa dddd |                     |        |
*/
mapping clause code_word = 0b0010 @ 0b0001 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b0001 @ x), always)

mapping clause code_word = 0b0010 @ 0b0010 @     pa @     pd <-> (MOVP(pd, pa), always)
mapping clause code_word = 0b0010 @ 0b0011 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b0100 @ x), always)
mapping clause code_word = forwards 0b0010 @ 0b0100 @ ra : register_index @ rd : register_index => (ADD(rd, rd, ra), always)
mapping clause code_word = forwards 0b0010 @ 0b0101 @ ra : register_index @ rd : register_index => (SUB(rd, rd, ra), always)
mapping clause code_word = 0b0010 @ 0b0110 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b0110 @ x), always)
mapping clause code_word = 0b0010 @ 0b0111 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b0111 @ x), always)
mapping clause code_word = forwards 0b0010 @ 0b1000 @ ra : register_index @ rd : register_index => (AND(rd, rd, ra), always)
mapping clause code_word = forwards 0b0010 @ 0b1001 @ ra : register_index @ rd : register_index => (ANDC(rd, rd, ra), always)
mapping clause code_word = forwards 0b0010 @ 0b1010 @ ra : register_index @ rd : register_index => (OR(rd, rd, ra), always)
mapping clause code_word = forwards 0b0010 @ 0b1011 @ ra : register_index @ rd : register_index => (XOR(rd, rd, ra), always)

/*
| lt p0, rd, ra           | 0010 1100 aaaa dddd |                     |        |
| lte p0, rd, ra          | 0010 1101 aaaa dddd |                     |        |
| lt.u p0, rd, ra         | 0010 1110 aaaa dddd |                     |        |
| lte.u p0, rd, ra        | 0010 1111 aaaa dddd |                     |        |
*/
mapping clause code_word = 0b0010 @ 0b1100 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b1100 @ x), always)
mapping clause code_word = 0b0010 @ 0b1101 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b1101 @ x), always)
mapping clause code_word = 0b0010 @ 0b1110 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b1110 @ x), always)
mapping clause code_word = 0b0010 @ 0b1110 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b1110 @ x), always)

/*
| eq p0, rd, ra           | 0011 0000 aaaa dddd |                     |        |
| neq p0, rd, ra          | 0011 0001 aaaa dddd |                     |        |
*/
mapping clause code_word = 0b0011 @ 0b0000 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0000 @ x), always)
mapping clause code_word = 0b0011 @ 0b0001 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0001 @ x), always)

mapping clause code_word = 0b0011 @ 0b0010 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0010 @ x), always)
mapping clause code_word = 0b0011 @ 0b0011 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0011 @ x), always)
mapping clause code_word = 0b0011 @ 0b0100 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0100 @ x), always)

/*
| add.c rd, ra, p1        | 0011 0101 aaaa dddd |                     | FOX-1  |
| sub.c rd, ra, p1        | 0011 0110 aaaa dddd |                     | FOX-1  |
*/
mapping clause code_word = 0b0011 @ 0b0101 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0101 @ x), always)
mapping clause code_word = 0b0011 @ 0b0110 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0110 @ x), always)

mapping clause code_word = 0b0011 @ 0b0111 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0111 @ x), always)
mapping clause code_word = 0b0011 @ 0b1000 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1000 @ x), always)
mapping clause code_word = 0b0011 @ 0b1001 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1001 @ x), always)
mapping clause code_word = 0b0011 @ 0b1010 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1010 @ x), always)
mapping clause code_word = 0b0011 @ 0b1011 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1011 @ x), always)
mapping clause code_word = 0b0011 @ 0b1100 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1100 @ x), always)
mapping clause code_word = 0b0011 @ 0b1101 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1101 @ x), always)
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0000 @ rd     <-> (EQ_Z(0b0000, rd), always)
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0001 @ rd     <-> (NEQ_Z(0b0000, rd), always)

/*
| eq rd, 0 unless p0      | 0011 1110 0010 dddd |                     |        |
| neq rd, 0 unless p0     | 0011 1110 0011 dddd |                     |        |
| eq rd, 0 if p0          | 0011 1110 0100 dddd |                     |        |
| neq rd, 0 if p0         | 0011 1110 0101 dddd |                     |        |
| lt rd, 0                | 0011 1110 0110 dddd |                     | FOX-1  |
| gt rd, 0                | 0011 1110 0111 dddd |                     | FOX-1  |
| lt rd, 0 unless p0      | 0011 1110 1000 dddd |                     |        |
| gt rd, 0 unless p0      | 0011 1110 1001 dddd |                     |        |
| lt rd, 0 if p0          | 0011 1110 1010 dddd |                     |        |
| gt rd, 0 if p0          | 0011 1110 1011 dddd |                     |        |
*/
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0010 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0010 @ x), always)
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0011 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0011 @ x), always)
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0100 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0100 @ x), always)
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0101 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0101 @ x), always)
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0110 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0110 @ x), always)
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0111 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0111 @ x), always)
mapping clause code_word = 0b0011 @ 0b1110 @ 0b1000 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1000 @ x), always)
mapping clause code_word = 0b0011 @ 0b1110 @ 0b1001 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1001 @ x), always)
mapping clause code_word = 0b0011 @ 0b1110 @ 0b1010 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1010 @ x), always)
mapping clause code_word = 0b0011 @ 0b1110 @ 0b1011 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1011 @ x), always)

mapping clause code_word = 0b0011 @ 0b1110 @ 0b1100 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1100 @ x), always)
mapping clause code_word = 0b0011 @ 0b1110 @ 0b1101 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1101 @ x), always)

/*
| set.p pd, 0             | 0011 1110 1110 dddd |                     | FOX-1  |
| set.p pd, 1             | 0011 1110 1111 dddd |                     | FOX-1  |
*/
mapping clause code_word = 0b0011 @ 0b1110 @ 0b1110 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1110 @ x), always)
mapping clause code_word = 0b0011 @ 0b1110 @ 0b1111 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1111 @ x), always)

/*
| return predicated(d)    | 0011 1111 0000 dddd |                     |        |
| blr rd                  | 0011 1111 0001 dddd |                     | FOX-1  |
| blr rd unless p0        | 0011 1111 0010 dddd |                     | FOX-1  |
| blr rd if p0            | 0011 1111 0011 dddd |                     | FOX-1  |
| b lr predicated(d)      | 0011 1111 0100 dddd |                     |        |
| b rd                    | 0011 1111 0101 dddd |                     | FOX-1  |
| b rd unless p0          | 0011 1111 0110 dddd |                     | FOX-1  |
| b rd if p0              | 0011 1111 0111 dddd |                     | FOX-1  |
| not rd                  | 0011 1111 1000 dddd |                     | FOX-1  |
| neg rd                  | 0011 1111 1001 dddd |                     | FOX-1  |
| reserved                | 0011 1111 1010 dddd |                     |        |
| reserved                | 0011 1111 1011 dddd |                     |        |
| set.b rd, 0             | 0011 1111 1100 dddd |                     |        |
| set.w rd, 0             | 0011 1111 1101 dddd |                     | FOX-1  |
| set.d rd, 0             | 0011 1111 1110 dddd |                     |        |
| set.q rd, 0             | 0011 1111 1111 dddd |                     |        |
*/
mapping clause code_word = 0b0011 @ 0b1111 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1110 @ x), always)

/* Backwards Mapping */

mapping clause code_word = backwards (ADD(rd, ra, rb), always) if ra == rd  => 0b0010 @ 0b0100 @ rb @ rd
mapping clause code_word = backwards (SUB(rd, ra, rb), always) if ra == rd  => 0b0010 @ 0b0101 @ rb @ rd
mapping clause code_word = backwards (AND(rd, ra, rb), always) if ra == rd  => 0b0010 @ 0b1000 @ rb @ rd
mapping clause code_word = backwards (ANDC(rd, ra, rb), always) if ra == rd => 0b0010 @ 0b1001 @ rb @ rd
mapping clause code_word = backwards (OR(rd, ra, rb), always) if ra == rd   => 0b0010 @ 0b1010 @ rb @ rd
mapping clause code_word = backwards (XOR(rd, ra, rb), always) if ra == rd  => 0b0010 @ 0b1011 @ rb @ rd

end code_word
