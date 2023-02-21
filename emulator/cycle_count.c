#include <stdbool.h>
#include <stdint.h>

#include "sail.h"

uint64_t g_cycle_count = 0;
uint64_t g_cycle_limit;

/* NB Also increments cycle_count */
bool cycle_limit_reached(const unit u) {
  return ++g_cycle_count >= g_cycle_limit && g_cycle_limit != 0;
}

unit cycle_count(const unit u) {
  if (cycle_limit_reached(UNIT)) {
    printf("\n[Sail] TIMEOUT: exceeded %" PRId64 " cycles\n", g_cycle_limit);
    exit(EXIT_SUCCESS);
  }
  return UNIT;
}

void get_cycle_count(sail_int *rop, const unit u) {
    mpz_init_set_ui(*rop, g_cycle_count);
}
