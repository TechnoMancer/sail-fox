/* returns wheter a block instruction was retired */
val execute_block : ast -> Retired
scattered function execute_block

val new_block : bits(32) -> unit
function new_block size = {
  block = instruction_address;
  block_size = Some(size + 2);
  block_remaining = size + 2;
}

function clause execute_block BLOCK_S(0b0, 0b00, imm) = {
  let immediate = zero_extend(32, imm << 1);

  new_block(immediate);

  RETIRE_SUCCESS
}

function clause execute_block BLOCK_S(0b1, l0, imm) = {
  let immediate = zero_extend(32, imm << 1);

  new_block(immediate);
  
  block_target = Some(block + immediate + 2);

  RETIRE_SUCCESS
}

function clause execute_block _ = { RETIRE_FAIL }

end execute_block
