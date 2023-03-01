function handle_unallocated() : unit -> unit = {
  halted = true;
}

union clause ast = UNALLOCATED : word

mapping clause code_word = (UNALLOCATED(s), always) <-> s

/* TODO: Actually handle this maybe? */
function clause execute (UNALLOCATED(s)) = { handle_unallocated(); RETIRE_FAIL }

mapping clause assembly = UNALLOCATED(s) <-> "unallocated" ^ spc() ^ hex_bits_16(s)

/* End definitions */
end ast
end execute
end assembly
end code_word

val print_insn : ast -> string
function print_insn insn = assembly(insn)

overload to_str = { print_insn }
