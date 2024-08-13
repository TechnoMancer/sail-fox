/* returns wheter a block instruction was retired */
val execute_block : ast -> Retired
scattered function execute_block

val new_block : (target_type, block_branch_count) -> unit
function new_block (size, branches) = {
  block = instruction_address;
  block_size = Some(size);
  block_remaining = size;
  block_branches = branches;
  let block_end : target_type = block + size;
  T(6) = block_end;
  T(7) = block;
}

val get_block_size : (block_length, target_type) -> target_type
function get_block_size (word_count, block_insn_size) = {
  // Block lengths are encodes as length in words - 1 so need to add 1 back
  let block_words = zero_extend(sizeof(target_width), word_count) + zero_extend(sizeof(target_width), 0x1) + block_insn_size;

  zero_extend(sizeof(target_width), block_words << 1)
}

val compute_target_addr : target_type -> target_type
function compute_target_addr(imm) = {
  let adjusted_imm = truncate(imm << 1, sizeof(target_width));

  if adjusted_imm <=_s sign_extend(sizeof(target_width),0x0) then
    block + adjusted_imm
  else
    T(6) + adjusted_imm - zero_extend(sizeof(target_width), 0x2)
}

function clause execute_block BLOCK(branches, words, None()) = {
  let block_size_words = get_block_size(words, zero_extend(sizeof(target_width), 0x1));

  new_block(block_size_words, branches);

  RETIRE_SUCCESS
}

function clause execute_block BLOCK(branches, words, Some(simm)) = {
  let block_size_words = get_block_size(words, zero_extend(sizeof(target_width), 0x2));

  new_block(block_size_words, branches);

  let target :target_type = compute_target_addr(simm);

  T(0) = target;

  RETIRE_SUCCESS
}

function clause execute_block _ = { RETIRE_FAIL }

end execute_block
