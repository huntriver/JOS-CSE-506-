
vmm/guest/obj/user/primespipe:     file format elf64-x86-64


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
  80003c:	e8 d3 03 00 00       	callq  800414 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80004e:	48 8d 4d ec          	lea    -0x14(%rbp),%rcx
  800052:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800055:	ba 04 00 00 00       	mov    $0x4,%edx
  80005a:	48 89 ce             	mov    %rcx,%rsi
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	48 b8 de 2e 80 00 00 	movabs $0x802ede,%rax
  800066:	00 00 00 
  800069:	ff d0                	callq  *%rax
  80006b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800072:	74 42                	je     8000b6 <primeproc+0x73>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800074:	b8 00 00 00 00       	mov    $0x0,%eax
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800081:	89 c2                	mov    %eax,%edx
  800083:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800086:	41 89 d0             	mov    %edx,%r8d
  800089:	89 c1                	mov    %eax,%ecx
  80008b:	48 ba a0 44 80 00 00 	movabs $0x8044a0,%rdx
  800092:	00 00 00 
  800095:	be 15 00 00 00       	mov    $0x15,%esi
  80009a:	48 bf cf 44 80 00 00 	movabs $0x8044cf,%rdi
  8000a1:	00 00 00 
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	49 b9 ba 04 80 00 00 	movabs $0x8004ba,%r9
  8000b0:	00 00 00 
  8000b3:	41 ff d1             	callq  *%r9

	cprintf("%d\n", p);
  8000b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000b9:	89 c6                	mov    %eax,%esi
  8000bb:	48 bf e1 44 80 00 00 	movabs $0x8044e1,%rdi
  8000c2:	00 00 00 
  8000c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ca:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  8000d1:	00 00 00 
  8000d4:	ff d2                	callq  *%rdx

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000d6:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 55 38 80 00 00 	movabs $0x803855,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	79 30                	jns    800123 <primeproc+0xe0>
		panic("pipe: %e", i);
  8000f3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f6:	89 c1                	mov    %eax,%ecx
  8000f8:	48 ba e5 44 80 00 00 	movabs $0x8044e5,%rdx
  8000ff:	00 00 00 
  800102:	be 1b 00 00 00       	mov    $0x1b,%esi
  800107:	48 bf cf 44 80 00 00 	movabs $0x8044cf,%rdi
  80010e:	00 00 00 
  800111:	b8 00 00 00 00       	mov    $0x0,%eax
  800116:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  80011d:	00 00 00 
  800120:	41 ff d0             	callq  *%r8
	if ((id = fork()) < 0)
  800123:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  80012a:	00 00 00 
  80012d:	ff d0                	callq  *%rax
  80012f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800132:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800136:	79 30                	jns    800168 <primeproc+0x125>
		panic("fork: %e", id);
  800138:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80013b:	89 c1                	mov    %eax,%ecx
  80013d:	48 ba ee 44 80 00 00 	movabs $0x8044ee,%rdx
  800144:	00 00 00 
  800147:	be 1d 00 00 00       	mov    $0x1d,%esi
  80014c:	48 bf cf 44 80 00 00 	movabs $0x8044cf,%rdi
  800153:	00 00 00 
  800156:	b8 00 00 00 00       	mov    $0x0,%eax
  80015b:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  800162:	00 00 00 
  800165:	41 ff d0             	callq  *%r8
	if (id == 0) {
  800168:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80016c:	75 2d                	jne    80019b <primeproc+0x158>
		close(fd);
  80016e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800171:	89 c7                	mov    %eax,%edi
  800173:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	callq  *%rax
		close(pfd[1]);
  80017f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800182:	89 c7                	mov    %eax,%edi
  800184:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  80018b:	00 00 00 
  80018e:	ff d0                	callq  *%rax
		fd = pfd[0];
  800190:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800193:	89 45 dc             	mov    %eax,-0x24(%rbp)
		goto top;
  800196:	e9 b3 fe ff ff       	jmpq   80004e <primeproc+0xb>
	}

	close(pfd[0]);
  80019b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80019e:	89 c7                	mov    %eax,%edi
  8001a0:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
	wfd = pfd[1];
  8001ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8001af:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8001b2:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8001b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001b9:	ba 04 00 00 00       	mov    $0x4,%edx
  8001be:	48 89 ce             	mov    %rcx,%rsi
  8001c1:	89 c7                	mov    %eax,%edi
  8001c3:	48 b8 de 2e 80 00 00 	movabs $0x802ede,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	callq  *%rax
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8001d6:	74 4e                	je     800226 <primeproc+0x1e3>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001e1:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8001e5:	89 c2                	mov    %eax,%edx
  8001e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ea:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ed:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8001f0:	89 14 24             	mov    %edx,(%rsp)
  8001f3:	41 89 f1             	mov    %esi,%r9d
  8001f6:	41 89 c8             	mov    %ecx,%r8d
  8001f9:	89 c1                	mov    %eax,%ecx
  8001fb:	48 ba f7 44 80 00 00 	movabs $0x8044f7,%rdx
  800202:	00 00 00 
  800205:	be 2b 00 00 00       	mov    $0x2b,%esi
  80020a:	48 bf cf 44 80 00 00 	movabs $0x8044cf,%rdi
  800211:	00 00 00 
  800214:	b8 00 00 00 00       	mov    $0x0,%eax
  800219:	49 ba ba 04 80 00 00 	movabs $0x8004ba,%r10
  800220:	00 00 00 
  800223:	41 ff d2             	callq  *%r10
		if (i%p)
  800226:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800229:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  80022c:	99                   	cltd   
  80022d:	f7 f9                	idiv   %ecx
  80022f:	89 d0                	mov    %edx,%eax
  800231:	85 c0                	test   %eax,%eax
  800233:	74 6e                	je     8002a3 <primeproc+0x260>
			if ((r=write(wfd, &i, 4)) != 4)
  800235:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  800239:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80023c:	ba 04 00 00 00       	mov    $0x4,%edx
  800241:	48 89 ce             	mov    %rcx,%rsi
  800244:	89 c7                	mov    %eax,%edi
  800246:	48 b8 53 2f 80 00 00 	movabs $0x802f53,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
  800252:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800255:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800259:	74 48                	je     8002a3 <primeproc+0x260>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80025b:	b8 00 00 00 00       	mov    $0x0,%eax
  800260:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800264:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800268:	89 c1                	mov    %eax,%ecx
  80026a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80026d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800270:	41 89 c9             	mov    %ecx,%r9d
  800273:	41 89 d0             	mov    %edx,%r8d
  800276:	89 c1                	mov    %eax,%ecx
  800278:	48 ba 13 45 80 00 00 	movabs $0x804513,%rdx
  80027f:	00 00 00 
  800282:	be 2e 00 00 00       	mov    $0x2e,%esi
  800287:	48 bf cf 44 80 00 00 	movabs $0x8044cf,%rdi
  80028e:	00 00 00 
  800291:	b8 00 00 00 00       	mov    $0x0,%eax
  800296:	49 ba ba 04 80 00 00 	movabs $0x8004ba,%r10
  80029d:	00 00 00 
  8002a0:	41 ff d2             	callq  *%r10
	}
  8002a3:	e9 0a ff ff ff       	jmpq   8001b2 <primeproc+0x16f>

00000000008002a8 <umain>:
}

void
umain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	53                   	push   %rbx
  8002ad:	48 83 ec 38          	sub    $0x38,%rsp
  8002b1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8002b4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i, id, p[2], r;

	binaryname = "primespipe";
  8002b8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002bf:	00 00 00 
  8002c2:	48 bb 2d 45 80 00 00 	movabs $0x80452d,%rbx
  8002c9:	00 00 00 
  8002cc:	48 89 18             	mov    %rbx,(%rax)

	if ((i=pipe(p)) < 0)
  8002cf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002d3:	48 89 c7             	mov    %rax,%rdi
  8002d6:	48 b8 55 38 80 00 00 	movabs $0x803855,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	callq  *%rax
  8002e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8002e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002e8:	85 c0                	test   %eax,%eax
  8002ea:	79 30                	jns    80031c <umain+0x74>
		panic("pipe: %e", i);
  8002ec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002ef:	89 c1                	mov    %eax,%ecx
  8002f1:	48 ba e5 44 80 00 00 	movabs $0x8044e5,%rdx
  8002f8:	00 00 00 
  8002fb:	be 3a 00 00 00       	mov    $0x3a,%esi
  800300:	48 bf cf 44 80 00 00 	movabs $0x8044cf,%rdi
  800307:	00 00 00 
  80030a:	b8 00 00 00 00       	mov    $0x0,%eax
  80030f:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  800316:	00 00 00 
  800319:	41 ff d0             	callq  *%r8

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80031c:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  800323:	00 00 00 
  800326:	ff d0                	callq  *%rax
  800328:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80032b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80032f:	79 30                	jns    800361 <umain+0xb9>
		panic("fork: %e", id);
  800331:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800334:	89 c1                	mov    %eax,%ecx
  800336:	48 ba ee 44 80 00 00 	movabs $0x8044ee,%rdx
  80033d:	00 00 00 
  800340:	be 3e 00 00 00       	mov    $0x3e,%esi
  800345:	48 bf cf 44 80 00 00 	movabs $0x8044cf,%rdi
  80034c:	00 00 00 
  80034f:	b8 00 00 00 00       	mov    $0x0,%eax
  800354:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  80035b:	00 00 00 
  80035e:	41 ff d0             	callq  *%r8

	if (id == 0) {
  800361:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800365:	75 22                	jne    800389 <umain+0xe1>
		close(p[1]);
  800367:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80036a:	89 c7                	mov    %eax,%edi
  80036c:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
		primeproc(p[0]);
  800378:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80037b:	89 c7                	mov    %eax,%edi
  80037d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800384:	00 00 00 
  800387:	ff d0                	callq  *%rax
	}

	close(p[0]);
  800389:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80038c:	89 c7                	mov    %eax,%edi
  80038e:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  800395:	00 00 00 
  800398:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i=2;; i++)
  80039a:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
  8003a1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003a4:	48 8d 4d e4          	lea    -0x1c(%rbp),%rcx
  8003a8:	ba 04 00 00 00       	mov    $0x4,%edx
  8003ad:	48 89 ce             	mov    %rcx,%rsi
  8003b0:	89 c7                	mov    %eax,%edi
  8003b2:	48 b8 53 2f 80 00 00 	movabs $0x802f53,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	callq  *%rax
  8003be:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8003c1:	83 7d e8 04          	cmpl   $0x4,-0x18(%rbp)
  8003c5:	74 42                	je     800409 <umain+0x161>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  8003c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8003d0:	0f 4e 45 e8          	cmovle -0x18(%rbp),%eax
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003d9:	41 89 d0             	mov    %edx,%r8d
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	48 ba 38 45 80 00 00 	movabs $0x804538,%rdx
  8003e5:	00 00 00 
  8003e8:	be 4a 00 00 00       	mov    $0x4a,%esi
  8003ed:	48 bf cf 44 80 00 00 	movabs $0x8044cf,%rdi
  8003f4:	00 00 00 
  8003f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fc:	49 b9 ba 04 80 00 00 	movabs $0x8004ba,%r9
  800403:	00 00 00 
  800406:	41 ff d1             	callq  *%r9
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  800409:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80040c:	83 c0 01             	add    $0x1,%eax
  80040f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  800412:	eb 8d                	jmp    8003a1 <umain+0xf9>

0000000000800414 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800414:	55                   	push   %rbp
  800415:	48 89 e5             	mov    %rsp,%rbp
  800418:	48 83 ec 10          	sub    $0x10,%rsp
  80041c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80041f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  800423:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  80042a:	00 00 00 
  80042d:	ff d0                	callq  *%rax
  80042f:	48 98                	cltq   
  800431:	25 ff 03 00 00       	and    $0x3ff,%eax
  800436:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  80043d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800444:	00 00 00 
  800447:	48 01 c2             	add    %rax,%rdx
  80044a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800451:	00 00 00 
  800454:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800457:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80045b:	7e 14                	jle    800471 <libmain+0x5d>
		binaryname = argv[0];
  80045d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800461:	48 8b 10             	mov    (%rax),%rdx
  800464:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80046b:	00 00 00 
  80046e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800471:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800475:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800478:	48 89 d6             	mov    %rdx,%rsi
  80047b:	89 c7                	mov    %eax,%edi
  80047d:	48 b8 a8 02 80 00 00 	movabs $0x8002a8,%rax
  800484:	00 00 00 
  800487:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800489:	48 b8 97 04 80 00 00 	movabs $0x800497,%rax
  800490:	00 00 00 
  800493:	ff d0                	callq  *%rax
}
  800495:	c9                   	leaveq 
  800496:	c3                   	retq   

0000000000800497 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800497:	55                   	push   %rbp
  800498:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80049b:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  8004a2:	00 00 00 
  8004a5:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8004a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8004ac:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  8004b3:	00 00 00 
  8004b6:	ff d0                	callq  *%rax
}
  8004b8:	5d                   	pop    %rbp
  8004b9:	c3                   	retq   

00000000008004ba <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004ba:	55                   	push   %rbp
  8004bb:	48 89 e5             	mov    %rsp,%rbp
  8004be:	53                   	push   %rbx
  8004bf:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8004c6:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8004cd:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8004d3:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8004da:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8004e1:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8004e8:	84 c0                	test   %al,%al
  8004ea:	74 23                	je     80050f <_panic+0x55>
  8004ec:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8004f3:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8004f7:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8004fb:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8004ff:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800503:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800507:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80050b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80050f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800516:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80051d:	00 00 00 
  800520:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800527:	00 00 00 
  80052a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80052e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800535:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80053c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800543:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80054a:	00 00 00 
  80054d:	48 8b 18             	mov    (%rax),%rbx
  800550:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  800557:	00 00 00 
  80055a:	ff d0                	callq  *%rax
  80055c:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800562:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800569:	41 89 c8             	mov    %ecx,%r8d
  80056c:	48 89 d1             	mov    %rdx,%rcx
  80056f:	48 89 da             	mov    %rbx,%rdx
  800572:	89 c6                	mov    %eax,%esi
  800574:	48 bf 60 45 80 00 00 	movabs $0x804560,%rdi
  80057b:	00 00 00 
  80057e:	b8 00 00 00 00       	mov    $0x0,%eax
  800583:	49 b9 f3 06 80 00 00 	movabs $0x8006f3,%r9
  80058a:	00 00 00 
  80058d:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800590:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800597:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80059e:	48 89 d6             	mov    %rdx,%rsi
  8005a1:	48 89 c7             	mov    %rax,%rdi
  8005a4:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  8005ab:	00 00 00 
  8005ae:	ff d0                	callq  *%rax
	cprintf("\n");
  8005b0:	48 bf 83 45 80 00 00 	movabs $0x804583,%rdi
  8005b7:	00 00 00 
  8005ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bf:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  8005c6:	00 00 00 
  8005c9:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005cb:	cc                   	int3   
  8005cc:	eb fd                	jmp    8005cb <_panic+0x111>

00000000008005ce <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8005ce:	55                   	push   %rbp
  8005cf:	48 89 e5             	mov    %rsp,%rbp
  8005d2:	48 83 ec 10          	sub    $0x10,%rsp
  8005d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8005dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e1:	8b 00                	mov    (%rax),%eax
  8005e3:	8d 48 01             	lea    0x1(%rax),%ecx
  8005e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005ea:	89 0a                	mov    %ecx,(%rdx)
  8005ec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8005ef:	89 d1                	mov    %edx,%ecx
  8005f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005f5:	48 98                	cltq   
  8005f7:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8005fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ff:	8b 00                	mov    (%rax),%eax
  800601:	3d ff 00 00 00       	cmp    $0xff,%eax
  800606:	75 2c                	jne    800634 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80060c:	8b 00                	mov    (%rax),%eax
  80060e:	48 98                	cltq   
  800610:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800614:	48 83 c2 08          	add    $0x8,%rdx
  800618:	48 89 c6             	mov    %rax,%rsi
  80061b:	48 89 d7             	mov    %rdx,%rdi
  80061e:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  800625:	00 00 00 
  800628:	ff d0                	callq  *%rax
        b->idx = 0;
  80062a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800634:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800638:	8b 40 04             	mov    0x4(%rax),%eax
  80063b:	8d 50 01             	lea    0x1(%rax),%edx
  80063e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800642:	89 50 04             	mov    %edx,0x4(%rax)
}
  800645:	c9                   	leaveq 
  800646:	c3                   	retq   

0000000000800647 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800647:	55                   	push   %rbp
  800648:	48 89 e5             	mov    %rsp,%rbp
  80064b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800652:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800659:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800660:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800667:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80066e:	48 8b 0a             	mov    (%rdx),%rcx
  800671:	48 89 08             	mov    %rcx,(%rax)
  800674:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800678:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80067c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800680:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800684:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80068b:	00 00 00 
    b.cnt = 0;
  80068e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800695:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800698:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80069f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006a6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006ad:	48 89 c6             	mov    %rax,%rsi
  8006b0:	48 bf ce 05 80 00 00 	movabs $0x8005ce,%rdi
  8006b7:	00 00 00 
  8006ba:	48 b8 a6 0a 80 00 00 	movabs $0x800aa6,%rax
  8006c1:	00 00 00 
  8006c4:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8006c6:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8006cc:	48 98                	cltq   
  8006ce:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8006d5:	48 83 c2 08          	add    $0x8,%rdx
  8006d9:	48 89 c6             	mov    %rax,%rsi
  8006dc:	48 89 d7             	mov    %rdx,%rdi
  8006df:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  8006e6:	00 00 00 
  8006e9:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8006eb:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8006f1:	c9                   	leaveq 
  8006f2:	c3                   	retq   

00000000008006f3 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8006f3:	55                   	push   %rbp
  8006f4:	48 89 e5             	mov    %rsp,%rbp
  8006f7:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8006fe:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800705:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80070c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800713:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80071a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800721:	84 c0                	test   %al,%al
  800723:	74 20                	je     800745 <cprintf+0x52>
  800725:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800729:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80072d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800731:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800735:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800739:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80073d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800741:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800745:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80074c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800753:	00 00 00 
  800756:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80075d:	00 00 00 
  800760:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800764:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80076b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800772:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800779:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800780:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800787:	48 8b 0a             	mov    (%rdx),%rcx
  80078a:	48 89 08             	mov    %rcx,(%rax)
  80078d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800791:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800795:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800799:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80079d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007a4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007ab:	48 89 d6             	mov    %rdx,%rsi
  8007ae:	48 89 c7             	mov    %rax,%rdi
  8007b1:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  8007b8:	00 00 00 
  8007bb:	ff d0                	callq  *%rax
  8007bd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8007c3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8007c9:	c9                   	leaveq 
  8007ca:	c3                   	retq   

00000000008007cb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007cb:	55                   	push   %rbp
  8007cc:	48 89 e5             	mov    %rsp,%rbp
  8007cf:	53                   	push   %rbx
  8007d0:	48 83 ec 38          	sub    $0x38,%rsp
  8007d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8007dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8007e0:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8007e3:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8007e7:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007eb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8007ee:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8007f2:	77 3b                	ja     80082f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007f4:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8007f7:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8007fb:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8007fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800802:	ba 00 00 00 00       	mov    $0x0,%edx
  800807:	48 f7 f3             	div    %rbx
  80080a:	48 89 c2             	mov    %rax,%rdx
  80080d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800810:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800813:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	41 89 f9             	mov    %edi,%r9d
  80081e:	48 89 c7             	mov    %rax,%rdi
  800821:	48 b8 cb 07 80 00 00 	movabs $0x8007cb,%rax
  800828:	00 00 00 
  80082b:	ff d0                	callq  *%rax
  80082d:	eb 1e                	jmp    80084d <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80082f:	eb 12                	jmp    800843 <printnum+0x78>
			putch(padc, putdat);
  800831:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800835:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800838:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083c:	48 89 ce             	mov    %rcx,%rsi
  80083f:	89 d7                	mov    %edx,%edi
  800841:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800843:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800847:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80084b:	7f e4                	jg     800831 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800850:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800854:	ba 00 00 00 00       	mov    $0x0,%edx
  800859:	48 f7 f1             	div    %rcx
  80085c:	48 89 d0             	mov    %rdx,%rax
  80085f:	48 ba 90 47 80 00 00 	movabs $0x804790,%rdx
  800866:	00 00 00 
  800869:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80086d:	0f be d0             	movsbl %al,%edx
  800870:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	48 89 ce             	mov    %rcx,%rsi
  80087b:	89 d7                	mov    %edx,%edi
  80087d:	ff d0                	callq  *%rax
}
  80087f:	48 83 c4 38          	add    $0x38,%rsp
  800883:	5b                   	pop    %rbx
  800884:	5d                   	pop    %rbp
  800885:	c3                   	retq   

0000000000800886 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800886:	55                   	push   %rbp
  800887:	48 89 e5             	mov    %rsp,%rbp
  80088a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80088e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800892:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800895:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800899:	7e 52                	jle    8008ed <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80089b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089f:	8b 00                	mov    (%rax),%eax
  8008a1:	83 f8 30             	cmp    $0x30,%eax
  8008a4:	73 24                	jae    8008ca <getuint+0x44>
  8008a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008aa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b2:	8b 00                	mov    (%rax),%eax
  8008b4:	89 c0                	mov    %eax,%eax
  8008b6:	48 01 d0             	add    %rdx,%rax
  8008b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bd:	8b 12                	mov    (%rdx),%edx
  8008bf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c6:	89 0a                	mov    %ecx,(%rdx)
  8008c8:	eb 17                	jmp    8008e1 <getuint+0x5b>
  8008ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ce:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008d2:	48 89 d0             	mov    %rdx,%rax
  8008d5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008dd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008e1:	48 8b 00             	mov    (%rax),%rax
  8008e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008e8:	e9 a3 00 00 00       	jmpq   800990 <getuint+0x10a>
	else if (lflag)
  8008ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008f1:	74 4f                	je     800942 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8008f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f7:	8b 00                	mov    (%rax),%eax
  8008f9:	83 f8 30             	cmp    $0x30,%eax
  8008fc:	73 24                	jae    800922 <getuint+0x9c>
  8008fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800902:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800906:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090a:	8b 00                	mov    (%rax),%eax
  80090c:	89 c0                	mov    %eax,%eax
  80090e:	48 01 d0             	add    %rdx,%rax
  800911:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800915:	8b 12                	mov    (%rdx),%edx
  800917:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80091a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091e:	89 0a                	mov    %ecx,(%rdx)
  800920:	eb 17                	jmp    800939 <getuint+0xb3>
  800922:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800926:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80092a:	48 89 d0             	mov    %rdx,%rax
  80092d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800931:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800935:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800939:	48 8b 00             	mov    (%rax),%rax
  80093c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800940:	eb 4e                	jmp    800990 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800946:	8b 00                	mov    (%rax),%eax
  800948:	83 f8 30             	cmp    $0x30,%eax
  80094b:	73 24                	jae    800971 <getuint+0xeb>
  80094d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800951:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800955:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800959:	8b 00                	mov    (%rax),%eax
  80095b:	89 c0                	mov    %eax,%eax
  80095d:	48 01 d0             	add    %rdx,%rax
  800960:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800964:	8b 12                	mov    (%rdx),%edx
  800966:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800969:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096d:	89 0a                	mov    %ecx,(%rdx)
  80096f:	eb 17                	jmp    800988 <getuint+0x102>
  800971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800975:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800979:	48 89 d0             	mov    %rdx,%rax
  80097c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800980:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800984:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800988:	8b 00                	mov    (%rax),%eax
  80098a:	89 c0                	mov    %eax,%eax
  80098c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800990:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800994:	c9                   	leaveq 
  800995:	c3                   	retq   

0000000000800996 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800996:	55                   	push   %rbp
  800997:	48 89 e5             	mov    %rsp,%rbp
  80099a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80099e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009a2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009a5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009a9:	7e 52                	jle    8009fd <getint+0x67>
		x=va_arg(*ap, long long);
  8009ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009af:	8b 00                	mov    (%rax),%eax
  8009b1:	83 f8 30             	cmp    $0x30,%eax
  8009b4:	73 24                	jae    8009da <getint+0x44>
  8009b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ba:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c2:	8b 00                	mov    (%rax),%eax
  8009c4:	89 c0                	mov    %eax,%eax
  8009c6:	48 01 d0             	add    %rdx,%rax
  8009c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cd:	8b 12                	mov    (%rdx),%edx
  8009cf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d6:	89 0a                	mov    %ecx,(%rdx)
  8009d8:	eb 17                	jmp    8009f1 <getint+0x5b>
  8009da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009de:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009e2:	48 89 d0             	mov    %rdx,%rax
  8009e5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ed:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f1:	48 8b 00             	mov    (%rax),%rax
  8009f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009f8:	e9 a3 00 00 00       	jmpq   800aa0 <getint+0x10a>
	else if (lflag)
  8009fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a01:	74 4f                	je     800a52 <getint+0xbc>
		x=va_arg(*ap, long);
  800a03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a07:	8b 00                	mov    (%rax),%eax
  800a09:	83 f8 30             	cmp    $0x30,%eax
  800a0c:	73 24                	jae    800a32 <getint+0x9c>
  800a0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a12:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1a:	8b 00                	mov    (%rax),%eax
  800a1c:	89 c0                	mov    %eax,%eax
  800a1e:	48 01 d0             	add    %rdx,%rax
  800a21:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a25:	8b 12                	mov    (%rdx),%edx
  800a27:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a2a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2e:	89 0a                	mov    %ecx,(%rdx)
  800a30:	eb 17                	jmp    800a49 <getint+0xb3>
  800a32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a36:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a3a:	48 89 d0             	mov    %rdx,%rax
  800a3d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a41:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a45:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a49:	48 8b 00             	mov    (%rax),%rax
  800a4c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a50:	eb 4e                	jmp    800aa0 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a56:	8b 00                	mov    (%rax),%eax
  800a58:	83 f8 30             	cmp    $0x30,%eax
  800a5b:	73 24                	jae    800a81 <getint+0xeb>
  800a5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a61:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a69:	8b 00                	mov    (%rax),%eax
  800a6b:	89 c0                	mov    %eax,%eax
  800a6d:	48 01 d0             	add    %rdx,%rax
  800a70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a74:	8b 12                	mov    (%rdx),%edx
  800a76:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7d:	89 0a                	mov    %ecx,(%rdx)
  800a7f:	eb 17                	jmp    800a98 <getint+0x102>
  800a81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a85:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a89:	48 89 d0             	mov    %rdx,%rax
  800a8c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a94:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a98:	8b 00                	mov    (%rax),%eax
  800a9a:	48 98                	cltq   
  800a9c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aa0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800aa4:	c9                   	leaveq 
  800aa5:	c3                   	retq   

0000000000800aa6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800aa6:	55                   	push   %rbp
  800aa7:	48 89 e5             	mov    %rsp,%rbp
  800aaa:	41 54                	push   %r12
  800aac:	53                   	push   %rbx
  800aad:	48 83 ec 60          	sub    $0x60,%rsp
  800ab1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ab5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ab9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800abd:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ac1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ac9:	48 8b 0a             	mov    (%rdx),%rcx
  800acc:	48 89 08             	mov    %rcx,(%rax)
  800acf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ad3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ad7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800adb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800adf:	eb 28                	jmp    800b09 <vprintfmt+0x63>
			if (ch == '\0'){
  800ae1:	85 db                	test   %ebx,%ebx
  800ae3:	75 15                	jne    800afa <vprintfmt+0x54>
				current_color=WHITE;
  800ae5:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800aec:	00 00 00 
  800aef:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800af5:	e9 fc 04 00 00       	jmpq   800ff6 <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  800afa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800afe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b02:	48 89 d6             	mov    %rdx,%rsi
  800b05:	89 df                	mov    %ebx,%edi
  800b07:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b09:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b0d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b11:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b15:	0f b6 00             	movzbl (%rax),%eax
  800b18:	0f b6 d8             	movzbl %al,%ebx
  800b1b:	83 fb 25             	cmp    $0x25,%ebx
  800b1e:	75 c1                	jne    800ae1 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b20:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b24:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b2b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b32:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b39:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b40:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b44:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b48:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b4c:	0f b6 00             	movzbl (%rax),%eax
  800b4f:	0f b6 d8             	movzbl %al,%ebx
  800b52:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b55:	83 f8 55             	cmp    $0x55,%eax
  800b58:	0f 87 64 04 00 00    	ja     800fc2 <vprintfmt+0x51c>
  800b5e:	89 c0                	mov    %eax,%eax
  800b60:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b67:	00 
  800b68:	48 b8 b8 47 80 00 00 	movabs $0x8047b8,%rax
  800b6f:	00 00 00 
  800b72:	48 01 d0             	add    %rdx,%rax
  800b75:	48 8b 00             	mov    (%rax),%rax
  800b78:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800b7a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b7e:	eb c0                	jmp    800b40 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b80:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b84:	eb ba                	jmp    800b40 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b86:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b8d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b90:	89 d0                	mov    %edx,%eax
  800b92:	c1 e0 02             	shl    $0x2,%eax
  800b95:	01 d0                	add    %edx,%eax
  800b97:	01 c0                	add    %eax,%eax
  800b99:	01 d8                	add    %ebx,%eax
  800b9b:	83 e8 30             	sub    $0x30,%eax
  800b9e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ba1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba5:	0f b6 00             	movzbl (%rax),%eax
  800ba8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bab:	83 fb 2f             	cmp    $0x2f,%ebx
  800bae:	7e 0c                	jle    800bbc <vprintfmt+0x116>
  800bb0:	83 fb 39             	cmp    $0x39,%ebx
  800bb3:	7f 07                	jg     800bbc <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bb5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bba:	eb d1                	jmp    800b8d <vprintfmt+0xe7>
			goto process_precision;
  800bbc:	eb 58                	jmp    800c16 <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800bbe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc1:	83 f8 30             	cmp    $0x30,%eax
  800bc4:	73 17                	jae    800bdd <vprintfmt+0x137>
  800bc6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcd:	89 c0                	mov    %eax,%eax
  800bcf:	48 01 d0             	add    %rdx,%rax
  800bd2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd5:	83 c2 08             	add    $0x8,%edx
  800bd8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bdb:	eb 0f                	jmp    800bec <vprintfmt+0x146>
  800bdd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be1:	48 89 d0             	mov    %rdx,%rax
  800be4:	48 83 c2 08          	add    $0x8,%rdx
  800be8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bec:	8b 00                	mov    (%rax),%eax
  800bee:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800bf1:	eb 23                	jmp    800c16 <vprintfmt+0x170>

		case '.':
			if (width < 0)
  800bf3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bf7:	79 0c                	jns    800c05 <vprintfmt+0x15f>
				width = 0;
  800bf9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c00:	e9 3b ff ff ff       	jmpq   800b40 <vprintfmt+0x9a>
  800c05:	e9 36 ff ff ff       	jmpq   800b40 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  800c0a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c11:	e9 2a ff ff ff       	jmpq   800b40 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  800c16:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c1a:	79 12                	jns    800c2e <vprintfmt+0x188>
				width = precision, precision = -1;
  800c1c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c1f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c22:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c29:	e9 12 ff ff ff       	jmpq   800b40 <vprintfmt+0x9a>
  800c2e:	e9 0d ff ff ff       	jmpq   800b40 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c33:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c37:	e9 04 ff ff ff       	jmpq   800b40 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3f:	83 f8 30             	cmp    $0x30,%eax
  800c42:	73 17                	jae    800c5b <vprintfmt+0x1b5>
  800c44:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4b:	89 c0                	mov    %eax,%eax
  800c4d:	48 01 d0             	add    %rdx,%rax
  800c50:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c53:	83 c2 08             	add    $0x8,%edx
  800c56:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c59:	eb 0f                	jmp    800c6a <vprintfmt+0x1c4>
  800c5b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c5f:	48 89 d0             	mov    %rdx,%rax
  800c62:	48 83 c2 08          	add    $0x8,%rdx
  800c66:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c6a:	8b 10                	mov    (%rax),%edx
  800c6c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c74:	48 89 ce             	mov    %rcx,%rsi
  800c77:	89 d7                	mov    %edx,%edi
  800c79:	ff d0                	callq  *%rax
			break;
  800c7b:	e9 70 03 00 00       	jmpq   800ff0 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800c80:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c83:	83 f8 30             	cmp    $0x30,%eax
  800c86:	73 17                	jae    800c9f <vprintfmt+0x1f9>
  800c88:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c8c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8f:	89 c0                	mov    %eax,%eax
  800c91:	48 01 d0             	add    %rdx,%rax
  800c94:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c97:	83 c2 08             	add    $0x8,%edx
  800c9a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c9d:	eb 0f                	jmp    800cae <vprintfmt+0x208>
  800c9f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ca3:	48 89 d0             	mov    %rdx,%rax
  800ca6:	48 83 c2 08          	add    $0x8,%rdx
  800caa:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cae:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cb0:	85 db                	test   %ebx,%ebx
  800cb2:	79 02                	jns    800cb6 <vprintfmt+0x210>
				err = -err;
  800cb4:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cb6:	83 fb 15             	cmp    $0x15,%ebx
  800cb9:	7f 16                	jg     800cd1 <vprintfmt+0x22b>
  800cbb:	48 b8 e0 46 80 00 00 	movabs $0x8046e0,%rax
  800cc2:	00 00 00 
  800cc5:	48 63 d3             	movslq %ebx,%rdx
  800cc8:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ccc:	4d 85 e4             	test   %r12,%r12
  800ccf:	75 2e                	jne    800cff <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  800cd1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cd5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd9:	89 d9                	mov    %ebx,%ecx
  800cdb:	48 ba a1 47 80 00 00 	movabs $0x8047a1,%rdx
  800ce2:	00 00 00 
  800ce5:	48 89 c7             	mov    %rax,%rdi
  800ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ced:	49 b8 ff 0f 80 00 00 	movabs $0x800fff,%r8
  800cf4:	00 00 00 
  800cf7:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cfa:	e9 f1 02 00 00       	jmpq   800ff0 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cff:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d03:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d07:	4c 89 e1             	mov    %r12,%rcx
  800d0a:	48 ba aa 47 80 00 00 	movabs $0x8047aa,%rdx
  800d11:	00 00 00 
  800d14:	48 89 c7             	mov    %rax,%rdi
  800d17:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1c:	49 b8 ff 0f 80 00 00 	movabs $0x800fff,%r8
  800d23:	00 00 00 
  800d26:	41 ff d0             	callq  *%r8
			break;
  800d29:	e9 c2 02 00 00       	jmpq   800ff0 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d2e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d31:	83 f8 30             	cmp    $0x30,%eax
  800d34:	73 17                	jae    800d4d <vprintfmt+0x2a7>
  800d36:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3d:	89 c0                	mov    %eax,%eax
  800d3f:	48 01 d0             	add    %rdx,%rax
  800d42:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d45:	83 c2 08             	add    $0x8,%edx
  800d48:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d4b:	eb 0f                	jmp    800d5c <vprintfmt+0x2b6>
  800d4d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d51:	48 89 d0             	mov    %rdx,%rax
  800d54:	48 83 c2 08          	add    $0x8,%rdx
  800d58:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d5c:	4c 8b 20             	mov    (%rax),%r12
  800d5f:	4d 85 e4             	test   %r12,%r12
  800d62:	75 0a                	jne    800d6e <vprintfmt+0x2c8>
				p = "(null)";
  800d64:	49 bc ad 47 80 00 00 	movabs $0x8047ad,%r12
  800d6b:	00 00 00 
			if (width > 0 && padc != '-')
  800d6e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d72:	7e 3f                	jle    800db3 <vprintfmt+0x30d>
  800d74:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d78:	74 39                	je     800db3 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d7a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d7d:	48 98                	cltq   
  800d7f:	48 89 c6             	mov    %rax,%rsi
  800d82:	4c 89 e7             	mov    %r12,%rdi
  800d85:	48 b8 ab 12 80 00 00 	movabs $0x8012ab,%rax
  800d8c:	00 00 00 
  800d8f:	ff d0                	callq  *%rax
  800d91:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d94:	eb 17                	jmp    800dad <vprintfmt+0x307>
					putch(padc, putdat);
  800d96:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d9a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da2:	48 89 ce             	mov    %rcx,%rsi
  800da5:	89 d7                	mov    %edx,%edi
  800da7:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800da9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dad:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800db1:	7f e3                	jg     800d96 <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800db3:	eb 37                	jmp    800dec <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  800db5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800db9:	74 1e                	je     800dd9 <vprintfmt+0x333>
  800dbb:	83 fb 1f             	cmp    $0x1f,%ebx
  800dbe:	7e 05                	jle    800dc5 <vprintfmt+0x31f>
  800dc0:	83 fb 7e             	cmp    $0x7e,%ebx
  800dc3:	7e 14                	jle    800dd9 <vprintfmt+0x333>
					putch('?', putdat);
  800dc5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dcd:	48 89 d6             	mov    %rdx,%rsi
  800dd0:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800dd5:	ff d0                	callq  *%rax
  800dd7:	eb 0f                	jmp    800de8 <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800dd9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ddd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de1:	48 89 d6             	mov    %rdx,%rsi
  800de4:	89 df                	mov    %ebx,%edi
  800de6:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800de8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dec:	4c 89 e0             	mov    %r12,%rax
  800def:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800df3:	0f b6 00             	movzbl (%rax),%eax
  800df6:	0f be d8             	movsbl %al,%ebx
  800df9:	85 db                	test   %ebx,%ebx
  800dfb:	74 10                	je     800e0d <vprintfmt+0x367>
  800dfd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e01:	78 b2                	js     800db5 <vprintfmt+0x30f>
  800e03:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e07:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e0b:	79 a8                	jns    800db5 <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e0d:	eb 16                	jmp    800e25 <vprintfmt+0x37f>
				putch(' ', putdat);
  800e0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e17:	48 89 d6             	mov    %rdx,%rsi
  800e1a:	bf 20 00 00 00       	mov    $0x20,%edi
  800e1f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e21:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e25:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e29:	7f e4                	jg     800e0f <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800e2b:	e9 c0 01 00 00       	jmpq   800ff0 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e30:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e34:	be 03 00 00 00       	mov    $0x3,%esi
  800e39:	48 89 c7             	mov    %rax,%rdi
  800e3c:	48 b8 96 09 80 00 00 	movabs $0x800996,%rax
  800e43:	00 00 00 
  800e46:	ff d0                	callq  *%rax
  800e48:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e50:	48 85 c0             	test   %rax,%rax
  800e53:	79 1d                	jns    800e72 <vprintfmt+0x3cc>
				putch('-', putdat);
  800e55:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5d:	48 89 d6             	mov    %rdx,%rsi
  800e60:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e65:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6b:	48 f7 d8             	neg    %rax
  800e6e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e72:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e79:	e9 d5 00 00 00       	jmpq   800f53 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e7e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e82:	be 03 00 00 00       	mov    $0x3,%esi
  800e87:	48 89 c7             	mov    %rax,%rdi
  800e8a:	48 b8 86 08 80 00 00 	movabs $0x800886,%rax
  800e91:	00 00 00 
  800e94:	ff d0                	callq  *%rax
  800e96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e9a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ea1:	e9 ad 00 00 00       	jmpq   800f53 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800ea6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eaa:	be 03 00 00 00       	mov    $0x3,%esi
  800eaf:	48 89 c7             	mov    %rax,%rdi
  800eb2:	48 b8 86 08 80 00 00 	movabs $0x800886,%rax
  800eb9:	00 00 00 
  800ebc:	ff d0                	callq  *%rax
  800ebe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ec2:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ec9:	e9 85 00 00 00       	jmpq   800f53 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800ece:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed6:	48 89 d6             	mov    %rdx,%rsi
  800ed9:	bf 30 00 00 00       	mov    $0x30,%edi
  800ede:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ee0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee8:	48 89 d6             	mov    %rdx,%rsi
  800eeb:	bf 78 00 00 00       	mov    $0x78,%edi
  800ef0:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ef2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ef5:	83 f8 30             	cmp    $0x30,%eax
  800ef8:	73 17                	jae    800f11 <vprintfmt+0x46b>
  800efa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800efe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f01:	89 c0                	mov    %eax,%eax
  800f03:	48 01 d0             	add    %rdx,%rax
  800f06:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f09:	83 c2 08             	add    $0x8,%edx
  800f0c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f0f:	eb 0f                	jmp    800f20 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  800f11:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f15:	48 89 d0             	mov    %rdx,%rax
  800f18:	48 83 c2 08          	add    $0x8,%rdx
  800f1c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f20:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f23:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f27:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f2e:	eb 23                	jmp    800f53 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f30:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f34:	be 03 00 00 00       	mov    $0x3,%esi
  800f39:	48 89 c7             	mov    %rax,%rdi
  800f3c:	48 b8 86 08 80 00 00 	movabs $0x800886,%rax
  800f43:	00 00 00 
  800f46:	ff d0                	callq  *%rax
  800f48:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f4c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f53:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f58:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f5b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f5e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f62:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f6a:	45 89 c1             	mov    %r8d,%r9d
  800f6d:	41 89 f8             	mov    %edi,%r8d
  800f70:	48 89 c7             	mov    %rax,%rdi
  800f73:	48 b8 cb 07 80 00 00 	movabs $0x8007cb,%rax
  800f7a:	00 00 00 
  800f7d:	ff d0                	callq  *%rax
			break;
  800f7f:	eb 6f                	jmp    800ff0 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f89:	48 89 d6             	mov    %rdx,%rsi
  800f8c:	89 df                	mov    %ebx,%edi
  800f8e:	ff d0                	callq  *%rax
			break;
  800f90:	eb 5e                	jmp    800ff0 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  800f92:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f96:	be 03 00 00 00       	mov    $0x3,%esi
  800f9b:	48 89 c7             	mov    %rax,%rdi
  800f9e:	48 b8 86 08 80 00 00 	movabs $0x800886,%rax
  800fa5:	00 00 00 
  800fa8:	ff d0                	callq  *%rax
  800faa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  800fae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb2:	89 c2                	mov    %eax,%edx
  800fb4:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800fbb:	00 00 00 
  800fbe:	89 10                	mov    %edx,(%rax)
			break;
  800fc0:	eb 2e                	jmp    800ff0 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fc2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fca:	48 89 d6             	mov    %rdx,%rsi
  800fcd:	bf 25 00 00 00       	mov    $0x25,%edi
  800fd2:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fd4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fd9:	eb 05                	jmp    800fe0 <vprintfmt+0x53a>
  800fdb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fe0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fe4:	48 83 e8 01          	sub    $0x1,%rax
  800fe8:	0f b6 00             	movzbl (%rax),%eax
  800feb:	3c 25                	cmp    $0x25,%al
  800fed:	75 ec                	jne    800fdb <vprintfmt+0x535>
				/* do nothing */;
			break;
  800fef:	90                   	nop
		}
	}
  800ff0:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ff1:	e9 13 fb ff ff       	jmpq   800b09 <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ff6:	48 83 c4 60          	add    $0x60,%rsp
  800ffa:	5b                   	pop    %rbx
  800ffb:	41 5c                	pop    %r12
  800ffd:	5d                   	pop    %rbp
  800ffe:	c3                   	retq   

0000000000800fff <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fff:	55                   	push   %rbp
  801000:	48 89 e5             	mov    %rsp,%rbp
  801003:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80100a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801011:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801018:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80101f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801026:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80102d:	84 c0                	test   %al,%al
  80102f:	74 20                	je     801051 <printfmt+0x52>
  801031:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801035:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801039:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80103d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801041:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801045:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801049:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80104d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801051:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801058:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80105f:	00 00 00 
  801062:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801069:	00 00 00 
  80106c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801070:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801077:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80107e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801085:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80108c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801093:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80109a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010a1:	48 89 c7             	mov    %rax,%rdi
  8010a4:	48 b8 a6 0a 80 00 00 	movabs $0x800aa6,%rax
  8010ab:	00 00 00 
  8010ae:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010b0:	c9                   	leaveq 
  8010b1:	c3                   	retq   

00000000008010b2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010b2:	55                   	push   %rbp
  8010b3:	48 89 e5             	mov    %rsp,%rbp
  8010b6:	48 83 ec 10          	sub    $0x10,%rsp
  8010ba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c5:	8b 40 10             	mov    0x10(%rax),%eax
  8010c8:	8d 50 01             	lea    0x1(%rax),%edx
  8010cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cf:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d6:	48 8b 10             	mov    (%rax),%rdx
  8010d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010dd:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010e1:	48 39 c2             	cmp    %rax,%rdx
  8010e4:	73 17                	jae    8010fd <sprintputch+0x4b>
		*b->buf++ = ch;
  8010e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ea:	48 8b 00             	mov    (%rax),%rax
  8010ed:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010f5:	48 89 0a             	mov    %rcx,(%rdx)
  8010f8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010fb:	88 10                	mov    %dl,(%rax)
}
  8010fd:	c9                   	leaveq 
  8010fe:	c3                   	retq   

00000000008010ff <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010ff:	55                   	push   %rbp
  801100:	48 89 e5             	mov    %rsp,%rbp
  801103:	48 83 ec 50          	sub    $0x50,%rsp
  801107:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80110b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80110e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801112:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801116:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80111a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80111e:	48 8b 0a             	mov    (%rdx),%rcx
  801121:	48 89 08             	mov    %rcx,(%rax)
  801124:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801128:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80112c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801130:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801134:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801138:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80113c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80113f:	48 98                	cltq   
  801141:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801145:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801149:	48 01 d0             	add    %rdx,%rax
  80114c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801150:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801157:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80115c:	74 06                	je     801164 <vsnprintf+0x65>
  80115e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801162:	7f 07                	jg     80116b <vsnprintf+0x6c>
		return -E_INVAL;
  801164:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801169:	eb 2f                	jmp    80119a <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80116b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80116f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801173:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801177:	48 89 c6             	mov    %rax,%rsi
  80117a:	48 bf b2 10 80 00 00 	movabs $0x8010b2,%rdi
  801181:	00 00 00 
  801184:	48 b8 a6 0a 80 00 00 	movabs $0x800aa6,%rax
  80118b:	00 00 00 
  80118e:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801190:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801194:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801197:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80119a:	c9                   	leaveq 
  80119b:	c3                   	retq   

000000000080119c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80119c:	55                   	push   %rbp
  80119d:	48 89 e5             	mov    %rsp,%rbp
  8011a0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011a7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011ae:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011b4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011bb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011c2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011c9:	84 c0                	test   %al,%al
  8011cb:	74 20                	je     8011ed <snprintf+0x51>
  8011cd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011d1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011d5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011d9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011dd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011e1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011e5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011e9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011ed:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011f4:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011fb:	00 00 00 
  8011fe:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801205:	00 00 00 
  801208:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80120c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801213:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80121a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801221:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801228:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80122f:	48 8b 0a             	mov    (%rdx),%rcx
  801232:	48 89 08             	mov    %rcx,(%rax)
  801235:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801239:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80123d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801241:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801245:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80124c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801253:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801259:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801260:	48 89 c7             	mov    %rax,%rdi
  801263:	48 b8 ff 10 80 00 00 	movabs $0x8010ff,%rax
  80126a:	00 00 00 
  80126d:	ff d0                	callq  *%rax
  80126f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801275:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80127b:	c9                   	leaveq 
  80127c:	c3                   	retq   

000000000080127d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80127d:	55                   	push   %rbp
  80127e:	48 89 e5             	mov    %rsp,%rbp
  801281:	48 83 ec 18          	sub    $0x18,%rsp
  801285:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801290:	eb 09                	jmp    80129b <strlen+0x1e>
		n++;
  801292:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801296:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80129b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129f:	0f b6 00             	movzbl (%rax),%eax
  8012a2:	84 c0                	test   %al,%al
  8012a4:	75 ec                	jne    801292 <strlen+0x15>
		n++;
	return n;
  8012a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012a9:	c9                   	leaveq 
  8012aa:	c3                   	retq   

00000000008012ab <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012ab:	55                   	push   %rbp
  8012ac:	48 89 e5             	mov    %rsp,%rbp
  8012af:	48 83 ec 20          	sub    $0x20,%rsp
  8012b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012c2:	eb 0e                	jmp    8012d2 <strnlen+0x27>
		n++;
  8012c4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012c8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012cd:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012d2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012d7:	74 0b                	je     8012e4 <strnlen+0x39>
  8012d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012dd:	0f b6 00             	movzbl (%rax),%eax
  8012e0:	84 c0                	test   %al,%al
  8012e2:	75 e0                	jne    8012c4 <strnlen+0x19>
		n++;
	return n;
  8012e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012e7:	c9                   	leaveq 
  8012e8:	c3                   	retq   

00000000008012e9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012e9:	55                   	push   %rbp
  8012ea:	48 89 e5             	mov    %rsp,%rbp
  8012ed:	48 83 ec 20          	sub    $0x20,%rsp
  8012f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801301:	90                   	nop
  801302:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801306:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80130a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80130e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801312:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801316:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80131a:	0f b6 12             	movzbl (%rdx),%edx
  80131d:	88 10                	mov    %dl,(%rax)
  80131f:	0f b6 00             	movzbl (%rax),%eax
  801322:	84 c0                	test   %al,%al
  801324:	75 dc                	jne    801302 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801326:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80132a:	c9                   	leaveq 
  80132b:	c3                   	retq   

000000000080132c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80132c:	55                   	push   %rbp
  80132d:	48 89 e5             	mov    %rsp,%rbp
  801330:	48 83 ec 20          	sub    $0x20,%rsp
  801334:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801338:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80133c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801340:	48 89 c7             	mov    %rax,%rdi
  801343:	48 b8 7d 12 80 00 00 	movabs $0x80127d,%rax
  80134a:	00 00 00 
  80134d:	ff d0                	callq  *%rax
  80134f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801352:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801355:	48 63 d0             	movslq %eax,%rdx
  801358:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135c:	48 01 c2             	add    %rax,%rdx
  80135f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801363:	48 89 c6             	mov    %rax,%rsi
  801366:	48 89 d7             	mov    %rdx,%rdi
  801369:	48 b8 e9 12 80 00 00 	movabs $0x8012e9,%rax
  801370:	00 00 00 
  801373:	ff d0                	callq  *%rax
	return dst;
  801375:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801379:	c9                   	leaveq 
  80137a:	c3                   	retq   

000000000080137b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80137b:	55                   	push   %rbp
  80137c:	48 89 e5             	mov    %rsp,%rbp
  80137f:	48 83 ec 28          	sub    $0x28,%rsp
  801383:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801387:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80138b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80138f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801393:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801397:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80139e:	00 
  80139f:	eb 2a                	jmp    8013cb <strncpy+0x50>
		*dst++ = *src;
  8013a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013a9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013ad:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013b1:	0f b6 12             	movzbl (%rdx),%edx
  8013b4:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ba:	0f b6 00             	movzbl (%rax),%eax
  8013bd:	84 c0                	test   %al,%al
  8013bf:	74 05                	je     8013c6 <strncpy+0x4b>
			src++;
  8013c1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013c6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cf:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013d3:	72 cc                	jb     8013a1 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013d9:	c9                   	leaveq 
  8013da:	c3                   	retq   

00000000008013db <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013db:	55                   	push   %rbp
  8013dc:	48 89 e5             	mov    %rsp,%rbp
  8013df:	48 83 ec 28          	sub    $0x28,%rsp
  8013e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013f7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013fc:	74 3d                	je     80143b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013fe:	eb 1d                	jmp    80141d <strlcpy+0x42>
			*dst++ = *src++;
  801400:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801404:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801408:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80140c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801410:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801414:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801418:	0f b6 12             	movzbl (%rdx),%edx
  80141b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80141d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801422:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801427:	74 0b                	je     801434 <strlcpy+0x59>
  801429:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80142d:	0f b6 00             	movzbl (%rax),%eax
  801430:	84 c0                	test   %al,%al
  801432:	75 cc                	jne    801400 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801438:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80143b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80143f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801443:	48 29 c2             	sub    %rax,%rdx
  801446:	48 89 d0             	mov    %rdx,%rax
}
  801449:	c9                   	leaveq 
  80144a:	c3                   	retq   

000000000080144b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80144b:	55                   	push   %rbp
  80144c:	48 89 e5             	mov    %rsp,%rbp
  80144f:	48 83 ec 10          	sub    $0x10,%rsp
  801453:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801457:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80145b:	eb 0a                	jmp    801467 <strcmp+0x1c>
		p++, q++;
  80145d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801462:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801467:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146b:	0f b6 00             	movzbl (%rax),%eax
  80146e:	84 c0                	test   %al,%al
  801470:	74 12                	je     801484 <strcmp+0x39>
  801472:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801476:	0f b6 10             	movzbl (%rax),%edx
  801479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147d:	0f b6 00             	movzbl (%rax),%eax
  801480:	38 c2                	cmp    %al,%dl
  801482:	74 d9                	je     80145d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801484:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801488:	0f b6 00             	movzbl (%rax),%eax
  80148b:	0f b6 d0             	movzbl %al,%edx
  80148e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801492:	0f b6 00             	movzbl (%rax),%eax
  801495:	0f b6 c0             	movzbl %al,%eax
  801498:	29 c2                	sub    %eax,%edx
  80149a:	89 d0                	mov    %edx,%eax
}
  80149c:	c9                   	leaveq 
  80149d:	c3                   	retq   

000000000080149e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80149e:	55                   	push   %rbp
  80149f:	48 89 e5             	mov    %rsp,%rbp
  8014a2:	48 83 ec 18          	sub    $0x18,%rsp
  8014a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014ae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014b2:	eb 0f                	jmp    8014c3 <strncmp+0x25>
		n--, p++, q++;
  8014b4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014be:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014c3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014c8:	74 1d                	je     8014e7 <strncmp+0x49>
  8014ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ce:	0f b6 00             	movzbl (%rax),%eax
  8014d1:	84 c0                	test   %al,%al
  8014d3:	74 12                	je     8014e7 <strncmp+0x49>
  8014d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d9:	0f b6 10             	movzbl (%rax),%edx
  8014dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e0:	0f b6 00             	movzbl (%rax),%eax
  8014e3:	38 c2                	cmp    %al,%dl
  8014e5:	74 cd                	je     8014b4 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014e7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014ec:	75 07                	jne    8014f5 <strncmp+0x57>
		return 0;
  8014ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f3:	eb 18                	jmp    80150d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f9:	0f b6 00             	movzbl (%rax),%eax
  8014fc:	0f b6 d0             	movzbl %al,%edx
  8014ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801503:	0f b6 00             	movzbl (%rax),%eax
  801506:	0f b6 c0             	movzbl %al,%eax
  801509:	29 c2                	sub    %eax,%edx
  80150b:	89 d0                	mov    %edx,%eax
}
  80150d:	c9                   	leaveq 
  80150e:	c3                   	retq   

000000000080150f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80150f:	55                   	push   %rbp
  801510:	48 89 e5             	mov    %rsp,%rbp
  801513:	48 83 ec 0c          	sub    $0xc,%rsp
  801517:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80151b:	89 f0                	mov    %esi,%eax
  80151d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801520:	eb 17                	jmp    801539 <strchr+0x2a>
		if (*s == c)
  801522:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801526:	0f b6 00             	movzbl (%rax),%eax
  801529:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80152c:	75 06                	jne    801534 <strchr+0x25>
			return (char *) s;
  80152e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801532:	eb 15                	jmp    801549 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801534:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801539:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153d:	0f b6 00             	movzbl (%rax),%eax
  801540:	84 c0                	test   %al,%al
  801542:	75 de                	jne    801522 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801544:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801549:	c9                   	leaveq 
  80154a:	c3                   	retq   

000000000080154b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80154b:	55                   	push   %rbp
  80154c:	48 89 e5             	mov    %rsp,%rbp
  80154f:	48 83 ec 0c          	sub    $0xc,%rsp
  801553:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801557:	89 f0                	mov    %esi,%eax
  801559:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80155c:	eb 13                	jmp    801571 <strfind+0x26>
		if (*s == c)
  80155e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801562:	0f b6 00             	movzbl (%rax),%eax
  801565:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801568:	75 02                	jne    80156c <strfind+0x21>
			break;
  80156a:	eb 10                	jmp    80157c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80156c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801575:	0f b6 00             	movzbl (%rax),%eax
  801578:	84 c0                	test   %al,%al
  80157a:	75 e2                	jne    80155e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80157c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801580:	c9                   	leaveq 
  801581:	c3                   	retq   

0000000000801582 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801582:	55                   	push   %rbp
  801583:	48 89 e5             	mov    %rsp,%rbp
  801586:	48 83 ec 18          	sub    $0x18,%rsp
  80158a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80158e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801591:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801595:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80159a:	75 06                	jne    8015a2 <memset+0x20>
		return v;
  80159c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a0:	eb 69                	jmp    80160b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a6:	83 e0 03             	and    $0x3,%eax
  8015a9:	48 85 c0             	test   %rax,%rax
  8015ac:	75 48                	jne    8015f6 <memset+0x74>
  8015ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b2:	83 e0 03             	and    $0x3,%eax
  8015b5:	48 85 c0             	test   %rax,%rax
  8015b8:	75 3c                	jne    8015f6 <memset+0x74>
		c &= 0xFF;
  8015ba:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c4:	c1 e0 18             	shl    $0x18,%eax
  8015c7:	89 c2                	mov    %eax,%edx
  8015c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015cc:	c1 e0 10             	shl    $0x10,%eax
  8015cf:	09 c2                	or     %eax,%edx
  8015d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015d4:	c1 e0 08             	shl    $0x8,%eax
  8015d7:	09 d0                	or     %edx,%eax
  8015d9:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e0:	48 c1 e8 02          	shr    $0x2,%rax
  8015e4:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015e7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ee:	48 89 d7             	mov    %rdx,%rdi
  8015f1:	fc                   	cld    
  8015f2:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015f4:	eb 11                	jmp    801607 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015fd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801601:	48 89 d7             	mov    %rdx,%rdi
  801604:	fc                   	cld    
  801605:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801607:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80160b:	c9                   	leaveq 
  80160c:	c3                   	retq   

000000000080160d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80160d:	55                   	push   %rbp
  80160e:	48 89 e5             	mov    %rsp,%rbp
  801611:	48 83 ec 28          	sub    $0x28,%rsp
  801615:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801619:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80161d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801621:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801625:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801629:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80162d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801631:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801635:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801639:	0f 83 88 00 00 00    	jae    8016c7 <memmove+0xba>
  80163f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801643:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801647:	48 01 d0             	add    %rdx,%rax
  80164a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80164e:	76 77                	jbe    8016c7 <memmove+0xba>
		s += n;
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801660:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801664:	83 e0 03             	and    $0x3,%eax
  801667:	48 85 c0             	test   %rax,%rax
  80166a:	75 3b                	jne    8016a7 <memmove+0x9a>
  80166c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801670:	83 e0 03             	and    $0x3,%eax
  801673:	48 85 c0             	test   %rax,%rax
  801676:	75 2f                	jne    8016a7 <memmove+0x9a>
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	83 e0 03             	and    $0x3,%eax
  80167f:	48 85 c0             	test   %rax,%rax
  801682:	75 23                	jne    8016a7 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801684:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801688:	48 83 e8 04          	sub    $0x4,%rax
  80168c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801690:	48 83 ea 04          	sub    $0x4,%rdx
  801694:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801698:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80169c:	48 89 c7             	mov    %rax,%rdi
  80169f:	48 89 d6             	mov    %rdx,%rsi
  8016a2:	fd                   	std    
  8016a3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016a5:	eb 1d                	jmp    8016c4 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ab:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bb:	48 89 d7             	mov    %rdx,%rdi
  8016be:	48 89 c1             	mov    %rax,%rcx
  8016c1:	fd                   	std    
  8016c2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016c4:	fc                   	cld    
  8016c5:	eb 57                	jmp    80171e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cb:	83 e0 03             	and    $0x3,%eax
  8016ce:	48 85 c0             	test   %rax,%rax
  8016d1:	75 36                	jne    801709 <memmove+0xfc>
  8016d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d7:	83 e0 03             	and    $0x3,%eax
  8016da:	48 85 c0             	test   %rax,%rax
  8016dd:	75 2a                	jne    801709 <memmove+0xfc>
  8016df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e3:	83 e0 03             	and    $0x3,%eax
  8016e6:	48 85 c0             	test   %rax,%rax
  8016e9:	75 1e                	jne    801709 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ef:	48 c1 e8 02          	shr    $0x2,%rax
  8016f3:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016fe:	48 89 c7             	mov    %rax,%rdi
  801701:	48 89 d6             	mov    %rdx,%rsi
  801704:	fc                   	cld    
  801705:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801707:	eb 15                	jmp    80171e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801709:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801711:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801715:	48 89 c7             	mov    %rax,%rdi
  801718:	48 89 d6             	mov    %rdx,%rsi
  80171b:	fc                   	cld    
  80171c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80171e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801722:	c9                   	leaveq 
  801723:	c3                   	retq   

0000000000801724 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801724:	55                   	push   %rbp
  801725:	48 89 e5             	mov    %rsp,%rbp
  801728:	48 83 ec 18          	sub    $0x18,%rsp
  80172c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801730:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801734:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801738:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80173c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801740:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801744:	48 89 ce             	mov    %rcx,%rsi
  801747:	48 89 c7             	mov    %rax,%rdi
  80174a:	48 b8 0d 16 80 00 00 	movabs $0x80160d,%rax
  801751:	00 00 00 
  801754:	ff d0                	callq  *%rax
}
  801756:	c9                   	leaveq 
  801757:	c3                   	retq   

0000000000801758 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801758:	55                   	push   %rbp
  801759:	48 89 e5             	mov    %rsp,%rbp
  80175c:	48 83 ec 28          	sub    $0x28,%rsp
  801760:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801764:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801768:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80176c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801770:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801774:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801778:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80177c:	eb 36                	jmp    8017b4 <memcmp+0x5c>
		if (*s1 != *s2)
  80177e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801782:	0f b6 10             	movzbl (%rax),%edx
  801785:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801789:	0f b6 00             	movzbl (%rax),%eax
  80178c:	38 c2                	cmp    %al,%dl
  80178e:	74 1a                	je     8017aa <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801790:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801794:	0f b6 00             	movzbl (%rax),%eax
  801797:	0f b6 d0             	movzbl %al,%edx
  80179a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179e:	0f b6 00             	movzbl (%rax),%eax
  8017a1:	0f b6 c0             	movzbl %al,%eax
  8017a4:	29 c2                	sub    %eax,%edx
  8017a6:	89 d0                	mov    %edx,%eax
  8017a8:	eb 20                	jmp    8017ca <memcmp+0x72>
		s1++, s2++;
  8017aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017af:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017c0:	48 85 c0             	test   %rax,%rax
  8017c3:	75 b9                	jne    80177e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ca:	c9                   	leaveq 
  8017cb:	c3                   	retq   

00000000008017cc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017cc:	55                   	push   %rbp
  8017cd:	48 89 e5             	mov    %rsp,%rbp
  8017d0:	48 83 ec 28          	sub    $0x28,%rsp
  8017d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017d8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e7:	48 01 d0             	add    %rdx,%rax
  8017ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017ee:	eb 15                	jmp    801805 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f4:	0f b6 10             	movzbl (%rax),%edx
  8017f7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017fa:	38 c2                	cmp    %al,%dl
  8017fc:	75 02                	jne    801800 <memfind+0x34>
			break;
  8017fe:	eb 0f                	jmp    80180f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801800:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801809:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80180d:	72 e1                	jb     8017f0 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80180f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801813:	c9                   	leaveq 
  801814:	c3                   	retq   

0000000000801815 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801815:	55                   	push   %rbp
  801816:	48 89 e5             	mov    %rsp,%rbp
  801819:	48 83 ec 34          	sub    $0x34,%rsp
  80181d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801821:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801825:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801828:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80182f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801836:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801837:	eb 05                	jmp    80183e <strtol+0x29>
		s++;
  801839:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80183e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801842:	0f b6 00             	movzbl (%rax),%eax
  801845:	3c 20                	cmp    $0x20,%al
  801847:	74 f0                	je     801839 <strtol+0x24>
  801849:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184d:	0f b6 00             	movzbl (%rax),%eax
  801850:	3c 09                	cmp    $0x9,%al
  801852:	74 e5                	je     801839 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801854:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801858:	0f b6 00             	movzbl (%rax),%eax
  80185b:	3c 2b                	cmp    $0x2b,%al
  80185d:	75 07                	jne    801866 <strtol+0x51>
		s++;
  80185f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801864:	eb 17                	jmp    80187d <strtol+0x68>
	else if (*s == '-')
  801866:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186a:	0f b6 00             	movzbl (%rax),%eax
  80186d:	3c 2d                	cmp    $0x2d,%al
  80186f:	75 0c                	jne    80187d <strtol+0x68>
		s++, neg = 1;
  801871:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801876:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80187d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801881:	74 06                	je     801889 <strtol+0x74>
  801883:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801887:	75 28                	jne    8018b1 <strtol+0x9c>
  801889:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188d:	0f b6 00             	movzbl (%rax),%eax
  801890:	3c 30                	cmp    $0x30,%al
  801892:	75 1d                	jne    8018b1 <strtol+0x9c>
  801894:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801898:	48 83 c0 01          	add    $0x1,%rax
  80189c:	0f b6 00             	movzbl (%rax),%eax
  80189f:	3c 78                	cmp    $0x78,%al
  8018a1:	75 0e                	jne    8018b1 <strtol+0x9c>
		s += 2, base = 16;
  8018a3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018a8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018af:	eb 2c                	jmp    8018dd <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018b1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018b5:	75 19                	jne    8018d0 <strtol+0xbb>
  8018b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bb:	0f b6 00             	movzbl (%rax),%eax
  8018be:	3c 30                	cmp    $0x30,%al
  8018c0:	75 0e                	jne    8018d0 <strtol+0xbb>
		s++, base = 8;
  8018c2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018c7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018ce:	eb 0d                	jmp    8018dd <strtol+0xc8>
	else if (base == 0)
  8018d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018d4:	75 07                	jne    8018dd <strtol+0xc8>
		base = 10;
  8018d6:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e1:	0f b6 00             	movzbl (%rax),%eax
  8018e4:	3c 2f                	cmp    $0x2f,%al
  8018e6:	7e 1d                	jle    801905 <strtol+0xf0>
  8018e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ec:	0f b6 00             	movzbl (%rax),%eax
  8018ef:	3c 39                	cmp    $0x39,%al
  8018f1:	7f 12                	jg     801905 <strtol+0xf0>
			dig = *s - '0';
  8018f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f7:	0f b6 00             	movzbl (%rax),%eax
  8018fa:	0f be c0             	movsbl %al,%eax
  8018fd:	83 e8 30             	sub    $0x30,%eax
  801900:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801903:	eb 4e                	jmp    801953 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801909:	0f b6 00             	movzbl (%rax),%eax
  80190c:	3c 60                	cmp    $0x60,%al
  80190e:	7e 1d                	jle    80192d <strtol+0x118>
  801910:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801914:	0f b6 00             	movzbl (%rax),%eax
  801917:	3c 7a                	cmp    $0x7a,%al
  801919:	7f 12                	jg     80192d <strtol+0x118>
			dig = *s - 'a' + 10;
  80191b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191f:	0f b6 00             	movzbl (%rax),%eax
  801922:	0f be c0             	movsbl %al,%eax
  801925:	83 e8 57             	sub    $0x57,%eax
  801928:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80192b:	eb 26                	jmp    801953 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80192d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801931:	0f b6 00             	movzbl (%rax),%eax
  801934:	3c 40                	cmp    $0x40,%al
  801936:	7e 48                	jle    801980 <strtol+0x16b>
  801938:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193c:	0f b6 00             	movzbl (%rax),%eax
  80193f:	3c 5a                	cmp    $0x5a,%al
  801941:	7f 3d                	jg     801980 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801943:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801947:	0f b6 00             	movzbl (%rax),%eax
  80194a:	0f be c0             	movsbl %al,%eax
  80194d:	83 e8 37             	sub    $0x37,%eax
  801950:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801953:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801956:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801959:	7c 02                	jl     80195d <strtol+0x148>
			break;
  80195b:	eb 23                	jmp    801980 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80195d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801962:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801965:	48 98                	cltq   
  801967:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80196c:	48 89 c2             	mov    %rax,%rdx
  80196f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801972:	48 98                	cltq   
  801974:	48 01 d0             	add    %rdx,%rax
  801977:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80197b:	e9 5d ff ff ff       	jmpq   8018dd <strtol+0xc8>

	if (endptr)
  801980:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801985:	74 0b                	je     801992 <strtol+0x17d>
		*endptr = (char *) s;
  801987:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80198b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80198f:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801992:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801996:	74 09                	je     8019a1 <strtol+0x18c>
  801998:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80199c:	48 f7 d8             	neg    %rax
  80199f:	eb 04                	jmp    8019a5 <strtol+0x190>
  8019a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019a5:	c9                   	leaveq 
  8019a6:	c3                   	retq   

00000000008019a7 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019a7:	55                   	push   %rbp
  8019a8:	48 89 e5             	mov    %rsp,%rbp
  8019ab:	48 83 ec 30          	sub    $0x30,%rsp
  8019af:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019b3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019bb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019bf:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019c3:	0f b6 00             	movzbl (%rax),%eax
  8019c6:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019c9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019cd:	75 06                	jne    8019d5 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d3:	eb 6b                	jmp    801a40 <strstr+0x99>

	len = strlen(str);
  8019d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019d9:	48 89 c7             	mov    %rax,%rdi
  8019dc:	48 b8 7d 12 80 00 00 	movabs $0x80127d,%rax
  8019e3:	00 00 00 
  8019e6:	ff d0                	callq  *%rax
  8019e8:	48 98                	cltq   
  8019ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019fa:	0f b6 00             	movzbl (%rax),%eax
  8019fd:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a00:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a04:	75 07                	jne    801a0d <strstr+0x66>
				return (char *) 0;
  801a06:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0b:	eb 33                	jmp    801a40 <strstr+0x99>
		} while (sc != c);
  801a0d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a11:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a14:	75 d8                	jne    8019ee <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a1a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a22:	48 89 ce             	mov    %rcx,%rsi
  801a25:	48 89 c7             	mov    %rax,%rdi
  801a28:	48 b8 9e 14 80 00 00 	movabs $0x80149e,%rax
  801a2f:	00 00 00 
  801a32:	ff d0                	callq  *%rax
  801a34:	85 c0                	test   %eax,%eax
  801a36:	75 b6                	jne    8019ee <strstr+0x47>

	return (char *) (in - 1);
  801a38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3c:	48 83 e8 01          	sub    $0x1,%rax
}
  801a40:	c9                   	leaveq 
  801a41:	c3                   	retq   

0000000000801a42 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801a42:	55                   	push   %rbp
  801a43:	48 89 e5             	mov    %rsp,%rbp
  801a46:	53                   	push   %rbx
  801a47:	48 83 ec 48          	sub    $0x48,%rsp
  801a4b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801a4e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801a51:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a55:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801a59:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801a5d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a61:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a64:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a68:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a6c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a70:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a74:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801a78:	4c 89 c3             	mov    %r8,%rbx
  801a7b:	cd 30                	int    $0x30
  801a7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801a81:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a85:	74 3e                	je     801ac5 <syscall+0x83>
  801a87:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a8c:	7e 37                	jle    801ac5 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a8e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a92:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a95:	49 89 d0             	mov    %rdx,%r8
  801a98:	89 c1                	mov    %eax,%ecx
  801a9a:	48 ba 68 4a 80 00 00 	movabs $0x804a68,%rdx
  801aa1:	00 00 00 
  801aa4:	be 23 00 00 00       	mov    $0x23,%esi
  801aa9:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  801ab0:	00 00 00 
  801ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab8:	49 b9 ba 04 80 00 00 	movabs $0x8004ba,%r9
  801abf:	00 00 00 
  801ac2:	41 ff d1             	callq  *%r9

	return ret;
  801ac5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ac9:	48 83 c4 48          	add    $0x48,%rsp
  801acd:	5b                   	pop    %rbx
  801ace:	5d                   	pop    %rbp
  801acf:	c3                   	retq   

0000000000801ad0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801ad0:	55                   	push   %rbp
  801ad1:	48 89 e5             	mov    %rsp,%rbp
  801ad4:	48 83 ec 20          	sub    $0x20,%rsp
  801ad8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801adc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ae0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aef:	00 
  801af0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afc:	48 89 d1             	mov    %rdx,%rcx
  801aff:	48 89 c2             	mov    %rax,%rdx
  801b02:	be 00 00 00 00       	mov    $0x0,%esi
  801b07:	bf 00 00 00 00       	mov    $0x0,%edi
  801b0c:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801b13:	00 00 00 
  801b16:	ff d0                	callq  *%rax
}
  801b18:	c9                   	leaveq 
  801b19:	c3                   	retq   

0000000000801b1a <sys_cgetc>:

int
sys_cgetc(void)
{
  801b1a:	55                   	push   %rbp
  801b1b:	48 89 e5             	mov    %rsp,%rbp
  801b1e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801b22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b29:	00 
  801b2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b36:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b40:	be 00 00 00 00       	mov    $0x0,%esi
  801b45:	bf 01 00 00 00       	mov    $0x1,%edi
  801b4a:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801b51:	00 00 00 
  801b54:	ff d0                	callq  *%rax
}
  801b56:	c9                   	leaveq 
  801b57:	c3                   	retq   

0000000000801b58 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801b58:	55                   	push   %rbp
  801b59:	48 89 e5             	mov    %rsp,%rbp
  801b5c:	48 83 ec 10          	sub    $0x10,%rsp
  801b60:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801b63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b66:	48 98                	cltq   
  801b68:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6f:	00 
  801b70:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b76:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b81:	48 89 c2             	mov    %rax,%rdx
  801b84:	be 01 00 00 00       	mov    $0x1,%esi
  801b89:	bf 03 00 00 00       	mov    $0x3,%edi
  801b8e:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801b95:	00 00 00 
  801b98:	ff d0                	callq  *%rax
}
  801b9a:	c9                   	leaveq 
  801b9b:	c3                   	retq   

0000000000801b9c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b9c:	55                   	push   %rbp
  801b9d:	48 89 e5             	mov    %rsp,%rbp
  801ba0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ba4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bab:	00 
  801bac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc2:	be 00 00 00 00       	mov    $0x0,%esi
  801bc7:	bf 02 00 00 00       	mov    $0x2,%edi
  801bcc:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801bd3:	00 00 00 
  801bd6:	ff d0                	callq  *%rax
}
  801bd8:	c9                   	leaveq 
  801bd9:	c3                   	retq   

0000000000801bda <sys_yield>:

void
sys_yield(void)
{
  801bda:	55                   	push   %rbp
  801bdb:	48 89 e5             	mov    %rsp,%rbp
  801bde:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801be2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801be9:	00 
  801bea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bfb:	ba 00 00 00 00       	mov    $0x0,%edx
  801c00:	be 00 00 00 00       	mov    $0x0,%esi
  801c05:	bf 0b 00 00 00       	mov    $0xb,%edi
  801c0a:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801c11:	00 00 00 
  801c14:	ff d0                	callq  *%rax
}
  801c16:	c9                   	leaveq 
  801c17:	c3                   	retq   

0000000000801c18 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801c18:	55                   	push   %rbp
  801c19:	48 89 e5             	mov    %rsp,%rbp
  801c1c:	48 83 ec 20          	sub    $0x20,%rsp
  801c20:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c23:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c27:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801c2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c2d:	48 63 c8             	movslq %eax,%rcx
  801c30:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c37:	48 98                	cltq   
  801c39:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c40:	00 
  801c41:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c47:	49 89 c8             	mov    %rcx,%r8
  801c4a:	48 89 d1             	mov    %rdx,%rcx
  801c4d:	48 89 c2             	mov    %rax,%rdx
  801c50:	be 01 00 00 00       	mov    $0x1,%esi
  801c55:	bf 04 00 00 00       	mov    $0x4,%edi
  801c5a:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801c61:	00 00 00 
  801c64:	ff d0                	callq  *%rax
}
  801c66:	c9                   	leaveq 
  801c67:	c3                   	retq   

0000000000801c68 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c68:	55                   	push   %rbp
  801c69:	48 89 e5             	mov    %rsp,%rbp
  801c6c:	48 83 ec 30          	sub    $0x30,%rsp
  801c70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c73:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c77:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c7a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c7e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c82:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c85:	48 63 c8             	movslq %eax,%rcx
  801c88:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c8f:	48 63 f0             	movslq %eax,%rsi
  801c92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c99:	48 98                	cltq   
  801c9b:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c9f:	49 89 f9             	mov    %rdi,%r9
  801ca2:	49 89 f0             	mov    %rsi,%r8
  801ca5:	48 89 d1             	mov    %rdx,%rcx
  801ca8:	48 89 c2             	mov    %rax,%rdx
  801cab:	be 01 00 00 00       	mov    $0x1,%esi
  801cb0:	bf 05 00 00 00       	mov    $0x5,%edi
  801cb5:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801cbc:	00 00 00 
  801cbf:	ff d0                	callq  *%rax
}
  801cc1:	c9                   	leaveq 
  801cc2:	c3                   	retq   

0000000000801cc3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801cc3:	55                   	push   %rbp
  801cc4:	48 89 e5             	mov    %rsp,%rbp
  801cc7:	48 83 ec 20          	sub    $0x20,%rsp
  801ccb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801cd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd9:	48 98                	cltq   
  801cdb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce2:	00 
  801ce3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cef:	48 89 d1             	mov    %rdx,%rcx
  801cf2:	48 89 c2             	mov    %rax,%rdx
  801cf5:	be 01 00 00 00       	mov    $0x1,%esi
  801cfa:	bf 06 00 00 00       	mov    $0x6,%edi
  801cff:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801d06:	00 00 00 
  801d09:	ff d0                	callq  *%rax
}
  801d0b:	c9                   	leaveq 
  801d0c:	c3                   	retq   

0000000000801d0d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801d0d:	55                   	push   %rbp
  801d0e:	48 89 e5             	mov    %rsp,%rbp
  801d11:	48 83 ec 10          	sub    $0x10,%rsp
  801d15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d18:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801d1b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d1e:	48 63 d0             	movslq %eax,%rdx
  801d21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d24:	48 98                	cltq   
  801d26:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d2d:	00 
  801d2e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d34:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d3a:	48 89 d1             	mov    %rdx,%rcx
  801d3d:	48 89 c2             	mov    %rax,%rdx
  801d40:	be 01 00 00 00       	mov    $0x1,%esi
  801d45:	bf 08 00 00 00       	mov    $0x8,%edi
  801d4a:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801d51:	00 00 00 
  801d54:	ff d0                	callq  *%rax
}
  801d56:	c9                   	leaveq 
  801d57:	c3                   	retq   

0000000000801d58 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801d58:	55                   	push   %rbp
  801d59:	48 89 e5             	mov    %rsp,%rbp
  801d5c:	48 83 ec 20          	sub    $0x20,%rsp
  801d60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6e:	48 98                	cltq   
  801d70:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d77:	00 
  801d78:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d7e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d84:	48 89 d1             	mov    %rdx,%rcx
  801d87:	48 89 c2             	mov    %rax,%rdx
  801d8a:	be 01 00 00 00       	mov    $0x1,%esi
  801d8f:	bf 09 00 00 00       	mov    $0x9,%edi
  801d94:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801d9b:	00 00 00 
  801d9e:	ff d0                	callq  *%rax
}
  801da0:	c9                   	leaveq 
  801da1:	c3                   	retq   

0000000000801da2 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801da2:	55                   	push   %rbp
  801da3:	48 89 e5             	mov    %rsp,%rbp
  801da6:	48 83 ec 20          	sub    $0x20,%rsp
  801daa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801db1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db8:	48 98                	cltq   
  801dba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc1:	00 
  801dc2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dc8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dce:	48 89 d1             	mov    %rdx,%rcx
  801dd1:	48 89 c2             	mov    %rax,%rdx
  801dd4:	be 01 00 00 00       	mov    $0x1,%esi
  801dd9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801dde:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801de5:	00 00 00 
  801de8:	ff d0                	callq  *%rax
}
  801dea:	c9                   	leaveq 
  801deb:	c3                   	retq   

0000000000801dec <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801dec:	55                   	push   %rbp
  801ded:	48 89 e5             	mov    %rsp,%rbp
  801df0:	48 83 ec 10          	sub    $0x10,%rsp
  801df4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801df7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801dfa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dfd:	48 63 d0             	movslq %eax,%rdx
  801e00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e03:	48 98                	cltq   
  801e05:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e0c:	00 
  801e0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e13:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e19:	48 89 d1             	mov    %rdx,%rcx
  801e1c:	48 89 c2             	mov    %rax,%rdx
  801e1f:	be 01 00 00 00       	mov    $0x1,%esi
  801e24:	bf 11 00 00 00       	mov    $0x11,%edi
  801e29:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801e30:	00 00 00 
  801e33:	ff d0                	callq  *%rax

}
  801e35:	c9                   	leaveq 
  801e36:	c3                   	retq   

0000000000801e37 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801e37:	55                   	push   %rbp
  801e38:	48 89 e5             	mov    %rsp,%rbp
  801e3b:	48 83 ec 20          	sub    $0x20,%rsp
  801e3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e46:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801e4a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801e4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e50:	48 63 f0             	movslq %eax,%rsi
  801e53:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e5a:	48 98                	cltq   
  801e5c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e60:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e67:	00 
  801e68:	49 89 f1             	mov    %rsi,%r9
  801e6b:	49 89 c8             	mov    %rcx,%r8
  801e6e:	48 89 d1             	mov    %rdx,%rcx
  801e71:	48 89 c2             	mov    %rax,%rdx
  801e74:	be 00 00 00 00       	mov    $0x0,%esi
  801e79:	bf 0c 00 00 00       	mov    $0xc,%edi
  801e7e:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801e85:	00 00 00 
  801e88:	ff d0                	callq  *%rax
}
  801e8a:	c9                   	leaveq 
  801e8b:	c3                   	retq   

0000000000801e8c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801e8c:	55                   	push   %rbp
  801e8d:	48 89 e5             	mov    %rsp,%rbp
  801e90:	48 83 ec 10          	sub    $0x10,%rsp
  801e94:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801e98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e9c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ea3:	00 
  801ea4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eaa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eb0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eb5:	48 89 c2             	mov    %rax,%rdx
  801eb8:	be 01 00 00 00       	mov    $0x1,%esi
  801ebd:	bf 0d 00 00 00       	mov    $0xd,%edi
  801ec2:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801ec9:	00 00 00 
  801ecc:	ff d0                	callq  *%rax
}
  801ece:	c9                   	leaveq 
  801ecf:	c3                   	retq   

0000000000801ed0 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801ed0:	55                   	push   %rbp
  801ed1:	48 89 e5             	mov    %rsp,%rbp
  801ed4:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ed8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801edf:	00 
  801ee0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ee6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eec:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ef1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef6:	be 00 00 00 00       	mov    $0x0,%esi
  801efb:	bf 0e 00 00 00       	mov    $0xe,%edi
  801f00:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801f07:	00 00 00 
  801f0a:	ff d0                	callq  *%rax
}
  801f0c:	c9                   	leaveq 
  801f0d:	c3                   	retq   

0000000000801f0e <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801f0e:	55                   	push   %rbp
  801f0f:	48 89 e5             	mov    %rsp,%rbp
  801f12:	48 83 ec 30          	sub    $0x30,%rsp
  801f16:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f1d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801f20:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801f24:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801f28:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801f2b:	48 63 c8             	movslq %eax,%rcx
  801f2e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f35:	48 63 f0             	movslq %eax,%rsi
  801f38:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f3f:	48 98                	cltq   
  801f41:	48 89 0c 24          	mov    %rcx,(%rsp)
  801f45:	49 89 f9             	mov    %rdi,%r9
  801f48:	49 89 f0             	mov    %rsi,%r8
  801f4b:	48 89 d1             	mov    %rdx,%rcx
  801f4e:	48 89 c2             	mov    %rax,%rdx
  801f51:	be 00 00 00 00       	mov    $0x0,%esi
  801f56:	bf 0f 00 00 00       	mov    $0xf,%edi
  801f5b:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801f62:	00 00 00 
  801f65:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801f67:	c9                   	leaveq 
  801f68:	c3                   	retq   

0000000000801f69 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801f69:	55                   	push   %rbp
  801f6a:	48 89 e5             	mov    %rsp,%rbp
  801f6d:	48 83 ec 20          	sub    $0x20,%rsp
  801f71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f75:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801f79:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f81:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f88:	00 
  801f89:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f8f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f95:	48 89 d1             	mov    %rdx,%rcx
  801f98:	48 89 c2             	mov    %rax,%rdx
  801f9b:	be 00 00 00 00       	mov    $0x0,%esi
  801fa0:	bf 10 00 00 00       	mov    $0x10,%edi
  801fa5:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  801fac:	00 00 00 
  801faf:	ff d0                	callq  *%rax
}
  801fb1:	c9                   	leaveq 
  801fb2:	c3                   	retq   

0000000000801fb3 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801fb3:	55                   	push   %rbp
  801fb4:	48 89 e5             	mov    %rsp,%rbp
  801fb7:	48 83 ec 30          	sub    $0x30,%rsp
  801fbb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)



	void *addr = (void *) utf->utf_fault_va;
  801fbf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc3:	48 8b 00             	mov    (%rax),%rax
  801fc6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801fca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fce:	48 8b 40 08          	mov    0x8(%rax),%rax
  801fd2:	89 45 f4             	mov    %eax,-0xc(%rbp)
        // Hint:
        //   Use the read-only page table mappings at vpt
        //   (see <inc/memlayout.h>).

        // LAB 4: Your code here.
	if (!(err&FEC_WR))
  801fd5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fd8:	83 e0 02             	and    $0x2,%eax
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	75 2a                	jne    802009 <pgfault+0x56>
		panic("pgfault:FEC_WR check\n");
  801fdf:	48 ba 98 4a 80 00 00 	movabs $0x804a98,%rdx
  801fe6:	00 00 00 
  801fe9:	be 21 00 00 00       	mov    $0x21,%esi
  801fee:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  801ff5:	00 00 00 
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffd:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802004:	00 00 00 
  802007:	ff d1                	callq  *%rcx
	if (!(uvpt[((uint64_t)addr) / PGSIZE] & PTE_COW))
  802009:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80200d:	48 c1 e8 0c          	shr    $0xc,%rax
  802011:	48 89 c2             	mov    %rax,%rdx
  802014:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80201b:	01 00 00 
  80201e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802022:	25 00 08 00 00       	and    $0x800,%eax
  802027:	48 85 c0             	test   %rax,%rax
  80202a:	75 2a                	jne    802056 <pgfault+0xa3>
		panic("pgfault:PTE_COW check\n");
  80202c:	48 ba b9 4a 80 00 00 	movabs $0x804ab9,%rdx
  802033:	00 00 00 
  802036:	be 23 00 00 00       	mov    $0x23,%esi
  80203b:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  802042:	00 00 00 
  802045:	b8 00 00 00 00       	mov    $0x0,%eax
  80204a:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802051:	00 00 00 
  802054:	ff d1                	callq  *%rcx
        // Hint:
        //   You should make three system calls.
        //   No need to explicitly delete the old page's mapping.

        // LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  802056:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80205a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80205e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802062:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802068:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U)<0)
  80206c:	ba 07 00 00 00       	mov    $0x7,%edx
  802071:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802076:	bf 00 00 00 00       	mov    $0x0,%edi
  80207b:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax
  802087:	85 c0                	test   %eax,%eax
  802089:	79 2a                	jns    8020b5 <pgfault+0x102>
		panic("pgfault: sys_page_alloc error\n");
  80208b:	48 ba d0 4a 80 00 00 	movabs $0x804ad0,%rdx
  802092:	00 00 00 
  802095:	be 2f 00 00 00       	mov    $0x2f,%esi
  80209a:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  8020a1:	00 00 00 
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a9:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  8020b0:	00 00 00 
  8020b3:	ff d1                	callq  *%rcx
	memcpy(PFTEMP, addr, PGSIZE);
  8020b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020b9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8020be:	48 89 c6             	mov    %rax,%rsi
  8020c1:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8020c6:	48 b8 24 17 80 00 00 	movabs $0x801724,%rax
  8020cd:	00 00 00 
  8020d0:	ff d0                	callq  *%rax
	if (sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0)
  8020d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020d6:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8020dc:	48 89 c1             	mov    %rax,%rcx
  8020df:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e4:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8020ee:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  8020f5:	00 00 00 
  8020f8:	ff d0                	callq  *%rax
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	79 2a                	jns    802128 <pgfault+0x175>
		panic("pgfault: sys_page_map error\n");
  8020fe:	48 ba ef 4a 80 00 00 	movabs $0x804aef,%rdx
  802105:	00 00 00 
  802108:	be 32 00 00 00       	mov    $0x32,%esi
  80210d:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  802114:	00 00 00 
  802117:	b8 00 00 00 00       	mov    $0x0,%eax
  80211c:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802123:	00 00 00 
  802126:	ff d1                	callq  *%rcx

	if (sys_page_unmap(0, (void *)PFTEMP)<0)
  802128:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80212d:	bf 00 00 00 00       	mov    $0x0,%edi
  802132:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  802139:	00 00 00 
  80213c:	ff d0                	callq  *%rax
  80213e:	85 c0                	test   %eax,%eax
  802140:	79 2a                	jns    80216c <pgfault+0x1b9>
		panic("pgfault: sys_page_unmap error\n");
  802142:	48 ba 10 4b 80 00 00 	movabs $0x804b10,%rdx
  802149:	00 00 00 
  80214c:	be 35 00 00 00       	mov    $0x35,%esi
  802151:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  802158:	00 00 00 
  80215b:	b8 00 00 00 00       	mov    $0x0,%eax
  802160:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802167:	00 00 00 
  80216a:	ff d1                	callq  *%rcx
	


}
  80216c:	c9                   	leaveq 
  80216d:	c3                   	retq   

000000000080216e <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80216e:	55                   	push   %rbp
  80216f:	48 89 e5             	mov    %rsp,%rbp
  802172:	48 83 ec 10          	sub    $0x10,%rsp
  802176:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802179:	89 75 f8             	mov    %esi,-0x8(%rbp)

	if (uvpt[pn] & PTE_SHARE){
  80217c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802183:	01 00 00 
  802186:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802189:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80218d:	25 00 04 00 00       	and    $0x400,%eax
  802192:	48 85 c0             	test   %rax,%rax
  802195:	74 75                	je     80220c <duppage+0x9e>
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
  802197:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80219e:	01 00 00 
  8021a1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8021a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a8:	25 07 0e 00 00       	and    $0xe07,%eax
  8021ad:	89 c6                	mov    %eax,%esi
  8021af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021b2:	48 c1 e0 0c          	shl    $0xc,%rax
  8021b6:	48 89 c1             	mov    %rax,%rcx
  8021b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021bc:	48 c1 e0 0c          	shl    $0xc,%rax
  8021c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021c3:	41 89 f0             	mov    %esi,%r8d
  8021c6:	48 89 c6             	mov    %rax,%rsi
  8021c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ce:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  8021d5:	00 00 00 
  8021d8:	ff d0                	callq  *%rax
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	0f 89 82 01 00 00    	jns    802364 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");	
  8021e2:	48 ba 2f 4b 80 00 00 	movabs $0x804b2f,%rdx
  8021e9:	00 00 00 
  8021ec:	be 4c 00 00 00       	mov    $0x4c,%esi
  8021f1:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  8021f8:	00 00 00 
  8021fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802200:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802207:	00 00 00 
  80220a:	ff d1                	callq  *%rcx
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
  80220c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802213:	01 00 00 
  802216:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802219:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221d:	83 e0 02             	and    $0x2,%eax
  802220:	48 85 c0             	test   %rax,%rax
  802223:	75 7e                	jne    8022a3 <duppage+0x135>
  802225:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80222c:	01 00 00 
  80222f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802232:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802236:	25 00 08 00 00       	and    $0x800,%eax
  80223b:	48 85 c0             	test   %rax,%rax
  80223e:	75 63                	jne    8022a3 <duppage+0x135>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  802240:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802243:	c1 e0 0c             	shl    $0xc,%eax
  802246:	89 c0                	mov    %eax,%eax
  802248:	48 89 c1             	mov    %rax,%rcx
  80224b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80224e:	c1 e0 0c             	shl    $0xc,%eax
  802251:	89 c0                	mov    %eax,%eax
  802253:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802256:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  80225c:	48 89 c6             	mov    %rax,%rsi
  80225f:	bf 00 00 00 00       	mov    $0x0,%edi
  802264:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  80226b:	00 00 00 
  80226e:	ff d0                	callq  *%rax
  802270:	85 c0                	test   %eax,%eax
  802272:	79 2a                	jns    80229e <duppage+0x130>
			panic("duppage:sys_page_map error\n");
  802274:	48 ba 2f 4b 80 00 00 	movabs $0x804b2f,%rdx
  80227b:	00 00 00 
  80227e:	be 51 00 00 00       	mov    $0x51,%esi
  802283:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  80228a:	00 00 00 
  80228d:	b8 00 00 00 00       	mov    $0x0,%eax
  802292:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802299:	00 00 00 
  80229c:	ff d1                	callq  *%rcx
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
			panic("duppage:sys_page_map error\n");	
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  80229e:	e9 c1 00 00 00       	jmpq   802364 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  8022a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022a6:	c1 e0 0c             	shl    $0xc,%eax
  8022a9:	89 c0                	mov    %eax,%eax
  8022ab:	48 89 c1             	mov    %rax,%rcx
  8022ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022b1:	c1 e0 0c             	shl    $0xc,%eax
  8022b4:	89 c0                	mov    %eax,%eax
  8022b6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022b9:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8022bf:	48 89 c6             	mov    %rax,%rsi
  8022c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c7:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  8022ce:	00 00 00 
  8022d1:	ff d0                	callq  *%rax
  8022d3:	85 c0                	test   %eax,%eax
  8022d5:	79 2a                	jns    802301 <duppage+0x193>
			panic("duppage:sys_page_map error\n");
  8022d7:	48 ba 2f 4b 80 00 00 	movabs $0x804b2f,%rdx
  8022de:	00 00 00 
  8022e1:	be 55 00 00 00       	mov    $0x55,%esi
  8022e6:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  8022ed:	00 00 00 
  8022f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f5:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  8022fc:	00 00 00 
  8022ff:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  802301:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802304:	c1 e0 0c             	shl    $0xc,%eax
  802307:	89 c0                	mov    %eax,%eax
  802309:	48 89 c2             	mov    %rax,%rdx
  80230c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80230f:	c1 e0 0c             	shl    $0xc,%eax
  802312:	89 c0                	mov    %eax,%eax
  802314:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  80231a:	48 89 d1             	mov    %rdx,%rcx
  80231d:	ba 00 00 00 00       	mov    $0x0,%edx
  802322:	48 89 c6             	mov    %rax,%rsi
  802325:	bf 00 00 00 00       	mov    $0x0,%edi
  80232a:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  802331:	00 00 00 
  802334:	ff d0                	callq  *%rax
  802336:	85 c0                	test   %eax,%eax
  802338:	79 2a                	jns    802364 <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
  80233a:	48 ba 2f 4b 80 00 00 	movabs $0x804b2f,%rdx
  802341:	00 00 00 
  802344:	be 57 00 00 00       	mov    $0x57,%esi
  802349:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  802350:	00 00 00 
  802353:	b8 00 00 00 00       	mov    $0x0,%eax
  802358:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  80235f:	00 00 00 
  802362:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  802364:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802369:	c9                   	leaveq 
  80236a:	c3                   	retq   

000000000080236b <new_duppage>:


static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
  80236b:	55                   	push   %rbp
  80236c:	48 89 e5             	mov    %rsp,%rbp
  80236f:	48 83 ec 10          	sub    $0x10,%rsp
  802373:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802376:	89 75 f8             	mov    %esi,-0x8(%rbp)
  802379:	89 55 f4             	mov    %edx,-0xc(%rbp)
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
  80237c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802383:	01 00 00 
  802386:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802389:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80238d:	83 e0 02             	and    $0x2,%eax
  802390:	48 85 c0             	test   %rax,%rax
  802393:	0f 85 84 00 00 00    	jne    80241d <new_duppage+0xb2>
  802399:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023a0:	01 00 00 
  8023a3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8023a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023aa:	25 00 08 00 00       	and    $0x800,%eax
  8023af:	48 85 c0             	test   %rax,%rax
  8023b2:	75 69                	jne    80241d <new_duppage+0xb2>
  8023b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8023b8:	75 63                	jne    80241d <new_duppage+0xb2>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  8023ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023bd:	c1 e0 0c             	shl    $0xc,%eax
  8023c0:	89 c0                	mov    %eax,%eax
  8023c2:	48 89 c1             	mov    %rax,%rcx
  8023c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023c8:	c1 e0 0c             	shl    $0xc,%eax
  8023cb:	89 c0                	mov    %eax,%eax
  8023cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023d0:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  8023d6:	48 89 c6             	mov    %rax,%rsi
  8023d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8023de:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  8023e5:	00 00 00 
  8023e8:	ff d0                	callq  *%rax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	79 2a                	jns    802418 <new_duppage+0xad>
			panic("duppage:sys_page_map error\n");
  8023ee:	48 ba 2f 4b 80 00 00 	movabs $0x804b2f,%rdx
  8023f5:	00 00 00 
  8023f8:	be 64 00 00 00       	mov    $0x64,%esi
  8023fd:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  802404:	00 00 00 
  802407:	b8 00 00 00 00       	mov    $0x0,%eax
  80240c:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802413:	00 00 00 
  802416:	ff d1                	callq  *%rcx
static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  802418:	e9 c1 00 00 00       	jmpq   8024de <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  80241d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802420:	c1 e0 0c             	shl    $0xc,%eax
  802423:	89 c0                	mov    %eax,%eax
  802425:	48 89 c1             	mov    %rax,%rcx
  802428:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80242b:	c1 e0 0c             	shl    $0xc,%eax
  80242e:	89 c0                	mov    %eax,%eax
  802430:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802433:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802439:	48 89 c6             	mov    %rax,%rsi
  80243c:	bf 00 00 00 00       	mov    $0x0,%edi
  802441:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  802448:	00 00 00 
  80244b:	ff d0                	callq  *%rax
  80244d:	85 c0                	test   %eax,%eax
  80244f:	79 2a                	jns    80247b <new_duppage+0x110>
			panic("duppage:sys_page_map error\n");
  802451:	48 ba 2f 4b 80 00 00 	movabs $0x804b2f,%rdx
  802458:	00 00 00 
  80245b:	be 68 00 00 00       	mov    $0x68,%esi
  802460:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  802467:	00 00 00 
  80246a:	b8 00 00 00 00       	mov    $0x0,%eax
  80246f:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802476:	00 00 00 
  802479:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  80247b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80247e:	c1 e0 0c             	shl    $0xc,%eax
  802481:	89 c0                	mov    %eax,%eax
  802483:	48 89 c2             	mov    %rax,%rdx
  802486:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802489:	c1 e0 0c             	shl    $0xc,%eax
  80248c:	89 c0                	mov    %eax,%eax
  80248e:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802494:	48 89 d1             	mov    %rdx,%rcx
  802497:	ba 00 00 00 00       	mov    $0x0,%edx
  80249c:	48 89 c6             	mov    %rax,%rsi
  80249f:	bf 00 00 00 00       	mov    $0x0,%edi
  8024a4:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  8024ab:	00 00 00 
  8024ae:	ff d0                	callq  *%rax
  8024b0:	85 c0                	test   %eax,%eax
  8024b2:	79 2a                	jns    8024de <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
  8024b4:	48 ba 2f 4b 80 00 00 	movabs $0x804b2f,%rdx
  8024bb:	00 00 00 
  8024be:	be 6a 00 00 00       	mov    $0x6a,%esi
  8024c3:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  8024ca:	00 00 00 
  8024cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d2:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  8024d9:	00 00 00 
  8024dc:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  8024de:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8024e3:	c9                   	leaveq 
  8024e4:	c3                   	retq   

00000000008024e5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8024e5:	55                   	push   %rbp
  8024e6:	48 89 e5             	mov    %rsp,%rbp
  8024e9:	48 83 ec 10          	sub    $0x10,%rsp


	
	int envid;  
	//extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  8024ed:	48 bf b3 1f 80 00 00 	movabs $0x801fb3,%rdi
  8024f4:	00 00 00 
  8024f7:	48 b8 d1 40 80 00 00 	movabs $0x8040d1,%rax
  8024fe:	00 00 00 
  802501:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802503:	b8 07 00 00 00       	mov    $0x7,%eax
  802508:	cd 30                	int    $0x30
  80250a:	89 45 f0             	mov    %eax,-0x10(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80250d:	8b 45 f0             	mov    -0x10(%rbp),%eax


	if ((envid=sys_exofork())<0)
  802510:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802513:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802517:	79 2a                	jns    802543 <fork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  802519:	48 ba 4b 4b 80 00 00 	movabs $0x804b4b,%rdx
  802520:	00 00 00 
  802523:	be 90 00 00 00       	mov    $0x90,%esi
  802528:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  80252f:	00 00 00 
  802532:	b8 00 00 00 00       	mov    $0x0,%eax
  802537:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  80253e:	00 00 00 
  802541:	ff d1                	callq  *%rcx

	if(envid>0){
  802543:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802547:	0f 8e e1 01 00 00    	jle    80272e <fork+0x249>
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  80254d:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  802554:	00 
  802555:	e9 d4 00 00 00       	jmpq   80262e <fork+0x149>
		{
			

               if(!(uvpml4e[VPML4E(i)]))
  80255a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80255e:	48 c1 e8 27          	shr    $0x27,%rax
  802562:	48 89 c2             	mov    %rax,%rdx
  802565:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80256c:	01 00 00 
  80256f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802573:	48 85 c0             	test   %rax,%rax
  802576:	75 05                	jne    80257d <fork+0x98>
		 continue;
  802578:	e9 a9 00 00 00       	jmpq   802626 <fork+0x141>
		
		if(!(uvpde[VPDPE(i)]))
  80257d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802581:	48 c1 e8 1e          	shr    $0x1e,%rax
  802585:	48 89 c2             	mov    %rax,%rdx
  802588:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80258f:	01 00 00 
  802592:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802596:	48 85 c0             	test   %rax,%rax
  802599:	75 05                	jne    8025a0 <fork+0xbb>
	          continue;
  80259b:	e9 86 00 00 00       	jmpq   802626 <fork+0x141>
	

			if(!(uvpd[VPD(i)] & PTE_P))
  8025a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025a4:	48 c1 e8 15          	shr    $0x15,%rax
  8025a8:	48 89 c2             	mov    %rax,%rdx
  8025ab:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025b2:	01 00 00 
  8025b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025b9:	83 e0 01             	and    $0x1,%eax
  8025bc:	48 85 c0             	test   %rax,%rax
  8025bf:	75 02                	jne    8025c3 <fork+0xde>
				continue;
  8025c1:	eb 63                	jmp    802626 <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_P))
  8025c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c7:	48 c1 e8 0c          	shr    $0xc,%rax
  8025cb:	48 89 c2             	mov    %rax,%rdx
  8025ce:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025d5:	01 00 00 
  8025d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025dc:	83 e0 01             	and    $0x1,%eax
  8025df:	48 85 c0             	test   %rax,%rax
  8025e2:	75 02                	jne    8025e6 <fork+0x101>
				continue; 
  8025e4:	eb 40                	jmp    802626 <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_U))
  8025e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025ea:	48 c1 e8 0c          	shr    $0xc,%rax
  8025ee:	48 89 c2             	mov    %rax,%rdx
  8025f1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025f8:	01 00 00 
  8025fb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ff:	83 e0 04             	and    $0x4,%eax
  802602:	48 85 c0             	test   %rax,%rax
  802605:	75 02                	jne    802609 <fork+0x124>
				continue; 
  802607:	eb 1d                	jmp    802626 <fork+0x141>
			duppage(envid, VPN(i)); 
  802609:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80260d:	48 c1 e8 0c          	shr    $0xc,%rax
  802611:	89 c2                	mov    %eax,%edx
  802613:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802616:	89 d6                	mov    %edx,%esi
  802618:	89 c7                	mov    %eax,%edi
  80261a:	48 b8 6e 21 80 00 00 	movabs $0x80216e,%rax
  802621:	00 00 00 
  802624:	ff d0                	callq  *%rax

	if(envid>0){
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  802626:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  80262d:	00 
  80262e:	b8 ff cf 7f ef       	mov    $0xef7fcfff,%eax
  802633:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802637:	0f 86 1d ff ff ff    	jbe    80255a <fork+0x75>
			if(!(uvpt[VPN(i)] & PTE_U))
				continue; 
			duppage(envid, VPN(i)); 
		}

		if (sys_page_alloc(envid,(void*)UXSTACKTOP-PGSIZE, PTE_U|PTE_W|PTE_P)<0)
  80263d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802640:	ba 07 00 00 00       	mov    $0x7,%edx
  802645:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80264a:	89 c7                	mov    %eax,%edi
  80264c:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  802653:	00 00 00 
  802656:	ff d0                	callq  *%rax
  802658:	85 c0                	test   %eax,%eax
  80265a:	79 2a                	jns    802686 <fork+0x1a1>
			panic("fork: sys_page_alloc error!\n");
  80265c:	48 ba 65 4b 80 00 00 	movabs $0x804b65,%rdx
  802663:	00 00 00 
  802666:	be ab 00 00 00       	mov    $0xab,%esi
  80266b:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  802672:	00 00 00 
  802675:	b8 00 00 00 00       	mov    $0x0,%eax
  80267a:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802681:	00 00 00 
  802684:	ff d1                	callq  *%rcx

		duppage(envid, VPN(USTACKTOP-PGSIZE));
  802686:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802689:	be fd f7 0e 00       	mov    $0xef7fd,%esi
  80268e:	89 c7                	mov    %eax,%edi
  802690:	48 b8 6e 21 80 00 00 	movabs $0x80216e,%rax
  802697:	00 00 00 
  80269a:	ff d0                	callq  *%rax
		extern void _pgfault_upcall(void);
		if (sys_env_set_pgfault_upcall(envid, _pgfault_upcall)<0)
  80269c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80269f:	48 be 71 41 80 00 00 	movabs $0x804171,%rsi
  8026a6:	00 00 00 
  8026a9:	89 c7                	mov    %eax,%edi
  8026ab:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	callq  *%rax
  8026b7:	85 c0                	test   %eax,%eax
  8026b9:	79 2a                	jns    8026e5 <fork+0x200>
			panic("fork: sys_env_set_status error!\n");
  8026bb:	48 ba 88 4b 80 00 00 	movabs $0x804b88,%rdx
  8026c2:	00 00 00 
  8026c5:	be b0 00 00 00       	mov    $0xb0,%esi
  8026ca:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  8026d1:	00 00 00 
  8026d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d9:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  8026e0:	00 00 00 
  8026e3:	ff d1                	callq  *%rcx
		if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  8026e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8026e8:	be 02 00 00 00       	mov    $0x2,%esi
  8026ed:	89 c7                	mov    %eax,%edi
  8026ef:	48 b8 0d 1d 80 00 00 	movabs $0x801d0d,%rax
  8026f6:	00 00 00 
  8026f9:	ff d0                	callq  *%rax
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	79 2a                	jns    802729 <fork+0x244>
			panic("fork: sys_env_set_status error!\n");
  8026ff:	48 ba 88 4b 80 00 00 	movabs $0x804b88,%rdx
  802706:	00 00 00 
  802709:	be b2 00 00 00       	mov    $0xb2,%esi
  80270e:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  802715:	00 00 00 
  802718:	b8 00 00 00 00       	mov    $0x0,%eax
  80271d:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802724:	00 00 00 
  802727:	ff d1                	callq  *%rcx

		return envid;
  802729:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80272c:	eb 39                	jmp    802767 <fork+0x282>
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80272e:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  802735:	00 00 00 
  802738:	ff d0                	callq  *%rax
  80273a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80273f:	48 98                	cltq   
  802741:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  802748:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80274f:	00 00 00 
  802752:	48 01 c2             	add    %rax,%rdx
  802755:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80275c:	00 00 00 
  80275f:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802762:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  802767:	c9                   	leaveq 
  802768:	c3                   	retq   

0000000000802769 <sfork>:

// Challenge!
envid_t
sfork(void)
{
  802769:	55                   	push   %rbp
  80276a:	48 89 e5             	mov    %rsp,%rbp
  80276d:	48 83 ec 20          	sub    $0x20,%rsp

	
	int envid;  
	extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  802771:	48 bf b3 1f 80 00 00 	movabs $0x801fb3,%rdi
  802778:	00 00 00 
  80277b:	48 b8 d1 40 80 00 00 	movabs $0x8040d1,%rax
  802782:	00 00 00 
  802785:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802787:	b8 07 00 00 00       	mov    $0x7,%eax
  80278c:	cd 30                	int    $0x30
  80278e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802791:	8b 45 ec             	mov    -0x14(%rbp),%eax
	

	if ((envid=sys_exofork())<0)
  802794:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802797:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80279b:	79 2a                	jns    8027c7 <sfork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  80279d:	48 ba 4b 4b 80 00 00 	movabs $0x804b4b,%rdx
  8027a4:	00 00 00 
  8027a7:	be ca 00 00 00       	mov    $0xca,%esi
  8027ac:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  8027b3:	00 00 00 
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bb:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  8027c2:	00 00 00 
  8027c5:	ff d1                	callq  *%rcx

	if(envid>0){
  8027c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8027cb:	0f 8e e5 00 00 00    	jle    8028b6 <sfork+0x14d>
		
		
		uintptr_t i;
		int flag=1;
  8027d1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)

		for (i = 0; i < (uintptr_t)end/*USTACKTOP-PGSIZE*/; i += PGSIZE) ;
  8027d8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8027df:	00 
  8027e0:	eb 08                	jmp    8027ea <sfork+0x81>
  8027e2:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8027e9:	00 
  8027ea:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  8027f1:	00 00 00 
  8027f4:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8027f8:	72 e8                	jb     8027e2 <sfork+0x79>
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
  8027fa:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802801:	00 
    for (;i>=0; i -= PGSIZE) 
		{
			cprintf("23\n");
  802802:	48 bf a9 4b 80 00 00 	movabs $0x804ba9,%rdi
  802809:	00 00 00 
  80280c:	b8 00 00 00 00       	mov    $0x0,%eax
  802811:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  802818:	00 00 00 
  80281b:	ff d2                	callq  *%rdx
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
  80281d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802821:	48 c1 e8 15          	shr    $0x15,%rax
  802825:	48 89 c2             	mov    %rax,%rdx
  802828:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80282f:	01 00 00 
  802832:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802836:	83 e0 01             	and    $0x1,%eax
  802839:	48 85 c0             	test   %rax,%rax
  80283c:	74 42                	je     802880 <sfork+0x117>
  80283e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802842:	48 c1 e8 0c          	shr    $0xc,%rax
  802846:	48 89 c2             	mov    %rax,%rdx
  802849:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802850:	01 00 00 
  802853:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802857:	83 e0 01             	and    $0x1,%eax
  80285a:	48 85 c0             	test   %rax,%rax
  80285d:	74 21                	je     802880 <sfork+0x117>
  80285f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802863:	48 c1 e8 0c          	shr    $0xc,%rax
  802867:	48 89 c2             	mov    %rax,%rdx
  80286a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802871:	01 00 00 
  802874:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802878:	83 e0 04             	and    $0x4,%eax
  80287b:	48 85 c0             	test   %rax,%rax
  80287e:	75 09                	jne    802889 <sfork+0x120>
				flag=0;
  802880:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802887:	eb 20                	jmp    8028a9 <sfork+0x140>
			else
				new_duppage(envid, VPN(i),flag); 
  802889:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80288d:	48 c1 e8 0c          	shr    $0xc,%rax
  802891:	89 c1                	mov    %eax,%ecx
  802893:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802896:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802899:	89 ce                	mov    %ecx,%esi
  80289b:	89 c7                	mov    %eax,%edi
  80289d:	48 b8 6b 23 80 00 00 	movabs $0x80236b,%rax
  8028a4:	00 00 00 
  8028a7:	ff d0                	callq  *%rax
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
    for (;i>=0; i -= PGSIZE) 
  8028a9:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8028b0:	00 
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
				flag=0;
			else
				new_duppage(envid, VPN(i),flag); 

		}
  8028b1:	e9 4c ff ff ff       	jmpq   802802 <sfork+0x99>

		return envid;
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8028b6:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  8028bd:	00 00 00 
  8028c0:	ff d0                	callq  *%rax
  8028c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8028c7:	48 98                	cltq   
  8028c9:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8028d0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8028d7:	00 00 00 
  8028da:	48 01 c2             	add    %rax,%rdx
  8028dd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028e4:	00 00 00 
  8028e7:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8028ea:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  8028ef:	c9                   	leaveq 
  8028f0:	c3                   	retq   

00000000008028f1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8028f1:	55                   	push   %rbp
  8028f2:	48 89 e5             	mov    %rsp,%rbp
  8028f5:	48 83 ec 08          	sub    $0x8,%rsp
  8028f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8028fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802901:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802908:	ff ff ff 
  80290b:	48 01 d0             	add    %rdx,%rax
  80290e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802912:	c9                   	leaveq 
  802913:	c3                   	retq   

0000000000802914 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802914:	55                   	push   %rbp
  802915:	48 89 e5             	mov    %rsp,%rbp
  802918:	48 83 ec 08          	sub    $0x8,%rsp
  80291c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802920:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802924:	48 89 c7             	mov    %rax,%rdi
  802927:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  80292e:	00 00 00 
  802931:	ff d0                	callq  *%rax
  802933:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802939:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80293d:	c9                   	leaveq 
  80293e:	c3                   	retq   

000000000080293f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80293f:	55                   	push   %rbp
  802940:	48 89 e5             	mov    %rsp,%rbp
  802943:	48 83 ec 18          	sub    $0x18,%rsp
  802947:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80294b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802952:	eb 6b                	jmp    8029bf <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802954:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802957:	48 98                	cltq   
  802959:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80295f:	48 c1 e0 0c          	shl    $0xc,%rax
  802963:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802967:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80296b:	48 c1 e8 15          	shr    $0x15,%rax
  80296f:	48 89 c2             	mov    %rax,%rdx
  802972:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802979:	01 00 00 
  80297c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802980:	83 e0 01             	and    $0x1,%eax
  802983:	48 85 c0             	test   %rax,%rax
  802986:	74 21                	je     8029a9 <fd_alloc+0x6a>
  802988:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80298c:	48 c1 e8 0c          	shr    $0xc,%rax
  802990:	48 89 c2             	mov    %rax,%rdx
  802993:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80299a:	01 00 00 
  80299d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029a1:	83 e0 01             	and    $0x1,%eax
  8029a4:	48 85 c0             	test   %rax,%rax
  8029a7:	75 12                	jne    8029bb <fd_alloc+0x7c>
			*fd_store = fd;
  8029a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029b1:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8029b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b9:	eb 1a                	jmp    8029d5 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8029bb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8029bf:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8029c3:	7e 8f                	jle    802954 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8029c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8029d0:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8029d5:	c9                   	leaveq 
  8029d6:	c3                   	retq   

00000000008029d7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8029d7:	55                   	push   %rbp
  8029d8:	48 89 e5             	mov    %rsp,%rbp
  8029db:	48 83 ec 20          	sub    $0x20,%rsp
  8029df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8029e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029ea:	78 06                	js     8029f2 <fd_lookup+0x1b>
  8029ec:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8029f0:	7e 07                	jle    8029f9 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8029f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029f7:	eb 6c                	jmp    802a65 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8029f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029fc:	48 98                	cltq   
  8029fe:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a04:	48 c1 e0 0c          	shl    $0xc,%rax
  802a08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802a0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a10:	48 c1 e8 15          	shr    $0x15,%rax
  802a14:	48 89 c2             	mov    %rax,%rdx
  802a17:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a1e:	01 00 00 
  802a21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a25:	83 e0 01             	and    $0x1,%eax
  802a28:	48 85 c0             	test   %rax,%rax
  802a2b:	74 21                	je     802a4e <fd_lookup+0x77>
  802a2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a31:	48 c1 e8 0c          	shr    $0xc,%rax
  802a35:	48 89 c2             	mov    %rax,%rdx
  802a38:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a3f:	01 00 00 
  802a42:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a46:	83 e0 01             	and    $0x1,%eax
  802a49:	48 85 c0             	test   %rax,%rax
  802a4c:	75 07                	jne    802a55 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802a4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a53:	eb 10                	jmp    802a65 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802a55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a59:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a5d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802a60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a65:	c9                   	leaveq 
  802a66:	c3                   	retq   

0000000000802a67 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802a67:	55                   	push   %rbp
  802a68:	48 89 e5             	mov    %rsp,%rbp
  802a6b:	48 83 ec 30          	sub    $0x30,%rsp
  802a6f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a73:	89 f0                	mov    %esi,%eax
  802a75:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802a78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a7c:	48 89 c7             	mov    %rax,%rdi
  802a7f:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  802a86:	00 00 00 
  802a89:	ff d0                	callq  *%rax
  802a8b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a8f:	48 89 d6             	mov    %rdx,%rsi
  802a92:	89 c7                	mov    %eax,%edi
  802a94:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  802a9b:	00 00 00 
  802a9e:	ff d0                	callq  *%rax
  802aa0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa7:	78 0a                	js     802ab3 <fd_close+0x4c>
	    || fd != fd2)
  802aa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aad:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802ab1:	74 12                	je     802ac5 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802ab3:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802ab7:	74 05                	je     802abe <fd_close+0x57>
  802ab9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802abc:	eb 05                	jmp    802ac3 <fd_close+0x5c>
  802abe:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac3:	eb 69                	jmp    802b2e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802ac5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ac9:	8b 00                	mov    (%rax),%eax
  802acb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802acf:	48 89 d6             	mov    %rdx,%rsi
  802ad2:	89 c7                	mov    %eax,%edi
  802ad4:	48 b8 30 2b 80 00 00 	movabs $0x802b30,%rax
  802adb:	00 00 00 
  802ade:	ff d0                	callq  *%rax
  802ae0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae7:	78 2a                	js     802b13 <fd_close+0xac>
		if (dev->dev_close)
  802ae9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aed:	48 8b 40 20          	mov    0x20(%rax),%rax
  802af1:	48 85 c0             	test   %rax,%rax
  802af4:	74 16                	je     802b0c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802af6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802afa:	48 8b 40 20          	mov    0x20(%rax),%rax
  802afe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b02:	48 89 d7             	mov    %rdx,%rdi
  802b05:	ff d0                	callq  *%rax
  802b07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b0a:	eb 07                	jmp    802b13 <fd_close+0xac>
		else
			r = 0;
  802b0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802b13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b17:	48 89 c6             	mov    %rax,%rsi
  802b1a:	bf 00 00 00 00       	mov    $0x0,%edi
  802b1f:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  802b26:	00 00 00 
  802b29:	ff d0                	callq  *%rax
	return r;
  802b2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b2e:	c9                   	leaveq 
  802b2f:	c3                   	retq   

0000000000802b30 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802b30:	55                   	push   %rbp
  802b31:	48 89 e5             	mov    %rsp,%rbp
  802b34:	48 83 ec 20          	sub    $0x20,%rsp
  802b38:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b3b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802b3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b46:	eb 41                	jmp    802b89 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802b48:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b4f:	00 00 00 
  802b52:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b55:	48 63 d2             	movslq %edx,%rdx
  802b58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b5c:	8b 00                	mov    (%rax),%eax
  802b5e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802b61:	75 22                	jne    802b85 <dev_lookup+0x55>
			*dev = devtab[i];
  802b63:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b6a:	00 00 00 
  802b6d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b70:	48 63 d2             	movslq %edx,%rdx
  802b73:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802b77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b7b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b83:	eb 60                	jmp    802be5 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802b85:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b89:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b90:	00 00 00 
  802b93:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b96:	48 63 d2             	movslq %edx,%rdx
  802b99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b9d:	48 85 c0             	test   %rax,%rax
  802ba0:	75 a6                	jne    802b48 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802ba2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ba9:	00 00 00 
  802bac:	48 8b 00             	mov    (%rax),%rax
  802baf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bb5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802bb8:	89 c6                	mov    %eax,%esi
  802bba:	48 bf b0 4b 80 00 00 	movabs $0x804bb0,%rdi
  802bc1:	00 00 00 
  802bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc9:	48 b9 f3 06 80 00 00 	movabs $0x8006f3,%rcx
  802bd0:	00 00 00 
  802bd3:	ff d1                	callq  *%rcx
	*dev = 0;
  802bd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bd9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802be0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802be5:	c9                   	leaveq 
  802be6:	c3                   	retq   

0000000000802be7 <close>:

int
close(int fdnum)
{
  802be7:	55                   	push   %rbp
  802be8:	48 89 e5             	mov    %rsp,%rbp
  802beb:	48 83 ec 20          	sub    $0x20,%rsp
  802bef:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bf2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bf6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bf9:	48 89 d6             	mov    %rdx,%rsi
  802bfc:	89 c7                	mov    %eax,%edi
  802bfe:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  802c05:	00 00 00 
  802c08:	ff d0                	callq  *%rax
  802c0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c11:	79 05                	jns    802c18 <close+0x31>
		return r;
  802c13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c16:	eb 18                	jmp    802c30 <close+0x49>
	else
		return fd_close(fd, 1);
  802c18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c1c:	be 01 00 00 00       	mov    $0x1,%esi
  802c21:	48 89 c7             	mov    %rax,%rdi
  802c24:	48 b8 67 2a 80 00 00 	movabs $0x802a67,%rax
  802c2b:	00 00 00 
  802c2e:	ff d0                	callq  *%rax
}
  802c30:	c9                   	leaveq 
  802c31:	c3                   	retq   

0000000000802c32 <close_all>:

void
close_all(void)
{
  802c32:	55                   	push   %rbp
  802c33:	48 89 e5             	mov    %rsp,%rbp
  802c36:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802c3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c41:	eb 15                	jmp    802c58 <close_all+0x26>
		close(i);
  802c43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c46:	89 c7                	mov    %eax,%edi
  802c48:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  802c4f:	00 00 00 
  802c52:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802c54:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c58:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802c5c:	7e e5                	jle    802c43 <close_all+0x11>
		close(i);
}
  802c5e:	c9                   	leaveq 
  802c5f:	c3                   	retq   

0000000000802c60 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802c60:	55                   	push   %rbp
  802c61:	48 89 e5             	mov    %rsp,%rbp
  802c64:	48 83 ec 40          	sub    $0x40,%rsp
  802c68:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802c6b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802c6e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802c72:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802c75:	48 89 d6             	mov    %rdx,%rsi
  802c78:	89 c7                	mov    %eax,%edi
  802c7a:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  802c81:	00 00 00 
  802c84:	ff d0                	callq  *%rax
  802c86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8d:	79 08                	jns    802c97 <dup+0x37>
		return r;
  802c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c92:	e9 70 01 00 00       	jmpq   802e07 <dup+0x1a7>
	close(newfdnum);
  802c97:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c9a:	89 c7                	mov    %eax,%edi
  802c9c:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  802ca3:	00 00 00 
  802ca6:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802ca8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802cab:	48 98                	cltq   
  802cad:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802cb3:	48 c1 e0 0c          	shl    $0xc,%rax
  802cb7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802cbb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cbf:	48 89 c7             	mov    %rax,%rdi
  802cc2:	48 b8 14 29 80 00 00 	movabs $0x802914,%rax
  802cc9:	00 00 00 
  802ccc:	ff d0                	callq  *%rax
  802cce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802cd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd6:	48 89 c7             	mov    %rax,%rdi
  802cd9:	48 b8 14 29 80 00 00 	movabs $0x802914,%rax
  802ce0:	00 00 00 
  802ce3:	ff d0                	callq  *%rax
  802ce5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802ce9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ced:	48 c1 e8 15          	shr    $0x15,%rax
  802cf1:	48 89 c2             	mov    %rax,%rdx
  802cf4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802cfb:	01 00 00 
  802cfe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d02:	83 e0 01             	and    $0x1,%eax
  802d05:	48 85 c0             	test   %rax,%rax
  802d08:	74 73                	je     802d7d <dup+0x11d>
  802d0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0e:	48 c1 e8 0c          	shr    $0xc,%rax
  802d12:	48 89 c2             	mov    %rax,%rdx
  802d15:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d1c:	01 00 00 
  802d1f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d23:	83 e0 01             	and    $0x1,%eax
  802d26:	48 85 c0             	test   %rax,%rax
  802d29:	74 52                	je     802d7d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802d2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d2f:	48 c1 e8 0c          	shr    $0xc,%rax
  802d33:	48 89 c2             	mov    %rax,%rdx
  802d36:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d3d:	01 00 00 
  802d40:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d44:	25 07 0e 00 00       	and    $0xe07,%eax
  802d49:	89 c1                	mov    %eax,%ecx
  802d4b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d53:	41 89 c8             	mov    %ecx,%r8d
  802d56:	48 89 d1             	mov    %rdx,%rcx
  802d59:	ba 00 00 00 00       	mov    $0x0,%edx
  802d5e:	48 89 c6             	mov    %rax,%rsi
  802d61:	bf 00 00 00 00       	mov    $0x0,%edi
  802d66:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  802d6d:	00 00 00 
  802d70:	ff d0                	callq  *%rax
  802d72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d79:	79 02                	jns    802d7d <dup+0x11d>
			goto err;
  802d7b:	eb 57                	jmp    802dd4 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d81:	48 c1 e8 0c          	shr    $0xc,%rax
  802d85:	48 89 c2             	mov    %rax,%rdx
  802d88:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d8f:	01 00 00 
  802d92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d96:	25 07 0e 00 00       	and    $0xe07,%eax
  802d9b:	89 c1                	mov    %eax,%ecx
  802d9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802da1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802da5:	41 89 c8             	mov    %ecx,%r8d
  802da8:	48 89 d1             	mov    %rdx,%rcx
  802dab:	ba 00 00 00 00       	mov    $0x0,%edx
  802db0:	48 89 c6             	mov    %rax,%rsi
  802db3:	bf 00 00 00 00       	mov    $0x0,%edi
  802db8:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  802dbf:	00 00 00 
  802dc2:	ff d0                	callq  *%rax
  802dc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dcb:	79 02                	jns    802dcf <dup+0x16f>
		goto err;
  802dcd:	eb 05                	jmp    802dd4 <dup+0x174>

	return newfdnum;
  802dcf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802dd2:	eb 33                	jmp    802e07 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802dd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd8:	48 89 c6             	mov    %rax,%rsi
  802ddb:	bf 00 00 00 00       	mov    $0x0,%edi
  802de0:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  802de7:	00 00 00 
  802dea:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802dec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802df0:	48 89 c6             	mov    %rax,%rsi
  802df3:	bf 00 00 00 00       	mov    $0x0,%edi
  802df8:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  802dff:	00 00 00 
  802e02:	ff d0                	callq  *%rax
	return r;
  802e04:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e07:	c9                   	leaveq 
  802e08:	c3                   	retq   

0000000000802e09 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802e09:	55                   	push   %rbp
  802e0a:	48 89 e5             	mov    %rsp,%rbp
  802e0d:	48 83 ec 40          	sub    $0x40,%rsp
  802e11:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e14:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e18:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e1c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e20:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e23:	48 89 d6             	mov    %rdx,%rsi
  802e26:	89 c7                	mov    %eax,%edi
  802e28:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  802e2f:	00 00 00 
  802e32:	ff d0                	callq  *%rax
  802e34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e3b:	78 24                	js     802e61 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e41:	8b 00                	mov    (%rax),%eax
  802e43:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e47:	48 89 d6             	mov    %rdx,%rsi
  802e4a:	89 c7                	mov    %eax,%edi
  802e4c:	48 b8 30 2b 80 00 00 	movabs $0x802b30,%rax
  802e53:	00 00 00 
  802e56:	ff d0                	callq  *%rax
  802e58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e5f:	79 05                	jns    802e66 <read+0x5d>
		return r;
  802e61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e64:	eb 76                	jmp    802edc <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802e66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e6a:	8b 40 08             	mov    0x8(%rax),%eax
  802e6d:	83 e0 03             	and    $0x3,%eax
  802e70:	83 f8 01             	cmp    $0x1,%eax
  802e73:	75 3a                	jne    802eaf <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e75:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802e7c:	00 00 00 
  802e7f:	48 8b 00             	mov    (%rax),%rax
  802e82:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e88:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e8b:	89 c6                	mov    %eax,%esi
  802e8d:	48 bf cf 4b 80 00 00 	movabs $0x804bcf,%rdi
  802e94:	00 00 00 
  802e97:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9c:	48 b9 f3 06 80 00 00 	movabs $0x8006f3,%rcx
  802ea3:	00 00 00 
  802ea6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ea8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ead:	eb 2d                	jmp    802edc <read+0xd3>
	}
	if (!dev->dev_read)
  802eaf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb3:	48 8b 40 10          	mov    0x10(%rax),%rax
  802eb7:	48 85 c0             	test   %rax,%rax
  802eba:	75 07                	jne    802ec3 <read+0xba>
		return -E_NOT_SUPP;
  802ebc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ec1:	eb 19                	jmp    802edc <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802ec3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec7:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ecb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ecf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ed3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802ed7:	48 89 cf             	mov    %rcx,%rdi
  802eda:	ff d0                	callq  *%rax
}
  802edc:	c9                   	leaveq 
  802edd:	c3                   	retq   

0000000000802ede <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ede:	55                   	push   %rbp
  802edf:	48 89 e5             	mov    %rsp,%rbp
  802ee2:	48 83 ec 30          	sub    $0x30,%rsp
  802ee6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ee9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802eed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ef1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ef8:	eb 49                	jmp    802f43 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802efa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802efd:	48 98                	cltq   
  802eff:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f03:	48 29 c2             	sub    %rax,%rdx
  802f06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f09:	48 63 c8             	movslq %eax,%rcx
  802f0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f10:	48 01 c1             	add    %rax,%rcx
  802f13:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f16:	48 89 ce             	mov    %rcx,%rsi
  802f19:	89 c7                	mov    %eax,%edi
  802f1b:	48 b8 09 2e 80 00 00 	movabs $0x802e09,%rax
  802f22:	00 00 00 
  802f25:	ff d0                	callq  *%rax
  802f27:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802f2a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f2e:	79 05                	jns    802f35 <readn+0x57>
			return m;
  802f30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f33:	eb 1c                	jmp    802f51 <readn+0x73>
		if (m == 0)
  802f35:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f39:	75 02                	jne    802f3d <readn+0x5f>
			break;
  802f3b:	eb 11                	jmp    802f4e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802f3d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f40:	01 45 fc             	add    %eax,-0x4(%rbp)
  802f43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f46:	48 98                	cltq   
  802f48:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802f4c:	72 ac                	jb     802efa <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802f4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f51:	c9                   	leaveq 
  802f52:	c3                   	retq   

0000000000802f53 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802f53:	55                   	push   %rbp
  802f54:	48 89 e5             	mov    %rsp,%rbp
  802f57:	48 83 ec 40          	sub    $0x40,%rsp
  802f5b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f5e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f62:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f66:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f6a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f6d:	48 89 d6             	mov    %rdx,%rsi
  802f70:	89 c7                	mov    %eax,%edi
  802f72:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	callq  *%rax
  802f7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f85:	78 24                	js     802fab <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f8b:	8b 00                	mov    (%rax),%eax
  802f8d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f91:	48 89 d6             	mov    %rdx,%rsi
  802f94:	89 c7                	mov    %eax,%edi
  802f96:	48 b8 30 2b 80 00 00 	movabs $0x802b30,%rax
  802f9d:	00 00 00 
  802fa0:	ff d0                	callq  *%rax
  802fa2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa9:	79 05                	jns    802fb0 <write+0x5d>
		return r;
  802fab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fae:	eb 75                	jmp    803025 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802fb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb4:	8b 40 08             	mov    0x8(%rax),%eax
  802fb7:	83 e0 03             	and    $0x3,%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	75 3a                	jne    802ff8 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802fbe:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802fc5:	00 00 00 
  802fc8:	48 8b 00             	mov    (%rax),%rax
  802fcb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fd1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802fd4:	89 c6                	mov    %eax,%esi
  802fd6:	48 bf eb 4b 80 00 00 	movabs $0x804beb,%rdi
  802fdd:	00 00 00 
  802fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe5:	48 b9 f3 06 80 00 00 	movabs $0x8006f3,%rcx
  802fec:	00 00 00 
  802fef:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ff1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ff6:	eb 2d                	jmp    803025 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ff8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffc:	48 8b 40 18          	mov    0x18(%rax),%rax
  803000:	48 85 c0             	test   %rax,%rax
  803003:	75 07                	jne    80300c <write+0xb9>
		return -E_NOT_SUPP;
  803005:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80300a:	eb 19                	jmp    803025 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80300c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803010:	48 8b 40 18          	mov    0x18(%rax),%rax
  803014:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803018:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80301c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803020:	48 89 cf             	mov    %rcx,%rdi
  803023:	ff d0                	callq  *%rax
}
  803025:	c9                   	leaveq 
  803026:	c3                   	retq   

0000000000803027 <seek>:

int
seek(int fdnum, off_t offset)
{
  803027:	55                   	push   %rbp
  803028:	48 89 e5             	mov    %rsp,%rbp
  80302b:	48 83 ec 18          	sub    $0x18,%rsp
  80302f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803032:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803035:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803039:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80303c:	48 89 d6             	mov    %rdx,%rsi
  80303f:	89 c7                	mov    %eax,%edi
  803041:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  803048:	00 00 00 
  80304b:	ff d0                	callq  *%rax
  80304d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803050:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803054:	79 05                	jns    80305b <seek+0x34>
		return r;
  803056:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803059:	eb 0f                	jmp    80306a <seek+0x43>
	fd->fd_offset = offset;
  80305b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803062:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803065:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80306a:	c9                   	leaveq 
  80306b:	c3                   	retq   

000000000080306c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80306c:	55                   	push   %rbp
  80306d:	48 89 e5             	mov    %rsp,%rbp
  803070:	48 83 ec 30          	sub    $0x30,%rsp
  803074:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803077:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80307a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80307e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803081:	48 89 d6             	mov    %rdx,%rsi
  803084:	89 c7                	mov    %eax,%edi
  803086:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  80308d:	00 00 00 
  803090:	ff d0                	callq  *%rax
  803092:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803095:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803099:	78 24                	js     8030bf <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80309b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80309f:	8b 00                	mov    (%rax),%eax
  8030a1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030a5:	48 89 d6             	mov    %rdx,%rsi
  8030a8:	89 c7                	mov    %eax,%edi
  8030aa:	48 b8 30 2b 80 00 00 	movabs $0x802b30,%rax
  8030b1:	00 00 00 
  8030b4:	ff d0                	callq  *%rax
  8030b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030bd:	79 05                	jns    8030c4 <ftruncate+0x58>
		return r;
  8030bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c2:	eb 72                	jmp    803136 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8030c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c8:	8b 40 08             	mov    0x8(%rax),%eax
  8030cb:	83 e0 03             	and    $0x3,%eax
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	75 3a                	jne    80310c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8030d2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8030d9:	00 00 00 
  8030dc:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8030df:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8030e5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8030e8:	89 c6                	mov    %eax,%esi
  8030ea:	48 bf 08 4c 80 00 00 	movabs $0x804c08,%rdi
  8030f1:	00 00 00 
  8030f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f9:	48 b9 f3 06 80 00 00 	movabs $0x8006f3,%rcx
  803100:	00 00 00 
  803103:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803105:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80310a:	eb 2a                	jmp    803136 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80310c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803110:	48 8b 40 30          	mov    0x30(%rax),%rax
  803114:	48 85 c0             	test   %rax,%rax
  803117:	75 07                	jne    803120 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803119:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80311e:	eb 16                	jmp    803136 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803120:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803124:	48 8b 40 30          	mov    0x30(%rax),%rax
  803128:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80312c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80312f:	89 ce                	mov    %ecx,%esi
  803131:	48 89 d7             	mov    %rdx,%rdi
  803134:	ff d0                	callq  *%rax
}
  803136:	c9                   	leaveq 
  803137:	c3                   	retq   

0000000000803138 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803138:	55                   	push   %rbp
  803139:	48 89 e5             	mov    %rsp,%rbp
  80313c:	48 83 ec 30          	sub    $0x30,%rsp
  803140:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803143:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803147:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80314b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80314e:	48 89 d6             	mov    %rdx,%rsi
  803151:	89 c7                	mov    %eax,%edi
  803153:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  80315a:	00 00 00 
  80315d:	ff d0                	callq  *%rax
  80315f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803162:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803166:	78 24                	js     80318c <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80316c:	8b 00                	mov    (%rax),%eax
  80316e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803172:	48 89 d6             	mov    %rdx,%rsi
  803175:	89 c7                	mov    %eax,%edi
  803177:	48 b8 30 2b 80 00 00 	movabs $0x802b30,%rax
  80317e:	00 00 00 
  803181:	ff d0                	callq  *%rax
  803183:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803186:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80318a:	79 05                	jns    803191 <fstat+0x59>
		return r;
  80318c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318f:	eb 5e                	jmp    8031ef <fstat+0xb7>
	if (!dev->dev_stat)
  803191:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803195:	48 8b 40 28          	mov    0x28(%rax),%rax
  803199:	48 85 c0             	test   %rax,%rax
  80319c:	75 07                	jne    8031a5 <fstat+0x6d>
		return -E_NOT_SUPP;
  80319e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031a3:	eb 4a                	jmp    8031ef <fstat+0xb7>
	stat->st_name[0] = 0;
  8031a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031a9:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8031ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031b0:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8031b7:	00 00 00 
	stat->st_isdir = 0;
  8031ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031be:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8031c5:	00 00 00 
	stat->st_dev = dev;
  8031c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031d0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8031d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031db:	48 8b 40 28          	mov    0x28(%rax),%rax
  8031df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031e3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8031e7:	48 89 ce             	mov    %rcx,%rsi
  8031ea:	48 89 d7             	mov    %rdx,%rdi
  8031ed:	ff d0                	callq  *%rax
}
  8031ef:	c9                   	leaveq 
  8031f0:	c3                   	retq   

00000000008031f1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8031f1:	55                   	push   %rbp
  8031f2:	48 89 e5             	mov    %rsp,%rbp
  8031f5:	48 83 ec 20          	sub    $0x20,%rsp
  8031f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803201:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803205:	be 00 00 00 00       	mov    $0x0,%esi
  80320a:	48 89 c7             	mov    %rax,%rdi
  80320d:	48 b8 df 32 80 00 00 	movabs $0x8032df,%rax
  803214:	00 00 00 
  803217:	ff d0                	callq  *%rax
  803219:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80321c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803220:	79 05                	jns    803227 <stat+0x36>
		return fd;
  803222:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803225:	eb 2f                	jmp    803256 <stat+0x65>
	r = fstat(fd, stat);
  803227:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80322b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322e:	48 89 d6             	mov    %rdx,%rsi
  803231:	89 c7                	mov    %eax,%edi
  803233:	48 b8 38 31 80 00 00 	movabs $0x803138,%rax
  80323a:	00 00 00 
  80323d:	ff d0                	callq  *%rax
  80323f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803242:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803245:	89 c7                	mov    %eax,%edi
  803247:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  80324e:	00 00 00 
  803251:	ff d0                	callq  *%rax
	return r;
  803253:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803256:	c9                   	leaveq 
  803257:	c3                   	retq   

0000000000803258 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803258:	55                   	push   %rbp
  803259:	48 89 e5             	mov    %rsp,%rbp
  80325c:	48 83 ec 10          	sub    $0x10,%rsp
  803260:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803263:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803267:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80326e:	00 00 00 
  803271:	8b 00                	mov    (%rax),%eax
  803273:	85 c0                	test   %eax,%eax
  803275:	75 1d                	jne    803294 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803277:	bf 01 00 00 00       	mov    $0x1,%edi
  80327c:	48 b8 9e 43 80 00 00 	movabs $0x80439e,%rax
  803283:	00 00 00 
  803286:	ff d0                	callq  *%rax
  803288:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80328f:	00 00 00 
  803292:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803294:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80329b:	00 00 00 
  80329e:	8b 00                	mov    (%rax),%eax
  8032a0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8032a3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8032a8:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8032af:	00 00 00 
  8032b2:	89 c7                	mov    %eax,%edi
  8032b4:	48 b8 9f 42 80 00 00 	movabs $0x80429f,%rax
  8032bb:	00 00 00 
  8032be:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8032c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8032c9:	48 89 c6             	mov    %rax,%rsi
  8032cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8032d1:	48 b8 ec 41 80 00 00 	movabs $0x8041ec,%rax
  8032d8:	00 00 00 
  8032db:	ff d0                	callq  *%rax
}
  8032dd:	c9                   	leaveq 
  8032de:	c3                   	retq   

00000000008032df <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8032df:	55                   	push   %rbp
  8032e0:	48 89 e5             	mov    %rsp,%rbp
  8032e3:	48 83 ec 20          	sub    $0x20,%rsp
  8032e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032eb:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  8032ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032f2:	48 89 c7             	mov    %rax,%rdi
  8032f5:	48 b8 7d 12 80 00 00 	movabs $0x80127d,%rax
  8032fc:	00 00 00 
  8032ff:	ff d0                	callq  *%rax
  803301:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803306:	7e 0a                	jle    803312 <open+0x33>
		return -E_BAD_PATH;
  803308:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80330d:	e9 a5 00 00 00       	jmpq   8033b7 <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  803312:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803316:	48 89 c7             	mov    %rax,%rdi
  803319:	48 b8 3f 29 80 00 00 	movabs $0x80293f,%rax
  803320:	00 00 00 
  803323:	ff d0                	callq  *%rax
  803325:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803328:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332c:	79 08                	jns    803336 <open+0x57>
		return ret;
  80332e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803331:	e9 81 00 00 00       	jmpq   8033b7 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  803336:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80333d:	00 00 00 
  803340:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803343:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  803349:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80334d:	48 89 c6             	mov    %rax,%rsi
  803350:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803357:	00 00 00 
  80335a:	48 b8 e9 12 80 00 00 	movabs $0x8012e9,%rax
  803361:	00 00 00 
  803364:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  803366:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80336a:	48 89 c6             	mov    %rax,%rsi
  80336d:	bf 01 00 00 00       	mov    $0x1,%edi
  803372:	48 b8 58 32 80 00 00 	movabs $0x803258,%rax
  803379:	00 00 00 
  80337c:	ff d0                	callq  *%rax
  80337e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803381:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803385:	79 1d                	jns    8033a4 <open+0xc5>
	{
		fd_close(fd,0);
  803387:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338b:	be 00 00 00 00       	mov    $0x0,%esi
  803390:	48 89 c7             	mov    %rax,%rdi
  803393:	48 b8 67 2a 80 00 00 	movabs $0x802a67,%rax
  80339a:	00 00 00 
  80339d:	ff d0                	callq  *%rax
		return ret;
  80339f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a2:	eb 13                	jmp    8033b7 <open+0xd8>
	}
	return fd2num (fd);
  8033a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a8:	48 89 c7             	mov    %rax,%rdi
  8033ab:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  8033b2:	00 00 00 
  8033b5:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  8033b7:	c9                   	leaveq 
  8033b8:	c3                   	retq   

00000000008033b9 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8033b9:	55                   	push   %rbp
  8033ba:	48 89 e5             	mov    %rsp,%rbp
  8033bd:	48 83 ec 10          	sub    $0x10,%rsp
  8033c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8033c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033c9:	8b 50 0c             	mov    0xc(%rax),%edx
  8033cc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033d3:	00 00 00 
  8033d6:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8033d8:	be 00 00 00 00       	mov    $0x0,%esi
  8033dd:	bf 06 00 00 00       	mov    $0x6,%edi
  8033e2:	48 b8 58 32 80 00 00 	movabs $0x803258,%rax
  8033e9:	00 00 00 
  8033ec:	ff d0                	callq  *%rax
}
  8033ee:	c9                   	leaveq 
  8033ef:	c3                   	retq   

00000000008033f0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8033f0:	55                   	push   %rbp
  8033f1:	48 89 e5             	mov    %rsp,%rbp
  8033f4:	48 83 ec 30          	sub    $0x30,%rsp
  8033f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803400:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  803404:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803408:	8b 50 0c             	mov    0xc(%rax),%edx
  80340b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803412:	00 00 00 
  803415:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  803417:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80341e:	00 00 00 
  803421:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803425:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  803429:	be 00 00 00 00       	mov    $0x0,%esi
  80342e:	bf 03 00 00 00       	mov    $0x3,%edi
  803433:	48 b8 58 32 80 00 00 	movabs $0x803258,%rax
  80343a:	00 00 00 
  80343d:	ff d0                	callq  *%rax
  80343f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803442:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803446:	79 05                	jns    80344d <devfile_read+0x5d>
		return ret;
  803448:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344b:	eb 26                	jmp    803473 <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  80344d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803450:	48 63 d0             	movslq %eax,%rdx
  803453:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803457:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80345e:	00 00 00 
  803461:	48 89 c7             	mov    %rax,%rdi
  803464:	48 b8 0d 16 80 00 00 	movabs $0x80160d,%rax
  80346b:	00 00 00 
  80346e:	ff d0                	callq  *%rax
	return ret;
  803470:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  803473:	c9                   	leaveq 
  803474:	c3                   	retq   

0000000000803475 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803475:	55                   	push   %rbp
  803476:	48 89 e5             	mov    %rsp,%rbp
  803479:	48 83 ec 30          	sub    $0x30,%rsp
  80347d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803481:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803485:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  803489:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80348d:	8b 50 0c             	mov    0xc(%rax),%edx
  803490:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803497:	00 00 00 
  80349a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  80349c:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  8034a1:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8034a8:	00 
  8034a9:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8034ae:	48 89 c2             	mov    %rax,%rdx
  8034b1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034b8:	00 00 00 
  8034bb:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8034bf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034c6:	00 00 00 
  8034c9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8034cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034d1:	48 89 c6             	mov    %rax,%rsi
  8034d4:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8034db:	00 00 00 
  8034de:	48 b8 0d 16 80 00 00 	movabs $0x80160d,%rax
  8034e5:	00 00 00 
  8034e8:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  8034ea:	be 00 00 00 00       	mov    $0x0,%esi
  8034ef:	bf 04 00 00 00       	mov    $0x4,%edi
  8034f4:	48 b8 58 32 80 00 00 	movabs $0x803258,%rax
  8034fb:	00 00 00 
  8034fe:	ff d0                	callq  *%rax
  803500:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803503:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803507:	79 05                	jns    80350e <devfile_write+0x99>
		return ret;
  803509:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350c:	eb 03                	jmp    803511 <devfile_write+0x9c>
	
	return ret;
  80350e:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  803511:	c9                   	leaveq 
  803512:	c3                   	retq   

0000000000803513 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803513:	55                   	push   %rbp
  803514:	48 89 e5             	mov    %rsp,%rbp
  803517:	48 83 ec 20          	sub    $0x20,%rsp
  80351b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80351f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803527:	8b 50 0c             	mov    0xc(%rax),%edx
  80352a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803531:	00 00 00 
  803534:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803536:	be 00 00 00 00       	mov    $0x0,%esi
  80353b:	bf 05 00 00 00       	mov    $0x5,%edi
  803540:	48 b8 58 32 80 00 00 	movabs $0x803258,%rax
  803547:	00 00 00 
  80354a:	ff d0                	callq  *%rax
  80354c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80354f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803553:	79 05                	jns    80355a <devfile_stat+0x47>
		return r;
  803555:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803558:	eb 56                	jmp    8035b0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80355a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80355e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803565:	00 00 00 
  803568:	48 89 c7             	mov    %rax,%rdi
  80356b:	48 b8 e9 12 80 00 00 	movabs $0x8012e9,%rax
  803572:	00 00 00 
  803575:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803577:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80357e:	00 00 00 
  803581:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803587:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80358b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803591:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803598:	00 00 00 
  80359b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8035a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8035ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035b0:	c9                   	leaveq 
  8035b1:	c3                   	retq   

00000000008035b2 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8035b2:	55                   	push   %rbp
  8035b3:	48 89 e5             	mov    %rsp,%rbp
  8035b6:	48 83 ec 10          	sub    $0x10,%rsp
  8035ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035be:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8035c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c5:	8b 50 0c             	mov    0xc(%rax),%edx
  8035c8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035cf:	00 00 00 
  8035d2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8035d4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035db:	00 00 00 
  8035de:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8035e1:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8035e4:	be 00 00 00 00       	mov    $0x0,%esi
  8035e9:	bf 02 00 00 00       	mov    $0x2,%edi
  8035ee:	48 b8 58 32 80 00 00 	movabs $0x803258,%rax
  8035f5:	00 00 00 
  8035f8:	ff d0                	callq  *%rax
}
  8035fa:	c9                   	leaveq 
  8035fb:	c3                   	retq   

00000000008035fc <remove>:

// Delete a file
int
remove(const char *path)
{
  8035fc:	55                   	push   %rbp
  8035fd:	48 89 e5             	mov    %rsp,%rbp
  803600:	48 83 ec 10          	sub    $0x10,%rsp
  803604:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803608:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80360c:	48 89 c7             	mov    %rax,%rdi
  80360f:	48 b8 7d 12 80 00 00 	movabs $0x80127d,%rax
  803616:	00 00 00 
  803619:	ff d0                	callq  *%rax
  80361b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803620:	7e 07                	jle    803629 <remove+0x2d>
		return -E_BAD_PATH;
  803622:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803627:	eb 33                	jmp    80365c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803629:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80362d:	48 89 c6             	mov    %rax,%rsi
  803630:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803637:	00 00 00 
  80363a:	48 b8 e9 12 80 00 00 	movabs $0x8012e9,%rax
  803641:	00 00 00 
  803644:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803646:	be 00 00 00 00       	mov    $0x0,%esi
  80364b:	bf 07 00 00 00       	mov    $0x7,%edi
  803650:	48 b8 58 32 80 00 00 	movabs $0x803258,%rax
  803657:	00 00 00 
  80365a:	ff d0                	callq  *%rax
}
  80365c:	c9                   	leaveq 
  80365d:	c3                   	retq   

000000000080365e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80365e:	55                   	push   %rbp
  80365f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803662:	be 00 00 00 00       	mov    $0x0,%esi
  803667:	bf 08 00 00 00       	mov    $0x8,%edi
  80366c:	48 b8 58 32 80 00 00 	movabs $0x803258,%rax
  803673:	00 00 00 
  803676:	ff d0                	callq  *%rax
}
  803678:	5d                   	pop    %rbp
  803679:	c3                   	retq   

000000000080367a <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80367a:	55                   	push   %rbp
  80367b:	48 89 e5             	mov    %rsp,%rbp
  80367e:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803685:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80368c:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803693:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80369a:	be 00 00 00 00       	mov    $0x0,%esi
  80369f:	48 89 c7             	mov    %rax,%rdi
  8036a2:	48 b8 df 32 80 00 00 	movabs $0x8032df,%rax
  8036a9:	00 00 00 
  8036ac:	ff d0                	callq  *%rax
  8036ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8036b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b5:	79 28                	jns    8036df <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8036b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ba:	89 c6                	mov    %eax,%esi
  8036bc:	48 bf 2e 4c 80 00 00 	movabs $0x804c2e,%rdi
  8036c3:	00 00 00 
  8036c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8036cb:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  8036d2:	00 00 00 
  8036d5:	ff d2                	callq  *%rdx
		return fd_src;
  8036d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036da:	e9 74 01 00 00       	jmpq   803853 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8036df:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8036e6:	be 01 01 00 00       	mov    $0x101,%esi
  8036eb:	48 89 c7             	mov    %rax,%rdi
  8036ee:	48 b8 df 32 80 00 00 	movabs $0x8032df,%rax
  8036f5:	00 00 00 
  8036f8:	ff d0                	callq  *%rax
  8036fa:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8036fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803701:	79 39                	jns    80373c <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803703:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803706:	89 c6                	mov    %eax,%esi
  803708:	48 bf 44 4c 80 00 00 	movabs $0x804c44,%rdi
  80370f:	00 00 00 
  803712:	b8 00 00 00 00       	mov    $0x0,%eax
  803717:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  80371e:	00 00 00 
  803721:	ff d2                	callq  *%rdx
		close(fd_src);
  803723:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803726:	89 c7                	mov    %eax,%edi
  803728:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  80372f:	00 00 00 
  803732:	ff d0                	callq  *%rax
		return fd_dest;
  803734:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803737:	e9 17 01 00 00       	jmpq   803853 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80373c:	eb 74                	jmp    8037b2 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80373e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803741:	48 63 d0             	movslq %eax,%rdx
  803744:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80374b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80374e:	48 89 ce             	mov    %rcx,%rsi
  803751:	89 c7                	mov    %eax,%edi
  803753:	48 b8 53 2f 80 00 00 	movabs $0x802f53,%rax
  80375a:	00 00 00 
  80375d:	ff d0                	callq  *%rax
  80375f:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803762:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803766:	79 4a                	jns    8037b2 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803768:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80376b:	89 c6                	mov    %eax,%esi
  80376d:	48 bf 5e 4c 80 00 00 	movabs $0x804c5e,%rdi
  803774:	00 00 00 
  803777:	b8 00 00 00 00       	mov    $0x0,%eax
  80377c:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  803783:	00 00 00 
  803786:	ff d2                	callq  *%rdx
			close(fd_src);
  803788:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80378b:	89 c7                	mov    %eax,%edi
  80378d:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  803794:	00 00 00 
  803797:	ff d0                	callq  *%rax
			close(fd_dest);
  803799:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80379c:	89 c7                	mov    %eax,%edi
  80379e:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  8037a5:	00 00 00 
  8037a8:	ff d0                	callq  *%rax
			return write_size;
  8037aa:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8037ad:	e9 a1 00 00 00       	jmpq   803853 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8037b2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8037b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037bc:	ba 00 02 00 00       	mov    $0x200,%edx
  8037c1:	48 89 ce             	mov    %rcx,%rsi
  8037c4:	89 c7                	mov    %eax,%edi
  8037c6:	48 b8 09 2e 80 00 00 	movabs $0x802e09,%rax
  8037cd:	00 00 00 
  8037d0:	ff d0                	callq  *%rax
  8037d2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8037d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8037d9:	0f 8f 5f ff ff ff    	jg     80373e <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8037df:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8037e3:	79 47                	jns    80382c <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8037e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037e8:	89 c6                	mov    %eax,%esi
  8037ea:	48 bf 71 4c 80 00 00 	movabs $0x804c71,%rdi
  8037f1:	00 00 00 
  8037f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f9:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  803800:	00 00 00 
  803803:	ff d2                	callq  *%rdx
		close(fd_src);
  803805:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803808:	89 c7                	mov    %eax,%edi
  80380a:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  803811:	00 00 00 
  803814:	ff d0                	callq  *%rax
		close(fd_dest);
  803816:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803819:	89 c7                	mov    %eax,%edi
  80381b:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  803822:	00 00 00 
  803825:	ff d0                	callq  *%rax
		return read_size;
  803827:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80382a:	eb 27                	jmp    803853 <copy+0x1d9>
	}
	close(fd_src);
  80382c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382f:	89 c7                	mov    %eax,%edi
  803831:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  803838:	00 00 00 
  80383b:	ff d0                	callq  *%rax
	close(fd_dest);
  80383d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803840:	89 c7                	mov    %eax,%edi
  803842:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  803849:	00 00 00 
  80384c:	ff d0                	callq  *%rax
	return 0;
  80384e:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803853:	c9                   	leaveq 
  803854:	c3                   	retq   

0000000000803855 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803855:	55                   	push   %rbp
  803856:	48 89 e5             	mov    %rsp,%rbp
  803859:	53                   	push   %rbx
  80385a:	48 83 ec 38          	sub    $0x38,%rsp
  80385e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803862:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803866:	48 89 c7             	mov    %rax,%rdi
  803869:	48 b8 3f 29 80 00 00 	movabs $0x80293f,%rax
  803870:	00 00 00 
  803873:	ff d0                	callq  *%rax
  803875:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803878:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80387c:	0f 88 bf 01 00 00    	js     803a41 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803882:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803886:	ba 07 04 00 00       	mov    $0x407,%edx
  80388b:	48 89 c6             	mov    %rax,%rsi
  80388e:	bf 00 00 00 00       	mov    $0x0,%edi
  803893:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  80389a:	00 00 00 
  80389d:	ff d0                	callq  *%rax
  80389f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038a6:	0f 88 95 01 00 00    	js     803a41 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8038ac:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8038b0:	48 89 c7             	mov    %rax,%rdi
  8038b3:	48 b8 3f 29 80 00 00 	movabs $0x80293f,%rax
  8038ba:	00 00 00 
  8038bd:	ff d0                	callq  *%rax
  8038bf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038c6:	0f 88 5d 01 00 00    	js     803a29 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038d0:	ba 07 04 00 00       	mov    $0x407,%edx
  8038d5:	48 89 c6             	mov    %rax,%rsi
  8038d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8038dd:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  8038e4:	00 00 00 
  8038e7:	ff d0                	callq  *%rax
  8038e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038f0:	0f 88 33 01 00 00    	js     803a29 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8038f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038fa:	48 89 c7             	mov    %rax,%rdi
  8038fd:	48 b8 14 29 80 00 00 	movabs $0x802914,%rax
  803904:	00 00 00 
  803907:	ff d0                	callq  *%rax
  803909:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80390d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803911:	ba 07 04 00 00       	mov    $0x407,%edx
  803916:	48 89 c6             	mov    %rax,%rsi
  803919:	bf 00 00 00 00       	mov    $0x0,%edi
  80391e:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  803925:	00 00 00 
  803928:	ff d0                	callq  *%rax
  80392a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80392d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803931:	79 05                	jns    803938 <pipe+0xe3>
		goto err2;
  803933:	e9 d9 00 00 00       	jmpq   803a11 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803938:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80393c:	48 89 c7             	mov    %rax,%rdi
  80393f:	48 b8 14 29 80 00 00 	movabs $0x802914,%rax
  803946:	00 00 00 
  803949:	ff d0                	callq  *%rax
  80394b:	48 89 c2             	mov    %rax,%rdx
  80394e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803952:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803958:	48 89 d1             	mov    %rdx,%rcx
  80395b:	ba 00 00 00 00       	mov    $0x0,%edx
  803960:	48 89 c6             	mov    %rax,%rsi
  803963:	bf 00 00 00 00       	mov    $0x0,%edi
  803968:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  80396f:	00 00 00 
  803972:	ff d0                	callq  *%rax
  803974:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803977:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80397b:	79 1b                	jns    803998 <pipe+0x143>
		goto err3;
  80397d:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80397e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803982:	48 89 c6             	mov    %rax,%rsi
  803985:	bf 00 00 00 00       	mov    $0x0,%edi
  80398a:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
  803996:	eb 79                	jmp    803a11 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803998:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80399c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039a3:	00 00 00 
  8039a6:	8b 12                	mov    (%rdx),%edx
  8039a8:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8039aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8039b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039b9:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039c0:	00 00 00 
  8039c3:	8b 12                	mov    (%rdx),%edx
  8039c5:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8039c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039cb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8039d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d6:	48 89 c7             	mov    %rax,%rdi
  8039d9:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  8039e0:	00 00 00 
  8039e3:	ff d0                	callq  *%rax
  8039e5:	89 c2                	mov    %eax,%edx
  8039e7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039eb:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8039ed:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039f1:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8039f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039f9:	48 89 c7             	mov    %rax,%rdi
  8039fc:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  803a03:	00 00 00 
  803a06:	ff d0                	callq  *%rax
  803a08:	89 03                	mov    %eax,(%rbx)
	return 0;
  803a0a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a0f:	eb 33                	jmp    803a44 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803a11:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a15:	48 89 c6             	mov    %rax,%rsi
  803a18:	bf 00 00 00 00       	mov    $0x0,%edi
  803a1d:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  803a24:	00 00 00 
  803a27:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803a29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a2d:	48 89 c6             	mov    %rax,%rsi
  803a30:	bf 00 00 00 00       	mov    $0x0,%edi
  803a35:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  803a3c:	00 00 00 
  803a3f:	ff d0                	callq  *%rax
err:
	return r;
  803a41:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803a44:	48 83 c4 38          	add    $0x38,%rsp
  803a48:	5b                   	pop    %rbx
  803a49:	5d                   	pop    %rbp
  803a4a:	c3                   	retq   

0000000000803a4b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803a4b:	55                   	push   %rbp
  803a4c:	48 89 e5             	mov    %rsp,%rbp
  803a4f:	53                   	push   %rbx
  803a50:	48 83 ec 28          	sub    $0x28,%rsp
  803a54:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a58:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803a5c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a63:	00 00 00 
  803a66:	48 8b 00             	mov    (%rax),%rax
  803a69:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a6f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803a72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a76:	48 89 c7             	mov    %rax,%rdi
  803a79:	48 b8 10 44 80 00 00 	movabs $0x804410,%rax
  803a80:	00 00 00 
  803a83:	ff d0                	callq  *%rax
  803a85:	89 c3                	mov    %eax,%ebx
  803a87:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a8b:	48 89 c7             	mov    %rax,%rdi
  803a8e:	48 b8 10 44 80 00 00 	movabs $0x804410,%rax
  803a95:	00 00 00 
  803a98:	ff d0                	callq  *%rax
  803a9a:	39 c3                	cmp    %eax,%ebx
  803a9c:	0f 94 c0             	sete   %al
  803a9f:	0f b6 c0             	movzbl %al,%eax
  803aa2:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803aa5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803aac:	00 00 00 
  803aaf:	48 8b 00             	mov    (%rax),%rax
  803ab2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ab8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803abb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803abe:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ac1:	75 05                	jne    803ac8 <_pipeisclosed+0x7d>
			return ret;
  803ac3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803ac6:	eb 4f                	jmp    803b17 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803ac8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803acb:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ace:	74 42                	je     803b12 <_pipeisclosed+0xc7>
  803ad0:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803ad4:	75 3c                	jne    803b12 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803ad6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803add:	00 00 00 
  803ae0:	48 8b 00             	mov    (%rax),%rax
  803ae3:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803ae9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803aec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aef:	89 c6                	mov    %eax,%esi
  803af1:	48 bf 91 4c 80 00 00 	movabs $0x804c91,%rdi
  803af8:	00 00 00 
  803afb:	b8 00 00 00 00       	mov    $0x0,%eax
  803b00:	49 b8 f3 06 80 00 00 	movabs $0x8006f3,%r8
  803b07:	00 00 00 
  803b0a:	41 ff d0             	callq  *%r8
	}
  803b0d:	e9 4a ff ff ff       	jmpq   803a5c <_pipeisclosed+0x11>
  803b12:	e9 45 ff ff ff       	jmpq   803a5c <_pipeisclosed+0x11>
}
  803b17:	48 83 c4 28          	add    $0x28,%rsp
  803b1b:	5b                   	pop    %rbx
  803b1c:	5d                   	pop    %rbp
  803b1d:	c3                   	retq   

0000000000803b1e <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803b1e:	55                   	push   %rbp
  803b1f:	48 89 e5             	mov    %rsp,%rbp
  803b22:	48 83 ec 30          	sub    $0x30,%rsp
  803b26:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b29:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b2d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b30:	48 89 d6             	mov    %rdx,%rsi
  803b33:	89 c7                	mov    %eax,%edi
  803b35:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  803b3c:	00 00 00 
  803b3f:	ff d0                	callq  *%rax
  803b41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b48:	79 05                	jns    803b4f <pipeisclosed+0x31>
		return r;
  803b4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b4d:	eb 31                	jmp    803b80 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803b4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b53:	48 89 c7             	mov    %rax,%rdi
  803b56:	48 b8 14 29 80 00 00 	movabs $0x802914,%rax
  803b5d:	00 00 00 
  803b60:	ff d0                	callq  *%rax
  803b62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803b66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b6e:	48 89 d6             	mov    %rdx,%rsi
  803b71:	48 89 c7             	mov    %rax,%rdi
  803b74:	48 b8 4b 3a 80 00 00 	movabs $0x803a4b,%rax
  803b7b:	00 00 00 
  803b7e:	ff d0                	callq  *%rax
}
  803b80:	c9                   	leaveq 
  803b81:	c3                   	retq   

0000000000803b82 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b82:	55                   	push   %rbp
  803b83:	48 89 e5             	mov    %rsp,%rbp
  803b86:	48 83 ec 40          	sub    $0x40,%rsp
  803b8a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b8e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b92:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803b96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b9a:	48 89 c7             	mov    %rax,%rdi
  803b9d:	48 b8 14 29 80 00 00 	movabs $0x802914,%rax
  803ba4:	00 00 00 
  803ba7:	ff d0                	callq  *%rax
  803ba9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803bad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bb1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803bb5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803bbc:	00 
  803bbd:	e9 92 00 00 00       	jmpq   803c54 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803bc2:	eb 41                	jmp    803c05 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803bc4:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803bc9:	74 09                	je     803bd4 <devpipe_read+0x52>
				return i;
  803bcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bcf:	e9 92 00 00 00       	jmpq   803c66 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803bd4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bdc:	48 89 d6             	mov    %rdx,%rsi
  803bdf:	48 89 c7             	mov    %rax,%rdi
  803be2:	48 b8 4b 3a 80 00 00 	movabs $0x803a4b,%rax
  803be9:	00 00 00 
  803bec:	ff d0                	callq  *%rax
  803bee:	85 c0                	test   %eax,%eax
  803bf0:	74 07                	je     803bf9 <devpipe_read+0x77>
				return 0;
  803bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf7:	eb 6d                	jmp    803c66 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803bf9:	48 b8 da 1b 80 00 00 	movabs $0x801bda,%rax
  803c00:	00 00 00 
  803c03:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803c05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c09:	8b 10                	mov    (%rax),%edx
  803c0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c0f:	8b 40 04             	mov    0x4(%rax),%eax
  803c12:	39 c2                	cmp    %eax,%edx
  803c14:	74 ae                	je     803bc4 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803c16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c1a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c1e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803c22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c26:	8b 00                	mov    (%rax),%eax
  803c28:	99                   	cltd   
  803c29:	c1 ea 1b             	shr    $0x1b,%edx
  803c2c:	01 d0                	add    %edx,%eax
  803c2e:	83 e0 1f             	and    $0x1f,%eax
  803c31:	29 d0                	sub    %edx,%eax
  803c33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c37:	48 98                	cltq   
  803c39:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803c3e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803c40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c44:	8b 00                	mov    (%rax),%eax
  803c46:	8d 50 01             	lea    0x1(%rax),%edx
  803c49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c4d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c4f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c58:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c5c:	0f 82 60 ff ff ff    	jb     803bc2 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803c62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c66:	c9                   	leaveq 
  803c67:	c3                   	retq   

0000000000803c68 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c68:	55                   	push   %rbp
  803c69:	48 89 e5             	mov    %rsp,%rbp
  803c6c:	48 83 ec 40          	sub    $0x40,%rsp
  803c70:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c74:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c78:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803c7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c80:	48 89 c7             	mov    %rax,%rdi
  803c83:	48 b8 14 29 80 00 00 	movabs $0x802914,%rax
  803c8a:	00 00 00 
  803c8d:	ff d0                	callq  *%rax
  803c8f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c97:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c9b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ca2:	00 
  803ca3:	e9 8e 00 00 00       	jmpq   803d36 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ca8:	eb 31                	jmp    803cdb <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803caa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cb2:	48 89 d6             	mov    %rdx,%rsi
  803cb5:	48 89 c7             	mov    %rax,%rdi
  803cb8:	48 b8 4b 3a 80 00 00 	movabs $0x803a4b,%rax
  803cbf:	00 00 00 
  803cc2:	ff d0                	callq  *%rax
  803cc4:	85 c0                	test   %eax,%eax
  803cc6:	74 07                	je     803ccf <devpipe_write+0x67>
				return 0;
  803cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  803ccd:	eb 79                	jmp    803d48 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803ccf:	48 b8 da 1b 80 00 00 	movabs $0x801bda,%rax
  803cd6:	00 00 00 
  803cd9:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803cdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cdf:	8b 40 04             	mov    0x4(%rax),%eax
  803ce2:	48 63 d0             	movslq %eax,%rdx
  803ce5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce9:	8b 00                	mov    (%rax),%eax
  803ceb:	48 98                	cltq   
  803ced:	48 83 c0 20          	add    $0x20,%rax
  803cf1:	48 39 c2             	cmp    %rax,%rdx
  803cf4:	73 b4                	jae    803caa <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803cf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfa:	8b 40 04             	mov    0x4(%rax),%eax
  803cfd:	99                   	cltd   
  803cfe:	c1 ea 1b             	shr    $0x1b,%edx
  803d01:	01 d0                	add    %edx,%eax
  803d03:	83 e0 1f             	and    $0x1f,%eax
  803d06:	29 d0                	sub    %edx,%eax
  803d08:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d0c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803d10:	48 01 ca             	add    %rcx,%rdx
  803d13:	0f b6 0a             	movzbl (%rdx),%ecx
  803d16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d1a:	48 98                	cltq   
  803d1c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803d20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d24:	8b 40 04             	mov    0x4(%rax),%eax
  803d27:	8d 50 01             	lea    0x1(%rax),%edx
  803d2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d2e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d31:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d3a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d3e:	0f 82 64 ff ff ff    	jb     803ca8 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803d44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d48:	c9                   	leaveq 
  803d49:	c3                   	retq   

0000000000803d4a <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803d4a:	55                   	push   %rbp
  803d4b:	48 89 e5             	mov    %rsp,%rbp
  803d4e:	48 83 ec 20          	sub    $0x20,%rsp
  803d52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d5e:	48 89 c7             	mov    %rax,%rdi
  803d61:	48 b8 14 29 80 00 00 	movabs $0x802914,%rax
  803d68:	00 00 00 
  803d6b:	ff d0                	callq  *%rax
  803d6d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803d71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d75:	48 be a4 4c 80 00 00 	movabs $0x804ca4,%rsi
  803d7c:	00 00 00 
  803d7f:	48 89 c7             	mov    %rax,%rdi
  803d82:	48 b8 e9 12 80 00 00 	movabs $0x8012e9,%rax
  803d89:	00 00 00 
  803d8c:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803d8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d92:	8b 50 04             	mov    0x4(%rax),%edx
  803d95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d99:	8b 00                	mov    (%rax),%eax
  803d9b:	29 c2                	sub    %eax,%edx
  803d9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803da1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803da7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dab:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803db2:	00 00 00 
	stat->st_dev = &devpipe;
  803db5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803db9:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803dc0:	00 00 00 
  803dc3:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803dca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dcf:	c9                   	leaveq 
  803dd0:	c3                   	retq   

0000000000803dd1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803dd1:	55                   	push   %rbp
  803dd2:	48 89 e5             	mov    %rsp,%rbp
  803dd5:	48 83 ec 10          	sub    $0x10,%rsp
  803dd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803ddd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803de1:	48 89 c6             	mov    %rax,%rsi
  803de4:	bf 00 00 00 00       	mov    $0x0,%edi
  803de9:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  803df0:	00 00 00 
  803df3:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803df5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803df9:	48 89 c7             	mov    %rax,%rdi
  803dfc:	48 b8 14 29 80 00 00 	movabs $0x802914,%rax
  803e03:	00 00 00 
  803e06:	ff d0                	callq  *%rax
  803e08:	48 89 c6             	mov    %rax,%rsi
  803e0b:	bf 00 00 00 00       	mov    $0x0,%edi
  803e10:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  803e17:	00 00 00 
  803e1a:	ff d0                	callq  *%rax
}
  803e1c:	c9                   	leaveq 
  803e1d:	c3                   	retq   

0000000000803e1e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803e1e:	55                   	push   %rbp
  803e1f:	48 89 e5             	mov    %rsp,%rbp
  803e22:	48 83 ec 20          	sub    $0x20,%rsp
  803e26:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803e29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e2c:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803e2f:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803e33:	be 01 00 00 00       	mov    $0x1,%esi
  803e38:	48 89 c7             	mov    %rax,%rdi
  803e3b:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803e42:	00 00 00 
  803e45:	ff d0                	callq  *%rax
}
  803e47:	c9                   	leaveq 
  803e48:	c3                   	retq   

0000000000803e49 <getchar>:

int
getchar(void)
{
  803e49:	55                   	push   %rbp
  803e4a:	48 89 e5             	mov    %rsp,%rbp
  803e4d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803e51:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803e55:	ba 01 00 00 00       	mov    $0x1,%edx
  803e5a:	48 89 c6             	mov    %rax,%rsi
  803e5d:	bf 00 00 00 00       	mov    $0x0,%edi
  803e62:	48 b8 09 2e 80 00 00 	movabs $0x802e09,%rax
  803e69:	00 00 00 
  803e6c:	ff d0                	callq  *%rax
  803e6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803e71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e75:	79 05                	jns    803e7c <getchar+0x33>
		return r;
  803e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e7a:	eb 14                	jmp    803e90 <getchar+0x47>
	if (r < 1)
  803e7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e80:	7f 07                	jg     803e89 <getchar+0x40>
		return -E_EOF;
  803e82:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803e87:	eb 07                	jmp    803e90 <getchar+0x47>
	return c;
  803e89:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803e8d:	0f b6 c0             	movzbl %al,%eax
}
  803e90:	c9                   	leaveq 
  803e91:	c3                   	retq   

0000000000803e92 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803e92:	55                   	push   %rbp
  803e93:	48 89 e5             	mov    %rsp,%rbp
  803e96:	48 83 ec 20          	sub    $0x20,%rsp
  803e9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e9d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ea1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ea4:	48 89 d6             	mov    %rdx,%rsi
  803ea7:	89 c7                	mov    %eax,%edi
  803ea9:	48 b8 d7 29 80 00 00 	movabs $0x8029d7,%rax
  803eb0:	00 00 00 
  803eb3:	ff d0                	callq  *%rax
  803eb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ebc:	79 05                	jns    803ec3 <iscons+0x31>
		return r;
  803ebe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec1:	eb 1a                	jmp    803edd <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803ec3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ec7:	8b 10                	mov    (%rax),%edx
  803ec9:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803ed0:	00 00 00 
  803ed3:	8b 00                	mov    (%rax),%eax
  803ed5:	39 c2                	cmp    %eax,%edx
  803ed7:	0f 94 c0             	sete   %al
  803eda:	0f b6 c0             	movzbl %al,%eax
}
  803edd:	c9                   	leaveq 
  803ede:	c3                   	retq   

0000000000803edf <opencons>:

int
opencons(void)
{
  803edf:	55                   	push   %rbp
  803ee0:	48 89 e5             	mov    %rsp,%rbp
  803ee3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803ee7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803eeb:	48 89 c7             	mov    %rax,%rdi
  803eee:	48 b8 3f 29 80 00 00 	movabs $0x80293f,%rax
  803ef5:	00 00 00 
  803ef8:	ff d0                	callq  *%rax
  803efa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803efd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f01:	79 05                	jns    803f08 <opencons+0x29>
		return r;
  803f03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f06:	eb 5b                	jmp    803f63 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803f08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f0c:	ba 07 04 00 00       	mov    $0x407,%edx
  803f11:	48 89 c6             	mov    %rax,%rsi
  803f14:	bf 00 00 00 00       	mov    $0x0,%edi
  803f19:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  803f20:	00 00 00 
  803f23:	ff d0                	callq  *%rax
  803f25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f2c:	79 05                	jns    803f33 <opencons+0x54>
		return r;
  803f2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f31:	eb 30                	jmp    803f63 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803f33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f37:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803f3e:	00 00 00 
  803f41:	8b 12                	mov    (%rdx),%edx
  803f43:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803f45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f49:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803f50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f54:	48 89 c7             	mov    %rax,%rdi
  803f57:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  803f5e:	00 00 00 
  803f61:	ff d0                	callq  *%rax
}
  803f63:	c9                   	leaveq 
  803f64:	c3                   	retq   

0000000000803f65 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f65:	55                   	push   %rbp
  803f66:	48 89 e5             	mov    %rsp,%rbp
  803f69:	48 83 ec 30          	sub    $0x30,%rsp
  803f6d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f71:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f75:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803f79:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f7e:	75 07                	jne    803f87 <devcons_read+0x22>
		return 0;
  803f80:	b8 00 00 00 00       	mov    $0x0,%eax
  803f85:	eb 4b                	jmp    803fd2 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803f87:	eb 0c                	jmp    803f95 <devcons_read+0x30>
		sys_yield();
  803f89:	48 b8 da 1b 80 00 00 	movabs $0x801bda,%rax
  803f90:	00 00 00 
  803f93:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803f95:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  803f9c:	00 00 00 
  803f9f:	ff d0                	callq  *%rax
  803fa1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fa4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fa8:	74 df                	je     803f89 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803faa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fae:	79 05                	jns    803fb5 <devcons_read+0x50>
		return c;
  803fb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb3:	eb 1d                	jmp    803fd2 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803fb5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803fb9:	75 07                	jne    803fc2 <devcons_read+0x5d>
		return 0;
  803fbb:	b8 00 00 00 00       	mov    $0x0,%eax
  803fc0:	eb 10                	jmp    803fd2 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803fc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc5:	89 c2                	mov    %eax,%edx
  803fc7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fcb:	88 10                	mov    %dl,(%rax)
	return 1;
  803fcd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803fd2:	c9                   	leaveq 
  803fd3:	c3                   	retq   

0000000000803fd4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803fd4:	55                   	push   %rbp
  803fd5:	48 89 e5             	mov    %rsp,%rbp
  803fd8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803fdf:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803fe6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803fed:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ff4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ffb:	eb 76                	jmp    804073 <devcons_write+0x9f>
		m = n - tot;
  803ffd:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804004:	89 c2                	mov    %eax,%edx
  804006:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804009:	29 c2                	sub    %eax,%edx
  80400b:	89 d0                	mov    %edx,%eax
  80400d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804010:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804013:	83 f8 7f             	cmp    $0x7f,%eax
  804016:	76 07                	jbe    80401f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804018:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80401f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804022:	48 63 d0             	movslq %eax,%rdx
  804025:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804028:	48 63 c8             	movslq %eax,%rcx
  80402b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804032:	48 01 c1             	add    %rax,%rcx
  804035:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80403c:	48 89 ce             	mov    %rcx,%rsi
  80403f:	48 89 c7             	mov    %rax,%rdi
  804042:	48 b8 0d 16 80 00 00 	movabs $0x80160d,%rax
  804049:	00 00 00 
  80404c:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80404e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804051:	48 63 d0             	movslq %eax,%rdx
  804054:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80405b:	48 89 d6             	mov    %rdx,%rsi
  80405e:	48 89 c7             	mov    %rax,%rdi
  804061:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  804068:	00 00 00 
  80406b:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80406d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804070:	01 45 fc             	add    %eax,-0x4(%rbp)
  804073:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804076:	48 98                	cltq   
  804078:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80407f:	0f 82 78 ff ff ff    	jb     803ffd <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804085:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804088:	c9                   	leaveq 
  804089:	c3                   	retq   

000000000080408a <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80408a:	55                   	push   %rbp
  80408b:	48 89 e5             	mov    %rsp,%rbp
  80408e:	48 83 ec 08          	sub    $0x8,%rsp
  804092:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804096:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80409b:	c9                   	leaveq 
  80409c:	c3                   	retq   

000000000080409d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80409d:	55                   	push   %rbp
  80409e:	48 89 e5             	mov    %rsp,%rbp
  8040a1:	48 83 ec 10          	sub    $0x10,%rsp
  8040a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8040a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8040ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b1:	48 be b0 4c 80 00 00 	movabs $0x804cb0,%rsi
  8040b8:	00 00 00 
  8040bb:	48 89 c7             	mov    %rax,%rdi
  8040be:	48 b8 e9 12 80 00 00 	movabs $0x8012e9,%rax
  8040c5:	00 00 00 
  8040c8:	ff d0                	callq  *%rax
	return 0;
  8040ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040cf:	c9                   	leaveq 
  8040d0:	c3                   	retq   

00000000008040d1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8040d1:	55                   	push   %rbp
  8040d2:	48 89 e5             	mov    %rsp,%rbp
  8040d5:	48 83 ec 20          	sub    $0x20,%rsp
  8040d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8040dd:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8040e4:	00 00 00 
  8040e7:	48 8b 00             	mov    (%rax),%rax
  8040ea:	48 85 c0             	test   %rax,%rax
  8040ed:	75 6f                	jne    80415e <set_pgfault_handler+0x8d>
		// First time through!
		// LAB 4: Your code here.

		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  8040ef:	ba 07 00 00 00       	mov    $0x7,%edx
  8040f4:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8040f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8040fe:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  804105:	00 00 00 
  804108:	ff d0                	callq  *%rax
  80410a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80410d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804111:	79 30                	jns    804143 <set_pgfault_handler+0x72>
            panic("set_pgfault_handler: %d\n", r);
  804113:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804116:	89 c1                	mov    %eax,%ecx
  804118:	48 ba b7 4c 80 00 00 	movabs $0x804cb7,%rdx
  80411f:	00 00 00 
  804122:	be 22 00 00 00       	mov    $0x22,%esi
  804127:	48 bf d0 4c 80 00 00 	movabs $0x804cd0,%rdi
  80412e:	00 00 00 
  804131:	b8 00 00 00 00       	mov    $0x0,%eax
  804136:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  80413d:	00 00 00 
  804140:	41 ff d0             	callq  *%r8
        sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804143:	48 be 71 41 80 00 00 	movabs $0x804171,%rsi
  80414a:	00 00 00 
  80414d:	bf 00 00 00 00       	mov    $0x0,%edi
  804152:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  804159:	00 00 00 
  80415c:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80415e:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804165:	00 00 00 
  804168:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80416c:	48 89 10             	mov    %rdx,(%rax)
}
  80416f:	c9                   	leaveq 
  804170:	c3                   	retq   

0000000000804171 <_pgfault_upcall>:
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF


	movq %rsp, %rdi;	
  804171:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  804174:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80417b:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  80417c:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  804183:	00 
	pushq %rbx;
  804184:	53                   	push   %rbx
	movq %rsp, %rbx;	
  804185:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  804188:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  80418b:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  804192:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  804193:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  804197:	4c 8b 3c 24          	mov    (%rsp),%r15
  80419b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8041a0:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8041a5:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8041aa:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8041af:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8041b4:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8041b9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8041be:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8041c3:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8041c8:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8041cd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8041d2:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8041d7:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8041dc:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8041e1:	48 83 c4 78          	add    $0x78,%rsp
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.


	add $8, %rsp; //Jump rip field  
  8041e5:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8041e9:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  8041ea:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  8041eb:	c3                   	retq   

00000000008041ec <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8041ec:	55                   	push   %rbp
  8041ed:	48 89 e5             	mov    %rsp,%rbp
  8041f0:	48 83 ec 30          	sub    $0x30,%rsp
  8041f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  804200:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804205:	75 08                	jne    80420f <ipc_recv+0x23>
  804207:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  80420e:	ff 
	int res=sys_ipc_recv(pg);
  80420f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804213:	48 89 c7             	mov    %rax,%rdi
  804216:	48 b8 8c 1e 80 00 00 	movabs $0x801e8c,%rax
  80421d:	00 00 00 
  804220:	ff d0                	callq  *%rax
  804222:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  804225:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80422a:	74 26                	je     804252 <ipc_recv+0x66>
  80422c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804230:	75 15                	jne    804247 <ipc_recv+0x5b>
  804232:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804239:	00 00 00 
  80423c:	48 8b 00             	mov    (%rax),%rax
  80423f:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  804245:	eb 05                	jmp    80424c <ipc_recv+0x60>
  804247:	b8 00 00 00 00       	mov    $0x0,%eax
  80424c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804250:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  804252:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804257:	74 26                	je     80427f <ipc_recv+0x93>
  804259:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80425d:	75 15                	jne    804274 <ipc_recv+0x88>
  80425f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804266:	00 00 00 
  804269:	48 8b 00             	mov    (%rax),%rax
  80426c:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  804272:	eb 05                	jmp    804279 <ipc_recv+0x8d>
  804274:	b8 00 00 00 00       	mov    $0x0,%eax
  804279:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80427d:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  80427f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804283:	75 15                	jne    80429a <ipc_recv+0xae>
  804285:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80428c:	00 00 00 
  80428f:	48 8b 00             	mov    (%rax),%rax
  804292:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  804298:	eb 03                	jmp    80429d <ipc_recv+0xb1>
  80429a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  80429d:	c9                   	leaveq 
  80429e:	c3                   	retq   

000000000080429f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80429f:	55                   	push   %rbp
  8042a0:	48 89 e5             	mov    %rsp,%rbp
  8042a3:	48 83 ec 30          	sub    $0x30,%rsp
  8042a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8042aa:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8042ad:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8042b1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  8042b4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8042b9:	75 0a                	jne    8042c5 <ipc_send+0x26>
  8042bb:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8042c2:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8042c3:	eb 3e                	jmp    804303 <ipc_send+0x64>
  8042c5:	eb 3c                	jmp    804303 <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  8042c7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8042cb:	74 2a                	je     8042f7 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  8042cd:	48 ba e0 4c 80 00 00 	movabs $0x804ce0,%rdx
  8042d4:	00 00 00 
  8042d7:	be 39 00 00 00       	mov    $0x39,%esi
  8042dc:	48 bf 0b 4d 80 00 00 	movabs $0x804d0b,%rdi
  8042e3:	00 00 00 
  8042e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8042eb:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  8042f2:	00 00 00 
  8042f5:	ff d1                	callq  *%rcx
		sys_yield();  
  8042f7:	48 b8 da 1b 80 00 00 	movabs $0x801bda,%rax
  8042fe:	00 00 00 
  804301:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  804303:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804306:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804309:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80430d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804310:	89 c7                	mov    %eax,%edi
  804312:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  804319:	00 00 00 
  80431c:	ff d0                	callq  *%rax
  80431e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804321:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804325:	78 a0                	js     8042c7 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  804327:	c9                   	leaveq 
  804328:	c3                   	retq   

0000000000804329 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804329:	55                   	push   %rbp
  80432a:	48 89 e5             	mov    %rsp,%rbp
  80432d:	48 83 ec 10          	sub    $0x10,%rsp
  804331:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  804335:	48 ba 18 4d 80 00 00 	movabs $0x804d18,%rdx
  80433c:	00 00 00 
  80433f:	be 47 00 00 00       	mov    $0x47,%esi
  804344:	48 bf 0b 4d 80 00 00 	movabs $0x804d0b,%rdi
  80434b:	00 00 00 
  80434e:	b8 00 00 00 00       	mov    $0x0,%eax
  804353:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  80435a:	00 00 00 
  80435d:	ff d1                	callq  *%rcx

000000000080435f <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80435f:	55                   	push   %rbp
  804360:	48 89 e5             	mov    %rsp,%rbp
  804363:	48 83 ec 20          	sub    $0x20,%rsp
  804367:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80436a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80436d:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  804371:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  804374:	48 ba 40 4d 80 00 00 	movabs $0x804d40,%rdx
  80437b:	00 00 00 
  80437e:	be 50 00 00 00       	mov    $0x50,%esi
  804383:	48 bf 0b 4d 80 00 00 	movabs $0x804d0b,%rdi
  80438a:	00 00 00 
  80438d:	b8 00 00 00 00       	mov    $0x0,%eax
  804392:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  804399:	00 00 00 
  80439c:	ff d1                	callq  *%rcx

000000000080439e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80439e:	55                   	push   %rbp
  80439f:	48 89 e5             	mov    %rsp,%rbp
  8043a2:	48 83 ec 14          	sub    $0x14,%rsp
  8043a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8043a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8043b0:	eb 4e                	jmp    804400 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8043b2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8043b9:	00 00 00 
  8043bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043bf:	48 98                	cltq   
  8043c1:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8043c8:	48 01 d0             	add    %rdx,%rax
  8043cb:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8043d1:	8b 00                	mov    (%rax),%eax
  8043d3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8043d6:	75 24                	jne    8043fc <ipc_find_env+0x5e>
			return envs[i].env_id;
  8043d8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8043df:	00 00 00 
  8043e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e5:	48 98                	cltq   
  8043e7:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8043ee:	48 01 d0             	add    %rdx,%rax
  8043f1:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8043f7:	8b 40 08             	mov    0x8(%rax),%eax
  8043fa:	eb 12                	jmp    80440e <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8043fc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804400:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804407:	7e a9                	jle    8043b2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  804409:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80440e:	c9                   	leaveq 
  80440f:	c3                   	retq   

0000000000804410 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804410:	55                   	push   %rbp
  804411:	48 89 e5             	mov    %rsp,%rbp
  804414:	48 83 ec 18          	sub    $0x18,%rsp
  804418:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80441c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804420:	48 c1 e8 15          	shr    $0x15,%rax
  804424:	48 89 c2             	mov    %rax,%rdx
  804427:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80442e:	01 00 00 
  804431:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804435:	83 e0 01             	and    $0x1,%eax
  804438:	48 85 c0             	test   %rax,%rax
  80443b:	75 07                	jne    804444 <pageref+0x34>
		return 0;
  80443d:	b8 00 00 00 00       	mov    $0x0,%eax
  804442:	eb 53                	jmp    804497 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804448:	48 c1 e8 0c          	shr    $0xc,%rax
  80444c:	48 89 c2             	mov    %rax,%rdx
  80444f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804456:	01 00 00 
  804459:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80445d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804461:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804465:	83 e0 01             	and    $0x1,%eax
  804468:	48 85 c0             	test   %rax,%rax
  80446b:	75 07                	jne    804474 <pageref+0x64>
		return 0;
  80446d:	b8 00 00 00 00       	mov    $0x0,%eax
  804472:	eb 23                	jmp    804497 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804474:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804478:	48 c1 e8 0c          	shr    $0xc,%rax
  80447c:	48 89 c2             	mov    %rax,%rdx
  80447f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804486:	00 00 00 
  804489:	48 c1 e2 04          	shl    $0x4,%rdx
  80448d:	48 01 d0             	add    %rdx,%rax
  804490:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804494:	0f b7 c0             	movzwl %ax,%eax
}
  804497:	c9                   	leaveq 
  804498:	c3                   	retq   
