#ifndef FOXMULATOR_RTS_H
#define FOXMULATOR_RTS_H

#include "sail.h"
#include "sail_failure.h"

unit sail_exit(unit);

/* ***** Memory builtins ***** */

void platform_read_mem_be(lbits *data,
                          const int read_kind,
                          const uint64_t addr_size,
                          const sbits addr,
                          const mpz_t n);

int process_arguments(int, char**);

/*
 * setup_rts and cleanup_rts are responsible for calling setup_library
 * and cleanup_library in sail.h.
 */
void setup_rts(void);
void cleanup_rts(void);

#endif
