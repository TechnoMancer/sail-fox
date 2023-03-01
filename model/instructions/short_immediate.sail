/* TODO: This is clearly missing an implementation */
val short_sext_immediate : bits(4) <-> string
val short_signed_immediate : bits(4) <-> string
val short_unsigned_immediate : bits(4) <-> string

/* add rd, imm */

union clause ast = ADD_S : (register_index, bits(4))

mapping clause code_word = (ADD_S(rd, imm), always) <-> 0b0001_0000 @ imm @ rd

function clause execute ADD_S(rd, imm) = { R(rd) = R(rd) + unsigned_extend(16, imm); RETIRE_SUCCESS }

mapping clause assembly = ADD_S(rd, imm) <-> "add" ^ spc() ^ register_name(rd) ^ sep() ^ short_unsigned_immediate(imm)

/* sub rd, imm */

union clause ast = SUB_S : (register_index, bits(4))

mapping clause code_word = (SUB_S(rd, imm), always) <-> 0b0001_0000 @ imm @ rd

function clause execute SUB_S(rd, imm) = { R(rd) = R(rd) - unsigned_extend(16, imm); RETIRE_SUCCESS }

mapping clause assembly = SUB_S(rd, imm) <-> "sub" ^ spc() ^ register_name(rd) ^ sep() ^ short_unsigned_immediate(imm)

/* and rd, imm */

union clause ast = AND_S : (register_index, bits(4))

mapping clause code_word = (AND_S(rd, imm), always) <-> 0b0001_0000 @ imm @ rd

function clause execute AND_S(rd, imm) = { R(rd) = R(rd) & signed_extend(16, imm); RETIRE_SUCCESS }

mapping clause assembly = AND_S(rd, imm) <-> "sub" ^ spc() ^ register_name(rd) ^ sep() ^ short_signed_immediate(imm)

/* set.b rd, imm */
/* set.w rd, imm */

union clause ast = SET_S : (register_index, bits(4))

mapping clause code_word = (SET_S(rd, imm), always) <-> 0b0001_0000 @ imm @ rd

function clause execute SET_S(rd, imm) = { R(rd) = sign_extend(16, imm); RETIRE_SUCCESS }

mapping clause assembly = SET_S(rd, imm) <-> "set.w" ^ spc() ^ register_name(rd) ^ sep() ^ short_sext_immediate(imm)

/* set.d rd, imm */
/* set.q rd, imm */
