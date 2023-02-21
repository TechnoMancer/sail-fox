#include <stdbool.h>
#include <stdint.h>

#include "sail.h"

static int64_t g_trace_depth;
//static int64_t g_trace_max_depth;
static bool g_trace_enabled;

unit enable_tracing(const unit u) {
  g_trace_depth = 0;
  g_trace_enabled = true;
  return UNIT;
}

unit disable_tracing(const unit u) {
  g_trace_depth = 0;
  g_trace_enabled = false;
  return UNIT;
}

bool is_tracing(const unit u) {
  return g_trace_enabled;
}

void trace_fbits(const fbits x) {
  if (g_trace_enabled) fprintf(stderr, "0x%" PRIx64, x);
}

void trace_unit(const unit u) {
  if (g_trace_enabled) fputs("()", stderr);
}

void trace_sail_string(const sail_string str) {
  if (g_trace_enabled) fputs(str, stderr);
}

void trace_sail_int(const sail_int op) {
  if (g_trace_enabled) mpz_out_str(stderr, 10, op);
}

void trace_lbits(const lbits op) {
  if (g_trace_enabled) fprint_bits("", op, "", stderr);
}

void trace_bool(const bool b) {
  if (g_trace_enabled) {
    if (b) {
      fprintf(stderr, "true");
    } else {
      fprintf(stderr, "false");
    }
  }
}

void trace_unknown(void) {
  if (g_trace_enabled) fputs("?", stderr);
}

void trace_argsep(void) {
  if (g_trace_enabled) fputs(", ", stderr);
}

void trace_argend(void) {
  if (g_trace_enabled) fputs(")\n", stderr);
}

void trace_retend(void) {
  if (g_trace_enabled) fputs("\n", stderr);
}

void trace_start(char *name) {
  if (g_trace_enabled) {
    fprintf(stderr, "[TRACE] ");
    for (int64_t i = 0; i < g_trace_depth; ++i) {
      fprintf(stderr, "%s", "|   ");
    }
    fprintf(stderr, "%s(", name);
    g_trace_depth++;
  }
}

void trace_end(void) {
  if (g_trace_enabled) {
    fprintf(stderr, "[TRACE] ");
    for (int64_t i = 0; i < g_trace_depth; ++i) {
      fprintf(stderr, "%s", "|   ");
    }
    g_trace_depth--;
  }
}
