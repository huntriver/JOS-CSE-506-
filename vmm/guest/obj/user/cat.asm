
vmm/guest/obj/user/cat:     file format elf64-x86-64


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
  80003c:	e8 08 02 00 00       	callq  800249 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800052:	eb 68                	jmp    8000bc <cat+0x79>
		if ((r = write(1, buf, n)) != n)
  800054:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800058:	48 89 c2             	mov    %rax,%rdx
  80005b:	48 be 20 60 80 00 00 	movabs $0x806020,%rsi
  800062:	00 00 00 
  800065:	bf 01 00 00 00       	mov    $0x1,%edi
  80006a:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800079:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80007c:	48 98                	cltq   
  80007e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800082:	74 38                	je     8000bc <cat+0x79>
			panic("write error copying %s: %e", s, r);
  800084:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80008b:	41 89 d0             	mov    %edx,%r8d
  80008e:	48 89 c1             	mov    %rax,%rcx
  800091:	48 ba 80 3b 80 00 00 	movabs $0x803b80,%rdx
  800098:	00 00 00 
  80009b:	be 0d 00 00 00       	mov    $0xd,%esi
  8000a0:	48 bf 9b 3b 80 00 00 	movabs $0x803b9b,%rdi
  8000a7:	00 00 00 
  8000aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000af:	49 b9 ef 02 80 00 00 	movabs $0x8002ef,%r9
  8000b6:	00 00 00 
  8000b9:	41 ff d1             	callq  *%r9
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  8000bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000bf:	ba 00 20 00 00       	mov    $0x2000,%edx
  8000c4:	48 be 20 60 80 00 00 	movabs $0x806020,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 00 23 80 00 00 	movabs $0x802300,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	48 98                	cltq   
  8000de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8000e2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000e7:	0f 8f 67 ff ff ff    	jg     800054 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000ed:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000f2:	79 39                	jns    80012d <cat+0xea>
		panic("error reading %s: %e", s, n);
  8000f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000fc:	49 89 d0             	mov    %rdx,%r8
  8000ff:	48 89 c1             	mov    %rax,%rcx
  800102:	48 ba a6 3b 80 00 00 	movabs $0x803ba6,%rdx
  800109:	00 00 00 
  80010c:	be 0f 00 00 00       	mov    $0xf,%esi
  800111:	48 bf 9b 3b 80 00 00 	movabs $0x803b9b,%rdi
  800118:	00 00 00 
  80011b:	b8 00 00 00 00       	mov    $0x0,%eax
  800120:	49 b9 ef 02 80 00 00 	movabs $0x8002ef,%r9
  800127:	00 00 00 
  80012a:	41 ff d1             	callq  *%r9
}
  80012d:	c9                   	leaveq 
  80012e:	c3                   	retq   

000000000080012f <umain>:

void
umain(int argc, char **argv)
{
  80012f:	55                   	push   %rbp
  800130:	48 89 e5             	mov    %rsp,%rbp
  800133:	53                   	push   %rbx
  800134:	48 83 ec 28          	sub    $0x28,%rsp
  800138:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80013b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "cat";
  80013f:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800146:	00 00 00 
  800149:	48 bb bb 3b 80 00 00 	movabs $0x803bbb,%rbx
  800150:	00 00 00 
  800153:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  800156:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  80015a:	75 20                	jne    80017c <umain+0x4d>
		cat(0, "<stdin>");
  80015c:	48 be bf 3b 80 00 00 	movabs $0x803bbf,%rsi
  800163:	00 00 00 
  800166:	bf 00 00 00 00       	mov    $0x0,%edi
  80016b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800172:	00 00 00 
  800175:	ff d0                	callq  *%rax
  800177:	e9 c6 00 00 00       	jmpq   800242 <umain+0x113>
	else
		for (i = 1; i < argc; i++) {
  80017c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  800183:	e9 ae 00 00 00       	jmpq   800236 <umain+0x107>
			f = open(argv[i], O_RDONLY);
  800188:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80018b:	48 98                	cltq   
  80018d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800194:	00 
  800195:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800199:	48 01 d0             	add    %rdx,%rax
  80019c:	48 8b 00             	mov    (%rax),%rax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	48 89 c7             	mov    %rax,%rdi
  8001a7:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax
  8001b3:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  8001b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8001ba:	79 3a                	jns    8001f6 <umain+0xc7>
				printf("can't open %s: %e\n", argv[i], f);
  8001bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bf:	48 98                	cltq   
  8001c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001c8:	00 
  8001c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8001cd:	48 01 d0             	add    %rdx,%rax
  8001d0:	48 8b 00             	mov    (%rax),%rax
  8001d3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8001d6:	48 89 c6             	mov    %rax,%rsi
  8001d9:	48 bf c7 3b 80 00 00 	movabs $0x803bc7,%rdi
  8001e0:	00 00 00 
  8001e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e8:	48 b9 9a 2f 80 00 00 	movabs $0x802f9a,%rcx
  8001ef:	00 00 00 
  8001f2:	ff d1                	callq  *%rcx
  8001f4:	eb 3c                	jmp    800232 <umain+0x103>
			else {
				cat(f, argv[i]);
  8001f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800202:	00 
  800203:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800207:	48 01 d0             	add    %rdx,%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800210:	48 89 d6             	mov    %rdx,%rsi
  800213:	89 c7                	mov    %eax,%edi
  800215:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80021c:	00 00 00 
  80021f:	ff d0                	callq  *%rax
				close(f);
  800221:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800224:	89 c7                	mov    %eax,%edi
  800226:	48 b8 de 20 80 00 00 	movabs $0x8020de,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800232:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800236:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800239:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  80023c:	0f 8c 46 ff ff ff    	jl     800188 <umain+0x59>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  800242:	48 83 c4 28          	add    $0x28,%rsp
  800246:	5b                   	pop    %rbx
  800247:	5d                   	pop    %rbp
  800248:	c3                   	retq   

0000000000800249 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800249:	55                   	push   %rbp
  80024a:	48 89 e5             	mov    %rsp,%rbp
  80024d:	48 83 ec 10          	sub    $0x10,%rsp
  800251:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800254:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  800258:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
  800264:	48 98                	cltq   
  800266:	25 ff 03 00 00       	and    $0x3ff,%eax
  80026b:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  800272:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800279:	00 00 00 
  80027c:	48 01 c2             	add    %rax,%rdx
  80027f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800286:	00 00 00 
  800289:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80028c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800290:	7e 14                	jle    8002a6 <libmain+0x5d>
		binaryname = argv[0];
  800292:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800296:	48 8b 10             	mov    (%rax),%rdx
  800299:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8002a0:	00 00 00 
  8002a3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ad:	48 89 d6             	mov    %rdx,%rsi
  8002b0:	89 c7                	mov    %eax,%edi
  8002b2:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  8002b9:	00 00 00 
  8002bc:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002be:	48 b8 cc 02 80 00 00 	movabs $0x8002cc,%rax
  8002c5:	00 00 00 
  8002c8:	ff d0                	callq  *%rax
}
  8002ca:	c9                   	leaveq 
  8002cb:	c3                   	retq   

00000000008002cc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002cc:	55                   	push   %rbp
  8002cd:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8002d0:	48 b8 29 21 80 00 00 	movabs $0x802129,%rax
  8002d7:	00 00 00 
  8002da:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8002dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8002e1:	48 b8 8d 19 80 00 00 	movabs $0x80198d,%rax
  8002e8:	00 00 00 
  8002eb:	ff d0                	callq  *%rax
}
  8002ed:	5d                   	pop    %rbp
  8002ee:	c3                   	retq   

00000000008002ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002ef:	55                   	push   %rbp
  8002f0:	48 89 e5             	mov    %rsp,%rbp
  8002f3:	53                   	push   %rbx
  8002f4:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8002fb:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800302:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800308:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80030f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800316:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80031d:	84 c0                	test   %al,%al
  80031f:	74 23                	je     800344 <_panic+0x55>
  800321:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800328:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80032c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800330:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800334:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800338:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80033c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800340:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800344:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80034b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800352:	00 00 00 
  800355:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80035c:	00 00 00 
  80035f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800363:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80036a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800371:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800378:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80037f:	00 00 00 
  800382:	48 8b 18             	mov    (%rax),%rbx
  800385:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  80038c:	00 00 00 
  80038f:	ff d0                	callq  *%rax
  800391:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800397:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80039e:	41 89 c8             	mov    %ecx,%r8d
  8003a1:	48 89 d1             	mov    %rdx,%rcx
  8003a4:	48 89 da             	mov    %rbx,%rdx
  8003a7:	89 c6                	mov    %eax,%esi
  8003a9:	48 bf e8 3b 80 00 00 	movabs $0x803be8,%rdi
  8003b0:	00 00 00 
  8003b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b8:	49 b9 28 05 80 00 00 	movabs $0x800528,%r9
  8003bf:	00 00 00 
  8003c2:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003c5:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003cc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d3:	48 89 d6             	mov    %rdx,%rsi
  8003d6:	48 89 c7             	mov    %rax,%rdi
  8003d9:	48 b8 7c 04 80 00 00 	movabs $0x80047c,%rax
  8003e0:	00 00 00 
  8003e3:	ff d0                	callq  *%rax
	cprintf("\n");
  8003e5:	48 bf 0b 3c 80 00 00 	movabs $0x803c0b,%rdi
  8003ec:	00 00 00 
  8003ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f4:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  8003fb:	00 00 00 
  8003fe:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800400:	cc                   	int3   
  800401:	eb fd                	jmp    800400 <_panic+0x111>

0000000000800403 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800403:	55                   	push   %rbp
  800404:	48 89 e5             	mov    %rsp,%rbp
  800407:	48 83 ec 10          	sub    $0x10,%rsp
  80040b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80040e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800416:	8b 00                	mov    (%rax),%eax
  800418:	8d 48 01             	lea    0x1(%rax),%ecx
  80041b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80041f:	89 0a                	mov    %ecx,(%rdx)
  800421:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800424:	89 d1                	mov    %edx,%ecx
  800426:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042a:	48 98                	cltq   
  80042c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800430:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800434:	8b 00                	mov    (%rax),%eax
  800436:	3d ff 00 00 00       	cmp    $0xff,%eax
  80043b:	75 2c                	jne    800469 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80043d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800441:	8b 00                	mov    (%rax),%eax
  800443:	48 98                	cltq   
  800445:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800449:	48 83 c2 08          	add    $0x8,%rdx
  80044d:	48 89 c6             	mov    %rax,%rsi
  800450:	48 89 d7             	mov    %rdx,%rdi
  800453:	48 b8 05 19 80 00 00 	movabs $0x801905,%rax
  80045a:	00 00 00 
  80045d:	ff d0                	callq  *%rax
        b->idx = 0;
  80045f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800463:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800469:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046d:	8b 40 04             	mov    0x4(%rax),%eax
  800470:	8d 50 01             	lea    0x1(%rax),%edx
  800473:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800477:	89 50 04             	mov    %edx,0x4(%rax)
}
  80047a:	c9                   	leaveq 
  80047b:	c3                   	retq   

000000000080047c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80047c:	55                   	push   %rbp
  80047d:	48 89 e5             	mov    %rsp,%rbp
  800480:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800487:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80048e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800495:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80049c:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004a3:	48 8b 0a             	mov    (%rdx),%rcx
  8004a6:	48 89 08             	mov    %rcx,(%rax)
  8004a9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004ad:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004b1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004b5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004c0:	00 00 00 
    b.cnt = 0;
  8004c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004ca:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004cd:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004d4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004db:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004e2:	48 89 c6             	mov    %rax,%rsi
  8004e5:	48 bf 03 04 80 00 00 	movabs $0x800403,%rdi
  8004ec:	00 00 00 
  8004ef:	48 b8 db 08 80 00 00 	movabs $0x8008db,%rax
  8004f6:	00 00 00 
  8004f9:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004fb:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800501:	48 98                	cltq   
  800503:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80050a:	48 83 c2 08          	add    $0x8,%rdx
  80050e:	48 89 c6             	mov    %rax,%rsi
  800511:	48 89 d7             	mov    %rdx,%rdi
  800514:	48 b8 05 19 80 00 00 	movabs $0x801905,%rax
  80051b:	00 00 00 
  80051e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800520:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800526:	c9                   	leaveq 
  800527:	c3                   	retq   

0000000000800528 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800528:	55                   	push   %rbp
  800529:	48 89 e5             	mov    %rsp,%rbp
  80052c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800533:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80053a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800541:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800548:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80054f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800556:	84 c0                	test   %al,%al
  800558:	74 20                	je     80057a <cprintf+0x52>
  80055a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80055e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800562:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800566:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80056a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80056e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800572:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800576:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80057a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800581:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800588:	00 00 00 
  80058b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800592:	00 00 00 
  800595:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800599:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005a0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005a7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005ae:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005b5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005bc:	48 8b 0a             	mov    (%rdx),%rcx
  8005bf:	48 89 08             	mov    %rcx,(%rax)
  8005c2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005c6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ca:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005ce:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005d2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005d9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005e0:	48 89 d6             	mov    %rdx,%rsi
  8005e3:	48 89 c7             	mov    %rax,%rdi
  8005e6:	48 b8 7c 04 80 00 00 	movabs $0x80047c,%rax
  8005ed:	00 00 00 
  8005f0:	ff d0                	callq  *%rax
  8005f2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005f8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005fe:	c9                   	leaveq 
  8005ff:	c3                   	retq   

0000000000800600 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800600:	55                   	push   %rbp
  800601:	48 89 e5             	mov    %rsp,%rbp
  800604:	53                   	push   %rbx
  800605:	48 83 ec 38          	sub    $0x38,%rsp
  800609:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80060d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800611:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800615:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800618:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80061c:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800620:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800623:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800627:	77 3b                	ja     800664 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800629:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80062c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800630:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800633:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800637:	ba 00 00 00 00       	mov    $0x0,%edx
  80063c:	48 f7 f3             	div    %rbx
  80063f:	48 89 c2             	mov    %rax,%rdx
  800642:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800645:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800648:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80064c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800650:	41 89 f9             	mov    %edi,%r9d
  800653:	48 89 c7             	mov    %rax,%rdi
  800656:	48 b8 00 06 80 00 00 	movabs $0x800600,%rax
  80065d:	00 00 00 
  800660:	ff d0                	callq  *%rax
  800662:	eb 1e                	jmp    800682 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800664:	eb 12                	jmp    800678 <printnum+0x78>
			putch(padc, putdat);
  800666:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80066a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	48 89 ce             	mov    %rcx,%rsi
  800674:	89 d7                	mov    %edx,%edi
  800676:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800678:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80067c:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800680:	7f e4                	jg     800666 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800682:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	48 f7 f1             	div    %rcx
  800691:	48 89 d0             	mov    %rdx,%rax
  800694:	48 ba 10 3e 80 00 00 	movabs $0x803e10,%rdx
  80069b:	00 00 00 
  80069e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006a2:	0f be d0             	movsbl %al,%edx
  8006a5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ad:	48 89 ce             	mov    %rcx,%rsi
  8006b0:	89 d7                	mov    %edx,%edi
  8006b2:	ff d0                	callq  *%rax
}
  8006b4:	48 83 c4 38          	add    $0x38,%rsp
  8006b8:	5b                   	pop    %rbx
  8006b9:	5d                   	pop    %rbp
  8006ba:	c3                   	retq   

00000000008006bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006bb:	55                   	push   %rbp
  8006bc:	48 89 e5             	mov    %rsp,%rbp
  8006bf:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006c7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006ca:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006ce:	7e 52                	jle    800722 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d4:	8b 00                	mov    (%rax),%eax
  8006d6:	83 f8 30             	cmp    $0x30,%eax
  8006d9:	73 24                	jae    8006ff <getuint+0x44>
  8006db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006df:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e7:	8b 00                	mov    (%rax),%eax
  8006e9:	89 c0                	mov    %eax,%eax
  8006eb:	48 01 d0             	add    %rdx,%rax
  8006ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f2:	8b 12                	mov    (%rdx),%edx
  8006f4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fb:	89 0a                	mov    %ecx,(%rdx)
  8006fd:	eb 17                	jmp    800716 <getuint+0x5b>
  8006ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800703:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800707:	48 89 d0             	mov    %rdx,%rax
  80070a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80070e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800712:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800716:	48 8b 00             	mov    (%rax),%rax
  800719:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80071d:	e9 a3 00 00 00       	jmpq   8007c5 <getuint+0x10a>
	else if (lflag)
  800722:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800726:	74 4f                	je     800777 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800728:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072c:	8b 00                	mov    (%rax),%eax
  80072e:	83 f8 30             	cmp    $0x30,%eax
  800731:	73 24                	jae    800757 <getuint+0x9c>
  800733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800737:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80073b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073f:	8b 00                	mov    (%rax),%eax
  800741:	89 c0                	mov    %eax,%eax
  800743:	48 01 d0             	add    %rdx,%rax
  800746:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074a:	8b 12                	mov    (%rdx),%edx
  80074c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80074f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800753:	89 0a                	mov    %ecx,(%rdx)
  800755:	eb 17                	jmp    80076e <getuint+0xb3>
  800757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80075f:	48 89 d0             	mov    %rdx,%rax
  800762:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800766:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80076e:	48 8b 00             	mov    (%rax),%rax
  800771:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800775:	eb 4e                	jmp    8007c5 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077b:	8b 00                	mov    (%rax),%eax
  80077d:	83 f8 30             	cmp    $0x30,%eax
  800780:	73 24                	jae    8007a6 <getuint+0xeb>
  800782:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800786:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80078a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078e:	8b 00                	mov    (%rax),%eax
  800790:	89 c0                	mov    %eax,%eax
  800792:	48 01 d0             	add    %rdx,%rax
  800795:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800799:	8b 12                	mov    (%rdx),%edx
  80079b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80079e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a2:	89 0a                	mov    %ecx,(%rdx)
  8007a4:	eb 17                	jmp    8007bd <getuint+0x102>
  8007a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007aa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007ae:	48 89 d0             	mov    %rdx,%rax
  8007b1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007bd:	8b 00                	mov    (%rax),%eax
  8007bf:	89 c0                	mov    %eax,%eax
  8007c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007c9:	c9                   	leaveq 
  8007ca:	c3                   	retq   

00000000008007cb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007cb:	55                   	push   %rbp
  8007cc:	48 89 e5             	mov    %rsp,%rbp
  8007cf:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007d7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007da:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007de:	7e 52                	jle    800832 <getint+0x67>
		x=va_arg(*ap, long long);
  8007e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e4:	8b 00                	mov    (%rax),%eax
  8007e6:	83 f8 30             	cmp    $0x30,%eax
  8007e9:	73 24                	jae    80080f <getint+0x44>
  8007eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f7:	8b 00                	mov    (%rax),%eax
  8007f9:	89 c0                	mov    %eax,%eax
  8007fb:	48 01 d0             	add    %rdx,%rax
  8007fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800802:	8b 12                	mov    (%rdx),%edx
  800804:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800807:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080b:	89 0a                	mov    %ecx,(%rdx)
  80080d:	eb 17                	jmp    800826 <getint+0x5b>
  80080f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800813:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800817:	48 89 d0             	mov    %rdx,%rax
  80081a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80081e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800822:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800826:	48 8b 00             	mov    (%rax),%rax
  800829:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80082d:	e9 a3 00 00 00       	jmpq   8008d5 <getint+0x10a>
	else if (lflag)
  800832:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800836:	74 4f                	je     800887 <getint+0xbc>
		x=va_arg(*ap, long);
  800838:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083c:	8b 00                	mov    (%rax),%eax
  80083e:	83 f8 30             	cmp    $0x30,%eax
  800841:	73 24                	jae    800867 <getint+0x9c>
  800843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800847:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80084b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084f:	8b 00                	mov    (%rax),%eax
  800851:	89 c0                	mov    %eax,%eax
  800853:	48 01 d0             	add    %rdx,%rax
  800856:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085a:	8b 12                	mov    (%rdx),%edx
  80085c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80085f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800863:	89 0a                	mov    %ecx,(%rdx)
  800865:	eb 17                	jmp    80087e <getint+0xb3>
  800867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80086f:	48 89 d0             	mov    %rdx,%rax
  800872:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800876:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80087e:	48 8b 00             	mov    (%rax),%rax
  800881:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800885:	eb 4e                	jmp    8008d5 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800887:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088b:	8b 00                	mov    (%rax),%eax
  80088d:	83 f8 30             	cmp    $0x30,%eax
  800890:	73 24                	jae    8008b6 <getint+0xeb>
  800892:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800896:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80089a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089e:	8b 00                	mov    (%rax),%eax
  8008a0:	89 c0                	mov    %eax,%eax
  8008a2:	48 01 d0             	add    %rdx,%rax
  8008a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a9:	8b 12                	mov    (%rdx),%edx
  8008ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b2:	89 0a                	mov    %ecx,(%rdx)
  8008b4:	eb 17                	jmp    8008cd <getint+0x102>
  8008b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008be:	48 89 d0             	mov    %rdx,%rax
  8008c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008cd:	8b 00                	mov    (%rax),%eax
  8008cf:	48 98                	cltq   
  8008d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008d9:	c9                   	leaveq 
  8008da:	c3                   	retq   

00000000008008db <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008db:	55                   	push   %rbp
  8008dc:	48 89 e5             	mov    %rsp,%rbp
  8008df:	41 54                	push   %r12
  8008e1:	53                   	push   %rbx
  8008e2:	48 83 ec 60          	sub    $0x60,%rsp
  8008e6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008ea:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008ee:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f2:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008f6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008fa:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008fe:	48 8b 0a             	mov    (%rdx),%rcx
  800901:	48 89 08             	mov    %rcx,(%rax)
  800904:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800908:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80090c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800910:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800914:	eb 28                	jmp    80093e <vprintfmt+0x63>
			if (ch == '\0'){
  800916:	85 db                	test   %ebx,%ebx
  800918:	75 15                	jne    80092f <vprintfmt+0x54>
				current_color=WHITE;
  80091a:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  800921:	00 00 00 
  800924:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  80092a:	e9 fc 04 00 00       	jmpq   800e2b <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  80092f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800933:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800937:	48 89 d6             	mov    %rdx,%rsi
  80093a:	89 df                	mov    %ebx,%edi
  80093c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800942:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800946:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80094a:	0f b6 00             	movzbl (%rax),%eax
  80094d:	0f b6 d8             	movzbl %al,%ebx
  800950:	83 fb 25             	cmp    $0x25,%ebx
  800953:	75 c1                	jne    800916 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800955:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800959:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800960:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800967:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80096e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800975:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800979:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80097d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800981:	0f b6 00             	movzbl (%rax),%eax
  800984:	0f b6 d8             	movzbl %al,%ebx
  800987:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80098a:	83 f8 55             	cmp    $0x55,%eax
  80098d:	0f 87 64 04 00 00    	ja     800df7 <vprintfmt+0x51c>
  800993:	89 c0                	mov    %eax,%eax
  800995:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80099c:	00 
  80099d:	48 b8 38 3e 80 00 00 	movabs $0x803e38,%rax
  8009a4:	00 00 00 
  8009a7:	48 01 d0             	add    %rdx,%rax
  8009aa:	48 8b 00             	mov    (%rax),%rax
  8009ad:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009af:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009b3:	eb c0                	jmp    800975 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009b9:	eb ba                	jmp    800975 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009bb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009c2:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009c5:	89 d0                	mov    %edx,%eax
  8009c7:	c1 e0 02             	shl    $0x2,%eax
  8009ca:	01 d0                	add    %edx,%eax
  8009cc:	01 c0                	add    %eax,%eax
  8009ce:	01 d8                	add    %ebx,%eax
  8009d0:	83 e8 30             	sub    $0x30,%eax
  8009d3:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009d6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009da:	0f b6 00             	movzbl (%rax),%eax
  8009dd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009e0:	83 fb 2f             	cmp    $0x2f,%ebx
  8009e3:	7e 0c                	jle    8009f1 <vprintfmt+0x116>
  8009e5:	83 fb 39             	cmp    $0x39,%ebx
  8009e8:	7f 07                	jg     8009f1 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ea:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ef:	eb d1                	jmp    8009c2 <vprintfmt+0xe7>
			goto process_precision;
  8009f1:	eb 58                	jmp    800a4b <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  8009f3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f6:	83 f8 30             	cmp    $0x30,%eax
  8009f9:	73 17                	jae    800a12 <vprintfmt+0x137>
  8009fb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a02:	89 c0                	mov    %eax,%eax
  800a04:	48 01 d0             	add    %rdx,%rax
  800a07:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a0a:	83 c2 08             	add    $0x8,%edx
  800a0d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a10:	eb 0f                	jmp    800a21 <vprintfmt+0x146>
  800a12:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a16:	48 89 d0             	mov    %rdx,%rax
  800a19:	48 83 c2 08          	add    $0x8,%rdx
  800a1d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a21:	8b 00                	mov    (%rax),%eax
  800a23:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a26:	eb 23                	jmp    800a4b <vprintfmt+0x170>

		case '.':
			if (width < 0)
  800a28:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a2c:	79 0c                	jns    800a3a <vprintfmt+0x15f>
				width = 0;
  800a2e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a35:	e9 3b ff ff ff       	jmpq   800975 <vprintfmt+0x9a>
  800a3a:	e9 36 ff ff ff       	jmpq   800975 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  800a3f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a46:	e9 2a ff ff ff       	jmpq   800975 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  800a4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a4f:	79 12                	jns    800a63 <vprintfmt+0x188>
				width = precision, precision = -1;
  800a51:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a54:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a57:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a5e:	e9 12 ff ff ff       	jmpq   800975 <vprintfmt+0x9a>
  800a63:	e9 0d ff ff ff       	jmpq   800975 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a68:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a6c:	e9 04 ff ff ff       	jmpq   800975 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a74:	83 f8 30             	cmp    $0x30,%eax
  800a77:	73 17                	jae    800a90 <vprintfmt+0x1b5>
  800a79:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a80:	89 c0                	mov    %eax,%eax
  800a82:	48 01 d0             	add    %rdx,%rax
  800a85:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a88:	83 c2 08             	add    $0x8,%edx
  800a8b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a8e:	eb 0f                	jmp    800a9f <vprintfmt+0x1c4>
  800a90:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a94:	48 89 d0             	mov    %rdx,%rax
  800a97:	48 83 c2 08          	add    $0x8,%rdx
  800a9b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9f:	8b 10                	mov    (%rax),%edx
  800aa1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800aa5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa9:	48 89 ce             	mov    %rcx,%rsi
  800aac:	89 d7                	mov    %edx,%edi
  800aae:	ff d0                	callq  *%rax
			break;
  800ab0:	e9 70 03 00 00       	jmpq   800e25 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ab5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab8:	83 f8 30             	cmp    $0x30,%eax
  800abb:	73 17                	jae    800ad4 <vprintfmt+0x1f9>
  800abd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ac1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac4:	89 c0                	mov    %eax,%eax
  800ac6:	48 01 d0             	add    %rdx,%rax
  800ac9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800acc:	83 c2 08             	add    $0x8,%edx
  800acf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ad2:	eb 0f                	jmp    800ae3 <vprintfmt+0x208>
  800ad4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad8:	48 89 d0             	mov    %rdx,%rax
  800adb:	48 83 c2 08          	add    $0x8,%rdx
  800adf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ae3:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ae5:	85 db                	test   %ebx,%ebx
  800ae7:	79 02                	jns    800aeb <vprintfmt+0x210>
				err = -err;
  800ae9:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800aeb:	83 fb 15             	cmp    $0x15,%ebx
  800aee:	7f 16                	jg     800b06 <vprintfmt+0x22b>
  800af0:	48 b8 60 3d 80 00 00 	movabs $0x803d60,%rax
  800af7:	00 00 00 
  800afa:	48 63 d3             	movslq %ebx,%rdx
  800afd:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b01:	4d 85 e4             	test   %r12,%r12
  800b04:	75 2e                	jne    800b34 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  800b06:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0e:	89 d9                	mov    %ebx,%ecx
  800b10:	48 ba 21 3e 80 00 00 	movabs $0x803e21,%rdx
  800b17:	00 00 00 
  800b1a:	48 89 c7             	mov    %rax,%rdi
  800b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b22:	49 b8 34 0e 80 00 00 	movabs $0x800e34,%r8
  800b29:	00 00 00 
  800b2c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b2f:	e9 f1 02 00 00       	jmpq   800e25 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b34:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3c:	4c 89 e1             	mov    %r12,%rcx
  800b3f:	48 ba 2a 3e 80 00 00 	movabs $0x803e2a,%rdx
  800b46:	00 00 00 
  800b49:	48 89 c7             	mov    %rax,%rdi
  800b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b51:	49 b8 34 0e 80 00 00 	movabs $0x800e34,%r8
  800b58:	00 00 00 
  800b5b:	41 ff d0             	callq  *%r8
			break;
  800b5e:	e9 c2 02 00 00       	jmpq   800e25 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b66:	83 f8 30             	cmp    $0x30,%eax
  800b69:	73 17                	jae    800b82 <vprintfmt+0x2a7>
  800b6b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b72:	89 c0                	mov    %eax,%eax
  800b74:	48 01 d0             	add    %rdx,%rax
  800b77:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b7a:	83 c2 08             	add    $0x8,%edx
  800b7d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b80:	eb 0f                	jmp    800b91 <vprintfmt+0x2b6>
  800b82:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b86:	48 89 d0             	mov    %rdx,%rax
  800b89:	48 83 c2 08          	add    $0x8,%rdx
  800b8d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b91:	4c 8b 20             	mov    (%rax),%r12
  800b94:	4d 85 e4             	test   %r12,%r12
  800b97:	75 0a                	jne    800ba3 <vprintfmt+0x2c8>
				p = "(null)";
  800b99:	49 bc 2d 3e 80 00 00 	movabs $0x803e2d,%r12
  800ba0:	00 00 00 
			if (width > 0 && padc != '-')
  800ba3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ba7:	7e 3f                	jle    800be8 <vprintfmt+0x30d>
  800ba9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bad:	74 39                	je     800be8 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  800baf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bb2:	48 98                	cltq   
  800bb4:	48 89 c6             	mov    %rax,%rsi
  800bb7:	4c 89 e7             	mov    %r12,%rdi
  800bba:	48 b8 e0 10 80 00 00 	movabs $0x8010e0,%rax
  800bc1:	00 00 00 
  800bc4:	ff d0                	callq  *%rax
  800bc6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bc9:	eb 17                	jmp    800be2 <vprintfmt+0x307>
					putch(padc, putdat);
  800bcb:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bcf:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd7:	48 89 ce             	mov    %rcx,%rsi
  800bda:	89 d7                	mov    %edx,%edi
  800bdc:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bde:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800be2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800be6:	7f e3                	jg     800bcb <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be8:	eb 37                	jmp    800c21 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  800bea:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bee:	74 1e                	je     800c0e <vprintfmt+0x333>
  800bf0:	83 fb 1f             	cmp    $0x1f,%ebx
  800bf3:	7e 05                	jle    800bfa <vprintfmt+0x31f>
  800bf5:	83 fb 7e             	cmp    $0x7e,%ebx
  800bf8:	7e 14                	jle    800c0e <vprintfmt+0x333>
					putch('?', putdat);
  800bfa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c02:	48 89 d6             	mov    %rdx,%rsi
  800c05:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c0a:	ff d0                	callq  *%rax
  800c0c:	eb 0f                	jmp    800c1d <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800c0e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c16:	48 89 d6             	mov    %rdx,%rsi
  800c19:	89 df                	mov    %ebx,%edi
  800c1b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c1d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c21:	4c 89 e0             	mov    %r12,%rax
  800c24:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c28:	0f b6 00             	movzbl (%rax),%eax
  800c2b:	0f be d8             	movsbl %al,%ebx
  800c2e:	85 db                	test   %ebx,%ebx
  800c30:	74 10                	je     800c42 <vprintfmt+0x367>
  800c32:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c36:	78 b2                	js     800bea <vprintfmt+0x30f>
  800c38:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c3c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c40:	79 a8                	jns    800bea <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c42:	eb 16                	jmp    800c5a <vprintfmt+0x37f>
				putch(' ', putdat);
  800c44:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4c:	48 89 d6             	mov    %rdx,%rsi
  800c4f:	bf 20 00 00 00       	mov    $0x20,%edi
  800c54:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c56:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c5a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c5e:	7f e4                	jg     800c44 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800c60:	e9 c0 01 00 00       	jmpq   800e25 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c65:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c69:	be 03 00 00 00       	mov    $0x3,%esi
  800c6e:	48 89 c7             	mov    %rax,%rdi
  800c71:	48 b8 cb 07 80 00 00 	movabs $0x8007cb,%rax
  800c78:	00 00 00 
  800c7b:	ff d0                	callq  *%rax
  800c7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c85:	48 85 c0             	test   %rax,%rax
  800c88:	79 1d                	jns    800ca7 <vprintfmt+0x3cc>
				putch('-', putdat);
  800c8a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c92:	48 89 d6             	mov    %rdx,%rsi
  800c95:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c9a:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca0:	48 f7 d8             	neg    %rax
  800ca3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ca7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cae:	e9 d5 00 00 00       	jmpq   800d88 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800cb3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb7:	be 03 00 00 00       	mov    $0x3,%esi
  800cbc:	48 89 c7             	mov    %rax,%rdi
  800cbf:	48 b8 bb 06 80 00 00 	movabs $0x8006bb,%rax
  800cc6:	00 00 00 
  800cc9:	ff d0                	callq  *%rax
  800ccb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ccf:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cd6:	e9 ad 00 00 00       	jmpq   800d88 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800cdb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cdf:	be 03 00 00 00       	mov    $0x3,%esi
  800ce4:	48 89 c7             	mov    %rax,%rdi
  800ce7:	48 b8 bb 06 80 00 00 	movabs $0x8006bb,%rax
  800cee:	00 00 00 
  800cf1:	ff d0                	callq  *%rax
  800cf3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800cf7:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cfe:	e9 85 00 00 00       	jmpq   800d88 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800d03:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0b:	48 89 d6             	mov    %rdx,%rsi
  800d0e:	bf 30 00 00 00       	mov    $0x30,%edi
  800d13:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1d:	48 89 d6             	mov    %rdx,%rsi
  800d20:	bf 78 00 00 00       	mov    $0x78,%edi
  800d25:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d27:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2a:	83 f8 30             	cmp    $0x30,%eax
  800d2d:	73 17                	jae    800d46 <vprintfmt+0x46b>
  800d2f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d33:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d36:	89 c0                	mov    %eax,%eax
  800d38:	48 01 d0             	add    %rdx,%rax
  800d3b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d3e:	83 c2 08             	add    $0x8,%edx
  800d41:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d44:	eb 0f                	jmp    800d55 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  800d46:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d4a:	48 89 d0             	mov    %rdx,%rax
  800d4d:	48 83 c2 08          	add    $0x8,%rdx
  800d51:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d55:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d58:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d5c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d63:	eb 23                	jmp    800d88 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d65:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d69:	be 03 00 00 00       	mov    $0x3,%esi
  800d6e:	48 89 c7             	mov    %rax,%rdi
  800d71:	48 b8 bb 06 80 00 00 	movabs $0x8006bb,%rax
  800d78:	00 00 00 
  800d7b:	ff d0                	callq  *%rax
  800d7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d81:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d88:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d8d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d90:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d97:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9f:	45 89 c1             	mov    %r8d,%r9d
  800da2:	41 89 f8             	mov    %edi,%r8d
  800da5:	48 89 c7             	mov    %rax,%rdi
  800da8:	48 b8 00 06 80 00 00 	movabs $0x800600,%rax
  800daf:	00 00 00 
  800db2:	ff d0                	callq  *%rax
			break;
  800db4:	eb 6f                	jmp    800e25 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800db6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dbe:	48 89 d6             	mov    %rdx,%rsi
  800dc1:	89 df                	mov    %ebx,%edi
  800dc3:	ff d0                	callq  *%rax
			break;
  800dc5:	eb 5e                	jmp    800e25 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  800dc7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dcb:	be 03 00 00 00       	mov    $0x3,%esi
  800dd0:	48 89 c7             	mov    %rax,%rdi
  800dd3:	48 b8 bb 06 80 00 00 	movabs $0x8006bb,%rax
  800dda:	00 00 00 
  800ddd:	ff d0                	callq  *%rax
  800ddf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  800de3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de7:	89 c2                	mov    %eax,%edx
  800de9:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  800df0:	00 00 00 
  800df3:	89 10                	mov    %edx,(%rax)
			break;
  800df5:	eb 2e                	jmp    800e25 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800df7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dfb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dff:	48 89 d6             	mov    %rdx,%rsi
  800e02:	bf 25 00 00 00       	mov    $0x25,%edi
  800e07:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e09:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e0e:	eb 05                	jmp    800e15 <vprintfmt+0x53a>
  800e10:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e15:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e19:	48 83 e8 01          	sub    $0x1,%rax
  800e1d:	0f b6 00             	movzbl (%rax),%eax
  800e20:	3c 25                	cmp    $0x25,%al
  800e22:	75 ec                	jne    800e10 <vprintfmt+0x535>
				/* do nothing */;
			break;
  800e24:	90                   	nop
		}
	}
  800e25:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e26:	e9 13 fb ff ff       	jmpq   80093e <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e2b:	48 83 c4 60          	add    $0x60,%rsp
  800e2f:	5b                   	pop    %rbx
  800e30:	41 5c                	pop    %r12
  800e32:	5d                   	pop    %rbp
  800e33:	c3                   	retq   

0000000000800e34 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e34:	55                   	push   %rbp
  800e35:	48 89 e5             	mov    %rsp,%rbp
  800e38:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e3f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e46:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e4d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e54:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e5b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e62:	84 c0                	test   %al,%al
  800e64:	74 20                	je     800e86 <printfmt+0x52>
  800e66:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e6a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e6e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e72:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e76:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e7a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e7e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e82:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e86:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e8d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e94:	00 00 00 
  800e97:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e9e:	00 00 00 
  800ea1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ea5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800eac:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eb3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800eba:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ec1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ec8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ecf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ed6:	48 89 c7             	mov    %rax,%rdi
  800ed9:	48 b8 db 08 80 00 00 	movabs $0x8008db,%rax
  800ee0:	00 00 00 
  800ee3:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ee5:	c9                   	leaveq 
  800ee6:	c3                   	retq   

0000000000800ee7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ee7:	55                   	push   %rbp
  800ee8:	48 89 e5             	mov    %rsp,%rbp
  800eeb:	48 83 ec 10          	sub    $0x10,%rsp
  800eef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ef2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ef6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800efa:	8b 40 10             	mov    0x10(%rax),%eax
  800efd:	8d 50 01             	lea    0x1(%rax),%edx
  800f00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f04:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f0b:	48 8b 10             	mov    (%rax),%rdx
  800f0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f12:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f16:	48 39 c2             	cmp    %rax,%rdx
  800f19:	73 17                	jae    800f32 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f1f:	48 8b 00             	mov    (%rax),%rax
  800f22:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f2a:	48 89 0a             	mov    %rcx,(%rdx)
  800f2d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f30:	88 10                	mov    %dl,(%rax)
}
  800f32:	c9                   	leaveq 
  800f33:	c3                   	retq   

0000000000800f34 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f34:	55                   	push   %rbp
  800f35:	48 89 e5             	mov    %rsp,%rbp
  800f38:	48 83 ec 50          	sub    $0x50,%rsp
  800f3c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f40:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f43:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f47:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f4b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f4f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f53:	48 8b 0a             	mov    (%rdx),%rcx
  800f56:	48 89 08             	mov    %rcx,(%rax)
  800f59:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f5d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f61:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f65:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f69:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f6d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f71:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f74:	48 98                	cltq   
  800f76:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f7a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f7e:	48 01 d0             	add    %rdx,%rax
  800f81:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f85:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f8c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f91:	74 06                	je     800f99 <vsnprintf+0x65>
  800f93:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f97:	7f 07                	jg     800fa0 <vsnprintf+0x6c>
		return -E_INVAL;
  800f99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f9e:	eb 2f                	jmp    800fcf <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fa0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fa4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800fa8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800fac:	48 89 c6             	mov    %rax,%rsi
  800faf:	48 bf e7 0e 80 00 00 	movabs $0x800ee7,%rdi
  800fb6:	00 00 00 
  800fb9:	48 b8 db 08 80 00 00 	movabs $0x8008db,%rax
  800fc0:	00 00 00 
  800fc3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fc5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fc9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fcc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800fcf:	c9                   	leaveq 
  800fd0:	c3                   	retq   

0000000000800fd1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fd1:	55                   	push   %rbp
  800fd2:	48 89 e5             	mov    %rsp,%rbp
  800fd5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fdc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fe3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fe9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ff0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ff7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ffe:	84 c0                	test   %al,%al
  801000:	74 20                	je     801022 <snprintf+0x51>
  801002:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801006:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80100a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80100e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801012:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801016:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80101a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80101e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801022:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801029:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801030:	00 00 00 
  801033:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80103a:	00 00 00 
  80103d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801041:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801048:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80104f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801056:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80105d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801064:	48 8b 0a             	mov    (%rdx),%rcx
  801067:	48 89 08             	mov    %rcx,(%rax)
  80106a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80106e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801072:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801076:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80107a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801081:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801088:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80108e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801095:	48 89 c7             	mov    %rax,%rdi
  801098:	48 b8 34 0f 80 00 00 	movabs $0x800f34,%rax
  80109f:	00 00 00 
  8010a2:	ff d0                	callq  *%rax
  8010a4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010aa:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010b0:	c9                   	leaveq 
  8010b1:	c3                   	retq   

00000000008010b2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010b2:	55                   	push   %rbp
  8010b3:	48 89 e5             	mov    %rsp,%rbp
  8010b6:	48 83 ec 18          	sub    $0x18,%rsp
  8010ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010c5:	eb 09                	jmp    8010d0 <strlen+0x1e>
		n++;
  8010c7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010cb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d4:	0f b6 00             	movzbl (%rax),%eax
  8010d7:	84 c0                	test   %al,%al
  8010d9:	75 ec                	jne    8010c7 <strlen+0x15>
		n++;
	return n;
  8010db:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010de:	c9                   	leaveq 
  8010df:	c3                   	retq   

00000000008010e0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010e0:	55                   	push   %rbp
  8010e1:	48 89 e5             	mov    %rsp,%rbp
  8010e4:	48 83 ec 20          	sub    $0x20,%rsp
  8010e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010f7:	eb 0e                	jmp    801107 <strnlen+0x27>
		n++;
  8010f9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010fd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801102:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801107:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80110c:	74 0b                	je     801119 <strnlen+0x39>
  80110e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801112:	0f b6 00             	movzbl (%rax),%eax
  801115:	84 c0                	test   %al,%al
  801117:	75 e0                	jne    8010f9 <strnlen+0x19>
		n++;
	return n;
  801119:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80111c:	c9                   	leaveq 
  80111d:	c3                   	retq   

000000000080111e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80111e:	55                   	push   %rbp
  80111f:	48 89 e5             	mov    %rsp,%rbp
  801122:	48 83 ec 20          	sub    $0x20,%rsp
  801126:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80112a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80112e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801132:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801136:	90                   	nop
  801137:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80113f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801143:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801147:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80114b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80114f:	0f b6 12             	movzbl (%rdx),%edx
  801152:	88 10                	mov    %dl,(%rax)
  801154:	0f b6 00             	movzbl (%rax),%eax
  801157:	84 c0                	test   %al,%al
  801159:	75 dc                	jne    801137 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80115b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80115f:	c9                   	leaveq 
  801160:	c3                   	retq   

0000000000801161 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801161:	55                   	push   %rbp
  801162:	48 89 e5             	mov    %rsp,%rbp
  801165:	48 83 ec 20          	sub    $0x20,%rsp
  801169:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80116d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801175:	48 89 c7             	mov    %rax,%rdi
  801178:	48 b8 b2 10 80 00 00 	movabs $0x8010b2,%rax
  80117f:	00 00 00 
  801182:	ff d0                	callq  *%rax
  801184:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801187:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80118a:	48 63 d0             	movslq %eax,%rdx
  80118d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801191:	48 01 c2             	add    %rax,%rdx
  801194:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801198:	48 89 c6             	mov    %rax,%rsi
  80119b:	48 89 d7             	mov    %rdx,%rdi
  80119e:	48 b8 1e 11 80 00 00 	movabs $0x80111e,%rax
  8011a5:	00 00 00 
  8011a8:	ff d0                	callq  *%rax
	return dst;
  8011aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011ae:	c9                   	leaveq 
  8011af:	c3                   	retq   

00000000008011b0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011b0:	55                   	push   %rbp
  8011b1:	48 89 e5             	mov    %rsp,%rbp
  8011b4:	48 83 ec 28          	sub    $0x28,%rsp
  8011b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011cc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011d3:	00 
  8011d4:	eb 2a                	jmp    801200 <strncpy+0x50>
		*dst++ = *src;
  8011d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011da:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011e2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011e6:	0f b6 12             	movzbl (%rdx),%edx
  8011e9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ef:	0f b6 00             	movzbl (%rax),%eax
  8011f2:	84 c0                	test   %al,%al
  8011f4:	74 05                	je     8011fb <strncpy+0x4b>
			src++;
  8011f6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011fb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801200:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801204:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801208:	72 cc                	jb     8011d6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80120a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80120e:	c9                   	leaveq 
  80120f:	c3                   	retq   

0000000000801210 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801210:	55                   	push   %rbp
  801211:	48 89 e5             	mov    %rsp,%rbp
  801214:	48 83 ec 28          	sub    $0x28,%rsp
  801218:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801220:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801228:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80122c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801231:	74 3d                	je     801270 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801233:	eb 1d                	jmp    801252 <strlcpy+0x42>
			*dst++ = *src++;
  801235:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801239:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80123d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801241:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801245:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801249:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80124d:	0f b6 12             	movzbl (%rdx),%edx
  801250:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801252:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801257:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80125c:	74 0b                	je     801269 <strlcpy+0x59>
  80125e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801262:	0f b6 00             	movzbl (%rax),%eax
  801265:	84 c0                	test   %al,%al
  801267:	75 cc                	jne    801235 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801269:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801270:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801278:	48 29 c2             	sub    %rax,%rdx
  80127b:	48 89 d0             	mov    %rdx,%rax
}
  80127e:	c9                   	leaveq 
  80127f:	c3                   	retq   

0000000000801280 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801280:	55                   	push   %rbp
  801281:	48 89 e5             	mov    %rsp,%rbp
  801284:	48 83 ec 10          	sub    $0x10,%rsp
  801288:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80128c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801290:	eb 0a                	jmp    80129c <strcmp+0x1c>
		p++, q++;
  801292:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801297:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80129c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a0:	0f b6 00             	movzbl (%rax),%eax
  8012a3:	84 c0                	test   %al,%al
  8012a5:	74 12                	je     8012b9 <strcmp+0x39>
  8012a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ab:	0f b6 10             	movzbl (%rax),%edx
  8012ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b2:	0f b6 00             	movzbl (%rax),%eax
  8012b5:	38 c2                	cmp    %al,%dl
  8012b7:	74 d9                	je     801292 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bd:	0f b6 00             	movzbl (%rax),%eax
  8012c0:	0f b6 d0             	movzbl %al,%edx
  8012c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c7:	0f b6 00             	movzbl (%rax),%eax
  8012ca:	0f b6 c0             	movzbl %al,%eax
  8012cd:	29 c2                	sub    %eax,%edx
  8012cf:	89 d0                	mov    %edx,%eax
}
  8012d1:	c9                   	leaveq 
  8012d2:	c3                   	retq   

00000000008012d3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012d3:	55                   	push   %rbp
  8012d4:	48 89 e5             	mov    %rsp,%rbp
  8012d7:	48 83 ec 18          	sub    $0x18,%rsp
  8012db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012e3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012e7:	eb 0f                	jmp    8012f8 <strncmp+0x25>
		n--, p++, q++;
  8012e9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012f8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012fd:	74 1d                	je     80131c <strncmp+0x49>
  8012ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801303:	0f b6 00             	movzbl (%rax),%eax
  801306:	84 c0                	test   %al,%al
  801308:	74 12                	je     80131c <strncmp+0x49>
  80130a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130e:	0f b6 10             	movzbl (%rax),%edx
  801311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801315:	0f b6 00             	movzbl (%rax),%eax
  801318:	38 c2                	cmp    %al,%dl
  80131a:	74 cd                	je     8012e9 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80131c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801321:	75 07                	jne    80132a <strncmp+0x57>
		return 0;
  801323:	b8 00 00 00 00       	mov    $0x0,%eax
  801328:	eb 18                	jmp    801342 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80132a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132e:	0f b6 00             	movzbl (%rax),%eax
  801331:	0f b6 d0             	movzbl %al,%edx
  801334:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801338:	0f b6 00             	movzbl (%rax),%eax
  80133b:	0f b6 c0             	movzbl %al,%eax
  80133e:	29 c2                	sub    %eax,%edx
  801340:	89 d0                	mov    %edx,%eax
}
  801342:	c9                   	leaveq 
  801343:	c3                   	retq   

0000000000801344 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801344:	55                   	push   %rbp
  801345:	48 89 e5             	mov    %rsp,%rbp
  801348:	48 83 ec 0c          	sub    $0xc,%rsp
  80134c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801350:	89 f0                	mov    %esi,%eax
  801352:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801355:	eb 17                	jmp    80136e <strchr+0x2a>
		if (*s == c)
  801357:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135b:	0f b6 00             	movzbl (%rax),%eax
  80135e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801361:	75 06                	jne    801369 <strchr+0x25>
			return (char *) s;
  801363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801367:	eb 15                	jmp    80137e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801369:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801372:	0f b6 00             	movzbl (%rax),%eax
  801375:	84 c0                	test   %al,%al
  801377:	75 de                	jne    801357 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801379:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137e:	c9                   	leaveq 
  80137f:	c3                   	retq   

0000000000801380 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801380:	55                   	push   %rbp
  801381:	48 89 e5             	mov    %rsp,%rbp
  801384:	48 83 ec 0c          	sub    $0xc,%rsp
  801388:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80138c:	89 f0                	mov    %esi,%eax
  80138e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801391:	eb 13                	jmp    8013a6 <strfind+0x26>
		if (*s == c)
  801393:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801397:	0f b6 00             	movzbl (%rax),%eax
  80139a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80139d:	75 02                	jne    8013a1 <strfind+0x21>
			break;
  80139f:	eb 10                	jmp    8013b1 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013aa:	0f b6 00             	movzbl (%rax),%eax
  8013ad:	84 c0                	test   %al,%al
  8013af:	75 e2                	jne    801393 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8013b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013b5:	c9                   	leaveq 
  8013b6:	c3                   	retq   

00000000008013b7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013b7:	55                   	push   %rbp
  8013b8:	48 89 e5             	mov    %rsp,%rbp
  8013bb:	48 83 ec 18          	sub    $0x18,%rsp
  8013bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013c3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013ca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013cf:	75 06                	jne    8013d7 <memset+0x20>
		return v;
  8013d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d5:	eb 69                	jmp    801440 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013db:	83 e0 03             	and    $0x3,%eax
  8013de:	48 85 c0             	test   %rax,%rax
  8013e1:	75 48                	jne    80142b <memset+0x74>
  8013e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e7:	83 e0 03             	and    $0x3,%eax
  8013ea:	48 85 c0             	test   %rax,%rax
  8013ed:	75 3c                	jne    80142b <memset+0x74>
		c &= 0xFF;
  8013ef:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013f9:	c1 e0 18             	shl    $0x18,%eax
  8013fc:	89 c2                	mov    %eax,%edx
  8013fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801401:	c1 e0 10             	shl    $0x10,%eax
  801404:	09 c2                	or     %eax,%edx
  801406:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801409:	c1 e0 08             	shl    $0x8,%eax
  80140c:	09 d0                	or     %edx,%eax
  80140e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801411:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801415:	48 c1 e8 02          	shr    $0x2,%rax
  801419:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80141c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801420:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801423:	48 89 d7             	mov    %rdx,%rdi
  801426:	fc                   	cld    
  801427:	f3 ab                	rep stos %eax,%es:(%rdi)
  801429:	eb 11                	jmp    80143c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80142b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80142f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801432:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801436:	48 89 d7             	mov    %rdx,%rdi
  801439:	fc                   	cld    
  80143a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80143c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801440:	c9                   	leaveq 
  801441:	c3                   	retq   

0000000000801442 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801442:	55                   	push   %rbp
  801443:	48 89 e5             	mov    %rsp,%rbp
  801446:	48 83 ec 28          	sub    $0x28,%rsp
  80144a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80144e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801452:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801456:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80145a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80145e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801462:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80146e:	0f 83 88 00 00 00    	jae    8014fc <memmove+0xba>
  801474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801478:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147c:	48 01 d0             	add    %rdx,%rax
  80147f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801483:	76 77                	jbe    8014fc <memmove+0xba>
		s += n;
  801485:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801489:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80148d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801491:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801495:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801499:	83 e0 03             	and    $0x3,%eax
  80149c:	48 85 c0             	test   %rax,%rax
  80149f:	75 3b                	jne    8014dc <memmove+0x9a>
  8014a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a5:	83 e0 03             	and    $0x3,%eax
  8014a8:	48 85 c0             	test   %rax,%rax
  8014ab:	75 2f                	jne    8014dc <memmove+0x9a>
  8014ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b1:	83 e0 03             	and    $0x3,%eax
  8014b4:	48 85 c0             	test   %rax,%rax
  8014b7:	75 23                	jne    8014dc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014bd:	48 83 e8 04          	sub    $0x4,%rax
  8014c1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c5:	48 83 ea 04          	sub    $0x4,%rdx
  8014c9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014cd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014d1:	48 89 c7             	mov    %rax,%rdi
  8014d4:	48 89 d6             	mov    %rdx,%rsi
  8014d7:	fd                   	std    
  8014d8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014da:	eb 1d                	jmp    8014f9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f0:	48 89 d7             	mov    %rdx,%rdi
  8014f3:	48 89 c1             	mov    %rax,%rcx
  8014f6:	fd                   	std    
  8014f7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014f9:	fc                   	cld    
  8014fa:	eb 57                	jmp    801553 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801500:	83 e0 03             	and    $0x3,%eax
  801503:	48 85 c0             	test   %rax,%rax
  801506:	75 36                	jne    80153e <memmove+0xfc>
  801508:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150c:	83 e0 03             	and    $0x3,%eax
  80150f:	48 85 c0             	test   %rax,%rax
  801512:	75 2a                	jne    80153e <memmove+0xfc>
  801514:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801518:	83 e0 03             	and    $0x3,%eax
  80151b:	48 85 c0             	test   %rax,%rax
  80151e:	75 1e                	jne    80153e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801520:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801524:	48 c1 e8 02          	shr    $0x2,%rax
  801528:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80152b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801533:	48 89 c7             	mov    %rax,%rdi
  801536:	48 89 d6             	mov    %rdx,%rsi
  801539:	fc                   	cld    
  80153a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80153c:	eb 15                	jmp    801553 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80153e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801542:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801546:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80154a:	48 89 c7             	mov    %rax,%rdi
  80154d:	48 89 d6             	mov    %rdx,%rsi
  801550:	fc                   	cld    
  801551:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801557:	c9                   	leaveq 
  801558:	c3                   	retq   

0000000000801559 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801559:	55                   	push   %rbp
  80155a:	48 89 e5             	mov    %rsp,%rbp
  80155d:	48 83 ec 18          	sub    $0x18,%rsp
  801561:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801565:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801569:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80156d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801571:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801575:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801579:	48 89 ce             	mov    %rcx,%rsi
  80157c:	48 89 c7             	mov    %rax,%rdi
  80157f:	48 b8 42 14 80 00 00 	movabs $0x801442,%rax
  801586:	00 00 00 
  801589:	ff d0                	callq  *%rax
}
  80158b:	c9                   	leaveq 
  80158c:	c3                   	retq   

000000000080158d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80158d:	55                   	push   %rbp
  80158e:	48 89 e5             	mov    %rsp,%rbp
  801591:	48 83 ec 28          	sub    $0x28,%rsp
  801595:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801599:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80159d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015b1:	eb 36                	jmp    8015e9 <memcmp+0x5c>
		if (*s1 != *s2)
  8015b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b7:	0f b6 10             	movzbl (%rax),%edx
  8015ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015be:	0f b6 00             	movzbl (%rax),%eax
  8015c1:	38 c2                	cmp    %al,%dl
  8015c3:	74 1a                	je     8015df <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c9:	0f b6 00             	movzbl (%rax),%eax
  8015cc:	0f b6 d0             	movzbl %al,%edx
  8015cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d3:	0f b6 00             	movzbl (%rax),%eax
  8015d6:	0f b6 c0             	movzbl %al,%eax
  8015d9:	29 c2                	sub    %eax,%edx
  8015db:	89 d0                	mov    %edx,%eax
  8015dd:	eb 20                	jmp    8015ff <memcmp+0x72>
		s1++, s2++;
  8015df:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015e4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ed:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015f5:	48 85 c0             	test   %rax,%rax
  8015f8:	75 b9                	jne    8015b3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ff:	c9                   	leaveq 
  801600:	c3                   	retq   

0000000000801601 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801601:	55                   	push   %rbp
  801602:	48 89 e5             	mov    %rsp,%rbp
  801605:	48 83 ec 28          	sub    $0x28,%rsp
  801609:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80160d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801610:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801618:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80161c:	48 01 d0             	add    %rdx,%rax
  80161f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801623:	eb 15                	jmp    80163a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801629:	0f b6 10             	movzbl (%rax),%edx
  80162c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80162f:	38 c2                	cmp    %al,%dl
  801631:	75 02                	jne    801635 <memfind+0x34>
			break;
  801633:	eb 0f                	jmp    801644 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801635:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80163a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80163e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801642:	72 e1                	jb     801625 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801648:	c9                   	leaveq 
  801649:	c3                   	retq   

000000000080164a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80164a:	55                   	push   %rbp
  80164b:	48 89 e5             	mov    %rsp,%rbp
  80164e:	48 83 ec 34          	sub    $0x34,%rsp
  801652:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801656:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80165a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80165d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801664:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80166b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80166c:	eb 05                	jmp    801673 <strtol+0x29>
		s++;
  80166e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801677:	0f b6 00             	movzbl (%rax),%eax
  80167a:	3c 20                	cmp    $0x20,%al
  80167c:	74 f0                	je     80166e <strtol+0x24>
  80167e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	3c 09                	cmp    $0x9,%al
  801687:	74 e5                	je     80166e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168d:	0f b6 00             	movzbl (%rax),%eax
  801690:	3c 2b                	cmp    $0x2b,%al
  801692:	75 07                	jne    80169b <strtol+0x51>
		s++;
  801694:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801699:	eb 17                	jmp    8016b2 <strtol+0x68>
	else if (*s == '-')
  80169b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169f:	0f b6 00             	movzbl (%rax),%eax
  8016a2:	3c 2d                	cmp    $0x2d,%al
  8016a4:	75 0c                	jne    8016b2 <strtol+0x68>
		s++, neg = 1;
  8016a6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016ab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016b2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016b6:	74 06                	je     8016be <strtol+0x74>
  8016b8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016bc:	75 28                	jne    8016e6 <strtol+0x9c>
  8016be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c2:	0f b6 00             	movzbl (%rax),%eax
  8016c5:	3c 30                	cmp    $0x30,%al
  8016c7:	75 1d                	jne    8016e6 <strtol+0x9c>
  8016c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cd:	48 83 c0 01          	add    $0x1,%rax
  8016d1:	0f b6 00             	movzbl (%rax),%eax
  8016d4:	3c 78                	cmp    $0x78,%al
  8016d6:	75 0e                	jne    8016e6 <strtol+0x9c>
		s += 2, base = 16;
  8016d8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016dd:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016e4:	eb 2c                	jmp    801712 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016e6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016ea:	75 19                	jne    801705 <strtol+0xbb>
  8016ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f0:	0f b6 00             	movzbl (%rax),%eax
  8016f3:	3c 30                	cmp    $0x30,%al
  8016f5:	75 0e                	jne    801705 <strtol+0xbb>
		s++, base = 8;
  8016f7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016fc:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801703:	eb 0d                	jmp    801712 <strtol+0xc8>
	else if (base == 0)
  801705:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801709:	75 07                	jne    801712 <strtol+0xc8>
		base = 10;
  80170b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801712:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801716:	0f b6 00             	movzbl (%rax),%eax
  801719:	3c 2f                	cmp    $0x2f,%al
  80171b:	7e 1d                	jle    80173a <strtol+0xf0>
  80171d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801721:	0f b6 00             	movzbl (%rax),%eax
  801724:	3c 39                	cmp    $0x39,%al
  801726:	7f 12                	jg     80173a <strtol+0xf0>
			dig = *s - '0';
  801728:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172c:	0f b6 00             	movzbl (%rax),%eax
  80172f:	0f be c0             	movsbl %al,%eax
  801732:	83 e8 30             	sub    $0x30,%eax
  801735:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801738:	eb 4e                	jmp    801788 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80173a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173e:	0f b6 00             	movzbl (%rax),%eax
  801741:	3c 60                	cmp    $0x60,%al
  801743:	7e 1d                	jle    801762 <strtol+0x118>
  801745:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801749:	0f b6 00             	movzbl (%rax),%eax
  80174c:	3c 7a                	cmp    $0x7a,%al
  80174e:	7f 12                	jg     801762 <strtol+0x118>
			dig = *s - 'a' + 10;
  801750:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801754:	0f b6 00             	movzbl (%rax),%eax
  801757:	0f be c0             	movsbl %al,%eax
  80175a:	83 e8 57             	sub    $0x57,%eax
  80175d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801760:	eb 26                	jmp    801788 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801762:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801766:	0f b6 00             	movzbl (%rax),%eax
  801769:	3c 40                	cmp    $0x40,%al
  80176b:	7e 48                	jle    8017b5 <strtol+0x16b>
  80176d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801771:	0f b6 00             	movzbl (%rax),%eax
  801774:	3c 5a                	cmp    $0x5a,%al
  801776:	7f 3d                	jg     8017b5 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801778:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177c:	0f b6 00             	movzbl (%rax),%eax
  80177f:	0f be c0             	movsbl %al,%eax
  801782:	83 e8 37             	sub    $0x37,%eax
  801785:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801788:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80178b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80178e:	7c 02                	jl     801792 <strtol+0x148>
			break;
  801790:	eb 23                	jmp    8017b5 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801792:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801797:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80179a:	48 98                	cltq   
  80179c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017a1:	48 89 c2             	mov    %rax,%rdx
  8017a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017a7:	48 98                	cltq   
  8017a9:	48 01 d0             	add    %rdx,%rax
  8017ac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017b0:	e9 5d ff ff ff       	jmpq   801712 <strtol+0xc8>

	if (endptr)
  8017b5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017ba:	74 0b                	je     8017c7 <strtol+0x17d>
		*endptr = (char *) s;
  8017bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017c0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017c4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017cb:	74 09                	je     8017d6 <strtol+0x18c>
  8017cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017d1:	48 f7 d8             	neg    %rax
  8017d4:	eb 04                	jmp    8017da <strtol+0x190>
  8017d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017da:	c9                   	leaveq 
  8017db:	c3                   	retq   

00000000008017dc <strstr>:

char * strstr(const char *in, const char *str)
{
  8017dc:	55                   	push   %rbp
  8017dd:	48 89 e5             	mov    %rsp,%rbp
  8017e0:	48 83 ec 30          	sub    $0x30,%rsp
  8017e4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017e8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017f0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017f4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017f8:	0f b6 00             	movzbl (%rax),%eax
  8017fb:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8017fe:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801802:	75 06                	jne    80180a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801804:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801808:	eb 6b                	jmp    801875 <strstr+0x99>

	len = strlen(str);
  80180a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80180e:	48 89 c7             	mov    %rax,%rdi
  801811:	48 b8 b2 10 80 00 00 	movabs $0x8010b2,%rax
  801818:	00 00 00 
  80181b:	ff d0                	callq  *%rax
  80181d:	48 98                	cltq   
  80181f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801823:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801827:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80182b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80182f:	0f b6 00             	movzbl (%rax),%eax
  801832:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801835:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801839:	75 07                	jne    801842 <strstr+0x66>
				return (char *) 0;
  80183b:	b8 00 00 00 00       	mov    $0x0,%eax
  801840:	eb 33                	jmp    801875 <strstr+0x99>
		} while (sc != c);
  801842:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801846:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801849:	75 d8                	jne    801823 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80184b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80184f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801853:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801857:	48 89 ce             	mov    %rcx,%rsi
  80185a:	48 89 c7             	mov    %rax,%rdi
  80185d:	48 b8 d3 12 80 00 00 	movabs $0x8012d3,%rax
  801864:	00 00 00 
  801867:	ff d0                	callq  *%rax
  801869:	85 c0                	test   %eax,%eax
  80186b:	75 b6                	jne    801823 <strstr+0x47>

	return (char *) (in - 1);
  80186d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801871:	48 83 e8 01          	sub    $0x1,%rax
}
  801875:	c9                   	leaveq 
  801876:	c3                   	retq   

0000000000801877 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801877:	55                   	push   %rbp
  801878:	48 89 e5             	mov    %rsp,%rbp
  80187b:	53                   	push   %rbx
  80187c:	48 83 ec 48          	sub    $0x48,%rsp
  801880:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801883:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801886:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80188a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80188e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801892:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801896:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801899:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80189d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018a1:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018a5:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018a9:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018ad:	4c 89 c3             	mov    %r8,%rbx
  8018b0:	cd 30                	int    $0x30
  8018b2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8018b6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018ba:	74 3e                	je     8018fa <syscall+0x83>
  8018bc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018c1:	7e 37                	jle    8018fa <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018c7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018ca:	49 89 d0             	mov    %rdx,%r8
  8018cd:	89 c1                	mov    %eax,%ecx
  8018cf:	48 ba e8 40 80 00 00 	movabs $0x8040e8,%rdx
  8018d6:	00 00 00 
  8018d9:	be 23 00 00 00       	mov    $0x23,%esi
  8018de:	48 bf 05 41 80 00 00 	movabs $0x804105,%rdi
  8018e5:	00 00 00 
  8018e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ed:	49 b9 ef 02 80 00 00 	movabs $0x8002ef,%r9
  8018f4:	00 00 00 
  8018f7:	41 ff d1             	callq  *%r9

	return ret;
  8018fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018fe:	48 83 c4 48          	add    $0x48,%rsp
  801902:	5b                   	pop    %rbx
  801903:	5d                   	pop    %rbp
  801904:	c3                   	retq   

0000000000801905 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801905:	55                   	push   %rbp
  801906:	48 89 e5             	mov    %rsp,%rbp
  801909:	48 83 ec 20          	sub    $0x20,%rsp
  80190d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801911:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801915:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801919:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80191d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801924:	00 
  801925:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801931:	48 89 d1             	mov    %rdx,%rcx
  801934:	48 89 c2             	mov    %rax,%rdx
  801937:	be 00 00 00 00       	mov    $0x0,%esi
  80193c:	bf 00 00 00 00       	mov    $0x0,%edi
  801941:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801948:	00 00 00 
  80194b:	ff d0                	callq  *%rax
}
  80194d:	c9                   	leaveq 
  80194e:	c3                   	retq   

000000000080194f <sys_cgetc>:

int
sys_cgetc(void)
{
  80194f:	55                   	push   %rbp
  801950:	48 89 e5             	mov    %rsp,%rbp
  801953:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801957:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80195e:	00 
  80195f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801965:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801970:	ba 00 00 00 00       	mov    $0x0,%edx
  801975:	be 00 00 00 00       	mov    $0x0,%esi
  80197a:	bf 01 00 00 00       	mov    $0x1,%edi
  80197f:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801986:	00 00 00 
  801989:	ff d0                	callq  *%rax
}
  80198b:	c9                   	leaveq 
  80198c:	c3                   	retq   

000000000080198d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80198d:	55                   	push   %rbp
  80198e:	48 89 e5             	mov    %rsp,%rbp
  801991:	48 83 ec 10          	sub    $0x10,%rsp
  801995:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801998:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80199b:	48 98                	cltq   
  80199d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a4:	00 
  8019a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019b6:	48 89 c2             	mov    %rax,%rdx
  8019b9:	be 01 00 00 00       	mov    $0x1,%esi
  8019be:	bf 03 00 00 00       	mov    $0x3,%edi
  8019c3:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  8019ca:	00 00 00 
  8019cd:	ff d0                	callq  *%rax
}
  8019cf:	c9                   	leaveq 
  8019d0:	c3                   	retq   

00000000008019d1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019d1:	55                   	push   %rbp
  8019d2:	48 89 e5             	mov    %rsp,%rbp
  8019d5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019d9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019e0:	00 
  8019e1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f7:	be 00 00 00 00       	mov    $0x0,%esi
  8019fc:	bf 02 00 00 00       	mov    $0x2,%edi
  801a01:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801a08:	00 00 00 
  801a0b:	ff d0                	callq  *%rax
}
  801a0d:	c9                   	leaveq 
  801a0e:	c3                   	retq   

0000000000801a0f <sys_yield>:

void
sys_yield(void)
{
  801a0f:	55                   	push   %rbp
  801a10:	48 89 e5             	mov    %rsp,%rbp
  801a13:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a17:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1e:	00 
  801a1f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a25:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a30:	ba 00 00 00 00       	mov    $0x0,%edx
  801a35:	be 00 00 00 00       	mov    $0x0,%esi
  801a3a:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a3f:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801a46:	00 00 00 
  801a49:	ff d0                	callq  *%rax
}
  801a4b:	c9                   	leaveq 
  801a4c:	c3                   	retq   

0000000000801a4d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a4d:	55                   	push   %rbp
  801a4e:	48 89 e5             	mov    %rsp,%rbp
  801a51:	48 83 ec 20          	sub    $0x20,%rsp
  801a55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a58:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a5c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a62:	48 63 c8             	movslq %eax,%rcx
  801a65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6c:	48 98                	cltq   
  801a6e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a75:	00 
  801a76:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7c:	49 89 c8             	mov    %rcx,%r8
  801a7f:	48 89 d1             	mov    %rdx,%rcx
  801a82:	48 89 c2             	mov    %rax,%rdx
  801a85:	be 01 00 00 00       	mov    $0x1,%esi
  801a8a:	bf 04 00 00 00       	mov    $0x4,%edi
  801a8f:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801a96:	00 00 00 
  801a99:	ff d0                	callq  *%rax
}
  801a9b:	c9                   	leaveq 
  801a9c:	c3                   	retq   

0000000000801a9d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a9d:	55                   	push   %rbp
  801a9e:	48 89 e5             	mov    %rsp,%rbp
  801aa1:	48 83 ec 30          	sub    $0x30,%rsp
  801aa5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aac:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801aaf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ab3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ab7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801aba:	48 63 c8             	movslq %eax,%rcx
  801abd:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ac1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ac4:	48 63 f0             	movslq %eax,%rsi
  801ac7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ace:	48 98                	cltq   
  801ad0:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ad4:	49 89 f9             	mov    %rdi,%r9
  801ad7:	49 89 f0             	mov    %rsi,%r8
  801ada:	48 89 d1             	mov    %rdx,%rcx
  801add:	48 89 c2             	mov    %rax,%rdx
  801ae0:	be 01 00 00 00       	mov    $0x1,%esi
  801ae5:	bf 05 00 00 00       	mov    $0x5,%edi
  801aea:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801af1:	00 00 00 
  801af4:	ff d0                	callq  *%rax
}
  801af6:	c9                   	leaveq 
  801af7:	c3                   	retq   

0000000000801af8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801af8:	55                   	push   %rbp
  801af9:	48 89 e5             	mov    %rsp,%rbp
  801afc:	48 83 ec 20          	sub    $0x20,%rsp
  801b00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b0e:	48 98                	cltq   
  801b10:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b17:	00 
  801b18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b24:	48 89 d1             	mov    %rdx,%rcx
  801b27:	48 89 c2             	mov    %rax,%rdx
  801b2a:	be 01 00 00 00       	mov    $0x1,%esi
  801b2f:	bf 06 00 00 00       	mov    $0x6,%edi
  801b34:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801b3b:	00 00 00 
  801b3e:	ff d0                	callq  *%rax
}
  801b40:	c9                   	leaveq 
  801b41:	c3                   	retq   

0000000000801b42 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b42:	55                   	push   %rbp
  801b43:	48 89 e5             	mov    %rsp,%rbp
  801b46:	48 83 ec 10          	sub    $0x10,%rsp
  801b4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b4d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b50:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b53:	48 63 d0             	movslq %eax,%rdx
  801b56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b59:	48 98                	cltq   
  801b5b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b62:	00 
  801b63:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b69:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b6f:	48 89 d1             	mov    %rdx,%rcx
  801b72:	48 89 c2             	mov    %rax,%rdx
  801b75:	be 01 00 00 00       	mov    $0x1,%esi
  801b7a:	bf 08 00 00 00       	mov    $0x8,%edi
  801b7f:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801b86:	00 00 00 
  801b89:	ff d0                	callq  *%rax
}
  801b8b:	c9                   	leaveq 
  801b8c:	c3                   	retq   

0000000000801b8d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b8d:	55                   	push   %rbp
  801b8e:	48 89 e5             	mov    %rsp,%rbp
  801b91:	48 83 ec 20          	sub    $0x20,%rsp
  801b95:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b98:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba3:	48 98                	cltq   
  801ba5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bac:	00 
  801bad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb9:	48 89 d1             	mov    %rdx,%rcx
  801bbc:	48 89 c2             	mov    %rax,%rdx
  801bbf:	be 01 00 00 00       	mov    $0x1,%esi
  801bc4:	bf 09 00 00 00       	mov    $0x9,%edi
  801bc9:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801bd0:	00 00 00 
  801bd3:	ff d0                	callq  *%rax
}
  801bd5:	c9                   	leaveq 
  801bd6:	c3                   	retq   

0000000000801bd7 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bd7:	55                   	push   %rbp
  801bd8:	48 89 e5             	mov    %rsp,%rbp
  801bdb:	48 83 ec 20          	sub    $0x20,%rsp
  801bdf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801be2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801be6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bed:	48 98                	cltq   
  801bef:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf6:	00 
  801bf7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c03:	48 89 d1             	mov    %rdx,%rcx
  801c06:	48 89 c2             	mov    %rax,%rdx
  801c09:	be 01 00 00 00       	mov    $0x1,%esi
  801c0e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c13:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801c1a:	00 00 00 
  801c1d:	ff d0                	callq  *%rax
}
  801c1f:	c9                   	leaveq 
  801c20:	c3                   	retq   

0000000000801c21 <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801c21:	55                   	push   %rbp
  801c22:	48 89 e5             	mov    %rsp,%rbp
  801c25:	48 83 ec 10          	sub    $0x10,%rsp
  801c29:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c2c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801c2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c32:	48 63 d0             	movslq %eax,%rdx
  801c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c38:	48 98                	cltq   
  801c3a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c41:	00 
  801c42:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c48:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c4e:	48 89 d1             	mov    %rdx,%rcx
  801c51:	48 89 c2             	mov    %rax,%rdx
  801c54:	be 01 00 00 00       	mov    $0x1,%esi
  801c59:	bf 11 00 00 00       	mov    $0x11,%edi
  801c5e:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801c65:	00 00 00 
  801c68:	ff d0                	callq  *%rax

}
  801c6a:	c9                   	leaveq 
  801c6b:	c3                   	retq   

0000000000801c6c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c6c:	55                   	push   %rbp
  801c6d:	48 89 e5             	mov    %rsp,%rbp
  801c70:	48 83 ec 20          	sub    $0x20,%rsp
  801c74:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c77:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c7b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c7f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c82:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c85:	48 63 f0             	movslq %eax,%rsi
  801c88:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c8f:	48 98                	cltq   
  801c91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c95:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c9c:	00 
  801c9d:	49 89 f1             	mov    %rsi,%r9
  801ca0:	49 89 c8             	mov    %rcx,%r8
  801ca3:	48 89 d1             	mov    %rdx,%rcx
  801ca6:	48 89 c2             	mov    %rax,%rdx
  801ca9:	be 00 00 00 00       	mov    $0x0,%esi
  801cae:	bf 0c 00 00 00       	mov    $0xc,%edi
  801cb3:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801cba:	00 00 00 
  801cbd:	ff d0                	callq  *%rax
}
  801cbf:	c9                   	leaveq 
  801cc0:	c3                   	retq   

0000000000801cc1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801cc1:	55                   	push   %rbp
  801cc2:	48 89 e5             	mov    %rsp,%rbp
  801cc5:	48 83 ec 10          	sub    $0x10,%rsp
  801cc9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd8:	00 
  801cd9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cdf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cea:	48 89 c2             	mov    %rax,%rdx
  801ced:	be 01 00 00 00       	mov    $0x1,%esi
  801cf2:	bf 0d 00 00 00       	mov    $0xd,%edi
  801cf7:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801cfe:	00 00 00 
  801d01:	ff d0                	callq  *%rax
}
  801d03:	c9                   	leaveq 
  801d04:	c3                   	retq   

0000000000801d05 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d05:	55                   	push   %rbp
  801d06:	48 89 e5             	mov    %rsp,%rbp
  801d09:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d14:	00 
  801d15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d21:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d26:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2b:	be 00 00 00 00       	mov    $0x0,%esi
  801d30:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d35:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801d3c:	00 00 00 
  801d3f:	ff d0                	callq  *%rax
}
  801d41:	c9                   	leaveq 
  801d42:	c3                   	retq   

0000000000801d43 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d43:	55                   	push   %rbp
  801d44:	48 89 e5             	mov    %rsp,%rbp
  801d47:	48 83 ec 30          	sub    $0x30,%rsp
  801d4b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d4e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d52:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d55:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d59:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d5d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d60:	48 63 c8             	movslq %eax,%rcx
  801d63:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d6a:	48 63 f0             	movslq %eax,%rsi
  801d6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d74:	48 98                	cltq   
  801d76:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d7a:	49 89 f9             	mov    %rdi,%r9
  801d7d:	49 89 f0             	mov    %rsi,%r8
  801d80:	48 89 d1             	mov    %rdx,%rcx
  801d83:	48 89 c2             	mov    %rax,%rdx
  801d86:	be 00 00 00 00       	mov    $0x0,%esi
  801d8b:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d90:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801d97:	00 00 00 
  801d9a:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d9c:	c9                   	leaveq 
  801d9d:	c3                   	retq   

0000000000801d9e <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d9e:	55                   	push   %rbp
  801d9f:	48 89 e5             	mov    %rsp,%rbp
  801da2:	48 83 ec 20          	sub    $0x20,%rsp
  801da6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801daa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801dae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801db6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dbd:	00 
  801dbe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dc4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dca:	48 89 d1             	mov    %rdx,%rcx
  801dcd:	48 89 c2             	mov    %rax,%rdx
  801dd0:	be 00 00 00 00       	mov    $0x0,%esi
  801dd5:	bf 10 00 00 00       	mov    $0x10,%edi
  801dda:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801de1:	00 00 00 
  801de4:	ff d0                	callq  *%rax
}
  801de6:	c9                   	leaveq 
  801de7:	c3                   	retq   

0000000000801de8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801de8:	55                   	push   %rbp
  801de9:	48 89 e5             	mov    %rsp,%rbp
  801dec:	48 83 ec 08          	sub    $0x8,%rsp
  801df0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801df4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801df8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801dff:	ff ff ff 
  801e02:	48 01 d0             	add    %rdx,%rax
  801e05:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e09:	c9                   	leaveq 
  801e0a:	c3                   	retq   

0000000000801e0b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e0b:	55                   	push   %rbp
  801e0c:	48 89 e5             	mov    %rsp,%rbp
  801e0f:	48 83 ec 08          	sub    $0x8,%rsp
  801e13:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1b:	48 89 c7             	mov    %rax,%rdi
  801e1e:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  801e25:	00 00 00 
  801e28:	ff d0                	callq  *%rax
  801e2a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e30:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e34:	c9                   	leaveq 
  801e35:	c3                   	retq   

0000000000801e36 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e36:	55                   	push   %rbp
  801e37:	48 89 e5             	mov    %rsp,%rbp
  801e3a:	48 83 ec 18          	sub    $0x18,%rsp
  801e3e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e49:	eb 6b                	jmp    801eb6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4e:	48 98                	cltq   
  801e50:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e56:	48 c1 e0 0c          	shl    $0xc,%rax
  801e5a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e62:	48 c1 e8 15          	shr    $0x15,%rax
  801e66:	48 89 c2             	mov    %rax,%rdx
  801e69:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e70:	01 00 00 
  801e73:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e77:	83 e0 01             	and    $0x1,%eax
  801e7a:	48 85 c0             	test   %rax,%rax
  801e7d:	74 21                	je     801ea0 <fd_alloc+0x6a>
  801e7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e83:	48 c1 e8 0c          	shr    $0xc,%rax
  801e87:	48 89 c2             	mov    %rax,%rdx
  801e8a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e91:	01 00 00 
  801e94:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e98:	83 e0 01             	and    $0x1,%eax
  801e9b:	48 85 c0             	test   %rax,%rax
  801e9e:	75 12                	jne    801eb2 <fd_alloc+0x7c>
			*fd_store = fd;
  801ea0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ea8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb0:	eb 1a                	jmp    801ecc <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801eb2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801eb6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801eba:	7e 8f                	jle    801e4b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ebc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ec0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ec7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ecc:	c9                   	leaveq 
  801ecd:	c3                   	retq   

0000000000801ece <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ece:	55                   	push   %rbp
  801ecf:	48 89 e5             	mov    %rsp,%rbp
  801ed2:	48 83 ec 20          	sub    $0x20,%rsp
  801ed6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ed9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801edd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ee1:	78 06                	js     801ee9 <fd_lookup+0x1b>
  801ee3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ee7:	7e 07                	jle    801ef0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ee9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eee:	eb 6c                	jmp    801f5c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ef0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ef3:	48 98                	cltq   
  801ef5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801efb:	48 c1 e0 0c          	shl    $0xc,%rax
  801eff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f07:	48 c1 e8 15          	shr    $0x15,%rax
  801f0b:	48 89 c2             	mov    %rax,%rdx
  801f0e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f15:	01 00 00 
  801f18:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1c:	83 e0 01             	and    $0x1,%eax
  801f1f:	48 85 c0             	test   %rax,%rax
  801f22:	74 21                	je     801f45 <fd_lookup+0x77>
  801f24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f28:	48 c1 e8 0c          	shr    $0xc,%rax
  801f2c:	48 89 c2             	mov    %rax,%rdx
  801f2f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f36:	01 00 00 
  801f39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f3d:	83 e0 01             	and    $0x1,%eax
  801f40:	48 85 c0             	test   %rax,%rax
  801f43:	75 07                	jne    801f4c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f45:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f4a:	eb 10                	jmp    801f5c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f50:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f54:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5c:	c9                   	leaveq 
  801f5d:	c3                   	retq   

0000000000801f5e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f5e:	55                   	push   %rbp
  801f5f:	48 89 e5             	mov    %rsp,%rbp
  801f62:	48 83 ec 30          	sub    $0x30,%rsp
  801f66:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f6a:	89 f0                	mov    %esi,%eax
  801f6c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f73:	48 89 c7             	mov    %rax,%rdi
  801f76:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  801f7d:	00 00 00 
  801f80:	ff d0                	callq  *%rax
  801f82:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f86:	48 89 d6             	mov    %rdx,%rsi
  801f89:	89 c7                	mov    %eax,%edi
  801f8b:	48 b8 ce 1e 80 00 00 	movabs $0x801ece,%rax
  801f92:	00 00 00 
  801f95:	ff d0                	callq  *%rax
  801f97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f9e:	78 0a                	js     801faa <fd_close+0x4c>
	    || fd != fd2)
  801fa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801fa8:	74 12                	je     801fbc <fd_close+0x5e>
		return (must_exist ? r : 0);
  801faa:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801fae:	74 05                	je     801fb5 <fd_close+0x57>
  801fb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fb3:	eb 05                	jmp    801fba <fd_close+0x5c>
  801fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fba:	eb 69                	jmp    802025 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc0:	8b 00                	mov    (%rax),%eax
  801fc2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fc6:	48 89 d6             	mov    %rdx,%rsi
  801fc9:	89 c7                	mov    %eax,%edi
  801fcb:	48 b8 27 20 80 00 00 	movabs $0x802027,%rax
  801fd2:	00 00 00 
  801fd5:	ff d0                	callq  *%rax
  801fd7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fde:	78 2a                	js     80200a <fd_close+0xac>
		if (dev->dev_close)
  801fe0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fe4:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fe8:	48 85 c0             	test   %rax,%rax
  801feb:	74 16                	je     802003 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801fed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff1:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ff5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ff9:	48 89 d7             	mov    %rdx,%rdi
  801ffc:	ff d0                	callq  *%rax
  801ffe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802001:	eb 07                	jmp    80200a <fd_close+0xac>
		else
			r = 0;
  802003:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80200a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80200e:	48 89 c6             	mov    %rax,%rsi
  802011:	bf 00 00 00 00       	mov    $0x0,%edi
  802016:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  80201d:	00 00 00 
  802020:	ff d0                	callq  *%rax
	return r;
  802022:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802025:	c9                   	leaveq 
  802026:	c3                   	retq   

0000000000802027 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802027:	55                   	push   %rbp
  802028:	48 89 e5             	mov    %rsp,%rbp
  80202b:	48 83 ec 20          	sub    $0x20,%rsp
  80202f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802032:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802036:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80203d:	eb 41                	jmp    802080 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80203f:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802046:	00 00 00 
  802049:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80204c:	48 63 d2             	movslq %edx,%rdx
  80204f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802053:	8b 00                	mov    (%rax),%eax
  802055:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802058:	75 22                	jne    80207c <dev_lookup+0x55>
			*dev = devtab[i];
  80205a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802061:	00 00 00 
  802064:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802067:	48 63 d2             	movslq %edx,%rdx
  80206a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80206e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802072:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802075:	b8 00 00 00 00       	mov    $0x0,%eax
  80207a:	eb 60                	jmp    8020dc <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80207c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802080:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802087:	00 00 00 
  80208a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80208d:	48 63 d2             	movslq %edx,%rdx
  802090:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802094:	48 85 c0             	test   %rax,%rax
  802097:	75 a6                	jne    80203f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802099:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8020a0:	00 00 00 
  8020a3:	48 8b 00             	mov    (%rax),%rax
  8020a6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020ac:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020af:	89 c6                	mov    %eax,%esi
  8020b1:	48 bf 18 41 80 00 00 	movabs $0x804118,%rdi
  8020b8:	00 00 00 
  8020bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c0:	48 b9 28 05 80 00 00 	movabs $0x800528,%rcx
  8020c7:	00 00 00 
  8020ca:	ff d1                	callq  *%rcx
	*dev = 0;
  8020cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020d0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020dc:	c9                   	leaveq 
  8020dd:	c3                   	retq   

00000000008020de <close>:

int
close(int fdnum)
{
  8020de:	55                   	push   %rbp
  8020df:	48 89 e5             	mov    %rsp,%rbp
  8020e2:	48 83 ec 20          	sub    $0x20,%rsp
  8020e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020e9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020f0:	48 89 d6             	mov    %rdx,%rsi
  8020f3:	89 c7                	mov    %eax,%edi
  8020f5:	48 b8 ce 1e 80 00 00 	movabs $0x801ece,%rax
  8020fc:	00 00 00 
  8020ff:	ff d0                	callq  *%rax
  802101:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802104:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802108:	79 05                	jns    80210f <close+0x31>
		return r;
  80210a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80210d:	eb 18                	jmp    802127 <close+0x49>
	else
		return fd_close(fd, 1);
  80210f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802113:	be 01 00 00 00       	mov    $0x1,%esi
  802118:	48 89 c7             	mov    %rax,%rdi
  80211b:	48 b8 5e 1f 80 00 00 	movabs $0x801f5e,%rax
  802122:	00 00 00 
  802125:	ff d0                	callq  *%rax
}
  802127:	c9                   	leaveq 
  802128:	c3                   	retq   

0000000000802129 <close_all>:

void
close_all(void)
{
  802129:	55                   	push   %rbp
  80212a:	48 89 e5             	mov    %rsp,%rbp
  80212d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802131:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802138:	eb 15                	jmp    80214f <close_all+0x26>
		close(i);
  80213a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213d:	89 c7                	mov    %eax,%edi
  80213f:	48 b8 de 20 80 00 00 	movabs $0x8020de,%rax
  802146:	00 00 00 
  802149:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80214b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80214f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802153:	7e e5                	jle    80213a <close_all+0x11>
		close(i);
}
  802155:	c9                   	leaveq 
  802156:	c3                   	retq   

0000000000802157 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802157:	55                   	push   %rbp
  802158:	48 89 e5             	mov    %rsp,%rbp
  80215b:	48 83 ec 40          	sub    $0x40,%rsp
  80215f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802162:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802165:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802169:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80216c:	48 89 d6             	mov    %rdx,%rsi
  80216f:	89 c7                	mov    %eax,%edi
  802171:	48 b8 ce 1e 80 00 00 	movabs $0x801ece,%rax
  802178:	00 00 00 
  80217b:	ff d0                	callq  *%rax
  80217d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802180:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802184:	79 08                	jns    80218e <dup+0x37>
		return r;
  802186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802189:	e9 70 01 00 00       	jmpq   8022fe <dup+0x1a7>
	close(newfdnum);
  80218e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802191:	89 c7                	mov    %eax,%edi
  802193:	48 b8 de 20 80 00 00 	movabs $0x8020de,%rax
  80219a:	00 00 00 
  80219d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80219f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021a2:	48 98                	cltq   
  8021a4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021aa:	48 c1 e0 0c          	shl    $0xc,%rax
  8021ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8021b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021b6:	48 89 c7             	mov    %rax,%rdi
  8021b9:	48 b8 0b 1e 80 00 00 	movabs $0x801e0b,%rax
  8021c0:	00 00 00 
  8021c3:	ff d0                	callq  *%rax
  8021c5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021cd:	48 89 c7             	mov    %rax,%rdi
  8021d0:	48 b8 0b 1e 80 00 00 	movabs $0x801e0b,%rax
  8021d7:	00 00 00 
  8021da:	ff d0                	callq  *%rax
  8021dc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e4:	48 c1 e8 15          	shr    $0x15,%rax
  8021e8:	48 89 c2             	mov    %rax,%rdx
  8021eb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021f2:	01 00 00 
  8021f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f9:	83 e0 01             	and    $0x1,%eax
  8021fc:	48 85 c0             	test   %rax,%rax
  8021ff:	74 73                	je     802274 <dup+0x11d>
  802201:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802205:	48 c1 e8 0c          	shr    $0xc,%rax
  802209:	48 89 c2             	mov    %rax,%rdx
  80220c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802213:	01 00 00 
  802216:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221a:	83 e0 01             	and    $0x1,%eax
  80221d:	48 85 c0             	test   %rax,%rax
  802220:	74 52                	je     802274 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802226:	48 c1 e8 0c          	shr    $0xc,%rax
  80222a:	48 89 c2             	mov    %rax,%rdx
  80222d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802234:	01 00 00 
  802237:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223b:	25 07 0e 00 00       	and    $0xe07,%eax
  802240:	89 c1                	mov    %eax,%ecx
  802242:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802246:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80224a:	41 89 c8             	mov    %ecx,%r8d
  80224d:	48 89 d1             	mov    %rdx,%rcx
  802250:	ba 00 00 00 00       	mov    $0x0,%edx
  802255:	48 89 c6             	mov    %rax,%rsi
  802258:	bf 00 00 00 00       	mov    $0x0,%edi
  80225d:	48 b8 9d 1a 80 00 00 	movabs $0x801a9d,%rax
  802264:	00 00 00 
  802267:	ff d0                	callq  *%rax
  802269:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80226c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802270:	79 02                	jns    802274 <dup+0x11d>
			goto err;
  802272:	eb 57                	jmp    8022cb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802274:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802278:	48 c1 e8 0c          	shr    $0xc,%rax
  80227c:	48 89 c2             	mov    %rax,%rdx
  80227f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802286:	01 00 00 
  802289:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80228d:	25 07 0e 00 00       	and    $0xe07,%eax
  802292:	89 c1                	mov    %eax,%ecx
  802294:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802298:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80229c:	41 89 c8             	mov    %ecx,%r8d
  80229f:	48 89 d1             	mov    %rdx,%rcx
  8022a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a7:	48 89 c6             	mov    %rax,%rsi
  8022aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8022af:	48 b8 9d 1a 80 00 00 	movabs $0x801a9d,%rax
  8022b6:	00 00 00 
  8022b9:	ff d0                	callq  *%rax
  8022bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c2:	79 02                	jns    8022c6 <dup+0x16f>
		goto err;
  8022c4:	eb 05                	jmp    8022cb <dup+0x174>

	return newfdnum;
  8022c6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022c9:	eb 33                	jmp    8022fe <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8022cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022cf:	48 89 c6             	mov    %rax,%rsi
  8022d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d7:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  8022de:	00 00 00 
  8022e1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022e7:	48 89 c6             	mov    %rax,%rsi
  8022ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ef:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  8022f6:	00 00 00 
  8022f9:	ff d0                	callq  *%rax
	return r;
  8022fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022fe:	c9                   	leaveq 
  8022ff:	c3                   	retq   

0000000000802300 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802300:	55                   	push   %rbp
  802301:	48 89 e5             	mov    %rsp,%rbp
  802304:	48 83 ec 40          	sub    $0x40,%rsp
  802308:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80230b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80230f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802313:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802317:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80231a:	48 89 d6             	mov    %rdx,%rsi
  80231d:	89 c7                	mov    %eax,%edi
  80231f:	48 b8 ce 1e 80 00 00 	movabs $0x801ece,%rax
  802326:	00 00 00 
  802329:	ff d0                	callq  *%rax
  80232b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80232e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802332:	78 24                	js     802358 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802338:	8b 00                	mov    (%rax),%eax
  80233a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80233e:	48 89 d6             	mov    %rdx,%rsi
  802341:	89 c7                	mov    %eax,%edi
  802343:	48 b8 27 20 80 00 00 	movabs $0x802027,%rax
  80234a:	00 00 00 
  80234d:	ff d0                	callq  *%rax
  80234f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802352:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802356:	79 05                	jns    80235d <read+0x5d>
		return r;
  802358:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235b:	eb 76                	jmp    8023d3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80235d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802361:	8b 40 08             	mov    0x8(%rax),%eax
  802364:	83 e0 03             	and    $0x3,%eax
  802367:	83 f8 01             	cmp    $0x1,%eax
  80236a:	75 3a                	jne    8023a6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80236c:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802373:	00 00 00 
  802376:	48 8b 00             	mov    (%rax),%rax
  802379:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80237f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802382:	89 c6                	mov    %eax,%esi
  802384:	48 bf 37 41 80 00 00 	movabs $0x804137,%rdi
  80238b:	00 00 00 
  80238e:	b8 00 00 00 00       	mov    $0x0,%eax
  802393:	48 b9 28 05 80 00 00 	movabs $0x800528,%rcx
  80239a:	00 00 00 
  80239d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80239f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023a4:	eb 2d                	jmp    8023d3 <read+0xd3>
	}
	if (!dev->dev_read)
  8023a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023aa:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023ae:	48 85 c0             	test   %rax,%rax
  8023b1:	75 07                	jne    8023ba <read+0xba>
		return -E_NOT_SUPP;
  8023b3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023b8:	eb 19                	jmp    8023d3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8023ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023be:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023c2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023c6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023ca:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023ce:	48 89 cf             	mov    %rcx,%rdi
  8023d1:	ff d0                	callq  *%rax
}
  8023d3:	c9                   	leaveq 
  8023d4:	c3                   	retq   

00000000008023d5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023d5:	55                   	push   %rbp
  8023d6:	48 89 e5             	mov    %rsp,%rbp
  8023d9:	48 83 ec 30          	sub    $0x30,%rsp
  8023dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023ef:	eb 49                	jmp    80243a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f4:	48 98                	cltq   
  8023f6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023fa:	48 29 c2             	sub    %rax,%rdx
  8023fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802400:	48 63 c8             	movslq %eax,%rcx
  802403:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802407:	48 01 c1             	add    %rax,%rcx
  80240a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80240d:	48 89 ce             	mov    %rcx,%rsi
  802410:	89 c7                	mov    %eax,%edi
  802412:	48 b8 00 23 80 00 00 	movabs $0x802300,%rax
  802419:	00 00 00 
  80241c:	ff d0                	callq  *%rax
  80241e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802421:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802425:	79 05                	jns    80242c <readn+0x57>
			return m;
  802427:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80242a:	eb 1c                	jmp    802448 <readn+0x73>
		if (m == 0)
  80242c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802430:	75 02                	jne    802434 <readn+0x5f>
			break;
  802432:	eb 11                	jmp    802445 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802434:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802437:	01 45 fc             	add    %eax,-0x4(%rbp)
  80243a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80243d:	48 98                	cltq   
  80243f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802443:	72 ac                	jb     8023f1 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802445:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802448:	c9                   	leaveq 
  802449:	c3                   	retq   

000000000080244a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80244a:	55                   	push   %rbp
  80244b:	48 89 e5             	mov    %rsp,%rbp
  80244e:	48 83 ec 40          	sub    $0x40,%rsp
  802452:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802455:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802459:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80245d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802461:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802464:	48 89 d6             	mov    %rdx,%rsi
  802467:	89 c7                	mov    %eax,%edi
  802469:	48 b8 ce 1e 80 00 00 	movabs $0x801ece,%rax
  802470:	00 00 00 
  802473:	ff d0                	callq  *%rax
  802475:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802478:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80247c:	78 24                	js     8024a2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80247e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802482:	8b 00                	mov    (%rax),%eax
  802484:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802488:	48 89 d6             	mov    %rdx,%rsi
  80248b:	89 c7                	mov    %eax,%edi
  80248d:	48 b8 27 20 80 00 00 	movabs $0x802027,%rax
  802494:	00 00 00 
  802497:	ff d0                	callq  *%rax
  802499:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80249c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a0:	79 05                	jns    8024a7 <write+0x5d>
		return r;
  8024a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a5:	eb 75                	jmp    80251c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ab:	8b 40 08             	mov    0x8(%rax),%eax
  8024ae:	83 e0 03             	and    $0x3,%eax
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	75 3a                	jne    8024ef <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8024b5:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8024bc:	00 00 00 
  8024bf:	48 8b 00             	mov    (%rax),%rax
  8024c2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024c8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024cb:	89 c6                	mov    %eax,%esi
  8024cd:	48 bf 53 41 80 00 00 	movabs $0x804153,%rdi
  8024d4:	00 00 00 
  8024d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024dc:	48 b9 28 05 80 00 00 	movabs $0x800528,%rcx
  8024e3:	00 00 00 
  8024e6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024ed:	eb 2d                	jmp    80251c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024f7:	48 85 c0             	test   %rax,%rax
  8024fa:	75 07                	jne    802503 <write+0xb9>
		return -E_NOT_SUPP;
  8024fc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802501:	eb 19                	jmp    80251c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802503:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802507:	48 8b 40 18          	mov    0x18(%rax),%rax
  80250b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80250f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802513:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802517:	48 89 cf             	mov    %rcx,%rdi
  80251a:	ff d0                	callq  *%rax
}
  80251c:	c9                   	leaveq 
  80251d:	c3                   	retq   

000000000080251e <seek>:

int
seek(int fdnum, off_t offset)
{
  80251e:	55                   	push   %rbp
  80251f:	48 89 e5             	mov    %rsp,%rbp
  802522:	48 83 ec 18          	sub    $0x18,%rsp
  802526:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802529:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80252c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802530:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802533:	48 89 d6             	mov    %rdx,%rsi
  802536:	89 c7                	mov    %eax,%edi
  802538:	48 b8 ce 1e 80 00 00 	movabs $0x801ece,%rax
  80253f:	00 00 00 
  802542:	ff d0                	callq  *%rax
  802544:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802547:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254b:	79 05                	jns    802552 <seek+0x34>
		return r;
  80254d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802550:	eb 0f                	jmp    802561 <seek+0x43>
	fd->fd_offset = offset;
  802552:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802556:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802559:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80255c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802561:	c9                   	leaveq 
  802562:	c3                   	retq   

0000000000802563 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802563:	55                   	push   %rbp
  802564:	48 89 e5             	mov    %rsp,%rbp
  802567:	48 83 ec 30          	sub    $0x30,%rsp
  80256b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80256e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802571:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802575:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802578:	48 89 d6             	mov    %rdx,%rsi
  80257b:	89 c7                	mov    %eax,%edi
  80257d:	48 b8 ce 1e 80 00 00 	movabs $0x801ece,%rax
  802584:	00 00 00 
  802587:	ff d0                	callq  *%rax
  802589:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802590:	78 24                	js     8025b6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802596:	8b 00                	mov    (%rax),%eax
  802598:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80259c:	48 89 d6             	mov    %rdx,%rsi
  80259f:	89 c7                	mov    %eax,%edi
  8025a1:	48 b8 27 20 80 00 00 	movabs $0x802027,%rax
  8025a8:	00 00 00 
  8025ab:	ff d0                	callq  *%rax
  8025ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b4:	79 05                	jns    8025bb <ftruncate+0x58>
		return r;
  8025b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b9:	eb 72                	jmp    80262d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025bf:	8b 40 08             	mov    0x8(%rax),%eax
  8025c2:	83 e0 03             	and    $0x3,%eax
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	75 3a                	jne    802603 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025c9:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8025d0:	00 00 00 
  8025d3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025d6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025dc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025df:	89 c6                	mov    %eax,%esi
  8025e1:	48 bf 70 41 80 00 00 	movabs $0x804170,%rdi
  8025e8:	00 00 00 
  8025eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f0:	48 b9 28 05 80 00 00 	movabs $0x800528,%rcx
  8025f7:	00 00 00 
  8025fa:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802601:	eb 2a                	jmp    80262d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802603:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802607:	48 8b 40 30          	mov    0x30(%rax),%rax
  80260b:	48 85 c0             	test   %rax,%rax
  80260e:	75 07                	jne    802617 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802610:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802615:	eb 16                	jmp    80262d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802617:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80261f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802623:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802626:	89 ce                	mov    %ecx,%esi
  802628:	48 89 d7             	mov    %rdx,%rdi
  80262b:	ff d0                	callq  *%rax
}
  80262d:	c9                   	leaveq 
  80262e:	c3                   	retq   

000000000080262f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80262f:	55                   	push   %rbp
  802630:	48 89 e5             	mov    %rsp,%rbp
  802633:	48 83 ec 30          	sub    $0x30,%rsp
  802637:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80263a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80263e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802642:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802645:	48 89 d6             	mov    %rdx,%rsi
  802648:	89 c7                	mov    %eax,%edi
  80264a:	48 b8 ce 1e 80 00 00 	movabs $0x801ece,%rax
  802651:	00 00 00 
  802654:	ff d0                	callq  *%rax
  802656:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802659:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265d:	78 24                	js     802683 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80265f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802663:	8b 00                	mov    (%rax),%eax
  802665:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802669:	48 89 d6             	mov    %rdx,%rsi
  80266c:	89 c7                	mov    %eax,%edi
  80266e:	48 b8 27 20 80 00 00 	movabs $0x802027,%rax
  802675:	00 00 00 
  802678:	ff d0                	callq  *%rax
  80267a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802681:	79 05                	jns    802688 <fstat+0x59>
		return r;
  802683:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802686:	eb 5e                	jmp    8026e6 <fstat+0xb7>
	if (!dev->dev_stat)
  802688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802690:	48 85 c0             	test   %rax,%rax
  802693:	75 07                	jne    80269c <fstat+0x6d>
		return -E_NOT_SUPP;
  802695:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80269a:	eb 4a                	jmp    8026e6 <fstat+0xb7>
	stat->st_name[0] = 0;
  80269c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026a0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8026a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026a7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8026ae:	00 00 00 
	stat->st_isdir = 0;
  8026b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026b5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026bc:	00 00 00 
	stat->st_dev = dev;
  8026bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026c7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026da:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026de:	48 89 ce             	mov    %rcx,%rsi
  8026e1:	48 89 d7             	mov    %rdx,%rdi
  8026e4:	ff d0                	callq  *%rax
}
  8026e6:	c9                   	leaveq 
  8026e7:	c3                   	retq   

00000000008026e8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026e8:	55                   	push   %rbp
  8026e9:	48 89 e5             	mov    %rsp,%rbp
  8026ec:	48 83 ec 20          	sub    $0x20,%rsp
  8026f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026fc:	be 00 00 00 00       	mov    $0x0,%esi
  802701:	48 89 c7             	mov    %rax,%rdi
  802704:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  80270b:	00 00 00 
  80270e:	ff d0                	callq  *%rax
  802710:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802713:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802717:	79 05                	jns    80271e <stat+0x36>
		return fd;
  802719:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271c:	eb 2f                	jmp    80274d <stat+0x65>
	r = fstat(fd, stat);
  80271e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802722:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802725:	48 89 d6             	mov    %rdx,%rsi
  802728:	89 c7                	mov    %eax,%edi
  80272a:	48 b8 2f 26 80 00 00 	movabs $0x80262f,%rax
  802731:	00 00 00 
  802734:	ff d0                	callq  *%rax
  802736:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802739:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273c:	89 c7                	mov    %eax,%edi
  80273e:	48 b8 de 20 80 00 00 	movabs $0x8020de,%rax
  802745:	00 00 00 
  802748:	ff d0                	callq  *%rax
	return r;
  80274a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80274d:	c9                   	leaveq 
  80274e:	c3                   	retq   

000000000080274f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80274f:	55                   	push   %rbp
  802750:	48 89 e5             	mov    %rsp,%rbp
  802753:	48 83 ec 10          	sub    $0x10,%rsp
  802757:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80275a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80275e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802765:	00 00 00 
  802768:	8b 00                	mov    (%rax),%eax
  80276a:	85 c0                	test   %eax,%eax
  80276c:	75 1d                	jne    80278b <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80276e:	bf 01 00 00 00       	mov    $0x1,%edi
  802773:	48 b8 7e 3a 80 00 00 	movabs $0x803a7e,%rax
  80277a:	00 00 00 
  80277d:	ff d0                	callq  *%rax
  80277f:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802786:	00 00 00 
  802789:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80278b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802792:	00 00 00 
  802795:	8b 00                	mov    (%rax),%eax
  802797:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80279a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80279f:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8027a6:	00 00 00 
  8027a9:	89 c7                	mov    %eax,%edi
  8027ab:	48 b8 7f 39 80 00 00 	movabs $0x80397f,%rax
  8027b2:	00 00 00 
  8027b5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c0:	48 89 c6             	mov    %rax,%rsi
  8027c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c8:	48 b8 cc 38 80 00 00 	movabs $0x8038cc,%rax
  8027cf:	00 00 00 
  8027d2:	ff d0                	callq  *%rax
}
  8027d4:	c9                   	leaveq 
  8027d5:	c3                   	retq   

00000000008027d6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027d6:	55                   	push   %rbp
  8027d7:	48 89 e5             	mov    %rsp,%rbp
  8027da:	48 83 ec 20          	sub    $0x20,%rsp
  8027de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027e2:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  8027e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e9:	48 89 c7             	mov    %rax,%rdi
  8027ec:	48 b8 b2 10 80 00 00 	movabs $0x8010b2,%rax
  8027f3:	00 00 00 
  8027f6:	ff d0                	callq  *%rax
  8027f8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027fd:	7e 0a                	jle    802809 <open+0x33>
		return -E_BAD_PATH;
  8027ff:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802804:	e9 a5 00 00 00       	jmpq   8028ae <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  802809:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80280d:	48 89 c7             	mov    %rax,%rdi
  802810:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  802817:	00 00 00 
  80281a:	ff d0                	callq  *%rax
  80281c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80281f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802823:	79 08                	jns    80282d <open+0x57>
		return ret;
  802825:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802828:	e9 81 00 00 00       	jmpq   8028ae <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  80282d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802834:	00 00 00 
  802837:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80283a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  802840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802844:	48 89 c6             	mov    %rax,%rsi
  802847:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80284e:	00 00 00 
  802851:	48 b8 1e 11 80 00 00 	movabs $0x80111e,%rax
  802858:	00 00 00 
  80285b:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  80285d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802861:	48 89 c6             	mov    %rax,%rsi
  802864:	bf 01 00 00 00       	mov    $0x1,%edi
  802869:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802870:	00 00 00 
  802873:	ff d0                	callq  *%rax
  802875:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802878:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287c:	79 1d                	jns    80289b <open+0xc5>
	{
		fd_close(fd,0);
  80287e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802882:	be 00 00 00 00       	mov    $0x0,%esi
  802887:	48 89 c7             	mov    %rax,%rdi
  80288a:	48 b8 5e 1f 80 00 00 	movabs $0x801f5e,%rax
  802891:	00 00 00 
  802894:	ff d0                	callq  *%rax
		return ret;
  802896:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802899:	eb 13                	jmp    8028ae <open+0xd8>
	}
	return fd2num (fd);
  80289b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80289f:	48 89 c7             	mov    %rax,%rdi
  8028a2:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  8028a9:	00 00 00 
  8028ac:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  8028ae:	c9                   	leaveq 
  8028af:	c3                   	retq   

00000000008028b0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028b0:	55                   	push   %rbp
  8028b1:	48 89 e5             	mov    %rsp,%rbp
  8028b4:	48 83 ec 10          	sub    $0x10,%rsp
  8028b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028c0:	8b 50 0c             	mov    0xc(%rax),%edx
  8028c3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028ca:	00 00 00 
  8028cd:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028cf:	be 00 00 00 00       	mov    $0x0,%esi
  8028d4:	bf 06 00 00 00       	mov    $0x6,%edi
  8028d9:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  8028e0:	00 00 00 
  8028e3:	ff d0                	callq  *%rax
}
  8028e5:	c9                   	leaveq 
  8028e6:	c3                   	retq   

00000000008028e7 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028e7:	55                   	push   %rbp
  8028e8:	48 89 e5             	mov    %rsp,%rbp
  8028eb:	48 83 ec 30          	sub    $0x30,%rsp
  8028ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  8028fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ff:	8b 50 0c             	mov    0xc(%rax),%edx
  802902:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802909:	00 00 00 
  80290c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  80290e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802915:	00 00 00 
  802918:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80291c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  802920:	be 00 00 00 00       	mov    $0x0,%esi
  802925:	bf 03 00 00 00       	mov    $0x3,%edi
  80292a:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802931:	00 00 00 
  802934:	ff d0                	callq  *%rax
  802936:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802939:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293d:	79 05                	jns    802944 <devfile_read+0x5d>
		return ret;
  80293f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802942:	eb 26                	jmp    80296a <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  802944:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802947:	48 63 d0             	movslq %eax,%rdx
  80294a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80294e:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802955:	00 00 00 
  802958:	48 89 c7             	mov    %rax,%rdi
  80295b:	48 b8 42 14 80 00 00 	movabs $0x801442,%rax
  802962:	00 00 00 
  802965:	ff d0                	callq  *%rax
	return ret;
  802967:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  80296a:	c9                   	leaveq 
  80296b:	c3                   	retq   

000000000080296c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80296c:	55                   	push   %rbp
  80296d:	48 89 e5             	mov    %rsp,%rbp
  802970:	48 83 ec 30          	sub    $0x30,%rsp
  802974:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802978:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80297c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  802980:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802984:	8b 50 0c             	mov    0xc(%rax),%edx
  802987:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80298e:	00 00 00 
  802991:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  802993:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  802998:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80299f:	00 
  8029a0:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8029a5:	48 89 c2             	mov    %rax,%rdx
  8029a8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029af:	00 00 00 
  8029b2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8029b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029bd:	00 00 00 
  8029c0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8029c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c8:	48 89 c6             	mov    %rax,%rsi
  8029cb:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8029d2:	00 00 00 
  8029d5:	48 b8 42 14 80 00 00 	movabs $0x801442,%rax
  8029dc:	00 00 00 
  8029df:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  8029e1:	be 00 00 00 00       	mov    $0x0,%esi
  8029e6:	bf 04 00 00 00       	mov    $0x4,%edi
  8029eb:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  8029f2:	00 00 00 
  8029f5:	ff d0                	callq  *%rax
  8029f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029fe:	79 05                	jns    802a05 <devfile_write+0x99>
		return ret;
  802a00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a03:	eb 03                	jmp    802a08 <devfile_write+0x9c>
	
	return ret;
  802a05:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  802a08:	c9                   	leaveq 
  802a09:	c3                   	retq   

0000000000802a0a <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a0a:	55                   	push   %rbp
  802a0b:	48 89 e5             	mov    %rsp,%rbp
  802a0e:	48 83 ec 20          	sub    $0x20,%rsp
  802a12:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a16:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1e:	8b 50 0c             	mov    0xc(%rax),%edx
  802a21:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a28:	00 00 00 
  802a2b:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a2d:	be 00 00 00 00       	mov    $0x0,%esi
  802a32:	bf 05 00 00 00       	mov    $0x5,%edi
  802a37:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802a3e:	00 00 00 
  802a41:	ff d0                	callq  *%rax
  802a43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4a:	79 05                	jns    802a51 <devfile_stat+0x47>
		return r;
  802a4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4f:	eb 56                	jmp    802aa7 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a51:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a55:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802a5c:	00 00 00 
  802a5f:	48 89 c7             	mov    %rax,%rdi
  802a62:	48 b8 1e 11 80 00 00 	movabs $0x80111e,%rax
  802a69:	00 00 00 
  802a6c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a6e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a75:	00 00 00 
  802a78:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a82:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a88:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a8f:	00 00 00 
  802a92:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a9c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802aa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aa7:	c9                   	leaveq 
  802aa8:	c3                   	retq   

0000000000802aa9 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802aa9:	55                   	push   %rbp
  802aaa:	48 89 e5             	mov    %rsp,%rbp
  802aad:	48 83 ec 10          	sub    $0x10,%rsp
  802ab1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ab5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ab8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802abc:	8b 50 0c             	mov    0xc(%rax),%edx
  802abf:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ac6:	00 00 00 
  802ac9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802acb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ad2:	00 00 00 
  802ad5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802ad8:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802adb:	be 00 00 00 00       	mov    $0x0,%esi
  802ae0:	bf 02 00 00 00       	mov    $0x2,%edi
  802ae5:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802aec:	00 00 00 
  802aef:	ff d0                	callq  *%rax
}
  802af1:	c9                   	leaveq 
  802af2:	c3                   	retq   

0000000000802af3 <remove>:

// Delete a file
int
remove(const char *path)
{
  802af3:	55                   	push   %rbp
  802af4:	48 89 e5             	mov    %rsp,%rbp
  802af7:	48 83 ec 10          	sub    $0x10,%rsp
  802afb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802aff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b03:	48 89 c7             	mov    %rax,%rdi
  802b06:	48 b8 b2 10 80 00 00 	movabs $0x8010b2,%rax
  802b0d:	00 00 00 
  802b10:	ff d0                	callq  *%rax
  802b12:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b17:	7e 07                	jle    802b20 <remove+0x2d>
		return -E_BAD_PATH;
  802b19:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b1e:	eb 33                	jmp    802b53 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b24:	48 89 c6             	mov    %rax,%rsi
  802b27:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802b2e:	00 00 00 
  802b31:	48 b8 1e 11 80 00 00 	movabs $0x80111e,%rax
  802b38:	00 00 00 
  802b3b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b3d:	be 00 00 00 00       	mov    $0x0,%esi
  802b42:	bf 07 00 00 00       	mov    $0x7,%edi
  802b47:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	callq  *%rax
}
  802b53:	c9                   	leaveq 
  802b54:	c3                   	retq   

0000000000802b55 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b55:	55                   	push   %rbp
  802b56:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b59:	be 00 00 00 00       	mov    $0x0,%esi
  802b5e:	bf 08 00 00 00       	mov    $0x8,%edi
  802b63:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802b6a:	00 00 00 
  802b6d:	ff d0                	callq  *%rax
}
  802b6f:	5d                   	pop    %rbp
  802b70:	c3                   	retq   

0000000000802b71 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b71:	55                   	push   %rbp
  802b72:	48 89 e5             	mov    %rsp,%rbp
  802b75:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b7c:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b83:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b8a:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b91:	be 00 00 00 00       	mov    $0x0,%esi
  802b96:	48 89 c7             	mov    %rax,%rdi
  802b99:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  802ba0:	00 00 00 
  802ba3:	ff d0                	callq  *%rax
  802ba5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ba8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bac:	79 28                	jns    802bd6 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802bae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb1:	89 c6                	mov    %eax,%esi
  802bb3:	48 bf 96 41 80 00 00 	movabs $0x804196,%rdi
  802bba:	00 00 00 
  802bbd:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc2:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  802bc9:	00 00 00 
  802bcc:	ff d2                	callq  *%rdx
		return fd_src;
  802bce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd1:	e9 74 01 00 00       	jmpq   802d4a <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802bd6:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802bdd:	be 01 01 00 00       	mov    $0x101,%esi
  802be2:	48 89 c7             	mov    %rax,%rdi
  802be5:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  802bec:	00 00 00 
  802bef:	ff d0                	callq  *%rax
  802bf1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802bf4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bf8:	79 39                	jns    802c33 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802bfa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bfd:	89 c6                	mov    %eax,%esi
  802bff:	48 bf ac 41 80 00 00 	movabs $0x8041ac,%rdi
  802c06:	00 00 00 
  802c09:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0e:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  802c15:	00 00 00 
  802c18:	ff d2                	callq  *%rdx
		close(fd_src);
  802c1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1d:	89 c7                	mov    %eax,%edi
  802c1f:	48 b8 de 20 80 00 00 	movabs $0x8020de,%rax
  802c26:	00 00 00 
  802c29:	ff d0                	callq  *%rax
		return fd_dest;
  802c2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c2e:	e9 17 01 00 00       	jmpq   802d4a <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c33:	eb 74                	jmp    802ca9 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c35:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c38:	48 63 d0             	movslq %eax,%rdx
  802c3b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c45:	48 89 ce             	mov    %rcx,%rsi
  802c48:	89 c7                	mov    %eax,%edi
  802c4a:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
  802c56:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c59:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c5d:	79 4a                	jns    802ca9 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c5f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c62:	89 c6                	mov    %eax,%esi
  802c64:	48 bf c6 41 80 00 00 	movabs $0x8041c6,%rdi
  802c6b:	00 00 00 
  802c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c73:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  802c7a:	00 00 00 
  802c7d:	ff d2                	callq  *%rdx
			close(fd_src);
  802c7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c82:	89 c7                	mov    %eax,%edi
  802c84:	48 b8 de 20 80 00 00 	movabs $0x8020de,%rax
  802c8b:	00 00 00 
  802c8e:	ff d0                	callq  *%rax
			close(fd_dest);
  802c90:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c93:	89 c7                	mov    %eax,%edi
  802c95:	48 b8 de 20 80 00 00 	movabs $0x8020de,%rax
  802c9c:	00 00 00 
  802c9f:	ff d0                	callq  *%rax
			return write_size;
  802ca1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ca4:	e9 a1 00 00 00       	jmpq   802d4a <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ca9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb3:	ba 00 02 00 00       	mov    $0x200,%edx
  802cb8:	48 89 ce             	mov    %rcx,%rsi
  802cbb:	89 c7                	mov    %eax,%edi
  802cbd:	48 b8 00 23 80 00 00 	movabs $0x802300,%rax
  802cc4:	00 00 00 
  802cc7:	ff d0                	callq  *%rax
  802cc9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ccc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cd0:	0f 8f 5f ff ff ff    	jg     802c35 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802cd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cda:	79 47                	jns    802d23 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802cdc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cdf:	89 c6                	mov    %eax,%esi
  802ce1:	48 bf d9 41 80 00 00 	movabs $0x8041d9,%rdi
  802ce8:	00 00 00 
  802ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf0:	48 ba 28 05 80 00 00 	movabs $0x800528,%rdx
  802cf7:	00 00 00 
  802cfa:	ff d2                	callq  *%rdx
		close(fd_src);
  802cfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cff:	89 c7                	mov    %eax,%edi
  802d01:	48 b8 de 20 80 00 00 	movabs $0x8020de,%rax
  802d08:	00 00 00 
  802d0b:	ff d0                	callq  *%rax
		close(fd_dest);
  802d0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d10:	89 c7                	mov    %eax,%edi
  802d12:	48 b8 de 20 80 00 00 	movabs $0x8020de,%rax
  802d19:	00 00 00 
  802d1c:	ff d0                	callq  *%rax
		return read_size;
  802d1e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d21:	eb 27                	jmp    802d4a <copy+0x1d9>
	}
	close(fd_src);
  802d23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d26:	89 c7                	mov    %eax,%edi
  802d28:	48 b8 de 20 80 00 00 	movabs $0x8020de,%rax
  802d2f:	00 00 00 
  802d32:	ff d0                	callq  *%rax
	close(fd_dest);
  802d34:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d37:	89 c7                	mov    %eax,%edi
  802d39:	48 b8 de 20 80 00 00 	movabs $0x8020de,%rax
  802d40:	00 00 00 
  802d43:	ff d0                	callq  *%rax
	return 0;
  802d45:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d4a:	c9                   	leaveq 
  802d4b:	c3                   	retq   

0000000000802d4c <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802d4c:	55                   	push   %rbp
  802d4d:	48 89 e5             	mov    %rsp,%rbp
  802d50:	48 83 ec 20          	sub    $0x20,%rsp
  802d54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802d58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5c:	8b 40 0c             	mov    0xc(%rax),%eax
  802d5f:	85 c0                	test   %eax,%eax
  802d61:	7e 67                	jle    802dca <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802d63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d67:	8b 40 04             	mov    0x4(%rax),%eax
  802d6a:	48 63 d0             	movslq %eax,%rdx
  802d6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d71:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802d75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d79:	8b 00                	mov    (%rax),%eax
  802d7b:	48 89 ce             	mov    %rcx,%rsi
  802d7e:	89 c7                	mov    %eax,%edi
  802d80:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  802d87:	00 00 00 
  802d8a:	ff d0                	callq  *%rax
  802d8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802d8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d93:	7e 13                	jle    802da8 <writebuf+0x5c>
			b->result += result;
  802d95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d99:	8b 50 08             	mov    0x8(%rax),%edx
  802d9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9f:	01 c2                	add    %eax,%edx
  802da1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da5:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802da8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dac:	8b 40 04             	mov    0x4(%rax),%eax
  802daf:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802db2:	74 16                	je     802dca <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802db4:	b8 00 00 00 00       	mov    $0x0,%eax
  802db9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dbd:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802dc1:	89 c2                	mov    %eax,%edx
  802dc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc7:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802dca:	c9                   	leaveq 
  802dcb:	c3                   	retq   

0000000000802dcc <putch>:

static void
putch(int ch, void *thunk)
{
  802dcc:	55                   	push   %rbp
  802dcd:	48 89 e5             	mov    %rsp,%rbp
  802dd0:	48 83 ec 20          	sub    $0x20,%rsp
  802dd4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dd7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802ddb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ddf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802de3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802de7:	8b 40 04             	mov    0x4(%rax),%eax
  802dea:	8d 48 01             	lea    0x1(%rax),%ecx
  802ded:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802df1:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802df4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802df7:	89 d1                	mov    %edx,%ecx
  802df9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802dfd:	48 98                	cltq   
  802dff:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802e03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e07:	8b 40 04             	mov    0x4(%rax),%eax
  802e0a:	3d 00 01 00 00       	cmp    $0x100,%eax
  802e0f:	75 1e                	jne    802e2f <putch+0x63>
		writebuf(b);
  802e11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e15:	48 89 c7             	mov    %rax,%rdi
  802e18:	48 b8 4c 2d 80 00 00 	movabs $0x802d4c,%rax
  802e1f:	00 00 00 
  802e22:	ff d0                	callq  *%rax
		b->idx = 0;
  802e24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802e2f:	c9                   	leaveq 
  802e30:	c3                   	retq   

0000000000802e31 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802e31:	55                   	push   %rbp
  802e32:	48 89 e5             	mov    %rsp,%rbp
  802e35:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802e3c:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802e42:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802e49:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802e50:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802e56:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802e5c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802e63:	00 00 00 
	b.result = 0;
  802e66:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802e6d:	00 00 00 
	b.error = 1;
  802e70:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802e77:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802e7a:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802e81:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802e88:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802e8f:	48 89 c6             	mov    %rax,%rsi
  802e92:	48 bf cc 2d 80 00 00 	movabs $0x802dcc,%rdi
  802e99:	00 00 00 
  802e9c:	48 b8 db 08 80 00 00 	movabs $0x8008db,%rax
  802ea3:	00 00 00 
  802ea6:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802ea8:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802eae:	85 c0                	test   %eax,%eax
  802eb0:	7e 16                	jle    802ec8 <vfprintf+0x97>
		writebuf(&b);
  802eb2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802eb9:	48 89 c7             	mov    %rax,%rdi
  802ebc:	48 b8 4c 2d 80 00 00 	movabs $0x802d4c,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802ec8:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802ece:	85 c0                	test   %eax,%eax
  802ed0:	74 08                	je     802eda <vfprintf+0xa9>
  802ed2:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802ed8:	eb 06                	jmp    802ee0 <vfprintf+0xaf>
  802eda:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802ee0:	c9                   	leaveq 
  802ee1:	c3                   	retq   

0000000000802ee2 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802ee2:	55                   	push   %rbp
  802ee3:	48 89 e5             	mov    %rsp,%rbp
  802ee6:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802eed:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802ef3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802efa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802f01:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802f08:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802f0f:	84 c0                	test   %al,%al
  802f11:	74 20                	je     802f33 <fprintf+0x51>
  802f13:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802f17:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802f1b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802f1f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802f23:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802f27:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802f2b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802f2f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802f33:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802f3a:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802f41:	00 00 00 
  802f44:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802f4b:	00 00 00 
  802f4e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f52:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802f59:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802f60:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802f67:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802f6e:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802f75:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802f7b:	48 89 ce             	mov    %rcx,%rsi
  802f7e:	89 c7                	mov    %eax,%edi
  802f80:	48 b8 31 2e 80 00 00 	movabs $0x802e31,%rax
  802f87:	00 00 00 
  802f8a:	ff d0                	callq  *%rax
  802f8c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802f92:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802f98:	c9                   	leaveq 
  802f99:	c3                   	retq   

0000000000802f9a <printf>:

int
printf(const char *fmt, ...)
{
  802f9a:	55                   	push   %rbp
  802f9b:	48 89 e5             	mov    %rsp,%rbp
  802f9e:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802fa5:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802fac:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802fb3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fba:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802fc1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802fc8:	84 c0                	test   %al,%al
  802fca:	74 20                	je     802fec <printf+0x52>
  802fcc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802fd0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802fd4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802fd8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802fdc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802fe0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802fe4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802fe8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802fec:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802ff3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802ffa:	00 00 00 
  802ffd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803004:	00 00 00 
  803007:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80300b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803012:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803019:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803020:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803027:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80302e:	48 89 c6             	mov    %rax,%rsi
  803031:	bf 01 00 00 00       	mov    $0x1,%edi
  803036:	48 b8 31 2e 80 00 00 	movabs $0x802e31,%rax
  80303d:	00 00 00 
  803040:	ff d0                	callq  *%rax
  803042:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803048:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80304e:	c9                   	leaveq 
  80304f:	c3                   	retq   

0000000000803050 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803050:	55                   	push   %rbp
  803051:	48 89 e5             	mov    %rsp,%rbp
  803054:	53                   	push   %rbx
  803055:	48 83 ec 38          	sub    $0x38,%rsp
  803059:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80305d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803061:	48 89 c7             	mov    %rax,%rdi
  803064:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  80306b:	00 00 00 
  80306e:	ff d0                	callq  *%rax
  803070:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803073:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803077:	0f 88 bf 01 00 00    	js     80323c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80307d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803081:	ba 07 04 00 00       	mov    $0x407,%edx
  803086:	48 89 c6             	mov    %rax,%rsi
  803089:	bf 00 00 00 00       	mov    $0x0,%edi
  80308e:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  803095:	00 00 00 
  803098:	ff d0                	callq  *%rax
  80309a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80309d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030a1:	0f 88 95 01 00 00    	js     80323c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8030a7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8030ab:	48 89 c7             	mov    %rax,%rdi
  8030ae:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  8030b5:	00 00 00 
  8030b8:	ff d0                	callq  *%rax
  8030ba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030c1:	0f 88 5d 01 00 00    	js     803224 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030cb:	ba 07 04 00 00       	mov    $0x407,%edx
  8030d0:	48 89 c6             	mov    %rax,%rsi
  8030d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8030d8:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  8030df:	00 00 00 
  8030e2:	ff d0                	callq  *%rax
  8030e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030eb:	0f 88 33 01 00 00    	js     803224 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8030f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030f5:	48 89 c7             	mov    %rax,%rdi
  8030f8:	48 b8 0b 1e 80 00 00 	movabs $0x801e0b,%rax
  8030ff:	00 00 00 
  803102:	ff d0                	callq  *%rax
  803104:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803108:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80310c:	ba 07 04 00 00       	mov    $0x407,%edx
  803111:	48 89 c6             	mov    %rax,%rsi
  803114:	bf 00 00 00 00       	mov    $0x0,%edi
  803119:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  803120:	00 00 00 
  803123:	ff d0                	callq  *%rax
  803125:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803128:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80312c:	79 05                	jns    803133 <pipe+0xe3>
		goto err2;
  80312e:	e9 d9 00 00 00       	jmpq   80320c <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803133:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803137:	48 89 c7             	mov    %rax,%rdi
  80313a:	48 b8 0b 1e 80 00 00 	movabs $0x801e0b,%rax
  803141:	00 00 00 
  803144:	ff d0                	callq  *%rax
  803146:	48 89 c2             	mov    %rax,%rdx
  803149:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80314d:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803153:	48 89 d1             	mov    %rdx,%rcx
  803156:	ba 00 00 00 00       	mov    $0x0,%edx
  80315b:	48 89 c6             	mov    %rax,%rsi
  80315e:	bf 00 00 00 00       	mov    $0x0,%edi
  803163:	48 b8 9d 1a 80 00 00 	movabs $0x801a9d,%rax
  80316a:	00 00 00 
  80316d:	ff d0                	callq  *%rax
  80316f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803172:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803176:	79 1b                	jns    803193 <pipe+0x143>
		goto err3;
  803178:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803179:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80317d:	48 89 c6             	mov    %rax,%rsi
  803180:	bf 00 00 00 00       	mov    $0x0,%edi
  803185:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  80318c:	00 00 00 
  80318f:	ff d0                	callq  *%rax
  803191:	eb 79                	jmp    80320c <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803193:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803197:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  80319e:	00 00 00 
  8031a1:	8b 12                	mov    (%rdx),%edx
  8031a3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8031a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8031b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031b4:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  8031bb:	00 00 00 
  8031be:	8b 12                	mov    (%rdx),%edx
  8031c0:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8031c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031c6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8031cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d1:	48 89 c7             	mov    %rax,%rdi
  8031d4:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  8031db:	00 00 00 
  8031de:	ff d0                	callq  *%rax
  8031e0:	89 c2                	mov    %eax,%edx
  8031e2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031e6:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8031e8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031ec:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8031f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031f4:	48 89 c7             	mov    %rax,%rdi
  8031f7:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  8031fe:	00 00 00 
  803201:	ff d0                	callq  *%rax
  803203:	89 03                	mov    %eax,(%rbx)
	return 0;
  803205:	b8 00 00 00 00       	mov    $0x0,%eax
  80320a:	eb 33                	jmp    80323f <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80320c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803210:	48 89 c6             	mov    %rax,%rsi
  803213:	bf 00 00 00 00       	mov    $0x0,%edi
  803218:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  80321f:	00 00 00 
  803222:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803224:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803228:	48 89 c6             	mov    %rax,%rsi
  80322b:	bf 00 00 00 00       	mov    $0x0,%edi
  803230:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  803237:	00 00 00 
  80323a:	ff d0                	callq  *%rax
err:
	return r;
  80323c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80323f:	48 83 c4 38          	add    $0x38,%rsp
  803243:	5b                   	pop    %rbx
  803244:	5d                   	pop    %rbp
  803245:	c3                   	retq   

0000000000803246 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803246:	55                   	push   %rbp
  803247:	48 89 e5             	mov    %rsp,%rbp
  80324a:	53                   	push   %rbx
  80324b:	48 83 ec 28          	sub    $0x28,%rsp
  80324f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803253:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803257:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80325e:	00 00 00 
  803261:	48 8b 00             	mov    (%rax),%rax
  803264:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80326a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80326d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803271:	48 89 c7             	mov    %rax,%rdi
  803274:	48 b8 f0 3a 80 00 00 	movabs $0x803af0,%rax
  80327b:	00 00 00 
  80327e:	ff d0                	callq  *%rax
  803280:	89 c3                	mov    %eax,%ebx
  803282:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803286:	48 89 c7             	mov    %rax,%rdi
  803289:	48 b8 f0 3a 80 00 00 	movabs $0x803af0,%rax
  803290:	00 00 00 
  803293:	ff d0                	callq  *%rax
  803295:	39 c3                	cmp    %eax,%ebx
  803297:	0f 94 c0             	sete   %al
  80329a:	0f b6 c0             	movzbl %al,%eax
  80329d:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8032a0:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8032a7:	00 00 00 
  8032aa:	48 8b 00             	mov    (%rax),%rax
  8032ad:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8032b3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8032b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032b9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8032bc:	75 05                	jne    8032c3 <_pipeisclosed+0x7d>
			return ret;
  8032be:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032c1:	eb 4f                	jmp    803312 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8032c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032c6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8032c9:	74 42                	je     80330d <_pipeisclosed+0xc7>
  8032cb:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8032cf:	75 3c                	jne    80330d <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8032d1:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8032d8:	00 00 00 
  8032db:	48 8b 00             	mov    (%rax),%rax
  8032de:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8032e4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8032e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032ea:	89 c6                	mov    %eax,%esi
  8032ec:	48 bf f9 41 80 00 00 	movabs $0x8041f9,%rdi
  8032f3:	00 00 00 
  8032f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8032fb:	49 b8 28 05 80 00 00 	movabs $0x800528,%r8
  803302:	00 00 00 
  803305:	41 ff d0             	callq  *%r8
	}
  803308:	e9 4a ff ff ff       	jmpq   803257 <_pipeisclosed+0x11>
  80330d:	e9 45 ff ff ff       	jmpq   803257 <_pipeisclosed+0x11>
}
  803312:	48 83 c4 28          	add    $0x28,%rsp
  803316:	5b                   	pop    %rbx
  803317:	5d                   	pop    %rbp
  803318:	c3                   	retq   

0000000000803319 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803319:	55                   	push   %rbp
  80331a:	48 89 e5             	mov    %rsp,%rbp
  80331d:	48 83 ec 30          	sub    $0x30,%rsp
  803321:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803324:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803328:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80332b:	48 89 d6             	mov    %rdx,%rsi
  80332e:	89 c7                	mov    %eax,%edi
  803330:	48 b8 ce 1e 80 00 00 	movabs $0x801ece,%rax
  803337:	00 00 00 
  80333a:	ff d0                	callq  *%rax
  80333c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80333f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803343:	79 05                	jns    80334a <pipeisclosed+0x31>
		return r;
  803345:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803348:	eb 31                	jmp    80337b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80334a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80334e:	48 89 c7             	mov    %rax,%rdi
  803351:	48 b8 0b 1e 80 00 00 	movabs $0x801e0b,%rax
  803358:	00 00 00 
  80335b:	ff d0                	callq  *%rax
  80335d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803361:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803365:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803369:	48 89 d6             	mov    %rdx,%rsi
  80336c:	48 89 c7             	mov    %rax,%rdi
  80336f:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  803376:	00 00 00 
  803379:	ff d0                	callq  *%rax
}
  80337b:	c9                   	leaveq 
  80337c:	c3                   	retq   

000000000080337d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80337d:	55                   	push   %rbp
  80337e:	48 89 e5             	mov    %rsp,%rbp
  803381:	48 83 ec 40          	sub    $0x40,%rsp
  803385:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803389:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80338d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803391:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803395:	48 89 c7             	mov    %rax,%rdi
  803398:	48 b8 0b 1e 80 00 00 	movabs $0x801e0b,%rax
  80339f:	00 00 00 
  8033a2:	ff d0                	callq  *%rax
  8033a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8033a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8033b0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8033b7:	00 
  8033b8:	e9 92 00 00 00       	jmpq   80344f <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8033bd:	eb 41                	jmp    803400 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8033bf:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8033c4:	74 09                	je     8033cf <devpipe_read+0x52>
				return i;
  8033c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ca:	e9 92 00 00 00       	jmpq   803461 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8033cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d7:	48 89 d6             	mov    %rdx,%rsi
  8033da:	48 89 c7             	mov    %rax,%rdi
  8033dd:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  8033e4:	00 00 00 
  8033e7:	ff d0                	callq  *%rax
  8033e9:	85 c0                	test   %eax,%eax
  8033eb:	74 07                	je     8033f4 <devpipe_read+0x77>
				return 0;
  8033ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f2:	eb 6d                	jmp    803461 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8033f4:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  8033fb:	00 00 00 
  8033fe:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803400:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803404:	8b 10                	mov    (%rax),%edx
  803406:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80340a:	8b 40 04             	mov    0x4(%rax),%eax
  80340d:	39 c2                	cmp    %eax,%edx
  80340f:	74 ae                	je     8033bf <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803411:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803415:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803419:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80341d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803421:	8b 00                	mov    (%rax),%eax
  803423:	99                   	cltd   
  803424:	c1 ea 1b             	shr    $0x1b,%edx
  803427:	01 d0                	add    %edx,%eax
  803429:	83 e0 1f             	and    $0x1f,%eax
  80342c:	29 d0                	sub    %edx,%eax
  80342e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803432:	48 98                	cltq   
  803434:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803439:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80343b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80343f:	8b 00                	mov    (%rax),%eax
  803441:	8d 50 01             	lea    0x1(%rax),%edx
  803444:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803448:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80344a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80344f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803453:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803457:	0f 82 60 ff ff ff    	jb     8033bd <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80345d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803461:	c9                   	leaveq 
  803462:	c3                   	retq   

0000000000803463 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803463:	55                   	push   %rbp
  803464:	48 89 e5             	mov    %rsp,%rbp
  803467:	48 83 ec 40          	sub    $0x40,%rsp
  80346b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80346f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803473:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803477:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80347b:	48 89 c7             	mov    %rax,%rdi
  80347e:	48 b8 0b 1e 80 00 00 	movabs $0x801e0b,%rax
  803485:	00 00 00 
  803488:	ff d0                	callq  *%rax
  80348a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80348e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803492:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803496:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80349d:	00 
  80349e:	e9 8e 00 00 00       	jmpq   803531 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8034a3:	eb 31                	jmp    8034d6 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8034a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034ad:	48 89 d6             	mov    %rdx,%rsi
  8034b0:	48 89 c7             	mov    %rax,%rdi
  8034b3:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  8034ba:	00 00 00 
  8034bd:	ff d0                	callq  *%rax
  8034bf:	85 c0                	test   %eax,%eax
  8034c1:	74 07                	je     8034ca <devpipe_write+0x67>
				return 0;
  8034c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c8:	eb 79                	jmp    803543 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8034ca:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  8034d1:	00 00 00 
  8034d4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8034d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034da:	8b 40 04             	mov    0x4(%rax),%eax
  8034dd:	48 63 d0             	movslq %eax,%rdx
  8034e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e4:	8b 00                	mov    (%rax),%eax
  8034e6:	48 98                	cltq   
  8034e8:	48 83 c0 20          	add    $0x20,%rax
  8034ec:	48 39 c2             	cmp    %rax,%rdx
  8034ef:	73 b4                	jae    8034a5 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8034f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f5:	8b 40 04             	mov    0x4(%rax),%eax
  8034f8:	99                   	cltd   
  8034f9:	c1 ea 1b             	shr    $0x1b,%edx
  8034fc:	01 d0                	add    %edx,%eax
  8034fe:	83 e0 1f             	and    $0x1f,%eax
  803501:	29 d0                	sub    %edx,%eax
  803503:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803507:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80350b:	48 01 ca             	add    %rcx,%rdx
  80350e:	0f b6 0a             	movzbl (%rdx),%ecx
  803511:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803515:	48 98                	cltq   
  803517:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80351b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80351f:	8b 40 04             	mov    0x4(%rax),%eax
  803522:	8d 50 01             	lea    0x1(%rax),%edx
  803525:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803529:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80352c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803531:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803535:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803539:	0f 82 64 ff ff ff    	jb     8034a3 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80353f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803543:	c9                   	leaveq 
  803544:	c3                   	retq   

0000000000803545 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803545:	55                   	push   %rbp
  803546:	48 89 e5             	mov    %rsp,%rbp
  803549:	48 83 ec 20          	sub    $0x20,%rsp
  80354d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803551:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803555:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803559:	48 89 c7             	mov    %rax,%rdi
  80355c:	48 b8 0b 1e 80 00 00 	movabs $0x801e0b,%rax
  803563:	00 00 00 
  803566:	ff d0                	callq  *%rax
  803568:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80356c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803570:	48 be 0c 42 80 00 00 	movabs $0x80420c,%rsi
  803577:	00 00 00 
  80357a:	48 89 c7             	mov    %rax,%rdi
  80357d:	48 b8 1e 11 80 00 00 	movabs $0x80111e,%rax
  803584:	00 00 00 
  803587:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80358d:	8b 50 04             	mov    0x4(%rax),%edx
  803590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803594:	8b 00                	mov    (%rax),%eax
  803596:	29 c2                	sub    %eax,%edx
  803598:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80359c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8035a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8035ad:	00 00 00 
	stat->st_dev = &devpipe;
  8035b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b4:	48 b9 e0 50 80 00 00 	movabs $0x8050e0,%rcx
  8035bb:	00 00 00 
  8035be:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8035c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035ca:	c9                   	leaveq 
  8035cb:	c3                   	retq   

00000000008035cc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8035cc:	55                   	push   %rbp
  8035cd:	48 89 e5             	mov    %rsp,%rbp
  8035d0:	48 83 ec 10          	sub    $0x10,%rsp
  8035d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8035d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035dc:	48 89 c6             	mov    %rax,%rsi
  8035df:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e4:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  8035eb:	00 00 00 
  8035ee:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8035f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035f4:	48 89 c7             	mov    %rax,%rdi
  8035f7:	48 b8 0b 1e 80 00 00 	movabs $0x801e0b,%rax
  8035fe:	00 00 00 
  803601:	ff d0                	callq  *%rax
  803603:	48 89 c6             	mov    %rax,%rsi
  803606:	bf 00 00 00 00       	mov    $0x0,%edi
  80360b:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  803612:	00 00 00 
  803615:	ff d0                	callq  *%rax
}
  803617:	c9                   	leaveq 
  803618:	c3                   	retq   

0000000000803619 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803619:	55                   	push   %rbp
  80361a:	48 89 e5             	mov    %rsp,%rbp
  80361d:	48 83 ec 20          	sub    $0x20,%rsp
  803621:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803624:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803627:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80362a:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80362e:	be 01 00 00 00       	mov    $0x1,%esi
  803633:	48 89 c7             	mov    %rax,%rdi
  803636:	48 b8 05 19 80 00 00 	movabs $0x801905,%rax
  80363d:	00 00 00 
  803640:	ff d0                	callq  *%rax
}
  803642:	c9                   	leaveq 
  803643:	c3                   	retq   

0000000000803644 <getchar>:

int
getchar(void)
{
  803644:	55                   	push   %rbp
  803645:	48 89 e5             	mov    %rsp,%rbp
  803648:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80364c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803650:	ba 01 00 00 00       	mov    $0x1,%edx
  803655:	48 89 c6             	mov    %rax,%rsi
  803658:	bf 00 00 00 00       	mov    $0x0,%edi
  80365d:	48 b8 00 23 80 00 00 	movabs $0x802300,%rax
  803664:	00 00 00 
  803667:	ff d0                	callq  *%rax
  803669:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80366c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803670:	79 05                	jns    803677 <getchar+0x33>
		return r;
  803672:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803675:	eb 14                	jmp    80368b <getchar+0x47>
	if (r < 1)
  803677:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80367b:	7f 07                	jg     803684 <getchar+0x40>
		return -E_EOF;
  80367d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803682:	eb 07                	jmp    80368b <getchar+0x47>
	return c;
  803684:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803688:	0f b6 c0             	movzbl %al,%eax
}
  80368b:	c9                   	leaveq 
  80368c:	c3                   	retq   

000000000080368d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80368d:	55                   	push   %rbp
  80368e:	48 89 e5             	mov    %rsp,%rbp
  803691:	48 83 ec 20          	sub    $0x20,%rsp
  803695:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803698:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80369c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80369f:	48 89 d6             	mov    %rdx,%rsi
  8036a2:	89 c7                	mov    %eax,%edi
  8036a4:	48 b8 ce 1e 80 00 00 	movabs $0x801ece,%rax
  8036ab:	00 00 00 
  8036ae:	ff d0                	callq  *%rax
  8036b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b7:	79 05                	jns    8036be <iscons+0x31>
		return r;
  8036b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bc:	eb 1a                	jmp    8036d8 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8036be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c2:	8b 10                	mov    (%rax),%edx
  8036c4:	48 b8 20 51 80 00 00 	movabs $0x805120,%rax
  8036cb:	00 00 00 
  8036ce:	8b 00                	mov    (%rax),%eax
  8036d0:	39 c2                	cmp    %eax,%edx
  8036d2:	0f 94 c0             	sete   %al
  8036d5:	0f b6 c0             	movzbl %al,%eax
}
  8036d8:	c9                   	leaveq 
  8036d9:	c3                   	retq   

00000000008036da <opencons>:

int
opencons(void)
{
  8036da:	55                   	push   %rbp
  8036db:	48 89 e5             	mov    %rsp,%rbp
  8036de:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8036e2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8036e6:	48 89 c7             	mov    %rax,%rdi
  8036e9:	48 b8 36 1e 80 00 00 	movabs $0x801e36,%rax
  8036f0:	00 00 00 
  8036f3:	ff d0                	callq  *%rax
  8036f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036fc:	79 05                	jns    803703 <opencons+0x29>
		return r;
  8036fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803701:	eb 5b                	jmp    80375e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803703:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803707:	ba 07 04 00 00       	mov    $0x407,%edx
  80370c:	48 89 c6             	mov    %rax,%rsi
  80370f:	bf 00 00 00 00       	mov    $0x0,%edi
  803714:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  80371b:	00 00 00 
  80371e:	ff d0                	callq  *%rax
  803720:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803723:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803727:	79 05                	jns    80372e <opencons+0x54>
		return r;
  803729:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80372c:	eb 30                	jmp    80375e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80372e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803732:	48 ba 20 51 80 00 00 	movabs $0x805120,%rdx
  803739:	00 00 00 
  80373c:	8b 12                	mov    (%rdx),%edx
  80373e:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803740:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803744:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80374b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374f:	48 89 c7             	mov    %rax,%rdi
  803752:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  803759:	00 00 00 
  80375c:	ff d0                	callq  *%rax
}
  80375e:	c9                   	leaveq 
  80375f:	c3                   	retq   

0000000000803760 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803760:	55                   	push   %rbp
  803761:	48 89 e5             	mov    %rsp,%rbp
  803764:	48 83 ec 30          	sub    $0x30,%rsp
  803768:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80376c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803770:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803774:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803779:	75 07                	jne    803782 <devcons_read+0x22>
		return 0;
  80377b:	b8 00 00 00 00       	mov    $0x0,%eax
  803780:	eb 4b                	jmp    8037cd <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803782:	eb 0c                	jmp    803790 <devcons_read+0x30>
		sys_yield();
  803784:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  80378b:	00 00 00 
  80378e:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803790:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  803797:	00 00 00 
  80379a:	ff d0                	callq  *%rax
  80379c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80379f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a3:	74 df                	je     803784 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8037a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a9:	79 05                	jns    8037b0 <devcons_read+0x50>
		return c;
  8037ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ae:	eb 1d                	jmp    8037cd <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8037b0:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8037b4:	75 07                	jne    8037bd <devcons_read+0x5d>
		return 0;
  8037b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8037bb:	eb 10                	jmp    8037cd <devcons_read+0x6d>
	*(char*)vbuf = c;
  8037bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c0:	89 c2                	mov    %eax,%edx
  8037c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c6:	88 10                	mov    %dl,(%rax)
	return 1;
  8037c8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8037cd:	c9                   	leaveq 
  8037ce:	c3                   	retq   

00000000008037cf <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037cf:	55                   	push   %rbp
  8037d0:	48 89 e5             	mov    %rsp,%rbp
  8037d3:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8037da:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8037e1:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8037e8:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8037ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8037f6:	eb 76                	jmp    80386e <devcons_write+0x9f>
		m = n - tot;
  8037f8:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8037ff:	89 c2                	mov    %eax,%edx
  803801:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803804:	29 c2                	sub    %eax,%edx
  803806:	89 d0                	mov    %edx,%eax
  803808:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80380b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80380e:	83 f8 7f             	cmp    $0x7f,%eax
  803811:	76 07                	jbe    80381a <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803813:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80381a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80381d:	48 63 d0             	movslq %eax,%rdx
  803820:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803823:	48 63 c8             	movslq %eax,%rcx
  803826:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80382d:	48 01 c1             	add    %rax,%rcx
  803830:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803837:	48 89 ce             	mov    %rcx,%rsi
  80383a:	48 89 c7             	mov    %rax,%rdi
  80383d:	48 b8 42 14 80 00 00 	movabs $0x801442,%rax
  803844:	00 00 00 
  803847:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803849:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80384c:	48 63 d0             	movslq %eax,%rdx
  80384f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803856:	48 89 d6             	mov    %rdx,%rsi
  803859:	48 89 c7             	mov    %rax,%rdi
  80385c:	48 b8 05 19 80 00 00 	movabs $0x801905,%rax
  803863:	00 00 00 
  803866:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803868:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80386b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80386e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803871:	48 98                	cltq   
  803873:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80387a:	0f 82 78 ff ff ff    	jb     8037f8 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803880:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803883:	c9                   	leaveq 
  803884:	c3                   	retq   

0000000000803885 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803885:	55                   	push   %rbp
  803886:	48 89 e5             	mov    %rsp,%rbp
  803889:	48 83 ec 08          	sub    $0x8,%rsp
  80388d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803891:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803896:	c9                   	leaveq 
  803897:	c3                   	retq   

0000000000803898 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803898:	55                   	push   %rbp
  803899:	48 89 e5             	mov    %rsp,%rbp
  80389c:	48 83 ec 10          	sub    $0x10,%rsp
  8038a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8038a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ac:	48 be 18 42 80 00 00 	movabs $0x804218,%rsi
  8038b3:	00 00 00 
  8038b6:	48 89 c7             	mov    %rax,%rdi
  8038b9:	48 b8 1e 11 80 00 00 	movabs $0x80111e,%rax
  8038c0:	00 00 00 
  8038c3:	ff d0                	callq  *%rax
	return 0;
  8038c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038ca:	c9                   	leaveq 
  8038cb:	c3                   	retq   

00000000008038cc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8038cc:	55                   	push   %rbp
  8038cd:	48 89 e5             	mov    %rsp,%rbp
  8038d0:	48 83 ec 30          	sub    $0x30,%rsp
  8038d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  8038e0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8038e5:	75 08                	jne    8038ef <ipc_recv+0x23>
  8038e7:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8038ee:	ff 
	int res=sys_ipc_recv(pg);
  8038ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038f3:	48 89 c7             	mov    %rax,%rdi
  8038f6:	48 b8 c1 1c 80 00 00 	movabs $0x801cc1,%rax
  8038fd:	00 00 00 
  803900:	ff d0                	callq  *%rax
  803902:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  803905:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80390a:	74 26                	je     803932 <ipc_recv+0x66>
  80390c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803910:	75 15                	jne    803927 <ipc_recv+0x5b>
  803912:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803919:	00 00 00 
  80391c:	48 8b 00             	mov    (%rax),%rax
  80391f:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803925:	eb 05                	jmp    80392c <ipc_recv+0x60>
  803927:	b8 00 00 00 00       	mov    $0x0,%eax
  80392c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803930:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  803932:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803937:	74 26                	je     80395f <ipc_recv+0x93>
  803939:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80393d:	75 15                	jne    803954 <ipc_recv+0x88>
  80393f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803946:	00 00 00 
  803949:	48 8b 00             	mov    (%rax),%rax
  80394c:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803952:	eb 05                	jmp    803959 <ipc_recv+0x8d>
  803954:	b8 00 00 00 00       	mov    $0x0,%eax
  803959:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80395d:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  80395f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803963:	75 15                	jne    80397a <ipc_recv+0xae>
  803965:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80396c:	00 00 00 
  80396f:	48 8b 00             	mov    (%rax),%rax
  803972:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803978:	eb 03                	jmp    80397d <ipc_recv+0xb1>
  80397a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  80397d:	c9                   	leaveq 
  80397e:	c3                   	retq   

000000000080397f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80397f:	55                   	push   %rbp
  803980:	48 89 e5             	mov    %rsp,%rbp
  803983:	48 83 ec 30          	sub    $0x30,%rsp
  803987:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80398a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80398d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803991:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  803994:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803999:	75 0a                	jne    8039a5 <ipc_send+0x26>
  80399b:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8039a2:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8039a3:	eb 3e                	jmp    8039e3 <ipc_send+0x64>
  8039a5:	eb 3c                	jmp    8039e3 <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  8039a7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8039ab:	74 2a                	je     8039d7 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  8039ad:	48 ba 20 42 80 00 00 	movabs $0x804220,%rdx
  8039b4:	00 00 00 
  8039b7:	be 39 00 00 00       	mov    $0x39,%esi
  8039bc:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  8039c3:	00 00 00 
  8039c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039cb:	48 b9 ef 02 80 00 00 	movabs $0x8002ef,%rcx
  8039d2:	00 00 00 
  8039d5:	ff d1                	callq  *%rcx
		sys_yield();  
  8039d7:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  8039de:	00 00 00 
  8039e1:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8039e3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8039e6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8039e9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8039ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039f0:	89 c7                	mov    %eax,%edi
  8039f2:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  8039f9:	00 00 00 
  8039fc:	ff d0                	callq  *%rax
  8039fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a05:	78 a0                	js     8039a7 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  803a07:	c9                   	leaveq 
  803a08:	c3                   	retq   

0000000000803a09 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803a09:	55                   	push   %rbp
  803a0a:	48 89 e5             	mov    %rsp,%rbp
  803a0d:	48 83 ec 10          	sub    $0x10,%rsp
  803a11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  803a15:	48 ba 58 42 80 00 00 	movabs $0x804258,%rdx
  803a1c:	00 00 00 
  803a1f:	be 47 00 00 00       	mov    $0x47,%esi
  803a24:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  803a2b:	00 00 00 
  803a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a33:	48 b9 ef 02 80 00 00 	movabs $0x8002ef,%rcx
  803a3a:	00 00 00 
  803a3d:	ff d1                	callq  *%rcx

0000000000803a3f <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a3f:	55                   	push   %rbp
  803a40:	48 89 e5             	mov    %rsp,%rbp
  803a43:	48 83 ec 20          	sub    $0x20,%rsp
  803a47:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a4a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803a4d:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803a51:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  803a54:	48 ba 80 42 80 00 00 	movabs $0x804280,%rdx
  803a5b:	00 00 00 
  803a5e:	be 50 00 00 00       	mov    $0x50,%esi
  803a63:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  803a6a:	00 00 00 
  803a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  803a72:	48 b9 ef 02 80 00 00 	movabs $0x8002ef,%rcx
  803a79:	00 00 00 
  803a7c:	ff d1                	callq  *%rcx

0000000000803a7e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803a7e:	55                   	push   %rbp
  803a7f:	48 89 e5             	mov    %rsp,%rbp
  803a82:	48 83 ec 14          	sub    $0x14,%rsp
  803a86:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803a89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a90:	eb 4e                	jmp    803ae0 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803a92:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803a99:	00 00 00 
  803a9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a9f:	48 98                	cltq   
  803aa1:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  803aa8:	48 01 d0             	add    %rdx,%rax
  803aab:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ab1:	8b 00                	mov    (%rax),%eax
  803ab3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ab6:	75 24                	jne    803adc <ipc_find_env+0x5e>
			return envs[i].env_id;
  803ab8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803abf:	00 00 00 
  803ac2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac5:	48 98                	cltq   
  803ac7:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  803ace:	48 01 d0             	add    %rdx,%rax
  803ad1:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803ad7:	8b 40 08             	mov    0x8(%rax),%eax
  803ada:	eb 12                	jmp    803aee <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803adc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ae0:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803ae7:	7e a9                	jle    803a92 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  803ae9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803aee:	c9                   	leaveq 
  803aef:	c3                   	retq   

0000000000803af0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803af0:	55                   	push   %rbp
  803af1:	48 89 e5             	mov    %rsp,%rbp
  803af4:	48 83 ec 18          	sub    $0x18,%rsp
  803af8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803afc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b00:	48 c1 e8 15          	shr    $0x15,%rax
  803b04:	48 89 c2             	mov    %rax,%rdx
  803b07:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b0e:	01 00 00 
  803b11:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b15:	83 e0 01             	and    $0x1,%eax
  803b18:	48 85 c0             	test   %rax,%rax
  803b1b:	75 07                	jne    803b24 <pageref+0x34>
		return 0;
  803b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b22:	eb 53                	jmp    803b77 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803b24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b28:	48 c1 e8 0c          	shr    $0xc,%rax
  803b2c:	48 89 c2             	mov    %rax,%rdx
  803b2f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b36:	01 00 00 
  803b39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b3d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803b41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b45:	83 e0 01             	and    $0x1,%eax
  803b48:	48 85 c0             	test   %rax,%rax
  803b4b:	75 07                	jne    803b54 <pageref+0x64>
		return 0;
  803b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b52:	eb 23                	jmp    803b77 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803b54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b58:	48 c1 e8 0c          	shr    $0xc,%rax
  803b5c:	48 89 c2             	mov    %rax,%rdx
  803b5f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803b66:	00 00 00 
  803b69:	48 c1 e2 04          	shl    $0x4,%rdx
  803b6d:	48 01 d0             	add    %rdx,%rax
  803b70:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803b74:	0f b7 c0             	movzwl %ax,%eax
}
  803b77:	c9                   	leaveq 
  803b78:	c3                   	retq   
