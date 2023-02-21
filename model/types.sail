type word = bits(16)

type register_index = bits(4)
type register_number ('n : Int), 0 <= 'n < 16 = atom('n)

enum Retired = { RETIRE_SUCCESS, RETIRE_FAIL }
