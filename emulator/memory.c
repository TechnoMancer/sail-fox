#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <inttypes.h>

#include "sail.h"

/*
 * We organise memory available to the sail model into a linked list
 * of dynamically allocated MASK + 1 size blocks.
 */
struct block {
  uint64_t block_id;
  uint8_t *mem;
  struct block *next;
};

struct block *sail_memory = NULL;

struct tag_block {
  uint64_t block_id;
  bool *mem;
  struct tag_block *next;
};

struct tag_block *sail_tags = NULL;

/*
 * Must be one less than a power of two.
 */
uint64_t MASK = 0xFFFFFFul;

/*
 * All sail vectors are at least 64-bits, but only the bottom 8 bits
 * are used in the second argument.
 */
void write_mem(uint64_t address, uint64_t byte) {
  uint64_t mask = address & ~MASK;
  uint64_t offset = address & MASK;

  /* if ((byte >= 97 && byte <= 122) || (byte >= 64 && byte <= 90) || (byte >= 48 && byte <= 57) || byte == 10 || byte == 32) {
    fprintf(stderr, "%" PRIx64 "\n", address);
    fprintf(stderr, "%c", (char) byte);
  } */

  struct block *current = sail_memory;

  while (current != NULL) {
    if (current->block_id == mask) {
      current->mem[offset] = (uint8_t) byte;
      return;
    } else {
      current = current->next;
    }
  }

  /*
   * If we couldn't find a block matching the mask, allocate a new
   * one, write the byte, and put it at the front of the block list.
   */
  fprintf(stderr, "[Sail] Allocating new block 0x%" PRIx64 "\n", mask);
  struct block *new_block = malloc(sizeof(struct block));
  new_block->block_id = mask;
  new_block->mem = calloc(MASK + 1, sizeof(uint8_t));
  new_block->mem[offset] = (uint8_t) byte;
  new_block->next = sail_memory;
  sail_memory = new_block;
}

uint64_t read_mem(uint64_t address) {
  uint64_t mask = address & ~MASK;
  uint64_t offset = address & MASK;

  struct block *current = sail_memory;

  while (current != NULL) {
    if (current->block_id == mask) {
      return (uint64_t) current->mem[offset];
    } else {
      current = current->next;
    }
  }

  return 0x00;
}

unit write_tag_bool(const uint64_t address, const bool tag) {
  uint64_t mask = address & ~MASK;
  uint64_t offset = address & MASK;

  struct tag_block *current = sail_tags;

  while (current != NULL) {
    if (current->block_id == mask) {
      current->mem[offset] = tag;
      return UNIT;
    } else {
      current = current->next;
    }
  }

  /*
   * If we couldn't find a block matching the mask, allocate a new
   * one, write the byte, and put it at the front of the block list.
   */
  fprintf(stderr, "[Sail] Allocating new tag block 0x%" PRIx64 "\n", mask);
  struct tag_block *new_block = malloc(sizeof(struct tag_block));
  new_block->block_id = mask;
  new_block->mem = calloc(MASK + 1, sizeof(bool));
  new_block->mem[offset] = tag;
  new_block->next = sail_tags;
  sail_tags = new_block;

  return UNIT;
}

bool read_tag_bool(const uint64_t address) {
  uint64_t mask = address & ~MASK;
  uint64_t offset = address & MASK;

  struct tag_block *current = sail_tags;

  while (current != NULL) {
    if (current->block_id == mask) {
      return current->mem[offset];
    } else {
      current = current->next;
    }
  }

  return false;
}

void kill_mem() {
  while (sail_memory != NULL) {
    struct block *next = sail_memory->next;

    free(sail_memory->mem);
    free(sail_memory);

    sail_memory = next;
  }

  while (sail_tags != NULL) {
    struct tag_block *next = sail_tags->next;

    free(sail_tags->mem);
    free(sail_tags);

    sail_tags = next;
  }
}

// ***** Memory builtins *****

bool write_ram(const mpz_t addr_size,     // Either 32 or 64
	       const mpz_t data_size_mpz, // Number of bytes
	       const lbits hex_ram,       // Currently unused
	       const lbits addr_bv,
	       const lbits data) {
  uint64_t addr = mpz_get_ui(*addr_bv.bits);
  uint64_t data_size = mpz_get_ui(data_size_mpz);

  mpz_t buf;
  mpz_init_set(buf, *data.bits);

  uint64_t byte;
  for(uint64_t i = 0; i < data_size; ++i) {
    // Take the 8 low bits of buf and write to addr.
    byte = mpz_get_ui(buf) & 0xFF;
    write_mem(addr + i, byte);

    // Then shift buf 8 bits right.
    mpz_fdiv_q_2exp(buf, buf, 8);
  }

  mpz_clear(buf);
  return true;
}

sbits fast_read_ram(const int64_t data_size, const uint64_t addr) {
  uint64_t r = 0;
  
  uint64_t byte;
  for(uint64_t i = (uint64_t) data_size; i > 0; --i) {
    byte = read_mem(addr + (i - 1));
    r = r << 8;
    r = r + byte;
  }
  sbits res = {.len = data_size * 8, .bits = r };
  return res;
}

void read_ram(lbits *data,
	      const mpz_t addr_size,
	      const mpz_t data_size_mpz,
	      const lbits hex_ram,
	      const lbits addr_bv) {
  uint64_t addr = mpz_get_ui(*addr_bv.bits);
  uint64_t data_size = mpz_get_ui(data_size_mpz);

  mpz_set_ui(*data->bits, 0);
  data->len = data_size * 8;

  mpz_t byte;
  mpz_init(byte);
  for(uint64_t i = data_size; i > 0; --i) {
    mpz_set_ui(byte, read_mem(addr + (i - 1)));
    mpz_mul_2exp(*data->bits, *data->bits, 8);
    mpz_add(*data->bits, *data->bits, byte);
  }

  mpz_clear(byte);
}

void platform_read_mem(lbits *data,
                       const int read_kind,
                       const uint64_t addr_size,
                       const sbits addr,
                       const mpz_t n) {
  sbits sdata;
  uint64_t len = mpz_get_ui(n); /* Sail type says always >0 */
  if (len <= 8) {
    /* fast path for small reads */
    sdata = fast_read_ram(len, addr.bits);
    RECREATE_OF(lbits, sbits)(data, sdata, true);
  } else {
    mpz_t mpz_addr_size;
    mpz_init(mpz_addr_size);
    mpz_set_ui(mpz_addr_size, addr_size);
    mpz_t addr_bv;
    mpz_init(addr_bv);
    mpz_set_ui(addr_bv, addr.bits);
    read_ram(data, mpz_addr_size, n, (lbits){.len=0, .bits=NULL}, (lbits){.len=addr.len, .bits=&addr_bv});
    mpz_clear(mpz_addr_size);
    mpz_clear(addr_bv);
  }
}

unit platform_write_mem_ea(const int write_kind,
                           const uint64_t addr_size,
                           const sbits addr,
                           const mpz_t n) {
    return UNIT;
}

bool platform_write_mem(const int write_kind,
                        const uint64_t addr_size,
                        const sbits addr,
                        const mpz_t n,
                        const lbits data) {
    mpz_t mpz_addr_size;
    mpz_init(mpz_addr_size);
    mpz_set_ui(mpz_addr_size, addr_size);
    mpz_t addr_bv;
    mpz_init(addr_bv);
    mpz_set_ui(addr_bv, addr.bits);
    bool res = write_ram(mpz_addr_size, n, (lbits){.len=0, .bits=NULL}, (lbits){.len=addr.len, .bits=&addr_bv}, data);
    mpz_clear(mpz_addr_size);
    mpz_clear(addr_bv);
    return res;
}

bool platform_excl_res(const unit unit) {
    return true;
}

unit platform_barrier() {
    return UNIT;
}

unit load_raw(fbits addr, const sail_string file) {
  FILE *fp = fopen(file, "r");

  if (!fp) {
    fprintf(stderr, "[Sail] Raw file %s could not be loaded\n", file);
    exit(EXIT_FAILURE);
  }

  uint64_t byte;
  while ((byte = (uint64_t)fgetc(fp)) != EOF) {
    write_mem(addr, byte);
    addr++;
  }

  return UNIT;
}

sbits fast_read_ram_be(const int64_t data_size, const uint64_t address) {
  uint64_t r = 0;
  
  for(uint64_t i = (uint64_t) data_size; i > 0; --i) {
    uint64_t byte = read_mem(address + i);
    r = r << 8;
    r = r + byte;
  }

  sbits res = { .len = data_size * 8, .bits = r };

  return res;
}

void read_ram_be(lbits *data,
	             const mpz_t addr_size,
	             const mpz_t data_size_mpz,
	             const lbits hex_ram,
	             const lbits addr_bv) {
  uint64_t addr = mpz_get_ui(*addr_bv.bits);
  uint64_t data_size = mpz_get_ui(data_size_mpz);

  mpz_set_ui(*data->bits, 0);
  data->len = data_size * 8;

  mpz_t byte;
  mpz_init(byte);
  for(uint64_t i = 0; i < data_size; i++) {
    mpz_set_ui(byte, read_mem(addr + i));
    mpz_mul_2exp(*data->bits, *data->bits, 8);
    mpz_add(*data->bits, *data->bits, byte);
  }

  mpz_clear(byte);
}

void platform_read_mem_be(lbits *data,
                          const int read_kind,
                          const uint64_t addr_size,
                          const sbits addr,
                          const mpz_t n) {
  sbits sdata;
  uint64_t len = mpz_get_ui(n); /* Sail type says always >0 */
  if (len <= 8) {
    /* fast path for small reads */
    sdata = fast_read_ram_be(len, addr.bits);
    RECREATE_OF(lbits, sbits)(data, sdata, true);
  } else {
    mpz_t mpz_addr_size;
    mpz_init(mpz_addr_size);
    mpz_set_ui(mpz_addr_size, addr_size);
    mpz_t addr_bv;
    mpz_init(addr_bv);
    mpz_set_ui(addr_bv, addr.bits);
    read_ram_be(data, mpz_addr_size, n, (lbits){ .len = 0, .bits = NULL}, (lbits){ .len = addr.len, .bits = &addr_bv });
    mpz_clear(mpz_addr_size);
    mpz_clear(addr_bv);
  }
}
