use clap::Parser;
use rug;
use std::{ffi::CString, process::exit};
use parse_int::parse;

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
}

#[link(name = "runtime")]
extern {
   // Always returns UNIT (0), so pretending it does not return
  fn load_raw(address: sail::fbits, file: *const libc::c_char);
}

#[derive(Parser)]
struct Arguments {
  /// Binary to load
  #[arg(short, long)]
  binary: Option<String>,
}

fn load_binary(binary: &str) -> Option<()> {
  let (address, file) = binary.split_once(",")?;
  let addr: sail::fbits = parse::<sail::fbits>(address).ok()?;
    
  let cfile = CString::new(file).ok()?;
  
  unsafe { load_raw(addr, cfile.as_ptr()) };

  return Some(());
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
