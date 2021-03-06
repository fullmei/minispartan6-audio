#ifndef __SPI_H__
#define __SPI_H__

#include <stdint.h>

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------
void      spi_init(uint32_t base_addr, uint32_t clk_div);
void      spi_cs(uint32_t value);
uint8_t   spi_sendrecv(uint8_t ch);
void      spi_readblock(uint8_t *ptr, int length);
void      spi_writeblock(uint8_t *ptr, int length);

#endif
