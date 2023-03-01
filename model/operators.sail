
infix 7 >>
infix 7 <<

val "shift_bits_right" : forall 'n 'm. (bits('n), bits('m)) -> bits('n)
val "shift_bits_left"  : forall 'n 'm. (bits('n), bits('m)) -> bits('n)

val "shiftl" : forall 'm 'n, 'n >= 0. (bits('m), atom('n)) -> bits('m)
val "shiftr" : forall 'm 'n, 'n >= 0. (bits('m), atom('n)) -> bits('m)

overload operator >> = { shift_bits_right, shiftr }
overload operator << = { shift_bits_left, shiftl }

val sub_vec = pure { c: "sub_bits", _: "sub_vec" } : forall 'n. (bits('n), bits('n)) -> bits('n)
val sub_vec_int = pure { c: "sub_bits_int", _: "sub_vec_int" } : forall 'n. (bits('n), int) -> bits('n)

overload operator - = { sub_vec, sub_vec_int }

val not_bit : bit -> bit

function not_bit(b) = if b == bitone then bitzero else bitone

overload ~ = { not_bool, not_vec, not_bit }

overload operator & = { and_vec }

overload operator | = { or_vec }

function xor_bool(a: bool, b: bool) -> bool = {
  a != b
}

overload operator ^ = { xor_vec, xor_bool }

infix 4 >_s
infix 4 <_s
infix 4 >=_s
infix 4 <=_s

val operator >_s  : forall 'n, 'n > 0. (bits('n), bits('n)) -> bool
val operator <_s  : forall 'n, 'n > 0. (bits('n), bits('n)) -> bool
val operator >=_s : forall 'n, 'n > 0. (bits('n), bits('n)) -> bool
val operator <=_s : forall 'n, 'n > 0. (bits('n), bits('n)) -> bool

function operator >_s  (x, y) = signed(x) > signed(y)
function operator <_s  (x, y) = signed(x) < signed(y)
function operator >=_s (x, y) = signed(x) >= signed(y)
function operator <=_s (x, y) = signed(x) <= signed(y)

infix 4 >_u
infix 4 <_u
infix 4 >=_u
infix 4 <=_u

val operator >_u  : forall 'n. (bits('n), bits('n)) -> bool
val operator <_u  : forall 'n. (bits('n), bits('n)) -> bool
val operator >=_u : forall 'n. (bits('n), bits('n)) -> bool
val operator <=_u : forall 'n. (bits('n), bits('n)) -> bool

function operator >_u  (x, y) = unsigned(x) > unsigned(y)
function operator <_u  (x, y) = unsigned(x) < unsigned(y)
function operator >=_u (x, y) = unsigned(x) >= unsigned(y)
function operator <=_u (x, y) = unsigned(x) <= unsigned(y)
