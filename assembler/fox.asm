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
  p8 => 0x8
  p9 => 0x9
  p10 => 0xA
  p11 => 0xB
  p12 => 0xC
  p13 => 0xD
  p14 => 0xE
  p15 => 0xF
  pa => 0xA
  pb => 0xB
  pc => 0xC
  pd => 0xD
  pe => 0xE
  pf => 0xF
}

#subruledef capability {
  c0 => 0x0
  c1 => 0x1
  c2 => 0x2
  c3 => 0x3
  c4 => 0x4
  c5 => 0x5
  c6 => 0x6
  c7 => 0x7
  c8 => 0x8
  c9 => 0x9
  c10 => 0xA
  c11 => 0xB
  c12 => 0xC
  c13 => 0xD
  c14 => 0xE
  c15 => 0xF
  ca => 0xA
  cb => 0xB
  cc => 0xC
  cd => 0xD
  ce => 0xE
  cf => 0xF
}

#subruledef short_capability {
  c0 => 0x0`3
  c1 => 0x1`3
  c2 => 0x2`3
  c3 => 0x3`3
  c12 => 0x4`3
  c13 => 0x5`3
  c14 => 0x6`3
  c15 => 0x7`3
  cc => 0x4`3
  cd => 0x5`3
  ce => 0x6`3
  cf => 0x7`3
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

#ruledef fox {
  invalid => 0x0000
  halt => 0x0001
  nop  => 0x0010

  b {imm: short_relative_address} => 0x01 @ imm;
  b {imm: short_relative_address} unless p0 => 0x02 @ imm;
  b {imm: short_relative_address} if p0 => 0x03 @ imm;

  block {imm: short_block_length} => 0x04 @ 0x0`1 @ 0x0`2 @ imm
  block.s {imm: short_block_length} => 0x04 @ 0x01`1 @ 0x0`2 @ imm

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
  and {rd: register}, {ra: register} => 0x28 @ ra @ rd
  andc {rd: register}, {ra: register} => 0x29 @ ra @ rd
  or {rd: register}, {ra: register} => 0x2A @ ra @ rd
  xor {rd: register}, {ra: register} => 0x2B @ ra @ rd
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

| eq rd, 0 unless p0  | 0011 1111 1100 dddd |                         |        |
| neq rd, 0 unless p0 | 0011 1111 1101 dddd |                         |        |
| eq rd, 0 if p0      | 0011 1111 1110 dddd |                         |        |
| neq rd, 0 if p0     | 0011 1111 1111 dddd |                         |        |

  st {cb: short_capability}[{ra: register}], {rd: register} => 0x4 @ 0x1`1 @ cb @ ra @ rd
  ld.w {rd: register}, {cb: short_capability}[{ra: register}] => 0x5 @ 0x0`1 @ cb @ ra @ rd
  
  st {ca: short_capability}[{imm: u4}], {rd: register} => 0x8 @ 0x1`1 @ ca @ imm @ rd
  ld.w {rd: register}, {cb: short_capability}[{imm: u4}] => 0x9 @ 0x0`1 @ ca @ imm @ rd
}
