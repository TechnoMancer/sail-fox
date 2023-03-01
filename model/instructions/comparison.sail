/* n?eq rd, 0 (if p0|unless p0)? */

union clause ast = EQ_Z : (bits(1), predicate_index, register_index, predicate_index, bits(1))

mapping clause code_word = EQ_Z(op, 0b0000, rd, 0b1111, 0b1) <-> 0b0011_1111_101 @ op @ rd
mapping clause code_word = EQ_Z(op, 0b0000, rd, 0b0000, expected) <-> 0b0011_1111_11 @ expected @ op @ rd

function clause execute EQ_Z(op, pd, rd, pr, expected) = {
  let value = (R(rd) == 0b0000_0000_0000_0000);

  if P(pr) == bits_to_bool(expected) then {
    P(pd) = bits_to_bool(op);
  };

  RETIRE_SUCCESS
}

mapping clause assembly = EQ_Z(0b0, pd, rd, pr, expected) <-> "neq" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(rd) ^ sep() ^ "0" ^ predication(pr, expected)
mapping clause assembly = EQ_Z(0b1, pd, rd, pr, expected) <->  "eq" ^ spc() ^ predicate_name(pd) ^ sep() ^ register_name(rd) ^ sep() ^ "0" ^ predication(pr, expected)
