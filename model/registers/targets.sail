register t0 : target_type
register t1 : target_type
register t2 : target_type
register t3 : target_type
register t4 : target_type
register t5 : target_type
register t6 : target_type
register link_register : target_type

val rT : forall 'n, 0 <= 'n < 8. target_number('n) -> target_type
function rT x = match x {
  0  => t0,
  1  => t1,
  2  => t2,
  3  => t3,
  4  => t4,
  5  => t5,
  6  => t6,
  7  => link_register,
  _  => { assert(false, "invalid target register number"); sign_extend(16, 0b0) }
}

val wT : forall 'n, 0 <= 'n < 8. (register_number('n), word) -> unit
function wT (x, in_v) = {
  let v = in_v;

  match x {
    0  => t0 = v,
    1  => t1 = v,
    2  => t2 = v,
    3  => t3 = v,
    4  => t4 = v,
    5  => t5 = v,
    6  => t6 = v,
    7  => link_register = v,
    _  => assert(false, "invalid target register number")
  };
}

function rT_bits(i: target_index) -> target_type = rT(unsigned(i))
function wT_bits(i: target_index, data: word) -> unit = {
  wT(unsigned(i)) = data
}

overload T = { rT_bits, wT_bits, rT, wT }

val target_name : target_index <-> string

mapping target_name = {
    0b000 <-> "t0",
    0b001 <-> "t1",
    0b010 <-> "t2",
    0b011 <-> "t3",
    0b100 <-> "t4",
    0b101 <-> "t5",
    0b110 <-> "t6",
    0b111 <-> "lr",
}

val read_target = monadic "read_target" : target_index -> target_type
val write_target = monadic "write_target" : (target_index, target_type) -> unit

function read_target_state_from_emulator () -> unit = {
  T(0b000) = read_target(0b000);
  T(0b001) = read_target(0b001);
  T(0b010) = read_target(0b010);
  T(0b011) = read_target(0b011);
  T(0b100) = read_target(0b100);
  T(0b101) = read_target(0b101);
  T(0b110) = read_target(0b110);
  T(0b111) = read_target(0b111);
}

function write_target_state_to_emulator () -> unit = {
  write_target(0b000, T(0b000));
  write_target(0b001, T(0b001));
  write_target(0b010, T(0b010));
  write_target(0b011, T(0b011));
  write_target(0b100, T(0b100));
  write_target(0b101, T(0b101));
  write_target(0b110, T(0b110));
  write_target(0b111, T(0b111));
}
