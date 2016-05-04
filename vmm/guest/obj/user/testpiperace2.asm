
vmm/guest/obj/user/testpiperace2:     file format elf64-x86-64


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
  80003c:	e8 e2 02 00 00       	callq  800323 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  800052:	48 bf c0 43 80 00 00 	movabs $0x8043c0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 64 37 80 00 00 	movabs $0x803764,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba e2 43 80 00 00 	movabs $0x8043e2,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf eb 43 80 00 00 	movabs $0x8043eb,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 c9 03 80 00 00 	movabs $0x8003c9,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	if ((r = fork()) < 0)
  8000b9:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
  8000c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cc:	79 30                	jns    8000fe <umain+0xbb>
		panic("fork: %e", r);
  8000ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba 00 44 80 00 00 	movabs $0x804400,%rdx
  8000da:	00 00 00 
  8000dd:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e2:	48 bf eb 43 80 00 00 	movabs $0x8043eb,%rdi
  8000e9:	00 00 00 
  8000ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f1:	49 b8 c9 03 80 00 00 	movabs $0x8003c9,%r8
  8000f8:	00 00 00 
  8000fb:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800102:	0f 85 c0 00 00 00    	jne    8001c8 <umain+0x185>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  800108:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
		for (i = 0; i < 200; i++) {
  800119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800120:	e9 8a 00 00 00       	jmpq   8001af <umain+0x16c>
			if (i % 10 == 0)
  800125:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800128:	ba 67 66 66 66       	mov    $0x66666667,%edx
  80012d:	89 c8                	mov    %ecx,%eax
  80012f:	f7 ea                	imul   %edx
  800131:	c1 fa 02             	sar    $0x2,%edx
  800134:	89 c8                	mov    %ecx,%eax
  800136:	c1 f8 1f             	sar    $0x1f,%eax
  800139:	29 c2                	sub    %eax,%edx
  80013b:	89 d0                	mov    %edx,%eax
  80013d:	c1 e0 02             	shl    $0x2,%eax
  800140:	01 d0                	add    %edx,%eax
  800142:	01 c0                	add    %eax,%eax
  800144:	29 c1                	sub    %eax,%ecx
  800146:	89 ca                	mov    %ecx,%edx
  800148:	85 d2                	test   %edx,%edx
  80014a:	75 20                	jne    80016c <umain+0x129>
				cprintf("%d.", i);
  80014c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014f:	89 c6                	mov    %eax,%esi
  800151:	48 bf 09 44 80 00 00 	movabs $0x804409,%rdi
  800158:	00 00 00 
  80015b:	b8 00 00 00 00       	mov    $0x0,%eax
  800160:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  800167:	00 00 00 
  80016a:	ff d2                	callq  *%rdx
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  80016c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80016f:	be 0a 00 00 00       	mov    $0xa,%esi
  800174:	89 c7                	mov    %eax,%edi
  800176:	48 b8 6f 2b 80 00 00 	movabs $0x802b6f,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
			sys_yield();
  800182:	48 b8 e9 1a 80 00 00 	movabs $0x801ae9,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
			close(10);
  80018e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800193:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  80019a:	00 00 00 
  80019d:	ff d0                	callq  *%rax
			sys_yield();
  80019f:	48 b8 e9 1a 80 00 00 	movabs $0x801ae9,%rax
  8001a6:	00 00 00 
  8001a9:	ff d0                	callq  *%rax
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  8001ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001af:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%rbp)
  8001b6:	0f 8e 69 ff ff ff    	jle    800125 <umain+0xe2>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  8001bc:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  8001c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d0:	48 98                	cltq   
  8001d2:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8001d9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001e0:	00 00 00 
  8001e3:	48 01 d0             	add    %rdx,%rax
  8001e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	while (kid->env_status == ENV_RUNNABLE)
  8001ea:	eb 4d                	jmp    800239 <umain+0x1f6>
		if (pipeisclosed(p[0]) != 0) {
  8001ec:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8001ef:	89 c7                	mov    %eax,%edi
  8001f1:	48 b8 2d 3a 80 00 00 	movabs $0x803a2d,%rax
  8001f8:	00 00 00 
  8001fb:	ff d0                	callq  *%rax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 38                	je     800239 <umain+0x1f6>
			cprintf("\nRACE: pipe appears closed\n");
  800201:	48 bf 0d 44 80 00 00 	movabs $0x80440d,%rdi
  800208:	00 00 00 
  80020b:	b8 00 00 00 00       	mov    $0x0,%eax
  800210:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  800217:	00 00 00 
  80021a:	ff d2                	callq  *%rdx
			sys_env_destroy(r);
  80021c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80021f:	89 c7                	mov    %eax,%edi
  800221:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  800228:	00 00 00 
  80022b:	ff d0                	callq  *%rax
			exit();
  80022d:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  800234:	00 00 00 
  800237:	ff d0                	callq  *%rax
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80023d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  800243:	83 f8 02             	cmp    $0x2,%eax
  800246:	74 a4                	je     8001ec <umain+0x1a9>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  800248:	48 bf 29 44 80 00 00 	movabs $0x804429,%rdi
  80024f:	00 00 00 
  800252:	b8 00 00 00 00       	mov    $0x0,%eax
  800257:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  80025e:	00 00 00 
  800261:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800263:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800266:	89 c7                	mov    %eax,%edi
  800268:	48 b8 2d 3a 80 00 00 	movabs $0x803a2d,%rax
  80026f:	00 00 00 
  800272:	ff d0                	callq  *%rax
  800274:	85 c0                	test   %eax,%eax
  800276:	74 2a                	je     8002a2 <umain+0x25f>
		panic("somehow the other end of p[0] got closed!");
  800278:	48 ba 40 44 80 00 00 	movabs $0x804440,%rdx
  80027f:	00 00 00 
  800282:	be 40 00 00 00       	mov    $0x40,%esi
  800287:	48 bf eb 43 80 00 00 	movabs $0x8043eb,%rdi
  80028e:	00 00 00 
  800291:	b8 00 00 00 00       	mov    $0x0,%eax
  800296:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  80029d:	00 00 00 
  8002a0:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002a2:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8002a5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8002a9:	48 89 d6             	mov    %rdx,%rsi
  8002ac:	89 c7                	mov    %eax,%edi
  8002ae:	48 b8 e6 28 80 00 00 	movabs $0x8028e6,%rax
  8002b5:	00 00 00 
  8002b8:	ff d0                	callq  *%rax
  8002ba:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002c1:	79 30                	jns    8002f3 <umain+0x2b0>
		panic("cannot look up p[0]: %e", r);
  8002c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002c6:	89 c1                	mov    %eax,%ecx
  8002c8:	48 ba 6a 44 80 00 00 	movabs $0x80446a,%rdx
  8002cf:	00 00 00 
  8002d2:	be 42 00 00 00       	mov    $0x42,%esi
  8002d7:	48 bf eb 43 80 00 00 	movabs $0x8043eb,%rdi
  8002de:	00 00 00 
  8002e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e6:	49 b8 c9 03 80 00 00 	movabs $0x8003c9,%r8
  8002ed:	00 00 00 
  8002f0:	41 ff d0             	callq  *%r8
	(void) fd2data(fd);
  8002f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002f7:	48 89 c7             	mov    %rax,%rdi
  8002fa:	48 b8 23 28 80 00 00 	movabs $0x802823,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax
	cprintf("race didn't happen\n");
  800306:	48 bf 82 44 80 00 00 	movabs $0x804482,%rdi
  80030d:	00 00 00 
  800310:	b8 00 00 00 00       	mov    $0x0,%eax
  800315:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  80031c:	00 00 00 
  80031f:	ff d2                	callq  *%rdx
}
  800321:	c9                   	leaveq 
  800322:	c3                   	retq   

0000000000800323 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800323:	55                   	push   %rbp
  800324:	48 89 e5             	mov    %rsp,%rbp
  800327:	48 83 ec 10          	sub    $0x10,%rsp
  80032b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80032e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  800332:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
  80033e:	48 98                	cltq   
  800340:	25 ff 03 00 00       	and    $0x3ff,%eax
  800345:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  80034c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800353:	00 00 00 
  800356:	48 01 c2             	add    %rax,%rdx
  800359:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800360:	00 00 00 
  800363:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800366:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80036a:	7e 14                	jle    800380 <libmain+0x5d>
		binaryname = argv[0];
  80036c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800370:	48 8b 10             	mov    (%rax),%rdx
  800373:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80037a:	00 00 00 
  80037d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800380:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800384:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800387:	48 89 d6             	mov    %rdx,%rsi
  80038a:	89 c7                	mov    %eax,%edi
  80038c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800393:	00 00 00 
  800396:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800398:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	callq  *%rax
}
  8003a4:	c9                   	leaveq 
  8003a5:	c3                   	retq   

00000000008003a6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003a6:	55                   	push   %rbp
  8003a7:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8003aa:	48 b8 41 2b 80 00 00 	movabs $0x802b41,%rax
  8003b1:	00 00 00 
  8003b4:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8003b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8003bb:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  8003c2:	00 00 00 
  8003c5:	ff d0                	callq  *%rax
}
  8003c7:	5d                   	pop    %rbp
  8003c8:	c3                   	retq   

00000000008003c9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003c9:	55                   	push   %rbp
  8003ca:	48 89 e5             	mov    %rsp,%rbp
  8003cd:	53                   	push   %rbx
  8003ce:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003d5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003dc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003e2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003e9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003f0:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003f7:	84 c0                	test   %al,%al
  8003f9:	74 23                	je     80041e <_panic+0x55>
  8003fb:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800402:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800406:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80040a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80040e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800412:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800416:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80041a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80041e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800425:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80042c:	00 00 00 
  80042f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800436:	00 00 00 
  800439:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80043d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800444:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80044b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800452:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800459:	00 00 00 
  80045c:	48 8b 18             	mov    (%rax),%rbx
  80045f:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
  80046b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800471:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800478:	41 89 c8             	mov    %ecx,%r8d
  80047b:	48 89 d1             	mov    %rdx,%rcx
  80047e:	48 89 da             	mov    %rbx,%rdx
  800481:	89 c6                	mov    %eax,%esi
  800483:	48 bf a0 44 80 00 00 	movabs $0x8044a0,%rdi
  80048a:	00 00 00 
  80048d:	b8 00 00 00 00       	mov    $0x0,%eax
  800492:	49 b9 02 06 80 00 00 	movabs $0x800602,%r9
  800499:	00 00 00 
  80049c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80049f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004a6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004ad:	48 89 d6             	mov    %rdx,%rsi
  8004b0:	48 89 c7             	mov    %rax,%rdi
  8004b3:	48 b8 56 05 80 00 00 	movabs $0x800556,%rax
  8004ba:	00 00 00 
  8004bd:	ff d0                	callq  *%rax
	cprintf("\n");
  8004bf:	48 bf c3 44 80 00 00 	movabs $0x8044c3,%rdi
  8004c6:	00 00 00 
  8004c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ce:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  8004d5:	00 00 00 
  8004d8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004da:	cc                   	int3   
  8004db:	eb fd                	jmp    8004da <_panic+0x111>

00000000008004dd <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8004dd:	55                   	push   %rbp
  8004de:	48 89 e5             	mov    %rsp,%rbp
  8004e1:	48 83 ec 10          	sub    $0x10,%rsp
  8004e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8004ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004f0:	8b 00                	mov    (%rax),%eax
  8004f2:	8d 48 01             	lea    0x1(%rax),%ecx
  8004f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004f9:	89 0a                	mov    %ecx,(%rdx)
  8004fb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004fe:	89 d1                	mov    %edx,%ecx
  800500:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800504:	48 98                	cltq   
  800506:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80050a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80050e:	8b 00                	mov    (%rax),%eax
  800510:	3d ff 00 00 00       	cmp    $0xff,%eax
  800515:	75 2c                	jne    800543 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800517:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80051b:	8b 00                	mov    (%rax),%eax
  80051d:	48 98                	cltq   
  80051f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800523:	48 83 c2 08          	add    $0x8,%rdx
  800527:	48 89 c6             	mov    %rax,%rsi
  80052a:	48 89 d7             	mov    %rdx,%rdi
  80052d:	48 b8 df 19 80 00 00 	movabs $0x8019df,%rax
  800534:	00 00 00 
  800537:	ff d0                	callq  *%rax
        b->idx = 0;
  800539:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80053d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800543:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800547:	8b 40 04             	mov    0x4(%rax),%eax
  80054a:	8d 50 01             	lea    0x1(%rax),%edx
  80054d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800551:	89 50 04             	mov    %edx,0x4(%rax)
}
  800554:	c9                   	leaveq 
  800555:	c3                   	retq   

0000000000800556 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800556:	55                   	push   %rbp
  800557:	48 89 e5             	mov    %rsp,%rbp
  80055a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800561:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800568:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80056f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800576:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80057d:	48 8b 0a             	mov    (%rdx),%rcx
  800580:	48 89 08             	mov    %rcx,(%rax)
  800583:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800587:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80058b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80058f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800593:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80059a:	00 00 00 
    b.cnt = 0;
  80059d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005a4:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005a7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005ae:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005b5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005bc:	48 89 c6             	mov    %rax,%rsi
  8005bf:	48 bf dd 04 80 00 00 	movabs $0x8004dd,%rdi
  8005c6:	00 00 00 
  8005c9:	48 b8 b5 09 80 00 00 	movabs $0x8009b5,%rax
  8005d0:	00 00 00 
  8005d3:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8005d5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005db:	48 98                	cltq   
  8005dd:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005e4:	48 83 c2 08          	add    $0x8,%rdx
  8005e8:	48 89 c6             	mov    %rax,%rsi
  8005eb:	48 89 d7             	mov    %rdx,%rdi
  8005ee:	48 b8 df 19 80 00 00 	movabs $0x8019df,%rax
  8005f5:	00 00 00 
  8005f8:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8005fa:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800600:	c9                   	leaveq 
  800601:	c3                   	retq   

0000000000800602 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800602:	55                   	push   %rbp
  800603:	48 89 e5             	mov    %rsp,%rbp
  800606:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80060d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800614:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80061b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800622:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800629:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800630:	84 c0                	test   %al,%al
  800632:	74 20                	je     800654 <cprintf+0x52>
  800634:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800638:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80063c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800640:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800644:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800648:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80064c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800650:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800654:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80065b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800662:	00 00 00 
  800665:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80066c:	00 00 00 
  80066f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800673:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80067a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800681:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800688:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80068f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800696:	48 8b 0a             	mov    (%rdx),%rcx
  800699:	48 89 08             	mov    %rcx,(%rax)
  80069c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006a0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006a4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006a8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006ac:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006b3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006ba:	48 89 d6             	mov    %rdx,%rsi
  8006bd:	48 89 c7             	mov    %rax,%rdi
  8006c0:	48 b8 56 05 80 00 00 	movabs $0x800556,%rax
  8006c7:	00 00 00 
  8006ca:	ff d0                	callq  *%rax
  8006cc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8006d2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006d8:	c9                   	leaveq 
  8006d9:	c3                   	retq   

00000000008006da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006da:	55                   	push   %rbp
  8006db:	48 89 e5             	mov    %rsp,%rbp
  8006de:	53                   	push   %rbx
  8006df:	48 83 ec 38          	sub    $0x38,%rsp
  8006e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8006ef:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8006f2:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8006f6:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006fa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8006fd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800701:	77 3b                	ja     80073e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800703:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800706:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80070a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80070d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
  800716:	48 f7 f3             	div    %rbx
  800719:	48 89 c2             	mov    %rax,%rdx
  80071c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80071f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800722:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072a:	41 89 f9             	mov    %edi,%r9d
  80072d:	48 89 c7             	mov    %rax,%rdi
  800730:	48 b8 da 06 80 00 00 	movabs $0x8006da,%rax
  800737:	00 00 00 
  80073a:	ff d0                	callq  *%rax
  80073c:	eb 1e                	jmp    80075c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80073e:	eb 12                	jmp    800752 <printnum+0x78>
			putch(padc, putdat);
  800740:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800744:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074b:	48 89 ce             	mov    %rcx,%rsi
  80074e:	89 d7                	mov    %edx,%edi
  800750:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800752:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800756:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80075a:	7f e4                	jg     800740 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80075c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80075f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800763:	ba 00 00 00 00       	mov    $0x0,%edx
  800768:	48 f7 f1             	div    %rcx
  80076b:	48 89 d0             	mov    %rdx,%rax
  80076e:	48 ba d0 46 80 00 00 	movabs $0x8046d0,%rdx
  800775:	00 00 00 
  800778:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80077c:	0f be d0             	movsbl %al,%edx
  80077f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800787:	48 89 ce             	mov    %rcx,%rsi
  80078a:	89 d7                	mov    %edx,%edi
  80078c:	ff d0                	callq  *%rax
}
  80078e:	48 83 c4 38          	add    $0x38,%rsp
  800792:	5b                   	pop    %rbx
  800793:	5d                   	pop    %rbp
  800794:	c3                   	retq   

0000000000800795 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800795:	55                   	push   %rbp
  800796:	48 89 e5             	mov    %rsp,%rbp
  800799:	48 83 ec 1c          	sub    $0x1c,%rsp
  80079d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007a1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007a4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007a8:	7e 52                	jle    8007fc <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ae:	8b 00                	mov    (%rax),%eax
  8007b0:	83 f8 30             	cmp    $0x30,%eax
  8007b3:	73 24                	jae    8007d9 <getuint+0x44>
  8007b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c1:	8b 00                	mov    (%rax),%eax
  8007c3:	89 c0                	mov    %eax,%eax
  8007c5:	48 01 d0             	add    %rdx,%rax
  8007c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cc:	8b 12                	mov    (%rdx),%edx
  8007ce:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d5:	89 0a                	mov    %ecx,(%rdx)
  8007d7:	eb 17                	jmp    8007f0 <getuint+0x5b>
  8007d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007dd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007e1:	48 89 d0             	mov    %rdx,%rax
  8007e4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ec:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f0:	48 8b 00             	mov    (%rax),%rax
  8007f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f7:	e9 a3 00 00 00       	jmpq   80089f <getuint+0x10a>
	else if (lflag)
  8007fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800800:	74 4f                	je     800851 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800802:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800806:	8b 00                	mov    (%rax),%eax
  800808:	83 f8 30             	cmp    $0x30,%eax
  80080b:	73 24                	jae    800831 <getuint+0x9c>
  80080d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800811:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800819:	8b 00                	mov    (%rax),%eax
  80081b:	89 c0                	mov    %eax,%eax
  80081d:	48 01 d0             	add    %rdx,%rax
  800820:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800824:	8b 12                	mov    (%rdx),%edx
  800826:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800829:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082d:	89 0a                	mov    %ecx,(%rdx)
  80082f:	eb 17                	jmp    800848 <getuint+0xb3>
  800831:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800835:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800839:	48 89 d0             	mov    %rdx,%rax
  80083c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800840:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800844:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800848:	48 8b 00             	mov    (%rax),%rax
  80084b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80084f:	eb 4e                	jmp    80089f <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	8b 00                	mov    (%rax),%eax
  800857:	83 f8 30             	cmp    $0x30,%eax
  80085a:	73 24                	jae    800880 <getuint+0xeb>
  80085c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800860:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800868:	8b 00                	mov    (%rax),%eax
  80086a:	89 c0                	mov    %eax,%eax
  80086c:	48 01 d0             	add    %rdx,%rax
  80086f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800873:	8b 12                	mov    (%rdx),%edx
  800875:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800878:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087c:	89 0a                	mov    %ecx,(%rdx)
  80087e:	eb 17                	jmp    800897 <getuint+0x102>
  800880:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800884:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800888:	48 89 d0             	mov    %rdx,%rax
  80088b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80088f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800893:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800897:	8b 00                	mov    (%rax),%eax
  800899:	89 c0                	mov    %eax,%eax
  80089b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80089f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008a3:	c9                   	leaveq 
  8008a4:	c3                   	retq   

00000000008008a5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008a5:	55                   	push   %rbp
  8008a6:	48 89 e5             	mov    %rsp,%rbp
  8008a9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008b1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008b4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008b8:	7e 52                	jle    80090c <getint+0x67>
		x=va_arg(*ap, long long);
  8008ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008be:	8b 00                	mov    (%rax),%eax
  8008c0:	83 f8 30             	cmp    $0x30,%eax
  8008c3:	73 24                	jae    8008e9 <getint+0x44>
  8008c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d1:	8b 00                	mov    (%rax),%eax
  8008d3:	89 c0                	mov    %eax,%eax
  8008d5:	48 01 d0             	add    %rdx,%rax
  8008d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008dc:	8b 12                	mov    (%rdx),%edx
  8008de:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e5:	89 0a                	mov    %ecx,(%rdx)
  8008e7:	eb 17                	jmp    800900 <getint+0x5b>
  8008e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ed:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008f1:	48 89 d0             	mov    %rdx,%rax
  8008f4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800900:	48 8b 00             	mov    (%rax),%rax
  800903:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800907:	e9 a3 00 00 00       	jmpq   8009af <getint+0x10a>
	else if (lflag)
  80090c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800910:	74 4f                	je     800961 <getint+0xbc>
		x=va_arg(*ap, long);
  800912:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800916:	8b 00                	mov    (%rax),%eax
  800918:	83 f8 30             	cmp    $0x30,%eax
  80091b:	73 24                	jae    800941 <getint+0x9c>
  80091d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800921:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800925:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800929:	8b 00                	mov    (%rax),%eax
  80092b:	89 c0                	mov    %eax,%eax
  80092d:	48 01 d0             	add    %rdx,%rax
  800930:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800934:	8b 12                	mov    (%rdx),%edx
  800936:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800939:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093d:	89 0a                	mov    %ecx,(%rdx)
  80093f:	eb 17                	jmp    800958 <getint+0xb3>
  800941:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800945:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800949:	48 89 d0             	mov    %rdx,%rax
  80094c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800950:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800954:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800958:	48 8b 00             	mov    (%rax),%rax
  80095b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80095f:	eb 4e                	jmp    8009af <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800961:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800965:	8b 00                	mov    (%rax),%eax
  800967:	83 f8 30             	cmp    $0x30,%eax
  80096a:	73 24                	jae    800990 <getint+0xeb>
  80096c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800970:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800978:	8b 00                	mov    (%rax),%eax
  80097a:	89 c0                	mov    %eax,%eax
  80097c:	48 01 d0             	add    %rdx,%rax
  80097f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800983:	8b 12                	mov    (%rdx),%edx
  800985:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800988:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098c:	89 0a                	mov    %ecx,(%rdx)
  80098e:	eb 17                	jmp    8009a7 <getint+0x102>
  800990:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800994:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800998:	48 89 d0             	mov    %rdx,%rax
  80099b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80099f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009a7:	8b 00                	mov    (%rax),%eax
  8009a9:	48 98                	cltq   
  8009ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009b3:	c9                   	leaveq 
  8009b4:	c3                   	retq   

00000000008009b5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009b5:	55                   	push   %rbp
  8009b6:	48 89 e5             	mov    %rsp,%rbp
  8009b9:	41 54                	push   %r12
  8009bb:	53                   	push   %rbx
  8009bc:	48 83 ec 60          	sub    $0x60,%rsp
  8009c0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009c4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009c8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009cc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009d0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009d4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009d8:	48 8b 0a             	mov    (%rdx),%rcx
  8009db:	48 89 08             	mov    %rcx,(%rax)
  8009de:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009e2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009e6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009ea:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ee:	eb 28                	jmp    800a18 <vprintfmt+0x63>
			if (ch == '\0'){
  8009f0:	85 db                	test   %ebx,%ebx
  8009f2:	75 15                	jne    800a09 <vprintfmt+0x54>
				current_color=WHITE;
  8009f4:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8009fb:	00 00 00 
  8009fe:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800a04:	e9 fc 04 00 00       	jmpq   800f05 <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  800a09:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a0d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a11:	48 89 d6             	mov    %rdx,%rsi
  800a14:	89 df                	mov    %ebx,%edi
  800a16:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a18:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a1c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a20:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a24:	0f b6 00             	movzbl (%rax),%eax
  800a27:	0f b6 d8             	movzbl %al,%ebx
  800a2a:	83 fb 25             	cmp    $0x25,%ebx
  800a2d:	75 c1                	jne    8009f0 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a2f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a33:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a3a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a41:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a48:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a4f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a53:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a57:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a5b:	0f b6 00             	movzbl (%rax),%eax
  800a5e:	0f b6 d8             	movzbl %al,%ebx
  800a61:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a64:	83 f8 55             	cmp    $0x55,%eax
  800a67:	0f 87 64 04 00 00    	ja     800ed1 <vprintfmt+0x51c>
  800a6d:	89 c0                	mov    %eax,%eax
  800a6f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a76:	00 
  800a77:	48 b8 f8 46 80 00 00 	movabs $0x8046f8,%rax
  800a7e:	00 00 00 
  800a81:	48 01 d0             	add    %rdx,%rax
  800a84:	48 8b 00             	mov    (%rax),%rax
  800a87:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a89:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a8d:	eb c0                	jmp    800a4f <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a8f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a93:	eb ba                	jmp    800a4f <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a95:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a9c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a9f:	89 d0                	mov    %edx,%eax
  800aa1:	c1 e0 02             	shl    $0x2,%eax
  800aa4:	01 d0                	add    %edx,%eax
  800aa6:	01 c0                	add    %eax,%eax
  800aa8:	01 d8                	add    %ebx,%eax
  800aaa:	83 e8 30             	sub    $0x30,%eax
  800aad:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ab0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ab4:	0f b6 00             	movzbl (%rax),%eax
  800ab7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aba:	83 fb 2f             	cmp    $0x2f,%ebx
  800abd:	7e 0c                	jle    800acb <vprintfmt+0x116>
  800abf:	83 fb 39             	cmp    $0x39,%ebx
  800ac2:	7f 07                	jg     800acb <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ac9:	eb d1                	jmp    800a9c <vprintfmt+0xe7>
			goto process_precision;
  800acb:	eb 58                	jmp    800b25 <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800acd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad0:	83 f8 30             	cmp    $0x30,%eax
  800ad3:	73 17                	jae    800aec <vprintfmt+0x137>
  800ad5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adc:	89 c0                	mov    %eax,%eax
  800ade:	48 01 d0             	add    %rdx,%rax
  800ae1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae4:	83 c2 08             	add    $0x8,%edx
  800ae7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aea:	eb 0f                	jmp    800afb <vprintfmt+0x146>
  800aec:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800af0:	48 89 d0             	mov    %rdx,%rax
  800af3:	48 83 c2 08          	add    $0x8,%rdx
  800af7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800afb:	8b 00                	mov    (%rax),%eax
  800afd:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b00:	eb 23                	jmp    800b25 <vprintfmt+0x170>

		case '.':
			if (width < 0)
  800b02:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b06:	79 0c                	jns    800b14 <vprintfmt+0x15f>
				width = 0;
  800b08:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b0f:	e9 3b ff ff ff       	jmpq   800a4f <vprintfmt+0x9a>
  800b14:	e9 36 ff ff ff       	jmpq   800a4f <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  800b19:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b20:	e9 2a ff ff ff       	jmpq   800a4f <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  800b25:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b29:	79 12                	jns    800b3d <vprintfmt+0x188>
				width = precision, precision = -1;
  800b2b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b2e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b31:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b38:	e9 12 ff ff ff       	jmpq   800a4f <vprintfmt+0x9a>
  800b3d:	e9 0d ff ff ff       	jmpq   800a4f <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b42:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b46:	e9 04 ff ff ff       	jmpq   800a4f <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b4e:	83 f8 30             	cmp    $0x30,%eax
  800b51:	73 17                	jae    800b6a <vprintfmt+0x1b5>
  800b53:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5a:	89 c0                	mov    %eax,%eax
  800b5c:	48 01 d0             	add    %rdx,%rax
  800b5f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b62:	83 c2 08             	add    $0x8,%edx
  800b65:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b68:	eb 0f                	jmp    800b79 <vprintfmt+0x1c4>
  800b6a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b6e:	48 89 d0             	mov    %rdx,%rax
  800b71:	48 83 c2 08          	add    $0x8,%rdx
  800b75:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b79:	8b 10                	mov    (%rax),%edx
  800b7b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b7f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b83:	48 89 ce             	mov    %rcx,%rsi
  800b86:	89 d7                	mov    %edx,%edi
  800b88:	ff d0                	callq  *%rax
			break;
  800b8a:	e9 70 03 00 00       	jmpq   800eff <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b8f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b92:	83 f8 30             	cmp    $0x30,%eax
  800b95:	73 17                	jae    800bae <vprintfmt+0x1f9>
  800b97:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9e:	89 c0                	mov    %eax,%eax
  800ba0:	48 01 d0             	add    %rdx,%rax
  800ba3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba6:	83 c2 08             	add    $0x8,%edx
  800ba9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bac:	eb 0f                	jmp    800bbd <vprintfmt+0x208>
  800bae:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb2:	48 89 d0             	mov    %rdx,%rax
  800bb5:	48 83 c2 08          	add    $0x8,%rdx
  800bb9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bbd:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bbf:	85 db                	test   %ebx,%ebx
  800bc1:	79 02                	jns    800bc5 <vprintfmt+0x210>
				err = -err;
  800bc3:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bc5:	83 fb 15             	cmp    $0x15,%ebx
  800bc8:	7f 16                	jg     800be0 <vprintfmt+0x22b>
  800bca:	48 b8 20 46 80 00 00 	movabs $0x804620,%rax
  800bd1:	00 00 00 
  800bd4:	48 63 d3             	movslq %ebx,%rdx
  800bd7:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bdb:	4d 85 e4             	test   %r12,%r12
  800bde:	75 2e                	jne    800c0e <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  800be0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800be4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be8:	89 d9                	mov    %ebx,%ecx
  800bea:	48 ba e1 46 80 00 00 	movabs $0x8046e1,%rdx
  800bf1:	00 00 00 
  800bf4:	48 89 c7             	mov    %rax,%rdi
  800bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfc:	49 b8 0e 0f 80 00 00 	movabs $0x800f0e,%r8
  800c03:	00 00 00 
  800c06:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c09:	e9 f1 02 00 00       	jmpq   800eff <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c0e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c16:	4c 89 e1             	mov    %r12,%rcx
  800c19:	48 ba ea 46 80 00 00 	movabs $0x8046ea,%rdx
  800c20:	00 00 00 
  800c23:	48 89 c7             	mov    %rax,%rdi
  800c26:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2b:	49 b8 0e 0f 80 00 00 	movabs $0x800f0e,%r8
  800c32:	00 00 00 
  800c35:	41 ff d0             	callq  *%r8
			break;
  800c38:	e9 c2 02 00 00       	jmpq   800eff <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c40:	83 f8 30             	cmp    $0x30,%eax
  800c43:	73 17                	jae    800c5c <vprintfmt+0x2a7>
  800c45:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4c:	89 c0                	mov    %eax,%eax
  800c4e:	48 01 d0             	add    %rdx,%rax
  800c51:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c54:	83 c2 08             	add    $0x8,%edx
  800c57:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c5a:	eb 0f                	jmp    800c6b <vprintfmt+0x2b6>
  800c5c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c60:	48 89 d0             	mov    %rdx,%rax
  800c63:	48 83 c2 08          	add    $0x8,%rdx
  800c67:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c6b:	4c 8b 20             	mov    (%rax),%r12
  800c6e:	4d 85 e4             	test   %r12,%r12
  800c71:	75 0a                	jne    800c7d <vprintfmt+0x2c8>
				p = "(null)";
  800c73:	49 bc ed 46 80 00 00 	movabs $0x8046ed,%r12
  800c7a:	00 00 00 
			if (width > 0 && padc != '-')
  800c7d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c81:	7e 3f                	jle    800cc2 <vprintfmt+0x30d>
  800c83:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c87:	74 39                	je     800cc2 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c89:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c8c:	48 98                	cltq   
  800c8e:	48 89 c6             	mov    %rax,%rsi
  800c91:	4c 89 e7             	mov    %r12,%rdi
  800c94:	48 b8 ba 11 80 00 00 	movabs $0x8011ba,%rax
  800c9b:	00 00 00 
  800c9e:	ff d0                	callq  *%rax
  800ca0:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ca3:	eb 17                	jmp    800cbc <vprintfmt+0x307>
					putch(padc, putdat);
  800ca5:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ca9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb1:	48 89 ce             	mov    %rcx,%rsi
  800cb4:	89 d7                	mov    %edx,%edi
  800cb6:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cb8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cbc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cc0:	7f e3                	jg     800ca5 <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cc2:	eb 37                	jmp    800cfb <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  800cc4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cc8:	74 1e                	je     800ce8 <vprintfmt+0x333>
  800cca:	83 fb 1f             	cmp    $0x1f,%ebx
  800ccd:	7e 05                	jle    800cd4 <vprintfmt+0x31f>
  800ccf:	83 fb 7e             	cmp    $0x7e,%ebx
  800cd2:	7e 14                	jle    800ce8 <vprintfmt+0x333>
					putch('?', putdat);
  800cd4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cdc:	48 89 d6             	mov    %rdx,%rsi
  800cdf:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ce4:	ff d0                	callq  *%rax
  800ce6:	eb 0f                	jmp    800cf7 <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800ce8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf0:	48 89 d6             	mov    %rdx,%rsi
  800cf3:	89 df                	mov    %ebx,%edi
  800cf5:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cfb:	4c 89 e0             	mov    %r12,%rax
  800cfe:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d02:	0f b6 00             	movzbl (%rax),%eax
  800d05:	0f be d8             	movsbl %al,%ebx
  800d08:	85 db                	test   %ebx,%ebx
  800d0a:	74 10                	je     800d1c <vprintfmt+0x367>
  800d0c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d10:	78 b2                	js     800cc4 <vprintfmt+0x30f>
  800d12:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d16:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d1a:	79 a8                	jns    800cc4 <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d1c:	eb 16                	jmp    800d34 <vprintfmt+0x37f>
				putch(' ', putdat);
  800d1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d26:	48 89 d6             	mov    %rdx,%rsi
  800d29:	bf 20 00 00 00       	mov    $0x20,%edi
  800d2e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d30:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d34:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d38:	7f e4                	jg     800d1e <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800d3a:	e9 c0 01 00 00       	jmpq   800eff <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d3f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d43:	be 03 00 00 00       	mov    $0x3,%esi
  800d48:	48 89 c7             	mov    %rax,%rdi
  800d4b:	48 b8 a5 08 80 00 00 	movabs $0x8008a5,%rax
  800d52:	00 00 00 
  800d55:	ff d0                	callq  *%rax
  800d57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d5f:	48 85 c0             	test   %rax,%rax
  800d62:	79 1d                	jns    800d81 <vprintfmt+0x3cc>
				putch('-', putdat);
  800d64:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6c:	48 89 d6             	mov    %rdx,%rsi
  800d6f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d74:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d7a:	48 f7 d8             	neg    %rax
  800d7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d81:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d88:	e9 d5 00 00 00       	jmpq   800e62 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d8d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d91:	be 03 00 00 00       	mov    $0x3,%esi
  800d96:	48 89 c7             	mov    %rax,%rdi
  800d99:	48 b8 95 07 80 00 00 	movabs $0x800795,%rax
  800da0:	00 00 00 
  800da3:	ff d0                	callq  *%rax
  800da5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800da9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800db0:	e9 ad 00 00 00       	jmpq   800e62 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800db5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800db9:	be 03 00 00 00       	mov    $0x3,%esi
  800dbe:	48 89 c7             	mov    %rax,%rdi
  800dc1:	48 b8 95 07 80 00 00 	movabs $0x800795,%rax
  800dc8:	00 00 00 
  800dcb:	ff d0                	callq  *%rax
  800dcd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800dd1:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800dd8:	e9 85 00 00 00       	jmpq   800e62 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800ddd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de5:	48 89 d6             	mov    %rdx,%rsi
  800de8:	bf 30 00 00 00       	mov    $0x30,%edi
  800ded:	ff d0                	callq  *%rax
			putch('x', putdat);
  800def:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df7:	48 89 d6             	mov    %rdx,%rsi
  800dfa:	bf 78 00 00 00       	mov    $0x78,%edi
  800dff:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e04:	83 f8 30             	cmp    $0x30,%eax
  800e07:	73 17                	jae    800e20 <vprintfmt+0x46b>
  800e09:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e10:	89 c0                	mov    %eax,%eax
  800e12:	48 01 d0             	add    %rdx,%rax
  800e15:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e18:	83 c2 08             	add    $0x8,%edx
  800e1b:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e1e:	eb 0f                	jmp    800e2f <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  800e20:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e24:	48 89 d0             	mov    %rdx,%rax
  800e27:	48 83 c2 08          	add    $0x8,%rdx
  800e2b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e2f:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e32:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e36:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e3d:	eb 23                	jmp    800e62 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e3f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e43:	be 03 00 00 00       	mov    $0x3,%esi
  800e48:	48 89 c7             	mov    %rax,%rdi
  800e4b:	48 b8 95 07 80 00 00 	movabs $0x800795,%rax
  800e52:	00 00 00 
  800e55:	ff d0                	callq  *%rax
  800e57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e5b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e62:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e67:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e6a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e6d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e71:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e79:	45 89 c1             	mov    %r8d,%r9d
  800e7c:	41 89 f8             	mov    %edi,%r8d
  800e7f:	48 89 c7             	mov    %rax,%rdi
  800e82:	48 b8 da 06 80 00 00 	movabs $0x8006da,%rax
  800e89:	00 00 00 
  800e8c:	ff d0                	callq  *%rax
			break;
  800e8e:	eb 6f                	jmp    800eff <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e90:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e98:	48 89 d6             	mov    %rdx,%rsi
  800e9b:	89 df                	mov    %ebx,%edi
  800e9d:	ff d0                	callq  *%rax
			break;
  800e9f:	eb 5e                	jmp    800eff <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  800ea1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea5:	be 03 00 00 00       	mov    $0x3,%esi
  800eaa:	48 89 c7             	mov    %rax,%rdi
  800ead:	48 b8 95 07 80 00 00 	movabs $0x800795,%rax
  800eb4:	00 00 00 
  800eb7:	ff d0                	callq  *%rax
  800eb9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  800ebd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec1:	89 c2                	mov    %eax,%edx
  800ec3:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800eca:	00 00 00 
  800ecd:	89 10                	mov    %edx,(%rax)
			break;
  800ecf:	eb 2e                	jmp    800eff <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ed1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed9:	48 89 d6             	mov    %rdx,%rsi
  800edc:	bf 25 00 00 00       	mov    $0x25,%edi
  800ee1:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ee3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ee8:	eb 05                	jmp    800eef <vprintfmt+0x53a>
  800eea:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800eef:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ef3:	48 83 e8 01          	sub    $0x1,%rax
  800ef7:	0f b6 00             	movzbl (%rax),%eax
  800efa:	3c 25                	cmp    $0x25,%al
  800efc:	75 ec                	jne    800eea <vprintfmt+0x535>
				/* do nothing */;
			break;
  800efe:	90                   	nop
		}
	}
  800eff:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f00:	e9 13 fb ff ff       	jmpq   800a18 <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f05:	48 83 c4 60          	add    $0x60,%rsp
  800f09:	5b                   	pop    %rbx
  800f0a:	41 5c                	pop    %r12
  800f0c:	5d                   	pop    %rbp
  800f0d:	c3                   	retq   

0000000000800f0e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f0e:	55                   	push   %rbp
  800f0f:	48 89 e5             	mov    %rsp,%rbp
  800f12:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f19:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f20:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f27:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f2e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f35:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f3c:	84 c0                	test   %al,%al
  800f3e:	74 20                	je     800f60 <printfmt+0x52>
  800f40:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f44:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f48:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f4c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f50:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f54:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f58:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f5c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f60:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f67:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f6e:	00 00 00 
  800f71:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f78:	00 00 00 
  800f7b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f7f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f86:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f8d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f94:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f9b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fa2:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fa9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fb0:	48 89 c7             	mov    %rax,%rdi
  800fb3:	48 b8 b5 09 80 00 00 	movabs $0x8009b5,%rax
  800fba:	00 00 00 
  800fbd:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fbf:	c9                   	leaveq 
  800fc0:	c3                   	retq   

0000000000800fc1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fc1:	55                   	push   %rbp
  800fc2:	48 89 e5             	mov    %rsp,%rbp
  800fc5:	48 83 ec 10          	sub    $0x10,%rsp
  800fc9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fcc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd4:	8b 40 10             	mov    0x10(%rax),%eax
  800fd7:	8d 50 01             	lea    0x1(%rax),%edx
  800fda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fde:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fe1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe5:	48 8b 10             	mov    (%rax),%rdx
  800fe8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fec:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ff0:	48 39 c2             	cmp    %rax,%rdx
  800ff3:	73 17                	jae    80100c <sprintputch+0x4b>
		*b->buf++ = ch;
  800ff5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff9:	48 8b 00             	mov    (%rax),%rax
  800ffc:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801000:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801004:	48 89 0a             	mov    %rcx,(%rdx)
  801007:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80100a:	88 10                	mov    %dl,(%rax)
}
  80100c:	c9                   	leaveq 
  80100d:	c3                   	retq   

000000000080100e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80100e:	55                   	push   %rbp
  80100f:	48 89 e5             	mov    %rsp,%rbp
  801012:	48 83 ec 50          	sub    $0x50,%rsp
  801016:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80101a:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80101d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801021:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801025:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801029:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80102d:	48 8b 0a             	mov    (%rdx),%rcx
  801030:	48 89 08             	mov    %rcx,(%rax)
  801033:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801037:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80103b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80103f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801043:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801047:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80104b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80104e:	48 98                	cltq   
  801050:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801054:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801058:	48 01 d0             	add    %rdx,%rax
  80105b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80105f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801066:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80106b:	74 06                	je     801073 <vsnprintf+0x65>
  80106d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801071:	7f 07                	jg     80107a <vsnprintf+0x6c>
		return -E_INVAL;
  801073:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801078:	eb 2f                	jmp    8010a9 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80107a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80107e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801082:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801086:	48 89 c6             	mov    %rax,%rsi
  801089:	48 bf c1 0f 80 00 00 	movabs $0x800fc1,%rdi
  801090:	00 00 00 
  801093:	48 b8 b5 09 80 00 00 	movabs $0x8009b5,%rax
  80109a:	00 00 00 
  80109d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80109f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010a3:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010a6:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010a9:	c9                   	leaveq 
  8010aa:	c3                   	retq   

00000000008010ab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010ab:	55                   	push   %rbp
  8010ac:	48 89 e5             	mov    %rsp,%rbp
  8010af:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010b6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010bd:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010c3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010ca:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010d1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010d8:	84 c0                	test   %al,%al
  8010da:	74 20                	je     8010fc <snprintf+0x51>
  8010dc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010e0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010e4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010e8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010ec:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010f0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010f4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010f8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010fc:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801103:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80110a:	00 00 00 
  80110d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801114:	00 00 00 
  801117:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80111b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801122:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801129:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801130:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801137:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80113e:	48 8b 0a             	mov    (%rdx),%rcx
  801141:	48 89 08             	mov    %rcx,(%rax)
  801144:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801148:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80114c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801150:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801154:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80115b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801162:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801168:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80116f:	48 89 c7             	mov    %rax,%rdi
  801172:	48 b8 0e 10 80 00 00 	movabs $0x80100e,%rax
  801179:	00 00 00 
  80117c:	ff d0                	callq  *%rax
  80117e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801184:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80118a:	c9                   	leaveq 
  80118b:	c3                   	retq   

000000000080118c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80118c:	55                   	push   %rbp
  80118d:	48 89 e5             	mov    %rsp,%rbp
  801190:	48 83 ec 18          	sub    $0x18,%rsp
  801194:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801198:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80119f:	eb 09                	jmp    8011aa <strlen+0x1e>
		n++;
  8011a1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011a5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ae:	0f b6 00             	movzbl (%rax),%eax
  8011b1:	84 c0                	test   %al,%al
  8011b3:	75 ec                	jne    8011a1 <strlen+0x15>
		n++;
	return n;
  8011b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011b8:	c9                   	leaveq 
  8011b9:	c3                   	retq   

00000000008011ba <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011ba:	55                   	push   %rbp
  8011bb:	48 89 e5             	mov    %rsp,%rbp
  8011be:	48 83 ec 20          	sub    $0x20,%rsp
  8011c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011d1:	eb 0e                	jmp    8011e1 <strnlen+0x27>
		n++;
  8011d3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011d7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011dc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011e1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011e6:	74 0b                	je     8011f3 <strnlen+0x39>
  8011e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ec:	0f b6 00             	movzbl (%rax),%eax
  8011ef:	84 c0                	test   %al,%al
  8011f1:	75 e0                	jne    8011d3 <strnlen+0x19>
		n++;
	return n;
  8011f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011f6:	c9                   	leaveq 
  8011f7:	c3                   	retq   

00000000008011f8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011f8:	55                   	push   %rbp
  8011f9:	48 89 e5             	mov    %rsp,%rbp
  8011fc:	48 83 ec 20          	sub    $0x20,%rsp
  801200:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801204:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801208:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801210:	90                   	nop
  801211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801215:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801219:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80121d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801221:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801225:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801229:	0f b6 12             	movzbl (%rdx),%edx
  80122c:	88 10                	mov    %dl,(%rax)
  80122e:	0f b6 00             	movzbl (%rax),%eax
  801231:	84 c0                	test   %al,%al
  801233:	75 dc                	jne    801211 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801239:	c9                   	leaveq 
  80123a:	c3                   	retq   

000000000080123b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80123b:	55                   	push   %rbp
  80123c:	48 89 e5             	mov    %rsp,%rbp
  80123f:	48 83 ec 20          	sub    $0x20,%rsp
  801243:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801247:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80124b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124f:	48 89 c7             	mov    %rax,%rdi
  801252:	48 b8 8c 11 80 00 00 	movabs $0x80118c,%rax
  801259:	00 00 00 
  80125c:	ff d0                	callq  *%rax
  80125e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801261:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801264:	48 63 d0             	movslq %eax,%rdx
  801267:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126b:	48 01 c2             	add    %rax,%rdx
  80126e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801272:	48 89 c6             	mov    %rax,%rsi
  801275:	48 89 d7             	mov    %rdx,%rdi
  801278:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  80127f:	00 00 00 
  801282:	ff d0                	callq  *%rax
	return dst;
  801284:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801288:	c9                   	leaveq 
  801289:	c3                   	retq   

000000000080128a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80128a:	55                   	push   %rbp
  80128b:	48 89 e5             	mov    %rsp,%rbp
  80128e:	48 83 ec 28          	sub    $0x28,%rsp
  801292:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801296:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80129a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80129e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012a6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012ad:	00 
  8012ae:	eb 2a                	jmp    8012da <strncpy+0x50>
		*dst++ = *src;
  8012b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012bc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012c0:	0f b6 12             	movzbl (%rdx),%edx
  8012c3:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c9:	0f b6 00             	movzbl (%rax),%eax
  8012cc:	84 c0                	test   %al,%al
  8012ce:	74 05                	je     8012d5 <strncpy+0x4b>
			src++;
  8012d0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012de:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012e2:	72 cc                	jb     8012b0 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012e8:	c9                   	leaveq 
  8012e9:	c3                   	retq   

00000000008012ea <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012ea:	55                   	push   %rbp
  8012eb:	48 89 e5             	mov    %rsp,%rbp
  8012ee:	48 83 ec 28          	sub    $0x28,%rsp
  8012f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801302:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801306:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80130b:	74 3d                	je     80134a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80130d:	eb 1d                	jmp    80132c <strlcpy+0x42>
			*dst++ = *src++;
  80130f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801313:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801317:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80131b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80131f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801323:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801327:	0f b6 12             	movzbl (%rdx),%edx
  80132a:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80132c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801331:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801336:	74 0b                	je     801343 <strlcpy+0x59>
  801338:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80133c:	0f b6 00             	movzbl (%rax),%eax
  80133f:	84 c0                	test   %al,%al
  801341:	75 cc                	jne    80130f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801347:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80134a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80134e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801352:	48 29 c2             	sub    %rax,%rdx
  801355:	48 89 d0             	mov    %rdx,%rax
}
  801358:	c9                   	leaveq 
  801359:	c3                   	retq   

000000000080135a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80135a:	55                   	push   %rbp
  80135b:	48 89 e5             	mov    %rsp,%rbp
  80135e:	48 83 ec 10          	sub    $0x10,%rsp
  801362:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801366:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80136a:	eb 0a                	jmp    801376 <strcmp+0x1c>
		p++, q++;
  80136c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801371:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137a:	0f b6 00             	movzbl (%rax),%eax
  80137d:	84 c0                	test   %al,%al
  80137f:	74 12                	je     801393 <strcmp+0x39>
  801381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801385:	0f b6 10             	movzbl (%rax),%edx
  801388:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138c:	0f b6 00             	movzbl (%rax),%eax
  80138f:	38 c2                	cmp    %al,%dl
  801391:	74 d9                	je     80136c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801393:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801397:	0f b6 00             	movzbl (%rax),%eax
  80139a:	0f b6 d0             	movzbl %al,%edx
  80139d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a1:	0f b6 00             	movzbl (%rax),%eax
  8013a4:	0f b6 c0             	movzbl %al,%eax
  8013a7:	29 c2                	sub    %eax,%edx
  8013a9:	89 d0                	mov    %edx,%eax
}
  8013ab:	c9                   	leaveq 
  8013ac:	c3                   	retq   

00000000008013ad <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013ad:	55                   	push   %rbp
  8013ae:	48 89 e5             	mov    %rsp,%rbp
  8013b1:	48 83 ec 18          	sub    $0x18,%rsp
  8013b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013bd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013c1:	eb 0f                	jmp    8013d2 <strncmp+0x25>
		n--, p++, q++;
  8013c3:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013c8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013cd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013d7:	74 1d                	je     8013f6 <strncmp+0x49>
  8013d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013dd:	0f b6 00             	movzbl (%rax),%eax
  8013e0:	84 c0                	test   %al,%al
  8013e2:	74 12                	je     8013f6 <strncmp+0x49>
  8013e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e8:	0f b6 10             	movzbl (%rax),%edx
  8013eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ef:	0f b6 00             	movzbl (%rax),%eax
  8013f2:	38 c2                	cmp    %al,%dl
  8013f4:	74 cd                	je     8013c3 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013fb:	75 07                	jne    801404 <strncmp+0x57>
		return 0;
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801402:	eb 18                	jmp    80141c <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801404:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801408:	0f b6 00             	movzbl (%rax),%eax
  80140b:	0f b6 d0             	movzbl %al,%edx
  80140e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801412:	0f b6 00             	movzbl (%rax),%eax
  801415:	0f b6 c0             	movzbl %al,%eax
  801418:	29 c2                	sub    %eax,%edx
  80141a:	89 d0                	mov    %edx,%eax
}
  80141c:	c9                   	leaveq 
  80141d:	c3                   	retq   

000000000080141e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80141e:	55                   	push   %rbp
  80141f:	48 89 e5             	mov    %rsp,%rbp
  801422:	48 83 ec 0c          	sub    $0xc,%rsp
  801426:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80142a:	89 f0                	mov    %esi,%eax
  80142c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80142f:	eb 17                	jmp    801448 <strchr+0x2a>
		if (*s == c)
  801431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801435:	0f b6 00             	movzbl (%rax),%eax
  801438:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80143b:	75 06                	jne    801443 <strchr+0x25>
			return (char *) s;
  80143d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801441:	eb 15                	jmp    801458 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801443:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801448:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144c:	0f b6 00             	movzbl (%rax),%eax
  80144f:	84 c0                	test   %al,%al
  801451:	75 de                	jne    801431 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801453:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801458:	c9                   	leaveq 
  801459:	c3                   	retq   

000000000080145a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80145a:	55                   	push   %rbp
  80145b:	48 89 e5             	mov    %rsp,%rbp
  80145e:	48 83 ec 0c          	sub    $0xc,%rsp
  801462:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801466:	89 f0                	mov    %esi,%eax
  801468:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80146b:	eb 13                	jmp    801480 <strfind+0x26>
		if (*s == c)
  80146d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801471:	0f b6 00             	movzbl (%rax),%eax
  801474:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801477:	75 02                	jne    80147b <strfind+0x21>
			break;
  801479:	eb 10                	jmp    80148b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80147b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801480:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801484:	0f b6 00             	movzbl (%rax),%eax
  801487:	84 c0                	test   %al,%al
  801489:	75 e2                	jne    80146d <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80148b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80148f:	c9                   	leaveq 
  801490:	c3                   	retq   

0000000000801491 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801491:	55                   	push   %rbp
  801492:	48 89 e5             	mov    %rsp,%rbp
  801495:	48 83 ec 18          	sub    $0x18,%rsp
  801499:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014a4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014a9:	75 06                	jne    8014b1 <memset+0x20>
		return v;
  8014ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014af:	eb 69                	jmp    80151a <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b5:	83 e0 03             	and    $0x3,%eax
  8014b8:	48 85 c0             	test   %rax,%rax
  8014bb:	75 48                	jne    801505 <memset+0x74>
  8014bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c1:	83 e0 03             	and    $0x3,%eax
  8014c4:	48 85 c0             	test   %rax,%rax
  8014c7:	75 3c                	jne    801505 <memset+0x74>
		c &= 0xFF;
  8014c9:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014d3:	c1 e0 18             	shl    $0x18,%eax
  8014d6:	89 c2                	mov    %eax,%edx
  8014d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014db:	c1 e0 10             	shl    $0x10,%eax
  8014de:	09 c2                	or     %eax,%edx
  8014e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e3:	c1 e0 08             	shl    $0x8,%eax
  8014e6:	09 d0                	or     %edx,%eax
  8014e8:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ef:	48 c1 e8 02          	shr    $0x2,%rax
  8014f3:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014fd:	48 89 d7             	mov    %rdx,%rdi
  801500:	fc                   	cld    
  801501:	f3 ab                	rep stos %eax,%es:(%rdi)
  801503:	eb 11                	jmp    801516 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801505:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801509:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80150c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801510:	48 89 d7             	mov    %rdx,%rdi
  801513:	fc                   	cld    
  801514:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801516:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80151a:	c9                   	leaveq 
  80151b:	c3                   	retq   

000000000080151c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80151c:	55                   	push   %rbp
  80151d:	48 89 e5             	mov    %rsp,%rbp
  801520:	48 83 ec 28          	sub    $0x28,%rsp
  801524:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801528:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80152c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801530:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801534:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801540:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801544:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801548:	0f 83 88 00 00 00    	jae    8015d6 <memmove+0xba>
  80154e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801552:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801556:	48 01 d0             	add    %rdx,%rax
  801559:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80155d:	76 77                	jbe    8015d6 <memmove+0xba>
		s += n;
  80155f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801563:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80156f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801573:	83 e0 03             	and    $0x3,%eax
  801576:	48 85 c0             	test   %rax,%rax
  801579:	75 3b                	jne    8015b6 <memmove+0x9a>
  80157b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157f:	83 e0 03             	and    $0x3,%eax
  801582:	48 85 c0             	test   %rax,%rax
  801585:	75 2f                	jne    8015b6 <memmove+0x9a>
  801587:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158b:	83 e0 03             	and    $0x3,%eax
  80158e:	48 85 c0             	test   %rax,%rax
  801591:	75 23                	jne    8015b6 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801593:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801597:	48 83 e8 04          	sub    $0x4,%rax
  80159b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80159f:	48 83 ea 04          	sub    $0x4,%rdx
  8015a3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015a7:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015ab:	48 89 c7             	mov    %rax,%rdi
  8015ae:	48 89 d6             	mov    %rdx,%rsi
  8015b1:	fd                   	std    
  8015b2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015b4:	eb 1d                	jmp    8015d3 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ba:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c2:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ca:	48 89 d7             	mov    %rdx,%rdi
  8015cd:	48 89 c1             	mov    %rax,%rcx
  8015d0:	fd                   	std    
  8015d1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015d3:	fc                   	cld    
  8015d4:	eb 57                	jmp    80162d <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015da:	83 e0 03             	and    $0x3,%eax
  8015dd:	48 85 c0             	test   %rax,%rax
  8015e0:	75 36                	jne    801618 <memmove+0xfc>
  8015e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e6:	83 e0 03             	and    $0x3,%eax
  8015e9:	48 85 c0             	test   %rax,%rax
  8015ec:	75 2a                	jne    801618 <memmove+0xfc>
  8015ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f2:	83 e0 03             	and    $0x3,%eax
  8015f5:	48 85 c0             	test   %rax,%rax
  8015f8:	75 1e                	jne    801618 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fe:	48 c1 e8 02          	shr    $0x2,%rax
  801602:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801605:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801609:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80160d:	48 89 c7             	mov    %rax,%rdi
  801610:	48 89 d6             	mov    %rdx,%rsi
  801613:	fc                   	cld    
  801614:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801616:	eb 15                	jmp    80162d <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801618:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801620:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801624:	48 89 c7             	mov    %rax,%rdi
  801627:	48 89 d6             	mov    %rdx,%rsi
  80162a:	fc                   	cld    
  80162b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80162d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801631:	c9                   	leaveq 
  801632:	c3                   	retq   

0000000000801633 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801633:	55                   	push   %rbp
  801634:	48 89 e5             	mov    %rsp,%rbp
  801637:	48 83 ec 18          	sub    $0x18,%rsp
  80163b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80163f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801643:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801647:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80164b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80164f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801653:	48 89 ce             	mov    %rcx,%rsi
  801656:	48 89 c7             	mov    %rax,%rdi
  801659:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  801660:	00 00 00 
  801663:	ff d0                	callq  *%rax
}
  801665:	c9                   	leaveq 
  801666:	c3                   	retq   

0000000000801667 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801667:	55                   	push   %rbp
  801668:	48 89 e5             	mov    %rsp,%rbp
  80166b:	48 83 ec 28          	sub    $0x28,%rsp
  80166f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801673:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801677:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80167b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80167f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801683:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801687:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80168b:	eb 36                	jmp    8016c3 <memcmp+0x5c>
		if (*s1 != *s2)
  80168d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801691:	0f b6 10             	movzbl (%rax),%edx
  801694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801698:	0f b6 00             	movzbl (%rax),%eax
  80169b:	38 c2                	cmp    %al,%dl
  80169d:	74 1a                	je     8016b9 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80169f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a3:	0f b6 00             	movzbl (%rax),%eax
  8016a6:	0f b6 d0             	movzbl %al,%edx
  8016a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ad:	0f b6 00             	movzbl (%rax),%eax
  8016b0:	0f b6 c0             	movzbl %al,%eax
  8016b3:	29 c2                	sub    %eax,%edx
  8016b5:	89 d0                	mov    %edx,%eax
  8016b7:	eb 20                	jmp    8016d9 <memcmp+0x72>
		s1++, s2++;
  8016b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016be:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016cf:	48 85 c0             	test   %rax,%rax
  8016d2:	75 b9                	jne    80168d <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d9:	c9                   	leaveq 
  8016da:	c3                   	retq   

00000000008016db <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016db:	55                   	push   %rbp
  8016dc:	48 89 e5             	mov    %rsp,%rbp
  8016df:	48 83 ec 28          	sub    $0x28,%rsp
  8016e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016e7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016f6:	48 01 d0             	add    %rdx,%rax
  8016f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016fd:	eb 15                	jmp    801714 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801703:	0f b6 10             	movzbl (%rax),%edx
  801706:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801709:	38 c2                	cmp    %al,%dl
  80170b:	75 02                	jne    80170f <memfind+0x34>
			break;
  80170d:	eb 0f                	jmp    80171e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80170f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801718:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80171c:	72 e1                	jb     8016ff <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80171e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801722:	c9                   	leaveq 
  801723:	c3                   	retq   

0000000000801724 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801724:	55                   	push   %rbp
  801725:	48 89 e5             	mov    %rsp,%rbp
  801728:	48 83 ec 34          	sub    $0x34,%rsp
  80172c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801730:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801734:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801737:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80173e:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801745:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801746:	eb 05                	jmp    80174d <strtol+0x29>
		s++;
  801748:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801751:	0f b6 00             	movzbl (%rax),%eax
  801754:	3c 20                	cmp    $0x20,%al
  801756:	74 f0                	je     801748 <strtol+0x24>
  801758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175c:	0f b6 00             	movzbl (%rax),%eax
  80175f:	3c 09                	cmp    $0x9,%al
  801761:	74 e5                	je     801748 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801763:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801767:	0f b6 00             	movzbl (%rax),%eax
  80176a:	3c 2b                	cmp    $0x2b,%al
  80176c:	75 07                	jne    801775 <strtol+0x51>
		s++;
  80176e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801773:	eb 17                	jmp    80178c <strtol+0x68>
	else if (*s == '-')
  801775:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801779:	0f b6 00             	movzbl (%rax),%eax
  80177c:	3c 2d                	cmp    $0x2d,%al
  80177e:	75 0c                	jne    80178c <strtol+0x68>
		s++, neg = 1;
  801780:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801785:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80178c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801790:	74 06                	je     801798 <strtol+0x74>
  801792:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801796:	75 28                	jne    8017c0 <strtol+0x9c>
  801798:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179c:	0f b6 00             	movzbl (%rax),%eax
  80179f:	3c 30                	cmp    $0x30,%al
  8017a1:	75 1d                	jne    8017c0 <strtol+0x9c>
  8017a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a7:	48 83 c0 01          	add    $0x1,%rax
  8017ab:	0f b6 00             	movzbl (%rax),%eax
  8017ae:	3c 78                	cmp    $0x78,%al
  8017b0:	75 0e                	jne    8017c0 <strtol+0x9c>
		s += 2, base = 16;
  8017b2:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017b7:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017be:	eb 2c                	jmp    8017ec <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017c0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017c4:	75 19                	jne    8017df <strtol+0xbb>
  8017c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ca:	0f b6 00             	movzbl (%rax),%eax
  8017cd:	3c 30                	cmp    $0x30,%al
  8017cf:	75 0e                	jne    8017df <strtol+0xbb>
		s++, base = 8;
  8017d1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017d6:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017dd:	eb 0d                	jmp    8017ec <strtol+0xc8>
	else if (base == 0)
  8017df:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017e3:	75 07                	jne    8017ec <strtol+0xc8>
		base = 10;
  8017e5:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f0:	0f b6 00             	movzbl (%rax),%eax
  8017f3:	3c 2f                	cmp    $0x2f,%al
  8017f5:	7e 1d                	jle    801814 <strtol+0xf0>
  8017f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fb:	0f b6 00             	movzbl (%rax),%eax
  8017fe:	3c 39                	cmp    $0x39,%al
  801800:	7f 12                	jg     801814 <strtol+0xf0>
			dig = *s - '0';
  801802:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801806:	0f b6 00             	movzbl (%rax),%eax
  801809:	0f be c0             	movsbl %al,%eax
  80180c:	83 e8 30             	sub    $0x30,%eax
  80180f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801812:	eb 4e                	jmp    801862 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801814:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801818:	0f b6 00             	movzbl (%rax),%eax
  80181b:	3c 60                	cmp    $0x60,%al
  80181d:	7e 1d                	jle    80183c <strtol+0x118>
  80181f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801823:	0f b6 00             	movzbl (%rax),%eax
  801826:	3c 7a                	cmp    $0x7a,%al
  801828:	7f 12                	jg     80183c <strtol+0x118>
			dig = *s - 'a' + 10;
  80182a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182e:	0f b6 00             	movzbl (%rax),%eax
  801831:	0f be c0             	movsbl %al,%eax
  801834:	83 e8 57             	sub    $0x57,%eax
  801837:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80183a:	eb 26                	jmp    801862 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80183c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801840:	0f b6 00             	movzbl (%rax),%eax
  801843:	3c 40                	cmp    $0x40,%al
  801845:	7e 48                	jle    80188f <strtol+0x16b>
  801847:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184b:	0f b6 00             	movzbl (%rax),%eax
  80184e:	3c 5a                	cmp    $0x5a,%al
  801850:	7f 3d                	jg     80188f <strtol+0x16b>
			dig = *s - 'A' + 10;
  801852:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801856:	0f b6 00             	movzbl (%rax),%eax
  801859:	0f be c0             	movsbl %al,%eax
  80185c:	83 e8 37             	sub    $0x37,%eax
  80185f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801862:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801865:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801868:	7c 02                	jl     80186c <strtol+0x148>
			break;
  80186a:	eb 23                	jmp    80188f <strtol+0x16b>
		s++, val = (val * base) + dig;
  80186c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801871:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801874:	48 98                	cltq   
  801876:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80187b:	48 89 c2             	mov    %rax,%rdx
  80187e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801881:	48 98                	cltq   
  801883:	48 01 d0             	add    %rdx,%rax
  801886:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80188a:	e9 5d ff ff ff       	jmpq   8017ec <strtol+0xc8>

	if (endptr)
  80188f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801894:	74 0b                	je     8018a1 <strtol+0x17d>
		*endptr = (char *) s;
  801896:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80189a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80189e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018a5:	74 09                	je     8018b0 <strtol+0x18c>
  8018a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ab:	48 f7 d8             	neg    %rax
  8018ae:	eb 04                	jmp    8018b4 <strtol+0x190>
  8018b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018b4:	c9                   	leaveq 
  8018b5:	c3                   	retq   

00000000008018b6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018b6:	55                   	push   %rbp
  8018b7:	48 89 e5             	mov    %rsp,%rbp
  8018ba:	48 83 ec 30          	sub    $0x30,%rsp
  8018be:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018ca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018ce:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018d2:	0f b6 00             	movzbl (%rax),%eax
  8018d5:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018d8:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018dc:	75 06                	jne    8018e4 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e2:	eb 6b                	jmp    80194f <strstr+0x99>

	len = strlen(str);
  8018e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e8:	48 89 c7             	mov    %rax,%rdi
  8018eb:	48 b8 8c 11 80 00 00 	movabs $0x80118c,%rax
  8018f2:	00 00 00 
  8018f5:	ff d0                	callq  *%rax
  8018f7:	48 98                	cltq   
  8018f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801901:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801905:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801909:	0f b6 00             	movzbl (%rax),%eax
  80190c:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80190f:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801913:	75 07                	jne    80191c <strstr+0x66>
				return (char *) 0;
  801915:	b8 00 00 00 00       	mov    $0x0,%eax
  80191a:	eb 33                	jmp    80194f <strstr+0x99>
		} while (sc != c);
  80191c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801920:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801923:	75 d8                	jne    8018fd <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801925:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801929:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80192d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801931:	48 89 ce             	mov    %rcx,%rsi
  801934:	48 89 c7             	mov    %rax,%rdi
  801937:	48 b8 ad 13 80 00 00 	movabs $0x8013ad,%rax
  80193e:	00 00 00 
  801941:	ff d0                	callq  *%rax
  801943:	85 c0                	test   %eax,%eax
  801945:	75 b6                	jne    8018fd <strstr+0x47>

	return (char *) (in - 1);
  801947:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194b:	48 83 e8 01          	sub    $0x1,%rax
}
  80194f:	c9                   	leaveq 
  801950:	c3                   	retq   

0000000000801951 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801951:	55                   	push   %rbp
  801952:	48 89 e5             	mov    %rsp,%rbp
  801955:	53                   	push   %rbx
  801956:	48 83 ec 48          	sub    $0x48,%rsp
  80195a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80195d:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801960:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801964:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801968:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80196c:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801970:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801973:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801977:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80197b:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80197f:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801983:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801987:	4c 89 c3             	mov    %r8,%rbx
  80198a:	cd 30                	int    $0x30
  80198c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801990:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801994:	74 3e                	je     8019d4 <syscall+0x83>
  801996:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80199b:	7e 37                	jle    8019d4 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80199d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019a1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019a4:	49 89 d0             	mov    %rdx,%r8
  8019a7:	89 c1                	mov    %eax,%ecx
  8019a9:	48 ba a8 49 80 00 00 	movabs $0x8049a8,%rdx
  8019b0:	00 00 00 
  8019b3:	be 23 00 00 00       	mov    $0x23,%esi
  8019b8:	48 bf c5 49 80 00 00 	movabs $0x8049c5,%rdi
  8019bf:	00 00 00 
  8019c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c7:	49 b9 c9 03 80 00 00 	movabs $0x8003c9,%r9
  8019ce:	00 00 00 
  8019d1:	41 ff d1             	callq  *%r9

	return ret;
  8019d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019d8:	48 83 c4 48          	add    $0x48,%rsp
  8019dc:	5b                   	pop    %rbx
  8019dd:	5d                   	pop    %rbp
  8019de:	c3                   	retq   

00000000008019df <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019df:	55                   	push   %rbp
  8019e0:	48 89 e5             	mov    %rsp,%rbp
  8019e3:	48 83 ec 20          	sub    $0x20,%rsp
  8019e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019fe:	00 
  8019ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0b:	48 89 d1             	mov    %rdx,%rcx
  801a0e:	48 89 c2             	mov    %rax,%rdx
  801a11:	be 00 00 00 00       	mov    $0x0,%esi
  801a16:	bf 00 00 00 00       	mov    $0x0,%edi
  801a1b:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801a22:	00 00 00 
  801a25:	ff d0                	callq  *%rax
}
  801a27:	c9                   	leaveq 
  801a28:	c3                   	retq   

0000000000801a29 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a29:	55                   	push   %rbp
  801a2a:	48 89 e5             	mov    %rsp,%rbp
  801a2d:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a38:	00 
  801a39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a45:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4f:	be 00 00 00 00       	mov    $0x0,%esi
  801a54:	bf 01 00 00 00       	mov    $0x1,%edi
  801a59:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801a60:	00 00 00 
  801a63:	ff d0                	callq  *%rax
}
  801a65:	c9                   	leaveq 
  801a66:	c3                   	retq   

0000000000801a67 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a67:	55                   	push   %rbp
  801a68:	48 89 e5             	mov    %rsp,%rbp
  801a6b:	48 83 ec 10          	sub    $0x10,%rsp
  801a6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a75:	48 98                	cltq   
  801a77:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a7e:	00 
  801a7f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a85:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a90:	48 89 c2             	mov    %rax,%rdx
  801a93:	be 01 00 00 00       	mov    $0x1,%esi
  801a98:	bf 03 00 00 00       	mov    $0x3,%edi
  801a9d:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801aa4:	00 00 00 
  801aa7:	ff d0                	callq  *%rax
}
  801aa9:	c9                   	leaveq 
  801aaa:	c3                   	retq   

0000000000801aab <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801aab:	55                   	push   %rbp
  801aac:	48 89 e5             	mov    %rsp,%rbp
  801aaf:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ab3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aba:	00 
  801abb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801acc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad1:	be 00 00 00 00       	mov    $0x0,%esi
  801ad6:	bf 02 00 00 00       	mov    $0x2,%edi
  801adb:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801ae2:	00 00 00 
  801ae5:	ff d0                	callq  *%rax
}
  801ae7:	c9                   	leaveq 
  801ae8:	c3                   	retq   

0000000000801ae9 <sys_yield>:

void
sys_yield(void)
{
  801ae9:	55                   	push   %rbp
  801aea:	48 89 e5             	mov    %rsp,%rbp
  801aed:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801af1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af8:	00 
  801af9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b05:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b0f:	be 00 00 00 00       	mov    $0x0,%esi
  801b14:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b19:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801b20:	00 00 00 
  801b23:	ff d0                	callq  *%rax
}
  801b25:	c9                   	leaveq 
  801b26:	c3                   	retq   

0000000000801b27 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b27:	55                   	push   %rbp
  801b28:	48 89 e5             	mov    %rsp,%rbp
  801b2b:	48 83 ec 20          	sub    $0x20,%rsp
  801b2f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b36:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b39:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b3c:	48 63 c8             	movslq %eax,%rcx
  801b3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b46:	48 98                	cltq   
  801b48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b4f:	00 
  801b50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b56:	49 89 c8             	mov    %rcx,%r8
  801b59:	48 89 d1             	mov    %rdx,%rcx
  801b5c:	48 89 c2             	mov    %rax,%rdx
  801b5f:	be 01 00 00 00       	mov    $0x1,%esi
  801b64:	bf 04 00 00 00       	mov    $0x4,%edi
  801b69:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801b70:	00 00 00 
  801b73:	ff d0                	callq  *%rax
}
  801b75:	c9                   	leaveq 
  801b76:	c3                   	retq   

0000000000801b77 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b77:	55                   	push   %rbp
  801b78:	48 89 e5             	mov    %rsp,%rbp
  801b7b:	48 83 ec 30          	sub    $0x30,%rsp
  801b7f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b82:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b86:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b89:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b8d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b91:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b94:	48 63 c8             	movslq %eax,%rcx
  801b97:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b9b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b9e:	48 63 f0             	movslq %eax,%rsi
  801ba1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba8:	48 98                	cltq   
  801baa:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bae:	49 89 f9             	mov    %rdi,%r9
  801bb1:	49 89 f0             	mov    %rsi,%r8
  801bb4:	48 89 d1             	mov    %rdx,%rcx
  801bb7:	48 89 c2             	mov    %rax,%rdx
  801bba:	be 01 00 00 00       	mov    $0x1,%esi
  801bbf:	bf 05 00 00 00       	mov    $0x5,%edi
  801bc4:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801bcb:	00 00 00 
  801bce:	ff d0                	callq  *%rax
}
  801bd0:	c9                   	leaveq 
  801bd1:	c3                   	retq   

0000000000801bd2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bd2:	55                   	push   %rbp
  801bd3:	48 89 e5             	mov    %rsp,%rbp
  801bd6:	48 83 ec 20          	sub    $0x20,%rsp
  801bda:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bdd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801be1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be8:	48 98                	cltq   
  801bea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf1:	00 
  801bf2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bfe:	48 89 d1             	mov    %rdx,%rcx
  801c01:	48 89 c2             	mov    %rax,%rdx
  801c04:	be 01 00 00 00       	mov    $0x1,%esi
  801c09:	bf 06 00 00 00       	mov    $0x6,%edi
  801c0e:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801c15:	00 00 00 
  801c18:	ff d0                	callq  *%rax
}
  801c1a:	c9                   	leaveq 
  801c1b:	c3                   	retq   

0000000000801c1c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c1c:	55                   	push   %rbp
  801c1d:	48 89 e5             	mov    %rsp,%rbp
  801c20:	48 83 ec 10          	sub    $0x10,%rsp
  801c24:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c27:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c2d:	48 63 d0             	movslq %eax,%rdx
  801c30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c33:	48 98                	cltq   
  801c35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c3c:	00 
  801c3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c49:	48 89 d1             	mov    %rdx,%rcx
  801c4c:	48 89 c2             	mov    %rax,%rdx
  801c4f:	be 01 00 00 00       	mov    $0x1,%esi
  801c54:	bf 08 00 00 00       	mov    $0x8,%edi
  801c59:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801c60:	00 00 00 
  801c63:	ff d0                	callq  *%rax
}
  801c65:	c9                   	leaveq 
  801c66:	c3                   	retq   

0000000000801c67 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c67:	55                   	push   %rbp
  801c68:	48 89 e5             	mov    %rsp,%rbp
  801c6b:	48 83 ec 20          	sub    $0x20,%rsp
  801c6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c7d:	48 98                	cltq   
  801c7f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c86:	00 
  801c87:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c8d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c93:	48 89 d1             	mov    %rdx,%rcx
  801c96:	48 89 c2             	mov    %rax,%rdx
  801c99:	be 01 00 00 00       	mov    $0x1,%esi
  801c9e:	bf 09 00 00 00       	mov    $0x9,%edi
  801ca3:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801caa:	00 00 00 
  801cad:	ff d0                	callq  *%rax
}
  801caf:	c9                   	leaveq 
  801cb0:	c3                   	retq   

0000000000801cb1 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cb1:	55                   	push   %rbp
  801cb2:	48 89 e5             	mov    %rsp,%rbp
  801cb5:	48 83 ec 20          	sub    $0x20,%rsp
  801cb9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cbc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cc0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc7:	48 98                	cltq   
  801cc9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd0:	00 
  801cd1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cdd:	48 89 d1             	mov    %rdx,%rcx
  801ce0:	48 89 c2             	mov    %rax,%rdx
  801ce3:	be 01 00 00 00       	mov    $0x1,%esi
  801ce8:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ced:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801cf4:	00 00 00 
  801cf7:	ff d0                	callq  *%rax
}
  801cf9:	c9                   	leaveq 
  801cfa:	c3                   	retq   

0000000000801cfb <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801cfb:	55                   	push   %rbp
  801cfc:	48 89 e5             	mov    %rsp,%rbp
  801cff:	48 83 ec 10          	sub    $0x10,%rsp
  801d03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d06:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801d09:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d0c:	48 63 d0             	movslq %eax,%rdx
  801d0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d12:	48 98                	cltq   
  801d14:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d1b:	00 
  801d1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d28:	48 89 d1             	mov    %rdx,%rcx
  801d2b:	48 89 c2             	mov    %rax,%rdx
  801d2e:	be 01 00 00 00       	mov    $0x1,%esi
  801d33:	bf 11 00 00 00       	mov    $0x11,%edi
  801d38:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801d3f:	00 00 00 
  801d42:	ff d0                	callq  *%rax

}
  801d44:	c9                   	leaveq 
  801d45:	c3                   	retq   

0000000000801d46 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d46:	55                   	push   %rbp
  801d47:	48 89 e5             	mov    %rsp,%rbp
  801d4a:	48 83 ec 20          	sub    $0x20,%rsp
  801d4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d55:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d59:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d5f:	48 63 f0             	movslq %eax,%rsi
  801d62:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d69:	48 98                	cltq   
  801d6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d6f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d76:	00 
  801d77:	49 89 f1             	mov    %rsi,%r9
  801d7a:	49 89 c8             	mov    %rcx,%r8
  801d7d:	48 89 d1             	mov    %rdx,%rcx
  801d80:	48 89 c2             	mov    %rax,%rdx
  801d83:	be 00 00 00 00       	mov    $0x0,%esi
  801d88:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d8d:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801d94:	00 00 00 
  801d97:	ff d0                	callq  *%rax
}
  801d99:	c9                   	leaveq 
  801d9a:	c3                   	retq   

0000000000801d9b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d9b:	55                   	push   %rbp
  801d9c:	48 89 e5             	mov    %rsp,%rbp
  801d9f:	48 83 ec 10          	sub    $0x10,%rsp
  801da3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801da7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db2:	00 
  801db3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dbf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dc4:	48 89 c2             	mov    %rax,%rdx
  801dc7:	be 01 00 00 00       	mov    $0x1,%esi
  801dcc:	bf 0d 00 00 00       	mov    $0xd,%edi
  801dd1:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801dd8:	00 00 00 
  801ddb:	ff d0                	callq  *%rax
}
  801ddd:	c9                   	leaveq 
  801dde:	c3                   	retq   

0000000000801ddf <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801ddf:	55                   	push   %rbp
  801de0:	48 89 e5             	mov    %rsp,%rbp
  801de3:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801de7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dee:	00 
  801def:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801df5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dfb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e00:	ba 00 00 00 00       	mov    $0x0,%edx
  801e05:	be 00 00 00 00       	mov    $0x0,%esi
  801e0a:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e0f:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801e16:	00 00 00 
  801e19:	ff d0                	callq  *%rax
}
  801e1b:	c9                   	leaveq 
  801e1c:	c3                   	retq   

0000000000801e1d <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801e1d:	55                   	push   %rbp
  801e1e:	48 89 e5             	mov    %rsp,%rbp
  801e21:	48 83 ec 30          	sub    $0x30,%rsp
  801e25:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e28:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e2c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e2f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e33:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e37:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e3a:	48 63 c8             	movslq %eax,%rcx
  801e3d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e41:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e44:	48 63 f0             	movslq %eax,%rsi
  801e47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4e:	48 98                	cltq   
  801e50:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e54:	49 89 f9             	mov    %rdi,%r9
  801e57:	49 89 f0             	mov    %rsi,%r8
  801e5a:	48 89 d1             	mov    %rdx,%rcx
  801e5d:	48 89 c2             	mov    %rax,%rdx
  801e60:	be 00 00 00 00       	mov    $0x0,%esi
  801e65:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e6a:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801e71:	00 00 00 
  801e74:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e76:	c9                   	leaveq 
  801e77:	c3                   	retq   

0000000000801e78 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e78:	55                   	push   %rbp
  801e79:	48 89 e5             	mov    %rsp,%rbp
  801e7c:	48 83 ec 20          	sub    $0x20,%rsp
  801e80:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e84:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e90:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e97:	00 
  801e98:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e9e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ea4:	48 89 d1             	mov    %rdx,%rcx
  801ea7:	48 89 c2             	mov    %rax,%rdx
  801eaa:	be 00 00 00 00       	mov    $0x0,%esi
  801eaf:	bf 10 00 00 00       	mov    $0x10,%edi
  801eb4:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801ebb:	00 00 00 
  801ebe:	ff d0                	callq  *%rax
}
  801ec0:	c9                   	leaveq 
  801ec1:	c3                   	retq   

0000000000801ec2 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801ec2:	55                   	push   %rbp
  801ec3:	48 89 e5             	mov    %rsp,%rbp
  801ec6:	48 83 ec 30          	sub    $0x30,%rsp
  801eca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)



	void *addr = (void *) utf->utf_fault_va;
  801ece:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed2:	48 8b 00             	mov    (%rax),%rax
  801ed5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801ed9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801edd:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ee1:	89 45 f4             	mov    %eax,-0xc(%rbp)
        // Hint:
        //   Use the read-only page table mappings at vpt
        //   (see <inc/memlayout.h>).

        // LAB 4: Your code here.
	if (!(err&FEC_WR))
  801ee4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ee7:	83 e0 02             	and    $0x2,%eax
  801eea:	85 c0                	test   %eax,%eax
  801eec:	75 2a                	jne    801f18 <pgfault+0x56>
		panic("pgfault:FEC_WR check\n");
  801eee:	48 ba d8 49 80 00 00 	movabs $0x8049d8,%rdx
  801ef5:	00 00 00 
  801ef8:	be 21 00 00 00       	mov    $0x21,%esi
  801efd:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  801f04:	00 00 00 
  801f07:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0c:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  801f13:	00 00 00 
  801f16:	ff d1                	callq  *%rcx
	if (!(uvpt[((uint64_t)addr) / PGSIZE] & PTE_COW))
  801f18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1c:	48 c1 e8 0c          	shr    $0xc,%rax
  801f20:	48 89 c2             	mov    %rax,%rdx
  801f23:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f2a:	01 00 00 
  801f2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f31:	25 00 08 00 00       	and    $0x800,%eax
  801f36:	48 85 c0             	test   %rax,%rax
  801f39:	75 2a                	jne    801f65 <pgfault+0xa3>
		panic("pgfault:PTE_COW check\n");
  801f3b:	48 ba f9 49 80 00 00 	movabs $0x8049f9,%rdx
  801f42:	00 00 00 
  801f45:	be 23 00 00 00       	mov    $0x23,%esi
  801f4a:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  801f51:	00 00 00 
  801f54:	b8 00 00 00 00       	mov    $0x0,%eax
  801f59:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  801f60:	00 00 00 
  801f63:	ff d1                	callq  *%rcx
        // Hint:
        //   You should make three system calls.
        //   No need to explicitly delete the old page's mapping.

        // LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801f65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f69:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f71:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f77:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U)<0)
  801f7b:	ba 07 00 00 00       	mov    $0x7,%edx
  801f80:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f85:	bf 00 00 00 00       	mov    $0x0,%edi
  801f8a:	48 b8 27 1b 80 00 00 	movabs $0x801b27,%rax
  801f91:	00 00 00 
  801f94:	ff d0                	callq  *%rax
  801f96:	85 c0                	test   %eax,%eax
  801f98:	79 2a                	jns    801fc4 <pgfault+0x102>
		panic("pgfault: sys_page_alloc error\n");
  801f9a:	48 ba 10 4a 80 00 00 	movabs $0x804a10,%rdx
  801fa1:	00 00 00 
  801fa4:	be 2f 00 00 00       	mov    $0x2f,%esi
  801fa9:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  801fb0:	00 00 00 
  801fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb8:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  801fbf:	00 00 00 
  801fc2:	ff d1                	callq  *%rcx
	memcpy(PFTEMP, addr, PGSIZE);
  801fc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc8:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fcd:	48 89 c6             	mov    %rax,%rsi
  801fd0:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801fd5:	48 b8 33 16 80 00 00 	movabs $0x801633,%rax
  801fdc:	00 00 00 
  801fdf:	ff d0                	callq  *%rax
	if (sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0)
  801fe1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe5:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801feb:	48 89 c1             	mov    %rax,%rcx
  801fee:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff3:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ff8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ffd:	48 b8 77 1b 80 00 00 	movabs $0x801b77,%rax
  802004:	00 00 00 
  802007:	ff d0                	callq  *%rax
  802009:	85 c0                	test   %eax,%eax
  80200b:	79 2a                	jns    802037 <pgfault+0x175>
		panic("pgfault: sys_page_map error\n");
  80200d:	48 ba 2f 4a 80 00 00 	movabs $0x804a2f,%rdx
  802014:	00 00 00 
  802017:	be 32 00 00 00       	mov    $0x32,%esi
  80201c:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  802023:	00 00 00 
  802026:	b8 00 00 00 00       	mov    $0x0,%eax
  80202b:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  802032:	00 00 00 
  802035:	ff d1                	callq  *%rcx

	if (sys_page_unmap(0, (void *)PFTEMP)<0)
  802037:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80203c:	bf 00 00 00 00       	mov    $0x0,%edi
  802041:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  802048:	00 00 00 
  80204b:	ff d0                	callq  *%rax
  80204d:	85 c0                	test   %eax,%eax
  80204f:	79 2a                	jns    80207b <pgfault+0x1b9>
		panic("pgfault: sys_page_unmap error\n");
  802051:	48 ba 50 4a 80 00 00 	movabs $0x804a50,%rdx
  802058:	00 00 00 
  80205b:	be 35 00 00 00       	mov    $0x35,%esi
  802060:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  802067:	00 00 00 
  80206a:	b8 00 00 00 00       	mov    $0x0,%eax
  80206f:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  802076:	00 00 00 
  802079:	ff d1                	callq  *%rcx
	


}
  80207b:	c9                   	leaveq 
  80207c:	c3                   	retq   

000000000080207d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80207d:	55                   	push   %rbp
  80207e:	48 89 e5             	mov    %rsp,%rbp
  802081:	48 83 ec 10          	sub    $0x10,%rsp
  802085:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802088:	89 75 f8             	mov    %esi,-0x8(%rbp)

	if (uvpt[pn] & PTE_SHARE){
  80208b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802092:	01 00 00 
  802095:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802098:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80209c:	25 00 04 00 00       	and    $0x400,%eax
  8020a1:	48 85 c0             	test   %rax,%rax
  8020a4:	74 75                	je     80211b <duppage+0x9e>
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
  8020a6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ad:	01 00 00 
  8020b0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8020b3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8020bc:	89 c6                	mov    %eax,%esi
  8020be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020c1:	48 c1 e0 0c          	shl    $0xc,%rax
  8020c5:	48 89 c1             	mov    %rax,%rcx
  8020c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020cb:	48 c1 e0 0c          	shl    $0xc,%rax
  8020cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020d2:	41 89 f0             	mov    %esi,%r8d
  8020d5:	48 89 c6             	mov    %rax,%rsi
  8020d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8020dd:	48 b8 77 1b 80 00 00 	movabs $0x801b77,%rax
  8020e4:	00 00 00 
  8020e7:	ff d0                	callq  *%rax
  8020e9:	85 c0                	test   %eax,%eax
  8020eb:	0f 89 82 01 00 00    	jns    802273 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");	
  8020f1:	48 ba 6f 4a 80 00 00 	movabs $0x804a6f,%rdx
  8020f8:	00 00 00 
  8020fb:	be 4c 00 00 00       	mov    $0x4c,%esi
  802100:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  802107:	00 00 00 
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
  80210f:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  802116:	00 00 00 
  802119:	ff d1                	callq  *%rcx
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
  80211b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802122:	01 00 00 
  802125:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802128:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212c:	83 e0 02             	and    $0x2,%eax
  80212f:	48 85 c0             	test   %rax,%rax
  802132:	75 7e                	jne    8021b2 <duppage+0x135>
  802134:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80213b:	01 00 00 
  80213e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802141:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802145:	25 00 08 00 00       	and    $0x800,%eax
  80214a:	48 85 c0             	test   %rax,%rax
  80214d:	75 63                	jne    8021b2 <duppage+0x135>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  80214f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802152:	c1 e0 0c             	shl    $0xc,%eax
  802155:	89 c0                	mov    %eax,%eax
  802157:	48 89 c1             	mov    %rax,%rcx
  80215a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80215d:	c1 e0 0c             	shl    $0xc,%eax
  802160:	89 c0                	mov    %eax,%eax
  802162:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802165:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  80216b:	48 89 c6             	mov    %rax,%rsi
  80216e:	bf 00 00 00 00       	mov    $0x0,%edi
  802173:	48 b8 77 1b 80 00 00 	movabs $0x801b77,%rax
  80217a:	00 00 00 
  80217d:	ff d0                	callq  *%rax
  80217f:	85 c0                	test   %eax,%eax
  802181:	79 2a                	jns    8021ad <duppage+0x130>
			panic("duppage:sys_page_map error\n");
  802183:	48 ba 6f 4a 80 00 00 	movabs $0x804a6f,%rdx
  80218a:	00 00 00 
  80218d:	be 51 00 00 00       	mov    $0x51,%esi
  802192:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  802199:	00 00 00 
  80219c:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a1:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  8021a8:	00 00 00 
  8021ab:	ff d1                	callq  *%rcx
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
			panic("duppage:sys_page_map error\n");	
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  8021ad:	e9 c1 00 00 00       	jmpq   802273 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  8021b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021b5:	c1 e0 0c             	shl    $0xc,%eax
  8021b8:	89 c0                	mov    %eax,%eax
  8021ba:	48 89 c1             	mov    %rax,%rcx
  8021bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021c0:	c1 e0 0c             	shl    $0xc,%eax
  8021c3:	89 c0                	mov    %eax,%eax
  8021c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021c8:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8021ce:	48 89 c6             	mov    %rax,%rsi
  8021d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d6:	48 b8 77 1b 80 00 00 	movabs $0x801b77,%rax
  8021dd:	00 00 00 
  8021e0:	ff d0                	callq  *%rax
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	79 2a                	jns    802210 <duppage+0x193>
			panic("duppage:sys_page_map error\n");
  8021e6:	48 ba 6f 4a 80 00 00 	movabs $0x804a6f,%rdx
  8021ed:	00 00 00 
  8021f0:	be 55 00 00 00       	mov    $0x55,%esi
  8021f5:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  8021fc:	00 00 00 
  8021ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802204:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  80220b:	00 00 00 
  80220e:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  802210:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802213:	c1 e0 0c             	shl    $0xc,%eax
  802216:	89 c0                	mov    %eax,%eax
  802218:	48 89 c2             	mov    %rax,%rdx
  80221b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80221e:	c1 e0 0c             	shl    $0xc,%eax
  802221:	89 c0                	mov    %eax,%eax
  802223:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802229:	48 89 d1             	mov    %rdx,%rcx
  80222c:	ba 00 00 00 00       	mov    $0x0,%edx
  802231:	48 89 c6             	mov    %rax,%rsi
  802234:	bf 00 00 00 00       	mov    $0x0,%edi
  802239:	48 b8 77 1b 80 00 00 	movabs $0x801b77,%rax
  802240:	00 00 00 
  802243:	ff d0                	callq  *%rax
  802245:	85 c0                	test   %eax,%eax
  802247:	79 2a                	jns    802273 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
  802249:	48 ba 6f 4a 80 00 00 	movabs $0x804a6f,%rdx
  802250:	00 00 00 
  802253:	be 57 00 00 00       	mov    $0x57,%esi
  802258:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  80225f:	00 00 00 
  802262:	b8 00 00 00 00       	mov    $0x0,%eax
  802267:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  80226e:	00 00 00 
  802271:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  802273:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802278:	c9                   	leaveq 
  802279:	c3                   	retq   

000000000080227a <new_duppage>:


static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
  80227a:	55                   	push   %rbp
  80227b:	48 89 e5             	mov    %rsp,%rbp
  80227e:	48 83 ec 10          	sub    $0x10,%rsp
  802282:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802285:	89 75 f8             	mov    %esi,-0x8(%rbp)
  802288:	89 55 f4             	mov    %edx,-0xc(%rbp)
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
  80228b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802292:	01 00 00 
  802295:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802298:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80229c:	83 e0 02             	and    $0x2,%eax
  80229f:	48 85 c0             	test   %rax,%rax
  8022a2:	0f 85 84 00 00 00    	jne    80232c <new_duppage+0xb2>
  8022a8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022af:	01 00 00 
  8022b2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8022b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b9:	25 00 08 00 00       	and    $0x800,%eax
  8022be:	48 85 c0             	test   %rax,%rax
  8022c1:	75 69                	jne    80232c <new_duppage+0xb2>
  8022c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8022c7:	75 63                	jne    80232c <new_duppage+0xb2>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  8022c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022cc:	c1 e0 0c             	shl    $0xc,%eax
  8022cf:	89 c0                	mov    %eax,%eax
  8022d1:	48 89 c1             	mov    %rax,%rcx
  8022d4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022d7:	c1 e0 0c             	shl    $0xc,%eax
  8022da:	89 c0                	mov    %eax,%eax
  8022dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022df:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  8022e5:	48 89 c6             	mov    %rax,%rsi
  8022e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ed:	48 b8 77 1b 80 00 00 	movabs $0x801b77,%rax
  8022f4:	00 00 00 
  8022f7:	ff d0                	callq  *%rax
  8022f9:	85 c0                	test   %eax,%eax
  8022fb:	79 2a                	jns    802327 <new_duppage+0xad>
			panic("duppage:sys_page_map error\n");
  8022fd:	48 ba 6f 4a 80 00 00 	movabs $0x804a6f,%rdx
  802304:	00 00 00 
  802307:	be 64 00 00 00       	mov    $0x64,%esi
  80230c:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  802313:	00 00 00 
  802316:	b8 00 00 00 00       	mov    $0x0,%eax
  80231b:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  802322:	00 00 00 
  802325:	ff d1                	callq  *%rcx
static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  802327:	e9 c1 00 00 00       	jmpq   8023ed <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  80232c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80232f:	c1 e0 0c             	shl    $0xc,%eax
  802332:	89 c0                	mov    %eax,%eax
  802334:	48 89 c1             	mov    %rax,%rcx
  802337:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80233a:	c1 e0 0c             	shl    $0xc,%eax
  80233d:	89 c0                	mov    %eax,%eax
  80233f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802342:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802348:	48 89 c6             	mov    %rax,%rsi
  80234b:	bf 00 00 00 00       	mov    $0x0,%edi
  802350:	48 b8 77 1b 80 00 00 	movabs $0x801b77,%rax
  802357:	00 00 00 
  80235a:	ff d0                	callq  *%rax
  80235c:	85 c0                	test   %eax,%eax
  80235e:	79 2a                	jns    80238a <new_duppage+0x110>
			panic("duppage:sys_page_map error\n");
  802360:	48 ba 6f 4a 80 00 00 	movabs $0x804a6f,%rdx
  802367:	00 00 00 
  80236a:	be 68 00 00 00       	mov    $0x68,%esi
  80236f:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  802376:	00 00 00 
  802379:	b8 00 00 00 00       	mov    $0x0,%eax
  80237e:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  802385:	00 00 00 
  802388:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  80238a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80238d:	c1 e0 0c             	shl    $0xc,%eax
  802390:	89 c0                	mov    %eax,%eax
  802392:	48 89 c2             	mov    %rax,%rdx
  802395:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802398:	c1 e0 0c             	shl    $0xc,%eax
  80239b:	89 c0                	mov    %eax,%eax
  80239d:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8023a3:	48 89 d1             	mov    %rdx,%rcx
  8023a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ab:	48 89 c6             	mov    %rax,%rsi
  8023ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8023b3:	48 b8 77 1b 80 00 00 	movabs $0x801b77,%rax
  8023ba:	00 00 00 
  8023bd:	ff d0                	callq  *%rax
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	79 2a                	jns    8023ed <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
  8023c3:	48 ba 6f 4a 80 00 00 	movabs $0x804a6f,%rdx
  8023ca:	00 00 00 
  8023cd:	be 6a 00 00 00       	mov    $0x6a,%esi
  8023d2:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  8023d9:	00 00 00 
  8023dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e1:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  8023e8:	00 00 00 
  8023eb:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  8023ed:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8023f2:	c9                   	leaveq 
  8023f3:	c3                   	retq   

00000000008023f4 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8023f4:	55                   	push   %rbp
  8023f5:	48 89 e5             	mov    %rsp,%rbp
  8023f8:	48 83 ec 10          	sub    $0x10,%rsp


	
	int envid;  
	//extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  8023fc:	48 bf c2 1e 80 00 00 	movabs $0x801ec2,%rdi
  802403:	00 00 00 
  802406:	48 b8 e0 3f 80 00 00 	movabs $0x803fe0,%rax
  80240d:	00 00 00 
  802410:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802412:	b8 07 00 00 00       	mov    $0x7,%eax
  802417:	cd 30                	int    $0x30
  802419:	89 45 f0             	mov    %eax,-0x10(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80241c:	8b 45 f0             	mov    -0x10(%rbp),%eax


	if ((envid=sys_exofork())<0)
  80241f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802422:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802426:	79 2a                	jns    802452 <fork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  802428:	48 ba 8b 4a 80 00 00 	movabs $0x804a8b,%rdx
  80242f:	00 00 00 
  802432:	be 90 00 00 00       	mov    $0x90,%esi
  802437:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  80243e:	00 00 00 
  802441:	b8 00 00 00 00       	mov    $0x0,%eax
  802446:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  80244d:	00 00 00 
  802450:	ff d1                	callq  *%rcx

	if(envid>0){
  802452:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802456:	0f 8e e1 01 00 00    	jle    80263d <fork+0x249>
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  80245c:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  802463:	00 
  802464:	e9 d4 00 00 00       	jmpq   80253d <fork+0x149>
		{
			

               if(!(uvpml4e[VPML4E(i)]))
  802469:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80246d:	48 c1 e8 27          	shr    $0x27,%rax
  802471:	48 89 c2             	mov    %rax,%rdx
  802474:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80247b:	01 00 00 
  80247e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802482:	48 85 c0             	test   %rax,%rax
  802485:	75 05                	jne    80248c <fork+0x98>
		 continue;
  802487:	e9 a9 00 00 00       	jmpq   802535 <fork+0x141>
		
		if(!(uvpde[VPDPE(i)]))
  80248c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802490:	48 c1 e8 1e          	shr    $0x1e,%rax
  802494:	48 89 c2             	mov    %rax,%rdx
  802497:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80249e:	01 00 00 
  8024a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024a5:	48 85 c0             	test   %rax,%rax
  8024a8:	75 05                	jne    8024af <fork+0xbb>
	          continue;
  8024aa:	e9 86 00 00 00       	jmpq   802535 <fork+0x141>
	

			if(!(uvpd[VPD(i)] & PTE_P))
  8024af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024b3:	48 c1 e8 15          	shr    $0x15,%rax
  8024b7:	48 89 c2             	mov    %rax,%rdx
  8024ba:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024c1:	01 00 00 
  8024c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024c8:	83 e0 01             	and    $0x1,%eax
  8024cb:	48 85 c0             	test   %rax,%rax
  8024ce:	75 02                	jne    8024d2 <fork+0xde>
				continue;
  8024d0:	eb 63                	jmp    802535 <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_P))
  8024d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024d6:	48 c1 e8 0c          	shr    $0xc,%rax
  8024da:	48 89 c2             	mov    %rax,%rdx
  8024dd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024e4:	01 00 00 
  8024e7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024eb:	83 e0 01             	and    $0x1,%eax
  8024ee:	48 85 c0             	test   %rax,%rax
  8024f1:	75 02                	jne    8024f5 <fork+0x101>
				continue; 
  8024f3:	eb 40                	jmp    802535 <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_U))
  8024f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024f9:	48 c1 e8 0c          	shr    $0xc,%rax
  8024fd:	48 89 c2             	mov    %rax,%rdx
  802500:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802507:	01 00 00 
  80250a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80250e:	83 e0 04             	and    $0x4,%eax
  802511:	48 85 c0             	test   %rax,%rax
  802514:	75 02                	jne    802518 <fork+0x124>
				continue; 
  802516:	eb 1d                	jmp    802535 <fork+0x141>
			duppage(envid, VPN(i)); 
  802518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80251c:	48 c1 e8 0c          	shr    $0xc,%rax
  802520:	89 c2                	mov    %eax,%edx
  802522:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802525:	89 d6                	mov    %edx,%esi
  802527:	89 c7                	mov    %eax,%edi
  802529:	48 b8 7d 20 80 00 00 	movabs $0x80207d,%rax
  802530:	00 00 00 
  802533:	ff d0                	callq  *%rax

	if(envid>0){
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  802535:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  80253c:	00 
  80253d:	b8 ff cf 7f ef       	mov    $0xef7fcfff,%eax
  802542:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802546:	0f 86 1d ff ff ff    	jbe    802469 <fork+0x75>
			if(!(uvpt[VPN(i)] & PTE_U))
				continue; 
			duppage(envid, VPN(i)); 
		}

		if (sys_page_alloc(envid,(void*)UXSTACKTOP-PGSIZE, PTE_U|PTE_W|PTE_P)<0)
  80254c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80254f:	ba 07 00 00 00       	mov    $0x7,%edx
  802554:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802559:	89 c7                	mov    %eax,%edi
  80255b:	48 b8 27 1b 80 00 00 	movabs $0x801b27,%rax
  802562:	00 00 00 
  802565:	ff d0                	callq  *%rax
  802567:	85 c0                	test   %eax,%eax
  802569:	79 2a                	jns    802595 <fork+0x1a1>
			panic("fork: sys_page_alloc error!\n");
  80256b:	48 ba a5 4a 80 00 00 	movabs $0x804aa5,%rdx
  802572:	00 00 00 
  802575:	be ab 00 00 00       	mov    $0xab,%esi
  80257a:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  802581:	00 00 00 
  802584:	b8 00 00 00 00       	mov    $0x0,%eax
  802589:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  802590:	00 00 00 
  802593:	ff d1                	callq  *%rcx

		duppage(envid, VPN(USTACKTOP-PGSIZE));
  802595:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802598:	be fd f7 0e 00       	mov    $0xef7fd,%esi
  80259d:	89 c7                	mov    %eax,%edi
  80259f:	48 b8 7d 20 80 00 00 	movabs $0x80207d,%rax
  8025a6:	00 00 00 
  8025a9:	ff d0                	callq  *%rax
		extern void _pgfault_upcall(void);
		if (sys_env_set_pgfault_upcall(envid, _pgfault_upcall)<0)
  8025ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025ae:	48 be 80 40 80 00 00 	movabs $0x804080,%rsi
  8025b5:	00 00 00 
  8025b8:	89 c7                	mov    %eax,%edi
  8025ba:	48 b8 b1 1c 80 00 00 	movabs $0x801cb1,%rax
  8025c1:	00 00 00 
  8025c4:	ff d0                	callq  *%rax
  8025c6:	85 c0                	test   %eax,%eax
  8025c8:	79 2a                	jns    8025f4 <fork+0x200>
			panic("fork: sys_env_set_status error!\n");
  8025ca:	48 ba c8 4a 80 00 00 	movabs $0x804ac8,%rdx
  8025d1:	00 00 00 
  8025d4:	be b0 00 00 00       	mov    $0xb0,%esi
  8025d9:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  8025e0:	00 00 00 
  8025e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e8:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  8025ef:	00 00 00 
  8025f2:	ff d1                	callq  *%rcx
		if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  8025f4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025f7:	be 02 00 00 00       	mov    $0x2,%esi
  8025fc:	89 c7                	mov    %eax,%edi
  8025fe:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  802605:	00 00 00 
  802608:	ff d0                	callq  *%rax
  80260a:	85 c0                	test   %eax,%eax
  80260c:	79 2a                	jns    802638 <fork+0x244>
			panic("fork: sys_env_set_status error!\n");
  80260e:	48 ba c8 4a 80 00 00 	movabs $0x804ac8,%rdx
  802615:	00 00 00 
  802618:	be b2 00 00 00       	mov    $0xb2,%esi
  80261d:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  802624:	00 00 00 
  802627:	b8 00 00 00 00       	mov    $0x0,%eax
  80262c:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  802633:	00 00 00 
  802636:	ff d1                	callq  *%rcx

		return envid;
  802638:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80263b:	eb 39                	jmp    802676 <fork+0x282>
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80263d:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  802644:	00 00 00 
  802647:	ff d0                	callq  *%rax
  802649:	25 ff 03 00 00       	and    $0x3ff,%eax
  80264e:	48 98                	cltq   
  802650:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  802657:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80265e:	00 00 00 
  802661:	48 01 c2             	add    %rax,%rdx
  802664:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80266b:	00 00 00 
  80266e:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802671:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  802676:	c9                   	leaveq 
  802677:	c3                   	retq   

0000000000802678 <sfork>:

// Challenge!
envid_t
sfork(void)
{
  802678:	55                   	push   %rbp
  802679:	48 89 e5             	mov    %rsp,%rbp
  80267c:	48 83 ec 20          	sub    $0x20,%rsp

	
	int envid;  
	extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  802680:	48 bf c2 1e 80 00 00 	movabs $0x801ec2,%rdi
  802687:	00 00 00 
  80268a:	48 b8 e0 3f 80 00 00 	movabs $0x803fe0,%rax
  802691:	00 00 00 
  802694:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802696:	b8 07 00 00 00       	mov    $0x7,%eax
  80269b:	cd 30                	int    $0x30
  80269d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8026a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
	

	if ((envid=sys_exofork())<0)
  8026a3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8026a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8026aa:	79 2a                	jns    8026d6 <sfork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  8026ac:	48 ba 8b 4a 80 00 00 	movabs $0x804a8b,%rdx
  8026b3:	00 00 00 
  8026b6:	be ca 00 00 00       	mov    $0xca,%esi
  8026bb:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  8026c2:	00 00 00 
  8026c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ca:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  8026d1:	00 00 00 
  8026d4:	ff d1                	callq  *%rcx

	if(envid>0){
  8026d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8026da:	0f 8e e5 00 00 00    	jle    8027c5 <sfork+0x14d>
		
		
		uintptr_t i;
		int flag=1;
  8026e0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)

		for (i = 0; i < (uintptr_t)end/*USTACKTOP-PGSIZE*/; i += PGSIZE) ;
  8026e7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8026ee:	00 
  8026ef:	eb 08                	jmp    8026f9 <sfork+0x81>
  8026f1:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8026f8:	00 
  8026f9:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  802700:	00 00 00 
  802703:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802707:	72 e8                	jb     8026f1 <sfork+0x79>
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
  802709:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802710:	00 
    for (;i>=0; i -= PGSIZE) 
		{
			cprintf("23\n");
  802711:	48 bf e9 4a 80 00 00 	movabs $0x804ae9,%rdi
  802718:	00 00 00 
  80271b:	b8 00 00 00 00       	mov    $0x0,%eax
  802720:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  802727:	00 00 00 
  80272a:	ff d2                	callq  *%rdx
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
  80272c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802730:	48 c1 e8 15          	shr    $0x15,%rax
  802734:	48 89 c2             	mov    %rax,%rdx
  802737:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80273e:	01 00 00 
  802741:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802745:	83 e0 01             	and    $0x1,%eax
  802748:	48 85 c0             	test   %rax,%rax
  80274b:	74 42                	je     80278f <sfork+0x117>
  80274d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802751:	48 c1 e8 0c          	shr    $0xc,%rax
  802755:	48 89 c2             	mov    %rax,%rdx
  802758:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80275f:	01 00 00 
  802762:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802766:	83 e0 01             	and    $0x1,%eax
  802769:	48 85 c0             	test   %rax,%rax
  80276c:	74 21                	je     80278f <sfork+0x117>
  80276e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802772:	48 c1 e8 0c          	shr    $0xc,%rax
  802776:	48 89 c2             	mov    %rax,%rdx
  802779:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802780:	01 00 00 
  802783:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802787:	83 e0 04             	and    $0x4,%eax
  80278a:	48 85 c0             	test   %rax,%rax
  80278d:	75 09                	jne    802798 <sfork+0x120>
				flag=0;
  80278f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802796:	eb 20                	jmp    8027b8 <sfork+0x140>
			else
				new_duppage(envid, VPN(i),flag); 
  802798:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80279c:	48 c1 e8 0c          	shr    $0xc,%rax
  8027a0:	89 c1                	mov    %eax,%ecx
  8027a2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8027a5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8027a8:	89 ce                	mov    %ecx,%esi
  8027aa:	89 c7                	mov    %eax,%edi
  8027ac:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  8027b3:	00 00 00 
  8027b6:	ff d0                	callq  *%rax
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
    for (;i>=0; i -= PGSIZE) 
  8027b8:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8027bf:	00 
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
				flag=0;
			else
				new_duppage(envid, VPN(i),flag); 

		}
  8027c0:	e9 4c ff ff ff       	jmpq   802711 <sfork+0x99>

		return envid;
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8027c5:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  8027cc:	00 00 00 
  8027cf:	ff d0                	callq  *%rax
  8027d1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8027d6:	48 98                	cltq   
  8027d8:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8027df:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8027e6:	00 00 00 
  8027e9:	48 01 c2             	add    %rax,%rdx
  8027ec:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027f3:	00 00 00 
  8027f6:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8027f9:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  8027fe:	c9                   	leaveq 
  8027ff:	c3                   	retq   

0000000000802800 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802800:	55                   	push   %rbp
  802801:	48 89 e5             	mov    %rsp,%rbp
  802804:	48 83 ec 08          	sub    $0x8,%rsp
  802808:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80280c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802810:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802817:	ff ff ff 
  80281a:	48 01 d0             	add    %rdx,%rax
  80281d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802821:	c9                   	leaveq 
  802822:	c3                   	retq   

0000000000802823 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802823:	55                   	push   %rbp
  802824:	48 89 e5             	mov    %rsp,%rbp
  802827:	48 83 ec 08          	sub    $0x8,%rsp
  80282b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80282f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802833:	48 89 c7             	mov    %rax,%rdi
  802836:	48 b8 00 28 80 00 00 	movabs $0x802800,%rax
  80283d:	00 00 00 
  802840:	ff d0                	callq  *%rax
  802842:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802848:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80284c:	c9                   	leaveq 
  80284d:	c3                   	retq   

000000000080284e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80284e:	55                   	push   %rbp
  80284f:	48 89 e5             	mov    %rsp,%rbp
  802852:	48 83 ec 18          	sub    $0x18,%rsp
  802856:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80285a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802861:	eb 6b                	jmp    8028ce <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802863:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802866:	48 98                	cltq   
  802868:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80286e:	48 c1 e0 0c          	shl    $0xc,%rax
  802872:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802876:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287a:	48 c1 e8 15          	shr    $0x15,%rax
  80287e:	48 89 c2             	mov    %rax,%rdx
  802881:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802888:	01 00 00 
  80288b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80288f:	83 e0 01             	and    $0x1,%eax
  802892:	48 85 c0             	test   %rax,%rax
  802895:	74 21                	je     8028b8 <fd_alloc+0x6a>
  802897:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80289b:	48 c1 e8 0c          	shr    $0xc,%rax
  80289f:	48 89 c2             	mov    %rax,%rdx
  8028a2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028a9:	01 00 00 
  8028ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028b0:	83 e0 01             	and    $0x1,%eax
  8028b3:	48 85 c0             	test   %rax,%rax
  8028b6:	75 12                	jne    8028ca <fd_alloc+0x7c>
			*fd_store = fd;
  8028b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028c0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8028c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c8:	eb 1a                	jmp    8028e4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8028ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028ce:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8028d2:	7e 8f                	jle    802863 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8028d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8028df:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8028e4:	c9                   	leaveq 
  8028e5:	c3                   	retq   

00000000008028e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8028e6:	55                   	push   %rbp
  8028e7:	48 89 e5             	mov    %rsp,%rbp
  8028ea:	48 83 ec 20          	sub    $0x20,%rsp
  8028ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8028f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8028f9:	78 06                	js     802901 <fd_lookup+0x1b>
  8028fb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8028ff:	7e 07                	jle    802908 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802901:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802906:	eb 6c                	jmp    802974 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802908:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80290b:	48 98                	cltq   
  80290d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802913:	48 c1 e0 0c          	shl    $0xc,%rax
  802917:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80291b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80291f:	48 c1 e8 15          	shr    $0x15,%rax
  802923:	48 89 c2             	mov    %rax,%rdx
  802926:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80292d:	01 00 00 
  802930:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802934:	83 e0 01             	and    $0x1,%eax
  802937:	48 85 c0             	test   %rax,%rax
  80293a:	74 21                	je     80295d <fd_lookup+0x77>
  80293c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802940:	48 c1 e8 0c          	shr    $0xc,%rax
  802944:	48 89 c2             	mov    %rax,%rdx
  802947:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80294e:	01 00 00 
  802951:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802955:	83 e0 01             	and    $0x1,%eax
  802958:	48 85 c0             	test   %rax,%rax
  80295b:	75 07                	jne    802964 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80295d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802962:	eb 10                	jmp    802974 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802964:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802968:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80296c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80296f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802974:	c9                   	leaveq 
  802975:	c3                   	retq   

0000000000802976 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802976:	55                   	push   %rbp
  802977:	48 89 e5             	mov    %rsp,%rbp
  80297a:	48 83 ec 30          	sub    $0x30,%rsp
  80297e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802982:	89 f0                	mov    %esi,%eax
  802984:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802987:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80298b:	48 89 c7             	mov    %rax,%rdi
  80298e:	48 b8 00 28 80 00 00 	movabs $0x802800,%rax
  802995:	00 00 00 
  802998:	ff d0                	callq  *%rax
  80299a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80299e:	48 89 d6             	mov    %rdx,%rsi
  8029a1:	89 c7                	mov    %eax,%edi
  8029a3:	48 b8 e6 28 80 00 00 	movabs $0x8028e6,%rax
  8029aa:	00 00 00 
  8029ad:	ff d0                	callq  *%rax
  8029af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b6:	78 0a                	js     8029c2 <fd_close+0x4c>
	    || fd != fd2)
  8029b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029bc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8029c0:	74 12                	je     8029d4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8029c2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8029c6:	74 05                	je     8029cd <fd_close+0x57>
  8029c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cb:	eb 05                	jmp    8029d2 <fd_close+0x5c>
  8029cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d2:	eb 69                	jmp    802a3d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8029d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029d8:	8b 00                	mov    (%rax),%eax
  8029da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029de:	48 89 d6             	mov    %rdx,%rsi
  8029e1:	89 c7                	mov    %eax,%edi
  8029e3:	48 b8 3f 2a 80 00 00 	movabs $0x802a3f,%rax
  8029ea:	00 00 00 
  8029ed:	ff d0                	callq  *%rax
  8029ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f6:	78 2a                	js     802a22 <fd_close+0xac>
		if (dev->dev_close)
  8029f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029fc:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a00:	48 85 c0             	test   %rax,%rax
  802a03:	74 16                	je     802a1b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802a05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a09:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a0d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a11:	48 89 d7             	mov    %rdx,%rdi
  802a14:	ff d0                	callq  *%rax
  802a16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a19:	eb 07                	jmp    802a22 <fd_close+0xac>
		else
			r = 0;
  802a1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802a22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a26:	48 89 c6             	mov    %rax,%rsi
  802a29:	bf 00 00 00 00       	mov    $0x0,%edi
  802a2e:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  802a35:	00 00 00 
  802a38:	ff d0                	callq  *%rax
	return r;
  802a3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a3d:	c9                   	leaveq 
  802a3e:	c3                   	retq   

0000000000802a3f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802a3f:	55                   	push   %rbp
  802a40:	48 89 e5             	mov    %rsp,%rbp
  802a43:	48 83 ec 20          	sub    $0x20,%rsp
  802a47:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a4a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802a4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a55:	eb 41                	jmp    802a98 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802a57:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802a5e:	00 00 00 
  802a61:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a64:	48 63 d2             	movslq %edx,%rdx
  802a67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a6b:	8b 00                	mov    (%rax),%eax
  802a6d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a70:	75 22                	jne    802a94 <dev_lookup+0x55>
			*dev = devtab[i];
  802a72:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802a79:	00 00 00 
  802a7c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a7f:	48 63 d2             	movslq %edx,%rdx
  802a82:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802a86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a8a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a92:	eb 60                	jmp    802af4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802a94:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a98:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802a9f:	00 00 00 
  802aa2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802aa5:	48 63 d2             	movslq %edx,%rdx
  802aa8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aac:	48 85 c0             	test   %rax,%rax
  802aaf:	75 a6                	jne    802a57 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802ab1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ab8:	00 00 00 
  802abb:	48 8b 00             	mov    (%rax),%rax
  802abe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ac4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ac7:	89 c6                	mov    %eax,%esi
  802ac9:	48 bf f0 4a 80 00 00 	movabs $0x804af0,%rdi
  802ad0:	00 00 00 
  802ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad8:	48 b9 02 06 80 00 00 	movabs $0x800602,%rcx
  802adf:	00 00 00 
  802ae2:	ff d1                	callq  *%rcx
	*dev = 0;
  802ae4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802aef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802af4:	c9                   	leaveq 
  802af5:	c3                   	retq   

0000000000802af6 <close>:

int
close(int fdnum)
{
  802af6:	55                   	push   %rbp
  802af7:	48 89 e5             	mov    %rsp,%rbp
  802afa:	48 83 ec 20          	sub    $0x20,%rsp
  802afe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b01:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b05:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b08:	48 89 d6             	mov    %rdx,%rsi
  802b0b:	89 c7                	mov    %eax,%edi
  802b0d:	48 b8 e6 28 80 00 00 	movabs $0x8028e6,%rax
  802b14:	00 00 00 
  802b17:	ff d0                	callq  *%rax
  802b19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b20:	79 05                	jns    802b27 <close+0x31>
		return r;
  802b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b25:	eb 18                	jmp    802b3f <close+0x49>
	else
		return fd_close(fd, 1);
  802b27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b2b:	be 01 00 00 00       	mov    $0x1,%esi
  802b30:	48 89 c7             	mov    %rax,%rdi
  802b33:	48 b8 76 29 80 00 00 	movabs $0x802976,%rax
  802b3a:	00 00 00 
  802b3d:	ff d0                	callq  *%rax
}
  802b3f:	c9                   	leaveq 
  802b40:	c3                   	retq   

0000000000802b41 <close_all>:

void
close_all(void)
{
  802b41:	55                   	push   %rbp
  802b42:	48 89 e5             	mov    %rsp,%rbp
  802b45:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802b49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b50:	eb 15                	jmp    802b67 <close_all+0x26>
		close(i);
  802b52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b55:	89 c7                	mov    %eax,%edi
  802b57:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  802b5e:	00 00 00 
  802b61:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802b63:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b67:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b6b:	7e e5                	jle    802b52 <close_all+0x11>
		close(i);
}
  802b6d:	c9                   	leaveq 
  802b6e:	c3                   	retq   

0000000000802b6f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b6f:	55                   	push   %rbp
  802b70:	48 89 e5             	mov    %rsp,%rbp
  802b73:	48 83 ec 40          	sub    $0x40,%rsp
  802b77:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802b7a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b7d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802b81:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802b84:	48 89 d6             	mov    %rdx,%rsi
  802b87:	89 c7                	mov    %eax,%edi
  802b89:	48 b8 e6 28 80 00 00 	movabs $0x8028e6,%rax
  802b90:	00 00 00 
  802b93:	ff d0                	callq  *%rax
  802b95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9c:	79 08                	jns    802ba6 <dup+0x37>
		return r;
  802b9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba1:	e9 70 01 00 00       	jmpq   802d16 <dup+0x1a7>
	close(newfdnum);
  802ba6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ba9:	89 c7                	mov    %eax,%edi
  802bab:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  802bb2:	00 00 00 
  802bb5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802bb7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bba:	48 98                	cltq   
  802bbc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802bc2:	48 c1 e0 0c          	shl    $0xc,%rax
  802bc6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802bca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bce:	48 89 c7             	mov    %rax,%rdi
  802bd1:	48 b8 23 28 80 00 00 	movabs $0x802823,%rax
  802bd8:	00 00 00 
  802bdb:	ff d0                	callq  *%rax
  802bdd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802be1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be5:	48 89 c7             	mov    %rax,%rdi
  802be8:	48 b8 23 28 80 00 00 	movabs $0x802823,%rax
  802bef:	00 00 00 
  802bf2:	ff d0                	callq  *%rax
  802bf4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfc:	48 c1 e8 15          	shr    $0x15,%rax
  802c00:	48 89 c2             	mov    %rax,%rdx
  802c03:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802c0a:	01 00 00 
  802c0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c11:	83 e0 01             	and    $0x1,%eax
  802c14:	48 85 c0             	test   %rax,%rax
  802c17:	74 73                	je     802c8c <dup+0x11d>
  802c19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1d:	48 c1 e8 0c          	shr    $0xc,%rax
  802c21:	48 89 c2             	mov    %rax,%rdx
  802c24:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c2b:	01 00 00 
  802c2e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c32:	83 e0 01             	and    $0x1,%eax
  802c35:	48 85 c0             	test   %rax,%rax
  802c38:	74 52                	je     802c8c <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802c3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3e:	48 c1 e8 0c          	shr    $0xc,%rax
  802c42:	48 89 c2             	mov    %rax,%rdx
  802c45:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c4c:	01 00 00 
  802c4f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c53:	25 07 0e 00 00       	and    $0xe07,%eax
  802c58:	89 c1                	mov    %eax,%ecx
  802c5a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c62:	41 89 c8             	mov    %ecx,%r8d
  802c65:	48 89 d1             	mov    %rdx,%rcx
  802c68:	ba 00 00 00 00       	mov    $0x0,%edx
  802c6d:	48 89 c6             	mov    %rax,%rsi
  802c70:	bf 00 00 00 00       	mov    $0x0,%edi
  802c75:	48 b8 77 1b 80 00 00 	movabs $0x801b77,%rax
  802c7c:	00 00 00 
  802c7f:	ff d0                	callq  *%rax
  802c81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c88:	79 02                	jns    802c8c <dup+0x11d>
			goto err;
  802c8a:	eb 57                	jmp    802ce3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802c8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c90:	48 c1 e8 0c          	shr    $0xc,%rax
  802c94:	48 89 c2             	mov    %rax,%rdx
  802c97:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c9e:	01 00 00 
  802ca1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ca5:	25 07 0e 00 00       	and    $0xe07,%eax
  802caa:	89 c1                	mov    %eax,%ecx
  802cac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cb0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cb4:	41 89 c8             	mov    %ecx,%r8d
  802cb7:	48 89 d1             	mov    %rdx,%rcx
  802cba:	ba 00 00 00 00       	mov    $0x0,%edx
  802cbf:	48 89 c6             	mov    %rax,%rsi
  802cc2:	bf 00 00 00 00       	mov    $0x0,%edi
  802cc7:	48 b8 77 1b 80 00 00 	movabs $0x801b77,%rax
  802cce:	00 00 00 
  802cd1:	ff d0                	callq  *%rax
  802cd3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cda:	79 02                	jns    802cde <dup+0x16f>
		goto err;
  802cdc:	eb 05                	jmp    802ce3 <dup+0x174>

	return newfdnum;
  802cde:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ce1:	eb 33                	jmp    802d16 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802ce3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce7:	48 89 c6             	mov    %rax,%rsi
  802cea:	bf 00 00 00 00       	mov    $0x0,%edi
  802cef:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  802cf6:	00 00 00 
  802cf9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802cfb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cff:	48 89 c6             	mov    %rax,%rsi
  802d02:	bf 00 00 00 00       	mov    $0x0,%edi
  802d07:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  802d0e:	00 00 00 
  802d11:	ff d0                	callq  *%rax
	return r;
  802d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d16:	c9                   	leaveq 
  802d17:	c3                   	retq   

0000000000802d18 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802d18:	55                   	push   %rbp
  802d19:	48 89 e5             	mov    %rsp,%rbp
  802d1c:	48 83 ec 40          	sub    $0x40,%rsp
  802d20:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d23:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d27:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d2b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d2f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d32:	48 89 d6             	mov    %rdx,%rsi
  802d35:	89 c7                	mov    %eax,%edi
  802d37:	48 b8 e6 28 80 00 00 	movabs $0x8028e6,%rax
  802d3e:	00 00 00 
  802d41:	ff d0                	callq  *%rax
  802d43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d4a:	78 24                	js     802d70 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d50:	8b 00                	mov    (%rax),%eax
  802d52:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d56:	48 89 d6             	mov    %rdx,%rsi
  802d59:	89 c7                	mov    %eax,%edi
  802d5b:	48 b8 3f 2a 80 00 00 	movabs $0x802a3f,%rax
  802d62:	00 00 00 
  802d65:	ff d0                	callq  *%rax
  802d67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6e:	79 05                	jns    802d75 <read+0x5d>
		return r;
  802d70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d73:	eb 76                	jmp    802deb <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802d75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d79:	8b 40 08             	mov    0x8(%rax),%eax
  802d7c:	83 e0 03             	and    $0x3,%eax
  802d7f:	83 f8 01             	cmp    $0x1,%eax
  802d82:	75 3a                	jne    802dbe <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802d84:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d8b:	00 00 00 
  802d8e:	48 8b 00             	mov    (%rax),%rax
  802d91:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d97:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d9a:	89 c6                	mov    %eax,%esi
  802d9c:	48 bf 0f 4b 80 00 00 	movabs $0x804b0f,%rdi
  802da3:	00 00 00 
  802da6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dab:	48 b9 02 06 80 00 00 	movabs $0x800602,%rcx
  802db2:	00 00 00 
  802db5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802db7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dbc:	eb 2d                	jmp    802deb <read+0xd3>
	}
	if (!dev->dev_read)
  802dbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc2:	48 8b 40 10          	mov    0x10(%rax),%rax
  802dc6:	48 85 c0             	test   %rax,%rax
  802dc9:	75 07                	jne    802dd2 <read+0xba>
		return -E_NOT_SUPP;
  802dcb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dd0:	eb 19                	jmp    802deb <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802dd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd6:	48 8b 40 10          	mov    0x10(%rax),%rax
  802dda:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802dde:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802de2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802de6:	48 89 cf             	mov    %rcx,%rdi
  802de9:	ff d0                	callq  *%rax
}
  802deb:	c9                   	leaveq 
  802dec:	c3                   	retq   

0000000000802ded <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ded:	55                   	push   %rbp
  802dee:	48 89 e5             	mov    %rsp,%rbp
  802df1:	48 83 ec 30          	sub    $0x30,%rsp
  802df5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802df8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dfc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e07:	eb 49                	jmp    802e52 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802e09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0c:	48 98                	cltq   
  802e0e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e12:	48 29 c2             	sub    %rax,%rdx
  802e15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e18:	48 63 c8             	movslq %eax,%rcx
  802e1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e1f:	48 01 c1             	add    %rax,%rcx
  802e22:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e25:	48 89 ce             	mov    %rcx,%rsi
  802e28:	89 c7                	mov    %eax,%edi
  802e2a:	48 b8 18 2d 80 00 00 	movabs $0x802d18,%rax
  802e31:	00 00 00 
  802e34:	ff d0                	callq  *%rax
  802e36:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802e39:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e3d:	79 05                	jns    802e44 <readn+0x57>
			return m;
  802e3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e42:	eb 1c                	jmp    802e60 <readn+0x73>
		if (m == 0)
  802e44:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e48:	75 02                	jne    802e4c <readn+0x5f>
			break;
  802e4a:	eb 11                	jmp    802e5d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e4f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802e52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e55:	48 98                	cltq   
  802e57:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802e5b:	72 ac                	jb     802e09 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802e5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e60:	c9                   	leaveq 
  802e61:	c3                   	retq   

0000000000802e62 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802e62:	55                   	push   %rbp
  802e63:	48 89 e5             	mov    %rsp,%rbp
  802e66:	48 83 ec 40          	sub    $0x40,%rsp
  802e6a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e6d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e71:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e75:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e79:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e7c:	48 89 d6             	mov    %rdx,%rsi
  802e7f:	89 c7                	mov    %eax,%edi
  802e81:	48 b8 e6 28 80 00 00 	movabs $0x8028e6,%rax
  802e88:	00 00 00 
  802e8b:	ff d0                	callq  *%rax
  802e8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e94:	78 24                	js     802eba <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e9a:	8b 00                	mov    (%rax),%eax
  802e9c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ea0:	48 89 d6             	mov    %rdx,%rsi
  802ea3:	89 c7                	mov    %eax,%edi
  802ea5:	48 b8 3f 2a 80 00 00 	movabs $0x802a3f,%rax
  802eac:	00 00 00 
  802eaf:	ff d0                	callq  *%rax
  802eb1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb8:	79 05                	jns    802ebf <write+0x5d>
		return r;
  802eba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ebd:	eb 75                	jmp    802f34 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec3:	8b 40 08             	mov    0x8(%rax),%eax
  802ec6:	83 e0 03             	and    $0x3,%eax
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	75 3a                	jne    802f07 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802ecd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ed4:	00 00 00 
  802ed7:	48 8b 00             	mov    (%rax),%rax
  802eda:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ee0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ee3:	89 c6                	mov    %eax,%esi
  802ee5:	48 bf 2b 4b 80 00 00 	movabs $0x804b2b,%rdi
  802eec:	00 00 00 
  802eef:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef4:	48 b9 02 06 80 00 00 	movabs $0x800602,%rcx
  802efb:	00 00 00 
  802efe:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f05:	eb 2d                	jmp    802f34 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802f07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f0b:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f0f:	48 85 c0             	test   %rax,%rax
  802f12:	75 07                	jne    802f1b <write+0xb9>
		return -E_NOT_SUPP;
  802f14:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f19:	eb 19                	jmp    802f34 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802f1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f23:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f27:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f2b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802f2f:	48 89 cf             	mov    %rcx,%rdi
  802f32:	ff d0                	callq  *%rax
}
  802f34:	c9                   	leaveq 
  802f35:	c3                   	retq   

0000000000802f36 <seek>:

int
seek(int fdnum, off_t offset)
{
  802f36:	55                   	push   %rbp
  802f37:	48 89 e5             	mov    %rsp,%rbp
  802f3a:	48 83 ec 18          	sub    $0x18,%rsp
  802f3e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f41:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f44:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f4b:	48 89 d6             	mov    %rdx,%rsi
  802f4e:	89 c7                	mov    %eax,%edi
  802f50:	48 b8 e6 28 80 00 00 	movabs $0x8028e6,%rax
  802f57:	00 00 00 
  802f5a:	ff d0                	callq  *%rax
  802f5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f63:	79 05                	jns    802f6a <seek+0x34>
		return r;
  802f65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f68:	eb 0f                	jmp    802f79 <seek+0x43>
	fd->fd_offset = offset;
  802f6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f6e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f71:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802f74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f79:	c9                   	leaveq 
  802f7a:	c3                   	retq   

0000000000802f7b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f7b:	55                   	push   %rbp
  802f7c:	48 89 e5             	mov    %rsp,%rbp
  802f7f:	48 83 ec 30          	sub    $0x30,%rsp
  802f83:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f86:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f89:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f8d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f90:	48 89 d6             	mov    %rdx,%rsi
  802f93:	89 c7                	mov    %eax,%edi
  802f95:	48 b8 e6 28 80 00 00 	movabs $0x8028e6,%rax
  802f9c:	00 00 00 
  802f9f:	ff d0                	callq  *%rax
  802fa1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa8:	78 24                	js     802fce <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802faa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fae:	8b 00                	mov    (%rax),%eax
  802fb0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fb4:	48 89 d6             	mov    %rdx,%rsi
  802fb7:	89 c7                	mov    %eax,%edi
  802fb9:	48 b8 3f 2a 80 00 00 	movabs $0x802a3f,%rax
  802fc0:	00 00 00 
  802fc3:	ff d0                	callq  *%rax
  802fc5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fcc:	79 05                	jns    802fd3 <ftruncate+0x58>
		return r;
  802fce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd1:	eb 72                	jmp    803045 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802fd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd7:	8b 40 08             	mov    0x8(%rax),%eax
  802fda:	83 e0 03             	and    $0x3,%eax
  802fdd:	85 c0                	test   %eax,%eax
  802fdf:	75 3a                	jne    80301b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802fe1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802fe8:	00 00 00 
  802feb:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802fee:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ff4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ff7:	89 c6                	mov    %eax,%esi
  802ff9:	48 bf 48 4b 80 00 00 	movabs $0x804b48,%rdi
  803000:	00 00 00 
  803003:	b8 00 00 00 00       	mov    $0x0,%eax
  803008:	48 b9 02 06 80 00 00 	movabs $0x800602,%rcx
  80300f:	00 00 00 
  803012:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803014:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803019:	eb 2a                	jmp    803045 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80301b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301f:	48 8b 40 30          	mov    0x30(%rax),%rax
  803023:	48 85 c0             	test   %rax,%rax
  803026:	75 07                	jne    80302f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803028:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80302d:	eb 16                	jmp    803045 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80302f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803033:	48 8b 40 30          	mov    0x30(%rax),%rax
  803037:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80303b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80303e:	89 ce                	mov    %ecx,%esi
  803040:	48 89 d7             	mov    %rdx,%rdi
  803043:	ff d0                	callq  *%rax
}
  803045:	c9                   	leaveq 
  803046:	c3                   	retq   

0000000000803047 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803047:	55                   	push   %rbp
  803048:	48 89 e5             	mov    %rsp,%rbp
  80304b:	48 83 ec 30          	sub    $0x30,%rsp
  80304f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803052:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803056:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80305a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80305d:	48 89 d6             	mov    %rdx,%rsi
  803060:	89 c7                	mov    %eax,%edi
  803062:	48 b8 e6 28 80 00 00 	movabs $0x8028e6,%rax
  803069:	00 00 00 
  80306c:	ff d0                	callq  *%rax
  80306e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803071:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803075:	78 24                	js     80309b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803077:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80307b:	8b 00                	mov    (%rax),%eax
  80307d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803081:	48 89 d6             	mov    %rdx,%rsi
  803084:	89 c7                	mov    %eax,%edi
  803086:	48 b8 3f 2a 80 00 00 	movabs $0x802a3f,%rax
  80308d:	00 00 00 
  803090:	ff d0                	callq  *%rax
  803092:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803095:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803099:	79 05                	jns    8030a0 <fstat+0x59>
		return r;
  80309b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80309e:	eb 5e                	jmp    8030fe <fstat+0xb7>
	if (!dev->dev_stat)
  8030a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8030a8:	48 85 c0             	test   %rax,%rax
  8030ab:	75 07                	jne    8030b4 <fstat+0x6d>
		return -E_NOT_SUPP;
  8030ad:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030b2:	eb 4a                	jmp    8030fe <fstat+0xb7>
	stat->st_name[0] = 0;
  8030b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030b8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8030bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030bf:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8030c6:	00 00 00 
	stat->st_isdir = 0;
  8030c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030cd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8030d4:	00 00 00 
	stat->st_dev = dev;
  8030d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030df:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8030e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ea:	48 8b 40 28          	mov    0x28(%rax),%rax
  8030ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030f2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8030f6:	48 89 ce             	mov    %rcx,%rsi
  8030f9:	48 89 d7             	mov    %rdx,%rdi
  8030fc:	ff d0                	callq  *%rax
}
  8030fe:	c9                   	leaveq 
  8030ff:	c3                   	retq   

0000000000803100 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803100:	55                   	push   %rbp
  803101:	48 89 e5             	mov    %rsp,%rbp
  803104:	48 83 ec 20          	sub    $0x20,%rsp
  803108:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80310c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803114:	be 00 00 00 00       	mov    $0x0,%esi
  803119:	48 89 c7             	mov    %rax,%rdi
  80311c:	48 b8 ee 31 80 00 00 	movabs $0x8031ee,%rax
  803123:	00 00 00 
  803126:	ff d0                	callq  *%rax
  803128:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80312b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80312f:	79 05                	jns    803136 <stat+0x36>
		return fd;
  803131:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803134:	eb 2f                	jmp    803165 <stat+0x65>
	r = fstat(fd, stat);
  803136:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80313a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313d:	48 89 d6             	mov    %rdx,%rsi
  803140:	89 c7                	mov    %eax,%edi
  803142:	48 b8 47 30 80 00 00 	movabs $0x803047,%rax
  803149:	00 00 00 
  80314c:	ff d0                	callq  *%rax
  80314e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803151:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803154:	89 c7                	mov    %eax,%edi
  803156:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  80315d:	00 00 00 
  803160:	ff d0                	callq  *%rax
	return r;
  803162:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803165:	c9                   	leaveq 
  803166:	c3                   	retq   

0000000000803167 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803167:	55                   	push   %rbp
  803168:	48 89 e5             	mov    %rsp,%rbp
  80316b:	48 83 ec 10          	sub    $0x10,%rsp
  80316f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803172:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803176:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80317d:	00 00 00 
  803180:	8b 00                	mov    (%rax),%eax
  803182:	85 c0                	test   %eax,%eax
  803184:	75 1d                	jne    8031a3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803186:	bf 01 00 00 00       	mov    $0x1,%edi
  80318b:	48 b8 ad 42 80 00 00 	movabs $0x8042ad,%rax
  803192:	00 00 00 
  803195:	ff d0                	callq  *%rax
  803197:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80319e:	00 00 00 
  8031a1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8031a3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8031aa:	00 00 00 
  8031ad:	8b 00                	mov    (%rax),%eax
  8031af:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8031b2:	b9 07 00 00 00       	mov    $0x7,%ecx
  8031b7:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8031be:	00 00 00 
  8031c1:	89 c7                	mov    %eax,%edi
  8031c3:	48 b8 ae 41 80 00 00 	movabs $0x8041ae,%rax
  8031ca:	00 00 00 
  8031cd:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8031cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8031d8:	48 89 c6             	mov    %rax,%rsi
  8031db:	bf 00 00 00 00       	mov    $0x0,%edi
  8031e0:	48 b8 fb 40 80 00 00 	movabs $0x8040fb,%rax
  8031e7:	00 00 00 
  8031ea:	ff d0                	callq  *%rax
}
  8031ec:	c9                   	leaveq 
  8031ed:	c3                   	retq   

00000000008031ee <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8031ee:	55                   	push   %rbp
  8031ef:	48 89 e5             	mov    %rsp,%rbp
  8031f2:	48 83 ec 20          	sub    $0x20,%rsp
  8031f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031fa:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  8031fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803201:	48 89 c7             	mov    %rax,%rdi
  803204:	48 b8 8c 11 80 00 00 	movabs $0x80118c,%rax
  80320b:	00 00 00 
  80320e:	ff d0                	callq  *%rax
  803210:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803215:	7e 0a                	jle    803221 <open+0x33>
		return -E_BAD_PATH;
  803217:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80321c:	e9 a5 00 00 00       	jmpq   8032c6 <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  803221:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803225:	48 89 c7             	mov    %rax,%rdi
  803228:	48 b8 4e 28 80 00 00 	movabs $0x80284e,%rax
  80322f:	00 00 00 
  803232:	ff d0                	callq  *%rax
  803234:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803237:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80323b:	79 08                	jns    803245 <open+0x57>
		return ret;
  80323d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803240:	e9 81 00 00 00       	jmpq   8032c6 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  803245:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80324c:	00 00 00 
  80324f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803252:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  803258:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80325c:	48 89 c6             	mov    %rax,%rsi
  80325f:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803266:	00 00 00 
  803269:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  803270:	00 00 00 
  803273:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  803275:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803279:	48 89 c6             	mov    %rax,%rsi
  80327c:	bf 01 00 00 00       	mov    $0x1,%edi
  803281:	48 b8 67 31 80 00 00 	movabs $0x803167,%rax
  803288:	00 00 00 
  80328b:	ff d0                	callq  *%rax
  80328d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803290:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803294:	79 1d                	jns    8032b3 <open+0xc5>
	{
		fd_close(fd,0);
  803296:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80329a:	be 00 00 00 00       	mov    $0x0,%esi
  80329f:	48 89 c7             	mov    %rax,%rdi
  8032a2:	48 b8 76 29 80 00 00 	movabs $0x802976,%rax
  8032a9:	00 00 00 
  8032ac:	ff d0                	callq  *%rax
		return ret;
  8032ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b1:	eb 13                	jmp    8032c6 <open+0xd8>
	}
	return fd2num (fd);
  8032b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b7:	48 89 c7             	mov    %rax,%rdi
  8032ba:	48 b8 00 28 80 00 00 	movabs $0x802800,%rax
  8032c1:	00 00 00 
  8032c4:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  8032c6:	c9                   	leaveq 
  8032c7:	c3                   	retq   

00000000008032c8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8032c8:	55                   	push   %rbp
  8032c9:	48 89 e5             	mov    %rsp,%rbp
  8032cc:	48 83 ec 10          	sub    $0x10,%rsp
  8032d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8032d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032d8:	8b 50 0c             	mov    0xc(%rax),%edx
  8032db:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032e2:	00 00 00 
  8032e5:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8032e7:	be 00 00 00 00       	mov    $0x0,%esi
  8032ec:	bf 06 00 00 00       	mov    $0x6,%edi
  8032f1:	48 b8 67 31 80 00 00 	movabs $0x803167,%rax
  8032f8:	00 00 00 
  8032fb:	ff d0                	callq  *%rax
}
  8032fd:	c9                   	leaveq 
  8032fe:	c3                   	retq   

00000000008032ff <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8032ff:	55                   	push   %rbp
  803300:	48 89 e5             	mov    %rsp,%rbp
  803303:	48 83 ec 30          	sub    $0x30,%rsp
  803307:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80330b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80330f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  803313:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803317:	8b 50 0c             	mov    0xc(%rax),%edx
  80331a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803321:	00 00 00 
  803324:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  803326:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80332d:	00 00 00 
  803330:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803334:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  803338:	be 00 00 00 00       	mov    $0x0,%esi
  80333d:	bf 03 00 00 00       	mov    $0x3,%edi
  803342:	48 b8 67 31 80 00 00 	movabs $0x803167,%rax
  803349:	00 00 00 
  80334c:	ff d0                	callq  *%rax
  80334e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803351:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803355:	79 05                	jns    80335c <devfile_read+0x5d>
		return ret;
  803357:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80335a:	eb 26                	jmp    803382 <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  80335c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80335f:	48 63 d0             	movslq %eax,%rdx
  803362:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803366:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80336d:	00 00 00 
  803370:	48 89 c7             	mov    %rax,%rdi
  803373:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  80337a:	00 00 00 
  80337d:	ff d0                	callq  *%rax
	return ret;
  80337f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  803382:	c9                   	leaveq 
  803383:	c3                   	retq   

0000000000803384 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803384:	55                   	push   %rbp
  803385:	48 89 e5             	mov    %rsp,%rbp
  803388:	48 83 ec 30          	sub    $0x30,%rsp
  80338c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803390:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803394:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  803398:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80339c:	8b 50 0c             	mov    0xc(%rax),%edx
  80339f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033a6:	00 00 00 
  8033a9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  8033ab:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  8033b0:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8033b7:	00 
  8033b8:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8033bd:	48 89 c2             	mov    %rax,%rdx
  8033c0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033c7:	00 00 00 
  8033ca:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8033ce:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033d5:	00 00 00 
  8033d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8033dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033e0:	48 89 c6             	mov    %rax,%rsi
  8033e3:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8033ea:	00 00 00 
  8033ed:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  8033f4:	00 00 00 
  8033f7:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  8033f9:	be 00 00 00 00       	mov    $0x0,%esi
  8033fe:	bf 04 00 00 00       	mov    $0x4,%edi
  803403:	48 b8 67 31 80 00 00 	movabs $0x803167,%rax
  80340a:	00 00 00 
  80340d:	ff d0                	callq  *%rax
  80340f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803412:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803416:	79 05                	jns    80341d <devfile_write+0x99>
		return ret;
  803418:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341b:	eb 03                	jmp    803420 <devfile_write+0x9c>
	
	return ret;
  80341d:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  803420:	c9                   	leaveq 
  803421:	c3                   	retq   

0000000000803422 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803422:	55                   	push   %rbp
  803423:	48 89 e5             	mov    %rsp,%rbp
  803426:	48 83 ec 20          	sub    $0x20,%rsp
  80342a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80342e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803432:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803436:	8b 50 0c             	mov    0xc(%rax),%edx
  803439:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803440:	00 00 00 
  803443:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803445:	be 00 00 00 00       	mov    $0x0,%esi
  80344a:	bf 05 00 00 00       	mov    $0x5,%edi
  80344f:	48 b8 67 31 80 00 00 	movabs $0x803167,%rax
  803456:	00 00 00 
  803459:	ff d0                	callq  *%rax
  80345b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80345e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803462:	79 05                	jns    803469 <devfile_stat+0x47>
		return r;
  803464:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803467:	eb 56                	jmp    8034bf <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803469:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80346d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803474:	00 00 00 
  803477:	48 89 c7             	mov    %rax,%rdi
  80347a:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  803481:	00 00 00 
  803484:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803486:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80348d:	00 00 00 
  803490:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803496:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80349a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8034a0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034a7:	00 00 00 
  8034aa:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8034b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034b4:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8034ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034bf:	c9                   	leaveq 
  8034c0:	c3                   	retq   

00000000008034c1 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8034c1:	55                   	push   %rbp
  8034c2:	48 89 e5             	mov    %rsp,%rbp
  8034c5:	48 83 ec 10          	sub    $0x10,%rsp
  8034c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034cd:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8034d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034d4:	8b 50 0c             	mov    0xc(%rax),%edx
  8034d7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034de:	00 00 00 
  8034e1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8034e3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034ea:	00 00 00 
  8034ed:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8034f0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8034f3:	be 00 00 00 00       	mov    $0x0,%esi
  8034f8:	bf 02 00 00 00       	mov    $0x2,%edi
  8034fd:	48 b8 67 31 80 00 00 	movabs $0x803167,%rax
  803504:	00 00 00 
  803507:	ff d0                	callq  *%rax
}
  803509:	c9                   	leaveq 
  80350a:	c3                   	retq   

000000000080350b <remove>:

// Delete a file
int
remove(const char *path)
{
  80350b:	55                   	push   %rbp
  80350c:	48 89 e5             	mov    %rsp,%rbp
  80350f:	48 83 ec 10          	sub    $0x10,%rsp
  803513:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80351b:	48 89 c7             	mov    %rax,%rdi
  80351e:	48 b8 8c 11 80 00 00 	movabs $0x80118c,%rax
  803525:	00 00 00 
  803528:	ff d0                	callq  *%rax
  80352a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80352f:	7e 07                	jle    803538 <remove+0x2d>
		return -E_BAD_PATH;
  803531:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803536:	eb 33                	jmp    80356b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803538:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80353c:	48 89 c6             	mov    %rax,%rsi
  80353f:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803546:	00 00 00 
  803549:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  803550:	00 00 00 
  803553:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803555:	be 00 00 00 00       	mov    $0x0,%esi
  80355a:	bf 07 00 00 00       	mov    $0x7,%edi
  80355f:	48 b8 67 31 80 00 00 	movabs $0x803167,%rax
  803566:	00 00 00 
  803569:	ff d0                	callq  *%rax
}
  80356b:	c9                   	leaveq 
  80356c:	c3                   	retq   

000000000080356d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80356d:	55                   	push   %rbp
  80356e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803571:	be 00 00 00 00       	mov    $0x0,%esi
  803576:	bf 08 00 00 00       	mov    $0x8,%edi
  80357b:	48 b8 67 31 80 00 00 	movabs $0x803167,%rax
  803582:	00 00 00 
  803585:	ff d0                	callq  *%rax
}
  803587:	5d                   	pop    %rbp
  803588:	c3                   	retq   

0000000000803589 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803589:	55                   	push   %rbp
  80358a:	48 89 e5             	mov    %rsp,%rbp
  80358d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803594:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80359b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8035a2:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8035a9:	be 00 00 00 00       	mov    $0x0,%esi
  8035ae:	48 89 c7             	mov    %rax,%rdi
  8035b1:	48 b8 ee 31 80 00 00 	movabs $0x8031ee,%rax
  8035b8:	00 00 00 
  8035bb:	ff d0                	callq  *%rax
  8035bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8035c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035c4:	79 28                	jns    8035ee <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8035c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c9:	89 c6                	mov    %eax,%esi
  8035cb:	48 bf 6e 4b 80 00 00 	movabs $0x804b6e,%rdi
  8035d2:	00 00 00 
  8035d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035da:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  8035e1:	00 00 00 
  8035e4:	ff d2                	callq  *%rdx
		return fd_src;
  8035e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e9:	e9 74 01 00 00       	jmpq   803762 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8035ee:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8035f5:	be 01 01 00 00       	mov    $0x101,%esi
  8035fa:	48 89 c7             	mov    %rax,%rdi
  8035fd:	48 b8 ee 31 80 00 00 	movabs $0x8031ee,%rax
  803604:	00 00 00 
  803607:	ff d0                	callq  *%rax
  803609:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80360c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803610:	79 39                	jns    80364b <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803612:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803615:	89 c6                	mov    %eax,%esi
  803617:	48 bf 84 4b 80 00 00 	movabs $0x804b84,%rdi
  80361e:	00 00 00 
  803621:	b8 00 00 00 00       	mov    $0x0,%eax
  803626:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  80362d:	00 00 00 
  803630:	ff d2                	callq  *%rdx
		close(fd_src);
  803632:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803635:	89 c7                	mov    %eax,%edi
  803637:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  80363e:	00 00 00 
  803641:	ff d0                	callq  *%rax
		return fd_dest;
  803643:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803646:	e9 17 01 00 00       	jmpq   803762 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80364b:	eb 74                	jmp    8036c1 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80364d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803650:	48 63 d0             	movslq %eax,%rdx
  803653:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80365a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80365d:	48 89 ce             	mov    %rcx,%rsi
  803660:	89 c7                	mov    %eax,%edi
  803662:	48 b8 62 2e 80 00 00 	movabs $0x802e62,%rax
  803669:	00 00 00 
  80366c:	ff d0                	callq  *%rax
  80366e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803671:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803675:	79 4a                	jns    8036c1 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803677:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80367a:	89 c6                	mov    %eax,%esi
  80367c:	48 bf 9e 4b 80 00 00 	movabs $0x804b9e,%rdi
  803683:	00 00 00 
  803686:	b8 00 00 00 00       	mov    $0x0,%eax
  80368b:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  803692:	00 00 00 
  803695:	ff d2                	callq  *%rdx
			close(fd_src);
  803697:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80369a:	89 c7                	mov    %eax,%edi
  80369c:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  8036a3:	00 00 00 
  8036a6:	ff d0                	callq  *%rax
			close(fd_dest);
  8036a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036ab:	89 c7                	mov    %eax,%edi
  8036ad:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  8036b4:	00 00 00 
  8036b7:	ff d0                	callq  *%rax
			return write_size;
  8036b9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8036bc:	e9 a1 00 00 00       	jmpq   803762 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8036c1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8036c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036cb:	ba 00 02 00 00       	mov    $0x200,%edx
  8036d0:	48 89 ce             	mov    %rcx,%rsi
  8036d3:	89 c7                	mov    %eax,%edi
  8036d5:	48 b8 18 2d 80 00 00 	movabs $0x802d18,%rax
  8036dc:	00 00 00 
  8036df:	ff d0                	callq  *%rax
  8036e1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8036e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8036e8:	0f 8f 5f ff ff ff    	jg     80364d <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8036ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8036f2:	79 47                	jns    80373b <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8036f4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036f7:	89 c6                	mov    %eax,%esi
  8036f9:	48 bf b1 4b 80 00 00 	movabs $0x804bb1,%rdi
  803700:	00 00 00 
  803703:	b8 00 00 00 00       	mov    $0x0,%eax
  803708:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  80370f:	00 00 00 
  803712:	ff d2                	callq  *%rdx
		close(fd_src);
  803714:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803717:	89 c7                	mov    %eax,%edi
  803719:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  803720:	00 00 00 
  803723:	ff d0                	callq  *%rax
		close(fd_dest);
  803725:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803728:	89 c7                	mov    %eax,%edi
  80372a:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  803731:	00 00 00 
  803734:	ff d0                	callq  *%rax
		return read_size;
  803736:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803739:	eb 27                	jmp    803762 <copy+0x1d9>
	}
	close(fd_src);
  80373b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80373e:	89 c7                	mov    %eax,%edi
  803740:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  803747:	00 00 00 
  80374a:	ff d0                	callq  *%rax
	close(fd_dest);
  80374c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80374f:	89 c7                	mov    %eax,%edi
  803751:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  803758:	00 00 00 
  80375b:	ff d0                	callq  *%rax
	return 0;
  80375d:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803762:	c9                   	leaveq 
  803763:	c3                   	retq   

0000000000803764 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803764:	55                   	push   %rbp
  803765:	48 89 e5             	mov    %rsp,%rbp
  803768:	53                   	push   %rbx
  803769:	48 83 ec 38          	sub    $0x38,%rsp
  80376d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803771:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803775:	48 89 c7             	mov    %rax,%rdi
  803778:	48 b8 4e 28 80 00 00 	movabs $0x80284e,%rax
  80377f:	00 00 00 
  803782:	ff d0                	callq  *%rax
  803784:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803787:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80378b:	0f 88 bf 01 00 00    	js     803950 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803791:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803795:	ba 07 04 00 00       	mov    $0x407,%edx
  80379a:	48 89 c6             	mov    %rax,%rsi
  80379d:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a2:	48 b8 27 1b 80 00 00 	movabs $0x801b27,%rax
  8037a9:	00 00 00 
  8037ac:	ff d0                	callq  *%rax
  8037ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037b5:	0f 88 95 01 00 00    	js     803950 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8037bb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8037bf:	48 89 c7             	mov    %rax,%rdi
  8037c2:	48 b8 4e 28 80 00 00 	movabs $0x80284e,%rax
  8037c9:	00 00 00 
  8037cc:	ff d0                	callq  *%rax
  8037ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037d5:	0f 88 5d 01 00 00    	js     803938 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037df:	ba 07 04 00 00       	mov    $0x407,%edx
  8037e4:	48 89 c6             	mov    %rax,%rsi
  8037e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ec:	48 b8 27 1b 80 00 00 	movabs $0x801b27,%rax
  8037f3:	00 00 00 
  8037f6:	ff d0                	callq  *%rax
  8037f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037ff:	0f 88 33 01 00 00    	js     803938 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803805:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803809:	48 89 c7             	mov    %rax,%rdi
  80380c:	48 b8 23 28 80 00 00 	movabs $0x802823,%rax
  803813:	00 00 00 
  803816:	ff d0                	callq  *%rax
  803818:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80381c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803820:	ba 07 04 00 00       	mov    $0x407,%edx
  803825:	48 89 c6             	mov    %rax,%rsi
  803828:	bf 00 00 00 00       	mov    $0x0,%edi
  80382d:	48 b8 27 1b 80 00 00 	movabs $0x801b27,%rax
  803834:	00 00 00 
  803837:	ff d0                	callq  *%rax
  803839:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80383c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803840:	79 05                	jns    803847 <pipe+0xe3>
		goto err2;
  803842:	e9 d9 00 00 00       	jmpq   803920 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803847:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80384b:	48 89 c7             	mov    %rax,%rdi
  80384e:	48 b8 23 28 80 00 00 	movabs $0x802823,%rax
  803855:	00 00 00 
  803858:	ff d0                	callq  *%rax
  80385a:	48 89 c2             	mov    %rax,%rdx
  80385d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803861:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803867:	48 89 d1             	mov    %rdx,%rcx
  80386a:	ba 00 00 00 00       	mov    $0x0,%edx
  80386f:	48 89 c6             	mov    %rax,%rsi
  803872:	bf 00 00 00 00       	mov    $0x0,%edi
  803877:	48 b8 77 1b 80 00 00 	movabs $0x801b77,%rax
  80387e:	00 00 00 
  803881:	ff d0                	callq  *%rax
  803883:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803886:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80388a:	79 1b                	jns    8038a7 <pipe+0x143>
		goto err3;
  80388c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80388d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803891:	48 89 c6             	mov    %rax,%rsi
  803894:	bf 00 00 00 00       	mov    $0x0,%edi
  803899:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  8038a0:	00 00 00 
  8038a3:	ff d0                	callq  *%rax
  8038a5:	eb 79                	jmp    803920 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8038a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ab:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8038b2:	00 00 00 
  8038b5:	8b 12                	mov    (%rdx),%edx
  8038b7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8038b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8038c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038c8:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8038cf:	00 00 00 
  8038d2:	8b 12                	mov    (%rdx),%edx
  8038d4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8038d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038da:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8038e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038e5:	48 89 c7             	mov    %rax,%rdi
  8038e8:	48 b8 00 28 80 00 00 	movabs $0x802800,%rax
  8038ef:	00 00 00 
  8038f2:	ff d0                	callq  *%rax
  8038f4:	89 c2                	mov    %eax,%edx
  8038f6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038fa:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8038fc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803900:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803904:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803908:	48 89 c7             	mov    %rax,%rdi
  80390b:	48 b8 00 28 80 00 00 	movabs $0x802800,%rax
  803912:	00 00 00 
  803915:	ff d0                	callq  *%rax
  803917:	89 03                	mov    %eax,(%rbx)
	return 0;
  803919:	b8 00 00 00 00       	mov    $0x0,%eax
  80391e:	eb 33                	jmp    803953 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803920:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803924:	48 89 c6             	mov    %rax,%rsi
  803927:	bf 00 00 00 00       	mov    $0x0,%edi
  80392c:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803933:	00 00 00 
  803936:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803938:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80393c:	48 89 c6             	mov    %rax,%rsi
  80393f:	bf 00 00 00 00       	mov    $0x0,%edi
  803944:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  80394b:	00 00 00 
  80394e:	ff d0                	callq  *%rax
err:
	return r;
  803950:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803953:	48 83 c4 38          	add    $0x38,%rsp
  803957:	5b                   	pop    %rbx
  803958:	5d                   	pop    %rbp
  803959:	c3                   	retq   

000000000080395a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80395a:	55                   	push   %rbp
  80395b:	48 89 e5             	mov    %rsp,%rbp
  80395e:	53                   	push   %rbx
  80395f:	48 83 ec 28          	sub    $0x28,%rsp
  803963:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803967:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80396b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803972:	00 00 00 
  803975:	48 8b 00             	mov    (%rax),%rax
  803978:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80397e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803981:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803985:	48 89 c7             	mov    %rax,%rdi
  803988:	48 b8 1f 43 80 00 00 	movabs $0x80431f,%rax
  80398f:	00 00 00 
  803992:	ff d0                	callq  *%rax
  803994:	89 c3                	mov    %eax,%ebx
  803996:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80399a:	48 89 c7             	mov    %rax,%rdi
  80399d:	48 b8 1f 43 80 00 00 	movabs $0x80431f,%rax
  8039a4:	00 00 00 
  8039a7:	ff d0                	callq  *%rax
  8039a9:	39 c3                	cmp    %eax,%ebx
  8039ab:	0f 94 c0             	sete   %al
  8039ae:	0f b6 c0             	movzbl %al,%eax
  8039b1:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8039b4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039bb:	00 00 00 
  8039be:	48 8b 00             	mov    (%rax),%rax
  8039c1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8039c7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8039ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039cd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039d0:	75 05                	jne    8039d7 <_pipeisclosed+0x7d>
			return ret;
  8039d2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8039d5:	eb 4f                	jmp    803a26 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8039d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039da:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039dd:	74 42                	je     803a21 <_pipeisclosed+0xc7>
  8039df:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8039e3:	75 3c                	jne    803a21 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8039e5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039ec:	00 00 00 
  8039ef:	48 8b 00             	mov    (%rax),%rax
  8039f2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8039f8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8039fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039fe:	89 c6                	mov    %eax,%esi
  803a00:	48 bf d1 4b 80 00 00 	movabs $0x804bd1,%rdi
  803a07:	00 00 00 
  803a0a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a0f:	49 b8 02 06 80 00 00 	movabs $0x800602,%r8
  803a16:	00 00 00 
  803a19:	41 ff d0             	callq  *%r8
	}
  803a1c:	e9 4a ff ff ff       	jmpq   80396b <_pipeisclosed+0x11>
  803a21:	e9 45 ff ff ff       	jmpq   80396b <_pipeisclosed+0x11>
}
  803a26:	48 83 c4 28          	add    $0x28,%rsp
  803a2a:	5b                   	pop    %rbx
  803a2b:	5d                   	pop    %rbp
  803a2c:	c3                   	retq   

0000000000803a2d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803a2d:	55                   	push   %rbp
  803a2e:	48 89 e5             	mov    %rsp,%rbp
  803a31:	48 83 ec 30          	sub    $0x30,%rsp
  803a35:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a38:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803a3c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a3f:	48 89 d6             	mov    %rdx,%rsi
  803a42:	89 c7                	mov    %eax,%edi
  803a44:	48 b8 e6 28 80 00 00 	movabs $0x8028e6,%rax
  803a4b:	00 00 00 
  803a4e:	ff d0                	callq  *%rax
  803a50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a57:	79 05                	jns    803a5e <pipeisclosed+0x31>
		return r;
  803a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5c:	eb 31                	jmp    803a8f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a62:	48 89 c7             	mov    %rax,%rdi
  803a65:	48 b8 23 28 80 00 00 	movabs $0x802823,%rax
  803a6c:	00 00 00 
  803a6f:	ff d0                	callq  *%rax
  803a71:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803a75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a79:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a7d:	48 89 d6             	mov    %rdx,%rsi
  803a80:	48 89 c7             	mov    %rax,%rdi
  803a83:	48 b8 5a 39 80 00 00 	movabs $0x80395a,%rax
  803a8a:	00 00 00 
  803a8d:	ff d0                	callq  *%rax
}
  803a8f:	c9                   	leaveq 
  803a90:	c3                   	retq   

0000000000803a91 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a91:	55                   	push   %rbp
  803a92:	48 89 e5             	mov    %rsp,%rbp
  803a95:	48 83 ec 40          	sub    $0x40,%rsp
  803a99:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a9d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803aa1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803aa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa9:	48 89 c7             	mov    %rax,%rdi
  803aac:	48 b8 23 28 80 00 00 	movabs $0x802823,%rax
  803ab3:	00 00 00 
  803ab6:	ff d0                	callq  *%rax
  803ab8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803abc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ac0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ac4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803acb:	00 
  803acc:	e9 92 00 00 00       	jmpq   803b63 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803ad1:	eb 41                	jmp    803b14 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803ad3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803ad8:	74 09                	je     803ae3 <devpipe_read+0x52>
				return i;
  803ada:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ade:	e9 92 00 00 00       	jmpq   803b75 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ae3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ae7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aeb:	48 89 d6             	mov    %rdx,%rsi
  803aee:	48 89 c7             	mov    %rax,%rdi
  803af1:	48 b8 5a 39 80 00 00 	movabs $0x80395a,%rax
  803af8:	00 00 00 
  803afb:	ff d0                	callq  *%rax
  803afd:	85 c0                	test   %eax,%eax
  803aff:	74 07                	je     803b08 <devpipe_read+0x77>
				return 0;
  803b01:	b8 00 00 00 00       	mov    $0x0,%eax
  803b06:	eb 6d                	jmp    803b75 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803b08:	48 b8 e9 1a 80 00 00 	movabs $0x801ae9,%rax
  803b0f:	00 00 00 
  803b12:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803b14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b18:	8b 10                	mov    (%rax),%edx
  803b1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b1e:	8b 40 04             	mov    0x4(%rax),%eax
  803b21:	39 c2                	cmp    %eax,%edx
  803b23:	74 ae                	je     803ad3 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803b25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b2d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803b31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b35:	8b 00                	mov    (%rax),%eax
  803b37:	99                   	cltd   
  803b38:	c1 ea 1b             	shr    $0x1b,%edx
  803b3b:	01 d0                	add    %edx,%eax
  803b3d:	83 e0 1f             	and    $0x1f,%eax
  803b40:	29 d0                	sub    %edx,%eax
  803b42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b46:	48 98                	cltq   
  803b48:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803b4d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803b4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b53:	8b 00                	mov    (%rax),%eax
  803b55:	8d 50 01             	lea    0x1(%rax),%edx
  803b58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b5c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b5e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b67:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b6b:	0f 82 60 ff ff ff    	jb     803ad1 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803b71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b75:	c9                   	leaveq 
  803b76:	c3                   	retq   

0000000000803b77 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b77:	55                   	push   %rbp
  803b78:	48 89 e5             	mov    %rsp,%rbp
  803b7b:	48 83 ec 40          	sub    $0x40,%rsp
  803b7f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b83:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b87:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803b8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b8f:	48 89 c7             	mov    %rax,%rdi
  803b92:	48 b8 23 28 80 00 00 	movabs $0x802823,%rax
  803b99:	00 00 00 
  803b9c:	ff d0                	callq  *%rax
  803b9e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ba2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ba6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803baa:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803bb1:	00 
  803bb2:	e9 8e 00 00 00       	jmpq   803c45 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803bb7:	eb 31                	jmp    803bea <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803bb9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bbd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bc1:	48 89 d6             	mov    %rdx,%rsi
  803bc4:	48 89 c7             	mov    %rax,%rdi
  803bc7:	48 b8 5a 39 80 00 00 	movabs $0x80395a,%rax
  803bce:	00 00 00 
  803bd1:	ff d0                	callq  *%rax
  803bd3:	85 c0                	test   %eax,%eax
  803bd5:	74 07                	je     803bde <devpipe_write+0x67>
				return 0;
  803bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  803bdc:	eb 79                	jmp    803c57 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803bde:	48 b8 e9 1a 80 00 00 	movabs $0x801ae9,%rax
  803be5:	00 00 00 
  803be8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803bea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bee:	8b 40 04             	mov    0x4(%rax),%eax
  803bf1:	48 63 d0             	movslq %eax,%rdx
  803bf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf8:	8b 00                	mov    (%rax),%eax
  803bfa:	48 98                	cltq   
  803bfc:	48 83 c0 20          	add    $0x20,%rax
  803c00:	48 39 c2             	cmp    %rax,%rdx
  803c03:	73 b4                	jae    803bb9 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803c05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c09:	8b 40 04             	mov    0x4(%rax),%eax
  803c0c:	99                   	cltd   
  803c0d:	c1 ea 1b             	shr    $0x1b,%edx
  803c10:	01 d0                	add    %edx,%eax
  803c12:	83 e0 1f             	and    $0x1f,%eax
  803c15:	29 d0                	sub    %edx,%eax
  803c17:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c1b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803c1f:	48 01 ca             	add    %rcx,%rdx
  803c22:	0f b6 0a             	movzbl (%rdx),%ecx
  803c25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c29:	48 98                	cltq   
  803c2b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803c2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c33:	8b 40 04             	mov    0x4(%rax),%eax
  803c36:	8d 50 01             	lea    0x1(%rax),%edx
  803c39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c3d:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c40:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c49:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c4d:	0f 82 64 ff ff ff    	jb     803bb7 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803c53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c57:	c9                   	leaveq 
  803c58:	c3                   	retq   

0000000000803c59 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803c59:	55                   	push   %rbp
  803c5a:	48 89 e5             	mov    %rsp,%rbp
  803c5d:	48 83 ec 20          	sub    $0x20,%rsp
  803c61:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c65:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803c69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c6d:	48 89 c7             	mov    %rax,%rdi
  803c70:	48 b8 23 28 80 00 00 	movabs $0x802823,%rax
  803c77:	00 00 00 
  803c7a:	ff d0                	callq  *%rax
  803c7c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803c80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c84:	48 be e4 4b 80 00 00 	movabs $0x804be4,%rsi
  803c8b:	00 00 00 
  803c8e:	48 89 c7             	mov    %rax,%rdi
  803c91:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  803c98:	00 00 00 
  803c9b:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803c9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ca1:	8b 50 04             	mov    0x4(%rax),%edx
  803ca4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ca8:	8b 00                	mov    (%rax),%eax
  803caa:	29 c2                	sub    %eax,%edx
  803cac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cb0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803cb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cba:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803cc1:	00 00 00 
	stat->st_dev = &devpipe;
  803cc4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cc8:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803ccf:	00 00 00 
  803cd2:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803cd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cde:	c9                   	leaveq 
  803cdf:	c3                   	retq   

0000000000803ce0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803ce0:	55                   	push   %rbp
  803ce1:	48 89 e5             	mov    %rsp,%rbp
  803ce4:	48 83 ec 10          	sub    $0x10,%rsp
  803ce8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803cec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf0:	48 89 c6             	mov    %rax,%rsi
  803cf3:	bf 00 00 00 00       	mov    $0x0,%edi
  803cf8:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803cff:	00 00 00 
  803d02:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803d04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d08:	48 89 c7             	mov    %rax,%rdi
  803d0b:	48 b8 23 28 80 00 00 	movabs $0x802823,%rax
  803d12:	00 00 00 
  803d15:	ff d0                	callq  *%rax
  803d17:	48 89 c6             	mov    %rax,%rsi
  803d1a:	bf 00 00 00 00       	mov    $0x0,%edi
  803d1f:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803d26:	00 00 00 
  803d29:	ff d0                	callq  *%rax
}
  803d2b:	c9                   	leaveq 
  803d2c:	c3                   	retq   

0000000000803d2d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803d2d:	55                   	push   %rbp
  803d2e:	48 89 e5             	mov    %rsp,%rbp
  803d31:	48 83 ec 20          	sub    $0x20,%rsp
  803d35:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803d38:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d3b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803d3e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803d42:	be 01 00 00 00       	mov    $0x1,%esi
  803d47:	48 89 c7             	mov    %rax,%rdi
  803d4a:	48 b8 df 19 80 00 00 	movabs $0x8019df,%rax
  803d51:	00 00 00 
  803d54:	ff d0                	callq  *%rax
}
  803d56:	c9                   	leaveq 
  803d57:	c3                   	retq   

0000000000803d58 <getchar>:

int
getchar(void)
{
  803d58:	55                   	push   %rbp
  803d59:	48 89 e5             	mov    %rsp,%rbp
  803d5c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803d60:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803d64:	ba 01 00 00 00       	mov    $0x1,%edx
  803d69:	48 89 c6             	mov    %rax,%rsi
  803d6c:	bf 00 00 00 00       	mov    $0x0,%edi
  803d71:	48 b8 18 2d 80 00 00 	movabs $0x802d18,%rax
  803d78:	00 00 00 
  803d7b:	ff d0                	callq  *%rax
  803d7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803d80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d84:	79 05                	jns    803d8b <getchar+0x33>
		return r;
  803d86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d89:	eb 14                	jmp    803d9f <getchar+0x47>
	if (r < 1)
  803d8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d8f:	7f 07                	jg     803d98 <getchar+0x40>
		return -E_EOF;
  803d91:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803d96:	eb 07                	jmp    803d9f <getchar+0x47>
	return c;
  803d98:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803d9c:	0f b6 c0             	movzbl %al,%eax
}
  803d9f:	c9                   	leaveq 
  803da0:	c3                   	retq   

0000000000803da1 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803da1:	55                   	push   %rbp
  803da2:	48 89 e5             	mov    %rsp,%rbp
  803da5:	48 83 ec 20          	sub    $0x20,%rsp
  803da9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803dac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803db0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803db3:	48 89 d6             	mov    %rdx,%rsi
  803db6:	89 c7                	mov    %eax,%edi
  803db8:	48 b8 e6 28 80 00 00 	movabs $0x8028e6,%rax
  803dbf:	00 00 00 
  803dc2:	ff d0                	callq  *%rax
  803dc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dcb:	79 05                	jns    803dd2 <iscons+0x31>
		return r;
  803dcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd0:	eb 1a                	jmp    803dec <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803dd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd6:	8b 10                	mov    (%rax),%edx
  803dd8:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803ddf:	00 00 00 
  803de2:	8b 00                	mov    (%rax),%eax
  803de4:	39 c2                	cmp    %eax,%edx
  803de6:	0f 94 c0             	sete   %al
  803de9:	0f b6 c0             	movzbl %al,%eax
}
  803dec:	c9                   	leaveq 
  803ded:	c3                   	retq   

0000000000803dee <opencons>:

int
opencons(void)
{
  803dee:	55                   	push   %rbp
  803def:	48 89 e5             	mov    %rsp,%rbp
  803df2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803df6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803dfa:	48 89 c7             	mov    %rax,%rdi
  803dfd:	48 b8 4e 28 80 00 00 	movabs $0x80284e,%rax
  803e04:	00 00 00 
  803e07:	ff d0                	callq  *%rax
  803e09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e10:	79 05                	jns    803e17 <opencons+0x29>
		return r;
  803e12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e15:	eb 5b                	jmp    803e72 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803e17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e1b:	ba 07 04 00 00       	mov    $0x407,%edx
  803e20:	48 89 c6             	mov    %rax,%rsi
  803e23:	bf 00 00 00 00       	mov    $0x0,%edi
  803e28:	48 b8 27 1b 80 00 00 	movabs $0x801b27,%rax
  803e2f:	00 00 00 
  803e32:	ff d0                	callq  *%rax
  803e34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e3b:	79 05                	jns    803e42 <opencons+0x54>
		return r;
  803e3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e40:	eb 30                	jmp    803e72 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803e42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e46:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803e4d:	00 00 00 
  803e50:	8b 12                	mov    (%rdx),%edx
  803e52:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803e54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e58:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e63:	48 89 c7             	mov    %rax,%rdi
  803e66:	48 b8 00 28 80 00 00 	movabs $0x802800,%rax
  803e6d:	00 00 00 
  803e70:	ff d0                	callq  *%rax
}
  803e72:	c9                   	leaveq 
  803e73:	c3                   	retq   

0000000000803e74 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e74:	55                   	push   %rbp
  803e75:	48 89 e5             	mov    %rsp,%rbp
  803e78:	48 83 ec 30          	sub    $0x30,%rsp
  803e7c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e80:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e84:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803e88:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e8d:	75 07                	jne    803e96 <devcons_read+0x22>
		return 0;
  803e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  803e94:	eb 4b                	jmp    803ee1 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803e96:	eb 0c                	jmp    803ea4 <devcons_read+0x30>
		sys_yield();
  803e98:	48 b8 e9 1a 80 00 00 	movabs $0x801ae9,%rax
  803e9f:	00 00 00 
  803ea2:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803ea4:	48 b8 29 1a 80 00 00 	movabs $0x801a29,%rax
  803eab:	00 00 00 
  803eae:	ff d0                	callq  *%rax
  803eb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eb7:	74 df                	je     803e98 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803eb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ebd:	79 05                	jns    803ec4 <devcons_read+0x50>
		return c;
  803ebf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec2:	eb 1d                	jmp    803ee1 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803ec4:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803ec8:	75 07                	jne    803ed1 <devcons_read+0x5d>
		return 0;
  803eca:	b8 00 00 00 00       	mov    $0x0,%eax
  803ecf:	eb 10                	jmp    803ee1 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803ed1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed4:	89 c2                	mov    %eax,%edx
  803ed6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eda:	88 10                	mov    %dl,(%rax)
	return 1;
  803edc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803ee1:	c9                   	leaveq 
  803ee2:	c3                   	retq   

0000000000803ee3 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ee3:	55                   	push   %rbp
  803ee4:	48 89 e5             	mov    %rsp,%rbp
  803ee7:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803eee:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803ef5:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803efc:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f0a:	eb 76                	jmp    803f82 <devcons_write+0x9f>
		m = n - tot;
  803f0c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803f13:	89 c2                	mov    %eax,%edx
  803f15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f18:	29 c2                	sub    %eax,%edx
  803f1a:	89 d0                	mov    %edx,%eax
  803f1c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803f1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f22:	83 f8 7f             	cmp    $0x7f,%eax
  803f25:	76 07                	jbe    803f2e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803f27:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803f2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f31:	48 63 d0             	movslq %eax,%rdx
  803f34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f37:	48 63 c8             	movslq %eax,%rcx
  803f3a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803f41:	48 01 c1             	add    %rax,%rcx
  803f44:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f4b:	48 89 ce             	mov    %rcx,%rsi
  803f4e:	48 89 c7             	mov    %rax,%rdi
  803f51:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  803f58:	00 00 00 
  803f5b:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803f5d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f60:	48 63 d0             	movslq %eax,%rdx
  803f63:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f6a:	48 89 d6             	mov    %rdx,%rsi
  803f6d:	48 89 c7             	mov    %rax,%rdi
  803f70:	48 b8 df 19 80 00 00 	movabs $0x8019df,%rax
  803f77:	00 00 00 
  803f7a:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f7f:	01 45 fc             	add    %eax,-0x4(%rbp)
  803f82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f85:	48 98                	cltq   
  803f87:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803f8e:	0f 82 78 ff ff ff    	jb     803f0c <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803f94:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f97:	c9                   	leaveq 
  803f98:	c3                   	retq   

0000000000803f99 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803f99:	55                   	push   %rbp
  803f9a:	48 89 e5             	mov    %rsp,%rbp
  803f9d:	48 83 ec 08          	sub    $0x8,%rsp
  803fa1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803fa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803faa:	c9                   	leaveq 
  803fab:	c3                   	retq   

0000000000803fac <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803fac:	55                   	push   %rbp
  803fad:	48 89 e5             	mov    %rsp,%rbp
  803fb0:	48 83 ec 10          	sub    $0x10,%rsp
  803fb4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803fb8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc0:	48 be f0 4b 80 00 00 	movabs $0x804bf0,%rsi
  803fc7:	00 00 00 
  803fca:	48 89 c7             	mov    %rax,%rdi
  803fcd:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  803fd4:	00 00 00 
  803fd7:	ff d0                	callq  *%rax
	return 0;
  803fd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fde:	c9                   	leaveq 
  803fdf:	c3                   	retq   

0000000000803fe0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803fe0:	55                   	push   %rbp
  803fe1:	48 89 e5             	mov    %rsp,%rbp
  803fe4:	48 83 ec 20          	sub    $0x20,%rsp
  803fe8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803fec:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803ff3:	00 00 00 
  803ff6:	48 8b 00             	mov    (%rax),%rax
  803ff9:	48 85 c0             	test   %rax,%rax
  803ffc:	75 6f                	jne    80406d <set_pgfault_handler+0x8d>
		// First time through!
		// LAB 4: Your code here.

		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  803ffe:	ba 07 00 00 00       	mov    $0x7,%edx
  804003:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804008:	bf 00 00 00 00       	mov    $0x0,%edi
  80400d:	48 b8 27 1b 80 00 00 	movabs $0x801b27,%rax
  804014:	00 00 00 
  804017:	ff d0                	callq  *%rax
  804019:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80401c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804020:	79 30                	jns    804052 <set_pgfault_handler+0x72>
            panic("set_pgfault_handler: %d\n", r);
  804022:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804025:	89 c1                	mov    %eax,%ecx
  804027:	48 ba f7 4b 80 00 00 	movabs $0x804bf7,%rdx
  80402e:	00 00 00 
  804031:	be 22 00 00 00       	mov    $0x22,%esi
  804036:	48 bf 10 4c 80 00 00 	movabs $0x804c10,%rdi
  80403d:	00 00 00 
  804040:	b8 00 00 00 00       	mov    $0x0,%eax
  804045:	49 b8 c9 03 80 00 00 	movabs $0x8003c9,%r8
  80404c:	00 00 00 
  80404f:	41 ff d0             	callq  *%r8
        sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804052:	48 be 80 40 80 00 00 	movabs $0x804080,%rsi
  804059:	00 00 00 
  80405c:	bf 00 00 00 00       	mov    $0x0,%edi
  804061:	48 b8 b1 1c 80 00 00 	movabs $0x801cb1,%rax
  804068:	00 00 00 
  80406b:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80406d:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804074:	00 00 00 
  804077:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80407b:	48 89 10             	mov    %rdx,(%rax)
}
  80407e:	c9                   	leaveq 
  80407f:	c3                   	retq   

0000000000804080 <_pgfault_upcall>:
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF


	movq %rsp, %rdi;	
  804080:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  804083:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80408a:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  80408b:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  804092:	00 
	pushq %rbx;
  804093:	53                   	push   %rbx
	movq %rsp, %rbx;	
  804094:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  804097:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  80409a:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  8040a1:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  8040a2:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  8040a6:	4c 8b 3c 24          	mov    (%rsp),%r15
  8040aa:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8040af:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8040b4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8040b9:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8040be:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8040c3:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8040c8:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8040cd:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8040d2:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8040d7:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8040dc:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8040e1:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8040e6:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8040eb:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8040f0:	48 83 c4 78          	add    $0x78,%rsp
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.


	add $8, %rsp; //Jump rip field  
  8040f4:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8040f8:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  8040f9:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  8040fa:	c3                   	retq   

00000000008040fb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8040fb:	55                   	push   %rbp
  8040fc:	48 89 e5             	mov    %rsp,%rbp
  8040ff:	48 83 ec 30          	sub    $0x30,%rsp
  804103:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804107:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80410b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  80410f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804114:	75 08                	jne    80411e <ipc_recv+0x23>
  804116:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  80411d:	ff 
	int res=sys_ipc_recv(pg);
  80411e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804122:	48 89 c7             	mov    %rax,%rdi
  804125:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  80412c:	00 00 00 
  80412f:	ff d0                	callq  *%rax
  804131:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  804134:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804139:	74 26                	je     804161 <ipc_recv+0x66>
  80413b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80413f:	75 15                	jne    804156 <ipc_recv+0x5b>
  804141:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804148:	00 00 00 
  80414b:	48 8b 00             	mov    (%rax),%rax
  80414e:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  804154:	eb 05                	jmp    80415b <ipc_recv+0x60>
  804156:	b8 00 00 00 00       	mov    $0x0,%eax
  80415b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80415f:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  804161:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804166:	74 26                	je     80418e <ipc_recv+0x93>
  804168:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80416c:	75 15                	jne    804183 <ipc_recv+0x88>
  80416e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804175:	00 00 00 
  804178:	48 8b 00             	mov    (%rax),%rax
  80417b:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  804181:	eb 05                	jmp    804188 <ipc_recv+0x8d>
  804183:	b8 00 00 00 00       	mov    $0x0,%eax
  804188:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80418c:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  80418e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804192:	75 15                	jne    8041a9 <ipc_recv+0xae>
  804194:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80419b:	00 00 00 
  80419e:	48 8b 00             	mov    (%rax),%rax
  8041a1:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  8041a7:	eb 03                	jmp    8041ac <ipc_recv+0xb1>
  8041a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  8041ac:	c9                   	leaveq 
  8041ad:	c3                   	retq   

00000000008041ae <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8041ae:	55                   	push   %rbp
  8041af:	48 89 e5             	mov    %rsp,%rbp
  8041b2:	48 83 ec 30          	sub    $0x30,%rsp
  8041b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8041b9:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8041bc:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8041c0:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  8041c3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8041c8:	75 0a                	jne    8041d4 <ipc_send+0x26>
  8041ca:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8041d1:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8041d2:	eb 3e                	jmp    804212 <ipc_send+0x64>
  8041d4:	eb 3c                	jmp    804212 <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  8041d6:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8041da:	74 2a                	je     804206 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  8041dc:	48 ba 20 4c 80 00 00 	movabs $0x804c20,%rdx
  8041e3:	00 00 00 
  8041e6:	be 39 00 00 00       	mov    $0x39,%esi
  8041eb:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  8041f2:	00 00 00 
  8041f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8041fa:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  804201:	00 00 00 
  804204:	ff d1                	callq  *%rcx
		sys_yield();  
  804206:	48 b8 e9 1a 80 00 00 	movabs $0x801ae9,%rax
  80420d:	00 00 00 
  804210:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  804212:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804215:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804218:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80421c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80421f:	89 c7                	mov    %eax,%edi
  804221:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  804228:	00 00 00 
  80422b:	ff d0                	callq  *%rax
  80422d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804230:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804234:	78 a0                	js     8041d6 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  804236:	c9                   	leaveq 
  804237:	c3                   	retq   

0000000000804238 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804238:	55                   	push   %rbp
  804239:	48 89 e5             	mov    %rsp,%rbp
  80423c:	48 83 ec 10          	sub    $0x10,%rsp
  804240:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  804244:	48 ba 58 4c 80 00 00 	movabs $0x804c58,%rdx
  80424b:	00 00 00 
  80424e:	be 47 00 00 00       	mov    $0x47,%esi
  804253:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  80425a:	00 00 00 
  80425d:	b8 00 00 00 00       	mov    $0x0,%eax
  804262:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  804269:	00 00 00 
  80426c:	ff d1                	callq  *%rcx

000000000080426e <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80426e:	55                   	push   %rbp
  80426f:	48 89 e5             	mov    %rsp,%rbp
  804272:	48 83 ec 20          	sub    $0x20,%rsp
  804276:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804279:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80427c:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  804280:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  804283:	48 ba 80 4c 80 00 00 	movabs $0x804c80,%rdx
  80428a:	00 00 00 
  80428d:	be 50 00 00 00       	mov    $0x50,%esi
  804292:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  804299:	00 00 00 
  80429c:	b8 00 00 00 00       	mov    $0x0,%eax
  8042a1:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  8042a8:	00 00 00 
  8042ab:	ff d1                	callq  *%rcx

00000000008042ad <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8042ad:	55                   	push   %rbp
  8042ae:	48 89 e5             	mov    %rsp,%rbp
  8042b1:	48 83 ec 14          	sub    $0x14,%rsp
  8042b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8042b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042bf:	eb 4e                	jmp    80430f <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8042c1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8042c8:	00 00 00 
  8042cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042ce:	48 98                	cltq   
  8042d0:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8042d7:	48 01 d0             	add    %rdx,%rax
  8042da:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8042e0:	8b 00                	mov    (%rax),%eax
  8042e2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8042e5:	75 24                	jne    80430b <ipc_find_env+0x5e>
			return envs[i].env_id;
  8042e7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8042ee:	00 00 00 
  8042f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042f4:	48 98                	cltq   
  8042f6:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8042fd:	48 01 d0             	add    %rdx,%rax
  804300:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804306:	8b 40 08             	mov    0x8(%rax),%eax
  804309:	eb 12                	jmp    80431d <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80430b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80430f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804316:	7e a9                	jle    8042c1 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  804318:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80431d:	c9                   	leaveq 
  80431e:	c3                   	retq   

000000000080431f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80431f:	55                   	push   %rbp
  804320:	48 89 e5             	mov    %rsp,%rbp
  804323:	48 83 ec 18          	sub    $0x18,%rsp
  804327:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80432b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80432f:	48 c1 e8 15          	shr    $0x15,%rax
  804333:	48 89 c2             	mov    %rax,%rdx
  804336:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80433d:	01 00 00 
  804340:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804344:	83 e0 01             	and    $0x1,%eax
  804347:	48 85 c0             	test   %rax,%rax
  80434a:	75 07                	jne    804353 <pageref+0x34>
		return 0;
  80434c:	b8 00 00 00 00       	mov    $0x0,%eax
  804351:	eb 53                	jmp    8043a6 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804353:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804357:	48 c1 e8 0c          	shr    $0xc,%rax
  80435b:	48 89 c2             	mov    %rax,%rdx
  80435e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804365:	01 00 00 
  804368:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80436c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804370:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804374:	83 e0 01             	and    $0x1,%eax
  804377:	48 85 c0             	test   %rax,%rax
  80437a:	75 07                	jne    804383 <pageref+0x64>
		return 0;
  80437c:	b8 00 00 00 00       	mov    $0x0,%eax
  804381:	eb 23                	jmp    8043a6 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804387:	48 c1 e8 0c          	shr    $0xc,%rax
  80438b:	48 89 c2             	mov    %rax,%rdx
  80438e:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804395:	00 00 00 
  804398:	48 c1 e2 04          	shl    $0x4,%rdx
  80439c:	48 01 d0             	add    %rdx,%rax
  80439f:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8043a3:	0f b7 c0             	movzwl %ax,%eax
}
  8043a6:	c9                   	leaveq 
  8043a7:	c3                   	retq   
