#ifndef FOXMULATOR_RTS_H
#define FOXMULATOR_RTS_H

#include "sail.h"
#include "sail_failure.h"

unit sail_exit(unit);

/* ***** Memory builtins ***** */

fbits read_u8_be(fbits);
fbits read_u16_be(fbits);

int process_arguments(int, char**);

/*
 * setup_rts and cleanup_rts are responsible for calling setup_library
 * and cleanup_library in sail.h.
 */
void setup_rts(void);
void cleanup_rts(void);

#endif
