CC=clang
SAIL_LIB=/Users/Aurora/.opam/default/share/sail/lib
CFLAGS=-lgmp -lz -Iemulator/include -I/Users/Aurora/.opam/default/share/sail/lib/ -L/opt/local/lib
SAIL=sail
# CFLAGS will be the options passed to the compiler. CFLAGS= -c -Wall
all: output/foxmulator
output/foxmulator: output/foxmulator.c emulator/cycle_count.c emulator/main.c emulator/memory.c emulator/rts.c emulator/sleeping.c emulator/tracing.c emulator/verbosity.c
	$(CC) $(CFLAGS) $(SAIL_LIB)/sail.c $(SAIL_LIB)/sail_failure.c output/foxmulator.c emulator/cycle_count.c emulator/main.c emulator/memory.c emulator/rts.c emulator/sleeping.c emulator/tracing.c emulator/verbosity.c -o output/foxmulator
output/foxmulator.c: model/prelude.sail model/types.sail model/registers.sail model/instructions/begin.sail model/instructions/branch.sail model/instructions/system.sail model/instructions/end.sail model/main.sail
	$(SAIL) -c -o output/foxmulator -c_no_main model/prelude.sail model/types.sail model/registers.sail model/instructions/begin.sail model/instructions/branch.sail model/instructions/system.sail model/instructions/end.sail model/main.sail
clean:
	rm -rf output