use foxmulator::Foxmulator;

#[test]
fn test_nop() {
  let mut foxmulator = Foxmulator::singleton().unwrap();
  
  foxmulator.run_assembly(r#"
    nop
    halt
  "#);

  assert_eq!(0, 0);
}

#[test]
fn test_add() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 2;
  foxmulator.state.r[1] = 1;
  foxmulator.run_assembly(r#"
    add r0, r1
    halt
  "#);

  assert_eq!(foxmulator.state.r[0], 3);
}

#[test]
fn test_sub() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  foxmulator.state.r[0] = 3;
  foxmulator.state.r[1] = 1;
  foxmulator.run_assembly(r#"
    sub r0, r1
    halt
  "#);

  assert_eq!(foxmulator.state.r[0], 2);
}
