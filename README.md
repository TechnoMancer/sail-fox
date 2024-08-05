# Fox ISA

This is the documentation, along with a sail model, sail based emulator in Rust, and customasm assembler for Fox ISA.

* The architecture is documented in fox-architechture.md
* The sail model is in model/
* The assembler and some examples are in assembler/
* The rest is various emulator glue/support and implementation

Fox ISA is primarily the creation of rawrafox with some collaboration by OmniTechnoMancer.

Fox ISA is meant to primarily be a 16-bit ISA for a fantasy console or something like a PDP-11, but one that can in theory be extended to 32/64 bits and can have capabilities retrofitted to it.

This branch is the progress of updating the emulator, assembler and model to the current design.