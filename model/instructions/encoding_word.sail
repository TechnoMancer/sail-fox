val code_word : word <-> (ast, option(instruction_predicate))
scattered mapping code_word

/* Bidirectional Mapping */

mapping clause code_word = 0b0000 @ 0b0000 @ 0b0000 @ 0b0000 <-> (UNALLOCATED(0b0000 @ 0b0000 @ 0b0000 @ 0b0000), None())

//| 0000 1111 0000 0000 | temporary halt.
mapping clause code_word = 0b0000 @ 0b1111 @ 0b0000 @ 0b0000 <-> (HALT(), None())

//| 0001 0000 dddd aaaa | and rd, ra
mapping clause code_word = forwards 0b0001 @ 0b0000 @ rd : register_index @ ra : register_index => (AND(rd, rd, ra), None())
//| 0001 0001 dddd aaaa | or rd, ra
mapping clause code_word = forwards 0b0001 @ 0b0001 @ rd : register_index @ ra : register_index => (OR(rd, rd, ra), None())
//| 0001 0010 dddd aaaa | xor rd, ra
mapping clause code_word = forwards 0b0001 @ 0b0010 @ rd : register_index @ ra : register_index => (XOR(rd, rd, ra), None())
//| 0001 0011 dddd aaaa | andc rd, ra
mapping clause code_word = forwards 0b0001 @ 0b0011 @ rd : register_index @ ra : register_index => (ANDC(rd, rd, ra), None())

//| 0010 1111 bbnn nnnn | block (b = branch count, n = instruction word count - 1)
mapping clause code_word = 0b0010 @ 0b1111 @ b : block_branch_count @ n : block_length  <-> (BLOCK(b, n, None()), None())

mapping clause code_word = 0b0000 @ 0b0000 @ 0b0000 @ x : bits(4) <-> (UNALLOCATED(0b0000 @ 0b0000 @ 0b0000 @ x), None())
mapping clause code_word = 0b0000 @ 0b0000 @ 0b0001 @ 0b0000 <-> (NOP(), None())
mapping clause code_word = 0b0000 @ 0b0000 @ 0b0001 @ x : bits(4) <-> (HINT(x), None())

/* 
| add sp, imm             | 0000 0000 0010 iiii |                     |        |
| sub sp, imm             | 0000 0000 0011 iiii |                     |        |
| reserved                | 0000 0000 01xx xxxx |                     |        |
| reserved                | 0000 0000 1xxx xxxx |                     |        |
*/
mapping clause code_word = 0b0000 @ 0b0000 @ x : bits(8)     <-> (UNALLOCATED(0b0000 @ 0b0000 @ x), None())

mapping clause code_word = 0b0000 @ 0b0001 @ imm             <-> (BRANCH_S(imm), None())
mapping clause code_word = 0b0000 @ 0b001 @ expected : bits(1) @ imm   <-> (BRANCH_S(imm), Some(0b0000, expected))

mapping clause code_word = 0b0000 @ 0b0101 @ imm             <-> (BRANCHL_S(imm), None())
mapping clause code_word = 0b0000 @ 0b011 @ expected :bits(1) @ imm   <-> (BRANCHL_S(imm), Some(0b0000, expected))
mapping clause code_word = 0b0001 @ 0b0000 @ imm    @ rd     <-> (ADD_S(rd, imm), None())
mapping clause code_word = 0b0001 @ 0b0001 @ imm    @ rd     <-> (SUB_S(rd, imm), None())
mapping clause code_word = 0b0001 @ 0b0010 @ imm    @ rd     <-> (AND_S(rd, imm), None())
mapping clause code_word = 0b0001 @ 0b0011 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0011 @ x), None())
mapping clause code_word = 0b0001 @ 0b0100 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0100 @ x), None())
mapping clause code_word = 0b0001 @ 0b0101 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0101 @ x), None())
mapping clause code_word = 0b0001 @ 0b0110 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0110 @ x), None())
mapping clause code_word = 0b0001 @ 0b0111 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0111 @ x), None())

/*
| sl rd, imm              | 0001 1000 iiii dddd |                     | FOX-1  |
| sra rd, imm             | 0001 1001 iiii dddd |                     | FOX-1  |
| srl rd, imm             | 0001 1010 iiii dddd |                     | FOX-1  |
*/
mapping clause code_word = 0b0001 @ 0b1000 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1000 @ x), None())
mapping clause code_word = 0b0001 @ 0b1001 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1001 @ x), None())
mapping clause code_word = 0b0001 @ 0b1010 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1010 @ x), None())

mapping clause code_word = 0b0001 @ 0b1011 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1011 @ x), None())
mapping clause code_word = 0b0001 @ 0b1100 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1100 @ x), None())
mapping clause code_word = 0b0001 @ 0b1101 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1101 @ x), None())

/*
| mov sr[imm], rd         | 0001 1110 iiii dddd |                     | FOX-1  |
| mov rd, sr[imm]         | 0001 1111 iiii dddd |                     | FOX-1  |
*/
mapping clause code_word = 0b0001 @ 0b1110 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1110 @ x), None())
mapping clause code_word = 0b0001 @ 0b1111 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1111 @ x), None())

mapping clause code_word = 0b0010 @ 0b0000 @     ra @     rd <-> (MOV(rd, ra), None())

/*
| mov cd, ca              | 0010 0001 aaaa dddd |                     |        |
*/
mapping clause code_word = 0b0010 @ 0b0001 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b0001 @ x), None())

mapping clause code_word = 0b0010 @ 0b0010 @     pa @     pd <-> (MOVP(pd, pa), None())
mapping clause code_word = 0b0010 @ 0b0011 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b0100 @ x), None())
mapping clause code_word = forwards 0b0010 @ 0b0100 @ ra : register_index @ rd : register_index => (ADD(rd, rd, ra), None())
mapping clause code_word = forwards 0b0010 @ 0b0101 @ ra : register_index @ rd : register_index => (SUB(rd, rd, ra), None())
mapping clause code_word = 0b0010 @ 0b0110 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b0110 @ x), None())
mapping clause code_word = 0b0010 @ 0b0111 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b0111 @ x), None())

/*
| lt p0, rd, ra           | 0010 1100 aaaa dddd |                     |        |
| lte p0, rd, ra          | 0010 1101 aaaa dddd |                     |        |
| lt.u p0, rd, ra         | 0010 1110 aaaa dddd |                     |        |
| lte.u p0, rd, ra        | 0010 1111 aaaa dddd |                     |        |
*/
mapping clause code_word = 0b0010 @ 0b1100 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b1100 @ x), None())
mapping clause code_word = 0b0010 @ 0b1101 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b1101 @ x), None())
mapping clause code_word = 0b0010 @ 0b1110 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b1110 @ x), None())
mapping clause code_word = 0b0010 @ 0b1110 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b1110 @ x), None())

/*
| eq p0, rd, ra           | 0011 0000 aaaa dddd |                     |        |
| neq p0, rd, ra          | 0011 0001 aaaa dddd |                     |        |
*/
mapping clause code_word = 0b0011 @ 0b0000 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0000 @ x), None())
mapping clause code_word = 0b0011 @ 0b0001 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0001 @ x), None())

mapping clause code_word = 0b0011 @ 0b0010 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0010 @ x), None())
mapping clause code_word = 0b0011 @ 0b0011 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0011 @ x), None())
mapping clause code_word = 0b0011 @ 0b0100 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0100 @ x), None())

/*
| add.c rd, ra, p1        | 0011 0101 aaaa dddd |                     | FOX-1  |
| sub.c rd, ra, p1        | 0011 0110 aaaa dddd |                     | FOX-1  |
*/
mapping clause code_word = 0b0011 @ 0b0101 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0101 @ x), None())
mapping clause code_word = 0b0011 @ 0b0110 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0110 @ x), None())

mapping clause code_word = 0b0011 @ 0b0111 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0111 @ x), None())
mapping clause code_word = 0b0011 @ 0b1000 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1000 @ x), None())
mapping clause code_word = 0b0011 @ 0b1001 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1001 @ x), None())
mapping clause code_word = 0b0011 @ 0b1010 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1010 @ x), None())
mapping clause code_word = 0b0011 @ 0b1011 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1011 @ x), None())
mapping clause code_word = 0b0011 @ 0b1100 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1100 @ x), None())
mapping clause code_word = 0b0011 @ 0b1101 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1101 @ x), None())
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0000 @ rd     <-> (EQ_Z(0b0000, rd), None())
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0001 @ rd     <-> (NEQ_Z(0b0000, rd), None())

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
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0010 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0010 @ x), None())
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0011 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0011 @ x), None())
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0100 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0100 @ x), None())
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0101 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0101 @ x), None())
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0110 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0110 @ x), None())
mapping clause code_word = 0b0011 @ 0b1110 @ 0b0111 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0111 @ x), None())
mapping clause code_word = 0b0011 @ 0b1110 @ 0b1000 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1000 @ x), None())
mapping clause code_word = 0b0011 @ 0b1110 @ 0b1001 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1001 @ x), None())
mapping clause code_word = 0b0011 @ 0b1110 @ 0b1010 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1010 @ x), None())
mapping clause code_word = 0b0011 @ 0b1110 @ 0b1011 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1011 @ x), None())

mapping clause code_word = 0b0011 @ 0b1110 @ 0b1100 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1100 @ x), None())
mapping clause code_word = 0b0011 @ 0b1110 @ 0b1101 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1101 @ x), None())

/*
| set.p pd, 0             | 0011 1110 1110 dddd |                     | FOX-1  |
| set.p pd, 1             | 0011 1110 1111 dddd |                     | FOX-1  |
*/
mapping clause code_word = 0b0011 @ 0b1110 @ 0b1110 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1110 @ x), None())
mapping clause code_word = 0b0011 @ 0b1110 @ 0b1111 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1111 @ x), None())

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
mapping clause code_word = 0b0011 @ 0b1111 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1110 @ x), None())

/* Backwards Mapping */

//| 0001 0000 dddd aaaa | and rd, ra
mapping clause code_word = backwards (AND(rd, ra, rb), None()) if ra == rd  => 0b0001 @ 0b0000 @ rd @ rb
//| 0001 0001 dddd aaaa | or rd, ra
mapping clause code_word = backwards (OR(rd, ra, rb), None()) if ra == rd   => 0b0001 @ 0b0001 @ rd @ rb
//| 0001 0010 dddd aaaa | xor rd, ra
mapping clause code_word = backwards (XOR(rd, ra, rb), None()) if ra == rd  => 0b0001 @ 0b0010 @ rd @ rb
//| 0001 0011 dddd aaaa | andc rd, ra
mapping clause code_word = backwards (ANDC(rd, ra, rb), None()) if ra == rd => 0b0001 @ 0b0011 @ rd @ rb

mapping clause code_word = backwards (ADD(rd, ra, rb), None()) if ra == rd  => 0b0010 @ 0b0100 @ rb @ rd
mapping clause code_word = backwards (SUB(rd, ra, rb), None()) if ra == rd  => 0b0010 @ 0b0101 @ rb @ rd

end code_word
