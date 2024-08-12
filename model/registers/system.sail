register halted : bool
register halt_reason : HaltReason = UNKNOWN

register lr : bits(32)

register instruction_address : bits(32)

register block : bits(32)
register block_size : option(bits(32)) = None()
register block_remaining : bits(32)
register block_target : option(bits(32)) = None()
register block_branches : block_branch_count

register instructions_retired : bits(32)
register blocks_retired : bits(32)

function retire_instruction() -> unit = {
  instructions_retired = instructions_retired + 1
}

function retire_block() -> unit = {
  retire_instruction();
  blocks_retired = blocks_retired + 1
}

val read_ia = monadic "read_ia" : unit -> bits(32)
val write_ia = monadic "write_ia" : bits(32) -> unit

val read_halt_reason = monadic "read_halt_reason" : unit -> bits(2)
val write_halt_reason = monadic "write_halt_reason" : bits(2) -> unit

function read_system_state_from_emulator () -> unit = {
  block_target = Some(read_ia());
  halt_reason = halt_reason_code(read_halt_reason());
}

function write_system_state_to_emulator () -> unit = {
  write_ia(instruction_address);
  write_halt_reason(halt_reason_code(halt_reason));
}
