function fetch_and_execute() : unit -> unit =
  while halted == false do {
    instruction_address = if unsigned(block_remaining) == 0 then {
      match block_target {
        None() => {
          /* TODO: Make this properly trap */
          print("block target not set");
          halted = true;
          instruction_address
        },
        Some(address) => {
          block = address;
          block_size = None();
          block_target = None();
          address
        }
      }
    } else {
      instruction_address
    };

    let instruction = read_u16_be(instruction_address);
    
    let (ast, (predicate, expected)) = code_word(instruction);

    /*
    let s = "";
    let s = string_append(s, hex_str(unsigned(instruction_address)));
    let s = string_append(s, ": ");
    let s = string_append(s, assembly(ast));
    let s = string_append(s, " (block: ");
    let s = string_append(s, match block_size {
      None() => " new",
      Some(size) => string_append(string_append(dec_str(unsigned(block_remaining)), " remaining of "), dec_str(unsigned(size)))
    });
    let s = string_append(s, ")");
    print(s);
    */

    match block_size {
      None() => match execute_block(ast) {
        RETIRE_SUCCESS => {
          retire_block()
        },
        RETIRE_FAIL => {
          /* TODO: Make this properly trap */
          print("block failed to retire");
          halted = true;
        }
      },
      Some(_) => if P(predicate) == bits_to_bool(expected) then {
        match execute(ast) {
          RETIRE_SUCCESS => retire_instruction(),
          RETIRE_FAIL => {
            /* TODO: Make this properly trap */
            print("instruction failed to retire");
            halted = true;
          }
        };
      } else {
        retire_instruction();
      }
    };

    instruction_address = instruction_address + 2;
    block_remaining = block_remaining - 2;
  }
