union clause ast = BRANCH_S : bits(8)

mapping clause code_word = BRANCH_S(immediate) <-> 0b0000_0001 @ immediate

function clause execute BRANCH_S(immediate) = { /* TODO: How to decode immediate?; */ RETIRE_SUCCESS }

/* TODO: This is clearly wrong, obviously but it is good enough for now */
mapping clause assembly = BRANCH_S(immediate) <-> "b" ^ spc() ^ hex_bits_8(immediate)
