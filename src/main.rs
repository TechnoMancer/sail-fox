use clap::Parser;
use memory::Memory;
use std::process::exit;
use parse_int::parse;
use rug;

#[allow(non_camel_case_types)]
mod sail {
  pub type unit = libc::c_int;
  pub type fbits = u64;
}

mod memory;

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

#[link(name = "foxmulator")]
extern {
  fn setup_library();
  fn cleanup_library();

  fn model_init();
  fn model_fini();
  fn model_pre_exit();

  // Always returns UNIT (0), so pretending it does not return
  fn zmain(_: sail::unit);
}

#[derive(Parser)]
struct Arguments {
  /// Binary to load
  #[arg(short, long)]
  binary: Option<String>,
}

static mut MEMORY: Memory = Memory::new();

fn load_binary(binary: &str) -> Option<()> {
  let (address, path) = binary.split_once(",")?;
  let addr = parse::<usize>(address).unwrap();
  
  unsafe { MEMORY.allocate_page_from_file(addr, path).unwrap() };
  
  return Some(());
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


fn main() {
  let args = Arguments::parse();

  unsafe {
    model_init();

    if let Some(binary) = args.binary {
      if load_binary(&binary).is_none() {
        println!("Failed to load binary: {}", binary);
        exit(1);
      };
    }

    zmain(0);
    model_fini();
    model_pre_exit();
  };
}
