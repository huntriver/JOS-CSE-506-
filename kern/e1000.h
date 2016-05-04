#ifndef JOS_KERN_E1000_H
#define JOS_KERN_E1000_H

#include <kern/pmap.h>
#include <kern/pci.h>
#include <kern/e1000_hw.h>
#include <inc/string.h>

#define descN 64  
#define bufSize 4096
struct tx_desc
{
	uint64_t addr;
	uint16_t length;
	uint8_t cso;
	uint8_t cmd;
	uint8_t status;
	uint8_t css;
	uint16_t special;
};

struct tx_buf{
	char buf[bufSize];
};

int pci_attach_func(struct pci_func *pciFunc);
int pci_xmit(char *, uint32_t);
volatile uint32_t *pci_e1000_addr;
struct tx_desc transmit_desc[descN];
// struct tx_buf transmit_buf[descN];
char transmit_buf[descN][bufSize];
#endif	// JOS_KERN_E1000_H