use std::env;

fn main() {
  // Tell Cargo that if the given file changes, to rerun this build script.
  println!("cargo:rerun-if-changed=emulator/main.c");
  println!("cargo:rerun-if-changed=emulator/memory.c");
  println!("cargo:rerun-if-changed=emulator/rts.c");
  println!("cargo:rerun-if-changed=output/foxmulator.c");

  cc::Build::new()
    .include("emulator/include")
    .include(env::var("DEP_GMP_INCLUDE_DIR").unwrap())
    .include("/Users/Aurora/.opam/default/share/sail/lib/")
    .file("emulator/memory.c")
    .file("emulator/rts.c")
    .file("/Users/Aurora/.opam/default/share/sail/lib/sail.c")
    .file("/Users/Aurora/.opam/default/share/sail/lib/sail_failure.c")
    .warnings(false) /* These a really spammy, should be fixed but … */
    .compile("runtime");

  cc::Build::new()
    .include("emulator/include")
    .include(env::var("DEP_GMP_INCLUDE_DIR").unwrap())
    .include("/Users/Aurora/.opam/default/share/sail/lib/")
    .file("output/foxmulator.c")
    .warnings(false) /* These a really spammy, but it is what it is … */
    .compile("foxmulator");
}
