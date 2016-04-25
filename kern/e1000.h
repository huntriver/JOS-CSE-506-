#ifndef JOS_KERN_E1000_H
#define JOS_KERN_E1000_H

#include <kern/pmap.h>
#include <kern/pci.h>

int pci_attach_func(struct pci_func *pciFunc);
volatile uint32_t *pci_e1000_addr;

#endif	// JOS_KERN_E1000_H
