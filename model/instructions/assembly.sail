val assembly : ast <-> string
scattered mapping assembly

mapping clause assembly = MOV(rd, ra) <->  "mov" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)
mapping clause assembly = MOVP(pd, pa) <->  "mov" ^ spc() ^ predicate_name(pd) ^ sep() ^ predication(pa)
mapping clause assembly = MOVT(td, ta) <->  "mov" ^ spc() ^ target_name(td) ^ sep() ^ target_name(ta)
mapping clause assembly = READT(rd, ta) <-> "read" ^ spc() ^ register_name(rd) ^ sep() ^ target_name(ta)
mapping clause assembly = WRITET(td, ra) <-> "target" ^ spc() ^ target_name(td) ^ sep() ^ register_name(ra)
mapping clause assembly = ADD(rd, ra, rb) <->  "add" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra) ^ sep() ^ register_name(rb)
mapping clause assembly = SUB(rd, ra, rb) <->  "sub" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra) ^ sep() ^ register_name(rb)
mapping clause assembly = BRANCH(td) <-> "b" ^ spc() ^ target_name(td)
mapping clause assembly = BRANCH_Z(td, ra, false) <-> "b" ^ spc() ^ target_name(td) ^ sep() ^ "if " ^ register_name(ra) ^ " == 0"
mapping clause assembly = BRANCH_Z(td, ra, true) <-> "b" ^ spc() ^ target_name(td) ^ sep() ^ "if " ^ register_name(ra) ^ " != 0"
mapping clause assembly = BLOCK(b, count, None()) <-> "block" ^ spc() ^ "(" ^ hex_bits_2(b) ^ ", #" ^ hex_bits_6(count) ^ ")"
mapping clause assembly = BLOCK(b, count, Some(imm)) <-> "block" ^ spc() ^ "(" ^ hex_bits_2(b) ^ ", #" ^ hex_bits_6(count) ^ ")" ^ spc() ^ hex_bits_16(imm) 
mapping clause assembly = BRANCHL(td) <-> "bl" ^ spc() ^ target_name(td)
mapping clause assembly = EQ_Z(pd, ra) <->  "eq" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(ra) ^ sep() ^ "0"
mapping clause assembly = NEQ_Z(pd, ra) <-> "neq" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(ra) ^ sep() ^ "0"
mapping clause assembly = EQ(pd, ra, rb) <->  "eq" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(ra) ^ sep() ^ register_name(rb)
mapping clause assembly = NEQ(pd, ra, rb) <-> "neq" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(ra) ^ sep() ^ register_name(rb)
mapping clause assembly = LT(pd, ra, rb) <->  "lt" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(ra) ^ sep() ^ register_name(rb)
mapping clause assembly = LTE(pd, ra, rb) <->  "lte" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(ra) ^ sep() ^ register_name(rb)
mapping clause assembly = LTU(pd, ra, rb) <->  "lt.u" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(ra) ^ sep() ^ register_name(rb)
mapping clause assembly = LTEU(pd, ra, rb) <->  "lte.u" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(ra) ^ sep() ^ register_name(rb)
mapping clause assembly = AND(rd, ra, rb) <->  "and" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra) ^ sep() ^ register_name(rb)
mapping clause assembly = ANDC(rd, ra, rb) <->  "andc" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra) ^ sep() ^ register_name(rb)
mapping clause assembly = OR(rd, ra, rb) <->  "or" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra) ^ sep() ^ register_name(rb)
mapping clause assembly = XOR(rd, ra, rb) <->  "xor" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra) ^ sep() ^ register_name(rb)
mapping clause assembly = NOT(rd, ra) <-> "not" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)
mapping clause assembly = NEG(rd, ra) <-> "neg" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)
mapping clause assembly = BSWAP(rd, ra) <-> "byteswap" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)
mapping clause assembly = ADD_S(rd, imm) <-> "add" ^ spc() ^ register_name(rd) ^ sep() ^ "(" ^ hex_bits_4(imm) ^ " + 1)" /* short_unsigned_immediate(imm) */
mapping clause assembly = SUB_S(rd, imm) <-> "sub" ^ spc() ^ register_name(rd) ^ sep() ^  "(" ^ hex_bits_4(imm) ^ " + 1)" /* short_unsigned_immediate(imm) */
mapping clause assembly = AND_S(rd, imm) <-> "sub" ^ spc() ^ register_name(rd) ^ sep() ^ hex_bits_4(imm) /* short_signed_immediate(imm) */
mapping clause assembly = SET_S(rd, imm, 0b0) <-> "set.s" ^ spc() ^ register_name(rd) ^ sep() ^ "(" ^ hex_bits_4(imm) ^ " + 1)"
mapping clause assembly = SET_S(rd, imm, 0b1) <-> "set.s" ^ spc() ^ register_name(rd) ^ sep() ^ "- (" ^ hex_bits_4(imm) ^ " + 1)"
mapping clause assembly = SET_W(rd, imm) <-> "set.w" ^ spc() ^ register_name(rd) ^ sep() ^ hex_bits_16(imm)
mapping clause assembly = LOAD_W(rd, ra, imm) <-> "ld.w" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra) ^ "[" ^ hex_bits_4(imm) ^ "]"
mapping clause assembly = STORE_W(rd, ra, imm) <-> "st.w" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra) ^ "[" ^ hex_bits_4(imm) ^ "]"
mapping clause assembly = CSR_READ(rd, imm) <-> "read" ^ spc() ^ register_name(rd) ^ sep() ^ "csr[" ^ hex_bits_8(imm) ^ "]"
mapping clause assembly = CSR_WRITE(rd, imm) <-> "write" ^ spc() ^ register_name(rd) ^ sep() ^ "csr[" ^ hex_bits_8(imm) ^ "]"
mapping clause assembly = HALT() <-> "halt"
mapping clause assembly = NOP() <-> "nop"
mapping clause assembly = HINT(hint) <-> "hint" ^ spc() ^ hex_bits_4(hint)
mapping clause assembly = UNALLOCATED(s) <-> "unallocated" ^ spc() ^ hex_bits_16(s)
mapping clause assembly = UNALLOCATED2(s) <-> "unallocated" ^ spc() ^ hex_bits_32(s)

end assembly
