#include <kern/e1000.h>
// LAB 6: Your driver code here

int pci_attach_func(struct pci_func *pciFunc)
{
	pci_func_enable(pciFunc);
	pci_e1000_addr = mmio_map_region(pciFunc->reg_base[0], pciFunc->reg_size[0]);

	*(uint32_t*)((char *)pci_e1000_addr+E1000_TDBAL) = PADDR(transmit_desc);
	*(uint32_t*)((char *)pci_e1000_addr+E1000_TDBAH) = 0x0;
	*(uint32_t*)((char *)pci_e1000_addr+E1000_TDH) = 0x0;
	*(uint32_t*)((char *)pci_e1000_addr+E1000_TDT) = 0x0;
	*(uint32_t*)((char *)pci_e1000_addr+E1000_TDLEN) = sizeof(transmit_desc);
	*(uint32_t*)((char *)pci_e1000_addr+E1000_TCTL) = E1000_TCTL_EN|E1000_TCTL_COLD|E1000_TCTL_CT|E1000_TCTL_PSP;
	*(uint32_t*)((char *)pci_e1000_addr+E1000_TIPG) = 0x60200a;

	int i;
	for(i = 0; i < descN; i++)
	{	
	  transmit_desc[i].status |= 1;
	  transmit_desc[i].addr = PADDR(transmit_buf[i]);
	}

	return 0;
}


int
pci_xmit(char * buf, uint32_t len){
 uint32_t last = *((char *)pci_e1000_addr+E1000_TDT);
 struct tx_desc *tmp = &transmit_desc[last];
 if (tmp->status != E1000_TXD_STAT_DD)
 {
   return -1;
 }
 // tmp->status=0;
 tmp->length = len> bufSize ? bufSize : len;
 memmove(transmit_buf[last], buf, tmp->length);
 tmp->cmd|= 1;
 *(uint32_t*)((char *)pci_e1000_addr+E1000_TDT) = (last + 1) % descN;
 return 0;
}
