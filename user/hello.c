// hello, world
#include <inc/lib.h>

int share = 1;
void
umain(int argc, char **argv)
{
	// int i;
	// sys_set_priority(0,500);
	// if ((i=fork())!=0)
	// {
	// 	sys_set_priority(i,100);
	// 	if ((i=fork())!=0)
	// 	{
	// 		sys_set_priority(i,200);	
	// 		if ((i=fork())!=0)
	// 		{
	// 			sys_set_priority(i,300);
	// 			if ((i=fork())!=0)
	// 			{
	// 				sys_set_priority(i,400);	
	// 			}	
	// 		}
	// 	}	
	// }
	// struct Env *env=(struct Env *) envs + ENVX (sys_getenvid ());
	// cprintf("%04x: On the environment with priority %d\n",sys_getenvid(),env->env_priority);

	//test sfork:
int ch = sfork ();
	if (ch != 0) {
 cprintf ("I’m parent with share num = %d\n", share);
 share = 2;
 } else {
 cprintf ("I’m child with share num = %d\n", share);
 }

}
