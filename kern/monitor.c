// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>
#include <inc/color.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/dwarf.h>
#include <kern/kdebug.h>
#include <kern/dwarf_api.h>
#include <kern/trap.h>

#include <kern/pmap.h>
#include <kern/env.h>


#define CMDBUF_SIZE	80	// enough for one VGA text line
#define ANSI_COLOR_RED     "\x1b[31m"

struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "backtrace", mon_backtrace },
	{ "showmappings", "showmappings", mon_showmappings },
	{ "dump", "dump", mon_dump },
	{ "setpermission", "setpermission", mon_setpermission },
	{ "continue", "continue", mon_continue },
	{ "si", "si", mon_si },
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}


int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	// Your cod1e here.

	uint64_t *rbp = (uint64_t *)read_rbp();
	uint64_t rip;
	read_rip(rip);
	cprintf("Stack backtrace: \n");

	do {
		
		cprintf("rbp %16.0x   rip %16.0x\n", rbp, rip);
		struct Ripdebuginfo info;
		debuginfo_rip(rip, &info);
		//file name and line within that file of the stack frame's rip, followed by the name of the function and the offset of the rip from the first instruction of the function 
        int offset=rip-info.rip_fn_addr;
		cprintf(" %s:%d: %s+%16.0x ",info.rip_file, info.rip_line, info.rip_fn_name,offset);
		
		cprintf("args:%x ",info.rip_fn_narg); //number of arguments
		int i;
		for(i = 1; i <= info.rip_fn_narg; i++) 
			cprintf("%16.0x ", *((int *)(rbp) -i));     
		cprintf("\n");
		rip = (uint64_t) *(rbp+1);
		rbp = (uint64_t *)(*rbp);
	} while (rbp!=0);
	return 0;

}

int
mon_showmappings(int argc, char **argv, struct Trapframe *tf)
{
	
	if (argc!=3)
		goto usage;
	char *rest;
	uint64_t lower_addr,upper_addr,i;
	lower_addr=strtol(argv[1],&rest,16);
	if (strcmp(rest,"")!=0){
		goto usage;
	}
	upper_addr=strtol(argv[2],&rest,16);
	if (strcmp(rest,"")!=0){
		goto usage;
	}
	if (upper_addr!=ROUNDUP(upper_addr,PGSIZE) || lower_addr!=ROUNDUP(lower_addr,PGSIZE))
	{
		cprintf("showmappings: address must be aligned in PGSIZE!\n");
		return 0;
	}
	if (upper_addr<lower_addr)
	{
		cprintf("showmappings: upper_address must not be less than lower_address!\n");
		return 0;
	}


	//cprintf("suc!\n");
	pte_t *pte;
	cprintf("   Virtual Address\t  Physical Address\tPTE_P\tPTE_W\tPTE_U\n");
	i=lower_addr;
	while(i<=upper_addr)
	{
		//cprintf("boot_pml4e:%x\n",boot_pml4e);
		pte=pml4e_walk(boot_pml4e,(void *)i,0);
		cprintf("0x%016x\t",i);
		if (!pte) {
			cprintf("address not mapped\n");
			
		}
		else
		cprintf("0x%016x\t%5d\t%5d\t%5d\n",PTE_ADDR(*pte),(*pte & PTE_P)?1:0,(*pte& PTE_W)?1:0,(*pte & PTE_U)?1:0);

		i+=PGSIZE;

	};
	return 0;

	usage:
	  cprintf("usage: showmappings <lower_address(base 16)> <upper_address(base 16)>\n");
	  return 0;
	
}

int
mon_setpermission(int argc, char **argv, struct Trapframe *tf)
{
	if (argc!=5)
		goto usage;
	char *rest;
	uint64_t addr;
	int permission;

	//cprintf("1\n");
	addr=strtol(argv[1],&rest,16);
	if (strcmp(rest,"")!=0){
		goto usage;
	}

	if (!(strcmp(argv[2],"0")==0 || strcmp(argv[2],"1")==0))
		goto usage;
	if (!(strcmp(argv[3],"0")==0 || strcmp(argv[3],"1")==0))
		goto usage;
	if (!(strcmp(argv[4],"0")==0 || strcmp(argv[4],"1")==0))
		goto usage;

	

	pte_t* pte=pml4e_walk(boot_pml4e,(void *)addr,0);
	if (!pte) {
		cprintf("address not mapped\n");
		return 0;
	}
	pte_t tmp=*pte;
	//permission=(strcmp(argv[2],"0")==0?0:PTE_P)|(strcmp(argv[3],"0")==0?0:PTE_W)|(strcmp(argv[4],"0")==0?0:PTE_U)
	*pte= PTE_ADDR(*pte)|(strcmp(argv[2],"0")==0?0:PTE_P)|(strcmp(argv[3],"0")==0?0:PTE_W)|(strcmp(argv[4],"0")==0?0:PTE_U);
	cprintf("permission changed from %d %d %d ",(tmp & PTE_P)?1:0,(tmp& PTE_W)?1:0,(tmp & PTE_U)?1:0);
	cprintf("to %d %d %d \n",(*pte & PTE_P)?1:0,(*pte& PTE_W)?1:0,(*pte & PTE_U)?1:0);
	return 0;
	usage:
	  cprintf("usage: setpermission <address(base 16)> <PTE_P(0|1)> <PTE_U(0|1)> <PTE_W(0|1)>\n");
	  return 0;
}


int
mon_dump(int argc, char **argv, struct Trapframe *tf)
{
	if (argc!=4)
		goto usage;
	char *rest;
	uint64_t lower_addr,upper_addr,i;
	if (!(strcmp(argv[1],"p")==0 || strcmp(argv[1],"v")==0))
		goto usage;
	//cprintf("1\n");
	lower_addr=strtol(argv[2],&rest,16);
	if (strcmp(rest,"")!=0){
		goto usage;
	}
	upper_addr=strtol(argv[3],&rest,16);
	if (strcmp(rest,"")!=0){
		goto usage;
	}

	if (upper_addr<lower_addr)
	{
		cprintf("dump: upper_address must not be less than lower_address!\n");
		return 0;
	}
	if (strcmp(argv[1],"p")==0)
	{
		if (PPN(upper_addr) >= npages){
			cprintf("dump: address must not be extend across page boundaries!\n");
			return 0;
		}
		cprintf("  Physical Address\tContent of Address\n");
	}
	else
		cprintf("   Virtual Address\tContent of Address\n");


	i=lower_addr;

	while(i<=upper_addr)
	{
		cprintf("0x%016x\t0x%016x\n",i,(strcmp(argv[1],"p")==0)?*((uint64_t*)KADDR(i)):*((uint64_t*)KADDR(PADDR(i))));
		i+=4;

	};



	return 0;
	usage:
	  cprintf("usage: dump p|v <lower_address(base 16)> <upper_address(base 16)>\n");
	  return 0;
}

int mon_continue(int argc, char **argv, struct Trapframe *tf)
{
    if (argc!=1) goto usage;
    if (!tf) {
        cprintf("continue: trapframe null\n");
        return 0;
    }
    tf->tf_eflags=tf->tf_eflags & ~FL_TF;
    env_run(curenv);
    return 0;
    usage:
	  cprintf("usage: setpermission <address(base 16)> <PTE_P(0|1)> <PTE_U(0|1)> <PTE_W(0|1)>\n");
	  return 0;
}

int mon_si(int argc, char **argv, struct Trapframe *tf) {
   if (argc!=1) goto usage;
    if (!tf) {
        cprintf("si: trapframe null\n");
        return 0;
    }
    tf->tf_eflags = tf->tf_eflags| FL_TF;
    env_run(curenv);
    return 0;
    usage:
	  cprintf("usage: si\n");
	  return 0;
}


/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");


	if (tf != NULL)
		print_trapframe(tf);

	cprintf("%C%s\n", BLUE, "BLUE");
	cprintf("%C%s\n", GREEN, "GREEN");
	cprintf("%C%s\n", YELLOW, "YELLOW");
	cprintf("%C%s\n", RED, "RED");
	cprintf("%C%s\n", BWHITE, "BRIGHT WHITE");
	cprintf("upages %x  kstacktop %x  kernbase %x\n",UPAGES,KSTACKTOP,KERNBASE);
	
	if (tf != NULL)
		print_trapframe(tf);
	

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
		}
	}
