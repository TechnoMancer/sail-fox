function read_state_from_emulator () -> unit = {
  read_register_state_from_emulator();
  read_predicate_state_from_emulator();
  read_target_state_from_emulator();
  read_system_state_from_emulator();
}

function write_state_to_emulator () -> unit = {
  write_register_state_to_emulator();
  write_predicate_state_to_emulator();
  write_target_state_to_emulator();
  write_system_state_to_emulator();
}
