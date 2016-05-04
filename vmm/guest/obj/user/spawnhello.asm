
vmm/guest/obj/user/spawnhello:     file format elf64-x86-64


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
  80003c:	e8 a6 00 00 00       	callq  8000e7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800052:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf c0 42 80 00 00 	movabs $0x8042c0,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba c6 03 80 00 00 	movabs $0x8003c6,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	if ((r = spawnl("/bin/hello", "hello", 0)) < 0)
  800082:	ba 00 00 00 00       	mov    $0x0,%edx
  800087:	48 be de 42 80 00 00 	movabs $0x8042de,%rsi
  80008e:	00 00 00 
  800091:	48 bf e4 42 80 00 00 	movabs $0x8042e4,%rdi
  800098:	00 00 00 
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	48 b9 3d 2f 80 00 00 	movabs $0x802f3d,%rcx
  8000a7:	00 00 00 
  8000aa:	ff d1                	callq  *%rcx
  8000ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b3:	79 30                	jns    8000e5 <umain+0xa2>
		panic("spawn(hello) failed: %e", r);
  8000b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b8:	89 c1                	mov    %eax,%ecx
  8000ba:	48 ba ef 42 80 00 00 	movabs $0x8042ef,%rdx
  8000c1:	00 00 00 
  8000c4:	be 09 00 00 00       	mov    $0x9,%esi
  8000c9:	48 bf 07 43 80 00 00 	movabs $0x804307,%rdi
  8000d0:	00 00 00 
  8000d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d8:	49 b8 8d 01 80 00 00 	movabs $0x80018d,%r8
  8000df:	00 00 00 
  8000e2:	41 ff d0             	callq  *%r8
}
  8000e5:	c9                   	leaveq 
  8000e6:	c3                   	retq   

00000000008000e7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e7:	55                   	push   %rbp
  8000e8:	48 89 e5             	mov    %rsp,%rbp
  8000eb:	48 83 ec 10          	sub    $0x10,%rsp
  8000ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  8000f6:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
  800102:	48 98                	cltq   
  800104:	25 ff 03 00 00       	and    $0x3ff,%eax
  800109:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  800110:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800117:	00 00 00 
  80011a:	48 01 c2             	add    %rax,%rdx
  80011d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800124:	00 00 00 
  800127:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80012e:	7e 14                	jle    800144 <libmain+0x5d>
		binaryname = argv[0];
  800130:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800134:	48 8b 10             	mov    (%rax),%rdx
  800137:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80013e:	00 00 00 
  800141:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800144:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800148:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014b:	48 89 d6             	mov    %rdx,%rsi
  80014e:	89 c7                	mov    %eax,%edi
  800150:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80015c:	48 b8 6a 01 80 00 00 	movabs $0x80016a,%rax
  800163:	00 00 00 
  800166:	ff d0                	callq  *%rax
}
  800168:	c9                   	leaveq 
  800169:	c3                   	retq   

000000000080016a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80016a:	55                   	push   %rbp
  80016b:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80016e:	48 b8 c7 1f 80 00 00 	movabs $0x801fc7,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80017a:	bf 00 00 00 00       	mov    $0x0,%edi
  80017f:	48 b8 2b 18 80 00 00 	movabs $0x80182b,%rax
  800186:	00 00 00 
  800189:	ff d0                	callq  *%rax
}
  80018b:	5d                   	pop    %rbp
  80018c:	c3                   	retq   

000000000080018d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018d:	55                   	push   %rbp
  80018e:	48 89 e5             	mov    %rsp,%rbp
  800191:	53                   	push   %rbx
  800192:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800199:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8001a0:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8001a6:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8001ad:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8001b4:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8001bb:	84 c0                	test   %al,%al
  8001bd:	74 23                	je     8001e2 <_panic+0x55>
  8001bf:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8001c6:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8001ca:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8001ce:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8001d2:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8001d6:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8001da:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8001de:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8001e2:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8001e9:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8001f0:	00 00 00 
  8001f3:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8001fa:	00 00 00 
  8001fd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800201:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800208:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80020f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800216:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80021d:	00 00 00 
  800220:	48 8b 18             	mov    (%rax),%rbx
  800223:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  80022a:	00 00 00 
  80022d:	ff d0                	callq  *%rax
  80022f:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800235:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80023c:	41 89 c8             	mov    %ecx,%r8d
  80023f:	48 89 d1             	mov    %rdx,%rcx
  800242:	48 89 da             	mov    %rbx,%rdx
  800245:	89 c6                	mov    %eax,%esi
  800247:	48 bf 28 43 80 00 00 	movabs $0x804328,%rdi
  80024e:	00 00 00 
  800251:	b8 00 00 00 00       	mov    $0x0,%eax
  800256:	49 b9 c6 03 80 00 00 	movabs $0x8003c6,%r9
  80025d:	00 00 00 
  800260:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800263:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80026a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800271:	48 89 d6             	mov    %rdx,%rsi
  800274:	48 89 c7             	mov    %rax,%rdi
  800277:	48 b8 1a 03 80 00 00 	movabs $0x80031a,%rax
  80027e:	00 00 00 
  800281:	ff d0                	callq  *%rax
	cprintf("\n");
  800283:	48 bf 4b 43 80 00 00 	movabs $0x80434b,%rdi
  80028a:	00 00 00 
  80028d:	b8 00 00 00 00       	mov    $0x0,%eax
  800292:	48 ba c6 03 80 00 00 	movabs $0x8003c6,%rdx
  800299:	00 00 00 
  80029c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80029e:	cc                   	int3   
  80029f:	eb fd                	jmp    80029e <_panic+0x111>

00000000008002a1 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8002a1:	55                   	push   %rbp
  8002a2:	48 89 e5             	mov    %rsp,%rbp
  8002a5:	48 83 ec 10          	sub    $0x10,%rsp
  8002a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8002b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002b4:	8b 00                	mov    (%rax),%eax
  8002b6:	8d 48 01             	lea    0x1(%rax),%ecx
  8002b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002bd:	89 0a                	mov    %ecx,(%rdx)
  8002bf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002c2:	89 d1                	mov    %edx,%ecx
  8002c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c8:	48 98                	cltq   
  8002ca:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8002ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d2:	8b 00                	mov    (%rax),%eax
  8002d4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d9:	75 2c                	jne    800307 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002df:	8b 00                	mov    (%rax),%eax
  8002e1:	48 98                	cltq   
  8002e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002e7:	48 83 c2 08          	add    $0x8,%rdx
  8002eb:	48 89 c6             	mov    %rax,%rsi
  8002ee:	48 89 d7             	mov    %rdx,%rdi
  8002f1:	48 b8 a3 17 80 00 00 	movabs $0x8017a3,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
        b->idx = 0;
  8002fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800301:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800307:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80030b:	8b 40 04             	mov    0x4(%rax),%eax
  80030e:	8d 50 01             	lea    0x1(%rax),%edx
  800311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800315:	89 50 04             	mov    %edx,0x4(%rax)
}
  800318:	c9                   	leaveq 
  800319:	c3                   	retq   

000000000080031a <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80031a:	55                   	push   %rbp
  80031b:	48 89 e5             	mov    %rsp,%rbp
  80031e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800325:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80032c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800333:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80033a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800341:	48 8b 0a             	mov    (%rdx),%rcx
  800344:	48 89 08             	mov    %rcx,(%rax)
  800347:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80034b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80034f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800353:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800357:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80035e:	00 00 00 
    b.cnt = 0;
  800361:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800368:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80036b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800372:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800379:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800380:	48 89 c6             	mov    %rax,%rsi
  800383:	48 bf a1 02 80 00 00 	movabs $0x8002a1,%rdi
  80038a:	00 00 00 
  80038d:	48 b8 79 07 80 00 00 	movabs $0x800779,%rax
  800394:	00 00 00 
  800397:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800399:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80039f:	48 98                	cltq   
  8003a1:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003a8:	48 83 c2 08          	add    $0x8,%rdx
  8003ac:	48 89 c6             	mov    %rax,%rsi
  8003af:	48 89 d7             	mov    %rdx,%rdi
  8003b2:	48 b8 a3 17 80 00 00 	movabs $0x8017a3,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003be:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003c4:	c9                   	leaveq 
  8003c5:	c3                   	retq   

00000000008003c6 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003c6:	55                   	push   %rbp
  8003c7:	48 89 e5             	mov    %rsp,%rbp
  8003ca:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003d1:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003d8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003df:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003e6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003ed:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003f4:	84 c0                	test   %al,%al
  8003f6:	74 20                	je     800418 <cprintf+0x52>
  8003f8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003fc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800400:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800404:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800408:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80040c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800410:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800414:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800418:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80041f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800426:	00 00 00 
  800429:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800430:	00 00 00 
  800433:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800437:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80043e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800445:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80044c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800453:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80045a:	48 8b 0a             	mov    (%rdx),%rcx
  80045d:	48 89 08             	mov    %rcx,(%rax)
  800460:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800464:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800468:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80046c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800470:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800477:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80047e:	48 89 d6             	mov    %rdx,%rsi
  800481:	48 89 c7             	mov    %rax,%rdi
  800484:	48 b8 1a 03 80 00 00 	movabs $0x80031a,%rax
  80048b:	00 00 00 
  80048e:	ff d0                	callq  *%rax
  800490:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800496:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80049c:	c9                   	leaveq 
  80049d:	c3                   	retq   

000000000080049e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80049e:	55                   	push   %rbp
  80049f:	48 89 e5             	mov    %rsp,%rbp
  8004a2:	53                   	push   %rbx
  8004a3:	48 83 ec 38          	sub    $0x38,%rsp
  8004a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004b3:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004b6:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8004ba:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004be:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004c1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004c5:	77 3b                	ja     800502 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004c7:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8004ca:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004ce:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004da:	48 f7 f3             	div    %rbx
  8004dd:	48 89 c2             	mov    %rax,%rdx
  8004e0:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004e3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004e6:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ee:	41 89 f9             	mov    %edi,%r9d
  8004f1:	48 89 c7             	mov    %rax,%rdi
  8004f4:	48 b8 9e 04 80 00 00 	movabs $0x80049e,%rax
  8004fb:	00 00 00 
  8004fe:	ff d0                	callq  *%rax
  800500:	eb 1e                	jmp    800520 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800502:	eb 12                	jmp    800516 <printnum+0x78>
			putch(padc, putdat);
  800504:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800508:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80050b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050f:	48 89 ce             	mov    %rcx,%rsi
  800512:	89 d7                	mov    %edx,%edi
  800514:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800516:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80051a:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80051e:	7f e4                	jg     800504 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800520:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800523:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800527:	ba 00 00 00 00       	mov    $0x0,%edx
  80052c:	48 f7 f1             	div    %rcx
  80052f:	48 89 d0             	mov    %rdx,%rax
  800532:	48 ba 50 45 80 00 00 	movabs $0x804550,%rdx
  800539:	00 00 00 
  80053c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800540:	0f be d0             	movsbl %al,%edx
  800543:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800547:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054b:	48 89 ce             	mov    %rcx,%rsi
  80054e:	89 d7                	mov    %edx,%edi
  800550:	ff d0                	callq  *%rax
}
  800552:	48 83 c4 38          	add    $0x38,%rsp
  800556:	5b                   	pop    %rbx
  800557:	5d                   	pop    %rbp
  800558:	c3                   	retq   

0000000000800559 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800559:	55                   	push   %rbp
  80055a:	48 89 e5             	mov    %rsp,%rbp
  80055d:	48 83 ec 1c          	sub    $0x1c,%rsp
  800561:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800565:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800568:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80056c:	7e 52                	jle    8005c0 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80056e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800572:	8b 00                	mov    (%rax),%eax
  800574:	83 f8 30             	cmp    $0x30,%eax
  800577:	73 24                	jae    80059d <getuint+0x44>
  800579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800585:	8b 00                	mov    (%rax),%eax
  800587:	89 c0                	mov    %eax,%eax
  800589:	48 01 d0             	add    %rdx,%rax
  80058c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800590:	8b 12                	mov    (%rdx),%edx
  800592:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800595:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800599:	89 0a                	mov    %ecx,(%rdx)
  80059b:	eb 17                	jmp    8005b4 <getuint+0x5b>
  80059d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a5:	48 89 d0             	mov    %rdx,%rax
  8005a8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b4:	48 8b 00             	mov    (%rax),%rax
  8005b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005bb:	e9 a3 00 00 00       	jmpq   800663 <getuint+0x10a>
	else if (lflag)
  8005c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005c4:	74 4f                	je     800615 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ca:	8b 00                	mov    (%rax),%eax
  8005cc:	83 f8 30             	cmp    $0x30,%eax
  8005cf:	73 24                	jae    8005f5 <getuint+0x9c>
  8005d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dd:	8b 00                	mov    (%rax),%eax
  8005df:	89 c0                	mov    %eax,%eax
  8005e1:	48 01 d0             	add    %rdx,%rax
  8005e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e8:	8b 12                	mov    (%rdx),%edx
  8005ea:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f1:	89 0a                	mov    %ecx,(%rdx)
  8005f3:	eb 17                	jmp    80060c <getuint+0xb3>
  8005f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005fd:	48 89 d0             	mov    %rdx,%rax
  800600:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800604:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800608:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80060c:	48 8b 00             	mov    (%rax),%rax
  80060f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800613:	eb 4e                	jmp    800663 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800615:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800619:	8b 00                	mov    (%rax),%eax
  80061b:	83 f8 30             	cmp    $0x30,%eax
  80061e:	73 24                	jae    800644 <getuint+0xeb>
  800620:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800624:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800628:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062c:	8b 00                	mov    (%rax),%eax
  80062e:	89 c0                	mov    %eax,%eax
  800630:	48 01 d0             	add    %rdx,%rax
  800633:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800637:	8b 12                	mov    (%rdx),%edx
  800639:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80063c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800640:	89 0a                	mov    %ecx,(%rdx)
  800642:	eb 17                	jmp    80065b <getuint+0x102>
  800644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800648:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80064c:	48 89 d0             	mov    %rdx,%rax
  80064f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800653:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800657:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80065b:	8b 00                	mov    (%rax),%eax
  80065d:	89 c0                	mov    %eax,%eax
  80065f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800663:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800667:	c9                   	leaveq 
  800668:	c3                   	retq   

0000000000800669 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800669:	55                   	push   %rbp
  80066a:	48 89 e5             	mov    %rsp,%rbp
  80066d:	48 83 ec 1c          	sub    $0x1c,%rsp
  800671:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800675:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800678:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80067c:	7e 52                	jle    8006d0 <getint+0x67>
		x=va_arg(*ap, long long);
  80067e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800682:	8b 00                	mov    (%rax),%eax
  800684:	83 f8 30             	cmp    $0x30,%eax
  800687:	73 24                	jae    8006ad <getint+0x44>
  800689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800695:	8b 00                	mov    (%rax),%eax
  800697:	89 c0                	mov    %eax,%eax
  800699:	48 01 d0             	add    %rdx,%rax
  80069c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a0:	8b 12                	mov    (%rdx),%edx
  8006a2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a9:	89 0a                	mov    %ecx,(%rdx)
  8006ab:	eb 17                	jmp    8006c4 <getint+0x5b>
  8006ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b5:	48 89 d0             	mov    %rdx,%rax
  8006b8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c4:	48 8b 00             	mov    (%rax),%rax
  8006c7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006cb:	e9 a3 00 00 00       	jmpq   800773 <getint+0x10a>
	else if (lflag)
  8006d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006d4:	74 4f                	je     800725 <getint+0xbc>
		x=va_arg(*ap, long);
  8006d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006da:	8b 00                	mov    (%rax),%eax
  8006dc:	83 f8 30             	cmp    $0x30,%eax
  8006df:	73 24                	jae    800705 <getint+0x9c>
  8006e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ed:	8b 00                	mov    (%rax),%eax
  8006ef:	89 c0                	mov    %eax,%eax
  8006f1:	48 01 d0             	add    %rdx,%rax
  8006f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f8:	8b 12                	mov    (%rdx),%edx
  8006fa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800701:	89 0a                	mov    %ecx,(%rdx)
  800703:	eb 17                	jmp    80071c <getint+0xb3>
  800705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800709:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80070d:	48 89 d0             	mov    %rdx,%rax
  800710:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800714:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800718:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071c:	48 8b 00             	mov    (%rax),%rax
  80071f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800723:	eb 4e                	jmp    800773 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800725:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800729:	8b 00                	mov    (%rax),%eax
  80072b:	83 f8 30             	cmp    $0x30,%eax
  80072e:	73 24                	jae    800754 <getint+0xeb>
  800730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800734:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	8b 00                	mov    (%rax),%eax
  80073e:	89 c0                	mov    %eax,%eax
  800740:	48 01 d0             	add    %rdx,%rax
  800743:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800747:	8b 12                	mov    (%rdx),%edx
  800749:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80074c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800750:	89 0a                	mov    %ecx,(%rdx)
  800752:	eb 17                	jmp    80076b <getint+0x102>
  800754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800758:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80075c:	48 89 d0             	mov    %rdx,%rax
  80075f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800763:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800767:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80076b:	8b 00                	mov    (%rax),%eax
  80076d:	48 98                	cltq   
  80076f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800773:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800777:	c9                   	leaveq 
  800778:	c3                   	retq   

0000000000800779 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800779:	55                   	push   %rbp
  80077a:	48 89 e5             	mov    %rsp,%rbp
  80077d:	41 54                	push   %r12
  80077f:	53                   	push   %rbx
  800780:	48 83 ec 60          	sub    $0x60,%rsp
  800784:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800788:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80078c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800790:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800794:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800798:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80079c:	48 8b 0a             	mov    (%rdx),%rcx
  80079f:	48 89 08             	mov    %rcx,(%rax)
  8007a2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007a6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007aa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007ae:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b2:	eb 28                	jmp    8007dc <vprintfmt+0x63>
			if (ch == '\0'){
  8007b4:	85 db                	test   %ebx,%ebx
  8007b6:	75 15                	jne    8007cd <vprintfmt+0x54>
				current_color=WHITE;
  8007b8:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8007bf:	00 00 00 
  8007c2:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  8007c8:	e9 fc 04 00 00       	jmpq   800cc9 <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  8007cd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007d1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007d5:	48 89 d6             	mov    %rdx,%rsi
  8007d8:	89 df                	mov    %ebx,%edi
  8007da:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007dc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007e0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007e4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007e8:	0f b6 00             	movzbl (%rax),%eax
  8007eb:	0f b6 d8             	movzbl %al,%ebx
  8007ee:	83 fb 25             	cmp    $0x25,%ebx
  8007f1:	75 c1                	jne    8007b4 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007f3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007f7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007fe:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800805:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80080c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800813:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800817:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80081b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80081f:	0f b6 00             	movzbl (%rax),%eax
  800822:	0f b6 d8             	movzbl %al,%ebx
  800825:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800828:	83 f8 55             	cmp    $0x55,%eax
  80082b:	0f 87 64 04 00 00    	ja     800c95 <vprintfmt+0x51c>
  800831:	89 c0                	mov    %eax,%eax
  800833:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80083a:	00 
  80083b:	48 b8 78 45 80 00 00 	movabs $0x804578,%rax
  800842:	00 00 00 
  800845:	48 01 d0             	add    %rdx,%rax
  800848:	48 8b 00             	mov    (%rax),%rax
  80084b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80084d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800851:	eb c0                	jmp    800813 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800853:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800857:	eb ba                	jmp    800813 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800859:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800860:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800863:	89 d0                	mov    %edx,%eax
  800865:	c1 e0 02             	shl    $0x2,%eax
  800868:	01 d0                	add    %edx,%eax
  80086a:	01 c0                	add    %eax,%eax
  80086c:	01 d8                	add    %ebx,%eax
  80086e:	83 e8 30             	sub    $0x30,%eax
  800871:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800874:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800878:	0f b6 00             	movzbl (%rax),%eax
  80087b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80087e:	83 fb 2f             	cmp    $0x2f,%ebx
  800881:	7e 0c                	jle    80088f <vprintfmt+0x116>
  800883:	83 fb 39             	cmp    $0x39,%ebx
  800886:	7f 07                	jg     80088f <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800888:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80088d:	eb d1                	jmp    800860 <vprintfmt+0xe7>
			goto process_precision;
  80088f:	eb 58                	jmp    8008e9 <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800891:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800894:	83 f8 30             	cmp    $0x30,%eax
  800897:	73 17                	jae    8008b0 <vprintfmt+0x137>
  800899:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80089d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a0:	89 c0                	mov    %eax,%eax
  8008a2:	48 01 d0             	add    %rdx,%rax
  8008a5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008a8:	83 c2 08             	add    $0x8,%edx
  8008ab:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008ae:	eb 0f                	jmp    8008bf <vprintfmt+0x146>
  8008b0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b4:	48 89 d0             	mov    %rdx,%rax
  8008b7:	48 83 c2 08          	add    $0x8,%rdx
  8008bb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008bf:	8b 00                	mov    (%rax),%eax
  8008c1:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008c4:	eb 23                	jmp    8008e9 <vprintfmt+0x170>

		case '.':
			if (width < 0)
  8008c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008ca:	79 0c                	jns    8008d8 <vprintfmt+0x15f>
				width = 0;
  8008cc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008d3:	e9 3b ff ff ff       	jmpq   800813 <vprintfmt+0x9a>
  8008d8:	e9 36 ff ff ff       	jmpq   800813 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  8008dd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008e4:	e9 2a ff ff ff       	jmpq   800813 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  8008e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008ed:	79 12                	jns    800901 <vprintfmt+0x188>
				width = precision, precision = -1;
  8008ef:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008f2:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008f5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008fc:	e9 12 ff ff ff       	jmpq   800813 <vprintfmt+0x9a>
  800901:	e9 0d ff ff ff       	jmpq   800813 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800906:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80090a:	e9 04 ff ff ff       	jmpq   800813 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80090f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800912:	83 f8 30             	cmp    $0x30,%eax
  800915:	73 17                	jae    80092e <vprintfmt+0x1b5>
  800917:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80091b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091e:	89 c0                	mov    %eax,%eax
  800920:	48 01 d0             	add    %rdx,%rax
  800923:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800926:	83 c2 08             	add    $0x8,%edx
  800929:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80092c:	eb 0f                	jmp    80093d <vprintfmt+0x1c4>
  80092e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800932:	48 89 d0             	mov    %rdx,%rax
  800935:	48 83 c2 08          	add    $0x8,%rdx
  800939:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80093d:	8b 10                	mov    (%rax),%edx
  80093f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800943:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800947:	48 89 ce             	mov    %rcx,%rsi
  80094a:	89 d7                	mov    %edx,%edi
  80094c:	ff d0                	callq  *%rax
			break;
  80094e:	e9 70 03 00 00       	jmpq   800cc3 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800953:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800956:	83 f8 30             	cmp    $0x30,%eax
  800959:	73 17                	jae    800972 <vprintfmt+0x1f9>
  80095b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80095f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800962:	89 c0                	mov    %eax,%eax
  800964:	48 01 d0             	add    %rdx,%rax
  800967:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80096a:	83 c2 08             	add    $0x8,%edx
  80096d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800970:	eb 0f                	jmp    800981 <vprintfmt+0x208>
  800972:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800976:	48 89 d0             	mov    %rdx,%rax
  800979:	48 83 c2 08          	add    $0x8,%rdx
  80097d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800981:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800983:	85 db                	test   %ebx,%ebx
  800985:	79 02                	jns    800989 <vprintfmt+0x210>
				err = -err;
  800987:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800989:	83 fb 15             	cmp    $0x15,%ebx
  80098c:	7f 16                	jg     8009a4 <vprintfmt+0x22b>
  80098e:	48 b8 a0 44 80 00 00 	movabs $0x8044a0,%rax
  800995:	00 00 00 
  800998:	48 63 d3             	movslq %ebx,%rdx
  80099b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80099f:	4d 85 e4             	test   %r12,%r12
  8009a2:	75 2e                	jne    8009d2 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  8009a4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009a8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ac:	89 d9                	mov    %ebx,%ecx
  8009ae:	48 ba 61 45 80 00 00 	movabs $0x804561,%rdx
  8009b5:	00 00 00 
  8009b8:	48 89 c7             	mov    %rax,%rdi
  8009bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c0:	49 b8 d2 0c 80 00 00 	movabs $0x800cd2,%r8
  8009c7:	00 00 00 
  8009ca:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009cd:	e9 f1 02 00 00       	jmpq   800cc3 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009d2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009da:	4c 89 e1             	mov    %r12,%rcx
  8009dd:	48 ba 6a 45 80 00 00 	movabs $0x80456a,%rdx
  8009e4:	00 00 00 
  8009e7:	48 89 c7             	mov    %rax,%rdi
  8009ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ef:	49 b8 d2 0c 80 00 00 	movabs $0x800cd2,%r8
  8009f6:	00 00 00 
  8009f9:	41 ff d0             	callq  *%r8
			break;
  8009fc:	e9 c2 02 00 00       	jmpq   800cc3 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a04:	83 f8 30             	cmp    $0x30,%eax
  800a07:	73 17                	jae    800a20 <vprintfmt+0x2a7>
  800a09:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a10:	89 c0                	mov    %eax,%eax
  800a12:	48 01 d0             	add    %rdx,%rax
  800a15:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a18:	83 c2 08             	add    $0x8,%edx
  800a1b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a1e:	eb 0f                	jmp    800a2f <vprintfmt+0x2b6>
  800a20:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a24:	48 89 d0             	mov    %rdx,%rax
  800a27:	48 83 c2 08          	add    $0x8,%rdx
  800a2b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a2f:	4c 8b 20             	mov    (%rax),%r12
  800a32:	4d 85 e4             	test   %r12,%r12
  800a35:	75 0a                	jne    800a41 <vprintfmt+0x2c8>
				p = "(null)";
  800a37:	49 bc 6d 45 80 00 00 	movabs $0x80456d,%r12
  800a3e:	00 00 00 
			if (width > 0 && padc != '-')
  800a41:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a45:	7e 3f                	jle    800a86 <vprintfmt+0x30d>
  800a47:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a4b:	74 39                	je     800a86 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a4d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a50:	48 98                	cltq   
  800a52:	48 89 c6             	mov    %rax,%rsi
  800a55:	4c 89 e7             	mov    %r12,%rdi
  800a58:	48 b8 7e 0f 80 00 00 	movabs $0x800f7e,%rax
  800a5f:	00 00 00 
  800a62:	ff d0                	callq  *%rax
  800a64:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a67:	eb 17                	jmp    800a80 <vprintfmt+0x307>
					putch(padc, putdat);
  800a69:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a6d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a75:	48 89 ce             	mov    %rcx,%rsi
  800a78:	89 d7                	mov    %edx,%edi
  800a7a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a7c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a80:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a84:	7f e3                	jg     800a69 <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a86:	eb 37                	jmp    800abf <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  800a88:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a8c:	74 1e                	je     800aac <vprintfmt+0x333>
  800a8e:	83 fb 1f             	cmp    $0x1f,%ebx
  800a91:	7e 05                	jle    800a98 <vprintfmt+0x31f>
  800a93:	83 fb 7e             	cmp    $0x7e,%ebx
  800a96:	7e 14                	jle    800aac <vprintfmt+0x333>
					putch('?', putdat);
  800a98:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa0:	48 89 d6             	mov    %rdx,%rsi
  800aa3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800aa8:	ff d0                	callq  *%rax
  800aaa:	eb 0f                	jmp    800abb <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800aac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ab0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab4:	48 89 d6             	mov    %rdx,%rsi
  800ab7:	89 df                	mov    %ebx,%edi
  800ab9:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800abb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800abf:	4c 89 e0             	mov    %r12,%rax
  800ac2:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ac6:	0f b6 00             	movzbl (%rax),%eax
  800ac9:	0f be d8             	movsbl %al,%ebx
  800acc:	85 db                	test   %ebx,%ebx
  800ace:	74 10                	je     800ae0 <vprintfmt+0x367>
  800ad0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ad4:	78 b2                	js     800a88 <vprintfmt+0x30f>
  800ad6:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ada:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ade:	79 a8                	jns    800a88 <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ae0:	eb 16                	jmp    800af8 <vprintfmt+0x37f>
				putch(' ', putdat);
  800ae2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aea:	48 89 d6             	mov    %rdx,%rsi
  800aed:	bf 20 00 00 00       	mov    $0x20,%edi
  800af2:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800af4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800af8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800afc:	7f e4                	jg     800ae2 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800afe:	e9 c0 01 00 00       	jmpq   800cc3 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b03:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b07:	be 03 00 00 00       	mov    $0x3,%esi
  800b0c:	48 89 c7             	mov    %rax,%rdi
  800b0f:	48 b8 69 06 80 00 00 	movabs $0x800669,%rax
  800b16:	00 00 00 
  800b19:	ff d0                	callq  *%rax
  800b1b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b23:	48 85 c0             	test   %rax,%rax
  800b26:	79 1d                	jns    800b45 <vprintfmt+0x3cc>
				putch('-', putdat);
  800b28:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b30:	48 89 d6             	mov    %rdx,%rsi
  800b33:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b38:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3e:	48 f7 d8             	neg    %rax
  800b41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b45:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b4c:	e9 d5 00 00 00       	jmpq   800c26 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b51:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b55:	be 03 00 00 00       	mov    $0x3,%esi
  800b5a:	48 89 c7             	mov    %rax,%rdi
  800b5d:	48 b8 59 05 80 00 00 	movabs $0x800559,%rax
  800b64:	00 00 00 
  800b67:	ff d0                	callq  *%rax
  800b69:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b6d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b74:	e9 ad 00 00 00       	jmpq   800c26 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800b79:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b7d:	be 03 00 00 00       	mov    $0x3,%esi
  800b82:	48 89 c7             	mov    %rax,%rdi
  800b85:	48 b8 59 05 80 00 00 	movabs $0x800559,%rax
  800b8c:	00 00 00 
  800b8f:	ff d0                	callq  *%rax
  800b91:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800b95:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b9c:	e9 85 00 00 00       	jmpq   800c26 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800ba1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba9:	48 89 d6             	mov    %rdx,%rsi
  800bac:	bf 30 00 00 00       	mov    $0x30,%edi
  800bb1:	ff d0                	callq  *%rax
			putch('x', putdat);
  800bb3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbb:	48 89 d6             	mov    %rdx,%rsi
  800bbe:	bf 78 00 00 00       	mov    $0x78,%edi
  800bc3:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800bc5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc8:	83 f8 30             	cmp    $0x30,%eax
  800bcb:	73 17                	jae    800be4 <vprintfmt+0x46b>
  800bcd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bd1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd4:	89 c0                	mov    %eax,%eax
  800bd6:	48 01 d0             	add    %rdx,%rax
  800bd9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bdc:	83 c2 08             	add    $0x8,%edx
  800bdf:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800be2:	eb 0f                	jmp    800bf3 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  800be4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be8:	48 89 d0             	mov    %rdx,%rax
  800beb:	48 83 c2 08          	add    $0x8,%rdx
  800bef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bf3:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bf6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bfa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c01:	eb 23                	jmp    800c26 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c03:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c07:	be 03 00 00 00       	mov    $0x3,%esi
  800c0c:	48 89 c7             	mov    %rax,%rdi
  800c0f:	48 b8 59 05 80 00 00 	movabs $0x800559,%rax
  800c16:	00 00 00 
  800c19:	ff d0                	callq  *%rax
  800c1b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c1f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c26:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c2b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c2e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c35:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3d:	45 89 c1             	mov    %r8d,%r9d
  800c40:	41 89 f8             	mov    %edi,%r8d
  800c43:	48 89 c7             	mov    %rax,%rdi
  800c46:	48 b8 9e 04 80 00 00 	movabs $0x80049e,%rax
  800c4d:	00 00 00 
  800c50:	ff d0                	callq  *%rax
			break;
  800c52:	eb 6f                	jmp    800cc3 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5c:	48 89 d6             	mov    %rdx,%rsi
  800c5f:	89 df                	mov    %ebx,%edi
  800c61:	ff d0                	callq  *%rax
			break;
  800c63:	eb 5e                	jmp    800cc3 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  800c65:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c69:	be 03 00 00 00       	mov    $0x3,%esi
  800c6e:	48 89 c7             	mov    %rax,%rdi
  800c71:	48 b8 59 05 80 00 00 	movabs $0x800559,%rax
  800c78:	00 00 00 
  800c7b:	ff d0                	callq  *%rax
  800c7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  800c81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c85:	89 c2                	mov    %eax,%edx
  800c87:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800c8e:	00 00 00 
  800c91:	89 10                	mov    %edx,(%rax)
			break;
  800c93:	eb 2e                	jmp    800cc3 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c95:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9d:	48 89 d6             	mov    %rdx,%rsi
  800ca0:	bf 25 00 00 00       	mov    $0x25,%edi
  800ca5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ca7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cac:	eb 05                	jmp    800cb3 <vprintfmt+0x53a>
  800cae:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cb3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cb7:	48 83 e8 01          	sub    $0x1,%rax
  800cbb:	0f b6 00             	movzbl (%rax),%eax
  800cbe:	3c 25                	cmp    $0x25,%al
  800cc0:	75 ec                	jne    800cae <vprintfmt+0x535>
				/* do nothing */;
			break;
  800cc2:	90                   	nop
		}
	}
  800cc3:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cc4:	e9 13 fb ff ff       	jmpq   8007dc <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800cc9:	48 83 c4 60          	add    $0x60,%rsp
  800ccd:	5b                   	pop    %rbx
  800cce:	41 5c                	pop    %r12
  800cd0:	5d                   	pop    %rbp
  800cd1:	c3                   	retq   

0000000000800cd2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cd2:	55                   	push   %rbp
  800cd3:	48 89 e5             	mov    %rsp,%rbp
  800cd6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800cdd:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ce4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ceb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cf2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cf9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d00:	84 c0                	test   %al,%al
  800d02:	74 20                	je     800d24 <printfmt+0x52>
  800d04:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d08:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d0c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d10:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d14:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d18:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d1c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d20:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d24:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d2b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d32:	00 00 00 
  800d35:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d3c:	00 00 00 
  800d3f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d43:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d4a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d51:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d58:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d5f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d66:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d6d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d74:	48 89 c7             	mov    %rax,%rdi
  800d77:	48 b8 79 07 80 00 00 	movabs $0x800779,%rax
  800d7e:	00 00 00 
  800d81:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d83:	c9                   	leaveq 
  800d84:	c3                   	retq   

0000000000800d85 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d85:	55                   	push   %rbp
  800d86:	48 89 e5             	mov    %rsp,%rbp
  800d89:	48 83 ec 10          	sub    $0x10,%rsp
  800d8d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d90:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d98:	8b 40 10             	mov    0x10(%rax),%eax
  800d9b:	8d 50 01             	lea    0x1(%rax),%edx
  800d9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800da5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da9:	48 8b 10             	mov    (%rax),%rdx
  800dac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800db0:	48 8b 40 08          	mov    0x8(%rax),%rax
  800db4:	48 39 c2             	cmp    %rax,%rdx
  800db7:	73 17                	jae    800dd0 <sprintputch+0x4b>
		*b->buf++ = ch;
  800db9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dbd:	48 8b 00             	mov    (%rax),%rax
  800dc0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800dc4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800dc8:	48 89 0a             	mov    %rcx,(%rdx)
  800dcb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800dce:	88 10                	mov    %dl,(%rax)
}
  800dd0:	c9                   	leaveq 
  800dd1:	c3                   	retq   

0000000000800dd2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dd2:	55                   	push   %rbp
  800dd3:	48 89 e5             	mov    %rsp,%rbp
  800dd6:	48 83 ec 50          	sub    $0x50,%rsp
  800dda:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800dde:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800de1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800de5:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800de9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ded:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800df1:	48 8b 0a             	mov    (%rdx),%rcx
  800df4:	48 89 08             	mov    %rcx,(%rax)
  800df7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dfb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dff:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e03:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e07:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e0b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e0f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e12:	48 98                	cltq   
  800e14:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e18:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e1c:	48 01 d0             	add    %rdx,%rax
  800e1f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e23:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e2a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e2f:	74 06                	je     800e37 <vsnprintf+0x65>
  800e31:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e35:	7f 07                	jg     800e3e <vsnprintf+0x6c>
		return -E_INVAL;
  800e37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e3c:	eb 2f                	jmp    800e6d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e3e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e42:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e46:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e4a:	48 89 c6             	mov    %rax,%rsi
  800e4d:	48 bf 85 0d 80 00 00 	movabs $0x800d85,%rdi
  800e54:	00 00 00 
  800e57:	48 b8 79 07 80 00 00 	movabs $0x800779,%rax
  800e5e:	00 00 00 
  800e61:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e67:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e6a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e6d:	c9                   	leaveq 
  800e6e:	c3                   	retq   

0000000000800e6f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e6f:	55                   	push   %rbp
  800e70:	48 89 e5             	mov    %rsp,%rbp
  800e73:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e7a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e81:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e87:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e8e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e95:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e9c:	84 c0                	test   %al,%al
  800e9e:	74 20                	je     800ec0 <snprintf+0x51>
  800ea0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ea4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ea8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800eac:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800eb0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800eb4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800eb8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ebc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ec0:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ec7:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800ece:	00 00 00 
  800ed1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ed8:	00 00 00 
  800edb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800edf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ee6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eed:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ef4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800efb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f02:	48 8b 0a             	mov    (%rdx),%rcx
  800f05:	48 89 08             	mov    %rcx,(%rax)
  800f08:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f0c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f10:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f14:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f18:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f1f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f26:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f2c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f33:	48 89 c7             	mov    %rax,%rdi
  800f36:	48 b8 d2 0d 80 00 00 	movabs $0x800dd2,%rax
  800f3d:	00 00 00 
  800f40:	ff d0                	callq  *%rax
  800f42:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f48:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f4e:	c9                   	leaveq 
  800f4f:	c3                   	retq   

0000000000800f50 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f50:	55                   	push   %rbp
  800f51:	48 89 e5             	mov    %rsp,%rbp
  800f54:	48 83 ec 18          	sub    $0x18,%rsp
  800f58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f63:	eb 09                	jmp    800f6e <strlen+0x1e>
		n++;
  800f65:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f69:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f72:	0f b6 00             	movzbl (%rax),%eax
  800f75:	84 c0                	test   %al,%al
  800f77:	75 ec                	jne    800f65 <strlen+0x15>
		n++;
	return n;
  800f79:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f7c:	c9                   	leaveq 
  800f7d:	c3                   	retq   

0000000000800f7e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f7e:	55                   	push   %rbp
  800f7f:	48 89 e5             	mov    %rsp,%rbp
  800f82:	48 83 ec 20          	sub    $0x20,%rsp
  800f86:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f8a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f95:	eb 0e                	jmp    800fa5 <strnlen+0x27>
		n++;
  800f97:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f9b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fa0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800fa5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800faa:	74 0b                	je     800fb7 <strnlen+0x39>
  800fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb0:	0f b6 00             	movzbl (%rax),%eax
  800fb3:	84 c0                	test   %al,%al
  800fb5:	75 e0                	jne    800f97 <strnlen+0x19>
		n++;
	return n;
  800fb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fba:	c9                   	leaveq 
  800fbb:	c3                   	retq   

0000000000800fbc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fbc:	55                   	push   %rbp
  800fbd:	48 89 e5             	mov    %rsp,%rbp
  800fc0:	48 83 ec 20          	sub    $0x20,%rsp
  800fc4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fc8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800fcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800fd4:	90                   	nop
  800fd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fdd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fe1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fe5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fe9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fed:	0f b6 12             	movzbl (%rdx),%edx
  800ff0:	88 10                	mov    %dl,(%rax)
  800ff2:	0f b6 00             	movzbl (%rax),%eax
  800ff5:	84 c0                	test   %al,%al
  800ff7:	75 dc                	jne    800fd5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ff9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ffd:	c9                   	leaveq 
  800ffe:	c3                   	retq   

0000000000800fff <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fff:	55                   	push   %rbp
  801000:	48 89 e5             	mov    %rsp,%rbp
  801003:	48 83 ec 20          	sub    $0x20,%rsp
  801007:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80100b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80100f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801013:	48 89 c7             	mov    %rax,%rdi
  801016:	48 b8 50 0f 80 00 00 	movabs $0x800f50,%rax
  80101d:	00 00 00 
  801020:	ff d0                	callq  *%rax
  801022:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801025:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801028:	48 63 d0             	movslq %eax,%rdx
  80102b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102f:	48 01 c2             	add    %rax,%rdx
  801032:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801036:	48 89 c6             	mov    %rax,%rsi
  801039:	48 89 d7             	mov    %rdx,%rdi
  80103c:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  801043:	00 00 00 
  801046:	ff d0                	callq  *%rax
	return dst;
  801048:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80104c:	c9                   	leaveq 
  80104d:	c3                   	retq   

000000000080104e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80104e:	55                   	push   %rbp
  80104f:	48 89 e5             	mov    %rsp,%rbp
  801052:	48 83 ec 28          	sub    $0x28,%rsp
  801056:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80105a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80105e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801062:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801066:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80106a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801071:	00 
  801072:	eb 2a                	jmp    80109e <strncpy+0x50>
		*dst++ = *src;
  801074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801078:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80107c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801080:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801084:	0f b6 12             	movzbl (%rdx),%edx
  801087:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801089:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80108d:	0f b6 00             	movzbl (%rax),%eax
  801090:	84 c0                	test   %al,%al
  801092:	74 05                	je     801099 <strncpy+0x4b>
			src++;
  801094:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801099:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80109e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010a6:	72 cc                	jb     801074 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8010ac:	c9                   	leaveq 
  8010ad:	c3                   	retq   

00000000008010ae <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010ae:	55                   	push   %rbp
  8010af:	48 89 e5             	mov    %rsp,%rbp
  8010b2:	48 83 ec 28          	sub    $0x28,%rsp
  8010b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8010c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8010ca:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010cf:	74 3d                	je     80110e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8010d1:	eb 1d                	jmp    8010f0 <strlcpy+0x42>
			*dst++ = *src++;
  8010d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010db:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010df:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010e3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010e7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010eb:	0f b6 12             	movzbl (%rdx),%edx
  8010ee:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010f0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010f5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010fa:	74 0b                	je     801107 <strlcpy+0x59>
  8010fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801100:	0f b6 00             	movzbl (%rax),%eax
  801103:	84 c0                	test   %al,%al
  801105:	75 cc                	jne    8010d3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801107:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80110e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801112:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801116:	48 29 c2             	sub    %rax,%rdx
  801119:	48 89 d0             	mov    %rdx,%rax
}
  80111c:	c9                   	leaveq 
  80111d:	c3                   	retq   

000000000080111e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80111e:	55                   	push   %rbp
  80111f:	48 89 e5             	mov    %rsp,%rbp
  801122:	48 83 ec 10          	sub    $0x10,%rsp
  801126:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80112a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80112e:	eb 0a                	jmp    80113a <strcmp+0x1c>
		p++, q++;
  801130:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801135:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80113a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113e:	0f b6 00             	movzbl (%rax),%eax
  801141:	84 c0                	test   %al,%al
  801143:	74 12                	je     801157 <strcmp+0x39>
  801145:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801149:	0f b6 10             	movzbl (%rax),%edx
  80114c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801150:	0f b6 00             	movzbl (%rax),%eax
  801153:	38 c2                	cmp    %al,%dl
  801155:	74 d9                	je     801130 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801157:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115b:	0f b6 00             	movzbl (%rax),%eax
  80115e:	0f b6 d0             	movzbl %al,%edx
  801161:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801165:	0f b6 00             	movzbl (%rax),%eax
  801168:	0f b6 c0             	movzbl %al,%eax
  80116b:	29 c2                	sub    %eax,%edx
  80116d:	89 d0                	mov    %edx,%eax
}
  80116f:	c9                   	leaveq 
  801170:	c3                   	retq   

0000000000801171 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801171:	55                   	push   %rbp
  801172:	48 89 e5             	mov    %rsp,%rbp
  801175:	48 83 ec 18          	sub    $0x18,%rsp
  801179:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80117d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801181:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801185:	eb 0f                	jmp    801196 <strncmp+0x25>
		n--, p++, q++;
  801187:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80118c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801191:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801196:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80119b:	74 1d                	je     8011ba <strncmp+0x49>
  80119d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a1:	0f b6 00             	movzbl (%rax),%eax
  8011a4:	84 c0                	test   %al,%al
  8011a6:	74 12                	je     8011ba <strncmp+0x49>
  8011a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ac:	0f b6 10             	movzbl (%rax),%edx
  8011af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b3:	0f b6 00             	movzbl (%rax),%eax
  8011b6:	38 c2                	cmp    %al,%dl
  8011b8:	74 cd                	je     801187 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8011ba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011bf:	75 07                	jne    8011c8 <strncmp+0x57>
		return 0;
  8011c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c6:	eb 18                	jmp    8011e0 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cc:	0f b6 00             	movzbl (%rax),%eax
  8011cf:	0f b6 d0             	movzbl %al,%edx
  8011d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d6:	0f b6 00             	movzbl (%rax),%eax
  8011d9:	0f b6 c0             	movzbl %al,%eax
  8011dc:	29 c2                	sub    %eax,%edx
  8011de:	89 d0                	mov    %edx,%eax
}
  8011e0:	c9                   	leaveq 
  8011e1:	c3                   	retq   

00000000008011e2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011e2:	55                   	push   %rbp
  8011e3:	48 89 e5             	mov    %rsp,%rbp
  8011e6:	48 83 ec 0c          	sub    $0xc,%rsp
  8011ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ee:	89 f0                	mov    %esi,%eax
  8011f0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011f3:	eb 17                	jmp    80120c <strchr+0x2a>
		if (*s == c)
  8011f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f9:	0f b6 00             	movzbl (%rax),%eax
  8011fc:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011ff:	75 06                	jne    801207 <strchr+0x25>
			return (char *) s;
  801201:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801205:	eb 15                	jmp    80121c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801207:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80120c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801210:	0f b6 00             	movzbl (%rax),%eax
  801213:	84 c0                	test   %al,%al
  801215:	75 de                	jne    8011f5 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801217:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80121c:	c9                   	leaveq 
  80121d:	c3                   	retq   

000000000080121e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80121e:	55                   	push   %rbp
  80121f:	48 89 e5             	mov    %rsp,%rbp
  801222:	48 83 ec 0c          	sub    $0xc,%rsp
  801226:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80122a:	89 f0                	mov    %esi,%eax
  80122c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80122f:	eb 13                	jmp    801244 <strfind+0x26>
		if (*s == c)
  801231:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801235:	0f b6 00             	movzbl (%rax),%eax
  801238:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80123b:	75 02                	jne    80123f <strfind+0x21>
			break;
  80123d:	eb 10                	jmp    80124f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80123f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801248:	0f b6 00             	movzbl (%rax),%eax
  80124b:	84 c0                	test   %al,%al
  80124d:	75 e2                	jne    801231 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80124f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801253:	c9                   	leaveq 
  801254:	c3                   	retq   

0000000000801255 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801255:	55                   	push   %rbp
  801256:	48 89 e5             	mov    %rsp,%rbp
  801259:	48 83 ec 18          	sub    $0x18,%rsp
  80125d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801261:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801264:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801268:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80126d:	75 06                	jne    801275 <memset+0x20>
		return v;
  80126f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801273:	eb 69                	jmp    8012de <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801275:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801279:	83 e0 03             	and    $0x3,%eax
  80127c:	48 85 c0             	test   %rax,%rax
  80127f:	75 48                	jne    8012c9 <memset+0x74>
  801281:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801285:	83 e0 03             	and    $0x3,%eax
  801288:	48 85 c0             	test   %rax,%rax
  80128b:	75 3c                	jne    8012c9 <memset+0x74>
		c &= 0xFF;
  80128d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801294:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801297:	c1 e0 18             	shl    $0x18,%eax
  80129a:	89 c2                	mov    %eax,%edx
  80129c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80129f:	c1 e0 10             	shl    $0x10,%eax
  8012a2:	09 c2                	or     %eax,%edx
  8012a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012a7:	c1 e0 08             	shl    $0x8,%eax
  8012aa:	09 d0                	or     %edx,%eax
  8012ac:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8012af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b3:	48 c1 e8 02          	shr    $0x2,%rax
  8012b7:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8012ba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012c1:	48 89 d7             	mov    %rdx,%rdi
  8012c4:	fc                   	cld    
  8012c5:	f3 ab                	rep stos %eax,%es:(%rdi)
  8012c7:	eb 11                	jmp    8012da <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012d0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8012d4:	48 89 d7             	mov    %rdx,%rdi
  8012d7:	fc                   	cld    
  8012d8:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8012da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012de:	c9                   	leaveq 
  8012df:	c3                   	retq   

00000000008012e0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012e0:	55                   	push   %rbp
  8012e1:	48 89 e5             	mov    %rsp,%rbp
  8012e4:	48 83 ec 28          	sub    $0x28,%rsp
  8012e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801300:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801304:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801308:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80130c:	0f 83 88 00 00 00    	jae    80139a <memmove+0xba>
  801312:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801316:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80131a:	48 01 d0             	add    %rdx,%rax
  80131d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801321:	76 77                	jbe    80139a <memmove+0xba>
		s += n;
  801323:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801327:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80132b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80132f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801333:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801337:	83 e0 03             	and    $0x3,%eax
  80133a:	48 85 c0             	test   %rax,%rax
  80133d:	75 3b                	jne    80137a <memmove+0x9a>
  80133f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801343:	83 e0 03             	and    $0x3,%eax
  801346:	48 85 c0             	test   %rax,%rax
  801349:	75 2f                	jne    80137a <memmove+0x9a>
  80134b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80134f:	83 e0 03             	and    $0x3,%eax
  801352:	48 85 c0             	test   %rax,%rax
  801355:	75 23                	jne    80137a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135b:	48 83 e8 04          	sub    $0x4,%rax
  80135f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801363:	48 83 ea 04          	sub    $0x4,%rdx
  801367:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80136b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80136f:	48 89 c7             	mov    %rax,%rdi
  801372:	48 89 d6             	mov    %rdx,%rsi
  801375:	fd                   	std    
  801376:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801378:	eb 1d                	jmp    801397 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80137a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801386:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80138a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138e:	48 89 d7             	mov    %rdx,%rdi
  801391:	48 89 c1             	mov    %rax,%rcx
  801394:	fd                   	std    
  801395:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801397:	fc                   	cld    
  801398:	eb 57                	jmp    8013f1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80139a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139e:	83 e0 03             	and    $0x3,%eax
  8013a1:	48 85 c0             	test   %rax,%rax
  8013a4:	75 36                	jne    8013dc <memmove+0xfc>
  8013a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013aa:	83 e0 03             	and    $0x3,%eax
  8013ad:	48 85 c0             	test   %rax,%rax
  8013b0:	75 2a                	jne    8013dc <memmove+0xfc>
  8013b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b6:	83 e0 03             	and    $0x3,%eax
  8013b9:	48 85 c0             	test   %rax,%rax
  8013bc:	75 1e                	jne    8013dc <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8013be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c2:	48 c1 e8 02          	shr    $0x2,%rax
  8013c6:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8013c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d1:	48 89 c7             	mov    %rax,%rdi
  8013d4:	48 89 d6             	mov    %rdx,%rsi
  8013d7:	fc                   	cld    
  8013d8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013da:	eb 15                	jmp    8013f1 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013e8:	48 89 c7             	mov    %rax,%rdi
  8013eb:	48 89 d6             	mov    %rdx,%rsi
  8013ee:	fc                   	cld    
  8013ef:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013f5:	c9                   	leaveq 
  8013f6:	c3                   	retq   

00000000008013f7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013f7:	55                   	push   %rbp
  8013f8:	48 89 e5             	mov    %rsp,%rbp
  8013fb:	48 83 ec 18          	sub    $0x18,%rsp
  8013ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801403:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801407:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80140b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80140f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801413:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801417:	48 89 ce             	mov    %rcx,%rsi
  80141a:	48 89 c7             	mov    %rax,%rdi
  80141d:	48 b8 e0 12 80 00 00 	movabs $0x8012e0,%rax
  801424:	00 00 00 
  801427:	ff d0                	callq  *%rax
}
  801429:	c9                   	leaveq 
  80142a:	c3                   	retq   

000000000080142b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80142b:	55                   	push   %rbp
  80142c:	48 89 e5             	mov    %rsp,%rbp
  80142f:	48 83 ec 28          	sub    $0x28,%rsp
  801433:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801437:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80143b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80143f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801443:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801447:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80144b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80144f:	eb 36                	jmp    801487 <memcmp+0x5c>
		if (*s1 != *s2)
  801451:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801455:	0f b6 10             	movzbl (%rax),%edx
  801458:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145c:	0f b6 00             	movzbl (%rax),%eax
  80145f:	38 c2                	cmp    %al,%dl
  801461:	74 1a                	je     80147d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801463:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801467:	0f b6 00             	movzbl (%rax),%eax
  80146a:	0f b6 d0             	movzbl %al,%edx
  80146d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801471:	0f b6 00             	movzbl (%rax),%eax
  801474:	0f b6 c0             	movzbl %al,%eax
  801477:	29 c2                	sub    %eax,%edx
  801479:	89 d0                	mov    %edx,%eax
  80147b:	eb 20                	jmp    80149d <memcmp+0x72>
		s1++, s2++;
  80147d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801482:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801487:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80148f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801493:	48 85 c0             	test   %rax,%rax
  801496:	75 b9                	jne    801451 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801498:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149d:	c9                   	leaveq 
  80149e:	c3                   	retq   

000000000080149f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80149f:	55                   	push   %rbp
  8014a0:	48 89 e5             	mov    %rsp,%rbp
  8014a3:	48 83 ec 28          	sub    $0x28,%rsp
  8014a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ab:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8014ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8014b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014ba:	48 01 d0             	add    %rdx,%rax
  8014bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8014c1:	eb 15                	jmp    8014d8 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c7:	0f b6 10             	movzbl (%rax),%edx
  8014ca:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8014cd:	38 c2                	cmp    %al,%dl
  8014cf:	75 02                	jne    8014d3 <memfind+0x34>
			break;
  8014d1:	eb 0f                	jmp    8014e2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014d3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014dc:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014e0:	72 e1                	jb     8014c3 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8014e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014e6:	c9                   	leaveq 
  8014e7:	c3                   	retq   

00000000008014e8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014e8:	55                   	push   %rbp
  8014e9:	48 89 e5             	mov    %rsp,%rbp
  8014ec:	48 83 ec 34          	sub    $0x34,%rsp
  8014f0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014f4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014f8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801502:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801509:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80150a:	eb 05                	jmp    801511 <strtol+0x29>
		s++;
  80150c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801511:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801515:	0f b6 00             	movzbl (%rax),%eax
  801518:	3c 20                	cmp    $0x20,%al
  80151a:	74 f0                	je     80150c <strtol+0x24>
  80151c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801520:	0f b6 00             	movzbl (%rax),%eax
  801523:	3c 09                	cmp    $0x9,%al
  801525:	74 e5                	je     80150c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801527:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152b:	0f b6 00             	movzbl (%rax),%eax
  80152e:	3c 2b                	cmp    $0x2b,%al
  801530:	75 07                	jne    801539 <strtol+0x51>
		s++;
  801532:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801537:	eb 17                	jmp    801550 <strtol+0x68>
	else if (*s == '-')
  801539:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153d:	0f b6 00             	movzbl (%rax),%eax
  801540:	3c 2d                	cmp    $0x2d,%al
  801542:	75 0c                	jne    801550 <strtol+0x68>
		s++, neg = 1;
  801544:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801549:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801550:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801554:	74 06                	je     80155c <strtol+0x74>
  801556:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80155a:	75 28                	jne    801584 <strtol+0x9c>
  80155c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801560:	0f b6 00             	movzbl (%rax),%eax
  801563:	3c 30                	cmp    $0x30,%al
  801565:	75 1d                	jne    801584 <strtol+0x9c>
  801567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156b:	48 83 c0 01          	add    $0x1,%rax
  80156f:	0f b6 00             	movzbl (%rax),%eax
  801572:	3c 78                	cmp    $0x78,%al
  801574:	75 0e                	jne    801584 <strtol+0x9c>
		s += 2, base = 16;
  801576:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80157b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801582:	eb 2c                	jmp    8015b0 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801584:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801588:	75 19                	jne    8015a3 <strtol+0xbb>
  80158a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158e:	0f b6 00             	movzbl (%rax),%eax
  801591:	3c 30                	cmp    $0x30,%al
  801593:	75 0e                	jne    8015a3 <strtol+0xbb>
		s++, base = 8;
  801595:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80159a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8015a1:	eb 0d                	jmp    8015b0 <strtol+0xc8>
	else if (base == 0)
  8015a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015a7:	75 07                	jne    8015b0 <strtol+0xc8>
		base = 10;
  8015a9:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b4:	0f b6 00             	movzbl (%rax),%eax
  8015b7:	3c 2f                	cmp    $0x2f,%al
  8015b9:	7e 1d                	jle    8015d8 <strtol+0xf0>
  8015bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bf:	0f b6 00             	movzbl (%rax),%eax
  8015c2:	3c 39                	cmp    $0x39,%al
  8015c4:	7f 12                	jg     8015d8 <strtol+0xf0>
			dig = *s - '0';
  8015c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ca:	0f b6 00             	movzbl (%rax),%eax
  8015cd:	0f be c0             	movsbl %al,%eax
  8015d0:	83 e8 30             	sub    $0x30,%eax
  8015d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015d6:	eb 4e                	jmp    801626 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8015d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dc:	0f b6 00             	movzbl (%rax),%eax
  8015df:	3c 60                	cmp    $0x60,%al
  8015e1:	7e 1d                	jle    801600 <strtol+0x118>
  8015e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e7:	0f b6 00             	movzbl (%rax),%eax
  8015ea:	3c 7a                	cmp    $0x7a,%al
  8015ec:	7f 12                	jg     801600 <strtol+0x118>
			dig = *s - 'a' + 10;
  8015ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f2:	0f b6 00             	movzbl (%rax),%eax
  8015f5:	0f be c0             	movsbl %al,%eax
  8015f8:	83 e8 57             	sub    $0x57,%eax
  8015fb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015fe:	eb 26                	jmp    801626 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801600:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801604:	0f b6 00             	movzbl (%rax),%eax
  801607:	3c 40                	cmp    $0x40,%al
  801609:	7e 48                	jle    801653 <strtol+0x16b>
  80160b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160f:	0f b6 00             	movzbl (%rax),%eax
  801612:	3c 5a                	cmp    $0x5a,%al
  801614:	7f 3d                	jg     801653 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801616:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161a:	0f b6 00             	movzbl (%rax),%eax
  80161d:	0f be c0             	movsbl %al,%eax
  801620:	83 e8 37             	sub    $0x37,%eax
  801623:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801626:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801629:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80162c:	7c 02                	jl     801630 <strtol+0x148>
			break;
  80162e:	eb 23                	jmp    801653 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801630:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801635:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801638:	48 98                	cltq   
  80163a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80163f:	48 89 c2             	mov    %rax,%rdx
  801642:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801645:	48 98                	cltq   
  801647:	48 01 d0             	add    %rdx,%rax
  80164a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80164e:	e9 5d ff ff ff       	jmpq   8015b0 <strtol+0xc8>

	if (endptr)
  801653:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801658:	74 0b                	je     801665 <strtol+0x17d>
		*endptr = (char *) s;
  80165a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80165e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801662:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801665:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801669:	74 09                	je     801674 <strtol+0x18c>
  80166b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166f:	48 f7 d8             	neg    %rax
  801672:	eb 04                	jmp    801678 <strtol+0x190>
  801674:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801678:	c9                   	leaveq 
  801679:	c3                   	retq   

000000000080167a <strstr>:

char * strstr(const char *in, const char *str)
{
  80167a:	55                   	push   %rbp
  80167b:	48 89 e5             	mov    %rsp,%rbp
  80167e:	48 83 ec 30          	sub    $0x30,%rsp
  801682:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801686:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80168a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80168e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801692:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801696:	0f b6 00             	movzbl (%rax),%eax
  801699:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80169c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8016a0:	75 06                	jne    8016a8 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8016a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a6:	eb 6b                	jmp    801713 <strstr+0x99>

	len = strlen(str);
  8016a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ac:	48 89 c7             	mov    %rax,%rdi
  8016af:	48 b8 50 0f 80 00 00 	movabs $0x800f50,%rax
  8016b6:	00 00 00 
  8016b9:	ff d0                	callq  *%rax
  8016bb:	48 98                	cltq   
  8016bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8016c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8016d3:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8016d7:	75 07                	jne    8016e0 <strstr+0x66>
				return (char *) 0;
  8016d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016de:	eb 33                	jmp    801713 <strstr+0x99>
		} while (sc != c);
  8016e0:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016e4:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016e7:	75 d8                	jne    8016c1 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8016e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016ed:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f5:	48 89 ce             	mov    %rcx,%rsi
  8016f8:	48 89 c7             	mov    %rax,%rdi
  8016fb:	48 b8 71 11 80 00 00 	movabs $0x801171,%rax
  801702:	00 00 00 
  801705:	ff d0                	callq  *%rax
  801707:	85 c0                	test   %eax,%eax
  801709:	75 b6                	jne    8016c1 <strstr+0x47>

	return (char *) (in - 1);
  80170b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170f:	48 83 e8 01          	sub    $0x1,%rax
}
  801713:	c9                   	leaveq 
  801714:	c3                   	retq   

0000000000801715 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801715:	55                   	push   %rbp
  801716:	48 89 e5             	mov    %rsp,%rbp
  801719:	53                   	push   %rbx
  80171a:	48 83 ec 48          	sub    $0x48,%rsp
  80171e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801721:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801724:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801728:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80172c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801730:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801734:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801737:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80173b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80173f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801743:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801747:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80174b:	4c 89 c3             	mov    %r8,%rbx
  80174e:	cd 30                	int    $0x30
  801750:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801754:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801758:	74 3e                	je     801798 <syscall+0x83>
  80175a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80175f:	7e 37                	jle    801798 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801761:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801765:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801768:	49 89 d0             	mov    %rdx,%r8
  80176b:	89 c1                	mov    %eax,%ecx
  80176d:	48 ba 28 48 80 00 00 	movabs $0x804828,%rdx
  801774:	00 00 00 
  801777:	be 23 00 00 00       	mov    $0x23,%esi
  80177c:	48 bf 45 48 80 00 00 	movabs $0x804845,%rdi
  801783:	00 00 00 
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
  80178b:	49 b9 8d 01 80 00 00 	movabs $0x80018d,%r9
  801792:	00 00 00 
  801795:	41 ff d1             	callq  *%r9

	return ret;
  801798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80179c:	48 83 c4 48          	add    $0x48,%rsp
  8017a0:	5b                   	pop    %rbx
  8017a1:	5d                   	pop    %rbp
  8017a2:	c3                   	retq   

00000000008017a3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8017a3:	55                   	push   %rbp
  8017a4:	48 89 e5             	mov    %rsp,%rbp
  8017a7:	48 83 ec 20          	sub    $0x20,%rsp
  8017ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8017b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017c2:	00 
  8017c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017cf:	48 89 d1             	mov    %rdx,%rcx
  8017d2:	48 89 c2             	mov    %rax,%rdx
  8017d5:	be 00 00 00 00       	mov    $0x0,%esi
  8017da:	bf 00 00 00 00       	mov    $0x0,%edi
  8017df:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  8017e6:	00 00 00 
  8017e9:	ff d0                	callq  *%rax
}
  8017eb:	c9                   	leaveq 
  8017ec:	c3                   	retq   

00000000008017ed <sys_cgetc>:

int
sys_cgetc(void)
{
  8017ed:	55                   	push   %rbp
  8017ee:	48 89 e5             	mov    %rsp,%rbp
  8017f1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017f5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017fc:	00 
  8017fd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801803:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801809:	b9 00 00 00 00       	mov    $0x0,%ecx
  80180e:	ba 00 00 00 00       	mov    $0x0,%edx
  801813:	be 00 00 00 00       	mov    $0x0,%esi
  801818:	bf 01 00 00 00       	mov    $0x1,%edi
  80181d:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  801824:	00 00 00 
  801827:	ff d0                	callq  *%rax
}
  801829:	c9                   	leaveq 
  80182a:	c3                   	retq   

000000000080182b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80182b:	55                   	push   %rbp
  80182c:	48 89 e5             	mov    %rsp,%rbp
  80182f:	48 83 ec 10          	sub    $0x10,%rsp
  801833:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801836:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801839:	48 98                	cltq   
  80183b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801842:	00 
  801843:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801849:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80184f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801854:	48 89 c2             	mov    %rax,%rdx
  801857:	be 01 00 00 00       	mov    $0x1,%esi
  80185c:	bf 03 00 00 00       	mov    $0x3,%edi
  801861:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  801868:	00 00 00 
  80186b:	ff d0                	callq  *%rax
}
  80186d:	c9                   	leaveq 
  80186e:	c3                   	retq   

000000000080186f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80186f:	55                   	push   %rbp
  801870:	48 89 e5             	mov    %rsp,%rbp
  801873:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801877:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80187e:	00 
  80187f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801885:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80188b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801890:	ba 00 00 00 00       	mov    $0x0,%edx
  801895:	be 00 00 00 00       	mov    $0x0,%esi
  80189a:	bf 02 00 00 00       	mov    $0x2,%edi
  80189f:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  8018a6:	00 00 00 
  8018a9:	ff d0                	callq  *%rax
}
  8018ab:	c9                   	leaveq 
  8018ac:	c3                   	retq   

00000000008018ad <sys_yield>:

void
sys_yield(void)
{
  8018ad:	55                   	push   %rbp
  8018ae:	48 89 e5             	mov    %rsp,%rbp
  8018b1:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8018b5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018bc:	00 
  8018bd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d3:	be 00 00 00 00       	mov    $0x0,%esi
  8018d8:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018dd:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  8018e4:	00 00 00 
  8018e7:	ff d0                	callq  *%rax
}
  8018e9:	c9                   	leaveq 
  8018ea:	c3                   	retq   

00000000008018eb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018eb:	55                   	push   %rbp
  8018ec:	48 89 e5             	mov    %rsp,%rbp
  8018ef:	48 83 ec 20          	sub    $0x20,%rsp
  8018f3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018fa:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801900:	48 63 c8             	movslq %eax,%rcx
  801903:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801907:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190a:	48 98                	cltq   
  80190c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801913:	00 
  801914:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80191a:	49 89 c8             	mov    %rcx,%r8
  80191d:	48 89 d1             	mov    %rdx,%rcx
  801920:	48 89 c2             	mov    %rax,%rdx
  801923:	be 01 00 00 00       	mov    $0x1,%esi
  801928:	bf 04 00 00 00       	mov    $0x4,%edi
  80192d:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  801934:	00 00 00 
  801937:	ff d0                	callq  *%rax
}
  801939:	c9                   	leaveq 
  80193a:	c3                   	retq   

000000000080193b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80193b:	55                   	push   %rbp
  80193c:	48 89 e5             	mov    %rsp,%rbp
  80193f:	48 83 ec 30          	sub    $0x30,%rsp
  801943:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801946:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80194a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80194d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801951:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801955:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801958:	48 63 c8             	movslq %eax,%rcx
  80195b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80195f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801962:	48 63 f0             	movslq %eax,%rsi
  801965:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801969:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196c:	48 98                	cltq   
  80196e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801972:	49 89 f9             	mov    %rdi,%r9
  801975:	49 89 f0             	mov    %rsi,%r8
  801978:	48 89 d1             	mov    %rdx,%rcx
  80197b:	48 89 c2             	mov    %rax,%rdx
  80197e:	be 01 00 00 00       	mov    $0x1,%esi
  801983:	bf 05 00 00 00       	mov    $0x5,%edi
  801988:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  80198f:	00 00 00 
  801992:	ff d0                	callq  *%rax
}
  801994:	c9                   	leaveq 
  801995:	c3                   	retq   

0000000000801996 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801996:	55                   	push   %rbp
  801997:	48 89 e5             	mov    %rsp,%rbp
  80199a:	48 83 ec 20          	sub    $0x20,%rsp
  80199e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8019a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ac:	48 98                	cltq   
  8019ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b5:	00 
  8019b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c2:	48 89 d1             	mov    %rdx,%rcx
  8019c5:	48 89 c2             	mov    %rax,%rdx
  8019c8:	be 01 00 00 00       	mov    $0x1,%esi
  8019cd:	bf 06 00 00 00       	mov    $0x6,%edi
  8019d2:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  8019d9:	00 00 00 
  8019dc:	ff d0                	callq  *%rax
}
  8019de:	c9                   	leaveq 
  8019df:	c3                   	retq   

00000000008019e0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019e0:	55                   	push   %rbp
  8019e1:	48 89 e5             	mov    %rsp,%rbp
  8019e4:	48 83 ec 10          	sub    $0x10,%rsp
  8019e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019eb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019f1:	48 63 d0             	movslq %eax,%rdx
  8019f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f7:	48 98                	cltq   
  8019f9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a00:	00 
  801a01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0d:	48 89 d1             	mov    %rdx,%rcx
  801a10:	48 89 c2             	mov    %rax,%rdx
  801a13:	be 01 00 00 00       	mov    $0x1,%esi
  801a18:	bf 08 00 00 00       	mov    $0x8,%edi
  801a1d:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  801a24:	00 00 00 
  801a27:	ff d0                	callq  *%rax
}
  801a29:	c9                   	leaveq 
  801a2a:	c3                   	retq   

0000000000801a2b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a2b:	55                   	push   %rbp
  801a2c:	48 89 e5             	mov    %rsp,%rbp
  801a2f:	48 83 ec 20          	sub    $0x20,%rsp
  801a33:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a41:	48 98                	cltq   
  801a43:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4a:	00 
  801a4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a57:	48 89 d1             	mov    %rdx,%rcx
  801a5a:	48 89 c2             	mov    %rax,%rdx
  801a5d:	be 01 00 00 00       	mov    $0x1,%esi
  801a62:	bf 09 00 00 00       	mov    $0x9,%edi
  801a67:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  801a6e:	00 00 00 
  801a71:	ff d0                	callq  *%rax
}
  801a73:	c9                   	leaveq 
  801a74:	c3                   	retq   

0000000000801a75 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a75:	55                   	push   %rbp
  801a76:	48 89 e5             	mov    %rsp,%rbp
  801a79:	48 83 ec 20          	sub    $0x20,%rsp
  801a7d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a80:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8b:	48 98                	cltq   
  801a8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a94:	00 
  801a95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa1:	48 89 d1             	mov    %rdx,%rcx
  801aa4:	48 89 c2             	mov    %rax,%rdx
  801aa7:	be 01 00 00 00       	mov    $0x1,%esi
  801aac:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ab1:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  801ab8:	00 00 00 
  801abb:	ff d0                	callq  *%rax
}
  801abd:	c9                   	leaveq 
  801abe:	c3                   	retq   

0000000000801abf <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801abf:	55                   	push   %rbp
  801ac0:	48 89 e5             	mov    %rsp,%rbp
  801ac3:	48 83 ec 10          	sub    $0x10,%rsp
  801ac7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aca:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801acd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ad0:	48 63 d0             	movslq %eax,%rdx
  801ad3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad6:	48 98                	cltq   
  801ad8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801adf:	00 
  801ae0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aec:	48 89 d1             	mov    %rdx,%rcx
  801aef:	48 89 c2             	mov    %rax,%rdx
  801af2:	be 01 00 00 00       	mov    $0x1,%esi
  801af7:	bf 11 00 00 00       	mov    $0x11,%edi
  801afc:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  801b03:	00 00 00 
  801b06:	ff d0                	callq  *%rax

}
  801b08:	c9                   	leaveq 
  801b09:	c3                   	retq   

0000000000801b0a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b0a:	55                   	push   %rbp
  801b0b:	48 89 e5             	mov    %rsp,%rbp
  801b0e:	48 83 ec 20          	sub    $0x20,%rsp
  801b12:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b19:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b1d:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b20:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b23:	48 63 f0             	movslq %eax,%rsi
  801b26:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2d:	48 98                	cltq   
  801b2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b33:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3a:	00 
  801b3b:	49 89 f1             	mov    %rsi,%r9
  801b3e:	49 89 c8             	mov    %rcx,%r8
  801b41:	48 89 d1             	mov    %rdx,%rcx
  801b44:	48 89 c2             	mov    %rax,%rdx
  801b47:	be 00 00 00 00       	mov    $0x0,%esi
  801b4c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b51:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  801b58:	00 00 00 
  801b5b:	ff d0                	callq  *%rax
}
  801b5d:	c9                   	leaveq 
  801b5e:	c3                   	retq   

0000000000801b5f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b5f:	55                   	push   %rbp
  801b60:	48 89 e5             	mov    %rsp,%rbp
  801b63:	48 83 ec 10          	sub    $0x10,%rsp
  801b67:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b6f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b76:	00 
  801b77:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b83:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b88:	48 89 c2             	mov    %rax,%rdx
  801b8b:	be 01 00 00 00       	mov    $0x1,%esi
  801b90:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b95:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  801b9c:	00 00 00 
  801b9f:	ff d0                	callq  *%rax
}
  801ba1:	c9                   	leaveq 
  801ba2:	c3                   	retq   

0000000000801ba3 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801ba3:	55                   	push   %rbp
  801ba4:	48 89 e5             	mov    %rsp,%rbp
  801ba7:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801bab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb2:	00 
  801bb3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bbf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc9:	be 00 00 00 00       	mov    $0x0,%esi
  801bce:	bf 0e 00 00 00       	mov    $0xe,%edi
  801bd3:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  801bda:	00 00 00 
  801bdd:	ff d0                	callq  *%rax
}
  801bdf:	c9                   	leaveq 
  801be0:	c3                   	retq   

0000000000801be1 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801be1:	55                   	push   %rbp
  801be2:	48 89 e5             	mov    %rsp,%rbp
  801be5:	48 83 ec 30          	sub    $0x30,%rsp
  801be9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bf0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bf3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bf7:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801bfb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bfe:	48 63 c8             	movslq %eax,%rcx
  801c01:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c08:	48 63 f0             	movslq %eax,%rsi
  801c0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c12:	48 98                	cltq   
  801c14:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c18:	49 89 f9             	mov    %rdi,%r9
  801c1b:	49 89 f0             	mov    %rsi,%r8
  801c1e:	48 89 d1             	mov    %rdx,%rcx
  801c21:	48 89 c2             	mov    %rax,%rdx
  801c24:	be 00 00 00 00       	mov    $0x0,%esi
  801c29:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c2e:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  801c35:	00 00 00 
  801c38:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801c3a:	c9                   	leaveq 
  801c3b:	c3                   	retq   

0000000000801c3c <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801c3c:	55                   	push   %rbp
  801c3d:	48 89 e5             	mov    %rsp,%rbp
  801c40:	48 83 ec 20          	sub    $0x20,%rsp
  801c44:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c48:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801c4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c54:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c5b:	00 
  801c5c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c62:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c68:	48 89 d1             	mov    %rdx,%rcx
  801c6b:	48 89 c2             	mov    %rax,%rdx
  801c6e:	be 00 00 00 00       	mov    $0x0,%esi
  801c73:	bf 10 00 00 00       	mov    $0x10,%edi
  801c78:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  801c7f:	00 00 00 
  801c82:	ff d0                	callq  *%rax
}
  801c84:	c9                   	leaveq 
  801c85:	c3                   	retq   

0000000000801c86 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c86:	55                   	push   %rbp
  801c87:	48 89 e5             	mov    %rsp,%rbp
  801c8a:	48 83 ec 08          	sub    $0x8,%rsp
  801c8e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c92:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c96:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c9d:	ff ff ff 
  801ca0:	48 01 d0             	add    %rdx,%rax
  801ca3:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ca7:	c9                   	leaveq 
  801ca8:	c3                   	retq   

0000000000801ca9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ca9:	55                   	push   %rbp
  801caa:	48 89 e5             	mov    %rsp,%rbp
  801cad:	48 83 ec 08          	sub    $0x8,%rsp
  801cb1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801cb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb9:	48 89 c7             	mov    %rax,%rdi
  801cbc:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  801cc3:	00 00 00 
  801cc6:	ff d0                	callq  *%rax
  801cc8:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801cce:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801cd2:	c9                   	leaveq 
  801cd3:	c3                   	retq   

0000000000801cd4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801cd4:	55                   	push   %rbp
  801cd5:	48 89 e5             	mov    %rsp,%rbp
  801cd8:	48 83 ec 18          	sub    $0x18,%rsp
  801cdc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ce0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ce7:	eb 6b                	jmp    801d54 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ce9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cec:	48 98                	cltq   
  801cee:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801cf4:	48 c1 e0 0c          	shl    $0xc,%rax
  801cf8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801cfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d00:	48 c1 e8 15          	shr    $0x15,%rax
  801d04:	48 89 c2             	mov    %rax,%rdx
  801d07:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d0e:	01 00 00 
  801d11:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d15:	83 e0 01             	and    $0x1,%eax
  801d18:	48 85 c0             	test   %rax,%rax
  801d1b:	74 21                	je     801d3e <fd_alloc+0x6a>
  801d1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d21:	48 c1 e8 0c          	shr    $0xc,%rax
  801d25:	48 89 c2             	mov    %rax,%rdx
  801d28:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d2f:	01 00 00 
  801d32:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d36:	83 e0 01             	and    $0x1,%eax
  801d39:	48 85 c0             	test   %rax,%rax
  801d3c:	75 12                	jne    801d50 <fd_alloc+0x7c>
			*fd_store = fd;
  801d3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d46:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d49:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4e:	eb 1a                	jmp    801d6a <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d50:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d54:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d58:	7e 8f                	jle    801ce9 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d5e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d65:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d6a:	c9                   	leaveq 
  801d6b:	c3                   	retq   

0000000000801d6c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d6c:	55                   	push   %rbp
  801d6d:	48 89 e5             	mov    %rsp,%rbp
  801d70:	48 83 ec 20          	sub    $0x20,%rsp
  801d74:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d77:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d7f:	78 06                	js     801d87 <fd_lookup+0x1b>
  801d81:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d85:	7e 07                	jle    801d8e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d8c:	eb 6c                	jmp    801dfa <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d91:	48 98                	cltq   
  801d93:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d99:	48 c1 e0 0c          	shl    $0xc,%rax
  801d9d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801da1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da5:	48 c1 e8 15          	shr    $0x15,%rax
  801da9:	48 89 c2             	mov    %rax,%rdx
  801dac:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801db3:	01 00 00 
  801db6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dba:	83 e0 01             	and    $0x1,%eax
  801dbd:	48 85 c0             	test   %rax,%rax
  801dc0:	74 21                	je     801de3 <fd_lookup+0x77>
  801dc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc6:	48 c1 e8 0c          	shr    $0xc,%rax
  801dca:	48 89 c2             	mov    %rax,%rdx
  801dcd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dd4:	01 00 00 
  801dd7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ddb:	83 e0 01             	and    $0x1,%eax
  801dde:	48 85 c0             	test   %rax,%rax
  801de1:	75 07                	jne    801dea <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801de3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801de8:	eb 10                	jmp    801dfa <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801dea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801df2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801df5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfa:	c9                   	leaveq 
  801dfb:	c3                   	retq   

0000000000801dfc <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801dfc:	55                   	push   %rbp
  801dfd:	48 89 e5             	mov    %rsp,%rbp
  801e00:	48 83 ec 30          	sub    $0x30,%rsp
  801e04:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e08:	89 f0                	mov    %esi,%eax
  801e0a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e11:	48 89 c7             	mov    %rax,%rdi
  801e14:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  801e1b:	00 00 00 
  801e1e:	ff d0                	callq  *%rax
  801e20:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e24:	48 89 d6             	mov    %rdx,%rsi
  801e27:	89 c7                	mov    %eax,%edi
  801e29:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  801e30:	00 00 00 
  801e33:	ff d0                	callq  *%rax
  801e35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e3c:	78 0a                	js     801e48 <fd_close+0x4c>
	    || fd != fd2)
  801e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e42:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e46:	74 12                	je     801e5a <fd_close+0x5e>
		return (must_exist ? r : 0);
  801e48:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801e4c:	74 05                	je     801e53 <fd_close+0x57>
  801e4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e51:	eb 05                	jmp    801e58 <fd_close+0x5c>
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
  801e58:	eb 69                	jmp    801ec3 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5e:	8b 00                	mov    (%rax),%eax
  801e60:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e64:	48 89 d6             	mov    %rdx,%rsi
  801e67:	89 c7                	mov    %eax,%edi
  801e69:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  801e70:	00 00 00 
  801e73:	ff d0                	callq  *%rax
  801e75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e7c:	78 2a                	js     801ea8 <fd_close+0xac>
		if (dev->dev_close)
  801e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e82:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e86:	48 85 c0             	test   %rax,%rax
  801e89:	74 16                	je     801ea1 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801e8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e8f:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e93:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e97:	48 89 d7             	mov    %rdx,%rdi
  801e9a:	ff d0                	callq  *%rax
  801e9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e9f:	eb 07                	jmp    801ea8 <fd_close+0xac>
		else
			r = 0;
  801ea1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ea8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eac:	48 89 c6             	mov    %rax,%rsi
  801eaf:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb4:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  801ebb:	00 00 00 
  801ebe:	ff d0                	callq  *%rax
	return r;
  801ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ec3:	c9                   	leaveq 
  801ec4:	c3                   	retq   

0000000000801ec5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ec5:	55                   	push   %rbp
  801ec6:	48 89 e5             	mov    %rsp,%rbp
  801ec9:	48 83 ec 20          	sub    $0x20,%rsp
  801ecd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ed0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801ed4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801edb:	eb 41                	jmp    801f1e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801edd:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ee4:	00 00 00 
  801ee7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801eea:	48 63 d2             	movslq %edx,%rdx
  801eed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ef1:	8b 00                	mov    (%rax),%eax
  801ef3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801ef6:	75 22                	jne    801f1a <dev_lookup+0x55>
			*dev = devtab[i];
  801ef8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801eff:	00 00 00 
  801f02:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f05:	48 63 d2             	movslq %edx,%rdx
  801f08:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f10:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
  801f18:	eb 60                	jmp    801f7a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f1a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f1e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f25:	00 00 00 
  801f28:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f2b:	48 63 d2             	movslq %edx,%rdx
  801f2e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f32:	48 85 c0             	test   %rax,%rax
  801f35:	75 a6                	jne    801edd <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f37:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801f3e:	00 00 00 
  801f41:	48 8b 00             	mov    (%rax),%rax
  801f44:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f4a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f4d:	89 c6                	mov    %eax,%esi
  801f4f:	48 bf 58 48 80 00 00 	movabs $0x804858,%rdi
  801f56:	00 00 00 
  801f59:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5e:	48 b9 c6 03 80 00 00 	movabs $0x8003c6,%rcx
  801f65:	00 00 00 
  801f68:	ff d1                	callq  *%rcx
	*dev = 0;
  801f6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f6e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f7a:	c9                   	leaveq 
  801f7b:	c3                   	retq   

0000000000801f7c <close>:

int
close(int fdnum)
{
  801f7c:	55                   	push   %rbp
  801f7d:	48 89 e5             	mov    %rsp,%rbp
  801f80:	48 83 ec 20          	sub    $0x20,%rsp
  801f84:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f87:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f8e:	48 89 d6             	mov    %rdx,%rsi
  801f91:	89 c7                	mov    %eax,%edi
  801f93:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  801f9a:	00 00 00 
  801f9d:	ff d0                	callq  *%rax
  801f9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fa6:	79 05                	jns    801fad <close+0x31>
		return r;
  801fa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fab:	eb 18                	jmp    801fc5 <close+0x49>
	else
		return fd_close(fd, 1);
  801fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb1:	be 01 00 00 00       	mov    $0x1,%esi
  801fb6:	48 89 c7             	mov    %rax,%rdi
  801fb9:	48 b8 fc 1d 80 00 00 	movabs $0x801dfc,%rax
  801fc0:	00 00 00 
  801fc3:	ff d0                	callq  *%rax
}
  801fc5:	c9                   	leaveq 
  801fc6:	c3                   	retq   

0000000000801fc7 <close_all>:

void
close_all(void)
{
  801fc7:	55                   	push   %rbp
  801fc8:	48 89 e5             	mov    %rsp,%rbp
  801fcb:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801fcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fd6:	eb 15                	jmp    801fed <close_all+0x26>
		close(i);
  801fd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fdb:	89 c7                	mov    %eax,%edi
  801fdd:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  801fe4:	00 00 00 
  801fe7:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801fe9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fed:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ff1:	7e e5                	jle    801fd8 <close_all+0x11>
		close(i);
}
  801ff3:	c9                   	leaveq 
  801ff4:	c3                   	retq   

0000000000801ff5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ff5:	55                   	push   %rbp
  801ff6:	48 89 e5             	mov    %rsp,%rbp
  801ff9:	48 83 ec 40          	sub    $0x40,%rsp
  801ffd:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802000:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802003:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802007:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80200a:	48 89 d6             	mov    %rdx,%rsi
  80200d:	89 c7                	mov    %eax,%edi
  80200f:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  802016:	00 00 00 
  802019:	ff d0                	callq  *%rax
  80201b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80201e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802022:	79 08                	jns    80202c <dup+0x37>
		return r;
  802024:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802027:	e9 70 01 00 00       	jmpq   80219c <dup+0x1a7>
	close(newfdnum);
  80202c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80202f:	89 c7                	mov    %eax,%edi
  802031:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802038:	00 00 00 
  80203b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80203d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802040:	48 98                	cltq   
  802042:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802048:	48 c1 e0 0c          	shl    $0xc,%rax
  80204c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802050:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802054:	48 89 c7             	mov    %rax,%rdi
  802057:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  80205e:	00 00 00 
  802061:	ff d0                	callq  *%rax
  802063:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802067:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80206b:	48 89 c7             	mov    %rax,%rdi
  80206e:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  802075:	00 00 00 
  802078:	ff d0                	callq  *%rax
  80207a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80207e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802082:	48 c1 e8 15          	shr    $0x15,%rax
  802086:	48 89 c2             	mov    %rax,%rdx
  802089:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802090:	01 00 00 
  802093:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802097:	83 e0 01             	and    $0x1,%eax
  80209a:	48 85 c0             	test   %rax,%rax
  80209d:	74 73                	je     802112 <dup+0x11d>
  80209f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a3:	48 c1 e8 0c          	shr    $0xc,%rax
  8020a7:	48 89 c2             	mov    %rax,%rdx
  8020aa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020b1:	01 00 00 
  8020b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b8:	83 e0 01             	and    $0x1,%eax
  8020bb:	48 85 c0             	test   %rax,%rax
  8020be:	74 52                	je     802112 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c4:	48 c1 e8 0c          	shr    $0xc,%rax
  8020c8:	48 89 c2             	mov    %rax,%rdx
  8020cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020d2:	01 00 00 
  8020d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020d9:	25 07 0e 00 00       	and    $0xe07,%eax
  8020de:	89 c1                	mov    %eax,%ecx
  8020e0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8020e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e8:	41 89 c8             	mov    %ecx,%r8d
  8020eb:	48 89 d1             	mov    %rdx,%rcx
  8020ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f3:	48 89 c6             	mov    %rax,%rsi
  8020f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8020fb:	48 b8 3b 19 80 00 00 	movabs $0x80193b,%rax
  802102:	00 00 00 
  802105:	ff d0                	callq  *%rax
  802107:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80210a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80210e:	79 02                	jns    802112 <dup+0x11d>
			goto err;
  802110:	eb 57                	jmp    802169 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802112:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802116:	48 c1 e8 0c          	shr    $0xc,%rax
  80211a:	48 89 c2             	mov    %rax,%rdx
  80211d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802124:	01 00 00 
  802127:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212b:	25 07 0e 00 00       	and    $0xe07,%eax
  802130:	89 c1                	mov    %eax,%ecx
  802132:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802136:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80213a:	41 89 c8             	mov    %ecx,%r8d
  80213d:	48 89 d1             	mov    %rdx,%rcx
  802140:	ba 00 00 00 00       	mov    $0x0,%edx
  802145:	48 89 c6             	mov    %rax,%rsi
  802148:	bf 00 00 00 00       	mov    $0x0,%edi
  80214d:	48 b8 3b 19 80 00 00 	movabs $0x80193b,%rax
  802154:	00 00 00 
  802157:	ff d0                	callq  *%rax
  802159:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80215c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802160:	79 02                	jns    802164 <dup+0x16f>
		goto err;
  802162:	eb 05                	jmp    802169 <dup+0x174>

	return newfdnum;
  802164:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802167:	eb 33                	jmp    80219c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802169:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80216d:	48 89 c6             	mov    %rax,%rsi
  802170:	bf 00 00 00 00       	mov    $0x0,%edi
  802175:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  80217c:	00 00 00 
  80217f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802181:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802185:	48 89 c6             	mov    %rax,%rsi
  802188:	bf 00 00 00 00       	mov    $0x0,%edi
  80218d:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  802194:	00 00 00 
  802197:	ff d0                	callq  *%rax
	return r;
  802199:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80219c:	c9                   	leaveq 
  80219d:	c3                   	retq   

000000000080219e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80219e:	55                   	push   %rbp
  80219f:	48 89 e5             	mov    %rsp,%rbp
  8021a2:	48 83 ec 40          	sub    $0x40,%rsp
  8021a6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021ad:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021b1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021b5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021b8:	48 89 d6             	mov    %rdx,%rsi
  8021bb:	89 c7                	mov    %eax,%edi
  8021bd:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8021c4:	00 00 00 
  8021c7:	ff d0                	callq  *%rax
  8021c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d0:	78 24                	js     8021f6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d6:	8b 00                	mov    (%rax),%eax
  8021d8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021dc:	48 89 d6             	mov    %rdx,%rsi
  8021df:	89 c7                	mov    %eax,%edi
  8021e1:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  8021e8:	00 00 00 
  8021eb:	ff d0                	callq  *%rax
  8021ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021f4:	79 05                	jns    8021fb <read+0x5d>
		return r;
  8021f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f9:	eb 76                	jmp    802271 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8021fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ff:	8b 40 08             	mov    0x8(%rax),%eax
  802202:	83 e0 03             	and    $0x3,%eax
  802205:	83 f8 01             	cmp    $0x1,%eax
  802208:	75 3a                	jne    802244 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80220a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802211:	00 00 00 
  802214:	48 8b 00             	mov    (%rax),%rax
  802217:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80221d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802220:	89 c6                	mov    %eax,%esi
  802222:	48 bf 77 48 80 00 00 	movabs $0x804877,%rdi
  802229:	00 00 00 
  80222c:	b8 00 00 00 00       	mov    $0x0,%eax
  802231:	48 b9 c6 03 80 00 00 	movabs $0x8003c6,%rcx
  802238:	00 00 00 
  80223b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80223d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802242:	eb 2d                	jmp    802271 <read+0xd3>
	}
	if (!dev->dev_read)
  802244:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802248:	48 8b 40 10          	mov    0x10(%rax),%rax
  80224c:	48 85 c0             	test   %rax,%rax
  80224f:	75 07                	jne    802258 <read+0xba>
		return -E_NOT_SUPP;
  802251:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802256:	eb 19                	jmp    802271 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802260:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802264:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802268:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80226c:	48 89 cf             	mov    %rcx,%rdi
  80226f:	ff d0                	callq  *%rax
}
  802271:	c9                   	leaveq 
  802272:	c3                   	retq   

0000000000802273 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802273:	55                   	push   %rbp
  802274:	48 89 e5             	mov    %rsp,%rbp
  802277:	48 83 ec 30          	sub    $0x30,%rsp
  80227b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80227e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802282:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802286:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80228d:	eb 49                	jmp    8022d8 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80228f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802292:	48 98                	cltq   
  802294:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802298:	48 29 c2             	sub    %rax,%rdx
  80229b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229e:	48 63 c8             	movslq %eax,%rcx
  8022a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022a5:	48 01 c1             	add    %rax,%rcx
  8022a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022ab:	48 89 ce             	mov    %rcx,%rsi
  8022ae:	89 c7                	mov    %eax,%edi
  8022b0:	48 b8 9e 21 80 00 00 	movabs $0x80219e,%rax
  8022b7:	00 00 00 
  8022ba:	ff d0                	callq  *%rax
  8022bc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8022bf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022c3:	79 05                	jns    8022ca <readn+0x57>
			return m;
  8022c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022c8:	eb 1c                	jmp    8022e6 <readn+0x73>
		if (m == 0)
  8022ca:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022ce:	75 02                	jne    8022d2 <readn+0x5f>
			break;
  8022d0:	eb 11                	jmp    8022e3 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8022d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022db:	48 98                	cltq   
  8022dd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8022e1:	72 ac                	jb     80228f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8022e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022e6:	c9                   	leaveq 
  8022e7:	c3                   	retq   

00000000008022e8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8022e8:	55                   	push   %rbp
  8022e9:	48 89 e5             	mov    %rsp,%rbp
  8022ec:	48 83 ec 40          	sub    $0x40,%rsp
  8022f0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022f3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022f7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022fb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022ff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802302:	48 89 d6             	mov    %rdx,%rsi
  802305:	89 c7                	mov    %eax,%edi
  802307:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  80230e:	00 00 00 
  802311:	ff d0                	callq  *%rax
  802313:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802316:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80231a:	78 24                	js     802340 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80231c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802320:	8b 00                	mov    (%rax),%eax
  802322:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802326:	48 89 d6             	mov    %rdx,%rsi
  802329:	89 c7                	mov    %eax,%edi
  80232b:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  802332:	00 00 00 
  802335:	ff d0                	callq  *%rax
  802337:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80233a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80233e:	79 05                	jns    802345 <write+0x5d>
		return r;
  802340:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802343:	eb 75                	jmp    8023ba <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802345:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802349:	8b 40 08             	mov    0x8(%rax),%eax
  80234c:	83 e0 03             	and    $0x3,%eax
  80234f:	85 c0                	test   %eax,%eax
  802351:	75 3a                	jne    80238d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802353:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80235a:	00 00 00 
  80235d:	48 8b 00             	mov    (%rax),%rax
  802360:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802366:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802369:	89 c6                	mov    %eax,%esi
  80236b:	48 bf 93 48 80 00 00 	movabs $0x804893,%rdi
  802372:	00 00 00 
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
  80237a:	48 b9 c6 03 80 00 00 	movabs $0x8003c6,%rcx
  802381:	00 00 00 
  802384:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802386:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80238b:	eb 2d                	jmp    8023ba <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80238d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802391:	48 8b 40 18          	mov    0x18(%rax),%rax
  802395:	48 85 c0             	test   %rax,%rax
  802398:	75 07                	jne    8023a1 <write+0xb9>
		return -E_NOT_SUPP;
  80239a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80239f:	eb 19                	jmp    8023ba <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8023a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023a9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023ad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023b1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023b5:	48 89 cf             	mov    %rcx,%rdi
  8023b8:	ff d0                	callq  *%rax
}
  8023ba:	c9                   	leaveq 
  8023bb:	c3                   	retq   

00000000008023bc <seek>:

int
seek(int fdnum, off_t offset)
{
  8023bc:	55                   	push   %rbp
  8023bd:	48 89 e5             	mov    %rsp,%rbp
  8023c0:	48 83 ec 18          	sub    $0x18,%rsp
  8023c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023c7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023d1:	48 89 d6             	mov    %rdx,%rsi
  8023d4:	89 c7                	mov    %eax,%edi
  8023d6:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8023dd:	00 00 00 
  8023e0:	ff d0                	callq  *%rax
  8023e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e9:	79 05                	jns    8023f0 <seek+0x34>
		return r;
  8023eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ee:	eb 0f                	jmp    8023ff <seek+0x43>
	fd->fd_offset = offset;
  8023f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8023f7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8023fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ff:	c9                   	leaveq 
  802400:	c3                   	retq   

0000000000802401 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802401:	55                   	push   %rbp
  802402:	48 89 e5             	mov    %rsp,%rbp
  802405:	48 83 ec 30          	sub    $0x30,%rsp
  802409:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80240c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80240f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802413:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802416:	48 89 d6             	mov    %rdx,%rsi
  802419:	89 c7                	mov    %eax,%edi
  80241b:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  802422:	00 00 00 
  802425:	ff d0                	callq  *%rax
  802427:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80242a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80242e:	78 24                	js     802454 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802430:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802434:	8b 00                	mov    (%rax),%eax
  802436:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80243a:	48 89 d6             	mov    %rdx,%rsi
  80243d:	89 c7                	mov    %eax,%edi
  80243f:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  802446:	00 00 00 
  802449:	ff d0                	callq  *%rax
  80244b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802452:	79 05                	jns    802459 <ftruncate+0x58>
		return r;
  802454:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802457:	eb 72                	jmp    8024cb <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802459:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245d:	8b 40 08             	mov    0x8(%rax),%eax
  802460:	83 e0 03             	and    $0x3,%eax
  802463:	85 c0                	test   %eax,%eax
  802465:	75 3a                	jne    8024a1 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802467:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80246e:	00 00 00 
  802471:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802474:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80247a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80247d:	89 c6                	mov    %eax,%esi
  80247f:	48 bf b0 48 80 00 00 	movabs $0x8048b0,%rdi
  802486:	00 00 00 
  802489:	b8 00 00 00 00       	mov    $0x0,%eax
  80248e:	48 b9 c6 03 80 00 00 	movabs $0x8003c6,%rcx
  802495:	00 00 00 
  802498:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80249a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80249f:	eb 2a                	jmp    8024cb <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8024a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024a9:	48 85 c0             	test   %rax,%rax
  8024ac:	75 07                	jne    8024b5 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8024ae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024b3:	eb 16                	jmp    8024cb <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8024b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024c1:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8024c4:	89 ce                	mov    %ecx,%esi
  8024c6:	48 89 d7             	mov    %rdx,%rdi
  8024c9:	ff d0                	callq  *%rax
}
  8024cb:	c9                   	leaveq 
  8024cc:	c3                   	retq   

00000000008024cd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024cd:	55                   	push   %rbp
  8024ce:	48 89 e5             	mov    %rsp,%rbp
  8024d1:	48 83 ec 30          	sub    $0x30,%rsp
  8024d5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024d8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024dc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024e3:	48 89 d6             	mov    %rdx,%rsi
  8024e6:	89 c7                	mov    %eax,%edi
  8024e8:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8024ef:	00 00 00 
  8024f2:	ff d0                	callq  *%rax
  8024f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024fb:	78 24                	js     802521 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802501:	8b 00                	mov    (%rax),%eax
  802503:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802507:	48 89 d6             	mov    %rdx,%rsi
  80250a:	89 c7                	mov    %eax,%edi
  80250c:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  802513:	00 00 00 
  802516:	ff d0                	callq  *%rax
  802518:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80251f:	79 05                	jns    802526 <fstat+0x59>
		return r;
  802521:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802524:	eb 5e                	jmp    802584 <fstat+0xb7>
	if (!dev->dev_stat)
  802526:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80252e:	48 85 c0             	test   %rax,%rax
  802531:	75 07                	jne    80253a <fstat+0x6d>
		return -E_NOT_SUPP;
  802533:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802538:	eb 4a                	jmp    802584 <fstat+0xb7>
	stat->st_name[0] = 0;
  80253a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80253e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802541:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802545:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80254c:	00 00 00 
	stat->st_isdir = 0;
  80254f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802553:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80255a:	00 00 00 
	stat->st_dev = dev;
  80255d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802561:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802565:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80256c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802570:	48 8b 40 28          	mov    0x28(%rax),%rax
  802574:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802578:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80257c:	48 89 ce             	mov    %rcx,%rsi
  80257f:	48 89 d7             	mov    %rdx,%rdi
  802582:	ff d0                	callq  *%rax
}
  802584:	c9                   	leaveq 
  802585:	c3                   	retq   

0000000000802586 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802586:	55                   	push   %rbp
  802587:	48 89 e5             	mov    %rsp,%rbp
  80258a:	48 83 ec 20          	sub    $0x20,%rsp
  80258e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802592:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802596:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259a:	be 00 00 00 00       	mov    $0x0,%esi
  80259f:	48 89 c7             	mov    %rax,%rdi
  8025a2:	48 b8 74 26 80 00 00 	movabs $0x802674,%rax
  8025a9:	00 00 00 
  8025ac:	ff d0                	callq  *%rax
  8025ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b5:	79 05                	jns    8025bc <stat+0x36>
		return fd;
  8025b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ba:	eb 2f                	jmp    8025eb <stat+0x65>
	r = fstat(fd, stat);
  8025bc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c3:	48 89 d6             	mov    %rdx,%rsi
  8025c6:	89 c7                	mov    %eax,%edi
  8025c8:	48 b8 cd 24 80 00 00 	movabs $0x8024cd,%rax
  8025cf:	00 00 00 
  8025d2:	ff d0                	callq  *%rax
  8025d4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8025d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025da:	89 c7                	mov    %eax,%edi
  8025dc:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  8025e3:	00 00 00 
  8025e6:	ff d0                	callq  *%rax
	return r;
  8025e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025eb:	c9                   	leaveq 
  8025ec:	c3                   	retq   

00000000008025ed <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8025ed:	55                   	push   %rbp
  8025ee:	48 89 e5             	mov    %rsp,%rbp
  8025f1:	48 83 ec 10          	sub    $0x10,%rsp
  8025f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8025fc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802603:	00 00 00 
  802606:	8b 00                	mov    (%rax),%eax
  802608:	85 c0                	test   %eax,%eax
  80260a:	75 1d                	jne    802629 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80260c:	bf 01 00 00 00       	mov    $0x1,%edi
  802611:	48 b8 b9 41 80 00 00 	movabs $0x8041b9,%rax
  802618:	00 00 00 
  80261b:	ff d0                	callq  *%rax
  80261d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802624:	00 00 00 
  802627:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802629:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802630:	00 00 00 
  802633:	8b 00                	mov    (%rax),%eax
  802635:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802638:	b9 07 00 00 00       	mov    $0x7,%ecx
  80263d:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802644:	00 00 00 
  802647:	89 c7                	mov    %eax,%edi
  802649:	48 b8 ba 40 80 00 00 	movabs $0x8040ba,%rax
  802650:	00 00 00 
  802653:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802655:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802659:	ba 00 00 00 00       	mov    $0x0,%edx
  80265e:	48 89 c6             	mov    %rax,%rsi
  802661:	bf 00 00 00 00       	mov    $0x0,%edi
  802666:	48 b8 07 40 80 00 00 	movabs $0x804007,%rax
  80266d:	00 00 00 
  802670:	ff d0                	callq  *%rax
}
  802672:	c9                   	leaveq 
  802673:	c3                   	retq   

0000000000802674 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802674:	55                   	push   %rbp
  802675:	48 89 e5             	mov    %rsp,%rbp
  802678:	48 83 ec 20          	sub    $0x20,%rsp
  80267c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802680:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  802683:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802687:	48 89 c7             	mov    %rax,%rdi
  80268a:	48 b8 50 0f 80 00 00 	movabs $0x800f50,%rax
  802691:	00 00 00 
  802694:	ff d0                	callq  *%rax
  802696:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80269b:	7e 0a                	jle    8026a7 <open+0x33>
		return -E_BAD_PATH;
  80269d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8026a2:	e9 a5 00 00 00       	jmpq   80274c <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  8026a7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8026ab:	48 89 c7             	mov    %rax,%rdi
  8026ae:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	callq  *%rax
  8026ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c1:	79 08                	jns    8026cb <open+0x57>
		return ret;
  8026c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c6:	e9 81 00 00 00       	jmpq   80274c <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  8026cb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026d2:	00 00 00 
  8026d5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8026d8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  8026de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e2:	48 89 c6             	mov    %rax,%rsi
  8026e5:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8026ec:	00 00 00 
  8026ef:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  8026f6:	00 00 00 
  8026f9:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  8026fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ff:	48 89 c6             	mov    %rax,%rsi
  802702:	bf 01 00 00 00       	mov    $0x1,%edi
  802707:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  80270e:	00 00 00 
  802711:	ff d0                	callq  *%rax
  802713:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802716:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80271a:	79 1d                	jns    802739 <open+0xc5>
	{
		fd_close(fd,0);
  80271c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802720:	be 00 00 00 00       	mov    $0x0,%esi
  802725:	48 89 c7             	mov    %rax,%rdi
  802728:	48 b8 fc 1d 80 00 00 	movabs $0x801dfc,%rax
  80272f:	00 00 00 
  802732:	ff d0                	callq  *%rax
		return ret;
  802734:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802737:	eb 13                	jmp    80274c <open+0xd8>
	}
	return fd2num (fd);
  802739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273d:	48 89 c7             	mov    %rax,%rdi
  802740:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  802747:	00 00 00 
  80274a:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  80274c:	c9                   	leaveq 
  80274d:	c3                   	retq   

000000000080274e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80274e:	55                   	push   %rbp
  80274f:	48 89 e5             	mov    %rsp,%rbp
  802752:	48 83 ec 10          	sub    $0x10,%rsp
  802756:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80275a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80275e:	8b 50 0c             	mov    0xc(%rax),%edx
  802761:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802768:	00 00 00 
  80276b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80276d:	be 00 00 00 00       	mov    $0x0,%esi
  802772:	bf 06 00 00 00       	mov    $0x6,%edi
  802777:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  80277e:	00 00 00 
  802781:	ff d0                	callq  *%rax
}
  802783:	c9                   	leaveq 
  802784:	c3                   	retq   

0000000000802785 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802785:	55                   	push   %rbp
  802786:	48 89 e5             	mov    %rsp,%rbp
  802789:	48 83 ec 30          	sub    $0x30,%rsp
  80278d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802791:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802795:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  802799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279d:	8b 50 0c             	mov    0xc(%rax),%edx
  8027a0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027a7:	00 00 00 
  8027aa:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  8027ac:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027b3:	00 00 00 
  8027b6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027ba:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  8027be:	be 00 00 00 00       	mov    $0x0,%esi
  8027c3:	bf 03 00 00 00       	mov    $0x3,%edi
  8027c8:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  8027cf:	00 00 00 
  8027d2:	ff d0                	callq  *%rax
  8027d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027db:	79 05                	jns    8027e2 <devfile_read+0x5d>
		return ret;
  8027dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e0:	eb 26                	jmp    802808 <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  8027e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e5:	48 63 d0             	movslq %eax,%rdx
  8027e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ec:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8027f3:	00 00 00 
  8027f6:	48 89 c7             	mov    %rax,%rdi
  8027f9:	48 b8 e0 12 80 00 00 	movabs $0x8012e0,%rax
  802800:	00 00 00 
  802803:	ff d0                	callq  *%rax
	return ret;
  802805:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  802808:	c9                   	leaveq 
  802809:	c3                   	retq   

000000000080280a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80280a:	55                   	push   %rbp
  80280b:	48 89 e5             	mov    %rsp,%rbp
  80280e:	48 83 ec 30          	sub    $0x30,%rsp
  802812:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802816:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80281a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  80281e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802822:	8b 50 0c             	mov    0xc(%rax),%edx
  802825:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80282c:	00 00 00 
  80282f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  802831:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  802836:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80283d:	00 
  80283e:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802843:	48 89 c2             	mov    %rax,%rdx
  802846:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80284d:	00 00 00 
  802850:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  802854:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80285b:	00 00 00 
  80285e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802862:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802866:	48 89 c6             	mov    %rax,%rsi
  802869:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802870:	00 00 00 
  802873:	48 b8 e0 12 80 00 00 	movabs $0x8012e0,%rax
  80287a:	00 00 00 
  80287d:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  80287f:	be 00 00 00 00       	mov    $0x0,%esi
  802884:	bf 04 00 00 00       	mov    $0x4,%edi
  802889:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  802890:	00 00 00 
  802893:	ff d0                	callq  *%rax
  802895:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802898:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80289c:	79 05                	jns    8028a3 <devfile_write+0x99>
		return ret;
  80289e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a1:	eb 03                	jmp    8028a6 <devfile_write+0x9c>
	
	return ret;
  8028a3:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  8028a6:	c9                   	leaveq 
  8028a7:	c3                   	retq   

00000000008028a8 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8028a8:	55                   	push   %rbp
  8028a9:	48 89 e5             	mov    %rsp,%rbp
  8028ac:	48 83 ec 20          	sub    $0x20,%rsp
  8028b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8028b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028bc:	8b 50 0c             	mov    0xc(%rax),%edx
  8028bf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028c6:	00 00 00 
  8028c9:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8028cb:	be 00 00 00 00       	mov    $0x0,%esi
  8028d0:	bf 05 00 00 00       	mov    $0x5,%edi
  8028d5:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  8028dc:	00 00 00 
  8028df:	ff d0                	callq  *%rax
  8028e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e8:	79 05                	jns    8028ef <devfile_stat+0x47>
		return r;
  8028ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ed:	eb 56                	jmp    802945 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8028ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028f3:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028fa:	00 00 00 
  8028fd:	48 89 c7             	mov    %rax,%rdi
  802900:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  802907:	00 00 00 
  80290a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80290c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802913:	00 00 00 
  802916:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80291c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802920:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802926:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80292d:	00 00 00 
  802930:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802936:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80293a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802940:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802945:	c9                   	leaveq 
  802946:	c3                   	retq   

0000000000802947 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802947:	55                   	push   %rbp
  802948:	48 89 e5             	mov    %rsp,%rbp
  80294b:	48 83 ec 10          	sub    $0x10,%rsp
  80294f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802953:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802956:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80295a:	8b 50 0c             	mov    0xc(%rax),%edx
  80295d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802964:	00 00 00 
  802967:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802969:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802970:	00 00 00 
  802973:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802976:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802979:	be 00 00 00 00       	mov    $0x0,%esi
  80297e:	bf 02 00 00 00       	mov    $0x2,%edi
  802983:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  80298a:	00 00 00 
  80298d:	ff d0                	callq  *%rax
}
  80298f:	c9                   	leaveq 
  802990:	c3                   	retq   

0000000000802991 <remove>:

// Delete a file
int
remove(const char *path)
{
  802991:	55                   	push   %rbp
  802992:	48 89 e5             	mov    %rsp,%rbp
  802995:	48 83 ec 10          	sub    $0x10,%rsp
  802999:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80299d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029a1:	48 89 c7             	mov    %rax,%rdi
  8029a4:	48 b8 50 0f 80 00 00 	movabs $0x800f50,%rax
  8029ab:	00 00 00 
  8029ae:	ff d0                	callq  *%rax
  8029b0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029b5:	7e 07                	jle    8029be <remove+0x2d>
		return -E_BAD_PATH;
  8029b7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029bc:	eb 33                	jmp    8029f1 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8029be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029c2:	48 89 c6             	mov    %rax,%rsi
  8029c5:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8029cc:	00 00 00 
  8029cf:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  8029d6:	00 00 00 
  8029d9:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8029db:	be 00 00 00 00       	mov    $0x0,%esi
  8029e0:	bf 07 00 00 00       	mov    $0x7,%edi
  8029e5:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  8029ec:	00 00 00 
  8029ef:	ff d0                	callq  *%rax
}
  8029f1:	c9                   	leaveq 
  8029f2:	c3                   	retq   

00000000008029f3 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8029f3:	55                   	push   %rbp
  8029f4:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8029f7:	be 00 00 00 00       	mov    $0x0,%esi
  8029fc:	bf 08 00 00 00       	mov    $0x8,%edi
  802a01:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  802a08:	00 00 00 
  802a0b:	ff d0                	callq  *%rax
}
  802a0d:	5d                   	pop    %rbp
  802a0e:	c3                   	retq   

0000000000802a0f <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802a0f:	55                   	push   %rbp
  802a10:	48 89 e5             	mov    %rsp,%rbp
  802a13:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802a1a:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802a21:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802a28:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802a2f:	be 00 00 00 00       	mov    $0x0,%esi
  802a34:	48 89 c7             	mov    %rax,%rdi
  802a37:	48 b8 74 26 80 00 00 	movabs $0x802674,%rax
  802a3e:	00 00 00 
  802a41:	ff d0                	callq  *%rax
  802a43:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802a46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4a:	79 28                	jns    802a74 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802a4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4f:	89 c6                	mov    %eax,%esi
  802a51:	48 bf d6 48 80 00 00 	movabs $0x8048d6,%rdi
  802a58:	00 00 00 
  802a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a60:	48 ba c6 03 80 00 00 	movabs $0x8003c6,%rdx
  802a67:	00 00 00 
  802a6a:	ff d2                	callq  *%rdx
		return fd_src;
  802a6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6f:	e9 74 01 00 00       	jmpq   802be8 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802a74:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802a7b:	be 01 01 00 00       	mov    $0x101,%esi
  802a80:	48 89 c7             	mov    %rax,%rdi
  802a83:	48 b8 74 26 80 00 00 	movabs $0x802674,%rax
  802a8a:	00 00 00 
  802a8d:	ff d0                	callq  *%rax
  802a8f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802a92:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a96:	79 39                	jns    802ad1 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802a98:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a9b:	89 c6                	mov    %eax,%esi
  802a9d:	48 bf ec 48 80 00 00 	movabs $0x8048ec,%rdi
  802aa4:	00 00 00 
  802aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  802aac:	48 ba c6 03 80 00 00 	movabs $0x8003c6,%rdx
  802ab3:	00 00 00 
  802ab6:	ff d2                	callq  *%rdx
		close(fd_src);
  802ab8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802abb:	89 c7                	mov    %eax,%edi
  802abd:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802ac4:	00 00 00 
  802ac7:	ff d0                	callq  *%rax
		return fd_dest;
  802ac9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802acc:	e9 17 01 00 00       	jmpq   802be8 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ad1:	eb 74                	jmp    802b47 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802ad3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ad6:	48 63 d0             	movslq %eax,%rdx
  802ad9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ae0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ae3:	48 89 ce             	mov    %rcx,%rsi
  802ae6:	89 c7                	mov    %eax,%edi
  802ae8:	48 b8 e8 22 80 00 00 	movabs $0x8022e8,%rax
  802aef:	00 00 00 
  802af2:	ff d0                	callq  *%rax
  802af4:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802af7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802afb:	79 4a                	jns    802b47 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802afd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b00:	89 c6                	mov    %eax,%esi
  802b02:	48 bf 06 49 80 00 00 	movabs $0x804906,%rdi
  802b09:	00 00 00 
  802b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b11:	48 ba c6 03 80 00 00 	movabs $0x8003c6,%rdx
  802b18:	00 00 00 
  802b1b:	ff d2                	callq  *%rdx
			close(fd_src);
  802b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b20:	89 c7                	mov    %eax,%edi
  802b22:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802b29:	00 00 00 
  802b2c:	ff d0                	callq  *%rax
			close(fd_dest);
  802b2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b31:	89 c7                	mov    %eax,%edi
  802b33:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802b3a:	00 00 00 
  802b3d:	ff d0                	callq  *%rax
			return write_size;
  802b3f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b42:	e9 a1 00 00 00       	jmpq   802be8 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b47:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b51:	ba 00 02 00 00       	mov    $0x200,%edx
  802b56:	48 89 ce             	mov    %rcx,%rsi
  802b59:	89 c7                	mov    %eax,%edi
  802b5b:	48 b8 9e 21 80 00 00 	movabs $0x80219e,%rax
  802b62:	00 00 00 
  802b65:	ff d0                	callq  *%rax
  802b67:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b6e:	0f 8f 5f ff ff ff    	jg     802ad3 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802b74:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b78:	79 47                	jns    802bc1 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802b7a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b7d:	89 c6                	mov    %eax,%esi
  802b7f:	48 bf 19 49 80 00 00 	movabs $0x804919,%rdi
  802b86:	00 00 00 
  802b89:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8e:	48 ba c6 03 80 00 00 	movabs $0x8003c6,%rdx
  802b95:	00 00 00 
  802b98:	ff d2                	callq  *%rdx
		close(fd_src);
  802b9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9d:	89 c7                	mov    %eax,%edi
  802b9f:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802ba6:	00 00 00 
  802ba9:	ff d0                	callq  *%rax
		close(fd_dest);
  802bab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bae:	89 c7                	mov    %eax,%edi
  802bb0:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802bb7:	00 00 00 
  802bba:	ff d0                	callq  *%rax
		return read_size;
  802bbc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bbf:	eb 27                	jmp    802be8 <copy+0x1d9>
	}
	close(fd_src);
  802bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc4:	89 c7                	mov    %eax,%edi
  802bc6:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802bcd:	00 00 00 
  802bd0:	ff d0                	callq  *%rax
	close(fd_dest);
  802bd2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bd5:	89 c7                	mov    %eax,%edi
  802bd7:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802bde:	00 00 00 
  802be1:	ff d0                	callq  *%rax
	return 0;
  802be3:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802be8:	c9                   	leaveq 
  802be9:	c3                   	retq   

0000000000802bea <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802bea:	55                   	push   %rbp
  802beb:	48 89 e5             	mov    %rsp,%rbp
  802bee:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802bf5:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802bfc:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802c03:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802c0a:	be 00 00 00 00       	mov    $0x0,%esi
  802c0f:	48 89 c7             	mov    %rax,%rdi
  802c12:	48 b8 74 26 80 00 00 	movabs $0x802674,%rax
  802c19:	00 00 00 
  802c1c:	ff d0                	callq  *%rax
  802c1e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802c21:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802c25:	79 08                	jns    802c2f <spawn+0x45>
		return r;
  802c27:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c2a:	e9 0c 03 00 00       	jmpq   802f3b <spawn+0x351>
	fd = r;
  802c2f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c32:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802c35:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802c3c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802c40:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802c47:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c4a:	ba 00 02 00 00       	mov    $0x200,%edx
  802c4f:	48 89 ce             	mov    %rcx,%rsi
  802c52:	89 c7                	mov    %eax,%edi
  802c54:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  802c5b:	00 00 00 
  802c5e:	ff d0                	callq  *%rax
  802c60:	3d 00 02 00 00       	cmp    $0x200,%eax
  802c65:	75 0d                	jne    802c74 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802c67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c6b:	8b 00                	mov    (%rax),%eax
  802c6d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802c72:	74 43                	je     802cb7 <spawn+0xcd>
		close(fd);
  802c74:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c77:	89 c7                	mov    %eax,%edi
  802c79:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802c80:	00 00 00 
  802c83:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802c85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c89:	8b 00                	mov    (%rax),%eax
  802c8b:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802c90:	89 c6                	mov    %eax,%esi
  802c92:	48 bf 30 49 80 00 00 	movabs $0x804930,%rdi
  802c99:	00 00 00 
  802c9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca1:	48 b9 c6 03 80 00 00 	movabs $0x8003c6,%rcx
  802ca8:	00 00 00 
  802cab:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802cad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802cb2:	e9 84 02 00 00       	jmpq   802f3b <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802cb7:	b8 07 00 00 00       	mov    $0x7,%eax
  802cbc:	cd 30                	int    $0x30
  802cbe:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802cc1:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802cc4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802cc7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ccb:	79 08                	jns    802cd5 <spawn+0xeb>
		return r;
  802ccd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cd0:	e9 66 02 00 00       	jmpq   802f3b <spawn+0x351>
	child = r;
  802cd5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cd8:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802cdb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802cde:	25 ff 03 00 00       	and    $0x3ff,%eax
  802ce3:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802cea:	00 00 00 
  802ced:	48 98                	cltq   
  802cef:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  802cf6:	48 01 d0             	add    %rdx,%rax
  802cf9:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802d00:	48 89 c6             	mov    %rax,%rsi
  802d03:	b8 18 00 00 00       	mov    $0x18,%eax
  802d08:	48 89 d7             	mov    %rdx,%rdi
  802d0b:	48 89 c1             	mov    %rax,%rcx
  802d0e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802d11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d15:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d19:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802d20:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802d27:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802d2e:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802d35:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d38:	48 89 ce             	mov    %rcx,%rsi
  802d3b:	89 c7                	mov    %eax,%edi
  802d3d:	48 b8 a5 31 80 00 00 	movabs $0x8031a5,%rax
  802d44:	00 00 00 
  802d47:	ff d0                	callq  *%rax
  802d49:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d4c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d50:	79 08                	jns    802d5a <spawn+0x170>
		return r;
  802d52:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d55:	e9 e1 01 00 00       	jmpq   802f3b <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802d5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d5e:	48 8b 40 20          	mov    0x20(%rax),%rax
  802d62:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802d69:	48 01 d0             	add    %rdx,%rax
  802d6c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d77:	e9 a3 00 00 00       	jmpq   802e1f <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  802d7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d80:	8b 00                	mov    (%rax),%eax
  802d82:	83 f8 01             	cmp    $0x1,%eax
  802d85:	74 05                	je     802d8c <spawn+0x1a2>
			continue;
  802d87:	e9 8a 00 00 00       	jmpq   802e16 <spawn+0x22c>
		perm = PTE_P | PTE_U;
  802d8c:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802d93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d97:	8b 40 04             	mov    0x4(%rax),%eax
  802d9a:	83 e0 02             	and    $0x2,%eax
  802d9d:	85 c0                	test   %eax,%eax
  802d9f:	74 04                	je     802da5 <spawn+0x1bb>
			perm |= PTE_W;
  802da1:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802da5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da9:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802dad:	41 89 c1             	mov    %eax,%r9d
  802db0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db4:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802db8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbc:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802dc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc4:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802dc8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802dcb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802dce:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802dd1:	89 3c 24             	mov    %edi,(%rsp)
  802dd4:	89 c7                	mov    %eax,%edi
  802dd6:	48 b8 4e 34 80 00 00 	movabs $0x80344e,%rax
  802ddd:	00 00 00 
  802de0:	ff d0                	callq  *%rax
  802de2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802de5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802de9:	79 2b                	jns    802e16 <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802deb:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802dec:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802def:	89 c7                	mov    %eax,%edi
  802df1:	48 b8 2b 18 80 00 00 	movabs $0x80182b,%rax
  802df8:	00 00 00 
  802dfb:	ff d0                	callq  *%rax
	close(fd);
  802dfd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e00:	89 c7                	mov    %eax,%edi
  802e02:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802e09:	00 00 00 
  802e0c:	ff d0                	callq  *%rax
	return r;
  802e0e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e11:	e9 25 01 00 00       	jmpq   802f3b <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e16:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802e1a:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802e1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e23:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802e27:	0f b7 c0             	movzwl %ax,%eax
  802e2a:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802e2d:	0f 8f 49 ff ff ff    	jg     802d7c <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802e33:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e36:	89 c7                	mov    %eax,%edi
  802e38:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802e3f:	00 00 00 
  802e42:	ff d0                	callq  *%rax
	fd = -1;
  802e44:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802e4b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e4e:	89 c7                	mov    %eax,%edi
  802e50:	48 b8 3a 36 80 00 00 	movabs $0x80363a,%rax
  802e57:	00 00 00 
  802e5a:	ff d0                	callq  *%rax
  802e5c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e63:	79 30                	jns    802e95 <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  802e65:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e68:	89 c1                	mov    %eax,%ecx
  802e6a:	48 ba 4a 49 80 00 00 	movabs $0x80494a,%rdx
  802e71:	00 00 00 
  802e74:	be 82 00 00 00       	mov    $0x82,%esi
  802e79:	48 bf 60 49 80 00 00 	movabs $0x804960,%rdi
  802e80:	00 00 00 
  802e83:	b8 00 00 00 00       	mov    $0x0,%eax
  802e88:	49 b8 8d 01 80 00 00 	movabs $0x80018d,%r8
  802e8f:	00 00 00 
  802e92:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802e95:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802e9c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e9f:	48 89 d6             	mov    %rdx,%rsi
  802ea2:	89 c7                	mov    %eax,%edi
  802ea4:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  802eab:	00 00 00 
  802eae:	ff d0                	callq  *%rax
  802eb0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802eb3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802eb7:	79 30                	jns    802ee9 <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  802eb9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ebc:	89 c1                	mov    %eax,%ecx
  802ebe:	48 ba 6c 49 80 00 00 	movabs $0x80496c,%rdx
  802ec5:	00 00 00 
  802ec8:	be 85 00 00 00       	mov    $0x85,%esi
  802ecd:	48 bf 60 49 80 00 00 	movabs $0x804960,%rdi
  802ed4:	00 00 00 
  802ed7:	b8 00 00 00 00       	mov    $0x0,%eax
  802edc:	49 b8 8d 01 80 00 00 	movabs $0x80018d,%r8
  802ee3:	00 00 00 
  802ee6:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802ee9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802eec:	be 02 00 00 00       	mov    $0x2,%esi
  802ef1:	89 c7                	mov    %eax,%edi
  802ef3:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  802efa:	00 00 00 
  802efd:	ff d0                	callq  *%rax
  802eff:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f02:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f06:	79 30                	jns    802f38 <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  802f08:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f0b:	89 c1                	mov    %eax,%ecx
  802f0d:	48 ba 86 49 80 00 00 	movabs $0x804986,%rdx
  802f14:	00 00 00 
  802f17:	be 88 00 00 00       	mov    $0x88,%esi
  802f1c:	48 bf 60 49 80 00 00 	movabs $0x804960,%rdi
  802f23:	00 00 00 
  802f26:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2b:	49 b8 8d 01 80 00 00 	movabs $0x80018d,%r8
  802f32:	00 00 00 
  802f35:	41 ff d0             	callq  *%r8

	return child;
  802f38:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802f3b:	c9                   	leaveq 
  802f3c:	c3                   	retq   

0000000000802f3d <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802f3d:	55                   	push   %rbp
  802f3e:	48 89 e5             	mov    %rsp,%rbp
  802f41:	41 55                	push   %r13
  802f43:	41 54                	push   %r12
  802f45:	53                   	push   %rbx
  802f46:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802f4d:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  802f54:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  802f5b:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  802f62:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  802f69:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  802f70:	84 c0                	test   %al,%al
  802f72:	74 26                	je     802f9a <spawnl+0x5d>
  802f74:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  802f7b:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  802f82:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  802f86:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  802f8a:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  802f8e:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  802f92:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  802f96:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  802f9a:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802fa1:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  802fa8:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802fab:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802fb2:	00 00 00 
  802fb5:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802fbc:	00 00 00 
  802fbf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fc3:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802fca:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802fd1:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  802fd8:	eb 07                	jmp    802fe1 <spawnl+0xa4>
		argc++;
  802fda:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802fe1:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802fe7:	83 f8 30             	cmp    $0x30,%eax
  802fea:	73 23                	jae    80300f <spawnl+0xd2>
  802fec:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  802ff3:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802ff9:	89 c0                	mov    %eax,%eax
  802ffb:	48 01 d0             	add    %rdx,%rax
  802ffe:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803004:	83 c2 08             	add    $0x8,%edx
  803007:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  80300d:	eb 15                	jmp    803024 <spawnl+0xe7>
  80300f:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803016:	48 89 d0             	mov    %rdx,%rax
  803019:	48 83 c2 08          	add    $0x8,%rdx
  80301d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803024:	48 8b 00             	mov    (%rax),%rax
  803027:	48 85 c0             	test   %rax,%rax
  80302a:	75 ae                	jne    802fda <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  80302c:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803032:	83 c0 02             	add    $0x2,%eax
  803035:	48 89 e2             	mov    %rsp,%rdx
  803038:	48 89 d3             	mov    %rdx,%rbx
  80303b:	48 63 d0             	movslq %eax,%rdx
  80303e:	48 83 ea 01          	sub    $0x1,%rdx
  803042:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803049:	48 63 d0             	movslq %eax,%rdx
  80304c:	49 89 d4             	mov    %rdx,%r12
  80304f:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803055:	48 63 d0             	movslq %eax,%rdx
  803058:	49 89 d2             	mov    %rdx,%r10
  80305b:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803061:	48 98                	cltq   
  803063:	48 c1 e0 03          	shl    $0x3,%rax
  803067:	48 8d 50 07          	lea    0x7(%rax),%rdx
  80306b:	b8 10 00 00 00       	mov    $0x10,%eax
  803070:	48 83 e8 01          	sub    $0x1,%rax
  803074:	48 01 d0             	add    %rdx,%rax
  803077:	bf 10 00 00 00       	mov    $0x10,%edi
  80307c:	ba 00 00 00 00       	mov    $0x0,%edx
  803081:	48 f7 f7             	div    %rdi
  803084:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803088:	48 29 c4             	sub    %rax,%rsp
  80308b:	48 89 e0             	mov    %rsp,%rax
  80308e:	48 83 c0 07          	add    $0x7,%rax
  803092:	48 c1 e8 03          	shr    $0x3,%rax
  803096:	48 c1 e0 03          	shl    $0x3,%rax
  80309a:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8030a1:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8030a8:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  8030af:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  8030b2:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8030b8:	8d 50 01             	lea    0x1(%rax),%edx
  8030bb:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8030c2:	48 63 d2             	movslq %edx,%rdx
  8030c5:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  8030cc:	00 

	va_start(vl, arg0);
  8030cd:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8030d4:	00 00 00 
  8030d7:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8030de:	00 00 00 
  8030e1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030e5:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8030ec:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8030f3:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8030fa:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803101:	00 00 00 
  803104:	eb 63                	jmp    803169 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803106:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  80310c:	8d 70 01             	lea    0x1(%rax),%esi
  80310f:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803115:	83 f8 30             	cmp    $0x30,%eax
  803118:	73 23                	jae    80313d <spawnl+0x200>
  80311a:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803121:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803127:	89 c0                	mov    %eax,%eax
  803129:	48 01 d0             	add    %rdx,%rax
  80312c:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803132:	83 c2 08             	add    $0x8,%edx
  803135:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  80313b:	eb 15                	jmp    803152 <spawnl+0x215>
  80313d:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803144:	48 89 d0             	mov    %rdx,%rax
  803147:	48 83 c2 08          	add    $0x8,%rdx
  80314b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803152:	48 8b 08             	mov    (%rax),%rcx
  803155:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80315c:	89 f2                	mov    %esi,%edx
  80315e:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803162:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803169:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80316f:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803175:	77 8f                	ja     803106 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803177:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80317e:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803185:	48 89 d6             	mov    %rdx,%rsi
  803188:	48 89 c7             	mov    %rax,%rdi
  80318b:	48 b8 ea 2b 80 00 00 	movabs $0x802bea,%rax
  803192:	00 00 00 
  803195:	ff d0                	callq  *%rax
  803197:	48 89 dc             	mov    %rbx,%rsp
}
  80319a:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  80319e:	5b                   	pop    %rbx
  80319f:	41 5c                	pop    %r12
  8031a1:	41 5d                	pop    %r13
  8031a3:	5d                   	pop    %rbp
  8031a4:	c3                   	retq   

00000000008031a5 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8031a5:	55                   	push   %rbp
  8031a6:	48 89 e5             	mov    %rsp,%rbp
  8031a9:	48 83 ec 50          	sub    $0x50,%rsp
  8031ad:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8031b0:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8031b4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8031b8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8031bf:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  8031c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8031c7:	eb 33                	jmp    8031fc <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  8031c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031cc:	48 98                	cltq   
  8031ce:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8031d5:	00 
  8031d6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8031da:	48 01 d0             	add    %rdx,%rax
  8031dd:	48 8b 00             	mov    (%rax),%rax
  8031e0:	48 89 c7             	mov    %rax,%rdi
  8031e3:	48 b8 50 0f 80 00 00 	movabs $0x800f50,%rax
  8031ea:	00 00 00 
  8031ed:	ff d0                	callq  *%rax
  8031ef:	83 c0 01             	add    $0x1,%eax
  8031f2:	48 98                	cltq   
  8031f4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8031f8:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8031fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031ff:	48 98                	cltq   
  803201:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803208:	00 
  803209:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80320d:	48 01 d0             	add    %rdx,%rax
  803210:	48 8b 00             	mov    (%rax),%rax
  803213:	48 85 c0             	test   %rax,%rax
  803216:	75 b1                	jne    8031c9 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803218:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80321c:	48 f7 d8             	neg    %rax
  80321f:	48 05 00 10 40 00    	add    $0x401000,%rax
  803225:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803229:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80322d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803231:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803235:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803239:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80323c:	83 c2 01             	add    $0x1,%edx
  80323f:	c1 e2 03             	shl    $0x3,%edx
  803242:	48 63 d2             	movslq %edx,%rdx
  803245:	48 f7 da             	neg    %rdx
  803248:	48 01 d0             	add    %rdx,%rax
  80324b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80324f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803253:	48 83 e8 10          	sub    $0x10,%rax
  803257:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80325d:	77 0a                	ja     803269 <init_stack+0xc4>
		return -E_NO_MEM;
  80325f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803264:	e9 e3 01 00 00       	jmpq   80344c <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803269:	ba 07 00 00 00       	mov    $0x7,%edx
  80326e:	be 00 00 40 00       	mov    $0x400000,%esi
  803273:	bf 00 00 00 00       	mov    $0x0,%edi
  803278:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  80327f:	00 00 00 
  803282:	ff d0                	callq  *%rax
  803284:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803287:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80328b:	79 08                	jns    803295 <init_stack+0xf0>
		return r;
  80328d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803290:	e9 b7 01 00 00       	jmpq   80344c <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803295:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80329c:	e9 8a 00 00 00       	jmpq   80332b <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  8032a1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032a4:	48 98                	cltq   
  8032a6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032ad:	00 
  8032ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032b2:	48 01 c2             	add    %rax,%rdx
  8032b5:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8032ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032be:	48 01 c8             	add    %rcx,%rax
  8032c1:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8032c7:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  8032ca:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032cd:	48 98                	cltq   
  8032cf:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032d6:	00 
  8032d7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032db:	48 01 d0             	add    %rdx,%rax
  8032de:	48 8b 10             	mov    (%rax),%rdx
  8032e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e5:	48 89 d6             	mov    %rdx,%rsi
  8032e8:	48 89 c7             	mov    %rax,%rdi
  8032eb:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  8032f2:	00 00 00 
  8032f5:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8032f7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032fa:	48 98                	cltq   
  8032fc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803303:	00 
  803304:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803308:	48 01 d0             	add    %rdx,%rax
  80330b:	48 8b 00             	mov    (%rax),%rax
  80330e:	48 89 c7             	mov    %rax,%rdi
  803311:	48 b8 50 0f 80 00 00 	movabs $0x800f50,%rax
  803318:	00 00 00 
  80331b:	ff d0                	callq  *%rax
  80331d:	48 98                	cltq   
  80331f:	48 83 c0 01          	add    $0x1,%rax
  803323:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803327:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  80332b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80332e:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803331:	0f 8c 6a ff ff ff    	jl     8032a1 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803337:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80333a:	48 98                	cltq   
  80333c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803343:	00 
  803344:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803348:	48 01 d0             	add    %rdx,%rax
  80334b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803352:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803359:	00 
  80335a:	74 35                	je     803391 <init_stack+0x1ec>
  80335c:	48 b9 a0 49 80 00 00 	movabs $0x8049a0,%rcx
  803363:	00 00 00 
  803366:	48 ba c6 49 80 00 00 	movabs $0x8049c6,%rdx
  80336d:	00 00 00 
  803370:	be f1 00 00 00       	mov    $0xf1,%esi
  803375:	48 bf 60 49 80 00 00 	movabs $0x804960,%rdi
  80337c:	00 00 00 
  80337f:	b8 00 00 00 00       	mov    $0x0,%eax
  803384:	49 b8 8d 01 80 00 00 	movabs $0x80018d,%r8
  80338b:	00 00 00 
  80338e:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803391:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803395:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803399:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80339e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033a2:	48 01 c8             	add    %rcx,%rax
  8033a5:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8033ab:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  8033ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033b2:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8033b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033b9:	48 98                	cltq   
  8033bb:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8033be:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8033c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033c7:	48 01 d0             	add    %rdx,%rax
  8033ca:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8033d0:	48 89 c2             	mov    %rax,%rdx
  8033d3:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8033d7:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8033da:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8033dd:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8033e3:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8033e8:	89 c2                	mov    %eax,%edx
  8033ea:	be 00 00 40 00       	mov    $0x400000,%esi
  8033ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8033f4:	48 b8 3b 19 80 00 00 	movabs $0x80193b,%rax
  8033fb:	00 00 00 
  8033fe:	ff d0                	callq  *%rax
  803400:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803403:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803407:	79 02                	jns    80340b <init_stack+0x266>
		goto error;
  803409:	eb 28                	jmp    803433 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80340b:	be 00 00 40 00       	mov    $0x400000,%esi
  803410:	bf 00 00 00 00       	mov    $0x0,%edi
  803415:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  80341c:	00 00 00 
  80341f:	ff d0                	callq  *%rax
  803421:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803424:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803428:	79 02                	jns    80342c <init_stack+0x287>
		goto error;
  80342a:	eb 07                	jmp    803433 <init_stack+0x28e>

	return 0;
  80342c:	b8 00 00 00 00       	mov    $0x0,%eax
  803431:	eb 19                	jmp    80344c <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803433:	be 00 00 40 00       	mov    $0x400000,%esi
  803438:	bf 00 00 00 00       	mov    $0x0,%edi
  80343d:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  803444:	00 00 00 
  803447:	ff d0                	callq  *%rax
	return r;
  803449:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80344c:	c9                   	leaveq 
  80344d:	c3                   	retq   

000000000080344e <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  80344e:	55                   	push   %rbp
  80344f:	48 89 e5             	mov    %rsp,%rbp
  803452:	48 83 ec 50          	sub    $0x50,%rsp
  803456:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803459:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80345d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803461:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803464:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803468:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80346c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803470:	25 ff 0f 00 00       	and    $0xfff,%eax
  803475:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803478:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80347c:	74 21                	je     80349f <map_segment+0x51>
		va -= i;
  80347e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803481:	48 98                	cltq   
  803483:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803487:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348a:	48 98                	cltq   
  80348c:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803490:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803493:	48 98                	cltq   
  803495:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803499:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349c:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80349f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034a6:	e9 79 01 00 00       	jmpq   803624 <map_segment+0x1d6>
		if (i >= filesz) {
  8034ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ae:	48 98                	cltq   
  8034b0:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8034b4:	72 3c                	jb     8034f2 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8034b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b9:	48 63 d0             	movslq %eax,%rdx
  8034bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034c0:	48 01 d0             	add    %rdx,%rax
  8034c3:	48 89 c1             	mov    %rax,%rcx
  8034c6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034c9:	8b 55 10             	mov    0x10(%rbp),%edx
  8034cc:	48 89 ce             	mov    %rcx,%rsi
  8034cf:	89 c7                	mov    %eax,%edi
  8034d1:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  8034d8:	00 00 00 
  8034db:	ff d0                	callq  *%rax
  8034dd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8034e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034e4:	0f 89 33 01 00 00    	jns    80361d <map_segment+0x1cf>
				return r;
  8034ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034ed:	e9 46 01 00 00       	jmpq   803638 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8034f2:	ba 07 00 00 00       	mov    $0x7,%edx
  8034f7:	be 00 00 40 00       	mov    $0x400000,%esi
  8034fc:	bf 00 00 00 00       	mov    $0x0,%edi
  803501:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  803508:	00 00 00 
  80350b:	ff d0                	callq  *%rax
  80350d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803510:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803514:	79 08                	jns    80351e <map_segment+0xd0>
				return r;
  803516:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803519:	e9 1a 01 00 00       	jmpq   803638 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80351e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803521:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803524:	01 c2                	add    %eax,%edx
  803526:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803529:	89 d6                	mov    %edx,%esi
  80352b:	89 c7                	mov    %eax,%edi
  80352d:	48 b8 bc 23 80 00 00 	movabs $0x8023bc,%rax
  803534:	00 00 00 
  803537:	ff d0                	callq  *%rax
  803539:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80353c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803540:	79 08                	jns    80354a <map_segment+0xfc>
				return r;
  803542:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803545:	e9 ee 00 00 00       	jmpq   803638 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80354a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803551:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803554:	48 98                	cltq   
  803556:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80355a:	48 29 c2             	sub    %rax,%rdx
  80355d:	48 89 d0             	mov    %rdx,%rax
  803560:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803564:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803567:	48 63 d0             	movslq %eax,%rdx
  80356a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80356e:	48 39 c2             	cmp    %rax,%rdx
  803571:	48 0f 47 d0          	cmova  %rax,%rdx
  803575:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803578:	be 00 00 40 00       	mov    $0x400000,%esi
  80357d:	89 c7                	mov    %eax,%edi
  80357f:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  803586:	00 00 00 
  803589:	ff d0                	callq  *%rax
  80358b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80358e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803592:	79 08                	jns    80359c <map_segment+0x14e>
				return r;
  803594:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803597:	e9 9c 00 00 00       	jmpq   803638 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80359c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359f:	48 63 d0             	movslq %eax,%rdx
  8035a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035a6:	48 01 d0             	add    %rdx,%rax
  8035a9:	48 89 c2             	mov    %rax,%rdx
  8035ac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035af:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8035b3:	48 89 d1             	mov    %rdx,%rcx
  8035b6:	89 c2                	mov    %eax,%edx
  8035b8:	be 00 00 40 00       	mov    $0x400000,%esi
  8035bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c2:	48 b8 3b 19 80 00 00 	movabs $0x80193b,%rax
  8035c9:	00 00 00 
  8035cc:	ff d0                	callq  *%rax
  8035ce:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8035d1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035d5:	79 30                	jns    803607 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8035d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035da:	89 c1                	mov    %eax,%ecx
  8035dc:	48 ba db 49 80 00 00 	movabs $0x8049db,%rdx
  8035e3:	00 00 00 
  8035e6:	be 24 01 00 00       	mov    $0x124,%esi
  8035eb:	48 bf 60 49 80 00 00 	movabs $0x804960,%rdi
  8035f2:	00 00 00 
  8035f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035fa:	49 b8 8d 01 80 00 00 	movabs $0x80018d,%r8
  803601:	00 00 00 
  803604:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803607:	be 00 00 40 00       	mov    $0x400000,%esi
  80360c:	bf 00 00 00 00       	mov    $0x0,%edi
  803611:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  803618:	00 00 00 
  80361b:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80361d:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803624:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803627:	48 98                	cltq   
  803629:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80362d:	0f 82 78 fe ff ff    	jb     8034ab <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803633:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803638:	c9                   	leaveq 
  803639:	c3                   	retq   

000000000080363a <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  80363a:	55                   	push   %rbp
  80363b:	48 89 e5             	mov    %rsp,%rbp
  80363e:	48 83 ec 20          	sub    $0x20,%rsp
  803642:	89 7d ec             	mov    %edi,-0x14(%rbp)
	// LAB 5: Your code here.
	uint64_t  i;
	for (i=UTEXT;i<USTACKTOP;i+=PGSIZE)
  803645:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  80364c:	00 
  80364d:	e9 23 01 00 00       	jmpq   803775 <copy_shared_pages+0x13b>
	{
		if ((uvpml4e[VPML4E(i)]) && (uvpde[VPDPE(i)]) && (uvpd[VPD(i)]) && (uvpt[VPN(i)]))
  803652:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803656:	48 c1 e8 27          	shr    $0x27,%rax
  80365a:	48 89 c2             	mov    %rax,%rdx
  80365d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803664:	01 00 00 
  803667:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80366b:	48 85 c0             	test   %rax,%rax
  80366e:	0f 84 f9 00 00 00    	je     80376d <copy_shared_pages+0x133>
  803674:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803678:	48 c1 e8 1e          	shr    $0x1e,%rax
  80367c:	48 89 c2             	mov    %rax,%rdx
  80367f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803686:	01 00 00 
  803689:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80368d:	48 85 c0             	test   %rax,%rax
  803690:	0f 84 d7 00 00 00    	je     80376d <copy_shared_pages+0x133>
  803696:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80369a:	48 c1 e8 15          	shr    $0x15,%rax
  80369e:	48 89 c2             	mov    %rax,%rdx
  8036a1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8036a8:	01 00 00 
  8036ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036af:	48 85 c0             	test   %rax,%rax
  8036b2:	0f 84 b5 00 00 00    	je     80376d <copy_shared_pages+0x133>
  8036b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036bc:	48 c1 e8 0c          	shr    $0xc,%rax
  8036c0:	48 89 c2             	mov    %rax,%rdx
  8036c3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036ca:	01 00 00 
  8036cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036d1:	48 85 c0             	test   %rax,%rax
  8036d4:	0f 84 93 00 00 00    	je     80376d <copy_shared_pages+0x133>
		{
			if (uvpt[VPN(i)]&PTE_SHARE)
  8036da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036de:	48 c1 e8 0c          	shr    $0xc,%rax
  8036e2:	48 89 c2             	mov    %rax,%rdx
  8036e5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036ec:	01 00 00 
  8036ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036f3:	25 00 04 00 00       	and    $0x400,%eax
  8036f8:	48 85 c0             	test   %rax,%rax
  8036fb:	74 70                	je     80376d <copy_shared_pages+0x133>
				if (sys_page_map(0, (void *)i, child, (void *)i, uvpt[VPN(i)] & PTE_SYSCALL)<0)
  8036fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803701:	48 c1 e8 0c          	shr    $0xc,%rax
  803705:	48 89 c2             	mov    %rax,%rdx
  803708:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80370f:	01 00 00 
  803712:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803716:	25 07 0e 00 00       	and    $0xe07,%eax
  80371b:	89 c6                	mov    %eax,%esi
  80371d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803721:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803725:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803728:	41 89 f0             	mov    %esi,%r8d
  80372b:	48 89 c6             	mov    %rax,%rsi
  80372e:	bf 00 00 00 00       	mov    $0x0,%edi
  803733:	48 b8 3b 19 80 00 00 	movabs $0x80193b,%rax
  80373a:	00 00 00 
  80373d:	ff d0                	callq  *%rax
  80373f:	85 c0                	test   %eax,%eax
  803741:	79 2a                	jns    80376d <copy_shared_pages+0x133>
					panic("copy_shared_pages: sys_page_map\n");
  803743:	48 ba f8 49 80 00 00 	movabs $0x8049f8,%rdx
  80374a:	00 00 00 
  80374d:	be 37 01 00 00       	mov    $0x137,%esi
  803752:	48 bf 60 49 80 00 00 	movabs $0x804960,%rdi
  803759:	00 00 00 
  80375c:	b8 00 00 00 00       	mov    $0x0,%eax
  803761:	48 b9 8d 01 80 00 00 	movabs $0x80018d,%rcx
  803768:	00 00 00 
  80376b:	ff d1                	callq  *%rcx
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint64_t  i;
	for (i=UTEXT;i<USTACKTOP;i+=PGSIZE)
  80376d:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803774:	00 
  803775:	b8 ff df 7f ef       	mov    $0xef7fdfff,%eax
  80377a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80377e:	0f 86 ce fe ff ff    	jbe    803652 <copy_shared_pages+0x18>
			if (uvpt[VPN(i)]&PTE_SHARE)
				if (sys_page_map(0, (void *)i, child, (void *)i, uvpt[VPN(i)] & PTE_SYSCALL)<0)
					panic("copy_shared_pages: sys_page_map\n");
		}
	}
	return 0;
  803784:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803789:	c9                   	leaveq 
  80378a:	c3                   	retq   

000000000080378b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80378b:	55                   	push   %rbp
  80378c:	48 89 e5             	mov    %rsp,%rbp
  80378f:	53                   	push   %rbx
  803790:	48 83 ec 38          	sub    $0x38,%rsp
  803794:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803798:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80379c:	48 89 c7             	mov    %rax,%rdi
  80379f:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  8037a6:	00 00 00 
  8037a9:	ff d0                	callq  *%rax
  8037ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037b2:	0f 88 bf 01 00 00    	js     803977 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037bc:	ba 07 04 00 00       	mov    $0x407,%edx
  8037c1:	48 89 c6             	mov    %rax,%rsi
  8037c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8037c9:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  8037d0:	00 00 00 
  8037d3:	ff d0                	callq  *%rax
  8037d5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037dc:	0f 88 95 01 00 00    	js     803977 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8037e2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8037e6:	48 89 c7             	mov    %rax,%rdi
  8037e9:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  8037f0:	00 00 00 
  8037f3:	ff d0                	callq  *%rax
  8037f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037fc:	0f 88 5d 01 00 00    	js     80395f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803802:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803806:	ba 07 04 00 00       	mov    $0x407,%edx
  80380b:	48 89 c6             	mov    %rax,%rsi
  80380e:	bf 00 00 00 00       	mov    $0x0,%edi
  803813:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  80381a:	00 00 00 
  80381d:	ff d0                	callq  *%rax
  80381f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803822:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803826:	0f 88 33 01 00 00    	js     80395f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80382c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803830:	48 89 c7             	mov    %rax,%rdi
  803833:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  80383a:	00 00 00 
  80383d:	ff d0                	callq  *%rax
  80383f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803843:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803847:	ba 07 04 00 00       	mov    $0x407,%edx
  80384c:	48 89 c6             	mov    %rax,%rsi
  80384f:	bf 00 00 00 00       	mov    $0x0,%edi
  803854:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  80385b:	00 00 00 
  80385e:	ff d0                	callq  *%rax
  803860:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803863:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803867:	79 05                	jns    80386e <pipe+0xe3>
		goto err2;
  803869:	e9 d9 00 00 00       	jmpq   803947 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80386e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803872:	48 89 c7             	mov    %rax,%rdi
  803875:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  80387c:	00 00 00 
  80387f:	ff d0                	callq  *%rax
  803881:	48 89 c2             	mov    %rax,%rdx
  803884:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803888:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80388e:	48 89 d1             	mov    %rdx,%rcx
  803891:	ba 00 00 00 00       	mov    $0x0,%edx
  803896:	48 89 c6             	mov    %rax,%rsi
  803899:	bf 00 00 00 00       	mov    $0x0,%edi
  80389e:	48 b8 3b 19 80 00 00 	movabs $0x80193b,%rax
  8038a5:	00 00 00 
  8038a8:	ff d0                	callq  *%rax
  8038aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038b1:	79 1b                	jns    8038ce <pipe+0x143>
		goto err3;
  8038b3:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8038b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038b8:	48 89 c6             	mov    %rax,%rsi
  8038bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8038c0:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  8038c7:	00 00 00 
  8038ca:	ff d0                	callq  *%rax
  8038cc:	eb 79                	jmp    803947 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8038ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038d2:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8038d9:	00 00 00 
  8038dc:	8b 12                	mov    (%rdx),%edx
  8038de:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8038e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8038eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038ef:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8038f6:	00 00 00 
  8038f9:	8b 12                	mov    (%rdx),%edx
  8038fb:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8038fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803901:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803908:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80390c:	48 89 c7             	mov    %rax,%rdi
  80390f:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  803916:	00 00 00 
  803919:	ff d0                	callq  *%rax
  80391b:	89 c2                	mov    %eax,%edx
  80391d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803921:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803923:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803927:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80392b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80392f:	48 89 c7             	mov    %rax,%rdi
  803932:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  803939:	00 00 00 
  80393c:	ff d0                	callq  *%rax
  80393e:	89 03                	mov    %eax,(%rbx)
	return 0;
  803940:	b8 00 00 00 00       	mov    $0x0,%eax
  803945:	eb 33                	jmp    80397a <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803947:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80394b:	48 89 c6             	mov    %rax,%rsi
  80394e:	bf 00 00 00 00       	mov    $0x0,%edi
  803953:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  80395a:	00 00 00 
  80395d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80395f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803963:	48 89 c6             	mov    %rax,%rsi
  803966:	bf 00 00 00 00       	mov    $0x0,%edi
  80396b:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  803972:	00 00 00 
  803975:	ff d0                	callq  *%rax
err:
	return r;
  803977:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80397a:	48 83 c4 38          	add    $0x38,%rsp
  80397e:	5b                   	pop    %rbx
  80397f:	5d                   	pop    %rbp
  803980:	c3                   	retq   

0000000000803981 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803981:	55                   	push   %rbp
  803982:	48 89 e5             	mov    %rsp,%rbp
  803985:	53                   	push   %rbx
  803986:	48 83 ec 28          	sub    $0x28,%rsp
  80398a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80398e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803992:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803999:	00 00 00 
  80399c:	48 8b 00             	mov    (%rax),%rax
  80399f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8039a5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8039a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ac:	48 89 c7             	mov    %rax,%rdi
  8039af:	48 b8 2b 42 80 00 00 	movabs $0x80422b,%rax
  8039b6:	00 00 00 
  8039b9:	ff d0                	callq  *%rax
  8039bb:	89 c3                	mov    %eax,%ebx
  8039bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039c1:	48 89 c7             	mov    %rax,%rdi
  8039c4:	48 b8 2b 42 80 00 00 	movabs $0x80422b,%rax
  8039cb:	00 00 00 
  8039ce:	ff d0                	callq  *%rax
  8039d0:	39 c3                	cmp    %eax,%ebx
  8039d2:	0f 94 c0             	sete   %al
  8039d5:	0f b6 c0             	movzbl %al,%eax
  8039d8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8039db:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039e2:	00 00 00 
  8039e5:	48 8b 00             	mov    (%rax),%rax
  8039e8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8039ee:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8039f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039f4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039f7:	75 05                	jne    8039fe <_pipeisclosed+0x7d>
			return ret;
  8039f9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8039fc:	eb 4f                	jmp    803a4d <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8039fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a01:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a04:	74 42                	je     803a48 <_pipeisclosed+0xc7>
  803a06:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803a0a:	75 3c                	jne    803a48 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803a0c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a13:	00 00 00 
  803a16:	48 8b 00             	mov    (%rax),%rax
  803a19:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803a1f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a22:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a25:	89 c6                	mov    %eax,%esi
  803a27:	48 bf 23 4a 80 00 00 	movabs $0x804a23,%rdi
  803a2e:	00 00 00 
  803a31:	b8 00 00 00 00       	mov    $0x0,%eax
  803a36:	49 b8 c6 03 80 00 00 	movabs $0x8003c6,%r8
  803a3d:	00 00 00 
  803a40:	41 ff d0             	callq  *%r8
	}
  803a43:	e9 4a ff ff ff       	jmpq   803992 <_pipeisclosed+0x11>
  803a48:	e9 45 ff ff ff       	jmpq   803992 <_pipeisclosed+0x11>
}
  803a4d:	48 83 c4 28          	add    $0x28,%rsp
  803a51:	5b                   	pop    %rbx
  803a52:	5d                   	pop    %rbp
  803a53:	c3                   	retq   

0000000000803a54 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803a54:	55                   	push   %rbp
  803a55:	48 89 e5             	mov    %rsp,%rbp
  803a58:	48 83 ec 30          	sub    $0x30,%rsp
  803a5c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a5f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803a63:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a66:	48 89 d6             	mov    %rdx,%rsi
  803a69:	89 c7                	mov    %eax,%edi
  803a6b:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  803a72:	00 00 00 
  803a75:	ff d0                	callq  *%rax
  803a77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a7e:	79 05                	jns    803a85 <pipeisclosed+0x31>
		return r;
  803a80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a83:	eb 31                	jmp    803ab6 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803a85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a89:	48 89 c7             	mov    %rax,%rdi
  803a8c:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  803a93:	00 00 00 
  803a96:	ff d0                	callq  *%rax
  803a98:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803a9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aa0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803aa4:	48 89 d6             	mov    %rdx,%rsi
  803aa7:	48 89 c7             	mov    %rax,%rdi
  803aaa:	48 b8 81 39 80 00 00 	movabs $0x803981,%rax
  803ab1:	00 00 00 
  803ab4:	ff d0                	callq  *%rax
}
  803ab6:	c9                   	leaveq 
  803ab7:	c3                   	retq   

0000000000803ab8 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ab8:	55                   	push   %rbp
  803ab9:	48 89 e5             	mov    %rsp,%rbp
  803abc:	48 83 ec 40          	sub    $0x40,%rsp
  803ac0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ac4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ac8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803acc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad0:	48 89 c7             	mov    %rax,%rdi
  803ad3:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  803ada:	00 00 00 
  803add:	ff d0                	callq  *%rax
  803adf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ae3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ae7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803aeb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803af2:	00 
  803af3:	e9 92 00 00 00       	jmpq   803b8a <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803af8:	eb 41                	jmp    803b3b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803afa:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803aff:	74 09                	je     803b0a <devpipe_read+0x52>
				return i;
  803b01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b05:	e9 92 00 00 00       	jmpq   803b9c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803b0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b12:	48 89 d6             	mov    %rdx,%rsi
  803b15:	48 89 c7             	mov    %rax,%rdi
  803b18:	48 b8 81 39 80 00 00 	movabs $0x803981,%rax
  803b1f:	00 00 00 
  803b22:	ff d0                	callq  *%rax
  803b24:	85 c0                	test   %eax,%eax
  803b26:	74 07                	je     803b2f <devpipe_read+0x77>
				return 0;
  803b28:	b8 00 00 00 00       	mov    $0x0,%eax
  803b2d:	eb 6d                	jmp    803b9c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803b2f:	48 b8 ad 18 80 00 00 	movabs $0x8018ad,%rax
  803b36:	00 00 00 
  803b39:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803b3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b3f:	8b 10                	mov    (%rax),%edx
  803b41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b45:	8b 40 04             	mov    0x4(%rax),%eax
  803b48:	39 c2                	cmp    %eax,%edx
  803b4a:	74 ae                	je     803afa <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803b4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b54:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803b58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b5c:	8b 00                	mov    (%rax),%eax
  803b5e:	99                   	cltd   
  803b5f:	c1 ea 1b             	shr    $0x1b,%edx
  803b62:	01 d0                	add    %edx,%eax
  803b64:	83 e0 1f             	and    $0x1f,%eax
  803b67:	29 d0                	sub    %edx,%eax
  803b69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b6d:	48 98                	cltq   
  803b6f:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803b74:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803b76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b7a:	8b 00                	mov    (%rax),%eax
  803b7c:	8d 50 01             	lea    0x1(%rax),%edx
  803b7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b83:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b85:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b8e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b92:	0f 82 60 ff ff ff    	jb     803af8 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803b98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b9c:	c9                   	leaveq 
  803b9d:	c3                   	retq   

0000000000803b9e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b9e:	55                   	push   %rbp
  803b9f:	48 89 e5             	mov    %rsp,%rbp
  803ba2:	48 83 ec 40          	sub    $0x40,%rsp
  803ba6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803baa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803bae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803bb2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bb6:	48 89 c7             	mov    %rax,%rdi
  803bb9:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  803bc0:	00 00 00 
  803bc3:	ff d0                	callq  *%rax
  803bc5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803bc9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bcd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803bd1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803bd8:	00 
  803bd9:	e9 8e 00 00 00       	jmpq   803c6c <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803bde:	eb 31                	jmp    803c11 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803be0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803be4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803be8:	48 89 d6             	mov    %rdx,%rsi
  803beb:	48 89 c7             	mov    %rax,%rdi
  803bee:	48 b8 81 39 80 00 00 	movabs $0x803981,%rax
  803bf5:	00 00 00 
  803bf8:	ff d0                	callq  *%rax
  803bfa:	85 c0                	test   %eax,%eax
  803bfc:	74 07                	je     803c05 <devpipe_write+0x67>
				return 0;
  803bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  803c03:	eb 79                	jmp    803c7e <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803c05:	48 b8 ad 18 80 00 00 	movabs $0x8018ad,%rax
  803c0c:	00 00 00 
  803c0f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c15:	8b 40 04             	mov    0x4(%rax),%eax
  803c18:	48 63 d0             	movslq %eax,%rdx
  803c1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c1f:	8b 00                	mov    (%rax),%eax
  803c21:	48 98                	cltq   
  803c23:	48 83 c0 20          	add    $0x20,%rax
  803c27:	48 39 c2             	cmp    %rax,%rdx
  803c2a:	73 b4                	jae    803be0 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803c2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c30:	8b 40 04             	mov    0x4(%rax),%eax
  803c33:	99                   	cltd   
  803c34:	c1 ea 1b             	shr    $0x1b,%edx
  803c37:	01 d0                	add    %edx,%eax
  803c39:	83 e0 1f             	and    $0x1f,%eax
  803c3c:	29 d0                	sub    %edx,%eax
  803c3e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c42:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803c46:	48 01 ca             	add    %rcx,%rdx
  803c49:	0f b6 0a             	movzbl (%rdx),%ecx
  803c4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c50:	48 98                	cltq   
  803c52:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803c56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c5a:	8b 40 04             	mov    0x4(%rax),%eax
  803c5d:	8d 50 01             	lea    0x1(%rax),%edx
  803c60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c64:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c67:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c70:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c74:	0f 82 64 ff ff ff    	jb     803bde <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803c7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c7e:	c9                   	leaveq 
  803c7f:	c3                   	retq   

0000000000803c80 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803c80:	55                   	push   %rbp
  803c81:	48 89 e5             	mov    %rsp,%rbp
  803c84:	48 83 ec 20          	sub    $0x20,%rsp
  803c88:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c8c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803c90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c94:	48 89 c7             	mov    %rax,%rdi
  803c97:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  803c9e:	00 00 00 
  803ca1:	ff d0                	callq  *%rax
  803ca3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803ca7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cab:	48 be 36 4a 80 00 00 	movabs $0x804a36,%rsi
  803cb2:	00 00 00 
  803cb5:	48 89 c7             	mov    %rax,%rdi
  803cb8:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  803cbf:	00 00 00 
  803cc2:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803cc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cc8:	8b 50 04             	mov    0x4(%rax),%edx
  803ccb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ccf:	8b 00                	mov    (%rax),%eax
  803cd1:	29 c2                	sub    %eax,%edx
  803cd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cd7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803cdd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ce1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803ce8:	00 00 00 
	stat->st_dev = &devpipe;
  803ceb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cef:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803cf6:	00 00 00 
  803cf9:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803d00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d05:	c9                   	leaveq 
  803d06:	c3                   	retq   

0000000000803d07 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803d07:	55                   	push   %rbp
  803d08:	48 89 e5             	mov    %rsp,%rbp
  803d0b:	48 83 ec 10          	sub    $0x10,%rsp
  803d0f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803d13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d17:	48 89 c6             	mov    %rax,%rsi
  803d1a:	bf 00 00 00 00       	mov    $0x0,%edi
  803d1f:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  803d26:	00 00 00 
  803d29:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803d2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d2f:	48 89 c7             	mov    %rax,%rdi
  803d32:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  803d39:	00 00 00 
  803d3c:	ff d0                	callq  *%rax
  803d3e:	48 89 c6             	mov    %rax,%rsi
  803d41:	bf 00 00 00 00       	mov    $0x0,%edi
  803d46:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  803d4d:	00 00 00 
  803d50:	ff d0                	callq  *%rax
}
  803d52:	c9                   	leaveq 
  803d53:	c3                   	retq   

0000000000803d54 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803d54:	55                   	push   %rbp
  803d55:	48 89 e5             	mov    %rsp,%rbp
  803d58:	48 83 ec 20          	sub    $0x20,%rsp
  803d5c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803d5f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d62:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803d65:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803d69:	be 01 00 00 00       	mov    $0x1,%esi
  803d6e:	48 89 c7             	mov    %rax,%rdi
  803d71:	48 b8 a3 17 80 00 00 	movabs $0x8017a3,%rax
  803d78:	00 00 00 
  803d7b:	ff d0                	callq  *%rax
}
  803d7d:	c9                   	leaveq 
  803d7e:	c3                   	retq   

0000000000803d7f <getchar>:

int
getchar(void)
{
  803d7f:	55                   	push   %rbp
  803d80:	48 89 e5             	mov    %rsp,%rbp
  803d83:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803d87:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803d8b:	ba 01 00 00 00       	mov    $0x1,%edx
  803d90:	48 89 c6             	mov    %rax,%rsi
  803d93:	bf 00 00 00 00       	mov    $0x0,%edi
  803d98:	48 b8 9e 21 80 00 00 	movabs $0x80219e,%rax
  803d9f:	00 00 00 
  803da2:	ff d0                	callq  *%rax
  803da4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803da7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dab:	79 05                	jns    803db2 <getchar+0x33>
		return r;
  803dad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db0:	eb 14                	jmp    803dc6 <getchar+0x47>
	if (r < 1)
  803db2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db6:	7f 07                	jg     803dbf <getchar+0x40>
		return -E_EOF;
  803db8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803dbd:	eb 07                	jmp    803dc6 <getchar+0x47>
	return c;
  803dbf:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803dc3:	0f b6 c0             	movzbl %al,%eax
}
  803dc6:	c9                   	leaveq 
  803dc7:	c3                   	retq   

0000000000803dc8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803dc8:	55                   	push   %rbp
  803dc9:	48 89 e5             	mov    %rsp,%rbp
  803dcc:	48 83 ec 20          	sub    $0x20,%rsp
  803dd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803dd3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803dd7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dda:	48 89 d6             	mov    %rdx,%rsi
  803ddd:	89 c7                	mov    %eax,%edi
  803ddf:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  803de6:	00 00 00 
  803de9:	ff d0                	callq  *%rax
  803deb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803df2:	79 05                	jns    803df9 <iscons+0x31>
		return r;
  803df4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df7:	eb 1a                	jmp    803e13 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803df9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dfd:	8b 10                	mov    (%rax),%edx
  803dff:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803e06:	00 00 00 
  803e09:	8b 00                	mov    (%rax),%eax
  803e0b:	39 c2                	cmp    %eax,%edx
  803e0d:	0f 94 c0             	sete   %al
  803e10:	0f b6 c0             	movzbl %al,%eax
}
  803e13:	c9                   	leaveq 
  803e14:	c3                   	retq   

0000000000803e15 <opencons>:

int
opencons(void)
{
  803e15:	55                   	push   %rbp
  803e16:	48 89 e5             	mov    %rsp,%rbp
  803e19:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803e1d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803e21:	48 89 c7             	mov    %rax,%rdi
  803e24:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  803e2b:	00 00 00 
  803e2e:	ff d0                	callq  *%rax
  803e30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e37:	79 05                	jns    803e3e <opencons+0x29>
		return r;
  803e39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e3c:	eb 5b                	jmp    803e99 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e42:	ba 07 04 00 00       	mov    $0x407,%edx
  803e47:	48 89 c6             	mov    %rax,%rsi
  803e4a:	bf 00 00 00 00       	mov    $0x0,%edi
  803e4f:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  803e56:	00 00 00 
  803e59:	ff d0                	callq  *%rax
  803e5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e62:	79 05                	jns    803e69 <opencons+0x54>
		return r;
  803e64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e67:	eb 30                	jmp    803e99 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803e69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e6d:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803e74:	00 00 00 
  803e77:	8b 12                	mov    (%rdx),%edx
  803e79:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803e7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e7f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803e86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e8a:	48 89 c7             	mov    %rax,%rdi
  803e8d:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  803e94:	00 00 00 
  803e97:	ff d0                	callq  *%rax
}
  803e99:	c9                   	leaveq 
  803e9a:	c3                   	retq   

0000000000803e9b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e9b:	55                   	push   %rbp
  803e9c:	48 89 e5             	mov    %rsp,%rbp
  803e9f:	48 83 ec 30          	sub    $0x30,%rsp
  803ea3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ea7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803eab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803eaf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803eb4:	75 07                	jne    803ebd <devcons_read+0x22>
		return 0;
  803eb6:	b8 00 00 00 00       	mov    $0x0,%eax
  803ebb:	eb 4b                	jmp    803f08 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803ebd:	eb 0c                	jmp    803ecb <devcons_read+0x30>
		sys_yield();
  803ebf:	48 b8 ad 18 80 00 00 	movabs $0x8018ad,%rax
  803ec6:	00 00 00 
  803ec9:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803ecb:	48 b8 ed 17 80 00 00 	movabs $0x8017ed,%rax
  803ed2:	00 00 00 
  803ed5:	ff d0                	callq  *%rax
  803ed7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ede:	74 df                	je     803ebf <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803ee0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ee4:	79 05                	jns    803eeb <devcons_read+0x50>
		return c;
  803ee6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ee9:	eb 1d                	jmp    803f08 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803eeb:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803eef:	75 07                	jne    803ef8 <devcons_read+0x5d>
		return 0;
  803ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  803ef6:	eb 10                	jmp    803f08 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803ef8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803efb:	89 c2                	mov    %eax,%edx
  803efd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f01:	88 10                	mov    %dl,(%rax)
	return 1;
  803f03:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803f08:	c9                   	leaveq 
  803f09:	c3                   	retq   

0000000000803f0a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f0a:	55                   	push   %rbp
  803f0b:	48 89 e5             	mov    %rsp,%rbp
  803f0e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803f15:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803f1c:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803f23:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f31:	eb 76                	jmp    803fa9 <devcons_write+0x9f>
		m = n - tot;
  803f33:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803f3a:	89 c2                	mov    %eax,%edx
  803f3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f3f:	29 c2                	sub    %eax,%edx
  803f41:	89 d0                	mov    %edx,%eax
  803f43:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803f46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f49:	83 f8 7f             	cmp    $0x7f,%eax
  803f4c:	76 07                	jbe    803f55 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803f4e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803f55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f58:	48 63 d0             	movslq %eax,%rdx
  803f5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f5e:	48 63 c8             	movslq %eax,%rcx
  803f61:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803f68:	48 01 c1             	add    %rax,%rcx
  803f6b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f72:	48 89 ce             	mov    %rcx,%rsi
  803f75:	48 89 c7             	mov    %rax,%rdi
  803f78:	48 b8 e0 12 80 00 00 	movabs $0x8012e0,%rax
  803f7f:	00 00 00 
  803f82:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803f84:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f87:	48 63 d0             	movslq %eax,%rdx
  803f8a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f91:	48 89 d6             	mov    %rdx,%rsi
  803f94:	48 89 c7             	mov    %rax,%rdi
  803f97:	48 b8 a3 17 80 00 00 	movabs $0x8017a3,%rax
  803f9e:	00 00 00 
  803fa1:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803fa3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fa6:	01 45 fc             	add    %eax,-0x4(%rbp)
  803fa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fac:	48 98                	cltq   
  803fae:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803fb5:	0f 82 78 ff ff ff    	jb     803f33 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803fbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803fbe:	c9                   	leaveq 
  803fbf:	c3                   	retq   

0000000000803fc0 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803fc0:	55                   	push   %rbp
  803fc1:	48 89 e5             	mov    %rsp,%rbp
  803fc4:	48 83 ec 08          	sub    $0x8,%rsp
  803fc8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803fcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fd1:	c9                   	leaveq 
  803fd2:	c3                   	retq   

0000000000803fd3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803fd3:	55                   	push   %rbp
  803fd4:	48 89 e5             	mov    %rsp,%rbp
  803fd7:	48 83 ec 10          	sub    $0x10,%rsp
  803fdb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803fdf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803fe3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe7:	48 be 42 4a 80 00 00 	movabs $0x804a42,%rsi
  803fee:	00 00 00 
  803ff1:	48 89 c7             	mov    %rax,%rdi
  803ff4:	48 b8 bc 0f 80 00 00 	movabs $0x800fbc,%rax
  803ffb:	00 00 00 
  803ffe:	ff d0                	callq  *%rax
	return 0;
  804000:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804005:	c9                   	leaveq 
  804006:	c3                   	retq   

0000000000804007 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804007:	55                   	push   %rbp
  804008:	48 89 e5             	mov    %rsp,%rbp
  80400b:	48 83 ec 30          	sub    $0x30,%rsp
  80400f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804013:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804017:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  80401b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804020:	75 08                	jne    80402a <ipc_recv+0x23>
  804022:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  804029:	ff 
	int res=sys_ipc_recv(pg);
  80402a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80402e:	48 89 c7             	mov    %rax,%rdi
  804031:	48 b8 5f 1b 80 00 00 	movabs $0x801b5f,%rax
  804038:	00 00 00 
  80403b:	ff d0                	callq  *%rax
  80403d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  804040:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804045:	74 26                	je     80406d <ipc_recv+0x66>
  804047:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80404b:	75 15                	jne    804062 <ipc_recv+0x5b>
  80404d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804054:	00 00 00 
  804057:	48 8b 00             	mov    (%rax),%rax
  80405a:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  804060:	eb 05                	jmp    804067 <ipc_recv+0x60>
  804062:	b8 00 00 00 00       	mov    $0x0,%eax
  804067:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80406b:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  80406d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804072:	74 26                	je     80409a <ipc_recv+0x93>
  804074:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804078:	75 15                	jne    80408f <ipc_recv+0x88>
  80407a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804081:	00 00 00 
  804084:	48 8b 00             	mov    (%rax),%rax
  804087:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  80408d:	eb 05                	jmp    804094 <ipc_recv+0x8d>
  80408f:	b8 00 00 00 00       	mov    $0x0,%eax
  804094:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804098:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  80409a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80409e:	75 15                	jne    8040b5 <ipc_recv+0xae>
  8040a0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8040a7:	00 00 00 
  8040aa:	48 8b 00             	mov    (%rax),%rax
  8040ad:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  8040b3:	eb 03                	jmp    8040b8 <ipc_recv+0xb1>
  8040b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  8040b8:	c9                   	leaveq 
  8040b9:	c3                   	retq   

00000000008040ba <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8040ba:	55                   	push   %rbp
  8040bb:	48 89 e5             	mov    %rsp,%rbp
  8040be:	48 83 ec 30          	sub    $0x30,%rsp
  8040c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8040c5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8040c8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8040cc:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  8040cf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8040d4:	75 0a                	jne    8040e0 <ipc_send+0x26>
  8040d6:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8040dd:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8040de:	eb 3e                	jmp    80411e <ipc_send+0x64>
  8040e0:	eb 3c                	jmp    80411e <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  8040e2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8040e6:	74 2a                	je     804112 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  8040e8:	48 ba 50 4a 80 00 00 	movabs $0x804a50,%rdx
  8040ef:	00 00 00 
  8040f2:	be 39 00 00 00       	mov    $0x39,%esi
  8040f7:	48 bf 7b 4a 80 00 00 	movabs $0x804a7b,%rdi
  8040fe:	00 00 00 
  804101:	b8 00 00 00 00       	mov    $0x0,%eax
  804106:	48 b9 8d 01 80 00 00 	movabs $0x80018d,%rcx
  80410d:	00 00 00 
  804110:	ff d1                	callq  *%rcx
		sys_yield();  
  804112:	48 b8 ad 18 80 00 00 	movabs $0x8018ad,%rax
  804119:	00 00 00 
  80411c:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  80411e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804121:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804124:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804128:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80412b:	89 c7                	mov    %eax,%edi
  80412d:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  804134:	00 00 00 
  804137:	ff d0                	callq  *%rax
  804139:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80413c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804140:	78 a0                	js     8040e2 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  804142:	c9                   	leaveq 
  804143:	c3                   	retq   

0000000000804144 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804144:	55                   	push   %rbp
  804145:	48 89 e5             	mov    %rsp,%rbp
  804148:	48 83 ec 10          	sub    $0x10,%rsp
  80414c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  804150:	48 ba 88 4a 80 00 00 	movabs $0x804a88,%rdx
  804157:	00 00 00 
  80415a:	be 47 00 00 00       	mov    $0x47,%esi
  80415f:	48 bf 7b 4a 80 00 00 	movabs $0x804a7b,%rdi
  804166:	00 00 00 
  804169:	b8 00 00 00 00       	mov    $0x0,%eax
  80416e:	48 b9 8d 01 80 00 00 	movabs $0x80018d,%rcx
  804175:	00 00 00 
  804178:	ff d1                	callq  *%rcx

000000000080417a <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80417a:	55                   	push   %rbp
  80417b:	48 89 e5             	mov    %rsp,%rbp
  80417e:	48 83 ec 20          	sub    $0x20,%rsp
  804182:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804185:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804188:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  80418c:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  80418f:	48 ba b0 4a 80 00 00 	movabs $0x804ab0,%rdx
  804196:	00 00 00 
  804199:	be 50 00 00 00       	mov    $0x50,%esi
  80419e:	48 bf 7b 4a 80 00 00 	movabs $0x804a7b,%rdi
  8041a5:	00 00 00 
  8041a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8041ad:	48 b9 8d 01 80 00 00 	movabs $0x80018d,%rcx
  8041b4:	00 00 00 
  8041b7:	ff d1                	callq  *%rcx

00000000008041b9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8041b9:	55                   	push   %rbp
  8041ba:	48 89 e5             	mov    %rsp,%rbp
  8041bd:	48 83 ec 14          	sub    $0x14,%rsp
  8041c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8041c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041cb:	eb 4e                	jmp    80421b <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8041cd:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041d4:	00 00 00 
  8041d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041da:	48 98                	cltq   
  8041dc:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8041e3:	48 01 d0             	add    %rdx,%rax
  8041e6:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8041ec:	8b 00                	mov    (%rax),%eax
  8041ee:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8041f1:	75 24                	jne    804217 <ipc_find_env+0x5e>
			return envs[i].env_id;
  8041f3:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041fa:	00 00 00 
  8041fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804200:	48 98                	cltq   
  804202:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  804209:	48 01 d0             	add    %rdx,%rax
  80420c:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804212:	8b 40 08             	mov    0x8(%rax),%eax
  804215:	eb 12                	jmp    804229 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804217:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80421b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804222:	7e a9                	jle    8041cd <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  804224:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804229:	c9                   	leaveq 
  80422a:	c3                   	retq   

000000000080422b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80422b:	55                   	push   %rbp
  80422c:	48 89 e5             	mov    %rsp,%rbp
  80422f:	48 83 ec 18          	sub    $0x18,%rsp
  804233:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804237:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80423b:	48 c1 e8 15          	shr    $0x15,%rax
  80423f:	48 89 c2             	mov    %rax,%rdx
  804242:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804249:	01 00 00 
  80424c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804250:	83 e0 01             	and    $0x1,%eax
  804253:	48 85 c0             	test   %rax,%rax
  804256:	75 07                	jne    80425f <pageref+0x34>
		return 0;
  804258:	b8 00 00 00 00       	mov    $0x0,%eax
  80425d:	eb 53                	jmp    8042b2 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80425f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804263:	48 c1 e8 0c          	shr    $0xc,%rax
  804267:	48 89 c2             	mov    %rax,%rdx
  80426a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804271:	01 00 00 
  804274:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804278:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80427c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804280:	83 e0 01             	and    $0x1,%eax
  804283:	48 85 c0             	test   %rax,%rax
  804286:	75 07                	jne    80428f <pageref+0x64>
		return 0;
  804288:	b8 00 00 00 00       	mov    $0x0,%eax
  80428d:	eb 23                	jmp    8042b2 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80428f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804293:	48 c1 e8 0c          	shr    $0xc,%rax
  804297:	48 89 c2             	mov    %rax,%rdx
  80429a:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8042a1:	00 00 00 
  8042a4:	48 c1 e2 04          	shl    $0x4,%rdx
  8042a8:	48 01 d0             	add    %rdx,%rax
  8042ab:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8042af:	0f b7 c0             	movzwl %ax,%eax
}
  8042b2:	c9                   	leaveq 
  8042b3:	c3                   	retq   
