/* eq rd, 0 */

union clause ast = EQ_Z : (predicate_index, register_index, predicate_index, bits(1))

mapping clause code_word = EQ_Z(0b0000, rd, 0b1111, 0b1) <-> 0b0011_1111_1010 @ rd
mapping clause code_word = EQ_Z(0b0000, rd, 0b0000, expected) <-> 0b0011_1111_11 @ expected @ 0b0 @ rd

function clause execute EQ_Z(pd, rd, pr, expected) = {
  let value = (R(rd) == 0b0000_0000_0000_0000);

  if P(pr) == bits_to_bool(expected) then {
    P(pd) = value;
  };

  RETIRE_SUCCESS
}

mapping clause assembly = EQ_Z(pd, rd, pr, expected) <-> "eq" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(rd) ^ sep() ^ "0" ^ predication(pr, expected)

/* neq rd, 0 */

union clause ast = NEQ_Z : (predicate_index, register_index, predicate_index, bits(1))

mapping clause code_word = NEQ_Z(0b0000, rd, 0b1111, 0b1) <-> 0b0011_1111_1011 @ rd
mapping clause code_word = NEQ_Z(0b0000, rd, 0b0000, expected) <-> 0b0011_1111_11 @ expected @ 0b1 @ rd

function clause execute NEQ_Z(pd, rd, pr, expected) = {
  let value = (R(rd) != 0b0000_0000_0000_0000);

  if P(pr) == bits_to_bool(expected) then {
    P(pd) = value;
  };

  RETIRE_SUCCESS
}

mapping clause assembly = NEQ_Z(pd, rd, pr, expected) <-> "neq" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(rd) ^ sep() ^ "0" ^ predication(pr, expected)
