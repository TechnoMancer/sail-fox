val branch_extend : forall 'n 'm, 'm > 'n & 'n > 1. (implicit('m), bits('n)) -> bits('m)
val signed_extend : forall 'n 'm, 'm > 'n & 'n > 1. (implicit('m), bits('n)) -> bits('m)
val unsigned_extend : forall 'n 'm, 'm > 'n & 'n > 0. (implicit('m), bits('n)) -> bits('m)

function branch_extend(m, v) = {
  let sign = v['n - 1 .. 'n - 1];
  let magnitude = zero_extend('m, v['n - 2 .. 0] @ 0b0);

  match sign {
    0b0 => zero_extend('m, 0b10) + magnitude,
    0b1 => sign_extend('m, 0b10) - magnitude
  }
}

function signed_extend(m, v) = {
  let sign = v[0 .. 0];

  let value : bits('n) = match sign {
    0b0 => v + 1,
    0b1 => v - 1
  };

  sign_extend('m - 'n, sign) @ value
}

function unsigned_extend(m, v) = {
  zero_extend('m, v) + 1
}

val short_value_immediate : bits(4) <-> string
function short_value_immediate_forwards(value: bits(4)) -> string = dec_str(signed(value))
val short_value_immediate_backwards : string -> bits(4)
function short_value_immediate_forwards_matches(value: bits(4)) -> bool = true
val short_value_immediate_backwards_matches : string -> bool

val short_signed_immediate : bits(4) <-> string
val short_unsigned_immediate : bits(4) <-> string
