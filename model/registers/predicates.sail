register p0 : predicate_type
register p1 : predicate_type
register p2 : predicate_type
register p3 : predicate_type
register p4 : predicate_type
register p5 : predicate_type
register p6 : predicate_type
let true_register : predicate_type = 0b1

val rP : forall 'n, 0 <= 'n < 8. predicate_number('n) -> bool
function rP x = bits_to_bool(match x {
  0  => p0,
  1  => p1,
  2  => p2,
  3  => p3,
  4  => p4,
  5  => p5,
  6  => p6,
  7 => true_register,
  _  => { assert(false, "invalid predicate number"); true_register }
})

val wP : forall 'n, 0 <= 'n < 8. (predicate_number('n), bool) -> unit
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
    7 => (),
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

mapping predicate_name = {
    0b000 <-> "p0",
    0b001 <-> "p1",
    0b010 <-> "p2",
    0b011 <-> "p3",
    0b100 <-> "p4",
    0b101 <-> "p5",
    0b110 <-> "p6",
    0b111 <-> "true",
}

union instruction_predicate = {
  Always : unit,
  Predicate : predicate_index,
  InversePredicate : predicate_index,
}

val predication : instruction_predicate <-> string
mapping predication = {
  Always() <-> "true",
  Predicate(pr) <-> predicate_name(pr),
  InversePredicate(0b111) <-> "reserved",
  InversePredicate(pr) <-> "!" ^ predicate_name(pr),
}

let always : predicate_encoding = 0b0111

val predicate_decode : predicate_encoding <-> option(instruction_predicate)
mapping predicate_decode = {
  0b1 @ 0b111 <-> None(),
  0b0 @ pr : predicate_index <-> Some(Predicate(pr)),
  0b1 @ pr : predicate_index <-> Some(InversePredicate(pr)),
}

val predicate_interp : instruction_predicate <-> (predicate_index, predicate_type)
mapping predicate_interp = {
  Always() <-> (0b111, 0b1),
  Predicate(pr) <-> (pr, 0b1),
  InversePredicate(pr) <-> (pr, 0b0),
}

val read_predicate = monadic "read_predicate" : predicate_index -> bool
val write_predicate = monadic "write_predicate" : (predicate_index, bool) -> unit

function read_predicate_state_from_emulator () -> unit = {
  P(0b000) = read_predicate(0b000);
  P(0b001) = read_predicate(0b001);
  P(0b010) = read_predicate(0b010);
  P(0b011) = read_predicate(0b011);
  P(0b100) = read_predicate(0b100);
  P(0b101) = read_predicate(0b101);
  P(0b110) = read_predicate(0b110);
}

function write_predicate_state_to_emulator () -> unit = {
  write_predicate(0b000, P(0b000));
  write_predicate(0b001, P(0b001));
  write_predicate(0b010, P(0b010));
  write_predicate(0b011, P(0b011));
  write_predicate(0b100, P(0b100));
  write_predicate(0b101, P(0b101));
  write_predicate(0b110, P(0b110));
}
