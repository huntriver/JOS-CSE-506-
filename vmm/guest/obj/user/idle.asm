
vmm/guest/obj/user/idle:     file format elf64-x86-64


Disassembly of section .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 36 00 00 00       	callq  800077 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	binaryname = "idle";
  800052:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800059:	00 00 00 
  80005c:	48 ba c0 36 80 00 00 	movabs $0x8036c0,%rdx
  800063:	00 00 00 
  800066:	48 89 10             	mov    %rdx,(%rax)
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800069:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  800070:	00 00 00 
  800073:	ff d0                	callq  *%rax
	}
  800075:	eb f2                	jmp    800069 <umain+0x26>

0000000000800077 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800077:	55                   	push   %rbp
  800078:	48 89 e5             	mov    %rsp,%rbp
  80007b:	48 83 ec 10          	sub    $0x10,%rsp
  80007f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800082:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  800086:	48 b8 77 02 80 00 00 	movabs $0x800277,%rax
  80008d:	00 00 00 
  800090:	ff d0                	callq  *%rax
  800092:	48 98                	cltq   
  800094:	25 ff 03 00 00       	and    $0x3ff,%eax
  800099:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8000a0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000a7:	00 00 00 
  8000aa:	48 01 c2             	add    %rax,%rdx
  8000ad:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000b4:	00 00 00 
  8000b7:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000be:	7e 14                	jle    8000d4 <libmain+0x5d>
		binaryname = argv[0];
  8000c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000c4:	48 8b 10             	mov    (%rax),%rdx
  8000c7:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000ce:	00 00 00 
  8000d1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000db:	48 89 d6             	mov    %rdx,%rsi
  8000de:	89 c7                	mov    %eax,%edi
  8000e0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000ec:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	callq  *%rax
}
  8000f8:	c9                   	leaveq 
  8000f9:	c3                   	retq   

00000000008000fa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fa:	55                   	push   %rbp
  8000fb:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8000fe:	48 b8 cf 09 80 00 00 	movabs $0x8009cf,%rax
  800105:	00 00 00 
  800108:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80010a:	bf 00 00 00 00       	mov    $0x0,%edi
  80010f:	48 b8 33 02 80 00 00 	movabs $0x800233,%rax
  800116:	00 00 00 
  800119:	ff d0                	callq  *%rax
}
  80011b:	5d                   	pop    %rbp
  80011c:	c3                   	retq   

000000000080011d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80011d:	55                   	push   %rbp
  80011e:	48 89 e5             	mov    %rsp,%rbp
  800121:	53                   	push   %rbx
  800122:	48 83 ec 48          	sub    $0x48,%rsp
  800126:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800129:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80012c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800130:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800134:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800138:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80013c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80013f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800143:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800147:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80014b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80014f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800153:	4c 89 c3             	mov    %r8,%rbx
  800156:	cd 30                	int    $0x30
  800158:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80015c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800160:	74 3e                	je     8001a0 <syscall+0x83>
  800162:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800167:	7e 37                	jle    8001a0 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800169:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80016d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800170:	49 89 d0             	mov    %rdx,%r8
  800173:	89 c1                	mov    %eax,%ecx
  800175:	48 ba cf 36 80 00 00 	movabs $0x8036cf,%rdx
  80017c:	00 00 00 
  80017f:	be 23 00 00 00       	mov    $0x23,%esi
  800184:	48 bf ec 36 80 00 00 	movabs $0x8036ec,%rdi
  80018b:	00 00 00 
  80018e:	b8 00 00 00 00       	mov    $0x0,%eax
  800193:	49 b9 6e 1e 80 00 00 	movabs $0x801e6e,%r9
  80019a:	00 00 00 
  80019d:	41 ff d1             	callq  *%r9

	return ret;
  8001a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001a4:	48 83 c4 48          	add    $0x48,%rsp
  8001a8:	5b                   	pop    %rbx
  8001a9:	5d                   	pop    %rbp
  8001aa:	c3                   	retq   

00000000008001ab <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001ab:	55                   	push   %rbp
  8001ac:	48 89 e5             	mov    %rsp,%rbp
  8001af:	48 83 ec 20          	sub    $0x20,%rsp
  8001b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001ca:	00 
  8001cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001d7:	48 89 d1             	mov    %rdx,%rcx
  8001da:	48 89 c2             	mov    %rax,%rdx
  8001dd:	be 00 00 00 00       	mov    $0x0,%esi
  8001e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e7:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8001ee:	00 00 00 
  8001f1:	ff d0                	callq  *%rax
}
  8001f3:	c9                   	leaveq 
  8001f4:	c3                   	retq   

00000000008001f5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001f5:	55                   	push   %rbp
  8001f6:	48 89 e5             	mov    %rsp,%rbp
  8001f9:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800204:	00 
  800205:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80020b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800211:	b9 00 00 00 00       	mov    $0x0,%ecx
  800216:	ba 00 00 00 00       	mov    $0x0,%edx
  80021b:	be 00 00 00 00       	mov    $0x0,%esi
  800220:	bf 01 00 00 00       	mov    $0x1,%edi
  800225:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  80022c:	00 00 00 
  80022f:	ff d0                	callq  *%rax
}
  800231:	c9                   	leaveq 
  800232:	c3                   	retq   

0000000000800233 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800233:	55                   	push   %rbp
  800234:	48 89 e5             	mov    %rsp,%rbp
  800237:	48 83 ec 10          	sub    $0x10,%rsp
  80023b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80023e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800241:	48 98                	cltq   
  800243:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80024a:	00 
  80024b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800251:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800257:	b9 00 00 00 00       	mov    $0x0,%ecx
  80025c:	48 89 c2             	mov    %rax,%rdx
  80025f:	be 01 00 00 00       	mov    $0x1,%esi
  800264:	bf 03 00 00 00       	mov    $0x3,%edi
  800269:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  800270:	00 00 00 
  800273:	ff d0                	callq  *%rax
}
  800275:	c9                   	leaveq 
  800276:	c3                   	retq   

0000000000800277 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800277:	55                   	push   %rbp
  800278:	48 89 e5             	mov    %rsp,%rbp
  80027b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80027f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800286:	00 
  800287:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80028d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800293:	b9 00 00 00 00       	mov    $0x0,%ecx
  800298:	ba 00 00 00 00       	mov    $0x0,%edx
  80029d:	be 00 00 00 00       	mov    $0x0,%esi
  8002a2:	bf 02 00 00 00       	mov    $0x2,%edi
  8002a7:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8002ae:	00 00 00 
  8002b1:	ff d0                	callq  *%rax
}
  8002b3:	c9                   	leaveq 
  8002b4:	c3                   	retq   

00000000008002b5 <sys_yield>:

void
sys_yield(void)
{
  8002b5:	55                   	push   %rbp
  8002b6:	48 89 e5             	mov    %rsp,%rbp
  8002b9:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002bd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002c4:	00 
  8002c5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8002db:	be 00 00 00 00       	mov    $0x0,%esi
  8002e0:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002e5:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8002ec:	00 00 00 
  8002ef:	ff d0                	callq  *%rax
}
  8002f1:	c9                   	leaveq 
  8002f2:	c3                   	retq   

00000000008002f3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002f3:	55                   	push   %rbp
  8002f4:	48 89 e5             	mov    %rsp,%rbp
  8002f7:	48 83 ec 20          	sub    $0x20,%rsp
  8002fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800302:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800305:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800308:	48 63 c8             	movslq %eax,%rcx
  80030b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80030f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800312:	48 98                	cltq   
  800314:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80031b:	00 
  80031c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800322:	49 89 c8             	mov    %rcx,%r8
  800325:	48 89 d1             	mov    %rdx,%rcx
  800328:	48 89 c2             	mov    %rax,%rdx
  80032b:	be 01 00 00 00       	mov    $0x1,%esi
  800330:	bf 04 00 00 00       	mov    $0x4,%edi
  800335:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
}
  800341:	c9                   	leaveq 
  800342:	c3                   	retq   

0000000000800343 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800343:	55                   	push   %rbp
  800344:	48 89 e5             	mov    %rsp,%rbp
  800347:	48 83 ec 30          	sub    $0x30,%rsp
  80034b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80034e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800352:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800355:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800359:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80035d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800360:	48 63 c8             	movslq %eax,%rcx
  800363:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800367:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80036a:	48 63 f0             	movslq %eax,%rsi
  80036d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800371:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800374:	48 98                	cltq   
  800376:	48 89 0c 24          	mov    %rcx,(%rsp)
  80037a:	49 89 f9             	mov    %rdi,%r9
  80037d:	49 89 f0             	mov    %rsi,%r8
  800380:	48 89 d1             	mov    %rdx,%rcx
  800383:	48 89 c2             	mov    %rax,%rdx
  800386:	be 01 00 00 00       	mov    $0x1,%esi
  80038b:	bf 05 00 00 00       	mov    $0x5,%edi
  800390:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  800397:	00 00 00 
  80039a:	ff d0                	callq  *%rax
}
  80039c:	c9                   	leaveq 
  80039d:	c3                   	retq   

000000000080039e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80039e:	55                   	push   %rbp
  80039f:	48 89 e5             	mov    %rsp,%rbp
  8003a2:	48 83 ec 20          	sub    $0x20,%rsp
  8003a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003b4:	48 98                	cltq   
  8003b6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003bd:	00 
  8003be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003ca:	48 89 d1             	mov    %rdx,%rcx
  8003cd:	48 89 c2             	mov    %rax,%rdx
  8003d0:	be 01 00 00 00       	mov    $0x1,%esi
  8003d5:	bf 06 00 00 00       	mov    $0x6,%edi
  8003da:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8003e1:	00 00 00 
  8003e4:	ff d0                	callq  *%rax
}
  8003e6:	c9                   	leaveq 
  8003e7:	c3                   	retq   

00000000008003e8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003e8:	55                   	push   %rbp
  8003e9:	48 89 e5             	mov    %rsp,%rbp
  8003ec:	48 83 ec 10          	sub    $0x10,%rsp
  8003f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003f3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003f9:	48 63 d0             	movslq %eax,%rdx
  8003fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ff:	48 98                	cltq   
  800401:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800408:	00 
  800409:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80040f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800415:	48 89 d1             	mov    %rdx,%rcx
  800418:	48 89 c2             	mov    %rax,%rdx
  80041b:	be 01 00 00 00       	mov    $0x1,%esi
  800420:	bf 08 00 00 00       	mov    $0x8,%edi
  800425:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  80042c:	00 00 00 
  80042f:	ff d0                	callq  *%rax
}
  800431:	c9                   	leaveq 
  800432:	c3                   	retq   

0000000000800433 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800433:	55                   	push   %rbp
  800434:	48 89 e5             	mov    %rsp,%rbp
  800437:	48 83 ec 20          	sub    $0x20,%rsp
  80043b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80043e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800442:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800446:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800449:	48 98                	cltq   
  80044b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800452:	00 
  800453:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800459:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80045f:	48 89 d1             	mov    %rdx,%rcx
  800462:	48 89 c2             	mov    %rax,%rdx
  800465:	be 01 00 00 00       	mov    $0x1,%esi
  80046a:	bf 09 00 00 00       	mov    $0x9,%edi
  80046f:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  800476:	00 00 00 
  800479:	ff d0                	callq  *%rax
}
  80047b:	c9                   	leaveq 
  80047c:	c3                   	retq   

000000000080047d <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80047d:	55                   	push   %rbp
  80047e:	48 89 e5             	mov    %rsp,%rbp
  800481:	48 83 ec 20          	sub    $0x20,%rsp
  800485:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800488:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80048c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800490:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800493:	48 98                	cltq   
  800495:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80049c:	00 
  80049d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004a9:	48 89 d1             	mov    %rdx,%rcx
  8004ac:	48 89 c2             	mov    %rax,%rdx
  8004af:	be 01 00 00 00       	mov    $0x1,%esi
  8004b4:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004b9:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8004c0:	00 00 00 
  8004c3:	ff d0                	callq  *%rax
}
  8004c5:	c9                   	leaveq 
  8004c6:	c3                   	retq   

00000000008004c7 <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  8004c7:	55                   	push   %rbp
  8004c8:	48 89 e5             	mov    %rsp,%rbp
  8004cb:	48 83 ec 10          	sub    $0x10,%rsp
  8004cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004d2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  8004d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004d8:	48 63 d0             	movslq %eax,%rdx
  8004db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004de:	48 98                	cltq   
  8004e0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004e7:	00 
  8004e8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004f4:	48 89 d1             	mov    %rdx,%rcx
  8004f7:	48 89 c2             	mov    %rax,%rdx
  8004fa:	be 01 00 00 00       	mov    $0x1,%esi
  8004ff:	bf 11 00 00 00       	mov    $0x11,%edi
  800504:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  80050b:	00 00 00 
  80050e:	ff d0                	callq  *%rax

}
  800510:	c9                   	leaveq 
  800511:	c3                   	retq   

0000000000800512 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800512:	55                   	push   %rbp
  800513:	48 89 e5             	mov    %rsp,%rbp
  800516:	48 83 ec 20          	sub    $0x20,%rsp
  80051a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80051d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800521:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800525:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800528:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80052b:	48 63 f0             	movslq %eax,%rsi
  80052e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800532:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800535:	48 98                	cltq   
  800537:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80053b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800542:	00 
  800543:	49 89 f1             	mov    %rsi,%r9
  800546:	49 89 c8             	mov    %rcx,%r8
  800549:	48 89 d1             	mov    %rdx,%rcx
  80054c:	48 89 c2             	mov    %rax,%rdx
  80054f:	be 00 00 00 00       	mov    $0x0,%esi
  800554:	bf 0c 00 00 00       	mov    $0xc,%edi
  800559:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  800560:	00 00 00 
  800563:	ff d0                	callq  *%rax
}
  800565:	c9                   	leaveq 
  800566:	c3                   	retq   

0000000000800567 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800567:	55                   	push   %rbp
  800568:	48 89 e5             	mov    %rsp,%rbp
  80056b:	48 83 ec 10          	sub    $0x10,%rsp
  80056f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800573:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800577:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80057e:	00 
  80057f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800585:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80058b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800590:	48 89 c2             	mov    %rax,%rdx
  800593:	be 01 00 00 00       	mov    $0x1,%esi
  800598:	bf 0d 00 00 00       	mov    $0xd,%edi
  80059d:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8005a4:	00 00 00 
  8005a7:	ff d0                	callq  *%rax
}
  8005a9:	c9                   	leaveq 
  8005aa:	c3                   	retq   

00000000008005ab <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8005ab:	55                   	push   %rbp
  8005ac:	48 89 e5             	mov    %rsp,%rbp
  8005af:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8005b3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005ba:	00 
  8005bb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005c1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d1:	be 00 00 00 00       	mov    $0x0,%esi
  8005d6:	bf 0e 00 00 00       	mov    $0xe,%edi
  8005db:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8005e2:	00 00 00 
  8005e5:	ff d0                	callq  *%rax
}
  8005e7:	c9                   	leaveq 
  8005e8:	c3                   	retq   

00000000008005e9 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8005e9:	55                   	push   %rbp
  8005ea:	48 89 e5             	mov    %rsp,%rbp
  8005ed:	48 83 ec 30          	sub    $0x30,%rsp
  8005f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8005f8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8005fb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8005ff:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  800603:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800606:	48 63 c8             	movslq %eax,%rcx
  800609:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80060d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800610:	48 63 f0             	movslq %eax,%rsi
  800613:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800617:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80061a:	48 98                	cltq   
  80061c:	48 89 0c 24          	mov    %rcx,(%rsp)
  800620:	49 89 f9             	mov    %rdi,%r9
  800623:	49 89 f0             	mov    %rsi,%r8
  800626:	48 89 d1             	mov    %rdx,%rcx
  800629:	48 89 c2             	mov    %rax,%rdx
  80062c:	be 00 00 00 00       	mov    $0x0,%esi
  800631:	bf 0f 00 00 00       	mov    $0xf,%edi
  800636:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  80063d:	00 00 00 
  800640:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  800642:	c9                   	leaveq 
  800643:	c3                   	retq   

0000000000800644 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  800644:	55                   	push   %rbp
  800645:	48 89 e5             	mov    %rsp,%rbp
  800648:	48 83 ec 20          	sub    $0x20,%rsp
  80064c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800650:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  800654:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800658:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80065c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800663:	00 
  800664:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80066a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800670:	48 89 d1             	mov    %rdx,%rcx
  800673:	48 89 c2             	mov    %rax,%rdx
  800676:	be 00 00 00 00       	mov    $0x0,%esi
  80067b:	bf 10 00 00 00       	mov    $0x10,%edi
  800680:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  800687:	00 00 00 
  80068a:	ff d0                	callq  *%rax
}
  80068c:	c9                   	leaveq 
  80068d:	c3                   	retq   

000000000080068e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80068e:	55                   	push   %rbp
  80068f:	48 89 e5             	mov    %rsp,%rbp
  800692:	48 83 ec 08          	sub    $0x8,%rsp
  800696:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80069a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80069e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8006a5:	ff ff ff 
  8006a8:	48 01 d0             	add    %rdx,%rax
  8006ab:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8006af:	c9                   	leaveq 
  8006b0:	c3                   	retq   

00000000008006b1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8006b1:	55                   	push   %rbp
  8006b2:	48 89 e5             	mov    %rsp,%rbp
  8006b5:	48 83 ec 08          	sub    $0x8,%rsp
  8006b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8006bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006c1:	48 89 c7             	mov    %rax,%rdi
  8006c4:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  8006cb:	00 00 00 
  8006ce:	ff d0                	callq  *%rax
  8006d0:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8006d6:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006da:	c9                   	leaveq 
  8006db:	c3                   	retq   

00000000008006dc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8006dc:	55                   	push   %rbp
  8006dd:	48 89 e5             	mov    %rsp,%rbp
  8006e0:	48 83 ec 18          	sub    $0x18,%rsp
  8006e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8006e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8006ef:	eb 6b                	jmp    80075c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8006f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8006f4:	48 98                	cltq   
  8006f6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8006fc:	48 c1 e0 0c          	shl    $0xc,%rax
  800700:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800704:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800708:	48 c1 e8 15          	shr    $0x15,%rax
  80070c:	48 89 c2             	mov    %rax,%rdx
  80070f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800716:	01 00 00 
  800719:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80071d:	83 e0 01             	and    $0x1,%eax
  800720:	48 85 c0             	test   %rax,%rax
  800723:	74 21                	je     800746 <fd_alloc+0x6a>
  800725:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800729:	48 c1 e8 0c          	shr    $0xc,%rax
  80072d:	48 89 c2             	mov    %rax,%rdx
  800730:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800737:	01 00 00 
  80073a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80073e:	83 e0 01             	and    $0x1,%eax
  800741:	48 85 c0             	test   %rax,%rax
  800744:	75 12                	jne    800758 <fd_alloc+0x7c>
			*fd_store = fd;
  800746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80074e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800751:	b8 00 00 00 00       	mov    $0x0,%eax
  800756:	eb 1a                	jmp    800772 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800758:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80075c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800760:	7e 8f                	jle    8006f1 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800766:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80076d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800772:	c9                   	leaveq 
  800773:	c3                   	retq   

0000000000800774 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800774:	55                   	push   %rbp
  800775:	48 89 e5             	mov    %rsp,%rbp
  800778:	48 83 ec 20          	sub    $0x20,%rsp
  80077c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80077f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800783:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800787:	78 06                	js     80078f <fd_lookup+0x1b>
  800789:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80078d:	7e 07                	jle    800796 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80078f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800794:	eb 6c                	jmp    800802 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800796:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800799:	48 98                	cltq   
  80079b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8007a1:	48 c1 e0 0c          	shl    $0xc,%rax
  8007a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8007a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007ad:	48 c1 e8 15          	shr    $0x15,%rax
  8007b1:	48 89 c2             	mov    %rax,%rdx
  8007b4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8007bb:	01 00 00 
  8007be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007c2:	83 e0 01             	and    $0x1,%eax
  8007c5:	48 85 c0             	test   %rax,%rax
  8007c8:	74 21                	je     8007eb <fd_lookup+0x77>
  8007ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007ce:	48 c1 e8 0c          	shr    $0xc,%rax
  8007d2:	48 89 c2             	mov    %rax,%rdx
  8007d5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8007dc:	01 00 00 
  8007df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007e3:	83 e0 01             	and    $0x1,%eax
  8007e6:	48 85 c0             	test   %rax,%rax
  8007e9:	75 07                	jne    8007f2 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8007eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f0:	eb 10                	jmp    800802 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8007f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007fa:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8007fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800802:	c9                   	leaveq 
  800803:	c3                   	retq   

0000000000800804 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800804:	55                   	push   %rbp
  800805:	48 89 e5             	mov    %rsp,%rbp
  800808:	48 83 ec 30          	sub    $0x30,%rsp
  80080c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800810:	89 f0                	mov    %esi,%eax
  800812:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800819:	48 89 c7             	mov    %rax,%rdi
  80081c:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  800823:	00 00 00 
  800826:	ff d0                	callq  *%rax
  800828:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80082c:	48 89 d6             	mov    %rdx,%rsi
  80082f:	89 c7                	mov    %eax,%edi
  800831:	48 b8 74 07 80 00 00 	movabs $0x800774,%rax
  800838:	00 00 00 
  80083b:	ff d0                	callq  *%rax
  80083d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800840:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800844:	78 0a                	js     800850 <fd_close+0x4c>
	    || fd != fd2)
  800846:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80084a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80084e:	74 12                	je     800862 <fd_close+0x5e>
		return (must_exist ? r : 0);
  800850:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800854:	74 05                	je     80085b <fd_close+0x57>
  800856:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800859:	eb 05                	jmp    800860 <fd_close+0x5c>
  80085b:	b8 00 00 00 00       	mov    $0x0,%eax
  800860:	eb 69                	jmp    8008cb <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800862:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800866:	8b 00                	mov    (%rax),%eax
  800868:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80086c:	48 89 d6             	mov    %rdx,%rsi
  80086f:	89 c7                	mov    %eax,%edi
  800871:	48 b8 cd 08 80 00 00 	movabs $0x8008cd,%rax
  800878:	00 00 00 
  80087b:	ff d0                	callq  *%rax
  80087d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800880:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800884:	78 2a                	js     8008b0 <fd_close+0xac>
		if (dev->dev_close)
  800886:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80088e:	48 85 c0             	test   %rax,%rax
  800891:	74 16                	je     8008a9 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800893:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800897:	48 8b 40 20          	mov    0x20(%rax),%rax
  80089b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80089f:	48 89 d7             	mov    %rdx,%rdi
  8008a2:	ff d0                	callq  *%rax
  8008a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008a7:	eb 07                	jmp    8008b0 <fd_close+0xac>
		else
			r = 0;
  8008a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8008b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b4:	48 89 c6             	mov    %rax,%rsi
  8008b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8008bc:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  8008c3:	00 00 00 
  8008c6:	ff d0                	callq  *%rax
	return r;
  8008c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8008cb:	c9                   	leaveq 
  8008cc:	c3                   	retq   

00000000008008cd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8008cd:	55                   	push   %rbp
  8008ce:	48 89 e5             	mov    %rsp,%rbp
  8008d1:	48 83 ec 20          	sub    $0x20,%rsp
  8008d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8008d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8008dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008e3:	eb 41                	jmp    800926 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8008e5:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8008ec:	00 00 00 
  8008ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008f2:	48 63 d2             	movslq %edx,%rdx
  8008f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008f9:	8b 00                	mov    (%rax),%eax
  8008fb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8008fe:	75 22                	jne    800922 <dev_lookup+0x55>
			*dev = devtab[i];
  800900:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800907:	00 00 00 
  80090a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80090d:	48 63 d2             	movslq %edx,%rdx
  800910:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  800914:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800918:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80091b:	b8 00 00 00 00       	mov    $0x0,%eax
  800920:	eb 60                	jmp    800982 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800922:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800926:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80092d:	00 00 00 
  800930:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800933:	48 63 d2             	movslq %edx,%rdx
  800936:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80093a:	48 85 c0             	test   %rax,%rax
  80093d:	75 a6                	jne    8008e5 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80093f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800946:	00 00 00 
  800949:	48 8b 00             	mov    (%rax),%rax
  80094c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800952:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800955:	89 c6                	mov    %eax,%esi
  800957:	48 bf 00 37 80 00 00 	movabs $0x803700,%rdi
  80095e:	00 00 00 
  800961:	b8 00 00 00 00       	mov    $0x0,%eax
  800966:	48 b9 a7 20 80 00 00 	movabs $0x8020a7,%rcx
  80096d:	00 00 00 
  800970:	ff d1                	callq  *%rcx
	*dev = 0;
  800972:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800976:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80097d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800982:	c9                   	leaveq 
  800983:	c3                   	retq   

0000000000800984 <close>:

int
close(int fdnum)
{
  800984:	55                   	push   %rbp
  800985:	48 89 e5             	mov    %rsp,%rbp
  800988:	48 83 ec 20          	sub    $0x20,%rsp
  80098c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80098f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800993:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800996:	48 89 d6             	mov    %rdx,%rsi
  800999:	89 c7                	mov    %eax,%edi
  80099b:	48 b8 74 07 80 00 00 	movabs $0x800774,%rax
  8009a2:	00 00 00 
  8009a5:	ff d0                	callq  *%rax
  8009a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009ae:	79 05                	jns    8009b5 <close+0x31>
		return r;
  8009b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009b3:	eb 18                	jmp    8009cd <close+0x49>
	else
		return fd_close(fd, 1);
  8009b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009b9:	be 01 00 00 00       	mov    $0x1,%esi
  8009be:	48 89 c7             	mov    %rax,%rdi
  8009c1:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  8009c8:	00 00 00 
  8009cb:	ff d0                	callq  *%rax
}
  8009cd:	c9                   	leaveq 
  8009ce:	c3                   	retq   

00000000008009cf <close_all>:

void
close_all(void)
{
  8009cf:	55                   	push   %rbp
  8009d0:	48 89 e5             	mov    %rsp,%rbp
  8009d3:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8009d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8009de:	eb 15                	jmp    8009f5 <close_all+0x26>
		close(i);
  8009e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009e3:	89 c7                	mov    %eax,%edi
  8009e5:	48 b8 84 09 80 00 00 	movabs $0x800984,%rax
  8009ec:	00 00 00 
  8009ef:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8009f1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8009f5:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8009f9:	7e e5                	jle    8009e0 <close_all+0x11>
		close(i);
}
  8009fb:	c9                   	leaveq 
  8009fc:	c3                   	retq   

00000000008009fd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8009fd:	55                   	push   %rbp
  8009fe:	48 89 e5             	mov    %rsp,%rbp
  800a01:	48 83 ec 40          	sub    $0x40,%rsp
  800a05:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800a08:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800a0b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  800a0f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800a12:	48 89 d6             	mov    %rdx,%rsi
  800a15:	89 c7                	mov    %eax,%edi
  800a17:	48 b8 74 07 80 00 00 	movabs $0x800774,%rax
  800a1e:	00 00 00 
  800a21:	ff d0                	callq  *%rax
  800a23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a2a:	79 08                	jns    800a34 <dup+0x37>
		return r;
  800a2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a2f:	e9 70 01 00 00       	jmpq   800ba4 <dup+0x1a7>
	close(newfdnum);
  800a34:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a37:	89 c7                	mov    %eax,%edi
  800a39:	48 b8 84 09 80 00 00 	movabs $0x800984,%rax
  800a40:	00 00 00 
  800a43:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800a45:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a48:	48 98                	cltq   
  800a4a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800a50:	48 c1 e0 0c          	shl    $0xc,%rax
  800a54:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800a58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a5c:	48 89 c7             	mov    %rax,%rdi
  800a5f:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  800a66:	00 00 00 
  800a69:	ff d0                	callq  *%rax
  800a6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800a6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a73:	48 89 c7             	mov    %rax,%rdi
  800a76:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  800a7d:	00 00 00 
  800a80:	ff d0                	callq  *%rax
  800a82:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8a:	48 c1 e8 15          	shr    $0x15,%rax
  800a8e:	48 89 c2             	mov    %rax,%rdx
  800a91:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800a98:	01 00 00 
  800a9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a9f:	83 e0 01             	and    $0x1,%eax
  800aa2:	48 85 c0             	test   %rax,%rax
  800aa5:	74 73                	je     800b1a <dup+0x11d>
  800aa7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aab:	48 c1 e8 0c          	shr    $0xc,%rax
  800aaf:	48 89 c2             	mov    %rax,%rdx
  800ab2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800ab9:	01 00 00 
  800abc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800ac0:	83 e0 01             	and    $0x1,%eax
  800ac3:	48 85 c0             	test   %rax,%rax
  800ac6:	74 52                	je     800b1a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800ac8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acc:	48 c1 e8 0c          	shr    $0xc,%rax
  800ad0:	48 89 c2             	mov    %rax,%rdx
  800ad3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800ada:	01 00 00 
  800add:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800ae1:	25 07 0e 00 00       	and    $0xe07,%eax
  800ae6:	89 c1                	mov    %eax,%ecx
  800ae8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800aec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af0:	41 89 c8             	mov    %ecx,%r8d
  800af3:	48 89 d1             	mov    %rdx,%rcx
  800af6:	ba 00 00 00 00       	mov    $0x0,%edx
  800afb:	48 89 c6             	mov    %rax,%rsi
  800afe:	bf 00 00 00 00       	mov    $0x0,%edi
  800b03:	48 b8 43 03 80 00 00 	movabs $0x800343,%rax
  800b0a:	00 00 00 
  800b0d:	ff d0                	callq  *%rax
  800b0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b16:	79 02                	jns    800b1a <dup+0x11d>
			goto err;
  800b18:	eb 57                	jmp    800b71 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800b1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b1e:	48 c1 e8 0c          	shr    $0xc,%rax
  800b22:	48 89 c2             	mov    %rax,%rdx
  800b25:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800b2c:	01 00 00 
  800b2f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b33:	25 07 0e 00 00       	and    $0xe07,%eax
  800b38:	89 c1                	mov    %eax,%ecx
  800b3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b42:	41 89 c8             	mov    %ecx,%r8d
  800b45:	48 89 d1             	mov    %rdx,%rcx
  800b48:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4d:	48 89 c6             	mov    %rax,%rsi
  800b50:	bf 00 00 00 00       	mov    $0x0,%edi
  800b55:	48 b8 43 03 80 00 00 	movabs $0x800343,%rax
  800b5c:	00 00 00 
  800b5f:	ff d0                	callq  *%rax
  800b61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b68:	79 02                	jns    800b6c <dup+0x16f>
		goto err;
  800b6a:	eb 05                	jmp    800b71 <dup+0x174>

	return newfdnum;
  800b6c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800b6f:	eb 33                	jmp    800ba4 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800b71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b75:	48 89 c6             	mov    %rax,%rsi
  800b78:	bf 00 00 00 00       	mov    $0x0,%edi
  800b7d:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  800b84:	00 00 00 
  800b87:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800b89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b8d:	48 89 c6             	mov    %rax,%rsi
  800b90:	bf 00 00 00 00       	mov    $0x0,%edi
  800b95:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  800b9c:	00 00 00 
  800b9f:	ff d0                	callq  *%rax
	return r;
  800ba1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ba4:	c9                   	leaveq 
  800ba5:	c3                   	retq   

0000000000800ba6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800ba6:	55                   	push   %rbp
  800ba7:	48 89 e5             	mov    %rsp,%rbp
  800baa:	48 83 ec 40          	sub    $0x40,%rsp
  800bae:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bb1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bb5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bb9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800bbd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800bc0:	48 89 d6             	mov    %rdx,%rsi
  800bc3:	89 c7                	mov    %eax,%edi
  800bc5:	48 b8 74 07 80 00 00 	movabs $0x800774,%rax
  800bcc:	00 00 00 
  800bcf:	ff d0                	callq  *%rax
  800bd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bd8:	78 24                	js     800bfe <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bde:	8b 00                	mov    (%rax),%eax
  800be0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800be4:	48 89 d6             	mov    %rdx,%rsi
  800be7:	89 c7                	mov    %eax,%edi
  800be9:	48 b8 cd 08 80 00 00 	movabs $0x8008cd,%rax
  800bf0:	00 00 00 
  800bf3:	ff d0                	callq  *%rax
  800bf5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bf8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bfc:	79 05                	jns    800c03 <read+0x5d>
		return r;
  800bfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c01:	eb 76                	jmp    800c79 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c07:	8b 40 08             	mov    0x8(%rax),%eax
  800c0a:	83 e0 03             	and    $0x3,%eax
  800c0d:	83 f8 01             	cmp    $0x1,%eax
  800c10:	75 3a                	jne    800c4c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800c12:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c19:	00 00 00 
  800c1c:	48 8b 00             	mov    (%rax),%rax
  800c1f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c25:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c28:	89 c6                	mov    %eax,%esi
  800c2a:	48 bf 1f 37 80 00 00 	movabs $0x80371f,%rdi
  800c31:	00 00 00 
  800c34:	b8 00 00 00 00       	mov    $0x0,%eax
  800c39:	48 b9 a7 20 80 00 00 	movabs $0x8020a7,%rcx
  800c40:	00 00 00 
  800c43:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c45:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c4a:	eb 2d                	jmp    800c79 <read+0xd3>
	}
	if (!dev->dev_read)
  800c4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c50:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c54:	48 85 c0             	test   %rax,%rax
  800c57:	75 07                	jne    800c60 <read+0xba>
		return -E_NOT_SUPP;
  800c59:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c5e:	eb 19                	jmp    800c79 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800c60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c64:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c68:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c6c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c70:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c74:	48 89 cf             	mov    %rcx,%rdi
  800c77:	ff d0                	callq  *%rax
}
  800c79:	c9                   	leaveq 
  800c7a:	c3                   	retq   

0000000000800c7b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800c7b:	55                   	push   %rbp
  800c7c:	48 89 e5             	mov    %rsp,%rbp
  800c7f:	48 83 ec 30          	sub    $0x30,%rsp
  800c83:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c86:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c8a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800c95:	eb 49                	jmp    800ce0 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c9a:	48 98                	cltq   
  800c9c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800ca0:	48 29 c2             	sub    %rax,%rdx
  800ca3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ca6:	48 63 c8             	movslq %eax,%rcx
  800ca9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800cad:	48 01 c1             	add    %rax,%rcx
  800cb0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800cb3:	48 89 ce             	mov    %rcx,%rsi
  800cb6:	89 c7                	mov    %eax,%edi
  800cb8:	48 b8 a6 0b 80 00 00 	movabs $0x800ba6,%rax
  800cbf:	00 00 00 
  800cc2:	ff d0                	callq  *%rax
  800cc4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800cc7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ccb:	79 05                	jns    800cd2 <readn+0x57>
			return m;
  800ccd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800cd0:	eb 1c                	jmp    800cee <readn+0x73>
		if (m == 0)
  800cd2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800cd6:	75 02                	jne    800cda <readn+0x5f>
			break;
  800cd8:	eb 11                	jmp    800ceb <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800cda:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800cdd:	01 45 fc             	add    %eax,-0x4(%rbp)
  800ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ce3:	48 98                	cltq   
  800ce5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ce9:	72 ac                	jb     800c97 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800ceb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800cee:	c9                   	leaveq 
  800cef:	c3                   	retq   

0000000000800cf0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800cf0:	55                   	push   %rbp
  800cf1:	48 89 e5             	mov    %rsp,%rbp
  800cf4:	48 83 ec 40          	sub    $0x40,%rsp
  800cf8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cfb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800cff:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d03:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d07:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d0a:	48 89 d6             	mov    %rdx,%rsi
  800d0d:	89 c7                	mov    %eax,%edi
  800d0f:	48 b8 74 07 80 00 00 	movabs $0x800774,%rax
  800d16:	00 00 00 
  800d19:	ff d0                	callq  *%rax
  800d1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d22:	78 24                	js     800d48 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d28:	8b 00                	mov    (%rax),%eax
  800d2a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d2e:	48 89 d6             	mov    %rdx,%rsi
  800d31:	89 c7                	mov    %eax,%edi
  800d33:	48 b8 cd 08 80 00 00 	movabs $0x8008cd,%rax
  800d3a:	00 00 00 
  800d3d:	ff d0                	callq  *%rax
  800d3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d46:	79 05                	jns    800d4d <write+0x5d>
		return r;
  800d48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d4b:	eb 75                	jmp    800dc2 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d51:	8b 40 08             	mov    0x8(%rax),%eax
  800d54:	83 e0 03             	and    $0x3,%eax
  800d57:	85 c0                	test   %eax,%eax
  800d59:	75 3a                	jne    800d95 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800d5b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d62:	00 00 00 
  800d65:	48 8b 00             	mov    (%rax),%rax
  800d68:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d6e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d71:	89 c6                	mov    %eax,%esi
  800d73:	48 bf 3b 37 80 00 00 	movabs $0x80373b,%rdi
  800d7a:	00 00 00 
  800d7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d82:	48 b9 a7 20 80 00 00 	movabs $0x8020a7,%rcx
  800d89:	00 00 00 
  800d8c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800d8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d93:	eb 2d                	jmp    800dc2 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800d95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d99:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d9d:	48 85 c0             	test   %rax,%rax
  800da0:	75 07                	jne    800da9 <write+0xb9>
		return -E_NOT_SUPP;
  800da2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800da7:	eb 19                	jmp    800dc2 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800da9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dad:	48 8b 40 18          	mov    0x18(%rax),%rax
  800db1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800db5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800db9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800dbd:	48 89 cf             	mov    %rcx,%rdi
  800dc0:	ff d0                	callq  *%rax
}
  800dc2:	c9                   	leaveq 
  800dc3:	c3                   	retq   

0000000000800dc4 <seek>:

int
seek(int fdnum, off_t offset)
{
  800dc4:	55                   	push   %rbp
  800dc5:	48 89 e5             	mov    %rsp,%rbp
  800dc8:	48 83 ec 18          	sub    $0x18,%rsp
  800dcc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800dcf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800dd2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dd6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800dd9:	48 89 d6             	mov    %rdx,%rsi
  800ddc:	89 c7                	mov    %eax,%edi
  800dde:	48 b8 74 07 80 00 00 	movabs $0x800774,%rax
  800de5:	00 00 00 
  800de8:	ff d0                	callq  *%rax
  800dea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ded:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800df1:	79 05                	jns    800df8 <seek+0x34>
		return r;
  800df3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800df6:	eb 0f                	jmp    800e07 <seek+0x43>
	fd->fd_offset = offset;
  800df8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dfc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800dff:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800e02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e07:	c9                   	leaveq 
  800e08:	c3                   	retq   

0000000000800e09 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800e09:	55                   	push   %rbp
  800e0a:	48 89 e5             	mov    %rsp,%rbp
  800e0d:	48 83 ec 30          	sub    $0x30,%rsp
  800e11:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e14:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e17:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e1b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e1e:	48 89 d6             	mov    %rdx,%rsi
  800e21:	89 c7                	mov    %eax,%edi
  800e23:	48 b8 74 07 80 00 00 	movabs $0x800774,%rax
  800e2a:	00 00 00 
  800e2d:	ff d0                	callq  *%rax
  800e2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e36:	78 24                	js     800e5c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3c:	8b 00                	mov    (%rax),%eax
  800e3e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e42:	48 89 d6             	mov    %rdx,%rsi
  800e45:	89 c7                	mov    %eax,%edi
  800e47:	48 b8 cd 08 80 00 00 	movabs $0x8008cd,%rax
  800e4e:	00 00 00 
  800e51:	ff d0                	callq  *%rax
  800e53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e5a:	79 05                	jns    800e61 <ftruncate+0x58>
		return r;
  800e5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e5f:	eb 72                	jmp    800ed3 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e65:	8b 40 08             	mov    0x8(%rax),%eax
  800e68:	83 e0 03             	and    $0x3,%eax
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	75 3a                	jne    800ea9 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800e6f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800e76:	00 00 00 
  800e79:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800e7c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800e82:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800e85:	89 c6                	mov    %eax,%esi
  800e87:	48 bf 58 37 80 00 00 	movabs $0x803758,%rdi
  800e8e:	00 00 00 
  800e91:	b8 00 00 00 00       	mov    $0x0,%eax
  800e96:	48 b9 a7 20 80 00 00 	movabs $0x8020a7,%rcx
  800e9d:	00 00 00 
  800ea0:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800ea2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea7:	eb 2a                	jmp    800ed3 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800ea9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ead:	48 8b 40 30          	mov    0x30(%rax),%rax
  800eb1:	48 85 c0             	test   %rax,%rax
  800eb4:	75 07                	jne    800ebd <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800eb6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800ebb:	eb 16                	jmp    800ed3 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800ebd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec1:	48 8b 40 30          	mov    0x30(%rax),%rax
  800ec5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ec9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800ecc:	89 ce                	mov    %ecx,%esi
  800ece:	48 89 d7             	mov    %rdx,%rdi
  800ed1:	ff d0                	callq  *%rax
}
  800ed3:	c9                   	leaveq 
  800ed4:	c3                   	retq   

0000000000800ed5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800ed5:	55                   	push   %rbp
  800ed6:	48 89 e5             	mov    %rsp,%rbp
  800ed9:	48 83 ec 30          	sub    $0x30,%rsp
  800edd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800ee0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ee4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ee8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800eeb:	48 89 d6             	mov    %rdx,%rsi
  800eee:	89 c7                	mov    %eax,%edi
  800ef0:	48 b8 74 07 80 00 00 	movabs $0x800774,%rax
  800ef7:	00 00 00 
  800efa:	ff d0                	callq  *%rax
  800efc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800eff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f03:	78 24                	js     800f29 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f09:	8b 00                	mov    (%rax),%eax
  800f0b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f0f:	48 89 d6             	mov    %rdx,%rsi
  800f12:	89 c7                	mov    %eax,%edi
  800f14:	48 b8 cd 08 80 00 00 	movabs $0x8008cd,%rax
  800f1b:	00 00 00 
  800f1e:	ff d0                	callq  *%rax
  800f20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f27:	79 05                	jns    800f2e <fstat+0x59>
		return r;
  800f29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f2c:	eb 5e                	jmp    800f8c <fstat+0xb7>
	if (!dev->dev_stat)
  800f2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f32:	48 8b 40 28          	mov    0x28(%rax),%rax
  800f36:	48 85 c0             	test   %rax,%rax
  800f39:	75 07                	jne    800f42 <fstat+0x6d>
		return -E_NOT_SUPP;
  800f3b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800f40:	eb 4a                	jmp    800f8c <fstat+0xb7>
	stat->st_name[0] = 0;
  800f42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f46:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800f49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f4d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800f54:	00 00 00 
	stat->st_isdir = 0;
  800f57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f5b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800f62:	00 00 00 
	stat->st_dev = dev;
  800f65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f69:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f6d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f78:	48 8b 40 28          	mov    0x28(%rax),%rax
  800f7c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f80:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800f84:	48 89 ce             	mov    %rcx,%rsi
  800f87:	48 89 d7             	mov    %rdx,%rdi
  800f8a:	ff d0                	callq  *%rax
}
  800f8c:	c9                   	leaveq 
  800f8d:	c3                   	retq   

0000000000800f8e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800f8e:	55                   	push   %rbp
  800f8f:	48 89 e5             	mov    %rsp,%rbp
  800f92:	48 83 ec 20          	sub    $0x20,%rsp
  800f96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f9a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa2:	be 00 00 00 00       	mov    $0x0,%esi
  800fa7:	48 89 c7             	mov    %rax,%rdi
  800faa:	48 b8 7c 10 80 00 00 	movabs $0x80107c,%rax
  800fb1:	00 00 00 
  800fb4:	ff d0                	callq  *%rax
  800fb6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fbd:	79 05                	jns    800fc4 <stat+0x36>
		return fd;
  800fbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fc2:	eb 2f                	jmp    800ff3 <stat+0x65>
	r = fstat(fd, stat);
  800fc4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fcb:	48 89 d6             	mov    %rdx,%rsi
  800fce:	89 c7                	mov    %eax,%edi
  800fd0:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  800fd7:	00 00 00 
  800fda:	ff d0                	callq  *%rax
  800fdc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800fdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fe2:	89 c7                	mov    %eax,%edi
  800fe4:	48 b8 84 09 80 00 00 	movabs $0x800984,%rax
  800feb:	00 00 00 
  800fee:	ff d0                	callq  *%rax
	return r;
  800ff0:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ff3:	c9                   	leaveq 
  800ff4:	c3                   	retq   

0000000000800ff5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ff5:	55                   	push   %rbp
  800ff6:	48 89 e5             	mov    %rsp,%rbp
  800ff9:	48 83 ec 10          	sub    $0x10,%rsp
  800ffd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801000:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801004:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80100b:	00 00 00 
  80100e:	8b 00                	mov    (%rax),%eax
  801010:	85 c0                	test   %eax,%eax
  801012:	75 1d                	jne    801031 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801014:	bf 01 00 00 00       	mov    $0x1,%edi
  801019:	48 b8 a8 35 80 00 00 	movabs $0x8035a8,%rax
  801020:	00 00 00 
  801023:	ff d0                	callq  *%rax
  801025:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  80102c:	00 00 00 
  80102f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801031:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801038:	00 00 00 
  80103b:	8b 00                	mov    (%rax),%eax
  80103d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801040:	b9 07 00 00 00       	mov    $0x7,%ecx
  801045:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80104c:	00 00 00 
  80104f:	89 c7                	mov    %eax,%edi
  801051:	48 b8 a9 34 80 00 00 	movabs $0x8034a9,%rax
  801058:	00 00 00 
  80105b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80105d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801061:	ba 00 00 00 00       	mov    $0x0,%edx
  801066:	48 89 c6             	mov    %rax,%rsi
  801069:	bf 00 00 00 00       	mov    $0x0,%edi
  80106e:	48 b8 f6 33 80 00 00 	movabs $0x8033f6,%rax
  801075:	00 00 00 
  801078:	ff d0                	callq  *%rax
}
  80107a:	c9                   	leaveq 
  80107b:	c3                   	retq   

000000000080107c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80107c:	55                   	push   %rbp
  80107d:	48 89 e5             	mov    %rsp,%rbp
  801080:	48 83 ec 20          	sub    $0x20,%rsp
  801084:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801088:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  80108b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108f:	48 89 c7             	mov    %rax,%rdi
  801092:	48 b8 31 2c 80 00 00 	movabs $0x802c31,%rax
  801099:	00 00 00 
  80109c:	ff d0                	callq  *%rax
  80109e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8010a3:	7e 0a                	jle    8010af <open+0x33>
		return -E_BAD_PATH;
  8010a5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8010aa:	e9 a5 00 00 00       	jmpq   801154 <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  8010af:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8010b3:	48 89 c7             	mov    %rax,%rdi
  8010b6:	48 b8 dc 06 80 00 00 	movabs $0x8006dc,%rax
  8010bd:	00 00 00 
  8010c0:	ff d0                	callq  *%rax
  8010c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010c9:	79 08                	jns    8010d3 <open+0x57>
		return ret;
  8010cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ce:	e9 81 00 00 00       	jmpq   801154 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  8010d3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010da:	00 00 00 
  8010dd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8010e0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  8010e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ea:	48 89 c6             	mov    %rax,%rsi
  8010ed:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8010f4:	00 00 00 
  8010f7:	48 b8 9d 2c 80 00 00 	movabs $0x802c9d,%rax
  8010fe:	00 00 00 
  801101:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  801103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801107:	48 89 c6             	mov    %rax,%rsi
  80110a:	bf 01 00 00 00       	mov    $0x1,%edi
  80110f:	48 b8 f5 0f 80 00 00 	movabs $0x800ff5,%rax
  801116:	00 00 00 
  801119:	ff d0                	callq  *%rax
  80111b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80111e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801122:	79 1d                	jns    801141 <open+0xc5>
	{
		fd_close(fd,0);
  801124:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801128:	be 00 00 00 00       	mov    $0x0,%esi
  80112d:	48 89 c7             	mov    %rax,%rdi
  801130:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  801137:	00 00 00 
  80113a:	ff d0                	callq  *%rax
		return ret;
  80113c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80113f:	eb 13                	jmp    801154 <open+0xd8>
	}
	return fd2num (fd);
  801141:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801145:	48 89 c7             	mov    %rax,%rdi
  801148:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  80114f:	00 00 00 
  801152:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  801154:	c9                   	leaveq 
  801155:	c3                   	retq   

0000000000801156 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801156:	55                   	push   %rbp
  801157:	48 89 e5             	mov    %rsp,%rbp
  80115a:	48 83 ec 10          	sub    $0x10,%rsp
  80115e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801162:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801166:	8b 50 0c             	mov    0xc(%rax),%edx
  801169:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801170:	00 00 00 
  801173:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801175:	be 00 00 00 00       	mov    $0x0,%esi
  80117a:	bf 06 00 00 00       	mov    $0x6,%edi
  80117f:	48 b8 f5 0f 80 00 00 	movabs $0x800ff5,%rax
  801186:	00 00 00 
  801189:	ff d0                	callq  *%rax
}
  80118b:	c9                   	leaveq 
  80118c:	c3                   	retq   

000000000080118d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80118d:	55                   	push   %rbp
  80118e:	48 89 e5             	mov    %rsp,%rbp
  801191:	48 83 ec 30          	sub    $0x30,%rsp
  801195:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801199:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80119d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  8011a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a5:	8b 50 0c             	mov    0xc(%rax),%edx
  8011a8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011af:	00 00 00 
  8011b2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  8011b4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011bb:	00 00 00 
  8011be:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011c2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  8011c6:	be 00 00 00 00       	mov    $0x0,%esi
  8011cb:	bf 03 00 00 00       	mov    $0x3,%edi
  8011d0:	48 b8 f5 0f 80 00 00 	movabs $0x800ff5,%rax
  8011d7:	00 00 00 
  8011da:	ff d0                	callq  *%rax
  8011dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011e3:	79 05                	jns    8011ea <devfile_read+0x5d>
		return ret;
  8011e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011e8:	eb 26                	jmp    801210 <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  8011ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011ed:	48 63 d0             	movslq %eax,%rdx
  8011f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011f4:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8011fb:	00 00 00 
  8011fe:	48 89 c7             	mov    %rax,%rdi
  801201:	48 b8 c1 2f 80 00 00 	movabs $0x802fc1,%rax
  801208:	00 00 00 
  80120b:	ff d0                	callq  *%rax
	return ret;
  80120d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  801210:	c9                   	leaveq 
  801211:	c3                   	retq   

0000000000801212 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801212:	55                   	push   %rbp
  801213:	48 89 e5             	mov    %rsp,%rbp
  801216:	48 83 ec 30          	sub    $0x30,%rsp
  80121a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801222:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  801226:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122a:	8b 50 0c             	mov    0xc(%rax),%edx
  80122d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801234:	00 00 00 
  801237:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  801239:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  80123e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801245:	00 
  801246:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  80124b:	48 89 c2             	mov    %rax,%rdx
  80124e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801255:	00 00 00 
  801258:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  80125c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801263:	00 00 00 
  801266:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80126a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80126e:	48 89 c6             	mov    %rax,%rsi
  801271:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  801278:	00 00 00 
  80127b:	48 b8 c1 2f 80 00 00 	movabs $0x802fc1,%rax
  801282:	00 00 00 
  801285:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  801287:	be 00 00 00 00       	mov    $0x0,%esi
  80128c:	bf 04 00 00 00       	mov    $0x4,%edi
  801291:	48 b8 f5 0f 80 00 00 	movabs $0x800ff5,%rax
  801298:	00 00 00 
  80129b:	ff d0                	callq  *%rax
  80129d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012a4:	79 05                	jns    8012ab <devfile_write+0x99>
		return ret;
  8012a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012a9:	eb 03                	jmp    8012ae <devfile_write+0x9c>
	
	return ret;
  8012ab:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  8012ae:	c9                   	leaveq 
  8012af:	c3                   	retq   

00000000008012b0 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8012b0:	55                   	push   %rbp
  8012b1:	48 89 e5             	mov    %rsp,%rbp
  8012b4:	48 83 ec 20          	sub    $0x20,%rsp
  8012b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8012c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c4:	8b 50 0c             	mov    0xc(%rax),%edx
  8012c7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012ce:	00 00 00 
  8012d1:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8012d3:	be 00 00 00 00       	mov    $0x0,%esi
  8012d8:	bf 05 00 00 00       	mov    $0x5,%edi
  8012dd:	48 b8 f5 0f 80 00 00 	movabs $0x800ff5,%rax
  8012e4:	00 00 00 
  8012e7:	ff d0                	callq  *%rax
  8012e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012f0:	79 05                	jns    8012f7 <devfile_stat+0x47>
		return r;
  8012f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012f5:	eb 56                	jmp    80134d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8012f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012fb:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801302:	00 00 00 
  801305:	48 89 c7             	mov    %rax,%rdi
  801308:	48 b8 9d 2c 80 00 00 	movabs $0x802c9d,%rax
  80130f:	00 00 00 
  801312:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801314:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80131b:	00 00 00 
  80131e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801324:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801328:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80132e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801335:	00 00 00 
  801338:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80133e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801342:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801348:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134d:	c9                   	leaveq 
  80134e:	c3                   	retq   

000000000080134f <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80134f:	55                   	push   %rbp
  801350:	48 89 e5             	mov    %rsp,%rbp
  801353:	48 83 ec 10          	sub    $0x10,%rsp
  801357:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80135b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80135e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801362:	8b 50 0c             	mov    0xc(%rax),%edx
  801365:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80136c:	00 00 00 
  80136f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801371:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801378:	00 00 00 
  80137b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80137e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801381:	be 00 00 00 00       	mov    $0x0,%esi
  801386:	bf 02 00 00 00       	mov    $0x2,%edi
  80138b:	48 b8 f5 0f 80 00 00 	movabs $0x800ff5,%rax
  801392:	00 00 00 
  801395:	ff d0                	callq  *%rax
}
  801397:	c9                   	leaveq 
  801398:	c3                   	retq   

0000000000801399 <remove>:

// Delete a file
int
remove(const char *path)
{
  801399:	55                   	push   %rbp
  80139a:	48 89 e5             	mov    %rsp,%rbp
  80139d:	48 83 ec 10          	sub    $0x10,%rsp
  8013a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8013a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a9:	48 89 c7             	mov    %rax,%rdi
  8013ac:	48 b8 31 2c 80 00 00 	movabs $0x802c31,%rax
  8013b3:	00 00 00 
  8013b6:	ff d0                	callq  *%rax
  8013b8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8013bd:	7e 07                	jle    8013c6 <remove+0x2d>
		return -E_BAD_PATH;
  8013bf:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8013c4:	eb 33                	jmp    8013f9 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8013c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ca:	48 89 c6             	mov    %rax,%rsi
  8013cd:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8013d4:	00 00 00 
  8013d7:	48 b8 9d 2c 80 00 00 	movabs $0x802c9d,%rax
  8013de:	00 00 00 
  8013e1:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8013e3:	be 00 00 00 00       	mov    $0x0,%esi
  8013e8:	bf 07 00 00 00       	mov    $0x7,%edi
  8013ed:	48 b8 f5 0f 80 00 00 	movabs $0x800ff5,%rax
  8013f4:	00 00 00 
  8013f7:	ff d0                	callq  *%rax
}
  8013f9:	c9                   	leaveq 
  8013fa:	c3                   	retq   

00000000008013fb <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8013fb:	55                   	push   %rbp
  8013fc:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8013ff:	be 00 00 00 00       	mov    $0x0,%esi
  801404:	bf 08 00 00 00       	mov    $0x8,%edi
  801409:	48 b8 f5 0f 80 00 00 	movabs $0x800ff5,%rax
  801410:	00 00 00 
  801413:	ff d0                	callq  *%rax
}
  801415:	5d                   	pop    %rbp
  801416:	c3                   	retq   

0000000000801417 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801417:	55                   	push   %rbp
  801418:	48 89 e5             	mov    %rsp,%rbp
  80141b:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801422:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801429:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801430:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801437:	be 00 00 00 00       	mov    $0x0,%esi
  80143c:	48 89 c7             	mov    %rax,%rdi
  80143f:	48 b8 7c 10 80 00 00 	movabs $0x80107c,%rax
  801446:	00 00 00 
  801449:	ff d0                	callq  *%rax
  80144b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80144e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801452:	79 28                	jns    80147c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801454:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801457:	89 c6                	mov    %eax,%esi
  801459:	48 bf 7e 37 80 00 00 	movabs $0x80377e,%rdi
  801460:	00 00 00 
  801463:	b8 00 00 00 00       	mov    $0x0,%eax
  801468:	48 ba a7 20 80 00 00 	movabs $0x8020a7,%rdx
  80146f:	00 00 00 
  801472:	ff d2                	callq  *%rdx
		return fd_src;
  801474:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801477:	e9 74 01 00 00       	jmpq   8015f0 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80147c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801483:	be 01 01 00 00       	mov    $0x101,%esi
  801488:	48 89 c7             	mov    %rax,%rdi
  80148b:	48 b8 7c 10 80 00 00 	movabs $0x80107c,%rax
  801492:	00 00 00 
  801495:	ff d0                	callq  *%rax
  801497:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80149a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80149e:	79 39                	jns    8014d9 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8014a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014a3:	89 c6                	mov    %eax,%esi
  8014a5:	48 bf 94 37 80 00 00 	movabs $0x803794,%rdi
  8014ac:	00 00 00 
  8014af:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b4:	48 ba a7 20 80 00 00 	movabs $0x8020a7,%rdx
  8014bb:	00 00 00 
  8014be:	ff d2                	callq  *%rdx
		close(fd_src);
  8014c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014c3:	89 c7                	mov    %eax,%edi
  8014c5:	48 b8 84 09 80 00 00 	movabs $0x800984,%rax
  8014cc:	00 00 00 
  8014cf:	ff d0                	callq  *%rax
		return fd_dest;
  8014d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014d4:	e9 17 01 00 00       	jmpq   8015f0 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8014d9:	eb 74                	jmp    80154f <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8014db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014de:	48 63 d0             	movslq %eax,%rdx
  8014e1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8014e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014eb:	48 89 ce             	mov    %rcx,%rsi
  8014ee:	89 c7                	mov    %eax,%edi
  8014f0:	48 b8 f0 0c 80 00 00 	movabs $0x800cf0,%rax
  8014f7:	00 00 00 
  8014fa:	ff d0                	callq  *%rax
  8014fc:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8014ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801503:	79 4a                	jns    80154f <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801505:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801508:	89 c6                	mov    %eax,%esi
  80150a:	48 bf ae 37 80 00 00 	movabs $0x8037ae,%rdi
  801511:	00 00 00 
  801514:	b8 00 00 00 00       	mov    $0x0,%eax
  801519:	48 ba a7 20 80 00 00 	movabs $0x8020a7,%rdx
  801520:	00 00 00 
  801523:	ff d2                	callq  *%rdx
			close(fd_src);
  801525:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801528:	89 c7                	mov    %eax,%edi
  80152a:	48 b8 84 09 80 00 00 	movabs $0x800984,%rax
  801531:	00 00 00 
  801534:	ff d0                	callq  *%rax
			close(fd_dest);
  801536:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801539:	89 c7                	mov    %eax,%edi
  80153b:	48 b8 84 09 80 00 00 	movabs $0x800984,%rax
  801542:	00 00 00 
  801545:	ff d0                	callq  *%rax
			return write_size;
  801547:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80154a:	e9 a1 00 00 00       	jmpq   8015f0 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80154f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801556:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801559:	ba 00 02 00 00       	mov    $0x200,%edx
  80155e:	48 89 ce             	mov    %rcx,%rsi
  801561:	89 c7                	mov    %eax,%edi
  801563:	48 b8 a6 0b 80 00 00 	movabs $0x800ba6,%rax
  80156a:	00 00 00 
  80156d:	ff d0                	callq  *%rax
  80156f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801572:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801576:	0f 8f 5f ff ff ff    	jg     8014db <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80157c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801580:	79 47                	jns    8015c9 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801582:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801585:	89 c6                	mov    %eax,%esi
  801587:	48 bf c1 37 80 00 00 	movabs $0x8037c1,%rdi
  80158e:	00 00 00 
  801591:	b8 00 00 00 00       	mov    $0x0,%eax
  801596:	48 ba a7 20 80 00 00 	movabs $0x8020a7,%rdx
  80159d:	00 00 00 
  8015a0:	ff d2                	callq  *%rdx
		close(fd_src);
  8015a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015a5:	89 c7                	mov    %eax,%edi
  8015a7:	48 b8 84 09 80 00 00 	movabs $0x800984,%rax
  8015ae:	00 00 00 
  8015b1:	ff d0                	callq  *%rax
		close(fd_dest);
  8015b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015b6:	89 c7                	mov    %eax,%edi
  8015b8:	48 b8 84 09 80 00 00 	movabs $0x800984,%rax
  8015bf:	00 00 00 
  8015c2:	ff d0                	callq  *%rax
		return read_size;
  8015c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c7:	eb 27                	jmp    8015f0 <copy+0x1d9>
	}
	close(fd_src);
  8015c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015cc:	89 c7                	mov    %eax,%edi
  8015ce:	48 b8 84 09 80 00 00 	movabs $0x800984,%rax
  8015d5:	00 00 00 
  8015d8:	ff d0                	callq  *%rax
	close(fd_dest);
  8015da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015dd:	89 c7                	mov    %eax,%edi
  8015df:	48 b8 84 09 80 00 00 	movabs $0x800984,%rax
  8015e6:	00 00 00 
  8015e9:	ff d0                	callq  *%rax
	return 0;
  8015eb:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8015f0:	c9                   	leaveq 
  8015f1:	c3                   	retq   

00000000008015f2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8015f2:	55                   	push   %rbp
  8015f3:	48 89 e5             	mov    %rsp,%rbp
  8015f6:	53                   	push   %rbx
  8015f7:	48 83 ec 38          	sub    $0x38,%rsp
  8015fb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015ff:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801603:	48 89 c7             	mov    %rax,%rdi
  801606:	48 b8 dc 06 80 00 00 	movabs $0x8006dc,%rax
  80160d:	00 00 00 
  801610:	ff d0                	callq  *%rax
  801612:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801615:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801619:	0f 88 bf 01 00 00    	js     8017de <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	ba 07 04 00 00       	mov    $0x407,%edx
  801628:	48 89 c6             	mov    %rax,%rsi
  80162b:	bf 00 00 00 00       	mov    $0x0,%edi
  801630:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  801637:	00 00 00 
  80163a:	ff d0                	callq  *%rax
  80163c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80163f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801643:	0f 88 95 01 00 00    	js     8017de <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801649:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80164d:	48 89 c7             	mov    %rax,%rdi
  801650:	48 b8 dc 06 80 00 00 	movabs $0x8006dc,%rax
  801657:	00 00 00 
  80165a:	ff d0                	callq  *%rax
  80165c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80165f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801663:	0f 88 5d 01 00 00    	js     8017c6 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801669:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80166d:	ba 07 04 00 00       	mov    $0x407,%edx
  801672:	48 89 c6             	mov    %rax,%rsi
  801675:	bf 00 00 00 00       	mov    $0x0,%edi
  80167a:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  801681:	00 00 00 
  801684:	ff d0                	callq  *%rax
  801686:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801689:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80168d:	0f 88 33 01 00 00    	js     8017c6 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801693:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801697:	48 89 c7             	mov    %rax,%rdi
  80169a:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  8016a1:	00 00 00 
  8016a4:	ff d0                	callq  *%rax
  8016a6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016ae:	ba 07 04 00 00       	mov    $0x407,%edx
  8016b3:	48 89 c6             	mov    %rax,%rsi
  8016b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8016bb:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  8016c2:	00 00 00 
  8016c5:	ff d0                	callq  *%rax
  8016c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016ce:	79 05                	jns    8016d5 <pipe+0xe3>
		goto err2;
  8016d0:	e9 d9 00 00 00       	jmpq   8017ae <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016d9:	48 89 c7             	mov    %rax,%rdi
  8016dc:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  8016e3:	00 00 00 
  8016e6:	ff d0                	callq  *%rax
  8016e8:	48 89 c2             	mov    %rax,%rdx
  8016eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016ef:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8016f5:	48 89 d1             	mov    %rdx,%rcx
  8016f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fd:	48 89 c6             	mov    %rax,%rsi
  801700:	bf 00 00 00 00       	mov    $0x0,%edi
  801705:	48 b8 43 03 80 00 00 	movabs $0x800343,%rax
  80170c:	00 00 00 
  80170f:	ff d0                	callq  *%rax
  801711:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801714:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801718:	79 1b                	jns    801735 <pipe+0x143>
		goto err3;
  80171a:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80171b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80171f:	48 89 c6             	mov    %rax,%rsi
  801722:	bf 00 00 00 00       	mov    $0x0,%edi
  801727:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  80172e:	00 00 00 
  801731:	ff d0                	callq  *%rax
  801733:	eb 79                	jmp    8017ae <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801735:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801739:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  801740:	00 00 00 
  801743:	8b 12                	mov    (%rdx),%edx
  801745:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801747:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801752:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801756:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  80175d:	00 00 00 
  801760:	8b 12                	mov    (%rdx),%edx
  801762:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801764:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801768:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80176f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801773:	48 89 c7             	mov    %rax,%rdi
  801776:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  80177d:	00 00 00 
  801780:	ff d0                	callq  *%rax
  801782:	89 c2                	mov    %eax,%edx
  801784:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801788:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80178a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80178e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801792:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801796:	48 89 c7             	mov    %rax,%rdi
  801799:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  8017a0:	00 00 00 
  8017a3:	ff d0                	callq  *%rax
  8017a5:	89 03                	mov    %eax,(%rbx)
	return 0;
  8017a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ac:	eb 33                	jmp    8017e1 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8017ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b2:	48 89 c6             	mov    %rax,%rsi
  8017b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8017ba:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  8017c1:	00 00 00 
  8017c4:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8017c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ca:	48 89 c6             	mov    %rax,%rsi
  8017cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8017d2:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  8017d9:	00 00 00 
  8017dc:	ff d0                	callq  *%rax
err:
	return r;
  8017de:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8017e1:	48 83 c4 38          	add    $0x38,%rsp
  8017e5:	5b                   	pop    %rbx
  8017e6:	5d                   	pop    %rbp
  8017e7:	c3                   	retq   

00000000008017e8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8017e8:	55                   	push   %rbp
  8017e9:	48 89 e5             	mov    %rsp,%rbp
  8017ec:	53                   	push   %rbx
  8017ed:	48 83 ec 28          	sub    $0x28,%rsp
  8017f1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017f5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8017f9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801800:	00 00 00 
  801803:	48 8b 00             	mov    (%rax),%rax
  801806:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80180c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80180f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801813:	48 89 c7             	mov    %rax,%rdi
  801816:	48 b8 1a 36 80 00 00 	movabs $0x80361a,%rax
  80181d:	00 00 00 
  801820:	ff d0                	callq  *%rax
  801822:	89 c3                	mov    %eax,%ebx
  801824:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801828:	48 89 c7             	mov    %rax,%rdi
  80182b:	48 b8 1a 36 80 00 00 	movabs $0x80361a,%rax
  801832:	00 00 00 
  801835:	ff d0                	callq  *%rax
  801837:	39 c3                	cmp    %eax,%ebx
  801839:	0f 94 c0             	sete   %al
  80183c:	0f b6 c0             	movzbl %al,%eax
  80183f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801842:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801849:	00 00 00 
  80184c:	48 8b 00             	mov    (%rax),%rax
  80184f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801855:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801858:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80185b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80185e:	75 05                	jne    801865 <_pipeisclosed+0x7d>
			return ret;
  801860:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801863:	eb 4f                	jmp    8018b4 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801865:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801868:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80186b:	74 42                	je     8018af <_pipeisclosed+0xc7>
  80186d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801871:	75 3c                	jne    8018af <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801873:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80187a:	00 00 00 
  80187d:	48 8b 00             	mov    (%rax),%rax
  801880:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801886:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801889:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80188c:	89 c6                	mov    %eax,%esi
  80188e:	48 bf e1 37 80 00 00 	movabs $0x8037e1,%rdi
  801895:	00 00 00 
  801898:	b8 00 00 00 00       	mov    $0x0,%eax
  80189d:	49 b8 a7 20 80 00 00 	movabs $0x8020a7,%r8
  8018a4:	00 00 00 
  8018a7:	41 ff d0             	callq  *%r8
	}
  8018aa:	e9 4a ff ff ff       	jmpq   8017f9 <_pipeisclosed+0x11>
  8018af:	e9 45 ff ff ff       	jmpq   8017f9 <_pipeisclosed+0x11>
}
  8018b4:	48 83 c4 28          	add    $0x28,%rsp
  8018b8:	5b                   	pop    %rbx
  8018b9:	5d                   	pop    %rbp
  8018ba:	c3                   	retq   

00000000008018bb <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8018bb:	55                   	push   %rbp
  8018bc:	48 89 e5             	mov    %rsp,%rbp
  8018bf:	48 83 ec 30          	sub    $0x30,%rsp
  8018c3:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8018ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018cd:	48 89 d6             	mov    %rdx,%rsi
  8018d0:	89 c7                	mov    %eax,%edi
  8018d2:	48 b8 74 07 80 00 00 	movabs $0x800774,%rax
  8018d9:	00 00 00 
  8018dc:	ff d0                	callq  *%rax
  8018de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018e5:	79 05                	jns    8018ec <pipeisclosed+0x31>
		return r;
  8018e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ea:	eb 31                	jmp    80191d <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8018ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018f0:	48 89 c7             	mov    %rax,%rdi
  8018f3:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  8018fa:	00 00 00 
  8018fd:	ff d0                	callq  *%rax
  8018ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  801903:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801907:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80190b:	48 89 d6             	mov    %rdx,%rsi
  80190e:	48 89 c7             	mov    %rax,%rdi
  801911:	48 b8 e8 17 80 00 00 	movabs $0x8017e8,%rax
  801918:	00 00 00 
  80191b:	ff d0                	callq  *%rax
}
  80191d:	c9                   	leaveq 
  80191e:	c3                   	retq   

000000000080191f <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80191f:	55                   	push   %rbp
  801920:	48 89 e5             	mov    %rsp,%rbp
  801923:	48 83 ec 40          	sub    $0x40,%rsp
  801927:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80192b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80192f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801933:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801937:	48 89 c7             	mov    %rax,%rdi
  80193a:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  801941:	00 00 00 
  801944:	ff d0                	callq  *%rax
  801946:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80194a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80194e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801952:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801959:	00 
  80195a:	e9 92 00 00 00       	jmpq   8019f1 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80195f:	eb 41                	jmp    8019a2 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801961:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801966:	74 09                	je     801971 <devpipe_read+0x52>
				return i;
  801968:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80196c:	e9 92 00 00 00       	jmpq   801a03 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801971:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801975:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801979:	48 89 d6             	mov    %rdx,%rsi
  80197c:	48 89 c7             	mov    %rax,%rdi
  80197f:	48 b8 e8 17 80 00 00 	movabs $0x8017e8,%rax
  801986:	00 00 00 
  801989:	ff d0                	callq  *%rax
  80198b:	85 c0                	test   %eax,%eax
  80198d:	74 07                	je     801996 <devpipe_read+0x77>
				return 0;
  80198f:	b8 00 00 00 00       	mov    $0x0,%eax
  801994:	eb 6d                	jmp    801a03 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801996:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  80199d:	00 00 00 
  8019a0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8019a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a6:	8b 10                	mov    (%rax),%edx
  8019a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019ac:	8b 40 04             	mov    0x4(%rax),%eax
  8019af:	39 c2                	cmp    %eax,%edx
  8019b1:	74 ae                	je     801961 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8019b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019bb:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8019bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019c3:	8b 00                	mov    (%rax),%eax
  8019c5:	99                   	cltd   
  8019c6:	c1 ea 1b             	shr    $0x1b,%edx
  8019c9:	01 d0                	add    %edx,%eax
  8019cb:	83 e0 1f             	and    $0x1f,%eax
  8019ce:	29 d0                	sub    %edx,%eax
  8019d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d4:	48 98                	cltq   
  8019d6:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8019db:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8019dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019e1:	8b 00                	mov    (%rax),%eax
  8019e3:	8d 50 01             	lea    0x1(%rax),%edx
  8019e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019ea:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019ec:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8019f9:	0f 82 60 ff ff ff    	jb     80195f <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a03:	c9                   	leaveq 
  801a04:	c3                   	retq   

0000000000801a05 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a05:	55                   	push   %rbp
  801a06:	48 89 e5             	mov    %rsp,%rbp
  801a09:	48 83 ec 40          	sub    $0x40,%rsp
  801a0d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a11:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801a15:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1d:	48 89 c7             	mov    %rax,%rdi
  801a20:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  801a27:	00 00 00 
  801a2a:	ff d0                	callq  *%rax
  801a2c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801a30:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a34:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801a38:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801a3f:	00 
  801a40:	e9 8e 00 00 00       	jmpq   801ad3 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a45:	eb 31                	jmp    801a78 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4f:	48 89 d6             	mov    %rdx,%rsi
  801a52:	48 89 c7             	mov    %rax,%rdi
  801a55:	48 b8 e8 17 80 00 00 	movabs $0x8017e8,%rax
  801a5c:	00 00 00 
  801a5f:	ff d0                	callq  *%rax
  801a61:	85 c0                	test   %eax,%eax
  801a63:	74 07                	je     801a6c <devpipe_write+0x67>
				return 0;
  801a65:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6a:	eb 79                	jmp    801ae5 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a6c:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  801a73:	00 00 00 
  801a76:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a7c:	8b 40 04             	mov    0x4(%rax),%eax
  801a7f:	48 63 d0             	movslq %eax,%rdx
  801a82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a86:	8b 00                	mov    (%rax),%eax
  801a88:	48 98                	cltq   
  801a8a:	48 83 c0 20          	add    $0x20,%rax
  801a8e:	48 39 c2             	cmp    %rax,%rdx
  801a91:	73 b4                	jae    801a47 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a97:	8b 40 04             	mov    0x4(%rax),%eax
  801a9a:	99                   	cltd   
  801a9b:	c1 ea 1b             	shr    $0x1b,%edx
  801a9e:	01 d0                	add    %edx,%eax
  801aa0:	83 e0 1f             	and    $0x1f,%eax
  801aa3:	29 d0                	sub    %edx,%eax
  801aa5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801aa9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801aad:	48 01 ca             	add    %rcx,%rdx
  801ab0:	0f b6 0a             	movzbl (%rdx),%ecx
  801ab3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab7:	48 98                	cltq   
  801ab9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801abd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac1:	8b 40 04             	mov    0x4(%rax),%eax
  801ac4:	8d 50 01             	lea    0x1(%rax),%edx
  801ac7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801acb:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ace:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ad3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801adb:	0f 82 64 ff ff ff    	jb     801a45 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801ae1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801ae5:	c9                   	leaveq 
  801ae6:	c3                   	retq   

0000000000801ae7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ae7:	55                   	push   %rbp
  801ae8:	48 89 e5             	mov    %rsp,%rbp
  801aeb:	48 83 ec 20          	sub    $0x20,%rsp
  801aef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801af3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801af7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801afb:	48 89 c7             	mov    %rax,%rdi
  801afe:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  801b05:	00 00 00 
  801b08:	ff d0                	callq  *%rax
  801b0a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801b0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b12:	48 be f4 37 80 00 00 	movabs $0x8037f4,%rsi
  801b19:	00 00 00 
  801b1c:	48 89 c7             	mov    %rax,%rdi
  801b1f:	48 b8 9d 2c 80 00 00 	movabs $0x802c9d,%rax
  801b26:	00 00 00 
  801b29:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801b2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b2f:	8b 50 04             	mov    0x4(%rax),%edx
  801b32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b36:	8b 00                	mov    (%rax),%eax
  801b38:	29 c2                	sub    %eax,%edx
  801b3a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b3e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801b44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b48:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801b4f:	00 00 00 
	stat->st_dev = &devpipe;
  801b52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b56:	48 b9 e0 50 80 00 00 	movabs $0x8050e0,%rcx
  801b5d:	00 00 00 
  801b60:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801b67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b6c:	c9                   	leaveq 
  801b6d:	c3                   	retq   

0000000000801b6e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b6e:	55                   	push   %rbp
  801b6f:	48 89 e5             	mov    %rsp,%rbp
  801b72:	48 83 ec 10          	sub    $0x10,%rsp
  801b76:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801b7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b7e:	48 89 c6             	mov    %rax,%rsi
  801b81:	bf 00 00 00 00       	mov    $0x0,%edi
  801b86:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  801b8d:	00 00 00 
  801b90:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801b92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b96:	48 89 c7             	mov    %rax,%rdi
  801b99:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  801ba0:	00 00 00 
  801ba3:	ff d0                	callq  *%rax
  801ba5:	48 89 c6             	mov    %rax,%rsi
  801ba8:	bf 00 00 00 00       	mov    $0x0,%edi
  801bad:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  801bb4:	00 00 00 
  801bb7:	ff d0                	callq  *%rax
}
  801bb9:	c9                   	leaveq 
  801bba:	c3                   	retq   

0000000000801bbb <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801bbb:	55                   	push   %rbp
  801bbc:	48 89 e5             	mov    %rsp,%rbp
  801bbf:	48 83 ec 20          	sub    $0x20,%rsp
  801bc3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801bc6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bc9:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801bcc:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801bd0:	be 01 00 00 00       	mov    $0x1,%esi
  801bd5:	48 89 c7             	mov    %rax,%rdi
  801bd8:	48 b8 ab 01 80 00 00 	movabs $0x8001ab,%rax
  801bdf:	00 00 00 
  801be2:	ff d0                	callq  *%rax
}
  801be4:	c9                   	leaveq 
  801be5:	c3                   	retq   

0000000000801be6 <getchar>:

int
getchar(void)
{
  801be6:	55                   	push   %rbp
  801be7:	48 89 e5             	mov    %rsp,%rbp
  801bea:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801bee:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801bf2:	ba 01 00 00 00       	mov    $0x1,%edx
  801bf7:	48 89 c6             	mov    %rax,%rsi
  801bfa:	bf 00 00 00 00       	mov    $0x0,%edi
  801bff:	48 b8 a6 0b 80 00 00 	movabs $0x800ba6,%rax
  801c06:	00 00 00 
  801c09:	ff d0                	callq  *%rax
  801c0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801c0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c12:	79 05                	jns    801c19 <getchar+0x33>
		return r;
  801c14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c17:	eb 14                	jmp    801c2d <getchar+0x47>
	if (r < 1)
  801c19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c1d:	7f 07                	jg     801c26 <getchar+0x40>
		return -E_EOF;
  801c1f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801c24:	eb 07                	jmp    801c2d <getchar+0x47>
	return c;
  801c26:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801c2a:	0f b6 c0             	movzbl %al,%eax
}
  801c2d:	c9                   	leaveq 
  801c2e:	c3                   	retq   

0000000000801c2f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801c2f:	55                   	push   %rbp
  801c30:	48 89 e5             	mov    %rsp,%rbp
  801c33:	48 83 ec 20          	sub    $0x20,%rsp
  801c37:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c3a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801c3e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c41:	48 89 d6             	mov    %rdx,%rsi
  801c44:	89 c7                	mov    %eax,%edi
  801c46:	48 b8 74 07 80 00 00 	movabs $0x800774,%rax
  801c4d:	00 00 00 
  801c50:	ff d0                	callq  *%rax
  801c52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c59:	79 05                	jns    801c60 <iscons+0x31>
		return r;
  801c5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c5e:	eb 1a                	jmp    801c7a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801c60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c64:	8b 10                	mov    (%rax),%edx
  801c66:	48 b8 20 51 80 00 00 	movabs $0x805120,%rax
  801c6d:	00 00 00 
  801c70:	8b 00                	mov    (%rax),%eax
  801c72:	39 c2                	cmp    %eax,%edx
  801c74:	0f 94 c0             	sete   %al
  801c77:	0f b6 c0             	movzbl %al,%eax
}
  801c7a:	c9                   	leaveq 
  801c7b:	c3                   	retq   

0000000000801c7c <opencons>:

int
opencons(void)
{
  801c7c:	55                   	push   %rbp
  801c7d:	48 89 e5             	mov    %rsp,%rbp
  801c80:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c84:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801c88:	48 89 c7             	mov    %rax,%rdi
  801c8b:	48 b8 dc 06 80 00 00 	movabs $0x8006dc,%rax
  801c92:	00 00 00 
  801c95:	ff d0                	callq  *%rax
  801c97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c9e:	79 05                	jns    801ca5 <opencons+0x29>
		return r;
  801ca0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca3:	eb 5b                	jmp    801d00 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca9:	ba 07 04 00 00       	mov    $0x407,%edx
  801cae:	48 89 c6             	mov    %rax,%rsi
  801cb1:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb6:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  801cbd:	00 00 00 
  801cc0:	ff d0                	callq  *%rax
  801cc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cc9:	79 05                	jns    801cd0 <opencons+0x54>
		return r;
  801ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cce:	eb 30                	jmp    801d00 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801cd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cd4:	48 ba 20 51 80 00 00 	movabs $0x805120,%rdx
  801cdb:	00 00 00 
  801cde:	8b 12                	mov    (%rdx),%edx
  801ce0:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801ce2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801ced:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf1:	48 89 c7             	mov    %rax,%rdi
  801cf4:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  801cfb:	00 00 00 
  801cfe:	ff d0                	callq  *%rax
}
  801d00:	c9                   	leaveq 
  801d01:	c3                   	retq   

0000000000801d02 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d02:	55                   	push   %rbp
  801d03:	48 89 e5             	mov    %rsp,%rbp
  801d06:	48 83 ec 30          	sub    $0x30,%rsp
  801d0a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d12:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801d16:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801d1b:	75 07                	jne    801d24 <devcons_read+0x22>
		return 0;
  801d1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d22:	eb 4b                	jmp    801d6f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801d24:	eb 0c                	jmp    801d32 <devcons_read+0x30>
		sys_yield();
  801d26:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  801d2d:	00 00 00 
  801d30:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801d32:	48 b8 f5 01 80 00 00 	movabs $0x8001f5,%rax
  801d39:	00 00 00 
  801d3c:	ff d0                	callq  *%rax
  801d3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d45:	74 df                	je     801d26 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801d47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d4b:	79 05                	jns    801d52 <devcons_read+0x50>
		return c;
  801d4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d50:	eb 1d                	jmp    801d6f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801d52:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801d56:	75 07                	jne    801d5f <devcons_read+0x5d>
		return 0;
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5d:	eb 10                	jmp    801d6f <devcons_read+0x6d>
	*(char*)vbuf = c;
  801d5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d62:	89 c2                	mov    %eax,%edx
  801d64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d68:	88 10                	mov    %dl,(%rax)
	return 1;
  801d6a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d6f:	c9                   	leaveq 
  801d70:	c3                   	retq   

0000000000801d71 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d71:	55                   	push   %rbp
  801d72:	48 89 e5             	mov    %rsp,%rbp
  801d75:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801d7c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801d83:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801d8a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d98:	eb 76                	jmp    801e10 <devcons_write+0x9f>
		m = n - tot;
  801d9a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801da1:	89 c2                	mov    %eax,%edx
  801da3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da6:	29 c2                	sub    %eax,%edx
  801da8:	89 d0                	mov    %edx,%eax
  801daa:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801dad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801db0:	83 f8 7f             	cmp    $0x7f,%eax
  801db3:	76 07                	jbe    801dbc <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801db5:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801dbc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dbf:	48 63 d0             	movslq %eax,%rdx
  801dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc5:	48 63 c8             	movslq %eax,%rcx
  801dc8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801dcf:	48 01 c1             	add    %rax,%rcx
  801dd2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801dd9:	48 89 ce             	mov    %rcx,%rsi
  801ddc:	48 89 c7             	mov    %rax,%rdi
  801ddf:	48 b8 c1 2f 80 00 00 	movabs $0x802fc1,%rax
  801de6:	00 00 00 
  801de9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801deb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dee:	48 63 d0             	movslq %eax,%rdx
  801df1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801df8:	48 89 d6             	mov    %rdx,%rsi
  801dfb:	48 89 c7             	mov    %rax,%rdi
  801dfe:	48 b8 ab 01 80 00 00 	movabs $0x8001ab,%rax
  801e05:	00 00 00 
  801e08:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e0a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e0d:	01 45 fc             	add    %eax,-0x4(%rbp)
  801e10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e13:	48 98                	cltq   
  801e15:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801e1c:	0f 82 78 ff ff ff    	jb     801d9a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801e22:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e25:	c9                   	leaveq 
  801e26:	c3                   	retq   

0000000000801e27 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801e27:	55                   	push   %rbp
  801e28:	48 89 e5             	mov    %rsp,%rbp
  801e2b:	48 83 ec 08          	sub    $0x8,%rsp
  801e2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801e33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e38:	c9                   	leaveq 
  801e39:	c3                   	retq   

0000000000801e3a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e3a:	55                   	push   %rbp
  801e3b:	48 89 e5             	mov    %rsp,%rbp
  801e3e:	48 83 ec 10          	sub    $0x10,%rsp
  801e42:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e46:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801e4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e4e:	48 be 00 38 80 00 00 	movabs $0x803800,%rsi
  801e55:	00 00 00 
  801e58:	48 89 c7             	mov    %rax,%rdi
  801e5b:	48 b8 9d 2c 80 00 00 	movabs $0x802c9d,%rax
  801e62:	00 00 00 
  801e65:	ff d0                	callq  *%rax
	return 0;
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6c:	c9                   	leaveq 
  801e6d:	c3                   	retq   

0000000000801e6e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e6e:	55                   	push   %rbp
  801e6f:	48 89 e5             	mov    %rsp,%rbp
  801e72:	53                   	push   %rbx
  801e73:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801e7a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801e81:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801e87:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801e8e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801e95:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801e9c:	84 c0                	test   %al,%al
  801e9e:	74 23                	je     801ec3 <_panic+0x55>
  801ea0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801ea7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801eab:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801eaf:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801eb3:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801eb7:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801ebb:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801ebf:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801ec3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801eca:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801ed1:	00 00 00 
  801ed4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801edb:	00 00 00 
  801ede:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ee2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801ee9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801ef0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ef7:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801efe:	00 00 00 
  801f01:	48 8b 18             	mov    (%rax),%rbx
  801f04:	48 b8 77 02 80 00 00 	movabs $0x800277,%rax
  801f0b:	00 00 00 
  801f0e:	ff d0                	callq  *%rax
  801f10:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801f16:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801f1d:	41 89 c8             	mov    %ecx,%r8d
  801f20:	48 89 d1             	mov    %rdx,%rcx
  801f23:	48 89 da             	mov    %rbx,%rdx
  801f26:	89 c6                	mov    %eax,%esi
  801f28:	48 bf 08 38 80 00 00 	movabs $0x803808,%rdi
  801f2f:	00 00 00 
  801f32:	b8 00 00 00 00       	mov    $0x0,%eax
  801f37:	49 b9 a7 20 80 00 00 	movabs $0x8020a7,%r9
  801f3e:	00 00 00 
  801f41:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f44:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801f4b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f52:	48 89 d6             	mov    %rdx,%rsi
  801f55:	48 89 c7             	mov    %rax,%rdi
  801f58:	48 b8 fb 1f 80 00 00 	movabs $0x801ffb,%rax
  801f5f:	00 00 00 
  801f62:	ff d0                	callq  *%rax
	cprintf("\n");
  801f64:	48 bf 2b 38 80 00 00 	movabs $0x80382b,%rdi
  801f6b:	00 00 00 
  801f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f73:	48 ba a7 20 80 00 00 	movabs $0x8020a7,%rdx
  801f7a:	00 00 00 
  801f7d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f7f:	cc                   	int3   
  801f80:	eb fd                	jmp    801f7f <_panic+0x111>

0000000000801f82 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801f82:	55                   	push   %rbp
  801f83:	48 89 e5             	mov    %rsp,%rbp
  801f86:	48 83 ec 10          	sub    $0x10,%rsp
  801f8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801f91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f95:	8b 00                	mov    (%rax),%eax
  801f97:	8d 48 01             	lea    0x1(%rax),%ecx
  801f9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f9e:	89 0a                	mov    %ecx,(%rdx)
  801fa0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fa3:	89 d1                	mov    %edx,%ecx
  801fa5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fa9:	48 98                	cltq   
  801fab:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801faf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb3:	8b 00                	mov    (%rax),%eax
  801fb5:	3d ff 00 00 00       	cmp    $0xff,%eax
  801fba:	75 2c                	jne    801fe8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc0:	8b 00                	mov    (%rax),%eax
  801fc2:	48 98                	cltq   
  801fc4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fc8:	48 83 c2 08          	add    $0x8,%rdx
  801fcc:	48 89 c6             	mov    %rax,%rsi
  801fcf:	48 89 d7             	mov    %rdx,%rdi
  801fd2:	48 b8 ab 01 80 00 00 	movabs $0x8001ab,%rax
  801fd9:	00 00 00 
  801fdc:	ff d0                	callq  *%rax
        b->idx = 0;
  801fde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fe2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801fe8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fec:	8b 40 04             	mov    0x4(%rax),%eax
  801fef:	8d 50 01             	lea    0x1(%rax),%edx
  801ff2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ff6:	89 50 04             	mov    %edx,0x4(%rax)
}
  801ff9:	c9                   	leaveq 
  801ffa:	c3                   	retq   

0000000000801ffb <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801ffb:	55                   	push   %rbp
  801ffc:	48 89 e5             	mov    %rsp,%rbp
  801fff:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802006:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80200d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  802014:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80201b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802022:	48 8b 0a             	mov    (%rdx),%rcx
  802025:	48 89 08             	mov    %rcx,(%rax)
  802028:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80202c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802030:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802034:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  802038:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80203f:	00 00 00 
    b.cnt = 0;
  802042:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802049:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80204c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802053:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80205a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802061:	48 89 c6             	mov    %rax,%rsi
  802064:	48 bf 82 1f 80 00 00 	movabs $0x801f82,%rdi
  80206b:	00 00 00 
  80206e:	48 b8 5a 24 80 00 00 	movabs $0x80245a,%rax
  802075:	00 00 00 
  802078:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80207a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802080:	48 98                	cltq   
  802082:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802089:	48 83 c2 08          	add    $0x8,%rdx
  80208d:	48 89 c6             	mov    %rax,%rsi
  802090:	48 89 d7             	mov    %rdx,%rdi
  802093:	48 b8 ab 01 80 00 00 	movabs $0x8001ab,%rax
  80209a:	00 00 00 
  80209d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80209f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8020a5:	c9                   	leaveq 
  8020a6:	c3                   	retq   

00000000008020a7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8020a7:	55                   	push   %rbp
  8020a8:	48 89 e5             	mov    %rsp,%rbp
  8020ab:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8020b2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8020b9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8020c0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8020c7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8020ce:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8020d5:	84 c0                	test   %al,%al
  8020d7:	74 20                	je     8020f9 <cprintf+0x52>
  8020d9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8020dd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8020e1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8020e5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8020e9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8020ed:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8020f1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8020f5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8020f9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  802100:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802107:	00 00 00 
  80210a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802111:	00 00 00 
  802114:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802118:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80211f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802126:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80212d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802134:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80213b:	48 8b 0a             	mov    (%rdx),%rcx
  80213e:	48 89 08             	mov    %rcx,(%rax)
  802141:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802145:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802149:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80214d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  802151:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802158:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80215f:	48 89 d6             	mov    %rdx,%rsi
  802162:	48 89 c7             	mov    %rax,%rdi
  802165:	48 b8 fb 1f 80 00 00 	movabs $0x801ffb,%rax
  80216c:	00 00 00 
  80216f:	ff d0                	callq  *%rax
  802171:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802177:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80217d:	c9                   	leaveq 
  80217e:	c3                   	retq   

000000000080217f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80217f:	55                   	push   %rbp
  802180:	48 89 e5             	mov    %rsp,%rbp
  802183:	53                   	push   %rbx
  802184:	48 83 ec 38          	sub    $0x38,%rsp
  802188:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80218c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802190:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802194:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802197:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80219b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80219f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8021a2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8021a6:	77 3b                	ja     8021e3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8021a8:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8021ab:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8021af:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8021b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8021bb:	48 f7 f3             	div    %rbx
  8021be:	48 89 c2             	mov    %rax,%rdx
  8021c1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8021c4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8021c7:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8021cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cf:	41 89 f9             	mov    %edi,%r9d
  8021d2:	48 89 c7             	mov    %rax,%rdi
  8021d5:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  8021dc:	00 00 00 
  8021df:	ff d0                	callq  *%rax
  8021e1:	eb 1e                	jmp    802201 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8021e3:	eb 12                	jmp    8021f7 <printnum+0x78>
			putch(padc, putdat);
  8021e5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021e9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8021ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f0:	48 89 ce             	mov    %rcx,%rsi
  8021f3:	89 d7                	mov    %edx,%edi
  8021f5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8021f7:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8021fb:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8021ff:	7f e4                	jg     8021e5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802201:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802204:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802208:	ba 00 00 00 00       	mov    $0x0,%edx
  80220d:	48 f7 f1             	div    %rcx
  802210:	48 89 d0             	mov    %rdx,%rax
  802213:	48 ba 30 3a 80 00 00 	movabs $0x803a30,%rdx
  80221a:	00 00 00 
  80221d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802221:	0f be d0             	movsbl %al,%edx
  802224:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802228:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222c:	48 89 ce             	mov    %rcx,%rsi
  80222f:	89 d7                	mov    %edx,%edi
  802231:	ff d0                	callq  *%rax
}
  802233:	48 83 c4 38          	add    $0x38,%rsp
  802237:	5b                   	pop    %rbx
  802238:	5d                   	pop    %rbp
  802239:	c3                   	retq   

000000000080223a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80223a:	55                   	push   %rbp
  80223b:	48 89 e5             	mov    %rsp,%rbp
  80223e:	48 83 ec 1c          	sub    $0x1c,%rsp
  802242:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802246:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802249:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80224d:	7e 52                	jle    8022a1 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80224f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802253:	8b 00                	mov    (%rax),%eax
  802255:	83 f8 30             	cmp    $0x30,%eax
  802258:	73 24                	jae    80227e <getuint+0x44>
  80225a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802262:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802266:	8b 00                	mov    (%rax),%eax
  802268:	89 c0                	mov    %eax,%eax
  80226a:	48 01 d0             	add    %rdx,%rax
  80226d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802271:	8b 12                	mov    (%rdx),%edx
  802273:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802276:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80227a:	89 0a                	mov    %ecx,(%rdx)
  80227c:	eb 17                	jmp    802295 <getuint+0x5b>
  80227e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802282:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802286:	48 89 d0             	mov    %rdx,%rax
  802289:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80228d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802291:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802295:	48 8b 00             	mov    (%rax),%rax
  802298:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80229c:	e9 a3 00 00 00       	jmpq   802344 <getuint+0x10a>
	else if (lflag)
  8022a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8022a5:	74 4f                	je     8022f6 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8022a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ab:	8b 00                	mov    (%rax),%eax
  8022ad:	83 f8 30             	cmp    $0x30,%eax
  8022b0:	73 24                	jae    8022d6 <getuint+0x9c>
  8022b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022be:	8b 00                	mov    (%rax),%eax
  8022c0:	89 c0                	mov    %eax,%eax
  8022c2:	48 01 d0             	add    %rdx,%rax
  8022c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c9:	8b 12                	mov    (%rdx),%edx
  8022cb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022d2:	89 0a                	mov    %ecx,(%rdx)
  8022d4:	eb 17                	jmp    8022ed <getuint+0xb3>
  8022d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022da:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022de:	48 89 d0             	mov    %rdx,%rax
  8022e1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022e9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022ed:	48 8b 00             	mov    (%rax),%rax
  8022f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022f4:	eb 4e                	jmp    802344 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8022f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022fa:	8b 00                	mov    (%rax),%eax
  8022fc:	83 f8 30             	cmp    $0x30,%eax
  8022ff:	73 24                	jae    802325 <getuint+0xeb>
  802301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802305:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802309:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230d:	8b 00                	mov    (%rax),%eax
  80230f:	89 c0                	mov    %eax,%eax
  802311:	48 01 d0             	add    %rdx,%rax
  802314:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802318:	8b 12                	mov    (%rdx),%edx
  80231a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80231d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802321:	89 0a                	mov    %ecx,(%rdx)
  802323:	eb 17                	jmp    80233c <getuint+0x102>
  802325:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802329:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80232d:	48 89 d0             	mov    %rdx,%rax
  802330:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802334:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802338:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80233c:	8b 00                	mov    (%rax),%eax
  80233e:	89 c0                	mov    %eax,%eax
  802340:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802344:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802348:	c9                   	leaveq 
  802349:	c3                   	retq   

000000000080234a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80234a:	55                   	push   %rbp
  80234b:	48 89 e5             	mov    %rsp,%rbp
  80234e:	48 83 ec 1c          	sub    $0x1c,%rsp
  802352:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802356:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802359:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80235d:	7e 52                	jle    8023b1 <getint+0x67>
		x=va_arg(*ap, long long);
  80235f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802363:	8b 00                	mov    (%rax),%eax
  802365:	83 f8 30             	cmp    $0x30,%eax
  802368:	73 24                	jae    80238e <getint+0x44>
  80236a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802376:	8b 00                	mov    (%rax),%eax
  802378:	89 c0                	mov    %eax,%eax
  80237a:	48 01 d0             	add    %rdx,%rax
  80237d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802381:	8b 12                	mov    (%rdx),%edx
  802383:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802386:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80238a:	89 0a                	mov    %ecx,(%rdx)
  80238c:	eb 17                	jmp    8023a5 <getint+0x5b>
  80238e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802392:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802396:	48 89 d0             	mov    %rdx,%rax
  802399:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80239d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023a1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023a5:	48 8b 00             	mov    (%rax),%rax
  8023a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023ac:	e9 a3 00 00 00       	jmpq   802454 <getint+0x10a>
	else if (lflag)
  8023b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8023b5:	74 4f                	je     802406 <getint+0xbc>
		x=va_arg(*ap, long);
  8023b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bb:	8b 00                	mov    (%rax),%eax
  8023bd:	83 f8 30             	cmp    $0x30,%eax
  8023c0:	73 24                	jae    8023e6 <getint+0x9c>
  8023c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ce:	8b 00                	mov    (%rax),%eax
  8023d0:	89 c0                	mov    %eax,%eax
  8023d2:	48 01 d0             	add    %rdx,%rax
  8023d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023d9:	8b 12                	mov    (%rdx),%edx
  8023db:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023e2:	89 0a                	mov    %ecx,(%rdx)
  8023e4:	eb 17                	jmp    8023fd <getint+0xb3>
  8023e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ea:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023ee:	48 89 d0             	mov    %rdx,%rax
  8023f1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023f9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023fd:	48 8b 00             	mov    (%rax),%rax
  802400:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802404:	eb 4e                	jmp    802454 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80240a:	8b 00                	mov    (%rax),%eax
  80240c:	83 f8 30             	cmp    $0x30,%eax
  80240f:	73 24                	jae    802435 <getint+0xeb>
  802411:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802415:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802419:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80241d:	8b 00                	mov    (%rax),%eax
  80241f:	89 c0                	mov    %eax,%eax
  802421:	48 01 d0             	add    %rdx,%rax
  802424:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802428:	8b 12                	mov    (%rdx),%edx
  80242a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80242d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802431:	89 0a                	mov    %ecx,(%rdx)
  802433:	eb 17                	jmp    80244c <getint+0x102>
  802435:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802439:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80243d:	48 89 d0             	mov    %rdx,%rax
  802440:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802444:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802448:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80244c:	8b 00                	mov    (%rax),%eax
  80244e:	48 98                	cltq   
  802450:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802458:	c9                   	leaveq 
  802459:	c3                   	retq   

000000000080245a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80245a:	55                   	push   %rbp
  80245b:	48 89 e5             	mov    %rsp,%rbp
  80245e:	41 54                	push   %r12
  802460:	53                   	push   %rbx
  802461:	48 83 ec 60          	sub    $0x60,%rsp
  802465:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802469:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80246d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802471:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802475:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802479:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80247d:	48 8b 0a             	mov    (%rdx),%rcx
  802480:	48 89 08             	mov    %rcx,(%rax)
  802483:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802487:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80248b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80248f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802493:	eb 28                	jmp    8024bd <vprintfmt+0x63>
			if (ch == '\0'){
  802495:	85 db                	test   %ebx,%ebx
  802497:	75 15                	jne    8024ae <vprintfmt+0x54>
				current_color=WHITE;
  802499:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8024a0:	00 00 00 
  8024a3:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  8024a9:	e9 fc 04 00 00       	jmpq   8029aa <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  8024ae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8024b2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8024b6:	48 89 d6             	mov    %rdx,%rsi
  8024b9:	89 df                	mov    %ebx,%edi
  8024bb:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8024bd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8024c1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8024c5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8024c9:	0f b6 00             	movzbl (%rax),%eax
  8024cc:	0f b6 d8             	movzbl %al,%ebx
  8024cf:	83 fb 25             	cmp    $0x25,%ebx
  8024d2:	75 c1                	jne    802495 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8024d4:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8024d8:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8024df:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8024e6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8024ed:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8024f4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8024f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8024fc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802500:	0f b6 00             	movzbl (%rax),%eax
  802503:	0f b6 d8             	movzbl %al,%ebx
  802506:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802509:	83 f8 55             	cmp    $0x55,%eax
  80250c:	0f 87 64 04 00 00    	ja     802976 <vprintfmt+0x51c>
  802512:	89 c0                	mov    %eax,%eax
  802514:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80251b:	00 
  80251c:	48 b8 58 3a 80 00 00 	movabs $0x803a58,%rax
  802523:	00 00 00 
  802526:	48 01 d0             	add    %rdx,%rax
  802529:	48 8b 00             	mov    (%rax),%rax
  80252c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80252e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802532:	eb c0                	jmp    8024f4 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802534:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802538:	eb ba                	jmp    8024f4 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80253a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802541:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802544:	89 d0                	mov    %edx,%eax
  802546:	c1 e0 02             	shl    $0x2,%eax
  802549:	01 d0                	add    %edx,%eax
  80254b:	01 c0                	add    %eax,%eax
  80254d:	01 d8                	add    %ebx,%eax
  80254f:	83 e8 30             	sub    $0x30,%eax
  802552:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802555:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802559:	0f b6 00             	movzbl (%rax),%eax
  80255c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80255f:	83 fb 2f             	cmp    $0x2f,%ebx
  802562:	7e 0c                	jle    802570 <vprintfmt+0x116>
  802564:	83 fb 39             	cmp    $0x39,%ebx
  802567:	7f 07                	jg     802570 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802569:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80256e:	eb d1                	jmp    802541 <vprintfmt+0xe7>
			goto process_precision;
  802570:	eb 58                	jmp    8025ca <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  802572:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802575:	83 f8 30             	cmp    $0x30,%eax
  802578:	73 17                	jae    802591 <vprintfmt+0x137>
  80257a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80257e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802581:	89 c0                	mov    %eax,%eax
  802583:	48 01 d0             	add    %rdx,%rax
  802586:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802589:	83 c2 08             	add    $0x8,%edx
  80258c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80258f:	eb 0f                	jmp    8025a0 <vprintfmt+0x146>
  802591:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802595:	48 89 d0             	mov    %rdx,%rax
  802598:	48 83 c2 08          	add    $0x8,%rdx
  80259c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025a0:	8b 00                	mov    (%rax),%eax
  8025a2:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8025a5:	eb 23                	jmp    8025ca <vprintfmt+0x170>

		case '.':
			if (width < 0)
  8025a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8025ab:	79 0c                	jns    8025b9 <vprintfmt+0x15f>
				width = 0;
  8025ad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8025b4:	e9 3b ff ff ff       	jmpq   8024f4 <vprintfmt+0x9a>
  8025b9:	e9 36 ff ff ff       	jmpq   8024f4 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  8025be:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8025c5:	e9 2a ff ff ff       	jmpq   8024f4 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  8025ca:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8025ce:	79 12                	jns    8025e2 <vprintfmt+0x188>
				width = precision, precision = -1;
  8025d0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8025d3:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8025d6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8025dd:	e9 12 ff ff ff       	jmpq   8024f4 <vprintfmt+0x9a>
  8025e2:	e9 0d ff ff ff       	jmpq   8024f4 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8025e7:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8025eb:	e9 04 ff ff ff       	jmpq   8024f4 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8025f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025f3:	83 f8 30             	cmp    $0x30,%eax
  8025f6:	73 17                	jae    80260f <vprintfmt+0x1b5>
  8025f8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025fc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025ff:	89 c0                	mov    %eax,%eax
  802601:	48 01 d0             	add    %rdx,%rax
  802604:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802607:	83 c2 08             	add    $0x8,%edx
  80260a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80260d:	eb 0f                	jmp    80261e <vprintfmt+0x1c4>
  80260f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802613:	48 89 d0             	mov    %rdx,%rax
  802616:	48 83 c2 08          	add    $0x8,%rdx
  80261a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80261e:	8b 10                	mov    (%rax),%edx
  802620:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802624:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802628:	48 89 ce             	mov    %rcx,%rsi
  80262b:	89 d7                	mov    %edx,%edi
  80262d:	ff d0                	callq  *%rax
			break;
  80262f:	e9 70 03 00 00       	jmpq   8029a4 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802634:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802637:	83 f8 30             	cmp    $0x30,%eax
  80263a:	73 17                	jae    802653 <vprintfmt+0x1f9>
  80263c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802640:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802643:	89 c0                	mov    %eax,%eax
  802645:	48 01 d0             	add    %rdx,%rax
  802648:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80264b:	83 c2 08             	add    $0x8,%edx
  80264e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802651:	eb 0f                	jmp    802662 <vprintfmt+0x208>
  802653:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802657:	48 89 d0             	mov    %rdx,%rax
  80265a:	48 83 c2 08          	add    $0x8,%rdx
  80265e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802662:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802664:	85 db                	test   %ebx,%ebx
  802666:	79 02                	jns    80266a <vprintfmt+0x210>
				err = -err;
  802668:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80266a:	83 fb 15             	cmp    $0x15,%ebx
  80266d:	7f 16                	jg     802685 <vprintfmt+0x22b>
  80266f:	48 b8 80 39 80 00 00 	movabs $0x803980,%rax
  802676:	00 00 00 
  802679:	48 63 d3             	movslq %ebx,%rdx
  80267c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802680:	4d 85 e4             	test   %r12,%r12
  802683:	75 2e                	jne    8026b3 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  802685:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802689:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80268d:	89 d9                	mov    %ebx,%ecx
  80268f:	48 ba 41 3a 80 00 00 	movabs $0x803a41,%rdx
  802696:	00 00 00 
  802699:	48 89 c7             	mov    %rax,%rdi
  80269c:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a1:	49 b8 b3 29 80 00 00 	movabs $0x8029b3,%r8
  8026a8:	00 00 00 
  8026ab:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8026ae:	e9 f1 02 00 00       	jmpq   8029a4 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8026b3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8026b7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026bb:	4c 89 e1             	mov    %r12,%rcx
  8026be:	48 ba 4a 3a 80 00 00 	movabs $0x803a4a,%rdx
  8026c5:	00 00 00 
  8026c8:	48 89 c7             	mov    %rax,%rdi
  8026cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d0:	49 b8 b3 29 80 00 00 	movabs $0x8029b3,%r8
  8026d7:	00 00 00 
  8026da:	41 ff d0             	callq  *%r8
			break;
  8026dd:	e9 c2 02 00 00       	jmpq   8029a4 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8026e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8026e5:	83 f8 30             	cmp    $0x30,%eax
  8026e8:	73 17                	jae    802701 <vprintfmt+0x2a7>
  8026ea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8026f1:	89 c0                	mov    %eax,%eax
  8026f3:	48 01 d0             	add    %rdx,%rax
  8026f6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8026f9:	83 c2 08             	add    $0x8,%edx
  8026fc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8026ff:	eb 0f                	jmp    802710 <vprintfmt+0x2b6>
  802701:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802705:	48 89 d0             	mov    %rdx,%rax
  802708:	48 83 c2 08          	add    $0x8,%rdx
  80270c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802710:	4c 8b 20             	mov    (%rax),%r12
  802713:	4d 85 e4             	test   %r12,%r12
  802716:	75 0a                	jne    802722 <vprintfmt+0x2c8>
				p = "(null)";
  802718:	49 bc 4d 3a 80 00 00 	movabs $0x803a4d,%r12
  80271f:	00 00 00 
			if (width > 0 && padc != '-')
  802722:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802726:	7e 3f                	jle    802767 <vprintfmt+0x30d>
  802728:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80272c:	74 39                	je     802767 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  80272e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802731:	48 98                	cltq   
  802733:	48 89 c6             	mov    %rax,%rsi
  802736:	4c 89 e7             	mov    %r12,%rdi
  802739:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  802740:	00 00 00 
  802743:	ff d0                	callq  *%rax
  802745:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802748:	eb 17                	jmp    802761 <vprintfmt+0x307>
					putch(padc, putdat);
  80274a:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80274e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802752:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802756:	48 89 ce             	mov    %rcx,%rsi
  802759:	89 d7                	mov    %edx,%edi
  80275b:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80275d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802761:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802765:	7f e3                	jg     80274a <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802767:	eb 37                	jmp    8027a0 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  802769:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80276d:	74 1e                	je     80278d <vprintfmt+0x333>
  80276f:	83 fb 1f             	cmp    $0x1f,%ebx
  802772:	7e 05                	jle    802779 <vprintfmt+0x31f>
  802774:	83 fb 7e             	cmp    $0x7e,%ebx
  802777:	7e 14                	jle    80278d <vprintfmt+0x333>
					putch('?', putdat);
  802779:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80277d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802781:	48 89 d6             	mov    %rdx,%rsi
  802784:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802789:	ff d0                	callq  *%rax
  80278b:	eb 0f                	jmp    80279c <vprintfmt+0x342>
				else
					putch(ch, putdat);
  80278d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802791:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802795:	48 89 d6             	mov    %rdx,%rsi
  802798:	89 df                	mov    %ebx,%edi
  80279a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80279c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8027a0:	4c 89 e0             	mov    %r12,%rax
  8027a3:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8027a7:	0f b6 00             	movzbl (%rax),%eax
  8027aa:	0f be d8             	movsbl %al,%ebx
  8027ad:	85 db                	test   %ebx,%ebx
  8027af:	74 10                	je     8027c1 <vprintfmt+0x367>
  8027b1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8027b5:	78 b2                	js     802769 <vprintfmt+0x30f>
  8027b7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8027bb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8027bf:	79 a8                	jns    802769 <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8027c1:	eb 16                	jmp    8027d9 <vprintfmt+0x37f>
				putch(' ', putdat);
  8027c3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027c7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027cb:	48 89 d6             	mov    %rdx,%rsi
  8027ce:	bf 20 00 00 00       	mov    $0x20,%edi
  8027d3:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8027d5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8027d9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8027dd:	7f e4                	jg     8027c3 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  8027df:	e9 c0 01 00 00       	jmpq   8029a4 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8027e4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027e8:	be 03 00 00 00       	mov    $0x3,%esi
  8027ed:	48 89 c7             	mov    %rax,%rdi
  8027f0:	48 b8 4a 23 80 00 00 	movabs $0x80234a,%rax
  8027f7:	00 00 00 
  8027fa:	ff d0                	callq  *%rax
  8027fc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802804:	48 85 c0             	test   %rax,%rax
  802807:	79 1d                	jns    802826 <vprintfmt+0x3cc>
				putch('-', putdat);
  802809:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80280d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802811:	48 89 d6             	mov    %rdx,%rsi
  802814:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802819:	ff d0                	callq  *%rax
				num = -(long long) num;
  80281b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281f:	48 f7 d8             	neg    %rax
  802822:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  802826:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80282d:	e9 d5 00 00 00       	jmpq   802907 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802832:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802836:	be 03 00 00 00       	mov    $0x3,%esi
  80283b:	48 89 c7             	mov    %rax,%rdi
  80283e:	48 b8 3a 22 80 00 00 	movabs $0x80223a,%rax
  802845:	00 00 00 
  802848:	ff d0                	callq  *%rax
  80284a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80284e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802855:	e9 ad 00 00 00       	jmpq   802907 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  80285a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80285e:	be 03 00 00 00       	mov    $0x3,%esi
  802863:	48 89 c7             	mov    %rax,%rdi
  802866:	48 b8 3a 22 80 00 00 	movabs $0x80223a,%rax
  80286d:	00 00 00 
  802870:	ff d0                	callq  *%rax
  802872:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  802876:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80287d:	e9 85 00 00 00       	jmpq   802907 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  802882:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802886:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80288a:	48 89 d6             	mov    %rdx,%rsi
  80288d:	bf 30 00 00 00       	mov    $0x30,%edi
  802892:	ff d0                	callq  *%rax
			putch('x', putdat);
  802894:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802898:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80289c:	48 89 d6             	mov    %rdx,%rsi
  80289f:	bf 78 00 00 00       	mov    $0x78,%edi
  8028a4:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8028a6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8028a9:	83 f8 30             	cmp    $0x30,%eax
  8028ac:	73 17                	jae    8028c5 <vprintfmt+0x46b>
  8028ae:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8028b5:	89 c0                	mov    %eax,%eax
  8028b7:	48 01 d0             	add    %rdx,%rax
  8028ba:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8028bd:	83 c2 08             	add    $0x8,%edx
  8028c0:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8028c3:	eb 0f                	jmp    8028d4 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  8028c5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8028c9:	48 89 d0             	mov    %rdx,%rax
  8028cc:	48 83 c2 08          	add    $0x8,%rdx
  8028d0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8028d4:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8028d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8028db:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8028e2:	eb 23                	jmp    802907 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8028e4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8028e8:	be 03 00 00 00       	mov    $0x3,%esi
  8028ed:	48 89 c7             	mov    %rax,%rdi
  8028f0:	48 b8 3a 22 80 00 00 	movabs $0x80223a,%rax
  8028f7:	00 00 00 
  8028fa:	ff d0                	callq  *%rax
  8028fc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  802900:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802907:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80290c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80290f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802912:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802916:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80291a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80291e:	45 89 c1             	mov    %r8d,%r9d
  802921:	41 89 f8             	mov    %edi,%r8d
  802924:	48 89 c7             	mov    %rax,%rdi
  802927:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  80292e:	00 00 00 
  802931:	ff d0                	callq  *%rax
			break;
  802933:	eb 6f                	jmp    8029a4 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  802935:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802939:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80293d:	48 89 d6             	mov    %rdx,%rsi
  802940:	89 df                	mov    %ebx,%edi
  802942:	ff d0                	callq  *%rax
			break;
  802944:	eb 5e                	jmp    8029a4 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  802946:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80294a:	be 03 00 00 00       	mov    $0x3,%esi
  80294f:	48 89 c7             	mov    %rax,%rdi
  802952:	48 b8 3a 22 80 00 00 	movabs $0x80223a,%rax
  802959:	00 00 00 
  80295c:	ff d0                	callq  *%rax
  80295e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  802962:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802966:	89 c2                	mov    %eax,%edx
  802968:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80296f:	00 00 00 
  802972:	89 10                	mov    %edx,(%rax)
			break;
  802974:	eb 2e                	jmp    8029a4 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802976:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80297a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80297e:	48 89 d6             	mov    %rdx,%rsi
  802981:	bf 25 00 00 00       	mov    $0x25,%edi
  802986:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  802988:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80298d:	eb 05                	jmp    802994 <vprintfmt+0x53a>
  80298f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802994:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802998:	48 83 e8 01          	sub    $0x1,%rax
  80299c:	0f b6 00             	movzbl (%rax),%eax
  80299f:	3c 25                	cmp    $0x25,%al
  8029a1:	75 ec                	jne    80298f <vprintfmt+0x535>
				/* do nothing */;
			break;
  8029a3:	90                   	nop
		}
	}
  8029a4:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8029a5:	e9 13 fb ff ff       	jmpq   8024bd <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8029aa:	48 83 c4 60          	add    $0x60,%rsp
  8029ae:	5b                   	pop    %rbx
  8029af:	41 5c                	pop    %r12
  8029b1:	5d                   	pop    %rbp
  8029b2:	c3                   	retq   

00000000008029b3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8029b3:	55                   	push   %rbp
  8029b4:	48 89 e5             	mov    %rsp,%rbp
  8029b7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8029be:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8029c5:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8029cc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8029d3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8029da:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8029e1:	84 c0                	test   %al,%al
  8029e3:	74 20                	je     802a05 <printfmt+0x52>
  8029e5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8029e9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8029ed:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8029f1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8029f5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8029f9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8029fd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802a01:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802a05:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802a0c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  802a13:	00 00 00 
  802a16:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  802a1d:	00 00 00 
  802a20:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a24:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  802a2b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802a32:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  802a39:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  802a40:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802a47:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  802a4e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802a55:	48 89 c7             	mov    %rax,%rdi
  802a58:	48 b8 5a 24 80 00 00 	movabs $0x80245a,%rax
  802a5f:	00 00 00 
  802a62:	ff d0                	callq  *%rax
	va_end(ap);
}
  802a64:	c9                   	leaveq 
  802a65:	c3                   	retq   

0000000000802a66 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802a66:	55                   	push   %rbp
  802a67:	48 89 e5             	mov    %rsp,%rbp
  802a6a:	48 83 ec 10          	sub    $0x10,%rsp
  802a6e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a71:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  802a75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a79:	8b 40 10             	mov    0x10(%rax),%eax
  802a7c:	8d 50 01             	lea    0x1(%rax),%edx
  802a7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a83:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802a86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a8a:	48 8b 10             	mov    (%rax),%rdx
  802a8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a91:	48 8b 40 08          	mov    0x8(%rax),%rax
  802a95:	48 39 c2             	cmp    %rax,%rdx
  802a98:	73 17                	jae    802ab1 <sprintputch+0x4b>
		*b->buf++ = ch;
  802a9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9e:	48 8b 00             	mov    (%rax),%rax
  802aa1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802aa5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802aa9:	48 89 0a             	mov    %rcx,(%rdx)
  802aac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802aaf:	88 10                	mov    %dl,(%rax)
}
  802ab1:	c9                   	leaveq 
  802ab2:	c3                   	retq   

0000000000802ab3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802ab3:	55                   	push   %rbp
  802ab4:	48 89 e5             	mov    %rsp,%rbp
  802ab7:	48 83 ec 50          	sub    $0x50,%rsp
  802abb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802abf:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802ac2:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802ac6:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802aca:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802ace:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802ad2:	48 8b 0a             	mov    (%rdx),%rcx
  802ad5:	48 89 08             	mov    %rcx,(%rax)
  802ad8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802adc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802ae0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802ae4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802ae8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802aec:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802af0:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802af3:	48 98                	cltq   
  802af5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802af9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802afd:	48 01 d0             	add    %rdx,%rax
  802b00:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802b04:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802b0b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802b10:	74 06                	je     802b18 <vsnprintf+0x65>
  802b12:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802b16:	7f 07                	jg     802b1f <vsnprintf+0x6c>
		return -E_INVAL;
  802b18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b1d:	eb 2f                	jmp    802b4e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802b1f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802b23:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802b27:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802b2b:	48 89 c6             	mov    %rax,%rsi
  802b2e:	48 bf 66 2a 80 00 00 	movabs $0x802a66,%rdi
  802b35:	00 00 00 
  802b38:	48 b8 5a 24 80 00 00 	movabs $0x80245a,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802b44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b48:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802b4b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802b4e:	c9                   	leaveq 
  802b4f:	c3                   	retq   

0000000000802b50 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802b50:	55                   	push   %rbp
  802b51:	48 89 e5             	mov    %rsp,%rbp
  802b54:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802b5b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802b62:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802b68:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802b6f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802b76:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802b7d:	84 c0                	test   %al,%al
  802b7f:	74 20                	je     802ba1 <snprintf+0x51>
  802b81:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802b85:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802b89:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802b8d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802b91:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802b95:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802b99:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802b9d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802ba1:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802ba8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802baf:	00 00 00 
  802bb2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802bb9:	00 00 00 
  802bbc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802bc0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802bc7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802bce:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802bd5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802bdc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802be3:	48 8b 0a             	mov    (%rdx),%rcx
  802be6:	48 89 08             	mov    %rcx,(%rax)
  802be9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802bed:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802bf1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802bf5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802bf9:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802c00:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802c07:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802c0d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802c14:	48 89 c7             	mov    %rax,%rdi
  802c17:	48 b8 b3 2a 80 00 00 	movabs $0x802ab3,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
  802c23:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802c29:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802c2f:	c9                   	leaveq 
  802c30:	c3                   	retq   

0000000000802c31 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802c31:	55                   	push   %rbp
  802c32:	48 89 e5             	mov    %rsp,%rbp
  802c35:	48 83 ec 18          	sub    $0x18,%rsp
  802c39:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802c3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c44:	eb 09                	jmp    802c4f <strlen+0x1e>
		n++;
  802c46:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802c4a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802c4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c53:	0f b6 00             	movzbl (%rax),%eax
  802c56:	84 c0                	test   %al,%al
  802c58:	75 ec                	jne    802c46 <strlen+0x15>
		n++;
	return n;
  802c5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c5d:	c9                   	leaveq 
  802c5e:	c3                   	retq   

0000000000802c5f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802c5f:	55                   	push   %rbp
  802c60:	48 89 e5             	mov    %rsp,%rbp
  802c63:	48 83 ec 20          	sub    $0x20,%rsp
  802c67:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c76:	eb 0e                	jmp    802c86 <strnlen+0x27>
		n++;
  802c78:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c7c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802c81:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802c86:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c8b:	74 0b                	je     802c98 <strnlen+0x39>
  802c8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c91:	0f b6 00             	movzbl (%rax),%eax
  802c94:	84 c0                	test   %al,%al
  802c96:	75 e0                	jne    802c78 <strnlen+0x19>
		n++;
	return n;
  802c98:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c9b:	c9                   	leaveq 
  802c9c:	c3                   	retq   

0000000000802c9d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802c9d:	55                   	push   %rbp
  802c9e:	48 89 e5             	mov    %rsp,%rbp
  802ca1:	48 83 ec 20          	sub    $0x20,%rsp
  802ca5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ca9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802cad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802cb5:	90                   	nop
  802cb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802cbe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802cc2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cc6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802cca:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802cce:	0f b6 12             	movzbl (%rdx),%edx
  802cd1:	88 10                	mov    %dl,(%rax)
  802cd3:	0f b6 00             	movzbl (%rax),%eax
  802cd6:	84 c0                	test   %al,%al
  802cd8:	75 dc                	jne    802cb6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802cda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802cde:	c9                   	leaveq 
  802cdf:	c3                   	retq   

0000000000802ce0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802ce0:	55                   	push   %rbp
  802ce1:	48 89 e5             	mov    %rsp,%rbp
  802ce4:	48 83 ec 20          	sub    $0x20,%rsp
  802ce8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802cf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf4:	48 89 c7             	mov    %rax,%rdi
  802cf7:	48 b8 31 2c 80 00 00 	movabs $0x802c31,%rax
  802cfe:	00 00 00 
  802d01:	ff d0                	callq  *%rax
  802d03:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802d06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d09:	48 63 d0             	movslq %eax,%rdx
  802d0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d10:	48 01 c2             	add    %rax,%rdx
  802d13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d17:	48 89 c6             	mov    %rax,%rsi
  802d1a:	48 89 d7             	mov    %rdx,%rdi
  802d1d:	48 b8 9d 2c 80 00 00 	movabs $0x802c9d,%rax
  802d24:	00 00 00 
  802d27:	ff d0                	callq  *%rax
	return dst;
  802d29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802d2d:	c9                   	leaveq 
  802d2e:	c3                   	retq   

0000000000802d2f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802d2f:	55                   	push   %rbp
  802d30:	48 89 e5             	mov    %rsp,%rbp
  802d33:	48 83 ec 28          	sub    $0x28,%rsp
  802d37:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d3b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d3f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802d43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d47:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802d4b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802d52:	00 
  802d53:	eb 2a                	jmp    802d7f <strncpy+0x50>
		*dst++ = *src;
  802d55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d59:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d5d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d61:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d65:	0f b6 12             	movzbl (%rdx),%edx
  802d68:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802d6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d6e:	0f b6 00             	movzbl (%rax),%eax
  802d71:	84 c0                	test   %al,%al
  802d73:	74 05                	je     802d7a <strncpy+0x4b>
			src++;
  802d75:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802d7a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d83:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d87:	72 cc                	jb     802d55 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802d89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802d8d:	c9                   	leaveq 
  802d8e:	c3                   	retq   

0000000000802d8f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802d8f:	55                   	push   %rbp
  802d90:	48 89 e5             	mov    %rsp,%rbp
  802d93:	48 83 ec 28          	sub    $0x28,%rsp
  802d97:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d9b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d9f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802da3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802dab:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802db0:	74 3d                	je     802def <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802db2:	eb 1d                	jmp    802dd1 <strlcpy+0x42>
			*dst++ = *src++;
  802db4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802dbc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802dc0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802dc4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802dc8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802dcc:	0f b6 12             	movzbl (%rdx),%edx
  802dcf:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802dd1:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802dd6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802ddb:	74 0b                	je     802de8 <strlcpy+0x59>
  802ddd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802de1:	0f b6 00             	movzbl (%rax),%eax
  802de4:	84 c0                	test   %al,%al
  802de6:	75 cc                	jne    802db4 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802de8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dec:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802def:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802df3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df7:	48 29 c2             	sub    %rax,%rdx
  802dfa:	48 89 d0             	mov    %rdx,%rax
}
  802dfd:	c9                   	leaveq 
  802dfe:	c3                   	retq   

0000000000802dff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802dff:	55                   	push   %rbp
  802e00:	48 89 e5             	mov    %rsp,%rbp
  802e03:	48 83 ec 10          	sub    $0x10,%rsp
  802e07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802e0f:	eb 0a                	jmp    802e1b <strcmp+0x1c>
		p++, q++;
  802e11:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e16:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802e1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e1f:	0f b6 00             	movzbl (%rax),%eax
  802e22:	84 c0                	test   %al,%al
  802e24:	74 12                	je     802e38 <strcmp+0x39>
  802e26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e2a:	0f b6 10             	movzbl (%rax),%edx
  802e2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e31:	0f b6 00             	movzbl (%rax),%eax
  802e34:	38 c2                	cmp    %al,%dl
  802e36:	74 d9                	je     802e11 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802e38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e3c:	0f b6 00             	movzbl (%rax),%eax
  802e3f:	0f b6 d0             	movzbl %al,%edx
  802e42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e46:	0f b6 00             	movzbl (%rax),%eax
  802e49:	0f b6 c0             	movzbl %al,%eax
  802e4c:	29 c2                	sub    %eax,%edx
  802e4e:	89 d0                	mov    %edx,%eax
}
  802e50:	c9                   	leaveq 
  802e51:	c3                   	retq   

0000000000802e52 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802e52:	55                   	push   %rbp
  802e53:	48 89 e5             	mov    %rsp,%rbp
  802e56:	48 83 ec 18          	sub    $0x18,%rsp
  802e5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e62:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802e66:	eb 0f                	jmp    802e77 <strncmp+0x25>
		n--, p++, q++;
  802e68:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802e6d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e72:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802e77:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e7c:	74 1d                	je     802e9b <strncmp+0x49>
  802e7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e82:	0f b6 00             	movzbl (%rax),%eax
  802e85:	84 c0                	test   %al,%al
  802e87:	74 12                	je     802e9b <strncmp+0x49>
  802e89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e8d:	0f b6 10             	movzbl (%rax),%edx
  802e90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e94:	0f b6 00             	movzbl (%rax),%eax
  802e97:	38 c2                	cmp    %al,%dl
  802e99:	74 cd                	je     802e68 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802e9b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ea0:	75 07                	jne    802ea9 <strncmp+0x57>
		return 0;
  802ea2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea7:	eb 18                	jmp    802ec1 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802ea9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ead:	0f b6 00             	movzbl (%rax),%eax
  802eb0:	0f b6 d0             	movzbl %al,%edx
  802eb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb7:	0f b6 00             	movzbl (%rax),%eax
  802eba:	0f b6 c0             	movzbl %al,%eax
  802ebd:	29 c2                	sub    %eax,%edx
  802ebf:	89 d0                	mov    %edx,%eax
}
  802ec1:	c9                   	leaveq 
  802ec2:	c3                   	retq   

0000000000802ec3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802ec3:	55                   	push   %rbp
  802ec4:	48 89 e5             	mov    %rsp,%rbp
  802ec7:	48 83 ec 0c          	sub    $0xc,%rsp
  802ecb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ecf:	89 f0                	mov    %esi,%eax
  802ed1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802ed4:	eb 17                	jmp    802eed <strchr+0x2a>
		if (*s == c)
  802ed6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eda:	0f b6 00             	movzbl (%rax),%eax
  802edd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802ee0:	75 06                	jne    802ee8 <strchr+0x25>
			return (char *) s;
  802ee2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee6:	eb 15                	jmp    802efd <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802ee8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802eed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ef1:	0f b6 00             	movzbl (%rax),%eax
  802ef4:	84 c0                	test   %al,%al
  802ef6:	75 de                	jne    802ed6 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802ef8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802efd:	c9                   	leaveq 
  802efe:	c3                   	retq   

0000000000802eff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802eff:	55                   	push   %rbp
  802f00:	48 89 e5             	mov    %rsp,%rbp
  802f03:	48 83 ec 0c          	sub    $0xc,%rsp
  802f07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f0b:	89 f0                	mov    %esi,%eax
  802f0d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802f10:	eb 13                	jmp    802f25 <strfind+0x26>
		if (*s == c)
  802f12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f16:	0f b6 00             	movzbl (%rax),%eax
  802f19:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802f1c:	75 02                	jne    802f20 <strfind+0x21>
			break;
  802f1e:	eb 10                	jmp    802f30 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802f20:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f29:	0f b6 00             	movzbl (%rax),%eax
  802f2c:	84 c0                	test   %al,%al
  802f2e:	75 e2                	jne    802f12 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802f30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f34:	c9                   	leaveq 
  802f35:	c3                   	retq   

0000000000802f36 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802f36:	55                   	push   %rbp
  802f37:	48 89 e5             	mov    %rsp,%rbp
  802f3a:	48 83 ec 18          	sub    $0x18,%rsp
  802f3e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f42:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802f45:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802f49:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f4e:	75 06                	jne    802f56 <memset+0x20>
		return v;
  802f50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f54:	eb 69                	jmp    802fbf <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802f56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f5a:	83 e0 03             	and    $0x3,%eax
  802f5d:	48 85 c0             	test   %rax,%rax
  802f60:	75 48                	jne    802faa <memset+0x74>
  802f62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f66:	83 e0 03             	and    $0x3,%eax
  802f69:	48 85 c0             	test   %rax,%rax
  802f6c:	75 3c                	jne    802faa <memset+0x74>
		c &= 0xFF;
  802f6e:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802f75:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f78:	c1 e0 18             	shl    $0x18,%eax
  802f7b:	89 c2                	mov    %eax,%edx
  802f7d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f80:	c1 e0 10             	shl    $0x10,%eax
  802f83:	09 c2                	or     %eax,%edx
  802f85:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f88:	c1 e0 08             	shl    $0x8,%eax
  802f8b:	09 d0                	or     %edx,%eax
  802f8d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802f90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f94:	48 c1 e8 02          	shr    $0x2,%rax
  802f98:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802f9b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f9f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fa2:	48 89 d7             	mov    %rdx,%rdi
  802fa5:	fc                   	cld    
  802fa6:	f3 ab                	rep stos %eax,%es:(%rdi)
  802fa8:	eb 11                	jmp    802fbb <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802faa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fb1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fb5:	48 89 d7             	mov    %rdx,%rdi
  802fb8:	fc                   	cld    
  802fb9:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802fbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802fbf:	c9                   	leaveq 
  802fc0:	c3                   	retq   

0000000000802fc1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802fc1:	55                   	push   %rbp
  802fc2:	48 89 e5             	mov    %rsp,%rbp
  802fc5:	48 83 ec 28          	sub    $0x28,%rsp
  802fc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fd1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802fd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fd9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802fdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802fe5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fe9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802fed:	0f 83 88 00 00 00    	jae    80307b <memmove+0xba>
  802ff3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ff7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ffb:	48 01 d0             	add    %rdx,%rax
  802ffe:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803002:	76 77                	jbe    80307b <memmove+0xba>
		s += n;
  803004:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803008:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80300c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803010:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803014:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803018:	83 e0 03             	and    $0x3,%eax
  80301b:	48 85 c0             	test   %rax,%rax
  80301e:	75 3b                	jne    80305b <memmove+0x9a>
  803020:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803024:	83 e0 03             	and    $0x3,%eax
  803027:	48 85 c0             	test   %rax,%rax
  80302a:	75 2f                	jne    80305b <memmove+0x9a>
  80302c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803030:	83 e0 03             	and    $0x3,%eax
  803033:	48 85 c0             	test   %rax,%rax
  803036:	75 23                	jne    80305b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  803038:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80303c:	48 83 e8 04          	sub    $0x4,%rax
  803040:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803044:	48 83 ea 04          	sub    $0x4,%rdx
  803048:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80304c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  803050:	48 89 c7             	mov    %rax,%rdi
  803053:	48 89 d6             	mov    %rdx,%rsi
  803056:	fd                   	std    
  803057:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803059:	eb 1d                	jmp    803078 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80305b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803063:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803067:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80306b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80306f:	48 89 d7             	mov    %rdx,%rdi
  803072:	48 89 c1             	mov    %rax,%rcx
  803075:	fd                   	std    
  803076:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  803078:	fc                   	cld    
  803079:	eb 57                	jmp    8030d2 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80307b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80307f:	83 e0 03             	and    $0x3,%eax
  803082:	48 85 c0             	test   %rax,%rax
  803085:	75 36                	jne    8030bd <memmove+0xfc>
  803087:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308b:	83 e0 03             	and    $0x3,%eax
  80308e:	48 85 c0             	test   %rax,%rax
  803091:	75 2a                	jne    8030bd <memmove+0xfc>
  803093:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803097:	83 e0 03             	and    $0x3,%eax
  80309a:	48 85 c0             	test   %rax,%rax
  80309d:	75 1e                	jne    8030bd <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80309f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030a3:	48 c1 e8 02          	shr    $0x2,%rax
  8030a7:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8030aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030b2:	48 89 c7             	mov    %rax,%rdi
  8030b5:	48 89 d6             	mov    %rdx,%rsi
  8030b8:	fc                   	cld    
  8030b9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8030bb:	eb 15                	jmp    8030d2 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8030bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030c5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8030c9:	48 89 c7             	mov    %rax,%rdi
  8030cc:	48 89 d6             	mov    %rdx,%rsi
  8030cf:	fc                   	cld    
  8030d0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8030d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8030d6:	c9                   	leaveq 
  8030d7:	c3                   	retq   

00000000008030d8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8030d8:	55                   	push   %rbp
  8030d9:	48 89 e5             	mov    %rsp,%rbp
  8030dc:	48 83 ec 18          	sub    $0x18,%rsp
  8030e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030e8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8030ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030f0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8030f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030f8:	48 89 ce             	mov    %rcx,%rsi
  8030fb:	48 89 c7             	mov    %rax,%rdi
  8030fe:	48 b8 c1 2f 80 00 00 	movabs $0x802fc1,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax
}
  80310a:	c9                   	leaveq 
  80310b:	c3                   	retq   

000000000080310c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80310c:	55                   	push   %rbp
  80310d:	48 89 e5             	mov    %rsp,%rbp
  803110:	48 83 ec 28          	sub    $0x28,%rsp
  803114:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803118:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80311c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  803120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803124:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  803128:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80312c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  803130:	eb 36                	jmp    803168 <memcmp+0x5c>
		if (*s1 != *s2)
  803132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803136:	0f b6 10             	movzbl (%rax),%edx
  803139:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80313d:	0f b6 00             	movzbl (%rax),%eax
  803140:	38 c2                	cmp    %al,%dl
  803142:	74 1a                	je     80315e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  803144:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803148:	0f b6 00             	movzbl (%rax),%eax
  80314b:	0f b6 d0             	movzbl %al,%edx
  80314e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803152:	0f b6 00             	movzbl (%rax),%eax
  803155:	0f b6 c0             	movzbl %al,%eax
  803158:	29 c2                	sub    %eax,%edx
  80315a:	89 d0                	mov    %edx,%eax
  80315c:	eb 20                	jmp    80317e <memcmp+0x72>
		s1++, s2++;
  80315e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803163:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803168:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80316c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803170:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803174:	48 85 c0             	test   %rax,%rax
  803177:	75 b9                	jne    803132 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803179:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80317e:	c9                   	leaveq 
  80317f:	c3                   	retq   

0000000000803180 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803180:	55                   	push   %rbp
  803181:	48 89 e5             	mov    %rsp,%rbp
  803184:	48 83 ec 28          	sub    $0x28,%rsp
  803188:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80318c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80318f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803193:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803197:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80319b:	48 01 d0             	add    %rdx,%rax
  80319e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8031a2:	eb 15                	jmp    8031b9 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8031a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031a8:	0f b6 10             	movzbl (%rax),%edx
  8031ab:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8031ae:	38 c2                	cmp    %al,%dl
  8031b0:	75 02                	jne    8031b4 <memfind+0x34>
			break;
  8031b2:	eb 0f                	jmp    8031c3 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8031b4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8031b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031bd:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8031c1:	72 e1                	jb     8031a4 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8031c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8031c7:	c9                   	leaveq 
  8031c8:	c3                   	retq   

00000000008031c9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8031c9:	55                   	push   %rbp
  8031ca:	48 89 e5             	mov    %rsp,%rbp
  8031cd:	48 83 ec 34          	sub    $0x34,%rsp
  8031d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8031d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8031d9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8031dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8031e3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8031ea:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8031eb:	eb 05                	jmp    8031f2 <strtol+0x29>
		s++;
  8031ed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8031f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031f6:	0f b6 00             	movzbl (%rax),%eax
  8031f9:	3c 20                	cmp    $0x20,%al
  8031fb:	74 f0                	je     8031ed <strtol+0x24>
  8031fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803201:	0f b6 00             	movzbl (%rax),%eax
  803204:	3c 09                	cmp    $0x9,%al
  803206:	74 e5                	je     8031ed <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803208:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80320c:	0f b6 00             	movzbl (%rax),%eax
  80320f:	3c 2b                	cmp    $0x2b,%al
  803211:	75 07                	jne    80321a <strtol+0x51>
		s++;
  803213:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803218:	eb 17                	jmp    803231 <strtol+0x68>
	else if (*s == '-')
  80321a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80321e:	0f b6 00             	movzbl (%rax),%eax
  803221:	3c 2d                	cmp    $0x2d,%al
  803223:	75 0c                	jne    803231 <strtol+0x68>
		s++, neg = 1;
  803225:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80322a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803231:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803235:	74 06                	je     80323d <strtol+0x74>
  803237:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80323b:	75 28                	jne    803265 <strtol+0x9c>
  80323d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803241:	0f b6 00             	movzbl (%rax),%eax
  803244:	3c 30                	cmp    $0x30,%al
  803246:	75 1d                	jne    803265 <strtol+0x9c>
  803248:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80324c:	48 83 c0 01          	add    $0x1,%rax
  803250:	0f b6 00             	movzbl (%rax),%eax
  803253:	3c 78                	cmp    $0x78,%al
  803255:	75 0e                	jne    803265 <strtol+0x9c>
		s += 2, base = 16;
  803257:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80325c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803263:	eb 2c                	jmp    803291 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803265:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803269:	75 19                	jne    803284 <strtol+0xbb>
  80326b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326f:	0f b6 00             	movzbl (%rax),%eax
  803272:	3c 30                	cmp    $0x30,%al
  803274:	75 0e                	jne    803284 <strtol+0xbb>
		s++, base = 8;
  803276:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80327b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803282:	eb 0d                	jmp    803291 <strtol+0xc8>
	else if (base == 0)
  803284:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803288:	75 07                	jne    803291 <strtol+0xc8>
		base = 10;
  80328a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803291:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803295:	0f b6 00             	movzbl (%rax),%eax
  803298:	3c 2f                	cmp    $0x2f,%al
  80329a:	7e 1d                	jle    8032b9 <strtol+0xf0>
  80329c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a0:	0f b6 00             	movzbl (%rax),%eax
  8032a3:	3c 39                	cmp    $0x39,%al
  8032a5:	7f 12                	jg     8032b9 <strtol+0xf0>
			dig = *s - '0';
  8032a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032ab:	0f b6 00             	movzbl (%rax),%eax
  8032ae:	0f be c0             	movsbl %al,%eax
  8032b1:	83 e8 30             	sub    $0x30,%eax
  8032b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032b7:	eb 4e                	jmp    803307 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8032b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032bd:	0f b6 00             	movzbl (%rax),%eax
  8032c0:	3c 60                	cmp    $0x60,%al
  8032c2:	7e 1d                	jle    8032e1 <strtol+0x118>
  8032c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032c8:	0f b6 00             	movzbl (%rax),%eax
  8032cb:	3c 7a                	cmp    $0x7a,%al
  8032cd:	7f 12                	jg     8032e1 <strtol+0x118>
			dig = *s - 'a' + 10;
  8032cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032d3:	0f b6 00             	movzbl (%rax),%eax
  8032d6:	0f be c0             	movsbl %al,%eax
  8032d9:	83 e8 57             	sub    $0x57,%eax
  8032dc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032df:	eb 26                	jmp    803307 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8032e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032e5:	0f b6 00             	movzbl (%rax),%eax
  8032e8:	3c 40                	cmp    $0x40,%al
  8032ea:	7e 48                	jle    803334 <strtol+0x16b>
  8032ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032f0:	0f b6 00             	movzbl (%rax),%eax
  8032f3:	3c 5a                	cmp    $0x5a,%al
  8032f5:	7f 3d                	jg     803334 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8032f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032fb:	0f b6 00             	movzbl (%rax),%eax
  8032fe:	0f be c0             	movsbl %al,%eax
  803301:	83 e8 37             	sub    $0x37,%eax
  803304:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803307:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80330a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80330d:	7c 02                	jl     803311 <strtol+0x148>
			break;
  80330f:	eb 23                	jmp    803334 <strtol+0x16b>
		s++, val = (val * base) + dig;
  803311:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803316:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803319:	48 98                	cltq   
  80331b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803320:	48 89 c2             	mov    %rax,%rdx
  803323:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803326:	48 98                	cltq   
  803328:	48 01 d0             	add    %rdx,%rax
  80332b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80332f:	e9 5d ff ff ff       	jmpq   803291 <strtol+0xc8>

	if (endptr)
  803334:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803339:	74 0b                	je     803346 <strtol+0x17d>
		*endptr = (char *) s;
  80333b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80333f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803343:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  803346:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80334a:	74 09                	je     803355 <strtol+0x18c>
  80334c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803350:	48 f7 d8             	neg    %rax
  803353:	eb 04                	jmp    803359 <strtol+0x190>
  803355:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803359:	c9                   	leaveq 
  80335a:	c3                   	retq   

000000000080335b <strstr>:

char * strstr(const char *in, const char *str)
{
  80335b:	55                   	push   %rbp
  80335c:	48 89 e5             	mov    %rsp,%rbp
  80335f:	48 83 ec 30          	sub    $0x30,%rsp
  803363:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803367:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80336b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80336f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803373:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803377:	0f b6 00             	movzbl (%rax),%eax
  80337a:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80337d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803381:	75 06                	jne    803389 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803387:	eb 6b                	jmp    8033f4 <strstr+0x99>

	len = strlen(str);
  803389:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80338d:	48 89 c7             	mov    %rax,%rdi
  803390:	48 b8 31 2c 80 00 00 	movabs $0x802c31,%rax
  803397:	00 00 00 
  80339a:	ff d0                	callq  *%rax
  80339c:	48 98                	cltq   
  80339e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8033a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033a6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8033aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8033ae:	0f b6 00             	movzbl (%rax),%eax
  8033b1:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8033b4:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8033b8:	75 07                	jne    8033c1 <strstr+0x66>
				return (char *) 0;
  8033ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8033bf:	eb 33                	jmp    8033f4 <strstr+0x99>
		} while (sc != c);
  8033c1:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8033c5:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8033c8:	75 d8                	jne    8033a2 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8033ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033ce:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8033d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d6:	48 89 ce             	mov    %rcx,%rsi
  8033d9:	48 89 c7             	mov    %rax,%rdi
  8033dc:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  8033e3:	00 00 00 
  8033e6:	ff d0                	callq  *%rax
  8033e8:	85 c0                	test   %eax,%eax
  8033ea:	75 b6                	jne    8033a2 <strstr+0x47>

	return (char *) (in - 1);
  8033ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f0:	48 83 e8 01          	sub    $0x1,%rax
}
  8033f4:	c9                   	leaveq 
  8033f5:	c3                   	retq   

00000000008033f6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8033f6:	55                   	push   %rbp
  8033f7:	48 89 e5             	mov    %rsp,%rbp
  8033fa:	48 83 ec 30          	sub    $0x30,%rsp
  8033fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803402:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803406:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  80340a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80340f:	75 08                	jne    803419 <ipc_recv+0x23>
  803411:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  803418:	ff 
	int res=sys_ipc_recv(pg);
  803419:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80341d:	48 89 c7             	mov    %rax,%rdi
  803420:	48 b8 67 05 80 00 00 	movabs $0x800567,%rax
  803427:	00 00 00 
  80342a:	ff d0                	callq  *%rax
  80342c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  80342f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803434:	74 26                	je     80345c <ipc_recv+0x66>
  803436:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80343a:	75 15                	jne    803451 <ipc_recv+0x5b>
  80343c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803443:	00 00 00 
  803446:	48 8b 00             	mov    (%rax),%rax
  803449:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  80344f:	eb 05                	jmp    803456 <ipc_recv+0x60>
  803451:	b8 00 00 00 00       	mov    $0x0,%eax
  803456:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80345a:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  80345c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803461:	74 26                	je     803489 <ipc_recv+0x93>
  803463:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803467:	75 15                	jne    80347e <ipc_recv+0x88>
  803469:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803470:	00 00 00 
  803473:	48 8b 00             	mov    (%rax),%rax
  803476:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  80347c:	eb 05                	jmp    803483 <ipc_recv+0x8d>
  80347e:	b8 00 00 00 00       	mov    $0x0,%eax
  803483:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803487:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  803489:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80348d:	75 15                	jne    8034a4 <ipc_recv+0xae>
  80348f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803496:	00 00 00 
  803499:	48 8b 00             	mov    (%rax),%rax
  80349c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  8034a2:	eb 03                	jmp    8034a7 <ipc_recv+0xb1>
  8034a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  8034a7:	c9                   	leaveq 
  8034a8:	c3                   	retq   

00000000008034a9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8034a9:	55                   	push   %rbp
  8034aa:	48 89 e5             	mov    %rsp,%rbp
  8034ad:	48 83 ec 30          	sub    $0x30,%rsp
  8034b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034b4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8034b7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8034bb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  8034be:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8034c3:	75 0a                	jne    8034cf <ipc_send+0x26>
  8034c5:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8034cc:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8034cd:	eb 3e                	jmp    80350d <ipc_send+0x64>
  8034cf:	eb 3c                	jmp    80350d <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  8034d1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8034d5:	74 2a                	je     803501 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  8034d7:	48 ba 08 3d 80 00 00 	movabs $0x803d08,%rdx
  8034de:	00 00 00 
  8034e1:	be 39 00 00 00       	mov    $0x39,%esi
  8034e6:	48 bf 33 3d 80 00 00 	movabs $0x803d33,%rdi
  8034ed:	00 00 00 
  8034f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f5:	48 b9 6e 1e 80 00 00 	movabs $0x801e6e,%rcx
  8034fc:	00 00 00 
  8034ff:	ff d1                	callq  *%rcx
		sys_yield();  
  803501:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  803508:	00 00 00 
  80350b:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  80350d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803510:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803513:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803517:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80351a:	89 c7                	mov    %eax,%edi
  80351c:	48 b8 12 05 80 00 00 	movabs $0x800512,%rax
  803523:	00 00 00 
  803526:	ff d0                	callq  *%rax
  803528:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80352b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80352f:	78 a0                	js     8034d1 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  803531:	c9                   	leaveq 
  803532:	c3                   	retq   

0000000000803533 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803533:	55                   	push   %rbp
  803534:	48 89 e5             	mov    %rsp,%rbp
  803537:	48 83 ec 10          	sub    $0x10,%rsp
  80353b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  80353f:	48 ba 40 3d 80 00 00 	movabs $0x803d40,%rdx
  803546:	00 00 00 
  803549:	be 47 00 00 00       	mov    $0x47,%esi
  80354e:	48 bf 33 3d 80 00 00 	movabs $0x803d33,%rdi
  803555:	00 00 00 
  803558:	b8 00 00 00 00       	mov    $0x0,%eax
  80355d:	48 b9 6e 1e 80 00 00 	movabs $0x801e6e,%rcx
  803564:	00 00 00 
  803567:	ff d1                	callq  *%rcx

0000000000803569 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803569:	55                   	push   %rbp
  80356a:	48 89 e5             	mov    %rsp,%rbp
  80356d:	48 83 ec 20          	sub    $0x20,%rsp
  803571:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803574:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803577:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  80357b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  80357e:	48 ba 68 3d 80 00 00 	movabs $0x803d68,%rdx
  803585:	00 00 00 
  803588:	be 50 00 00 00       	mov    $0x50,%esi
  80358d:	48 bf 33 3d 80 00 00 	movabs $0x803d33,%rdi
  803594:	00 00 00 
  803597:	b8 00 00 00 00       	mov    $0x0,%eax
  80359c:	48 b9 6e 1e 80 00 00 	movabs $0x801e6e,%rcx
  8035a3:	00 00 00 
  8035a6:	ff d1                	callq  *%rcx

00000000008035a8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8035a8:	55                   	push   %rbp
  8035a9:	48 89 e5             	mov    %rsp,%rbp
  8035ac:	48 83 ec 14          	sub    $0x14,%rsp
  8035b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8035b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8035ba:	eb 4e                	jmp    80360a <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8035bc:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8035c3:	00 00 00 
  8035c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c9:	48 98                	cltq   
  8035cb:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8035d2:	48 01 d0             	add    %rdx,%rax
  8035d5:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8035db:	8b 00                	mov    (%rax),%eax
  8035dd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8035e0:	75 24                	jne    803606 <ipc_find_env+0x5e>
			return envs[i].env_id;
  8035e2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8035e9:	00 00 00 
  8035ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ef:	48 98                	cltq   
  8035f1:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8035f8:	48 01 d0             	add    %rdx,%rax
  8035fb:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803601:	8b 40 08             	mov    0x8(%rax),%eax
  803604:	eb 12                	jmp    803618 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803606:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80360a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803611:	7e a9                	jle    8035bc <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  803613:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803618:	c9                   	leaveq 
  803619:	c3                   	retq   

000000000080361a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80361a:	55                   	push   %rbp
  80361b:	48 89 e5             	mov    %rsp,%rbp
  80361e:	48 83 ec 18          	sub    $0x18,%rsp
  803622:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803626:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80362a:	48 c1 e8 15          	shr    $0x15,%rax
  80362e:	48 89 c2             	mov    %rax,%rdx
  803631:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803638:	01 00 00 
  80363b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80363f:	83 e0 01             	and    $0x1,%eax
  803642:	48 85 c0             	test   %rax,%rax
  803645:	75 07                	jne    80364e <pageref+0x34>
		return 0;
  803647:	b8 00 00 00 00       	mov    $0x0,%eax
  80364c:	eb 53                	jmp    8036a1 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80364e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803652:	48 c1 e8 0c          	shr    $0xc,%rax
  803656:	48 89 c2             	mov    %rax,%rdx
  803659:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803660:	01 00 00 
  803663:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803667:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80366b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80366f:	83 e0 01             	and    $0x1,%eax
  803672:	48 85 c0             	test   %rax,%rax
  803675:	75 07                	jne    80367e <pageref+0x64>
		return 0;
  803677:	b8 00 00 00 00       	mov    $0x0,%eax
  80367c:	eb 23                	jmp    8036a1 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80367e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803682:	48 c1 e8 0c          	shr    $0xc,%rax
  803686:	48 89 c2             	mov    %rax,%rdx
  803689:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803690:	00 00 00 
  803693:	48 c1 e2 04          	shl    $0x4,%rdx
  803697:	48 01 d0             	add    %rdx,%rax
  80369a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80369e:	0f b7 c0             	movzwl %ax,%eax
}
  8036a1:	c9                   	leaveq 
  8036a2:	c3                   	retq   
