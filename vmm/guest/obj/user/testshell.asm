
vmm/guest/obj/user/testshell:     file format elf64-x86-64


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
  80003c:	e8 10 08 00 00       	callq  800851 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  800052:	bf 00 00 00 00       	mov    $0x0,%edi
  800057:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  80005e:	00 00 00 
  800061:	ff d0                	callq  *%rax
	close(1);
  800063:	bf 01 00 00 00       	mov    $0x1,%edi
  800068:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  80006f:	00 00 00 
  800072:	ff d0                	callq  *%rax
	opencons();
  800074:	48 b8 5f 06 80 00 00 	movabs $0x80065f,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
	opencons();
  800080:	48 b8 5f 06 80 00 00 	movabs $0x80065f,%rax
  800087:	00 00 00 
  80008a:	ff d0                	callq  *%rax

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80008c:	be 00 00 00 00       	mov    $0x0,%esi
  800091:	48 bf 60 52 80 00 00 	movabs $0x805260,%rdi
  800098:	00 00 00 
  80009b:	48 b8 1c 37 80 00 00 	movabs $0x80371c,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000ae:	79 30                	jns    8000e0 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b3:	89 c1                	mov    %eax,%ecx
  8000b5:	48 ba 6d 52 80 00 00 	movabs $0x80526d,%rdx
  8000bc:	00 00 00 
  8000bf:	be 13 00 00 00       	mov    $0x13,%esi
  8000c4:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
  8000cb:	00 00 00 
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	49 b8 f7 08 80 00 00 	movabs $0x8008f7,%r8
  8000da:	00 00 00 
  8000dd:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e4:	48 89 c7             	mov    %rax,%rdi
  8000e7:	48 b8 33 48 80 00 00 	movabs $0x804833,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax
  8000f3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fa:	79 30                	jns    80012c <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ff:	89 c1                	mov    %eax,%ecx
  800101:	48 ba 94 52 80 00 00 	movabs $0x805294,%rdx
  800108:	00 00 00 
  80010b:	be 15 00 00 00       	mov    $0x15,%esi
  800110:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
  800117:	00 00 00 
  80011a:	b8 00 00 00 00       	mov    $0x0,%eax
  80011f:	49 b8 f7 08 80 00 00 	movabs $0x8008f7,%r8
  800126:	00 00 00 
  800129:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80012f:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800132:	48 bf a0 52 80 00 00 	movabs $0x8052a0,%rdi
  800139:	00 00 00 
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
  800141:	48 ba 30 0b 80 00 00 	movabs $0x800b30,%rdx
  800148:	00 00 00 
  80014b:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014d:	48 b8 22 29 80 00 00 	movabs $0x802922,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800160:	79 30                	jns    800192 <umain+0x14f>
		panic("fork: %e", r);
  800162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800165:	89 c1                	mov    %eax,%ecx
  800167:	48 ba c4 52 80 00 00 	movabs $0x8052c4,%rdx
  80016e:	00 00 00 
  800171:	be 1a 00 00 00       	mov    $0x1a,%esi
  800176:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	49 b8 f7 08 80 00 00 	movabs $0x8008f7,%r8
  80018c:	00 00 00 
  80018f:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800192:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800196:	0f 85 fb 00 00 00    	jne    800297 <umain+0x254>
		dup(rfd, 0);
  80019c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	48 b8 9d 30 80 00 00 	movabs $0x80309d,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b5:	be 01 00 00 00       	mov    $0x1,%esi
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 9d 30 80 00 00 	movabs $0x80309d,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		close(rfd);
  8001c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
		close(wfd);
  8001d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	48 ba cd 52 80 00 00 	movabs $0x8052cd,%rdx
  8001f6:	00 00 00 
  8001f9:	48 be d0 52 80 00 00 	movabs $0x8052d0,%rsi
  800200:	00 00 00 
  800203:	48 bf d3 52 80 00 00 	movabs $0x8052d3,%rdi
  80020a:	00 00 00 
  80020d:	b8 00 00 00 00       	mov    $0x0,%eax
  800212:	49 b8 e5 3f 80 00 00 	movabs $0x803fe5,%r8
  800219:	00 00 00 
  80021c:	41 ff d0             	callq  *%r8
  80021f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800222:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800226:	79 30                	jns    800258 <umain+0x215>
			panic("spawn: %e", r);
  800228:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	48 ba db 52 80 00 00 	movabs $0x8052db,%rdx
  800234:	00 00 00 
  800237:	be 21 00 00 00       	mov    $0x21,%esi
  80023c:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	49 b8 f7 08 80 00 00 	movabs $0x8008f7,%r8
  800252:	00 00 00 
  800255:	41 ff d0             	callq  *%r8
		close(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
		close(1);
  800269:	bf 01 00 00 00       	mov    $0x1,%edi
  80026e:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
		wait(r);
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	89 c7                	mov    %eax,%edi
  80027f:	48 b8 fc 4d 80 00 00 	movabs $0x804dfc,%rax
  800286:	00 00 00 
  800289:	ff d0                	callq  *%rax
		exit();
  80028b:	48 b8 d4 08 80 00 00 	movabs $0x8008d4,%rax
  800292:	00 00 00 
  800295:	ff d0                	callq  *%rax
	}
	close(rfd);
  800297:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029a:	89 c7                	mov    %eax,%edi
  80029c:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
	close(wfd);
  8002a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ab:	89 c7                	mov    %eax,%edi
  8002ad:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	callq  *%rax
	cprintf("here\n");
  8002b9:	48 bf e5 52 80 00 00 	movabs $0x8052e5,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	48 ba 30 0b 80 00 00 	movabs $0x800b30,%rdx
  8002cf:	00 00 00 
  8002d2:	ff d2                	callq  *%rdx
	rfd = pfds[0];
  8002d4:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002d7:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002da:	be 00 00 00 00       	mov    $0x0,%esi
  8002df:	48 bf eb 52 80 00 00 	movabs $0x8052eb,%rdi
  8002e6:	00 00 00 
  8002e9:	48 b8 1c 37 80 00 00 	movabs $0x80371c,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax
  8002f5:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002fc:	79 30                	jns    80032e <umain+0x2eb>
		panic("open testshell.key for reading: %e", kfd);
  8002fe:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800301:	89 c1                	mov    %eax,%ecx
  800303:	48 ba 00 53 80 00 00 	movabs $0x805300,%rdx
  80030a:	00 00 00 
  80030d:	be 2c 00 00 00       	mov    $0x2c,%esi
  800312:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
  800319:	00 00 00 
  80031c:	b8 00 00 00 00       	mov    $0x0,%eax
  800321:	49 b8 f7 08 80 00 00 	movabs $0x8008f7,%r8
  800328:	00 00 00 
  80032b:	41 ff d0             	callq  *%r8

	nloff = 0;
  80032e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (off=0;; off++) {
  800335:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		n1 = read(rfd, &c1, 1);
  80033c:	48 8d 4d df          	lea    -0x21(%rbp),%rcx
  800340:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800343:	ba 01 00 00 00       	mov    $0x1,%edx
  800348:	48 89 ce             	mov    %rcx,%rsi
  80034b:	89 c7                	mov    %eax,%edi
  80034d:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  800354:	00 00 00 
  800357:	ff d0                	callq  *%rax
  800359:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  80035c:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800360:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800363:	ba 01 00 00 00       	mov    $0x1,%edx
  800368:	48 89 ce             	mov    %rcx,%rsi
  80036b:	89 c7                	mov    %eax,%edi
  80036d:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  800374:	00 00 00 
  800377:	ff d0                	callq  *%rax
  800379:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  80037c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800380:	79 30                	jns    8003b2 <umain+0x36f>
			panic("reading testshell.out: %e", n1);
  800382:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800385:	89 c1                	mov    %eax,%ecx
  800387:	48 ba 23 53 80 00 00 	movabs $0x805323,%rdx
  80038e:	00 00 00 
  800391:	be 33 00 00 00       	mov    $0x33,%esi
  800396:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
  80039d:	00 00 00 
  8003a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a5:	49 b8 f7 08 80 00 00 	movabs $0x8008f7,%r8
  8003ac:	00 00 00 
  8003af:	41 ff d0             	callq  *%r8
		if (n2 < 0)
  8003b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003b6:	79 30                	jns    8003e8 <umain+0x3a5>
			panic("reading testshell.key: %e", n2);
  8003b8:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003bb:	89 c1                	mov    %eax,%ecx
  8003bd:	48 ba 3d 53 80 00 00 	movabs $0x80533d,%rdx
  8003c4:	00 00 00 
  8003c7:	be 35 00 00 00       	mov    $0x35,%esi
  8003cc:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
  8003d3:	00 00 00 
  8003d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003db:	49 b8 f7 08 80 00 00 	movabs $0x8008f7,%r8
  8003e2:	00 00 00 
  8003e5:	41 ff d0             	callq  *%r8
		if (n1 == 0 && n2 == 0)
  8003e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8003ec:	75 08                	jne    8003f6 <umain+0x3b3>
  8003ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003f2:	75 02                	jne    8003f6 <umain+0x3b3>
			break;
  8003f4:	eb 4b                	jmp    800441 <umain+0x3fe>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8003f6:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003fa:	75 12                	jne    80040e <umain+0x3cb>
  8003fc:	83 7d e0 01          	cmpl   $0x1,-0x20(%rbp)
  800400:	75 0c                	jne    80040e <umain+0x3cb>
  800402:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  800406:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  80040a:	38 c2                	cmp    %al,%dl
  80040c:	74 19                	je     800427 <umain+0x3e4>
			wrong(rfd, kfd, nloff);
  80040e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800411:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  800414:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800417:	89 ce                	mov    %ecx,%esi
  800419:	89 c7                	mov    %eax,%edi
  80041b:	48 b8 5f 04 80 00 00 	movabs $0x80045f,%rax
  800422:	00 00 00 
  800425:	ff d0                	callq  *%rax
		if (c1 == '\n')
  800427:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80042b:	3c 0a                	cmp    $0xa,%al
  80042d:	75 09                	jne    800438 <umain+0x3f5>
			nloff = off+1;
  80042f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800432:	83 c0 01             	add    $0x1,%eax
  800435:	89 45 f8             	mov    %eax,-0x8(%rbp)
	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
  800438:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
  80043c:	e9 fb fe ff ff       	jmpq   80033c <umain+0x2f9>
	cprintf("shell ran correctly\n");
  800441:	48 bf 57 53 80 00 00 	movabs $0x805357,%rdi
  800448:	00 00 00 
  80044b:	b8 00 00 00 00       	mov    $0x0,%eax
  800450:	48 ba 30 0b 80 00 00 	movabs $0x800b30,%rdx
  800457:	00 00 00 
  80045a:	ff d2                	callq  *%rdx


    static __inline void
breakpoint(void)
{
    __asm __volatile("int3");
  80045c:	cc                   	int3   

	breakpoint();
}
  80045d:	c9                   	leaveq 
  80045e:	c3                   	retq   

000000000080045f <wrong>:

void
wrong(int rfd, int kfd, int off)
{
  80045f:	55                   	push   %rbp
  800460:	48 89 e5             	mov    %rsp,%rbp
  800463:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  800467:	89 7d 8c             	mov    %edi,-0x74(%rbp)
  80046a:	89 75 88             	mov    %esi,-0x78(%rbp)
  80046d:	89 55 84             	mov    %edx,-0x7c(%rbp)
	char buf[100];
	int n;

	seek(rfd, off);
  800470:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800473:	8b 45 8c             	mov    -0x74(%rbp),%eax
  800476:	89 d6                	mov    %edx,%esi
  800478:	89 c7                	mov    %eax,%edi
  80047a:	48 b8 64 34 80 00 00 	movabs $0x803464,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
	seek(kfd, off);
  800486:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800489:	8b 45 88             	mov    -0x78(%rbp),%eax
  80048c:	89 d6                	mov    %edx,%esi
  80048e:	89 c7                	mov    %eax,%edi
  800490:	48 b8 64 34 80 00 00 	movabs $0x803464,%rax
  800497:	00 00 00 
  80049a:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  80049c:	48 bf 70 53 80 00 00 	movabs $0x805370,%rdi
  8004a3:	00 00 00 
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	48 ba 30 0b 80 00 00 	movabs $0x800b30,%rdx
  8004b2:	00 00 00 
  8004b5:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  8004b7:	48 bf 92 53 80 00 00 	movabs $0x805392,%rdi
  8004be:	00 00 00 
  8004c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c6:	48 ba 30 0b 80 00 00 	movabs $0x800b30,%rdx
  8004cd:	00 00 00 
  8004d0:	ff d2                	callq  *%rdx
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004d2:	eb 1c                	jmp    8004f0 <wrong+0x91>
		sys_cputs(buf, n);
  8004d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d7:	48 63 d0             	movslq %eax,%rdx
  8004da:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004de:	48 89 d6             	mov    %rdx,%rsi
  8004e1:	48 89 c7             	mov    %rax,%rdi
  8004e4:	48 b8 0d 1f 80 00 00 	movabs $0x801f0d,%rax
  8004eb:	00 00 00 
  8004ee:	ff d0                	callq  *%rax
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004f0:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004f4:	8b 45 88             	mov    -0x78(%rbp),%eax
  8004f7:	ba 63 00 00 00       	mov    $0x63,%edx
  8004fc:	48 89 ce             	mov    %rcx,%rsi
  8004ff:	89 c7                	mov    %eax,%edi
  800501:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  800508:	00 00 00 
  80050b:	ff d0                	callq  *%rax
  80050d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800510:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800514:	7f be                	jg     8004d4 <wrong+0x75>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  800516:	48 bf a1 53 80 00 00 	movabs $0x8053a1,%rdi
  80051d:	00 00 00 
  800520:	b8 00 00 00 00       	mov    $0x0,%eax
  800525:	48 ba 30 0b 80 00 00 	movabs $0x800b30,%rdx
  80052c:	00 00 00 
  80052f:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800531:	eb 1c                	jmp    80054f <wrong+0xf0>
		sys_cputs(buf, n);
  800533:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800536:	48 63 d0             	movslq %eax,%rdx
  800539:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  80053d:	48 89 d6             	mov    %rdx,%rsi
  800540:	48 89 c7             	mov    %rax,%rdi
  800543:	48 b8 0d 1f 80 00 00 	movabs $0x801f0d,%rax
  80054a:	00 00 00 
  80054d:	ff d0                	callq  *%rax
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  80054f:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  800553:	8b 45 8c             	mov    -0x74(%rbp),%eax
  800556:	ba 63 00 00 00       	mov    $0x63,%edx
  80055b:	48 89 ce             	mov    %rcx,%rsi
  80055e:	89 c7                	mov    %eax,%edi
  800560:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  800567:	00 00 00 
  80056a:	ff d0                	callq  *%rax
  80056c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80056f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800573:	7f be                	jg     800533 <wrong+0xd4>
		sys_cputs(buf, n);
	cprintf("===\n");
  800575:	48 bf af 53 80 00 00 	movabs $0x8053af,%rdi
  80057c:	00 00 00 
  80057f:	b8 00 00 00 00       	mov    $0x0,%eax
  800584:	48 ba 30 0b 80 00 00 	movabs $0x800b30,%rdx
  80058b:	00 00 00 
  80058e:	ff d2                	callq  *%rdx
	exit();
  800590:	48 b8 d4 08 80 00 00 	movabs $0x8008d4,%rax
  800597:	00 00 00 
  80059a:	ff d0                	callq  *%rax
}
  80059c:	c9                   	leaveq 
  80059d:	c3                   	retq   

000000000080059e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80059e:	55                   	push   %rbp
  80059f:	48 89 e5             	mov    %rsp,%rbp
  8005a2:	48 83 ec 20          	sub    $0x20,%rsp
  8005a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8005a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8005ac:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8005af:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8005b3:	be 01 00 00 00       	mov    $0x1,%esi
  8005b8:	48 89 c7             	mov    %rax,%rdi
  8005bb:	48 b8 0d 1f 80 00 00 	movabs $0x801f0d,%rax
  8005c2:	00 00 00 
  8005c5:	ff d0                	callq  *%rax
}
  8005c7:	c9                   	leaveq 
  8005c8:	c3                   	retq   

00000000008005c9 <getchar>:

int
getchar(void)
{
  8005c9:	55                   	push   %rbp
  8005ca:	48 89 e5             	mov    %rsp,%rbp
  8005cd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8005d1:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8005d5:	ba 01 00 00 00       	mov    $0x1,%edx
  8005da:	48 89 c6             	mov    %rax,%rsi
  8005dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8005e2:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  8005e9:	00 00 00 
  8005ec:	ff d0                	callq  *%rax
  8005ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8005f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005f5:	79 05                	jns    8005fc <getchar+0x33>
		return r;
  8005f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005fa:	eb 14                	jmp    800610 <getchar+0x47>
	if (r < 1)
  8005fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800600:	7f 07                	jg     800609 <getchar+0x40>
		return -E_EOF;
  800602:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800607:	eb 07                	jmp    800610 <getchar+0x47>
	return c;
  800609:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80060d:	0f b6 c0             	movzbl %al,%eax
}
  800610:	c9                   	leaveq 
  800611:	c3                   	retq   

0000000000800612 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800612:	55                   	push   %rbp
  800613:	48 89 e5             	mov    %rsp,%rbp
  800616:	48 83 ec 20          	sub    $0x20,%rsp
  80061a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80061d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800621:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800624:	48 89 d6             	mov    %rdx,%rsi
  800627:	89 c7                	mov    %eax,%edi
  800629:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  800630:	00 00 00 
  800633:	ff d0                	callq  *%rax
  800635:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800638:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80063c:	79 05                	jns    800643 <iscons+0x31>
		return r;
  80063e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800641:	eb 1a                	jmp    80065d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800643:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800647:	8b 10                	mov    (%rax),%edx
  800649:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800650:	00 00 00 
  800653:	8b 00                	mov    (%rax),%eax
  800655:	39 c2                	cmp    %eax,%edx
  800657:	0f 94 c0             	sete   %al
  80065a:	0f b6 c0             	movzbl %al,%eax
}
  80065d:	c9                   	leaveq 
  80065e:	c3                   	retq   

000000000080065f <opencons>:

int
opencons(void)
{
  80065f:	55                   	push   %rbp
  800660:	48 89 e5             	mov    %rsp,%rbp
  800663:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800667:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80066b:	48 89 c7             	mov    %rax,%rdi
  80066e:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  800675:	00 00 00 
  800678:	ff d0                	callq  *%rax
  80067a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80067d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800681:	79 05                	jns    800688 <opencons+0x29>
		return r;
  800683:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800686:	eb 5b                	jmp    8006e3 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068c:	ba 07 04 00 00       	mov    $0x407,%edx
  800691:	48 89 c6             	mov    %rax,%rsi
  800694:	bf 00 00 00 00       	mov    $0x0,%edi
  800699:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  8006a0:	00 00 00 
  8006a3:	ff d0                	callq  *%rax
  8006a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8006a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006ac:	79 05                	jns    8006b3 <opencons+0x54>
		return r;
  8006ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8006b1:	eb 30                	jmp    8006e3 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8006b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b7:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8006be:	00 00 00 
  8006c1:	8b 12                	mov    (%rdx),%edx
  8006c3:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8006c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006c9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8006d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006d4:	48 89 c7             	mov    %rax,%rdi
  8006d7:	48 b8 2e 2d 80 00 00 	movabs $0x802d2e,%rax
  8006de:	00 00 00 
  8006e1:	ff d0                	callq  *%rax
}
  8006e3:	c9                   	leaveq 
  8006e4:	c3                   	retq   

00000000008006e5 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8006e5:	55                   	push   %rbp
  8006e6:	48 89 e5             	mov    %rsp,%rbp
  8006e9:	48 83 ec 30          	sub    $0x30,%rsp
  8006ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8006f9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8006fe:	75 07                	jne    800707 <devcons_read+0x22>
		return 0;
  800700:	b8 00 00 00 00       	mov    $0x0,%eax
  800705:	eb 4b                	jmp    800752 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800707:	eb 0c                	jmp    800715 <devcons_read+0x30>
		sys_yield();
  800709:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  800710:	00 00 00 
  800713:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800715:	48 b8 57 1f 80 00 00 	movabs $0x801f57,%rax
  80071c:	00 00 00 
  80071f:	ff d0                	callq  *%rax
  800721:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800724:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800728:	74 df                	je     800709 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80072a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80072e:	79 05                	jns    800735 <devcons_read+0x50>
		return c;
  800730:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800733:	eb 1d                	jmp    800752 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  800735:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800739:	75 07                	jne    800742 <devcons_read+0x5d>
		return 0;
  80073b:	b8 00 00 00 00       	mov    $0x0,%eax
  800740:	eb 10                	jmp    800752 <devcons_read+0x6d>
	*(char*)vbuf = c;
  800742:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800745:	89 c2                	mov    %eax,%edx
  800747:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80074b:	88 10                	mov    %dl,(%rax)
	return 1;
  80074d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800752:	c9                   	leaveq 
  800753:	c3                   	retq   

0000000000800754 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800754:	55                   	push   %rbp
  800755:	48 89 e5             	mov    %rsp,%rbp
  800758:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80075f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  800766:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80076d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800774:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80077b:	eb 76                	jmp    8007f3 <devcons_write+0x9f>
		m = n - tot;
  80077d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800784:	89 c2                	mov    %eax,%edx
  800786:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800789:	29 c2                	sub    %eax,%edx
  80078b:	89 d0                	mov    %edx,%eax
  80078d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  800790:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800793:	83 f8 7f             	cmp    $0x7f,%eax
  800796:	76 07                	jbe    80079f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  800798:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80079f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007a2:	48 63 d0             	movslq %eax,%rdx
  8007a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007a8:	48 63 c8             	movslq %eax,%rcx
  8007ab:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8007b2:	48 01 c1             	add    %rax,%rcx
  8007b5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007bc:	48 89 ce             	mov    %rcx,%rsi
  8007bf:	48 89 c7             	mov    %rax,%rdi
  8007c2:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  8007c9:	00 00 00 
  8007cc:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8007ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007d1:	48 63 d0             	movslq %eax,%rdx
  8007d4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007db:	48 89 d6             	mov    %rdx,%rsi
  8007de:	48 89 c7             	mov    %rax,%rdi
  8007e1:	48 b8 0d 1f 80 00 00 	movabs $0x801f0d,%rax
  8007e8:	00 00 00 
  8007eb:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8007ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007f0:	01 45 fc             	add    %eax,-0x4(%rbp)
  8007f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007f6:	48 98                	cltq   
  8007f8:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8007ff:	0f 82 78 ff ff ff    	jb     80077d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  800805:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800808:	c9                   	leaveq 
  800809:	c3                   	retq   

000000000080080a <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80080a:	55                   	push   %rbp
  80080b:	48 89 e5             	mov    %rsp,%rbp
  80080e:	48 83 ec 08          	sub    $0x8,%rsp
  800812:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80081b:	c9                   	leaveq 
  80081c:	c3                   	retq   

000000000080081d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80081d:	55                   	push   %rbp
  80081e:	48 89 e5             	mov    %rsp,%rbp
  800821:	48 83 ec 10          	sub    $0x10,%rsp
  800825:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800829:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80082d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800831:	48 be b9 53 80 00 00 	movabs $0x8053b9,%rsi
  800838:	00 00 00 
  80083b:	48 89 c7             	mov    %rax,%rdi
  80083e:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  800845:	00 00 00 
  800848:	ff d0                	callq  *%rax
	return 0;
  80084a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80084f:	c9                   	leaveq 
  800850:	c3                   	retq   

0000000000800851 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800851:	55                   	push   %rbp
  800852:	48 89 e5             	mov    %rsp,%rbp
  800855:	48 83 ec 10          	sub    $0x10,%rsp
  800859:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80085c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  800860:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  800867:	00 00 00 
  80086a:	ff d0                	callq  *%rax
  80086c:	48 98                	cltq   
  80086e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800873:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  80087a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800881:	00 00 00 
  800884:	48 01 c2             	add    %rax,%rdx
  800887:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80088e:	00 00 00 
  800891:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800894:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800898:	7e 14                	jle    8008ae <libmain+0x5d>
		binaryname = argv[0];
  80089a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80089e:	48 8b 10             	mov    (%rax),%rdx
  8008a1:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  8008a8:	00 00 00 
  8008ab:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8008ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008b5:	48 89 d6             	mov    %rdx,%rsi
  8008b8:	89 c7                	mov    %eax,%edi
  8008ba:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8008c1:	00 00 00 
  8008c4:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8008c6:	48 b8 d4 08 80 00 00 	movabs $0x8008d4,%rax
  8008cd:	00 00 00 
  8008d0:	ff d0                	callq  *%rax
}
  8008d2:	c9                   	leaveq 
  8008d3:	c3                   	retq   

00000000008008d4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008d4:	55                   	push   %rbp
  8008d5:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8008d8:	48 b8 6f 30 80 00 00 	movabs $0x80306f,%rax
  8008df:	00 00 00 
  8008e2:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8008e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8008e9:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  8008f0:	00 00 00 
  8008f3:	ff d0                	callq  *%rax
}
  8008f5:	5d                   	pop    %rbp
  8008f6:	c3                   	retq   

00000000008008f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008f7:	55                   	push   %rbp
  8008f8:	48 89 e5             	mov    %rsp,%rbp
  8008fb:	53                   	push   %rbx
  8008fc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800903:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80090a:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800910:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800917:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80091e:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800925:	84 c0                	test   %al,%al
  800927:	74 23                	je     80094c <_panic+0x55>
  800929:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800930:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800934:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800938:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80093c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800940:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800944:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800948:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80094c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800953:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80095a:	00 00 00 
  80095d:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800964:	00 00 00 
  800967:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80096b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800972:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800979:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800980:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  800987:	00 00 00 
  80098a:	48 8b 18             	mov    (%rax),%rbx
  80098d:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  800994:	00 00 00 
  800997:	ff d0                	callq  *%rax
  800999:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80099f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8009a6:	41 89 c8             	mov    %ecx,%r8d
  8009a9:	48 89 d1             	mov    %rdx,%rcx
  8009ac:	48 89 da             	mov    %rbx,%rdx
  8009af:	89 c6                	mov    %eax,%esi
  8009b1:	48 bf d0 53 80 00 00 	movabs $0x8053d0,%rdi
  8009b8:	00 00 00 
  8009bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c0:	49 b9 30 0b 80 00 00 	movabs $0x800b30,%r9
  8009c7:	00 00 00 
  8009ca:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8009cd:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8009d4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8009db:	48 89 d6             	mov    %rdx,%rsi
  8009de:	48 89 c7             	mov    %rax,%rdi
  8009e1:	48 b8 84 0a 80 00 00 	movabs $0x800a84,%rax
  8009e8:	00 00 00 
  8009eb:	ff d0                	callq  *%rax
	cprintf("\n");
  8009ed:	48 bf f3 53 80 00 00 	movabs $0x8053f3,%rdi
  8009f4:	00 00 00 
  8009f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fc:	48 ba 30 0b 80 00 00 	movabs $0x800b30,%rdx
  800a03:	00 00 00 
  800a06:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800a08:	cc                   	int3   
  800a09:	eb fd                	jmp    800a08 <_panic+0x111>

0000000000800a0b <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800a0b:	55                   	push   %rbp
  800a0c:	48 89 e5             	mov    %rsp,%rbp
  800a0f:	48 83 ec 10          	sub    $0x10,%rsp
  800a13:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a16:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800a1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a1e:	8b 00                	mov    (%rax),%eax
  800a20:	8d 48 01             	lea    0x1(%rax),%ecx
  800a23:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a27:	89 0a                	mov    %ecx,(%rdx)
  800a29:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a2c:	89 d1                	mov    %edx,%ecx
  800a2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a32:	48 98                	cltq   
  800a34:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800a38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a3c:	8b 00                	mov    (%rax),%eax
  800a3e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a43:	75 2c                	jne    800a71 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800a45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a49:	8b 00                	mov    (%rax),%eax
  800a4b:	48 98                	cltq   
  800a4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a51:	48 83 c2 08          	add    $0x8,%rdx
  800a55:	48 89 c6             	mov    %rax,%rsi
  800a58:	48 89 d7             	mov    %rdx,%rdi
  800a5b:	48 b8 0d 1f 80 00 00 	movabs $0x801f0d,%rax
  800a62:	00 00 00 
  800a65:	ff d0                	callq  *%rax
        b->idx = 0;
  800a67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a6b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800a71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a75:	8b 40 04             	mov    0x4(%rax),%eax
  800a78:	8d 50 01             	lea    0x1(%rax),%edx
  800a7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a7f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800a82:	c9                   	leaveq 
  800a83:	c3                   	retq   

0000000000800a84 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800a84:	55                   	push   %rbp
  800a85:	48 89 e5             	mov    %rsp,%rbp
  800a88:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800a8f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800a96:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800a9d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800aa4:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800aab:	48 8b 0a             	mov    (%rdx),%rcx
  800aae:	48 89 08             	mov    %rcx,(%rax)
  800ab1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ab5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ab9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800abd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800ac1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800ac8:	00 00 00 
    b.cnt = 0;
  800acb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800ad2:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800ad5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800adc:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800ae3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800aea:	48 89 c6             	mov    %rax,%rsi
  800aed:	48 bf 0b 0a 80 00 00 	movabs $0x800a0b,%rdi
  800af4:	00 00 00 
  800af7:	48 b8 e3 0e 80 00 00 	movabs $0x800ee3,%rax
  800afe:	00 00 00 
  800b01:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800b03:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800b09:	48 98                	cltq   
  800b0b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800b12:	48 83 c2 08          	add    $0x8,%rdx
  800b16:	48 89 c6             	mov    %rax,%rsi
  800b19:	48 89 d7             	mov    %rdx,%rdi
  800b1c:	48 b8 0d 1f 80 00 00 	movabs $0x801f0d,%rax
  800b23:	00 00 00 
  800b26:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800b28:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b2e:	c9                   	leaveq 
  800b2f:	c3                   	retq   

0000000000800b30 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800b30:	55                   	push   %rbp
  800b31:	48 89 e5             	mov    %rsp,%rbp
  800b34:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b3b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b42:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b49:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b50:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b57:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b5e:	84 c0                	test   %al,%al
  800b60:	74 20                	je     800b82 <cprintf+0x52>
  800b62:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b66:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b6a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b6e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b72:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b76:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b7a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b7e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b82:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800b89:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800b90:	00 00 00 
  800b93:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800b9a:	00 00 00 
  800b9d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ba1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ba8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800baf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800bb6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800bbd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800bc4:	48 8b 0a             	mov    (%rdx),%rcx
  800bc7:	48 89 08             	mov    %rcx,(%rax)
  800bca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bce:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bd2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bd6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800bda:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800be1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800be8:	48 89 d6             	mov    %rdx,%rsi
  800beb:	48 89 c7             	mov    %rax,%rdi
  800bee:	48 b8 84 0a 80 00 00 	movabs $0x800a84,%rax
  800bf5:	00 00 00 
  800bf8:	ff d0                	callq  *%rax
  800bfa:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800c00:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800c06:	c9                   	leaveq 
  800c07:	c3                   	retq   

0000000000800c08 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c08:	55                   	push   %rbp
  800c09:	48 89 e5             	mov    %rsp,%rbp
  800c0c:	53                   	push   %rbx
  800c0d:	48 83 ec 38          	sub    $0x38,%rsp
  800c11:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c15:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c19:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800c1d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800c20:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800c24:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c28:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800c2b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c2f:	77 3b                	ja     800c6c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c31:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800c34:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800c38:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800c3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c44:	48 f7 f3             	div    %rbx
  800c47:	48 89 c2             	mov    %rax,%rdx
  800c4a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800c4d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c50:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800c54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c58:	41 89 f9             	mov    %edi,%r9d
  800c5b:	48 89 c7             	mov    %rax,%rdi
  800c5e:	48 b8 08 0c 80 00 00 	movabs $0x800c08,%rax
  800c65:	00 00 00 
  800c68:	ff d0                	callq  *%rax
  800c6a:	eb 1e                	jmp    800c8a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c6c:	eb 12                	jmp    800c80 <printnum+0x78>
			putch(padc, putdat);
  800c6e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800c72:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800c75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c79:	48 89 ce             	mov    %rcx,%rsi
  800c7c:	89 d7                	mov    %edx,%edi
  800c7e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c80:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800c84:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800c88:	7f e4                	jg     800c6e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c8a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c91:	ba 00 00 00 00       	mov    $0x0,%edx
  800c96:	48 f7 f1             	div    %rcx
  800c99:	48 89 d0             	mov    %rdx,%rax
  800c9c:	48 ba f0 55 80 00 00 	movabs $0x8055f0,%rdx
  800ca3:	00 00 00 
  800ca6:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800caa:	0f be d0             	movsbl %al,%edx
  800cad:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800cb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb5:	48 89 ce             	mov    %rcx,%rsi
  800cb8:	89 d7                	mov    %edx,%edi
  800cba:	ff d0                	callq  *%rax
}
  800cbc:	48 83 c4 38          	add    $0x38,%rsp
  800cc0:	5b                   	pop    %rbx
  800cc1:	5d                   	pop    %rbp
  800cc2:	c3                   	retq   

0000000000800cc3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cc3:	55                   	push   %rbp
  800cc4:	48 89 e5             	mov    %rsp,%rbp
  800cc7:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ccb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ccf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800cd2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800cd6:	7e 52                	jle    800d2a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800cd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cdc:	8b 00                	mov    (%rax),%eax
  800cde:	83 f8 30             	cmp    $0x30,%eax
  800ce1:	73 24                	jae    800d07 <getuint+0x44>
  800ce3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ceb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cef:	8b 00                	mov    (%rax),%eax
  800cf1:	89 c0                	mov    %eax,%eax
  800cf3:	48 01 d0             	add    %rdx,%rax
  800cf6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cfa:	8b 12                	mov    (%rdx),%edx
  800cfc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d03:	89 0a                	mov    %ecx,(%rdx)
  800d05:	eb 17                	jmp    800d1e <getuint+0x5b>
  800d07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d0b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d0f:	48 89 d0             	mov    %rdx,%rax
  800d12:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d1a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d1e:	48 8b 00             	mov    (%rax),%rax
  800d21:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d25:	e9 a3 00 00 00       	jmpq   800dcd <getuint+0x10a>
	else if (lflag)
  800d2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d2e:	74 4f                	je     800d7f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800d30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d34:	8b 00                	mov    (%rax),%eax
  800d36:	83 f8 30             	cmp    $0x30,%eax
  800d39:	73 24                	jae    800d5f <getuint+0x9c>
  800d3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d3f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d47:	8b 00                	mov    (%rax),%eax
  800d49:	89 c0                	mov    %eax,%eax
  800d4b:	48 01 d0             	add    %rdx,%rax
  800d4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d52:	8b 12                	mov    (%rdx),%edx
  800d54:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d5b:	89 0a                	mov    %ecx,(%rdx)
  800d5d:	eb 17                	jmp    800d76 <getuint+0xb3>
  800d5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d63:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d67:	48 89 d0             	mov    %rdx,%rax
  800d6a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d6e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d72:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d76:	48 8b 00             	mov    (%rax),%rax
  800d79:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d7d:	eb 4e                	jmp    800dcd <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800d7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d83:	8b 00                	mov    (%rax),%eax
  800d85:	83 f8 30             	cmp    $0x30,%eax
  800d88:	73 24                	jae    800dae <getuint+0xeb>
  800d8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d8e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d96:	8b 00                	mov    (%rax),%eax
  800d98:	89 c0                	mov    %eax,%eax
  800d9a:	48 01 d0             	add    %rdx,%rax
  800d9d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da1:	8b 12                	mov    (%rdx),%edx
  800da3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800da6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800daa:	89 0a                	mov    %ecx,(%rdx)
  800dac:	eb 17                	jmp    800dc5 <getuint+0x102>
  800dae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800db6:	48 89 d0             	mov    %rdx,%rax
  800db9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800dbd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dc1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800dc5:	8b 00                	mov    (%rax),%eax
  800dc7:	89 c0                	mov    %eax,%eax
  800dc9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800dcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800dd1:	c9                   	leaveq 
  800dd2:	c3                   	retq   

0000000000800dd3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dd3:	55                   	push   %rbp
  800dd4:	48 89 e5             	mov    %rsp,%rbp
  800dd7:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ddb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ddf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800de2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800de6:	7e 52                	jle    800e3a <getint+0x67>
		x=va_arg(*ap, long long);
  800de8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dec:	8b 00                	mov    (%rax),%eax
  800dee:	83 f8 30             	cmp    $0x30,%eax
  800df1:	73 24                	jae    800e17 <getint+0x44>
  800df3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800dfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dff:	8b 00                	mov    (%rax),%eax
  800e01:	89 c0                	mov    %eax,%eax
  800e03:	48 01 d0             	add    %rdx,%rax
  800e06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e0a:	8b 12                	mov    (%rdx),%edx
  800e0c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e13:	89 0a                	mov    %ecx,(%rdx)
  800e15:	eb 17                	jmp    800e2e <getint+0x5b>
  800e17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e1f:	48 89 d0             	mov    %rdx,%rax
  800e22:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e2a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e2e:	48 8b 00             	mov    (%rax),%rax
  800e31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e35:	e9 a3 00 00 00       	jmpq   800edd <getint+0x10a>
	else if (lflag)
  800e3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e3e:	74 4f                	je     800e8f <getint+0xbc>
		x=va_arg(*ap, long);
  800e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e44:	8b 00                	mov    (%rax),%eax
  800e46:	83 f8 30             	cmp    $0x30,%eax
  800e49:	73 24                	jae    800e6f <getint+0x9c>
  800e4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e57:	8b 00                	mov    (%rax),%eax
  800e59:	89 c0                	mov    %eax,%eax
  800e5b:	48 01 d0             	add    %rdx,%rax
  800e5e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e62:	8b 12                	mov    (%rdx),%edx
  800e64:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e6b:	89 0a                	mov    %ecx,(%rdx)
  800e6d:	eb 17                	jmp    800e86 <getint+0xb3>
  800e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e73:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e77:	48 89 d0             	mov    %rdx,%rax
  800e7a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e82:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e86:	48 8b 00             	mov    (%rax),%rax
  800e89:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e8d:	eb 4e                	jmp    800edd <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800e8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e93:	8b 00                	mov    (%rax),%eax
  800e95:	83 f8 30             	cmp    $0x30,%eax
  800e98:	73 24                	jae    800ebe <getint+0xeb>
  800e9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ea2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea6:	8b 00                	mov    (%rax),%eax
  800ea8:	89 c0                	mov    %eax,%eax
  800eaa:	48 01 d0             	add    %rdx,%rax
  800ead:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eb1:	8b 12                	mov    (%rdx),%edx
  800eb3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800eb6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eba:	89 0a                	mov    %ecx,(%rdx)
  800ebc:	eb 17                	jmp    800ed5 <getint+0x102>
  800ebe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ec6:	48 89 d0             	mov    %rdx,%rax
  800ec9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ecd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ed1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ed5:	8b 00                	mov    (%rax),%eax
  800ed7:	48 98                	cltq   
  800ed9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800edd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ee1:	c9                   	leaveq 
  800ee2:	c3                   	retq   

0000000000800ee3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ee3:	55                   	push   %rbp
  800ee4:	48 89 e5             	mov    %rsp,%rbp
  800ee7:	41 54                	push   %r12
  800ee9:	53                   	push   %rbx
  800eea:	48 83 ec 60          	sub    $0x60,%rsp
  800eee:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ef2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ef6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800efa:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800efe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f02:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800f06:	48 8b 0a             	mov    (%rdx),%rcx
  800f09:	48 89 08             	mov    %rcx,(%rax)
  800f0c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f10:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f14:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f18:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f1c:	eb 28                	jmp    800f46 <vprintfmt+0x63>
			if (ch == '\0'){
  800f1e:	85 db                	test   %ebx,%ebx
  800f20:	75 15                	jne    800f37 <vprintfmt+0x54>
				current_color=WHITE;
  800f22:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800f29:	00 00 00 
  800f2c:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800f32:	e9 fc 04 00 00       	jmpq   801433 <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  800f37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f3f:	48 89 d6             	mov    %rdx,%rsi
  800f42:	89 df                	mov    %ebx,%edi
  800f44:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f46:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f4a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f4e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f52:	0f b6 00             	movzbl (%rax),%eax
  800f55:	0f b6 d8             	movzbl %al,%ebx
  800f58:	83 fb 25             	cmp    $0x25,%ebx
  800f5b:	75 c1                	jne    800f1e <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f5d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800f61:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800f68:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800f6f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800f76:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f7d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f81:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f85:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f89:	0f b6 00             	movzbl (%rax),%eax
  800f8c:	0f b6 d8             	movzbl %al,%ebx
  800f8f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800f92:	83 f8 55             	cmp    $0x55,%eax
  800f95:	0f 87 64 04 00 00    	ja     8013ff <vprintfmt+0x51c>
  800f9b:	89 c0                	mov    %eax,%eax
  800f9d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800fa4:	00 
  800fa5:	48 b8 18 56 80 00 00 	movabs $0x805618,%rax
  800fac:	00 00 00 
  800faf:	48 01 d0             	add    %rdx,%rax
  800fb2:	48 8b 00             	mov    (%rax),%rax
  800fb5:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800fb7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800fbb:	eb c0                	jmp    800f7d <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fbd:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800fc1:	eb ba                	jmp    800f7d <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fc3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800fca:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800fcd:	89 d0                	mov    %edx,%eax
  800fcf:	c1 e0 02             	shl    $0x2,%eax
  800fd2:	01 d0                	add    %edx,%eax
  800fd4:	01 c0                	add    %eax,%eax
  800fd6:	01 d8                	add    %ebx,%eax
  800fd8:	83 e8 30             	sub    $0x30,%eax
  800fdb:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800fde:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fe2:	0f b6 00             	movzbl (%rax),%eax
  800fe5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fe8:	83 fb 2f             	cmp    $0x2f,%ebx
  800feb:	7e 0c                	jle    800ff9 <vprintfmt+0x116>
  800fed:	83 fb 39             	cmp    $0x39,%ebx
  800ff0:	7f 07                	jg     800ff9 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ff2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ff7:	eb d1                	jmp    800fca <vprintfmt+0xe7>
			goto process_precision;
  800ff9:	eb 58                	jmp    801053 <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800ffb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ffe:	83 f8 30             	cmp    $0x30,%eax
  801001:	73 17                	jae    80101a <vprintfmt+0x137>
  801003:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801007:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80100a:	89 c0                	mov    %eax,%eax
  80100c:	48 01 d0             	add    %rdx,%rax
  80100f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801012:	83 c2 08             	add    $0x8,%edx
  801015:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801018:	eb 0f                	jmp    801029 <vprintfmt+0x146>
  80101a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80101e:	48 89 d0             	mov    %rdx,%rax
  801021:	48 83 c2 08          	add    $0x8,%rdx
  801025:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801029:	8b 00                	mov    (%rax),%eax
  80102b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80102e:	eb 23                	jmp    801053 <vprintfmt+0x170>

		case '.':
			if (width < 0)
  801030:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801034:	79 0c                	jns    801042 <vprintfmt+0x15f>
				width = 0;
  801036:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80103d:	e9 3b ff ff ff       	jmpq   800f7d <vprintfmt+0x9a>
  801042:	e9 36 ff ff ff       	jmpq   800f7d <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  801047:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80104e:	e9 2a ff ff ff       	jmpq   800f7d <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  801053:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801057:	79 12                	jns    80106b <vprintfmt+0x188>
				width = precision, precision = -1;
  801059:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80105c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80105f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801066:	e9 12 ff ff ff       	jmpq   800f7d <vprintfmt+0x9a>
  80106b:	e9 0d ff ff ff       	jmpq   800f7d <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801070:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801074:	e9 04 ff ff ff       	jmpq   800f7d <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801079:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80107c:	83 f8 30             	cmp    $0x30,%eax
  80107f:	73 17                	jae    801098 <vprintfmt+0x1b5>
  801081:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801085:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801088:	89 c0                	mov    %eax,%eax
  80108a:	48 01 d0             	add    %rdx,%rax
  80108d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801090:	83 c2 08             	add    $0x8,%edx
  801093:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801096:	eb 0f                	jmp    8010a7 <vprintfmt+0x1c4>
  801098:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80109c:	48 89 d0             	mov    %rdx,%rax
  80109f:	48 83 c2 08          	add    $0x8,%rdx
  8010a3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010a7:	8b 10                	mov    (%rax),%edx
  8010a9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8010ad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010b1:	48 89 ce             	mov    %rcx,%rsi
  8010b4:	89 d7                	mov    %edx,%edi
  8010b6:	ff d0                	callq  *%rax
			break;
  8010b8:	e9 70 03 00 00       	jmpq   80142d <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8010bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010c0:	83 f8 30             	cmp    $0x30,%eax
  8010c3:	73 17                	jae    8010dc <vprintfmt+0x1f9>
  8010c5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010cc:	89 c0                	mov    %eax,%eax
  8010ce:	48 01 d0             	add    %rdx,%rax
  8010d1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010d4:	83 c2 08             	add    $0x8,%edx
  8010d7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010da:	eb 0f                	jmp    8010eb <vprintfmt+0x208>
  8010dc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010e0:	48 89 d0             	mov    %rdx,%rax
  8010e3:	48 83 c2 08          	add    $0x8,%rdx
  8010e7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010eb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8010ed:	85 db                	test   %ebx,%ebx
  8010ef:	79 02                	jns    8010f3 <vprintfmt+0x210>
				err = -err;
  8010f1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8010f3:	83 fb 15             	cmp    $0x15,%ebx
  8010f6:	7f 16                	jg     80110e <vprintfmt+0x22b>
  8010f8:	48 b8 40 55 80 00 00 	movabs $0x805540,%rax
  8010ff:	00 00 00 
  801102:	48 63 d3             	movslq %ebx,%rdx
  801105:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801109:	4d 85 e4             	test   %r12,%r12
  80110c:	75 2e                	jne    80113c <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  80110e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801112:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801116:	89 d9                	mov    %ebx,%ecx
  801118:	48 ba 01 56 80 00 00 	movabs $0x805601,%rdx
  80111f:	00 00 00 
  801122:	48 89 c7             	mov    %rax,%rdi
  801125:	b8 00 00 00 00       	mov    $0x0,%eax
  80112a:	49 b8 3c 14 80 00 00 	movabs $0x80143c,%r8
  801131:	00 00 00 
  801134:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801137:	e9 f1 02 00 00       	jmpq   80142d <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80113c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801140:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801144:	4c 89 e1             	mov    %r12,%rcx
  801147:	48 ba 0a 56 80 00 00 	movabs $0x80560a,%rdx
  80114e:	00 00 00 
  801151:	48 89 c7             	mov    %rax,%rdi
  801154:	b8 00 00 00 00       	mov    $0x0,%eax
  801159:	49 b8 3c 14 80 00 00 	movabs $0x80143c,%r8
  801160:	00 00 00 
  801163:	41 ff d0             	callq  *%r8
			break;
  801166:	e9 c2 02 00 00       	jmpq   80142d <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80116b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80116e:	83 f8 30             	cmp    $0x30,%eax
  801171:	73 17                	jae    80118a <vprintfmt+0x2a7>
  801173:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801177:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80117a:	89 c0                	mov    %eax,%eax
  80117c:	48 01 d0             	add    %rdx,%rax
  80117f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801182:	83 c2 08             	add    $0x8,%edx
  801185:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801188:	eb 0f                	jmp    801199 <vprintfmt+0x2b6>
  80118a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80118e:	48 89 d0             	mov    %rdx,%rax
  801191:	48 83 c2 08          	add    $0x8,%rdx
  801195:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801199:	4c 8b 20             	mov    (%rax),%r12
  80119c:	4d 85 e4             	test   %r12,%r12
  80119f:	75 0a                	jne    8011ab <vprintfmt+0x2c8>
				p = "(null)";
  8011a1:	49 bc 0d 56 80 00 00 	movabs $0x80560d,%r12
  8011a8:	00 00 00 
			if (width > 0 && padc != '-')
  8011ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011af:	7e 3f                	jle    8011f0 <vprintfmt+0x30d>
  8011b1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8011b5:	74 39                	je     8011f0 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  8011b7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8011ba:	48 98                	cltq   
  8011bc:	48 89 c6             	mov    %rax,%rsi
  8011bf:	4c 89 e7             	mov    %r12,%rdi
  8011c2:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  8011c9:	00 00 00 
  8011cc:	ff d0                	callq  *%rax
  8011ce:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8011d1:	eb 17                	jmp    8011ea <vprintfmt+0x307>
					putch(padc, putdat);
  8011d3:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8011d7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8011db:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011df:	48 89 ce             	mov    %rcx,%rsi
  8011e2:	89 d7                	mov    %edx,%edi
  8011e4:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8011e6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011ee:	7f e3                	jg     8011d3 <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011f0:	eb 37                	jmp    801229 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  8011f2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8011f6:	74 1e                	je     801216 <vprintfmt+0x333>
  8011f8:	83 fb 1f             	cmp    $0x1f,%ebx
  8011fb:	7e 05                	jle    801202 <vprintfmt+0x31f>
  8011fd:	83 fb 7e             	cmp    $0x7e,%ebx
  801200:	7e 14                	jle    801216 <vprintfmt+0x333>
					putch('?', putdat);
  801202:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801206:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80120a:	48 89 d6             	mov    %rdx,%rsi
  80120d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801212:	ff d0                	callq  *%rax
  801214:	eb 0f                	jmp    801225 <vprintfmt+0x342>
				else
					putch(ch, putdat);
  801216:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80121a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80121e:	48 89 d6             	mov    %rdx,%rsi
  801221:	89 df                	mov    %ebx,%edi
  801223:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801225:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801229:	4c 89 e0             	mov    %r12,%rax
  80122c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801230:	0f b6 00             	movzbl (%rax),%eax
  801233:	0f be d8             	movsbl %al,%ebx
  801236:	85 db                	test   %ebx,%ebx
  801238:	74 10                	je     80124a <vprintfmt+0x367>
  80123a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80123e:	78 b2                	js     8011f2 <vprintfmt+0x30f>
  801240:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801244:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801248:	79 a8                	jns    8011f2 <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80124a:	eb 16                	jmp    801262 <vprintfmt+0x37f>
				putch(' ', putdat);
  80124c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801250:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801254:	48 89 d6             	mov    %rdx,%rsi
  801257:	bf 20 00 00 00       	mov    $0x20,%edi
  80125c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80125e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801262:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801266:	7f e4                	jg     80124c <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  801268:	e9 c0 01 00 00       	jmpq   80142d <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80126d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801271:	be 03 00 00 00       	mov    $0x3,%esi
  801276:	48 89 c7             	mov    %rax,%rdi
  801279:	48 b8 d3 0d 80 00 00 	movabs $0x800dd3,%rax
  801280:	00 00 00 
  801283:	ff d0                	callq  *%rax
  801285:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801289:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128d:	48 85 c0             	test   %rax,%rax
  801290:	79 1d                	jns    8012af <vprintfmt+0x3cc>
				putch('-', putdat);
  801292:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801296:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80129a:	48 89 d6             	mov    %rdx,%rsi
  80129d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8012a2:	ff d0                	callq  *%rax
				num = -(long long) num;
  8012a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a8:	48 f7 d8             	neg    %rax
  8012ab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8012af:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012b6:	e9 d5 00 00 00       	jmpq   801390 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8012bb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012bf:	be 03 00 00 00       	mov    $0x3,%esi
  8012c4:	48 89 c7             	mov    %rax,%rdi
  8012c7:	48 b8 c3 0c 80 00 00 	movabs $0x800cc3,%rax
  8012ce:	00 00 00 
  8012d1:	ff d0                	callq  *%rax
  8012d3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8012d7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012de:	e9 ad 00 00 00       	jmpq   801390 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  8012e3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012e7:	be 03 00 00 00       	mov    $0x3,%esi
  8012ec:	48 89 c7             	mov    %rax,%rdi
  8012ef:	48 b8 c3 0c 80 00 00 	movabs $0x800cc3,%rax
  8012f6:	00 00 00 
  8012f9:	ff d0                	callq  *%rax
  8012fb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8012ff:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801306:	e9 85 00 00 00       	jmpq   801390 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  80130b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80130f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801313:	48 89 d6             	mov    %rdx,%rsi
  801316:	bf 30 00 00 00       	mov    $0x30,%edi
  80131b:	ff d0                	callq  *%rax
			putch('x', putdat);
  80131d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801321:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801325:	48 89 d6             	mov    %rdx,%rsi
  801328:	bf 78 00 00 00       	mov    $0x78,%edi
  80132d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80132f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801332:	83 f8 30             	cmp    $0x30,%eax
  801335:	73 17                	jae    80134e <vprintfmt+0x46b>
  801337:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80133b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80133e:	89 c0                	mov    %eax,%eax
  801340:	48 01 d0             	add    %rdx,%rax
  801343:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801346:	83 c2 08             	add    $0x8,%edx
  801349:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80134c:	eb 0f                	jmp    80135d <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  80134e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801352:	48 89 d0             	mov    %rdx,%rax
  801355:	48 83 c2 08          	add    $0x8,%rdx
  801359:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80135d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801360:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801364:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80136b:	eb 23                	jmp    801390 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80136d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801371:	be 03 00 00 00       	mov    $0x3,%esi
  801376:	48 89 c7             	mov    %rax,%rdi
  801379:	48 b8 c3 0c 80 00 00 	movabs $0x800cc3,%rax
  801380:	00 00 00 
  801383:	ff d0                	callq  *%rax
  801385:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801389:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801390:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801395:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801398:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80139b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80139f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8013a3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013a7:	45 89 c1             	mov    %r8d,%r9d
  8013aa:	41 89 f8             	mov    %edi,%r8d
  8013ad:	48 89 c7             	mov    %rax,%rdi
  8013b0:	48 b8 08 0c 80 00 00 	movabs $0x800c08,%rax
  8013b7:	00 00 00 
  8013ba:	ff d0                	callq  *%rax
			break;
  8013bc:	eb 6f                	jmp    80142d <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8013be:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013c6:	48 89 d6             	mov    %rdx,%rsi
  8013c9:	89 df                	mov    %ebx,%edi
  8013cb:	ff d0                	callq  *%rax
			break;
  8013cd:	eb 5e                	jmp    80142d <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  8013cf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8013d3:	be 03 00 00 00       	mov    $0x3,%esi
  8013d8:	48 89 c7             	mov    %rax,%rdi
  8013db:	48 b8 c3 0c 80 00 00 	movabs $0x800cc3,%rax
  8013e2:	00 00 00 
  8013e5:	ff d0                	callq  *%rax
  8013e7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  8013eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ef:	89 c2                	mov    %eax,%edx
  8013f1:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8013f8:	00 00 00 
  8013fb:	89 10                	mov    %edx,(%rax)
			break;
  8013fd:	eb 2e                	jmp    80142d <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8013ff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801403:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801407:	48 89 d6             	mov    %rdx,%rsi
  80140a:	bf 25 00 00 00       	mov    $0x25,%edi
  80140f:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801411:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801416:	eb 05                	jmp    80141d <vprintfmt+0x53a>
  801418:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80141d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801421:	48 83 e8 01          	sub    $0x1,%rax
  801425:	0f b6 00             	movzbl (%rax),%eax
  801428:	3c 25                	cmp    $0x25,%al
  80142a:	75 ec                	jne    801418 <vprintfmt+0x535>
				/* do nothing */;
			break;
  80142c:	90                   	nop
		}
	}
  80142d:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80142e:	e9 13 fb ff ff       	jmpq   800f46 <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801433:	48 83 c4 60          	add    $0x60,%rsp
  801437:	5b                   	pop    %rbx
  801438:	41 5c                	pop    %r12
  80143a:	5d                   	pop    %rbp
  80143b:	c3                   	retq   

000000000080143c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80143c:	55                   	push   %rbp
  80143d:	48 89 e5             	mov    %rsp,%rbp
  801440:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801447:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80144e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801455:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80145c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801463:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80146a:	84 c0                	test   %al,%al
  80146c:	74 20                	je     80148e <printfmt+0x52>
  80146e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801472:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801476:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80147a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80147e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801482:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801486:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80148a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80148e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801495:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80149c:	00 00 00 
  80149f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8014a6:	00 00 00 
  8014a9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014ad:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8014b4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014bb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8014c2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8014c9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8014d0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8014d7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8014de:	48 89 c7             	mov    %rax,%rdi
  8014e1:	48 b8 e3 0e 80 00 00 	movabs $0x800ee3,%rax
  8014e8:	00 00 00 
  8014eb:	ff d0                	callq  *%rax
	va_end(ap);
}
  8014ed:	c9                   	leaveq 
  8014ee:	c3                   	retq   

00000000008014ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014ef:	55                   	push   %rbp
  8014f0:	48 89 e5             	mov    %rsp,%rbp
  8014f3:	48 83 ec 10          	sub    $0x10,%rsp
  8014f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8014fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8014fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801502:	8b 40 10             	mov    0x10(%rax),%eax
  801505:	8d 50 01             	lea    0x1(%rax),%edx
  801508:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80150f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801513:	48 8b 10             	mov    (%rax),%rdx
  801516:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80151e:	48 39 c2             	cmp    %rax,%rdx
  801521:	73 17                	jae    80153a <sprintputch+0x4b>
		*b->buf++ = ch;
  801523:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801527:	48 8b 00             	mov    (%rax),%rax
  80152a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80152e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801532:	48 89 0a             	mov    %rcx,(%rdx)
  801535:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801538:	88 10                	mov    %dl,(%rax)
}
  80153a:	c9                   	leaveq 
  80153b:	c3                   	retq   

000000000080153c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80153c:	55                   	push   %rbp
  80153d:	48 89 e5             	mov    %rsp,%rbp
  801540:	48 83 ec 50          	sub    $0x50,%rsp
  801544:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801548:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80154b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80154f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801553:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801557:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80155b:	48 8b 0a             	mov    (%rdx),%rcx
  80155e:	48 89 08             	mov    %rcx,(%rax)
  801561:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801565:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801569:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80156d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801571:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801575:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801579:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80157c:	48 98                	cltq   
  80157e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801582:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801586:	48 01 d0             	add    %rdx,%rax
  801589:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80158d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801594:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801599:	74 06                	je     8015a1 <vsnprintf+0x65>
  80159b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80159f:	7f 07                	jg     8015a8 <vsnprintf+0x6c>
		return -E_INVAL;
  8015a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a6:	eb 2f                	jmp    8015d7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8015a8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8015ac:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8015b0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8015b4:	48 89 c6             	mov    %rax,%rsi
  8015b7:	48 bf ef 14 80 00 00 	movabs $0x8014ef,%rdi
  8015be:	00 00 00 
  8015c1:	48 b8 e3 0e 80 00 00 	movabs $0x800ee3,%rax
  8015c8:	00 00 00 
  8015cb:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8015cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015d1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8015d4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8015d7:	c9                   	leaveq 
  8015d8:	c3                   	retq   

00000000008015d9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015d9:	55                   	push   %rbp
  8015da:	48 89 e5             	mov    %rsp,%rbp
  8015dd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8015e4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8015eb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8015f1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8015f8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8015ff:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801606:	84 c0                	test   %al,%al
  801608:	74 20                	je     80162a <snprintf+0x51>
  80160a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80160e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801612:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801616:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80161a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80161e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801622:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801626:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80162a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801631:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801638:	00 00 00 
  80163b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801642:	00 00 00 
  801645:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801649:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801650:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801657:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80165e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801665:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80166c:	48 8b 0a             	mov    (%rdx),%rcx
  80166f:	48 89 08             	mov    %rcx,(%rax)
  801672:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801676:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80167a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80167e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801682:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801689:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801690:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801696:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80169d:	48 89 c7             	mov    %rax,%rdi
  8016a0:	48 b8 3c 15 80 00 00 	movabs $0x80153c,%rax
  8016a7:	00 00 00 
  8016aa:	ff d0                	callq  *%rax
  8016ac:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8016b2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8016b8:	c9                   	leaveq 
  8016b9:	c3                   	retq   

00000000008016ba <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8016ba:	55                   	push   %rbp
  8016bb:	48 89 e5             	mov    %rsp,%rbp
  8016be:	48 83 ec 18          	sub    $0x18,%rsp
  8016c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8016c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016cd:	eb 09                	jmp    8016d8 <strlen+0x1e>
		n++;
  8016cf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8016d3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016dc:	0f b6 00             	movzbl (%rax),%eax
  8016df:	84 c0                	test   %al,%al
  8016e1:	75 ec                	jne    8016cf <strlen+0x15>
		n++;
	return n;
  8016e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016e6:	c9                   	leaveq 
  8016e7:	c3                   	retq   

00000000008016e8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016e8:	55                   	push   %rbp
  8016e9:	48 89 e5             	mov    %rsp,%rbp
  8016ec:	48 83 ec 20          	sub    $0x20,%rsp
  8016f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016ff:	eb 0e                	jmp    80170f <strnlen+0x27>
		n++;
  801701:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801705:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80170a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80170f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801714:	74 0b                	je     801721 <strnlen+0x39>
  801716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171a:	0f b6 00             	movzbl (%rax),%eax
  80171d:	84 c0                	test   %al,%al
  80171f:	75 e0                	jne    801701 <strnlen+0x19>
		n++;
	return n;
  801721:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801724:	c9                   	leaveq 
  801725:	c3                   	retq   

0000000000801726 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801726:	55                   	push   %rbp
  801727:	48 89 e5             	mov    %rsp,%rbp
  80172a:	48 83 ec 20          	sub    $0x20,%rsp
  80172e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801732:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80173a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80173e:	90                   	nop
  80173f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801743:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801747:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80174b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80174f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801753:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801757:	0f b6 12             	movzbl (%rdx),%edx
  80175a:	88 10                	mov    %dl,(%rax)
  80175c:	0f b6 00             	movzbl (%rax),%eax
  80175f:	84 c0                	test   %al,%al
  801761:	75 dc                	jne    80173f <strcpy+0x19>
		/* do nothing */;
	return ret;
  801763:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801767:	c9                   	leaveq 
  801768:	c3                   	retq   

0000000000801769 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801769:	55                   	push   %rbp
  80176a:	48 89 e5             	mov    %rsp,%rbp
  80176d:	48 83 ec 20          	sub    $0x20,%rsp
  801771:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801775:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801779:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177d:	48 89 c7             	mov    %rax,%rdi
  801780:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801787:	00 00 00 
  80178a:	ff d0                	callq  *%rax
  80178c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80178f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801792:	48 63 d0             	movslq %eax,%rdx
  801795:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801799:	48 01 c2             	add    %rax,%rdx
  80179c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017a0:	48 89 c6             	mov    %rax,%rsi
  8017a3:	48 89 d7             	mov    %rdx,%rdi
  8017a6:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  8017ad:	00 00 00 
  8017b0:	ff d0                	callq  *%rax
	return dst;
  8017b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017b6:	c9                   	leaveq 
  8017b7:	c3                   	retq   

00000000008017b8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8017b8:	55                   	push   %rbp
  8017b9:	48 89 e5             	mov    %rsp,%rbp
  8017bc:	48 83 ec 28          	sub    $0x28,%rsp
  8017c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8017cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8017d4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8017db:	00 
  8017dc:	eb 2a                	jmp    801808 <strncpy+0x50>
		*dst++ = *src;
  8017de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8017ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017ee:	0f b6 12             	movzbl (%rdx),%edx
  8017f1:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8017f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017f7:	0f b6 00             	movzbl (%rax),%eax
  8017fa:	84 c0                	test   %al,%al
  8017fc:	74 05                	je     801803 <strncpy+0x4b>
			src++;
  8017fe:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801803:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801808:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80180c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801810:	72 cc                	jb     8017de <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801816:	c9                   	leaveq 
  801817:	c3                   	retq   

0000000000801818 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801818:	55                   	push   %rbp
  801819:	48 89 e5             	mov    %rsp,%rbp
  80181c:	48 83 ec 28          	sub    $0x28,%rsp
  801820:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801824:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801828:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80182c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801830:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801834:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801839:	74 3d                	je     801878 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80183b:	eb 1d                	jmp    80185a <strlcpy+0x42>
			*dst++ = *src++;
  80183d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801841:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801845:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801849:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80184d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801851:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801855:	0f b6 12             	movzbl (%rdx),%edx
  801858:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80185a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80185f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801864:	74 0b                	je     801871 <strlcpy+0x59>
  801866:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80186a:	0f b6 00             	movzbl (%rax),%eax
  80186d:	84 c0                	test   %al,%al
  80186f:	75 cc                	jne    80183d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801875:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801878:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80187c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801880:	48 29 c2             	sub    %rax,%rdx
  801883:	48 89 d0             	mov    %rdx,%rax
}
  801886:	c9                   	leaveq 
  801887:	c3                   	retq   

0000000000801888 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801888:	55                   	push   %rbp
  801889:	48 89 e5             	mov    %rsp,%rbp
  80188c:	48 83 ec 10          	sub    $0x10,%rsp
  801890:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801894:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801898:	eb 0a                	jmp    8018a4 <strcmp+0x1c>
		p++, q++;
  80189a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80189f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8018a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018a8:	0f b6 00             	movzbl (%rax),%eax
  8018ab:	84 c0                	test   %al,%al
  8018ad:	74 12                	je     8018c1 <strcmp+0x39>
  8018af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b3:	0f b6 10             	movzbl (%rax),%edx
  8018b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ba:	0f b6 00             	movzbl (%rax),%eax
  8018bd:	38 c2                	cmp    %al,%dl
  8018bf:	74 d9                	je     80189a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c5:	0f b6 00             	movzbl (%rax),%eax
  8018c8:	0f b6 d0             	movzbl %al,%edx
  8018cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018cf:	0f b6 00             	movzbl (%rax),%eax
  8018d2:	0f b6 c0             	movzbl %al,%eax
  8018d5:	29 c2                	sub    %eax,%edx
  8018d7:	89 d0                	mov    %edx,%eax
}
  8018d9:	c9                   	leaveq 
  8018da:	c3                   	retq   

00000000008018db <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018db:	55                   	push   %rbp
  8018dc:	48 89 e5             	mov    %rsp,%rbp
  8018df:	48 83 ec 18          	sub    $0x18,%rsp
  8018e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018eb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8018ef:	eb 0f                	jmp    801900 <strncmp+0x25>
		n--, p++, q++;
  8018f1:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8018f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018fb:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801900:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801905:	74 1d                	je     801924 <strncmp+0x49>
  801907:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80190b:	0f b6 00             	movzbl (%rax),%eax
  80190e:	84 c0                	test   %al,%al
  801910:	74 12                	je     801924 <strncmp+0x49>
  801912:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801916:	0f b6 10             	movzbl (%rax),%edx
  801919:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80191d:	0f b6 00             	movzbl (%rax),%eax
  801920:	38 c2                	cmp    %al,%dl
  801922:	74 cd                	je     8018f1 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801924:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801929:	75 07                	jne    801932 <strncmp+0x57>
		return 0;
  80192b:	b8 00 00 00 00       	mov    $0x0,%eax
  801930:	eb 18                	jmp    80194a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801932:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801936:	0f b6 00             	movzbl (%rax),%eax
  801939:	0f b6 d0             	movzbl %al,%edx
  80193c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801940:	0f b6 00             	movzbl (%rax),%eax
  801943:	0f b6 c0             	movzbl %al,%eax
  801946:	29 c2                	sub    %eax,%edx
  801948:	89 d0                	mov    %edx,%eax
}
  80194a:	c9                   	leaveq 
  80194b:	c3                   	retq   

000000000080194c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80194c:	55                   	push   %rbp
  80194d:	48 89 e5             	mov    %rsp,%rbp
  801950:	48 83 ec 0c          	sub    $0xc,%rsp
  801954:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801958:	89 f0                	mov    %esi,%eax
  80195a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80195d:	eb 17                	jmp    801976 <strchr+0x2a>
		if (*s == c)
  80195f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801963:	0f b6 00             	movzbl (%rax),%eax
  801966:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801969:	75 06                	jne    801971 <strchr+0x25>
			return (char *) s;
  80196b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80196f:	eb 15                	jmp    801986 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801971:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801976:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80197a:	0f b6 00             	movzbl (%rax),%eax
  80197d:	84 c0                	test   %al,%al
  80197f:	75 de                	jne    80195f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801981:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801986:	c9                   	leaveq 
  801987:	c3                   	retq   

0000000000801988 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801988:	55                   	push   %rbp
  801989:	48 89 e5             	mov    %rsp,%rbp
  80198c:	48 83 ec 0c          	sub    $0xc,%rsp
  801990:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801994:	89 f0                	mov    %esi,%eax
  801996:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801999:	eb 13                	jmp    8019ae <strfind+0x26>
		if (*s == c)
  80199b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80199f:	0f b6 00             	movzbl (%rax),%eax
  8019a2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8019a5:	75 02                	jne    8019a9 <strfind+0x21>
			break;
  8019a7:	eb 10                	jmp    8019b9 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8019a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b2:	0f b6 00             	movzbl (%rax),%eax
  8019b5:	84 c0                	test   %al,%al
  8019b7:	75 e2                	jne    80199b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8019b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019bd:	c9                   	leaveq 
  8019be:	c3                   	retq   

00000000008019bf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8019bf:	55                   	push   %rbp
  8019c0:	48 89 e5             	mov    %rsp,%rbp
  8019c3:	48 83 ec 18          	sub    $0x18,%rsp
  8019c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019cb:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8019ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8019d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019d7:	75 06                	jne    8019df <memset+0x20>
		return v;
  8019d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019dd:	eb 69                	jmp    801a48 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8019df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019e3:	83 e0 03             	and    $0x3,%eax
  8019e6:	48 85 c0             	test   %rax,%rax
  8019e9:	75 48                	jne    801a33 <memset+0x74>
  8019eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ef:	83 e0 03             	and    $0x3,%eax
  8019f2:	48 85 c0             	test   %rax,%rax
  8019f5:	75 3c                	jne    801a33 <memset+0x74>
		c &= 0xFF;
  8019f7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8019fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a01:	c1 e0 18             	shl    $0x18,%eax
  801a04:	89 c2                	mov    %eax,%edx
  801a06:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a09:	c1 e0 10             	shl    $0x10,%eax
  801a0c:	09 c2                	or     %eax,%edx
  801a0e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a11:	c1 e0 08             	shl    $0x8,%eax
  801a14:	09 d0                	or     %edx,%eax
  801a16:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801a19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a1d:	48 c1 e8 02          	shr    $0x2,%rax
  801a21:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801a24:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a28:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a2b:	48 89 d7             	mov    %rdx,%rdi
  801a2e:	fc                   	cld    
  801a2f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801a31:	eb 11                	jmp    801a44 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801a33:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a37:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a3a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a3e:	48 89 d7             	mov    %rdx,%rdi
  801a41:	fc                   	cld    
  801a42:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801a44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a48:	c9                   	leaveq 
  801a49:	c3                   	retq   

0000000000801a4a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801a4a:	55                   	push   %rbp
  801a4b:	48 89 e5             	mov    %rsp,%rbp
  801a4e:	48 83 ec 28          	sub    $0x28,%rsp
  801a52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a5a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801a5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a62:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801a66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a6a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801a6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a72:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a76:	0f 83 88 00 00 00    	jae    801b04 <memmove+0xba>
  801a7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a80:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a84:	48 01 d0             	add    %rdx,%rax
  801a87:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a8b:	76 77                	jbe    801b04 <memmove+0xba>
		s += n;
  801a8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a91:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801a95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a99:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aa1:	83 e0 03             	and    $0x3,%eax
  801aa4:	48 85 c0             	test   %rax,%rax
  801aa7:	75 3b                	jne    801ae4 <memmove+0x9a>
  801aa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aad:	83 e0 03             	and    $0x3,%eax
  801ab0:	48 85 c0             	test   %rax,%rax
  801ab3:	75 2f                	jne    801ae4 <memmove+0x9a>
  801ab5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab9:	83 e0 03             	and    $0x3,%eax
  801abc:	48 85 c0             	test   %rax,%rax
  801abf:	75 23                	jne    801ae4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801ac1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac5:	48 83 e8 04          	sub    $0x4,%rax
  801ac9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801acd:	48 83 ea 04          	sub    $0x4,%rdx
  801ad1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801ad5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801ad9:	48 89 c7             	mov    %rax,%rdi
  801adc:	48 89 d6             	mov    %rdx,%rsi
  801adf:	fd                   	std    
  801ae0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ae2:	eb 1d                	jmp    801b01 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801ae4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801aec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801af4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af8:	48 89 d7             	mov    %rdx,%rdi
  801afb:	48 89 c1             	mov    %rax,%rcx
  801afe:	fd                   	std    
  801aff:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801b01:	fc                   	cld    
  801b02:	eb 57                	jmp    801b5b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801b04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b08:	83 e0 03             	and    $0x3,%eax
  801b0b:	48 85 c0             	test   %rax,%rax
  801b0e:	75 36                	jne    801b46 <memmove+0xfc>
  801b10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b14:	83 e0 03             	and    $0x3,%eax
  801b17:	48 85 c0             	test   %rax,%rax
  801b1a:	75 2a                	jne    801b46 <memmove+0xfc>
  801b1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b20:	83 e0 03             	and    $0x3,%eax
  801b23:	48 85 c0             	test   %rax,%rax
  801b26:	75 1e                	jne    801b46 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801b28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b2c:	48 c1 e8 02          	shr    $0x2,%rax
  801b30:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b37:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b3b:	48 89 c7             	mov    %rax,%rdi
  801b3e:	48 89 d6             	mov    %rdx,%rsi
  801b41:	fc                   	cld    
  801b42:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801b44:	eb 15                	jmp    801b5b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801b46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b4a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b4e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801b52:	48 89 c7             	mov    %rax,%rdi
  801b55:	48 89 d6             	mov    %rdx,%rsi
  801b58:	fc                   	cld    
  801b59:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801b5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b5f:	c9                   	leaveq 
  801b60:	c3                   	retq   

0000000000801b61 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b61:	55                   	push   %rbp
  801b62:	48 89 e5             	mov    %rsp,%rbp
  801b65:	48 83 ec 18          	sub    $0x18,%rsp
  801b69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b71:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801b75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b79:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b81:	48 89 ce             	mov    %rcx,%rsi
  801b84:	48 89 c7             	mov    %rax,%rdi
  801b87:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  801b8e:	00 00 00 
  801b91:	ff d0                	callq  *%rax
}
  801b93:	c9                   	leaveq 
  801b94:	c3                   	retq   

0000000000801b95 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b95:	55                   	push   %rbp
  801b96:	48 89 e5             	mov    %rsp,%rbp
  801b99:	48 83 ec 28          	sub    $0x28,%rsp
  801b9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ba1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ba5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801ba9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801bb1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bb5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801bb9:	eb 36                	jmp    801bf1 <memcmp+0x5c>
		if (*s1 != *s2)
  801bbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bbf:	0f b6 10             	movzbl (%rax),%edx
  801bc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bc6:	0f b6 00             	movzbl (%rax),%eax
  801bc9:	38 c2                	cmp    %al,%dl
  801bcb:	74 1a                	je     801be7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801bcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bd1:	0f b6 00             	movzbl (%rax),%eax
  801bd4:	0f b6 d0             	movzbl %al,%edx
  801bd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bdb:	0f b6 00             	movzbl (%rax),%eax
  801bde:	0f b6 c0             	movzbl %al,%eax
  801be1:	29 c2                	sub    %eax,%edx
  801be3:	89 d0                	mov    %edx,%eax
  801be5:	eb 20                	jmp    801c07 <memcmp+0x72>
		s1++, s2++;
  801be7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bec:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801bf1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bf5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801bf9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801bfd:	48 85 c0             	test   %rax,%rax
  801c00:	75 b9                	jne    801bbb <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c07:	c9                   	leaveq 
  801c08:	c3                   	retq   

0000000000801c09 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801c09:	55                   	push   %rbp
  801c0a:	48 89 e5             	mov    %rsp,%rbp
  801c0d:	48 83 ec 28          	sub    $0x28,%rsp
  801c11:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c15:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801c18:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801c1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c24:	48 01 d0             	add    %rdx,%rax
  801c27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801c2b:	eb 15                	jmp    801c42 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c31:	0f b6 10             	movzbl (%rax),%edx
  801c34:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c37:	38 c2                	cmp    %al,%dl
  801c39:	75 02                	jne    801c3d <memfind+0x34>
			break;
  801c3b:	eb 0f                	jmp    801c4c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c3d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801c42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c46:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801c4a:	72 e1                	jb     801c2d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801c4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c50:	c9                   	leaveq 
  801c51:	c3                   	retq   

0000000000801c52 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c52:	55                   	push   %rbp
  801c53:	48 89 e5             	mov    %rsp,%rbp
  801c56:	48 83 ec 34          	sub    $0x34,%rsp
  801c5a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c5e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801c62:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801c65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801c6c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801c73:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c74:	eb 05                	jmp    801c7b <strtol+0x29>
		s++;
  801c76:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c7f:	0f b6 00             	movzbl (%rax),%eax
  801c82:	3c 20                	cmp    $0x20,%al
  801c84:	74 f0                	je     801c76 <strtol+0x24>
  801c86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c8a:	0f b6 00             	movzbl (%rax),%eax
  801c8d:	3c 09                	cmp    $0x9,%al
  801c8f:	74 e5                	je     801c76 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c95:	0f b6 00             	movzbl (%rax),%eax
  801c98:	3c 2b                	cmp    $0x2b,%al
  801c9a:	75 07                	jne    801ca3 <strtol+0x51>
		s++;
  801c9c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ca1:	eb 17                	jmp    801cba <strtol+0x68>
	else if (*s == '-')
  801ca3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca7:	0f b6 00             	movzbl (%rax),%eax
  801caa:	3c 2d                	cmp    $0x2d,%al
  801cac:	75 0c                	jne    801cba <strtol+0x68>
		s++, neg = 1;
  801cae:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801cb3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801cba:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cbe:	74 06                	je     801cc6 <strtol+0x74>
  801cc0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801cc4:	75 28                	jne    801cee <strtol+0x9c>
  801cc6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cca:	0f b6 00             	movzbl (%rax),%eax
  801ccd:	3c 30                	cmp    $0x30,%al
  801ccf:	75 1d                	jne    801cee <strtol+0x9c>
  801cd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd5:	48 83 c0 01          	add    $0x1,%rax
  801cd9:	0f b6 00             	movzbl (%rax),%eax
  801cdc:	3c 78                	cmp    $0x78,%al
  801cde:	75 0e                	jne    801cee <strtol+0x9c>
		s += 2, base = 16;
  801ce0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801ce5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801cec:	eb 2c                	jmp    801d1a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801cee:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cf2:	75 19                	jne    801d0d <strtol+0xbb>
  801cf4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf8:	0f b6 00             	movzbl (%rax),%eax
  801cfb:	3c 30                	cmp    $0x30,%al
  801cfd:	75 0e                	jne    801d0d <strtol+0xbb>
		s++, base = 8;
  801cff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d04:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801d0b:	eb 0d                	jmp    801d1a <strtol+0xc8>
	else if (base == 0)
  801d0d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d11:	75 07                	jne    801d1a <strtol+0xc8>
		base = 10;
  801d13:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d1e:	0f b6 00             	movzbl (%rax),%eax
  801d21:	3c 2f                	cmp    $0x2f,%al
  801d23:	7e 1d                	jle    801d42 <strtol+0xf0>
  801d25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d29:	0f b6 00             	movzbl (%rax),%eax
  801d2c:	3c 39                	cmp    $0x39,%al
  801d2e:	7f 12                	jg     801d42 <strtol+0xf0>
			dig = *s - '0';
  801d30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d34:	0f b6 00             	movzbl (%rax),%eax
  801d37:	0f be c0             	movsbl %al,%eax
  801d3a:	83 e8 30             	sub    $0x30,%eax
  801d3d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d40:	eb 4e                	jmp    801d90 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801d42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d46:	0f b6 00             	movzbl (%rax),%eax
  801d49:	3c 60                	cmp    $0x60,%al
  801d4b:	7e 1d                	jle    801d6a <strtol+0x118>
  801d4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d51:	0f b6 00             	movzbl (%rax),%eax
  801d54:	3c 7a                	cmp    $0x7a,%al
  801d56:	7f 12                	jg     801d6a <strtol+0x118>
			dig = *s - 'a' + 10;
  801d58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d5c:	0f b6 00             	movzbl (%rax),%eax
  801d5f:	0f be c0             	movsbl %al,%eax
  801d62:	83 e8 57             	sub    $0x57,%eax
  801d65:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d68:	eb 26                	jmp    801d90 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801d6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d6e:	0f b6 00             	movzbl (%rax),%eax
  801d71:	3c 40                	cmp    $0x40,%al
  801d73:	7e 48                	jle    801dbd <strtol+0x16b>
  801d75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d79:	0f b6 00             	movzbl (%rax),%eax
  801d7c:	3c 5a                	cmp    $0x5a,%al
  801d7e:	7f 3d                	jg     801dbd <strtol+0x16b>
			dig = *s - 'A' + 10;
  801d80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d84:	0f b6 00             	movzbl (%rax),%eax
  801d87:	0f be c0             	movsbl %al,%eax
  801d8a:	83 e8 37             	sub    $0x37,%eax
  801d8d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801d90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d93:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801d96:	7c 02                	jl     801d9a <strtol+0x148>
			break;
  801d98:	eb 23                	jmp    801dbd <strtol+0x16b>
		s++, val = (val * base) + dig;
  801d9a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d9f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801da2:	48 98                	cltq   
  801da4:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801da9:	48 89 c2             	mov    %rax,%rdx
  801dac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801daf:	48 98                	cltq   
  801db1:	48 01 d0             	add    %rdx,%rax
  801db4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801db8:	e9 5d ff ff ff       	jmpq   801d1a <strtol+0xc8>

	if (endptr)
  801dbd:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801dc2:	74 0b                	je     801dcf <strtol+0x17d>
		*endptr = (char *) s;
  801dc4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dc8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801dcc:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801dcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dd3:	74 09                	je     801dde <strtol+0x18c>
  801dd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dd9:	48 f7 d8             	neg    %rax
  801ddc:	eb 04                	jmp    801de2 <strtol+0x190>
  801dde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801de2:	c9                   	leaveq 
  801de3:	c3                   	retq   

0000000000801de4 <strstr>:

char * strstr(const char *in, const char *str)
{
  801de4:	55                   	push   %rbp
  801de5:	48 89 e5             	mov    %rsp,%rbp
  801de8:	48 83 ec 30          	sub    $0x30,%rsp
  801dec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801df0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801df4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801df8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801dfc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e00:	0f b6 00             	movzbl (%rax),%eax
  801e03:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801e06:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801e0a:	75 06                	jne    801e12 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801e0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e10:	eb 6b                	jmp    801e7d <strstr+0x99>

	len = strlen(str);
  801e12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e16:	48 89 c7             	mov    %rax,%rdi
  801e19:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801e20:	00 00 00 
  801e23:	ff d0                	callq  *%rax
  801e25:	48 98                	cltq   
  801e27:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801e2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e33:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801e37:	0f b6 00             	movzbl (%rax),%eax
  801e3a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801e3d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801e41:	75 07                	jne    801e4a <strstr+0x66>
				return (char *) 0;
  801e43:	b8 00 00 00 00       	mov    $0x0,%eax
  801e48:	eb 33                	jmp    801e7d <strstr+0x99>
		} while (sc != c);
  801e4a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801e4e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801e51:	75 d8                	jne    801e2b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801e53:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e57:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801e5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5f:	48 89 ce             	mov    %rcx,%rsi
  801e62:	48 89 c7             	mov    %rax,%rdi
  801e65:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  801e6c:	00 00 00 
  801e6f:	ff d0                	callq  *%rax
  801e71:	85 c0                	test   %eax,%eax
  801e73:	75 b6                	jne    801e2b <strstr+0x47>

	return (char *) (in - 1);
  801e75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e79:	48 83 e8 01          	sub    $0x1,%rax
}
  801e7d:	c9                   	leaveq 
  801e7e:	c3                   	retq   

0000000000801e7f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801e7f:	55                   	push   %rbp
  801e80:	48 89 e5             	mov    %rsp,%rbp
  801e83:	53                   	push   %rbx
  801e84:	48 83 ec 48          	sub    $0x48,%rsp
  801e88:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e8b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801e8e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e92:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801e96:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801e9a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e9e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ea1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801ea5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801ea9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801ead:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801eb1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801eb5:	4c 89 c3             	mov    %r8,%rbx
  801eb8:	cd 30                	int    $0x30
  801eba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801ebe:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801ec2:	74 3e                	je     801f02 <syscall+0x83>
  801ec4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ec9:	7e 37                	jle    801f02 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ecb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ecf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ed2:	49 89 d0             	mov    %rdx,%r8
  801ed5:	89 c1                	mov    %eax,%ecx
  801ed7:	48 ba c8 58 80 00 00 	movabs $0x8058c8,%rdx
  801ede:	00 00 00 
  801ee1:	be 23 00 00 00       	mov    $0x23,%esi
  801ee6:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  801eed:	00 00 00 
  801ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef5:	49 b9 f7 08 80 00 00 	movabs $0x8008f7,%r9
  801efc:	00 00 00 
  801eff:	41 ff d1             	callq  *%r9

	return ret;
  801f02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f06:	48 83 c4 48          	add    $0x48,%rsp
  801f0a:	5b                   	pop    %rbx
  801f0b:	5d                   	pop    %rbp
  801f0c:	c3                   	retq   

0000000000801f0d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801f0d:	55                   	push   %rbp
  801f0e:	48 89 e5             	mov    %rsp,%rbp
  801f11:	48 83 ec 20          	sub    $0x20,%rsp
  801f15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801f1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f2c:	00 
  801f2d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f39:	48 89 d1             	mov    %rdx,%rcx
  801f3c:	48 89 c2             	mov    %rax,%rdx
  801f3f:	be 00 00 00 00       	mov    $0x0,%esi
  801f44:	bf 00 00 00 00       	mov    $0x0,%edi
  801f49:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  801f50:	00 00 00 
  801f53:	ff d0                	callq  *%rax
}
  801f55:	c9                   	leaveq 
  801f56:	c3                   	retq   

0000000000801f57 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f57:	55                   	push   %rbp
  801f58:	48 89 e5             	mov    %rsp,%rbp
  801f5b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801f5f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f66:	00 
  801f67:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f6d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f73:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f78:	ba 00 00 00 00       	mov    $0x0,%edx
  801f7d:	be 00 00 00 00       	mov    $0x0,%esi
  801f82:	bf 01 00 00 00       	mov    $0x1,%edi
  801f87:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  801f8e:	00 00 00 
  801f91:	ff d0                	callq  *%rax
}
  801f93:	c9                   	leaveq 
  801f94:	c3                   	retq   

0000000000801f95 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801f95:	55                   	push   %rbp
  801f96:	48 89 e5             	mov    %rsp,%rbp
  801f99:	48 83 ec 10          	sub    $0x10,%rsp
  801f9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801fa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa3:	48 98                	cltq   
  801fa5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fac:	00 
  801fad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fb3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fbe:	48 89 c2             	mov    %rax,%rdx
  801fc1:	be 01 00 00 00       	mov    $0x1,%esi
  801fc6:	bf 03 00 00 00       	mov    $0x3,%edi
  801fcb:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  801fd2:	00 00 00 
  801fd5:	ff d0                	callq  *%rax
}
  801fd7:	c9                   	leaveq 
  801fd8:	c3                   	retq   

0000000000801fd9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801fd9:	55                   	push   %rbp
  801fda:	48 89 e5             	mov    %rsp,%rbp
  801fdd:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801fe1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fe8:	00 
  801fe9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ff5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ffa:	ba 00 00 00 00       	mov    $0x0,%edx
  801fff:	be 00 00 00 00       	mov    $0x0,%esi
  802004:	bf 02 00 00 00       	mov    $0x2,%edi
  802009:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  802010:	00 00 00 
  802013:	ff d0                	callq  *%rax
}
  802015:	c9                   	leaveq 
  802016:	c3                   	retq   

0000000000802017 <sys_yield>:

void
sys_yield(void)
{
  802017:	55                   	push   %rbp
  802018:	48 89 e5             	mov    %rsp,%rbp
  80201b:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80201f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802026:	00 
  802027:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80202d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802033:	b9 00 00 00 00       	mov    $0x0,%ecx
  802038:	ba 00 00 00 00       	mov    $0x0,%edx
  80203d:	be 00 00 00 00       	mov    $0x0,%esi
  802042:	bf 0b 00 00 00       	mov    $0xb,%edi
  802047:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  80204e:	00 00 00 
  802051:	ff d0                	callq  *%rax
}
  802053:	c9                   	leaveq 
  802054:	c3                   	retq   

0000000000802055 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802055:	55                   	push   %rbp
  802056:	48 89 e5             	mov    %rsp,%rbp
  802059:	48 83 ec 20          	sub    $0x20,%rsp
  80205d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802060:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802064:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802067:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80206a:	48 63 c8             	movslq %eax,%rcx
  80206d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802071:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802074:	48 98                	cltq   
  802076:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80207d:	00 
  80207e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802084:	49 89 c8             	mov    %rcx,%r8
  802087:	48 89 d1             	mov    %rdx,%rcx
  80208a:	48 89 c2             	mov    %rax,%rdx
  80208d:	be 01 00 00 00       	mov    $0x1,%esi
  802092:	bf 04 00 00 00       	mov    $0x4,%edi
  802097:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  80209e:	00 00 00 
  8020a1:	ff d0                	callq  *%rax
}
  8020a3:	c9                   	leaveq 
  8020a4:	c3                   	retq   

00000000008020a5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8020a5:	55                   	push   %rbp
  8020a6:	48 89 e5             	mov    %rsp,%rbp
  8020a9:	48 83 ec 30          	sub    $0x30,%rsp
  8020ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020b4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8020b7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8020bb:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8020bf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020c2:	48 63 c8             	movslq %eax,%rcx
  8020c5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020cc:	48 63 f0             	movslq %eax,%rsi
  8020cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d6:	48 98                	cltq   
  8020d8:	48 89 0c 24          	mov    %rcx,(%rsp)
  8020dc:	49 89 f9             	mov    %rdi,%r9
  8020df:	49 89 f0             	mov    %rsi,%r8
  8020e2:	48 89 d1             	mov    %rdx,%rcx
  8020e5:	48 89 c2             	mov    %rax,%rdx
  8020e8:	be 01 00 00 00       	mov    $0x1,%esi
  8020ed:	bf 05 00 00 00       	mov    $0x5,%edi
  8020f2:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  8020f9:	00 00 00 
  8020fc:	ff d0                	callq  *%rax
}
  8020fe:	c9                   	leaveq 
  8020ff:	c3                   	retq   

0000000000802100 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802100:	55                   	push   %rbp
  802101:	48 89 e5             	mov    %rsp,%rbp
  802104:	48 83 ec 20          	sub    $0x20,%rsp
  802108:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80210b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80210f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802113:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802116:	48 98                	cltq   
  802118:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80211f:	00 
  802120:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802126:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80212c:	48 89 d1             	mov    %rdx,%rcx
  80212f:	48 89 c2             	mov    %rax,%rdx
  802132:	be 01 00 00 00       	mov    $0x1,%esi
  802137:	bf 06 00 00 00       	mov    $0x6,%edi
  80213c:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  802143:	00 00 00 
  802146:	ff d0                	callq  *%rax
}
  802148:	c9                   	leaveq 
  802149:	c3                   	retq   

000000000080214a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80214a:	55                   	push   %rbp
  80214b:	48 89 e5             	mov    %rsp,%rbp
  80214e:	48 83 ec 10          	sub    $0x10,%rsp
  802152:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802155:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802158:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80215b:	48 63 d0             	movslq %eax,%rdx
  80215e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802161:	48 98                	cltq   
  802163:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80216a:	00 
  80216b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802171:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802177:	48 89 d1             	mov    %rdx,%rcx
  80217a:	48 89 c2             	mov    %rax,%rdx
  80217d:	be 01 00 00 00       	mov    $0x1,%esi
  802182:	bf 08 00 00 00       	mov    $0x8,%edi
  802187:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  80218e:	00 00 00 
  802191:	ff d0                	callq  *%rax
}
  802193:	c9                   	leaveq 
  802194:	c3                   	retq   

0000000000802195 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802195:	55                   	push   %rbp
  802196:	48 89 e5             	mov    %rsp,%rbp
  802199:	48 83 ec 20          	sub    $0x20,%rsp
  80219d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8021a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ab:	48 98                	cltq   
  8021ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021b4:	00 
  8021b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021c1:	48 89 d1             	mov    %rdx,%rcx
  8021c4:	48 89 c2             	mov    %rax,%rdx
  8021c7:	be 01 00 00 00       	mov    $0x1,%esi
  8021cc:	bf 09 00 00 00       	mov    $0x9,%edi
  8021d1:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	callq  *%rax
}
  8021dd:	c9                   	leaveq 
  8021de:	c3                   	retq   

00000000008021df <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8021df:	55                   	push   %rbp
  8021e0:	48 89 e5             	mov    %rsp,%rbp
  8021e3:	48 83 ec 20          	sub    $0x20,%rsp
  8021e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8021ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f5:	48 98                	cltq   
  8021f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021fe:	00 
  8021ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802205:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80220b:	48 89 d1             	mov    %rdx,%rcx
  80220e:	48 89 c2             	mov    %rax,%rdx
  802211:	be 01 00 00 00       	mov    $0x1,%esi
  802216:	bf 0a 00 00 00       	mov    $0xa,%edi
  80221b:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  802222:	00 00 00 
  802225:	ff d0                	callq  *%rax
}
  802227:	c9                   	leaveq 
  802228:	c3                   	retq   

0000000000802229 <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  802229:	55                   	push   %rbp
  80222a:	48 89 e5             	mov    %rsp,%rbp
  80222d:	48 83 ec 10          	sub    $0x10,%rsp
  802231:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802234:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  802237:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80223a:	48 63 d0             	movslq %eax,%rdx
  80223d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802240:	48 98                	cltq   
  802242:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802249:	00 
  80224a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802250:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802256:	48 89 d1             	mov    %rdx,%rcx
  802259:	48 89 c2             	mov    %rax,%rdx
  80225c:	be 01 00 00 00       	mov    $0x1,%esi
  802261:	bf 11 00 00 00       	mov    $0x11,%edi
  802266:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  80226d:	00 00 00 
  802270:	ff d0                	callq  *%rax

}
  802272:	c9                   	leaveq 
  802273:	c3                   	retq   

0000000000802274 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802274:	55                   	push   %rbp
  802275:	48 89 e5             	mov    %rsp,%rbp
  802278:	48 83 ec 20          	sub    $0x20,%rsp
  80227c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80227f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802283:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802287:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80228a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80228d:	48 63 f0             	movslq %eax,%rsi
  802290:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802294:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802297:	48 98                	cltq   
  802299:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80229d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022a4:	00 
  8022a5:	49 89 f1             	mov    %rsi,%r9
  8022a8:	49 89 c8             	mov    %rcx,%r8
  8022ab:	48 89 d1             	mov    %rdx,%rcx
  8022ae:	48 89 c2             	mov    %rax,%rdx
  8022b1:	be 00 00 00 00       	mov    $0x0,%esi
  8022b6:	bf 0c 00 00 00       	mov    $0xc,%edi
  8022bb:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  8022c2:	00 00 00 
  8022c5:	ff d0                	callq  *%rax
}
  8022c7:	c9                   	leaveq 
  8022c8:	c3                   	retq   

00000000008022c9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8022c9:	55                   	push   %rbp
  8022ca:	48 89 e5             	mov    %rsp,%rbp
  8022cd:	48 83 ec 10          	sub    $0x10,%rsp
  8022d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8022d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022d9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022e0:	00 
  8022e1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022f2:	48 89 c2             	mov    %rax,%rdx
  8022f5:	be 01 00 00 00       	mov    $0x1,%esi
  8022fa:	bf 0d 00 00 00       	mov    $0xd,%edi
  8022ff:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  802306:	00 00 00 
  802309:	ff d0                	callq  *%rax
}
  80230b:	c9                   	leaveq 
  80230c:	c3                   	retq   

000000000080230d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80230d:	55                   	push   %rbp
  80230e:	48 89 e5             	mov    %rsp,%rbp
  802311:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802315:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80231c:	00 
  80231d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802323:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802329:	b9 00 00 00 00       	mov    $0x0,%ecx
  80232e:	ba 00 00 00 00       	mov    $0x0,%edx
  802333:	be 00 00 00 00       	mov    $0x0,%esi
  802338:	bf 0e 00 00 00       	mov    $0xe,%edi
  80233d:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  802344:	00 00 00 
  802347:	ff d0                	callq  *%rax
}
  802349:	c9                   	leaveq 
  80234a:	c3                   	retq   

000000000080234b <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  80234b:	55                   	push   %rbp
  80234c:	48 89 e5             	mov    %rsp,%rbp
  80234f:	48 83 ec 30          	sub    $0x30,%rsp
  802353:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802356:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80235a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80235d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802361:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802365:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802368:	48 63 c8             	movslq %eax,%rcx
  80236b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80236f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802372:	48 63 f0             	movslq %eax,%rsi
  802375:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802379:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237c:	48 98                	cltq   
  80237e:	48 89 0c 24          	mov    %rcx,(%rsp)
  802382:	49 89 f9             	mov    %rdi,%r9
  802385:	49 89 f0             	mov    %rsi,%r8
  802388:	48 89 d1             	mov    %rdx,%rcx
  80238b:	48 89 c2             	mov    %rax,%rdx
  80238e:	be 00 00 00 00       	mov    $0x0,%esi
  802393:	bf 0f 00 00 00       	mov    $0xf,%edi
  802398:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  80239f:	00 00 00 
  8023a2:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8023a4:	c9                   	leaveq 
  8023a5:	c3                   	retq   

00000000008023a6 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8023a6:	55                   	push   %rbp
  8023a7:	48 89 e5             	mov    %rsp,%rbp
  8023aa:	48 83 ec 20          	sub    $0x20,%rsp
  8023ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8023b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023c5:	00 
  8023c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023d2:	48 89 d1             	mov    %rdx,%rcx
  8023d5:	48 89 c2             	mov    %rax,%rdx
  8023d8:	be 00 00 00 00       	mov    $0x0,%esi
  8023dd:	bf 10 00 00 00       	mov    $0x10,%edi
  8023e2:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  8023e9:	00 00 00 
  8023ec:	ff d0                	callq  *%rax
}
  8023ee:	c9                   	leaveq 
  8023ef:	c3                   	retq   

00000000008023f0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8023f0:	55                   	push   %rbp
  8023f1:	48 89 e5             	mov    %rsp,%rbp
  8023f4:	48 83 ec 30          	sub    $0x30,%rsp
  8023f8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)



	void *addr = (void *) utf->utf_fault_va;
  8023fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802400:	48 8b 00             	mov    (%rax),%rax
  802403:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802407:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80240b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80240f:	89 45 f4             	mov    %eax,-0xc(%rbp)
        // Hint:
        //   Use the read-only page table mappings at vpt
        //   (see <inc/memlayout.h>).

        // LAB 4: Your code here.
	if (!(err&FEC_WR))
  802412:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802415:	83 e0 02             	and    $0x2,%eax
  802418:	85 c0                	test   %eax,%eax
  80241a:	75 2a                	jne    802446 <pgfault+0x56>
		panic("pgfault:FEC_WR check\n");
  80241c:	48 ba f8 58 80 00 00 	movabs $0x8058f8,%rdx
  802423:	00 00 00 
  802426:	be 21 00 00 00       	mov    $0x21,%esi
  80242b:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  802432:	00 00 00 
  802435:	b8 00 00 00 00       	mov    $0x0,%eax
  80243a:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  802441:	00 00 00 
  802444:	ff d1                	callq  *%rcx
	if (!(uvpt[((uint64_t)addr) / PGSIZE] & PTE_COW))
  802446:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80244a:	48 c1 e8 0c          	shr    $0xc,%rax
  80244e:	48 89 c2             	mov    %rax,%rdx
  802451:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802458:	01 00 00 
  80245b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80245f:	25 00 08 00 00       	and    $0x800,%eax
  802464:	48 85 c0             	test   %rax,%rax
  802467:	75 2a                	jne    802493 <pgfault+0xa3>
		panic("pgfault:PTE_COW check\n");
  802469:	48 ba 19 59 80 00 00 	movabs $0x805919,%rdx
  802470:	00 00 00 
  802473:	be 23 00 00 00       	mov    $0x23,%esi
  802478:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  80247f:	00 00 00 
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
  802487:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  80248e:	00 00 00 
  802491:	ff d1                	callq  *%rcx
        // Hint:
        //   You should make three system calls.
        //   No need to explicitly delete the old page's mapping.

        // LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  802493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802497:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80249b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80249f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8024a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U)<0)
  8024a9:	ba 07 00 00 00       	mov    $0x7,%edx
  8024ae:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8024b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b8:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  8024bf:	00 00 00 
  8024c2:	ff d0                	callq  *%rax
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	79 2a                	jns    8024f2 <pgfault+0x102>
		panic("pgfault: sys_page_alloc error\n");
  8024c8:	48 ba 30 59 80 00 00 	movabs $0x805930,%rdx
  8024cf:	00 00 00 
  8024d2:	be 2f 00 00 00       	mov    $0x2f,%esi
  8024d7:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  8024de:	00 00 00 
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e6:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  8024ed:	00 00 00 
  8024f0:	ff d1                	callq  *%rcx
	memcpy(PFTEMP, addr, PGSIZE);
  8024f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024f6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024fb:	48 89 c6             	mov    %rax,%rsi
  8024fe:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802503:	48 b8 61 1b 80 00 00 	movabs $0x801b61,%rax
  80250a:	00 00 00 
  80250d:	ff d0                	callq  *%rax
	if (sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0)
  80250f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802513:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802519:	48 89 c1             	mov    %rax,%rcx
  80251c:	ba 00 00 00 00       	mov    $0x0,%edx
  802521:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802526:	bf 00 00 00 00       	mov    $0x0,%edi
  80252b:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  802532:	00 00 00 
  802535:	ff d0                	callq  *%rax
  802537:	85 c0                	test   %eax,%eax
  802539:	79 2a                	jns    802565 <pgfault+0x175>
		panic("pgfault: sys_page_map error\n");
  80253b:	48 ba 4f 59 80 00 00 	movabs $0x80594f,%rdx
  802542:	00 00 00 
  802545:	be 32 00 00 00       	mov    $0x32,%esi
  80254a:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  802551:	00 00 00 
  802554:	b8 00 00 00 00       	mov    $0x0,%eax
  802559:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  802560:	00 00 00 
  802563:	ff d1                	callq  *%rcx

	if (sys_page_unmap(0, (void *)PFTEMP)<0)
  802565:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80256a:	bf 00 00 00 00       	mov    $0x0,%edi
  80256f:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  802576:	00 00 00 
  802579:	ff d0                	callq  *%rax
  80257b:	85 c0                	test   %eax,%eax
  80257d:	79 2a                	jns    8025a9 <pgfault+0x1b9>
		panic("pgfault: sys_page_unmap error\n");
  80257f:	48 ba 70 59 80 00 00 	movabs $0x805970,%rdx
  802586:	00 00 00 
  802589:	be 35 00 00 00       	mov    $0x35,%esi
  80258e:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  802595:	00 00 00 
  802598:	b8 00 00 00 00       	mov    $0x0,%eax
  80259d:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  8025a4:	00 00 00 
  8025a7:	ff d1                	callq  *%rcx
	


}
  8025a9:	c9                   	leaveq 
  8025aa:	c3                   	retq   

00000000008025ab <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8025ab:	55                   	push   %rbp
  8025ac:	48 89 e5             	mov    %rsp,%rbp
  8025af:	48 83 ec 10          	sub    $0x10,%rsp
  8025b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025b6:	89 75 f8             	mov    %esi,-0x8(%rbp)

	if (uvpt[pn] & PTE_SHARE){
  8025b9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025c0:	01 00 00 
  8025c3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8025c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ca:	25 00 04 00 00       	and    $0x400,%eax
  8025cf:	48 85 c0             	test   %rax,%rax
  8025d2:	74 75                	je     802649 <duppage+0x9e>
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
  8025d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025db:	01 00 00 
  8025de:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8025e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025e5:	25 07 0e 00 00       	and    $0xe07,%eax
  8025ea:	89 c6                	mov    %eax,%esi
  8025ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025ef:	48 c1 e0 0c          	shl    $0xc,%rax
  8025f3:	48 89 c1             	mov    %rax,%rcx
  8025f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025f9:	48 c1 e0 0c          	shl    $0xc,%rax
  8025fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802600:	41 89 f0             	mov    %esi,%r8d
  802603:	48 89 c6             	mov    %rax,%rsi
  802606:	bf 00 00 00 00       	mov    $0x0,%edi
  80260b:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  802612:	00 00 00 
  802615:	ff d0                	callq  *%rax
  802617:	85 c0                	test   %eax,%eax
  802619:	0f 89 82 01 00 00    	jns    8027a1 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");	
  80261f:	48 ba 8f 59 80 00 00 	movabs $0x80598f,%rdx
  802626:	00 00 00 
  802629:	be 4c 00 00 00       	mov    $0x4c,%esi
  80262e:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  802635:	00 00 00 
  802638:	b8 00 00 00 00       	mov    $0x0,%eax
  80263d:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  802644:	00 00 00 
  802647:	ff d1                	callq  *%rcx
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
  802649:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802650:	01 00 00 
  802653:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802656:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80265a:	83 e0 02             	and    $0x2,%eax
  80265d:	48 85 c0             	test   %rax,%rax
  802660:	75 7e                	jne    8026e0 <duppage+0x135>
  802662:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802669:	01 00 00 
  80266c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80266f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802673:	25 00 08 00 00       	and    $0x800,%eax
  802678:	48 85 c0             	test   %rax,%rax
  80267b:	75 63                	jne    8026e0 <duppage+0x135>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  80267d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802680:	c1 e0 0c             	shl    $0xc,%eax
  802683:	89 c0                	mov    %eax,%eax
  802685:	48 89 c1             	mov    %rax,%rcx
  802688:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80268b:	c1 e0 0c             	shl    $0xc,%eax
  80268e:	89 c0                	mov    %eax,%eax
  802690:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802693:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  802699:	48 89 c6             	mov    %rax,%rsi
  80269c:	bf 00 00 00 00       	mov    $0x0,%edi
  8026a1:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  8026a8:	00 00 00 
  8026ab:	ff d0                	callq  *%rax
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	79 2a                	jns    8026db <duppage+0x130>
			panic("duppage:sys_page_map error\n");
  8026b1:	48 ba 8f 59 80 00 00 	movabs $0x80598f,%rdx
  8026b8:	00 00 00 
  8026bb:	be 51 00 00 00       	mov    $0x51,%esi
  8026c0:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  8026c7:	00 00 00 
  8026ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cf:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  8026d6:	00 00 00 
  8026d9:	ff d1                	callq  *%rcx
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
			panic("duppage:sys_page_map error\n");	
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  8026db:	e9 c1 00 00 00       	jmpq   8027a1 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  8026e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026e3:	c1 e0 0c             	shl    $0xc,%eax
  8026e6:	89 c0                	mov    %eax,%eax
  8026e8:	48 89 c1             	mov    %rax,%rcx
  8026eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026ee:	c1 e0 0c             	shl    $0xc,%eax
  8026f1:	89 c0                	mov    %eax,%eax
  8026f3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026f6:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8026fc:	48 89 c6             	mov    %rax,%rsi
  8026ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802704:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  80270b:	00 00 00 
  80270e:	ff d0                	callq  *%rax
  802710:	85 c0                	test   %eax,%eax
  802712:	79 2a                	jns    80273e <duppage+0x193>
			panic("duppage:sys_page_map error\n");
  802714:	48 ba 8f 59 80 00 00 	movabs $0x80598f,%rdx
  80271b:	00 00 00 
  80271e:	be 55 00 00 00       	mov    $0x55,%esi
  802723:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  80272a:	00 00 00 
  80272d:	b8 00 00 00 00       	mov    $0x0,%eax
  802732:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  802739:	00 00 00 
  80273c:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  80273e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802741:	c1 e0 0c             	shl    $0xc,%eax
  802744:	89 c0                	mov    %eax,%eax
  802746:	48 89 c2             	mov    %rax,%rdx
  802749:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80274c:	c1 e0 0c             	shl    $0xc,%eax
  80274f:	89 c0                	mov    %eax,%eax
  802751:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802757:	48 89 d1             	mov    %rdx,%rcx
  80275a:	ba 00 00 00 00       	mov    $0x0,%edx
  80275f:	48 89 c6             	mov    %rax,%rsi
  802762:	bf 00 00 00 00       	mov    $0x0,%edi
  802767:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  80276e:	00 00 00 
  802771:	ff d0                	callq  *%rax
  802773:	85 c0                	test   %eax,%eax
  802775:	79 2a                	jns    8027a1 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
  802777:	48 ba 8f 59 80 00 00 	movabs $0x80598f,%rdx
  80277e:	00 00 00 
  802781:	be 57 00 00 00       	mov    $0x57,%esi
  802786:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  80278d:	00 00 00 
  802790:	b8 00 00 00 00       	mov    $0x0,%eax
  802795:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  80279c:	00 00 00 
  80279f:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  8027a1:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8027a6:	c9                   	leaveq 
  8027a7:	c3                   	retq   

00000000008027a8 <new_duppage>:


static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
  8027a8:	55                   	push   %rbp
  8027a9:	48 89 e5             	mov    %rsp,%rbp
  8027ac:	48 83 ec 10          	sub    $0x10,%rsp
  8027b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027b3:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8027b6:	89 55 f4             	mov    %edx,-0xc(%rbp)
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
  8027b9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027c0:	01 00 00 
  8027c3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8027c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027ca:	83 e0 02             	and    $0x2,%eax
  8027cd:	48 85 c0             	test   %rax,%rax
  8027d0:	0f 85 84 00 00 00    	jne    80285a <new_duppage+0xb2>
  8027d6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027dd:	01 00 00 
  8027e0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8027e3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027e7:	25 00 08 00 00       	and    $0x800,%eax
  8027ec:	48 85 c0             	test   %rax,%rax
  8027ef:	75 69                	jne    80285a <new_duppage+0xb2>
  8027f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8027f5:	75 63                	jne    80285a <new_duppage+0xb2>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  8027f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027fa:	c1 e0 0c             	shl    $0xc,%eax
  8027fd:	89 c0                	mov    %eax,%eax
  8027ff:	48 89 c1             	mov    %rax,%rcx
  802802:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802805:	c1 e0 0c             	shl    $0xc,%eax
  802808:	89 c0                	mov    %eax,%eax
  80280a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80280d:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  802813:	48 89 c6             	mov    %rax,%rsi
  802816:	bf 00 00 00 00       	mov    $0x0,%edi
  80281b:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  802822:	00 00 00 
  802825:	ff d0                	callq  *%rax
  802827:	85 c0                	test   %eax,%eax
  802829:	79 2a                	jns    802855 <new_duppage+0xad>
			panic("duppage:sys_page_map error\n");
  80282b:	48 ba 8f 59 80 00 00 	movabs $0x80598f,%rdx
  802832:	00 00 00 
  802835:	be 64 00 00 00       	mov    $0x64,%esi
  80283a:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  802841:	00 00 00 
  802844:	b8 00 00 00 00       	mov    $0x0,%eax
  802849:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  802850:	00 00 00 
  802853:	ff d1                	callq  *%rcx
static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  802855:	e9 c1 00 00 00       	jmpq   80291b <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  80285a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80285d:	c1 e0 0c             	shl    $0xc,%eax
  802860:	89 c0                	mov    %eax,%eax
  802862:	48 89 c1             	mov    %rax,%rcx
  802865:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802868:	c1 e0 0c             	shl    $0xc,%eax
  80286b:	89 c0                	mov    %eax,%eax
  80286d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802870:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802876:	48 89 c6             	mov    %rax,%rsi
  802879:	bf 00 00 00 00       	mov    $0x0,%edi
  80287e:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  802885:	00 00 00 
  802888:	ff d0                	callq  *%rax
  80288a:	85 c0                	test   %eax,%eax
  80288c:	79 2a                	jns    8028b8 <new_duppage+0x110>
			panic("duppage:sys_page_map error\n");
  80288e:	48 ba 8f 59 80 00 00 	movabs $0x80598f,%rdx
  802895:	00 00 00 
  802898:	be 68 00 00 00       	mov    $0x68,%esi
  80289d:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  8028a4:	00 00 00 
  8028a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ac:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  8028b3:	00 00 00 
  8028b6:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  8028b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028bb:	c1 e0 0c             	shl    $0xc,%eax
  8028be:	89 c0                	mov    %eax,%eax
  8028c0:	48 89 c2             	mov    %rax,%rdx
  8028c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028c6:	c1 e0 0c             	shl    $0xc,%eax
  8028c9:	89 c0                	mov    %eax,%eax
  8028cb:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8028d1:	48 89 d1             	mov    %rdx,%rcx
  8028d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8028d9:	48 89 c6             	mov    %rax,%rsi
  8028dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e1:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  8028e8:	00 00 00 
  8028eb:	ff d0                	callq  *%rax
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	79 2a                	jns    80291b <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
  8028f1:	48 ba 8f 59 80 00 00 	movabs $0x80598f,%rdx
  8028f8:	00 00 00 
  8028fb:	be 6a 00 00 00       	mov    $0x6a,%esi
  802900:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  802907:	00 00 00 
  80290a:	b8 00 00 00 00       	mov    $0x0,%eax
  80290f:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  802916:	00 00 00 
  802919:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  80291b:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802920:	c9                   	leaveq 
  802921:	c3                   	retq   

0000000000802922 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802922:	55                   	push   %rbp
  802923:	48 89 e5             	mov    %rsp,%rbp
  802926:	48 83 ec 10          	sub    $0x10,%rsp


	
	int envid;  
	//extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  80292a:	48 bf f0 23 80 00 00 	movabs $0x8023f0,%rdi
  802931:	00 00 00 
  802934:	48 b8 91 4e 80 00 00 	movabs $0x804e91,%rax
  80293b:	00 00 00 
  80293e:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802940:	b8 07 00 00 00       	mov    $0x7,%eax
  802945:	cd 30                	int    $0x30
  802947:	89 45 f0             	mov    %eax,-0x10(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80294a:	8b 45 f0             	mov    -0x10(%rbp),%eax


	if ((envid=sys_exofork())<0)
  80294d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802950:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802954:	79 2a                	jns    802980 <fork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  802956:	48 ba ab 59 80 00 00 	movabs $0x8059ab,%rdx
  80295d:	00 00 00 
  802960:	be 90 00 00 00       	mov    $0x90,%esi
  802965:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  80296c:	00 00 00 
  80296f:	b8 00 00 00 00       	mov    $0x0,%eax
  802974:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  80297b:	00 00 00 
  80297e:	ff d1                	callq  *%rcx

	if(envid>0){
  802980:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802984:	0f 8e e1 01 00 00    	jle    802b6b <fork+0x249>
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  80298a:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  802991:	00 
  802992:	e9 d4 00 00 00       	jmpq   802a6b <fork+0x149>
		{
			

               if(!(uvpml4e[VPML4E(i)]))
  802997:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80299b:	48 c1 e8 27          	shr    $0x27,%rax
  80299f:	48 89 c2             	mov    %rax,%rdx
  8029a2:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8029a9:	01 00 00 
  8029ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029b0:	48 85 c0             	test   %rax,%rax
  8029b3:	75 05                	jne    8029ba <fork+0x98>
		 continue;
  8029b5:	e9 a9 00 00 00       	jmpq   802a63 <fork+0x141>
		
		if(!(uvpde[VPDPE(i)]))
  8029ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029be:	48 c1 e8 1e          	shr    $0x1e,%rax
  8029c2:	48 89 c2             	mov    %rax,%rdx
  8029c5:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8029cc:	01 00 00 
  8029cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029d3:	48 85 c0             	test   %rax,%rax
  8029d6:	75 05                	jne    8029dd <fork+0xbb>
	          continue;
  8029d8:	e9 86 00 00 00       	jmpq   802a63 <fork+0x141>
	

			if(!(uvpd[VPD(i)] & PTE_P))
  8029dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029e1:	48 c1 e8 15          	shr    $0x15,%rax
  8029e5:	48 89 c2             	mov    %rax,%rdx
  8029e8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029ef:	01 00 00 
  8029f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029f6:	83 e0 01             	and    $0x1,%eax
  8029f9:	48 85 c0             	test   %rax,%rax
  8029fc:	75 02                	jne    802a00 <fork+0xde>
				continue;
  8029fe:	eb 63                	jmp    802a63 <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_P))
  802a00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a04:	48 c1 e8 0c          	shr    $0xc,%rax
  802a08:	48 89 c2             	mov    %rax,%rdx
  802a0b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a12:	01 00 00 
  802a15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a19:	83 e0 01             	and    $0x1,%eax
  802a1c:	48 85 c0             	test   %rax,%rax
  802a1f:	75 02                	jne    802a23 <fork+0x101>
				continue; 
  802a21:	eb 40                	jmp    802a63 <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_U))
  802a23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a27:	48 c1 e8 0c          	shr    $0xc,%rax
  802a2b:	48 89 c2             	mov    %rax,%rdx
  802a2e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a35:	01 00 00 
  802a38:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a3c:	83 e0 04             	and    $0x4,%eax
  802a3f:	48 85 c0             	test   %rax,%rax
  802a42:	75 02                	jne    802a46 <fork+0x124>
				continue; 
  802a44:	eb 1d                	jmp    802a63 <fork+0x141>
			duppage(envid, VPN(i)); 
  802a46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a4a:	48 c1 e8 0c          	shr    $0xc,%rax
  802a4e:	89 c2                	mov    %eax,%edx
  802a50:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a53:	89 d6                	mov    %edx,%esi
  802a55:	89 c7                	mov    %eax,%edi
  802a57:	48 b8 ab 25 80 00 00 	movabs $0x8025ab,%rax
  802a5e:	00 00 00 
  802a61:	ff d0                	callq  *%rax

	if(envid>0){
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  802a63:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  802a6a:	00 
  802a6b:	b8 ff cf 7f ef       	mov    $0xef7fcfff,%eax
  802a70:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802a74:	0f 86 1d ff ff ff    	jbe    802997 <fork+0x75>
			if(!(uvpt[VPN(i)] & PTE_U))
				continue; 
			duppage(envid, VPN(i)); 
		}

		if (sys_page_alloc(envid,(void*)UXSTACKTOP-PGSIZE, PTE_U|PTE_W|PTE_P)<0)
  802a7a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a7d:	ba 07 00 00 00       	mov    $0x7,%edx
  802a82:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802a87:	89 c7                	mov    %eax,%edi
  802a89:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  802a90:	00 00 00 
  802a93:	ff d0                	callq  *%rax
  802a95:	85 c0                	test   %eax,%eax
  802a97:	79 2a                	jns    802ac3 <fork+0x1a1>
			panic("fork: sys_page_alloc error!\n");
  802a99:	48 ba c5 59 80 00 00 	movabs $0x8059c5,%rdx
  802aa0:	00 00 00 
  802aa3:	be ab 00 00 00       	mov    $0xab,%esi
  802aa8:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  802aaf:	00 00 00 
  802ab2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab7:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  802abe:	00 00 00 
  802ac1:	ff d1                	callq  *%rcx

		duppage(envid, VPN(USTACKTOP-PGSIZE));
  802ac3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ac6:	be fd f7 0e 00       	mov    $0xef7fd,%esi
  802acb:	89 c7                	mov    %eax,%edi
  802acd:	48 b8 ab 25 80 00 00 	movabs $0x8025ab,%rax
  802ad4:	00 00 00 
  802ad7:	ff d0                	callq  *%rax
		extern void _pgfault_upcall(void);
		if (sys_env_set_pgfault_upcall(envid, _pgfault_upcall)<0)
  802ad9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802adc:	48 be 31 4f 80 00 00 	movabs $0x804f31,%rsi
  802ae3:	00 00 00 
  802ae6:	89 c7                	mov    %eax,%edi
  802ae8:	48 b8 df 21 80 00 00 	movabs $0x8021df,%rax
  802aef:	00 00 00 
  802af2:	ff d0                	callq  *%rax
  802af4:	85 c0                	test   %eax,%eax
  802af6:	79 2a                	jns    802b22 <fork+0x200>
			panic("fork: sys_env_set_status error!\n");
  802af8:	48 ba e8 59 80 00 00 	movabs $0x8059e8,%rdx
  802aff:	00 00 00 
  802b02:	be b0 00 00 00       	mov    $0xb0,%esi
  802b07:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  802b0e:	00 00 00 
  802b11:	b8 00 00 00 00       	mov    $0x0,%eax
  802b16:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  802b1d:	00 00 00 
  802b20:	ff d1                	callq  *%rcx
		if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  802b22:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b25:	be 02 00 00 00       	mov    $0x2,%esi
  802b2a:	89 c7                	mov    %eax,%edi
  802b2c:	48 b8 4a 21 80 00 00 	movabs $0x80214a,%rax
  802b33:	00 00 00 
  802b36:	ff d0                	callq  *%rax
  802b38:	85 c0                	test   %eax,%eax
  802b3a:	79 2a                	jns    802b66 <fork+0x244>
			panic("fork: sys_env_set_status error!\n");
  802b3c:	48 ba e8 59 80 00 00 	movabs $0x8059e8,%rdx
  802b43:	00 00 00 
  802b46:	be b2 00 00 00       	mov    $0xb2,%esi
  802b4b:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  802b52:	00 00 00 
  802b55:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5a:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  802b61:	00 00 00 
  802b64:	ff d1                	callq  *%rcx

		return envid;
  802b66:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b69:	eb 39                	jmp    802ba4 <fork+0x282>
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802b6b:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  802b72:	00 00 00 
  802b75:	ff d0                	callq  *%rax
  802b77:	25 ff 03 00 00       	and    $0x3ff,%eax
  802b7c:	48 98                	cltq   
  802b7e:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  802b85:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802b8c:	00 00 00 
  802b8f:	48 01 c2             	add    %rax,%rdx
  802b92:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802b99:	00 00 00 
  802b9c:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802b9f:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  802ba4:	c9                   	leaveq 
  802ba5:	c3                   	retq   

0000000000802ba6 <sfork>:

// Challenge!
envid_t
sfork(void)
{
  802ba6:	55                   	push   %rbp
  802ba7:	48 89 e5             	mov    %rsp,%rbp
  802baa:	48 83 ec 20          	sub    $0x20,%rsp

	
	int envid;  
	extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  802bae:	48 bf f0 23 80 00 00 	movabs $0x8023f0,%rdi
  802bb5:	00 00 00 
  802bb8:	48 b8 91 4e 80 00 00 	movabs $0x804e91,%rax
  802bbf:	00 00 00 
  802bc2:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802bc4:	b8 07 00 00 00       	mov    $0x7,%eax
  802bc9:	cd 30                	int    $0x30
  802bcb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802bce:	8b 45 ec             	mov    -0x14(%rbp),%eax
	

	if ((envid=sys_exofork())<0)
  802bd1:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802bd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802bd8:	79 2a                	jns    802c04 <sfork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  802bda:	48 ba ab 59 80 00 00 	movabs $0x8059ab,%rdx
  802be1:	00 00 00 
  802be4:	be ca 00 00 00       	mov    $0xca,%esi
  802be9:	48 bf 0e 59 80 00 00 	movabs $0x80590e,%rdi
  802bf0:	00 00 00 
  802bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf8:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  802bff:	00 00 00 
  802c02:	ff d1                	callq  *%rcx

	if(envid>0){
  802c04:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c08:	0f 8e e5 00 00 00    	jle    802cf3 <sfork+0x14d>
		
		
		uintptr_t i;
		int flag=1;
  802c0e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)

		for (i = 0; i < (uintptr_t)end/*USTACKTOP-PGSIZE*/; i += PGSIZE) ;
  802c15:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802c1c:	00 
  802c1d:	eb 08                	jmp    802c27 <sfork+0x81>
  802c1f:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  802c26:	00 
  802c27:	48 b8 10 a0 80 00 00 	movabs $0x80a010,%rax
  802c2e:	00 00 00 
  802c31:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802c35:	72 e8                	jb     802c1f <sfork+0x79>
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
  802c37:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802c3e:	00 
    for (;i>=0; i -= PGSIZE) 
		{
			cprintf("23\n");
  802c3f:	48 bf 09 5a 80 00 00 	movabs $0x805a09,%rdi
  802c46:	00 00 00 
  802c49:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4e:	48 ba 30 0b 80 00 00 	movabs $0x800b30,%rdx
  802c55:	00 00 00 
  802c58:	ff d2                	callq  *%rdx
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
  802c5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c5e:	48 c1 e8 15          	shr    $0x15,%rax
  802c62:	48 89 c2             	mov    %rax,%rdx
  802c65:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802c6c:	01 00 00 
  802c6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c73:	83 e0 01             	and    $0x1,%eax
  802c76:	48 85 c0             	test   %rax,%rax
  802c79:	74 42                	je     802cbd <sfork+0x117>
  802c7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c7f:	48 c1 e8 0c          	shr    $0xc,%rax
  802c83:	48 89 c2             	mov    %rax,%rdx
  802c86:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c8d:	01 00 00 
  802c90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c94:	83 e0 01             	and    $0x1,%eax
  802c97:	48 85 c0             	test   %rax,%rax
  802c9a:	74 21                	je     802cbd <sfork+0x117>
  802c9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ca0:	48 c1 e8 0c          	shr    $0xc,%rax
  802ca4:	48 89 c2             	mov    %rax,%rdx
  802ca7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cae:	01 00 00 
  802cb1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cb5:	83 e0 04             	and    $0x4,%eax
  802cb8:	48 85 c0             	test   %rax,%rax
  802cbb:	75 09                	jne    802cc6 <sfork+0x120>
				flag=0;
  802cbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802cc4:	eb 20                	jmp    802ce6 <sfork+0x140>
			else
				new_duppage(envid, VPN(i),flag); 
  802cc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cca:	48 c1 e8 0c          	shr    $0xc,%rax
  802cce:	89 c1                	mov    %eax,%ecx
  802cd0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802cd3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cd6:	89 ce                	mov    %ecx,%esi
  802cd8:	89 c7                	mov    %eax,%edi
  802cda:	48 b8 a8 27 80 00 00 	movabs $0x8027a8,%rax
  802ce1:	00 00 00 
  802ce4:	ff d0                	callq  *%rax
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
    for (;i>=0; i -= PGSIZE) 
  802ce6:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802ced:	00 
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
				flag=0;
			else
				new_duppage(envid, VPN(i),flag); 

		}
  802cee:	e9 4c ff ff ff       	jmpq   802c3f <sfork+0x99>

		return envid;
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802cf3:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  802cfa:	00 00 00 
  802cfd:	ff d0                	callq  *%rax
  802cff:	25 ff 03 00 00       	and    $0x3ff,%eax
  802d04:	48 98                	cltq   
  802d06:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  802d0d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802d14:	00 00 00 
  802d17:	48 01 c2             	add    %rax,%rdx
  802d1a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d21:	00 00 00 
  802d24:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802d27:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  802d2c:	c9                   	leaveq 
  802d2d:	c3                   	retq   

0000000000802d2e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802d2e:	55                   	push   %rbp
  802d2f:	48 89 e5             	mov    %rsp,%rbp
  802d32:	48 83 ec 08          	sub    $0x8,%rsp
  802d36:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802d3a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d3e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802d45:	ff ff ff 
  802d48:	48 01 d0             	add    %rdx,%rax
  802d4b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802d4f:	c9                   	leaveq 
  802d50:	c3                   	retq   

0000000000802d51 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802d51:	55                   	push   %rbp
  802d52:	48 89 e5             	mov    %rsp,%rbp
  802d55:	48 83 ec 08          	sub    $0x8,%rsp
  802d59:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802d5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d61:	48 89 c7             	mov    %rax,%rdi
  802d64:	48 b8 2e 2d 80 00 00 	movabs $0x802d2e,%rax
  802d6b:	00 00 00 
  802d6e:	ff d0                	callq  *%rax
  802d70:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802d76:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802d7a:	c9                   	leaveq 
  802d7b:	c3                   	retq   

0000000000802d7c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802d7c:	55                   	push   %rbp
  802d7d:	48 89 e5             	mov    %rsp,%rbp
  802d80:	48 83 ec 18          	sub    $0x18,%rsp
  802d84:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802d88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d8f:	eb 6b                	jmp    802dfc <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802d91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d94:	48 98                	cltq   
  802d96:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802d9c:	48 c1 e0 0c          	shl    $0xc,%rax
  802da0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802da4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da8:	48 c1 e8 15          	shr    $0x15,%rax
  802dac:	48 89 c2             	mov    %rax,%rdx
  802daf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802db6:	01 00 00 
  802db9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dbd:	83 e0 01             	and    $0x1,%eax
  802dc0:	48 85 c0             	test   %rax,%rax
  802dc3:	74 21                	je     802de6 <fd_alloc+0x6a>
  802dc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc9:	48 c1 e8 0c          	shr    $0xc,%rax
  802dcd:	48 89 c2             	mov    %rax,%rdx
  802dd0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802dd7:	01 00 00 
  802dda:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dde:	83 e0 01             	and    $0x1,%eax
  802de1:	48 85 c0             	test   %rax,%rax
  802de4:	75 12                	jne    802df8 <fd_alloc+0x7c>
			*fd_store = fd;
  802de6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dee:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802df1:	b8 00 00 00 00       	mov    $0x0,%eax
  802df6:	eb 1a                	jmp    802e12 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802df8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802dfc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802e00:	7e 8f                	jle    802d91 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802e02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e06:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802e0d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802e12:	c9                   	leaveq 
  802e13:	c3                   	retq   

0000000000802e14 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802e14:	55                   	push   %rbp
  802e15:	48 89 e5             	mov    %rsp,%rbp
  802e18:	48 83 ec 20          	sub    $0x20,%rsp
  802e1c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802e23:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e27:	78 06                	js     802e2f <fd_lookup+0x1b>
  802e29:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802e2d:	7e 07                	jle    802e36 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802e2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e34:	eb 6c                	jmp    802ea2 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802e36:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e39:	48 98                	cltq   
  802e3b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802e41:	48 c1 e0 0c          	shl    $0xc,%rax
  802e45:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802e49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e4d:	48 c1 e8 15          	shr    $0x15,%rax
  802e51:	48 89 c2             	mov    %rax,%rdx
  802e54:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802e5b:	01 00 00 
  802e5e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e62:	83 e0 01             	and    $0x1,%eax
  802e65:	48 85 c0             	test   %rax,%rax
  802e68:	74 21                	je     802e8b <fd_lookup+0x77>
  802e6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e6e:	48 c1 e8 0c          	shr    $0xc,%rax
  802e72:	48 89 c2             	mov    %rax,%rdx
  802e75:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e7c:	01 00 00 
  802e7f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e83:	83 e0 01             	and    $0x1,%eax
  802e86:	48 85 c0             	test   %rax,%rax
  802e89:	75 07                	jne    802e92 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802e8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e90:	eb 10                	jmp    802ea2 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802e92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e96:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e9a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802e9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ea2:	c9                   	leaveq 
  802ea3:	c3                   	retq   

0000000000802ea4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802ea4:	55                   	push   %rbp
  802ea5:	48 89 e5             	mov    %rsp,%rbp
  802ea8:	48 83 ec 30          	sub    $0x30,%rsp
  802eac:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802eb0:	89 f0                	mov    %esi,%eax
  802eb2:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802eb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eb9:	48 89 c7             	mov    %rax,%rdi
  802ebc:	48 b8 2e 2d 80 00 00 	movabs $0x802d2e,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax
  802ec8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ecc:	48 89 d6             	mov    %rdx,%rsi
  802ecf:	89 c7                	mov    %eax,%edi
  802ed1:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  802ed8:	00 00 00 
  802edb:	ff d0                	callq  *%rax
  802edd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee4:	78 0a                	js     802ef0 <fd_close+0x4c>
	    || fd != fd2)
  802ee6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eea:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802eee:	74 12                	je     802f02 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802ef0:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802ef4:	74 05                	je     802efb <fd_close+0x57>
  802ef6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef9:	eb 05                	jmp    802f00 <fd_close+0x5c>
  802efb:	b8 00 00 00 00       	mov    $0x0,%eax
  802f00:	eb 69                	jmp    802f6b <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802f02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f06:	8b 00                	mov    (%rax),%eax
  802f08:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f0c:	48 89 d6             	mov    %rdx,%rsi
  802f0f:	89 c7                	mov    %eax,%edi
  802f11:	48 b8 6d 2f 80 00 00 	movabs $0x802f6d,%rax
  802f18:	00 00 00 
  802f1b:	ff d0                	callq  *%rax
  802f1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f24:	78 2a                	js     802f50 <fd_close+0xac>
		if (dev->dev_close)
  802f26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f2a:	48 8b 40 20          	mov    0x20(%rax),%rax
  802f2e:	48 85 c0             	test   %rax,%rax
  802f31:	74 16                	je     802f49 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f37:	48 8b 40 20          	mov    0x20(%rax),%rax
  802f3b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f3f:	48 89 d7             	mov    %rdx,%rdi
  802f42:	ff d0                	callq  *%rax
  802f44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f47:	eb 07                	jmp    802f50 <fd_close+0xac>
		else
			r = 0;
  802f49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802f50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f54:	48 89 c6             	mov    %rax,%rsi
  802f57:	bf 00 00 00 00       	mov    $0x0,%edi
  802f5c:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  802f63:	00 00 00 
  802f66:	ff d0                	callq  *%rax
	return r;
  802f68:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f6b:	c9                   	leaveq 
  802f6c:	c3                   	retq   

0000000000802f6d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802f6d:	55                   	push   %rbp
  802f6e:	48 89 e5             	mov    %rsp,%rbp
  802f71:	48 83 ec 20          	sub    $0x20,%rsp
  802f75:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802f7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802f83:	eb 41                	jmp    802fc6 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802f85:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802f8c:	00 00 00 
  802f8f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f92:	48 63 d2             	movslq %edx,%rdx
  802f95:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f99:	8b 00                	mov    (%rax),%eax
  802f9b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802f9e:	75 22                	jne    802fc2 <dev_lookup+0x55>
			*dev = devtab[i];
  802fa0:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802fa7:	00 00 00 
  802faa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fad:	48 63 d2             	movslq %edx,%rdx
  802fb0:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802fb4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fb8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802fbb:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc0:	eb 60                	jmp    803022 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802fc2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802fc6:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802fcd:	00 00 00 
  802fd0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fd3:	48 63 d2             	movslq %edx,%rdx
  802fd6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802fda:	48 85 c0             	test   %rax,%rax
  802fdd:	75 a6                	jne    802f85 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802fdf:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802fe6:	00 00 00 
  802fe9:	48 8b 00             	mov    (%rax),%rax
  802fec:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ff2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ff5:	89 c6                	mov    %eax,%esi
  802ff7:	48 bf 10 5a 80 00 00 	movabs $0x805a10,%rdi
  802ffe:	00 00 00 
  803001:	b8 00 00 00 00       	mov    $0x0,%eax
  803006:	48 b9 30 0b 80 00 00 	movabs $0x800b30,%rcx
  80300d:	00 00 00 
  803010:	ff d1                	callq  *%rcx
	*dev = 0;
  803012:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803016:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80301d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803022:	c9                   	leaveq 
  803023:	c3                   	retq   

0000000000803024 <close>:

int
close(int fdnum)
{
  803024:	55                   	push   %rbp
  803025:	48 89 e5             	mov    %rsp,%rbp
  803028:	48 83 ec 20          	sub    $0x20,%rsp
  80302c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80302f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803033:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803036:	48 89 d6             	mov    %rdx,%rsi
  803039:	89 c7                	mov    %eax,%edi
  80303b:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  803042:	00 00 00 
  803045:	ff d0                	callq  *%rax
  803047:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80304a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80304e:	79 05                	jns    803055 <close+0x31>
		return r;
  803050:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803053:	eb 18                	jmp    80306d <close+0x49>
	else
		return fd_close(fd, 1);
  803055:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803059:	be 01 00 00 00       	mov    $0x1,%esi
  80305e:	48 89 c7             	mov    %rax,%rdi
  803061:	48 b8 a4 2e 80 00 00 	movabs $0x802ea4,%rax
  803068:	00 00 00 
  80306b:	ff d0                	callq  *%rax
}
  80306d:	c9                   	leaveq 
  80306e:	c3                   	retq   

000000000080306f <close_all>:

void
close_all(void)
{
  80306f:	55                   	push   %rbp
  803070:	48 89 e5             	mov    %rsp,%rbp
  803073:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80307e:	eb 15                	jmp    803095 <close_all+0x26>
		close(i);
  803080:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803083:	89 c7                	mov    %eax,%edi
  803085:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  80308c:	00 00 00 
  80308f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  803091:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803095:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803099:	7e e5                	jle    803080 <close_all+0x11>
		close(i);
}
  80309b:	c9                   	leaveq 
  80309c:	c3                   	retq   

000000000080309d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80309d:	55                   	push   %rbp
  80309e:	48 89 e5             	mov    %rsp,%rbp
  8030a1:	48 83 ec 40          	sub    $0x40,%rsp
  8030a5:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8030a8:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8030ab:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8030af:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8030b2:	48 89 d6             	mov    %rdx,%rsi
  8030b5:	89 c7                	mov    %eax,%edi
  8030b7:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  8030be:	00 00 00 
  8030c1:	ff d0                	callq  *%rax
  8030c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ca:	79 08                	jns    8030d4 <dup+0x37>
		return r;
  8030cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030cf:	e9 70 01 00 00       	jmpq   803244 <dup+0x1a7>
	close(newfdnum);
  8030d4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8030d7:	89 c7                	mov    %eax,%edi
  8030d9:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  8030e0:	00 00 00 
  8030e3:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8030e5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8030e8:	48 98                	cltq   
  8030ea:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8030f0:	48 c1 e0 0c          	shl    $0xc,%rax
  8030f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8030f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030fc:	48 89 c7             	mov    %rax,%rdi
  8030ff:	48 b8 51 2d 80 00 00 	movabs $0x802d51,%rax
  803106:	00 00 00 
  803109:	ff d0                	callq  *%rax
  80310b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80310f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803113:	48 89 c7             	mov    %rax,%rdi
  803116:	48 b8 51 2d 80 00 00 	movabs $0x802d51,%rax
  80311d:	00 00 00 
  803120:	ff d0                	callq  *%rax
  803122:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803126:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80312a:	48 c1 e8 15          	shr    $0x15,%rax
  80312e:	48 89 c2             	mov    %rax,%rdx
  803131:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803138:	01 00 00 
  80313b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80313f:	83 e0 01             	and    $0x1,%eax
  803142:	48 85 c0             	test   %rax,%rax
  803145:	74 73                	je     8031ba <dup+0x11d>
  803147:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80314b:	48 c1 e8 0c          	shr    $0xc,%rax
  80314f:	48 89 c2             	mov    %rax,%rdx
  803152:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803159:	01 00 00 
  80315c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803160:	83 e0 01             	and    $0x1,%eax
  803163:	48 85 c0             	test   %rax,%rax
  803166:	74 52                	je     8031ba <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80316c:	48 c1 e8 0c          	shr    $0xc,%rax
  803170:	48 89 c2             	mov    %rax,%rdx
  803173:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80317a:	01 00 00 
  80317d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803181:	25 07 0e 00 00       	and    $0xe07,%eax
  803186:	89 c1                	mov    %eax,%ecx
  803188:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80318c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803190:	41 89 c8             	mov    %ecx,%r8d
  803193:	48 89 d1             	mov    %rdx,%rcx
  803196:	ba 00 00 00 00       	mov    $0x0,%edx
  80319b:	48 89 c6             	mov    %rax,%rsi
  80319e:	bf 00 00 00 00       	mov    $0x0,%edi
  8031a3:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  8031aa:	00 00 00 
  8031ad:	ff d0                	callq  *%rax
  8031af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b6:	79 02                	jns    8031ba <dup+0x11d>
			goto err;
  8031b8:	eb 57                	jmp    803211 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8031ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031be:	48 c1 e8 0c          	shr    $0xc,%rax
  8031c2:	48 89 c2             	mov    %rax,%rdx
  8031c5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8031cc:	01 00 00 
  8031cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031d3:	25 07 0e 00 00       	and    $0xe07,%eax
  8031d8:	89 c1                	mov    %eax,%ecx
  8031da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031e2:	41 89 c8             	mov    %ecx,%r8d
  8031e5:	48 89 d1             	mov    %rdx,%rcx
  8031e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8031ed:	48 89 c6             	mov    %rax,%rsi
  8031f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8031f5:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  8031fc:	00 00 00 
  8031ff:	ff d0                	callq  *%rax
  803201:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803204:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803208:	79 02                	jns    80320c <dup+0x16f>
		goto err;
  80320a:	eb 05                	jmp    803211 <dup+0x174>

	return newfdnum;
  80320c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80320f:	eb 33                	jmp    803244 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  803211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803215:	48 89 c6             	mov    %rax,%rsi
  803218:	bf 00 00 00 00       	mov    $0x0,%edi
  80321d:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  803224:	00 00 00 
  803227:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803229:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80322d:	48 89 c6             	mov    %rax,%rsi
  803230:	bf 00 00 00 00       	mov    $0x0,%edi
  803235:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  80323c:	00 00 00 
  80323f:	ff d0                	callq  *%rax
	return r;
  803241:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803244:	c9                   	leaveq 
  803245:	c3                   	retq   

0000000000803246 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803246:	55                   	push   %rbp
  803247:	48 89 e5             	mov    %rsp,%rbp
  80324a:	48 83 ec 40          	sub    $0x40,%rsp
  80324e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803251:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803255:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803259:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80325d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803260:	48 89 d6             	mov    %rdx,%rsi
  803263:	89 c7                	mov    %eax,%edi
  803265:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  80326c:	00 00 00 
  80326f:	ff d0                	callq  *%rax
  803271:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803274:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803278:	78 24                	js     80329e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80327a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80327e:	8b 00                	mov    (%rax),%eax
  803280:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803284:	48 89 d6             	mov    %rdx,%rsi
  803287:	89 c7                	mov    %eax,%edi
  803289:	48 b8 6d 2f 80 00 00 	movabs $0x802f6d,%rax
  803290:	00 00 00 
  803293:	ff d0                	callq  *%rax
  803295:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803298:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80329c:	79 05                	jns    8032a3 <read+0x5d>
		return r;
  80329e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a1:	eb 76                	jmp    803319 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8032a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032a7:	8b 40 08             	mov    0x8(%rax),%eax
  8032aa:	83 e0 03             	and    $0x3,%eax
  8032ad:	83 f8 01             	cmp    $0x1,%eax
  8032b0:	75 3a                	jne    8032ec <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8032b2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8032b9:	00 00 00 
  8032bc:	48 8b 00             	mov    (%rax),%rax
  8032bf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8032c5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8032c8:	89 c6                	mov    %eax,%esi
  8032ca:	48 bf 2f 5a 80 00 00 	movabs $0x805a2f,%rdi
  8032d1:	00 00 00 
  8032d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d9:	48 b9 30 0b 80 00 00 	movabs $0x800b30,%rcx
  8032e0:	00 00 00 
  8032e3:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8032e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8032ea:	eb 2d                	jmp    803319 <read+0xd3>
	}
	if (!dev->dev_read)
  8032ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8032f4:	48 85 c0             	test   %rax,%rax
  8032f7:	75 07                	jne    803300 <read+0xba>
		return -E_NOT_SUPP;
  8032f9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032fe:	eb 19                	jmp    803319 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803304:	48 8b 40 10          	mov    0x10(%rax),%rax
  803308:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80330c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803310:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803314:	48 89 cf             	mov    %rcx,%rdi
  803317:	ff d0                	callq  *%rax
}
  803319:	c9                   	leaveq 
  80331a:	c3                   	retq   

000000000080331b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80331b:	55                   	push   %rbp
  80331c:	48 89 e5             	mov    %rsp,%rbp
  80331f:	48 83 ec 30          	sub    $0x30,%rsp
  803323:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803326:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80332a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80332e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803335:	eb 49                	jmp    803380 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803337:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80333a:	48 98                	cltq   
  80333c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803340:	48 29 c2             	sub    %rax,%rdx
  803343:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803346:	48 63 c8             	movslq %eax,%rcx
  803349:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80334d:	48 01 c1             	add    %rax,%rcx
  803350:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803353:	48 89 ce             	mov    %rcx,%rsi
  803356:	89 c7                	mov    %eax,%edi
  803358:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  80335f:	00 00 00 
  803362:	ff d0                	callq  *%rax
  803364:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803367:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80336b:	79 05                	jns    803372 <readn+0x57>
			return m;
  80336d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803370:	eb 1c                	jmp    80338e <readn+0x73>
		if (m == 0)
  803372:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803376:	75 02                	jne    80337a <readn+0x5f>
			break;
  803378:	eb 11                	jmp    80338b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80337a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80337d:	01 45 fc             	add    %eax,-0x4(%rbp)
  803380:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803383:	48 98                	cltq   
  803385:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803389:	72 ac                	jb     803337 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80338b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80338e:	c9                   	leaveq 
  80338f:	c3                   	retq   

0000000000803390 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803390:	55                   	push   %rbp
  803391:	48 89 e5             	mov    %rsp,%rbp
  803394:	48 83 ec 40          	sub    $0x40,%rsp
  803398:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80339b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80339f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8033a3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8033a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8033aa:	48 89 d6             	mov    %rdx,%rsi
  8033ad:	89 c7                	mov    %eax,%edi
  8033af:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  8033b6:	00 00 00 
  8033b9:	ff d0                	callq  *%rax
  8033bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033c2:	78 24                	js     8033e8 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8033c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c8:	8b 00                	mov    (%rax),%eax
  8033ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8033ce:	48 89 d6             	mov    %rdx,%rsi
  8033d1:	89 c7                	mov    %eax,%edi
  8033d3:	48 b8 6d 2f 80 00 00 	movabs $0x802f6d,%rax
  8033da:	00 00 00 
  8033dd:	ff d0                	callq  *%rax
  8033df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e6:	79 05                	jns    8033ed <write+0x5d>
		return r;
  8033e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033eb:	eb 75                	jmp    803462 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8033ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f1:	8b 40 08             	mov    0x8(%rax),%eax
  8033f4:	83 e0 03             	and    $0x3,%eax
  8033f7:	85 c0                	test   %eax,%eax
  8033f9:	75 3a                	jne    803435 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8033fb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803402:	00 00 00 
  803405:	48 8b 00             	mov    (%rax),%rax
  803408:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80340e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803411:	89 c6                	mov    %eax,%esi
  803413:	48 bf 4b 5a 80 00 00 	movabs $0x805a4b,%rdi
  80341a:	00 00 00 
  80341d:	b8 00 00 00 00       	mov    $0x0,%eax
  803422:	48 b9 30 0b 80 00 00 	movabs $0x800b30,%rcx
  803429:	00 00 00 
  80342c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80342e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803433:	eb 2d                	jmp    803462 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803439:	48 8b 40 18          	mov    0x18(%rax),%rax
  80343d:	48 85 c0             	test   %rax,%rax
  803440:	75 07                	jne    803449 <write+0xb9>
		return -E_NOT_SUPP;
  803442:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803447:	eb 19                	jmp    803462 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803449:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80344d:	48 8b 40 18          	mov    0x18(%rax),%rax
  803451:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803455:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803459:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80345d:	48 89 cf             	mov    %rcx,%rdi
  803460:	ff d0                	callq  *%rax
}
  803462:	c9                   	leaveq 
  803463:	c3                   	retq   

0000000000803464 <seek>:

int
seek(int fdnum, off_t offset)
{
  803464:	55                   	push   %rbp
  803465:	48 89 e5             	mov    %rsp,%rbp
  803468:	48 83 ec 18          	sub    $0x18,%rsp
  80346c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80346f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803472:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803476:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803479:	48 89 d6             	mov    %rdx,%rsi
  80347c:	89 c7                	mov    %eax,%edi
  80347e:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  803485:	00 00 00 
  803488:	ff d0                	callq  *%rax
  80348a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80348d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803491:	79 05                	jns    803498 <seek+0x34>
		return r;
  803493:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803496:	eb 0f                	jmp    8034a7 <seek+0x43>
	fd->fd_offset = offset;
  803498:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80349c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80349f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8034a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034a7:	c9                   	leaveq 
  8034a8:	c3                   	retq   

00000000008034a9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8034a9:	55                   	push   %rbp
  8034aa:	48 89 e5             	mov    %rsp,%rbp
  8034ad:	48 83 ec 30          	sub    $0x30,%rsp
  8034b1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8034b4:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8034b7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8034bb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034be:	48 89 d6             	mov    %rdx,%rsi
  8034c1:	89 c7                	mov    %eax,%edi
  8034c3:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  8034ca:	00 00 00 
  8034cd:	ff d0                	callq  *%rax
  8034cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d6:	78 24                	js     8034fc <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8034d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034dc:	8b 00                	mov    (%rax),%eax
  8034de:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034e2:	48 89 d6             	mov    %rdx,%rsi
  8034e5:	89 c7                	mov    %eax,%edi
  8034e7:	48 b8 6d 2f 80 00 00 	movabs $0x802f6d,%rax
  8034ee:	00 00 00 
  8034f1:	ff d0                	callq  *%rax
  8034f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034fa:	79 05                	jns    803501 <ftruncate+0x58>
		return r;
  8034fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ff:	eb 72                	jmp    803573 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803501:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803505:	8b 40 08             	mov    0x8(%rax),%eax
  803508:	83 e0 03             	and    $0x3,%eax
  80350b:	85 c0                	test   %eax,%eax
  80350d:	75 3a                	jne    803549 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80350f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803516:	00 00 00 
  803519:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80351c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803522:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803525:	89 c6                	mov    %eax,%esi
  803527:	48 bf 68 5a 80 00 00 	movabs $0x805a68,%rdi
  80352e:	00 00 00 
  803531:	b8 00 00 00 00       	mov    $0x0,%eax
  803536:	48 b9 30 0b 80 00 00 	movabs $0x800b30,%rcx
  80353d:	00 00 00 
  803540:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803542:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803547:	eb 2a                	jmp    803573 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354d:	48 8b 40 30          	mov    0x30(%rax),%rax
  803551:	48 85 c0             	test   %rax,%rax
  803554:	75 07                	jne    80355d <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803556:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80355b:	eb 16                	jmp    803573 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80355d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803561:	48 8b 40 30          	mov    0x30(%rax),%rax
  803565:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803569:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80356c:	89 ce                	mov    %ecx,%esi
  80356e:	48 89 d7             	mov    %rdx,%rdi
  803571:	ff d0                	callq  *%rax
}
  803573:	c9                   	leaveq 
  803574:	c3                   	retq   

0000000000803575 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803575:	55                   	push   %rbp
  803576:	48 89 e5             	mov    %rsp,%rbp
  803579:	48 83 ec 30          	sub    $0x30,%rsp
  80357d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803580:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803584:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803588:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80358b:	48 89 d6             	mov    %rdx,%rsi
  80358e:	89 c7                	mov    %eax,%edi
  803590:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  803597:	00 00 00 
  80359a:	ff d0                	callq  *%rax
  80359c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80359f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035a3:	78 24                	js     8035c9 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8035a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a9:	8b 00                	mov    (%rax),%eax
  8035ab:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8035af:	48 89 d6             	mov    %rdx,%rsi
  8035b2:	89 c7                	mov    %eax,%edi
  8035b4:	48 b8 6d 2f 80 00 00 	movabs $0x802f6d,%rax
  8035bb:	00 00 00 
  8035be:	ff d0                	callq  *%rax
  8035c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035c7:	79 05                	jns    8035ce <fstat+0x59>
		return r;
  8035c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035cc:	eb 5e                	jmp    80362c <fstat+0xb7>
	if (!dev->dev_stat)
  8035ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8035d6:	48 85 c0             	test   %rax,%rax
  8035d9:	75 07                	jne    8035e2 <fstat+0x6d>
		return -E_NOT_SUPP;
  8035db:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8035e0:	eb 4a                	jmp    80362c <fstat+0xb7>
	stat->st_name[0] = 0;
  8035e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035e6:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8035e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035ed:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8035f4:	00 00 00 
	stat->st_isdir = 0;
  8035f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035fb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803602:	00 00 00 
	stat->st_dev = dev;
  803605:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803609:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80360d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803614:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803618:	48 8b 40 28          	mov    0x28(%rax),%rax
  80361c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803620:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803624:	48 89 ce             	mov    %rcx,%rsi
  803627:	48 89 d7             	mov    %rdx,%rdi
  80362a:	ff d0                	callq  *%rax
}
  80362c:	c9                   	leaveq 
  80362d:	c3                   	retq   

000000000080362e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80362e:	55                   	push   %rbp
  80362f:	48 89 e5             	mov    %rsp,%rbp
  803632:	48 83 ec 20          	sub    $0x20,%rsp
  803636:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80363a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80363e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803642:	be 00 00 00 00       	mov    $0x0,%esi
  803647:	48 89 c7             	mov    %rax,%rdi
  80364a:	48 b8 1c 37 80 00 00 	movabs $0x80371c,%rax
  803651:	00 00 00 
  803654:	ff d0                	callq  *%rax
  803656:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803659:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80365d:	79 05                	jns    803664 <stat+0x36>
		return fd;
  80365f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803662:	eb 2f                	jmp    803693 <stat+0x65>
	r = fstat(fd, stat);
  803664:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366b:	48 89 d6             	mov    %rdx,%rsi
  80366e:	89 c7                	mov    %eax,%edi
  803670:	48 b8 75 35 80 00 00 	movabs $0x803575,%rax
  803677:	00 00 00 
  80367a:	ff d0                	callq  *%rax
  80367c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80367f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803682:	89 c7                	mov    %eax,%edi
  803684:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  80368b:	00 00 00 
  80368e:	ff d0                	callq  *%rax
	return r;
  803690:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803693:	c9                   	leaveq 
  803694:	c3                   	retq   

0000000000803695 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803695:	55                   	push   %rbp
  803696:	48 89 e5             	mov    %rsp,%rbp
  803699:	48 83 ec 10          	sub    $0x10,%rsp
  80369d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8036a4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8036ab:	00 00 00 
  8036ae:	8b 00                	mov    (%rax),%eax
  8036b0:	85 c0                	test   %eax,%eax
  8036b2:	75 1d                	jne    8036d1 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8036b4:	bf 01 00 00 00       	mov    $0x1,%edi
  8036b9:	48 b8 5e 51 80 00 00 	movabs $0x80515e,%rax
  8036c0:	00 00 00 
  8036c3:	ff d0                	callq  *%rax
  8036c5:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8036cc:	00 00 00 
  8036cf:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8036d1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8036d8:	00 00 00 
  8036db:	8b 00                	mov    (%rax),%eax
  8036dd:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8036e0:	b9 07 00 00 00       	mov    $0x7,%ecx
  8036e5:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8036ec:	00 00 00 
  8036ef:	89 c7                	mov    %eax,%edi
  8036f1:	48 b8 5f 50 80 00 00 	movabs $0x80505f,%rax
  8036f8:	00 00 00 
  8036fb:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8036fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803701:	ba 00 00 00 00       	mov    $0x0,%edx
  803706:	48 89 c6             	mov    %rax,%rsi
  803709:	bf 00 00 00 00       	mov    $0x0,%edi
  80370e:	48 b8 ac 4f 80 00 00 	movabs $0x804fac,%rax
  803715:	00 00 00 
  803718:	ff d0                	callq  *%rax
}
  80371a:	c9                   	leaveq 
  80371b:	c3                   	retq   

000000000080371c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80371c:	55                   	push   %rbp
  80371d:	48 89 e5             	mov    %rsp,%rbp
  803720:	48 83 ec 20          	sub    $0x20,%rsp
  803724:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803728:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  80372b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80372f:	48 89 c7             	mov    %rax,%rdi
  803732:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  803739:	00 00 00 
  80373c:	ff d0                	callq  *%rax
  80373e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803743:	7e 0a                	jle    80374f <open+0x33>
		return -E_BAD_PATH;
  803745:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80374a:	e9 a5 00 00 00       	jmpq   8037f4 <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  80374f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803753:	48 89 c7             	mov    %rax,%rdi
  803756:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  80375d:	00 00 00 
  803760:	ff d0                	callq  *%rax
  803762:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803765:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803769:	79 08                	jns    803773 <open+0x57>
		return ret;
  80376b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80376e:	e9 81 00 00 00       	jmpq   8037f4 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  803773:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80377a:	00 00 00 
  80377d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803780:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  803786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80378a:	48 89 c6             	mov    %rax,%rsi
  80378d:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803794:	00 00 00 
  803797:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  80379e:	00 00 00 
  8037a1:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  8037a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a7:	48 89 c6             	mov    %rax,%rsi
  8037aa:	bf 01 00 00 00       	mov    $0x1,%edi
  8037af:	48 b8 95 36 80 00 00 	movabs $0x803695,%rax
  8037b6:	00 00 00 
  8037b9:	ff d0                	callq  *%rax
  8037bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c2:	79 1d                	jns    8037e1 <open+0xc5>
	{
		fd_close(fd,0);
  8037c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c8:	be 00 00 00 00       	mov    $0x0,%esi
  8037cd:	48 89 c7             	mov    %rax,%rdi
  8037d0:	48 b8 a4 2e 80 00 00 	movabs $0x802ea4,%rax
  8037d7:	00 00 00 
  8037da:	ff d0                	callq  *%rax
		return ret;
  8037dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037df:	eb 13                	jmp    8037f4 <open+0xd8>
	}
	return fd2num (fd);
  8037e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e5:	48 89 c7             	mov    %rax,%rdi
  8037e8:	48 b8 2e 2d 80 00 00 	movabs $0x802d2e,%rax
  8037ef:	00 00 00 
  8037f2:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  8037f4:	c9                   	leaveq 
  8037f5:	c3                   	retq   

00000000008037f6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8037f6:	55                   	push   %rbp
  8037f7:	48 89 e5             	mov    %rsp,%rbp
  8037fa:	48 83 ec 10          	sub    $0x10,%rsp
  8037fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803802:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803806:	8b 50 0c             	mov    0xc(%rax),%edx
  803809:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803810:	00 00 00 
  803813:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803815:	be 00 00 00 00       	mov    $0x0,%esi
  80381a:	bf 06 00 00 00       	mov    $0x6,%edi
  80381f:	48 b8 95 36 80 00 00 	movabs $0x803695,%rax
  803826:	00 00 00 
  803829:	ff d0                	callq  *%rax
}
  80382b:	c9                   	leaveq 
  80382c:	c3                   	retq   

000000000080382d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80382d:	55                   	push   %rbp
  80382e:	48 89 e5             	mov    %rsp,%rbp
  803831:	48 83 ec 30          	sub    $0x30,%rsp
  803835:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803839:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80383d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  803841:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803845:	8b 50 0c             	mov    0xc(%rax),%edx
  803848:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80384f:	00 00 00 
  803852:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  803854:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80385b:	00 00 00 
  80385e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803862:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  803866:	be 00 00 00 00       	mov    $0x0,%esi
  80386b:	bf 03 00 00 00       	mov    $0x3,%edi
  803870:	48 b8 95 36 80 00 00 	movabs $0x803695,%rax
  803877:	00 00 00 
  80387a:	ff d0                	callq  *%rax
  80387c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80387f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803883:	79 05                	jns    80388a <devfile_read+0x5d>
		return ret;
  803885:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803888:	eb 26                	jmp    8038b0 <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  80388a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80388d:	48 63 d0             	movslq %eax,%rdx
  803890:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803894:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80389b:	00 00 00 
  80389e:	48 89 c7             	mov    %rax,%rdi
  8038a1:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  8038a8:	00 00 00 
  8038ab:	ff d0                	callq  *%rax
	return ret;
  8038ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  8038b0:	c9                   	leaveq 
  8038b1:	c3                   	retq   

00000000008038b2 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8038b2:	55                   	push   %rbp
  8038b3:	48 89 e5             	mov    %rsp,%rbp
  8038b6:	48 83 ec 30          	sub    $0x30,%rsp
  8038ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  8038c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038ca:	8b 50 0c             	mov    0xc(%rax),%edx
  8038cd:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8038d4:	00 00 00 
  8038d7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  8038d9:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  8038de:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8038e5:	00 
  8038e6:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8038eb:	48 89 c2             	mov    %rax,%rdx
  8038ee:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8038f5:	00 00 00 
  8038f8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8038fc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803903:	00 00 00 
  803906:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80390a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80390e:	48 89 c6             	mov    %rax,%rsi
  803911:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803918:	00 00 00 
  80391b:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  803922:	00 00 00 
  803925:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  803927:	be 00 00 00 00       	mov    $0x0,%esi
  80392c:	bf 04 00 00 00       	mov    $0x4,%edi
  803931:	48 b8 95 36 80 00 00 	movabs $0x803695,%rax
  803938:	00 00 00 
  80393b:	ff d0                	callq  *%rax
  80393d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803940:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803944:	79 05                	jns    80394b <devfile_write+0x99>
		return ret;
  803946:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803949:	eb 03                	jmp    80394e <devfile_write+0x9c>
	
	return ret;
  80394b:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  80394e:	c9                   	leaveq 
  80394f:	c3                   	retq   

0000000000803950 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803950:	55                   	push   %rbp
  803951:	48 89 e5             	mov    %rsp,%rbp
  803954:	48 83 ec 20          	sub    $0x20,%rsp
  803958:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80395c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803960:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803964:	8b 50 0c             	mov    0xc(%rax),%edx
  803967:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80396e:	00 00 00 
  803971:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803973:	be 00 00 00 00       	mov    $0x0,%esi
  803978:	bf 05 00 00 00       	mov    $0x5,%edi
  80397d:	48 b8 95 36 80 00 00 	movabs $0x803695,%rax
  803984:	00 00 00 
  803987:	ff d0                	callq  *%rax
  803989:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80398c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803990:	79 05                	jns    803997 <devfile_stat+0x47>
		return r;
  803992:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803995:	eb 56                	jmp    8039ed <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803997:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80399b:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8039a2:	00 00 00 
  8039a5:	48 89 c7             	mov    %rax,%rdi
  8039a8:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  8039af:	00 00 00 
  8039b2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8039b4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8039bb:	00 00 00 
  8039be:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8039c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039c8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8039ce:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8039d5:	00 00 00 
  8039d8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8039de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039e2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8039e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039ed:	c9                   	leaveq 
  8039ee:	c3                   	retq   

00000000008039ef <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8039ef:	55                   	push   %rbp
  8039f0:	48 89 e5             	mov    %rsp,%rbp
  8039f3:	48 83 ec 10          	sub    $0x10,%rsp
  8039f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039fb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8039fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a02:	8b 50 0c             	mov    0xc(%rax),%edx
  803a05:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803a0c:	00 00 00 
  803a0f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803a11:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803a18:	00 00 00 
  803a1b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803a1e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803a21:	be 00 00 00 00       	mov    $0x0,%esi
  803a26:	bf 02 00 00 00       	mov    $0x2,%edi
  803a2b:	48 b8 95 36 80 00 00 	movabs $0x803695,%rax
  803a32:	00 00 00 
  803a35:	ff d0                	callq  *%rax
}
  803a37:	c9                   	leaveq 
  803a38:	c3                   	retq   

0000000000803a39 <remove>:

// Delete a file
int
remove(const char *path)
{
  803a39:	55                   	push   %rbp
  803a3a:	48 89 e5             	mov    %rsp,%rbp
  803a3d:	48 83 ec 10          	sub    $0x10,%rsp
  803a41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803a45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a49:	48 89 c7             	mov    %rax,%rdi
  803a4c:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  803a53:	00 00 00 
  803a56:	ff d0                	callq  *%rax
  803a58:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803a5d:	7e 07                	jle    803a66 <remove+0x2d>
		return -E_BAD_PATH;
  803a5f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803a64:	eb 33                	jmp    803a99 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803a66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a6a:	48 89 c6             	mov    %rax,%rsi
  803a6d:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803a74:	00 00 00 
  803a77:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  803a7e:	00 00 00 
  803a81:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803a83:	be 00 00 00 00       	mov    $0x0,%esi
  803a88:	bf 07 00 00 00       	mov    $0x7,%edi
  803a8d:	48 b8 95 36 80 00 00 	movabs $0x803695,%rax
  803a94:	00 00 00 
  803a97:	ff d0                	callq  *%rax
}
  803a99:	c9                   	leaveq 
  803a9a:	c3                   	retq   

0000000000803a9b <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803a9b:	55                   	push   %rbp
  803a9c:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803a9f:	be 00 00 00 00       	mov    $0x0,%esi
  803aa4:	bf 08 00 00 00       	mov    $0x8,%edi
  803aa9:	48 b8 95 36 80 00 00 	movabs $0x803695,%rax
  803ab0:	00 00 00 
  803ab3:	ff d0                	callq  *%rax
}
  803ab5:	5d                   	pop    %rbp
  803ab6:	c3                   	retq   

0000000000803ab7 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803ab7:	55                   	push   %rbp
  803ab8:	48 89 e5             	mov    %rsp,%rbp
  803abb:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803ac2:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803ac9:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803ad0:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803ad7:	be 00 00 00 00       	mov    $0x0,%esi
  803adc:	48 89 c7             	mov    %rax,%rdi
  803adf:	48 b8 1c 37 80 00 00 	movabs $0x80371c,%rax
  803ae6:	00 00 00 
  803ae9:	ff d0                	callq  *%rax
  803aeb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803aee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803af2:	79 28                	jns    803b1c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803af4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af7:	89 c6                	mov    %eax,%esi
  803af9:	48 bf 8e 5a 80 00 00 	movabs $0x805a8e,%rdi
  803b00:	00 00 00 
  803b03:	b8 00 00 00 00       	mov    $0x0,%eax
  803b08:	48 ba 30 0b 80 00 00 	movabs $0x800b30,%rdx
  803b0f:	00 00 00 
  803b12:	ff d2                	callq  *%rdx
		return fd_src;
  803b14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b17:	e9 74 01 00 00       	jmpq   803c90 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803b1c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803b23:	be 01 01 00 00       	mov    $0x101,%esi
  803b28:	48 89 c7             	mov    %rax,%rdi
  803b2b:	48 b8 1c 37 80 00 00 	movabs $0x80371c,%rax
  803b32:	00 00 00 
  803b35:	ff d0                	callq  *%rax
  803b37:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803b3a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b3e:	79 39                	jns    803b79 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803b40:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b43:	89 c6                	mov    %eax,%esi
  803b45:	48 bf a4 5a 80 00 00 	movabs $0x805aa4,%rdi
  803b4c:	00 00 00 
  803b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b54:	48 ba 30 0b 80 00 00 	movabs $0x800b30,%rdx
  803b5b:	00 00 00 
  803b5e:	ff d2                	callq  *%rdx
		close(fd_src);
  803b60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b63:	89 c7                	mov    %eax,%edi
  803b65:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  803b6c:	00 00 00 
  803b6f:	ff d0                	callq  *%rax
		return fd_dest;
  803b71:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b74:	e9 17 01 00 00       	jmpq   803c90 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803b79:	eb 74                	jmp    803bef <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803b7b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b7e:	48 63 d0             	movslq %eax,%rdx
  803b81:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803b88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b8b:	48 89 ce             	mov    %rcx,%rsi
  803b8e:	89 c7                	mov    %eax,%edi
  803b90:	48 b8 90 33 80 00 00 	movabs $0x803390,%rax
  803b97:	00 00 00 
  803b9a:	ff d0                	callq  *%rax
  803b9c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803b9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803ba3:	79 4a                	jns    803bef <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803ba5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803ba8:	89 c6                	mov    %eax,%esi
  803baa:	48 bf be 5a 80 00 00 	movabs $0x805abe,%rdi
  803bb1:	00 00 00 
  803bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb9:	48 ba 30 0b 80 00 00 	movabs $0x800b30,%rdx
  803bc0:	00 00 00 
  803bc3:	ff d2                	callq  *%rdx
			close(fd_src);
  803bc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bc8:	89 c7                	mov    %eax,%edi
  803bca:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  803bd1:	00 00 00 
  803bd4:	ff d0                	callq  *%rax
			close(fd_dest);
  803bd6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bd9:	89 c7                	mov    %eax,%edi
  803bdb:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  803be2:	00 00 00 
  803be5:	ff d0                	callq  *%rax
			return write_size;
  803be7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803bea:	e9 a1 00 00 00       	jmpq   803c90 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803bef:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf9:	ba 00 02 00 00       	mov    $0x200,%edx
  803bfe:	48 89 ce             	mov    %rcx,%rsi
  803c01:	89 c7                	mov    %eax,%edi
  803c03:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  803c0a:	00 00 00 
  803c0d:	ff d0                	callq  *%rax
  803c0f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803c12:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803c16:	0f 8f 5f ff ff ff    	jg     803b7b <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803c1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803c20:	79 47                	jns    803c69 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803c22:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803c25:	89 c6                	mov    %eax,%esi
  803c27:	48 bf d1 5a 80 00 00 	movabs $0x805ad1,%rdi
  803c2e:	00 00 00 
  803c31:	b8 00 00 00 00       	mov    $0x0,%eax
  803c36:	48 ba 30 0b 80 00 00 	movabs $0x800b30,%rdx
  803c3d:	00 00 00 
  803c40:	ff d2                	callq  *%rdx
		close(fd_src);
  803c42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c45:	89 c7                	mov    %eax,%edi
  803c47:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  803c4e:	00 00 00 
  803c51:	ff d0                	callq  *%rax
		close(fd_dest);
  803c53:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c56:	89 c7                	mov    %eax,%edi
  803c58:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  803c5f:	00 00 00 
  803c62:	ff d0                	callq  *%rax
		return read_size;
  803c64:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803c67:	eb 27                	jmp    803c90 <copy+0x1d9>
	}
	close(fd_src);
  803c69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6c:	89 c7                	mov    %eax,%edi
  803c6e:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  803c75:	00 00 00 
  803c78:	ff d0                	callq  *%rax
	close(fd_dest);
  803c7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c7d:	89 c7                	mov    %eax,%edi
  803c7f:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  803c86:	00 00 00 
  803c89:	ff d0                	callq  *%rax
	return 0;
  803c8b:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803c90:	c9                   	leaveq 
  803c91:	c3                   	retq   

0000000000803c92 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803c92:	55                   	push   %rbp
  803c93:	48 89 e5             	mov    %rsp,%rbp
  803c96:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  803c9d:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  803ca4:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803cab:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  803cb2:	be 00 00 00 00       	mov    $0x0,%esi
  803cb7:	48 89 c7             	mov    %rax,%rdi
  803cba:	48 b8 1c 37 80 00 00 	movabs $0x80371c,%rax
  803cc1:	00 00 00 
  803cc4:	ff d0                	callq  *%rax
  803cc6:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803cc9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803ccd:	79 08                	jns    803cd7 <spawn+0x45>
		return r;
  803ccf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803cd2:	e9 0c 03 00 00       	jmpq   803fe3 <spawn+0x351>
	fd = r;
  803cd7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803cda:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803cdd:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803ce4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803ce8:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803cef:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803cf2:	ba 00 02 00 00       	mov    $0x200,%edx
  803cf7:	48 89 ce             	mov    %rcx,%rsi
  803cfa:	89 c7                	mov    %eax,%edi
  803cfc:	48 b8 1b 33 80 00 00 	movabs $0x80331b,%rax
  803d03:	00 00 00 
  803d06:	ff d0                	callq  *%rax
  803d08:	3d 00 02 00 00       	cmp    $0x200,%eax
  803d0d:	75 0d                	jne    803d1c <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803d0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d13:	8b 00                	mov    (%rax),%eax
  803d15:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803d1a:	74 43                	je     803d5f <spawn+0xcd>
		close(fd);
  803d1c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803d1f:	89 c7                	mov    %eax,%edi
  803d21:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  803d28:	00 00 00 
  803d2b:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803d2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d31:	8b 00                	mov    (%rax),%eax
  803d33:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803d38:	89 c6                	mov    %eax,%esi
  803d3a:	48 bf e8 5a 80 00 00 	movabs $0x805ae8,%rdi
  803d41:	00 00 00 
  803d44:	b8 00 00 00 00       	mov    $0x0,%eax
  803d49:	48 b9 30 0b 80 00 00 	movabs $0x800b30,%rcx
  803d50:	00 00 00 
  803d53:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803d55:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803d5a:	e9 84 02 00 00       	jmpq   803fe3 <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803d5f:	b8 07 00 00 00       	mov    $0x7,%eax
  803d64:	cd 30                	int    $0x30
  803d66:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803d69:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803d6c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803d6f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803d73:	79 08                	jns    803d7d <spawn+0xeb>
		return r;
  803d75:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803d78:	e9 66 02 00 00       	jmpq   803fe3 <spawn+0x351>
	child = r;
  803d7d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803d80:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803d83:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803d86:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d8b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d92:	00 00 00 
  803d95:	48 98                	cltq   
  803d97:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  803d9e:	48 01 d0             	add    %rdx,%rax
  803da1:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803da8:	48 89 c6             	mov    %rax,%rsi
  803dab:	b8 18 00 00 00       	mov    $0x18,%eax
  803db0:	48 89 d7             	mov    %rdx,%rdi
  803db3:	48 89 c1             	mov    %rax,%rcx
  803db6:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803db9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dbd:	48 8b 40 18          	mov    0x18(%rax),%rax
  803dc1:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803dc8:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803dcf:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803dd6:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803ddd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803de0:	48 89 ce             	mov    %rcx,%rsi
  803de3:	89 c7                	mov    %eax,%edi
  803de5:	48 b8 4d 42 80 00 00 	movabs $0x80424d,%rax
  803dec:	00 00 00 
  803def:	ff d0                	callq  *%rax
  803df1:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803df4:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803df8:	79 08                	jns    803e02 <spawn+0x170>
		return r;
  803dfa:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803dfd:	e9 e1 01 00 00       	jmpq   803fe3 <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803e02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e06:	48 8b 40 20          	mov    0x20(%rax),%rax
  803e0a:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803e11:	48 01 d0             	add    %rdx,%rax
  803e14:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803e18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e1f:	e9 a3 00 00 00       	jmpq   803ec7 <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  803e24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e28:	8b 00                	mov    (%rax),%eax
  803e2a:	83 f8 01             	cmp    $0x1,%eax
  803e2d:	74 05                	je     803e34 <spawn+0x1a2>
			continue;
  803e2f:	e9 8a 00 00 00       	jmpq   803ebe <spawn+0x22c>
		perm = PTE_P | PTE_U;
  803e34:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803e3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e3f:	8b 40 04             	mov    0x4(%rax),%eax
  803e42:	83 e0 02             	and    $0x2,%eax
  803e45:	85 c0                	test   %eax,%eax
  803e47:	74 04                	je     803e4d <spawn+0x1bb>
			perm |= PTE_W;
  803e49:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803e4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e51:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803e55:	41 89 c1             	mov    %eax,%r9d
  803e58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5c:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803e60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e64:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803e68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e6c:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803e70:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803e73:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803e76:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803e79:	89 3c 24             	mov    %edi,(%rsp)
  803e7c:	89 c7                	mov    %eax,%edi
  803e7e:	48 b8 f6 44 80 00 00 	movabs $0x8044f6,%rax
  803e85:	00 00 00 
  803e88:	ff d0                	callq  *%rax
  803e8a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803e8d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803e91:	79 2b                	jns    803ebe <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803e93:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803e94:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803e97:	89 c7                	mov    %eax,%edi
  803e99:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  803ea0:	00 00 00 
  803ea3:	ff d0                	callq  *%rax
	close(fd);
  803ea5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803ea8:	89 c7                	mov    %eax,%edi
  803eaa:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  803eb1:	00 00 00 
  803eb4:	ff d0                	callq  *%rax
	return r;
  803eb6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803eb9:	e9 25 01 00 00       	jmpq   803fe3 <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803ebe:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ec2:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803ec7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ecb:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803ecf:	0f b7 c0             	movzwl %ax,%eax
  803ed2:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803ed5:	0f 8f 49 ff ff ff    	jg     803e24 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803edb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803ede:	89 c7                	mov    %eax,%edi
  803ee0:	48 b8 24 30 80 00 00 	movabs $0x803024,%rax
  803ee7:	00 00 00 
  803eea:	ff d0                	callq  *%rax
	fd = -1;
  803eec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803ef3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803ef6:	89 c7                	mov    %eax,%edi
  803ef8:	48 b8 e2 46 80 00 00 	movabs $0x8046e2,%rax
  803eff:	00 00 00 
  803f02:	ff d0                	callq  *%rax
  803f04:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803f07:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803f0b:	79 30                	jns    803f3d <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  803f0d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f10:	89 c1                	mov    %eax,%ecx
  803f12:	48 ba 02 5b 80 00 00 	movabs $0x805b02,%rdx
  803f19:	00 00 00 
  803f1c:	be 82 00 00 00       	mov    $0x82,%esi
  803f21:	48 bf 18 5b 80 00 00 	movabs $0x805b18,%rdi
  803f28:	00 00 00 
  803f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  803f30:	49 b8 f7 08 80 00 00 	movabs $0x8008f7,%r8
  803f37:	00 00 00 
  803f3a:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803f3d:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803f44:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803f47:	48 89 d6             	mov    %rdx,%rsi
  803f4a:	89 c7                	mov    %eax,%edi
  803f4c:	48 b8 95 21 80 00 00 	movabs $0x802195,%rax
  803f53:	00 00 00 
  803f56:	ff d0                	callq  *%rax
  803f58:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803f5b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803f5f:	79 30                	jns    803f91 <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  803f61:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f64:	89 c1                	mov    %eax,%ecx
  803f66:	48 ba 24 5b 80 00 00 	movabs $0x805b24,%rdx
  803f6d:	00 00 00 
  803f70:	be 85 00 00 00       	mov    $0x85,%esi
  803f75:	48 bf 18 5b 80 00 00 	movabs $0x805b18,%rdi
  803f7c:	00 00 00 
  803f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f84:	49 b8 f7 08 80 00 00 	movabs $0x8008f7,%r8
  803f8b:	00 00 00 
  803f8e:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803f91:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803f94:	be 02 00 00 00       	mov    $0x2,%esi
  803f99:	89 c7                	mov    %eax,%edi
  803f9b:	48 b8 4a 21 80 00 00 	movabs $0x80214a,%rax
  803fa2:	00 00 00 
  803fa5:	ff d0                	callq  *%rax
  803fa7:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803faa:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803fae:	79 30                	jns    803fe0 <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  803fb0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803fb3:	89 c1                	mov    %eax,%ecx
  803fb5:	48 ba 3e 5b 80 00 00 	movabs $0x805b3e,%rdx
  803fbc:	00 00 00 
  803fbf:	be 88 00 00 00       	mov    $0x88,%esi
  803fc4:	48 bf 18 5b 80 00 00 	movabs $0x805b18,%rdi
  803fcb:	00 00 00 
  803fce:	b8 00 00 00 00       	mov    $0x0,%eax
  803fd3:	49 b8 f7 08 80 00 00 	movabs $0x8008f7,%r8
  803fda:	00 00 00 
  803fdd:	41 ff d0             	callq  *%r8

	return child;
  803fe0:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803fe3:	c9                   	leaveq 
  803fe4:	c3                   	retq   

0000000000803fe5 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803fe5:	55                   	push   %rbp
  803fe6:	48 89 e5             	mov    %rsp,%rbp
  803fe9:	41 55                	push   %r13
  803feb:	41 54                	push   %r12
  803fed:	53                   	push   %rbx
  803fee:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803ff5:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803ffc:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  804003:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  80400a:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  804011:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  804018:	84 c0                	test   %al,%al
  80401a:	74 26                	je     804042 <spawnl+0x5d>
  80401c:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  804023:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  80402a:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  80402e:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  804032:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  804036:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  80403a:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  80403e:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  804042:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  804049:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  804050:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  804053:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80405a:	00 00 00 
  80405d:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804064:	00 00 00 
  804067:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80406b:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804072:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804079:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  804080:	eb 07                	jmp    804089 <spawnl+0xa4>
		argc++;
  804082:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  804089:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80408f:	83 f8 30             	cmp    $0x30,%eax
  804092:	73 23                	jae    8040b7 <spawnl+0xd2>
  804094:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80409b:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8040a1:	89 c0                	mov    %eax,%eax
  8040a3:	48 01 d0             	add    %rdx,%rax
  8040a6:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8040ac:	83 c2 08             	add    $0x8,%edx
  8040af:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8040b5:	eb 15                	jmp    8040cc <spawnl+0xe7>
  8040b7:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8040be:	48 89 d0             	mov    %rdx,%rax
  8040c1:	48 83 c2 08          	add    $0x8,%rdx
  8040c5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8040cc:	48 8b 00             	mov    (%rax),%rax
  8040cf:	48 85 c0             	test   %rax,%rax
  8040d2:	75 ae                	jne    804082 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8040d4:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8040da:	83 c0 02             	add    $0x2,%eax
  8040dd:	48 89 e2             	mov    %rsp,%rdx
  8040e0:	48 89 d3             	mov    %rdx,%rbx
  8040e3:	48 63 d0             	movslq %eax,%rdx
  8040e6:	48 83 ea 01          	sub    $0x1,%rdx
  8040ea:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8040f1:	48 63 d0             	movslq %eax,%rdx
  8040f4:	49 89 d4             	mov    %rdx,%r12
  8040f7:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8040fd:	48 63 d0             	movslq %eax,%rdx
  804100:	49 89 d2             	mov    %rdx,%r10
  804103:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  804109:	48 98                	cltq   
  80410b:	48 c1 e0 03          	shl    $0x3,%rax
  80410f:	48 8d 50 07          	lea    0x7(%rax),%rdx
  804113:	b8 10 00 00 00       	mov    $0x10,%eax
  804118:	48 83 e8 01          	sub    $0x1,%rax
  80411c:	48 01 d0             	add    %rdx,%rax
  80411f:	bf 10 00 00 00       	mov    $0x10,%edi
  804124:	ba 00 00 00 00       	mov    $0x0,%edx
  804129:	48 f7 f7             	div    %rdi
  80412c:	48 6b c0 10          	imul   $0x10,%rax,%rax
  804130:	48 29 c4             	sub    %rax,%rsp
  804133:	48 89 e0             	mov    %rsp,%rax
  804136:	48 83 c0 07          	add    $0x7,%rax
  80413a:	48 c1 e8 03          	shr    $0x3,%rax
  80413e:	48 c1 e0 03          	shl    $0x3,%rax
  804142:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  804149:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804150:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  804157:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  80415a:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804160:	8d 50 01             	lea    0x1(%rax),%edx
  804163:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80416a:	48 63 d2             	movslq %edx,%rdx
  80416d:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  804174:	00 

	va_start(vl, arg0);
  804175:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80417c:	00 00 00 
  80417f:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804186:	00 00 00 
  804189:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80418d:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804194:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80419b:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8041a2:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8041a9:	00 00 00 
  8041ac:	eb 63                	jmp    804211 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  8041ae:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8041b4:	8d 70 01             	lea    0x1(%rax),%esi
  8041b7:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8041bd:	83 f8 30             	cmp    $0x30,%eax
  8041c0:	73 23                	jae    8041e5 <spawnl+0x200>
  8041c2:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  8041c9:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8041cf:	89 c0                	mov    %eax,%eax
  8041d1:	48 01 d0             	add    %rdx,%rax
  8041d4:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8041da:	83 c2 08             	add    $0x8,%edx
  8041dd:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8041e3:	eb 15                	jmp    8041fa <spawnl+0x215>
  8041e5:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8041ec:	48 89 d0             	mov    %rdx,%rax
  8041ef:	48 83 c2 08          	add    $0x8,%rdx
  8041f3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8041fa:	48 8b 08             	mov    (%rax),%rcx
  8041fd:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804204:	89 f2                	mov    %esi,%edx
  804206:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80420a:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  804211:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804217:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  80421d:	77 8f                	ja     8041ae <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80421f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804226:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  80422d:	48 89 d6             	mov    %rdx,%rsi
  804230:	48 89 c7             	mov    %rax,%rdi
  804233:	48 b8 92 3c 80 00 00 	movabs $0x803c92,%rax
  80423a:	00 00 00 
  80423d:	ff d0                	callq  *%rax
  80423f:	48 89 dc             	mov    %rbx,%rsp
}
  804242:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  804246:	5b                   	pop    %rbx
  804247:	41 5c                	pop    %r12
  804249:	41 5d                	pop    %r13
  80424b:	5d                   	pop    %rbp
  80424c:	c3                   	retq   

000000000080424d <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  80424d:	55                   	push   %rbp
  80424e:	48 89 e5             	mov    %rsp,%rbp
  804251:	48 83 ec 50          	sub    $0x50,%rsp
  804255:	89 7d cc             	mov    %edi,-0x34(%rbp)
  804258:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80425c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  804260:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804267:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  804268:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80426f:	eb 33                	jmp    8042a4 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  804271:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804274:	48 98                	cltq   
  804276:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80427d:	00 
  80427e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804282:	48 01 d0             	add    %rdx,%rax
  804285:	48 8b 00             	mov    (%rax),%rax
  804288:	48 89 c7             	mov    %rax,%rdi
  80428b:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  804292:	00 00 00 
  804295:	ff d0                	callq  *%rax
  804297:	83 c0 01             	add    $0x1,%eax
  80429a:	48 98                	cltq   
  80429c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8042a0:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8042a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042a7:	48 98                	cltq   
  8042a9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8042b0:	00 
  8042b1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8042b5:	48 01 d0             	add    %rdx,%rax
  8042b8:	48 8b 00             	mov    (%rax),%rax
  8042bb:	48 85 c0             	test   %rax,%rax
  8042be:	75 b1                	jne    804271 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8042c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042c4:	48 f7 d8             	neg    %rax
  8042c7:	48 05 00 10 40 00    	add    $0x401000,%rax
  8042cd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8042d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042d5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8042d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042dd:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8042e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8042e4:	83 c2 01             	add    $0x1,%edx
  8042e7:	c1 e2 03             	shl    $0x3,%edx
  8042ea:	48 63 d2             	movslq %edx,%rdx
  8042ed:	48 f7 da             	neg    %rdx
  8042f0:	48 01 d0             	add    %rdx,%rax
  8042f3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8042f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042fb:	48 83 e8 10          	sub    $0x10,%rax
  8042ff:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  804305:	77 0a                	ja     804311 <init_stack+0xc4>
		return -E_NO_MEM;
  804307:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80430c:	e9 e3 01 00 00       	jmpq   8044f4 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  804311:	ba 07 00 00 00       	mov    $0x7,%edx
  804316:	be 00 00 40 00       	mov    $0x400000,%esi
  80431b:	bf 00 00 00 00       	mov    $0x0,%edi
  804320:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  804327:	00 00 00 
  80432a:	ff d0                	callq  *%rax
  80432c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80432f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804333:	79 08                	jns    80433d <init_stack+0xf0>
		return r;
  804335:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804338:	e9 b7 01 00 00       	jmpq   8044f4 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80433d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  804344:	e9 8a 00 00 00       	jmpq   8043d3 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  804349:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80434c:	48 98                	cltq   
  80434e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804355:	00 
  804356:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80435a:	48 01 c2             	add    %rax,%rdx
  80435d:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804362:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804366:	48 01 c8             	add    %rcx,%rax
  804369:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80436f:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  804372:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804375:	48 98                	cltq   
  804377:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80437e:	00 
  80437f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804383:	48 01 d0             	add    %rdx,%rax
  804386:	48 8b 10             	mov    (%rax),%rdx
  804389:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80438d:	48 89 d6             	mov    %rdx,%rsi
  804390:	48 89 c7             	mov    %rax,%rdi
  804393:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  80439a:	00 00 00 
  80439d:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80439f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8043a2:	48 98                	cltq   
  8043a4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8043ab:	00 
  8043ac:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8043b0:	48 01 d0             	add    %rdx,%rax
  8043b3:	48 8b 00             	mov    (%rax),%rax
  8043b6:	48 89 c7             	mov    %rax,%rdi
  8043b9:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  8043c0:	00 00 00 
  8043c3:	ff d0                	callq  *%rax
  8043c5:	48 98                	cltq   
  8043c7:	48 83 c0 01          	add    $0x1,%rax
  8043cb:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8043cf:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8043d3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8043d6:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8043d9:	0f 8c 6a ff ff ff    	jl     804349 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8043df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043e2:	48 98                	cltq   
  8043e4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8043eb:	00 
  8043ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043f0:	48 01 d0             	add    %rdx,%rax
  8043f3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8043fa:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  804401:	00 
  804402:	74 35                	je     804439 <init_stack+0x1ec>
  804404:	48 b9 58 5b 80 00 00 	movabs $0x805b58,%rcx
  80440b:	00 00 00 
  80440e:	48 ba 7e 5b 80 00 00 	movabs $0x805b7e,%rdx
  804415:	00 00 00 
  804418:	be f1 00 00 00       	mov    $0xf1,%esi
  80441d:	48 bf 18 5b 80 00 00 	movabs $0x805b18,%rdi
  804424:	00 00 00 
  804427:	b8 00 00 00 00       	mov    $0x0,%eax
  80442c:	49 b8 f7 08 80 00 00 	movabs $0x8008f7,%r8
  804433:	00 00 00 
  804436:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  804439:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80443d:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  804441:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804446:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80444a:	48 01 c8             	add    %rcx,%rax
  80444d:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804453:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  804456:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80445a:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80445e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804461:	48 98                	cltq   
  804463:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  804466:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  80446b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80446f:	48 01 d0             	add    %rdx,%rax
  804472:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804478:	48 89 c2             	mov    %rax,%rdx
  80447b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80447f:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  804482:	8b 45 cc             	mov    -0x34(%rbp),%eax
  804485:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80448b:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804490:	89 c2                	mov    %eax,%edx
  804492:	be 00 00 40 00       	mov    $0x400000,%esi
  804497:	bf 00 00 00 00       	mov    $0x0,%edi
  80449c:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  8044a3:	00 00 00 
  8044a6:	ff d0                	callq  *%rax
  8044a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8044ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044af:	79 02                	jns    8044b3 <init_stack+0x266>
		goto error;
  8044b1:	eb 28                	jmp    8044db <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8044b3:	be 00 00 40 00       	mov    $0x400000,%esi
  8044b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8044bd:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  8044c4:	00 00 00 
  8044c7:	ff d0                	callq  *%rax
  8044c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8044cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044d0:	79 02                	jns    8044d4 <init_stack+0x287>
		goto error;
  8044d2:	eb 07                	jmp    8044db <init_stack+0x28e>

	return 0;
  8044d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8044d9:	eb 19                	jmp    8044f4 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8044db:	be 00 00 40 00       	mov    $0x400000,%esi
  8044e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8044e5:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  8044ec:	00 00 00 
  8044ef:	ff d0                	callq  *%rax
	return r;
  8044f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8044f4:	c9                   	leaveq 
  8044f5:	c3                   	retq   

00000000008044f6 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8044f6:	55                   	push   %rbp
  8044f7:	48 89 e5             	mov    %rsp,%rbp
  8044fa:	48 83 ec 50          	sub    $0x50,%rsp
  8044fe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804501:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804505:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  804509:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  80450c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804510:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  804514:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804518:	25 ff 0f 00 00       	and    $0xfff,%eax
  80451d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804520:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804524:	74 21                	je     804547 <map_segment+0x51>
		va -= i;
  804526:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804529:	48 98                	cltq   
  80452b:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80452f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804532:	48 98                	cltq   
  804534:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  804538:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80453b:	48 98                	cltq   
  80453d:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  804541:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804544:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  804547:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80454e:	e9 79 01 00 00       	jmpq   8046cc <map_segment+0x1d6>
		if (i >= filesz) {
  804553:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804556:	48 98                	cltq   
  804558:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80455c:	72 3c                	jb     80459a <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80455e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804561:	48 63 d0             	movslq %eax,%rdx
  804564:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804568:	48 01 d0             	add    %rdx,%rax
  80456b:	48 89 c1             	mov    %rax,%rcx
  80456e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804571:	8b 55 10             	mov    0x10(%rbp),%edx
  804574:	48 89 ce             	mov    %rcx,%rsi
  804577:	89 c7                	mov    %eax,%edi
  804579:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  804580:	00 00 00 
  804583:	ff d0                	callq  *%rax
  804585:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804588:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80458c:	0f 89 33 01 00 00    	jns    8046c5 <map_segment+0x1cf>
				return r;
  804592:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804595:	e9 46 01 00 00       	jmpq   8046e0 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80459a:	ba 07 00 00 00       	mov    $0x7,%edx
  80459f:	be 00 00 40 00       	mov    $0x400000,%esi
  8045a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8045a9:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  8045b0:	00 00 00 
  8045b3:	ff d0                	callq  *%rax
  8045b5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8045b8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8045bc:	79 08                	jns    8045c6 <map_segment+0xd0>
				return r;
  8045be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045c1:	e9 1a 01 00 00       	jmpq   8046e0 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8045c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045c9:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8045cc:	01 c2                	add    %eax,%edx
  8045ce:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8045d1:	89 d6                	mov    %edx,%esi
  8045d3:	89 c7                	mov    %eax,%edi
  8045d5:	48 b8 64 34 80 00 00 	movabs $0x803464,%rax
  8045dc:	00 00 00 
  8045df:	ff d0                	callq  *%rax
  8045e1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8045e4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8045e8:	79 08                	jns    8045f2 <map_segment+0xfc>
				return r;
  8045ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045ed:	e9 ee 00 00 00       	jmpq   8046e0 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8045f2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8045f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045fc:	48 98                	cltq   
  8045fe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804602:	48 29 c2             	sub    %rax,%rdx
  804605:	48 89 d0             	mov    %rdx,%rax
  804608:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80460c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80460f:	48 63 d0             	movslq %eax,%rdx
  804612:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804616:	48 39 c2             	cmp    %rax,%rdx
  804619:	48 0f 47 d0          	cmova  %rax,%rdx
  80461d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804620:	be 00 00 40 00       	mov    $0x400000,%esi
  804625:	89 c7                	mov    %eax,%edi
  804627:	48 b8 1b 33 80 00 00 	movabs $0x80331b,%rax
  80462e:	00 00 00 
  804631:	ff d0                	callq  *%rax
  804633:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804636:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80463a:	79 08                	jns    804644 <map_segment+0x14e>
				return r;
  80463c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80463f:	e9 9c 00 00 00       	jmpq   8046e0 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  804644:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804647:	48 63 d0             	movslq %eax,%rdx
  80464a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80464e:	48 01 d0             	add    %rdx,%rax
  804651:	48 89 c2             	mov    %rax,%rdx
  804654:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804657:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  80465b:	48 89 d1             	mov    %rdx,%rcx
  80465e:	89 c2                	mov    %eax,%edx
  804660:	be 00 00 40 00       	mov    $0x400000,%esi
  804665:	bf 00 00 00 00       	mov    $0x0,%edi
  80466a:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  804671:	00 00 00 
  804674:	ff d0                	callq  *%rax
  804676:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804679:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80467d:	79 30                	jns    8046af <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  80467f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804682:	89 c1                	mov    %eax,%ecx
  804684:	48 ba 93 5b 80 00 00 	movabs $0x805b93,%rdx
  80468b:	00 00 00 
  80468e:	be 24 01 00 00       	mov    $0x124,%esi
  804693:	48 bf 18 5b 80 00 00 	movabs $0x805b18,%rdi
  80469a:	00 00 00 
  80469d:	b8 00 00 00 00       	mov    $0x0,%eax
  8046a2:	49 b8 f7 08 80 00 00 	movabs $0x8008f7,%r8
  8046a9:	00 00 00 
  8046ac:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8046af:	be 00 00 40 00       	mov    $0x400000,%esi
  8046b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8046b9:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  8046c0:	00 00 00 
  8046c3:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8046c5:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8046cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046cf:	48 98                	cltq   
  8046d1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8046d5:	0f 82 78 fe ff ff    	jb     804553 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8046db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046e0:	c9                   	leaveq 
  8046e1:	c3                   	retq   

00000000008046e2 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8046e2:	55                   	push   %rbp
  8046e3:	48 89 e5             	mov    %rsp,%rbp
  8046e6:	48 83 ec 20          	sub    $0x20,%rsp
  8046ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
	// LAB 5: Your code here.
	uint64_t  i;
	for (i=UTEXT;i<USTACKTOP;i+=PGSIZE)
  8046ed:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  8046f4:	00 
  8046f5:	e9 23 01 00 00       	jmpq   80481d <copy_shared_pages+0x13b>
	{
		if ((uvpml4e[VPML4E(i)]) && (uvpde[VPDPE(i)]) && (uvpd[VPD(i)]) && (uvpt[VPN(i)]))
  8046fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046fe:	48 c1 e8 27          	shr    $0x27,%rax
  804702:	48 89 c2             	mov    %rax,%rdx
  804705:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80470c:	01 00 00 
  80470f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804713:	48 85 c0             	test   %rax,%rax
  804716:	0f 84 f9 00 00 00    	je     804815 <copy_shared_pages+0x133>
  80471c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804720:	48 c1 e8 1e          	shr    $0x1e,%rax
  804724:	48 89 c2             	mov    %rax,%rdx
  804727:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80472e:	01 00 00 
  804731:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804735:	48 85 c0             	test   %rax,%rax
  804738:	0f 84 d7 00 00 00    	je     804815 <copy_shared_pages+0x133>
  80473e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804742:	48 c1 e8 15          	shr    $0x15,%rax
  804746:	48 89 c2             	mov    %rax,%rdx
  804749:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804750:	01 00 00 
  804753:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804757:	48 85 c0             	test   %rax,%rax
  80475a:	0f 84 b5 00 00 00    	je     804815 <copy_shared_pages+0x133>
  804760:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804764:	48 c1 e8 0c          	shr    $0xc,%rax
  804768:	48 89 c2             	mov    %rax,%rdx
  80476b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804772:	01 00 00 
  804775:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804779:	48 85 c0             	test   %rax,%rax
  80477c:	0f 84 93 00 00 00    	je     804815 <copy_shared_pages+0x133>
		{
			if (uvpt[VPN(i)]&PTE_SHARE)
  804782:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804786:	48 c1 e8 0c          	shr    $0xc,%rax
  80478a:	48 89 c2             	mov    %rax,%rdx
  80478d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804794:	01 00 00 
  804797:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80479b:	25 00 04 00 00       	and    $0x400,%eax
  8047a0:	48 85 c0             	test   %rax,%rax
  8047a3:	74 70                	je     804815 <copy_shared_pages+0x133>
				if (sys_page_map(0, (void *)i, child, (void *)i, uvpt[VPN(i)] & PTE_SYSCALL)<0)
  8047a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8047ad:	48 89 c2             	mov    %rax,%rdx
  8047b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8047b7:	01 00 00 
  8047ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8047be:	25 07 0e 00 00       	and    $0xe07,%eax
  8047c3:	89 c6                	mov    %eax,%esi
  8047c5:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8047c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047cd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8047d0:	41 89 f0             	mov    %esi,%r8d
  8047d3:	48 89 c6             	mov    %rax,%rsi
  8047d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8047db:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  8047e2:	00 00 00 
  8047e5:	ff d0                	callq  *%rax
  8047e7:	85 c0                	test   %eax,%eax
  8047e9:	79 2a                	jns    804815 <copy_shared_pages+0x133>
					panic("copy_shared_pages: sys_page_map\n");
  8047eb:	48 ba b0 5b 80 00 00 	movabs $0x805bb0,%rdx
  8047f2:	00 00 00 
  8047f5:	be 37 01 00 00       	mov    $0x137,%esi
  8047fa:	48 bf 18 5b 80 00 00 	movabs $0x805b18,%rdi
  804801:	00 00 00 
  804804:	b8 00 00 00 00       	mov    $0x0,%eax
  804809:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  804810:	00 00 00 
  804813:	ff d1                	callq  *%rcx
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint64_t  i;
	for (i=UTEXT;i<USTACKTOP;i+=PGSIZE)
  804815:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  80481c:	00 
  80481d:	b8 ff df 7f ef       	mov    $0xef7fdfff,%eax
  804822:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  804826:	0f 86 ce fe ff ff    	jbe    8046fa <copy_shared_pages+0x18>
			if (uvpt[VPN(i)]&PTE_SHARE)
				if (sys_page_map(0, (void *)i, child, (void *)i, uvpt[VPN(i)] & PTE_SYSCALL)<0)
					panic("copy_shared_pages: sys_page_map\n");
		}
	}
	return 0;
  80482c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804831:	c9                   	leaveq 
  804832:	c3                   	retq   

0000000000804833 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804833:	55                   	push   %rbp
  804834:	48 89 e5             	mov    %rsp,%rbp
  804837:	53                   	push   %rbx
  804838:	48 83 ec 38          	sub    $0x38,%rsp
  80483c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804840:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804844:	48 89 c7             	mov    %rax,%rdi
  804847:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  80484e:	00 00 00 
  804851:	ff d0                	callq  *%rax
  804853:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804856:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80485a:	0f 88 bf 01 00 00    	js     804a1f <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804860:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804864:	ba 07 04 00 00       	mov    $0x407,%edx
  804869:	48 89 c6             	mov    %rax,%rsi
  80486c:	bf 00 00 00 00       	mov    $0x0,%edi
  804871:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  804878:	00 00 00 
  80487b:	ff d0                	callq  *%rax
  80487d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804880:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804884:	0f 88 95 01 00 00    	js     804a1f <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80488a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80488e:	48 89 c7             	mov    %rax,%rdi
  804891:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  804898:	00 00 00 
  80489b:	ff d0                	callq  *%rax
  80489d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8048a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8048a4:	0f 88 5d 01 00 00    	js     804a07 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8048aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048ae:	ba 07 04 00 00       	mov    $0x407,%edx
  8048b3:	48 89 c6             	mov    %rax,%rsi
  8048b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8048bb:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  8048c2:	00 00 00 
  8048c5:	ff d0                	callq  *%rax
  8048c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8048ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8048ce:	0f 88 33 01 00 00    	js     804a07 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8048d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048d8:	48 89 c7             	mov    %rax,%rdi
  8048db:	48 b8 51 2d 80 00 00 	movabs $0x802d51,%rax
  8048e2:	00 00 00 
  8048e5:	ff d0                	callq  *%rax
  8048e7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8048eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048ef:	ba 07 04 00 00       	mov    $0x407,%edx
  8048f4:	48 89 c6             	mov    %rax,%rsi
  8048f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8048fc:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  804903:	00 00 00 
  804906:	ff d0                	callq  *%rax
  804908:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80490b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80490f:	79 05                	jns    804916 <pipe+0xe3>
		goto err2;
  804911:	e9 d9 00 00 00       	jmpq   8049ef <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804916:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80491a:	48 89 c7             	mov    %rax,%rdi
  80491d:	48 b8 51 2d 80 00 00 	movabs $0x802d51,%rax
  804924:	00 00 00 
  804927:	ff d0                	callq  *%rax
  804929:	48 89 c2             	mov    %rax,%rdx
  80492c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804930:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804936:	48 89 d1             	mov    %rdx,%rcx
  804939:	ba 00 00 00 00       	mov    $0x0,%edx
  80493e:	48 89 c6             	mov    %rax,%rsi
  804941:	bf 00 00 00 00       	mov    $0x0,%edi
  804946:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  80494d:	00 00 00 
  804950:	ff d0                	callq  *%rax
  804952:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804955:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804959:	79 1b                	jns    804976 <pipe+0x143>
		goto err3;
  80495b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80495c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804960:	48 89 c6             	mov    %rax,%rsi
  804963:	bf 00 00 00 00       	mov    $0x0,%edi
  804968:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  80496f:	00 00 00 
  804972:	ff d0                	callq  *%rax
  804974:	eb 79                	jmp    8049ef <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804976:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80497a:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  804981:	00 00 00 
  804984:	8b 12                	mov    (%rdx),%edx
  804986:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804988:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80498c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804993:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804997:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  80499e:	00 00 00 
  8049a1:	8b 12                	mov    (%rdx),%edx
  8049a3:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8049a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049a9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8049b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049b4:	48 89 c7             	mov    %rax,%rdi
  8049b7:	48 b8 2e 2d 80 00 00 	movabs $0x802d2e,%rax
  8049be:	00 00 00 
  8049c1:	ff d0                	callq  *%rax
  8049c3:	89 c2                	mov    %eax,%edx
  8049c5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8049c9:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8049cb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8049cf:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8049d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049d7:	48 89 c7             	mov    %rax,%rdi
  8049da:	48 b8 2e 2d 80 00 00 	movabs $0x802d2e,%rax
  8049e1:	00 00 00 
  8049e4:	ff d0                	callq  *%rax
  8049e6:	89 03                	mov    %eax,(%rbx)
	return 0;
  8049e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8049ed:	eb 33                	jmp    804a22 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8049ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049f3:	48 89 c6             	mov    %rax,%rsi
  8049f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8049fb:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  804a02:	00 00 00 
  804a05:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804a07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a0b:	48 89 c6             	mov    %rax,%rsi
  804a0e:	bf 00 00 00 00       	mov    $0x0,%edi
  804a13:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  804a1a:	00 00 00 
  804a1d:	ff d0                	callq  *%rax
err:
	return r;
  804a1f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804a22:	48 83 c4 38          	add    $0x38,%rsp
  804a26:	5b                   	pop    %rbx
  804a27:	5d                   	pop    %rbp
  804a28:	c3                   	retq   

0000000000804a29 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804a29:	55                   	push   %rbp
  804a2a:	48 89 e5             	mov    %rsp,%rbp
  804a2d:	53                   	push   %rbx
  804a2e:	48 83 ec 28          	sub    $0x28,%rsp
  804a32:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804a36:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804a3a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a41:	00 00 00 
  804a44:	48 8b 00             	mov    (%rax),%rax
  804a47:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804a4d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804a50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a54:	48 89 c7             	mov    %rax,%rdi
  804a57:	48 b8 d0 51 80 00 00 	movabs $0x8051d0,%rax
  804a5e:	00 00 00 
  804a61:	ff d0                	callq  *%rax
  804a63:	89 c3                	mov    %eax,%ebx
  804a65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a69:	48 89 c7             	mov    %rax,%rdi
  804a6c:	48 b8 d0 51 80 00 00 	movabs $0x8051d0,%rax
  804a73:	00 00 00 
  804a76:	ff d0                	callq  *%rax
  804a78:	39 c3                	cmp    %eax,%ebx
  804a7a:	0f 94 c0             	sete   %al
  804a7d:	0f b6 c0             	movzbl %al,%eax
  804a80:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804a83:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a8a:	00 00 00 
  804a8d:	48 8b 00             	mov    (%rax),%rax
  804a90:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804a96:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804a99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a9c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804a9f:	75 05                	jne    804aa6 <_pipeisclosed+0x7d>
			return ret;
  804aa1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804aa4:	eb 4f                	jmp    804af5 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804aa6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804aa9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804aac:	74 42                	je     804af0 <_pipeisclosed+0xc7>
  804aae:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804ab2:	75 3c                	jne    804af0 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804ab4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804abb:	00 00 00 
  804abe:	48 8b 00             	mov    (%rax),%rax
  804ac1:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804ac7:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804aca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804acd:	89 c6                	mov    %eax,%esi
  804acf:	48 bf db 5b 80 00 00 	movabs $0x805bdb,%rdi
  804ad6:	00 00 00 
  804ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  804ade:	49 b8 30 0b 80 00 00 	movabs $0x800b30,%r8
  804ae5:	00 00 00 
  804ae8:	41 ff d0             	callq  *%r8
	}
  804aeb:	e9 4a ff ff ff       	jmpq   804a3a <_pipeisclosed+0x11>
  804af0:	e9 45 ff ff ff       	jmpq   804a3a <_pipeisclosed+0x11>
}
  804af5:	48 83 c4 28          	add    $0x28,%rsp
  804af9:	5b                   	pop    %rbx
  804afa:	5d                   	pop    %rbp
  804afb:	c3                   	retq   

0000000000804afc <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804afc:	55                   	push   %rbp
  804afd:	48 89 e5             	mov    %rsp,%rbp
  804b00:	48 83 ec 30          	sub    $0x30,%rsp
  804b04:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804b07:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804b0b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804b0e:	48 89 d6             	mov    %rdx,%rsi
  804b11:	89 c7                	mov    %eax,%edi
  804b13:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  804b1a:	00 00 00 
  804b1d:	ff d0                	callq  *%rax
  804b1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b26:	79 05                	jns    804b2d <pipeisclosed+0x31>
		return r;
  804b28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b2b:	eb 31                	jmp    804b5e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804b2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b31:	48 89 c7             	mov    %rax,%rdi
  804b34:	48 b8 51 2d 80 00 00 	movabs $0x802d51,%rax
  804b3b:	00 00 00 
  804b3e:	ff d0                	callq  *%rax
  804b40:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804b44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b48:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b4c:	48 89 d6             	mov    %rdx,%rsi
  804b4f:	48 89 c7             	mov    %rax,%rdi
  804b52:	48 b8 29 4a 80 00 00 	movabs $0x804a29,%rax
  804b59:	00 00 00 
  804b5c:	ff d0                	callq  *%rax
}
  804b5e:	c9                   	leaveq 
  804b5f:	c3                   	retq   

0000000000804b60 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804b60:	55                   	push   %rbp
  804b61:	48 89 e5             	mov    %rsp,%rbp
  804b64:	48 83 ec 40          	sub    $0x40,%rsp
  804b68:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804b6c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804b70:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804b74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b78:	48 89 c7             	mov    %rax,%rdi
  804b7b:	48 b8 51 2d 80 00 00 	movabs $0x802d51,%rax
  804b82:	00 00 00 
  804b85:	ff d0                	callq  *%rax
  804b87:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804b8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804b8f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804b93:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804b9a:	00 
  804b9b:	e9 92 00 00 00       	jmpq   804c32 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804ba0:	eb 41                	jmp    804be3 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804ba2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804ba7:	74 09                	je     804bb2 <devpipe_read+0x52>
				return i;
  804ba9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bad:	e9 92 00 00 00       	jmpq   804c44 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804bb2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804bb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804bba:	48 89 d6             	mov    %rdx,%rsi
  804bbd:	48 89 c7             	mov    %rax,%rdi
  804bc0:	48 b8 29 4a 80 00 00 	movabs $0x804a29,%rax
  804bc7:	00 00 00 
  804bca:	ff d0                	callq  *%rax
  804bcc:	85 c0                	test   %eax,%eax
  804bce:	74 07                	je     804bd7 <devpipe_read+0x77>
				return 0;
  804bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  804bd5:	eb 6d                	jmp    804c44 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804bd7:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  804bde:	00 00 00 
  804be1:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804be3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804be7:	8b 10                	mov    (%rax),%edx
  804be9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bed:	8b 40 04             	mov    0x4(%rax),%eax
  804bf0:	39 c2                	cmp    %eax,%edx
  804bf2:	74 ae                	je     804ba2 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804bf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bf8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804bfc:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804c00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c04:	8b 00                	mov    (%rax),%eax
  804c06:	99                   	cltd   
  804c07:	c1 ea 1b             	shr    $0x1b,%edx
  804c0a:	01 d0                	add    %edx,%eax
  804c0c:	83 e0 1f             	and    $0x1f,%eax
  804c0f:	29 d0                	sub    %edx,%eax
  804c11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c15:	48 98                	cltq   
  804c17:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804c1c:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804c1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c22:	8b 00                	mov    (%rax),%eax
  804c24:	8d 50 01             	lea    0x1(%rax),%edx
  804c27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c2b:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804c2d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804c32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c36:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804c3a:	0f 82 60 ff ff ff    	jb     804ba0 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804c40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804c44:	c9                   	leaveq 
  804c45:	c3                   	retq   

0000000000804c46 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804c46:	55                   	push   %rbp
  804c47:	48 89 e5             	mov    %rsp,%rbp
  804c4a:	48 83 ec 40          	sub    $0x40,%rsp
  804c4e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804c52:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804c56:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804c5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c5e:	48 89 c7             	mov    %rax,%rdi
  804c61:	48 b8 51 2d 80 00 00 	movabs $0x802d51,%rax
  804c68:	00 00 00 
  804c6b:	ff d0                	callq  *%rax
  804c6d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804c71:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804c75:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804c79:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804c80:	00 
  804c81:	e9 8e 00 00 00       	jmpq   804d14 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804c86:	eb 31                	jmp    804cb9 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804c88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c90:	48 89 d6             	mov    %rdx,%rsi
  804c93:	48 89 c7             	mov    %rax,%rdi
  804c96:	48 b8 29 4a 80 00 00 	movabs $0x804a29,%rax
  804c9d:	00 00 00 
  804ca0:	ff d0                	callq  *%rax
  804ca2:	85 c0                	test   %eax,%eax
  804ca4:	74 07                	je     804cad <devpipe_write+0x67>
				return 0;
  804ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  804cab:	eb 79                	jmp    804d26 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804cad:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  804cb4:	00 00 00 
  804cb7:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804cb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cbd:	8b 40 04             	mov    0x4(%rax),%eax
  804cc0:	48 63 d0             	movslq %eax,%rdx
  804cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cc7:	8b 00                	mov    (%rax),%eax
  804cc9:	48 98                	cltq   
  804ccb:	48 83 c0 20          	add    $0x20,%rax
  804ccf:	48 39 c2             	cmp    %rax,%rdx
  804cd2:	73 b4                	jae    804c88 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804cd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cd8:	8b 40 04             	mov    0x4(%rax),%eax
  804cdb:	99                   	cltd   
  804cdc:	c1 ea 1b             	shr    $0x1b,%edx
  804cdf:	01 d0                	add    %edx,%eax
  804ce1:	83 e0 1f             	and    $0x1f,%eax
  804ce4:	29 d0                	sub    %edx,%eax
  804ce6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804cea:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804cee:	48 01 ca             	add    %rcx,%rdx
  804cf1:	0f b6 0a             	movzbl (%rdx),%ecx
  804cf4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804cf8:	48 98                	cltq   
  804cfa:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804cfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d02:	8b 40 04             	mov    0x4(%rax),%eax
  804d05:	8d 50 01             	lea    0x1(%rax),%edx
  804d08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d0c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804d0f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804d14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d18:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804d1c:	0f 82 64 ff ff ff    	jb     804c86 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804d22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804d26:	c9                   	leaveq 
  804d27:	c3                   	retq   

0000000000804d28 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804d28:	55                   	push   %rbp
  804d29:	48 89 e5             	mov    %rsp,%rbp
  804d2c:	48 83 ec 20          	sub    $0x20,%rsp
  804d30:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804d34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804d38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d3c:	48 89 c7             	mov    %rax,%rdi
  804d3f:	48 b8 51 2d 80 00 00 	movabs $0x802d51,%rax
  804d46:	00 00 00 
  804d49:	ff d0                	callq  *%rax
  804d4b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804d4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d53:	48 be ee 5b 80 00 00 	movabs $0x805bee,%rsi
  804d5a:	00 00 00 
  804d5d:	48 89 c7             	mov    %rax,%rdi
  804d60:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  804d67:	00 00 00 
  804d6a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804d6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d70:	8b 50 04             	mov    0x4(%rax),%edx
  804d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d77:	8b 00                	mov    (%rax),%eax
  804d79:	29 c2                	sub    %eax,%edx
  804d7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d7f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804d85:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d89:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804d90:	00 00 00 
	stat->st_dev = &devpipe;
  804d93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d97:	48 b9 00 71 80 00 00 	movabs $0x807100,%rcx
  804d9e:	00 00 00 
  804da1:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804da8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804dad:	c9                   	leaveq 
  804dae:	c3                   	retq   

0000000000804daf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804daf:	55                   	push   %rbp
  804db0:	48 89 e5             	mov    %rsp,%rbp
  804db3:	48 83 ec 10          	sub    $0x10,%rsp
  804db7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804dbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804dbf:	48 89 c6             	mov    %rax,%rsi
  804dc2:	bf 00 00 00 00       	mov    $0x0,%edi
  804dc7:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  804dce:	00 00 00 
  804dd1:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804dd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804dd7:	48 89 c7             	mov    %rax,%rdi
  804dda:	48 b8 51 2d 80 00 00 	movabs $0x802d51,%rax
  804de1:	00 00 00 
  804de4:	ff d0                	callq  *%rax
  804de6:	48 89 c6             	mov    %rax,%rsi
  804de9:	bf 00 00 00 00       	mov    $0x0,%edi
  804dee:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  804df5:	00 00 00 
  804df8:	ff d0                	callq  *%rax
}
  804dfa:	c9                   	leaveq 
  804dfb:	c3                   	retq   

0000000000804dfc <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804dfc:	55                   	push   %rbp
  804dfd:	48 89 e5             	mov    %rsp,%rbp
  804e00:	48 83 ec 20          	sub    $0x20,%rsp
  804e04:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804e07:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e0b:	75 35                	jne    804e42 <wait+0x46>
  804e0d:	48 b9 f5 5b 80 00 00 	movabs $0x805bf5,%rcx
  804e14:	00 00 00 
  804e17:	48 ba 00 5c 80 00 00 	movabs $0x805c00,%rdx
  804e1e:	00 00 00 
  804e21:	be 09 00 00 00       	mov    $0x9,%esi
  804e26:	48 bf 15 5c 80 00 00 	movabs $0x805c15,%rdi
  804e2d:	00 00 00 
  804e30:	b8 00 00 00 00       	mov    $0x0,%eax
  804e35:	49 b8 f7 08 80 00 00 	movabs $0x8008f7,%r8
  804e3c:	00 00 00 
  804e3f:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804e42:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e45:	25 ff 03 00 00       	and    $0x3ff,%eax
  804e4a:	48 98                	cltq   
  804e4c:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  804e53:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804e5a:	00 00 00 
  804e5d:	48 01 d0             	add    %rdx,%rax
  804e60:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804e64:	eb 0c                	jmp    804e72 <wait+0x76>
		sys_yield();
  804e66:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  804e6d:	00 00 00 
  804e70:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804e72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e76:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804e7c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804e7f:	75 0e                	jne    804e8f <wait+0x93>
  804e81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e85:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804e8b:	85 c0                	test   %eax,%eax
  804e8d:	75 d7                	jne    804e66 <wait+0x6a>
		sys_yield();
}
  804e8f:	c9                   	leaveq 
  804e90:	c3                   	retq   

0000000000804e91 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804e91:	55                   	push   %rbp
  804e92:	48 89 e5             	mov    %rsp,%rbp
  804e95:	48 83 ec 20          	sub    $0x20,%rsp
  804e99:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804e9d:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  804ea4:	00 00 00 
  804ea7:	48 8b 00             	mov    (%rax),%rax
  804eaa:	48 85 c0             	test   %rax,%rax
  804ead:	75 6f                	jne    804f1e <set_pgfault_handler+0x8d>
		// First time through!
		// LAB 4: Your code here.

		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  804eaf:	ba 07 00 00 00       	mov    $0x7,%edx
  804eb4:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804eb9:	bf 00 00 00 00       	mov    $0x0,%edi
  804ebe:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  804ec5:	00 00 00 
  804ec8:	ff d0                	callq  *%rax
  804eca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ecd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ed1:	79 30                	jns    804f03 <set_pgfault_handler+0x72>
            panic("set_pgfault_handler: %d\n", r);
  804ed3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ed6:	89 c1                	mov    %eax,%ecx
  804ed8:	48 ba 20 5c 80 00 00 	movabs $0x805c20,%rdx
  804edf:	00 00 00 
  804ee2:	be 22 00 00 00       	mov    $0x22,%esi
  804ee7:	48 bf 39 5c 80 00 00 	movabs $0x805c39,%rdi
  804eee:	00 00 00 
  804ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  804ef6:	49 b8 f7 08 80 00 00 	movabs $0x8008f7,%r8
  804efd:	00 00 00 
  804f00:	41 ff d0             	callq  *%r8
        sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804f03:	48 be 31 4f 80 00 00 	movabs $0x804f31,%rsi
  804f0a:	00 00 00 
  804f0d:	bf 00 00 00 00       	mov    $0x0,%edi
  804f12:	48 b8 df 21 80 00 00 	movabs $0x8021df,%rax
  804f19:	00 00 00 
  804f1c:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804f1e:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  804f25:	00 00 00 
  804f28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804f2c:	48 89 10             	mov    %rdx,(%rax)
}
  804f2f:	c9                   	leaveq 
  804f30:	c3                   	retq   

0000000000804f31 <_pgfault_upcall>:
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF


	movq %rsp, %rdi;	
  804f31:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  804f34:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804f3b:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  804f3c:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  804f43:	00 
	pushq %rbx;
  804f44:	53                   	push   %rbx
	movq %rsp, %rbx;	
  804f45:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  804f48:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  804f4b:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  804f52:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  804f53:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  804f57:	4c 8b 3c 24          	mov    (%rsp),%r15
  804f5b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804f60:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804f65:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804f6a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804f6f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804f74:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804f79:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804f7e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804f83:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804f88:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804f8d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804f92:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804f97:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804f9c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804fa1:	48 83 c4 78          	add    $0x78,%rsp
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.


	add $8, %rsp; //Jump rip field  
  804fa5:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804fa9:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  804faa:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  804fab:	c3                   	retq   

0000000000804fac <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804fac:	55                   	push   %rbp
  804fad:	48 89 e5             	mov    %rsp,%rbp
  804fb0:	48 83 ec 30          	sub    $0x30,%rsp
  804fb4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804fb8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804fbc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  804fc0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804fc5:	75 08                	jne    804fcf <ipc_recv+0x23>
  804fc7:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  804fce:	ff 
	int res=sys_ipc_recv(pg);
  804fcf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804fd3:	48 89 c7             	mov    %rax,%rdi
  804fd6:	48 b8 c9 22 80 00 00 	movabs $0x8022c9,%rax
  804fdd:	00 00 00 
  804fe0:	ff d0                	callq  *%rax
  804fe2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  804fe5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804fea:	74 26                	je     805012 <ipc_recv+0x66>
  804fec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ff0:	75 15                	jne    805007 <ipc_recv+0x5b>
  804ff2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804ff9:	00 00 00 
  804ffc:	48 8b 00             	mov    (%rax),%rax
  804fff:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  805005:	eb 05                	jmp    80500c <ipc_recv+0x60>
  805007:	b8 00 00 00 00       	mov    $0x0,%eax
  80500c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805010:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  805012:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805017:	74 26                	je     80503f <ipc_recv+0x93>
  805019:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80501d:	75 15                	jne    805034 <ipc_recv+0x88>
  80501f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  805026:	00 00 00 
  805029:	48 8b 00             	mov    (%rax),%rax
  80502c:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  805032:	eb 05                	jmp    805039 <ipc_recv+0x8d>
  805034:	b8 00 00 00 00       	mov    $0x0,%eax
  805039:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80503d:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  80503f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805043:	75 15                	jne    80505a <ipc_recv+0xae>
  805045:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80504c:	00 00 00 
  80504f:	48 8b 00             	mov    (%rax),%rax
  805052:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  805058:	eb 03                	jmp    80505d <ipc_recv+0xb1>
  80505a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  80505d:	c9                   	leaveq 
  80505e:	c3                   	retq   

000000000080505f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80505f:	55                   	push   %rbp
  805060:	48 89 e5             	mov    %rsp,%rbp
  805063:	48 83 ec 30          	sub    $0x30,%rsp
  805067:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80506a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80506d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  805071:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  805074:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805079:	75 0a                	jne    805085 <ipc_send+0x26>
  80507b:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  805082:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  805083:	eb 3e                	jmp    8050c3 <ipc_send+0x64>
  805085:	eb 3c                	jmp    8050c3 <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  805087:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80508b:	74 2a                	je     8050b7 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  80508d:	48 ba 48 5c 80 00 00 	movabs $0x805c48,%rdx
  805094:	00 00 00 
  805097:	be 39 00 00 00       	mov    $0x39,%esi
  80509c:	48 bf 73 5c 80 00 00 	movabs $0x805c73,%rdi
  8050a3:	00 00 00 
  8050a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8050ab:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  8050b2:	00 00 00 
  8050b5:	ff d1                	callq  *%rcx
		sys_yield();  
  8050b7:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  8050be:	00 00 00 
  8050c1:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8050c3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8050c6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8050c9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8050cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8050d0:	89 c7                	mov    %eax,%edi
  8050d2:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  8050d9:	00 00 00 
  8050dc:	ff d0                	callq  *%rax
  8050de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8050e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8050e5:	78 a0                	js     805087 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  8050e7:	c9                   	leaveq 
  8050e8:	c3                   	retq   

00000000008050e9 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8050e9:	55                   	push   %rbp
  8050ea:	48 89 e5             	mov    %rsp,%rbp
  8050ed:	48 83 ec 10          	sub    $0x10,%rsp
  8050f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  8050f5:	48 ba 80 5c 80 00 00 	movabs $0x805c80,%rdx
  8050fc:	00 00 00 
  8050ff:	be 47 00 00 00       	mov    $0x47,%esi
  805104:	48 bf 73 5c 80 00 00 	movabs $0x805c73,%rdi
  80510b:	00 00 00 
  80510e:	b8 00 00 00 00       	mov    $0x0,%eax
  805113:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  80511a:	00 00 00 
  80511d:	ff d1                	callq  *%rcx

000000000080511f <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80511f:	55                   	push   %rbp
  805120:	48 89 e5             	mov    %rsp,%rbp
  805123:	48 83 ec 20          	sub    $0x20,%rsp
  805127:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80512a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80512d:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  805131:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  805134:	48 ba a8 5c 80 00 00 	movabs $0x805ca8,%rdx
  80513b:	00 00 00 
  80513e:	be 50 00 00 00       	mov    $0x50,%esi
  805143:	48 bf 73 5c 80 00 00 	movabs $0x805c73,%rdi
  80514a:	00 00 00 
  80514d:	b8 00 00 00 00       	mov    $0x0,%eax
  805152:	48 b9 f7 08 80 00 00 	movabs $0x8008f7,%rcx
  805159:	00 00 00 
  80515c:	ff d1                	callq  *%rcx

000000000080515e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80515e:	55                   	push   %rbp
  80515f:	48 89 e5             	mov    %rsp,%rbp
  805162:	48 83 ec 14          	sub    $0x14,%rsp
  805166:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  805169:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805170:	eb 4e                	jmp    8051c0 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  805172:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805179:	00 00 00 
  80517c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80517f:	48 98                	cltq   
  805181:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  805188:	48 01 d0             	add    %rdx,%rax
  80518b:	48 05 d0 00 00 00    	add    $0xd0,%rax
  805191:	8b 00                	mov    (%rax),%eax
  805193:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805196:	75 24                	jne    8051bc <ipc_find_env+0x5e>
			return envs[i].env_id;
  805198:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80519f:	00 00 00 
  8051a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051a5:	48 98                	cltq   
  8051a7:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8051ae:	48 01 d0             	add    %rdx,%rax
  8051b1:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8051b7:	8b 40 08             	mov    0x8(%rax),%eax
  8051ba:	eb 12                	jmp    8051ce <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8051bc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8051c0:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8051c7:	7e a9                	jle    805172 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  8051c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8051ce:	c9                   	leaveq 
  8051cf:	c3                   	retq   

00000000008051d0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8051d0:	55                   	push   %rbp
  8051d1:	48 89 e5             	mov    %rsp,%rbp
  8051d4:	48 83 ec 18          	sub    $0x18,%rsp
  8051d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8051dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8051e0:	48 c1 e8 15          	shr    $0x15,%rax
  8051e4:	48 89 c2             	mov    %rax,%rdx
  8051e7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8051ee:	01 00 00 
  8051f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8051f5:	83 e0 01             	and    $0x1,%eax
  8051f8:	48 85 c0             	test   %rax,%rax
  8051fb:	75 07                	jne    805204 <pageref+0x34>
		return 0;
  8051fd:	b8 00 00 00 00       	mov    $0x0,%eax
  805202:	eb 53                	jmp    805257 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805208:	48 c1 e8 0c          	shr    $0xc,%rax
  80520c:	48 89 c2             	mov    %rax,%rdx
  80520f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805216:	01 00 00 
  805219:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80521d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805221:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805225:	83 e0 01             	and    $0x1,%eax
  805228:	48 85 c0             	test   %rax,%rax
  80522b:	75 07                	jne    805234 <pageref+0x64>
		return 0;
  80522d:	b8 00 00 00 00       	mov    $0x0,%eax
  805232:	eb 23                	jmp    805257 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805234:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805238:	48 c1 e8 0c          	shr    $0xc,%rax
  80523c:	48 89 c2             	mov    %rax,%rdx
  80523f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805246:	00 00 00 
  805249:	48 c1 e2 04          	shl    $0x4,%rdx
  80524d:	48 01 d0             	add    %rdx,%rax
  805250:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805254:	0f b7 c0             	movzwl %ax,%eax
}
  805257:	c9                   	leaveq 
  805258:	c3                   	retq   
