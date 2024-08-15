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
  p7 => 0x7
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
  t7 => 0x7
  link => 0x5
  next => 0x6
  current => 0x7
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

#ruledef block_target_offset {
  targ_helper {address}, {block_start}, {block_end} => {
    assert(address <= block_start)
    offset = address - block_start
    target = offset >> 1
    target`32
  }
  targ_helper {address}, {block_start}, {block_end} => {
    assert(address >= block_end)
    offset = address - block_end + 2
    target = offset >> 1
    target`32
  }
  targ_helper {address}, {block_start}, {block_end} => {
    assert (false, "Target address cannot reside within current block")
  }
}

#ruledef fox {
  invalid => 0x0000
; Temporarily use a reserved instruction as an explicit expected halt request to the emulator model until
; somethng that can reasonably signal this in general.
; | 0000 1111 dddd aaaa | reserved
  halt => 0x0F00
  nop  => asm { and r0, r0 }

; Hybrid

; | 0010 0000 dddd iiii | set rd, imm + 1
; | 0010 0001 dddd iiii | set rd, -(imm + 1)
; | 1100 0100 dddd 0001 iiii iiii iiii iiii | set rd, simm
; Synthetic composite set instruction to set a register to an immediate however it can, 0 is set by way of xor
set {rd: register}, 0 => asm { xor {rd}, {rd} }
set {rd: register}, {val: s6} => {
  assert (val <= 16)
  assert (val > 0)
  0b0010_0000 @ rd @ (val - 1)`4
}
set {rd: register}, {val: s5} => {
  assert (val < 0)
  assert (val >= -16)
  0b0010_0001 @ rd @ ((-val) - 1)`4
}
set {rd: register}, {val: i16} => {
  0b1100_0100 @ rd @ 0b0001 @ val
}

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
  block ({branches: block_branch_count}, #{words: u7}) {target: medium_relative_address} => {
    offset = asm {targ_helper {target}, $, $+({words}<<1)}
    0b1100_0010 @ branches @ make_block_length(words) @ offset`16
  }
  ; Block lenght does not include block insn
  block ({branches: block_branch_count}, {end: block_end_address}) {target: medium_relative_address} => {
    offset = asm {targ_helper {target}, $, {end}}
    0b1100_0010 @ branches @ make_block_length(end - 2)`6 @ offset`16
  }

  block (#{words: u7}) {target} => {
    offset = asm {targ_helper {target}, $, $+({words}<<1)}
    ;assert(offset < 65535, "Block target too far")
    ;assert(offset > -32768, "Block target too far")
    0b1100_0010 @ 0`2 @ make_block_length(words) @ offset`16
  }
  ; Block lenght does not include block insn
  block ({end: block_end_address}) {target} => {
    offset = asm {targ_helper {target}, $, {end}}
    ;assert(offset < 65535, "Block target too far")
    0b1100_0010 @ 0`2 @ make_block_length(end - 2)`6 @ offset`16
  }

; Single Word ISA

; | 0000 0000 dddd aaaa | mov rd, ra (rd = ra is reserved)

  mov {rd: register}, {ra: register} => {
    assert(rd != ra, "Mov to self is forbidden")
    0b0000_0000 @ rd @ ra
    }

; | 0000 0001 dddd aaaa | not rd, ra
  not {rd: register}, {ra: register} => 0b0000_0001 @ rd @ ra
; | 0000 0010 dddd aaaa | neg rd, ra
  neg {rd: register}, {ra: register} => 0b0000_0010 @ rd @ ra
; | 0000 1011 0ddd pppp | b td (predicated)
  b {td: target} if {p: predicate} => 0b0000_1011 @ 0b0 @ td`3 @ p`4
; short for always branch
  b {td: target} => 0b0000_1011 @ 0b0 @ td`3 @ 0b0111
; | 0000 1011 1ddd pppp | call td (predicated)
  call {td: target} if {p: predicate} => 0b0000_1011 @ 0b1 @ td`3 @ p`4
; short for always branch
  call {td: target} => 0b0000_1011 @ 0b1 @ td`3 @ 0b0111
; | 0001 0000 dddd aaaa | and rd, ra
  and {rd: register}, {ra: register} => 0b0001_0000 @ rd @ra
; | 0001 0001 dddd aaaa | or rd, ra
  or {rd: register}, {ra: register} => 0b0001_0001 @ rd @ra
; | 0001 0010 dddd aaaa | xor rd, ra
  xor {rd: register}, {ra: register} => 0b0001_0010 @ rd @ ra
; | 0001 0011 dddd aaaa | andc rd, ra
  andc {rd: register}, {ra: register} => 0b0001_0011 @ rd @ ra


  add {rd: register}, {imm: u4} => 0x10 @ imm @ rd
  sub {rd: register}, {imm: u4} => 0x11 @ imm @ rd
  
  add {rd: register}, {ra: register} => 0x24 @ ra @ rd
  sub {rd: register}, {ra: register} => 0x25 @ ra @ rd
  subf {rd: register}, {ra: register} => 0x26 @ ra @ rd
  lt {rd: register}, {ra: register} => 0x2C @ ra @ rd
  lte {rd: register}, {ra: register} => 0x2D @ ra @ rd
  lt.u {rd: register}, {ra: register} => 0x2E @ ra @ rd
  lte.u {rd: register}, {ra: register} => 0x2F @ ra @ rd
  eq {rd: register}, {ra: register} => 0x30 @ ra @ rd
  neq {rd: register}, {ra: register} => 0x31 @ ra @ rd
  
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
