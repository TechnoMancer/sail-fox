default Order dec

$include <smt.sail>
$include <option.sail>
$include <arith.sail>
$include <string.sail>
$include <vector_dec.sail>
$include <regfp.sail>

val string_startswith = pure "string_startswith" : (string, string) -> bool
val string_drop = pure "string_drop" : (string, nat) -> string
val string_take = pure "string_take" : (string, nat) -> string
val string_length = pure "string_length" : string -> nat
val string_append = pure { c: "concat_str", _: "string_append" } : (string, string) -> string

val spc : unit <-> string

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


type max_memory_access : Int = 2

val __read_mem_be = monadic { c: "platform_read_mem_be" }
  : forall 'n 'addrsize, 'n > 0 & 'addrsize in {32, 64}.
  (read_kind, int('addrsize), bits('addrsize), int('n)) -> bits(8 * 'n)

val read_ram = monadic { lem: "read_ram_be", coq: "read_ram_be" } : forall 'n, 0 < 'n <= max_memory_access . (bits(32), atom('n)) -> bits(8 * 'n)
function read_ram(address, width) = __read_mem_be(Read_plain, 32, address, width)
