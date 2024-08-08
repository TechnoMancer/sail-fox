#once

#subruledef register {
  r0 => 0x0
  r1 => 0x1
  r2 => 0x2
  r3 => 0x3
  r4 => 0x4
  r5 => 0x5
  r6 => 0x6
  r7 => 0x7
  r8 => 0x8
  r9 => 0x9
  r10 => 0xA
  r11 => 0xB
  r12 => 0xC
  r13 => 0xD
  r14 => 0xE
  r15 => 0xF
  ra => 0xA
  rb => 0xB
  rc => 0xC
  rd => 0xD
  re => 0xE
  rf => 0xF
}

#subruledef predicate {
  p0 => 0x0
  p1 => 0x1
  p2 => 0x2
  p3 => 0x3
  p4 => 0x4
  p5 => 0x5
  p6 => 0x6
  true => 0x7
  !p0 => 0x8
  !p1 => 0x9
  !p2 => 0xA
  !p3 => 0xB
  !p4 => 0xC
  !p5 => 0xD
  !p6 => 0xE
}

#subruledef target {
  t0 => 0x0
  t1 => 0x1
  t2 => 0x2
  t3 => 0x3
  t4 => 0x4
  t5 => 0x5
  t6 => 0x6
  lr => 0x7
}

#subruledef short_block_length {
  {words: u16} => {
    assert(words >= 0)
    assert(words <= 0x1F)

    words`5
  }
}

#subruledef short_relative_address {
	{address: u16} => {
    assert(address % 2 == 0)

		relative = address - $
    result = relative >> 1

		assert(result >= -0x80)
		assert(result <=  0x7F)

		result`8
	}
}

#subruledef block_end_address {
  {address: u16} => {
    assert(address % 2 == 0, "Unaligned end of block")

    relative = address - $
    assert(relative >= 0, "End of block must be after block")
    word_count = relative >> 1
    assert(word_count > 0, "Block cannot be empty")

    word_count
  }
}

#subruledef block_branch_count {
  {count: u2} =>
    count`2
}

#subruledef medium_relative_address {
  {address: u17} => {
    assert(address % 2 == 0, "Unaligned target label")

    relative = address - $
    target = relative >> 1

    assert(target > -65536, "Target label too far before")
    assert(target < 65535, "Target label too far after")

    target`16
  }
}

#fn make_block_length(words) => {
  assert(words > 0, "Block cannot be empty")
  assert(words <= 64, "Black cannot be longer than 64")
  (words - 1)`6
}

#ruledef fox {
  invalid => 0x0000
; Temporarily use a reserved instruction as an explicit expected halt request to the emulator model until
; somethng that can reasonably signal this in general.
; | 0000 1111 dddd aaaa | reserved
  halt => 0x0F00
  nop  => 0x0010

; Hybrid

; | 0010 1111 bbnn nnnn | block (b = branch count, n = instruction word count)
  block ({branches: block_branch_count}, #{words: u7}) => 
    0b0010_1111 @ branches @ make_block_length(words)`6

  ; Block length does not include block insn
  block ({branches: block_branch_count}, {end: block_end_address}) => 
    0b0010_1111 @ branches @ make_block_length(end - 1)`6

  block (#{words: u7}) =>
    0b0010_1111 @ 0`2 @ make_block_length(words)`6
  ; Block length does not include block insn
  block ({end: block_end_address}) => 
    0b0010_1111 @ 0`2 @ make_block_length(end - 1)`6


; | 1100 0010 bbnn nnnn iiii iiii iiii iiii | block (b = branch count, n = instruction word count), t1 = block + simm << 1
  block ({branches: block_branch_count}, #{words: u6}) {target: medium_relative_address} =>
    0b1100_0010 @ branches @ make_block_length(words) @ target
  ; Block lenght does not include block insn
  block ({branches: block_branch_count}, {end: block_end_address}) {target: medium_relative_address} => 
    0b1100_0010 @ branches @ make_block_length(end - 2)`6 @ target

  block (#{words: u6}) {target: medium_relative_address} =>
    0b1100_0010 @ 0`2 @ make_block_length(words) @ target
  ; Block lenght does not include block insn
  block ({end: block_end_address}) {target: medium_relative_address} => 
    0b1100_0010 @ 0`2 @ make_block_length(end - 2)`6 @ target

; | 0001 0000 dddd aaaa | and rd, ra
and {rd: register}, {ra: register} => 0b0001_0000 @ rd @ra
; | 0001 0001 dddd aaaa | or rd, ra
or {rd: register}, {ra: register} => 0b0001_0001 @ rd @ra
; | 0001 0010 dddd aaaa | xor rd, ra
xor {rd: register}, {ra: register} => 0b0001_0010 @ rd @ ra
; | 0001 0011 dddd aaaa | andc rd, ra
andc {rd: register}, {ra: register} => 0b0001_0011 @ rd @ ra

  b {imm: short_relative_address} => 0x01 @ imm;
  b {imm: short_relative_address} unless p0 => 0x02 @ imm;
  b {imm: short_relative_address} if p0 => 0x03 @ imm;

  ; add l0 looping flags

  bl {imm: short_relative_address} => 0x05 @ imm
  bl {imm: short_relative_address} unless p0 => 0x06 @ imm
  bl {imm: short_relative_address} if p0 => 0x07 @ imm

  add {rd: register}, {imm: u4} => 0x10 @ imm @ rd
  sub {rd: register}, {imm: u4} => 0x11 @ imm @ rd
  ; and {rd: register}, {imm: i4} => 0x12 @ imm @ rd
  set.w {rd: register}, {imm: i4} => 0x15 @ imm @ rd
  
  mov {rd: register}, {ra: register} => 0x20 @ ra @ rd
  
  add {rd: register}, {ra: register} => 0x24 @ ra @ rd
  sub {rd: register}, {ra: register} => 0x25 @ ra @ rd
  subf {rd: register}, {ra: register} => 0x26 @ ra @ rd
  lt {rd: register}, {ra: register} => 0x2C @ ra @ rd
  lte {rd: register}, {ra: register} => 0x2D @ ra @ rd
  lt.u {rd: register}, {ra: register} => 0x2E @ ra @ rd
  lte.u {rd: register}, {ra: register} => 0x2F @ ra @ rd
  eq {rd: register}, {ra: register} => 0x30 @ ra @ rd
  neq {rd: register}, {ra: register} => 0x31 @ ra @ rd
  
  blr {rd: register} => 0x3F @ 0x0 @ rd
  b {rd: register} => 0x3F @ 0x1 @ rd
  b {rd: register} unless p0 => 0x3F @ 0x2 @ rd
  b {rd: register} if p0 => 0x3F @ 0x3 @ rd
  
  eq {rd: register}, 0 => 0x3F @ 0xA @ rd
  neq {rd: register}, 0 => 0x3F @ 0xB @ rd

  eq {rd: register}, 0 unless p0 => 0x3F @ 0xC @ rd
  neq {rd: register}, 0 unless p0 => 0x3F @ 0xD @ rd
  eq {rd: register}, 0 if p0 => 0x3F @ 0xE @ rd
  neq {rd: register}, 0 if p0 => 0x3F @ 0xF @ rd

;| eq rd, 0 unless p0  | 0011 1111 1100 dddd |                         |        |
;| neq rd, 0 unless p0 | 0011 1111 1101 dddd |                         |        |
;| eq rd, 0 if p0      | 0011 1111 1110 dddd |                         |        |
;| neq rd, 0 if p0     | 0011 1111 1111 dddd |                         |        |

}
