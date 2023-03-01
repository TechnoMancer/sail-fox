/* n?eq rd, 0 */
union clause ast = EQ_Z : (bits(1), predicate_index, register_index)

mapping clause code_word = (EQ_Z(op, 0b0000, rd), always) <-> 0b0011_1111_101 @ op @ rd
mapping clause code_word = (EQ_Z(op, 0b0000, rd), (0b0000, expected)) <-> 0b0011_1111_11 @ expected @ op @ rd

function clause execute EQ_Z(op, pd, rd) = {
  P(pd) = bits_to_bool(op) ^ (R(rd) == 0b0000_0000_0000_0000);

  RETIRE_SUCCESS
}

mapping clause assembly = EQ_Z(0b0, pd, rd) <->  "eq" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(rd) ^ sep() ^ "0"
mapping clause assembly = EQ_Z(0b1, pd, rd) <-> "neq" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(rd) ^ sep() ^ "0"

/* n?eq rd, ra */
union clause ast = EQ : (bits(1), predicate_index, register_index, register_index)

mapping clause code_word = (EQ(op, 0b0000, rd, ra), always) <-> 0b0011_000 @ op @ ra @ rd

function clause execute EQ(op, pd, rd, ra) = {
  P(pd) = bits_to_bool(op) ^ (R(rd) == R(ra));

  RETIRE_SUCCESS
}

mapping clause assembly = EQ(0b0, pd, rd, ra) <->  "eq" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(rd) ^ sep() ^ register_name(ra)
mapping clause assembly = EQ(0b1, pd, rd, ra) <-> "neq" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(rd) ^ sep() ^ register_name(ra)

/* lt rd, ra */
union clause ast = LT : (register_index, register_index)

mapping clause code_word = (LT(rd, ra), always) <-> 0b0010_1100 @ ra @ rd

function clause execute LT(rd, ra) = {
  P(0b0000) = (R(rd) <_s R(ra));

  RETIRE_SUCCESS
}

mapping clause assembly = LT(rd, ra) <->  "lt" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)

/* lte rd, ra */
union clause ast = LTE : (register_index, register_index)

mapping clause code_word = (LTE(rd, ra), always) <-> 0b0010_1111 @ ra @ rd

function clause execute LTE(rd, ra) = {
  P(0b0000) = (R(rd) <=_s R(ra));

  RETIRE_SUCCESS
}

mapping clause assembly = LTE(rd, ra) <->  "lte" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)

/* lt.u rd, ra */
union clause ast = LTU : (register_index, register_index)

mapping clause code_word = (LTU(rd, ra), always) <-> 0b0010_1110 @ ra @ rd

function clause execute LTU(rd, ra) = {
  P(0b0000) = (R(rd) <_u R(ra));

  RETIRE_SUCCESS
}

mapping clause assembly = LTU(rd, ra) <->  "lt.u" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)

/* lte.u rd, ra */
union clause ast = LTEU : (register_index, register_index)

mapping clause code_word = (LTEU(rd, ra), always) <-> 0b0010_1111 @ ra @ rd

function clause execute LTEU(rd, ra) = {
  P(0b0000) = (R(rd) <=_u R(ra));

  RETIRE_SUCCESS
}

mapping clause assembly = LTEU(rd, ra) <->  "lte.u" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)
