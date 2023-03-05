register halted : bool

register instruction_address : bits(32)
register instruction_address_next : bits(32)

register instructions_retired : bits(32)

function retire_instruction() -> unit = {
  instructions_retired = instructions_retired + 1
}

val read_ia = monadic "read_ia" : unit -> bits(32)
val write_ia = monadic "write_ia" : bits(32) -> unit


function read_system_state_from_emulator () -> unit = {
  instruction_address = read_ia();
}

function write_system_state_to_emulator () -> unit = {
  write_ia(instruction_address);
}
