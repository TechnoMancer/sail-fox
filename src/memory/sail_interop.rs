use crate::sail;
use crate::memory::Memory;

pub static mut MEMORY: Memory = Memory::new();

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
