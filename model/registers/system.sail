register halted : bool
register halt_reason : HaltReason = UNKNOWN

register instruction_address : target_type

register stack_pointer : target_type

register block : target_type
register block_size : option(target_type) = None()
register block_remaining : target_type
register block_target : option(target_type) = None()
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

val read_ia = monadic "read_ia" : unit -> target_type
val write_ia = monadic "write_ia" : target_type -> unit

val read_halt_reason = monadic "read_halt_reason" : unit -> bits(3)
val write_halt_reason = monadic "write_halt_reason" : bits(3) -> unit

val read_stack_pointer = monadic "read_stack_pointer" : unit -> target_type
val write_stack_pointer = monadic "write_stack_pointer" : target_type -> unit

function read_system_state_from_emulator () -> unit = {
  block_target = Some(read_ia());
  halt_reason = halt_reason_code(read_halt_reason());
  stack_pointer = read_stack_pointer();
}

function write_system_state_to_emulator () -> unit = {
  write_ia(instruction_address);
  write_halt_reason(halt_reason_code(halt_reason));
  write_stack_pointer(stack_pointer);
}
