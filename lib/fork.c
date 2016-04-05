// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>

// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW		0x800

//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{



	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	int r;


        // Check that the faulting access was (1) a write, and (2) to a
        // copy-on-write page.  If not, panic.
        // Hint:
        //   Use the read-only page table mappings at vpt
        //   (see <inc/memlayout.h>).

        // LAB 4: Your code here.
	if (!(err&FEC_WR))
		panic("pgfault:FEC_WR check\n");
	if (!(uvpt[((uint64_t)addr) / PGSIZE] & PTE_COW))
		panic("pgfault:PTE_COW check\n");

        // Allocate a new page, map it at a temporary location (PFTEMP),
        // copy the data from the old page to the new page, then move the new
        // page to the old page's address.
        // Hint:
        //   You should make three system calls.
        //   No need to explicitly delete the old page's mapping.

        // LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
	if (sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U)<0)
		panic("pgfault: sys_page_alloc error\n");
	memcpy(PFTEMP, addr, PGSIZE);
	if (sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0)
		panic("pgfault: sys_page_map error\n");

	if (sys_page_unmap(0, (void *)PFTEMP)<0)
		panic("pgfault: sys_page_unmap error\n");
	


}

//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why do we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{

	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
			panic("duppage:sys_page_map error\n");
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
			panic("duppage:sys_page_map error\n");
	}
	return 0;	   	

}


static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
			panic("duppage:sys_page_map error\n");
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
			panic("duppage:sys_page_map error\n");
	}
	return 0;	   	

}





//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use uvpd, uvpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{


	
	int envid;  
	extern unsigned char end[];      
	set_pgfault_handler(pgfault);


	if ((envid=sys_exofork())<0)
		panic("fork: sys_exofork error!\n"); 

	if(envid>0){
		
		
		uintptr_t i;
    for (i = 0; i < (uintptr_t)end/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
		{
			
			if(!(uvpd[VPD(i)] & PTE_P))
				continue;
			if(!(uvpt[VPN(i)] & PTE_P))
				continue; 
			if(!(uvpt[VPN(i)] & PTE_U))
				continue; 
			duppage(envid, VPN(i)); 
		}

		if (sys_page_alloc(envid,(void*)UXSTACKTOP-PGSIZE, PTE_U|PTE_W|PTE_P)<0)
			panic("fork: sys_page_alloc error!\n");

		duppage(envid, PPN(USTACKTOP-PGSIZE));
		extern void _pgfault_upcall(void);
		if (sys_env_set_pgfault_upcall(envid, _pgfault_upcall)<0)
			panic("fork: sys_env_set_status error!\n");
		if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
			panic("fork: sys_env_set_status error!\n");

		return envid;
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

}

// Challenge!
envid_t
sfork(void)
{

	
	int envid;  
	extern unsigned char end[];      
	set_pgfault_handler(pgfault);
	

	if ((envid=sys_exofork())<0)
		panic("fork: sys_exofork error!\n"); 

	if(envid>0){
		
		
		uintptr_t i;
		int flag=1;

		for (i = 0; i < (uintptr_t)end/*USTACKTOP-PGSIZE*/; i += PGSIZE) ;
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
    for (;i>=0; i -= PGSIZE) 
		{
			cprintf("23\n");
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
				flag=0;
			else
				new_duppage(envid, VPN(i),flag); 

		}

		if (sys_page_alloc(envid,(void*)UXSTACKTOP-PGSIZE, PTE_U|PTE_W|PTE_P)<0)
			panic("fork: sys_page_alloc error!\n");
cprintf("123\n");
		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		extern void _pgfault_upcall(void);
		if (sys_env_set_pgfault_upcall(envid, _pgfault_upcall)<0)
			panic("fork: sys_env_set_status error!\n");
		if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
			panic("fork: sys_env_set_status error!\n");

		return envid;
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

}

