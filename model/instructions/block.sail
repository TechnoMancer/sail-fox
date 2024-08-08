/* returns wheter a block instruction was retired */
val execute_block : ast -> Retired
scattered function execute_block

val new_block : (bits(32), block_branch_count) -> unit
function new_block (size, branches) = {
  block = instruction_address;
  block_size = Some(size);
  block_remaining = size;
  block_branches = branches;
}

val get_block_size : (block_length, bits(32)) -> bits(32)
function get_block_size (word_count, block_insn_size) = {
  // Block lengths are encodes as length in words - 1 so need to add 1 back
  let block_words = zero_extend(32, word_count) + zero_extend(32, 0x1) + block_insn_size;

  zero_extend(32, block_words << 1)
}

function clause execute_block BLOCK(branches, words, None()) = {
  let block_size_words = get_block_size(words, zero_extend(32, 0x1));

  new_block(block_size_words, branches);

  RETIRE_SUCCESS
}

function clause execute_block _ = { RETIRE_FAIL }

end execute_block
