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
union clause ast = ADD : (register_index, register_index, register_index)

mapping clause code_word = forwards (ADD(rd, ra, rb), always) if ra == rd => 0b0010_0100 @ rb @ rd
mapping clause code_word = backwards 0b0010_0100 @ ra : register_index @ rd : register_index => (ADD(rd, rd, ra), always)

function clause execute ADD(rd, ra, rb) = {
  R(rd) = R(ra) + R(rb);

  RETIRE_SUCCESS
}

mapping clause assembly = ADD(rd, ra, rb) <->  "add" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra) ^ sep() ^ register_name(rb)

/* suba */
union clause ast = SUB : (register_index, register_index, register_index)

mapping clause code_word = forwards (SUB(rd, ra, rb), always) if ra == rd => 0b0010_0101 @ rb @ rd
mapping clause code_word = forwards (SUB(rd, ra, rb), always) if rb == rd => 0b0010_0110 @ ra @ rd

mapping clause code_word = backwards 0b0010_0101 @ ra : register_index @ rd : register_index => (SUB(rd, rd, ra), always)
mapping clause code_word = backwards 0b0010_0110 @ ra : register_index @ rd : register_index => (SUB(rd, ra, rd), always)

function clause execute SUB(rd, ra, rb) = {
  R(rd) = R(ra) - R(rb);

  RETIRE_SUCCESS
}

mapping clause assembly = SUB(rd, ra, rb) <->  "sub" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra) ^ sep() ^ register_name(rb)
