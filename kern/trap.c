#include <inc/mmu.h>
#include <inc/x86.h>
#include <inc/assert.h>

#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/env.h>
#include <kern/syscall.h>
#include <kern/sched.h>
#include <kern/kclock.h>
#include <kern/picirq.h>
#include <kern/cpu.h>
#include <kern/spinlock.h>
#include <kern/time.h>
#include <inc/vmx.h>

extern uintptr_t gdtdesc_64;
struct Taskstate ts;
extern struct Segdesc gdt[];
extern long gdt_pd;

/* For debugging, so print_trapframe can distinguish between printing
 * a saved trapframe and printing the current trapframe and print some
 * additional information in the latter case.
 */

 static struct Trapframe *last_tf;

/* Interrupt descriptor table.  (Must be built at run time because
 * shifted function addresses can't be represented in relocation records.)
 */
struct Gatedesc idt[256] = { { 0 } };
struct Pseudodesc idt_pd = {0,0};


static const char *trapname(int trapno)
{
	static const char * const excnames[] = {
		"Divide error",
		"Debug",
		"Non-Maskable Interrupt",
		"Breakpoint",
		"Overflow",
		"BOUND Range Exceeded",
		"Invalid Opcode",
		"Device Not Available",
		"Double Fault",
		"Coprocessor Segment Overrun",
		"Invalid TSS",
		"Segment Not Present",
		"Stack Fault",
		"General Protection",
		"Page Fault",
		"(unknown trap)",
		"x87 FPU Floating-Point Error",
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
		return "Hardware Interrupt";
	return "(unknown trap)";
}


void
trap_init(void)
{
	extern struct Segdesc gdt[];


	int i;
	extern uint64_t entries[];
	void entry48();
	for (i=0;i<20;i++)
		SETGATE(idt[i], 0, GD_KT, entries[i], i==3?3:0);
	// for (i=32;i<=47;i++)
	// 	SETGATE(idt[i], 0, GD_KT, entries[i], 0);
	SETGATE(idt[48], 0, GD_KT, entry48, 3);
	

	//for (i = 0; i < 16; ++i)
//		SETGATE(idt[IRQ_OFFSET+i], 0, GD_KT, entries[IRQ_OFFSET+i], 0);

void entry32();
void entry33();
void entry34();
void entry35();
void entry36();
void entry37();
void entry38();
void entry39();
void entry40();
void entry41();
void entry42();
void entry43();
void entry44();
void entry45();
void entry46();
void entry47();



 	SETGATE(idt[32], 0, GD_KT, entry32, 0);
    SETGATE(idt[33], 0, GD_KT, entry33, 0);
    SETGATE(idt[34], 0, GD_KT, entry34, 0);
    SETGATE(idt[35], 0, GD_KT, entry35, 0);
    SETGATE(idt[36], 0, GD_KT, entry36, 0);
    SETGATE(idt[37], 0, GD_KT, entry37, 0);
    SETGATE(idt[38], 0, GD_KT, entry38, 0);
    SETGATE(idt[39], 0, GD_KT, entry39, 0);
    SETGATE(idt[40], 0, GD_KT, entry40, 0);
    SETGATE(idt[41], 0, GD_KT, entry41, 0);
    SETGATE(idt[42], 0, GD_KT, entry42, 0);
    SETGATE(idt[43], 0, GD_KT, entry43, 0);
    SETGATE(idt[44], 0, GD_KT, entry44, 0);
    SETGATE(idt[45], 0, GD_KT, entry45, 0);
    SETGATE(idt[46], 0, GD_KT, entry46, 0);
    SETGATE(idt[47], 0, GD_KT, entry47, 0);

//  SETGATE (idt[IRQ_OFFSET + 0], 0, GD_KT, routine_irq0, 0);
//  SETGATE (idt[IRQ_OFFSET + 1], 0, GD_KT, routine_irq1, 0);
//  SETGATE (idt[IRQ_OFFSET + 2], 0, GD_KT, routine_irq2, 0);
//  SETGATE (idt[IRQ_OFFSET + 3], 0, GD_KT, routine_irq3, 0);
//  SETGATE (idt[IRQ_OFFSET + 4], 0, GD_KT, routine_irq4, 0);
//  SETGATE (idt[IRQ_OFFSET + 5], 0, GD_KT, routine_irq5, 0);
//  SETGATE (idt[IRQ_OFFSET + 6], 0, GD_KT, routine_irq6, 0);
//  SETGATE (idt[IRQ_OFFSET + 7], 0, GD_KT, routine_irq7, 0);
//  SETGATE (idt[IRQ_OFFSET + 8], 0, GD_KT, routine_irq8, 0);
//  SETGATE (idt[IRQ_OFFSET + 9], 0, GD_KT, routine_irq9, 0);
//  SETGATE (idt[IRQ_OFFSET + 10], 0, GD_KT, routine_irq10, 0);
//  SETGATE (idt[IRQ_OFFSET + 11], 0, GD_KT, routine_irq11, 0);
//  SETGATE (idt[IRQ_OFFSET + 12], 0, GD_KT, routine_irq12, 0);
//  SETGATE (idt[IRQ_OFFSET + 13], 0, GD_KT, routine_irq13, 0);
//  SETGATE (idt[IRQ_OFFSET + 14], 0, GD_KT, routine_irq14, 0);
//  SETGATE (idt[IRQ_OFFSET + 15], 0, GD_KT, routine_irq15, 0);

idt_pd.pd_lim = sizeof(idt)-1;

    idt_pd.pd_base = (uint64_t)idt;

	// Per-CPU setup
	trap_init_percpu();
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
	// The example code here sets up the Task State Segment (TSS) and
	// the TSS descriptor for CPU 0. But it is incorrect if we are
	// running on other CPUs because each CPU has its own kernel stack.
	// Fix the code so that it works for all CPUs.
	//
	// Hints:
	//   - The macro "thiscpu" always refers to the current CPU's
	//     struct CpuInfo;
	//   - The ID of the current CPU is given by cpunum() or
	//     thiscpu->cpu_id;
	//   - Use "thiscpu->cpu_ts" as the TSS for the current CPU,
	//     rather than the global "ts" variable;
	//   - Use gdt[(GD_TSS0 >> 3) + 2*i] for CPU i's TSS descriptor;
	//   - You mapped the per-CPU kernel stacks in mem_init_mp()
	//
	// ltr sets a 'busy' flag in the TSS selector, so if you
	// accidentally load the same TSS on more than one CPU, you'll
	// get a triple fault.  If you set up an individual CPU's TSS
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:


	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.



	int id=cpunum();
	thiscpu->cpu_ts.ts_esp0 = (uintptr_t)percpu_kstacks[id]+KSTKSIZE;
	// Initialize the TSS slot of the gdt.
	SETTSS((struct SystemSegdesc64 *)((gdt_pd>>16)+40+id*16),STS_T64A, (uint64_t) (&thiscpu->cpu_ts),sizeof(struct Taskstate), 0);
	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0+id*16);


	// Load the IDT
	lidt(&idt_pd);
}

void
print_trapframe(struct Trapframe *tf)
{
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
		cprintf("  cr2  0x%08x\n", rcr2());
	cprintf("  err  0x%08x", tf->tf_err);
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
	cprintf("  rip  0x%08x\n", tf->tf_rip);
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
	if ((tf->tf_cs & 3) != 0) {
		cprintf("  rsp  0x%08x\n", tf->tf_rsp);
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
	}
}

void
print_regs(struct PushRegs *regs)
{
	cprintf("  r15  0x%08x\n", regs->reg_r15);
	cprintf("  r14  0x%08x\n", regs->reg_r14);
	cprintf("  r13  0x%08x\n", regs->reg_r13);
	cprintf("  r12  0x%08x\n", regs->reg_r12);
	cprintf("  r11  0x%08x\n", regs->reg_r11);
	cprintf("  r10  0x%08x\n", regs->reg_r10);
	cprintf("  r9  0x%08x\n", regs->reg_r9);
	cprintf("  r8  0x%08x\n", regs->reg_r8);
	cprintf("  rdi  0x%08x\n", regs->reg_rdi);
	cprintf("  rsi  0x%08x\n", regs->reg_rsi);
	cprintf("  rbp  0x%08x\n", regs->reg_rbp);
	cprintf("  rbx  0x%08x\n", regs->reg_rbx);
	cprintf("  rdx  0x%08x\n", regs->reg_rdx);
	cprintf("  rcx  0x%08x\n", regs->reg_rcx);
	cprintf("  rax  0x%08x\n", regs->reg_rax);
}

static void
trap_dispatch(struct Trapframe *tf)
{

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.


	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
		cprintf("Spurious interrupt on irq 7\n");
		print_trapframe(tf);
		return;
	}



	// Handle clock interrupts. Don't forget to acknowledge the
	// interrupt using lapic_eoi() before calling the scheduler!
	// LAB 4: Your code here.


	// Add time tick increment to clock interrupts.
	// Be careful! In multiprocessors, clock interrupts are
	// triggered on every CPU.
	// LAB 6: Your code here.


	// Handle keyboard and serial interrupts.
	// LAB 5: Your code here.


	// Handle processor exceptions.
	// LAB 3: Your code here.
	switch (tf->tf_trapno)
	{
		case T_PGFLT:
		page_fault_handler(tf);
		break;

		case T_BRKPT:
		monitor(tf);
		break;

		case T_DEBUG: 
		monitor(tf);
		break;

		case T_SYSCALL:
		tf->tf_regs.reg_rax = syscall(tf->tf_regs.reg_rax, tf->tf_regs.reg_rdx, tf->tf_regs.reg_rcx, tf->tf_regs.reg_rbx, tf->tf_regs.reg_rdi, tf->tf_regs.reg_rsi);
		break;

		case IRQ_OFFSET+IRQ_TIMER:
		lapic_eoi();
		sched_yield();
		break;

		case IRQ_OFFSET+IRQ_KBD:
		kbd_intr();
		break;

		case IRQ_OFFSET+IRQ_SERIAL:
		serial_intr();
		break;
		
		default:
	// Unexpected trap: The user process or the kernel has a bug.
		print_trapframe(tf);
		if (tf->tf_cs == GD_KT)
			panic("unhandled trap in kernel");
		else {
			env_destroy(curenv);
			return;

		}

	}
}

void
trap(struct Trapframe *tf)
{
	//struct Trapframe *tf = &tf_;
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");

	// Halt the CPU if some other CPU has called panic()
	extern char *panicstr;
	if (panicstr)
		asm volatile("hlt");

	// Re-acqurie the big kernel lock if we were halted in
	// sched_yield()
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
		lock_kernel();
	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));

	if ((tf->tf_cs & 3) == 3) {
		// Trapped from user mode.
		// Acquire the big kernel lock before doing any
		// serious kernel work.
		// LAB 4: Your code here.

		lock_kernel();

		assert(curenv);

		// Garbage collect if current enviroment is a zombie
		if (curenv->env_status == ENV_DYING) {
			env_free(curenv);
			curenv = NULL;
			sched_yield();
		}

		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNING)
		env_run(curenv);
	else
		sched_yield();
}


void
page_fault_handler(struct Trapframe *tf)
{
	uint64_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.


	if (!(tf->tf_cs&3))
		panic ("kernel mode pauge fault happened!");
	// LAB 4: Your code here.

	if (curenv->env_pgfault_upcall){
		struct UTrapframe *utf;
		utf = (struct UTrapframe *)( (tf->tf_rsp>=UXSTACKTOP-PGSIZE && tf->tf_rsp<UXSTACKTOP)?tf->tf_rsp-sizeof(struct UTrapframe)-8:UXSTACKTOP-sizeof(struct UTrapframe) );
		user_mem_assert(curenv, (void*)utf, sizeof(struct UTrapframe),  PTE_P|PTE_U|PTE_W);
		utf->utf_eflags = tf->tf_eflags;
		utf->utf_rip = tf->tf_rip;
		utf->utf_err = tf->tf_err;
		utf->utf_fault_va = fault_va;
		utf->utf_regs = tf->tf_regs;
		utf->utf_rsp = tf->tf_rsp;
		curenv->env_tf.tf_rip = (uintptr_t)curenv->env_pgfault_upcall;
		curenv->env_tf.tf_rsp = (uintptr_t)utf;
		env_run(curenv);
		return;
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
		curenv->env_id, fault_va, tf->tf_rip);
	print_trapframe(tf);
	env_destroy(curenv);
}

