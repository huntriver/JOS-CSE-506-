#include <kern/e1000.h>
// LAB 6: Your driver code here

int pci_attach_func(struct pci_func *pciFunc)
{
	pci_func_enable(pciFunc);
	pci_e1000_addr = mmio_map_region(pciFunc->reg_base[0], pciFunc->reg_size[0]);
	//transmit descriptor
	*(uint32_t*)((char *)pci_e1000_addr+E1000_TDBAL) = PADDR(transmit_desc);
	*(uint32_t*)((char *)pci_e1000_addr+E1000_TDBAH) = 0x0;
	*(uint32_t*)((char *)pci_e1000_addr+E1000_TDH) = 0x0;
	*(uint32_t*)((char *)pci_e1000_addr+E1000_TDT) = 0x0;
	*(uint32_t*)((char *)pci_e1000_addr+E1000_TDLEN) = sizeof(transmit_desc);
	*(uint32_t*)((char *)pci_e1000_addr+E1000_TCTL) =((((  E1000_TCTL_EN | E1000_TCTL_PSP )& ~E1000_TCTL_CT ) | (0x10<<4)) & ~E1000_TCTL_COLD) | (0x40<<12);
	*(uint32_t*)((char *)pci_e1000_addr+E1000_TIPG) = 0xa|0x4<<10|0x6<<20;
	
	//receive descriptor
	*(uint32_t*)((char *)pci_e1000_addr+E1000_RDBAL) = PADDR(receive_desc);
	*(uint32_t*)((char *)pci_e1000_addr+E1000_RDBAH) = 0x0;
	*(uint32_t*)((char *)pci_e1000_addr+E1000_RDH) = 0x0;
	*(uint32_t*)((char *)pci_e1000_addr+E1000_RDT) = rx_descN-1;
	*(uint32_t*)((char *)pci_e1000_addr+E1000_RDLEN) = sizeof(receive_desc);
	*(uint32_t*)((char *)pci_e1000_addr+E1000_RCTL) = E1000_RCTL_BAM|E1000_RCTL_EN|E1000_RCTL_SZ_2048|E1000_RCTL_SECRC;

	//(((E1000_RCTL_EN |E1000_RCTL_BAM |E1000_RCTL_SZ_2048 |E1000_RCTL_SECRC) & ~E1000_RCTL_LPE) | E1000_RCTL_LBM_NO) | E1000_RCTL_RDMTS_HALF | E1000_RCTL_MO_3;

	int i=0;
	while (i<(rx_descN>tx_descN?rx_descN:rx_descN))
	{
		if (i<tx_descN){
			transmit_desc[i].status |=E1000_TXD_STAT_DD ;
			transmit_desc[i].addr = PADDR(transmit_buf[i]);

		}
		if (i<rx_descN){
			receive_desc[i].status &=E1000_TXD_STAT_DD;
			receive_desc[i].buffer_addr=PADDR(receive_buf[i]);		
		}
		i++;
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
	*(uint32_t*)((char *)pci_e1000_addr+E1000_TDT) = (last + 1) % tx_descN;
	return 0;
}


int
pci_recv(char * buf){
	uint32_t last = *((char *)pci_e1000_addr+E1000_RDT);
	last =(last + 1) % rx_descN;
	struct rx_desc *tmp = &receive_desc[last];
	//cprintf("status: %d\n",tmp->status);
	if (!(tmp->status & E1000_RXD_STAT_DD))
	{
		//cprintf("try again ");
		return -1;
	}
	//cprintf("go %d\n",tmp->length);
    tmp->status&= ~E1000_RXD_STAT_DD;
    tmp->status&= ~E1000_RXD_STAT_EOP;
	memmove( buf,receive_buf[last], tmp->length);
	*(uint32_t*)((char *)pci_e1000_addr+E1000_RDT) = last;
	return tmp->length;
}