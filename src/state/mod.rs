#[derive(Clone, Copy, Debug)]
pub struct State {
  pub ia: usize,
  pub r: [u16; 16],
  pub p: [bool; 15],
  pub t: [u16; 8],
  pub halt_reason: HaltReason,
}

impl State {
  pub const fn new() -> State {
    return State {
      ia: 0,
      r: [0; 16],
      p: [true; 15],
      t: [0; 8],
      halt_reason: HaltReason::Unknown,
    }
  }
}

impl Default for State {
  fn default() -> Self {
    return State::new();
  }
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub enum HaltReason {
  Error,
  Halt,
  UnknownInstruction,
  BlockError,
  Unknown,
}

pub mod sail_interop;
