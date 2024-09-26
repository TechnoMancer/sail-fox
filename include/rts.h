#ifndef FOXMULATOR_RTS_H
#define FOXMULATOR_RTS_H

#include "sail.h"
#include "sail_failure.h"

unit sail_exit(unit);

/* Memory builtins */

fbits read_u8_be(fbits);
fbits read_u16_be(fbits);

unit write_u16_be(fbits, fbits);

/* State builtins */

fbits read_ia(unit);
fbits read_halt_reason(unit);
fbits read_stack_pointer(unit);
fbits read_register(fbits);
fbits read_predicate(fbits);
fbits read_target(fbits);

unit write_ia(fbits);
unit write_halt_reason(fbits);
unit write_stack_pointer(fbits);
unit write_register(fbits, fbits);
unit write_predicate(fbits, bool);
unit write_target(fbits, fbits);

/* Random stuff */

int process_arguments(int, char**);

/*
 * setup_rts and cleanup_rts are responsible for calling setup_library
 * and cleanup_library in sail.h.
 */
void setup_rts(void);
void cleanup_rts(void);

#endif
