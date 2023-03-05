#ifndef FOXMULATOR_RTS_H
#define FOXMULATOR_RTS_H

#include "sail.h"
#include "sail_failure.h"

unit sail_exit(unit);

/* Memory builtins */

fbits read_u8_be(fbits);
fbits read_u16_be(fbits);

/* State builtins */

fbits read_ia();
fbits read_register(fbits);
fbits read_predicate(fbits);

unit write_ia(fbits);
unit write_register(fbits, fbits);
unit write_predicate(fbits, bool);

/* Random stuff */

int process_arguments(int, char**);

/*
 * setup_rts and cleanup_rts are responsible for calling setup_library
 * and cleanup_library in sail.h.
 */
void setup_rts(void);
void cleanup_rts(void);

#endif
