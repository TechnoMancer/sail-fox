register p0 : predicate_type
register p1 : predicate_type
register p2 : predicate_type
register p3 : predicate_type
register p4 : predicate_type
register p5 : predicate_type
register p6 : predicate_type
register p7 : predicate_type
register p8 : predicate_type
register p9 : predicate_type
register p10 : predicate_type
register p11 : predicate_type
register p12 : predicate_type
register p13 : predicate_type
register p14 : predicate_type
let true_register : predicate_type = 0b1

val rP : forall 'n, 0 <= 'n < 16. predicate_number('n) -> bool
function rP x = bits_to_bool(match x {
  0  => p0,
  1  => p1,
  2  => p2,
  3  => p3,
  4  => p4,
  5  => p5,
  6  => p6,
  7  => p7,
  8  => p8,
  9  => p9,
  10 => p10,
  11 => p11,
  12 => p12,
  13 => p13,
  14 => p14,
  15 => true_register,
  _  => { assert(false, "invalid predicate number"); true_register }
})

val wP : forall 'n, 0 <= 'n < 16. (predicate_number('n), bool) -> unit
function wP (x, in_v) = {
  let v = bool_to_bits(in_v);

  match x {
    0  => p0 = v,
    1  => p1 = v,
    2  => p2 = v,
    3  => p3 = v,
    4  => p4 = v,
    5  => p5 = v,
    6  => p6 = v,
    7  => p7 = v,
    8  => p8 = v,
    9  => p9 = v,
    10 => p10 = v,
    11 => p11 = v,
    12 => p12 = v,
    13 => p13 = v,
    14 => p14 = v,
    15 => (),
    _  => assert(false, "invalid predicate number")
  };
}

function rP_bits(i: predicate_index) -> bool = rP(unsigned(i))
function wP_bits(i: predicate_index, data: bool) -> unit = {
  wP(unsigned(i)) = data
}

overload P = {
  rP_bits, wP_bits,
  rP, wP
}

val predicate_name : predicate_index <-> string
val predication : (predicate_index, bits(1)) <-> string
