
vmm/guest/obj/user/writemotd:     file format elf64-x86-64


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
  80003c:	e8 36 03 00 00       	callq  800377 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80004e:	89 bd ec fd ff ff    	mov    %edi,-0x214(%rbp)
  800054:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int rfd, wfd;
	char buf[512];
	int n, r;

	if ((rfd = open("/newmotd", O_RDONLY)) < 0)
  80005b:	be 00 00 00 00       	mov    $0x0,%esi
  800060:	48 bf c0 39 80 00 00 	movabs $0x8039c0,%rdi
  800067:	00 00 00 
  80006a:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	79 30                	jns    8000af <umain+0x6c>
		panic("open /newmotd: %e", rfd);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba c9 39 80 00 00 	movabs $0x8039c9,%rdx
  80008b:	00 00 00 
  80008e:	be 0b 00 00 00       	mov    $0xb,%esi
  800093:	48 bf db 39 80 00 00 	movabs $0x8039db,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 1d 04 80 00 00 	movabs $0x80041d,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if ((wfd = open("/motd", O_RDWR)) < 0)
  8000af:	be 02 00 00 00       	mov    $0x2,%esi
  8000b4:	48 bf ec 39 80 00 00 	movabs $0x8039ec,%rdi
  8000bb:	00 00 00 
  8000be:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d1:	79 30                	jns    800103 <umain+0xc0>
		panic("open /motd: %e", wfd);
  8000d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	48 ba f2 39 80 00 00 	movabs $0x8039f2,%rdx
  8000df:	00 00 00 
  8000e2:	be 0d 00 00 00       	mov    $0xd,%esi
  8000e7:	48 bf db 39 80 00 00 	movabs $0x8039db,%rdi
  8000ee:	00 00 00 
  8000f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f6:	49 b8 1d 04 80 00 00 	movabs $0x80041d,%r8
  8000fd:	00 00 00 
  800100:	41 ff d0             	callq  *%r8
	cprintf("file descriptors %d %d\n", rfd, wfd);
  800103:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800109:	89 c6                	mov    %eax,%esi
  80010b:	48 bf 01 3a 80 00 00 	movabs $0x803a01,%rdi
  800112:	00 00 00 
  800115:	b8 00 00 00 00       	mov    $0x0,%eax
  80011a:	48 b9 56 06 80 00 00 	movabs $0x800656,%rcx
  800121:	00 00 00 
  800124:	ff d1                	callq  *%rcx
	if (rfd == wfd)
  800126:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800129:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  80012c:	75 2a                	jne    800158 <umain+0x115>
		panic("open /newmotd and /motd give same file descriptor");
  80012e:	48 ba 20 3a 80 00 00 	movabs $0x803a20,%rdx
  800135:	00 00 00 
  800138:	be 10 00 00 00       	mov    $0x10,%esi
  80013d:	48 bf db 39 80 00 00 	movabs $0x8039db,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	48 b9 1d 04 80 00 00 	movabs $0x80041d,%rcx
  800153:	00 00 00 
  800156:	ff d1                	callq  *%rcx

	cprintf("OLD MOTD\n===\n");
  800158:	48 bf 52 3a 80 00 00 	movabs $0x803a52,%rdi
  80015f:	00 00 00 
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
  800167:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  80016e:	00 00 00 
  800171:	ff d2                	callq  *%rdx
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800173:	eb 1f                	jmp    800194 <umain+0x151>
		sys_cputs(buf, n);
  800175:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800178:	48 63 d0             	movslq %eax,%rdx
  80017b:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800182:	48 89 d6             	mov    %rdx,%rsi
  800185:	48 89 c7             	mov    %rax,%rdi
  800188:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
	cprintf("file descriptors %d %d\n", rfd, wfd);
	if (rfd == wfd)
		panic("open /newmotd and /motd give same file descriptor");

	cprintf("OLD MOTD\n===\n");
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800194:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80019b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019e:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8001a3:	48 89 ce             	mov    %rcx,%rsi
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax
  8001b4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8001bb:	7f b8                	jg     800175 <umain+0x132>
		sys_cputs(buf, n);
	cprintf("===\n");
  8001bd:	48 bf 60 3a 80 00 00 	movabs $0x803a60,%rdi
  8001c4:	00 00 00 
  8001c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cc:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  8001d3:	00 00 00 
  8001d6:	ff d2                	callq  *%rdx
	seek(wfd, 0);
  8001d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001db:	be 00 00 00 00       	mov    $0x0,%esi
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	48 b8 4c 26 80 00 00 	movabs $0x80264c,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax

	if ((r = ftruncate(wfd, 0)) < 0)
  8001ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f1:	be 00 00 00 00       	mov    $0x0,%esi
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	48 b8 91 26 80 00 00 	movabs $0x802691,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
  800204:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800207:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("truncate /motd: %e", r);
  80020d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba 65 3a 80 00 00 	movabs $0x803a65,%rdx
  800219:	00 00 00 
  80021c:	be 19 00 00 00       	mov    $0x19,%esi
  800221:	48 bf db 39 80 00 00 	movabs $0x8039db,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 1d 04 80 00 00 	movabs $0x80041d,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8

	cprintf("NEW MOTD\n===\n");
  80023d:	48 bf 78 3a 80 00 00 	movabs $0x803a78,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  800258:	eb 7b                	jmp    8002d5 <umain+0x292>
		sys_cputs(buf, n);
  80025a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80025d:	48 63 d0             	movslq %eax,%rdx
  800260:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800267:	48 89 d6             	mov    %rdx,%rsi
  80026a:	48 89 c7             	mov    %rax,%rdi
  80026d:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  800274:	00 00 00 
  800277:	ff d0                	callq  *%rax
		if ((r = write(wfd, buf, n)) != n)
  800279:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80027c:	48 63 d0             	movslq %eax,%rdx
  80027f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  800286:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800289:	48 89 ce             	mov    %rcx,%rsi
  80028c:	89 c7                	mov    %eax,%edi
  80028e:	48 b8 78 25 80 00 00 	movabs $0x802578,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002a3:	74 30                	je     8002d5 <umain+0x292>
			panic("write /motd: %e", r);
  8002a5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a8:	89 c1                	mov    %eax,%ecx
  8002aa:	48 ba 86 3a 80 00 00 	movabs $0x803a86,%rdx
  8002b1:	00 00 00 
  8002b4:	be 1f 00 00 00       	mov    $0x1f,%esi
  8002b9:	48 bf db 39 80 00 00 	movabs $0x8039db,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	49 b8 1d 04 80 00 00 	movabs $0x80041d,%r8
  8002cf:	00 00 00 
  8002d2:	41 ff d0             	callq  *%r8

	if ((r = ftruncate(wfd, 0)) < 0)
		panic("truncate /motd: %e", r);

	cprintf("NEW MOTD\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  8002d5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8002dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002df:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8002e4:	48 89 ce             	mov    %rcx,%rsi
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002fc:	0f 8f 58 ff ff ff    	jg     80025a <umain+0x217>
		sys_cputs(buf, n);
		if ((r = write(wfd, buf, n)) != n)
			panic("write /motd: %e", r);
	}
	cprintf("===\n");
  800302:	48 bf 60 3a 80 00 00 	movabs $0x803a60,%rdi
  800309:	00 00 00 
  80030c:	b8 00 00 00 00       	mov    $0x0,%eax
  800311:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  800318:	00 00 00 
  80031b:	ff d2                	callq  *%rdx

	if (n < 0)
  80031d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800321:	79 30                	jns    800353 <umain+0x310>
		panic("read /newmotd: %e", n);
  800323:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800326:	89 c1                	mov    %eax,%ecx
  800328:	48 ba 96 3a 80 00 00 	movabs $0x803a96,%rdx
  80032f:	00 00 00 
  800332:	be 24 00 00 00       	mov    $0x24,%esi
  800337:	48 bf db 39 80 00 00 	movabs $0x8039db,%rdi
  80033e:	00 00 00 
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	49 b8 1d 04 80 00 00 	movabs $0x80041d,%r8
  80034d:	00 00 00 
  800350:	41 ff d0             	callq  *%r8

	close(rfd);
  800353:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800356:	89 c7                	mov    %eax,%edi
  800358:	48 b8 0c 22 80 00 00 	movabs $0x80220c,%rax
  80035f:	00 00 00 
  800362:	ff d0                	callq  *%rax
	close(wfd);
  800364:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800367:	89 c7                	mov    %eax,%edi
  800369:	48 b8 0c 22 80 00 00 	movabs $0x80220c,%rax
  800370:	00 00 00 
  800373:	ff d0                	callq  *%rax
}
  800375:	c9                   	leaveq 
  800376:	c3                   	retq   

0000000000800377 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800377:	55                   	push   %rbp
  800378:	48 89 e5             	mov    %rsp,%rbp
  80037b:	48 83 ec 10          	sub    $0x10,%rsp
  80037f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800382:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  800386:	48 b8 ff 1a 80 00 00 	movabs $0x801aff,%rax
  80038d:	00 00 00 
  800390:	ff d0                	callq  *%rax
  800392:	48 98                	cltq   
  800394:	25 ff 03 00 00       	and    $0x3ff,%eax
  800399:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8003a0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8003a7:	00 00 00 
  8003aa:	48 01 c2             	add    %rax,%rdx
  8003ad:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003b4:	00 00 00 
  8003b7:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003be:	7e 14                	jle    8003d4 <libmain+0x5d>
		binaryname = argv[0];
  8003c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c4:	48 8b 10             	mov    (%rax),%rdx
  8003c7:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8003ce:	00 00 00 
  8003d1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003db:	48 89 d6             	mov    %rdx,%rsi
  8003de:	89 c7                	mov    %eax,%edi
  8003e0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003e7:	00 00 00 
  8003ea:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003ec:	48 b8 fa 03 80 00 00 	movabs $0x8003fa,%rax
  8003f3:	00 00 00 
  8003f6:	ff d0                	callq  *%rax
}
  8003f8:	c9                   	leaveq 
  8003f9:	c3                   	retq   

00000000008003fa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003fa:	55                   	push   %rbp
  8003fb:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8003fe:	48 b8 57 22 80 00 00 	movabs $0x802257,%rax
  800405:	00 00 00 
  800408:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80040a:	bf 00 00 00 00       	mov    $0x0,%edi
  80040f:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
}
  80041b:	5d                   	pop    %rbp
  80041c:	c3                   	retq   

000000000080041d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80041d:	55                   	push   %rbp
  80041e:	48 89 e5             	mov    %rsp,%rbp
  800421:	53                   	push   %rbx
  800422:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800429:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800430:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800436:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80043d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800444:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80044b:	84 c0                	test   %al,%al
  80044d:	74 23                	je     800472 <_panic+0x55>
  80044f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800456:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80045a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80045e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800462:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800466:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80046a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80046e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800472:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800479:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800480:	00 00 00 
  800483:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80048a:	00 00 00 
  80048d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800491:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800498:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80049f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004a6:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8004ad:	00 00 00 
  8004b0:	48 8b 18             	mov    (%rax),%rbx
  8004b3:	48 b8 ff 1a 80 00 00 	movabs $0x801aff,%rax
  8004ba:	00 00 00 
  8004bd:	ff d0                	callq  *%rax
  8004bf:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004c5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004cc:	41 89 c8             	mov    %ecx,%r8d
  8004cf:	48 89 d1             	mov    %rdx,%rcx
  8004d2:	48 89 da             	mov    %rbx,%rdx
  8004d5:	89 c6                	mov    %eax,%esi
  8004d7:	48 bf b8 3a 80 00 00 	movabs $0x803ab8,%rdi
  8004de:	00 00 00 
  8004e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e6:	49 b9 56 06 80 00 00 	movabs $0x800656,%r9
  8004ed:	00 00 00 
  8004f0:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004f3:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004fa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800501:	48 89 d6             	mov    %rdx,%rsi
  800504:	48 89 c7             	mov    %rax,%rdi
  800507:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  80050e:	00 00 00 
  800511:	ff d0                	callq  *%rax
	cprintf("\n");
  800513:	48 bf db 3a 80 00 00 	movabs $0x803adb,%rdi
  80051a:	00 00 00 
  80051d:	b8 00 00 00 00       	mov    $0x0,%eax
  800522:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  800529:	00 00 00 
  80052c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80052e:	cc                   	int3   
  80052f:	eb fd                	jmp    80052e <_panic+0x111>

0000000000800531 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800531:	55                   	push   %rbp
  800532:	48 89 e5             	mov    %rsp,%rbp
  800535:	48 83 ec 10          	sub    $0x10,%rsp
  800539:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80053c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800540:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800544:	8b 00                	mov    (%rax),%eax
  800546:	8d 48 01             	lea    0x1(%rax),%ecx
  800549:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80054d:	89 0a                	mov    %ecx,(%rdx)
  80054f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800552:	89 d1                	mov    %edx,%ecx
  800554:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800558:	48 98                	cltq   
  80055a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80055e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800562:	8b 00                	mov    (%rax),%eax
  800564:	3d ff 00 00 00       	cmp    $0xff,%eax
  800569:	75 2c                	jne    800597 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80056b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80056f:	8b 00                	mov    (%rax),%eax
  800571:	48 98                	cltq   
  800573:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800577:	48 83 c2 08          	add    $0x8,%rdx
  80057b:	48 89 c6             	mov    %rax,%rsi
  80057e:	48 89 d7             	mov    %rdx,%rdi
  800581:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  800588:	00 00 00 
  80058b:	ff d0                	callq  *%rax
        b->idx = 0;
  80058d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800591:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80059b:	8b 40 04             	mov    0x4(%rax),%eax
  80059e:	8d 50 01             	lea    0x1(%rax),%edx
  8005a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a5:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005a8:	c9                   	leaveq 
  8005a9:	c3                   	retq   

00000000008005aa <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005aa:	55                   	push   %rbp
  8005ab:	48 89 e5             	mov    %rsp,%rbp
  8005ae:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005b5:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005bc:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005c3:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005ca:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005d1:	48 8b 0a             	mov    (%rdx),%rcx
  8005d4:	48 89 08             	mov    %rcx,(%rax)
  8005d7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005db:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005df:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005e3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005ee:	00 00 00 
    b.cnt = 0;
  8005f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005f8:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005fb:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800602:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800609:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800610:	48 89 c6             	mov    %rax,%rsi
  800613:	48 bf 31 05 80 00 00 	movabs $0x800531,%rdi
  80061a:	00 00 00 
  80061d:	48 b8 09 0a 80 00 00 	movabs $0x800a09,%rax
  800624:	00 00 00 
  800627:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800629:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80062f:	48 98                	cltq   
  800631:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800638:	48 83 c2 08          	add    $0x8,%rdx
  80063c:	48 89 c6             	mov    %rax,%rsi
  80063f:	48 89 d7             	mov    %rdx,%rdi
  800642:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  800649:	00 00 00 
  80064c:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80064e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800654:	c9                   	leaveq 
  800655:	c3                   	retq   

0000000000800656 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800656:	55                   	push   %rbp
  800657:	48 89 e5             	mov    %rsp,%rbp
  80065a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800661:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800668:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80066f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800676:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80067d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800684:	84 c0                	test   %al,%al
  800686:	74 20                	je     8006a8 <cprintf+0x52>
  800688:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80068c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800690:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800694:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800698:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80069c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006a0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006a4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006a8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006af:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006b6:	00 00 00 
  8006b9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006c0:	00 00 00 
  8006c3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006c7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006ce:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006d5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006dc:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006e3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006ea:	48 8b 0a             	mov    (%rdx),%rcx
  8006ed:	48 89 08             	mov    %rcx,(%rax)
  8006f0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006f4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006f8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006fc:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800700:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800707:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80070e:	48 89 d6             	mov    %rdx,%rsi
  800711:	48 89 c7             	mov    %rax,%rdi
  800714:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  80071b:	00 00 00 
  80071e:	ff d0                	callq  *%rax
  800720:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800726:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80072c:	c9                   	leaveq 
  80072d:	c3                   	retq   

000000000080072e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80072e:	55                   	push   %rbp
  80072f:	48 89 e5             	mov    %rsp,%rbp
  800732:	53                   	push   %rbx
  800733:	48 83 ec 38          	sub    $0x38,%rsp
  800737:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80073b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80073f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800743:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800746:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80074a:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80074e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800751:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800755:	77 3b                	ja     800792 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800757:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80075a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80075e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800761:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800765:	ba 00 00 00 00       	mov    $0x0,%edx
  80076a:	48 f7 f3             	div    %rbx
  80076d:	48 89 c2             	mov    %rax,%rdx
  800770:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800773:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800776:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80077a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077e:	41 89 f9             	mov    %edi,%r9d
  800781:	48 89 c7             	mov    %rax,%rdi
  800784:	48 b8 2e 07 80 00 00 	movabs $0x80072e,%rax
  80078b:	00 00 00 
  80078e:	ff d0                	callq  *%rax
  800790:	eb 1e                	jmp    8007b0 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800792:	eb 12                	jmp    8007a6 <printnum+0x78>
			putch(padc, putdat);
  800794:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800798:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80079b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079f:	48 89 ce             	mov    %rcx,%rsi
  8007a2:	89 d7                	mov    %edx,%edi
  8007a4:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007a6:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007aa:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007ae:	7f e4                	jg     800794 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007b0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bc:	48 f7 f1             	div    %rcx
  8007bf:	48 89 d0             	mov    %rdx,%rax
  8007c2:	48 ba d0 3c 80 00 00 	movabs $0x803cd0,%rdx
  8007c9:	00 00 00 
  8007cc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007d0:	0f be d0             	movsbl %al,%edx
  8007d3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007db:	48 89 ce             	mov    %rcx,%rsi
  8007de:	89 d7                	mov    %edx,%edi
  8007e0:	ff d0                	callq  *%rax
}
  8007e2:	48 83 c4 38          	add    $0x38,%rsp
  8007e6:	5b                   	pop    %rbx
  8007e7:	5d                   	pop    %rbp
  8007e8:	c3                   	retq   

00000000008007e9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007e9:	55                   	push   %rbp
  8007ea:	48 89 e5             	mov    %rsp,%rbp
  8007ed:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007f5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007f8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007fc:	7e 52                	jle    800850 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800802:	8b 00                	mov    (%rax),%eax
  800804:	83 f8 30             	cmp    $0x30,%eax
  800807:	73 24                	jae    80082d <getuint+0x44>
  800809:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800815:	8b 00                	mov    (%rax),%eax
  800817:	89 c0                	mov    %eax,%eax
  800819:	48 01 d0             	add    %rdx,%rax
  80081c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800820:	8b 12                	mov    (%rdx),%edx
  800822:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800825:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800829:	89 0a                	mov    %ecx,(%rdx)
  80082b:	eb 17                	jmp    800844 <getuint+0x5b>
  80082d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800831:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800835:	48 89 d0             	mov    %rdx,%rax
  800838:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80083c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800840:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800844:	48 8b 00             	mov    (%rax),%rax
  800847:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80084b:	e9 a3 00 00 00       	jmpq   8008f3 <getuint+0x10a>
	else if (lflag)
  800850:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800854:	74 4f                	je     8008a5 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085a:	8b 00                	mov    (%rax),%eax
  80085c:	83 f8 30             	cmp    $0x30,%eax
  80085f:	73 24                	jae    800885 <getuint+0x9c>
  800861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800865:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086d:	8b 00                	mov    (%rax),%eax
  80086f:	89 c0                	mov    %eax,%eax
  800871:	48 01 d0             	add    %rdx,%rax
  800874:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800878:	8b 12                	mov    (%rdx),%edx
  80087a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80087d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800881:	89 0a                	mov    %ecx,(%rdx)
  800883:	eb 17                	jmp    80089c <getuint+0xb3>
  800885:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800889:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80088d:	48 89 d0             	mov    %rdx,%rax
  800890:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800894:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800898:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80089c:	48 8b 00             	mov    (%rax),%rax
  80089f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008a3:	eb 4e                	jmp    8008f3 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a9:	8b 00                	mov    (%rax),%eax
  8008ab:	83 f8 30             	cmp    $0x30,%eax
  8008ae:	73 24                	jae    8008d4 <getuint+0xeb>
  8008b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bc:	8b 00                	mov    (%rax),%eax
  8008be:	89 c0                	mov    %eax,%eax
  8008c0:	48 01 d0             	add    %rdx,%rax
  8008c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c7:	8b 12                	mov    (%rdx),%edx
  8008c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d0:	89 0a                	mov    %ecx,(%rdx)
  8008d2:	eb 17                	jmp    8008eb <getuint+0x102>
  8008d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008dc:	48 89 d0             	mov    %rdx,%rax
  8008df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008eb:	8b 00                	mov    (%rax),%eax
  8008ed:	89 c0                	mov    %eax,%eax
  8008ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008f7:	c9                   	leaveq 
  8008f8:	c3                   	retq   

00000000008008f9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008f9:	55                   	push   %rbp
  8008fa:	48 89 e5             	mov    %rsp,%rbp
  8008fd:	48 83 ec 1c          	sub    $0x1c,%rsp
  800901:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800905:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800908:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80090c:	7e 52                	jle    800960 <getint+0x67>
		x=va_arg(*ap, long long);
  80090e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800912:	8b 00                	mov    (%rax),%eax
  800914:	83 f8 30             	cmp    $0x30,%eax
  800917:	73 24                	jae    80093d <getint+0x44>
  800919:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800925:	8b 00                	mov    (%rax),%eax
  800927:	89 c0                	mov    %eax,%eax
  800929:	48 01 d0             	add    %rdx,%rax
  80092c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800930:	8b 12                	mov    (%rdx),%edx
  800932:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800935:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800939:	89 0a                	mov    %ecx,(%rdx)
  80093b:	eb 17                	jmp    800954 <getint+0x5b>
  80093d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800941:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800945:	48 89 d0             	mov    %rdx,%rax
  800948:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80094c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800950:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800954:	48 8b 00             	mov    (%rax),%rax
  800957:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80095b:	e9 a3 00 00 00       	jmpq   800a03 <getint+0x10a>
	else if (lflag)
  800960:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800964:	74 4f                	je     8009b5 <getint+0xbc>
		x=va_arg(*ap, long);
  800966:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096a:	8b 00                	mov    (%rax),%eax
  80096c:	83 f8 30             	cmp    $0x30,%eax
  80096f:	73 24                	jae    800995 <getint+0x9c>
  800971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800975:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097d:	8b 00                	mov    (%rax),%eax
  80097f:	89 c0                	mov    %eax,%eax
  800981:	48 01 d0             	add    %rdx,%rax
  800984:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800988:	8b 12                	mov    (%rdx),%edx
  80098a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80098d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800991:	89 0a                	mov    %ecx,(%rdx)
  800993:	eb 17                	jmp    8009ac <getint+0xb3>
  800995:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800999:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80099d:	48 89 d0             	mov    %rdx,%rax
  8009a0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ac:	48 8b 00             	mov    (%rax),%rax
  8009af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009b3:	eb 4e                	jmp    800a03 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b9:	8b 00                	mov    (%rax),%eax
  8009bb:	83 f8 30             	cmp    $0x30,%eax
  8009be:	73 24                	jae    8009e4 <getint+0xeb>
  8009c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cc:	8b 00                	mov    (%rax),%eax
  8009ce:	89 c0                	mov    %eax,%eax
  8009d0:	48 01 d0             	add    %rdx,%rax
  8009d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d7:	8b 12                	mov    (%rdx),%edx
  8009d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e0:	89 0a                	mov    %ecx,(%rdx)
  8009e2:	eb 17                	jmp    8009fb <getint+0x102>
  8009e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ec:	48 89 d0             	mov    %rdx,%rax
  8009ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009fb:	8b 00                	mov    (%rax),%eax
  8009fd:	48 98                	cltq   
  8009ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a07:	c9                   	leaveq 
  800a08:	c3                   	retq   

0000000000800a09 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a09:	55                   	push   %rbp
  800a0a:	48 89 e5             	mov    %rsp,%rbp
  800a0d:	41 54                	push   %r12
  800a0f:	53                   	push   %rbx
  800a10:	48 83 ec 60          	sub    $0x60,%rsp
  800a14:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a18:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a1c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a20:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a24:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a28:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a2c:	48 8b 0a             	mov    (%rdx),%rcx
  800a2f:	48 89 08             	mov    %rcx,(%rax)
  800a32:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a36:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a3a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a3e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a42:	eb 28                	jmp    800a6c <vprintfmt+0x63>
			if (ch == '\0'){
  800a44:	85 db                	test   %ebx,%ebx
  800a46:	75 15                	jne    800a5d <vprintfmt+0x54>
				current_color=WHITE;
  800a48:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800a4f:	00 00 00 
  800a52:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800a58:	e9 fc 04 00 00       	jmpq   800f59 <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  800a5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a65:	48 89 d6             	mov    %rdx,%rsi
  800a68:	89 df                	mov    %ebx,%edi
  800a6a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a6c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a70:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a74:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a78:	0f b6 00             	movzbl (%rax),%eax
  800a7b:	0f b6 d8             	movzbl %al,%ebx
  800a7e:	83 fb 25             	cmp    $0x25,%ebx
  800a81:	75 c1                	jne    800a44 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a83:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a87:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a8e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a95:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a9c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800aa3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aa7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800aab:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800aaf:	0f b6 00             	movzbl (%rax),%eax
  800ab2:	0f b6 d8             	movzbl %al,%ebx
  800ab5:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ab8:	83 f8 55             	cmp    $0x55,%eax
  800abb:	0f 87 64 04 00 00    	ja     800f25 <vprintfmt+0x51c>
  800ac1:	89 c0                	mov    %eax,%eax
  800ac3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800aca:	00 
  800acb:	48 b8 f8 3c 80 00 00 	movabs $0x803cf8,%rax
  800ad2:	00 00 00 
  800ad5:	48 01 d0             	add    %rdx,%rax
  800ad8:	48 8b 00             	mov    (%rax),%rax
  800adb:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800add:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ae1:	eb c0                	jmp    800aa3 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ae3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ae7:	eb ba                	jmp    800aa3 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ae9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800af0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800af3:	89 d0                	mov    %edx,%eax
  800af5:	c1 e0 02             	shl    $0x2,%eax
  800af8:	01 d0                	add    %edx,%eax
  800afa:	01 c0                	add    %eax,%eax
  800afc:	01 d8                	add    %ebx,%eax
  800afe:	83 e8 30             	sub    $0x30,%eax
  800b01:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b04:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b08:	0f b6 00             	movzbl (%rax),%eax
  800b0b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b0e:	83 fb 2f             	cmp    $0x2f,%ebx
  800b11:	7e 0c                	jle    800b1f <vprintfmt+0x116>
  800b13:	83 fb 39             	cmp    $0x39,%ebx
  800b16:	7f 07                	jg     800b1f <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b18:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b1d:	eb d1                	jmp    800af0 <vprintfmt+0xe7>
			goto process_precision;
  800b1f:	eb 58                	jmp    800b79 <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800b21:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b24:	83 f8 30             	cmp    $0x30,%eax
  800b27:	73 17                	jae    800b40 <vprintfmt+0x137>
  800b29:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b2d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b30:	89 c0                	mov    %eax,%eax
  800b32:	48 01 d0             	add    %rdx,%rax
  800b35:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b38:	83 c2 08             	add    $0x8,%edx
  800b3b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b3e:	eb 0f                	jmp    800b4f <vprintfmt+0x146>
  800b40:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b44:	48 89 d0             	mov    %rdx,%rax
  800b47:	48 83 c2 08          	add    $0x8,%rdx
  800b4b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b4f:	8b 00                	mov    (%rax),%eax
  800b51:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b54:	eb 23                	jmp    800b79 <vprintfmt+0x170>

		case '.':
			if (width < 0)
  800b56:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b5a:	79 0c                	jns    800b68 <vprintfmt+0x15f>
				width = 0;
  800b5c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b63:	e9 3b ff ff ff       	jmpq   800aa3 <vprintfmt+0x9a>
  800b68:	e9 36 ff ff ff       	jmpq   800aa3 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  800b6d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b74:	e9 2a ff ff ff       	jmpq   800aa3 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  800b79:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b7d:	79 12                	jns    800b91 <vprintfmt+0x188>
				width = precision, precision = -1;
  800b7f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b82:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b85:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b8c:	e9 12 ff ff ff       	jmpq   800aa3 <vprintfmt+0x9a>
  800b91:	e9 0d ff ff ff       	jmpq   800aa3 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b96:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b9a:	e9 04 ff ff ff       	jmpq   800aa3 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba2:	83 f8 30             	cmp    $0x30,%eax
  800ba5:	73 17                	jae    800bbe <vprintfmt+0x1b5>
  800ba7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bae:	89 c0                	mov    %eax,%eax
  800bb0:	48 01 d0             	add    %rdx,%rax
  800bb3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bb6:	83 c2 08             	add    $0x8,%edx
  800bb9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bbc:	eb 0f                	jmp    800bcd <vprintfmt+0x1c4>
  800bbe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bc2:	48 89 d0             	mov    %rdx,%rax
  800bc5:	48 83 c2 08          	add    $0x8,%rdx
  800bc9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bcd:	8b 10                	mov    (%rax),%edx
  800bcf:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd7:	48 89 ce             	mov    %rcx,%rsi
  800bda:	89 d7                	mov    %edx,%edi
  800bdc:	ff d0                	callq  *%rax
			break;
  800bde:	e9 70 03 00 00       	jmpq   800f53 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800be3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be6:	83 f8 30             	cmp    $0x30,%eax
  800be9:	73 17                	jae    800c02 <vprintfmt+0x1f9>
  800beb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf2:	89 c0                	mov    %eax,%eax
  800bf4:	48 01 d0             	add    %rdx,%rax
  800bf7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bfa:	83 c2 08             	add    $0x8,%edx
  800bfd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c00:	eb 0f                	jmp    800c11 <vprintfmt+0x208>
  800c02:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c06:	48 89 d0             	mov    %rdx,%rax
  800c09:	48 83 c2 08          	add    $0x8,%rdx
  800c0d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c11:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c13:	85 db                	test   %ebx,%ebx
  800c15:	79 02                	jns    800c19 <vprintfmt+0x210>
				err = -err;
  800c17:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c19:	83 fb 15             	cmp    $0x15,%ebx
  800c1c:	7f 16                	jg     800c34 <vprintfmt+0x22b>
  800c1e:	48 b8 20 3c 80 00 00 	movabs $0x803c20,%rax
  800c25:	00 00 00 
  800c28:	48 63 d3             	movslq %ebx,%rdx
  800c2b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c2f:	4d 85 e4             	test   %r12,%r12
  800c32:	75 2e                	jne    800c62 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  800c34:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3c:	89 d9                	mov    %ebx,%ecx
  800c3e:	48 ba e1 3c 80 00 00 	movabs $0x803ce1,%rdx
  800c45:	00 00 00 
  800c48:	48 89 c7             	mov    %rax,%rdi
  800c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c50:	49 b8 62 0f 80 00 00 	movabs $0x800f62,%r8
  800c57:	00 00 00 
  800c5a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c5d:	e9 f1 02 00 00       	jmpq   800f53 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c62:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6a:	4c 89 e1             	mov    %r12,%rcx
  800c6d:	48 ba ea 3c 80 00 00 	movabs $0x803cea,%rdx
  800c74:	00 00 00 
  800c77:	48 89 c7             	mov    %rax,%rdi
  800c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7f:	49 b8 62 0f 80 00 00 	movabs $0x800f62,%r8
  800c86:	00 00 00 
  800c89:	41 ff d0             	callq  *%r8
			break;
  800c8c:	e9 c2 02 00 00       	jmpq   800f53 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c91:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c94:	83 f8 30             	cmp    $0x30,%eax
  800c97:	73 17                	jae    800cb0 <vprintfmt+0x2a7>
  800c99:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca0:	89 c0                	mov    %eax,%eax
  800ca2:	48 01 d0             	add    %rdx,%rax
  800ca5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca8:	83 c2 08             	add    $0x8,%edx
  800cab:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cae:	eb 0f                	jmp    800cbf <vprintfmt+0x2b6>
  800cb0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb4:	48 89 d0             	mov    %rdx,%rax
  800cb7:	48 83 c2 08          	add    $0x8,%rdx
  800cbb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cbf:	4c 8b 20             	mov    (%rax),%r12
  800cc2:	4d 85 e4             	test   %r12,%r12
  800cc5:	75 0a                	jne    800cd1 <vprintfmt+0x2c8>
				p = "(null)";
  800cc7:	49 bc ed 3c 80 00 00 	movabs $0x803ced,%r12
  800cce:	00 00 00 
			if (width > 0 && padc != '-')
  800cd1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cd5:	7e 3f                	jle    800d16 <vprintfmt+0x30d>
  800cd7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cdb:	74 39                	je     800d16 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cdd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ce0:	48 98                	cltq   
  800ce2:	48 89 c6             	mov    %rax,%rsi
  800ce5:	4c 89 e7             	mov    %r12,%rdi
  800ce8:	48 b8 0e 12 80 00 00 	movabs $0x80120e,%rax
  800cef:	00 00 00 
  800cf2:	ff d0                	callq  *%rax
  800cf4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cf7:	eb 17                	jmp    800d10 <vprintfmt+0x307>
					putch(padc, putdat);
  800cf9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cfd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d05:	48 89 ce             	mov    %rcx,%rsi
  800d08:	89 d7                	mov    %edx,%edi
  800d0a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d0c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d10:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d14:	7f e3                	jg     800cf9 <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d16:	eb 37                	jmp    800d4f <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  800d18:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d1c:	74 1e                	je     800d3c <vprintfmt+0x333>
  800d1e:	83 fb 1f             	cmp    $0x1f,%ebx
  800d21:	7e 05                	jle    800d28 <vprintfmt+0x31f>
  800d23:	83 fb 7e             	cmp    $0x7e,%ebx
  800d26:	7e 14                	jle    800d3c <vprintfmt+0x333>
					putch('?', putdat);
  800d28:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d30:	48 89 d6             	mov    %rdx,%rsi
  800d33:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d38:	ff d0                	callq  *%rax
  800d3a:	eb 0f                	jmp    800d4b <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800d3c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d44:	48 89 d6             	mov    %rdx,%rsi
  800d47:	89 df                	mov    %ebx,%edi
  800d49:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d4b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d4f:	4c 89 e0             	mov    %r12,%rax
  800d52:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d56:	0f b6 00             	movzbl (%rax),%eax
  800d59:	0f be d8             	movsbl %al,%ebx
  800d5c:	85 db                	test   %ebx,%ebx
  800d5e:	74 10                	je     800d70 <vprintfmt+0x367>
  800d60:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d64:	78 b2                	js     800d18 <vprintfmt+0x30f>
  800d66:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d6a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d6e:	79 a8                	jns    800d18 <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d70:	eb 16                	jmp    800d88 <vprintfmt+0x37f>
				putch(' ', putdat);
  800d72:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7a:	48 89 d6             	mov    %rdx,%rsi
  800d7d:	bf 20 00 00 00       	mov    $0x20,%edi
  800d82:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d84:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d88:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d8c:	7f e4                	jg     800d72 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800d8e:	e9 c0 01 00 00       	jmpq   800f53 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d93:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d97:	be 03 00 00 00       	mov    $0x3,%esi
  800d9c:	48 89 c7             	mov    %rax,%rdi
  800d9f:	48 b8 f9 08 80 00 00 	movabs $0x8008f9,%rax
  800da6:	00 00 00 
  800da9:	ff d0                	callq  *%rax
  800dab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800daf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db3:	48 85 c0             	test   %rax,%rax
  800db6:	79 1d                	jns    800dd5 <vprintfmt+0x3cc>
				putch('-', putdat);
  800db8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dbc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc0:	48 89 d6             	mov    %rdx,%rsi
  800dc3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dc8:	ff d0                	callq  *%rax
				num = -(long long) num;
  800dca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dce:	48 f7 d8             	neg    %rax
  800dd1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800dd5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ddc:	e9 d5 00 00 00       	jmpq   800eb6 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800de1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800de5:	be 03 00 00 00       	mov    $0x3,%esi
  800dea:	48 89 c7             	mov    %rax,%rdi
  800ded:	48 b8 e9 07 80 00 00 	movabs $0x8007e9,%rax
  800df4:	00 00 00 
  800df7:	ff d0                	callq  *%rax
  800df9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dfd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e04:	e9 ad 00 00 00       	jmpq   800eb6 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800e09:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e0d:	be 03 00 00 00       	mov    $0x3,%esi
  800e12:	48 89 c7             	mov    %rax,%rdi
  800e15:	48 b8 e9 07 80 00 00 	movabs $0x8007e9,%rax
  800e1c:	00 00 00 
  800e1f:	ff d0                	callq  *%rax
  800e21:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800e25:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e2c:	e9 85 00 00 00       	jmpq   800eb6 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800e31:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e39:	48 89 d6             	mov    %rdx,%rsi
  800e3c:	bf 30 00 00 00       	mov    $0x30,%edi
  800e41:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e43:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e4b:	48 89 d6             	mov    %rdx,%rsi
  800e4e:	bf 78 00 00 00       	mov    $0x78,%edi
  800e53:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e58:	83 f8 30             	cmp    $0x30,%eax
  800e5b:	73 17                	jae    800e74 <vprintfmt+0x46b>
  800e5d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e64:	89 c0                	mov    %eax,%eax
  800e66:	48 01 d0             	add    %rdx,%rax
  800e69:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e6c:	83 c2 08             	add    $0x8,%edx
  800e6f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e72:	eb 0f                	jmp    800e83 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  800e74:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e78:	48 89 d0             	mov    %rdx,%rax
  800e7b:	48 83 c2 08          	add    $0x8,%rdx
  800e7f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e83:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e86:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e8a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e91:	eb 23                	jmp    800eb6 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e93:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e97:	be 03 00 00 00       	mov    $0x3,%esi
  800e9c:	48 89 c7             	mov    %rax,%rdi
  800e9f:	48 b8 e9 07 80 00 00 	movabs $0x8007e9,%rax
  800ea6:	00 00 00 
  800ea9:	ff d0                	callq  *%rax
  800eab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800eaf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eb6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ebb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ebe:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ec1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ec5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ec9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ecd:	45 89 c1             	mov    %r8d,%r9d
  800ed0:	41 89 f8             	mov    %edi,%r8d
  800ed3:	48 89 c7             	mov    %rax,%rdi
  800ed6:	48 b8 2e 07 80 00 00 	movabs $0x80072e,%rax
  800edd:	00 00 00 
  800ee0:	ff d0                	callq  *%rax
			break;
  800ee2:	eb 6f                	jmp    800f53 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ee4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eec:	48 89 d6             	mov    %rdx,%rsi
  800eef:	89 df                	mov    %ebx,%edi
  800ef1:	ff d0                	callq  *%rax
			break;
  800ef3:	eb 5e                	jmp    800f53 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  800ef5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ef9:	be 03 00 00 00       	mov    $0x3,%esi
  800efe:	48 89 c7             	mov    %rax,%rdi
  800f01:	48 b8 e9 07 80 00 00 	movabs $0x8007e9,%rax
  800f08:	00 00 00 
  800f0b:	ff d0                	callq  *%rax
  800f0d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  800f11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f15:	89 c2                	mov    %eax,%edx
  800f17:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800f1e:	00 00 00 
  800f21:	89 10                	mov    %edx,(%rax)
			break;
  800f23:	eb 2e                	jmp    800f53 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f2d:	48 89 d6             	mov    %rdx,%rsi
  800f30:	bf 25 00 00 00       	mov    $0x25,%edi
  800f35:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f37:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f3c:	eb 05                	jmp    800f43 <vprintfmt+0x53a>
  800f3e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f43:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f47:	48 83 e8 01          	sub    $0x1,%rax
  800f4b:	0f b6 00             	movzbl (%rax),%eax
  800f4e:	3c 25                	cmp    $0x25,%al
  800f50:	75 ec                	jne    800f3e <vprintfmt+0x535>
				/* do nothing */;
			break;
  800f52:	90                   	nop
		}
	}
  800f53:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f54:	e9 13 fb ff ff       	jmpq   800a6c <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f59:	48 83 c4 60          	add    $0x60,%rsp
  800f5d:	5b                   	pop    %rbx
  800f5e:	41 5c                	pop    %r12
  800f60:	5d                   	pop    %rbp
  800f61:	c3                   	retq   

0000000000800f62 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f62:	55                   	push   %rbp
  800f63:	48 89 e5             	mov    %rsp,%rbp
  800f66:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f6d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f74:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f7b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f82:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f89:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f90:	84 c0                	test   %al,%al
  800f92:	74 20                	je     800fb4 <printfmt+0x52>
  800f94:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f98:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f9c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fa0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fa4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fa8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fac:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fb0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fb4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800fbb:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800fc2:	00 00 00 
  800fc5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800fcc:	00 00 00 
  800fcf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fd3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fda:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fe1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fe8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fef:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ff6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ffd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801004:	48 89 c7             	mov    %rax,%rdi
  801007:	48 b8 09 0a 80 00 00 	movabs $0x800a09,%rax
  80100e:	00 00 00 
  801011:	ff d0                	callq  *%rax
	va_end(ap);
}
  801013:	c9                   	leaveq 
  801014:	c3                   	retq   

0000000000801015 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801015:	55                   	push   %rbp
  801016:	48 89 e5             	mov    %rsp,%rbp
  801019:	48 83 ec 10          	sub    $0x10,%rsp
  80101d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801020:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801024:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801028:	8b 40 10             	mov    0x10(%rax),%eax
  80102b:	8d 50 01             	lea    0x1(%rax),%edx
  80102e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801032:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801035:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801039:	48 8b 10             	mov    (%rax),%rdx
  80103c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801040:	48 8b 40 08          	mov    0x8(%rax),%rax
  801044:	48 39 c2             	cmp    %rax,%rdx
  801047:	73 17                	jae    801060 <sprintputch+0x4b>
		*b->buf++ = ch;
  801049:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80104d:	48 8b 00             	mov    (%rax),%rax
  801050:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801054:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801058:	48 89 0a             	mov    %rcx,(%rdx)
  80105b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80105e:	88 10                	mov    %dl,(%rax)
}
  801060:	c9                   	leaveq 
  801061:	c3                   	retq   

0000000000801062 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801062:	55                   	push   %rbp
  801063:	48 89 e5             	mov    %rsp,%rbp
  801066:	48 83 ec 50          	sub    $0x50,%rsp
  80106a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80106e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801071:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801075:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801079:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80107d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801081:	48 8b 0a             	mov    (%rdx),%rcx
  801084:	48 89 08             	mov    %rcx,(%rax)
  801087:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80108b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80108f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801093:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801097:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80109b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80109f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8010a2:	48 98                	cltq   
  8010a4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8010a8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010ac:	48 01 d0             	add    %rdx,%rax
  8010af:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8010b3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8010ba:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8010bf:	74 06                	je     8010c7 <vsnprintf+0x65>
  8010c1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010c5:	7f 07                	jg     8010ce <vsnprintf+0x6c>
		return -E_INVAL;
  8010c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010cc:	eb 2f                	jmp    8010fd <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8010ce:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8010d2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010d6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010da:	48 89 c6             	mov    %rax,%rsi
  8010dd:	48 bf 15 10 80 00 00 	movabs $0x801015,%rdi
  8010e4:	00 00 00 
  8010e7:	48 b8 09 0a 80 00 00 	movabs $0x800a09,%rax
  8010ee:	00 00 00 
  8010f1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010f7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010fa:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010fd:	c9                   	leaveq 
  8010fe:	c3                   	retq   

00000000008010ff <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010ff:	55                   	push   %rbp
  801100:	48 89 e5             	mov    %rsp,%rbp
  801103:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80110a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801111:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801117:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80111e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801125:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80112c:	84 c0                	test   %al,%al
  80112e:	74 20                	je     801150 <snprintf+0x51>
  801130:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801134:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801138:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80113c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801140:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801144:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801148:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80114c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801150:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801157:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80115e:	00 00 00 
  801161:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801168:	00 00 00 
  80116b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80116f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801176:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80117d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801184:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80118b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801192:	48 8b 0a             	mov    (%rdx),%rcx
  801195:	48 89 08             	mov    %rcx,(%rax)
  801198:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80119c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011a0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011a4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8011a8:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8011af:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8011b6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8011bc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8011c3:	48 89 c7             	mov    %rax,%rdi
  8011c6:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  8011cd:	00 00 00 
  8011d0:	ff d0                	callq  *%rax
  8011d2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011d8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011de:	c9                   	leaveq 
  8011df:	c3                   	retq   

00000000008011e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011e0:	55                   	push   %rbp
  8011e1:	48 89 e5             	mov    %rsp,%rbp
  8011e4:	48 83 ec 18          	sub    $0x18,%rsp
  8011e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011f3:	eb 09                	jmp    8011fe <strlen+0x1e>
		n++;
  8011f5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011f9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801202:	0f b6 00             	movzbl (%rax),%eax
  801205:	84 c0                	test   %al,%al
  801207:	75 ec                	jne    8011f5 <strlen+0x15>
		n++;
	return n;
  801209:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80120c:	c9                   	leaveq 
  80120d:	c3                   	retq   

000000000080120e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80120e:	55                   	push   %rbp
  80120f:	48 89 e5             	mov    %rsp,%rbp
  801212:	48 83 ec 20          	sub    $0x20,%rsp
  801216:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80121e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801225:	eb 0e                	jmp    801235 <strnlen+0x27>
		n++;
  801227:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80122b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801230:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801235:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80123a:	74 0b                	je     801247 <strnlen+0x39>
  80123c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801240:	0f b6 00             	movzbl (%rax),%eax
  801243:	84 c0                	test   %al,%al
  801245:	75 e0                	jne    801227 <strnlen+0x19>
		n++;
	return n;
  801247:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80124a:	c9                   	leaveq 
  80124b:	c3                   	retq   

000000000080124c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80124c:	55                   	push   %rbp
  80124d:	48 89 e5             	mov    %rsp,%rbp
  801250:	48 83 ec 20          	sub    $0x20,%rsp
  801254:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801258:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80125c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801260:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801264:	90                   	nop
  801265:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801269:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80126d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801271:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801275:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801279:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80127d:	0f b6 12             	movzbl (%rdx),%edx
  801280:	88 10                	mov    %dl,(%rax)
  801282:	0f b6 00             	movzbl (%rax),%eax
  801285:	84 c0                	test   %al,%al
  801287:	75 dc                	jne    801265 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801289:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80128d:	c9                   	leaveq 
  80128e:	c3                   	retq   

000000000080128f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80128f:	55                   	push   %rbp
  801290:	48 89 e5             	mov    %rsp,%rbp
  801293:	48 83 ec 20          	sub    $0x20,%rsp
  801297:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80129b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80129f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a3:	48 89 c7             	mov    %rax,%rdi
  8012a6:	48 b8 e0 11 80 00 00 	movabs $0x8011e0,%rax
  8012ad:	00 00 00 
  8012b0:	ff d0                	callq  *%rax
  8012b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8012b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012b8:	48 63 d0             	movslq %eax,%rdx
  8012bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bf:	48 01 c2             	add    %rax,%rdx
  8012c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c6:	48 89 c6             	mov    %rax,%rsi
  8012c9:	48 89 d7             	mov    %rdx,%rdi
  8012cc:	48 b8 4c 12 80 00 00 	movabs $0x80124c,%rax
  8012d3:	00 00 00 
  8012d6:	ff d0                	callq  *%rax
	return dst;
  8012d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012dc:	c9                   	leaveq 
  8012dd:	c3                   	retq   

00000000008012de <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012de:	55                   	push   %rbp
  8012df:	48 89 e5             	mov    %rsp,%rbp
  8012e2:	48 83 ec 28          	sub    $0x28,%rsp
  8012e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012fa:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801301:	00 
  801302:	eb 2a                	jmp    80132e <strncpy+0x50>
		*dst++ = *src;
  801304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801308:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80130c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801310:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801314:	0f b6 12             	movzbl (%rdx),%edx
  801317:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801319:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80131d:	0f b6 00             	movzbl (%rax),%eax
  801320:	84 c0                	test   %al,%al
  801322:	74 05                	je     801329 <strncpy+0x4b>
			src++;
  801324:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801329:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80132e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801332:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801336:	72 cc                	jb     801304 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801338:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80133c:	c9                   	leaveq 
  80133d:	c3                   	retq   

000000000080133e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80133e:	55                   	push   %rbp
  80133f:	48 89 e5             	mov    %rsp,%rbp
  801342:	48 83 ec 28          	sub    $0x28,%rsp
  801346:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80134a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80134e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801352:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801356:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80135a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80135f:	74 3d                	je     80139e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801361:	eb 1d                	jmp    801380 <strlcpy+0x42>
			*dst++ = *src++;
  801363:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801367:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80136b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80136f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801373:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801377:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80137b:	0f b6 12             	movzbl (%rdx),%edx
  80137e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801380:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801385:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80138a:	74 0b                	je     801397 <strlcpy+0x59>
  80138c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801390:	0f b6 00             	movzbl (%rax),%eax
  801393:	84 c0                	test   %al,%al
  801395:	75 cc                	jne    801363 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801397:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80139b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80139e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a6:	48 29 c2             	sub    %rax,%rdx
  8013a9:	48 89 d0             	mov    %rdx,%rax
}
  8013ac:	c9                   	leaveq 
  8013ad:	c3                   	retq   

00000000008013ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013ae:	55                   	push   %rbp
  8013af:	48 89 e5             	mov    %rsp,%rbp
  8013b2:	48 83 ec 10          	sub    $0x10,%rsp
  8013b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8013be:	eb 0a                	jmp    8013ca <strcmp+0x1c>
		p++, q++;
  8013c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013c5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ce:	0f b6 00             	movzbl (%rax),%eax
  8013d1:	84 c0                	test   %al,%al
  8013d3:	74 12                	je     8013e7 <strcmp+0x39>
  8013d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d9:	0f b6 10             	movzbl (%rax),%edx
  8013dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e0:	0f b6 00             	movzbl (%rax),%eax
  8013e3:	38 c2                	cmp    %al,%dl
  8013e5:	74 d9                	je     8013c0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013eb:	0f b6 00             	movzbl (%rax),%eax
  8013ee:	0f b6 d0             	movzbl %al,%edx
  8013f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f5:	0f b6 00             	movzbl (%rax),%eax
  8013f8:	0f b6 c0             	movzbl %al,%eax
  8013fb:	29 c2                	sub    %eax,%edx
  8013fd:	89 d0                	mov    %edx,%eax
}
  8013ff:	c9                   	leaveq 
  801400:	c3                   	retq   

0000000000801401 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801401:	55                   	push   %rbp
  801402:	48 89 e5             	mov    %rsp,%rbp
  801405:	48 83 ec 18          	sub    $0x18,%rsp
  801409:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80140d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801411:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801415:	eb 0f                	jmp    801426 <strncmp+0x25>
		n--, p++, q++;
  801417:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80141c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801421:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801426:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80142b:	74 1d                	je     80144a <strncmp+0x49>
  80142d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801431:	0f b6 00             	movzbl (%rax),%eax
  801434:	84 c0                	test   %al,%al
  801436:	74 12                	je     80144a <strncmp+0x49>
  801438:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143c:	0f b6 10             	movzbl (%rax),%edx
  80143f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801443:	0f b6 00             	movzbl (%rax),%eax
  801446:	38 c2                	cmp    %al,%dl
  801448:	74 cd                	je     801417 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80144a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80144f:	75 07                	jne    801458 <strncmp+0x57>
		return 0;
  801451:	b8 00 00 00 00       	mov    $0x0,%eax
  801456:	eb 18                	jmp    801470 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145c:	0f b6 00             	movzbl (%rax),%eax
  80145f:	0f b6 d0             	movzbl %al,%edx
  801462:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801466:	0f b6 00             	movzbl (%rax),%eax
  801469:	0f b6 c0             	movzbl %al,%eax
  80146c:	29 c2                	sub    %eax,%edx
  80146e:	89 d0                	mov    %edx,%eax
}
  801470:	c9                   	leaveq 
  801471:	c3                   	retq   

0000000000801472 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801472:	55                   	push   %rbp
  801473:	48 89 e5             	mov    %rsp,%rbp
  801476:	48 83 ec 0c          	sub    $0xc,%rsp
  80147a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147e:	89 f0                	mov    %esi,%eax
  801480:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801483:	eb 17                	jmp    80149c <strchr+0x2a>
		if (*s == c)
  801485:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801489:	0f b6 00             	movzbl (%rax),%eax
  80148c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80148f:	75 06                	jne    801497 <strchr+0x25>
			return (char *) s;
  801491:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801495:	eb 15                	jmp    8014ac <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801497:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80149c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a0:	0f b6 00             	movzbl (%rax),%eax
  8014a3:	84 c0                	test   %al,%al
  8014a5:	75 de                	jne    801485 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8014a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ac:	c9                   	leaveq 
  8014ad:	c3                   	retq   

00000000008014ae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014ae:	55                   	push   %rbp
  8014af:	48 89 e5             	mov    %rsp,%rbp
  8014b2:	48 83 ec 0c          	sub    $0xc,%rsp
  8014b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014ba:	89 f0                	mov    %esi,%eax
  8014bc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014bf:	eb 13                	jmp    8014d4 <strfind+0x26>
		if (*s == c)
  8014c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c5:	0f b6 00             	movzbl (%rax),%eax
  8014c8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014cb:	75 02                	jne    8014cf <strfind+0x21>
			break;
  8014cd:	eb 10                	jmp    8014df <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014cf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d8:	0f b6 00             	movzbl (%rax),%eax
  8014db:	84 c0                	test   %al,%al
  8014dd:	75 e2                	jne    8014c1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014e3:	c9                   	leaveq 
  8014e4:	c3                   	retq   

00000000008014e5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014e5:	55                   	push   %rbp
  8014e6:	48 89 e5             	mov    %rsp,%rbp
  8014e9:	48 83 ec 18          	sub    $0x18,%rsp
  8014ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014f1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014f8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014fd:	75 06                	jne    801505 <memset+0x20>
		return v;
  8014ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801503:	eb 69                	jmp    80156e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801509:	83 e0 03             	and    $0x3,%eax
  80150c:	48 85 c0             	test   %rax,%rax
  80150f:	75 48                	jne    801559 <memset+0x74>
  801511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801515:	83 e0 03             	and    $0x3,%eax
  801518:	48 85 c0             	test   %rax,%rax
  80151b:	75 3c                	jne    801559 <memset+0x74>
		c &= 0xFF;
  80151d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801524:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801527:	c1 e0 18             	shl    $0x18,%eax
  80152a:	89 c2                	mov    %eax,%edx
  80152c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80152f:	c1 e0 10             	shl    $0x10,%eax
  801532:	09 c2                	or     %eax,%edx
  801534:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801537:	c1 e0 08             	shl    $0x8,%eax
  80153a:	09 d0                	or     %edx,%eax
  80153c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80153f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801543:	48 c1 e8 02          	shr    $0x2,%rax
  801547:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80154a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80154e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801551:	48 89 d7             	mov    %rdx,%rdi
  801554:	fc                   	cld    
  801555:	f3 ab                	rep stos %eax,%es:(%rdi)
  801557:	eb 11                	jmp    80156a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801559:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80155d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801560:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801564:	48 89 d7             	mov    %rdx,%rdi
  801567:	fc                   	cld    
  801568:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80156a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80156e:	c9                   	leaveq 
  80156f:	c3                   	retq   

0000000000801570 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801570:	55                   	push   %rbp
  801571:	48 89 e5             	mov    %rsp,%rbp
  801574:	48 83 ec 28          	sub    $0x28,%rsp
  801578:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80157c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801580:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801584:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801588:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80158c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801590:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801598:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80159c:	0f 83 88 00 00 00    	jae    80162a <memmove+0xba>
  8015a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015aa:	48 01 d0             	add    %rdx,%rax
  8015ad:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015b1:	76 77                	jbe    80162a <memmove+0xba>
		s += n;
  8015b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8015bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bf:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c7:	83 e0 03             	and    $0x3,%eax
  8015ca:	48 85 c0             	test   %rax,%rax
  8015cd:	75 3b                	jne    80160a <memmove+0x9a>
  8015cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d3:	83 e0 03             	and    $0x3,%eax
  8015d6:	48 85 c0             	test   %rax,%rax
  8015d9:	75 2f                	jne    80160a <memmove+0x9a>
  8015db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015df:	83 e0 03             	and    $0x3,%eax
  8015e2:	48 85 c0             	test   %rax,%rax
  8015e5:	75 23                	jne    80160a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015eb:	48 83 e8 04          	sub    $0x4,%rax
  8015ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015f3:	48 83 ea 04          	sub    $0x4,%rdx
  8015f7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015fb:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015ff:	48 89 c7             	mov    %rax,%rdi
  801602:	48 89 d6             	mov    %rdx,%rsi
  801605:	fd                   	std    
  801606:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801608:	eb 1d                	jmp    801627 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80160a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801612:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801616:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80161a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161e:	48 89 d7             	mov    %rdx,%rdi
  801621:	48 89 c1             	mov    %rax,%rcx
  801624:	fd                   	std    
  801625:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801627:	fc                   	cld    
  801628:	eb 57                	jmp    801681 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80162a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162e:	83 e0 03             	and    $0x3,%eax
  801631:	48 85 c0             	test   %rax,%rax
  801634:	75 36                	jne    80166c <memmove+0xfc>
  801636:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163a:	83 e0 03             	and    $0x3,%eax
  80163d:	48 85 c0             	test   %rax,%rax
  801640:	75 2a                	jne    80166c <memmove+0xfc>
  801642:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801646:	83 e0 03             	and    $0x3,%eax
  801649:	48 85 c0             	test   %rax,%rax
  80164c:	75 1e                	jne    80166c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80164e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801652:	48 c1 e8 02          	shr    $0x2,%rax
  801656:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801659:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80165d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801661:	48 89 c7             	mov    %rax,%rdi
  801664:	48 89 d6             	mov    %rdx,%rsi
  801667:	fc                   	cld    
  801668:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80166a:	eb 15                	jmp    801681 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80166c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801670:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801674:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801678:	48 89 c7             	mov    %rax,%rdi
  80167b:	48 89 d6             	mov    %rdx,%rsi
  80167e:	fc                   	cld    
  80167f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801681:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801685:	c9                   	leaveq 
  801686:	c3                   	retq   

0000000000801687 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801687:	55                   	push   %rbp
  801688:	48 89 e5             	mov    %rsp,%rbp
  80168b:	48 83 ec 18          	sub    $0x18,%rsp
  80168f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801693:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801697:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80169b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80169f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a7:	48 89 ce             	mov    %rcx,%rsi
  8016aa:	48 89 c7             	mov    %rax,%rdi
  8016ad:	48 b8 70 15 80 00 00 	movabs $0x801570,%rax
  8016b4:	00 00 00 
  8016b7:	ff d0                	callq  *%rax
}
  8016b9:	c9                   	leaveq 
  8016ba:	c3                   	retq   

00000000008016bb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8016bb:	55                   	push   %rbp
  8016bc:	48 89 e5             	mov    %rsp,%rbp
  8016bf:	48 83 ec 28          	sub    $0x28,%rsp
  8016c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8016cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016df:	eb 36                	jmp    801717 <memcmp+0x5c>
		if (*s1 != *s2)
  8016e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e5:	0f b6 10             	movzbl (%rax),%edx
  8016e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ec:	0f b6 00             	movzbl (%rax),%eax
  8016ef:	38 c2                	cmp    %al,%dl
  8016f1:	74 1a                	je     80170d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	0f b6 d0             	movzbl %al,%edx
  8016fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801701:	0f b6 00             	movzbl (%rax),%eax
  801704:	0f b6 c0             	movzbl %al,%eax
  801707:	29 c2                	sub    %eax,%edx
  801709:	89 d0                	mov    %edx,%eax
  80170b:	eb 20                	jmp    80172d <memcmp+0x72>
		s1++, s2++;
  80170d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801712:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801717:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80171f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801723:	48 85 c0             	test   %rax,%rax
  801726:	75 b9                	jne    8016e1 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172d:	c9                   	leaveq 
  80172e:	c3                   	retq   

000000000080172f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80172f:	55                   	push   %rbp
  801730:	48 89 e5             	mov    %rsp,%rbp
  801733:	48 83 ec 28          	sub    $0x28,%rsp
  801737:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80173b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80173e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801742:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801746:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80174a:	48 01 d0             	add    %rdx,%rax
  80174d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801751:	eb 15                	jmp    801768 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801757:	0f b6 10             	movzbl (%rax),%edx
  80175a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80175d:	38 c2                	cmp    %al,%dl
  80175f:	75 02                	jne    801763 <memfind+0x34>
			break;
  801761:	eb 0f                	jmp    801772 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801763:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80176c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801770:	72 e1                	jb     801753 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801776:	c9                   	leaveq 
  801777:	c3                   	retq   

0000000000801778 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801778:	55                   	push   %rbp
  801779:	48 89 e5             	mov    %rsp,%rbp
  80177c:	48 83 ec 34          	sub    $0x34,%rsp
  801780:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801784:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801788:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80178b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801792:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801799:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80179a:	eb 05                	jmp    8017a1 <strtol+0x29>
		s++;
  80179c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a5:	0f b6 00             	movzbl (%rax),%eax
  8017a8:	3c 20                	cmp    $0x20,%al
  8017aa:	74 f0                	je     80179c <strtol+0x24>
  8017ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b0:	0f b6 00             	movzbl (%rax),%eax
  8017b3:	3c 09                	cmp    $0x9,%al
  8017b5:	74 e5                	je     80179c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bb:	0f b6 00             	movzbl (%rax),%eax
  8017be:	3c 2b                	cmp    $0x2b,%al
  8017c0:	75 07                	jne    8017c9 <strtol+0x51>
		s++;
  8017c2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017c7:	eb 17                	jmp    8017e0 <strtol+0x68>
	else if (*s == '-')
  8017c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cd:	0f b6 00             	movzbl (%rax),%eax
  8017d0:	3c 2d                	cmp    $0x2d,%al
  8017d2:	75 0c                	jne    8017e0 <strtol+0x68>
		s++, neg = 1;
  8017d4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017e0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017e4:	74 06                	je     8017ec <strtol+0x74>
  8017e6:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017ea:	75 28                	jne    801814 <strtol+0x9c>
  8017ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f0:	0f b6 00             	movzbl (%rax),%eax
  8017f3:	3c 30                	cmp    $0x30,%al
  8017f5:	75 1d                	jne    801814 <strtol+0x9c>
  8017f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fb:	48 83 c0 01          	add    $0x1,%rax
  8017ff:	0f b6 00             	movzbl (%rax),%eax
  801802:	3c 78                	cmp    $0x78,%al
  801804:	75 0e                	jne    801814 <strtol+0x9c>
		s += 2, base = 16;
  801806:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80180b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801812:	eb 2c                	jmp    801840 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801814:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801818:	75 19                	jne    801833 <strtol+0xbb>
  80181a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181e:	0f b6 00             	movzbl (%rax),%eax
  801821:	3c 30                	cmp    $0x30,%al
  801823:	75 0e                	jne    801833 <strtol+0xbb>
		s++, base = 8;
  801825:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80182a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801831:	eb 0d                	jmp    801840 <strtol+0xc8>
	else if (base == 0)
  801833:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801837:	75 07                	jne    801840 <strtol+0xc8>
		base = 10;
  801839:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801840:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801844:	0f b6 00             	movzbl (%rax),%eax
  801847:	3c 2f                	cmp    $0x2f,%al
  801849:	7e 1d                	jle    801868 <strtol+0xf0>
  80184b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184f:	0f b6 00             	movzbl (%rax),%eax
  801852:	3c 39                	cmp    $0x39,%al
  801854:	7f 12                	jg     801868 <strtol+0xf0>
			dig = *s - '0';
  801856:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185a:	0f b6 00             	movzbl (%rax),%eax
  80185d:	0f be c0             	movsbl %al,%eax
  801860:	83 e8 30             	sub    $0x30,%eax
  801863:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801866:	eb 4e                	jmp    8018b6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801868:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186c:	0f b6 00             	movzbl (%rax),%eax
  80186f:	3c 60                	cmp    $0x60,%al
  801871:	7e 1d                	jle    801890 <strtol+0x118>
  801873:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801877:	0f b6 00             	movzbl (%rax),%eax
  80187a:	3c 7a                	cmp    $0x7a,%al
  80187c:	7f 12                	jg     801890 <strtol+0x118>
			dig = *s - 'a' + 10;
  80187e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801882:	0f b6 00             	movzbl (%rax),%eax
  801885:	0f be c0             	movsbl %al,%eax
  801888:	83 e8 57             	sub    $0x57,%eax
  80188b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80188e:	eb 26                	jmp    8018b6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801890:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801894:	0f b6 00             	movzbl (%rax),%eax
  801897:	3c 40                	cmp    $0x40,%al
  801899:	7e 48                	jle    8018e3 <strtol+0x16b>
  80189b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189f:	0f b6 00             	movzbl (%rax),%eax
  8018a2:	3c 5a                	cmp    $0x5a,%al
  8018a4:	7f 3d                	jg     8018e3 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8018a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018aa:	0f b6 00             	movzbl (%rax),%eax
  8018ad:	0f be c0             	movsbl %al,%eax
  8018b0:	83 e8 37             	sub    $0x37,%eax
  8018b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8018b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018b9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8018bc:	7c 02                	jl     8018c0 <strtol+0x148>
			break;
  8018be:	eb 23                	jmp    8018e3 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8018c0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018c5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8018c8:	48 98                	cltq   
  8018ca:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8018cf:	48 89 c2             	mov    %rax,%rdx
  8018d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018d5:	48 98                	cltq   
  8018d7:	48 01 d0             	add    %rdx,%rax
  8018da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018de:	e9 5d ff ff ff       	jmpq   801840 <strtol+0xc8>

	if (endptr)
  8018e3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018e8:	74 0b                	je     8018f5 <strtol+0x17d>
		*endptr = (char *) s;
  8018ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018ee:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018f2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018f9:	74 09                	je     801904 <strtol+0x18c>
  8018fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ff:	48 f7 d8             	neg    %rax
  801902:	eb 04                	jmp    801908 <strtol+0x190>
  801904:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801908:	c9                   	leaveq 
  801909:	c3                   	retq   

000000000080190a <strstr>:

char * strstr(const char *in, const char *str)
{
  80190a:	55                   	push   %rbp
  80190b:	48 89 e5             	mov    %rsp,%rbp
  80190e:	48 83 ec 30          	sub    $0x30,%rsp
  801912:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801916:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80191a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80191e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801922:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801926:	0f b6 00             	movzbl (%rax),%eax
  801929:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80192c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801930:	75 06                	jne    801938 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801932:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801936:	eb 6b                	jmp    8019a3 <strstr+0x99>

	len = strlen(str);
  801938:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80193c:	48 89 c7             	mov    %rax,%rdi
  80193f:	48 b8 e0 11 80 00 00 	movabs $0x8011e0,%rax
  801946:	00 00 00 
  801949:	ff d0                	callq  *%rax
  80194b:	48 98                	cltq   
  80194d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801951:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801955:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801959:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80195d:	0f b6 00             	movzbl (%rax),%eax
  801960:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801963:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801967:	75 07                	jne    801970 <strstr+0x66>
				return (char *) 0;
  801969:	b8 00 00 00 00       	mov    $0x0,%eax
  80196e:	eb 33                	jmp    8019a3 <strstr+0x99>
		} while (sc != c);
  801970:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801974:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801977:	75 d8                	jne    801951 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801979:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80197d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801981:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801985:	48 89 ce             	mov    %rcx,%rsi
  801988:	48 89 c7             	mov    %rax,%rdi
  80198b:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  801992:	00 00 00 
  801995:	ff d0                	callq  *%rax
  801997:	85 c0                	test   %eax,%eax
  801999:	75 b6                	jne    801951 <strstr+0x47>

	return (char *) (in - 1);
  80199b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199f:	48 83 e8 01          	sub    $0x1,%rax
}
  8019a3:	c9                   	leaveq 
  8019a4:	c3                   	retq   

00000000008019a5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8019a5:	55                   	push   %rbp
  8019a6:	48 89 e5             	mov    %rsp,%rbp
  8019a9:	53                   	push   %rbx
  8019aa:	48 83 ec 48          	sub    $0x48,%rsp
  8019ae:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8019b1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8019b4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019b8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8019bc:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8019c0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019c4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019c7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8019cb:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8019cf:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019d3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019d7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019db:	4c 89 c3             	mov    %r8,%rbx
  8019de:	cd 30                	int    $0x30
  8019e0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019e4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019e8:	74 3e                	je     801a28 <syscall+0x83>
  8019ea:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019ef:	7e 37                	jle    801a28 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019f5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019f8:	49 89 d0             	mov    %rdx,%r8
  8019fb:	89 c1                	mov    %eax,%ecx
  8019fd:	48 ba a8 3f 80 00 00 	movabs $0x803fa8,%rdx
  801a04:	00 00 00 
  801a07:	be 23 00 00 00       	mov    $0x23,%esi
  801a0c:	48 bf c5 3f 80 00 00 	movabs $0x803fc5,%rdi
  801a13:	00 00 00 
  801a16:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1b:	49 b9 1d 04 80 00 00 	movabs $0x80041d,%r9
  801a22:	00 00 00 
  801a25:	41 ff d1             	callq  *%r9

	return ret;
  801a28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a2c:	48 83 c4 48          	add    $0x48,%rsp
  801a30:	5b                   	pop    %rbx
  801a31:	5d                   	pop    %rbp
  801a32:	c3                   	retq   

0000000000801a33 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a33:	55                   	push   %rbp
  801a34:	48 89 e5             	mov    %rsp,%rbp
  801a37:	48 83 ec 20          	sub    $0x20,%rsp
  801a3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a52:	00 
  801a53:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a59:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5f:	48 89 d1             	mov    %rdx,%rcx
  801a62:	48 89 c2             	mov    %rax,%rdx
  801a65:	be 00 00 00 00       	mov    $0x0,%esi
  801a6a:	bf 00 00 00 00       	mov    $0x0,%edi
  801a6f:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801a76:	00 00 00 
  801a79:	ff d0                	callq  *%rax
}
  801a7b:	c9                   	leaveq 
  801a7c:	c3                   	retq   

0000000000801a7d <sys_cgetc>:

int
sys_cgetc(void)
{
  801a7d:	55                   	push   %rbp
  801a7e:	48 89 e5             	mov    %rsp,%rbp
  801a81:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a85:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8c:	00 
  801a8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a99:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa3:	be 00 00 00 00       	mov    $0x0,%esi
  801aa8:	bf 01 00 00 00       	mov    $0x1,%edi
  801aad:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801ab4:	00 00 00 
  801ab7:	ff d0                	callq  *%rax
}
  801ab9:	c9                   	leaveq 
  801aba:	c3                   	retq   

0000000000801abb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801abb:	55                   	push   %rbp
  801abc:	48 89 e5             	mov    %rsp,%rbp
  801abf:	48 83 ec 10          	sub    $0x10,%rsp
  801ac3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801ac6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac9:	48 98                	cltq   
  801acb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad2:	00 
  801ad3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801adf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae4:	48 89 c2             	mov    %rax,%rdx
  801ae7:	be 01 00 00 00       	mov    $0x1,%esi
  801aec:	bf 03 00 00 00       	mov    $0x3,%edi
  801af1:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801af8:	00 00 00 
  801afb:	ff d0                	callq  *%rax
}
  801afd:	c9                   	leaveq 
  801afe:	c3                   	retq   

0000000000801aff <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801aff:	55                   	push   %rbp
  801b00:	48 89 e5             	mov    %rsp,%rbp
  801b03:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b07:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b0e:	00 
  801b0f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b15:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b1b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b20:	ba 00 00 00 00       	mov    $0x0,%edx
  801b25:	be 00 00 00 00       	mov    $0x0,%esi
  801b2a:	bf 02 00 00 00       	mov    $0x2,%edi
  801b2f:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801b36:	00 00 00 
  801b39:	ff d0                	callq  *%rax
}
  801b3b:	c9                   	leaveq 
  801b3c:	c3                   	retq   

0000000000801b3d <sys_yield>:

void
sys_yield(void)
{
  801b3d:	55                   	push   %rbp
  801b3e:	48 89 e5             	mov    %rsp,%rbp
  801b41:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b4c:	00 
  801b4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b59:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b63:	be 00 00 00 00       	mov    $0x0,%esi
  801b68:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b6d:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801b74:	00 00 00 
  801b77:	ff d0                	callq  *%rax
}
  801b79:	c9                   	leaveq 
  801b7a:	c3                   	retq   

0000000000801b7b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b7b:	55                   	push   %rbp
  801b7c:	48 89 e5             	mov    %rsp,%rbp
  801b7f:	48 83 ec 20          	sub    $0x20,%rsp
  801b83:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b86:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b8a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b8d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b90:	48 63 c8             	movslq %eax,%rcx
  801b93:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b9a:	48 98                	cltq   
  801b9c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ba3:	00 
  801ba4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801baa:	49 89 c8             	mov    %rcx,%r8
  801bad:	48 89 d1             	mov    %rdx,%rcx
  801bb0:	48 89 c2             	mov    %rax,%rdx
  801bb3:	be 01 00 00 00       	mov    $0x1,%esi
  801bb8:	bf 04 00 00 00       	mov    $0x4,%edi
  801bbd:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801bc4:	00 00 00 
  801bc7:	ff d0                	callq  *%rax
}
  801bc9:	c9                   	leaveq 
  801bca:	c3                   	retq   

0000000000801bcb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801bcb:	55                   	push   %rbp
  801bcc:	48 89 e5             	mov    %rsp,%rbp
  801bcf:	48 83 ec 30          	sub    $0x30,%rsp
  801bd3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bd6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bda:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bdd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801be1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801be5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801be8:	48 63 c8             	movslq %eax,%rcx
  801beb:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bf2:	48 63 f0             	movslq %eax,%rsi
  801bf5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bfc:	48 98                	cltq   
  801bfe:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c02:	49 89 f9             	mov    %rdi,%r9
  801c05:	49 89 f0             	mov    %rsi,%r8
  801c08:	48 89 d1             	mov    %rdx,%rcx
  801c0b:	48 89 c2             	mov    %rax,%rdx
  801c0e:	be 01 00 00 00       	mov    $0x1,%esi
  801c13:	bf 05 00 00 00       	mov    $0x5,%edi
  801c18:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801c1f:	00 00 00 
  801c22:	ff d0                	callq  *%rax
}
  801c24:	c9                   	leaveq 
  801c25:	c3                   	retq   

0000000000801c26 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c26:	55                   	push   %rbp
  801c27:	48 89 e5             	mov    %rsp,%rbp
  801c2a:	48 83 ec 20          	sub    $0x20,%rsp
  801c2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c3c:	48 98                	cltq   
  801c3e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c45:	00 
  801c46:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c4c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c52:	48 89 d1             	mov    %rdx,%rcx
  801c55:	48 89 c2             	mov    %rax,%rdx
  801c58:	be 01 00 00 00       	mov    $0x1,%esi
  801c5d:	bf 06 00 00 00       	mov    $0x6,%edi
  801c62:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801c69:	00 00 00 
  801c6c:	ff d0                	callq  *%rax
}
  801c6e:	c9                   	leaveq 
  801c6f:	c3                   	retq   

0000000000801c70 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c70:	55                   	push   %rbp
  801c71:	48 89 e5             	mov    %rsp,%rbp
  801c74:	48 83 ec 10          	sub    $0x10,%rsp
  801c78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c7b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c81:	48 63 d0             	movslq %eax,%rdx
  801c84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c87:	48 98                	cltq   
  801c89:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c90:	00 
  801c91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c9d:	48 89 d1             	mov    %rdx,%rcx
  801ca0:	48 89 c2             	mov    %rax,%rdx
  801ca3:	be 01 00 00 00       	mov    $0x1,%esi
  801ca8:	bf 08 00 00 00       	mov    $0x8,%edi
  801cad:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801cb4:	00 00 00 
  801cb7:	ff d0                	callq  *%rax
}
  801cb9:	c9                   	leaveq 
  801cba:	c3                   	retq   

0000000000801cbb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801cbb:	55                   	push   %rbp
  801cbc:	48 89 e5             	mov    %rsp,%rbp
  801cbf:	48 83 ec 20          	sub    $0x20,%rsp
  801cc3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801cca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd1:	48 98                	cltq   
  801cd3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cda:	00 
  801cdb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce7:	48 89 d1             	mov    %rdx,%rcx
  801cea:	48 89 c2             	mov    %rax,%rdx
  801ced:	be 01 00 00 00       	mov    $0x1,%esi
  801cf2:	bf 09 00 00 00       	mov    $0x9,%edi
  801cf7:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801cfe:	00 00 00 
  801d01:	ff d0                	callq  *%rax
}
  801d03:	c9                   	leaveq 
  801d04:	c3                   	retq   

0000000000801d05 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d05:	55                   	push   %rbp
  801d06:	48 89 e5             	mov    %rsp,%rbp
  801d09:	48 83 ec 20          	sub    $0x20,%rsp
  801d0d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1b:	48 98                	cltq   
  801d1d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d24:	00 
  801d25:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d31:	48 89 d1             	mov    %rdx,%rcx
  801d34:	48 89 c2             	mov    %rax,%rdx
  801d37:	be 01 00 00 00       	mov    $0x1,%esi
  801d3c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d41:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801d48:	00 00 00 
  801d4b:	ff d0                	callq  *%rax
}
  801d4d:	c9                   	leaveq 
  801d4e:	c3                   	retq   

0000000000801d4f <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801d4f:	55                   	push   %rbp
  801d50:	48 89 e5             	mov    %rsp,%rbp
  801d53:	48 83 ec 10          	sub    $0x10,%rsp
  801d57:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d5a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801d5d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d60:	48 63 d0             	movslq %eax,%rdx
  801d63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d66:	48 98                	cltq   
  801d68:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d6f:	00 
  801d70:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d76:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d7c:	48 89 d1             	mov    %rdx,%rcx
  801d7f:	48 89 c2             	mov    %rax,%rdx
  801d82:	be 01 00 00 00       	mov    $0x1,%esi
  801d87:	bf 11 00 00 00       	mov    $0x11,%edi
  801d8c:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801d93:	00 00 00 
  801d96:	ff d0                	callq  *%rax

}
  801d98:	c9                   	leaveq 
  801d99:	c3                   	retq   

0000000000801d9a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d9a:	55                   	push   %rbp
  801d9b:	48 89 e5             	mov    %rsp,%rbp
  801d9e:	48 83 ec 20          	sub    $0x20,%rsp
  801da2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801da5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801da9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801dad:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801db0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801db3:	48 63 f0             	movslq %eax,%rsi
  801db6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801dba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dbd:	48 98                	cltq   
  801dbf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dca:	00 
  801dcb:	49 89 f1             	mov    %rsi,%r9
  801dce:	49 89 c8             	mov    %rcx,%r8
  801dd1:	48 89 d1             	mov    %rdx,%rcx
  801dd4:	48 89 c2             	mov    %rax,%rdx
  801dd7:	be 00 00 00 00       	mov    $0x0,%esi
  801ddc:	bf 0c 00 00 00       	mov    $0xc,%edi
  801de1:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801de8:	00 00 00 
  801deb:	ff d0                	callq  *%rax
}
  801ded:	c9                   	leaveq 
  801dee:	c3                   	retq   

0000000000801def <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801def:	55                   	push   %rbp
  801df0:	48 89 e5             	mov    %rsp,%rbp
  801df3:	48 83 ec 10          	sub    $0x10,%rsp
  801df7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801dfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e06:	00 
  801e07:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e0d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e13:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e18:	48 89 c2             	mov    %rax,%rdx
  801e1b:	be 01 00 00 00       	mov    $0x1,%esi
  801e20:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e25:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801e2c:	00 00 00 
  801e2f:	ff d0                	callq  *%rax
}
  801e31:	c9                   	leaveq 
  801e32:	c3                   	retq   

0000000000801e33 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801e33:	55                   	push   %rbp
  801e34:	48 89 e5             	mov    %rsp,%rbp
  801e37:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e42:	00 
  801e43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e4f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e54:	ba 00 00 00 00       	mov    $0x0,%edx
  801e59:	be 00 00 00 00       	mov    $0x0,%esi
  801e5e:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e63:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801e6a:	00 00 00 
  801e6d:	ff d0                	callq  *%rax
}
  801e6f:	c9                   	leaveq 
  801e70:	c3                   	retq   

0000000000801e71 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801e71:	55                   	push   %rbp
  801e72:	48 89 e5             	mov    %rsp,%rbp
  801e75:	48 83 ec 30          	sub    $0x30,%rsp
  801e79:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e7c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e80:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e83:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e87:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e8b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e8e:	48 63 c8             	movslq %eax,%rcx
  801e91:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e98:	48 63 f0             	movslq %eax,%rsi
  801e9b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ea2:	48 98                	cltq   
  801ea4:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ea8:	49 89 f9             	mov    %rdi,%r9
  801eab:	49 89 f0             	mov    %rsi,%r8
  801eae:	48 89 d1             	mov    %rdx,%rcx
  801eb1:	48 89 c2             	mov    %rax,%rdx
  801eb4:	be 00 00 00 00       	mov    $0x0,%esi
  801eb9:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ebe:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801ec5:	00 00 00 
  801ec8:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801eca:	c9                   	leaveq 
  801ecb:	c3                   	retq   

0000000000801ecc <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801ecc:	55                   	push   %rbp
  801ecd:	48 89 e5             	mov    %rsp,%rbp
  801ed0:	48 83 ec 20          	sub    $0x20,%rsp
  801ed4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ed8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801edc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ee0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eeb:	00 
  801eec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ef2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ef8:	48 89 d1             	mov    %rdx,%rcx
  801efb:	48 89 c2             	mov    %rax,%rdx
  801efe:	be 00 00 00 00       	mov    $0x0,%esi
  801f03:	bf 10 00 00 00       	mov    $0x10,%edi
  801f08:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  801f0f:	00 00 00 
  801f12:	ff d0                	callq  *%rax
}
  801f14:	c9                   	leaveq 
  801f15:	c3                   	retq   

0000000000801f16 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801f16:	55                   	push   %rbp
  801f17:	48 89 e5             	mov    %rsp,%rbp
  801f1a:	48 83 ec 08          	sub    $0x8,%rsp
  801f1e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f22:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f26:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801f2d:	ff ff ff 
  801f30:	48 01 d0             	add    %rdx,%rax
  801f33:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801f37:	c9                   	leaveq 
  801f38:	c3                   	retq   

0000000000801f39 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f39:	55                   	push   %rbp
  801f3a:	48 89 e5             	mov    %rsp,%rbp
  801f3d:	48 83 ec 08          	sub    $0x8,%rsp
  801f41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801f45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f49:	48 89 c7             	mov    %rax,%rdi
  801f4c:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  801f53:	00 00 00 
  801f56:	ff d0                	callq  *%rax
  801f58:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801f5e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801f62:	c9                   	leaveq 
  801f63:	c3                   	retq   

0000000000801f64 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f64:	55                   	push   %rbp
  801f65:	48 89 e5             	mov    %rsp,%rbp
  801f68:	48 83 ec 18          	sub    $0x18,%rsp
  801f6c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f77:	eb 6b                	jmp    801fe4 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f7c:	48 98                	cltq   
  801f7e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f84:	48 c1 e0 0c          	shl    $0xc,%rax
  801f88:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f90:	48 c1 e8 15          	shr    $0x15,%rax
  801f94:	48 89 c2             	mov    %rax,%rdx
  801f97:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f9e:	01 00 00 
  801fa1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fa5:	83 e0 01             	and    $0x1,%eax
  801fa8:	48 85 c0             	test   %rax,%rax
  801fab:	74 21                	je     801fce <fd_alloc+0x6a>
  801fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb1:	48 c1 e8 0c          	shr    $0xc,%rax
  801fb5:	48 89 c2             	mov    %rax,%rdx
  801fb8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fbf:	01 00 00 
  801fc2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fc6:	83 e0 01             	and    $0x1,%eax
  801fc9:	48 85 c0             	test   %rax,%rax
  801fcc:	75 12                	jne    801fe0 <fd_alloc+0x7c>
			*fd_store = fd;
  801fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fd6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fde:	eb 1a                	jmp    801ffa <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801fe0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fe4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fe8:	7e 8f                	jle    801f79 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801fea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fee:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ff5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ffa:	c9                   	leaveq 
  801ffb:	c3                   	retq   

0000000000801ffc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ffc:	55                   	push   %rbp
  801ffd:	48 89 e5             	mov    %rsp,%rbp
  802000:	48 83 ec 20          	sub    $0x20,%rsp
  802004:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802007:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80200b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80200f:	78 06                	js     802017 <fd_lookup+0x1b>
  802011:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802015:	7e 07                	jle    80201e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802017:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80201c:	eb 6c                	jmp    80208a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80201e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802021:	48 98                	cltq   
  802023:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802029:	48 c1 e0 0c          	shl    $0xc,%rax
  80202d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802031:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802035:	48 c1 e8 15          	shr    $0x15,%rax
  802039:	48 89 c2             	mov    %rax,%rdx
  80203c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802043:	01 00 00 
  802046:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80204a:	83 e0 01             	and    $0x1,%eax
  80204d:	48 85 c0             	test   %rax,%rax
  802050:	74 21                	je     802073 <fd_lookup+0x77>
  802052:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802056:	48 c1 e8 0c          	shr    $0xc,%rax
  80205a:	48 89 c2             	mov    %rax,%rdx
  80205d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802064:	01 00 00 
  802067:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80206b:	83 e0 01             	and    $0x1,%eax
  80206e:	48 85 c0             	test   %rax,%rax
  802071:	75 07                	jne    80207a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802073:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802078:	eb 10                	jmp    80208a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80207a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80207e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802082:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802085:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80208a:	c9                   	leaveq 
  80208b:	c3                   	retq   

000000000080208c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80208c:	55                   	push   %rbp
  80208d:	48 89 e5             	mov    %rsp,%rbp
  802090:	48 83 ec 30          	sub    $0x30,%rsp
  802094:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802098:	89 f0                	mov    %esi,%eax
  80209a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80209d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a1:	48 89 c7             	mov    %rax,%rdi
  8020a4:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  8020ab:	00 00 00 
  8020ae:	ff d0                	callq  *%rax
  8020b0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020b4:	48 89 d6             	mov    %rdx,%rsi
  8020b7:	89 c7                	mov    %eax,%edi
  8020b9:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  8020c0:	00 00 00 
  8020c3:	ff d0                	callq  *%rax
  8020c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020cc:	78 0a                	js     8020d8 <fd_close+0x4c>
	    || fd != fd2)
  8020ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d2:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8020d6:	74 12                	je     8020ea <fd_close+0x5e>
		return (must_exist ? r : 0);
  8020d8:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8020dc:	74 05                	je     8020e3 <fd_close+0x57>
  8020de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e1:	eb 05                	jmp    8020e8 <fd_close+0x5c>
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e8:	eb 69                	jmp    802153 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8020ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ee:	8b 00                	mov    (%rax),%eax
  8020f0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020f4:	48 89 d6             	mov    %rdx,%rsi
  8020f7:	89 c7                	mov    %eax,%edi
  8020f9:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  802100:	00 00 00 
  802103:	ff d0                	callq  *%rax
  802105:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802108:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80210c:	78 2a                	js     802138 <fd_close+0xac>
		if (dev->dev_close)
  80210e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802112:	48 8b 40 20          	mov    0x20(%rax),%rax
  802116:	48 85 c0             	test   %rax,%rax
  802119:	74 16                	je     802131 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80211b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80211f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802123:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802127:	48 89 d7             	mov    %rdx,%rdi
  80212a:	ff d0                	callq  *%rax
  80212c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80212f:	eb 07                	jmp    802138 <fd_close+0xac>
		else
			r = 0;
  802131:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802138:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80213c:	48 89 c6             	mov    %rax,%rsi
  80213f:	bf 00 00 00 00       	mov    $0x0,%edi
  802144:	48 b8 26 1c 80 00 00 	movabs $0x801c26,%rax
  80214b:	00 00 00 
  80214e:	ff d0                	callq  *%rax
	return r;
  802150:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802153:	c9                   	leaveq 
  802154:	c3                   	retq   

0000000000802155 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802155:	55                   	push   %rbp
  802156:	48 89 e5             	mov    %rsp,%rbp
  802159:	48 83 ec 20          	sub    $0x20,%rsp
  80215d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802160:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802164:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80216b:	eb 41                	jmp    8021ae <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80216d:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802174:	00 00 00 
  802177:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80217a:	48 63 d2             	movslq %edx,%rdx
  80217d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802181:	8b 00                	mov    (%rax),%eax
  802183:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802186:	75 22                	jne    8021aa <dev_lookup+0x55>
			*dev = devtab[i];
  802188:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80218f:	00 00 00 
  802192:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802195:	48 63 d2             	movslq %edx,%rdx
  802198:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80219c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021a0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8021a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a8:	eb 60                	jmp    80220a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8021aa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021ae:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8021b5:	00 00 00 
  8021b8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021bb:	48 63 d2             	movslq %edx,%rdx
  8021be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c2:	48 85 c0             	test   %rax,%rax
  8021c5:	75 a6                	jne    80216d <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8021c7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8021ce:	00 00 00 
  8021d1:	48 8b 00             	mov    (%rax),%rax
  8021d4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021da:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021dd:	89 c6                	mov    %eax,%esi
  8021df:	48 bf d8 3f 80 00 00 	movabs $0x803fd8,%rdi
  8021e6:	00 00 00 
  8021e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ee:	48 b9 56 06 80 00 00 	movabs $0x800656,%rcx
  8021f5:	00 00 00 
  8021f8:	ff d1                	callq  *%rcx
	*dev = 0;
  8021fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021fe:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802205:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80220a:	c9                   	leaveq 
  80220b:	c3                   	retq   

000000000080220c <close>:

int
close(int fdnum)
{
  80220c:	55                   	push   %rbp
  80220d:	48 89 e5             	mov    %rsp,%rbp
  802210:	48 83 ec 20          	sub    $0x20,%rsp
  802214:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802217:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80221b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80221e:	48 89 d6             	mov    %rdx,%rsi
  802221:	89 c7                	mov    %eax,%edi
  802223:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  80222a:	00 00 00 
  80222d:	ff d0                	callq  *%rax
  80222f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802232:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802236:	79 05                	jns    80223d <close+0x31>
		return r;
  802238:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80223b:	eb 18                	jmp    802255 <close+0x49>
	else
		return fd_close(fd, 1);
  80223d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802241:	be 01 00 00 00       	mov    $0x1,%esi
  802246:	48 89 c7             	mov    %rax,%rdi
  802249:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  802250:	00 00 00 
  802253:	ff d0                	callq  *%rax
}
  802255:	c9                   	leaveq 
  802256:	c3                   	retq   

0000000000802257 <close_all>:

void
close_all(void)
{
  802257:	55                   	push   %rbp
  802258:	48 89 e5             	mov    %rsp,%rbp
  80225b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80225f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802266:	eb 15                	jmp    80227d <close_all+0x26>
		close(i);
  802268:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80226b:	89 c7                	mov    %eax,%edi
  80226d:	48 b8 0c 22 80 00 00 	movabs $0x80220c,%rax
  802274:	00 00 00 
  802277:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802279:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80227d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802281:	7e e5                	jle    802268 <close_all+0x11>
		close(i);
}
  802283:	c9                   	leaveq 
  802284:	c3                   	retq   

0000000000802285 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802285:	55                   	push   %rbp
  802286:	48 89 e5             	mov    %rsp,%rbp
  802289:	48 83 ec 40          	sub    $0x40,%rsp
  80228d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802290:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802293:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802297:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80229a:	48 89 d6             	mov    %rdx,%rsi
  80229d:	89 c7                	mov    %eax,%edi
  80229f:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  8022a6:	00 00 00 
  8022a9:	ff d0                	callq  *%rax
  8022ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b2:	79 08                	jns    8022bc <dup+0x37>
		return r;
  8022b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b7:	e9 70 01 00 00       	jmpq   80242c <dup+0x1a7>
	close(newfdnum);
  8022bc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022bf:	89 c7                	mov    %eax,%edi
  8022c1:	48 b8 0c 22 80 00 00 	movabs $0x80220c,%rax
  8022c8:	00 00 00 
  8022cb:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8022cd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022d0:	48 98                	cltq   
  8022d2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022d8:	48 c1 e0 0c          	shl    $0xc,%rax
  8022dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8022e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022e4:	48 89 c7             	mov    %rax,%rdi
  8022e7:	48 b8 39 1f 80 00 00 	movabs $0x801f39,%rax
  8022ee:	00 00 00 
  8022f1:	ff d0                	callq  *%rax
  8022f3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8022f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022fb:	48 89 c7             	mov    %rax,%rdi
  8022fe:	48 b8 39 1f 80 00 00 	movabs $0x801f39,%rax
  802305:	00 00 00 
  802308:	ff d0                	callq  *%rax
  80230a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80230e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802312:	48 c1 e8 15          	shr    $0x15,%rax
  802316:	48 89 c2             	mov    %rax,%rdx
  802319:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802320:	01 00 00 
  802323:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802327:	83 e0 01             	and    $0x1,%eax
  80232a:	48 85 c0             	test   %rax,%rax
  80232d:	74 73                	je     8023a2 <dup+0x11d>
  80232f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802333:	48 c1 e8 0c          	shr    $0xc,%rax
  802337:	48 89 c2             	mov    %rax,%rdx
  80233a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802341:	01 00 00 
  802344:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802348:	83 e0 01             	and    $0x1,%eax
  80234b:	48 85 c0             	test   %rax,%rax
  80234e:	74 52                	je     8023a2 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802350:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802354:	48 c1 e8 0c          	shr    $0xc,%rax
  802358:	48 89 c2             	mov    %rax,%rdx
  80235b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802362:	01 00 00 
  802365:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802369:	25 07 0e 00 00       	and    $0xe07,%eax
  80236e:	89 c1                	mov    %eax,%ecx
  802370:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802378:	41 89 c8             	mov    %ecx,%r8d
  80237b:	48 89 d1             	mov    %rdx,%rcx
  80237e:	ba 00 00 00 00       	mov    $0x0,%edx
  802383:	48 89 c6             	mov    %rax,%rsi
  802386:	bf 00 00 00 00       	mov    $0x0,%edi
  80238b:	48 b8 cb 1b 80 00 00 	movabs $0x801bcb,%rax
  802392:	00 00 00 
  802395:	ff d0                	callq  *%rax
  802397:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80239a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80239e:	79 02                	jns    8023a2 <dup+0x11d>
			goto err;
  8023a0:	eb 57                	jmp    8023f9 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8023a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023a6:	48 c1 e8 0c          	shr    $0xc,%rax
  8023aa:	48 89 c2             	mov    %rax,%rdx
  8023ad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023b4:	01 00 00 
  8023b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8023c0:	89 c1                	mov    %eax,%ecx
  8023c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023ca:	41 89 c8             	mov    %ecx,%r8d
  8023cd:	48 89 d1             	mov    %rdx,%rcx
  8023d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8023d5:	48 89 c6             	mov    %rax,%rsi
  8023d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8023dd:	48 b8 cb 1b 80 00 00 	movabs $0x801bcb,%rax
  8023e4:	00 00 00 
  8023e7:	ff d0                	callq  *%rax
  8023e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f0:	79 02                	jns    8023f4 <dup+0x16f>
		goto err;
  8023f2:	eb 05                	jmp    8023f9 <dup+0x174>

	return newfdnum;
  8023f4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023f7:	eb 33                	jmp    80242c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8023f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023fd:	48 89 c6             	mov    %rax,%rsi
  802400:	bf 00 00 00 00       	mov    $0x0,%edi
  802405:	48 b8 26 1c 80 00 00 	movabs $0x801c26,%rax
  80240c:	00 00 00 
  80240f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802411:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802415:	48 89 c6             	mov    %rax,%rsi
  802418:	bf 00 00 00 00       	mov    $0x0,%edi
  80241d:	48 b8 26 1c 80 00 00 	movabs $0x801c26,%rax
  802424:	00 00 00 
  802427:	ff d0                	callq  *%rax
	return r;
  802429:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80242c:	c9                   	leaveq 
  80242d:	c3                   	retq   

000000000080242e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80242e:	55                   	push   %rbp
  80242f:	48 89 e5             	mov    %rsp,%rbp
  802432:	48 83 ec 40          	sub    $0x40,%rsp
  802436:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802439:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80243d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802441:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802445:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802448:	48 89 d6             	mov    %rdx,%rsi
  80244b:	89 c7                	mov    %eax,%edi
  80244d:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  802454:	00 00 00 
  802457:	ff d0                	callq  *%rax
  802459:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80245c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802460:	78 24                	js     802486 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802466:	8b 00                	mov    (%rax),%eax
  802468:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80246c:	48 89 d6             	mov    %rdx,%rsi
  80246f:	89 c7                	mov    %eax,%edi
  802471:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  802478:	00 00 00 
  80247b:	ff d0                	callq  *%rax
  80247d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802480:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802484:	79 05                	jns    80248b <read+0x5d>
		return r;
  802486:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802489:	eb 76                	jmp    802501 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80248b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80248f:	8b 40 08             	mov    0x8(%rax),%eax
  802492:	83 e0 03             	and    $0x3,%eax
  802495:	83 f8 01             	cmp    $0x1,%eax
  802498:	75 3a                	jne    8024d4 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80249a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8024a1:	00 00 00 
  8024a4:	48 8b 00             	mov    (%rax),%rax
  8024a7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024ad:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024b0:	89 c6                	mov    %eax,%esi
  8024b2:	48 bf f7 3f 80 00 00 	movabs $0x803ff7,%rdi
  8024b9:	00 00 00 
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c1:	48 b9 56 06 80 00 00 	movabs $0x800656,%rcx
  8024c8:	00 00 00 
  8024cb:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024d2:	eb 2d                	jmp    802501 <read+0xd3>
	}
	if (!dev->dev_read)
  8024d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024dc:	48 85 c0             	test   %rax,%rax
  8024df:	75 07                	jne    8024e8 <read+0xba>
		return -E_NOT_SUPP;
  8024e1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024e6:	eb 19                	jmp    802501 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8024e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ec:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024f0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024f4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024f8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024fc:	48 89 cf             	mov    %rcx,%rdi
  8024ff:	ff d0                	callq  *%rax
}
  802501:	c9                   	leaveq 
  802502:	c3                   	retq   

0000000000802503 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802503:	55                   	push   %rbp
  802504:	48 89 e5             	mov    %rsp,%rbp
  802507:	48 83 ec 30          	sub    $0x30,%rsp
  80250b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80250e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802512:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802516:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80251d:	eb 49                	jmp    802568 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80251f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802522:	48 98                	cltq   
  802524:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802528:	48 29 c2             	sub    %rax,%rdx
  80252b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252e:	48 63 c8             	movslq %eax,%rcx
  802531:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802535:	48 01 c1             	add    %rax,%rcx
  802538:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80253b:	48 89 ce             	mov    %rcx,%rsi
  80253e:	89 c7                	mov    %eax,%edi
  802540:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  802547:	00 00 00 
  80254a:	ff d0                	callq  *%rax
  80254c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80254f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802553:	79 05                	jns    80255a <readn+0x57>
			return m;
  802555:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802558:	eb 1c                	jmp    802576 <readn+0x73>
		if (m == 0)
  80255a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80255e:	75 02                	jne    802562 <readn+0x5f>
			break;
  802560:	eb 11                	jmp    802573 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802562:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802565:	01 45 fc             	add    %eax,-0x4(%rbp)
  802568:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256b:	48 98                	cltq   
  80256d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802571:	72 ac                	jb     80251f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802573:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802576:	c9                   	leaveq 
  802577:	c3                   	retq   

0000000000802578 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802578:	55                   	push   %rbp
  802579:	48 89 e5             	mov    %rsp,%rbp
  80257c:	48 83 ec 40          	sub    $0x40,%rsp
  802580:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802583:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802587:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80258b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80258f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802592:	48 89 d6             	mov    %rdx,%rsi
  802595:	89 c7                	mov    %eax,%edi
  802597:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  80259e:	00 00 00 
  8025a1:	ff d0                	callq  *%rax
  8025a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025aa:	78 24                	js     8025d0 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b0:	8b 00                	mov    (%rax),%eax
  8025b2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025b6:	48 89 d6             	mov    %rdx,%rsi
  8025b9:	89 c7                	mov    %eax,%edi
  8025bb:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  8025c2:	00 00 00 
  8025c5:	ff d0                	callq  *%rax
  8025c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ce:	79 05                	jns    8025d5 <write+0x5d>
		return r;
  8025d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d3:	eb 75                	jmp    80264a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d9:	8b 40 08             	mov    0x8(%rax),%eax
  8025dc:	83 e0 03             	and    $0x3,%eax
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	75 3a                	jne    80261d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8025e3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8025ea:	00 00 00 
  8025ed:	48 8b 00             	mov    (%rax),%rax
  8025f0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025f6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025f9:	89 c6                	mov    %eax,%esi
  8025fb:	48 bf 13 40 80 00 00 	movabs $0x804013,%rdi
  802602:	00 00 00 
  802605:	b8 00 00 00 00       	mov    $0x0,%eax
  80260a:	48 b9 56 06 80 00 00 	movabs $0x800656,%rcx
  802611:	00 00 00 
  802614:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802616:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80261b:	eb 2d                	jmp    80264a <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80261d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802621:	48 8b 40 18          	mov    0x18(%rax),%rax
  802625:	48 85 c0             	test   %rax,%rax
  802628:	75 07                	jne    802631 <write+0xb9>
		return -E_NOT_SUPP;
  80262a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80262f:	eb 19                	jmp    80264a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802635:	48 8b 40 18          	mov    0x18(%rax),%rax
  802639:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80263d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802641:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802645:	48 89 cf             	mov    %rcx,%rdi
  802648:	ff d0                	callq  *%rax
}
  80264a:	c9                   	leaveq 
  80264b:	c3                   	retq   

000000000080264c <seek>:

int
seek(int fdnum, off_t offset)
{
  80264c:	55                   	push   %rbp
  80264d:	48 89 e5             	mov    %rsp,%rbp
  802650:	48 83 ec 18          	sub    $0x18,%rsp
  802654:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802657:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80265a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80265e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802661:	48 89 d6             	mov    %rdx,%rsi
  802664:	89 c7                	mov    %eax,%edi
  802666:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  80266d:	00 00 00 
  802670:	ff d0                	callq  *%rax
  802672:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802675:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802679:	79 05                	jns    802680 <seek+0x34>
		return r;
  80267b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267e:	eb 0f                	jmp    80268f <seek+0x43>
	fd->fd_offset = offset;
  802680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802684:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802687:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80268a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80268f:	c9                   	leaveq 
  802690:	c3                   	retq   

0000000000802691 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802691:	55                   	push   %rbp
  802692:	48 89 e5             	mov    %rsp,%rbp
  802695:	48 83 ec 30          	sub    $0x30,%rsp
  802699:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80269c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80269f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026a3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026a6:	48 89 d6             	mov    %rdx,%rsi
  8026a9:	89 c7                	mov    %eax,%edi
  8026ab:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	callq  *%rax
  8026b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026be:	78 24                	js     8026e4 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c4:	8b 00                	mov    (%rax),%eax
  8026c6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026ca:	48 89 d6             	mov    %rdx,%rsi
  8026cd:	89 c7                	mov    %eax,%edi
  8026cf:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  8026d6:	00 00 00 
  8026d9:	ff d0                	callq  *%rax
  8026db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026e2:	79 05                	jns    8026e9 <ftruncate+0x58>
		return r;
  8026e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e7:	eb 72                	jmp    80275b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ed:	8b 40 08             	mov    0x8(%rax),%eax
  8026f0:	83 e0 03             	and    $0x3,%eax
  8026f3:	85 c0                	test   %eax,%eax
  8026f5:	75 3a                	jne    802731 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8026f7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8026fe:	00 00 00 
  802701:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802704:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80270a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80270d:	89 c6                	mov    %eax,%esi
  80270f:	48 bf 30 40 80 00 00 	movabs $0x804030,%rdi
  802716:	00 00 00 
  802719:	b8 00 00 00 00       	mov    $0x0,%eax
  80271e:	48 b9 56 06 80 00 00 	movabs $0x800656,%rcx
  802725:	00 00 00 
  802728:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80272a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80272f:	eb 2a                	jmp    80275b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802731:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802735:	48 8b 40 30          	mov    0x30(%rax),%rax
  802739:	48 85 c0             	test   %rax,%rax
  80273c:	75 07                	jne    802745 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80273e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802743:	eb 16                	jmp    80275b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802749:	48 8b 40 30          	mov    0x30(%rax),%rax
  80274d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802751:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802754:	89 ce                	mov    %ecx,%esi
  802756:	48 89 d7             	mov    %rdx,%rdi
  802759:	ff d0                	callq  *%rax
}
  80275b:	c9                   	leaveq 
  80275c:	c3                   	retq   

000000000080275d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80275d:	55                   	push   %rbp
  80275e:	48 89 e5             	mov    %rsp,%rbp
  802761:	48 83 ec 30          	sub    $0x30,%rsp
  802765:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802768:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80276c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802770:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802773:	48 89 d6             	mov    %rdx,%rsi
  802776:	89 c7                	mov    %eax,%edi
  802778:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  80277f:	00 00 00 
  802782:	ff d0                	callq  *%rax
  802784:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802787:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278b:	78 24                	js     8027b1 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80278d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802791:	8b 00                	mov    (%rax),%eax
  802793:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802797:	48 89 d6             	mov    %rdx,%rsi
  80279a:	89 c7                	mov    %eax,%edi
  80279c:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  8027a3:	00 00 00 
  8027a6:	ff d0                	callq  *%rax
  8027a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027af:	79 05                	jns    8027b6 <fstat+0x59>
		return r;
  8027b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b4:	eb 5e                	jmp    802814 <fstat+0xb7>
	if (!dev->dev_stat)
  8027b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ba:	48 8b 40 28          	mov    0x28(%rax),%rax
  8027be:	48 85 c0             	test   %rax,%rax
  8027c1:	75 07                	jne    8027ca <fstat+0x6d>
		return -E_NOT_SUPP;
  8027c3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027c8:	eb 4a                	jmp    802814 <fstat+0xb7>
	stat->st_name[0] = 0;
  8027ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027ce:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8027d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027d5:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8027dc:	00 00 00 
	stat->st_isdir = 0;
  8027df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027e3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8027ea:	00 00 00 
	stat->st_dev = dev;
  8027ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027f5:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8027fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802800:	48 8b 40 28          	mov    0x28(%rax),%rax
  802804:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802808:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80280c:	48 89 ce             	mov    %rcx,%rsi
  80280f:	48 89 d7             	mov    %rdx,%rdi
  802812:	ff d0                	callq  *%rax
}
  802814:	c9                   	leaveq 
  802815:	c3                   	retq   

0000000000802816 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802816:	55                   	push   %rbp
  802817:	48 89 e5             	mov    %rsp,%rbp
  80281a:	48 83 ec 20          	sub    $0x20,%rsp
  80281e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802822:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282a:	be 00 00 00 00       	mov    $0x0,%esi
  80282f:	48 89 c7             	mov    %rax,%rdi
  802832:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802839:	00 00 00 
  80283c:	ff d0                	callq  *%rax
  80283e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802841:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802845:	79 05                	jns    80284c <stat+0x36>
		return fd;
  802847:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284a:	eb 2f                	jmp    80287b <stat+0x65>
	r = fstat(fd, stat);
  80284c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802850:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802853:	48 89 d6             	mov    %rdx,%rsi
  802856:	89 c7                	mov    %eax,%edi
  802858:	48 b8 5d 27 80 00 00 	movabs $0x80275d,%rax
  80285f:	00 00 00 
  802862:	ff d0                	callq  *%rax
  802864:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802867:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80286a:	89 c7                	mov    %eax,%edi
  80286c:	48 b8 0c 22 80 00 00 	movabs $0x80220c,%rax
  802873:	00 00 00 
  802876:	ff d0                	callq  *%rax
	return r;
  802878:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80287b:	c9                   	leaveq 
  80287c:	c3                   	retq   

000000000080287d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80287d:	55                   	push   %rbp
  80287e:	48 89 e5             	mov    %rsp,%rbp
  802881:	48 83 ec 10          	sub    $0x10,%rsp
  802885:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802888:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80288c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802893:	00 00 00 
  802896:	8b 00                	mov    (%rax),%eax
  802898:	85 c0                	test   %eax,%eax
  80289a:	75 1d                	jne    8028b9 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80289c:	bf 01 00 00 00       	mov    $0x1,%edi
  8028a1:	48 b8 a8 38 80 00 00 	movabs $0x8038a8,%rax
  8028a8:	00 00 00 
  8028ab:	ff d0                	callq  *%rax
  8028ad:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8028b4:	00 00 00 
  8028b7:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8028b9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8028c0:	00 00 00 
  8028c3:	8b 00                	mov    (%rax),%eax
  8028c5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8028c8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8028cd:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8028d4:	00 00 00 
  8028d7:	89 c7                	mov    %eax,%edi
  8028d9:	48 b8 a9 37 80 00 00 	movabs $0x8037a9,%rax
  8028e0:	00 00 00 
  8028e3:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8028e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ee:	48 89 c6             	mov    %rax,%rsi
  8028f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8028f6:	48 b8 f6 36 80 00 00 	movabs $0x8036f6,%rax
  8028fd:	00 00 00 
  802900:	ff d0                	callq  *%rax
}
  802902:	c9                   	leaveq 
  802903:	c3                   	retq   

0000000000802904 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802904:	55                   	push   %rbp
  802905:	48 89 e5             	mov    %rsp,%rbp
  802908:	48 83 ec 20          	sub    $0x20,%rsp
  80290c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802910:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  802913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802917:	48 89 c7             	mov    %rax,%rdi
  80291a:	48 b8 e0 11 80 00 00 	movabs $0x8011e0,%rax
  802921:	00 00 00 
  802924:	ff d0                	callq  *%rax
  802926:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80292b:	7e 0a                	jle    802937 <open+0x33>
		return -E_BAD_PATH;
  80292d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802932:	e9 a5 00 00 00       	jmpq   8029dc <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  802937:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80293b:	48 89 c7             	mov    %rax,%rdi
  80293e:	48 b8 64 1f 80 00 00 	movabs $0x801f64,%rax
  802945:	00 00 00 
  802948:	ff d0                	callq  *%rax
  80294a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802951:	79 08                	jns    80295b <open+0x57>
		return ret;
  802953:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802956:	e9 81 00 00 00       	jmpq   8029dc <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  80295b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802962:	00 00 00 
  802965:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802968:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  80296e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802972:	48 89 c6             	mov    %rax,%rsi
  802975:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80297c:	00 00 00 
  80297f:	48 b8 4c 12 80 00 00 	movabs $0x80124c,%rax
  802986:	00 00 00 
  802989:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  80298b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80298f:	48 89 c6             	mov    %rax,%rsi
  802992:	bf 01 00 00 00       	mov    $0x1,%edi
  802997:	48 b8 7d 28 80 00 00 	movabs $0x80287d,%rax
  80299e:	00 00 00 
  8029a1:	ff d0                	callq  *%rax
  8029a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029aa:	79 1d                	jns    8029c9 <open+0xc5>
	{
		fd_close(fd,0);
  8029ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b0:	be 00 00 00 00       	mov    $0x0,%esi
  8029b5:	48 89 c7             	mov    %rax,%rdi
  8029b8:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  8029bf:	00 00 00 
  8029c2:	ff d0                	callq  *%rax
		return ret;
  8029c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c7:	eb 13                	jmp    8029dc <open+0xd8>
	}
	return fd2num (fd);
  8029c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029cd:	48 89 c7             	mov    %rax,%rdi
  8029d0:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  8029d7:	00 00 00 
  8029da:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  8029dc:	c9                   	leaveq 
  8029dd:	c3                   	retq   

00000000008029de <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8029de:	55                   	push   %rbp
  8029df:	48 89 e5             	mov    %rsp,%rbp
  8029e2:	48 83 ec 10          	sub    $0x10,%rsp
  8029e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8029ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029ee:	8b 50 0c             	mov    0xc(%rax),%edx
  8029f1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029f8:	00 00 00 
  8029fb:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8029fd:	be 00 00 00 00       	mov    $0x0,%esi
  802a02:	bf 06 00 00 00       	mov    $0x6,%edi
  802a07:	48 b8 7d 28 80 00 00 	movabs $0x80287d,%rax
  802a0e:	00 00 00 
  802a11:	ff d0                	callq  *%rax
}
  802a13:	c9                   	leaveq 
  802a14:	c3                   	retq   

0000000000802a15 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802a15:	55                   	push   %rbp
  802a16:	48 89 e5             	mov    %rsp,%rbp
  802a19:	48 83 ec 30          	sub    $0x30,%rsp
  802a1d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a21:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a25:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  802a29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a2d:	8b 50 0c             	mov    0xc(%rax),%edx
  802a30:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a37:	00 00 00 
  802a3a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  802a3c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a43:	00 00 00 
  802a46:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a4a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  802a4e:	be 00 00 00 00       	mov    $0x0,%esi
  802a53:	bf 03 00 00 00       	mov    $0x3,%edi
  802a58:	48 b8 7d 28 80 00 00 	movabs $0x80287d,%rax
  802a5f:	00 00 00 
  802a62:	ff d0                	callq  *%rax
  802a64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6b:	79 05                	jns    802a72 <devfile_read+0x5d>
		return ret;
  802a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a70:	eb 26                	jmp    802a98 <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  802a72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a75:	48 63 d0             	movslq %eax,%rdx
  802a78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a7c:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802a83:	00 00 00 
  802a86:	48 89 c7             	mov    %rax,%rdi
  802a89:	48 b8 70 15 80 00 00 	movabs $0x801570,%rax
  802a90:	00 00 00 
  802a93:	ff d0                	callq  *%rax
	return ret;
  802a95:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  802a98:	c9                   	leaveq 
  802a99:	c3                   	retq   

0000000000802a9a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a9a:	55                   	push   %rbp
  802a9b:	48 89 e5             	mov    %rsp,%rbp
  802a9e:	48 83 ec 30          	sub    $0x30,%rsp
  802aa2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aa6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802aaa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  802aae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab2:	8b 50 0c             	mov    0xc(%rax),%edx
  802ab5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802abc:	00 00 00 
  802abf:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  802ac1:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  802ac6:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802acd:	00 
  802ace:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802ad3:	48 89 c2             	mov    %rax,%rdx
  802ad6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802add:	00 00 00 
  802ae0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  802ae4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aeb:	00 00 00 
  802aee:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802af2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802af6:	48 89 c6             	mov    %rax,%rsi
  802af9:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802b00:	00 00 00 
  802b03:	48 b8 70 15 80 00 00 	movabs $0x801570,%rax
  802b0a:	00 00 00 
  802b0d:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  802b0f:	be 00 00 00 00       	mov    $0x0,%esi
  802b14:	bf 04 00 00 00       	mov    $0x4,%edi
  802b19:	48 b8 7d 28 80 00 00 	movabs $0x80287d,%rax
  802b20:	00 00 00 
  802b23:	ff d0                	callq  *%rax
  802b25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b2c:	79 05                	jns    802b33 <devfile_write+0x99>
		return ret;
  802b2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b31:	eb 03                	jmp    802b36 <devfile_write+0x9c>
	
	return ret;
  802b33:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  802b36:	c9                   	leaveq 
  802b37:	c3                   	retq   

0000000000802b38 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b38:	55                   	push   %rbp
  802b39:	48 89 e5             	mov    %rsp,%rbp
  802b3c:	48 83 ec 20          	sub    $0x20,%rsp
  802b40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4c:	8b 50 0c             	mov    0xc(%rax),%edx
  802b4f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b56:	00 00 00 
  802b59:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b5b:	be 00 00 00 00       	mov    $0x0,%esi
  802b60:	bf 05 00 00 00       	mov    $0x5,%edi
  802b65:	48 b8 7d 28 80 00 00 	movabs $0x80287d,%rax
  802b6c:	00 00 00 
  802b6f:	ff d0                	callq  *%rax
  802b71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b78:	79 05                	jns    802b7f <devfile_stat+0x47>
		return r;
  802b7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7d:	eb 56                	jmp    802bd5 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b7f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b83:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802b8a:	00 00 00 
  802b8d:	48 89 c7             	mov    %rax,%rdi
  802b90:	48 b8 4c 12 80 00 00 	movabs $0x80124c,%rax
  802b97:	00 00 00 
  802b9a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b9c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ba3:	00 00 00 
  802ba6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802bac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bb0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802bb6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bbd:	00 00 00 
  802bc0:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802bc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bca:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802bd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bd5:	c9                   	leaveq 
  802bd6:	c3                   	retq   

0000000000802bd7 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802bd7:	55                   	push   %rbp
  802bd8:	48 89 e5             	mov    %rsp,%rbp
  802bdb:	48 83 ec 10          	sub    $0x10,%rsp
  802bdf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802be3:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802be6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bea:	8b 50 0c             	mov    0xc(%rax),%edx
  802bed:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bf4:	00 00 00 
  802bf7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802bf9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c00:	00 00 00 
  802c03:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c06:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c09:	be 00 00 00 00       	mov    $0x0,%esi
  802c0e:	bf 02 00 00 00       	mov    $0x2,%edi
  802c13:	48 b8 7d 28 80 00 00 	movabs $0x80287d,%rax
  802c1a:	00 00 00 
  802c1d:	ff d0                	callq  *%rax
}
  802c1f:	c9                   	leaveq 
  802c20:	c3                   	retq   

0000000000802c21 <remove>:

// Delete a file
int
remove(const char *path)
{
  802c21:	55                   	push   %rbp
  802c22:	48 89 e5             	mov    %rsp,%rbp
  802c25:	48 83 ec 10          	sub    $0x10,%rsp
  802c29:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c31:	48 89 c7             	mov    %rax,%rdi
  802c34:	48 b8 e0 11 80 00 00 	movabs $0x8011e0,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
  802c40:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c45:	7e 07                	jle    802c4e <remove+0x2d>
		return -E_BAD_PATH;
  802c47:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c4c:	eb 33                	jmp    802c81 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c52:	48 89 c6             	mov    %rax,%rsi
  802c55:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802c5c:	00 00 00 
  802c5f:	48 b8 4c 12 80 00 00 	movabs $0x80124c,%rax
  802c66:	00 00 00 
  802c69:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c6b:	be 00 00 00 00       	mov    $0x0,%esi
  802c70:	bf 07 00 00 00       	mov    $0x7,%edi
  802c75:	48 b8 7d 28 80 00 00 	movabs $0x80287d,%rax
  802c7c:	00 00 00 
  802c7f:	ff d0                	callq  *%rax
}
  802c81:	c9                   	leaveq 
  802c82:	c3                   	retq   

0000000000802c83 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c83:	55                   	push   %rbp
  802c84:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c87:	be 00 00 00 00       	mov    $0x0,%esi
  802c8c:	bf 08 00 00 00       	mov    $0x8,%edi
  802c91:	48 b8 7d 28 80 00 00 	movabs $0x80287d,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
}
  802c9d:	5d                   	pop    %rbp
  802c9e:	c3                   	retq   

0000000000802c9f <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c9f:	55                   	push   %rbp
  802ca0:	48 89 e5             	mov    %rsp,%rbp
  802ca3:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802caa:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802cb1:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802cb8:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802cbf:	be 00 00 00 00       	mov    $0x0,%esi
  802cc4:	48 89 c7             	mov    %rax,%rdi
  802cc7:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802cce:	00 00 00 
  802cd1:	ff d0                	callq  *%rax
  802cd3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802cd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cda:	79 28                	jns    802d04 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802cdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdf:	89 c6                	mov    %eax,%esi
  802ce1:	48 bf 56 40 80 00 00 	movabs $0x804056,%rdi
  802ce8:	00 00 00 
  802ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf0:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  802cf7:	00 00 00 
  802cfa:	ff d2                	callq  *%rdx
		return fd_src;
  802cfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cff:	e9 74 01 00 00       	jmpq   802e78 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d04:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d0b:	be 01 01 00 00       	mov    $0x101,%esi
  802d10:	48 89 c7             	mov    %rax,%rdi
  802d13:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802d1a:	00 00 00 
  802d1d:	ff d0                	callq  *%rax
  802d1f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d22:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d26:	79 39                	jns    802d61 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d28:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d2b:	89 c6                	mov    %eax,%esi
  802d2d:	48 bf 6c 40 80 00 00 	movabs $0x80406c,%rdi
  802d34:	00 00 00 
  802d37:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3c:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  802d43:	00 00 00 
  802d46:	ff d2                	callq  *%rdx
		close(fd_src);
  802d48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4b:	89 c7                	mov    %eax,%edi
  802d4d:	48 b8 0c 22 80 00 00 	movabs $0x80220c,%rax
  802d54:	00 00 00 
  802d57:	ff d0                	callq  *%rax
		return fd_dest;
  802d59:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d5c:	e9 17 01 00 00       	jmpq   802e78 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d61:	eb 74                	jmp    802dd7 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d63:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d66:	48 63 d0             	movslq %eax,%rdx
  802d69:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d70:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d73:	48 89 ce             	mov    %rcx,%rsi
  802d76:	89 c7                	mov    %eax,%edi
  802d78:	48 b8 78 25 80 00 00 	movabs $0x802578,%rax
  802d7f:	00 00 00 
  802d82:	ff d0                	callq  *%rax
  802d84:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d87:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d8b:	79 4a                	jns    802dd7 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d8d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d90:	89 c6                	mov    %eax,%esi
  802d92:	48 bf 86 40 80 00 00 	movabs $0x804086,%rdi
  802d99:	00 00 00 
  802d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802da1:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  802da8:	00 00 00 
  802dab:	ff d2                	callq  *%rdx
			close(fd_src);
  802dad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db0:	89 c7                	mov    %eax,%edi
  802db2:	48 b8 0c 22 80 00 00 	movabs $0x80220c,%rax
  802db9:	00 00 00 
  802dbc:	ff d0                	callq  *%rax
			close(fd_dest);
  802dbe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dc1:	89 c7                	mov    %eax,%edi
  802dc3:	48 b8 0c 22 80 00 00 	movabs $0x80220c,%rax
  802dca:	00 00 00 
  802dcd:	ff d0                	callq  *%rax
			return write_size;
  802dcf:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802dd2:	e9 a1 00 00 00       	jmpq   802e78 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802dd7:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802dde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de1:	ba 00 02 00 00       	mov    $0x200,%edx
  802de6:	48 89 ce             	mov    %rcx,%rsi
  802de9:	89 c7                	mov    %eax,%edi
  802deb:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  802df2:	00 00 00 
  802df5:	ff d0                	callq  *%rax
  802df7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802dfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802dfe:	0f 8f 5f ff ff ff    	jg     802d63 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802e04:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e08:	79 47                	jns    802e51 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802e0a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e0d:	89 c6                	mov    %eax,%esi
  802e0f:	48 bf 99 40 80 00 00 	movabs $0x804099,%rdi
  802e16:	00 00 00 
  802e19:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1e:	48 ba 56 06 80 00 00 	movabs $0x800656,%rdx
  802e25:	00 00 00 
  802e28:	ff d2                	callq  *%rdx
		close(fd_src);
  802e2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2d:	89 c7                	mov    %eax,%edi
  802e2f:	48 b8 0c 22 80 00 00 	movabs $0x80220c,%rax
  802e36:	00 00 00 
  802e39:	ff d0                	callq  *%rax
		close(fd_dest);
  802e3b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e3e:	89 c7                	mov    %eax,%edi
  802e40:	48 b8 0c 22 80 00 00 	movabs $0x80220c,%rax
  802e47:	00 00 00 
  802e4a:	ff d0                	callq  *%rax
		return read_size;
  802e4c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e4f:	eb 27                	jmp    802e78 <copy+0x1d9>
	}
	close(fd_src);
  802e51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e54:	89 c7                	mov    %eax,%edi
  802e56:	48 b8 0c 22 80 00 00 	movabs $0x80220c,%rax
  802e5d:	00 00 00 
  802e60:	ff d0                	callq  *%rax
	close(fd_dest);
  802e62:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e65:	89 c7                	mov    %eax,%edi
  802e67:	48 b8 0c 22 80 00 00 	movabs $0x80220c,%rax
  802e6e:	00 00 00 
  802e71:	ff d0                	callq  *%rax
	return 0;
  802e73:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e78:	c9                   	leaveq 
  802e79:	c3                   	retq   

0000000000802e7a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802e7a:	55                   	push   %rbp
  802e7b:	48 89 e5             	mov    %rsp,%rbp
  802e7e:	53                   	push   %rbx
  802e7f:	48 83 ec 38          	sub    $0x38,%rsp
  802e83:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802e87:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802e8b:	48 89 c7             	mov    %rax,%rdi
  802e8e:	48 b8 64 1f 80 00 00 	movabs $0x801f64,%rax
  802e95:	00 00 00 
  802e98:	ff d0                	callq  *%rax
  802e9a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ea1:	0f 88 bf 01 00 00    	js     803066 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ea7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eab:	ba 07 04 00 00       	mov    $0x407,%edx
  802eb0:	48 89 c6             	mov    %rax,%rsi
  802eb3:	bf 00 00 00 00       	mov    $0x0,%edi
  802eb8:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  802ebf:	00 00 00 
  802ec2:	ff d0                	callq  *%rax
  802ec4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ec7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ecb:	0f 88 95 01 00 00    	js     803066 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802ed1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802ed5:	48 89 c7             	mov    %rax,%rdi
  802ed8:	48 b8 64 1f 80 00 00 	movabs $0x801f64,%rax
  802edf:	00 00 00 
  802ee2:	ff d0                	callq  *%rax
  802ee4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ee7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802eeb:	0f 88 5d 01 00 00    	js     80304e <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ef1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ef5:	ba 07 04 00 00       	mov    $0x407,%edx
  802efa:	48 89 c6             	mov    %rax,%rsi
  802efd:	bf 00 00 00 00       	mov    $0x0,%edi
  802f02:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  802f09:	00 00 00 
  802f0c:	ff d0                	callq  *%rax
  802f0e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f11:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f15:	0f 88 33 01 00 00    	js     80304e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802f1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f1f:	48 89 c7             	mov    %rax,%rdi
  802f22:	48 b8 39 1f 80 00 00 	movabs $0x801f39,%rax
  802f29:	00 00 00 
  802f2c:	ff d0                	callq  *%rax
  802f2e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f36:	ba 07 04 00 00       	mov    $0x407,%edx
  802f3b:	48 89 c6             	mov    %rax,%rsi
  802f3e:	bf 00 00 00 00       	mov    $0x0,%edi
  802f43:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  802f4a:	00 00 00 
  802f4d:	ff d0                	callq  *%rax
  802f4f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f52:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f56:	79 05                	jns    802f5d <pipe+0xe3>
		goto err2;
  802f58:	e9 d9 00 00 00       	jmpq   803036 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f5d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f61:	48 89 c7             	mov    %rax,%rdi
  802f64:	48 b8 39 1f 80 00 00 	movabs $0x801f39,%rax
  802f6b:	00 00 00 
  802f6e:	ff d0                	callq  *%rax
  802f70:	48 89 c2             	mov    %rax,%rdx
  802f73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f77:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802f7d:	48 89 d1             	mov    %rdx,%rcx
  802f80:	ba 00 00 00 00       	mov    $0x0,%edx
  802f85:	48 89 c6             	mov    %rax,%rsi
  802f88:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8d:	48 b8 cb 1b 80 00 00 	movabs $0x801bcb,%rax
  802f94:	00 00 00 
  802f97:	ff d0                	callq  *%rax
  802f99:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fa0:	79 1b                	jns    802fbd <pipe+0x143>
		goto err3;
  802fa2:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802fa3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fa7:	48 89 c6             	mov    %rax,%rsi
  802faa:	bf 00 00 00 00       	mov    $0x0,%edi
  802faf:	48 b8 26 1c 80 00 00 	movabs $0x801c26,%rax
  802fb6:	00 00 00 
  802fb9:	ff d0                	callq  *%rax
  802fbb:	eb 79                	jmp    803036 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802fbd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fc1:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  802fc8:	00 00 00 
  802fcb:	8b 12                	mov    (%rdx),%edx
  802fcd:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802fcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fd3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802fda:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fde:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  802fe5:	00 00 00 
  802fe8:	8b 12                	mov    (%rdx),%edx
  802fea:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802fec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ff0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802ff7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ffb:	48 89 c7             	mov    %rax,%rdi
  802ffe:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  803005:	00 00 00 
  803008:	ff d0                	callq  *%rax
  80300a:	89 c2                	mov    %eax,%edx
  80300c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803010:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803012:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803016:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80301a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80301e:	48 89 c7             	mov    %rax,%rdi
  803021:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  803028:	00 00 00 
  80302b:	ff d0                	callq  *%rax
  80302d:	89 03                	mov    %eax,(%rbx)
	return 0;
  80302f:	b8 00 00 00 00       	mov    $0x0,%eax
  803034:	eb 33                	jmp    803069 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803036:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80303a:	48 89 c6             	mov    %rax,%rsi
  80303d:	bf 00 00 00 00       	mov    $0x0,%edi
  803042:	48 b8 26 1c 80 00 00 	movabs $0x801c26,%rax
  803049:	00 00 00 
  80304c:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80304e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803052:	48 89 c6             	mov    %rax,%rsi
  803055:	bf 00 00 00 00       	mov    $0x0,%edi
  80305a:	48 b8 26 1c 80 00 00 	movabs $0x801c26,%rax
  803061:	00 00 00 
  803064:	ff d0                	callq  *%rax
err:
	return r;
  803066:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803069:	48 83 c4 38          	add    $0x38,%rsp
  80306d:	5b                   	pop    %rbx
  80306e:	5d                   	pop    %rbp
  80306f:	c3                   	retq   

0000000000803070 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803070:	55                   	push   %rbp
  803071:	48 89 e5             	mov    %rsp,%rbp
  803074:	53                   	push   %rbx
  803075:	48 83 ec 28          	sub    $0x28,%rsp
  803079:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80307d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803081:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803088:	00 00 00 
  80308b:	48 8b 00             	mov    (%rax),%rax
  80308e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803094:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803097:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80309b:	48 89 c7             	mov    %rax,%rdi
  80309e:	48 b8 1a 39 80 00 00 	movabs $0x80391a,%rax
  8030a5:	00 00 00 
  8030a8:	ff d0                	callq  *%rax
  8030aa:	89 c3                	mov    %eax,%ebx
  8030ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030b0:	48 89 c7             	mov    %rax,%rdi
  8030b3:	48 b8 1a 39 80 00 00 	movabs $0x80391a,%rax
  8030ba:	00 00 00 
  8030bd:	ff d0                	callq  *%rax
  8030bf:	39 c3                	cmp    %eax,%ebx
  8030c1:	0f 94 c0             	sete   %al
  8030c4:	0f b6 c0             	movzbl %al,%eax
  8030c7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8030ca:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8030d1:	00 00 00 
  8030d4:	48 8b 00             	mov    (%rax),%rax
  8030d7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8030dd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8030e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030e3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8030e6:	75 05                	jne    8030ed <_pipeisclosed+0x7d>
			return ret;
  8030e8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8030eb:	eb 4f                	jmp    80313c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8030ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030f0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8030f3:	74 42                	je     803137 <_pipeisclosed+0xc7>
  8030f5:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8030f9:	75 3c                	jne    803137 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8030fb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803102:	00 00 00 
  803105:	48 8b 00             	mov    (%rax),%rax
  803108:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80310e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803111:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803114:	89 c6                	mov    %eax,%esi
  803116:	48 bf b9 40 80 00 00 	movabs $0x8040b9,%rdi
  80311d:	00 00 00 
  803120:	b8 00 00 00 00       	mov    $0x0,%eax
  803125:	49 b8 56 06 80 00 00 	movabs $0x800656,%r8
  80312c:	00 00 00 
  80312f:	41 ff d0             	callq  *%r8
	}
  803132:	e9 4a ff ff ff       	jmpq   803081 <_pipeisclosed+0x11>
  803137:	e9 45 ff ff ff       	jmpq   803081 <_pipeisclosed+0x11>
}
  80313c:	48 83 c4 28          	add    $0x28,%rsp
  803140:	5b                   	pop    %rbx
  803141:	5d                   	pop    %rbp
  803142:	c3                   	retq   

0000000000803143 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803143:	55                   	push   %rbp
  803144:	48 89 e5             	mov    %rsp,%rbp
  803147:	48 83 ec 30          	sub    $0x30,%rsp
  80314b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80314e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803152:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803155:	48 89 d6             	mov    %rdx,%rsi
  803158:	89 c7                	mov    %eax,%edi
  80315a:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  803161:	00 00 00 
  803164:	ff d0                	callq  *%rax
  803166:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803169:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316d:	79 05                	jns    803174 <pipeisclosed+0x31>
		return r;
  80316f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803172:	eb 31                	jmp    8031a5 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803174:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803178:	48 89 c7             	mov    %rax,%rdi
  80317b:	48 b8 39 1f 80 00 00 	movabs $0x801f39,%rax
  803182:	00 00 00 
  803185:	ff d0                	callq  *%rax
  803187:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80318b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80318f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803193:	48 89 d6             	mov    %rdx,%rsi
  803196:	48 89 c7             	mov    %rax,%rdi
  803199:	48 b8 70 30 80 00 00 	movabs $0x803070,%rax
  8031a0:	00 00 00 
  8031a3:	ff d0                	callq  *%rax
}
  8031a5:	c9                   	leaveq 
  8031a6:	c3                   	retq   

00000000008031a7 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8031a7:	55                   	push   %rbp
  8031a8:	48 89 e5             	mov    %rsp,%rbp
  8031ab:	48 83 ec 40          	sub    $0x40,%rsp
  8031af:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8031b3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8031b7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8031bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031bf:	48 89 c7             	mov    %rax,%rdi
  8031c2:	48 b8 39 1f 80 00 00 	movabs $0x801f39,%rax
  8031c9:	00 00 00 
  8031cc:	ff d0                	callq  *%rax
  8031ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8031d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031d6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8031da:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8031e1:	00 
  8031e2:	e9 92 00 00 00       	jmpq   803279 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8031e7:	eb 41                	jmp    80322a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8031e9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8031ee:	74 09                	je     8031f9 <devpipe_read+0x52>
				return i;
  8031f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031f4:	e9 92 00 00 00       	jmpq   80328b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8031f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803201:	48 89 d6             	mov    %rdx,%rsi
  803204:	48 89 c7             	mov    %rax,%rdi
  803207:	48 b8 70 30 80 00 00 	movabs $0x803070,%rax
  80320e:	00 00 00 
  803211:	ff d0                	callq  *%rax
  803213:	85 c0                	test   %eax,%eax
  803215:	74 07                	je     80321e <devpipe_read+0x77>
				return 0;
  803217:	b8 00 00 00 00       	mov    $0x0,%eax
  80321c:	eb 6d                	jmp    80328b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80321e:	48 b8 3d 1b 80 00 00 	movabs $0x801b3d,%rax
  803225:	00 00 00 
  803228:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80322a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80322e:	8b 10                	mov    (%rax),%edx
  803230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803234:	8b 40 04             	mov    0x4(%rax),%eax
  803237:	39 c2                	cmp    %eax,%edx
  803239:	74 ae                	je     8031e9 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80323b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80323f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803243:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80324b:	8b 00                	mov    (%rax),%eax
  80324d:	99                   	cltd   
  80324e:	c1 ea 1b             	shr    $0x1b,%edx
  803251:	01 d0                	add    %edx,%eax
  803253:	83 e0 1f             	and    $0x1f,%eax
  803256:	29 d0                	sub    %edx,%eax
  803258:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80325c:	48 98                	cltq   
  80325e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803263:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803265:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803269:	8b 00                	mov    (%rax),%eax
  80326b:	8d 50 01             	lea    0x1(%rax),%edx
  80326e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803272:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803274:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803279:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80327d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803281:	0f 82 60 ff ff ff    	jb     8031e7 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80328b:	c9                   	leaveq 
  80328c:	c3                   	retq   

000000000080328d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80328d:	55                   	push   %rbp
  80328e:	48 89 e5             	mov    %rsp,%rbp
  803291:	48 83 ec 40          	sub    $0x40,%rsp
  803295:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803299:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80329d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8032a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a5:	48 89 c7             	mov    %rax,%rdi
  8032a8:	48 b8 39 1f 80 00 00 	movabs $0x801f39,%rax
  8032af:	00 00 00 
  8032b2:	ff d0                	callq  *%rax
  8032b4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8032b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032bc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8032c0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8032c7:	00 
  8032c8:	e9 8e 00 00 00       	jmpq   80335b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8032cd:	eb 31                	jmp    803300 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8032cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032d7:	48 89 d6             	mov    %rdx,%rsi
  8032da:	48 89 c7             	mov    %rax,%rdi
  8032dd:	48 b8 70 30 80 00 00 	movabs $0x803070,%rax
  8032e4:	00 00 00 
  8032e7:	ff d0                	callq  *%rax
  8032e9:	85 c0                	test   %eax,%eax
  8032eb:	74 07                	je     8032f4 <devpipe_write+0x67>
				return 0;
  8032ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f2:	eb 79                	jmp    80336d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8032f4:	48 b8 3d 1b 80 00 00 	movabs $0x801b3d,%rax
  8032fb:	00 00 00 
  8032fe:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803304:	8b 40 04             	mov    0x4(%rax),%eax
  803307:	48 63 d0             	movslq %eax,%rdx
  80330a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80330e:	8b 00                	mov    (%rax),%eax
  803310:	48 98                	cltq   
  803312:	48 83 c0 20          	add    $0x20,%rax
  803316:	48 39 c2             	cmp    %rax,%rdx
  803319:	73 b4                	jae    8032cf <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80331b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80331f:	8b 40 04             	mov    0x4(%rax),%eax
  803322:	99                   	cltd   
  803323:	c1 ea 1b             	shr    $0x1b,%edx
  803326:	01 d0                	add    %edx,%eax
  803328:	83 e0 1f             	and    $0x1f,%eax
  80332b:	29 d0                	sub    %edx,%eax
  80332d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803331:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803335:	48 01 ca             	add    %rcx,%rdx
  803338:	0f b6 0a             	movzbl (%rdx),%ecx
  80333b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80333f:	48 98                	cltq   
  803341:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803345:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803349:	8b 40 04             	mov    0x4(%rax),%eax
  80334c:	8d 50 01             	lea    0x1(%rax),%edx
  80334f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803353:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803356:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80335b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80335f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803363:	0f 82 64 ff ff ff    	jb     8032cd <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80336d:	c9                   	leaveq 
  80336e:	c3                   	retq   

000000000080336f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80336f:	55                   	push   %rbp
  803370:	48 89 e5             	mov    %rsp,%rbp
  803373:	48 83 ec 20          	sub    $0x20,%rsp
  803377:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80337b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80337f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803383:	48 89 c7             	mov    %rax,%rdi
  803386:	48 b8 39 1f 80 00 00 	movabs $0x801f39,%rax
  80338d:	00 00 00 
  803390:	ff d0                	callq  *%rax
  803392:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803396:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80339a:	48 be cc 40 80 00 00 	movabs $0x8040cc,%rsi
  8033a1:	00 00 00 
  8033a4:	48 89 c7             	mov    %rax,%rdi
  8033a7:	48 b8 4c 12 80 00 00 	movabs $0x80124c,%rax
  8033ae:	00 00 00 
  8033b1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8033b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033b7:	8b 50 04             	mov    0x4(%rax),%edx
  8033ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033be:	8b 00                	mov    (%rax),%eax
  8033c0:	29 c2                	sub    %eax,%edx
  8033c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033c6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8033cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033d0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8033d7:	00 00 00 
	stat->st_dev = &devpipe;
  8033da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033de:	48 b9 e0 50 80 00 00 	movabs $0x8050e0,%rcx
  8033e5:	00 00 00 
  8033e8:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8033ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033f4:	c9                   	leaveq 
  8033f5:	c3                   	retq   

00000000008033f6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8033f6:	55                   	push   %rbp
  8033f7:	48 89 e5             	mov    %rsp,%rbp
  8033fa:	48 83 ec 10          	sub    $0x10,%rsp
  8033fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803402:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803406:	48 89 c6             	mov    %rax,%rsi
  803409:	bf 00 00 00 00       	mov    $0x0,%edi
  80340e:	48 b8 26 1c 80 00 00 	movabs $0x801c26,%rax
  803415:	00 00 00 
  803418:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80341a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80341e:	48 89 c7             	mov    %rax,%rdi
  803421:	48 b8 39 1f 80 00 00 	movabs $0x801f39,%rax
  803428:	00 00 00 
  80342b:	ff d0                	callq  *%rax
  80342d:	48 89 c6             	mov    %rax,%rsi
  803430:	bf 00 00 00 00       	mov    $0x0,%edi
  803435:	48 b8 26 1c 80 00 00 	movabs $0x801c26,%rax
  80343c:	00 00 00 
  80343f:	ff d0                	callq  *%rax
}
  803441:	c9                   	leaveq 
  803442:	c3                   	retq   

0000000000803443 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803443:	55                   	push   %rbp
  803444:	48 89 e5             	mov    %rsp,%rbp
  803447:	48 83 ec 20          	sub    $0x20,%rsp
  80344b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80344e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803451:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803454:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803458:	be 01 00 00 00       	mov    $0x1,%esi
  80345d:	48 89 c7             	mov    %rax,%rdi
  803460:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  803467:	00 00 00 
  80346a:	ff d0                	callq  *%rax
}
  80346c:	c9                   	leaveq 
  80346d:	c3                   	retq   

000000000080346e <getchar>:

int
getchar(void)
{
  80346e:	55                   	push   %rbp
  80346f:	48 89 e5             	mov    %rsp,%rbp
  803472:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803476:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80347a:	ba 01 00 00 00       	mov    $0x1,%edx
  80347f:	48 89 c6             	mov    %rax,%rsi
  803482:	bf 00 00 00 00       	mov    $0x0,%edi
  803487:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  80348e:	00 00 00 
  803491:	ff d0                	callq  *%rax
  803493:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803496:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80349a:	79 05                	jns    8034a1 <getchar+0x33>
		return r;
  80349c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349f:	eb 14                	jmp    8034b5 <getchar+0x47>
	if (r < 1)
  8034a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a5:	7f 07                	jg     8034ae <getchar+0x40>
		return -E_EOF;
  8034a7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8034ac:	eb 07                	jmp    8034b5 <getchar+0x47>
	return c;
  8034ae:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8034b2:	0f b6 c0             	movzbl %al,%eax
}
  8034b5:	c9                   	leaveq 
  8034b6:	c3                   	retq   

00000000008034b7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8034b7:	55                   	push   %rbp
  8034b8:	48 89 e5             	mov    %rsp,%rbp
  8034bb:	48 83 ec 20          	sub    $0x20,%rsp
  8034bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8034c2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034c9:	48 89 d6             	mov    %rdx,%rsi
  8034cc:	89 c7                	mov    %eax,%edi
  8034ce:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  8034d5:	00 00 00 
  8034d8:	ff d0                	callq  *%rax
  8034da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e1:	79 05                	jns    8034e8 <iscons+0x31>
		return r;
  8034e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e6:	eb 1a                	jmp    803502 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8034e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ec:	8b 10                	mov    (%rax),%edx
  8034ee:	48 b8 20 51 80 00 00 	movabs $0x805120,%rax
  8034f5:	00 00 00 
  8034f8:	8b 00                	mov    (%rax),%eax
  8034fa:	39 c2                	cmp    %eax,%edx
  8034fc:	0f 94 c0             	sete   %al
  8034ff:	0f b6 c0             	movzbl %al,%eax
}
  803502:	c9                   	leaveq 
  803503:	c3                   	retq   

0000000000803504 <opencons>:

int
opencons(void)
{
  803504:	55                   	push   %rbp
  803505:	48 89 e5             	mov    %rsp,%rbp
  803508:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80350c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803510:	48 89 c7             	mov    %rax,%rdi
  803513:	48 b8 64 1f 80 00 00 	movabs $0x801f64,%rax
  80351a:	00 00 00 
  80351d:	ff d0                	callq  *%rax
  80351f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803522:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803526:	79 05                	jns    80352d <opencons+0x29>
		return r;
  803528:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352b:	eb 5b                	jmp    803588 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80352d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803531:	ba 07 04 00 00       	mov    $0x407,%edx
  803536:	48 89 c6             	mov    %rax,%rsi
  803539:	bf 00 00 00 00       	mov    $0x0,%edi
  80353e:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  803545:	00 00 00 
  803548:	ff d0                	callq  *%rax
  80354a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80354d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803551:	79 05                	jns    803558 <opencons+0x54>
		return r;
  803553:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803556:	eb 30                	jmp    803588 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803558:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80355c:	48 ba 20 51 80 00 00 	movabs $0x805120,%rdx
  803563:	00 00 00 
  803566:	8b 12                	mov    (%rdx),%edx
  803568:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80356a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803575:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803579:	48 89 c7             	mov    %rax,%rdi
  80357c:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  803583:	00 00 00 
  803586:	ff d0                	callq  *%rax
}
  803588:	c9                   	leaveq 
  803589:	c3                   	retq   

000000000080358a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80358a:	55                   	push   %rbp
  80358b:	48 89 e5             	mov    %rsp,%rbp
  80358e:	48 83 ec 30          	sub    $0x30,%rsp
  803592:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803596:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80359a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80359e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8035a3:	75 07                	jne    8035ac <devcons_read+0x22>
		return 0;
  8035a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035aa:	eb 4b                	jmp    8035f7 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8035ac:	eb 0c                	jmp    8035ba <devcons_read+0x30>
		sys_yield();
  8035ae:	48 b8 3d 1b 80 00 00 	movabs $0x801b3d,%rax
  8035b5:	00 00 00 
  8035b8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8035ba:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  8035c1:	00 00 00 
  8035c4:	ff d0                	callq  *%rax
  8035c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035cd:	74 df                	je     8035ae <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8035cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d3:	79 05                	jns    8035da <devcons_read+0x50>
		return c;
  8035d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d8:	eb 1d                	jmp    8035f7 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8035da:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8035de:	75 07                	jne    8035e7 <devcons_read+0x5d>
		return 0;
  8035e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e5:	eb 10                	jmp    8035f7 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8035e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ea:	89 c2                	mov    %eax,%edx
  8035ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f0:	88 10                	mov    %dl,(%rax)
	return 1;
  8035f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8035f7:	c9                   	leaveq 
  8035f8:	c3                   	retq   

00000000008035f9 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8035f9:	55                   	push   %rbp
  8035fa:	48 89 e5             	mov    %rsp,%rbp
  8035fd:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803604:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80360b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803612:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803619:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803620:	eb 76                	jmp    803698 <devcons_write+0x9f>
		m = n - tot;
  803622:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803629:	89 c2                	mov    %eax,%edx
  80362b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80362e:	29 c2                	sub    %eax,%edx
  803630:	89 d0                	mov    %edx,%eax
  803632:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803635:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803638:	83 f8 7f             	cmp    $0x7f,%eax
  80363b:	76 07                	jbe    803644 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80363d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803644:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803647:	48 63 d0             	movslq %eax,%rdx
  80364a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80364d:	48 63 c8             	movslq %eax,%rcx
  803650:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803657:	48 01 c1             	add    %rax,%rcx
  80365a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803661:	48 89 ce             	mov    %rcx,%rsi
  803664:	48 89 c7             	mov    %rax,%rdi
  803667:	48 b8 70 15 80 00 00 	movabs $0x801570,%rax
  80366e:	00 00 00 
  803671:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803673:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803676:	48 63 d0             	movslq %eax,%rdx
  803679:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803680:	48 89 d6             	mov    %rdx,%rsi
  803683:	48 89 c7             	mov    %rax,%rdi
  803686:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  80368d:	00 00 00 
  803690:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803692:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803695:	01 45 fc             	add    %eax,-0x4(%rbp)
  803698:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80369b:	48 98                	cltq   
  80369d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8036a4:	0f 82 78 ff ff ff    	jb     803622 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8036aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8036ad:	c9                   	leaveq 
  8036ae:	c3                   	retq   

00000000008036af <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8036af:	55                   	push   %rbp
  8036b0:	48 89 e5             	mov    %rsp,%rbp
  8036b3:	48 83 ec 08          	sub    $0x8,%rsp
  8036b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8036bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036c0:	c9                   	leaveq 
  8036c1:	c3                   	retq   

00000000008036c2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8036c2:	55                   	push   %rbp
  8036c3:	48 89 e5             	mov    %rsp,%rbp
  8036c6:	48 83 ec 10          	sub    $0x10,%rsp
  8036ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8036d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d6:	48 be d8 40 80 00 00 	movabs $0x8040d8,%rsi
  8036dd:	00 00 00 
  8036e0:	48 89 c7             	mov    %rax,%rdi
  8036e3:	48 b8 4c 12 80 00 00 	movabs $0x80124c,%rax
  8036ea:	00 00 00 
  8036ed:	ff d0                	callq  *%rax
	return 0;
  8036ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036f4:	c9                   	leaveq 
  8036f5:	c3                   	retq   

00000000008036f6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8036f6:	55                   	push   %rbp
  8036f7:	48 89 e5             	mov    %rsp,%rbp
  8036fa:	48 83 ec 30          	sub    $0x30,%rsp
  8036fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803702:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803706:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  80370a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80370f:	75 08                	jne    803719 <ipc_recv+0x23>
  803711:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  803718:	ff 
	int res=sys_ipc_recv(pg);
  803719:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80371d:	48 89 c7             	mov    %rax,%rdi
  803720:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  803727:	00 00 00 
  80372a:	ff d0                	callq  *%rax
  80372c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  80372f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803734:	74 26                	je     80375c <ipc_recv+0x66>
  803736:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80373a:	75 15                	jne    803751 <ipc_recv+0x5b>
  80373c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803743:	00 00 00 
  803746:	48 8b 00             	mov    (%rax),%rax
  803749:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  80374f:	eb 05                	jmp    803756 <ipc_recv+0x60>
  803751:	b8 00 00 00 00       	mov    $0x0,%eax
  803756:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80375a:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  80375c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803761:	74 26                	je     803789 <ipc_recv+0x93>
  803763:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803767:	75 15                	jne    80377e <ipc_recv+0x88>
  803769:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803770:	00 00 00 
  803773:	48 8b 00             	mov    (%rax),%rax
  803776:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  80377c:	eb 05                	jmp    803783 <ipc_recv+0x8d>
  80377e:	b8 00 00 00 00       	mov    $0x0,%eax
  803783:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803787:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  803789:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80378d:	75 15                	jne    8037a4 <ipc_recv+0xae>
  80378f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803796:	00 00 00 
  803799:	48 8b 00             	mov    (%rax),%rax
  80379c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  8037a2:	eb 03                	jmp    8037a7 <ipc_recv+0xb1>
  8037a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  8037a7:	c9                   	leaveq 
  8037a8:	c3                   	retq   

00000000008037a9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8037a9:	55                   	push   %rbp
  8037aa:	48 89 e5             	mov    %rsp,%rbp
  8037ad:	48 83 ec 30          	sub    $0x30,%rsp
  8037b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037b4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8037b7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8037bb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  8037be:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8037c3:	75 0a                	jne    8037cf <ipc_send+0x26>
  8037c5:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8037cc:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8037cd:	eb 3e                	jmp    80380d <ipc_send+0x64>
  8037cf:	eb 3c                	jmp    80380d <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  8037d1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8037d5:	74 2a                	je     803801 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  8037d7:	48 ba e0 40 80 00 00 	movabs $0x8040e0,%rdx
  8037de:	00 00 00 
  8037e1:	be 39 00 00 00       	mov    $0x39,%esi
  8037e6:	48 bf 0b 41 80 00 00 	movabs $0x80410b,%rdi
  8037ed:	00 00 00 
  8037f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f5:	48 b9 1d 04 80 00 00 	movabs $0x80041d,%rcx
  8037fc:	00 00 00 
  8037ff:	ff d1                	callq  *%rcx
		sys_yield();  
  803801:	48 b8 3d 1b 80 00 00 	movabs $0x801b3d,%rax
  803808:	00 00 00 
  80380b:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  80380d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803810:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803813:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803817:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80381a:	89 c7                	mov    %eax,%edi
  80381c:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  803823:	00 00 00 
  803826:	ff d0                	callq  *%rax
  803828:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80382b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80382f:	78 a0                	js     8037d1 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  803831:	c9                   	leaveq 
  803832:	c3                   	retq   

0000000000803833 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803833:	55                   	push   %rbp
  803834:	48 89 e5             	mov    %rsp,%rbp
  803837:	48 83 ec 10          	sub    $0x10,%rsp
  80383b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  80383f:	48 ba 18 41 80 00 00 	movabs $0x804118,%rdx
  803846:	00 00 00 
  803849:	be 47 00 00 00       	mov    $0x47,%esi
  80384e:	48 bf 0b 41 80 00 00 	movabs $0x80410b,%rdi
  803855:	00 00 00 
  803858:	b8 00 00 00 00       	mov    $0x0,%eax
  80385d:	48 b9 1d 04 80 00 00 	movabs $0x80041d,%rcx
  803864:	00 00 00 
  803867:	ff d1                	callq  *%rcx

0000000000803869 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803869:	55                   	push   %rbp
  80386a:	48 89 e5             	mov    %rsp,%rbp
  80386d:	48 83 ec 20          	sub    $0x20,%rsp
  803871:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803874:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803877:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  80387b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  80387e:	48 ba 40 41 80 00 00 	movabs $0x804140,%rdx
  803885:	00 00 00 
  803888:	be 50 00 00 00       	mov    $0x50,%esi
  80388d:	48 bf 0b 41 80 00 00 	movabs $0x80410b,%rdi
  803894:	00 00 00 
  803897:	b8 00 00 00 00       	mov    $0x0,%eax
  80389c:	48 b9 1d 04 80 00 00 	movabs $0x80041d,%rcx
  8038a3:	00 00 00 
  8038a6:	ff d1                	callq  *%rcx

00000000008038a8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8038a8:	55                   	push   %rbp
  8038a9:	48 89 e5             	mov    %rsp,%rbp
  8038ac:	48 83 ec 14          	sub    $0x14,%rsp
  8038b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8038b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038ba:	eb 4e                	jmp    80390a <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8038bc:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8038c3:	00 00 00 
  8038c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c9:	48 98                	cltq   
  8038cb:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8038d2:	48 01 d0             	add    %rdx,%rax
  8038d5:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8038db:	8b 00                	mov    (%rax),%eax
  8038dd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8038e0:	75 24                	jne    803906 <ipc_find_env+0x5e>
			return envs[i].env_id;
  8038e2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8038e9:	00 00 00 
  8038ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ef:	48 98                	cltq   
  8038f1:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8038f8:	48 01 d0             	add    %rdx,%rax
  8038fb:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803901:	8b 40 08             	mov    0x8(%rax),%eax
  803904:	eb 12                	jmp    803918 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803906:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80390a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803911:	7e a9                	jle    8038bc <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  803913:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803918:	c9                   	leaveq 
  803919:	c3                   	retq   

000000000080391a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80391a:	55                   	push   %rbp
  80391b:	48 89 e5             	mov    %rsp,%rbp
  80391e:	48 83 ec 18          	sub    $0x18,%rsp
  803922:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803926:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80392a:	48 c1 e8 15          	shr    $0x15,%rax
  80392e:	48 89 c2             	mov    %rax,%rdx
  803931:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803938:	01 00 00 
  80393b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80393f:	83 e0 01             	and    $0x1,%eax
  803942:	48 85 c0             	test   %rax,%rax
  803945:	75 07                	jne    80394e <pageref+0x34>
		return 0;
  803947:	b8 00 00 00 00       	mov    $0x0,%eax
  80394c:	eb 53                	jmp    8039a1 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80394e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803952:	48 c1 e8 0c          	shr    $0xc,%rax
  803956:	48 89 c2             	mov    %rax,%rdx
  803959:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803960:	01 00 00 
  803963:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803967:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80396b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80396f:	83 e0 01             	and    $0x1,%eax
  803972:	48 85 c0             	test   %rax,%rax
  803975:	75 07                	jne    80397e <pageref+0x64>
		return 0;
  803977:	b8 00 00 00 00       	mov    $0x0,%eax
  80397c:	eb 23                	jmp    8039a1 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80397e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803982:	48 c1 e8 0c          	shr    $0xc,%rax
  803986:	48 89 c2             	mov    %rax,%rdx
  803989:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803990:	00 00 00 
  803993:	48 c1 e2 04          	shl    $0x4,%rdx
  803997:	48 01 d0             	add    %rdx,%rax
  80399a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80399e:	0f b7 c0             	movzwl %ax,%eax
}
  8039a1:	c9                   	leaveq 
  8039a2:	c3                   	retq   
