use foxmulator::{Foxmulator, State};

#[test]
fn test_nop() {
  let mut foxmulator = Foxmulator::singleton().unwrap();
  
  foxmulator.map_assembly(0, "nop\nhalt").unwrap();
  foxmulator.run();

  assert_eq!(0, 0);
}

#[test]
fn test_add() {
  let mut foxmulator = Foxmulator::singleton().unwrap();

  let mut state = State::new();

  state.r[0] = 2;
  state.r[1] = 1;

  foxmulator.set_state(state);
  println!("before: {:?}", foxmulator.state());
  foxmulator.map_assembly(0, "add r0, r1\nhalt").unwrap();
  foxmulator.run();
  println!("after: {:?}", foxmulator.state());

  assert_eq!(foxmulator.state().r[0], 3);
}