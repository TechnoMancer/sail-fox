union clause ast = HALT : unit

mapping clause code_word = (HALT(), always) <-> 0b0000_0000 @ 0b0000 @ 0b0001

function clause execute HALT() = { halted = true; RETIRE_SUCCESS }

mapping clause assembly = HALT() <-> "halt"

/* ****************************************************************** */

union clause ast = NOP : unit

mapping clause code_word = (NOP(), always) <-> 0b0000_0000 @ 0b0001 @ 0b0000

function clause execute NOP() = { RETIRE_SUCCESS }

mapping clause assembly = NOP() <-> "nop"

/* ****************************************************************** */

union clause ast = HINT : bits(4)

mapping clause code_word = (HINT(hint), always) <-> 0b0000_0000 @ 0b0001 @ hint

function clause execute HINT(_) = { RETIRE_SUCCESS }

mapping clause assembly = HINT(hint) <-> "hint" ^ spc() ^ hex_bits_4(hint)
