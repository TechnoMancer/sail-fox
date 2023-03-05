function fetch_and_execute() : unit -> unit =
  while halted == false do {
    let instruction = read_u16_be(instruction_address);

    instruction_address_next = instruction_address + 2;

    let (ast, (predicate, expected)) = code_word(instruction);

    print(string_append(string_append(hex_str(unsigned(instruction_address)), ": "), assembly(ast)));

    if P(predicate) == bits_to_bool(expected) then {
      match execute(ast) {
        RETIRE_SUCCESS => retire_instruction(),
        RETIRE_FAIL => ()
      };
    } else {
      retire_instruction();
    };

    instruction_address = instruction_address_next;
  }

function main() : unit -> unit = {
  halted = false;

  read_state_from_emulator();

  fetch_and_execute();

  write_state_to_emulator();
}