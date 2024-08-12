use crate::sail;
use crate::state::State;

use super::HaltReason;

pub static mut STATE: State = State::new();

#[no_mangle]
pub unsafe extern "C" fn read_ia() -> sail::fbits {
  return STATE.ia as sail::fbits;
}

#[no_mangle]
pub unsafe extern "C" fn write_ia(value: sail::fbits) {
  return STATE.ia = value as usize;
}

#[no_mangle]
pub unsafe extern "C" fn read_halt_reason() -> sail::fbits {
  let halt_reason = match STATE.halt_reason {
    HaltReason::ERROR => 0,
    HaltReason::HALT => 1,
    HaltReason::UNKNOWN => 2,
  };
  return halt_reason as sail::fbits;
}

#[no_mangle]
pub unsafe extern "C" fn write_halt_reason(value: sail::fbits) {
  let halt_reason = match value {
    0 => HaltReason::ERROR,
    1 => HaltReason::HALT,
    2 => HaltReason::UNKNOWN,
    _ => HaltReason::UNKNOWN,
  };
  return STATE.halt_reason = halt_reason;
}

#[no_mangle]
pub unsafe extern "C" fn read_register(n: sail::fbits) -> sail::fbits {
  println!("Reading r{}", n);
  return STATE.r[n as usize] as sail::fbits;
}

#[no_mangle]
pub unsafe extern "C" fn write_register(n: sail::fbits, value: sail::fbits) {
  return STATE.r[n as usize] = value as u16;
}

#[no_mangle]
pub unsafe extern "C" fn read_predicate(n: sail::fbits) -> bool {
  return STATE.p[n as usize];
}

#[no_mangle]
pub unsafe extern "C" fn write_predicate(n: sail::fbits, value: bool) {
  return STATE.p[n as usize] = value;
}

#[no_mangle]
pub unsafe extern "C" fn read_target(n: sail::fbits) -> sail::fbits {
  println!("Reading t{}", n);
  return STATE.t[n as usize] as sail::fbits;
}

#[no_mangle]
pub unsafe extern "C" fn write_target(n: sail::fbits, value: sail::fbits) {
  return STATE.t[n as usize] = value as u16;
}