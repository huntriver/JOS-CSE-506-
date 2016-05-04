
vmm/guest/obj/user/echo:     file format elf64-x86-64


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
  80003c:	e8 11 01 00 00       	callq  800152 <libmain>
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
	int i, nflag;

	nflag = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800059:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80005d:	7e 38                	jle    800097 <umain+0x54>
  80005f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800063:	48 83 c0 08          	add    $0x8,%rax
  800067:	48 8b 00             	mov    (%rax),%rax
  80006a:	48 be 80 37 80 00 00 	movabs $0x803780,%rsi
  800071:	00 00 00 
  800074:	48 89 c7             	mov    %rax,%rdi
  800077:	48 b8 c6 03 80 00 00 	movabs $0x8003c6,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
  800083:	85 c0                	test   %eax,%eax
  800085:	75 10                	jne    800097 <umain+0x54>
		nflag = 1;
  800087:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
		argc--;
  80008e:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
		argv++;
  800092:	48 83 45 e0 08       	addq   $0x8,-0x20(%rbp)
	}
	for (i = 1; i < argc; i++) {
  800097:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  80009e:	eb 7e                	jmp    80011e <umain+0xdb>
		if (i > 1)
  8000a0:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  8000a4:	7e 20                	jle    8000c6 <umain+0x83>
			write(1, " ", 1);
  8000a6:	ba 01 00 00 00       	mov    $0x1,%edx
  8000ab:	48 be 83 37 80 00 00 	movabs $0x803783,%rsi
  8000b2:	00 00 00 
  8000b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ba:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
		write(1, argv[i], strlen(argv[i]));
  8000c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c9:	48 98                	cltq   
  8000cb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8000d2:	00 
  8000d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d7:	48 01 d0             	add    %rdx,%rax
  8000da:	48 8b 00             	mov    (%rax),%rax
  8000dd:	48 89 c7             	mov    %rax,%rdi
  8000e0:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
  8000ec:	48 63 d0             	movslq %eax,%rdx
  8000ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000f2:	48 98                	cltq   
  8000f4:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8000fb:	00 
  8000fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800100:	48 01 c8             	add    %rcx,%rax
  800103:	48 8b 00             	mov    (%rax),%rax
  800106:	48 89 c6             	mov    %rax,%rsi
  800109:	bf 01 00 00 00       	mov    $0x1,%edi
  80010e:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80011a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800121:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800124:	0f 8c 76 ff ff ff    	jl     8000a0 <umain+0x5d>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  80012a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80012e:	75 20                	jne    800150 <umain+0x10d>
		write(1, "\n", 1);
  800130:	ba 01 00 00 00       	mov    $0x1,%edx
  800135:	48 be 85 37 80 00 00 	movabs $0x803785,%rsi
  80013c:	00 00 00 
  80013f:	bf 01 00 00 00       	mov    $0x1,%edi
  800144:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
}
  800150:	c9                   	leaveq 
  800151:	c3                   	retq   

0000000000800152 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800152:	55                   	push   %rbp
  800153:	48 89 e5             	mov    %rsp,%rbp
  800156:	48 83 ec 10          	sub    $0x10,%rsp
  80015a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80015d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  800161:	48 b8 17 0b 80 00 00 	movabs $0x800b17,%rax
  800168:	00 00 00 
  80016b:	ff d0                	callq  *%rax
  80016d:	48 98                	cltq   
  80016f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800174:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  80017b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800182:	00 00 00 
  800185:	48 01 c2             	add    %rax,%rdx
  800188:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80018f:	00 00 00 
  800192:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800195:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800199:	7e 14                	jle    8001af <libmain+0x5d>
		binaryname = argv[0];
  80019b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80019f:	48 8b 10             	mov    (%rax),%rdx
  8001a2:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001a9:	00 00 00 
  8001ac:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001b6:	48 89 d6             	mov    %rdx,%rsi
  8001b9:	89 c7                	mov    %eax,%edi
  8001bb:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001c2:	00 00 00 
  8001c5:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001c7:	48 b8 d5 01 80 00 00 	movabs $0x8001d5,%rax
  8001ce:	00 00 00 
  8001d1:	ff d0                	callq  *%rax
}
  8001d3:	c9                   	leaveq 
  8001d4:	c3                   	retq   

00000000008001d5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d5:	55                   	push   %rbp
  8001d6:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8001d9:	48 b8 6f 12 80 00 00 	movabs $0x80126f,%rax
  8001e0:	00 00 00 
  8001e3:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8001e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ea:	48 b8 d3 0a 80 00 00 	movabs $0x800ad3,%rax
  8001f1:	00 00 00 
  8001f4:	ff d0                	callq  *%rax
}
  8001f6:	5d                   	pop    %rbp
  8001f7:	c3                   	retq   

00000000008001f8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8001f8:	55                   	push   %rbp
  8001f9:	48 89 e5             	mov    %rsp,%rbp
  8001fc:	48 83 ec 18          	sub    $0x18,%rsp
  800200:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800204:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80020b:	eb 09                	jmp    800216 <strlen+0x1e>
		n++;
  80020d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800211:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80021a:	0f b6 00             	movzbl (%rax),%eax
  80021d:	84 c0                	test   %al,%al
  80021f:	75 ec                	jne    80020d <strlen+0x15>
		n++;
	return n;
  800221:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800224:	c9                   	leaveq 
  800225:	c3                   	retq   

0000000000800226 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800226:	55                   	push   %rbp
  800227:	48 89 e5             	mov    %rsp,%rbp
  80022a:	48 83 ec 20          	sub    $0x20,%rsp
  80022e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800232:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800236:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80023d:	eb 0e                	jmp    80024d <strnlen+0x27>
		n++;
  80023f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800243:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800248:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80024d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800252:	74 0b                	je     80025f <strnlen+0x39>
  800254:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800258:	0f b6 00             	movzbl (%rax),%eax
  80025b:	84 c0                	test   %al,%al
  80025d:	75 e0                	jne    80023f <strnlen+0x19>
		n++;
	return n;
  80025f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800262:	c9                   	leaveq 
  800263:	c3                   	retq   

0000000000800264 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800264:	55                   	push   %rbp
  800265:	48 89 e5             	mov    %rsp,%rbp
  800268:	48 83 ec 20          	sub    $0x20,%rsp
  80026c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800270:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800274:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800278:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80027c:	90                   	nop
  80027d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800281:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800285:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800289:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80028d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800291:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800295:	0f b6 12             	movzbl (%rdx),%edx
  800298:	88 10                	mov    %dl,(%rax)
  80029a:	0f b6 00             	movzbl (%rax),%eax
  80029d:	84 c0                	test   %al,%al
  80029f:	75 dc                	jne    80027d <strcpy+0x19>
		/* do nothing */;
	return ret;
  8002a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8002a5:	c9                   	leaveq 
  8002a6:	c3                   	retq   

00000000008002a7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8002a7:	55                   	push   %rbp
  8002a8:	48 89 e5             	mov    %rsp,%rbp
  8002ab:	48 83 ec 20          	sub    $0x20,%rsp
  8002af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8002b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8002b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002bb:	48 89 c7             	mov    %rax,%rdi
  8002be:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  8002c5:	00 00 00 
  8002c8:	ff d0                	callq  *%rax
  8002ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8002cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002d0:	48 63 d0             	movslq %eax,%rdx
  8002d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002d7:	48 01 c2             	add    %rax,%rdx
  8002da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002de:	48 89 c6             	mov    %rax,%rsi
  8002e1:	48 89 d7             	mov    %rdx,%rdi
  8002e4:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  8002eb:	00 00 00 
  8002ee:	ff d0                	callq  *%rax
	return dst;
  8002f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8002f4:	c9                   	leaveq 
  8002f5:	c3                   	retq   

00000000008002f6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8002f6:	55                   	push   %rbp
  8002f7:	48 89 e5             	mov    %rsp,%rbp
  8002fa:	48 83 ec 28          	sub    $0x28,%rsp
  8002fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800302:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800306:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80030a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80030e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800312:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800319:	00 
  80031a:	eb 2a                	jmp    800346 <strncpy+0x50>
		*dst++ = *src;
  80031c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800320:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800324:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800328:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80032c:	0f b6 12             	movzbl (%rdx),%edx
  80032f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800331:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800335:	0f b6 00             	movzbl (%rax),%eax
  800338:	84 c0                	test   %al,%al
  80033a:	74 05                	je     800341 <strncpy+0x4b>
			src++;
  80033c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800341:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800346:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80034a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80034e:	72 cc                	jb     80031c <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800350:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800354:	c9                   	leaveq 
  800355:	c3                   	retq   

0000000000800356 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800356:	55                   	push   %rbp
  800357:	48 89 e5             	mov    %rsp,%rbp
  80035a:	48 83 ec 28          	sub    $0x28,%rsp
  80035e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800362:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800366:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80036a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80036e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800372:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800377:	74 3d                	je     8003b6 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800379:	eb 1d                	jmp    800398 <strlcpy+0x42>
			*dst++ = *src++;
  80037b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80037f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800383:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800387:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80038b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80038f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800393:	0f b6 12             	movzbl (%rdx),%edx
  800396:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800398:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80039d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8003a2:	74 0b                	je     8003af <strlcpy+0x59>
  8003a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8003a8:	0f b6 00             	movzbl (%rax),%eax
  8003ab:	84 c0                	test   %al,%al
  8003ad:	75 cc                	jne    80037b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8003af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003b3:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8003b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003be:	48 29 c2             	sub    %rax,%rdx
  8003c1:	48 89 d0             	mov    %rdx,%rax
}
  8003c4:	c9                   	leaveq 
  8003c5:	c3                   	retq   

00000000008003c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8003c6:	55                   	push   %rbp
  8003c7:	48 89 e5             	mov    %rsp,%rbp
  8003ca:	48 83 ec 10          	sub    $0x10,%rsp
  8003ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8003d6:	eb 0a                	jmp    8003e2 <strcmp+0x1c>
		p++, q++;
  8003d8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8003dd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8003e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003e6:	0f b6 00             	movzbl (%rax),%eax
  8003e9:	84 c0                	test   %al,%al
  8003eb:	74 12                	je     8003ff <strcmp+0x39>
  8003ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f1:	0f b6 10             	movzbl (%rax),%edx
  8003f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f8:	0f b6 00             	movzbl (%rax),%eax
  8003fb:	38 c2                	cmp    %al,%dl
  8003fd:	74 d9                	je     8003d8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8003ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800403:	0f b6 00             	movzbl (%rax),%eax
  800406:	0f b6 d0             	movzbl %al,%edx
  800409:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80040d:	0f b6 00             	movzbl (%rax),%eax
  800410:	0f b6 c0             	movzbl %al,%eax
  800413:	29 c2                	sub    %eax,%edx
  800415:	89 d0                	mov    %edx,%eax
}
  800417:	c9                   	leaveq 
  800418:	c3                   	retq   

0000000000800419 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800419:	55                   	push   %rbp
  80041a:	48 89 e5             	mov    %rsp,%rbp
  80041d:	48 83 ec 18          	sub    $0x18,%rsp
  800421:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800425:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800429:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80042d:	eb 0f                	jmp    80043e <strncmp+0x25>
		n--, p++, q++;
  80042f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800434:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800439:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80043e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800443:	74 1d                	je     800462 <strncmp+0x49>
  800445:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800449:	0f b6 00             	movzbl (%rax),%eax
  80044c:	84 c0                	test   %al,%al
  80044e:	74 12                	je     800462 <strncmp+0x49>
  800450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800454:	0f b6 10             	movzbl (%rax),%edx
  800457:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80045b:	0f b6 00             	movzbl (%rax),%eax
  80045e:	38 c2                	cmp    %al,%dl
  800460:	74 cd                	je     80042f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800462:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800467:	75 07                	jne    800470 <strncmp+0x57>
		return 0;
  800469:	b8 00 00 00 00       	mov    $0x0,%eax
  80046e:	eb 18                	jmp    800488 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800470:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800474:	0f b6 00             	movzbl (%rax),%eax
  800477:	0f b6 d0             	movzbl %al,%edx
  80047a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047e:	0f b6 00             	movzbl (%rax),%eax
  800481:	0f b6 c0             	movzbl %al,%eax
  800484:	29 c2                	sub    %eax,%edx
  800486:	89 d0                	mov    %edx,%eax
}
  800488:	c9                   	leaveq 
  800489:	c3                   	retq   

000000000080048a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80048a:	55                   	push   %rbp
  80048b:	48 89 e5             	mov    %rsp,%rbp
  80048e:	48 83 ec 0c          	sub    $0xc,%rsp
  800492:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800496:	89 f0                	mov    %esi,%eax
  800498:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80049b:	eb 17                	jmp    8004b4 <strchr+0x2a>
		if (*s == c)
  80049d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004a1:	0f b6 00             	movzbl (%rax),%eax
  8004a4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004a7:	75 06                	jne    8004af <strchr+0x25>
			return (char *) s;
  8004a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ad:	eb 15                	jmp    8004c4 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8004af:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004b8:	0f b6 00             	movzbl (%rax),%eax
  8004bb:	84 c0                	test   %al,%al
  8004bd:	75 de                	jne    80049d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8004bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004c4:	c9                   	leaveq 
  8004c5:	c3                   	retq   

00000000008004c6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8004c6:	55                   	push   %rbp
  8004c7:	48 89 e5             	mov    %rsp,%rbp
  8004ca:	48 83 ec 0c          	sub    $0xc,%rsp
  8004ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004d2:	89 f0                	mov    %esi,%eax
  8004d4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004d7:	eb 13                	jmp    8004ec <strfind+0x26>
		if (*s == c)
  8004d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004dd:	0f b6 00             	movzbl (%rax),%eax
  8004e0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004e3:	75 02                	jne    8004e7 <strfind+0x21>
			break;
  8004e5:	eb 10                	jmp    8004f7 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8004e7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004f0:	0f b6 00             	movzbl (%rax),%eax
  8004f3:	84 c0                	test   %al,%al
  8004f5:	75 e2                	jne    8004d9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8004f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004fb:	c9                   	leaveq 
  8004fc:	c3                   	retq   

00000000008004fd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8004fd:	55                   	push   %rbp
  8004fe:	48 89 e5             	mov    %rsp,%rbp
  800501:	48 83 ec 18          	sub    $0x18,%rsp
  800505:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800509:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80050c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  800510:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800515:	75 06                	jne    80051d <memset+0x20>
		return v;
  800517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80051b:	eb 69                	jmp    800586 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80051d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800521:	83 e0 03             	and    $0x3,%eax
  800524:	48 85 c0             	test   %rax,%rax
  800527:	75 48                	jne    800571 <memset+0x74>
  800529:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052d:	83 e0 03             	and    $0x3,%eax
  800530:	48 85 c0             	test   %rax,%rax
  800533:	75 3c                	jne    800571 <memset+0x74>
		c &= 0xFF;
  800535:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80053c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80053f:	c1 e0 18             	shl    $0x18,%eax
  800542:	89 c2                	mov    %eax,%edx
  800544:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800547:	c1 e0 10             	shl    $0x10,%eax
  80054a:	09 c2                	or     %eax,%edx
  80054c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80054f:	c1 e0 08             	shl    $0x8,%eax
  800552:	09 d0                	or     %edx,%eax
  800554:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  800557:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055b:	48 c1 e8 02          	shr    $0x2,%rax
  80055f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800562:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800566:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800569:	48 89 d7             	mov    %rdx,%rdi
  80056c:	fc                   	cld    
  80056d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80056f:	eb 11                	jmp    800582 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800571:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800575:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800578:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80057c:	48 89 d7             	mov    %rdx,%rdi
  80057f:	fc                   	cld    
  800580:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  800582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800586:	c9                   	leaveq 
  800587:	c3                   	retq   

0000000000800588 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800588:	55                   	push   %rbp
  800589:	48 89 e5             	mov    %rsp,%rbp
  80058c:	48 83 ec 28          	sub    $0x28,%rsp
  800590:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800594:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800598:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80059c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8005a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8005ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005b0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005b4:	0f 83 88 00 00 00    	jae    800642 <memmove+0xba>
  8005ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8005c2:	48 01 d0             	add    %rdx,%rax
  8005c5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005c9:	76 77                	jbe    800642 <memmove+0xba>
		s += n;
  8005cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005cf:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8005d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005d7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8005db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005df:	83 e0 03             	and    $0x3,%eax
  8005e2:	48 85 c0             	test   %rax,%rax
  8005e5:	75 3b                	jne    800622 <memmove+0x9a>
  8005e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005eb:	83 e0 03             	and    $0x3,%eax
  8005ee:	48 85 c0             	test   %rax,%rax
  8005f1:	75 2f                	jne    800622 <memmove+0x9a>
  8005f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005f7:	83 e0 03             	and    $0x3,%eax
  8005fa:	48 85 c0             	test   %rax,%rax
  8005fd:	75 23                	jne    800622 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8005ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800603:	48 83 e8 04          	sub    $0x4,%rax
  800607:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80060b:	48 83 ea 04          	sub    $0x4,%rdx
  80060f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800613:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800617:	48 89 c7             	mov    %rax,%rdi
  80061a:	48 89 d6             	mov    %rdx,%rsi
  80061d:	fd                   	std    
  80061e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  800620:	eb 1d                	jmp    80063f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800622:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800626:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80062a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80062e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800632:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800636:	48 89 d7             	mov    %rdx,%rdi
  800639:	48 89 c1             	mov    %rax,%rcx
  80063c:	fd                   	std    
  80063d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80063f:	fc                   	cld    
  800640:	eb 57                	jmp    800699 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  800642:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800646:	83 e0 03             	and    $0x3,%eax
  800649:	48 85 c0             	test   %rax,%rax
  80064c:	75 36                	jne    800684 <memmove+0xfc>
  80064e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800652:	83 e0 03             	and    $0x3,%eax
  800655:	48 85 c0             	test   %rax,%rax
  800658:	75 2a                	jne    800684 <memmove+0xfc>
  80065a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80065e:	83 e0 03             	and    $0x3,%eax
  800661:	48 85 c0             	test   %rax,%rax
  800664:	75 1e                	jne    800684 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800666:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80066a:	48 c1 e8 02          	shr    $0x2,%rax
  80066e:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800671:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800675:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800679:	48 89 c7             	mov    %rax,%rdi
  80067c:	48 89 d6             	mov    %rdx,%rsi
  80067f:	fc                   	cld    
  800680:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  800682:	eb 15                	jmp    800699 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800684:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800688:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80068c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800690:	48 89 c7             	mov    %rax,%rdi
  800693:	48 89 d6             	mov    %rdx,%rsi
  800696:	fc                   	cld    
  800697:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800699:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80069d:	c9                   	leaveq 
  80069e:	c3                   	retq   

000000000080069f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80069f:	55                   	push   %rbp
  8006a0:	48 89 e5             	mov    %rsp,%rbp
  8006a3:	48 83 ec 18          	sub    $0x18,%rsp
  8006a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006af:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8006b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006bf:	48 89 ce             	mov    %rcx,%rsi
  8006c2:	48 89 c7             	mov    %rax,%rdi
  8006c5:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  8006cc:	00 00 00 
  8006cf:	ff d0                	callq  *%rax
}
  8006d1:	c9                   	leaveq 
  8006d2:	c3                   	retq   

00000000008006d3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8006d3:	55                   	push   %rbp
  8006d4:	48 89 e5             	mov    %rsp,%rbp
  8006d7:	48 83 ec 28          	sub    $0x28,%rsp
  8006db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8006e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8006ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8006f7:	eb 36                	jmp    80072f <memcmp+0x5c>
		if (*s1 != *s2)
  8006f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006fd:	0f b6 10             	movzbl (%rax),%edx
  800700:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800704:	0f b6 00             	movzbl (%rax),%eax
  800707:	38 c2                	cmp    %al,%dl
  800709:	74 1a                	je     800725 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80070b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80070f:	0f b6 00             	movzbl (%rax),%eax
  800712:	0f b6 d0             	movzbl %al,%edx
  800715:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800719:	0f b6 00             	movzbl (%rax),%eax
  80071c:	0f b6 c0             	movzbl %al,%eax
  80071f:	29 c2                	sub    %eax,%edx
  800721:	89 d0                	mov    %edx,%eax
  800723:	eb 20                	jmp    800745 <memcmp+0x72>
		s1++, s2++;
  800725:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80072a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80072f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800733:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800737:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80073b:	48 85 c0             	test   %rax,%rax
  80073e:	75 b9                	jne    8006f9 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800745:	c9                   	leaveq 
  800746:	c3                   	retq   

0000000000800747 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800747:	55                   	push   %rbp
  800748:	48 89 e5             	mov    %rsp,%rbp
  80074b:	48 83 ec 28          	sub    $0x28,%rsp
  80074f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800753:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  800756:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80075a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80075e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800762:	48 01 d0             	add    %rdx,%rax
  800765:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  800769:	eb 15                	jmp    800780 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80076b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076f:	0f b6 10             	movzbl (%rax),%edx
  800772:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800775:	38 c2                	cmp    %al,%dl
  800777:	75 02                	jne    80077b <memfind+0x34>
			break;
  800779:	eb 0f                	jmp    80078a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80077b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800784:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800788:	72 e1                	jb     80076b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80078a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80078e:	c9                   	leaveq 
  80078f:	c3                   	retq   

0000000000800790 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800790:	55                   	push   %rbp
  800791:	48 89 e5             	mov    %rsp,%rbp
  800794:	48 83 ec 34          	sub    $0x34,%rsp
  800798:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80079c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8007a0:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8007a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8007aa:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8007b1:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007b2:	eb 05                	jmp    8007b9 <strtol+0x29>
		s++;
  8007b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007bd:	0f b6 00             	movzbl (%rax),%eax
  8007c0:	3c 20                	cmp    $0x20,%al
  8007c2:	74 f0                	je     8007b4 <strtol+0x24>
  8007c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007c8:	0f b6 00             	movzbl (%rax),%eax
  8007cb:	3c 09                	cmp    $0x9,%al
  8007cd:	74 e5                	je     8007b4 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8007cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d3:	0f b6 00             	movzbl (%rax),%eax
  8007d6:	3c 2b                	cmp    $0x2b,%al
  8007d8:	75 07                	jne    8007e1 <strtol+0x51>
		s++;
  8007da:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007df:	eb 17                	jmp    8007f8 <strtol+0x68>
	else if (*s == '-')
  8007e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007e5:	0f b6 00             	movzbl (%rax),%eax
  8007e8:	3c 2d                	cmp    $0x2d,%al
  8007ea:	75 0c                	jne    8007f8 <strtol+0x68>
		s++, neg = 1;
  8007ec:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007f1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8007f8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8007fc:	74 06                	je     800804 <strtol+0x74>
  8007fe:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  800802:	75 28                	jne    80082c <strtol+0x9c>
  800804:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800808:	0f b6 00             	movzbl (%rax),%eax
  80080b:	3c 30                	cmp    $0x30,%al
  80080d:	75 1d                	jne    80082c <strtol+0x9c>
  80080f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800813:	48 83 c0 01          	add    $0x1,%rax
  800817:	0f b6 00             	movzbl (%rax),%eax
  80081a:	3c 78                	cmp    $0x78,%al
  80081c:	75 0e                	jne    80082c <strtol+0x9c>
		s += 2, base = 16;
  80081e:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  800823:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80082a:	eb 2c                	jmp    800858 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80082c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800830:	75 19                	jne    80084b <strtol+0xbb>
  800832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800836:	0f b6 00             	movzbl (%rax),%eax
  800839:	3c 30                	cmp    $0x30,%al
  80083b:	75 0e                	jne    80084b <strtol+0xbb>
		s++, base = 8;
  80083d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  800842:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  800849:	eb 0d                	jmp    800858 <strtol+0xc8>
	else if (base == 0)
  80084b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80084f:	75 07                	jne    800858 <strtol+0xc8>
		base = 10;
  800851:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80085c:	0f b6 00             	movzbl (%rax),%eax
  80085f:	3c 2f                	cmp    $0x2f,%al
  800861:	7e 1d                	jle    800880 <strtol+0xf0>
  800863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800867:	0f b6 00             	movzbl (%rax),%eax
  80086a:	3c 39                	cmp    $0x39,%al
  80086c:	7f 12                	jg     800880 <strtol+0xf0>
			dig = *s - '0';
  80086e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800872:	0f b6 00             	movzbl (%rax),%eax
  800875:	0f be c0             	movsbl %al,%eax
  800878:	83 e8 30             	sub    $0x30,%eax
  80087b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80087e:	eb 4e                	jmp    8008ce <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  800880:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800884:	0f b6 00             	movzbl (%rax),%eax
  800887:	3c 60                	cmp    $0x60,%al
  800889:	7e 1d                	jle    8008a8 <strtol+0x118>
  80088b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80088f:	0f b6 00             	movzbl (%rax),%eax
  800892:	3c 7a                	cmp    $0x7a,%al
  800894:	7f 12                	jg     8008a8 <strtol+0x118>
			dig = *s - 'a' + 10;
  800896:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089a:	0f b6 00             	movzbl (%rax),%eax
  80089d:	0f be c0             	movsbl %al,%eax
  8008a0:	83 e8 57             	sub    $0x57,%eax
  8008a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8008a6:	eb 26                	jmp    8008ce <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8008a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008ac:	0f b6 00             	movzbl (%rax),%eax
  8008af:	3c 40                	cmp    $0x40,%al
  8008b1:	7e 48                	jle    8008fb <strtol+0x16b>
  8008b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b7:	0f b6 00             	movzbl (%rax),%eax
  8008ba:	3c 5a                	cmp    $0x5a,%al
  8008bc:	7f 3d                	jg     8008fb <strtol+0x16b>
			dig = *s - 'A' + 10;
  8008be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008c2:	0f b6 00             	movzbl (%rax),%eax
  8008c5:	0f be c0             	movsbl %al,%eax
  8008c8:	83 e8 37             	sub    $0x37,%eax
  8008cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8008ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008d1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8008d4:	7c 02                	jl     8008d8 <strtol+0x148>
			break;
  8008d6:	eb 23                	jmp    8008fb <strtol+0x16b>
		s++, val = (val * base) + dig;
  8008d8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8008dd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008e0:	48 98                	cltq   
  8008e2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8008e7:	48 89 c2             	mov    %rax,%rdx
  8008ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008ed:	48 98                	cltq   
  8008ef:	48 01 d0             	add    %rdx,%rax
  8008f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8008f6:	e9 5d ff ff ff       	jmpq   800858 <strtol+0xc8>

	if (endptr)
  8008fb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800900:	74 0b                	je     80090d <strtol+0x17d>
		*endptr = (char *) s;
  800902:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800906:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80090a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80090d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800911:	74 09                	je     80091c <strtol+0x18c>
  800913:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800917:	48 f7 d8             	neg    %rax
  80091a:	eb 04                	jmp    800920 <strtol+0x190>
  80091c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800920:	c9                   	leaveq 
  800921:	c3                   	retq   

0000000000800922 <strstr>:

char * strstr(const char *in, const char *str)
{
  800922:	55                   	push   %rbp
  800923:	48 89 e5             	mov    %rsp,%rbp
  800926:	48 83 ec 30          	sub    $0x30,%rsp
  80092a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80092e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  800932:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800936:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80093a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80093e:	0f b6 00             	movzbl (%rax),%eax
  800941:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  800944:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  800948:	75 06                	jne    800950 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80094a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80094e:	eb 6b                	jmp    8009bb <strstr+0x99>

	len = strlen(str);
  800950:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800954:	48 89 c7             	mov    %rax,%rdi
  800957:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  80095e:	00 00 00 
  800961:	ff d0                	callq  *%rax
  800963:	48 98                	cltq   
  800965:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  800969:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80096d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800971:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800975:	0f b6 00             	movzbl (%rax),%eax
  800978:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80097b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80097f:	75 07                	jne    800988 <strstr+0x66>
				return (char *) 0;
  800981:	b8 00 00 00 00       	mov    $0x0,%eax
  800986:	eb 33                	jmp    8009bb <strstr+0x99>
		} while (sc != c);
  800988:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80098c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80098f:	75 d8                	jne    800969 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  800991:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800995:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800999:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80099d:	48 89 ce             	mov    %rcx,%rsi
  8009a0:	48 89 c7             	mov    %rax,%rdi
  8009a3:	48 b8 19 04 80 00 00 	movabs $0x800419,%rax
  8009aa:	00 00 00 
  8009ad:	ff d0                	callq  *%rax
  8009af:	85 c0                	test   %eax,%eax
  8009b1:	75 b6                	jne    800969 <strstr+0x47>

	return (char *) (in - 1);
  8009b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009b7:	48 83 e8 01          	sub    $0x1,%rax
}
  8009bb:	c9                   	leaveq 
  8009bc:	c3                   	retq   

00000000008009bd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8009bd:	55                   	push   %rbp
  8009be:	48 89 e5             	mov    %rsp,%rbp
  8009c1:	53                   	push   %rbx
  8009c2:	48 83 ec 48          	sub    $0x48,%rsp
  8009c6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8009c9:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8009cc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8009d0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8009d4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8009d8:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009dc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8009df:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8009e3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8009e7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8009eb:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8009ef:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8009f3:	4c 89 c3             	mov    %r8,%rbx
  8009f6:	cd 30                	int    $0x30
  8009f8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8009fc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a00:	74 3e                	je     800a40 <syscall+0x83>
  800a02:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800a07:	7e 37                	jle    800a40 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800a09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a0d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a10:	49 89 d0             	mov    %rdx,%r8
  800a13:	89 c1                	mov    %eax,%ecx
  800a15:	48 ba 91 37 80 00 00 	movabs $0x803791,%rdx
  800a1c:	00 00 00 
  800a1f:	be 23 00 00 00       	mov    $0x23,%esi
  800a24:	48 bf ae 37 80 00 00 	movabs $0x8037ae,%rdi
  800a2b:	00 00 00 
  800a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a33:	49 b9 0e 27 80 00 00 	movabs $0x80270e,%r9
  800a3a:	00 00 00 
  800a3d:	41 ff d1             	callq  *%r9

	return ret;
  800a40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800a44:	48 83 c4 48          	add    $0x48,%rsp
  800a48:	5b                   	pop    %rbx
  800a49:	5d                   	pop    %rbp
  800a4a:	c3                   	retq   

0000000000800a4b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a4b:	55                   	push   %rbp
  800a4c:	48 89 e5             	mov    %rsp,%rbp
  800a4f:	48 83 ec 20          	sub    $0x20,%rsp
  800a53:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800a5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a63:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800a6a:	00 
  800a6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800a71:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800a77:	48 89 d1             	mov    %rdx,%rcx
  800a7a:	48 89 c2             	mov    %rax,%rdx
  800a7d:	be 00 00 00 00       	mov    $0x0,%esi
  800a82:	bf 00 00 00 00       	mov    $0x0,%edi
  800a87:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800a8e:	00 00 00 
  800a91:	ff d0                	callq  *%rax
}
  800a93:	c9                   	leaveq 
  800a94:	c3                   	retq   

0000000000800a95 <sys_cgetc>:

int
sys_cgetc(void)
{
  800a95:	55                   	push   %rbp
  800a96:	48 89 e5             	mov    %rsp,%rbp
  800a99:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800a9d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800aa4:	00 
  800aa5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800aab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ab1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ab6:	ba 00 00 00 00       	mov    $0x0,%edx
  800abb:	be 00 00 00 00       	mov    $0x0,%esi
  800ac0:	bf 01 00 00 00       	mov    $0x1,%edi
  800ac5:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800acc:	00 00 00 
  800acf:	ff d0                	callq  *%rax
}
  800ad1:	c9                   	leaveq 
  800ad2:	c3                   	retq   

0000000000800ad3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ad3:	55                   	push   %rbp
  800ad4:	48 89 e5             	mov    %rsp,%rbp
  800ad7:	48 83 ec 10          	sub    $0x10,%rsp
  800adb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800ade:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ae1:	48 98                	cltq   
  800ae3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800aea:	00 
  800aeb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800af1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800af7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800afc:	48 89 c2             	mov    %rax,%rdx
  800aff:	be 01 00 00 00       	mov    $0x1,%esi
  800b04:	bf 03 00 00 00       	mov    $0x3,%edi
  800b09:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800b10:	00 00 00 
  800b13:	ff d0                	callq  *%rax
}
  800b15:	c9                   	leaveq 
  800b16:	c3                   	retq   

0000000000800b17 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b17:	55                   	push   %rbp
  800b18:	48 89 e5             	mov    %rsp,%rbp
  800b1b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b1f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b26:	00 
  800b27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b33:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b38:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3d:	be 00 00 00 00       	mov    $0x0,%esi
  800b42:	bf 02 00 00 00       	mov    $0x2,%edi
  800b47:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800b4e:	00 00 00 
  800b51:	ff d0                	callq  *%rax
}
  800b53:	c9                   	leaveq 
  800b54:	c3                   	retq   

0000000000800b55 <sys_yield>:

void
sys_yield(void)
{
  800b55:	55                   	push   %rbp
  800b56:	48 89 e5             	mov    %rsp,%rbp
  800b59:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b5d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b64:	00 
  800b65:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b71:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b76:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7b:	be 00 00 00 00       	mov    $0x0,%esi
  800b80:	bf 0b 00 00 00       	mov    $0xb,%edi
  800b85:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800b8c:	00 00 00 
  800b8f:	ff d0                	callq  *%rax
}
  800b91:	c9                   	leaveq 
  800b92:	c3                   	retq   

0000000000800b93 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b93:	55                   	push   %rbp
  800b94:	48 89 e5             	mov    %rsp,%rbp
  800b97:	48 83 ec 20          	sub    $0x20,%rsp
  800b9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800b9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800ba2:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800ba5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ba8:	48 63 c8             	movslq %eax,%rcx
  800bab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800baf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bb2:	48 98                	cltq   
  800bb4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800bbb:	00 
  800bbc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800bc2:	49 89 c8             	mov    %rcx,%r8
  800bc5:	48 89 d1             	mov    %rdx,%rcx
  800bc8:	48 89 c2             	mov    %rax,%rdx
  800bcb:	be 01 00 00 00       	mov    $0x1,%esi
  800bd0:	bf 04 00 00 00       	mov    $0x4,%edi
  800bd5:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800bdc:	00 00 00 
  800bdf:	ff d0                	callq  *%rax
}
  800be1:	c9                   	leaveq 
  800be2:	c3                   	retq   

0000000000800be3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800be3:	55                   	push   %rbp
  800be4:	48 89 e5             	mov    %rsp,%rbp
  800be7:	48 83 ec 30          	sub    $0x30,%rsp
  800beb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800bf2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800bf5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800bf9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800bfd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c00:	48 63 c8             	movslq %eax,%rcx
  800c03:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c07:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c0a:	48 63 f0             	movslq %eax,%rsi
  800c0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c14:	48 98                	cltq   
  800c16:	48 89 0c 24          	mov    %rcx,(%rsp)
  800c1a:	49 89 f9             	mov    %rdi,%r9
  800c1d:	49 89 f0             	mov    %rsi,%r8
  800c20:	48 89 d1             	mov    %rdx,%rcx
  800c23:	48 89 c2             	mov    %rax,%rdx
  800c26:	be 01 00 00 00       	mov    $0x1,%esi
  800c2b:	bf 05 00 00 00       	mov    $0x5,%edi
  800c30:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800c37:	00 00 00 
  800c3a:	ff d0                	callq  *%rax
}
  800c3c:	c9                   	leaveq 
  800c3d:	c3                   	retq   

0000000000800c3e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c3e:	55                   	push   %rbp
  800c3f:	48 89 e5             	mov    %rsp,%rbp
  800c42:	48 83 ec 20          	sub    $0x20,%rsp
  800c46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800c4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c54:	48 98                	cltq   
  800c56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800c5d:	00 
  800c5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800c64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800c6a:	48 89 d1             	mov    %rdx,%rcx
  800c6d:	48 89 c2             	mov    %rax,%rdx
  800c70:	be 01 00 00 00       	mov    $0x1,%esi
  800c75:	bf 06 00 00 00       	mov    $0x6,%edi
  800c7a:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800c81:	00 00 00 
  800c84:	ff d0                	callq  *%rax
}
  800c86:	c9                   	leaveq 
  800c87:	c3                   	retq   

0000000000800c88 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c88:	55                   	push   %rbp
  800c89:	48 89 e5             	mov    %rsp,%rbp
  800c8c:	48 83 ec 10          	sub    $0x10,%rsp
  800c90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c93:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c96:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c99:	48 63 d0             	movslq %eax,%rdx
  800c9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c9f:	48 98                	cltq   
  800ca1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800ca8:	00 
  800ca9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800caf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800cb5:	48 89 d1             	mov    %rdx,%rcx
  800cb8:	48 89 c2             	mov    %rax,%rdx
  800cbb:	be 01 00 00 00       	mov    $0x1,%esi
  800cc0:	bf 08 00 00 00       	mov    $0x8,%edi
  800cc5:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800ccc:	00 00 00 
  800ccf:	ff d0                	callq  *%rax
}
  800cd1:	c9                   	leaveq 
  800cd2:	c3                   	retq   

0000000000800cd3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cd3:	55                   	push   %rbp
  800cd4:	48 89 e5             	mov    %rsp,%rbp
  800cd7:	48 83 ec 20          	sub    $0x20,%rsp
  800cdb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cde:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800ce2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ce6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ce9:	48 98                	cltq   
  800ceb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800cf2:	00 
  800cf3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800cf9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800cff:	48 89 d1             	mov    %rdx,%rcx
  800d02:	48 89 c2             	mov    %rax,%rdx
  800d05:	be 01 00 00 00       	mov    $0x1,%esi
  800d0a:	bf 09 00 00 00       	mov    $0x9,%edi
  800d0f:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800d16:	00 00 00 
  800d19:	ff d0                	callq  *%rax
}
  800d1b:	c9                   	leaveq 
  800d1c:	c3                   	retq   

0000000000800d1d <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d1d:	55                   	push   %rbp
  800d1e:	48 89 e5             	mov    %rsp,%rbp
  800d21:	48 83 ec 20          	sub    $0x20,%rsp
  800d25:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d28:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800d2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d33:	48 98                	cltq   
  800d35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d3c:	00 
  800d3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d49:	48 89 d1             	mov    %rdx,%rcx
  800d4c:	48 89 c2             	mov    %rax,%rdx
  800d4f:	be 01 00 00 00       	mov    $0x1,%esi
  800d54:	bf 0a 00 00 00       	mov    $0xa,%edi
  800d59:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800d60:	00 00 00 
  800d63:	ff d0                	callq  *%rax
}
  800d65:	c9                   	leaveq 
  800d66:	c3                   	retq   

0000000000800d67 <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  800d67:	55                   	push   %rbp
  800d68:	48 89 e5             	mov    %rsp,%rbp
  800d6b:	48 83 ec 10          	sub    $0x10,%rsp
  800d6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d72:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  800d75:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d78:	48 63 d0             	movslq %eax,%rdx
  800d7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d7e:	48 98                	cltq   
  800d80:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d87:	00 
  800d88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d94:	48 89 d1             	mov    %rdx,%rcx
  800d97:	48 89 c2             	mov    %rax,%rdx
  800d9a:	be 01 00 00 00       	mov    $0x1,%esi
  800d9f:	bf 11 00 00 00       	mov    $0x11,%edi
  800da4:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800dab:	00 00 00 
  800dae:	ff d0                	callq  *%rax

}
  800db0:	c9                   	leaveq 
  800db1:	c3                   	retq   

0000000000800db2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800db2:	55                   	push   %rbp
  800db3:	48 89 e5             	mov    %rsp,%rbp
  800db6:	48 83 ec 20          	sub    $0x20,%rsp
  800dba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800dbd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800dc1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800dc5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800dc8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800dcb:	48 63 f0             	movslq %eax,%rsi
  800dce:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800dd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dd5:	48 98                	cltq   
  800dd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ddb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800de2:	00 
  800de3:	49 89 f1             	mov    %rsi,%r9
  800de6:	49 89 c8             	mov    %rcx,%r8
  800de9:	48 89 d1             	mov    %rdx,%rcx
  800dec:	48 89 c2             	mov    %rax,%rdx
  800def:	be 00 00 00 00       	mov    $0x0,%esi
  800df4:	bf 0c 00 00 00       	mov    $0xc,%edi
  800df9:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800e00:	00 00 00 
  800e03:	ff d0                	callq  *%rax
}
  800e05:	c9                   	leaveq 
  800e06:	c3                   	retq   

0000000000800e07 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e07:	55                   	push   %rbp
  800e08:	48 89 e5             	mov    %rsp,%rbp
  800e0b:	48 83 ec 10          	sub    $0x10,%rsp
  800e0f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800e13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e17:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800e1e:	00 
  800e1f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800e25:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e30:	48 89 c2             	mov    %rax,%rdx
  800e33:	be 01 00 00 00       	mov    $0x1,%esi
  800e38:	bf 0d 00 00 00       	mov    $0xd,%edi
  800e3d:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800e44:	00 00 00 
  800e47:	ff d0                	callq  *%rax
}
  800e49:	c9                   	leaveq 
  800e4a:	c3                   	retq   

0000000000800e4b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e4b:	55                   	push   %rbp
  800e4c:	48 89 e5             	mov    %rsp,%rbp
  800e4f:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800e53:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800e5a:	00 
  800e5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800e61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e67:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e71:	be 00 00 00 00       	mov    $0x0,%esi
  800e76:	bf 0e 00 00 00       	mov    $0xe,%edi
  800e7b:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800e82:	00 00 00 
  800e85:	ff d0                	callq  *%rax
}
  800e87:	c9                   	leaveq 
  800e88:	c3                   	retq   

0000000000800e89 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  800e89:	55                   	push   %rbp
  800e8a:	48 89 e5             	mov    %rsp,%rbp
  800e8d:	48 83 ec 30          	sub    $0x30,%rsp
  800e91:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800e98:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800e9b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800e9f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  800ea3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800ea6:	48 63 c8             	movslq %eax,%rcx
  800ea9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800ead:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800eb0:	48 63 f0             	movslq %eax,%rsi
  800eb3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800eb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eba:	48 98                	cltq   
  800ebc:	48 89 0c 24          	mov    %rcx,(%rsp)
  800ec0:	49 89 f9             	mov    %rdi,%r9
  800ec3:	49 89 f0             	mov    %rsi,%r8
  800ec6:	48 89 d1             	mov    %rdx,%rcx
  800ec9:	48 89 c2             	mov    %rax,%rdx
  800ecc:	be 00 00 00 00       	mov    $0x0,%esi
  800ed1:	bf 0f 00 00 00       	mov    $0xf,%edi
  800ed6:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800edd:	00 00 00 
  800ee0:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  800ee2:	c9                   	leaveq 
  800ee3:	c3                   	retq   

0000000000800ee4 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  800ee4:	55                   	push   %rbp
  800ee5:	48 89 e5             	mov    %rsp,%rbp
  800ee8:	48 83 ec 20          	sub    $0x20,%rsp
  800eec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800ef0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  800ef4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ef8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800efc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800f03:	00 
  800f04:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800f0a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800f10:	48 89 d1             	mov    %rdx,%rcx
  800f13:	48 89 c2             	mov    %rax,%rdx
  800f16:	be 00 00 00 00       	mov    $0x0,%esi
  800f1b:	bf 10 00 00 00       	mov    $0x10,%edi
  800f20:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800f27:	00 00 00 
  800f2a:	ff d0                	callq  *%rax
}
  800f2c:	c9                   	leaveq 
  800f2d:	c3                   	retq   

0000000000800f2e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800f2e:	55                   	push   %rbp
  800f2f:	48 89 e5             	mov    %rsp,%rbp
  800f32:	48 83 ec 08          	sub    $0x8,%rsp
  800f36:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f3a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800f3e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800f45:	ff ff ff 
  800f48:	48 01 d0             	add    %rdx,%rax
  800f4b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800f4f:	c9                   	leaveq 
  800f50:	c3                   	retq   

0000000000800f51 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f51:	55                   	push   %rbp
  800f52:	48 89 e5             	mov    %rsp,%rbp
  800f55:	48 83 ec 08          	sub    $0x8,%rsp
  800f59:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800f5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f61:	48 89 c7             	mov    %rax,%rdi
  800f64:	48 b8 2e 0f 80 00 00 	movabs $0x800f2e,%rax
  800f6b:	00 00 00 
  800f6e:	ff d0                	callq  *%rax
  800f70:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800f76:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800f7a:	c9                   	leaveq 
  800f7b:	c3                   	retq   

0000000000800f7c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f7c:	55                   	push   %rbp
  800f7d:	48 89 e5             	mov    %rsp,%rbp
  800f80:	48 83 ec 18          	sub    $0x18,%rsp
  800f84:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f8f:	eb 6b                	jmp    800ffc <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800f91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f94:	48 98                	cltq   
  800f96:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800f9c:	48 c1 e0 0c          	shl    $0xc,%rax
  800fa0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa8:	48 c1 e8 15          	shr    $0x15,%rax
  800fac:	48 89 c2             	mov    %rax,%rdx
  800faf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800fb6:	01 00 00 
  800fb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800fbd:	83 e0 01             	and    $0x1,%eax
  800fc0:	48 85 c0             	test   %rax,%rax
  800fc3:	74 21                	je     800fe6 <fd_alloc+0x6a>
  800fc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc9:	48 c1 e8 0c          	shr    $0xc,%rax
  800fcd:	48 89 c2             	mov    %rax,%rdx
  800fd0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800fd7:	01 00 00 
  800fda:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800fde:	83 e0 01             	and    $0x1,%eax
  800fe1:	48 85 c0             	test   %rax,%rax
  800fe4:	75 12                	jne    800ff8 <fd_alloc+0x7c>
			*fd_store = fd;
  800fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fee:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800ff1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff6:	eb 1a                	jmp    801012 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800ff8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800ffc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801000:	7e 8f                	jle    800f91 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801002:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801006:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80100d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801012:	c9                   	leaveq 
  801013:	c3                   	retq   

0000000000801014 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801014:	55                   	push   %rbp
  801015:	48 89 e5             	mov    %rsp,%rbp
  801018:	48 83 ec 20          	sub    $0x20,%rsp
  80101c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80101f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801023:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801027:	78 06                	js     80102f <fd_lookup+0x1b>
  801029:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80102d:	7e 07                	jle    801036 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80102f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801034:	eb 6c                	jmp    8010a2 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801036:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801039:	48 98                	cltq   
  80103b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801041:	48 c1 e0 0c          	shl    $0xc,%rax
  801045:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801049:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104d:	48 c1 e8 15          	shr    $0x15,%rax
  801051:	48 89 c2             	mov    %rax,%rdx
  801054:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80105b:	01 00 00 
  80105e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801062:	83 e0 01             	and    $0x1,%eax
  801065:	48 85 c0             	test   %rax,%rax
  801068:	74 21                	je     80108b <fd_lookup+0x77>
  80106a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106e:	48 c1 e8 0c          	shr    $0xc,%rax
  801072:	48 89 c2             	mov    %rax,%rdx
  801075:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80107c:	01 00 00 
  80107f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801083:	83 e0 01             	and    $0x1,%eax
  801086:	48 85 c0             	test   %rax,%rax
  801089:	75 07                	jne    801092 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80108b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801090:	eb 10                	jmp    8010a2 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801092:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801096:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80109a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80109d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a2:	c9                   	leaveq 
  8010a3:	c3                   	retq   

00000000008010a4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8010a4:	55                   	push   %rbp
  8010a5:	48 89 e5             	mov    %rsp,%rbp
  8010a8:	48 83 ec 30          	sub    $0x30,%rsp
  8010ac:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8010b0:	89 f0                	mov    %esi,%eax
  8010b2:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010b9:	48 89 c7             	mov    %rax,%rdi
  8010bc:	48 b8 2e 0f 80 00 00 	movabs $0x800f2e,%rax
  8010c3:	00 00 00 
  8010c6:	ff d0                	callq  *%rax
  8010c8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8010cc:	48 89 d6             	mov    %rdx,%rsi
  8010cf:	89 c7                	mov    %eax,%edi
  8010d1:	48 b8 14 10 80 00 00 	movabs $0x801014,%rax
  8010d8:	00 00 00 
  8010db:	ff d0                	callq  *%rax
  8010dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010e4:	78 0a                	js     8010f0 <fd_close+0x4c>
	    || fd != fd2)
  8010e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ea:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8010ee:	74 12                	je     801102 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8010f0:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8010f4:	74 05                	je     8010fb <fd_close+0x57>
  8010f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010f9:	eb 05                	jmp    801100 <fd_close+0x5c>
  8010fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801100:	eb 69                	jmp    80116b <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801102:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801106:	8b 00                	mov    (%rax),%eax
  801108:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80110c:	48 89 d6             	mov    %rdx,%rsi
  80110f:	89 c7                	mov    %eax,%edi
  801111:	48 b8 6d 11 80 00 00 	movabs $0x80116d,%rax
  801118:	00 00 00 
  80111b:	ff d0                	callq  *%rax
  80111d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801120:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801124:	78 2a                	js     801150 <fd_close+0xac>
		if (dev->dev_close)
  801126:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80112e:	48 85 c0             	test   %rax,%rax
  801131:	74 16                	je     801149 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801133:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801137:	48 8b 40 20          	mov    0x20(%rax),%rax
  80113b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80113f:	48 89 d7             	mov    %rdx,%rdi
  801142:	ff d0                	callq  *%rax
  801144:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801147:	eb 07                	jmp    801150 <fd_close+0xac>
		else
			r = 0;
  801149:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801150:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801154:	48 89 c6             	mov    %rax,%rsi
  801157:	bf 00 00 00 00       	mov    $0x0,%edi
  80115c:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  801163:	00 00 00 
  801166:	ff d0                	callq  *%rax
	return r;
  801168:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80116b:	c9                   	leaveq 
  80116c:	c3                   	retq   

000000000080116d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80116d:	55                   	push   %rbp
  80116e:	48 89 e5             	mov    %rsp,%rbp
  801171:	48 83 ec 20          	sub    $0x20,%rsp
  801175:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801178:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80117c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801183:	eb 41                	jmp    8011c6 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801185:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80118c:	00 00 00 
  80118f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801192:	48 63 d2             	movslq %edx,%rdx
  801195:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801199:	8b 00                	mov    (%rax),%eax
  80119b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80119e:	75 22                	jne    8011c2 <dev_lookup+0x55>
			*dev = devtab[i];
  8011a0:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8011a7:	00 00 00 
  8011aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011ad:	48 63 d2             	movslq %edx,%rdx
  8011b0:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8011b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8011bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c0:	eb 60                	jmp    801222 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011c2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8011c6:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8011cd:	00 00 00 
  8011d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011d3:	48 63 d2             	movslq %edx,%rdx
  8011d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8011da:	48 85 c0             	test   %rax,%rax
  8011dd:	75 a6                	jne    801185 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011df:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8011e6:	00 00 00 
  8011e9:	48 8b 00             	mov    (%rax),%rax
  8011ec:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8011f2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8011f5:	89 c6                	mov    %eax,%esi
  8011f7:	48 bf c0 37 80 00 00 	movabs $0x8037c0,%rdi
  8011fe:	00 00 00 
  801201:	b8 00 00 00 00       	mov    $0x0,%eax
  801206:	48 b9 47 29 80 00 00 	movabs $0x802947,%rcx
  80120d:	00 00 00 
  801210:	ff d1                	callq  *%rcx
	*dev = 0;
  801212:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801216:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80121d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801222:	c9                   	leaveq 
  801223:	c3                   	retq   

0000000000801224 <close>:

int
close(int fdnum)
{
  801224:	55                   	push   %rbp
  801225:	48 89 e5             	mov    %rsp,%rbp
  801228:	48 83 ec 20          	sub    $0x20,%rsp
  80122c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80122f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801233:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801236:	48 89 d6             	mov    %rdx,%rsi
  801239:	89 c7                	mov    %eax,%edi
  80123b:	48 b8 14 10 80 00 00 	movabs $0x801014,%rax
  801242:	00 00 00 
  801245:	ff d0                	callq  *%rax
  801247:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80124a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80124e:	79 05                	jns    801255 <close+0x31>
		return r;
  801250:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801253:	eb 18                	jmp    80126d <close+0x49>
	else
		return fd_close(fd, 1);
  801255:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801259:	be 01 00 00 00       	mov    $0x1,%esi
  80125e:	48 89 c7             	mov    %rax,%rdi
  801261:	48 b8 a4 10 80 00 00 	movabs $0x8010a4,%rax
  801268:	00 00 00 
  80126b:	ff d0                	callq  *%rax
}
  80126d:	c9                   	leaveq 
  80126e:	c3                   	retq   

000000000080126f <close_all>:

void
close_all(void)
{
  80126f:	55                   	push   %rbp
  801270:	48 89 e5             	mov    %rsp,%rbp
  801273:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801277:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80127e:	eb 15                	jmp    801295 <close_all+0x26>
		close(i);
  801280:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801283:	89 c7                	mov    %eax,%edi
  801285:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  80128c:	00 00 00 
  80128f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801291:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801295:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801299:	7e e5                	jle    801280 <close_all+0x11>
		close(i);
}
  80129b:	c9                   	leaveq 
  80129c:	c3                   	retq   

000000000080129d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80129d:	55                   	push   %rbp
  80129e:	48 89 e5             	mov    %rsp,%rbp
  8012a1:	48 83 ec 40          	sub    $0x40,%rsp
  8012a5:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8012a8:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012ab:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8012af:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8012b2:	48 89 d6             	mov    %rdx,%rsi
  8012b5:	89 c7                	mov    %eax,%edi
  8012b7:	48 b8 14 10 80 00 00 	movabs $0x801014,%rax
  8012be:	00 00 00 
  8012c1:	ff d0                	callq  *%rax
  8012c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012ca:	79 08                	jns    8012d4 <dup+0x37>
		return r;
  8012cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012cf:	e9 70 01 00 00       	jmpq   801444 <dup+0x1a7>
	close(newfdnum);
  8012d4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8012d7:	89 c7                	mov    %eax,%edi
  8012d9:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  8012e0:	00 00 00 
  8012e3:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8012e5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8012e8:	48 98                	cltq   
  8012ea:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8012f0:	48 c1 e0 0c          	shl    $0xc,%rax
  8012f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8012f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012fc:	48 89 c7             	mov    %rax,%rdi
  8012ff:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  801306:	00 00 00 
  801309:	ff d0                	callq  *%rax
  80130b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80130f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801313:	48 89 c7             	mov    %rax,%rdi
  801316:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  80131d:	00 00 00 
  801320:	ff d0                	callq  *%rax
  801322:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801326:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132a:	48 c1 e8 15          	shr    $0x15,%rax
  80132e:	48 89 c2             	mov    %rax,%rdx
  801331:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801338:	01 00 00 
  80133b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80133f:	83 e0 01             	and    $0x1,%eax
  801342:	48 85 c0             	test   %rax,%rax
  801345:	74 73                	je     8013ba <dup+0x11d>
  801347:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134b:	48 c1 e8 0c          	shr    $0xc,%rax
  80134f:	48 89 c2             	mov    %rax,%rdx
  801352:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801359:	01 00 00 
  80135c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801360:	83 e0 01             	and    $0x1,%eax
  801363:	48 85 c0             	test   %rax,%rax
  801366:	74 52                	je     8013ba <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801368:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136c:	48 c1 e8 0c          	shr    $0xc,%rax
  801370:	48 89 c2             	mov    %rax,%rdx
  801373:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80137a:	01 00 00 
  80137d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801381:	25 07 0e 00 00       	and    $0xe07,%eax
  801386:	89 c1                	mov    %eax,%ecx
  801388:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80138c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801390:	41 89 c8             	mov    %ecx,%r8d
  801393:	48 89 d1             	mov    %rdx,%rcx
  801396:	ba 00 00 00 00       	mov    $0x0,%edx
  80139b:	48 89 c6             	mov    %rax,%rsi
  80139e:	bf 00 00 00 00       	mov    $0x0,%edi
  8013a3:	48 b8 e3 0b 80 00 00 	movabs $0x800be3,%rax
  8013aa:	00 00 00 
  8013ad:	ff d0                	callq  *%rax
  8013af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013b6:	79 02                	jns    8013ba <dup+0x11d>
			goto err;
  8013b8:	eb 57                	jmp    801411 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013be:	48 c1 e8 0c          	shr    $0xc,%rax
  8013c2:	48 89 c2             	mov    %rax,%rdx
  8013c5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8013cc:	01 00 00 
  8013cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8013d3:	25 07 0e 00 00       	and    $0xe07,%eax
  8013d8:	89 c1                	mov    %eax,%ecx
  8013da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8013e2:	41 89 c8             	mov    %ecx,%r8d
  8013e5:	48 89 d1             	mov    %rdx,%rcx
  8013e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ed:	48 89 c6             	mov    %rax,%rsi
  8013f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8013f5:	48 b8 e3 0b 80 00 00 	movabs $0x800be3,%rax
  8013fc:	00 00 00 
  8013ff:	ff d0                	callq  *%rax
  801401:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801404:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801408:	79 02                	jns    80140c <dup+0x16f>
		goto err;
  80140a:	eb 05                	jmp    801411 <dup+0x174>

	return newfdnum;
  80140c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80140f:	eb 33                	jmp    801444 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  801411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801415:	48 89 c6             	mov    %rax,%rsi
  801418:	bf 00 00 00 00       	mov    $0x0,%edi
  80141d:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  801424:	00 00 00 
  801427:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801429:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80142d:	48 89 c6             	mov    %rax,%rsi
  801430:	bf 00 00 00 00       	mov    $0x0,%edi
  801435:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  80143c:	00 00 00 
  80143f:	ff d0                	callq  *%rax
	return r;
  801441:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801444:	c9                   	leaveq 
  801445:	c3                   	retq   

0000000000801446 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801446:	55                   	push   %rbp
  801447:	48 89 e5             	mov    %rsp,%rbp
  80144a:	48 83 ec 40          	sub    $0x40,%rsp
  80144e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801451:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801455:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801459:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80145d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801460:	48 89 d6             	mov    %rdx,%rsi
  801463:	89 c7                	mov    %eax,%edi
  801465:	48 b8 14 10 80 00 00 	movabs $0x801014,%rax
  80146c:	00 00 00 
  80146f:	ff d0                	callq  *%rax
  801471:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801474:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801478:	78 24                	js     80149e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147e:	8b 00                	mov    (%rax),%eax
  801480:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801484:	48 89 d6             	mov    %rdx,%rsi
  801487:	89 c7                	mov    %eax,%edi
  801489:	48 b8 6d 11 80 00 00 	movabs $0x80116d,%rax
  801490:	00 00 00 
  801493:	ff d0                	callq  *%rax
  801495:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801498:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80149c:	79 05                	jns    8014a3 <read+0x5d>
		return r;
  80149e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014a1:	eb 76                	jmp    801519 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a7:	8b 40 08             	mov    0x8(%rax),%eax
  8014aa:	83 e0 03             	and    $0x3,%eax
  8014ad:	83 f8 01             	cmp    $0x1,%eax
  8014b0:	75 3a                	jne    8014ec <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014b2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8014b9:	00 00 00 
  8014bc:	48 8b 00             	mov    (%rax),%rax
  8014bf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8014c5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8014c8:	89 c6                	mov    %eax,%esi
  8014ca:	48 bf df 37 80 00 00 	movabs $0x8037df,%rdi
  8014d1:	00 00 00 
  8014d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d9:	48 b9 47 29 80 00 00 	movabs $0x802947,%rcx
  8014e0:	00 00 00 
  8014e3:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8014e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ea:	eb 2d                	jmp    801519 <read+0xd3>
	}
	if (!dev->dev_read)
  8014ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8014f4:	48 85 c0             	test   %rax,%rax
  8014f7:	75 07                	jne    801500 <read+0xba>
		return -E_NOT_SUPP;
  8014f9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8014fe:	eb 19                	jmp    801519 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  801500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801504:	48 8b 40 10          	mov    0x10(%rax),%rax
  801508:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80150c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801510:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801514:	48 89 cf             	mov    %rcx,%rdi
  801517:	ff d0                	callq  *%rax
}
  801519:	c9                   	leaveq 
  80151a:	c3                   	retq   

000000000080151b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80151b:	55                   	push   %rbp
  80151c:	48 89 e5             	mov    %rsp,%rbp
  80151f:	48 83 ec 30          	sub    $0x30,%rsp
  801523:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801526:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80152a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80152e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801535:	eb 49                	jmp    801580 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801537:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80153a:	48 98                	cltq   
  80153c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801540:	48 29 c2             	sub    %rax,%rdx
  801543:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801546:	48 63 c8             	movslq %eax,%rcx
  801549:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80154d:	48 01 c1             	add    %rax,%rcx
  801550:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801553:	48 89 ce             	mov    %rcx,%rsi
  801556:	89 c7                	mov    %eax,%edi
  801558:	48 b8 46 14 80 00 00 	movabs $0x801446,%rax
  80155f:	00 00 00 
  801562:	ff d0                	callq  *%rax
  801564:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  801567:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80156b:	79 05                	jns    801572 <readn+0x57>
			return m;
  80156d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801570:	eb 1c                	jmp    80158e <readn+0x73>
		if (m == 0)
  801572:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801576:	75 02                	jne    80157a <readn+0x5f>
			break;
  801578:	eb 11                	jmp    80158b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80157a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80157d:	01 45 fc             	add    %eax,-0x4(%rbp)
  801580:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801583:	48 98                	cltq   
  801585:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801589:	72 ac                	jb     801537 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80158b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80158e:	c9                   	leaveq 
  80158f:	c3                   	retq   

0000000000801590 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801590:	55                   	push   %rbp
  801591:	48 89 e5             	mov    %rsp,%rbp
  801594:	48 83 ec 40          	sub    $0x40,%rsp
  801598:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80159b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80159f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8015a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015aa:	48 89 d6             	mov    %rdx,%rsi
  8015ad:	89 c7                	mov    %eax,%edi
  8015af:	48 b8 14 10 80 00 00 	movabs $0x801014,%rax
  8015b6:	00 00 00 
  8015b9:	ff d0                	callq  *%rax
  8015bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015c2:	78 24                	js     8015e8 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c8:	8b 00                	mov    (%rax),%eax
  8015ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8015ce:	48 89 d6             	mov    %rdx,%rsi
  8015d1:	89 c7                	mov    %eax,%edi
  8015d3:	48 b8 6d 11 80 00 00 	movabs $0x80116d,%rax
  8015da:	00 00 00 
  8015dd:	ff d0                	callq  *%rax
  8015df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015e6:	79 05                	jns    8015ed <write+0x5d>
		return r;
  8015e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015eb:	eb 75                	jmp    801662 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f1:	8b 40 08             	mov    0x8(%rax),%eax
  8015f4:	83 e0 03             	and    $0x3,%eax
  8015f7:	85 c0                	test   %eax,%eax
  8015f9:	75 3a                	jne    801635 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015fb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801602:	00 00 00 
  801605:	48 8b 00             	mov    (%rax),%rax
  801608:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80160e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801611:	89 c6                	mov    %eax,%esi
  801613:	48 bf fb 37 80 00 00 	movabs $0x8037fb,%rdi
  80161a:	00 00 00 
  80161d:	b8 00 00 00 00       	mov    $0x0,%eax
  801622:	48 b9 47 29 80 00 00 	movabs $0x802947,%rcx
  801629:	00 00 00 
  80162c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80162e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801633:	eb 2d                	jmp    801662 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801635:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801639:	48 8b 40 18          	mov    0x18(%rax),%rax
  80163d:	48 85 c0             	test   %rax,%rax
  801640:	75 07                	jne    801649 <write+0xb9>
		return -E_NOT_SUPP;
  801642:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801647:	eb 19                	jmp    801662 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  801649:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164d:	48 8b 40 18          	mov    0x18(%rax),%rax
  801651:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801655:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801659:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80165d:	48 89 cf             	mov    %rcx,%rdi
  801660:	ff d0                	callq  *%rax
}
  801662:	c9                   	leaveq 
  801663:	c3                   	retq   

0000000000801664 <seek>:

int
seek(int fdnum, off_t offset)
{
  801664:	55                   	push   %rbp
  801665:	48 89 e5             	mov    %rsp,%rbp
  801668:	48 83 ec 18          	sub    $0x18,%rsp
  80166c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80166f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801672:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801676:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801679:	48 89 d6             	mov    %rdx,%rsi
  80167c:	89 c7                	mov    %eax,%edi
  80167e:	48 b8 14 10 80 00 00 	movabs $0x801014,%rax
  801685:	00 00 00 
  801688:	ff d0                	callq  *%rax
  80168a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80168d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801691:	79 05                	jns    801698 <seek+0x34>
		return r;
  801693:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801696:	eb 0f                	jmp    8016a7 <seek+0x43>
	fd->fd_offset = offset;
  801698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80169f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8016a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a7:	c9                   	leaveq 
  8016a8:	c3                   	retq   

00000000008016a9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016a9:	55                   	push   %rbp
  8016aa:	48 89 e5             	mov    %rsp,%rbp
  8016ad:	48 83 ec 30          	sub    $0x30,%rsp
  8016b1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016b4:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8016bb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016be:	48 89 d6             	mov    %rdx,%rsi
  8016c1:	89 c7                	mov    %eax,%edi
  8016c3:	48 b8 14 10 80 00 00 	movabs $0x801014,%rax
  8016ca:	00 00 00 
  8016cd:	ff d0                	callq  *%rax
  8016cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016d6:	78 24                	js     8016fc <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016dc:	8b 00                	mov    (%rax),%eax
  8016de:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8016e2:	48 89 d6             	mov    %rdx,%rsi
  8016e5:	89 c7                	mov    %eax,%edi
  8016e7:	48 b8 6d 11 80 00 00 	movabs $0x80116d,%rax
  8016ee:	00 00 00 
  8016f1:	ff d0                	callq  *%rax
  8016f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016fa:	79 05                	jns    801701 <ftruncate+0x58>
		return r;
  8016fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016ff:	eb 72                	jmp    801773 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801705:	8b 40 08             	mov    0x8(%rax),%eax
  801708:	83 e0 03             	and    $0x3,%eax
  80170b:	85 c0                	test   %eax,%eax
  80170d:	75 3a                	jne    801749 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80170f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801716:	00 00 00 
  801719:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80171c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801722:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801725:	89 c6                	mov    %eax,%esi
  801727:	48 bf 18 38 80 00 00 	movabs $0x803818,%rdi
  80172e:	00 00 00 
  801731:	b8 00 00 00 00       	mov    $0x0,%eax
  801736:	48 b9 47 29 80 00 00 	movabs $0x802947,%rcx
  80173d:	00 00 00 
  801740:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801742:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801747:	eb 2a                	jmp    801773 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  801749:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80174d:	48 8b 40 30          	mov    0x30(%rax),%rax
  801751:	48 85 c0             	test   %rax,%rax
  801754:	75 07                	jne    80175d <ftruncate+0xb4>
		return -E_NOT_SUPP;
  801756:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80175b:	eb 16                	jmp    801773 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80175d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801761:	48 8b 40 30          	mov    0x30(%rax),%rax
  801765:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801769:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80176c:	89 ce                	mov    %ecx,%esi
  80176e:	48 89 d7             	mov    %rdx,%rdi
  801771:	ff d0                	callq  *%rax
}
  801773:	c9                   	leaveq 
  801774:	c3                   	retq   

0000000000801775 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801775:	55                   	push   %rbp
  801776:	48 89 e5             	mov    %rsp,%rbp
  801779:	48 83 ec 30          	sub    $0x30,%rsp
  80177d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801780:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801784:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801788:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80178b:	48 89 d6             	mov    %rdx,%rsi
  80178e:	89 c7                	mov    %eax,%edi
  801790:	48 b8 14 10 80 00 00 	movabs $0x801014,%rax
  801797:	00 00 00 
  80179a:	ff d0                	callq  *%rax
  80179c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80179f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017a3:	78 24                	js     8017c9 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a9:	8b 00                	mov    (%rax),%eax
  8017ab:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8017af:	48 89 d6             	mov    %rdx,%rsi
  8017b2:	89 c7                	mov    %eax,%edi
  8017b4:	48 b8 6d 11 80 00 00 	movabs $0x80116d,%rax
  8017bb:	00 00 00 
  8017be:	ff d0                	callq  *%rax
  8017c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017c7:	79 05                	jns    8017ce <fstat+0x59>
		return r;
  8017c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017cc:	eb 5e                	jmp    80182c <fstat+0xb7>
	if (!dev->dev_stat)
  8017ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017d2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8017d6:	48 85 c0             	test   %rax,%rax
  8017d9:	75 07                	jne    8017e2 <fstat+0x6d>
		return -E_NOT_SUPP;
  8017db:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8017e0:	eb 4a                	jmp    80182c <fstat+0xb7>
	stat->st_name[0] = 0;
  8017e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017e6:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8017e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ed:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8017f4:	00 00 00 
	stat->st_isdir = 0;
  8017f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017fb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801802:	00 00 00 
	stat->st_dev = dev;
  801805:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801809:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80180d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  801814:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801818:	48 8b 40 28          	mov    0x28(%rax),%rax
  80181c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801820:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801824:	48 89 ce             	mov    %rcx,%rsi
  801827:	48 89 d7             	mov    %rdx,%rdi
  80182a:	ff d0                	callq  *%rax
}
  80182c:	c9                   	leaveq 
  80182d:	c3                   	retq   

000000000080182e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80182e:	55                   	push   %rbp
  80182f:	48 89 e5             	mov    %rsp,%rbp
  801832:	48 83 ec 20          	sub    $0x20,%rsp
  801836:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80183a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80183e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801842:	be 00 00 00 00       	mov    $0x0,%esi
  801847:	48 89 c7             	mov    %rax,%rdi
  80184a:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  801851:	00 00 00 
  801854:	ff d0                	callq  *%rax
  801856:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801859:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80185d:	79 05                	jns    801864 <stat+0x36>
		return fd;
  80185f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801862:	eb 2f                	jmp    801893 <stat+0x65>
	r = fstat(fd, stat);
  801864:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801868:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80186b:	48 89 d6             	mov    %rdx,%rsi
  80186e:	89 c7                	mov    %eax,%edi
  801870:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801877:	00 00 00 
  80187a:	ff d0                	callq  *%rax
  80187c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80187f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801882:	89 c7                	mov    %eax,%edi
  801884:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  80188b:	00 00 00 
  80188e:	ff d0                	callq  *%rax
	return r;
  801890:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801893:	c9                   	leaveq 
  801894:	c3                   	retq   

0000000000801895 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801895:	55                   	push   %rbp
  801896:	48 89 e5             	mov    %rsp,%rbp
  801899:	48 83 ec 10          	sub    $0x10,%rsp
  80189d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8018a4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8018ab:	00 00 00 
  8018ae:	8b 00                	mov    (%rax),%eax
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	75 1d                	jne    8018d1 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018b4:	bf 01 00 00 00       	mov    $0x1,%edi
  8018b9:	48 b8 83 36 80 00 00 	movabs $0x803683,%rax
  8018c0:	00 00 00 
  8018c3:	ff d0                	callq  *%rax
  8018c5:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8018cc:	00 00 00 
  8018cf:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018d1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8018d8:	00 00 00 
  8018db:	8b 00                	mov    (%rax),%eax
  8018dd:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8018e0:	b9 07 00 00 00       	mov    $0x7,%ecx
  8018e5:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8018ec:	00 00 00 
  8018ef:	89 c7                	mov    %eax,%edi
  8018f1:	48 b8 84 35 80 00 00 	movabs $0x803584,%rax
  8018f8:	00 00 00 
  8018fb:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8018fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801901:	ba 00 00 00 00       	mov    $0x0,%edx
  801906:	48 89 c6             	mov    %rax,%rsi
  801909:	bf 00 00 00 00       	mov    $0x0,%edi
  80190e:	48 b8 d1 34 80 00 00 	movabs $0x8034d1,%rax
  801915:	00 00 00 
  801918:	ff d0                	callq  *%rax
}
  80191a:	c9                   	leaveq 
  80191b:	c3                   	retq   

000000000080191c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80191c:	55                   	push   %rbp
  80191d:	48 89 e5             	mov    %rsp,%rbp
  801920:	48 83 ec 20          	sub    $0x20,%rsp
  801924:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801928:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  80192b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80192f:	48 89 c7             	mov    %rax,%rdi
  801932:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  801939:	00 00 00 
  80193c:	ff d0                	callq  *%rax
  80193e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801943:	7e 0a                	jle    80194f <open+0x33>
		return -E_BAD_PATH;
  801945:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80194a:	e9 a5 00 00 00       	jmpq   8019f4 <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  80194f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801953:	48 89 c7             	mov    %rax,%rdi
  801956:	48 b8 7c 0f 80 00 00 	movabs $0x800f7c,%rax
  80195d:	00 00 00 
  801960:	ff d0                	callq  *%rax
  801962:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801965:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801969:	79 08                	jns    801973 <open+0x57>
		return ret;
  80196b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196e:	e9 81 00 00 00       	jmpq   8019f4 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  801973:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80197a:	00 00 00 
  80197d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801980:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  801986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80198a:	48 89 c6             	mov    %rax,%rsi
  80198d:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801994:	00 00 00 
  801997:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  80199e:	00 00 00 
  8019a1:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  8019a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a7:	48 89 c6             	mov    %rax,%rsi
  8019aa:	bf 01 00 00 00       	mov    $0x1,%edi
  8019af:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  8019b6:	00 00 00 
  8019b9:	ff d0                	callq  *%rax
  8019bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019c2:	79 1d                	jns    8019e1 <open+0xc5>
	{
		fd_close(fd,0);
  8019c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019c8:	be 00 00 00 00       	mov    $0x0,%esi
  8019cd:	48 89 c7             	mov    %rax,%rdi
  8019d0:	48 b8 a4 10 80 00 00 	movabs $0x8010a4,%rax
  8019d7:	00 00 00 
  8019da:	ff d0                	callq  *%rax
		return ret;
  8019dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019df:	eb 13                	jmp    8019f4 <open+0xd8>
	}
	return fd2num (fd);
  8019e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019e5:	48 89 c7             	mov    %rax,%rdi
  8019e8:	48 b8 2e 0f 80 00 00 	movabs $0x800f2e,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  8019f4:	c9                   	leaveq 
  8019f5:	c3                   	retq   

00000000008019f6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019f6:	55                   	push   %rbp
  8019f7:	48 89 e5             	mov    %rsp,%rbp
  8019fa:	48 83 ec 10          	sub    $0x10,%rsp
  8019fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a06:	8b 50 0c             	mov    0xc(%rax),%edx
  801a09:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a10:	00 00 00 
  801a13:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801a15:	be 00 00 00 00       	mov    $0x0,%esi
  801a1a:	bf 06 00 00 00       	mov    $0x6,%edi
  801a1f:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801a26:	00 00 00 
  801a29:	ff d0                	callq  *%rax
}
  801a2b:	c9                   	leaveq 
  801a2c:	c3                   	retq   

0000000000801a2d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a2d:	55                   	push   %rbp
  801a2e:	48 89 e5             	mov    %rsp,%rbp
  801a31:	48 83 ec 30          	sub    $0x30,%rsp
  801a35:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a39:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a3d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  801a41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a45:	8b 50 0c             	mov    0xc(%rax),%edx
  801a48:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a4f:	00 00 00 
  801a52:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  801a54:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a5b:	00 00 00 
  801a5e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a62:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  801a66:	be 00 00 00 00       	mov    $0x0,%esi
  801a6b:	bf 03 00 00 00       	mov    $0x3,%edi
  801a70:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801a77:	00 00 00 
  801a7a:	ff d0                	callq  *%rax
  801a7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a83:	79 05                	jns    801a8a <devfile_read+0x5d>
		return ret;
  801a85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a88:	eb 26                	jmp    801ab0 <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  801a8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8d:	48 63 d0             	movslq %eax,%rdx
  801a90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a94:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801a9b:	00 00 00 
  801a9e:	48 89 c7             	mov    %rax,%rdi
  801aa1:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  801aa8:	00 00 00 
  801aab:	ff d0                	callq  *%rax
	return ret;
  801aad:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  801ab0:	c9                   	leaveq 
  801ab1:	c3                   	retq   

0000000000801ab2 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ab2:	55                   	push   %rbp
  801ab3:	48 89 e5             	mov    %rsp,%rbp
  801ab6:	48 83 ec 30          	sub    $0x30,%rsp
  801aba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801abe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ac2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  801ac6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aca:	8b 50 0c             	mov    0xc(%rax),%edx
  801acd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801ad4:	00 00 00 
  801ad7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  801ad9:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  801ade:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801ae5:	00 
  801ae6:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  801aeb:	48 89 c2             	mov    %rax,%rdx
  801aee:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801af5:	00 00 00 
  801af8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801afc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b03:	00 00 00 
  801b06:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801b0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b0e:	48 89 c6             	mov    %rax,%rsi
  801b11:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  801b18:	00 00 00 
  801b1b:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  801b22:	00 00 00 
  801b25:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  801b27:	be 00 00 00 00       	mov    $0x0,%esi
  801b2c:	bf 04 00 00 00       	mov    $0x4,%edi
  801b31:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801b38:	00 00 00 
  801b3b:	ff d0                	callq  *%rax
  801b3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b44:	79 05                	jns    801b4b <devfile_write+0x99>
		return ret;
  801b46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b49:	eb 03                	jmp    801b4e <devfile_write+0x9c>
	
	return ret;
  801b4b:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  801b4e:	c9                   	leaveq 
  801b4f:	c3                   	retq   

0000000000801b50 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b50:	55                   	push   %rbp
  801b51:	48 89 e5             	mov    %rsp,%rbp
  801b54:	48 83 ec 20          	sub    $0x20,%rsp
  801b58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b5c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b64:	8b 50 0c             	mov    0xc(%rax),%edx
  801b67:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b6e:	00 00 00 
  801b71:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b73:	be 00 00 00 00       	mov    $0x0,%esi
  801b78:	bf 05 00 00 00       	mov    $0x5,%edi
  801b7d:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801b84:	00 00 00 
  801b87:	ff d0                	callq  *%rax
  801b89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b90:	79 05                	jns    801b97 <devfile_stat+0x47>
		return r;
  801b92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b95:	eb 56                	jmp    801bed <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b9b:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801ba2:	00 00 00 
  801ba5:	48 89 c7             	mov    %rax,%rdi
  801ba8:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  801baf:	00 00 00 
  801bb2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801bb4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801bbb:	00 00 00 
  801bbe:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801bc4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bc8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bce:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801bd5:	00 00 00 
  801bd8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801bde:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801be2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801be8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bed:	c9                   	leaveq 
  801bee:	c3                   	retq   

0000000000801bef <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bef:	55                   	push   %rbp
  801bf0:	48 89 e5             	mov    %rsp,%rbp
  801bf3:	48 83 ec 10          	sub    $0x10,%rsp
  801bf7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bfb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c02:	8b 50 0c             	mov    0xc(%rax),%edx
  801c05:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c0c:	00 00 00 
  801c0f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801c11:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c18:	00 00 00 
  801c1b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c1e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c21:	be 00 00 00 00       	mov    $0x0,%esi
  801c26:	bf 02 00 00 00       	mov    $0x2,%edi
  801c2b:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801c32:	00 00 00 
  801c35:	ff d0                	callq  *%rax
}
  801c37:	c9                   	leaveq 
  801c38:	c3                   	retq   

0000000000801c39 <remove>:

// Delete a file
int
remove(const char *path)
{
  801c39:	55                   	push   %rbp
  801c3a:	48 89 e5             	mov    %rsp,%rbp
  801c3d:	48 83 ec 10          	sub    $0x10,%rsp
  801c41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801c45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c49:	48 89 c7             	mov    %rax,%rdi
  801c4c:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  801c53:	00 00 00 
  801c56:	ff d0                	callq  *%rax
  801c58:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c5d:	7e 07                	jle    801c66 <remove+0x2d>
		return -E_BAD_PATH;
  801c5f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801c64:	eb 33                	jmp    801c99 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801c66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c6a:	48 89 c6             	mov    %rax,%rsi
  801c6d:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801c74:	00 00 00 
  801c77:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  801c7e:	00 00 00 
  801c81:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801c83:	be 00 00 00 00       	mov    $0x0,%esi
  801c88:	bf 07 00 00 00       	mov    $0x7,%edi
  801c8d:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801c94:	00 00 00 
  801c97:	ff d0                	callq  *%rax
}
  801c99:	c9                   	leaveq 
  801c9a:	c3                   	retq   

0000000000801c9b <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801c9b:	55                   	push   %rbp
  801c9c:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c9f:	be 00 00 00 00       	mov    $0x0,%esi
  801ca4:	bf 08 00 00 00       	mov    $0x8,%edi
  801ca9:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801cb0:	00 00 00 
  801cb3:	ff d0                	callq  *%rax
}
  801cb5:	5d                   	pop    %rbp
  801cb6:	c3                   	retq   

0000000000801cb7 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801cb7:	55                   	push   %rbp
  801cb8:	48 89 e5             	mov    %rsp,%rbp
  801cbb:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801cc2:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801cc9:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801cd0:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801cd7:	be 00 00 00 00       	mov    $0x0,%esi
  801cdc:	48 89 c7             	mov    %rax,%rdi
  801cdf:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  801ce6:	00 00 00 
  801ce9:	ff d0                	callq  *%rax
  801ceb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801cee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cf2:	79 28                	jns    801d1c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf7:	89 c6                	mov    %eax,%esi
  801cf9:	48 bf 3e 38 80 00 00 	movabs $0x80383e,%rdi
  801d00:	00 00 00 
  801d03:	b8 00 00 00 00       	mov    $0x0,%eax
  801d08:	48 ba 47 29 80 00 00 	movabs $0x802947,%rdx
  801d0f:	00 00 00 
  801d12:	ff d2                	callq  *%rdx
		return fd_src;
  801d14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d17:	e9 74 01 00 00       	jmpq   801e90 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801d1c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801d23:	be 01 01 00 00       	mov    $0x101,%esi
  801d28:	48 89 c7             	mov    %rax,%rdi
  801d2b:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  801d32:	00 00 00 
  801d35:	ff d0                	callq  *%rax
  801d37:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801d3a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801d3e:	79 39                	jns    801d79 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801d40:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d43:	89 c6                	mov    %eax,%esi
  801d45:	48 bf 54 38 80 00 00 	movabs $0x803854,%rdi
  801d4c:	00 00 00 
  801d4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d54:	48 ba 47 29 80 00 00 	movabs $0x802947,%rdx
  801d5b:	00 00 00 
  801d5e:	ff d2                	callq  *%rdx
		close(fd_src);
  801d60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d63:	89 c7                	mov    %eax,%edi
  801d65:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  801d6c:	00 00 00 
  801d6f:	ff d0                	callq  *%rax
		return fd_dest;
  801d71:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d74:	e9 17 01 00 00       	jmpq   801e90 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801d79:	eb 74                	jmp    801def <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801d7b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d7e:	48 63 d0             	movslq %eax,%rdx
  801d81:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801d88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d8b:	48 89 ce             	mov    %rcx,%rsi
  801d8e:	89 c7                	mov    %eax,%edi
  801d90:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  801d97:	00 00 00 
  801d9a:	ff d0                	callq  *%rax
  801d9c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  801d9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801da3:	79 4a                	jns    801def <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801da5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801da8:	89 c6                	mov    %eax,%esi
  801daa:	48 bf 6e 38 80 00 00 	movabs $0x80386e,%rdi
  801db1:	00 00 00 
  801db4:	b8 00 00 00 00       	mov    $0x0,%eax
  801db9:	48 ba 47 29 80 00 00 	movabs $0x802947,%rdx
  801dc0:	00 00 00 
  801dc3:	ff d2                	callq  *%rdx
			close(fd_src);
  801dc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc8:	89 c7                	mov    %eax,%edi
  801dca:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  801dd1:	00 00 00 
  801dd4:	ff d0                	callq  *%rax
			close(fd_dest);
  801dd6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dd9:	89 c7                	mov    %eax,%edi
  801ddb:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  801de2:	00 00 00 
  801de5:	ff d0                	callq  *%rax
			return write_size;
  801de7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801dea:	e9 a1 00 00 00       	jmpq   801e90 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801def:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801df6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df9:	ba 00 02 00 00       	mov    $0x200,%edx
  801dfe:	48 89 ce             	mov    %rcx,%rsi
  801e01:	89 c7                	mov    %eax,%edi
  801e03:	48 b8 46 14 80 00 00 	movabs $0x801446,%rax
  801e0a:	00 00 00 
  801e0d:	ff d0                	callq  *%rax
  801e0f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801e12:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e16:	0f 8f 5f ff ff ff    	jg     801d7b <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  801e1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e20:	79 47                	jns    801e69 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801e22:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e25:	89 c6                	mov    %eax,%esi
  801e27:	48 bf 81 38 80 00 00 	movabs $0x803881,%rdi
  801e2e:	00 00 00 
  801e31:	b8 00 00 00 00       	mov    $0x0,%eax
  801e36:	48 ba 47 29 80 00 00 	movabs $0x802947,%rdx
  801e3d:	00 00 00 
  801e40:	ff d2                	callq  *%rdx
		close(fd_src);
  801e42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e45:	89 c7                	mov    %eax,%edi
  801e47:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  801e4e:	00 00 00 
  801e51:	ff d0                	callq  *%rax
		close(fd_dest);
  801e53:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e56:	89 c7                	mov    %eax,%edi
  801e58:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  801e5f:	00 00 00 
  801e62:	ff d0                	callq  *%rax
		return read_size;
  801e64:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e67:	eb 27                	jmp    801e90 <copy+0x1d9>
	}
	close(fd_src);
  801e69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e6c:	89 c7                	mov    %eax,%edi
  801e6e:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  801e75:	00 00 00 
  801e78:	ff d0                	callq  *%rax
	close(fd_dest);
  801e7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e7d:	89 c7                	mov    %eax,%edi
  801e7f:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  801e86:	00 00 00 
  801e89:	ff d0                	callq  *%rax
	return 0;
  801e8b:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  801e90:	c9                   	leaveq 
  801e91:	c3                   	retq   

0000000000801e92 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801e92:	55                   	push   %rbp
  801e93:	48 89 e5             	mov    %rsp,%rbp
  801e96:	53                   	push   %rbx
  801e97:	48 83 ec 38          	sub    $0x38,%rsp
  801e9b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801e9f:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801ea3:	48 89 c7             	mov    %rax,%rdi
  801ea6:	48 b8 7c 0f 80 00 00 	movabs $0x800f7c,%rax
  801ead:	00 00 00 
  801eb0:	ff d0                	callq  *%rax
  801eb2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801eb5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801eb9:	0f 88 bf 01 00 00    	js     80207e <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec3:	ba 07 04 00 00       	mov    $0x407,%edx
  801ec8:	48 89 c6             	mov    %rax,%rsi
  801ecb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ed0:	48 b8 93 0b 80 00 00 	movabs $0x800b93,%rax
  801ed7:	00 00 00 
  801eda:	ff d0                	callq  *%rax
  801edc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801edf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ee3:	0f 88 95 01 00 00    	js     80207e <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ee9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801eed:	48 89 c7             	mov    %rax,%rdi
  801ef0:	48 b8 7c 0f 80 00 00 	movabs $0x800f7c,%rax
  801ef7:	00 00 00 
  801efa:	ff d0                	callq  *%rax
  801efc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801eff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f03:	0f 88 5d 01 00 00    	js     802066 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f09:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f0d:	ba 07 04 00 00       	mov    $0x407,%edx
  801f12:	48 89 c6             	mov    %rax,%rsi
  801f15:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1a:	48 b8 93 0b 80 00 00 	movabs $0x800b93,%rax
  801f21:	00 00 00 
  801f24:	ff d0                	callq  *%rax
  801f26:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f29:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f2d:	0f 88 33 01 00 00    	js     802066 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f37:	48 89 c7             	mov    %rax,%rdi
  801f3a:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  801f41:	00 00 00 
  801f44:	ff d0                	callq  *%rax
  801f46:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f4e:	ba 07 04 00 00       	mov    $0x407,%edx
  801f53:	48 89 c6             	mov    %rax,%rsi
  801f56:	bf 00 00 00 00       	mov    $0x0,%edi
  801f5b:	48 b8 93 0b 80 00 00 	movabs $0x800b93,%rax
  801f62:	00 00 00 
  801f65:	ff d0                	callq  *%rax
  801f67:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f6e:	79 05                	jns    801f75 <pipe+0xe3>
		goto err2;
  801f70:	e9 d9 00 00 00       	jmpq   80204e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f75:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f79:	48 89 c7             	mov    %rax,%rdi
  801f7c:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  801f83:	00 00 00 
  801f86:	ff d0                	callq  *%rax
  801f88:	48 89 c2             	mov    %rax,%rdx
  801f8b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f8f:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801f95:	48 89 d1             	mov    %rdx,%rcx
  801f98:	ba 00 00 00 00       	mov    $0x0,%edx
  801f9d:	48 89 c6             	mov    %rax,%rsi
  801fa0:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa5:	48 b8 e3 0b 80 00 00 	movabs $0x800be3,%rax
  801fac:	00 00 00 
  801faf:	ff d0                	callq  *%rax
  801fb1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801fb4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fb8:	79 1b                	jns    801fd5 <pipe+0x143>
		goto err3;
  801fba:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  801fbb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fbf:	48 89 c6             	mov    %rax,%rsi
  801fc2:	bf 00 00 00 00       	mov    $0x0,%edi
  801fc7:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  801fce:	00 00 00 
  801fd1:	ff d0                	callq  *%rax
  801fd3:	eb 79                	jmp    80204e <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801fd5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd9:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  801fe0:	00 00 00 
  801fe3:	8b 12                	mov    (%rdx),%edx
  801fe5:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801fe7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801feb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801ff2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ff6:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  801ffd:	00 00 00 
  802000:	8b 12                	mov    (%rdx),%edx
  802002:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802004:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802008:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80200f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802013:	48 89 c7             	mov    %rax,%rdi
  802016:	48 b8 2e 0f 80 00 00 	movabs $0x800f2e,%rax
  80201d:	00 00 00 
  802020:	ff d0                	callq  *%rax
  802022:	89 c2                	mov    %eax,%edx
  802024:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802028:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80202a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80202e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802032:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802036:	48 89 c7             	mov    %rax,%rdi
  802039:	48 b8 2e 0f 80 00 00 	movabs $0x800f2e,%rax
  802040:	00 00 00 
  802043:	ff d0                	callq  *%rax
  802045:	89 03                	mov    %eax,(%rbx)
	return 0;
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
  80204c:	eb 33                	jmp    802081 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80204e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802052:	48 89 c6             	mov    %rax,%rsi
  802055:	bf 00 00 00 00       	mov    $0x0,%edi
  80205a:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  802061:	00 00 00 
  802064:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802066:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80206a:	48 89 c6             	mov    %rax,%rsi
  80206d:	bf 00 00 00 00       	mov    $0x0,%edi
  802072:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  802079:	00 00 00 
  80207c:	ff d0                	callq  *%rax
err:
	return r;
  80207e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802081:	48 83 c4 38          	add    $0x38,%rsp
  802085:	5b                   	pop    %rbx
  802086:	5d                   	pop    %rbp
  802087:	c3                   	retq   

0000000000802088 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802088:	55                   	push   %rbp
  802089:	48 89 e5             	mov    %rsp,%rbp
  80208c:	53                   	push   %rbx
  80208d:	48 83 ec 28          	sub    $0x28,%rsp
  802091:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802095:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802099:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8020a0:	00 00 00 
  8020a3:	48 8b 00             	mov    (%rax),%rax
  8020a6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8020ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8020af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b3:	48 89 c7             	mov    %rax,%rdi
  8020b6:	48 b8 f5 36 80 00 00 	movabs $0x8036f5,%rax
  8020bd:	00 00 00 
  8020c0:	ff d0                	callq  *%rax
  8020c2:	89 c3                	mov    %eax,%ebx
  8020c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8020c8:	48 89 c7             	mov    %rax,%rdi
  8020cb:	48 b8 f5 36 80 00 00 	movabs $0x8036f5,%rax
  8020d2:	00 00 00 
  8020d5:	ff d0                	callq  *%rax
  8020d7:	39 c3                	cmp    %eax,%ebx
  8020d9:	0f 94 c0             	sete   %al
  8020dc:	0f b6 c0             	movzbl %al,%eax
  8020df:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8020e2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8020e9:	00 00 00 
  8020ec:	48 8b 00             	mov    (%rax),%rax
  8020ef:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8020f5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8020f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020fb:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8020fe:	75 05                	jne    802105 <_pipeisclosed+0x7d>
			return ret;
  802100:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802103:	eb 4f                	jmp    802154 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802105:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802108:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80210b:	74 42                	je     80214f <_pipeisclosed+0xc7>
  80210d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802111:	75 3c                	jne    80214f <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802113:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80211a:	00 00 00 
  80211d:	48 8b 00             	mov    (%rax),%rax
  802120:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802126:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802129:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80212c:	89 c6                	mov    %eax,%esi
  80212e:	48 bf a1 38 80 00 00 	movabs $0x8038a1,%rdi
  802135:	00 00 00 
  802138:	b8 00 00 00 00       	mov    $0x0,%eax
  80213d:	49 b8 47 29 80 00 00 	movabs $0x802947,%r8
  802144:	00 00 00 
  802147:	41 ff d0             	callq  *%r8
	}
  80214a:	e9 4a ff ff ff       	jmpq   802099 <_pipeisclosed+0x11>
  80214f:	e9 45 ff ff ff       	jmpq   802099 <_pipeisclosed+0x11>
}
  802154:	48 83 c4 28          	add    $0x28,%rsp
  802158:	5b                   	pop    %rbx
  802159:	5d                   	pop    %rbp
  80215a:	c3                   	retq   

000000000080215b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80215b:	55                   	push   %rbp
  80215c:	48 89 e5             	mov    %rsp,%rbp
  80215f:	48 83 ec 30          	sub    $0x30,%rsp
  802163:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802166:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80216a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80216d:	48 89 d6             	mov    %rdx,%rsi
  802170:	89 c7                	mov    %eax,%edi
  802172:	48 b8 14 10 80 00 00 	movabs $0x801014,%rax
  802179:	00 00 00 
  80217c:	ff d0                	callq  *%rax
  80217e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802181:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802185:	79 05                	jns    80218c <pipeisclosed+0x31>
		return r;
  802187:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80218a:	eb 31                	jmp    8021bd <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80218c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802190:	48 89 c7             	mov    %rax,%rdi
  802193:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  80219a:	00 00 00 
  80219d:	ff d0                	callq  *%rax
  80219f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8021a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021ab:	48 89 d6             	mov    %rdx,%rsi
  8021ae:	48 89 c7             	mov    %rax,%rdi
  8021b1:	48 b8 88 20 80 00 00 	movabs $0x802088,%rax
  8021b8:	00 00 00 
  8021bb:	ff d0                	callq  *%rax
}
  8021bd:	c9                   	leaveq 
  8021be:	c3                   	retq   

00000000008021bf <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021bf:	55                   	push   %rbp
  8021c0:	48 89 e5             	mov    %rsp,%rbp
  8021c3:	48 83 ec 40          	sub    $0x40,%rsp
  8021c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8021cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021cf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8021d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021d7:	48 89 c7             	mov    %rax,%rdi
  8021da:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  8021e1:	00 00 00 
  8021e4:	ff d0                	callq  *%rax
  8021e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8021ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021ee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8021f2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8021f9:	00 
  8021fa:	e9 92 00 00 00       	jmpq   802291 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8021ff:	eb 41                	jmp    802242 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802201:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802206:	74 09                	je     802211 <devpipe_read+0x52>
				return i;
  802208:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80220c:	e9 92 00 00 00       	jmpq   8022a3 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802211:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802215:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802219:	48 89 d6             	mov    %rdx,%rsi
  80221c:	48 89 c7             	mov    %rax,%rdi
  80221f:	48 b8 88 20 80 00 00 	movabs $0x802088,%rax
  802226:	00 00 00 
  802229:	ff d0                	callq  *%rax
  80222b:	85 c0                	test   %eax,%eax
  80222d:	74 07                	je     802236 <devpipe_read+0x77>
				return 0;
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
  802234:	eb 6d                	jmp    8022a3 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802236:	48 b8 55 0b 80 00 00 	movabs $0x800b55,%rax
  80223d:	00 00 00 
  802240:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802242:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802246:	8b 10                	mov    (%rax),%edx
  802248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224c:	8b 40 04             	mov    0x4(%rax),%eax
  80224f:	39 c2                	cmp    %eax,%edx
  802251:	74 ae                	je     802201 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802253:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802257:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80225b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80225f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802263:	8b 00                	mov    (%rax),%eax
  802265:	99                   	cltd   
  802266:	c1 ea 1b             	shr    $0x1b,%edx
  802269:	01 d0                	add    %edx,%eax
  80226b:	83 e0 1f             	and    $0x1f,%eax
  80226e:	29 d0                	sub    %edx,%eax
  802270:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802274:	48 98                	cltq   
  802276:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80227b:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80227d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802281:	8b 00                	mov    (%rax),%eax
  802283:	8d 50 01             	lea    0x1(%rax),%edx
  802286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80228a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80228c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802291:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802295:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802299:	0f 82 60 ff ff ff    	jb     8021ff <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80229f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8022a3:	c9                   	leaveq 
  8022a4:	c3                   	retq   

00000000008022a5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022a5:	55                   	push   %rbp
  8022a6:	48 89 e5             	mov    %rsp,%rbp
  8022a9:	48 83 ec 40          	sub    $0x40,%rsp
  8022ad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8022b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022b5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8022b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022bd:	48 89 c7             	mov    %rax,%rdi
  8022c0:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  8022c7:	00 00 00 
  8022ca:	ff d0                	callq  *%rax
  8022cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8022d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022d4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8022d8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8022df:	00 
  8022e0:	e9 8e 00 00 00       	jmpq   802373 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022e5:	eb 31                	jmp    802318 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8022e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ef:	48 89 d6             	mov    %rdx,%rsi
  8022f2:	48 89 c7             	mov    %rax,%rdi
  8022f5:	48 b8 88 20 80 00 00 	movabs $0x802088,%rax
  8022fc:	00 00 00 
  8022ff:	ff d0                	callq  *%rax
  802301:	85 c0                	test   %eax,%eax
  802303:	74 07                	je     80230c <devpipe_write+0x67>
				return 0;
  802305:	b8 00 00 00 00       	mov    $0x0,%eax
  80230a:	eb 79                	jmp    802385 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80230c:	48 b8 55 0b 80 00 00 	movabs $0x800b55,%rax
  802313:	00 00 00 
  802316:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802318:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80231c:	8b 40 04             	mov    0x4(%rax),%eax
  80231f:	48 63 d0             	movslq %eax,%rdx
  802322:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802326:	8b 00                	mov    (%rax),%eax
  802328:	48 98                	cltq   
  80232a:	48 83 c0 20          	add    $0x20,%rax
  80232e:	48 39 c2             	cmp    %rax,%rdx
  802331:	73 b4                	jae    8022e7 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802337:	8b 40 04             	mov    0x4(%rax),%eax
  80233a:	99                   	cltd   
  80233b:	c1 ea 1b             	shr    $0x1b,%edx
  80233e:	01 d0                	add    %edx,%eax
  802340:	83 e0 1f             	and    $0x1f,%eax
  802343:	29 d0                	sub    %edx,%eax
  802345:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802349:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80234d:	48 01 ca             	add    %rcx,%rdx
  802350:	0f b6 0a             	movzbl (%rdx),%ecx
  802353:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802357:	48 98                	cltq   
  802359:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80235d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802361:	8b 40 04             	mov    0x4(%rax),%eax
  802364:	8d 50 01             	lea    0x1(%rax),%edx
  802367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80236b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80236e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802373:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802377:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80237b:	0f 82 64 ff ff ff    	jb     8022e5 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802385:	c9                   	leaveq 
  802386:	c3                   	retq   

0000000000802387 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802387:	55                   	push   %rbp
  802388:	48 89 e5             	mov    %rsp,%rbp
  80238b:	48 83 ec 20          	sub    $0x20,%rsp
  80238f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802393:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802397:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80239b:	48 89 c7             	mov    %rax,%rdi
  80239e:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  8023a5:	00 00 00 
  8023a8:	ff d0                	callq  *%rax
  8023aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8023ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b2:	48 be b4 38 80 00 00 	movabs $0x8038b4,%rsi
  8023b9:	00 00 00 
  8023bc:	48 89 c7             	mov    %rax,%rdi
  8023bf:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  8023c6:	00 00 00 
  8023c9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8023cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023cf:	8b 50 04             	mov    0x4(%rax),%edx
  8023d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d6:	8b 00                	mov    (%rax),%eax
  8023d8:	29 c2                	sub    %eax,%edx
  8023da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023de:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8023e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023e8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8023ef:	00 00 00 
	stat->st_dev = &devpipe;
  8023f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023f6:	48 b9 e0 50 80 00 00 	movabs $0x8050e0,%rcx
  8023fd:	00 00 00 
  802400:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802407:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240c:	c9                   	leaveq 
  80240d:	c3                   	retq   

000000000080240e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80240e:	55                   	push   %rbp
  80240f:	48 89 e5             	mov    %rsp,%rbp
  802412:	48 83 ec 10          	sub    $0x10,%rsp
  802416:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80241a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80241e:	48 89 c6             	mov    %rax,%rsi
  802421:	bf 00 00 00 00       	mov    $0x0,%edi
  802426:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  80242d:	00 00 00 
  802430:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802432:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802436:	48 89 c7             	mov    %rax,%rdi
  802439:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  802440:	00 00 00 
  802443:	ff d0                	callq  *%rax
  802445:	48 89 c6             	mov    %rax,%rsi
  802448:	bf 00 00 00 00       	mov    $0x0,%edi
  80244d:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  802454:	00 00 00 
  802457:	ff d0                	callq  *%rax
}
  802459:	c9                   	leaveq 
  80245a:	c3                   	retq   

000000000080245b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80245b:	55                   	push   %rbp
  80245c:	48 89 e5             	mov    %rsp,%rbp
  80245f:	48 83 ec 20          	sub    $0x20,%rsp
  802463:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802466:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802469:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80246c:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802470:	be 01 00 00 00       	mov    $0x1,%esi
  802475:	48 89 c7             	mov    %rax,%rdi
  802478:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  80247f:	00 00 00 
  802482:	ff d0                	callq  *%rax
}
  802484:	c9                   	leaveq 
  802485:	c3                   	retq   

0000000000802486 <getchar>:

int
getchar(void)
{
  802486:	55                   	push   %rbp
  802487:	48 89 e5             	mov    %rsp,%rbp
  80248a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80248e:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802492:	ba 01 00 00 00       	mov    $0x1,%edx
  802497:	48 89 c6             	mov    %rax,%rsi
  80249a:	bf 00 00 00 00       	mov    $0x0,%edi
  80249f:	48 b8 46 14 80 00 00 	movabs $0x801446,%rax
  8024a6:	00 00 00 
  8024a9:	ff d0                	callq  *%rax
  8024ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8024ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b2:	79 05                	jns    8024b9 <getchar+0x33>
		return r;
  8024b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b7:	eb 14                	jmp    8024cd <getchar+0x47>
	if (r < 1)
  8024b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024bd:	7f 07                	jg     8024c6 <getchar+0x40>
		return -E_EOF;
  8024bf:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8024c4:	eb 07                	jmp    8024cd <getchar+0x47>
	return c;
  8024c6:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8024ca:	0f b6 c0             	movzbl %al,%eax
}
  8024cd:	c9                   	leaveq 
  8024ce:	c3                   	retq   

00000000008024cf <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8024cf:	55                   	push   %rbp
  8024d0:	48 89 e5             	mov    %rsp,%rbp
  8024d3:	48 83 ec 20          	sub    $0x20,%rsp
  8024d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024da:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024e1:	48 89 d6             	mov    %rdx,%rsi
  8024e4:	89 c7                	mov    %eax,%edi
  8024e6:	48 b8 14 10 80 00 00 	movabs $0x801014,%rax
  8024ed:	00 00 00 
  8024f0:	ff d0                	callq  *%rax
  8024f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f9:	79 05                	jns    802500 <iscons+0x31>
		return r;
  8024fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024fe:	eb 1a                	jmp    80251a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802504:	8b 10                	mov    (%rax),%edx
  802506:	48 b8 20 51 80 00 00 	movabs $0x805120,%rax
  80250d:	00 00 00 
  802510:	8b 00                	mov    (%rax),%eax
  802512:	39 c2                	cmp    %eax,%edx
  802514:	0f 94 c0             	sete   %al
  802517:	0f b6 c0             	movzbl %al,%eax
}
  80251a:	c9                   	leaveq 
  80251b:	c3                   	retq   

000000000080251c <opencons>:

int
opencons(void)
{
  80251c:	55                   	push   %rbp
  80251d:	48 89 e5             	mov    %rsp,%rbp
  802520:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802524:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802528:	48 89 c7             	mov    %rax,%rdi
  80252b:	48 b8 7c 0f 80 00 00 	movabs $0x800f7c,%rax
  802532:	00 00 00 
  802535:	ff d0                	callq  *%rax
  802537:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80253a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253e:	79 05                	jns    802545 <opencons+0x29>
		return r;
  802540:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802543:	eb 5b                	jmp    8025a0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802545:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802549:	ba 07 04 00 00       	mov    $0x407,%edx
  80254e:	48 89 c6             	mov    %rax,%rsi
  802551:	bf 00 00 00 00       	mov    $0x0,%edi
  802556:	48 b8 93 0b 80 00 00 	movabs $0x800b93,%rax
  80255d:	00 00 00 
  802560:	ff d0                	callq  *%rax
  802562:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802565:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802569:	79 05                	jns    802570 <opencons+0x54>
		return r;
  80256b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256e:	eb 30                	jmp    8025a0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802570:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802574:	48 ba 20 51 80 00 00 	movabs $0x805120,%rdx
  80257b:	00 00 00 
  80257e:	8b 12                	mov    (%rdx),%edx
  802580:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802582:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802586:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80258d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802591:	48 89 c7             	mov    %rax,%rdi
  802594:	48 b8 2e 0f 80 00 00 	movabs $0x800f2e,%rax
  80259b:	00 00 00 
  80259e:	ff d0                	callq  *%rax
}
  8025a0:	c9                   	leaveq 
  8025a1:	c3                   	retq   

00000000008025a2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025a2:	55                   	push   %rbp
  8025a3:	48 89 e5             	mov    %rsp,%rbp
  8025a6:	48 83 ec 30          	sub    $0x30,%rsp
  8025aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8025b6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8025bb:	75 07                	jne    8025c4 <devcons_read+0x22>
		return 0;
  8025bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c2:	eb 4b                	jmp    80260f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8025c4:	eb 0c                	jmp    8025d2 <devcons_read+0x30>
		sys_yield();
  8025c6:	48 b8 55 0b 80 00 00 	movabs $0x800b55,%rax
  8025cd:	00 00 00 
  8025d0:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8025d2:	48 b8 95 0a 80 00 00 	movabs $0x800a95,%rax
  8025d9:	00 00 00 
  8025dc:	ff d0                	callq  *%rax
  8025de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e5:	74 df                	je     8025c6 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8025e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025eb:	79 05                	jns    8025f2 <devcons_read+0x50>
		return c;
  8025ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f0:	eb 1d                	jmp    80260f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8025f2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8025f6:	75 07                	jne    8025ff <devcons_read+0x5d>
		return 0;
  8025f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fd:	eb 10                	jmp    80260f <devcons_read+0x6d>
	*(char*)vbuf = c;
  8025ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802602:	89 c2                	mov    %eax,%edx
  802604:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802608:	88 10                	mov    %dl,(%rax)
	return 1;
  80260a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80260f:	c9                   	leaveq 
  802610:	c3                   	retq   

0000000000802611 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802611:	55                   	push   %rbp
  802612:	48 89 e5             	mov    %rsp,%rbp
  802615:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80261c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  802623:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80262a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802631:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802638:	eb 76                	jmp    8026b0 <devcons_write+0x9f>
		m = n - tot;
  80263a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802641:	89 c2                	mov    %eax,%edx
  802643:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802646:	29 c2                	sub    %eax,%edx
  802648:	89 d0                	mov    %edx,%eax
  80264a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80264d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802650:	83 f8 7f             	cmp    $0x7f,%eax
  802653:	76 07                	jbe    80265c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  802655:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80265c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80265f:	48 63 d0             	movslq %eax,%rdx
  802662:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802665:	48 63 c8             	movslq %eax,%rcx
  802668:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80266f:	48 01 c1             	add    %rax,%rcx
  802672:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802679:	48 89 ce             	mov    %rcx,%rsi
  80267c:	48 89 c7             	mov    %rax,%rdi
  80267f:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  802686:	00 00 00 
  802689:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80268b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80268e:	48 63 d0             	movslq %eax,%rdx
  802691:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802698:	48 89 d6             	mov    %rdx,%rsi
  80269b:	48 89 c7             	mov    %rax,%rdi
  80269e:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  8026a5:	00 00 00 
  8026a8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026ad:	01 45 fc             	add    %eax,-0x4(%rbp)
  8026b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b3:	48 98                	cltq   
  8026b5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8026bc:	0f 82 78 ff ff ff    	jb     80263a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8026c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026c5:	c9                   	leaveq 
  8026c6:	c3                   	retq   

00000000008026c7 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8026c7:	55                   	push   %rbp
  8026c8:	48 89 e5             	mov    %rsp,%rbp
  8026cb:	48 83 ec 08          	sub    $0x8,%rsp
  8026cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8026d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d8:	c9                   	leaveq 
  8026d9:	c3                   	retq   

00000000008026da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026da:	55                   	push   %rbp
  8026db:	48 89 e5             	mov    %rsp,%rbp
  8026de:	48 83 ec 10          	sub    $0x10,%rsp
  8026e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8026ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ee:	48 be c0 38 80 00 00 	movabs $0x8038c0,%rsi
  8026f5:	00 00 00 
  8026f8:	48 89 c7             	mov    %rax,%rdi
  8026fb:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  802702:	00 00 00 
  802705:	ff d0                	callq  *%rax
	return 0;
  802707:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80270c:	c9                   	leaveq 
  80270d:	c3                   	retq   

000000000080270e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80270e:	55                   	push   %rbp
  80270f:	48 89 e5             	mov    %rsp,%rbp
  802712:	53                   	push   %rbx
  802713:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80271a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802721:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802727:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80272e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802735:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80273c:	84 c0                	test   %al,%al
  80273e:	74 23                	je     802763 <_panic+0x55>
  802740:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802747:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80274b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80274f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802753:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802757:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80275b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80275f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802763:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80276a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802771:	00 00 00 
  802774:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80277b:	00 00 00 
  80277e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802782:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802789:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802790:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802797:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80279e:	00 00 00 
  8027a1:	48 8b 18             	mov    (%rax),%rbx
  8027a4:	48 b8 17 0b 80 00 00 	movabs $0x800b17,%rax
  8027ab:	00 00 00 
  8027ae:	ff d0                	callq  *%rax
  8027b0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8027b6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8027bd:	41 89 c8             	mov    %ecx,%r8d
  8027c0:	48 89 d1             	mov    %rdx,%rcx
  8027c3:	48 89 da             	mov    %rbx,%rdx
  8027c6:	89 c6                	mov    %eax,%esi
  8027c8:	48 bf c8 38 80 00 00 	movabs $0x8038c8,%rdi
  8027cf:	00 00 00 
  8027d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d7:	49 b9 47 29 80 00 00 	movabs $0x802947,%r9
  8027de:	00 00 00 
  8027e1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8027e4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8027eb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8027f2:	48 89 d6             	mov    %rdx,%rsi
  8027f5:	48 89 c7             	mov    %rax,%rdi
  8027f8:	48 b8 9b 28 80 00 00 	movabs $0x80289b,%rax
  8027ff:	00 00 00 
  802802:	ff d0                	callq  *%rax
	cprintf("\n");
  802804:	48 bf eb 38 80 00 00 	movabs $0x8038eb,%rdi
  80280b:	00 00 00 
  80280e:	b8 00 00 00 00       	mov    $0x0,%eax
  802813:	48 ba 47 29 80 00 00 	movabs $0x802947,%rdx
  80281a:	00 00 00 
  80281d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80281f:	cc                   	int3   
  802820:	eb fd                	jmp    80281f <_panic+0x111>

0000000000802822 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  802822:	55                   	push   %rbp
  802823:	48 89 e5             	mov    %rsp,%rbp
  802826:	48 83 ec 10          	sub    $0x10,%rsp
  80282a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80282d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  802831:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802835:	8b 00                	mov    (%rax),%eax
  802837:	8d 48 01             	lea    0x1(%rax),%ecx
  80283a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80283e:	89 0a                	mov    %ecx,(%rdx)
  802840:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802843:	89 d1                	mov    %edx,%ecx
  802845:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802849:	48 98                	cltq   
  80284b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80284f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802853:	8b 00                	mov    (%rax),%eax
  802855:	3d ff 00 00 00       	cmp    $0xff,%eax
  80285a:	75 2c                	jne    802888 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80285c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802860:	8b 00                	mov    (%rax),%eax
  802862:	48 98                	cltq   
  802864:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802868:	48 83 c2 08          	add    $0x8,%rdx
  80286c:	48 89 c6             	mov    %rax,%rsi
  80286f:	48 89 d7             	mov    %rdx,%rdi
  802872:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  802879:	00 00 00 
  80287c:	ff d0                	callq  *%rax
        b->idx = 0;
  80287e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802882:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  802888:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80288c:	8b 40 04             	mov    0x4(%rax),%eax
  80288f:	8d 50 01             	lea    0x1(%rax),%edx
  802892:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802896:	89 50 04             	mov    %edx,0x4(%rax)
}
  802899:	c9                   	leaveq 
  80289a:	c3                   	retq   

000000000080289b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80289b:	55                   	push   %rbp
  80289c:	48 89 e5             	mov    %rsp,%rbp
  80289f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8028a6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8028ad:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8028b4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8028bb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8028c2:	48 8b 0a             	mov    (%rdx),%rcx
  8028c5:	48 89 08             	mov    %rcx,(%rax)
  8028c8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8028cc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8028d0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8028d4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8028d8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8028df:	00 00 00 
    b.cnt = 0;
  8028e2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8028e9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8028ec:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8028f3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8028fa:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802901:	48 89 c6             	mov    %rax,%rsi
  802904:	48 bf 22 28 80 00 00 	movabs $0x802822,%rdi
  80290b:	00 00 00 
  80290e:	48 b8 fa 2c 80 00 00 	movabs $0x802cfa,%rax
  802915:	00 00 00 
  802918:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80291a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802920:	48 98                	cltq   
  802922:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802929:	48 83 c2 08          	add    $0x8,%rdx
  80292d:	48 89 c6             	mov    %rax,%rsi
  802930:	48 89 d7             	mov    %rdx,%rdi
  802933:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  80293a:	00 00 00 
  80293d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80293f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802945:	c9                   	leaveq 
  802946:	c3                   	retq   

0000000000802947 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802947:	55                   	push   %rbp
  802948:	48 89 e5             	mov    %rsp,%rbp
  80294b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802952:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802959:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802960:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802967:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80296e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802975:	84 c0                	test   %al,%al
  802977:	74 20                	je     802999 <cprintf+0x52>
  802979:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80297d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802981:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802985:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802989:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80298d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802991:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802995:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802999:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8029a0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8029a7:	00 00 00 
  8029aa:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8029b1:	00 00 00 
  8029b4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8029b8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8029bf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8029c6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8029cd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8029d4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8029db:	48 8b 0a             	mov    (%rdx),%rcx
  8029de:	48 89 08             	mov    %rcx,(%rax)
  8029e1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8029e5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8029e9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8029ed:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8029f1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8029f8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8029ff:	48 89 d6             	mov    %rdx,%rsi
  802a02:	48 89 c7             	mov    %rax,%rdi
  802a05:	48 b8 9b 28 80 00 00 	movabs $0x80289b,%rax
  802a0c:	00 00 00 
  802a0f:	ff d0                	callq  *%rax
  802a11:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802a17:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802a1d:	c9                   	leaveq 
  802a1e:	c3                   	retq   

0000000000802a1f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802a1f:	55                   	push   %rbp
  802a20:	48 89 e5             	mov    %rsp,%rbp
  802a23:	53                   	push   %rbx
  802a24:	48 83 ec 38          	sub    $0x38,%rsp
  802a28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a30:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802a34:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802a37:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802a3b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802a3f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802a42:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a46:	77 3b                	ja     802a83 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802a48:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802a4b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802a4f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802a52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a56:	ba 00 00 00 00       	mov    $0x0,%edx
  802a5b:	48 f7 f3             	div    %rbx
  802a5e:	48 89 c2             	mov    %rax,%rdx
  802a61:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802a64:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802a67:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802a6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a6f:	41 89 f9             	mov    %edi,%r9d
  802a72:	48 89 c7             	mov    %rax,%rdi
  802a75:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  802a7c:	00 00 00 
  802a7f:	ff d0                	callq  *%rax
  802a81:	eb 1e                	jmp    802aa1 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802a83:	eb 12                	jmp    802a97 <printnum+0x78>
			putch(padc, putdat);
  802a85:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a89:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802a8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a90:	48 89 ce             	mov    %rcx,%rsi
  802a93:	89 d7                	mov    %edx,%edi
  802a95:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802a97:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  802a9b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802a9f:	7f e4                	jg     802a85 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802aa1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802aa4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aa8:	ba 00 00 00 00       	mov    $0x0,%edx
  802aad:	48 f7 f1             	div    %rcx
  802ab0:	48 89 d0             	mov    %rdx,%rax
  802ab3:	48 ba f0 3a 80 00 00 	movabs $0x803af0,%rdx
  802aba:	00 00 00 
  802abd:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802ac1:	0f be d0             	movsbl %al,%edx
  802ac4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ac8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802acc:	48 89 ce             	mov    %rcx,%rsi
  802acf:	89 d7                	mov    %edx,%edi
  802ad1:	ff d0                	callq  *%rax
}
  802ad3:	48 83 c4 38          	add    $0x38,%rsp
  802ad7:	5b                   	pop    %rbx
  802ad8:	5d                   	pop    %rbp
  802ad9:	c3                   	retq   

0000000000802ada <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802ada:	55                   	push   %rbp
  802adb:	48 89 e5             	mov    %rsp,%rbp
  802ade:	48 83 ec 1c          	sub    $0x1c,%rsp
  802ae2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ae6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802ae9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802aed:	7e 52                	jle    802b41 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802aef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af3:	8b 00                	mov    (%rax),%eax
  802af5:	83 f8 30             	cmp    $0x30,%eax
  802af8:	73 24                	jae    802b1e <getuint+0x44>
  802afa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802afe:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b06:	8b 00                	mov    (%rax),%eax
  802b08:	89 c0                	mov    %eax,%eax
  802b0a:	48 01 d0             	add    %rdx,%rax
  802b0d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b11:	8b 12                	mov    (%rdx),%edx
  802b13:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b1a:	89 0a                	mov    %ecx,(%rdx)
  802b1c:	eb 17                	jmp    802b35 <getuint+0x5b>
  802b1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b22:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b26:	48 89 d0             	mov    %rdx,%rax
  802b29:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b2d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b31:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b35:	48 8b 00             	mov    (%rax),%rax
  802b38:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b3c:	e9 a3 00 00 00       	jmpq   802be4 <getuint+0x10a>
	else if (lflag)
  802b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802b45:	74 4f                	je     802b96 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802b47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4b:	8b 00                	mov    (%rax),%eax
  802b4d:	83 f8 30             	cmp    $0x30,%eax
  802b50:	73 24                	jae    802b76 <getuint+0x9c>
  802b52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b56:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5e:	8b 00                	mov    (%rax),%eax
  802b60:	89 c0                	mov    %eax,%eax
  802b62:	48 01 d0             	add    %rdx,%rax
  802b65:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b69:	8b 12                	mov    (%rdx),%edx
  802b6b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b6e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b72:	89 0a                	mov    %ecx,(%rdx)
  802b74:	eb 17                	jmp    802b8d <getuint+0xb3>
  802b76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b7e:	48 89 d0             	mov    %rdx,%rax
  802b81:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b89:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b8d:	48 8b 00             	mov    (%rax),%rax
  802b90:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b94:	eb 4e                	jmp    802be4 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802b96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b9a:	8b 00                	mov    (%rax),%eax
  802b9c:	83 f8 30             	cmp    $0x30,%eax
  802b9f:	73 24                	jae    802bc5 <getuint+0xeb>
  802ba1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802ba9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bad:	8b 00                	mov    (%rax),%eax
  802baf:	89 c0                	mov    %eax,%eax
  802bb1:	48 01 d0             	add    %rdx,%rax
  802bb4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bb8:	8b 12                	mov    (%rdx),%edx
  802bba:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802bbd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bc1:	89 0a                	mov    %ecx,(%rdx)
  802bc3:	eb 17                	jmp    802bdc <getuint+0x102>
  802bc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802bcd:	48 89 d0             	mov    %rdx,%rax
  802bd0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802bd4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bd8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802bdc:	8b 00                	mov    (%rax),%eax
  802bde:	89 c0                	mov    %eax,%eax
  802be0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802be4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802be8:	c9                   	leaveq 
  802be9:	c3                   	retq   

0000000000802bea <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802bea:	55                   	push   %rbp
  802beb:	48 89 e5             	mov    %rsp,%rbp
  802bee:	48 83 ec 1c          	sub    $0x1c,%rsp
  802bf2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bf6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802bf9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802bfd:	7e 52                	jle    802c51 <getint+0x67>
		x=va_arg(*ap, long long);
  802bff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c03:	8b 00                	mov    (%rax),%eax
  802c05:	83 f8 30             	cmp    $0x30,%eax
  802c08:	73 24                	jae    802c2e <getint+0x44>
  802c0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c16:	8b 00                	mov    (%rax),%eax
  802c18:	89 c0                	mov    %eax,%eax
  802c1a:	48 01 d0             	add    %rdx,%rax
  802c1d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c21:	8b 12                	mov    (%rdx),%edx
  802c23:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c2a:	89 0a                	mov    %ecx,(%rdx)
  802c2c:	eb 17                	jmp    802c45 <getint+0x5b>
  802c2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c32:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c36:	48 89 d0             	mov    %rdx,%rax
  802c39:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c3d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c41:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c45:	48 8b 00             	mov    (%rax),%rax
  802c48:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c4c:	e9 a3 00 00 00       	jmpq   802cf4 <getint+0x10a>
	else if (lflag)
  802c51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802c55:	74 4f                	je     802ca6 <getint+0xbc>
		x=va_arg(*ap, long);
  802c57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5b:	8b 00                	mov    (%rax),%eax
  802c5d:	83 f8 30             	cmp    $0x30,%eax
  802c60:	73 24                	jae    802c86 <getint+0x9c>
  802c62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c66:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6e:	8b 00                	mov    (%rax),%eax
  802c70:	89 c0                	mov    %eax,%eax
  802c72:	48 01 d0             	add    %rdx,%rax
  802c75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c79:	8b 12                	mov    (%rdx),%edx
  802c7b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c82:	89 0a                	mov    %ecx,(%rdx)
  802c84:	eb 17                	jmp    802c9d <getint+0xb3>
  802c86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c8e:	48 89 d0             	mov    %rdx,%rax
  802c91:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c95:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c99:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c9d:	48 8b 00             	mov    (%rax),%rax
  802ca0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802ca4:	eb 4e                	jmp    802cf4 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802ca6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802caa:	8b 00                	mov    (%rax),%eax
  802cac:	83 f8 30             	cmp    $0x30,%eax
  802caf:	73 24                	jae    802cd5 <getint+0xeb>
  802cb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802cb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cbd:	8b 00                	mov    (%rax),%eax
  802cbf:	89 c0                	mov    %eax,%eax
  802cc1:	48 01 d0             	add    %rdx,%rax
  802cc4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cc8:	8b 12                	mov    (%rdx),%edx
  802cca:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802ccd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cd1:	89 0a                	mov    %ecx,(%rdx)
  802cd3:	eb 17                	jmp    802cec <getint+0x102>
  802cd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802cdd:	48 89 d0             	mov    %rdx,%rax
  802ce0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802ce4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ce8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802cec:	8b 00                	mov    (%rax),%eax
  802cee:	48 98                	cltq   
  802cf0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802cf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802cf8:	c9                   	leaveq 
  802cf9:	c3                   	retq   

0000000000802cfa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802cfa:	55                   	push   %rbp
  802cfb:	48 89 e5             	mov    %rsp,%rbp
  802cfe:	41 54                	push   %r12
  802d00:	53                   	push   %rbx
  802d01:	48 83 ec 60          	sub    $0x60,%rsp
  802d05:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802d09:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802d0d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d11:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802d15:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802d19:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802d1d:	48 8b 0a             	mov    (%rdx),%rcx
  802d20:	48 89 08             	mov    %rcx,(%rax)
  802d23:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802d27:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802d2b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802d2f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802d33:	eb 28                	jmp    802d5d <vprintfmt+0x63>
			if (ch == '\0'){
  802d35:	85 db                	test   %ebx,%ebx
  802d37:	75 15                	jne    802d4e <vprintfmt+0x54>
				current_color=WHITE;
  802d39:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d40:	00 00 00 
  802d43:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  802d49:	e9 fc 04 00 00       	jmpq   80324a <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  802d4e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802d52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802d56:	48 89 d6             	mov    %rdx,%rsi
  802d59:	89 df                	mov    %ebx,%edi
  802d5b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802d5d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d61:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d65:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d69:	0f b6 00             	movzbl (%rax),%eax
  802d6c:	0f b6 d8             	movzbl %al,%ebx
  802d6f:	83 fb 25             	cmp    $0x25,%ebx
  802d72:	75 c1                	jne    802d35 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802d74:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802d78:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802d7f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802d86:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802d8d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802d94:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d98:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d9c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802da0:	0f b6 00             	movzbl (%rax),%eax
  802da3:	0f b6 d8             	movzbl %al,%ebx
  802da6:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802da9:	83 f8 55             	cmp    $0x55,%eax
  802dac:	0f 87 64 04 00 00    	ja     803216 <vprintfmt+0x51c>
  802db2:	89 c0                	mov    %eax,%eax
  802db4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802dbb:	00 
  802dbc:	48 b8 18 3b 80 00 00 	movabs $0x803b18,%rax
  802dc3:	00 00 00 
  802dc6:	48 01 d0             	add    %rdx,%rax
  802dc9:	48 8b 00             	mov    (%rax),%rax
  802dcc:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802dce:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802dd2:	eb c0                	jmp    802d94 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802dd4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802dd8:	eb ba                	jmp    802d94 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802dda:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802de1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802de4:	89 d0                	mov    %edx,%eax
  802de6:	c1 e0 02             	shl    $0x2,%eax
  802de9:	01 d0                	add    %edx,%eax
  802deb:	01 c0                	add    %eax,%eax
  802ded:	01 d8                	add    %ebx,%eax
  802def:	83 e8 30             	sub    $0x30,%eax
  802df2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802df5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802df9:	0f b6 00             	movzbl (%rax),%eax
  802dfc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802dff:	83 fb 2f             	cmp    $0x2f,%ebx
  802e02:	7e 0c                	jle    802e10 <vprintfmt+0x116>
  802e04:	83 fb 39             	cmp    $0x39,%ebx
  802e07:	7f 07                	jg     802e10 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802e09:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802e0e:	eb d1                	jmp    802de1 <vprintfmt+0xe7>
			goto process_precision;
  802e10:	eb 58                	jmp    802e6a <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  802e12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e15:	83 f8 30             	cmp    $0x30,%eax
  802e18:	73 17                	jae    802e31 <vprintfmt+0x137>
  802e1a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e21:	89 c0                	mov    %eax,%eax
  802e23:	48 01 d0             	add    %rdx,%rax
  802e26:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e29:	83 c2 08             	add    $0x8,%edx
  802e2c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802e2f:	eb 0f                	jmp    802e40 <vprintfmt+0x146>
  802e31:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e35:	48 89 d0             	mov    %rdx,%rax
  802e38:	48 83 c2 08          	add    $0x8,%rdx
  802e3c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802e40:	8b 00                	mov    (%rax),%eax
  802e42:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802e45:	eb 23                	jmp    802e6a <vprintfmt+0x170>

		case '.':
			if (width < 0)
  802e47:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e4b:	79 0c                	jns    802e59 <vprintfmt+0x15f>
				width = 0;
  802e4d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802e54:	e9 3b ff ff ff       	jmpq   802d94 <vprintfmt+0x9a>
  802e59:	e9 36 ff ff ff       	jmpq   802d94 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  802e5e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802e65:	e9 2a ff ff ff       	jmpq   802d94 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  802e6a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e6e:	79 12                	jns    802e82 <vprintfmt+0x188>
				width = precision, precision = -1;
  802e70:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802e73:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802e76:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802e7d:	e9 12 ff ff ff       	jmpq   802d94 <vprintfmt+0x9a>
  802e82:	e9 0d ff ff ff       	jmpq   802d94 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802e87:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802e8b:	e9 04 ff ff ff       	jmpq   802d94 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802e90:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e93:	83 f8 30             	cmp    $0x30,%eax
  802e96:	73 17                	jae    802eaf <vprintfmt+0x1b5>
  802e98:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e9f:	89 c0                	mov    %eax,%eax
  802ea1:	48 01 d0             	add    %rdx,%rax
  802ea4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802ea7:	83 c2 08             	add    $0x8,%edx
  802eaa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802ead:	eb 0f                	jmp    802ebe <vprintfmt+0x1c4>
  802eaf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802eb3:	48 89 d0             	mov    %rdx,%rax
  802eb6:	48 83 c2 08          	add    $0x8,%rdx
  802eba:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802ebe:	8b 10                	mov    (%rax),%edx
  802ec0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802ec4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ec8:	48 89 ce             	mov    %rcx,%rsi
  802ecb:	89 d7                	mov    %edx,%edi
  802ecd:	ff d0                	callq  *%rax
			break;
  802ecf:	e9 70 03 00 00       	jmpq   803244 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802ed4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ed7:	83 f8 30             	cmp    $0x30,%eax
  802eda:	73 17                	jae    802ef3 <vprintfmt+0x1f9>
  802edc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ee0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ee3:	89 c0                	mov    %eax,%eax
  802ee5:	48 01 d0             	add    %rdx,%rax
  802ee8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802eeb:	83 c2 08             	add    $0x8,%edx
  802eee:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802ef1:	eb 0f                	jmp    802f02 <vprintfmt+0x208>
  802ef3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ef7:	48 89 d0             	mov    %rdx,%rax
  802efa:	48 83 c2 08          	add    $0x8,%rdx
  802efe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802f02:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802f04:	85 db                	test   %ebx,%ebx
  802f06:	79 02                	jns    802f0a <vprintfmt+0x210>
				err = -err;
  802f08:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802f0a:	83 fb 15             	cmp    $0x15,%ebx
  802f0d:	7f 16                	jg     802f25 <vprintfmt+0x22b>
  802f0f:	48 b8 40 3a 80 00 00 	movabs $0x803a40,%rax
  802f16:	00 00 00 
  802f19:	48 63 d3             	movslq %ebx,%rdx
  802f1c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802f20:	4d 85 e4             	test   %r12,%r12
  802f23:	75 2e                	jne    802f53 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  802f25:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802f29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f2d:	89 d9                	mov    %ebx,%ecx
  802f2f:	48 ba 01 3b 80 00 00 	movabs $0x803b01,%rdx
  802f36:	00 00 00 
  802f39:	48 89 c7             	mov    %rax,%rdi
  802f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f41:	49 b8 53 32 80 00 00 	movabs $0x803253,%r8
  802f48:	00 00 00 
  802f4b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802f4e:	e9 f1 02 00 00       	jmpq   803244 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802f53:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802f57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f5b:	4c 89 e1             	mov    %r12,%rcx
  802f5e:	48 ba 0a 3b 80 00 00 	movabs $0x803b0a,%rdx
  802f65:	00 00 00 
  802f68:	48 89 c7             	mov    %rax,%rdi
  802f6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f70:	49 b8 53 32 80 00 00 	movabs $0x803253,%r8
  802f77:	00 00 00 
  802f7a:	41 ff d0             	callq  *%r8
			break;
  802f7d:	e9 c2 02 00 00       	jmpq   803244 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802f82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f85:	83 f8 30             	cmp    $0x30,%eax
  802f88:	73 17                	jae    802fa1 <vprintfmt+0x2a7>
  802f8a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f91:	89 c0                	mov    %eax,%eax
  802f93:	48 01 d0             	add    %rdx,%rax
  802f96:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802f99:	83 c2 08             	add    $0x8,%edx
  802f9c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802f9f:	eb 0f                	jmp    802fb0 <vprintfmt+0x2b6>
  802fa1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802fa5:	48 89 d0             	mov    %rdx,%rax
  802fa8:	48 83 c2 08          	add    $0x8,%rdx
  802fac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802fb0:	4c 8b 20             	mov    (%rax),%r12
  802fb3:	4d 85 e4             	test   %r12,%r12
  802fb6:	75 0a                	jne    802fc2 <vprintfmt+0x2c8>
				p = "(null)";
  802fb8:	49 bc 0d 3b 80 00 00 	movabs $0x803b0d,%r12
  802fbf:	00 00 00 
			if (width > 0 && padc != '-')
  802fc2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802fc6:	7e 3f                	jle    803007 <vprintfmt+0x30d>
  802fc8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802fcc:	74 39                	je     803007 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  802fce:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802fd1:	48 98                	cltq   
  802fd3:	48 89 c6             	mov    %rax,%rsi
  802fd6:	4c 89 e7             	mov    %r12,%rdi
  802fd9:	48 b8 26 02 80 00 00 	movabs $0x800226,%rax
  802fe0:	00 00 00 
  802fe3:	ff d0                	callq  *%rax
  802fe5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802fe8:	eb 17                	jmp    803001 <vprintfmt+0x307>
					putch(padc, putdat);
  802fea:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802fee:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802ff2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ff6:	48 89 ce             	mov    %rcx,%rsi
  802ff9:	89 d7                	mov    %edx,%edi
  802ffb:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802ffd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803001:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803005:	7f e3                	jg     802fea <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803007:	eb 37                	jmp    803040 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  803009:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80300d:	74 1e                	je     80302d <vprintfmt+0x333>
  80300f:	83 fb 1f             	cmp    $0x1f,%ebx
  803012:	7e 05                	jle    803019 <vprintfmt+0x31f>
  803014:	83 fb 7e             	cmp    $0x7e,%ebx
  803017:	7e 14                	jle    80302d <vprintfmt+0x333>
					putch('?', putdat);
  803019:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80301d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803021:	48 89 d6             	mov    %rdx,%rsi
  803024:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803029:	ff d0                	callq  *%rax
  80302b:	eb 0f                	jmp    80303c <vprintfmt+0x342>
				else
					putch(ch, putdat);
  80302d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803031:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803035:	48 89 d6             	mov    %rdx,%rsi
  803038:	89 df                	mov    %ebx,%edi
  80303a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80303c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803040:	4c 89 e0             	mov    %r12,%rax
  803043:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803047:	0f b6 00             	movzbl (%rax),%eax
  80304a:	0f be d8             	movsbl %al,%ebx
  80304d:	85 db                	test   %ebx,%ebx
  80304f:	74 10                	je     803061 <vprintfmt+0x367>
  803051:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803055:	78 b2                	js     803009 <vprintfmt+0x30f>
  803057:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80305b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80305f:	79 a8                	jns    803009 <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803061:	eb 16                	jmp    803079 <vprintfmt+0x37f>
				putch(' ', putdat);
  803063:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803067:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80306b:	48 89 d6             	mov    %rdx,%rsi
  80306e:	bf 20 00 00 00       	mov    $0x20,%edi
  803073:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803075:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803079:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80307d:	7f e4                	jg     803063 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  80307f:	e9 c0 01 00 00       	jmpq   803244 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803084:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803088:	be 03 00 00 00       	mov    $0x3,%esi
  80308d:	48 89 c7             	mov    %rax,%rdi
  803090:	48 b8 ea 2b 80 00 00 	movabs $0x802bea,%rax
  803097:	00 00 00 
  80309a:	ff d0                	callq  *%rax
  80309c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8030a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030a4:	48 85 c0             	test   %rax,%rax
  8030a7:	79 1d                	jns    8030c6 <vprintfmt+0x3cc>
				putch('-', putdat);
  8030a9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030ad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030b1:	48 89 d6             	mov    %rdx,%rsi
  8030b4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8030b9:	ff d0                	callq  *%rax
				num = -(long long) num;
  8030bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030bf:	48 f7 d8             	neg    %rax
  8030c2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8030c6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8030cd:	e9 d5 00 00 00       	jmpq   8031a7 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8030d2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8030d6:	be 03 00 00 00       	mov    $0x3,%esi
  8030db:	48 89 c7             	mov    %rax,%rdi
  8030de:	48 b8 da 2a 80 00 00 	movabs $0x802ada,%rax
  8030e5:	00 00 00 
  8030e8:	ff d0                	callq  *%rax
  8030ea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8030ee:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8030f5:	e9 ad 00 00 00       	jmpq   8031a7 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  8030fa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8030fe:	be 03 00 00 00       	mov    $0x3,%esi
  803103:	48 89 c7             	mov    %rax,%rdi
  803106:	48 b8 da 2a 80 00 00 	movabs $0x802ada,%rax
  80310d:	00 00 00 
  803110:	ff d0                	callq  *%rax
  803112:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  803116:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80311d:	e9 85 00 00 00       	jmpq   8031a7 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  803122:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803126:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80312a:	48 89 d6             	mov    %rdx,%rsi
  80312d:	bf 30 00 00 00       	mov    $0x30,%edi
  803132:	ff d0                	callq  *%rax
			putch('x', putdat);
  803134:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803138:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80313c:	48 89 d6             	mov    %rdx,%rsi
  80313f:	bf 78 00 00 00       	mov    $0x78,%edi
  803144:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803146:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803149:	83 f8 30             	cmp    $0x30,%eax
  80314c:	73 17                	jae    803165 <vprintfmt+0x46b>
  80314e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803152:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803155:	89 c0                	mov    %eax,%eax
  803157:	48 01 d0             	add    %rdx,%rax
  80315a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80315d:	83 c2 08             	add    $0x8,%edx
  803160:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803163:	eb 0f                	jmp    803174 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  803165:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803169:	48 89 d0             	mov    %rdx,%rax
  80316c:	48 83 c2 08          	add    $0x8,%rdx
  803170:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803174:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803177:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80317b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803182:	eb 23                	jmp    8031a7 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803184:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803188:	be 03 00 00 00       	mov    $0x3,%esi
  80318d:	48 89 c7             	mov    %rax,%rdi
  803190:	48 b8 da 2a 80 00 00 	movabs $0x802ada,%rax
  803197:	00 00 00 
  80319a:	ff d0                	callq  *%rax
  80319c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8031a0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8031a7:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8031ac:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8031af:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8031b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031b6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8031ba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8031be:	45 89 c1             	mov    %r8d,%r9d
  8031c1:	41 89 f8             	mov    %edi,%r8d
  8031c4:	48 89 c7             	mov    %rax,%rdi
  8031c7:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  8031ce:	00 00 00 
  8031d1:	ff d0                	callq  *%rax
			break;
  8031d3:	eb 6f                	jmp    803244 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8031d5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8031d9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8031dd:	48 89 d6             	mov    %rdx,%rsi
  8031e0:	89 df                	mov    %ebx,%edi
  8031e2:	ff d0                	callq  *%rax
			break;
  8031e4:	eb 5e                	jmp    803244 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  8031e6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8031ea:	be 03 00 00 00       	mov    $0x3,%esi
  8031ef:	48 89 c7             	mov    %rax,%rdi
  8031f2:	48 b8 da 2a 80 00 00 	movabs $0x802ada,%rax
  8031f9:	00 00 00 
  8031fc:	ff d0                	callq  *%rax
  8031fe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  803202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803206:	89 c2                	mov    %eax,%edx
  803208:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80320f:	00 00 00 
  803212:	89 10                	mov    %edx,(%rax)
			break;
  803214:	eb 2e                	jmp    803244 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803216:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80321a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80321e:	48 89 d6             	mov    %rdx,%rsi
  803221:	bf 25 00 00 00       	mov    $0x25,%edi
  803226:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803228:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80322d:	eb 05                	jmp    803234 <vprintfmt+0x53a>
  80322f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803234:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803238:	48 83 e8 01          	sub    $0x1,%rax
  80323c:	0f b6 00             	movzbl (%rax),%eax
  80323f:	3c 25                	cmp    $0x25,%al
  803241:	75 ec                	jne    80322f <vprintfmt+0x535>
				/* do nothing */;
			break;
  803243:	90                   	nop
		}
	}
  803244:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803245:	e9 13 fb ff ff       	jmpq   802d5d <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80324a:	48 83 c4 60          	add    $0x60,%rsp
  80324e:	5b                   	pop    %rbx
  80324f:	41 5c                	pop    %r12
  803251:	5d                   	pop    %rbp
  803252:	c3                   	retq   

0000000000803253 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803253:	55                   	push   %rbp
  803254:	48 89 e5             	mov    %rsp,%rbp
  803257:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80325e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803265:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80326c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803273:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80327a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803281:	84 c0                	test   %al,%al
  803283:	74 20                	je     8032a5 <printfmt+0x52>
  803285:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803289:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80328d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803291:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803295:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803299:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80329d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8032a1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8032a5:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8032ac:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8032b3:	00 00 00 
  8032b6:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8032bd:	00 00 00 
  8032c0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032c4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8032cb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8032d2:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8032d9:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8032e0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8032e7:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8032ee:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8032f5:	48 89 c7             	mov    %rax,%rdi
  8032f8:	48 b8 fa 2c 80 00 00 	movabs $0x802cfa,%rax
  8032ff:	00 00 00 
  803302:	ff d0                	callq  *%rax
	va_end(ap);
}
  803304:	c9                   	leaveq 
  803305:	c3                   	retq   

0000000000803306 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803306:	55                   	push   %rbp
  803307:	48 89 e5             	mov    %rsp,%rbp
  80330a:	48 83 ec 10          	sub    $0x10,%rsp
  80330e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803311:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803319:	8b 40 10             	mov    0x10(%rax),%eax
  80331c:	8d 50 01             	lea    0x1(%rax),%edx
  80331f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803323:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332a:	48 8b 10             	mov    (%rax),%rdx
  80332d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803331:	48 8b 40 08          	mov    0x8(%rax),%rax
  803335:	48 39 c2             	cmp    %rax,%rdx
  803338:	73 17                	jae    803351 <sprintputch+0x4b>
		*b->buf++ = ch;
  80333a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333e:	48 8b 00             	mov    (%rax),%rax
  803341:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803345:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803349:	48 89 0a             	mov    %rcx,(%rdx)
  80334c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80334f:	88 10                	mov    %dl,(%rax)
}
  803351:	c9                   	leaveq 
  803352:	c3                   	retq   

0000000000803353 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803353:	55                   	push   %rbp
  803354:	48 89 e5             	mov    %rsp,%rbp
  803357:	48 83 ec 50          	sub    $0x50,%rsp
  80335b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80335f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803362:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803366:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80336a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80336e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803372:	48 8b 0a             	mov    (%rdx),%rcx
  803375:	48 89 08             	mov    %rcx,(%rax)
  803378:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80337c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803380:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803384:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803388:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80338c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803390:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803393:	48 98                	cltq   
  803395:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803399:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80339d:	48 01 d0             	add    %rdx,%rax
  8033a0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8033a4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8033ab:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8033b0:	74 06                	je     8033b8 <vsnprintf+0x65>
  8033b2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8033b6:	7f 07                	jg     8033bf <vsnprintf+0x6c>
		return -E_INVAL;
  8033b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8033bd:	eb 2f                	jmp    8033ee <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8033bf:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8033c3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8033c7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8033cb:	48 89 c6             	mov    %rax,%rsi
  8033ce:	48 bf 06 33 80 00 00 	movabs $0x803306,%rdi
  8033d5:	00 00 00 
  8033d8:	48 b8 fa 2c 80 00 00 	movabs $0x802cfa,%rax
  8033df:	00 00 00 
  8033e2:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8033e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033e8:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8033eb:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8033ee:	c9                   	leaveq 
  8033ef:	c3                   	retq   

00000000008033f0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8033f0:	55                   	push   %rbp
  8033f1:	48 89 e5             	mov    %rsp,%rbp
  8033f4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8033fb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803402:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803408:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80340f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803416:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80341d:	84 c0                	test   %al,%al
  80341f:	74 20                	je     803441 <snprintf+0x51>
  803421:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803425:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803429:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80342d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803431:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803435:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803439:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80343d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803441:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803448:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80344f:	00 00 00 
  803452:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803459:	00 00 00 
  80345c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803460:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803467:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80346e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803475:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80347c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803483:	48 8b 0a             	mov    (%rdx),%rcx
  803486:	48 89 08             	mov    %rcx,(%rax)
  803489:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80348d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803491:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803495:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803499:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8034a0:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8034a7:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8034ad:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8034b4:	48 89 c7             	mov    %rax,%rdi
  8034b7:	48 b8 53 33 80 00 00 	movabs $0x803353,%rax
  8034be:	00 00 00 
  8034c1:	ff d0                	callq  *%rax
  8034c3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8034c9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8034cf:	c9                   	leaveq 
  8034d0:	c3                   	retq   

00000000008034d1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8034d1:	55                   	push   %rbp
  8034d2:	48 89 e5             	mov    %rsp,%rbp
  8034d5:	48 83 ec 30          	sub    $0x30,%rsp
  8034d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  8034e5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8034ea:	75 08                	jne    8034f4 <ipc_recv+0x23>
  8034ec:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8034f3:	ff 
	int res=sys_ipc_recv(pg);
  8034f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034f8:	48 89 c7             	mov    %rax,%rdi
  8034fb:	48 b8 07 0e 80 00 00 	movabs $0x800e07,%rax
  803502:	00 00 00 
  803505:	ff d0                	callq  *%rax
  803507:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  80350a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80350f:	74 26                	je     803537 <ipc_recv+0x66>
  803511:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803515:	75 15                	jne    80352c <ipc_recv+0x5b>
  803517:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80351e:	00 00 00 
  803521:	48 8b 00             	mov    (%rax),%rax
  803524:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  80352a:	eb 05                	jmp    803531 <ipc_recv+0x60>
  80352c:	b8 00 00 00 00       	mov    $0x0,%eax
  803531:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803535:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  803537:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80353c:	74 26                	je     803564 <ipc_recv+0x93>
  80353e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803542:	75 15                	jne    803559 <ipc_recv+0x88>
  803544:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80354b:	00 00 00 
  80354e:	48 8b 00             	mov    (%rax),%rax
  803551:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803557:	eb 05                	jmp    80355e <ipc_recv+0x8d>
  803559:	b8 00 00 00 00       	mov    $0x0,%eax
  80355e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803562:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  803564:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803568:	75 15                	jne    80357f <ipc_recv+0xae>
  80356a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803571:	00 00 00 
  803574:	48 8b 00             	mov    (%rax),%rax
  803577:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  80357d:	eb 03                	jmp    803582 <ipc_recv+0xb1>
  80357f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  803582:	c9                   	leaveq 
  803583:	c3                   	retq   

0000000000803584 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803584:	55                   	push   %rbp
  803585:	48 89 e5             	mov    %rsp,%rbp
  803588:	48 83 ec 30          	sub    $0x30,%rsp
  80358c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80358f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803592:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803596:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  803599:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80359e:	75 0a                	jne    8035aa <ipc_send+0x26>
  8035a0:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8035a7:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8035a8:	eb 3e                	jmp    8035e8 <ipc_send+0x64>
  8035aa:	eb 3c                	jmp    8035e8 <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  8035ac:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8035b0:	74 2a                	je     8035dc <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  8035b2:	48 ba c8 3d 80 00 00 	movabs $0x803dc8,%rdx
  8035b9:	00 00 00 
  8035bc:	be 39 00 00 00       	mov    $0x39,%esi
  8035c1:	48 bf f3 3d 80 00 00 	movabs $0x803df3,%rdi
  8035c8:	00 00 00 
  8035cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d0:	48 b9 0e 27 80 00 00 	movabs $0x80270e,%rcx
  8035d7:	00 00 00 
  8035da:	ff d1                	callq  *%rcx
		sys_yield();  
  8035dc:	48 b8 55 0b 80 00 00 	movabs $0x800b55,%rax
  8035e3:	00 00 00 
  8035e6:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8035e8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8035eb:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8035ee:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8035f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035f5:	89 c7                	mov    %eax,%edi
  8035f7:	48 b8 b2 0d 80 00 00 	movabs $0x800db2,%rax
  8035fe:	00 00 00 
  803601:	ff d0                	callq  *%rax
  803603:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803606:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80360a:	78 a0                	js     8035ac <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  80360c:	c9                   	leaveq 
  80360d:	c3                   	retq   

000000000080360e <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  80360e:	55                   	push   %rbp
  80360f:	48 89 e5             	mov    %rsp,%rbp
  803612:	48 83 ec 10          	sub    $0x10,%rsp
  803616:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  80361a:	48 ba 00 3e 80 00 00 	movabs $0x803e00,%rdx
  803621:	00 00 00 
  803624:	be 47 00 00 00       	mov    $0x47,%esi
  803629:	48 bf f3 3d 80 00 00 	movabs $0x803df3,%rdi
  803630:	00 00 00 
  803633:	b8 00 00 00 00       	mov    $0x0,%eax
  803638:	48 b9 0e 27 80 00 00 	movabs $0x80270e,%rcx
  80363f:	00 00 00 
  803642:	ff d1                	callq  *%rcx

0000000000803644 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803644:	55                   	push   %rbp
  803645:	48 89 e5             	mov    %rsp,%rbp
  803648:	48 83 ec 20          	sub    $0x20,%rsp
  80364c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80364f:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803652:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803656:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  803659:	48 ba 28 3e 80 00 00 	movabs $0x803e28,%rdx
  803660:	00 00 00 
  803663:	be 50 00 00 00       	mov    $0x50,%esi
  803668:	48 bf f3 3d 80 00 00 	movabs $0x803df3,%rdi
  80366f:	00 00 00 
  803672:	b8 00 00 00 00       	mov    $0x0,%eax
  803677:	48 b9 0e 27 80 00 00 	movabs $0x80270e,%rcx
  80367e:	00 00 00 
  803681:	ff d1                	callq  *%rcx

0000000000803683 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803683:	55                   	push   %rbp
  803684:	48 89 e5             	mov    %rsp,%rbp
  803687:	48 83 ec 14          	sub    $0x14,%rsp
  80368b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80368e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803695:	eb 4e                	jmp    8036e5 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803697:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80369e:	00 00 00 
  8036a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a4:	48 98                	cltq   
  8036a6:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8036ad:	48 01 d0             	add    %rdx,%rax
  8036b0:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8036b6:	8b 00                	mov    (%rax),%eax
  8036b8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8036bb:	75 24                	jne    8036e1 <ipc_find_env+0x5e>
			return envs[i].env_id;
  8036bd:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8036c4:	00 00 00 
  8036c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ca:	48 98                	cltq   
  8036cc:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8036d3:	48 01 d0             	add    %rdx,%rax
  8036d6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8036dc:	8b 40 08             	mov    0x8(%rax),%eax
  8036df:	eb 12                	jmp    8036f3 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8036e1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8036e5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8036ec:	7e a9                	jle    803697 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  8036ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036f3:	c9                   	leaveq 
  8036f4:	c3                   	retq   

00000000008036f5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8036f5:	55                   	push   %rbp
  8036f6:	48 89 e5             	mov    %rsp,%rbp
  8036f9:	48 83 ec 18          	sub    $0x18,%rsp
  8036fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803705:	48 c1 e8 15          	shr    $0x15,%rax
  803709:	48 89 c2             	mov    %rax,%rdx
  80370c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803713:	01 00 00 
  803716:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80371a:	83 e0 01             	and    $0x1,%eax
  80371d:	48 85 c0             	test   %rax,%rax
  803720:	75 07                	jne    803729 <pageref+0x34>
		return 0;
  803722:	b8 00 00 00 00       	mov    $0x0,%eax
  803727:	eb 53                	jmp    80377c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80372d:	48 c1 e8 0c          	shr    $0xc,%rax
  803731:	48 89 c2             	mov    %rax,%rdx
  803734:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80373b:	01 00 00 
  80373e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803742:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803746:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80374a:	83 e0 01             	and    $0x1,%eax
  80374d:	48 85 c0             	test   %rax,%rax
  803750:	75 07                	jne    803759 <pageref+0x64>
		return 0;
  803752:	b8 00 00 00 00       	mov    $0x0,%eax
  803757:	eb 23                	jmp    80377c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803759:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80375d:	48 c1 e8 0c          	shr    $0xc,%rax
  803761:	48 89 c2             	mov    %rax,%rdx
  803764:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80376b:	00 00 00 
  80376e:	48 c1 e2 04          	shl    $0x4,%rdx
  803772:	48 01 d0             	add    %rdx,%rax
  803775:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803779:	0f b7 c0             	movzwl %ax,%eax
}
  80377c:	c9                   	leaveq 
  80377d:	c3                   	retq   
