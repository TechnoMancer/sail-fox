function fetch_and_execute() : unit -> unit =
  while halted == false do {
    print_bits("ia = ", instruction_address);

    let instruction = read_u16_be(instruction_address);

    instruction_address_next = instruction_address + 2;

    print_bits("instruction = ", instruction);

    let (ast, (predicate, expected)) = code_word(instruction);

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
  instruction_address = 0x0000_0000;

  print_bits("initial ia = ", instruction_address);

  fetch_and_execute()
}