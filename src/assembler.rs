use customasm::{asm, diagn, util};

pub fn assemble(asm: &str) -> Result<Vec<u8>, ()> {

  let mut fielserver = util::FileServerMock::new();

  let asm = String::from("#include \"fox.asm\"\n\n") + asm;

  fielserver.add_std_files(&[("fox.asm",include_str!("../assembler/fox.asm")), ("input", &asm)]);

  let mut report = diagn::Report::new();
  let opts = asm::AssemblyOptions::new();

  let result = asm::assemble(&mut report, &opts, &mut fielserver, &["input"]);

  if result.error
  {
    return Err(());
  }

  if let Some(output) = result.output {
    return Ok(output.format_binary());
  } else {
    return Err(());
  }
}