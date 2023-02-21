#include "sail.h"

extern void kill_mem();
extern unit disable_tracing(const unit u);

void setup_rts(void) {
  disable_tracing(UNIT);
  setup_library();
}

void cleanup_rts(void) {
  cleanup_library();
  kill_mem();
}
