/* TODO: This is clearly missing an implementation */
val short_branch_immediate : bits(8) <-> string

/* b imm */

union clause ast = BRANCH_S : bits(8)

mapping clause code_word = (BRANCH_S(imm), always) <-> 0b0000_0001 @ imm
mapping clause code_word = (BRANCH_S(imm), (0b1111, expected)) <-> 0b0000_001 @ expected @ imm

function clause execute BRANCH_S(imm) = {
  instruction_address_next = instruction_address_next + branch_extend(32, imm);

  RETIRE_SUCCESS
}

mapping clause assembly = BRANCH_S(imm) <-> "b" ^ spc() ^ short_branch_immediate(imm)
