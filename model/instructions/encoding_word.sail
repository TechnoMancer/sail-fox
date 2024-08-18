val instruction_length : bits(3) -> instructionLength
function instruction_length (prefix) = {
    match (prefix) {
        0b0 @ _ => SINGLE_WORD,
        0b11 @ _ => DOUBLE_WORD,
        _ => NOT_ALLOCATED,
    }
}

val code_single_word : word <-> (ast, option(instruction_predicate))
scattered mapping code_single_word

/* Bidirectional Mapping */

mapping clause code_single_word = 0b0000 @ 0b0000 @ 0b0000 @ 0b0000 <-> (UNALLOCATED(0b0000 @ 0b0000 @ 0b0000 @ 0b0000), Some(Always()))

//| 0000 0000 dddd aaaa | mov rd, ra (rd = ra is reserved)
mapping clause code_single_word = forwards 0b0000 @ 0b0000 @ rd : register_index @ ra : register_index if ra != rd => (MOV(rd, ra), Some(Always()))

// | 0000 0001 dddd aaaa | not rd, ra
mapping clause code_single_word = 0b0000 @ 0b0001 @ rd : register_index @ ra : register_index <-> (NOT(rd, ra), Some(Always()))
// | 0000 0010 dddd aaaa | neg rd, ra
mapping clause code_single_word = 0b0000 @ 0b0010 @ rd : register_index @ ra : register_index <-> (NEG(rd, ra), Some(Always()))
// | 0000 0011 dddd aaaa | byteswap rd, ra
mapping clause code_single_word = 0b0000 @ 0b0011 @ rd : register_index @ ra : register_index <-> (BSWAP(rd, ra), Some(Always()))

//| 0000 0111 0ddd aaaa | b td if ra == 0
mapping clause code_single_word = 0b0000 @ 0b0111 @ 0b0 @ td : target_index @ ra : register_index <-> (BRANCH_Z(td, ra, false), Some(Always()))
//| 0000 0111 1ddd aaaa | b td if ra != 0
mapping clause code_single_word = 0b0000 @ 0b0111 @ 0b1 @ td : target_index @ ra : register_index <-> (BRANCH_Z(td, ra, true), Some(Always()))

//| 0000 1011 0ddd pppp | b td (predicated)
mapping clause code_single_word = 0b0000 @ 0b1011 @ 0b0 @ td : target_index @ p : predicate_encoding <-> (BRANCH(td), predicate_decode(p))
//| 0000 1011 1ddd pppp | call td (predicated)
mapping clause code_single_word = 0b0000 @ 0b1011 @ 0b1 @ td : target_index @ p : predicate_encoding <-> (BRANCHL(td), predicate_decode(p))

//| 0000 1100 dddd aaaa | inc rd, ra
mapping clause code_single_word = forwards 0b0000 @ 0b1100 @ rd : register_index @ ra : register_index => (ADD(rd, rd, ra), Some(Always()))
//| 0000 1101 dddd aaaa | dec rd, ra
mapping clause code_single_word = forwards 0b0000 @ 0b1101 @ rd : register_index @ ra : register_index => (SUB(rd, rd, ra), Some(Always()))

//| 0000 1111 0000 0000 | temporary halt.
mapping clause code_single_word = 0b0000 @ 0b1111 @ 0b0000 @ 0b0000 <-> (HALT(), Some(Always()))

//| 0001 0000 dddd aaaa | and rd, ra
mapping clause code_single_word = forwards 0b0001 @ 0b0000 @ rd : register_index @ ra : register_index => (AND(rd, rd, ra), Some(Always()))
//| 0001 0001 dddd aaaa | or rd, ra
mapping clause code_single_word = forwards 0b0001 @ 0b0001 @ rd : register_index @ ra : register_index => (OR(rd, rd, ra), Some(Always()))
//| 0001 0010 dddd aaaa | xor rd, ra
mapping clause code_single_word = forwards 0b0001 @ 0b0010 @ rd : register_index @ ra : register_index => (XOR(rd, rd, ra), Some(Always()))
//| 0001 0011 dddd aaaa | andc rd, ra
mapping clause code_single_word = forwards 0b0001 @ 0b0011 @ rd : register_index @ ra : register_index => (ANDC(rd, rd, ra), Some(Always()))

//| 0010 0000 dddd iiii | set rd, imm + 1
//| 0010 0001 dddd iiii | set rd, -(imm + 1)
mapping clause code_single_word = 0b0010 @ 0b000 @ sign @ rd @     imm <-> (SET_S(rd, imm, sign), Some(Always()))

//| 0011 1111 bbnn nnnn | block (b = branch count, n = instruction word count - 1)
mapping clause code_single_word = 0b0011 @ 0b1111 @ b : block_branch_count @ n : block_length  <-> (BLOCK(b, n, None()), Some(Always()))

mapping clause code_single_word = 0b0000 @ 0b0000 @ 0b0000 @ x : bits(4) <-> (UNALLOCATED(0b0000 @ 0b0000 @ 0b0000 @ x), Some(Always()))
mapping clause code_single_word = 0b0000 @ 0b0000 @ 0b0001 @ x : bits(4) <-> (HINT(x), Some(Always()))

/* 
| add sp, imm             | 0000 0000 0010 iiii |                     |        |
| sub sp, imm             | 0000 0000 0011 iiii |                     |        |
| reserved                | 0000 0000 01xx xxxx |                     |        |
| reserved                | 0000 0000 1xxx xxxx |                     |        |
*/
mapping clause code_single_word = 0b0000 @ 0b0000 @ x : bits(8)     <-> (UNALLOCATED(0b0000 @ 0b0000 @ x), Some(Always()))

mapping clause code_single_word = 0b0001 @ 0b0000 @ imm    @ rd     <-> (ADD_S(rd, imm), Some(Always()))
mapping clause code_single_word = 0b0001 @ 0b0001 @ imm    @ rd     <-> (SUB_S(rd, imm), Some(Always()))
mapping clause code_single_word = 0b0001 @ 0b0010 @ imm    @ rd     <-> (AND_S(rd, imm), Some(Always()))
mapping clause code_single_word = 0b0001 @ 0b0011 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0011 @ x), Some(Always()))
mapping clause code_single_word = 0b0001 @ 0b0100 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0100 @ x), Some(Always()))
mapping clause code_single_word = 0b0001 @ 0b0101 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0101 @ x), Some(Always()))
mapping clause code_single_word = 0b0001 @ 0b0110 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0110 @ x), Some(Always()))
mapping clause code_single_word = 0b0001 @ 0b0111 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b0111 @ x), Some(Always()))

/*
| sl rd, imm              | 0001 1000 iiii dddd |                     | FOX-1  |
| sra rd, imm             | 0001 1001 iiii dddd |                     | FOX-1  |
| srl rd, imm             | 0001 1010 iiii dddd |                     | FOX-1  |
*/
mapping clause code_single_word = 0b0001 @ 0b1000 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1000 @ x), Some(Always()))
mapping clause code_single_word = 0b0001 @ 0b1001 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1001 @ x), Some(Always()))
mapping clause code_single_word = 0b0001 @ 0b1010 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1010 @ x), Some(Always()))

mapping clause code_single_word = 0b0001 @ 0b1011 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1011 @ x), Some(Always()))
mapping clause code_single_word = 0b0001 @ 0b1100 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1100 @ x), Some(Always()))
mapping clause code_single_word = 0b0001 @ 0b1101 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1101 @ x), Some(Always()))

/*
| mov sr[imm], rd         | 0001 1110 iiii dddd |                     | FOX-1  |
| mov rd, sr[imm]         | 0001 1111 iiii dddd |                     | FOX-1  |
*/
mapping clause code_single_word = 0b0001 @ 0b1110 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1110 @ x), Some(Always()))
mapping clause code_single_word = 0b0001 @ 0b1111 @ x : bits(8)     <-> (UNALLOCATED(0b0001 @ 0b1111 @ x), Some(Always()))

mapping clause code_single_word = 0b0010 @ 0b0010 @ 0b0 @    pa @  0b0 @   pd <-> (MOVP(pd, pa), Some(Always()))
mapping clause code_single_word = 0b0010 @ 0b0011 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b0100 @ x), Some(Always()))

mapping clause code_single_word = 0b0010 @ 0b0110 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b0110 @ x), Some(Always()))
mapping clause code_single_word = 0b0010 @ 0b0111 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b0111 @ x), Some(Always()))

/*
| lt p0, rd, ra           | 0010 1100 aaaa dddd |                     |        |
| lte p0, rd, ra          | 0010 1101 aaaa dddd |                     |        |
| lt.u p0, rd, ra         | 0010 1110 aaaa dddd |                     |        |
| lte.u p0, rd, ra        | 0010 1111 aaaa dddd |                     |        |
*/
mapping clause code_single_word = 0b0010 @ 0b1100 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b1100 @ x), Some(Always()))
mapping clause code_single_word = 0b0010 @ 0b1101 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b1101 @ x), Some(Always()))
mapping clause code_single_word = 0b0010 @ 0b1110 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b1110 @ x), Some(Always()))
mapping clause code_single_word = 0b0010 @ 0b1110 @ x : bits(8)     <-> (UNALLOCATED(0b0010 @ 0b1110 @ x), Some(Always()))

/*
| eq p0, rd, ra           | 0011 0000 aaaa dddd |                     |        |
| neq p0, rd, ra          | 0011 0001 aaaa dddd |                     |        |
*/
mapping clause code_single_word = 0b0011 @ 0b0000 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0000 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b0001 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0001 @ x), Some(Always()))

mapping clause code_single_word = 0b0011 @ 0b0010 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0010 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b0011 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0011 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b0100 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0100 @ x), Some(Always()))

/*
| add.c rd, ra, p1        | 0011 0101 aaaa dddd |                     | FOX-1  |
| sub.c rd, ra, p1        | 0011 0110 aaaa dddd |                     | FOX-1  |
*/
mapping clause code_single_word = 0b0011 @ 0b0101 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0101 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b0110 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0110 @ x), Some(Always()))

mapping clause code_single_word = 0b0011 @ 0b0111 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b0111 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1000 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1000 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1001 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1001 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1010 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1010 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1011 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1011 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1100 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1100 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1101 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1101 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b0000 @ rd     <-> (EQ_Z(0b000, rd), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b0001 @ rd     <-> (NEQ_Z(0b000, rd), Some(Always()))

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
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b0010 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0010 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b0011 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0011 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b0100 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0100 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b0101 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0101 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b0110 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0110 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b0111 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b0111 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b1000 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1000 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b1001 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1001 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b1010 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1010 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b1011 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1011 @ x), Some(Always()))

mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b1100 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1100 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b1101 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1101 @ x), Some(Always()))

/*
| set.p pd, 0             | 0011 1110 1110 dddd |                     | FOX-1  |
| set.p pd, 1             | 0011 1110 1111 dddd |                     | FOX-1  |
*/
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b1110 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1110 @ x), Some(Always()))
mapping clause code_single_word = 0b0011 @ 0b1110 @ 0b1111 @ x : bits(4) <-> (UNALLOCATED(0b0011 @ 0b1101 @ 0b1111 @ x), Some(Always()))

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
mapping clause code_single_word = 0b0011 @ 0b1111 @ x : bits(8)     <-> (UNALLOCATED(0b0011 @ 0b1110 @ x), Some(Always()))

/* Backwards Mapping */

//| 0000 0000 dddd aaaa | mov rd, ra (rd = ra is reserved)
mapping clause code_single_word = backwards (MOV(rd, ra), Some(Always())) if rd != ra => 0b0000 @ 0b0000 @ rd : register_index @ ra : register_index

//| 0000 1100 dddd aaaa | inc rd, ra
mapping clause code_single_word = backwards (ADD(rd, ra, rb), Some(Always())) if ra == rd  => 0b0000 @ 0b1100 @ rd @ rb
//| 0000 1101 dddd aaaa | dec rd, ra
mapping clause code_single_word = backwards (SUB(rd, ra, rb), Some(Always())) if ra == rd  => 0b0000 @ 0b1101 @ rd @ rb


//| 0001 0000 dddd aaaa | and rd, ra
mapping clause code_single_word = backwards (AND(rd, ra, rb), Some(Always())) if ra == rd  => 0b0001 @ 0b0000 @ rd @ rb
//| 0001 0001 dddd aaaa | or rd, ra
mapping clause code_single_word = backwards (OR(rd, ra, rb), Some(Always())) if ra == rd   => 0b0001 @ 0b0001 @ rd @ rb
//| 0001 0010 dddd aaaa | xor rd, ra
mapping clause code_single_word = backwards (XOR(rd, ra, rb), Some(Always())) if ra == rd  => 0b0001 @ 0b0010 @ rd @ rb
//| 0001 0011 dddd aaaa | andc rd, ra
mapping clause code_single_word = backwards (ANDC(rd, ra, rb), Some(Always())) if ra == rd => 0b0001 @ 0b0011 @ rd @ rb


mapping clause code_single_word = unallocated : bits(16) <-> (UNALLOCATED(unallocated), Some(Always()))

end code_single_word

val code_double_word : doubleword <-> (ast, option(instruction_predicate))
scattered mapping code_double_word

// | 1100 0010 bbnn nnnn iiii iiii iiii iiii | block (b = branch count, n = instruction word count - 1), t1 = block + simm << 1
mapping clause code_double_word = 0b1100 @ 0b0010 @ b : block_branch_count @ n : block_length @ imm <-> (BLOCK(b, n, Some(imm)), Some(Always()))

// | 1100 0100 dddd 0001 iiii iiii iiii iiii | set rd, simm
mapping clause code_double_word = 0b1100 @ 0b0100 @ rd @ 0b0001 @ imm <-> (SET_W(rd, imm), Some(Always()))

mapping clause code_double_word = unallocated : bits(32) <-> (UNALLOCATED2(unallocated), Some(Always()))

end code_double_word
