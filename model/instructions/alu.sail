/* mov rd, ra */
union clause ast = MOV : (register_index, register_index)

mapping clause code_word = (MOV(rd, ra), always) <-> 0b0010_0000 @ ra @ rd

function clause execute MOV(rd, ra) = {
  R(rd) = R(ra);

  RETIRE_SUCCESS
}

mapping clause assembly = MOV(rd, ra) <->  "mov" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)

/* mov pd, pa */
union clause ast = MOVP : (predicate_index, predicate_index)

mapping clause code_word = (MOVP(pd, pa), always) <-> 0b0010_0010 @ pa @ pd

function clause execute MOVP(pd, pa) = {
  P(pd) = P(pa);

  RETIRE_SUCCESS
}

mapping clause assembly = MOVP(pd, pa) <->  "mov" ^ spc() ^ predicate_name(pd) ^ sep() ^ predicate_name(pa)

/* add rd, ra */
union clause ast = ADD : (register_index, register_index)

mapping clause code_word = (ADD(rd, ra), always) <-> 0b0010_0100 @ ra @ rd

function clause execute ADD(rd, ra) = {
  R(rd) = R(rd) + R(ra);

  RETIRE_SUCCESS
}

mapping clause assembly = ADD(rd, ra) <->  "add" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)

/* sub rd, ra */
union clause ast = SUB : (register_index, register_index)

mapping clause code_word = (SUB(rd, ra), always) <-> 0b0010_0101 @ ra @ rd

function clause execute SUB(rd, ra) = {
  R(rd) = R(rd) - R(ra);

  RETIRE_SUCCESS
}

mapping clause assembly = SUB(rd, ra) <->  "sub" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)

/* subf rd, ra */
union clause ast = SUBF : (register_index, register_index)

mapping clause code_word = (SUBF(rd, ra), always) <-> 0b0010_0110 @ ra @ rd

function clause execute SUBF(rd, ra) = {
  R(rd) = R(ra) - R(rd);

  RETIRE_SUCCESS
}

mapping clause assembly = SUBF(rd, ra) <->  "subf" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)
