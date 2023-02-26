/* TODO: This is clearly missing an implementation */
val short_branch_immediate : bits(8) <-> string
val predication : (predicate_index, bits(1)) <-> string

/* b imm */

union clause ast = BRANCH_S : (bits(8), predicate_index, bits(1))

mapping clause code_word = BRANCH_S(imm, 0b1111, 0b1) <-> 0b0000_0001 @ imm
mapping clause code_word = BRANCH_S(imm, 0b0000, 0b0) <-> 0b0000_0010 @ imm
mapping clause code_word = BRANCH_S(imm, 0b0000, 0b1) <-> 0b0000_0011 @ imm

function clause execute BRANCH_S(imm, px, expected) = {
  if pX(px) == expected then {
    instruction_address_next = instruction_address_next + branch_extend(32, imm);
  };

  RETIRE_SUCCESS
}

mapping clause assembly = BRANCH_S(imm, px, expected) <-> "b" ^ spc() ^ short_branch_immediate(imm) ^ predication(px, expected)

/* b rd */

union clause ast = BRANCH_SR : (register_index, predicate_index, bits(1))

mapping clause code_word = BRANCH_SR(rd, 0b1111, 0b1) <-> 0b0011_1111 @ 0b0001 @ rd
mapping clause code_word = BRANCH_SR(rd, 0b0000, 0b0) <-> 0b0011_1111 @ 0b0010 @ rd
mapping clause code_word = BRANCH_SR(rd, 0b0000, 0b1) <-> 0b0011_1111 @ 0b0011 @ rd

function clause execute BRANCH_SR(rd, px, expected) = {
  if pX(px) == expected then {
    instruction_address_next = R(rd);
  };

  RETIRE_SUCCESS
}

mapping clause assembly = BRANCH_SR(rd, px, expected) <-> "b" ^ spc() ^ register_name(rd) ^ predication(px, expected)
