
vmm/guest/obj/user/lsfd:     file format elf64-x86-64


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
  80003c:	e8 7c 01 00 00       	callq  8001bd <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: lsfd [-1]\n");
  800047:	48 bf e0 3d 80 00 00 	movabs $0x803de0,%rdi
  80004e:	00 00 00 
  800051:	b8 00 00 00 00       	mov    $0x0,%eax
  800056:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  80005d:	00 00 00 
  800060:	ff d2                	callq  *%rdx
	exit();
  800062:	48 b8 40 02 80 00 00 	movabs $0x800240,%rax
  800069:	00 00 00 
  80006c:	ff d0                	callq  *%rax
}
  80006e:	5d                   	pop    %rbp
  80006f:	c3                   	retq   

0000000000800070 <umain>:

void
umain(int argc, char **argv)
{
  800070:	55                   	push   %rbp
  800071:	48 89 e5             	mov    %rsp,%rbp
  800074:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80007b:	89 bd 3c ff ff ff    	mov    %edi,-0xc4(%rbp)
  800081:	48 89 b5 30 ff ff ff 	mov    %rsi,-0xd0(%rbp)
	int i, usefprint = 0;
  800088:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  80008f:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  800096:	48 8b 8d 30 ff ff ff 	mov    -0xd0(%rbp),%rcx
  80009d:	48 8d 85 3c ff ff ff 	lea    -0xc4(%rbp),%rax
  8000a4:	48 89 ce             	mov    %rcx,%rsi
  8000a7:	48 89 c7             	mov    %rax,%rdi
  8000aa:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  8000b1:	00 00 00 
  8000b4:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  8000b6:	eb 1b                	jmp    8000d3 <umain+0x63>
		if (i == '1')
  8000b8:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  8000bc:	75 09                	jne    8000c7 <umain+0x57>
			usefprint = 1;
  8000be:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
  8000c5:	eb 0c                	jmp    8000d3 <umain+0x63>
		else
			usage();
  8000c7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ce:	00 00 00 
  8000d1:	ff d0                	callq  *%rax
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8000d3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000f0:	79 c6                	jns    8000b8 <umain+0x48>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8000f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000f9:	e9 b3 00 00 00       	jmpq   8001b1 <umain+0x141>
		if (fstat(i, &st) >= 0) {
  8000fe:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800105:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800108:	48 89 d6             	mov    %rdx,%rsi
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 74 27 80 00 00 	movabs $0x802774,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
  800119:	85 c0                	test   %eax,%eax
  80011b:	0f 88 8c 00 00 00    	js     8001ad <umain+0x13d>
			if (usefprint)
  800121:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800125:	74 4a                	je     800171 <umain+0x101>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80012b:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80012f:	8b 7d e0             	mov    -0x20(%rbp),%edi
  800132:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800135:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80013c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80013f:	48 89 0c 24          	mov    %rcx,(%rsp)
  800143:	41 89 f9             	mov    %edi,%r9d
  800146:	41 89 f0             	mov    %esi,%r8d
  800149:	48 89 d1             	mov    %rdx,%rcx
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	48 be f8 3d 80 00 00 	movabs $0x803df8,%rsi
  800155:	00 00 00 
  800158:	bf 01 00 00 00       	mov    $0x1,%edi
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
  800162:	49 ba 27 30 80 00 00 	movabs $0x803027,%r10
  800169:	00 00 00 
  80016c:	41 ff d2             	callq  *%r10
  80016f:	eb 3c                	jmp    8001ad <umain+0x13d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800175:	48 8b 78 08          	mov    0x8(%rax),%rdi
  800179:	8b 75 e0             	mov    -0x20(%rbp),%esi
  80017c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80017f:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800189:	49 89 f9             	mov    %rdi,%r9
  80018c:	41 89 f0             	mov    %esi,%r8d
  80018f:	89 c6                	mov    %eax,%esi
  800191:	48 bf f8 3d 80 00 00 	movabs $0x803df8,%rdi
  800198:	00 00 00 
  80019b:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a0:	49 ba 88 03 80 00 00 	movabs $0x800388,%r10
  8001a7:	00 00 00 
  8001aa:	41 ff d2             	callq  *%r10
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8001ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001b1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8001b5:	0f 8e 43 ff ff ff    	jle    8000fe <umain+0x8e>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  8001bb:	c9                   	leaveq 
  8001bc:	c3                   	retq   

00000000008001bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001bd:	55                   	push   %rbp
  8001be:	48 89 e5             	mov    %rsp,%rbp
  8001c1:	48 83 ec 10          	sub    $0x10,%rsp
  8001c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  8001cc:	48 b8 31 18 80 00 00 	movabs $0x801831,%rax
  8001d3:	00 00 00 
  8001d6:	ff d0                	callq  *%rax
  8001d8:	48 98                	cltq   
  8001da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001df:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8001e6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001ed:	00 00 00 
  8001f0:	48 01 c2             	add    %rax,%rdx
  8001f3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001fa:	00 00 00 
  8001fd:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800200:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800204:	7e 14                	jle    80021a <libmain+0x5d>
		binaryname = argv[0];
  800206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800214:	00 00 00 
  800217:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80021a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80021e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800221:	48 89 d6             	mov    %rdx,%rsi
  800224:	89 c7                	mov    %eax,%edi
  800226:	48 b8 70 00 80 00 00 	movabs $0x800070,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800232:	48 b8 40 02 80 00 00 	movabs $0x800240,%rax
  800239:	00 00 00 
  80023c:	ff d0                	callq  *%rax
}
  80023e:	c9                   	leaveq 
  80023f:	c3                   	retq   

0000000000800240 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800240:	55                   	push   %rbp
  800241:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800244:	48 b8 6e 22 80 00 00 	movabs $0x80226e,%rax
  80024b:	00 00 00 
  80024e:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800250:	bf 00 00 00 00       	mov    $0x0,%edi
  800255:	48 b8 ed 17 80 00 00 	movabs $0x8017ed,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax
}
  800261:	5d                   	pop    %rbp
  800262:	c3                   	retq   

0000000000800263 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800263:	55                   	push   %rbp
  800264:	48 89 e5             	mov    %rsp,%rbp
  800267:	48 83 ec 10          	sub    $0x10,%rsp
  80026b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80026e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800276:	8b 00                	mov    (%rax),%eax
  800278:	8d 48 01             	lea    0x1(%rax),%ecx
  80027b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80027f:	89 0a                	mov    %ecx,(%rdx)
  800281:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800284:	89 d1                	mov    %edx,%ecx
  800286:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80028a:	48 98                	cltq   
  80028c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800290:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800294:	8b 00                	mov    (%rax),%eax
  800296:	3d ff 00 00 00       	cmp    $0xff,%eax
  80029b:	75 2c                	jne    8002c9 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80029d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a1:	8b 00                	mov    (%rax),%eax
  8002a3:	48 98                	cltq   
  8002a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002a9:	48 83 c2 08          	add    $0x8,%rdx
  8002ad:	48 89 c6             	mov    %rax,%rsi
  8002b0:	48 89 d7             	mov    %rdx,%rdi
  8002b3:	48 b8 65 17 80 00 00 	movabs $0x801765,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
        b->idx = 0;
  8002bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002c3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8002c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002cd:	8b 40 04             	mov    0x4(%rax),%eax
  8002d0:	8d 50 01             	lea    0x1(%rax),%edx
  8002d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d7:	89 50 04             	mov    %edx,0x4(%rax)
}
  8002da:	c9                   	leaveq 
  8002db:	c3                   	retq   

00000000008002dc <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8002dc:	55                   	push   %rbp
  8002dd:	48 89 e5             	mov    %rsp,%rbp
  8002e0:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8002e7:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002ee:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8002f5:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002fc:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800303:	48 8b 0a             	mov    (%rdx),%rcx
  800306:	48 89 08             	mov    %rcx,(%rax)
  800309:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80030d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800311:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800315:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800319:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800320:	00 00 00 
    b.cnt = 0;
  800323:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80032a:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80032d:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800334:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80033b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800342:	48 89 c6             	mov    %rax,%rsi
  800345:	48 bf 63 02 80 00 00 	movabs $0x800263,%rdi
  80034c:	00 00 00 
  80034f:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  800356:	00 00 00 
  800359:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80035b:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800361:	48 98                	cltq   
  800363:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80036a:	48 83 c2 08          	add    $0x8,%rdx
  80036e:	48 89 c6             	mov    %rax,%rsi
  800371:	48 89 d7             	mov    %rdx,%rdi
  800374:	48 b8 65 17 80 00 00 	movabs $0x801765,%rax
  80037b:	00 00 00 
  80037e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800380:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800386:	c9                   	leaveq 
  800387:	c3                   	retq   

0000000000800388 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800388:	55                   	push   %rbp
  800389:	48 89 e5             	mov    %rsp,%rbp
  80038c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800393:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80039a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003a1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003a8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003af:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003b6:	84 c0                	test   %al,%al
  8003b8:	74 20                	je     8003da <cprintf+0x52>
  8003ba:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003be:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8003c2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8003c6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8003ca:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8003ce:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8003d2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8003d6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8003da:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8003e1:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8003e8:	00 00 00 
  8003eb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003f2:	00 00 00 
  8003f5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003f9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800400:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800407:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80040e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800415:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80041c:	48 8b 0a             	mov    (%rdx),%rcx
  80041f:	48 89 08             	mov    %rcx,(%rax)
  800422:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800426:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80042a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80042e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800432:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800439:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800440:	48 89 d6             	mov    %rdx,%rsi
  800443:	48 89 c7             	mov    %rax,%rdi
  800446:	48 b8 dc 02 80 00 00 	movabs $0x8002dc,%rax
  80044d:	00 00 00 
  800450:	ff d0                	callq  *%rax
  800452:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800458:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80045e:	c9                   	leaveq 
  80045f:	c3                   	retq   

0000000000800460 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800460:	55                   	push   %rbp
  800461:	48 89 e5             	mov    %rsp,%rbp
  800464:	53                   	push   %rbx
  800465:	48 83 ec 38          	sub    $0x38,%rsp
  800469:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80046d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800471:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800475:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800478:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80047c:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800480:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800483:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800487:	77 3b                	ja     8004c4 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800489:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80048c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800490:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800493:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800497:	ba 00 00 00 00       	mov    $0x0,%edx
  80049c:	48 f7 f3             	div    %rbx
  80049f:	48 89 c2             	mov    %rax,%rdx
  8004a2:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004a5:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004a8:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b0:	41 89 f9             	mov    %edi,%r9d
  8004b3:	48 89 c7             	mov    %rax,%rdi
  8004b6:	48 b8 60 04 80 00 00 	movabs $0x800460,%rax
  8004bd:	00 00 00 
  8004c0:	ff d0                	callq  *%rax
  8004c2:	eb 1e                	jmp    8004e2 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004c4:	eb 12                	jmp    8004d8 <printnum+0x78>
			putch(padc, putdat);
  8004c6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004ca:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8004cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d1:	48 89 ce             	mov    %rcx,%rsi
  8004d4:	89 d7                	mov    %edx,%edi
  8004d6:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004d8:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8004dc:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8004e0:	7f e4                	jg     8004c6 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004e2:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ee:	48 f7 f1             	div    %rcx
  8004f1:	48 89 d0             	mov    %rdx,%rax
  8004f4:	48 ba 30 40 80 00 00 	movabs $0x804030,%rdx
  8004fb:	00 00 00 
  8004fe:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800502:	0f be d0             	movsbl %al,%edx
  800505:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050d:	48 89 ce             	mov    %rcx,%rsi
  800510:	89 d7                	mov    %edx,%edi
  800512:	ff d0                	callq  *%rax
}
  800514:	48 83 c4 38          	add    $0x38,%rsp
  800518:	5b                   	pop    %rbx
  800519:	5d                   	pop    %rbp
  80051a:	c3                   	retq   

000000000080051b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	48 83 ec 1c          	sub    $0x1c,%rsp
  800523:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800527:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80052a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80052e:	7e 52                	jle    800582 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800534:	8b 00                	mov    (%rax),%eax
  800536:	83 f8 30             	cmp    $0x30,%eax
  800539:	73 24                	jae    80055f <getuint+0x44>
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
  80055d:	eb 17                	jmp    800576 <getuint+0x5b>
  80055f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800563:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800567:	48 89 d0             	mov    %rdx,%rax
  80056a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80056e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800572:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800576:	48 8b 00             	mov    (%rax),%rax
  800579:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80057d:	e9 a3 00 00 00       	jmpq   800625 <getuint+0x10a>
	else if (lflag)
  800582:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800586:	74 4f                	je     8005d7 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058c:	8b 00                	mov    (%rax),%eax
  80058e:	83 f8 30             	cmp    $0x30,%eax
  800591:	73 24                	jae    8005b7 <getuint+0x9c>
  800593:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800597:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80059b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059f:	8b 00                	mov    (%rax),%eax
  8005a1:	89 c0                	mov    %eax,%eax
  8005a3:	48 01 d0             	add    %rdx,%rax
  8005a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005aa:	8b 12                	mov    (%rdx),%edx
  8005ac:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b3:	89 0a                	mov    %ecx,(%rdx)
  8005b5:	eb 17                	jmp    8005ce <getuint+0xb3>
  8005b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005bf:	48 89 d0             	mov    %rdx,%rax
  8005c2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ce:	48 8b 00             	mov    (%rax),%rax
  8005d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005d5:	eb 4e                	jmp    800625 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8005d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005db:	8b 00                	mov    (%rax),%eax
  8005dd:	83 f8 30             	cmp    $0x30,%eax
  8005e0:	73 24                	jae    800606 <getuint+0xeb>
  8005e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	8b 00                	mov    (%rax),%eax
  8005f0:	89 c0                	mov    %eax,%eax
  8005f2:	48 01 d0             	add    %rdx,%rax
  8005f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f9:	8b 12                	mov    (%rdx),%edx
  8005fb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800602:	89 0a                	mov    %ecx,(%rdx)
  800604:	eb 17                	jmp    80061d <getuint+0x102>
  800606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060e:	48 89 d0             	mov    %rdx,%rax
  800611:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800615:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800619:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061d:	8b 00                	mov    (%rax),%eax
  80061f:	89 c0                	mov    %eax,%eax
  800621:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800625:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800629:	c9                   	leaveq 
  80062a:	c3                   	retq   

000000000080062b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80062b:	55                   	push   %rbp
  80062c:	48 89 e5             	mov    %rsp,%rbp
  80062f:	48 83 ec 1c          	sub    $0x1c,%rsp
  800633:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800637:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80063a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80063e:	7e 52                	jle    800692 <getint+0x67>
		x=va_arg(*ap, long long);
  800640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800644:	8b 00                	mov    (%rax),%eax
  800646:	83 f8 30             	cmp    $0x30,%eax
  800649:	73 24                	jae    80066f <getint+0x44>
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
  80066d:	eb 17                	jmp    800686 <getint+0x5b>
  80066f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800673:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800677:	48 89 d0             	mov    %rdx,%rax
  80067a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80067e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800682:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800686:	48 8b 00             	mov    (%rax),%rax
  800689:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80068d:	e9 a3 00 00 00       	jmpq   800735 <getint+0x10a>
	else if (lflag)
  800692:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800696:	74 4f                	je     8006e7 <getint+0xbc>
		x=va_arg(*ap, long);
  800698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069c:	8b 00                	mov    (%rax),%eax
  80069e:	83 f8 30             	cmp    $0x30,%eax
  8006a1:	73 24                	jae    8006c7 <getint+0x9c>
  8006a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006af:	8b 00                	mov    (%rax),%eax
  8006b1:	89 c0                	mov    %eax,%eax
  8006b3:	48 01 d0             	add    %rdx,%rax
  8006b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ba:	8b 12                	mov    (%rdx),%edx
  8006bc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c3:	89 0a                	mov    %ecx,(%rdx)
  8006c5:	eb 17                	jmp    8006de <getint+0xb3>
  8006c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006cf:	48 89 d0             	mov    %rdx,%rax
  8006d2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006da:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006de:	48 8b 00             	mov    (%rax),%rax
  8006e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006e5:	eb 4e                	jmp    800735 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8006e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006eb:	8b 00                	mov    (%rax),%eax
  8006ed:	83 f8 30             	cmp    $0x30,%eax
  8006f0:	73 24                	jae    800716 <getint+0xeb>
  8006f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fe:	8b 00                	mov    (%rax),%eax
  800700:	89 c0                	mov    %eax,%eax
  800702:	48 01 d0             	add    %rdx,%rax
  800705:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800709:	8b 12                	mov    (%rdx),%edx
  80070b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80070e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800712:	89 0a                	mov    %ecx,(%rdx)
  800714:	eb 17                	jmp    80072d <getint+0x102>
  800716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80071e:	48 89 d0             	mov    %rdx,%rax
  800721:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800725:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800729:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80072d:	8b 00                	mov    (%rax),%eax
  80072f:	48 98                	cltq   
  800731:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800735:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800739:	c9                   	leaveq 
  80073a:	c3                   	retq   

000000000080073b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80073b:	55                   	push   %rbp
  80073c:	48 89 e5             	mov    %rsp,%rbp
  80073f:	41 54                	push   %r12
  800741:	53                   	push   %rbx
  800742:	48 83 ec 60          	sub    $0x60,%rsp
  800746:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80074a:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80074e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800752:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800756:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80075a:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80075e:	48 8b 0a             	mov    (%rdx),%rcx
  800761:	48 89 08             	mov    %rcx,(%rax)
  800764:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800768:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80076c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800770:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800774:	eb 28                	jmp    80079e <vprintfmt+0x63>
			if (ch == '\0'){
  800776:	85 db                	test   %ebx,%ebx
  800778:	75 15                	jne    80078f <vprintfmt+0x54>
				current_color=WHITE;
  80077a:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800781:	00 00 00 
  800784:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  80078a:	e9 fc 04 00 00       	jmpq   800c8b <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  80078f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800793:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800797:	48 89 d6             	mov    %rdx,%rsi
  80079a:	89 df                	mov    %ebx,%edi
  80079c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007a6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007aa:	0f b6 00             	movzbl (%rax),%eax
  8007ad:	0f b6 d8             	movzbl %al,%ebx
  8007b0:	83 fb 25             	cmp    $0x25,%ebx
  8007b3:	75 c1                	jne    800776 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007b5:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007b9:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007c0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007ce:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007d5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007dd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007e1:	0f b6 00             	movzbl (%rax),%eax
  8007e4:	0f b6 d8             	movzbl %al,%ebx
  8007e7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8007ea:	83 f8 55             	cmp    $0x55,%eax
  8007ed:	0f 87 64 04 00 00    	ja     800c57 <vprintfmt+0x51c>
  8007f3:	89 c0                	mov    %eax,%eax
  8007f5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007fc:	00 
  8007fd:	48 b8 58 40 80 00 00 	movabs $0x804058,%rax
  800804:	00 00 00 
  800807:	48 01 d0             	add    %rdx,%rax
  80080a:	48 8b 00             	mov    (%rax),%rax
  80080d:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80080f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800813:	eb c0                	jmp    8007d5 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800815:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800819:	eb ba                	jmp    8007d5 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80081b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800822:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800825:	89 d0                	mov    %edx,%eax
  800827:	c1 e0 02             	shl    $0x2,%eax
  80082a:	01 d0                	add    %edx,%eax
  80082c:	01 c0                	add    %eax,%eax
  80082e:	01 d8                	add    %ebx,%eax
  800830:	83 e8 30             	sub    $0x30,%eax
  800833:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800836:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80083a:	0f b6 00             	movzbl (%rax),%eax
  80083d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800840:	83 fb 2f             	cmp    $0x2f,%ebx
  800843:	7e 0c                	jle    800851 <vprintfmt+0x116>
  800845:	83 fb 39             	cmp    $0x39,%ebx
  800848:	7f 07                	jg     800851 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80084a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80084f:	eb d1                	jmp    800822 <vprintfmt+0xe7>
			goto process_precision;
  800851:	eb 58                	jmp    8008ab <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800853:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800856:	83 f8 30             	cmp    $0x30,%eax
  800859:	73 17                	jae    800872 <vprintfmt+0x137>
  80085b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80085f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800862:	89 c0                	mov    %eax,%eax
  800864:	48 01 d0             	add    %rdx,%rax
  800867:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80086a:	83 c2 08             	add    $0x8,%edx
  80086d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800870:	eb 0f                	jmp    800881 <vprintfmt+0x146>
  800872:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800876:	48 89 d0             	mov    %rdx,%rax
  800879:	48 83 c2 08          	add    $0x8,%rdx
  80087d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800881:	8b 00                	mov    (%rax),%eax
  800883:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800886:	eb 23                	jmp    8008ab <vprintfmt+0x170>

		case '.':
			if (width < 0)
  800888:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80088c:	79 0c                	jns    80089a <vprintfmt+0x15f>
				width = 0;
  80088e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800895:	e9 3b ff ff ff       	jmpq   8007d5 <vprintfmt+0x9a>
  80089a:	e9 36 ff ff ff       	jmpq   8007d5 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  80089f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008a6:	e9 2a ff ff ff       	jmpq   8007d5 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  8008ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008af:	79 12                	jns    8008c3 <vprintfmt+0x188>
				width = precision, precision = -1;
  8008b1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008b4:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008b7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008be:	e9 12 ff ff ff       	jmpq   8007d5 <vprintfmt+0x9a>
  8008c3:	e9 0d ff ff ff       	jmpq   8007d5 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008cc:	e9 04 ff ff ff       	jmpq   8007d5 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8008d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d4:	83 f8 30             	cmp    $0x30,%eax
  8008d7:	73 17                	jae    8008f0 <vprintfmt+0x1b5>
  8008d9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e0:	89 c0                	mov    %eax,%eax
  8008e2:	48 01 d0             	add    %rdx,%rax
  8008e5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008e8:	83 c2 08             	add    $0x8,%edx
  8008eb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008ee:	eb 0f                	jmp    8008ff <vprintfmt+0x1c4>
  8008f0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008f4:	48 89 d0             	mov    %rdx,%rax
  8008f7:	48 83 c2 08          	add    $0x8,%rdx
  8008fb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008ff:	8b 10                	mov    (%rax),%edx
  800901:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800905:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800909:	48 89 ce             	mov    %rcx,%rsi
  80090c:	89 d7                	mov    %edx,%edi
  80090e:	ff d0                	callq  *%rax
			break;
  800910:	e9 70 03 00 00       	jmpq   800c85 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800915:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800918:	83 f8 30             	cmp    $0x30,%eax
  80091b:	73 17                	jae    800934 <vprintfmt+0x1f9>
  80091d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800921:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800924:	89 c0                	mov    %eax,%eax
  800926:	48 01 d0             	add    %rdx,%rax
  800929:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80092c:	83 c2 08             	add    $0x8,%edx
  80092f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800932:	eb 0f                	jmp    800943 <vprintfmt+0x208>
  800934:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800938:	48 89 d0             	mov    %rdx,%rax
  80093b:	48 83 c2 08          	add    $0x8,%rdx
  80093f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800943:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800945:	85 db                	test   %ebx,%ebx
  800947:	79 02                	jns    80094b <vprintfmt+0x210>
				err = -err;
  800949:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80094b:	83 fb 15             	cmp    $0x15,%ebx
  80094e:	7f 16                	jg     800966 <vprintfmt+0x22b>
  800950:	48 b8 80 3f 80 00 00 	movabs $0x803f80,%rax
  800957:	00 00 00 
  80095a:	48 63 d3             	movslq %ebx,%rdx
  80095d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800961:	4d 85 e4             	test   %r12,%r12
  800964:	75 2e                	jne    800994 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  800966:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80096a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80096e:	89 d9                	mov    %ebx,%ecx
  800970:	48 ba 41 40 80 00 00 	movabs $0x804041,%rdx
  800977:	00 00 00 
  80097a:	48 89 c7             	mov    %rax,%rdi
  80097d:	b8 00 00 00 00       	mov    $0x0,%eax
  800982:	49 b8 94 0c 80 00 00 	movabs $0x800c94,%r8
  800989:	00 00 00 
  80098c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80098f:	e9 f1 02 00 00       	jmpq   800c85 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800994:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800998:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80099c:	4c 89 e1             	mov    %r12,%rcx
  80099f:	48 ba 4a 40 80 00 00 	movabs $0x80404a,%rdx
  8009a6:	00 00 00 
  8009a9:	48 89 c7             	mov    %rax,%rdi
  8009ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b1:	49 b8 94 0c 80 00 00 	movabs $0x800c94,%r8
  8009b8:	00 00 00 
  8009bb:	41 ff d0             	callq  *%r8
			break;
  8009be:	e9 c2 02 00 00       	jmpq   800c85 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009c3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c6:	83 f8 30             	cmp    $0x30,%eax
  8009c9:	73 17                	jae    8009e2 <vprintfmt+0x2a7>
  8009cb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009cf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d2:	89 c0                	mov    %eax,%eax
  8009d4:	48 01 d0             	add    %rdx,%rax
  8009d7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009da:	83 c2 08             	add    $0x8,%edx
  8009dd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009e0:	eb 0f                	jmp    8009f1 <vprintfmt+0x2b6>
  8009e2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e6:	48 89 d0             	mov    %rdx,%rax
  8009e9:	48 83 c2 08          	add    $0x8,%rdx
  8009ed:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009f1:	4c 8b 20             	mov    (%rax),%r12
  8009f4:	4d 85 e4             	test   %r12,%r12
  8009f7:	75 0a                	jne    800a03 <vprintfmt+0x2c8>
				p = "(null)";
  8009f9:	49 bc 4d 40 80 00 00 	movabs $0x80404d,%r12
  800a00:	00 00 00 
			if (width > 0 && padc != '-')
  800a03:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a07:	7e 3f                	jle    800a48 <vprintfmt+0x30d>
  800a09:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a0d:	74 39                	je     800a48 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a12:	48 98                	cltq   
  800a14:	48 89 c6             	mov    %rax,%rsi
  800a17:	4c 89 e7             	mov    %r12,%rdi
  800a1a:	48 b8 40 0f 80 00 00 	movabs $0x800f40,%rax
  800a21:	00 00 00 
  800a24:	ff d0                	callq  *%rax
  800a26:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a29:	eb 17                	jmp    800a42 <vprintfmt+0x307>
					putch(padc, putdat);
  800a2b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a2f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a33:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a37:	48 89 ce             	mov    %rcx,%rsi
  800a3a:	89 d7                	mov    %edx,%edi
  800a3c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a42:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a46:	7f e3                	jg     800a2b <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a48:	eb 37                	jmp    800a81 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  800a4a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a4e:	74 1e                	je     800a6e <vprintfmt+0x333>
  800a50:	83 fb 1f             	cmp    $0x1f,%ebx
  800a53:	7e 05                	jle    800a5a <vprintfmt+0x31f>
  800a55:	83 fb 7e             	cmp    $0x7e,%ebx
  800a58:	7e 14                	jle    800a6e <vprintfmt+0x333>
					putch('?', putdat);
  800a5a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a62:	48 89 d6             	mov    %rdx,%rsi
  800a65:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a6a:	ff d0                	callq  *%rax
  800a6c:	eb 0f                	jmp    800a7d <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800a6e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a76:	48 89 d6             	mov    %rdx,%rsi
  800a79:	89 df                	mov    %ebx,%edi
  800a7b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a7d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a81:	4c 89 e0             	mov    %r12,%rax
  800a84:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a88:	0f b6 00             	movzbl (%rax),%eax
  800a8b:	0f be d8             	movsbl %al,%ebx
  800a8e:	85 db                	test   %ebx,%ebx
  800a90:	74 10                	je     800aa2 <vprintfmt+0x367>
  800a92:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a96:	78 b2                	js     800a4a <vprintfmt+0x30f>
  800a98:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a9c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800aa0:	79 a8                	jns    800a4a <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa2:	eb 16                	jmp    800aba <vprintfmt+0x37f>
				putch(' ', putdat);
  800aa4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aac:	48 89 d6             	mov    %rdx,%rsi
  800aaf:	bf 20 00 00 00       	mov    $0x20,%edi
  800ab4:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800aba:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800abe:	7f e4                	jg     800aa4 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800ac0:	e9 c0 01 00 00       	jmpq   800c85 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ac5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac9:	be 03 00 00 00       	mov    $0x3,%esi
  800ace:	48 89 c7             	mov    %rax,%rdi
  800ad1:	48 b8 2b 06 80 00 00 	movabs $0x80062b,%rax
  800ad8:	00 00 00 
  800adb:	ff d0                	callq  *%rax
  800add:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ae1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae5:	48 85 c0             	test   %rax,%rax
  800ae8:	79 1d                	jns    800b07 <vprintfmt+0x3cc>
				putch('-', putdat);
  800aea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af2:	48 89 d6             	mov    %rdx,%rsi
  800af5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800afa:	ff d0                	callq  *%rax
				num = -(long long) num;
  800afc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b00:	48 f7 d8             	neg    %rax
  800b03:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b07:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b0e:	e9 d5 00 00 00       	jmpq   800be8 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b13:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b17:	be 03 00 00 00       	mov    $0x3,%esi
  800b1c:	48 89 c7             	mov    %rax,%rdi
  800b1f:	48 b8 1b 05 80 00 00 	movabs $0x80051b,%rax
  800b26:	00 00 00 
  800b29:	ff d0                	callq  *%rax
  800b2b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b2f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b36:	e9 ad 00 00 00       	jmpq   800be8 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800b3b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b3f:	be 03 00 00 00       	mov    $0x3,%esi
  800b44:	48 89 c7             	mov    %rax,%rdi
  800b47:	48 b8 1b 05 80 00 00 	movabs $0x80051b,%rax
  800b4e:	00 00 00 
  800b51:	ff d0                	callq  *%rax
  800b53:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800b57:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b5e:	e9 85 00 00 00       	jmpq   800be8 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800b63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6b:	48 89 d6             	mov    %rdx,%rsi
  800b6e:	bf 30 00 00 00       	mov    $0x30,%edi
  800b73:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b75:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7d:	48 89 d6             	mov    %rdx,%rsi
  800b80:	bf 78 00 00 00       	mov    $0x78,%edi
  800b85:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8a:	83 f8 30             	cmp    $0x30,%eax
  800b8d:	73 17                	jae    800ba6 <vprintfmt+0x46b>
  800b8f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b96:	89 c0                	mov    %eax,%eax
  800b98:	48 01 d0             	add    %rdx,%rax
  800b9b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b9e:	83 c2 08             	add    $0x8,%edx
  800ba1:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ba4:	eb 0f                	jmp    800bb5 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  800ba6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800baa:	48 89 d0             	mov    %rdx,%rax
  800bad:	48 83 c2 08          	add    $0x8,%rdx
  800bb1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bb5:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bbc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bc3:	eb 23                	jmp    800be8 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bc5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc9:	be 03 00 00 00       	mov    $0x3,%esi
  800bce:	48 89 c7             	mov    %rax,%rdi
  800bd1:	48 b8 1b 05 80 00 00 	movabs $0x80051b,%rax
  800bd8:	00 00 00 
  800bdb:	ff d0                	callq  *%rax
  800bdd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800be1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800bed:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800bf0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800bf3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bf7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bfb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bff:	45 89 c1             	mov    %r8d,%r9d
  800c02:	41 89 f8             	mov    %edi,%r8d
  800c05:	48 89 c7             	mov    %rax,%rdi
  800c08:	48 b8 60 04 80 00 00 	movabs $0x800460,%rax
  800c0f:	00 00 00 
  800c12:	ff d0                	callq  *%rax
			break;
  800c14:	eb 6f                	jmp    800c85 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c16:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1e:	48 89 d6             	mov    %rdx,%rsi
  800c21:	89 df                	mov    %ebx,%edi
  800c23:	ff d0                	callq  *%rax
			break;
  800c25:	eb 5e                	jmp    800c85 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  800c27:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c2b:	be 03 00 00 00       	mov    $0x3,%esi
  800c30:	48 89 c7             	mov    %rax,%rdi
  800c33:	48 b8 1b 05 80 00 00 	movabs $0x80051b,%rax
  800c3a:	00 00 00 
  800c3d:	ff d0                	callq  *%rax
  800c3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  800c43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c47:	89 c2                	mov    %eax,%edx
  800c49:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800c50:	00 00 00 
  800c53:	89 10                	mov    %edx,(%rax)
			break;
  800c55:	eb 2e                	jmp    800c85 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c57:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5f:	48 89 d6             	mov    %rdx,%rsi
  800c62:	bf 25 00 00 00       	mov    $0x25,%edi
  800c67:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c69:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c6e:	eb 05                	jmp    800c75 <vprintfmt+0x53a>
  800c70:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c75:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c79:	48 83 e8 01          	sub    $0x1,%rax
  800c7d:	0f b6 00             	movzbl (%rax),%eax
  800c80:	3c 25                	cmp    $0x25,%al
  800c82:	75 ec                	jne    800c70 <vprintfmt+0x535>
				/* do nothing */;
			break;
  800c84:	90                   	nop
		}
	}
  800c85:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c86:	e9 13 fb ff ff       	jmpq   80079e <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c8b:	48 83 c4 60          	add    $0x60,%rsp
  800c8f:	5b                   	pop    %rbx
  800c90:	41 5c                	pop    %r12
  800c92:	5d                   	pop    %rbp
  800c93:	c3                   	retq   

0000000000800c94 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c94:	55                   	push   %rbp
  800c95:	48 89 e5             	mov    %rsp,%rbp
  800c98:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c9f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ca6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cad:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cb4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cbb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cc2:	84 c0                	test   %al,%al
  800cc4:	74 20                	je     800ce6 <printfmt+0x52>
  800cc6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cca:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cce:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cd2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cd6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cda:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cde:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ce2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ce6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ced:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cf4:	00 00 00 
  800cf7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800cfe:	00 00 00 
  800d01:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d05:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d0c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d13:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d1a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d21:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d28:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d2f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d36:	48 89 c7             	mov    %rax,%rdi
  800d39:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  800d40:	00 00 00 
  800d43:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d45:	c9                   	leaveq 
  800d46:	c3                   	retq   

0000000000800d47 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d47:	55                   	push   %rbp
  800d48:	48 89 e5             	mov    %rsp,%rbp
  800d4b:	48 83 ec 10          	sub    $0x10,%rsp
  800d4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d5a:	8b 40 10             	mov    0x10(%rax),%eax
  800d5d:	8d 50 01             	lea    0x1(%rax),%edx
  800d60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d64:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d6b:	48 8b 10             	mov    (%rax),%rdx
  800d6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d72:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d76:	48 39 c2             	cmp    %rax,%rdx
  800d79:	73 17                	jae    800d92 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d7f:	48 8b 00             	mov    (%rax),%rax
  800d82:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d8a:	48 89 0a             	mov    %rcx,(%rdx)
  800d8d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d90:	88 10                	mov    %dl,(%rax)
}
  800d92:	c9                   	leaveq 
  800d93:	c3                   	retq   

0000000000800d94 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d94:	55                   	push   %rbp
  800d95:	48 89 e5             	mov    %rsp,%rbp
  800d98:	48 83 ec 50          	sub    $0x50,%rsp
  800d9c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800da0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800da3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800da7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800dab:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800daf:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800db3:	48 8b 0a             	mov    (%rdx),%rcx
  800db6:	48 89 08             	mov    %rcx,(%rax)
  800db9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dbd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dc1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dc5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dc9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dcd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800dd1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800dd4:	48 98                	cltq   
  800dd6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800dda:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dde:	48 01 d0             	add    %rdx,%rax
  800de1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800de5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800dec:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800df1:	74 06                	je     800df9 <vsnprintf+0x65>
  800df3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800df7:	7f 07                	jg     800e00 <vsnprintf+0x6c>
		return -E_INVAL;
  800df9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dfe:	eb 2f                	jmp    800e2f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e00:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e04:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e08:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e0c:	48 89 c6             	mov    %rax,%rsi
  800e0f:	48 bf 47 0d 80 00 00 	movabs $0x800d47,%rdi
  800e16:	00 00 00 
  800e19:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  800e20:	00 00 00 
  800e23:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e25:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e29:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e2c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e2f:	c9                   	leaveq 
  800e30:	c3                   	retq   

0000000000800e31 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e31:	55                   	push   %rbp
  800e32:	48 89 e5             	mov    %rsp,%rbp
  800e35:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e3c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e43:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e49:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e50:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e57:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e5e:	84 c0                	test   %al,%al
  800e60:	74 20                	je     800e82 <snprintf+0x51>
  800e62:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e66:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e6a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e6e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e72:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e76:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e7a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e7e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e82:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e89:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e90:	00 00 00 
  800e93:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e9a:	00 00 00 
  800e9d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ea1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ea8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eaf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800eb6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ebd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ec4:	48 8b 0a             	mov    (%rdx),%rcx
  800ec7:	48 89 08             	mov    %rcx,(%rax)
  800eca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ece:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ed2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ed6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800eda:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ee1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ee8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800eee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ef5:	48 89 c7             	mov    %rax,%rdi
  800ef8:	48 b8 94 0d 80 00 00 	movabs $0x800d94,%rax
  800eff:	00 00 00 
  800f02:	ff d0                	callq  *%rax
  800f04:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f0a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f10:	c9                   	leaveq 
  800f11:	c3                   	retq   

0000000000800f12 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f12:	55                   	push   %rbp
  800f13:	48 89 e5             	mov    %rsp,%rbp
  800f16:	48 83 ec 18          	sub    $0x18,%rsp
  800f1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f25:	eb 09                	jmp    800f30 <strlen+0x1e>
		n++;
  800f27:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f2b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f34:	0f b6 00             	movzbl (%rax),%eax
  800f37:	84 c0                	test   %al,%al
  800f39:	75 ec                	jne    800f27 <strlen+0x15>
		n++;
	return n;
  800f3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f3e:	c9                   	leaveq 
  800f3f:	c3                   	retq   

0000000000800f40 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f40:	55                   	push   %rbp
  800f41:	48 89 e5             	mov    %rsp,%rbp
  800f44:	48 83 ec 20          	sub    $0x20,%rsp
  800f48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f57:	eb 0e                	jmp    800f67 <strnlen+0x27>
		n++;
  800f59:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f5d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f62:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f67:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f6c:	74 0b                	je     800f79 <strnlen+0x39>
  800f6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f72:	0f b6 00             	movzbl (%rax),%eax
  800f75:	84 c0                	test   %al,%al
  800f77:	75 e0                	jne    800f59 <strnlen+0x19>
		n++;
	return n;
  800f79:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f7c:	c9                   	leaveq 
  800f7d:	c3                   	retq   

0000000000800f7e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f7e:	55                   	push   %rbp
  800f7f:	48 89 e5             	mov    %rsp,%rbp
  800f82:	48 83 ec 20          	sub    $0x20,%rsp
  800f86:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f8a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f92:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f96:	90                   	nop
  800f97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f9f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fa3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fa7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fab:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800faf:	0f b6 12             	movzbl (%rdx),%edx
  800fb2:	88 10                	mov    %dl,(%rax)
  800fb4:	0f b6 00             	movzbl (%rax),%eax
  800fb7:	84 c0                	test   %al,%al
  800fb9:	75 dc                	jne    800f97 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fbf:	c9                   	leaveq 
  800fc0:	c3                   	retq   

0000000000800fc1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fc1:	55                   	push   %rbp
  800fc2:	48 89 e5             	mov    %rsp,%rbp
  800fc5:	48 83 ec 20          	sub    $0x20,%rsp
  800fc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd5:	48 89 c7             	mov    %rax,%rdi
  800fd8:	48 b8 12 0f 80 00 00 	movabs $0x800f12,%rax
  800fdf:	00 00 00 
  800fe2:	ff d0                	callq  *%rax
  800fe4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fe7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fea:	48 63 d0             	movslq %eax,%rdx
  800fed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff1:	48 01 c2             	add    %rax,%rdx
  800ff4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ff8:	48 89 c6             	mov    %rax,%rsi
  800ffb:	48 89 d7             	mov    %rdx,%rdi
  800ffe:	48 b8 7e 0f 80 00 00 	movabs $0x800f7e,%rax
  801005:	00 00 00 
  801008:	ff d0                	callq  *%rax
	return dst;
  80100a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80100e:	c9                   	leaveq 
  80100f:	c3                   	retq   

0000000000801010 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801010:	55                   	push   %rbp
  801011:	48 89 e5             	mov    %rsp,%rbp
  801014:	48 83 ec 28          	sub    $0x28,%rsp
  801018:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80101c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801020:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801024:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801028:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80102c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801033:	00 
  801034:	eb 2a                	jmp    801060 <strncpy+0x50>
		*dst++ = *src;
  801036:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80103e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801042:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801046:	0f b6 12             	movzbl (%rdx),%edx
  801049:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80104b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80104f:	0f b6 00             	movzbl (%rax),%eax
  801052:	84 c0                	test   %al,%al
  801054:	74 05                	je     80105b <strncpy+0x4b>
			src++;
  801056:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80105b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801060:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801064:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801068:	72 cc                	jb     801036 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80106a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80106e:	c9                   	leaveq 
  80106f:	c3                   	retq   

0000000000801070 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801070:	55                   	push   %rbp
  801071:	48 89 e5             	mov    %rsp,%rbp
  801074:	48 83 ec 28          	sub    $0x28,%rsp
  801078:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80107c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801080:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801084:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801088:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80108c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801091:	74 3d                	je     8010d0 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801093:	eb 1d                	jmp    8010b2 <strlcpy+0x42>
			*dst++ = *src++;
  801095:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801099:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80109d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010a1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010a5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010a9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010ad:	0f b6 12             	movzbl (%rdx),%edx
  8010b0:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010b2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010b7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010bc:	74 0b                	je     8010c9 <strlcpy+0x59>
  8010be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010c2:	0f b6 00             	movzbl (%rax),%eax
  8010c5:	84 c0                	test   %al,%al
  8010c7:	75 cc                	jne    801095 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d8:	48 29 c2             	sub    %rax,%rdx
  8010db:	48 89 d0             	mov    %rdx,%rax
}
  8010de:	c9                   	leaveq 
  8010df:	c3                   	retq   

00000000008010e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010e0:	55                   	push   %rbp
  8010e1:	48 89 e5             	mov    %rsp,%rbp
  8010e4:	48 83 ec 10          	sub    $0x10,%rsp
  8010e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010f0:	eb 0a                	jmp    8010fc <strcmp+0x1c>
		p++, q++;
  8010f2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010f7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801100:	0f b6 00             	movzbl (%rax),%eax
  801103:	84 c0                	test   %al,%al
  801105:	74 12                	je     801119 <strcmp+0x39>
  801107:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110b:	0f b6 10             	movzbl (%rax),%edx
  80110e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801112:	0f b6 00             	movzbl (%rax),%eax
  801115:	38 c2                	cmp    %al,%dl
  801117:	74 d9                	je     8010f2 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801119:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111d:	0f b6 00             	movzbl (%rax),%eax
  801120:	0f b6 d0             	movzbl %al,%edx
  801123:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801127:	0f b6 00             	movzbl (%rax),%eax
  80112a:	0f b6 c0             	movzbl %al,%eax
  80112d:	29 c2                	sub    %eax,%edx
  80112f:	89 d0                	mov    %edx,%eax
}
  801131:	c9                   	leaveq 
  801132:	c3                   	retq   

0000000000801133 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801133:	55                   	push   %rbp
  801134:	48 89 e5             	mov    %rsp,%rbp
  801137:	48 83 ec 18          	sub    $0x18,%rsp
  80113b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80113f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801143:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801147:	eb 0f                	jmp    801158 <strncmp+0x25>
		n--, p++, q++;
  801149:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80114e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801153:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801158:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80115d:	74 1d                	je     80117c <strncmp+0x49>
  80115f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801163:	0f b6 00             	movzbl (%rax),%eax
  801166:	84 c0                	test   %al,%al
  801168:	74 12                	je     80117c <strncmp+0x49>
  80116a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116e:	0f b6 10             	movzbl (%rax),%edx
  801171:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801175:	0f b6 00             	movzbl (%rax),%eax
  801178:	38 c2                	cmp    %al,%dl
  80117a:	74 cd                	je     801149 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80117c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801181:	75 07                	jne    80118a <strncmp+0x57>
		return 0;
  801183:	b8 00 00 00 00       	mov    $0x0,%eax
  801188:	eb 18                	jmp    8011a2 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80118a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118e:	0f b6 00             	movzbl (%rax),%eax
  801191:	0f b6 d0             	movzbl %al,%edx
  801194:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801198:	0f b6 00             	movzbl (%rax),%eax
  80119b:	0f b6 c0             	movzbl %al,%eax
  80119e:	29 c2                	sub    %eax,%edx
  8011a0:	89 d0                	mov    %edx,%eax
}
  8011a2:	c9                   	leaveq 
  8011a3:	c3                   	retq   

00000000008011a4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a4:	55                   	push   %rbp
  8011a5:	48 89 e5             	mov    %rsp,%rbp
  8011a8:	48 83 ec 0c          	sub    $0xc,%rsp
  8011ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b0:	89 f0                	mov    %esi,%eax
  8011b2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011b5:	eb 17                	jmp    8011ce <strchr+0x2a>
		if (*s == c)
  8011b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bb:	0f b6 00             	movzbl (%rax),%eax
  8011be:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011c1:	75 06                	jne    8011c9 <strchr+0x25>
			return (char *) s;
  8011c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c7:	eb 15                	jmp    8011de <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d2:	0f b6 00             	movzbl (%rax),%eax
  8011d5:	84 c0                	test   %al,%al
  8011d7:	75 de                	jne    8011b7 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011de:	c9                   	leaveq 
  8011df:	c3                   	retq   

00000000008011e0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011e0:	55                   	push   %rbp
  8011e1:	48 89 e5             	mov    %rsp,%rbp
  8011e4:	48 83 ec 0c          	sub    $0xc,%rsp
  8011e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ec:	89 f0                	mov    %esi,%eax
  8011ee:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011f1:	eb 13                	jmp    801206 <strfind+0x26>
		if (*s == c)
  8011f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f7:	0f b6 00             	movzbl (%rax),%eax
  8011fa:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011fd:	75 02                	jne    801201 <strfind+0x21>
			break;
  8011ff:	eb 10                	jmp    801211 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801201:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801206:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120a:	0f b6 00             	movzbl (%rax),%eax
  80120d:	84 c0                	test   %al,%al
  80120f:	75 e2                	jne    8011f3 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801211:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801215:	c9                   	leaveq 
  801216:	c3                   	retq   

0000000000801217 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801217:	55                   	push   %rbp
  801218:	48 89 e5             	mov    %rsp,%rbp
  80121b:	48 83 ec 18          	sub    $0x18,%rsp
  80121f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801223:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801226:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80122a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80122f:	75 06                	jne    801237 <memset+0x20>
		return v;
  801231:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801235:	eb 69                	jmp    8012a0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123b:	83 e0 03             	and    $0x3,%eax
  80123e:	48 85 c0             	test   %rax,%rax
  801241:	75 48                	jne    80128b <memset+0x74>
  801243:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801247:	83 e0 03             	and    $0x3,%eax
  80124a:	48 85 c0             	test   %rax,%rax
  80124d:	75 3c                	jne    80128b <memset+0x74>
		c &= 0xFF;
  80124f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801256:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801259:	c1 e0 18             	shl    $0x18,%eax
  80125c:	89 c2                	mov    %eax,%edx
  80125e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801261:	c1 e0 10             	shl    $0x10,%eax
  801264:	09 c2                	or     %eax,%edx
  801266:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801269:	c1 e0 08             	shl    $0x8,%eax
  80126c:	09 d0                	or     %edx,%eax
  80126e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801271:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801275:	48 c1 e8 02          	shr    $0x2,%rax
  801279:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80127c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801280:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801283:	48 89 d7             	mov    %rdx,%rdi
  801286:	fc                   	cld    
  801287:	f3 ab                	rep stos %eax,%es:(%rdi)
  801289:	eb 11                	jmp    80129c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80128b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80128f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801292:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801296:	48 89 d7             	mov    %rdx,%rdi
  801299:	fc                   	cld    
  80129a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80129c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012a0:	c9                   	leaveq 
  8012a1:	c3                   	retq   

00000000008012a2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012a2:	55                   	push   %rbp
  8012a3:	48 89 e5             	mov    %rsp,%rbp
  8012a6:	48 83 ec 28          	sub    $0x28,%rsp
  8012aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ca:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012ce:	0f 83 88 00 00 00    	jae    80135c <memmove+0xba>
  8012d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012dc:	48 01 d0             	add    %rdx,%rax
  8012df:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012e3:	76 77                	jbe    80135c <memmove+0xba>
		s += n;
  8012e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e9:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f1:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f9:	83 e0 03             	and    $0x3,%eax
  8012fc:	48 85 c0             	test   %rax,%rax
  8012ff:	75 3b                	jne    80133c <memmove+0x9a>
  801301:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801305:	83 e0 03             	and    $0x3,%eax
  801308:	48 85 c0             	test   %rax,%rax
  80130b:	75 2f                	jne    80133c <memmove+0x9a>
  80130d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801311:	83 e0 03             	and    $0x3,%eax
  801314:	48 85 c0             	test   %rax,%rax
  801317:	75 23                	jne    80133c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131d:	48 83 e8 04          	sub    $0x4,%rax
  801321:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801325:	48 83 ea 04          	sub    $0x4,%rdx
  801329:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80132d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801331:	48 89 c7             	mov    %rax,%rdi
  801334:	48 89 d6             	mov    %rdx,%rsi
  801337:	fd                   	std    
  801338:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80133a:	eb 1d                	jmp    801359 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80133c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801340:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801344:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801348:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80134c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801350:	48 89 d7             	mov    %rdx,%rdi
  801353:	48 89 c1             	mov    %rax,%rcx
  801356:	fd                   	std    
  801357:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801359:	fc                   	cld    
  80135a:	eb 57                	jmp    8013b3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80135c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801360:	83 e0 03             	and    $0x3,%eax
  801363:	48 85 c0             	test   %rax,%rax
  801366:	75 36                	jne    80139e <memmove+0xfc>
  801368:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136c:	83 e0 03             	and    $0x3,%eax
  80136f:	48 85 c0             	test   %rax,%rax
  801372:	75 2a                	jne    80139e <memmove+0xfc>
  801374:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801378:	83 e0 03             	and    $0x3,%eax
  80137b:	48 85 c0             	test   %rax,%rax
  80137e:	75 1e                	jne    80139e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801380:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801384:	48 c1 e8 02          	shr    $0x2,%rax
  801388:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80138b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801393:	48 89 c7             	mov    %rax,%rdi
  801396:	48 89 d6             	mov    %rdx,%rsi
  801399:	fc                   	cld    
  80139a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80139c:	eb 15                	jmp    8013b3 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80139e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013aa:	48 89 c7             	mov    %rax,%rdi
  8013ad:	48 89 d6             	mov    %rdx,%rsi
  8013b0:	fc                   	cld    
  8013b1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013b7:	c9                   	leaveq 
  8013b8:	c3                   	retq   

00000000008013b9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013b9:	55                   	push   %rbp
  8013ba:	48 89 e5             	mov    %rsp,%rbp
  8013bd:	48 83 ec 18          	sub    $0x18,%rsp
  8013c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013c9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013d1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d9:	48 89 ce             	mov    %rcx,%rsi
  8013dc:	48 89 c7             	mov    %rax,%rdi
  8013df:	48 b8 a2 12 80 00 00 	movabs $0x8012a2,%rax
  8013e6:	00 00 00 
  8013e9:	ff d0                	callq  *%rax
}
  8013eb:	c9                   	leaveq 
  8013ec:	c3                   	retq   

00000000008013ed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013ed:	55                   	push   %rbp
  8013ee:	48 89 e5             	mov    %rsp,%rbp
  8013f1:	48 83 ec 28          	sub    $0x28,%rsp
  8013f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801401:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801405:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801409:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80140d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801411:	eb 36                	jmp    801449 <memcmp+0x5c>
		if (*s1 != *s2)
  801413:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801417:	0f b6 10             	movzbl (%rax),%edx
  80141a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141e:	0f b6 00             	movzbl (%rax),%eax
  801421:	38 c2                	cmp    %al,%dl
  801423:	74 1a                	je     80143f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801429:	0f b6 00             	movzbl (%rax),%eax
  80142c:	0f b6 d0             	movzbl %al,%edx
  80142f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801433:	0f b6 00             	movzbl (%rax),%eax
  801436:	0f b6 c0             	movzbl %al,%eax
  801439:	29 c2                	sub    %eax,%edx
  80143b:	89 d0                	mov    %edx,%eax
  80143d:	eb 20                	jmp    80145f <memcmp+0x72>
		s1++, s2++;
  80143f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801444:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801449:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801451:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801455:	48 85 c0             	test   %rax,%rax
  801458:	75 b9                	jne    801413 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80145a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145f:	c9                   	leaveq 
  801460:	c3                   	retq   

0000000000801461 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801461:	55                   	push   %rbp
  801462:	48 89 e5             	mov    %rsp,%rbp
  801465:	48 83 ec 28          	sub    $0x28,%rsp
  801469:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801470:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801478:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80147c:	48 01 d0             	add    %rdx,%rax
  80147f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801483:	eb 15                	jmp    80149a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801485:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801489:	0f b6 10             	movzbl (%rax),%edx
  80148c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80148f:	38 c2                	cmp    %al,%dl
  801491:	75 02                	jne    801495 <memfind+0x34>
			break;
  801493:	eb 0f                	jmp    8014a4 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801495:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80149a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014a2:	72 e1                	jb     801485 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8014a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014a8:	c9                   	leaveq 
  8014a9:	c3                   	retq   

00000000008014aa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014aa:	55                   	push   %rbp
  8014ab:	48 89 e5             	mov    %rsp,%rbp
  8014ae:	48 83 ec 34          	sub    $0x34,%rsp
  8014b2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014ba:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014c4:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014cb:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014cc:	eb 05                	jmp    8014d3 <strtol+0x29>
		s++;
  8014ce:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d7:	0f b6 00             	movzbl (%rax),%eax
  8014da:	3c 20                	cmp    $0x20,%al
  8014dc:	74 f0                	je     8014ce <strtol+0x24>
  8014de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e2:	0f b6 00             	movzbl (%rax),%eax
  8014e5:	3c 09                	cmp    $0x9,%al
  8014e7:	74 e5                	je     8014ce <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ed:	0f b6 00             	movzbl (%rax),%eax
  8014f0:	3c 2b                	cmp    $0x2b,%al
  8014f2:	75 07                	jne    8014fb <strtol+0x51>
		s++;
  8014f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014f9:	eb 17                	jmp    801512 <strtol+0x68>
	else if (*s == '-')
  8014fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ff:	0f b6 00             	movzbl (%rax),%eax
  801502:	3c 2d                	cmp    $0x2d,%al
  801504:	75 0c                	jne    801512 <strtol+0x68>
		s++, neg = 1;
  801506:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80150b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801512:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801516:	74 06                	je     80151e <strtol+0x74>
  801518:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80151c:	75 28                	jne    801546 <strtol+0x9c>
  80151e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801522:	0f b6 00             	movzbl (%rax),%eax
  801525:	3c 30                	cmp    $0x30,%al
  801527:	75 1d                	jne    801546 <strtol+0x9c>
  801529:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152d:	48 83 c0 01          	add    $0x1,%rax
  801531:	0f b6 00             	movzbl (%rax),%eax
  801534:	3c 78                	cmp    $0x78,%al
  801536:	75 0e                	jne    801546 <strtol+0x9c>
		s += 2, base = 16;
  801538:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80153d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801544:	eb 2c                	jmp    801572 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801546:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80154a:	75 19                	jne    801565 <strtol+0xbb>
  80154c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801550:	0f b6 00             	movzbl (%rax),%eax
  801553:	3c 30                	cmp    $0x30,%al
  801555:	75 0e                	jne    801565 <strtol+0xbb>
		s++, base = 8;
  801557:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80155c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801563:	eb 0d                	jmp    801572 <strtol+0xc8>
	else if (base == 0)
  801565:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801569:	75 07                	jne    801572 <strtol+0xc8>
		base = 10;
  80156b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801572:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801576:	0f b6 00             	movzbl (%rax),%eax
  801579:	3c 2f                	cmp    $0x2f,%al
  80157b:	7e 1d                	jle    80159a <strtol+0xf0>
  80157d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801581:	0f b6 00             	movzbl (%rax),%eax
  801584:	3c 39                	cmp    $0x39,%al
  801586:	7f 12                	jg     80159a <strtol+0xf0>
			dig = *s - '0';
  801588:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158c:	0f b6 00             	movzbl (%rax),%eax
  80158f:	0f be c0             	movsbl %al,%eax
  801592:	83 e8 30             	sub    $0x30,%eax
  801595:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801598:	eb 4e                	jmp    8015e8 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80159a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159e:	0f b6 00             	movzbl (%rax),%eax
  8015a1:	3c 60                	cmp    $0x60,%al
  8015a3:	7e 1d                	jle    8015c2 <strtol+0x118>
  8015a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a9:	0f b6 00             	movzbl (%rax),%eax
  8015ac:	3c 7a                	cmp    $0x7a,%al
  8015ae:	7f 12                	jg     8015c2 <strtol+0x118>
			dig = *s - 'a' + 10;
  8015b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b4:	0f b6 00             	movzbl (%rax),%eax
  8015b7:	0f be c0             	movsbl %al,%eax
  8015ba:	83 e8 57             	sub    $0x57,%eax
  8015bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015c0:	eb 26                	jmp    8015e8 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c6:	0f b6 00             	movzbl (%rax),%eax
  8015c9:	3c 40                	cmp    $0x40,%al
  8015cb:	7e 48                	jle    801615 <strtol+0x16b>
  8015cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d1:	0f b6 00             	movzbl (%rax),%eax
  8015d4:	3c 5a                	cmp    $0x5a,%al
  8015d6:	7f 3d                	jg     801615 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8015d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dc:	0f b6 00             	movzbl (%rax),%eax
  8015df:	0f be c0             	movsbl %al,%eax
  8015e2:	83 e8 37             	sub    $0x37,%eax
  8015e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015eb:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015ee:	7c 02                	jl     8015f2 <strtol+0x148>
			break;
  8015f0:	eb 23                	jmp    801615 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8015f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015fa:	48 98                	cltq   
  8015fc:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801601:	48 89 c2             	mov    %rax,%rdx
  801604:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801607:	48 98                	cltq   
  801609:	48 01 d0             	add    %rdx,%rax
  80160c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801610:	e9 5d ff ff ff       	jmpq   801572 <strtol+0xc8>

	if (endptr)
  801615:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80161a:	74 0b                	je     801627 <strtol+0x17d>
		*endptr = (char *) s;
  80161c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801620:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801624:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801627:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80162b:	74 09                	je     801636 <strtol+0x18c>
  80162d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801631:	48 f7 d8             	neg    %rax
  801634:	eb 04                	jmp    80163a <strtol+0x190>
  801636:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80163a:	c9                   	leaveq 
  80163b:	c3                   	retq   

000000000080163c <strstr>:

char * strstr(const char *in, const char *str)
{
  80163c:	55                   	push   %rbp
  80163d:	48 89 e5             	mov    %rsp,%rbp
  801640:	48 83 ec 30          	sub    $0x30,%rsp
  801644:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801648:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80164c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801650:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801654:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801658:	0f b6 00             	movzbl (%rax),%eax
  80165b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80165e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801662:	75 06                	jne    80166a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801664:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801668:	eb 6b                	jmp    8016d5 <strstr+0x99>

	len = strlen(str);
  80166a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80166e:	48 89 c7             	mov    %rax,%rdi
  801671:	48 b8 12 0f 80 00 00 	movabs $0x800f12,%rax
  801678:	00 00 00 
  80167b:	ff d0                	callq  *%rax
  80167d:	48 98                	cltq   
  80167f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801687:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80168b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80168f:	0f b6 00             	movzbl (%rax),%eax
  801692:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801695:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801699:	75 07                	jne    8016a2 <strstr+0x66>
				return (char *) 0;
  80169b:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a0:	eb 33                	jmp    8016d5 <strstr+0x99>
		} while (sc != c);
  8016a2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016a6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016a9:	75 d8                	jne    801683 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8016ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016af:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b7:	48 89 ce             	mov    %rcx,%rsi
  8016ba:	48 89 c7             	mov    %rax,%rdi
  8016bd:	48 b8 33 11 80 00 00 	movabs $0x801133,%rax
  8016c4:	00 00 00 
  8016c7:	ff d0                	callq  *%rax
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	75 b6                	jne    801683 <strstr+0x47>

	return (char *) (in - 1);
  8016cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d1:	48 83 e8 01          	sub    $0x1,%rax
}
  8016d5:	c9                   	leaveq 
  8016d6:	c3                   	retq   

00000000008016d7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016d7:	55                   	push   %rbp
  8016d8:	48 89 e5             	mov    %rsp,%rbp
  8016db:	53                   	push   %rbx
  8016dc:	48 83 ec 48          	sub    $0x48,%rsp
  8016e0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016e3:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016e6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016ea:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016ee:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016f2:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016f9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016fd:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801701:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801705:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801709:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80170d:	4c 89 c3             	mov    %r8,%rbx
  801710:	cd 30                	int    $0x30
  801712:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801716:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80171a:	74 3e                	je     80175a <syscall+0x83>
  80171c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801721:	7e 37                	jle    80175a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801723:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801727:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80172a:	49 89 d0             	mov    %rdx,%r8
  80172d:	89 c1                	mov    %eax,%ecx
  80172f:	48 ba 08 43 80 00 00 	movabs $0x804308,%rdx
  801736:	00 00 00 
  801739:	be 23 00 00 00       	mov    $0x23,%esi
  80173e:	48 bf 25 43 80 00 00 	movabs $0x804325,%rdi
  801745:	00 00 00 
  801748:	b8 00 00 00 00       	mov    $0x0,%eax
  80174d:	49 b9 11 3a 80 00 00 	movabs $0x803a11,%r9
  801754:	00 00 00 
  801757:	41 ff d1             	callq  *%r9

	return ret;
  80175a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80175e:	48 83 c4 48          	add    $0x48,%rsp
  801762:	5b                   	pop    %rbx
  801763:	5d                   	pop    %rbp
  801764:	c3                   	retq   

0000000000801765 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801765:	55                   	push   %rbp
  801766:	48 89 e5             	mov    %rsp,%rbp
  801769:	48 83 ec 20          	sub    $0x20,%rsp
  80176d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801771:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801775:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801779:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80177d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801784:	00 
  801785:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80178b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801791:	48 89 d1             	mov    %rdx,%rcx
  801794:	48 89 c2             	mov    %rax,%rdx
  801797:	be 00 00 00 00       	mov    $0x0,%esi
  80179c:	bf 00 00 00 00       	mov    $0x0,%edi
  8017a1:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  8017a8:	00 00 00 
  8017ab:	ff d0                	callq  *%rax
}
  8017ad:	c9                   	leaveq 
  8017ae:	c3                   	retq   

00000000008017af <sys_cgetc>:

int
sys_cgetc(void)
{
  8017af:	55                   	push   %rbp
  8017b0:	48 89 e5             	mov    %rsp,%rbp
  8017b3:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017b7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017be:	00 
  8017bf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d5:	be 00 00 00 00       	mov    $0x0,%esi
  8017da:	bf 01 00 00 00       	mov    $0x1,%edi
  8017df:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  8017e6:	00 00 00 
  8017e9:	ff d0                	callq  *%rax
}
  8017eb:	c9                   	leaveq 
  8017ec:	c3                   	retq   

00000000008017ed <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017ed:	55                   	push   %rbp
  8017ee:	48 89 e5             	mov    %rsp,%rbp
  8017f1:	48 83 ec 10          	sub    $0x10,%rsp
  8017f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017fb:	48 98                	cltq   
  8017fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801804:	00 
  801805:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80180b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801811:	b9 00 00 00 00       	mov    $0x0,%ecx
  801816:	48 89 c2             	mov    %rax,%rdx
  801819:	be 01 00 00 00       	mov    $0x1,%esi
  80181e:	bf 03 00 00 00       	mov    $0x3,%edi
  801823:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  80182a:	00 00 00 
  80182d:	ff d0                	callq  *%rax
}
  80182f:	c9                   	leaveq 
  801830:	c3                   	retq   

0000000000801831 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801831:	55                   	push   %rbp
  801832:	48 89 e5             	mov    %rsp,%rbp
  801835:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801839:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801840:	00 
  801841:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801847:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80184d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801852:	ba 00 00 00 00       	mov    $0x0,%edx
  801857:	be 00 00 00 00       	mov    $0x0,%esi
  80185c:	bf 02 00 00 00       	mov    $0x2,%edi
  801861:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  801868:	00 00 00 
  80186b:	ff d0                	callq  *%rax
}
  80186d:	c9                   	leaveq 
  80186e:	c3                   	retq   

000000000080186f <sys_yield>:

void
sys_yield(void)
{
  80186f:	55                   	push   %rbp
  801870:	48 89 e5             	mov    %rsp,%rbp
  801873:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801877:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80187e:	00 
  80187f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801885:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80188b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801890:	ba 00 00 00 00       	mov    $0x0,%edx
  801895:	be 00 00 00 00       	mov    $0x0,%esi
  80189a:	bf 0b 00 00 00       	mov    $0xb,%edi
  80189f:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  8018a6:	00 00 00 
  8018a9:	ff d0                	callq  *%rax
}
  8018ab:	c9                   	leaveq 
  8018ac:	c3                   	retq   

00000000008018ad <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018ad:	55                   	push   %rbp
  8018ae:	48 89 e5             	mov    %rsp,%rbp
  8018b1:	48 83 ec 20          	sub    $0x20,%rsp
  8018b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018bc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018c2:	48 63 c8             	movslq %eax,%rcx
  8018c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018cc:	48 98                	cltq   
  8018ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d5:	00 
  8018d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018dc:	49 89 c8             	mov    %rcx,%r8
  8018df:	48 89 d1             	mov    %rdx,%rcx
  8018e2:	48 89 c2             	mov    %rax,%rdx
  8018e5:	be 01 00 00 00       	mov    $0x1,%esi
  8018ea:	bf 04 00 00 00       	mov    $0x4,%edi
  8018ef:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  8018f6:	00 00 00 
  8018f9:	ff d0                	callq  *%rax
}
  8018fb:	c9                   	leaveq 
  8018fc:	c3                   	retq   

00000000008018fd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018fd:	55                   	push   %rbp
  8018fe:	48 89 e5             	mov    %rsp,%rbp
  801901:	48 83 ec 30          	sub    $0x30,%rsp
  801905:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801908:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80190c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80190f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801913:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801917:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80191a:	48 63 c8             	movslq %eax,%rcx
  80191d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801921:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801924:	48 63 f0             	movslq %eax,%rsi
  801927:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80192b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192e:	48 98                	cltq   
  801930:	48 89 0c 24          	mov    %rcx,(%rsp)
  801934:	49 89 f9             	mov    %rdi,%r9
  801937:	49 89 f0             	mov    %rsi,%r8
  80193a:	48 89 d1             	mov    %rdx,%rcx
  80193d:	48 89 c2             	mov    %rax,%rdx
  801940:	be 01 00 00 00       	mov    $0x1,%esi
  801945:	bf 05 00 00 00       	mov    $0x5,%edi
  80194a:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  801951:	00 00 00 
  801954:	ff d0                	callq  *%rax
}
  801956:	c9                   	leaveq 
  801957:	c3                   	retq   

0000000000801958 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801958:	55                   	push   %rbp
  801959:	48 89 e5             	mov    %rsp,%rbp
  80195c:	48 83 ec 20          	sub    $0x20,%rsp
  801960:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801963:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801967:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196e:	48 98                	cltq   
  801970:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801977:	00 
  801978:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801984:	48 89 d1             	mov    %rdx,%rcx
  801987:	48 89 c2             	mov    %rax,%rdx
  80198a:	be 01 00 00 00       	mov    $0x1,%esi
  80198f:	bf 06 00 00 00       	mov    $0x6,%edi
  801994:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  80199b:	00 00 00 
  80199e:	ff d0                	callq  *%rax
}
  8019a0:	c9                   	leaveq 
  8019a1:	c3                   	retq   

00000000008019a2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019a2:	55                   	push   %rbp
  8019a3:	48 89 e5             	mov    %rsp,%rbp
  8019a6:	48 83 ec 10          	sub    $0x10,%rsp
  8019aa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ad:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019b3:	48 63 d0             	movslq %eax,%rdx
  8019b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b9:	48 98                	cltq   
  8019bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c2:	00 
  8019c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019cf:	48 89 d1             	mov    %rdx,%rcx
  8019d2:	48 89 c2             	mov    %rax,%rdx
  8019d5:	be 01 00 00 00       	mov    $0x1,%esi
  8019da:	bf 08 00 00 00       	mov    $0x8,%edi
  8019df:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  8019e6:	00 00 00 
  8019e9:	ff d0                	callq  *%rax
}
  8019eb:	c9                   	leaveq 
  8019ec:	c3                   	retq   

00000000008019ed <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019ed:	55                   	push   %rbp
  8019ee:	48 89 e5             	mov    %rsp,%rbp
  8019f1:	48 83 ec 20          	sub    $0x20,%rsp
  8019f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a03:	48 98                	cltq   
  801a05:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a0c:	00 
  801a0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a13:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a19:	48 89 d1             	mov    %rdx,%rcx
  801a1c:	48 89 c2             	mov    %rax,%rdx
  801a1f:	be 01 00 00 00       	mov    $0x1,%esi
  801a24:	bf 09 00 00 00       	mov    $0x9,%edi
  801a29:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  801a30:	00 00 00 
  801a33:	ff d0                	callq  *%rax
}
  801a35:	c9                   	leaveq 
  801a36:	c3                   	retq   

0000000000801a37 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a37:	55                   	push   %rbp
  801a38:	48 89 e5             	mov    %rsp,%rbp
  801a3b:	48 83 ec 20          	sub    $0x20,%rsp
  801a3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4d:	48 98                	cltq   
  801a4f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a56:	00 
  801a57:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a63:	48 89 d1             	mov    %rdx,%rcx
  801a66:	48 89 c2             	mov    %rax,%rdx
  801a69:	be 01 00 00 00       	mov    $0x1,%esi
  801a6e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a73:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  801a7a:	00 00 00 
  801a7d:	ff d0                	callq  *%rax
}
  801a7f:	c9                   	leaveq 
  801a80:	c3                   	retq   

0000000000801a81 <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801a81:	55                   	push   %rbp
  801a82:	48 89 e5             	mov    %rsp,%rbp
  801a85:	48 83 ec 10          	sub    $0x10,%rsp
  801a89:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a8c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801a8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a92:	48 63 d0             	movslq %eax,%rdx
  801a95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a98:	48 98                	cltq   
  801a9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa1:	00 
  801aa2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aae:	48 89 d1             	mov    %rdx,%rcx
  801ab1:	48 89 c2             	mov    %rax,%rdx
  801ab4:	be 01 00 00 00       	mov    $0x1,%esi
  801ab9:	bf 11 00 00 00       	mov    $0x11,%edi
  801abe:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  801ac5:	00 00 00 
  801ac8:	ff d0                	callq  *%rax

}
  801aca:	c9                   	leaveq 
  801acb:	c3                   	retq   

0000000000801acc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801acc:	55                   	push   %rbp
  801acd:	48 89 e5             	mov    %rsp,%rbp
  801ad0:	48 83 ec 20          	sub    $0x20,%rsp
  801ad4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801adb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801adf:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ae2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ae5:	48 63 f0             	movslq %eax,%rsi
  801ae8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801aec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aef:	48 98                	cltq   
  801af1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801afc:	00 
  801afd:	49 89 f1             	mov    %rsi,%r9
  801b00:	49 89 c8             	mov    %rcx,%r8
  801b03:	48 89 d1             	mov    %rdx,%rcx
  801b06:	48 89 c2             	mov    %rax,%rdx
  801b09:	be 00 00 00 00       	mov    $0x0,%esi
  801b0e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b13:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  801b1a:	00 00 00 
  801b1d:	ff d0                	callq  *%rax
}
  801b1f:	c9                   	leaveq 
  801b20:	c3                   	retq   

0000000000801b21 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b21:	55                   	push   %rbp
  801b22:	48 89 e5             	mov    %rsp,%rbp
  801b25:	48 83 ec 10          	sub    $0x10,%rsp
  801b29:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b38:	00 
  801b39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b45:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b4a:	48 89 c2             	mov    %rax,%rdx
  801b4d:	be 01 00 00 00       	mov    $0x1,%esi
  801b52:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b57:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  801b5e:	00 00 00 
  801b61:	ff d0                	callq  *%rax
}
  801b63:	c9                   	leaveq 
  801b64:	c3                   	retq   

0000000000801b65 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801b65:	55                   	push   %rbp
  801b66:	48 89 e5             	mov    %rsp,%rbp
  801b69:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b6d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b74:	00 
  801b75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b81:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b86:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8b:	be 00 00 00 00       	mov    $0x0,%esi
  801b90:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b95:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  801b9c:	00 00 00 
  801b9f:	ff d0                	callq  *%rax
}
  801ba1:	c9                   	leaveq 
  801ba2:	c3                   	retq   

0000000000801ba3 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801ba3:	55                   	push   %rbp
  801ba4:	48 89 e5             	mov    %rsp,%rbp
  801ba7:	48 83 ec 30          	sub    $0x30,%rsp
  801bab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bb2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bb5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bb9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801bbd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bc0:	48 63 c8             	movslq %eax,%rcx
  801bc3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bc7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bca:	48 63 f0             	movslq %eax,%rsi
  801bcd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd4:	48 98                	cltq   
  801bd6:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bda:	49 89 f9             	mov    %rdi,%r9
  801bdd:	49 89 f0             	mov    %rsi,%r8
  801be0:	48 89 d1             	mov    %rdx,%rcx
  801be3:	48 89 c2             	mov    %rax,%rdx
  801be6:	be 00 00 00 00       	mov    $0x0,%esi
  801beb:	bf 0f 00 00 00       	mov    $0xf,%edi
  801bf0:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  801bf7:	00 00 00 
  801bfa:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801bfc:	c9                   	leaveq 
  801bfd:	c3                   	retq   

0000000000801bfe <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801bfe:	55                   	push   %rbp
  801bff:	48 89 e5             	mov    %rsp,%rbp
  801c02:	48 83 ec 20          	sub    $0x20,%rsp
  801c06:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c0a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801c0e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c16:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1d:	00 
  801c1e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c24:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2a:	48 89 d1             	mov    %rdx,%rcx
  801c2d:	48 89 c2             	mov    %rax,%rdx
  801c30:	be 00 00 00 00       	mov    $0x0,%esi
  801c35:	bf 10 00 00 00       	mov    $0x10,%edi
  801c3a:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  801c41:	00 00 00 
  801c44:	ff d0                	callq  *%rax
}
  801c46:	c9                   	leaveq 
  801c47:	c3                   	retq   

0000000000801c48 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801c48:	55                   	push   %rbp
  801c49:	48 89 e5             	mov    %rsp,%rbp
  801c4c:	48 83 ec 18          	sub    $0x18,%rsp
  801c50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c54:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c58:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801c5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c60:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c64:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801c67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c6f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801c73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c77:	8b 00                	mov    (%rax),%eax
  801c79:	83 f8 01             	cmp    $0x1,%eax
  801c7c:	7e 13                	jle    801c91 <argstart+0x49>
  801c7e:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801c83:	74 0c                	je     801c91 <argstart+0x49>
  801c85:	48 b8 33 43 80 00 00 	movabs $0x804333,%rax
  801c8c:	00 00 00 
  801c8f:	eb 05                	jmp    801c96 <argstart+0x4e>
  801c91:	b8 00 00 00 00       	mov    $0x0,%eax
  801c96:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c9a:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801c9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ca2:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801ca9:	00 
}
  801caa:	c9                   	leaveq 
  801cab:	c3                   	retq   

0000000000801cac <argnext>:

int
argnext(struct Argstate *args)
{
  801cac:	55                   	push   %rbp
  801cad:	48 89 e5             	mov    %rsp,%rbp
  801cb0:	48 83 ec 20          	sub    $0x20,%rsp
  801cb4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801cb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cbc:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801cc3:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801cc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc8:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ccc:	48 85 c0             	test   %rax,%rax
  801ccf:	75 0a                	jne    801cdb <argnext+0x2f>
		return -1;
  801cd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801cd6:	e9 25 01 00 00       	jmpq   801e00 <argnext+0x154>

	if (!*args->curarg) {
  801cdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cdf:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ce3:	0f b6 00             	movzbl (%rax),%eax
  801ce6:	84 c0                	test   %al,%al
  801ce8:	0f 85 d7 00 00 00    	jne    801dc5 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801cee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cf2:	48 8b 00             	mov    (%rax),%rax
  801cf5:	8b 00                	mov    (%rax),%eax
  801cf7:	83 f8 01             	cmp    $0x1,%eax
  801cfa:	0f 84 ef 00 00 00    	je     801def <argnext+0x143>
		    || args->argv[1][0] != '-'
  801d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d04:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d08:	48 83 c0 08          	add    $0x8,%rax
  801d0c:	48 8b 00             	mov    (%rax),%rax
  801d0f:	0f b6 00             	movzbl (%rax),%eax
  801d12:	3c 2d                	cmp    $0x2d,%al
  801d14:	0f 85 d5 00 00 00    	jne    801def <argnext+0x143>
		    || args->argv[1][1] == '\0')
  801d1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d1e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d22:	48 83 c0 08          	add    $0x8,%rax
  801d26:	48 8b 00             	mov    (%rax),%rax
  801d29:	48 83 c0 01          	add    $0x1,%rax
  801d2d:	0f b6 00             	movzbl (%rax),%eax
  801d30:	84 c0                	test   %al,%al
  801d32:	0f 84 b7 00 00 00    	je     801def <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801d38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3c:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d40:	48 83 c0 08          	add    $0x8,%rax
  801d44:	48 8b 00             	mov    (%rax),%rax
  801d47:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801d4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d4f:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801d53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d57:	48 8b 00             	mov    (%rax),%rax
  801d5a:	8b 00                	mov    (%rax),%eax
  801d5c:	83 e8 01             	sub    $0x1,%eax
  801d5f:	48 98                	cltq   
  801d61:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801d68:	00 
  801d69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d6d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d71:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801d75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d79:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d7d:	48 83 c0 08          	add    $0x8,%rax
  801d81:	48 89 ce             	mov    %rcx,%rsi
  801d84:	48 89 c7             	mov    %rax,%rdi
  801d87:	48 b8 a2 12 80 00 00 	movabs $0x8012a2,%rax
  801d8e:	00 00 00 
  801d91:	ff d0                	callq  *%rax
		(*args->argc)--;
  801d93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d97:	48 8b 00             	mov    (%rax),%rax
  801d9a:	8b 10                	mov    (%rax),%edx
  801d9c:	83 ea 01             	sub    $0x1,%edx
  801d9f:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801da1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801da5:	48 8b 40 10          	mov    0x10(%rax),%rax
  801da9:	0f b6 00             	movzbl (%rax),%eax
  801dac:	3c 2d                	cmp    $0x2d,%al
  801dae:	75 15                	jne    801dc5 <argnext+0x119>
  801db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db4:	48 8b 40 10          	mov    0x10(%rax),%rax
  801db8:	48 83 c0 01          	add    $0x1,%rax
  801dbc:	0f b6 00             	movzbl (%rax),%eax
  801dbf:	84 c0                	test   %al,%al
  801dc1:	75 02                	jne    801dc5 <argnext+0x119>
			goto endofargs;
  801dc3:	eb 2a                	jmp    801def <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  801dc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc9:	48 8b 40 10          	mov    0x10(%rax),%rax
  801dcd:	0f b6 00             	movzbl (%rax),%eax
  801dd0:	0f b6 c0             	movzbl %al,%eax
  801dd3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  801dd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dda:	48 8b 40 10          	mov    0x10(%rax),%rax
  801dde:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801de2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  801dea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ded:	eb 11                	jmp    801e00 <argnext+0x154>

endofargs:
	args->curarg = 0;
  801def:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df3:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801dfa:	00 
	return -1;
  801dfb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801e00:	c9                   	leaveq 
  801e01:	c3                   	retq   

0000000000801e02 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  801e02:	55                   	push   %rbp
  801e03:	48 89 e5             	mov    %rsp,%rbp
  801e06:	48 83 ec 10          	sub    $0x10,%rsp
  801e0a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801e0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e12:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e16:	48 85 c0             	test   %rax,%rax
  801e19:	74 0a                	je     801e25 <argvalue+0x23>
  801e1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1f:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e23:	eb 13                	jmp    801e38 <argvalue+0x36>
  801e25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e29:	48 89 c7             	mov    %rax,%rdi
  801e2c:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  801e33:	00 00 00 
  801e36:	ff d0                	callq  *%rax
}
  801e38:	c9                   	leaveq 
  801e39:	c3                   	retq   

0000000000801e3a <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  801e3a:	55                   	push   %rbp
  801e3b:	48 89 e5             	mov    %rsp,%rbp
  801e3e:	53                   	push   %rbx
  801e3f:	48 83 ec 18          	sub    $0x18,%rsp
  801e43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  801e47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e4b:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e4f:	48 85 c0             	test   %rax,%rax
  801e52:	75 0a                	jne    801e5e <argnextvalue+0x24>
		return 0;
  801e54:	b8 00 00 00 00       	mov    $0x0,%eax
  801e59:	e9 c8 00 00 00       	jmpq   801f26 <argnextvalue+0xec>
	if (*args->curarg) {
  801e5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e62:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e66:	0f b6 00             	movzbl (%rax),%eax
  801e69:	84 c0                	test   %al,%al
  801e6b:	74 27                	je     801e94 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  801e6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e71:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801e75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e79:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  801e7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e81:	48 bb 33 43 80 00 00 	movabs $0x804333,%rbx
  801e88:	00 00 00 
  801e8b:	48 89 58 10          	mov    %rbx,0x10(%rax)
  801e8f:	e9 8a 00 00 00       	jmpq   801f1e <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  801e94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e98:	48 8b 00             	mov    (%rax),%rax
  801e9b:	8b 00                	mov    (%rax),%eax
  801e9d:	83 f8 01             	cmp    $0x1,%eax
  801ea0:	7e 64                	jle    801f06 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  801ea2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea6:	48 8b 40 08          	mov    0x8(%rax),%rax
  801eaa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801eae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eb2:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801eb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eba:	48 8b 00             	mov    (%rax),%rax
  801ebd:	8b 00                	mov    (%rax),%eax
  801ebf:	83 e8 01             	sub    $0x1,%eax
  801ec2:	48 98                	cltq   
  801ec4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801ecb:	00 
  801ecc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed0:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ed4:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801edc:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ee0:	48 83 c0 08          	add    $0x8,%rax
  801ee4:	48 89 ce             	mov    %rcx,%rsi
  801ee7:	48 89 c7             	mov    %rax,%rdi
  801eea:	48 b8 a2 12 80 00 00 	movabs $0x8012a2,%rax
  801ef1:	00 00 00 
  801ef4:	ff d0                	callq  *%rax
		(*args->argc)--;
  801ef6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801efa:	48 8b 00             	mov    (%rax),%rax
  801efd:	8b 10                	mov    (%rax),%edx
  801eff:	83 ea 01             	sub    $0x1,%edx
  801f02:	89 10                	mov    %edx,(%rax)
  801f04:	eb 18                	jmp    801f1e <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  801f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f0a:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801f11:	00 
		args->curarg = 0;
  801f12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f16:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801f1d:	00 
	}
	return (char*) args->argvalue;
  801f1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f22:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  801f26:	48 83 c4 18          	add    $0x18,%rsp
  801f2a:	5b                   	pop    %rbx
  801f2b:	5d                   	pop    %rbp
  801f2c:	c3                   	retq   

0000000000801f2d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801f2d:	55                   	push   %rbp
  801f2e:	48 89 e5             	mov    %rsp,%rbp
  801f31:	48 83 ec 08          	sub    $0x8,%rsp
  801f35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f39:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f3d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801f44:	ff ff ff 
  801f47:	48 01 d0             	add    %rdx,%rax
  801f4a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801f4e:	c9                   	leaveq 
  801f4f:	c3                   	retq   

0000000000801f50 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f50:	55                   	push   %rbp
  801f51:	48 89 e5             	mov    %rsp,%rbp
  801f54:	48 83 ec 08          	sub    $0x8,%rsp
  801f58:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801f5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f60:	48 89 c7             	mov    %rax,%rdi
  801f63:	48 b8 2d 1f 80 00 00 	movabs $0x801f2d,%rax
  801f6a:	00 00 00 
  801f6d:	ff d0                	callq  *%rax
  801f6f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801f75:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801f79:	c9                   	leaveq 
  801f7a:	c3                   	retq   

0000000000801f7b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f7b:	55                   	push   %rbp
  801f7c:	48 89 e5             	mov    %rsp,%rbp
  801f7f:	48 83 ec 18          	sub    $0x18,%rsp
  801f83:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f8e:	eb 6b                	jmp    801ffb <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f93:	48 98                	cltq   
  801f95:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f9b:	48 c1 e0 0c          	shl    $0xc,%rax
  801f9f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801fa3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa7:	48 c1 e8 15          	shr    $0x15,%rax
  801fab:	48 89 c2             	mov    %rax,%rdx
  801fae:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fb5:	01 00 00 
  801fb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fbc:	83 e0 01             	and    $0x1,%eax
  801fbf:	48 85 c0             	test   %rax,%rax
  801fc2:	74 21                	je     801fe5 <fd_alloc+0x6a>
  801fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc8:	48 c1 e8 0c          	shr    $0xc,%rax
  801fcc:	48 89 c2             	mov    %rax,%rdx
  801fcf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fd6:	01 00 00 
  801fd9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fdd:	83 e0 01             	and    $0x1,%eax
  801fe0:	48 85 c0             	test   %rax,%rax
  801fe3:	75 12                	jne    801ff7 <fd_alloc+0x7c>
			*fd_store = fd;
  801fe5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fe9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fed:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff5:	eb 1a                	jmp    802011 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ff7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ffb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fff:	7e 8f                	jle    801f90 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802001:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802005:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80200c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802011:	c9                   	leaveq 
  802012:	c3                   	retq   

0000000000802013 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802013:	55                   	push   %rbp
  802014:	48 89 e5             	mov    %rsp,%rbp
  802017:	48 83 ec 20          	sub    $0x20,%rsp
  80201b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80201e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802022:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802026:	78 06                	js     80202e <fd_lookup+0x1b>
  802028:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80202c:	7e 07                	jle    802035 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80202e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802033:	eb 6c                	jmp    8020a1 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802035:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802038:	48 98                	cltq   
  80203a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802040:	48 c1 e0 0c          	shl    $0xc,%rax
  802044:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80204c:	48 c1 e8 15          	shr    $0x15,%rax
  802050:	48 89 c2             	mov    %rax,%rdx
  802053:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80205a:	01 00 00 
  80205d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802061:	83 e0 01             	and    $0x1,%eax
  802064:	48 85 c0             	test   %rax,%rax
  802067:	74 21                	je     80208a <fd_lookup+0x77>
  802069:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80206d:	48 c1 e8 0c          	shr    $0xc,%rax
  802071:	48 89 c2             	mov    %rax,%rdx
  802074:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80207b:	01 00 00 
  80207e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802082:	83 e0 01             	and    $0x1,%eax
  802085:	48 85 c0             	test   %rax,%rax
  802088:	75 07                	jne    802091 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80208a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80208f:	eb 10                	jmp    8020a1 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802091:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802095:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802099:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80209c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a1:	c9                   	leaveq 
  8020a2:	c3                   	retq   

00000000008020a3 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8020a3:	55                   	push   %rbp
  8020a4:	48 89 e5             	mov    %rsp,%rbp
  8020a7:	48 83 ec 30          	sub    $0x30,%rsp
  8020ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8020af:	89 f0                	mov    %esi,%eax
  8020b1:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8020b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b8:	48 89 c7             	mov    %rax,%rdi
  8020bb:	48 b8 2d 1f 80 00 00 	movabs $0x801f2d,%rax
  8020c2:	00 00 00 
  8020c5:	ff d0                	callq  *%rax
  8020c7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020cb:	48 89 d6             	mov    %rdx,%rsi
  8020ce:	89 c7                	mov    %eax,%edi
  8020d0:	48 b8 13 20 80 00 00 	movabs $0x802013,%rax
  8020d7:	00 00 00 
  8020da:	ff d0                	callq  *%rax
  8020dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e3:	78 0a                	js     8020ef <fd_close+0x4c>
	    || fd != fd2)
  8020e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8020ed:	74 12                	je     802101 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8020ef:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8020f3:	74 05                	je     8020fa <fd_close+0x57>
  8020f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f8:	eb 05                	jmp    8020ff <fd_close+0x5c>
  8020fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ff:	eb 69                	jmp    80216a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802101:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802105:	8b 00                	mov    (%rax),%eax
  802107:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80210b:	48 89 d6             	mov    %rdx,%rsi
  80210e:	89 c7                	mov    %eax,%edi
  802110:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  802117:	00 00 00 
  80211a:	ff d0                	callq  *%rax
  80211c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80211f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802123:	78 2a                	js     80214f <fd_close+0xac>
		if (dev->dev_close)
  802125:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802129:	48 8b 40 20          	mov    0x20(%rax),%rax
  80212d:	48 85 c0             	test   %rax,%rax
  802130:	74 16                	je     802148 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802136:	48 8b 40 20          	mov    0x20(%rax),%rax
  80213a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80213e:	48 89 d7             	mov    %rdx,%rdi
  802141:	ff d0                	callq  *%rax
  802143:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802146:	eb 07                	jmp    80214f <fd_close+0xac>
		else
			r = 0;
  802148:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80214f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802153:	48 89 c6             	mov    %rax,%rsi
  802156:	bf 00 00 00 00       	mov    $0x0,%edi
  80215b:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  802162:	00 00 00 
  802165:	ff d0                	callq  *%rax
	return r;
  802167:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80216a:	c9                   	leaveq 
  80216b:	c3                   	retq   

000000000080216c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80216c:	55                   	push   %rbp
  80216d:	48 89 e5             	mov    %rsp,%rbp
  802170:	48 83 ec 20          	sub    $0x20,%rsp
  802174:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802177:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80217b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802182:	eb 41                	jmp    8021c5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802184:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80218b:	00 00 00 
  80218e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802191:	48 63 d2             	movslq %edx,%rdx
  802194:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802198:	8b 00                	mov    (%rax),%eax
  80219a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80219d:	75 22                	jne    8021c1 <dev_lookup+0x55>
			*dev = devtab[i];
  80219f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8021a6:	00 00 00 
  8021a9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021ac:	48 63 d2             	movslq %edx,%rdx
  8021af:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8021b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021b7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8021ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bf:	eb 60                	jmp    802221 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8021c1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021c5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8021cc:	00 00 00 
  8021cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021d2:	48 63 d2             	movslq %edx,%rdx
  8021d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d9:	48 85 c0             	test   %rax,%rax
  8021dc:	75 a6                	jne    802184 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8021de:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021e5:	00 00 00 
  8021e8:	48 8b 00             	mov    (%rax),%rax
  8021eb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021f1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021f4:	89 c6                	mov    %eax,%esi
  8021f6:	48 bf 38 43 80 00 00 	movabs $0x804338,%rdi
  8021fd:	00 00 00 
  802200:	b8 00 00 00 00       	mov    $0x0,%eax
  802205:	48 b9 88 03 80 00 00 	movabs $0x800388,%rcx
  80220c:	00 00 00 
  80220f:	ff d1                	callq  *%rcx
	*dev = 0;
  802211:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802215:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80221c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802221:	c9                   	leaveq 
  802222:	c3                   	retq   

0000000000802223 <close>:

int
close(int fdnum)
{
  802223:	55                   	push   %rbp
  802224:	48 89 e5             	mov    %rsp,%rbp
  802227:	48 83 ec 20          	sub    $0x20,%rsp
  80222b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80222e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802232:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802235:	48 89 d6             	mov    %rdx,%rsi
  802238:	89 c7                	mov    %eax,%edi
  80223a:	48 b8 13 20 80 00 00 	movabs $0x802013,%rax
  802241:	00 00 00 
  802244:	ff d0                	callq  *%rax
  802246:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802249:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80224d:	79 05                	jns    802254 <close+0x31>
		return r;
  80224f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802252:	eb 18                	jmp    80226c <close+0x49>
	else
		return fd_close(fd, 1);
  802254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802258:	be 01 00 00 00       	mov    $0x1,%esi
  80225d:	48 89 c7             	mov    %rax,%rdi
  802260:	48 b8 a3 20 80 00 00 	movabs $0x8020a3,%rax
  802267:	00 00 00 
  80226a:	ff d0                	callq  *%rax
}
  80226c:	c9                   	leaveq 
  80226d:	c3                   	retq   

000000000080226e <close_all>:

void
close_all(void)
{
  80226e:	55                   	push   %rbp
  80226f:	48 89 e5             	mov    %rsp,%rbp
  802272:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802276:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80227d:	eb 15                	jmp    802294 <close_all+0x26>
		close(i);
  80227f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802282:	89 c7                	mov    %eax,%edi
  802284:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  80228b:	00 00 00 
  80228e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802290:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802294:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802298:	7e e5                	jle    80227f <close_all+0x11>
		close(i);
}
  80229a:	c9                   	leaveq 
  80229b:	c3                   	retq   

000000000080229c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80229c:	55                   	push   %rbp
  80229d:	48 89 e5             	mov    %rsp,%rbp
  8022a0:	48 83 ec 40          	sub    $0x40,%rsp
  8022a4:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8022a7:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8022aa:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8022ae:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8022b1:	48 89 d6             	mov    %rdx,%rsi
  8022b4:	89 c7                	mov    %eax,%edi
  8022b6:	48 b8 13 20 80 00 00 	movabs $0x802013,%rax
  8022bd:	00 00 00 
  8022c0:	ff d0                	callq  *%rax
  8022c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c9:	79 08                	jns    8022d3 <dup+0x37>
		return r;
  8022cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ce:	e9 70 01 00 00       	jmpq   802443 <dup+0x1a7>
	close(newfdnum);
  8022d3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022d6:	89 c7                	mov    %eax,%edi
  8022d8:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8022df:	00 00 00 
  8022e2:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8022e4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022e7:	48 98                	cltq   
  8022e9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022ef:	48 c1 e0 0c          	shl    $0xc,%rax
  8022f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8022f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022fb:	48 89 c7             	mov    %rax,%rdi
  8022fe:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  802305:	00 00 00 
  802308:	ff d0                	callq  *%rax
  80230a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80230e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802312:	48 89 c7             	mov    %rax,%rdi
  802315:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  80231c:	00 00 00 
  80231f:	ff d0                	callq  *%rax
  802321:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802325:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802329:	48 c1 e8 15          	shr    $0x15,%rax
  80232d:	48 89 c2             	mov    %rax,%rdx
  802330:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802337:	01 00 00 
  80233a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80233e:	83 e0 01             	and    $0x1,%eax
  802341:	48 85 c0             	test   %rax,%rax
  802344:	74 73                	je     8023b9 <dup+0x11d>
  802346:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234a:	48 c1 e8 0c          	shr    $0xc,%rax
  80234e:	48 89 c2             	mov    %rax,%rdx
  802351:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802358:	01 00 00 
  80235b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80235f:	83 e0 01             	and    $0x1,%eax
  802362:	48 85 c0             	test   %rax,%rax
  802365:	74 52                	je     8023b9 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236b:	48 c1 e8 0c          	shr    $0xc,%rax
  80236f:	48 89 c2             	mov    %rax,%rdx
  802372:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802379:	01 00 00 
  80237c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802380:	25 07 0e 00 00       	and    $0xe07,%eax
  802385:	89 c1                	mov    %eax,%ecx
  802387:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80238b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238f:	41 89 c8             	mov    %ecx,%r8d
  802392:	48 89 d1             	mov    %rdx,%rcx
  802395:	ba 00 00 00 00       	mov    $0x0,%edx
  80239a:	48 89 c6             	mov    %rax,%rsi
  80239d:	bf 00 00 00 00       	mov    $0x0,%edi
  8023a2:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  8023a9:	00 00 00 
  8023ac:	ff d0                	callq  *%rax
  8023ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b5:	79 02                	jns    8023b9 <dup+0x11d>
			goto err;
  8023b7:	eb 57                	jmp    802410 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8023b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023bd:	48 c1 e8 0c          	shr    $0xc,%rax
  8023c1:	48 89 c2             	mov    %rax,%rdx
  8023c4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023cb:	01 00 00 
  8023ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023d2:	25 07 0e 00 00       	and    $0xe07,%eax
  8023d7:	89 c1                	mov    %eax,%ecx
  8023d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023e1:	41 89 c8             	mov    %ecx,%r8d
  8023e4:	48 89 d1             	mov    %rdx,%rcx
  8023e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ec:	48 89 c6             	mov    %rax,%rsi
  8023ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f4:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  8023fb:	00 00 00 
  8023fe:	ff d0                	callq  *%rax
  802400:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802403:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802407:	79 02                	jns    80240b <dup+0x16f>
		goto err;
  802409:	eb 05                	jmp    802410 <dup+0x174>

	return newfdnum;
  80240b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80240e:	eb 33                	jmp    802443 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802410:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802414:	48 89 c6             	mov    %rax,%rsi
  802417:	bf 00 00 00 00       	mov    $0x0,%edi
  80241c:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  802423:	00 00 00 
  802426:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802428:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80242c:	48 89 c6             	mov    %rax,%rsi
  80242f:	bf 00 00 00 00       	mov    $0x0,%edi
  802434:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  80243b:	00 00 00 
  80243e:	ff d0                	callq  *%rax
	return r;
  802440:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802443:	c9                   	leaveq 
  802444:	c3                   	retq   

0000000000802445 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802445:	55                   	push   %rbp
  802446:	48 89 e5             	mov    %rsp,%rbp
  802449:	48 83 ec 40          	sub    $0x40,%rsp
  80244d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802450:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802454:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802458:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80245c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80245f:	48 89 d6             	mov    %rdx,%rsi
  802462:	89 c7                	mov    %eax,%edi
  802464:	48 b8 13 20 80 00 00 	movabs $0x802013,%rax
  80246b:	00 00 00 
  80246e:	ff d0                	callq  *%rax
  802470:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802473:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802477:	78 24                	js     80249d <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802479:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80247d:	8b 00                	mov    (%rax),%eax
  80247f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802483:	48 89 d6             	mov    %rdx,%rsi
  802486:	89 c7                	mov    %eax,%edi
  802488:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  80248f:	00 00 00 
  802492:	ff d0                	callq  *%rax
  802494:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802497:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80249b:	79 05                	jns    8024a2 <read+0x5d>
		return r;
  80249d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a0:	eb 76                	jmp    802518 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8024a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a6:	8b 40 08             	mov    0x8(%rax),%eax
  8024a9:	83 e0 03             	and    $0x3,%eax
  8024ac:	83 f8 01             	cmp    $0x1,%eax
  8024af:	75 3a                	jne    8024eb <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8024b1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024b8:	00 00 00 
  8024bb:	48 8b 00             	mov    (%rax),%rax
  8024be:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024c4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024c7:	89 c6                	mov    %eax,%esi
  8024c9:	48 bf 57 43 80 00 00 	movabs $0x804357,%rdi
  8024d0:	00 00 00 
  8024d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d8:	48 b9 88 03 80 00 00 	movabs $0x800388,%rcx
  8024df:	00 00 00 
  8024e2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024e9:	eb 2d                	jmp    802518 <read+0xd3>
	}
	if (!dev->dev_read)
  8024eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ef:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024f3:	48 85 c0             	test   %rax,%rax
  8024f6:	75 07                	jne    8024ff <read+0xba>
		return -E_NOT_SUPP;
  8024f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024fd:	eb 19                	jmp    802518 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8024ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802503:	48 8b 40 10          	mov    0x10(%rax),%rax
  802507:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80250b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80250f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802513:	48 89 cf             	mov    %rcx,%rdi
  802516:	ff d0                	callq  *%rax
}
  802518:	c9                   	leaveq 
  802519:	c3                   	retq   

000000000080251a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80251a:	55                   	push   %rbp
  80251b:	48 89 e5             	mov    %rsp,%rbp
  80251e:	48 83 ec 30          	sub    $0x30,%rsp
  802522:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802525:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802529:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80252d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802534:	eb 49                	jmp    80257f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802536:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802539:	48 98                	cltq   
  80253b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80253f:	48 29 c2             	sub    %rax,%rdx
  802542:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802545:	48 63 c8             	movslq %eax,%rcx
  802548:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80254c:	48 01 c1             	add    %rax,%rcx
  80254f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802552:	48 89 ce             	mov    %rcx,%rsi
  802555:	89 c7                	mov    %eax,%edi
  802557:	48 b8 45 24 80 00 00 	movabs $0x802445,%rax
  80255e:	00 00 00 
  802561:	ff d0                	callq  *%rax
  802563:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802566:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80256a:	79 05                	jns    802571 <readn+0x57>
			return m;
  80256c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80256f:	eb 1c                	jmp    80258d <readn+0x73>
		if (m == 0)
  802571:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802575:	75 02                	jne    802579 <readn+0x5f>
			break;
  802577:	eb 11                	jmp    80258a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802579:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80257c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80257f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802582:	48 98                	cltq   
  802584:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802588:	72 ac                	jb     802536 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80258a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80258d:	c9                   	leaveq 
  80258e:	c3                   	retq   

000000000080258f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80258f:	55                   	push   %rbp
  802590:	48 89 e5             	mov    %rsp,%rbp
  802593:	48 83 ec 40          	sub    $0x40,%rsp
  802597:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80259a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80259e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025a2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025a6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025a9:	48 89 d6             	mov    %rdx,%rsi
  8025ac:	89 c7                	mov    %eax,%edi
  8025ae:	48 b8 13 20 80 00 00 	movabs $0x802013,%rax
  8025b5:	00 00 00 
  8025b8:	ff d0                	callq  *%rax
  8025ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c1:	78 24                	js     8025e7 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c7:	8b 00                	mov    (%rax),%eax
  8025c9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025cd:	48 89 d6             	mov    %rdx,%rsi
  8025d0:	89 c7                	mov    %eax,%edi
  8025d2:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8025d9:	00 00 00 
  8025dc:	ff d0                	callq  *%rax
  8025de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e5:	79 05                	jns    8025ec <write+0x5d>
		return r;
  8025e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ea:	eb 75                	jmp    802661 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f0:	8b 40 08             	mov    0x8(%rax),%eax
  8025f3:	83 e0 03             	and    $0x3,%eax
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	75 3a                	jne    802634 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8025fa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802601:	00 00 00 
  802604:	48 8b 00             	mov    (%rax),%rax
  802607:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80260d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802610:	89 c6                	mov    %eax,%esi
  802612:	48 bf 73 43 80 00 00 	movabs $0x804373,%rdi
  802619:	00 00 00 
  80261c:	b8 00 00 00 00       	mov    $0x0,%eax
  802621:	48 b9 88 03 80 00 00 	movabs $0x800388,%rcx
  802628:	00 00 00 
  80262b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80262d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802632:	eb 2d                	jmp    802661 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802634:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802638:	48 8b 40 18          	mov    0x18(%rax),%rax
  80263c:	48 85 c0             	test   %rax,%rax
  80263f:	75 07                	jne    802648 <write+0xb9>
		return -E_NOT_SUPP;
  802641:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802646:	eb 19                	jmp    802661 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802648:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80264c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802650:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802654:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802658:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80265c:	48 89 cf             	mov    %rcx,%rdi
  80265f:	ff d0                	callq  *%rax
}
  802661:	c9                   	leaveq 
  802662:	c3                   	retq   

0000000000802663 <seek>:

int
seek(int fdnum, off_t offset)
{
  802663:	55                   	push   %rbp
  802664:	48 89 e5             	mov    %rsp,%rbp
  802667:	48 83 ec 18          	sub    $0x18,%rsp
  80266b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80266e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802671:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802675:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802678:	48 89 d6             	mov    %rdx,%rsi
  80267b:	89 c7                	mov    %eax,%edi
  80267d:	48 b8 13 20 80 00 00 	movabs $0x802013,%rax
  802684:	00 00 00 
  802687:	ff d0                	callq  *%rax
  802689:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80268c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802690:	79 05                	jns    802697 <seek+0x34>
		return r;
  802692:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802695:	eb 0f                	jmp    8026a6 <seek+0x43>
	fd->fd_offset = offset;
  802697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80269e:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8026a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a6:	c9                   	leaveq 
  8026a7:	c3                   	retq   

00000000008026a8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8026a8:	55                   	push   %rbp
  8026a9:	48 89 e5             	mov    %rsp,%rbp
  8026ac:	48 83 ec 30          	sub    $0x30,%rsp
  8026b0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026b3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026b6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026ba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026bd:	48 89 d6             	mov    %rdx,%rsi
  8026c0:	89 c7                	mov    %eax,%edi
  8026c2:	48 b8 13 20 80 00 00 	movabs $0x802013,%rax
  8026c9:	00 00 00 
  8026cc:	ff d0                	callq  *%rax
  8026ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d5:	78 24                	js     8026fb <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026db:	8b 00                	mov    (%rax),%eax
  8026dd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026e1:	48 89 d6             	mov    %rdx,%rsi
  8026e4:	89 c7                	mov    %eax,%edi
  8026e6:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8026ed:	00 00 00 
  8026f0:	ff d0                	callq  *%rax
  8026f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f9:	79 05                	jns    802700 <ftruncate+0x58>
		return r;
  8026fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026fe:	eb 72                	jmp    802772 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802704:	8b 40 08             	mov    0x8(%rax),%eax
  802707:	83 e0 03             	and    $0x3,%eax
  80270a:	85 c0                	test   %eax,%eax
  80270c:	75 3a                	jne    802748 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80270e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802715:	00 00 00 
  802718:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80271b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802721:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802724:	89 c6                	mov    %eax,%esi
  802726:	48 bf 90 43 80 00 00 	movabs $0x804390,%rdi
  80272d:	00 00 00 
  802730:	b8 00 00 00 00       	mov    $0x0,%eax
  802735:	48 b9 88 03 80 00 00 	movabs $0x800388,%rcx
  80273c:	00 00 00 
  80273f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802741:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802746:	eb 2a                	jmp    802772 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802748:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80274c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802750:	48 85 c0             	test   %rax,%rax
  802753:	75 07                	jne    80275c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802755:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80275a:	eb 16                	jmp    802772 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80275c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802760:	48 8b 40 30          	mov    0x30(%rax),%rax
  802764:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802768:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80276b:	89 ce                	mov    %ecx,%esi
  80276d:	48 89 d7             	mov    %rdx,%rdi
  802770:	ff d0                	callq  *%rax
}
  802772:	c9                   	leaveq 
  802773:	c3                   	retq   

0000000000802774 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802774:	55                   	push   %rbp
  802775:	48 89 e5             	mov    %rsp,%rbp
  802778:	48 83 ec 30          	sub    $0x30,%rsp
  80277c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80277f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802783:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802787:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80278a:	48 89 d6             	mov    %rdx,%rsi
  80278d:	89 c7                	mov    %eax,%edi
  80278f:	48 b8 13 20 80 00 00 	movabs $0x802013,%rax
  802796:	00 00 00 
  802799:	ff d0                	callq  *%rax
  80279b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a2:	78 24                	js     8027c8 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a8:	8b 00                	mov    (%rax),%eax
  8027aa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027ae:	48 89 d6             	mov    %rdx,%rsi
  8027b1:	89 c7                	mov    %eax,%edi
  8027b3:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8027ba:	00 00 00 
  8027bd:	ff d0                	callq  *%rax
  8027bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c6:	79 05                	jns    8027cd <fstat+0x59>
		return r;
  8027c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cb:	eb 5e                	jmp    80282b <fstat+0xb7>
	if (!dev->dev_stat)
  8027cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d1:	48 8b 40 28          	mov    0x28(%rax),%rax
  8027d5:	48 85 c0             	test   %rax,%rax
  8027d8:	75 07                	jne    8027e1 <fstat+0x6d>
		return -E_NOT_SUPP;
  8027da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027df:	eb 4a                	jmp    80282b <fstat+0xb7>
	stat->st_name[0] = 0;
  8027e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027e5:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8027e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027ec:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8027f3:	00 00 00 
	stat->st_isdir = 0;
  8027f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027fa:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802801:	00 00 00 
	stat->st_dev = dev;
  802804:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802808:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80280c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802813:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802817:	48 8b 40 28          	mov    0x28(%rax),%rax
  80281b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80281f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802823:	48 89 ce             	mov    %rcx,%rsi
  802826:	48 89 d7             	mov    %rdx,%rdi
  802829:	ff d0                	callq  *%rax
}
  80282b:	c9                   	leaveq 
  80282c:	c3                   	retq   

000000000080282d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80282d:	55                   	push   %rbp
  80282e:	48 89 e5             	mov    %rsp,%rbp
  802831:	48 83 ec 20          	sub    $0x20,%rsp
  802835:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802839:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80283d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802841:	be 00 00 00 00       	mov    $0x0,%esi
  802846:	48 89 c7             	mov    %rax,%rdi
  802849:	48 b8 1b 29 80 00 00 	movabs $0x80291b,%rax
  802850:	00 00 00 
  802853:	ff d0                	callq  *%rax
  802855:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802858:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285c:	79 05                	jns    802863 <stat+0x36>
		return fd;
  80285e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802861:	eb 2f                	jmp    802892 <stat+0x65>
	r = fstat(fd, stat);
  802863:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802867:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80286a:	48 89 d6             	mov    %rdx,%rsi
  80286d:	89 c7                	mov    %eax,%edi
  80286f:	48 b8 74 27 80 00 00 	movabs $0x802774,%rax
  802876:	00 00 00 
  802879:	ff d0                	callq  *%rax
  80287b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80287e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802881:	89 c7                	mov    %eax,%edi
  802883:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  80288a:	00 00 00 
  80288d:	ff d0                	callq  *%rax
	return r;
  80288f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802892:	c9                   	leaveq 
  802893:	c3                   	retq   

0000000000802894 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802894:	55                   	push   %rbp
  802895:	48 89 e5             	mov    %rsp,%rbp
  802898:	48 83 ec 10          	sub    $0x10,%rsp
  80289c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80289f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8028a3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028aa:	00 00 00 
  8028ad:	8b 00                	mov    (%rax),%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	75 1d                	jne    8028d0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8028b3:	bf 01 00 00 00       	mov    $0x1,%edi
  8028b8:	48 b8 d7 3c 80 00 00 	movabs $0x803cd7,%rax
  8028bf:	00 00 00 
  8028c2:	ff d0                	callq  *%rax
  8028c4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8028cb:	00 00 00 
  8028ce:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8028d0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028d7:	00 00 00 
  8028da:	8b 00                	mov    (%rax),%eax
  8028dc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8028df:	b9 07 00 00 00       	mov    $0x7,%ecx
  8028e4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8028eb:	00 00 00 
  8028ee:	89 c7                	mov    %eax,%edi
  8028f0:	48 b8 d8 3b 80 00 00 	movabs $0x803bd8,%rax
  8028f7:	00 00 00 
  8028fa:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8028fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802900:	ba 00 00 00 00       	mov    $0x0,%edx
  802905:	48 89 c6             	mov    %rax,%rsi
  802908:	bf 00 00 00 00       	mov    $0x0,%edi
  80290d:	48 b8 25 3b 80 00 00 	movabs $0x803b25,%rax
  802914:	00 00 00 
  802917:	ff d0                	callq  *%rax
}
  802919:	c9                   	leaveq 
  80291a:	c3                   	retq   

000000000080291b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80291b:	55                   	push   %rbp
  80291c:	48 89 e5             	mov    %rsp,%rbp
  80291f:	48 83 ec 20          	sub    $0x20,%rsp
  802923:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802927:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  80292a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292e:	48 89 c7             	mov    %rax,%rdi
  802931:	48 b8 12 0f 80 00 00 	movabs $0x800f12,%rax
  802938:	00 00 00 
  80293b:	ff d0                	callq  *%rax
  80293d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802942:	7e 0a                	jle    80294e <open+0x33>
		return -E_BAD_PATH;
  802944:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802949:	e9 a5 00 00 00       	jmpq   8029f3 <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  80294e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802952:	48 89 c7             	mov    %rax,%rdi
  802955:	48 b8 7b 1f 80 00 00 	movabs $0x801f7b,%rax
  80295c:	00 00 00 
  80295f:	ff d0                	callq  *%rax
  802961:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802964:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802968:	79 08                	jns    802972 <open+0x57>
		return ret;
  80296a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296d:	e9 81 00 00 00       	jmpq   8029f3 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802972:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802979:	00 00 00 
  80297c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80297f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  802985:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802989:	48 89 c6             	mov    %rax,%rsi
  80298c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802993:	00 00 00 
  802996:	48 b8 7e 0f 80 00 00 	movabs $0x800f7e,%rax
  80299d:	00 00 00 
  8029a0:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  8029a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a6:	48 89 c6             	mov    %rax,%rsi
  8029a9:	bf 01 00 00 00       	mov    $0x1,%edi
  8029ae:	48 b8 94 28 80 00 00 	movabs $0x802894,%rax
  8029b5:	00 00 00 
  8029b8:	ff d0                	callq  *%rax
  8029ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c1:	79 1d                	jns    8029e0 <open+0xc5>
	{
		fd_close(fd,0);
  8029c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c7:	be 00 00 00 00       	mov    $0x0,%esi
  8029cc:	48 89 c7             	mov    %rax,%rdi
  8029cf:	48 b8 a3 20 80 00 00 	movabs $0x8020a3,%rax
  8029d6:	00 00 00 
  8029d9:	ff d0                	callq  *%rax
		return ret;
  8029db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029de:	eb 13                	jmp    8029f3 <open+0xd8>
	}
	return fd2num (fd);
  8029e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e4:	48 89 c7             	mov    %rax,%rdi
  8029e7:	48 b8 2d 1f 80 00 00 	movabs $0x801f2d,%rax
  8029ee:	00 00 00 
  8029f1:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  8029f3:	c9                   	leaveq 
  8029f4:	c3                   	retq   

00000000008029f5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8029f5:	55                   	push   %rbp
  8029f6:	48 89 e5             	mov    %rsp,%rbp
  8029f9:	48 83 ec 10          	sub    $0x10,%rsp
  8029fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802a01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a05:	8b 50 0c             	mov    0xc(%rax),%edx
  802a08:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a0f:	00 00 00 
  802a12:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802a14:	be 00 00 00 00       	mov    $0x0,%esi
  802a19:	bf 06 00 00 00       	mov    $0x6,%edi
  802a1e:	48 b8 94 28 80 00 00 	movabs $0x802894,%rax
  802a25:	00 00 00 
  802a28:	ff d0                	callq  *%rax
}
  802a2a:	c9                   	leaveq 
  802a2b:	c3                   	retq   

0000000000802a2c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802a2c:	55                   	push   %rbp
  802a2d:	48 89 e5             	mov    %rsp,%rbp
  802a30:	48 83 ec 30          	sub    $0x30,%rsp
  802a34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a3c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  802a40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a44:	8b 50 0c             	mov    0xc(%rax),%edx
  802a47:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a4e:	00 00 00 
  802a51:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  802a53:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a5a:	00 00 00 
  802a5d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a61:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  802a65:	be 00 00 00 00       	mov    $0x0,%esi
  802a6a:	bf 03 00 00 00       	mov    $0x3,%edi
  802a6f:	48 b8 94 28 80 00 00 	movabs $0x802894,%rax
  802a76:	00 00 00 
  802a79:	ff d0                	callq  *%rax
  802a7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a82:	79 05                	jns    802a89 <devfile_read+0x5d>
		return ret;
  802a84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a87:	eb 26                	jmp    802aaf <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  802a89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8c:	48 63 d0             	movslq %eax,%rdx
  802a8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a93:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a9a:	00 00 00 
  802a9d:	48 89 c7             	mov    %rax,%rdi
  802aa0:	48 b8 a2 12 80 00 00 	movabs $0x8012a2,%rax
  802aa7:	00 00 00 
  802aaa:	ff d0                	callq  *%rax
	return ret;
  802aac:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  802aaf:	c9                   	leaveq 
  802ab0:	c3                   	retq   

0000000000802ab1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ab1:	55                   	push   %rbp
  802ab2:	48 89 e5             	mov    %rsp,%rbp
  802ab5:	48 83 ec 30          	sub    $0x30,%rsp
  802ab9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802abd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ac1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  802ac5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac9:	8b 50 0c             	mov    0xc(%rax),%edx
  802acc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ad3:	00 00 00 
  802ad6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  802ad8:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  802add:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802ae4:	00 
  802ae5:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802aea:	48 89 c2             	mov    %rax,%rdx
  802aed:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802af4:	00 00 00 
  802af7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  802afb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b02:	00 00 00 
  802b05:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b0d:	48 89 c6             	mov    %rax,%rsi
  802b10:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802b17:	00 00 00 
  802b1a:	48 b8 a2 12 80 00 00 	movabs $0x8012a2,%rax
  802b21:	00 00 00 
  802b24:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  802b26:	be 00 00 00 00       	mov    $0x0,%esi
  802b2b:	bf 04 00 00 00       	mov    $0x4,%edi
  802b30:	48 b8 94 28 80 00 00 	movabs $0x802894,%rax
  802b37:	00 00 00 
  802b3a:	ff d0                	callq  *%rax
  802b3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b43:	79 05                	jns    802b4a <devfile_write+0x99>
		return ret;
  802b45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b48:	eb 03                	jmp    802b4d <devfile_write+0x9c>
	
	return ret;
  802b4a:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  802b4d:	c9                   	leaveq 
  802b4e:	c3                   	retq   

0000000000802b4f <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b4f:	55                   	push   %rbp
  802b50:	48 89 e5             	mov    %rsp,%rbp
  802b53:	48 83 ec 20          	sub    $0x20,%rsp
  802b57:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b5b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b63:	8b 50 0c             	mov    0xc(%rax),%edx
  802b66:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b6d:	00 00 00 
  802b70:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b72:	be 00 00 00 00       	mov    $0x0,%esi
  802b77:	bf 05 00 00 00       	mov    $0x5,%edi
  802b7c:	48 b8 94 28 80 00 00 	movabs $0x802894,%rax
  802b83:	00 00 00 
  802b86:	ff d0                	callq  *%rax
  802b88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8f:	79 05                	jns    802b96 <devfile_stat+0x47>
		return r;
  802b91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b94:	eb 56                	jmp    802bec <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b9a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ba1:	00 00 00 
  802ba4:	48 89 c7             	mov    %rax,%rdi
  802ba7:	48 b8 7e 0f 80 00 00 	movabs $0x800f7e,%rax
  802bae:	00 00 00 
  802bb1:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802bb3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bba:	00 00 00 
  802bbd:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802bc3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bc7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802bcd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bd4:	00 00 00 
  802bd7:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802bdd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802be1:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bec:	c9                   	leaveq 
  802bed:	c3                   	retq   

0000000000802bee <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802bee:	55                   	push   %rbp
  802bef:	48 89 e5             	mov    %rsp,%rbp
  802bf2:	48 83 ec 10          	sub    $0x10,%rsp
  802bf6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bfa:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802bfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c01:	8b 50 0c             	mov    0xc(%rax),%edx
  802c04:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c0b:	00 00 00 
  802c0e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c10:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c17:	00 00 00 
  802c1a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c1d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c20:	be 00 00 00 00       	mov    $0x0,%esi
  802c25:	bf 02 00 00 00       	mov    $0x2,%edi
  802c2a:	48 b8 94 28 80 00 00 	movabs $0x802894,%rax
  802c31:	00 00 00 
  802c34:	ff d0                	callq  *%rax
}
  802c36:	c9                   	leaveq 
  802c37:	c3                   	retq   

0000000000802c38 <remove>:

// Delete a file
int
remove(const char *path)
{
  802c38:	55                   	push   %rbp
  802c39:	48 89 e5             	mov    %rsp,%rbp
  802c3c:	48 83 ec 10          	sub    $0x10,%rsp
  802c40:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c48:	48 89 c7             	mov    %rax,%rdi
  802c4b:	48 b8 12 0f 80 00 00 	movabs $0x800f12,%rax
  802c52:	00 00 00 
  802c55:	ff d0                	callq  *%rax
  802c57:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c5c:	7e 07                	jle    802c65 <remove+0x2d>
		return -E_BAD_PATH;
  802c5e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c63:	eb 33                	jmp    802c98 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c69:	48 89 c6             	mov    %rax,%rsi
  802c6c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c73:	00 00 00 
  802c76:	48 b8 7e 0f 80 00 00 	movabs $0x800f7e,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c82:	be 00 00 00 00       	mov    $0x0,%esi
  802c87:	bf 07 00 00 00       	mov    $0x7,%edi
  802c8c:	48 b8 94 28 80 00 00 	movabs $0x802894,%rax
  802c93:	00 00 00 
  802c96:	ff d0                	callq  *%rax
}
  802c98:	c9                   	leaveq 
  802c99:	c3                   	retq   

0000000000802c9a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c9a:	55                   	push   %rbp
  802c9b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c9e:	be 00 00 00 00       	mov    $0x0,%esi
  802ca3:	bf 08 00 00 00       	mov    $0x8,%edi
  802ca8:	48 b8 94 28 80 00 00 	movabs $0x802894,%rax
  802caf:	00 00 00 
  802cb2:	ff d0                	callq  *%rax
}
  802cb4:	5d                   	pop    %rbp
  802cb5:	c3                   	retq   

0000000000802cb6 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802cb6:	55                   	push   %rbp
  802cb7:	48 89 e5             	mov    %rsp,%rbp
  802cba:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802cc1:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802cc8:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802ccf:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802cd6:	be 00 00 00 00       	mov    $0x0,%esi
  802cdb:	48 89 c7             	mov    %rax,%rdi
  802cde:	48 b8 1b 29 80 00 00 	movabs $0x80291b,%rax
  802ce5:	00 00 00 
  802ce8:	ff d0                	callq  *%rax
  802cea:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ced:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf1:	79 28                	jns    802d1b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802cf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf6:	89 c6                	mov    %eax,%esi
  802cf8:	48 bf b6 43 80 00 00 	movabs $0x8043b6,%rdi
  802cff:	00 00 00 
  802d02:	b8 00 00 00 00       	mov    $0x0,%eax
  802d07:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  802d0e:	00 00 00 
  802d11:	ff d2                	callq  *%rdx
		return fd_src;
  802d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d16:	e9 74 01 00 00       	jmpq   802e8f <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d1b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d22:	be 01 01 00 00       	mov    $0x101,%esi
  802d27:	48 89 c7             	mov    %rax,%rdi
  802d2a:	48 b8 1b 29 80 00 00 	movabs $0x80291b,%rax
  802d31:	00 00 00 
  802d34:	ff d0                	callq  *%rax
  802d36:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d39:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d3d:	79 39                	jns    802d78 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d42:	89 c6                	mov    %eax,%esi
  802d44:	48 bf cc 43 80 00 00 	movabs $0x8043cc,%rdi
  802d4b:	00 00 00 
  802d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d53:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  802d5a:	00 00 00 
  802d5d:	ff d2                	callq  *%rdx
		close(fd_src);
  802d5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d62:	89 c7                	mov    %eax,%edi
  802d64:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  802d6b:	00 00 00 
  802d6e:	ff d0                	callq  *%rax
		return fd_dest;
  802d70:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d73:	e9 17 01 00 00       	jmpq   802e8f <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d78:	eb 74                	jmp    802dee <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d7a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d7d:	48 63 d0             	movslq %eax,%rdx
  802d80:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d87:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d8a:	48 89 ce             	mov    %rcx,%rsi
  802d8d:	89 c7                	mov    %eax,%edi
  802d8f:	48 b8 8f 25 80 00 00 	movabs $0x80258f,%rax
  802d96:	00 00 00 
  802d99:	ff d0                	callq  *%rax
  802d9b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802da2:	79 4a                	jns    802dee <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802da4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802da7:	89 c6                	mov    %eax,%esi
  802da9:	48 bf e6 43 80 00 00 	movabs $0x8043e6,%rdi
  802db0:	00 00 00 
  802db3:	b8 00 00 00 00       	mov    $0x0,%eax
  802db8:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  802dbf:	00 00 00 
  802dc2:	ff d2                	callq  *%rdx
			close(fd_src);
  802dc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc7:	89 c7                	mov    %eax,%edi
  802dc9:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  802dd0:	00 00 00 
  802dd3:	ff d0                	callq  *%rax
			close(fd_dest);
  802dd5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dd8:	89 c7                	mov    %eax,%edi
  802dda:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  802de1:	00 00 00 
  802de4:	ff d0                	callq  *%rax
			return write_size;
  802de6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802de9:	e9 a1 00 00 00       	jmpq   802e8f <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802dee:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802df5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df8:	ba 00 02 00 00       	mov    $0x200,%edx
  802dfd:	48 89 ce             	mov    %rcx,%rsi
  802e00:	89 c7                	mov    %eax,%edi
  802e02:	48 b8 45 24 80 00 00 	movabs $0x802445,%rax
  802e09:	00 00 00 
  802e0c:	ff d0                	callq  *%rax
  802e0e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e11:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e15:	0f 8f 5f ff ff ff    	jg     802d7a <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802e1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e1f:	79 47                	jns    802e68 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802e21:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e24:	89 c6                	mov    %eax,%esi
  802e26:	48 bf f9 43 80 00 00 	movabs $0x8043f9,%rdi
  802e2d:	00 00 00 
  802e30:	b8 00 00 00 00       	mov    $0x0,%eax
  802e35:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  802e3c:	00 00 00 
  802e3f:	ff d2                	callq  *%rdx
		close(fd_src);
  802e41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e44:	89 c7                	mov    %eax,%edi
  802e46:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  802e4d:	00 00 00 
  802e50:	ff d0                	callq  *%rax
		close(fd_dest);
  802e52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e55:	89 c7                	mov    %eax,%edi
  802e57:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  802e5e:	00 00 00 
  802e61:	ff d0                	callq  *%rax
		return read_size;
  802e63:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e66:	eb 27                	jmp    802e8f <copy+0x1d9>
	}
	close(fd_src);
  802e68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6b:	89 c7                	mov    %eax,%edi
  802e6d:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  802e74:	00 00 00 
  802e77:	ff d0                	callq  *%rax
	close(fd_dest);
  802e79:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e7c:	89 c7                	mov    %eax,%edi
  802e7e:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  802e85:	00 00 00 
  802e88:	ff d0                	callq  *%rax
	return 0;
  802e8a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e8f:	c9                   	leaveq 
  802e90:	c3                   	retq   

0000000000802e91 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802e91:	55                   	push   %rbp
  802e92:	48 89 e5             	mov    %rsp,%rbp
  802e95:	48 83 ec 20          	sub    $0x20,%rsp
  802e99:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802e9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea1:	8b 40 0c             	mov    0xc(%rax),%eax
  802ea4:	85 c0                	test   %eax,%eax
  802ea6:	7e 67                	jle    802f0f <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802ea8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eac:	8b 40 04             	mov    0x4(%rax),%eax
  802eaf:	48 63 d0             	movslq %eax,%rdx
  802eb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb6:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802eba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ebe:	8b 00                	mov    (%rax),%eax
  802ec0:	48 89 ce             	mov    %rcx,%rsi
  802ec3:	89 c7                	mov    %eax,%edi
  802ec5:	48 b8 8f 25 80 00 00 	movabs $0x80258f,%rax
  802ecc:	00 00 00 
  802ecf:	ff d0                	callq  *%rax
  802ed1:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802ed4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed8:	7e 13                	jle    802eed <writebuf+0x5c>
			b->result += result;
  802eda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ede:	8b 50 08             	mov    0x8(%rax),%edx
  802ee1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee4:	01 c2                	add    %eax,%edx
  802ee6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eea:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802eed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef1:	8b 40 04             	mov    0x4(%rax),%eax
  802ef4:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802ef7:	74 16                	je     802f0f <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  802efe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f02:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802f06:	89 c2                	mov    %eax,%edx
  802f08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f0c:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802f0f:	c9                   	leaveq 
  802f10:	c3                   	retq   

0000000000802f11 <putch>:

static void
putch(int ch, void *thunk)
{
  802f11:	55                   	push   %rbp
  802f12:	48 89 e5             	mov    %rsp,%rbp
  802f15:	48 83 ec 20          	sub    $0x20,%rsp
  802f19:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802f20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f24:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802f28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f2c:	8b 40 04             	mov    0x4(%rax),%eax
  802f2f:	8d 48 01             	lea    0x1(%rax),%ecx
  802f32:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f36:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802f39:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f3c:	89 d1                	mov    %edx,%ecx
  802f3e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f42:	48 98                	cltq   
  802f44:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802f48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f4c:	8b 40 04             	mov    0x4(%rax),%eax
  802f4f:	3d 00 01 00 00       	cmp    $0x100,%eax
  802f54:	75 1e                	jne    802f74 <putch+0x63>
		writebuf(b);
  802f56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f5a:	48 89 c7             	mov    %rax,%rdi
  802f5d:	48 b8 91 2e 80 00 00 	movabs $0x802e91,%rax
  802f64:	00 00 00 
  802f67:	ff d0                	callq  *%rax
		b->idx = 0;
  802f69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802f74:	c9                   	leaveq 
  802f75:	c3                   	retq   

0000000000802f76 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802f76:	55                   	push   %rbp
  802f77:	48 89 e5             	mov    %rsp,%rbp
  802f7a:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802f81:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802f87:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802f8e:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802f95:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802f9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802fa1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802fa8:	00 00 00 
	b.result = 0;
  802fab:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802fb2:	00 00 00 
	b.error = 1;
  802fb5:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802fbc:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802fbf:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802fc6:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802fcd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802fd4:	48 89 c6             	mov    %rax,%rsi
  802fd7:	48 bf 11 2f 80 00 00 	movabs $0x802f11,%rdi
  802fde:	00 00 00 
  802fe1:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  802fe8:	00 00 00 
  802feb:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802fed:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802ff3:	85 c0                	test   %eax,%eax
  802ff5:	7e 16                	jle    80300d <vfprintf+0x97>
		writebuf(&b);
  802ff7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802ffe:	48 89 c7             	mov    %rax,%rdi
  803001:	48 b8 91 2e 80 00 00 	movabs $0x802e91,%rax
  803008:	00 00 00 
  80300b:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  80300d:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803013:	85 c0                	test   %eax,%eax
  803015:	74 08                	je     80301f <vfprintf+0xa9>
  803017:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80301d:	eb 06                	jmp    803025 <vfprintf+0xaf>
  80301f:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803025:	c9                   	leaveq 
  803026:	c3                   	retq   

0000000000803027 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803027:	55                   	push   %rbp
  803028:	48 89 e5             	mov    %rsp,%rbp
  80302b:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803032:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803038:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80303f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803046:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80304d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803054:	84 c0                	test   %al,%al
  803056:	74 20                	je     803078 <fprintf+0x51>
  803058:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80305c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803060:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803064:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803068:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80306c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803070:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803074:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803078:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80307f:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803086:	00 00 00 
  803089:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803090:	00 00 00 
  803093:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803097:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80309e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030a5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8030ac:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8030b3:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8030ba:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8030c0:	48 89 ce             	mov    %rcx,%rsi
  8030c3:	89 c7                	mov    %eax,%edi
  8030c5:	48 b8 76 2f 80 00 00 	movabs $0x802f76,%rax
  8030cc:	00 00 00 
  8030cf:	ff d0                	callq  *%rax
  8030d1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8030d7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8030dd:	c9                   	leaveq 
  8030de:	c3                   	retq   

00000000008030df <printf>:

int
printf(const char *fmt, ...)
{
  8030df:	55                   	push   %rbp
  8030e0:	48 89 e5             	mov    %rsp,%rbp
  8030e3:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8030ea:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8030f1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8030f8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8030ff:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803106:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80310d:	84 c0                	test   %al,%al
  80310f:	74 20                	je     803131 <printf+0x52>
  803111:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803115:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803119:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80311d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803121:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803125:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803129:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80312d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803131:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803138:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80313f:	00 00 00 
  803142:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803149:	00 00 00 
  80314c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803150:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803157:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80315e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803165:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80316c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803173:	48 89 c6             	mov    %rax,%rsi
  803176:	bf 01 00 00 00       	mov    $0x1,%edi
  80317b:	48 b8 76 2f 80 00 00 	movabs $0x802f76,%rax
  803182:	00 00 00 
  803185:	ff d0                	callq  *%rax
  803187:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80318d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803193:	c9                   	leaveq 
  803194:	c3                   	retq   

0000000000803195 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803195:	55                   	push   %rbp
  803196:	48 89 e5             	mov    %rsp,%rbp
  803199:	53                   	push   %rbx
  80319a:	48 83 ec 38          	sub    $0x38,%rsp
  80319e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8031a2:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8031a6:	48 89 c7             	mov    %rax,%rdi
  8031a9:	48 b8 7b 1f 80 00 00 	movabs $0x801f7b,%rax
  8031b0:	00 00 00 
  8031b3:	ff d0                	callq  *%rax
  8031b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031bc:	0f 88 bf 01 00 00    	js     803381 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c6:	ba 07 04 00 00       	mov    $0x407,%edx
  8031cb:	48 89 c6             	mov    %rax,%rsi
  8031ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8031d3:	48 b8 ad 18 80 00 00 	movabs $0x8018ad,%rax
  8031da:	00 00 00 
  8031dd:	ff d0                	callq  *%rax
  8031df:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031e6:	0f 88 95 01 00 00    	js     803381 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8031ec:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8031f0:	48 89 c7             	mov    %rax,%rdi
  8031f3:	48 b8 7b 1f 80 00 00 	movabs $0x801f7b,%rax
  8031fa:	00 00 00 
  8031fd:	ff d0                	callq  *%rax
  8031ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803202:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803206:	0f 88 5d 01 00 00    	js     803369 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80320c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803210:	ba 07 04 00 00       	mov    $0x407,%edx
  803215:	48 89 c6             	mov    %rax,%rsi
  803218:	bf 00 00 00 00       	mov    $0x0,%edi
  80321d:	48 b8 ad 18 80 00 00 	movabs $0x8018ad,%rax
  803224:	00 00 00 
  803227:	ff d0                	callq  *%rax
  803229:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80322c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803230:	0f 88 33 01 00 00    	js     803369 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803236:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80323a:	48 89 c7             	mov    %rax,%rdi
  80323d:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  803244:	00 00 00 
  803247:	ff d0                	callq  *%rax
  803249:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80324d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803251:	ba 07 04 00 00       	mov    $0x407,%edx
  803256:	48 89 c6             	mov    %rax,%rsi
  803259:	bf 00 00 00 00       	mov    $0x0,%edi
  80325e:	48 b8 ad 18 80 00 00 	movabs $0x8018ad,%rax
  803265:	00 00 00 
  803268:	ff d0                	callq  *%rax
  80326a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80326d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803271:	79 05                	jns    803278 <pipe+0xe3>
		goto err2;
  803273:	e9 d9 00 00 00       	jmpq   803351 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803278:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80327c:	48 89 c7             	mov    %rax,%rdi
  80327f:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  803286:	00 00 00 
  803289:	ff d0                	callq  *%rax
  80328b:	48 89 c2             	mov    %rax,%rdx
  80328e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803292:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803298:	48 89 d1             	mov    %rdx,%rcx
  80329b:	ba 00 00 00 00       	mov    $0x0,%edx
  8032a0:	48 89 c6             	mov    %rax,%rsi
  8032a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8032a8:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  8032af:	00 00 00 
  8032b2:	ff d0                	callq  *%rax
  8032b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032bb:	79 1b                	jns    8032d8 <pipe+0x143>
		goto err3;
  8032bd:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8032be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032c2:	48 89 c6             	mov    %rax,%rsi
  8032c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ca:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  8032d1:	00 00 00 
  8032d4:	ff d0                	callq  *%rax
  8032d6:	eb 79                	jmp    803351 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8032d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032dc:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8032e3:	00 00 00 
  8032e6:	8b 12                	mov    (%rdx),%edx
  8032e8:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8032ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032ee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8032f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032f9:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803300:	00 00 00 
  803303:	8b 12                	mov    (%rdx),%edx
  803305:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803307:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80330b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803312:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803316:	48 89 c7             	mov    %rax,%rdi
  803319:	48 b8 2d 1f 80 00 00 	movabs $0x801f2d,%rax
  803320:	00 00 00 
  803323:	ff d0                	callq  *%rax
  803325:	89 c2                	mov    %eax,%edx
  803327:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80332b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80332d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803331:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803335:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803339:	48 89 c7             	mov    %rax,%rdi
  80333c:	48 b8 2d 1f 80 00 00 	movabs $0x801f2d,%rax
  803343:	00 00 00 
  803346:	ff d0                	callq  *%rax
  803348:	89 03                	mov    %eax,(%rbx)
	return 0;
  80334a:	b8 00 00 00 00       	mov    $0x0,%eax
  80334f:	eb 33                	jmp    803384 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803351:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803355:	48 89 c6             	mov    %rax,%rsi
  803358:	bf 00 00 00 00       	mov    $0x0,%edi
  80335d:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  803364:	00 00 00 
  803367:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803369:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336d:	48 89 c6             	mov    %rax,%rsi
  803370:	bf 00 00 00 00       	mov    $0x0,%edi
  803375:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  80337c:	00 00 00 
  80337f:	ff d0                	callq  *%rax
err:
	return r;
  803381:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803384:	48 83 c4 38          	add    $0x38,%rsp
  803388:	5b                   	pop    %rbx
  803389:	5d                   	pop    %rbp
  80338a:	c3                   	retq   

000000000080338b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80338b:	55                   	push   %rbp
  80338c:	48 89 e5             	mov    %rsp,%rbp
  80338f:	53                   	push   %rbx
  803390:	48 83 ec 28          	sub    $0x28,%rsp
  803394:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803398:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80339c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033a3:	00 00 00 
  8033a6:	48 8b 00             	mov    (%rax),%rax
  8033a9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8033af:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8033b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033b6:	48 89 c7             	mov    %rax,%rdi
  8033b9:	48 b8 49 3d 80 00 00 	movabs $0x803d49,%rax
  8033c0:	00 00 00 
  8033c3:	ff d0                	callq  *%rax
  8033c5:	89 c3                	mov    %eax,%ebx
  8033c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033cb:	48 89 c7             	mov    %rax,%rdi
  8033ce:	48 b8 49 3d 80 00 00 	movabs $0x803d49,%rax
  8033d5:	00 00 00 
  8033d8:	ff d0                	callq  *%rax
  8033da:	39 c3                	cmp    %eax,%ebx
  8033dc:	0f 94 c0             	sete   %al
  8033df:	0f b6 c0             	movzbl %al,%eax
  8033e2:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8033e5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033ec:	00 00 00 
  8033ef:	48 8b 00             	mov    (%rax),%rax
  8033f2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8033f8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8033fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033fe:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803401:	75 05                	jne    803408 <_pipeisclosed+0x7d>
			return ret;
  803403:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803406:	eb 4f                	jmp    803457 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803408:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80340b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80340e:	74 42                	je     803452 <_pipeisclosed+0xc7>
  803410:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803414:	75 3c                	jne    803452 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803416:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80341d:	00 00 00 
  803420:	48 8b 00             	mov    (%rax),%rax
  803423:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803429:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80342c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80342f:	89 c6                	mov    %eax,%esi
  803431:	48 bf 19 44 80 00 00 	movabs $0x804419,%rdi
  803438:	00 00 00 
  80343b:	b8 00 00 00 00       	mov    $0x0,%eax
  803440:	49 b8 88 03 80 00 00 	movabs $0x800388,%r8
  803447:	00 00 00 
  80344a:	41 ff d0             	callq  *%r8
	}
  80344d:	e9 4a ff ff ff       	jmpq   80339c <_pipeisclosed+0x11>
  803452:	e9 45 ff ff ff       	jmpq   80339c <_pipeisclosed+0x11>
}
  803457:	48 83 c4 28          	add    $0x28,%rsp
  80345b:	5b                   	pop    %rbx
  80345c:	5d                   	pop    %rbp
  80345d:	c3                   	retq   

000000000080345e <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80345e:	55                   	push   %rbp
  80345f:	48 89 e5             	mov    %rsp,%rbp
  803462:	48 83 ec 30          	sub    $0x30,%rsp
  803466:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803469:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80346d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803470:	48 89 d6             	mov    %rdx,%rsi
  803473:	89 c7                	mov    %eax,%edi
  803475:	48 b8 13 20 80 00 00 	movabs $0x802013,%rax
  80347c:	00 00 00 
  80347f:	ff d0                	callq  *%rax
  803481:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803484:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803488:	79 05                	jns    80348f <pipeisclosed+0x31>
		return r;
  80348a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348d:	eb 31                	jmp    8034c0 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80348f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803493:	48 89 c7             	mov    %rax,%rdi
  803496:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  80349d:	00 00 00 
  8034a0:	ff d0                	callq  *%rax
  8034a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8034a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034ae:	48 89 d6             	mov    %rdx,%rsi
  8034b1:	48 89 c7             	mov    %rax,%rdi
  8034b4:	48 b8 8b 33 80 00 00 	movabs $0x80338b,%rax
  8034bb:	00 00 00 
  8034be:	ff d0                	callq  *%rax
}
  8034c0:	c9                   	leaveq 
  8034c1:	c3                   	retq   

00000000008034c2 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8034c2:	55                   	push   %rbp
  8034c3:	48 89 e5             	mov    %rsp,%rbp
  8034c6:	48 83 ec 40          	sub    $0x40,%rsp
  8034ca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034ce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034d2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8034d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034da:	48 89 c7             	mov    %rax,%rdi
  8034dd:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  8034e4:	00 00 00 
  8034e7:	ff d0                	callq  *%rax
  8034e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8034ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8034f5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8034fc:	00 
  8034fd:	e9 92 00 00 00       	jmpq   803594 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803502:	eb 41                	jmp    803545 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803504:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803509:	74 09                	je     803514 <devpipe_read+0x52>
				return i;
  80350b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80350f:	e9 92 00 00 00       	jmpq   8035a6 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803514:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803518:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80351c:	48 89 d6             	mov    %rdx,%rsi
  80351f:	48 89 c7             	mov    %rax,%rdi
  803522:	48 b8 8b 33 80 00 00 	movabs $0x80338b,%rax
  803529:	00 00 00 
  80352c:	ff d0                	callq  *%rax
  80352e:	85 c0                	test   %eax,%eax
  803530:	74 07                	je     803539 <devpipe_read+0x77>
				return 0;
  803532:	b8 00 00 00 00       	mov    $0x0,%eax
  803537:	eb 6d                	jmp    8035a6 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803539:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  803540:	00 00 00 
  803543:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803545:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803549:	8b 10                	mov    (%rax),%edx
  80354b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354f:	8b 40 04             	mov    0x4(%rax),%eax
  803552:	39 c2                	cmp    %eax,%edx
  803554:	74 ae                	je     803504 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80355a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80355e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803562:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803566:	8b 00                	mov    (%rax),%eax
  803568:	99                   	cltd   
  803569:	c1 ea 1b             	shr    $0x1b,%edx
  80356c:	01 d0                	add    %edx,%eax
  80356e:	83 e0 1f             	and    $0x1f,%eax
  803571:	29 d0                	sub    %edx,%eax
  803573:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803577:	48 98                	cltq   
  803579:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80357e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803584:	8b 00                	mov    (%rax),%eax
  803586:	8d 50 01             	lea    0x1(%rax),%edx
  803589:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80358d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80358f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803598:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80359c:	0f 82 60 ff ff ff    	jb     803502 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8035a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035a6:	c9                   	leaveq 
  8035a7:	c3                   	retq   

00000000008035a8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8035a8:	55                   	push   %rbp
  8035a9:	48 89 e5             	mov    %rsp,%rbp
  8035ac:	48 83 ec 40          	sub    $0x40,%rsp
  8035b0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035b4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035b8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8035bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035c0:	48 89 c7             	mov    %rax,%rdi
  8035c3:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  8035ca:	00 00 00 
  8035cd:	ff d0                	callq  *%rax
  8035cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035db:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035e2:	00 
  8035e3:	e9 8e 00 00 00       	jmpq   803676 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8035e8:	eb 31                	jmp    80361b <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8035ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f2:	48 89 d6             	mov    %rdx,%rsi
  8035f5:	48 89 c7             	mov    %rax,%rdi
  8035f8:	48 b8 8b 33 80 00 00 	movabs $0x80338b,%rax
  8035ff:	00 00 00 
  803602:	ff d0                	callq  *%rax
  803604:	85 c0                	test   %eax,%eax
  803606:	74 07                	je     80360f <devpipe_write+0x67>
				return 0;
  803608:	b8 00 00 00 00       	mov    $0x0,%eax
  80360d:	eb 79                	jmp    803688 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80360f:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  803616:	00 00 00 
  803619:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80361b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80361f:	8b 40 04             	mov    0x4(%rax),%eax
  803622:	48 63 d0             	movslq %eax,%rdx
  803625:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803629:	8b 00                	mov    (%rax),%eax
  80362b:	48 98                	cltq   
  80362d:	48 83 c0 20          	add    $0x20,%rax
  803631:	48 39 c2             	cmp    %rax,%rdx
  803634:	73 b4                	jae    8035ea <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803636:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80363a:	8b 40 04             	mov    0x4(%rax),%eax
  80363d:	99                   	cltd   
  80363e:	c1 ea 1b             	shr    $0x1b,%edx
  803641:	01 d0                	add    %edx,%eax
  803643:	83 e0 1f             	and    $0x1f,%eax
  803646:	29 d0                	sub    %edx,%eax
  803648:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80364c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803650:	48 01 ca             	add    %rcx,%rdx
  803653:	0f b6 0a             	movzbl (%rdx),%ecx
  803656:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80365a:	48 98                	cltq   
  80365c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803660:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803664:	8b 40 04             	mov    0x4(%rax),%eax
  803667:	8d 50 01             	lea    0x1(%rax),%edx
  80366a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803671:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803676:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80367e:	0f 82 64 ff ff ff    	jb     8035e8 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803684:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803688:	c9                   	leaveq 
  803689:	c3                   	retq   

000000000080368a <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80368a:	55                   	push   %rbp
  80368b:	48 89 e5             	mov    %rsp,%rbp
  80368e:	48 83 ec 20          	sub    $0x20,%rsp
  803692:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803696:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80369a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80369e:	48 89 c7             	mov    %rax,%rdi
  8036a1:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  8036a8:	00 00 00 
  8036ab:	ff d0                	callq  *%rax
  8036ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8036b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036b5:	48 be 2c 44 80 00 00 	movabs $0x80442c,%rsi
  8036bc:	00 00 00 
  8036bf:	48 89 c7             	mov    %rax,%rdi
  8036c2:	48 b8 7e 0f 80 00 00 	movabs $0x800f7e,%rax
  8036c9:	00 00 00 
  8036cc:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8036ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036d2:	8b 50 04             	mov    0x4(%rax),%edx
  8036d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036d9:	8b 00                	mov    (%rax),%eax
  8036db:	29 c2                	sub    %eax,%edx
  8036dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8036e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036eb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8036f2:	00 00 00 
	stat->st_dev = &devpipe;
  8036f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036f9:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803700:	00 00 00 
  803703:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80370a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80370f:	c9                   	leaveq 
  803710:	c3                   	retq   

0000000000803711 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803711:	55                   	push   %rbp
  803712:	48 89 e5             	mov    %rsp,%rbp
  803715:	48 83 ec 10          	sub    $0x10,%rsp
  803719:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80371d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803721:	48 89 c6             	mov    %rax,%rsi
  803724:	bf 00 00 00 00       	mov    $0x0,%edi
  803729:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  803730:	00 00 00 
  803733:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803735:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803739:	48 89 c7             	mov    %rax,%rdi
  80373c:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  803743:	00 00 00 
  803746:	ff d0                	callq  *%rax
  803748:	48 89 c6             	mov    %rax,%rsi
  80374b:	bf 00 00 00 00       	mov    $0x0,%edi
  803750:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  803757:	00 00 00 
  80375a:	ff d0                	callq  *%rax
}
  80375c:	c9                   	leaveq 
  80375d:	c3                   	retq   

000000000080375e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80375e:	55                   	push   %rbp
  80375f:	48 89 e5             	mov    %rsp,%rbp
  803762:	48 83 ec 20          	sub    $0x20,%rsp
  803766:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803769:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80376c:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80376f:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803773:	be 01 00 00 00       	mov    $0x1,%esi
  803778:	48 89 c7             	mov    %rax,%rdi
  80377b:	48 b8 65 17 80 00 00 	movabs $0x801765,%rax
  803782:	00 00 00 
  803785:	ff d0                	callq  *%rax
}
  803787:	c9                   	leaveq 
  803788:	c3                   	retq   

0000000000803789 <getchar>:

int
getchar(void)
{
  803789:	55                   	push   %rbp
  80378a:	48 89 e5             	mov    %rsp,%rbp
  80378d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803791:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803795:	ba 01 00 00 00       	mov    $0x1,%edx
  80379a:	48 89 c6             	mov    %rax,%rsi
  80379d:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a2:	48 b8 45 24 80 00 00 	movabs $0x802445,%rax
  8037a9:	00 00 00 
  8037ac:	ff d0                	callq  *%rax
  8037ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8037b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037b5:	79 05                	jns    8037bc <getchar+0x33>
		return r;
  8037b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ba:	eb 14                	jmp    8037d0 <getchar+0x47>
	if (r < 1)
  8037bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c0:	7f 07                	jg     8037c9 <getchar+0x40>
		return -E_EOF;
  8037c2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8037c7:	eb 07                	jmp    8037d0 <getchar+0x47>
	return c;
  8037c9:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8037cd:	0f b6 c0             	movzbl %al,%eax
}
  8037d0:	c9                   	leaveq 
  8037d1:	c3                   	retq   

00000000008037d2 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8037d2:	55                   	push   %rbp
  8037d3:	48 89 e5             	mov    %rsp,%rbp
  8037d6:	48 83 ec 20          	sub    $0x20,%rsp
  8037da:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037dd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037e4:	48 89 d6             	mov    %rdx,%rsi
  8037e7:	89 c7                	mov    %eax,%edi
  8037e9:	48 b8 13 20 80 00 00 	movabs $0x802013,%rax
  8037f0:	00 00 00 
  8037f3:	ff d0                	callq  *%rax
  8037f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037fc:	79 05                	jns    803803 <iscons+0x31>
		return r;
  8037fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803801:	eb 1a                	jmp    80381d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803803:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803807:	8b 10                	mov    (%rax),%edx
  803809:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803810:	00 00 00 
  803813:	8b 00                	mov    (%rax),%eax
  803815:	39 c2                	cmp    %eax,%edx
  803817:	0f 94 c0             	sete   %al
  80381a:	0f b6 c0             	movzbl %al,%eax
}
  80381d:	c9                   	leaveq 
  80381e:	c3                   	retq   

000000000080381f <opencons>:

int
opencons(void)
{
  80381f:	55                   	push   %rbp
  803820:	48 89 e5             	mov    %rsp,%rbp
  803823:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803827:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80382b:	48 89 c7             	mov    %rax,%rdi
  80382e:	48 b8 7b 1f 80 00 00 	movabs $0x801f7b,%rax
  803835:	00 00 00 
  803838:	ff d0                	callq  *%rax
  80383a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80383d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803841:	79 05                	jns    803848 <opencons+0x29>
		return r;
  803843:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803846:	eb 5b                	jmp    8038a3 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803848:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80384c:	ba 07 04 00 00       	mov    $0x407,%edx
  803851:	48 89 c6             	mov    %rax,%rsi
  803854:	bf 00 00 00 00       	mov    $0x0,%edi
  803859:	48 b8 ad 18 80 00 00 	movabs $0x8018ad,%rax
  803860:	00 00 00 
  803863:	ff d0                	callq  *%rax
  803865:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803868:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80386c:	79 05                	jns    803873 <opencons+0x54>
		return r;
  80386e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803871:	eb 30                	jmp    8038a3 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803873:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803877:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80387e:	00 00 00 
  803881:	8b 12                	mov    (%rdx),%edx
  803883:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803885:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803889:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803890:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803894:	48 89 c7             	mov    %rax,%rdi
  803897:	48 b8 2d 1f 80 00 00 	movabs $0x801f2d,%rax
  80389e:	00 00 00 
  8038a1:	ff d0                	callq  *%rax
}
  8038a3:	c9                   	leaveq 
  8038a4:	c3                   	retq   

00000000008038a5 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038a5:	55                   	push   %rbp
  8038a6:	48 89 e5             	mov    %rsp,%rbp
  8038a9:	48 83 ec 30          	sub    $0x30,%rsp
  8038ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8038b9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8038be:	75 07                	jne    8038c7 <devcons_read+0x22>
		return 0;
  8038c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c5:	eb 4b                	jmp    803912 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8038c7:	eb 0c                	jmp    8038d5 <devcons_read+0x30>
		sys_yield();
  8038c9:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  8038d0:	00 00 00 
  8038d3:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8038d5:	48 b8 af 17 80 00 00 	movabs $0x8017af,%rax
  8038dc:	00 00 00 
  8038df:	ff d0                	callq  *%rax
  8038e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038e8:	74 df                	je     8038c9 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8038ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ee:	79 05                	jns    8038f5 <devcons_read+0x50>
		return c;
  8038f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f3:	eb 1d                	jmp    803912 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8038f5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8038f9:	75 07                	jne    803902 <devcons_read+0x5d>
		return 0;
  8038fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803900:	eb 10                	jmp    803912 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803902:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803905:	89 c2                	mov    %eax,%edx
  803907:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80390b:	88 10                	mov    %dl,(%rax)
	return 1;
  80390d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803912:	c9                   	leaveq 
  803913:	c3                   	retq   

0000000000803914 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803914:	55                   	push   %rbp
  803915:	48 89 e5             	mov    %rsp,%rbp
  803918:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80391f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803926:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80392d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803934:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80393b:	eb 76                	jmp    8039b3 <devcons_write+0x9f>
		m = n - tot;
  80393d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803944:	89 c2                	mov    %eax,%edx
  803946:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803949:	29 c2                	sub    %eax,%edx
  80394b:	89 d0                	mov    %edx,%eax
  80394d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803950:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803953:	83 f8 7f             	cmp    $0x7f,%eax
  803956:	76 07                	jbe    80395f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803958:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80395f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803962:	48 63 d0             	movslq %eax,%rdx
  803965:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803968:	48 63 c8             	movslq %eax,%rcx
  80396b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803972:	48 01 c1             	add    %rax,%rcx
  803975:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80397c:	48 89 ce             	mov    %rcx,%rsi
  80397f:	48 89 c7             	mov    %rax,%rdi
  803982:	48 b8 a2 12 80 00 00 	movabs $0x8012a2,%rax
  803989:	00 00 00 
  80398c:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80398e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803991:	48 63 d0             	movslq %eax,%rdx
  803994:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80399b:	48 89 d6             	mov    %rdx,%rsi
  80399e:	48 89 c7             	mov    %rax,%rdi
  8039a1:	48 b8 65 17 80 00 00 	movabs $0x801765,%rax
  8039a8:	00 00 00 
  8039ab:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039b0:	01 45 fc             	add    %eax,-0x4(%rbp)
  8039b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b6:	48 98                	cltq   
  8039b8:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8039bf:	0f 82 78 ff ff ff    	jb     80393d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8039c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039c8:	c9                   	leaveq 
  8039c9:	c3                   	retq   

00000000008039ca <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8039ca:	55                   	push   %rbp
  8039cb:	48 89 e5             	mov    %rsp,%rbp
  8039ce:	48 83 ec 08          	sub    $0x8,%rsp
  8039d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8039d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039db:	c9                   	leaveq 
  8039dc:	c3                   	retq   

00000000008039dd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8039dd:	55                   	push   %rbp
  8039de:	48 89 e5             	mov    %rsp,%rbp
  8039e1:	48 83 ec 10          	sub    $0x10,%rsp
  8039e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8039ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f1:	48 be 38 44 80 00 00 	movabs $0x804438,%rsi
  8039f8:	00 00 00 
  8039fb:	48 89 c7             	mov    %rax,%rdi
  8039fe:	48 b8 7e 0f 80 00 00 	movabs $0x800f7e,%rax
  803a05:	00 00 00 
  803a08:	ff d0                	callq  *%rax
	return 0;
  803a0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a0f:	c9                   	leaveq 
  803a10:	c3                   	retq   

0000000000803a11 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803a11:	55                   	push   %rbp
  803a12:	48 89 e5             	mov    %rsp,%rbp
  803a15:	53                   	push   %rbx
  803a16:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803a1d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803a24:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803a2a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803a31:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803a38:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803a3f:	84 c0                	test   %al,%al
  803a41:	74 23                	je     803a66 <_panic+0x55>
  803a43:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803a4a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803a4e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803a52:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803a56:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803a5a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803a5e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803a62:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803a66:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803a6d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803a74:	00 00 00 
  803a77:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803a7e:	00 00 00 
  803a81:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803a85:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803a8c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803a93:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803a9a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803aa1:	00 00 00 
  803aa4:	48 8b 18             	mov    (%rax),%rbx
  803aa7:	48 b8 31 18 80 00 00 	movabs $0x801831,%rax
  803aae:	00 00 00 
  803ab1:	ff d0                	callq  *%rax
  803ab3:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803ab9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803ac0:	41 89 c8             	mov    %ecx,%r8d
  803ac3:	48 89 d1             	mov    %rdx,%rcx
  803ac6:	48 89 da             	mov    %rbx,%rdx
  803ac9:	89 c6                	mov    %eax,%esi
  803acb:	48 bf 40 44 80 00 00 	movabs $0x804440,%rdi
  803ad2:	00 00 00 
  803ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  803ada:	49 b9 88 03 80 00 00 	movabs $0x800388,%r9
  803ae1:	00 00 00 
  803ae4:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803ae7:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803aee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803af5:	48 89 d6             	mov    %rdx,%rsi
  803af8:	48 89 c7             	mov    %rax,%rdi
  803afb:	48 b8 dc 02 80 00 00 	movabs $0x8002dc,%rax
  803b02:	00 00 00 
  803b05:	ff d0                	callq  *%rax
	cprintf("\n");
  803b07:	48 bf 63 44 80 00 00 	movabs $0x804463,%rdi
  803b0e:	00 00 00 
  803b11:	b8 00 00 00 00       	mov    $0x0,%eax
  803b16:	48 ba 88 03 80 00 00 	movabs $0x800388,%rdx
  803b1d:	00 00 00 
  803b20:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803b22:	cc                   	int3   
  803b23:	eb fd                	jmp    803b22 <_panic+0x111>

0000000000803b25 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803b25:	55                   	push   %rbp
  803b26:	48 89 e5             	mov    %rsp,%rbp
  803b29:	48 83 ec 30          	sub    $0x30,%rsp
  803b2d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b31:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b35:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  803b39:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b3e:	75 08                	jne    803b48 <ipc_recv+0x23>
  803b40:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  803b47:	ff 
	int res=sys_ipc_recv(pg);
  803b48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b4c:	48 89 c7             	mov    %rax,%rdi
  803b4f:	48 b8 21 1b 80 00 00 	movabs $0x801b21,%rax
  803b56:	00 00 00 
  803b59:	ff d0                	callq  *%rax
  803b5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  803b5e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803b63:	74 26                	je     803b8b <ipc_recv+0x66>
  803b65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b69:	75 15                	jne    803b80 <ipc_recv+0x5b>
  803b6b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b72:	00 00 00 
  803b75:	48 8b 00             	mov    (%rax),%rax
  803b78:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803b7e:	eb 05                	jmp    803b85 <ipc_recv+0x60>
  803b80:	b8 00 00 00 00       	mov    $0x0,%eax
  803b85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b89:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  803b8b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803b90:	74 26                	je     803bb8 <ipc_recv+0x93>
  803b92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b96:	75 15                	jne    803bad <ipc_recv+0x88>
  803b98:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b9f:	00 00 00 
  803ba2:	48 8b 00             	mov    (%rax),%rax
  803ba5:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803bab:	eb 05                	jmp    803bb2 <ipc_recv+0x8d>
  803bad:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803bb6:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  803bb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bbc:	75 15                	jne    803bd3 <ipc_recv+0xae>
  803bbe:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bc5:	00 00 00 
  803bc8:	48 8b 00             	mov    (%rax),%rax
  803bcb:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803bd1:	eb 03                	jmp    803bd6 <ipc_recv+0xb1>
  803bd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  803bd6:	c9                   	leaveq 
  803bd7:	c3                   	retq   

0000000000803bd8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803bd8:	55                   	push   %rbp
  803bd9:	48 89 e5             	mov    %rsp,%rbp
  803bdc:	48 83 ec 30          	sub    $0x30,%rsp
  803be0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803be3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803be6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803bea:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  803bed:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803bf2:	75 0a                	jne    803bfe <ipc_send+0x26>
  803bf4:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  803bfb:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  803bfc:	eb 3e                	jmp    803c3c <ipc_send+0x64>
  803bfe:	eb 3c                	jmp    803c3c <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  803c00:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803c04:	74 2a                	je     803c30 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  803c06:	48 ba 68 44 80 00 00 	movabs $0x804468,%rdx
  803c0d:	00 00 00 
  803c10:	be 39 00 00 00       	mov    $0x39,%esi
  803c15:	48 bf 93 44 80 00 00 	movabs $0x804493,%rdi
  803c1c:	00 00 00 
  803c1f:	b8 00 00 00 00       	mov    $0x0,%eax
  803c24:	48 b9 11 3a 80 00 00 	movabs $0x803a11,%rcx
  803c2b:	00 00 00 
  803c2e:	ff d1                	callq  *%rcx
		sys_yield();  
  803c30:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  803c37:	00 00 00 
  803c3a:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  803c3c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803c3f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803c42:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803c46:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c49:	89 c7                	mov    %eax,%edi
  803c4b:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  803c52:	00 00 00 
  803c55:	ff d0                	callq  *%rax
  803c57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c5e:	78 a0                	js     803c00 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  803c60:	c9                   	leaveq 
  803c61:	c3                   	retq   

0000000000803c62 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803c62:	55                   	push   %rbp
  803c63:	48 89 e5             	mov    %rsp,%rbp
  803c66:	48 83 ec 10          	sub    $0x10,%rsp
  803c6a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  803c6e:	48 ba a0 44 80 00 00 	movabs $0x8044a0,%rdx
  803c75:	00 00 00 
  803c78:	be 47 00 00 00       	mov    $0x47,%esi
  803c7d:	48 bf 93 44 80 00 00 	movabs $0x804493,%rdi
  803c84:	00 00 00 
  803c87:	b8 00 00 00 00       	mov    $0x0,%eax
  803c8c:	48 b9 11 3a 80 00 00 	movabs $0x803a11,%rcx
  803c93:	00 00 00 
  803c96:	ff d1                	callq  *%rcx

0000000000803c98 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c98:	55                   	push   %rbp
  803c99:	48 89 e5             	mov    %rsp,%rbp
  803c9c:	48 83 ec 20          	sub    $0x20,%rsp
  803ca0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ca3:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ca6:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803caa:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  803cad:	48 ba c8 44 80 00 00 	movabs $0x8044c8,%rdx
  803cb4:	00 00 00 
  803cb7:	be 50 00 00 00       	mov    $0x50,%esi
  803cbc:	48 bf 93 44 80 00 00 	movabs $0x804493,%rdi
  803cc3:	00 00 00 
  803cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  803ccb:	48 b9 11 3a 80 00 00 	movabs $0x803a11,%rcx
  803cd2:	00 00 00 
  803cd5:	ff d1                	callq  *%rcx

0000000000803cd7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803cd7:	55                   	push   %rbp
  803cd8:	48 89 e5             	mov    %rsp,%rbp
  803cdb:	48 83 ec 14          	sub    $0x14,%rsp
  803cdf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803ce2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ce9:	eb 4e                	jmp    803d39 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803ceb:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803cf2:	00 00 00 
  803cf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf8:	48 98                	cltq   
  803cfa:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  803d01:	48 01 d0             	add    %rdx,%rax
  803d04:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803d0a:	8b 00                	mov    (%rax),%eax
  803d0c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d0f:	75 24                	jne    803d35 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803d11:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d18:	00 00 00 
  803d1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d1e:	48 98                	cltq   
  803d20:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  803d27:	48 01 d0             	add    %rdx,%rax
  803d2a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803d30:	8b 40 08             	mov    0x8(%rax),%eax
  803d33:	eb 12                	jmp    803d47 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803d35:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803d39:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803d40:	7e a9                	jle    803ceb <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  803d42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d47:	c9                   	leaveq 
  803d48:	c3                   	retq   

0000000000803d49 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803d49:	55                   	push   %rbp
  803d4a:	48 89 e5             	mov    %rsp,%rbp
  803d4d:	48 83 ec 18          	sub    $0x18,%rsp
  803d51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803d55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d59:	48 c1 e8 15          	shr    $0x15,%rax
  803d5d:	48 89 c2             	mov    %rax,%rdx
  803d60:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d67:	01 00 00 
  803d6a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d6e:	83 e0 01             	and    $0x1,%eax
  803d71:	48 85 c0             	test   %rax,%rax
  803d74:	75 07                	jne    803d7d <pageref+0x34>
		return 0;
  803d76:	b8 00 00 00 00       	mov    $0x0,%eax
  803d7b:	eb 53                	jmp    803dd0 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803d7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d81:	48 c1 e8 0c          	shr    $0xc,%rax
  803d85:	48 89 c2             	mov    %rax,%rdx
  803d88:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d8f:	01 00 00 
  803d92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d96:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803d9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d9e:	83 e0 01             	and    $0x1,%eax
  803da1:	48 85 c0             	test   %rax,%rax
  803da4:	75 07                	jne    803dad <pageref+0x64>
		return 0;
  803da6:	b8 00 00 00 00       	mov    $0x0,%eax
  803dab:	eb 23                	jmp    803dd0 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803dad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803db1:	48 c1 e8 0c          	shr    $0xc,%rax
  803db5:	48 89 c2             	mov    %rax,%rdx
  803db8:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803dbf:	00 00 00 
  803dc2:	48 c1 e2 04          	shl    $0x4,%rdx
  803dc6:	48 01 d0             	add    %rdx,%rax
  803dc9:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803dcd:	0f b7 c0             	movzwl %ax,%eax
}
  803dd0:	c9                   	leaveq 
  803dd1:	c3                   	retq   
