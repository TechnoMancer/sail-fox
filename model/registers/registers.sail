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

mapping register_name = {
    0b0000 <-> "r0",
    0b0001 <-> "r1",
    0b0010 <-> "r2",
    0b0011 <-> "r3",
    0b0100 <-> "r4",
    0b0101 <-> "r5",
    0b0110 <-> "r6",
    0b0111 <-> "r7",
    0b1000 <-> "r8",
    0b1001 <-> "r9",
    0b1010 <-> "r10",
    0b1011 <-> "r11",
    0b1100 <-> "r12",
    0b1101 <-> "r13",
    0b1110 <-> "r14",
    0b1111 <-> "r15"
}

val read_register = monadic "read_register" : register_index -> register_type
val write_register = monadic "write_register" : (register_index, register_type) -> unit

function read_register_state_from_emulator () -> unit = {
  R(0b0000) = read_register(0b0000);
  R(0b0001) = read_register(0b0001);
  R(0b0010) = read_register(0b0010);
  R(0b0011) = read_register(0b0011);
  R(0b0100) = read_register(0b0100);
  R(0b0101) = read_register(0b0101);
  R(0b0110) = read_register(0b0110);
  R(0b0111) = read_register(0b0111);
  R(0b1000) = read_register(0b1000);
  R(0b1001) = read_register(0b1001);
  R(0b1010) = read_register(0b1010);
  R(0b1011) = read_register(0b1011);
  R(0b1100) = read_register(0b1100);
  R(0b1101) = read_register(0b1101);
  R(0b1110) = read_register(0b1110);
  R(0b1111) = read_register(0b1111);
}

function write_register_state_to_emulator () -> unit = {
  write_register(0b0000, R(0b0000));
  write_register(0b0001, R(0b0001));
  write_register(0b0010, R(0b0010));
  write_register(0b0011, R(0b0011));
  write_register(0b0100, R(0b0100));
  write_register(0b0101, R(0b0101));
  write_register(0b0110, R(0b0110));
  write_register(0b0111, R(0b0111));
  write_register(0b1000, R(0b1000));
  write_register(0b1001, R(0b1001));
  write_register(0b1010, R(0b1010));
  write_register(0b1011, R(0b1011));
  write_register(0b1100, R(0b1100));
  write_register(0b1101, R(0b1101));
  write_register(0b1110, R(0b1110));
  write_register(0b1111, R(0b1111));
}
