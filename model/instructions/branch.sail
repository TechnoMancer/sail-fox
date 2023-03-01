/* TODO: This is clearly missing an implementation */
val short_branch_immediate : bits(8) <-> string

/* b imm */

union clause ast = BRANCH_S : (bits(8), predicate_index, bits(1))

mapping clause code_word = BRANCH_S(imm, 0b1111, 0b1) <-> 0b0000_0001 @ imm
mapping clause code_word = BRANCH_S(imm, 0b0000, expected) <-> 0b0000_001 @ expected @ imm

function clause execute BRANCH_S(imm, pr, expected) = {
  if P(pr) == bits_to_bool(expected) then {
    instruction_address_next = instruction_address_next + branch_extend(32, imm);
  };

  RETIRE_SUCCESS
}

mapping clause assembly = BRANCH_S(imm, pr, expected) <-> "b" ^ spc() ^ short_branch_immediate(imm) ^ predication(pr, expected)
