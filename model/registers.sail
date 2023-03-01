register r0 : register_type
register r1 : register_type
register r2 : register_type
register r3 : register_type
register r4 : register_type
register r5 : register_type
register r6 : register_type
register r7 : register_type
register r8 : register_type
register r9 : register_type
register r10 : register_type
register r11 : register_type
register r12 : register_type
register r13 : register_type
register r14 : register_type
register r15 : register_type

val rR : forall 'n, 0 <= 'n < 16. register_number('n) -> register_type
function rR x = match x {
  0  => r0,
  1  => r1,
  2  => r2,
  3  => r3,
  4  => r4,
  5  => r5,
  6  => r6,
  7  => r7,
  8  => r8,
  9  => r9,
  10 => r10,
  11 => r11,
  12 => r12,
  13 => r13,
  14 => r14,
  15 => r15,
  _  => { assert(false, "invalid register number"); sign_extend(16, 0b0) }
}

val wR : forall 'n, 0 <= 'n < 16. (register_number('n), word) -> unit
function wR (x, in_v) = {
  let v = in_v;

  match x {
    0  => r0 = v,
    1  => r1 = v,
    2  => r2 = v,
    3  => r3 = v,
    4  => r4 = v,
    5  => r5 = v,
    6  => r6 = v,
    7  => r7 = v,
    8  => r8 = v,
    9  => r9 = v,
    10 => r10 = v,
    11 => r11 = v,
    12 => r12 = v,
    13 => r13 = v,
    14 => r14 = v,
    15 => r15 = v,
    _  => assert(false, "invalid register number")
  };
}

function rR_bits(i: register_index) -> register_type = rR(unsigned(i))
function wR_bits(i: register_index, data: word) -> unit = {
  wR(unsigned(i)) = data
}

overload R = { rR_bits, wR_bits, rR, wR }

val register_name : register_index <-> string

register halted : bool

register instruction_address : bits(32)
register instruction_address_next : bits(32)

register instructions_retired : bits(32)

function retire_instruction() -> unit = {
  instructions_retired = instructions_retired + 1
}
