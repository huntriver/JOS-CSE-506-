
vmm/guest/obj/user/num:     file format elf64-x86-64


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
  80003c:	e8 97 02 00 00       	callq  8002d8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800052:	e9 da 00 00 00       	jmpq   800131 <num+0xee>
		if (bol) {
  800057:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80005e:	00 00 00 
  800061:	8b 00                	mov    (%rax),%eax
  800063:	85 c0                	test   %eax,%eax
  800065:	74 54                	je     8000bb <num+0x78>
			printf("%5d ", ++line);
  800067:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80006e:	00 00 00 
  800071:	8b 00                	mov    (%rax),%eax
  800073:	8d 50 01             	lea    0x1(%rax),%edx
  800076:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80007d:	00 00 00 
  800080:	89 10                	mov    %edx,(%rax)
  800082:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800089:	00 00 00 
  80008c:	8b 00                	mov    (%rax),%eax
  80008e:	89 c6                	mov    %eax,%esi
  800090:	48 bf 20 3c 80 00 00 	movabs $0x803c20,%rdi
  800097:	00 00 00 
  80009a:	b8 00 00 00 00       	mov    $0x0,%eax
  80009f:	48 ba 29 30 80 00 00 	movabs $0x803029,%rdx
  8000a6:	00 00 00 
  8000a9:	ff d2                	callq  *%rdx
			bol = 0;
  8000ab:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000b2:	00 00 00 
  8000b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if ((r = write(1, &c, 1)) != 1)
  8000bb:	48 8d 45 f3          	lea    -0xd(%rbp),%rax
  8000bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8000c4:	48 89 c6             	mov    %rax,%rsi
  8000c7:	bf 01 00 00 00       	mov    $0x1,%edi
  8000cc:	48 b8 d9 24 80 00 00 	movabs $0x8024d9,%rax
  8000d3:	00 00 00 
  8000d6:	ff d0                	callq  *%rax
  8000d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000db:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
  8000df:	74 38                	je     800119 <num+0xd6>
			panic("write error copying %s: %e", s, r);
  8000e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e8:	41 89 d0             	mov    %edx,%r8d
  8000eb:	48 89 c1             	mov    %rax,%rcx
  8000ee:	48 ba 25 3c 80 00 00 	movabs $0x803c25,%rdx
  8000f5:	00 00 00 
  8000f8:	be 13 00 00 00       	mov    $0x13,%esi
  8000fd:	48 bf 40 3c 80 00 00 	movabs $0x803c40,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	49 b9 7e 03 80 00 00 	movabs $0x80037e,%r9
  800113:	00 00 00 
  800116:	41 ff d1             	callq  *%r9
		if (c == '\n')
  800119:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  80011d:	3c 0a                	cmp    $0xa,%al
  80011f:	75 10                	jne    800131 <num+0xee>
			bol = 1;
  800121:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800128:	00 00 00 
  80012b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800131:	48 8d 4d f3          	lea    -0xd(%rbp),%rcx
  800135:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800138:	ba 01 00 00 00       	mov    $0x1,%edx
  80013d:	48 89 ce             	mov    %rcx,%rsi
  800140:	89 c7                	mov    %eax,%edi
  800142:	48 b8 8f 23 80 00 00 	movabs $0x80238f,%rax
  800149:	00 00 00 
  80014c:	ff d0                	callq  *%rax
  80014e:	48 98                	cltq   
  800150:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800154:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800159:	0f 8f f8 fe ff ff    	jg     800057 <num+0x14>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  80015f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800164:	79 39                	jns    80019f <num+0x15c>
		panic("error reading %s: %e", s, n);
  800166:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80016a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80016e:	49 89 d0             	mov    %rdx,%r8
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba 4b 3c 80 00 00 	movabs $0x803c4b,%rdx
  80017b:	00 00 00 
  80017e:	be 18 00 00 00       	mov    $0x18,%esi
  800183:	48 bf 40 3c 80 00 00 	movabs $0x803c40,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 7e 03 80 00 00 	movabs $0x80037e,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
}
  80019f:	c9                   	leaveq 
  8001a0:	c3                   	retq   

00000000008001a1 <umain>:

void
umain(int argc, char **argv)
{
  8001a1:	55                   	push   %rbp
  8001a2:	48 89 e5             	mov    %rsp,%rbp
  8001a5:	53                   	push   %rbx
  8001a6:	48 83 ec 28          	sub    $0x28,%rsp
  8001aa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8001ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "num";
  8001b1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001b8:	00 00 00 
  8001bb:	48 bb 60 3c 80 00 00 	movabs $0x803c60,%rbx
  8001c2:	00 00 00 
  8001c5:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  8001c8:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  8001cc:	75 20                	jne    8001ee <umain+0x4d>
		num(0, "<stdin>");
  8001ce:	48 be 64 3c 80 00 00 	movabs $0x803c64,%rsi
  8001d5:	00 00 00 
  8001d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	e9 d7 00 00 00       	jmpq   8002c5 <umain+0x124>
	else
		for (i = 1; i < argc; i++) {
  8001ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  8001f5:	e9 bf 00 00 00       	jmpq   8002b9 <umain+0x118>
			f = open(argv[i], O_RDONLY);
  8001fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001fd:	48 98                	cltq   
  8001ff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800206:	00 
  800207:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80020b:	48 01 d0             	add    %rdx,%rax
  80020e:	48 8b 00             	mov    (%rax),%rax
  800211:	be 00 00 00 00       	mov    $0x0,%esi
  800216:	48 89 c7             	mov    %rax,%rdi
  800219:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  800220:	00 00 00 
  800223:	ff d0                	callq  *%rax
  800225:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  800228:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80022c:	79 4b                	jns    800279 <umain+0xd8>
				panic("can't open %s: %e", argv[i], f);
  80022e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800231:	48 98                	cltq   
  800233:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80023a:	00 
  80023b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80023f:	48 01 d0             	add    %rdx,%rax
  800242:	48 8b 00             	mov    (%rax),%rax
  800245:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800248:	41 89 d0             	mov    %edx,%r8d
  80024b:	48 89 c1             	mov    %rax,%rcx
  80024e:	48 ba 6c 3c 80 00 00 	movabs $0x803c6c,%rdx
  800255:	00 00 00 
  800258:	be 27 00 00 00       	mov    $0x27,%esi
  80025d:	48 bf 40 3c 80 00 00 	movabs $0x803c40,%rdi
  800264:	00 00 00 
  800267:	b8 00 00 00 00       	mov    $0x0,%eax
  80026c:	49 b9 7e 03 80 00 00 	movabs $0x80037e,%r9
  800273:	00 00 00 
  800276:	41 ff d1             	callq  *%r9
			else {
				num(f, argv[i]);
  800279:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027c:	48 98                	cltq   
  80027e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800285:	00 
  800286:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80028a:	48 01 d0             	add    %rdx,%rax
  80028d:	48 8b 10             	mov    (%rax),%rdx
  800290:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800293:	48 89 d6             	mov    %rdx,%rsi
  800296:	89 c7                	mov    %eax,%edi
  800298:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80029f:	00 00 00 
  8002a2:	ff d0                	callq  *%rax
				close(f);
  8002a4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002a7:	89 c7                	mov    %eax,%edi
  8002a9:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  8002b0:	00 00 00 
  8002b3:	ff d0                	callq  *%rax

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8002b5:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8002b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002bc:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  8002bf:	0f 8c 35 ff ff ff    	jl     8001fa <umain+0x59>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8002c5:	48 b8 5b 03 80 00 00 	movabs $0x80035b,%rax
  8002cc:	00 00 00 
  8002cf:	ff d0                	callq  *%rax
}
  8002d1:	48 83 c4 28          	add    $0x28,%rsp
  8002d5:	5b                   	pop    %rbx
  8002d6:	5d                   	pop    %rbp
  8002d7:	c3                   	retq   

00000000008002d8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d8:	55                   	push   %rbp
  8002d9:	48 89 e5             	mov    %rsp,%rbp
  8002dc:	48 83 ec 10          	sub    $0x10,%rsp
  8002e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  8002e7:	48 b8 60 1a 80 00 00 	movabs $0x801a60,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
  8002f3:	48 98                	cltq   
  8002f5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002fa:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  800301:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800308:	00 00 00 
  80030b:	48 01 c2             	add    %rax,%rdx
  80030e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800315:	00 00 00 
  800318:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80031b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80031f:	7e 14                	jle    800335 <libmain+0x5d>
		binaryname = argv[0];
  800321:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800325:	48 8b 10             	mov    (%rax),%rdx
  800328:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80032f:	00 00 00 
  800332:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800335:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800339:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80033c:	48 89 d6             	mov    %rdx,%rsi
  80033f:	89 c7                	mov    %eax,%edi
  800341:	48 b8 a1 01 80 00 00 	movabs $0x8001a1,%rax
  800348:	00 00 00 
  80034b:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80034d:	48 b8 5b 03 80 00 00 	movabs $0x80035b,%rax
  800354:	00 00 00 
  800357:	ff d0                	callq  *%rax
}
  800359:	c9                   	leaveq 
  80035a:	c3                   	retq   

000000000080035b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80035b:	55                   	push   %rbp
  80035c:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80035f:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  800366:	00 00 00 
  800369:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80036b:	bf 00 00 00 00       	mov    $0x0,%edi
  800370:	48 b8 1c 1a 80 00 00 	movabs $0x801a1c,%rax
  800377:	00 00 00 
  80037a:	ff d0                	callq  *%rax
}
  80037c:	5d                   	pop    %rbp
  80037d:	c3                   	retq   

000000000080037e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80037e:	55                   	push   %rbp
  80037f:	48 89 e5             	mov    %rsp,%rbp
  800382:	53                   	push   %rbx
  800383:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80038a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800391:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800397:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80039e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003a5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003ac:	84 c0                	test   %al,%al
  8003ae:	74 23                	je     8003d3 <_panic+0x55>
  8003b0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003b7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003bb:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003bf:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003c3:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003c7:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003cb:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003cf:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003d3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003da:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003e1:	00 00 00 
  8003e4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003eb:	00 00 00 
  8003ee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003f2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003f9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800400:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800407:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80040e:	00 00 00 
  800411:	48 8b 18             	mov    (%rax),%rbx
  800414:	48 b8 60 1a 80 00 00 	movabs $0x801a60,%rax
  80041b:	00 00 00 
  80041e:	ff d0                	callq  *%rax
  800420:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800426:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80042d:	41 89 c8             	mov    %ecx,%r8d
  800430:	48 89 d1             	mov    %rdx,%rcx
  800433:	48 89 da             	mov    %rbx,%rdx
  800436:	89 c6                	mov    %eax,%esi
  800438:	48 bf 88 3c 80 00 00 	movabs $0x803c88,%rdi
  80043f:	00 00 00 
  800442:	b8 00 00 00 00       	mov    $0x0,%eax
  800447:	49 b9 b7 05 80 00 00 	movabs $0x8005b7,%r9
  80044e:	00 00 00 
  800451:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800454:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80045b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800462:	48 89 d6             	mov    %rdx,%rsi
  800465:	48 89 c7             	mov    %rax,%rdi
  800468:	48 b8 0b 05 80 00 00 	movabs $0x80050b,%rax
  80046f:	00 00 00 
  800472:	ff d0                	callq  *%rax
	cprintf("\n");
  800474:	48 bf ab 3c 80 00 00 	movabs $0x803cab,%rdi
  80047b:	00 00 00 
  80047e:	b8 00 00 00 00       	mov    $0x0,%eax
  800483:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  80048a:	00 00 00 
  80048d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80048f:	cc                   	int3   
  800490:	eb fd                	jmp    80048f <_panic+0x111>

0000000000800492 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800492:	55                   	push   %rbp
  800493:	48 89 e5             	mov    %rsp,%rbp
  800496:	48 83 ec 10          	sub    $0x10,%rsp
  80049a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80049d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8004a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a5:	8b 00                	mov    (%rax),%eax
  8004a7:	8d 48 01             	lea    0x1(%rax),%ecx
  8004aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004ae:	89 0a                	mov    %ecx,(%rdx)
  8004b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004b3:	89 d1                	mov    %edx,%ecx
  8004b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b9:	48 98                	cltq   
  8004bb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8004bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c3:	8b 00                	mov    (%rax),%eax
  8004c5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004ca:	75 2c                	jne    8004f8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8004cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d0:	8b 00                	mov    (%rax),%eax
  8004d2:	48 98                	cltq   
  8004d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004d8:	48 83 c2 08          	add    $0x8,%rdx
  8004dc:	48 89 c6             	mov    %rax,%rsi
  8004df:	48 89 d7             	mov    %rdx,%rdi
  8004e2:	48 b8 94 19 80 00 00 	movabs $0x801994,%rax
  8004e9:	00 00 00 
  8004ec:	ff d0                	callq  *%rax
        b->idx = 0;
  8004ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004f2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004fc:	8b 40 04             	mov    0x4(%rax),%eax
  8004ff:	8d 50 01             	lea    0x1(%rax),%edx
  800502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800506:	89 50 04             	mov    %edx,0x4(%rax)
}
  800509:	c9                   	leaveq 
  80050a:	c3                   	retq   

000000000080050b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80050b:	55                   	push   %rbp
  80050c:	48 89 e5             	mov    %rsp,%rbp
  80050f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800516:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80051d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800524:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80052b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800532:	48 8b 0a             	mov    (%rdx),%rcx
  800535:	48 89 08             	mov    %rcx,(%rax)
  800538:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80053c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800540:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800544:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800548:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80054f:	00 00 00 
    b.cnt = 0;
  800552:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800559:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80055c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800563:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80056a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800571:	48 89 c6             	mov    %rax,%rsi
  800574:	48 bf 92 04 80 00 00 	movabs $0x800492,%rdi
  80057b:	00 00 00 
  80057e:	48 b8 6a 09 80 00 00 	movabs $0x80096a,%rax
  800585:	00 00 00 
  800588:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80058a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800590:	48 98                	cltq   
  800592:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800599:	48 83 c2 08          	add    $0x8,%rdx
  80059d:	48 89 c6             	mov    %rax,%rsi
  8005a0:	48 89 d7             	mov    %rdx,%rdi
  8005a3:	48 b8 94 19 80 00 00 	movabs $0x801994,%rax
  8005aa:	00 00 00 
  8005ad:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8005af:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005b5:	c9                   	leaveq 
  8005b6:	c3                   	retq   

00000000008005b7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8005b7:	55                   	push   %rbp
  8005b8:	48 89 e5             	mov    %rsp,%rbp
  8005bb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005c2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005c9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005d0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005d7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005de:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005e5:	84 c0                	test   %al,%al
  8005e7:	74 20                	je     800609 <cprintf+0x52>
  8005e9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005ed:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005f1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005f5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005f9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005fd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800601:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800605:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800609:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800610:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800617:	00 00 00 
  80061a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800621:	00 00 00 
  800624:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800628:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80062f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800636:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80063d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800644:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80064b:	48 8b 0a             	mov    (%rdx),%rcx
  80064e:	48 89 08             	mov    %rcx,(%rax)
  800651:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800655:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800659:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80065d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800661:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800668:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80066f:	48 89 d6             	mov    %rdx,%rsi
  800672:	48 89 c7             	mov    %rax,%rdi
  800675:	48 b8 0b 05 80 00 00 	movabs $0x80050b,%rax
  80067c:	00 00 00 
  80067f:	ff d0                	callq  *%rax
  800681:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800687:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80068d:	c9                   	leaveq 
  80068e:	c3                   	retq   

000000000080068f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068f:	55                   	push   %rbp
  800690:	48 89 e5             	mov    %rsp,%rbp
  800693:	53                   	push   %rbx
  800694:	48 83 ec 38          	sub    $0x38,%rsp
  800698:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80069c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8006a4:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8006a7:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8006ab:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006af:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8006b2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8006b6:	77 3b                	ja     8006f3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b8:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8006bb:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8006bf:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8006c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cb:	48 f7 f3             	div    %rbx
  8006ce:	48 89 c2             	mov    %rax,%rdx
  8006d1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006d4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006d7:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006df:	41 89 f9             	mov    %edi,%r9d
  8006e2:	48 89 c7             	mov    %rax,%rdi
  8006e5:	48 b8 8f 06 80 00 00 	movabs $0x80068f,%rax
  8006ec:	00 00 00 
  8006ef:	ff d0                	callq  *%rax
  8006f1:	eb 1e                	jmp    800711 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f3:	eb 12                	jmp    800707 <printnum+0x78>
			putch(padc, putdat);
  8006f5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006f9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8006fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800700:	48 89 ce             	mov    %rcx,%rsi
  800703:	89 d7                	mov    %edx,%edi
  800705:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800707:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80070b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80070f:	7f e4                	jg     8006f5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800711:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800714:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800718:	ba 00 00 00 00       	mov    $0x0,%edx
  80071d:	48 f7 f1             	div    %rcx
  800720:	48 89 d0             	mov    %rdx,%rax
  800723:	48 ba b0 3e 80 00 00 	movabs $0x803eb0,%rdx
  80072a:	00 00 00 
  80072d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800731:	0f be d0             	movsbl %al,%edx
  800734:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	48 89 ce             	mov    %rcx,%rsi
  80073f:	89 d7                	mov    %edx,%edi
  800741:	ff d0                	callq  *%rax
}
  800743:	48 83 c4 38          	add    $0x38,%rsp
  800747:	5b                   	pop    %rbx
  800748:	5d                   	pop    %rbp
  800749:	c3                   	retq   

000000000080074a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80074a:	55                   	push   %rbp
  80074b:	48 89 e5             	mov    %rsp,%rbp
  80074e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800752:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800756:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800759:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80075d:	7e 52                	jle    8007b1 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	8b 00                	mov    (%rax),%eax
  800765:	83 f8 30             	cmp    $0x30,%eax
  800768:	73 24                	jae    80078e <getuint+0x44>
  80076a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800776:	8b 00                	mov    (%rax),%eax
  800778:	89 c0                	mov    %eax,%eax
  80077a:	48 01 d0             	add    %rdx,%rax
  80077d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800781:	8b 12                	mov    (%rdx),%edx
  800783:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800786:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078a:	89 0a                	mov    %ecx,(%rdx)
  80078c:	eb 17                	jmp    8007a5 <getuint+0x5b>
  80078e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800792:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800796:	48 89 d0             	mov    %rdx,%rax
  800799:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80079d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007a5:	48 8b 00             	mov    (%rax),%rax
  8007a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007ac:	e9 a3 00 00 00       	jmpq   800854 <getuint+0x10a>
	else if (lflag)
  8007b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007b5:	74 4f                	je     800806 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8007b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bb:	8b 00                	mov    (%rax),%eax
  8007bd:	83 f8 30             	cmp    $0x30,%eax
  8007c0:	73 24                	jae    8007e6 <getuint+0x9c>
  8007c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	8b 00                	mov    (%rax),%eax
  8007d0:	89 c0                	mov    %eax,%eax
  8007d2:	48 01 d0             	add    %rdx,%rax
  8007d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d9:	8b 12                	mov    (%rdx),%edx
  8007db:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e2:	89 0a                	mov    %ecx,(%rdx)
  8007e4:	eb 17                	jmp    8007fd <getuint+0xb3>
  8007e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ea:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007ee:	48 89 d0             	mov    %rdx,%rax
  8007f1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007fd:	48 8b 00             	mov    (%rax),%rax
  800800:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800804:	eb 4e                	jmp    800854 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080a:	8b 00                	mov    (%rax),%eax
  80080c:	83 f8 30             	cmp    $0x30,%eax
  80080f:	73 24                	jae    800835 <getuint+0xeb>
  800811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800815:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081d:	8b 00                	mov    (%rax),%eax
  80081f:	89 c0                	mov    %eax,%eax
  800821:	48 01 d0             	add    %rdx,%rax
  800824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800828:	8b 12                	mov    (%rdx),%edx
  80082a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80082d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800831:	89 0a                	mov    %ecx,(%rdx)
  800833:	eb 17                	jmp    80084c <getuint+0x102>
  800835:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800839:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80083d:	48 89 d0             	mov    %rdx,%rax
  800840:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800844:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800848:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80084c:	8b 00                	mov    (%rax),%eax
  80084e:	89 c0                	mov    %eax,%eax
  800850:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800854:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800858:	c9                   	leaveq 
  800859:	c3                   	retq   

000000000080085a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80085a:	55                   	push   %rbp
  80085b:	48 89 e5             	mov    %rsp,%rbp
  80085e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800862:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800866:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800869:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80086d:	7e 52                	jle    8008c1 <getint+0x67>
		x=va_arg(*ap, long long);
  80086f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800873:	8b 00                	mov    (%rax),%eax
  800875:	83 f8 30             	cmp    $0x30,%eax
  800878:	73 24                	jae    80089e <getint+0x44>
  80087a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800886:	8b 00                	mov    (%rax),%eax
  800888:	89 c0                	mov    %eax,%eax
  80088a:	48 01 d0             	add    %rdx,%rax
  80088d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800891:	8b 12                	mov    (%rdx),%edx
  800893:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800896:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089a:	89 0a                	mov    %ecx,(%rdx)
  80089c:	eb 17                	jmp    8008b5 <getint+0x5b>
  80089e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008a6:	48 89 d0             	mov    %rdx,%rax
  8008a9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008b5:	48 8b 00             	mov    (%rax),%rax
  8008b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008bc:	e9 a3 00 00 00       	jmpq   800964 <getint+0x10a>
	else if (lflag)
  8008c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008c5:	74 4f                	je     800916 <getint+0xbc>
		x=va_arg(*ap, long);
  8008c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cb:	8b 00                	mov    (%rax),%eax
  8008cd:	83 f8 30             	cmp    $0x30,%eax
  8008d0:	73 24                	jae    8008f6 <getint+0x9c>
  8008d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008de:	8b 00                	mov    (%rax),%eax
  8008e0:	89 c0                	mov    %eax,%eax
  8008e2:	48 01 d0             	add    %rdx,%rax
  8008e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e9:	8b 12                	mov    (%rdx),%edx
  8008eb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f2:	89 0a                	mov    %ecx,(%rdx)
  8008f4:	eb 17                	jmp    80090d <getint+0xb3>
  8008f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008fe:	48 89 d0             	mov    %rdx,%rax
  800901:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800905:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800909:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80090d:	48 8b 00             	mov    (%rax),%rax
  800910:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800914:	eb 4e                	jmp    800964 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800916:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091a:	8b 00                	mov    (%rax),%eax
  80091c:	83 f8 30             	cmp    $0x30,%eax
  80091f:	73 24                	jae    800945 <getint+0xeb>
  800921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800925:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092d:	8b 00                	mov    (%rax),%eax
  80092f:	89 c0                	mov    %eax,%eax
  800931:	48 01 d0             	add    %rdx,%rax
  800934:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800938:	8b 12                	mov    (%rdx),%edx
  80093a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80093d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800941:	89 0a                	mov    %ecx,(%rdx)
  800943:	eb 17                	jmp    80095c <getint+0x102>
  800945:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800949:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80094d:	48 89 d0             	mov    %rdx,%rax
  800950:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800954:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800958:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80095c:	8b 00                	mov    (%rax),%eax
  80095e:	48 98                	cltq   
  800960:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800964:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800968:	c9                   	leaveq 
  800969:	c3                   	retq   

000000000080096a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80096a:	55                   	push   %rbp
  80096b:	48 89 e5             	mov    %rsp,%rbp
  80096e:	41 54                	push   %r12
  800970:	53                   	push   %rbx
  800971:	48 83 ec 60          	sub    $0x60,%rsp
  800975:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800979:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80097d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800981:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800985:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800989:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80098d:	48 8b 0a             	mov    (%rdx),%rcx
  800990:	48 89 08             	mov    %rcx,(%rax)
  800993:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800997:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80099b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80099f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a3:	eb 28                	jmp    8009cd <vprintfmt+0x63>
			if (ch == '\0'){
  8009a5:	85 db                	test   %ebx,%ebx
  8009a7:	75 15                	jne    8009be <vprintfmt+0x54>
				current_color=WHITE;
  8009a9:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8009b0:	00 00 00 
  8009b3:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  8009b9:	e9 fc 04 00 00       	jmpq   800eba <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  8009be:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c6:	48 89 d6             	mov    %rdx,%rsi
  8009c9:	89 df                	mov    %ebx,%edi
  8009cb:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009cd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009d1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009d5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009d9:	0f b6 00             	movzbl (%rax),%eax
  8009dc:	0f b6 d8             	movzbl %al,%ebx
  8009df:	83 fb 25             	cmp    $0x25,%ebx
  8009e2:	75 c1                	jne    8009a5 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009e4:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009e8:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009ef:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009f6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009fd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a04:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a08:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a0c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a10:	0f b6 00             	movzbl (%rax),%eax
  800a13:	0f b6 d8             	movzbl %al,%ebx
  800a16:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a19:	83 f8 55             	cmp    $0x55,%eax
  800a1c:	0f 87 64 04 00 00    	ja     800e86 <vprintfmt+0x51c>
  800a22:	89 c0                	mov    %eax,%eax
  800a24:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a2b:	00 
  800a2c:	48 b8 d8 3e 80 00 00 	movabs $0x803ed8,%rax
  800a33:	00 00 00 
  800a36:	48 01 d0             	add    %rdx,%rax
  800a39:	48 8b 00             	mov    (%rax),%rax
  800a3c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a3e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a42:	eb c0                	jmp    800a04 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a44:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a48:	eb ba                	jmp    800a04 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a4a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a51:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a54:	89 d0                	mov    %edx,%eax
  800a56:	c1 e0 02             	shl    $0x2,%eax
  800a59:	01 d0                	add    %edx,%eax
  800a5b:	01 c0                	add    %eax,%eax
  800a5d:	01 d8                	add    %ebx,%eax
  800a5f:	83 e8 30             	sub    $0x30,%eax
  800a62:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a65:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a69:	0f b6 00             	movzbl (%rax),%eax
  800a6c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a6f:	83 fb 2f             	cmp    $0x2f,%ebx
  800a72:	7e 0c                	jle    800a80 <vprintfmt+0x116>
  800a74:	83 fb 39             	cmp    $0x39,%ebx
  800a77:	7f 07                	jg     800a80 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a79:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a7e:	eb d1                	jmp    800a51 <vprintfmt+0xe7>
			goto process_precision;
  800a80:	eb 58                	jmp    800ada <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800a82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a85:	83 f8 30             	cmp    $0x30,%eax
  800a88:	73 17                	jae    800aa1 <vprintfmt+0x137>
  800a8a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a91:	89 c0                	mov    %eax,%eax
  800a93:	48 01 d0             	add    %rdx,%rax
  800a96:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a99:	83 c2 08             	add    $0x8,%edx
  800a9c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a9f:	eb 0f                	jmp    800ab0 <vprintfmt+0x146>
  800aa1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa5:	48 89 d0             	mov    %rdx,%rax
  800aa8:	48 83 c2 08          	add    $0x8,%rdx
  800aac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab0:	8b 00                	mov    (%rax),%eax
  800ab2:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800ab5:	eb 23                	jmp    800ada <vprintfmt+0x170>

		case '.':
			if (width < 0)
  800ab7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800abb:	79 0c                	jns    800ac9 <vprintfmt+0x15f>
				width = 0;
  800abd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ac4:	e9 3b ff ff ff       	jmpq   800a04 <vprintfmt+0x9a>
  800ac9:	e9 36 ff ff ff       	jmpq   800a04 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  800ace:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ad5:	e9 2a ff ff ff       	jmpq   800a04 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  800ada:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ade:	79 12                	jns    800af2 <vprintfmt+0x188>
				width = precision, precision = -1;
  800ae0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ae3:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ae6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800aed:	e9 12 ff ff ff       	jmpq   800a04 <vprintfmt+0x9a>
  800af2:	e9 0d ff ff ff       	jmpq   800a04 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800af7:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800afb:	e9 04 ff ff ff       	jmpq   800a04 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b03:	83 f8 30             	cmp    $0x30,%eax
  800b06:	73 17                	jae    800b1f <vprintfmt+0x1b5>
  800b08:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0f:	89 c0                	mov    %eax,%eax
  800b11:	48 01 d0             	add    %rdx,%rax
  800b14:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b17:	83 c2 08             	add    $0x8,%edx
  800b1a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b1d:	eb 0f                	jmp    800b2e <vprintfmt+0x1c4>
  800b1f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b23:	48 89 d0             	mov    %rdx,%rax
  800b26:	48 83 c2 08          	add    $0x8,%rdx
  800b2a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b2e:	8b 10                	mov    (%rax),%edx
  800b30:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b34:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b38:	48 89 ce             	mov    %rcx,%rsi
  800b3b:	89 d7                	mov    %edx,%edi
  800b3d:	ff d0                	callq  *%rax
			break;
  800b3f:	e9 70 03 00 00       	jmpq   800eb4 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b47:	83 f8 30             	cmp    $0x30,%eax
  800b4a:	73 17                	jae    800b63 <vprintfmt+0x1f9>
  800b4c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b53:	89 c0                	mov    %eax,%eax
  800b55:	48 01 d0             	add    %rdx,%rax
  800b58:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b5b:	83 c2 08             	add    $0x8,%edx
  800b5e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b61:	eb 0f                	jmp    800b72 <vprintfmt+0x208>
  800b63:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b67:	48 89 d0             	mov    %rdx,%rax
  800b6a:	48 83 c2 08          	add    $0x8,%rdx
  800b6e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b72:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b74:	85 db                	test   %ebx,%ebx
  800b76:	79 02                	jns    800b7a <vprintfmt+0x210>
				err = -err;
  800b78:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b7a:	83 fb 15             	cmp    $0x15,%ebx
  800b7d:	7f 16                	jg     800b95 <vprintfmt+0x22b>
  800b7f:	48 b8 00 3e 80 00 00 	movabs $0x803e00,%rax
  800b86:	00 00 00 
  800b89:	48 63 d3             	movslq %ebx,%rdx
  800b8c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b90:	4d 85 e4             	test   %r12,%r12
  800b93:	75 2e                	jne    800bc3 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  800b95:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9d:	89 d9                	mov    %ebx,%ecx
  800b9f:	48 ba c1 3e 80 00 00 	movabs $0x803ec1,%rdx
  800ba6:	00 00 00 
  800ba9:	48 89 c7             	mov    %rax,%rdi
  800bac:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb1:	49 b8 c3 0e 80 00 00 	movabs $0x800ec3,%r8
  800bb8:	00 00 00 
  800bbb:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bbe:	e9 f1 02 00 00       	jmpq   800eb4 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bc3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bc7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bcb:	4c 89 e1             	mov    %r12,%rcx
  800bce:	48 ba ca 3e 80 00 00 	movabs $0x803eca,%rdx
  800bd5:	00 00 00 
  800bd8:	48 89 c7             	mov    %rax,%rdi
  800bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  800be0:	49 b8 c3 0e 80 00 00 	movabs $0x800ec3,%r8
  800be7:	00 00 00 
  800bea:	41 ff d0             	callq  *%r8
			break;
  800bed:	e9 c2 02 00 00       	jmpq   800eb4 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bf2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf5:	83 f8 30             	cmp    $0x30,%eax
  800bf8:	73 17                	jae    800c11 <vprintfmt+0x2a7>
  800bfa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bfe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c01:	89 c0                	mov    %eax,%eax
  800c03:	48 01 d0             	add    %rdx,%rax
  800c06:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c09:	83 c2 08             	add    $0x8,%edx
  800c0c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c0f:	eb 0f                	jmp    800c20 <vprintfmt+0x2b6>
  800c11:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c15:	48 89 d0             	mov    %rdx,%rax
  800c18:	48 83 c2 08          	add    $0x8,%rdx
  800c1c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c20:	4c 8b 20             	mov    (%rax),%r12
  800c23:	4d 85 e4             	test   %r12,%r12
  800c26:	75 0a                	jne    800c32 <vprintfmt+0x2c8>
				p = "(null)";
  800c28:	49 bc cd 3e 80 00 00 	movabs $0x803ecd,%r12
  800c2f:	00 00 00 
			if (width > 0 && padc != '-')
  800c32:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c36:	7e 3f                	jle    800c77 <vprintfmt+0x30d>
  800c38:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c3c:	74 39                	je     800c77 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c3e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c41:	48 98                	cltq   
  800c43:	48 89 c6             	mov    %rax,%rsi
  800c46:	4c 89 e7             	mov    %r12,%rdi
  800c49:	48 b8 6f 11 80 00 00 	movabs $0x80116f,%rax
  800c50:	00 00 00 
  800c53:	ff d0                	callq  *%rax
  800c55:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c58:	eb 17                	jmp    800c71 <vprintfmt+0x307>
					putch(padc, putdat);
  800c5a:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c5e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c66:	48 89 ce             	mov    %rcx,%rsi
  800c69:	89 d7                	mov    %edx,%edi
  800c6b:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c6d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c71:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c75:	7f e3                	jg     800c5a <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c77:	eb 37                	jmp    800cb0 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  800c79:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c7d:	74 1e                	je     800c9d <vprintfmt+0x333>
  800c7f:	83 fb 1f             	cmp    $0x1f,%ebx
  800c82:	7e 05                	jle    800c89 <vprintfmt+0x31f>
  800c84:	83 fb 7e             	cmp    $0x7e,%ebx
  800c87:	7e 14                	jle    800c9d <vprintfmt+0x333>
					putch('?', putdat);
  800c89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c91:	48 89 d6             	mov    %rdx,%rsi
  800c94:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c99:	ff d0                	callq  *%rax
  800c9b:	eb 0f                	jmp    800cac <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800c9d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca5:	48 89 d6             	mov    %rdx,%rsi
  800ca8:	89 df                	mov    %ebx,%edi
  800caa:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cac:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cb0:	4c 89 e0             	mov    %r12,%rax
  800cb3:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800cb7:	0f b6 00             	movzbl (%rax),%eax
  800cba:	0f be d8             	movsbl %al,%ebx
  800cbd:	85 db                	test   %ebx,%ebx
  800cbf:	74 10                	je     800cd1 <vprintfmt+0x367>
  800cc1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cc5:	78 b2                	js     800c79 <vprintfmt+0x30f>
  800cc7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ccb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ccf:	79 a8                	jns    800c79 <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cd1:	eb 16                	jmp    800ce9 <vprintfmt+0x37f>
				putch(' ', putdat);
  800cd3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cdb:	48 89 d6             	mov    %rdx,%rsi
  800cde:	bf 20 00 00 00       	mov    $0x20,%edi
  800ce3:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ce5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ce9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ced:	7f e4                	jg     800cd3 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800cef:	e9 c0 01 00 00       	jmpq   800eb4 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cf4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cf8:	be 03 00 00 00       	mov    $0x3,%esi
  800cfd:	48 89 c7             	mov    %rax,%rdi
  800d00:	48 b8 5a 08 80 00 00 	movabs $0x80085a,%rax
  800d07:	00 00 00 
  800d0a:	ff d0                	callq  *%rax
  800d0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d14:	48 85 c0             	test   %rax,%rax
  800d17:	79 1d                	jns    800d36 <vprintfmt+0x3cc>
				putch('-', putdat);
  800d19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d21:	48 89 d6             	mov    %rdx,%rsi
  800d24:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d29:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2f:	48 f7 d8             	neg    %rax
  800d32:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d36:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d3d:	e9 d5 00 00 00       	jmpq   800e17 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d42:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d46:	be 03 00 00 00       	mov    $0x3,%esi
  800d4b:	48 89 c7             	mov    %rax,%rdi
  800d4e:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800d55:	00 00 00 
  800d58:	ff d0                	callq  *%rax
  800d5a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d5e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d65:	e9 ad 00 00 00       	jmpq   800e17 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800d6a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d6e:	be 03 00 00 00       	mov    $0x3,%esi
  800d73:	48 89 c7             	mov    %rax,%rdi
  800d76:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800d7d:	00 00 00 
  800d80:	ff d0                	callq  *%rax
  800d82:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800d86:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d8d:	e9 85 00 00 00       	jmpq   800e17 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800d92:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9a:	48 89 d6             	mov    %rdx,%rsi
  800d9d:	bf 30 00 00 00       	mov    $0x30,%edi
  800da2:	ff d0                	callq  *%rax
			putch('x', putdat);
  800da4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800da8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dac:	48 89 d6             	mov    %rdx,%rsi
  800daf:	bf 78 00 00 00       	mov    $0x78,%edi
  800db4:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800db6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db9:	83 f8 30             	cmp    $0x30,%eax
  800dbc:	73 17                	jae    800dd5 <vprintfmt+0x46b>
  800dbe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dc2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dc5:	89 c0                	mov    %eax,%eax
  800dc7:	48 01 d0             	add    %rdx,%rax
  800dca:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dcd:	83 c2 08             	add    $0x8,%edx
  800dd0:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dd3:	eb 0f                	jmp    800de4 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  800dd5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dd9:	48 89 d0             	mov    %rdx,%rax
  800ddc:	48 83 c2 08          	add    $0x8,%rdx
  800de0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800de4:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800de7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800deb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800df2:	eb 23                	jmp    800e17 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800df4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800df8:	be 03 00 00 00       	mov    $0x3,%esi
  800dfd:	48 89 c7             	mov    %rax,%rdi
  800e00:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800e07:	00 00 00 
  800e0a:	ff d0                	callq  *%rax
  800e0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e10:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e17:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e1c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e1f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e26:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2e:	45 89 c1             	mov    %r8d,%r9d
  800e31:	41 89 f8             	mov    %edi,%r8d
  800e34:	48 89 c7             	mov    %rax,%rdi
  800e37:	48 b8 8f 06 80 00 00 	movabs $0x80068f,%rax
  800e3e:	00 00 00 
  800e41:	ff d0                	callq  *%rax
			break;
  800e43:	eb 6f                	jmp    800eb4 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e45:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e4d:	48 89 d6             	mov    %rdx,%rsi
  800e50:	89 df                	mov    %ebx,%edi
  800e52:	ff d0                	callq  *%rax
			break;
  800e54:	eb 5e                	jmp    800eb4 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  800e56:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e5a:	be 03 00 00 00       	mov    $0x3,%esi
  800e5f:	48 89 c7             	mov    %rax,%rdi
  800e62:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800e69:	00 00 00 
  800e6c:	ff d0                	callq  *%rax
  800e6e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  800e72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e76:	89 c2                	mov    %eax,%edx
  800e78:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800e7f:	00 00 00 
  800e82:	89 10                	mov    %edx,(%rax)
			break;
  800e84:	eb 2e                	jmp    800eb4 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e86:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e8e:	48 89 d6             	mov    %rdx,%rsi
  800e91:	bf 25 00 00 00       	mov    $0x25,%edi
  800e96:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e98:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e9d:	eb 05                	jmp    800ea4 <vprintfmt+0x53a>
  800e9f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ea4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ea8:	48 83 e8 01          	sub    $0x1,%rax
  800eac:	0f b6 00             	movzbl (%rax),%eax
  800eaf:	3c 25                	cmp    $0x25,%al
  800eb1:	75 ec                	jne    800e9f <vprintfmt+0x535>
				/* do nothing */;
			break;
  800eb3:	90                   	nop
		}
	}
  800eb4:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800eb5:	e9 13 fb ff ff       	jmpq   8009cd <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800eba:	48 83 c4 60          	add    $0x60,%rsp
  800ebe:	5b                   	pop    %rbx
  800ebf:	41 5c                	pop    %r12
  800ec1:	5d                   	pop    %rbp
  800ec2:	c3                   	retq   

0000000000800ec3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ec3:	55                   	push   %rbp
  800ec4:	48 89 e5             	mov    %rsp,%rbp
  800ec7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ece:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ed5:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800edc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ee3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800eea:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ef1:	84 c0                	test   %al,%al
  800ef3:	74 20                	je     800f15 <printfmt+0x52>
  800ef5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ef9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800efd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f01:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f05:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f09:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f0d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f11:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f15:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f1c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f23:	00 00 00 
  800f26:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f2d:	00 00 00 
  800f30:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f34:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f3b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f42:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f49:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f50:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f57:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f5e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f65:	48 89 c7             	mov    %rax,%rdi
  800f68:	48 b8 6a 09 80 00 00 	movabs $0x80096a,%rax
  800f6f:	00 00 00 
  800f72:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f74:	c9                   	leaveq 
  800f75:	c3                   	retq   

0000000000800f76 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f76:	55                   	push   %rbp
  800f77:	48 89 e5             	mov    %rsp,%rbp
  800f7a:	48 83 ec 10          	sub    $0x10,%rsp
  800f7e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f81:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f89:	8b 40 10             	mov    0x10(%rax),%eax
  800f8c:	8d 50 01             	lea    0x1(%rax),%edx
  800f8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f93:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f9a:	48 8b 10             	mov    (%rax),%rdx
  800f9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa1:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fa5:	48 39 c2             	cmp    %rax,%rdx
  800fa8:	73 17                	jae    800fc1 <sprintputch+0x4b>
		*b->buf++ = ch;
  800faa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fae:	48 8b 00             	mov    (%rax),%rax
  800fb1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fb5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fb9:	48 89 0a             	mov    %rcx,(%rdx)
  800fbc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fbf:	88 10                	mov    %dl,(%rax)
}
  800fc1:	c9                   	leaveq 
  800fc2:	c3                   	retq   

0000000000800fc3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fc3:	55                   	push   %rbp
  800fc4:	48 89 e5             	mov    %rsp,%rbp
  800fc7:	48 83 ec 50          	sub    $0x50,%rsp
  800fcb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800fcf:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800fd2:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800fd6:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800fda:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fde:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fe2:	48 8b 0a             	mov    (%rdx),%rcx
  800fe5:	48 89 08             	mov    %rcx,(%rax)
  800fe8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fec:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ff0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ff4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ff8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ffc:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801000:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801003:	48 98                	cltq   
  801005:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801009:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80100d:	48 01 d0             	add    %rdx,%rax
  801010:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801014:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80101b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801020:	74 06                	je     801028 <vsnprintf+0x65>
  801022:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801026:	7f 07                	jg     80102f <vsnprintf+0x6c>
		return -E_INVAL;
  801028:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80102d:	eb 2f                	jmp    80105e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80102f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801033:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801037:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80103b:	48 89 c6             	mov    %rax,%rsi
  80103e:	48 bf 76 0f 80 00 00 	movabs $0x800f76,%rdi
  801045:	00 00 00 
  801048:	48 b8 6a 09 80 00 00 	movabs $0x80096a,%rax
  80104f:	00 00 00 
  801052:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801054:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801058:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80105b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80105e:	c9                   	leaveq 
  80105f:	c3                   	retq   

0000000000801060 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801060:	55                   	push   %rbp
  801061:	48 89 e5             	mov    %rsp,%rbp
  801064:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80106b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801072:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801078:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80107f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801086:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80108d:	84 c0                	test   %al,%al
  80108f:	74 20                	je     8010b1 <snprintf+0x51>
  801091:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801095:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801099:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80109d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010a1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010a5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010a9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010ad:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010b1:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010b8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010bf:	00 00 00 
  8010c2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010c9:	00 00 00 
  8010cc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010d0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010d7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010de:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010e5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010ec:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010f3:	48 8b 0a             	mov    (%rdx),%rcx
  8010f6:	48 89 08             	mov    %rcx,(%rax)
  8010f9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010fd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801101:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801105:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801109:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801110:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801117:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80111d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801124:	48 89 c7             	mov    %rax,%rdi
  801127:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  80112e:	00 00 00 
  801131:	ff d0                	callq  *%rax
  801133:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801139:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80113f:	c9                   	leaveq 
  801140:	c3                   	retq   

0000000000801141 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801141:	55                   	push   %rbp
  801142:	48 89 e5             	mov    %rsp,%rbp
  801145:	48 83 ec 18          	sub    $0x18,%rsp
  801149:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80114d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801154:	eb 09                	jmp    80115f <strlen+0x1e>
		n++;
  801156:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80115a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80115f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801163:	0f b6 00             	movzbl (%rax),%eax
  801166:	84 c0                	test   %al,%al
  801168:	75 ec                	jne    801156 <strlen+0x15>
		n++;
	return n;
  80116a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80116d:	c9                   	leaveq 
  80116e:	c3                   	retq   

000000000080116f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80116f:	55                   	push   %rbp
  801170:	48 89 e5             	mov    %rsp,%rbp
  801173:	48 83 ec 20          	sub    $0x20,%rsp
  801177:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80117b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801186:	eb 0e                	jmp    801196 <strnlen+0x27>
		n++;
  801188:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80118c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801191:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801196:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80119b:	74 0b                	je     8011a8 <strnlen+0x39>
  80119d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a1:	0f b6 00             	movzbl (%rax),%eax
  8011a4:	84 c0                	test   %al,%al
  8011a6:	75 e0                	jne    801188 <strnlen+0x19>
		n++;
	return n;
  8011a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011ab:	c9                   	leaveq 
  8011ac:	c3                   	retq   

00000000008011ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011ad:	55                   	push   %rbp
  8011ae:	48 89 e5             	mov    %rsp,%rbp
  8011b1:	48 83 ec 20          	sub    $0x20,%rsp
  8011b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011c5:	90                   	nop
  8011c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011d2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011d6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011da:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011de:	0f b6 12             	movzbl (%rdx),%edx
  8011e1:	88 10                	mov    %dl,(%rax)
  8011e3:	0f b6 00             	movzbl (%rax),%eax
  8011e6:	84 c0                	test   %al,%al
  8011e8:	75 dc                	jne    8011c6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ee:	c9                   	leaveq 
  8011ef:	c3                   	retq   

00000000008011f0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011f0:	55                   	push   %rbp
  8011f1:	48 89 e5             	mov    %rsp,%rbp
  8011f4:	48 83 ec 20          	sub    $0x20,%rsp
  8011f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801200:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801204:	48 89 c7             	mov    %rax,%rdi
  801207:	48 b8 41 11 80 00 00 	movabs $0x801141,%rax
  80120e:	00 00 00 
  801211:	ff d0                	callq  *%rax
  801213:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801219:	48 63 d0             	movslq %eax,%rdx
  80121c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801220:	48 01 c2             	add    %rax,%rdx
  801223:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801227:	48 89 c6             	mov    %rax,%rsi
  80122a:	48 89 d7             	mov    %rdx,%rdi
  80122d:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  801234:	00 00 00 
  801237:	ff d0                	callq  *%rax
	return dst;
  801239:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80123d:	c9                   	leaveq 
  80123e:	c3                   	retq   

000000000080123f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80123f:	55                   	push   %rbp
  801240:	48 89 e5             	mov    %rsp,%rbp
  801243:	48 83 ec 28          	sub    $0x28,%rsp
  801247:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80124b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80124f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801257:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80125b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801262:	00 
  801263:	eb 2a                	jmp    80128f <strncpy+0x50>
		*dst++ = *src;
  801265:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801269:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80126d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801271:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801275:	0f b6 12             	movzbl (%rdx),%edx
  801278:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80127a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80127e:	0f b6 00             	movzbl (%rax),%eax
  801281:	84 c0                	test   %al,%al
  801283:	74 05                	je     80128a <strncpy+0x4b>
			src++;
  801285:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80128a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80128f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801293:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801297:	72 cc                	jb     801265 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801299:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80129d:	c9                   	leaveq 
  80129e:	c3                   	retq   

000000000080129f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80129f:	55                   	push   %rbp
  8012a0:	48 89 e5             	mov    %rsp,%rbp
  8012a3:	48 83 ec 28          	sub    $0x28,%rsp
  8012a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012bb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012c0:	74 3d                	je     8012ff <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012c2:	eb 1d                	jmp    8012e1 <strlcpy+0x42>
			*dst++ = *src++;
  8012c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012cc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012d0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012d4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012d8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012dc:	0f b6 12             	movzbl (%rdx),%edx
  8012df:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012e1:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012e6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012eb:	74 0b                	je     8012f8 <strlcpy+0x59>
  8012ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012f1:	0f b6 00             	movzbl (%rax),%eax
  8012f4:	84 c0                	test   %al,%al
  8012f6:	75 cc                	jne    8012c4 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fc:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801307:	48 29 c2             	sub    %rax,%rdx
  80130a:	48 89 d0             	mov    %rdx,%rax
}
  80130d:	c9                   	leaveq 
  80130e:	c3                   	retq   

000000000080130f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80130f:	55                   	push   %rbp
  801310:	48 89 e5             	mov    %rsp,%rbp
  801313:	48 83 ec 10          	sub    $0x10,%rsp
  801317:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80131f:	eb 0a                	jmp    80132b <strcmp+0x1c>
		p++, q++;
  801321:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801326:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80132b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132f:	0f b6 00             	movzbl (%rax),%eax
  801332:	84 c0                	test   %al,%al
  801334:	74 12                	je     801348 <strcmp+0x39>
  801336:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133a:	0f b6 10             	movzbl (%rax),%edx
  80133d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801341:	0f b6 00             	movzbl (%rax),%eax
  801344:	38 c2                	cmp    %al,%dl
  801346:	74 d9                	je     801321 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134c:	0f b6 00             	movzbl (%rax),%eax
  80134f:	0f b6 d0             	movzbl %al,%edx
  801352:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801356:	0f b6 00             	movzbl (%rax),%eax
  801359:	0f b6 c0             	movzbl %al,%eax
  80135c:	29 c2                	sub    %eax,%edx
  80135e:	89 d0                	mov    %edx,%eax
}
  801360:	c9                   	leaveq 
  801361:	c3                   	retq   

0000000000801362 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801362:	55                   	push   %rbp
  801363:	48 89 e5             	mov    %rsp,%rbp
  801366:	48 83 ec 18          	sub    $0x18,%rsp
  80136a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801372:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801376:	eb 0f                	jmp    801387 <strncmp+0x25>
		n--, p++, q++;
  801378:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80137d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801382:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801387:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80138c:	74 1d                	je     8013ab <strncmp+0x49>
  80138e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801392:	0f b6 00             	movzbl (%rax),%eax
  801395:	84 c0                	test   %al,%al
  801397:	74 12                	je     8013ab <strncmp+0x49>
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139d:	0f b6 10             	movzbl (%rax),%edx
  8013a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a4:	0f b6 00             	movzbl (%rax),%eax
  8013a7:	38 c2                	cmp    %al,%dl
  8013a9:	74 cd                	je     801378 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013ab:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013b0:	75 07                	jne    8013b9 <strncmp+0x57>
		return 0;
  8013b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b7:	eb 18                	jmp    8013d1 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bd:	0f b6 00             	movzbl (%rax),%eax
  8013c0:	0f b6 d0             	movzbl %al,%edx
  8013c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c7:	0f b6 00             	movzbl (%rax),%eax
  8013ca:	0f b6 c0             	movzbl %al,%eax
  8013cd:	29 c2                	sub    %eax,%edx
  8013cf:	89 d0                	mov    %edx,%eax
}
  8013d1:	c9                   	leaveq 
  8013d2:	c3                   	retq   

00000000008013d3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013d3:	55                   	push   %rbp
  8013d4:	48 89 e5             	mov    %rsp,%rbp
  8013d7:	48 83 ec 0c          	sub    $0xc,%rsp
  8013db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013df:	89 f0                	mov    %esi,%eax
  8013e1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013e4:	eb 17                	jmp    8013fd <strchr+0x2a>
		if (*s == c)
  8013e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ea:	0f b6 00             	movzbl (%rax),%eax
  8013ed:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013f0:	75 06                	jne    8013f8 <strchr+0x25>
			return (char *) s;
  8013f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f6:	eb 15                	jmp    80140d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013f8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801401:	0f b6 00             	movzbl (%rax),%eax
  801404:	84 c0                	test   %al,%al
  801406:	75 de                	jne    8013e6 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801408:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140d:	c9                   	leaveq 
  80140e:	c3                   	retq   

000000000080140f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80140f:	55                   	push   %rbp
  801410:	48 89 e5             	mov    %rsp,%rbp
  801413:	48 83 ec 0c          	sub    $0xc,%rsp
  801417:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80141b:	89 f0                	mov    %esi,%eax
  80141d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801420:	eb 13                	jmp    801435 <strfind+0x26>
		if (*s == c)
  801422:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801426:	0f b6 00             	movzbl (%rax),%eax
  801429:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80142c:	75 02                	jne    801430 <strfind+0x21>
			break;
  80142e:	eb 10                	jmp    801440 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801430:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801439:	0f b6 00             	movzbl (%rax),%eax
  80143c:	84 c0                	test   %al,%al
  80143e:	75 e2                	jne    801422 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801440:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801444:	c9                   	leaveq 
  801445:	c3                   	retq   

0000000000801446 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801446:	55                   	push   %rbp
  801447:	48 89 e5             	mov    %rsp,%rbp
  80144a:	48 83 ec 18          	sub    $0x18,%rsp
  80144e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801452:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801455:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801459:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80145e:	75 06                	jne    801466 <memset+0x20>
		return v;
  801460:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801464:	eb 69                	jmp    8014cf <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146a:	83 e0 03             	and    $0x3,%eax
  80146d:	48 85 c0             	test   %rax,%rax
  801470:	75 48                	jne    8014ba <memset+0x74>
  801472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801476:	83 e0 03             	and    $0x3,%eax
  801479:	48 85 c0             	test   %rax,%rax
  80147c:	75 3c                	jne    8014ba <memset+0x74>
		c &= 0xFF;
  80147e:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801485:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801488:	c1 e0 18             	shl    $0x18,%eax
  80148b:	89 c2                	mov    %eax,%edx
  80148d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801490:	c1 e0 10             	shl    $0x10,%eax
  801493:	09 c2                	or     %eax,%edx
  801495:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801498:	c1 e0 08             	shl    $0x8,%eax
  80149b:	09 d0                	or     %edx,%eax
  80149d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a4:	48 c1 e8 02          	shr    $0x2,%rax
  8014a8:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014b2:	48 89 d7             	mov    %rdx,%rdi
  8014b5:	fc                   	cld    
  8014b6:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014b8:	eb 11                	jmp    8014cb <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014ba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014c1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014c5:	48 89 d7             	mov    %rdx,%rdi
  8014c8:	fc                   	cld    
  8014c9:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014cf:	c9                   	leaveq 
  8014d0:	c3                   	retq   

00000000008014d1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014d1:	55                   	push   %rbp
  8014d2:	48 89 e5             	mov    %rsp,%rbp
  8014d5:	48 83 ec 28          	sub    $0x28,%rsp
  8014d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014fd:	0f 83 88 00 00 00    	jae    80158b <memmove+0xba>
  801503:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801507:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150b:	48 01 d0             	add    %rdx,%rax
  80150e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801512:	76 77                	jbe    80158b <memmove+0xba>
		s += n;
  801514:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801518:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80151c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801520:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801524:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801528:	83 e0 03             	and    $0x3,%eax
  80152b:	48 85 c0             	test   %rax,%rax
  80152e:	75 3b                	jne    80156b <memmove+0x9a>
  801530:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801534:	83 e0 03             	and    $0x3,%eax
  801537:	48 85 c0             	test   %rax,%rax
  80153a:	75 2f                	jne    80156b <memmove+0x9a>
  80153c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801540:	83 e0 03             	and    $0x3,%eax
  801543:	48 85 c0             	test   %rax,%rax
  801546:	75 23                	jne    80156b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801548:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154c:	48 83 e8 04          	sub    $0x4,%rax
  801550:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801554:	48 83 ea 04          	sub    $0x4,%rdx
  801558:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80155c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801560:	48 89 c7             	mov    %rax,%rdi
  801563:	48 89 d6             	mov    %rdx,%rsi
  801566:	fd                   	std    
  801567:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801569:	eb 1d                	jmp    801588 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80156b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801573:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801577:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80157b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157f:	48 89 d7             	mov    %rdx,%rdi
  801582:	48 89 c1             	mov    %rax,%rcx
  801585:	fd                   	std    
  801586:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801588:	fc                   	cld    
  801589:	eb 57                	jmp    8015e2 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80158b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158f:	83 e0 03             	and    $0x3,%eax
  801592:	48 85 c0             	test   %rax,%rax
  801595:	75 36                	jne    8015cd <memmove+0xfc>
  801597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159b:	83 e0 03             	and    $0x3,%eax
  80159e:	48 85 c0             	test   %rax,%rax
  8015a1:	75 2a                	jne    8015cd <memmove+0xfc>
  8015a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a7:	83 e0 03             	and    $0x3,%eax
  8015aa:	48 85 c0             	test   %rax,%rax
  8015ad:	75 1e                	jne    8015cd <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b3:	48 c1 e8 02          	shr    $0x2,%rax
  8015b7:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015c2:	48 89 c7             	mov    %rax,%rdi
  8015c5:	48 89 d6             	mov    %rdx,%rsi
  8015c8:	fc                   	cld    
  8015c9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015cb:	eb 15                	jmp    8015e2 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015d5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015d9:	48 89 c7             	mov    %rax,%rdi
  8015dc:	48 89 d6             	mov    %rdx,%rsi
  8015df:	fc                   	cld    
  8015e0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015e6:	c9                   	leaveq 
  8015e7:	c3                   	retq   

00000000008015e8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015e8:	55                   	push   %rbp
  8015e9:	48 89 e5             	mov    %rsp,%rbp
  8015ec:	48 83 ec 18          	sub    $0x18,%rsp
  8015f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015f8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801600:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801604:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801608:	48 89 ce             	mov    %rcx,%rsi
  80160b:	48 89 c7             	mov    %rax,%rdi
  80160e:	48 b8 d1 14 80 00 00 	movabs $0x8014d1,%rax
  801615:	00 00 00 
  801618:	ff d0                	callq  *%rax
}
  80161a:	c9                   	leaveq 
  80161b:	c3                   	retq   

000000000080161c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80161c:	55                   	push   %rbp
  80161d:	48 89 e5             	mov    %rsp,%rbp
  801620:	48 83 ec 28          	sub    $0x28,%rsp
  801624:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801628:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80162c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801634:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801638:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80163c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801640:	eb 36                	jmp    801678 <memcmp+0x5c>
		if (*s1 != *s2)
  801642:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801646:	0f b6 10             	movzbl (%rax),%edx
  801649:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164d:	0f b6 00             	movzbl (%rax),%eax
  801650:	38 c2                	cmp    %al,%dl
  801652:	74 1a                	je     80166e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801654:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801658:	0f b6 00             	movzbl (%rax),%eax
  80165b:	0f b6 d0             	movzbl %al,%edx
  80165e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	0f b6 c0             	movzbl %al,%eax
  801668:	29 c2                	sub    %eax,%edx
  80166a:	89 d0                	mov    %edx,%eax
  80166c:	eb 20                	jmp    80168e <memcmp+0x72>
		s1++, s2++;
  80166e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801673:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801680:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801684:	48 85 c0             	test   %rax,%rax
  801687:	75 b9                	jne    801642 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801689:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168e:	c9                   	leaveq 
  80168f:	c3                   	retq   

0000000000801690 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801690:	55                   	push   %rbp
  801691:	48 89 e5             	mov    %rsp,%rbp
  801694:	48 83 ec 28          	sub    $0x28,%rsp
  801698:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80169c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80169f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ab:	48 01 d0             	add    %rdx,%rax
  8016ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016b2:	eb 15                	jmp    8016c9 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b8:	0f b6 10             	movzbl (%rax),%edx
  8016bb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016be:	38 c2                	cmp    %al,%dl
  8016c0:	75 02                	jne    8016c4 <memfind+0x34>
			break;
  8016c2:	eb 0f                	jmp    8016d3 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016c4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016cd:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016d1:	72 e1                	jb     8016b4 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8016d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016d7:	c9                   	leaveq 
  8016d8:	c3                   	retq   

00000000008016d9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016d9:	55                   	push   %rbp
  8016da:	48 89 e5             	mov    %rsp,%rbp
  8016dd:	48 83 ec 34          	sub    $0x34,%rsp
  8016e1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016e9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016f3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016fa:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016fb:	eb 05                	jmp    801702 <strtol+0x29>
		s++;
  8016fd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801702:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801706:	0f b6 00             	movzbl (%rax),%eax
  801709:	3c 20                	cmp    $0x20,%al
  80170b:	74 f0                	je     8016fd <strtol+0x24>
  80170d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801711:	0f b6 00             	movzbl (%rax),%eax
  801714:	3c 09                	cmp    $0x9,%al
  801716:	74 e5                	je     8016fd <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801718:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171c:	0f b6 00             	movzbl (%rax),%eax
  80171f:	3c 2b                	cmp    $0x2b,%al
  801721:	75 07                	jne    80172a <strtol+0x51>
		s++;
  801723:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801728:	eb 17                	jmp    801741 <strtol+0x68>
	else if (*s == '-')
  80172a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172e:	0f b6 00             	movzbl (%rax),%eax
  801731:	3c 2d                	cmp    $0x2d,%al
  801733:	75 0c                	jne    801741 <strtol+0x68>
		s++, neg = 1;
  801735:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80173a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801741:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801745:	74 06                	je     80174d <strtol+0x74>
  801747:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80174b:	75 28                	jne    801775 <strtol+0x9c>
  80174d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801751:	0f b6 00             	movzbl (%rax),%eax
  801754:	3c 30                	cmp    $0x30,%al
  801756:	75 1d                	jne    801775 <strtol+0x9c>
  801758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175c:	48 83 c0 01          	add    $0x1,%rax
  801760:	0f b6 00             	movzbl (%rax),%eax
  801763:	3c 78                	cmp    $0x78,%al
  801765:	75 0e                	jne    801775 <strtol+0x9c>
		s += 2, base = 16;
  801767:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80176c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801773:	eb 2c                	jmp    8017a1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801775:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801779:	75 19                	jne    801794 <strtol+0xbb>
  80177b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177f:	0f b6 00             	movzbl (%rax),%eax
  801782:	3c 30                	cmp    $0x30,%al
  801784:	75 0e                	jne    801794 <strtol+0xbb>
		s++, base = 8;
  801786:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80178b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801792:	eb 0d                	jmp    8017a1 <strtol+0xc8>
	else if (base == 0)
  801794:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801798:	75 07                	jne    8017a1 <strtol+0xc8>
		base = 10;
  80179a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a5:	0f b6 00             	movzbl (%rax),%eax
  8017a8:	3c 2f                	cmp    $0x2f,%al
  8017aa:	7e 1d                	jle    8017c9 <strtol+0xf0>
  8017ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b0:	0f b6 00             	movzbl (%rax),%eax
  8017b3:	3c 39                	cmp    $0x39,%al
  8017b5:	7f 12                	jg     8017c9 <strtol+0xf0>
			dig = *s - '0';
  8017b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bb:	0f b6 00             	movzbl (%rax),%eax
  8017be:	0f be c0             	movsbl %al,%eax
  8017c1:	83 e8 30             	sub    $0x30,%eax
  8017c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017c7:	eb 4e                	jmp    801817 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cd:	0f b6 00             	movzbl (%rax),%eax
  8017d0:	3c 60                	cmp    $0x60,%al
  8017d2:	7e 1d                	jle    8017f1 <strtol+0x118>
  8017d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d8:	0f b6 00             	movzbl (%rax),%eax
  8017db:	3c 7a                	cmp    $0x7a,%al
  8017dd:	7f 12                	jg     8017f1 <strtol+0x118>
			dig = *s - 'a' + 10;
  8017df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e3:	0f b6 00             	movzbl (%rax),%eax
  8017e6:	0f be c0             	movsbl %al,%eax
  8017e9:	83 e8 57             	sub    $0x57,%eax
  8017ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017ef:	eb 26                	jmp    801817 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f5:	0f b6 00             	movzbl (%rax),%eax
  8017f8:	3c 40                	cmp    $0x40,%al
  8017fa:	7e 48                	jle    801844 <strtol+0x16b>
  8017fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801800:	0f b6 00             	movzbl (%rax),%eax
  801803:	3c 5a                	cmp    $0x5a,%al
  801805:	7f 3d                	jg     801844 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801807:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180b:	0f b6 00             	movzbl (%rax),%eax
  80180e:	0f be c0             	movsbl %al,%eax
  801811:	83 e8 37             	sub    $0x37,%eax
  801814:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801817:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80181a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80181d:	7c 02                	jl     801821 <strtol+0x148>
			break;
  80181f:	eb 23                	jmp    801844 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801821:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801826:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801829:	48 98                	cltq   
  80182b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801830:	48 89 c2             	mov    %rax,%rdx
  801833:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801836:	48 98                	cltq   
  801838:	48 01 d0             	add    %rdx,%rax
  80183b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80183f:	e9 5d ff ff ff       	jmpq   8017a1 <strtol+0xc8>

	if (endptr)
  801844:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801849:	74 0b                	je     801856 <strtol+0x17d>
		*endptr = (char *) s;
  80184b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80184f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801853:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801856:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80185a:	74 09                	je     801865 <strtol+0x18c>
  80185c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801860:	48 f7 d8             	neg    %rax
  801863:	eb 04                	jmp    801869 <strtol+0x190>
  801865:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801869:	c9                   	leaveq 
  80186a:	c3                   	retq   

000000000080186b <strstr>:

char * strstr(const char *in, const char *str)
{
  80186b:	55                   	push   %rbp
  80186c:	48 89 e5             	mov    %rsp,%rbp
  80186f:	48 83 ec 30          	sub    $0x30,%rsp
  801873:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801877:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80187b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80187f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801883:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801887:	0f b6 00             	movzbl (%rax),%eax
  80188a:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80188d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801891:	75 06                	jne    801899 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801897:	eb 6b                	jmp    801904 <strstr+0x99>

	len = strlen(str);
  801899:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80189d:	48 89 c7             	mov    %rax,%rdi
  8018a0:	48 b8 41 11 80 00 00 	movabs $0x801141,%rax
  8018a7:	00 00 00 
  8018aa:	ff d0                	callq  *%rax
  8018ac:	48 98                	cltq   
  8018ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018be:	0f b6 00             	movzbl (%rax),%eax
  8018c1:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018c4:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018c8:	75 07                	jne    8018d1 <strstr+0x66>
				return (char *) 0;
  8018ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cf:	eb 33                	jmp    801904 <strstr+0x99>
		} while (sc != c);
  8018d1:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018d5:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018d8:	75 d8                	jne    8018b2 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8018da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018de:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e6:	48 89 ce             	mov    %rcx,%rsi
  8018e9:	48 89 c7             	mov    %rax,%rdi
  8018ec:	48 b8 62 13 80 00 00 	movabs $0x801362,%rax
  8018f3:	00 00 00 
  8018f6:	ff d0                	callq  *%rax
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	75 b6                	jne    8018b2 <strstr+0x47>

	return (char *) (in - 1);
  8018fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801900:	48 83 e8 01          	sub    $0x1,%rax
}
  801904:	c9                   	leaveq 
  801905:	c3                   	retq   

0000000000801906 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801906:	55                   	push   %rbp
  801907:	48 89 e5             	mov    %rsp,%rbp
  80190a:	53                   	push   %rbx
  80190b:	48 83 ec 48          	sub    $0x48,%rsp
  80190f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801912:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801915:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801919:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80191d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801921:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801925:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801928:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80192c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801930:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801934:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801938:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80193c:	4c 89 c3             	mov    %r8,%rbx
  80193f:	cd 30                	int    $0x30
  801941:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801945:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801949:	74 3e                	je     801989 <syscall+0x83>
  80194b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801950:	7e 37                	jle    801989 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801952:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801956:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801959:	49 89 d0             	mov    %rdx,%r8
  80195c:	89 c1                	mov    %eax,%ecx
  80195e:	48 ba 88 41 80 00 00 	movabs $0x804188,%rdx
  801965:	00 00 00 
  801968:	be 23 00 00 00       	mov    $0x23,%esi
  80196d:	48 bf a5 41 80 00 00 	movabs $0x8041a5,%rdi
  801974:	00 00 00 
  801977:	b8 00 00 00 00       	mov    $0x0,%eax
  80197c:	49 b9 7e 03 80 00 00 	movabs $0x80037e,%r9
  801983:	00 00 00 
  801986:	41 ff d1             	callq  *%r9

	return ret;
  801989:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80198d:	48 83 c4 48          	add    $0x48,%rsp
  801991:	5b                   	pop    %rbx
  801992:	5d                   	pop    %rbp
  801993:	c3                   	retq   

0000000000801994 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801994:	55                   	push   %rbp
  801995:	48 89 e5             	mov    %rsp,%rbp
  801998:	48 83 ec 20          	sub    $0x20,%rsp
  80199c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b3:	00 
  8019b4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c0:	48 89 d1             	mov    %rdx,%rcx
  8019c3:	48 89 c2             	mov    %rax,%rdx
  8019c6:	be 00 00 00 00       	mov    $0x0,%esi
  8019cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8019d0:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  8019d7:	00 00 00 
  8019da:	ff d0                	callq  *%rax
}
  8019dc:	c9                   	leaveq 
  8019dd:	c3                   	retq   

00000000008019de <sys_cgetc>:

int
sys_cgetc(void)
{
  8019de:	55                   	push   %rbp
  8019df:	48 89 e5             	mov    %rsp,%rbp
  8019e2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019e6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ed:	00 
  8019ee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801a04:	be 00 00 00 00       	mov    $0x0,%esi
  801a09:	bf 01 00 00 00       	mov    $0x1,%edi
  801a0e:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801a15:	00 00 00 
  801a18:	ff d0                	callq  *%rax
}
  801a1a:	c9                   	leaveq 
  801a1b:	c3                   	retq   

0000000000801a1c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a1c:	55                   	push   %rbp
  801a1d:	48 89 e5             	mov    %rsp,%rbp
  801a20:	48 83 ec 10          	sub    $0x10,%rsp
  801a24:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a2a:	48 98                	cltq   
  801a2c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a33:	00 
  801a34:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a40:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a45:	48 89 c2             	mov    %rax,%rdx
  801a48:	be 01 00 00 00       	mov    $0x1,%esi
  801a4d:	bf 03 00 00 00       	mov    $0x3,%edi
  801a52:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801a59:	00 00 00 
  801a5c:	ff d0                	callq  *%rax
}
  801a5e:	c9                   	leaveq 
  801a5f:	c3                   	retq   

0000000000801a60 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a60:	55                   	push   %rbp
  801a61:	48 89 e5             	mov    %rsp,%rbp
  801a64:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a68:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a6f:	00 
  801a70:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a76:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a81:	ba 00 00 00 00       	mov    $0x0,%edx
  801a86:	be 00 00 00 00       	mov    $0x0,%esi
  801a8b:	bf 02 00 00 00       	mov    $0x2,%edi
  801a90:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801a97:	00 00 00 
  801a9a:	ff d0                	callq  *%rax
}
  801a9c:	c9                   	leaveq 
  801a9d:	c3                   	retq   

0000000000801a9e <sys_yield>:

void
sys_yield(void)
{
  801a9e:	55                   	push   %rbp
  801a9f:	48 89 e5             	mov    %rsp,%rbp
  801aa2:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801aa6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aad:	00 
  801aae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aba:	b9 00 00 00 00       	mov    $0x0,%ecx
  801abf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac4:	be 00 00 00 00       	mov    $0x0,%esi
  801ac9:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ace:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801ad5:	00 00 00 
  801ad8:	ff d0                	callq  *%rax
}
  801ada:	c9                   	leaveq 
  801adb:	c3                   	retq   

0000000000801adc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801adc:	55                   	push   %rbp
  801add:	48 89 e5             	mov    %rsp,%rbp
  801ae0:	48 83 ec 20          	sub    $0x20,%rsp
  801ae4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aeb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801aee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801af1:	48 63 c8             	movslq %eax,%rcx
  801af4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801afb:	48 98                	cltq   
  801afd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b04:	00 
  801b05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0b:	49 89 c8             	mov    %rcx,%r8
  801b0e:	48 89 d1             	mov    %rdx,%rcx
  801b11:	48 89 c2             	mov    %rax,%rdx
  801b14:	be 01 00 00 00       	mov    $0x1,%esi
  801b19:	bf 04 00 00 00       	mov    $0x4,%edi
  801b1e:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801b25:	00 00 00 
  801b28:	ff d0                	callq  *%rax
}
  801b2a:	c9                   	leaveq 
  801b2b:	c3                   	retq   

0000000000801b2c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b2c:	55                   	push   %rbp
  801b2d:	48 89 e5             	mov    %rsp,%rbp
  801b30:	48 83 ec 30          	sub    $0x30,%rsp
  801b34:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b37:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b3b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b3e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b42:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b46:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b49:	48 63 c8             	movslq %eax,%rcx
  801b4c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b50:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b53:	48 63 f0             	movslq %eax,%rsi
  801b56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5d:	48 98                	cltq   
  801b5f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b63:	49 89 f9             	mov    %rdi,%r9
  801b66:	49 89 f0             	mov    %rsi,%r8
  801b69:	48 89 d1             	mov    %rdx,%rcx
  801b6c:	48 89 c2             	mov    %rax,%rdx
  801b6f:	be 01 00 00 00       	mov    $0x1,%esi
  801b74:	bf 05 00 00 00       	mov    $0x5,%edi
  801b79:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801b80:	00 00 00 
  801b83:	ff d0                	callq  *%rax
}
  801b85:	c9                   	leaveq 
  801b86:	c3                   	retq   

0000000000801b87 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b87:	55                   	push   %rbp
  801b88:	48 89 e5             	mov    %rsp,%rbp
  801b8b:	48 83 ec 20          	sub    $0x20,%rsp
  801b8f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b92:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b96:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b9d:	48 98                	cltq   
  801b9f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ba6:	00 
  801ba7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb3:	48 89 d1             	mov    %rdx,%rcx
  801bb6:	48 89 c2             	mov    %rax,%rdx
  801bb9:	be 01 00 00 00       	mov    $0x1,%esi
  801bbe:	bf 06 00 00 00       	mov    $0x6,%edi
  801bc3:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801bca:	00 00 00 
  801bcd:	ff d0                	callq  *%rax
}
  801bcf:	c9                   	leaveq 
  801bd0:	c3                   	retq   

0000000000801bd1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801bd1:	55                   	push   %rbp
  801bd2:	48 89 e5             	mov    %rsp,%rbp
  801bd5:	48 83 ec 10          	sub    $0x10,%rsp
  801bd9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bdc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801bdf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801be2:	48 63 d0             	movslq %eax,%rdx
  801be5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be8:	48 98                	cltq   
  801bea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf1:	00 
  801bf2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bfe:	48 89 d1             	mov    %rdx,%rcx
  801c01:	48 89 c2             	mov    %rax,%rdx
  801c04:	be 01 00 00 00       	mov    $0x1,%esi
  801c09:	bf 08 00 00 00       	mov    $0x8,%edi
  801c0e:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801c15:	00 00 00 
  801c18:	ff d0                	callq  *%rax
}
  801c1a:	c9                   	leaveq 
  801c1b:	c3                   	retq   

0000000000801c1c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c1c:	55                   	push   %rbp
  801c1d:	48 89 e5             	mov    %rsp,%rbp
  801c20:	48 83 ec 20          	sub    $0x20,%rsp
  801c24:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c27:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c2b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c32:	48 98                	cltq   
  801c34:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c3b:	00 
  801c3c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c42:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c48:	48 89 d1             	mov    %rdx,%rcx
  801c4b:	48 89 c2             	mov    %rax,%rdx
  801c4e:	be 01 00 00 00       	mov    $0x1,%esi
  801c53:	bf 09 00 00 00       	mov    $0x9,%edi
  801c58:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801c5f:	00 00 00 
  801c62:	ff d0                	callq  *%rax
}
  801c64:	c9                   	leaveq 
  801c65:	c3                   	retq   

0000000000801c66 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c66:	55                   	push   %rbp
  801c67:	48 89 e5             	mov    %rsp,%rbp
  801c6a:	48 83 ec 20          	sub    $0x20,%rsp
  801c6e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c71:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c7c:	48 98                	cltq   
  801c7e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c85:	00 
  801c86:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c8c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c92:	48 89 d1             	mov    %rdx,%rcx
  801c95:	48 89 c2             	mov    %rax,%rdx
  801c98:	be 01 00 00 00       	mov    $0x1,%esi
  801c9d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ca2:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801ca9:	00 00 00 
  801cac:	ff d0                	callq  *%rax
}
  801cae:	c9                   	leaveq 
  801caf:	c3                   	retq   

0000000000801cb0 <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801cb0:	55                   	push   %rbp
  801cb1:	48 89 e5             	mov    %rsp,%rbp
  801cb4:	48 83 ec 10          	sub    $0x10,%rsp
  801cb8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cbb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801cbe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cc1:	48 63 d0             	movslq %eax,%rdx
  801cc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc7:	48 98                	cltq   
  801cc9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd0:	00 
  801cd1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cdd:	48 89 d1             	mov    %rdx,%rcx
  801ce0:	48 89 c2             	mov    %rax,%rdx
  801ce3:	be 01 00 00 00       	mov    $0x1,%esi
  801ce8:	bf 11 00 00 00       	mov    $0x11,%edi
  801ced:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801cf4:	00 00 00 
  801cf7:	ff d0                	callq  *%rax

}
  801cf9:	c9                   	leaveq 
  801cfa:	c3                   	retq   

0000000000801cfb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801cfb:	55                   	push   %rbp
  801cfc:	48 89 e5             	mov    %rsp,%rbp
  801cff:	48 83 ec 20          	sub    $0x20,%rsp
  801d03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d0a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d0e:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d11:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d14:	48 63 f0             	movslq %eax,%rsi
  801d17:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1e:	48 98                	cltq   
  801d20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d24:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d2b:	00 
  801d2c:	49 89 f1             	mov    %rsi,%r9
  801d2f:	49 89 c8             	mov    %rcx,%r8
  801d32:	48 89 d1             	mov    %rdx,%rcx
  801d35:	48 89 c2             	mov    %rax,%rdx
  801d38:	be 00 00 00 00       	mov    $0x0,%esi
  801d3d:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d42:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801d49:	00 00 00 
  801d4c:	ff d0                	callq  *%rax
}
  801d4e:	c9                   	leaveq 
  801d4f:	c3                   	retq   

0000000000801d50 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d50:	55                   	push   %rbp
  801d51:	48 89 e5             	mov    %rsp,%rbp
  801d54:	48 83 ec 10          	sub    $0x10,%rsp
  801d58:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d60:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d67:	00 
  801d68:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d6e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d74:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d79:	48 89 c2             	mov    %rax,%rdx
  801d7c:	be 01 00 00 00       	mov    $0x1,%esi
  801d81:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d86:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801d8d:	00 00 00 
  801d90:	ff d0                	callq  *%rax
}
  801d92:	c9                   	leaveq 
  801d93:	c3                   	retq   

0000000000801d94 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d94:	55                   	push   %rbp
  801d95:	48 89 e5             	mov    %rsp,%rbp
  801d98:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d9c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801da3:	00 
  801da4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801daa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801db5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dba:	be 00 00 00 00       	mov    $0x0,%esi
  801dbf:	bf 0e 00 00 00       	mov    $0xe,%edi
  801dc4:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801dcb:	00 00 00 
  801dce:	ff d0                	callq  *%rax
}
  801dd0:	c9                   	leaveq 
  801dd1:	c3                   	retq   

0000000000801dd2 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801dd2:	55                   	push   %rbp
  801dd3:	48 89 e5             	mov    %rsp,%rbp
  801dd6:	48 83 ec 30          	sub    $0x30,%rsp
  801dda:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ddd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801de1:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801de4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801de8:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801dec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801def:	48 63 c8             	movslq %eax,%rcx
  801df2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801df6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801df9:	48 63 f0             	movslq %eax,%rsi
  801dfc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e03:	48 98                	cltq   
  801e05:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e09:	49 89 f9             	mov    %rdi,%r9
  801e0c:	49 89 f0             	mov    %rsi,%r8
  801e0f:	48 89 d1             	mov    %rdx,%rcx
  801e12:	48 89 c2             	mov    %rax,%rdx
  801e15:	be 00 00 00 00       	mov    $0x0,%esi
  801e1a:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e1f:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801e26:	00 00 00 
  801e29:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e2b:	c9                   	leaveq 
  801e2c:	c3                   	retq   

0000000000801e2d <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e2d:	55                   	push   %rbp
  801e2e:	48 89 e5             	mov    %rsp,%rbp
  801e31:	48 83 ec 20          	sub    $0x20,%rsp
  801e35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e4c:	00 
  801e4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e59:	48 89 d1             	mov    %rdx,%rcx
  801e5c:	48 89 c2             	mov    %rax,%rdx
  801e5f:	be 00 00 00 00       	mov    $0x0,%esi
  801e64:	bf 10 00 00 00       	mov    $0x10,%edi
  801e69:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801e70:	00 00 00 
  801e73:	ff d0                	callq  *%rax
}
  801e75:	c9                   	leaveq 
  801e76:	c3                   	retq   

0000000000801e77 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e77:	55                   	push   %rbp
  801e78:	48 89 e5             	mov    %rsp,%rbp
  801e7b:	48 83 ec 08          	sub    $0x8,%rsp
  801e7f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e83:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e87:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e8e:	ff ff ff 
  801e91:	48 01 d0             	add    %rdx,%rax
  801e94:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e98:	c9                   	leaveq 
  801e99:	c3                   	retq   

0000000000801e9a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e9a:	55                   	push   %rbp
  801e9b:	48 89 e5             	mov    %rsp,%rbp
  801e9e:	48 83 ec 08          	sub    $0x8,%rsp
  801ea2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ea6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eaa:	48 89 c7             	mov    %rax,%rdi
  801ead:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  801eb4:	00 00 00 
  801eb7:	ff d0                	callq  *%rax
  801eb9:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ebf:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ec3:	c9                   	leaveq 
  801ec4:	c3                   	retq   

0000000000801ec5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ec5:	55                   	push   %rbp
  801ec6:	48 89 e5             	mov    %rsp,%rbp
  801ec9:	48 83 ec 18          	sub    $0x18,%rsp
  801ecd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ed1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ed8:	eb 6b                	jmp    801f45 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801eda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801edd:	48 98                	cltq   
  801edf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ee5:	48 c1 e0 0c          	shl    $0xc,%rax
  801ee9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801eed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef1:	48 c1 e8 15          	shr    $0x15,%rax
  801ef5:	48 89 c2             	mov    %rax,%rdx
  801ef8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801eff:	01 00 00 
  801f02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f06:	83 e0 01             	and    $0x1,%eax
  801f09:	48 85 c0             	test   %rax,%rax
  801f0c:	74 21                	je     801f2f <fd_alloc+0x6a>
  801f0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f12:	48 c1 e8 0c          	shr    $0xc,%rax
  801f16:	48 89 c2             	mov    %rax,%rdx
  801f19:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f20:	01 00 00 
  801f23:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f27:	83 e0 01             	and    $0x1,%eax
  801f2a:	48 85 c0             	test   %rax,%rax
  801f2d:	75 12                	jne    801f41 <fd_alloc+0x7c>
			*fd_store = fd;
  801f2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f37:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3f:	eb 1a                	jmp    801f5b <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f41:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f45:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f49:	7e 8f                	jle    801eda <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f56:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f5b:	c9                   	leaveq 
  801f5c:	c3                   	retq   

0000000000801f5d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f5d:	55                   	push   %rbp
  801f5e:	48 89 e5             	mov    %rsp,%rbp
  801f61:	48 83 ec 20          	sub    $0x20,%rsp
  801f65:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f68:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f70:	78 06                	js     801f78 <fd_lookup+0x1b>
  801f72:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f76:	7e 07                	jle    801f7f <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f7d:	eb 6c                	jmp    801feb <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f7f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f82:	48 98                	cltq   
  801f84:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f8a:	48 c1 e0 0c          	shl    $0xc,%rax
  801f8e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f96:	48 c1 e8 15          	shr    $0x15,%rax
  801f9a:	48 89 c2             	mov    %rax,%rdx
  801f9d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fa4:	01 00 00 
  801fa7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fab:	83 e0 01             	and    $0x1,%eax
  801fae:	48 85 c0             	test   %rax,%rax
  801fb1:	74 21                	je     801fd4 <fd_lookup+0x77>
  801fb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb7:	48 c1 e8 0c          	shr    $0xc,%rax
  801fbb:	48 89 c2             	mov    %rax,%rdx
  801fbe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc5:	01 00 00 
  801fc8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fcc:	83 e0 01             	and    $0x1,%eax
  801fcf:	48 85 c0             	test   %rax,%rax
  801fd2:	75 07                	jne    801fdb <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fd4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fd9:	eb 10                	jmp    801feb <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fdb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fdf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fe3:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801feb:	c9                   	leaveq 
  801fec:	c3                   	retq   

0000000000801fed <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801fed:	55                   	push   %rbp
  801fee:	48 89 e5             	mov    %rsp,%rbp
  801ff1:	48 83 ec 30          	sub    $0x30,%rsp
  801ff5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ff9:	89 f0                	mov    %esi,%eax
  801ffb:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ffe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802002:	48 89 c7             	mov    %rax,%rdi
  802005:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  80200c:	00 00 00 
  80200f:	ff d0                	callq  *%rax
  802011:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802015:	48 89 d6             	mov    %rdx,%rsi
  802018:	89 c7                	mov    %eax,%edi
  80201a:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  802021:	00 00 00 
  802024:	ff d0                	callq  *%rax
  802026:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802029:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80202d:	78 0a                	js     802039 <fd_close+0x4c>
	    || fd != fd2)
  80202f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802033:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802037:	74 12                	je     80204b <fd_close+0x5e>
		return (must_exist ? r : 0);
  802039:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80203d:	74 05                	je     802044 <fd_close+0x57>
  80203f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802042:	eb 05                	jmp    802049 <fd_close+0x5c>
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
  802049:	eb 69                	jmp    8020b4 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80204b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204f:	8b 00                	mov    (%rax),%eax
  802051:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802055:	48 89 d6             	mov    %rdx,%rsi
  802058:	89 c7                	mov    %eax,%edi
  80205a:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  802061:	00 00 00 
  802064:	ff d0                	callq  *%rax
  802066:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802069:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80206d:	78 2a                	js     802099 <fd_close+0xac>
		if (dev->dev_close)
  80206f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802073:	48 8b 40 20          	mov    0x20(%rax),%rax
  802077:	48 85 c0             	test   %rax,%rax
  80207a:	74 16                	je     802092 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80207c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802080:	48 8b 40 20          	mov    0x20(%rax),%rax
  802084:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802088:	48 89 d7             	mov    %rdx,%rdi
  80208b:	ff d0                	callq  *%rax
  80208d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802090:	eb 07                	jmp    802099 <fd_close+0xac>
		else
			r = 0;
  802092:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802099:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80209d:	48 89 c6             	mov    %rax,%rsi
  8020a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a5:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  8020ac:	00 00 00 
  8020af:	ff d0                	callq  *%rax
	return r;
  8020b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020b4:	c9                   	leaveq 
  8020b5:	c3                   	retq   

00000000008020b6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020b6:	55                   	push   %rbp
  8020b7:	48 89 e5             	mov    %rsp,%rbp
  8020ba:	48 83 ec 20          	sub    $0x20,%rsp
  8020be:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020cc:	eb 41                	jmp    80210f <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020ce:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020d5:	00 00 00 
  8020d8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020db:	48 63 d2             	movslq %edx,%rdx
  8020de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e2:	8b 00                	mov    (%rax),%eax
  8020e4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020e7:	75 22                	jne    80210b <dev_lookup+0x55>
			*dev = devtab[i];
  8020e9:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020f0:	00 00 00 
  8020f3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020f6:	48 63 d2             	movslq %edx,%rdx
  8020f9:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8020fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802101:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802104:	b8 00 00 00 00       	mov    $0x0,%eax
  802109:	eb 60                	jmp    80216b <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80210b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80210f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802116:	00 00 00 
  802119:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80211c:	48 63 d2             	movslq %edx,%rdx
  80211f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802123:	48 85 c0             	test   %rax,%rax
  802126:	75 a6                	jne    8020ce <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802128:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80212f:	00 00 00 
  802132:	48 8b 00             	mov    (%rax),%rax
  802135:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80213b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80213e:	89 c6                	mov    %eax,%esi
  802140:	48 bf b8 41 80 00 00 	movabs $0x8041b8,%rdi
  802147:	00 00 00 
  80214a:	b8 00 00 00 00       	mov    $0x0,%eax
  80214f:	48 b9 b7 05 80 00 00 	movabs $0x8005b7,%rcx
  802156:	00 00 00 
  802159:	ff d1                	callq  *%rcx
	*dev = 0;
  80215b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80215f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802166:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80216b:	c9                   	leaveq 
  80216c:	c3                   	retq   

000000000080216d <close>:

int
close(int fdnum)
{
  80216d:	55                   	push   %rbp
  80216e:	48 89 e5             	mov    %rsp,%rbp
  802171:	48 83 ec 20          	sub    $0x20,%rsp
  802175:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802178:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80217c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80217f:	48 89 d6             	mov    %rdx,%rsi
  802182:	89 c7                	mov    %eax,%edi
  802184:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  80218b:	00 00 00 
  80218e:	ff d0                	callq  *%rax
  802190:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802193:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802197:	79 05                	jns    80219e <close+0x31>
		return r;
  802199:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219c:	eb 18                	jmp    8021b6 <close+0x49>
	else
		return fd_close(fd, 1);
  80219e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a2:	be 01 00 00 00       	mov    $0x1,%esi
  8021a7:	48 89 c7             	mov    %rax,%rdi
  8021aa:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  8021b1:	00 00 00 
  8021b4:	ff d0                	callq  *%rax
}
  8021b6:	c9                   	leaveq 
  8021b7:	c3                   	retq   

00000000008021b8 <close_all>:

void
close_all(void)
{
  8021b8:	55                   	push   %rbp
  8021b9:	48 89 e5             	mov    %rsp,%rbp
  8021bc:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021c7:	eb 15                	jmp    8021de <close_all+0x26>
		close(i);
  8021c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021cc:	89 c7                	mov    %eax,%edi
  8021ce:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  8021d5:	00 00 00 
  8021d8:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021da:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021de:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021e2:	7e e5                	jle    8021c9 <close_all+0x11>
		close(i);
}
  8021e4:	c9                   	leaveq 
  8021e5:	c3                   	retq   

00000000008021e6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021e6:	55                   	push   %rbp
  8021e7:	48 89 e5             	mov    %rsp,%rbp
  8021ea:	48 83 ec 40          	sub    $0x40,%rsp
  8021ee:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021f1:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021f4:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021f8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021fb:	48 89 d6             	mov    %rdx,%rsi
  8021fe:	89 c7                	mov    %eax,%edi
  802200:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  802207:	00 00 00 
  80220a:	ff d0                	callq  *%rax
  80220c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80220f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802213:	79 08                	jns    80221d <dup+0x37>
		return r;
  802215:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802218:	e9 70 01 00 00       	jmpq   80238d <dup+0x1a7>
	close(newfdnum);
  80221d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802220:	89 c7                	mov    %eax,%edi
  802222:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  802229:	00 00 00 
  80222c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80222e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802231:	48 98                	cltq   
  802233:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802239:	48 c1 e0 0c          	shl    $0xc,%rax
  80223d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802241:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802245:	48 89 c7             	mov    %rax,%rdi
  802248:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  80224f:	00 00 00 
  802252:	ff d0                	callq  *%rax
  802254:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225c:	48 89 c7             	mov    %rax,%rdi
  80225f:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  802266:	00 00 00 
  802269:	ff d0                	callq  *%rax
  80226b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80226f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802273:	48 c1 e8 15          	shr    $0x15,%rax
  802277:	48 89 c2             	mov    %rax,%rdx
  80227a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802281:	01 00 00 
  802284:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802288:	83 e0 01             	and    $0x1,%eax
  80228b:	48 85 c0             	test   %rax,%rax
  80228e:	74 73                	je     802303 <dup+0x11d>
  802290:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802294:	48 c1 e8 0c          	shr    $0xc,%rax
  802298:	48 89 c2             	mov    %rax,%rdx
  80229b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022a2:	01 00 00 
  8022a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a9:	83 e0 01             	and    $0x1,%eax
  8022ac:	48 85 c0             	test   %rax,%rax
  8022af:	74 52                	je     802303 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b5:	48 c1 e8 0c          	shr    $0xc,%rax
  8022b9:	48 89 c2             	mov    %rax,%rdx
  8022bc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022c3:	01 00 00 
  8022c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ca:	25 07 0e 00 00       	and    $0xe07,%eax
  8022cf:	89 c1                	mov    %eax,%ecx
  8022d1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d9:	41 89 c8             	mov    %ecx,%r8d
  8022dc:	48 89 d1             	mov    %rdx,%rcx
  8022df:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e4:	48 89 c6             	mov    %rax,%rsi
  8022e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ec:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  8022f3:	00 00 00 
  8022f6:	ff d0                	callq  *%rax
  8022f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ff:	79 02                	jns    802303 <dup+0x11d>
			goto err;
  802301:	eb 57                	jmp    80235a <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802303:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802307:	48 c1 e8 0c          	shr    $0xc,%rax
  80230b:	48 89 c2             	mov    %rax,%rdx
  80230e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802315:	01 00 00 
  802318:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231c:	25 07 0e 00 00       	and    $0xe07,%eax
  802321:	89 c1                	mov    %eax,%ecx
  802323:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802327:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80232b:	41 89 c8             	mov    %ecx,%r8d
  80232e:	48 89 d1             	mov    %rdx,%rcx
  802331:	ba 00 00 00 00       	mov    $0x0,%edx
  802336:	48 89 c6             	mov    %rax,%rsi
  802339:	bf 00 00 00 00       	mov    $0x0,%edi
  80233e:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  802345:	00 00 00 
  802348:	ff d0                	callq  *%rax
  80234a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80234d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802351:	79 02                	jns    802355 <dup+0x16f>
		goto err;
  802353:	eb 05                	jmp    80235a <dup+0x174>

	return newfdnum;
  802355:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802358:	eb 33                	jmp    80238d <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80235a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235e:	48 89 c6             	mov    %rax,%rsi
  802361:	bf 00 00 00 00       	mov    $0x0,%edi
  802366:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  80236d:	00 00 00 
  802370:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802372:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802376:	48 89 c6             	mov    %rax,%rsi
  802379:	bf 00 00 00 00       	mov    $0x0,%edi
  80237e:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  802385:	00 00 00 
  802388:	ff d0                	callq  *%rax
	return r;
  80238a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80238d:	c9                   	leaveq 
  80238e:	c3                   	retq   

000000000080238f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80238f:	55                   	push   %rbp
  802390:	48 89 e5             	mov    %rsp,%rbp
  802393:	48 83 ec 40          	sub    $0x40,%rsp
  802397:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80239a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80239e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023a2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023a6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023a9:	48 89 d6             	mov    %rdx,%rsi
  8023ac:	89 c7                	mov    %eax,%edi
  8023ae:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  8023b5:	00 00 00 
  8023b8:	ff d0                	callq  *%rax
  8023ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c1:	78 24                	js     8023e7 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c7:	8b 00                	mov    (%rax),%eax
  8023c9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023cd:	48 89 d6             	mov    %rdx,%rsi
  8023d0:	89 c7                	mov    %eax,%edi
  8023d2:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  8023d9:	00 00 00 
  8023dc:	ff d0                	callq  *%rax
  8023de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e5:	79 05                	jns    8023ec <read+0x5d>
		return r;
  8023e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ea:	eb 76                	jmp    802462 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f0:	8b 40 08             	mov    0x8(%rax),%eax
  8023f3:	83 e0 03             	and    $0x3,%eax
  8023f6:	83 f8 01             	cmp    $0x1,%eax
  8023f9:	75 3a                	jne    802435 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023fb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802402:	00 00 00 
  802405:	48 8b 00             	mov    (%rax),%rax
  802408:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80240e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802411:	89 c6                	mov    %eax,%esi
  802413:	48 bf d7 41 80 00 00 	movabs $0x8041d7,%rdi
  80241a:	00 00 00 
  80241d:	b8 00 00 00 00       	mov    $0x0,%eax
  802422:	48 b9 b7 05 80 00 00 	movabs $0x8005b7,%rcx
  802429:	00 00 00 
  80242c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80242e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802433:	eb 2d                	jmp    802462 <read+0xd3>
	}
	if (!dev->dev_read)
  802435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802439:	48 8b 40 10          	mov    0x10(%rax),%rax
  80243d:	48 85 c0             	test   %rax,%rax
  802440:	75 07                	jne    802449 <read+0xba>
		return -E_NOT_SUPP;
  802442:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802447:	eb 19                	jmp    802462 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802449:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802451:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802455:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802459:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80245d:	48 89 cf             	mov    %rcx,%rdi
  802460:	ff d0                	callq  *%rax
}
  802462:	c9                   	leaveq 
  802463:	c3                   	retq   

0000000000802464 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802464:	55                   	push   %rbp
  802465:	48 89 e5             	mov    %rsp,%rbp
  802468:	48 83 ec 30          	sub    $0x30,%rsp
  80246c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80246f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802473:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802477:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80247e:	eb 49                	jmp    8024c9 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802480:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802483:	48 98                	cltq   
  802485:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802489:	48 29 c2             	sub    %rax,%rdx
  80248c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248f:	48 63 c8             	movslq %eax,%rcx
  802492:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802496:	48 01 c1             	add    %rax,%rcx
  802499:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80249c:	48 89 ce             	mov    %rcx,%rsi
  80249f:	89 c7                	mov    %eax,%edi
  8024a1:	48 b8 8f 23 80 00 00 	movabs $0x80238f,%rax
  8024a8:	00 00 00 
  8024ab:	ff d0                	callq  *%rax
  8024ad:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024b0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024b4:	79 05                	jns    8024bb <readn+0x57>
			return m;
  8024b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024b9:	eb 1c                	jmp    8024d7 <readn+0x73>
		if (m == 0)
  8024bb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024bf:	75 02                	jne    8024c3 <readn+0x5f>
			break;
  8024c1:	eb 11                	jmp    8024d4 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024c6:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024cc:	48 98                	cltq   
  8024ce:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024d2:	72 ac                	jb     802480 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024d7:	c9                   	leaveq 
  8024d8:	c3                   	retq   

00000000008024d9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024d9:	55                   	push   %rbp
  8024da:	48 89 e5             	mov    %rsp,%rbp
  8024dd:	48 83 ec 40          	sub    $0x40,%rsp
  8024e1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024e4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024e8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024ec:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f3:	48 89 d6             	mov    %rdx,%rsi
  8024f6:	89 c7                	mov    %eax,%edi
  8024f8:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  8024ff:	00 00 00 
  802502:	ff d0                	callq  *%rax
  802504:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802507:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250b:	78 24                	js     802531 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80250d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802511:	8b 00                	mov    (%rax),%eax
  802513:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802517:	48 89 d6             	mov    %rdx,%rsi
  80251a:	89 c7                	mov    %eax,%edi
  80251c:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  802523:	00 00 00 
  802526:	ff d0                	callq  *%rax
  802528:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80252f:	79 05                	jns    802536 <write+0x5d>
		return r;
  802531:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802534:	eb 75                	jmp    8025ab <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802536:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253a:	8b 40 08             	mov    0x8(%rax),%eax
  80253d:	83 e0 03             	and    $0x3,%eax
  802540:	85 c0                	test   %eax,%eax
  802542:	75 3a                	jne    80257e <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802544:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80254b:	00 00 00 
  80254e:	48 8b 00             	mov    (%rax),%rax
  802551:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802557:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80255a:	89 c6                	mov    %eax,%esi
  80255c:	48 bf f3 41 80 00 00 	movabs $0x8041f3,%rdi
  802563:	00 00 00 
  802566:	b8 00 00 00 00       	mov    $0x0,%eax
  80256b:	48 b9 b7 05 80 00 00 	movabs $0x8005b7,%rcx
  802572:	00 00 00 
  802575:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802577:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80257c:	eb 2d                	jmp    8025ab <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80257e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802582:	48 8b 40 18          	mov    0x18(%rax),%rax
  802586:	48 85 c0             	test   %rax,%rax
  802589:	75 07                	jne    802592 <write+0xb9>
		return -E_NOT_SUPP;
  80258b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802590:	eb 19                	jmp    8025ab <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802592:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802596:	48 8b 40 18          	mov    0x18(%rax),%rax
  80259a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80259e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025a2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025a6:	48 89 cf             	mov    %rcx,%rdi
  8025a9:	ff d0                	callq  *%rax
}
  8025ab:	c9                   	leaveq 
  8025ac:	c3                   	retq   

00000000008025ad <seek>:

int
seek(int fdnum, off_t offset)
{
  8025ad:	55                   	push   %rbp
  8025ae:	48 89 e5             	mov    %rsp,%rbp
  8025b1:	48 83 ec 18          	sub    $0x18,%rsp
  8025b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025b8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025bb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025c2:	48 89 d6             	mov    %rdx,%rsi
  8025c5:	89 c7                	mov    %eax,%edi
  8025c7:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  8025ce:	00 00 00 
  8025d1:	ff d0                	callq  *%rax
  8025d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025da:	79 05                	jns    8025e1 <seek+0x34>
		return r;
  8025dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025df:	eb 0f                	jmp    8025f0 <seek+0x43>
	fd->fd_offset = offset;
  8025e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025e8:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f0:	c9                   	leaveq 
  8025f1:	c3                   	retq   

00000000008025f2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025f2:	55                   	push   %rbp
  8025f3:	48 89 e5             	mov    %rsp,%rbp
  8025f6:	48 83 ec 30          	sub    $0x30,%rsp
  8025fa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025fd:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802600:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802604:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802607:	48 89 d6             	mov    %rdx,%rsi
  80260a:	89 c7                	mov    %eax,%edi
  80260c:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  802613:	00 00 00 
  802616:	ff d0                	callq  *%rax
  802618:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261f:	78 24                	js     802645 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802621:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802625:	8b 00                	mov    (%rax),%eax
  802627:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80262b:	48 89 d6             	mov    %rdx,%rsi
  80262e:	89 c7                	mov    %eax,%edi
  802630:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  802637:	00 00 00 
  80263a:	ff d0                	callq  *%rax
  80263c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80263f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802643:	79 05                	jns    80264a <ftruncate+0x58>
		return r;
  802645:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802648:	eb 72                	jmp    8026bc <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80264a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264e:	8b 40 08             	mov    0x8(%rax),%eax
  802651:	83 e0 03             	and    $0x3,%eax
  802654:	85 c0                	test   %eax,%eax
  802656:	75 3a                	jne    802692 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802658:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80265f:	00 00 00 
  802662:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802665:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80266b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80266e:	89 c6                	mov    %eax,%esi
  802670:	48 bf 10 42 80 00 00 	movabs $0x804210,%rdi
  802677:	00 00 00 
  80267a:	b8 00 00 00 00       	mov    $0x0,%eax
  80267f:	48 b9 b7 05 80 00 00 	movabs $0x8005b7,%rcx
  802686:	00 00 00 
  802689:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80268b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802690:	eb 2a                	jmp    8026bc <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802696:	48 8b 40 30          	mov    0x30(%rax),%rax
  80269a:	48 85 c0             	test   %rax,%rax
  80269d:	75 07                	jne    8026a6 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80269f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026a4:	eb 16                	jmp    8026bc <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026aa:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026b2:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026b5:	89 ce                	mov    %ecx,%esi
  8026b7:	48 89 d7             	mov    %rdx,%rdi
  8026ba:	ff d0                	callq  *%rax
}
  8026bc:	c9                   	leaveq 
  8026bd:	c3                   	retq   

00000000008026be <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026be:	55                   	push   %rbp
  8026bf:	48 89 e5             	mov    %rsp,%rbp
  8026c2:	48 83 ec 30          	sub    $0x30,%rsp
  8026c6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026cd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026d1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026d4:	48 89 d6             	mov    %rdx,%rsi
  8026d7:	89 c7                	mov    %eax,%edi
  8026d9:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  8026e0:	00 00 00 
  8026e3:	ff d0                	callq  *%rax
  8026e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ec:	78 24                	js     802712 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f2:	8b 00                	mov    (%rax),%eax
  8026f4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026f8:	48 89 d6             	mov    %rdx,%rsi
  8026fb:	89 c7                	mov    %eax,%edi
  8026fd:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  802704:	00 00 00 
  802707:	ff d0                	callq  *%rax
  802709:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80270c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802710:	79 05                	jns    802717 <fstat+0x59>
		return r;
  802712:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802715:	eb 5e                	jmp    802775 <fstat+0xb7>
	if (!dev->dev_stat)
  802717:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80271f:	48 85 c0             	test   %rax,%rax
  802722:	75 07                	jne    80272b <fstat+0x6d>
		return -E_NOT_SUPP;
  802724:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802729:	eb 4a                	jmp    802775 <fstat+0xb7>
	stat->st_name[0] = 0;
  80272b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80272f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802732:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802736:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80273d:	00 00 00 
	stat->st_isdir = 0;
  802740:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802744:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80274b:	00 00 00 
	stat->st_dev = dev;
  80274e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802752:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802756:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80275d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802761:	48 8b 40 28          	mov    0x28(%rax),%rax
  802765:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802769:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80276d:	48 89 ce             	mov    %rcx,%rsi
  802770:	48 89 d7             	mov    %rdx,%rdi
  802773:	ff d0                	callq  *%rax
}
  802775:	c9                   	leaveq 
  802776:	c3                   	retq   

0000000000802777 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802777:	55                   	push   %rbp
  802778:	48 89 e5             	mov    %rsp,%rbp
  80277b:	48 83 ec 20          	sub    $0x20,%rsp
  80277f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802783:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802787:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278b:	be 00 00 00 00       	mov    $0x0,%esi
  802790:	48 89 c7             	mov    %rax,%rdi
  802793:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  80279a:	00 00 00 
  80279d:	ff d0                	callq  *%rax
  80279f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a6:	79 05                	jns    8027ad <stat+0x36>
		return fd;
  8027a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ab:	eb 2f                	jmp    8027dc <stat+0x65>
	r = fstat(fd, stat);
  8027ad:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b4:	48 89 d6             	mov    %rdx,%rsi
  8027b7:	89 c7                	mov    %eax,%edi
  8027b9:	48 b8 be 26 80 00 00 	movabs $0x8026be,%rax
  8027c0:	00 00 00 
  8027c3:	ff d0                	callq  *%rax
  8027c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cb:	89 c7                	mov    %eax,%edi
  8027cd:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  8027d4:	00 00 00 
  8027d7:	ff d0                	callq  *%rax
	return r;
  8027d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027dc:	c9                   	leaveq 
  8027dd:	c3                   	retq   

00000000008027de <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027de:	55                   	push   %rbp
  8027df:	48 89 e5             	mov    %rsp,%rbp
  8027e2:	48 83 ec 10          	sub    $0x10,%rsp
  8027e6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027ed:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8027f4:	00 00 00 
  8027f7:	8b 00                	mov    (%rax),%eax
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	75 1d                	jne    80281a <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027fd:	bf 01 00 00 00       	mov    $0x1,%edi
  802802:	48 b8 0d 3b 80 00 00 	movabs $0x803b0d,%rax
  802809:	00 00 00 
  80280c:	ff d0                	callq  *%rax
  80280e:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802815:	00 00 00 
  802818:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80281a:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802821:	00 00 00 
  802824:	8b 00                	mov    (%rax),%eax
  802826:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802829:	b9 07 00 00 00       	mov    $0x7,%ecx
  80282e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802835:	00 00 00 
  802838:	89 c7                	mov    %eax,%edi
  80283a:	48 b8 0e 3a 80 00 00 	movabs $0x803a0e,%rax
  802841:	00 00 00 
  802844:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802846:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284a:	ba 00 00 00 00       	mov    $0x0,%edx
  80284f:	48 89 c6             	mov    %rax,%rsi
  802852:	bf 00 00 00 00       	mov    $0x0,%edi
  802857:	48 b8 5b 39 80 00 00 	movabs $0x80395b,%rax
  80285e:	00 00 00 
  802861:	ff d0                	callq  *%rax
}
  802863:	c9                   	leaveq 
  802864:	c3                   	retq   

0000000000802865 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802865:	55                   	push   %rbp
  802866:	48 89 e5             	mov    %rsp,%rbp
  802869:	48 83 ec 20          	sub    $0x20,%rsp
  80286d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802871:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  802874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802878:	48 89 c7             	mov    %rax,%rdi
  80287b:	48 b8 41 11 80 00 00 	movabs $0x801141,%rax
  802882:	00 00 00 
  802885:	ff d0                	callq  *%rax
  802887:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80288c:	7e 0a                	jle    802898 <open+0x33>
		return -E_BAD_PATH;
  80288e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802893:	e9 a5 00 00 00       	jmpq   80293d <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  802898:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80289c:	48 89 c7             	mov    %rax,%rdi
  80289f:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  8028a6:	00 00 00 
  8028a9:	ff d0                	callq  *%rax
  8028ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b2:	79 08                	jns    8028bc <open+0x57>
		return ret;
  8028b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b7:	e9 81 00 00 00       	jmpq   80293d <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  8028bc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028c3:	00 00 00 
  8028c6:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8028c9:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  8028cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d3:	48 89 c6             	mov    %rax,%rsi
  8028d6:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8028dd:	00 00 00 
  8028e0:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  8028e7:	00 00 00 
  8028ea:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  8028ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f0:	48 89 c6             	mov    %rax,%rsi
  8028f3:	bf 01 00 00 00       	mov    $0x1,%edi
  8028f8:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  8028ff:	00 00 00 
  802902:	ff d0                	callq  *%rax
  802904:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802907:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290b:	79 1d                	jns    80292a <open+0xc5>
	{
		fd_close(fd,0);
  80290d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802911:	be 00 00 00 00       	mov    $0x0,%esi
  802916:	48 89 c7             	mov    %rax,%rdi
  802919:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  802920:	00 00 00 
  802923:	ff d0                	callq  *%rax
		return ret;
  802925:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802928:	eb 13                	jmp    80293d <open+0xd8>
	}
	return fd2num (fd);
  80292a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292e:	48 89 c7             	mov    %rax,%rdi
  802931:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  802938:	00 00 00 
  80293b:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  80293d:	c9                   	leaveq 
  80293e:	c3                   	retq   

000000000080293f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80293f:	55                   	push   %rbp
  802940:	48 89 e5             	mov    %rsp,%rbp
  802943:	48 83 ec 10          	sub    $0x10,%rsp
  802947:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80294b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80294f:	8b 50 0c             	mov    0xc(%rax),%edx
  802952:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802959:	00 00 00 
  80295c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80295e:	be 00 00 00 00       	mov    $0x0,%esi
  802963:	bf 06 00 00 00       	mov    $0x6,%edi
  802968:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  80296f:	00 00 00 
  802972:	ff d0                	callq  *%rax
}
  802974:	c9                   	leaveq 
  802975:	c3                   	retq   

0000000000802976 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802976:	55                   	push   %rbp
  802977:	48 89 e5             	mov    %rsp,%rbp
  80297a:	48 83 ec 30          	sub    $0x30,%rsp
  80297e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802982:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802986:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  80298a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298e:	8b 50 0c             	mov    0xc(%rax),%edx
  802991:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802998:	00 00 00 
  80299b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  80299d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029a4:	00 00 00 
  8029a7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029ab:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  8029af:	be 00 00 00 00       	mov    $0x0,%esi
  8029b4:	bf 03 00 00 00       	mov    $0x3,%edi
  8029b9:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  8029c0:	00 00 00 
  8029c3:	ff d0                	callq  *%rax
  8029c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029cc:	79 05                	jns    8029d3 <devfile_read+0x5d>
		return ret;
  8029ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d1:	eb 26                	jmp    8029f9 <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  8029d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d6:	48 63 d0             	movslq %eax,%rdx
  8029d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029dd:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8029e4:	00 00 00 
  8029e7:	48 89 c7             	mov    %rax,%rdi
  8029ea:	48 b8 d1 14 80 00 00 	movabs $0x8014d1,%rax
  8029f1:	00 00 00 
  8029f4:	ff d0                	callq  *%rax
	return ret;
  8029f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  8029f9:	c9                   	leaveq 
  8029fa:	c3                   	retq   

00000000008029fb <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029fb:	55                   	push   %rbp
  8029fc:	48 89 e5             	mov    %rsp,%rbp
  8029ff:	48 83 ec 30          	sub    $0x30,%rsp
  802a03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  802a0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a13:	8b 50 0c             	mov    0xc(%rax),%edx
  802a16:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a1d:	00 00 00 
  802a20:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  802a22:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  802a27:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a2e:	00 
  802a2f:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802a34:	48 89 c2             	mov    %rax,%rdx
  802a37:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a3e:	00 00 00 
  802a41:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  802a45:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a4c:	00 00 00 
  802a4f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802a53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a57:	48 89 c6             	mov    %rax,%rsi
  802a5a:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802a61:	00 00 00 
  802a64:	48 b8 d1 14 80 00 00 	movabs $0x8014d1,%rax
  802a6b:	00 00 00 
  802a6e:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  802a70:	be 00 00 00 00       	mov    $0x0,%esi
  802a75:	bf 04 00 00 00       	mov    $0x4,%edi
  802a7a:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  802a81:	00 00 00 
  802a84:	ff d0                	callq  *%rax
  802a86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a8d:	79 05                	jns    802a94 <devfile_write+0x99>
		return ret;
  802a8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a92:	eb 03                	jmp    802a97 <devfile_write+0x9c>
	
	return ret;
  802a94:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  802a97:	c9                   	leaveq 
  802a98:	c3                   	retq   

0000000000802a99 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a99:	55                   	push   %rbp
  802a9a:	48 89 e5             	mov    %rsp,%rbp
  802a9d:	48 83 ec 20          	sub    $0x20,%rsp
  802aa1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aa5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802aa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aad:	8b 50 0c             	mov    0xc(%rax),%edx
  802ab0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ab7:	00 00 00 
  802aba:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802abc:	be 00 00 00 00       	mov    $0x0,%esi
  802ac1:	bf 05 00 00 00       	mov    $0x5,%edi
  802ac6:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  802acd:	00 00 00 
  802ad0:	ff d0                	callq  *%rax
  802ad2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad9:	79 05                	jns    802ae0 <devfile_stat+0x47>
		return r;
  802adb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ade:	eb 56                	jmp    802b36 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ae0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae4:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802aeb:	00 00 00 
  802aee:	48 89 c7             	mov    %rax,%rdi
  802af1:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  802af8:	00 00 00 
  802afb:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802afd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b04:	00 00 00 
  802b07:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b0d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b11:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b17:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b1e:	00 00 00 
  802b21:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b2b:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b36:	c9                   	leaveq 
  802b37:	c3                   	retq   

0000000000802b38 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b38:	55                   	push   %rbp
  802b39:	48 89 e5             	mov    %rsp,%rbp
  802b3c:	48 83 ec 10          	sub    $0x10,%rsp
  802b40:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b44:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b4b:	8b 50 0c             	mov    0xc(%rax),%edx
  802b4e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b55:	00 00 00 
  802b58:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b5a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b61:	00 00 00 
  802b64:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b67:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b6a:	be 00 00 00 00       	mov    $0x0,%esi
  802b6f:	bf 02 00 00 00       	mov    $0x2,%edi
  802b74:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  802b7b:	00 00 00 
  802b7e:	ff d0                	callq  *%rax
}
  802b80:	c9                   	leaveq 
  802b81:	c3                   	retq   

0000000000802b82 <remove>:

// Delete a file
int
remove(const char *path)
{
  802b82:	55                   	push   %rbp
  802b83:	48 89 e5             	mov    %rsp,%rbp
  802b86:	48 83 ec 10          	sub    $0x10,%rsp
  802b8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b92:	48 89 c7             	mov    %rax,%rdi
  802b95:	48 b8 41 11 80 00 00 	movabs $0x801141,%rax
  802b9c:	00 00 00 
  802b9f:	ff d0                	callq  *%rax
  802ba1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ba6:	7e 07                	jle    802baf <remove+0x2d>
		return -E_BAD_PATH;
  802ba8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bad:	eb 33                	jmp    802be2 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802baf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb3:	48 89 c6             	mov    %rax,%rsi
  802bb6:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802bbd:	00 00 00 
  802bc0:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  802bc7:	00 00 00 
  802bca:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802bcc:	be 00 00 00 00       	mov    $0x0,%esi
  802bd1:	bf 07 00 00 00       	mov    $0x7,%edi
  802bd6:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  802bdd:	00 00 00 
  802be0:	ff d0                	callq  *%rax
}
  802be2:	c9                   	leaveq 
  802be3:	c3                   	retq   

0000000000802be4 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802be4:	55                   	push   %rbp
  802be5:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802be8:	be 00 00 00 00       	mov    $0x0,%esi
  802bed:	bf 08 00 00 00       	mov    $0x8,%edi
  802bf2:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  802bf9:	00 00 00 
  802bfc:	ff d0                	callq  *%rax
}
  802bfe:	5d                   	pop    %rbp
  802bff:	c3                   	retq   

0000000000802c00 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c00:	55                   	push   %rbp
  802c01:	48 89 e5             	mov    %rsp,%rbp
  802c04:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c0b:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c12:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c19:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c20:	be 00 00 00 00       	mov    $0x0,%esi
  802c25:	48 89 c7             	mov    %rax,%rdi
  802c28:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  802c2f:	00 00 00 
  802c32:	ff d0                	callq  *%rax
  802c34:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3b:	79 28                	jns    802c65 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c40:	89 c6                	mov    %eax,%esi
  802c42:	48 bf 36 42 80 00 00 	movabs $0x804236,%rdi
  802c49:	00 00 00 
  802c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c51:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  802c58:	00 00 00 
  802c5b:	ff d2                	callq  *%rdx
		return fd_src;
  802c5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c60:	e9 74 01 00 00       	jmpq   802dd9 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c65:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c6c:	be 01 01 00 00       	mov    $0x101,%esi
  802c71:	48 89 c7             	mov    %rax,%rdi
  802c74:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  802c7b:	00 00 00 
  802c7e:	ff d0                	callq  *%rax
  802c80:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c83:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c87:	79 39                	jns    802cc2 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802c89:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c8c:	89 c6                	mov    %eax,%esi
  802c8e:	48 bf 4c 42 80 00 00 	movabs $0x80424c,%rdi
  802c95:	00 00 00 
  802c98:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9d:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  802ca4:	00 00 00 
  802ca7:	ff d2                	callq  *%rdx
		close(fd_src);
  802ca9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cac:	89 c7                	mov    %eax,%edi
  802cae:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  802cb5:	00 00 00 
  802cb8:	ff d0                	callq  *%rax
		return fd_dest;
  802cba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cbd:	e9 17 01 00 00       	jmpq   802dd9 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cc2:	eb 74                	jmp    802d38 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802cc4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cc7:	48 63 d0             	movslq %eax,%rdx
  802cca:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cd1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cd4:	48 89 ce             	mov    %rcx,%rsi
  802cd7:	89 c7                	mov    %eax,%edi
  802cd9:	48 b8 d9 24 80 00 00 	movabs $0x8024d9,%rax
  802ce0:	00 00 00 
  802ce3:	ff d0                	callq  *%rax
  802ce5:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802ce8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802cec:	79 4a                	jns    802d38 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802cee:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cf1:	89 c6                	mov    %eax,%esi
  802cf3:	48 bf 66 42 80 00 00 	movabs $0x804266,%rdi
  802cfa:	00 00 00 
  802cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  802d02:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  802d09:	00 00 00 
  802d0c:	ff d2                	callq  *%rdx
			close(fd_src);
  802d0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d11:	89 c7                	mov    %eax,%edi
  802d13:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  802d1a:	00 00 00 
  802d1d:	ff d0                	callq  *%rax
			close(fd_dest);
  802d1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d22:	89 c7                	mov    %eax,%edi
  802d24:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  802d2b:	00 00 00 
  802d2e:	ff d0                	callq  *%rax
			return write_size;
  802d30:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d33:	e9 a1 00 00 00       	jmpq   802dd9 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d38:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d42:	ba 00 02 00 00       	mov    $0x200,%edx
  802d47:	48 89 ce             	mov    %rcx,%rsi
  802d4a:	89 c7                	mov    %eax,%edi
  802d4c:	48 b8 8f 23 80 00 00 	movabs $0x80238f,%rax
  802d53:	00 00 00 
  802d56:	ff d0                	callq  *%rax
  802d58:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d5f:	0f 8f 5f ff ff ff    	jg     802cc4 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802d65:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d69:	79 47                	jns    802db2 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802d6b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d6e:	89 c6                	mov    %eax,%esi
  802d70:	48 bf 79 42 80 00 00 	movabs $0x804279,%rdi
  802d77:	00 00 00 
  802d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7f:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  802d86:	00 00 00 
  802d89:	ff d2                	callq  *%rdx
		close(fd_src);
  802d8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d8e:	89 c7                	mov    %eax,%edi
  802d90:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  802d97:	00 00 00 
  802d9a:	ff d0                	callq  *%rax
		close(fd_dest);
  802d9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d9f:	89 c7                	mov    %eax,%edi
  802da1:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  802da8:	00 00 00 
  802dab:	ff d0                	callq  *%rax
		return read_size;
  802dad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802db0:	eb 27                	jmp    802dd9 <copy+0x1d9>
	}
	close(fd_src);
  802db2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db5:	89 c7                	mov    %eax,%edi
  802db7:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  802dbe:	00 00 00 
  802dc1:	ff d0                	callq  *%rax
	close(fd_dest);
  802dc3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dc6:	89 c7                	mov    %eax,%edi
  802dc8:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  802dcf:	00 00 00 
  802dd2:	ff d0                	callq  *%rax
	return 0;
  802dd4:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802dd9:	c9                   	leaveq 
  802dda:	c3                   	retq   

0000000000802ddb <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802ddb:	55                   	push   %rbp
  802ddc:	48 89 e5             	mov    %rsp,%rbp
  802ddf:	48 83 ec 20          	sub    $0x20,%rsp
  802de3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802de7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802deb:	8b 40 0c             	mov    0xc(%rax),%eax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	7e 67                	jle    802e59 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802df2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df6:	8b 40 04             	mov    0x4(%rax),%eax
  802df9:	48 63 d0             	movslq %eax,%rdx
  802dfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e00:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802e04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e08:	8b 00                	mov    (%rax),%eax
  802e0a:	48 89 ce             	mov    %rcx,%rsi
  802e0d:	89 c7                	mov    %eax,%edi
  802e0f:	48 b8 d9 24 80 00 00 	movabs $0x8024d9,%rax
  802e16:	00 00 00 
  802e19:	ff d0                	callq  *%rax
  802e1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802e1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e22:	7e 13                	jle    802e37 <writebuf+0x5c>
			b->result += result;
  802e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e28:	8b 50 08             	mov    0x8(%rax),%edx
  802e2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2e:	01 c2                	add    %eax,%edx
  802e30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e34:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802e37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3b:	8b 40 04             	mov    0x4(%rax),%eax
  802e3e:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802e41:	74 16                	je     802e59 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802e43:	b8 00 00 00 00       	mov    $0x0,%eax
  802e48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e4c:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802e50:	89 c2                	mov    %eax,%edx
  802e52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e56:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802e59:	c9                   	leaveq 
  802e5a:	c3                   	retq   

0000000000802e5b <putch>:

static void
putch(int ch, void *thunk)
{
  802e5b:	55                   	push   %rbp
  802e5c:	48 89 e5             	mov    %rsp,%rbp
  802e5f:	48 83 ec 20          	sub    $0x20,%rsp
  802e63:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802e6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e6e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802e72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e76:	8b 40 04             	mov    0x4(%rax),%eax
  802e79:	8d 48 01             	lea    0x1(%rax),%ecx
  802e7c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e80:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802e83:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e86:	89 d1                	mov    %edx,%ecx
  802e88:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e8c:	48 98                	cltq   
  802e8e:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802e92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e96:	8b 40 04             	mov    0x4(%rax),%eax
  802e99:	3d 00 01 00 00       	cmp    $0x100,%eax
  802e9e:	75 1e                	jne    802ebe <putch+0x63>
		writebuf(b);
  802ea0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea4:	48 89 c7             	mov    %rax,%rdi
  802ea7:	48 b8 db 2d 80 00 00 	movabs $0x802ddb,%rax
  802eae:	00 00 00 
  802eb1:	ff d0                	callq  *%rax
		b->idx = 0;
  802eb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802ebe:	c9                   	leaveq 
  802ebf:	c3                   	retq   

0000000000802ec0 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802ec0:	55                   	push   %rbp
  802ec1:	48 89 e5             	mov    %rsp,%rbp
  802ec4:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802ecb:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802ed1:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802ed8:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802edf:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802ee5:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802eeb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802ef2:	00 00 00 
	b.result = 0;
  802ef5:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802efc:	00 00 00 
	b.error = 1;
  802eff:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802f06:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802f09:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802f10:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802f17:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f1e:	48 89 c6             	mov    %rax,%rsi
  802f21:	48 bf 5b 2e 80 00 00 	movabs $0x802e5b,%rdi
  802f28:	00 00 00 
  802f2b:	48 b8 6a 09 80 00 00 	movabs $0x80096a,%rax
  802f32:	00 00 00 
  802f35:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802f37:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802f3d:	85 c0                	test   %eax,%eax
  802f3f:	7e 16                	jle    802f57 <vfprintf+0x97>
		writebuf(&b);
  802f41:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f48:	48 89 c7             	mov    %rax,%rdi
  802f4b:	48 b8 db 2d 80 00 00 	movabs $0x802ddb,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802f57:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	74 08                	je     802f69 <vfprintf+0xa9>
  802f61:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802f67:	eb 06                	jmp    802f6f <vfprintf+0xaf>
  802f69:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802f6f:	c9                   	leaveq 
  802f70:	c3                   	retq   

0000000000802f71 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802f71:	55                   	push   %rbp
  802f72:	48 89 e5             	mov    %rsp,%rbp
  802f75:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802f7c:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802f82:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802f89:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802f90:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802f97:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802f9e:	84 c0                	test   %al,%al
  802fa0:	74 20                	je     802fc2 <fprintf+0x51>
  802fa2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802fa6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802faa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802fae:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802fb2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802fb6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802fba:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802fbe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802fc2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802fc9:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802fd0:	00 00 00 
  802fd3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802fda:	00 00 00 
  802fdd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fe1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802fe8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802fef:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802ff6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802ffd:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  803004:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80300a:	48 89 ce             	mov    %rcx,%rsi
  80300d:	89 c7                	mov    %eax,%edi
  80300f:	48 b8 c0 2e 80 00 00 	movabs $0x802ec0,%rax
  803016:	00 00 00 
  803019:	ff d0                	callq  *%rax
  80301b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803021:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803027:	c9                   	leaveq 
  803028:	c3                   	retq   

0000000000803029 <printf>:

int
printf(const char *fmt, ...)
{
  803029:	55                   	push   %rbp
  80302a:	48 89 e5             	mov    %rsp,%rbp
  80302d:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803034:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80303b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803042:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803049:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803050:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803057:	84 c0                	test   %al,%al
  803059:	74 20                	je     80307b <printf+0x52>
  80305b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80305f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803063:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803067:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80306b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80306f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803073:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803077:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80307b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803082:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803089:	00 00 00 
  80308c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803093:	00 00 00 
  803096:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80309a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8030a1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030a8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  8030af:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8030b6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8030bd:	48 89 c6             	mov    %rax,%rsi
  8030c0:	bf 01 00 00 00       	mov    $0x1,%edi
  8030c5:	48 b8 c0 2e 80 00 00 	movabs $0x802ec0,%rax
  8030cc:	00 00 00 
  8030cf:	ff d0                	callq  *%rax
  8030d1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8030d7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8030dd:	c9                   	leaveq 
  8030de:	c3                   	retq   

00000000008030df <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8030df:	55                   	push   %rbp
  8030e0:	48 89 e5             	mov    %rsp,%rbp
  8030e3:	53                   	push   %rbx
  8030e4:	48 83 ec 38          	sub    $0x38,%rsp
  8030e8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8030ec:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8030f0:	48 89 c7             	mov    %rax,%rdi
  8030f3:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  8030fa:	00 00 00 
  8030fd:	ff d0                	callq  *%rax
  8030ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803102:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803106:	0f 88 bf 01 00 00    	js     8032cb <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80310c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803110:	ba 07 04 00 00       	mov    $0x407,%edx
  803115:	48 89 c6             	mov    %rax,%rsi
  803118:	bf 00 00 00 00       	mov    $0x0,%edi
  80311d:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  803124:	00 00 00 
  803127:	ff d0                	callq  *%rax
  803129:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80312c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803130:	0f 88 95 01 00 00    	js     8032cb <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803136:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80313a:	48 89 c7             	mov    %rax,%rdi
  80313d:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  803144:	00 00 00 
  803147:	ff d0                	callq  *%rax
  803149:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80314c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803150:	0f 88 5d 01 00 00    	js     8032b3 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803156:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80315a:	ba 07 04 00 00       	mov    $0x407,%edx
  80315f:	48 89 c6             	mov    %rax,%rsi
  803162:	bf 00 00 00 00       	mov    $0x0,%edi
  803167:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  80316e:	00 00 00 
  803171:	ff d0                	callq  *%rax
  803173:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803176:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80317a:	0f 88 33 01 00 00    	js     8032b3 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803180:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803184:	48 89 c7             	mov    %rax,%rdi
  803187:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  80318e:	00 00 00 
  803191:	ff d0                	callq  *%rax
  803193:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803197:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319b:	ba 07 04 00 00       	mov    $0x407,%edx
  8031a0:	48 89 c6             	mov    %rax,%rsi
  8031a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8031a8:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  8031af:	00 00 00 
  8031b2:	ff d0                	callq  *%rax
  8031b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031bb:	79 05                	jns    8031c2 <pipe+0xe3>
		goto err2;
  8031bd:	e9 d9 00 00 00       	jmpq   80329b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031c6:	48 89 c7             	mov    %rax,%rdi
  8031c9:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  8031d0:	00 00 00 
  8031d3:	ff d0                	callq  *%rax
  8031d5:	48 89 c2             	mov    %rax,%rdx
  8031d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031dc:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8031e2:	48 89 d1             	mov    %rdx,%rcx
  8031e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8031ea:	48 89 c6             	mov    %rax,%rsi
  8031ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8031f2:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  8031f9:	00 00 00 
  8031fc:	ff d0                	callq  *%rax
  8031fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803201:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803205:	79 1b                	jns    803222 <pipe+0x143>
		goto err3;
  803207:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803208:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80320c:	48 89 c6             	mov    %rax,%rsi
  80320f:	bf 00 00 00 00       	mov    $0x0,%edi
  803214:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  80321b:	00 00 00 
  80321e:	ff d0                	callq  *%rax
  803220:	eb 79                	jmp    80329b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803222:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803226:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80322d:	00 00 00 
  803230:	8b 12                	mov    (%rdx),%edx
  803232:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803234:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803238:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80323f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803243:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80324a:	00 00 00 
  80324d:	8b 12                	mov    (%rdx),%edx
  80324f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803251:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803255:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80325c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803260:	48 89 c7             	mov    %rax,%rdi
  803263:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  80326a:	00 00 00 
  80326d:	ff d0                	callq  *%rax
  80326f:	89 c2                	mov    %eax,%edx
  803271:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803275:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803277:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80327b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80327f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803283:	48 89 c7             	mov    %rax,%rdi
  803286:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  80328d:	00 00 00 
  803290:	ff d0                	callq  *%rax
  803292:	89 03                	mov    %eax,(%rbx)
	return 0;
  803294:	b8 00 00 00 00       	mov    $0x0,%eax
  803299:	eb 33                	jmp    8032ce <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80329b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80329f:	48 89 c6             	mov    %rax,%rsi
  8032a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8032a7:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  8032ae:	00 00 00 
  8032b1:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8032b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032b7:	48 89 c6             	mov    %rax,%rsi
  8032ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8032bf:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  8032c6:	00 00 00 
  8032c9:	ff d0                	callq  *%rax
err:
	return r;
  8032cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8032ce:	48 83 c4 38          	add    $0x38,%rsp
  8032d2:	5b                   	pop    %rbx
  8032d3:	5d                   	pop    %rbp
  8032d4:	c3                   	retq   

00000000008032d5 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8032d5:	55                   	push   %rbp
  8032d6:	48 89 e5             	mov    %rsp,%rbp
  8032d9:	53                   	push   %rbx
  8032da:	48 83 ec 28          	sub    $0x28,%rsp
  8032de:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8032e6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8032ed:	00 00 00 
  8032f0:	48 8b 00             	mov    (%rax),%rax
  8032f3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8032f9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8032fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803300:	48 89 c7             	mov    %rax,%rdi
  803303:	48 b8 7f 3b 80 00 00 	movabs $0x803b7f,%rax
  80330a:	00 00 00 
  80330d:	ff d0                	callq  *%rax
  80330f:	89 c3                	mov    %eax,%ebx
  803311:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803315:	48 89 c7             	mov    %rax,%rdi
  803318:	48 b8 7f 3b 80 00 00 	movabs $0x803b7f,%rax
  80331f:	00 00 00 
  803322:	ff d0                	callq  *%rax
  803324:	39 c3                	cmp    %eax,%ebx
  803326:	0f 94 c0             	sete   %al
  803329:	0f b6 c0             	movzbl %al,%eax
  80332c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80332f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803336:	00 00 00 
  803339:	48 8b 00             	mov    (%rax),%rax
  80333c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803342:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803345:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803348:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80334b:	75 05                	jne    803352 <_pipeisclosed+0x7d>
			return ret;
  80334d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803350:	eb 4f                	jmp    8033a1 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803352:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803355:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803358:	74 42                	je     80339c <_pipeisclosed+0xc7>
  80335a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80335e:	75 3c                	jne    80339c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803360:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803367:	00 00 00 
  80336a:	48 8b 00             	mov    (%rax),%rax
  80336d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803373:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803376:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803379:	89 c6                	mov    %eax,%esi
  80337b:	48 bf 99 42 80 00 00 	movabs $0x804299,%rdi
  803382:	00 00 00 
  803385:	b8 00 00 00 00       	mov    $0x0,%eax
  80338a:	49 b8 b7 05 80 00 00 	movabs $0x8005b7,%r8
  803391:	00 00 00 
  803394:	41 ff d0             	callq  *%r8
	}
  803397:	e9 4a ff ff ff       	jmpq   8032e6 <_pipeisclosed+0x11>
  80339c:	e9 45 ff ff ff       	jmpq   8032e6 <_pipeisclosed+0x11>
}
  8033a1:	48 83 c4 28          	add    $0x28,%rsp
  8033a5:	5b                   	pop    %rbx
  8033a6:	5d                   	pop    %rbp
  8033a7:	c3                   	retq   

00000000008033a8 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8033a8:	55                   	push   %rbp
  8033a9:	48 89 e5             	mov    %rsp,%rbp
  8033ac:	48 83 ec 30          	sub    $0x30,%rsp
  8033b0:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8033b3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8033b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8033ba:	48 89 d6             	mov    %rdx,%rsi
  8033bd:	89 c7                	mov    %eax,%edi
  8033bf:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  8033c6:	00 00 00 
  8033c9:	ff d0                	callq  *%rax
  8033cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d2:	79 05                	jns    8033d9 <pipeisclosed+0x31>
		return r;
  8033d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d7:	eb 31                	jmp    80340a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8033d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033dd:	48 89 c7             	mov    %rax,%rdi
  8033e0:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  8033e7:	00 00 00 
  8033ea:	ff d0                	callq  *%rax
  8033ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8033f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033f8:	48 89 d6             	mov    %rdx,%rsi
  8033fb:	48 89 c7             	mov    %rax,%rdi
  8033fe:	48 b8 d5 32 80 00 00 	movabs $0x8032d5,%rax
  803405:	00 00 00 
  803408:	ff d0                	callq  *%rax
}
  80340a:	c9                   	leaveq 
  80340b:	c3                   	retq   

000000000080340c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80340c:	55                   	push   %rbp
  80340d:	48 89 e5             	mov    %rsp,%rbp
  803410:	48 83 ec 40          	sub    $0x40,%rsp
  803414:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803418:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80341c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803420:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803424:	48 89 c7             	mov    %rax,%rdi
  803427:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  80342e:	00 00 00 
  803431:	ff d0                	callq  *%rax
  803433:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803437:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80343b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80343f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803446:	00 
  803447:	e9 92 00 00 00       	jmpq   8034de <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80344c:	eb 41                	jmp    80348f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80344e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803453:	74 09                	je     80345e <devpipe_read+0x52>
				return i;
  803455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803459:	e9 92 00 00 00       	jmpq   8034f0 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80345e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803462:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803466:	48 89 d6             	mov    %rdx,%rsi
  803469:	48 89 c7             	mov    %rax,%rdi
  80346c:	48 b8 d5 32 80 00 00 	movabs $0x8032d5,%rax
  803473:	00 00 00 
  803476:	ff d0                	callq  *%rax
  803478:	85 c0                	test   %eax,%eax
  80347a:	74 07                	je     803483 <devpipe_read+0x77>
				return 0;
  80347c:	b8 00 00 00 00       	mov    $0x0,%eax
  803481:	eb 6d                	jmp    8034f0 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803483:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  80348a:	00 00 00 
  80348d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80348f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803493:	8b 10                	mov    (%rax),%edx
  803495:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803499:	8b 40 04             	mov    0x4(%rax),%eax
  80349c:	39 c2                	cmp    %eax,%edx
  80349e:	74 ae                	je     80344e <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8034a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034a8:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8034ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b0:	8b 00                	mov    (%rax),%eax
  8034b2:	99                   	cltd   
  8034b3:	c1 ea 1b             	shr    $0x1b,%edx
  8034b6:	01 d0                	add    %edx,%eax
  8034b8:	83 e0 1f             	and    $0x1f,%eax
  8034bb:	29 d0                	sub    %edx,%eax
  8034bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034c1:	48 98                	cltq   
  8034c3:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8034c8:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8034ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ce:	8b 00                	mov    (%rax),%eax
  8034d0:	8d 50 01             	lea    0x1(%rax),%edx
  8034d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d7:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8034d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8034de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034e2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8034e6:	0f 82 60 ff ff ff    	jb     80344c <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8034ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8034f0:	c9                   	leaveq 
  8034f1:	c3                   	retq   

00000000008034f2 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8034f2:	55                   	push   %rbp
  8034f3:	48 89 e5             	mov    %rsp,%rbp
  8034f6:	48 83 ec 40          	sub    $0x40,%rsp
  8034fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803502:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803506:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80350a:	48 89 c7             	mov    %rax,%rdi
  80350d:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  803514:	00 00 00 
  803517:	ff d0                	callq  *%rax
  803519:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80351d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803521:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803525:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80352c:	00 
  80352d:	e9 8e 00 00 00       	jmpq   8035c0 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803532:	eb 31                	jmp    803565 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803534:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803538:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80353c:	48 89 d6             	mov    %rdx,%rsi
  80353f:	48 89 c7             	mov    %rax,%rdi
  803542:	48 b8 d5 32 80 00 00 	movabs $0x8032d5,%rax
  803549:	00 00 00 
  80354c:	ff d0                	callq  *%rax
  80354e:	85 c0                	test   %eax,%eax
  803550:	74 07                	je     803559 <devpipe_write+0x67>
				return 0;
  803552:	b8 00 00 00 00       	mov    $0x0,%eax
  803557:	eb 79                	jmp    8035d2 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803559:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  803560:	00 00 00 
  803563:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803565:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803569:	8b 40 04             	mov    0x4(%rax),%eax
  80356c:	48 63 d0             	movslq %eax,%rdx
  80356f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803573:	8b 00                	mov    (%rax),%eax
  803575:	48 98                	cltq   
  803577:	48 83 c0 20          	add    $0x20,%rax
  80357b:	48 39 c2             	cmp    %rax,%rdx
  80357e:	73 b4                	jae    803534 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803584:	8b 40 04             	mov    0x4(%rax),%eax
  803587:	99                   	cltd   
  803588:	c1 ea 1b             	shr    $0x1b,%edx
  80358b:	01 d0                	add    %edx,%eax
  80358d:	83 e0 1f             	and    $0x1f,%eax
  803590:	29 d0                	sub    %edx,%eax
  803592:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803596:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80359a:	48 01 ca             	add    %rcx,%rdx
  80359d:	0f b6 0a             	movzbl (%rdx),%ecx
  8035a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035a4:	48 98                	cltq   
  8035a6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8035aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ae:	8b 40 04             	mov    0x4(%rax),%eax
  8035b1:	8d 50 01             	lea    0x1(%rax),%edx
  8035b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b8:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8035bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035c8:	0f 82 64 ff ff ff    	jb     803532 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8035ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035d2:	c9                   	leaveq 
  8035d3:	c3                   	retq   

00000000008035d4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8035d4:	55                   	push   %rbp
  8035d5:	48 89 e5             	mov    %rsp,%rbp
  8035d8:	48 83 ec 20          	sub    $0x20,%rsp
  8035dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8035e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e8:	48 89 c7             	mov    %rax,%rdi
  8035eb:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  8035f2:	00 00 00 
  8035f5:	ff d0                	callq  *%rax
  8035f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8035fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035ff:	48 be ac 42 80 00 00 	movabs $0x8042ac,%rsi
  803606:	00 00 00 
  803609:	48 89 c7             	mov    %rax,%rdi
  80360c:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  803613:	00 00 00 
  803616:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80361c:	8b 50 04             	mov    0x4(%rax),%edx
  80361f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803623:	8b 00                	mov    (%rax),%eax
  803625:	29 c2                	sub    %eax,%edx
  803627:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80362b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803631:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803635:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80363c:	00 00 00 
	stat->st_dev = &devpipe;
  80363f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803643:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  80364a:	00 00 00 
  80364d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803654:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803659:	c9                   	leaveq 
  80365a:	c3                   	retq   

000000000080365b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80365b:	55                   	push   %rbp
  80365c:	48 89 e5             	mov    %rsp,%rbp
  80365f:	48 83 ec 10          	sub    $0x10,%rsp
  803663:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803667:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80366b:	48 89 c6             	mov    %rax,%rsi
  80366e:	bf 00 00 00 00       	mov    $0x0,%edi
  803673:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  80367a:	00 00 00 
  80367d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80367f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803683:	48 89 c7             	mov    %rax,%rdi
  803686:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  80368d:	00 00 00 
  803690:	ff d0                	callq  *%rax
  803692:	48 89 c6             	mov    %rax,%rsi
  803695:	bf 00 00 00 00       	mov    $0x0,%edi
  80369a:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  8036a1:	00 00 00 
  8036a4:	ff d0                	callq  *%rax
}
  8036a6:	c9                   	leaveq 
  8036a7:	c3                   	retq   

00000000008036a8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8036a8:	55                   	push   %rbp
  8036a9:	48 89 e5             	mov    %rsp,%rbp
  8036ac:	48 83 ec 20          	sub    $0x20,%rsp
  8036b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8036b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036b6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8036b9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8036bd:	be 01 00 00 00       	mov    $0x1,%esi
  8036c2:	48 89 c7             	mov    %rax,%rdi
  8036c5:	48 b8 94 19 80 00 00 	movabs $0x801994,%rax
  8036cc:	00 00 00 
  8036cf:	ff d0                	callq  *%rax
}
  8036d1:	c9                   	leaveq 
  8036d2:	c3                   	retq   

00000000008036d3 <getchar>:

int
getchar(void)
{
  8036d3:	55                   	push   %rbp
  8036d4:	48 89 e5             	mov    %rsp,%rbp
  8036d7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8036db:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8036df:	ba 01 00 00 00       	mov    $0x1,%edx
  8036e4:	48 89 c6             	mov    %rax,%rsi
  8036e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8036ec:	48 b8 8f 23 80 00 00 	movabs $0x80238f,%rax
  8036f3:	00 00 00 
  8036f6:	ff d0                	callq  *%rax
  8036f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8036fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ff:	79 05                	jns    803706 <getchar+0x33>
		return r;
  803701:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803704:	eb 14                	jmp    80371a <getchar+0x47>
	if (r < 1)
  803706:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80370a:	7f 07                	jg     803713 <getchar+0x40>
		return -E_EOF;
  80370c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803711:	eb 07                	jmp    80371a <getchar+0x47>
	return c;
  803713:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803717:	0f b6 c0             	movzbl %al,%eax
}
  80371a:	c9                   	leaveq 
  80371b:	c3                   	retq   

000000000080371c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80371c:	55                   	push   %rbp
  80371d:	48 89 e5             	mov    %rsp,%rbp
  803720:	48 83 ec 20          	sub    $0x20,%rsp
  803724:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803727:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80372b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80372e:	48 89 d6             	mov    %rdx,%rsi
  803731:	89 c7                	mov    %eax,%edi
  803733:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  80373a:	00 00 00 
  80373d:	ff d0                	callq  *%rax
  80373f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803742:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803746:	79 05                	jns    80374d <iscons+0x31>
		return r;
  803748:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80374b:	eb 1a                	jmp    803767 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80374d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803751:	8b 10                	mov    (%rax),%edx
  803753:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80375a:	00 00 00 
  80375d:	8b 00                	mov    (%rax),%eax
  80375f:	39 c2                	cmp    %eax,%edx
  803761:	0f 94 c0             	sete   %al
  803764:	0f b6 c0             	movzbl %al,%eax
}
  803767:	c9                   	leaveq 
  803768:	c3                   	retq   

0000000000803769 <opencons>:

int
opencons(void)
{
  803769:	55                   	push   %rbp
  80376a:	48 89 e5             	mov    %rsp,%rbp
  80376d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803771:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803775:	48 89 c7             	mov    %rax,%rdi
  803778:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  80377f:	00 00 00 
  803782:	ff d0                	callq  *%rax
  803784:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803787:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80378b:	79 05                	jns    803792 <opencons+0x29>
		return r;
  80378d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803790:	eb 5b                	jmp    8037ed <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803792:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803796:	ba 07 04 00 00       	mov    $0x407,%edx
  80379b:	48 89 c6             	mov    %rax,%rsi
  80379e:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a3:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  8037aa:	00 00 00 
  8037ad:	ff d0                	callq  *%rax
  8037af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037b6:	79 05                	jns    8037bd <opencons+0x54>
		return r;
  8037b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037bb:	eb 30                	jmp    8037ed <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8037bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c1:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8037c8:	00 00 00 
  8037cb:	8b 12                	mov    (%rdx),%edx
  8037cd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8037cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8037da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037de:	48 89 c7             	mov    %rax,%rdi
  8037e1:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  8037e8:	00 00 00 
  8037eb:	ff d0                	callq  *%rax
}
  8037ed:	c9                   	leaveq 
  8037ee:	c3                   	retq   

00000000008037ef <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037ef:	55                   	push   %rbp
  8037f0:	48 89 e5             	mov    %rsp,%rbp
  8037f3:	48 83 ec 30          	sub    $0x30,%rsp
  8037f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803803:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803808:	75 07                	jne    803811 <devcons_read+0x22>
		return 0;
  80380a:	b8 00 00 00 00       	mov    $0x0,%eax
  80380f:	eb 4b                	jmp    80385c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803811:	eb 0c                	jmp    80381f <devcons_read+0x30>
		sys_yield();
  803813:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  80381a:	00 00 00 
  80381d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80381f:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  803826:	00 00 00 
  803829:	ff d0                	callq  *%rax
  80382b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80382e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803832:	74 df                	je     803813 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803834:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803838:	79 05                	jns    80383f <devcons_read+0x50>
		return c;
  80383a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80383d:	eb 1d                	jmp    80385c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80383f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803843:	75 07                	jne    80384c <devcons_read+0x5d>
		return 0;
  803845:	b8 00 00 00 00       	mov    $0x0,%eax
  80384a:	eb 10                	jmp    80385c <devcons_read+0x6d>
	*(char*)vbuf = c;
  80384c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384f:	89 c2                	mov    %eax,%edx
  803851:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803855:	88 10                	mov    %dl,(%rax)
	return 1;
  803857:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80385c:	c9                   	leaveq 
  80385d:	c3                   	retq   

000000000080385e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80385e:	55                   	push   %rbp
  80385f:	48 89 e5             	mov    %rsp,%rbp
  803862:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803869:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803870:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803877:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80387e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803885:	eb 76                	jmp    8038fd <devcons_write+0x9f>
		m = n - tot;
  803887:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80388e:	89 c2                	mov    %eax,%edx
  803890:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803893:	29 c2                	sub    %eax,%edx
  803895:	89 d0                	mov    %edx,%eax
  803897:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80389a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80389d:	83 f8 7f             	cmp    $0x7f,%eax
  8038a0:	76 07                	jbe    8038a9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8038a2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8038a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038ac:	48 63 d0             	movslq %eax,%rdx
  8038af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b2:	48 63 c8             	movslq %eax,%rcx
  8038b5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8038bc:	48 01 c1             	add    %rax,%rcx
  8038bf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8038c6:	48 89 ce             	mov    %rcx,%rsi
  8038c9:	48 89 c7             	mov    %rax,%rdi
  8038cc:	48 b8 d1 14 80 00 00 	movabs $0x8014d1,%rax
  8038d3:	00 00 00 
  8038d6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8038d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038db:	48 63 d0             	movslq %eax,%rdx
  8038de:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8038e5:	48 89 d6             	mov    %rdx,%rsi
  8038e8:	48 89 c7             	mov    %rax,%rdi
  8038eb:	48 b8 94 19 80 00 00 	movabs $0x801994,%rax
  8038f2:	00 00 00 
  8038f5:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8038f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038fa:	01 45 fc             	add    %eax,-0x4(%rbp)
  8038fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803900:	48 98                	cltq   
  803902:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803909:	0f 82 78 ff ff ff    	jb     803887 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80390f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803912:	c9                   	leaveq 
  803913:	c3                   	retq   

0000000000803914 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803914:	55                   	push   %rbp
  803915:	48 89 e5             	mov    %rsp,%rbp
  803918:	48 83 ec 08          	sub    $0x8,%rsp
  80391c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803920:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803925:	c9                   	leaveq 
  803926:	c3                   	retq   

0000000000803927 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803927:	55                   	push   %rbp
  803928:	48 89 e5             	mov    %rsp,%rbp
  80392b:	48 83 ec 10          	sub    $0x10,%rsp
  80392f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803933:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803937:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80393b:	48 be b8 42 80 00 00 	movabs $0x8042b8,%rsi
  803942:	00 00 00 
  803945:	48 89 c7             	mov    %rax,%rdi
  803948:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  80394f:	00 00 00 
  803952:	ff d0                	callq  *%rax
	return 0;
  803954:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803959:	c9                   	leaveq 
  80395a:	c3                   	retq   

000000000080395b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80395b:	55                   	push   %rbp
  80395c:	48 89 e5             	mov    %rsp,%rbp
  80395f:	48 83 ec 30          	sub    $0x30,%rsp
  803963:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803967:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80396b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  80396f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803974:	75 08                	jne    80397e <ipc_recv+0x23>
  803976:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  80397d:	ff 
	int res=sys_ipc_recv(pg);
  80397e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803982:	48 89 c7             	mov    %rax,%rdi
  803985:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  80398c:	00 00 00 
  80398f:	ff d0                	callq  *%rax
  803991:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  803994:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803999:	74 26                	je     8039c1 <ipc_recv+0x66>
  80399b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80399f:	75 15                	jne    8039b6 <ipc_recv+0x5b>
  8039a1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039a8:	00 00 00 
  8039ab:	48 8b 00             	mov    (%rax),%rax
  8039ae:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  8039b4:	eb 05                	jmp    8039bb <ipc_recv+0x60>
  8039b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039bf:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  8039c1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039c6:	74 26                	je     8039ee <ipc_recv+0x93>
  8039c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039cc:	75 15                	jne    8039e3 <ipc_recv+0x88>
  8039ce:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039d5:	00 00 00 
  8039d8:	48 8b 00             	mov    (%rax),%rax
  8039db:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  8039e1:	eb 05                	jmp    8039e8 <ipc_recv+0x8d>
  8039e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8039ec:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  8039ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039f2:	75 15                	jne    803a09 <ipc_recv+0xae>
  8039f4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039fb:	00 00 00 
  8039fe:	48 8b 00             	mov    (%rax),%rax
  803a01:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803a07:	eb 03                	jmp    803a0c <ipc_recv+0xb1>
  803a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  803a0c:	c9                   	leaveq 
  803a0d:	c3                   	retq   

0000000000803a0e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a0e:	55                   	push   %rbp
  803a0f:	48 89 e5             	mov    %rsp,%rbp
  803a12:	48 83 ec 30          	sub    $0x30,%rsp
  803a16:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a19:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a1c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803a20:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  803a23:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a28:	75 0a                	jne    803a34 <ipc_send+0x26>
  803a2a:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  803a31:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  803a32:	eb 3e                	jmp    803a72 <ipc_send+0x64>
  803a34:	eb 3c                	jmp    803a72 <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  803a36:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803a3a:	74 2a                	je     803a66 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  803a3c:	48 ba c0 42 80 00 00 	movabs $0x8042c0,%rdx
  803a43:	00 00 00 
  803a46:	be 39 00 00 00       	mov    $0x39,%esi
  803a4b:	48 bf eb 42 80 00 00 	movabs $0x8042eb,%rdi
  803a52:	00 00 00 
  803a55:	b8 00 00 00 00       	mov    $0x0,%eax
  803a5a:	48 b9 7e 03 80 00 00 	movabs $0x80037e,%rcx
  803a61:	00 00 00 
  803a64:	ff d1                	callq  *%rcx
		sys_yield();  
  803a66:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  803a6d:	00 00 00 
  803a70:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  803a72:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803a75:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803a78:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803a7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a7f:	89 c7                	mov    %eax,%edi
  803a81:	48 b8 fb 1c 80 00 00 	movabs $0x801cfb,%rax
  803a88:	00 00 00 
  803a8b:	ff d0                	callq  *%rax
  803a8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a94:	78 a0                	js     803a36 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  803a96:	c9                   	leaveq 
  803a97:	c3                   	retq   

0000000000803a98 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803a98:	55                   	push   %rbp
  803a99:	48 89 e5             	mov    %rsp,%rbp
  803a9c:	48 83 ec 10          	sub    $0x10,%rsp
  803aa0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  803aa4:	48 ba f8 42 80 00 00 	movabs $0x8042f8,%rdx
  803aab:	00 00 00 
  803aae:	be 47 00 00 00       	mov    $0x47,%esi
  803ab3:	48 bf eb 42 80 00 00 	movabs $0x8042eb,%rdi
  803aba:	00 00 00 
  803abd:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac2:	48 b9 7e 03 80 00 00 	movabs $0x80037e,%rcx
  803ac9:	00 00 00 
  803acc:	ff d1                	callq  *%rcx

0000000000803ace <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ace:	55                   	push   %rbp
  803acf:	48 89 e5             	mov    %rsp,%rbp
  803ad2:	48 83 ec 20          	sub    $0x20,%rsp
  803ad6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ad9:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803adc:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803ae0:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  803ae3:	48 ba 20 43 80 00 00 	movabs $0x804320,%rdx
  803aea:	00 00 00 
  803aed:	be 50 00 00 00       	mov    $0x50,%esi
  803af2:	48 bf eb 42 80 00 00 	movabs $0x8042eb,%rdi
  803af9:	00 00 00 
  803afc:	b8 00 00 00 00       	mov    $0x0,%eax
  803b01:	48 b9 7e 03 80 00 00 	movabs $0x80037e,%rcx
  803b08:	00 00 00 
  803b0b:	ff d1                	callq  *%rcx

0000000000803b0d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b0d:	55                   	push   %rbp
  803b0e:	48 89 e5             	mov    %rsp,%rbp
  803b11:	48 83 ec 14          	sub    $0x14,%rsp
  803b15:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803b18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b1f:	eb 4e                	jmp    803b6f <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803b21:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803b28:	00 00 00 
  803b2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2e:	48 98                	cltq   
  803b30:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  803b37:	48 01 d0             	add    %rdx,%rax
  803b3a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b40:	8b 00                	mov    (%rax),%eax
  803b42:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b45:	75 24                	jne    803b6b <ipc_find_env+0x5e>
			return envs[i].env_id;
  803b47:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803b4e:	00 00 00 
  803b51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b54:	48 98                	cltq   
  803b56:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  803b5d:	48 01 d0             	add    %rdx,%rax
  803b60:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803b66:	8b 40 08             	mov    0x8(%rax),%eax
  803b69:	eb 12                	jmp    803b7d <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803b6b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803b6f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803b76:	7e a9                	jle    803b21 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  803b78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b7d:	c9                   	leaveq 
  803b7e:	c3                   	retq   

0000000000803b7f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803b7f:	55                   	push   %rbp
  803b80:	48 89 e5             	mov    %rsp,%rbp
  803b83:	48 83 ec 18          	sub    $0x18,%rsp
  803b87:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803b8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b8f:	48 c1 e8 15          	shr    $0x15,%rax
  803b93:	48 89 c2             	mov    %rax,%rdx
  803b96:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b9d:	01 00 00 
  803ba0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ba4:	83 e0 01             	and    $0x1,%eax
  803ba7:	48 85 c0             	test   %rax,%rax
  803baa:	75 07                	jne    803bb3 <pageref+0x34>
		return 0;
  803bac:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb1:	eb 53                	jmp    803c06 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803bb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bb7:	48 c1 e8 0c          	shr    $0xc,%rax
  803bbb:	48 89 c2             	mov    %rax,%rdx
  803bbe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803bc5:	01 00 00 
  803bc8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bcc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803bd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bd4:	83 e0 01             	and    $0x1,%eax
  803bd7:	48 85 c0             	test   %rax,%rax
  803bda:	75 07                	jne    803be3 <pageref+0x64>
		return 0;
  803bdc:	b8 00 00 00 00       	mov    $0x0,%eax
  803be1:	eb 23                	jmp    803c06 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803be3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803be7:	48 c1 e8 0c          	shr    $0xc,%rax
  803beb:	48 89 c2             	mov    %rax,%rdx
  803bee:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803bf5:	00 00 00 
  803bf8:	48 c1 e2 04          	shl    $0x4,%rdx
  803bfc:	48 01 d0             	add    %rdx,%rax
  803bff:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c03:	0f b7 c0             	movzwl %ax,%eax
}
  803c06:	c9                   	leaveq 
  803c07:	c3                   	retq   
