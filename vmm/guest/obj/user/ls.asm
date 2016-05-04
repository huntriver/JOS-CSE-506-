
vmm/guest/obj/user/ls:     file format elf64-x86-64


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
  80003c:	e8 da 04 00 00       	callq  80051b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80004e:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  800055:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  80005c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800063:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80006a:	48 89 d6             	mov    %rdx,%rsi
  80006d:	48 89 c7             	mov    %rax,%rdi
  800070:	48 b8 9f 2c 80 00 00 	movabs $0x802c9f,%rax
  800077:	00 00 00 
  80007a:	ff d0                	callq  *%rax
  80007c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800083:	79 3b                	jns    8000c0 <ls+0x7d>
		panic("stat %s: %e", path, r);
  800085:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800088:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80008f:	41 89 d0             	mov    %edx,%r8d
  800092:	48 89 c1             	mov    %rax,%rcx
  800095:	48 ba 40 41 80 00 00 	movabs $0x804140,%rdx
  80009c:	00 00 00 
  80009f:	be 0f 00 00 00       	mov    $0xf,%esi
  8000a4:	48 bf 4c 41 80 00 00 	movabs $0x80414c,%rdi
  8000ab:	00 00 00 
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	49 b9 c1 05 80 00 00 	movabs $0x8005c1,%r9
  8000ba:	00 00 00 
  8000bd:	41 ff d1             	callq  *%r9
	if (st.st_isdir && !flag['d'])
  8000c0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	74 36                	je     8000fd <ls+0xba>
  8000c7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8000ce:	00 00 00 
  8000d1:	8b 80 90 01 00 00    	mov    0x190(%rax),%eax
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	75 22                	jne    8000fd <ls+0xba>
		lsdir(path, prefix);
  8000db:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
  8000e2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8000e9:	48 89 d6             	mov    %rdx,%rsi
  8000ec:	48 89 c7             	mov    %rax,%rdi
  8000ef:	48 b8 27 01 80 00 00 	movabs $0x800127,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
  8000fb:	eb 28                	jmp    800125 <ls+0xe2>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  8000fd:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800100:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800103:	85 c0                	test   %eax,%eax
  800105:	0f 95 c0             	setne  %al
  800108:	0f b6 c0             	movzbl %al,%eax
  80010b:	48 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%rcx
  800112:	89 c6                	mov    %eax,%esi
  800114:	bf 00 00 00 00       	mov    $0x0,%edi
  800119:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
}
  800125:	c9                   	leaveq 
  800126:	c3                   	retq   

0000000000800127 <lsdir>:

void
lsdir(const char *path, const char *prefix)
{
  800127:	55                   	push   %rbp
  800128:	48 89 e5             	mov    %rsp,%rbp
  80012b:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800132:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
  800139:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800140:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800147:	be 00 00 00 00       	mov    $0x0,%esi
  80014c:	48 89 c7             	mov    %rax,%rdi
  80014f:	48 b8 8d 2d 80 00 00 	movabs $0x802d8d,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800162:	79 3b                	jns    80019f <lsdir+0x78>
		panic("open %s: %e", path, fd);
  800164:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800167:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  80016e:	41 89 d0             	mov    %edx,%r8d
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba 56 41 80 00 00 	movabs $0x804156,%rdx
  80017b:	00 00 00 
  80017e:	be 1d 00 00 00       	mov    $0x1d,%esi
  800183:	48 bf 4c 41 80 00 00 	movabs $0x80414c,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 c1 05 80 00 00 	movabs $0x8005c1,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80019f:	eb 3d                	jmp    8001de <lsdir+0xb7>
		if (f.f_name[0])
  8001a1:	0f b6 85 f0 fe ff ff 	movzbl -0x110(%rbp),%eax
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 32                	je     8001de <lsdir+0xb7>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  8001ac:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  8001b2:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8001b8:	83 f8 01             	cmp    $0x1,%eax
  8001bb:	0f 94 c0             	sete   %al
  8001be:	0f b6 f0             	movzbl %al,%esi
  8001c1:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001c8:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001cf:	48 89 c7             	mov    %rax,%rdi
  8001d2:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  8001d9:	00 00 00 
  8001dc:	ff d0                	callq  *%rax
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  8001de:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e8:	ba 00 01 00 00       	mov    $0x100,%edx
  8001ed:	48 89 ce             	mov    %rcx,%rsi
  8001f0:	89 c7                	mov    %eax,%edi
  8001f2:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  8001f9:	00 00 00 
  8001fc:	ff d0                	callq  *%rax
  8001fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800201:	81 7d f8 00 01 00 00 	cmpl   $0x100,-0x8(%rbp)
  800208:	74 97                	je     8001a1 <lsdir+0x7a>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  80020a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80020e:	7e 35                	jle    800245 <lsdir+0x11e>
		panic("short read in directory %s", path);
  800210:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800217:	48 89 c1             	mov    %rax,%rcx
  80021a:	48 ba 62 41 80 00 00 	movabs $0x804162,%rdx
  800221:	00 00 00 
  800224:	be 22 00 00 00       	mov    $0x22,%esi
  800229:	48 bf 4c 41 80 00 00 	movabs $0x80414c,%rdi
  800230:	00 00 00 
  800233:	b8 00 00 00 00       	mov    $0x0,%eax
  800238:	49 b8 c1 05 80 00 00 	movabs $0x8005c1,%r8
  80023f:	00 00 00 
  800242:	41 ff d0             	callq  *%r8
	if (n < 0)
  800245:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800249:	79 3b                	jns    800286 <lsdir+0x15f>
		panic("error reading directory %s: %e", path, n);
  80024b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80024e:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800255:	41 89 d0             	mov    %edx,%r8d
  800258:	48 89 c1             	mov    %rax,%rcx
  80025b:	48 ba 80 41 80 00 00 	movabs $0x804180,%rdx
  800262:	00 00 00 
  800265:	be 24 00 00 00       	mov    $0x24,%esi
  80026a:	48 bf 4c 41 80 00 00 	movabs $0x80414c,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b9 c1 05 80 00 00 	movabs $0x8005c1,%r9
  800280:	00 00 00 
  800283:	41 ff d1             	callq  *%r9
}
  800286:	c9                   	leaveq 
  800287:	c3                   	retq   

0000000000800288 <ls1>:

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800288:	55                   	push   %rbp
  800289:	48 89 e5             	mov    %rsp,%rbp
  80028c:	48 83 ec 30          	sub    $0x30,%rsp
  800290:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800294:	89 f0                	mov    %esi,%eax
  800296:	89 55 e0             	mov    %edx,-0x20(%rbp)
  800299:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  80029d:	88 45 e4             	mov    %al,-0x1c(%rbp)
	const char *sep;

	if(flag['l'])
  8002a0:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8002a7:	00 00 00 
  8002aa:	8b 80 b0 01 00 00    	mov    0x1b0(%rax),%eax
  8002b0:	85 c0                	test   %eax,%eax
  8002b2:	74 34                	je     8002e8 <ls1+0x60>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  8002b4:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  8002b8:	74 07                	je     8002c1 <ls1+0x39>
  8002ba:	b8 64 00 00 00       	mov    $0x64,%eax
  8002bf:	eb 05                	jmp    8002c6 <ls1+0x3e>
  8002c1:	b8 2d 00 00 00       	mov    $0x2d,%eax
  8002c6:	8b 4d e0             	mov    -0x20(%rbp),%ecx
  8002c9:	89 c2                	mov    %eax,%edx
  8002cb:	89 ce                	mov    %ecx,%esi
  8002cd:	48 bf 9f 41 80 00 00 	movabs $0x80419f,%rdi
  8002d4:	00 00 00 
  8002d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dc:	48 b9 51 35 80 00 00 	movabs $0x803551,%rcx
  8002e3:	00 00 00 
  8002e6:	ff d1                	callq  *%rcx
	if(prefix) {
  8002e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8002ed:	74 76                	je     800365 <ls1+0xdd>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8002ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002f3:	0f b6 00             	movzbl (%rax),%eax
  8002f6:	84 c0                	test   %al,%al
  8002f8:	74 37                	je     800331 <ls1+0xa9>
  8002fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002fe:	48 89 c7             	mov    %rax,%rdi
  800301:	48 b8 84 13 80 00 00 	movabs $0x801384,%rax
  800308:	00 00 00 
  80030b:	ff d0                	callq  *%rax
  80030d:	48 98                	cltq   
  80030f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800313:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800317:	48 01 d0             	add    %rdx,%rax
  80031a:	0f b6 00             	movzbl (%rax),%eax
  80031d:	3c 2f                	cmp    $0x2f,%al
  80031f:	74 10                	je     800331 <ls1+0xa9>
			sep = "/";
  800321:	48 b8 a8 41 80 00 00 	movabs $0x8041a8,%rax
  800328:	00 00 00 
  80032b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80032f:	eb 0e                	jmp    80033f <ls1+0xb7>
		else
			sep = "";
  800331:	48 b8 aa 41 80 00 00 	movabs $0x8041aa,%rax
  800338:	00 00 00 
  80033b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		printf("%s%s", prefix, sep);
  80033f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800347:	48 89 c6             	mov    %rax,%rsi
  80034a:	48 bf ab 41 80 00 00 	movabs $0x8041ab,%rdi
  800351:	00 00 00 
  800354:	b8 00 00 00 00       	mov    $0x0,%eax
  800359:	48 b9 51 35 80 00 00 	movabs $0x803551,%rcx
  800360:	00 00 00 
  800363:	ff d1                	callq  *%rcx
	}
	printf("%s", name);
  800365:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800369:	48 89 c6             	mov    %rax,%rsi
  80036c:	48 bf b0 41 80 00 00 	movabs $0x8041b0,%rdi
  800373:	00 00 00 
  800376:	b8 00 00 00 00       	mov    $0x0,%eax
  80037b:	48 ba 51 35 80 00 00 	movabs $0x803551,%rdx
  800382:	00 00 00 
  800385:	ff d2                	callq  *%rdx
	if(flag['F'] && isdir)
  800387:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80038e:	00 00 00 
  800391:	8b 80 18 01 00 00    	mov    0x118(%rax),%eax
  800397:	85 c0                	test   %eax,%eax
  800399:	74 21                	je     8003bc <ls1+0x134>
  80039b:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  80039f:	74 1b                	je     8003bc <ls1+0x134>
		printf("/");
  8003a1:	48 bf a8 41 80 00 00 	movabs $0x8041a8,%rdi
  8003a8:	00 00 00 
  8003ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b0:	48 ba 51 35 80 00 00 	movabs $0x803551,%rdx
  8003b7:	00 00 00 
  8003ba:	ff d2                	callq  *%rdx
	printf("\n");
  8003bc:	48 bf b3 41 80 00 00 	movabs $0x8041b3,%rdi
  8003c3:	00 00 00 
  8003c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cb:	48 ba 51 35 80 00 00 	movabs $0x803551,%rdx
  8003d2:	00 00 00 
  8003d5:	ff d2                	callq  *%rdx
}
  8003d7:	c9                   	leaveq 
  8003d8:	c3                   	retq   

00000000008003d9 <usage>:

void
usage(void)
{
  8003d9:	55                   	push   %rbp
  8003da:	48 89 e5             	mov    %rsp,%rbp
	printf("usage: ls [-dFl] [file...]\n");
  8003dd:	48 bf b5 41 80 00 00 	movabs $0x8041b5,%rdi
  8003e4:	00 00 00 
  8003e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ec:	48 ba 51 35 80 00 00 	movabs $0x803551,%rdx
  8003f3:	00 00 00 
  8003f6:	ff d2                	callq  *%rdx
	exit();
  8003f8:	48 b8 9e 05 80 00 00 	movabs $0x80059e,%rax
  8003ff:	00 00 00 
  800402:	ff d0                	callq  *%rax
}
  800404:	5d                   	pop    %rbp
  800405:	c3                   	retq   

0000000000800406 <umain>:

void
umain(int argc, char **argv)
{
  800406:	55                   	push   %rbp
  800407:	48 89 e5             	mov    %rsp,%rbp
  80040a:	48 83 ec 40          	sub    $0x40,%rsp
  80040e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800411:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800415:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  800419:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80041d:	48 8d 45 cc          	lea    -0x34(%rbp),%rax
  800421:	48 89 ce             	mov    %rcx,%rsi
  800424:	48 89 c7             	mov    %rax,%rdi
  800427:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  80042e:	00 00 00 
  800431:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  800433:	eb 49                	jmp    80047e <umain+0x78>
		switch (i) {
  800435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800438:	83 f8 64             	cmp    $0x64,%eax
  80043b:	74 0a                	je     800447 <umain+0x41>
  80043d:	83 f8 6c             	cmp    $0x6c,%eax
  800440:	74 05                	je     800447 <umain+0x41>
  800442:	83 f8 46             	cmp    $0x46,%eax
  800445:	75 2b                	jne    800472 <umain+0x6c>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800447:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80044e:	00 00 00 
  800451:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800454:	48 63 d2             	movslq %edx,%rdx
  800457:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  80045a:	8d 48 01             	lea    0x1(%rax),%ecx
  80045d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  800464:	00 00 00 
  800467:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80046a:	48 63 d2             	movslq %edx,%rdx
  80046d:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)
			break;
  800470:	eb 0c                	jmp    80047e <umain+0x78>
		default:
			usage();
  800472:	48 b8 d9 03 80 00 00 	movabs $0x8003d9,%rax
  800479:	00 00 00 
  80047c:	ff d0                	callq  *%rax
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  80047e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800482:	48 89 c7             	mov    %rax,%rdi
  800485:	48 b8 1e 21 80 00 00 	movabs $0x80211e,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
  800491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800498:	79 9b                	jns    800435 <umain+0x2f>
			break;
		default:
			usage();
		}

	if (argc == 1)
  80049a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80049d:	83 f8 01             	cmp    $0x1,%eax
  8004a0:	75 22                	jne    8004c4 <umain+0xbe>
		ls("/", "");
  8004a2:	48 be aa 41 80 00 00 	movabs $0x8041aa,%rsi
  8004a9:	00 00 00 
  8004ac:	48 bf a8 41 80 00 00 	movabs $0x8041a8,%rdi
  8004b3:	00 00 00 
  8004b6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004bd:	00 00 00 
  8004c0:	ff d0                	callq  *%rax
  8004c2:	eb 55                	jmp    800519 <umain+0x113>
	else {
		for (i = 1; i < argc; i++)
  8004c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8004cb:	eb 44                	jmp    800511 <umain+0x10b>
			ls(argv[i], argv[i]);
  8004cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d0:	48 98                	cltq   
  8004d2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004d9:	00 
  8004da:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004de:	48 01 d0             	add    %rdx,%rax
  8004e1:	48 8b 10             	mov    (%rax),%rdx
  8004e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e7:	48 98                	cltq   
  8004e9:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8004f0:	00 
  8004f1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004f5:	48 01 c8             	add    %rcx,%rax
  8004f8:	48 8b 00             	mov    (%rax),%rax
  8004fb:	48 89 d6             	mov    %rdx,%rsi
  8004fe:	48 89 c7             	mov    %rax,%rdi
  800501:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800508:	00 00 00 
  80050b:	ff d0                	callq  *%rax
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  80050d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800511:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800514:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  800517:	7c b4                	jl     8004cd <umain+0xc7>
			ls(argv[i], argv[i]);
	}
}
  800519:	c9                   	leaveq 
  80051a:	c3                   	retq   

000000000080051b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	48 83 ec 10          	sub    $0x10,%rsp
  800523:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800526:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  80052a:	48 b8 a3 1c 80 00 00 	movabs $0x801ca3,%rax
  800531:	00 00 00 
  800534:	ff d0                	callq  *%rax
  800536:	48 98                	cltq   
  800538:	25 ff 03 00 00       	and    $0x3ff,%eax
  80053d:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  800544:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80054b:	00 00 00 
  80054e:	48 01 c2             	add    %rax,%rdx
  800551:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  800558:	00 00 00 
  80055b:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80055e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800562:	7e 14                	jle    800578 <libmain+0x5d>
		binaryname = argv[0];
  800564:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800568:	48 8b 10             	mov    (%rax),%rdx
  80056b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800572:	00 00 00 
  800575:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800578:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80057c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80057f:	48 89 d6             	mov    %rdx,%rsi
  800582:	89 c7                	mov    %eax,%edi
  800584:	48 b8 06 04 80 00 00 	movabs $0x800406,%rax
  80058b:	00 00 00 
  80058e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800590:	48 b8 9e 05 80 00 00 	movabs $0x80059e,%rax
  800597:	00 00 00 
  80059a:	ff d0                	callq  *%rax
}
  80059c:	c9                   	leaveq 
  80059d:	c3                   	retq   

000000000080059e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80059e:	55                   	push   %rbp
  80059f:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8005a2:	48 b8 e0 26 80 00 00 	movabs $0x8026e0,%rax
  8005a9:	00 00 00 
  8005ac:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8005ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8005b3:	48 b8 5f 1c 80 00 00 	movabs $0x801c5f,%rax
  8005ba:	00 00 00 
  8005bd:	ff d0                	callq  *%rax
}
  8005bf:	5d                   	pop    %rbp
  8005c0:	c3                   	retq   

00000000008005c1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005c1:	55                   	push   %rbp
  8005c2:	48 89 e5             	mov    %rsp,%rbp
  8005c5:	53                   	push   %rbx
  8005c6:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005cd:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005d4:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005da:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005e1:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005e8:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005ef:	84 c0                	test   %al,%al
  8005f1:	74 23                	je     800616 <_panic+0x55>
  8005f3:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8005fa:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8005fe:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800602:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800606:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80060a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80060e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800612:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800616:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80061d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800624:	00 00 00 
  800627:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80062e:	00 00 00 
  800631:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800635:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80063c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800643:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80064a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800651:	00 00 00 
  800654:	48 8b 18             	mov    (%rax),%rbx
  800657:	48 b8 a3 1c 80 00 00 	movabs $0x801ca3,%rax
  80065e:	00 00 00 
  800661:	ff d0                	callq  *%rax
  800663:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800669:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800670:	41 89 c8             	mov    %ecx,%r8d
  800673:	48 89 d1             	mov    %rdx,%rcx
  800676:	48 89 da             	mov    %rbx,%rdx
  800679:	89 c6                	mov    %eax,%esi
  80067b:	48 bf e0 41 80 00 00 	movabs $0x8041e0,%rdi
  800682:	00 00 00 
  800685:	b8 00 00 00 00       	mov    $0x0,%eax
  80068a:	49 b9 fa 07 80 00 00 	movabs $0x8007fa,%r9
  800691:	00 00 00 
  800694:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800697:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80069e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006a5:	48 89 d6             	mov    %rdx,%rsi
  8006a8:	48 89 c7             	mov    %rax,%rdi
  8006ab:	48 b8 4e 07 80 00 00 	movabs $0x80074e,%rax
  8006b2:	00 00 00 
  8006b5:	ff d0                	callq  *%rax
	cprintf("\n");
  8006b7:	48 bf 03 42 80 00 00 	movabs $0x804203,%rdi
  8006be:	00 00 00 
  8006c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c6:	48 ba fa 07 80 00 00 	movabs $0x8007fa,%rdx
  8006cd:	00 00 00 
  8006d0:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006d2:	cc                   	int3   
  8006d3:	eb fd                	jmp    8006d2 <_panic+0x111>

00000000008006d5 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006d5:	55                   	push   %rbp
  8006d6:	48 89 e5             	mov    %rsp,%rbp
  8006d9:	48 83 ec 10          	sub    $0x10,%rsp
  8006dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8006e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006e8:	8b 00                	mov    (%rax),%eax
  8006ea:	8d 48 01             	lea    0x1(%rax),%ecx
  8006ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006f1:	89 0a                	mov    %ecx,(%rdx)
  8006f3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8006f6:	89 d1                	mov    %edx,%ecx
  8006f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006fc:	48 98                	cltq   
  8006fe:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800702:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800706:	8b 00                	mov    (%rax),%eax
  800708:	3d ff 00 00 00       	cmp    $0xff,%eax
  80070d:	75 2c                	jne    80073b <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80070f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800713:	8b 00                	mov    (%rax),%eax
  800715:	48 98                	cltq   
  800717:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80071b:	48 83 c2 08          	add    $0x8,%rdx
  80071f:	48 89 c6             	mov    %rax,%rsi
  800722:	48 89 d7             	mov    %rdx,%rdi
  800725:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  80072c:	00 00 00 
  80072f:	ff d0                	callq  *%rax
        b->idx = 0;
  800731:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800735:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80073b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80073f:	8b 40 04             	mov    0x4(%rax),%eax
  800742:	8d 50 01             	lea    0x1(%rax),%edx
  800745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800749:	89 50 04             	mov    %edx,0x4(%rax)
}
  80074c:	c9                   	leaveq 
  80074d:	c3                   	retq   

000000000080074e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80074e:	55                   	push   %rbp
  80074f:	48 89 e5             	mov    %rsp,%rbp
  800752:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800759:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800760:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800767:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80076e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800775:	48 8b 0a             	mov    (%rdx),%rcx
  800778:	48 89 08             	mov    %rcx,(%rax)
  80077b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80077f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800783:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800787:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80078b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800792:	00 00 00 
    b.cnt = 0;
  800795:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80079c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80079f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007a6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007ad:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007b4:	48 89 c6             	mov    %rax,%rsi
  8007b7:	48 bf d5 06 80 00 00 	movabs $0x8006d5,%rdi
  8007be:	00 00 00 
  8007c1:	48 b8 ad 0b 80 00 00 	movabs $0x800bad,%rax
  8007c8:	00 00 00 
  8007cb:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007cd:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007d3:	48 98                	cltq   
  8007d5:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007dc:	48 83 c2 08          	add    $0x8,%rdx
  8007e0:	48 89 c6             	mov    %rax,%rsi
  8007e3:	48 89 d7             	mov    %rdx,%rdi
  8007e6:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  8007ed:	00 00 00 
  8007f0:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8007f2:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8007f8:	c9                   	leaveq 
  8007f9:	c3                   	retq   

00000000008007fa <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8007fa:	55                   	push   %rbp
  8007fb:	48 89 e5             	mov    %rsp,%rbp
  8007fe:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800805:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80080c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800813:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80081a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800821:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800828:	84 c0                	test   %al,%al
  80082a:	74 20                	je     80084c <cprintf+0x52>
  80082c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800830:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800834:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800838:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80083c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800840:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800844:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800848:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80084c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800853:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80085a:	00 00 00 
  80085d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800864:	00 00 00 
  800867:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80086b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800872:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800879:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800880:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800887:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80088e:	48 8b 0a             	mov    (%rdx),%rcx
  800891:	48 89 08             	mov    %rcx,(%rax)
  800894:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800898:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80089c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008a0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8008a4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008ab:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008b2:	48 89 d6             	mov    %rdx,%rsi
  8008b5:	48 89 c7             	mov    %rax,%rdi
  8008b8:	48 b8 4e 07 80 00 00 	movabs $0x80074e,%rax
  8008bf:	00 00 00 
  8008c2:	ff d0                	callq  *%rax
  8008c4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008ca:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008d0:	c9                   	leaveq 
  8008d1:	c3                   	retq   

00000000008008d2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008d2:	55                   	push   %rbp
  8008d3:	48 89 e5             	mov    %rsp,%rbp
  8008d6:	53                   	push   %rbx
  8008d7:	48 83 ec 38          	sub    $0x38,%rsp
  8008db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8008e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8008e7:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8008ea:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8008ee:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008f2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8008f5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8008f9:	77 3b                	ja     800936 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008fb:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8008fe:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800902:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800909:	ba 00 00 00 00       	mov    $0x0,%edx
  80090e:	48 f7 f3             	div    %rbx
  800911:	48 89 c2             	mov    %rax,%rdx
  800914:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800917:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80091a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80091e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800922:	41 89 f9             	mov    %edi,%r9d
  800925:	48 89 c7             	mov    %rax,%rdi
  800928:	48 b8 d2 08 80 00 00 	movabs $0x8008d2,%rax
  80092f:	00 00 00 
  800932:	ff d0                	callq  *%rax
  800934:	eb 1e                	jmp    800954 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800936:	eb 12                	jmp    80094a <printnum+0x78>
			putch(padc, putdat);
  800938:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80093c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80093f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800943:	48 89 ce             	mov    %rcx,%rsi
  800946:	89 d7                	mov    %edx,%edi
  800948:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80094a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80094e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800952:	7f e4                	jg     800938 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800954:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800957:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80095b:	ba 00 00 00 00       	mov    $0x0,%edx
  800960:	48 f7 f1             	div    %rcx
  800963:	48 89 d0             	mov    %rdx,%rax
  800966:	48 ba 10 44 80 00 00 	movabs $0x804410,%rdx
  80096d:	00 00 00 
  800970:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800974:	0f be d0             	movsbl %al,%edx
  800977:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80097b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097f:	48 89 ce             	mov    %rcx,%rsi
  800982:	89 d7                	mov    %edx,%edi
  800984:	ff d0                	callq  *%rax
}
  800986:	48 83 c4 38          	add    $0x38,%rsp
  80098a:	5b                   	pop    %rbx
  80098b:	5d                   	pop    %rbp
  80098c:	c3                   	retq   

000000000080098d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80098d:	55                   	push   %rbp
  80098e:	48 89 e5             	mov    %rsp,%rbp
  800991:	48 83 ec 1c          	sub    $0x1c,%rsp
  800995:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800999:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80099c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009a0:	7e 52                	jle    8009f4 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a6:	8b 00                	mov    (%rax),%eax
  8009a8:	83 f8 30             	cmp    $0x30,%eax
  8009ab:	73 24                	jae    8009d1 <getuint+0x44>
  8009ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b9:	8b 00                	mov    (%rax),%eax
  8009bb:	89 c0                	mov    %eax,%eax
  8009bd:	48 01 d0             	add    %rdx,%rax
  8009c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c4:	8b 12                	mov    (%rdx),%edx
  8009c6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cd:	89 0a                	mov    %ecx,(%rdx)
  8009cf:	eb 17                	jmp    8009e8 <getuint+0x5b>
  8009d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009d9:	48 89 d0             	mov    %rdx,%rax
  8009dc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e8:	48 8b 00             	mov    (%rax),%rax
  8009eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009ef:	e9 a3 00 00 00       	jmpq   800a97 <getuint+0x10a>
	else if (lflag)
  8009f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009f8:	74 4f                	je     800a49 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8009fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fe:	8b 00                	mov    (%rax),%eax
  800a00:	83 f8 30             	cmp    $0x30,%eax
  800a03:	73 24                	jae    800a29 <getuint+0x9c>
  800a05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a09:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a11:	8b 00                	mov    (%rax),%eax
  800a13:	89 c0                	mov    %eax,%eax
  800a15:	48 01 d0             	add    %rdx,%rax
  800a18:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1c:	8b 12                	mov    (%rdx),%edx
  800a1e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a21:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a25:	89 0a                	mov    %ecx,(%rdx)
  800a27:	eb 17                	jmp    800a40 <getuint+0xb3>
  800a29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a31:	48 89 d0             	mov    %rdx,%rax
  800a34:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a38:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a40:	48 8b 00             	mov    (%rax),%rax
  800a43:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a47:	eb 4e                	jmp    800a97 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4d:	8b 00                	mov    (%rax),%eax
  800a4f:	83 f8 30             	cmp    $0x30,%eax
  800a52:	73 24                	jae    800a78 <getuint+0xeb>
  800a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a58:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a60:	8b 00                	mov    (%rax),%eax
  800a62:	89 c0                	mov    %eax,%eax
  800a64:	48 01 d0             	add    %rdx,%rax
  800a67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6b:	8b 12                	mov    (%rdx),%edx
  800a6d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a74:	89 0a                	mov    %ecx,(%rdx)
  800a76:	eb 17                	jmp    800a8f <getuint+0x102>
  800a78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a80:	48 89 d0             	mov    %rdx,%rax
  800a83:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a87:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a8f:	8b 00                	mov    (%rax),%eax
  800a91:	89 c0                	mov    %eax,%eax
  800a93:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a9b:	c9                   	leaveq 
  800a9c:	c3                   	retq   

0000000000800a9d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a9d:	55                   	push   %rbp
  800a9e:	48 89 e5             	mov    %rsp,%rbp
  800aa1:	48 83 ec 1c          	sub    $0x1c,%rsp
  800aa5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800aa9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800aac:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ab0:	7e 52                	jle    800b04 <getint+0x67>
		x=va_arg(*ap, long long);
  800ab2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab6:	8b 00                	mov    (%rax),%eax
  800ab8:	83 f8 30             	cmp    $0x30,%eax
  800abb:	73 24                	jae    800ae1 <getint+0x44>
  800abd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ac5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac9:	8b 00                	mov    (%rax),%eax
  800acb:	89 c0                	mov    %eax,%eax
  800acd:	48 01 d0             	add    %rdx,%rax
  800ad0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad4:	8b 12                	mov    (%rdx),%edx
  800ad6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ad9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800add:	89 0a                	mov    %ecx,(%rdx)
  800adf:	eb 17                	jmp    800af8 <getint+0x5b>
  800ae1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ae9:	48 89 d0             	mov    %rdx,%rax
  800aec:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800af0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800af8:	48 8b 00             	mov    (%rax),%rax
  800afb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aff:	e9 a3 00 00 00       	jmpq   800ba7 <getint+0x10a>
	else if (lflag)
  800b04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b08:	74 4f                	je     800b59 <getint+0xbc>
		x=va_arg(*ap, long);
  800b0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b0e:	8b 00                	mov    (%rax),%eax
  800b10:	83 f8 30             	cmp    $0x30,%eax
  800b13:	73 24                	jae    800b39 <getint+0x9c>
  800b15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b19:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b21:	8b 00                	mov    (%rax),%eax
  800b23:	89 c0                	mov    %eax,%eax
  800b25:	48 01 d0             	add    %rdx,%rax
  800b28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b2c:	8b 12                	mov    (%rdx),%edx
  800b2e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b35:	89 0a                	mov    %ecx,(%rdx)
  800b37:	eb 17                	jmp    800b50 <getint+0xb3>
  800b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b41:	48 89 d0             	mov    %rdx,%rax
  800b44:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b4c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b50:	48 8b 00             	mov    (%rax),%rax
  800b53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b57:	eb 4e                	jmp    800ba7 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5d:	8b 00                	mov    (%rax),%eax
  800b5f:	83 f8 30             	cmp    $0x30,%eax
  800b62:	73 24                	jae    800b88 <getint+0xeb>
  800b64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b68:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b70:	8b 00                	mov    (%rax),%eax
  800b72:	89 c0                	mov    %eax,%eax
  800b74:	48 01 d0             	add    %rdx,%rax
  800b77:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b7b:	8b 12                	mov    (%rdx),%edx
  800b7d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b84:	89 0a                	mov    %ecx,(%rdx)
  800b86:	eb 17                	jmp    800b9f <getint+0x102>
  800b88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b90:	48 89 d0             	mov    %rdx,%rax
  800b93:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b9b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b9f:	8b 00                	mov    (%rax),%eax
  800ba1:	48 98                	cltq   
  800ba3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ba7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bab:	c9                   	leaveq 
  800bac:	c3                   	retq   

0000000000800bad <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bad:	55                   	push   %rbp
  800bae:	48 89 e5             	mov    %rsp,%rbp
  800bb1:	41 54                	push   %r12
  800bb3:	53                   	push   %rbx
  800bb4:	48 83 ec 60          	sub    $0x60,%rsp
  800bb8:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800bbc:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bc0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bc4:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bc8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bcc:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bd0:	48 8b 0a             	mov    (%rdx),%rcx
  800bd3:	48 89 08             	mov    %rcx,(%rax)
  800bd6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bda:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bde:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800be2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be6:	eb 28                	jmp    800c10 <vprintfmt+0x63>
			if (ch == '\0'){
  800be8:	85 db                	test   %ebx,%ebx
  800bea:	75 15                	jne    800c01 <vprintfmt+0x54>
				current_color=WHITE;
  800bec:	48 b8 28 74 80 00 00 	movabs $0x807428,%rax
  800bf3:	00 00 00 
  800bf6:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800bfc:	e9 fc 04 00 00       	jmpq   8010fd <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  800c01:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c09:	48 89 d6             	mov    %rdx,%rsi
  800c0c:	89 df                	mov    %ebx,%edi
  800c0e:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c10:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c14:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c18:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c1c:	0f b6 00             	movzbl (%rax),%eax
  800c1f:	0f b6 d8             	movzbl %al,%ebx
  800c22:	83 fb 25             	cmp    $0x25,%ebx
  800c25:	75 c1                	jne    800be8 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c27:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c2b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c32:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c39:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c40:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c47:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c4b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c4f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c53:	0f b6 00             	movzbl (%rax),%eax
  800c56:	0f b6 d8             	movzbl %al,%ebx
  800c59:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c5c:	83 f8 55             	cmp    $0x55,%eax
  800c5f:	0f 87 64 04 00 00    	ja     8010c9 <vprintfmt+0x51c>
  800c65:	89 c0                	mov    %eax,%eax
  800c67:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c6e:	00 
  800c6f:	48 b8 38 44 80 00 00 	movabs $0x804438,%rax
  800c76:	00 00 00 
  800c79:	48 01 d0             	add    %rdx,%rax
  800c7c:	48 8b 00             	mov    (%rax),%rax
  800c7f:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c81:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c85:	eb c0                	jmp    800c47 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c87:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c8b:	eb ba                	jmp    800c47 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c8d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c94:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c97:	89 d0                	mov    %edx,%eax
  800c99:	c1 e0 02             	shl    $0x2,%eax
  800c9c:	01 d0                	add    %edx,%eax
  800c9e:	01 c0                	add    %eax,%eax
  800ca0:	01 d8                	add    %ebx,%eax
  800ca2:	83 e8 30             	sub    $0x30,%eax
  800ca5:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ca8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cac:	0f b6 00             	movzbl (%rax),%eax
  800caf:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cb2:	83 fb 2f             	cmp    $0x2f,%ebx
  800cb5:	7e 0c                	jle    800cc3 <vprintfmt+0x116>
  800cb7:	83 fb 39             	cmp    $0x39,%ebx
  800cba:	7f 07                	jg     800cc3 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cbc:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cc1:	eb d1                	jmp    800c94 <vprintfmt+0xe7>
			goto process_precision;
  800cc3:	eb 58                	jmp    800d1d <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800cc5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc8:	83 f8 30             	cmp    $0x30,%eax
  800ccb:	73 17                	jae    800ce4 <vprintfmt+0x137>
  800ccd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cd1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd4:	89 c0                	mov    %eax,%eax
  800cd6:	48 01 d0             	add    %rdx,%rax
  800cd9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cdc:	83 c2 08             	add    $0x8,%edx
  800cdf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ce2:	eb 0f                	jmp    800cf3 <vprintfmt+0x146>
  800ce4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce8:	48 89 d0             	mov    %rdx,%rax
  800ceb:	48 83 c2 08          	add    $0x8,%rdx
  800cef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cf3:	8b 00                	mov    (%rax),%eax
  800cf5:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cf8:	eb 23                	jmp    800d1d <vprintfmt+0x170>

		case '.':
			if (width < 0)
  800cfa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cfe:	79 0c                	jns    800d0c <vprintfmt+0x15f>
				width = 0;
  800d00:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d07:	e9 3b ff ff ff       	jmpq   800c47 <vprintfmt+0x9a>
  800d0c:	e9 36 ff ff ff       	jmpq   800c47 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  800d11:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d18:	e9 2a ff ff ff       	jmpq   800c47 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  800d1d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d21:	79 12                	jns    800d35 <vprintfmt+0x188>
				width = precision, precision = -1;
  800d23:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d26:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d29:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d30:	e9 12 ff ff ff       	jmpq   800c47 <vprintfmt+0x9a>
  800d35:	e9 0d ff ff ff       	jmpq   800c47 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d3a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d3e:	e9 04 ff ff ff       	jmpq   800c47 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d46:	83 f8 30             	cmp    $0x30,%eax
  800d49:	73 17                	jae    800d62 <vprintfmt+0x1b5>
  800d4b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d4f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d52:	89 c0                	mov    %eax,%eax
  800d54:	48 01 d0             	add    %rdx,%rax
  800d57:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d5a:	83 c2 08             	add    $0x8,%edx
  800d5d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d60:	eb 0f                	jmp    800d71 <vprintfmt+0x1c4>
  800d62:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d66:	48 89 d0             	mov    %rdx,%rax
  800d69:	48 83 c2 08          	add    $0x8,%rdx
  800d6d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d71:	8b 10                	mov    (%rax),%edx
  800d73:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7b:	48 89 ce             	mov    %rcx,%rsi
  800d7e:	89 d7                	mov    %edx,%edi
  800d80:	ff d0                	callq  *%rax
			break;
  800d82:	e9 70 03 00 00       	jmpq   8010f7 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8a:	83 f8 30             	cmp    $0x30,%eax
  800d8d:	73 17                	jae    800da6 <vprintfmt+0x1f9>
  800d8f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d96:	89 c0                	mov    %eax,%eax
  800d98:	48 01 d0             	add    %rdx,%rax
  800d9b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d9e:	83 c2 08             	add    $0x8,%edx
  800da1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800da4:	eb 0f                	jmp    800db5 <vprintfmt+0x208>
  800da6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800daa:	48 89 d0             	mov    %rdx,%rax
  800dad:	48 83 c2 08          	add    $0x8,%rdx
  800db1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800db5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800db7:	85 db                	test   %ebx,%ebx
  800db9:	79 02                	jns    800dbd <vprintfmt+0x210>
				err = -err;
  800dbb:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800dbd:	83 fb 15             	cmp    $0x15,%ebx
  800dc0:	7f 16                	jg     800dd8 <vprintfmt+0x22b>
  800dc2:	48 b8 60 43 80 00 00 	movabs $0x804360,%rax
  800dc9:	00 00 00 
  800dcc:	48 63 d3             	movslq %ebx,%rdx
  800dcf:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800dd3:	4d 85 e4             	test   %r12,%r12
  800dd6:	75 2e                	jne    800e06 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  800dd8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ddc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de0:	89 d9                	mov    %ebx,%ecx
  800de2:	48 ba 21 44 80 00 00 	movabs $0x804421,%rdx
  800de9:	00 00 00 
  800dec:	48 89 c7             	mov    %rax,%rdi
  800def:	b8 00 00 00 00       	mov    $0x0,%eax
  800df4:	49 b8 06 11 80 00 00 	movabs $0x801106,%r8
  800dfb:	00 00 00 
  800dfe:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e01:	e9 f1 02 00 00       	jmpq   8010f7 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e06:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0e:	4c 89 e1             	mov    %r12,%rcx
  800e11:	48 ba 2a 44 80 00 00 	movabs $0x80442a,%rdx
  800e18:	00 00 00 
  800e1b:	48 89 c7             	mov    %rax,%rdi
  800e1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e23:	49 b8 06 11 80 00 00 	movabs $0x801106,%r8
  800e2a:	00 00 00 
  800e2d:	41 ff d0             	callq  *%r8
			break;
  800e30:	e9 c2 02 00 00       	jmpq   8010f7 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e38:	83 f8 30             	cmp    $0x30,%eax
  800e3b:	73 17                	jae    800e54 <vprintfmt+0x2a7>
  800e3d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e44:	89 c0                	mov    %eax,%eax
  800e46:	48 01 d0             	add    %rdx,%rax
  800e49:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e4c:	83 c2 08             	add    $0x8,%edx
  800e4f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e52:	eb 0f                	jmp    800e63 <vprintfmt+0x2b6>
  800e54:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e58:	48 89 d0             	mov    %rdx,%rax
  800e5b:	48 83 c2 08          	add    $0x8,%rdx
  800e5f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e63:	4c 8b 20             	mov    (%rax),%r12
  800e66:	4d 85 e4             	test   %r12,%r12
  800e69:	75 0a                	jne    800e75 <vprintfmt+0x2c8>
				p = "(null)";
  800e6b:	49 bc 2d 44 80 00 00 	movabs $0x80442d,%r12
  800e72:	00 00 00 
			if (width > 0 && padc != '-')
  800e75:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e79:	7e 3f                	jle    800eba <vprintfmt+0x30d>
  800e7b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e7f:	74 39                	je     800eba <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e81:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e84:	48 98                	cltq   
  800e86:	48 89 c6             	mov    %rax,%rsi
  800e89:	4c 89 e7             	mov    %r12,%rdi
  800e8c:	48 b8 b2 13 80 00 00 	movabs $0x8013b2,%rax
  800e93:	00 00 00 
  800e96:	ff d0                	callq  *%rax
  800e98:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e9b:	eb 17                	jmp    800eb4 <vprintfmt+0x307>
					putch(padc, putdat);
  800e9d:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ea1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ea5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea9:	48 89 ce             	mov    %rcx,%rsi
  800eac:	89 d7                	mov    %edx,%edi
  800eae:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eb0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eb4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eb8:	7f e3                	jg     800e9d <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eba:	eb 37                	jmp    800ef3 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  800ebc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ec0:	74 1e                	je     800ee0 <vprintfmt+0x333>
  800ec2:	83 fb 1f             	cmp    $0x1f,%ebx
  800ec5:	7e 05                	jle    800ecc <vprintfmt+0x31f>
  800ec7:	83 fb 7e             	cmp    $0x7e,%ebx
  800eca:	7e 14                	jle    800ee0 <vprintfmt+0x333>
					putch('?', putdat);
  800ecc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed4:	48 89 d6             	mov    %rdx,%rsi
  800ed7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800edc:	ff d0                	callq  *%rax
  800ede:	eb 0f                	jmp    800eef <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800ee0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee8:	48 89 d6             	mov    %rdx,%rsi
  800eeb:	89 df                	mov    %ebx,%edi
  800eed:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eef:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ef3:	4c 89 e0             	mov    %r12,%rax
  800ef6:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800efa:	0f b6 00             	movzbl (%rax),%eax
  800efd:	0f be d8             	movsbl %al,%ebx
  800f00:	85 db                	test   %ebx,%ebx
  800f02:	74 10                	je     800f14 <vprintfmt+0x367>
  800f04:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f08:	78 b2                	js     800ebc <vprintfmt+0x30f>
  800f0a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f0e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f12:	79 a8                	jns    800ebc <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f14:	eb 16                	jmp    800f2c <vprintfmt+0x37f>
				putch(' ', putdat);
  800f16:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f1e:	48 89 d6             	mov    %rdx,%rsi
  800f21:	bf 20 00 00 00       	mov    $0x20,%edi
  800f26:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f28:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f30:	7f e4                	jg     800f16 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800f32:	e9 c0 01 00 00       	jmpq   8010f7 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f37:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f3b:	be 03 00 00 00       	mov    $0x3,%esi
  800f40:	48 89 c7             	mov    %rax,%rdi
  800f43:	48 b8 9d 0a 80 00 00 	movabs $0x800a9d,%rax
  800f4a:	00 00 00 
  800f4d:	ff d0                	callq  *%rax
  800f4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f57:	48 85 c0             	test   %rax,%rax
  800f5a:	79 1d                	jns    800f79 <vprintfmt+0x3cc>
				putch('-', putdat);
  800f5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f64:	48 89 d6             	mov    %rdx,%rsi
  800f67:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f6c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f72:	48 f7 d8             	neg    %rax
  800f75:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f79:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f80:	e9 d5 00 00 00       	jmpq   80105a <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f85:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f89:	be 03 00 00 00       	mov    $0x3,%esi
  800f8e:	48 89 c7             	mov    %rax,%rdi
  800f91:	48 b8 8d 09 80 00 00 	movabs $0x80098d,%rax
  800f98:	00 00 00 
  800f9b:	ff d0                	callq  *%rax
  800f9d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800fa1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fa8:	e9 ad 00 00 00       	jmpq   80105a <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800fad:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fb1:	be 03 00 00 00       	mov    $0x3,%esi
  800fb6:	48 89 c7             	mov    %rax,%rdi
  800fb9:	48 b8 8d 09 80 00 00 	movabs $0x80098d,%rax
  800fc0:	00 00 00 
  800fc3:	ff d0                	callq  *%rax
  800fc5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800fc9:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800fd0:	e9 85 00 00 00       	jmpq   80105a <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800fd5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fdd:	48 89 d6             	mov    %rdx,%rsi
  800fe0:	bf 30 00 00 00       	mov    $0x30,%edi
  800fe5:	ff d0                	callq  *%rax
			putch('x', putdat);
  800fe7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800feb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fef:	48 89 d6             	mov    %rdx,%rsi
  800ff2:	bf 78 00 00 00       	mov    $0x78,%edi
  800ff7:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ff9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ffc:	83 f8 30             	cmp    $0x30,%eax
  800fff:	73 17                	jae    801018 <vprintfmt+0x46b>
  801001:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801005:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801008:	89 c0                	mov    %eax,%eax
  80100a:	48 01 d0             	add    %rdx,%rax
  80100d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801010:	83 c2 08             	add    $0x8,%edx
  801013:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801016:	eb 0f                	jmp    801027 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  801018:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80101c:	48 89 d0             	mov    %rdx,%rax
  80101f:	48 83 c2 08          	add    $0x8,%rdx
  801023:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801027:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80102a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80102e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801035:	eb 23                	jmp    80105a <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801037:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80103b:	be 03 00 00 00       	mov    $0x3,%esi
  801040:	48 89 c7             	mov    %rax,%rdi
  801043:	48 b8 8d 09 80 00 00 	movabs $0x80098d,%rax
  80104a:	00 00 00 
  80104d:	ff d0                	callq  *%rax
  80104f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801053:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80105a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80105f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801062:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801065:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801069:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80106d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801071:	45 89 c1             	mov    %r8d,%r9d
  801074:	41 89 f8             	mov    %edi,%r8d
  801077:	48 89 c7             	mov    %rax,%rdi
  80107a:	48 b8 d2 08 80 00 00 	movabs $0x8008d2,%rax
  801081:	00 00 00 
  801084:	ff d0                	callq  *%rax
			break;
  801086:	eb 6f                	jmp    8010f7 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801088:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80108c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801090:	48 89 d6             	mov    %rdx,%rsi
  801093:	89 df                	mov    %ebx,%edi
  801095:	ff d0                	callq  *%rax
			break;
  801097:	eb 5e                	jmp    8010f7 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  801099:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80109d:	be 03 00 00 00       	mov    $0x3,%esi
  8010a2:	48 89 c7             	mov    %rax,%rdi
  8010a5:	48 b8 8d 09 80 00 00 	movabs $0x80098d,%rax
  8010ac:	00 00 00 
  8010af:	ff d0                	callq  *%rax
  8010b1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  8010b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b9:	89 c2                	mov    %eax,%edx
  8010bb:	48 b8 28 74 80 00 00 	movabs $0x807428,%rax
  8010c2:	00 00 00 
  8010c5:	89 10                	mov    %edx,(%rax)
			break;
  8010c7:	eb 2e                	jmp    8010f7 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010c9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010cd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010d1:	48 89 d6             	mov    %rdx,%rsi
  8010d4:	bf 25 00 00 00       	mov    $0x25,%edi
  8010d9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010db:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010e0:	eb 05                	jmp    8010e7 <vprintfmt+0x53a>
  8010e2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010e7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010eb:	48 83 e8 01          	sub    $0x1,%rax
  8010ef:	0f b6 00             	movzbl (%rax),%eax
  8010f2:	3c 25                	cmp    $0x25,%al
  8010f4:	75 ec                	jne    8010e2 <vprintfmt+0x535>
				/* do nothing */;
			break;
  8010f6:	90                   	nop
		}
	}
  8010f7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010f8:	e9 13 fb ff ff       	jmpq   800c10 <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8010fd:	48 83 c4 60          	add    $0x60,%rsp
  801101:	5b                   	pop    %rbx
  801102:	41 5c                	pop    %r12
  801104:	5d                   	pop    %rbp
  801105:	c3                   	retq   

0000000000801106 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801106:	55                   	push   %rbp
  801107:	48 89 e5             	mov    %rsp,%rbp
  80110a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801111:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801118:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80111f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801126:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80112d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801134:	84 c0                	test   %al,%al
  801136:	74 20                	je     801158 <printfmt+0x52>
  801138:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80113c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801140:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801144:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801148:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80114c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801150:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801154:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801158:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80115f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801166:	00 00 00 
  801169:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801170:	00 00 00 
  801173:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801177:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80117e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801185:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80118c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801193:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80119a:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8011a1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8011a8:	48 89 c7             	mov    %rax,%rdi
  8011ab:	48 b8 ad 0b 80 00 00 	movabs $0x800bad,%rax
  8011b2:	00 00 00 
  8011b5:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011b7:	c9                   	leaveq 
  8011b8:	c3                   	retq   

00000000008011b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011b9:	55                   	push   %rbp
  8011ba:	48 89 e5             	mov    %rsp,%rbp
  8011bd:	48 83 ec 10          	sub    $0x10,%rsp
  8011c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cc:	8b 40 10             	mov    0x10(%rax),%eax
  8011cf:	8d 50 01             	lea    0x1(%rax),%edx
  8011d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d6:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011dd:	48 8b 10             	mov    (%rax),%rdx
  8011e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011e8:	48 39 c2             	cmp    %rax,%rdx
  8011eb:	73 17                	jae    801204 <sprintputch+0x4b>
		*b->buf++ = ch;
  8011ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f1:	48 8b 00             	mov    (%rax),%rax
  8011f4:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011fc:	48 89 0a             	mov    %rcx,(%rdx)
  8011ff:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801202:	88 10                	mov    %dl,(%rax)
}
  801204:	c9                   	leaveq 
  801205:	c3                   	retq   

0000000000801206 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801206:	55                   	push   %rbp
  801207:	48 89 e5             	mov    %rsp,%rbp
  80120a:	48 83 ec 50          	sub    $0x50,%rsp
  80120e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801212:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801215:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801219:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80121d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801221:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801225:	48 8b 0a             	mov    (%rdx),%rcx
  801228:	48 89 08             	mov    %rcx,(%rax)
  80122b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80122f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801233:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801237:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80123b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80123f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801243:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801246:	48 98                	cltq   
  801248:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80124c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801250:	48 01 d0             	add    %rdx,%rax
  801253:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801257:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80125e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801263:	74 06                	je     80126b <vsnprintf+0x65>
  801265:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801269:	7f 07                	jg     801272 <vsnprintf+0x6c>
		return -E_INVAL;
  80126b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801270:	eb 2f                	jmp    8012a1 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801272:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801276:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80127a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80127e:	48 89 c6             	mov    %rax,%rsi
  801281:	48 bf b9 11 80 00 00 	movabs $0x8011b9,%rdi
  801288:	00 00 00 
  80128b:	48 b8 ad 0b 80 00 00 	movabs $0x800bad,%rax
  801292:	00 00 00 
  801295:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801297:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80129b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80129e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8012a1:	c9                   	leaveq 
  8012a2:	c3                   	retq   

00000000008012a3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012a3:	55                   	push   %rbp
  8012a4:	48 89 e5             	mov    %rsp,%rbp
  8012a7:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8012ae:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012b5:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012bb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012c2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012c9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012d0:	84 c0                	test   %al,%al
  8012d2:	74 20                	je     8012f4 <snprintf+0x51>
  8012d4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012d8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012dc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012e0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012e4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012e8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012ec:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012f0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012f4:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012fb:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801302:	00 00 00 
  801305:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80130c:	00 00 00 
  80130f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801313:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80131a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801321:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801328:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80132f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801336:	48 8b 0a             	mov    (%rdx),%rcx
  801339:	48 89 08             	mov    %rcx,(%rax)
  80133c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801340:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801344:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801348:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80134c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801353:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80135a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801360:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801367:	48 89 c7             	mov    %rax,%rdi
  80136a:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  801371:	00 00 00 
  801374:	ff d0                	callq  *%rax
  801376:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80137c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801382:	c9                   	leaveq 
  801383:	c3                   	retq   

0000000000801384 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801384:	55                   	push   %rbp
  801385:	48 89 e5             	mov    %rsp,%rbp
  801388:	48 83 ec 18          	sub    $0x18,%rsp
  80138c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801390:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801397:	eb 09                	jmp    8013a2 <strlen+0x1e>
		n++;
  801399:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80139d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a6:	0f b6 00             	movzbl (%rax),%eax
  8013a9:	84 c0                	test   %al,%al
  8013ab:	75 ec                	jne    801399 <strlen+0x15>
		n++;
	return n;
  8013ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013b0:	c9                   	leaveq 
  8013b1:	c3                   	retq   

00000000008013b2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013b2:	55                   	push   %rbp
  8013b3:	48 89 e5             	mov    %rsp,%rbp
  8013b6:	48 83 ec 20          	sub    $0x20,%rsp
  8013ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013c9:	eb 0e                	jmp    8013d9 <strnlen+0x27>
		n++;
  8013cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013cf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013d4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013d9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013de:	74 0b                	je     8013eb <strnlen+0x39>
  8013e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e4:	0f b6 00             	movzbl (%rax),%eax
  8013e7:	84 c0                	test   %al,%al
  8013e9:	75 e0                	jne    8013cb <strnlen+0x19>
		n++;
	return n;
  8013eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013ee:	c9                   	leaveq 
  8013ef:	c3                   	retq   

00000000008013f0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013f0:	55                   	push   %rbp
  8013f1:	48 89 e5             	mov    %rsp,%rbp
  8013f4:	48 83 ec 20          	sub    $0x20,%rsp
  8013f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801400:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801404:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801408:	90                   	nop
  801409:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801411:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801415:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801419:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80141d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801421:	0f b6 12             	movzbl (%rdx),%edx
  801424:	88 10                	mov    %dl,(%rax)
  801426:	0f b6 00             	movzbl (%rax),%eax
  801429:	84 c0                	test   %al,%al
  80142b:	75 dc                	jne    801409 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80142d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801431:	c9                   	leaveq 
  801432:	c3                   	retq   

0000000000801433 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801433:	55                   	push   %rbp
  801434:	48 89 e5             	mov    %rsp,%rbp
  801437:	48 83 ec 20          	sub    $0x20,%rsp
  80143b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80143f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801447:	48 89 c7             	mov    %rax,%rdi
  80144a:	48 b8 84 13 80 00 00 	movabs $0x801384,%rax
  801451:	00 00 00 
  801454:	ff d0                	callq  *%rax
  801456:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801459:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80145c:	48 63 d0             	movslq %eax,%rdx
  80145f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801463:	48 01 c2             	add    %rax,%rdx
  801466:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80146a:	48 89 c6             	mov    %rax,%rsi
  80146d:	48 89 d7             	mov    %rdx,%rdi
  801470:	48 b8 f0 13 80 00 00 	movabs $0x8013f0,%rax
  801477:	00 00 00 
  80147a:	ff d0                	callq  *%rax
	return dst;
  80147c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801480:	c9                   	leaveq 
  801481:	c3                   	retq   

0000000000801482 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801482:	55                   	push   %rbp
  801483:	48 89 e5             	mov    %rsp,%rbp
  801486:	48 83 ec 28          	sub    $0x28,%rsp
  80148a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80148e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801492:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801496:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80149e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8014a5:	00 
  8014a6:	eb 2a                	jmp    8014d2 <strncpy+0x50>
		*dst++ = *src;
  8014a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014b0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014b4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014b8:	0f b6 12             	movzbl (%rdx),%edx
  8014bb:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014c1:	0f b6 00             	movzbl (%rax),%eax
  8014c4:	84 c0                	test   %al,%al
  8014c6:	74 05                	je     8014cd <strncpy+0x4b>
			src++;
  8014c8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014cd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014da:	72 cc                	jb     8014a8 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014e0:	c9                   	leaveq 
  8014e1:	c3                   	retq   

00000000008014e2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014e2:	55                   	push   %rbp
  8014e3:	48 89 e5             	mov    %rsp,%rbp
  8014e6:	48 83 ec 28          	sub    $0x28,%rsp
  8014ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014fe:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801503:	74 3d                	je     801542 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801505:	eb 1d                	jmp    801524 <strlcpy+0x42>
			*dst++ = *src++;
  801507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80150f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801513:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801517:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80151b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80151f:	0f b6 12             	movzbl (%rdx),%edx
  801522:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801524:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801529:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80152e:	74 0b                	je     80153b <strlcpy+0x59>
  801530:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801534:	0f b6 00             	movzbl (%rax),%eax
  801537:	84 c0                	test   %al,%al
  801539:	75 cc                	jne    801507 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80153b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801542:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801546:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154a:	48 29 c2             	sub    %rax,%rdx
  80154d:	48 89 d0             	mov    %rdx,%rax
}
  801550:	c9                   	leaveq 
  801551:	c3                   	retq   

0000000000801552 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801552:	55                   	push   %rbp
  801553:	48 89 e5             	mov    %rsp,%rbp
  801556:	48 83 ec 10          	sub    $0x10,%rsp
  80155a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80155e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801562:	eb 0a                	jmp    80156e <strcmp+0x1c>
		p++, q++;
  801564:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801569:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80156e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801572:	0f b6 00             	movzbl (%rax),%eax
  801575:	84 c0                	test   %al,%al
  801577:	74 12                	je     80158b <strcmp+0x39>
  801579:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157d:	0f b6 10             	movzbl (%rax),%edx
  801580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801584:	0f b6 00             	movzbl (%rax),%eax
  801587:	38 c2                	cmp    %al,%dl
  801589:	74 d9                	je     801564 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80158b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158f:	0f b6 00             	movzbl (%rax),%eax
  801592:	0f b6 d0             	movzbl %al,%edx
  801595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801599:	0f b6 00             	movzbl (%rax),%eax
  80159c:	0f b6 c0             	movzbl %al,%eax
  80159f:	29 c2                	sub    %eax,%edx
  8015a1:	89 d0                	mov    %edx,%eax
}
  8015a3:	c9                   	leaveq 
  8015a4:	c3                   	retq   

00000000008015a5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8015a5:	55                   	push   %rbp
  8015a6:	48 89 e5             	mov    %rsp,%rbp
  8015a9:	48 83 ec 18          	sub    $0x18,%rsp
  8015ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015b9:	eb 0f                	jmp    8015ca <strncmp+0x25>
		n--, p++, q++;
  8015bb:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015c5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015ca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015cf:	74 1d                	je     8015ee <strncmp+0x49>
  8015d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d5:	0f b6 00             	movzbl (%rax),%eax
  8015d8:	84 c0                	test   %al,%al
  8015da:	74 12                	je     8015ee <strncmp+0x49>
  8015dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e0:	0f b6 10             	movzbl (%rax),%edx
  8015e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e7:	0f b6 00             	movzbl (%rax),%eax
  8015ea:	38 c2                	cmp    %al,%dl
  8015ec:	74 cd                	je     8015bb <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015ee:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015f3:	75 07                	jne    8015fc <strncmp+0x57>
		return 0;
  8015f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fa:	eb 18                	jmp    801614 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801600:	0f b6 00             	movzbl (%rax),%eax
  801603:	0f b6 d0             	movzbl %al,%edx
  801606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160a:	0f b6 00             	movzbl (%rax),%eax
  80160d:	0f b6 c0             	movzbl %al,%eax
  801610:	29 c2                	sub    %eax,%edx
  801612:	89 d0                	mov    %edx,%eax
}
  801614:	c9                   	leaveq 
  801615:	c3                   	retq   

0000000000801616 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801616:	55                   	push   %rbp
  801617:	48 89 e5             	mov    %rsp,%rbp
  80161a:	48 83 ec 0c          	sub    $0xc,%rsp
  80161e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801622:	89 f0                	mov    %esi,%eax
  801624:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801627:	eb 17                	jmp    801640 <strchr+0x2a>
		if (*s == c)
  801629:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162d:	0f b6 00             	movzbl (%rax),%eax
  801630:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801633:	75 06                	jne    80163b <strchr+0x25>
			return (char *) s;
  801635:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801639:	eb 15                	jmp    801650 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80163b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801640:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801644:	0f b6 00             	movzbl (%rax),%eax
  801647:	84 c0                	test   %al,%al
  801649:	75 de                	jne    801629 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80164b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801650:	c9                   	leaveq 
  801651:	c3                   	retq   

0000000000801652 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801652:	55                   	push   %rbp
  801653:	48 89 e5             	mov    %rsp,%rbp
  801656:	48 83 ec 0c          	sub    $0xc,%rsp
  80165a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80165e:	89 f0                	mov    %esi,%eax
  801660:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801663:	eb 13                	jmp    801678 <strfind+0x26>
		if (*s == c)
  801665:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801669:	0f b6 00             	movzbl (%rax),%eax
  80166c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80166f:	75 02                	jne    801673 <strfind+0x21>
			break;
  801671:	eb 10                	jmp    801683 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801673:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801678:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167c:	0f b6 00             	movzbl (%rax),%eax
  80167f:	84 c0                	test   %al,%al
  801681:	75 e2                	jne    801665 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801683:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801687:	c9                   	leaveq 
  801688:	c3                   	retq   

0000000000801689 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801689:	55                   	push   %rbp
  80168a:	48 89 e5             	mov    %rsp,%rbp
  80168d:	48 83 ec 18          	sub    $0x18,%rsp
  801691:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801695:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801698:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80169c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016a1:	75 06                	jne    8016a9 <memset+0x20>
		return v;
  8016a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a7:	eb 69                	jmp    801712 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8016a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ad:	83 e0 03             	and    $0x3,%eax
  8016b0:	48 85 c0             	test   %rax,%rax
  8016b3:	75 48                	jne    8016fd <memset+0x74>
  8016b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b9:	83 e0 03             	and    $0x3,%eax
  8016bc:	48 85 c0             	test   %rax,%rax
  8016bf:	75 3c                	jne    8016fd <memset+0x74>
		c &= 0xFF;
  8016c1:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016cb:	c1 e0 18             	shl    $0x18,%eax
  8016ce:	89 c2                	mov    %eax,%edx
  8016d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016d3:	c1 e0 10             	shl    $0x10,%eax
  8016d6:	09 c2                	or     %eax,%edx
  8016d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016db:	c1 e0 08             	shl    $0x8,%eax
  8016de:	09 d0                	or     %edx,%eax
  8016e0:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8016e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e7:	48 c1 e8 02          	shr    $0x2,%rax
  8016eb:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016f5:	48 89 d7             	mov    %rdx,%rdi
  8016f8:	fc                   	cld    
  8016f9:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016fb:	eb 11                	jmp    80170e <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801701:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801704:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801708:	48 89 d7             	mov    %rdx,%rdi
  80170b:	fc                   	cld    
  80170c:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80170e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801712:	c9                   	leaveq 
  801713:	c3                   	retq   

0000000000801714 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801714:	55                   	push   %rbp
  801715:	48 89 e5             	mov    %rsp,%rbp
  801718:	48 83 ec 28          	sub    $0x28,%rsp
  80171c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801720:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801724:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801728:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80172c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801734:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801738:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80173c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801740:	0f 83 88 00 00 00    	jae    8017ce <memmove+0xba>
  801746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80174e:	48 01 d0             	add    %rdx,%rax
  801751:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801755:	76 77                	jbe    8017ce <memmove+0xba>
		s += n;
  801757:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80175f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801763:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801767:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80176b:	83 e0 03             	and    $0x3,%eax
  80176e:	48 85 c0             	test   %rax,%rax
  801771:	75 3b                	jne    8017ae <memmove+0x9a>
  801773:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801777:	83 e0 03             	and    $0x3,%eax
  80177a:	48 85 c0             	test   %rax,%rax
  80177d:	75 2f                	jne    8017ae <memmove+0x9a>
  80177f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801783:	83 e0 03             	and    $0x3,%eax
  801786:	48 85 c0             	test   %rax,%rax
  801789:	75 23                	jne    8017ae <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80178b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80178f:	48 83 e8 04          	sub    $0x4,%rax
  801793:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801797:	48 83 ea 04          	sub    $0x4,%rdx
  80179b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80179f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8017a3:	48 89 c7             	mov    %rax,%rdi
  8017a6:	48 89 d6             	mov    %rdx,%rsi
  8017a9:	fd                   	std    
  8017aa:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017ac:	eb 1d                	jmp    8017cb <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ba:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c2:	48 89 d7             	mov    %rdx,%rdi
  8017c5:	48 89 c1             	mov    %rax,%rcx
  8017c8:	fd                   	std    
  8017c9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017cb:	fc                   	cld    
  8017cc:	eb 57                	jmp    801825 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017d2:	83 e0 03             	and    $0x3,%eax
  8017d5:	48 85 c0             	test   %rax,%rax
  8017d8:	75 36                	jne    801810 <memmove+0xfc>
  8017da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017de:	83 e0 03             	and    $0x3,%eax
  8017e1:	48 85 c0             	test   %rax,%rax
  8017e4:	75 2a                	jne    801810 <memmove+0xfc>
  8017e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ea:	83 e0 03             	and    $0x3,%eax
  8017ed:	48 85 c0             	test   %rax,%rax
  8017f0:	75 1e                	jne    801810 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f6:	48 c1 e8 02          	shr    $0x2,%rax
  8017fa:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801801:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801805:	48 89 c7             	mov    %rax,%rdi
  801808:	48 89 d6             	mov    %rdx,%rsi
  80180b:	fc                   	cld    
  80180c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80180e:	eb 15                	jmp    801825 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801810:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801814:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801818:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80181c:	48 89 c7             	mov    %rax,%rdi
  80181f:	48 89 d6             	mov    %rdx,%rsi
  801822:	fc                   	cld    
  801823:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801825:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801829:	c9                   	leaveq 
  80182a:	c3                   	retq   

000000000080182b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80182b:	55                   	push   %rbp
  80182c:	48 89 e5             	mov    %rsp,%rbp
  80182f:	48 83 ec 18          	sub    $0x18,%rsp
  801833:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801837:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80183b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80183f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801843:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801847:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80184b:	48 89 ce             	mov    %rcx,%rsi
  80184e:	48 89 c7             	mov    %rax,%rdi
  801851:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  801858:	00 00 00 
  80185b:	ff d0                	callq  *%rax
}
  80185d:	c9                   	leaveq 
  80185e:	c3                   	retq   

000000000080185f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80185f:	55                   	push   %rbp
  801860:	48 89 e5             	mov    %rsp,%rbp
  801863:	48 83 ec 28          	sub    $0x28,%rsp
  801867:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80186b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80186f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801873:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801877:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80187b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80187f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801883:	eb 36                	jmp    8018bb <memcmp+0x5c>
		if (*s1 != *s2)
  801885:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801889:	0f b6 10             	movzbl (%rax),%edx
  80188c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801890:	0f b6 00             	movzbl (%rax),%eax
  801893:	38 c2                	cmp    %al,%dl
  801895:	74 1a                	je     8018b1 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801897:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80189b:	0f b6 00             	movzbl (%rax),%eax
  80189e:	0f b6 d0             	movzbl %al,%edx
  8018a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a5:	0f b6 00             	movzbl (%rax),%eax
  8018a8:	0f b6 c0             	movzbl %al,%eax
  8018ab:	29 c2                	sub    %eax,%edx
  8018ad:	89 d0                	mov    %edx,%eax
  8018af:	eb 20                	jmp    8018d1 <memcmp+0x72>
		s1++, s2++;
  8018b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018b6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bf:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018c7:	48 85 c0             	test   %rax,%rax
  8018ca:	75 b9                	jne    801885 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d1:	c9                   	leaveq 
  8018d2:	c3                   	retq   

00000000008018d3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018d3:	55                   	push   %rbp
  8018d4:	48 89 e5             	mov    %rsp,%rbp
  8018d7:	48 83 ec 28          	sub    $0x28,%rsp
  8018db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018df:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018ee:	48 01 d0             	add    %rdx,%rax
  8018f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018f5:	eb 15                	jmp    80190c <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018fb:	0f b6 10             	movzbl (%rax),%edx
  8018fe:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801901:	38 c2                	cmp    %al,%dl
  801903:	75 02                	jne    801907 <memfind+0x34>
			break;
  801905:	eb 0f                	jmp    801916 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801907:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80190c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801910:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801914:	72 e1                	jb     8018f7 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801916:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80191a:	c9                   	leaveq 
  80191b:	c3                   	retq   

000000000080191c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80191c:	55                   	push   %rbp
  80191d:	48 89 e5             	mov    %rsp,%rbp
  801920:	48 83 ec 34          	sub    $0x34,%rsp
  801924:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801928:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80192c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80192f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801936:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80193d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80193e:	eb 05                	jmp    801945 <strtol+0x29>
		s++;
  801940:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801945:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801949:	0f b6 00             	movzbl (%rax),%eax
  80194c:	3c 20                	cmp    $0x20,%al
  80194e:	74 f0                	je     801940 <strtol+0x24>
  801950:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801954:	0f b6 00             	movzbl (%rax),%eax
  801957:	3c 09                	cmp    $0x9,%al
  801959:	74 e5                	je     801940 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80195b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195f:	0f b6 00             	movzbl (%rax),%eax
  801962:	3c 2b                	cmp    $0x2b,%al
  801964:	75 07                	jne    80196d <strtol+0x51>
		s++;
  801966:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80196b:	eb 17                	jmp    801984 <strtol+0x68>
	else if (*s == '-')
  80196d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801971:	0f b6 00             	movzbl (%rax),%eax
  801974:	3c 2d                	cmp    $0x2d,%al
  801976:	75 0c                	jne    801984 <strtol+0x68>
		s++, neg = 1;
  801978:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80197d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801984:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801988:	74 06                	je     801990 <strtol+0x74>
  80198a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80198e:	75 28                	jne    8019b8 <strtol+0x9c>
  801990:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801994:	0f b6 00             	movzbl (%rax),%eax
  801997:	3c 30                	cmp    $0x30,%al
  801999:	75 1d                	jne    8019b8 <strtol+0x9c>
  80199b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199f:	48 83 c0 01          	add    $0x1,%rax
  8019a3:	0f b6 00             	movzbl (%rax),%eax
  8019a6:	3c 78                	cmp    $0x78,%al
  8019a8:	75 0e                	jne    8019b8 <strtol+0x9c>
		s += 2, base = 16;
  8019aa:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019af:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019b6:	eb 2c                	jmp    8019e4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019b8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019bc:	75 19                	jne    8019d7 <strtol+0xbb>
  8019be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c2:	0f b6 00             	movzbl (%rax),%eax
  8019c5:	3c 30                	cmp    $0x30,%al
  8019c7:	75 0e                	jne    8019d7 <strtol+0xbb>
		s++, base = 8;
  8019c9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019ce:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019d5:	eb 0d                	jmp    8019e4 <strtol+0xc8>
	else if (base == 0)
  8019d7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019db:	75 07                	jne    8019e4 <strtol+0xc8>
		base = 10;
  8019dd:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e8:	0f b6 00             	movzbl (%rax),%eax
  8019eb:	3c 2f                	cmp    $0x2f,%al
  8019ed:	7e 1d                	jle    801a0c <strtol+0xf0>
  8019ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f3:	0f b6 00             	movzbl (%rax),%eax
  8019f6:	3c 39                	cmp    $0x39,%al
  8019f8:	7f 12                	jg     801a0c <strtol+0xf0>
			dig = *s - '0';
  8019fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fe:	0f b6 00             	movzbl (%rax),%eax
  801a01:	0f be c0             	movsbl %al,%eax
  801a04:	83 e8 30             	sub    $0x30,%eax
  801a07:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a0a:	eb 4e                	jmp    801a5a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a10:	0f b6 00             	movzbl (%rax),%eax
  801a13:	3c 60                	cmp    $0x60,%al
  801a15:	7e 1d                	jle    801a34 <strtol+0x118>
  801a17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1b:	0f b6 00             	movzbl (%rax),%eax
  801a1e:	3c 7a                	cmp    $0x7a,%al
  801a20:	7f 12                	jg     801a34 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a26:	0f b6 00             	movzbl (%rax),%eax
  801a29:	0f be c0             	movsbl %al,%eax
  801a2c:	83 e8 57             	sub    $0x57,%eax
  801a2f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a32:	eb 26                	jmp    801a5a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a38:	0f b6 00             	movzbl (%rax),%eax
  801a3b:	3c 40                	cmp    $0x40,%al
  801a3d:	7e 48                	jle    801a87 <strtol+0x16b>
  801a3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a43:	0f b6 00             	movzbl (%rax),%eax
  801a46:	3c 5a                	cmp    $0x5a,%al
  801a48:	7f 3d                	jg     801a87 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4e:	0f b6 00             	movzbl (%rax),%eax
  801a51:	0f be c0             	movsbl %al,%eax
  801a54:	83 e8 37             	sub    $0x37,%eax
  801a57:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a5a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a5d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a60:	7c 02                	jl     801a64 <strtol+0x148>
			break;
  801a62:	eb 23                	jmp    801a87 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a64:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a69:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a6c:	48 98                	cltq   
  801a6e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a73:	48 89 c2             	mov    %rax,%rdx
  801a76:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a79:	48 98                	cltq   
  801a7b:	48 01 d0             	add    %rdx,%rax
  801a7e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a82:	e9 5d ff ff ff       	jmpq   8019e4 <strtol+0xc8>

	if (endptr)
  801a87:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a8c:	74 0b                	je     801a99 <strtol+0x17d>
		*endptr = (char *) s;
  801a8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a92:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a96:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a9d:	74 09                	je     801aa8 <strtol+0x18c>
  801a9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aa3:	48 f7 d8             	neg    %rax
  801aa6:	eb 04                	jmp    801aac <strtol+0x190>
  801aa8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801aac:	c9                   	leaveq 
  801aad:	c3                   	retq   

0000000000801aae <strstr>:

char * strstr(const char *in, const char *str)
{
  801aae:	55                   	push   %rbp
  801aaf:	48 89 e5             	mov    %rsp,%rbp
  801ab2:	48 83 ec 30          	sub    $0x30,%rsp
  801ab6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801aba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801abe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ac2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ac6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801aca:	0f b6 00             	movzbl (%rax),%eax
  801acd:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801ad0:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801ad4:	75 06                	jne    801adc <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801ad6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ada:	eb 6b                	jmp    801b47 <strstr+0x99>

	len = strlen(str);
  801adc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ae0:	48 89 c7             	mov    %rax,%rdi
  801ae3:	48 b8 84 13 80 00 00 	movabs $0x801384,%rax
  801aea:	00 00 00 
  801aed:	ff d0                	callq  *%rax
  801aef:	48 98                	cltq   
  801af1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801af5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801afd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b01:	0f b6 00             	movzbl (%rax),%eax
  801b04:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b07:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b0b:	75 07                	jne    801b14 <strstr+0x66>
				return (char *) 0;
  801b0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b12:	eb 33                	jmp    801b47 <strstr+0x99>
		} while (sc != c);
  801b14:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b18:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b1b:	75 d8                	jne    801af5 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b21:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b29:	48 89 ce             	mov    %rcx,%rsi
  801b2c:	48 89 c7             	mov    %rax,%rdi
  801b2f:	48 b8 a5 15 80 00 00 	movabs $0x8015a5,%rax
  801b36:	00 00 00 
  801b39:	ff d0                	callq  *%rax
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	75 b6                	jne    801af5 <strstr+0x47>

	return (char *) (in - 1);
  801b3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b43:	48 83 e8 01          	sub    $0x1,%rax
}
  801b47:	c9                   	leaveq 
  801b48:	c3                   	retq   

0000000000801b49 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b49:	55                   	push   %rbp
  801b4a:	48 89 e5             	mov    %rsp,%rbp
  801b4d:	53                   	push   %rbx
  801b4e:	48 83 ec 48          	sub    $0x48,%rsp
  801b52:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b55:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b58:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b5c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b60:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b64:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b68:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b6b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b6f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b73:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b77:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b7b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b7f:	4c 89 c3             	mov    %r8,%rbx
  801b82:	cd 30                	int    $0x30
  801b84:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801b88:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b8c:	74 3e                	je     801bcc <syscall+0x83>
  801b8e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b93:	7e 37                	jle    801bcc <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b95:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b99:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b9c:	49 89 d0             	mov    %rdx,%r8
  801b9f:	89 c1                	mov    %eax,%ecx
  801ba1:	48 ba e8 46 80 00 00 	movabs $0x8046e8,%rdx
  801ba8:	00 00 00 
  801bab:	be 23 00 00 00       	mov    $0x23,%esi
  801bb0:	48 bf 05 47 80 00 00 	movabs $0x804705,%rdi
  801bb7:	00 00 00 
  801bba:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbf:	49 b9 c1 05 80 00 00 	movabs $0x8005c1,%r9
  801bc6:	00 00 00 
  801bc9:	41 ff d1             	callq  *%r9

	return ret;
  801bcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bd0:	48 83 c4 48          	add    $0x48,%rsp
  801bd4:	5b                   	pop    %rbx
  801bd5:	5d                   	pop    %rbp
  801bd6:	c3                   	retq   

0000000000801bd7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801bd7:	55                   	push   %rbp
  801bd8:	48 89 e5             	mov    %rsp,%rbp
  801bdb:	48 83 ec 20          	sub    $0x20,%rsp
  801bdf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801be3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801be7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801beb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bef:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf6:	00 
  801bf7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c03:	48 89 d1             	mov    %rdx,%rcx
  801c06:	48 89 c2             	mov    %rax,%rdx
  801c09:	be 00 00 00 00       	mov    $0x0,%esi
  801c0e:	bf 00 00 00 00       	mov    $0x0,%edi
  801c13:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801c1a:	00 00 00 
  801c1d:	ff d0                	callq  *%rax
}
  801c1f:	c9                   	leaveq 
  801c20:	c3                   	retq   

0000000000801c21 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c21:	55                   	push   %rbp
  801c22:	48 89 e5             	mov    %rsp,%rbp
  801c25:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c29:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c30:	00 
  801c31:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c37:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c42:	ba 00 00 00 00       	mov    $0x0,%edx
  801c47:	be 00 00 00 00       	mov    $0x0,%esi
  801c4c:	bf 01 00 00 00       	mov    $0x1,%edi
  801c51:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801c58:	00 00 00 
  801c5b:	ff d0                	callq  *%rax
}
  801c5d:	c9                   	leaveq 
  801c5e:	c3                   	retq   

0000000000801c5f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c5f:	55                   	push   %rbp
  801c60:	48 89 e5             	mov    %rsp,%rbp
  801c63:	48 83 ec 10          	sub    $0x10,%rsp
  801c67:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c6d:	48 98                	cltq   
  801c6f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c76:	00 
  801c77:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c7d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c83:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c88:	48 89 c2             	mov    %rax,%rdx
  801c8b:	be 01 00 00 00       	mov    $0x1,%esi
  801c90:	bf 03 00 00 00       	mov    $0x3,%edi
  801c95:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801c9c:	00 00 00 
  801c9f:	ff d0                	callq  *%rax
}
  801ca1:	c9                   	leaveq 
  801ca2:	c3                   	retq   

0000000000801ca3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ca3:	55                   	push   %rbp
  801ca4:	48 89 e5             	mov    %rsp,%rbp
  801ca7:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801cab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb2:	00 
  801cb3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cbf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc4:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc9:	be 00 00 00 00       	mov    $0x0,%esi
  801cce:	bf 02 00 00 00       	mov    $0x2,%edi
  801cd3:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801cda:	00 00 00 
  801cdd:	ff d0                	callq  *%rax
}
  801cdf:	c9                   	leaveq 
  801ce0:	c3                   	retq   

0000000000801ce1 <sys_yield>:

void
sys_yield(void)
{
  801ce1:	55                   	push   %rbp
  801ce2:	48 89 e5             	mov    %rsp,%rbp
  801ce5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ce9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf0:	00 
  801cf1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d02:	ba 00 00 00 00       	mov    $0x0,%edx
  801d07:	be 00 00 00 00       	mov    $0x0,%esi
  801d0c:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d11:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	callq  *%rax
}
  801d1d:	c9                   	leaveq 
  801d1e:	c3                   	retq   

0000000000801d1f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d1f:	55                   	push   %rbp
  801d20:	48 89 e5             	mov    %rsp,%rbp
  801d23:	48 83 ec 20          	sub    $0x20,%rsp
  801d27:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d2a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d2e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d34:	48 63 c8             	movslq %eax,%rcx
  801d37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3e:	48 98                	cltq   
  801d40:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d47:	00 
  801d48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d4e:	49 89 c8             	mov    %rcx,%r8
  801d51:	48 89 d1             	mov    %rdx,%rcx
  801d54:	48 89 c2             	mov    %rax,%rdx
  801d57:	be 01 00 00 00       	mov    $0x1,%esi
  801d5c:	bf 04 00 00 00       	mov    $0x4,%edi
  801d61:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801d68:	00 00 00 
  801d6b:	ff d0                	callq  *%rax
}
  801d6d:	c9                   	leaveq 
  801d6e:	c3                   	retq   

0000000000801d6f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d6f:	55                   	push   %rbp
  801d70:	48 89 e5             	mov    %rsp,%rbp
  801d73:	48 83 ec 30          	sub    $0x30,%rsp
  801d77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d7e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d81:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d85:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d89:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d8c:	48 63 c8             	movslq %eax,%rcx
  801d8f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d96:	48 63 f0             	movslq %eax,%rsi
  801d99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da0:	48 98                	cltq   
  801da2:	48 89 0c 24          	mov    %rcx,(%rsp)
  801da6:	49 89 f9             	mov    %rdi,%r9
  801da9:	49 89 f0             	mov    %rsi,%r8
  801dac:	48 89 d1             	mov    %rdx,%rcx
  801daf:	48 89 c2             	mov    %rax,%rdx
  801db2:	be 01 00 00 00       	mov    $0x1,%esi
  801db7:	bf 05 00 00 00       	mov    $0x5,%edi
  801dbc:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801dc3:	00 00 00 
  801dc6:	ff d0                	callq  *%rax
}
  801dc8:	c9                   	leaveq 
  801dc9:	c3                   	retq   

0000000000801dca <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801dca:	55                   	push   %rbp
  801dcb:	48 89 e5             	mov    %rsp,%rbp
  801dce:	48 83 ec 20          	sub    $0x20,%rsp
  801dd2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dd5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801dd9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ddd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de0:	48 98                	cltq   
  801de2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801de9:	00 
  801dea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801df0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801df6:	48 89 d1             	mov    %rdx,%rcx
  801df9:	48 89 c2             	mov    %rax,%rdx
  801dfc:	be 01 00 00 00       	mov    $0x1,%esi
  801e01:	bf 06 00 00 00       	mov    $0x6,%edi
  801e06:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801e0d:	00 00 00 
  801e10:	ff d0                	callq  *%rax
}
  801e12:	c9                   	leaveq 
  801e13:	c3                   	retq   

0000000000801e14 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e14:	55                   	push   %rbp
  801e15:	48 89 e5             	mov    %rsp,%rbp
  801e18:	48 83 ec 10          	sub    $0x10,%rsp
  801e1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e1f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e25:	48 63 d0             	movslq %eax,%rdx
  801e28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2b:	48 98                	cltq   
  801e2d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e34:	00 
  801e35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e3b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e41:	48 89 d1             	mov    %rdx,%rcx
  801e44:	48 89 c2             	mov    %rax,%rdx
  801e47:	be 01 00 00 00       	mov    $0x1,%esi
  801e4c:	bf 08 00 00 00       	mov    $0x8,%edi
  801e51:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801e58:	00 00 00 
  801e5b:	ff d0                	callq  *%rax
}
  801e5d:	c9                   	leaveq 
  801e5e:	c3                   	retq   

0000000000801e5f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e5f:	55                   	push   %rbp
  801e60:	48 89 e5             	mov    %rsp,%rbp
  801e63:	48 83 ec 20          	sub    $0x20,%rsp
  801e67:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e75:	48 98                	cltq   
  801e77:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e7e:	00 
  801e7f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e85:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e8b:	48 89 d1             	mov    %rdx,%rcx
  801e8e:	48 89 c2             	mov    %rax,%rdx
  801e91:	be 01 00 00 00       	mov    $0x1,%esi
  801e96:	bf 09 00 00 00       	mov    $0x9,%edi
  801e9b:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801ea2:	00 00 00 
  801ea5:	ff d0                	callq  *%rax
}
  801ea7:	c9                   	leaveq 
  801ea8:	c3                   	retq   

0000000000801ea9 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ea9:	55                   	push   %rbp
  801eaa:	48 89 e5             	mov    %rsp,%rbp
  801ead:	48 83 ec 20          	sub    $0x20,%rsp
  801eb1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eb4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801eb8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ebc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ebf:	48 98                	cltq   
  801ec1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ec8:	00 
  801ec9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ecf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ed5:	48 89 d1             	mov    %rdx,%rcx
  801ed8:	48 89 c2             	mov    %rax,%rdx
  801edb:	be 01 00 00 00       	mov    $0x1,%esi
  801ee0:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ee5:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801eec:	00 00 00 
  801eef:	ff d0                	callq  *%rax
}
  801ef1:	c9                   	leaveq 
  801ef2:	c3                   	retq   

0000000000801ef3 <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801ef3:	55                   	push   %rbp
  801ef4:	48 89 e5             	mov    %rsp,%rbp
  801ef7:	48 83 ec 10          	sub    $0x10,%rsp
  801efb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801efe:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801f01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f04:	48 63 d0             	movslq %eax,%rdx
  801f07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f0a:	48 98                	cltq   
  801f0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f13:	00 
  801f14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f20:	48 89 d1             	mov    %rdx,%rcx
  801f23:	48 89 c2             	mov    %rax,%rdx
  801f26:	be 01 00 00 00       	mov    $0x1,%esi
  801f2b:	bf 11 00 00 00       	mov    $0x11,%edi
  801f30:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801f37:	00 00 00 
  801f3a:	ff d0                	callq  *%rax

}
  801f3c:	c9                   	leaveq 
  801f3d:	c3                   	retq   

0000000000801f3e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f3e:	55                   	push   %rbp
  801f3f:	48 89 e5             	mov    %rsp,%rbp
  801f42:	48 83 ec 20          	sub    $0x20,%rsp
  801f46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f4d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f51:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f57:	48 63 f0             	movslq %eax,%rsi
  801f5a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f61:	48 98                	cltq   
  801f63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f6e:	00 
  801f6f:	49 89 f1             	mov    %rsi,%r9
  801f72:	49 89 c8             	mov    %rcx,%r8
  801f75:	48 89 d1             	mov    %rdx,%rcx
  801f78:	48 89 c2             	mov    %rax,%rdx
  801f7b:	be 00 00 00 00       	mov    $0x0,%esi
  801f80:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f85:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801f8c:	00 00 00 
  801f8f:	ff d0                	callq  *%rax
}
  801f91:	c9                   	leaveq 
  801f92:	c3                   	retq   

0000000000801f93 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f93:	55                   	push   %rbp
  801f94:	48 89 e5             	mov    %rsp,%rbp
  801f97:	48 83 ec 10          	sub    $0x10,%rsp
  801f9b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801faa:	00 
  801fab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fb1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fb7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fbc:	48 89 c2             	mov    %rax,%rdx
  801fbf:	be 01 00 00 00       	mov    $0x1,%esi
  801fc4:	bf 0d 00 00 00       	mov    $0xd,%edi
  801fc9:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801fd0:	00 00 00 
  801fd3:	ff d0                	callq  *%rax
}
  801fd5:	c9                   	leaveq 
  801fd6:	c3                   	retq   

0000000000801fd7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801fd7:	55                   	push   %rbp
  801fd8:	48 89 e5             	mov    %rsp,%rbp
  801fdb:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801fdf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fe6:	00 
  801fe7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ff3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ff8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ffd:	be 00 00 00 00       	mov    $0x0,%esi
  802002:	bf 0e 00 00 00       	mov    $0xe,%edi
  802007:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  80200e:	00 00 00 
  802011:	ff d0                	callq  *%rax
}
  802013:	c9                   	leaveq 
  802014:	c3                   	retq   

0000000000802015 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802015:	55                   	push   %rbp
  802016:	48 89 e5             	mov    %rsp,%rbp
  802019:	48 83 ec 30          	sub    $0x30,%rsp
  80201d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802020:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802024:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802027:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80202b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  80202f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802032:	48 63 c8             	movslq %eax,%rcx
  802035:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802039:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80203c:	48 63 f0             	movslq %eax,%rsi
  80203f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802043:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802046:	48 98                	cltq   
  802048:	48 89 0c 24          	mov    %rcx,(%rsp)
  80204c:	49 89 f9             	mov    %rdi,%r9
  80204f:	49 89 f0             	mov    %rsi,%r8
  802052:	48 89 d1             	mov    %rdx,%rcx
  802055:	48 89 c2             	mov    %rax,%rdx
  802058:	be 00 00 00 00       	mov    $0x0,%esi
  80205d:	bf 0f 00 00 00       	mov    $0xf,%edi
  802062:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  802069:	00 00 00 
  80206c:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  80206e:	c9                   	leaveq 
  80206f:	c3                   	retq   

0000000000802070 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802070:	55                   	push   %rbp
  802071:	48 89 e5             	mov    %rsp,%rbp
  802074:	48 83 ec 20          	sub    $0x20,%rsp
  802078:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80207c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802080:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802088:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80208f:	00 
  802090:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802096:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80209c:	48 89 d1             	mov    %rdx,%rcx
  80209f:	48 89 c2             	mov    %rax,%rdx
  8020a2:	be 00 00 00 00       	mov    $0x0,%esi
  8020a7:	bf 10 00 00 00       	mov    $0x10,%edi
  8020ac:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  8020b3:	00 00 00 
  8020b6:	ff d0                	callq  *%rax
}
  8020b8:	c9                   	leaveq 
  8020b9:	c3                   	retq   

00000000008020ba <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8020ba:	55                   	push   %rbp
  8020bb:	48 89 e5             	mov    %rsp,%rbp
  8020be:	48 83 ec 18          	sub    $0x18,%rsp
  8020c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020ca:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  8020ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020d6:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  8020d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020e1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8020e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020e9:	8b 00                	mov    (%rax),%eax
  8020eb:	83 f8 01             	cmp    $0x1,%eax
  8020ee:	7e 13                	jle    802103 <argstart+0x49>
  8020f0:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8020f5:	74 0c                	je     802103 <argstart+0x49>
  8020f7:	48 b8 13 47 80 00 00 	movabs $0x804713,%rax
  8020fe:	00 00 00 
  802101:	eb 05                	jmp    802108 <argstart+0x4e>
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
  802108:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80210c:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  802110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802114:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80211b:	00 
}
  80211c:	c9                   	leaveq 
  80211d:	c3                   	retq   

000000000080211e <argnext>:

int
argnext(struct Argstate *args)
{
  80211e:	55                   	push   %rbp
  80211f:	48 89 e5             	mov    %rsp,%rbp
  802122:	48 83 ec 20          	sub    $0x20,%rsp
  802126:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  80212a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212e:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802135:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  802136:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80213a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80213e:	48 85 c0             	test   %rax,%rax
  802141:	75 0a                	jne    80214d <argnext+0x2f>
		return -1;
  802143:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802148:	e9 25 01 00 00       	jmpq   802272 <argnext+0x154>

	if (!*args->curarg) {
  80214d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802151:	48 8b 40 10          	mov    0x10(%rax),%rax
  802155:	0f b6 00             	movzbl (%rax),%eax
  802158:	84 c0                	test   %al,%al
  80215a:	0f 85 d7 00 00 00    	jne    802237 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  802160:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802164:	48 8b 00             	mov    (%rax),%rax
  802167:	8b 00                	mov    (%rax),%eax
  802169:	83 f8 01             	cmp    $0x1,%eax
  80216c:	0f 84 ef 00 00 00    	je     802261 <argnext+0x143>
		    || args->argv[1][0] != '-'
  802172:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802176:	48 8b 40 08          	mov    0x8(%rax),%rax
  80217a:	48 83 c0 08          	add    $0x8,%rax
  80217e:	48 8b 00             	mov    (%rax),%rax
  802181:	0f b6 00             	movzbl (%rax),%eax
  802184:	3c 2d                	cmp    $0x2d,%al
  802186:	0f 85 d5 00 00 00    	jne    802261 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  80218c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802190:	48 8b 40 08          	mov    0x8(%rax),%rax
  802194:	48 83 c0 08          	add    $0x8,%rax
  802198:	48 8b 00             	mov    (%rax),%rax
  80219b:	48 83 c0 01          	add    $0x1,%rax
  80219f:	0f b6 00             	movzbl (%rax),%eax
  8021a2:	84 c0                	test   %al,%al
  8021a4:	0f 84 b7 00 00 00    	je     802261 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8021aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ae:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021b2:	48 83 c0 08          	add    $0x8,%rax
  8021b6:	48 8b 00             	mov    (%rax),%rax
  8021b9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c1:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8021c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c9:	48 8b 00             	mov    (%rax),%rax
  8021cc:	8b 00                	mov    (%rax),%eax
  8021ce:	83 e8 01             	sub    $0x1,%eax
  8021d1:	48 98                	cltq   
  8021d3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8021da:	00 
  8021db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021df:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021e3:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8021e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021eb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021ef:	48 83 c0 08          	add    $0x8,%rax
  8021f3:	48 89 ce             	mov    %rcx,%rsi
  8021f6:	48 89 c7             	mov    %rax,%rdi
  8021f9:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  802200:	00 00 00 
  802203:	ff d0                	callq  *%rax
		(*args->argc)--;
  802205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802209:	48 8b 00             	mov    (%rax),%rax
  80220c:	8b 10                	mov    (%rax),%edx
  80220e:	83 ea 01             	sub    $0x1,%edx
  802211:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  802213:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802217:	48 8b 40 10          	mov    0x10(%rax),%rax
  80221b:	0f b6 00             	movzbl (%rax),%eax
  80221e:	3c 2d                	cmp    $0x2d,%al
  802220:	75 15                	jne    802237 <argnext+0x119>
  802222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802226:	48 8b 40 10          	mov    0x10(%rax),%rax
  80222a:	48 83 c0 01          	add    $0x1,%rax
  80222e:	0f b6 00             	movzbl (%rax),%eax
  802231:	84 c0                	test   %al,%al
  802233:	75 02                	jne    802237 <argnext+0x119>
			goto endofargs;
  802235:	eb 2a                	jmp    802261 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  802237:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80223f:	0f b6 00             	movzbl (%rax),%eax
  802242:	0f b6 c0             	movzbl %al,%eax
  802245:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  802248:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80224c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802250:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802254:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802258:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  80225c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225f:	eb 11                	jmp    802272 <argnext+0x154>

endofargs:
	args->curarg = 0;
  802261:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802265:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80226c:	00 
	return -1;
  80226d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  802272:	c9                   	leaveq 
  802273:	c3                   	retq   

0000000000802274 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  802274:	55                   	push   %rbp
  802275:	48 89 e5             	mov    %rsp,%rbp
  802278:	48 83 ec 10          	sub    $0x10,%rsp
  80227c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  802280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802284:	48 8b 40 18          	mov    0x18(%rax),%rax
  802288:	48 85 c0             	test   %rax,%rax
  80228b:	74 0a                	je     802297 <argvalue+0x23>
  80228d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802291:	48 8b 40 18          	mov    0x18(%rax),%rax
  802295:	eb 13                	jmp    8022aa <argvalue+0x36>
  802297:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80229b:	48 89 c7             	mov    %rax,%rdi
  80229e:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  8022a5:	00 00 00 
  8022a8:	ff d0                	callq  *%rax
}
  8022aa:	c9                   	leaveq 
  8022ab:	c3                   	retq   

00000000008022ac <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  8022ac:	55                   	push   %rbp
  8022ad:	48 89 e5             	mov    %rsp,%rbp
  8022b0:	53                   	push   %rbx
  8022b1:	48 83 ec 18          	sub    $0x18,%rsp
  8022b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  8022b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bd:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022c1:	48 85 c0             	test   %rax,%rax
  8022c4:	75 0a                	jne    8022d0 <argnextvalue+0x24>
		return 0;
  8022c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cb:	e9 c8 00 00 00       	jmpq   802398 <argnextvalue+0xec>
	if (*args->curarg) {
  8022d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022d8:	0f b6 00             	movzbl (%rax),%eax
  8022db:	84 c0                	test   %al,%al
  8022dd:	74 27                	je     802306 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  8022df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022eb:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  8022ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f3:	48 bb 13 47 80 00 00 	movabs $0x804713,%rbx
  8022fa:	00 00 00 
  8022fd:	48 89 58 10          	mov    %rbx,0x10(%rax)
  802301:	e9 8a 00 00 00       	jmpq   802390 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  802306:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230a:	48 8b 00             	mov    (%rax),%rax
  80230d:	8b 00                	mov    (%rax),%eax
  80230f:	83 f8 01             	cmp    $0x1,%eax
  802312:	7e 64                	jle    802378 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  802314:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802318:	48 8b 40 08          	mov    0x8(%rax),%rax
  80231c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802320:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802324:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802328:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232c:	48 8b 00             	mov    (%rax),%rax
  80232f:	8b 00                	mov    (%rax),%eax
  802331:	83 e8 01             	sub    $0x1,%eax
  802334:	48 98                	cltq   
  802336:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80233d:	00 
  80233e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802342:	48 8b 40 08          	mov    0x8(%rax),%rax
  802346:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80234a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234e:	48 8b 40 08          	mov    0x8(%rax),%rax
  802352:	48 83 c0 08          	add    $0x8,%rax
  802356:	48 89 ce             	mov    %rcx,%rsi
  802359:	48 89 c7             	mov    %rax,%rdi
  80235c:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  802363:	00 00 00 
  802366:	ff d0                	callq  *%rax
		(*args->argc)--;
  802368:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236c:	48 8b 00             	mov    (%rax),%rax
  80236f:	8b 10                	mov    (%rax),%edx
  802371:	83 ea 01             	sub    $0x1,%edx
  802374:	89 10                	mov    %edx,(%rax)
  802376:	eb 18                	jmp    802390 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  802378:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237c:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802383:	00 
		args->curarg = 0;
  802384:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802388:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80238f:	00 
	}
	return (char*) args->argvalue;
  802390:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802394:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  802398:	48 83 c4 18          	add    $0x18,%rsp
  80239c:	5b                   	pop    %rbx
  80239d:	5d                   	pop    %rbp
  80239e:	c3                   	retq   

000000000080239f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80239f:	55                   	push   %rbp
  8023a0:	48 89 e5             	mov    %rsp,%rbp
  8023a3:	48 83 ec 08          	sub    $0x8,%rsp
  8023a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8023ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023af:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8023b6:	ff ff ff 
  8023b9:	48 01 d0             	add    %rdx,%rax
  8023bc:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8023c0:	c9                   	leaveq 
  8023c1:	c3                   	retq   

00000000008023c2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8023c2:	55                   	push   %rbp
  8023c3:	48 89 e5             	mov    %rsp,%rbp
  8023c6:	48 83 ec 08          	sub    $0x8,%rsp
  8023ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8023ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d2:	48 89 c7             	mov    %rax,%rdi
  8023d5:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  8023dc:	00 00 00 
  8023df:	ff d0                	callq  *%rax
  8023e1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8023e7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8023eb:	c9                   	leaveq 
  8023ec:	c3                   	retq   

00000000008023ed <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8023ed:	55                   	push   %rbp
  8023ee:	48 89 e5             	mov    %rsp,%rbp
  8023f1:	48 83 ec 18          	sub    $0x18,%rsp
  8023f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802400:	eb 6b                	jmp    80246d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802402:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802405:	48 98                	cltq   
  802407:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80240d:	48 c1 e0 0c          	shl    $0xc,%rax
  802411:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802415:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802419:	48 c1 e8 15          	shr    $0x15,%rax
  80241d:	48 89 c2             	mov    %rax,%rdx
  802420:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802427:	01 00 00 
  80242a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242e:	83 e0 01             	and    $0x1,%eax
  802431:	48 85 c0             	test   %rax,%rax
  802434:	74 21                	je     802457 <fd_alloc+0x6a>
  802436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80243a:	48 c1 e8 0c          	shr    $0xc,%rax
  80243e:	48 89 c2             	mov    %rax,%rdx
  802441:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802448:	01 00 00 
  80244b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80244f:	83 e0 01             	and    $0x1,%eax
  802452:	48 85 c0             	test   %rax,%rax
  802455:	75 12                	jne    802469 <fd_alloc+0x7c>
			*fd_store = fd;
  802457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80245f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
  802467:	eb 1a                	jmp    802483 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802469:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80246d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802471:	7e 8f                	jle    802402 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802473:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802477:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80247e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802483:	c9                   	leaveq 
  802484:	c3                   	retq   

0000000000802485 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802485:	55                   	push   %rbp
  802486:	48 89 e5             	mov    %rsp,%rbp
  802489:	48 83 ec 20          	sub    $0x20,%rsp
  80248d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802490:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802494:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802498:	78 06                	js     8024a0 <fd_lookup+0x1b>
  80249a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80249e:	7e 07                	jle    8024a7 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024a5:	eb 6c                	jmp    802513 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8024a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024aa:	48 98                	cltq   
  8024ac:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024b2:	48 c1 e0 0c          	shl    $0xc,%rax
  8024b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8024ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024be:	48 c1 e8 15          	shr    $0x15,%rax
  8024c2:	48 89 c2             	mov    %rax,%rdx
  8024c5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024cc:	01 00 00 
  8024cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d3:	83 e0 01             	and    $0x1,%eax
  8024d6:	48 85 c0             	test   %rax,%rax
  8024d9:	74 21                	je     8024fc <fd_lookup+0x77>
  8024db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024df:	48 c1 e8 0c          	shr    $0xc,%rax
  8024e3:	48 89 c2             	mov    %rax,%rdx
  8024e6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024ed:	01 00 00 
  8024f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024f4:	83 e0 01             	and    $0x1,%eax
  8024f7:	48 85 c0             	test   %rax,%rax
  8024fa:	75 07                	jne    802503 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802501:	eb 10                	jmp    802513 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802503:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802507:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80250b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80250e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802513:	c9                   	leaveq 
  802514:	c3                   	retq   

0000000000802515 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802515:	55                   	push   %rbp
  802516:	48 89 e5             	mov    %rsp,%rbp
  802519:	48 83 ec 30          	sub    $0x30,%rsp
  80251d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802521:	89 f0                	mov    %esi,%eax
  802523:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802526:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80252a:	48 89 c7             	mov    %rax,%rdi
  80252d:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  802534:	00 00 00 
  802537:	ff d0                	callq  *%rax
  802539:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80253d:	48 89 d6             	mov    %rdx,%rsi
  802540:	89 c7                	mov    %eax,%edi
  802542:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802549:	00 00 00 
  80254c:	ff d0                	callq  *%rax
  80254e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802551:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802555:	78 0a                	js     802561 <fd_close+0x4c>
	    || fd != fd2)
  802557:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80255f:	74 12                	je     802573 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802561:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802565:	74 05                	je     80256c <fd_close+0x57>
  802567:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256a:	eb 05                	jmp    802571 <fd_close+0x5c>
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
  802571:	eb 69                	jmp    8025dc <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802573:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802577:	8b 00                	mov    (%rax),%eax
  802579:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80257d:	48 89 d6             	mov    %rdx,%rsi
  802580:	89 c7                	mov    %eax,%edi
  802582:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802589:	00 00 00 
  80258c:	ff d0                	callq  *%rax
  80258e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802591:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802595:	78 2a                	js     8025c1 <fd_close+0xac>
		if (dev->dev_close)
  802597:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80259f:	48 85 c0             	test   %rax,%rax
  8025a2:	74 16                	je     8025ba <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8025a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025ac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025b0:	48 89 d7             	mov    %rdx,%rdi
  8025b3:	ff d0                	callq  *%rax
  8025b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b8:	eb 07                	jmp    8025c1 <fd_close+0xac>
		else
			r = 0;
  8025ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8025c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025c5:	48 89 c6             	mov    %rax,%rsi
  8025c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8025cd:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  8025d4:	00 00 00 
  8025d7:	ff d0                	callq  *%rax
	return r;
  8025d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025dc:	c9                   	leaveq 
  8025dd:	c3                   	retq   

00000000008025de <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8025de:	55                   	push   %rbp
  8025df:	48 89 e5             	mov    %rsp,%rbp
  8025e2:	48 83 ec 20          	sub    $0x20,%rsp
  8025e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8025ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025f4:	eb 41                	jmp    802637 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8025f6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025fd:	00 00 00 
  802600:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802603:	48 63 d2             	movslq %edx,%rdx
  802606:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80260a:	8b 00                	mov    (%rax),%eax
  80260c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80260f:	75 22                	jne    802633 <dev_lookup+0x55>
			*dev = devtab[i];
  802611:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802618:	00 00 00 
  80261b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80261e:	48 63 d2             	movslq %edx,%rdx
  802621:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802625:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802629:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
  802631:	eb 60                	jmp    802693 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802633:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802637:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80263e:	00 00 00 
  802641:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802644:	48 63 d2             	movslq %edx,%rdx
  802647:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80264b:	48 85 c0             	test   %rax,%rax
  80264e:	75 a6                	jne    8025f6 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802650:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802657:	00 00 00 
  80265a:	48 8b 00             	mov    (%rax),%rax
  80265d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802663:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802666:	89 c6                	mov    %eax,%esi
  802668:	48 bf 18 47 80 00 00 	movabs $0x804718,%rdi
  80266f:	00 00 00 
  802672:	b8 00 00 00 00       	mov    $0x0,%eax
  802677:	48 b9 fa 07 80 00 00 	movabs $0x8007fa,%rcx
  80267e:	00 00 00 
  802681:	ff d1                	callq  *%rcx
	*dev = 0;
  802683:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802687:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80268e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802693:	c9                   	leaveq 
  802694:	c3                   	retq   

0000000000802695 <close>:

int
close(int fdnum)
{
  802695:	55                   	push   %rbp
  802696:	48 89 e5             	mov    %rsp,%rbp
  802699:	48 83 ec 20          	sub    $0x20,%rsp
  80269d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026a0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026a7:	48 89 d6             	mov    %rdx,%rsi
  8026aa:	89 c7                	mov    %eax,%edi
  8026ac:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  8026b3:	00 00 00 
  8026b6:	ff d0                	callq  *%rax
  8026b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026bf:	79 05                	jns    8026c6 <close+0x31>
		return r;
  8026c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c4:	eb 18                	jmp    8026de <close+0x49>
	else
		return fd_close(fd, 1);
  8026c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ca:	be 01 00 00 00       	mov    $0x1,%esi
  8026cf:	48 89 c7             	mov    %rax,%rdi
  8026d2:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  8026d9:	00 00 00 
  8026dc:	ff d0                	callq  *%rax
}
  8026de:	c9                   	leaveq 
  8026df:	c3                   	retq   

00000000008026e0 <close_all>:

void
close_all(void)
{
  8026e0:	55                   	push   %rbp
  8026e1:	48 89 e5             	mov    %rsp,%rbp
  8026e4:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8026e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026ef:	eb 15                	jmp    802706 <close_all+0x26>
		close(i);
  8026f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f4:	89 c7                	mov    %eax,%edi
  8026f6:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  8026fd:	00 00 00 
  802700:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802702:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802706:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80270a:	7e e5                	jle    8026f1 <close_all+0x11>
		close(i);
}
  80270c:	c9                   	leaveq 
  80270d:	c3                   	retq   

000000000080270e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80270e:	55                   	push   %rbp
  80270f:	48 89 e5             	mov    %rsp,%rbp
  802712:	48 83 ec 40          	sub    $0x40,%rsp
  802716:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802719:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80271c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802720:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802723:	48 89 d6             	mov    %rdx,%rsi
  802726:	89 c7                	mov    %eax,%edi
  802728:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  80272f:	00 00 00 
  802732:	ff d0                	callq  *%rax
  802734:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802737:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273b:	79 08                	jns    802745 <dup+0x37>
		return r;
  80273d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802740:	e9 70 01 00 00       	jmpq   8028b5 <dup+0x1a7>
	close(newfdnum);
  802745:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802748:	89 c7                	mov    %eax,%edi
  80274a:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  802751:	00 00 00 
  802754:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802756:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802759:	48 98                	cltq   
  80275b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802761:	48 c1 e0 0c          	shl    $0xc,%rax
  802765:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80276d:	48 89 c7             	mov    %rax,%rdi
  802770:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  802777:	00 00 00 
  80277a:	ff d0                	callq  *%rax
  80277c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802780:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802784:	48 89 c7             	mov    %rax,%rdi
  802787:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  80278e:	00 00 00 
  802791:	ff d0                	callq  *%rax
  802793:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279b:	48 c1 e8 15          	shr    $0x15,%rax
  80279f:	48 89 c2             	mov    %rax,%rdx
  8027a2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027a9:	01 00 00 
  8027ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027b0:	83 e0 01             	and    $0x1,%eax
  8027b3:	48 85 c0             	test   %rax,%rax
  8027b6:	74 73                	je     80282b <dup+0x11d>
  8027b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bc:	48 c1 e8 0c          	shr    $0xc,%rax
  8027c0:	48 89 c2             	mov    %rax,%rdx
  8027c3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027ca:	01 00 00 
  8027cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027d1:	83 e0 01             	and    $0x1,%eax
  8027d4:	48 85 c0             	test   %rax,%rax
  8027d7:	74 52                	je     80282b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8027d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027dd:	48 c1 e8 0c          	shr    $0xc,%rax
  8027e1:	48 89 c2             	mov    %rax,%rdx
  8027e4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027eb:	01 00 00 
  8027ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027f2:	25 07 0e 00 00       	and    $0xe07,%eax
  8027f7:	89 c1                	mov    %eax,%ecx
  8027f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802801:	41 89 c8             	mov    %ecx,%r8d
  802804:	48 89 d1             	mov    %rdx,%rcx
  802807:	ba 00 00 00 00       	mov    $0x0,%edx
  80280c:	48 89 c6             	mov    %rax,%rsi
  80280f:	bf 00 00 00 00       	mov    $0x0,%edi
  802814:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  80281b:	00 00 00 
  80281e:	ff d0                	callq  *%rax
  802820:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802823:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802827:	79 02                	jns    80282b <dup+0x11d>
			goto err;
  802829:	eb 57                	jmp    802882 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80282b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80282f:	48 c1 e8 0c          	shr    $0xc,%rax
  802833:	48 89 c2             	mov    %rax,%rdx
  802836:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80283d:	01 00 00 
  802840:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802844:	25 07 0e 00 00       	and    $0xe07,%eax
  802849:	89 c1                	mov    %eax,%ecx
  80284b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80284f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802853:	41 89 c8             	mov    %ecx,%r8d
  802856:	48 89 d1             	mov    %rdx,%rcx
  802859:	ba 00 00 00 00       	mov    $0x0,%edx
  80285e:	48 89 c6             	mov    %rax,%rsi
  802861:	bf 00 00 00 00       	mov    $0x0,%edi
  802866:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  80286d:	00 00 00 
  802870:	ff d0                	callq  *%rax
  802872:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802875:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802879:	79 02                	jns    80287d <dup+0x16f>
		goto err;
  80287b:	eb 05                	jmp    802882 <dup+0x174>

	return newfdnum;
  80287d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802880:	eb 33                	jmp    8028b5 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802882:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802886:	48 89 c6             	mov    %rax,%rsi
  802889:	bf 00 00 00 00       	mov    $0x0,%edi
  80288e:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  802895:	00 00 00 
  802898:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80289a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80289e:	48 89 c6             	mov    %rax,%rsi
  8028a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a6:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  8028ad:	00 00 00 
  8028b0:	ff d0                	callq  *%rax
	return r;
  8028b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028b5:	c9                   	leaveq 
  8028b6:	c3                   	retq   

00000000008028b7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8028b7:	55                   	push   %rbp
  8028b8:	48 89 e5             	mov    %rsp,%rbp
  8028bb:	48 83 ec 40          	sub    $0x40,%rsp
  8028bf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028c6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028ca:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028ce:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028d1:	48 89 d6             	mov    %rdx,%rsi
  8028d4:	89 c7                	mov    %eax,%edi
  8028d6:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  8028dd:	00 00 00 
  8028e0:	ff d0                	callq  *%rax
  8028e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e9:	78 24                	js     80290f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ef:	8b 00                	mov    (%rax),%eax
  8028f1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028f5:	48 89 d6             	mov    %rdx,%rsi
  8028f8:	89 c7                	mov    %eax,%edi
  8028fa:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802901:	00 00 00 
  802904:	ff d0                	callq  *%rax
  802906:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802909:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290d:	79 05                	jns    802914 <read+0x5d>
		return r;
  80290f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802912:	eb 76                	jmp    80298a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802918:	8b 40 08             	mov    0x8(%rax),%eax
  80291b:	83 e0 03             	and    $0x3,%eax
  80291e:	83 f8 01             	cmp    $0x1,%eax
  802921:	75 3a                	jne    80295d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802923:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80292a:	00 00 00 
  80292d:	48 8b 00             	mov    (%rax),%rax
  802930:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802936:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802939:	89 c6                	mov    %eax,%esi
  80293b:	48 bf 37 47 80 00 00 	movabs $0x804737,%rdi
  802942:	00 00 00 
  802945:	b8 00 00 00 00       	mov    $0x0,%eax
  80294a:	48 b9 fa 07 80 00 00 	movabs $0x8007fa,%rcx
  802951:	00 00 00 
  802954:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802956:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80295b:	eb 2d                	jmp    80298a <read+0xd3>
	}
	if (!dev->dev_read)
  80295d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802961:	48 8b 40 10          	mov    0x10(%rax),%rax
  802965:	48 85 c0             	test   %rax,%rax
  802968:	75 07                	jne    802971 <read+0xba>
		return -E_NOT_SUPP;
  80296a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80296f:	eb 19                	jmp    80298a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802971:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802975:	48 8b 40 10          	mov    0x10(%rax),%rax
  802979:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80297d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802981:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802985:	48 89 cf             	mov    %rcx,%rdi
  802988:	ff d0                	callq  *%rax
}
  80298a:	c9                   	leaveq 
  80298b:	c3                   	retq   

000000000080298c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80298c:	55                   	push   %rbp
  80298d:	48 89 e5             	mov    %rsp,%rbp
  802990:	48 83 ec 30          	sub    $0x30,%rsp
  802994:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802997:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80299b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80299f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029a6:	eb 49                	jmp    8029f1 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8029a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ab:	48 98                	cltq   
  8029ad:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029b1:	48 29 c2             	sub    %rax,%rdx
  8029b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b7:	48 63 c8             	movslq %eax,%rcx
  8029ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029be:	48 01 c1             	add    %rax,%rcx
  8029c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029c4:	48 89 ce             	mov    %rcx,%rsi
  8029c7:	89 c7                	mov    %eax,%edi
  8029c9:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  8029d0:	00 00 00 
  8029d3:	ff d0                	callq  *%rax
  8029d5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8029d8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029dc:	79 05                	jns    8029e3 <readn+0x57>
			return m;
  8029de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029e1:	eb 1c                	jmp    8029ff <readn+0x73>
		if (m == 0)
  8029e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029e7:	75 02                	jne    8029eb <readn+0x5f>
			break;
  8029e9:	eb 11                	jmp    8029fc <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029ee:	01 45 fc             	add    %eax,-0x4(%rbp)
  8029f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f4:	48 98                	cltq   
  8029f6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029fa:	72 ac                	jb     8029a8 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8029fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029ff:	c9                   	leaveq 
  802a00:	c3                   	retq   

0000000000802a01 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a01:	55                   	push   %rbp
  802a02:	48 89 e5             	mov    %rsp,%rbp
  802a05:	48 83 ec 40          	sub    $0x40,%rsp
  802a09:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a0c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a10:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a14:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a18:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a1b:	48 89 d6             	mov    %rdx,%rsi
  802a1e:	89 c7                	mov    %eax,%edi
  802a20:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802a27:	00 00 00 
  802a2a:	ff d0                	callq  *%rax
  802a2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a33:	78 24                	js     802a59 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a39:	8b 00                	mov    (%rax),%eax
  802a3b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a3f:	48 89 d6             	mov    %rdx,%rsi
  802a42:	89 c7                	mov    %eax,%edi
  802a44:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802a4b:	00 00 00 
  802a4e:	ff d0                	callq  *%rax
  802a50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a57:	79 05                	jns    802a5e <write+0x5d>
		return r;
  802a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5c:	eb 75                	jmp    802ad3 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a62:	8b 40 08             	mov    0x8(%rax),%eax
  802a65:	83 e0 03             	and    $0x3,%eax
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	75 3a                	jne    802aa6 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a6c:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802a73:	00 00 00 
  802a76:	48 8b 00             	mov    (%rax),%rax
  802a79:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a7f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a82:	89 c6                	mov    %eax,%esi
  802a84:	48 bf 53 47 80 00 00 	movabs $0x804753,%rdi
  802a8b:	00 00 00 
  802a8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a93:	48 b9 fa 07 80 00 00 	movabs $0x8007fa,%rcx
  802a9a:	00 00 00 
  802a9d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aa4:	eb 2d                	jmp    802ad3 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802aa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aaa:	48 8b 40 18          	mov    0x18(%rax),%rax
  802aae:	48 85 c0             	test   %rax,%rax
  802ab1:	75 07                	jne    802aba <write+0xb9>
		return -E_NOT_SUPP;
  802ab3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ab8:	eb 19                	jmp    802ad3 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802aba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abe:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ac2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ac6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802aca:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802ace:	48 89 cf             	mov    %rcx,%rdi
  802ad1:	ff d0                	callq  *%rax
}
  802ad3:	c9                   	leaveq 
  802ad4:	c3                   	retq   

0000000000802ad5 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ad5:	55                   	push   %rbp
  802ad6:	48 89 e5             	mov    %rsp,%rbp
  802ad9:	48 83 ec 18          	sub    $0x18,%rsp
  802add:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ae0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ae3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ae7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aea:	48 89 d6             	mov    %rdx,%rsi
  802aed:	89 c7                	mov    %eax,%edi
  802aef:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802af6:	00 00 00 
  802af9:	ff d0                	callq  *%rax
  802afb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b02:	79 05                	jns    802b09 <seek+0x34>
		return r;
  802b04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b07:	eb 0f                	jmp    802b18 <seek+0x43>
	fd->fd_offset = offset;
  802b09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b10:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b18:	c9                   	leaveq 
  802b19:	c3                   	retq   

0000000000802b1a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b1a:	55                   	push   %rbp
  802b1b:	48 89 e5             	mov    %rsp,%rbp
  802b1e:	48 83 ec 30          	sub    $0x30,%rsp
  802b22:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b25:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b28:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b2c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b2f:	48 89 d6             	mov    %rdx,%rsi
  802b32:	89 c7                	mov    %eax,%edi
  802b34:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802b3b:	00 00 00 
  802b3e:	ff d0                	callq  *%rax
  802b40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b47:	78 24                	js     802b6d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4d:	8b 00                	mov    (%rax),%eax
  802b4f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b53:	48 89 d6             	mov    %rdx,%rsi
  802b56:	89 c7                	mov    %eax,%edi
  802b58:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802b5f:	00 00 00 
  802b62:	ff d0                	callq  *%rax
  802b64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6b:	79 05                	jns    802b72 <ftruncate+0x58>
		return r;
  802b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b70:	eb 72                	jmp    802be4 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b76:	8b 40 08             	mov    0x8(%rax),%eax
  802b79:	83 e0 03             	and    $0x3,%eax
  802b7c:	85 c0                	test   %eax,%eax
  802b7e:	75 3a                	jne    802bba <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b80:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802b87:	00 00 00 
  802b8a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b8d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b93:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b96:	89 c6                	mov    %eax,%esi
  802b98:	48 bf 70 47 80 00 00 	movabs $0x804770,%rdi
  802b9f:	00 00 00 
  802ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba7:	48 b9 fa 07 80 00 00 	movabs $0x8007fa,%rcx
  802bae:	00 00 00 
  802bb1:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802bb3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bb8:	eb 2a                	jmp    802be4 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802bba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbe:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bc2:	48 85 c0             	test   %rax,%rax
  802bc5:	75 07                	jne    802bce <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802bc7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bcc:	eb 16                	jmp    802be4 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802bce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd2:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bd6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bda:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802bdd:	89 ce                	mov    %ecx,%esi
  802bdf:	48 89 d7             	mov    %rdx,%rdi
  802be2:	ff d0                	callq  *%rax
}
  802be4:	c9                   	leaveq 
  802be5:	c3                   	retq   

0000000000802be6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802be6:	55                   	push   %rbp
  802be7:	48 89 e5             	mov    %rsp,%rbp
  802bea:	48 83 ec 30          	sub    $0x30,%rsp
  802bee:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bf1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bf5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bf9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bfc:	48 89 d6             	mov    %rdx,%rsi
  802bff:	89 c7                	mov    %eax,%edi
  802c01:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802c08:	00 00 00 
  802c0b:	ff d0                	callq  *%rax
  802c0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c14:	78 24                	js     802c3a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1a:	8b 00                	mov    (%rax),%eax
  802c1c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c20:	48 89 d6             	mov    %rdx,%rsi
  802c23:	89 c7                	mov    %eax,%edi
  802c25:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802c2c:	00 00 00 
  802c2f:	ff d0                	callq  *%rax
  802c31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c38:	79 05                	jns    802c3f <fstat+0x59>
		return r;
  802c3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3d:	eb 5e                	jmp    802c9d <fstat+0xb7>
	if (!dev->dev_stat)
  802c3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c43:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c47:	48 85 c0             	test   %rax,%rax
  802c4a:	75 07                	jne    802c53 <fstat+0x6d>
		return -E_NOT_SUPP;
  802c4c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c51:	eb 4a                	jmp    802c9d <fstat+0xb7>
	stat->st_name[0] = 0;
  802c53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c57:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c5a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c5e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c65:	00 00 00 
	stat->st_isdir = 0;
  802c68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c6c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c73:	00 00 00 
	stat->st_dev = dev;
  802c76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c7e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c89:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c8d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c91:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c95:	48 89 ce             	mov    %rcx,%rsi
  802c98:	48 89 d7             	mov    %rdx,%rdi
  802c9b:	ff d0                	callq  *%rax
}
  802c9d:	c9                   	leaveq 
  802c9e:	c3                   	retq   

0000000000802c9f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c9f:	55                   	push   %rbp
  802ca0:	48 89 e5             	mov    %rsp,%rbp
  802ca3:	48 83 ec 20          	sub    $0x20,%rsp
  802ca7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802caf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb3:	be 00 00 00 00       	mov    $0x0,%esi
  802cb8:	48 89 c7             	mov    %rax,%rdi
  802cbb:	48 b8 8d 2d 80 00 00 	movabs $0x802d8d,%rax
  802cc2:	00 00 00 
  802cc5:	ff d0                	callq  *%rax
  802cc7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cce:	79 05                	jns    802cd5 <stat+0x36>
		return fd;
  802cd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd3:	eb 2f                	jmp    802d04 <stat+0x65>
	r = fstat(fd, stat);
  802cd5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdc:	48 89 d6             	mov    %rdx,%rsi
  802cdf:	89 c7                	mov    %eax,%edi
  802ce1:	48 b8 e6 2b 80 00 00 	movabs $0x802be6,%rax
  802ce8:	00 00 00 
  802ceb:	ff d0                	callq  *%rax
  802ced:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802cf0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf3:	89 c7                	mov    %eax,%edi
  802cf5:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  802cfc:	00 00 00 
  802cff:	ff d0                	callq  *%rax
	return r;
  802d01:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d04:	c9                   	leaveq 
  802d05:	c3                   	retq   

0000000000802d06 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d06:	55                   	push   %rbp
  802d07:	48 89 e5             	mov    %rsp,%rbp
  802d0a:	48 83 ec 10          	sub    $0x10,%rsp
  802d0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d15:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d1c:	00 00 00 
  802d1f:	8b 00                	mov    (%rax),%eax
  802d21:	85 c0                	test   %eax,%eax
  802d23:	75 1d                	jne    802d42 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d25:	bf 01 00 00 00       	mov    $0x1,%edi
  802d2a:	48 b8 35 40 80 00 00 	movabs $0x804035,%rax
  802d31:	00 00 00 
  802d34:	ff d0                	callq  *%rax
  802d36:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802d3d:	00 00 00 
  802d40:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802d42:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d49:	00 00 00 
  802d4c:	8b 00                	mov    (%rax),%eax
  802d4e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d51:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d56:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802d5d:	00 00 00 
  802d60:	89 c7                	mov    %eax,%edi
  802d62:	48 b8 36 3f 80 00 00 	movabs $0x803f36,%rax
  802d69:	00 00 00 
  802d6c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d72:	ba 00 00 00 00       	mov    $0x0,%edx
  802d77:	48 89 c6             	mov    %rax,%rsi
  802d7a:	bf 00 00 00 00       	mov    $0x0,%edi
  802d7f:	48 b8 83 3e 80 00 00 	movabs $0x803e83,%rax
  802d86:	00 00 00 
  802d89:	ff d0                	callq  *%rax
}
  802d8b:	c9                   	leaveq 
  802d8c:	c3                   	retq   

0000000000802d8d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d8d:	55                   	push   %rbp
  802d8e:	48 89 e5             	mov    %rsp,%rbp
  802d91:	48 83 ec 20          	sub    $0x20,%rsp
  802d95:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d99:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  802d9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da0:	48 89 c7             	mov    %rax,%rdi
  802da3:	48 b8 84 13 80 00 00 	movabs $0x801384,%rax
  802daa:	00 00 00 
  802dad:	ff d0                	callq  *%rax
  802daf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802db4:	7e 0a                	jle    802dc0 <open+0x33>
		return -E_BAD_PATH;
  802db6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802dbb:	e9 a5 00 00 00       	jmpq   802e65 <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  802dc0:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802dc4:	48 89 c7             	mov    %rax,%rdi
  802dc7:	48 b8 ed 23 80 00 00 	movabs $0x8023ed,%rax
  802dce:	00 00 00 
  802dd1:	ff d0                	callq  *%rax
  802dd3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dda:	79 08                	jns    802de4 <open+0x57>
		return ret;
  802ddc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ddf:	e9 81 00 00 00       	jmpq   802e65 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802de4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802deb:	00 00 00 
  802dee:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802df1:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  802df7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dfb:	48 89 c6             	mov    %rax,%rsi
  802dfe:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e05:	00 00 00 
  802e08:	48 b8 f0 13 80 00 00 	movabs $0x8013f0,%rax
  802e0f:	00 00 00 
  802e12:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  802e14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e18:	48 89 c6             	mov    %rax,%rsi
  802e1b:	bf 01 00 00 00       	mov    $0x1,%edi
  802e20:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  802e27:	00 00 00 
  802e2a:	ff d0                	callq  *%rax
  802e2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e33:	79 1d                	jns    802e52 <open+0xc5>
	{
		fd_close(fd,0);
  802e35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e39:	be 00 00 00 00       	mov    $0x0,%esi
  802e3e:	48 89 c7             	mov    %rax,%rdi
  802e41:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  802e48:	00 00 00 
  802e4b:	ff d0                	callq  *%rax
		return ret;
  802e4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e50:	eb 13                	jmp    802e65 <open+0xd8>
	}
	return fd2num (fd);
  802e52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e56:	48 89 c7             	mov    %rax,%rdi
  802e59:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  802e60:	00 00 00 
  802e63:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  802e65:	c9                   	leaveq 
  802e66:	c3                   	retq   

0000000000802e67 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e67:	55                   	push   %rbp
  802e68:	48 89 e5             	mov    %rsp,%rbp
  802e6b:	48 83 ec 10          	sub    $0x10,%rsp
  802e6f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e77:	8b 50 0c             	mov    0xc(%rax),%edx
  802e7a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e81:	00 00 00 
  802e84:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e86:	be 00 00 00 00       	mov    $0x0,%esi
  802e8b:	bf 06 00 00 00       	mov    $0x6,%edi
  802e90:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  802e97:	00 00 00 
  802e9a:	ff d0                	callq  *%rax
}
  802e9c:	c9                   	leaveq 
  802e9d:	c3                   	retq   

0000000000802e9e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e9e:	55                   	push   %rbp
  802e9f:	48 89 e5             	mov    %rsp,%rbp
  802ea2:	48 83 ec 30          	sub    $0x30,%rsp
  802ea6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802eaa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802eae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  802eb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb6:	8b 50 0c             	mov    0xc(%rax),%edx
  802eb9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ec0:	00 00 00 
  802ec3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  802ec5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ecc:	00 00 00 
  802ecf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ed3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  802ed7:	be 00 00 00 00       	mov    $0x0,%esi
  802edc:	bf 03 00 00 00       	mov    $0x3,%edi
  802ee1:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  802ee8:	00 00 00 
  802eeb:	ff d0                	callq  *%rax
  802eed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef4:	79 05                	jns    802efb <devfile_read+0x5d>
		return ret;
  802ef6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef9:	eb 26                	jmp    802f21 <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  802efb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802efe:	48 63 d0             	movslq %eax,%rdx
  802f01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f05:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f0c:	00 00 00 
  802f0f:	48 89 c7             	mov    %rax,%rdi
  802f12:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  802f19:	00 00 00 
  802f1c:	ff d0                	callq  *%rax
	return ret;
  802f1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  802f21:	c9                   	leaveq 
  802f22:	c3                   	retq   

0000000000802f23 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f23:	55                   	push   %rbp
  802f24:	48 89 e5             	mov    %rsp,%rbp
  802f27:	48 83 ec 30          	sub    $0x30,%rsp
  802f2b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f2f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f33:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  802f37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f3b:	8b 50 0c             	mov    0xc(%rax),%edx
  802f3e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f45:	00 00 00 
  802f48:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  802f4a:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  802f4f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802f56:	00 
  802f57:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802f5c:	48 89 c2             	mov    %rax,%rdx
  802f5f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f66:	00 00 00 
  802f69:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  802f6d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f74:	00 00 00 
  802f77:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802f7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f7f:	48 89 c6             	mov    %rax,%rsi
  802f82:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802f89:	00 00 00 
  802f8c:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  802f93:	00 00 00 
  802f96:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  802f98:	be 00 00 00 00       	mov    $0x0,%esi
  802f9d:	bf 04 00 00 00       	mov    $0x4,%edi
  802fa2:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  802fa9:	00 00 00 
  802fac:	ff d0                	callq  *%rax
  802fae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb5:	79 05                	jns    802fbc <devfile_write+0x99>
		return ret;
  802fb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fba:	eb 03                	jmp    802fbf <devfile_write+0x9c>
	
	return ret;
  802fbc:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  802fbf:	c9                   	leaveq 
  802fc0:	c3                   	retq   

0000000000802fc1 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802fc1:	55                   	push   %rbp
  802fc2:	48 89 e5             	mov    %rsp,%rbp
  802fc5:	48 83 ec 20          	sub    $0x20,%rsp
  802fc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802fd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd5:	8b 50 0c             	mov    0xc(%rax),%edx
  802fd8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fdf:	00 00 00 
  802fe2:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802fe4:	be 00 00 00 00       	mov    $0x0,%esi
  802fe9:	bf 05 00 00 00       	mov    $0x5,%edi
  802fee:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  802ff5:	00 00 00 
  802ff8:	ff d0                	callq  *%rax
  802ffa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803001:	79 05                	jns    803008 <devfile_stat+0x47>
		return r;
  803003:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803006:	eb 56                	jmp    80305e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803008:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80300c:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803013:	00 00 00 
  803016:	48 89 c7             	mov    %rax,%rdi
  803019:	48 b8 f0 13 80 00 00 	movabs $0x8013f0,%rax
  803020:	00 00 00 
  803023:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803025:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80302c:	00 00 00 
  80302f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803035:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803039:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80303f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803046:	00 00 00 
  803049:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80304f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803053:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803059:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80305e:	c9                   	leaveq 
  80305f:	c3                   	retq   

0000000000803060 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803060:	55                   	push   %rbp
  803061:	48 89 e5             	mov    %rsp,%rbp
  803064:	48 83 ec 10          	sub    $0x10,%rsp
  803068:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80306c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80306f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803073:	8b 50 0c             	mov    0xc(%rax),%edx
  803076:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80307d:	00 00 00 
  803080:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803082:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803089:	00 00 00 
  80308c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80308f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803092:	be 00 00 00 00       	mov    $0x0,%esi
  803097:	bf 02 00 00 00       	mov    $0x2,%edi
  80309c:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  8030a3:	00 00 00 
  8030a6:	ff d0                	callq  *%rax
}
  8030a8:	c9                   	leaveq 
  8030a9:	c3                   	retq   

00000000008030aa <remove>:

// Delete a file
int
remove(const char *path)
{
  8030aa:	55                   	push   %rbp
  8030ab:	48 89 e5             	mov    %rsp,%rbp
  8030ae:	48 83 ec 10          	sub    $0x10,%rsp
  8030b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8030b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ba:	48 89 c7             	mov    %rax,%rdi
  8030bd:	48 b8 84 13 80 00 00 	movabs $0x801384,%rax
  8030c4:	00 00 00 
  8030c7:	ff d0                	callq  *%rax
  8030c9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8030ce:	7e 07                	jle    8030d7 <remove+0x2d>
		return -E_BAD_PATH;
  8030d0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030d5:	eb 33                	jmp    80310a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8030d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030db:	48 89 c6             	mov    %rax,%rsi
  8030de:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8030e5:	00 00 00 
  8030e8:	48 b8 f0 13 80 00 00 	movabs $0x8013f0,%rax
  8030ef:	00 00 00 
  8030f2:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8030f4:	be 00 00 00 00       	mov    $0x0,%esi
  8030f9:	bf 07 00 00 00       	mov    $0x7,%edi
  8030fe:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax
}
  80310a:	c9                   	leaveq 
  80310b:	c3                   	retq   

000000000080310c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80310c:	55                   	push   %rbp
  80310d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803110:	be 00 00 00 00       	mov    $0x0,%esi
  803115:	bf 08 00 00 00       	mov    $0x8,%edi
  80311a:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  803121:	00 00 00 
  803124:	ff d0                	callq  *%rax
}
  803126:	5d                   	pop    %rbp
  803127:	c3                   	retq   

0000000000803128 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803128:	55                   	push   %rbp
  803129:	48 89 e5             	mov    %rsp,%rbp
  80312c:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803133:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80313a:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803141:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803148:	be 00 00 00 00       	mov    $0x0,%esi
  80314d:	48 89 c7             	mov    %rax,%rdi
  803150:	48 b8 8d 2d 80 00 00 	movabs $0x802d8d,%rax
  803157:	00 00 00 
  80315a:	ff d0                	callq  *%rax
  80315c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80315f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803163:	79 28                	jns    80318d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803168:	89 c6                	mov    %eax,%esi
  80316a:	48 bf 96 47 80 00 00 	movabs $0x804796,%rdi
  803171:	00 00 00 
  803174:	b8 00 00 00 00       	mov    $0x0,%eax
  803179:	48 ba fa 07 80 00 00 	movabs $0x8007fa,%rdx
  803180:	00 00 00 
  803183:	ff d2                	callq  *%rdx
		return fd_src;
  803185:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803188:	e9 74 01 00 00       	jmpq   803301 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80318d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803194:	be 01 01 00 00       	mov    $0x101,%esi
  803199:	48 89 c7             	mov    %rax,%rdi
  80319c:	48 b8 8d 2d 80 00 00 	movabs $0x802d8d,%rax
  8031a3:	00 00 00 
  8031a6:	ff d0                	callq  *%rax
  8031a8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8031ab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8031af:	79 39                	jns    8031ea <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8031b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031b4:	89 c6                	mov    %eax,%esi
  8031b6:	48 bf ac 47 80 00 00 	movabs $0x8047ac,%rdi
  8031bd:	00 00 00 
  8031c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c5:	48 ba fa 07 80 00 00 	movabs $0x8007fa,%rdx
  8031cc:	00 00 00 
  8031cf:	ff d2                	callq  *%rdx
		close(fd_src);
  8031d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d4:	89 c7                	mov    %eax,%edi
  8031d6:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  8031dd:	00 00 00 
  8031e0:	ff d0                	callq  *%rax
		return fd_dest;
  8031e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031e5:	e9 17 01 00 00       	jmpq   803301 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031ea:	eb 74                	jmp    803260 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8031ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031ef:	48 63 d0             	movslq %eax,%rdx
  8031f2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031fc:	48 89 ce             	mov    %rcx,%rsi
  8031ff:	89 c7                	mov    %eax,%edi
  803201:	48 b8 01 2a 80 00 00 	movabs $0x802a01,%rax
  803208:	00 00 00 
  80320b:	ff d0                	callq  *%rax
  80320d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803210:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803214:	79 4a                	jns    803260 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803216:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803219:	89 c6                	mov    %eax,%esi
  80321b:	48 bf c6 47 80 00 00 	movabs $0x8047c6,%rdi
  803222:	00 00 00 
  803225:	b8 00 00 00 00       	mov    $0x0,%eax
  80322a:	48 ba fa 07 80 00 00 	movabs $0x8007fa,%rdx
  803231:	00 00 00 
  803234:	ff d2                	callq  *%rdx
			close(fd_src);
  803236:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803239:	89 c7                	mov    %eax,%edi
  80323b:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  803242:	00 00 00 
  803245:	ff d0                	callq  *%rax
			close(fd_dest);
  803247:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80324a:	89 c7                	mov    %eax,%edi
  80324c:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  803253:	00 00 00 
  803256:	ff d0                	callq  *%rax
			return write_size;
  803258:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80325b:	e9 a1 00 00 00       	jmpq   803301 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803260:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326a:	ba 00 02 00 00       	mov    $0x200,%edx
  80326f:	48 89 ce             	mov    %rcx,%rsi
  803272:	89 c7                	mov    %eax,%edi
  803274:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  80327b:	00 00 00 
  80327e:	ff d0                	callq  *%rax
  803280:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803283:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803287:	0f 8f 5f ff ff ff    	jg     8031ec <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80328d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803291:	79 47                	jns    8032da <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803293:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803296:	89 c6                	mov    %eax,%esi
  803298:	48 bf d9 47 80 00 00 	movabs $0x8047d9,%rdi
  80329f:	00 00 00 
  8032a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a7:	48 ba fa 07 80 00 00 	movabs $0x8007fa,%rdx
  8032ae:	00 00 00 
  8032b1:	ff d2                	callq  *%rdx
		close(fd_src);
  8032b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b6:	89 c7                	mov    %eax,%edi
  8032b8:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  8032bf:	00 00 00 
  8032c2:	ff d0                	callq  *%rax
		close(fd_dest);
  8032c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032c7:	89 c7                	mov    %eax,%edi
  8032c9:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  8032d0:	00 00 00 
  8032d3:	ff d0                	callq  *%rax
		return read_size;
  8032d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032d8:	eb 27                	jmp    803301 <copy+0x1d9>
	}
	close(fd_src);
  8032da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032dd:	89 c7                	mov    %eax,%edi
  8032df:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  8032e6:	00 00 00 
  8032e9:	ff d0                	callq  *%rax
	close(fd_dest);
  8032eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032ee:	89 c7                	mov    %eax,%edi
  8032f0:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  8032f7:	00 00 00 
  8032fa:	ff d0                	callq  *%rax
	return 0;
  8032fc:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803301:	c9                   	leaveq 
  803302:	c3                   	retq   

0000000000803303 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  803303:	55                   	push   %rbp
  803304:	48 89 e5             	mov    %rsp,%rbp
  803307:	48 83 ec 20          	sub    $0x20,%rsp
  80330b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  80330f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803313:	8b 40 0c             	mov    0xc(%rax),%eax
  803316:	85 c0                	test   %eax,%eax
  803318:	7e 67                	jle    803381 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80331a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80331e:	8b 40 04             	mov    0x4(%rax),%eax
  803321:	48 63 d0             	movslq %eax,%rdx
  803324:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803328:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80332c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803330:	8b 00                	mov    (%rax),%eax
  803332:	48 89 ce             	mov    %rcx,%rsi
  803335:	89 c7                	mov    %eax,%edi
  803337:	48 b8 01 2a 80 00 00 	movabs $0x802a01,%rax
  80333e:	00 00 00 
  803341:	ff d0                	callq  *%rax
  803343:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  803346:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80334a:	7e 13                	jle    80335f <writebuf+0x5c>
			b->result += result;
  80334c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803350:	8b 50 08             	mov    0x8(%rax),%edx
  803353:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803356:	01 c2                	add    %eax,%edx
  803358:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80335c:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  80335f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803363:	8b 40 04             	mov    0x4(%rax),%eax
  803366:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803369:	74 16                	je     803381 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  80336b:	b8 00 00 00 00       	mov    $0x0,%eax
  803370:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803374:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  803378:	89 c2                	mov    %eax,%edx
  80337a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80337e:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  803381:	c9                   	leaveq 
  803382:	c3                   	retq   

0000000000803383 <putch>:

static void
putch(int ch, void *thunk)
{
  803383:	55                   	push   %rbp
  803384:	48 89 e5             	mov    %rsp,%rbp
  803387:	48 83 ec 20          	sub    $0x20,%rsp
  80338b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80338e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  803392:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803396:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  80339a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80339e:	8b 40 04             	mov    0x4(%rax),%eax
  8033a1:	8d 48 01             	lea    0x1(%rax),%ecx
  8033a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033a8:	89 4a 04             	mov    %ecx,0x4(%rdx)
  8033ab:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033ae:	89 d1                	mov    %edx,%ecx
  8033b0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033b4:	48 98                	cltq   
  8033b6:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  8033ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033be:	8b 40 04             	mov    0x4(%rax),%eax
  8033c1:	3d 00 01 00 00       	cmp    $0x100,%eax
  8033c6:	75 1e                	jne    8033e6 <putch+0x63>
		writebuf(b);
  8033c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033cc:	48 89 c7             	mov    %rax,%rdi
  8033cf:	48 b8 03 33 80 00 00 	movabs $0x803303,%rax
  8033d6:	00 00 00 
  8033d9:	ff d0                	callq  *%rax
		b->idx = 0;
  8033db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  8033e6:	c9                   	leaveq 
  8033e7:	c3                   	retq   

00000000008033e8 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8033e8:	55                   	push   %rbp
  8033e9:	48 89 e5             	mov    %rsp,%rbp
  8033ec:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  8033f3:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  8033f9:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  803400:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  803407:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  80340d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  803413:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80341a:	00 00 00 
	b.result = 0;
  80341d:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  803424:	00 00 00 
	b.error = 1;
  803427:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  80342e:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  803431:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  803438:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  80343f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803446:	48 89 c6             	mov    %rax,%rsi
  803449:	48 bf 83 33 80 00 00 	movabs $0x803383,%rdi
  803450:	00 00 00 
  803453:	48 b8 ad 0b 80 00 00 	movabs $0x800bad,%rax
  80345a:	00 00 00 
  80345d:	ff d0                	callq  *%rax
	if (b.idx > 0)
  80345f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  803465:	85 c0                	test   %eax,%eax
  803467:	7e 16                	jle    80347f <vfprintf+0x97>
		writebuf(&b);
  803469:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803470:	48 89 c7             	mov    %rax,%rdi
  803473:	48 b8 03 33 80 00 00 	movabs $0x803303,%rax
  80347a:	00 00 00 
  80347d:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  80347f:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803485:	85 c0                	test   %eax,%eax
  803487:	74 08                	je     803491 <vfprintf+0xa9>
  803489:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80348f:	eb 06                	jmp    803497 <vfprintf+0xaf>
  803491:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803497:	c9                   	leaveq 
  803498:	c3                   	retq   

0000000000803499 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803499:	55                   	push   %rbp
  80349a:	48 89 e5             	mov    %rsp,%rbp
  80349d:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8034a4:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  8034aa:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8034b1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8034b8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8034bf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8034c6:	84 c0                	test   %al,%al
  8034c8:	74 20                	je     8034ea <fprintf+0x51>
  8034ca:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8034ce:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8034d2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8034d6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8034da:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8034de:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8034e2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8034e6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8034ea:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8034f1:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  8034f8:	00 00 00 
  8034fb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803502:	00 00 00 
  803505:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803509:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803510:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803517:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  80351e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803525:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  80352c:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803532:	48 89 ce             	mov    %rcx,%rsi
  803535:	89 c7                	mov    %eax,%edi
  803537:	48 b8 e8 33 80 00 00 	movabs $0x8033e8,%rax
  80353e:	00 00 00 
  803541:	ff d0                	callq  *%rax
  803543:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803549:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80354f:	c9                   	leaveq 
  803550:	c3                   	retq   

0000000000803551 <printf>:

int
printf(const char *fmt, ...)
{
  803551:	55                   	push   %rbp
  803552:	48 89 e5             	mov    %rsp,%rbp
  803555:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80355c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803563:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80356a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803571:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803578:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80357f:	84 c0                	test   %al,%al
  803581:	74 20                	je     8035a3 <printf+0x52>
  803583:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803587:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80358b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80358f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803593:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803597:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80359b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80359f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8035a3:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8035aa:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8035b1:	00 00 00 
  8035b4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8035bb:	00 00 00 
  8035be:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8035c2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8035c9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8035d0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  8035d7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8035de:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8035e5:	48 89 c6             	mov    %rax,%rsi
  8035e8:	bf 01 00 00 00       	mov    $0x1,%edi
  8035ed:	48 b8 e8 33 80 00 00 	movabs $0x8033e8,%rax
  8035f4:	00 00 00 
  8035f7:	ff d0                	callq  *%rax
  8035f9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8035ff:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803605:	c9                   	leaveq 
  803606:	c3                   	retq   

0000000000803607 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803607:	55                   	push   %rbp
  803608:	48 89 e5             	mov    %rsp,%rbp
  80360b:	53                   	push   %rbx
  80360c:	48 83 ec 38          	sub    $0x38,%rsp
  803610:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803614:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803618:	48 89 c7             	mov    %rax,%rdi
  80361b:	48 b8 ed 23 80 00 00 	movabs $0x8023ed,%rax
  803622:	00 00 00 
  803625:	ff d0                	callq  *%rax
  803627:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80362a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80362e:	0f 88 bf 01 00 00    	js     8037f3 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803634:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803638:	ba 07 04 00 00       	mov    $0x407,%edx
  80363d:	48 89 c6             	mov    %rax,%rsi
  803640:	bf 00 00 00 00       	mov    $0x0,%edi
  803645:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  80364c:	00 00 00 
  80364f:	ff d0                	callq  *%rax
  803651:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803654:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803658:	0f 88 95 01 00 00    	js     8037f3 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80365e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803662:	48 89 c7             	mov    %rax,%rdi
  803665:	48 b8 ed 23 80 00 00 	movabs $0x8023ed,%rax
  80366c:	00 00 00 
  80366f:	ff d0                	callq  *%rax
  803671:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803674:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803678:	0f 88 5d 01 00 00    	js     8037db <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80367e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803682:	ba 07 04 00 00       	mov    $0x407,%edx
  803687:	48 89 c6             	mov    %rax,%rsi
  80368a:	bf 00 00 00 00       	mov    $0x0,%edi
  80368f:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  803696:	00 00 00 
  803699:	ff d0                	callq  *%rax
  80369b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80369e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036a2:	0f 88 33 01 00 00    	js     8037db <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8036a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ac:	48 89 c7             	mov    %rax,%rdi
  8036af:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  8036b6:	00 00 00 
  8036b9:	ff d0                	callq  *%rax
  8036bb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036c3:	ba 07 04 00 00       	mov    $0x407,%edx
  8036c8:	48 89 c6             	mov    %rax,%rsi
  8036cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8036d0:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  8036d7:	00 00 00 
  8036da:	ff d0                	callq  *%rax
  8036dc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036df:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036e3:	79 05                	jns    8036ea <pipe+0xe3>
		goto err2;
  8036e5:	e9 d9 00 00 00       	jmpq   8037c3 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ee:	48 89 c7             	mov    %rax,%rdi
  8036f1:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  8036f8:	00 00 00 
  8036fb:	ff d0                	callq  *%rax
  8036fd:	48 89 c2             	mov    %rax,%rdx
  803700:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803704:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80370a:	48 89 d1             	mov    %rdx,%rcx
  80370d:	ba 00 00 00 00       	mov    $0x0,%edx
  803712:	48 89 c6             	mov    %rax,%rsi
  803715:	bf 00 00 00 00       	mov    $0x0,%edi
  80371a:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  803721:	00 00 00 
  803724:	ff d0                	callq  *%rax
  803726:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803729:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80372d:	79 1b                	jns    80374a <pipe+0x143>
		goto err3;
  80372f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803730:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803734:	48 89 c6             	mov    %rax,%rsi
  803737:	bf 00 00 00 00       	mov    $0x0,%edi
  80373c:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  803743:	00 00 00 
  803746:	ff d0                	callq  *%rax
  803748:	eb 79                	jmp    8037c3 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80374a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80374e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803755:	00 00 00 
  803758:	8b 12                	mov    (%rdx),%edx
  80375a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80375c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803760:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803767:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80376b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803772:	00 00 00 
  803775:	8b 12                	mov    (%rdx),%edx
  803777:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803779:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80377d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803788:	48 89 c7             	mov    %rax,%rdi
  80378b:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  803792:	00 00 00 
  803795:	ff d0                	callq  *%rax
  803797:	89 c2                	mov    %eax,%edx
  803799:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80379d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80379f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037a3:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8037a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ab:	48 89 c7             	mov    %rax,%rdi
  8037ae:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  8037b5:	00 00 00 
  8037b8:	ff d0                	callq  *%rax
  8037ba:	89 03                	mov    %eax,(%rbx)
	return 0;
  8037bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c1:	eb 33                	jmp    8037f6 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8037c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037c7:	48 89 c6             	mov    %rax,%rsi
  8037ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8037cf:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  8037d6:	00 00 00 
  8037d9:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8037db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037df:	48 89 c6             	mov    %rax,%rsi
  8037e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e7:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  8037ee:	00 00 00 
  8037f1:	ff d0                	callq  *%rax
err:
	return r;
  8037f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8037f6:	48 83 c4 38          	add    $0x38,%rsp
  8037fa:	5b                   	pop    %rbx
  8037fb:	5d                   	pop    %rbp
  8037fc:	c3                   	retq   

00000000008037fd <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8037fd:	55                   	push   %rbp
  8037fe:	48 89 e5             	mov    %rsp,%rbp
  803801:	53                   	push   %rbx
  803802:	48 83 ec 28          	sub    $0x28,%rsp
  803806:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80380a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80380e:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803815:	00 00 00 
  803818:	48 8b 00             	mov    (%rax),%rax
  80381b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803821:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803824:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803828:	48 89 c7             	mov    %rax,%rdi
  80382b:	48 b8 a7 40 80 00 00 	movabs $0x8040a7,%rax
  803832:	00 00 00 
  803835:	ff d0                	callq  *%rax
  803837:	89 c3                	mov    %eax,%ebx
  803839:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80383d:	48 89 c7             	mov    %rax,%rdi
  803840:	48 b8 a7 40 80 00 00 	movabs $0x8040a7,%rax
  803847:	00 00 00 
  80384a:	ff d0                	callq  *%rax
  80384c:	39 c3                	cmp    %eax,%ebx
  80384e:	0f 94 c0             	sete   %al
  803851:	0f b6 c0             	movzbl %al,%eax
  803854:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803857:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80385e:	00 00 00 
  803861:	48 8b 00             	mov    (%rax),%rax
  803864:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80386a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80386d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803870:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803873:	75 05                	jne    80387a <_pipeisclosed+0x7d>
			return ret;
  803875:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803878:	eb 4f                	jmp    8038c9 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80387a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80387d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803880:	74 42                	je     8038c4 <_pipeisclosed+0xc7>
  803882:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803886:	75 3c                	jne    8038c4 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803888:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80388f:	00 00 00 
  803892:	48 8b 00             	mov    (%rax),%rax
  803895:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80389b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80389e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038a1:	89 c6                	mov    %eax,%esi
  8038a3:	48 bf f9 47 80 00 00 	movabs $0x8047f9,%rdi
  8038aa:	00 00 00 
  8038ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b2:	49 b8 fa 07 80 00 00 	movabs $0x8007fa,%r8
  8038b9:	00 00 00 
  8038bc:	41 ff d0             	callq  *%r8
	}
  8038bf:	e9 4a ff ff ff       	jmpq   80380e <_pipeisclosed+0x11>
  8038c4:	e9 45 ff ff ff       	jmpq   80380e <_pipeisclosed+0x11>
}
  8038c9:	48 83 c4 28          	add    $0x28,%rsp
  8038cd:	5b                   	pop    %rbx
  8038ce:	5d                   	pop    %rbp
  8038cf:	c3                   	retq   

00000000008038d0 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8038d0:	55                   	push   %rbp
  8038d1:	48 89 e5             	mov    %rsp,%rbp
  8038d4:	48 83 ec 30          	sub    $0x30,%rsp
  8038d8:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038db:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038df:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038e2:	48 89 d6             	mov    %rdx,%rsi
  8038e5:	89 c7                	mov    %eax,%edi
  8038e7:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  8038ee:	00 00 00 
  8038f1:	ff d0                	callq  *%rax
  8038f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038fa:	79 05                	jns    803901 <pipeisclosed+0x31>
		return r;
  8038fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ff:	eb 31                	jmp    803932 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803901:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803905:	48 89 c7             	mov    %rax,%rdi
  803908:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  80390f:	00 00 00 
  803912:	ff d0                	callq  *%rax
  803914:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803918:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80391c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803920:	48 89 d6             	mov    %rdx,%rsi
  803923:	48 89 c7             	mov    %rax,%rdi
  803926:	48 b8 fd 37 80 00 00 	movabs $0x8037fd,%rax
  80392d:	00 00 00 
  803930:	ff d0                	callq  *%rax
}
  803932:	c9                   	leaveq 
  803933:	c3                   	retq   

0000000000803934 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803934:	55                   	push   %rbp
  803935:	48 89 e5             	mov    %rsp,%rbp
  803938:	48 83 ec 40          	sub    $0x40,%rsp
  80393c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803940:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803944:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803948:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80394c:	48 89 c7             	mov    %rax,%rdi
  80394f:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  803956:	00 00 00 
  803959:	ff d0                	callq  *%rax
  80395b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80395f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803963:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803967:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80396e:	00 
  80396f:	e9 92 00 00 00       	jmpq   803a06 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803974:	eb 41                	jmp    8039b7 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803976:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80397b:	74 09                	je     803986 <devpipe_read+0x52>
				return i;
  80397d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803981:	e9 92 00 00 00       	jmpq   803a18 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803986:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80398a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80398e:	48 89 d6             	mov    %rdx,%rsi
  803991:	48 89 c7             	mov    %rax,%rdi
  803994:	48 b8 fd 37 80 00 00 	movabs $0x8037fd,%rax
  80399b:	00 00 00 
  80399e:	ff d0                	callq  *%rax
  8039a0:	85 c0                	test   %eax,%eax
  8039a2:	74 07                	je     8039ab <devpipe_read+0x77>
				return 0;
  8039a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a9:	eb 6d                	jmp    803a18 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8039ab:	48 b8 e1 1c 80 00 00 	movabs $0x801ce1,%rax
  8039b2:	00 00 00 
  8039b5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8039b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039bb:	8b 10                	mov    (%rax),%edx
  8039bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c1:	8b 40 04             	mov    0x4(%rax),%eax
  8039c4:	39 c2                	cmp    %eax,%edx
  8039c6:	74 ae                	je     803976 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8039c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039d0:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8039d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d8:	8b 00                	mov    (%rax),%eax
  8039da:	99                   	cltd   
  8039db:	c1 ea 1b             	shr    $0x1b,%edx
  8039de:	01 d0                	add    %edx,%eax
  8039e0:	83 e0 1f             	and    $0x1f,%eax
  8039e3:	29 d0                	sub    %edx,%eax
  8039e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039e9:	48 98                	cltq   
  8039eb:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8039f0:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8039f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f6:	8b 00                	mov    (%rax),%eax
  8039f8:	8d 50 01             	lea    0x1(%rax),%edx
  8039fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ff:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a01:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a0a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a0e:	0f 82 60 ff ff ff    	jb     803974 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a18:	c9                   	leaveq 
  803a19:	c3                   	retq   

0000000000803a1a <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a1a:	55                   	push   %rbp
  803a1b:	48 89 e5             	mov    %rsp,%rbp
  803a1e:	48 83 ec 40          	sub    $0x40,%rsp
  803a22:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a26:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a2a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a32:	48 89 c7             	mov    %rax,%rdi
  803a35:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  803a3c:	00 00 00 
  803a3f:	ff d0                	callq  *%rax
  803a41:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a45:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a49:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a4d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a54:	00 
  803a55:	e9 8e 00 00 00       	jmpq   803ae8 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a5a:	eb 31                	jmp    803a8d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a5c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a64:	48 89 d6             	mov    %rdx,%rsi
  803a67:	48 89 c7             	mov    %rax,%rdi
  803a6a:	48 b8 fd 37 80 00 00 	movabs $0x8037fd,%rax
  803a71:	00 00 00 
  803a74:	ff d0                	callq  *%rax
  803a76:	85 c0                	test   %eax,%eax
  803a78:	74 07                	je     803a81 <devpipe_write+0x67>
				return 0;
  803a7a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a7f:	eb 79                	jmp    803afa <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a81:	48 b8 e1 1c 80 00 00 	movabs $0x801ce1,%rax
  803a88:	00 00 00 
  803a8b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a91:	8b 40 04             	mov    0x4(%rax),%eax
  803a94:	48 63 d0             	movslq %eax,%rdx
  803a97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a9b:	8b 00                	mov    (%rax),%eax
  803a9d:	48 98                	cltq   
  803a9f:	48 83 c0 20          	add    $0x20,%rax
  803aa3:	48 39 c2             	cmp    %rax,%rdx
  803aa6:	73 b4                	jae    803a5c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803aa8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aac:	8b 40 04             	mov    0x4(%rax),%eax
  803aaf:	99                   	cltd   
  803ab0:	c1 ea 1b             	shr    $0x1b,%edx
  803ab3:	01 d0                	add    %edx,%eax
  803ab5:	83 e0 1f             	and    $0x1f,%eax
  803ab8:	29 d0                	sub    %edx,%eax
  803aba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803abe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803ac2:	48 01 ca             	add    %rcx,%rdx
  803ac5:	0f b6 0a             	movzbl (%rdx),%ecx
  803ac8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803acc:	48 98                	cltq   
  803ace:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ad2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad6:	8b 40 04             	mov    0x4(%rax),%eax
  803ad9:	8d 50 01             	lea    0x1(%rax),%edx
  803adc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ae0:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ae3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ae8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aec:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803af0:	0f 82 64 ff ff ff    	jb     803a5a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803af6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803afa:	c9                   	leaveq 
  803afb:	c3                   	retq   

0000000000803afc <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803afc:	55                   	push   %rbp
  803afd:	48 89 e5             	mov    %rsp,%rbp
  803b00:	48 83 ec 20          	sub    $0x20,%rsp
  803b04:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b10:	48 89 c7             	mov    %rax,%rdi
  803b13:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  803b1a:	00 00 00 
  803b1d:	ff d0                	callq  *%rax
  803b1f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b27:	48 be 0c 48 80 00 00 	movabs $0x80480c,%rsi
  803b2e:	00 00 00 
  803b31:	48 89 c7             	mov    %rax,%rdi
  803b34:	48 b8 f0 13 80 00 00 	movabs $0x8013f0,%rax
  803b3b:	00 00 00 
  803b3e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b44:	8b 50 04             	mov    0x4(%rax),%edx
  803b47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b4b:	8b 00                	mov    (%rax),%eax
  803b4d:	29 c2                	sub    %eax,%edx
  803b4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b53:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b59:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b5d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b64:	00 00 00 
	stat->st_dev = &devpipe;
  803b67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b6b:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803b72:	00 00 00 
  803b75:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b81:	c9                   	leaveq 
  803b82:	c3                   	retq   

0000000000803b83 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b83:	55                   	push   %rbp
  803b84:	48 89 e5             	mov    %rsp,%rbp
  803b87:	48 83 ec 10          	sub    $0x10,%rsp
  803b8b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b93:	48 89 c6             	mov    %rax,%rsi
  803b96:	bf 00 00 00 00       	mov    $0x0,%edi
  803b9b:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  803ba2:	00 00 00 
  803ba5:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803ba7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bab:	48 89 c7             	mov    %rax,%rdi
  803bae:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  803bb5:	00 00 00 
  803bb8:	ff d0                	callq  *%rax
  803bba:	48 89 c6             	mov    %rax,%rsi
  803bbd:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc2:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  803bc9:	00 00 00 
  803bcc:	ff d0                	callq  *%rax
}
  803bce:	c9                   	leaveq 
  803bcf:	c3                   	retq   

0000000000803bd0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803bd0:	55                   	push   %rbp
  803bd1:	48 89 e5             	mov    %rsp,%rbp
  803bd4:	48 83 ec 20          	sub    $0x20,%rsp
  803bd8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803bdb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bde:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803be1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803be5:	be 01 00 00 00       	mov    $0x1,%esi
  803bea:	48 89 c7             	mov    %rax,%rdi
  803bed:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  803bf4:	00 00 00 
  803bf7:	ff d0                	callq  *%rax
}
  803bf9:	c9                   	leaveq 
  803bfa:	c3                   	retq   

0000000000803bfb <getchar>:

int
getchar(void)
{
  803bfb:	55                   	push   %rbp
  803bfc:	48 89 e5             	mov    %rsp,%rbp
  803bff:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c03:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c07:	ba 01 00 00 00       	mov    $0x1,%edx
  803c0c:	48 89 c6             	mov    %rax,%rsi
  803c0f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c14:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  803c1b:	00 00 00 
  803c1e:	ff d0                	callq  *%rax
  803c20:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c27:	79 05                	jns    803c2e <getchar+0x33>
		return r;
  803c29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c2c:	eb 14                	jmp    803c42 <getchar+0x47>
	if (r < 1)
  803c2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c32:	7f 07                	jg     803c3b <getchar+0x40>
		return -E_EOF;
  803c34:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c39:	eb 07                	jmp    803c42 <getchar+0x47>
	return c;
  803c3b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c3f:	0f b6 c0             	movzbl %al,%eax
}
  803c42:	c9                   	leaveq 
  803c43:	c3                   	retq   

0000000000803c44 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c44:	55                   	push   %rbp
  803c45:	48 89 e5             	mov    %rsp,%rbp
  803c48:	48 83 ec 20          	sub    $0x20,%rsp
  803c4c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c4f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c53:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c56:	48 89 d6             	mov    %rdx,%rsi
  803c59:	89 c7                	mov    %eax,%edi
  803c5b:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  803c62:	00 00 00 
  803c65:	ff d0                	callq  *%rax
  803c67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c6e:	79 05                	jns    803c75 <iscons+0x31>
		return r;
  803c70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c73:	eb 1a                	jmp    803c8f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c79:	8b 10                	mov    (%rax),%edx
  803c7b:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803c82:	00 00 00 
  803c85:	8b 00                	mov    (%rax),%eax
  803c87:	39 c2                	cmp    %eax,%edx
  803c89:	0f 94 c0             	sete   %al
  803c8c:	0f b6 c0             	movzbl %al,%eax
}
  803c8f:	c9                   	leaveq 
  803c90:	c3                   	retq   

0000000000803c91 <opencons>:

int
opencons(void)
{
  803c91:	55                   	push   %rbp
  803c92:	48 89 e5             	mov    %rsp,%rbp
  803c95:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c99:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c9d:	48 89 c7             	mov    %rax,%rdi
  803ca0:	48 b8 ed 23 80 00 00 	movabs $0x8023ed,%rax
  803ca7:	00 00 00 
  803caa:	ff d0                	callq  *%rax
  803cac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803caf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb3:	79 05                	jns    803cba <opencons+0x29>
		return r;
  803cb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb8:	eb 5b                	jmp    803d15 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803cba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cbe:	ba 07 04 00 00       	mov    $0x407,%edx
  803cc3:	48 89 c6             	mov    %rax,%rsi
  803cc6:	bf 00 00 00 00       	mov    $0x0,%edi
  803ccb:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  803cd2:	00 00 00 
  803cd5:	ff d0                	callq  *%rax
  803cd7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cde:	79 05                	jns    803ce5 <opencons+0x54>
		return r;
  803ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce3:	eb 30                	jmp    803d15 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803ce5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce9:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803cf0:	00 00 00 
  803cf3:	8b 12                	mov    (%rdx),%edx
  803cf5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803cf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d06:	48 89 c7             	mov    %rax,%rdi
  803d09:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  803d10:	00 00 00 
  803d13:	ff d0                	callq  *%rax
}
  803d15:	c9                   	leaveq 
  803d16:	c3                   	retq   

0000000000803d17 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d17:	55                   	push   %rbp
  803d18:	48 89 e5             	mov    %rsp,%rbp
  803d1b:	48 83 ec 30          	sub    $0x30,%rsp
  803d1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d27:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d2b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d30:	75 07                	jne    803d39 <devcons_read+0x22>
		return 0;
  803d32:	b8 00 00 00 00       	mov    $0x0,%eax
  803d37:	eb 4b                	jmp    803d84 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803d39:	eb 0c                	jmp    803d47 <devcons_read+0x30>
		sys_yield();
  803d3b:	48 b8 e1 1c 80 00 00 	movabs $0x801ce1,%rax
  803d42:	00 00 00 
  803d45:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803d47:	48 b8 21 1c 80 00 00 	movabs $0x801c21,%rax
  803d4e:	00 00 00 
  803d51:	ff d0                	callq  *%rax
  803d53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d5a:	74 df                	je     803d3b <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803d5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d60:	79 05                	jns    803d67 <devcons_read+0x50>
		return c;
  803d62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d65:	eb 1d                	jmp    803d84 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803d67:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d6b:	75 07                	jne    803d74 <devcons_read+0x5d>
		return 0;
  803d6d:	b8 00 00 00 00       	mov    $0x0,%eax
  803d72:	eb 10                	jmp    803d84 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803d74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d77:	89 c2                	mov    %eax,%edx
  803d79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d7d:	88 10                	mov    %dl,(%rax)
	return 1;
  803d7f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d84:	c9                   	leaveq 
  803d85:	c3                   	retq   

0000000000803d86 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d86:	55                   	push   %rbp
  803d87:	48 89 e5             	mov    %rsp,%rbp
  803d8a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d91:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d98:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d9f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803da6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803dad:	eb 76                	jmp    803e25 <devcons_write+0x9f>
		m = n - tot;
  803daf:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803db6:	89 c2                	mov    %eax,%edx
  803db8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbb:	29 c2                	sub    %eax,%edx
  803dbd:	89 d0                	mov    %edx,%eax
  803dbf:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803dc2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dc5:	83 f8 7f             	cmp    $0x7f,%eax
  803dc8:	76 07                	jbe    803dd1 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803dca:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803dd1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dd4:	48 63 d0             	movslq %eax,%rdx
  803dd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dda:	48 63 c8             	movslq %eax,%rcx
  803ddd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803de4:	48 01 c1             	add    %rax,%rcx
  803de7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803dee:	48 89 ce             	mov    %rcx,%rsi
  803df1:	48 89 c7             	mov    %rax,%rdi
  803df4:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  803dfb:	00 00 00 
  803dfe:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e00:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e03:	48 63 d0             	movslq %eax,%rdx
  803e06:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e0d:	48 89 d6             	mov    %rdx,%rsi
  803e10:	48 89 c7             	mov    %rax,%rdi
  803e13:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  803e1a:	00 00 00 
  803e1d:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e22:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e28:	48 98                	cltq   
  803e2a:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e31:	0f 82 78 ff ff ff    	jb     803daf <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e37:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e3a:	c9                   	leaveq 
  803e3b:	c3                   	retq   

0000000000803e3c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e3c:	55                   	push   %rbp
  803e3d:	48 89 e5             	mov    %rsp,%rbp
  803e40:	48 83 ec 08          	sub    $0x8,%rsp
  803e44:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e4d:	c9                   	leaveq 
  803e4e:	c3                   	retq   

0000000000803e4f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e4f:	55                   	push   %rbp
  803e50:	48 89 e5             	mov    %rsp,%rbp
  803e53:	48 83 ec 10          	sub    $0x10,%rsp
  803e57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e63:	48 be 18 48 80 00 00 	movabs $0x804818,%rsi
  803e6a:	00 00 00 
  803e6d:	48 89 c7             	mov    %rax,%rdi
  803e70:	48 b8 f0 13 80 00 00 	movabs $0x8013f0,%rax
  803e77:	00 00 00 
  803e7a:	ff d0                	callq  *%rax
	return 0;
  803e7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e81:	c9                   	leaveq 
  803e82:	c3                   	retq   

0000000000803e83 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e83:	55                   	push   %rbp
  803e84:	48 89 e5             	mov    %rsp,%rbp
  803e87:	48 83 ec 30          	sub    $0x30,%rsp
  803e8b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e93:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  803e97:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e9c:	75 08                	jne    803ea6 <ipc_recv+0x23>
  803e9e:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  803ea5:	ff 
	int res=sys_ipc_recv(pg);
  803ea6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eaa:	48 89 c7             	mov    %rax,%rdi
  803ead:	48 b8 93 1f 80 00 00 	movabs $0x801f93,%rax
  803eb4:	00 00 00 
  803eb7:	ff d0                	callq  *%rax
  803eb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  803ebc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ec1:	74 26                	je     803ee9 <ipc_recv+0x66>
  803ec3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ec7:	75 15                	jne    803ede <ipc_recv+0x5b>
  803ec9:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803ed0:	00 00 00 
  803ed3:	48 8b 00             	mov    (%rax),%rax
  803ed6:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803edc:	eb 05                	jmp    803ee3 <ipc_recv+0x60>
  803ede:	b8 00 00 00 00       	mov    $0x0,%eax
  803ee3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ee7:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  803ee9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803eee:	74 26                	je     803f16 <ipc_recv+0x93>
  803ef0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ef4:	75 15                	jne    803f0b <ipc_recv+0x88>
  803ef6:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803efd:	00 00 00 
  803f00:	48 8b 00             	mov    (%rax),%rax
  803f03:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803f09:	eb 05                	jmp    803f10 <ipc_recv+0x8d>
  803f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  803f10:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803f14:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  803f16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f1a:	75 15                	jne    803f31 <ipc_recv+0xae>
  803f1c:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803f23:	00 00 00 
  803f26:	48 8b 00             	mov    (%rax),%rax
  803f29:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803f2f:	eb 03                	jmp    803f34 <ipc_recv+0xb1>
  803f31:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  803f34:	c9                   	leaveq 
  803f35:	c3                   	retq   

0000000000803f36 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f36:	55                   	push   %rbp
  803f37:	48 89 e5             	mov    %rsp,%rbp
  803f3a:	48 83 ec 30          	sub    $0x30,%rsp
  803f3e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f41:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f44:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f48:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  803f4b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f50:	75 0a                	jne    803f5c <ipc_send+0x26>
  803f52:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  803f59:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  803f5a:	eb 3e                	jmp    803f9a <ipc_send+0x64>
  803f5c:	eb 3c                	jmp    803f9a <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  803f5e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f62:	74 2a                	je     803f8e <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  803f64:	48 ba 20 48 80 00 00 	movabs $0x804820,%rdx
  803f6b:	00 00 00 
  803f6e:	be 39 00 00 00       	mov    $0x39,%esi
  803f73:	48 bf 4b 48 80 00 00 	movabs $0x80484b,%rdi
  803f7a:	00 00 00 
  803f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  803f82:	48 b9 c1 05 80 00 00 	movabs $0x8005c1,%rcx
  803f89:	00 00 00 
  803f8c:	ff d1                	callq  *%rcx
		sys_yield();  
  803f8e:	48 b8 e1 1c 80 00 00 	movabs $0x801ce1,%rax
  803f95:	00 00 00 
  803f98:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  803f9a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f9d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803fa0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803fa4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fa7:	89 c7                	mov    %eax,%edi
  803fa9:	48 b8 3e 1f 80 00 00 	movabs $0x801f3e,%rax
  803fb0:	00 00 00 
  803fb3:	ff d0                	callq  *%rax
  803fb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fbc:	78 a0                	js     803f5e <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  803fbe:	c9                   	leaveq 
  803fbf:	c3                   	retq   

0000000000803fc0 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803fc0:	55                   	push   %rbp
  803fc1:	48 89 e5             	mov    %rsp,%rbp
  803fc4:	48 83 ec 10          	sub    $0x10,%rsp
  803fc8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  803fcc:	48 ba 58 48 80 00 00 	movabs $0x804858,%rdx
  803fd3:	00 00 00 
  803fd6:	be 47 00 00 00       	mov    $0x47,%esi
  803fdb:	48 bf 4b 48 80 00 00 	movabs $0x80484b,%rdi
  803fe2:	00 00 00 
  803fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  803fea:	48 b9 c1 05 80 00 00 	movabs $0x8005c1,%rcx
  803ff1:	00 00 00 
  803ff4:	ff d1                	callq  *%rcx

0000000000803ff6 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ff6:	55                   	push   %rbp
  803ff7:	48 89 e5             	mov    %rsp,%rbp
  803ffa:	48 83 ec 20          	sub    $0x20,%rsp
  803ffe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804001:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804004:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  804008:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  80400b:	48 ba 80 48 80 00 00 	movabs $0x804880,%rdx
  804012:	00 00 00 
  804015:	be 50 00 00 00       	mov    $0x50,%esi
  80401a:	48 bf 4b 48 80 00 00 	movabs $0x80484b,%rdi
  804021:	00 00 00 
  804024:	b8 00 00 00 00       	mov    $0x0,%eax
  804029:	48 b9 c1 05 80 00 00 	movabs $0x8005c1,%rcx
  804030:	00 00 00 
  804033:	ff d1                	callq  *%rcx

0000000000804035 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804035:	55                   	push   %rbp
  804036:	48 89 e5             	mov    %rsp,%rbp
  804039:	48 83 ec 14          	sub    $0x14,%rsp
  80403d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804047:	eb 4e                	jmp    804097 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804049:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804050:	00 00 00 
  804053:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804056:	48 98                	cltq   
  804058:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  80405f:	48 01 d0             	add    %rdx,%rax
  804062:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804068:	8b 00                	mov    (%rax),%eax
  80406a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80406d:	75 24                	jne    804093 <ipc_find_env+0x5e>
			return envs[i].env_id;
  80406f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804076:	00 00 00 
  804079:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80407c:	48 98                	cltq   
  80407e:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  804085:	48 01 d0             	add    %rdx,%rax
  804088:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80408e:	8b 40 08             	mov    0x8(%rax),%eax
  804091:	eb 12                	jmp    8040a5 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804093:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804097:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80409e:	7e a9                	jle    804049 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  8040a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040a5:	c9                   	leaveq 
  8040a6:	c3                   	retq   

00000000008040a7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8040a7:	55                   	push   %rbp
  8040a8:	48 89 e5             	mov    %rsp,%rbp
  8040ab:	48 83 ec 18          	sub    $0x18,%rsp
  8040af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8040b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040b7:	48 c1 e8 15          	shr    $0x15,%rax
  8040bb:	48 89 c2             	mov    %rax,%rdx
  8040be:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8040c5:	01 00 00 
  8040c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040cc:	83 e0 01             	and    $0x1,%eax
  8040cf:	48 85 c0             	test   %rax,%rax
  8040d2:	75 07                	jne    8040db <pageref+0x34>
		return 0;
  8040d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8040d9:	eb 53                	jmp    80412e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8040db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040df:	48 c1 e8 0c          	shr    $0xc,%rax
  8040e3:	48 89 c2             	mov    %rax,%rdx
  8040e6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040ed:	01 00 00 
  8040f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8040f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040fc:	83 e0 01             	and    $0x1,%eax
  8040ff:	48 85 c0             	test   %rax,%rax
  804102:	75 07                	jne    80410b <pageref+0x64>
		return 0;
  804104:	b8 00 00 00 00       	mov    $0x0,%eax
  804109:	eb 23                	jmp    80412e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80410b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80410f:	48 c1 e8 0c          	shr    $0xc,%rax
  804113:	48 89 c2             	mov    %rax,%rdx
  804116:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80411d:	00 00 00 
  804120:	48 c1 e2 04          	shl    $0x4,%rdx
  804124:	48 01 d0             	add    %rdx,%rax
  804127:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80412b:	0f b7 c0             	movzwl %ax,%eax
}
  80412e:	c9                   	leaveq 
  80412f:	c3                   	retq   
