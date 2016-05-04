
vmm/guest/obj/user/hello:     file format elf64-x86-64


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
  80003c:	e8 5e 00 00 00       	callq  80009f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("hello, world\n");
  800052:	48 bf e0 36 80 00 00 	movabs $0x8036e0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800074:	00 00 00 
  800077:	48 8b 00             	mov    (%rax),%rax
  80007a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800080:	89 c6                	mov    %eax,%esi
  800082:	48 bf ee 36 80 00 00 	movabs $0x8036ee,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
  80009d:	c9                   	leaveq 
  80009e:	c3                   	retq   

000000000080009f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009f:	55                   	push   %rbp
  8000a0:	48 89 e5             	mov    %rsp,%rbp
  8000a3:	48 83 ec 10          	sub    $0x10,%rsp
  8000a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  8000ae:	48 b8 13 17 80 00 00 	movabs $0x801713,%rax
  8000b5:	00 00 00 
  8000b8:	ff d0                	callq  *%rax
  8000ba:	48 98                	cltq   
  8000bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000c1:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8000c8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000cf:	00 00 00 
  8000d2:	48 01 c2             	add    %rax,%rdx
  8000d5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000dc:	00 00 00 
  8000df:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000e6:	7e 14                	jle    8000fc <libmain+0x5d>
		binaryname = argv[0];
  8000e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000ec:	48 8b 10             	mov    (%rax),%rdx
  8000ef:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000f6:	00 00 00 
  8000f9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800100:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800103:	48 89 d6             	mov    %rdx,%rsi
  800106:	89 c7                	mov    %eax,%edi
  800108:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80010f:	00 00 00 
  800112:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800114:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	callq  *%rax
}
  800120:	c9                   	leaveq 
  800121:	c3                   	retq   

0000000000800122 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800122:	55                   	push   %rbp
  800123:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800126:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  80012d:	00 00 00 
  800130:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800132:	bf 00 00 00 00       	mov    $0x0,%edi
  800137:	48 b8 cf 16 80 00 00 	movabs $0x8016cf,%rax
  80013e:	00 00 00 
  800141:	ff d0                	callq  *%rax
}
  800143:	5d                   	pop    %rbp
  800144:	c3                   	retq   

0000000000800145 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800145:	55                   	push   %rbp
  800146:	48 89 e5             	mov    %rsp,%rbp
  800149:	48 83 ec 10          	sub    $0x10,%rsp
  80014d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800150:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800154:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800158:	8b 00                	mov    (%rax),%eax
  80015a:	8d 48 01             	lea    0x1(%rax),%ecx
  80015d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800161:	89 0a                	mov    %ecx,(%rdx)
  800163:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800166:	89 d1                	mov    %edx,%ecx
  800168:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80016c:	48 98                	cltq   
  80016e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800176:	8b 00                	mov    (%rax),%eax
  800178:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017d:	75 2c                	jne    8001ab <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80017f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800183:	8b 00                	mov    (%rax),%eax
  800185:	48 98                	cltq   
  800187:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80018b:	48 83 c2 08          	add    $0x8,%rdx
  80018f:	48 89 c6             	mov    %rax,%rsi
  800192:	48 89 d7             	mov    %rdx,%rdi
  800195:	48 b8 47 16 80 00 00 	movabs $0x801647,%rax
  80019c:	00 00 00 
  80019f:	ff d0                	callq  *%rax
        b->idx = 0;
  8001a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001af:	8b 40 04             	mov    0x4(%rax),%eax
  8001b2:	8d 50 01             	lea    0x1(%rax),%edx
  8001b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b9:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001bc:	c9                   	leaveq 
  8001bd:	c3                   	retq   

00000000008001be <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001be:	55                   	push   %rbp
  8001bf:	48 89 e5             	mov    %rsp,%rbp
  8001c2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001c9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001d0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001d7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001de:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001e5:	48 8b 0a             	mov    (%rdx),%rcx
  8001e8:	48 89 08             	mov    %rcx,(%rax)
  8001eb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001ef:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001f3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001f7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800202:	00 00 00 
    b.cnt = 0;
  800205:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80020c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80020f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800216:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80021d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800224:	48 89 c6             	mov    %rax,%rsi
  800227:	48 bf 45 01 80 00 00 	movabs $0x800145,%rdi
  80022e:	00 00 00 
  800231:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  800238:	00 00 00 
  80023b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80023d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800243:	48 98                	cltq   
  800245:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80024c:	48 83 c2 08          	add    $0x8,%rdx
  800250:	48 89 c6             	mov    %rax,%rsi
  800253:	48 89 d7             	mov    %rdx,%rdi
  800256:	48 b8 47 16 80 00 00 	movabs $0x801647,%rax
  80025d:	00 00 00 
  800260:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800262:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800268:	c9                   	leaveq 
  800269:	c3                   	retq   

000000000080026a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80026a:	55                   	push   %rbp
  80026b:	48 89 e5             	mov    %rsp,%rbp
  80026e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800275:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80027c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800283:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80028a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800291:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800298:	84 c0                	test   %al,%al
  80029a:	74 20                	je     8002bc <cprintf+0x52>
  80029c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002a0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002a4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002a8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002ac:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002b0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002b4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002b8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002bc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002c3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002ca:	00 00 00 
  8002cd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002d4:	00 00 00 
  8002d7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002db:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002e2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002e9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002f0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002f7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002fe:	48 8b 0a             	mov    (%rdx),%rcx
  800301:	48 89 08             	mov    %rcx,(%rax)
  800304:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800308:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80030c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800310:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800314:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80031b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800322:	48 89 d6             	mov    %rdx,%rsi
  800325:	48 89 c7             	mov    %rax,%rdi
  800328:	48 b8 be 01 80 00 00 	movabs $0x8001be,%rax
  80032f:	00 00 00 
  800332:	ff d0                	callq  *%rax
  800334:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80033a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800340:	c9                   	leaveq 
  800341:	c3                   	retq   

0000000000800342 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800342:	55                   	push   %rbp
  800343:	48 89 e5             	mov    %rsp,%rbp
  800346:	53                   	push   %rbx
  800347:	48 83 ec 38          	sub    $0x38,%rsp
  80034b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80034f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800353:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800357:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80035a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80035e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800362:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800365:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800369:	77 3b                	ja     8003a6 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80036e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800372:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800375:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800379:	ba 00 00 00 00       	mov    $0x0,%edx
  80037e:	48 f7 f3             	div    %rbx
  800381:	48 89 c2             	mov    %rax,%rdx
  800384:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800387:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80038a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80038e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800392:	41 89 f9             	mov    %edi,%r9d
  800395:	48 89 c7             	mov    %rax,%rdi
  800398:	48 b8 42 03 80 00 00 	movabs $0x800342,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	callq  *%rax
  8003a4:	eb 1e                	jmp    8003c4 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a6:	eb 12                	jmp    8003ba <printnum+0x78>
			putch(padc, putdat);
  8003a8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003ac:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003b3:	48 89 ce             	mov    %rcx,%rsi
  8003b6:	89 d7                	mov    %edx,%edi
  8003b8:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ba:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003be:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003c2:	7f e4                	jg     8003a8 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d0:	48 f7 f1             	div    %rcx
  8003d3:	48 89 d0             	mov    %rdx,%rax
  8003d6:	48 ba 10 39 80 00 00 	movabs $0x803910,%rdx
  8003dd:	00 00 00 
  8003e0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003e4:	0f be d0             	movsbl %al,%edx
  8003e7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003ef:	48 89 ce             	mov    %rcx,%rsi
  8003f2:	89 d7                	mov    %edx,%edi
  8003f4:	ff d0                	callq  *%rax
}
  8003f6:	48 83 c4 38          	add    $0x38,%rsp
  8003fa:	5b                   	pop    %rbx
  8003fb:	5d                   	pop    %rbp
  8003fc:	c3                   	retq   

00000000008003fd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003fd:	55                   	push   %rbp
  8003fe:	48 89 e5             	mov    %rsp,%rbp
  800401:	48 83 ec 1c          	sub    $0x1c,%rsp
  800405:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800409:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80040c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800410:	7e 52                	jle    800464 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800412:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800416:	8b 00                	mov    (%rax),%eax
  800418:	83 f8 30             	cmp    $0x30,%eax
  80041b:	73 24                	jae    800441 <getuint+0x44>
  80041d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800421:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800429:	8b 00                	mov    (%rax),%eax
  80042b:	89 c0                	mov    %eax,%eax
  80042d:	48 01 d0             	add    %rdx,%rax
  800430:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800434:	8b 12                	mov    (%rdx),%edx
  800436:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800439:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80043d:	89 0a                	mov    %ecx,(%rdx)
  80043f:	eb 17                	jmp    800458 <getuint+0x5b>
  800441:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800445:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800449:	48 89 d0             	mov    %rdx,%rax
  80044c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800450:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800454:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800458:	48 8b 00             	mov    (%rax),%rax
  80045b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80045f:	e9 a3 00 00 00       	jmpq   800507 <getuint+0x10a>
	else if (lflag)
  800464:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800468:	74 4f                	je     8004b9 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80046a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046e:	8b 00                	mov    (%rax),%eax
  800470:	83 f8 30             	cmp    $0x30,%eax
  800473:	73 24                	jae    800499 <getuint+0x9c>
  800475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800479:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80047d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800481:	8b 00                	mov    (%rax),%eax
  800483:	89 c0                	mov    %eax,%eax
  800485:	48 01 d0             	add    %rdx,%rax
  800488:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80048c:	8b 12                	mov    (%rdx),%edx
  80048e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800491:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800495:	89 0a                	mov    %ecx,(%rdx)
  800497:	eb 17                	jmp    8004b0 <getuint+0xb3>
  800499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004a1:	48 89 d0             	mov    %rdx,%rax
  8004a4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ac:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004b0:	48 8b 00             	mov    (%rax),%rax
  8004b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004b7:	eb 4e                	jmp    800507 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bd:	8b 00                	mov    (%rax),%eax
  8004bf:	83 f8 30             	cmp    $0x30,%eax
  8004c2:	73 24                	jae    8004e8 <getuint+0xeb>
  8004c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d0:	8b 00                	mov    (%rax),%eax
  8004d2:	89 c0                	mov    %eax,%eax
  8004d4:	48 01 d0             	add    %rdx,%rax
  8004d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004db:	8b 12                	mov    (%rdx),%edx
  8004dd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e4:	89 0a                	mov    %ecx,(%rdx)
  8004e6:	eb 17                	jmp    8004ff <getuint+0x102>
  8004e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ec:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004f0:	48 89 d0             	mov    %rdx,%rax
  8004f3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004fb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004ff:	8b 00                	mov    (%rax),%eax
  800501:	89 c0                	mov    %eax,%eax
  800503:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800507:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80050b:	c9                   	leaveq 
  80050c:	c3                   	retq   

000000000080050d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80050d:	55                   	push   %rbp
  80050e:	48 89 e5             	mov    %rsp,%rbp
  800511:	48 83 ec 1c          	sub    $0x1c,%rsp
  800515:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800519:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80051c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800520:	7e 52                	jle    800574 <getint+0x67>
		x=va_arg(*ap, long long);
  800522:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800526:	8b 00                	mov    (%rax),%eax
  800528:	83 f8 30             	cmp    $0x30,%eax
  80052b:	73 24                	jae    800551 <getint+0x44>
  80052d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800531:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800535:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800539:	8b 00                	mov    (%rax),%eax
  80053b:	89 c0                	mov    %eax,%eax
  80053d:	48 01 d0             	add    %rdx,%rax
  800540:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800544:	8b 12                	mov    (%rdx),%edx
  800546:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800549:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054d:	89 0a                	mov    %ecx,(%rdx)
  80054f:	eb 17                	jmp    800568 <getint+0x5b>
  800551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800555:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800559:	48 89 d0             	mov    %rdx,%rax
  80055c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800560:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800564:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800568:	48 8b 00             	mov    (%rax),%rax
  80056b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80056f:	e9 a3 00 00 00       	jmpq   800617 <getint+0x10a>
	else if (lflag)
  800574:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800578:	74 4f                	je     8005c9 <getint+0xbc>
		x=va_arg(*ap, long);
  80057a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057e:	8b 00                	mov    (%rax),%eax
  800580:	83 f8 30             	cmp    $0x30,%eax
  800583:	73 24                	jae    8005a9 <getint+0x9c>
  800585:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800589:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80058d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800591:	8b 00                	mov    (%rax),%eax
  800593:	89 c0                	mov    %eax,%eax
  800595:	48 01 d0             	add    %rdx,%rax
  800598:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059c:	8b 12                	mov    (%rdx),%edx
  80059e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a5:	89 0a                	mov    %ecx,(%rdx)
  8005a7:	eb 17                	jmp    8005c0 <getint+0xb3>
  8005a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ad:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005b1:	48 89 d0             	mov    %rdx,%rax
  8005b4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c0:	48 8b 00             	mov    (%rax),%rax
  8005c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005c7:	eb 4e                	jmp    800617 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005cd:	8b 00                	mov    (%rax),%eax
  8005cf:	83 f8 30             	cmp    $0x30,%eax
  8005d2:	73 24                	jae    8005f8 <getint+0xeb>
  8005d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e0:	8b 00                	mov    (%rax),%eax
  8005e2:	89 c0                	mov    %eax,%eax
  8005e4:	48 01 d0             	add    %rdx,%rax
  8005e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005eb:	8b 12                	mov    (%rdx),%edx
  8005ed:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f4:	89 0a                	mov    %ecx,(%rdx)
  8005f6:	eb 17                	jmp    80060f <getint+0x102>
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800600:	48 89 d0             	mov    %rdx,%rax
  800603:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800607:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80060f:	8b 00                	mov    (%rax),%eax
  800611:	48 98                	cltq   
  800613:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800617:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80061b:	c9                   	leaveq 
  80061c:	c3                   	retq   

000000000080061d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80061d:	55                   	push   %rbp
  80061e:	48 89 e5             	mov    %rsp,%rbp
  800621:	41 54                	push   %r12
  800623:	53                   	push   %rbx
  800624:	48 83 ec 60          	sub    $0x60,%rsp
  800628:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80062c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800630:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800634:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800638:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80063c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800640:	48 8b 0a             	mov    (%rdx),%rcx
  800643:	48 89 08             	mov    %rcx,(%rax)
  800646:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80064a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80064e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800652:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800656:	eb 28                	jmp    800680 <vprintfmt+0x63>
			if (ch == '\0'){
  800658:	85 db                	test   %ebx,%ebx
  80065a:	75 15                	jne    800671 <vprintfmt+0x54>
				current_color=WHITE;
  80065c:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800663:	00 00 00 
  800666:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  80066c:	e9 fc 04 00 00       	jmpq   800b6d <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  800671:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800675:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800679:	48 89 d6             	mov    %rdx,%rsi
  80067c:	89 df                	mov    %ebx,%edi
  80067e:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800680:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800684:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800688:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80068c:	0f b6 00             	movzbl (%rax),%eax
  80068f:	0f b6 d8             	movzbl %al,%ebx
  800692:	83 fb 25             	cmp    $0x25,%ebx
  800695:	75 c1                	jne    800658 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800697:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80069b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8006a2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006b0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006bb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006bf:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006c3:	0f b6 00             	movzbl (%rax),%eax
  8006c6:	0f b6 d8             	movzbl %al,%ebx
  8006c9:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006cc:	83 f8 55             	cmp    $0x55,%eax
  8006cf:	0f 87 64 04 00 00    	ja     800b39 <vprintfmt+0x51c>
  8006d5:	89 c0                	mov    %eax,%eax
  8006d7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006de:	00 
  8006df:	48 b8 38 39 80 00 00 	movabs $0x803938,%rax
  8006e6:	00 00 00 
  8006e9:	48 01 d0             	add    %rdx,%rax
  8006ec:	48 8b 00             	mov    (%rax),%rax
  8006ef:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006f1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006f5:	eb c0                	jmp    8006b7 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006f7:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006fb:	eb ba                	jmp    8006b7 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006fd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800704:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800707:	89 d0                	mov    %edx,%eax
  800709:	c1 e0 02             	shl    $0x2,%eax
  80070c:	01 d0                	add    %edx,%eax
  80070e:	01 c0                	add    %eax,%eax
  800710:	01 d8                	add    %ebx,%eax
  800712:	83 e8 30             	sub    $0x30,%eax
  800715:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800718:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80071c:	0f b6 00             	movzbl (%rax),%eax
  80071f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800722:	83 fb 2f             	cmp    $0x2f,%ebx
  800725:	7e 0c                	jle    800733 <vprintfmt+0x116>
  800727:	83 fb 39             	cmp    $0x39,%ebx
  80072a:	7f 07                	jg     800733 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80072c:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800731:	eb d1                	jmp    800704 <vprintfmt+0xe7>
			goto process_precision;
  800733:	eb 58                	jmp    80078d <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800735:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800738:	83 f8 30             	cmp    $0x30,%eax
  80073b:	73 17                	jae    800754 <vprintfmt+0x137>
  80073d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800741:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800744:	89 c0                	mov    %eax,%eax
  800746:	48 01 d0             	add    %rdx,%rax
  800749:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80074c:	83 c2 08             	add    $0x8,%edx
  80074f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800752:	eb 0f                	jmp    800763 <vprintfmt+0x146>
  800754:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800758:	48 89 d0             	mov    %rdx,%rax
  80075b:	48 83 c2 08          	add    $0x8,%rdx
  80075f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800763:	8b 00                	mov    (%rax),%eax
  800765:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800768:	eb 23                	jmp    80078d <vprintfmt+0x170>

		case '.':
			if (width < 0)
  80076a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80076e:	79 0c                	jns    80077c <vprintfmt+0x15f>
				width = 0;
  800770:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800777:	e9 3b ff ff ff       	jmpq   8006b7 <vprintfmt+0x9a>
  80077c:	e9 36 ff ff ff       	jmpq   8006b7 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  800781:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800788:	e9 2a ff ff ff       	jmpq   8006b7 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  80078d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800791:	79 12                	jns    8007a5 <vprintfmt+0x188>
				width = precision, precision = -1;
  800793:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800796:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800799:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007a0:	e9 12 ff ff ff       	jmpq   8006b7 <vprintfmt+0x9a>
  8007a5:	e9 0d ff ff ff       	jmpq   8006b7 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007aa:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007ae:	e9 04 ff ff ff       	jmpq   8006b7 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007b3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b6:	83 f8 30             	cmp    $0x30,%eax
  8007b9:	73 17                	jae    8007d2 <vprintfmt+0x1b5>
  8007bb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007bf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c2:	89 c0                	mov    %eax,%eax
  8007c4:	48 01 d0             	add    %rdx,%rax
  8007c7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007ca:	83 c2 08             	add    $0x8,%edx
  8007cd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007d0:	eb 0f                	jmp    8007e1 <vprintfmt+0x1c4>
  8007d2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007d6:	48 89 d0             	mov    %rdx,%rax
  8007d9:	48 83 c2 08          	add    $0x8,%rdx
  8007dd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007e1:	8b 10                	mov    (%rax),%edx
  8007e3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007e7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007eb:	48 89 ce             	mov    %rcx,%rsi
  8007ee:	89 d7                	mov    %edx,%edi
  8007f0:	ff d0                	callq  *%rax
			break;
  8007f2:	e9 70 03 00 00       	jmpq   800b67 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007f7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007fa:	83 f8 30             	cmp    $0x30,%eax
  8007fd:	73 17                	jae    800816 <vprintfmt+0x1f9>
  8007ff:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800803:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800806:	89 c0                	mov    %eax,%eax
  800808:	48 01 d0             	add    %rdx,%rax
  80080b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80080e:	83 c2 08             	add    $0x8,%edx
  800811:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800814:	eb 0f                	jmp    800825 <vprintfmt+0x208>
  800816:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80081a:	48 89 d0             	mov    %rdx,%rax
  80081d:	48 83 c2 08          	add    $0x8,%rdx
  800821:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800825:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800827:	85 db                	test   %ebx,%ebx
  800829:	79 02                	jns    80082d <vprintfmt+0x210>
				err = -err;
  80082b:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80082d:	83 fb 15             	cmp    $0x15,%ebx
  800830:	7f 16                	jg     800848 <vprintfmt+0x22b>
  800832:	48 b8 60 38 80 00 00 	movabs $0x803860,%rax
  800839:	00 00 00 
  80083c:	48 63 d3             	movslq %ebx,%rdx
  80083f:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800843:	4d 85 e4             	test   %r12,%r12
  800846:	75 2e                	jne    800876 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  800848:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80084c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800850:	89 d9                	mov    %ebx,%ecx
  800852:	48 ba 21 39 80 00 00 	movabs $0x803921,%rdx
  800859:	00 00 00 
  80085c:	48 89 c7             	mov    %rax,%rdi
  80085f:	b8 00 00 00 00       	mov    $0x0,%eax
  800864:	49 b8 76 0b 80 00 00 	movabs $0x800b76,%r8
  80086b:	00 00 00 
  80086e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800871:	e9 f1 02 00 00       	jmpq   800b67 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800876:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80087a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80087e:	4c 89 e1             	mov    %r12,%rcx
  800881:	48 ba 2a 39 80 00 00 	movabs $0x80392a,%rdx
  800888:	00 00 00 
  80088b:	48 89 c7             	mov    %rax,%rdi
  80088e:	b8 00 00 00 00       	mov    $0x0,%eax
  800893:	49 b8 76 0b 80 00 00 	movabs $0x800b76,%r8
  80089a:	00 00 00 
  80089d:	41 ff d0             	callq  *%r8
			break;
  8008a0:	e9 c2 02 00 00       	jmpq   800b67 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a8:	83 f8 30             	cmp    $0x30,%eax
  8008ab:	73 17                	jae    8008c4 <vprintfmt+0x2a7>
  8008ad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008b1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b4:	89 c0                	mov    %eax,%eax
  8008b6:	48 01 d0             	add    %rdx,%rax
  8008b9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008bc:	83 c2 08             	add    $0x8,%edx
  8008bf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008c2:	eb 0f                	jmp    8008d3 <vprintfmt+0x2b6>
  8008c4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c8:	48 89 d0             	mov    %rdx,%rax
  8008cb:	48 83 c2 08          	add    $0x8,%rdx
  8008cf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008d3:	4c 8b 20             	mov    (%rax),%r12
  8008d6:	4d 85 e4             	test   %r12,%r12
  8008d9:	75 0a                	jne    8008e5 <vprintfmt+0x2c8>
				p = "(null)";
  8008db:	49 bc 2d 39 80 00 00 	movabs $0x80392d,%r12
  8008e2:	00 00 00 
			if (width > 0 && padc != '-')
  8008e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e9:	7e 3f                	jle    80092a <vprintfmt+0x30d>
  8008eb:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008ef:	74 39                	je     80092a <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008f4:	48 98                	cltq   
  8008f6:	48 89 c6             	mov    %rax,%rsi
  8008f9:	4c 89 e7             	mov    %r12,%rdi
  8008fc:	48 b8 22 0e 80 00 00 	movabs $0x800e22,%rax
  800903:	00 00 00 
  800906:	ff d0                	callq  *%rax
  800908:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80090b:	eb 17                	jmp    800924 <vprintfmt+0x307>
					putch(padc, putdat);
  80090d:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800911:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800915:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800919:	48 89 ce             	mov    %rcx,%rsi
  80091c:	89 d7                	mov    %edx,%edi
  80091e:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800920:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800924:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800928:	7f e3                	jg     80090d <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092a:	eb 37                	jmp    800963 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  80092c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800930:	74 1e                	je     800950 <vprintfmt+0x333>
  800932:	83 fb 1f             	cmp    $0x1f,%ebx
  800935:	7e 05                	jle    80093c <vprintfmt+0x31f>
  800937:	83 fb 7e             	cmp    $0x7e,%ebx
  80093a:	7e 14                	jle    800950 <vprintfmt+0x333>
					putch('?', putdat);
  80093c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800940:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800944:	48 89 d6             	mov    %rdx,%rsi
  800947:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80094c:	ff d0                	callq  *%rax
  80094e:	eb 0f                	jmp    80095f <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800950:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800954:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800958:	48 89 d6             	mov    %rdx,%rsi
  80095b:	89 df                	mov    %ebx,%edi
  80095d:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800963:	4c 89 e0             	mov    %r12,%rax
  800966:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80096a:	0f b6 00             	movzbl (%rax),%eax
  80096d:	0f be d8             	movsbl %al,%ebx
  800970:	85 db                	test   %ebx,%ebx
  800972:	74 10                	je     800984 <vprintfmt+0x367>
  800974:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800978:	78 b2                	js     80092c <vprintfmt+0x30f>
  80097a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80097e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800982:	79 a8                	jns    80092c <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800984:	eb 16                	jmp    80099c <vprintfmt+0x37f>
				putch(' ', putdat);
  800986:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80098a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098e:	48 89 d6             	mov    %rdx,%rsi
  800991:	bf 20 00 00 00       	mov    $0x20,%edi
  800996:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800998:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80099c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a0:	7f e4                	jg     800986 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  8009a2:	e9 c0 01 00 00       	jmpq   800b67 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009a7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009ab:	be 03 00 00 00       	mov    $0x3,%esi
  8009b0:	48 89 c7             	mov    %rax,%rdi
  8009b3:	48 b8 0d 05 80 00 00 	movabs $0x80050d,%rax
  8009ba:	00 00 00 
  8009bd:	ff d0                	callq  *%rax
  8009bf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c7:	48 85 c0             	test   %rax,%rax
  8009ca:	79 1d                	jns    8009e9 <vprintfmt+0x3cc>
				putch('-', putdat);
  8009cc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009d0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d4:	48 89 d6             	mov    %rdx,%rsi
  8009d7:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009dc:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e2:	48 f7 d8             	neg    %rax
  8009e5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009e9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009f0:	e9 d5 00 00 00       	jmpq   800aca <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009f5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009f9:	be 03 00 00 00       	mov    $0x3,%esi
  8009fe:	48 89 c7             	mov    %rax,%rdi
  800a01:	48 b8 fd 03 80 00 00 	movabs $0x8003fd,%rax
  800a08:	00 00 00 
  800a0b:	ff d0                	callq  *%rax
  800a0d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a11:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a18:	e9 ad 00 00 00       	jmpq   800aca <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800a1d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a21:	be 03 00 00 00       	mov    $0x3,%esi
  800a26:	48 89 c7             	mov    %rax,%rdi
  800a29:	48 b8 fd 03 80 00 00 	movabs $0x8003fd,%rax
  800a30:	00 00 00 
  800a33:	ff d0                	callq  *%rax
  800a35:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a39:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a40:	e9 85 00 00 00       	jmpq   800aca <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800a45:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4d:	48 89 d6             	mov    %rdx,%rsi
  800a50:	bf 30 00 00 00       	mov    $0x30,%edi
  800a55:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a57:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a5b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5f:	48 89 d6             	mov    %rdx,%rsi
  800a62:	bf 78 00 00 00       	mov    $0x78,%edi
  800a67:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6c:	83 f8 30             	cmp    $0x30,%eax
  800a6f:	73 17                	jae    800a88 <vprintfmt+0x46b>
  800a71:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a78:	89 c0                	mov    %eax,%eax
  800a7a:	48 01 d0             	add    %rdx,%rax
  800a7d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a80:	83 c2 08             	add    $0x8,%edx
  800a83:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a86:	eb 0f                	jmp    800a97 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  800a88:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a8c:	48 89 d0             	mov    %rdx,%rax
  800a8f:	48 83 c2 08          	add    $0x8,%rdx
  800a93:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a97:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a9e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800aa5:	eb 23                	jmp    800aca <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800aa7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aab:	be 03 00 00 00       	mov    $0x3,%esi
  800ab0:	48 89 c7             	mov    %rax,%rdi
  800ab3:	48 b8 fd 03 80 00 00 	movabs $0x8003fd,%rax
  800aba:	00 00 00 
  800abd:	ff d0                	callq  *%rax
  800abf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ac3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aca:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800acf:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ad2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ad5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800add:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae1:	45 89 c1             	mov    %r8d,%r9d
  800ae4:	41 89 f8             	mov    %edi,%r8d
  800ae7:	48 89 c7             	mov    %rax,%rdi
  800aea:	48 b8 42 03 80 00 00 	movabs $0x800342,%rax
  800af1:	00 00 00 
  800af4:	ff d0                	callq  *%rax
			break;
  800af6:	eb 6f                	jmp    800b67 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800af8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800afc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b00:	48 89 d6             	mov    %rdx,%rsi
  800b03:	89 df                	mov    %ebx,%edi
  800b05:	ff d0                	callq  *%rax
			break;
  800b07:	eb 5e                	jmp    800b67 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  800b09:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b0d:	be 03 00 00 00       	mov    $0x3,%esi
  800b12:	48 89 c7             	mov    %rax,%rdi
  800b15:	48 b8 fd 03 80 00 00 	movabs $0x8003fd,%rax
  800b1c:	00 00 00 
  800b1f:	ff d0                	callq  *%rax
  800b21:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  800b25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b29:	89 c2                	mov    %eax,%edx
  800b2b:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800b32:	00 00 00 
  800b35:	89 10                	mov    %edx,(%rax)
			break;
  800b37:	eb 2e                	jmp    800b67 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b41:	48 89 d6             	mov    %rdx,%rsi
  800b44:	bf 25 00 00 00       	mov    $0x25,%edi
  800b49:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b4b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b50:	eb 05                	jmp    800b57 <vprintfmt+0x53a>
  800b52:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b57:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b5b:	48 83 e8 01          	sub    $0x1,%rax
  800b5f:	0f b6 00             	movzbl (%rax),%eax
  800b62:	3c 25                	cmp    $0x25,%al
  800b64:	75 ec                	jne    800b52 <vprintfmt+0x535>
				/* do nothing */;
			break;
  800b66:	90                   	nop
		}
	}
  800b67:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b68:	e9 13 fb ff ff       	jmpq   800680 <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b6d:	48 83 c4 60          	add    $0x60,%rsp
  800b71:	5b                   	pop    %rbx
  800b72:	41 5c                	pop    %r12
  800b74:	5d                   	pop    %rbp
  800b75:	c3                   	retq   

0000000000800b76 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b76:	55                   	push   %rbp
  800b77:	48 89 e5             	mov    %rsp,%rbp
  800b7a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b81:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b88:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b8f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b96:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b9d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ba4:	84 c0                	test   %al,%al
  800ba6:	74 20                	je     800bc8 <printfmt+0x52>
  800ba8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bac:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bb0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bb4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bb8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bbc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bc0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bc4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800bc8:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800bcf:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800bd6:	00 00 00 
  800bd9:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800be0:	00 00 00 
  800be3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800be7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bee:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bf5:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bfc:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c03:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c0a:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c11:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c18:	48 89 c7             	mov    %rax,%rdi
  800c1b:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  800c22:	00 00 00 
  800c25:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c27:	c9                   	leaveq 
  800c28:	c3                   	retq   

0000000000800c29 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c29:	55                   	push   %rbp
  800c2a:	48 89 e5             	mov    %rsp,%rbp
  800c2d:	48 83 ec 10          	sub    $0x10,%rsp
  800c31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c34:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c3c:	8b 40 10             	mov    0x10(%rax),%eax
  800c3f:	8d 50 01             	lea    0x1(%rax),%edx
  800c42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c46:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c4d:	48 8b 10             	mov    (%rax),%rdx
  800c50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c54:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c58:	48 39 c2             	cmp    %rax,%rdx
  800c5b:	73 17                	jae    800c74 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c61:	48 8b 00             	mov    (%rax),%rax
  800c64:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c6c:	48 89 0a             	mov    %rcx,(%rdx)
  800c6f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c72:	88 10                	mov    %dl,(%rax)
}
  800c74:	c9                   	leaveq 
  800c75:	c3                   	retq   

0000000000800c76 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c76:	55                   	push   %rbp
  800c77:	48 89 e5             	mov    %rsp,%rbp
  800c7a:	48 83 ec 50          	sub    $0x50,%rsp
  800c7e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c82:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c85:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c89:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c8d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c91:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c95:	48 8b 0a             	mov    (%rdx),%rcx
  800c98:	48 89 08             	mov    %rcx,(%rax)
  800c9b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c9f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ca3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ca7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800caf:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cb3:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cb6:	48 98                	cltq   
  800cb8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800cbc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cc0:	48 01 d0             	add    %rdx,%rax
  800cc3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800cc7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800cce:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800cd3:	74 06                	je     800cdb <vsnprintf+0x65>
  800cd5:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800cd9:	7f 07                	jg     800ce2 <vsnprintf+0x6c>
		return -E_INVAL;
  800cdb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ce0:	eb 2f                	jmp    800d11 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ce2:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ce6:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cea:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cee:	48 89 c6             	mov    %rax,%rsi
  800cf1:	48 bf 29 0c 80 00 00 	movabs $0x800c29,%rdi
  800cf8:	00 00 00 
  800cfb:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  800d02:	00 00 00 
  800d05:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d07:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d0b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d0e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d11:	c9                   	leaveq 
  800d12:	c3                   	retq   

0000000000800d13 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d13:	55                   	push   %rbp
  800d14:	48 89 e5             	mov    %rsp,%rbp
  800d17:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d1e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d25:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d2b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d32:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d39:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d40:	84 c0                	test   %al,%al
  800d42:	74 20                	je     800d64 <snprintf+0x51>
  800d44:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d48:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d4c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d50:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d54:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d58:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d5c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d60:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d64:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d6b:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d72:	00 00 00 
  800d75:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d7c:	00 00 00 
  800d7f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d83:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d8a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d91:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d98:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d9f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800da6:	48 8b 0a             	mov    (%rdx),%rcx
  800da9:	48 89 08             	mov    %rcx,(%rax)
  800dac:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800db0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800db4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800db8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800dbc:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800dc3:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800dca:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800dd0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800dd7:	48 89 c7             	mov    %rax,%rdi
  800dda:	48 b8 76 0c 80 00 00 	movabs $0x800c76,%rax
  800de1:	00 00 00 
  800de4:	ff d0                	callq  *%rax
  800de6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800dec:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800df2:	c9                   	leaveq 
  800df3:	c3                   	retq   

0000000000800df4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800df4:	55                   	push   %rbp
  800df5:	48 89 e5             	mov    %rsp,%rbp
  800df8:	48 83 ec 18          	sub    $0x18,%rsp
  800dfc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e07:	eb 09                	jmp    800e12 <strlen+0x1e>
		n++;
  800e09:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e16:	0f b6 00             	movzbl (%rax),%eax
  800e19:	84 c0                	test   %al,%al
  800e1b:	75 ec                	jne    800e09 <strlen+0x15>
		n++;
	return n;
  800e1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e20:	c9                   	leaveq 
  800e21:	c3                   	retq   

0000000000800e22 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e22:	55                   	push   %rbp
  800e23:	48 89 e5             	mov    %rsp,%rbp
  800e26:	48 83 ec 20          	sub    $0x20,%rsp
  800e2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e2e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e39:	eb 0e                	jmp    800e49 <strnlen+0x27>
		n++;
  800e3b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e3f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e44:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e49:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e4e:	74 0b                	je     800e5b <strnlen+0x39>
  800e50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e54:	0f b6 00             	movzbl (%rax),%eax
  800e57:	84 c0                	test   %al,%al
  800e59:	75 e0                	jne    800e3b <strnlen+0x19>
		n++;
	return n;
  800e5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e5e:	c9                   	leaveq 
  800e5f:	c3                   	retq   

0000000000800e60 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e60:	55                   	push   %rbp
  800e61:	48 89 e5             	mov    %rsp,%rbp
  800e64:	48 83 ec 20          	sub    $0x20,%rsp
  800e68:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e74:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e78:	90                   	nop
  800e79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e81:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e85:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e89:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e8d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e91:	0f b6 12             	movzbl (%rdx),%edx
  800e94:	88 10                	mov    %dl,(%rax)
  800e96:	0f b6 00             	movzbl (%rax),%eax
  800e99:	84 c0                	test   %al,%al
  800e9b:	75 dc                	jne    800e79 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ea1:	c9                   	leaveq 
  800ea2:	c3                   	retq   

0000000000800ea3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ea3:	55                   	push   %rbp
  800ea4:	48 89 e5             	mov    %rsp,%rbp
  800ea7:	48 83 ec 20          	sub    $0x20,%rsp
  800eab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eaf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800eb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb7:	48 89 c7             	mov    %rax,%rdi
  800eba:	48 b8 f4 0d 80 00 00 	movabs $0x800df4,%rax
  800ec1:	00 00 00 
  800ec4:	ff d0                	callq  *%rax
  800ec6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ec9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ecc:	48 63 d0             	movslq %eax,%rdx
  800ecf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed3:	48 01 c2             	add    %rax,%rdx
  800ed6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800eda:	48 89 c6             	mov    %rax,%rsi
  800edd:	48 89 d7             	mov    %rdx,%rdi
  800ee0:	48 b8 60 0e 80 00 00 	movabs $0x800e60,%rax
  800ee7:	00 00 00 
  800eea:	ff d0                	callq  *%rax
	return dst;
  800eec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ef0:	c9                   	leaveq 
  800ef1:	c3                   	retq   

0000000000800ef2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ef2:	55                   	push   %rbp
  800ef3:	48 89 e5             	mov    %rsp,%rbp
  800ef6:	48 83 ec 28          	sub    $0x28,%rsp
  800efa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800efe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f02:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f0e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f15:	00 
  800f16:	eb 2a                	jmp    800f42 <strncpy+0x50>
		*dst++ = *src;
  800f18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f1c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f20:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f24:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f28:	0f b6 12             	movzbl (%rdx),%edx
  800f2b:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f2d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f31:	0f b6 00             	movzbl (%rax),%eax
  800f34:	84 c0                	test   %al,%al
  800f36:	74 05                	je     800f3d <strncpy+0x4b>
			src++;
  800f38:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f3d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f46:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f4a:	72 cc                	jb     800f18 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f50:	c9                   	leaveq 
  800f51:	c3                   	retq   

0000000000800f52 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f52:	55                   	push   %rbp
  800f53:	48 89 e5             	mov    %rsp,%rbp
  800f56:	48 83 ec 28          	sub    $0x28,%rsp
  800f5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f5e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f62:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f6e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f73:	74 3d                	je     800fb2 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f75:	eb 1d                	jmp    800f94 <strlcpy+0x42>
			*dst++ = *src++;
  800f77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f7f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f83:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f87:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f8b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f8f:	0f b6 12             	movzbl (%rdx),%edx
  800f92:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f94:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f99:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f9e:	74 0b                	je     800fab <strlcpy+0x59>
  800fa0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fa4:	0f b6 00             	movzbl (%rax),%eax
  800fa7:	84 c0                	test   %al,%al
  800fa9:	75 cc                	jne    800f77 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800faf:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800fb2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fba:	48 29 c2             	sub    %rax,%rdx
  800fbd:	48 89 d0             	mov    %rdx,%rax
}
  800fc0:	c9                   	leaveq 
  800fc1:	c3                   	retq   

0000000000800fc2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fc2:	55                   	push   %rbp
  800fc3:	48 89 e5             	mov    %rsp,%rbp
  800fc6:	48 83 ec 10          	sub    $0x10,%rsp
  800fca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800fd2:	eb 0a                	jmp    800fde <strcmp+0x1c>
		p++, q++;
  800fd4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fd9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fe2:	0f b6 00             	movzbl (%rax),%eax
  800fe5:	84 c0                	test   %al,%al
  800fe7:	74 12                	je     800ffb <strcmp+0x39>
  800fe9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fed:	0f b6 10             	movzbl (%rax),%edx
  800ff0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff4:	0f b6 00             	movzbl (%rax),%eax
  800ff7:	38 c2                	cmp    %al,%dl
  800ff9:	74 d9                	je     800fd4 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ffb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fff:	0f b6 00             	movzbl (%rax),%eax
  801002:	0f b6 d0             	movzbl %al,%edx
  801005:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801009:	0f b6 00             	movzbl (%rax),%eax
  80100c:	0f b6 c0             	movzbl %al,%eax
  80100f:	29 c2                	sub    %eax,%edx
  801011:	89 d0                	mov    %edx,%eax
}
  801013:	c9                   	leaveq 
  801014:	c3                   	retq   

0000000000801015 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801015:	55                   	push   %rbp
  801016:	48 89 e5             	mov    %rsp,%rbp
  801019:	48 83 ec 18          	sub    $0x18,%rsp
  80101d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801021:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801025:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801029:	eb 0f                	jmp    80103a <strncmp+0x25>
		n--, p++, q++;
  80102b:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801030:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801035:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80103a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80103f:	74 1d                	je     80105e <strncmp+0x49>
  801041:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801045:	0f b6 00             	movzbl (%rax),%eax
  801048:	84 c0                	test   %al,%al
  80104a:	74 12                	je     80105e <strncmp+0x49>
  80104c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801050:	0f b6 10             	movzbl (%rax),%edx
  801053:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801057:	0f b6 00             	movzbl (%rax),%eax
  80105a:	38 c2                	cmp    %al,%dl
  80105c:	74 cd                	je     80102b <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80105e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801063:	75 07                	jne    80106c <strncmp+0x57>
		return 0;
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
  80106a:	eb 18                	jmp    801084 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80106c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801070:	0f b6 00             	movzbl (%rax),%eax
  801073:	0f b6 d0             	movzbl %al,%edx
  801076:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80107a:	0f b6 00             	movzbl (%rax),%eax
  80107d:	0f b6 c0             	movzbl %al,%eax
  801080:	29 c2                	sub    %eax,%edx
  801082:	89 d0                	mov    %edx,%eax
}
  801084:	c9                   	leaveq 
  801085:	c3                   	retq   

0000000000801086 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801086:	55                   	push   %rbp
  801087:	48 89 e5             	mov    %rsp,%rbp
  80108a:	48 83 ec 0c          	sub    $0xc,%rsp
  80108e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801092:	89 f0                	mov    %esi,%eax
  801094:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801097:	eb 17                	jmp    8010b0 <strchr+0x2a>
		if (*s == c)
  801099:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109d:	0f b6 00             	movzbl (%rax),%eax
  8010a0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010a3:	75 06                	jne    8010ab <strchr+0x25>
			return (char *) s;
  8010a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a9:	eb 15                	jmp    8010c0 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b4:	0f b6 00             	movzbl (%rax),%eax
  8010b7:	84 c0                	test   %al,%al
  8010b9:	75 de                	jne    801099 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c0:	c9                   	leaveq 
  8010c1:	c3                   	retq   

00000000008010c2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010c2:	55                   	push   %rbp
  8010c3:	48 89 e5             	mov    %rsp,%rbp
  8010c6:	48 83 ec 0c          	sub    $0xc,%rsp
  8010ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010ce:	89 f0                	mov    %esi,%eax
  8010d0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010d3:	eb 13                	jmp    8010e8 <strfind+0x26>
		if (*s == c)
  8010d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d9:	0f b6 00             	movzbl (%rax),%eax
  8010dc:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010df:	75 02                	jne    8010e3 <strfind+0x21>
			break;
  8010e1:	eb 10                	jmp    8010f3 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ec:	0f b6 00             	movzbl (%rax),%eax
  8010ef:	84 c0                	test   %al,%al
  8010f1:	75 e2                	jne    8010d5 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010f7:	c9                   	leaveq 
  8010f8:	c3                   	retq   

00000000008010f9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010f9:	55                   	push   %rbp
  8010fa:	48 89 e5             	mov    %rsp,%rbp
  8010fd:	48 83 ec 18          	sub    $0x18,%rsp
  801101:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801105:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801108:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80110c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801111:	75 06                	jne    801119 <memset+0x20>
		return v;
  801113:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801117:	eb 69                	jmp    801182 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801119:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111d:	83 e0 03             	and    $0x3,%eax
  801120:	48 85 c0             	test   %rax,%rax
  801123:	75 48                	jne    80116d <memset+0x74>
  801125:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801129:	83 e0 03             	and    $0x3,%eax
  80112c:	48 85 c0             	test   %rax,%rax
  80112f:	75 3c                	jne    80116d <memset+0x74>
		c &= 0xFF;
  801131:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801138:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80113b:	c1 e0 18             	shl    $0x18,%eax
  80113e:	89 c2                	mov    %eax,%edx
  801140:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801143:	c1 e0 10             	shl    $0x10,%eax
  801146:	09 c2                	or     %eax,%edx
  801148:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80114b:	c1 e0 08             	shl    $0x8,%eax
  80114e:	09 d0                	or     %edx,%eax
  801150:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801153:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801157:	48 c1 e8 02          	shr    $0x2,%rax
  80115b:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80115e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801162:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801165:	48 89 d7             	mov    %rdx,%rdi
  801168:	fc                   	cld    
  801169:	f3 ab                	rep stos %eax,%es:(%rdi)
  80116b:	eb 11                	jmp    80117e <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80116d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801171:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801174:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801178:	48 89 d7             	mov    %rdx,%rdi
  80117b:	fc                   	cld    
  80117c:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80117e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801182:	c9                   	leaveq 
  801183:	c3                   	retq   

0000000000801184 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801184:	55                   	push   %rbp
  801185:	48 89 e5             	mov    %rsp,%rbp
  801188:	48 83 ec 28          	sub    $0x28,%rsp
  80118c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801190:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801194:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801198:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80119c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ac:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011b0:	0f 83 88 00 00 00    	jae    80123e <memmove+0xba>
  8011b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011ba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011be:	48 01 d0             	add    %rdx,%rax
  8011c1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011c5:	76 77                	jbe    80123e <memmove+0xba>
		s += n;
  8011c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011cb:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d3:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011db:	83 e0 03             	and    $0x3,%eax
  8011de:	48 85 c0             	test   %rax,%rax
  8011e1:	75 3b                	jne    80121e <memmove+0x9a>
  8011e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e7:	83 e0 03             	and    $0x3,%eax
  8011ea:	48 85 c0             	test   %rax,%rax
  8011ed:	75 2f                	jne    80121e <memmove+0x9a>
  8011ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f3:	83 e0 03             	and    $0x3,%eax
  8011f6:	48 85 c0             	test   %rax,%rax
  8011f9:	75 23                	jne    80121e <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ff:	48 83 e8 04          	sub    $0x4,%rax
  801203:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801207:	48 83 ea 04          	sub    $0x4,%rdx
  80120b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80120f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801213:	48 89 c7             	mov    %rax,%rdi
  801216:	48 89 d6             	mov    %rdx,%rsi
  801219:	fd                   	std    
  80121a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80121c:	eb 1d                	jmp    80123b <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80121e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801222:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801226:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122a:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80122e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801232:	48 89 d7             	mov    %rdx,%rdi
  801235:	48 89 c1             	mov    %rax,%rcx
  801238:	fd                   	std    
  801239:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80123b:	fc                   	cld    
  80123c:	eb 57                	jmp    801295 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80123e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801242:	83 e0 03             	and    $0x3,%eax
  801245:	48 85 c0             	test   %rax,%rax
  801248:	75 36                	jne    801280 <memmove+0xfc>
  80124a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124e:	83 e0 03             	and    $0x3,%eax
  801251:	48 85 c0             	test   %rax,%rax
  801254:	75 2a                	jne    801280 <memmove+0xfc>
  801256:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80125a:	83 e0 03             	and    $0x3,%eax
  80125d:	48 85 c0             	test   %rax,%rax
  801260:	75 1e                	jne    801280 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801262:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801266:	48 c1 e8 02          	shr    $0x2,%rax
  80126a:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80126d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801271:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801275:	48 89 c7             	mov    %rax,%rdi
  801278:	48 89 d6             	mov    %rdx,%rsi
  80127b:	fc                   	cld    
  80127c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80127e:	eb 15                	jmp    801295 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801284:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801288:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80128c:	48 89 c7             	mov    %rax,%rdi
  80128f:	48 89 d6             	mov    %rdx,%rsi
  801292:	fc                   	cld    
  801293:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801295:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801299:	c9                   	leaveq 
  80129a:	c3                   	retq   

000000000080129b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80129b:	55                   	push   %rbp
  80129c:	48 89 e5             	mov    %rsp,%rbp
  80129f:	48 83 ec 18          	sub    $0x18,%rsp
  8012a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012b3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bb:	48 89 ce             	mov    %rcx,%rsi
  8012be:	48 89 c7             	mov    %rax,%rdi
  8012c1:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  8012c8:	00 00 00 
  8012cb:	ff d0                	callq  *%rax
}
  8012cd:	c9                   	leaveq 
  8012ce:	c3                   	retq   

00000000008012cf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012cf:	55                   	push   %rbp
  8012d0:	48 89 e5             	mov    %rsp,%rbp
  8012d3:	48 83 ec 28          	sub    $0x28,%rsp
  8012d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012f3:	eb 36                	jmp    80132b <memcmp+0x5c>
		if (*s1 != *s2)
  8012f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f9:	0f b6 10             	movzbl (%rax),%edx
  8012fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801300:	0f b6 00             	movzbl (%rax),%eax
  801303:	38 c2                	cmp    %al,%dl
  801305:	74 1a                	je     801321 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130b:	0f b6 00             	movzbl (%rax),%eax
  80130e:	0f b6 d0             	movzbl %al,%edx
  801311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801315:	0f b6 00             	movzbl (%rax),%eax
  801318:	0f b6 c0             	movzbl %al,%eax
  80131b:	29 c2                	sub    %eax,%edx
  80131d:	89 d0                	mov    %edx,%eax
  80131f:	eb 20                	jmp    801341 <memcmp+0x72>
		s1++, s2++;
  801321:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801326:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80132b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80132f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801333:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801337:	48 85 c0             	test   %rax,%rax
  80133a:	75 b9                	jne    8012f5 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80133c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801341:	c9                   	leaveq 
  801342:	c3                   	retq   

0000000000801343 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801343:	55                   	push   %rbp
  801344:	48 89 e5             	mov    %rsp,%rbp
  801347:	48 83 ec 28          	sub    $0x28,%rsp
  80134b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80134f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801352:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801356:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80135e:	48 01 d0             	add    %rdx,%rax
  801361:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801365:	eb 15                	jmp    80137c <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136b:	0f b6 10             	movzbl (%rax),%edx
  80136e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801371:	38 c2                	cmp    %al,%dl
  801373:	75 02                	jne    801377 <memfind+0x34>
			break;
  801375:	eb 0f                	jmp    801386 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801377:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80137c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801380:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801384:	72 e1                	jb     801367 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801386:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80138a:	c9                   	leaveq 
  80138b:	c3                   	retq   

000000000080138c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80138c:	55                   	push   %rbp
  80138d:	48 89 e5             	mov    %rsp,%rbp
  801390:	48 83 ec 34          	sub    $0x34,%rsp
  801394:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801398:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80139c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80139f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013a6:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013ad:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013ae:	eb 05                	jmp    8013b5 <strtol+0x29>
		s++;
  8013b0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b9:	0f b6 00             	movzbl (%rax),%eax
  8013bc:	3c 20                	cmp    $0x20,%al
  8013be:	74 f0                	je     8013b0 <strtol+0x24>
  8013c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c4:	0f b6 00             	movzbl (%rax),%eax
  8013c7:	3c 09                	cmp    $0x9,%al
  8013c9:	74 e5                	je     8013b0 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cf:	0f b6 00             	movzbl (%rax),%eax
  8013d2:	3c 2b                	cmp    $0x2b,%al
  8013d4:	75 07                	jne    8013dd <strtol+0x51>
		s++;
  8013d6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013db:	eb 17                	jmp    8013f4 <strtol+0x68>
	else if (*s == '-')
  8013dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e1:	0f b6 00             	movzbl (%rax),%eax
  8013e4:	3c 2d                	cmp    $0x2d,%al
  8013e6:	75 0c                	jne    8013f4 <strtol+0x68>
		s++, neg = 1;
  8013e8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013ed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013f4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013f8:	74 06                	je     801400 <strtol+0x74>
  8013fa:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013fe:	75 28                	jne    801428 <strtol+0x9c>
  801400:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801404:	0f b6 00             	movzbl (%rax),%eax
  801407:	3c 30                	cmp    $0x30,%al
  801409:	75 1d                	jne    801428 <strtol+0x9c>
  80140b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140f:	48 83 c0 01          	add    $0x1,%rax
  801413:	0f b6 00             	movzbl (%rax),%eax
  801416:	3c 78                	cmp    $0x78,%al
  801418:	75 0e                	jne    801428 <strtol+0x9c>
		s += 2, base = 16;
  80141a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80141f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801426:	eb 2c                	jmp    801454 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801428:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80142c:	75 19                	jne    801447 <strtol+0xbb>
  80142e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801432:	0f b6 00             	movzbl (%rax),%eax
  801435:	3c 30                	cmp    $0x30,%al
  801437:	75 0e                	jne    801447 <strtol+0xbb>
		s++, base = 8;
  801439:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80143e:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801445:	eb 0d                	jmp    801454 <strtol+0xc8>
	else if (base == 0)
  801447:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80144b:	75 07                	jne    801454 <strtol+0xc8>
		base = 10;
  80144d:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801458:	0f b6 00             	movzbl (%rax),%eax
  80145b:	3c 2f                	cmp    $0x2f,%al
  80145d:	7e 1d                	jle    80147c <strtol+0xf0>
  80145f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801463:	0f b6 00             	movzbl (%rax),%eax
  801466:	3c 39                	cmp    $0x39,%al
  801468:	7f 12                	jg     80147c <strtol+0xf0>
			dig = *s - '0';
  80146a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146e:	0f b6 00             	movzbl (%rax),%eax
  801471:	0f be c0             	movsbl %al,%eax
  801474:	83 e8 30             	sub    $0x30,%eax
  801477:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80147a:	eb 4e                	jmp    8014ca <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80147c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801480:	0f b6 00             	movzbl (%rax),%eax
  801483:	3c 60                	cmp    $0x60,%al
  801485:	7e 1d                	jle    8014a4 <strtol+0x118>
  801487:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148b:	0f b6 00             	movzbl (%rax),%eax
  80148e:	3c 7a                	cmp    $0x7a,%al
  801490:	7f 12                	jg     8014a4 <strtol+0x118>
			dig = *s - 'a' + 10;
  801492:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801496:	0f b6 00             	movzbl (%rax),%eax
  801499:	0f be c0             	movsbl %al,%eax
  80149c:	83 e8 57             	sub    $0x57,%eax
  80149f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014a2:	eb 26                	jmp    8014ca <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a8:	0f b6 00             	movzbl (%rax),%eax
  8014ab:	3c 40                	cmp    $0x40,%al
  8014ad:	7e 48                	jle    8014f7 <strtol+0x16b>
  8014af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b3:	0f b6 00             	movzbl (%rax),%eax
  8014b6:	3c 5a                	cmp    $0x5a,%al
  8014b8:	7f 3d                	jg     8014f7 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8014ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014be:	0f b6 00             	movzbl (%rax),%eax
  8014c1:	0f be c0             	movsbl %al,%eax
  8014c4:	83 e8 37             	sub    $0x37,%eax
  8014c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014cd:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014d0:	7c 02                	jl     8014d4 <strtol+0x148>
			break;
  8014d2:	eb 23                	jmp    8014f7 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8014d4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014d9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014dc:	48 98                	cltq   
  8014de:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014e3:	48 89 c2             	mov    %rax,%rdx
  8014e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014e9:	48 98                	cltq   
  8014eb:	48 01 d0             	add    %rdx,%rax
  8014ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014f2:	e9 5d ff ff ff       	jmpq   801454 <strtol+0xc8>

	if (endptr)
  8014f7:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014fc:	74 0b                	je     801509 <strtol+0x17d>
		*endptr = (char *) s;
  8014fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801502:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801506:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801509:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80150d:	74 09                	je     801518 <strtol+0x18c>
  80150f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801513:	48 f7 d8             	neg    %rax
  801516:	eb 04                	jmp    80151c <strtol+0x190>
  801518:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80151c:	c9                   	leaveq 
  80151d:	c3                   	retq   

000000000080151e <strstr>:

char * strstr(const char *in, const char *str)
{
  80151e:	55                   	push   %rbp
  80151f:	48 89 e5             	mov    %rsp,%rbp
  801522:	48 83 ec 30          	sub    $0x30,%rsp
  801526:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80152a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80152e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801532:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801536:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80153a:	0f b6 00             	movzbl (%rax),%eax
  80153d:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801540:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801544:	75 06                	jne    80154c <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801546:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154a:	eb 6b                	jmp    8015b7 <strstr+0x99>

	len = strlen(str);
  80154c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801550:	48 89 c7             	mov    %rax,%rdi
  801553:	48 b8 f4 0d 80 00 00 	movabs $0x800df4,%rax
  80155a:	00 00 00 
  80155d:	ff d0                	callq  *%rax
  80155f:	48 98                	cltq   
  801561:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801565:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801569:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80156d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801571:	0f b6 00             	movzbl (%rax),%eax
  801574:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801577:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80157b:	75 07                	jne    801584 <strstr+0x66>
				return (char *) 0;
  80157d:	b8 00 00 00 00       	mov    $0x0,%eax
  801582:	eb 33                	jmp    8015b7 <strstr+0x99>
		} while (sc != c);
  801584:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801588:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80158b:	75 d8                	jne    801565 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80158d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801591:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801595:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801599:	48 89 ce             	mov    %rcx,%rsi
  80159c:	48 89 c7             	mov    %rax,%rdi
  80159f:	48 b8 15 10 80 00 00 	movabs $0x801015,%rax
  8015a6:	00 00 00 
  8015a9:	ff d0                	callq  *%rax
  8015ab:	85 c0                	test   %eax,%eax
  8015ad:	75 b6                	jne    801565 <strstr+0x47>

	return (char *) (in - 1);
  8015af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b3:	48 83 e8 01          	sub    $0x1,%rax
}
  8015b7:	c9                   	leaveq 
  8015b8:	c3                   	retq   

00000000008015b9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015b9:	55                   	push   %rbp
  8015ba:	48 89 e5             	mov    %rsp,%rbp
  8015bd:	53                   	push   %rbx
  8015be:	48 83 ec 48          	sub    $0x48,%rsp
  8015c2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015c5:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015c8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015cc:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015d0:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015d4:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015d8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015db:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015df:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015e3:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015e7:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015eb:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015ef:	4c 89 c3             	mov    %r8,%rbx
  8015f2:	cd 30                	int    $0x30
  8015f4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015f8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015fc:	74 3e                	je     80163c <syscall+0x83>
  8015fe:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801603:	7e 37                	jle    80163c <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801605:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801609:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80160c:	49 89 d0             	mov    %rdx,%r8
  80160f:	89 c1                	mov    %eax,%ecx
  801611:	48 ba e8 3b 80 00 00 	movabs $0x803be8,%rdx
  801618:	00 00 00 
  80161b:	be 23 00 00 00       	mov    $0x23,%esi
  801620:	48 bf 05 3c 80 00 00 	movabs $0x803c05,%rdi
  801627:	00 00 00 
  80162a:	b8 00 00 00 00       	mov    $0x0,%eax
  80162f:	49 b9 0a 33 80 00 00 	movabs $0x80330a,%r9
  801636:	00 00 00 
  801639:	41 ff d1             	callq  *%r9

	return ret;
  80163c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801640:	48 83 c4 48          	add    $0x48,%rsp
  801644:	5b                   	pop    %rbx
  801645:	5d                   	pop    %rbp
  801646:	c3                   	retq   

0000000000801647 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801647:	55                   	push   %rbp
  801648:	48 89 e5             	mov    %rsp,%rbp
  80164b:	48 83 ec 20          	sub    $0x20,%rsp
  80164f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801653:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801657:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80165f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801666:	00 
  801667:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80166d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801673:	48 89 d1             	mov    %rdx,%rcx
  801676:	48 89 c2             	mov    %rax,%rdx
  801679:	be 00 00 00 00       	mov    $0x0,%esi
  80167e:	bf 00 00 00 00       	mov    $0x0,%edi
  801683:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  80168a:	00 00 00 
  80168d:	ff d0                	callq  *%rax
}
  80168f:	c9                   	leaveq 
  801690:	c3                   	retq   

0000000000801691 <sys_cgetc>:

int
sys_cgetc(void)
{
  801691:	55                   	push   %rbp
  801692:	48 89 e5             	mov    %rsp,%rbp
  801695:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801699:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016a0:	00 
  8016a1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016a7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b7:	be 00 00 00 00       	mov    $0x0,%esi
  8016bc:	bf 01 00 00 00       	mov    $0x1,%edi
  8016c1:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  8016c8:	00 00 00 
  8016cb:	ff d0                	callq  *%rax
}
  8016cd:	c9                   	leaveq 
  8016ce:	c3                   	retq   

00000000008016cf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016cf:	55                   	push   %rbp
  8016d0:	48 89 e5             	mov    %rsp,%rbp
  8016d3:	48 83 ec 10          	sub    $0x10,%rsp
  8016d7:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016dd:	48 98                	cltq   
  8016df:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016e6:	00 
  8016e7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016f8:	48 89 c2             	mov    %rax,%rdx
  8016fb:	be 01 00 00 00       	mov    $0x1,%esi
  801700:	bf 03 00 00 00       	mov    $0x3,%edi
  801705:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  80170c:	00 00 00 
  80170f:	ff d0                	callq  *%rax
}
  801711:	c9                   	leaveq 
  801712:	c3                   	retq   

0000000000801713 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801713:	55                   	push   %rbp
  801714:	48 89 e5             	mov    %rsp,%rbp
  801717:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80171b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801722:	00 
  801723:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801729:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80172f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801734:	ba 00 00 00 00       	mov    $0x0,%edx
  801739:	be 00 00 00 00       	mov    $0x0,%esi
  80173e:	bf 02 00 00 00       	mov    $0x2,%edi
  801743:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  80174a:	00 00 00 
  80174d:	ff d0                	callq  *%rax
}
  80174f:	c9                   	leaveq 
  801750:	c3                   	retq   

0000000000801751 <sys_yield>:

void
sys_yield(void)
{
  801751:	55                   	push   %rbp
  801752:	48 89 e5             	mov    %rsp,%rbp
  801755:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801759:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801760:	00 
  801761:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801767:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80176d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801772:	ba 00 00 00 00       	mov    $0x0,%edx
  801777:	be 00 00 00 00       	mov    $0x0,%esi
  80177c:	bf 0b 00 00 00       	mov    $0xb,%edi
  801781:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  801788:	00 00 00 
  80178b:	ff d0                	callq  *%rax
}
  80178d:	c9                   	leaveq 
  80178e:	c3                   	retq   

000000000080178f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80178f:	55                   	push   %rbp
  801790:	48 89 e5             	mov    %rsp,%rbp
  801793:	48 83 ec 20          	sub    $0x20,%rsp
  801797:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80179a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80179e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017a1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017a4:	48 63 c8             	movslq %eax,%rcx
  8017a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017ae:	48 98                	cltq   
  8017b0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017b7:	00 
  8017b8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017be:	49 89 c8             	mov    %rcx,%r8
  8017c1:	48 89 d1             	mov    %rdx,%rcx
  8017c4:	48 89 c2             	mov    %rax,%rdx
  8017c7:	be 01 00 00 00       	mov    $0x1,%esi
  8017cc:	bf 04 00 00 00       	mov    $0x4,%edi
  8017d1:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  8017d8:	00 00 00 
  8017db:	ff d0                	callq  *%rax
}
  8017dd:	c9                   	leaveq 
  8017de:	c3                   	retq   

00000000008017df <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017df:	55                   	push   %rbp
  8017e0:	48 89 e5             	mov    %rsp,%rbp
  8017e3:	48 83 ec 30          	sub    $0x30,%rsp
  8017e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017ee:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017f1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017f5:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017f9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017fc:	48 63 c8             	movslq %eax,%rcx
  8017ff:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801803:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801806:	48 63 f0             	movslq %eax,%rsi
  801809:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80180d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801810:	48 98                	cltq   
  801812:	48 89 0c 24          	mov    %rcx,(%rsp)
  801816:	49 89 f9             	mov    %rdi,%r9
  801819:	49 89 f0             	mov    %rsi,%r8
  80181c:	48 89 d1             	mov    %rdx,%rcx
  80181f:	48 89 c2             	mov    %rax,%rdx
  801822:	be 01 00 00 00       	mov    $0x1,%esi
  801827:	bf 05 00 00 00       	mov    $0x5,%edi
  80182c:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  801833:	00 00 00 
  801836:	ff d0                	callq  *%rax
}
  801838:	c9                   	leaveq 
  801839:	c3                   	retq   

000000000080183a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80183a:	55                   	push   %rbp
  80183b:	48 89 e5             	mov    %rsp,%rbp
  80183e:	48 83 ec 20          	sub    $0x20,%rsp
  801842:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801845:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801849:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80184d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801850:	48 98                	cltq   
  801852:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801859:	00 
  80185a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801860:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801866:	48 89 d1             	mov    %rdx,%rcx
  801869:	48 89 c2             	mov    %rax,%rdx
  80186c:	be 01 00 00 00       	mov    $0x1,%esi
  801871:	bf 06 00 00 00       	mov    $0x6,%edi
  801876:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  80187d:	00 00 00 
  801880:	ff d0                	callq  *%rax
}
  801882:	c9                   	leaveq 
  801883:	c3                   	retq   

0000000000801884 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801884:	55                   	push   %rbp
  801885:	48 89 e5             	mov    %rsp,%rbp
  801888:	48 83 ec 10          	sub    $0x10,%rsp
  80188c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80188f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801892:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801895:	48 63 d0             	movslq %eax,%rdx
  801898:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80189b:	48 98                	cltq   
  80189d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a4:	00 
  8018a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b1:	48 89 d1             	mov    %rdx,%rcx
  8018b4:	48 89 c2             	mov    %rax,%rdx
  8018b7:	be 01 00 00 00       	mov    $0x1,%esi
  8018bc:	bf 08 00 00 00       	mov    $0x8,%edi
  8018c1:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  8018c8:	00 00 00 
  8018cb:	ff d0                	callq  *%rax
}
  8018cd:	c9                   	leaveq 
  8018ce:	c3                   	retq   

00000000008018cf <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8018cf:	55                   	push   %rbp
  8018d0:	48 89 e5             	mov    %rsp,%rbp
  8018d3:	48 83 ec 20          	sub    $0x20,%rsp
  8018d7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8018de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e5:	48 98                	cltq   
  8018e7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ee:	00 
  8018ef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018fb:	48 89 d1             	mov    %rdx,%rcx
  8018fe:	48 89 c2             	mov    %rax,%rdx
  801901:	be 01 00 00 00       	mov    $0x1,%esi
  801906:	bf 09 00 00 00       	mov    $0x9,%edi
  80190b:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  801912:	00 00 00 
  801915:	ff d0                	callq  *%rax
}
  801917:	c9                   	leaveq 
  801918:	c3                   	retq   

0000000000801919 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801919:	55                   	push   %rbp
  80191a:	48 89 e5             	mov    %rsp,%rbp
  80191d:	48 83 ec 20          	sub    $0x20,%rsp
  801921:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801924:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801928:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80192c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192f:	48 98                	cltq   
  801931:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801938:	00 
  801939:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801945:	48 89 d1             	mov    %rdx,%rcx
  801948:	48 89 c2             	mov    %rax,%rdx
  80194b:	be 01 00 00 00       	mov    $0x1,%esi
  801950:	bf 0a 00 00 00       	mov    $0xa,%edi
  801955:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  80195c:	00 00 00 
  80195f:	ff d0                	callq  *%rax
}
  801961:	c9                   	leaveq 
  801962:	c3                   	retq   

0000000000801963 <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801963:	55                   	push   %rbp
  801964:	48 89 e5             	mov    %rsp,%rbp
  801967:	48 83 ec 10          	sub    $0x10,%rsp
  80196b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80196e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801971:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801974:	48 63 d0             	movslq %eax,%rdx
  801977:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197a:	48 98                	cltq   
  80197c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801983:	00 
  801984:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801990:	48 89 d1             	mov    %rdx,%rcx
  801993:	48 89 c2             	mov    %rax,%rdx
  801996:	be 01 00 00 00       	mov    $0x1,%esi
  80199b:	bf 11 00 00 00       	mov    $0x11,%edi
  8019a0:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  8019a7:	00 00 00 
  8019aa:	ff d0                	callq  *%rax

}
  8019ac:	c9                   	leaveq 
  8019ad:	c3                   	retq   

00000000008019ae <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019ae:	55                   	push   %rbp
  8019af:	48 89 e5             	mov    %rsp,%rbp
  8019b2:	48 83 ec 20          	sub    $0x20,%rsp
  8019b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019bd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019c1:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c7:	48 63 f0             	movslq %eax,%rsi
  8019ca:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d1:	48 98                	cltq   
  8019d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019de:	00 
  8019df:	49 89 f1             	mov    %rsi,%r9
  8019e2:	49 89 c8             	mov    %rcx,%r8
  8019e5:	48 89 d1             	mov    %rdx,%rcx
  8019e8:	48 89 c2             	mov    %rax,%rdx
  8019eb:	be 00 00 00 00       	mov    $0x0,%esi
  8019f0:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019f5:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  8019fc:	00 00 00 
  8019ff:	ff d0                	callq  *%rax
}
  801a01:	c9                   	leaveq 
  801a02:	c3                   	retq   

0000000000801a03 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a03:	55                   	push   %rbp
  801a04:	48 89 e5             	mov    %rsp,%rbp
  801a07:	48 83 ec 10          	sub    $0x10,%rsp
  801a0b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a13:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1a:	00 
  801a1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a21:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a27:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a2c:	48 89 c2             	mov    %rax,%rdx
  801a2f:	be 01 00 00 00       	mov    $0x1,%esi
  801a34:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a39:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  801a40:	00 00 00 
  801a43:	ff d0                	callq  *%rax
}
  801a45:	c9                   	leaveq 
  801a46:	c3                   	retq   

0000000000801a47 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801a47:	55                   	push   %rbp
  801a48:	48 89 e5             	mov    %rsp,%rbp
  801a4b:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801a4f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a56:	00 
  801a57:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a63:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a68:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6d:	be 00 00 00 00       	mov    $0x0,%esi
  801a72:	bf 0e 00 00 00       	mov    $0xe,%edi
  801a77:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  801a7e:	00 00 00 
  801a81:	ff d0                	callq  *%rax
}
  801a83:	c9                   	leaveq 
  801a84:	c3                   	retq   

0000000000801a85 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801a85:	55                   	push   %rbp
  801a86:	48 89 e5             	mov    %rsp,%rbp
  801a89:	48 83 ec 30          	sub    $0x30,%rsp
  801a8d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a90:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a94:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a97:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a9b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801a9f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801aa2:	48 63 c8             	movslq %eax,%rcx
  801aa5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801aa9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aac:	48 63 f0             	movslq %eax,%rsi
  801aaf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab6:	48 98                	cltq   
  801ab8:	48 89 0c 24          	mov    %rcx,(%rsp)
  801abc:	49 89 f9             	mov    %rdi,%r9
  801abf:	49 89 f0             	mov    %rsi,%r8
  801ac2:	48 89 d1             	mov    %rdx,%rcx
  801ac5:	48 89 c2             	mov    %rax,%rdx
  801ac8:	be 00 00 00 00       	mov    $0x0,%esi
  801acd:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ad2:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  801ad9:	00 00 00 
  801adc:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801ade:	c9                   	leaveq 
  801adf:	c3                   	retq   

0000000000801ae0 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801ae0:	55                   	push   %rbp
  801ae1:	48 89 e5             	mov    %rsp,%rbp
  801ae4:	48 83 ec 20          	sub    $0x20,%rsp
  801ae8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801af0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aff:	00 
  801b00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b0c:	48 89 d1             	mov    %rdx,%rcx
  801b0f:	48 89 c2             	mov    %rax,%rdx
  801b12:	be 00 00 00 00       	mov    $0x0,%esi
  801b17:	bf 10 00 00 00       	mov    $0x10,%edi
  801b1c:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  801b23:	00 00 00 
  801b26:	ff d0                	callq  *%rax
}
  801b28:	c9                   	leaveq 
  801b29:	c3                   	retq   

0000000000801b2a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801b2a:	55                   	push   %rbp
  801b2b:	48 89 e5             	mov    %rsp,%rbp
  801b2e:	48 83 ec 08          	sub    $0x8,%rsp
  801b32:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801b36:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b3a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b41:	ff ff ff 
  801b44:	48 01 d0             	add    %rdx,%rax
  801b47:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801b4b:	c9                   	leaveq 
  801b4c:	c3                   	retq   

0000000000801b4d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801b4d:	55                   	push   %rbp
  801b4e:	48 89 e5             	mov    %rsp,%rbp
  801b51:	48 83 ec 08          	sub    $0x8,%rsp
  801b55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801b59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5d:	48 89 c7             	mov    %rax,%rdi
  801b60:	48 b8 2a 1b 80 00 00 	movabs $0x801b2a,%rax
  801b67:	00 00 00 
  801b6a:	ff d0                	callq  *%rax
  801b6c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b72:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b76:	c9                   	leaveq 
  801b77:	c3                   	retq   

0000000000801b78 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801b78:	55                   	push   %rbp
  801b79:	48 89 e5             	mov    %rsp,%rbp
  801b7c:	48 83 ec 18          	sub    $0x18,%rsp
  801b80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b8b:	eb 6b                	jmp    801bf8 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801b8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b90:	48 98                	cltq   
  801b92:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801b98:	48 c1 e0 0c          	shl    $0xc,%rax
  801b9c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ba0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ba4:	48 c1 e8 15          	shr    $0x15,%rax
  801ba8:	48 89 c2             	mov    %rax,%rdx
  801bab:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801bb2:	01 00 00 
  801bb5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bb9:	83 e0 01             	and    $0x1,%eax
  801bbc:	48 85 c0             	test   %rax,%rax
  801bbf:	74 21                	je     801be2 <fd_alloc+0x6a>
  801bc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bc5:	48 c1 e8 0c          	shr    $0xc,%rax
  801bc9:	48 89 c2             	mov    %rax,%rdx
  801bcc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bd3:	01 00 00 
  801bd6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bda:	83 e0 01             	and    $0x1,%eax
  801bdd:	48 85 c0             	test   %rax,%rax
  801be0:	75 12                	jne    801bf4 <fd_alloc+0x7c>
			*fd_store = fd;
  801be2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bea:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801bed:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf2:	eb 1a                	jmp    801c0e <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801bf4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801bf8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801bfc:	7e 8f                	jle    801b8d <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801bfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c02:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801c09:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801c0e:	c9                   	leaveq 
  801c0f:	c3                   	retq   

0000000000801c10 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c10:	55                   	push   %rbp
  801c11:	48 89 e5             	mov    %rsp,%rbp
  801c14:	48 83 ec 20          	sub    $0x20,%rsp
  801c18:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801c1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c23:	78 06                	js     801c2b <fd_lookup+0x1b>
  801c25:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801c29:	7e 07                	jle    801c32 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c30:	eb 6c                	jmp    801c9e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801c32:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c35:	48 98                	cltq   
  801c37:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c3d:	48 c1 e0 0c          	shl    $0xc,%rax
  801c41:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801c45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c49:	48 c1 e8 15          	shr    $0x15,%rax
  801c4d:	48 89 c2             	mov    %rax,%rdx
  801c50:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c57:	01 00 00 
  801c5a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c5e:	83 e0 01             	and    $0x1,%eax
  801c61:	48 85 c0             	test   %rax,%rax
  801c64:	74 21                	je     801c87 <fd_lookup+0x77>
  801c66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c6a:	48 c1 e8 0c          	shr    $0xc,%rax
  801c6e:	48 89 c2             	mov    %rax,%rdx
  801c71:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c78:	01 00 00 
  801c7b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c7f:	83 e0 01             	and    $0x1,%eax
  801c82:	48 85 c0             	test   %rax,%rax
  801c85:	75 07                	jne    801c8e <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c8c:	eb 10                	jmp    801c9e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801c8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c92:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c96:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9e:	c9                   	leaveq 
  801c9f:	c3                   	retq   

0000000000801ca0 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ca0:	55                   	push   %rbp
  801ca1:	48 89 e5             	mov    %rsp,%rbp
  801ca4:	48 83 ec 30          	sub    $0x30,%rsp
  801ca8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801cac:	89 f0                	mov    %esi,%eax
  801cae:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801cb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb5:	48 89 c7             	mov    %rax,%rdi
  801cb8:	48 b8 2a 1b 80 00 00 	movabs $0x801b2a,%rax
  801cbf:	00 00 00 
  801cc2:	ff d0                	callq  *%rax
  801cc4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801cc8:	48 89 d6             	mov    %rdx,%rsi
  801ccb:	89 c7                	mov    %eax,%edi
  801ccd:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  801cd4:	00 00 00 
  801cd7:	ff d0                	callq  *%rax
  801cd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ce0:	78 0a                	js     801cec <fd_close+0x4c>
	    || fd != fd2)
  801ce2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce6:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801cea:	74 12                	je     801cfe <fd_close+0x5e>
		return (must_exist ? r : 0);
  801cec:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801cf0:	74 05                	je     801cf7 <fd_close+0x57>
  801cf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf5:	eb 05                	jmp    801cfc <fd_close+0x5c>
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfc:	eb 69                	jmp    801d67 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801cfe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d02:	8b 00                	mov    (%rax),%eax
  801d04:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d08:	48 89 d6             	mov    %rdx,%rsi
  801d0b:	89 c7                	mov    %eax,%edi
  801d0d:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  801d14:	00 00 00 
  801d17:	ff d0                	callq  *%rax
  801d19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d20:	78 2a                	js     801d4c <fd_close+0xac>
		if (dev->dev_close)
  801d22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d26:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d2a:	48 85 c0             	test   %rax,%rax
  801d2d:	74 16                	je     801d45 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801d2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d33:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d37:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d3b:	48 89 d7             	mov    %rdx,%rdi
  801d3e:	ff d0                	callq  *%rax
  801d40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d43:	eb 07                	jmp    801d4c <fd_close+0xac>
		else
			r = 0;
  801d45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d50:	48 89 c6             	mov    %rax,%rsi
  801d53:	bf 00 00 00 00       	mov    $0x0,%edi
  801d58:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  801d5f:	00 00 00 
  801d62:	ff d0                	callq  *%rax
	return r;
  801d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d67:	c9                   	leaveq 
  801d68:	c3                   	retq   

0000000000801d69 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d69:	55                   	push   %rbp
  801d6a:	48 89 e5             	mov    %rsp,%rbp
  801d6d:	48 83 ec 20          	sub    $0x20,%rsp
  801d71:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801d78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d7f:	eb 41                	jmp    801dc2 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801d81:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801d88:	00 00 00 
  801d8b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d8e:	48 63 d2             	movslq %edx,%rdx
  801d91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d95:	8b 00                	mov    (%rax),%eax
  801d97:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801d9a:	75 22                	jne    801dbe <dev_lookup+0x55>
			*dev = devtab[i];
  801d9c:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801da3:	00 00 00 
  801da6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801da9:	48 63 d2             	movslq %edx,%rdx
  801dac:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801db0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801db4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbc:	eb 60                	jmp    801e1e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801dbe:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dc2:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801dc9:	00 00 00 
  801dcc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801dcf:	48 63 d2             	movslq %edx,%rdx
  801dd2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd6:	48 85 c0             	test   %rax,%rax
  801dd9:	75 a6                	jne    801d81 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ddb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801de2:	00 00 00 
  801de5:	48 8b 00             	mov    (%rax),%rax
  801de8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801dee:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801df1:	89 c6                	mov    %eax,%esi
  801df3:	48 bf 18 3c 80 00 00 	movabs $0x803c18,%rdi
  801dfa:	00 00 00 
  801dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801e02:	48 b9 6a 02 80 00 00 	movabs $0x80026a,%rcx
  801e09:	00 00 00 
  801e0c:	ff d1                	callq  *%rcx
	*dev = 0;
  801e0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e12:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801e19:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e1e:	c9                   	leaveq 
  801e1f:	c3                   	retq   

0000000000801e20 <close>:

int
close(int fdnum)
{
  801e20:	55                   	push   %rbp
  801e21:	48 89 e5             	mov    %rsp,%rbp
  801e24:	48 83 ec 20          	sub    $0x20,%rsp
  801e28:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e2b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e2f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e32:	48 89 d6             	mov    %rdx,%rsi
  801e35:	89 c7                	mov    %eax,%edi
  801e37:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  801e3e:	00 00 00 
  801e41:	ff d0                	callq  *%rax
  801e43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e4a:	79 05                	jns    801e51 <close+0x31>
		return r;
  801e4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4f:	eb 18                	jmp    801e69 <close+0x49>
	else
		return fd_close(fd, 1);
  801e51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e55:	be 01 00 00 00       	mov    $0x1,%esi
  801e5a:	48 89 c7             	mov    %rax,%rdi
  801e5d:	48 b8 a0 1c 80 00 00 	movabs $0x801ca0,%rax
  801e64:	00 00 00 
  801e67:	ff d0                	callq  *%rax
}
  801e69:	c9                   	leaveq 
  801e6a:	c3                   	retq   

0000000000801e6b <close_all>:

void
close_all(void)
{
  801e6b:	55                   	push   %rbp
  801e6c:	48 89 e5             	mov    %rsp,%rbp
  801e6f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e7a:	eb 15                	jmp    801e91 <close_all+0x26>
		close(i);
  801e7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e7f:	89 c7                	mov    %eax,%edi
  801e81:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  801e88:	00 00 00 
  801e8b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801e8d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e91:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e95:	7e e5                	jle    801e7c <close_all+0x11>
		close(i);
}
  801e97:	c9                   	leaveq 
  801e98:	c3                   	retq   

0000000000801e99 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801e99:	55                   	push   %rbp
  801e9a:	48 89 e5             	mov    %rsp,%rbp
  801e9d:	48 83 ec 40          	sub    $0x40,%rsp
  801ea1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801ea4:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ea7:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801eab:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801eae:	48 89 d6             	mov    %rdx,%rsi
  801eb1:	89 c7                	mov    %eax,%edi
  801eb3:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  801eba:	00 00 00 
  801ebd:	ff d0                	callq  *%rax
  801ebf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ec2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ec6:	79 08                	jns    801ed0 <dup+0x37>
		return r;
  801ec8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ecb:	e9 70 01 00 00       	jmpq   802040 <dup+0x1a7>
	close(newfdnum);
  801ed0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ed3:	89 c7                	mov    %eax,%edi
  801ed5:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  801edc:	00 00 00 
  801edf:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801ee1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ee4:	48 98                	cltq   
  801ee6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801eec:	48 c1 e0 0c          	shl    $0xc,%rax
  801ef0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801ef4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef8:	48 89 c7             	mov    %rax,%rdi
  801efb:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801f02:	00 00 00 
  801f05:	ff d0                	callq  *%rax
  801f07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801f0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f0f:	48 89 c7             	mov    %rax,%rdi
  801f12:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801f19:	00 00 00 
  801f1c:	ff d0                	callq  *%rax
  801f1e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f26:	48 c1 e8 15          	shr    $0x15,%rax
  801f2a:	48 89 c2             	mov    %rax,%rdx
  801f2d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f34:	01 00 00 
  801f37:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f3b:	83 e0 01             	and    $0x1,%eax
  801f3e:	48 85 c0             	test   %rax,%rax
  801f41:	74 73                	je     801fb6 <dup+0x11d>
  801f43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f47:	48 c1 e8 0c          	shr    $0xc,%rax
  801f4b:	48 89 c2             	mov    %rax,%rdx
  801f4e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f55:	01 00 00 
  801f58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f5c:	83 e0 01             	and    $0x1,%eax
  801f5f:	48 85 c0             	test   %rax,%rax
  801f62:	74 52                	je     801fb6 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f68:	48 c1 e8 0c          	shr    $0xc,%rax
  801f6c:	48 89 c2             	mov    %rax,%rdx
  801f6f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f76:	01 00 00 
  801f79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f7d:	25 07 0e 00 00       	and    $0xe07,%eax
  801f82:	89 c1                	mov    %eax,%ecx
  801f84:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801f88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f8c:	41 89 c8             	mov    %ecx,%r8d
  801f8f:	48 89 d1             	mov    %rdx,%rcx
  801f92:	ba 00 00 00 00       	mov    $0x0,%edx
  801f97:	48 89 c6             	mov    %rax,%rsi
  801f9a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f9f:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  801fa6:	00 00 00 
  801fa9:	ff d0                	callq  *%rax
  801fab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fb2:	79 02                	jns    801fb6 <dup+0x11d>
			goto err;
  801fb4:	eb 57                	jmp    80200d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801fb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fba:	48 c1 e8 0c          	shr    $0xc,%rax
  801fbe:	48 89 c2             	mov    %rax,%rdx
  801fc1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc8:	01 00 00 
  801fcb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fcf:	25 07 0e 00 00       	and    $0xe07,%eax
  801fd4:	89 c1                	mov    %eax,%ecx
  801fd6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fda:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fde:	41 89 c8             	mov    %ecx,%r8d
  801fe1:	48 89 d1             	mov    %rdx,%rcx
  801fe4:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe9:	48 89 c6             	mov    %rax,%rsi
  801fec:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff1:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  801ff8:	00 00 00 
  801ffb:	ff d0                	callq  *%rax
  801ffd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802000:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802004:	79 02                	jns    802008 <dup+0x16f>
		goto err;
  802006:	eb 05                	jmp    80200d <dup+0x174>

	return newfdnum;
  802008:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80200b:	eb 33                	jmp    802040 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80200d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802011:	48 89 c6             	mov    %rax,%rsi
  802014:	bf 00 00 00 00       	mov    $0x0,%edi
  802019:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  802020:	00 00 00 
  802023:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802025:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802029:	48 89 c6             	mov    %rax,%rsi
  80202c:	bf 00 00 00 00       	mov    $0x0,%edi
  802031:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  802038:	00 00 00 
  80203b:	ff d0                	callq  *%rax
	return r;
  80203d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802040:	c9                   	leaveq 
  802041:	c3                   	retq   

0000000000802042 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802042:	55                   	push   %rbp
  802043:	48 89 e5             	mov    %rsp,%rbp
  802046:	48 83 ec 40          	sub    $0x40,%rsp
  80204a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80204d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802051:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802055:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802059:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80205c:	48 89 d6             	mov    %rdx,%rsi
  80205f:	89 c7                	mov    %eax,%edi
  802061:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  802068:	00 00 00 
  80206b:	ff d0                	callq  *%rax
  80206d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802074:	78 24                	js     80209a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802076:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207a:	8b 00                	mov    (%rax),%eax
  80207c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802080:	48 89 d6             	mov    %rdx,%rsi
  802083:	89 c7                	mov    %eax,%edi
  802085:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  80208c:	00 00 00 
  80208f:	ff d0                	callq  *%rax
  802091:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802094:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802098:	79 05                	jns    80209f <read+0x5d>
		return r;
  80209a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80209d:	eb 76                	jmp    802115 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80209f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a3:	8b 40 08             	mov    0x8(%rax),%eax
  8020a6:	83 e0 03             	and    $0x3,%eax
  8020a9:	83 f8 01             	cmp    $0x1,%eax
  8020ac:	75 3a                	jne    8020e8 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8020ae:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8020b5:	00 00 00 
  8020b8:	48 8b 00             	mov    (%rax),%rax
  8020bb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020c1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020c4:	89 c6                	mov    %eax,%esi
  8020c6:	48 bf 37 3c 80 00 00 	movabs $0x803c37,%rdi
  8020cd:	00 00 00 
  8020d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d5:	48 b9 6a 02 80 00 00 	movabs $0x80026a,%rcx
  8020dc:	00 00 00 
  8020df:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020e6:	eb 2d                	jmp    802115 <read+0xd3>
	}
	if (!dev->dev_read)
  8020e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ec:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020f0:	48 85 c0             	test   %rax,%rax
  8020f3:	75 07                	jne    8020fc <read+0xba>
		return -E_NOT_SUPP;
  8020f5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8020fa:	eb 19                	jmp    802115 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8020fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802100:	48 8b 40 10          	mov    0x10(%rax),%rax
  802104:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802108:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80210c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802110:	48 89 cf             	mov    %rcx,%rdi
  802113:	ff d0                	callq  *%rax
}
  802115:	c9                   	leaveq 
  802116:	c3                   	retq   

0000000000802117 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802117:	55                   	push   %rbp
  802118:	48 89 e5             	mov    %rsp,%rbp
  80211b:	48 83 ec 30          	sub    $0x30,%rsp
  80211f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802122:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802126:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80212a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802131:	eb 49                	jmp    80217c <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802133:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802136:	48 98                	cltq   
  802138:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80213c:	48 29 c2             	sub    %rax,%rdx
  80213f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802142:	48 63 c8             	movslq %eax,%rcx
  802145:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802149:	48 01 c1             	add    %rax,%rcx
  80214c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80214f:	48 89 ce             	mov    %rcx,%rsi
  802152:	89 c7                	mov    %eax,%edi
  802154:	48 b8 42 20 80 00 00 	movabs $0x802042,%rax
  80215b:	00 00 00 
  80215e:	ff d0                	callq  *%rax
  802160:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802163:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802167:	79 05                	jns    80216e <readn+0x57>
			return m;
  802169:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80216c:	eb 1c                	jmp    80218a <readn+0x73>
		if (m == 0)
  80216e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802172:	75 02                	jne    802176 <readn+0x5f>
			break;
  802174:	eb 11                	jmp    802187 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802176:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802179:	01 45 fc             	add    %eax,-0x4(%rbp)
  80217c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80217f:	48 98                	cltq   
  802181:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802185:	72 ac                	jb     802133 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802187:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80218a:	c9                   	leaveq 
  80218b:	c3                   	retq   

000000000080218c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80218c:	55                   	push   %rbp
  80218d:	48 89 e5             	mov    %rsp,%rbp
  802190:	48 83 ec 40          	sub    $0x40,%rsp
  802194:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802197:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80219b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80219f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021a3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021a6:	48 89 d6             	mov    %rdx,%rsi
  8021a9:	89 c7                	mov    %eax,%edi
  8021ab:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  8021b2:	00 00 00 
  8021b5:	ff d0                	callq  *%rax
  8021b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021be:	78 24                	js     8021e4 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c4:	8b 00                	mov    (%rax),%eax
  8021c6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021ca:	48 89 d6             	mov    %rdx,%rsi
  8021cd:	89 c7                	mov    %eax,%edi
  8021cf:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  8021d6:	00 00 00 
  8021d9:	ff d0                	callq  *%rax
  8021db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021e2:	79 05                	jns    8021e9 <write+0x5d>
		return r;
  8021e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e7:	eb 75                	jmp    80225e <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ed:	8b 40 08             	mov    0x8(%rax),%eax
  8021f0:	83 e0 03             	and    $0x3,%eax
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	75 3a                	jne    802231 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8021f7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8021fe:	00 00 00 
  802201:	48 8b 00             	mov    (%rax),%rax
  802204:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80220a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80220d:	89 c6                	mov    %eax,%esi
  80220f:	48 bf 53 3c 80 00 00 	movabs $0x803c53,%rdi
  802216:	00 00 00 
  802219:	b8 00 00 00 00       	mov    $0x0,%eax
  80221e:	48 b9 6a 02 80 00 00 	movabs $0x80026a,%rcx
  802225:	00 00 00 
  802228:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80222a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80222f:	eb 2d                	jmp    80225e <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802231:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802235:	48 8b 40 18          	mov    0x18(%rax),%rax
  802239:	48 85 c0             	test   %rax,%rax
  80223c:	75 07                	jne    802245 <write+0xb9>
		return -E_NOT_SUPP;
  80223e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802243:	eb 19                	jmp    80225e <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802245:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802249:	48 8b 40 18          	mov    0x18(%rax),%rax
  80224d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802251:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802255:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802259:	48 89 cf             	mov    %rcx,%rdi
  80225c:	ff d0                	callq  *%rax
}
  80225e:	c9                   	leaveq 
  80225f:	c3                   	retq   

0000000000802260 <seek>:

int
seek(int fdnum, off_t offset)
{
  802260:	55                   	push   %rbp
  802261:	48 89 e5             	mov    %rsp,%rbp
  802264:	48 83 ec 18          	sub    $0x18,%rsp
  802268:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80226b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80226e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802272:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802275:	48 89 d6             	mov    %rdx,%rsi
  802278:	89 c7                	mov    %eax,%edi
  80227a:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  802281:	00 00 00 
  802284:	ff d0                	callq  *%rax
  802286:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802289:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80228d:	79 05                	jns    802294 <seek+0x34>
		return r;
  80228f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802292:	eb 0f                	jmp    8022a3 <seek+0x43>
	fd->fd_offset = offset;
  802294:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802298:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80229b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a3:	c9                   	leaveq 
  8022a4:	c3                   	retq   

00000000008022a5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8022a5:	55                   	push   %rbp
  8022a6:	48 89 e5             	mov    %rsp,%rbp
  8022a9:	48 83 ec 30          	sub    $0x30,%rsp
  8022ad:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022b0:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022b3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022ba:	48 89 d6             	mov    %rdx,%rsi
  8022bd:	89 c7                	mov    %eax,%edi
  8022bf:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  8022c6:	00 00 00 
  8022c9:	ff d0                	callq  *%rax
  8022cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022d2:	78 24                	js     8022f8 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d8:	8b 00                	mov    (%rax),%eax
  8022da:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022de:	48 89 d6             	mov    %rdx,%rsi
  8022e1:	89 c7                	mov    %eax,%edi
  8022e3:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  8022ea:	00 00 00 
  8022ed:	ff d0                	callq  *%rax
  8022ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f6:	79 05                	jns    8022fd <ftruncate+0x58>
		return r;
  8022f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022fb:	eb 72                	jmp    80236f <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802301:	8b 40 08             	mov    0x8(%rax),%eax
  802304:	83 e0 03             	and    $0x3,%eax
  802307:	85 c0                	test   %eax,%eax
  802309:	75 3a                	jne    802345 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80230b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802312:	00 00 00 
  802315:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802318:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80231e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802321:	89 c6                	mov    %eax,%esi
  802323:	48 bf 70 3c 80 00 00 	movabs $0x803c70,%rdi
  80232a:	00 00 00 
  80232d:	b8 00 00 00 00       	mov    $0x0,%eax
  802332:	48 b9 6a 02 80 00 00 	movabs $0x80026a,%rcx
  802339:	00 00 00 
  80233c:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80233e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802343:	eb 2a                	jmp    80236f <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802345:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802349:	48 8b 40 30          	mov    0x30(%rax),%rax
  80234d:	48 85 c0             	test   %rax,%rax
  802350:	75 07                	jne    802359 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802352:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802357:	eb 16                	jmp    80236f <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802359:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802361:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802365:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802368:	89 ce                	mov    %ecx,%esi
  80236a:	48 89 d7             	mov    %rdx,%rdi
  80236d:	ff d0                	callq  *%rax
}
  80236f:	c9                   	leaveq 
  802370:	c3                   	retq   

0000000000802371 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802371:	55                   	push   %rbp
  802372:	48 89 e5             	mov    %rsp,%rbp
  802375:	48 83 ec 30          	sub    $0x30,%rsp
  802379:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80237c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802380:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802384:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802387:	48 89 d6             	mov    %rdx,%rsi
  80238a:	89 c7                	mov    %eax,%edi
  80238c:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  802393:	00 00 00 
  802396:	ff d0                	callq  *%rax
  802398:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80239b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80239f:	78 24                	js     8023c5 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a5:	8b 00                	mov    (%rax),%eax
  8023a7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ab:	48 89 d6             	mov    %rdx,%rsi
  8023ae:	89 c7                	mov    %eax,%edi
  8023b0:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  8023b7:	00 00 00 
  8023ba:	ff d0                	callq  *%rax
  8023bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c3:	79 05                	jns    8023ca <fstat+0x59>
		return r;
  8023c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c8:	eb 5e                	jmp    802428 <fstat+0xb7>
	if (!dev->dev_stat)
  8023ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ce:	48 8b 40 28          	mov    0x28(%rax),%rax
  8023d2:	48 85 c0             	test   %rax,%rax
  8023d5:	75 07                	jne    8023de <fstat+0x6d>
		return -E_NOT_SUPP;
  8023d7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023dc:	eb 4a                	jmp    802428 <fstat+0xb7>
	stat->st_name[0] = 0;
  8023de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023e2:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8023e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023e9:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8023f0:	00 00 00 
	stat->st_isdir = 0;
  8023f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023f7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8023fe:	00 00 00 
	stat->st_dev = dev;
  802401:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802405:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802409:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802410:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802414:	48 8b 40 28          	mov    0x28(%rax),%rax
  802418:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80241c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802420:	48 89 ce             	mov    %rcx,%rsi
  802423:	48 89 d7             	mov    %rdx,%rdi
  802426:	ff d0                	callq  *%rax
}
  802428:	c9                   	leaveq 
  802429:	c3                   	retq   

000000000080242a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80242a:	55                   	push   %rbp
  80242b:	48 89 e5             	mov    %rsp,%rbp
  80242e:	48 83 ec 20          	sub    $0x20,%rsp
  802432:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802436:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80243a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80243e:	be 00 00 00 00       	mov    $0x0,%esi
  802443:	48 89 c7             	mov    %rax,%rdi
  802446:	48 b8 18 25 80 00 00 	movabs $0x802518,%rax
  80244d:	00 00 00 
  802450:	ff d0                	callq  *%rax
  802452:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802455:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802459:	79 05                	jns    802460 <stat+0x36>
		return fd;
  80245b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245e:	eb 2f                	jmp    80248f <stat+0x65>
	r = fstat(fd, stat);
  802460:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802464:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802467:	48 89 d6             	mov    %rdx,%rsi
  80246a:	89 c7                	mov    %eax,%edi
  80246c:	48 b8 71 23 80 00 00 	movabs $0x802371,%rax
  802473:	00 00 00 
  802476:	ff d0                	callq  *%rax
  802478:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80247b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247e:	89 c7                	mov    %eax,%edi
  802480:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  802487:	00 00 00 
  80248a:	ff d0                	callq  *%rax
	return r;
  80248c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80248f:	c9                   	leaveq 
  802490:	c3                   	retq   

0000000000802491 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802491:	55                   	push   %rbp
  802492:	48 89 e5             	mov    %rsp,%rbp
  802495:	48 83 ec 10          	sub    $0x10,%rsp
  802499:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80249c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8024a0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8024a7:	00 00 00 
  8024aa:	8b 00                	mov    (%rax),%eax
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	75 1d                	jne    8024cd <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8024b0:	bf 01 00 00 00       	mov    $0x1,%edi
  8024b5:	48 b8 d0 35 80 00 00 	movabs $0x8035d0,%rax
  8024bc:	00 00 00 
  8024bf:	ff d0                	callq  *%rax
  8024c1:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8024c8:	00 00 00 
  8024cb:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8024cd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8024d4:	00 00 00 
  8024d7:	8b 00                	mov    (%rax),%eax
  8024d9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8024dc:	b9 07 00 00 00       	mov    $0x7,%ecx
  8024e1:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8024e8:	00 00 00 
  8024eb:	89 c7                	mov    %eax,%edi
  8024ed:	48 b8 d1 34 80 00 00 	movabs $0x8034d1,%rax
  8024f4:	00 00 00 
  8024f7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8024f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802502:	48 89 c6             	mov    %rax,%rsi
  802505:	bf 00 00 00 00       	mov    $0x0,%edi
  80250a:	48 b8 1e 34 80 00 00 	movabs $0x80341e,%rax
  802511:	00 00 00 
  802514:	ff d0                	callq  *%rax
}
  802516:	c9                   	leaveq 
  802517:	c3                   	retq   

0000000000802518 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802518:	55                   	push   %rbp
  802519:	48 89 e5             	mov    %rsp,%rbp
  80251c:	48 83 ec 20          	sub    $0x20,%rsp
  802520:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802524:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  802527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252b:	48 89 c7             	mov    %rax,%rdi
  80252e:	48 b8 f4 0d 80 00 00 	movabs $0x800df4,%rax
  802535:	00 00 00 
  802538:	ff d0                	callq  *%rax
  80253a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80253f:	7e 0a                	jle    80254b <open+0x33>
		return -E_BAD_PATH;
  802541:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802546:	e9 a5 00 00 00       	jmpq   8025f0 <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  80254b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80254f:	48 89 c7             	mov    %rax,%rdi
  802552:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  802559:	00 00 00 
  80255c:	ff d0                	callq  *%rax
  80255e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802561:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802565:	79 08                	jns    80256f <open+0x57>
		return ret;
  802567:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256a:	e9 81 00 00 00       	jmpq   8025f0 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  80256f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802576:	00 00 00 
  802579:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80257c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  802582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802586:	48 89 c6             	mov    %rax,%rsi
  802589:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802590:	00 00 00 
  802593:	48 b8 60 0e 80 00 00 	movabs $0x800e60,%rax
  80259a:	00 00 00 
  80259d:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  80259f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025a3:	48 89 c6             	mov    %rax,%rsi
  8025a6:	bf 01 00 00 00       	mov    $0x1,%edi
  8025ab:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  8025b2:	00 00 00 
  8025b5:	ff d0                	callq  *%rax
  8025b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025be:	79 1d                	jns    8025dd <open+0xc5>
	{
		fd_close(fd,0);
  8025c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c4:	be 00 00 00 00       	mov    $0x0,%esi
  8025c9:	48 89 c7             	mov    %rax,%rdi
  8025cc:	48 b8 a0 1c 80 00 00 	movabs $0x801ca0,%rax
  8025d3:	00 00 00 
  8025d6:	ff d0                	callq  *%rax
		return ret;
  8025d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025db:	eb 13                	jmp    8025f0 <open+0xd8>
	}
	return fd2num (fd);
  8025dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e1:	48 89 c7             	mov    %rax,%rdi
  8025e4:	48 b8 2a 1b 80 00 00 	movabs $0x801b2a,%rax
  8025eb:	00 00 00 
  8025ee:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  8025f0:	c9                   	leaveq 
  8025f1:	c3                   	retq   

00000000008025f2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8025f2:	55                   	push   %rbp
  8025f3:	48 89 e5             	mov    %rsp,%rbp
  8025f6:	48 83 ec 10          	sub    $0x10,%rsp
  8025fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8025fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802602:	8b 50 0c             	mov    0xc(%rax),%edx
  802605:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80260c:	00 00 00 
  80260f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802611:	be 00 00 00 00       	mov    $0x0,%esi
  802616:	bf 06 00 00 00       	mov    $0x6,%edi
  80261b:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  802622:	00 00 00 
  802625:	ff d0                	callq  *%rax
}
  802627:	c9                   	leaveq 
  802628:	c3                   	retq   

0000000000802629 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802629:	55                   	push   %rbp
  80262a:	48 89 e5             	mov    %rsp,%rbp
  80262d:	48 83 ec 30          	sub    $0x30,%rsp
  802631:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802635:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802639:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  80263d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802641:	8b 50 0c             	mov    0xc(%rax),%edx
  802644:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80264b:	00 00 00 
  80264e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  802650:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802657:	00 00 00 
  80265a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80265e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  802662:	be 00 00 00 00       	mov    $0x0,%esi
  802667:	bf 03 00 00 00       	mov    $0x3,%edi
  80266c:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  802673:	00 00 00 
  802676:	ff d0                	callq  *%rax
  802678:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80267f:	79 05                	jns    802686 <devfile_read+0x5d>
		return ret;
  802681:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802684:	eb 26                	jmp    8026ac <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  802686:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802689:	48 63 d0             	movslq %eax,%rdx
  80268c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802690:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802697:	00 00 00 
  80269a:	48 89 c7             	mov    %rax,%rdi
  80269d:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  8026a4:	00 00 00 
  8026a7:	ff d0                	callq  *%rax
	return ret;
  8026a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  8026ac:	c9                   	leaveq 
  8026ad:	c3                   	retq   

00000000008026ae <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8026ae:	55                   	push   %rbp
  8026af:	48 89 e5             	mov    %rsp,%rbp
  8026b2:	48 83 ec 30          	sub    $0x30,%rsp
  8026b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  8026c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c6:	8b 50 0c             	mov    0xc(%rax),%edx
  8026c9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026d0:	00 00 00 
  8026d3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  8026d5:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  8026da:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8026e1:	00 
  8026e2:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8026e7:	48 89 c2             	mov    %rax,%rdx
  8026ea:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026f1:	00 00 00 
  8026f4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8026f8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026ff:	00 00 00 
  802702:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802706:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80270a:	48 89 c6             	mov    %rax,%rsi
  80270d:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802714:	00 00 00 
  802717:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  80271e:	00 00 00 
  802721:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  802723:	be 00 00 00 00       	mov    $0x0,%esi
  802728:	bf 04 00 00 00       	mov    $0x4,%edi
  80272d:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  802734:	00 00 00 
  802737:	ff d0                	callq  *%rax
  802739:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802740:	79 05                	jns    802747 <devfile_write+0x99>
		return ret;
  802742:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802745:	eb 03                	jmp    80274a <devfile_write+0x9c>
	
	return ret;
  802747:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  80274a:	c9                   	leaveq 
  80274b:	c3                   	retq   

000000000080274c <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80274c:	55                   	push   %rbp
  80274d:	48 89 e5             	mov    %rsp,%rbp
  802750:	48 83 ec 20          	sub    $0x20,%rsp
  802754:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802758:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80275c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802760:	8b 50 0c             	mov    0xc(%rax),%edx
  802763:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80276a:	00 00 00 
  80276d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80276f:	be 00 00 00 00       	mov    $0x0,%esi
  802774:	bf 05 00 00 00       	mov    $0x5,%edi
  802779:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  802780:	00 00 00 
  802783:	ff d0                	callq  *%rax
  802785:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802788:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278c:	79 05                	jns    802793 <devfile_stat+0x47>
		return r;
  80278e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802791:	eb 56                	jmp    8027e9 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802793:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802797:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80279e:	00 00 00 
  8027a1:	48 89 c7             	mov    %rax,%rdi
  8027a4:	48 b8 60 0e 80 00 00 	movabs $0x800e60,%rax
  8027ab:	00 00 00 
  8027ae:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8027b0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027b7:	00 00 00 
  8027ba:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8027c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027c4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8027ca:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027d1:	00 00 00 
  8027d4:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8027da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027de:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8027e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e9:	c9                   	leaveq 
  8027ea:	c3                   	retq   

00000000008027eb <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8027eb:	55                   	push   %rbp
  8027ec:	48 89 e5             	mov    %rsp,%rbp
  8027ef:	48 83 ec 10          	sub    $0x10,%rsp
  8027f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027f7:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8027fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027fe:	8b 50 0c             	mov    0xc(%rax),%edx
  802801:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802808:	00 00 00 
  80280b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80280d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802814:	00 00 00 
  802817:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80281a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80281d:	be 00 00 00 00       	mov    $0x0,%esi
  802822:	bf 02 00 00 00       	mov    $0x2,%edi
  802827:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  80282e:	00 00 00 
  802831:	ff d0                	callq  *%rax
}
  802833:	c9                   	leaveq 
  802834:	c3                   	retq   

0000000000802835 <remove>:

// Delete a file
int
remove(const char *path)
{
  802835:	55                   	push   %rbp
  802836:	48 89 e5             	mov    %rsp,%rbp
  802839:	48 83 ec 10          	sub    $0x10,%rsp
  80283d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802841:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802845:	48 89 c7             	mov    %rax,%rdi
  802848:	48 b8 f4 0d 80 00 00 	movabs $0x800df4,%rax
  80284f:	00 00 00 
  802852:	ff d0                	callq  *%rax
  802854:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802859:	7e 07                	jle    802862 <remove+0x2d>
		return -E_BAD_PATH;
  80285b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802860:	eb 33                	jmp    802895 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802862:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802866:	48 89 c6             	mov    %rax,%rsi
  802869:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802870:	00 00 00 
  802873:	48 b8 60 0e 80 00 00 	movabs $0x800e60,%rax
  80287a:	00 00 00 
  80287d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80287f:	be 00 00 00 00       	mov    $0x0,%esi
  802884:	bf 07 00 00 00       	mov    $0x7,%edi
  802889:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  802890:	00 00 00 
  802893:	ff d0                	callq  *%rax
}
  802895:	c9                   	leaveq 
  802896:	c3                   	retq   

0000000000802897 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802897:	55                   	push   %rbp
  802898:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80289b:	be 00 00 00 00       	mov    $0x0,%esi
  8028a0:	bf 08 00 00 00       	mov    $0x8,%edi
  8028a5:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  8028ac:	00 00 00 
  8028af:	ff d0                	callq  *%rax
}
  8028b1:	5d                   	pop    %rbp
  8028b2:	c3                   	retq   

00000000008028b3 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8028b3:	55                   	push   %rbp
  8028b4:	48 89 e5             	mov    %rsp,%rbp
  8028b7:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8028be:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8028c5:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8028cc:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8028d3:	be 00 00 00 00       	mov    $0x0,%esi
  8028d8:	48 89 c7             	mov    %rax,%rdi
  8028db:	48 b8 18 25 80 00 00 	movabs $0x802518,%rax
  8028e2:	00 00 00 
  8028e5:	ff d0                	callq  *%rax
  8028e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8028ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ee:	79 28                	jns    802918 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8028f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f3:	89 c6                	mov    %eax,%esi
  8028f5:	48 bf 96 3c 80 00 00 	movabs $0x803c96,%rdi
  8028fc:	00 00 00 
  8028ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802904:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  80290b:	00 00 00 
  80290e:	ff d2                	callq  *%rdx
		return fd_src;
  802910:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802913:	e9 74 01 00 00       	jmpq   802a8c <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802918:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80291f:	be 01 01 00 00       	mov    $0x101,%esi
  802924:	48 89 c7             	mov    %rax,%rdi
  802927:	48 b8 18 25 80 00 00 	movabs $0x802518,%rax
  80292e:	00 00 00 
  802931:	ff d0                	callq  *%rax
  802933:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802936:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80293a:	79 39                	jns    802975 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80293c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80293f:	89 c6                	mov    %eax,%esi
  802941:	48 bf ac 3c 80 00 00 	movabs $0x803cac,%rdi
  802948:	00 00 00 
  80294b:	b8 00 00 00 00       	mov    $0x0,%eax
  802950:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  802957:	00 00 00 
  80295a:	ff d2                	callq  *%rdx
		close(fd_src);
  80295c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295f:	89 c7                	mov    %eax,%edi
  802961:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  802968:	00 00 00 
  80296b:	ff d0                	callq  *%rax
		return fd_dest;
  80296d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802970:	e9 17 01 00 00       	jmpq   802a8c <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802975:	eb 74                	jmp    8029eb <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802977:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80297a:	48 63 d0             	movslq %eax,%rdx
  80297d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802984:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802987:	48 89 ce             	mov    %rcx,%rsi
  80298a:	89 c7                	mov    %eax,%edi
  80298c:	48 b8 8c 21 80 00 00 	movabs $0x80218c,%rax
  802993:	00 00 00 
  802996:	ff d0                	callq  *%rax
  802998:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80299b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80299f:	79 4a                	jns    8029eb <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8029a1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8029a4:	89 c6                	mov    %eax,%esi
  8029a6:	48 bf c6 3c 80 00 00 	movabs $0x803cc6,%rdi
  8029ad:	00 00 00 
  8029b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b5:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  8029bc:	00 00 00 
  8029bf:	ff d2                	callq  *%rdx
			close(fd_src);
  8029c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c4:	89 c7                	mov    %eax,%edi
  8029c6:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  8029cd:	00 00 00 
  8029d0:	ff d0                	callq  *%rax
			close(fd_dest);
  8029d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029d5:	89 c7                	mov    %eax,%edi
  8029d7:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  8029de:	00 00 00 
  8029e1:	ff d0                	callq  *%rax
			return write_size;
  8029e3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8029e6:	e9 a1 00 00 00       	jmpq   802a8c <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8029eb:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8029f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f5:	ba 00 02 00 00       	mov    $0x200,%edx
  8029fa:	48 89 ce             	mov    %rcx,%rsi
  8029fd:	89 c7                	mov    %eax,%edi
  8029ff:	48 b8 42 20 80 00 00 	movabs $0x802042,%rax
  802a06:	00 00 00 
  802a09:	ff d0                	callq  *%rax
  802a0b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802a0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802a12:	0f 8f 5f ff ff ff    	jg     802977 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802a18:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802a1c:	79 47                	jns    802a65 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802a1e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a21:	89 c6                	mov    %eax,%esi
  802a23:	48 bf d9 3c 80 00 00 	movabs $0x803cd9,%rdi
  802a2a:	00 00 00 
  802a2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a32:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  802a39:	00 00 00 
  802a3c:	ff d2                	callq  *%rdx
		close(fd_src);
  802a3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a41:	89 c7                	mov    %eax,%edi
  802a43:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  802a4a:	00 00 00 
  802a4d:	ff d0                	callq  *%rax
		close(fd_dest);
  802a4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a52:	89 c7                	mov    %eax,%edi
  802a54:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  802a5b:	00 00 00 
  802a5e:	ff d0                	callq  *%rax
		return read_size;
  802a60:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a63:	eb 27                	jmp    802a8c <copy+0x1d9>
	}
	close(fd_src);
  802a65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a68:	89 c7                	mov    %eax,%edi
  802a6a:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  802a71:	00 00 00 
  802a74:	ff d0                	callq  *%rax
	close(fd_dest);
  802a76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a79:	89 c7                	mov    %eax,%edi
  802a7b:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  802a82:	00 00 00 
  802a85:	ff d0                	callq  *%rax
	return 0;
  802a87:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802a8c:	c9                   	leaveq 
  802a8d:	c3                   	retq   

0000000000802a8e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802a8e:	55                   	push   %rbp
  802a8f:	48 89 e5             	mov    %rsp,%rbp
  802a92:	53                   	push   %rbx
  802a93:	48 83 ec 38          	sub    $0x38,%rsp
  802a97:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802a9b:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802a9f:	48 89 c7             	mov    %rax,%rdi
  802aa2:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  802aa9:	00 00 00 
  802aac:	ff d0                	callq  *%rax
  802aae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ab1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ab5:	0f 88 bf 01 00 00    	js     802c7a <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802abb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802abf:	ba 07 04 00 00       	mov    $0x407,%edx
  802ac4:	48 89 c6             	mov    %rax,%rsi
  802ac7:	bf 00 00 00 00       	mov    $0x0,%edi
  802acc:	48 b8 8f 17 80 00 00 	movabs $0x80178f,%rax
  802ad3:	00 00 00 
  802ad6:	ff d0                	callq  *%rax
  802ad8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802adb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802adf:	0f 88 95 01 00 00    	js     802c7a <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802ae5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802ae9:	48 89 c7             	mov    %rax,%rdi
  802aec:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  802af3:	00 00 00 
  802af6:	ff d0                	callq  *%rax
  802af8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802afb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802aff:	0f 88 5d 01 00 00    	js     802c62 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b09:	ba 07 04 00 00       	mov    $0x407,%edx
  802b0e:	48 89 c6             	mov    %rax,%rsi
  802b11:	bf 00 00 00 00       	mov    $0x0,%edi
  802b16:	48 b8 8f 17 80 00 00 	movabs $0x80178f,%rax
  802b1d:	00 00 00 
  802b20:	ff d0                	callq  *%rax
  802b22:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b25:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b29:	0f 88 33 01 00 00    	js     802c62 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802b2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b33:	48 89 c7             	mov    %rax,%rdi
  802b36:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  802b3d:	00 00 00 
  802b40:	ff d0                	callq  *%rax
  802b42:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b4a:	ba 07 04 00 00       	mov    $0x407,%edx
  802b4f:	48 89 c6             	mov    %rax,%rsi
  802b52:	bf 00 00 00 00       	mov    $0x0,%edi
  802b57:	48 b8 8f 17 80 00 00 	movabs $0x80178f,%rax
  802b5e:	00 00 00 
  802b61:	ff d0                	callq  *%rax
  802b63:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b66:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b6a:	79 05                	jns    802b71 <pipe+0xe3>
		goto err2;
  802b6c:	e9 d9 00 00 00       	jmpq   802c4a <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b71:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b75:	48 89 c7             	mov    %rax,%rdi
  802b78:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  802b7f:	00 00 00 
  802b82:	ff d0                	callq  *%rax
  802b84:	48 89 c2             	mov    %rax,%rdx
  802b87:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b8b:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802b91:	48 89 d1             	mov    %rdx,%rcx
  802b94:	ba 00 00 00 00       	mov    $0x0,%edx
  802b99:	48 89 c6             	mov    %rax,%rsi
  802b9c:	bf 00 00 00 00       	mov    $0x0,%edi
  802ba1:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  802ba8:	00 00 00 
  802bab:	ff d0                	callq  *%rax
  802bad:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802bb0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bb4:	79 1b                	jns    802bd1 <pipe+0x143>
		goto err3;
  802bb6:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802bb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bbb:	48 89 c6             	mov    %rax,%rsi
  802bbe:	bf 00 00 00 00       	mov    $0x0,%edi
  802bc3:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  802bca:	00 00 00 
  802bcd:	ff d0                	callq  *%rax
  802bcf:	eb 79                	jmp    802c4a <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802bd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bd5:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  802bdc:	00 00 00 
  802bdf:	8b 12                	mov    (%rdx),%edx
  802be1:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802be3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802be7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802bee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bf2:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  802bf9:	00 00 00 
  802bfc:	8b 12                	mov    (%rdx),%edx
  802bfe:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802c00:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c04:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802c0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c0f:	48 89 c7             	mov    %rax,%rdi
  802c12:	48 b8 2a 1b 80 00 00 	movabs $0x801b2a,%rax
  802c19:	00 00 00 
  802c1c:	ff d0                	callq  *%rax
  802c1e:	89 c2                	mov    %eax,%edx
  802c20:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c24:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802c26:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c2a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802c2e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c32:	48 89 c7             	mov    %rax,%rdi
  802c35:	48 b8 2a 1b 80 00 00 	movabs $0x801b2a,%rax
  802c3c:	00 00 00 
  802c3f:	ff d0                	callq  *%rax
  802c41:	89 03                	mov    %eax,(%rbx)
	return 0;
  802c43:	b8 00 00 00 00       	mov    $0x0,%eax
  802c48:	eb 33                	jmp    802c7d <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802c4a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c4e:	48 89 c6             	mov    %rax,%rsi
  802c51:	bf 00 00 00 00       	mov    $0x0,%edi
  802c56:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  802c5d:	00 00 00 
  802c60:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802c62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c66:	48 89 c6             	mov    %rax,%rsi
  802c69:	bf 00 00 00 00       	mov    $0x0,%edi
  802c6e:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  802c75:	00 00 00 
  802c78:	ff d0                	callq  *%rax
err:
	return r;
  802c7a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802c7d:	48 83 c4 38          	add    $0x38,%rsp
  802c81:	5b                   	pop    %rbx
  802c82:	5d                   	pop    %rbp
  802c83:	c3                   	retq   

0000000000802c84 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802c84:	55                   	push   %rbp
  802c85:	48 89 e5             	mov    %rsp,%rbp
  802c88:	53                   	push   %rbx
  802c89:	48 83 ec 28          	sub    $0x28,%rsp
  802c8d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c91:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c95:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c9c:	00 00 00 
  802c9f:	48 8b 00             	mov    (%rax),%rax
  802ca2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802ca8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802cab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802caf:	48 89 c7             	mov    %rax,%rdi
  802cb2:	48 b8 42 36 80 00 00 	movabs $0x803642,%rax
  802cb9:	00 00 00 
  802cbc:	ff d0                	callq  *%rax
  802cbe:	89 c3                	mov    %eax,%ebx
  802cc0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cc4:	48 89 c7             	mov    %rax,%rdi
  802cc7:	48 b8 42 36 80 00 00 	movabs $0x803642,%rax
  802cce:	00 00 00 
  802cd1:	ff d0                	callq  *%rax
  802cd3:	39 c3                	cmp    %eax,%ebx
  802cd5:	0f 94 c0             	sete   %al
  802cd8:	0f b6 c0             	movzbl %al,%eax
  802cdb:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802cde:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802ce5:	00 00 00 
  802ce8:	48 8b 00             	mov    (%rax),%rax
  802ceb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802cf1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802cf4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cf7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802cfa:	75 05                	jne    802d01 <_pipeisclosed+0x7d>
			return ret;
  802cfc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cff:	eb 4f                	jmp    802d50 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802d01:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d04:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802d07:	74 42                	je     802d4b <_pipeisclosed+0xc7>
  802d09:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802d0d:	75 3c                	jne    802d4b <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802d0f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802d16:	00 00 00 
  802d19:	48 8b 00             	mov    (%rax),%rax
  802d1c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802d22:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802d25:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d28:	89 c6                	mov    %eax,%esi
  802d2a:	48 bf f9 3c 80 00 00 	movabs $0x803cf9,%rdi
  802d31:	00 00 00 
  802d34:	b8 00 00 00 00       	mov    $0x0,%eax
  802d39:	49 b8 6a 02 80 00 00 	movabs $0x80026a,%r8
  802d40:	00 00 00 
  802d43:	41 ff d0             	callq  *%r8
	}
  802d46:	e9 4a ff ff ff       	jmpq   802c95 <_pipeisclosed+0x11>
  802d4b:	e9 45 ff ff ff       	jmpq   802c95 <_pipeisclosed+0x11>
}
  802d50:	48 83 c4 28          	add    $0x28,%rsp
  802d54:	5b                   	pop    %rbx
  802d55:	5d                   	pop    %rbp
  802d56:	c3                   	retq   

0000000000802d57 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802d57:	55                   	push   %rbp
  802d58:	48 89 e5             	mov    %rsp,%rbp
  802d5b:	48 83 ec 30          	sub    $0x30,%rsp
  802d5f:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d62:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d66:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d69:	48 89 d6             	mov    %rdx,%rsi
  802d6c:	89 c7                	mov    %eax,%edi
  802d6e:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  802d75:	00 00 00 
  802d78:	ff d0                	callq  *%rax
  802d7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d81:	79 05                	jns    802d88 <pipeisclosed+0x31>
		return r;
  802d83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d86:	eb 31                	jmp    802db9 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802d88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d8c:	48 89 c7             	mov    %rax,%rdi
  802d8f:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  802d96:	00 00 00 
  802d99:	ff d0                	callq  *%rax
  802d9b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802d9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802da7:	48 89 d6             	mov    %rdx,%rsi
  802daa:	48 89 c7             	mov    %rax,%rdi
  802dad:	48 b8 84 2c 80 00 00 	movabs $0x802c84,%rax
  802db4:	00 00 00 
  802db7:	ff d0                	callq  *%rax
}
  802db9:	c9                   	leaveq 
  802dba:	c3                   	retq   

0000000000802dbb <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802dbb:	55                   	push   %rbp
  802dbc:	48 89 e5             	mov    %rsp,%rbp
  802dbf:	48 83 ec 40          	sub    $0x40,%rsp
  802dc3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802dc7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802dcb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802dcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dd3:	48 89 c7             	mov    %rax,%rdi
  802dd6:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  802ddd:	00 00 00 
  802de0:	ff d0                	callq  *%rax
  802de2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802de6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802dee:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802df5:	00 
  802df6:	e9 92 00 00 00       	jmpq   802e8d <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802dfb:	eb 41                	jmp    802e3e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802dfd:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802e02:	74 09                	je     802e0d <devpipe_read+0x52>
				return i;
  802e04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e08:	e9 92 00 00 00       	jmpq   802e9f <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802e0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e15:	48 89 d6             	mov    %rdx,%rsi
  802e18:	48 89 c7             	mov    %rax,%rdi
  802e1b:	48 b8 84 2c 80 00 00 	movabs $0x802c84,%rax
  802e22:	00 00 00 
  802e25:	ff d0                	callq  *%rax
  802e27:	85 c0                	test   %eax,%eax
  802e29:	74 07                	je     802e32 <devpipe_read+0x77>
				return 0;
  802e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e30:	eb 6d                	jmp    802e9f <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802e32:	48 b8 51 17 80 00 00 	movabs $0x801751,%rax
  802e39:	00 00 00 
  802e3c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e42:	8b 10                	mov    (%rax),%edx
  802e44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e48:	8b 40 04             	mov    0x4(%rax),%eax
  802e4b:	39 c2                	cmp    %eax,%edx
  802e4d:	74 ae                	je     802dfd <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e53:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e57:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802e5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5f:	8b 00                	mov    (%rax),%eax
  802e61:	99                   	cltd   
  802e62:	c1 ea 1b             	shr    $0x1b,%edx
  802e65:	01 d0                	add    %edx,%eax
  802e67:	83 e0 1f             	and    $0x1f,%eax
  802e6a:	29 d0                	sub    %edx,%eax
  802e6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e70:	48 98                	cltq   
  802e72:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802e77:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802e79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e7d:	8b 00                	mov    (%rax),%eax
  802e7f:	8d 50 01             	lea    0x1(%rax),%edx
  802e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e86:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e88:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e91:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e95:	0f 82 60 ff ff ff    	jb     802dfb <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802e9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e9f:	c9                   	leaveq 
  802ea0:	c3                   	retq   

0000000000802ea1 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802ea1:	55                   	push   %rbp
  802ea2:	48 89 e5             	mov    %rsp,%rbp
  802ea5:	48 83 ec 40          	sub    $0x40,%rsp
  802ea9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ead:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802eb1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802eb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eb9:	48 89 c7             	mov    %rax,%rdi
  802ebc:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax
  802ec8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802ecc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ed0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802ed4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802edb:	00 
  802edc:	e9 8e 00 00 00       	jmpq   802f6f <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ee1:	eb 31                	jmp    802f14 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802ee3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ee7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eeb:	48 89 d6             	mov    %rdx,%rsi
  802eee:	48 89 c7             	mov    %rax,%rdi
  802ef1:	48 b8 84 2c 80 00 00 	movabs $0x802c84,%rax
  802ef8:	00 00 00 
  802efb:	ff d0                	callq  *%rax
  802efd:	85 c0                	test   %eax,%eax
  802eff:	74 07                	je     802f08 <devpipe_write+0x67>
				return 0;
  802f01:	b8 00 00 00 00       	mov    $0x0,%eax
  802f06:	eb 79                	jmp    802f81 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802f08:	48 b8 51 17 80 00 00 	movabs $0x801751,%rax
  802f0f:	00 00 00 
  802f12:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802f14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f18:	8b 40 04             	mov    0x4(%rax),%eax
  802f1b:	48 63 d0             	movslq %eax,%rdx
  802f1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f22:	8b 00                	mov    (%rax),%eax
  802f24:	48 98                	cltq   
  802f26:	48 83 c0 20          	add    $0x20,%rax
  802f2a:	48 39 c2             	cmp    %rax,%rdx
  802f2d:	73 b4                	jae    802ee3 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802f2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f33:	8b 40 04             	mov    0x4(%rax),%eax
  802f36:	99                   	cltd   
  802f37:	c1 ea 1b             	shr    $0x1b,%edx
  802f3a:	01 d0                	add    %edx,%eax
  802f3c:	83 e0 1f             	and    $0x1f,%eax
  802f3f:	29 d0                	sub    %edx,%eax
  802f41:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f45:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f49:	48 01 ca             	add    %rcx,%rdx
  802f4c:	0f b6 0a             	movzbl (%rdx),%ecx
  802f4f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f53:	48 98                	cltq   
  802f55:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802f59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5d:	8b 40 04             	mov    0x4(%rax),%eax
  802f60:	8d 50 01             	lea    0x1(%rax),%edx
  802f63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f67:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f6a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f73:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802f77:	0f 82 64 ff ff ff    	jb     802ee1 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802f7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f81:	c9                   	leaveq 
  802f82:	c3                   	retq   

0000000000802f83 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802f83:	55                   	push   %rbp
  802f84:	48 89 e5             	mov    %rsp,%rbp
  802f87:	48 83 ec 20          	sub    $0x20,%rsp
  802f8b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f97:	48 89 c7             	mov    %rax,%rdi
  802f9a:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  802fa1:	00 00 00 
  802fa4:	ff d0                	callq  *%rax
  802fa6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802faa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fae:	48 be 0c 3d 80 00 00 	movabs $0x803d0c,%rsi
  802fb5:	00 00 00 
  802fb8:	48 89 c7             	mov    %rax,%rdi
  802fbb:	48 b8 60 0e 80 00 00 	movabs $0x800e60,%rax
  802fc2:	00 00 00 
  802fc5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802fc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fcb:	8b 50 04             	mov    0x4(%rax),%edx
  802fce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fd2:	8b 00                	mov    (%rax),%eax
  802fd4:	29 c2                	sub    %eax,%edx
  802fd6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fda:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802fe0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fe4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802feb:	00 00 00 
	stat->st_dev = &devpipe;
  802fee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ff2:	48 b9 e0 50 80 00 00 	movabs $0x8050e0,%rcx
  802ff9:	00 00 00 
  802ffc:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803003:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803008:	c9                   	leaveq 
  803009:	c3                   	retq   

000000000080300a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80300a:	55                   	push   %rbp
  80300b:	48 89 e5             	mov    %rsp,%rbp
  80300e:	48 83 ec 10          	sub    $0x10,%rsp
  803012:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803016:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80301a:	48 89 c6             	mov    %rax,%rsi
  80301d:	bf 00 00 00 00       	mov    $0x0,%edi
  803022:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  803029:	00 00 00 
  80302c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80302e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803032:	48 89 c7             	mov    %rax,%rdi
  803035:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  80303c:	00 00 00 
  80303f:	ff d0                	callq  *%rax
  803041:	48 89 c6             	mov    %rax,%rsi
  803044:	bf 00 00 00 00       	mov    $0x0,%edi
  803049:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  803050:	00 00 00 
  803053:	ff d0                	callq  *%rax
}
  803055:	c9                   	leaveq 
  803056:	c3                   	retq   

0000000000803057 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803057:	55                   	push   %rbp
  803058:	48 89 e5             	mov    %rsp,%rbp
  80305b:	48 83 ec 20          	sub    $0x20,%rsp
  80305f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803062:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803065:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803068:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80306c:	be 01 00 00 00       	mov    $0x1,%esi
  803071:	48 89 c7             	mov    %rax,%rdi
  803074:	48 b8 47 16 80 00 00 	movabs $0x801647,%rax
  80307b:	00 00 00 
  80307e:	ff d0                	callq  *%rax
}
  803080:	c9                   	leaveq 
  803081:	c3                   	retq   

0000000000803082 <getchar>:

int
getchar(void)
{
  803082:	55                   	push   %rbp
  803083:	48 89 e5             	mov    %rsp,%rbp
  803086:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80308a:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80308e:	ba 01 00 00 00       	mov    $0x1,%edx
  803093:	48 89 c6             	mov    %rax,%rsi
  803096:	bf 00 00 00 00       	mov    $0x0,%edi
  80309b:	48 b8 42 20 80 00 00 	movabs $0x802042,%rax
  8030a2:	00 00 00 
  8030a5:	ff d0                	callq  *%rax
  8030a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8030aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ae:	79 05                	jns    8030b5 <getchar+0x33>
		return r;
  8030b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b3:	eb 14                	jmp    8030c9 <getchar+0x47>
	if (r < 1)
  8030b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b9:	7f 07                	jg     8030c2 <getchar+0x40>
		return -E_EOF;
  8030bb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8030c0:	eb 07                	jmp    8030c9 <getchar+0x47>
	return c;
  8030c2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8030c6:	0f b6 c0             	movzbl %al,%eax
}
  8030c9:	c9                   	leaveq 
  8030ca:	c3                   	retq   

00000000008030cb <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8030cb:	55                   	push   %rbp
  8030cc:	48 89 e5             	mov    %rsp,%rbp
  8030cf:	48 83 ec 20          	sub    $0x20,%rsp
  8030d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030d6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030dd:	48 89 d6             	mov    %rdx,%rsi
  8030e0:	89 c7                	mov    %eax,%edi
  8030e2:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  8030e9:	00 00 00 
  8030ec:	ff d0                	callq  *%rax
  8030ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f5:	79 05                	jns    8030fc <iscons+0x31>
		return r;
  8030f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fa:	eb 1a                	jmp    803116 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8030fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803100:	8b 10                	mov    (%rax),%edx
  803102:	48 b8 20 51 80 00 00 	movabs $0x805120,%rax
  803109:	00 00 00 
  80310c:	8b 00                	mov    (%rax),%eax
  80310e:	39 c2                	cmp    %eax,%edx
  803110:	0f 94 c0             	sete   %al
  803113:	0f b6 c0             	movzbl %al,%eax
}
  803116:	c9                   	leaveq 
  803117:	c3                   	retq   

0000000000803118 <opencons>:

int
opencons(void)
{
  803118:	55                   	push   %rbp
  803119:	48 89 e5             	mov    %rsp,%rbp
  80311c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803120:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803124:	48 89 c7             	mov    %rax,%rdi
  803127:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  80312e:	00 00 00 
  803131:	ff d0                	callq  *%rax
  803133:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803136:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80313a:	79 05                	jns    803141 <opencons+0x29>
		return r;
  80313c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313f:	eb 5b                	jmp    80319c <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803141:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803145:	ba 07 04 00 00       	mov    $0x407,%edx
  80314a:	48 89 c6             	mov    %rax,%rsi
  80314d:	bf 00 00 00 00       	mov    $0x0,%edi
  803152:	48 b8 8f 17 80 00 00 	movabs $0x80178f,%rax
  803159:	00 00 00 
  80315c:	ff d0                	callq  *%rax
  80315e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803161:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803165:	79 05                	jns    80316c <opencons+0x54>
		return r;
  803167:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80316a:	eb 30                	jmp    80319c <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80316c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803170:	48 ba 20 51 80 00 00 	movabs $0x805120,%rdx
  803177:	00 00 00 
  80317a:	8b 12                	mov    (%rdx),%edx
  80317c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80317e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803182:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803189:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80318d:	48 89 c7             	mov    %rax,%rdi
  803190:	48 b8 2a 1b 80 00 00 	movabs $0x801b2a,%rax
  803197:	00 00 00 
  80319a:	ff d0                	callq  *%rax
}
  80319c:	c9                   	leaveq 
  80319d:	c3                   	retq   

000000000080319e <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80319e:	55                   	push   %rbp
  80319f:	48 89 e5             	mov    %rsp,%rbp
  8031a2:	48 83 ec 30          	sub    $0x30,%rsp
  8031a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8031b2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8031b7:	75 07                	jne    8031c0 <devcons_read+0x22>
		return 0;
  8031b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031be:	eb 4b                	jmp    80320b <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8031c0:	eb 0c                	jmp    8031ce <devcons_read+0x30>
		sys_yield();
  8031c2:	48 b8 51 17 80 00 00 	movabs $0x801751,%rax
  8031c9:	00 00 00 
  8031cc:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8031ce:	48 b8 91 16 80 00 00 	movabs $0x801691,%rax
  8031d5:	00 00 00 
  8031d8:	ff d0                	callq  *%rax
  8031da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e1:	74 df                	je     8031c2 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8031e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e7:	79 05                	jns    8031ee <devcons_read+0x50>
		return c;
  8031e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ec:	eb 1d                	jmp    80320b <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8031ee:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8031f2:	75 07                	jne    8031fb <devcons_read+0x5d>
		return 0;
  8031f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f9:	eb 10                	jmp    80320b <devcons_read+0x6d>
	*(char*)vbuf = c;
  8031fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031fe:	89 c2                	mov    %eax,%edx
  803200:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803204:	88 10                	mov    %dl,(%rax)
	return 1;
  803206:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80320b:	c9                   	leaveq 
  80320c:	c3                   	retq   

000000000080320d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80320d:	55                   	push   %rbp
  80320e:	48 89 e5             	mov    %rsp,%rbp
  803211:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803218:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80321f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803226:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80322d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803234:	eb 76                	jmp    8032ac <devcons_write+0x9f>
		m = n - tot;
  803236:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80323d:	89 c2                	mov    %eax,%edx
  80323f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803242:	29 c2                	sub    %eax,%edx
  803244:	89 d0                	mov    %edx,%eax
  803246:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803249:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80324c:	83 f8 7f             	cmp    $0x7f,%eax
  80324f:	76 07                	jbe    803258 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803251:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803258:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80325b:	48 63 d0             	movslq %eax,%rdx
  80325e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803261:	48 63 c8             	movslq %eax,%rcx
  803264:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80326b:	48 01 c1             	add    %rax,%rcx
  80326e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803275:	48 89 ce             	mov    %rcx,%rsi
  803278:	48 89 c7             	mov    %rax,%rdi
  80327b:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  803282:	00 00 00 
  803285:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803287:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80328a:	48 63 d0             	movslq %eax,%rdx
  80328d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803294:	48 89 d6             	mov    %rdx,%rsi
  803297:	48 89 c7             	mov    %rax,%rdi
  80329a:	48 b8 47 16 80 00 00 	movabs $0x801647,%rax
  8032a1:	00 00 00 
  8032a4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8032a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032a9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8032ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032af:	48 98                	cltq   
  8032b1:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8032b8:	0f 82 78 ff ff ff    	jb     803236 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8032be:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8032c1:	c9                   	leaveq 
  8032c2:	c3                   	retq   

00000000008032c3 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8032c3:	55                   	push   %rbp
  8032c4:	48 89 e5             	mov    %rsp,%rbp
  8032c7:	48 83 ec 08          	sub    $0x8,%rsp
  8032cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8032cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032d4:	c9                   	leaveq 
  8032d5:	c3                   	retq   

00000000008032d6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8032d6:	55                   	push   %rbp
  8032d7:	48 89 e5             	mov    %rsp,%rbp
  8032da:	48 83 ec 10          	sub    $0x10,%rsp
  8032de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8032e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ea:	48 be 18 3d 80 00 00 	movabs $0x803d18,%rsi
  8032f1:	00 00 00 
  8032f4:	48 89 c7             	mov    %rax,%rdi
  8032f7:	48 b8 60 0e 80 00 00 	movabs $0x800e60,%rax
  8032fe:	00 00 00 
  803301:	ff d0                	callq  *%rax
	return 0;
  803303:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803308:	c9                   	leaveq 
  803309:	c3                   	retq   

000000000080330a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80330a:	55                   	push   %rbp
  80330b:	48 89 e5             	mov    %rsp,%rbp
  80330e:	53                   	push   %rbx
  80330f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803316:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80331d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803323:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80332a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803331:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803338:	84 c0                	test   %al,%al
  80333a:	74 23                	je     80335f <_panic+0x55>
  80333c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803343:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803347:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80334b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80334f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803353:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803357:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80335b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80335f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803366:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80336d:	00 00 00 
  803370:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803377:	00 00 00 
  80337a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80337e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803385:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80338c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803393:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80339a:	00 00 00 
  80339d:	48 8b 18             	mov    (%rax),%rbx
  8033a0:	48 b8 13 17 80 00 00 	movabs $0x801713,%rax
  8033a7:	00 00 00 
  8033aa:	ff d0                	callq  *%rax
  8033ac:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8033b2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8033b9:	41 89 c8             	mov    %ecx,%r8d
  8033bc:	48 89 d1             	mov    %rdx,%rcx
  8033bf:	48 89 da             	mov    %rbx,%rdx
  8033c2:	89 c6                	mov    %eax,%esi
  8033c4:	48 bf 20 3d 80 00 00 	movabs $0x803d20,%rdi
  8033cb:	00 00 00 
  8033ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d3:	49 b9 6a 02 80 00 00 	movabs $0x80026a,%r9
  8033da:	00 00 00 
  8033dd:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8033e0:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8033e7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8033ee:	48 89 d6             	mov    %rdx,%rsi
  8033f1:	48 89 c7             	mov    %rax,%rdi
  8033f4:	48 b8 be 01 80 00 00 	movabs $0x8001be,%rax
  8033fb:	00 00 00 
  8033fe:	ff d0                	callq  *%rax
	cprintf("\n");
  803400:	48 bf 43 3d 80 00 00 	movabs $0x803d43,%rdi
  803407:	00 00 00 
  80340a:	b8 00 00 00 00       	mov    $0x0,%eax
  80340f:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  803416:	00 00 00 
  803419:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80341b:	cc                   	int3   
  80341c:	eb fd                	jmp    80341b <_panic+0x111>

000000000080341e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80341e:	55                   	push   %rbp
  80341f:	48 89 e5             	mov    %rsp,%rbp
  803422:	48 83 ec 30          	sub    $0x30,%rsp
  803426:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80342a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80342e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  803432:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803437:	75 08                	jne    803441 <ipc_recv+0x23>
  803439:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  803440:	ff 
	int res=sys_ipc_recv(pg);
  803441:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803445:	48 89 c7             	mov    %rax,%rdi
  803448:	48 b8 03 1a 80 00 00 	movabs $0x801a03,%rax
  80344f:	00 00 00 
  803452:	ff d0                	callq  *%rax
  803454:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  803457:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80345c:	74 26                	je     803484 <ipc_recv+0x66>
  80345e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803462:	75 15                	jne    803479 <ipc_recv+0x5b>
  803464:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80346b:	00 00 00 
  80346e:	48 8b 00             	mov    (%rax),%rax
  803471:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803477:	eb 05                	jmp    80347e <ipc_recv+0x60>
  803479:	b8 00 00 00 00       	mov    $0x0,%eax
  80347e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803482:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  803484:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803489:	74 26                	je     8034b1 <ipc_recv+0x93>
  80348b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80348f:	75 15                	jne    8034a6 <ipc_recv+0x88>
  803491:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803498:	00 00 00 
  80349b:	48 8b 00             	mov    (%rax),%rax
  80349e:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  8034a4:	eb 05                	jmp    8034ab <ipc_recv+0x8d>
  8034a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ab:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034af:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  8034b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b5:	75 15                	jne    8034cc <ipc_recv+0xae>
  8034b7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034be:	00 00 00 
  8034c1:	48 8b 00             	mov    (%rax),%rax
  8034c4:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  8034ca:	eb 03                	jmp    8034cf <ipc_recv+0xb1>
  8034cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  8034cf:	c9                   	leaveq 
  8034d0:	c3                   	retq   

00000000008034d1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8034d1:	55                   	push   %rbp
  8034d2:	48 89 e5             	mov    %rsp,%rbp
  8034d5:	48 83 ec 30          	sub    $0x30,%rsp
  8034d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034dc:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8034df:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8034e3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  8034e6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8034eb:	75 0a                	jne    8034f7 <ipc_send+0x26>
  8034ed:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8034f4:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8034f5:	eb 3e                	jmp    803535 <ipc_send+0x64>
  8034f7:	eb 3c                	jmp    803535 <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  8034f9:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8034fd:	74 2a                	je     803529 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  8034ff:	48 ba 48 3d 80 00 00 	movabs $0x803d48,%rdx
  803506:	00 00 00 
  803509:	be 39 00 00 00       	mov    $0x39,%esi
  80350e:	48 bf 73 3d 80 00 00 	movabs $0x803d73,%rdi
  803515:	00 00 00 
  803518:	b8 00 00 00 00       	mov    $0x0,%eax
  80351d:	48 b9 0a 33 80 00 00 	movabs $0x80330a,%rcx
  803524:	00 00 00 
  803527:	ff d1                	callq  *%rcx
		sys_yield();  
  803529:	48 b8 51 17 80 00 00 	movabs $0x801751,%rax
  803530:	00 00 00 
  803533:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  803535:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803538:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80353b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80353f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803542:	89 c7                	mov    %eax,%edi
  803544:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  80354b:	00 00 00 
  80354e:	ff d0                	callq  *%rax
  803550:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803553:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803557:	78 a0                	js     8034f9 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  803559:	c9                   	leaveq 
  80355a:	c3                   	retq   

000000000080355b <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  80355b:	55                   	push   %rbp
  80355c:	48 89 e5             	mov    %rsp,%rbp
  80355f:	48 83 ec 10          	sub    $0x10,%rsp
  803563:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  803567:	48 ba 80 3d 80 00 00 	movabs $0x803d80,%rdx
  80356e:	00 00 00 
  803571:	be 47 00 00 00       	mov    $0x47,%esi
  803576:	48 bf 73 3d 80 00 00 	movabs $0x803d73,%rdi
  80357d:	00 00 00 
  803580:	b8 00 00 00 00       	mov    $0x0,%eax
  803585:	48 b9 0a 33 80 00 00 	movabs $0x80330a,%rcx
  80358c:	00 00 00 
  80358f:	ff d1                	callq  *%rcx

0000000000803591 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803591:	55                   	push   %rbp
  803592:	48 89 e5             	mov    %rsp,%rbp
  803595:	48 83 ec 20          	sub    $0x20,%rsp
  803599:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80359c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80359f:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  8035a3:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  8035a6:	48 ba a8 3d 80 00 00 	movabs $0x803da8,%rdx
  8035ad:	00 00 00 
  8035b0:	be 50 00 00 00       	mov    $0x50,%esi
  8035b5:	48 bf 73 3d 80 00 00 	movabs $0x803d73,%rdi
  8035bc:	00 00 00 
  8035bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c4:	48 b9 0a 33 80 00 00 	movabs $0x80330a,%rcx
  8035cb:	00 00 00 
  8035ce:	ff d1                	callq  *%rcx

00000000008035d0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8035d0:	55                   	push   %rbp
  8035d1:	48 89 e5             	mov    %rsp,%rbp
  8035d4:	48 83 ec 14          	sub    $0x14,%rsp
  8035d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8035db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8035e2:	eb 4e                	jmp    803632 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8035e4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8035eb:	00 00 00 
  8035ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f1:	48 98                	cltq   
  8035f3:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8035fa:	48 01 d0             	add    %rdx,%rax
  8035fd:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803603:	8b 00                	mov    (%rax),%eax
  803605:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803608:	75 24                	jne    80362e <ipc_find_env+0x5e>
			return envs[i].env_id;
  80360a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803611:	00 00 00 
  803614:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803617:	48 98                	cltq   
  803619:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  803620:	48 01 d0             	add    %rdx,%rax
  803623:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803629:	8b 40 08             	mov    0x8(%rax),%eax
  80362c:	eb 12                	jmp    803640 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80362e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803632:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803639:	7e a9                	jle    8035e4 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  80363b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803640:	c9                   	leaveq 
  803641:	c3                   	retq   

0000000000803642 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803642:	55                   	push   %rbp
  803643:	48 89 e5             	mov    %rsp,%rbp
  803646:	48 83 ec 18          	sub    $0x18,%rsp
  80364a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80364e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803652:	48 c1 e8 15          	shr    $0x15,%rax
  803656:	48 89 c2             	mov    %rax,%rdx
  803659:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803660:	01 00 00 
  803663:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803667:	83 e0 01             	and    $0x1,%eax
  80366a:	48 85 c0             	test   %rax,%rax
  80366d:	75 07                	jne    803676 <pageref+0x34>
		return 0;
  80366f:	b8 00 00 00 00       	mov    $0x0,%eax
  803674:	eb 53                	jmp    8036c9 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80367a:	48 c1 e8 0c          	shr    $0xc,%rax
  80367e:	48 89 c2             	mov    %rax,%rdx
  803681:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803688:	01 00 00 
  80368b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80368f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803693:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803697:	83 e0 01             	and    $0x1,%eax
  80369a:	48 85 c0             	test   %rax,%rax
  80369d:	75 07                	jne    8036a6 <pageref+0x64>
		return 0;
  80369f:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a4:	eb 23                	jmp    8036c9 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8036a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036aa:	48 c1 e8 0c          	shr    $0xc,%rax
  8036ae:	48 89 c2             	mov    %rax,%rdx
  8036b1:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8036b8:	00 00 00 
  8036bb:	48 c1 e2 04          	shl    $0x4,%rdx
  8036bf:	48 01 d0             	add    %rdx,%rax
  8036c2:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8036c6:	0f b7 c0             	movzwl %ax,%eax
}
  8036c9:	c9                   	leaveq 
  8036ca:	c3                   	retq   
