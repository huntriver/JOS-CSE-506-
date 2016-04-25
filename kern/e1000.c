#include <kern/e1000.h>

// LAB 6: Your driver code here

int pci_attach_func(struct pci_func *pciFunc){
pci_func_enable(pciFunc);
pci_e1000_addr=mmio_map_region(pciFunc->reg_base[0], pciFunc->reg_size[0]);
return 0;
}