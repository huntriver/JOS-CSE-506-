
vmm/guest/obj/user/testpiperace:     file format elf64-x86-64


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
  80003c:	e8 44 03 00 00       	callq  800385 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 50          	sub    $0x50,%rsp
  80004b:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80004e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800052:	48 bf 20 44 80 00 00 	movabs $0x804420,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 73 3a 80 00 00 	movabs $0x803a73,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 39 44 80 00 00 	movabs $0x804439,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf 42 44 80 00 00 	movabs $0x804442,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	max = 200;
  8000b9:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c0:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d3:	79 30                	jns    800105 <umain+0xc2>
		panic("fork: %e", r);
  8000d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d8:	89 c1                	mov    %eax,%ecx
  8000da:	48 ba 56 44 80 00 00 	movabs $0x804456,%rdx
  8000e1:	00 00 00 
  8000e4:	be 10 00 00 00       	mov    $0x10,%esi
  8000e9:	48 bf 42 44 80 00 00 	movabs $0x804442,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8000ff:	00 00 00 
  800102:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800105:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800109:	0f 85 89 00 00 00    	jne    800198 <umain+0x155>
		close(p[1]);
  80010f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800112:	89 c7                	mov    %eax,%edi
  800114:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800127:	eb 4c                	jmp    800175 <umain+0x132>
			if(pipeisclosed(p[0])){
  800129:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80012c:	89 c7                	mov    %eax,%edi
  80012e:	48 b8 3c 3d 80 00 00 	movabs $0x803d3c,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 27                	je     800165 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013e:	48 bf 5f 44 80 00 00 	movabs $0x80445f,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			sys_yield();
  800165:	48 b8 4b 1b 80 00 00 	movabs $0x801b4b,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800171:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800175:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800178:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80017b:	7c ac                	jl     800129 <umain+0xe6>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  80017d:	ba 00 00 00 00       	mov    $0x0,%edx
  800182:	be 00 00 00 00       	mov    $0x0,%esi
  800187:	bf 00 00 00 00       	mov    $0x0,%edi
  80018c:	48 b8 62 28 80 00 00 	movabs $0x802862,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
	}
	pid = r;
  800198:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019b:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a1:	89 c6                	mov    %eax,%esi
  8001a3:	48 bf 7a 44 80 00 00 	movabs $0x80447a,%rdi
  8001aa:	00 00 00 
  8001ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b2:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  8001b9:	00 00 00 
  8001bc:	ff d2                	callq  *%rdx
	va = 0;
  8001be:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8001c5:	00 
	kid = &envs[ENVX(pid)];
  8001c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ce:	48 98                	cltq   
  8001d0:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8001d7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001de:	00 00 00 
  8001e1:	48 01 d0             	add    %rdx,%rax
  8001e4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	cprintf("kid is %d\n", kid-envs);
  8001e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001ec:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001f3:	00 00 00 
  8001f6:	48 29 c2             	sub    %rax,%rdx
  8001f9:	48 89 d0             	mov    %rdx,%rax
  8001fc:	48 c1 f8 04          	sar    $0x4,%rax
  800200:	48 89 c2             	mov    %rax,%rdx
  800203:	48 b8 a7 37 bd e9 4d 	movabs $0xd37a6f4de9bd37a7,%rax
  80020a:	6f 7a d3 
  80020d:	48 0f af c2          	imul   %rdx,%rax
  800211:	48 89 c6             	mov    %rax,%rsi
  800214:	48 bf 85 44 80 00 00 	movabs $0x804485,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  80022f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800232:	be 0a 00 00 00       	mov    $0xa,%esi
  800237:	89 c7                	mov    %eax,%edi
  800239:	48 b8 f5 2d 80 00 00 	movabs $0x802df5,%rax
  800240:	00 00 00 
  800243:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  800245:	eb 16                	jmp    80025d <umain+0x21a>
		dup(p[0], 10);
  800247:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80024a:	be 0a 00 00 00       	mov    $0xa,%esi
  80024f:	89 c7                	mov    %eax,%edi
  800251:	48 b8 f5 2d 80 00 00 	movabs $0x802df5,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  80025d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800261:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  800267:	83 f8 02             	cmp    $0x2,%eax
  80026a:	74 db                	je     800247 <umain+0x204>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  80026c:	48 bf 90 44 80 00 00 	movabs $0x804490,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800282:	00 00 00 
  800285:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800287:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80028a:	89 c7                	mov    %eax,%edi
  80028c:	48 b8 3c 3d 80 00 00 	movabs $0x803d3c,%rax
  800293:	00 00 00 
  800296:	ff d0                	callq  *%rax
  800298:	85 c0                	test   %eax,%eax
  80029a:	74 2a                	je     8002c6 <umain+0x283>
		panic("somehow the other end of p[0] got closed!");
  80029c:	48 ba a8 44 80 00 00 	movabs $0x8044a8,%rdx
  8002a3:	00 00 00 
  8002a6:	be 3a 00 00 00       	mov    $0x3a,%esi
  8002ab:	48 bf 42 44 80 00 00 	movabs $0x804442,%rdi
  8002b2:	00 00 00 
  8002b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ba:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8002c1:	00 00 00 
  8002c4:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002c6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002c9:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8002cd:	48 89 d6             	mov    %rdx,%rsi
  8002d0:	89 c7                	mov    %eax,%edi
  8002d2:	48 b8 6c 2b 80 00 00 	movabs $0x802b6c,%rax
  8002d9:	00 00 00 
  8002dc:	ff d0                	callq  *%rax
  8002de:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002e1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002e5:	79 30                	jns    800317 <umain+0x2d4>
		panic("cannot look up p[0]: %e", r);
  8002e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ea:	89 c1                	mov    %eax,%ecx
  8002ec:	48 ba d2 44 80 00 00 	movabs $0x8044d2,%rdx
  8002f3:	00 00 00 
  8002f6:	be 3c 00 00 00       	mov    $0x3c,%esi
  8002fb:	48 bf 42 44 80 00 00 	movabs $0x804442,%rdi
  800302:	00 00 00 
  800305:	b8 00 00 00 00       	mov    $0x0,%eax
  80030a:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  800311:	00 00 00 
  800314:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  800317:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80031b:	48 89 c7             	mov    %rax,%rdi
  80031e:	48 b8 a9 2a 80 00 00 	movabs $0x802aa9,%rax
  800325:	00 00 00 
  800328:	ff d0                	callq  *%rax
  80032a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  80032e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800332:	48 89 c7             	mov    %rax,%rdi
  800335:	48 b8 ea 39 80 00 00 	movabs $0x8039ea,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
  800341:	83 f8 04             	cmp    $0x4,%eax
  800344:	74 1d                	je     800363 <umain+0x320>
		cprintf("\nchild detected race\n");
  800346:	48 bf ea 44 80 00 00 	movabs $0x8044ea,%rdi
  80034d:	00 00 00 
  800350:	b8 00 00 00 00       	mov    $0x0,%eax
  800355:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80035c:	00 00 00 
  80035f:	ff d2                	callq  *%rdx
  800361:	eb 20                	jmp    800383 <umain+0x340>
	else
		cprintf("\nrace didn't happen\n", max);
  800363:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf 00 45 80 00 00 	movabs $0x804500,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80037e:	00 00 00 
  800381:	ff d2                	callq  *%rdx
}
  800383:	c9                   	leaveq 
  800384:	c3                   	retq   

0000000000800385 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800385:	55                   	push   %rbp
  800386:	48 89 e5             	mov    %rsp,%rbp
  800389:	48 83 ec 10          	sub    $0x10,%rsp
  80038d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800390:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  800394:	48 b8 0d 1b 80 00 00 	movabs $0x801b0d,%rax
  80039b:	00 00 00 
  80039e:	ff d0                	callq  *%rax
  8003a0:	48 98                	cltq   
  8003a2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003a7:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8003ae:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8003b5:	00 00 00 
  8003b8:	48 01 c2             	add    %rax,%rdx
  8003bb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8003c2:	00 00 00 
  8003c5:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003cc:	7e 14                	jle    8003e2 <libmain+0x5d>
		binaryname = argv[0];
  8003ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d2:	48 8b 10             	mov    (%rax),%rdx
  8003d5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003dc:	00 00 00 
  8003df:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003e9:	48 89 d6             	mov    %rdx,%rsi
  8003ec:	89 c7                	mov    %eax,%edi
  8003ee:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003f5:	00 00 00 
  8003f8:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003fa:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800401:	00 00 00 
  800404:	ff d0                	callq  *%rax
}
  800406:	c9                   	leaveq 
  800407:	c3                   	retq   

0000000000800408 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800408:	55                   	push   %rbp
  800409:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80040c:	48 b8 c7 2d 80 00 00 	movabs $0x802dc7,%rax
  800413:	00 00 00 
  800416:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800418:	bf 00 00 00 00       	mov    $0x0,%edi
  80041d:	48 b8 c9 1a 80 00 00 	movabs $0x801ac9,%rax
  800424:	00 00 00 
  800427:	ff d0                	callq  *%rax
}
  800429:	5d                   	pop    %rbp
  80042a:	c3                   	retq   

000000000080042b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80042b:	55                   	push   %rbp
  80042c:	48 89 e5             	mov    %rsp,%rbp
  80042f:	53                   	push   %rbx
  800430:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800437:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80043e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800444:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80044b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800452:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800459:	84 c0                	test   %al,%al
  80045b:	74 23                	je     800480 <_panic+0x55>
  80045d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800464:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800468:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80046c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800470:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800474:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800478:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80047c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800480:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800487:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80048e:	00 00 00 
  800491:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800498:	00 00 00 
  80049b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80049f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004a6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004ad:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004b4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8004bb:	00 00 00 
  8004be:	48 8b 18             	mov    (%rax),%rbx
  8004c1:	48 b8 0d 1b 80 00 00 	movabs $0x801b0d,%rax
  8004c8:	00 00 00 
  8004cb:	ff d0                	callq  *%rax
  8004cd:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004d3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004da:	41 89 c8             	mov    %ecx,%r8d
  8004dd:	48 89 d1             	mov    %rdx,%rcx
  8004e0:	48 89 da             	mov    %rbx,%rdx
  8004e3:	89 c6                	mov    %eax,%esi
  8004e5:	48 bf 20 45 80 00 00 	movabs $0x804520,%rdi
  8004ec:	00 00 00 
  8004ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f4:	49 b9 64 06 80 00 00 	movabs $0x800664,%r9
  8004fb:	00 00 00 
  8004fe:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800501:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800508:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80050f:	48 89 d6             	mov    %rdx,%rsi
  800512:	48 89 c7             	mov    %rax,%rdi
  800515:	48 b8 b8 05 80 00 00 	movabs $0x8005b8,%rax
  80051c:	00 00 00 
  80051f:	ff d0                	callq  *%rax
	cprintf("\n");
  800521:	48 bf 43 45 80 00 00 	movabs $0x804543,%rdi
  800528:	00 00 00 
  80052b:	b8 00 00 00 00       	mov    $0x0,%eax
  800530:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800537:	00 00 00 
  80053a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80053c:	cc                   	int3   
  80053d:	eb fd                	jmp    80053c <_panic+0x111>

000000000080053f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80053f:	55                   	push   %rbp
  800540:	48 89 e5             	mov    %rsp,%rbp
  800543:	48 83 ec 10          	sub    $0x10,%rsp
  800547:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80054a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80054e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800552:	8b 00                	mov    (%rax),%eax
  800554:	8d 48 01             	lea    0x1(%rax),%ecx
  800557:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80055b:	89 0a                	mov    %ecx,(%rdx)
  80055d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800560:	89 d1                	mov    %edx,%ecx
  800562:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800566:	48 98                	cltq   
  800568:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80056c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800570:	8b 00                	mov    (%rax),%eax
  800572:	3d ff 00 00 00       	cmp    $0xff,%eax
  800577:	75 2c                	jne    8005a5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057d:	8b 00                	mov    (%rax),%eax
  80057f:	48 98                	cltq   
  800581:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800585:	48 83 c2 08          	add    $0x8,%rdx
  800589:	48 89 c6             	mov    %rax,%rsi
  80058c:	48 89 d7             	mov    %rdx,%rdi
  80058f:	48 b8 41 1a 80 00 00 	movabs $0x801a41,%rax
  800596:	00 00 00 
  800599:	ff d0                	callq  *%rax
        b->idx = 0;
  80059b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80059f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8005a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a9:	8b 40 04             	mov    0x4(%rax),%eax
  8005ac:	8d 50 01             	lea    0x1(%rax),%edx
  8005af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005b6:	c9                   	leaveq 
  8005b7:	c3                   	retq   

00000000008005b8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005b8:	55                   	push   %rbp
  8005b9:	48 89 e5             	mov    %rsp,%rbp
  8005bc:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005c3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005ca:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005d1:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005d8:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005df:	48 8b 0a             	mov    (%rdx),%rcx
  8005e2:	48 89 08             	mov    %rcx,(%rax)
  8005e5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005e9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005f1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005fc:	00 00 00 
    b.cnt = 0;
  8005ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800606:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800609:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800610:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800617:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80061e:	48 89 c6             	mov    %rax,%rsi
  800621:	48 bf 3f 05 80 00 00 	movabs $0x80053f,%rdi
  800628:	00 00 00 
  80062b:	48 b8 17 0a 80 00 00 	movabs $0x800a17,%rax
  800632:	00 00 00 
  800635:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800637:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80063d:	48 98                	cltq   
  80063f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800646:	48 83 c2 08          	add    $0x8,%rdx
  80064a:	48 89 c6             	mov    %rax,%rsi
  80064d:	48 89 d7             	mov    %rdx,%rdi
  800650:	48 b8 41 1a 80 00 00 	movabs $0x801a41,%rax
  800657:	00 00 00 
  80065a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80065c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800662:	c9                   	leaveq 
  800663:	c3                   	retq   

0000000000800664 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800664:	55                   	push   %rbp
  800665:	48 89 e5             	mov    %rsp,%rbp
  800668:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80066f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800676:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80067d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800684:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80068b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800692:	84 c0                	test   %al,%al
  800694:	74 20                	je     8006b6 <cprintf+0x52>
  800696:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80069a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80069e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006a2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006a6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006aa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006ae:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006b2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006b6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006bd:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006c4:	00 00 00 
  8006c7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006ce:	00 00 00 
  8006d1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006d5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006dc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006e3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006ea:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006f1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006f8:	48 8b 0a             	mov    (%rdx),%rcx
  8006fb:	48 89 08             	mov    %rcx,(%rax)
  8006fe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800702:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800706:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80070a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80070e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800715:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80071c:	48 89 d6             	mov    %rdx,%rsi
  80071f:	48 89 c7             	mov    %rax,%rdi
  800722:	48 b8 b8 05 80 00 00 	movabs $0x8005b8,%rax
  800729:	00 00 00 
  80072c:	ff d0                	callq  *%rax
  80072e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800734:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80073a:	c9                   	leaveq 
  80073b:	c3                   	retq   

000000000080073c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80073c:	55                   	push   %rbp
  80073d:	48 89 e5             	mov    %rsp,%rbp
  800740:	53                   	push   %rbx
  800741:	48 83 ec 38          	sub    $0x38,%rsp
  800745:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800749:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80074d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800751:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800754:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800758:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80075c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80075f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800763:	77 3b                	ja     8007a0 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800765:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800768:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80076c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80076f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800773:	ba 00 00 00 00       	mov    $0x0,%edx
  800778:	48 f7 f3             	div    %rbx
  80077b:	48 89 c2             	mov    %rax,%rdx
  80077e:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800781:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800784:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078c:	41 89 f9             	mov    %edi,%r9d
  80078f:	48 89 c7             	mov    %rax,%rdi
  800792:	48 b8 3c 07 80 00 00 	movabs $0x80073c,%rax
  800799:	00 00 00 
  80079c:	ff d0                	callq  *%rax
  80079e:	eb 1e                	jmp    8007be <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007a0:	eb 12                	jmp    8007b4 <printnum+0x78>
			putch(padc, putdat);
  8007a2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007a6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8007a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ad:	48 89 ce             	mov    %rcx,%rsi
  8007b0:	89 d7                	mov    %edx,%edi
  8007b2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007b8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007bc:	7f e4                	jg     8007a2 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007be:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ca:	48 f7 f1             	div    %rcx
  8007cd:	48 89 d0             	mov    %rdx,%rax
  8007d0:	48 ba 50 47 80 00 00 	movabs $0x804750,%rdx
  8007d7:	00 00 00 
  8007da:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007de:	0f be d0             	movsbl %al,%edx
  8007e1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e9:	48 89 ce             	mov    %rcx,%rsi
  8007ec:	89 d7                	mov    %edx,%edi
  8007ee:	ff d0                	callq  *%rax
}
  8007f0:	48 83 c4 38          	add    $0x38,%rsp
  8007f4:	5b                   	pop    %rbx
  8007f5:	5d                   	pop    %rbp
  8007f6:	c3                   	retq   

00000000008007f7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007f7:	55                   	push   %rbp
  8007f8:	48 89 e5             	mov    %rsp,%rbp
  8007fb:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800803:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800806:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80080a:	7e 52                	jle    80085e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80080c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800810:	8b 00                	mov    (%rax),%eax
  800812:	83 f8 30             	cmp    $0x30,%eax
  800815:	73 24                	jae    80083b <getuint+0x44>
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80081f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800823:	8b 00                	mov    (%rax),%eax
  800825:	89 c0                	mov    %eax,%eax
  800827:	48 01 d0             	add    %rdx,%rax
  80082a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082e:	8b 12                	mov    (%rdx),%edx
  800830:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800833:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800837:	89 0a                	mov    %ecx,(%rdx)
  800839:	eb 17                	jmp    800852 <getuint+0x5b>
  80083b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800843:	48 89 d0             	mov    %rdx,%rax
  800846:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80084a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800852:	48 8b 00             	mov    (%rax),%rax
  800855:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800859:	e9 a3 00 00 00       	jmpq   800901 <getuint+0x10a>
	else if (lflag)
  80085e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800862:	74 4f                	je     8008b3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800868:	8b 00                	mov    (%rax),%eax
  80086a:	83 f8 30             	cmp    $0x30,%eax
  80086d:	73 24                	jae    800893 <getuint+0x9c>
  80086f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800873:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087b:	8b 00                	mov    (%rax),%eax
  80087d:	89 c0                	mov    %eax,%eax
  80087f:	48 01 d0             	add    %rdx,%rax
  800882:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800886:	8b 12                	mov    (%rdx),%edx
  800888:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80088b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088f:	89 0a                	mov    %ecx,(%rdx)
  800891:	eb 17                	jmp    8008aa <getuint+0xb3>
  800893:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800897:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80089b:	48 89 d0             	mov    %rdx,%rax
  80089e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008aa:	48 8b 00             	mov    (%rax),%rax
  8008ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008b1:	eb 4e                	jmp    800901 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b7:	8b 00                	mov    (%rax),%eax
  8008b9:	83 f8 30             	cmp    $0x30,%eax
  8008bc:	73 24                	jae    8008e2 <getuint+0xeb>
  8008be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ca:	8b 00                	mov    (%rax),%eax
  8008cc:	89 c0                	mov    %eax,%eax
  8008ce:	48 01 d0             	add    %rdx,%rax
  8008d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d5:	8b 12                	mov    (%rdx),%edx
  8008d7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008de:	89 0a                	mov    %ecx,(%rdx)
  8008e0:	eb 17                	jmp    8008f9 <getuint+0x102>
  8008e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ea:	48 89 d0             	mov    %rdx,%rax
  8008ed:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008f9:	8b 00                	mov    (%rax),%eax
  8008fb:	89 c0                	mov    %eax,%eax
  8008fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800901:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800905:	c9                   	leaveq 
  800906:	c3                   	retq   

0000000000800907 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800907:	55                   	push   %rbp
  800908:	48 89 e5             	mov    %rsp,%rbp
  80090b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80090f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800913:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800916:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80091a:	7e 52                	jle    80096e <getint+0x67>
		x=va_arg(*ap, long long);
  80091c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800920:	8b 00                	mov    (%rax),%eax
  800922:	83 f8 30             	cmp    $0x30,%eax
  800925:	73 24                	jae    80094b <getint+0x44>
  800927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80092f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800933:	8b 00                	mov    (%rax),%eax
  800935:	89 c0                	mov    %eax,%eax
  800937:	48 01 d0             	add    %rdx,%rax
  80093a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093e:	8b 12                	mov    (%rdx),%edx
  800940:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800943:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800947:	89 0a                	mov    %ecx,(%rdx)
  800949:	eb 17                	jmp    800962 <getint+0x5b>
  80094b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800953:	48 89 d0             	mov    %rdx,%rax
  800956:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80095a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800962:	48 8b 00             	mov    (%rax),%rax
  800965:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800969:	e9 a3 00 00 00       	jmpq   800a11 <getint+0x10a>
	else if (lflag)
  80096e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800972:	74 4f                	je     8009c3 <getint+0xbc>
		x=va_arg(*ap, long);
  800974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800978:	8b 00                	mov    (%rax),%eax
  80097a:	83 f8 30             	cmp    $0x30,%eax
  80097d:	73 24                	jae    8009a3 <getint+0x9c>
  80097f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800983:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098b:	8b 00                	mov    (%rax),%eax
  80098d:	89 c0                	mov    %eax,%eax
  80098f:	48 01 d0             	add    %rdx,%rax
  800992:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800996:	8b 12                	mov    (%rdx),%edx
  800998:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80099b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099f:	89 0a                	mov    %ecx,(%rdx)
  8009a1:	eb 17                	jmp    8009ba <getint+0xb3>
  8009a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ab:	48 89 d0             	mov    %rdx,%rax
  8009ae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ba:	48 8b 00             	mov    (%rax),%rax
  8009bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009c1:	eb 4e                	jmp    800a11 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c7:	8b 00                	mov    (%rax),%eax
  8009c9:	83 f8 30             	cmp    $0x30,%eax
  8009cc:	73 24                	jae    8009f2 <getint+0xeb>
  8009ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009da:	8b 00                	mov    (%rax),%eax
  8009dc:	89 c0                	mov    %eax,%eax
  8009de:	48 01 d0             	add    %rdx,%rax
  8009e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e5:	8b 12                	mov    (%rdx),%edx
  8009e7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ee:	89 0a                	mov    %ecx,(%rdx)
  8009f0:	eb 17                	jmp    800a09 <getint+0x102>
  8009f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009fa:	48 89 d0             	mov    %rdx,%rax
  8009fd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a01:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a05:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a09:	8b 00                	mov    (%rax),%eax
  800a0b:	48 98                	cltq   
  800a0d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a15:	c9                   	leaveq 
  800a16:	c3                   	retq   

0000000000800a17 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a17:	55                   	push   %rbp
  800a18:	48 89 e5             	mov    %rsp,%rbp
  800a1b:	41 54                	push   %r12
  800a1d:	53                   	push   %rbx
  800a1e:	48 83 ec 60          	sub    $0x60,%rsp
  800a22:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a26:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a2a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a2e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a32:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a36:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a3a:	48 8b 0a             	mov    (%rdx),%rcx
  800a3d:	48 89 08             	mov    %rcx,(%rax)
  800a40:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a44:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a48:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a4c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a50:	eb 28                	jmp    800a7a <vprintfmt+0x63>
			if (ch == '\0'){
  800a52:	85 db                	test   %ebx,%ebx
  800a54:	75 15                	jne    800a6b <vprintfmt+0x54>
				current_color=WHITE;
  800a56:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800a5d:	00 00 00 
  800a60:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800a66:	e9 fc 04 00 00       	jmpq   800f67 <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  800a6b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a73:	48 89 d6             	mov    %rdx,%rsi
  800a76:	89 df                	mov    %ebx,%edi
  800a78:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a7a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a7e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a82:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a86:	0f b6 00             	movzbl (%rax),%eax
  800a89:	0f b6 d8             	movzbl %al,%ebx
  800a8c:	83 fb 25             	cmp    $0x25,%ebx
  800a8f:	75 c1                	jne    800a52 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a91:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a95:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a9c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800aa3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800aaa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ab1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ab5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ab9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800abd:	0f b6 00             	movzbl (%rax),%eax
  800ac0:	0f b6 d8             	movzbl %al,%ebx
  800ac3:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ac6:	83 f8 55             	cmp    $0x55,%eax
  800ac9:	0f 87 64 04 00 00    	ja     800f33 <vprintfmt+0x51c>
  800acf:	89 c0                	mov    %eax,%eax
  800ad1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ad8:	00 
  800ad9:	48 b8 78 47 80 00 00 	movabs $0x804778,%rax
  800ae0:	00 00 00 
  800ae3:	48 01 d0             	add    %rdx,%rax
  800ae6:	48 8b 00             	mov    (%rax),%rax
  800ae9:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800aeb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800aef:	eb c0                	jmp    800ab1 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800af1:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800af5:	eb ba                	jmp    800ab1 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800afe:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b01:	89 d0                	mov    %edx,%eax
  800b03:	c1 e0 02             	shl    $0x2,%eax
  800b06:	01 d0                	add    %edx,%eax
  800b08:	01 c0                	add    %eax,%eax
  800b0a:	01 d8                	add    %ebx,%eax
  800b0c:	83 e8 30             	sub    $0x30,%eax
  800b0f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b12:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b16:	0f b6 00             	movzbl (%rax),%eax
  800b19:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b1c:	83 fb 2f             	cmp    $0x2f,%ebx
  800b1f:	7e 0c                	jle    800b2d <vprintfmt+0x116>
  800b21:	83 fb 39             	cmp    $0x39,%ebx
  800b24:	7f 07                	jg     800b2d <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b26:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b2b:	eb d1                	jmp    800afe <vprintfmt+0xe7>
			goto process_precision;
  800b2d:	eb 58                	jmp    800b87 <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800b2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b32:	83 f8 30             	cmp    $0x30,%eax
  800b35:	73 17                	jae    800b4e <vprintfmt+0x137>
  800b37:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3e:	89 c0                	mov    %eax,%eax
  800b40:	48 01 d0             	add    %rdx,%rax
  800b43:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b46:	83 c2 08             	add    $0x8,%edx
  800b49:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b4c:	eb 0f                	jmp    800b5d <vprintfmt+0x146>
  800b4e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b52:	48 89 d0             	mov    %rdx,%rax
  800b55:	48 83 c2 08          	add    $0x8,%rdx
  800b59:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b5d:	8b 00                	mov    (%rax),%eax
  800b5f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b62:	eb 23                	jmp    800b87 <vprintfmt+0x170>

		case '.':
			if (width < 0)
  800b64:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b68:	79 0c                	jns    800b76 <vprintfmt+0x15f>
				width = 0;
  800b6a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b71:	e9 3b ff ff ff       	jmpq   800ab1 <vprintfmt+0x9a>
  800b76:	e9 36 ff ff ff       	jmpq   800ab1 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  800b7b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b82:	e9 2a ff ff ff       	jmpq   800ab1 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  800b87:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b8b:	79 12                	jns    800b9f <vprintfmt+0x188>
				width = precision, precision = -1;
  800b8d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b90:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b93:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b9a:	e9 12 ff ff ff       	jmpq   800ab1 <vprintfmt+0x9a>
  800b9f:	e9 0d ff ff ff       	jmpq   800ab1 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ba4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ba8:	e9 04 ff ff ff       	jmpq   800ab1 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800bad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb0:	83 f8 30             	cmp    $0x30,%eax
  800bb3:	73 17                	jae    800bcc <vprintfmt+0x1b5>
  800bb5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bb9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbc:	89 c0                	mov    %eax,%eax
  800bbe:	48 01 d0             	add    %rdx,%rax
  800bc1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bc4:	83 c2 08             	add    $0x8,%edx
  800bc7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bca:	eb 0f                	jmp    800bdb <vprintfmt+0x1c4>
  800bcc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd0:	48 89 d0             	mov    %rdx,%rax
  800bd3:	48 83 c2 08          	add    $0x8,%rdx
  800bd7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bdb:	8b 10                	mov    (%rax),%edx
  800bdd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800be1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be5:	48 89 ce             	mov    %rcx,%rsi
  800be8:	89 d7                	mov    %edx,%edi
  800bea:	ff d0                	callq  *%rax
			break;
  800bec:	e9 70 03 00 00       	jmpq   800f61 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bf1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf4:	83 f8 30             	cmp    $0x30,%eax
  800bf7:	73 17                	jae    800c10 <vprintfmt+0x1f9>
  800bf9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bfd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c00:	89 c0                	mov    %eax,%eax
  800c02:	48 01 d0             	add    %rdx,%rax
  800c05:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c08:	83 c2 08             	add    $0x8,%edx
  800c0b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c0e:	eb 0f                	jmp    800c1f <vprintfmt+0x208>
  800c10:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c14:	48 89 d0             	mov    %rdx,%rax
  800c17:	48 83 c2 08          	add    $0x8,%rdx
  800c1b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c1f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c21:	85 db                	test   %ebx,%ebx
  800c23:	79 02                	jns    800c27 <vprintfmt+0x210>
				err = -err;
  800c25:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c27:	83 fb 15             	cmp    $0x15,%ebx
  800c2a:	7f 16                	jg     800c42 <vprintfmt+0x22b>
  800c2c:	48 b8 a0 46 80 00 00 	movabs $0x8046a0,%rax
  800c33:	00 00 00 
  800c36:	48 63 d3             	movslq %ebx,%rdx
  800c39:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c3d:	4d 85 e4             	test   %r12,%r12
  800c40:	75 2e                	jne    800c70 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  800c42:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4a:	89 d9                	mov    %ebx,%ecx
  800c4c:	48 ba 61 47 80 00 00 	movabs $0x804761,%rdx
  800c53:	00 00 00 
  800c56:	48 89 c7             	mov    %rax,%rdi
  800c59:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5e:	49 b8 70 0f 80 00 00 	movabs $0x800f70,%r8
  800c65:	00 00 00 
  800c68:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c6b:	e9 f1 02 00 00       	jmpq   800f61 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c70:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c78:	4c 89 e1             	mov    %r12,%rcx
  800c7b:	48 ba 6a 47 80 00 00 	movabs $0x80476a,%rdx
  800c82:	00 00 00 
  800c85:	48 89 c7             	mov    %rax,%rdi
  800c88:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8d:	49 b8 70 0f 80 00 00 	movabs $0x800f70,%r8
  800c94:	00 00 00 
  800c97:	41 ff d0             	callq  *%r8
			break;
  800c9a:	e9 c2 02 00 00       	jmpq   800f61 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca2:	83 f8 30             	cmp    $0x30,%eax
  800ca5:	73 17                	jae    800cbe <vprintfmt+0x2a7>
  800ca7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cae:	89 c0                	mov    %eax,%eax
  800cb0:	48 01 d0             	add    %rdx,%rax
  800cb3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb6:	83 c2 08             	add    $0x8,%edx
  800cb9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cbc:	eb 0f                	jmp    800ccd <vprintfmt+0x2b6>
  800cbe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc2:	48 89 d0             	mov    %rdx,%rax
  800cc5:	48 83 c2 08          	add    $0x8,%rdx
  800cc9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ccd:	4c 8b 20             	mov    (%rax),%r12
  800cd0:	4d 85 e4             	test   %r12,%r12
  800cd3:	75 0a                	jne    800cdf <vprintfmt+0x2c8>
				p = "(null)";
  800cd5:	49 bc 6d 47 80 00 00 	movabs $0x80476d,%r12
  800cdc:	00 00 00 
			if (width > 0 && padc != '-')
  800cdf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce3:	7e 3f                	jle    800d24 <vprintfmt+0x30d>
  800ce5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ce9:	74 39                	je     800d24 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ceb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cee:	48 98                	cltq   
  800cf0:	48 89 c6             	mov    %rax,%rsi
  800cf3:	4c 89 e7             	mov    %r12,%rdi
  800cf6:	48 b8 1c 12 80 00 00 	movabs $0x80121c,%rax
  800cfd:	00 00 00 
  800d00:	ff d0                	callq  *%rax
  800d02:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d05:	eb 17                	jmp    800d1e <vprintfmt+0x307>
					putch(padc, putdat);
  800d07:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d0b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d13:	48 89 ce             	mov    %rcx,%rsi
  800d16:	89 d7                	mov    %edx,%edi
  800d18:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d1e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d22:	7f e3                	jg     800d07 <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d24:	eb 37                	jmp    800d5d <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  800d26:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d2a:	74 1e                	je     800d4a <vprintfmt+0x333>
  800d2c:	83 fb 1f             	cmp    $0x1f,%ebx
  800d2f:	7e 05                	jle    800d36 <vprintfmt+0x31f>
  800d31:	83 fb 7e             	cmp    $0x7e,%ebx
  800d34:	7e 14                	jle    800d4a <vprintfmt+0x333>
					putch('?', putdat);
  800d36:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3e:	48 89 d6             	mov    %rdx,%rsi
  800d41:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d46:	ff d0                	callq  *%rax
  800d48:	eb 0f                	jmp    800d59 <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800d4a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d52:	48 89 d6             	mov    %rdx,%rsi
  800d55:	89 df                	mov    %ebx,%edi
  800d57:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d59:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d5d:	4c 89 e0             	mov    %r12,%rax
  800d60:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d64:	0f b6 00             	movzbl (%rax),%eax
  800d67:	0f be d8             	movsbl %al,%ebx
  800d6a:	85 db                	test   %ebx,%ebx
  800d6c:	74 10                	je     800d7e <vprintfmt+0x367>
  800d6e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d72:	78 b2                	js     800d26 <vprintfmt+0x30f>
  800d74:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d78:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d7c:	79 a8                	jns    800d26 <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d7e:	eb 16                	jmp    800d96 <vprintfmt+0x37f>
				putch(' ', putdat);
  800d80:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d84:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d88:	48 89 d6             	mov    %rdx,%rsi
  800d8b:	bf 20 00 00 00       	mov    $0x20,%edi
  800d90:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d92:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d96:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d9a:	7f e4                	jg     800d80 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800d9c:	e9 c0 01 00 00       	jmpq   800f61 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800da1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800da5:	be 03 00 00 00       	mov    $0x3,%esi
  800daa:	48 89 c7             	mov    %rax,%rdi
  800dad:	48 b8 07 09 80 00 00 	movabs $0x800907,%rax
  800db4:	00 00 00 
  800db7:	ff d0                	callq  *%rax
  800db9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800dbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc1:	48 85 c0             	test   %rax,%rax
  800dc4:	79 1d                	jns    800de3 <vprintfmt+0x3cc>
				putch('-', putdat);
  800dc6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dce:	48 89 d6             	mov    %rdx,%rsi
  800dd1:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dd6:	ff d0                	callq  *%rax
				num = -(long long) num;
  800dd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ddc:	48 f7 d8             	neg    %rax
  800ddf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800de3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dea:	e9 d5 00 00 00       	jmpq   800ec4 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800def:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800df3:	be 03 00 00 00       	mov    $0x3,%esi
  800df8:	48 89 c7             	mov    %rax,%rdi
  800dfb:	48 b8 f7 07 80 00 00 	movabs $0x8007f7,%rax
  800e02:	00 00 00 
  800e05:	ff d0                	callq  *%rax
  800e07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e0b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e12:	e9 ad 00 00 00       	jmpq   800ec4 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800e17:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e1b:	be 03 00 00 00       	mov    $0x3,%esi
  800e20:	48 89 c7             	mov    %rax,%rdi
  800e23:	48 b8 f7 07 80 00 00 	movabs $0x8007f7,%rax
  800e2a:	00 00 00 
  800e2d:	ff d0                	callq  *%rax
  800e2f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800e33:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e3a:	e9 85 00 00 00       	jmpq   800ec4 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800e3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e47:	48 89 d6             	mov    %rdx,%rsi
  800e4a:	bf 30 00 00 00       	mov    $0x30,%edi
  800e4f:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e59:	48 89 d6             	mov    %rdx,%rsi
  800e5c:	bf 78 00 00 00       	mov    $0x78,%edi
  800e61:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e66:	83 f8 30             	cmp    $0x30,%eax
  800e69:	73 17                	jae    800e82 <vprintfmt+0x46b>
  800e6b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e72:	89 c0                	mov    %eax,%eax
  800e74:	48 01 d0             	add    %rdx,%rax
  800e77:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e7a:	83 c2 08             	add    $0x8,%edx
  800e7d:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e80:	eb 0f                	jmp    800e91 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  800e82:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e86:	48 89 d0             	mov    %rdx,%rax
  800e89:	48 83 c2 08          	add    $0x8,%rdx
  800e8d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e91:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e94:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e98:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e9f:	eb 23                	jmp    800ec4 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ea1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea5:	be 03 00 00 00       	mov    $0x3,%esi
  800eaa:	48 89 c7             	mov    %rax,%rdi
  800ead:	48 b8 f7 07 80 00 00 	movabs $0x8007f7,%rax
  800eb4:	00 00 00 
  800eb7:	ff d0                	callq  *%rax
  800eb9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ebd:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ec4:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ec9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ecc:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ecf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ed3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ed7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800edb:	45 89 c1             	mov    %r8d,%r9d
  800ede:	41 89 f8             	mov    %edi,%r8d
  800ee1:	48 89 c7             	mov    %rax,%rdi
  800ee4:	48 b8 3c 07 80 00 00 	movabs $0x80073c,%rax
  800eeb:	00 00 00 
  800eee:	ff d0                	callq  *%rax
			break;
  800ef0:	eb 6f                	jmp    800f61 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efa:	48 89 d6             	mov    %rdx,%rsi
  800efd:	89 df                	mov    %ebx,%edi
  800eff:	ff d0                	callq  *%rax
			break;
  800f01:	eb 5e                	jmp    800f61 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  800f03:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f07:	be 03 00 00 00       	mov    $0x3,%esi
  800f0c:	48 89 c7             	mov    %rax,%rdi
  800f0f:	48 b8 f7 07 80 00 00 	movabs $0x8007f7,%rax
  800f16:	00 00 00 
  800f19:	ff d0                	callq  *%rax
  800f1b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  800f1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f23:	89 c2                	mov    %eax,%edx
  800f25:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800f2c:	00 00 00 
  800f2f:	89 10                	mov    %edx,(%rax)
			break;
  800f31:	eb 2e                	jmp    800f61 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f3b:	48 89 d6             	mov    %rdx,%rsi
  800f3e:	bf 25 00 00 00       	mov    $0x25,%edi
  800f43:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f45:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f4a:	eb 05                	jmp    800f51 <vprintfmt+0x53a>
  800f4c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f51:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f55:	48 83 e8 01          	sub    $0x1,%rax
  800f59:	0f b6 00             	movzbl (%rax),%eax
  800f5c:	3c 25                	cmp    $0x25,%al
  800f5e:	75 ec                	jne    800f4c <vprintfmt+0x535>
				/* do nothing */;
			break;
  800f60:	90                   	nop
		}
	}
  800f61:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f62:	e9 13 fb ff ff       	jmpq   800a7a <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f67:	48 83 c4 60          	add    $0x60,%rsp
  800f6b:	5b                   	pop    %rbx
  800f6c:	41 5c                	pop    %r12
  800f6e:	5d                   	pop    %rbp
  800f6f:	c3                   	retq   

0000000000800f70 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f70:	55                   	push   %rbp
  800f71:	48 89 e5             	mov    %rsp,%rbp
  800f74:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f7b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f82:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f89:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f90:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f97:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f9e:	84 c0                	test   %al,%al
  800fa0:	74 20                	je     800fc2 <printfmt+0x52>
  800fa2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fa6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800faa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fae:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fb2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fb6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fba:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fbe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fc2:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800fc9:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800fd0:	00 00 00 
  800fd3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800fda:	00 00 00 
  800fdd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fe1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fe8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fef:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ff6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ffd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801004:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80100b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801012:	48 89 c7             	mov    %rax,%rdi
  801015:	48 b8 17 0a 80 00 00 	movabs $0x800a17,%rax
  80101c:	00 00 00 
  80101f:	ff d0                	callq  *%rax
	va_end(ap);
}
  801021:	c9                   	leaveq 
  801022:	c3                   	retq   

0000000000801023 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801023:	55                   	push   %rbp
  801024:	48 89 e5             	mov    %rsp,%rbp
  801027:	48 83 ec 10          	sub    $0x10,%rsp
  80102b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80102e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801032:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801036:	8b 40 10             	mov    0x10(%rax),%eax
  801039:	8d 50 01             	lea    0x1(%rax),%edx
  80103c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801040:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801043:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801047:	48 8b 10             	mov    (%rax),%rdx
  80104a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80104e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801052:	48 39 c2             	cmp    %rax,%rdx
  801055:	73 17                	jae    80106e <sprintputch+0x4b>
		*b->buf++ = ch;
  801057:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80105b:	48 8b 00             	mov    (%rax),%rax
  80105e:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801062:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801066:	48 89 0a             	mov    %rcx,(%rdx)
  801069:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80106c:	88 10                	mov    %dl,(%rax)
}
  80106e:	c9                   	leaveq 
  80106f:	c3                   	retq   

0000000000801070 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801070:	55                   	push   %rbp
  801071:	48 89 e5             	mov    %rsp,%rbp
  801074:	48 83 ec 50          	sub    $0x50,%rsp
  801078:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80107c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80107f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801083:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801087:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80108b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80108f:	48 8b 0a             	mov    (%rdx),%rcx
  801092:	48 89 08             	mov    %rcx,(%rax)
  801095:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801099:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80109d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010a1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010a5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010a9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8010ad:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8010b0:	48 98                	cltq   
  8010b2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8010b6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010ba:	48 01 d0             	add    %rdx,%rax
  8010bd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8010c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8010c8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8010cd:	74 06                	je     8010d5 <vsnprintf+0x65>
  8010cf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010d3:	7f 07                	jg     8010dc <vsnprintf+0x6c>
		return -E_INVAL;
  8010d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010da:	eb 2f                	jmp    80110b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8010dc:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8010e0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010e4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010e8:	48 89 c6             	mov    %rax,%rsi
  8010eb:	48 bf 23 10 80 00 00 	movabs $0x801023,%rdi
  8010f2:	00 00 00 
  8010f5:	48 b8 17 0a 80 00 00 	movabs $0x800a17,%rax
  8010fc:	00 00 00 
  8010ff:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801101:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801105:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801108:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80110b:	c9                   	leaveq 
  80110c:	c3                   	retq   

000000000080110d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80110d:	55                   	push   %rbp
  80110e:	48 89 e5             	mov    %rsp,%rbp
  801111:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801118:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80111f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801125:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80112c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801133:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80113a:	84 c0                	test   %al,%al
  80113c:	74 20                	je     80115e <snprintf+0x51>
  80113e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801142:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801146:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80114a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80114e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801152:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801156:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80115a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80115e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801165:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80116c:	00 00 00 
  80116f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801176:	00 00 00 
  801179:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80117d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801184:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80118b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801192:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801199:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8011a0:	48 8b 0a             	mov    (%rdx),%rcx
  8011a3:	48 89 08             	mov    %rcx,(%rax)
  8011a6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011aa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011ae:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011b2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8011b6:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8011bd:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8011c4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8011ca:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8011d1:	48 89 c7             	mov    %rax,%rdi
  8011d4:	48 b8 70 10 80 00 00 	movabs $0x801070,%rax
  8011db:	00 00 00 
  8011de:	ff d0                	callq  *%rax
  8011e0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011e6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011ec:	c9                   	leaveq 
  8011ed:	c3                   	retq   

00000000008011ee <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011ee:	55                   	push   %rbp
  8011ef:	48 89 e5             	mov    %rsp,%rbp
  8011f2:	48 83 ec 18          	sub    $0x18,%rsp
  8011f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801201:	eb 09                	jmp    80120c <strlen+0x1e>
		n++;
  801203:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801207:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80120c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801210:	0f b6 00             	movzbl (%rax),%eax
  801213:	84 c0                	test   %al,%al
  801215:	75 ec                	jne    801203 <strlen+0x15>
		n++;
	return n;
  801217:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80121a:	c9                   	leaveq 
  80121b:	c3                   	retq   

000000000080121c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80121c:	55                   	push   %rbp
  80121d:	48 89 e5             	mov    %rsp,%rbp
  801220:	48 83 ec 20          	sub    $0x20,%rsp
  801224:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801228:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80122c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801233:	eb 0e                	jmp    801243 <strnlen+0x27>
		n++;
  801235:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801239:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80123e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801243:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801248:	74 0b                	je     801255 <strnlen+0x39>
  80124a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124e:	0f b6 00             	movzbl (%rax),%eax
  801251:	84 c0                	test   %al,%al
  801253:	75 e0                	jne    801235 <strnlen+0x19>
		n++;
	return n;
  801255:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801258:	c9                   	leaveq 
  801259:	c3                   	retq   

000000000080125a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80125a:	55                   	push   %rbp
  80125b:	48 89 e5             	mov    %rsp,%rbp
  80125e:	48 83 ec 20          	sub    $0x20,%rsp
  801262:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801266:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80126a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801272:	90                   	nop
  801273:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801277:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80127b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80127f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801283:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801287:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80128b:	0f b6 12             	movzbl (%rdx),%edx
  80128e:	88 10                	mov    %dl,(%rax)
  801290:	0f b6 00             	movzbl (%rax),%eax
  801293:	84 c0                	test   %al,%al
  801295:	75 dc                	jne    801273 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801297:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80129b:	c9                   	leaveq 
  80129c:	c3                   	retq   

000000000080129d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80129d:	55                   	push   %rbp
  80129e:	48 89 e5             	mov    %rsp,%rbp
  8012a1:	48 83 ec 20          	sub    $0x20,%rsp
  8012a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8012ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b1:	48 89 c7             	mov    %rax,%rdi
  8012b4:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  8012bb:	00 00 00 
  8012be:	ff d0                	callq  *%rax
  8012c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8012c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012c6:	48 63 d0             	movslq %eax,%rdx
  8012c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cd:	48 01 c2             	add    %rax,%rdx
  8012d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012d4:	48 89 c6             	mov    %rax,%rsi
  8012d7:	48 89 d7             	mov    %rdx,%rdi
  8012da:	48 b8 5a 12 80 00 00 	movabs $0x80125a,%rax
  8012e1:	00 00 00 
  8012e4:	ff d0                	callq  *%rax
	return dst;
  8012e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012ea:	c9                   	leaveq 
  8012eb:	c3                   	retq   

00000000008012ec <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012ec:	55                   	push   %rbp
  8012ed:	48 89 e5             	mov    %rsp,%rbp
  8012f0:	48 83 ec 28          	sub    $0x28,%rsp
  8012f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801300:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801304:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801308:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80130f:	00 
  801310:	eb 2a                	jmp    80133c <strncpy+0x50>
		*dst++ = *src;
  801312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801316:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80131a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80131e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801322:	0f b6 12             	movzbl (%rdx),%edx
  801325:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801327:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80132b:	0f b6 00             	movzbl (%rax),%eax
  80132e:	84 c0                	test   %al,%al
  801330:	74 05                	je     801337 <strncpy+0x4b>
			src++;
  801332:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801337:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80133c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801340:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801344:	72 cc                	jb     801312 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801346:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80134a:	c9                   	leaveq 
  80134b:	c3                   	retq   

000000000080134c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80134c:	55                   	push   %rbp
  80134d:	48 89 e5             	mov    %rsp,%rbp
  801350:	48 83 ec 28          	sub    $0x28,%rsp
  801354:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801358:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80135c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801364:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801368:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80136d:	74 3d                	je     8013ac <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80136f:	eb 1d                	jmp    80138e <strlcpy+0x42>
			*dst++ = *src++;
  801371:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801375:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801379:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80137d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801381:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801385:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801389:	0f b6 12             	movzbl (%rdx),%edx
  80138c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80138e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801393:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801398:	74 0b                	je     8013a5 <strlcpy+0x59>
  80139a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80139e:	0f b6 00             	movzbl (%rax),%eax
  8013a1:	84 c0                	test   %al,%al
  8013a3:	75 cc                	jne    801371 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8013a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8013ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b4:	48 29 c2             	sub    %rax,%rdx
  8013b7:	48 89 d0             	mov    %rdx,%rax
}
  8013ba:	c9                   	leaveq 
  8013bb:	c3                   	retq   

00000000008013bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013bc:	55                   	push   %rbp
  8013bd:	48 89 e5             	mov    %rsp,%rbp
  8013c0:	48 83 ec 10          	sub    $0x10,%rsp
  8013c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8013cc:	eb 0a                	jmp    8013d8 <strcmp+0x1c>
		p++, q++;
  8013ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013d3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013dc:	0f b6 00             	movzbl (%rax),%eax
  8013df:	84 c0                	test   %al,%al
  8013e1:	74 12                	je     8013f5 <strcmp+0x39>
  8013e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e7:	0f b6 10             	movzbl (%rax),%edx
  8013ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ee:	0f b6 00             	movzbl (%rax),%eax
  8013f1:	38 c2                	cmp    %al,%dl
  8013f3:	74 d9                	je     8013ce <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f9:	0f b6 00             	movzbl (%rax),%eax
  8013fc:	0f b6 d0             	movzbl %al,%edx
  8013ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801403:	0f b6 00             	movzbl (%rax),%eax
  801406:	0f b6 c0             	movzbl %al,%eax
  801409:	29 c2                	sub    %eax,%edx
  80140b:	89 d0                	mov    %edx,%eax
}
  80140d:	c9                   	leaveq 
  80140e:	c3                   	retq   

000000000080140f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80140f:	55                   	push   %rbp
  801410:	48 89 e5             	mov    %rsp,%rbp
  801413:	48 83 ec 18          	sub    $0x18,%rsp
  801417:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80141b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80141f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801423:	eb 0f                	jmp    801434 <strncmp+0x25>
		n--, p++, q++;
  801425:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80142a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80142f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801434:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801439:	74 1d                	je     801458 <strncmp+0x49>
  80143b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143f:	0f b6 00             	movzbl (%rax),%eax
  801442:	84 c0                	test   %al,%al
  801444:	74 12                	je     801458 <strncmp+0x49>
  801446:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144a:	0f b6 10             	movzbl (%rax),%edx
  80144d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801451:	0f b6 00             	movzbl (%rax),%eax
  801454:	38 c2                	cmp    %al,%dl
  801456:	74 cd                	je     801425 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801458:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80145d:	75 07                	jne    801466 <strncmp+0x57>
		return 0;
  80145f:	b8 00 00 00 00       	mov    $0x0,%eax
  801464:	eb 18                	jmp    80147e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146a:	0f b6 00             	movzbl (%rax),%eax
  80146d:	0f b6 d0             	movzbl %al,%edx
  801470:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801474:	0f b6 00             	movzbl (%rax),%eax
  801477:	0f b6 c0             	movzbl %al,%eax
  80147a:	29 c2                	sub    %eax,%edx
  80147c:	89 d0                	mov    %edx,%eax
}
  80147e:	c9                   	leaveq 
  80147f:	c3                   	retq   

0000000000801480 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801480:	55                   	push   %rbp
  801481:	48 89 e5             	mov    %rsp,%rbp
  801484:	48 83 ec 0c          	sub    $0xc,%rsp
  801488:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80148c:	89 f0                	mov    %esi,%eax
  80148e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801491:	eb 17                	jmp    8014aa <strchr+0x2a>
		if (*s == c)
  801493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801497:	0f b6 00             	movzbl (%rax),%eax
  80149a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80149d:	75 06                	jne    8014a5 <strchr+0x25>
			return (char *) s;
  80149f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a3:	eb 15                	jmp    8014ba <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014a5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ae:	0f b6 00             	movzbl (%rax),%eax
  8014b1:	84 c0                	test   %al,%al
  8014b3:	75 de                	jne    801493 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8014b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ba:	c9                   	leaveq 
  8014bb:	c3                   	retq   

00000000008014bc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014bc:	55                   	push   %rbp
  8014bd:	48 89 e5             	mov    %rsp,%rbp
  8014c0:	48 83 ec 0c          	sub    $0xc,%rsp
  8014c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014c8:	89 f0                	mov    %esi,%eax
  8014ca:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014cd:	eb 13                	jmp    8014e2 <strfind+0x26>
		if (*s == c)
  8014cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d3:	0f b6 00             	movzbl (%rax),%eax
  8014d6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014d9:	75 02                	jne    8014dd <strfind+0x21>
			break;
  8014db:	eb 10                	jmp    8014ed <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014dd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e6:	0f b6 00             	movzbl (%rax),%eax
  8014e9:	84 c0                	test   %al,%al
  8014eb:	75 e2                	jne    8014cf <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014f1:	c9                   	leaveq 
  8014f2:	c3                   	retq   

00000000008014f3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014f3:	55                   	push   %rbp
  8014f4:	48 89 e5             	mov    %rsp,%rbp
  8014f7:	48 83 ec 18          	sub    $0x18,%rsp
  8014fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014ff:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801502:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801506:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80150b:	75 06                	jne    801513 <memset+0x20>
		return v;
  80150d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801511:	eb 69                	jmp    80157c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801513:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801517:	83 e0 03             	and    $0x3,%eax
  80151a:	48 85 c0             	test   %rax,%rax
  80151d:	75 48                	jne    801567 <memset+0x74>
  80151f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801523:	83 e0 03             	and    $0x3,%eax
  801526:	48 85 c0             	test   %rax,%rax
  801529:	75 3c                	jne    801567 <memset+0x74>
		c &= 0xFF;
  80152b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801532:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801535:	c1 e0 18             	shl    $0x18,%eax
  801538:	89 c2                	mov    %eax,%edx
  80153a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80153d:	c1 e0 10             	shl    $0x10,%eax
  801540:	09 c2                	or     %eax,%edx
  801542:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801545:	c1 e0 08             	shl    $0x8,%eax
  801548:	09 d0                	or     %edx,%eax
  80154a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80154d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801551:	48 c1 e8 02          	shr    $0x2,%rax
  801555:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801558:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80155c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80155f:	48 89 d7             	mov    %rdx,%rdi
  801562:	fc                   	cld    
  801563:	f3 ab                	rep stos %eax,%es:(%rdi)
  801565:	eb 11                	jmp    801578 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801567:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80156b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80156e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801572:	48 89 d7             	mov    %rdx,%rdi
  801575:	fc                   	cld    
  801576:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801578:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80157c:	c9                   	leaveq 
  80157d:	c3                   	retq   

000000000080157e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80157e:	55                   	push   %rbp
  80157f:	48 89 e5             	mov    %rsp,%rbp
  801582:	48 83 ec 28          	sub    $0x28,%rsp
  801586:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80158a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80158e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801592:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801596:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80159a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80159e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8015a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015aa:	0f 83 88 00 00 00    	jae    801638 <memmove+0xba>
  8015b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015b8:	48 01 d0             	add    %rdx,%rax
  8015bb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015bf:	76 77                	jbe    801638 <memmove+0xba>
		s += n;
  8015c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8015c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d5:	83 e0 03             	and    $0x3,%eax
  8015d8:	48 85 c0             	test   %rax,%rax
  8015db:	75 3b                	jne    801618 <memmove+0x9a>
  8015dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e1:	83 e0 03             	and    $0x3,%eax
  8015e4:	48 85 c0             	test   %rax,%rax
  8015e7:	75 2f                	jne    801618 <memmove+0x9a>
  8015e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ed:	83 e0 03             	and    $0x3,%eax
  8015f0:	48 85 c0             	test   %rax,%rax
  8015f3:	75 23                	jne    801618 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f9:	48 83 e8 04          	sub    $0x4,%rax
  8015fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801601:	48 83 ea 04          	sub    $0x4,%rdx
  801605:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801609:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80160d:	48 89 c7             	mov    %rax,%rdi
  801610:	48 89 d6             	mov    %rdx,%rsi
  801613:	fd                   	std    
  801614:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801616:	eb 1d                	jmp    801635 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801618:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801620:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801624:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801628:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162c:	48 89 d7             	mov    %rdx,%rdi
  80162f:	48 89 c1             	mov    %rax,%rcx
  801632:	fd                   	std    
  801633:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801635:	fc                   	cld    
  801636:	eb 57                	jmp    80168f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801638:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80163c:	83 e0 03             	and    $0x3,%eax
  80163f:	48 85 c0             	test   %rax,%rax
  801642:	75 36                	jne    80167a <memmove+0xfc>
  801644:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801648:	83 e0 03             	and    $0x3,%eax
  80164b:	48 85 c0             	test   %rax,%rax
  80164e:	75 2a                	jne    80167a <memmove+0xfc>
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	83 e0 03             	and    $0x3,%eax
  801657:	48 85 c0             	test   %rax,%rax
  80165a:	75 1e                	jne    80167a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80165c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801660:	48 c1 e8 02          	shr    $0x2,%rax
  801664:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801667:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80166f:	48 89 c7             	mov    %rax,%rdi
  801672:	48 89 d6             	mov    %rdx,%rsi
  801675:	fc                   	cld    
  801676:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801678:	eb 15                	jmp    80168f <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80167a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801682:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801686:	48 89 c7             	mov    %rax,%rdi
  801689:	48 89 d6             	mov    %rdx,%rsi
  80168c:	fc                   	cld    
  80168d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80168f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801693:	c9                   	leaveq 
  801694:	c3                   	retq   

0000000000801695 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801695:	55                   	push   %rbp
  801696:	48 89 e5             	mov    %rsp,%rbp
  801699:	48 83 ec 18          	sub    $0x18,%rsp
  80169d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8016a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ad:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b5:	48 89 ce             	mov    %rcx,%rsi
  8016b8:	48 89 c7             	mov    %rax,%rdi
  8016bb:	48 b8 7e 15 80 00 00 	movabs $0x80157e,%rax
  8016c2:	00 00 00 
  8016c5:	ff d0                	callq  *%rax
}
  8016c7:	c9                   	leaveq 
  8016c8:	c3                   	retq   

00000000008016c9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8016c9:	55                   	push   %rbp
  8016ca:	48 89 e5             	mov    %rsp,%rbp
  8016cd:	48 83 ec 28          	sub    $0x28,%rsp
  8016d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8016dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016ed:	eb 36                	jmp    801725 <memcmp+0x5c>
		if (*s1 != *s2)
  8016ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f3:	0f b6 10             	movzbl (%rax),%edx
  8016f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fa:	0f b6 00             	movzbl (%rax),%eax
  8016fd:	38 c2                	cmp    %al,%dl
  8016ff:	74 1a                	je     80171b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801701:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801705:	0f b6 00             	movzbl (%rax),%eax
  801708:	0f b6 d0             	movzbl %al,%edx
  80170b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170f:	0f b6 00             	movzbl (%rax),%eax
  801712:	0f b6 c0             	movzbl %al,%eax
  801715:	29 c2                	sub    %eax,%edx
  801717:	89 d0                	mov    %edx,%eax
  801719:	eb 20                	jmp    80173b <memcmp+0x72>
		s1++, s2++;
  80171b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801720:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801729:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80172d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801731:	48 85 c0             	test   %rax,%rax
  801734:	75 b9                	jne    8016ef <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801736:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173b:	c9                   	leaveq 
  80173c:	c3                   	retq   

000000000080173d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80173d:	55                   	push   %rbp
  80173e:	48 89 e5             	mov    %rsp,%rbp
  801741:	48 83 ec 28          	sub    $0x28,%rsp
  801745:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801749:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80174c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801750:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801754:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801758:	48 01 d0             	add    %rdx,%rax
  80175b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80175f:	eb 15                	jmp    801776 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801765:	0f b6 10             	movzbl (%rax),%edx
  801768:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80176b:	38 c2                	cmp    %al,%dl
  80176d:	75 02                	jne    801771 <memfind+0x34>
			break;
  80176f:	eb 0f                	jmp    801780 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801771:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801776:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80177e:	72 e1                	jb     801761 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801784:	c9                   	leaveq 
  801785:	c3                   	retq   

0000000000801786 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801786:	55                   	push   %rbp
  801787:	48 89 e5             	mov    %rsp,%rbp
  80178a:	48 83 ec 34          	sub    $0x34,%rsp
  80178e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801792:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801796:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801799:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8017a0:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8017a7:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017a8:	eb 05                	jmp    8017af <strtol+0x29>
		s++;
  8017aa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b3:	0f b6 00             	movzbl (%rax),%eax
  8017b6:	3c 20                	cmp    $0x20,%al
  8017b8:	74 f0                	je     8017aa <strtol+0x24>
  8017ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017be:	0f b6 00             	movzbl (%rax),%eax
  8017c1:	3c 09                	cmp    $0x9,%al
  8017c3:	74 e5                	je     8017aa <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c9:	0f b6 00             	movzbl (%rax),%eax
  8017cc:	3c 2b                	cmp    $0x2b,%al
  8017ce:	75 07                	jne    8017d7 <strtol+0x51>
		s++;
  8017d0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017d5:	eb 17                	jmp    8017ee <strtol+0x68>
	else if (*s == '-')
  8017d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017db:	0f b6 00             	movzbl (%rax),%eax
  8017de:	3c 2d                	cmp    $0x2d,%al
  8017e0:	75 0c                	jne    8017ee <strtol+0x68>
		s++, neg = 1;
  8017e2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017ee:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017f2:	74 06                	je     8017fa <strtol+0x74>
  8017f4:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017f8:	75 28                	jne    801822 <strtol+0x9c>
  8017fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fe:	0f b6 00             	movzbl (%rax),%eax
  801801:	3c 30                	cmp    $0x30,%al
  801803:	75 1d                	jne    801822 <strtol+0x9c>
  801805:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801809:	48 83 c0 01          	add    $0x1,%rax
  80180d:	0f b6 00             	movzbl (%rax),%eax
  801810:	3c 78                	cmp    $0x78,%al
  801812:	75 0e                	jne    801822 <strtol+0x9c>
		s += 2, base = 16;
  801814:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801819:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801820:	eb 2c                	jmp    80184e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801822:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801826:	75 19                	jne    801841 <strtol+0xbb>
  801828:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182c:	0f b6 00             	movzbl (%rax),%eax
  80182f:	3c 30                	cmp    $0x30,%al
  801831:	75 0e                	jne    801841 <strtol+0xbb>
		s++, base = 8;
  801833:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801838:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80183f:	eb 0d                	jmp    80184e <strtol+0xc8>
	else if (base == 0)
  801841:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801845:	75 07                	jne    80184e <strtol+0xc8>
		base = 10;
  801847:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80184e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801852:	0f b6 00             	movzbl (%rax),%eax
  801855:	3c 2f                	cmp    $0x2f,%al
  801857:	7e 1d                	jle    801876 <strtol+0xf0>
  801859:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185d:	0f b6 00             	movzbl (%rax),%eax
  801860:	3c 39                	cmp    $0x39,%al
  801862:	7f 12                	jg     801876 <strtol+0xf0>
			dig = *s - '0';
  801864:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801868:	0f b6 00             	movzbl (%rax),%eax
  80186b:	0f be c0             	movsbl %al,%eax
  80186e:	83 e8 30             	sub    $0x30,%eax
  801871:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801874:	eb 4e                	jmp    8018c4 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801876:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187a:	0f b6 00             	movzbl (%rax),%eax
  80187d:	3c 60                	cmp    $0x60,%al
  80187f:	7e 1d                	jle    80189e <strtol+0x118>
  801881:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801885:	0f b6 00             	movzbl (%rax),%eax
  801888:	3c 7a                	cmp    $0x7a,%al
  80188a:	7f 12                	jg     80189e <strtol+0x118>
			dig = *s - 'a' + 10;
  80188c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801890:	0f b6 00             	movzbl (%rax),%eax
  801893:	0f be c0             	movsbl %al,%eax
  801896:	83 e8 57             	sub    $0x57,%eax
  801899:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80189c:	eb 26                	jmp    8018c4 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80189e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a2:	0f b6 00             	movzbl (%rax),%eax
  8018a5:	3c 40                	cmp    $0x40,%al
  8018a7:	7e 48                	jle    8018f1 <strtol+0x16b>
  8018a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ad:	0f b6 00             	movzbl (%rax),%eax
  8018b0:	3c 5a                	cmp    $0x5a,%al
  8018b2:	7f 3d                	jg     8018f1 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8018b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b8:	0f b6 00             	movzbl (%rax),%eax
  8018bb:	0f be c0             	movsbl %al,%eax
  8018be:	83 e8 37             	sub    $0x37,%eax
  8018c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8018c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018c7:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8018ca:	7c 02                	jl     8018ce <strtol+0x148>
			break;
  8018cc:	eb 23                	jmp    8018f1 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8018ce:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018d3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8018d6:	48 98                	cltq   
  8018d8:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8018dd:	48 89 c2             	mov    %rax,%rdx
  8018e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018e3:	48 98                	cltq   
  8018e5:	48 01 d0             	add    %rdx,%rax
  8018e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018ec:	e9 5d ff ff ff       	jmpq   80184e <strtol+0xc8>

	if (endptr)
  8018f1:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018f6:	74 0b                	je     801903 <strtol+0x17d>
		*endptr = (char *) s;
  8018f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018fc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801900:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801903:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801907:	74 09                	je     801912 <strtol+0x18c>
  801909:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80190d:	48 f7 d8             	neg    %rax
  801910:	eb 04                	jmp    801916 <strtol+0x190>
  801912:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801916:	c9                   	leaveq 
  801917:	c3                   	retq   

0000000000801918 <strstr>:

char * strstr(const char *in, const char *str)
{
  801918:	55                   	push   %rbp
  801919:	48 89 e5             	mov    %rsp,%rbp
  80191c:	48 83 ec 30          	sub    $0x30,%rsp
  801920:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801924:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801928:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80192c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801930:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801934:	0f b6 00             	movzbl (%rax),%eax
  801937:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80193a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80193e:	75 06                	jne    801946 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801940:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801944:	eb 6b                	jmp    8019b1 <strstr+0x99>

	len = strlen(str);
  801946:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80194a:	48 89 c7             	mov    %rax,%rdi
  80194d:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  801954:	00 00 00 
  801957:	ff d0                	callq  *%rax
  801959:	48 98                	cltq   
  80195b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80195f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801963:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801967:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80196b:	0f b6 00             	movzbl (%rax),%eax
  80196e:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801971:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801975:	75 07                	jne    80197e <strstr+0x66>
				return (char *) 0;
  801977:	b8 00 00 00 00       	mov    $0x0,%eax
  80197c:	eb 33                	jmp    8019b1 <strstr+0x99>
		} while (sc != c);
  80197e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801982:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801985:	75 d8                	jne    80195f <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801987:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80198b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80198f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801993:	48 89 ce             	mov    %rcx,%rsi
  801996:	48 89 c7             	mov    %rax,%rdi
  801999:	48 b8 0f 14 80 00 00 	movabs $0x80140f,%rax
  8019a0:	00 00 00 
  8019a3:	ff d0                	callq  *%rax
  8019a5:	85 c0                	test   %eax,%eax
  8019a7:	75 b6                	jne    80195f <strstr+0x47>

	return (char *) (in - 1);
  8019a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ad:	48 83 e8 01          	sub    $0x1,%rax
}
  8019b1:	c9                   	leaveq 
  8019b2:	c3                   	retq   

00000000008019b3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8019b3:	55                   	push   %rbp
  8019b4:	48 89 e5             	mov    %rsp,%rbp
  8019b7:	53                   	push   %rbx
  8019b8:	48 83 ec 48          	sub    $0x48,%rsp
  8019bc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8019bf:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8019c2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019c6:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8019ca:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8019ce:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019d2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019d5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8019d9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8019dd:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019e1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019e5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019e9:	4c 89 c3             	mov    %r8,%rbx
  8019ec:	cd 30                	int    $0x30
  8019ee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019f2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019f6:	74 3e                	je     801a36 <syscall+0x83>
  8019f8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019fd:	7e 37                	jle    801a36 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a03:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a06:	49 89 d0             	mov    %rdx,%r8
  801a09:	89 c1                	mov    %eax,%ecx
  801a0b:	48 ba 28 4a 80 00 00 	movabs $0x804a28,%rdx
  801a12:	00 00 00 
  801a15:	be 23 00 00 00       	mov    $0x23,%esi
  801a1a:	48 bf 45 4a 80 00 00 	movabs $0x804a45,%rdi
  801a21:	00 00 00 
  801a24:	b8 00 00 00 00       	mov    $0x0,%eax
  801a29:	49 b9 2b 04 80 00 00 	movabs $0x80042b,%r9
  801a30:	00 00 00 
  801a33:	41 ff d1             	callq  *%r9

	return ret;
  801a36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a3a:	48 83 c4 48          	add    $0x48,%rsp
  801a3e:	5b                   	pop    %rbx
  801a3f:	5d                   	pop    %rbp
  801a40:	c3                   	retq   

0000000000801a41 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a41:	55                   	push   %rbp
  801a42:	48 89 e5             	mov    %rsp,%rbp
  801a45:	48 83 ec 20          	sub    $0x20,%rsp
  801a49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a59:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a60:	00 
  801a61:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a67:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6d:	48 89 d1             	mov    %rdx,%rcx
  801a70:	48 89 c2             	mov    %rax,%rdx
  801a73:	be 00 00 00 00       	mov    $0x0,%esi
  801a78:	bf 00 00 00 00       	mov    $0x0,%edi
  801a7d:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801a84:	00 00 00 
  801a87:	ff d0                	callq  *%rax
}
  801a89:	c9                   	leaveq 
  801a8a:	c3                   	retq   

0000000000801a8b <sys_cgetc>:

int
sys_cgetc(void)
{
  801a8b:	55                   	push   %rbp
  801a8c:	48 89 e5             	mov    %rsp,%rbp
  801a8f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a93:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9a:	00 
  801a9b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aac:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab1:	be 00 00 00 00       	mov    $0x0,%esi
  801ab6:	bf 01 00 00 00       	mov    $0x1,%edi
  801abb:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801ac2:	00 00 00 
  801ac5:	ff d0                	callq  *%rax
}
  801ac7:	c9                   	leaveq 
  801ac8:	c3                   	retq   

0000000000801ac9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801ac9:	55                   	push   %rbp
  801aca:	48 89 e5             	mov    %rsp,%rbp
  801acd:	48 83 ec 10          	sub    $0x10,%rsp
  801ad1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801ad4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad7:	48 98                	cltq   
  801ad9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae0:	00 
  801ae1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aed:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af2:	48 89 c2             	mov    %rax,%rdx
  801af5:	be 01 00 00 00       	mov    $0x1,%esi
  801afa:	bf 03 00 00 00       	mov    $0x3,%edi
  801aff:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801b06:	00 00 00 
  801b09:	ff d0                	callq  *%rax
}
  801b0b:	c9                   	leaveq 
  801b0c:	c3                   	retq   

0000000000801b0d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b0d:	55                   	push   %rbp
  801b0e:	48 89 e5             	mov    %rsp,%rbp
  801b11:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b15:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b1c:	00 
  801b1d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b23:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b29:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b33:	be 00 00 00 00       	mov    $0x0,%esi
  801b38:	bf 02 00 00 00       	mov    $0x2,%edi
  801b3d:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801b44:	00 00 00 
  801b47:	ff d0                	callq  *%rax
}
  801b49:	c9                   	leaveq 
  801b4a:	c3                   	retq   

0000000000801b4b <sys_yield>:

void
sys_yield(void)
{
  801b4b:	55                   	push   %rbp
  801b4c:	48 89 e5             	mov    %rsp,%rbp
  801b4f:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b53:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b5a:	00 
  801b5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b67:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b71:	be 00 00 00 00       	mov    $0x0,%esi
  801b76:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b7b:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801b82:	00 00 00 
  801b85:	ff d0                	callq  *%rax
}
  801b87:	c9                   	leaveq 
  801b88:	c3                   	retq   

0000000000801b89 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b89:	55                   	push   %rbp
  801b8a:	48 89 e5             	mov    %rsp,%rbp
  801b8d:	48 83 ec 20          	sub    $0x20,%rsp
  801b91:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b98:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b9b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b9e:	48 63 c8             	movslq %eax,%rcx
  801ba1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba8:	48 98                	cltq   
  801baa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb1:	00 
  801bb2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb8:	49 89 c8             	mov    %rcx,%r8
  801bbb:	48 89 d1             	mov    %rdx,%rcx
  801bbe:	48 89 c2             	mov    %rax,%rdx
  801bc1:	be 01 00 00 00       	mov    $0x1,%esi
  801bc6:	bf 04 00 00 00       	mov    $0x4,%edi
  801bcb:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801bd2:	00 00 00 
  801bd5:	ff d0                	callq  *%rax
}
  801bd7:	c9                   	leaveq 
  801bd8:	c3                   	retq   

0000000000801bd9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801bd9:	55                   	push   %rbp
  801bda:	48 89 e5             	mov    %rsp,%rbp
  801bdd:	48 83 ec 30          	sub    $0x30,%rsp
  801be1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801be4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801be8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801beb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bef:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bf3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bf6:	48 63 c8             	movslq %eax,%rcx
  801bf9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bfd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c00:	48 63 f0             	movslq %eax,%rsi
  801c03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0a:	48 98                	cltq   
  801c0c:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c10:	49 89 f9             	mov    %rdi,%r9
  801c13:	49 89 f0             	mov    %rsi,%r8
  801c16:	48 89 d1             	mov    %rdx,%rcx
  801c19:	48 89 c2             	mov    %rax,%rdx
  801c1c:	be 01 00 00 00       	mov    $0x1,%esi
  801c21:	bf 05 00 00 00       	mov    $0x5,%edi
  801c26:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801c2d:	00 00 00 
  801c30:	ff d0                	callq  *%rax
}
  801c32:	c9                   	leaveq 
  801c33:	c3                   	retq   

0000000000801c34 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c34:	55                   	push   %rbp
  801c35:	48 89 e5             	mov    %rsp,%rbp
  801c38:	48 83 ec 20          	sub    $0x20,%rsp
  801c3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4a:	48 98                	cltq   
  801c4c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c53:	00 
  801c54:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c60:	48 89 d1             	mov    %rdx,%rcx
  801c63:	48 89 c2             	mov    %rax,%rdx
  801c66:	be 01 00 00 00       	mov    $0x1,%esi
  801c6b:	bf 06 00 00 00       	mov    $0x6,%edi
  801c70:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801c77:	00 00 00 
  801c7a:	ff d0                	callq  *%rax
}
  801c7c:	c9                   	leaveq 
  801c7d:	c3                   	retq   

0000000000801c7e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c7e:	55                   	push   %rbp
  801c7f:	48 89 e5             	mov    %rsp,%rbp
  801c82:	48 83 ec 10          	sub    $0x10,%rsp
  801c86:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c89:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c8f:	48 63 d0             	movslq %eax,%rdx
  801c92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c95:	48 98                	cltq   
  801c97:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c9e:	00 
  801c9f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cab:	48 89 d1             	mov    %rdx,%rcx
  801cae:	48 89 c2             	mov    %rax,%rdx
  801cb1:	be 01 00 00 00       	mov    $0x1,%esi
  801cb6:	bf 08 00 00 00       	mov    $0x8,%edi
  801cbb:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801cc2:	00 00 00 
  801cc5:	ff d0                	callq  *%rax
}
  801cc7:	c9                   	leaveq 
  801cc8:	c3                   	retq   

0000000000801cc9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801cc9:	55                   	push   %rbp
  801cca:	48 89 e5             	mov    %rsp,%rbp
  801ccd:	48 83 ec 20          	sub    $0x20,%rsp
  801cd1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cd4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801cd8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cdf:	48 98                	cltq   
  801ce1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce8:	00 
  801ce9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf5:	48 89 d1             	mov    %rdx,%rcx
  801cf8:	48 89 c2             	mov    %rax,%rdx
  801cfb:	be 01 00 00 00       	mov    $0x1,%esi
  801d00:	bf 09 00 00 00       	mov    $0x9,%edi
  801d05:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801d0c:	00 00 00 
  801d0f:	ff d0                	callq  *%rax
}
  801d11:	c9                   	leaveq 
  801d12:	c3                   	retq   

0000000000801d13 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d13:	55                   	push   %rbp
  801d14:	48 89 e5             	mov    %rsp,%rbp
  801d17:	48 83 ec 20          	sub    $0x20,%rsp
  801d1b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d1e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d29:	48 98                	cltq   
  801d2b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d32:	00 
  801d33:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d39:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d3f:	48 89 d1             	mov    %rdx,%rcx
  801d42:	48 89 c2             	mov    %rax,%rdx
  801d45:	be 01 00 00 00       	mov    $0x1,%esi
  801d4a:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d4f:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801d56:	00 00 00 
  801d59:	ff d0                	callq  *%rax
}
  801d5b:	c9                   	leaveq 
  801d5c:	c3                   	retq   

0000000000801d5d <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801d5d:	55                   	push   %rbp
  801d5e:	48 89 e5             	mov    %rsp,%rbp
  801d61:	48 83 ec 10          	sub    $0x10,%rsp
  801d65:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d68:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801d6b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d6e:	48 63 d0             	movslq %eax,%rdx
  801d71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d74:	48 98                	cltq   
  801d76:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d7d:	00 
  801d7e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d84:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d8a:	48 89 d1             	mov    %rdx,%rcx
  801d8d:	48 89 c2             	mov    %rax,%rdx
  801d90:	be 01 00 00 00       	mov    $0x1,%esi
  801d95:	bf 11 00 00 00       	mov    $0x11,%edi
  801d9a:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801da1:	00 00 00 
  801da4:	ff d0                	callq  *%rax

}
  801da6:	c9                   	leaveq 
  801da7:	c3                   	retq   

0000000000801da8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801da8:	55                   	push   %rbp
  801da9:	48 89 e5             	mov    %rsp,%rbp
  801dac:	48 83 ec 20          	sub    $0x20,%rsp
  801db0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801db7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801dbb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801dbe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dc1:	48 63 f0             	movslq %eax,%rsi
  801dc4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dcb:	48 98                	cltq   
  801dcd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dd1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dd8:	00 
  801dd9:	49 89 f1             	mov    %rsi,%r9
  801ddc:	49 89 c8             	mov    %rcx,%r8
  801ddf:	48 89 d1             	mov    %rdx,%rcx
  801de2:	48 89 c2             	mov    %rax,%rdx
  801de5:	be 00 00 00 00       	mov    $0x0,%esi
  801dea:	bf 0c 00 00 00       	mov    $0xc,%edi
  801def:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801df6:	00 00 00 
  801df9:	ff d0                	callq  *%rax
}
  801dfb:	c9                   	leaveq 
  801dfc:	c3                   	retq   

0000000000801dfd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801dfd:	55                   	push   %rbp
  801dfe:	48 89 e5             	mov    %rsp,%rbp
  801e01:	48 83 ec 10          	sub    $0x10,%rsp
  801e05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801e09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e14:	00 
  801e15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e21:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e26:	48 89 c2             	mov    %rax,%rdx
  801e29:	be 01 00 00 00       	mov    $0x1,%esi
  801e2e:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e33:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801e3a:	00 00 00 
  801e3d:	ff d0                	callq  *%rax
}
  801e3f:	c9                   	leaveq 
  801e40:	c3                   	retq   

0000000000801e41 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801e41:	55                   	push   %rbp
  801e42:	48 89 e5             	mov    %rsp,%rbp
  801e45:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e49:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e50:	00 
  801e51:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e57:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e62:	ba 00 00 00 00       	mov    $0x0,%edx
  801e67:	be 00 00 00 00       	mov    $0x0,%esi
  801e6c:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e71:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801e78:	00 00 00 
  801e7b:	ff d0                	callq  *%rax
}
  801e7d:	c9                   	leaveq 
  801e7e:	c3                   	retq   

0000000000801e7f <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801e7f:	55                   	push   %rbp
  801e80:	48 89 e5             	mov    %rsp,%rbp
  801e83:	48 83 ec 30          	sub    $0x30,%rsp
  801e87:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e8a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e8e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e91:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e95:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e99:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e9c:	48 63 c8             	movslq %eax,%rcx
  801e9f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ea3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ea6:	48 63 f0             	movslq %eax,%rsi
  801ea9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ead:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb0:	48 98                	cltq   
  801eb2:	48 89 0c 24          	mov    %rcx,(%rsp)
  801eb6:	49 89 f9             	mov    %rdi,%r9
  801eb9:	49 89 f0             	mov    %rsi,%r8
  801ebc:	48 89 d1             	mov    %rdx,%rcx
  801ebf:	48 89 c2             	mov    %rax,%rdx
  801ec2:	be 00 00 00 00       	mov    $0x0,%esi
  801ec7:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ecc:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801ed3:	00 00 00 
  801ed6:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801ed8:	c9                   	leaveq 
  801ed9:	c3                   	retq   

0000000000801eda <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801eda:	55                   	push   %rbp
  801edb:	48 89 e5             	mov    %rsp,%rbp
  801ede:	48 83 ec 20          	sub    $0x20,%rsp
  801ee2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ee6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801eea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ef9:	00 
  801efa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f00:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f06:	48 89 d1             	mov    %rdx,%rcx
  801f09:	48 89 c2             	mov    %rax,%rdx
  801f0c:	be 00 00 00 00       	mov    $0x0,%esi
  801f11:	bf 10 00 00 00       	mov    $0x10,%edi
  801f16:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801f1d:	00 00 00 
  801f20:	ff d0                	callq  *%rax
}
  801f22:	c9                   	leaveq 
  801f23:	c3                   	retq   

0000000000801f24 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801f24:	55                   	push   %rbp
  801f25:	48 89 e5             	mov    %rsp,%rbp
  801f28:	48 83 ec 30          	sub    $0x30,%rsp
  801f2c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)



	void *addr = (void *) utf->utf_fault_va;
  801f30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f34:	48 8b 00             	mov    (%rax),%rax
  801f37:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f3f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f43:	89 45 f4             	mov    %eax,-0xc(%rbp)
        // Hint:
        //   Use the read-only page table mappings at vpt
        //   (see <inc/memlayout.h>).

        // LAB 4: Your code here.
	if (!(err&FEC_WR))
  801f46:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f49:	83 e0 02             	and    $0x2,%eax
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	75 2a                	jne    801f7a <pgfault+0x56>
		panic("pgfault:FEC_WR check\n");
  801f50:	48 ba 58 4a 80 00 00 	movabs $0x804a58,%rdx
  801f57:	00 00 00 
  801f5a:	be 21 00 00 00       	mov    $0x21,%esi
  801f5f:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  801f66:	00 00 00 
  801f69:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6e:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  801f75:	00 00 00 
  801f78:	ff d1                	callq  *%rcx
	if (!(uvpt[((uint64_t)addr) / PGSIZE] & PTE_COW))
  801f7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f7e:	48 c1 e8 0c          	shr    $0xc,%rax
  801f82:	48 89 c2             	mov    %rax,%rdx
  801f85:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f8c:	01 00 00 
  801f8f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f93:	25 00 08 00 00       	and    $0x800,%eax
  801f98:	48 85 c0             	test   %rax,%rax
  801f9b:	75 2a                	jne    801fc7 <pgfault+0xa3>
		panic("pgfault:PTE_COW check\n");
  801f9d:	48 ba 79 4a 80 00 00 	movabs $0x804a79,%rdx
  801fa4:	00 00 00 
  801fa7:	be 23 00 00 00       	mov    $0x23,%esi
  801fac:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  801fb3:	00 00 00 
  801fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbb:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  801fc2:	00 00 00 
  801fc5:	ff d1                	callq  *%rcx
        // Hint:
        //   You should make three system calls.
        //   No need to explicitly delete the old page's mapping.

        // LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801fc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fcb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801fcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801fd9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U)<0)
  801fdd:	ba 07 00 00 00       	mov    $0x7,%edx
  801fe2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fe7:	bf 00 00 00 00       	mov    $0x0,%edi
  801fec:	48 b8 89 1b 80 00 00 	movabs $0x801b89,%rax
  801ff3:	00 00 00 
  801ff6:	ff d0                	callq  *%rax
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	79 2a                	jns    802026 <pgfault+0x102>
		panic("pgfault: sys_page_alloc error\n");
  801ffc:	48 ba 90 4a 80 00 00 	movabs $0x804a90,%rdx
  802003:	00 00 00 
  802006:	be 2f 00 00 00       	mov    $0x2f,%esi
  80200b:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  802012:	00 00 00 
  802015:	b8 00 00 00 00       	mov    $0x0,%eax
  80201a:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802021:	00 00 00 
  802024:	ff d1                	callq  *%rcx
	memcpy(PFTEMP, addr, PGSIZE);
  802026:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80202a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80202f:	48 89 c6             	mov    %rax,%rsi
  802032:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802037:	48 b8 95 16 80 00 00 	movabs $0x801695,%rax
  80203e:	00 00 00 
  802041:	ff d0                	callq  *%rax
	if (sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0)
  802043:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802047:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80204d:	48 89 c1             	mov    %rax,%rcx
  802050:	ba 00 00 00 00       	mov    $0x0,%edx
  802055:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80205a:	bf 00 00 00 00       	mov    $0x0,%edi
  80205f:	48 b8 d9 1b 80 00 00 	movabs $0x801bd9,%rax
  802066:	00 00 00 
  802069:	ff d0                	callq  *%rax
  80206b:	85 c0                	test   %eax,%eax
  80206d:	79 2a                	jns    802099 <pgfault+0x175>
		panic("pgfault: sys_page_map error\n");
  80206f:	48 ba af 4a 80 00 00 	movabs $0x804aaf,%rdx
  802076:	00 00 00 
  802079:	be 32 00 00 00       	mov    $0x32,%esi
  80207e:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  802085:	00 00 00 
  802088:	b8 00 00 00 00       	mov    $0x0,%eax
  80208d:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802094:	00 00 00 
  802097:	ff d1                	callq  *%rcx

	if (sys_page_unmap(0, (void *)PFTEMP)<0)
  802099:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80209e:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a3:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  8020aa:	00 00 00 
  8020ad:	ff d0                	callq  *%rax
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	79 2a                	jns    8020dd <pgfault+0x1b9>
		panic("pgfault: sys_page_unmap error\n");
  8020b3:	48 ba d0 4a 80 00 00 	movabs $0x804ad0,%rdx
  8020ba:	00 00 00 
  8020bd:	be 35 00 00 00       	mov    $0x35,%esi
  8020c2:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  8020c9:	00 00 00 
  8020cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d1:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8020d8:	00 00 00 
  8020db:	ff d1                	callq  *%rcx
	


}
  8020dd:	c9                   	leaveq 
  8020de:	c3                   	retq   

00000000008020df <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8020df:	55                   	push   %rbp
  8020e0:	48 89 e5             	mov    %rsp,%rbp
  8020e3:	48 83 ec 10          	sub    $0x10,%rsp
  8020e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020ea:	89 75 f8             	mov    %esi,-0x8(%rbp)

	if (uvpt[pn] & PTE_SHARE){
  8020ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020f4:	01 00 00 
  8020f7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8020fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020fe:	25 00 04 00 00       	and    $0x400,%eax
  802103:	48 85 c0             	test   %rax,%rax
  802106:	74 75                	je     80217d <duppage+0x9e>
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
  802108:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80210f:	01 00 00 
  802112:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802115:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802119:	25 07 0e 00 00       	and    $0xe07,%eax
  80211e:	89 c6                	mov    %eax,%esi
  802120:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802123:	48 c1 e0 0c          	shl    $0xc,%rax
  802127:	48 89 c1             	mov    %rax,%rcx
  80212a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80212d:	48 c1 e0 0c          	shl    $0xc,%rax
  802131:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802134:	41 89 f0             	mov    %esi,%r8d
  802137:	48 89 c6             	mov    %rax,%rsi
  80213a:	bf 00 00 00 00       	mov    $0x0,%edi
  80213f:	48 b8 d9 1b 80 00 00 	movabs $0x801bd9,%rax
  802146:	00 00 00 
  802149:	ff d0                	callq  *%rax
  80214b:	85 c0                	test   %eax,%eax
  80214d:	0f 89 82 01 00 00    	jns    8022d5 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");	
  802153:	48 ba ef 4a 80 00 00 	movabs $0x804aef,%rdx
  80215a:	00 00 00 
  80215d:	be 4c 00 00 00       	mov    $0x4c,%esi
  802162:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  802169:	00 00 00 
  80216c:	b8 00 00 00 00       	mov    $0x0,%eax
  802171:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802178:	00 00 00 
  80217b:	ff d1                	callq  *%rcx
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
  80217d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802184:	01 00 00 
  802187:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80218a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80218e:	83 e0 02             	and    $0x2,%eax
  802191:	48 85 c0             	test   %rax,%rax
  802194:	75 7e                	jne    802214 <duppage+0x135>
  802196:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80219d:	01 00 00 
  8021a0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8021a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a7:	25 00 08 00 00       	and    $0x800,%eax
  8021ac:	48 85 c0             	test   %rax,%rax
  8021af:	75 63                	jne    802214 <duppage+0x135>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  8021b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021b4:	c1 e0 0c             	shl    $0xc,%eax
  8021b7:	89 c0                	mov    %eax,%eax
  8021b9:	48 89 c1             	mov    %rax,%rcx
  8021bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021bf:	c1 e0 0c             	shl    $0xc,%eax
  8021c2:	89 c0                	mov    %eax,%eax
  8021c4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021c7:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  8021cd:	48 89 c6             	mov    %rax,%rsi
  8021d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d5:	48 b8 d9 1b 80 00 00 	movabs $0x801bd9,%rax
  8021dc:	00 00 00 
  8021df:	ff d0                	callq  *%rax
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	79 2a                	jns    80220f <duppage+0x130>
			panic("duppage:sys_page_map error\n");
  8021e5:	48 ba ef 4a 80 00 00 	movabs $0x804aef,%rdx
  8021ec:	00 00 00 
  8021ef:	be 51 00 00 00       	mov    $0x51,%esi
  8021f4:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  8021fb:	00 00 00 
  8021fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802203:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  80220a:	00 00 00 
  80220d:	ff d1                	callq  *%rcx
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
			panic("duppage:sys_page_map error\n");	
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  80220f:	e9 c1 00 00 00       	jmpq   8022d5 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  802214:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802217:	c1 e0 0c             	shl    $0xc,%eax
  80221a:	89 c0                	mov    %eax,%eax
  80221c:	48 89 c1             	mov    %rax,%rcx
  80221f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802222:	c1 e0 0c             	shl    $0xc,%eax
  802225:	89 c0                	mov    %eax,%eax
  802227:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80222a:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802230:	48 89 c6             	mov    %rax,%rsi
  802233:	bf 00 00 00 00       	mov    $0x0,%edi
  802238:	48 b8 d9 1b 80 00 00 	movabs $0x801bd9,%rax
  80223f:	00 00 00 
  802242:	ff d0                	callq  *%rax
  802244:	85 c0                	test   %eax,%eax
  802246:	79 2a                	jns    802272 <duppage+0x193>
			panic("duppage:sys_page_map error\n");
  802248:	48 ba ef 4a 80 00 00 	movabs $0x804aef,%rdx
  80224f:	00 00 00 
  802252:	be 55 00 00 00       	mov    $0x55,%esi
  802257:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  80225e:	00 00 00 
  802261:	b8 00 00 00 00       	mov    $0x0,%eax
  802266:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  80226d:	00 00 00 
  802270:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  802272:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802275:	c1 e0 0c             	shl    $0xc,%eax
  802278:	89 c0                	mov    %eax,%eax
  80227a:	48 89 c2             	mov    %rax,%rdx
  80227d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802280:	c1 e0 0c             	shl    $0xc,%eax
  802283:	89 c0                	mov    %eax,%eax
  802285:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  80228b:	48 89 d1             	mov    %rdx,%rcx
  80228e:	ba 00 00 00 00       	mov    $0x0,%edx
  802293:	48 89 c6             	mov    %rax,%rsi
  802296:	bf 00 00 00 00       	mov    $0x0,%edi
  80229b:	48 b8 d9 1b 80 00 00 	movabs $0x801bd9,%rax
  8022a2:	00 00 00 
  8022a5:	ff d0                	callq  *%rax
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	79 2a                	jns    8022d5 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
  8022ab:	48 ba ef 4a 80 00 00 	movabs $0x804aef,%rdx
  8022b2:	00 00 00 
  8022b5:	be 57 00 00 00       	mov    $0x57,%esi
  8022ba:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  8022c1:	00 00 00 
  8022c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c9:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8022d0:	00 00 00 
  8022d3:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  8022d5:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8022da:	c9                   	leaveq 
  8022db:	c3                   	retq   

00000000008022dc <new_duppage>:


static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
  8022dc:	55                   	push   %rbp
  8022dd:	48 89 e5             	mov    %rsp,%rbp
  8022e0:	48 83 ec 10          	sub    $0x10,%rsp
  8022e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022e7:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8022ea:	89 55 f4             	mov    %edx,-0xc(%rbp)
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
  8022ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022f4:	01 00 00 
  8022f7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8022fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022fe:	83 e0 02             	and    $0x2,%eax
  802301:	48 85 c0             	test   %rax,%rax
  802304:	0f 85 84 00 00 00    	jne    80238e <new_duppage+0xb2>
  80230a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802311:	01 00 00 
  802314:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802317:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231b:	25 00 08 00 00       	and    $0x800,%eax
  802320:	48 85 c0             	test   %rax,%rax
  802323:	75 69                	jne    80238e <new_duppage+0xb2>
  802325:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802329:	75 63                	jne    80238e <new_duppage+0xb2>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  80232b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80232e:	c1 e0 0c             	shl    $0xc,%eax
  802331:	89 c0                	mov    %eax,%eax
  802333:	48 89 c1             	mov    %rax,%rcx
  802336:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802339:	c1 e0 0c             	shl    $0xc,%eax
  80233c:	89 c0                	mov    %eax,%eax
  80233e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802341:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  802347:	48 89 c6             	mov    %rax,%rsi
  80234a:	bf 00 00 00 00       	mov    $0x0,%edi
  80234f:	48 b8 d9 1b 80 00 00 	movabs $0x801bd9,%rax
  802356:	00 00 00 
  802359:	ff d0                	callq  *%rax
  80235b:	85 c0                	test   %eax,%eax
  80235d:	79 2a                	jns    802389 <new_duppage+0xad>
			panic("duppage:sys_page_map error\n");
  80235f:	48 ba ef 4a 80 00 00 	movabs $0x804aef,%rdx
  802366:	00 00 00 
  802369:	be 64 00 00 00       	mov    $0x64,%esi
  80236e:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  802375:	00 00 00 
  802378:	b8 00 00 00 00       	mov    $0x0,%eax
  80237d:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802384:	00 00 00 
  802387:	ff d1                	callq  *%rcx
static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  802389:	e9 c1 00 00 00       	jmpq   80244f <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  80238e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802391:	c1 e0 0c             	shl    $0xc,%eax
  802394:	89 c0                	mov    %eax,%eax
  802396:	48 89 c1             	mov    %rax,%rcx
  802399:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80239c:	c1 e0 0c             	shl    $0xc,%eax
  80239f:	89 c0                	mov    %eax,%eax
  8023a1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023a4:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8023aa:	48 89 c6             	mov    %rax,%rsi
  8023ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8023b2:	48 b8 d9 1b 80 00 00 	movabs $0x801bd9,%rax
  8023b9:	00 00 00 
  8023bc:	ff d0                	callq  *%rax
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	79 2a                	jns    8023ec <new_duppage+0x110>
			panic("duppage:sys_page_map error\n");
  8023c2:	48 ba ef 4a 80 00 00 	movabs $0x804aef,%rdx
  8023c9:	00 00 00 
  8023cc:	be 68 00 00 00       	mov    $0x68,%esi
  8023d1:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  8023d8:	00 00 00 
  8023db:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e0:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8023e7:	00 00 00 
  8023ea:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  8023ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023ef:	c1 e0 0c             	shl    $0xc,%eax
  8023f2:	89 c0                	mov    %eax,%eax
  8023f4:	48 89 c2             	mov    %rax,%rdx
  8023f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023fa:	c1 e0 0c             	shl    $0xc,%eax
  8023fd:	89 c0                	mov    %eax,%eax
  8023ff:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802405:	48 89 d1             	mov    %rdx,%rcx
  802408:	ba 00 00 00 00       	mov    $0x0,%edx
  80240d:	48 89 c6             	mov    %rax,%rsi
  802410:	bf 00 00 00 00       	mov    $0x0,%edi
  802415:	48 b8 d9 1b 80 00 00 	movabs $0x801bd9,%rax
  80241c:	00 00 00 
  80241f:	ff d0                	callq  *%rax
  802421:	85 c0                	test   %eax,%eax
  802423:	79 2a                	jns    80244f <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
  802425:	48 ba ef 4a 80 00 00 	movabs $0x804aef,%rdx
  80242c:	00 00 00 
  80242f:	be 6a 00 00 00       	mov    $0x6a,%esi
  802434:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  80243b:	00 00 00 
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
  802443:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  80244a:	00 00 00 
  80244d:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  80244f:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802454:	c9                   	leaveq 
  802455:	c3                   	retq   

0000000000802456 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802456:	55                   	push   %rbp
  802457:	48 89 e5             	mov    %rsp,%rbp
  80245a:	48 83 ec 10          	sub    $0x10,%rsp


	
	int envid;  
	//extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  80245e:	48 bf 24 1f 80 00 00 	movabs $0x801f24,%rdi
  802465:	00 00 00 
  802468:	48 b8 ef 42 80 00 00 	movabs $0x8042ef,%rax
  80246f:	00 00 00 
  802472:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802474:	b8 07 00 00 00       	mov    $0x7,%eax
  802479:	cd 30                	int    $0x30
  80247b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80247e:	8b 45 f0             	mov    -0x10(%rbp),%eax


	if ((envid=sys_exofork())<0)
  802481:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802484:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802488:	79 2a                	jns    8024b4 <fork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  80248a:	48 ba 0b 4b 80 00 00 	movabs $0x804b0b,%rdx
  802491:	00 00 00 
  802494:	be 90 00 00 00       	mov    $0x90,%esi
  802499:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  8024a0:	00 00 00 
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a8:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8024af:	00 00 00 
  8024b2:	ff d1                	callq  *%rcx

	if(envid>0){
  8024b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8024b8:	0f 8e e1 01 00 00    	jle    80269f <fork+0x249>
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  8024be:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  8024c5:	00 
  8024c6:	e9 d4 00 00 00       	jmpq   80259f <fork+0x149>
		{
			

               if(!(uvpml4e[VPML4E(i)]))
  8024cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024cf:	48 c1 e8 27          	shr    $0x27,%rax
  8024d3:	48 89 c2             	mov    %rax,%rdx
  8024d6:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8024dd:	01 00 00 
  8024e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024e4:	48 85 c0             	test   %rax,%rax
  8024e7:	75 05                	jne    8024ee <fork+0x98>
		 continue;
  8024e9:	e9 a9 00 00 00       	jmpq   802597 <fork+0x141>
		
		if(!(uvpde[VPDPE(i)]))
  8024ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024f2:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024f6:	48 89 c2             	mov    %rax,%rdx
  8024f9:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802500:	01 00 00 
  802503:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802507:	48 85 c0             	test   %rax,%rax
  80250a:	75 05                	jne    802511 <fork+0xbb>
	          continue;
  80250c:	e9 86 00 00 00       	jmpq   802597 <fork+0x141>
	

			if(!(uvpd[VPD(i)] & PTE_P))
  802511:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802515:	48 c1 e8 15          	shr    $0x15,%rax
  802519:	48 89 c2             	mov    %rax,%rdx
  80251c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802523:	01 00 00 
  802526:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80252a:	83 e0 01             	and    $0x1,%eax
  80252d:	48 85 c0             	test   %rax,%rax
  802530:	75 02                	jne    802534 <fork+0xde>
				continue;
  802532:	eb 63                	jmp    802597 <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_P))
  802534:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802538:	48 c1 e8 0c          	shr    $0xc,%rax
  80253c:	48 89 c2             	mov    %rax,%rdx
  80253f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802546:	01 00 00 
  802549:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80254d:	83 e0 01             	and    $0x1,%eax
  802550:	48 85 c0             	test   %rax,%rax
  802553:	75 02                	jne    802557 <fork+0x101>
				continue; 
  802555:	eb 40                	jmp    802597 <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_U))
  802557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80255b:	48 c1 e8 0c          	shr    $0xc,%rax
  80255f:	48 89 c2             	mov    %rax,%rdx
  802562:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802569:	01 00 00 
  80256c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802570:	83 e0 04             	and    $0x4,%eax
  802573:	48 85 c0             	test   %rax,%rax
  802576:	75 02                	jne    80257a <fork+0x124>
				continue; 
  802578:	eb 1d                	jmp    802597 <fork+0x141>
			duppage(envid, VPN(i)); 
  80257a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80257e:	48 c1 e8 0c          	shr    $0xc,%rax
  802582:	89 c2                	mov    %eax,%edx
  802584:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802587:	89 d6                	mov    %edx,%esi
  802589:	89 c7                	mov    %eax,%edi
  80258b:	48 b8 df 20 80 00 00 	movabs $0x8020df,%rax
  802592:	00 00 00 
  802595:	ff d0                	callq  *%rax

	if(envid>0){
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  802597:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  80259e:	00 
  80259f:	b8 ff cf 7f ef       	mov    $0xef7fcfff,%eax
  8025a4:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8025a8:	0f 86 1d ff ff ff    	jbe    8024cb <fork+0x75>
			if(!(uvpt[VPN(i)] & PTE_U))
				continue; 
			duppage(envid, VPN(i)); 
		}

		if (sys_page_alloc(envid,(void*)UXSTACKTOP-PGSIZE, PTE_U|PTE_W|PTE_P)<0)
  8025ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025b1:	ba 07 00 00 00       	mov    $0x7,%edx
  8025b6:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8025bb:	89 c7                	mov    %eax,%edi
  8025bd:	48 b8 89 1b 80 00 00 	movabs $0x801b89,%rax
  8025c4:	00 00 00 
  8025c7:	ff d0                	callq  *%rax
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	79 2a                	jns    8025f7 <fork+0x1a1>
			panic("fork: sys_page_alloc error!\n");
  8025cd:	48 ba 25 4b 80 00 00 	movabs $0x804b25,%rdx
  8025d4:	00 00 00 
  8025d7:	be ab 00 00 00       	mov    $0xab,%esi
  8025dc:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  8025e3:	00 00 00 
  8025e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025eb:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8025f2:	00 00 00 
  8025f5:	ff d1                	callq  *%rcx

		duppage(envid, VPN(USTACKTOP-PGSIZE));
  8025f7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025fa:	be fd f7 0e 00       	mov    $0xef7fd,%esi
  8025ff:	89 c7                	mov    %eax,%edi
  802601:	48 b8 df 20 80 00 00 	movabs $0x8020df,%rax
  802608:	00 00 00 
  80260b:	ff d0                	callq  *%rax
		extern void _pgfault_upcall(void);
		if (sys_env_set_pgfault_upcall(envid, _pgfault_upcall)<0)
  80260d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802610:	48 be 8f 43 80 00 00 	movabs $0x80438f,%rsi
  802617:	00 00 00 
  80261a:	89 c7                	mov    %eax,%edi
  80261c:	48 b8 13 1d 80 00 00 	movabs $0x801d13,%rax
  802623:	00 00 00 
  802626:	ff d0                	callq  *%rax
  802628:	85 c0                	test   %eax,%eax
  80262a:	79 2a                	jns    802656 <fork+0x200>
			panic("fork: sys_env_set_status error!\n");
  80262c:	48 ba 48 4b 80 00 00 	movabs $0x804b48,%rdx
  802633:	00 00 00 
  802636:	be b0 00 00 00       	mov    $0xb0,%esi
  80263b:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  802642:	00 00 00 
  802645:	b8 00 00 00 00       	mov    $0x0,%eax
  80264a:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802651:	00 00 00 
  802654:	ff d1                	callq  *%rcx
		if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  802656:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802659:	be 02 00 00 00       	mov    $0x2,%esi
  80265e:	89 c7                	mov    %eax,%edi
  802660:	48 b8 7e 1c 80 00 00 	movabs $0x801c7e,%rax
  802667:	00 00 00 
  80266a:	ff d0                	callq  *%rax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	79 2a                	jns    80269a <fork+0x244>
			panic("fork: sys_env_set_status error!\n");
  802670:	48 ba 48 4b 80 00 00 	movabs $0x804b48,%rdx
  802677:	00 00 00 
  80267a:	be b2 00 00 00       	mov    $0xb2,%esi
  80267f:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  802686:	00 00 00 
  802689:	b8 00 00 00 00       	mov    $0x0,%eax
  80268e:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802695:	00 00 00 
  802698:	ff d1                	callq  *%rcx

		return envid;
  80269a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80269d:	eb 39                	jmp    8026d8 <fork+0x282>
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80269f:	48 b8 0d 1b 80 00 00 	movabs $0x801b0d,%rax
  8026a6:	00 00 00 
  8026a9:	ff d0                	callq  *%rax
  8026ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8026b0:	48 98                	cltq   
  8026b2:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8026b9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8026c0:	00 00 00 
  8026c3:	48 01 c2             	add    %rax,%rdx
  8026c6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026cd:	00 00 00 
  8026d0:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8026d3:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  8026d8:	c9                   	leaveq 
  8026d9:	c3                   	retq   

00000000008026da <sfork>:

// Challenge!
envid_t
sfork(void)
{
  8026da:	55                   	push   %rbp
  8026db:	48 89 e5             	mov    %rsp,%rbp
  8026de:	48 83 ec 20          	sub    $0x20,%rsp

	
	int envid;  
	extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  8026e2:	48 bf 24 1f 80 00 00 	movabs $0x801f24,%rdi
  8026e9:	00 00 00 
  8026ec:	48 b8 ef 42 80 00 00 	movabs $0x8042ef,%rax
  8026f3:	00 00 00 
  8026f6:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8026f8:	b8 07 00 00 00       	mov    $0x7,%eax
  8026fd:	cd 30                	int    $0x30
  8026ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802702:	8b 45 ec             	mov    -0x14(%rbp),%eax
	

	if ((envid=sys_exofork())<0)
  802705:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802708:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80270c:	79 2a                	jns    802738 <sfork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  80270e:	48 ba 0b 4b 80 00 00 	movabs $0x804b0b,%rdx
  802715:	00 00 00 
  802718:	be ca 00 00 00       	mov    $0xca,%esi
  80271d:	48 bf 6e 4a 80 00 00 	movabs $0x804a6e,%rdi
  802724:	00 00 00 
  802727:	b8 00 00 00 00       	mov    $0x0,%eax
  80272c:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802733:	00 00 00 
  802736:	ff d1                	callq  *%rcx

	if(envid>0){
  802738:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80273c:	0f 8e e5 00 00 00    	jle    802827 <sfork+0x14d>
		
		
		uintptr_t i;
		int flag=1;
  802742:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)

		for (i = 0; i < (uintptr_t)end/*USTACKTOP-PGSIZE*/; i += PGSIZE) ;
  802749:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802750:	00 
  802751:	eb 08                	jmp    80275b <sfork+0x81>
  802753:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  80275a:	00 
  80275b:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  802762:	00 00 00 
  802765:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802769:	72 e8                	jb     802753 <sfork+0x79>
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
  80276b:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802772:	00 
    for (;i>=0; i -= PGSIZE) 
		{
			cprintf("23\n");
  802773:	48 bf 69 4b 80 00 00 	movabs $0x804b69,%rdi
  80277a:	00 00 00 
  80277d:	b8 00 00 00 00       	mov    $0x0,%eax
  802782:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  802789:	00 00 00 
  80278c:	ff d2                	callq  *%rdx
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
  80278e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802792:	48 c1 e8 15          	shr    $0x15,%rax
  802796:	48 89 c2             	mov    %rax,%rdx
  802799:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027a0:	01 00 00 
  8027a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a7:	83 e0 01             	and    $0x1,%eax
  8027aa:	48 85 c0             	test   %rax,%rax
  8027ad:	74 42                	je     8027f1 <sfork+0x117>
  8027af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8027b7:	48 89 c2             	mov    %rax,%rdx
  8027ba:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027c1:	01 00 00 
  8027c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027c8:	83 e0 01             	and    $0x1,%eax
  8027cb:	48 85 c0             	test   %rax,%rax
  8027ce:	74 21                	je     8027f1 <sfork+0x117>
  8027d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027d4:	48 c1 e8 0c          	shr    $0xc,%rax
  8027d8:	48 89 c2             	mov    %rax,%rdx
  8027db:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027e2:	01 00 00 
  8027e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027e9:	83 e0 04             	and    $0x4,%eax
  8027ec:	48 85 c0             	test   %rax,%rax
  8027ef:	75 09                	jne    8027fa <sfork+0x120>
				flag=0;
  8027f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8027f8:	eb 20                	jmp    80281a <sfork+0x140>
			else
				new_duppage(envid, VPN(i),flag); 
  8027fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027fe:	48 c1 e8 0c          	shr    $0xc,%rax
  802802:	89 c1                	mov    %eax,%ecx
  802804:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802807:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80280a:	89 ce                	mov    %ecx,%esi
  80280c:	89 c7                	mov    %eax,%edi
  80280e:	48 b8 dc 22 80 00 00 	movabs $0x8022dc,%rax
  802815:	00 00 00 
  802818:	ff d0                	callq  *%rax
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
    for (;i>=0; i -= PGSIZE) 
  80281a:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802821:	00 
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
				flag=0;
			else
				new_duppage(envid, VPN(i),flag); 

		}
  802822:	e9 4c ff ff ff       	jmpq   802773 <sfork+0x99>

		return envid;
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802827:	48 b8 0d 1b 80 00 00 	movabs $0x801b0d,%rax
  80282e:	00 00 00 
  802831:	ff d0                	callq  *%rax
  802833:	25 ff 03 00 00       	and    $0x3ff,%eax
  802838:	48 98                	cltq   
  80283a:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  802841:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802848:	00 00 00 
  80284b:	48 01 c2             	add    %rax,%rdx
  80284e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802855:	00 00 00 
  802858:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80285b:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  802860:	c9                   	leaveq 
  802861:	c3                   	retq   

0000000000802862 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802862:	55                   	push   %rbp
  802863:	48 89 e5             	mov    %rsp,%rbp
  802866:	48 83 ec 30          	sub    $0x30,%rsp
  80286a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80286e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802872:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  802876:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80287b:	75 08                	jne    802885 <ipc_recv+0x23>
  80287d:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  802884:	ff 
	int res=sys_ipc_recv(pg);
  802885:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802889:	48 89 c7             	mov    %rax,%rdi
  80288c:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  802893:	00 00 00 
  802896:	ff d0                	callq  *%rax
  802898:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  80289b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8028a0:	74 26                	je     8028c8 <ipc_recv+0x66>
  8028a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a6:	75 15                	jne    8028bd <ipc_recv+0x5b>
  8028a8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028af:	00 00 00 
  8028b2:	48 8b 00             	mov    (%rax),%rax
  8028b5:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  8028bb:	eb 05                	jmp    8028c2 <ipc_recv+0x60>
  8028bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028c6:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  8028c8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8028cd:	74 26                	je     8028f5 <ipc_recv+0x93>
  8028cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d3:	75 15                	jne    8028ea <ipc_recv+0x88>
  8028d5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028dc:	00 00 00 
  8028df:	48 8b 00             	mov    (%rax),%rax
  8028e2:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  8028e8:	eb 05                	jmp    8028ef <ipc_recv+0x8d>
  8028ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ef:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028f3:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  8028f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f9:	75 15                	jne    802910 <ipc_recv+0xae>
  8028fb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802902:	00 00 00 
  802905:	48 8b 00             	mov    (%rax),%rax
  802908:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  80290e:	eb 03                	jmp    802913 <ipc_recv+0xb1>
  802910:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  802913:	c9                   	leaveq 
  802914:	c3                   	retq   

0000000000802915 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802915:	55                   	push   %rbp
  802916:	48 89 e5             	mov    %rsp,%rbp
  802919:	48 83 ec 30          	sub    $0x30,%rsp
  80291d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802920:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802923:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802927:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  80292a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80292f:	75 0a                	jne    80293b <ipc_send+0x26>
  802931:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  802938:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  802939:	eb 3e                	jmp    802979 <ipc_send+0x64>
  80293b:	eb 3c                	jmp    802979 <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  80293d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802941:	74 2a                	je     80296d <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  802943:	48 ba 70 4b 80 00 00 	movabs $0x804b70,%rdx
  80294a:	00 00 00 
  80294d:	be 39 00 00 00       	mov    $0x39,%esi
  802952:	48 bf 9b 4b 80 00 00 	movabs $0x804b9b,%rdi
  802959:	00 00 00 
  80295c:	b8 00 00 00 00       	mov    $0x0,%eax
  802961:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802968:	00 00 00 
  80296b:	ff d1                	callq  *%rcx
		sys_yield();  
  80296d:	48 b8 4b 1b 80 00 00 	movabs $0x801b4b,%rax
  802974:	00 00 00 
  802977:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  802979:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80297c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80297f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802983:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802986:	89 c7                	mov    %eax,%edi
  802988:	48 b8 a8 1d 80 00 00 	movabs $0x801da8,%rax
  80298f:	00 00 00 
  802992:	ff d0                	callq  *%rax
  802994:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802997:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80299b:	78 a0                	js     80293d <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  80299d:	c9                   	leaveq 
  80299e:	c3                   	retq   

000000000080299f <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  80299f:	55                   	push   %rbp
  8029a0:	48 89 e5             	mov    %rsp,%rbp
  8029a3:	48 83 ec 10          	sub    $0x10,%rsp
  8029a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  8029ab:	48 ba a8 4b 80 00 00 	movabs $0x804ba8,%rdx
  8029b2:	00 00 00 
  8029b5:	be 47 00 00 00       	mov    $0x47,%esi
  8029ba:	48 bf 9b 4b 80 00 00 	movabs $0x804b9b,%rdi
  8029c1:	00 00 00 
  8029c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c9:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8029d0:	00 00 00 
  8029d3:	ff d1                	callq  *%rcx

00000000008029d5 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8029d5:	55                   	push   %rbp
  8029d6:	48 89 e5             	mov    %rsp,%rbp
  8029d9:	48 83 ec 20          	sub    $0x20,%rsp
  8029dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8029e0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8029e3:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  8029e7:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  8029ea:	48 ba d0 4b 80 00 00 	movabs $0x804bd0,%rdx
  8029f1:	00 00 00 
  8029f4:	be 50 00 00 00       	mov    $0x50,%esi
  8029f9:	48 bf 9b 4b 80 00 00 	movabs $0x804b9b,%rdi
  802a00:	00 00 00 
  802a03:	b8 00 00 00 00       	mov    $0x0,%eax
  802a08:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802a0f:	00 00 00 
  802a12:	ff d1                	callq  *%rcx

0000000000802a14 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a14:	55                   	push   %rbp
  802a15:	48 89 e5             	mov    %rsp,%rbp
  802a18:	48 83 ec 14          	sub    $0x14,%rsp
  802a1c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802a1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a26:	eb 4e                	jmp    802a76 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  802a28:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a2f:	00 00 00 
  802a32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a35:	48 98                	cltq   
  802a37:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  802a3e:	48 01 d0             	add    %rdx,%rax
  802a41:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802a47:	8b 00                	mov    (%rax),%eax
  802a49:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a4c:	75 24                	jne    802a72 <ipc_find_env+0x5e>
			return envs[i].env_id;
  802a4e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a55:	00 00 00 
  802a58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5b:	48 98                	cltq   
  802a5d:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  802a64:	48 01 d0             	add    %rdx,%rax
  802a67:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802a6d:	8b 40 08             	mov    0x8(%rax),%eax
  802a70:	eb 12                	jmp    802a84 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802a72:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a76:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802a7d:	7e a9                	jle    802a28 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  802a7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a84:	c9                   	leaveq 
  802a85:	c3                   	retq   

0000000000802a86 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802a86:	55                   	push   %rbp
  802a87:	48 89 e5             	mov    %rsp,%rbp
  802a8a:	48 83 ec 08          	sub    $0x8,%rsp
  802a8e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802a92:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a96:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802a9d:	ff ff ff 
  802aa0:	48 01 d0             	add    %rdx,%rax
  802aa3:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802aa7:	c9                   	leaveq 
  802aa8:	c3                   	retq   

0000000000802aa9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802aa9:	55                   	push   %rbp
  802aaa:	48 89 e5             	mov    %rsp,%rbp
  802aad:	48 83 ec 08          	sub    $0x8,%rsp
  802ab1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802ab5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ab9:	48 89 c7             	mov    %rax,%rdi
  802abc:	48 b8 86 2a 80 00 00 	movabs $0x802a86,%rax
  802ac3:	00 00 00 
  802ac6:	ff d0                	callq  *%rax
  802ac8:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802ace:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802ad2:	c9                   	leaveq 
  802ad3:	c3                   	retq   

0000000000802ad4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802ad4:	55                   	push   %rbp
  802ad5:	48 89 e5             	mov    %rsp,%rbp
  802ad8:	48 83 ec 18          	sub    $0x18,%rsp
  802adc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802ae0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ae7:	eb 6b                	jmp    802b54 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802ae9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aec:	48 98                	cltq   
  802aee:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802af4:	48 c1 e0 0c          	shl    $0xc,%rax
  802af8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802afc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b00:	48 c1 e8 15          	shr    $0x15,%rax
  802b04:	48 89 c2             	mov    %rax,%rdx
  802b07:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b0e:	01 00 00 
  802b11:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b15:	83 e0 01             	and    $0x1,%eax
  802b18:	48 85 c0             	test   %rax,%rax
  802b1b:	74 21                	je     802b3e <fd_alloc+0x6a>
  802b1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b21:	48 c1 e8 0c          	shr    $0xc,%rax
  802b25:	48 89 c2             	mov    %rax,%rdx
  802b28:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b2f:	01 00 00 
  802b32:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b36:	83 e0 01             	and    $0x1,%eax
  802b39:	48 85 c0             	test   %rax,%rax
  802b3c:	75 12                	jne    802b50 <fd_alloc+0x7c>
			*fd_store = fd;
  802b3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b46:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b49:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4e:	eb 1a                	jmp    802b6a <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802b50:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b54:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b58:	7e 8f                	jle    802ae9 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802b65:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802b6a:	c9                   	leaveq 
  802b6b:	c3                   	retq   

0000000000802b6c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b6c:	55                   	push   %rbp
  802b6d:	48 89 e5             	mov    %rsp,%rbp
  802b70:	48 83 ec 20          	sub    $0x20,%rsp
  802b74:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b77:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802b7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b7f:	78 06                	js     802b87 <fd_lookup+0x1b>
  802b81:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802b85:	7e 07                	jle    802b8e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b8c:	eb 6c                	jmp    802bfa <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802b8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b91:	48 98                	cltq   
  802b93:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b99:	48 c1 e0 0c          	shl    $0xc,%rax
  802b9d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802ba1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ba5:	48 c1 e8 15          	shr    $0x15,%rax
  802ba9:	48 89 c2             	mov    %rax,%rdx
  802bac:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802bb3:	01 00 00 
  802bb6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bba:	83 e0 01             	and    $0x1,%eax
  802bbd:	48 85 c0             	test   %rax,%rax
  802bc0:	74 21                	je     802be3 <fd_lookup+0x77>
  802bc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bc6:	48 c1 e8 0c          	shr    $0xc,%rax
  802bca:	48 89 c2             	mov    %rax,%rdx
  802bcd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bd4:	01 00 00 
  802bd7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bdb:	83 e0 01             	and    $0x1,%eax
  802bde:	48 85 c0             	test   %rax,%rax
  802be1:	75 07                	jne    802bea <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802be3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802be8:	eb 10                	jmp    802bfa <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802bea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bf2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bfa:	c9                   	leaveq 
  802bfb:	c3                   	retq   

0000000000802bfc <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802bfc:	55                   	push   %rbp
  802bfd:	48 89 e5             	mov    %rsp,%rbp
  802c00:	48 83 ec 30          	sub    $0x30,%rsp
  802c04:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c08:	89 f0                	mov    %esi,%eax
  802c0a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c11:	48 89 c7             	mov    %rax,%rdi
  802c14:	48 b8 86 2a 80 00 00 	movabs $0x802a86,%rax
  802c1b:	00 00 00 
  802c1e:	ff d0                	callq  *%rax
  802c20:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c24:	48 89 d6             	mov    %rdx,%rsi
  802c27:	89 c7                	mov    %eax,%edi
  802c29:	48 b8 6c 2b 80 00 00 	movabs $0x802b6c,%rax
  802c30:	00 00 00 
  802c33:	ff d0                	callq  *%rax
  802c35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3c:	78 0a                	js     802c48 <fd_close+0x4c>
	    || fd != fd2)
  802c3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c42:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802c46:	74 12                	je     802c5a <fd_close+0x5e>
		return (must_exist ? r : 0);
  802c48:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802c4c:	74 05                	je     802c53 <fd_close+0x57>
  802c4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c51:	eb 05                	jmp    802c58 <fd_close+0x5c>
  802c53:	b8 00 00 00 00       	mov    $0x0,%eax
  802c58:	eb 69                	jmp    802cc3 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802c5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c5e:	8b 00                	mov    (%rax),%eax
  802c60:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c64:	48 89 d6             	mov    %rdx,%rsi
  802c67:	89 c7                	mov    %eax,%edi
  802c69:	48 b8 c5 2c 80 00 00 	movabs $0x802cc5,%rax
  802c70:	00 00 00 
  802c73:	ff d0                	callq  *%rax
  802c75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c7c:	78 2a                	js     802ca8 <fd_close+0xac>
		if (dev->dev_close)
  802c7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c82:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c86:	48 85 c0             	test   %rax,%rax
  802c89:	74 16                	je     802ca1 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802c8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c93:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c97:	48 89 d7             	mov    %rdx,%rdi
  802c9a:	ff d0                	callq  *%rax
  802c9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c9f:	eb 07                	jmp    802ca8 <fd_close+0xac>
		else
			r = 0;
  802ca1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802ca8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cac:	48 89 c6             	mov    %rax,%rsi
  802caf:	bf 00 00 00 00       	mov    $0x0,%edi
  802cb4:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  802cbb:	00 00 00 
  802cbe:	ff d0                	callq  *%rax
	return r;
  802cc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cc3:	c9                   	leaveq 
  802cc4:	c3                   	retq   

0000000000802cc5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802cc5:	55                   	push   %rbp
  802cc6:	48 89 e5             	mov    %rsp,%rbp
  802cc9:	48 83 ec 20          	sub    $0x20,%rsp
  802ccd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cd0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802cd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802cdb:	eb 41                	jmp    802d1e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802cdd:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802ce4:	00 00 00 
  802ce7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802cea:	48 63 d2             	movslq %edx,%rdx
  802ced:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cf1:	8b 00                	mov    (%rax),%eax
  802cf3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802cf6:	75 22                	jne    802d1a <dev_lookup+0x55>
			*dev = devtab[i];
  802cf8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802cff:	00 00 00 
  802d02:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d05:	48 63 d2             	movslq %edx,%rdx
  802d08:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802d0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d10:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802d13:	b8 00 00 00 00       	mov    $0x0,%eax
  802d18:	eb 60                	jmp    802d7a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802d1a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d1e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802d25:	00 00 00 
  802d28:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d2b:	48 63 d2             	movslq %edx,%rdx
  802d2e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d32:	48 85 c0             	test   %rax,%rax
  802d35:	75 a6                	jne    802cdd <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802d37:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d3e:	00 00 00 
  802d41:	48 8b 00             	mov    (%rax),%rax
  802d44:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d4a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d4d:	89 c6                	mov    %eax,%esi
  802d4f:	48 bf f8 4b 80 00 00 	movabs $0x804bf8,%rdi
  802d56:	00 00 00 
  802d59:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5e:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  802d65:	00 00 00 
  802d68:	ff d1                	callq  *%rcx
	*dev = 0;
  802d6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d6e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802d75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802d7a:	c9                   	leaveq 
  802d7b:	c3                   	retq   

0000000000802d7c <close>:

int
close(int fdnum)
{
  802d7c:	55                   	push   %rbp
  802d7d:	48 89 e5             	mov    %rsp,%rbp
  802d80:	48 83 ec 20          	sub    $0x20,%rsp
  802d84:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d87:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d8e:	48 89 d6             	mov    %rdx,%rsi
  802d91:	89 c7                	mov    %eax,%edi
  802d93:	48 b8 6c 2b 80 00 00 	movabs $0x802b6c,%rax
  802d9a:	00 00 00 
  802d9d:	ff d0                	callq  *%rax
  802d9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da6:	79 05                	jns    802dad <close+0x31>
		return r;
  802da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dab:	eb 18                	jmp    802dc5 <close+0x49>
	else
		return fd_close(fd, 1);
  802dad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db1:	be 01 00 00 00       	mov    $0x1,%esi
  802db6:	48 89 c7             	mov    %rax,%rdi
  802db9:	48 b8 fc 2b 80 00 00 	movabs $0x802bfc,%rax
  802dc0:	00 00 00 
  802dc3:	ff d0                	callq  *%rax
}
  802dc5:	c9                   	leaveq 
  802dc6:	c3                   	retq   

0000000000802dc7 <close_all>:

void
close_all(void)
{
  802dc7:	55                   	push   %rbp
  802dc8:	48 89 e5             	mov    %rsp,%rbp
  802dcb:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802dcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802dd6:	eb 15                	jmp    802ded <close_all+0x26>
		close(i);
  802dd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ddb:	89 c7                	mov    %eax,%edi
  802ddd:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  802de4:	00 00 00 
  802de7:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802de9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ded:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802df1:	7e e5                	jle    802dd8 <close_all+0x11>
		close(i);
}
  802df3:	c9                   	leaveq 
  802df4:	c3                   	retq   

0000000000802df5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802df5:	55                   	push   %rbp
  802df6:	48 89 e5             	mov    %rsp,%rbp
  802df9:	48 83 ec 40          	sub    $0x40,%rsp
  802dfd:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802e00:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802e03:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802e07:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802e0a:	48 89 d6             	mov    %rdx,%rsi
  802e0d:	89 c7                	mov    %eax,%edi
  802e0f:	48 b8 6c 2b 80 00 00 	movabs $0x802b6c,%rax
  802e16:	00 00 00 
  802e19:	ff d0                	callq  *%rax
  802e1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e22:	79 08                	jns    802e2c <dup+0x37>
		return r;
  802e24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e27:	e9 70 01 00 00       	jmpq   802f9c <dup+0x1a7>
	close(newfdnum);
  802e2c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e2f:	89 c7                	mov    %eax,%edi
  802e31:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  802e38:	00 00 00 
  802e3b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802e3d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e40:	48 98                	cltq   
  802e42:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802e48:	48 c1 e0 0c          	shl    $0xc,%rax
  802e4c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802e50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e54:	48 89 c7             	mov    %rax,%rdi
  802e57:	48 b8 a9 2a 80 00 00 	movabs $0x802aa9,%rax
  802e5e:	00 00 00 
  802e61:	ff d0                	callq  *%rax
  802e63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802e67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e6b:	48 89 c7             	mov    %rax,%rdi
  802e6e:	48 b8 a9 2a 80 00 00 	movabs $0x802aa9,%rax
  802e75:	00 00 00 
  802e78:	ff d0                	callq  *%rax
  802e7a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e82:	48 c1 e8 15          	shr    $0x15,%rax
  802e86:	48 89 c2             	mov    %rax,%rdx
  802e89:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802e90:	01 00 00 
  802e93:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e97:	83 e0 01             	and    $0x1,%eax
  802e9a:	48 85 c0             	test   %rax,%rax
  802e9d:	74 73                	je     802f12 <dup+0x11d>
  802e9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea3:	48 c1 e8 0c          	shr    $0xc,%rax
  802ea7:	48 89 c2             	mov    %rax,%rdx
  802eaa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802eb1:	01 00 00 
  802eb4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802eb8:	83 e0 01             	and    $0x1,%eax
  802ebb:	48 85 c0             	test   %rax,%rax
  802ebe:	74 52                	je     802f12 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802ec0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec4:	48 c1 e8 0c          	shr    $0xc,%rax
  802ec8:	48 89 c2             	mov    %rax,%rdx
  802ecb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ed2:	01 00 00 
  802ed5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ed9:	25 07 0e 00 00       	and    $0xe07,%eax
  802ede:	89 c1                	mov    %eax,%ecx
  802ee0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ee4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee8:	41 89 c8             	mov    %ecx,%r8d
  802eeb:	48 89 d1             	mov    %rdx,%rcx
  802eee:	ba 00 00 00 00       	mov    $0x0,%edx
  802ef3:	48 89 c6             	mov    %rax,%rsi
  802ef6:	bf 00 00 00 00       	mov    $0x0,%edi
  802efb:	48 b8 d9 1b 80 00 00 	movabs $0x801bd9,%rax
  802f02:	00 00 00 
  802f05:	ff d0                	callq  *%rax
  802f07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f0e:	79 02                	jns    802f12 <dup+0x11d>
			goto err;
  802f10:	eb 57                	jmp    802f69 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802f12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f16:	48 c1 e8 0c          	shr    $0xc,%rax
  802f1a:	48 89 c2             	mov    %rax,%rdx
  802f1d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f24:	01 00 00 
  802f27:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f2b:	25 07 0e 00 00       	and    $0xe07,%eax
  802f30:	89 c1                	mov    %eax,%ecx
  802f32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f3a:	41 89 c8             	mov    %ecx,%r8d
  802f3d:	48 89 d1             	mov    %rdx,%rcx
  802f40:	ba 00 00 00 00       	mov    $0x0,%edx
  802f45:	48 89 c6             	mov    %rax,%rsi
  802f48:	bf 00 00 00 00       	mov    $0x0,%edi
  802f4d:	48 b8 d9 1b 80 00 00 	movabs $0x801bd9,%rax
  802f54:	00 00 00 
  802f57:	ff d0                	callq  *%rax
  802f59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f60:	79 02                	jns    802f64 <dup+0x16f>
		goto err;
  802f62:	eb 05                	jmp    802f69 <dup+0x174>

	return newfdnum;
  802f64:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802f67:	eb 33                	jmp    802f9c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802f69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f6d:	48 89 c6             	mov    %rax,%rsi
  802f70:	bf 00 00 00 00       	mov    $0x0,%edi
  802f75:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  802f7c:	00 00 00 
  802f7f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802f81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f85:	48 89 c6             	mov    %rax,%rsi
  802f88:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8d:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  802f94:	00 00 00 
  802f97:	ff d0                	callq  *%rax
	return r;
  802f99:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f9c:	c9                   	leaveq 
  802f9d:	c3                   	retq   

0000000000802f9e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802f9e:	55                   	push   %rbp
  802f9f:	48 89 e5             	mov    %rsp,%rbp
  802fa2:	48 83 ec 40          	sub    $0x40,%rsp
  802fa6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802fa9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fad:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fb1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fb5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fb8:	48 89 d6             	mov    %rdx,%rsi
  802fbb:	89 c7                	mov    %eax,%edi
  802fbd:	48 b8 6c 2b 80 00 00 	movabs $0x802b6c,%rax
  802fc4:	00 00 00 
  802fc7:	ff d0                	callq  *%rax
  802fc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd0:	78 24                	js     802ff6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd6:	8b 00                	mov    (%rax),%eax
  802fd8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fdc:	48 89 d6             	mov    %rdx,%rsi
  802fdf:	89 c7                	mov    %eax,%edi
  802fe1:	48 b8 c5 2c 80 00 00 	movabs $0x802cc5,%rax
  802fe8:	00 00 00 
  802feb:	ff d0                	callq  *%rax
  802fed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff4:	79 05                	jns    802ffb <read+0x5d>
		return r;
  802ff6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff9:	eb 76                	jmp    803071 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802ffb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fff:	8b 40 08             	mov    0x8(%rax),%eax
  803002:	83 e0 03             	and    $0x3,%eax
  803005:	83 f8 01             	cmp    $0x1,%eax
  803008:	75 3a                	jne    803044 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80300a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803011:	00 00 00 
  803014:	48 8b 00             	mov    (%rax),%rax
  803017:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80301d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803020:	89 c6                	mov    %eax,%esi
  803022:	48 bf 17 4c 80 00 00 	movabs $0x804c17,%rdi
  803029:	00 00 00 
  80302c:	b8 00 00 00 00       	mov    $0x0,%eax
  803031:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  803038:	00 00 00 
  80303b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80303d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803042:	eb 2d                	jmp    803071 <read+0xd3>
	}
	if (!dev->dev_read)
  803044:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803048:	48 8b 40 10          	mov    0x10(%rax),%rax
  80304c:	48 85 c0             	test   %rax,%rax
  80304f:	75 07                	jne    803058 <read+0xba>
		return -E_NOT_SUPP;
  803051:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803056:	eb 19                	jmp    803071 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803058:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305c:	48 8b 40 10          	mov    0x10(%rax),%rax
  803060:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803064:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803068:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80306c:	48 89 cf             	mov    %rcx,%rdi
  80306f:	ff d0                	callq  *%rax
}
  803071:	c9                   	leaveq 
  803072:	c3                   	retq   

0000000000803073 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803073:	55                   	push   %rbp
  803074:	48 89 e5             	mov    %rsp,%rbp
  803077:	48 83 ec 30          	sub    $0x30,%rsp
  80307b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80307e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803082:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803086:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80308d:	eb 49                	jmp    8030d8 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80308f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803092:	48 98                	cltq   
  803094:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803098:	48 29 c2             	sub    %rax,%rdx
  80309b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80309e:	48 63 c8             	movslq %eax,%rcx
  8030a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030a5:	48 01 c1             	add    %rax,%rcx
  8030a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030ab:	48 89 ce             	mov    %rcx,%rsi
  8030ae:	89 c7                	mov    %eax,%edi
  8030b0:	48 b8 9e 2f 80 00 00 	movabs $0x802f9e,%rax
  8030b7:	00 00 00 
  8030ba:	ff d0                	callq  *%rax
  8030bc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8030bf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030c3:	79 05                	jns    8030ca <readn+0x57>
			return m;
  8030c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030c8:	eb 1c                	jmp    8030e6 <readn+0x73>
		if (m == 0)
  8030ca:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030ce:	75 02                	jne    8030d2 <readn+0x5f>
			break;
  8030d0:	eb 11                	jmp    8030e3 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8030d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8030d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030db:	48 98                	cltq   
  8030dd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8030e1:	72 ac                	jb     80308f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8030e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8030e6:	c9                   	leaveq 
  8030e7:	c3                   	retq   

00000000008030e8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8030e8:	55                   	push   %rbp
  8030e9:	48 89 e5             	mov    %rsp,%rbp
  8030ec:	48 83 ec 40          	sub    $0x40,%rsp
  8030f0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030f3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8030f7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030fb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030ff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803102:	48 89 d6             	mov    %rdx,%rsi
  803105:	89 c7                	mov    %eax,%edi
  803107:	48 b8 6c 2b 80 00 00 	movabs $0x802b6c,%rax
  80310e:	00 00 00 
  803111:	ff d0                	callq  *%rax
  803113:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803116:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80311a:	78 24                	js     803140 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80311c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803120:	8b 00                	mov    (%rax),%eax
  803122:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803126:	48 89 d6             	mov    %rdx,%rsi
  803129:	89 c7                	mov    %eax,%edi
  80312b:	48 b8 c5 2c 80 00 00 	movabs $0x802cc5,%rax
  803132:	00 00 00 
  803135:	ff d0                	callq  *%rax
  803137:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80313a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80313e:	79 05                	jns    803145 <write+0x5d>
		return r;
  803140:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803143:	eb 75                	jmp    8031ba <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803145:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803149:	8b 40 08             	mov    0x8(%rax),%eax
  80314c:	83 e0 03             	and    $0x3,%eax
  80314f:	85 c0                	test   %eax,%eax
  803151:	75 3a                	jne    80318d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803153:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80315a:	00 00 00 
  80315d:	48 8b 00             	mov    (%rax),%rax
  803160:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803166:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803169:	89 c6                	mov    %eax,%esi
  80316b:	48 bf 33 4c 80 00 00 	movabs $0x804c33,%rdi
  803172:	00 00 00 
  803175:	b8 00 00 00 00       	mov    $0x0,%eax
  80317a:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  803181:	00 00 00 
  803184:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803186:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80318b:	eb 2d                	jmp    8031ba <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80318d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803191:	48 8b 40 18          	mov    0x18(%rax),%rax
  803195:	48 85 c0             	test   %rax,%rax
  803198:	75 07                	jne    8031a1 <write+0xb9>
		return -E_NOT_SUPP;
  80319a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80319f:	eb 19                	jmp    8031ba <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8031a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8031a9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8031ad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8031b1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8031b5:	48 89 cf             	mov    %rcx,%rdi
  8031b8:	ff d0                	callq  *%rax
}
  8031ba:	c9                   	leaveq 
  8031bb:	c3                   	retq   

00000000008031bc <seek>:

int
seek(int fdnum, off_t offset)
{
  8031bc:	55                   	push   %rbp
  8031bd:	48 89 e5             	mov    %rsp,%rbp
  8031c0:	48 83 ec 18          	sub    $0x18,%rsp
  8031c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031c7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031d1:	48 89 d6             	mov    %rdx,%rsi
  8031d4:	89 c7                	mov    %eax,%edi
  8031d6:	48 b8 6c 2b 80 00 00 	movabs $0x802b6c,%rax
  8031dd:	00 00 00 
  8031e0:	ff d0                	callq  *%rax
  8031e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e9:	79 05                	jns    8031f0 <seek+0x34>
		return r;
  8031eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ee:	eb 0f                	jmp    8031ff <seek+0x43>
	fd->fd_offset = offset;
  8031f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031f7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8031fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ff:	c9                   	leaveq 
  803200:	c3                   	retq   

0000000000803201 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803201:	55                   	push   %rbp
  803202:	48 89 e5             	mov    %rsp,%rbp
  803205:	48 83 ec 30          	sub    $0x30,%rsp
  803209:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80320c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80320f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803213:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803216:	48 89 d6             	mov    %rdx,%rsi
  803219:	89 c7                	mov    %eax,%edi
  80321b:	48 b8 6c 2b 80 00 00 	movabs $0x802b6c,%rax
  803222:	00 00 00 
  803225:	ff d0                	callq  *%rax
  803227:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80322a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80322e:	78 24                	js     803254 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803234:	8b 00                	mov    (%rax),%eax
  803236:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80323a:	48 89 d6             	mov    %rdx,%rsi
  80323d:	89 c7                	mov    %eax,%edi
  80323f:	48 b8 c5 2c 80 00 00 	movabs $0x802cc5,%rax
  803246:	00 00 00 
  803249:	ff d0                	callq  *%rax
  80324b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80324e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803252:	79 05                	jns    803259 <ftruncate+0x58>
		return r;
  803254:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803257:	eb 72                	jmp    8032cb <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803259:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80325d:	8b 40 08             	mov    0x8(%rax),%eax
  803260:	83 e0 03             	and    $0x3,%eax
  803263:	85 c0                	test   %eax,%eax
  803265:	75 3a                	jne    8032a1 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803267:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80326e:	00 00 00 
  803271:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803274:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80327a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80327d:	89 c6                	mov    %eax,%esi
  80327f:	48 bf 50 4c 80 00 00 	movabs $0x804c50,%rdi
  803286:	00 00 00 
  803289:	b8 00 00 00 00       	mov    $0x0,%eax
  80328e:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  803295:	00 00 00 
  803298:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80329a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80329f:	eb 2a                	jmp    8032cb <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8032a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8032a9:	48 85 c0             	test   %rax,%rax
  8032ac:	75 07                	jne    8032b5 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8032ae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032b3:	eb 16                	jmp    8032cb <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8032b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8032bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032c1:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8032c4:	89 ce                	mov    %ecx,%esi
  8032c6:	48 89 d7             	mov    %rdx,%rdi
  8032c9:	ff d0                	callq  *%rax
}
  8032cb:	c9                   	leaveq 
  8032cc:	c3                   	retq   

00000000008032cd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8032cd:	55                   	push   %rbp
  8032ce:	48 89 e5             	mov    %rsp,%rbp
  8032d1:	48 83 ec 30          	sub    $0x30,%rsp
  8032d5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8032d8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8032dc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8032e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8032e3:	48 89 d6             	mov    %rdx,%rsi
  8032e6:	89 c7                	mov    %eax,%edi
  8032e8:	48 b8 6c 2b 80 00 00 	movabs $0x802b6c,%rax
  8032ef:	00 00 00 
  8032f2:	ff d0                	callq  *%rax
  8032f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032fb:	78 24                	js     803321 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8032fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803301:	8b 00                	mov    (%rax),%eax
  803303:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803307:	48 89 d6             	mov    %rdx,%rsi
  80330a:	89 c7                	mov    %eax,%edi
  80330c:	48 b8 c5 2c 80 00 00 	movabs $0x802cc5,%rax
  803313:	00 00 00 
  803316:	ff d0                	callq  *%rax
  803318:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80331b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80331f:	79 05                	jns    803326 <fstat+0x59>
		return r;
  803321:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803324:	eb 5e                	jmp    803384 <fstat+0xb7>
	if (!dev->dev_stat)
  803326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80332e:	48 85 c0             	test   %rax,%rax
  803331:	75 07                	jne    80333a <fstat+0x6d>
		return -E_NOT_SUPP;
  803333:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803338:	eb 4a                	jmp    803384 <fstat+0xb7>
	stat->st_name[0] = 0;
  80333a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80333e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803341:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803345:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80334c:	00 00 00 
	stat->st_isdir = 0;
  80334f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803353:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80335a:	00 00 00 
	stat->st_dev = dev;
  80335d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803361:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803365:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80336c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803370:	48 8b 40 28          	mov    0x28(%rax),%rax
  803374:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803378:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80337c:	48 89 ce             	mov    %rcx,%rsi
  80337f:	48 89 d7             	mov    %rdx,%rdi
  803382:	ff d0                	callq  *%rax
}
  803384:	c9                   	leaveq 
  803385:	c3                   	retq   

0000000000803386 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803386:	55                   	push   %rbp
  803387:	48 89 e5             	mov    %rsp,%rbp
  80338a:	48 83 ec 20          	sub    $0x20,%rsp
  80338e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803392:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803396:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80339a:	be 00 00 00 00       	mov    $0x0,%esi
  80339f:	48 89 c7             	mov    %rax,%rdi
  8033a2:	48 b8 74 34 80 00 00 	movabs $0x803474,%rax
  8033a9:	00 00 00 
  8033ac:	ff d0                	callq  *%rax
  8033ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b5:	79 05                	jns    8033bc <stat+0x36>
		return fd;
  8033b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ba:	eb 2f                	jmp    8033eb <stat+0x65>
	r = fstat(fd, stat);
  8033bc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8033c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c3:	48 89 d6             	mov    %rdx,%rsi
  8033c6:	89 c7                	mov    %eax,%edi
  8033c8:	48 b8 cd 32 80 00 00 	movabs $0x8032cd,%rax
  8033cf:	00 00 00 
  8033d2:	ff d0                	callq  *%rax
  8033d4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8033d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033da:	89 c7                	mov    %eax,%edi
  8033dc:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  8033e3:	00 00 00 
  8033e6:	ff d0                	callq  *%rax
	return r;
  8033e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8033eb:	c9                   	leaveq 
  8033ec:	c3                   	retq   

00000000008033ed <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8033ed:	55                   	push   %rbp
  8033ee:	48 89 e5             	mov    %rsp,%rbp
  8033f1:	48 83 ec 10          	sub    $0x10,%rsp
  8033f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8033fc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803403:	00 00 00 
  803406:	8b 00                	mov    (%rax),%eax
  803408:	85 c0                	test   %eax,%eax
  80340a:	75 1d                	jne    803429 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80340c:	bf 01 00 00 00       	mov    $0x1,%edi
  803411:	48 b8 14 2a 80 00 00 	movabs $0x802a14,%rax
  803418:	00 00 00 
  80341b:	ff d0                	callq  *%rax
  80341d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  803424:	00 00 00 
  803427:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803429:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803430:	00 00 00 
  803433:	8b 00                	mov    (%rax),%eax
  803435:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803438:	b9 07 00 00 00       	mov    $0x7,%ecx
  80343d:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803444:	00 00 00 
  803447:	89 c7                	mov    %eax,%edi
  803449:	48 b8 15 29 80 00 00 	movabs $0x802915,%rax
  803450:	00 00 00 
  803453:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803455:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803459:	ba 00 00 00 00       	mov    $0x0,%edx
  80345e:	48 89 c6             	mov    %rax,%rsi
  803461:	bf 00 00 00 00       	mov    $0x0,%edi
  803466:	48 b8 62 28 80 00 00 	movabs $0x802862,%rax
  80346d:	00 00 00 
  803470:	ff d0                	callq  *%rax
}
  803472:	c9                   	leaveq 
  803473:	c3                   	retq   

0000000000803474 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803474:	55                   	push   %rbp
  803475:	48 89 e5             	mov    %rsp,%rbp
  803478:	48 83 ec 20          	sub    $0x20,%rsp
  80347c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803480:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  803483:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803487:	48 89 c7             	mov    %rax,%rdi
  80348a:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  803491:	00 00 00 
  803494:	ff d0                	callq  *%rax
  803496:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80349b:	7e 0a                	jle    8034a7 <open+0x33>
		return -E_BAD_PATH;
  80349d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034a2:	e9 a5 00 00 00       	jmpq   80354c <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  8034a7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8034ab:	48 89 c7             	mov    %rax,%rdi
  8034ae:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  8034b5:	00 00 00 
  8034b8:	ff d0                	callq  *%rax
  8034ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c1:	79 08                	jns    8034cb <open+0x57>
		return ret;
  8034c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c6:	e9 81 00 00 00       	jmpq   80354c <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  8034cb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034d2:	00 00 00 
  8034d5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8034d8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  8034de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e2:	48 89 c6             	mov    %rax,%rsi
  8034e5:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8034ec:	00 00 00 
  8034ef:	48 b8 5a 12 80 00 00 	movabs $0x80125a,%rax
  8034f6:	00 00 00 
  8034f9:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  8034fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ff:	48 89 c6             	mov    %rax,%rsi
  803502:	bf 01 00 00 00       	mov    $0x1,%edi
  803507:	48 b8 ed 33 80 00 00 	movabs $0x8033ed,%rax
  80350e:	00 00 00 
  803511:	ff d0                	callq  *%rax
  803513:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803516:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80351a:	79 1d                	jns    803539 <open+0xc5>
	{
		fd_close(fd,0);
  80351c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803520:	be 00 00 00 00       	mov    $0x0,%esi
  803525:	48 89 c7             	mov    %rax,%rdi
  803528:	48 b8 fc 2b 80 00 00 	movabs $0x802bfc,%rax
  80352f:	00 00 00 
  803532:	ff d0                	callq  *%rax
		return ret;
  803534:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803537:	eb 13                	jmp    80354c <open+0xd8>
	}
	return fd2num (fd);
  803539:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80353d:	48 89 c7             	mov    %rax,%rdi
  803540:	48 b8 86 2a 80 00 00 	movabs $0x802a86,%rax
  803547:	00 00 00 
  80354a:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  80354c:	c9                   	leaveq 
  80354d:	c3                   	retq   

000000000080354e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80354e:	55                   	push   %rbp
  80354f:	48 89 e5             	mov    %rsp,%rbp
  803552:	48 83 ec 10          	sub    $0x10,%rsp
  803556:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80355a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80355e:	8b 50 0c             	mov    0xc(%rax),%edx
  803561:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803568:	00 00 00 
  80356b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80356d:	be 00 00 00 00       	mov    $0x0,%esi
  803572:	bf 06 00 00 00       	mov    $0x6,%edi
  803577:	48 b8 ed 33 80 00 00 	movabs $0x8033ed,%rax
  80357e:	00 00 00 
  803581:	ff d0                	callq  *%rax
}
  803583:	c9                   	leaveq 
  803584:	c3                   	retq   

0000000000803585 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803585:	55                   	push   %rbp
  803586:	48 89 e5             	mov    %rsp,%rbp
  803589:	48 83 ec 30          	sub    $0x30,%rsp
  80358d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803591:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803595:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  803599:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80359d:	8b 50 0c             	mov    0xc(%rax),%edx
  8035a0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035a7:	00 00 00 
  8035aa:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  8035ac:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035b3:	00 00 00 
  8035b6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035ba:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  8035be:	be 00 00 00 00       	mov    $0x0,%esi
  8035c3:	bf 03 00 00 00       	mov    $0x3,%edi
  8035c8:	48 b8 ed 33 80 00 00 	movabs $0x8033ed,%rax
  8035cf:	00 00 00 
  8035d2:	ff d0                	callq  *%rax
  8035d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035db:	79 05                	jns    8035e2 <devfile_read+0x5d>
		return ret;
  8035dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e0:	eb 26                	jmp    803608 <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  8035e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e5:	48 63 d0             	movslq %eax,%rdx
  8035e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035ec:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8035f3:	00 00 00 
  8035f6:	48 89 c7             	mov    %rax,%rdi
  8035f9:	48 b8 7e 15 80 00 00 	movabs $0x80157e,%rax
  803600:	00 00 00 
  803603:	ff d0                	callq  *%rax
	return ret;
  803605:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  803608:	c9                   	leaveq 
  803609:	c3                   	retq   

000000000080360a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80360a:	55                   	push   %rbp
  80360b:	48 89 e5             	mov    %rsp,%rbp
  80360e:	48 83 ec 30          	sub    $0x30,%rsp
  803612:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803616:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80361a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  80361e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803622:	8b 50 0c             	mov    0xc(%rax),%edx
  803625:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80362c:	00 00 00 
  80362f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  803631:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  803636:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80363d:	00 
  80363e:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  803643:	48 89 c2             	mov    %rax,%rdx
  803646:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80364d:	00 00 00 
  803650:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  803654:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80365b:	00 00 00 
  80365e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803662:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803666:	48 89 c6             	mov    %rax,%rsi
  803669:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803670:	00 00 00 
  803673:	48 b8 7e 15 80 00 00 	movabs $0x80157e,%rax
  80367a:	00 00 00 
  80367d:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  80367f:	be 00 00 00 00       	mov    $0x0,%esi
  803684:	bf 04 00 00 00       	mov    $0x4,%edi
  803689:	48 b8 ed 33 80 00 00 	movabs $0x8033ed,%rax
  803690:	00 00 00 
  803693:	ff d0                	callq  *%rax
  803695:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803698:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80369c:	79 05                	jns    8036a3 <devfile_write+0x99>
		return ret;
  80369e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a1:	eb 03                	jmp    8036a6 <devfile_write+0x9c>
	
	return ret;
  8036a3:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  8036a6:	c9                   	leaveq 
  8036a7:	c3                   	retq   

00000000008036a8 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8036a8:	55                   	push   %rbp
  8036a9:	48 89 e5             	mov    %rsp,%rbp
  8036ac:	48 83 ec 20          	sub    $0x20,%rsp
  8036b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8036b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036bc:	8b 50 0c             	mov    0xc(%rax),%edx
  8036bf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8036c6:	00 00 00 
  8036c9:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8036cb:	be 00 00 00 00       	mov    $0x0,%esi
  8036d0:	bf 05 00 00 00       	mov    $0x5,%edi
  8036d5:	48 b8 ed 33 80 00 00 	movabs $0x8033ed,%rax
  8036dc:	00 00 00 
  8036df:	ff d0                	callq  *%rax
  8036e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036e8:	79 05                	jns    8036ef <devfile_stat+0x47>
		return r;
  8036ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ed:	eb 56                	jmp    803745 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8036ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036f3:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8036fa:	00 00 00 
  8036fd:	48 89 c7             	mov    %rax,%rdi
  803700:	48 b8 5a 12 80 00 00 	movabs $0x80125a,%rax
  803707:	00 00 00 
  80370a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80370c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803713:	00 00 00 
  803716:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80371c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803720:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803726:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80372d:	00 00 00 
  803730:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803736:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80373a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803745:	c9                   	leaveq 
  803746:	c3                   	retq   

0000000000803747 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803747:	55                   	push   %rbp
  803748:	48 89 e5             	mov    %rsp,%rbp
  80374b:	48 83 ec 10          	sub    $0x10,%rsp
  80374f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803753:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803756:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80375a:	8b 50 0c             	mov    0xc(%rax),%edx
  80375d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803764:	00 00 00 
  803767:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803769:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803770:	00 00 00 
  803773:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803776:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803779:	be 00 00 00 00       	mov    $0x0,%esi
  80377e:	bf 02 00 00 00       	mov    $0x2,%edi
  803783:	48 b8 ed 33 80 00 00 	movabs $0x8033ed,%rax
  80378a:	00 00 00 
  80378d:	ff d0                	callq  *%rax
}
  80378f:	c9                   	leaveq 
  803790:	c3                   	retq   

0000000000803791 <remove>:

// Delete a file
int
remove(const char *path)
{
  803791:	55                   	push   %rbp
  803792:	48 89 e5             	mov    %rsp,%rbp
  803795:	48 83 ec 10          	sub    $0x10,%rsp
  803799:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80379d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037a1:	48 89 c7             	mov    %rax,%rdi
  8037a4:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  8037ab:	00 00 00 
  8037ae:	ff d0                	callq  *%rax
  8037b0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8037b5:	7e 07                	jle    8037be <remove+0x2d>
		return -E_BAD_PATH;
  8037b7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8037bc:	eb 33                	jmp    8037f1 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8037be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c2:	48 89 c6             	mov    %rax,%rsi
  8037c5:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8037cc:	00 00 00 
  8037cf:	48 b8 5a 12 80 00 00 	movabs $0x80125a,%rax
  8037d6:	00 00 00 
  8037d9:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8037db:	be 00 00 00 00       	mov    $0x0,%esi
  8037e0:	bf 07 00 00 00       	mov    $0x7,%edi
  8037e5:	48 b8 ed 33 80 00 00 	movabs $0x8033ed,%rax
  8037ec:	00 00 00 
  8037ef:	ff d0                	callq  *%rax
}
  8037f1:	c9                   	leaveq 
  8037f2:	c3                   	retq   

00000000008037f3 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8037f3:	55                   	push   %rbp
  8037f4:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8037f7:	be 00 00 00 00       	mov    $0x0,%esi
  8037fc:	bf 08 00 00 00       	mov    $0x8,%edi
  803801:	48 b8 ed 33 80 00 00 	movabs $0x8033ed,%rax
  803808:	00 00 00 
  80380b:	ff d0                	callq  *%rax
}
  80380d:	5d                   	pop    %rbp
  80380e:	c3                   	retq   

000000000080380f <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80380f:	55                   	push   %rbp
  803810:	48 89 e5             	mov    %rsp,%rbp
  803813:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80381a:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803821:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803828:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80382f:	be 00 00 00 00       	mov    $0x0,%esi
  803834:	48 89 c7             	mov    %rax,%rdi
  803837:	48 b8 74 34 80 00 00 	movabs $0x803474,%rax
  80383e:	00 00 00 
  803841:	ff d0                	callq  *%rax
  803843:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803846:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80384a:	79 28                	jns    803874 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80384c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384f:	89 c6                	mov    %eax,%esi
  803851:	48 bf 76 4c 80 00 00 	movabs $0x804c76,%rdi
  803858:	00 00 00 
  80385b:	b8 00 00 00 00       	mov    $0x0,%eax
  803860:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  803867:	00 00 00 
  80386a:	ff d2                	callq  *%rdx
		return fd_src;
  80386c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80386f:	e9 74 01 00 00       	jmpq   8039e8 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803874:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80387b:	be 01 01 00 00       	mov    $0x101,%esi
  803880:	48 89 c7             	mov    %rax,%rdi
  803883:	48 b8 74 34 80 00 00 	movabs $0x803474,%rax
  80388a:	00 00 00 
  80388d:	ff d0                	callq  *%rax
  80388f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803892:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803896:	79 39                	jns    8038d1 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803898:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80389b:	89 c6                	mov    %eax,%esi
  80389d:	48 bf 8c 4c 80 00 00 	movabs $0x804c8c,%rdi
  8038a4:	00 00 00 
  8038a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ac:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  8038b3:	00 00 00 
  8038b6:	ff d2                	callq  *%rdx
		close(fd_src);
  8038b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038bb:	89 c7                	mov    %eax,%edi
  8038bd:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  8038c4:	00 00 00 
  8038c7:	ff d0                	callq  *%rax
		return fd_dest;
  8038c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038cc:	e9 17 01 00 00       	jmpq   8039e8 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8038d1:	eb 74                	jmp    803947 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8038d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038d6:	48 63 d0             	movslq %eax,%rdx
  8038d9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8038e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038e3:	48 89 ce             	mov    %rcx,%rsi
  8038e6:	89 c7                	mov    %eax,%edi
  8038e8:	48 b8 e8 30 80 00 00 	movabs $0x8030e8,%rax
  8038ef:	00 00 00 
  8038f2:	ff d0                	callq  *%rax
  8038f4:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8038f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8038fb:	79 4a                	jns    803947 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8038fd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803900:	89 c6                	mov    %eax,%esi
  803902:	48 bf a6 4c 80 00 00 	movabs $0x804ca6,%rdi
  803909:	00 00 00 
  80390c:	b8 00 00 00 00       	mov    $0x0,%eax
  803911:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  803918:	00 00 00 
  80391b:	ff d2                	callq  *%rdx
			close(fd_src);
  80391d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803920:	89 c7                	mov    %eax,%edi
  803922:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  803929:	00 00 00 
  80392c:	ff d0                	callq  *%rax
			close(fd_dest);
  80392e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803931:	89 c7                	mov    %eax,%edi
  803933:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  80393a:	00 00 00 
  80393d:	ff d0                	callq  *%rax
			return write_size;
  80393f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803942:	e9 a1 00 00 00       	jmpq   8039e8 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803947:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80394e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803951:	ba 00 02 00 00       	mov    $0x200,%edx
  803956:	48 89 ce             	mov    %rcx,%rsi
  803959:	89 c7                	mov    %eax,%edi
  80395b:	48 b8 9e 2f 80 00 00 	movabs $0x802f9e,%rax
  803962:	00 00 00 
  803965:	ff d0                	callq  *%rax
  803967:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80396a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80396e:	0f 8f 5f ff ff ff    	jg     8038d3 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803974:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803978:	79 47                	jns    8039c1 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80397a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80397d:	89 c6                	mov    %eax,%esi
  80397f:	48 bf b9 4c 80 00 00 	movabs $0x804cb9,%rdi
  803986:	00 00 00 
  803989:	b8 00 00 00 00       	mov    $0x0,%eax
  80398e:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  803995:	00 00 00 
  803998:	ff d2                	callq  *%rdx
		close(fd_src);
  80399a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80399d:	89 c7                	mov    %eax,%edi
  80399f:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  8039a6:	00 00 00 
  8039a9:	ff d0                	callq  *%rax
		close(fd_dest);
  8039ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039ae:	89 c7                	mov    %eax,%edi
  8039b0:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  8039b7:	00 00 00 
  8039ba:	ff d0                	callq  *%rax
		return read_size;
  8039bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039bf:	eb 27                	jmp    8039e8 <copy+0x1d9>
	}
	close(fd_src);
  8039c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c4:	89 c7                	mov    %eax,%edi
  8039c6:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  8039cd:	00 00 00 
  8039d0:	ff d0                	callq  *%rax
	close(fd_dest);
  8039d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039d5:	89 c7                	mov    %eax,%edi
  8039d7:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  8039de:	00 00 00 
  8039e1:	ff d0                	callq  *%rax
	return 0;
  8039e3:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8039e8:	c9                   	leaveq 
  8039e9:	c3                   	retq   

00000000008039ea <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8039ea:	55                   	push   %rbp
  8039eb:	48 89 e5             	mov    %rsp,%rbp
  8039ee:	48 83 ec 18          	sub    $0x18,%rsp
  8039f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8039f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039fa:	48 c1 e8 15          	shr    $0x15,%rax
  8039fe:	48 89 c2             	mov    %rax,%rdx
  803a01:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803a08:	01 00 00 
  803a0b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a0f:	83 e0 01             	and    $0x1,%eax
  803a12:	48 85 c0             	test   %rax,%rax
  803a15:	75 07                	jne    803a1e <pageref+0x34>
		return 0;
  803a17:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1c:	eb 53                	jmp    803a71 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803a1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a22:	48 c1 e8 0c          	shr    $0xc,%rax
  803a26:	48 89 c2             	mov    %rax,%rdx
  803a29:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a30:	01 00 00 
  803a33:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a37:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803a3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a3f:	83 e0 01             	and    $0x1,%eax
  803a42:	48 85 c0             	test   %rax,%rax
  803a45:	75 07                	jne    803a4e <pageref+0x64>
		return 0;
  803a47:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4c:	eb 23                	jmp    803a71 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803a4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a52:	48 c1 e8 0c          	shr    $0xc,%rax
  803a56:	48 89 c2             	mov    %rax,%rdx
  803a59:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803a60:	00 00 00 
  803a63:	48 c1 e2 04          	shl    $0x4,%rdx
  803a67:	48 01 d0             	add    %rdx,%rax
  803a6a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803a6e:	0f b7 c0             	movzwl %ax,%eax
}
  803a71:	c9                   	leaveq 
  803a72:	c3                   	retq   

0000000000803a73 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803a73:	55                   	push   %rbp
  803a74:	48 89 e5             	mov    %rsp,%rbp
  803a77:	53                   	push   %rbx
  803a78:	48 83 ec 38          	sub    $0x38,%rsp
  803a7c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803a80:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803a84:	48 89 c7             	mov    %rax,%rdi
  803a87:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  803a8e:	00 00 00 
  803a91:	ff d0                	callq  *%rax
  803a93:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a96:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a9a:	0f 88 bf 01 00 00    	js     803c5f <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803aa0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa4:	ba 07 04 00 00       	mov    $0x407,%edx
  803aa9:	48 89 c6             	mov    %rax,%rsi
  803aac:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab1:	48 b8 89 1b 80 00 00 	movabs $0x801b89,%rax
  803ab8:	00 00 00 
  803abb:	ff d0                	callq  *%rax
  803abd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ac0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ac4:	0f 88 95 01 00 00    	js     803c5f <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803aca:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803ace:	48 89 c7             	mov    %rax,%rdi
  803ad1:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  803ad8:	00 00 00 
  803adb:	ff d0                	callq  *%rax
  803add:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ae0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ae4:	0f 88 5d 01 00 00    	js     803c47 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803aea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aee:	ba 07 04 00 00       	mov    $0x407,%edx
  803af3:	48 89 c6             	mov    %rax,%rsi
  803af6:	bf 00 00 00 00       	mov    $0x0,%edi
  803afb:	48 b8 89 1b 80 00 00 	movabs $0x801b89,%rax
  803b02:	00 00 00 
  803b05:	ff d0                	callq  *%rax
  803b07:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b0e:	0f 88 33 01 00 00    	js     803c47 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803b14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b18:	48 89 c7             	mov    %rax,%rdi
  803b1b:	48 b8 a9 2a 80 00 00 	movabs $0x802aa9,%rax
  803b22:	00 00 00 
  803b25:	ff d0                	callq  *%rax
  803b27:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b2f:	ba 07 04 00 00       	mov    $0x407,%edx
  803b34:	48 89 c6             	mov    %rax,%rsi
  803b37:	bf 00 00 00 00       	mov    $0x0,%edi
  803b3c:	48 b8 89 1b 80 00 00 	movabs $0x801b89,%rax
  803b43:	00 00 00 
  803b46:	ff d0                	callq  *%rax
  803b48:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b4f:	79 05                	jns    803b56 <pipe+0xe3>
		goto err2;
  803b51:	e9 d9 00 00 00       	jmpq   803c2f <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b56:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b5a:	48 89 c7             	mov    %rax,%rdi
  803b5d:	48 b8 a9 2a 80 00 00 	movabs $0x802aa9,%rax
  803b64:	00 00 00 
  803b67:	ff d0                	callq  *%rax
  803b69:	48 89 c2             	mov    %rax,%rdx
  803b6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b70:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803b76:	48 89 d1             	mov    %rdx,%rcx
  803b79:	ba 00 00 00 00       	mov    $0x0,%edx
  803b7e:	48 89 c6             	mov    %rax,%rsi
  803b81:	bf 00 00 00 00       	mov    $0x0,%edi
  803b86:	48 b8 d9 1b 80 00 00 	movabs $0x801bd9,%rax
  803b8d:	00 00 00 
  803b90:	ff d0                	callq  *%rax
  803b92:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b95:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b99:	79 1b                	jns    803bb6 <pipe+0x143>
		goto err3;
  803b9b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803b9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ba0:	48 89 c6             	mov    %rax,%rsi
  803ba3:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba8:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  803baf:	00 00 00 
  803bb2:	ff d0                	callq  *%rax
  803bb4:	eb 79                	jmp    803c2f <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803bb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bba:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803bc1:	00 00 00 
  803bc4:	8b 12                	mov    (%rdx),%edx
  803bc6:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803bc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bcc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803bd3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bd7:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803bde:	00 00 00 
  803be1:	8b 12                	mov    (%rdx),%edx
  803be3:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803be5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803be9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803bf0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bf4:	48 89 c7             	mov    %rax,%rdi
  803bf7:	48 b8 86 2a 80 00 00 	movabs $0x802a86,%rax
  803bfe:	00 00 00 
  803c01:	ff d0                	callq  *%rax
  803c03:	89 c2                	mov    %eax,%edx
  803c05:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c09:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803c0b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c0f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803c13:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c17:	48 89 c7             	mov    %rax,%rdi
  803c1a:	48 b8 86 2a 80 00 00 	movabs $0x802a86,%rax
  803c21:	00 00 00 
  803c24:	ff d0                	callq  *%rax
  803c26:	89 03                	mov    %eax,(%rbx)
	return 0;
  803c28:	b8 00 00 00 00       	mov    $0x0,%eax
  803c2d:	eb 33                	jmp    803c62 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803c2f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c33:	48 89 c6             	mov    %rax,%rsi
  803c36:	bf 00 00 00 00       	mov    $0x0,%edi
  803c3b:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  803c42:	00 00 00 
  803c45:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803c47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c4b:	48 89 c6             	mov    %rax,%rsi
  803c4e:	bf 00 00 00 00       	mov    $0x0,%edi
  803c53:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  803c5a:	00 00 00 
  803c5d:	ff d0                	callq  *%rax
err:
	return r;
  803c5f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803c62:	48 83 c4 38          	add    $0x38,%rsp
  803c66:	5b                   	pop    %rbx
  803c67:	5d                   	pop    %rbp
  803c68:	c3                   	retq   

0000000000803c69 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803c69:	55                   	push   %rbp
  803c6a:	48 89 e5             	mov    %rsp,%rbp
  803c6d:	53                   	push   %rbx
  803c6e:	48 83 ec 28          	sub    $0x28,%rsp
  803c72:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c76:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803c7a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c81:	00 00 00 
  803c84:	48 8b 00             	mov    (%rax),%rax
  803c87:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c8d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803c90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c94:	48 89 c7             	mov    %rax,%rdi
  803c97:	48 b8 ea 39 80 00 00 	movabs $0x8039ea,%rax
  803c9e:	00 00 00 
  803ca1:	ff d0                	callq  *%rax
  803ca3:	89 c3                	mov    %eax,%ebx
  803ca5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ca9:	48 89 c7             	mov    %rax,%rdi
  803cac:	48 b8 ea 39 80 00 00 	movabs $0x8039ea,%rax
  803cb3:	00 00 00 
  803cb6:	ff d0                	callq  *%rax
  803cb8:	39 c3                	cmp    %eax,%ebx
  803cba:	0f 94 c0             	sete   %al
  803cbd:	0f b6 c0             	movzbl %al,%eax
  803cc0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803cc3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cca:	00 00 00 
  803ccd:	48 8b 00             	mov    (%rax),%rax
  803cd0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803cd6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803cd9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cdc:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803cdf:	75 05                	jne    803ce6 <_pipeisclosed+0x7d>
			return ret;
  803ce1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803ce4:	eb 4f                	jmp    803d35 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803ce6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ce9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803cec:	74 42                	je     803d30 <_pipeisclosed+0xc7>
  803cee:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803cf2:	75 3c                	jne    803d30 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803cf4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cfb:	00 00 00 
  803cfe:	48 8b 00             	mov    (%rax),%rax
  803d01:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803d07:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803d0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d0d:	89 c6                	mov    %eax,%esi
  803d0f:	48 bf d9 4c 80 00 00 	movabs $0x804cd9,%rdi
  803d16:	00 00 00 
  803d19:	b8 00 00 00 00       	mov    $0x0,%eax
  803d1e:	49 b8 64 06 80 00 00 	movabs $0x800664,%r8
  803d25:	00 00 00 
  803d28:	41 ff d0             	callq  *%r8
	}
  803d2b:	e9 4a ff ff ff       	jmpq   803c7a <_pipeisclosed+0x11>
  803d30:	e9 45 ff ff ff       	jmpq   803c7a <_pipeisclosed+0x11>
}
  803d35:	48 83 c4 28          	add    $0x28,%rsp
  803d39:	5b                   	pop    %rbx
  803d3a:	5d                   	pop    %rbp
  803d3b:	c3                   	retq   

0000000000803d3c <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803d3c:	55                   	push   %rbp
  803d3d:	48 89 e5             	mov    %rsp,%rbp
  803d40:	48 83 ec 30          	sub    $0x30,%rsp
  803d44:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d47:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d4b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d4e:	48 89 d6             	mov    %rdx,%rsi
  803d51:	89 c7                	mov    %eax,%edi
  803d53:	48 b8 6c 2b 80 00 00 	movabs $0x802b6c,%rax
  803d5a:	00 00 00 
  803d5d:	ff d0                	callq  *%rax
  803d5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d66:	79 05                	jns    803d6d <pipeisclosed+0x31>
		return r;
  803d68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6b:	eb 31                	jmp    803d9e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803d6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d71:	48 89 c7             	mov    %rax,%rdi
  803d74:	48 b8 a9 2a 80 00 00 	movabs $0x802aa9,%rax
  803d7b:	00 00 00 
  803d7e:	ff d0                	callq  *%rax
  803d80:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803d84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d8c:	48 89 d6             	mov    %rdx,%rsi
  803d8f:	48 89 c7             	mov    %rax,%rdi
  803d92:	48 b8 69 3c 80 00 00 	movabs $0x803c69,%rax
  803d99:	00 00 00 
  803d9c:	ff d0                	callq  *%rax
}
  803d9e:	c9                   	leaveq 
  803d9f:	c3                   	retq   

0000000000803da0 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803da0:	55                   	push   %rbp
  803da1:	48 89 e5             	mov    %rsp,%rbp
  803da4:	48 83 ec 40          	sub    $0x40,%rsp
  803da8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803dac:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803db0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803db4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803db8:	48 89 c7             	mov    %rax,%rdi
  803dbb:	48 b8 a9 2a 80 00 00 	movabs $0x802aa9,%rax
  803dc2:	00 00 00 
  803dc5:	ff d0                	callq  *%rax
  803dc7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803dcb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dcf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803dd3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803dda:	00 
  803ddb:	e9 92 00 00 00       	jmpq   803e72 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803de0:	eb 41                	jmp    803e23 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803de2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803de7:	74 09                	je     803df2 <devpipe_read+0x52>
				return i;
  803de9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ded:	e9 92 00 00 00       	jmpq   803e84 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803df2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803df6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dfa:	48 89 d6             	mov    %rdx,%rsi
  803dfd:	48 89 c7             	mov    %rax,%rdi
  803e00:	48 b8 69 3c 80 00 00 	movabs $0x803c69,%rax
  803e07:	00 00 00 
  803e0a:	ff d0                	callq  *%rax
  803e0c:	85 c0                	test   %eax,%eax
  803e0e:	74 07                	je     803e17 <devpipe_read+0x77>
				return 0;
  803e10:	b8 00 00 00 00       	mov    $0x0,%eax
  803e15:	eb 6d                	jmp    803e84 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803e17:	48 b8 4b 1b 80 00 00 	movabs $0x801b4b,%rax
  803e1e:	00 00 00 
  803e21:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803e23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e27:	8b 10                	mov    (%rax),%edx
  803e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e2d:	8b 40 04             	mov    0x4(%rax),%eax
  803e30:	39 c2                	cmp    %eax,%edx
  803e32:	74 ae                	je     803de2 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803e34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e38:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e3c:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e44:	8b 00                	mov    (%rax),%eax
  803e46:	99                   	cltd   
  803e47:	c1 ea 1b             	shr    $0x1b,%edx
  803e4a:	01 d0                	add    %edx,%eax
  803e4c:	83 e0 1f             	and    $0x1f,%eax
  803e4f:	29 d0                	sub    %edx,%eax
  803e51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e55:	48 98                	cltq   
  803e57:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803e5c:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803e5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e62:	8b 00                	mov    (%rax),%eax
  803e64:	8d 50 01             	lea    0x1(%rax),%edx
  803e67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e6b:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e6d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e76:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e7a:	0f 82 60 ff ff ff    	jb     803de0 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803e80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e84:	c9                   	leaveq 
  803e85:	c3                   	retq   

0000000000803e86 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e86:	55                   	push   %rbp
  803e87:	48 89 e5             	mov    %rsp,%rbp
  803e8a:	48 83 ec 40          	sub    $0x40,%rsp
  803e8e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e92:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e96:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e9e:	48 89 c7             	mov    %rax,%rdi
  803ea1:	48 b8 a9 2a 80 00 00 	movabs $0x802aa9,%rax
  803ea8:	00 00 00 
  803eab:	ff d0                	callq  *%rax
  803ead:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803eb1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eb5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803eb9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ec0:	00 
  803ec1:	e9 8e 00 00 00       	jmpq   803f54 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ec6:	eb 31                	jmp    803ef9 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ec8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ecc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ed0:	48 89 d6             	mov    %rdx,%rsi
  803ed3:	48 89 c7             	mov    %rax,%rdi
  803ed6:	48 b8 69 3c 80 00 00 	movabs $0x803c69,%rax
  803edd:	00 00 00 
  803ee0:	ff d0                	callq  *%rax
  803ee2:	85 c0                	test   %eax,%eax
  803ee4:	74 07                	je     803eed <devpipe_write+0x67>
				return 0;
  803ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  803eeb:	eb 79                	jmp    803f66 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803eed:	48 b8 4b 1b 80 00 00 	movabs $0x801b4b,%rax
  803ef4:	00 00 00 
  803ef7:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ef9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803efd:	8b 40 04             	mov    0x4(%rax),%eax
  803f00:	48 63 d0             	movslq %eax,%rdx
  803f03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f07:	8b 00                	mov    (%rax),%eax
  803f09:	48 98                	cltq   
  803f0b:	48 83 c0 20          	add    $0x20,%rax
  803f0f:	48 39 c2             	cmp    %rax,%rdx
  803f12:	73 b4                	jae    803ec8 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803f14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f18:	8b 40 04             	mov    0x4(%rax),%eax
  803f1b:	99                   	cltd   
  803f1c:	c1 ea 1b             	shr    $0x1b,%edx
  803f1f:	01 d0                	add    %edx,%eax
  803f21:	83 e0 1f             	and    $0x1f,%eax
  803f24:	29 d0                	sub    %edx,%eax
  803f26:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f2a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803f2e:	48 01 ca             	add    %rcx,%rdx
  803f31:	0f b6 0a             	movzbl (%rdx),%ecx
  803f34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f38:	48 98                	cltq   
  803f3a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803f3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f42:	8b 40 04             	mov    0x4(%rax),%eax
  803f45:	8d 50 01             	lea    0x1(%rax),%edx
  803f48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f4c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f4f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f58:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f5c:	0f 82 64 ff ff ff    	jb     803ec6 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803f62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f66:	c9                   	leaveq 
  803f67:	c3                   	retq   

0000000000803f68 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803f68:	55                   	push   %rbp
  803f69:	48 89 e5             	mov    %rsp,%rbp
  803f6c:	48 83 ec 20          	sub    $0x20,%rsp
  803f70:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803f78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f7c:	48 89 c7             	mov    %rax,%rdi
  803f7f:	48 b8 a9 2a 80 00 00 	movabs $0x802aa9,%rax
  803f86:	00 00 00 
  803f89:	ff d0                	callq  *%rax
  803f8b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803f8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f93:	48 be ec 4c 80 00 00 	movabs $0x804cec,%rsi
  803f9a:	00 00 00 
  803f9d:	48 89 c7             	mov    %rax,%rdi
  803fa0:	48 b8 5a 12 80 00 00 	movabs $0x80125a,%rax
  803fa7:	00 00 00 
  803faa:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803fac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fb0:	8b 50 04             	mov    0x4(%rax),%edx
  803fb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fb7:	8b 00                	mov    (%rax),%eax
  803fb9:	29 c2                	sub    %eax,%edx
  803fbb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fbf:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803fc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fc9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803fd0:	00 00 00 
	stat->st_dev = &devpipe;
  803fd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fd7:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803fde:	00 00 00 
  803fe1:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803fe8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fed:	c9                   	leaveq 
  803fee:	c3                   	retq   

0000000000803fef <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803fef:	55                   	push   %rbp
  803ff0:	48 89 e5             	mov    %rsp,%rbp
  803ff3:	48 83 ec 10          	sub    $0x10,%rsp
  803ff7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803ffb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fff:	48 89 c6             	mov    %rax,%rsi
  804002:	bf 00 00 00 00       	mov    $0x0,%edi
  804007:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  80400e:	00 00 00 
  804011:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804013:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804017:	48 89 c7             	mov    %rax,%rdi
  80401a:	48 b8 a9 2a 80 00 00 	movabs $0x802aa9,%rax
  804021:	00 00 00 
  804024:	ff d0                	callq  *%rax
  804026:	48 89 c6             	mov    %rax,%rsi
  804029:	bf 00 00 00 00       	mov    $0x0,%edi
  80402e:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  804035:	00 00 00 
  804038:	ff d0                	callq  *%rax
}
  80403a:	c9                   	leaveq 
  80403b:	c3                   	retq   

000000000080403c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80403c:	55                   	push   %rbp
  80403d:	48 89 e5             	mov    %rsp,%rbp
  804040:	48 83 ec 20          	sub    $0x20,%rsp
  804044:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804047:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80404a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80404d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804051:	be 01 00 00 00       	mov    $0x1,%esi
  804056:	48 89 c7             	mov    %rax,%rdi
  804059:	48 b8 41 1a 80 00 00 	movabs $0x801a41,%rax
  804060:	00 00 00 
  804063:	ff d0                	callq  *%rax
}
  804065:	c9                   	leaveq 
  804066:	c3                   	retq   

0000000000804067 <getchar>:

int
getchar(void)
{
  804067:	55                   	push   %rbp
  804068:	48 89 e5             	mov    %rsp,%rbp
  80406b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80406f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804073:	ba 01 00 00 00       	mov    $0x1,%edx
  804078:	48 89 c6             	mov    %rax,%rsi
  80407b:	bf 00 00 00 00       	mov    $0x0,%edi
  804080:	48 b8 9e 2f 80 00 00 	movabs $0x802f9e,%rax
  804087:	00 00 00 
  80408a:	ff d0                	callq  *%rax
  80408c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80408f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804093:	79 05                	jns    80409a <getchar+0x33>
		return r;
  804095:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804098:	eb 14                	jmp    8040ae <getchar+0x47>
	if (r < 1)
  80409a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80409e:	7f 07                	jg     8040a7 <getchar+0x40>
		return -E_EOF;
  8040a0:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8040a5:	eb 07                	jmp    8040ae <getchar+0x47>
	return c;
  8040a7:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8040ab:	0f b6 c0             	movzbl %al,%eax
}
  8040ae:	c9                   	leaveq 
  8040af:	c3                   	retq   

00000000008040b0 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8040b0:	55                   	push   %rbp
  8040b1:	48 89 e5             	mov    %rsp,%rbp
  8040b4:	48 83 ec 20          	sub    $0x20,%rsp
  8040b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8040bb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8040bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040c2:	48 89 d6             	mov    %rdx,%rsi
  8040c5:	89 c7                	mov    %eax,%edi
  8040c7:	48 b8 6c 2b 80 00 00 	movabs $0x802b6c,%rax
  8040ce:	00 00 00 
  8040d1:	ff d0                	callq  *%rax
  8040d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040da:	79 05                	jns    8040e1 <iscons+0x31>
		return r;
  8040dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040df:	eb 1a                	jmp    8040fb <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8040e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040e5:	8b 10                	mov    (%rax),%edx
  8040e7:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8040ee:	00 00 00 
  8040f1:	8b 00                	mov    (%rax),%eax
  8040f3:	39 c2                	cmp    %eax,%edx
  8040f5:	0f 94 c0             	sete   %al
  8040f8:	0f b6 c0             	movzbl %al,%eax
}
  8040fb:	c9                   	leaveq 
  8040fc:	c3                   	retq   

00000000008040fd <opencons>:

int
opencons(void)
{
  8040fd:	55                   	push   %rbp
  8040fe:	48 89 e5             	mov    %rsp,%rbp
  804101:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804105:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804109:	48 89 c7             	mov    %rax,%rdi
  80410c:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  804113:	00 00 00 
  804116:	ff d0                	callq  *%rax
  804118:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80411b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80411f:	79 05                	jns    804126 <opencons+0x29>
		return r;
  804121:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804124:	eb 5b                	jmp    804181 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804126:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80412a:	ba 07 04 00 00       	mov    $0x407,%edx
  80412f:	48 89 c6             	mov    %rax,%rsi
  804132:	bf 00 00 00 00       	mov    $0x0,%edi
  804137:	48 b8 89 1b 80 00 00 	movabs $0x801b89,%rax
  80413e:	00 00 00 
  804141:	ff d0                	callq  *%rax
  804143:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804146:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80414a:	79 05                	jns    804151 <opencons+0x54>
		return r;
  80414c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80414f:	eb 30                	jmp    804181 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804151:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804155:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80415c:	00 00 00 
  80415f:	8b 12                	mov    (%rdx),%edx
  804161:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804163:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804167:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80416e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804172:	48 89 c7             	mov    %rax,%rdi
  804175:	48 b8 86 2a 80 00 00 	movabs $0x802a86,%rax
  80417c:	00 00 00 
  80417f:	ff d0                	callq  *%rax
}
  804181:	c9                   	leaveq 
  804182:	c3                   	retq   

0000000000804183 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804183:	55                   	push   %rbp
  804184:	48 89 e5             	mov    %rsp,%rbp
  804187:	48 83 ec 30          	sub    $0x30,%rsp
  80418b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80418f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804193:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804197:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80419c:	75 07                	jne    8041a5 <devcons_read+0x22>
		return 0;
  80419e:	b8 00 00 00 00       	mov    $0x0,%eax
  8041a3:	eb 4b                	jmp    8041f0 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8041a5:	eb 0c                	jmp    8041b3 <devcons_read+0x30>
		sys_yield();
  8041a7:	48 b8 4b 1b 80 00 00 	movabs $0x801b4b,%rax
  8041ae:	00 00 00 
  8041b1:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8041b3:	48 b8 8b 1a 80 00 00 	movabs $0x801a8b,%rax
  8041ba:	00 00 00 
  8041bd:	ff d0                	callq  *%rax
  8041bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041c6:	74 df                	je     8041a7 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8041c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041cc:	79 05                	jns    8041d3 <devcons_read+0x50>
		return c;
  8041ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d1:	eb 1d                	jmp    8041f0 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8041d3:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8041d7:	75 07                	jne    8041e0 <devcons_read+0x5d>
		return 0;
  8041d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8041de:	eb 10                	jmp    8041f0 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8041e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041e3:	89 c2                	mov    %eax,%edx
  8041e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041e9:	88 10                	mov    %dl,(%rax)
	return 1;
  8041eb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8041f0:	c9                   	leaveq 
  8041f1:	c3                   	retq   

00000000008041f2 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8041f2:	55                   	push   %rbp
  8041f3:	48 89 e5             	mov    %rsp,%rbp
  8041f6:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8041fd:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804204:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80420b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804219:	eb 76                	jmp    804291 <devcons_write+0x9f>
		m = n - tot;
  80421b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804222:	89 c2                	mov    %eax,%edx
  804224:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804227:	29 c2                	sub    %eax,%edx
  804229:	89 d0                	mov    %edx,%eax
  80422b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80422e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804231:	83 f8 7f             	cmp    $0x7f,%eax
  804234:	76 07                	jbe    80423d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804236:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80423d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804240:	48 63 d0             	movslq %eax,%rdx
  804243:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804246:	48 63 c8             	movslq %eax,%rcx
  804249:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804250:	48 01 c1             	add    %rax,%rcx
  804253:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80425a:	48 89 ce             	mov    %rcx,%rsi
  80425d:	48 89 c7             	mov    %rax,%rdi
  804260:	48 b8 7e 15 80 00 00 	movabs $0x80157e,%rax
  804267:	00 00 00 
  80426a:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80426c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80426f:	48 63 d0             	movslq %eax,%rdx
  804272:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804279:	48 89 d6             	mov    %rdx,%rsi
  80427c:	48 89 c7             	mov    %rax,%rdi
  80427f:	48 b8 41 1a 80 00 00 	movabs $0x801a41,%rax
  804286:	00 00 00 
  804289:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80428b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80428e:	01 45 fc             	add    %eax,-0x4(%rbp)
  804291:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804294:	48 98                	cltq   
  804296:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80429d:	0f 82 78 ff ff ff    	jb     80421b <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8042a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8042a6:	c9                   	leaveq 
  8042a7:	c3                   	retq   

00000000008042a8 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8042a8:	55                   	push   %rbp
  8042a9:	48 89 e5             	mov    %rsp,%rbp
  8042ac:	48 83 ec 08          	sub    $0x8,%rsp
  8042b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8042b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042b9:	c9                   	leaveq 
  8042ba:	c3                   	retq   

00000000008042bb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8042bb:	55                   	push   %rbp
  8042bc:	48 89 e5             	mov    %rsp,%rbp
  8042bf:	48 83 ec 10          	sub    $0x10,%rsp
  8042c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8042cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042cf:	48 be f8 4c 80 00 00 	movabs $0x804cf8,%rsi
  8042d6:	00 00 00 
  8042d9:	48 89 c7             	mov    %rax,%rdi
  8042dc:	48 b8 5a 12 80 00 00 	movabs $0x80125a,%rax
  8042e3:	00 00 00 
  8042e6:	ff d0                	callq  *%rax
	return 0;
  8042e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042ed:	c9                   	leaveq 
  8042ee:	c3                   	retq   

00000000008042ef <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8042ef:	55                   	push   %rbp
  8042f0:	48 89 e5             	mov    %rsp,%rbp
  8042f3:	48 83 ec 20          	sub    $0x20,%rsp
  8042f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8042fb:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804302:	00 00 00 
  804305:	48 8b 00             	mov    (%rax),%rax
  804308:	48 85 c0             	test   %rax,%rax
  80430b:	75 6f                	jne    80437c <set_pgfault_handler+0x8d>
		// First time through!
		// LAB 4: Your code here.

		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  80430d:	ba 07 00 00 00       	mov    $0x7,%edx
  804312:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804317:	bf 00 00 00 00       	mov    $0x0,%edi
  80431c:	48 b8 89 1b 80 00 00 	movabs $0x801b89,%rax
  804323:	00 00 00 
  804326:	ff d0                	callq  *%rax
  804328:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80432b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80432f:	79 30                	jns    804361 <set_pgfault_handler+0x72>
            panic("set_pgfault_handler: %d\n", r);
  804331:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804334:	89 c1                	mov    %eax,%ecx
  804336:	48 ba ff 4c 80 00 00 	movabs $0x804cff,%rdx
  80433d:	00 00 00 
  804340:	be 22 00 00 00       	mov    $0x22,%esi
  804345:	48 bf 18 4d 80 00 00 	movabs $0x804d18,%rdi
  80434c:	00 00 00 
  80434f:	b8 00 00 00 00       	mov    $0x0,%eax
  804354:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  80435b:	00 00 00 
  80435e:	41 ff d0             	callq  *%r8
        sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804361:	48 be 8f 43 80 00 00 	movabs $0x80438f,%rsi
  804368:	00 00 00 
  80436b:	bf 00 00 00 00       	mov    $0x0,%edi
  804370:	48 b8 13 1d 80 00 00 	movabs $0x801d13,%rax
  804377:	00 00 00 
  80437a:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80437c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804383:	00 00 00 
  804386:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80438a:	48 89 10             	mov    %rdx,(%rax)
}
  80438d:	c9                   	leaveq 
  80438e:	c3                   	retq   

000000000080438f <_pgfault_upcall>:
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF


	movq %rsp, %rdi;	
  80438f:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  804392:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804399:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  80439a:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  8043a1:	00 
	pushq %rbx;
  8043a2:	53                   	push   %rbx
	movq %rsp, %rbx;	
  8043a3:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  8043a6:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  8043a9:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  8043b0:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  8043b1:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  8043b5:	4c 8b 3c 24          	mov    (%rsp),%r15
  8043b9:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8043be:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8043c3:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8043c8:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8043cd:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8043d2:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8043d7:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8043dc:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8043e1:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8043e6:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8043eb:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8043f0:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8043f5:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8043fa:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8043ff:	48 83 c4 78          	add    $0x78,%rsp
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.


	add $8, %rsp; //Jump rip field  
  804403:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804407:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  804408:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  804409:	c3                   	retq   
