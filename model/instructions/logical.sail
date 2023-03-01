/* and rd, ra */
union clause ast = AND : (register_index, register_index)

mapping clause code_word = AND(rd, ra) <-> 0b0010_1000 @ ra @ rd

function clause execute AND(rd, ra) = {
  R(rd) = R(rd) & R(ra);

  RETIRE_SUCCESS
}

mapping clause assembly = AND(rd, ra) <->  "and" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)

/* andc rd, ra */
union clause ast = ANDC : (register_index, register_index)

mapping clause code_word = ANDC(rd, ra) <-> 0b0010_1001 @ ra @ rd

function clause execute ANDC(rd, ra) = {
  R(rd) = R(rd) & ~(R(ra));

  RETIRE_SUCCESS
}

mapping clause assembly = ANDC(rd, ra) <->  "andc" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)

/* or rd, ra */
union clause ast = OR : (register_index, register_index)

mapping clause code_word = OR(rd, ra) <-> 0b0010_1010 @ ra @ rd

function clause execute OR(rd, ra) = {
  R(rd) = R(rd) | R(ra);

  RETIRE_SUCCESS
}

mapping clause assembly = OR(rd, ra) <->  "or" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)

/* xor rd, ra */
union clause ast = XOR : (register_index, register_index)

mapping clause code_word = XOR(rd, ra) <-> 0b0010_1011 @ ra @ rd

function clause execute XOR(rd, ra) = {
  R(rd) = R(rd) ^ R(ra);

  RETIRE_SUCCESS
}

mapping clause assembly = OR(rd, ra) <->  "xor" ^ spc() ^ register_name(rd) ^ sep() ^ register_name(ra)
