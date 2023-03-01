use parse_int::parse;
use std::process::exit;

use crate::memory::Memory;

static mut MEMORY: Memory = Memory::new();

#[allow(non_camel_case_types)]
mod sail {
  pub type unit = libc::c_int;
  pub type fbits = u64;
}

#[link(name = "foxmulator")]
extern {
  fn model_init();
  fn model_fini();
  fn model_pre_exit();

  // Always returns UNIT (0), so pretending it does not return
  fn zmain(_: sail::unit);

  fn setup_library();
  fn cleanup_library();
}

#[no_mangle]
pub unsafe extern "C" fn setup_rts() {
  setup_library();
}

#[no_mangle]
pub unsafe extern "C" fn cleanup_rts() {
  cleanup_library();
}

#[no_mangle]
pub unsafe extern "C" fn sail_exit(_: sail::unit) -> ! {
  model_pre_exit();

  exit(0);
}

#[no_mangle]
pub unsafe extern "C" fn read_u8_be(address: sail::fbits) -> sail::fbits {
  if let Ok(value) = MEMORY.read_u8(address as usize) {
    return value as sail::fbits;
  } else {
    panic!("We probably shouldn't panic on out of bounds reads should we?");
  }
}

#[no_mangle]
pub unsafe extern "C" fn read_u16_be(address: sail::fbits) -> sail::fbits {
  if let Ok(value) = MEMORY.read_u16(address as usize) {
    return value.to_be() as sail::fbits;
  } else {
    panic!("We probably shouldn't panic on out of bounds reads should we?");
  }
}

#[no_mangle]
pub unsafe extern "C" fn write_u8_be(address: sail::fbits, value: sail::fbits) {
  MEMORY.write_u8(address as usize, value as u8).unwrap();
}

#[no_mangle]
pub unsafe extern "C" fn write_u16_be(address: sail::fbits, value: sail::fbits) {
  MEMORY.write_u16(address as usize, (value as u16).to_be()).unwrap();
}

pub fn init() {
  unsafe {
    model_init();
  }
}

pub fn run_model() {
  unsafe {
    zmain(0);
  }
}

pub fn fini() {
  unsafe {
    model_fini();
  }
}

pub fn pre_exit() {
  unsafe {
    model_pre_exit();
  }
}

pub fn map_memory(memory: &str) -> Option<()> {
  let addr = parse::<usize>(memory).unwrap();

  unsafe { MEMORY.allocate_page(addr).unwrap() };

  return Some(());
}

pub fn map_binary(binary: &str) -> Option<()> {
  let (address, path) = binary.split_once(",")?;
  let addr = parse::<usize>(address).unwrap();
  
  unsafe { MEMORY.allocate_page_from_file(addr, path).unwrap() };
  
  return Some(());
}
