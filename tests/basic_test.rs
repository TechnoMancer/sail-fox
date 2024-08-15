use foxmulator::Foxmulator;
use foxmulator::HaltReason;

#[test]
fn test_nop() {
  let mut foxmulator = Foxmulator::singleton().unwrap();
  
  foxmulator.run_assembly(r#"
    block (end)
    nop
    halt
    end:
  "#);

  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
}

#[test]
fn test_add() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 2;
  foxmulator.state.r[1] = 1;
  foxmulator.run_assembly(r#"
    block (end)
    add r0, r1
    halt
    end:
  "#);

  assert_eq!(foxmulator.state.r[0], 3);
  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
}

#[test]
fn test_sub() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 3;
  foxmulator.state.r[1] = 1;
  foxmulator.run_assembly(r#"
    block (end)
    sub r0, r1
    halt
    end:
  "#);

  assert_eq!(foxmulator.state.r[0], 2);
  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
}

#[test]
fn test_and() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 0b1010;
  foxmulator.state.r[1] = 0b1100;
  foxmulator.run_assembly(r#"
    block (end)
    and r0, r1
    halt
    end:
  "#);

  assert_eq!(foxmulator.state.r[0], 0b1000);
  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
}

#[test]
fn test_or() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 0b1010;
  foxmulator.state.r[1] = 0b1100;
  foxmulator.run_assembly(r#"
    block (end)
    or r0, r1
    halt
    end:
  "#);

  assert_eq!(foxmulator.state.r[0], 0b1110);
  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
}

#[test]
fn test_xor() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 0b1010;
  foxmulator.state.r[1] = 0b1100;
  foxmulator.run_assembly(r#"
    block (end)
    xor r0, r1
    halt
    end:
  "#);

  assert_eq!(foxmulator.state.r[0], 0b0110);
  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
}

#[test]
fn test_andc() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 0b1010;
  foxmulator.state.r[1] = 0b1100;
  foxmulator.run_assembly(r#"
    block (end)
    andc r0, r1
    halt
    end:
  "#);

  assert_eq!(foxmulator.state.r[0], 0b0010);
  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
}

#[test]
fn test_not() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 0b1010_1010_1111_1111;
  foxmulator.state.r[1] = 0b1100_1100_0011_0011;
  foxmulator.run_assembly(r#"
    block (end)
    not r0, r1
    halt
    end:
  "#);

  assert_eq!(foxmulator.state.r[0], 0b0011_0011_1100_1100);
  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
}

#[test]
fn test_neg() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 54;
  foxmulator.state.r[1] = 28;
  foxmulator.run_assembly(r#"
    block (end)
    neg r0, r1
    halt
    end:
  "#);

  assert_eq!(foxmulator.state.r[0], -28_i16 as u16);
  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
}

#[test]
fn test_bswap() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 0xcafe;
  foxmulator.state.r[1] = 0xbeef;
  foxmulator.run_assembly(r#"
    block (end)
    byteswap r2, r0
    byteswap r1, r1
    halt
    end:
  "#);

  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
  assert_eq!(foxmulator.state.r[0], 0xcafe);
  assert_eq!(foxmulator.state.r[1], 0xefbe);
  assert_eq!(foxmulator.state.r[2], 0xfeca);
}

#[test]
fn test_set() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 0xcafe;
  foxmulator.run_assembly(r#"
    block (end)
    set r0, 0
    set r1, 1
    set r2, -1
    set r3, 15
    set r4, -15
    set r5, 16
    set r6, -16
    set r7, 0xffff
    set r8, 0xcafe
    set r9, 0xff
    set r10, 0xff00
    set r11, -100
    set r12, -30000
    halt
    end:
  "#);

  assert_eq!(foxmulator.state.r[0], 0);
  assert_eq!(foxmulator.state.r[1], 1);
  assert_eq!(foxmulator.state.r[2], (-1i16) as u16);
  assert_eq!(foxmulator.state.r[3], 15);
  assert_eq!(foxmulator.state.r[4], (-15i16) as u16);
  assert_eq!(foxmulator.state.r[5], 16);
  assert_eq!(foxmulator.state.r[6], (-16i16) as u16);
  assert_eq!(foxmulator.state.r[7], 0xffff);
  assert_eq!(foxmulator.state.r[8], 0xcafe);
  assert_eq!(foxmulator.state.r[9], 0x00ff);
  assert_eq!(foxmulator.state.r[10], 0xff00);
  assert_eq!(foxmulator.state.r[11], (-100i16) as u16);
  assert_eq!(foxmulator.state.r[12], (-30000i16) as u16);
  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
}

#[test]
fn test_block() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 3;
  foxmulator.state.r[1] = 1;
  foxmulator.run_assembly(r#"
    block (0, end) next
    nop
    sub r0, r1
    end:
    block (next)
    sub r0, r1
    next:
    block (#1)
    halt
  "#);

  assert_eq!(foxmulator.state.r[0], 1);
  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
}

#[test]
fn test_b() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 3;
  foxmulator.state.r[1] = 1;
  foxmulator.run_assembly(r#"
    block (1, end) next
    b t0
    sub r0, r1
    end:
    block (next)
    sub r0, r1
    next:
    block (#1)
    halt
  "#);

  assert_eq!(foxmulator.state.r[0], 2);
  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
}

#[test]
fn test_mov() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 0xcafe;
  foxmulator.state.r[1] = 0xbeef;

  foxmulator.run_assembly(r#"
    block (end)
    mov r2, r0
    mov r15, r2
    mov r2, r1
    mov r14, r2
    mov r3, r2
    mov r5, r1
    mov r10, r0
    halt
    end:
  "#);

  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
  assert_eq!(foxmulator.state.r[0], 0xcafe);
  assert_eq!(foxmulator.state.r[1], 0xbeef);
  assert_eq!(foxmulator.state.r[15], 0xcafe);
  assert_eq!(foxmulator.state.r[14], 0xbeef);
  assert_eq!(foxmulator.state.r[2], 0xbeef);
  assert_eq!(foxmulator.state.r[3], 0xbeef);
  assert_eq!(foxmulator.state.r[5], 0xbeef);
  assert_eq!(foxmulator.state.r[10], 0xcafe);
}

#[test]
fn test_call() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.run_assembly(r#"
    block (1, end) test
    call t0
    end:
    block (end2)
    set r0, 1
    halt
    end2:
    test:
    block (end3)
    set r0, 2
    halt
    end3:
  "#);

  assert_eq!(foxmulator.state.halt_reason, HaltReason::Halt);
  assert_eq!(foxmulator.state.r[0], 2);
  assert_eq!(foxmulator.state.t[5], 6);
}
