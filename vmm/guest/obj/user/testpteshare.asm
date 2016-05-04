
vmm/guest/obj/user/testpteshare:     file format elf64-x86-64


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
  80003c:	e8 67 02 00 00       	callq  8002a8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (argc != 0)
  800052:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800056:	74 0c                	je     800064 <umain+0x21>
		childofspawn();
  800058:	48 b8 75 02 80 00 00 	movabs $0x800275,%rax
  80005f:	00 00 00 
  800062:	ff d0                	callq  *%rax

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	ba 07 04 00 00       	mov    $0x407,%edx
  800069:	be 00 00 00 a0       	mov    $0xa0000000,%esi
  80006e:	bf 00 00 00 00       	mov    $0x0,%edi
  800073:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  80007a:	00 00 00 
  80007d:	ff d0                	callq  *%rax
  80007f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800082:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800086:	79 30                	jns    8000b8 <umain+0x75>
		panic("sys_page_alloc: %e", r);
  800088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008b:	89 c1                	mov    %eax,%ecx
  80008d:	48 ba 9e 4f 80 00 00 	movabs $0x804f9e,%rdx
  800094:	00 00 00 
  800097:	be 13 00 00 00       	mov    $0x13,%esi
  80009c:	48 bf b1 4f 80 00 00 	movabs $0x804fb1,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8000b2:	00 00 00 
  8000b5:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b8:	48 b8 79 23 80 00 00 	movabs $0x802379,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("fork: %e", r);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba c5 4f 80 00 00 	movabs $0x804fc5,%rdx
  8000d9:	00 00 00 
  8000dc:	be 17 00 00 00       	mov    $0x17,%esi
  8000e1:	48 bf b1 4f 80 00 00 	movabs $0x804fb1,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800101:	75 2d                	jne    800130 <umain+0xed>
		strcpy(VA, msg);
  800103:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80010a:	00 00 00 
  80010d:	48 8b 00             	mov    (%rax),%rax
  800110:	48 89 c6             	mov    %rax,%rsi
  800113:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800118:	48 b8 7d 11 80 00 00 	movabs $0x80117d,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
		exit();
  800124:	48 b8 2b 03 80 00 00 	movabs $0x80032b,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
	}
	wait(r);
  800130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800133:	89 c7                	mov    %eax,%edi
  800135:	48 b8 53 48 80 00 00 	movabs $0x804853,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  800141:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800148:	00 00 00 
  80014b:	48 8b 00             	mov    (%rax),%rax
  80014e:	48 89 c6             	mov    %rax,%rsi
  800151:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800156:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	85 c0                	test   %eax,%eax
  800164:	75 0c                	jne    800172 <umain+0x12f>
  800166:	48 b8 ce 4f 80 00 00 	movabs $0x804fce,%rax
  80016d:	00 00 00 
  800170:	eb 0a                	jmp    80017c <umain+0x139>
  800172:	48 b8 d4 4f 80 00 00 	movabs $0x804fd4,%rax
  800179:	00 00 00 
  80017c:	48 89 c6             	mov    %rax,%rsi
  80017f:	48 bf da 4f 80 00 00 	movabs $0x804fda,%rdi
  800186:	00 00 00 
  800189:	b8 00 00 00 00       	mov    $0x0,%eax
  80018e:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  800195:	00 00 00 
  800198:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019f:	48 ba f5 4f 80 00 00 	movabs $0x804ff5,%rdx
  8001a6:	00 00 00 
  8001a9:	48 be f9 4f 80 00 00 	movabs $0x804ff9,%rsi
  8001b0:	00 00 00 
  8001b3:	48 bf 06 50 80 00 00 	movabs $0x805006,%rdi
  8001ba:	00 00 00 
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c2:	49 b8 3c 3a 80 00 00 	movabs $0x803a3c,%r8
  8001c9:	00 00 00 
  8001cc:	41 ff d0             	callq  *%r8
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d6:	79 30                	jns    800208 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	89 c1                	mov    %eax,%ecx
  8001dd:	48 ba 18 50 80 00 00 	movabs $0x805018,%rdx
  8001e4:	00 00 00 
  8001e7:	be 21 00 00 00       	mov    $0x21,%esi
  8001ec:	48 bf b1 4f 80 00 00 	movabs $0x804fb1,%rdi
  8001f3:	00 00 00 
  8001f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fb:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  800202:	00 00 00 
  800205:	41 ff d0             	callq  *%r8
	wait(r);
  800208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020b:	89 c7                	mov    %eax,%edi
  80020d:	48 b8 53 48 80 00 00 	movabs $0x804853,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800219:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800220:	00 00 00 
  800223:	48 8b 00             	mov    (%rax),%rax
  800226:	48 89 c6             	mov    %rax,%rsi
  800229:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80022e:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
  80023a:	85 c0                	test   %eax,%eax
  80023c:	75 0c                	jne    80024a <umain+0x207>
  80023e:	48 b8 ce 4f 80 00 00 	movabs $0x804fce,%rax
  800245:	00 00 00 
  800248:	eb 0a                	jmp    800254 <umain+0x211>
  80024a:	48 b8 d4 4f 80 00 00 	movabs $0x804fd4,%rax
  800251:	00 00 00 
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 bf 22 50 80 00 00 	movabs $0x805022,%rdi
  80025e:	00 00 00 
  800261:	b8 00 00 00 00       	mov    $0x0,%eax
  800266:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  80026d:	00 00 00 
  800270:	ff d2                	callq  *%rdx


    static __inline void
breakpoint(void)
{
    __asm __volatile("int3");
  800272:	cc                   	int3   

	breakpoint();
}
  800273:	c9                   	leaveq 
  800274:	c3                   	retq   

0000000000800275 <childofspawn>:

void
childofspawn(void)
{
  800275:	55                   	push   %rbp
  800276:	48 89 e5             	mov    %rsp,%rbp
	strcpy(VA, msg2);
  800279:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800280:	00 00 00 
  800283:	48 8b 00             	mov    (%rax),%rax
  800286:	48 89 c6             	mov    %rax,%rsi
  800289:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80028e:	48 b8 7d 11 80 00 00 	movabs $0x80117d,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	exit();
  80029a:	48 b8 2b 03 80 00 00 	movabs $0x80032b,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
}
  8002a6:	5d                   	pop    %rbp
  8002a7:	c3                   	retq   

00000000008002a8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	48 83 ec 10          	sub    $0x10,%rsp
  8002b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  8002b7:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
  8002c3:	48 98                	cltq   
  8002c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002ca:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8002d1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8002d8:	00 00 00 
  8002db:	48 01 c2             	add    %rax,%rdx
  8002de:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002e5:	00 00 00 
  8002e8:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002ef:	7e 14                	jle    800305 <libmain+0x5d>
		binaryname = argv[0];
  8002f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f5:	48 8b 10             	mov    (%rax),%rdx
  8002f8:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8002ff:	00 00 00 
  800302:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800305:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800309:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030c:	48 89 d6             	mov    %rdx,%rsi
  80030f:	89 c7                	mov    %eax,%edi
  800311:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800318:	00 00 00 
  80031b:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80031d:	48 b8 2b 03 80 00 00 	movabs $0x80032b,%rax
  800324:	00 00 00 
  800327:	ff d0                	callq  *%rax
}
  800329:	c9                   	leaveq 
  80032a:	c3                   	retq   

000000000080032b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80032b:	55                   	push   %rbp
  80032c:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80032f:	48 b8 c6 2a 80 00 00 	movabs $0x802ac6,%rax
  800336:	00 00 00 
  800339:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80033b:	bf 00 00 00 00       	mov    $0x0,%edi
  800340:	48 b8 ec 19 80 00 00 	movabs $0x8019ec,%rax
  800347:	00 00 00 
  80034a:	ff d0                	callq  *%rax
}
  80034c:	5d                   	pop    %rbp
  80034d:	c3                   	retq   

000000000080034e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80034e:	55                   	push   %rbp
  80034f:	48 89 e5             	mov    %rsp,%rbp
  800352:	53                   	push   %rbx
  800353:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80035a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800361:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800367:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80036e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800375:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80037c:	84 c0                	test   %al,%al
  80037e:	74 23                	je     8003a3 <_panic+0x55>
  800380:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800387:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80038b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80038f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800393:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800397:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80039b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80039f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003a3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003aa:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003b1:	00 00 00 
  8003b4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003bb:	00 00 00 
  8003be:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003c2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003c9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003d0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003d7:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8003de:	00 00 00 
  8003e1:	48 8b 18             	mov    (%rax),%rbx
  8003e4:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  8003eb:	00 00 00 
  8003ee:	ff d0                	callq  *%rax
  8003f0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003f6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003fd:	41 89 c8             	mov    %ecx,%r8d
  800400:	48 89 d1             	mov    %rdx,%rcx
  800403:	48 89 da             	mov    %rbx,%rdx
  800406:	89 c6                	mov    %eax,%esi
  800408:	48 bf 48 50 80 00 00 	movabs $0x805048,%rdi
  80040f:	00 00 00 
  800412:	b8 00 00 00 00       	mov    $0x0,%eax
  800417:	49 b9 87 05 80 00 00 	movabs $0x800587,%r9
  80041e:	00 00 00 
  800421:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800424:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80042b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800432:	48 89 d6             	mov    %rdx,%rsi
  800435:	48 89 c7             	mov    %rax,%rdi
  800438:	48 b8 db 04 80 00 00 	movabs $0x8004db,%rax
  80043f:	00 00 00 
  800442:	ff d0                	callq  *%rax
	cprintf("\n");
  800444:	48 bf 6b 50 80 00 00 	movabs $0x80506b,%rdi
  80044b:	00 00 00 
  80044e:	b8 00 00 00 00       	mov    $0x0,%eax
  800453:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  80045a:	00 00 00 
  80045d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80045f:	cc                   	int3   
  800460:	eb fd                	jmp    80045f <_panic+0x111>

0000000000800462 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800462:	55                   	push   %rbp
  800463:	48 89 e5             	mov    %rsp,%rbp
  800466:	48 83 ec 10          	sub    $0x10,%rsp
  80046a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80046d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800471:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800475:	8b 00                	mov    (%rax),%eax
  800477:	8d 48 01             	lea    0x1(%rax),%ecx
  80047a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80047e:	89 0a                	mov    %ecx,(%rdx)
  800480:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800483:	89 d1                	mov    %edx,%ecx
  800485:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800489:	48 98                	cltq   
  80048b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80048f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800493:	8b 00                	mov    (%rax),%eax
  800495:	3d ff 00 00 00       	cmp    $0xff,%eax
  80049a:	75 2c                	jne    8004c8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80049c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a0:	8b 00                	mov    (%rax),%eax
  8004a2:	48 98                	cltq   
  8004a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a8:	48 83 c2 08          	add    $0x8,%rdx
  8004ac:	48 89 c6             	mov    %rax,%rsi
  8004af:	48 89 d7             	mov    %rdx,%rdi
  8004b2:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  8004b9:	00 00 00 
  8004bc:	ff d0                	callq  *%rax
        b->idx = 0;
  8004be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004cc:	8b 40 04             	mov    0x4(%rax),%eax
  8004cf:	8d 50 01             	lea    0x1(%rax),%edx
  8004d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8004d9:	c9                   	leaveq 
  8004da:	c3                   	retq   

00000000008004db <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8004db:	55                   	push   %rbp
  8004dc:	48 89 e5             	mov    %rsp,%rbp
  8004df:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004e6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004ed:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004f4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004fb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800502:	48 8b 0a             	mov    (%rdx),%rcx
  800505:	48 89 08             	mov    %rcx,(%rax)
  800508:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80050c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800510:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800514:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800518:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80051f:	00 00 00 
    b.cnt = 0;
  800522:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800529:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80052c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800533:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80053a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800541:	48 89 c6             	mov    %rax,%rsi
  800544:	48 bf 62 04 80 00 00 	movabs $0x800462,%rdi
  80054b:	00 00 00 
  80054e:	48 b8 3a 09 80 00 00 	movabs $0x80093a,%rax
  800555:	00 00 00 
  800558:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80055a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800560:	48 98                	cltq   
  800562:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800569:	48 83 c2 08          	add    $0x8,%rdx
  80056d:	48 89 c6             	mov    %rax,%rsi
  800570:	48 89 d7             	mov    %rdx,%rdi
  800573:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  80057a:	00 00 00 
  80057d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80057f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800585:	c9                   	leaveq 
  800586:	c3                   	retq   

0000000000800587 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800587:	55                   	push   %rbp
  800588:	48 89 e5             	mov    %rsp,%rbp
  80058b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800592:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800599:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005a0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005a7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005ae:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005b5:	84 c0                	test   %al,%al
  8005b7:	74 20                	je     8005d9 <cprintf+0x52>
  8005b9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005bd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005c1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005c5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005c9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005cd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8005d1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8005d5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8005d9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8005e0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005e7:	00 00 00 
  8005ea:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005f1:	00 00 00 
  8005f4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005f8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005ff:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800606:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80060d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800614:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80061b:	48 8b 0a             	mov    (%rdx),%rcx
  80061e:	48 89 08             	mov    %rcx,(%rax)
  800621:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800625:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800629:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80062d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800631:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800638:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80063f:	48 89 d6             	mov    %rdx,%rsi
  800642:	48 89 c7             	mov    %rax,%rdi
  800645:	48 b8 db 04 80 00 00 	movabs $0x8004db,%rax
  80064c:	00 00 00 
  80064f:	ff d0                	callq  *%rax
  800651:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800657:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80065d:	c9                   	leaveq 
  80065e:	c3                   	retq   

000000000080065f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80065f:	55                   	push   %rbp
  800660:	48 89 e5             	mov    %rsp,%rbp
  800663:	53                   	push   %rbx
  800664:	48 83 ec 38          	sub    $0x38,%rsp
  800668:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80066c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800670:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800674:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800677:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80067b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80067f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800682:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800686:	77 3b                	ja     8006c3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800688:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80068b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80068f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800692:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800696:	ba 00 00 00 00       	mov    $0x0,%edx
  80069b:	48 f7 f3             	div    %rbx
  80069e:	48 89 c2             	mov    %rax,%rdx
  8006a1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006a4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006a7:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006af:	41 89 f9             	mov    %edi,%r9d
  8006b2:	48 89 c7             	mov    %rax,%rdi
  8006b5:	48 b8 5f 06 80 00 00 	movabs $0x80065f,%rax
  8006bc:	00 00 00 
  8006bf:	ff d0                	callq  *%rax
  8006c1:	eb 1e                	jmp    8006e1 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006c3:	eb 12                	jmp    8006d7 <printnum+0x78>
			putch(padc, putdat);
  8006c5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006c9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8006cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d0:	48 89 ce             	mov    %rcx,%rsi
  8006d3:	89 d7                	mov    %edx,%edi
  8006d5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d7:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8006db:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8006df:	7f e4                	jg     8006c5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006e1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ed:	48 f7 f1             	div    %rcx
  8006f0:	48 89 d0             	mov    %rdx,%rax
  8006f3:	48 ba 70 52 80 00 00 	movabs $0x805270,%rdx
  8006fa:	00 00 00 
  8006fd:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800701:	0f be d0             	movsbl %al,%edx
  800704:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070c:	48 89 ce             	mov    %rcx,%rsi
  80070f:	89 d7                	mov    %edx,%edi
  800711:	ff d0                	callq  *%rax
}
  800713:	48 83 c4 38          	add    $0x38,%rsp
  800717:	5b                   	pop    %rbx
  800718:	5d                   	pop    %rbp
  800719:	c3                   	retq   

000000000080071a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80071a:	55                   	push   %rbp
  80071b:	48 89 e5             	mov    %rsp,%rbp
  80071e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800722:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800726:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800729:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80072d:	7e 52                	jle    800781 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80072f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800733:	8b 00                	mov    (%rax),%eax
  800735:	83 f8 30             	cmp    $0x30,%eax
  800738:	73 24                	jae    80075e <getuint+0x44>
  80073a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800746:	8b 00                	mov    (%rax),%eax
  800748:	89 c0                	mov    %eax,%eax
  80074a:	48 01 d0             	add    %rdx,%rax
  80074d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800751:	8b 12                	mov    (%rdx),%edx
  800753:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800756:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075a:	89 0a                	mov    %ecx,(%rdx)
  80075c:	eb 17                	jmp    800775 <getuint+0x5b>
  80075e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800762:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800766:	48 89 d0             	mov    %rdx,%rax
  800769:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800771:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800775:	48 8b 00             	mov    (%rax),%rax
  800778:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80077c:	e9 a3 00 00 00       	jmpq   800824 <getuint+0x10a>
	else if (lflag)
  800781:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800785:	74 4f                	je     8007d6 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800787:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078b:	8b 00                	mov    (%rax),%eax
  80078d:	83 f8 30             	cmp    $0x30,%eax
  800790:	73 24                	jae    8007b6 <getuint+0x9c>
  800792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800796:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80079a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079e:	8b 00                	mov    (%rax),%eax
  8007a0:	89 c0                	mov    %eax,%eax
  8007a2:	48 01 d0             	add    %rdx,%rax
  8007a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a9:	8b 12                	mov    (%rdx),%edx
  8007ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b2:	89 0a                	mov    %ecx,(%rdx)
  8007b4:	eb 17                	jmp    8007cd <getuint+0xb3>
  8007b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007be:	48 89 d0             	mov    %rdx,%rax
  8007c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007cd:	48 8b 00             	mov    (%rax),%rax
  8007d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007d4:	eb 4e                	jmp    800824 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8007d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007da:	8b 00                	mov    (%rax),%eax
  8007dc:	83 f8 30             	cmp    $0x30,%eax
  8007df:	73 24                	jae    800805 <getuint+0xeb>
  8007e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ed:	8b 00                	mov    (%rax),%eax
  8007ef:	89 c0                	mov    %eax,%eax
  8007f1:	48 01 d0             	add    %rdx,%rax
  8007f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f8:	8b 12                	mov    (%rdx),%edx
  8007fa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800801:	89 0a                	mov    %ecx,(%rdx)
  800803:	eb 17                	jmp    80081c <getuint+0x102>
  800805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800809:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80080d:	48 89 d0             	mov    %rdx,%rax
  800810:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800814:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800818:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80081c:	8b 00                	mov    (%rax),%eax
  80081e:	89 c0                	mov    %eax,%eax
  800820:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800824:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800828:	c9                   	leaveq 
  800829:	c3                   	retq   

000000000080082a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80082a:	55                   	push   %rbp
  80082b:	48 89 e5             	mov    %rsp,%rbp
  80082e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800832:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800836:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800839:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80083d:	7e 52                	jle    800891 <getint+0x67>
		x=va_arg(*ap, long long);
  80083f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800843:	8b 00                	mov    (%rax),%eax
  800845:	83 f8 30             	cmp    $0x30,%eax
  800848:	73 24                	jae    80086e <getint+0x44>
  80084a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800856:	8b 00                	mov    (%rax),%eax
  800858:	89 c0                	mov    %eax,%eax
  80085a:	48 01 d0             	add    %rdx,%rax
  80085d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800861:	8b 12                	mov    (%rdx),%edx
  800863:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800866:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086a:	89 0a                	mov    %ecx,(%rdx)
  80086c:	eb 17                	jmp    800885 <getint+0x5b>
  80086e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800872:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800876:	48 89 d0             	mov    %rdx,%rax
  800879:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800881:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800885:	48 8b 00             	mov    (%rax),%rax
  800888:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80088c:	e9 a3 00 00 00       	jmpq   800934 <getint+0x10a>
	else if (lflag)
  800891:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800895:	74 4f                	je     8008e6 <getint+0xbc>
		x=va_arg(*ap, long);
  800897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089b:	8b 00                	mov    (%rax),%eax
  80089d:	83 f8 30             	cmp    $0x30,%eax
  8008a0:	73 24                	jae    8008c6 <getint+0x9c>
  8008a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ae:	8b 00                	mov    (%rax),%eax
  8008b0:	89 c0                	mov    %eax,%eax
  8008b2:	48 01 d0             	add    %rdx,%rax
  8008b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b9:	8b 12                	mov    (%rdx),%edx
  8008bb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c2:	89 0a                	mov    %ecx,(%rdx)
  8008c4:	eb 17                	jmp    8008dd <getint+0xb3>
  8008c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ca:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ce:	48 89 d0             	mov    %rdx,%rax
  8008d1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008dd:	48 8b 00             	mov    (%rax),%rax
  8008e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008e4:	eb 4e                	jmp    800934 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ea:	8b 00                	mov    (%rax),%eax
  8008ec:	83 f8 30             	cmp    $0x30,%eax
  8008ef:	73 24                	jae    800915 <getint+0xeb>
  8008f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fd:	8b 00                	mov    (%rax),%eax
  8008ff:	89 c0                	mov    %eax,%eax
  800901:	48 01 d0             	add    %rdx,%rax
  800904:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800908:	8b 12                	mov    (%rdx),%edx
  80090a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80090d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800911:	89 0a                	mov    %ecx,(%rdx)
  800913:	eb 17                	jmp    80092c <getint+0x102>
  800915:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800919:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80091d:	48 89 d0             	mov    %rdx,%rax
  800920:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800924:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800928:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80092c:	8b 00                	mov    (%rax),%eax
  80092e:	48 98                	cltq   
  800930:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800934:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800938:	c9                   	leaveq 
  800939:	c3                   	retq   

000000000080093a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80093a:	55                   	push   %rbp
  80093b:	48 89 e5             	mov    %rsp,%rbp
  80093e:	41 54                	push   %r12
  800940:	53                   	push   %rbx
  800941:	48 83 ec 60          	sub    $0x60,%rsp
  800945:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800949:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80094d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800951:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800955:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800959:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80095d:	48 8b 0a             	mov    (%rdx),%rcx
  800960:	48 89 08             	mov    %rcx,(%rax)
  800963:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800967:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80096b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80096f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800973:	eb 28                	jmp    80099d <vprintfmt+0x63>
			if (ch == '\0'){
  800975:	85 db                	test   %ebx,%ebx
  800977:	75 15                	jne    80098e <vprintfmt+0x54>
				current_color=WHITE;
  800979:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800980:	00 00 00 
  800983:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800989:	e9 fc 04 00 00       	jmpq   800e8a <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  80098e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800992:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800996:	48 89 d6             	mov    %rdx,%rsi
  800999:	89 df                	mov    %ebx,%edi
  80099b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009a1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009a5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009a9:	0f b6 00             	movzbl (%rax),%eax
  8009ac:	0f b6 d8             	movzbl %al,%ebx
  8009af:	83 fb 25             	cmp    $0x25,%ebx
  8009b2:	75 c1                	jne    800975 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b4:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009b8:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009bf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009cd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009dc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009e0:	0f b6 00             	movzbl (%rax),%eax
  8009e3:	0f b6 d8             	movzbl %al,%ebx
  8009e6:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009e9:	83 f8 55             	cmp    $0x55,%eax
  8009ec:	0f 87 64 04 00 00    	ja     800e56 <vprintfmt+0x51c>
  8009f2:	89 c0                	mov    %eax,%eax
  8009f4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009fb:	00 
  8009fc:	48 b8 98 52 80 00 00 	movabs $0x805298,%rax
  800a03:	00 00 00 
  800a06:	48 01 d0             	add    %rdx,%rax
  800a09:	48 8b 00             	mov    (%rax),%rax
  800a0c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a0e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a12:	eb c0                	jmp    8009d4 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a14:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a18:	eb ba                	jmp    8009d4 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a1a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a21:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a24:	89 d0                	mov    %edx,%eax
  800a26:	c1 e0 02             	shl    $0x2,%eax
  800a29:	01 d0                	add    %edx,%eax
  800a2b:	01 c0                	add    %eax,%eax
  800a2d:	01 d8                	add    %ebx,%eax
  800a2f:	83 e8 30             	sub    $0x30,%eax
  800a32:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a35:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a39:	0f b6 00             	movzbl (%rax),%eax
  800a3c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a3f:	83 fb 2f             	cmp    $0x2f,%ebx
  800a42:	7e 0c                	jle    800a50 <vprintfmt+0x116>
  800a44:	83 fb 39             	cmp    $0x39,%ebx
  800a47:	7f 07                	jg     800a50 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a49:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a4e:	eb d1                	jmp    800a21 <vprintfmt+0xe7>
			goto process_precision;
  800a50:	eb 58                	jmp    800aaa <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800a52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a55:	83 f8 30             	cmp    $0x30,%eax
  800a58:	73 17                	jae    800a71 <vprintfmt+0x137>
  800a5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a61:	89 c0                	mov    %eax,%eax
  800a63:	48 01 d0             	add    %rdx,%rax
  800a66:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a69:	83 c2 08             	add    $0x8,%edx
  800a6c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a6f:	eb 0f                	jmp    800a80 <vprintfmt+0x146>
  800a71:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a75:	48 89 d0             	mov    %rdx,%rax
  800a78:	48 83 c2 08          	add    $0x8,%rdx
  800a7c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a80:	8b 00                	mov    (%rax),%eax
  800a82:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a85:	eb 23                	jmp    800aaa <vprintfmt+0x170>

		case '.':
			if (width < 0)
  800a87:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a8b:	79 0c                	jns    800a99 <vprintfmt+0x15f>
				width = 0;
  800a8d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a94:	e9 3b ff ff ff       	jmpq   8009d4 <vprintfmt+0x9a>
  800a99:	e9 36 ff ff ff       	jmpq   8009d4 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  800a9e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800aa5:	e9 2a ff ff ff       	jmpq   8009d4 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  800aaa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aae:	79 12                	jns    800ac2 <vprintfmt+0x188>
				width = precision, precision = -1;
  800ab0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ab3:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ab6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800abd:	e9 12 ff ff ff       	jmpq   8009d4 <vprintfmt+0x9a>
  800ac2:	e9 0d ff ff ff       	jmpq   8009d4 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ac7:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800acb:	e9 04 ff ff ff       	jmpq   8009d4 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ad0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad3:	83 f8 30             	cmp    $0x30,%eax
  800ad6:	73 17                	jae    800aef <vprintfmt+0x1b5>
  800ad8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800adc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adf:	89 c0                	mov    %eax,%eax
  800ae1:	48 01 d0             	add    %rdx,%rax
  800ae4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae7:	83 c2 08             	add    $0x8,%edx
  800aea:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aed:	eb 0f                	jmp    800afe <vprintfmt+0x1c4>
  800aef:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800af3:	48 89 d0             	mov    %rdx,%rax
  800af6:	48 83 c2 08          	add    $0x8,%rdx
  800afa:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800afe:	8b 10                	mov    (%rax),%edx
  800b00:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b08:	48 89 ce             	mov    %rcx,%rsi
  800b0b:	89 d7                	mov    %edx,%edi
  800b0d:	ff d0                	callq  *%rax
			break;
  800b0f:	e9 70 03 00 00       	jmpq   800e84 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b14:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b17:	83 f8 30             	cmp    $0x30,%eax
  800b1a:	73 17                	jae    800b33 <vprintfmt+0x1f9>
  800b1c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b20:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b23:	89 c0                	mov    %eax,%eax
  800b25:	48 01 d0             	add    %rdx,%rax
  800b28:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b2b:	83 c2 08             	add    $0x8,%edx
  800b2e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b31:	eb 0f                	jmp    800b42 <vprintfmt+0x208>
  800b33:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b37:	48 89 d0             	mov    %rdx,%rax
  800b3a:	48 83 c2 08          	add    $0x8,%rdx
  800b3e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b42:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b44:	85 db                	test   %ebx,%ebx
  800b46:	79 02                	jns    800b4a <vprintfmt+0x210>
				err = -err;
  800b48:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b4a:	83 fb 15             	cmp    $0x15,%ebx
  800b4d:	7f 16                	jg     800b65 <vprintfmt+0x22b>
  800b4f:	48 b8 c0 51 80 00 00 	movabs $0x8051c0,%rax
  800b56:	00 00 00 
  800b59:	48 63 d3             	movslq %ebx,%rdx
  800b5c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b60:	4d 85 e4             	test   %r12,%r12
  800b63:	75 2e                	jne    800b93 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  800b65:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b69:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6d:	89 d9                	mov    %ebx,%ecx
  800b6f:	48 ba 81 52 80 00 00 	movabs $0x805281,%rdx
  800b76:	00 00 00 
  800b79:	48 89 c7             	mov    %rax,%rdi
  800b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b81:	49 b8 93 0e 80 00 00 	movabs $0x800e93,%r8
  800b88:	00 00 00 
  800b8b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b8e:	e9 f1 02 00 00       	jmpq   800e84 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b93:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9b:	4c 89 e1             	mov    %r12,%rcx
  800b9e:	48 ba 8a 52 80 00 00 	movabs $0x80528a,%rdx
  800ba5:	00 00 00 
  800ba8:	48 89 c7             	mov    %rax,%rdi
  800bab:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb0:	49 b8 93 0e 80 00 00 	movabs $0x800e93,%r8
  800bb7:	00 00 00 
  800bba:	41 ff d0             	callq  *%r8
			break;
  800bbd:	e9 c2 02 00 00       	jmpq   800e84 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bc2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc5:	83 f8 30             	cmp    $0x30,%eax
  800bc8:	73 17                	jae    800be1 <vprintfmt+0x2a7>
  800bca:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd1:	89 c0                	mov    %eax,%eax
  800bd3:	48 01 d0             	add    %rdx,%rax
  800bd6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd9:	83 c2 08             	add    $0x8,%edx
  800bdc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bdf:	eb 0f                	jmp    800bf0 <vprintfmt+0x2b6>
  800be1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be5:	48 89 d0             	mov    %rdx,%rax
  800be8:	48 83 c2 08          	add    $0x8,%rdx
  800bec:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bf0:	4c 8b 20             	mov    (%rax),%r12
  800bf3:	4d 85 e4             	test   %r12,%r12
  800bf6:	75 0a                	jne    800c02 <vprintfmt+0x2c8>
				p = "(null)";
  800bf8:	49 bc 8d 52 80 00 00 	movabs $0x80528d,%r12
  800bff:	00 00 00 
			if (width > 0 && padc != '-')
  800c02:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c06:	7e 3f                	jle    800c47 <vprintfmt+0x30d>
  800c08:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c0c:	74 39                	je     800c47 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c0e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c11:	48 98                	cltq   
  800c13:	48 89 c6             	mov    %rax,%rsi
  800c16:	4c 89 e7             	mov    %r12,%rdi
  800c19:	48 b8 3f 11 80 00 00 	movabs $0x80113f,%rax
  800c20:	00 00 00 
  800c23:	ff d0                	callq  *%rax
  800c25:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c28:	eb 17                	jmp    800c41 <vprintfmt+0x307>
					putch(padc, putdat);
  800c2a:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c2e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c36:	48 89 ce             	mov    %rcx,%rsi
  800c39:	89 d7                	mov    %edx,%edi
  800c3b:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c3d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c41:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c45:	7f e3                	jg     800c2a <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c47:	eb 37                	jmp    800c80 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  800c49:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c4d:	74 1e                	je     800c6d <vprintfmt+0x333>
  800c4f:	83 fb 1f             	cmp    $0x1f,%ebx
  800c52:	7e 05                	jle    800c59 <vprintfmt+0x31f>
  800c54:	83 fb 7e             	cmp    $0x7e,%ebx
  800c57:	7e 14                	jle    800c6d <vprintfmt+0x333>
					putch('?', putdat);
  800c59:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c61:	48 89 d6             	mov    %rdx,%rsi
  800c64:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c69:	ff d0                	callq  *%rax
  800c6b:	eb 0f                	jmp    800c7c <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800c6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c75:	48 89 d6             	mov    %rdx,%rsi
  800c78:	89 df                	mov    %ebx,%edi
  800c7a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c7c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c80:	4c 89 e0             	mov    %r12,%rax
  800c83:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c87:	0f b6 00             	movzbl (%rax),%eax
  800c8a:	0f be d8             	movsbl %al,%ebx
  800c8d:	85 db                	test   %ebx,%ebx
  800c8f:	74 10                	je     800ca1 <vprintfmt+0x367>
  800c91:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c95:	78 b2                	js     800c49 <vprintfmt+0x30f>
  800c97:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c9b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c9f:	79 a8                	jns    800c49 <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ca1:	eb 16                	jmp    800cb9 <vprintfmt+0x37f>
				putch(' ', putdat);
  800ca3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cab:	48 89 d6             	mov    %rdx,%rsi
  800cae:	bf 20 00 00 00       	mov    $0x20,%edi
  800cb3:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cb5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cb9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cbd:	7f e4                	jg     800ca3 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800cbf:	e9 c0 01 00 00       	jmpq   800e84 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cc4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cc8:	be 03 00 00 00       	mov    $0x3,%esi
  800ccd:	48 89 c7             	mov    %rax,%rdi
  800cd0:	48 b8 2a 08 80 00 00 	movabs $0x80082a,%rax
  800cd7:	00 00 00 
  800cda:	ff d0                	callq  *%rax
  800cdc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ce0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce4:	48 85 c0             	test   %rax,%rax
  800ce7:	79 1d                	jns    800d06 <vprintfmt+0x3cc>
				putch('-', putdat);
  800ce9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ced:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf1:	48 89 d6             	mov    %rdx,%rsi
  800cf4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cf9:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cff:	48 f7 d8             	neg    %rax
  800d02:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d06:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d0d:	e9 d5 00 00 00       	jmpq   800de7 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d12:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d16:	be 03 00 00 00       	mov    $0x3,%esi
  800d1b:	48 89 c7             	mov    %rax,%rdi
  800d1e:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800d25:	00 00 00 
  800d28:	ff d0                	callq  *%rax
  800d2a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d2e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d35:	e9 ad 00 00 00       	jmpq   800de7 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800d3a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d3e:	be 03 00 00 00       	mov    $0x3,%esi
  800d43:	48 89 c7             	mov    %rax,%rdi
  800d46:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800d4d:	00 00 00 
  800d50:	ff d0                	callq  *%rax
  800d52:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800d56:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d5d:	e9 85 00 00 00       	jmpq   800de7 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800d62:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6a:	48 89 d6             	mov    %rdx,%rsi
  800d6d:	bf 30 00 00 00       	mov    $0x30,%edi
  800d72:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d74:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7c:	48 89 d6             	mov    %rdx,%rsi
  800d7f:	bf 78 00 00 00       	mov    $0x78,%edi
  800d84:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d86:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d89:	83 f8 30             	cmp    $0x30,%eax
  800d8c:	73 17                	jae    800da5 <vprintfmt+0x46b>
  800d8e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d92:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d95:	89 c0                	mov    %eax,%eax
  800d97:	48 01 d0             	add    %rdx,%rax
  800d9a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d9d:	83 c2 08             	add    $0x8,%edx
  800da0:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800da3:	eb 0f                	jmp    800db4 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  800da5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da9:	48 89 d0             	mov    %rdx,%rax
  800dac:	48 83 c2 08          	add    $0x8,%rdx
  800db0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800db4:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800db7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800dbb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800dc2:	eb 23                	jmp    800de7 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800dc4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dc8:	be 03 00 00 00       	mov    $0x3,%esi
  800dcd:	48 89 c7             	mov    %rax,%rdi
  800dd0:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800dd7:	00 00 00 
  800dda:	ff d0                	callq  *%rax
  800ddc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800de0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800de7:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800dec:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800def:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800df2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800df6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dfa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfe:	45 89 c1             	mov    %r8d,%r9d
  800e01:	41 89 f8             	mov    %edi,%r8d
  800e04:	48 89 c7             	mov    %rax,%rdi
  800e07:	48 b8 5f 06 80 00 00 	movabs $0x80065f,%rax
  800e0e:	00 00 00 
  800e11:	ff d0                	callq  *%rax
			break;
  800e13:	eb 6f                	jmp    800e84 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1d:	48 89 d6             	mov    %rdx,%rsi
  800e20:	89 df                	mov    %ebx,%edi
  800e22:	ff d0                	callq  *%rax
			break;
  800e24:	eb 5e                	jmp    800e84 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  800e26:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e2a:	be 03 00 00 00       	mov    $0x3,%esi
  800e2f:	48 89 c7             	mov    %rax,%rdi
  800e32:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800e39:	00 00 00 
  800e3c:	ff d0                	callq  *%rax
  800e3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  800e42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e46:	89 c2                	mov    %eax,%edx
  800e48:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800e4f:	00 00 00 
  800e52:	89 10                	mov    %edx,(%rax)
			break;
  800e54:	eb 2e                	jmp    800e84 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e56:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5e:	48 89 d6             	mov    %rdx,%rsi
  800e61:	bf 25 00 00 00       	mov    $0x25,%edi
  800e66:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e68:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e6d:	eb 05                	jmp    800e74 <vprintfmt+0x53a>
  800e6f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e74:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e78:	48 83 e8 01          	sub    $0x1,%rax
  800e7c:	0f b6 00             	movzbl (%rax),%eax
  800e7f:	3c 25                	cmp    $0x25,%al
  800e81:	75 ec                	jne    800e6f <vprintfmt+0x535>
				/* do nothing */;
			break;
  800e83:	90                   	nop
		}
	}
  800e84:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e85:	e9 13 fb ff ff       	jmpq   80099d <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e8a:	48 83 c4 60          	add    $0x60,%rsp
  800e8e:	5b                   	pop    %rbx
  800e8f:	41 5c                	pop    %r12
  800e91:	5d                   	pop    %rbp
  800e92:	c3                   	retq   

0000000000800e93 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e93:	55                   	push   %rbp
  800e94:	48 89 e5             	mov    %rsp,%rbp
  800e97:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e9e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ea5:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800eac:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800eb3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800eba:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ec1:	84 c0                	test   %al,%al
  800ec3:	74 20                	je     800ee5 <printfmt+0x52>
  800ec5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ec9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ecd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ed1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ed5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ed9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800edd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ee1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ee5:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800eec:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ef3:	00 00 00 
  800ef6:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800efd:	00 00 00 
  800f00:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f04:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f0b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f12:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f19:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f20:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f27:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f2e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f35:	48 89 c7             	mov    %rax,%rdi
  800f38:	48 b8 3a 09 80 00 00 	movabs $0x80093a,%rax
  800f3f:	00 00 00 
  800f42:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f44:	c9                   	leaveq 
  800f45:	c3                   	retq   

0000000000800f46 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f46:	55                   	push   %rbp
  800f47:	48 89 e5             	mov    %rsp,%rbp
  800f4a:	48 83 ec 10          	sub    $0x10,%rsp
  800f4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f59:	8b 40 10             	mov    0x10(%rax),%eax
  800f5c:	8d 50 01             	lea    0x1(%rax),%edx
  800f5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f63:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6a:	48 8b 10             	mov    (%rax),%rdx
  800f6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f71:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f75:	48 39 c2             	cmp    %rax,%rdx
  800f78:	73 17                	jae    800f91 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f7e:	48 8b 00             	mov    (%rax),%rax
  800f81:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f89:	48 89 0a             	mov    %rcx,(%rdx)
  800f8c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f8f:	88 10                	mov    %dl,(%rax)
}
  800f91:	c9                   	leaveq 
  800f92:	c3                   	retq   

0000000000800f93 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f93:	55                   	push   %rbp
  800f94:	48 89 e5             	mov    %rsp,%rbp
  800f97:	48 83 ec 50          	sub    $0x50,%rsp
  800f9b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f9f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800fa2:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800fa6:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800faa:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fae:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fb2:	48 8b 0a             	mov    (%rdx),%rcx
  800fb5:	48 89 08             	mov    %rcx,(%rax)
  800fb8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fbc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fc0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fc4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fc8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fcc:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fd0:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fd3:	48 98                	cltq   
  800fd5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fd9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fdd:	48 01 d0             	add    %rdx,%rax
  800fe0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fe4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800feb:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ff0:	74 06                	je     800ff8 <vsnprintf+0x65>
  800ff2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ff6:	7f 07                	jg     800fff <vsnprintf+0x6c>
		return -E_INVAL;
  800ff8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ffd:	eb 2f                	jmp    80102e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fff:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801003:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801007:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80100b:	48 89 c6             	mov    %rax,%rsi
  80100e:	48 bf 46 0f 80 00 00 	movabs $0x800f46,%rdi
  801015:	00 00 00 
  801018:	48 b8 3a 09 80 00 00 	movabs $0x80093a,%rax
  80101f:	00 00 00 
  801022:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801024:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801028:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80102b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80102e:	c9                   	leaveq 
  80102f:	c3                   	retq   

0000000000801030 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801030:	55                   	push   %rbp
  801031:	48 89 e5             	mov    %rsp,%rbp
  801034:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80103b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801042:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801048:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80104f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801056:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80105d:	84 c0                	test   %al,%al
  80105f:	74 20                	je     801081 <snprintf+0x51>
  801061:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801065:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801069:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80106d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801071:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801075:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801079:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80107d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801081:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801088:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80108f:	00 00 00 
  801092:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801099:	00 00 00 
  80109c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010a0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010a7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010ae:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010b5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010bc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010c3:	48 8b 0a             	mov    (%rdx),%rcx
  8010c6:	48 89 08             	mov    %rcx,(%rax)
  8010c9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010cd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010d1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010d5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010d9:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010e0:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010e7:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010ed:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010f4:	48 89 c7             	mov    %rax,%rdi
  8010f7:	48 b8 93 0f 80 00 00 	movabs $0x800f93,%rax
  8010fe:	00 00 00 
  801101:	ff d0                	callq  *%rax
  801103:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801109:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80110f:	c9                   	leaveq 
  801110:	c3                   	retq   

0000000000801111 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801111:	55                   	push   %rbp
  801112:	48 89 e5             	mov    %rsp,%rbp
  801115:	48 83 ec 18          	sub    $0x18,%rsp
  801119:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80111d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801124:	eb 09                	jmp    80112f <strlen+0x1e>
		n++;
  801126:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80112a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80112f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801133:	0f b6 00             	movzbl (%rax),%eax
  801136:	84 c0                	test   %al,%al
  801138:	75 ec                	jne    801126 <strlen+0x15>
		n++;
	return n;
  80113a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80113d:	c9                   	leaveq 
  80113e:	c3                   	retq   

000000000080113f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80113f:	55                   	push   %rbp
  801140:	48 89 e5             	mov    %rsp,%rbp
  801143:	48 83 ec 20          	sub    $0x20,%rsp
  801147:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80114f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801156:	eb 0e                	jmp    801166 <strnlen+0x27>
		n++;
  801158:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80115c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801161:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801166:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80116b:	74 0b                	je     801178 <strnlen+0x39>
  80116d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801171:	0f b6 00             	movzbl (%rax),%eax
  801174:	84 c0                	test   %al,%al
  801176:	75 e0                	jne    801158 <strnlen+0x19>
		n++;
	return n;
  801178:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80117b:	c9                   	leaveq 
  80117c:	c3                   	retq   

000000000080117d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80117d:	55                   	push   %rbp
  80117e:	48 89 e5             	mov    %rsp,%rbp
  801181:	48 83 ec 20          	sub    $0x20,%rsp
  801185:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801189:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80118d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801191:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801195:	90                   	nop
  801196:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80119e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011a2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011a6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011aa:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011ae:	0f b6 12             	movzbl (%rdx),%edx
  8011b1:	88 10                	mov    %dl,(%rax)
  8011b3:	0f b6 00             	movzbl (%rax),%eax
  8011b6:	84 c0                	test   %al,%al
  8011b8:	75 dc                	jne    801196 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011be:	c9                   	leaveq 
  8011bf:	c3                   	retq   

00000000008011c0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011c0:	55                   	push   %rbp
  8011c1:	48 89 e5             	mov    %rsp,%rbp
  8011c4:	48 83 ec 20          	sub    $0x20,%rsp
  8011c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d4:	48 89 c7             	mov    %rax,%rdi
  8011d7:	48 b8 11 11 80 00 00 	movabs $0x801111,%rax
  8011de:	00 00 00 
  8011e1:	ff d0                	callq  *%rax
  8011e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011e9:	48 63 d0             	movslq %eax,%rdx
  8011ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f0:	48 01 c2             	add    %rax,%rdx
  8011f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011f7:	48 89 c6             	mov    %rax,%rsi
  8011fa:	48 89 d7             	mov    %rdx,%rdi
  8011fd:	48 b8 7d 11 80 00 00 	movabs $0x80117d,%rax
  801204:	00 00 00 
  801207:	ff d0                	callq  *%rax
	return dst;
  801209:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80120d:	c9                   	leaveq 
  80120e:	c3                   	retq   

000000000080120f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80120f:	55                   	push   %rbp
  801210:	48 89 e5             	mov    %rsp,%rbp
  801213:	48 83 ec 28          	sub    $0x28,%rsp
  801217:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80121f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801223:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801227:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80122b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801232:	00 
  801233:	eb 2a                	jmp    80125f <strncpy+0x50>
		*dst++ = *src;
  801235:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801239:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80123d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801241:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801245:	0f b6 12             	movzbl (%rdx),%edx
  801248:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80124a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80124e:	0f b6 00             	movzbl (%rax),%eax
  801251:	84 c0                	test   %al,%al
  801253:	74 05                	je     80125a <strncpy+0x4b>
			src++;
  801255:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80125a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80125f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801263:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801267:	72 cc                	jb     801235 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801269:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80126d:	c9                   	leaveq 
  80126e:	c3                   	retq   

000000000080126f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80126f:	55                   	push   %rbp
  801270:	48 89 e5             	mov    %rsp,%rbp
  801273:	48 83 ec 28          	sub    $0x28,%rsp
  801277:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80127b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80127f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801287:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80128b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801290:	74 3d                	je     8012cf <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801292:	eb 1d                	jmp    8012b1 <strlcpy+0x42>
			*dst++ = *src++;
  801294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801298:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80129c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012a0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012a4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012a8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012ac:	0f b6 12             	movzbl (%rdx),%edx
  8012af:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012b1:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012b6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012bb:	74 0b                	je     8012c8 <strlcpy+0x59>
  8012bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c1:	0f b6 00             	movzbl (%rax),%eax
  8012c4:	84 c0                	test   %al,%al
  8012c6:	75 cc                	jne    801294 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cc:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d7:	48 29 c2             	sub    %rax,%rdx
  8012da:	48 89 d0             	mov    %rdx,%rax
}
  8012dd:	c9                   	leaveq 
  8012de:	c3                   	retq   

00000000008012df <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012df:	55                   	push   %rbp
  8012e0:	48 89 e5             	mov    %rsp,%rbp
  8012e3:	48 83 ec 10          	sub    $0x10,%rsp
  8012e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012ef:	eb 0a                	jmp    8012fb <strcmp+0x1c>
		p++, q++;
  8012f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ff:	0f b6 00             	movzbl (%rax),%eax
  801302:	84 c0                	test   %al,%al
  801304:	74 12                	je     801318 <strcmp+0x39>
  801306:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130a:	0f b6 10             	movzbl (%rax),%edx
  80130d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801311:	0f b6 00             	movzbl (%rax),%eax
  801314:	38 c2                	cmp    %al,%dl
  801316:	74 d9                	je     8012f1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131c:	0f b6 00             	movzbl (%rax),%eax
  80131f:	0f b6 d0             	movzbl %al,%edx
  801322:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801326:	0f b6 00             	movzbl (%rax),%eax
  801329:	0f b6 c0             	movzbl %al,%eax
  80132c:	29 c2                	sub    %eax,%edx
  80132e:	89 d0                	mov    %edx,%eax
}
  801330:	c9                   	leaveq 
  801331:	c3                   	retq   

0000000000801332 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801332:	55                   	push   %rbp
  801333:	48 89 e5             	mov    %rsp,%rbp
  801336:	48 83 ec 18          	sub    $0x18,%rsp
  80133a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80133e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801342:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801346:	eb 0f                	jmp    801357 <strncmp+0x25>
		n--, p++, q++;
  801348:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80134d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801352:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801357:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80135c:	74 1d                	je     80137b <strncmp+0x49>
  80135e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801362:	0f b6 00             	movzbl (%rax),%eax
  801365:	84 c0                	test   %al,%al
  801367:	74 12                	je     80137b <strncmp+0x49>
  801369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136d:	0f b6 10             	movzbl (%rax),%edx
  801370:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801374:	0f b6 00             	movzbl (%rax),%eax
  801377:	38 c2                	cmp    %al,%dl
  801379:	74 cd                	je     801348 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80137b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801380:	75 07                	jne    801389 <strncmp+0x57>
		return 0;
  801382:	b8 00 00 00 00       	mov    $0x0,%eax
  801387:	eb 18                	jmp    8013a1 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801389:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138d:	0f b6 00             	movzbl (%rax),%eax
  801390:	0f b6 d0             	movzbl %al,%edx
  801393:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801397:	0f b6 00             	movzbl (%rax),%eax
  80139a:	0f b6 c0             	movzbl %al,%eax
  80139d:	29 c2                	sub    %eax,%edx
  80139f:	89 d0                	mov    %edx,%eax
}
  8013a1:	c9                   	leaveq 
  8013a2:	c3                   	retq   

00000000008013a3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013a3:	55                   	push   %rbp
  8013a4:	48 89 e5             	mov    %rsp,%rbp
  8013a7:	48 83 ec 0c          	sub    $0xc,%rsp
  8013ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013af:	89 f0                	mov    %esi,%eax
  8013b1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013b4:	eb 17                	jmp    8013cd <strchr+0x2a>
		if (*s == c)
  8013b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ba:	0f b6 00             	movzbl (%rax),%eax
  8013bd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013c0:	75 06                	jne    8013c8 <strchr+0x25>
			return (char *) s;
  8013c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c6:	eb 15                	jmp    8013dd <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013c8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d1:	0f b6 00             	movzbl (%rax),%eax
  8013d4:	84 c0                	test   %al,%al
  8013d6:	75 de                	jne    8013b6 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013dd:	c9                   	leaveq 
  8013de:	c3                   	retq   

00000000008013df <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013df:	55                   	push   %rbp
  8013e0:	48 89 e5             	mov    %rsp,%rbp
  8013e3:	48 83 ec 0c          	sub    $0xc,%rsp
  8013e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013eb:	89 f0                	mov    %esi,%eax
  8013ed:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013f0:	eb 13                	jmp    801405 <strfind+0x26>
		if (*s == c)
  8013f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f6:	0f b6 00             	movzbl (%rax),%eax
  8013f9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013fc:	75 02                	jne    801400 <strfind+0x21>
			break;
  8013fe:	eb 10                	jmp    801410 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801400:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801409:	0f b6 00             	movzbl (%rax),%eax
  80140c:	84 c0                	test   %al,%al
  80140e:	75 e2                	jne    8013f2 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801414:	c9                   	leaveq 
  801415:	c3                   	retq   

0000000000801416 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801416:	55                   	push   %rbp
  801417:	48 89 e5             	mov    %rsp,%rbp
  80141a:	48 83 ec 18          	sub    $0x18,%rsp
  80141e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801422:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801425:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801429:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80142e:	75 06                	jne    801436 <memset+0x20>
		return v;
  801430:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801434:	eb 69                	jmp    80149f <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143a:	83 e0 03             	and    $0x3,%eax
  80143d:	48 85 c0             	test   %rax,%rax
  801440:	75 48                	jne    80148a <memset+0x74>
  801442:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801446:	83 e0 03             	and    $0x3,%eax
  801449:	48 85 c0             	test   %rax,%rax
  80144c:	75 3c                	jne    80148a <memset+0x74>
		c &= 0xFF;
  80144e:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801455:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801458:	c1 e0 18             	shl    $0x18,%eax
  80145b:	89 c2                	mov    %eax,%edx
  80145d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801460:	c1 e0 10             	shl    $0x10,%eax
  801463:	09 c2                	or     %eax,%edx
  801465:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801468:	c1 e0 08             	shl    $0x8,%eax
  80146b:	09 d0                	or     %edx,%eax
  80146d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801470:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801474:	48 c1 e8 02          	shr    $0x2,%rax
  801478:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80147b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801482:	48 89 d7             	mov    %rdx,%rdi
  801485:	fc                   	cld    
  801486:	f3 ab                	rep stos %eax,%es:(%rdi)
  801488:	eb 11                	jmp    80149b <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80148a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801491:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801495:	48 89 d7             	mov    %rdx,%rdi
  801498:	fc                   	cld    
  801499:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80149b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80149f:	c9                   	leaveq 
  8014a0:	c3                   	retq   

00000000008014a1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014a1:	55                   	push   %rbp
  8014a2:	48 89 e5             	mov    %rsp,%rbp
  8014a5:	48 83 ec 28          	sub    $0x28,%rsp
  8014a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014cd:	0f 83 88 00 00 00    	jae    80155b <memmove+0xba>
  8014d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014db:	48 01 d0             	add    %rdx,%rax
  8014de:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014e2:	76 77                	jbe    80155b <memmove+0xba>
		s += n;
  8014e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e8:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f0:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f8:	83 e0 03             	and    $0x3,%eax
  8014fb:	48 85 c0             	test   %rax,%rax
  8014fe:	75 3b                	jne    80153b <memmove+0x9a>
  801500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801504:	83 e0 03             	and    $0x3,%eax
  801507:	48 85 c0             	test   %rax,%rax
  80150a:	75 2f                	jne    80153b <memmove+0x9a>
  80150c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801510:	83 e0 03             	and    $0x3,%eax
  801513:	48 85 c0             	test   %rax,%rax
  801516:	75 23                	jne    80153b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801518:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151c:	48 83 e8 04          	sub    $0x4,%rax
  801520:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801524:	48 83 ea 04          	sub    $0x4,%rdx
  801528:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80152c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801530:	48 89 c7             	mov    %rax,%rdi
  801533:	48 89 d6             	mov    %rdx,%rsi
  801536:	fd                   	std    
  801537:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801539:	eb 1d                	jmp    801558 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80153b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801547:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80154b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154f:	48 89 d7             	mov    %rdx,%rdi
  801552:	48 89 c1             	mov    %rax,%rcx
  801555:	fd                   	std    
  801556:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801558:	fc                   	cld    
  801559:	eb 57                	jmp    8015b2 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80155b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155f:	83 e0 03             	and    $0x3,%eax
  801562:	48 85 c0             	test   %rax,%rax
  801565:	75 36                	jne    80159d <memmove+0xfc>
  801567:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156b:	83 e0 03             	and    $0x3,%eax
  80156e:	48 85 c0             	test   %rax,%rax
  801571:	75 2a                	jne    80159d <memmove+0xfc>
  801573:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801577:	83 e0 03             	and    $0x3,%eax
  80157a:	48 85 c0             	test   %rax,%rax
  80157d:	75 1e                	jne    80159d <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80157f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801583:	48 c1 e8 02          	shr    $0x2,%rax
  801587:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80158a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80158e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801592:	48 89 c7             	mov    %rax,%rdi
  801595:	48 89 d6             	mov    %rdx,%rsi
  801598:	fc                   	cld    
  801599:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80159b:	eb 15                	jmp    8015b2 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80159d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015a5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015a9:	48 89 c7             	mov    %rax,%rdi
  8015ac:	48 89 d6             	mov    %rdx,%rsi
  8015af:	fc                   	cld    
  8015b0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015b6:	c9                   	leaveq 
  8015b7:	c3                   	retq   

00000000008015b8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015b8:	55                   	push   %rbp
  8015b9:	48 89 e5             	mov    %rsp,%rbp
  8015bc:	48 83 ec 18          	sub    $0x18,%rsp
  8015c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015c8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015d0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d8:	48 89 ce             	mov    %rcx,%rsi
  8015db:	48 89 c7             	mov    %rax,%rdi
  8015de:	48 b8 a1 14 80 00 00 	movabs $0x8014a1,%rax
  8015e5:	00 00 00 
  8015e8:	ff d0                	callq  *%rax
}
  8015ea:	c9                   	leaveq 
  8015eb:	c3                   	retq   

00000000008015ec <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015ec:	55                   	push   %rbp
  8015ed:	48 89 e5             	mov    %rsp,%rbp
  8015f0:	48 83 ec 28          	sub    $0x28,%rsp
  8015f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801604:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801608:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80160c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801610:	eb 36                	jmp    801648 <memcmp+0x5c>
		if (*s1 != *s2)
  801612:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801616:	0f b6 10             	movzbl (%rax),%edx
  801619:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161d:	0f b6 00             	movzbl (%rax),%eax
  801620:	38 c2                	cmp    %al,%dl
  801622:	74 1a                	je     80163e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801624:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801628:	0f b6 00             	movzbl (%rax),%eax
  80162b:	0f b6 d0             	movzbl %al,%edx
  80162e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801632:	0f b6 00             	movzbl (%rax),%eax
  801635:	0f b6 c0             	movzbl %al,%eax
  801638:	29 c2                	sub    %eax,%edx
  80163a:	89 d0                	mov    %edx,%eax
  80163c:	eb 20                	jmp    80165e <memcmp+0x72>
		s1++, s2++;
  80163e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801643:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801648:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801650:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801654:	48 85 c0             	test   %rax,%rax
  801657:	75 b9                	jne    801612 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801659:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165e:	c9                   	leaveq 
  80165f:	c3                   	retq   

0000000000801660 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801660:	55                   	push   %rbp
  801661:	48 89 e5             	mov    %rsp,%rbp
  801664:	48 83 ec 28          	sub    $0x28,%rsp
  801668:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80166c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80166f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801677:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80167b:	48 01 d0             	add    %rdx,%rax
  80167e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801682:	eb 15                	jmp    801699 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801688:	0f b6 10             	movzbl (%rax),%edx
  80168b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80168e:	38 c2                	cmp    %al,%dl
  801690:	75 02                	jne    801694 <memfind+0x34>
			break;
  801692:	eb 0f                	jmp    8016a3 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801694:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801699:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016a1:	72 e1                	jb     801684 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8016a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016a7:	c9                   	leaveq 
  8016a8:	c3                   	retq   

00000000008016a9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016a9:	55                   	push   %rbp
  8016aa:	48 89 e5             	mov    %rsp,%rbp
  8016ad:	48 83 ec 34          	sub    $0x34,%rsp
  8016b1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016b5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016b9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016c3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016ca:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016cb:	eb 05                	jmp    8016d2 <strtol+0x29>
		s++;
  8016cd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d6:	0f b6 00             	movzbl (%rax),%eax
  8016d9:	3c 20                	cmp    $0x20,%al
  8016db:	74 f0                	je     8016cd <strtol+0x24>
  8016dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e1:	0f b6 00             	movzbl (%rax),%eax
  8016e4:	3c 09                	cmp    $0x9,%al
  8016e6:	74 e5                	je     8016cd <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ec:	0f b6 00             	movzbl (%rax),%eax
  8016ef:	3c 2b                	cmp    $0x2b,%al
  8016f1:	75 07                	jne    8016fa <strtol+0x51>
		s++;
  8016f3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f8:	eb 17                	jmp    801711 <strtol+0x68>
	else if (*s == '-')
  8016fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fe:	0f b6 00             	movzbl (%rax),%eax
  801701:	3c 2d                	cmp    $0x2d,%al
  801703:	75 0c                	jne    801711 <strtol+0x68>
		s++, neg = 1;
  801705:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80170a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801711:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801715:	74 06                	je     80171d <strtol+0x74>
  801717:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80171b:	75 28                	jne    801745 <strtol+0x9c>
  80171d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801721:	0f b6 00             	movzbl (%rax),%eax
  801724:	3c 30                	cmp    $0x30,%al
  801726:	75 1d                	jne    801745 <strtol+0x9c>
  801728:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172c:	48 83 c0 01          	add    $0x1,%rax
  801730:	0f b6 00             	movzbl (%rax),%eax
  801733:	3c 78                	cmp    $0x78,%al
  801735:	75 0e                	jne    801745 <strtol+0x9c>
		s += 2, base = 16;
  801737:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80173c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801743:	eb 2c                	jmp    801771 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801745:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801749:	75 19                	jne    801764 <strtol+0xbb>
  80174b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174f:	0f b6 00             	movzbl (%rax),%eax
  801752:	3c 30                	cmp    $0x30,%al
  801754:	75 0e                	jne    801764 <strtol+0xbb>
		s++, base = 8;
  801756:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80175b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801762:	eb 0d                	jmp    801771 <strtol+0xc8>
	else if (base == 0)
  801764:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801768:	75 07                	jne    801771 <strtol+0xc8>
		base = 10;
  80176a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801775:	0f b6 00             	movzbl (%rax),%eax
  801778:	3c 2f                	cmp    $0x2f,%al
  80177a:	7e 1d                	jle    801799 <strtol+0xf0>
  80177c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801780:	0f b6 00             	movzbl (%rax),%eax
  801783:	3c 39                	cmp    $0x39,%al
  801785:	7f 12                	jg     801799 <strtol+0xf0>
			dig = *s - '0';
  801787:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178b:	0f b6 00             	movzbl (%rax),%eax
  80178e:	0f be c0             	movsbl %al,%eax
  801791:	83 e8 30             	sub    $0x30,%eax
  801794:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801797:	eb 4e                	jmp    8017e7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801799:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179d:	0f b6 00             	movzbl (%rax),%eax
  8017a0:	3c 60                	cmp    $0x60,%al
  8017a2:	7e 1d                	jle    8017c1 <strtol+0x118>
  8017a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a8:	0f b6 00             	movzbl (%rax),%eax
  8017ab:	3c 7a                	cmp    $0x7a,%al
  8017ad:	7f 12                	jg     8017c1 <strtol+0x118>
			dig = *s - 'a' + 10;
  8017af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b3:	0f b6 00             	movzbl (%rax),%eax
  8017b6:	0f be c0             	movsbl %al,%eax
  8017b9:	83 e8 57             	sub    $0x57,%eax
  8017bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017bf:	eb 26                	jmp    8017e7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c5:	0f b6 00             	movzbl (%rax),%eax
  8017c8:	3c 40                	cmp    $0x40,%al
  8017ca:	7e 48                	jle    801814 <strtol+0x16b>
  8017cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d0:	0f b6 00             	movzbl (%rax),%eax
  8017d3:	3c 5a                	cmp    $0x5a,%al
  8017d5:	7f 3d                	jg     801814 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8017d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017db:	0f b6 00             	movzbl (%rax),%eax
  8017de:	0f be c0             	movsbl %al,%eax
  8017e1:	83 e8 37             	sub    $0x37,%eax
  8017e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017ea:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017ed:	7c 02                	jl     8017f1 <strtol+0x148>
			break;
  8017ef:	eb 23                	jmp    801814 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017f1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017f9:	48 98                	cltq   
  8017fb:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801800:	48 89 c2             	mov    %rax,%rdx
  801803:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801806:	48 98                	cltq   
  801808:	48 01 d0             	add    %rdx,%rax
  80180b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80180f:	e9 5d ff ff ff       	jmpq   801771 <strtol+0xc8>

	if (endptr)
  801814:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801819:	74 0b                	je     801826 <strtol+0x17d>
		*endptr = (char *) s;
  80181b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80181f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801823:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801826:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80182a:	74 09                	je     801835 <strtol+0x18c>
  80182c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801830:	48 f7 d8             	neg    %rax
  801833:	eb 04                	jmp    801839 <strtol+0x190>
  801835:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801839:	c9                   	leaveq 
  80183a:	c3                   	retq   

000000000080183b <strstr>:

char * strstr(const char *in, const char *str)
{
  80183b:	55                   	push   %rbp
  80183c:	48 89 e5             	mov    %rsp,%rbp
  80183f:	48 83 ec 30          	sub    $0x30,%rsp
  801843:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801847:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80184b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80184f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801853:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801857:	0f b6 00             	movzbl (%rax),%eax
  80185a:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80185d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801861:	75 06                	jne    801869 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801867:	eb 6b                	jmp    8018d4 <strstr+0x99>

	len = strlen(str);
  801869:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80186d:	48 89 c7             	mov    %rax,%rdi
  801870:	48 b8 11 11 80 00 00 	movabs $0x801111,%rax
  801877:	00 00 00 
  80187a:	ff d0                	callq  *%rax
  80187c:	48 98                	cltq   
  80187e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801882:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801886:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80188a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80188e:	0f b6 00             	movzbl (%rax),%eax
  801891:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801894:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801898:	75 07                	jne    8018a1 <strstr+0x66>
				return (char *) 0;
  80189a:	b8 00 00 00 00       	mov    $0x0,%eax
  80189f:	eb 33                	jmp    8018d4 <strstr+0x99>
		} while (sc != c);
  8018a1:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018a5:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018a8:	75 d8                	jne    801882 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8018aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ae:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b6:	48 89 ce             	mov    %rcx,%rsi
  8018b9:	48 89 c7             	mov    %rax,%rdi
  8018bc:	48 b8 32 13 80 00 00 	movabs $0x801332,%rax
  8018c3:	00 00 00 
  8018c6:	ff d0                	callq  *%rax
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	75 b6                	jne    801882 <strstr+0x47>

	return (char *) (in - 1);
  8018cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d0:	48 83 e8 01          	sub    $0x1,%rax
}
  8018d4:	c9                   	leaveq 
  8018d5:	c3                   	retq   

00000000008018d6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018d6:	55                   	push   %rbp
  8018d7:	48 89 e5             	mov    %rsp,%rbp
  8018da:	53                   	push   %rbx
  8018db:	48 83 ec 48          	sub    $0x48,%rsp
  8018df:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018e2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018e5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018e9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018ed:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018f1:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018f5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018f8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018fc:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801900:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801904:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801908:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80190c:	4c 89 c3             	mov    %r8,%rbx
  80190f:	cd 30                	int    $0x30
  801911:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801915:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801919:	74 3e                	je     801959 <syscall+0x83>
  80191b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801920:	7e 37                	jle    801959 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801922:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801926:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801929:	49 89 d0             	mov    %rdx,%r8
  80192c:	89 c1                	mov    %eax,%ecx
  80192e:	48 ba 48 55 80 00 00 	movabs $0x805548,%rdx
  801935:	00 00 00 
  801938:	be 23 00 00 00       	mov    $0x23,%esi
  80193d:	48 bf 65 55 80 00 00 	movabs $0x805565,%rdi
  801944:	00 00 00 
  801947:	b8 00 00 00 00       	mov    $0x0,%eax
  80194c:	49 b9 4e 03 80 00 00 	movabs $0x80034e,%r9
  801953:	00 00 00 
  801956:	41 ff d1             	callq  *%r9

	return ret;
  801959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80195d:	48 83 c4 48          	add    $0x48,%rsp
  801961:	5b                   	pop    %rbx
  801962:	5d                   	pop    %rbp
  801963:	c3                   	retq   

0000000000801964 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801964:	55                   	push   %rbp
  801965:	48 89 e5             	mov    %rsp,%rbp
  801968:	48 83 ec 20          	sub    $0x20,%rsp
  80196c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801970:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801974:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801978:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80197c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801983:	00 
  801984:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801990:	48 89 d1             	mov    %rdx,%rcx
  801993:	48 89 c2             	mov    %rax,%rdx
  801996:	be 00 00 00 00       	mov    $0x0,%esi
  80199b:	bf 00 00 00 00       	mov    $0x0,%edi
  8019a0:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  8019a7:	00 00 00 
  8019aa:	ff d0                	callq  *%rax
}
  8019ac:	c9                   	leaveq 
  8019ad:	c3                   	retq   

00000000008019ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8019ae:	55                   	push   %rbp
  8019af:	48 89 e5             	mov    %rsp,%rbp
  8019b2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019b6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019bd:	00 
  8019be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d4:	be 00 00 00 00       	mov    $0x0,%esi
  8019d9:	bf 01 00 00 00       	mov    $0x1,%edi
  8019de:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  8019e5:	00 00 00 
  8019e8:	ff d0                	callq  *%rax
}
  8019ea:	c9                   	leaveq 
  8019eb:	c3                   	retq   

00000000008019ec <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019ec:	55                   	push   %rbp
  8019ed:	48 89 e5             	mov    %rsp,%rbp
  8019f0:	48 83 ec 10          	sub    $0x10,%rsp
  8019f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fa:	48 98                	cltq   
  8019fc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a03:	00 
  801a04:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a0a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a10:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a15:	48 89 c2             	mov    %rax,%rdx
  801a18:	be 01 00 00 00       	mov    $0x1,%esi
  801a1d:	bf 03 00 00 00       	mov    $0x3,%edi
  801a22:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801a29:	00 00 00 
  801a2c:	ff d0                	callq  *%rax
}
  801a2e:	c9                   	leaveq 
  801a2f:	c3                   	retq   

0000000000801a30 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a30:	55                   	push   %rbp
  801a31:	48 89 e5             	mov    %rsp,%rbp
  801a34:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a38:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3f:	00 
  801a40:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a46:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a51:	ba 00 00 00 00       	mov    $0x0,%edx
  801a56:	be 00 00 00 00       	mov    $0x0,%esi
  801a5b:	bf 02 00 00 00       	mov    $0x2,%edi
  801a60:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801a67:	00 00 00 
  801a6a:	ff d0                	callq  *%rax
}
  801a6c:	c9                   	leaveq 
  801a6d:	c3                   	retq   

0000000000801a6e <sys_yield>:

void
sys_yield(void)
{
  801a6e:	55                   	push   %rbp
  801a6f:	48 89 e5             	mov    %rsp,%rbp
  801a72:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a76:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a7d:	00 
  801a7e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a84:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a94:	be 00 00 00 00       	mov    $0x0,%esi
  801a99:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a9e:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801aa5:	00 00 00 
  801aa8:	ff d0                	callq  *%rax
}
  801aaa:	c9                   	leaveq 
  801aab:	c3                   	retq   

0000000000801aac <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801aac:	55                   	push   %rbp
  801aad:	48 89 e5             	mov    %rsp,%rbp
  801ab0:	48 83 ec 20          	sub    $0x20,%rsp
  801ab4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801abb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801abe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ac1:	48 63 c8             	movslq %eax,%rcx
  801ac4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801acb:	48 98                	cltq   
  801acd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad4:	00 
  801ad5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801adb:	49 89 c8             	mov    %rcx,%r8
  801ade:	48 89 d1             	mov    %rdx,%rcx
  801ae1:	48 89 c2             	mov    %rax,%rdx
  801ae4:	be 01 00 00 00       	mov    $0x1,%esi
  801ae9:	bf 04 00 00 00       	mov    $0x4,%edi
  801aee:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801af5:	00 00 00 
  801af8:	ff d0                	callq  *%rax
}
  801afa:	c9                   	leaveq 
  801afb:	c3                   	retq   

0000000000801afc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801afc:	55                   	push   %rbp
  801afd:	48 89 e5             	mov    %rsp,%rbp
  801b00:	48 83 ec 30          	sub    $0x30,%rsp
  801b04:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b0b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b0e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b12:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b16:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b19:	48 63 c8             	movslq %eax,%rcx
  801b1c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b20:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b23:	48 63 f0             	movslq %eax,%rsi
  801b26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2d:	48 98                	cltq   
  801b2f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b33:	49 89 f9             	mov    %rdi,%r9
  801b36:	49 89 f0             	mov    %rsi,%r8
  801b39:	48 89 d1             	mov    %rdx,%rcx
  801b3c:	48 89 c2             	mov    %rax,%rdx
  801b3f:	be 01 00 00 00       	mov    $0x1,%esi
  801b44:	bf 05 00 00 00       	mov    $0x5,%edi
  801b49:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801b50:	00 00 00 
  801b53:	ff d0                	callq  *%rax
}
  801b55:	c9                   	leaveq 
  801b56:	c3                   	retq   

0000000000801b57 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b57:	55                   	push   %rbp
  801b58:	48 89 e5             	mov    %rsp,%rbp
  801b5b:	48 83 ec 20          	sub    $0x20,%rsp
  801b5f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b62:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b66:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6d:	48 98                	cltq   
  801b6f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b76:	00 
  801b77:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b83:	48 89 d1             	mov    %rdx,%rcx
  801b86:	48 89 c2             	mov    %rax,%rdx
  801b89:	be 01 00 00 00       	mov    $0x1,%esi
  801b8e:	bf 06 00 00 00       	mov    $0x6,%edi
  801b93:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801b9a:	00 00 00 
  801b9d:	ff d0                	callq  *%rax
}
  801b9f:	c9                   	leaveq 
  801ba0:	c3                   	retq   

0000000000801ba1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ba1:	55                   	push   %rbp
  801ba2:	48 89 e5             	mov    %rsp,%rbp
  801ba5:	48 83 ec 10          	sub    $0x10,%rsp
  801ba9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bac:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801baf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bb2:	48 63 d0             	movslq %eax,%rdx
  801bb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb8:	48 98                	cltq   
  801bba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc1:	00 
  801bc2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bce:	48 89 d1             	mov    %rdx,%rcx
  801bd1:	48 89 c2             	mov    %rax,%rdx
  801bd4:	be 01 00 00 00       	mov    $0x1,%esi
  801bd9:	bf 08 00 00 00       	mov    $0x8,%edi
  801bde:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801be5:	00 00 00 
  801be8:	ff d0                	callq  *%rax
}
  801bea:	c9                   	leaveq 
  801beb:	c3                   	retq   

0000000000801bec <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bec:	55                   	push   %rbp
  801bed:	48 89 e5             	mov    %rsp,%rbp
  801bf0:	48 83 ec 20          	sub    $0x20,%rsp
  801bf4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bfb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c02:	48 98                	cltq   
  801c04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0b:	00 
  801c0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c18:	48 89 d1             	mov    %rdx,%rcx
  801c1b:	48 89 c2             	mov    %rax,%rdx
  801c1e:	be 01 00 00 00       	mov    $0x1,%esi
  801c23:	bf 09 00 00 00       	mov    $0x9,%edi
  801c28:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801c2f:	00 00 00 
  801c32:	ff d0                	callq  *%rax
}
  801c34:	c9                   	leaveq 
  801c35:	c3                   	retq   

0000000000801c36 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c36:	55                   	push   %rbp
  801c37:	48 89 e5             	mov    %rsp,%rbp
  801c3a:	48 83 ec 20          	sub    $0x20,%rsp
  801c3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4c:	48 98                	cltq   
  801c4e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c55:	00 
  801c56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c62:	48 89 d1             	mov    %rdx,%rcx
  801c65:	48 89 c2             	mov    %rax,%rdx
  801c68:	be 01 00 00 00       	mov    $0x1,%esi
  801c6d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c72:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801c79:	00 00 00 
  801c7c:	ff d0                	callq  *%rax
}
  801c7e:	c9                   	leaveq 
  801c7f:	c3                   	retq   

0000000000801c80 <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801c80:	55                   	push   %rbp
  801c81:	48 89 e5             	mov    %rsp,%rbp
  801c84:	48 83 ec 10          	sub    $0x10,%rsp
  801c88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c8b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801c8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c91:	48 63 d0             	movslq %eax,%rdx
  801c94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c97:	48 98                	cltq   
  801c99:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca0:	00 
  801ca1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cad:	48 89 d1             	mov    %rdx,%rcx
  801cb0:	48 89 c2             	mov    %rax,%rdx
  801cb3:	be 01 00 00 00       	mov    $0x1,%esi
  801cb8:	bf 11 00 00 00       	mov    $0x11,%edi
  801cbd:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801cc4:	00 00 00 
  801cc7:	ff d0                	callq  *%rax

}
  801cc9:	c9                   	leaveq 
  801cca:	c3                   	retq   

0000000000801ccb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ccb:	55                   	push   %rbp
  801ccc:	48 89 e5             	mov    %rsp,%rbp
  801ccf:	48 83 ec 20          	sub    $0x20,%rsp
  801cd3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cd6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cda:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801cde:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ce1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ce4:	48 63 f0             	movslq %eax,%rsi
  801ce7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ceb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cee:	48 98                	cltq   
  801cf0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cfb:	00 
  801cfc:	49 89 f1             	mov    %rsi,%r9
  801cff:	49 89 c8             	mov    %rcx,%r8
  801d02:	48 89 d1             	mov    %rdx,%rcx
  801d05:	48 89 c2             	mov    %rax,%rdx
  801d08:	be 00 00 00 00       	mov    $0x0,%esi
  801d0d:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d12:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801d19:	00 00 00 
  801d1c:	ff d0                	callq  *%rax
}
  801d1e:	c9                   	leaveq 
  801d1f:	c3                   	retq   

0000000000801d20 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d20:	55                   	push   %rbp
  801d21:	48 89 e5             	mov    %rsp,%rbp
  801d24:	48 83 ec 10          	sub    $0x10,%rsp
  801d28:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d30:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d37:	00 
  801d38:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d44:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d49:	48 89 c2             	mov    %rax,%rdx
  801d4c:	be 01 00 00 00       	mov    $0x1,%esi
  801d51:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d56:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801d5d:	00 00 00 
  801d60:	ff d0                	callq  *%rax
}
  801d62:	c9                   	leaveq 
  801d63:	c3                   	retq   

0000000000801d64 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d64:	55                   	push   %rbp
  801d65:	48 89 e5             	mov    %rsp,%rbp
  801d68:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d6c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d73:	00 
  801d74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d80:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d85:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8a:	be 00 00 00 00       	mov    $0x0,%esi
  801d8f:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d94:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801d9b:	00 00 00 
  801d9e:	ff d0                	callq  *%rax
}
  801da0:	c9                   	leaveq 
  801da1:	c3                   	retq   

0000000000801da2 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801da2:	55                   	push   %rbp
  801da3:	48 89 e5             	mov    %rsp,%rbp
  801da6:	48 83 ec 30          	sub    $0x30,%rsp
  801daa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801db1:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801db4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801db8:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801dbc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dbf:	48 63 c8             	movslq %eax,%rcx
  801dc2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dc6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dc9:	48 63 f0             	movslq %eax,%rsi
  801dcc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd3:	48 98                	cltq   
  801dd5:	48 89 0c 24          	mov    %rcx,(%rsp)
  801dd9:	49 89 f9             	mov    %rdi,%r9
  801ddc:	49 89 f0             	mov    %rsi,%r8
  801ddf:	48 89 d1             	mov    %rdx,%rcx
  801de2:	48 89 c2             	mov    %rax,%rdx
  801de5:	be 00 00 00 00       	mov    $0x0,%esi
  801dea:	bf 0f 00 00 00       	mov    $0xf,%edi
  801def:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801df6:	00 00 00 
  801df9:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801dfb:	c9                   	leaveq 
  801dfc:	c3                   	retq   

0000000000801dfd <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801dfd:	55                   	push   %rbp
  801dfe:	48 89 e5             	mov    %rsp,%rbp
  801e01:	48 83 ec 20          	sub    $0x20,%rsp
  801e05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e15:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e1c:	00 
  801e1d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e23:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e29:	48 89 d1             	mov    %rdx,%rcx
  801e2c:	48 89 c2             	mov    %rax,%rdx
  801e2f:	be 00 00 00 00       	mov    $0x0,%esi
  801e34:	bf 10 00 00 00       	mov    $0x10,%edi
  801e39:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  801e40:	00 00 00 
  801e43:	ff d0                	callq  *%rax
}
  801e45:	c9                   	leaveq 
  801e46:	c3                   	retq   

0000000000801e47 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801e47:	55                   	push   %rbp
  801e48:	48 89 e5             	mov    %rsp,%rbp
  801e4b:	48 83 ec 30          	sub    $0x30,%rsp
  801e4f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)



	void *addr = (void *) utf->utf_fault_va;
  801e53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e57:	48 8b 00             	mov    (%rax),%rax
  801e5a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e62:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e66:	89 45 f4             	mov    %eax,-0xc(%rbp)
        // Hint:
        //   Use the read-only page table mappings at vpt
        //   (see <inc/memlayout.h>).

        // LAB 4: Your code here.
	if (!(err&FEC_WR))
  801e69:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e6c:	83 e0 02             	and    $0x2,%eax
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	75 2a                	jne    801e9d <pgfault+0x56>
		panic("pgfault:FEC_WR check\n");
  801e73:	48 ba 78 55 80 00 00 	movabs $0x805578,%rdx
  801e7a:	00 00 00 
  801e7d:	be 21 00 00 00       	mov    $0x21,%esi
  801e82:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  801e89:	00 00 00 
  801e8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e91:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  801e98:	00 00 00 
  801e9b:	ff d1                	callq  *%rcx
	if (!(uvpt[((uint64_t)addr) / PGSIZE] & PTE_COW))
  801e9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea1:	48 c1 e8 0c          	shr    $0xc,%rax
  801ea5:	48 89 c2             	mov    %rax,%rdx
  801ea8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eaf:	01 00 00 
  801eb2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eb6:	25 00 08 00 00       	and    $0x800,%eax
  801ebb:	48 85 c0             	test   %rax,%rax
  801ebe:	75 2a                	jne    801eea <pgfault+0xa3>
		panic("pgfault:PTE_COW check\n");
  801ec0:	48 ba 99 55 80 00 00 	movabs $0x805599,%rdx
  801ec7:	00 00 00 
  801eca:	be 23 00 00 00       	mov    $0x23,%esi
  801ecf:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  801ed6:	00 00 00 
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  801ee5:	00 00 00 
  801ee8:	ff d1                	callq  *%rcx
        // Hint:
        //   You should make three system calls.
        //   No need to explicitly delete the old page's mapping.

        // LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801eea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801ef2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef6:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801efc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U)<0)
  801f00:	ba 07 00 00 00       	mov    $0x7,%edx
  801f05:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f0a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f0f:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  801f16:	00 00 00 
  801f19:	ff d0                	callq  *%rax
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	79 2a                	jns    801f49 <pgfault+0x102>
		panic("pgfault: sys_page_alloc error\n");
  801f1f:	48 ba b0 55 80 00 00 	movabs $0x8055b0,%rdx
  801f26:	00 00 00 
  801f29:	be 2f 00 00 00       	mov    $0x2f,%esi
  801f2e:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  801f35:	00 00 00 
  801f38:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3d:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  801f44:	00 00 00 
  801f47:	ff d1                	callq  *%rcx
	memcpy(PFTEMP, addr, PGSIZE);
  801f49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f4d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f52:	48 89 c6             	mov    %rax,%rsi
  801f55:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f5a:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  801f61:	00 00 00 
  801f64:	ff d0                	callq  *%rax
	if (sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0)
  801f66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f6a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f70:	48 89 c1             	mov    %rax,%rcx
  801f73:	ba 00 00 00 00       	mov    $0x0,%edx
  801f78:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f7d:	bf 00 00 00 00       	mov    $0x0,%edi
  801f82:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  801f89:	00 00 00 
  801f8c:	ff d0                	callq  *%rax
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	79 2a                	jns    801fbc <pgfault+0x175>
		panic("pgfault: sys_page_map error\n");
  801f92:	48 ba cf 55 80 00 00 	movabs $0x8055cf,%rdx
  801f99:	00 00 00 
  801f9c:	be 32 00 00 00       	mov    $0x32,%esi
  801fa1:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  801fa8:	00 00 00 
  801fab:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb0:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  801fb7:	00 00 00 
  801fba:	ff d1                	callq  *%rcx

	if (sys_page_unmap(0, (void *)PFTEMP)<0)
  801fbc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fc1:	bf 00 00 00 00       	mov    $0x0,%edi
  801fc6:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  801fcd:	00 00 00 
  801fd0:	ff d0                	callq  *%rax
  801fd2:	85 c0                	test   %eax,%eax
  801fd4:	79 2a                	jns    802000 <pgfault+0x1b9>
		panic("pgfault: sys_page_unmap error\n");
  801fd6:	48 ba f0 55 80 00 00 	movabs $0x8055f0,%rdx
  801fdd:	00 00 00 
  801fe0:	be 35 00 00 00       	mov    $0x35,%esi
  801fe5:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  801fec:	00 00 00 
  801fef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff4:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  801ffb:	00 00 00 
  801ffe:	ff d1                	callq  *%rcx
	


}
  802000:	c9                   	leaveq 
  802001:	c3                   	retq   

0000000000802002 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802002:	55                   	push   %rbp
  802003:	48 89 e5             	mov    %rsp,%rbp
  802006:	48 83 ec 10          	sub    $0x10,%rsp
  80200a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80200d:	89 75 f8             	mov    %esi,-0x8(%rbp)

	if (uvpt[pn] & PTE_SHARE){
  802010:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802017:	01 00 00 
  80201a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80201d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802021:	25 00 04 00 00       	and    $0x400,%eax
  802026:	48 85 c0             	test   %rax,%rax
  802029:	74 75                	je     8020a0 <duppage+0x9e>
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
  80202b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802032:	01 00 00 
  802035:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802038:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203c:	25 07 0e 00 00       	and    $0xe07,%eax
  802041:	89 c6                	mov    %eax,%esi
  802043:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802046:	48 c1 e0 0c          	shl    $0xc,%rax
  80204a:	48 89 c1             	mov    %rax,%rcx
  80204d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802050:	48 c1 e0 0c          	shl    $0xc,%rax
  802054:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802057:	41 89 f0             	mov    %esi,%r8d
  80205a:	48 89 c6             	mov    %rax,%rsi
  80205d:	bf 00 00 00 00       	mov    $0x0,%edi
  802062:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  802069:	00 00 00 
  80206c:	ff d0                	callq  *%rax
  80206e:	85 c0                	test   %eax,%eax
  802070:	0f 89 82 01 00 00    	jns    8021f8 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");	
  802076:	48 ba 0f 56 80 00 00 	movabs $0x80560f,%rdx
  80207d:	00 00 00 
  802080:	be 4c 00 00 00       	mov    $0x4c,%esi
  802085:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  80208c:	00 00 00 
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
  802094:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  80209b:	00 00 00 
  80209e:	ff d1                	callq  *%rcx
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
  8020a0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020a7:	01 00 00 
  8020aa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8020ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b1:	83 e0 02             	and    $0x2,%eax
  8020b4:	48 85 c0             	test   %rax,%rax
  8020b7:	75 7e                	jne    802137 <duppage+0x135>
  8020b9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020c0:	01 00 00 
  8020c3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8020c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ca:	25 00 08 00 00       	and    $0x800,%eax
  8020cf:	48 85 c0             	test   %rax,%rax
  8020d2:	75 63                	jne    802137 <duppage+0x135>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  8020d4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020d7:	c1 e0 0c             	shl    $0xc,%eax
  8020da:	89 c0                	mov    %eax,%eax
  8020dc:	48 89 c1             	mov    %rax,%rcx
  8020df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020e2:	c1 e0 0c             	shl    $0xc,%eax
  8020e5:	89 c0                	mov    %eax,%eax
  8020e7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020ea:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  8020f0:	48 89 c6             	mov    %rax,%rsi
  8020f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f8:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  8020ff:	00 00 00 
  802102:	ff d0                	callq  *%rax
  802104:	85 c0                	test   %eax,%eax
  802106:	79 2a                	jns    802132 <duppage+0x130>
			panic("duppage:sys_page_map error\n");
  802108:	48 ba 0f 56 80 00 00 	movabs $0x80560f,%rdx
  80210f:	00 00 00 
  802112:	be 51 00 00 00       	mov    $0x51,%esi
  802117:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  80211e:	00 00 00 
  802121:	b8 00 00 00 00       	mov    $0x0,%eax
  802126:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  80212d:	00 00 00 
  802130:	ff d1                	callq  *%rcx
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
			panic("duppage:sys_page_map error\n");	
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  802132:	e9 c1 00 00 00       	jmpq   8021f8 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  802137:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80213a:	c1 e0 0c             	shl    $0xc,%eax
  80213d:	89 c0                	mov    %eax,%eax
  80213f:	48 89 c1             	mov    %rax,%rcx
  802142:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802145:	c1 e0 0c             	shl    $0xc,%eax
  802148:	89 c0                	mov    %eax,%eax
  80214a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80214d:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802153:	48 89 c6             	mov    %rax,%rsi
  802156:	bf 00 00 00 00       	mov    $0x0,%edi
  80215b:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  802162:	00 00 00 
  802165:	ff d0                	callq  *%rax
  802167:	85 c0                	test   %eax,%eax
  802169:	79 2a                	jns    802195 <duppage+0x193>
			panic("duppage:sys_page_map error\n");
  80216b:	48 ba 0f 56 80 00 00 	movabs $0x80560f,%rdx
  802172:	00 00 00 
  802175:	be 55 00 00 00       	mov    $0x55,%esi
  80217a:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  802181:	00 00 00 
  802184:	b8 00 00 00 00       	mov    $0x0,%eax
  802189:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  802190:	00 00 00 
  802193:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  802195:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802198:	c1 e0 0c             	shl    $0xc,%eax
  80219b:	89 c0                	mov    %eax,%eax
  80219d:	48 89 c2             	mov    %rax,%rdx
  8021a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021a3:	c1 e0 0c             	shl    $0xc,%eax
  8021a6:	89 c0                	mov    %eax,%eax
  8021a8:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8021ae:	48 89 d1             	mov    %rdx,%rcx
  8021b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b6:	48 89 c6             	mov    %rax,%rsi
  8021b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8021be:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  8021c5:	00 00 00 
  8021c8:	ff d0                	callq  *%rax
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	79 2a                	jns    8021f8 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
  8021ce:	48 ba 0f 56 80 00 00 	movabs $0x80560f,%rdx
  8021d5:	00 00 00 
  8021d8:	be 57 00 00 00       	mov    $0x57,%esi
  8021dd:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  8021e4:	00 00 00 
  8021e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ec:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  8021f3:	00 00 00 
  8021f6:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  8021f8:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8021fd:	c9                   	leaveq 
  8021fe:	c3                   	retq   

00000000008021ff <new_duppage>:


static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
  8021ff:	55                   	push   %rbp
  802200:	48 89 e5             	mov    %rsp,%rbp
  802203:	48 83 ec 10          	sub    $0x10,%rsp
  802207:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80220a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80220d:	89 55 f4             	mov    %edx,-0xc(%rbp)
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
  802210:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802217:	01 00 00 
  80221a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80221d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802221:	83 e0 02             	and    $0x2,%eax
  802224:	48 85 c0             	test   %rax,%rax
  802227:	0f 85 84 00 00 00    	jne    8022b1 <new_duppage+0xb2>
  80222d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802234:	01 00 00 
  802237:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80223a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223e:	25 00 08 00 00       	and    $0x800,%eax
  802243:	48 85 c0             	test   %rax,%rax
  802246:	75 69                	jne    8022b1 <new_duppage+0xb2>
  802248:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80224c:	75 63                	jne    8022b1 <new_duppage+0xb2>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  80224e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802251:	c1 e0 0c             	shl    $0xc,%eax
  802254:	89 c0                	mov    %eax,%eax
  802256:	48 89 c1             	mov    %rax,%rcx
  802259:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80225c:	c1 e0 0c             	shl    $0xc,%eax
  80225f:	89 c0                	mov    %eax,%eax
  802261:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802264:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  80226a:	48 89 c6             	mov    %rax,%rsi
  80226d:	bf 00 00 00 00       	mov    $0x0,%edi
  802272:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  802279:	00 00 00 
  80227c:	ff d0                	callq  *%rax
  80227e:	85 c0                	test   %eax,%eax
  802280:	79 2a                	jns    8022ac <new_duppage+0xad>
			panic("duppage:sys_page_map error\n");
  802282:	48 ba 0f 56 80 00 00 	movabs $0x80560f,%rdx
  802289:	00 00 00 
  80228c:	be 64 00 00 00       	mov    $0x64,%esi
  802291:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  802298:	00 00 00 
  80229b:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a0:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  8022a7:	00 00 00 
  8022aa:	ff d1                	callq  *%rcx
static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  8022ac:	e9 c1 00 00 00       	jmpq   802372 <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  8022b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022b4:	c1 e0 0c             	shl    $0xc,%eax
  8022b7:	89 c0                	mov    %eax,%eax
  8022b9:	48 89 c1             	mov    %rax,%rcx
  8022bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022bf:	c1 e0 0c             	shl    $0xc,%eax
  8022c2:	89 c0                	mov    %eax,%eax
  8022c4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022c7:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8022cd:	48 89 c6             	mov    %rax,%rsi
  8022d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d5:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  8022dc:	00 00 00 
  8022df:	ff d0                	callq  *%rax
  8022e1:	85 c0                	test   %eax,%eax
  8022e3:	79 2a                	jns    80230f <new_duppage+0x110>
			panic("duppage:sys_page_map error\n");
  8022e5:	48 ba 0f 56 80 00 00 	movabs $0x80560f,%rdx
  8022ec:	00 00 00 
  8022ef:	be 68 00 00 00       	mov    $0x68,%esi
  8022f4:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  8022fb:	00 00 00 
  8022fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802303:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  80230a:	00 00 00 
  80230d:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  80230f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802312:	c1 e0 0c             	shl    $0xc,%eax
  802315:	89 c0                	mov    %eax,%eax
  802317:	48 89 c2             	mov    %rax,%rdx
  80231a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80231d:	c1 e0 0c             	shl    $0xc,%eax
  802320:	89 c0                	mov    %eax,%eax
  802322:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802328:	48 89 d1             	mov    %rdx,%rcx
  80232b:	ba 00 00 00 00       	mov    $0x0,%edx
  802330:	48 89 c6             	mov    %rax,%rsi
  802333:	bf 00 00 00 00       	mov    $0x0,%edi
  802338:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  80233f:	00 00 00 
  802342:	ff d0                	callq  *%rax
  802344:	85 c0                	test   %eax,%eax
  802346:	79 2a                	jns    802372 <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
  802348:	48 ba 0f 56 80 00 00 	movabs $0x80560f,%rdx
  80234f:	00 00 00 
  802352:	be 6a 00 00 00       	mov    $0x6a,%esi
  802357:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  80235e:	00 00 00 
  802361:	b8 00 00 00 00       	mov    $0x0,%eax
  802366:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  80236d:	00 00 00 
  802370:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  802372:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802377:	c9                   	leaveq 
  802378:	c3                   	retq   

0000000000802379 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802379:	55                   	push   %rbp
  80237a:	48 89 e5             	mov    %rsp,%rbp
  80237d:	48 83 ec 10          	sub    $0x10,%rsp


	
	int envid;  
	//extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  802381:	48 bf 47 1e 80 00 00 	movabs $0x801e47,%rdi
  802388:	00 00 00 
  80238b:	48 b8 9b 4b 80 00 00 	movabs $0x804b9b,%rax
  802392:	00 00 00 
  802395:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802397:	b8 07 00 00 00       	mov    $0x7,%eax
  80239c:	cd 30                	int    $0x30
  80239e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8023a1:	8b 45 f0             	mov    -0x10(%rbp),%eax


	if ((envid=sys_exofork())<0)
  8023a4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8023a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8023ab:	79 2a                	jns    8023d7 <fork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  8023ad:	48 ba 2b 56 80 00 00 	movabs $0x80562b,%rdx
  8023b4:	00 00 00 
  8023b7:	be 90 00 00 00       	mov    $0x90,%esi
  8023bc:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  8023c3:	00 00 00 
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cb:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  8023d2:	00 00 00 
  8023d5:	ff d1                	callq  *%rcx

	if(envid>0){
  8023d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8023db:	0f 8e e1 01 00 00    	jle    8025c2 <fork+0x249>
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  8023e1:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  8023e8:	00 
  8023e9:	e9 d4 00 00 00       	jmpq   8024c2 <fork+0x149>
		{
			

               if(!(uvpml4e[VPML4E(i)]))
  8023ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f2:	48 c1 e8 27          	shr    $0x27,%rax
  8023f6:	48 89 c2             	mov    %rax,%rdx
  8023f9:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802400:	01 00 00 
  802403:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802407:	48 85 c0             	test   %rax,%rax
  80240a:	75 05                	jne    802411 <fork+0x98>
		 continue;
  80240c:	e9 a9 00 00 00       	jmpq   8024ba <fork+0x141>
		
		if(!(uvpde[VPDPE(i)]))
  802411:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802415:	48 c1 e8 1e          	shr    $0x1e,%rax
  802419:	48 89 c2             	mov    %rax,%rdx
  80241c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802423:	01 00 00 
  802426:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242a:	48 85 c0             	test   %rax,%rax
  80242d:	75 05                	jne    802434 <fork+0xbb>
	          continue;
  80242f:	e9 86 00 00 00       	jmpq   8024ba <fork+0x141>
	

			if(!(uvpd[VPD(i)] & PTE_P))
  802434:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802438:	48 c1 e8 15          	shr    $0x15,%rax
  80243c:	48 89 c2             	mov    %rax,%rdx
  80243f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802446:	01 00 00 
  802449:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80244d:	83 e0 01             	and    $0x1,%eax
  802450:	48 85 c0             	test   %rax,%rax
  802453:	75 02                	jne    802457 <fork+0xde>
				continue;
  802455:	eb 63                	jmp    8024ba <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_P))
  802457:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80245b:	48 c1 e8 0c          	shr    $0xc,%rax
  80245f:	48 89 c2             	mov    %rax,%rdx
  802462:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802469:	01 00 00 
  80246c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802470:	83 e0 01             	and    $0x1,%eax
  802473:	48 85 c0             	test   %rax,%rax
  802476:	75 02                	jne    80247a <fork+0x101>
				continue; 
  802478:	eb 40                	jmp    8024ba <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_U))
  80247a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80247e:	48 c1 e8 0c          	shr    $0xc,%rax
  802482:	48 89 c2             	mov    %rax,%rdx
  802485:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80248c:	01 00 00 
  80248f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802493:	83 e0 04             	and    $0x4,%eax
  802496:	48 85 c0             	test   %rax,%rax
  802499:	75 02                	jne    80249d <fork+0x124>
				continue; 
  80249b:	eb 1d                	jmp    8024ba <fork+0x141>
			duppage(envid, VPN(i)); 
  80249d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024a1:	48 c1 e8 0c          	shr    $0xc,%rax
  8024a5:	89 c2                	mov    %eax,%edx
  8024a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024aa:	89 d6                	mov    %edx,%esi
  8024ac:	89 c7                	mov    %eax,%edi
  8024ae:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  8024b5:	00 00 00 
  8024b8:	ff d0                	callq  *%rax

	if(envid>0){
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  8024ba:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8024c1:	00 
  8024c2:	b8 ff cf 7f ef       	mov    $0xef7fcfff,%eax
  8024c7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8024cb:	0f 86 1d ff ff ff    	jbe    8023ee <fork+0x75>
			if(!(uvpt[VPN(i)] & PTE_U))
				continue; 
			duppage(envid, VPN(i)); 
		}

		if (sys_page_alloc(envid,(void*)UXSTACKTOP-PGSIZE, PTE_U|PTE_W|PTE_P)<0)
  8024d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024d4:	ba 07 00 00 00       	mov    $0x7,%edx
  8024d9:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024de:	89 c7                	mov    %eax,%edi
  8024e0:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  8024e7:	00 00 00 
  8024ea:	ff d0                	callq  *%rax
  8024ec:	85 c0                	test   %eax,%eax
  8024ee:	79 2a                	jns    80251a <fork+0x1a1>
			panic("fork: sys_page_alloc error!\n");
  8024f0:	48 ba 45 56 80 00 00 	movabs $0x805645,%rdx
  8024f7:	00 00 00 
  8024fa:	be ab 00 00 00       	mov    $0xab,%esi
  8024ff:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  802506:	00 00 00 
  802509:	b8 00 00 00 00       	mov    $0x0,%eax
  80250e:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  802515:	00 00 00 
  802518:	ff d1                	callq  *%rcx

		duppage(envid, VPN(USTACKTOP-PGSIZE));
  80251a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80251d:	be fd f7 0e 00       	mov    $0xef7fd,%esi
  802522:	89 c7                	mov    %eax,%edi
  802524:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  80252b:	00 00 00 
  80252e:	ff d0                	callq  *%rax
		extern void _pgfault_upcall(void);
		if (sys_env_set_pgfault_upcall(envid, _pgfault_upcall)<0)
  802530:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802533:	48 be 3b 4c 80 00 00 	movabs $0x804c3b,%rsi
  80253a:	00 00 00 
  80253d:	89 c7                	mov    %eax,%edi
  80253f:	48 b8 36 1c 80 00 00 	movabs $0x801c36,%rax
  802546:	00 00 00 
  802549:	ff d0                	callq  *%rax
  80254b:	85 c0                	test   %eax,%eax
  80254d:	79 2a                	jns    802579 <fork+0x200>
			panic("fork: sys_env_set_status error!\n");
  80254f:	48 ba 68 56 80 00 00 	movabs $0x805668,%rdx
  802556:	00 00 00 
  802559:	be b0 00 00 00       	mov    $0xb0,%esi
  80255e:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  802565:	00 00 00 
  802568:	b8 00 00 00 00       	mov    $0x0,%eax
  80256d:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  802574:	00 00 00 
  802577:	ff d1                	callq  *%rcx
		if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  802579:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80257c:	be 02 00 00 00       	mov    $0x2,%esi
  802581:	89 c7                	mov    %eax,%edi
  802583:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  80258a:	00 00 00 
  80258d:	ff d0                	callq  *%rax
  80258f:	85 c0                	test   %eax,%eax
  802591:	79 2a                	jns    8025bd <fork+0x244>
			panic("fork: sys_env_set_status error!\n");
  802593:	48 ba 68 56 80 00 00 	movabs $0x805668,%rdx
  80259a:	00 00 00 
  80259d:	be b2 00 00 00       	mov    $0xb2,%esi
  8025a2:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  8025a9:	00 00 00 
  8025ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b1:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  8025b8:	00 00 00 
  8025bb:	ff d1                	callq  *%rcx

		return envid;
  8025bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025c0:	eb 39                	jmp    8025fb <fork+0x282>
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8025c2:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  8025c9:	00 00 00 
  8025cc:	ff d0                	callq  *%rax
  8025ce:	25 ff 03 00 00       	and    $0x3ff,%eax
  8025d3:	48 98                	cltq   
  8025d5:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8025dc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8025e3:	00 00 00 
  8025e6:	48 01 c2             	add    %rax,%rdx
  8025e9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025f0:	00 00 00 
  8025f3:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8025f6:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  8025fb:	c9                   	leaveq 
  8025fc:	c3                   	retq   

00000000008025fd <sfork>:

// Challenge!
envid_t
sfork(void)
{
  8025fd:	55                   	push   %rbp
  8025fe:	48 89 e5             	mov    %rsp,%rbp
  802601:	48 83 ec 20          	sub    $0x20,%rsp

	
	int envid;  
	extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  802605:	48 bf 47 1e 80 00 00 	movabs $0x801e47,%rdi
  80260c:	00 00 00 
  80260f:	48 b8 9b 4b 80 00 00 	movabs $0x804b9b,%rax
  802616:	00 00 00 
  802619:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80261b:	b8 07 00 00 00       	mov    $0x7,%eax
  802620:	cd 30                	int    $0x30
  802622:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802625:	8b 45 ec             	mov    -0x14(%rbp),%eax
	

	if ((envid=sys_exofork())<0)
  802628:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80262b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80262f:	79 2a                	jns    80265b <sfork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  802631:	48 ba 2b 56 80 00 00 	movabs $0x80562b,%rdx
  802638:	00 00 00 
  80263b:	be ca 00 00 00       	mov    $0xca,%esi
  802640:	48 bf 8e 55 80 00 00 	movabs $0x80558e,%rdi
  802647:	00 00 00 
  80264a:	b8 00 00 00 00       	mov    $0x0,%eax
  80264f:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  802656:	00 00 00 
  802659:	ff d1                	callq  *%rcx

	if(envid>0){
  80265b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80265f:	0f 8e e5 00 00 00    	jle    80274a <sfork+0x14d>
		
		
		uintptr_t i;
		int flag=1;
  802665:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)

		for (i = 0; i < (uintptr_t)end/*USTACKTOP-PGSIZE*/; i += PGSIZE) ;
  80266c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802673:	00 
  802674:	eb 08                	jmp    80267e <sfork+0x81>
  802676:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  80267d:	00 
  80267e:	48 b8 10 a0 80 00 00 	movabs $0x80a010,%rax
  802685:	00 00 00 
  802688:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80268c:	72 e8                	jb     802676 <sfork+0x79>
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
  80268e:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802695:	00 
    for (;i>=0; i -= PGSIZE) 
		{
			cprintf("23\n");
  802696:	48 bf 89 56 80 00 00 	movabs $0x805689,%rdi
  80269d:	00 00 00 
  8026a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a5:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  8026ac:	00 00 00 
  8026af:	ff d2                	callq  *%rdx
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
  8026b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026b5:	48 c1 e8 15          	shr    $0x15,%rax
  8026b9:	48 89 c2             	mov    %rax,%rdx
  8026bc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026c3:	01 00 00 
  8026c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026ca:	83 e0 01             	and    $0x1,%eax
  8026cd:	48 85 c0             	test   %rax,%rax
  8026d0:	74 42                	je     802714 <sfork+0x117>
  8026d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026d6:	48 c1 e8 0c          	shr    $0xc,%rax
  8026da:	48 89 c2             	mov    %rax,%rdx
  8026dd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026e4:	01 00 00 
  8026e7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026eb:	83 e0 01             	and    $0x1,%eax
  8026ee:	48 85 c0             	test   %rax,%rax
  8026f1:	74 21                	je     802714 <sfork+0x117>
  8026f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f7:	48 c1 e8 0c          	shr    $0xc,%rax
  8026fb:	48 89 c2             	mov    %rax,%rdx
  8026fe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802705:	01 00 00 
  802708:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80270c:	83 e0 04             	and    $0x4,%eax
  80270f:	48 85 c0             	test   %rax,%rax
  802712:	75 09                	jne    80271d <sfork+0x120>
				flag=0;
  802714:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80271b:	eb 20                	jmp    80273d <sfork+0x140>
			else
				new_duppage(envid, VPN(i),flag); 
  80271d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802721:	48 c1 e8 0c          	shr    $0xc,%rax
  802725:	89 c1                	mov    %eax,%ecx
  802727:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80272a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80272d:	89 ce                	mov    %ecx,%esi
  80272f:	89 c7                	mov    %eax,%edi
  802731:	48 b8 ff 21 80 00 00 	movabs $0x8021ff,%rax
  802738:	00 00 00 
  80273b:	ff d0                	callq  *%rax
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
    for (;i>=0; i -= PGSIZE) 
  80273d:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802744:	00 
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
				flag=0;
			else
				new_duppage(envid, VPN(i),flag); 

		}
  802745:	e9 4c ff ff ff       	jmpq   802696 <sfork+0x99>

		return envid;
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80274a:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  802751:	00 00 00 
  802754:	ff d0                	callq  *%rax
  802756:	25 ff 03 00 00       	and    $0x3ff,%eax
  80275b:	48 98                	cltq   
  80275d:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  802764:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80276b:	00 00 00 
  80276e:	48 01 c2             	add    %rax,%rdx
  802771:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802778:	00 00 00 
  80277b:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80277e:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  802783:	c9                   	leaveq 
  802784:	c3                   	retq   

0000000000802785 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802785:	55                   	push   %rbp
  802786:	48 89 e5             	mov    %rsp,%rbp
  802789:	48 83 ec 08          	sub    $0x8,%rsp
  80278d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802791:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802795:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80279c:	ff ff ff 
  80279f:	48 01 d0             	add    %rdx,%rax
  8027a2:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8027a6:	c9                   	leaveq 
  8027a7:	c3                   	retq   

00000000008027a8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8027a8:	55                   	push   %rbp
  8027a9:	48 89 e5             	mov    %rsp,%rbp
  8027ac:	48 83 ec 08          	sub    $0x8,%rsp
  8027b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8027b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027b8:	48 89 c7             	mov    %rax,%rdi
  8027bb:	48 b8 85 27 80 00 00 	movabs $0x802785,%rax
  8027c2:	00 00 00 
  8027c5:	ff d0                	callq  *%rax
  8027c7:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8027cd:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8027d1:	c9                   	leaveq 
  8027d2:	c3                   	retq   

00000000008027d3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8027d3:	55                   	push   %rbp
  8027d4:	48 89 e5             	mov    %rsp,%rbp
  8027d7:	48 83 ec 18          	sub    $0x18,%rsp
  8027db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8027df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027e6:	eb 6b                	jmp    802853 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8027e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027eb:	48 98                	cltq   
  8027ed:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027f3:	48 c1 e0 0c          	shl    $0xc,%rax
  8027f7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8027fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ff:	48 c1 e8 15          	shr    $0x15,%rax
  802803:	48 89 c2             	mov    %rax,%rdx
  802806:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80280d:	01 00 00 
  802810:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802814:	83 e0 01             	and    $0x1,%eax
  802817:	48 85 c0             	test   %rax,%rax
  80281a:	74 21                	je     80283d <fd_alloc+0x6a>
  80281c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802820:	48 c1 e8 0c          	shr    $0xc,%rax
  802824:	48 89 c2             	mov    %rax,%rdx
  802827:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80282e:	01 00 00 
  802831:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802835:	83 e0 01             	and    $0x1,%eax
  802838:	48 85 c0             	test   %rax,%rax
  80283b:	75 12                	jne    80284f <fd_alloc+0x7c>
			*fd_store = fd;
  80283d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802841:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802845:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802848:	b8 00 00 00 00       	mov    $0x0,%eax
  80284d:	eb 1a                	jmp    802869 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80284f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802853:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802857:	7e 8f                	jle    8027e8 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802859:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802864:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802869:	c9                   	leaveq 
  80286a:	c3                   	retq   

000000000080286b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80286b:	55                   	push   %rbp
  80286c:	48 89 e5             	mov    %rsp,%rbp
  80286f:	48 83 ec 20          	sub    $0x20,%rsp
  802873:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802876:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80287a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80287e:	78 06                	js     802886 <fd_lookup+0x1b>
  802880:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802884:	7e 07                	jle    80288d <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802886:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80288b:	eb 6c                	jmp    8028f9 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80288d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802890:	48 98                	cltq   
  802892:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802898:	48 c1 e0 0c          	shl    $0xc,%rax
  80289c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8028a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028a4:	48 c1 e8 15          	shr    $0x15,%rax
  8028a8:	48 89 c2             	mov    %rax,%rdx
  8028ab:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028b2:	01 00 00 
  8028b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028b9:	83 e0 01             	and    $0x1,%eax
  8028bc:	48 85 c0             	test   %rax,%rax
  8028bf:	74 21                	je     8028e2 <fd_lookup+0x77>
  8028c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028c5:	48 c1 e8 0c          	shr    $0xc,%rax
  8028c9:	48 89 c2             	mov    %rax,%rdx
  8028cc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028d3:	01 00 00 
  8028d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028da:	83 e0 01             	and    $0x1,%eax
  8028dd:	48 85 c0             	test   %rax,%rax
  8028e0:	75 07                	jne    8028e9 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8028e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028e7:	eb 10                	jmp    8028f9 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8028e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8028f1:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8028f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f9:	c9                   	leaveq 
  8028fa:	c3                   	retq   

00000000008028fb <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8028fb:	55                   	push   %rbp
  8028fc:	48 89 e5             	mov    %rsp,%rbp
  8028ff:	48 83 ec 30          	sub    $0x30,%rsp
  802903:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802907:	89 f0                	mov    %esi,%eax
  802909:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80290c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802910:	48 89 c7             	mov    %rax,%rdi
  802913:	48 b8 85 27 80 00 00 	movabs $0x802785,%rax
  80291a:	00 00 00 
  80291d:	ff d0                	callq  *%rax
  80291f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802923:	48 89 d6             	mov    %rdx,%rsi
  802926:	89 c7                	mov    %eax,%edi
  802928:	48 b8 6b 28 80 00 00 	movabs $0x80286b,%rax
  80292f:	00 00 00 
  802932:	ff d0                	callq  *%rax
  802934:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802937:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293b:	78 0a                	js     802947 <fd_close+0x4c>
	    || fd != fd2)
  80293d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802941:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802945:	74 12                	je     802959 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802947:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80294b:	74 05                	je     802952 <fd_close+0x57>
  80294d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802950:	eb 05                	jmp    802957 <fd_close+0x5c>
  802952:	b8 00 00 00 00       	mov    $0x0,%eax
  802957:	eb 69                	jmp    8029c2 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802959:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80295d:	8b 00                	mov    (%rax),%eax
  80295f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802963:	48 89 d6             	mov    %rdx,%rsi
  802966:	89 c7                	mov    %eax,%edi
  802968:	48 b8 c4 29 80 00 00 	movabs $0x8029c4,%rax
  80296f:	00 00 00 
  802972:	ff d0                	callq  *%rax
  802974:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802977:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297b:	78 2a                	js     8029a7 <fd_close+0xac>
		if (dev->dev_close)
  80297d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802981:	48 8b 40 20          	mov    0x20(%rax),%rax
  802985:	48 85 c0             	test   %rax,%rax
  802988:	74 16                	je     8029a0 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80298a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298e:	48 8b 40 20          	mov    0x20(%rax),%rax
  802992:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802996:	48 89 d7             	mov    %rdx,%rdi
  802999:	ff d0                	callq  *%rax
  80299b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299e:	eb 07                	jmp    8029a7 <fd_close+0xac>
		else
			r = 0;
  8029a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8029a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029ab:	48 89 c6             	mov    %rax,%rsi
  8029ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8029b3:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  8029ba:	00 00 00 
  8029bd:	ff d0                	callq  *%rax
	return r;
  8029bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029c2:	c9                   	leaveq 
  8029c3:	c3                   	retq   

00000000008029c4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8029c4:	55                   	push   %rbp
  8029c5:	48 89 e5             	mov    %rsp,%rbp
  8029c8:	48 83 ec 20          	sub    $0x20,%rsp
  8029cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8029d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029da:	eb 41                	jmp    802a1d <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8029dc:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8029e3:	00 00 00 
  8029e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029e9:	48 63 d2             	movslq %edx,%rdx
  8029ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029f0:	8b 00                	mov    (%rax),%eax
  8029f2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8029f5:	75 22                	jne    802a19 <dev_lookup+0x55>
			*dev = devtab[i];
  8029f7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8029fe:	00 00 00 
  802a01:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a04:	48 63 d2             	movslq %edx,%rdx
  802a07:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802a0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a0f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a12:	b8 00 00 00 00       	mov    $0x0,%eax
  802a17:	eb 60                	jmp    802a79 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802a19:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a1d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802a24:	00 00 00 
  802a27:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a2a:	48 63 d2             	movslq %edx,%rdx
  802a2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a31:	48 85 c0             	test   %rax,%rax
  802a34:	75 a6                	jne    8029dc <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802a36:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802a3d:	00 00 00 
  802a40:	48 8b 00             	mov    (%rax),%rax
  802a43:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a49:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a4c:	89 c6                	mov    %eax,%esi
  802a4e:	48 bf 90 56 80 00 00 	movabs $0x805690,%rdi
  802a55:	00 00 00 
  802a58:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5d:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  802a64:	00 00 00 
  802a67:	ff d1                	callq  *%rcx
	*dev = 0;
  802a69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a6d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802a74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802a79:	c9                   	leaveq 
  802a7a:	c3                   	retq   

0000000000802a7b <close>:

int
close(int fdnum)
{
  802a7b:	55                   	push   %rbp
  802a7c:	48 89 e5             	mov    %rsp,%rbp
  802a7f:	48 83 ec 20          	sub    $0x20,%rsp
  802a83:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a86:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a8a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a8d:	48 89 d6             	mov    %rdx,%rsi
  802a90:	89 c7                	mov    %eax,%edi
  802a92:	48 b8 6b 28 80 00 00 	movabs $0x80286b,%rax
  802a99:	00 00 00 
  802a9c:	ff d0                	callq  *%rax
  802a9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa5:	79 05                	jns    802aac <close+0x31>
		return r;
  802aa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aaa:	eb 18                	jmp    802ac4 <close+0x49>
	else
		return fd_close(fd, 1);
  802aac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab0:	be 01 00 00 00       	mov    $0x1,%esi
  802ab5:	48 89 c7             	mov    %rax,%rdi
  802ab8:	48 b8 fb 28 80 00 00 	movabs $0x8028fb,%rax
  802abf:	00 00 00 
  802ac2:	ff d0                	callq  *%rax
}
  802ac4:	c9                   	leaveq 
  802ac5:	c3                   	retq   

0000000000802ac6 <close_all>:

void
close_all(void)
{
  802ac6:	55                   	push   %rbp
  802ac7:	48 89 e5             	mov    %rsp,%rbp
  802aca:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802ace:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ad5:	eb 15                	jmp    802aec <close_all+0x26>
		close(i);
  802ad7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ada:	89 c7                	mov    %eax,%edi
  802adc:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  802ae3:	00 00 00 
  802ae6:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802ae8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802aec:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802af0:	7e e5                	jle    802ad7 <close_all+0x11>
		close(i);
}
  802af2:	c9                   	leaveq 
  802af3:	c3                   	retq   

0000000000802af4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802af4:	55                   	push   %rbp
  802af5:	48 89 e5             	mov    %rsp,%rbp
  802af8:	48 83 ec 40          	sub    $0x40,%rsp
  802afc:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802aff:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b02:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802b06:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802b09:	48 89 d6             	mov    %rdx,%rsi
  802b0c:	89 c7                	mov    %eax,%edi
  802b0e:	48 b8 6b 28 80 00 00 	movabs $0x80286b,%rax
  802b15:	00 00 00 
  802b18:	ff d0                	callq  *%rax
  802b1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b21:	79 08                	jns    802b2b <dup+0x37>
		return r;
  802b23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b26:	e9 70 01 00 00       	jmpq   802c9b <dup+0x1a7>
	close(newfdnum);
  802b2b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b2e:	89 c7                	mov    %eax,%edi
  802b30:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  802b37:	00 00 00 
  802b3a:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802b3c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b3f:	48 98                	cltq   
  802b41:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b47:	48 c1 e0 0c          	shl    $0xc,%rax
  802b4b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802b4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b53:	48 89 c7             	mov    %rax,%rdi
  802b56:	48 b8 a8 27 80 00 00 	movabs $0x8027a8,%rax
  802b5d:	00 00 00 
  802b60:	ff d0                	callq  *%rax
  802b62:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802b66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b6a:	48 89 c7             	mov    %rax,%rdi
  802b6d:	48 b8 a8 27 80 00 00 	movabs $0x8027a8,%rax
  802b74:	00 00 00 
  802b77:	ff d0                	callq  *%rax
  802b79:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802b7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b81:	48 c1 e8 15          	shr    $0x15,%rax
  802b85:	48 89 c2             	mov    %rax,%rdx
  802b88:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b8f:	01 00 00 
  802b92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b96:	83 e0 01             	and    $0x1,%eax
  802b99:	48 85 c0             	test   %rax,%rax
  802b9c:	74 73                	je     802c11 <dup+0x11d>
  802b9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba2:	48 c1 e8 0c          	shr    $0xc,%rax
  802ba6:	48 89 c2             	mov    %rax,%rdx
  802ba9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bb0:	01 00 00 
  802bb3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bb7:	83 e0 01             	and    $0x1,%eax
  802bba:	48 85 c0             	test   %rax,%rax
  802bbd:	74 52                	je     802c11 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802bbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc3:	48 c1 e8 0c          	shr    $0xc,%rax
  802bc7:	48 89 c2             	mov    %rax,%rdx
  802bca:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bd1:	01 00 00 
  802bd4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bd8:	25 07 0e 00 00       	and    $0xe07,%eax
  802bdd:	89 c1                	mov    %eax,%ecx
  802bdf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be7:	41 89 c8             	mov    %ecx,%r8d
  802bea:	48 89 d1             	mov    %rdx,%rcx
  802bed:	ba 00 00 00 00       	mov    $0x0,%edx
  802bf2:	48 89 c6             	mov    %rax,%rsi
  802bf5:	bf 00 00 00 00       	mov    $0x0,%edi
  802bfa:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  802c01:	00 00 00 
  802c04:	ff d0                	callq  *%rax
  802c06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c0d:	79 02                	jns    802c11 <dup+0x11d>
			goto err;
  802c0f:	eb 57                	jmp    802c68 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802c11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c15:	48 c1 e8 0c          	shr    $0xc,%rax
  802c19:	48 89 c2             	mov    %rax,%rdx
  802c1c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c23:	01 00 00 
  802c26:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c2a:	25 07 0e 00 00       	and    $0xe07,%eax
  802c2f:	89 c1                	mov    %eax,%ecx
  802c31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c39:	41 89 c8             	mov    %ecx,%r8d
  802c3c:	48 89 d1             	mov    %rdx,%rcx
  802c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  802c44:	48 89 c6             	mov    %rax,%rsi
  802c47:	bf 00 00 00 00       	mov    $0x0,%edi
  802c4c:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  802c53:	00 00 00 
  802c56:	ff d0                	callq  *%rax
  802c58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5f:	79 02                	jns    802c63 <dup+0x16f>
		goto err;
  802c61:	eb 05                	jmp    802c68 <dup+0x174>

	return newfdnum;
  802c63:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c66:	eb 33                	jmp    802c9b <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802c68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c6c:	48 89 c6             	mov    %rax,%rsi
  802c6f:	bf 00 00 00 00       	mov    $0x0,%edi
  802c74:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  802c7b:	00 00 00 
  802c7e:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802c80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c84:	48 89 c6             	mov    %rax,%rsi
  802c87:	bf 00 00 00 00       	mov    $0x0,%edi
  802c8c:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  802c93:	00 00 00 
  802c96:	ff d0                	callq  *%rax
	return r;
  802c98:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c9b:	c9                   	leaveq 
  802c9c:	c3                   	retq   

0000000000802c9d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802c9d:	55                   	push   %rbp
  802c9e:	48 89 e5             	mov    %rsp,%rbp
  802ca1:	48 83 ec 40          	sub    $0x40,%rsp
  802ca5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ca8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802cac:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cb0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cb4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cb7:	48 89 d6             	mov    %rdx,%rsi
  802cba:	89 c7                	mov    %eax,%edi
  802cbc:	48 b8 6b 28 80 00 00 	movabs $0x80286b,%rax
  802cc3:	00 00 00 
  802cc6:	ff d0                	callq  *%rax
  802cc8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ccb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ccf:	78 24                	js     802cf5 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd5:	8b 00                	mov    (%rax),%eax
  802cd7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cdb:	48 89 d6             	mov    %rdx,%rsi
  802cde:	89 c7                	mov    %eax,%edi
  802ce0:	48 b8 c4 29 80 00 00 	movabs $0x8029c4,%rax
  802ce7:	00 00 00 
  802cea:	ff d0                	callq  *%rax
  802cec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf3:	79 05                	jns    802cfa <read+0x5d>
		return r;
  802cf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf8:	eb 76                	jmp    802d70 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802cfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cfe:	8b 40 08             	mov    0x8(%rax),%eax
  802d01:	83 e0 03             	and    $0x3,%eax
  802d04:	83 f8 01             	cmp    $0x1,%eax
  802d07:	75 3a                	jne    802d43 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802d09:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d10:	00 00 00 
  802d13:	48 8b 00             	mov    (%rax),%rax
  802d16:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d1c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d1f:	89 c6                	mov    %eax,%esi
  802d21:	48 bf af 56 80 00 00 	movabs $0x8056af,%rdi
  802d28:	00 00 00 
  802d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d30:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  802d37:	00 00 00 
  802d3a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d41:	eb 2d                	jmp    802d70 <read+0xd3>
	}
	if (!dev->dev_read)
  802d43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d47:	48 8b 40 10          	mov    0x10(%rax),%rax
  802d4b:	48 85 c0             	test   %rax,%rax
  802d4e:	75 07                	jne    802d57 <read+0xba>
		return -E_NOT_SUPP;
  802d50:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d55:	eb 19                	jmp    802d70 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802d57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5b:	48 8b 40 10          	mov    0x10(%rax),%rax
  802d5f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d63:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d67:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d6b:	48 89 cf             	mov    %rcx,%rdi
  802d6e:	ff d0                	callq  *%rax
}
  802d70:	c9                   	leaveq 
  802d71:	c3                   	retq   

0000000000802d72 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802d72:	55                   	push   %rbp
  802d73:	48 89 e5             	mov    %rsp,%rbp
  802d76:	48 83 ec 30          	sub    $0x30,%rsp
  802d7a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d7d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d81:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d8c:	eb 49                	jmp    802dd7 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802d8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d91:	48 98                	cltq   
  802d93:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d97:	48 29 c2             	sub    %rax,%rdx
  802d9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9d:	48 63 c8             	movslq %eax,%rcx
  802da0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802da4:	48 01 c1             	add    %rax,%rcx
  802da7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802daa:	48 89 ce             	mov    %rcx,%rsi
  802dad:	89 c7                	mov    %eax,%edi
  802daf:	48 b8 9d 2c 80 00 00 	movabs $0x802c9d,%rax
  802db6:	00 00 00 
  802db9:	ff d0                	callq  *%rax
  802dbb:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802dbe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802dc2:	79 05                	jns    802dc9 <readn+0x57>
			return m;
  802dc4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dc7:	eb 1c                	jmp    802de5 <readn+0x73>
		if (m == 0)
  802dc9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802dcd:	75 02                	jne    802dd1 <readn+0x5f>
			break;
  802dcf:	eb 11                	jmp    802de2 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802dd1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dd4:	01 45 fc             	add    %eax,-0x4(%rbp)
  802dd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dda:	48 98                	cltq   
  802ddc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802de0:	72 ac                	jb     802d8e <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802de2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802de5:	c9                   	leaveq 
  802de6:	c3                   	retq   

0000000000802de7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802de7:	55                   	push   %rbp
  802de8:	48 89 e5             	mov    %rsp,%rbp
  802deb:	48 83 ec 40          	sub    $0x40,%rsp
  802def:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802df2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802df6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dfa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dfe:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e01:	48 89 d6             	mov    %rdx,%rsi
  802e04:	89 c7                	mov    %eax,%edi
  802e06:	48 b8 6b 28 80 00 00 	movabs $0x80286b,%rax
  802e0d:	00 00 00 
  802e10:	ff d0                	callq  *%rax
  802e12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e19:	78 24                	js     802e3f <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e1f:	8b 00                	mov    (%rax),%eax
  802e21:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e25:	48 89 d6             	mov    %rdx,%rsi
  802e28:	89 c7                	mov    %eax,%edi
  802e2a:	48 b8 c4 29 80 00 00 	movabs $0x8029c4,%rax
  802e31:	00 00 00 
  802e34:	ff d0                	callq  *%rax
  802e36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e3d:	79 05                	jns    802e44 <write+0x5d>
		return r;
  802e3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e42:	eb 75                	jmp    802eb9 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e48:	8b 40 08             	mov    0x8(%rax),%eax
  802e4b:	83 e0 03             	and    $0x3,%eax
  802e4e:	85 c0                	test   %eax,%eax
  802e50:	75 3a                	jne    802e8c <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802e52:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802e59:	00 00 00 
  802e5c:	48 8b 00             	mov    (%rax),%rax
  802e5f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e65:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e68:	89 c6                	mov    %eax,%esi
  802e6a:	48 bf cb 56 80 00 00 	movabs $0x8056cb,%rdi
  802e71:	00 00 00 
  802e74:	b8 00 00 00 00       	mov    $0x0,%eax
  802e79:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  802e80:	00 00 00 
  802e83:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e85:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e8a:	eb 2d                	jmp    802eb9 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802e8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e90:	48 8b 40 18          	mov    0x18(%rax),%rax
  802e94:	48 85 c0             	test   %rax,%rax
  802e97:	75 07                	jne    802ea0 <write+0xb9>
		return -E_NOT_SUPP;
  802e99:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e9e:	eb 19                	jmp    802eb9 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802ea0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea4:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ea8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802eac:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802eb0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802eb4:	48 89 cf             	mov    %rcx,%rdi
  802eb7:	ff d0                	callq  *%rax
}
  802eb9:	c9                   	leaveq 
  802eba:	c3                   	retq   

0000000000802ebb <seek>:

int
seek(int fdnum, off_t offset)
{
  802ebb:	55                   	push   %rbp
  802ebc:	48 89 e5             	mov    %rsp,%rbp
  802ebf:	48 83 ec 18          	sub    $0x18,%rsp
  802ec3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ec6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ec9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ecd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ed0:	48 89 d6             	mov    %rdx,%rsi
  802ed3:	89 c7                	mov    %eax,%edi
  802ed5:	48 b8 6b 28 80 00 00 	movabs $0x80286b,%rax
  802edc:	00 00 00 
  802edf:	ff d0                	callq  *%rax
  802ee1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee8:	79 05                	jns    802eef <seek+0x34>
		return r;
  802eea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eed:	eb 0f                	jmp    802efe <seek+0x43>
	fd->fd_offset = offset;
  802eef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ef6:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802ef9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802efe:	c9                   	leaveq 
  802eff:	c3                   	retq   

0000000000802f00 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f00:	55                   	push   %rbp
  802f01:	48 89 e5             	mov    %rsp,%rbp
  802f04:	48 83 ec 30          	sub    $0x30,%rsp
  802f08:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f0b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f0e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f12:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f15:	48 89 d6             	mov    %rdx,%rsi
  802f18:	89 c7                	mov    %eax,%edi
  802f1a:	48 b8 6b 28 80 00 00 	movabs $0x80286b,%rax
  802f21:	00 00 00 
  802f24:	ff d0                	callq  *%rax
  802f26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f2d:	78 24                	js     802f53 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f33:	8b 00                	mov    (%rax),%eax
  802f35:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f39:	48 89 d6             	mov    %rdx,%rsi
  802f3c:	89 c7                	mov    %eax,%edi
  802f3e:	48 b8 c4 29 80 00 00 	movabs $0x8029c4,%rax
  802f45:	00 00 00 
  802f48:	ff d0                	callq  *%rax
  802f4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f51:	79 05                	jns    802f58 <ftruncate+0x58>
		return r;
  802f53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f56:	eb 72                	jmp    802fca <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5c:	8b 40 08             	mov    0x8(%rax),%eax
  802f5f:	83 e0 03             	and    $0x3,%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	75 3a                	jne    802fa0 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802f66:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802f6d:	00 00 00 
  802f70:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802f73:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f79:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f7c:	89 c6                	mov    %eax,%esi
  802f7e:	48 bf e8 56 80 00 00 	movabs $0x8056e8,%rdi
  802f85:	00 00 00 
  802f88:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8d:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  802f94:	00 00 00 
  802f97:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802f99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f9e:	eb 2a                	jmp    802fca <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802fa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa4:	48 8b 40 30          	mov    0x30(%rax),%rax
  802fa8:	48 85 c0             	test   %rax,%rax
  802fab:	75 07                	jne    802fb4 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802fad:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fb2:	eb 16                	jmp    802fca <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802fb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb8:	48 8b 40 30          	mov    0x30(%rax),%rax
  802fbc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fc0:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802fc3:	89 ce                	mov    %ecx,%esi
  802fc5:	48 89 d7             	mov    %rdx,%rdi
  802fc8:	ff d0                	callq  *%rax
}
  802fca:	c9                   	leaveq 
  802fcb:	c3                   	retq   

0000000000802fcc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802fcc:	55                   	push   %rbp
  802fcd:	48 89 e5             	mov    %rsp,%rbp
  802fd0:	48 83 ec 30          	sub    $0x30,%rsp
  802fd4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802fd7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fdb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fdf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fe2:	48 89 d6             	mov    %rdx,%rsi
  802fe5:	89 c7                	mov    %eax,%edi
  802fe7:	48 b8 6b 28 80 00 00 	movabs $0x80286b,%rax
  802fee:	00 00 00 
  802ff1:	ff d0                	callq  *%rax
  802ff3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ffa:	78 24                	js     803020 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ffc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803000:	8b 00                	mov    (%rax),%eax
  803002:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803006:	48 89 d6             	mov    %rdx,%rsi
  803009:	89 c7                	mov    %eax,%edi
  80300b:	48 b8 c4 29 80 00 00 	movabs $0x8029c4,%rax
  803012:	00 00 00 
  803015:	ff d0                	callq  *%rax
  803017:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80301a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80301e:	79 05                	jns    803025 <fstat+0x59>
		return r;
  803020:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803023:	eb 5e                	jmp    803083 <fstat+0xb7>
	if (!dev->dev_stat)
  803025:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803029:	48 8b 40 28          	mov    0x28(%rax),%rax
  80302d:	48 85 c0             	test   %rax,%rax
  803030:	75 07                	jne    803039 <fstat+0x6d>
		return -E_NOT_SUPP;
  803032:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803037:	eb 4a                	jmp    803083 <fstat+0xb7>
	stat->st_name[0] = 0;
  803039:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80303d:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803040:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803044:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80304b:	00 00 00 
	stat->st_isdir = 0;
  80304e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803052:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803059:	00 00 00 
	stat->st_dev = dev;
  80305c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803060:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803064:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80306b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80306f:	48 8b 40 28          	mov    0x28(%rax),%rax
  803073:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803077:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80307b:	48 89 ce             	mov    %rcx,%rsi
  80307e:	48 89 d7             	mov    %rdx,%rdi
  803081:	ff d0                	callq  *%rax
}
  803083:	c9                   	leaveq 
  803084:	c3                   	retq   

0000000000803085 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803085:	55                   	push   %rbp
  803086:	48 89 e5             	mov    %rsp,%rbp
  803089:	48 83 ec 20          	sub    $0x20,%rsp
  80308d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803091:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803095:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803099:	be 00 00 00 00       	mov    $0x0,%esi
  80309e:	48 89 c7             	mov    %rax,%rdi
  8030a1:	48 b8 73 31 80 00 00 	movabs $0x803173,%rax
  8030a8:	00 00 00 
  8030ab:	ff d0                	callq  *%rax
  8030ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b4:	79 05                	jns    8030bb <stat+0x36>
		return fd;
  8030b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b9:	eb 2f                	jmp    8030ea <stat+0x65>
	r = fstat(fd, stat);
  8030bb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8030bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c2:	48 89 d6             	mov    %rdx,%rsi
  8030c5:	89 c7                	mov    %eax,%edi
  8030c7:	48 b8 cc 2f 80 00 00 	movabs $0x802fcc,%rax
  8030ce:	00 00 00 
  8030d1:	ff d0                	callq  *%rax
  8030d3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8030d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d9:	89 c7                	mov    %eax,%edi
  8030db:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  8030e2:	00 00 00 
  8030e5:	ff d0                	callq  *%rax
	return r;
  8030e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8030ea:	c9                   	leaveq 
  8030eb:	c3                   	retq   

00000000008030ec <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8030ec:	55                   	push   %rbp
  8030ed:	48 89 e5             	mov    %rsp,%rbp
  8030f0:	48 83 ec 10          	sub    $0x10,%rsp
  8030f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8030fb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803102:	00 00 00 
  803105:	8b 00                	mov    (%rax),%eax
  803107:	85 c0                	test   %eax,%eax
  803109:	75 1d                	jne    803128 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80310b:	bf 01 00 00 00       	mov    $0x1,%edi
  803110:	48 b8 68 4e 80 00 00 	movabs $0x804e68,%rax
  803117:	00 00 00 
  80311a:	ff d0                	callq  *%rax
  80311c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803123:	00 00 00 
  803126:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803128:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80312f:	00 00 00 
  803132:	8b 00                	mov    (%rax),%eax
  803134:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803137:	b9 07 00 00 00       	mov    $0x7,%ecx
  80313c:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803143:	00 00 00 
  803146:	89 c7                	mov    %eax,%edi
  803148:	48 b8 69 4d 80 00 00 	movabs $0x804d69,%rax
  80314f:	00 00 00 
  803152:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803154:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803158:	ba 00 00 00 00       	mov    $0x0,%edx
  80315d:	48 89 c6             	mov    %rax,%rsi
  803160:	bf 00 00 00 00       	mov    $0x0,%edi
  803165:	48 b8 b6 4c 80 00 00 	movabs $0x804cb6,%rax
  80316c:	00 00 00 
  80316f:	ff d0                	callq  *%rax
}
  803171:	c9                   	leaveq 
  803172:	c3                   	retq   

0000000000803173 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803173:	55                   	push   %rbp
  803174:	48 89 e5             	mov    %rsp,%rbp
  803177:	48 83 ec 20          	sub    $0x20,%rsp
  80317b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80317f:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  803182:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803186:	48 89 c7             	mov    %rax,%rdi
  803189:	48 b8 11 11 80 00 00 	movabs $0x801111,%rax
  803190:	00 00 00 
  803193:	ff d0                	callq  *%rax
  803195:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80319a:	7e 0a                	jle    8031a6 <open+0x33>
		return -E_BAD_PATH;
  80319c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031a1:	e9 a5 00 00 00       	jmpq   80324b <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  8031a6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8031aa:	48 89 c7             	mov    %rax,%rdi
  8031ad:	48 b8 d3 27 80 00 00 	movabs $0x8027d3,%rax
  8031b4:	00 00 00 
  8031b7:	ff d0                	callq  *%rax
  8031b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c0:	79 08                	jns    8031ca <open+0x57>
		return ret;
  8031c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c5:	e9 81 00 00 00       	jmpq   80324b <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  8031ca:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031d1:	00 00 00 
  8031d4:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8031d7:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  8031dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031e1:	48 89 c6             	mov    %rax,%rsi
  8031e4:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8031eb:	00 00 00 
  8031ee:	48 b8 7d 11 80 00 00 	movabs $0x80117d,%rax
  8031f5:	00 00 00 
  8031f8:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  8031fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031fe:	48 89 c6             	mov    %rax,%rsi
  803201:	bf 01 00 00 00       	mov    $0x1,%edi
  803206:	48 b8 ec 30 80 00 00 	movabs $0x8030ec,%rax
  80320d:	00 00 00 
  803210:	ff d0                	callq  *%rax
  803212:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803215:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803219:	79 1d                	jns    803238 <open+0xc5>
	{
		fd_close(fd,0);
  80321b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80321f:	be 00 00 00 00       	mov    $0x0,%esi
  803224:	48 89 c7             	mov    %rax,%rdi
  803227:	48 b8 fb 28 80 00 00 	movabs $0x8028fb,%rax
  80322e:	00 00 00 
  803231:	ff d0                	callq  *%rax
		return ret;
  803233:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803236:	eb 13                	jmp    80324b <open+0xd8>
	}
	return fd2num (fd);
  803238:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80323c:	48 89 c7             	mov    %rax,%rdi
  80323f:	48 b8 85 27 80 00 00 	movabs $0x802785,%rax
  803246:	00 00 00 
  803249:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  80324b:	c9                   	leaveq 
  80324c:	c3                   	retq   

000000000080324d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80324d:	55                   	push   %rbp
  80324e:	48 89 e5             	mov    %rsp,%rbp
  803251:	48 83 ec 10          	sub    $0x10,%rsp
  803255:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803259:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80325d:	8b 50 0c             	mov    0xc(%rax),%edx
  803260:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803267:	00 00 00 
  80326a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80326c:	be 00 00 00 00       	mov    $0x0,%esi
  803271:	bf 06 00 00 00       	mov    $0x6,%edi
  803276:	48 b8 ec 30 80 00 00 	movabs $0x8030ec,%rax
  80327d:	00 00 00 
  803280:	ff d0                	callq  *%rax
}
  803282:	c9                   	leaveq 
  803283:	c3                   	retq   

0000000000803284 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803284:	55                   	push   %rbp
  803285:	48 89 e5             	mov    %rsp,%rbp
  803288:	48 83 ec 30          	sub    $0x30,%rsp
  80328c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803290:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803294:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  803298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80329c:	8b 50 0c             	mov    0xc(%rax),%edx
  80329f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032a6:	00 00 00 
  8032a9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  8032ab:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032b2:	00 00 00 
  8032b5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032b9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  8032bd:	be 00 00 00 00       	mov    $0x0,%esi
  8032c2:	bf 03 00 00 00       	mov    $0x3,%edi
  8032c7:	48 b8 ec 30 80 00 00 	movabs $0x8030ec,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax
  8032d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032da:	79 05                	jns    8032e1 <devfile_read+0x5d>
		return ret;
  8032dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032df:	eb 26                	jmp    803307 <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  8032e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e4:	48 63 d0             	movslq %eax,%rdx
  8032e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032eb:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8032f2:	00 00 00 
  8032f5:	48 89 c7             	mov    %rax,%rdi
  8032f8:	48 b8 a1 14 80 00 00 	movabs $0x8014a1,%rax
  8032ff:	00 00 00 
  803302:	ff d0                	callq  *%rax
	return ret;
  803304:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  803307:	c9                   	leaveq 
  803308:	c3                   	retq   

0000000000803309 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803309:	55                   	push   %rbp
  80330a:	48 89 e5             	mov    %rsp,%rbp
  80330d:	48 83 ec 30          	sub    $0x30,%rsp
  803311:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803315:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803319:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  80331d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803321:	8b 50 0c             	mov    0xc(%rax),%edx
  803324:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80332b:	00 00 00 
  80332e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  803330:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  803335:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80333c:	00 
  80333d:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  803342:	48 89 c2             	mov    %rax,%rdx
  803345:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80334c:	00 00 00 
  80334f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  803353:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80335a:	00 00 00 
  80335d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803361:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803365:	48 89 c6             	mov    %rax,%rsi
  803368:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80336f:	00 00 00 
  803372:	48 b8 a1 14 80 00 00 	movabs $0x8014a1,%rax
  803379:	00 00 00 
  80337c:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  80337e:	be 00 00 00 00       	mov    $0x0,%esi
  803383:	bf 04 00 00 00       	mov    $0x4,%edi
  803388:	48 b8 ec 30 80 00 00 	movabs $0x8030ec,%rax
  80338f:	00 00 00 
  803392:	ff d0                	callq  *%rax
  803394:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803397:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80339b:	79 05                	jns    8033a2 <devfile_write+0x99>
		return ret;
  80339d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a0:	eb 03                	jmp    8033a5 <devfile_write+0x9c>
	
	return ret;
  8033a2:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  8033a5:	c9                   	leaveq 
  8033a6:	c3                   	retq   

00000000008033a7 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8033a7:	55                   	push   %rbp
  8033a8:	48 89 e5             	mov    %rsp,%rbp
  8033ab:	48 83 ec 20          	sub    $0x20,%rsp
  8033af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8033b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033bb:	8b 50 0c             	mov    0xc(%rax),%edx
  8033be:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033c5:	00 00 00 
  8033c8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8033ca:	be 00 00 00 00       	mov    $0x0,%esi
  8033cf:	bf 05 00 00 00       	mov    $0x5,%edi
  8033d4:	48 b8 ec 30 80 00 00 	movabs $0x8030ec,%rax
  8033db:	00 00 00 
  8033de:	ff d0                	callq  *%rax
  8033e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e7:	79 05                	jns    8033ee <devfile_stat+0x47>
		return r;
  8033e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ec:	eb 56                	jmp    803444 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8033ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f2:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8033f9:	00 00 00 
  8033fc:	48 89 c7             	mov    %rax,%rdi
  8033ff:	48 b8 7d 11 80 00 00 	movabs $0x80117d,%rax
  803406:	00 00 00 
  803409:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80340b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803412:	00 00 00 
  803415:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80341b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80341f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803425:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80342c:	00 00 00 
  80342f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803435:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803439:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80343f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803444:	c9                   	leaveq 
  803445:	c3                   	retq   

0000000000803446 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803446:	55                   	push   %rbp
  803447:	48 89 e5             	mov    %rsp,%rbp
  80344a:	48 83 ec 10          	sub    $0x10,%rsp
  80344e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803452:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803459:	8b 50 0c             	mov    0xc(%rax),%edx
  80345c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803463:	00 00 00 
  803466:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803468:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80346f:	00 00 00 
  803472:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803475:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803478:	be 00 00 00 00       	mov    $0x0,%esi
  80347d:	bf 02 00 00 00       	mov    $0x2,%edi
  803482:	48 b8 ec 30 80 00 00 	movabs $0x8030ec,%rax
  803489:	00 00 00 
  80348c:	ff d0                	callq  *%rax
}
  80348e:	c9                   	leaveq 
  80348f:	c3                   	retq   

0000000000803490 <remove>:

// Delete a file
int
remove(const char *path)
{
  803490:	55                   	push   %rbp
  803491:	48 89 e5             	mov    %rsp,%rbp
  803494:	48 83 ec 10          	sub    $0x10,%rsp
  803498:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80349c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a0:	48 89 c7             	mov    %rax,%rdi
  8034a3:	48 b8 11 11 80 00 00 	movabs $0x801111,%rax
  8034aa:	00 00 00 
  8034ad:	ff d0                	callq  *%rax
  8034af:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8034b4:	7e 07                	jle    8034bd <remove+0x2d>
		return -E_BAD_PATH;
  8034b6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034bb:	eb 33                	jmp    8034f0 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8034bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c1:	48 89 c6             	mov    %rax,%rsi
  8034c4:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8034cb:	00 00 00 
  8034ce:	48 b8 7d 11 80 00 00 	movabs $0x80117d,%rax
  8034d5:	00 00 00 
  8034d8:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8034da:	be 00 00 00 00       	mov    $0x0,%esi
  8034df:	bf 07 00 00 00       	mov    $0x7,%edi
  8034e4:	48 b8 ec 30 80 00 00 	movabs $0x8030ec,%rax
  8034eb:	00 00 00 
  8034ee:	ff d0                	callq  *%rax
}
  8034f0:	c9                   	leaveq 
  8034f1:	c3                   	retq   

00000000008034f2 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8034f2:	55                   	push   %rbp
  8034f3:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8034f6:	be 00 00 00 00       	mov    $0x0,%esi
  8034fb:	bf 08 00 00 00       	mov    $0x8,%edi
  803500:	48 b8 ec 30 80 00 00 	movabs $0x8030ec,%rax
  803507:	00 00 00 
  80350a:	ff d0                	callq  *%rax
}
  80350c:	5d                   	pop    %rbp
  80350d:	c3                   	retq   

000000000080350e <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80350e:	55                   	push   %rbp
  80350f:	48 89 e5             	mov    %rsp,%rbp
  803512:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803519:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803520:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803527:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80352e:	be 00 00 00 00       	mov    $0x0,%esi
  803533:	48 89 c7             	mov    %rax,%rdi
  803536:	48 b8 73 31 80 00 00 	movabs $0x803173,%rax
  80353d:	00 00 00 
  803540:	ff d0                	callq  *%rax
  803542:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803545:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803549:	79 28                	jns    803573 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80354b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354e:	89 c6                	mov    %eax,%esi
  803550:	48 bf 0e 57 80 00 00 	movabs $0x80570e,%rdi
  803557:	00 00 00 
  80355a:	b8 00 00 00 00       	mov    $0x0,%eax
  80355f:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  803566:	00 00 00 
  803569:	ff d2                	callq  *%rdx
		return fd_src;
  80356b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80356e:	e9 74 01 00 00       	jmpq   8036e7 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803573:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80357a:	be 01 01 00 00       	mov    $0x101,%esi
  80357f:	48 89 c7             	mov    %rax,%rdi
  803582:	48 b8 73 31 80 00 00 	movabs $0x803173,%rax
  803589:	00 00 00 
  80358c:	ff d0                	callq  *%rax
  80358e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803591:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803595:	79 39                	jns    8035d0 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803597:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80359a:	89 c6                	mov    %eax,%esi
  80359c:	48 bf 24 57 80 00 00 	movabs $0x805724,%rdi
  8035a3:	00 00 00 
  8035a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ab:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  8035b2:	00 00 00 
  8035b5:	ff d2                	callq  *%rdx
		close(fd_src);
  8035b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ba:	89 c7                	mov    %eax,%edi
  8035bc:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  8035c3:	00 00 00 
  8035c6:	ff d0                	callq  *%rax
		return fd_dest;
  8035c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035cb:	e9 17 01 00 00       	jmpq   8036e7 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8035d0:	eb 74                	jmp    803646 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8035d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035d5:	48 63 d0             	movslq %eax,%rdx
  8035d8:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8035df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035e2:	48 89 ce             	mov    %rcx,%rsi
  8035e5:	89 c7                	mov    %eax,%edi
  8035e7:	48 b8 e7 2d 80 00 00 	movabs $0x802de7,%rax
  8035ee:	00 00 00 
  8035f1:	ff d0                	callq  *%rax
  8035f3:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8035f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8035fa:	79 4a                	jns    803646 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8035fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035ff:	89 c6                	mov    %eax,%esi
  803601:	48 bf 3e 57 80 00 00 	movabs $0x80573e,%rdi
  803608:	00 00 00 
  80360b:	b8 00 00 00 00       	mov    $0x0,%eax
  803610:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  803617:	00 00 00 
  80361a:	ff d2                	callq  *%rdx
			close(fd_src);
  80361c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80361f:	89 c7                	mov    %eax,%edi
  803621:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  803628:	00 00 00 
  80362b:	ff d0                	callq  *%rax
			close(fd_dest);
  80362d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803630:	89 c7                	mov    %eax,%edi
  803632:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  803639:	00 00 00 
  80363c:	ff d0                	callq  *%rax
			return write_size;
  80363e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803641:	e9 a1 00 00 00       	jmpq   8036e7 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803646:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80364d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803650:	ba 00 02 00 00       	mov    $0x200,%edx
  803655:	48 89 ce             	mov    %rcx,%rsi
  803658:	89 c7                	mov    %eax,%edi
  80365a:	48 b8 9d 2c 80 00 00 	movabs $0x802c9d,%rax
  803661:	00 00 00 
  803664:	ff d0                	callq  *%rax
  803666:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803669:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80366d:	0f 8f 5f ff ff ff    	jg     8035d2 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803673:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803677:	79 47                	jns    8036c0 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803679:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80367c:	89 c6                	mov    %eax,%esi
  80367e:	48 bf 51 57 80 00 00 	movabs $0x805751,%rdi
  803685:	00 00 00 
  803688:	b8 00 00 00 00       	mov    $0x0,%eax
  80368d:	48 ba 87 05 80 00 00 	movabs $0x800587,%rdx
  803694:	00 00 00 
  803697:	ff d2                	callq  *%rdx
		close(fd_src);
  803699:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80369c:	89 c7                	mov    %eax,%edi
  80369e:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  8036a5:	00 00 00 
  8036a8:	ff d0                	callq  *%rax
		close(fd_dest);
  8036aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036ad:	89 c7                	mov    %eax,%edi
  8036af:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  8036b6:	00 00 00 
  8036b9:	ff d0                	callq  *%rax
		return read_size;
  8036bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036be:	eb 27                	jmp    8036e7 <copy+0x1d9>
	}
	close(fd_src);
  8036c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c3:	89 c7                	mov    %eax,%edi
  8036c5:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  8036cc:	00 00 00 
  8036cf:	ff d0                	callq  *%rax
	close(fd_dest);
  8036d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036d4:	89 c7                	mov    %eax,%edi
  8036d6:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  8036dd:	00 00 00 
  8036e0:	ff d0                	callq  *%rax
	return 0;
  8036e2:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8036e7:	c9                   	leaveq 
  8036e8:	c3                   	retq   

00000000008036e9 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8036e9:	55                   	push   %rbp
  8036ea:	48 89 e5             	mov    %rsp,%rbp
  8036ed:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  8036f4:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  8036fb:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803702:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  803709:	be 00 00 00 00       	mov    $0x0,%esi
  80370e:	48 89 c7             	mov    %rax,%rdi
  803711:	48 b8 73 31 80 00 00 	movabs $0x803173,%rax
  803718:	00 00 00 
  80371b:	ff d0                	callq  *%rax
  80371d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803720:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803724:	79 08                	jns    80372e <spawn+0x45>
		return r;
  803726:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803729:	e9 0c 03 00 00       	jmpq   803a3a <spawn+0x351>
	fd = r;
  80372e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803731:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803734:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  80373b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80373f:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803746:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803749:	ba 00 02 00 00       	mov    $0x200,%edx
  80374e:	48 89 ce             	mov    %rcx,%rsi
  803751:	89 c7                	mov    %eax,%edi
  803753:	48 b8 72 2d 80 00 00 	movabs $0x802d72,%rax
  80375a:	00 00 00 
  80375d:	ff d0                	callq  *%rax
  80375f:	3d 00 02 00 00       	cmp    $0x200,%eax
  803764:	75 0d                	jne    803773 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803766:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80376a:	8b 00                	mov    (%rax),%eax
  80376c:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803771:	74 43                	je     8037b6 <spawn+0xcd>
		close(fd);
  803773:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803776:	89 c7                	mov    %eax,%edi
  803778:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  80377f:	00 00 00 
  803782:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803788:	8b 00                	mov    (%rax),%eax
  80378a:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  80378f:	89 c6                	mov    %eax,%esi
  803791:	48 bf 68 57 80 00 00 	movabs $0x805768,%rdi
  803798:	00 00 00 
  80379b:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a0:	48 b9 87 05 80 00 00 	movabs $0x800587,%rcx
  8037a7:	00 00 00 
  8037aa:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  8037ac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8037b1:	e9 84 02 00 00       	jmpq   803a3a <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8037b6:	b8 07 00 00 00       	mov    $0x7,%eax
  8037bb:	cd 30                	int    $0x30
  8037bd:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8037c0:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8037c3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8037c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8037ca:	79 08                	jns    8037d4 <spawn+0xeb>
		return r;
  8037cc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8037cf:	e9 66 02 00 00       	jmpq   803a3a <spawn+0x351>
	child = r;
  8037d4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8037d7:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8037da:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8037dd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8037e2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8037e9:	00 00 00 
  8037ec:	48 98                	cltq   
  8037ee:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8037f5:	48 01 d0             	add    %rdx,%rax
  8037f8:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8037ff:	48 89 c6             	mov    %rax,%rsi
  803802:	b8 18 00 00 00       	mov    $0x18,%eax
  803807:	48 89 d7             	mov    %rdx,%rdi
  80380a:	48 89 c1             	mov    %rax,%rcx
  80380d:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803810:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803814:	48 8b 40 18          	mov    0x18(%rax),%rax
  803818:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  80381f:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803826:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  80382d:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803834:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803837:	48 89 ce             	mov    %rcx,%rsi
  80383a:	89 c7                	mov    %eax,%edi
  80383c:	48 b8 a4 3c 80 00 00 	movabs $0x803ca4,%rax
  803843:	00 00 00 
  803846:	ff d0                	callq  *%rax
  803848:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80384b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80384f:	79 08                	jns    803859 <spawn+0x170>
		return r;
  803851:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803854:	e9 e1 01 00 00       	jmpq   803a3a <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803859:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80385d:	48 8b 40 20          	mov    0x20(%rax),%rax
  803861:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803868:	48 01 d0             	add    %rdx,%rax
  80386b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80386f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803876:	e9 a3 00 00 00       	jmpq   80391e <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  80387b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387f:	8b 00                	mov    (%rax),%eax
  803881:	83 f8 01             	cmp    $0x1,%eax
  803884:	74 05                	je     80388b <spawn+0x1a2>
			continue;
  803886:	e9 8a 00 00 00       	jmpq   803915 <spawn+0x22c>
		perm = PTE_P | PTE_U;
  80388b:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803892:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803896:	8b 40 04             	mov    0x4(%rax),%eax
  803899:	83 e0 02             	and    $0x2,%eax
  80389c:	85 c0                	test   %eax,%eax
  80389e:	74 04                	je     8038a4 <spawn+0x1bb>
			perm |= PTE_W;
  8038a0:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  8038a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a8:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8038ac:	41 89 c1             	mov    %eax,%r9d
  8038af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b3:	4c 8b 40 20          	mov    0x20(%rax),%r8
  8038b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bb:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8038bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c3:	48 8b 70 10          	mov    0x10(%rax),%rsi
  8038c7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8038ca:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8038cd:	8b 7d ec             	mov    -0x14(%rbp),%edi
  8038d0:	89 3c 24             	mov    %edi,(%rsp)
  8038d3:	89 c7                	mov    %eax,%edi
  8038d5:	48 b8 4d 3f 80 00 00 	movabs $0x803f4d,%rax
  8038dc:	00 00 00 
  8038df:	ff d0                	callq  *%rax
  8038e1:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8038e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8038e8:	79 2b                	jns    803915 <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  8038ea:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8038eb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8038ee:	89 c7                	mov    %eax,%edi
  8038f0:	48 b8 ec 19 80 00 00 	movabs $0x8019ec,%rax
  8038f7:	00 00 00 
  8038fa:	ff d0                	callq  *%rax
	close(fd);
  8038fc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8038ff:	89 c7                	mov    %eax,%edi
  803901:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  803908:	00 00 00 
  80390b:	ff d0                	callq  *%rax
	return r;
  80390d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803910:	e9 25 01 00 00       	jmpq   803a3a <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803915:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803919:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  80391e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803922:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803926:	0f b7 c0             	movzwl %ax,%eax
  803929:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80392c:	0f 8f 49 ff ff ff    	jg     80387b <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803932:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803935:	89 c7                	mov    %eax,%edi
  803937:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  80393e:	00 00 00 
  803941:	ff d0                	callq  *%rax
	fd = -1;
  803943:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  80394a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80394d:	89 c7                	mov    %eax,%edi
  80394f:	48 b8 39 41 80 00 00 	movabs $0x804139,%rax
  803956:	00 00 00 
  803959:	ff d0                	callq  *%rax
  80395b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80395e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803962:	79 30                	jns    803994 <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  803964:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803967:	89 c1                	mov    %eax,%ecx
  803969:	48 ba 82 57 80 00 00 	movabs $0x805782,%rdx
  803970:	00 00 00 
  803973:	be 82 00 00 00       	mov    $0x82,%esi
  803978:	48 bf 98 57 80 00 00 	movabs $0x805798,%rdi
  80397f:	00 00 00 
  803982:	b8 00 00 00 00       	mov    $0x0,%eax
  803987:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  80398e:	00 00 00 
  803991:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803994:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  80399b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80399e:	48 89 d6             	mov    %rdx,%rsi
  8039a1:	89 c7                	mov    %eax,%edi
  8039a3:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  8039aa:	00 00 00 
  8039ad:	ff d0                	callq  *%rax
  8039af:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8039b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8039b6:	79 30                	jns    8039e8 <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  8039b8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8039bb:	89 c1                	mov    %eax,%ecx
  8039bd:	48 ba a4 57 80 00 00 	movabs $0x8057a4,%rdx
  8039c4:	00 00 00 
  8039c7:	be 85 00 00 00       	mov    $0x85,%esi
  8039cc:	48 bf 98 57 80 00 00 	movabs $0x805798,%rdi
  8039d3:	00 00 00 
  8039d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039db:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  8039e2:	00 00 00 
  8039e5:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8039e8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8039eb:	be 02 00 00 00       	mov    $0x2,%esi
  8039f0:	89 c7                	mov    %eax,%edi
  8039f2:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8039f9:	00 00 00 
  8039fc:	ff d0                	callq  *%rax
  8039fe:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803a01:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803a05:	79 30                	jns    803a37 <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  803a07:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a0a:	89 c1                	mov    %eax,%ecx
  803a0c:	48 ba be 57 80 00 00 	movabs $0x8057be,%rdx
  803a13:	00 00 00 
  803a16:	be 88 00 00 00       	mov    $0x88,%esi
  803a1b:	48 bf 98 57 80 00 00 	movabs $0x805798,%rdi
  803a22:	00 00 00 
  803a25:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2a:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803a31:	00 00 00 
  803a34:	41 ff d0             	callq  *%r8

	return child;
  803a37:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803a3a:	c9                   	leaveq 
  803a3b:	c3                   	retq   

0000000000803a3c <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803a3c:	55                   	push   %rbp
  803a3d:	48 89 e5             	mov    %rsp,%rbp
  803a40:	41 55                	push   %r13
  803a42:	41 54                	push   %r12
  803a44:	53                   	push   %rbx
  803a45:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803a4c:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803a53:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803a5a:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803a61:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803a68:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803a6f:	84 c0                	test   %al,%al
  803a71:	74 26                	je     803a99 <spawnl+0x5d>
  803a73:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803a7a:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803a81:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803a85:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803a89:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803a8d:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803a91:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803a95:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803a99:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803aa0:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803aa7:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803aaa:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803ab1:	00 00 00 
  803ab4:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803abb:	00 00 00 
  803abe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803ac2:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803ac9:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803ad0:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803ad7:	eb 07                	jmp    803ae0 <spawnl+0xa4>
		argc++;
  803ad9:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803ae0:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803ae6:	83 f8 30             	cmp    $0x30,%eax
  803ae9:	73 23                	jae    803b0e <spawnl+0xd2>
  803aeb:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803af2:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803af8:	89 c0                	mov    %eax,%eax
  803afa:	48 01 d0             	add    %rdx,%rax
  803afd:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803b03:	83 c2 08             	add    $0x8,%edx
  803b06:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803b0c:	eb 15                	jmp    803b23 <spawnl+0xe7>
  803b0e:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803b15:	48 89 d0             	mov    %rdx,%rax
  803b18:	48 83 c2 08          	add    $0x8,%rdx
  803b1c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803b23:	48 8b 00             	mov    (%rax),%rax
  803b26:	48 85 c0             	test   %rax,%rax
  803b29:	75 ae                	jne    803ad9 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803b2b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803b31:	83 c0 02             	add    $0x2,%eax
  803b34:	48 89 e2             	mov    %rsp,%rdx
  803b37:	48 89 d3             	mov    %rdx,%rbx
  803b3a:	48 63 d0             	movslq %eax,%rdx
  803b3d:	48 83 ea 01          	sub    $0x1,%rdx
  803b41:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803b48:	48 63 d0             	movslq %eax,%rdx
  803b4b:	49 89 d4             	mov    %rdx,%r12
  803b4e:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803b54:	48 63 d0             	movslq %eax,%rdx
  803b57:	49 89 d2             	mov    %rdx,%r10
  803b5a:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803b60:	48 98                	cltq   
  803b62:	48 c1 e0 03          	shl    $0x3,%rax
  803b66:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803b6a:	b8 10 00 00 00       	mov    $0x10,%eax
  803b6f:	48 83 e8 01          	sub    $0x1,%rax
  803b73:	48 01 d0             	add    %rdx,%rax
  803b76:	bf 10 00 00 00       	mov    $0x10,%edi
  803b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  803b80:	48 f7 f7             	div    %rdi
  803b83:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803b87:	48 29 c4             	sub    %rax,%rsp
  803b8a:	48 89 e0             	mov    %rsp,%rax
  803b8d:	48 83 c0 07          	add    $0x7,%rax
  803b91:	48 c1 e8 03          	shr    $0x3,%rax
  803b95:	48 c1 e0 03          	shl    $0x3,%rax
  803b99:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803ba0:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803ba7:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803bae:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803bb1:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803bb7:	8d 50 01             	lea    0x1(%rax),%edx
  803bba:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803bc1:	48 63 d2             	movslq %edx,%rdx
  803bc4:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803bcb:	00 

	va_start(vl, arg0);
  803bcc:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803bd3:	00 00 00 
  803bd6:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803bdd:	00 00 00 
  803be0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803be4:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803beb:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803bf2:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803bf9:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803c00:	00 00 00 
  803c03:	eb 63                	jmp    803c68 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803c05:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803c0b:	8d 70 01             	lea    0x1(%rax),%esi
  803c0e:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803c14:	83 f8 30             	cmp    $0x30,%eax
  803c17:	73 23                	jae    803c3c <spawnl+0x200>
  803c19:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803c20:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803c26:	89 c0                	mov    %eax,%eax
  803c28:	48 01 d0             	add    %rdx,%rax
  803c2b:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803c31:	83 c2 08             	add    $0x8,%edx
  803c34:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803c3a:	eb 15                	jmp    803c51 <spawnl+0x215>
  803c3c:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803c43:	48 89 d0             	mov    %rdx,%rax
  803c46:	48 83 c2 08          	add    $0x8,%rdx
  803c4a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803c51:	48 8b 08             	mov    (%rax),%rcx
  803c54:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803c5b:	89 f2                	mov    %esi,%edx
  803c5d:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803c61:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803c68:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803c6e:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803c74:	77 8f                	ja     803c05 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803c76:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803c7d:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803c84:	48 89 d6             	mov    %rdx,%rsi
  803c87:	48 89 c7             	mov    %rax,%rdi
  803c8a:	48 b8 e9 36 80 00 00 	movabs $0x8036e9,%rax
  803c91:	00 00 00 
  803c94:	ff d0                	callq  *%rax
  803c96:	48 89 dc             	mov    %rbx,%rsp
}
  803c99:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803c9d:	5b                   	pop    %rbx
  803c9e:	41 5c                	pop    %r12
  803ca0:	41 5d                	pop    %r13
  803ca2:	5d                   	pop    %rbp
  803ca3:	c3                   	retq   

0000000000803ca4 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803ca4:	55                   	push   %rbp
  803ca5:	48 89 e5             	mov    %rsp,%rbp
  803ca8:	48 83 ec 50          	sub    $0x50,%rsp
  803cac:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803caf:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803cb3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803cb7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803cbe:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803cbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803cc6:	eb 33                	jmp    803cfb <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803cc8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ccb:	48 98                	cltq   
  803ccd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803cd4:	00 
  803cd5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803cd9:	48 01 d0             	add    %rdx,%rax
  803cdc:	48 8b 00             	mov    (%rax),%rax
  803cdf:	48 89 c7             	mov    %rax,%rdi
  803ce2:	48 b8 11 11 80 00 00 	movabs $0x801111,%rax
  803ce9:	00 00 00 
  803cec:	ff d0                	callq  *%rax
  803cee:	83 c0 01             	add    $0x1,%eax
  803cf1:	48 98                	cltq   
  803cf3:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803cf7:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803cfb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803cfe:	48 98                	cltq   
  803d00:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803d07:	00 
  803d08:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803d0c:	48 01 d0             	add    %rdx,%rax
  803d0f:	48 8b 00             	mov    (%rax),%rax
  803d12:	48 85 c0             	test   %rax,%rax
  803d15:	75 b1                	jne    803cc8 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803d17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d1b:	48 f7 d8             	neg    %rax
  803d1e:	48 05 00 10 40 00    	add    $0x401000,%rax
  803d24:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803d28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d2c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803d30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d34:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803d38:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d3b:	83 c2 01             	add    $0x1,%edx
  803d3e:	c1 e2 03             	shl    $0x3,%edx
  803d41:	48 63 d2             	movslq %edx,%rdx
  803d44:	48 f7 da             	neg    %rdx
  803d47:	48 01 d0             	add    %rdx,%rax
  803d4a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803d4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d52:	48 83 e8 10          	sub    $0x10,%rax
  803d56:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803d5c:	77 0a                	ja     803d68 <init_stack+0xc4>
		return -E_NO_MEM;
  803d5e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803d63:	e9 e3 01 00 00       	jmpq   803f4b <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803d68:	ba 07 00 00 00       	mov    $0x7,%edx
  803d6d:	be 00 00 40 00       	mov    $0x400000,%esi
  803d72:	bf 00 00 00 00       	mov    $0x0,%edi
  803d77:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  803d7e:	00 00 00 
  803d81:	ff d0                	callq  *%rax
  803d83:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d86:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d8a:	79 08                	jns    803d94 <init_stack+0xf0>
		return r;
  803d8c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d8f:	e9 b7 01 00 00       	jmpq   803f4b <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803d94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803d9b:	e9 8a 00 00 00       	jmpq   803e2a <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803da0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803da3:	48 98                	cltq   
  803da5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803dac:	00 
  803dad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803db1:	48 01 c2             	add    %rax,%rdx
  803db4:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803db9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dbd:	48 01 c8             	add    %rcx,%rax
  803dc0:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803dc6:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803dc9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803dcc:	48 98                	cltq   
  803dce:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803dd5:	00 
  803dd6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803dda:	48 01 d0             	add    %rdx,%rax
  803ddd:	48 8b 10             	mov    (%rax),%rdx
  803de0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803de4:	48 89 d6             	mov    %rdx,%rsi
  803de7:	48 89 c7             	mov    %rax,%rdi
  803dea:	48 b8 7d 11 80 00 00 	movabs $0x80117d,%rax
  803df1:	00 00 00 
  803df4:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803df6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803df9:	48 98                	cltq   
  803dfb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803e02:	00 
  803e03:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803e07:	48 01 d0             	add    %rdx,%rax
  803e0a:	48 8b 00             	mov    (%rax),%rax
  803e0d:	48 89 c7             	mov    %rax,%rdi
  803e10:	48 b8 11 11 80 00 00 	movabs $0x801111,%rax
  803e17:	00 00 00 
  803e1a:	ff d0                	callq  *%rax
  803e1c:	48 98                	cltq   
  803e1e:	48 83 c0 01          	add    $0x1,%rax
  803e22:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803e26:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803e2a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e2d:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803e30:	0f 8c 6a ff ff ff    	jl     803da0 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803e36:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803e39:	48 98                	cltq   
  803e3b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803e42:	00 
  803e43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e47:	48 01 d0             	add    %rdx,%rax
  803e4a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803e51:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803e58:	00 
  803e59:	74 35                	je     803e90 <init_stack+0x1ec>
  803e5b:	48 b9 d8 57 80 00 00 	movabs $0x8057d8,%rcx
  803e62:	00 00 00 
  803e65:	48 ba fe 57 80 00 00 	movabs $0x8057fe,%rdx
  803e6c:	00 00 00 
  803e6f:	be f1 00 00 00       	mov    $0xf1,%esi
  803e74:	48 bf 98 57 80 00 00 	movabs $0x805798,%rdi
  803e7b:	00 00 00 
  803e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  803e83:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  803e8a:	00 00 00 
  803e8d:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803e90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e94:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803e98:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803e9d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ea1:	48 01 c8             	add    %rcx,%rax
  803ea4:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803eaa:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803ead:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eb1:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803eb5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803eb8:	48 98                	cltq   
  803eba:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803ebd:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803ec2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ec6:	48 01 d0             	add    %rdx,%rax
  803ec9:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803ecf:	48 89 c2             	mov    %rax,%rdx
  803ed2:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803ed6:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803ed9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803edc:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803ee2:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803ee7:	89 c2                	mov    %eax,%edx
  803ee9:	be 00 00 40 00       	mov    $0x400000,%esi
  803eee:	bf 00 00 00 00       	mov    $0x0,%edi
  803ef3:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  803efa:	00 00 00 
  803efd:	ff d0                	callq  *%rax
  803eff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f02:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f06:	79 02                	jns    803f0a <init_stack+0x266>
		goto error;
  803f08:	eb 28                	jmp    803f32 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803f0a:	be 00 00 40 00       	mov    $0x400000,%esi
  803f0f:	bf 00 00 00 00       	mov    $0x0,%edi
  803f14:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  803f1b:	00 00 00 
  803f1e:	ff d0                	callq  *%rax
  803f20:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f23:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f27:	79 02                	jns    803f2b <init_stack+0x287>
		goto error;
  803f29:	eb 07                	jmp    803f32 <init_stack+0x28e>

	return 0;
  803f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  803f30:	eb 19                	jmp    803f4b <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803f32:	be 00 00 40 00       	mov    $0x400000,%esi
  803f37:	bf 00 00 00 00       	mov    $0x0,%edi
  803f3c:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  803f43:	00 00 00 
  803f46:	ff d0                	callq  *%rax
	return r;
  803f48:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f4b:	c9                   	leaveq 
  803f4c:	c3                   	retq   

0000000000803f4d <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803f4d:	55                   	push   %rbp
  803f4e:	48 89 e5             	mov    %rsp,%rbp
  803f51:	48 83 ec 50          	sub    $0x50,%rsp
  803f55:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803f58:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f5c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803f60:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803f63:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803f67:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803f6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f6f:	25 ff 0f 00 00       	and    $0xfff,%eax
  803f74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f7b:	74 21                	je     803f9e <map_segment+0x51>
		va -= i;
  803f7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f80:	48 98                	cltq   
  803f82:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803f86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f89:	48 98                	cltq   
  803f8b:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803f8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f92:	48 98                	cltq   
  803f94:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803f98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f9b:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803f9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fa5:	e9 79 01 00 00       	jmpq   804123 <map_segment+0x1d6>
		if (i >= filesz) {
  803faa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fad:	48 98                	cltq   
  803faf:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803fb3:	72 3c                	jb     803ff1 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803fb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb8:	48 63 d0             	movslq %eax,%rdx
  803fbb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fbf:	48 01 d0             	add    %rdx,%rax
  803fc2:	48 89 c1             	mov    %rax,%rcx
  803fc5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fc8:	8b 55 10             	mov    0x10(%rbp),%edx
  803fcb:	48 89 ce             	mov    %rcx,%rsi
  803fce:	89 c7                	mov    %eax,%edi
  803fd0:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  803fd7:	00 00 00 
  803fda:	ff d0                	callq  *%rax
  803fdc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803fdf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803fe3:	0f 89 33 01 00 00    	jns    80411c <map_segment+0x1cf>
				return r;
  803fe9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fec:	e9 46 01 00 00       	jmpq   804137 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803ff1:	ba 07 00 00 00       	mov    $0x7,%edx
  803ff6:	be 00 00 40 00       	mov    $0x400000,%esi
  803ffb:	bf 00 00 00 00       	mov    $0x0,%edi
  804000:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  804007:	00 00 00 
  80400a:	ff d0                	callq  *%rax
  80400c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80400f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804013:	79 08                	jns    80401d <map_segment+0xd0>
				return r;
  804015:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804018:	e9 1a 01 00 00       	jmpq   804137 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80401d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804020:	8b 55 bc             	mov    -0x44(%rbp),%edx
  804023:	01 c2                	add    %eax,%edx
  804025:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804028:	89 d6                	mov    %edx,%esi
  80402a:	89 c7                	mov    %eax,%edi
  80402c:	48 b8 bb 2e 80 00 00 	movabs $0x802ebb,%rax
  804033:	00 00 00 
  804036:	ff d0                	callq  *%rax
  804038:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80403b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80403f:	79 08                	jns    804049 <map_segment+0xfc>
				return r;
  804041:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804044:	e9 ee 00 00 00       	jmpq   804137 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  804049:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  804050:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804053:	48 98                	cltq   
  804055:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804059:	48 29 c2             	sub    %rax,%rdx
  80405c:	48 89 d0             	mov    %rdx,%rax
  80405f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804063:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804066:	48 63 d0             	movslq %eax,%rdx
  804069:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80406d:	48 39 c2             	cmp    %rax,%rdx
  804070:	48 0f 47 d0          	cmova  %rax,%rdx
  804074:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804077:	be 00 00 40 00       	mov    $0x400000,%esi
  80407c:	89 c7                	mov    %eax,%edi
  80407e:	48 b8 72 2d 80 00 00 	movabs $0x802d72,%rax
  804085:	00 00 00 
  804088:	ff d0                	callq  *%rax
  80408a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80408d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804091:	79 08                	jns    80409b <map_segment+0x14e>
				return r;
  804093:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804096:	e9 9c 00 00 00       	jmpq   804137 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80409b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80409e:	48 63 d0             	movslq %eax,%rdx
  8040a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040a5:	48 01 d0             	add    %rdx,%rax
  8040a8:	48 89 c2             	mov    %rax,%rdx
  8040ab:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040ae:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8040b2:	48 89 d1             	mov    %rdx,%rcx
  8040b5:	89 c2                	mov    %eax,%edx
  8040b7:	be 00 00 40 00       	mov    $0x400000,%esi
  8040bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c1:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  8040c8:	00 00 00 
  8040cb:	ff d0                	callq  *%rax
  8040cd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8040d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8040d4:	79 30                	jns    804106 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8040d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040d9:	89 c1                	mov    %eax,%ecx
  8040db:	48 ba 13 58 80 00 00 	movabs $0x805813,%rdx
  8040e2:	00 00 00 
  8040e5:	be 24 01 00 00       	mov    $0x124,%esi
  8040ea:	48 bf 98 57 80 00 00 	movabs $0x805798,%rdi
  8040f1:	00 00 00 
  8040f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f9:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  804100:	00 00 00 
  804103:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  804106:	be 00 00 40 00       	mov    $0x400000,%esi
  80410b:	bf 00 00 00 00       	mov    $0x0,%edi
  804110:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  804117:	00 00 00 
  80411a:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80411c:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  804123:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804126:	48 98                	cltq   
  804128:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80412c:	0f 82 78 fe ff ff    	jb     803faa <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  804132:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804137:	c9                   	leaveq 
  804138:	c3                   	retq   

0000000000804139 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  804139:	55                   	push   %rbp
  80413a:	48 89 e5             	mov    %rsp,%rbp
  80413d:	48 83 ec 20          	sub    $0x20,%rsp
  804141:	89 7d ec             	mov    %edi,-0x14(%rbp)
	// LAB 5: Your code here.
	uint64_t  i;
	for (i=UTEXT;i<USTACKTOP;i+=PGSIZE)
  804144:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  80414b:	00 
  80414c:	e9 23 01 00 00       	jmpq   804274 <copy_shared_pages+0x13b>
	{
		if ((uvpml4e[VPML4E(i)]) && (uvpde[VPDPE(i)]) && (uvpd[VPD(i)]) && (uvpt[VPN(i)]))
  804151:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804155:	48 c1 e8 27          	shr    $0x27,%rax
  804159:	48 89 c2             	mov    %rax,%rdx
  80415c:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804163:	01 00 00 
  804166:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80416a:	48 85 c0             	test   %rax,%rax
  80416d:	0f 84 f9 00 00 00    	je     80426c <copy_shared_pages+0x133>
  804173:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804177:	48 c1 e8 1e          	shr    $0x1e,%rax
  80417b:	48 89 c2             	mov    %rax,%rdx
  80417e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804185:	01 00 00 
  804188:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80418c:	48 85 c0             	test   %rax,%rax
  80418f:	0f 84 d7 00 00 00    	je     80426c <copy_shared_pages+0x133>
  804195:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804199:	48 c1 e8 15          	shr    $0x15,%rax
  80419d:	48 89 c2             	mov    %rax,%rdx
  8041a0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8041a7:	01 00 00 
  8041aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041ae:	48 85 c0             	test   %rax,%rax
  8041b1:	0f 84 b5 00 00 00    	je     80426c <copy_shared_pages+0x133>
  8041b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041bb:	48 c1 e8 0c          	shr    $0xc,%rax
  8041bf:	48 89 c2             	mov    %rax,%rdx
  8041c2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8041c9:	01 00 00 
  8041cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041d0:	48 85 c0             	test   %rax,%rax
  8041d3:	0f 84 93 00 00 00    	je     80426c <copy_shared_pages+0x133>
		{
			if (uvpt[VPN(i)]&PTE_SHARE)
  8041d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041dd:	48 c1 e8 0c          	shr    $0xc,%rax
  8041e1:	48 89 c2             	mov    %rax,%rdx
  8041e4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8041eb:	01 00 00 
  8041ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041f2:	25 00 04 00 00       	and    $0x400,%eax
  8041f7:	48 85 c0             	test   %rax,%rax
  8041fa:	74 70                	je     80426c <copy_shared_pages+0x133>
				if (sys_page_map(0, (void *)i, child, (void *)i, uvpt[VPN(i)] & PTE_SYSCALL)<0)
  8041fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804200:	48 c1 e8 0c          	shr    $0xc,%rax
  804204:	48 89 c2             	mov    %rax,%rdx
  804207:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80420e:	01 00 00 
  804211:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804215:	25 07 0e 00 00       	and    $0xe07,%eax
  80421a:	89 c6                	mov    %eax,%esi
  80421c:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  804220:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804224:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804227:	41 89 f0             	mov    %esi,%r8d
  80422a:	48 89 c6             	mov    %rax,%rsi
  80422d:	bf 00 00 00 00       	mov    $0x0,%edi
  804232:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  804239:	00 00 00 
  80423c:	ff d0                	callq  *%rax
  80423e:	85 c0                	test   %eax,%eax
  804240:	79 2a                	jns    80426c <copy_shared_pages+0x133>
					panic("copy_shared_pages: sys_page_map\n");
  804242:	48 ba 30 58 80 00 00 	movabs $0x805830,%rdx
  804249:	00 00 00 
  80424c:	be 37 01 00 00       	mov    $0x137,%esi
  804251:	48 bf 98 57 80 00 00 	movabs $0x805798,%rdi
  804258:	00 00 00 
  80425b:	b8 00 00 00 00       	mov    $0x0,%eax
  804260:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  804267:	00 00 00 
  80426a:	ff d1                	callq  *%rcx
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint64_t  i;
	for (i=UTEXT;i<USTACKTOP;i+=PGSIZE)
  80426c:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  804273:	00 
  804274:	b8 ff df 7f ef       	mov    $0xef7fdfff,%eax
  804279:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80427d:	0f 86 ce fe ff ff    	jbe    804151 <copy_shared_pages+0x18>
			if (uvpt[VPN(i)]&PTE_SHARE)
				if (sys_page_map(0, (void *)i, child, (void *)i, uvpt[VPN(i)] & PTE_SYSCALL)<0)
					panic("copy_shared_pages: sys_page_map\n");
		}
	}
	return 0;
  804283:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804288:	c9                   	leaveq 
  804289:	c3                   	retq   

000000000080428a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80428a:	55                   	push   %rbp
  80428b:	48 89 e5             	mov    %rsp,%rbp
  80428e:	53                   	push   %rbx
  80428f:	48 83 ec 38          	sub    $0x38,%rsp
  804293:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804297:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80429b:	48 89 c7             	mov    %rax,%rdi
  80429e:	48 b8 d3 27 80 00 00 	movabs $0x8027d3,%rax
  8042a5:	00 00 00 
  8042a8:	ff d0                	callq  *%rax
  8042aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042b1:	0f 88 bf 01 00 00    	js     804476 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8042b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042bb:	ba 07 04 00 00       	mov    $0x407,%edx
  8042c0:	48 89 c6             	mov    %rax,%rsi
  8042c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8042c8:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  8042cf:	00 00 00 
  8042d2:	ff d0                	callq  *%rax
  8042d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042db:	0f 88 95 01 00 00    	js     804476 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8042e1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8042e5:	48 89 c7             	mov    %rax,%rdi
  8042e8:	48 b8 d3 27 80 00 00 	movabs $0x8027d3,%rax
  8042ef:	00 00 00 
  8042f2:	ff d0                	callq  *%rax
  8042f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042fb:	0f 88 5d 01 00 00    	js     80445e <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804301:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804305:	ba 07 04 00 00       	mov    $0x407,%edx
  80430a:	48 89 c6             	mov    %rax,%rsi
  80430d:	bf 00 00 00 00       	mov    $0x0,%edi
  804312:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  804319:	00 00 00 
  80431c:	ff d0                	callq  *%rax
  80431e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804321:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804325:	0f 88 33 01 00 00    	js     80445e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80432b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80432f:	48 89 c7             	mov    %rax,%rdi
  804332:	48 b8 a8 27 80 00 00 	movabs $0x8027a8,%rax
  804339:	00 00 00 
  80433c:	ff d0                	callq  *%rax
  80433e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804342:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804346:	ba 07 04 00 00       	mov    $0x407,%edx
  80434b:	48 89 c6             	mov    %rax,%rsi
  80434e:	bf 00 00 00 00       	mov    $0x0,%edi
  804353:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  80435a:	00 00 00 
  80435d:	ff d0                	callq  *%rax
  80435f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804362:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804366:	79 05                	jns    80436d <pipe+0xe3>
		goto err2;
  804368:	e9 d9 00 00 00       	jmpq   804446 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80436d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804371:	48 89 c7             	mov    %rax,%rdi
  804374:	48 b8 a8 27 80 00 00 	movabs $0x8027a8,%rax
  80437b:	00 00 00 
  80437e:	ff d0                	callq  *%rax
  804380:	48 89 c2             	mov    %rax,%rdx
  804383:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804387:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80438d:	48 89 d1             	mov    %rdx,%rcx
  804390:	ba 00 00 00 00       	mov    $0x0,%edx
  804395:	48 89 c6             	mov    %rax,%rsi
  804398:	bf 00 00 00 00       	mov    $0x0,%edi
  80439d:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  8043a4:	00 00 00 
  8043a7:	ff d0                	callq  *%rax
  8043a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043b0:	79 1b                	jns    8043cd <pipe+0x143>
		goto err3;
  8043b2:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8043b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043b7:	48 89 c6             	mov    %rax,%rsi
  8043ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8043bf:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  8043c6:	00 00 00 
  8043c9:	ff d0                	callq  *%rax
  8043cb:	eb 79                	jmp    804446 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8043cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043d1:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8043d8:	00 00 00 
  8043db:	8b 12                	mov    (%rdx),%edx
  8043dd:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8043df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8043ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043ee:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8043f5:	00 00 00 
  8043f8:	8b 12                	mov    (%rdx),%edx
  8043fa:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8043fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804400:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804407:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80440b:	48 89 c7             	mov    %rax,%rdi
  80440e:	48 b8 85 27 80 00 00 	movabs $0x802785,%rax
  804415:	00 00 00 
  804418:	ff d0                	callq  *%rax
  80441a:	89 c2                	mov    %eax,%edx
  80441c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804420:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804422:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804426:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80442a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80442e:	48 89 c7             	mov    %rax,%rdi
  804431:	48 b8 85 27 80 00 00 	movabs $0x802785,%rax
  804438:	00 00 00 
  80443b:	ff d0                	callq  *%rax
  80443d:	89 03                	mov    %eax,(%rbx)
	return 0;
  80443f:	b8 00 00 00 00       	mov    $0x0,%eax
  804444:	eb 33                	jmp    804479 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804446:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80444a:	48 89 c6             	mov    %rax,%rsi
  80444d:	bf 00 00 00 00       	mov    $0x0,%edi
  804452:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  804459:	00 00 00 
  80445c:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80445e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804462:	48 89 c6             	mov    %rax,%rsi
  804465:	bf 00 00 00 00       	mov    $0x0,%edi
  80446a:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  804471:	00 00 00 
  804474:	ff d0                	callq  *%rax
err:
	return r;
  804476:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804479:	48 83 c4 38          	add    $0x38,%rsp
  80447d:	5b                   	pop    %rbx
  80447e:	5d                   	pop    %rbp
  80447f:	c3                   	retq   

0000000000804480 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804480:	55                   	push   %rbp
  804481:	48 89 e5             	mov    %rsp,%rbp
  804484:	53                   	push   %rbx
  804485:	48 83 ec 28          	sub    $0x28,%rsp
  804489:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80448d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804491:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804498:	00 00 00 
  80449b:	48 8b 00             	mov    (%rax),%rax
  80449e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8044a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8044a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044ab:	48 89 c7             	mov    %rax,%rdi
  8044ae:	48 b8 da 4e 80 00 00 	movabs $0x804eda,%rax
  8044b5:	00 00 00 
  8044b8:	ff d0                	callq  *%rax
  8044ba:	89 c3                	mov    %eax,%ebx
  8044bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044c0:	48 89 c7             	mov    %rax,%rdi
  8044c3:	48 b8 da 4e 80 00 00 	movabs $0x804eda,%rax
  8044ca:	00 00 00 
  8044cd:	ff d0                	callq  *%rax
  8044cf:	39 c3                	cmp    %eax,%ebx
  8044d1:	0f 94 c0             	sete   %al
  8044d4:	0f b6 c0             	movzbl %al,%eax
  8044d7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8044da:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8044e1:	00 00 00 
  8044e4:	48 8b 00             	mov    (%rax),%rax
  8044e7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8044ed:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8044f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044f3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8044f6:	75 05                	jne    8044fd <_pipeisclosed+0x7d>
			return ret;
  8044f8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8044fb:	eb 4f                	jmp    80454c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8044fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804500:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804503:	74 42                	je     804547 <_pipeisclosed+0xc7>
  804505:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804509:	75 3c                	jne    804547 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80450b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804512:	00 00 00 
  804515:	48 8b 00             	mov    (%rax),%rax
  804518:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80451e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804521:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804524:	89 c6                	mov    %eax,%esi
  804526:	48 bf 5b 58 80 00 00 	movabs $0x80585b,%rdi
  80452d:	00 00 00 
  804530:	b8 00 00 00 00       	mov    $0x0,%eax
  804535:	49 b8 87 05 80 00 00 	movabs $0x800587,%r8
  80453c:	00 00 00 
  80453f:	41 ff d0             	callq  *%r8
	}
  804542:	e9 4a ff ff ff       	jmpq   804491 <_pipeisclosed+0x11>
  804547:	e9 45 ff ff ff       	jmpq   804491 <_pipeisclosed+0x11>
}
  80454c:	48 83 c4 28          	add    $0x28,%rsp
  804550:	5b                   	pop    %rbx
  804551:	5d                   	pop    %rbp
  804552:	c3                   	retq   

0000000000804553 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804553:	55                   	push   %rbp
  804554:	48 89 e5             	mov    %rsp,%rbp
  804557:	48 83 ec 30          	sub    $0x30,%rsp
  80455b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80455e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804562:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804565:	48 89 d6             	mov    %rdx,%rsi
  804568:	89 c7                	mov    %eax,%edi
  80456a:	48 b8 6b 28 80 00 00 	movabs $0x80286b,%rax
  804571:	00 00 00 
  804574:	ff d0                	callq  *%rax
  804576:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804579:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80457d:	79 05                	jns    804584 <pipeisclosed+0x31>
		return r;
  80457f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804582:	eb 31                	jmp    8045b5 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804584:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804588:	48 89 c7             	mov    %rax,%rdi
  80458b:	48 b8 a8 27 80 00 00 	movabs $0x8027a8,%rax
  804592:	00 00 00 
  804595:	ff d0                	callq  *%rax
  804597:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80459b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80459f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045a3:	48 89 d6             	mov    %rdx,%rsi
  8045a6:	48 89 c7             	mov    %rax,%rdi
  8045a9:	48 b8 80 44 80 00 00 	movabs $0x804480,%rax
  8045b0:	00 00 00 
  8045b3:	ff d0                	callq  *%rax
}
  8045b5:	c9                   	leaveq 
  8045b6:	c3                   	retq   

00000000008045b7 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8045b7:	55                   	push   %rbp
  8045b8:	48 89 e5             	mov    %rsp,%rbp
  8045bb:	48 83 ec 40          	sub    $0x40,%rsp
  8045bf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8045c3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8045c7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8045cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045cf:	48 89 c7             	mov    %rax,%rdi
  8045d2:	48 b8 a8 27 80 00 00 	movabs $0x8027a8,%rax
  8045d9:	00 00 00 
  8045dc:	ff d0                	callq  *%rax
  8045de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8045e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045e6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8045ea:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8045f1:	00 
  8045f2:	e9 92 00 00 00       	jmpq   804689 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8045f7:	eb 41                	jmp    80463a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8045f9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8045fe:	74 09                	je     804609 <devpipe_read+0x52>
				return i;
  804600:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804604:	e9 92 00 00 00       	jmpq   80469b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804609:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80460d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804611:	48 89 d6             	mov    %rdx,%rsi
  804614:	48 89 c7             	mov    %rax,%rdi
  804617:	48 b8 80 44 80 00 00 	movabs $0x804480,%rax
  80461e:	00 00 00 
  804621:	ff d0                	callq  *%rax
  804623:	85 c0                	test   %eax,%eax
  804625:	74 07                	je     80462e <devpipe_read+0x77>
				return 0;
  804627:	b8 00 00 00 00       	mov    $0x0,%eax
  80462c:	eb 6d                	jmp    80469b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80462e:	48 b8 6e 1a 80 00 00 	movabs $0x801a6e,%rax
  804635:	00 00 00 
  804638:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80463a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80463e:	8b 10                	mov    (%rax),%edx
  804640:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804644:	8b 40 04             	mov    0x4(%rax),%eax
  804647:	39 c2                	cmp    %eax,%edx
  804649:	74 ae                	je     8045f9 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80464b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80464f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804653:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804657:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80465b:	8b 00                	mov    (%rax),%eax
  80465d:	99                   	cltd   
  80465e:	c1 ea 1b             	shr    $0x1b,%edx
  804661:	01 d0                	add    %edx,%eax
  804663:	83 e0 1f             	and    $0x1f,%eax
  804666:	29 d0                	sub    %edx,%eax
  804668:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80466c:	48 98                	cltq   
  80466e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804673:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804679:	8b 00                	mov    (%rax),%eax
  80467b:	8d 50 01             	lea    0x1(%rax),%edx
  80467e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804682:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804684:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80468d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804691:	0f 82 60 ff ff ff    	jb     8045f7 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804697:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80469b:	c9                   	leaveq 
  80469c:	c3                   	retq   

000000000080469d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80469d:	55                   	push   %rbp
  80469e:	48 89 e5             	mov    %rsp,%rbp
  8046a1:	48 83 ec 40          	sub    $0x40,%rsp
  8046a5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8046a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8046ad:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8046b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046b5:	48 89 c7             	mov    %rax,%rdi
  8046b8:	48 b8 a8 27 80 00 00 	movabs $0x8027a8,%rax
  8046bf:	00 00 00 
  8046c2:	ff d0                	callq  *%rax
  8046c4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8046c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046cc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8046d0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8046d7:	00 
  8046d8:	e9 8e 00 00 00       	jmpq   80476b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8046dd:	eb 31                	jmp    804710 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8046df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046e7:	48 89 d6             	mov    %rdx,%rsi
  8046ea:	48 89 c7             	mov    %rax,%rdi
  8046ed:	48 b8 80 44 80 00 00 	movabs $0x804480,%rax
  8046f4:	00 00 00 
  8046f7:	ff d0                	callq  *%rax
  8046f9:	85 c0                	test   %eax,%eax
  8046fb:	74 07                	je     804704 <devpipe_write+0x67>
				return 0;
  8046fd:	b8 00 00 00 00       	mov    $0x0,%eax
  804702:	eb 79                	jmp    80477d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804704:	48 b8 6e 1a 80 00 00 	movabs $0x801a6e,%rax
  80470b:	00 00 00 
  80470e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804714:	8b 40 04             	mov    0x4(%rax),%eax
  804717:	48 63 d0             	movslq %eax,%rdx
  80471a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80471e:	8b 00                	mov    (%rax),%eax
  804720:	48 98                	cltq   
  804722:	48 83 c0 20          	add    $0x20,%rax
  804726:	48 39 c2             	cmp    %rax,%rdx
  804729:	73 b4                	jae    8046df <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80472b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80472f:	8b 40 04             	mov    0x4(%rax),%eax
  804732:	99                   	cltd   
  804733:	c1 ea 1b             	shr    $0x1b,%edx
  804736:	01 d0                	add    %edx,%eax
  804738:	83 e0 1f             	and    $0x1f,%eax
  80473b:	29 d0                	sub    %edx,%eax
  80473d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804741:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804745:	48 01 ca             	add    %rcx,%rdx
  804748:	0f b6 0a             	movzbl (%rdx),%ecx
  80474b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80474f:	48 98                	cltq   
  804751:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804755:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804759:	8b 40 04             	mov    0x4(%rax),%eax
  80475c:	8d 50 01             	lea    0x1(%rax),%edx
  80475f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804763:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804766:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80476b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80476f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804773:	0f 82 64 ff ff ff    	jb     8046dd <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804779:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80477d:	c9                   	leaveq 
  80477e:	c3                   	retq   

000000000080477f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80477f:	55                   	push   %rbp
  804780:	48 89 e5             	mov    %rsp,%rbp
  804783:	48 83 ec 20          	sub    $0x20,%rsp
  804787:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80478b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80478f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804793:	48 89 c7             	mov    %rax,%rdi
  804796:	48 b8 a8 27 80 00 00 	movabs $0x8027a8,%rax
  80479d:	00 00 00 
  8047a0:	ff d0                	callq  *%rax
  8047a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8047a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047aa:	48 be 6e 58 80 00 00 	movabs $0x80586e,%rsi
  8047b1:	00 00 00 
  8047b4:	48 89 c7             	mov    %rax,%rdi
  8047b7:	48 b8 7d 11 80 00 00 	movabs $0x80117d,%rax
  8047be:	00 00 00 
  8047c1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8047c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047c7:	8b 50 04             	mov    0x4(%rax),%edx
  8047ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047ce:	8b 00                	mov    (%rax),%eax
  8047d0:	29 c2                	sub    %eax,%edx
  8047d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047d6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8047dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047e0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8047e7:	00 00 00 
	stat->st_dev = &devpipe;
  8047ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047ee:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8047f5:	00 00 00 
  8047f8:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8047ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804804:	c9                   	leaveq 
  804805:	c3                   	retq   

0000000000804806 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804806:	55                   	push   %rbp
  804807:	48 89 e5             	mov    %rsp,%rbp
  80480a:	48 83 ec 10          	sub    $0x10,%rsp
  80480e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804812:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804816:	48 89 c6             	mov    %rax,%rsi
  804819:	bf 00 00 00 00       	mov    $0x0,%edi
  80481e:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  804825:	00 00 00 
  804828:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80482a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80482e:	48 89 c7             	mov    %rax,%rdi
  804831:	48 b8 a8 27 80 00 00 	movabs $0x8027a8,%rax
  804838:	00 00 00 
  80483b:	ff d0                	callq  *%rax
  80483d:	48 89 c6             	mov    %rax,%rsi
  804840:	bf 00 00 00 00       	mov    $0x0,%edi
  804845:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  80484c:	00 00 00 
  80484f:	ff d0                	callq  *%rax
}
  804851:	c9                   	leaveq 
  804852:	c3                   	retq   

0000000000804853 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804853:	55                   	push   %rbp
  804854:	48 89 e5             	mov    %rsp,%rbp
  804857:	48 83 ec 20          	sub    $0x20,%rsp
  80485b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80485e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804862:	75 35                	jne    804899 <wait+0x46>
  804864:	48 b9 75 58 80 00 00 	movabs $0x805875,%rcx
  80486b:	00 00 00 
  80486e:	48 ba 80 58 80 00 00 	movabs $0x805880,%rdx
  804875:	00 00 00 
  804878:	be 09 00 00 00       	mov    $0x9,%esi
  80487d:	48 bf 95 58 80 00 00 	movabs $0x805895,%rdi
  804884:	00 00 00 
  804887:	b8 00 00 00 00       	mov    $0x0,%eax
  80488c:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  804893:	00 00 00 
  804896:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804899:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80489c:	25 ff 03 00 00       	and    $0x3ff,%eax
  8048a1:	48 98                	cltq   
  8048a3:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8048aa:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8048b1:	00 00 00 
  8048b4:	48 01 d0             	add    %rdx,%rax
  8048b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8048bb:	eb 0c                	jmp    8048c9 <wait+0x76>
		sys_yield();
  8048bd:	48 b8 6e 1a 80 00 00 	movabs $0x801a6e,%rax
  8048c4:	00 00 00 
  8048c7:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8048c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8048d3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8048d6:	75 0e                	jne    8048e6 <wait+0x93>
  8048d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048dc:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8048e2:	85 c0                	test   %eax,%eax
  8048e4:	75 d7                	jne    8048bd <wait+0x6a>
		sys_yield();
}
  8048e6:	c9                   	leaveq 
  8048e7:	c3                   	retq   

00000000008048e8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8048e8:	55                   	push   %rbp
  8048e9:	48 89 e5             	mov    %rsp,%rbp
  8048ec:	48 83 ec 20          	sub    $0x20,%rsp
  8048f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8048f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048f6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8048f9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8048fd:	be 01 00 00 00       	mov    $0x1,%esi
  804902:	48 89 c7             	mov    %rax,%rdi
  804905:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  80490c:	00 00 00 
  80490f:	ff d0                	callq  *%rax
}
  804911:	c9                   	leaveq 
  804912:	c3                   	retq   

0000000000804913 <getchar>:

int
getchar(void)
{
  804913:	55                   	push   %rbp
  804914:	48 89 e5             	mov    %rsp,%rbp
  804917:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80491b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80491f:	ba 01 00 00 00       	mov    $0x1,%edx
  804924:	48 89 c6             	mov    %rax,%rsi
  804927:	bf 00 00 00 00       	mov    $0x0,%edi
  80492c:	48 b8 9d 2c 80 00 00 	movabs $0x802c9d,%rax
  804933:	00 00 00 
  804936:	ff d0                	callq  *%rax
  804938:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80493b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80493f:	79 05                	jns    804946 <getchar+0x33>
		return r;
  804941:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804944:	eb 14                	jmp    80495a <getchar+0x47>
	if (r < 1)
  804946:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80494a:	7f 07                	jg     804953 <getchar+0x40>
		return -E_EOF;
  80494c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804951:	eb 07                	jmp    80495a <getchar+0x47>
	return c;
  804953:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804957:	0f b6 c0             	movzbl %al,%eax
}
  80495a:	c9                   	leaveq 
  80495b:	c3                   	retq   

000000000080495c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80495c:	55                   	push   %rbp
  80495d:	48 89 e5             	mov    %rsp,%rbp
  804960:	48 83 ec 20          	sub    $0x20,%rsp
  804964:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804967:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80496b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80496e:	48 89 d6             	mov    %rdx,%rsi
  804971:	89 c7                	mov    %eax,%edi
  804973:	48 b8 6b 28 80 00 00 	movabs $0x80286b,%rax
  80497a:	00 00 00 
  80497d:	ff d0                	callq  *%rax
  80497f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804982:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804986:	79 05                	jns    80498d <iscons+0x31>
		return r;
  804988:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80498b:	eb 1a                	jmp    8049a7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80498d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804991:	8b 10                	mov    (%rax),%edx
  804993:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  80499a:	00 00 00 
  80499d:	8b 00                	mov    (%rax),%eax
  80499f:	39 c2                	cmp    %eax,%edx
  8049a1:	0f 94 c0             	sete   %al
  8049a4:	0f b6 c0             	movzbl %al,%eax
}
  8049a7:	c9                   	leaveq 
  8049a8:	c3                   	retq   

00000000008049a9 <opencons>:

int
opencons(void)
{
  8049a9:	55                   	push   %rbp
  8049aa:	48 89 e5             	mov    %rsp,%rbp
  8049ad:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8049b1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8049b5:	48 89 c7             	mov    %rax,%rdi
  8049b8:	48 b8 d3 27 80 00 00 	movabs $0x8027d3,%rax
  8049bf:	00 00 00 
  8049c2:	ff d0                	callq  *%rax
  8049c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049cb:	79 05                	jns    8049d2 <opencons+0x29>
		return r;
  8049cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049d0:	eb 5b                	jmp    804a2d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8049d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049d6:	ba 07 04 00 00       	mov    $0x407,%edx
  8049db:	48 89 c6             	mov    %rax,%rsi
  8049de:	bf 00 00 00 00       	mov    $0x0,%edi
  8049e3:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  8049ea:	00 00 00 
  8049ed:	ff d0                	callq  *%rax
  8049ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049f6:	79 05                	jns    8049fd <opencons+0x54>
		return r;
  8049f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049fb:	eb 30                	jmp    804a2d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8049fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a01:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804a08:	00 00 00 
  804a0b:	8b 12                	mov    (%rdx),%edx
  804a0d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804a0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a13:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804a1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a1e:	48 89 c7             	mov    %rax,%rdi
  804a21:	48 b8 85 27 80 00 00 	movabs $0x802785,%rax
  804a28:	00 00 00 
  804a2b:	ff d0                	callq  *%rax
}
  804a2d:	c9                   	leaveq 
  804a2e:	c3                   	retq   

0000000000804a2f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804a2f:	55                   	push   %rbp
  804a30:	48 89 e5             	mov    %rsp,%rbp
  804a33:	48 83 ec 30          	sub    $0x30,%rsp
  804a37:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804a3b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804a3f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804a43:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804a48:	75 07                	jne    804a51 <devcons_read+0x22>
		return 0;
  804a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  804a4f:	eb 4b                	jmp    804a9c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804a51:	eb 0c                	jmp    804a5f <devcons_read+0x30>
		sys_yield();
  804a53:	48 b8 6e 1a 80 00 00 	movabs $0x801a6e,%rax
  804a5a:	00 00 00 
  804a5d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804a5f:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  804a66:	00 00 00 
  804a69:	ff d0                	callq  *%rax
  804a6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a72:	74 df                	je     804a53 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804a74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a78:	79 05                	jns    804a7f <devcons_read+0x50>
		return c;
  804a7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a7d:	eb 1d                	jmp    804a9c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804a7f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804a83:	75 07                	jne    804a8c <devcons_read+0x5d>
		return 0;
  804a85:	b8 00 00 00 00       	mov    $0x0,%eax
  804a8a:	eb 10                	jmp    804a9c <devcons_read+0x6d>
	*(char*)vbuf = c;
  804a8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a8f:	89 c2                	mov    %eax,%edx
  804a91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a95:	88 10                	mov    %dl,(%rax)
	return 1;
  804a97:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804a9c:	c9                   	leaveq 
  804a9d:	c3                   	retq   

0000000000804a9e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804a9e:	55                   	push   %rbp
  804a9f:	48 89 e5             	mov    %rsp,%rbp
  804aa2:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804aa9:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804ab0:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804ab7:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804abe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804ac5:	eb 76                	jmp    804b3d <devcons_write+0x9f>
		m = n - tot;
  804ac7:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804ace:	89 c2                	mov    %eax,%edx
  804ad0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ad3:	29 c2                	sub    %eax,%edx
  804ad5:	89 d0                	mov    %edx,%eax
  804ad7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804ada:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804add:	83 f8 7f             	cmp    $0x7f,%eax
  804ae0:	76 07                	jbe    804ae9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804ae2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804ae9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804aec:	48 63 d0             	movslq %eax,%rdx
  804aef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804af2:	48 63 c8             	movslq %eax,%rcx
  804af5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804afc:	48 01 c1             	add    %rax,%rcx
  804aff:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804b06:	48 89 ce             	mov    %rcx,%rsi
  804b09:	48 89 c7             	mov    %rax,%rdi
  804b0c:	48 b8 a1 14 80 00 00 	movabs $0x8014a1,%rax
  804b13:	00 00 00 
  804b16:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804b18:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b1b:	48 63 d0             	movslq %eax,%rdx
  804b1e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804b25:	48 89 d6             	mov    %rdx,%rsi
  804b28:	48 89 c7             	mov    %rax,%rdi
  804b2b:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  804b32:	00 00 00 
  804b35:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804b37:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b3a:	01 45 fc             	add    %eax,-0x4(%rbp)
  804b3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b40:	48 98                	cltq   
  804b42:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804b49:	0f 82 78 ff ff ff    	jb     804ac7 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804b4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804b52:	c9                   	leaveq 
  804b53:	c3                   	retq   

0000000000804b54 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804b54:	55                   	push   %rbp
  804b55:	48 89 e5             	mov    %rsp,%rbp
  804b58:	48 83 ec 08          	sub    $0x8,%rsp
  804b5c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804b60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b65:	c9                   	leaveq 
  804b66:	c3                   	retq   

0000000000804b67 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804b67:	55                   	push   %rbp
  804b68:	48 89 e5             	mov    %rsp,%rbp
  804b6b:	48 83 ec 10          	sub    $0x10,%rsp
  804b6f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804b73:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804b77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b7b:	48 be a5 58 80 00 00 	movabs $0x8058a5,%rsi
  804b82:	00 00 00 
  804b85:	48 89 c7             	mov    %rax,%rdi
  804b88:	48 b8 7d 11 80 00 00 	movabs $0x80117d,%rax
  804b8f:	00 00 00 
  804b92:	ff d0                	callq  *%rax
	return 0;
  804b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b99:	c9                   	leaveq 
  804b9a:	c3                   	retq   

0000000000804b9b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804b9b:	55                   	push   %rbp
  804b9c:	48 89 e5             	mov    %rsp,%rbp
  804b9f:	48 83 ec 20          	sub    $0x20,%rsp
  804ba3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804ba7:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  804bae:	00 00 00 
  804bb1:	48 8b 00             	mov    (%rax),%rax
  804bb4:	48 85 c0             	test   %rax,%rax
  804bb7:	75 6f                	jne    804c28 <set_pgfault_handler+0x8d>
		// First time through!
		// LAB 4: Your code here.

		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  804bb9:	ba 07 00 00 00       	mov    $0x7,%edx
  804bbe:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804bc3:	bf 00 00 00 00       	mov    $0x0,%edi
  804bc8:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  804bcf:	00 00 00 
  804bd2:	ff d0                	callq  *%rax
  804bd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804bd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804bdb:	79 30                	jns    804c0d <set_pgfault_handler+0x72>
            panic("set_pgfault_handler: %d\n", r);
  804bdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804be0:	89 c1                	mov    %eax,%ecx
  804be2:	48 ba ac 58 80 00 00 	movabs $0x8058ac,%rdx
  804be9:	00 00 00 
  804bec:	be 22 00 00 00       	mov    $0x22,%esi
  804bf1:	48 bf c5 58 80 00 00 	movabs $0x8058c5,%rdi
  804bf8:	00 00 00 
  804bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  804c00:	49 b8 4e 03 80 00 00 	movabs $0x80034e,%r8
  804c07:	00 00 00 
  804c0a:	41 ff d0             	callq  *%r8
        sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804c0d:	48 be 3b 4c 80 00 00 	movabs $0x804c3b,%rsi
  804c14:	00 00 00 
  804c17:	bf 00 00 00 00       	mov    $0x0,%edi
  804c1c:	48 b8 36 1c 80 00 00 	movabs $0x801c36,%rax
  804c23:	00 00 00 
  804c26:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804c28:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  804c2f:	00 00 00 
  804c32:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804c36:	48 89 10             	mov    %rdx,(%rax)
}
  804c39:	c9                   	leaveq 
  804c3a:	c3                   	retq   

0000000000804c3b <_pgfault_upcall>:
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF


	movq %rsp, %rdi;	
  804c3b:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  804c3e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804c45:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  804c46:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  804c4d:	00 
	pushq %rbx;
  804c4e:	53                   	push   %rbx
	movq %rsp, %rbx;	
  804c4f:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  804c52:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  804c55:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  804c5c:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  804c5d:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  804c61:	4c 8b 3c 24          	mov    (%rsp),%r15
  804c65:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804c6a:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804c6f:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804c74:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804c79:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804c7e:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804c83:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804c88:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804c8d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804c92:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804c97:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804c9c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804ca1:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804ca6:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804cab:	48 83 c4 78          	add    $0x78,%rsp
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.


	add $8, %rsp; //Jump rip field  
  804caf:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804cb3:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  804cb4:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  804cb5:	c3                   	retq   

0000000000804cb6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804cb6:	55                   	push   %rbp
  804cb7:	48 89 e5             	mov    %rsp,%rbp
  804cba:	48 83 ec 30          	sub    $0x30,%rsp
  804cbe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804cc2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804cc6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  804cca:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804ccf:	75 08                	jne    804cd9 <ipc_recv+0x23>
  804cd1:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  804cd8:	ff 
	int res=sys_ipc_recv(pg);
  804cd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cdd:	48 89 c7             	mov    %rax,%rdi
  804ce0:	48 b8 20 1d 80 00 00 	movabs $0x801d20,%rax
  804ce7:	00 00 00 
  804cea:	ff d0                	callq  *%rax
  804cec:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  804cef:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804cf4:	74 26                	je     804d1c <ipc_recv+0x66>
  804cf6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804cfa:	75 15                	jne    804d11 <ipc_recv+0x5b>
  804cfc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804d03:	00 00 00 
  804d06:	48 8b 00             	mov    (%rax),%rax
  804d09:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  804d0f:	eb 05                	jmp    804d16 <ipc_recv+0x60>
  804d11:	b8 00 00 00 00       	mov    $0x0,%eax
  804d16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804d1a:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  804d1c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804d21:	74 26                	je     804d49 <ipc_recv+0x93>
  804d23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d27:	75 15                	jne    804d3e <ipc_recv+0x88>
  804d29:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804d30:	00 00 00 
  804d33:	48 8b 00             	mov    (%rax),%rax
  804d36:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  804d3c:	eb 05                	jmp    804d43 <ipc_recv+0x8d>
  804d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  804d43:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804d47:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  804d49:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d4d:	75 15                	jne    804d64 <ipc_recv+0xae>
  804d4f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804d56:	00 00 00 
  804d59:	48 8b 00             	mov    (%rax),%rax
  804d5c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  804d62:	eb 03                	jmp    804d67 <ipc_recv+0xb1>
  804d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  804d67:	c9                   	leaveq 
  804d68:	c3                   	retq   

0000000000804d69 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804d69:	55                   	push   %rbp
  804d6a:	48 89 e5             	mov    %rsp,%rbp
  804d6d:	48 83 ec 30          	sub    $0x30,%rsp
  804d71:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804d74:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804d77:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804d7b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  804d7e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804d83:	75 0a                	jne    804d8f <ipc_send+0x26>
  804d85:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  804d8c:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  804d8d:	eb 3e                	jmp    804dcd <ipc_send+0x64>
  804d8f:	eb 3c                	jmp    804dcd <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  804d91:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804d95:	74 2a                	je     804dc1 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  804d97:	48 ba d8 58 80 00 00 	movabs $0x8058d8,%rdx
  804d9e:	00 00 00 
  804da1:	be 39 00 00 00       	mov    $0x39,%esi
  804da6:	48 bf 03 59 80 00 00 	movabs $0x805903,%rdi
  804dad:	00 00 00 
  804db0:	b8 00 00 00 00       	mov    $0x0,%eax
  804db5:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  804dbc:	00 00 00 
  804dbf:	ff d1                	callq  *%rcx
		sys_yield();  
  804dc1:	48 b8 6e 1a 80 00 00 	movabs $0x801a6e,%rax
  804dc8:	00 00 00 
  804dcb:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  804dcd:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804dd0:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804dd3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804dd7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804dda:	89 c7                	mov    %eax,%edi
  804ddc:	48 b8 cb 1c 80 00 00 	movabs $0x801ccb,%rax
  804de3:	00 00 00 
  804de6:	ff d0                	callq  *%rax
  804de8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804deb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804def:	78 a0                	js     804d91 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  804df1:	c9                   	leaveq 
  804df2:	c3                   	retq   

0000000000804df3 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804df3:	55                   	push   %rbp
  804df4:	48 89 e5             	mov    %rsp,%rbp
  804df7:	48 83 ec 10          	sub    $0x10,%rsp
  804dfb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  804dff:	48 ba 10 59 80 00 00 	movabs $0x805910,%rdx
  804e06:	00 00 00 
  804e09:	be 47 00 00 00       	mov    $0x47,%esi
  804e0e:	48 bf 03 59 80 00 00 	movabs $0x805903,%rdi
  804e15:	00 00 00 
  804e18:	b8 00 00 00 00       	mov    $0x0,%eax
  804e1d:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  804e24:	00 00 00 
  804e27:	ff d1                	callq  *%rcx

0000000000804e29 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804e29:	55                   	push   %rbp
  804e2a:	48 89 e5             	mov    %rsp,%rbp
  804e2d:	48 83 ec 20          	sub    $0x20,%rsp
  804e31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804e34:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804e37:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  804e3b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  804e3e:	48 ba 38 59 80 00 00 	movabs $0x805938,%rdx
  804e45:	00 00 00 
  804e48:	be 50 00 00 00       	mov    $0x50,%esi
  804e4d:	48 bf 03 59 80 00 00 	movabs $0x805903,%rdi
  804e54:	00 00 00 
  804e57:	b8 00 00 00 00       	mov    $0x0,%eax
  804e5c:	48 b9 4e 03 80 00 00 	movabs $0x80034e,%rcx
  804e63:	00 00 00 
  804e66:	ff d1                	callq  *%rcx

0000000000804e68 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804e68:	55                   	push   %rbp
  804e69:	48 89 e5             	mov    %rsp,%rbp
  804e6c:	48 83 ec 14          	sub    $0x14,%rsp
  804e70:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804e73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804e7a:	eb 4e                	jmp    804eca <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804e7c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804e83:	00 00 00 
  804e86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e89:	48 98                	cltq   
  804e8b:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  804e92:	48 01 d0             	add    %rdx,%rax
  804e95:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804e9b:	8b 00                	mov    (%rax),%eax
  804e9d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804ea0:	75 24                	jne    804ec6 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804ea2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804ea9:	00 00 00 
  804eac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804eaf:	48 98                	cltq   
  804eb1:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  804eb8:	48 01 d0             	add    %rdx,%rax
  804ebb:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804ec1:	8b 40 08             	mov    0x8(%rax),%eax
  804ec4:	eb 12                	jmp    804ed8 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804ec6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804eca:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804ed1:	7e a9                	jle    804e7c <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  804ed3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ed8:	c9                   	leaveq 
  804ed9:	c3                   	retq   

0000000000804eda <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804eda:	55                   	push   %rbp
  804edb:	48 89 e5             	mov    %rsp,%rbp
  804ede:	48 83 ec 18          	sub    $0x18,%rsp
  804ee2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804ee6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804eea:	48 c1 e8 15          	shr    $0x15,%rax
  804eee:	48 89 c2             	mov    %rax,%rdx
  804ef1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804ef8:	01 00 00 
  804efb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804eff:	83 e0 01             	and    $0x1,%eax
  804f02:	48 85 c0             	test   %rax,%rax
  804f05:	75 07                	jne    804f0e <pageref+0x34>
		return 0;
  804f07:	b8 00 00 00 00       	mov    $0x0,%eax
  804f0c:	eb 53                	jmp    804f61 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804f0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804f12:	48 c1 e8 0c          	shr    $0xc,%rax
  804f16:	48 89 c2             	mov    %rax,%rdx
  804f19:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804f20:	01 00 00 
  804f23:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804f27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804f2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f2f:	83 e0 01             	and    $0x1,%eax
  804f32:	48 85 c0             	test   %rax,%rax
  804f35:	75 07                	jne    804f3e <pageref+0x64>
		return 0;
  804f37:	b8 00 00 00 00       	mov    $0x0,%eax
  804f3c:	eb 23                	jmp    804f61 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804f3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f42:	48 c1 e8 0c          	shr    $0xc,%rax
  804f46:	48 89 c2             	mov    %rax,%rdx
  804f49:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804f50:	00 00 00 
  804f53:	48 c1 e2 04          	shl    $0x4,%rdx
  804f57:	48 01 d0             	add    %rdx,%rax
  804f5a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804f5e:	0f b7 c0             	movzwl %ax,%eax
}
  804f61:	c9                   	leaveq 
  804f62:	c3                   	retq   
