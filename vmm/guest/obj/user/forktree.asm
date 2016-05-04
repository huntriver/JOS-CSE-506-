
vmm/guest/obj/user/forktree:     file format elf64-x86-64


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
  80003c:	e8 24 01 00 00       	callq  800165 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 f0                	mov    %esi,%eax
  800051:	88 45 e4             	mov    %al,-0x1c(%rbp)
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800058:	48 89 c7             	mov    %rax,%rdi
  80005b:	48 b8 ba 0e 80 00 00 	movabs $0x800eba,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
  800067:	83 f8 02             	cmp    $0x2,%eax
  80006a:	7f 65                	jg     8000d1 <forkchild+0x8e>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80006c:	0f be 4d e4          	movsbl -0x1c(%rbp),%ecx
  800070:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800074:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800078:	41 89 c8             	mov    %ecx,%r8d
  80007b:	48 89 d1             	mov    %rdx,%rcx
  80007e:	48 ba 00 42 80 00 00 	movabs $0x804200,%rdx
  800085:	00 00 00 
  800088:	be 04 00 00 00       	mov    $0x4,%esi
  80008d:	48 89 c7             	mov    %rax,%rdi
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	49 b9 d9 0d 80 00 00 	movabs $0x800dd9,%r9
  80009c:	00 00 00 
  80009f:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a2:	48 b8 22 21 80 00 00 	movabs $0x802122,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 1f                	jne    8000d1 <forkchild+0x8e>
		forktree(nxt);
  8000b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000b6:	48 89 c7             	mov    %rax,%rdi
  8000b9:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
		exit();
  8000c5:	48 b8 e8 01 80 00 00 	movabs $0x8001e8,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	callq  *%rax
	}
}
  8000d1:	c9                   	leaveq 
  8000d2:	c3                   	retq   

00000000008000d3 <forktree>:

void
forktree(const char *cur)
{
  8000d3:	55                   	push   %rbp
  8000d4:	48 89 e5             	mov    %rsp,%rbp
  8000d7:	48 83 ec 10          	sub    $0x10,%rsp
  8000db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  8000df:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  8000e6:	00 00 00 
  8000e9:	ff d0                	callq  *%rax
  8000eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ef:	89 c6                	mov    %eax,%esi
  8000f1:	48 bf 05 42 80 00 00 	movabs $0x804205,%rdi
  8000f8:	00 00 00 
  8000fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800100:	48 b9 30 03 80 00 00 	movabs $0x800330,%rcx
  800107:	00 00 00 
  80010a:	ff d1                	callq  *%rcx

	forkchild(cur, '0');
  80010c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800110:	be 30 00 00 00       	mov    $0x30,%esi
  800115:	48 89 c7             	mov    %rax,%rdi
  800118:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
	forkchild(cur, '1');
  800124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800128:	be 31 00 00 00       	mov    $0x31,%esi
  80012d:	48 89 c7             	mov    %rax,%rdi
  800130:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800137:	00 00 00 
  80013a:	ff d0                	callq  *%rax
}
  80013c:	c9                   	leaveq 
  80013d:	c3                   	retq   

000000000080013e <umain>:

void
umain(int argc, char **argv)
{
  80013e:	55                   	push   %rbp
  80013f:	48 89 e5             	mov    %rsp,%rbp
  800142:	48 83 ec 10          	sub    $0x10,%rsp
  800146:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800149:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	forktree("");
  80014d:	48 bf 16 42 80 00 00 	movabs $0x804216,%rdi
  800154:	00 00 00 
  800157:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
}
  800163:	c9                   	leaveq 
  800164:	c3                   	retq   

0000000000800165 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800165:	55                   	push   %rbp
  800166:	48 89 e5             	mov    %rsp,%rbp
  800169:	48 83 ec 10          	sub    $0x10,%rsp
  80016d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800170:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  800174:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	48 98                	cltq   
  800182:	25 ff 03 00 00       	and    $0x3ff,%eax
  800187:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  80018e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800195:	00 00 00 
  800198:	48 01 c2             	add    %rax,%rdx
  80019b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001a2:	00 00 00 
  8001a5:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001ac:	7e 14                	jle    8001c2 <libmain+0x5d>
		binaryname = argv[0];
  8001ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b2:	48 8b 10             	mov    (%rax),%rdx
  8001b5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001bc:	00 00 00 
  8001bf:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001c9:	48 89 d6             	mov    %rdx,%rsi
  8001cc:	89 c7                	mov    %eax,%edi
  8001ce:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8001d5:	00 00 00 
  8001d8:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001da:	48 b8 e8 01 80 00 00 	movabs $0x8001e8,%rax
  8001e1:	00 00 00 
  8001e4:	ff d0                	callq  *%rax
}
  8001e6:	c9                   	leaveq 
  8001e7:	c3                   	retq   

00000000008001e8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e8:	55                   	push   %rbp
  8001e9:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8001ec:	48 b8 6f 28 80 00 00 	movabs $0x80286f,%rax
  8001f3:	00 00 00 
  8001f6:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8001f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fd:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  800204:	00 00 00 
  800207:	ff d0                	callq  *%rax
}
  800209:	5d                   	pop    %rbp
  80020a:	c3                   	retq   

000000000080020b <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80020b:	55                   	push   %rbp
  80020c:	48 89 e5             	mov    %rsp,%rbp
  80020f:	48 83 ec 10          	sub    $0x10,%rsp
  800213:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800216:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80021a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80021e:	8b 00                	mov    (%rax),%eax
  800220:	8d 48 01             	lea    0x1(%rax),%ecx
  800223:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800227:	89 0a                	mov    %ecx,(%rdx)
  800229:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80022c:	89 d1                	mov    %edx,%ecx
  80022e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800232:	48 98                	cltq   
  800234:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800238:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80023c:	8b 00                	mov    (%rax),%eax
  80023e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800243:	75 2c                	jne    800271 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800245:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800249:	8b 00                	mov    (%rax),%eax
  80024b:	48 98                	cltq   
  80024d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800251:	48 83 c2 08          	add    $0x8,%rdx
  800255:	48 89 c6             	mov    %rax,%rsi
  800258:	48 89 d7             	mov    %rdx,%rdi
  80025b:	48 b8 0d 17 80 00 00 	movabs $0x80170d,%rax
  800262:	00 00 00 
  800265:	ff d0                	callq  *%rax
        b->idx = 0;
  800267:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80026b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800275:	8b 40 04             	mov    0x4(%rax),%eax
  800278:	8d 50 01             	lea    0x1(%rax),%edx
  80027b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80027f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800282:	c9                   	leaveq 
  800283:	c3                   	retq   

0000000000800284 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800284:	55                   	push   %rbp
  800285:	48 89 e5             	mov    %rsp,%rbp
  800288:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80028f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800296:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80029d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002a4:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002ab:	48 8b 0a             	mov    (%rdx),%rcx
  8002ae:	48 89 08             	mov    %rcx,(%rax)
  8002b1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002b5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002b9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002c8:	00 00 00 
    b.cnt = 0;
  8002cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002d2:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002d5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002dc:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002e3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002ea:	48 89 c6             	mov    %rax,%rsi
  8002ed:	48 bf 0b 02 80 00 00 	movabs $0x80020b,%rdi
  8002f4:	00 00 00 
  8002f7:	48 b8 e3 06 80 00 00 	movabs $0x8006e3,%rax
  8002fe:	00 00 00 
  800301:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800303:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800309:	48 98                	cltq   
  80030b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800312:	48 83 c2 08          	add    $0x8,%rdx
  800316:	48 89 c6             	mov    %rax,%rsi
  800319:	48 89 d7             	mov    %rdx,%rdi
  80031c:	48 b8 0d 17 80 00 00 	movabs $0x80170d,%rax
  800323:	00 00 00 
  800326:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800328:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80032e:	c9                   	leaveq 
  80032f:	c3                   	retq   

0000000000800330 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800330:	55                   	push   %rbp
  800331:	48 89 e5             	mov    %rsp,%rbp
  800334:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80033b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800342:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800349:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800350:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800357:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80035e:	84 c0                	test   %al,%al
  800360:	74 20                	je     800382 <cprintf+0x52>
  800362:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800366:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80036a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80036e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800372:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800376:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80037a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80037e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800382:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800389:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800390:	00 00 00 
  800393:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80039a:	00 00 00 
  80039d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003a1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003a8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003af:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003b6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003bd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003c4:	48 8b 0a             	mov    (%rdx),%rcx
  8003c7:	48 89 08             	mov    %rcx,(%rax)
  8003ca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003ce:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003d2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003d6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003da:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003e1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003e8:	48 89 d6             	mov    %rdx,%rsi
  8003eb:	48 89 c7             	mov    %rax,%rdi
  8003ee:	48 b8 84 02 80 00 00 	movabs $0x800284,%rax
  8003f5:	00 00 00 
  8003f8:	ff d0                	callq  *%rax
  8003fa:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800400:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800406:	c9                   	leaveq 
  800407:	c3                   	retq   

0000000000800408 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800408:	55                   	push   %rbp
  800409:	48 89 e5             	mov    %rsp,%rbp
  80040c:	53                   	push   %rbx
  80040d:	48 83 ec 38          	sub    $0x38,%rsp
  800411:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800415:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800419:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80041d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800420:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800424:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800428:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80042b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80042f:	77 3b                	ja     80046c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800431:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800434:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800438:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80043b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80043f:	ba 00 00 00 00       	mov    $0x0,%edx
  800444:	48 f7 f3             	div    %rbx
  800447:	48 89 c2             	mov    %rax,%rdx
  80044a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80044d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800450:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800454:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800458:	41 89 f9             	mov    %edi,%r9d
  80045b:	48 89 c7             	mov    %rax,%rdi
  80045e:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800465:	00 00 00 
  800468:	ff d0                	callq  *%rax
  80046a:	eb 1e                	jmp    80048a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80046c:	eb 12                	jmp    800480 <printnum+0x78>
			putch(padc, putdat);
  80046e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800472:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800479:	48 89 ce             	mov    %rcx,%rsi
  80047c:	89 d7                	mov    %edx,%edi
  80047e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800480:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800484:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800488:	7f e4                	jg     80046e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80048a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80048d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800491:	ba 00 00 00 00       	mov    $0x0,%edx
  800496:	48 f7 f1             	div    %rcx
  800499:	48 89 d0             	mov    %rdx,%rax
  80049c:	48 ba 30 44 80 00 00 	movabs $0x804430,%rdx
  8004a3:	00 00 00 
  8004a6:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004aa:	0f be d0             	movsbl %al,%edx
  8004ad:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b5:	48 89 ce             	mov    %rcx,%rsi
  8004b8:	89 d7                	mov    %edx,%edi
  8004ba:	ff d0                	callq  *%rax
}
  8004bc:	48 83 c4 38          	add    $0x38,%rsp
  8004c0:	5b                   	pop    %rbx
  8004c1:	5d                   	pop    %rbp
  8004c2:	c3                   	retq   

00000000008004c3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004c3:	55                   	push   %rbp
  8004c4:	48 89 e5             	mov    %rsp,%rbp
  8004c7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004d2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004d6:	7e 52                	jle    80052a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004dc:	8b 00                	mov    (%rax),%eax
  8004de:	83 f8 30             	cmp    $0x30,%eax
  8004e1:	73 24                	jae    800507 <getuint+0x44>
  8004e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ef:	8b 00                	mov    (%rax),%eax
  8004f1:	89 c0                	mov    %eax,%eax
  8004f3:	48 01 d0             	add    %rdx,%rax
  8004f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004fa:	8b 12                	mov    (%rdx),%edx
  8004fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800503:	89 0a                	mov    %ecx,(%rdx)
  800505:	eb 17                	jmp    80051e <getuint+0x5b>
  800507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80050f:	48 89 d0             	mov    %rdx,%rax
  800512:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800516:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80051e:	48 8b 00             	mov    (%rax),%rax
  800521:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800525:	e9 a3 00 00 00       	jmpq   8005cd <getuint+0x10a>
	else if (lflag)
  80052a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80052e:	74 4f                	je     80057f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800534:	8b 00                	mov    (%rax),%eax
  800536:	83 f8 30             	cmp    $0x30,%eax
  800539:	73 24                	jae    80055f <getuint+0x9c>
  80053b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800547:	8b 00                	mov    (%rax),%eax
  800549:	89 c0                	mov    %eax,%eax
  80054b:	48 01 d0             	add    %rdx,%rax
  80054e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800552:	8b 12                	mov    (%rdx),%edx
  800554:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800557:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055b:	89 0a                	mov    %ecx,(%rdx)
  80055d:	eb 17                	jmp    800576 <getuint+0xb3>
  80055f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800563:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800567:	48 89 d0             	mov    %rdx,%rax
  80056a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80056e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800572:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800576:	48 8b 00             	mov    (%rax),%rax
  800579:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80057d:	eb 4e                	jmp    8005cd <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80057f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800583:	8b 00                	mov    (%rax),%eax
  800585:	83 f8 30             	cmp    $0x30,%eax
  800588:	73 24                	jae    8005ae <getuint+0xeb>
  80058a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800596:	8b 00                	mov    (%rax),%eax
  800598:	89 c0                	mov    %eax,%eax
  80059a:	48 01 d0             	add    %rdx,%rax
  80059d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a1:	8b 12                	mov    (%rdx),%edx
  8005a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005aa:	89 0a                	mov    %ecx,(%rdx)
  8005ac:	eb 17                	jmp    8005c5 <getuint+0x102>
  8005ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005b6:	48 89 d0             	mov    %rdx,%rax
  8005b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c5:	8b 00                	mov    (%rax),%eax
  8005c7:	89 c0                	mov    %eax,%eax
  8005c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005d1:	c9                   	leaveq 
  8005d2:	c3                   	retq   

00000000008005d3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d3:	55                   	push   %rbp
  8005d4:	48 89 e5             	mov    %rsp,%rbp
  8005d7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005df:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005e2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005e6:	7e 52                	jle    80063a <getint+0x67>
		x=va_arg(*ap, long long);
  8005e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ec:	8b 00                	mov    (%rax),%eax
  8005ee:	83 f8 30             	cmp    $0x30,%eax
  8005f1:	73 24                	jae    800617 <getint+0x44>
  8005f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ff:	8b 00                	mov    (%rax),%eax
  800601:	89 c0                	mov    %eax,%eax
  800603:	48 01 d0             	add    %rdx,%rax
  800606:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060a:	8b 12                	mov    (%rdx),%edx
  80060c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80060f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800613:	89 0a                	mov    %ecx,(%rdx)
  800615:	eb 17                	jmp    80062e <getint+0x5b>
  800617:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80061f:	48 89 d0             	mov    %rdx,%rax
  800622:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800626:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80062e:	48 8b 00             	mov    (%rax),%rax
  800631:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800635:	e9 a3 00 00 00       	jmpq   8006dd <getint+0x10a>
	else if (lflag)
  80063a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80063e:	74 4f                	je     80068f <getint+0xbc>
		x=va_arg(*ap, long);
  800640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800644:	8b 00                	mov    (%rax),%eax
  800646:	83 f8 30             	cmp    $0x30,%eax
  800649:	73 24                	jae    80066f <getint+0x9c>
  80064b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800657:	8b 00                	mov    (%rax),%eax
  800659:	89 c0                	mov    %eax,%eax
  80065b:	48 01 d0             	add    %rdx,%rax
  80065e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800662:	8b 12                	mov    (%rdx),%edx
  800664:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800667:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066b:	89 0a                	mov    %ecx,(%rdx)
  80066d:	eb 17                	jmp    800686 <getint+0xb3>
  80066f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800673:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800677:	48 89 d0             	mov    %rdx,%rax
  80067a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80067e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800682:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800686:	48 8b 00             	mov    (%rax),%rax
  800689:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80068d:	eb 4e                	jmp    8006dd <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80068f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800693:	8b 00                	mov    (%rax),%eax
  800695:	83 f8 30             	cmp    $0x30,%eax
  800698:	73 24                	jae    8006be <getint+0xeb>
  80069a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a6:	8b 00                	mov    (%rax),%eax
  8006a8:	89 c0                	mov    %eax,%eax
  8006aa:	48 01 d0             	add    %rdx,%rax
  8006ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b1:	8b 12                	mov    (%rdx),%edx
  8006b3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ba:	89 0a                	mov    %ecx,(%rdx)
  8006bc:	eb 17                	jmp    8006d5 <getint+0x102>
  8006be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c6:	48 89 d0             	mov    %rdx,%rax
  8006c9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d5:	8b 00                	mov    (%rax),%eax
  8006d7:	48 98                	cltq   
  8006d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006e1:	c9                   	leaveq 
  8006e2:	c3                   	retq   

00000000008006e3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e3:	55                   	push   %rbp
  8006e4:	48 89 e5             	mov    %rsp,%rbp
  8006e7:	41 54                	push   %r12
  8006e9:	53                   	push   %rbx
  8006ea:	48 83 ec 60          	sub    $0x60,%rsp
  8006ee:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006f2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006f6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006fa:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006fe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800702:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800706:	48 8b 0a             	mov    (%rdx),%rcx
  800709:	48 89 08             	mov    %rcx,(%rax)
  80070c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800710:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800714:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800718:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071c:	eb 28                	jmp    800746 <vprintfmt+0x63>
			if (ch == '\0'){
  80071e:	85 db                	test   %ebx,%ebx
  800720:	75 15                	jne    800737 <vprintfmt+0x54>
				current_color=WHITE;
  800722:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800729:	00 00 00 
  80072c:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800732:	e9 fc 04 00 00       	jmpq   800c33 <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  800737:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80073b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80073f:	48 89 d6             	mov    %rdx,%rsi
  800742:	89 df                	mov    %ebx,%edi
  800744:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800746:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80074a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80074e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800752:	0f b6 00             	movzbl (%rax),%eax
  800755:	0f b6 d8             	movzbl %al,%ebx
  800758:	83 fb 25             	cmp    $0x25,%ebx
  80075b:	75 c1                	jne    80071e <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80075d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800761:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800768:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80076f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800776:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80077d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800781:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800785:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800789:	0f b6 00             	movzbl (%rax),%eax
  80078c:	0f b6 d8             	movzbl %al,%ebx
  80078f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800792:	83 f8 55             	cmp    $0x55,%eax
  800795:	0f 87 64 04 00 00    	ja     800bff <vprintfmt+0x51c>
  80079b:	89 c0                	mov    %eax,%eax
  80079d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007a4:	00 
  8007a5:	48 b8 58 44 80 00 00 	movabs $0x804458,%rax
  8007ac:	00 00 00 
  8007af:	48 01 d0             	add    %rdx,%rax
  8007b2:	48 8b 00             	mov    (%rax),%rax
  8007b5:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8007b7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007bb:	eb c0                	jmp    80077d <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bd:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007c1:	eb ba                	jmp    80077d <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007ca:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007cd:	89 d0                	mov    %edx,%eax
  8007cf:	c1 e0 02             	shl    $0x2,%eax
  8007d2:	01 d0                	add    %edx,%eax
  8007d4:	01 c0                	add    %eax,%eax
  8007d6:	01 d8                	add    %ebx,%eax
  8007d8:	83 e8 30             	sub    $0x30,%eax
  8007db:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007de:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007e2:	0f b6 00             	movzbl (%rax),%eax
  8007e5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e8:	83 fb 2f             	cmp    $0x2f,%ebx
  8007eb:	7e 0c                	jle    8007f9 <vprintfmt+0x116>
  8007ed:	83 fb 39             	cmp    $0x39,%ebx
  8007f0:	7f 07                	jg     8007f9 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f7:	eb d1                	jmp    8007ca <vprintfmt+0xe7>
			goto process_precision;
  8007f9:	eb 58                	jmp    800853 <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  8007fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007fe:	83 f8 30             	cmp    $0x30,%eax
  800801:	73 17                	jae    80081a <vprintfmt+0x137>
  800803:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800807:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80080a:	89 c0                	mov    %eax,%eax
  80080c:	48 01 d0             	add    %rdx,%rax
  80080f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800812:	83 c2 08             	add    $0x8,%edx
  800815:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800818:	eb 0f                	jmp    800829 <vprintfmt+0x146>
  80081a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80081e:	48 89 d0             	mov    %rdx,%rax
  800821:	48 83 c2 08          	add    $0x8,%rdx
  800825:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800829:	8b 00                	mov    (%rax),%eax
  80082b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80082e:	eb 23                	jmp    800853 <vprintfmt+0x170>

		case '.':
			if (width < 0)
  800830:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800834:	79 0c                	jns    800842 <vprintfmt+0x15f>
				width = 0;
  800836:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80083d:	e9 3b ff ff ff       	jmpq   80077d <vprintfmt+0x9a>
  800842:	e9 36 ff ff ff       	jmpq   80077d <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  800847:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80084e:	e9 2a ff ff ff       	jmpq   80077d <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  800853:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800857:	79 12                	jns    80086b <vprintfmt+0x188>
				width = precision, precision = -1;
  800859:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80085c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80085f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800866:	e9 12 ff ff ff       	jmpq   80077d <vprintfmt+0x9a>
  80086b:	e9 0d ff ff ff       	jmpq   80077d <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800870:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800874:	e9 04 ff ff ff       	jmpq   80077d <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800879:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087c:	83 f8 30             	cmp    $0x30,%eax
  80087f:	73 17                	jae    800898 <vprintfmt+0x1b5>
  800881:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800885:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800888:	89 c0                	mov    %eax,%eax
  80088a:	48 01 d0             	add    %rdx,%rax
  80088d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800890:	83 c2 08             	add    $0x8,%edx
  800893:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800896:	eb 0f                	jmp    8008a7 <vprintfmt+0x1c4>
  800898:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80089c:	48 89 d0             	mov    %rdx,%rax
  80089f:	48 83 c2 08          	add    $0x8,%rdx
  8008a3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008a7:	8b 10                	mov    (%rax),%edx
  8008a9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008ad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b1:	48 89 ce             	mov    %rcx,%rsi
  8008b4:	89 d7                	mov    %edx,%edi
  8008b6:	ff d0                	callq  *%rax
			break;
  8008b8:	e9 70 03 00 00       	jmpq   800c2d <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8008bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c0:	83 f8 30             	cmp    $0x30,%eax
  8008c3:	73 17                	jae    8008dc <vprintfmt+0x1f9>
  8008c5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008cc:	89 c0                	mov    %eax,%eax
  8008ce:	48 01 d0             	add    %rdx,%rax
  8008d1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008d4:	83 c2 08             	add    $0x8,%edx
  8008d7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008da:	eb 0f                	jmp    8008eb <vprintfmt+0x208>
  8008dc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008e0:	48 89 d0             	mov    %rdx,%rax
  8008e3:	48 83 c2 08          	add    $0x8,%rdx
  8008e7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008eb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008ed:	85 db                	test   %ebx,%ebx
  8008ef:	79 02                	jns    8008f3 <vprintfmt+0x210>
				err = -err;
  8008f1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008f3:	83 fb 15             	cmp    $0x15,%ebx
  8008f6:	7f 16                	jg     80090e <vprintfmt+0x22b>
  8008f8:	48 b8 80 43 80 00 00 	movabs $0x804380,%rax
  8008ff:	00 00 00 
  800902:	48 63 d3             	movslq %ebx,%rdx
  800905:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800909:	4d 85 e4             	test   %r12,%r12
  80090c:	75 2e                	jne    80093c <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  80090e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800912:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800916:	89 d9                	mov    %ebx,%ecx
  800918:	48 ba 41 44 80 00 00 	movabs $0x804441,%rdx
  80091f:	00 00 00 
  800922:	48 89 c7             	mov    %rax,%rdi
  800925:	b8 00 00 00 00       	mov    $0x0,%eax
  80092a:	49 b8 3c 0c 80 00 00 	movabs $0x800c3c,%r8
  800931:	00 00 00 
  800934:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800937:	e9 f1 02 00 00       	jmpq   800c2d <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80093c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800940:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800944:	4c 89 e1             	mov    %r12,%rcx
  800947:	48 ba 4a 44 80 00 00 	movabs $0x80444a,%rdx
  80094e:	00 00 00 
  800951:	48 89 c7             	mov    %rax,%rdi
  800954:	b8 00 00 00 00       	mov    $0x0,%eax
  800959:	49 b8 3c 0c 80 00 00 	movabs $0x800c3c,%r8
  800960:	00 00 00 
  800963:	41 ff d0             	callq  *%r8
			break;
  800966:	e9 c2 02 00 00       	jmpq   800c2d <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80096b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096e:	83 f8 30             	cmp    $0x30,%eax
  800971:	73 17                	jae    80098a <vprintfmt+0x2a7>
  800973:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800977:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097a:	89 c0                	mov    %eax,%eax
  80097c:	48 01 d0             	add    %rdx,%rax
  80097f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800982:	83 c2 08             	add    $0x8,%edx
  800985:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800988:	eb 0f                	jmp    800999 <vprintfmt+0x2b6>
  80098a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80098e:	48 89 d0             	mov    %rdx,%rax
  800991:	48 83 c2 08          	add    $0x8,%rdx
  800995:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800999:	4c 8b 20             	mov    (%rax),%r12
  80099c:	4d 85 e4             	test   %r12,%r12
  80099f:	75 0a                	jne    8009ab <vprintfmt+0x2c8>
				p = "(null)";
  8009a1:	49 bc 4d 44 80 00 00 	movabs $0x80444d,%r12
  8009a8:	00 00 00 
			if (width > 0 && padc != '-')
  8009ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009af:	7e 3f                	jle    8009f0 <vprintfmt+0x30d>
  8009b1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8009b5:	74 39                	je     8009f0 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009ba:	48 98                	cltq   
  8009bc:	48 89 c6             	mov    %rax,%rsi
  8009bf:	4c 89 e7             	mov    %r12,%rdi
  8009c2:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  8009c9:	00 00 00 
  8009cc:	ff d0                	callq  *%rax
  8009ce:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009d1:	eb 17                	jmp    8009ea <vprintfmt+0x307>
					putch(padc, putdat);
  8009d3:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009d7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009db:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009df:	48 89 ce             	mov    %rcx,%rsi
  8009e2:	89 d7                	mov    %edx,%edi
  8009e4:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ee:	7f e3                	jg     8009d3 <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f0:	eb 37                	jmp    800a29 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009f6:	74 1e                	je     800a16 <vprintfmt+0x333>
  8009f8:	83 fb 1f             	cmp    $0x1f,%ebx
  8009fb:	7e 05                	jle    800a02 <vprintfmt+0x31f>
  8009fd:	83 fb 7e             	cmp    $0x7e,%ebx
  800a00:	7e 14                	jle    800a16 <vprintfmt+0x333>
					putch('?', putdat);
  800a02:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0a:	48 89 d6             	mov    %rdx,%rsi
  800a0d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a12:	ff d0                	callq  *%rax
  800a14:	eb 0f                	jmp    800a25 <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800a16:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1e:	48 89 d6             	mov    %rdx,%rsi
  800a21:	89 df                	mov    %ebx,%edi
  800a23:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a25:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a29:	4c 89 e0             	mov    %r12,%rax
  800a2c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a30:	0f b6 00             	movzbl (%rax),%eax
  800a33:	0f be d8             	movsbl %al,%ebx
  800a36:	85 db                	test   %ebx,%ebx
  800a38:	74 10                	je     800a4a <vprintfmt+0x367>
  800a3a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a3e:	78 b2                	js     8009f2 <vprintfmt+0x30f>
  800a40:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a44:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a48:	79 a8                	jns    8009f2 <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a4a:	eb 16                	jmp    800a62 <vprintfmt+0x37f>
				putch(' ', putdat);
  800a4c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a50:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a54:	48 89 d6             	mov    %rdx,%rsi
  800a57:	bf 20 00 00 00       	mov    $0x20,%edi
  800a5c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a5e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a62:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a66:	7f e4                	jg     800a4c <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800a68:	e9 c0 01 00 00       	jmpq   800c2d <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a6d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a71:	be 03 00 00 00       	mov    $0x3,%esi
  800a76:	48 89 c7             	mov    %rax,%rdi
  800a79:	48 b8 d3 05 80 00 00 	movabs $0x8005d3,%rax
  800a80:	00 00 00 
  800a83:	ff d0                	callq  *%rax
  800a85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8d:	48 85 c0             	test   %rax,%rax
  800a90:	79 1d                	jns    800aaf <vprintfmt+0x3cc>
				putch('-', putdat);
  800a92:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9a:	48 89 d6             	mov    %rdx,%rsi
  800a9d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800aa2:	ff d0                	callq  *%rax
				num = -(long long) num;
  800aa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa8:	48 f7 d8             	neg    %rax
  800aab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800aaf:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ab6:	e9 d5 00 00 00       	jmpq   800b90 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800abb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800abf:	be 03 00 00 00       	mov    $0x3,%esi
  800ac4:	48 89 c7             	mov    %rax,%rdi
  800ac7:	48 b8 c3 04 80 00 00 	movabs $0x8004c3,%rax
  800ace:	00 00 00 
  800ad1:	ff d0                	callq  *%rax
  800ad3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ad7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ade:	e9 ad 00 00 00       	jmpq   800b90 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800ae3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ae7:	be 03 00 00 00       	mov    $0x3,%esi
  800aec:	48 89 c7             	mov    %rax,%rdi
  800aef:	48 b8 c3 04 80 00 00 	movabs $0x8004c3,%rax
  800af6:	00 00 00 
  800af9:	ff d0                	callq  *%rax
  800afb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800aff:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b06:	e9 85 00 00 00       	jmpq   800b90 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800b0b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b13:	48 89 d6             	mov    %rdx,%rsi
  800b16:	bf 30 00 00 00       	mov    $0x30,%edi
  800b1b:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b25:	48 89 d6             	mov    %rdx,%rsi
  800b28:	bf 78 00 00 00       	mov    $0x78,%edi
  800b2d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b32:	83 f8 30             	cmp    $0x30,%eax
  800b35:	73 17                	jae    800b4e <vprintfmt+0x46b>
  800b37:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3e:	89 c0                	mov    %eax,%eax
  800b40:	48 01 d0             	add    %rdx,%rax
  800b43:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b46:	83 c2 08             	add    $0x8,%edx
  800b49:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b4c:	eb 0f                	jmp    800b5d <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  800b4e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b52:	48 89 d0             	mov    %rdx,%rax
  800b55:	48 83 c2 08          	add    $0x8,%rdx
  800b59:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b5d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b64:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b6b:	eb 23                	jmp    800b90 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b6d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b71:	be 03 00 00 00       	mov    $0x3,%esi
  800b76:	48 89 c7             	mov    %rax,%rdi
  800b79:	48 b8 c3 04 80 00 00 	movabs $0x8004c3,%rax
  800b80:	00 00 00 
  800b83:	ff d0                	callq  *%rax
  800b85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b89:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b90:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b95:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b98:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b9b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b9f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ba3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba7:	45 89 c1             	mov    %r8d,%r9d
  800baa:	41 89 f8             	mov    %edi,%r8d
  800bad:	48 89 c7             	mov    %rax,%rdi
  800bb0:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800bb7:	00 00 00 
  800bba:	ff d0                	callq  *%rax
			break;
  800bbc:	eb 6f                	jmp    800c2d <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bbe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc6:	48 89 d6             	mov    %rdx,%rsi
  800bc9:	89 df                	mov    %ebx,%edi
  800bcb:	ff d0                	callq  *%rax
			break;
  800bcd:	eb 5e                	jmp    800c2d <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  800bcf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bd3:	be 03 00 00 00       	mov    $0x3,%esi
  800bd8:	48 89 c7             	mov    %rax,%rdi
  800bdb:	48 b8 c3 04 80 00 00 	movabs $0x8004c3,%rax
  800be2:	00 00 00 
  800be5:	ff d0                	callq  *%rax
  800be7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  800beb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bef:	89 c2                	mov    %eax,%edx
  800bf1:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800bf8:	00 00 00 
  800bfb:	89 10                	mov    %edx,(%rax)
			break;
  800bfd:	eb 2e                	jmp    800c2d <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c03:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c07:	48 89 d6             	mov    %rdx,%rsi
  800c0a:	bf 25 00 00 00       	mov    $0x25,%edi
  800c0f:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c11:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c16:	eb 05                	jmp    800c1d <vprintfmt+0x53a>
  800c18:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c1d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c21:	48 83 e8 01          	sub    $0x1,%rax
  800c25:	0f b6 00             	movzbl (%rax),%eax
  800c28:	3c 25                	cmp    $0x25,%al
  800c2a:	75 ec                	jne    800c18 <vprintfmt+0x535>
				/* do nothing */;
			break;
  800c2c:	90                   	nop
		}
	}
  800c2d:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c2e:	e9 13 fb ff ff       	jmpq   800746 <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c33:	48 83 c4 60          	add    $0x60,%rsp
  800c37:	5b                   	pop    %rbx
  800c38:	41 5c                	pop    %r12
  800c3a:	5d                   	pop    %rbp
  800c3b:	c3                   	retq   

0000000000800c3c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c3c:	55                   	push   %rbp
  800c3d:	48 89 e5             	mov    %rsp,%rbp
  800c40:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c47:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c4e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c55:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c5c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c63:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c6a:	84 c0                	test   %al,%al
  800c6c:	74 20                	je     800c8e <printfmt+0x52>
  800c6e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c72:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c76:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c7a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c7e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c82:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c86:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c8a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c8e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c95:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c9c:	00 00 00 
  800c9f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ca6:	00 00 00 
  800ca9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cad:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800cb4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800cbb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800cc2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800cc9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800cd0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800cd7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800cde:	48 89 c7             	mov    %rax,%rdi
  800ce1:	48 b8 e3 06 80 00 00 	movabs $0x8006e3,%rax
  800ce8:	00 00 00 
  800ceb:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ced:	c9                   	leaveq 
  800cee:	c3                   	retq   

0000000000800cef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cef:	55                   	push   %rbp
  800cf0:	48 89 e5             	mov    %rsp,%rbp
  800cf3:	48 83 ec 10          	sub    $0x10,%rsp
  800cf7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cfa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d02:	8b 40 10             	mov    0x10(%rax),%eax
  800d05:	8d 50 01             	lea    0x1(%rax),%edx
  800d08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d0c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d13:	48 8b 10             	mov    (%rax),%rdx
  800d16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d1a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d1e:	48 39 c2             	cmp    %rax,%rdx
  800d21:	73 17                	jae    800d3a <sprintputch+0x4b>
		*b->buf++ = ch;
  800d23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d27:	48 8b 00             	mov    (%rax),%rax
  800d2a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d32:	48 89 0a             	mov    %rcx,(%rdx)
  800d35:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d38:	88 10                	mov    %dl,(%rax)
}
  800d3a:	c9                   	leaveq 
  800d3b:	c3                   	retq   

0000000000800d3c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d3c:	55                   	push   %rbp
  800d3d:	48 89 e5             	mov    %rsp,%rbp
  800d40:	48 83 ec 50          	sub    $0x50,%rsp
  800d44:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d48:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d4b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d4f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d53:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d57:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d5b:	48 8b 0a             	mov    (%rdx),%rcx
  800d5e:	48 89 08             	mov    %rcx,(%rax)
  800d61:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d65:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d69:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d6d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d71:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d75:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d79:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d7c:	48 98                	cltq   
  800d7e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d82:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d86:	48 01 d0             	add    %rdx,%rax
  800d89:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d8d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d94:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d99:	74 06                	je     800da1 <vsnprintf+0x65>
  800d9b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d9f:	7f 07                	jg     800da8 <vsnprintf+0x6c>
		return -E_INVAL;
  800da1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800da6:	eb 2f                	jmp    800dd7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800da8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800dac:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800db0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800db4:	48 89 c6             	mov    %rax,%rsi
  800db7:	48 bf ef 0c 80 00 00 	movabs $0x800cef,%rdi
  800dbe:	00 00 00 
  800dc1:	48 b8 e3 06 80 00 00 	movabs $0x8006e3,%rax
  800dc8:	00 00 00 
  800dcb:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800dcd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800dd1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800dd4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800dd7:	c9                   	leaveq 
  800dd8:	c3                   	retq   

0000000000800dd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dd9:	55                   	push   %rbp
  800dda:	48 89 e5             	mov    %rsp,%rbp
  800ddd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800de4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800deb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800df1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800df8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dff:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e06:	84 c0                	test   %al,%al
  800e08:	74 20                	je     800e2a <snprintf+0x51>
  800e0a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e0e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e12:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e16:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e1a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e1e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e22:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e26:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e2a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e31:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e38:	00 00 00 
  800e3b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e42:	00 00 00 
  800e45:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e49:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e50:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e57:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e5e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e65:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e6c:	48 8b 0a             	mov    (%rdx),%rcx
  800e6f:	48 89 08             	mov    %rcx,(%rax)
  800e72:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e76:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e7a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e7e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e82:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e89:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e90:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e96:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e9d:	48 89 c7             	mov    %rax,%rdi
  800ea0:	48 b8 3c 0d 80 00 00 	movabs $0x800d3c,%rax
  800ea7:	00 00 00 
  800eaa:	ff d0                	callq  *%rax
  800eac:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800eb2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800eb8:	c9                   	leaveq 
  800eb9:	c3                   	retq   

0000000000800eba <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800eba:	55                   	push   %rbp
  800ebb:	48 89 e5             	mov    %rsp,%rbp
  800ebe:	48 83 ec 18          	sub    $0x18,%rsp
  800ec2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ec6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ecd:	eb 09                	jmp    800ed8 <strlen+0x1e>
		n++;
  800ecf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ed3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800edc:	0f b6 00             	movzbl (%rax),%eax
  800edf:	84 c0                	test   %al,%al
  800ee1:	75 ec                	jne    800ecf <strlen+0x15>
		n++;
	return n;
  800ee3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ee6:	c9                   	leaveq 
  800ee7:	c3                   	retq   

0000000000800ee8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ee8:	55                   	push   %rbp
  800ee9:	48 89 e5             	mov    %rsp,%rbp
  800eec:	48 83 ec 20          	sub    $0x20,%rsp
  800ef0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ef8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800eff:	eb 0e                	jmp    800f0f <strnlen+0x27>
		n++;
  800f01:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f05:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f0a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f0f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f14:	74 0b                	je     800f21 <strnlen+0x39>
  800f16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f1a:	0f b6 00             	movzbl (%rax),%eax
  800f1d:	84 c0                	test   %al,%al
  800f1f:	75 e0                	jne    800f01 <strnlen+0x19>
		n++;
	return n;
  800f21:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f24:	c9                   	leaveq 
  800f25:	c3                   	retq   

0000000000800f26 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f26:	55                   	push   %rbp
  800f27:	48 89 e5             	mov    %rsp,%rbp
  800f2a:	48 83 ec 20          	sub    $0x20,%rsp
  800f2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f32:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f3e:	90                   	nop
  800f3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f43:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f47:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f4b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f4f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f53:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f57:	0f b6 12             	movzbl (%rdx),%edx
  800f5a:	88 10                	mov    %dl,(%rax)
  800f5c:	0f b6 00             	movzbl (%rax),%eax
  800f5f:	84 c0                	test   %al,%al
  800f61:	75 dc                	jne    800f3f <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f67:	c9                   	leaveq 
  800f68:	c3                   	retq   

0000000000800f69 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f69:	55                   	push   %rbp
  800f6a:	48 89 e5             	mov    %rsp,%rbp
  800f6d:	48 83 ec 20          	sub    $0x20,%rsp
  800f71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f75:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7d:	48 89 c7             	mov    %rax,%rdi
  800f80:	48 b8 ba 0e 80 00 00 	movabs $0x800eba,%rax
  800f87:	00 00 00 
  800f8a:	ff d0                	callq  *%rax
  800f8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f92:	48 63 d0             	movslq %eax,%rdx
  800f95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f99:	48 01 c2             	add    %rax,%rdx
  800f9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fa0:	48 89 c6             	mov    %rax,%rsi
  800fa3:	48 89 d7             	mov    %rdx,%rdi
  800fa6:	48 b8 26 0f 80 00 00 	movabs $0x800f26,%rax
  800fad:	00 00 00 
  800fb0:	ff d0                	callq  *%rax
	return dst;
  800fb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800fb6:	c9                   	leaveq 
  800fb7:	c3                   	retq   

0000000000800fb8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fb8:	55                   	push   %rbp
  800fb9:	48 89 e5             	mov    %rsp,%rbp
  800fbc:	48 83 ec 28          	sub    $0x28,%rsp
  800fc0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fc4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fc8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800fcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800fd4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800fdb:	00 
  800fdc:	eb 2a                	jmp    801008 <strncpy+0x50>
		*dst++ = *src;
  800fde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fe6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fee:	0f b6 12             	movzbl (%rdx),%edx
  800ff1:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ff3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ff7:	0f b6 00             	movzbl (%rax),%eax
  800ffa:	84 c0                	test   %al,%al
  800ffc:	74 05                	je     801003 <strncpy+0x4b>
			src++;
  800ffe:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801003:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801008:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80100c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801010:	72 cc                	jb     800fde <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801012:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801016:	c9                   	leaveq 
  801017:	c3                   	retq   

0000000000801018 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801018:	55                   	push   %rbp
  801019:	48 89 e5             	mov    %rsp,%rbp
  80101c:	48 83 ec 28          	sub    $0x28,%rsp
  801020:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801024:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801028:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80102c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801030:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801034:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801039:	74 3d                	je     801078 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80103b:	eb 1d                	jmp    80105a <strlcpy+0x42>
			*dst++ = *src++;
  80103d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801041:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801045:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801049:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80104d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801051:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801055:	0f b6 12             	movzbl (%rdx),%edx
  801058:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80105a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80105f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801064:	74 0b                	je     801071 <strlcpy+0x59>
  801066:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80106a:	0f b6 00             	movzbl (%rax),%eax
  80106d:	84 c0                	test   %al,%al
  80106f:	75 cc                	jne    80103d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801075:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801078:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80107c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801080:	48 29 c2             	sub    %rax,%rdx
  801083:	48 89 d0             	mov    %rdx,%rax
}
  801086:	c9                   	leaveq 
  801087:	c3                   	retq   

0000000000801088 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801088:	55                   	push   %rbp
  801089:	48 89 e5             	mov    %rsp,%rbp
  80108c:	48 83 ec 10          	sub    $0x10,%rsp
  801090:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801094:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801098:	eb 0a                	jmp    8010a4 <strcmp+0x1c>
		p++, q++;
  80109a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80109f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a8:	0f b6 00             	movzbl (%rax),%eax
  8010ab:	84 c0                	test   %al,%al
  8010ad:	74 12                	je     8010c1 <strcmp+0x39>
  8010af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b3:	0f b6 10             	movzbl (%rax),%edx
  8010b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ba:	0f b6 00             	movzbl (%rax),%eax
  8010bd:	38 c2                	cmp    %al,%dl
  8010bf:	74 d9                	je     80109a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c5:	0f b6 00             	movzbl (%rax),%eax
  8010c8:	0f b6 d0             	movzbl %al,%edx
  8010cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cf:	0f b6 00             	movzbl (%rax),%eax
  8010d2:	0f b6 c0             	movzbl %al,%eax
  8010d5:	29 c2                	sub    %eax,%edx
  8010d7:	89 d0                	mov    %edx,%eax
}
  8010d9:	c9                   	leaveq 
  8010da:	c3                   	retq   

00000000008010db <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010db:	55                   	push   %rbp
  8010dc:	48 89 e5             	mov    %rsp,%rbp
  8010df:	48 83 ec 18          	sub    $0x18,%rsp
  8010e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010eb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010ef:	eb 0f                	jmp    801100 <strncmp+0x25>
		n--, p++, q++;
  8010f1:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010fb:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801100:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801105:	74 1d                	je     801124 <strncmp+0x49>
  801107:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110b:	0f b6 00             	movzbl (%rax),%eax
  80110e:	84 c0                	test   %al,%al
  801110:	74 12                	je     801124 <strncmp+0x49>
  801112:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801116:	0f b6 10             	movzbl (%rax),%edx
  801119:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80111d:	0f b6 00             	movzbl (%rax),%eax
  801120:	38 c2                	cmp    %al,%dl
  801122:	74 cd                	je     8010f1 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801124:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801129:	75 07                	jne    801132 <strncmp+0x57>
		return 0;
  80112b:	b8 00 00 00 00       	mov    $0x0,%eax
  801130:	eb 18                	jmp    80114a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801136:	0f b6 00             	movzbl (%rax),%eax
  801139:	0f b6 d0             	movzbl %al,%edx
  80113c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801140:	0f b6 00             	movzbl (%rax),%eax
  801143:	0f b6 c0             	movzbl %al,%eax
  801146:	29 c2                	sub    %eax,%edx
  801148:	89 d0                	mov    %edx,%eax
}
  80114a:	c9                   	leaveq 
  80114b:	c3                   	retq   

000000000080114c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80114c:	55                   	push   %rbp
  80114d:	48 89 e5             	mov    %rsp,%rbp
  801150:	48 83 ec 0c          	sub    $0xc,%rsp
  801154:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801158:	89 f0                	mov    %esi,%eax
  80115a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80115d:	eb 17                	jmp    801176 <strchr+0x2a>
		if (*s == c)
  80115f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801163:	0f b6 00             	movzbl (%rax),%eax
  801166:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801169:	75 06                	jne    801171 <strchr+0x25>
			return (char *) s;
  80116b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116f:	eb 15                	jmp    801186 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801171:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801176:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117a:	0f b6 00             	movzbl (%rax),%eax
  80117d:	84 c0                	test   %al,%al
  80117f:	75 de                	jne    80115f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801181:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801186:	c9                   	leaveq 
  801187:	c3                   	retq   

0000000000801188 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801188:	55                   	push   %rbp
  801189:	48 89 e5             	mov    %rsp,%rbp
  80118c:	48 83 ec 0c          	sub    $0xc,%rsp
  801190:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801194:	89 f0                	mov    %esi,%eax
  801196:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801199:	eb 13                	jmp    8011ae <strfind+0x26>
		if (*s == c)
  80119b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119f:	0f b6 00             	movzbl (%rax),%eax
  8011a2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011a5:	75 02                	jne    8011a9 <strfind+0x21>
			break;
  8011a7:	eb 10                	jmp    8011b9 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b2:	0f b6 00             	movzbl (%rax),%eax
  8011b5:	84 c0                	test   %al,%al
  8011b7:	75 e2                	jne    80119b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8011b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011bd:	c9                   	leaveq 
  8011be:	c3                   	retq   

00000000008011bf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8011bf:	55                   	push   %rbp
  8011c0:	48 89 e5             	mov    %rsp,%rbp
  8011c3:	48 83 ec 18          	sub    $0x18,%rsp
  8011c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011cb:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8011ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8011d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011d7:	75 06                	jne    8011df <memset+0x20>
		return v;
  8011d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011dd:	eb 69                	jmp    801248 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e3:	83 e0 03             	and    $0x3,%eax
  8011e6:	48 85 c0             	test   %rax,%rax
  8011e9:	75 48                	jne    801233 <memset+0x74>
  8011eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ef:	83 e0 03             	and    $0x3,%eax
  8011f2:	48 85 c0             	test   %rax,%rax
  8011f5:	75 3c                	jne    801233 <memset+0x74>
		c &= 0xFF;
  8011f7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801201:	c1 e0 18             	shl    $0x18,%eax
  801204:	89 c2                	mov    %eax,%edx
  801206:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801209:	c1 e0 10             	shl    $0x10,%eax
  80120c:	09 c2                	or     %eax,%edx
  80120e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801211:	c1 e0 08             	shl    $0x8,%eax
  801214:	09 d0                	or     %edx,%eax
  801216:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801219:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121d:	48 c1 e8 02          	shr    $0x2,%rax
  801221:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801224:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801228:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80122b:	48 89 d7             	mov    %rdx,%rdi
  80122e:	fc                   	cld    
  80122f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801231:	eb 11                	jmp    801244 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801233:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801237:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80123a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80123e:	48 89 d7             	mov    %rdx,%rdi
  801241:	fc                   	cld    
  801242:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801248:	c9                   	leaveq 
  801249:	c3                   	retq   

000000000080124a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80124a:	55                   	push   %rbp
  80124b:	48 89 e5             	mov    %rsp,%rbp
  80124e:	48 83 ec 28          	sub    $0x28,%rsp
  801252:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801256:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80125a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80125e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801262:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801266:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80126e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801272:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801276:	0f 83 88 00 00 00    	jae    801304 <memmove+0xba>
  80127c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801280:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801284:	48 01 d0             	add    %rdx,%rax
  801287:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80128b:	76 77                	jbe    801304 <memmove+0xba>
		s += n;
  80128d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801291:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801295:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801299:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80129d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a1:	83 e0 03             	and    $0x3,%eax
  8012a4:	48 85 c0             	test   %rax,%rax
  8012a7:	75 3b                	jne    8012e4 <memmove+0x9a>
  8012a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ad:	83 e0 03             	and    $0x3,%eax
  8012b0:	48 85 c0             	test   %rax,%rax
  8012b3:	75 2f                	jne    8012e4 <memmove+0x9a>
  8012b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b9:	83 e0 03             	and    $0x3,%eax
  8012bc:	48 85 c0             	test   %rax,%rax
  8012bf:	75 23                	jne    8012e4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c5:	48 83 e8 04          	sub    $0x4,%rax
  8012c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012cd:	48 83 ea 04          	sub    $0x4,%rdx
  8012d1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012d5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012d9:	48 89 c7             	mov    %rax,%rdi
  8012dc:	48 89 d6             	mov    %rdx,%rsi
  8012df:	fd                   	std    
  8012e0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012e2:	eb 1d                	jmp    801301 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f8:	48 89 d7             	mov    %rdx,%rdi
  8012fb:	48 89 c1             	mov    %rax,%rcx
  8012fe:	fd                   	std    
  8012ff:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801301:	fc                   	cld    
  801302:	eb 57                	jmp    80135b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801304:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801308:	83 e0 03             	and    $0x3,%eax
  80130b:	48 85 c0             	test   %rax,%rax
  80130e:	75 36                	jne    801346 <memmove+0xfc>
  801310:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801314:	83 e0 03             	and    $0x3,%eax
  801317:	48 85 c0             	test   %rax,%rax
  80131a:	75 2a                	jne    801346 <memmove+0xfc>
  80131c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801320:	83 e0 03             	and    $0x3,%eax
  801323:	48 85 c0             	test   %rax,%rax
  801326:	75 1e                	jne    801346 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801328:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80132c:	48 c1 e8 02          	shr    $0x2,%rax
  801330:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801337:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80133b:	48 89 c7             	mov    %rax,%rdi
  80133e:	48 89 d6             	mov    %rdx,%rsi
  801341:	fc                   	cld    
  801342:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801344:	eb 15                	jmp    80135b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801346:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80134e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801352:	48 89 c7             	mov    %rax,%rdi
  801355:	48 89 d6             	mov    %rdx,%rsi
  801358:	fc                   	cld    
  801359:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80135b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80135f:	c9                   	leaveq 
  801360:	c3                   	retq   

0000000000801361 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801361:	55                   	push   %rbp
  801362:	48 89 e5             	mov    %rsp,%rbp
  801365:	48 83 ec 18          	sub    $0x18,%rsp
  801369:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801371:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801375:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801379:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80137d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801381:	48 89 ce             	mov    %rcx,%rsi
  801384:	48 89 c7             	mov    %rax,%rdi
  801387:	48 b8 4a 12 80 00 00 	movabs $0x80124a,%rax
  80138e:	00 00 00 
  801391:	ff d0                	callq  *%rax
}
  801393:	c9                   	leaveq 
  801394:	c3                   	retq   

0000000000801395 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801395:	55                   	push   %rbp
  801396:	48 89 e5             	mov    %rsp,%rbp
  801399:	48 83 ec 28          	sub    $0x28,%rsp
  80139d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8013a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8013b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8013b9:	eb 36                	jmp    8013f1 <memcmp+0x5c>
		if (*s1 != *s2)
  8013bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bf:	0f b6 10             	movzbl (%rax),%edx
  8013c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c6:	0f b6 00             	movzbl (%rax),%eax
  8013c9:	38 c2                	cmp    %al,%dl
  8013cb:	74 1a                	je     8013e7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8013cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d1:	0f b6 00             	movzbl (%rax),%eax
  8013d4:	0f b6 d0             	movzbl %al,%edx
  8013d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013db:	0f b6 00             	movzbl (%rax),%eax
  8013de:	0f b6 c0             	movzbl %al,%eax
  8013e1:	29 c2                	sub    %eax,%edx
  8013e3:	89 d0                	mov    %edx,%eax
  8013e5:	eb 20                	jmp    801407 <memcmp+0x72>
		s1++, s2++;
  8013e7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ec:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013fd:	48 85 c0             	test   %rax,%rax
  801400:	75 b9                	jne    8013bb <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801402:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801407:	c9                   	leaveq 
  801408:	c3                   	retq   

0000000000801409 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801409:	55                   	push   %rbp
  80140a:	48 89 e5             	mov    %rsp,%rbp
  80140d:	48 83 ec 28          	sub    $0x28,%rsp
  801411:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801415:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801418:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80141c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801420:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801424:	48 01 d0             	add    %rdx,%rax
  801427:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80142b:	eb 15                	jmp    801442 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80142d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801431:	0f b6 10             	movzbl (%rax),%edx
  801434:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801437:	38 c2                	cmp    %al,%dl
  801439:	75 02                	jne    80143d <memfind+0x34>
			break;
  80143b:	eb 0f                	jmp    80144c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80143d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801442:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801446:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80144a:	72 e1                	jb     80142d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80144c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801450:	c9                   	leaveq 
  801451:	c3                   	retq   

0000000000801452 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801452:	55                   	push   %rbp
  801453:	48 89 e5             	mov    %rsp,%rbp
  801456:	48 83 ec 34          	sub    $0x34,%rsp
  80145a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80145e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801462:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801465:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80146c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801473:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801474:	eb 05                	jmp    80147b <strtol+0x29>
		s++;
  801476:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80147b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147f:	0f b6 00             	movzbl (%rax),%eax
  801482:	3c 20                	cmp    $0x20,%al
  801484:	74 f0                	je     801476 <strtol+0x24>
  801486:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148a:	0f b6 00             	movzbl (%rax),%eax
  80148d:	3c 09                	cmp    $0x9,%al
  80148f:	74 e5                	je     801476 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801491:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801495:	0f b6 00             	movzbl (%rax),%eax
  801498:	3c 2b                	cmp    $0x2b,%al
  80149a:	75 07                	jne    8014a3 <strtol+0x51>
		s++;
  80149c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014a1:	eb 17                	jmp    8014ba <strtol+0x68>
	else if (*s == '-')
  8014a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a7:	0f b6 00             	movzbl (%rax),%eax
  8014aa:	3c 2d                	cmp    $0x2d,%al
  8014ac:	75 0c                	jne    8014ba <strtol+0x68>
		s++, neg = 1;
  8014ae:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014ba:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014be:	74 06                	je     8014c6 <strtol+0x74>
  8014c0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8014c4:	75 28                	jne    8014ee <strtol+0x9c>
  8014c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ca:	0f b6 00             	movzbl (%rax),%eax
  8014cd:	3c 30                	cmp    $0x30,%al
  8014cf:	75 1d                	jne    8014ee <strtol+0x9c>
  8014d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d5:	48 83 c0 01          	add    $0x1,%rax
  8014d9:	0f b6 00             	movzbl (%rax),%eax
  8014dc:	3c 78                	cmp    $0x78,%al
  8014de:	75 0e                	jne    8014ee <strtol+0x9c>
		s += 2, base = 16;
  8014e0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014e5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014ec:	eb 2c                	jmp    80151a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014ee:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014f2:	75 19                	jne    80150d <strtol+0xbb>
  8014f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f8:	0f b6 00             	movzbl (%rax),%eax
  8014fb:	3c 30                	cmp    $0x30,%al
  8014fd:	75 0e                	jne    80150d <strtol+0xbb>
		s++, base = 8;
  8014ff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801504:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80150b:	eb 0d                	jmp    80151a <strtol+0xc8>
	else if (base == 0)
  80150d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801511:	75 07                	jne    80151a <strtol+0xc8>
		base = 10;
  801513:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80151a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151e:	0f b6 00             	movzbl (%rax),%eax
  801521:	3c 2f                	cmp    $0x2f,%al
  801523:	7e 1d                	jle    801542 <strtol+0xf0>
  801525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801529:	0f b6 00             	movzbl (%rax),%eax
  80152c:	3c 39                	cmp    $0x39,%al
  80152e:	7f 12                	jg     801542 <strtol+0xf0>
			dig = *s - '0';
  801530:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801534:	0f b6 00             	movzbl (%rax),%eax
  801537:	0f be c0             	movsbl %al,%eax
  80153a:	83 e8 30             	sub    $0x30,%eax
  80153d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801540:	eb 4e                	jmp    801590 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801542:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801546:	0f b6 00             	movzbl (%rax),%eax
  801549:	3c 60                	cmp    $0x60,%al
  80154b:	7e 1d                	jle    80156a <strtol+0x118>
  80154d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801551:	0f b6 00             	movzbl (%rax),%eax
  801554:	3c 7a                	cmp    $0x7a,%al
  801556:	7f 12                	jg     80156a <strtol+0x118>
			dig = *s - 'a' + 10;
  801558:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155c:	0f b6 00             	movzbl (%rax),%eax
  80155f:	0f be c0             	movsbl %al,%eax
  801562:	83 e8 57             	sub    $0x57,%eax
  801565:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801568:	eb 26                	jmp    801590 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80156a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156e:	0f b6 00             	movzbl (%rax),%eax
  801571:	3c 40                	cmp    $0x40,%al
  801573:	7e 48                	jle    8015bd <strtol+0x16b>
  801575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801579:	0f b6 00             	movzbl (%rax),%eax
  80157c:	3c 5a                	cmp    $0x5a,%al
  80157e:	7f 3d                	jg     8015bd <strtol+0x16b>
			dig = *s - 'A' + 10;
  801580:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801584:	0f b6 00             	movzbl (%rax),%eax
  801587:	0f be c0             	movsbl %al,%eax
  80158a:	83 e8 37             	sub    $0x37,%eax
  80158d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801590:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801593:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801596:	7c 02                	jl     80159a <strtol+0x148>
			break;
  801598:	eb 23                	jmp    8015bd <strtol+0x16b>
		s++, val = (val * base) + dig;
  80159a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80159f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015a2:	48 98                	cltq   
  8015a4:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8015a9:	48 89 c2             	mov    %rax,%rdx
  8015ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015af:	48 98                	cltq   
  8015b1:	48 01 d0             	add    %rdx,%rax
  8015b4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8015b8:	e9 5d ff ff ff       	jmpq   80151a <strtol+0xc8>

	if (endptr)
  8015bd:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8015c2:	74 0b                	je     8015cf <strtol+0x17d>
		*endptr = (char *) s;
  8015c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015cc:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8015cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015d3:	74 09                	je     8015de <strtol+0x18c>
  8015d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d9:	48 f7 d8             	neg    %rax
  8015dc:	eb 04                	jmp    8015e2 <strtol+0x190>
  8015de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015e2:	c9                   	leaveq 
  8015e3:	c3                   	retq   

00000000008015e4 <strstr>:

char * strstr(const char *in, const char *str)
{
  8015e4:	55                   	push   %rbp
  8015e5:	48 89 e5             	mov    %rsp,%rbp
  8015e8:	48 83 ec 30          	sub    $0x30,%rsp
  8015ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015fc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801600:	0f b6 00             	movzbl (%rax),%eax
  801603:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801606:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80160a:	75 06                	jne    801612 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80160c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801610:	eb 6b                	jmp    80167d <strstr+0x99>

	len = strlen(str);
  801612:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801616:	48 89 c7             	mov    %rax,%rdi
  801619:	48 b8 ba 0e 80 00 00 	movabs $0x800eba,%rax
  801620:	00 00 00 
  801623:	ff d0                	callq  *%rax
  801625:	48 98                	cltq   
  801627:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80162b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801633:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801637:	0f b6 00             	movzbl (%rax),%eax
  80163a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80163d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801641:	75 07                	jne    80164a <strstr+0x66>
				return (char *) 0;
  801643:	b8 00 00 00 00       	mov    $0x0,%eax
  801648:	eb 33                	jmp    80167d <strstr+0x99>
		} while (sc != c);
  80164a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80164e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801651:	75 d8                	jne    80162b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801653:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801657:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80165b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165f:	48 89 ce             	mov    %rcx,%rsi
  801662:	48 89 c7             	mov    %rax,%rdi
  801665:	48 b8 db 10 80 00 00 	movabs $0x8010db,%rax
  80166c:	00 00 00 
  80166f:	ff d0                	callq  *%rax
  801671:	85 c0                	test   %eax,%eax
  801673:	75 b6                	jne    80162b <strstr+0x47>

	return (char *) (in - 1);
  801675:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801679:	48 83 e8 01          	sub    $0x1,%rax
}
  80167d:	c9                   	leaveq 
  80167e:	c3                   	retq   

000000000080167f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80167f:	55                   	push   %rbp
  801680:	48 89 e5             	mov    %rsp,%rbp
  801683:	53                   	push   %rbx
  801684:	48 83 ec 48          	sub    $0x48,%rsp
  801688:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80168b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80168e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801692:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801696:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80169a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80169e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016a1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016a5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8016a9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8016ad:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8016b1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8016b5:	4c 89 c3             	mov    %r8,%rbx
  8016b8:	cd 30                	int    $0x30
  8016ba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8016be:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8016c2:	74 3e                	je     801702 <syscall+0x83>
  8016c4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016c9:	7e 37                	jle    801702 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016cf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016d2:	49 89 d0             	mov    %rdx,%r8
  8016d5:	89 c1                	mov    %eax,%ecx
  8016d7:	48 ba 08 47 80 00 00 	movabs $0x804708,%rdx
  8016de:	00 00 00 
  8016e1:	be 23 00 00 00       	mov    $0x23,%esi
  8016e6:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  8016ed:	00 00 00 
  8016f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f5:	49 b9 0e 3d 80 00 00 	movabs $0x803d0e,%r9
  8016fc:	00 00 00 
  8016ff:	41 ff d1             	callq  *%r9

	return ret;
  801702:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801706:	48 83 c4 48          	add    $0x48,%rsp
  80170a:	5b                   	pop    %rbx
  80170b:	5d                   	pop    %rbp
  80170c:	c3                   	retq   

000000000080170d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80170d:	55                   	push   %rbp
  80170e:	48 89 e5             	mov    %rsp,%rbp
  801711:	48 83 ec 20          	sub    $0x20,%rsp
  801715:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801719:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80171d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801721:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801725:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80172c:	00 
  80172d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801733:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801739:	48 89 d1             	mov    %rdx,%rcx
  80173c:	48 89 c2             	mov    %rax,%rdx
  80173f:	be 00 00 00 00       	mov    $0x0,%esi
  801744:	bf 00 00 00 00       	mov    $0x0,%edi
  801749:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  801750:	00 00 00 
  801753:	ff d0                	callq  *%rax
}
  801755:	c9                   	leaveq 
  801756:	c3                   	retq   

0000000000801757 <sys_cgetc>:

int
sys_cgetc(void)
{
  801757:	55                   	push   %rbp
  801758:	48 89 e5             	mov    %rsp,%rbp
  80175b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80175f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801766:	00 
  801767:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80176d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801773:	b9 00 00 00 00       	mov    $0x0,%ecx
  801778:	ba 00 00 00 00       	mov    $0x0,%edx
  80177d:	be 00 00 00 00       	mov    $0x0,%esi
  801782:	bf 01 00 00 00       	mov    $0x1,%edi
  801787:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  80178e:	00 00 00 
  801791:	ff d0                	callq  *%rax
}
  801793:	c9                   	leaveq 
  801794:	c3                   	retq   

0000000000801795 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801795:	55                   	push   %rbp
  801796:	48 89 e5             	mov    %rsp,%rbp
  801799:	48 83 ec 10          	sub    $0x10,%rsp
  80179d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017a3:	48 98                	cltq   
  8017a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017ac:	00 
  8017ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017be:	48 89 c2             	mov    %rax,%rdx
  8017c1:	be 01 00 00 00       	mov    $0x1,%esi
  8017c6:	bf 03 00 00 00       	mov    $0x3,%edi
  8017cb:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  8017d2:	00 00 00 
  8017d5:	ff d0                	callq  *%rax
}
  8017d7:	c9                   	leaveq 
  8017d8:	c3                   	retq   

00000000008017d9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017d9:	55                   	push   %rbp
  8017da:	48 89 e5             	mov    %rsp,%rbp
  8017dd:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017e1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017e8:	00 
  8017e9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ff:	be 00 00 00 00       	mov    $0x0,%esi
  801804:	bf 02 00 00 00       	mov    $0x2,%edi
  801809:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  801810:	00 00 00 
  801813:	ff d0                	callq  *%rax
}
  801815:	c9                   	leaveq 
  801816:	c3                   	retq   

0000000000801817 <sys_yield>:

void
sys_yield(void)
{
  801817:	55                   	push   %rbp
  801818:	48 89 e5             	mov    %rsp,%rbp
  80181b:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80181f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801826:	00 
  801827:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801833:	b9 00 00 00 00       	mov    $0x0,%ecx
  801838:	ba 00 00 00 00       	mov    $0x0,%edx
  80183d:	be 00 00 00 00       	mov    $0x0,%esi
  801842:	bf 0b 00 00 00       	mov    $0xb,%edi
  801847:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  80184e:	00 00 00 
  801851:	ff d0                	callq  *%rax
}
  801853:	c9                   	leaveq 
  801854:	c3                   	retq   

0000000000801855 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801855:	55                   	push   %rbp
  801856:	48 89 e5             	mov    %rsp,%rbp
  801859:	48 83 ec 20          	sub    $0x20,%rsp
  80185d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801860:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801864:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801867:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80186a:	48 63 c8             	movslq %eax,%rcx
  80186d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801871:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801874:	48 98                	cltq   
  801876:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80187d:	00 
  80187e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801884:	49 89 c8             	mov    %rcx,%r8
  801887:	48 89 d1             	mov    %rdx,%rcx
  80188a:	48 89 c2             	mov    %rax,%rdx
  80188d:	be 01 00 00 00       	mov    $0x1,%esi
  801892:	bf 04 00 00 00       	mov    $0x4,%edi
  801897:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  80189e:	00 00 00 
  8018a1:	ff d0                	callq  *%rax
}
  8018a3:	c9                   	leaveq 
  8018a4:	c3                   	retq   

00000000008018a5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018a5:	55                   	push   %rbp
  8018a6:	48 89 e5             	mov    %rsp,%rbp
  8018a9:	48 83 ec 30          	sub    $0x30,%rsp
  8018ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018b4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8018b7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8018bb:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8018bf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018c2:	48 63 c8             	movslq %eax,%rcx
  8018c5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8018c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018cc:	48 63 f0             	movslq %eax,%rsi
  8018cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d6:	48 98                	cltq   
  8018d8:	48 89 0c 24          	mov    %rcx,(%rsp)
  8018dc:	49 89 f9             	mov    %rdi,%r9
  8018df:	49 89 f0             	mov    %rsi,%r8
  8018e2:	48 89 d1             	mov    %rdx,%rcx
  8018e5:	48 89 c2             	mov    %rax,%rdx
  8018e8:	be 01 00 00 00       	mov    $0x1,%esi
  8018ed:	bf 05 00 00 00       	mov    $0x5,%edi
  8018f2:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  8018f9:	00 00 00 
  8018fc:	ff d0                	callq  *%rax
}
  8018fe:	c9                   	leaveq 
  8018ff:	c3                   	retq   

0000000000801900 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801900:	55                   	push   %rbp
  801901:	48 89 e5             	mov    %rsp,%rbp
  801904:	48 83 ec 20          	sub    $0x20,%rsp
  801908:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80190b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80190f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801913:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801916:	48 98                	cltq   
  801918:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191f:	00 
  801920:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801926:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192c:	48 89 d1             	mov    %rdx,%rcx
  80192f:	48 89 c2             	mov    %rax,%rdx
  801932:	be 01 00 00 00       	mov    $0x1,%esi
  801937:	bf 06 00 00 00       	mov    $0x6,%edi
  80193c:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  801943:	00 00 00 
  801946:	ff d0                	callq  *%rax
}
  801948:	c9                   	leaveq 
  801949:	c3                   	retq   

000000000080194a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80194a:	55                   	push   %rbp
  80194b:	48 89 e5             	mov    %rsp,%rbp
  80194e:	48 83 ec 10          	sub    $0x10,%rsp
  801952:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801955:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801958:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80195b:	48 63 d0             	movslq %eax,%rdx
  80195e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801961:	48 98                	cltq   
  801963:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80196a:	00 
  80196b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801971:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801977:	48 89 d1             	mov    %rdx,%rcx
  80197a:	48 89 c2             	mov    %rax,%rdx
  80197d:	be 01 00 00 00       	mov    $0x1,%esi
  801982:	bf 08 00 00 00       	mov    $0x8,%edi
  801987:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  80198e:	00 00 00 
  801991:	ff d0                	callq  *%rax
}
  801993:	c9                   	leaveq 
  801994:	c3                   	retq   

0000000000801995 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801995:	55                   	push   %rbp
  801996:	48 89 e5             	mov    %rsp,%rbp
  801999:	48 83 ec 20          	sub    $0x20,%rsp
  80199d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ab:	48 98                	cltq   
  8019ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b4:	00 
  8019b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c1:	48 89 d1             	mov    %rdx,%rcx
  8019c4:	48 89 c2             	mov    %rax,%rdx
  8019c7:	be 01 00 00 00       	mov    $0x1,%esi
  8019cc:	bf 09 00 00 00       	mov    $0x9,%edi
  8019d1:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  8019d8:	00 00 00 
  8019db:	ff d0                	callq  *%rax
}
  8019dd:	c9                   	leaveq 
  8019de:	c3                   	retq   

00000000008019df <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019df:	55                   	push   %rbp
  8019e0:	48 89 e5             	mov    %rsp,%rbp
  8019e3:	48 83 ec 20          	sub    $0x20,%rsp
  8019e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8019ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f5:	48 98                	cltq   
  8019f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019fe:	00 
  8019ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0b:	48 89 d1             	mov    %rdx,%rcx
  801a0e:	48 89 c2             	mov    %rax,%rdx
  801a11:	be 01 00 00 00       	mov    $0x1,%esi
  801a16:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a1b:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  801a22:	00 00 00 
  801a25:	ff d0                	callq  *%rax
}
  801a27:	c9                   	leaveq 
  801a28:	c3                   	retq   

0000000000801a29 <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801a29:	55                   	push   %rbp
  801a2a:	48 89 e5             	mov    %rsp,%rbp
  801a2d:	48 83 ec 10          	sub    $0x10,%rsp
  801a31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a34:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801a37:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a3a:	48 63 d0             	movslq %eax,%rdx
  801a3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a40:	48 98                	cltq   
  801a42:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a49:	00 
  801a4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a56:	48 89 d1             	mov    %rdx,%rcx
  801a59:	48 89 c2             	mov    %rax,%rdx
  801a5c:	be 01 00 00 00       	mov    $0x1,%esi
  801a61:	bf 11 00 00 00       	mov    $0x11,%edi
  801a66:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  801a6d:	00 00 00 
  801a70:	ff d0                	callq  *%rax

}
  801a72:	c9                   	leaveq 
  801a73:	c3                   	retq   

0000000000801a74 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a74:	55                   	push   %rbp
  801a75:	48 89 e5             	mov    %rsp,%rbp
  801a78:	48 83 ec 20          	sub    $0x20,%rsp
  801a7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a83:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a87:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a8d:	48 63 f0             	movslq %eax,%rsi
  801a90:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a97:	48 98                	cltq   
  801a99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a9d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa4:	00 
  801aa5:	49 89 f1             	mov    %rsi,%r9
  801aa8:	49 89 c8             	mov    %rcx,%r8
  801aab:	48 89 d1             	mov    %rdx,%rcx
  801aae:	48 89 c2             	mov    %rax,%rdx
  801ab1:	be 00 00 00 00       	mov    $0x0,%esi
  801ab6:	bf 0c 00 00 00       	mov    $0xc,%edi
  801abb:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  801ac2:	00 00 00 
  801ac5:	ff d0                	callq  *%rax
}
  801ac7:	c9                   	leaveq 
  801ac8:	c3                   	retq   

0000000000801ac9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ac9:	55                   	push   %rbp
  801aca:	48 89 e5             	mov    %rsp,%rbp
  801acd:	48 83 ec 10          	sub    $0x10,%rsp
  801ad1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ad5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae0:	00 
  801ae1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aed:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af2:	48 89 c2             	mov    %rax,%rdx
  801af5:	be 01 00 00 00       	mov    $0x1,%esi
  801afa:	bf 0d 00 00 00       	mov    $0xd,%edi
  801aff:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  801b06:	00 00 00 
  801b09:	ff d0                	callq  *%rax
}
  801b0b:	c9                   	leaveq 
  801b0c:	c3                   	retq   

0000000000801b0d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801b0d:	55                   	push   %rbp
  801b0e:	48 89 e5             	mov    %rsp,%rbp
  801b11:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b15:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b1c:	00 
  801b1d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b23:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b29:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b33:	be 00 00 00 00       	mov    $0x0,%esi
  801b38:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b3d:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  801b44:	00 00 00 
  801b47:	ff d0                	callq  *%rax
}
  801b49:	c9                   	leaveq 
  801b4a:	c3                   	retq   

0000000000801b4b <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801b4b:	55                   	push   %rbp
  801b4c:	48 89 e5             	mov    %rsp,%rbp
  801b4f:	48 83 ec 30          	sub    $0x30,%rsp
  801b53:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b5a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b5d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b61:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801b65:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b68:	48 63 c8             	movslq %eax,%rcx
  801b6b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b72:	48 63 f0             	movslq %eax,%rsi
  801b75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7c:	48 98                	cltq   
  801b7e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b82:	49 89 f9             	mov    %rdi,%r9
  801b85:	49 89 f0             	mov    %rsi,%r8
  801b88:	48 89 d1             	mov    %rdx,%rcx
  801b8b:	48 89 c2             	mov    %rax,%rdx
  801b8e:	be 00 00 00 00       	mov    $0x0,%esi
  801b93:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b98:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  801b9f:	00 00 00 
  801ba2:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801ba4:	c9                   	leaveq 
  801ba5:	c3                   	retq   

0000000000801ba6 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801ba6:	55                   	push   %rbp
  801ba7:	48 89 e5             	mov    %rsp,%rbp
  801baa:	48 83 ec 20          	sub    $0x20,%rsp
  801bae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bb2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801bb6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bbe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc5:	00 
  801bc6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bcc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd2:	48 89 d1             	mov    %rdx,%rcx
  801bd5:	48 89 c2             	mov    %rax,%rdx
  801bd8:	be 00 00 00 00       	mov    $0x0,%esi
  801bdd:	bf 10 00 00 00       	mov    $0x10,%edi
  801be2:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  801be9:	00 00 00 
  801bec:	ff d0                	callq  *%rax
}
  801bee:	c9                   	leaveq 
  801bef:	c3                   	retq   

0000000000801bf0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801bf0:	55                   	push   %rbp
  801bf1:	48 89 e5             	mov    %rsp,%rbp
  801bf4:	48 83 ec 30          	sub    $0x30,%rsp
  801bf8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)



	void *addr = (void *) utf->utf_fault_va;
  801bfc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c00:	48 8b 00             	mov    (%rax),%rax
  801c03:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801c07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c0b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c0f:	89 45 f4             	mov    %eax,-0xc(%rbp)
        // Hint:
        //   Use the read-only page table mappings at vpt
        //   (see <inc/memlayout.h>).

        // LAB 4: Your code here.
	if (!(err&FEC_WR))
  801c12:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c15:	83 e0 02             	and    $0x2,%eax
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	75 2a                	jne    801c46 <pgfault+0x56>
		panic("pgfault:FEC_WR check\n");
  801c1c:	48 ba 38 47 80 00 00 	movabs $0x804738,%rdx
  801c23:	00 00 00 
  801c26:	be 21 00 00 00       	mov    $0x21,%esi
  801c2b:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  801c32:	00 00 00 
  801c35:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3a:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  801c41:	00 00 00 
  801c44:	ff d1                	callq  *%rcx
	if (!(uvpt[((uint64_t)addr) / PGSIZE] & PTE_COW))
  801c46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4a:	48 c1 e8 0c          	shr    $0xc,%rax
  801c4e:	48 89 c2             	mov    %rax,%rdx
  801c51:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c58:	01 00 00 
  801c5b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c5f:	25 00 08 00 00       	and    $0x800,%eax
  801c64:	48 85 c0             	test   %rax,%rax
  801c67:	75 2a                	jne    801c93 <pgfault+0xa3>
		panic("pgfault:PTE_COW check\n");
  801c69:	48 ba 59 47 80 00 00 	movabs $0x804759,%rdx
  801c70:	00 00 00 
  801c73:	be 23 00 00 00       	mov    $0x23,%esi
  801c78:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  801c7f:	00 00 00 
  801c82:	b8 00 00 00 00       	mov    $0x0,%eax
  801c87:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  801c8e:	00 00 00 
  801c91:	ff d1                	callq  *%rcx
        // Hint:
        //   You should make three system calls.
        //   No need to explicitly delete the old page's mapping.

        // LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801c93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c97:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c9f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801ca5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U)<0)
  801ca9:	ba 07 00 00 00       	mov    $0x7,%edx
  801cae:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cb3:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb8:	48 b8 55 18 80 00 00 	movabs $0x801855,%rax
  801cbf:	00 00 00 
  801cc2:	ff d0                	callq  *%rax
  801cc4:	85 c0                	test   %eax,%eax
  801cc6:	79 2a                	jns    801cf2 <pgfault+0x102>
		panic("pgfault: sys_page_alloc error\n");
  801cc8:	48 ba 70 47 80 00 00 	movabs $0x804770,%rdx
  801ccf:	00 00 00 
  801cd2:	be 2f 00 00 00       	mov    $0x2f,%esi
  801cd7:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  801cde:	00 00 00 
  801ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce6:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  801ced:	00 00 00 
  801cf0:	ff d1                	callq  *%rcx
	memcpy(PFTEMP, addr, PGSIZE);
  801cf2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf6:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cfb:	48 89 c6             	mov    %rax,%rsi
  801cfe:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801d03:	48 b8 61 13 80 00 00 	movabs $0x801361,%rax
  801d0a:	00 00 00 
  801d0d:	ff d0                	callq  *%rax
	if (sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0)
  801d0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d13:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801d19:	48 89 c1             	mov    %rax,%rcx
  801d1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d21:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d26:	bf 00 00 00 00       	mov    $0x0,%edi
  801d2b:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  801d32:	00 00 00 
  801d35:	ff d0                	callq  *%rax
  801d37:	85 c0                	test   %eax,%eax
  801d39:	79 2a                	jns    801d65 <pgfault+0x175>
		panic("pgfault: sys_page_map error\n");
  801d3b:	48 ba 8f 47 80 00 00 	movabs $0x80478f,%rdx
  801d42:	00 00 00 
  801d45:	be 32 00 00 00       	mov    $0x32,%esi
  801d4a:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  801d51:	00 00 00 
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
  801d59:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  801d60:	00 00 00 
  801d63:	ff d1                	callq  *%rcx

	if (sys_page_unmap(0, (void *)PFTEMP)<0)
  801d65:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d6a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d6f:	48 b8 00 19 80 00 00 	movabs $0x801900,%rax
  801d76:	00 00 00 
  801d79:	ff d0                	callq  *%rax
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	79 2a                	jns    801da9 <pgfault+0x1b9>
		panic("pgfault: sys_page_unmap error\n");
  801d7f:	48 ba b0 47 80 00 00 	movabs $0x8047b0,%rdx
  801d86:	00 00 00 
  801d89:	be 35 00 00 00       	mov    $0x35,%esi
  801d8e:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  801d95:	00 00 00 
  801d98:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9d:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  801da4:	00 00 00 
  801da7:	ff d1                	callq  *%rcx
	


}
  801da9:	c9                   	leaveq 
  801daa:	c3                   	retq   

0000000000801dab <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801dab:	55                   	push   %rbp
  801dac:	48 89 e5             	mov    %rsp,%rbp
  801daf:	48 83 ec 10          	sub    $0x10,%rsp
  801db3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db6:	89 75 f8             	mov    %esi,-0x8(%rbp)

	if (uvpt[pn] & PTE_SHARE){
  801db9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dc0:	01 00 00 
  801dc3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801dc6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dca:	25 00 04 00 00       	and    $0x400,%eax
  801dcf:	48 85 c0             	test   %rax,%rax
  801dd2:	74 75                	je     801e49 <duppage+0x9e>
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
  801dd4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ddb:	01 00 00 
  801dde:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801de1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801de5:	25 07 0e 00 00       	and    $0xe07,%eax
  801dea:	89 c6                	mov    %eax,%esi
  801dec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801def:	48 c1 e0 0c          	shl    $0xc,%rax
  801df3:	48 89 c1             	mov    %rax,%rcx
  801df6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801df9:	48 c1 e0 0c          	shl    $0xc,%rax
  801dfd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e00:	41 89 f0             	mov    %esi,%r8d
  801e03:	48 89 c6             	mov    %rax,%rsi
  801e06:	bf 00 00 00 00       	mov    $0x0,%edi
  801e0b:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  801e12:	00 00 00 
  801e15:	ff d0                	callq  *%rax
  801e17:	85 c0                	test   %eax,%eax
  801e19:	0f 89 82 01 00 00    	jns    801fa1 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");	
  801e1f:	48 ba cf 47 80 00 00 	movabs $0x8047cf,%rdx
  801e26:	00 00 00 
  801e29:	be 4c 00 00 00       	mov    $0x4c,%esi
  801e2e:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  801e35:	00 00 00 
  801e38:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3d:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  801e44:	00 00 00 
  801e47:	ff d1                	callq  *%rcx
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
  801e49:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e50:	01 00 00 
  801e53:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801e56:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e5a:	83 e0 02             	and    $0x2,%eax
  801e5d:	48 85 c0             	test   %rax,%rax
  801e60:	75 7e                	jne    801ee0 <duppage+0x135>
  801e62:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e69:	01 00 00 
  801e6c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801e6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e73:	25 00 08 00 00       	and    $0x800,%eax
  801e78:	48 85 c0             	test   %rax,%rax
  801e7b:	75 63                	jne    801ee0 <duppage+0x135>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  801e7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e80:	c1 e0 0c             	shl    $0xc,%eax
  801e83:	89 c0                	mov    %eax,%eax
  801e85:	48 89 c1             	mov    %rax,%rcx
  801e88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e8b:	c1 e0 0c             	shl    $0xc,%eax
  801e8e:	89 c0                	mov    %eax,%eax
  801e90:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e93:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  801e99:	48 89 c6             	mov    %rax,%rsi
  801e9c:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea1:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  801ea8:	00 00 00 
  801eab:	ff d0                	callq  *%rax
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	79 2a                	jns    801edb <duppage+0x130>
			panic("duppage:sys_page_map error\n");
  801eb1:	48 ba cf 47 80 00 00 	movabs $0x8047cf,%rdx
  801eb8:	00 00 00 
  801ebb:	be 51 00 00 00       	mov    $0x51,%esi
  801ec0:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  801ec7:	00 00 00 
  801eca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecf:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  801ed6:	00 00 00 
  801ed9:	ff d1                	callq  *%rcx
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
			panic("duppage:sys_page_map error\n");	
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  801edb:	e9 c1 00 00 00       	jmpq   801fa1 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  801ee0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ee3:	c1 e0 0c             	shl    $0xc,%eax
  801ee6:	89 c0                	mov    %eax,%eax
  801ee8:	48 89 c1             	mov    %rax,%rcx
  801eeb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eee:	c1 e0 0c             	shl    $0xc,%eax
  801ef1:	89 c0                	mov    %eax,%eax
  801ef3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ef6:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801efc:	48 89 c6             	mov    %rax,%rsi
  801eff:	bf 00 00 00 00       	mov    $0x0,%edi
  801f04:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  801f0b:	00 00 00 
  801f0e:	ff d0                	callq  *%rax
  801f10:	85 c0                	test   %eax,%eax
  801f12:	79 2a                	jns    801f3e <duppage+0x193>
			panic("duppage:sys_page_map error\n");
  801f14:	48 ba cf 47 80 00 00 	movabs $0x8047cf,%rdx
  801f1b:	00 00 00 
  801f1e:	be 55 00 00 00       	mov    $0x55,%esi
  801f23:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  801f2a:	00 00 00 
  801f2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f32:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  801f39:	00 00 00 
  801f3c:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  801f3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f41:	c1 e0 0c             	shl    $0xc,%eax
  801f44:	89 c0                	mov    %eax,%eax
  801f46:	48 89 c2             	mov    %rax,%rdx
  801f49:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f4c:	c1 e0 0c             	shl    $0xc,%eax
  801f4f:	89 c0                	mov    %eax,%eax
  801f51:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801f57:	48 89 d1             	mov    %rdx,%rcx
  801f5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5f:	48 89 c6             	mov    %rax,%rsi
  801f62:	bf 00 00 00 00       	mov    $0x0,%edi
  801f67:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  801f6e:	00 00 00 
  801f71:	ff d0                	callq  *%rax
  801f73:	85 c0                	test   %eax,%eax
  801f75:	79 2a                	jns    801fa1 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
  801f77:	48 ba cf 47 80 00 00 	movabs $0x8047cf,%rdx
  801f7e:	00 00 00 
  801f81:	be 57 00 00 00       	mov    $0x57,%esi
  801f86:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  801f8d:	00 00 00 
  801f90:	b8 00 00 00 00       	mov    $0x0,%eax
  801f95:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  801f9c:	00 00 00 
  801f9f:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  801fa1:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801fa6:	c9                   	leaveq 
  801fa7:	c3                   	retq   

0000000000801fa8 <new_duppage>:


static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
  801fa8:	55                   	push   %rbp
  801fa9:	48 89 e5             	mov    %rsp,%rbp
  801fac:	48 83 ec 10          	sub    $0x10,%rsp
  801fb0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fb3:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801fb6:	89 55 f4             	mov    %edx,-0xc(%rbp)
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
  801fb9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc0:	01 00 00 
  801fc3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801fc6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fca:	83 e0 02             	and    $0x2,%eax
  801fcd:	48 85 c0             	test   %rax,%rax
  801fd0:	0f 85 84 00 00 00    	jne    80205a <new_duppage+0xb2>
  801fd6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fdd:	01 00 00 
  801fe0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801fe3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe7:	25 00 08 00 00       	and    $0x800,%eax
  801fec:	48 85 c0             	test   %rax,%rax
  801fef:	75 69                	jne    80205a <new_duppage+0xb2>
  801ff1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ff5:	75 63                	jne    80205a <new_duppage+0xb2>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  801ff7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ffa:	c1 e0 0c             	shl    $0xc,%eax
  801ffd:	89 c0                	mov    %eax,%eax
  801fff:	48 89 c1             	mov    %rax,%rcx
  802002:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802005:	c1 e0 0c             	shl    $0xc,%eax
  802008:	89 c0                	mov    %eax,%eax
  80200a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80200d:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  802013:	48 89 c6             	mov    %rax,%rsi
  802016:	bf 00 00 00 00       	mov    $0x0,%edi
  80201b:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  802022:	00 00 00 
  802025:	ff d0                	callq  *%rax
  802027:	85 c0                	test   %eax,%eax
  802029:	79 2a                	jns    802055 <new_duppage+0xad>
			panic("duppage:sys_page_map error\n");
  80202b:	48 ba cf 47 80 00 00 	movabs $0x8047cf,%rdx
  802032:	00 00 00 
  802035:	be 64 00 00 00       	mov    $0x64,%esi
  80203a:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  802041:	00 00 00 
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
  802049:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  802050:	00 00 00 
  802053:	ff d1                	callq  *%rcx
static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  802055:	e9 c1 00 00 00       	jmpq   80211b <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  80205a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80205d:	c1 e0 0c             	shl    $0xc,%eax
  802060:	89 c0                	mov    %eax,%eax
  802062:	48 89 c1             	mov    %rax,%rcx
  802065:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802068:	c1 e0 0c             	shl    $0xc,%eax
  80206b:	89 c0                	mov    %eax,%eax
  80206d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802070:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802076:	48 89 c6             	mov    %rax,%rsi
  802079:	bf 00 00 00 00       	mov    $0x0,%edi
  80207e:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  802085:	00 00 00 
  802088:	ff d0                	callq  *%rax
  80208a:	85 c0                	test   %eax,%eax
  80208c:	79 2a                	jns    8020b8 <new_duppage+0x110>
			panic("duppage:sys_page_map error\n");
  80208e:	48 ba cf 47 80 00 00 	movabs $0x8047cf,%rdx
  802095:	00 00 00 
  802098:	be 68 00 00 00       	mov    $0x68,%esi
  80209d:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  8020a4:	00 00 00 
  8020a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ac:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  8020b3:	00 00 00 
  8020b6:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  8020b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020bb:	c1 e0 0c             	shl    $0xc,%eax
  8020be:	89 c0                	mov    %eax,%eax
  8020c0:	48 89 c2             	mov    %rax,%rdx
  8020c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020c6:	c1 e0 0c             	shl    $0xc,%eax
  8020c9:	89 c0                	mov    %eax,%eax
  8020cb:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8020d1:	48 89 d1             	mov    %rdx,%rcx
  8020d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d9:	48 89 c6             	mov    %rax,%rsi
  8020dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8020e1:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  8020e8:	00 00 00 
  8020eb:	ff d0                	callq  *%rax
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	79 2a                	jns    80211b <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
  8020f1:	48 ba cf 47 80 00 00 	movabs $0x8047cf,%rdx
  8020f8:	00 00 00 
  8020fb:	be 6a 00 00 00       	mov    $0x6a,%esi
  802100:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  802107:	00 00 00 
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
  80210f:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  802116:	00 00 00 
  802119:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  80211b:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802120:	c9                   	leaveq 
  802121:	c3                   	retq   

0000000000802122 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802122:	55                   	push   %rbp
  802123:	48 89 e5             	mov    %rsp,%rbp
  802126:	48 83 ec 10          	sub    $0x10,%rsp


	
	int envid;  
	//extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  80212a:	48 bf f0 1b 80 00 00 	movabs $0x801bf0,%rdi
  802131:	00 00 00 
  802134:	48 b8 22 3e 80 00 00 	movabs $0x803e22,%rax
  80213b:	00 00 00 
  80213e:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802140:	b8 07 00 00 00       	mov    $0x7,%eax
  802145:	cd 30                	int    $0x30
  802147:	89 45 f0             	mov    %eax,-0x10(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80214a:	8b 45 f0             	mov    -0x10(%rbp),%eax


	if ((envid=sys_exofork())<0)
  80214d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802150:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802154:	79 2a                	jns    802180 <fork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  802156:	48 ba eb 47 80 00 00 	movabs $0x8047eb,%rdx
  80215d:	00 00 00 
  802160:	be 90 00 00 00       	mov    $0x90,%esi
  802165:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  80216c:	00 00 00 
  80216f:	b8 00 00 00 00       	mov    $0x0,%eax
  802174:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  80217b:	00 00 00 
  80217e:	ff d1                	callq  *%rcx

	if(envid>0){
  802180:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802184:	0f 8e e1 01 00 00    	jle    80236b <fork+0x249>
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  80218a:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  802191:	00 
  802192:	e9 d4 00 00 00       	jmpq   80226b <fork+0x149>
		{
			

               if(!(uvpml4e[VPML4E(i)]))
  802197:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80219b:	48 c1 e8 27          	shr    $0x27,%rax
  80219f:	48 89 c2             	mov    %rax,%rdx
  8021a2:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8021a9:	01 00 00 
  8021ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b0:	48 85 c0             	test   %rax,%rax
  8021b3:	75 05                	jne    8021ba <fork+0x98>
		 continue;
  8021b5:	e9 a9 00 00 00       	jmpq   802263 <fork+0x141>
		
		if(!(uvpde[VPDPE(i)]))
  8021ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021be:	48 c1 e8 1e          	shr    $0x1e,%rax
  8021c2:	48 89 c2             	mov    %rax,%rdx
  8021c5:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021cc:	01 00 00 
  8021cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d3:	48 85 c0             	test   %rax,%rax
  8021d6:	75 05                	jne    8021dd <fork+0xbb>
	          continue;
  8021d8:	e9 86 00 00 00       	jmpq   802263 <fork+0x141>
	

			if(!(uvpd[VPD(i)] & PTE_P))
  8021dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021e1:	48 c1 e8 15          	shr    $0x15,%rax
  8021e5:	48 89 c2             	mov    %rax,%rdx
  8021e8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021ef:	01 00 00 
  8021f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f6:	83 e0 01             	and    $0x1,%eax
  8021f9:	48 85 c0             	test   %rax,%rax
  8021fc:	75 02                	jne    802200 <fork+0xde>
				continue;
  8021fe:	eb 63                	jmp    802263 <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_P))
  802200:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802204:	48 c1 e8 0c          	shr    $0xc,%rax
  802208:	48 89 c2             	mov    %rax,%rdx
  80220b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802212:	01 00 00 
  802215:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802219:	83 e0 01             	and    $0x1,%eax
  80221c:	48 85 c0             	test   %rax,%rax
  80221f:	75 02                	jne    802223 <fork+0x101>
				continue; 
  802221:	eb 40                	jmp    802263 <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_U))
  802223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802227:	48 c1 e8 0c          	shr    $0xc,%rax
  80222b:	48 89 c2             	mov    %rax,%rdx
  80222e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802235:	01 00 00 
  802238:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223c:	83 e0 04             	and    $0x4,%eax
  80223f:	48 85 c0             	test   %rax,%rax
  802242:	75 02                	jne    802246 <fork+0x124>
				continue; 
  802244:	eb 1d                	jmp    802263 <fork+0x141>
			duppage(envid, VPN(i)); 
  802246:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80224a:	48 c1 e8 0c          	shr    $0xc,%rax
  80224e:	89 c2                	mov    %eax,%edx
  802250:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802253:	89 d6                	mov    %edx,%esi
  802255:	89 c7                	mov    %eax,%edi
  802257:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  80225e:	00 00 00 
  802261:	ff d0                	callq  *%rax

	if(envid>0){
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  802263:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  80226a:	00 
  80226b:	b8 ff cf 7f ef       	mov    $0xef7fcfff,%eax
  802270:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802274:	0f 86 1d ff ff ff    	jbe    802197 <fork+0x75>
			if(!(uvpt[VPN(i)] & PTE_U))
				continue; 
			duppage(envid, VPN(i)); 
		}

		if (sys_page_alloc(envid,(void*)UXSTACKTOP-PGSIZE, PTE_U|PTE_W|PTE_P)<0)
  80227a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80227d:	ba 07 00 00 00       	mov    $0x7,%edx
  802282:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802287:	89 c7                	mov    %eax,%edi
  802289:	48 b8 55 18 80 00 00 	movabs $0x801855,%rax
  802290:	00 00 00 
  802293:	ff d0                	callq  *%rax
  802295:	85 c0                	test   %eax,%eax
  802297:	79 2a                	jns    8022c3 <fork+0x1a1>
			panic("fork: sys_page_alloc error!\n");
  802299:	48 ba 05 48 80 00 00 	movabs $0x804805,%rdx
  8022a0:	00 00 00 
  8022a3:	be ab 00 00 00       	mov    $0xab,%esi
  8022a8:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  8022af:	00 00 00 
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b7:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  8022be:	00 00 00 
  8022c1:	ff d1                	callq  *%rcx

		duppage(envid, VPN(USTACKTOP-PGSIZE));
  8022c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022c6:	be fd f7 0e 00       	mov    $0xef7fd,%esi
  8022cb:	89 c7                	mov    %eax,%edi
  8022cd:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  8022d4:	00 00 00 
  8022d7:	ff d0                	callq  *%rax
		extern void _pgfault_upcall(void);
		if (sys_env_set_pgfault_upcall(envid, _pgfault_upcall)<0)
  8022d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022dc:	48 be c2 3e 80 00 00 	movabs $0x803ec2,%rsi
  8022e3:	00 00 00 
  8022e6:	89 c7                	mov    %eax,%edi
  8022e8:	48 b8 df 19 80 00 00 	movabs $0x8019df,%rax
  8022ef:	00 00 00 
  8022f2:	ff d0                	callq  *%rax
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	79 2a                	jns    802322 <fork+0x200>
			panic("fork: sys_env_set_status error!\n");
  8022f8:	48 ba 28 48 80 00 00 	movabs $0x804828,%rdx
  8022ff:	00 00 00 
  802302:	be b0 00 00 00       	mov    $0xb0,%esi
  802307:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  80230e:	00 00 00 
  802311:	b8 00 00 00 00       	mov    $0x0,%eax
  802316:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  80231d:	00 00 00 
  802320:	ff d1                	callq  *%rcx
		if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  802322:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802325:	be 02 00 00 00       	mov    $0x2,%esi
  80232a:	89 c7                	mov    %eax,%edi
  80232c:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  802333:	00 00 00 
  802336:	ff d0                	callq  *%rax
  802338:	85 c0                	test   %eax,%eax
  80233a:	79 2a                	jns    802366 <fork+0x244>
			panic("fork: sys_env_set_status error!\n");
  80233c:	48 ba 28 48 80 00 00 	movabs $0x804828,%rdx
  802343:	00 00 00 
  802346:	be b2 00 00 00       	mov    $0xb2,%esi
  80234b:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  802352:	00 00 00 
  802355:	b8 00 00 00 00       	mov    $0x0,%eax
  80235a:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  802361:	00 00 00 
  802364:	ff d1                	callq  *%rcx

		return envid;
  802366:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802369:	eb 39                	jmp    8023a4 <fork+0x282>
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80236b:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  802372:	00 00 00 
  802375:	ff d0                	callq  *%rax
  802377:	25 ff 03 00 00       	and    $0x3ff,%eax
  80237c:	48 98                	cltq   
  80237e:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  802385:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80238c:	00 00 00 
  80238f:	48 01 c2             	add    %rax,%rdx
  802392:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802399:	00 00 00 
  80239c:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80239f:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  8023a4:	c9                   	leaveq 
  8023a5:	c3                   	retq   

00000000008023a6 <sfork>:

// Challenge!
envid_t
sfork(void)
{
  8023a6:	55                   	push   %rbp
  8023a7:	48 89 e5             	mov    %rsp,%rbp
  8023aa:	48 83 ec 20          	sub    $0x20,%rsp

	
	int envid;  
	extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  8023ae:	48 bf f0 1b 80 00 00 	movabs $0x801bf0,%rdi
  8023b5:	00 00 00 
  8023b8:	48 b8 22 3e 80 00 00 	movabs $0x803e22,%rax
  8023bf:	00 00 00 
  8023c2:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8023c4:	b8 07 00 00 00       	mov    $0x7,%eax
  8023c9:	cd 30                	int    $0x30
  8023cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8023ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
	

	if ((envid=sys_exofork())<0)
  8023d1:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8023d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8023d8:	79 2a                	jns    802404 <sfork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  8023da:	48 ba eb 47 80 00 00 	movabs $0x8047eb,%rdx
  8023e1:	00 00 00 
  8023e4:	be ca 00 00 00       	mov    $0xca,%esi
  8023e9:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  8023f0:	00 00 00 
  8023f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f8:	48 b9 0e 3d 80 00 00 	movabs $0x803d0e,%rcx
  8023ff:	00 00 00 
  802402:	ff d1                	callq  *%rcx

	if(envid>0){
  802404:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802408:	0f 8e e5 00 00 00    	jle    8024f3 <sfork+0x14d>
		
		
		uintptr_t i;
		int flag=1;
  80240e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)

		for (i = 0; i < (uintptr_t)end/*USTACKTOP-PGSIZE*/; i += PGSIZE) ;
  802415:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80241c:	00 
  80241d:	eb 08                	jmp    802427 <sfork+0x81>
  80241f:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  802426:	00 
  802427:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  80242e:	00 00 00 
  802431:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802435:	72 e8                	jb     80241f <sfork+0x79>
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
  802437:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80243e:	00 
    for (;i>=0; i -= PGSIZE) 
		{
			cprintf("23\n");
  80243f:	48 bf 49 48 80 00 00 	movabs $0x804849,%rdi
  802446:	00 00 00 
  802449:	b8 00 00 00 00       	mov    $0x0,%eax
  80244e:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  802455:	00 00 00 
  802458:	ff d2                	callq  *%rdx
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
  80245a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80245e:	48 c1 e8 15          	shr    $0x15,%rax
  802462:	48 89 c2             	mov    %rax,%rdx
  802465:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80246c:	01 00 00 
  80246f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802473:	83 e0 01             	and    $0x1,%eax
  802476:	48 85 c0             	test   %rax,%rax
  802479:	74 42                	je     8024bd <sfork+0x117>
  80247b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80247f:	48 c1 e8 0c          	shr    $0xc,%rax
  802483:	48 89 c2             	mov    %rax,%rdx
  802486:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80248d:	01 00 00 
  802490:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802494:	83 e0 01             	and    $0x1,%eax
  802497:	48 85 c0             	test   %rax,%rax
  80249a:	74 21                	je     8024bd <sfork+0x117>
  80249c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024a0:	48 c1 e8 0c          	shr    $0xc,%rax
  8024a4:	48 89 c2             	mov    %rax,%rdx
  8024a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024ae:	01 00 00 
  8024b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024b5:	83 e0 04             	and    $0x4,%eax
  8024b8:	48 85 c0             	test   %rax,%rax
  8024bb:	75 09                	jne    8024c6 <sfork+0x120>
				flag=0;
  8024bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8024c4:	eb 20                	jmp    8024e6 <sfork+0x140>
			else
				new_duppage(envid, VPN(i),flag); 
  8024c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024ca:	48 c1 e8 0c          	shr    $0xc,%rax
  8024ce:	89 c1                	mov    %eax,%ecx
  8024d0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8024d3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8024d6:	89 ce                	mov    %ecx,%esi
  8024d8:	89 c7                	mov    %eax,%edi
  8024da:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  8024e1:	00 00 00 
  8024e4:	ff d0                	callq  *%rax
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
    for (;i>=0; i -= PGSIZE) 
  8024e6:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8024ed:	00 
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
				flag=0;
			else
				new_duppage(envid, VPN(i),flag); 

		}
  8024ee:	e9 4c ff ff ff       	jmpq   80243f <sfork+0x99>

		return envid;
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8024f3:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  8024fa:	00 00 00 
  8024fd:	ff d0                	callq  *%rax
  8024ff:	25 ff 03 00 00       	and    $0x3ff,%eax
  802504:	48 98                	cltq   
  802506:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  80250d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802514:	00 00 00 
  802517:	48 01 c2             	add    %rax,%rdx
  80251a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802521:	00 00 00 
  802524:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802527:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  80252c:	c9                   	leaveq 
  80252d:	c3                   	retq   

000000000080252e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80252e:	55                   	push   %rbp
  80252f:	48 89 e5             	mov    %rsp,%rbp
  802532:	48 83 ec 08          	sub    $0x8,%rsp
  802536:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80253a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80253e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802545:	ff ff ff 
  802548:	48 01 d0             	add    %rdx,%rax
  80254b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80254f:	c9                   	leaveq 
  802550:	c3                   	retq   

0000000000802551 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802551:	55                   	push   %rbp
  802552:	48 89 e5             	mov    %rsp,%rbp
  802555:	48 83 ec 08          	sub    $0x8,%rsp
  802559:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80255d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802561:	48 89 c7             	mov    %rax,%rdi
  802564:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  80256b:	00 00 00 
  80256e:	ff d0                	callq  *%rax
  802570:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802576:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80257a:	c9                   	leaveq 
  80257b:	c3                   	retq   

000000000080257c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80257c:	55                   	push   %rbp
  80257d:	48 89 e5             	mov    %rsp,%rbp
  802580:	48 83 ec 18          	sub    $0x18,%rsp
  802584:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802588:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80258f:	eb 6b                	jmp    8025fc <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802591:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802594:	48 98                	cltq   
  802596:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80259c:	48 c1 e0 0c          	shl    $0xc,%rax
  8025a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8025a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025a8:	48 c1 e8 15          	shr    $0x15,%rax
  8025ac:	48 89 c2             	mov    %rax,%rdx
  8025af:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025b6:	01 00 00 
  8025b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025bd:	83 e0 01             	and    $0x1,%eax
  8025c0:	48 85 c0             	test   %rax,%rax
  8025c3:	74 21                	je     8025e6 <fd_alloc+0x6a>
  8025c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c9:	48 c1 e8 0c          	shr    $0xc,%rax
  8025cd:	48 89 c2             	mov    %rax,%rdx
  8025d0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025d7:	01 00 00 
  8025da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025de:	83 e0 01             	and    $0x1,%eax
  8025e1:	48 85 c0             	test   %rax,%rax
  8025e4:	75 12                	jne    8025f8 <fd_alloc+0x7c>
			*fd_store = fd;
  8025e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025ee:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f6:	eb 1a                	jmp    802612 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025f8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025fc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802600:	7e 8f                	jle    802591 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802606:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80260d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802612:	c9                   	leaveq 
  802613:	c3                   	retq   

0000000000802614 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802614:	55                   	push   %rbp
  802615:	48 89 e5             	mov    %rsp,%rbp
  802618:	48 83 ec 20          	sub    $0x20,%rsp
  80261c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80261f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802623:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802627:	78 06                	js     80262f <fd_lookup+0x1b>
  802629:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80262d:	7e 07                	jle    802636 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80262f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802634:	eb 6c                	jmp    8026a2 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802636:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802639:	48 98                	cltq   
  80263b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802641:	48 c1 e0 0c          	shl    $0xc,%rax
  802645:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802649:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80264d:	48 c1 e8 15          	shr    $0x15,%rax
  802651:	48 89 c2             	mov    %rax,%rdx
  802654:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80265b:	01 00 00 
  80265e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802662:	83 e0 01             	and    $0x1,%eax
  802665:	48 85 c0             	test   %rax,%rax
  802668:	74 21                	je     80268b <fd_lookup+0x77>
  80266a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80266e:	48 c1 e8 0c          	shr    $0xc,%rax
  802672:	48 89 c2             	mov    %rax,%rdx
  802675:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80267c:	01 00 00 
  80267f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802683:	83 e0 01             	and    $0x1,%eax
  802686:	48 85 c0             	test   %rax,%rax
  802689:	75 07                	jne    802692 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80268b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802690:	eb 10                	jmp    8026a2 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802692:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802696:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80269a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80269d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a2:	c9                   	leaveq 
  8026a3:	c3                   	retq   

00000000008026a4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8026a4:	55                   	push   %rbp
  8026a5:	48 89 e5             	mov    %rsp,%rbp
  8026a8:	48 83 ec 30          	sub    $0x30,%rsp
  8026ac:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026b0:	89 f0                	mov    %esi,%eax
  8026b2:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8026b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026b9:	48 89 c7             	mov    %rax,%rdi
  8026bc:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  8026c3:	00 00 00 
  8026c6:	ff d0                	callq  *%rax
  8026c8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026cc:	48 89 d6             	mov    %rdx,%rsi
  8026cf:	89 c7                	mov    %eax,%edi
  8026d1:	48 b8 14 26 80 00 00 	movabs $0x802614,%rax
  8026d8:	00 00 00 
  8026db:	ff d0                	callq  *%rax
  8026dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026e4:	78 0a                	js     8026f0 <fd_close+0x4c>
	    || fd != fd2)
  8026e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ea:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8026ee:	74 12                	je     802702 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8026f0:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8026f4:	74 05                	je     8026fb <fd_close+0x57>
  8026f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f9:	eb 05                	jmp    802700 <fd_close+0x5c>
  8026fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802700:	eb 69                	jmp    80276b <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802702:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802706:	8b 00                	mov    (%rax),%eax
  802708:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80270c:	48 89 d6             	mov    %rdx,%rsi
  80270f:	89 c7                	mov    %eax,%edi
  802711:	48 b8 6d 27 80 00 00 	movabs $0x80276d,%rax
  802718:	00 00 00 
  80271b:	ff d0                	callq  *%rax
  80271d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802720:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802724:	78 2a                	js     802750 <fd_close+0xac>
		if (dev->dev_close)
  802726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80272a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80272e:	48 85 c0             	test   %rax,%rax
  802731:	74 16                	je     802749 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802737:	48 8b 40 20          	mov    0x20(%rax),%rax
  80273b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80273f:	48 89 d7             	mov    %rdx,%rdi
  802742:	ff d0                	callq  *%rax
  802744:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802747:	eb 07                	jmp    802750 <fd_close+0xac>
		else
			r = 0;
  802749:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802750:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802754:	48 89 c6             	mov    %rax,%rsi
  802757:	bf 00 00 00 00       	mov    $0x0,%edi
  80275c:	48 b8 00 19 80 00 00 	movabs $0x801900,%rax
  802763:	00 00 00 
  802766:	ff d0                	callq  *%rax
	return r;
  802768:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80276b:	c9                   	leaveq 
  80276c:	c3                   	retq   

000000000080276d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80276d:	55                   	push   %rbp
  80276e:	48 89 e5             	mov    %rsp,%rbp
  802771:	48 83 ec 20          	sub    $0x20,%rsp
  802775:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802778:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80277c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802783:	eb 41                	jmp    8027c6 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802785:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80278c:	00 00 00 
  80278f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802792:	48 63 d2             	movslq %edx,%rdx
  802795:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802799:	8b 00                	mov    (%rax),%eax
  80279b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80279e:	75 22                	jne    8027c2 <dev_lookup+0x55>
			*dev = devtab[i];
  8027a0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8027a7:	00 00 00 
  8027aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027ad:	48 63 d2             	movslq %edx,%rdx
  8027b0:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8027b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027b8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8027bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c0:	eb 60                	jmp    802822 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8027c2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027c6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8027cd:	00 00 00 
  8027d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027d3:	48 63 d2             	movslq %edx,%rdx
  8027d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027da:	48 85 c0             	test   %rax,%rax
  8027dd:	75 a6                	jne    802785 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8027df:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027e6:	00 00 00 
  8027e9:	48 8b 00             	mov    (%rax),%rax
  8027ec:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027f2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8027f5:	89 c6                	mov    %eax,%esi
  8027f7:	48 bf 50 48 80 00 00 	movabs $0x804850,%rdi
  8027fe:	00 00 00 
  802801:	b8 00 00 00 00       	mov    $0x0,%eax
  802806:	48 b9 30 03 80 00 00 	movabs $0x800330,%rcx
  80280d:	00 00 00 
  802810:	ff d1                	callq  *%rcx
	*dev = 0;
  802812:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802816:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80281d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802822:	c9                   	leaveq 
  802823:	c3                   	retq   

0000000000802824 <close>:

int
close(int fdnum)
{
  802824:	55                   	push   %rbp
  802825:	48 89 e5             	mov    %rsp,%rbp
  802828:	48 83 ec 20          	sub    $0x20,%rsp
  80282c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80282f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802833:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802836:	48 89 d6             	mov    %rdx,%rsi
  802839:	89 c7                	mov    %eax,%edi
  80283b:	48 b8 14 26 80 00 00 	movabs $0x802614,%rax
  802842:	00 00 00 
  802845:	ff d0                	callq  *%rax
  802847:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284e:	79 05                	jns    802855 <close+0x31>
		return r;
  802850:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802853:	eb 18                	jmp    80286d <close+0x49>
	else
		return fd_close(fd, 1);
  802855:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802859:	be 01 00 00 00       	mov    $0x1,%esi
  80285e:	48 89 c7             	mov    %rax,%rdi
  802861:	48 b8 a4 26 80 00 00 	movabs $0x8026a4,%rax
  802868:	00 00 00 
  80286b:	ff d0                	callq  *%rax
}
  80286d:	c9                   	leaveq 
  80286e:	c3                   	retq   

000000000080286f <close_all>:

void
close_all(void)
{
  80286f:	55                   	push   %rbp
  802870:	48 89 e5             	mov    %rsp,%rbp
  802873:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802877:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80287e:	eb 15                	jmp    802895 <close_all+0x26>
		close(i);
  802880:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802883:	89 c7                	mov    %eax,%edi
  802885:	48 b8 24 28 80 00 00 	movabs $0x802824,%rax
  80288c:	00 00 00 
  80288f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802891:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802895:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802899:	7e e5                	jle    802880 <close_all+0x11>
		close(i);
}
  80289b:	c9                   	leaveq 
  80289c:	c3                   	retq   

000000000080289d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80289d:	55                   	push   %rbp
  80289e:	48 89 e5             	mov    %rsp,%rbp
  8028a1:	48 83 ec 40          	sub    $0x40,%rsp
  8028a5:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8028a8:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8028ab:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8028af:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8028b2:	48 89 d6             	mov    %rdx,%rsi
  8028b5:	89 c7                	mov    %eax,%edi
  8028b7:	48 b8 14 26 80 00 00 	movabs $0x802614,%rax
  8028be:	00 00 00 
  8028c1:	ff d0                	callq  *%rax
  8028c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ca:	79 08                	jns    8028d4 <dup+0x37>
		return r;
  8028cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cf:	e9 70 01 00 00       	jmpq   802a44 <dup+0x1a7>
	close(newfdnum);
  8028d4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028d7:	89 c7                	mov    %eax,%edi
  8028d9:	48 b8 24 28 80 00 00 	movabs $0x802824,%rax
  8028e0:	00 00 00 
  8028e3:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8028e5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028e8:	48 98                	cltq   
  8028ea:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028f0:	48 c1 e0 0c          	shl    $0xc,%rax
  8028f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8028f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028fc:	48 89 c7             	mov    %rax,%rdi
  8028ff:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  802906:	00 00 00 
  802909:	ff d0                	callq  *%rax
  80290b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80290f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802913:	48 89 c7             	mov    %rax,%rdi
  802916:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  80291d:	00 00 00 
  802920:	ff d0                	callq  *%rax
  802922:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802926:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292a:	48 c1 e8 15          	shr    $0x15,%rax
  80292e:	48 89 c2             	mov    %rax,%rdx
  802931:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802938:	01 00 00 
  80293b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80293f:	83 e0 01             	and    $0x1,%eax
  802942:	48 85 c0             	test   %rax,%rax
  802945:	74 73                	je     8029ba <dup+0x11d>
  802947:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294b:	48 c1 e8 0c          	shr    $0xc,%rax
  80294f:	48 89 c2             	mov    %rax,%rdx
  802952:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802959:	01 00 00 
  80295c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802960:	83 e0 01             	and    $0x1,%eax
  802963:	48 85 c0             	test   %rax,%rax
  802966:	74 52                	je     8029ba <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802968:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296c:	48 c1 e8 0c          	shr    $0xc,%rax
  802970:	48 89 c2             	mov    %rax,%rdx
  802973:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80297a:	01 00 00 
  80297d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802981:	25 07 0e 00 00       	and    $0xe07,%eax
  802986:	89 c1                	mov    %eax,%ecx
  802988:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80298c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802990:	41 89 c8             	mov    %ecx,%r8d
  802993:	48 89 d1             	mov    %rdx,%rcx
  802996:	ba 00 00 00 00       	mov    $0x0,%edx
  80299b:	48 89 c6             	mov    %rax,%rsi
  80299e:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a3:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  8029aa:	00 00 00 
  8029ad:	ff d0                	callq  *%rax
  8029af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b6:	79 02                	jns    8029ba <dup+0x11d>
			goto err;
  8029b8:	eb 57                	jmp    802a11 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8029ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029be:	48 c1 e8 0c          	shr    $0xc,%rax
  8029c2:	48 89 c2             	mov    %rax,%rdx
  8029c5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029cc:	01 00 00 
  8029cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029d3:	25 07 0e 00 00       	and    $0xe07,%eax
  8029d8:	89 c1                	mov    %eax,%ecx
  8029da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029e2:	41 89 c8             	mov    %ecx,%r8d
  8029e5:	48 89 d1             	mov    %rdx,%rcx
  8029e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ed:	48 89 c6             	mov    %rax,%rsi
  8029f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8029f5:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  8029fc:	00 00 00 
  8029ff:	ff d0                	callq  *%rax
  802a01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a08:	79 02                	jns    802a0c <dup+0x16f>
		goto err;
  802a0a:	eb 05                	jmp    802a11 <dup+0x174>

	return newfdnum;
  802a0c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a0f:	eb 33                	jmp    802a44 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802a11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a15:	48 89 c6             	mov    %rax,%rsi
  802a18:	bf 00 00 00 00       	mov    $0x0,%edi
  802a1d:	48 b8 00 19 80 00 00 	movabs $0x801900,%rax
  802a24:	00 00 00 
  802a27:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802a29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a2d:	48 89 c6             	mov    %rax,%rsi
  802a30:	bf 00 00 00 00       	mov    $0x0,%edi
  802a35:	48 b8 00 19 80 00 00 	movabs $0x801900,%rax
  802a3c:	00 00 00 
  802a3f:	ff d0                	callq  *%rax
	return r;
  802a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a44:	c9                   	leaveq 
  802a45:	c3                   	retq   

0000000000802a46 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802a46:	55                   	push   %rbp
  802a47:	48 89 e5             	mov    %rsp,%rbp
  802a4a:	48 83 ec 40          	sub    $0x40,%rsp
  802a4e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a51:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a55:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a59:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a5d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a60:	48 89 d6             	mov    %rdx,%rsi
  802a63:	89 c7                	mov    %eax,%edi
  802a65:	48 b8 14 26 80 00 00 	movabs $0x802614,%rax
  802a6c:	00 00 00 
  802a6f:	ff d0                	callq  *%rax
  802a71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a78:	78 24                	js     802a9e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a7e:	8b 00                	mov    (%rax),%eax
  802a80:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a84:	48 89 d6             	mov    %rdx,%rsi
  802a87:	89 c7                	mov    %eax,%edi
  802a89:	48 b8 6d 27 80 00 00 	movabs $0x80276d,%rax
  802a90:	00 00 00 
  802a93:	ff d0                	callq  *%rax
  802a95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a9c:	79 05                	jns    802aa3 <read+0x5d>
		return r;
  802a9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa1:	eb 76                	jmp    802b19 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802aa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa7:	8b 40 08             	mov    0x8(%rax),%eax
  802aaa:	83 e0 03             	and    $0x3,%eax
  802aad:	83 f8 01             	cmp    $0x1,%eax
  802ab0:	75 3a                	jne    802aec <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802ab2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ab9:	00 00 00 
  802abc:	48 8b 00             	mov    (%rax),%rax
  802abf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ac5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ac8:	89 c6                	mov    %eax,%esi
  802aca:	48 bf 6f 48 80 00 00 	movabs $0x80486f,%rdi
  802ad1:	00 00 00 
  802ad4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad9:	48 b9 30 03 80 00 00 	movabs $0x800330,%rcx
  802ae0:	00 00 00 
  802ae3:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ae5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aea:	eb 2d                	jmp    802b19 <read+0xd3>
	}
	if (!dev->dev_read)
  802aec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af0:	48 8b 40 10          	mov    0x10(%rax),%rax
  802af4:	48 85 c0             	test   %rax,%rax
  802af7:	75 07                	jne    802b00 <read+0xba>
		return -E_NOT_SUPP;
  802af9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802afe:	eb 19                	jmp    802b19 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802b00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b04:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b08:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b0c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b10:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b14:	48 89 cf             	mov    %rcx,%rdi
  802b17:	ff d0                	callq  *%rax
}
  802b19:	c9                   	leaveq 
  802b1a:	c3                   	retq   

0000000000802b1b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b1b:	55                   	push   %rbp
  802b1c:	48 89 e5             	mov    %rsp,%rbp
  802b1f:	48 83 ec 30          	sub    $0x30,%rsp
  802b23:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b26:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b2a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b35:	eb 49                	jmp    802b80 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802b37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3a:	48 98                	cltq   
  802b3c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b40:	48 29 c2             	sub    %rax,%rdx
  802b43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b46:	48 63 c8             	movslq %eax,%rcx
  802b49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b4d:	48 01 c1             	add    %rax,%rcx
  802b50:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b53:	48 89 ce             	mov    %rcx,%rsi
  802b56:	89 c7                	mov    %eax,%edi
  802b58:	48 b8 46 2a 80 00 00 	movabs $0x802a46,%rax
  802b5f:	00 00 00 
  802b62:	ff d0                	callq  *%rax
  802b64:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b67:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b6b:	79 05                	jns    802b72 <readn+0x57>
			return m;
  802b6d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b70:	eb 1c                	jmp    802b8e <readn+0x73>
		if (m == 0)
  802b72:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b76:	75 02                	jne    802b7a <readn+0x5f>
			break;
  802b78:	eb 11                	jmp    802b8b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b7d:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b83:	48 98                	cltq   
  802b85:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b89:	72 ac                	jb     802b37 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802b8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b8e:	c9                   	leaveq 
  802b8f:	c3                   	retq   

0000000000802b90 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b90:	55                   	push   %rbp
  802b91:	48 89 e5             	mov    %rsp,%rbp
  802b94:	48 83 ec 40          	sub    $0x40,%rsp
  802b98:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b9b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b9f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ba3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ba7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802baa:	48 89 d6             	mov    %rdx,%rsi
  802bad:	89 c7                	mov    %eax,%edi
  802baf:	48 b8 14 26 80 00 00 	movabs $0x802614,%rax
  802bb6:	00 00 00 
  802bb9:	ff d0                	callq  *%rax
  802bbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc2:	78 24                	js     802be8 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc8:	8b 00                	mov    (%rax),%eax
  802bca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bce:	48 89 d6             	mov    %rdx,%rsi
  802bd1:	89 c7                	mov    %eax,%edi
  802bd3:	48 b8 6d 27 80 00 00 	movabs $0x80276d,%rax
  802bda:	00 00 00 
  802bdd:	ff d0                	callq  *%rax
  802bdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be6:	79 05                	jns    802bed <write+0x5d>
		return r;
  802be8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802beb:	eb 75                	jmp    802c62 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf1:	8b 40 08             	mov    0x8(%rax),%eax
  802bf4:	83 e0 03             	and    $0x3,%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	75 3a                	jne    802c35 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802bfb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c02:	00 00 00 
  802c05:	48 8b 00             	mov    (%rax),%rax
  802c08:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c0e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c11:	89 c6                	mov    %eax,%esi
  802c13:	48 bf 8b 48 80 00 00 	movabs $0x80488b,%rdi
  802c1a:	00 00 00 
  802c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c22:	48 b9 30 03 80 00 00 	movabs $0x800330,%rcx
  802c29:	00 00 00 
  802c2c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c33:	eb 2d                	jmp    802c62 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802c35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c39:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c3d:	48 85 c0             	test   %rax,%rax
  802c40:	75 07                	jne    802c49 <write+0xb9>
		return -E_NOT_SUPP;
  802c42:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c47:	eb 19                	jmp    802c62 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802c49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c4d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c51:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c55:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c59:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c5d:	48 89 cf             	mov    %rcx,%rdi
  802c60:	ff d0                	callq  *%rax
}
  802c62:	c9                   	leaveq 
  802c63:	c3                   	retq   

0000000000802c64 <seek>:

int
seek(int fdnum, off_t offset)
{
  802c64:	55                   	push   %rbp
  802c65:	48 89 e5             	mov    %rsp,%rbp
  802c68:	48 83 ec 18          	sub    $0x18,%rsp
  802c6c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c6f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c72:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c76:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c79:	48 89 d6             	mov    %rdx,%rsi
  802c7c:	89 c7                	mov    %eax,%edi
  802c7e:	48 b8 14 26 80 00 00 	movabs $0x802614,%rax
  802c85:	00 00 00 
  802c88:	ff d0                	callq  *%rax
  802c8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c91:	79 05                	jns    802c98 <seek+0x34>
		return r;
  802c93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c96:	eb 0f                	jmp    802ca7 <seek+0x43>
	fd->fd_offset = offset;
  802c98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c9c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c9f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ca7:	c9                   	leaveq 
  802ca8:	c3                   	retq   

0000000000802ca9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802ca9:	55                   	push   %rbp
  802caa:	48 89 e5             	mov    %rsp,%rbp
  802cad:	48 83 ec 30          	sub    $0x30,%rsp
  802cb1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cb4:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cb7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cbb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cbe:	48 89 d6             	mov    %rdx,%rsi
  802cc1:	89 c7                	mov    %eax,%edi
  802cc3:	48 b8 14 26 80 00 00 	movabs $0x802614,%rax
  802cca:	00 00 00 
  802ccd:	ff d0                	callq  *%rax
  802ccf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cd6:	78 24                	js     802cfc <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cdc:	8b 00                	mov    (%rax),%eax
  802cde:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ce2:	48 89 d6             	mov    %rdx,%rsi
  802ce5:	89 c7                	mov    %eax,%edi
  802ce7:	48 b8 6d 27 80 00 00 	movabs $0x80276d,%rax
  802cee:	00 00 00 
  802cf1:	ff d0                	callq  *%rax
  802cf3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cfa:	79 05                	jns    802d01 <ftruncate+0x58>
		return r;
  802cfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cff:	eb 72                	jmp    802d73 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d05:	8b 40 08             	mov    0x8(%rax),%eax
  802d08:	83 e0 03             	and    $0x3,%eax
  802d0b:	85 c0                	test   %eax,%eax
  802d0d:	75 3a                	jne    802d49 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d0f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d16:	00 00 00 
  802d19:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d1c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d22:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d25:	89 c6                	mov    %eax,%esi
  802d27:	48 bf a8 48 80 00 00 	movabs $0x8048a8,%rdi
  802d2e:	00 00 00 
  802d31:	b8 00 00 00 00       	mov    $0x0,%eax
  802d36:	48 b9 30 03 80 00 00 	movabs $0x800330,%rcx
  802d3d:	00 00 00 
  802d40:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802d42:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d47:	eb 2a                	jmp    802d73 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802d49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d51:	48 85 c0             	test   %rax,%rax
  802d54:	75 07                	jne    802d5d <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d56:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d5b:	eb 16                	jmp    802d73 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d61:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d65:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d69:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802d6c:	89 ce                	mov    %ecx,%esi
  802d6e:	48 89 d7             	mov    %rdx,%rdi
  802d71:	ff d0                	callq  *%rax
}
  802d73:	c9                   	leaveq 
  802d74:	c3                   	retq   

0000000000802d75 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d75:	55                   	push   %rbp
  802d76:	48 89 e5             	mov    %rsp,%rbp
  802d79:	48 83 ec 30          	sub    $0x30,%rsp
  802d7d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d80:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d84:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d88:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d8b:	48 89 d6             	mov    %rdx,%rsi
  802d8e:	89 c7                	mov    %eax,%edi
  802d90:	48 b8 14 26 80 00 00 	movabs $0x802614,%rax
  802d97:	00 00 00 
  802d9a:	ff d0                	callq  *%rax
  802d9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da3:	78 24                	js     802dc9 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802da5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da9:	8b 00                	mov    (%rax),%eax
  802dab:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802daf:	48 89 d6             	mov    %rdx,%rsi
  802db2:	89 c7                	mov    %eax,%edi
  802db4:	48 b8 6d 27 80 00 00 	movabs $0x80276d,%rax
  802dbb:	00 00 00 
  802dbe:	ff d0                	callq  *%rax
  802dc0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc7:	79 05                	jns    802dce <fstat+0x59>
		return r;
  802dc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcc:	eb 5e                	jmp    802e2c <fstat+0xb7>
	if (!dev->dev_stat)
  802dce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd2:	48 8b 40 28          	mov    0x28(%rax),%rax
  802dd6:	48 85 c0             	test   %rax,%rax
  802dd9:	75 07                	jne    802de2 <fstat+0x6d>
		return -E_NOT_SUPP;
  802ddb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802de0:	eb 4a                	jmp    802e2c <fstat+0xb7>
	stat->st_name[0] = 0;
  802de2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802de6:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802de9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ded:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802df4:	00 00 00 
	stat->st_isdir = 0;
  802df7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dfb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e02:	00 00 00 
	stat->st_dev = dev;
  802e05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e09:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e0d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e18:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e1c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e20:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e24:	48 89 ce             	mov    %rcx,%rsi
  802e27:	48 89 d7             	mov    %rdx,%rdi
  802e2a:	ff d0                	callq  *%rax
}
  802e2c:	c9                   	leaveq 
  802e2d:	c3                   	retq   

0000000000802e2e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e2e:	55                   	push   %rbp
  802e2f:	48 89 e5             	mov    %rsp,%rbp
  802e32:	48 83 ec 20          	sub    $0x20,%rsp
  802e36:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e3a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e42:	be 00 00 00 00       	mov    $0x0,%esi
  802e47:	48 89 c7             	mov    %rax,%rdi
  802e4a:	48 b8 1c 2f 80 00 00 	movabs $0x802f1c,%rax
  802e51:	00 00 00 
  802e54:	ff d0                	callq  *%rax
  802e56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e5d:	79 05                	jns    802e64 <stat+0x36>
		return fd;
  802e5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e62:	eb 2f                	jmp    802e93 <stat+0x65>
	r = fstat(fd, stat);
  802e64:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6b:	48 89 d6             	mov    %rdx,%rsi
  802e6e:	89 c7                	mov    %eax,%edi
  802e70:	48 b8 75 2d 80 00 00 	movabs $0x802d75,%rax
  802e77:	00 00 00 
  802e7a:	ff d0                	callq  *%rax
  802e7c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e82:	89 c7                	mov    %eax,%edi
  802e84:	48 b8 24 28 80 00 00 	movabs $0x802824,%rax
  802e8b:	00 00 00 
  802e8e:	ff d0                	callq  *%rax
	return r;
  802e90:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e93:	c9                   	leaveq 
  802e94:	c3                   	retq   

0000000000802e95 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e95:	55                   	push   %rbp
  802e96:	48 89 e5             	mov    %rsp,%rbp
  802e99:	48 83 ec 10          	sub    $0x10,%rsp
  802e9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ea0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802ea4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802eab:	00 00 00 
  802eae:	8b 00                	mov    (%rax),%eax
  802eb0:	85 c0                	test   %eax,%eax
  802eb2:	75 1d                	jne    802ed1 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802eb4:	bf 01 00 00 00       	mov    $0x1,%edi
  802eb9:	48 b8 ef 40 80 00 00 	movabs $0x8040ef,%rax
  802ec0:	00 00 00 
  802ec3:	ff d0                	callq  *%rax
  802ec5:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802ecc:	00 00 00 
  802ecf:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ed1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ed8:	00 00 00 
  802edb:	8b 00                	mov    (%rax),%eax
  802edd:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ee0:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ee5:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802eec:	00 00 00 
  802eef:	89 c7                	mov    %eax,%edi
  802ef1:	48 b8 f0 3f 80 00 00 	movabs $0x803ff0,%rax
  802ef8:	00 00 00 
  802efb:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802efd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f01:	ba 00 00 00 00       	mov    $0x0,%edx
  802f06:	48 89 c6             	mov    %rax,%rsi
  802f09:	bf 00 00 00 00       	mov    $0x0,%edi
  802f0e:	48 b8 3d 3f 80 00 00 	movabs $0x803f3d,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	callq  *%rax
}
  802f1a:	c9                   	leaveq 
  802f1b:	c3                   	retq   

0000000000802f1c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f1c:	55                   	push   %rbp
  802f1d:	48 89 e5             	mov    %rsp,%rbp
  802f20:	48 83 ec 20          	sub    $0x20,%rsp
  802f24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f28:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  802f2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f2f:	48 89 c7             	mov    %rax,%rdi
  802f32:	48 b8 ba 0e 80 00 00 	movabs $0x800eba,%rax
  802f39:	00 00 00 
  802f3c:	ff d0                	callq  *%rax
  802f3e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f43:	7e 0a                	jle    802f4f <open+0x33>
		return -E_BAD_PATH;
  802f45:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f4a:	e9 a5 00 00 00       	jmpq   802ff4 <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  802f4f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f53:	48 89 c7             	mov    %rax,%rdi
  802f56:	48 b8 7c 25 80 00 00 	movabs $0x80257c,%rax
  802f5d:	00 00 00 
  802f60:	ff d0                	callq  *%rax
  802f62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f69:	79 08                	jns    802f73 <open+0x57>
		return ret;
  802f6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f6e:	e9 81 00 00 00       	jmpq   802ff4 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802f73:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f7a:	00 00 00 
  802f7d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802f80:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  802f86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f8a:	48 89 c6             	mov    %rax,%rsi
  802f8d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f94:	00 00 00 
  802f97:	48 b8 26 0f 80 00 00 	movabs $0x800f26,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  802fa3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa7:	48 89 c6             	mov    %rax,%rsi
  802faa:	bf 01 00 00 00       	mov    $0x1,%edi
  802faf:	48 b8 95 2e 80 00 00 	movabs $0x802e95,%rax
  802fb6:	00 00 00 
  802fb9:	ff d0                	callq  *%rax
  802fbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc2:	79 1d                	jns    802fe1 <open+0xc5>
	{
		fd_close(fd,0);
  802fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc8:	be 00 00 00 00       	mov    $0x0,%esi
  802fcd:	48 89 c7             	mov    %rax,%rdi
  802fd0:	48 b8 a4 26 80 00 00 	movabs $0x8026a4,%rax
  802fd7:	00 00 00 
  802fda:	ff d0                	callq  *%rax
		return ret;
  802fdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fdf:	eb 13                	jmp    802ff4 <open+0xd8>
	}
	return fd2num (fd);
  802fe1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe5:	48 89 c7             	mov    %rax,%rdi
  802fe8:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  802fef:	00 00 00 
  802ff2:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  802ff4:	c9                   	leaveq 
  802ff5:	c3                   	retq   

0000000000802ff6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802ff6:	55                   	push   %rbp
  802ff7:	48 89 e5             	mov    %rsp,%rbp
  802ffa:	48 83 ec 10          	sub    $0x10,%rsp
  802ffe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803002:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803006:	8b 50 0c             	mov    0xc(%rax),%edx
  803009:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803010:	00 00 00 
  803013:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803015:	be 00 00 00 00       	mov    $0x0,%esi
  80301a:	bf 06 00 00 00       	mov    $0x6,%edi
  80301f:	48 b8 95 2e 80 00 00 	movabs $0x802e95,%rax
  803026:	00 00 00 
  803029:	ff d0                	callq  *%rax
}
  80302b:	c9                   	leaveq 
  80302c:	c3                   	retq   

000000000080302d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80302d:	55                   	push   %rbp
  80302e:	48 89 e5             	mov    %rsp,%rbp
  803031:	48 83 ec 30          	sub    $0x30,%rsp
  803035:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803039:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80303d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  803041:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803045:	8b 50 0c             	mov    0xc(%rax),%edx
  803048:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80304f:	00 00 00 
  803052:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  803054:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80305b:	00 00 00 
  80305e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803062:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  803066:	be 00 00 00 00       	mov    $0x0,%esi
  80306b:	bf 03 00 00 00       	mov    $0x3,%edi
  803070:	48 b8 95 2e 80 00 00 	movabs $0x802e95,%rax
  803077:	00 00 00 
  80307a:	ff d0                	callq  *%rax
  80307c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80307f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803083:	79 05                	jns    80308a <devfile_read+0x5d>
		return ret;
  803085:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803088:	eb 26                	jmp    8030b0 <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  80308a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308d:	48 63 d0             	movslq %eax,%rdx
  803090:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803094:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80309b:	00 00 00 
  80309e:	48 89 c7             	mov    %rax,%rdi
  8030a1:	48 b8 4a 12 80 00 00 	movabs $0x80124a,%rax
  8030a8:	00 00 00 
  8030ab:	ff d0                	callq  *%rax
	return ret;
  8030ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  8030b0:	c9                   	leaveq 
  8030b1:	c3                   	retq   

00000000008030b2 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8030b2:	55                   	push   %rbp
  8030b3:	48 89 e5             	mov    %rsp,%rbp
  8030b6:	48 83 ec 30          	sub    $0x30,%rsp
  8030ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  8030c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ca:	8b 50 0c             	mov    0xc(%rax),%edx
  8030cd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030d4:	00 00 00 
  8030d7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  8030d9:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  8030de:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8030e5:	00 
  8030e6:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8030eb:	48 89 c2             	mov    %rax,%rdx
  8030ee:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030f5:	00 00 00 
  8030f8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8030fc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803103:	00 00 00 
  803106:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80310a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80310e:	48 89 c6             	mov    %rax,%rsi
  803111:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803118:	00 00 00 
  80311b:	48 b8 4a 12 80 00 00 	movabs $0x80124a,%rax
  803122:	00 00 00 
  803125:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  803127:	be 00 00 00 00       	mov    $0x0,%esi
  80312c:	bf 04 00 00 00       	mov    $0x4,%edi
  803131:	48 b8 95 2e 80 00 00 	movabs $0x802e95,%rax
  803138:	00 00 00 
  80313b:	ff d0                	callq  *%rax
  80313d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803140:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803144:	79 05                	jns    80314b <devfile_write+0x99>
		return ret;
  803146:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803149:	eb 03                	jmp    80314e <devfile_write+0x9c>
	
	return ret;
  80314b:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  80314e:	c9                   	leaveq 
  80314f:	c3                   	retq   

0000000000803150 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803150:	55                   	push   %rbp
  803151:	48 89 e5             	mov    %rsp,%rbp
  803154:	48 83 ec 20          	sub    $0x20,%rsp
  803158:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80315c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803160:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803164:	8b 50 0c             	mov    0xc(%rax),%edx
  803167:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80316e:	00 00 00 
  803171:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803173:	be 00 00 00 00       	mov    $0x0,%esi
  803178:	bf 05 00 00 00       	mov    $0x5,%edi
  80317d:	48 b8 95 2e 80 00 00 	movabs $0x802e95,%rax
  803184:	00 00 00 
  803187:	ff d0                	callq  *%rax
  803189:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80318c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803190:	79 05                	jns    803197 <devfile_stat+0x47>
		return r;
  803192:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803195:	eb 56                	jmp    8031ed <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803197:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031a2:	00 00 00 
  8031a5:	48 89 c7             	mov    %rax,%rdi
  8031a8:	48 b8 26 0f 80 00 00 	movabs $0x800f26,%rax
  8031af:	00 00 00 
  8031b2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031b4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031bb:	00 00 00 
  8031be:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031c8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8031ce:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031d5:	00 00 00 
  8031d8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8031de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ed:	c9                   	leaveq 
  8031ee:	c3                   	retq   

00000000008031ef <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031ef:	55                   	push   %rbp
  8031f0:	48 89 e5             	mov    %rsp,%rbp
  8031f3:	48 83 ec 10          	sub    $0x10,%rsp
  8031f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031fb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8031fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803202:	8b 50 0c             	mov    0xc(%rax),%edx
  803205:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80320c:	00 00 00 
  80320f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803211:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803218:	00 00 00 
  80321b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80321e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803221:	be 00 00 00 00       	mov    $0x0,%esi
  803226:	bf 02 00 00 00       	mov    $0x2,%edi
  80322b:	48 b8 95 2e 80 00 00 	movabs $0x802e95,%rax
  803232:	00 00 00 
  803235:	ff d0                	callq  *%rax
}
  803237:	c9                   	leaveq 
  803238:	c3                   	retq   

0000000000803239 <remove>:

// Delete a file
int
remove(const char *path)
{
  803239:	55                   	push   %rbp
  80323a:	48 89 e5             	mov    %rsp,%rbp
  80323d:	48 83 ec 10          	sub    $0x10,%rsp
  803241:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803245:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803249:	48 89 c7             	mov    %rax,%rdi
  80324c:	48 b8 ba 0e 80 00 00 	movabs $0x800eba,%rax
  803253:	00 00 00 
  803256:	ff d0                	callq  *%rax
  803258:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80325d:	7e 07                	jle    803266 <remove+0x2d>
		return -E_BAD_PATH;
  80325f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803264:	eb 33                	jmp    803299 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80326a:	48 89 c6             	mov    %rax,%rsi
  80326d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803274:	00 00 00 
  803277:	48 b8 26 0f 80 00 00 	movabs $0x800f26,%rax
  80327e:	00 00 00 
  803281:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803283:	be 00 00 00 00       	mov    $0x0,%esi
  803288:	bf 07 00 00 00       	mov    $0x7,%edi
  80328d:	48 b8 95 2e 80 00 00 	movabs $0x802e95,%rax
  803294:	00 00 00 
  803297:	ff d0                	callq  *%rax
}
  803299:	c9                   	leaveq 
  80329a:	c3                   	retq   

000000000080329b <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80329b:	55                   	push   %rbp
  80329c:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80329f:	be 00 00 00 00       	mov    $0x0,%esi
  8032a4:	bf 08 00 00 00       	mov    $0x8,%edi
  8032a9:	48 b8 95 2e 80 00 00 	movabs $0x802e95,%rax
  8032b0:	00 00 00 
  8032b3:	ff d0                	callq  *%rax
}
  8032b5:	5d                   	pop    %rbp
  8032b6:	c3                   	retq   

00000000008032b7 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8032b7:	55                   	push   %rbp
  8032b8:	48 89 e5             	mov    %rsp,%rbp
  8032bb:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8032c2:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8032c9:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8032d0:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8032d7:	be 00 00 00 00       	mov    $0x0,%esi
  8032dc:	48 89 c7             	mov    %rax,%rdi
  8032df:	48 b8 1c 2f 80 00 00 	movabs $0x802f1c,%rax
  8032e6:	00 00 00 
  8032e9:	ff d0                	callq  *%rax
  8032eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8032ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f2:	79 28                	jns    80331c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8032f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f7:	89 c6                	mov    %eax,%esi
  8032f9:	48 bf ce 48 80 00 00 	movabs $0x8048ce,%rdi
  803300:	00 00 00 
  803303:	b8 00 00 00 00       	mov    $0x0,%eax
  803308:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  80330f:	00 00 00 
  803312:	ff d2                	callq  *%rdx
		return fd_src;
  803314:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803317:	e9 74 01 00 00       	jmpq   803490 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80331c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803323:	be 01 01 00 00       	mov    $0x101,%esi
  803328:	48 89 c7             	mov    %rax,%rdi
  80332b:	48 b8 1c 2f 80 00 00 	movabs $0x802f1c,%rax
  803332:	00 00 00 
  803335:	ff d0                	callq  *%rax
  803337:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80333a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80333e:	79 39                	jns    803379 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803340:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803343:	89 c6                	mov    %eax,%esi
  803345:	48 bf e4 48 80 00 00 	movabs $0x8048e4,%rdi
  80334c:	00 00 00 
  80334f:	b8 00 00 00 00       	mov    $0x0,%eax
  803354:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  80335b:	00 00 00 
  80335e:	ff d2                	callq  *%rdx
		close(fd_src);
  803360:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803363:	89 c7                	mov    %eax,%edi
  803365:	48 b8 24 28 80 00 00 	movabs $0x802824,%rax
  80336c:	00 00 00 
  80336f:	ff d0                	callq  *%rax
		return fd_dest;
  803371:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803374:	e9 17 01 00 00       	jmpq   803490 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803379:	eb 74                	jmp    8033ef <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80337b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80337e:	48 63 d0             	movslq %eax,%rdx
  803381:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803388:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80338b:	48 89 ce             	mov    %rcx,%rsi
  80338e:	89 c7                	mov    %eax,%edi
  803390:	48 b8 90 2b 80 00 00 	movabs $0x802b90,%rax
  803397:	00 00 00 
  80339a:	ff d0                	callq  *%rax
  80339c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80339f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8033a3:	79 4a                	jns    8033ef <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8033a5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033a8:	89 c6                	mov    %eax,%esi
  8033aa:	48 bf fe 48 80 00 00 	movabs $0x8048fe,%rdi
  8033b1:	00 00 00 
  8033b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b9:	48 ba 30 03 80 00 00 	movabs $0x800330,%rdx
  8033c0:	00 00 00 
  8033c3:	ff d2                	callq  *%rdx
			close(fd_src);
  8033c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c8:	89 c7                	mov    %eax,%edi
  8033ca:	48 b8 24 28 80 00 00 	movabs $0x802824,%rax
  8033d1:	00 00 00 
  8033d4:	ff d0                	callq  *%rax
			close(fd_dest);
  8033d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033d9:	89 c7                	mov    %eax,%edi
  8033db:	48 b8 24 28 80 00 00 	movabs $0x802824,%rax
  8033e2:	00 00 00 
  8033e5:	ff d0                	callq  *%rax
			return write_size;
  8033e7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033ea:	e9 a1 00 00 00       	jmpq   803490 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033ef:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f9:	ba 00 02 00 00       	mov    $0x200,%edx
  8033fe:	48 89 ce             	mov    %rcx,%rsi
  803401:	89 c7                	mov    %eax,%edi
  803403:	48 b8 46 2a 80 00 00 	movabs $0x802a46,%rax
  80340a:	00 00 00 
  80340d:	ff d0                	callq  *%rax
  80340f:	89 45 f4             	mov    %eax,-0xc(%rbp)