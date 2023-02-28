function fetch_and_execute() : unit -> unit =
  while halted == false do {
    print_bits("ia = ", instruction_address);

    let instruction = read_u16_be(instruction_address);

    instruction_address_next = instruction_address + 2;

    print_bits("instruction = ", instruction);

    let ast = code_word(instruction);

    match execute(ast) {
      RETIRE_SUCCESS => retire_instruction(),
      RETIRE_FAIL => ()
    };

    instruction_address = instruction_address_next;
  }

function main() : unit -> unit = {
  halted = false;
  instruction_address = 0x0000_0000;

  print_bits("initial ia = ", instruction_address);

  fetch_and_execute()
}