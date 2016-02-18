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
#include <kern/pmap.h>

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
	cprintf("Virtual Address			Physical Address			PTE_P		PTE_W		PTE_U\n");
	i=lower_addr;
	while(i<=upper_addr)
	{
		pte=pml4e_walk(boot_pml4e,(void *)i,0);
		cprintf("0x%x			",i);
		if (!pte) {
			cprintf("address not mapped\n");
			
		}
		else
		cprintf("0x%x			%x		%x 		%x 		\n",PTE_ADDR(*pte),*pte&PTE_P,*pte&PTE_W,*pte&PTE_U);

		i+=PGSIZE;

	};
	return 0;

	usage:
	  cprintf("usage: showmappings lower_address(base 16) upper_address(base 16)\n");
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
	cprintf("%C%s\n", BLUE, "BLUE");
	cprintf("%C%s\n", GREEN, "GREEN");
	cprintf("%C%s\n", YELLOW, "YELLOW");
	cprintf("%C%s\n", RED, "RED");
	cprintf("%C%s\n", BWHITE, "BRIGHT WHITE");
	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
		}
	}
