use clap::Parser;
use rug;
use std::process::exit;

mod memory;
mod runtime;

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

  runtime::init();

  if let Some(ref binary) = args.binary {
    if runtime::map_binary(binary).is_none() {
      println!("Failed to map binary: {}", binary);
      exit(1);
    };
  }

  if let Some(ref memory) = args.memory {
    if runtime::map_memory(memory).is_none() {
      println!("Failed to map memory: {}", memory);
      exit(1);
    };
  }

  runtime::run_model();
  runtime::fini();
  runtime::pre_exit();
}
