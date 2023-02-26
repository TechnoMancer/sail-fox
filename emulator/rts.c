#include "sail.h"

extern void model_pre_exit();
extern void kill_mem();

void setup_rts(void) {
  setup_library();
}

void cleanup_rts(void) {
  cleanup_library();
  kill_mem();
}

unit sail_exit(unit u) {
  model_pre_exit();
  exit(EXIT_SUCCESS);
  return UNIT;
}
