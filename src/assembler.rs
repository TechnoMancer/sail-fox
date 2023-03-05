use customasm::diagn;

struct FileServer {
  files: std::collections::HashMap<String, Vec<u8>>
}

impl FileServer {
  pub fn new() -> FileServer {
    let mut files = std::collections::HashMap::new();

    files.insert("fox.asm".to_string(), include_bytes!("../assembler/fox.asm").to_vec());

		return FileServer {
			files: files
		};
	}

	pub fn add<S, T>(&mut self, filename: S, contents: T) where S: Into<String>, T: Into<Vec<u8>> {
		self.files.insert(filename.into(), contents.into());
	}

  pub fn remove(&mut self, filename: &str) -> Option<Vec<u8>> {
    return self.files.remove(filename);
  }
}

impl customasm::util::FileServer for FileServer {
	fn exists(&self, filename: &str) -> bool {
		self.files.get(filename).is_some()
	}

	fn get_bytes(&self, report: diagn::RcReport, filename: &str, span: Option<&diagn::Span>) -> Result<Vec<u8>, ()> {
		match self.files.get(filename) {
			None => {
        let description = format!("file not found: `{}`", filename);

        if let Some(span) = span {
          report.error_span(description, span);
        } else {
          report.error(description);
        }

        Err(())
      },
			Some(bytes) => Ok(bytes.clone())
		}
	}

	fn write_bytes(&mut self, _: diagn::RcReport, filename: &str, data: &Vec<u8>, _: Option<&diagn::Span>) -> Result<(), ()> {
		self.files.insert(filename.to_string(), data.clone());
		Ok(())
	}
}

pub fn assemble(asm: &str) -> Result<Vec<u8>, ()> {
  let mut fileserver = FileServer::new();

  let asm = String::from("#include \"fox.asm\"\n\n") + asm;

  fileserver.add("input", asm);

  let args: Vec<String> = vec!["customasm".to_string(), "input".to_string()];

  if let Err(()) = customasm::driver::drive(&args, &mut fileserver) {
    std::process::exit(1);
  }

  if let Some(output) = fileserver.remove("input.bin") {
    return Ok(output);
  } else {
    return Err(());
  }
}