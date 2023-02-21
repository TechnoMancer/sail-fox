register halted : bool

register instruction_address : bits(32)
register instruction_address_next : bits(32)

register instructions_retired : bits(32)

function retire_instruction() -> unit = {
    instructions_retired = instructions_retired + 1
}
