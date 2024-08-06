use customasm::{asm, diagn, util};

pub fn assemble(asm: &str) -> Result<Vec<u8>, ()> {

  let mut fileserver = util::FileServerMock::new();

  let asm = String::from("#include \"fox.asm\"\n\n") + asm;

  fileserver.add_std_files(&[("fox.asm",include_str!("../assembler/fox.asm")), ("input", &asm)]);

  let mut report = diagn::Report::new();
  let opts = asm::AssemblyOptions::new();

  let result = asm::assemble(&mut report, &opts, &mut fileserver, &["input"]);

  if result.error
  {
    report.print_all(&mut std::io::stderr(), &fileserver, true);
    return Err(());
  }

  if let Some(output) = result.output {
    return Ok(output.format_binary());
  } else {
    return Err(());
  }
}