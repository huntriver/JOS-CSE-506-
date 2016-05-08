#ifndef JOS_KERN_E1000_H
#define JOS_KERN_E1000_H

#include <kern/pmap.h>
#include <kern/pci.h>
#include <kern/e1000_hw.h>
#include <inc/string.h>

#define tx_descN 64  
#define rx_descN 128
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

/* Receive Descriptor */
struct rx_desc {
    uint64_t buffer_addr; /* Address of the descriptor's data buffer */
    uint16_t length;     /* Length of data DMAed into data buffer */
    uint16_t csum;       /* Packet checksum */
    uint8_t status;      /* Descriptor status */
    uint8_t errors;      /* Descriptor Errors */
    uint16_t special;
};

int pci_attach_func(struct pci_func *pciFunc);
int pci_xmit(char *, uint32_t);
int pci_recv(char *);
volatile uint32_t *pci_e1000_addr;
struct tx_desc transmit_desc[tx_descN];
struct rx_desc receive_desc[rx_descN];
// struct tx_buf transmit_buf[descN];
char transmit_buf[tx_descN][bufSize];
char receive_buf[rx_descN][bufSize];
#endif	// JOS_KERN_E1000_H