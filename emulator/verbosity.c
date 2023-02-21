#include "sail.h"

uint64_t g_verbosity = 0;

fbits sail_get_verbosity(const unit u) {
  return g_verbosity;
}
