#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <inttypes.h>
#include <limits.h>

#include "sail.h"

extern uint64_t g_cycle_count;
extern uint64_t g_cycle_limit;
extern uint64_t g_verbosity;

extern unit load_raw(fbits addr, const sail_string file);

static struct option options[] = {
  {"binary",     required_argument, 0, 'b'},
  {"cyclelimit", required_argument, 0, 'l'},
  {"verbosity",  required_argument, 0, 'v'},
  {"help",       no_argument,       0, 'h'},
  {0, 0, 0, 0}
};

static void print_usage() {
  struct option *opt = options;
  while (opt->name) {
    printf("\t -%c\t %s\n", (char)opt->val, opt->name);
    opt++;
  }
  exit(EXIT_SUCCESS);
}

int process_arguments(int argc, char * argv[]) {
  int c;

  while (true) {
    int option_index = 0;
    c = getopt_long(argc, argv, "e:n:i:b:l:C:v:h", options, &option_index);

    if (c == -1) break;

    switch (c) {
    case 'b': ;
      uint64_t addr;
      char file[PATH_MAX];

      if (!sscanf(optarg, "0x%" PRIx64 ",%s", &addr, file)) {
        fprintf(stderr, "Could not parse argument %s\n", optarg);
        return -1;
      };

      load_raw(addr, file);
      break;

    case 'l':
      if (!sscanf(optarg, "%" PRId64, &g_cycle_limit)) {
        fprintf(stderr, "Could not parse cycle limit %s\n", optarg);
        return -1;
      }
      break;

    case 'v':
      if (!sscanf(optarg, "0x%" PRIx64, &g_verbosity)) {
        fprintf(stderr, "Could not parse verbosity flags %s\n", optarg);
        return -1;
      }
      break;

    case 'h':
      print_usage();
      break;

    default:
      fprintf(stderr, "Unrecognized option %s\n", optarg);
      print_usage();
      return -1;
    }
  }

  return 0;
}

extern void model_init();
extern void model_fini();
extern void model_pre_exit();

extern unit zmain(unit);

unit sail_exit(unit u) {
  fprintf(stderr, "[Sail] Exiting after %" PRIu64 " cycles\n", g_cycle_count);
  model_pre_exit();
  exit(EXIT_SUCCESS);
  return UNIT;
}

int main(int argc, char *argv[]) {
  model_init();
  if (process_arguments(argc, argv)) exit(EXIT_FAILURE);
  zmain(UNIT);
  model_fini();
  model_pre_exit();
  return EXIT_SUCCESS;
}
