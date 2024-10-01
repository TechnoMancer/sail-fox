val instruction_length : bits(3) -> instructionLength
function instruction_length (prefix) = {
    match (prefix) {
        0b0 @ _ => SINGLE_WORD,
        0b10 @ _ => SINGLE_WORD,
        0b11 @ _ => DOUBLE_WORD,
        _ => NOT_ALLOCATED,
    }
}

val code_single_word : word <-> (ast, option(predicate))
scattered mapping code_single_word

/* Bidirectional Mapping */

mapping clause code_single_word = 0b0000 @ 0b0000 @ 0b0000 @ 0b0000 <-> (UNALLOCATED(0b0000 @ 0b0000 @ 0b0000 @ 0b0000), Some(Always()))

//| CORE | 0000 0000 dddd aaaa | mov rd, ra (rd = ra is reserved)
mapping clause code_single_word = forwards 0b0000 @ 0b0000 @ rd : register_index @ ra : register_index if ra != rd => (MOV(rd, ra), Some(Always()))

//| CORE | 0000 0001 dddd aaaa | not rd, ra
mapping clause code_single_word = 0b0000 @ 0b0001 @ rd : register_index @ ra : register_index <-> (NOT(rd, ra), Some(Always()))
//| CORE | 0000 0010 dddd aaaa | neg rd, ra
mapping clause code_single_word = 0b0000 @ 0b0010 @ rd : register_index @ ra : register_index <-> (NEG(rd, ra), Some(Always()))
//| CORE | 0000 0011 dddd aaaa | byteswap rd, ra
mapping clause code_single_word = 0b0000 @ 0b0011 @ rd : register_index @ ra : register_index <-> (BSWAP(rd, ra), Some(Always()))

//| CMOV | 0000 0100 dddd aaaa | mov rd, ra if p0 (rd = ra is reserved)
mapping clause code_single_word = forwards 0b0000 @ 0b0100 @ rd : register_index @ ra : register_index if ra != rd => (MOV(rd, ra), Some(Predicate(0b000)))
//| CMOV | 0000 0101 dddd aaaa | mov rd, ra unless p0 (rd = ra is reserved)
mapping clause code_single_word = forwards 0b0000 @ 0b0101 @ rd : register_index @ ra : register_index if ra != rd => (MOV(rd, ra), Some(InversePredicate(0b000)))

//| CORE | 0000 0111 0ddd aaaa | b td if ra == 0
mapping clause code_single_word = 0b0000 @ 0b0111 @ 0b0 @ td : target_index @ ra : register_index <-> (BRANCH_Z(td, ra, false), Some(Always()))
//| CORE | 0000 0111 1ddd aaaa | b td if ra != 0
mapping clause code_single_word = 0b0000 @ 0b0111 @ 0b1 @ td : target_index @ ra : register_index <-> (BRANCH_Z(td, ra, true), Some(Always()))

//| CORE | 0000 1000 dddd aaaa | eq p0, rd, ra
mapping clause code_single_word = 0b0000 @ 0b1000 @ rd : register_index @ ra : register_index <-> (EQ(0b000, rd, ra), Some(Always()))
//| CORE | 0000 1001 dddd aaaa | gt.s p0, rd, ra
mapping clause code_single_word = 0b0000 @ 0b1001 @ rd : register_index @ ra : register_index <-> (LT(0b000, ra, rd), Some(Always()))
//| CORE | 0000 1010 dddd aaaa | gt.u p0, rd, ra
mapping clause code_single_word = 0b0000 @ 0b1010 @ rd : register_index @ ra : register_index <-> (LTU(0b000, ra, rd), Some(Always()))

//| CORE | 0000 1011 0ddd pppp | b td (predicated)
mapping clause code_single_word = 0b0000 @ 0b1011 @ 0b0 @ td : target_index @ p : predicate_encoding <-> (BRANCH(td), predicated_instruction_decode(p))
//| CALL | 0000 1011 1ddd pppp | call td (predicated)
mapping clause code_single_word = 0b0000 @ 0b1011 @ 0b1 @ td : target_index @ p : predicate_encoding <-> (BRANCHL(td), predicated_instruction_decode(p))

//| CORE | 0000 1100 dddd aaaa | inc rd, ra
mapping clause code_single_word = forwards 0b0000 @ 0b1100 @ rd : register_index @ ra : register_index => (ADD(rd, rd, ra), Some(Always()))
//| CORE | 0000 1101 dddd aaaa | dec rd, ra
mapping clause code_single_word = forwards 0b0000 @ 0b1101 @ rd : register_index @ ra : register_index => (SUB(rd, rd, ra), Some(Always()))

//| EMU | 0000 1111 0000 0000 | temporary halt.
mapping clause code_single_word = 0b0000 @ 0b1111 @ 0b0000 @ 0b0000 <-> (HALT(), Some(Always()))

//| CORE | 0001 0000 dddd aaaa | and rd, ra
mapping clause code_single_word = forwards 0b0001 @ 0b0000 @ rd : register_index @ ra : register_index => (AND(rd, rd, ra), Some(Always()))
//| CORE | 0001 0001 dddd aaaa | or rd, ra
mapping clause code_single_word = forwards 0b0001 @ 0b0001 @ rd : register_index @ ra : register_index => (OR(rd, rd, ra), Some(Always()))
//| CORE | 0001 0010 dddd aaaa | xor rd, ra
mapping clause code_single_word = forwards 0b0001 @ 0b0010 @ rd : register_index @ ra : register_index => (XOR(rd, rd, ra), Some(Always()))
//| CORE | 0001 0011 dddd aaaa | andc rd, ra
mapping clause code_single_word = forwards 0b0001 @ 0b0011 @ rd : register_index @ ra : register_index => (ANDC(rd, rd, ra), Some(Always()))

//| CORE | 0001 0100 0ddd aaaa | mov pd, pa
mapping clause code_single_word = 0b0001 @ 0b0100 @ 0b0 @ pd : predicate_index @ pa : predicate_encoding <-> (MOVP(pd, predicate_read_decode(pa)), Some(Always()))
//| CORE | 0001 0100 1ddd aaaa | mov td, ta
mapping clause code_single_word = 0b0001 @ 0b0100 @ 0b1 @ td : target_index @ 0b0 @ ta: target_index <-> (MOVT(td, ta), Some(Always()))

//| CORE | 0010 0000 dddd iiii | set rd, imm + 1
//| CORE | 0010 0001 dddd iiii | set rd, -(imm + 1)
mapping clause code_single_word = 0b0010 @ 0b000 @ sign @ rd : register_index @     imm <-> (SET_S(rd, imm, sign), Some(Always()))

//| CORE | 0010 0010 dddd iiii | inc rd, imm + 1
mapping clause code_single_word = 0b0010 @ 0b0010 @ rd :register_index @ imm <-> (ADD_S(rd, imm), Some(Always()))
//| CORE | 0010 0011 dddd iiii | dec rd, imm + 1
mapping clause code_single_word = 0b0010 @ 0b0011 @ rd :register_index @ imm <-> (SUB_S(rd, imm), Some(Always()))

//| CMOV | 0010 0100 dddd iiii | inc rd, imm + 1 if p0
mapping clause code_single_word = 0b0010 @ 0b0100 @ rd :register_index @ imm <-> (ADD_S(rd, imm), Some(Predicate(0b000)))
//| CMOV | 0010 0101 dddd iiii | dec rd, imm + 1 if p0
mapping clause code_single_word = 0b0010 @ 0b0101 @ rd :register_index @ imm <-> (SUB_S(rd, imm), Some(Predicate(0b000)))

//| CORE | 0011 1111 bbnn nnnn | block (b = branch count, n = instruction word count - 1)
mapping clause code_single_word = 0b0011 @ 0b1111 @ b : block_branch_count @ n : block_length  <-> (BLOCK(b, n, None()), Some(Always()))

//| CORE | 1000 iiii dddd aaaa | load rd, ra[imm] (relative to c0)
mapping clause code_single_word = 0b1000 @ imm @ rd : register_index @ ra : register_index <-> (LOAD_W(rd, ra, imm), Some(Always()))
//| CORE | 1001 iiii dddd aaaa | store rd, ra[imm] (relative to c0)
mapping clause code_single_word = 0b1001 @ imm @ rd : register_index @ ra : register_index <-> (STORE_W(rd, ra, imm), Some(Always()))

/* Backwards Mapping */

//| CORE | 0000 0000 dddd aaaa | mov rd, ra (rd = ra is reserved)
mapping clause code_single_word = backwards (MOV(rd, ra), Some(Always())) if rd != ra => 0b0000 @ 0b0000 @ rd : register_index @ ra : register_index

//| CMOV | 0000 0100 dddd aaaa | mov rd, ra if p0 (rd = ra is reserved)
mapping clause code_single_word = backwards (MOV(rd, ra), Some(Predicate(0b000))) if ra != rd => 0b0000 @ 0b0100 @ rd : register_index @ ra : register_index
//| CMOV | 0000 0101 dddd aaaa | mov rd, ra unless p0 (rd = ra is reserved)
mapping clause code_single_word = backwards (MOV(rd, ra), Some(InversePredicate(0b000))) if ra != rd => 0b0000 @ 0b0100 @ rd : register_index @ ra : register_index

//| CORE | 0000 1100 dddd aaaa | inc rd, ra
mapping clause code_single_word = backwards (ADD(rd, ra, rb), Some(Always())) if ra == rd  => 0b0000 @ 0b1100 @ rd @ rb
//| CORE | 0000 1101 dddd aaaa | dec rd, ra
mapping clause code_single_word = backwards (SUB(rd, ra, rb), Some(Always())) if ra == rd  => 0b0000 @ 0b1101 @ rd @ rb

//| CORE | 0001 0000 dddd aaaa | and rd, ra
mapping clause code_single_word = backwards (AND(rd, ra, rb), Some(Always())) if ra == rd  => 0b0001 @ 0b0000 @ rd @ rb
//| CORE | 0001 0001 dddd aaaa | or rd, ra
mapping clause code_single_word = backwards (OR(rd, ra, rb), Some(Always())) if ra == rd   => 0b0001 @ 0b0001 @ rd @ rb
//| CORE | 0001 0010 dddd aaaa | xor rd, ra
mapping clause code_single_word = backwards (XOR(rd, ra, rb), Some(Always())) if ra == rd  => 0b0001 @ 0b0010 @ rd @ rb
//| CORE | 0001 0011 dddd aaaa | andc rd, ra
mapping clause code_single_word = backwards (ANDC(rd, ra, rb), Some(Always())) if ra == rd => 0b0001 @ 0b0011 @ rd @ rb


mapping clause code_single_word = unallocated : bits(16) <-> (UNALLOCATED(unallocated), Some(Always()))

end code_single_word

val code_double_word : doubleword <-> (ast, option(predicate))
scattered mapping code_double_word

//| CORE | 1100 0000 dddd iiii iiii 0111 1111 1100 | read rd, csr[imm]
mapping clause code_double_word = 0b1100 @ 0b0000 @ rd :register_index @ imm : bits(8) @ 0b0111 @ 0b1111 @ 0b1100 <-> (CSR_READ(rd, imm), Some(Always()))
//| CORE | 1100 0000 dddd iiii iiii 0111 1111 1101 | write rd, csr[imm]
mapping clause code_double_word = 0b1100 @ 0b0000 @ rd :register_index @ imm : bits(8) @ 0b0111 @ 0b1111 @ 0b1101 <-> (CSR_WRITE(rd, imm), Some(Always()))

//| CORE | 1100 1101 bbnn nnnn iiii iiii iiii iiii | block (b = branch count, n = instruction word count - 1), t0 = block + simm << 1
mapping clause code_double_word = 0b1100 @ 0b1101 @ b : block_branch_count @ n : block_length @ imm <-> (BLOCK(b, n, Some(imm)), Some(Always()))

//| CORE | 1100 1111 dddd 0001 iiii iiii iiii iiii | set rd, simm
mapping clause code_double_word = 0b1100 @ 0b1111 @ rd @ 0b0001 @ imm <-> (SET_W(rd, imm), Some(Always()))

mapping clause code_double_word = unallocated : bits(32) <-> (UNALLOCATED2(unallocated), Some(Always()))

end code_double_word
