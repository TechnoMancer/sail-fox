use std::env;
use std::process::Command;

fn main() {
  let out_dir = env::var("OUT_DIR").unwrap();

  let sail_home = Command::new("sail")
    .arg("-dir")
    .output()
    .expect("failed to find Sail's home directory")
    .stdout;
  let sail_home = std::str::from_utf8(&sail_home).expect("Sail's output is not UTF-8?").trim_end(); 

  let sail_files = Command::new("sail")
    .arg("--no-memo-z3")
    .args(["--project", "model/fox.sail_project"])
    .arg("--list-files")
    .arg("main")
    .output().expect("failed to retrieve project file list")
    .stdout;
  let sail_files = std::str::from_utf8(&sail_files).expect("Sail's output is not UTF-8?");

  for file in sail_files.split_ascii_whitespace() {
    println!("cargo:rerun-if-changed={}", file);
  }

  println!("cargo:rustc-link-lib=gmp");

  println!("cargo:rerun-if-changed=model/fox.sail_project");

  println!("cargo:rerun-if-changed=include/rts.h");

  let sail = Command::new("sail")
    .arg("--no-memo-z3")
    .arg("-c")
    .args(["-o", &format!("{}/foxmulator", out_dir), "-c-no-main"])
    .args(["--project", "model/fox.sail_project"])
    .arg("main")
    .output()
    .expect("Sail model failed to execute");

  if !sail.status.success() {
    let stdout = std::str::from_utf8(&sail.stdout).expect("Sail's output is not UTF-8?");
    let stderr = std::str::from_utf8(&sail.stderr).expect("Sail's output is not UTF-8?");

    panic!("Sail: {} {} {}", sail.status, stdout, stderr);
  }

  cc::Build::new()
    .include("include")
    .include(format!("{}/lib", sail_home))
    .include(env::var("DEP_GMP_INCLUDE_DIR").unwrap())
    .file(format!("{}/lib/sail.c", sail_home))
    .file(format!("{}/lib/sail_failure.c", sail_home))
    .file(&format!("{}/foxmulator.c", out_dir))
    .warnings(false) /* These a really spammy, but it is what it is … */
    .compile("foxmulator-model");

    println!("cargo:rustc-link-lib=foxmulator-model");

}
