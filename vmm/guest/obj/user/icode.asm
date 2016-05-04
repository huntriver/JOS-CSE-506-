
vmm/guest/obj/user/icode:     file format elf64-x86-64


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
  80003c:	e8 21 02 00 00       	callq  800262 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#define MOTD "/motd"
#endif

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 81 ec 28 02 00 00 	sub    $0x228,%rsp
  80004f:	89 bd dc fd ff ff    	mov    %edi,-0x224(%rbp)
  800055:	48 89 b5 d0 fd ff ff 	mov    %rsi,-0x230(%rbp)
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80005c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800063:	00 00 00 
  800066:	48 bb 40 44 80 00 00 	movabs $0x804440,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	cprintf("icode startup\n");
  800073:	48 bf 46 44 80 00 00 	movabs $0x804446,%rdi
  80007a:	00 00 00 
  80007d:	b8 00 00 00 00       	mov    $0x0,%eax
  800082:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800089:	00 00 00 
  80008c:	ff d2                	callq  *%rdx

	cprintf("icode: open /motd\n");
  80008e:	48 bf 55 44 80 00 00 	movabs $0x804455,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  8000a4:	00 00 00 
  8000a7:	ff d2                	callq  *%rdx
	if ((fd = open(MOTD, O_RDONLY)) < 0)
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	48 bf 68 44 80 00 00 	movabs $0x804468,%rdi
  8000b5:	00 00 00 
  8000b8:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("icode: open /motd: %e", fd);
  8000cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 74 44 80 00 00 	movabs $0x804474,%rdx
  8000d9:	00 00 00 
  8000dc:	be 15 00 00 00       	mov    $0x15,%esi
  8000e1:	48 bf 8a 44 80 00 00 	movabs $0x80448a,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8

	cprintf("icode: read /motd\n");
  8000fd:	48 bf 97 44 80 00 00 	movabs $0x804497,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800113:	00 00 00 
  800116:	ff d2                	callq  *%rdx
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800118:	eb 3a                	jmp    800154 <umain+0x111>
		cprintf("Writing MOTD\n");
  80011a:	48 bf aa 44 80 00 00 	movabs $0x8044aa,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800130:	00 00 00 
  800133:	ff d2                	callq  *%rdx
		sys_cputs(buf, n);
  800135:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800138:	48 63 d0             	movslq %eax,%rdx
  80013b:	48 8d 85 e0 fd ff ff 	lea    -0x220(%rbp),%rax
  800142:	48 89 d6             	mov    %rdx,%rsi
  800145:	48 89 c7             	mov    %rax,%rdi
  800148:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  80014f:	00 00 00 
  800152:	ff d0                	callq  *%rax
	cprintf("icode: open /motd\n");
	if ((fd = open(MOTD, O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800154:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
  80015b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80015e:	ba 00 02 00 00       	mov    $0x200,%edx
  800163:	48 89 ce             	mov    %rcx,%rsi
  800166:	89 c7                	mov    %eax,%edi
  800168:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  80016f:	00 00 00 
  800172:	ff d0                	callq  *%rax
  800174:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800177:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80017b:	7f 9d                	jg     80011a <umain+0xd7>
		cprintf("Writing MOTD\n");
		sys_cputs(buf, n);
	}

	cprintf("icode: close /motd\n");
  80017d:	48 bf b8 44 80 00 00 	movabs $0x8044b8,%rdi
  800184:	00 00 00 
  800187:	b8 00 00 00 00       	mov    $0x0,%eax
  80018c:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800193:	00 00 00 
  800196:	ff d2                	callq  *%rdx
	close(fd);
  800198:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80019b:	89 c7                	mov    %eax,%edi
  80019d:	48 b8 f7 20 80 00 00 	movabs $0x8020f7,%rax
  8001a4:	00 00 00 
  8001a7:	ff d0                	callq  *%rax

	cprintf("icode: spawn /sbin/init\n");
  8001a9:	48 bf cc 44 80 00 00 	movabs $0x8044cc,%rdi
  8001b0:	00 00 00 
  8001b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b8:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  8001bf:	00 00 00 
  8001c2:	ff d2                	callq  *%rdx
	if ((r = spawnl("/sbin/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8001c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ca:	48 b9 e5 44 80 00 00 	movabs $0x8044e5,%rcx
  8001d1:	00 00 00 
  8001d4:	48 ba ee 44 80 00 00 	movabs $0x8044ee,%rdx
  8001db:	00 00 00 
  8001de:	48 be f7 44 80 00 00 	movabs $0x8044f7,%rsi
  8001e5:	00 00 00 
  8001e8:	48 bf fc 44 80 00 00 	movabs $0x8044fc,%rdi
  8001ef:	00 00 00 
  8001f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f7:	49 b9 b8 30 80 00 00 	movabs $0x8030b8,%r9
  8001fe:	00 00 00 
  800201:	41 ff d1             	callq  *%r9
  800204:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800207:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("icode: spawn /sbin/init: %e", r);
  80020d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba 07 45 80 00 00 	movabs $0x804507,%rdx
  800219:	00 00 00 
  80021c:	be 22 00 00 00       	mov    $0x22,%esi
  800221:	48 bf 8a 44 80 00 00 	movabs $0x80448a,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8
	cprintf("icode: exiting\n");
  80023d:	48 bf 23 45 80 00 00 	movabs $0x804523,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
}
  800258:	48 81 c4 28 02 00 00 	add    $0x228,%rsp
  80025f:	5b                   	pop    %rbx
  800260:	5d                   	pop    %rbp
  800261:	c3                   	retq   

0000000000800262 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800262:	55                   	push   %rbp
  800263:	48 89 e5             	mov    %rsp,%rbp
  800266:	48 83 ec 10          	sub    $0x10,%rsp
  80026a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80026d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  800271:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
  80027d:	48 98                	cltq   
  80027f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800284:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  80028b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800292:	00 00 00 
  800295:	48 01 c2             	add    %rax,%rdx
  800298:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80029f:	00 00 00 
  8002a2:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002a9:	7e 14                	jle    8002bf <libmain+0x5d>
		binaryname = argv[0];
  8002ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002af:	48 8b 10             	mov    (%rax),%rdx
  8002b2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002b9:	00 00 00 
  8002bc:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002c6:	48 89 d6             	mov    %rdx,%rsi
  8002c9:	89 c7                	mov    %eax,%edi
  8002cb:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002d2:	00 00 00 
  8002d5:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002d7:	48 b8 e5 02 80 00 00 	movabs $0x8002e5,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	callq  *%rax
}
  8002e3:	c9                   	leaveq 
  8002e4:	c3                   	retq   

00000000008002e5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002e5:	55                   	push   %rbp
  8002e6:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8002e9:	48 b8 42 21 80 00 00 	movabs $0x802142,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8002f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8002fa:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax
}
  800306:	5d                   	pop    %rbp
  800307:	c3                   	retq   

0000000000800308 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800308:	55                   	push   %rbp
  800309:	48 89 e5             	mov    %rsp,%rbp
  80030c:	53                   	push   %rbx
  80030d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800314:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80031b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800321:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800328:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80032f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800336:	84 c0                	test   %al,%al
  800338:	74 23                	je     80035d <_panic+0x55>
  80033a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800341:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800345:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800349:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80034d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800351:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800355:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800359:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80035d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800364:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80036b:	00 00 00 
  80036e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800375:	00 00 00 
  800378:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80037c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800383:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80038a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800391:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800398:	00 00 00 
  80039b:	48 8b 18             	mov    (%rax),%rbx
  80039e:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  8003a5:	00 00 00 
  8003a8:	ff d0                	callq  *%rax
  8003aa:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003b0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003b7:	41 89 c8             	mov    %ecx,%r8d
  8003ba:	48 89 d1             	mov    %rdx,%rcx
  8003bd:	48 89 da             	mov    %rbx,%rdx
  8003c0:	89 c6                	mov    %eax,%esi
  8003c2:	48 bf 40 45 80 00 00 	movabs $0x804540,%rdi
  8003c9:	00 00 00 
  8003cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d1:	49 b9 41 05 80 00 00 	movabs $0x800541,%r9
  8003d8:	00 00 00 
  8003db:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003de:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003e5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003ec:	48 89 d6             	mov    %rdx,%rsi
  8003ef:	48 89 c7             	mov    %rax,%rdi
  8003f2:	48 b8 95 04 80 00 00 	movabs $0x800495,%rax
  8003f9:	00 00 00 
  8003fc:	ff d0                	callq  *%rax
	cprintf("\n");
  8003fe:	48 bf 63 45 80 00 00 	movabs $0x804563,%rdi
  800405:	00 00 00 
  800408:	b8 00 00 00 00       	mov    $0x0,%eax
  80040d:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  800414:	00 00 00 
  800417:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800419:	cc                   	int3   
  80041a:	eb fd                	jmp    800419 <_panic+0x111>

000000000080041c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80041c:	55                   	push   %rbp
  80041d:	48 89 e5             	mov    %rsp,%rbp
  800420:	48 83 ec 10          	sub    $0x10,%rsp
  800424:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800427:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80042b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042f:	8b 00                	mov    (%rax),%eax
  800431:	8d 48 01             	lea    0x1(%rax),%ecx
  800434:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800438:	89 0a                	mov    %ecx,(%rdx)
  80043a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80043d:	89 d1                	mov    %edx,%ecx
  80043f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800443:	48 98                	cltq   
  800445:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800449:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044d:	8b 00                	mov    (%rax),%eax
  80044f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800454:	75 2c                	jne    800482 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800456:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80045a:	8b 00                	mov    (%rax),%eax
  80045c:	48 98                	cltq   
  80045e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800462:	48 83 c2 08          	add    $0x8,%rdx
  800466:	48 89 c6             	mov    %rax,%rsi
  800469:	48 89 d7             	mov    %rdx,%rdi
  80046c:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  800473:	00 00 00 
  800476:	ff d0                	callq  *%rax
        b->idx = 0;
  800478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800482:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800486:	8b 40 04             	mov    0x4(%rax),%eax
  800489:	8d 50 01             	lea    0x1(%rax),%edx
  80048c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800490:	89 50 04             	mov    %edx,0x4(%rax)
}
  800493:	c9                   	leaveq 
  800494:	c3                   	retq   

0000000000800495 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800495:	55                   	push   %rbp
  800496:	48 89 e5             	mov    %rsp,%rbp
  800499:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004a0:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004a7:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004ae:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004b5:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004bc:	48 8b 0a             	mov    (%rdx),%rcx
  8004bf:	48 89 08             	mov    %rcx,(%rax)
  8004c2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004c6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004ca:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004ce:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004d9:	00 00 00 
    b.cnt = 0;
  8004dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004e3:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004e6:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004ed:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004f4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004fb:	48 89 c6             	mov    %rax,%rsi
  8004fe:	48 bf 1c 04 80 00 00 	movabs $0x80041c,%rdi
  800505:	00 00 00 
  800508:	48 b8 f4 08 80 00 00 	movabs $0x8008f4,%rax
  80050f:	00 00 00 
  800512:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800514:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80051a:	48 98                	cltq   
  80051c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800523:	48 83 c2 08          	add    $0x8,%rdx
  800527:	48 89 c6             	mov    %rax,%rsi
  80052a:	48 89 d7             	mov    %rdx,%rdi
  80052d:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  800534:	00 00 00 
  800537:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800539:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80053f:	c9                   	leaveq 
  800540:	c3                   	retq   

0000000000800541 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800541:	55                   	push   %rbp
  800542:	48 89 e5             	mov    %rsp,%rbp
  800545:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80054c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800553:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80055a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800561:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800568:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80056f:	84 c0                	test   %al,%al
  800571:	74 20                	je     800593 <cprintf+0x52>
  800573:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800577:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80057b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80057f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800583:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800587:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80058b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80058f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800593:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80059a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005a1:	00 00 00 
  8005a4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005ab:	00 00 00 
  8005ae:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005b2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005b9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005c0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005c7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005ce:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005d5:	48 8b 0a             	mov    (%rdx),%rcx
  8005d8:	48 89 08             	mov    %rcx,(%rax)
  8005db:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005df:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005e3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005e7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005eb:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005f2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005f9:	48 89 d6             	mov    %rdx,%rsi
  8005fc:	48 89 c7             	mov    %rax,%rdi
  8005ff:	48 b8 95 04 80 00 00 	movabs $0x800495,%rax
  800606:	00 00 00 
  800609:	ff d0                	callq  *%rax
  80060b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800611:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800617:	c9                   	leaveq 
  800618:	c3                   	retq   

0000000000800619 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800619:	55                   	push   %rbp
  80061a:	48 89 e5             	mov    %rsp,%rbp
  80061d:	53                   	push   %rbx
  80061e:	48 83 ec 38          	sub    $0x38,%rsp
  800622:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800626:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80062a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80062e:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800631:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800635:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800639:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80063c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800640:	77 3b                	ja     80067d <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800642:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800645:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800649:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80064c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800650:	ba 00 00 00 00       	mov    $0x0,%edx
  800655:	48 f7 f3             	div    %rbx
  800658:	48 89 c2             	mov    %rax,%rdx
  80065b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80065e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800661:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800669:	41 89 f9             	mov    %edi,%r9d
  80066c:	48 89 c7             	mov    %rax,%rdi
  80066f:	48 b8 19 06 80 00 00 	movabs $0x800619,%rax
  800676:	00 00 00 
  800679:	ff d0                	callq  *%rax
  80067b:	eb 1e                	jmp    80069b <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80067d:	eb 12                	jmp    800691 <printnum+0x78>
			putch(padc, putdat);
  80067f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800683:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800686:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068a:	48 89 ce             	mov    %rcx,%rsi
  80068d:	89 d7                	mov    %edx,%edi
  80068f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800691:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800695:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800699:	7f e4                	jg     80067f <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80069b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80069e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a7:	48 f7 f1             	div    %rcx
  8006aa:	48 89 d0             	mov    %rdx,%rax
  8006ad:	48 ba 70 47 80 00 00 	movabs $0x804770,%rdx
  8006b4:	00 00 00 
  8006b7:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006bb:	0f be d0             	movsbl %al,%edx
  8006be:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c6:	48 89 ce             	mov    %rcx,%rsi
  8006c9:	89 d7                	mov    %edx,%edi
  8006cb:	ff d0                	callq  *%rax
}
  8006cd:	48 83 c4 38          	add    $0x38,%rsp
  8006d1:	5b                   	pop    %rbx
  8006d2:	5d                   	pop    %rbp
  8006d3:	c3                   	retq   

00000000008006d4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006d4:	55                   	push   %rbp
  8006d5:	48 89 e5             	mov    %rsp,%rbp
  8006d8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006e0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006e3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006e7:	7e 52                	jle    80073b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ed:	8b 00                	mov    (%rax),%eax
  8006ef:	83 f8 30             	cmp    $0x30,%eax
  8006f2:	73 24                	jae    800718 <getuint+0x44>
  8006f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800700:	8b 00                	mov    (%rax),%eax
  800702:	89 c0                	mov    %eax,%eax
  800704:	48 01 d0             	add    %rdx,%rax
  800707:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070b:	8b 12                	mov    (%rdx),%edx
  80070d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800710:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800714:	89 0a                	mov    %ecx,(%rdx)
  800716:	eb 17                	jmp    80072f <getuint+0x5b>
  800718:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800720:	48 89 d0             	mov    %rdx,%rax
  800723:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800727:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80072f:	48 8b 00             	mov    (%rax),%rax
  800732:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800736:	e9 a3 00 00 00       	jmpq   8007de <getuint+0x10a>
	else if (lflag)
  80073b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80073f:	74 4f                	je     800790 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800745:	8b 00                	mov    (%rax),%eax
  800747:	83 f8 30             	cmp    $0x30,%eax
  80074a:	73 24                	jae    800770 <getuint+0x9c>
  80074c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800750:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800758:	8b 00                	mov    (%rax),%eax
  80075a:	89 c0                	mov    %eax,%eax
  80075c:	48 01 d0             	add    %rdx,%rax
  80075f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800763:	8b 12                	mov    (%rdx),%edx
  800765:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800768:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076c:	89 0a                	mov    %ecx,(%rdx)
  80076e:	eb 17                	jmp    800787 <getuint+0xb3>
  800770:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800774:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800778:	48 89 d0             	mov    %rdx,%rax
  80077b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80077f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800783:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800787:	48 8b 00             	mov    (%rax),%rax
  80078a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80078e:	eb 4e                	jmp    8007de <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800794:	8b 00                	mov    (%rax),%eax
  800796:	83 f8 30             	cmp    $0x30,%eax
  800799:	73 24                	jae    8007bf <getuint+0xeb>
  80079b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a7:	8b 00                	mov    (%rax),%eax
  8007a9:	89 c0                	mov    %eax,%eax
  8007ab:	48 01 d0             	add    %rdx,%rax
  8007ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b2:	8b 12                	mov    (%rdx),%edx
  8007b4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bb:	89 0a                	mov    %ecx,(%rdx)
  8007bd:	eb 17                	jmp    8007d6 <getuint+0x102>
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007c7:	48 89 d0             	mov    %rdx,%rax
  8007ca:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d6:	8b 00                	mov    (%rax),%eax
  8007d8:	89 c0                	mov    %eax,%eax
  8007da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007e2:	c9                   	leaveq 
  8007e3:	c3                   	retq   

00000000008007e4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007e4:	55                   	push   %rbp
  8007e5:	48 89 e5             	mov    %rsp,%rbp
  8007e8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007f0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007f3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007f7:	7e 52                	jle    80084b <getint+0x67>
		x=va_arg(*ap, long long);
  8007f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fd:	8b 00                	mov    (%rax),%eax
  8007ff:	83 f8 30             	cmp    $0x30,%eax
  800802:	73 24                	jae    800828 <getint+0x44>
  800804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800808:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80080c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800810:	8b 00                	mov    (%rax),%eax
  800812:	89 c0                	mov    %eax,%eax
  800814:	48 01 d0             	add    %rdx,%rax
  800817:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081b:	8b 12                	mov    (%rdx),%edx
  80081d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800820:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800824:	89 0a                	mov    %ecx,(%rdx)
  800826:	eb 17                	jmp    80083f <getint+0x5b>
  800828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800830:	48 89 d0             	mov    %rdx,%rax
  800833:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800837:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80083f:	48 8b 00             	mov    (%rax),%rax
  800842:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800846:	e9 a3 00 00 00       	jmpq   8008ee <getint+0x10a>
	else if (lflag)
  80084b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80084f:	74 4f                	je     8008a0 <getint+0xbc>
		x=va_arg(*ap, long);
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	8b 00                	mov    (%rax),%eax
  800857:	83 f8 30             	cmp    $0x30,%eax
  80085a:	73 24                	jae    800880 <getint+0x9c>
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
  80087e:	eb 17                	jmp    800897 <getint+0xb3>
  800880:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800884:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800888:	48 89 d0             	mov    %rdx,%rax
  80088b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80088f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800893:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800897:	48 8b 00             	mov    (%rax),%rax
  80089a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80089e:	eb 4e                	jmp    8008ee <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	8b 00                	mov    (%rax),%eax
  8008a6:	83 f8 30             	cmp    $0x30,%eax
  8008a9:	73 24                	jae    8008cf <getint+0xeb>
  8008ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008af:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b7:	8b 00                	mov    (%rax),%eax
  8008b9:	89 c0                	mov    %eax,%eax
  8008bb:	48 01 d0             	add    %rdx,%rax
  8008be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c2:	8b 12                	mov    (%rdx),%edx
  8008c4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cb:	89 0a                	mov    %ecx,(%rdx)
  8008cd:	eb 17                	jmp    8008e6 <getint+0x102>
  8008cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008d7:	48 89 d0             	mov    %rdx,%rax
  8008da:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008e6:	8b 00                	mov    (%rax),%eax
  8008e8:	48 98                	cltq   
  8008ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008f2:	c9                   	leaveq 
  8008f3:	c3                   	retq   

00000000008008f4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008f4:	55                   	push   %rbp
  8008f5:	48 89 e5             	mov    %rsp,%rbp
  8008f8:	41 54                	push   %r12
  8008fa:	53                   	push   %rbx
  8008fb:	48 83 ec 60          	sub    $0x60,%rsp
  8008ff:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800903:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800907:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80090b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80090f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800913:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800917:	48 8b 0a             	mov    (%rdx),%rcx
  80091a:	48 89 08             	mov    %rcx,(%rax)
  80091d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800921:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800925:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800929:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092d:	eb 28                	jmp    800957 <vprintfmt+0x63>
			if (ch == '\0'){
  80092f:	85 db                	test   %ebx,%ebx
  800931:	75 15                	jne    800948 <vprintfmt+0x54>
				current_color=WHITE;
  800933:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80093a:	00 00 00 
  80093d:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800943:	e9 fc 04 00 00       	jmpq   800e44 <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  800948:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80094c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800950:	48 89 d6             	mov    %rdx,%rsi
  800953:	89 df                	mov    %ebx,%edi
  800955:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800957:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80095b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80095f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800963:	0f b6 00             	movzbl (%rax),%eax
  800966:	0f b6 d8             	movzbl %al,%ebx
  800969:	83 fb 25             	cmp    $0x25,%ebx
  80096c:	75 c1                	jne    80092f <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80096e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800972:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800979:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800980:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800987:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80098e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800992:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800996:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80099a:	0f b6 00             	movzbl (%rax),%eax
  80099d:	0f b6 d8             	movzbl %al,%ebx
  8009a0:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009a3:	83 f8 55             	cmp    $0x55,%eax
  8009a6:	0f 87 64 04 00 00    	ja     800e10 <vprintfmt+0x51c>
  8009ac:	89 c0                	mov    %eax,%eax
  8009ae:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009b5:	00 
  8009b6:	48 b8 98 47 80 00 00 	movabs $0x804798,%rax
  8009bd:	00 00 00 
  8009c0:	48 01 d0             	add    %rdx,%rax
  8009c3:	48 8b 00             	mov    (%rax),%rax
  8009c6:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009c8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009cc:	eb c0                	jmp    80098e <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009ce:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009d2:	eb ba                	jmp    80098e <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009db:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009de:	89 d0                	mov    %edx,%eax
  8009e0:	c1 e0 02             	shl    $0x2,%eax
  8009e3:	01 d0                	add    %edx,%eax
  8009e5:	01 c0                	add    %eax,%eax
  8009e7:	01 d8                	add    %ebx,%eax
  8009e9:	83 e8 30             	sub    $0x30,%eax
  8009ec:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009ef:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009f3:	0f b6 00             	movzbl (%rax),%eax
  8009f6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009f9:	83 fb 2f             	cmp    $0x2f,%ebx
  8009fc:	7e 0c                	jle    800a0a <vprintfmt+0x116>
  8009fe:	83 fb 39             	cmp    $0x39,%ebx
  800a01:	7f 07                	jg     800a0a <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a03:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a08:	eb d1                	jmp    8009db <vprintfmt+0xe7>
			goto process_precision;
  800a0a:	eb 58                	jmp    800a64 <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800a0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0f:	83 f8 30             	cmp    $0x30,%eax
  800a12:	73 17                	jae    800a2b <vprintfmt+0x137>
  800a14:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1b:	89 c0                	mov    %eax,%eax
  800a1d:	48 01 d0             	add    %rdx,%rax
  800a20:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a23:	83 c2 08             	add    $0x8,%edx
  800a26:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a29:	eb 0f                	jmp    800a3a <vprintfmt+0x146>
  800a2b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a2f:	48 89 d0             	mov    %rdx,%rax
  800a32:	48 83 c2 08          	add    $0x8,%rdx
  800a36:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a3a:	8b 00                	mov    (%rax),%eax
  800a3c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a3f:	eb 23                	jmp    800a64 <vprintfmt+0x170>

		case '.':
			if (width < 0)
  800a41:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a45:	79 0c                	jns    800a53 <vprintfmt+0x15f>
				width = 0;
  800a47:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a4e:	e9 3b ff ff ff       	jmpq   80098e <vprintfmt+0x9a>
  800a53:	e9 36 ff ff ff       	jmpq   80098e <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  800a58:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a5f:	e9 2a ff ff ff       	jmpq   80098e <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  800a64:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a68:	79 12                	jns    800a7c <vprintfmt+0x188>
				width = precision, precision = -1;
  800a6a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a6d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a70:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a77:	e9 12 ff ff ff       	jmpq   80098e <vprintfmt+0x9a>
  800a7c:	e9 0d ff ff ff       	jmpq   80098e <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a81:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a85:	e9 04 ff ff ff       	jmpq   80098e <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8d:	83 f8 30             	cmp    $0x30,%eax
  800a90:	73 17                	jae    800aa9 <vprintfmt+0x1b5>
  800a92:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a99:	89 c0                	mov    %eax,%eax
  800a9b:	48 01 d0             	add    %rdx,%rax
  800a9e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aa1:	83 c2 08             	add    $0x8,%edx
  800aa4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aa7:	eb 0f                	jmp    800ab8 <vprintfmt+0x1c4>
  800aa9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aad:	48 89 d0             	mov    %rdx,%rax
  800ab0:	48 83 c2 08          	add    $0x8,%rdx
  800ab4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab8:	8b 10                	mov    (%rax),%edx
  800aba:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800abe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac2:	48 89 ce             	mov    %rcx,%rsi
  800ac5:	89 d7                	mov    %edx,%edi
  800ac7:	ff d0                	callq  *%rax
			break;
  800ac9:	e9 70 03 00 00       	jmpq   800e3e <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ace:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad1:	83 f8 30             	cmp    $0x30,%eax
  800ad4:	73 17                	jae    800aed <vprintfmt+0x1f9>
  800ad6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ada:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800add:	89 c0                	mov    %eax,%eax
  800adf:	48 01 d0             	add    %rdx,%rax
  800ae2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae5:	83 c2 08             	add    $0x8,%edx
  800ae8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aeb:	eb 0f                	jmp    800afc <vprintfmt+0x208>
  800aed:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800af1:	48 89 d0             	mov    %rdx,%rax
  800af4:	48 83 c2 08          	add    $0x8,%rdx
  800af8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800afc:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800afe:	85 db                	test   %ebx,%ebx
  800b00:	79 02                	jns    800b04 <vprintfmt+0x210>
				err = -err;
  800b02:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b04:	83 fb 15             	cmp    $0x15,%ebx
  800b07:	7f 16                	jg     800b1f <vprintfmt+0x22b>
  800b09:	48 b8 c0 46 80 00 00 	movabs $0x8046c0,%rax
  800b10:	00 00 00 
  800b13:	48 63 d3             	movslq %ebx,%rdx
  800b16:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b1a:	4d 85 e4             	test   %r12,%r12
  800b1d:	75 2e                	jne    800b4d <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  800b1f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b27:	89 d9                	mov    %ebx,%ecx
  800b29:	48 ba 81 47 80 00 00 	movabs $0x804781,%rdx
  800b30:	00 00 00 
  800b33:	48 89 c7             	mov    %rax,%rdi
  800b36:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3b:	49 b8 4d 0e 80 00 00 	movabs $0x800e4d,%r8
  800b42:	00 00 00 
  800b45:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b48:	e9 f1 02 00 00       	jmpq   800e3e <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b4d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b55:	4c 89 e1             	mov    %r12,%rcx
  800b58:	48 ba 8a 47 80 00 00 	movabs $0x80478a,%rdx
  800b5f:	00 00 00 
  800b62:	48 89 c7             	mov    %rax,%rdi
  800b65:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6a:	49 b8 4d 0e 80 00 00 	movabs $0x800e4d,%r8
  800b71:	00 00 00 
  800b74:	41 ff d0             	callq  *%r8
			break;
  800b77:	e9 c2 02 00 00       	jmpq   800e3e <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7f:	83 f8 30             	cmp    $0x30,%eax
  800b82:	73 17                	jae    800b9b <vprintfmt+0x2a7>
  800b84:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8b:	89 c0                	mov    %eax,%eax
  800b8d:	48 01 d0             	add    %rdx,%rax
  800b90:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b93:	83 c2 08             	add    $0x8,%edx
  800b96:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b99:	eb 0f                	jmp    800baa <vprintfmt+0x2b6>
  800b9b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b9f:	48 89 d0             	mov    %rdx,%rax
  800ba2:	48 83 c2 08          	add    $0x8,%rdx
  800ba6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800baa:	4c 8b 20             	mov    (%rax),%r12
  800bad:	4d 85 e4             	test   %r12,%r12
  800bb0:	75 0a                	jne    800bbc <vprintfmt+0x2c8>
				p = "(null)";
  800bb2:	49 bc 8d 47 80 00 00 	movabs $0x80478d,%r12
  800bb9:	00 00 00 
			if (width > 0 && padc != '-')
  800bbc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bc0:	7e 3f                	jle    800c01 <vprintfmt+0x30d>
  800bc2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bc6:	74 39                	je     800c01 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bc8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bcb:	48 98                	cltq   
  800bcd:	48 89 c6             	mov    %rax,%rsi
  800bd0:	4c 89 e7             	mov    %r12,%rdi
  800bd3:	48 b8 f9 10 80 00 00 	movabs $0x8010f9,%rax
  800bda:	00 00 00 
  800bdd:	ff d0                	callq  *%rax
  800bdf:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800be2:	eb 17                	jmp    800bfb <vprintfmt+0x307>
					putch(padc, putdat);
  800be4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800be8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf0:	48 89 ce             	mov    %rcx,%rsi
  800bf3:	89 d7                	mov    %edx,%edi
  800bf5:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bf7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bfb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bff:	7f e3                	jg     800be4 <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c01:	eb 37                	jmp    800c3a <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  800c03:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c07:	74 1e                	je     800c27 <vprintfmt+0x333>
  800c09:	83 fb 1f             	cmp    $0x1f,%ebx
  800c0c:	7e 05                	jle    800c13 <vprintfmt+0x31f>
  800c0e:	83 fb 7e             	cmp    $0x7e,%ebx
  800c11:	7e 14                	jle    800c27 <vprintfmt+0x333>
					putch('?', putdat);
  800c13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1b:	48 89 d6             	mov    %rdx,%rsi
  800c1e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c23:	ff d0                	callq  *%rax
  800c25:	eb 0f                	jmp    800c36 <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800c27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2f:	48 89 d6             	mov    %rdx,%rsi
  800c32:	89 df                	mov    %ebx,%edi
  800c34:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c36:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c3a:	4c 89 e0             	mov    %r12,%rax
  800c3d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c41:	0f b6 00             	movzbl (%rax),%eax
  800c44:	0f be d8             	movsbl %al,%ebx
  800c47:	85 db                	test   %ebx,%ebx
  800c49:	74 10                	je     800c5b <vprintfmt+0x367>
  800c4b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c4f:	78 b2                	js     800c03 <vprintfmt+0x30f>
  800c51:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c55:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c59:	79 a8                	jns    800c03 <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c5b:	eb 16                	jmp    800c73 <vprintfmt+0x37f>
				putch(' ', putdat);
  800c5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c65:	48 89 d6             	mov    %rdx,%rsi
  800c68:	bf 20 00 00 00       	mov    $0x20,%edi
  800c6d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c6f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c73:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c77:	7f e4                	jg     800c5d <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800c79:	e9 c0 01 00 00       	jmpq   800e3e <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c7e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c82:	be 03 00 00 00       	mov    $0x3,%esi
  800c87:	48 89 c7             	mov    %rax,%rdi
  800c8a:	48 b8 e4 07 80 00 00 	movabs $0x8007e4,%rax
  800c91:	00 00 00 
  800c94:	ff d0                	callq  *%rax
  800c96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9e:	48 85 c0             	test   %rax,%rax
  800ca1:	79 1d                	jns    800cc0 <vprintfmt+0x3cc>
				putch('-', putdat);
  800ca3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cab:	48 89 d6             	mov    %rdx,%rsi
  800cae:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cb3:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb9:	48 f7 d8             	neg    %rax
  800cbc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800cc0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cc7:	e9 d5 00 00 00       	jmpq   800da1 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ccc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cd0:	be 03 00 00 00       	mov    $0x3,%esi
  800cd5:	48 89 c7             	mov    %rax,%rdi
  800cd8:	48 b8 d4 06 80 00 00 	movabs $0x8006d4,%rax
  800cdf:	00 00 00 
  800ce2:	ff d0                	callq  *%rax
  800ce4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ce8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cef:	e9 ad 00 00 00       	jmpq   800da1 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800cf4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cf8:	be 03 00 00 00       	mov    $0x3,%esi
  800cfd:	48 89 c7             	mov    %rax,%rdi
  800d00:	48 b8 d4 06 80 00 00 	movabs $0x8006d4,%rax
  800d07:	00 00 00 
  800d0a:	ff d0                	callq  *%rax
  800d0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800d10:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d17:	e9 85 00 00 00       	jmpq   800da1 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800d1c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d20:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d24:	48 89 d6             	mov    %rdx,%rsi
  800d27:	bf 30 00 00 00       	mov    $0x30,%edi
  800d2c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d36:	48 89 d6             	mov    %rdx,%rsi
  800d39:	bf 78 00 00 00       	mov    $0x78,%edi
  800d3e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d43:	83 f8 30             	cmp    $0x30,%eax
  800d46:	73 17                	jae    800d5f <vprintfmt+0x46b>
  800d48:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d4c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d4f:	89 c0                	mov    %eax,%eax
  800d51:	48 01 d0             	add    %rdx,%rax
  800d54:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d57:	83 c2 08             	add    $0x8,%edx
  800d5a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d5d:	eb 0f                	jmp    800d6e <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  800d5f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d63:	48 89 d0             	mov    %rdx,%rax
  800d66:	48 83 c2 08          	add    $0x8,%rdx
  800d6a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d6e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d71:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d75:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d7c:	eb 23                	jmp    800da1 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d7e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d82:	be 03 00 00 00       	mov    $0x3,%esi
  800d87:	48 89 c7             	mov    %rax,%rdi
  800d8a:	48 b8 d4 06 80 00 00 	movabs $0x8006d4,%rax
  800d91:	00 00 00 
  800d94:	ff d0                	callq  *%rax
  800d96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d9a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800da1:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800da6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800da9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800dac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800db0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800db4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db8:	45 89 c1             	mov    %r8d,%r9d
  800dbb:	41 89 f8             	mov    %edi,%r8d
  800dbe:	48 89 c7             	mov    %rax,%rdi
  800dc1:	48 b8 19 06 80 00 00 	movabs $0x800619,%rax
  800dc8:	00 00 00 
  800dcb:	ff d0                	callq  *%rax
			break;
  800dcd:	eb 6f                	jmp    800e3e <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dcf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd7:	48 89 d6             	mov    %rdx,%rsi
  800dda:	89 df                	mov    %ebx,%edi
  800ddc:	ff d0                	callq  *%rax
			break;
  800dde:	eb 5e                	jmp    800e3e <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  800de0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800de4:	be 03 00 00 00       	mov    $0x3,%esi
  800de9:	48 89 c7             	mov    %rax,%rdi
  800dec:	48 b8 d4 06 80 00 00 	movabs $0x8006d4,%rax
  800df3:	00 00 00 
  800df6:	ff d0                	callq  *%rax
  800df8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  800dfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e00:	89 c2                	mov    %eax,%edx
  800e02:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800e09:	00 00 00 
  800e0c:	89 10                	mov    %edx,(%rax)
			break;
  800e0e:	eb 2e                	jmp    800e3e <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e18:	48 89 d6             	mov    %rdx,%rsi
  800e1b:	bf 25 00 00 00       	mov    $0x25,%edi
  800e20:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e22:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e27:	eb 05                	jmp    800e2e <vprintfmt+0x53a>
  800e29:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e2e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e32:	48 83 e8 01          	sub    $0x1,%rax
  800e36:	0f b6 00             	movzbl (%rax),%eax
  800e39:	3c 25                	cmp    $0x25,%al
  800e3b:	75 ec                	jne    800e29 <vprintfmt+0x535>
				/* do nothing */;
			break;
  800e3d:	90                   	nop
		}
	}
  800e3e:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e3f:	e9 13 fb ff ff       	jmpq   800957 <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e44:	48 83 c4 60          	add    $0x60,%rsp
  800e48:	5b                   	pop    %rbx
  800e49:	41 5c                	pop    %r12
  800e4b:	5d                   	pop    %rbp
  800e4c:	c3                   	retq   

0000000000800e4d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e4d:	55                   	push   %rbp
  800e4e:	48 89 e5             	mov    %rsp,%rbp
  800e51:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e58:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e5f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e66:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e6d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e74:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e7b:	84 c0                	test   %al,%al
  800e7d:	74 20                	je     800e9f <printfmt+0x52>
  800e7f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e83:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e87:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e8b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e8f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e93:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e97:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e9b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e9f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ea6:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ead:	00 00 00 
  800eb0:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800eb7:	00 00 00 
  800eba:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ebe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ec5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ecc:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ed3:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800eda:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ee1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ee8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800eef:	48 89 c7             	mov    %rax,%rdi
  800ef2:	48 b8 f4 08 80 00 00 	movabs $0x8008f4,%rax
  800ef9:	00 00 00 
  800efc:	ff d0                	callq  *%rax
	va_end(ap);
}
  800efe:	c9                   	leaveq 
  800eff:	c3                   	retq   

0000000000800f00 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f00:	55                   	push   %rbp
  800f01:	48 89 e5             	mov    %rsp,%rbp
  800f04:	48 83 ec 10          	sub    $0x10,%rsp
  800f08:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f13:	8b 40 10             	mov    0x10(%rax),%eax
  800f16:	8d 50 01             	lea    0x1(%rax),%edx
  800f19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f1d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f24:	48 8b 10             	mov    (%rax),%rdx
  800f27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f2b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f2f:	48 39 c2             	cmp    %rax,%rdx
  800f32:	73 17                	jae    800f4b <sprintputch+0x4b>
		*b->buf++ = ch;
  800f34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f38:	48 8b 00             	mov    (%rax),%rax
  800f3b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f43:	48 89 0a             	mov    %rcx,(%rdx)
  800f46:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f49:	88 10                	mov    %dl,(%rax)
}
  800f4b:	c9                   	leaveq 
  800f4c:	c3                   	retq   

0000000000800f4d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f4d:	55                   	push   %rbp
  800f4e:	48 89 e5             	mov    %rsp,%rbp
  800f51:	48 83 ec 50          	sub    $0x50,%rsp
  800f55:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f59:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f5c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f60:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f64:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f68:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f6c:	48 8b 0a             	mov    (%rdx),%rcx
  800f6f:	48 89 08             	mov    %rcx,(%rax)
  800f72:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f76:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f7a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f7e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f82:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f86:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f8a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f8d:	48 98                	cltq   
  800f8f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f93:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f97:	48 01 d0             	add    %rdx,%rax
  800f9a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f9e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fa5:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800faa:	74 06                	je     800fb2 <vsnprintf+0x65>
  800fac:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fb0:	7f 07                	jg     800fb9 <vsnprintf+0x6c>
		return -E_INVAL;
  800fb2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fb7:	eb 2f                	jmp    800fe8 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fb9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fbd:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800fc1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800fc5:	48 89 c6             	mov    %rax,%rsi
  800fc8:	48 bf 00 0f 80 00 00 	movabs $0x800f00,%rdi
  800fcf:	00 00 00 
  800fd2:	48 b8 f4 08 80 00 00 	movabs $0x8008f4,%rax
  800fd9:	00 00 00 
  800fdc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fde:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fe2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fe5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800fe8:	c9                   	leaveq 
  800fe9:	c3                   	retq   

0000000000800fea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fea:	55                   	push   %rbp
  800feb:	48 89 e5             	mov    %rsp,%rbp
  800fee:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ff5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ffc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801002:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801009:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801010:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801017:	84 c0                	test   %al,%al
  801019:	74 20                	je     80103b <snprintf+0x51>
  80101b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80101f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801023:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801027:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80102b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80102f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801033:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801037:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80103b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801042:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801049:	00 00 00 
  80104c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801053:	00 00 00 
  801056:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80105a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801061:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801068:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80106f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801076:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80107d:	48 8b 0a             	mov    (%rdx),%rcx
  801080:	48 89 08             	mov    %rcx,(%rax)
  801083:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801087:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80108b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80108f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801093:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80109a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010a1:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010a7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010ae:	48 89 c7             	mov    %rax,%rdi
  8010b1:	48 b8 4d 0f 80 00 00 	movabs $0x800f4d,%rax
  8010b8:	00 00 00 
  8010bb:	ff d0                	callq  *%rax
  8010bd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010c3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010c9:	c9                   	leaveq 
  8010ca:	c3                   	retq   

00000000008010cb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010cb:	55                   	push   %rbp
  8010cc:	48 89 e5             	mov    %rsp,%rbp
  8010cf:	48 83 ec 18          	sub    $0x18,%rsp
  8010d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010de:	eb 09                	jmp    8010e9 <strlen+0x1e>
		n++;
  8010e0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ed:	0f b6 00             	movzbl (%rax),%eax
  8010f0:	84 c0                	test   %al,%al
  8010f2:	75 ec                	jne    8010e0 <strlen+0x15>
		n++;
	return n;
  8010f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010f7:	c9                   	leaveq 
  8010f8:	c3                   	retq   

00000000008010f9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010f9:	55                   	push   %rbp
  8010fa:	48 89 e5             	mov    %rsp,%rbp
  8010fd:	48 83 ec 20          	sub    $0x20,%rsp
  801101:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801105:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801109:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801110:	eb 0e                	jmp    801120 <strnlen+0x27>
		n++;
  801112:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801116:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80111b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801120:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801125:	74 0b                	je     801132 <strnlen+0x39>
  801127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112b:	0f b6 00             	movzbl (%rax),%eax
  80112e:	84 c0                	test   %al,%al
  801130:	75 e0                	jne    801112 <strnlen+0x19>
		n++;
	return n;
  801132:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801135:	c9                   	leaveq 
  801136:	c3                   	retq   

0000000000801137 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801137:	55                   	push   %rbp
  801138:	48 89 e5             	mov    %rsp,%rbp
  80113b:	48 83 ec 20          	sub    $0x20,%rsp
  80113f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801143:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801147:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80114f:	90                   	nop
  801150:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801154:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801158:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80115c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801160:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801164:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801168:	0f b6 12             	movzbl (%rdx),%edx
  80116b:	88 10                	mov    %dl,(%rax)
  80116d:	0f b6 00             	movzbl (%rax),%eax
  801170:	84 c0                	test   %al,%al
  801172:	75 dc                	jne    801150 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801174:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801178:	c9                   	leaveq 
  801179:	c3                   	retq   

000000000080117a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80117a:	55                   	push   %rbp
  80117b:	48 89 e5             	mov    %rsp,%rbp
  80117e:	48 83 ec 20          	sub    $0x20,%rsp
  801182:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801186:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80118a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118e:	48 89 c7             	mov    %rax,%rdi
  801191:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  801198:	00 00 00 
  80119b:	ff d0                	callq  *%rax
  80119d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011a3:	48 63 d0             	movslq %eax,%rdx
  8011a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011aa:	48 01 c2             	add    %rax,%rdx
  8011ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b1:	48 89 c6             	mov    %rax,%rsi
  8011b4:	48 89 d7             	mov    %rdx,%rdi
  8011b7:	48 b8 37 11 80 00 00 	movabs $0x801137,%rax
  8011be:	00 00 00 
  8011c1:	ff d0                	callq  *%rax
	return dst;
  8011c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011c7:	c9                   	leaveq 
  8011c8:	c3                   	retq   

00000000008011c9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011c9:	55                   	push   %rbp
  8011ca:	48 89 e5             	mov    %rsp,%rbp
  8011cd:	48 83 ec 28          	sub    $0x28,%rsp
  8011d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011e5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011ec:	00 
  8011ed:	eb 2a                	jmp    801219 <strncpy+0x50>
		*dst++ = *src;
  8011ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011f7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011fb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011ff:	0f b6 12             	movzbl (%rdx),%edx
  801202:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801204:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801208:	0f b6 00             	movzbl (%rax),%eax
  80120b:	84 c0                	test   %al,%al
  80120d:	74 05                	je     801214 <strncpy+0x4b>
			src++;
  80120f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801214:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801219:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801221:	72 cc                	jb     8011ef <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801223:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801227:	c9                   	leaveq 
  801228:	c3                   	retq   

0000000000801229 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801229:	55                   	push   %rbp
  80122a:	48 89 e5             	mov    %rsp,%rbp
  80122d:	48 83 ec 28          	sub    $0x28,%rsp
  801231:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801235:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801239:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80123d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801241:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801245:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80124a:	74 3d                	je     801289 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80124c:	eb 1d                	jmp    80126b <strlcpy+0x42>
			*dst++ = *src++;
  80124e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801252:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801256:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80125a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80125e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801262:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801266:	0f b6 12             	movzbl (%rdx),%edx
  801269:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80126b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801270:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801275:	74 0b                	je     801282 <strlcpy+0x59>
  801277:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80127b:	0f b6 00             	movzbl (%rax),%eax
  80127e:	84 c0                	test   %al,%al
  801280:	75 cc                	jne    80124e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801286:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801289:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80128d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801291:	48 29 c2             	sub    %rax,%rdx
  801294:	48 89 d0             	mov    %rdx,%rax
}
  801297:	c9                   	leaveq 
  801298:	c3                   	retq   

0000000000801299 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801299:	55                   	push   %rbp
  80129a:	48 89 e5             	mov    %rsp,%rbp
  80129d:	48 83 ec 10          	sub    $0x10,%rsp
  8012a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012a9:	eb 0a                	jmp    8012b5 <strcmp+0x1c>
		p++, q++;
  8012ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b9:	0f b6 00             	movzbl (%rax),%eax
  8012bc:	84 c0                	test   %al,%al
  8012be:	74 12                	je     8012d2 <strcmp+0x39>
  8012c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c4:	0f b6 10             	movzbl (%rax),%edx
  8012c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012cb:	0f b6 00             	movzbl (%rax),%eax
  8012ce:	38 c2                	cmp    %al,%dl
  8012d0:	74 d9                	je     8012ab <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d6:	0f b6 00             	movzbl (%rax),%eax
  8012d9:	0f b6 d0             	movzbl %al,%edx
  8012dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e0:	0f b6 00             	movzbl (%rax),%eax
  8012e3:	0f b6 c0             	movzbl %al,%eax
  8012e6:	29 c2                	sub    %eax,%edx
  8012e8:	89 d0                	mov    %edx,%eax
}
  8012ea:	c9                   	leaveq 
  8012eb:	c3                   	retq   

00000000008012ec <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012ec:	55                   	push   %rbp
  8012ed:	48 89 e5             	mov    %rsp,%rbp
  8012f0:	48 83 ec 18          	sub    $0x18,%rsp
  8012f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801300:	eb 0f                	jmp    801311 <strncmp+0x25>
		n--, p++, q++;
  801302:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801307:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80130c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801311:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801316:	74 1d                	je     801335 <strncmp+0x49>
  801318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131c:	0f b6 00             	movzbl (%rax),%eax
  80131f:	84 c0                	test   %al,%al
  801321:	74 12                	je     801335 <strncmp+0x49>
  801323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801327:	0f b6 10             	movzbl (%rax),%edx
  80132a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132e:	0f b6 00             	movzbl (%rax),%eax
  801331:	38 c2                	cmp    %al,%dl
  801333:	74 cd                	je     801302 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801335:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80133a:	75 07                	jne    801343 <strncmp+0x57>
		return 0;
  80133c:	b8 00 00 00 00       	mov    $0x0,%eax
  801341:	eb 18                	jmp    80135b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801347:	0f b6 00             	movzbl (%rax),%eax
  80134a:	0f b6 d0             	movzbl %al,%edx
  80134d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801351:	0f b6 00             	movzbl (%rax),%eax
  801354:	0f b6 c0             	movzbl %al,%eax
  801357:	29 c2                	sub    %eax,%edx
  801359:	89 d0                	mov    %edx,%eax
}
  80135b:	c9                   	leaveq 
  80135c:	c3                   	retq   

000000000080135d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80135d:	55                   	push   %rbp
  80135e:	48 89 e5             	mov    %rsp,%rbp
  801361:	48 83 ec 0c          	sub    $0xc,%rsp
  801365:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801369:	89 f0                	mov    %esi,%eax
  80136b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80136e:	eb 17                	jmp    801387 <strchr+0x2a>
		if (*s == c)
  801370:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801374:	0f b6 00             	movzbl (%rax),%eax
  801377:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80137a:	75 06                	jne    801382 <strchr+0x25>
			return (char *) s;
  80137c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801380:	eb 15                	jmp    801397 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801382:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801387:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138b:	0f b6 00             	movzbl (%rax),%eax
  80138e:	84 c0                	test   %al,%al
  801390:	75 de                	jne    801370 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801392:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801397:	c9                   	leaveq 
  801398:	c3                   	retq   

0000000000801399 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801399:	55                   	push   %rbp
  80139a:	48 89 e5             	mov    %rsp,%rbp
  80139d:	48 83 ec 0c          	sub    $0xc,%rsp
  8013a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013a5:	89 f0                	mov    %esi,%eax
  8013a7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013aa:	eb 13                	jmp    8013bf <strfind+0x26>
		if (*s == c)
  8013ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b0:	0f b6 00             	movzbl (%rax),%eax
  8013b3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013b6:	75 02                	jne    8013ba <strfind+0x21>
			break;
  8013b8:	eb 10                	jmp    8013ca <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c3:	0f b6 00             	movzbl (%rax),%eax
  8013c6:	84 c0                	test   %al,%al
  8013c8:	75 e2                	jne    8013ac <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8013ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013ce:	c9                   	leaveq 
  8013cf:	c3                   	retq   

00000000008013d0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013d0:	55                   	push   %rbp
  8013d1:	48 89 e5             	mov    %rsp,%rbp
  8013d4:	48 83 ec 18          	sub    $0x18,%rsp
  8013d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013dc:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013df:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013e3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013e8:	75 06                	jne    8013f0 <memset+0x20>
		return v;
  8013ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ee:	eb 69                	jmp    801459 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f4:	83 e0 03             	and    $0x3,%eax
  8013f7:	48 85 c0             	test   %rax,%rax
  8013fa:	75 48                	jne    801444 <memset+0x74>
  8013fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801400:	83 e0 03             	and    $0x3,%eax
  801403:	48 85 c0             	test   %rax,%rax
  801406:	75 3c                	jne    801444 <memset+0x74>
		c &= 0xFF;
  801408:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80140f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801412:	c1 e0 18             	shl    $0x18,%eax
  801415:	89 c2                	mov    %eax,%edx
  801417:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80141a:	c1 e0 10             	shl    $0x10,%eax
  80141d:	09 c2                	or     %eax,%edx
  80141f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801422:	c1 e0 08             	shl    $0x8,%eax
  801425:	09 d0                	or     %edx,%eax
  801427:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80142a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142e:	48 c1 e8 02          	shr    $0x2,%rax
  801432:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801435:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801439:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80143c:	48 89 d7             	mov    %rdx,%rdi
  80143f:	fc                   	cld    
  801440:	f3 ab                	rep stos %eax,%es:(%rdi)
  801442:	eb 11                	jmp    801455 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801444:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801448:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80144b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80144f:	48 89 d7             	mov    %rdx,%rdi
  801452:	fc                   	cld    
  801453:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801459:	c9                   	leaveq 
  80145a:	c3                   	retq   

000000000080145b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80145b:	55                   	push   %rbp
  80145c:	48 89 e5             	mov    %rsp,%rbp
  80145f:	48 83 ec 28          	sub    $0x28,%rsp
  801463:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801467:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80146b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80146f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801473:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801477:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80147f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801483:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801487:	0f 83 88 00 00 00    	jae    801515 <memmove+0xba>
  80148d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801491:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801495:	48 01 d0             	add    %rdx,%rax
  801498:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80149c:	76 77                	jbe    801515 <memmove+0xba>
		s += n;
  80149e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a2:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014aa:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b2:	83 e0 03             	and    $0x3,%eax
  8014b5:	48 85 c0             	test   %rax,%rax
  8014b8:	75 3b                	jne    8014f5 <memmove+0x9a>
  8014ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014be:	83 e0 03             	and    $0x3,%eax
  8014c1:	48 85 c0             	test   %rax,%rax
  8014c4:	75 2f                	jne    8014f5 <memmove+0x9a>
  8014c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ca:	83 e0 03             	and    $0x3,%eax
  8014cd:	48 85 c0             	test   %rax,%rax
  8014d0:	75 23                	jne    8014f5 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d6:	48 83 e8 04          	sub    $0x4,%rax
  8014da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014de:	48 83 ea 04          	sub    $0x4,%rdx
  8014e2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014e6:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014ea:	48 89 c7             	mov    %rax,%rdi
  8014ed:	48 89 d6             	mov    %rdx,%rsi
  8014f0:	fd                   	std    
  8014f1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014f3:	eb 1d                	jmp    801512 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801501:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801505:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801509:	48 89 d7             	mov    %rdx,%rdi
  80150c:	48 89 c1             	mov    %rax,%rcx
  80150f:	fd                   	std    
  801510:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801512:	fc                   	cld    
  801513:	eb 57                	jmp    80156c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801515:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801519:	83 e0 03             	and    $0x3,%eax
  80151c:	48 85 c0             	test   %rax,%rax
  80151f:	75 36                	jne    801557 <memmove+0xfc>
  801521:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801525:	83 e0 03             	and    $0x3,%eax
  801528:	48 85 c0             	test   %rax,%rax
  80152b:	75 2a                	jne    801557 <memmove+0xfc>
  80152d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801531:	83 e0 03             	and    $0x3,%eax
  801534:	48 85 c0             	test   %rax,%rax
  801537:	75 1e                	jne    801557 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801539:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153d:	48 c1 e8 02          	shr    $0x2,%rax
  801541:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801544:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801548:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80154c:	48 89 c7             	mov    %rax,%rdi
  80154f:	48 89 d6             	mov    %rdx,%rsi
  801552:	fc                   	cld    
  801553:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801555:	eb 15                	jmp    80156c <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801557:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80155b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80155f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801563:	48 89 c7             	mov    %rax,%rdi
  801566:	48 89 d6             	mov    %rdx,%rsi
  801569:	fc                   	cld    
  80156a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80156c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801570:	c9                   	leaveq 
  801571:	c3                   	retq   

0000000000801572 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801572:	55                   	push   %rbp
  801573:	48 89 e5             	mov    %rsp,%rbp
  801576:	48 83 ec 18          	sub    $0x18,%rsp
  80157a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80157e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801582:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801586:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80158a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80158e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801592:	48 89 ce             	mov    %rcx,%rsi
  801595:	48 89 c7             	mov    %rax,%rdi
  801598:	48 b8 5b 14 80 00 00 	movabs $0x80145b,%rax
  80159f:	00 00 00 
  8015a2:	ff d0                	callq  *%rax
}
  8015a4:	c9                   	leaveq 
  8015a5:	c3                   	retq   

00000000008015a6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015a6:	55                   	push   %rbp
  8015a7:	48 89 e5             	mov    %rsp,%rbp
  8015aa:	48 83 ec 28          	sub    $0x28,%rsp
  8015ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015ca:	eb 36                	jmp    801602 <memcmp+0x5c>
		if (*s1 != *s2)
  8015cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d0:	0f b6 10             	movzbl (%rax),%edx
  8015d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d7:	0f b6 00             	movzbl (%rax),%eax
  8015da:	38 c2                	cmp    %al,%dl
  8015dc:	74 1a                	je     8015f8 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e2:	0f b6 00             	movzbl (%rax),%eax
  8015e5:	0f b6 d0             	movzbl %al,%edx
  8015e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ec:	0f b6 00             	movzbl (%rax),%eax
  8015ef:	0f b6 c0             	movzbl %al,%eax
  8015f2:	29 c2                	sub    %eax,%edx
  8015f4:	89 d0                	mov    %edx,%eax
  8015f6:	eb 20                	jmp    801618 <memcmp+0x72>
		s1++, s2++;
  8015f8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015fd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801606:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80160a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80160e:	48 85 c0             	test   %rax,%rax
  801611:	75 b9                	jne    8015cc <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801613:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801618:	c9                   	leaveq 
  801619:	c3                   	retq   

000000000080161a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80161a:	55                   	push   %rbp
  80161b:	48 89 e5             	mov    %rsp,%rbp
  80161e:	48 83 ec 28          	sub    $0x28,%rsp
  801622:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801626:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801629:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80162d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801631:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801635:	48 01 d0             	add    %rdx,%rax
  801638:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80163c:	eb 15                	jmp    801653 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80163e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801642:	0f b6 10             	movzbl (%rax),%edx
  801645:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801648:	38 c2                	cmp    %al,%dl
  80164a:	75 02                	jne    80164e <memfind+0x34>
			break;
  80164c:	eb 0f                	jmp    80165d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80164e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801657:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80165b:	72 e1                	jb     80163e <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80165d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801661:	c9                   	leaveq 
  801662:	c3                   	retq   

0000000000801663 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801663:	55                   	push   %rbp
  801664:	48 89 e5             	mov    %rsp,%rbp
  801667:	48 83 ec 34          	sub    $0x34,%rsp
  80166b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80166f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801673:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801676:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80167d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801684:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801685:	eb 05                	jmp    80168c <strtol+0x29>
		s++;
  801687:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80168c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801690:	0f b6 00             	movzbl (%rax),%eax
  801693:	3c 20                	cmp    $0x20,%al
  801695:	74 f0                	je     801687 <strtol+0x24>
  801697:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169b:	0f b6 00             	movzbl (%rax),%eax
  80169e:	3c 09                	cmp    $0x9,%al
  8016a0:	74 e5                	je     801687 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a6:	0f b6 00             	movzbl (%rax),%eax
  8016a9:	3c 2b                	cmp    $0x2b,%al
  8016ab:	75 07                	jne    8016b4 <strtol+0x51>
		s++;
  8016ad:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016b2:	eb 17                	jmp    8016cb <strtol+0x68>
	else if (*s == '-')
  8016b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b8:	0f b6 00             	movzbl (%rax),%eax
  8016bb:	3c 2d                	cmp    $0x2d,%al
  8016bd:	75 0c                	jne    8016cb <strtol+0x68>
		s++, neg = 1;
  8016bf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016cb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016cf:	74 06                	je     8016d7 <strtol+0x74>
  8016d1:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016d5:	75 28                	jne    8016ff <strtol+0x9c>
  8016d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016db:	0f b6 00             	movzbl (%rax),%eax
  8016de:	3c 30                	cmp    $0x30,%al
  8016e0:	75 1d                	jne    8016ff <strtol+0x9c>
  8016e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e6:	48 83 c0 01          	add    $0x1,%rax
  8016ea:	0f b6 00             	movzbl (%rax),%eax
  8016ed:	3c 78                	cmp    $0x78,%al
  8016ef:	75 0e                	jne    8016ff <strtol+0x9c>
		s += 2, base = 16;
  8016f1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016f6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016fd:	eb 2c                	jmp    80172b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016ff:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801703:	75 19                	jne    80171e <strtol+0xbb>
  801705:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801709:	0f b6 00             	movzbl (%rax),%eax
  80170c:	3c 30                	cmp    $0x30,%al
  80170e:	75 0e                	jne    80171e <strtol+0xbb>
		s++, base = 8;
  801710:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801715:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80171c:	eb 0d                	jmp    80172b <strtol+0xc8>
	else if (base == 0)
  80171e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801722:	75 07                	jne    80172b <strtol+0xc8>
		base = 10;
  801724:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80172b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172f:	0f b6 00             	movzbl (%rax),%eax
  801732:	3c 2f                	cmp    $0x2f,%al
  801734:	7e 1d                	jle    801753 <strtol+0xf0>
  801736:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173a:	0f b6 00             	movzbl (%rax),%eax
  80173d:	3c 39                	cmp    $0x39,%al
  80173f:	7f 12                	jg     801753 <strtol+0xf0>
			dig = *s - '0';
  801741:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801745:	0f b6 00             	movzbl (%rax),%eax
  801748:	0f be c0             	movsbl %al,%eax
  80174b:	83 e8 30             	sub    $0x30,%eax
  80174e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801751:	eb 4e                	jmp    8017a1 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801753:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801757:	0f b6 00             	movzbl (%rax),%eax
  80175a:	3c 60                	cmp    $0x60,%al
  80175c:	7e 1d                	jle    80177b <strtol+0x118>
  80175e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801762:	0f b6 00             	movzbl (%rax),%eax
  801765:	3c 7a                	cmp    $0x7a,%al
  801767:	7f 12                	jg     80177b <strtol+0x118>
			dig = *s - 'a' + 10;
  801769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176d:	0f b6 00             	movzbl (%rax),%eax
  801770:	0f be c0             	movsbl %al,%eax
  801773:	83 e8 57             	sub    $0x57,%eax
  801776:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801779:	eb 26                	jmp    8017a1 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80177b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177f:	0f b6 00             	movzbl (%rax),%eax
  801782:	3c 40                	cmp    $0x40,%al
  801784:	7e 48                	jle    8017ce <strtol+0x16b>
  801786:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178a:	0f b6 00             	movzbl (%rax),%eax
  80178d:	3c 5a                	cmp    $0x5a,%al
  80178f:	7f 3d                	jg     8017ce <strtol+0x16b>
			dig = *s - 'A' + 10;
  801791:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801795:	0f b6 00             	movzbl (%rax),%eax
  801798:	0f be c0             	movsbl %al,%eax
  80179b:	83 e8 37             	sub    $0x37,%eax
  80179e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017a4:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017a7:	7c 02                	jl     8017ab <strtol+0x148>
			break;
  8017a9:	eb 23                	jmp    8017ce <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017ab:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017b0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017b3:	48 98                	cltq   
  8017b5:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017ba:	48 89 c2             	mov    %rax,%rdx
  8017bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017c0:	48 98                	cltq   
  8017c2:	48 01 d0             	add    %rdx,%rax
  8017c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017c9:	e9 5d ff ff ff       	jmpq   80172b <strtol+0xc8>

	if (endptr)
  8017ce:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017d3:	74 0b                	je     8017e0 <strtol+0x17d>
		*endptr = (char *) s;
  8017d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017dd:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017e4:	74 09                	je     8017ef <strtol+0x18c>
  8017e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ea:	48 f7 d8             	neg    %rax
  8017ed:	eb 04                	jmp    8017f3 <strtol+0x190>
  8017ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017f3:	c9                   	leaveq 
  8017f4:	c3                   	retq   

00000000008017f5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8017f5:	55                   	push   %rbp
  8017f6:	48 89 e5             	mov    %rsp,%rbp
  8017f9:	48 83 ec 30          	sub    $0x30,%rsp
  8017fd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801801:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801805:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801809:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80180d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801811:	0f b6 00             	movzbl (%rax),%eax
  801814:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801817:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80181b:	75 06                	jne    801823 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80181d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801821:	eb 6b                	jmp    80188e <strstr+0x99>

	len = strlen(str);
  801823:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801827:	48 89 c7             	mov    %rax,%rdi
  80182a:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  801831:	00 00 00 
  801834:	ff d0                	callq  *%rax
  801836:	48 98                	cltq   
  801838:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80183c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801840:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801844:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801848:	0f b6 00             	movzbl (%rax),%eax
  80184b:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80184e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801852:	75 07                	jne    80185b <strstr+0x66>
				return (char *) 0;
  801854:	b8 00 00 00 00       	mov    $0x0,%eax
  801859:	eb 33                	jmp    80188e <strstr+0x99>
		} while (sc != c);
  80185b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80185f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801862:	75 d8                	jne    80183c <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801864:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801868:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80186c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801870:	48 89 ce             	mov    %rcx,%rsi
  801873:	48 89 c7             	mov    %rax,%rdi
  801876:	48 b8 ec 12 80 00 00 	movabs $0x8012ec,%rax
  80187d:	00 00 00 
  801880:	ff d0                	callq  *%rax
  801882:	85 c0                	test   %eax,%eax
  801884:	75 b6                	jne    80183c <strstr+0x47>

	return (char *) (in - 1);
  801886:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188a:	48 83 e8 01          	sub    $0x1,%rax
}
  80188e:	c9                   	leaveq 
  80188f:	c3                   	retq   

0000000000801890 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801890:	55                   	push   %rbp
  801891:	48 89 e5             	mov    %rsp,%rbp
  801894:	53                   	push   %rbx
  801895:	48 83 ec 48          	sub    $0x48,%rsp
  801899:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80189c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80189f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018a3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018a7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018ab:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018af:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018b2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018b6:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018ba:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018be:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018c2:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018c6:	4c 89 c3             	mov    %r8,%rbx
  8018c9:	cd 30                	int    $0x30
  8018cb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8018cf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018d3:	74 3e                	je     801913 <syscall+0x83>
  8018d5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018da:	7e 37                	jle    801913 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018e3:	49 89 d0             	mov    %rdx,%r8
  8018e6:	89 c1                	mov    %eax,%ecx
  8018e8:	48 ba 48 4a 80 00 00 	movabs $0x804a48,%rdx
  8018ef:	00 00 00 
  8018f2:	be 23 00 00 00       	mov    $0x23,%esi
  8018f7:	48 bf 65 4a 80 00 00 	movabs $0x804a65,%rdi
  8018fe:	00 00 00 
  801901:	b8 00 00 00 00       	mov    $0x0,%eax
  801906:	49 b9 08 03 80 00 00 	movabs $0x800308,%r9
  80190d:	00 00 00 
  801910:	41 ff d1             	callq  *%r9

	return ret;
  801913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801917:	48 83 c4 48          	add    $0x48,%rsp
  80191b:	5b                   	pop    %rbx
  80191c:	5d                   	pop    %rbp
  80191d:	c3                   	retq   

000000000080191e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80191e:	55                   	push   %rbp
  80191f:	48 89 e5             	mov    %rsp,%rbp
  801922:	48 83 ec 20          	sub    $0x20,%rsp
  801926:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80192a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80192e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801932:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801936:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80193d:	00 
  80193e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801944:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194a:	48 89 d1             	mov    %rdx,%rcx
  80194d:	48 89 c2             	mov    %rax,%rdx
  801950:	be 00 00 00 00       	mov    $0x0,%esi
  801955:	bf 00 00 00 00       	mov    $0x0,%edi
  80195a:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801961:	00 00 00 
  801964:	ff d0                	callq  *%rax
}
  801966:	c9                   	leaveq 
  801967:	c3                   	retq   

0000000000801968 <sys_cgetc>:

int
sys_cgetc(void)
{
  801968:	55                   	push   %rbp
  801969:	48 89 e5             	mov    %rsp,%rbp
  80196c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801970:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801977:	00 
  801978:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801984:	b9 00 00 00 00       	mov    $0x0,%ecx
  801989:	ba 00 00 00 00       	mov    $0x0,%edx
  80198e:	be 00 00 00 00       	mov    $0x0,%esi
  801993:	bf 01 00 00 00       	mov    $0x1,%edi
  801998:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  80199f:	00 00 00 
  8019a2:	ff d0                	callq  *%rax
}
  8019a4:	c9                   	leaveq 
  8019a5:	c3                   	retq   

00000000008019a6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019a6:	55                   	push   %rbp
  8019a7:	48 89 e5             	mov    %rsp,%rbp
  8019aa:	48 83 ec 10          	sub    $0x10,%rsp
  8019ae:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b4:	48 98                	cltq   
  8019b6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019bd:	00 
  8019be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019cf:	48 89 c2             	mov    %rax,%rdx
  8019d2:	be 01 00 00 00       	mov    $0x1,%esi
  8019d7:	bf 03 00 00 00       	mov    $0x3,%edi
  8019dc:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  8019e3:	00 00 00 
  8019e6:	ff d0                	callq  *%rax
}
  8019e8:	c9                   	leaveq 
  8019e9:	c3                   	retq   

00000000008019ea <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019ea:	55                   	push   %rbp
  8019eb:	48 89 e5             	mov    %rsp,%rbp
  8019ee:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019f2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f9:	00 
  8019fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a00:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a06:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a10:	be 00 00 00 00       	mov    $0x0,%esi
  801a15:	bf 02 00 00 00       	mov    $0x2,%edi
  801a1a:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801a21:	00 00 00 
  801a24:	ff d0                	callq  *%rax
}
  801a26:	c9                   	leaveq 
  801a27:	c3                   	retq   

0000000000801a28 <sys_yield>:

void
sys_yield(void)
{
  801a28:	55                   	push   %rbp
  801a29:	48 89 e5             	mov    %rsp,%rbp
  801a2c:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a30:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a37:	00 
  801a38:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a44:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a49:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4e:	be 00 00 00 00       	mov    $0x0,%esi
  801a53:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a58:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801a5f:	00 00 00 
  801a62:	ff d0                	callq  *%rax
}
  801a64:	c9                   	leaveq 
  801a65:	c3                   	retq   

0000000000801a66 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a66:	55                   	push   %rbp
  801a67:	48 89 e5             	mov    %rsp,%rbp
  801a6a:	48 83 ec 20          	sub    $0x20,%rsp
  801a6e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a71:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a75:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a7b:	48 63 c8             	movslq %eax,%rcx
  801a7e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a85:	48 98                	cltq   
  801a87:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8e:	00 
  801a8f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a95:	49 89 c8             	mov    %rcx,%r8
  801a98:	48 89 d1             	mov    %rdx,%rcx
  801a9b:	48 89 c2             	mov    %rax,%rdx
  801a9e:	be 01 00 00 00       	mov    $0x1,%esi
  801aa3:	bf 04 00 00 00       	mov    $0x4,%edi
  801aa8:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801aaf:	00 00 00 
  801ab2:	ff d0                	callq  *%rax
}
  801ab4:	c9                   	leaveq 
  801ab5:	c3                   	retq   

0000000000801ab6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ab6:	55                   	push   %rbp
  801ab7:	48 89 e5             	mov    %rsp,%rbp
  801aba:	48 83 ec 30          	sub    $0x30,%rsp
  801abe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ac5:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ac8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801acc:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ad0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ad3:	48 63 c8             	movslq %eax,%rcx
  801ad6:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ada:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801add:	48 63 f0             	movslq %eax,%rsi
  801ae0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae7:	48 98                	cltq   
  801ae9:	48 89 0c 24          	mov    %rcx,(%rsp)
  801aed:	49 89 f9             	mov    %rdi,%r9
  801af0:	49 89 f0             	mov    %rsi,%r8
  801af3:	48 89 d1             	mov    %rdx,%rcx
  801af6:	48 89 c2             	mov    %rax,%rdx
  801af9:	be 01 00 00 00       	mov    $0x1,%esi
  801afe:	bf 05 00 00 00       	mov    $0x5,%edi
  801b03:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801b0a:	00 00 00 
  801b0d:	ff d0                	callq  *%rax
}
  801b0f:	c9                   	leaveq 
  801b10:	c3                   	retq   

0000000000801b11 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b11:	55                   	push   %rbp
  801b12:	48 89 e5             	mov    %rsp,%rbp
  801b15:	48 83 ec 20          	sub    $0x20,%rsp
  801b19:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b27:	48 98                	cltq   
  801b29:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b30:	00 
  801b31:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b37:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b3d:	48 89 d1             	mov    %rdx,%rcx
  801b40:	48 89 c2             	mov    %rax,%rdx
  801b43:	be 01 00 00 00       	mov    $0x1,%esi
  801b48:	bf 06 00 00 00       	mov    $0x6,%edi
  801b4d:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801b54:	00 00 00 
  801b57:	ff d0                	callq  *%rax
}
  801b59:	c9                   	leaveq 
  801b5a:	c3                   	retq   

0000000000801b5b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b5b:	55                   	push   %rbp
  801b5c:	48 89 e5             	mov    %rsp,%rbp
  801b5f:	48 83 ec 10          	sub    $0x10,%rsp
  801b63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b66:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b69:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b6c:	48 63 d0             	movslq %eax,%rdx
  801b6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b72:	48 98                	cltq   
  801b74:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b7b:	00 
  801b7c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b82:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b88:	48 89 d1             	mov    %rdx,%rcx
  801b8b:	48 89 c2             	mov    %rax,%rdx
  801b8e:	be 01 00 00 00       	mov    $0x1,%esi
  801b93:	bf 08 00 00 00       	mov    $0x8,%edi
  801b98:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801b9f:	00 00 00 
  801ba2:	ff d0                	callq  *%rax
}
  801ba4:	c9                   	leaveq 
  801ba5:	c3                   	retq   

0000000000801ba6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ba6:	55                   	push   %rbp
  801ba7:	48 89 e5             	mov    %rsp,%rbp
  801baa:	48 83 ec 20          	sub    $0x20,%rsp
  801bae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bb5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bbc:	48 98                	cltq   
  801bbe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc5:	00 
  801bc6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bcc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd2:	48 89 d1             	mov    %rdx,%rcx
  801bd5:	48 89 c2             	mov    %rax,%rdx
  801bd8:	be 01 00 00 00       	mov    $0x1,%esi
  801bdd:	bf 09 00 00 00       	mov    $0x9,%edi
  801be2:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801be9:	00 00 00 
  801bec:	ff d0                	callq  *%rax
}
  801bee:	c9                   	leaveq 
  801bef:	c3                   	retq   

0000000000801bf0 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bf0:	55                   	push   %rbp
  801bf1:	48 89 e5             	mov    %rsp,%rbp
  801bf4:	48 83 ec 20          	sub    $0x20,%rsp
  801bf8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c06:	48 98                	cltq   
  801c08:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0f:	00 
  801c10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1c:	48 89 d1             	mov    %rdx,%rcx
  801c1f:	48 89 c2             	mov    %rax,%rdx
  801c22:	be 01 00 00 00       	mov    $0x1,%esi
  801c27:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c2c:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801c33:	00 00 00 
  801c36:	ff d0                	callq  *%rax
}
  801c38:	c9                   	leaveq 
  801c39:	c3                   	retq   

0000000000801c3a <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801c3a:	55                   	push   %rbp
  801c3b:	48 89 e5             	mov    %rsp,%rbp
  801c3e:	48 83 ec 10          	sub    $0x10,%rsp
  801c42:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c45:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801c48:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c4b:	48 63 d0             	movslq %eax,%rdx
  801c4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c51:	48 98                	cltq   
  801c53:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c5a:	00 
  801c5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c67:	48 89 d1             	mov    %rdx,%rcx
  801c6a:	48 89 c2             	mov    %rax,%rdx
  801c6d:	be 01 00 00 00       	mov    $0x1,%esi
  801c72:	bf 11 00 00 00       	mov    $0x11,%edi
  801c77:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801c7e:	00 00 00 
  801c81:	ff d0                	callq  *%rax

}
  801c83:	c9                   	leaveq 
  801c84:	c3                   	retq   

0000000000801c85 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c85:	55                   	push   %rbp
  801c86:	48 89 e5             	mov    %rsp,%rbp
  801c89:	48 83 ec 20          	sub    $0x20,%rsp
  801c8d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c90:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c94:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c98:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c9b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c9e:	48 63 f0             	movslq %eax,%rsi
  801ca1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ca5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca8:	48 98                	cltq   
  801caa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb5:	00 
  801cb6:	49 89 f1             	mov    %rsi,%r9
  801cb9:	49 89 c8             	mov    %rcx,%r8
  801cbc:	48 89 d1             	mov    %rdx,%rcx
  801cbf:	48 89 c2             	mov    %rax,%rdx
  801cc2:	be 00 00 00 00       	mov    $0x0,%esi
  801cc7:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ccc:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801cd3:	00 00 00 
  801cd6:	ff d0                	callq  *%rax
}
  801cd8:	c9                   	leaveq 
  801cd9:	c3                   	retq   

0000000000801cda <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801cda:	55                   	push   %rbp
  801cdb:	48 89 e5             	mov    %rsp,%rbp
  801cde:	48 83 ec 10          	sub    $0x10,%rsp
  801ce2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ce6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf1:	00 
  801cf2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d03:	48 89 c2             	mov    %rax,%rdx
  801d06:	be 01 00 00 00       	mov    $0x1,%esi
  801d0b:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d10:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801d17:	00 00 00 
  801d1a:	ff d0                	callq  *%rax
}
  801d1c:	c9                   	leaveq 
  801d1d:	c3                   	retq   

0000000000801d1e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d1e:	55                   	push   %rbp
  801d1f:	48 89 e5             	mov    %rsp,%rbp
  801d22:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d26:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d2d:	00 
  801d2e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d34:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d3a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d44:	be 00 00 00 00       	mov    $0x0,%esi
  801d49:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d4e:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801d55:	00 00 00 
  801d58:	ff d0                	callq  *%rax
}
  801d5a:	c9                   	leaveq 
  801d5b:	c3                   	retq   

0000000000801d5c <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d5c:	55                   	push   %rbp
  801d5d:	48 89 e5             	mov    %rsp,%rbp
  801d60:	48 83 ec 30          	sub    $0x30,%rsp
  801d64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d6b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d6e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d72:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d76:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d79:	48 63 c8             	movslq %eax,%rcx
  801d7c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d83:	48 63 f0             	movslq %eax,%rsi
  801d86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d8d:	48 98                	cltq   
  801d8f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d93:	49 89 f9             	mov    %rdi,%r9
  801d96:	49 89 f0             	mov    %rsi,%r8
  801d99:	48 89 d1             	mov    %rdx,%rcx
  801d9c:	48 89 c2             	mov    %rax,%rdx
  801d9f:	be 00 00 00 00       	mov    $0x0,%esi
  801da4:	bf 0f 00 00 00       	mov    $0xf,%edi
  801da9:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801db0:	00 00 00 
  801db3:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801db5:	c9                   	leaveq 
  801db6:	c3                   	retq   

0000000000801db7 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801db7:	55                   	push   %rbp
  801db8:	48 89 e5             	mov    %rsp,%rbp
  801dbb:	48 83 ec 20          	sub    $0x20,%rsp
  801dbf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dc3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801dc7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dcf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dd6:	00 
  801dd7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ddd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801de3:	48 89 d1             	mov    %rdx,%rcx
  801de6:	48 89 c2             	mov    %rax,%rdx
  801de9:	be 00 00 00 00       	mov    $0x0,%esi
  801dee:	bf 10 00 00 00       	mov    $0x10,%edi
  801df3:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  801dfa:	00 00 00 
  801dfd:	ff d0                	callq  *%rax
}
  801dff:	c9                   	leaveq 
  801e00:	c3                   	retq   

0000000000801e01 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e01:	55                   	push   %rbp
  801e02:	48 89 e5             	mov    %rsp,%rbp
  801e05:	48 83 ec 08          	sub    $0x8,%rsp
  801e09:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e0d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e11:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e18:	ff ff ff 
  801e1b:	48 01 d0             	add    %rdx,%rax
  801e1e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e22:	c9                   	leaveq 
  801e23:	c3                   	retq   

0000000000801e24 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e24:	55                   	push   %rbp
  801e25:	48 89 e5             	mov    %rsp,%rbp
  801e28:	48 83 ec 08          	sub    $0x8,%rsp
  801e2c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e34:	48 89 c7             	mov    %rax,%rdi
  801e37:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  801e3e:	00 00 00 
  801e41:	ff d0                	callq  *%rax
  801e43:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e49:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e4d:	c9                   	leaveq 
  801e4e:	c3                   	retq   

0000000000801e4f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e4f:	55                   	push   %rbp
  801e50:	48 89 e5             	mov    %rsp,%rbp
  801e53:	48 83 ec 18          	sub    $0x18,%rsp
  801e57:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e62:	eb 6b                	jmp    801ecf <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e67:	48 98                	cltq   
  801e69:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e6f:	48 c1 e0 0c          	shl    $0xc,%rax
  801e73:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e7b:	48 c1 e8 15          	shr    $0x15,%rax
  801e7f:	48 89 c2             	mov    %rax,%rdx
  801e82:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e89:	01 00 00 
  801e8c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e90:	83 e0 01             	and    $0x1,%eax
  801e93:	48 85 c0             	test   %rax,%rax
  801e96:	74 21                	je     801eb9 <fd_alloc+0x6a>
  801e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e9c:	48 c1 e8 0c          	shr    $0xc,%rax
  801ea0:	48 89 c2             	mov    %rax,%rdx
  801ea3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eaa:	01 00 00 
  801ead:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eb1:	83 e0 01             	and    $0x1,%eax
  801eb4:	48 85 c0             	test   %rax,%rax
  801eb7:	75 12                	jne    801ecb <fd_alloc+0x7c>
			*fd_store = fd;
  801eb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ebd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ec1:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ec4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec9:	eb 1a                	jmp    801ee5 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ecb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ecf:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ed3:	7e 8f                	jle    801e64 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ed5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ee0:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ee5:	c9                   	leaveq 
  801ee6:	c3                   	retq   

0000000000801ee7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ee7:	55                   	push   %rbp
  801ee8:	48 89 e5             	mov    %rsp,%rbp
  801eeb:	48 83 ec 20          	sub    $0x20,%rsp
  801eef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ef2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ef6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801efa:	78 06                	js     801f02 <fd_lookup+0x1b>
  801efc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f00:	7e 07                	jle    801f09 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f07:	eb 6c                	jmp    801f75 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f09:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f0c:	48 98                	cltq   
  801f0e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f14:	48 c1 e0 0c          	shl    $0xc,%rax
  801f18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f20:	48 c1 e8 15          	shr    $0x15,%rax
  801f24:	48 89 c2             	mov    %rax,%rdx
  801f27:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f2e:	01 00 00 
  801f31:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f35:	83 e0 01             	and    $0x1,%eax
  801f38:	48 85 c0             	test   %rax,%rax
  801f3b:	74 21                	je     801f5e <fd_lookup+0x77>
  801f3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f41:	48 c1 e8 0c          	shr    $0xc,%rax
  801f45:	48 89 c2             	mov    %rax,%rdx
  801f48:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f4f:	01 00 00 
  801f52:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f56:	83 e0 01             	and    $0x1,%eax
  801f59:	48 85 c0             	test   %rax,%rax
  801f5c:	75 07                	jne    801f65 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f63:	eb 10                	jmp    801f75 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f65:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f69:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f6d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f75:	c9                   	leaveq 
  801f76:	c3                   	retq   

0000000000801f77 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f77:	55                   	push   %rbp
  801f78:	48 89 e5             	mov    %rsp,%rbp
  801f7b:	48 83 ec 30          	sub    $0x30,%rsp
  801f7f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f83:	89 f0                	mov    %esi,%eax
  801f85:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f8c:	48 89 c7             	mov    %rax,%rdi
  801f8f:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  801f96:	00 00 00 
  801f99:	ff d0                	callq  *%rax
  801f9b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f9f:	48 89 d6             	mov    %rdx,%rsi
  801fa2:	89 c7                	mov    %eax,%edi
  801fa4:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  801fab:	00 00 00 
  801fae:	ff d0                	callq  *%rax
  801fb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fb7:	78 0a                	js     801fc3 <fd_close+0x4c>
	    || fd != fd2)
  801fb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fbd:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801fc1:	74 12                	je     801fd5 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801fc3:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801fc7:	74 05                	je     801fce <fd_close+0x57>
  801fc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fcc:	eb 05                	jmp    801fd3 <fd_close+0x5c>
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd3:	eb 69                	jmp    80203e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fd5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd9:	8b 00                	mov    (%rax),%eax
  801fdb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fdf:	48 89 d6             	mov    %rdx,%rsi
  801fe2:	89 c7                	mov    %eax,%edi
  801fe4:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  801feb:	00 00 00 
  801fee:	ff d0                	callq  *%rax
  801ff0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ff3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ff7:	78 2a                	js     802023 <fd_close+0xac>
		if (dev->dev_close)
  801ff9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ffd:	48 8b 40 20          	mov    0x20(%rax),%rax
  802001:	48 85 c0             	test   %rax,%rax
  802004:	74 16                	je     80201c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802006:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80200a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80200e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802012:	48 89 d7             	mov    %rdx,%rdi
  802015:	ff d0                	callq  *%rax
  802017:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80201a:	eb 07                	jmp    802023 <fd_close+0xac>
		else
			r = 0;
  80201c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802023:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802027:	48 89 c6             	mov    %rax,%rsi
  80202a:	bf 00 00 00 00       	mov    $0x0,%edi
  80202f:	48 b8 11 1b 80 00 00 	movabs $0x801b11,%rax
  802036:	00 00 00 
  802039:	ff d0                	callq  *%rax
	return r;
  80203b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80203e:	c9                   	leaveq 
  80203f:	c3                   	retq   

0000000000802040 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802040:	55                   	push   %rbp
  802041:	48 89 e5             	mov    %rsp,%rbp
  802044:	48 83 ec 20          	sub    $0x20,%rsp
  802048:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80204b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80204f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802056:	eb 41                	jmp    802099 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802058:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80205f:	00 00 00 
  802062:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802065:	48 63 d2             	movslq %edx,%rdx
  802068:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80206c:	8b 00                	mov    (%rax),%eax
  80206e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802071:	75 22                	jne    802095 <dev_lookup+0x55>
			*dev = devtab[i];
  802073:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80207a:	00 00 00 
  80207d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802080:	48 63 d2             	movslq %edx,%rdx
  802083:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80208b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
  802093:	eb 60                	jmp    8020f5 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802095:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802099:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020a0:	00 00 00 
  8020a3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020a6:	48 63 d2             	movslq %edx,%rdx
  8020a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ad:	48 85 c0             	test   %rax,%rax
  8020b0:	75 a6                	jne    802058 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8020b2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020b9:	00 00 00 
  8020bc:	48 8b 00             	mov    (%rax),%rax
  8020bf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020c5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020c8:	89 c6                	mov    %eax,%esi
  8020ca:	48 bf 78 4a 80 00 00 	movabs $0x804a78,%rdi
  8020d1:	00 00 00 
  8020d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d9:	48 b9 41 05 80 00 00 	movabs $0x800541,%rcx
  8020e0:	00 00 00 
  8020e3:	ff d1                	callq  *%rcx
	*dev = 0;
  8020e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020e9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020f5:	c9                   	leaveq 
  8020f6:	c3                   	retq   

00000000008020f7 <close>:

int
close(int fdnum)
{
  8020f7:	55                   	push   %rbp
  8020f8:	48 89 e5             	mov    %rsp,%rbp
  8020fb:	48 83 ec 20          	sub    $0x20,%rsp
  8020ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802102:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802106:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802109:	48 89 d6             	mov    %rdx,%rsi
  80210c:	89 c7                	mov    %eax,%edi
  80210e:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  802115:	00 00 00 
  802118:	ff d0                	callq  *%rax
  80211a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80211d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802121:	79 05                	jns    802128 <close+0x31>
		return r;
  802123:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802126:	eb 18                	jmp    802140 <close+0x49>
	else
		return fd_close(fd, 1);
  802128:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80212c:	be 01 00 00 00       	mov    $0x1,%esi
  802131:	48 89 c7             	mov    %rax,%rdi
  802134:	48 b8 77 1f 80 00 00 	movabs $0x801f77,%rax
  80213b:	00 00 00 
  80213e:	ff d0                	callq  *%rax
}
  802140:	c9                   	leaveq 
  802141:	c3                   	retq   

0000000000802142 <close_all>:

void
close_all(void)
{
  802142:	55                   	push   %rbp
  802143:	48 89 e5             	mov    %rsp,%rbp
  802146:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80214a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802151:	eb 15                	jmp    802168 <close_all+0x26>
		close(i);
  802153:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802156:	89 c7                	mov    %eax,%edi
  802158:	48 b8 f7 20 80 00 00 	movabs $0x8020f7,%rax
  80215f:	00 00 00 
  802162:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802164:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802168:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80216c:	7e e5                	jle    802153 <close_all+0x11>
		close(i);
}
  80216e:	c9                   	leaveq 
  80216f:	c3                   	retq   

0000000000802170 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802170:	55                   	push   %rbp
  802171:	48 89 e5             	mov    %rsp,%rbp
  802174:	48 83 ec 40          	sub    $0x40,%rsp
  802178:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80217b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80217e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802182:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802185:	48 89 d6             	mov    %rdx,%rsi
  802188:	89 c7                	mov    %eax,%edi
  80218a:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  802191:	00 00 00 
  802194:	ff d0                	callq  *%rax
  802196:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802199:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219d:	79 08                	jns    8021a7 <dup+0x37>
		return r;
  80219f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a2:	e9 70 01 00 00       	jmpq   802317 <dup+0x1a7>
	close(newfdnum);
  8021a7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021aa:	89 c7                	mov    %eax,%edi
  8021ac:	48 b8 f7 20 80 00 00 	movabs $0x8020f7,%rax
  8021b3:	00 00 00 
  8021b6:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8021b8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021bb:	48 98                	cltq   
  8021bd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021c3:	48 c1 e0 0c          	shl    $0xc,%rax
  8021c7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8021cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021cf:	48 89 c7             	mov    %rax,%rdi
  8021d2:	48 b8 24 1e 80 00 00 	movabs $0x801e24,%rax
  8021d9:	00 00 00 
  8021dc:	ff d0                	callq  *%rax
  8021de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e6:	48 89 c7             	mov    %rax,%rdi
  8021e9:	48 b8 24 1e 80 00 00 	movabs $0x801e24,%rax
  8021f0:	00 00 00 
  8021f3:	ff d0                	callq  *%rax
  8021f5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fd:	48 c1 e8 15          	shr    $0x15,%rax
  802201:	48 89 c2             	mov    %rax,%rdx
  802204:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80220b:	01 00 00 
  80220e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802212:	83 e0 01             	and    $0x1,%eax
  802215:	48 85 c0             	test   %rax,%rax
  802218:	74 73                	je     80228d <dup+0x11d>
  80221a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221e:	48 c1 e8 0c          	shr    $0xc,%rax
  802222:	48 89 c2             	mov    %rax,%rdx
  802225:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80222c:	01 00 00 
  80222f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802233:	83 e0 01             	and    $0x1,%eax
  802236:	48 85 c0             	test   %rax,%rax
  802239:	74 52                	je     80228d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80223b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223f:	48 c1 e8 0c          	shr    $0xc,%rax
  802243:	48 89 c2             	mov    %rax,%rdx
  802246:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80224d:	01 00 00 
  802250:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802254:	25 07 0e 00 00       	and    $0xe07,%eax
  802259:	89 c1                	mov    %eax,%ecx
  80225b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80225f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802263:	41 89 c8             	mov    %ecx,%r8d
  802266:	48 89 d1             	mov    %rdx,%rcx
  802269:	ba 00 00 00 00       	mov    $0x0,%edx
  80226e:	48 89 c6             	mov    %rax,%rsi
  802271:	bf 00 00 00 00       	mov    $0x0,%edi
  802276:	48 b8 b6 1a 80 00 00 	movabs $0x801ab6,%rax
  80227d:	00 00 00 
  802280:	ff d0                	callq  *%rax
  802282:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802285:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802289:	79 02                	jns    80228d <dup+0x11d>
			goto err;
  80228b:	eb 57                	jmp    8022e4 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80228d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802291:	48 c1 e8 0c          	shr    $0xc,%rax
  802295:	48 89 c2             	mov    %rax,%rdx
  802298:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80229f:	01 00 00 
  8022a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a6:	25 07 0e 00 00       	and    $0xe07,%eax
  8022ab:	89 c1                	mov    %eax,%ecx
  8022ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022b5:	41 89 c8             	mov    %ecx,%r8d
  8022b8:	48 89 d1             	mov    %rdx,%rcx
  8022bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8022c0:	48 89 c6             	mov    %rax,%rsi
  8022c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c8:	48 b8 b6 1a 80 00 00 	movabs $0x801ab6,%rax
  8022cf:	00 00 00 
  8022d2:	ff d0                	callq  *%rax
  8022d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022db:	79 02                	jns    8022df <dup+0x16f>
		goto err;
  8022dd:	eb 05                	jmp    8022e4 <dup+0x174>

	return newfdnum;
  8022df:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022e2:	eb 33                	jmp    802317 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8022e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e8:	48 89 c6             	mov    %rax,%rsi
  8022eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f0:	48 b8 11 1b 80 00 00 	movabs $0x801b11,%rax
  8022f7:	00 00 00 
  8022fa:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802300:	48 89 c6             	mov    %rax,%rsi
  802303:	bf 00 00 00 00       	mov    $0x0,%edi
  802308:	48 b8 11 1b 80 00 00 	movabs $0x801b11,%rax
  80230f:	00 00 00 
  802312:	ff d0                	callq  *%rax
	return r;
  802314:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802317:	c9                   	leaveq 
  802318:	c3                   	retq   

0000000000802319 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802319:	55                   	push   %rbp
  80231a:	48 89 e5             	mov    %rsp,%rbp
  80231d:	48 83 ec 40          	sub    $0x40,%rsp
  802321:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802324:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802328:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80232c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802330:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802333:	48 89 d6             	mov    %rdx,%rsi
  802336:	89 c7                	mov    %eax,%edi
  802338:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  80233f:	00 00 00 
  802342:	ff d0                	callq  *%rax
  802344:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802347:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80234b:	78 24                	js     802371 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80234d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802351:	8b 00                	mov    (%rax),%eax
  802353:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802357:	48 89 d6             	mov    %rdx,%rsi
  80235a:	89 c7                	mov    %eax,%edi
  80235c:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  802363:	00 00 00 
  802366:	ff d0                	callq  *%rax
  802368:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80236b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80236f:	79 05                	jns    802376 <read+0x5d>
		return r;
  802371:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802374:	eb 76                	jmp    8023ec <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802376:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237a:	8b 40 08             	mov    0x8(%rax),%eax
  80237d:	83 e0 03             	and    $0x3,%eax
  802380:	83 f8 01             	cmp    $0x1,%eax
  802383:	75 3a                	jne    8023bf <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802385:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80238c:	00 00 00 
  80238f:	48 8b 00             	mov    (%rax),%rax
  802392:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802398:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80239b:	89 c6                	mov    %eax,%esi
  80239d:	48 bf 97 4a 80 00 00 	movabs $0x804a97,%rdi
  8023a4:	00 00 00 
  8023a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ac:	48 b9 41 05 80 00 00 	movabs $0x800541,%rcx
  8023b3:	00 00 00 
  8023b6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023bd:	eb 2d                	jmp    8023ec <read+0xd3>
	}
	if (!dev->dev_read)
  8023bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023c3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023c7:	48 85 c0             	test   %rax,%rax
  8023ca:	75 07                	jne    8023d3 <read+0xba>
		return -E_NOT_SUPP;
  8023cc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023d1:	eb 19                	jmp    8023ec <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8023d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023db:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023df:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023e3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023e7:	48 89 cf             	mov    %rcx,%rdi
  8023ea:	ff d0                	callq  *%rax
}
  8023ec:	c9                   	leaveq 
  8023ed:	c3                   	retq   

00000000008023ee <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023ee:	55                   	push   %rbp
  8023ef:	48 89 e5             	mov    %rsp,%rbp
  8023f2:	48 83 ec 30          	sub    $0x30,%rsp
  8023f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802401:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802408:	eb 49                	jmp    802453 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80240a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80240d:	48 98                	cltq   
  80240f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802413:	48 29 c2             	sub    %rax,%rdx
  802416:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802419:	48 63 c8             	movslq %eax,%rcx
  80241c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802420:	48 01 c1             	add    %rax,%rcx
  802423:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802426:	48 89 ce             	mov    %rcx,%rsi
  802429:	89 c7                	mov    %eax,%edi
  80242b:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  802432:	00 00 00 
  802435:	ff d0                	callq  *%rax
  802437:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80243a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80243e:	79 05                	jns    802445 <readn+0x57>
			return m;
  802440:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802443:	eb 1c                	jmp    802461 <readn+0x73>
		if (m == 0)
  802445:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802449:	75 02                	jne    80244d <readn+0x5f>
			break;
  80244b:	eb 11                	jmp    80245e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80244d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802450:	01 45 fc             	add    %eax,-0x4(%rbp)
  802453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802456:	48 98                	cltq   
  802458:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80245c:	72 ac                	jb     80240a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80245e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802461:	c9                   	leaveq 
  802462:	c3                   	retq   

0000000000802463 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802463:	55                   	push   %rbp
  802464:	48 89 e5             	mov    %rsp,%rbp
  802467:	48 83 ec 40          	sub    $0x40,%rsp
  80246b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80246e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802472:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802476:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80247a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80247d:	48 89 d6             	mov    %rdx,%rsi
  802480:	89 c7                	mov    %eax,%edi
  802482:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  802489:	00 00 00 
  80248c:	ff d0                	callq  *%rax
  80248e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802491:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802495:	78 24                	js     8024bb <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802497:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80249b:	8b 00                	mov    (%rax),%eax
  80249d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a1:	48 89 d6             	mov    %rdx,%rsi
  8024a4:	89 c7                	mov    %eax,%edi
  8024a6:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  8024ad:	00 00 00 
  8024b0:	ff d0                	callq  *%rax
  8024b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b9:	79 05                	jns    8024c0 <write+0x5d>
		return r;
  8024bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024be:	eb 75                	jmp    802535 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c4:	8b 40 08             	mov    0x8(%rax),%eax
  8024c7:	83 e0 03             	and    $0x3,%eax
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	75 3a                	jne    802508 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8024ce:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024d5:	00 00 00 
  8024d8:	48 8b 00             	mov    (%rax),%rax
  8024db:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024e1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024e4:	89 c6                	mov    %eax,%esi
  8024e6:	48 bf b3 4a 80 00 00 	movabs $0x804ab3,%rdi
  8024ed:	00 00 00 
  8024f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f5:	48 b9 41 05 80 00 00 	movabs $0x800541,%rcx
  8024fc:	00 00 00 
  8024ff:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802501:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802506:	eb 2d                	jmp    802535 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802508:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802510:	48 85 c0             	test   %rax,%rax
  802513:	75 07                	jne    80251c <write+0xb9>
		return -E_NOT_SUPP;
  802515:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80251a:	eb 19                	jmp    802535 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80251c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802520:	48 8b 40 18          	mov    0x18(%rax),%rax
  802524:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802528:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80252c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802530:	48 89 cf             	mov    %rcx,%rdi
  802533:	ff d0                	callq  *%rax
}
  802535:	c9                   	leaveq 
  802536:	c3                   	retq   

0000000000802537 <seek>:

int
seek(int fdnum, off_t offset)
{
  802537:	55                   	push   %rbp
  802538:	48 89 e5             	mov    %rsp,%rbp
  80253b:	48 83 ec 18          	sub    $0x18,%rsp
  80253f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802542:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802545:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802549:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80254c:	48 89 d6             	mov    %rdx,%rsi
  80254f:	89 c7                	mov    %eax,%edi
  802551:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  802558:	00 00 00 
  80255b:	ff d0                	callq  *%rax
  80255d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802560:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802564:	79 05                	jns    80256b <seek+0x34>
		return r;
  802566:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802569:	eb 0f                	jmp    80257a <seek+0x43>
	fd->fd_offset = offset;
  80256b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80256f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802572:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802575:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80257a:	c9                   	leaveq 
  80257b:	c3                   	retq   

000000000080257c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80257c:	55                   	push   %rbp
  80257d:	48 89 e5             	mov    %rsp,%rbp
  802580:	48 83 ec 30          	sub    $0x30,%rsp
  802584:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802587:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80258a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80258e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802591:	48 89 d6             	mov    %rdx,%rsi
  802594:	89 c7                	mov    %eax,%edi
  802596:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  80259d:	00 00 00 
  8025a0:	ff d0                	callq  *%rax
  8025a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a9:	78 24                	js     8025cf <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025af:	8b 00                	mov    (%rax),%eax
  8025b1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025b5:	48 89 d6             	mov    %rdx,%rsi
  8025b8:	89 c7                	mov    %eax,%edi
  8025ba:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  8025c1:	00 00 00 
  8025c4:	ff d0                	callq  *%rax
  8025c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025cd:	79 05                	jns    8025d4 <ftruncate+0x58>
		return r;
  8025cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d2:	eb 72                	jmp    802646 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d8:	8b 40 08             	mov    0x8(%rax),%eax
  8025db:	83 e0 03             	and    $0x3,%eax
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	75 3a                	jne    80261c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025e2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025e9:	00 00 00 
  8025ec:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025ef:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025f5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025f8:	89 c6                	mov    %eax,%esi
  8025fa:	48 bf d0 4a 80 00 00 	movabs $0x804ad0,%rdi
  802601:	00 00 00 
  802604:	b8 00 00 00 00       	mov    $0x0,%eax
  802609:	48 b9 41 05 80 00 00 	movabs $0x800541,%rcx
  802610:	00 00 00 
  802613:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802615:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80261a:	eb 2a                	jmp    802646 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80261c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802620:	48 8b 40 30          	mov    0x30(%rax),%rax
  802624:	48 85 c0             	test   %rax,%rax
  802627:	75 07                	jne    802630 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802629:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80262e:	eb 16                	jmp    802646 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802630:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802634:	48 8b 40 30          	mov    0x30(%rax),%rax
  802638:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80263c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80263f:	89 ce                	mov    %ecx,%esi
  802641:	48 89 d7             	mov    %rdx,%rdi
  802644:	ff d0                	callq  *%rax
}
  802646:	c9                   	leaveq 
  802647:	c3                   	retq   

0000000000802648 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802648:	55                   	push   %rbp
  802649:	48 89 e5             	mov    %rsp,%rbp
  80264c:	48 83 ec 30          	sub    $0x30,%rsp
  802650:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802653:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802657:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80265b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80265e:	48 89 d6             	mov    %rdx,%rsi
  802661:	89 c7                	mov    %eax,%edi
  802663:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  80266a:	00 00 00 
  80266d:	ff d0                	callq  *%rax
  80266f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802672:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802676:	78 24                	js     80269c <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267c:	8b 00                	mov    (%rax),%eax
  80267e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802682:	48 89 d6             	mov    %rdx,%rsi
  802685:	89 c7                	mov    %eax,%edi
  802687:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  80268e:	00 00 00 
  802691:	ff d0                	callq  *%rax
  802693:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802696:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269a:	79 05                	jns    8026a1 <fstat+0x59>
		return r;
  80269c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269f:	eb 5e                	jmp    8026ff <fstat+0xb7>
	if (!dev->dev_stat)
  8026a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a5:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026a9:	48 85 c0             	test   %rax,%rax
  8026ac:	75 07                	jne    8026b5 <fstat+0x6d>
		return -E_NOT_SUPP;
  8026ae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026b3:	eb 4a                	jmp    8026ff <fstat+0xb7>
	stat->st_name[0] = 0;
  8026b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026b9:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8026bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026c0:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8026c7:	00 00 00 
	stat->st_isdir = 0;
  8026ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026ce:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026d5:	00 00 00 
	stat->st_dev = dev;
  8026d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026e0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026eb:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026f3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026f7:	48 89 ce             	mov    %rcx,%rsi
  8026fa:	48 89 d7             	mov    %rdx,%rdi
  8026fd:	ff d0                	callq  *%rax
}
  8026ff:	c9                   	leaveq 
  802700:	c3                   	retq   

0000000000802701 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802701:	55                   	push   %rbp
  802702:	48 89 e5             	mov    %rsp,%rbp
  802705:	48 83 ec 20          	sub    $0x20,%rsp
  802709:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80270d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802711:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802715:	be 00 00 00 00       	mov    $0x0,%esi
  80271a:	48 89 c7             	mov    %rax,%rdi
  80271d:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  802724:	00 00 00 
  802727:	ff d0                	callq  *%rax
  802729:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80272c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802730:	79 05                	jns    802737 <stat+0x36>
		return fd;
  802732:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802735:	eb 2f                	jmp    802766 <stat+0x65>
	r = fstat(fd, stat);
  802737:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80273b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273e:	48 89 d6             	mov    %rdx,%rsi
  802741:	89 c7                	mov    %eax,%edi
  802743:	48 b8 48 26 80 00 00 	movabs $0x802648,%rax
  80274a:	00 00 00 
  80274d:	ff d0                	callq  *%rax
  80274f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802752:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802755:	89 c7                	mov    %eax,%edi
  802757:	48 b8 f7 20 80 00 00 	movabs $0x8020f7,%rax
  80275e:	00 00 00 
  802761:	ff d0                	callq  *%rax
	return r;
  802763:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802766:	c9                   	leaveq 
  802767:	c3                   	retq   

0000000000802768 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802768:	55                   	push   %rbp
  802769:	48 89 e5             	mov    %rsp,%rbp
  80276c:	48 83 ec 10          	sub    $0x10,%rsp
  802770:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802773:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802777:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80277e:	00 00 00 
  802781:	8b 00                	mov    (%rax),%eax
  802783:	85 c0                	test   %eax,%eax
  802785:	75 1d                	jne    8027a4 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802787:	bf 01 00 00 00       	mov    $0x1,%edi
  80278c:	48 b8 34 43 80 00 00 	movabs $0x804334,%rax
  802793:	00 00 00 
  802796:	ff d0                	callq  *%rax
  802798:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80279f:	00 00 00 
  8027a2:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8027a4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027ab:	00 00 00 
  8027ae:	8b 00                	mov    (%rax),%eax
  8027b0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8027b3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8027b8:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8027bf:	00 00 00 
  8027c2:	89 c7                	mov    %eax,%edi
  8027c4:	48 b8 35 42 80 00 00 	movabs $0x804235,%rax
  8027cb:	00 00 00 
  8027ce:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d9:	48 89 c6             	mov    %rax,%rsi
  8027dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e1:	48 b8 82 41 80 00 00 	movabs $0x804182,%rax
  8027e8:	00 00 00 
  8027eb:	ff d0                	callq  *%rax
}
  8027ed:	c9                   	leaveq 
  8027ee:	c3                   	retq   

00000000008027ef <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027ef:	55                   	push   %rbp
  8027f0:	48 89 e5             	mov    %rsp,%rbp
  8027f3:	48 83 ec 20          	sub    $0x20,%rsp
  8027f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027fb:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  8027fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802802:	48 89 c7             	mov    %rax,%rdi
  802805:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  80280c:	00 00 00 
  80280f:	ff d0                	callq  *%rax
  802811:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802816:	7e 0a                	jle    802822 <open+0x33>
		return -E_BAD_PATH;
  802818:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80281d:	e9 a5 00 00 00       	jmpq   8028c7 <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  802822:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802826:	48 89 c7             	mov    %rax,%rdi
  802829:	48 b8 4f 1e 80 00 00 	movabs $0x801e4f,%rax
  802830:	00 00 00 
  802833:	ff d0                	callq  *%rax
  802835:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802838:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80283c:	79 08                	jns    802846 <open+0x57>
		return ret;
  80283e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802841:	e9 81 00 00 00       	jmpq   8028c7 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802846:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80284d:	00 00 00 
  802850:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802853:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  802859:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285d:	48 89 c6             	mov    %rax,%rsi
  802860:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802867:	00 00 00 
  80286a:	48 b8 37 11 80 00 00 	movabs $0x801137,%rax
  802871:	00 00 00 
  802874:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  802876:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287a:	48 89 c6             	mov    %rax,%rsi
  80287d:	bf 01 00 00 00       	mov    $0x1,%edi
  802882:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  802889:	00 00 00 
  80288c:	ff d0                	callq  *%rax
  80288e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802891:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802895:	79 1d                	jns    8028b4 <open+0xc5>
	{
		fd_close(fd,0);
  802897:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80289b:	be 00 00 00 00       	mov    $0x0,%esi
  8028a0:	48 89 c7             	mov    %rax,%rdi
  8028a3:	48 b8 77 1f 80 00 00 	movabs $0x801f77,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
		return ret;
  8028af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b2:	eb 13                	jmp    8028c7 <open+0xd8>
	}
	return fd2num (fd);
  8028b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b8:	48 89 c7             	mov    %rax,%rdi
  8028bb:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  8028c2:	00 00 00 
  8028c5:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  8028c7:	c9                   	leaveq 
  8028c8:	c3                   	retq   

00000000008028c9 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028c9:	55                   	push   %rbp
  8028ca:	48 89 e5             	mov    %rsp,%rbp
  8028cd:	48 83 ec 10          	sub    $0x10,%rsp
  8028d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028d9:	8b 50 0c             	mov    0xc(%rax),%edx
  8028dc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028e3:	00 00 00 
  8028e6:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028e8:	be 00 00 00 00       	mov    $0x0,%esi
  8028ed:	bf 06 00 00 00       	mov    $0x6,%edi
  8028f2:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  8028f9:	00 00 00 
  8028fc:	ff d0                	callq  *%rax
}
  8028fe:	c9                   	leaveq 
  8028ff:	c3                   	retq   

0000000000802900 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802900:	55                   	push   %rbp
  802901:	48 89 e5             	mov    %rsp,%rbp
  802904:	48 83 ec 30          	sub    $0x30,%rsp
  802908:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80290c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802910:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  802914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802918:	8b 50 0c             	mov    0xc(%rax),%edx
  80291b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802922:	00 00 00 
  802925:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  802927:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80292e:	00 00 00 
  802931:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802935:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  802939:	be 00 00 00 00       	mov    $0x0,%esi
  80293e:	bf 03 00 00 00       	mov    $0x3,%edi
  802943:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  80294a:	00 00 00 
  80294d:	ff d0                	callq  *%rax
  80294f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802952:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802956:	79 05                	jns    80295d <devfile_read+0x5d>
		return ret;
  802958:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295b:	eb 26                	jmp    802983 <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  80295d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802960:	48 63 d0             	movslq %eax,%rdx
  802963:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802967:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80296e:	00 00 00 
  802971:	48 89 c7             	mov    %rax,%rdi
  802974:	48 b8 5b 14 80 00 00 	movabs $0x80145b,%rax
  80297b:	00 00 00 
  80297e:	ff d0                	callq  *%rax
	return ret;
  802980:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  802983:	c9                   	leaveq 
  802984:	c3                   	retq   

0000000000802985 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802985:	55                   	push   %rbp
  802986:	48 89 e5             	mov    %rsp,%rbp
  802989:	48 83 ec 30          	sub    $0x30,%rsp
  80298d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802991:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802995:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  802999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299d:	8b 50 0c             	mov    0xc(%rax),%edx
  8029a0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029a7:	00 00 00 
  8029aa:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  8029ac:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  8029b1:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8029b8:	00 
  8029b9:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8029be:	48 89 c2             	mov    %rax,%rdx
  8029c1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029c8:	00 00 00 
  8029cb:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8029cf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029d6:	00 00 00 
  8029d9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8029dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029e1:	48 89 c6             	mov    %rax,%rsi
  8029e4:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8029eb:	00 00 00 
  8029ee:	48 b8 5b 14 80 00 00 	movabs $0x80145b,%rax
  8029f5:	00 00 00 
  8029f8:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  8029fa:	be 00 00 00 00       	mov    $0x0,%esi
  8029ff:	bf 04 00 00 00       	mov    $0x4,%edi
  802a04:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  802a0b:	00 00 00 
  802a0e:	ff d0                	callq  *%rax
  802a10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a17:	79 05                	jns    802a1e <devfile_write+0x99>
		return ret;
  802a19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1c:	eb 03                	jmp    802a21 <devfile_write+0x9c>
	
	return ret;
  802a1e:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  802a21:	c9                   	leaveq 
  802a22:	c3                   	retq   

0000000000802a23 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a23:	55                   	push   %rbp
  802a24:	48 89 e5             	mov    %rsp,%rbp
  802a27:	48 83 ec 20          	sub    $0x20,%rsp
  802a2b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a2f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a37:	8b 50 0c             	mov    0xc(%rax),%edx
  802a3a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a41:	00 00 00 
  802a44:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a46:	be 00 00 00 00       	mov    $0x0,%esi
  802a4b:	bf 05 00 00 00       	mov    $0x5,%edi
  802a50:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  802a57:	00 00 00 
  802a5a:	ff d0                	callq  *%rax
  802a5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a63:	79 05                	jns    802a6a <devfile_stat+0x47>
		return r;
  802a65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a68:	eb 56                	jmp    802ac0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a6e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a75:	00 00 00 
  802a78:	48 89 c7             	mov    %rax,%rdi
  802a7b:	48 b8 37 11 80 00 00 	movabs $0x801137,%rax
  802a82:	00 00 00 
  802a85:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a87:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a8e:	00 00 00 
  802a91:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a9b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802aa1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aa8:	00 00 00 
  802aab:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ab1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ab5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802abb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ac0:	c9                   	leaveq 
  802ac1:	c3                   	retq   

0000000000802ac2 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ac2:	55                   	push   %rbp
  802ac3:	48 89 e5             	mov    %rsp,%rbp
  802ac6:	48 83 ec 10          	sub    $0x10,%rsp
  802aca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ace:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ad1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ad5:	8b 50 0c             	mov    0xc(%rax),%edx
  802ad8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802adf:	00 00 00 
  802ae2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ae4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aeb:	00 00 00 
  802aee:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802af1:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802af4:	be 00 00 00 00       	mov    $0x0,%esi
  802af9:	bf 02 00 00 00       	mov    $0x2,%edi
  802afe:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  802b05:	00 00 00 
  802b08:	ff d0                	callq  *%rax
}
  802b0a:	c9                   	leaveq 
  802b0b:	c3                   	retq   

0000000000802b0c <remove>:

// Delete a file
int
remove(const char *path)
{
  802b0c:	55                   	push   %rbp
  802b0d:	48 89 e5             	mov    %rsp,%rbp
  802b10:	48 83 ec 10          	sub    $0x10,%rsp
  802b14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b1c:	48 89 c7             	mov    %rax,%rdi
  802b1f:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  802b26:	00 00 00 
  802b29:	ff d0                	callq  *%rax
  802b2b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b30:	7e 07                	jle    802b39 <remove+0x2d>
		return -E_BAD_PATH;
  802b32:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b37:	eb 33                	jmp    802b6c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b3d:	48 89 c6             	mov    %rax,%rsi
  802b40:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b47:	00 00 00 
  802b4a:	48 b8 37 11 80 00 00 	movabs $0x801137,%rax
  802b51:	00 00 00 
  802b54:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b56:	be 00 00 00 00       	mov    $0x0,%esi
  802b5b:	bf 07 00 00 00       	mov    $0x7,%edi
  802b60:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  802b67:	00 00 00 
  802b6a:	ff d0                	callq  *%rax
}
  802b6c:	c9                   	leaveq 
  802b6d:	c3                   	retq   

0000000000802b6e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b6e:	55                   	push   %rbp
  802b6f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b72:	be 00 00 00 00       	mov    $0x0,%esi
  802b77:	bf 08 00 00 00       	mov    $0x8,%edi
  802b7c:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  802b83:	00 00 00 
  802b86:	ff d0                	callq  *%rax
}
  802b88:	5d                   	pop    %rbp
  802b89:	c3                   	retq   

0000000000802b8a <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b8a:	55                   	push   %rbp
  802b8b:	48 89 e5             	mov    %rsp,%rbp
  802b8e:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b95:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b9c:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802ba3:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802baa:	be 00 00 00 00       	mov    $0x0,%esi
  802baf:	48 89 c7             	mov    %rax,%rdi
  802bb2:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  802bb9:	00 00 00 
  802bbc:	ff d0                	callq  *%rax
  802bbe:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802bc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc5:	79 28                	jns    802bef <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802bc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bca:	89 c6                	mov    %eax,%esi
  802bcc:	48 bf f6 4a 80 00 00 	movabs $0x804af6,%rdi
  802bd3:	00 00 00 
  802bd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bdb:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  802be2:	00 00 00 
  802be5:	ff d2                	callq  *%rdx
		return fd_src;
  802be7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bea:	e9 74 01 00 00       	jmpq   802d63 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802bef:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802bf6:	be 01 01 00 00       	mov    $0x101,%esi
  802bfb:	48 89 c7             	mov    %rax,%rdi
  802bfe:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  802c05:	00 00 00 
  802c08:	ff d0                	callq  *%rax
  802c0a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c0d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c11:	79 39                	jns    802c4c <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802c13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c16:	89 c6                	mov    %eax,%esi
  802c18:	48 bf 0c 4b 80 00 00 	movabs $0x804b0c,%rdi
  802c1f:	00 00 00 
  802c22:	b8 00 00 00 00       	mov    $0x0,%eax
  802c27:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  802c2e:	00 00 00 
  802c31:	ff d2                	callq  *%rdx
		close(fd_src);
  802c33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c36:	89 c7                	mov    %eax,%edi
  802c38:	48 b8 f7 20 80 00 00 	movabs $0x8020f7,%rax
  802c3f:	00 00 00 
  802c42:	ff d0                	callq  *%rax
		return fd_dest;
  802c44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c47:	e9 17 01 00 00       	jmpq   802d63 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c4c:	eb 74                	jmp    802cc2 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c4e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c51:	48 63 d0             	movslq %eax,%rdx
  802c54:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c5e:	48 89 ce             	mov    %rcx,%rsi
  802c61:	89 c7                	mov    %eax,%edi
  802c63:	48 b8 63 24 80 00 00 	movabs $0x802463,%rax
  802c6a:	00 00 00 
  802c6d:	ff d0                	callq  *%rax
  802c6f:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c72:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c76:	79 4a                	jns    802cc2 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c78:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c7b:	89 c6                	mov    %eax,%esi
  802c7d:	48 bf 26 4b 80 00 00 	movabs $0x804b26,%rdi
  802c84:	00 00 00 
  802c87:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8c:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  802c93:	00 00 00 
  802c96:	ff d2                	callq  *%rdx
			close(fd_src);
  802c98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9b:	89 c7                	mov    %eax,%edi
  802c9d:	48 b8 f7 20 80 00 00 	movabs $0x8020f7,%rax
  802ca4:	00 00 00 
  802ca7:	ff d0                	callq  *%rax
			close(fd_dest);
  802ca9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cac:	89 c7                	mov    %eax,%edi
  802cae:	48 b8 f7 20 80 00 00 	movabs $0x8020f7,%rax
  802cb5:	00 00 00 
  802cb8:	ff d0                	callq  *%rax
			return write_size;
  802cba:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cbd:	e9 a1 00 00 00       	jmpq   802d63 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cc2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ccc:	ba 00 02 00 00       	mov    $0x200,%edx
  802cd1:	48 89 ce             	mov    %rcx,%rsi
  802cd4:	89 c7                	mov    %eax,%edi
  802cd6:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  802cdd:	00 00 00 
  802ce0:	ff d0                	callq  *%rax
  802ce2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ce5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ce9:	0f 8f 5f ff ff ff    	jg     802c4e <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802cef:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cf3:	79 47                	jns    802d3c <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802cf5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cf8:	89 c6                	mov    %eax,%esi
  802cfa:	48 bf 39 4b 80 00 00 	movabs $0x804b39,%rdi
  802d01:	00 00 00 
  802d04:	b8 00 00 00 00       	mov    $0x0,%eax
  802d09:	48 ba 41 05 80 00 00 	movabs $0x800541,%rdx
  802d10:	00 00 00 
  802d13:	ff d2                	callq  *%rdx
		close(fd_src);
  802d15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d18:	89 c7                	mov    %eax,%edi
  802d1a:	48 b8 f7 20 80 00 00 	movabs $0x8020f7,%rax
  802d21:	00 00 00 
  802d24:	ff d0                	callq  *%rax
		close(fd_dest);
  802d26:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d29:	89 c7                	mov    %eax,%edi
  802d2b:	48 b8 f7 20 80 00 00 	movabs $0x8020f7,%rax
  802d32:	00 00 00 
  802d35:	ff d0                	callq  *%rax
		return read_size;
  802d37:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d3a:	eb 27                	jmp    802d63 <copy+0x1d9>
	}
	close(fd_src);
  802d3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3f:	89 c7                	mov    %eax,%edi
  802d41:	48 b8 f7 20 80 00 00 	movabs $0x8020f7,%rax
  802d48:	00 00 00 
  802d4b:	ff d0                	callq  *%rax
	close(fd_dest);
  802d4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d50:	89 c7                	mov    %eax,%edi
  802d52:	48 b8 f7 20 80 00 00 	movabs $0x8020f7,%rax
  802d59:	00 00 00 
  802d5c:	ff d0                	callq  *%rax
	return 0;
  802d5e:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d63:	c9                   	leaveq 
  802d64:	c3                   	retq   

0000000000802d65 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802d65:	55                   	push   %rbp
  802d66:	48 89 e5             	mov    %rsp,%rbp
  802d69:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802d70:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802d77:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802d7e:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802d85:	be 00 00 00 00       	mov    $0x0,%esi
  802d8a:	48 89 c7             	mov    %rax,%rdi
  802d8d:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  802d94:	00 00 00 
  802d97:	ff d0                	callq  *%rax
  802d99:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802da0:	79 08                	jns    802daa <spawn+0x45>
		return r;
  802da2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802da5:	e9 0c 03 00 00       	jmpq   8030b6 <spawn+0x351>
	fd = r;
  802daa:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802dad:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802db0:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802db7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802dbb:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802dc2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802dc5:	ba 00 02 00 00       	mov    $0x200,%edx
  802dca:	48 89 ce             	mov    %rcx,%rsi
  802dcd:	89 c7                	mov    %eax,%edi
  802dcf:	48 b8 ee 23 80 00 00 	movabs $0x8023ee,%rax
  802dd6:	00 00 00 
  802dd9:	ff d0                	callq  *%rax
  802ddb:	3d 00 02 00 00       	cmp    $0x200,%eax
  802de0:	75 0d                	jne    802def <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802de2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802de6:	8b 00                	mov    (%rax),%eax
  802de8:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802ded:	74 43                	je     802e32 <spawn+0xcd>
		close(fd);
  802def:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802df2:	89 c7                	mov    %eax,%edi
  802df4:	48 b8 f7 20 80 00 00 	movabs $0x8020f7,%rax
  802dfb:	00 00 00 
  802dfe:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802e00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e04:	8b 00                	mov    (%rax),%eax
  802e06:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802e0b:	89 c6                	mov    %eax,%esi
  802e0d:	48 bf 50 4b 80 00 00 	movabs $0x804b50,%rdi
  802e14:	00 00 00 
  802e17:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1c:	48 b9 41 05 80 00 00 	movabs $0x800541,%rcx
  802e23:	00 00 00 
  802e26:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802e28:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802e2d:	e9 84 02 00 00       	jmpq   8030b6 <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802e32:	b8 07 00 00 00       	mov    $0x7,%eax
  802e37:	cd 30                	int    $0x30
  802e39:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802e3c:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802e3f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e42:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e46:	79 08                	jns    802e50 <spawn+0xeb>
		return r;
  802e48:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e4b:	e9 66 02 00 00       	jmpq   8030b6 <spawn+0x351>
	child = r;
  802e50:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e53:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802e56:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e59:	25 ff 03 00 00       	and    $0x3ff,%eax
  802e5e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802e65:	00 00 00 
  802e68:	48 98                	cltq   
  802e6a:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  802e71:	48 01 d0             	add    %rdx,%rax
  802e74:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802e7b:	48 89 c6             	mov    %rax,%rsi
  802e7e:	b8 18 00 00 00       	mov    $0x18,%eax
  802e83:	48 89 d7             	mov    %rdx,%rdi
  802e86:	48 89 c1             	mov    %rax,%rcx
  802e89:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802e8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e90:	48 8b 40 18          	mov    0x18(%rax),%rax
  802e94:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802e9b:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802ea2:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802ea9:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802eb0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802eb3:	48 89 ce             	mov    %rcx,%rsi
  802eb6:	89 c7                	mov    %eax,%edi
  802eb8:	48 b8 20 33 80 00 00 	movabs $0x803320,%rax
  802ebf:	00 00 00 
  802ec2:	ff d0                	callq  *%rax
  802ec4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ec7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ecb:	79 08                	jns    802ed5 <spawn+0x170>
		return r;
  802ecd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ed0:	e9 e1 01 00 00       	jmpq   8030b6 <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802ed5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ed9:	48 8b 40 20          	mov    0x20(%rax),%rax
  802edd:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802ee4:	48 01 d0             	add    %rdx,%rax
  802ee7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802eeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ef2:	e9 a3 00 00 00       	jmpq   802f9a <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  802ef7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802efb:	8b 00                	mov    (%rax),%eax
  802efd:	83 f8 01             	cmp    $0x1,%eax
  802f00:	74 05                	je     802f07 <spawn+0x1a2>
			continue;
  802f02:	e9 8a 00 00 00       	jmpq   802f91 <spawn+0x22c>
		perm = PTE_P | PTE_U;
  802f07:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802f0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f12:	8b 40 04             	mov    0x4(%rax),%eax
  802f15:	83 e0 02             	and    $0x2,%eax
  802f18:	85 c0                	test   %eax,%eax
  802f1a:	74 04                	je     802f20 <spawn+0x1bb>
			perm |= PTE_W;
  802f1c:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802f20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f24:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802f28:	41 89 c1             	mov    %eax,%r9d
  802f2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f2f:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802f33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f37:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802f3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3f:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802f43:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802f46:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f49:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802f4c:	89 3c 24             	mov    %edi,(%rsp)
  802f4f:	89 c7                	mov    %eax,%edi
  802f51:	48 b8 c9 35 80 00 00 	movabs $0x8035c9,%rax
  802f58:	00 00 00 
  802f5b:	ff d0                	callq  *%rax
  802f5d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f60:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f64:	79 2b                	jns    802f91 <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802f66:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802f67:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f6a:	89 c7                	mov    %eax,%edi
  802f6c:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  802f73:	00 00 00 
  802f76:	ff d0                	callq  *%rax
	close(fd);
  802f78:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802f7b:	89 c7                	mov    %eax,%edi
  802f7d:	48 b8 f7 20 80 00 00 	movabs $0x8020f7,%rax
  802f84:	00 00 00 
  802f87:	ff d0                	callq  *%rax
	return r;
  802f89:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f8c:	e9 25 01 00 00       	jmpq   8030b6 <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802f91:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802f95:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802f9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f9e:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802fa2:	0f b7 c0             	movzwl %ax,%eax
  802fa5:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802fa8:	0f 8f 49 ff ff ff    	jg     802ef7 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802fae:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802fb1:	89 c7                	mov    %eax,%edi
  802fb3:	48 b8 f7 20 80 00 00 	movabs $0x8020f7,%rax
  802fba:	00 00 00 
  802fbd:	ff d0                	callq  *%rax
	fd = -1;
  802fbf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802fc6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802fc9:	89 c7                	mov    %eax,%edi
  802fcb:	48 b8 b5 37 80 00 00 	movabs $0x8037b5,%rax
  802fd2:	00 00 00 
  802fd5:	ff d0                	callq  *%rax
  802fd7:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802fda:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802fde:	79 30                	jns    803010 <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  802fe0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802fe3:	89 c1                	mov    %eax,%ecx
  802fe5:	48 ba 6a 4b 80 00 00 	movabs $0x804b6a,%rdx
  802fec:	00 00 00 
  802fef:	be 82 00 00 00       	mov    $0x82,%esi
  802ff4:	48 bf 80 4b 80 00 00 	movabs $0x804b80,%rdi
  802ffb:	00 00 00 
  802ffe:	b8 00 00 00 00       	mov    $0x0,%eax
  803003:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  80300a:	00 00 00 
  80300d:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803010:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803017:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80301a:	48 89 d6             	mov    %rdx,%rsi
  80301d:	89 c7                	mov    %eax,%edi
  80301f:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  803026:	00 00 00 
  803029:	ff d0                	callq  *%rax
  80302b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80302e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803032:	79 30                	jns    803064 <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  803034:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803037:	89 c1                	mov    %eax,%ecx
  803039:	48 ba 8c 4b 80 00 00 	movabs $0x804b8c,%rdx
  803040:	00 00 00 
  803043:	be 85 00 00 00       	mov    $0x85,%esi
  803048:	48 bf 80 4b 80 00 00 	movabs $0x804b80,%rdi
  80304f:	00 00 00 
  803052:	b8 00 00 00 00       	mov    $0x0,%eax
  803057:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  80305e:	00 00 00 
  803061:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803064:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803067:	be 02 00 00 00       	mov    $0x2,%esi
  80306c:	89 c7                	mov    %eax,%edi
  80306e:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  803075:	00 00 00 
  803078:	ff d0                	callq  *%rax
  80307a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80307d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803081:	79 30                	jns    8030b3 <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  803083:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803086:	89 c1                	mov    %eax,%ecx
  803088:	48 ba a6 4b 80 00 00 	movabs $0x804ba6,%rdx
  80308f:	00 00 00 
  803092:	be 88 00 00 00       	mov    $0x88,%esi
  803097:	48 bf 80 4b 80 00 00 	movabs $0x804b80,%rdi
  80309e:	00 00 00 
  8030a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a6:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  8030ad:	00 00 00 
  8030b0:	41 ff d0             	callq  *%r8

	return child;
  8030b3:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8030b6:	c9                   	leaveq 
  8030b7:	c3                   	retq   

00000000008030b8 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8030b8:	55                   	push   %rbp
  8030b9:	48 89 e5             	mov    %rsp,%rbp
  8030bc:	41 55                	push   %r13
  8030be:	41 54                	push   %r12
  8030c0:	53                   	push   %rbx
  8030c1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8030c8:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8030cf:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8030d6:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  8030dd:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  8030e4:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8030eb:	84 c0                	test   %al,%al
  8030ed:	74 26                	je     803115 <spawnl+0x5d>
  8030ef:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8030f6:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8030fd:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803101:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803105:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803109:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  80310d:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803111:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803115:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  80311c:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803123:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803126:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80312d:	00 00 00 
  803130:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803137:	00 00 00 
  80313a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80313e:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803145:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80314c:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803153:	eb 07                	jmp    80315c <spawnl+0xa4>
		argc++;
  803155:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80315c:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803162:	83 f8 30             	cmp    $0x30,%eax
  803165:	73 23                	jae    80318a <spawnl+0xd2>
  803167:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80316e:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803174:	89 c0                	mov    %eax,%eax
  803176:	48 01 d0             	add    %rdx,%rax
  803179:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80317f:	83 c2 08             	add    $0x8,%edx
  803182:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803188:	eb 15                	jmp    80319f <spawnl+0xe7>
  80318a:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803191:	48 89 d0             	mov    %rdx,%rax
  803194:	48 83 c2 08          	add    $0x8,%rdx
  803198:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80319f:	48 8b 00             	mov    (%rax),%rax
  8031a2:	48 85 c0             	test   %rax,%rax
  8031a5:	75 ae                	jne    803155 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8031a7:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8031ad:	83 c0 02             	add    $0x2,%eax
  8031b0:	48 89 e2             	mov    %rsp,%rdx
  8031b3:	48 89 d3             	mov    %rdx,%rbx
  8031b6:	48 63 d0             	movslq %eax,%rdx
  8031b9:	48 83 ea 01          	sub    $0x1,%rdx
  8031bd:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8031c4:	48 63 d0             	movslq %eax,%rdx
  8031c7:	49 89 d4             	mov    %rdx,%r12
  8031ca:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8031d0:	48 63 d0             	movslq %eax,%rdx
  8031d3:	49 89 d2             	mov    %rdx,%r10
  8031d6:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8031dc:	48 98                	cltq   
  8031de:	48 c1 e0 03          	shl    $0x3,%rax
  8031e2:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8031e6:	b8 10 00 00 00       	mov    $0x10,%eax
  8031eb:	48 83 e8 01          	sub    $0x1,%rax
  8031ef:	48 01 d0             	add    %rdx,%rax
  8031f2:	bf 10 00 00 00       	mov    $0x10,%edi
  8031f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8031fc:	48 f7 f7             	div    %rdi
  8031ff:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803203:	48 29 c4             	sub    %rax,%rsp
  803206:	48 89 e0             	mov    %rsp,%rax
  803209:	48 83 c0 07          	add    $0x7,%rax
  80320d:	48 c1 e8 03          	shr    $0x3,%rax
  803211:	48 c1 e0 03          	shl    $0x3,%rax
  803215:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  80321c:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803223:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  80322a:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  80322d:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803233:	8d 50 01             	lea    0x1(%rax),%edx
  803236:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80323d:	48 63 d2             	movslq %edx,%rdx
  803240:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803247:	00 

	va_start(vl, arg0);
  803248:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80324f:	00 00 00 
  803252:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803259:	00 00 00 
  80325c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803260:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803267:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80326e:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803275:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80327c:	00 00 00 
  80327f:	eb 63                	jmp    8032e4 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803281:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803287:	8d 70 01             	lea    0x1(%rax),%esi
  80328a:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803290:	83 f8 30             	cmp    $0x30,%eax
  803293:	73 23                	jae    8032b8 <spawnl+0x200>
  803295:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80329c:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8032a2:	89 c0                	mov    %eax,%eax
  8032a4:	48 01 d0             	add    %rdx,%rax
  8032a7:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8032ad:	83 c2 08             	add    $0x8,%edx
  8032b0:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8032b6:	eb 15                	jmp    8032cd <spawnl+0x215>
  8032b8:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8032bf:	48 89 d0             	mov    %rdx,%rax
  8032c2:	48 83 c2 08          	add    $0x8,%rdx
  8032c6:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8032cd:	48 8b 08             	mov    (%rax),%rcx
  8032d0:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8032d7:	89 f2                	mov    %esi,%edx
  8032d9:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8032dd:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8032e4:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8032ea:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8032f0:	77 8f                	ja     803281 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8032f2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8032f9:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803300:	48 89 d6             	mov    %rdx,%rsi
  803303:	48 89 c7             	mov    %rax,%rdi
  803306:	48 b8 65 2d 80 00 00 	movabs $0x802d65,%rax
  80330d:	00 00 00 
  803310:	ff d0                	callq  *%rax
  803312:	48 89 dc             	mov    %rbx,%rsp
}
  803315:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803319:	5b                   	pop    %rbx
  80331a:	41 5c                	pop    %r12
  80331c:	41 5d                	pop    %r13
  80331e:	5d                   	pop    %rbp
  80331f:	c3                   	retq   

0000000000803320 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803320:	55                   	push   %rbp
  803321:	48 89 e5             	mov    %rsp,%rbp
  803324:	48 83 ec 50          	sub    $0x50,%rsp
  803328:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80332b:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80332f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803333:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80333a:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  80333b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803342:	eb 33                	jmp    803377 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803344:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803347:	48 98                	cltq   
  803349:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803350:	00 
  803351:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803355:	48 01 d0             	add    %rdx,%rax
  803358:	48 8b 00             	mov    (%rax),%rax
  80335b:	48 89 c7             	mov    %rax,%rdi
  80335e:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  803365:	00 00 00 
  803368:	ff d0                	callq  *%rax
  80336a:	83 c0 01             	add    $0x1,%eax
  80336d:	48 98                	cltq   
  80336f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803373:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803377:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80337a:	48 98                	cltq   
  80337c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803383:	00 
  803384:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803388:	48 01 d0             	add    %rdx,%rax
  80338b:	48 8b 00             	mov    (%rax),%rax
  80338e:	48 85 c0             	test   %rax,%rax
  803391:	75 b1                	jne    803344 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803393:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803397:	48 f7 d8             	neg    %rax
  80339a:	48 05 00 10 40 00    	add    $0x401000,%rax
  8033a0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8033a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033a8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8033ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033b0:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8033b4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8033b7:	83 c2 01             	add    $0x1,%edx
  8033ba:	c1 e2 03             	shl    $0x3,%edx
  8033bd:	48 63 d2             	movslq %edx,%rdx
  8033c0:	48 f7 da             	neg    %rdx
  8033c3:	48 01 d0             	add    %rdx,%rax
  8033c6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8033ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ce:	48 83 e8 10          	sub    $0x10,%rax
  8033d2:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8033d8:	77 0a                	ja     8033e4 <init_stack+0xc4>
		return -E_NO_MEM;
  8033da:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8033df:	e9 e3 01 00 00       	jmpq   8035c7 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8033e4:	ba 07 00 00 00       	mov    $0x7,%edx
  8033e9:	be 00 00 40 00       	mov    $0x400000,%esi
  8033ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8033f3:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  8033fa:	00 00 00 
  8033fd:	ff d0                	callq  *%rax
  8033ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803402:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803406:	79 08                	jns    803410 <init_stack+0xf0>
		return r;
  803408:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80340b:	e9 b7 01 00 00       	jmpq   8035c7 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803410:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803417:	e9 8a 00 00 00       	jmpq   8034a6 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  80341c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80341f:	48 98                	cltq   
  803421:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803428:	00 
  803429:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80342d:	48 01 c2             	add    %rax,%rdx
  803430:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803435:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803439:	48 01 c8             	add    %rcx,%rax
  80343c:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803442:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803445:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803448:	48 98                	cltq   
  80344a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803451:	00 
  803452:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803456:	48 01 d0             	add    %rdx,%rax
  803459:	48 8b 10             	mov    (%rax),%rdx
  80345c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803460:	48 89 d6             	mov    %rdx,%rsi
  803463:	48 89 c7             	mov    %rax,%rdi
  803466:	48 b8 37 11 80 00 00 	movabs $0x801137,%rax
  80346d:	00 00 00 
  803470:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803472:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803475:	48 98                	cltq   
  803477:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80347e:	00 
  80347f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803483:	48 01 d0             	add    %rdx,%rax
  803486:	48 8b 00             	mov    (%rax),%rax
  803489:	48 89 c7             	mov    %rax,%rdi
  80348c:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  803493:	00 00 00 
  803496:	ff d0                	callq  *%rax
  803498:	48 98                	cltq   
  80349a:	48 83 c0 01          	add    $0x1,%rax
  80349e:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8034a2:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8034a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034a9:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8034ac:	0f 8c 6a ff ff ff    	jl     80341c <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8034b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034b5:	48 98                	cltq   
  8034b7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8034be:	00 
  8034bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034c3:	48 01 d0             	add    %rdx,%rax
  8034c6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8034cd:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8034d4:	00 
  8034d5:	74 35                	je     80350c <init_stack+0x1ec>
  8034d7:	48 b9 c0 4b 80 00 00 	movabs $0x804bc0,%rcx
  8034de:	00 00 00 
  8034e1:	48 ba e6 4b 80 00 00 	movabs $0x804be6,%rdx
  8034e8:	00 00 00 
  8034eb:	be f1 00 00 00       	mov    $0xf1,%esi
  8034f0:	48 bf 80 4b 80 00 00 	movabs $0x804b80,%rdi
  8034f7:	00 00 00 
  8034fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ff:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  803506:	00 00 00 
  803509:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80350c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803510:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803514:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803519:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80351d:	48 01 c8             	add    %rcx,%rax
  803520:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803526:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803529:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80352d:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803531:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803534:	48 98                	cltq   
  803536:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803539:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  80353e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803542:	48 01 d0             	add    %rdx,%rax
  803545:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80354b:	48 89 c2             	mov    %rax,%rdx
  80354e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803552:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803555:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803558:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80355e:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803563:	89 c2                	mov    %eax,%edx
  803565:	be 00 00 40 00       	mov    $0x400000,%esi
  80356a:	bf 00 00 00 00       	mov    $0x0,%edi
  80356f:	48 b8 b6 1a 80 00 00 	movabs $0x801ab6,%rax
  803576:	00 00 00 
  803579:	ff d0                	callq  *%rax
  80357b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80357e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803582:	79 02                	jns    803586 <init_stack+0x266>
		goto error;
  803584:	eb 28                	jmp    8035ae <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803586:	be 00 00 40 00       	mov    $0x400000,%esi
  80358b:	bf 00 00 00 00       	mov    $0x0,%edi
  803590:	48 b8 11 1b 80 00 00 	movabs $0x801b11,%rax
  803597:	00 00 00 
  80359a:	ff d0                	callq  *%rax
  80359c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80359f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035a3:	79 02                	jns    8035a7 <init_stack+0x287>
		goto error;
  8035a5:	eb 07                	jmp    8035ae <init_stack+0x28e>

	return 0;
  8035a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ac:	eb 19                	jmp    8035c7 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8035ae:	be 00 00 40 00       	mov    $0x400000,%esi
  8035b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8035b8:	48 b8 11 1b 80 00 00 	movabs $0x801b11,%rax
  8035bf:	00 00 00 
  8035c2:	ff d0                	callq  *%rax
	return r;
  8035c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8035c7:	c9                   	leaveq 
  8035c8:	c3                   	retq   

00000000008035c9 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8035c9:	55                   	push   %rbp
  8035ca:	48 89 e5             	mov    %rsp,%rbp
  8035cd:	48 83 ec 50          	sub    $0x50,%rsp
  8035d1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8035d4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035d8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8035dc:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8035df:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8035e3:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8035e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035eb:	25 ff 0f 00 00       	and    $0xfff,%eax
  8035f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035f7:	74 21                	je     80361a <map_segment+0x51>
		va -= i;
  8035f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035fc:	48 98                	cltq   
  8035fe:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803602:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803605:	48 98                	cltq   
  803607:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  80360b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80360e:	48 98                	cltq   
  803610:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803614:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803617:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80361a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803621:	e9 79 01 00 00       	jmpq   80379f <map_segment+0x1d6>
		if (i >= filesz) {
  803626:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803629:	48 98                	cltq   
  80362b:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80362f:	72 3c                	jb     80366d <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803634:	48 63 d0             	movslq %eax,%rdx
  803637:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80363b:	48 01 d0             	add    %rdx,%rax
  80363e:	48 89 c1             	mov    %rax,%rcx
  803641:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803644:	8b 55 10             	mov    0x10(%rbp),%edx
  803647:	48 89 ce             	mov    %rcx,%rsi
  80364a:	89 c7                	mov    %eax,%edi
  80364c:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  803653:	00 00 00 
  803656:	ff d0                	callq  *%rax
  803658:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80365b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80365f:	0f 89 33 01 00 00    	jns    803798 <map_segment+0x1cf>
				return r;
  803665:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803668:	e9 46 01 00 00       	jmpq   8037b3 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80366d:	ba 07 00 00 00       	mov    $0x7,%edx
  803672:	be 00 00 40 00       	mov    $0x400000,%esi
  803677:	bf 00 00 00 00       	mov    $0x0,%edi
  80367c:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  803683:	00 00 00 
  803686:	ff d0                	callq  *%rax
  803688:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80368b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80368f:	79 08                	jns    803699 <map_segment+0xd0>
				return r;
  803691:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803694:	e9 1a 01 00 00       	jmpq   8037b3 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803699:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80369c:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80369f:	01 c2                	add    %eax,%edx
  8036a1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8036a4:	89 d6                	mov    %edx,%esi
  8036a6:	89 c7                	mov    %eax,%edi
  8036a8:	48 b8 37 25 80 00 00 	movabs $0x802537,%rax
  8036af:	00 00 00 
  8036b2:	ff d0                	callq  *%rax
  8036b4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8036b7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8036bb:	79 08                	jns    8036c5 <map_segment+0xfc>
				return r;
  8036bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036c0:	e9 ee 00 00 00       	jmpq   8037b3 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8036c5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8036cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036cf:	48 98                	cltq   
  8036d1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8036d5:	48 29 c2             	sub    %rax,%rdx
  8036d8:	48 89 d0             	mov    %rdx,%rax
  8036db:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8036df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036e2:	48 63 d0             	movslq %eax,%rdx
  8036e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e9:	48 39 c2             	cmp    %rax,%rdx
  8036ec:	48 0f 47 d0          	cmova  %rax,%rdx
  8036f0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8036f3:	be 00 00 40 00       	mov    $0x400000,%esi
  8036f8:	89 c7                	mov    %eax,%edi
  8036fa:	48 b8 ee 23 80 00 00 	movabs $0x8023ee,%rax
  803701:	00 00 00 
  803704:	ff d0                	callq  *%rax
  803706:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803709:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80370d:	79 08                	jns    803717 <map_segment+0x14e>
				return r;
  80370f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803712:	e9 9c 00 00 00       	jmpq   8037b3 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803717:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371a:	48 63 d0             	movslq %eax,%rdx
  80371d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803721:	48 01 d0             	add    %rdx,%rax
  803724:	48 89 c2             	mov    %rax,%rdx
  803727:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80372a:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  80372e:	48 89 d1             	mov    %rdx,%rcx
  803731:	89 c2                	mov    %eax,%edx
  803733:	be 00 00 40 00       	mov    $0x400000,%esi
  803738:	bf 00 00 00 00       	mov    $0x0,%edi
  80373d:	48 b8 b6 1a 80 00 00 	movabs $0x801ab6,%rax
  803744:	00 00 00 
  803747:	ff d0                	callq  *%rax
  803749:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80374c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803750:	79 30                	jns    803782 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803752:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803755:	89 c1                	mov    %eax,%ecx
  803757:	48 ba fb 4b 80 00 00 	movabs $0x804bfb,%rdx
  80375e:	00 00 00 
  803761:	be 24 01 00 00       	mov    $0x124,%esi
  803766:	48 bf 80 4b 80 00 00 	movabs $0x804b80,%rdi
  80376d:	00 00 00 
  803770:	b8 00 00 00 00       	mov    $0x0,%eax
  803775:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  80377c:	00 00 00 
  80377f:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803782:	be 00 00 40 00       	mov    $0x400000,%esi
  803787:	bf 00 00 00 00       	mov    $0x0,%edi
  80378c:	48 b8 11 1b 80 00 00 	movabs $0x801b11,%rax
  803793:	00 00 00 
  803796:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803798:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80379f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a2:	48 98                	cltq   
  8037a4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037a8:	0f 82 78 fe ff ff    	jb     803626 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8037ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037b3:	c9                   	leaveq 
  8037b4:	c3                   	retq   

00000000008037b5 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8037b5:	55                   	push   %rbp
  8037b6:	48 89 e5             	mov    %rsp,%rbp
  8037b9:	48 83 ec 20          	sub    $0x20,%rsp
  8037bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	// LAB 5: Your code here.
	uint64_t  i;
	for (i=UTEXT;i<USTACKTOP;i+=PGSIZE)
  8037c0:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  8037c7:	00 
  8037c8:	e9 23 01 00 00       	jmpq   8038f0 <copy_shared_pages+0x13b>
	{
		if ((uvpml4e[VPML4E(i)]) && (uvpde[VPDPE(i)]) && (uvpd[VPD(i)]) && (uvpt[VPN(i)]))
  8037cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d1:	48 c1 e8 27          	shr    $0x27,%rax
  8037d5:	48 89 c2             	mov    %rax,%rdx
  8037d8:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8037df:	01 00 00 
  8037e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037e6:	48 85 c0             	test   %rax,%rax
  8037e9:	0f 84 f9 00 00 00    	je     8038e8 <copy_shared_pages+0x133>
  8037ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f3:	48 c1 e8 1e          	shr    $0x1e,%rax
  8037f7:	48 89 c2             	mov    %rax,%rdx
  8037fa:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803801:	01 00 00 
  803804:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803808:	48 85 c0             	test   %rax,%rax
  80380b:	0f 84 d7 00 00 00    	je     8038e8 <copy_shared_pages+0x133>
  803811:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803815:	48 c1 e8 15          	shr    $0x15,%rax
  803819:	48 89 c2             	mov    %rax,%rdx
  80381c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803823:	01 00 00 
  803826:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80382a:	48 85 c0             	test   %rax,%rax
  80382d:	0f 84 b5 00 00 00    	je     8038e8 <copy_shared_pages+0x133>
  803833:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803837:	48 c1 e8 0c          	shr    $0xc,%rax
  80383b:	48 89 c2             	mov    %rax,%rdx
  80383e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803845:	01 00 00 
  803848:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80384c:	48 85 c0             	test   %rax,%rax
  80384f:	0f 84 93 00 00 00    	je     8038e8 <copy_shared_pages+0x133>
		{
			if (uvpt[VPN(i)]&PTE_SHARE)
  803855:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803859:	48 c1 e8 0c          	shr    $0xc,%rax
  80385d:	48 89 c2             	mov    %rax,%rdx
  803860:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803867:	01 00 00 
  80386a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80386e:	25 00 04 00 00       	and    $0x400,%eax
  803873:	48 85 c0             	test   %rax,%rax
  803876:	74 70                	je     8038e8 <copy_shared_pages+0x133>
				if (sys_page_map(0, (void *)i, child, (void *)i, uvpt[VPN(i)] & PTE_SYSCALL)<0)
  803878:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80387c:	48 c1 e8 0c          	shr    $0xc,%rax
  803880:	48 89 c2             	mov    %rax,%rdx
  803883:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80388a:	01 00 00 
  80388d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803891:	25 07 0e 00 00       	and    $0xe07,%eax
  803896:	89 c6                	mov    %eax,%esi
  803898:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80389c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038a3:	41 89 f0             	mov    %esi,%r8d
  8038a6:	48 89 c6             	mov    %rax,%rsi
  8038a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8038ae:	48 b8 b6 1a 80 00 00 	movabs $0x801ab6,%rax
  8038b5:	00 00 00 
  8038b8:	ff d0                	callq  *%rax
  8038ba:	85 c0                	test   %eax,%eax
  8038bc:	79 2a                	jns    8038e8 <copy_shared_pages+0x133>
					panic("copy_shared_pages: sys_page_map\n");
  8038be:	48 ba 18 4c 80 00 00 	movabs $0x804c18,%rdx
  8038c5:	00 00 00 
  8038c8:	be 37 01 00 00       	mov    $0x137,%esi
  8038cd:	48 bf 80 4b 80 00 00 	movabs $0x804b80,%rdi
  8038d4:	00 00 00 
  8038d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038dc:	48 b9 08 03 80 00 00 	movabs $0x800308,%rcx
  8038e3:	00 00 00 
  8038e6:	ff d1                	callq  *%rcx
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint64_t  i;
	for (i=UTEXT;i<USTACKTOP;i+=PGSIZE)
  8038e8:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8038ef:	00 
  8038f0:	b8 ff df 7f ef       	mov    $0xef7fdfff,%eax
  8038f5:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8038f9:	0f 86 ce fe ff ff    	jbe    8037cd <copy_shared_pages+0x18>
			if (uvpt[VPN(i)]&PTE_SHARE)
				if (sys_page_map(0, (void *)i, child, (void *)i, uvpt[VPN(i)] & PTE_SYSCALL)<0)
					panic("copy_shared_pages: sys_page_map\n");
		}
	}
	return 0;
  8038ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803904:	c9                   	leaveq 
  803905:	c3                   	retq   

0000000000803906 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803906:	55                   	push   %rbp
  803907:	48 89 e5             	mov    %rsp,%rbp
  80390a:	53                   	push   %rbx
  80390b:	48 83 ec 38          	sub    $0x38,%rsp
  80390f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803913:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803917:	48 89 c7             	mov    %rax,%rdi
  80391a:	48 b8 4f 1e 80 00 00 	movabs $0x801e4f,%rax
  803921:	00 00 00 
  803924:	ff d0                	callq  *%rax
  803926:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803929:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80392d:	0f 88 bf 01 00 00    	js     803af2 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803933:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803937:	ba 07 04 00 00       	mov    $0x407,%edx
  80393c:	48 89 c6             	mov    %rax,%rsi
  80393f:	bf 00 00 00 00       	mov    $0x0,%edi
  803944:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  80394b:	00 00 00 
  80394e:	ff d0                	callq  *%rax
  803950:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803953:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803957:	0f 88 95 01 00 00    	js     803af2 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80395d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803961:	48 89 c7             	mov    %rax,%rdi
  803964:	48 b8 4f 1e 80 00 00 	movabs $0x801e4f,%rax
  80396b:	00 00 00 
  80396e:	ff d0                	callq  *%rax
  803970:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803973:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803977:	0f 88 5d 01 00 00    	js     803ada <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80397d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803981:	ba 07 04 00 00       	mov    $0x407,%edx
  803986:	48 89 c6             	mov    %rax,%rsi
  803989:	bf 00 00 00 00       	mov    $0x0,%edi
  80398e:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  803995:	00 00 00 
  803998:	ff d0                	callq  *%rax
  80399a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80399d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039a1:	0f 88 33 01 00 00    	js     803ada <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8039a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ab:	48 89 c7             	mov    %rax,%rdi
  8039ae:	48 b8 24 1e 80 00 00 	movabs $0x801e24,%rax
  8039b5:	00 00 00 
  8039b8:	ff d0                	callq  *%rax
  8039ba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039c2:	ba 07 04 00 00       	mov    $0x407,%edx
  8039c7:	48 89 c6             	mov    %rax,%rsi
  8039ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8039cf:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  8039d6:	00 00 00 
  8039d9:	ff d0                	callq  *%rax
  8039db:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039de:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039e2:	79 05                	jns    8039e9 <pipe+0xe3>
		goto err2;
  8039e4:	e9 d9 00 00 00       	jmpq   803ac2 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039ed:	48 89 c7             	mov    %rax,%rdi
  8039f0:	48 b8 24 1e 80 00 00 	movabs $0x801e24,%rax
  8039f7:	00 00 00 
  8039fa:	ff d0                	callq  *%rax
  8039fc:	48 89 c2             	mov    %rax,%rdx
  8039ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a03:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803a09:	48 89 d1             	mov    %rdx,%rcx
  803a0c:	ba 00 00 00 00       	mov    $0x0,%edx
  803a11:	48 89 c6             	mov    %rax,%rsi
  803a14:	bf 00 00 00 00       	mov    $0x0,%edi
  803a19:	48 b8 b6 1a 80 00 00 	movabs $0x801ab6,%rax
  803a20:	00 00 00 
  803a23:	ff d0                	callq  *%rax
  803a25:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a28:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a2c:	79 1b                	jns    803a49 <pipe+0x143>
		goto err3;
  803a2e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803a2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a33:	48 89 c6             	mov    %rax,%rsi
  803a36:	bf 00 00 00 00       	mov    $0x0,%edi
  803a3b:	48 b8 11 1b 80 00 00 	movabs $0x801b11,%rax
  803a42:	00 00 00 
  803a45:	ff d0                	callq  *%rax
  803a47:	eb 79                	jmp    803ac2 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803a49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a4d:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803a54:	00 00 00 
  803a57:	8b 12                	mov    (%rdx),%edx
  803a59:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803a5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a5f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803a66:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a6a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803a71:	00 00 00 
  803a74:	8b 12                	mov    (%rdx),%edx
  803a76:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803a78:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a7c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803a83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a87:	48 89 c7             	mov    %rax,%rdi
  803a8a:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  803a91:	00 00 00 
  803a94:	ff d0                	callq  *%rax
  803a96:	89 c2                	mov    %eax,%edx
  803a98:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a9c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803a9e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803aa2:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803aa6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aaa:	48 89 c7             	mov    %rax,%rdi
  803aad:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  803ab4:	00 00 00 
  803ab7:	ff d0                	callq  *%rax
  803ab9:	89 03                	mov    %eax,(%rbx)
	return 0;
  803abb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac0:	eb 33                	jmp    803af5 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803ac2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ac6:	48 89 c6             	mov    %rax,%rsi
  803ac9:	bf 00 00 00 00       	mov    $0x0,%edi
  803ace:	48 b8 11 1b 80 00 00 	movabs $0x801b11,%rax
  803ad5:	00 00 00 
  803ad8:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803ada:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ade:	48 89 c6             	mov    %rax,%rsi
  803ae1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ae6:	48 b8 11 1b 80 00 00 	movabs $0x801b11,%rax
  803aed:	00 00 00 
  803af0:	ff d0                	callq  *%rax
err:
	return r;
  803af2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803af5:	48 83 c4 38          	add    $0x38,%rsp
  803af9:	5b                   	pop    %rbx
  803afa:	5d                   	pop    %rbp
  803afb:	c3                   	retq   

0000000000803afc <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803afc:	55                   	push   %rbp
  803afd:	48 89 e5             	mov    %rsp,%rbp
  803b00:	53                   	push   %rbx
  803b01:	48 83 ec 28          	sub    $0x28,%rsp
  803b05:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b09:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803b0d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b14:	00 00 00 
  803b17:	48 8b 00             	mov    (%rax),%rax
  803b1a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b20:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803b23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b27:	48 89 c7             	mov    %rax,%rdi
  803b2a:	48 b8 a6 43 80 00 00 	movabs $0x8043a6,%rax
  803b31:	00 00 00 
  803b34:	ff d0                	callq  *%rax
  803b36:	89 c3                	mov    %eax,%ebx
  803b38:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b3c:	48 89 c7             	mov    %rax,%rdi
  803b3f:	48 b8 a6 43 80 00 00 	movabs $0x8043a6,%rax
  803b46:	00 00 00 
  803b49:	ff d0                	callq  *%rax
  803b4b:	39 c3                	cmp    %eax,%ebx
  803b4d:	0f 94 c0             	sete   %al
  803b50:	0f b6 c0             	movzbl %al,%eax
  803b53:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803b56:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b5d:	00 00 00 
  803b60:	48 8b 00             	mov    (%rax),%rax
  803b63:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b69:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803b6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b6f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803b72:	75 05                	jne    803b79 <_pipeisclosed+0x7d>
			return ret;
  803b74:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b77:	eb 4f                	jmp    803bc8 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803b79:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b7c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803b7f:	74 42                	je     803bc3 <_pipeisclosed+0xc7>
  803b81:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803b85:	75 3c                	jne    803bc3 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803b87:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b8e:	00 00 00 
  803b91:	48 8b 00             	mov    (%rax),%rax
  803b94:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803b9a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803b9d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ba0:	89 c6                	mov    %eax,%esi
  803ba2:	48 bf 43 4c 80 00 00 	movabs $0x804c43,%rdi
  803ba9:	00 00 00 
  803bac:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb1:	49 b8 41 05 80 00 00 	movabs $0x800541,%r8
  803bb8:	00 00 00 
  803bbb:	41 ff d0             	callq  *%r8
	}
  803bbe:	e9 4a ff ff ff       	jmpq   803b0d <_pipeisclosed+0x11>
  803bc3:	e9 45 ff ff ff       	jmpq   803b0d <_pipeisclosed+0x11>
}
  803bc8:	48 83 c4 28          	add    $0x28,%rsp
  803bcc:	5b                   	pop    %rbx
  803bcd:	5d                   	pop    %rbp
  803bce:	c3                   	retq   

0000000000803bcf <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803bcf:	55                   	push   %rbp
  803bd0:	48 89 e5             	mov    %rsp,%rbp
  803bd3:	48 83 ec 30          	sub    $0x30,%rsp
  803bd7:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803bda:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803bde:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803be1:	48 89 d6             	mov    %rdx,%rsi
  803be4:	89 c7                	mov    %eax,%edi
  803be6:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  803bed:	00 00 00 
  803bf0:	ff d0                	callq  *%rax
  803bf2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bf5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf9:	79 05                	jns    803c00 <pipeisclosed+0x31>
		return r;
  803bfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bfe:	eb 31                	jmp    803c31 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803c00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c04:	48 89 c7             	mov    %rax,%rdi
  803c07:	48 b8 24 1e 80 00 00 	movabs $0x801e24,%rax
  803c0e:	00 00 00 
  803c11:	ff d0                	callq  *%rax
  803c13:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803c17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c1f:	48 89 d6             	mov    %rdx,%rsi
  803c22:	48 89 c7             	mov    %rax,%rdi
  803c25:	48 b8 fc 3a 80 00 00 	movabs $0x803afc,%rax
  803c2c:	00 00 00 
  803c2f:	ff d0                	callq  *%rax
}
  803c31:	c9                   	leaveq 
  803c32:	c3                   	retq   

0000000000803c33 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c33:	55                   	push   %rbp
  803c34:	48 89 e5             	mov    %rsp,%rbp
  803c37:	48 83 ec 40          	sub    $0x40,%rsp
  803c3b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c3f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c43:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803c47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c4b:	48 89 c7             	mov    %rax,%rdi
  803c4e:	48 b8 24 1e 80 00 00 	movabs $0x801e24,%rax
  803c55:	00 00 00 
  803c58:	ff d0                	callq  *%rax
  803c5a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c62:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c66:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c6d:	00 
  803c6e:	e9 92 00 00 00       	jmpq   803d05 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803c73:	eb 41                	jmp    803cb6 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803c75:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803c7a:	74 09                	je     803c85 <devpipe_read+0x52>
				return i;
  803c7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c80:	e9 92 00 00 00       	jmpq   803d17 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803c85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c8d:	48 89 d6             	mov    %rdx,%rsi
  803c90:	48 89 c7             	mov    %rax,%rdi
  803c93:	48 b8 fc 3a 80 00 00 	movabs $0x803afc,%rax
  803c9a:	00 00 00 
  803c9d:	ff d0                	callq  *%rax
  803c9f:	85 c0                	test   %eax,%eax
  803ca1:	74 07                	je     803caa <devpipe_read+0x77>
				return 0;
  803ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca8:	eb 6d                	jmp    803d17 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803caa:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  803cb1:	00 00 00 
  803cb4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803cb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cba:	8b 10                	mov    (%rax),%edx
  803cbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cc0:	8b 40 04             	mov    0x4(%rax),%eax
  803cc3:	39 c2                	cmp    %eax,%edx
  803cc5:	74 ae                	je     803c75 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803cc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ccb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ccf:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cd7:	8b 00                	mov    (%rax),%eax
  803cd9:	99                   	cltd   
  803cda:	c1 ea 1b             	shr    $0x1b,%edx
  803cdd:	01 d0                	add    %edx,%eax
  803cdf:	83 e0 1f             	and    $0x1f,%eax
  803ce2:	29 d0                	sub    %edx,%eax
  803ce4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ce8:	48 98                	cltq   
  803cea:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803cef:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803cf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf5:	8b 00                	mov    (%rax),%eax
  803cf7:	8d 50 01             	lea    0x1(%rax),%edx
  803cfa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfe:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d00:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d09:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d0d:	0f 82 60 ff ff ff    	jb     803c73 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803d13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d17:	c9                   	leaveq 
  803d18:	c3                   	retq   

0000000000803d19 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d19:	55                   	push   %rbp
  803d1a:	48 89 e5             	mov    %rsp,%rbp
  803d1d:	48 83 ec 40          	sub    $0x40,%rsp
  803d21:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d25:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d29:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803d2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d31:	48 89 c7             	mov    %rax,%rdi
  803d34:	48 b8 24 1e 80 00 00 	movabs $0x801e24,%rax
  803d3b:	00 00 00 
  803d3e:	ff d0                	callq  *%rax
  803d40:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d48:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d4c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d53:	00 
  803d54:	e9 8e 00 00 00       	jmpq   803de7 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803d59:	eb 31                	jmp    803d8c <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803d5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d63:	48 89 d6             	mov    %rdx,%rsi
  803d66:	48 89 c7             	mov    %rax,%rdi
  803d69:	48 b8 fc 3a 80 00 00 	movabs $0x803afc,%rax
  803d70:	00 00 00 
  803d73:	ff d0                	callq  *%rax
  803d75:	85 c0                	test   %eax,%eax
  803d77:	74 07                	je     803d80 <devpipe_write+0x67>
				return 0;
  803d79:	b8 00 00 00 00       	mov    $0x0,%eax
  803d7e:	eb 79                	jmp    803df9 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803d80:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  803d87:	00 00 00 
  803d8a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803d8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d90:	8b 40 04             	mov    0x4(%rax),%eax
  803d93:	48 63 d0             	movslq %eax,%rdx
  803d96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d9a:	8b 00                	mov    (%rax),%eax
  803d9c:	48 98                	cltq   
  803d9e:	48 83 c0 20          	add    $0x20,%rax
  803da2:	48 39 c2             	cmp    %rax,%rdx
  803da5:	73 b4                	jae    803d5b <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803da7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dab:	8b 40 04             	mov    0x4(%rax),%eax
  803dae:	99                   	cltd   
  803daf:	c1 ea 1b             	shr    $0x1b,%edx
  803db2:	01 d0                	add    %edx,%eax
  803db4:	83 e0 1f             	and    $0x1f,%eax
  803db7:	29 d0                	sub    %edx,%eax
  803db9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803dbd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803dc1:	48 01 ca             	add    %rcx,%rdx
  803dc4:	0f b6 0a             	movzbl (%rdx),%ecx
  803dc7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dcb:	48 98                	cltq   
  803dcd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803dd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd5:	8b 40 04             	mov    0x4(%rax),%eax
  803dd8:	8d 50 01             	lea    0x1(%rax),%edx
  803ddb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ddf:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803de2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803de7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803deb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803def:	0f 82 64 ff ff ff    	jb     803d59 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803df5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803df9:	c9                   	leaveq 
  803dfa:	c3                   	retq   

0000000000803dfb <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803dfb:	55                   	push   %rbp
  803dfc:	48 89 e5             	mov    %rsp,%rbp
  803dff:	48 83 ec 20          	sub    $0x20,%rsp
  803e03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803e0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e0f:	48 89 c7             	mov    %rax,%rdi
  803e12:	48 b8 24 1e 80 00 00 	movabs $0x801e24,%rax
  803e19:	00 00 00 
  803e1c:	ff d0                	callq  *%rax
  803e1e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803e22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e26:	48 be 56 4c 80 00 00 	movabs $0x804c56,%rsi
  803e2d:	00 00 00 
  803e30:	48 89 c7             	mov    %rax,%rdi
  803e33:	48 b8 37 11 80 00 00 	movabs $0x801137,%rax
  803e3a:	00 00 00 
  803e3d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803e3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e43:	8b 50 04             	mov    0x4(%rax),%edx
  803e46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e4a:	8b 00                	mov    (%rax),%eax
  803e4c:	29 c2                	sub    %eax,%edx
  803e4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e52:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803e58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e5c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803e63:	00 00 00 
	stat->st_dev = &devpipe;
  803e66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e6a:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803e71:	00 00 00 
  803e74:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e80:	c9                   	leaveq 
  803e81:	c3                   	retq   

0000000000803e82 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803e82:	55                   	push   %rbp
  803e83:	48 89 e5             	mov    %rsp,%rbp
  803e86:	48 83 ec 10          	sub    $0x10,%rsp
  803e8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803e8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e92:	48 89 c6             	mov    %rax,%rsi
  803e95:	bf 00 00 00 00       	mov    $0x0,%edi
  803e9a:	48 b8 11 1b 80 00 00 	movabs $0x801b11,%rax
  803ea1:	00 00 00 
  803ea4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803ea6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eaa:	48 89 c7             	mov    %rax,%rdi
  803ead:	48 b8 24 1e 80 00 00 	movabs $0x801e24,%rax
  803eb4:	00 00 00 
  803eb7:	ff d0                	callq  *%rax
  803eb9:	48 89 c6             	mov    %rax,%rsi
  803ebc:	bf 00 00 00 00       	mov    $0x0,%edi
  803ec1:	48 b8 11 1b 80 00 00 	movabs $0x801b11,%rax
  803ec8:	00 00 00 
  803ecb:	ff d0                	callq  *%rax
}
  803ecd:	c9                   	leaveq 
  803ece:	c3                   	retq   

0000000000803ecf <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803ecf:	55                   	push   %rbp
  803ed0:	48 89 e5             	mov    %rsp,%rbp
  803ed3:	48 83 ec 20          	sub    $0x20,%rsp
  803ed7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803eda:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803edd:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ee0:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ee4:	be 01 00 00 00       	mov    $0x1,%esi
  803ee9:	48 89 c7             	mov    %rax,%rdi
  803eec:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  803ef3:	00 00 00 
  803ef6:	ff d0                	callq  *%rax
}
  803ef8:	c9                   	leaveq 
  803ef9:	c3                   	retq   

0000000000803efa <getchar>:

int
getchar(void)
{
  803efa:	55                   	push   %rbp
  803efb:	48 89 e5             	mov    %rsp,%rbp
  803efe:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803f02:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803f06:	ba 01 00 00 00       	mov    $0x1,%edx
  803f0b:	48 89 c6             	mov    %rax,%rsi
  803f0e:	bf 00 00 00 00       	mov    $0x0,%edi
  803f13:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  803f1a:	00 00 00 
  803f1d:	ff d0                	callq  *%rax
  803f1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803f22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f26:	79 05                	jns    803f2d <getchar+0x33>
		return r;
  803f28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f2b:	eb 14                	jmp    803f41 <getchar+0x47>
	if (r < 1)
  803f2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f31:	7f 07                	jg     803f3a <getchar+0x40>
		return -E_EOF;
  803f33:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803f38:	eb 07                	jmp    803f41 <getchar+0x47>
	return c;
  803f3a:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803f3e:	0f b6 c0             	movzbl %al,%eax
}
  803f41:	c9                   	leaveq 
  803f42:	c3                   	retq   

0000000000803f43 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803f43:	55                   	push   %rbp
  803f44:	48 89 e5             	mov    %rsp,%rbp
  803f47:	48 83 ec 20          	sub    $0x20,%rsp
  803f4b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f4e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f55:	48 89 d6             	mov    %rdx,%rsi
  803f58:	89 c7                	mov    %eax,%edi
  803f5a:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  803f61:	00 00 00 
  803f64:	ff d0                	callq  *%rax
  803f66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f6d:	79 05                	jns    803f74 <iscons+0x31>
		return r;
  803f6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f72:	eb 1a                	jmp    803f8e <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f78:	8b 10                	mov    (%rax),%edx
  803f7a:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803f81:	00 00 00 
  803f84:	8b 00                	mov    (%rax),%eax
  803f86:	39 c2                	cmp    %eax,%edx
  803f88:	0f 94 c0             	sete   %al
  803f8b:	0f b6 c0             	movzbl %al,%eax
}
  803f8e:	c9                   	leaveq 
  803f8f:	c3                   	retq   

0000000000803f90 <opencons>:

int
opencons(void)
{
  803f90:	55                   	push   %rbp
  803f91:	48 89 e5             	mov    %rsp,%rbp
  803f94:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803f98:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803f9c:	48 89 c7             	mov    %rax,%rdi
  803f9f:	48 b8 4f 1e 80 00 00 	movabs $0x801e4f,%rax
  803fa6:	00 00 00 
  803fa9:	ff d0                	callq  *%rax
  803fab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fb2:	79 05                	jns    803fb9 <opencons+0x29>
		return r;
  803fb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb7:	eb 5b                	jmp    804014 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803fb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fbd:	ba 07 04 00 00       	mov    $0x407,%edx
  803fc2:	48 89 c6             	mov    %rax,%rsi
  803fc5:	bf 00 00 00 00       	mov    $0x0,%edi
  803fca:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  803fd1:	00 00 00 
  803fd4:	ff d0                	callq  *%rax
  803fd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fdd:	79 05                	jns    803fe4 <opencons+0x54>
		return r;
  803fdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fe2:	eb 30                	jmp    804014 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803fe4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe8:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803fef:	00 00 00 
  803ff2:	8b 12                	mov    (%rdx),%edx
  803ff4:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803ff6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ffa:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804001:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804005:	48 89 c7             	mov    %rax,%rdi
  804008:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  80400f:	00 00 00 
  804012:	ff d0                	callq  *%rax
}
  804014:	c9                   	leaveq 
  804015:	c3                   	retq   

0000000000804016 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804016:	55                   	push   %rbp
  804017:	48 89 e5             	mov    %rsp,%rbp
  80401a:	48 83 ec 30          	sub    $0x30,%rsp
  80401e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804022:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804026:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80402a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80402f:	75 07                	jne    804038 <devcons_read+0x22>
		return 0;
  804031:	b8 00 00 00 00       	mov    $0x0,%eax
  804036:	eb 4b                	jmp    804083 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804038:	eb 0c                	jmp    804046 <devcons_read+0x30>
		sys_yield();
  80403a:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  804041:	00 00 00 
  804044:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804046:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  80404d:	00 00 00 
  804050:	ff d0                	callq  *%rax
  804052:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804055:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804059:	74 df                	je     80403a <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80405b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80405f:	79 05                	jns    804066 <devcons_read+0x50>
		return c;
  804061:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804064:	eb 1d                	jmp    804083 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804066:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80406a:	75 07                	jne    804073 <devcons_read+0x5d>
		return 0;
  80406c:	b8 00 00 00 00       	mov    $0x0,%eax
  804071:	eb 10                	jmp    804083 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804073:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804076:	89 c2                	mov    %eax,%edx
  804078:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80407c:	88 10                	mov    %dl,(%rax)
	return 1;
  80407e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804083:	c9                   	leaveq 
  804084:	c3                   	retq   

0000000000804085 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804085:	55                   	push   %rbp
  804086:	48 89 e5             	mov    %rsp,%rbp
  804089:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804090:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804097:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80409e:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8040a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8040ac:	eb 76                	jmp    804124 <devcons_write+0x9f>
		m = n - tot;
  8040ae:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8040b5:	89 c2                	mov    %eax,%edx
  8040b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ba:	29 c2                	sub    %eax,%edx
  8040bc:	89 d0                	mov    %edx,%eax
  8040be:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8040c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040c4:	83 f8 7f             	cmp    $0x7f,%eax
  8040c7:	76 07                	jbe    8040d0 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8040c9:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8040d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040d3:	48 63 d0             	movslq %eax,%rdx
  8040d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040d9:	48 63 c8             	movslq %eax,%rcx
  8040dc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8040e3:	48 01 c1             	add    %rax,%rcx
  8040e6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8040ed:	48 89 ce             	mov    %rcx,%rsi
  8040f0:	48 89 c7             	mov    %rax,%rdi
  8040f3:	48 b8 5b 14 80 00 00 	movabs $0x80145b,%rax
  8040fa:	00 00 00 
  8040fd:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8040ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804102:	48 63 d0             	movslq %eax,%rdx
  804105:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80410c:	48 89 d6             	mov    %rdx,%rsi
  80410f:	48 89 c7             	mov    %rax,%rdi
  804112:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  804119:	00 00 00 
  80411c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80411e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804121:	01 45 fc             	add    %eax,-0x4(%rbp)
  804124:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804127:	48 98                	cltq   
  804129:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804130:	0f 82 78 ff ff ff    	jb     8040ae <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804136:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804139:	c9                   	leaveq 
  80413a:	c3                   	retq   

000000000080413b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80413b:	55                   	push   %rbp
  80413c:	48 89 e5             	mov    %rsp,%rbp
  80413f:	48 83 ec 08          	sub    $0x8,%rsp
  804143:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804147:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80414c:	c9                   	leaveq 
  80414d:	c3                   	retq   

000000000080414e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80414e:	55                   	push   %rbp
  80414f:	48 89 e5             	mov    %rsp,%rbp
  804152:	48 83 ec 10          	sub    $0x10,%rsp
  804156:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80415a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80415e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804162:	48 be 62 4c 80 00 00 	movabs $0x804c62,%rsi
  804169:	00 00 00 
  80416c:	48 89 c7             	mov    %rax,%rdi
  80416f:	48 b8 37 11 80 00 00 	movabs $0x801137,%rax
  804176:	00 00 00 
  804179:	ff d0                	callq  *%rax
	return 0;
  80417b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804180:	c9                   	leaveq 
  804181:	c3                   	retq   

0000000000804182 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804182:	55                   	push   %rbp
  804183:	48 89 e5             	mov    %rsp,%rbp
  804186:	48 83 ec 30          	sub    $0x30,%rsp
  80418a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80418e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804192:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  804196:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80419b:	75 08                	jne    8041a5 <ipc_recv+0x23>
  80419d:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8041a4:	ff 
	int res=sys_ipc_recv(pg);
  8041a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041a9:	48 89 c7             	mov    %rax,%rdi
  8041ac:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  8041b3:	00 00 00 
  8041b6:	ff d0                	callq  *%rax
  8041b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  8041bb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8041c0:	74 26                	je     8041e8 <ipc_recv+0x66>
  8041c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041c6:	75 15                	jne    8041dd <ipc_recv+0x5b>
  8041c8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8041cf:	00 00 00 
  8041d2:	48 8b 00             	mov    (%rax),%rax
  8041d5:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  8041db:	eb 05                	jmp    8041e2 <ipc_recv+0x60>
  8041dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8041e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8041e6:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  8041e8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8041ed:	74 26                	je     804215 <ipc_recv+0x93>
  8041ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041f3:	75 15                	jne    80420a <ipc_recv+0x88>
  8041f5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8041fc:	00 00 00 
  8041ff:	48 8b 00             	mov    (%rax),%rax
  804202:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  804208:	eb 05                	jmp    80420f <ipc_recv+0x8d>
  80420a:	b8 00 00 00 00       	mov    $0x0,%eax
  80420f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804213:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  804215:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804219:	75 15                	jne    804230 <ipc_recv+0xae>
  80421b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804222:	00 00 00 
  804225:	48 8b 00             	mov    (%rax),%rax
  804228:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  80422e:	eb 03                	jmp    804233 <ipc_recv+0xb1>
  804230:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  804233:	c9                   	leaveq 
  804234:	c3                   	retq   

0000000000804235 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804235:	55                   	push   %rbp
  804236:	48 89 e5             	mov    %rsp,%rbp
  804239:	48 83 ec 30          	sub    $0x30,%rsp
  80423d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804240:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804243:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804247:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  80424a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80424f:	75 0a                	jne    80425b <ipc_send+0x26>
  804251:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  804258:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  804259:	eb 3e                	jmp    804299 <ipc_send+0x64>
  80425b:	eb 3c                	jmp    804299 <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  80425d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804261:	74 2a                	je     80428d <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  804263:	48 ba 70 4c 80 00 00 	movabs $0x804c70,%rdx
  80426a:	00 00 00 
  80426d:	be 39 00 00 00       	mov    $0x39,%esi
  804272:	48 bf 9b 4c 80 00 00 	movabs $0x804c9b,%rdi
  804279:	00 00 00 
  80427c:	b8 00 00 00 00       	mov    $0x0,%eax
  804281:	48 b9 08 03 80 00 00 	movabs $0x800308,%rcx
  804288:	00 00 00 
  80428b:	ff d1                	callq  *%rcx
		sys_yield();  
  80428d:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  804294:	00 00 00 
  804297:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  804299:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80429c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80429f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8042a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042a6:	89 c7                	mov    %eax,%edi
  8042a8:	48 b8 85 1c 80 00 00 	movabs $0x801c85,%rax
  8042af:	00 00 00 
  8042b2:	ff d0                	callq  *%rax
  8042b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042bb:	78 a0                	js     80425d <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  8042bd:	c9                   	leaveq 
  8042be:	c3                   	retq   

00000000008042bf <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8042bf:	55                   	push   %rbp
  8042c0:	48 89 e5             	mov    %rsp,%rbp
  8042c3:	48 83 ec 10          	sub    $0x10,%rsp
  8042c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  8042cb:	48 ba a8 4c 80 00 00 	movabs $0x804ca8,%rdx
  8042d2:	00 00 00 
  8042d5:	be 47 00 00 00       	mov    $0x47,%esi
  8042da:	48 bf 9b 4c 80 00 00 	movabs $0x804c9b,%rdi
  8042e1:	00 00 00 
  8042e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8042e9:	48 b9 08 03 80 00 00 	movabs $0x800308,%rcx
  8042f0:	00 00 00 
  8042f3:	ff d1                	callq  *%rcx

00000000008042f5 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8042f5:	55                   	push   %rbp
  8042f6:	48 89 e5             	mov    %rsp,%rbp
  8042f9:	48 83 ec 20          	sub    $0x20,%rsp
  8042fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804300:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804303:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  804307:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  80430a:	48 ba d0 4c 80 00 00 	movabs $0x804cd0,%rdx
  804311:	00 00 00 
  804314:	be 50 00 00 00       	mov    $0x50,%esi
  804319:	48 bf 9b 4c 80 00 00 	movabs $0x804c9b,%rdi
  804320:	00 00 00 
  804323:	b8 00 00 00 00       	mov    $0x0,%eax
  804328:	48 b9 08 03 80 00 00 	movabs $0x800308,%rcx
  80432f:	00 00 00 
  804332:	ff d1                	callq  *%rcx

0000000000804334 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804334:	55                   	push   %rbp
  804335:	48 89 e5             	mov    %rsp,%rbp
  804338:	48 83 ec 14          	sub    $0x14,%rsp
  80433c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80433f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804346:	eb 4e                	jmp    804396 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804348:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80434f:	00 00 00 
  804352:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804355:	48 98                	cltq   
  804357:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  80435e:	48 01 d0             	add    %rdx,%rax
  804361:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804367:	8b 00                	mov    (%rax),%eax
  804369:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80436c:	75 24                	jne    804392 <ipc_find_env+0x5e>
			return envs[i].env_id;
  80436e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804375:	00 00 00 
  804378:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80437b:	48 98                	cltq   
  80437d:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  804384:	48 01 d0             	add    %rdx,%rax
  804387:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80438d:	8b 40 08             	mov    0x8(%rax),%eax
  804390:	eb 12                	jmp    8043a4 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804392:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804396:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80439d:	7e a9                	jle    804348 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  80439f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043a4:	c9                   	leaveq 
  8043a5:	c3                   	retq   

00000000008043a6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8043a6:	55                   	push   %rbp
  8043a7:	48 89 e5             	mov    %rsp,%rbp
  8043aa:	48 83 ec 18          	sub    $0x18,%rsp
  8043ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8043b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043b6:	48 c1 e8 15          	shr    $0x15,%rax
  8043ba:	48 89 c2             	mov    %rax,%rdx
  8043bd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8043c4:	01 00 00 
  8043c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043cb:	83 e0 01             	and    $0x1,%eax
  8043ce:	48 85 c0             	test   %rax,%rax
  8043d1:	75 07                	jne    8043da <pageref+0x34>
		return 0;
  8043d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8043d8:	eb 53                	jmp    80442d <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8043da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043de:	48 c1 e8 0c          	shr    $0xc,%rax
  8043e2:	48 89 c2             	mov    %rax,%rdx
  8043e5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8043ec:	01 00 00 
  8043ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8043f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043fb:	83 e0 01             	and    $0x1,%eax
  8043fe:	48 85 c0             	test   %rax,%rax
  804401:	75 07                	jne    80440a <pageref+0x64>
		return 0;
  804403:	b8 00 00 00 00       	mov    $0x0,%eax
  804408:	eb 23                	jmp    80442d <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80440a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80440e:	48 c1 e8 0c          	shr    $0xc,%rax
  804412:	48 89 c2             	mov    %rax,%rdx
  804415:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80441c:	00 00 00 
  80441f:	48 c1 e2 04          	shl    $0x4,%rdx
  804423:	48 01 d0             	add    %rdx,%rax
  804426:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80442a:	0f b7 c0             	movzwl %ax,%eax
}
  80442d:	c9                   	leaveq 
  80442e:	c3                   	retq   
