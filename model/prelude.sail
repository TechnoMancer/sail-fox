default Order dec

$include <smt.sail>
$include <option.sail>
$include <arith.sail>
$include <string.sail>
$include <vector_dec.sail>
$include <regfp.sail>

val bit_to_bool : bit -> bool
function bit_to_bool b = match b {
  bitone  => true,
  bitzero => false
}

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

overload operator - = {sub_vec, sub_vec_int}

val sign_extend : forall 'n 'm, 'm >= 'n. (implicit('m), bits('n)) -> bits('m)
val zero_extend : forall 'n 'm, 'm >= 'n. (implicit('m), bits('n)) -> bits('m)

function sign_extend(m, v) = sail_sign_extend(v, m)
function zero_extend(m, v) = sail_zero_extend(v, m)

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


val string_startswith = pure "string_startswith" : (string, string) -> bool
val string_drop = pure "string_drop" : (string, nat) -> string
val string_take = pure "string_take" : (string, nat) -> string
val string_length = pure "string_length" : string -> nat
val string_append = pure { c: "concat_str", _: "string_append" } : (string, string) -> string

/* helpers for mappings */

val spc : unit <-> string
val opt_spc : unit <-> string
val def_spc : unit <-> string

val "decimal_string_of_bits" : forall 'n. bits('n) -> string
val hex_bits : forall 'n . (atom('n), bits('n)) <-> string

val n_leading_spaces : string -> nat
function n_leading_spaces s =
  match s {
    "" => 0,
    _ => match string_take(s, 1) {
      " " => 1 + n_leading_spaces(string_drop(s, 1)),
      _ => 0
    }
  }

val spc_forwards : unit -> string
function spc_forwards () = " "
val spc_backwards : string -> unit
function spc_backwards s = ()
val spc_matches_prefix : string -> option((unit, nat))
function spc_matches_prefix s = {
  let n = n_leading_spaces(s);
  match n {
    0 => None(),
    _ => Some((), n)
  }
}

val opt_spc_forwards : unit -> string
function opt_spc_forwards () = ""
val opt_spc_backwards : string -> unit
function opt_spc_backwards s = ()
val opt_spc_matches_prefix : string -> option((unit, nat))
function opt_spc_matches_prefix s =
  Some((), n_leading_spaces(s))

val def_spc_forwards : unit -> string
function def_spc_forwards () = " "
val def_spc_backwards : string -> unit
function def_spc_backwards s = ()
val def_spc_matches_prefix : string -> option((unit, nat))
function def_spc_matches_prefix s = opt_spc_matches_prefix(s)

val sep : unit <-> string
mapping sep : unit <-> string = {
  () <-> opt_spc() ^ "," ^ def_spc()
}

val hex_bits_4 : bits(4) <-> string
val hex_bits_4_forwards = pure "decimal_string_of_bits" : bits(4) -> string
val hex_bits_4_forwards_matches : bits(4) -> bool
function hex_bits_4_forwards_matches bv = true
val "hex_bits_4_matches_prefix" : string -> option((bits(4), nat))
val hex_bits_4_backwards_matches : string -> bool
function hex_bits_4_backwards_matches s = match s {
  s if match hex_bits_4_matches_prefix(s) {
    Some (_, n) if n == string_length(s) => true,
    _ => false
  } => true,
  _ => false
}
val hex_bits_4_backwards : string -> bits(4)
function hex_bits_4_backwards s =
  match hex_bits_4_matches_prefix(s) {
      Some (bv, n) if n == string_length(s) => bv
  }

val hex_bits_7 : bits(7) <-> string
val hex_bits_7_forwards = pure "decimal_string_of_bits" : bits(7) -> string
val hex_bits_7_forwards_matches : bits(7) -> bool
function hex_bits_7_forwards_matches bv = true
val "hex_bits_7_matches_prefix" : string -> option((bits(7), nat))
val hex_bits_7_backwards_matches : string -> bool
function hex_bits_7_backwards_matches s = match s {
  s if match hex_bits_7_matches_prefix(s) {
    Some (_, n) if n == string_length(s) => true,
    _ => false
  } => true,
  _ => false
}
val hex_bits_7_backwards : string -> bits(7)
function hex_bits_7_backwards s =
  match hex_bits_7_matches_prefix(s) {
      Some (bv, n) if n == string_length(s) => bv
  }

val hex_bits_8 : bits(8) <-> string
val hex_bits_8_forwards = pure "decimal_string_of_bits" : bits(8) -> string
val hex_bits_8_forwards_matches : bits(8) -> bool
function hex_bits_8_forwards_matches bv = true
val "hex_bits_8_matches_prefix" : string -> option((bits(8), nat))
val hex_bits_8_backwards_matches : string -> bool
function hex_bits_8_backwards_matches s = match s {
  s if match hex_bits_8_matches_prefix(s) {
    Some (_, n) if n == string_length(s) => true,
    _ => false
  } => true,
  _ => false
}
val hex_bits_8_backwards : string -> bits(8)
function hex_bits_8_backwards s =
  match hex_bits_8_matches_prefix(s) {
      Some (bv, n) if n == string_length(s) => bv
  }

val hex_bits_16 : bits(16) <-> string
val hex_bits_16_forwards = pure "decimal_string_of_bits" : bits(16) -> string
val hex_bits_16_forwards_matches : bits(16) -> bool
function hex_bits_16_forwards_matches bv = true
val "hex_bits_16_matches_prefix" : string -> option((bits(16), nat))
val hex_bits_16_backwards_matches : string -> bool
function hex_bits_16_backwards_matches s = match s {
  s if match hex_bits_16_matches_prefix(s) {
    Some (_, n) if n == string_length(s) => true,
    _ => false
  } => true,
  _ => false
}

val read_u8_be = monadic { c: "read_u8_be" } : bits(32) -> bits(8)
val read_u16_be = monadic { c: "read_u16_be" } : bits(32) -> bits(16)
