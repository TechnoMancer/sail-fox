use foxmulator::Foxmulator;

#[test]
fn test_nop() {
  let mut foxmulator = Foxmulator::singleton().unwrap();
  
  foxmulator.run_assembly(r#"
    block (end)
    nop
    halt
    end:
  "#);

  assert_eq!(0, 0);
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
}

#[test]
fn test_b() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 3;
  foxmulator.state.r[1] = 1;
  foxmulator.run_assembly(r#"
    block (#2)
    b 6
    sub r0, r1
    sub r0, r1
    block (#1)
    halt
  "#);

  assert_eq!(foxmulator.state.r[0], 2);
}
