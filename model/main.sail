function main() : unit -> unit = {
  halted = false;

  read_state_from_emulator();

  fetch_and_execute();

  write_state_to_emulator();
}
