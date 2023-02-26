type word = bits(16)

type register_index = bits(4)
type register_number ('n : Int), 0 <= 'n < 16 = atom('n)
type register_type = word

type predicate_index = bits(4)
type predicate_number ('n : Int), 0 <= 'n < 16 = atom('n)
type predicate_type = bits(1)

enum Retired = { RETIRE_SUCCESS, RETIRE_FAIL }
