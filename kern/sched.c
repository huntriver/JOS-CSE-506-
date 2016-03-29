#include <inc/assert.h>
#include <inc/x86.h>
#include <kern/spinlock.h>
#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/monitor.h>

void sched_halt(void);

// Choose a user environment to run and run it.
void
sched_yield(void)
{
	struct Env *idle;

	// Implement simple round-robin scheduling.
	//
	// Search through 'envs' for an ENV_RUNNABLE environment in
	// circular fashion starting just after the env this CPU was
	// last running.  Switch to the first such environment found.
	//
	// If no envs are runnable, but the environment previously
	// running on this CPU is still ENV_RUNNING, it's okay to
	// choose that environment.
	//
	// Never choose an environment that's currently running on
	// another CPU (env_status == ENV_RUNNING). If there are
	// no runnable environments, simply drop through to the code
	// below to halt the cpu.

	// LAB 4: Your code here.


	int i=curenv?(ENVX(curenv->env_id)+1)%NENV:0;
	int j;
	// while (true) {
	// 	if(envs[i].env_status == ENV_RUNNABLE)  
	// 	{  
	// 		env_run(&envs[i]);  
	// 		return;  
	// 	}
	// 	i=(i+1)%NENV;
	// 	if (i==j)
	// 		break;
	// }
	int max=-1;
	int maxid=-1;
	for (j=0;j<NENV;j++){
		
		if(envs[i].env_status == ENV_RUNNABLE)
			if (envs[i].env_priority>max){
				max=envs[i].env_priority;
				maxid=i;
			}
		i=(i+1)%NENV;
	}

	if (max>=0)
		if (!(curenv && curenv->env_status == ENV_RUNNING && curenv->env_priority>max))
			env_run(&envs[maxid]);
	
    
      if (curenv && curenv->env_status == ENV_RUNNING) {
       env_run(curenv);
    }



	// int now, i;
 //    if (curenv) {
 //        now = (ENVX(curenv->env_id) + 1)% NENV;
 //    } else {
 //        now = 0;
 //    }
 //    for (i = 0; i < NENV; i++, now = (now + 1) % NENV) {
 //        if (now == 1) cprintf("%d  %d\n",ENV_RUNNABLE,envs[now].env_status);
 //        if (envs[now].env_status == ENV_RUNNABLE) {
 //            env_run(&envs[now]);
 //        }
 //    }
 //    if (curenv && curenv->env_status == ENV_RUNNING) {
 //       env_run(curenv);
 //    }


	// sched_halt never returns
	sched_halt();
}

// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
			envs[i].env_status == ENV_RUNNING ||
			envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
		while (1)
			monitor(NULL);
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
	lcr3(PADDR(boot_pml4e));

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);

	// Release the big kernel lock as if we were "leaving" the kernel
	unlock_kernel();

	// Reset stack pointer, enable interrupts and then halt.
	asm volatile (
		"movq $0, %%rbp\n"
		"movq %0, %%rsp\n"
		"pushq $0\n"
		"pushq $0\n"
		"sti\n"
		"hlt\n"
		: : "a" (thiscpu->cpu_ts.ts_esp0));
}

