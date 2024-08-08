type word = bits(16)
type doubleword = bits(32)
type quadword = bits(64)

type register_index = bits(4)
type register_number ('n : Int), 0 <= 'n < 16 = atom('n)
type register_type = word

type predicate_index = bits(4)
type predicate_number ('n : Int), 0 <= 'n < 16 = atom('n)
type predicate_type = bits(1)

type target_index = bits(3)
type target_number ('n : Int), 0 <= 'n < 8 = atom('n)
type target_type = word

type block_length = bits(6)
type block_branch_count = bits(2)

enum Retired = { RETIRE_SUCCESS, RETIRE_FAIL }
