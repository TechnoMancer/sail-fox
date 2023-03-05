#[derive(Clone, Copy, Debug)]
pub struct State {
  pub ia: usize,
  pub r: [u16; 16],
  pub p: [bool; 15]
}

impl State {
  pub const fn new() -> State {
    return State {
      ia: 0,
      r: [0; 16],
      p: [true; 15]
    }
  }
}

impl Default for State {
  fn default() -> Self {
    return State::new();
  }
}


pub mod sail_interop;
