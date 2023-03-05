extern crate foxmulator;

use std::process::exit;

use clap::Parser;
use parse_int::parse;

use foxmulator::Foxmulator;

#[derive(Parser)]
struct Arguments {
  /// Binary to map
  #[arg(short, long)]
  binary: Option<String>,
  /// Memory to map
  #[arg(short, long)]
  memory: Option<String>
}

fn main() {
  let args = Arguments::parse();

  let mut foxmulator = Foxmulator::singleton().unwrap();

  if let Some(ref binary) = args.binary {
    let (address, path) = binary.split_once(",").unwrap();
    let address = parse::<usize>(address).unwrap();

    if foxmulator.map_binary(address, path).is_err() {
      println!("Failed to map binary: {}", binary);
      exit(1);
    };
  }

  if let Some(ref memory) = args.memory {
    let address = parse::<usize>(memory).unwrap();

    if foxmulator.map_memory(address).is_err() {
      println!("Failed to map memory: {}", memory);
      exit(1);
    };
  }

  foxmulator.run();
}
