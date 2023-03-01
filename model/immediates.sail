val branch_extend : forall 'n 'm, 'm > 'n & 'n > 0. (implicit('m), bits('n)) -> bits('m)
val signed_extend : forall 'n 'm, 'm > 'n & 'n > 0. (implicit('m), bits('n)) -> bits('m)
val unsigned_extend : forall 'n 'm, 'm > 'n & 'n > 0. (implicit('m), bits('n)) -> bits('m)

function branch_extend(m, v) = {
  let sign = v[0 .. 0];

  let value : bits('n) = match sign {
    0b0 => v + 1,
    0b1 => v - 2
  };

  (sign_extend('m - 'n, sign) @ value) << 1
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
  zero_extend(m, v) + 1
}
