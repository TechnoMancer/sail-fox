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
    HaltReason::Error => 0,
    HaltReason::Halt => 1,
    HaltReason::UnknownInstruction => 2,
    HaltReason::BlockError => 3,
    HaltReason::Unknown => 4,
  };
  return halt_reason as sail::fbits;
}

#[no_mangle]
pub unsafe extern "C" fn write_halt_reason(value: sail::fbits) {
  let halt_reason = match value {
    0 => HaltReason::Error,
    1 => HaltReason::Halt,
    2 => HaltReason::UnknownInstruction,
    3 => HaltReason::BlockError,
    4 => HaltReason::Unknown,
    _ => HaltReason::Unknown,
  };
  return STATE.halt_reason = halt_reason;
}

#[no_mangle]
pub unsafe extern "C" fn read_stack_pointer() -> sail::fbits {
  return STATE.sp as sail::fbits;
}

#[no_mangle]
pub unsafe extern "C" fn write_stack_pointer(value: sail::fbits) {
  return STATE.sp = value as usize;
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