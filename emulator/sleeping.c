#include "sail.h"

bool g_sleeping = false;

unit sleep_request(const unit u) {
  fprintf(stderr, "Sail CPU model going to sleep\n");
  g_sleeping = true;
  return UNIT;
}

unit wakeup_request(const unit u) {
  fprintf(stderr, "Sail CPU model waking up\n");
  g_sleeping = false;
  return UNIT;
}

bool sleeping(const unit u) {
    return g_sleeping;
}
