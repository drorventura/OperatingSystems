
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   f:	8d 94 24 1e 02 00 00 	lea    0x21e(%esp),%edx
  16:	bb 26 0a 00 00       	mov    $0xa26,%ebx
  1b:	b8 0a 00 00 00       	mov    $0xa,%eax
  20:	89 d7                	mov    %edx,%edi
  22:	89 de                	mov    %ebx,%esi
  24:	89 c1                	mov    %eax,%ecx
  26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	c7 44 24 04 03 0a 00 	movl   $0xa03,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 00 06 00 00       	call   63c <printf>
  memset(data, 'a', sizeof(data));
  3c:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  43:	00 
  44:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4b:	00 
  4c:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  50:	89 04 24             	mov    %eax,(%esp)
  53:	e8 08 02 00 00       	call   260 <memset>

  for(i = 0; i < 4; i++)
  58:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  5f:	00 00 00 00 
  63:	eb 10                	jmp    75 <main+0x75>
    if(fork() > 0)
  65:	e8 42 04 00 00       	call   4ac <fork>
  6a:	85 c0                	test   %eax,%eax
  6c:	7f 13                	jg     81 <main+0x81>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  6e:	ff 84 24 2c 02 00 00 	incl   0x22c(%esp)
  75:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  7c:	03 
  7d:	7e e6                	jle    65 <main+0x65>
  7f:	eb 01                	jmp    82 <main+0x82>
    if(fork() > 0)
      break;
  81:	90                   	nop

  printf(1, "write %d\n", i);
  82:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  89:	89 44 24 08          	mov    %eax,0x8(%esp)
  8d:	c7 44 24 04 16 0a 00 	movl   $0xa16,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 9b 05 00 00       	call   63c <printf>

  path[8] += i;
  a1:	8a 84 24 26 02 00 00 	mov    0x226(%esp),%al
  a8:	88 c2                	mov    %al,%dl
  aa:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b1:	01 d0                	add    %edx,%eax
  b3:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  ba:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c1:	00 
  c2:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  c9:	89 04 24             	mov    %eax,(%esp)
  cc:	e8 23 04 00 00       	call   4f4 <open>
  d1:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  d8:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  df:	00 00 00 00 
  e3:	eb 26                	jmp    10b <main+0x10b>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  e5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  ec:	00 
  ed:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  f5:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
  fc:	89 04 24             	mov    %eax,(%esp)
  ff:	e8 d0 03 00 00       	call   4d4 <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
 104:	ff 84 24 2c 02 00 00 	incl   0x22c(%esp)
 10b:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 112:	13 
 113:	7e d0                	jle    e5 <main+0xe5>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
 115:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 11c:	89 04 24             	mov    %eax,(%esp)
 11f:	e8 b8 03 00 00       	call   4dc <close>

  printf(1, "read\n");
 124:	c7 44 24 04 20 0a 00 	movl   $0xa20,0x4(%esp)
 12b:	00 
 12c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 133:	e8 04 05 00 00       	call   63c <printf>

  fd = open(path, O_RDONLY);
 138:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 13f:	00 
 140:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 147:	89 04 24             	mov    %eax,(%esp)
 14a:	e8 a5 03 00 00       	call   4f4 <open>
 14f:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 156:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 15d:	00 00 00 00 
 161:	eb 26                	jmp    189 <main+0x189>
    read(fd, data, sizeof(data));
 163:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 16a:	00 
 16b:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 16f:	89 44 24 04          	mov    %eax,0x4(%esp)
 173:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 17a:	89 04 24             	mov    %eax,(%esp)
 17d:	e8 4a 03 00 00       	call   4cc <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 182:	ff 84 24 2c 02 00 00 	incl   0x22c(%esp)
 189:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 190:	13 
 191:	7e d0                	jle    163 <main+0x163>
    read(fd, data, sizeof(data));
  close(fd);
 193:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 19a:	89 04 24             	mov    %eax,(%esp)
 19d:	e8 3a 03 00 00       	call   4dc <close>

  wait();
 1a2:	e8 15 03 00 00       	call   4bc <wait>
  
  exit();
 1a7:	e8 08 03 00 00       	call   4b4 <exit>

000001ac <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	57                   	push   %edi
 1b0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1b4:	8b 55 10             	mov    0x10(%ebp),%edx
 1b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ba:	89 cb                	mov    %ecx,%ebx
 1bc:	89 df                	mov    %ebx,%edi
 1be:	89 d1                	mov    %edx,%ecx
 1c0:	fc                   	cld    
 1c1:	f3 aa                	rep stos %al,%es:(%edi)
 1c3:	89 ca                	mov    %ecx,%edx
 1c5:	89 fb                	mov    %edi,%ebx
 1c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1ca:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1cd:	5b                   	pop    %ebx
 1ce:	5f                   	pop    %edi
 1cf:	5d                   	pop    %ebp
 1d0:	c3                   	ret    

000001d1 <strcpy>:

#define NULL   0

char*
strcpy(char *s, char *t)
{
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
 1d4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1dd:	90                   	nop
 1de:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e1:	8a 10                	mov    (%eax),%dl
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	88 10                	mov    %dl,(%eax)
 1e8:	8b 45 08             	mov    0x8(%ebp),%eax
 1eb:	8a 00                	mov    (%eax),%al
 1ed:	84 c0                	test   %al,%al
 1ef:	0f 95 c0             	setne  %al
 1f2:	ff 45 08             	incl   0x8(%ebp)
 1f5:	ff 45 0c             	incl   0xc(%ebp)
 1f8:	84 c0                	test   %al,%al
 1fa:	75 e2                	jne    1de <strcpy+0xd>
    ;
  return os;
 1fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 204:	eb 06                	jmp    20c <strcmp+0xb>
    p++, q++;
 206:	ff 45 08             	incl   0x8(%ebp)
 209:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	8a 00                	mov    (%eax),%al
 211:	84 c0                	test   %al,%al
 213:	74 0e                	je     223 <strcmp+0x22>
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	8a 10                	mov    (%eax),%dl
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	8a 00                	mov    (%eax),%al
 21f:	38 c2                	cmp    %al,%dl
 221:	74 e3                	je     206 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	8a 00                	mov    (%eax),%al
 228:	0f b6 d0             	movzbl %al,%edx
 22b:	8b 45 0c             	mov    0xc(%ebp),%eax
 22e:	8a 00                	mov    (%eax),%al
 230:	0f b6 c0             	movzbl %al,%eax
 233:	89 d1                	mov    %edx,%ecx
 235:	29 c1                	sub    %eax,%ecx
 237:	89 c8                	mov    %ecx,%eax
}
 239:	5d                   	pop    %ebp
 23a:	c3                   	ret    

0000023b <strlen>:

uint
strlen(char *s)
{
 23b:	55                   	push   %ebp
 23c:	89 e5                	mov    %esp,%ebp
 23e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 241:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 248:	eb 03                	jmp    24d <strlen+0x12>
 24a:	ff 45 fc             	incl   -0x4(%ebp)
 24d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	01 d0                	add    %edx,%eax
 255:	8a 00                	mov    (%eax),%al
 257:	84 c0                	test   %al,%al
 259:	75 ef                	jne    24a <strlen+0xf>
    ;
  return n;
 25b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 25e:	c9                   	leave  
 25f:	c3                   	ret    

00000260 <memset>:

void*
memset(void *dst, int c, uint n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 266:	8b 45 10             	mov    0x10(%ebp),%eax
 269:	89 44 24 08          	mov    %eax,0x8(%esp)
 26d:	8b 45 0c             	mov    0xc(%ebp),%eax
 270:	89 44 24 04          	mov    %eax,0x4(%esp)
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	89 04 24             	mov    %eax,(%esp)
 27a:	e8 2d ff ff ff       	call   1ac <stosb>
  return dst;
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <strchr>:

char*
strchr(const char *s, char c)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 04             	sub    $0x4,%esp
 28a:	8b 45 0c             	mov    0xc(%ebp),%eax
 28d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 290:	eb 12                	jmp    2a4 <strchr+0x20>
    if(*s == c)
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	8a 00                	mov    (%eax),%al
 297:	3a 45 fc             	cmp    -0x4(%ebp),%al
 29a:	75 05                	jne    2a1 <strchr+0x1d>
      return (char*)s;
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	eb 11                	jmp    2b2 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2a1:	ff 45 08             	incl   0x8(%ebp)
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	8a 00                	mov    (%eax),%al
 2a9:	84 c0                	test   %al,%al
 2ab:	75 e5                	jne    292 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <gets>:

char*
gets(char *buf, int max)
{
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2c1:	eb 42                	jmp    305 <gets+0x51>
    cc = read(0, &c, 1);
 2c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2ca:	00 
 2cb:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2d9:	e8 ee 01 00 00       	call   4cc <read>
 2de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2e5:	7e 29                	jle    310 <gets+0x5c>
      break;
    buf[i++] = c;
 2e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	01 c2                	add    %eax,%edx
 2ef:	8a 45 ef             	mov    -0x11(%ebp),%al
 2f2:	88 02                	mov    %al,(%edx)
 2f4:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 2f7:	8a 45 ef             	mov    -0x11(%ebp),%al
 2fa:	3c 0a                	cmp    $0xa,%al
 2fc:	74 13                	je     311 <gets+0x5d>
 2fe:	8a 45 ef             	mov    -0x11(%ebp),%al
 301:	3c 0d                	cmp    $0xd,%al
 303:	74 0c                	je     311 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 305:	8b 45 f4             	mov    -0xc(%ebp),%eax
 308:	40                   	inc    %eax
 309:	3b 45 0c             	cmp    0xc(%ebp),%eax
 30c:	7c b5                	jl     2c3 <gets+0xf>
 30e:	eb 01                	jmp    311 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 310:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 311:	8b 55 f4             	mov    -0xc(%ebp),%edx
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	01 d0                	add    %edx,%eax
 319:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <stat>:

int
stat(char *n, struct stat *st)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 327:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 32e:	00 
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	89 04 24             	mov    %eax,(%esp)
 335:	e8 ba 01 00 00       	call   4f4 <open>
 33a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 33d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 341:	79 07                	jns    34a <stat+0x29>
    return -1;
 343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 348:	eb 23                	jmp    36d <stat+0x4c>
  r = fstat(fd, st);
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	89 44 24 04          	mov    %eax,0x4(%esp)
 351:	8b 45 f4             	mov    -0xc(%ebp),%eax
 354:	89 04 24             	mov    %eax,(%esp)
 357:	e8 b0 01 00 00       	call   50c <fstat>
 35c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 35f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 362:	89 04 24             	mov    %eax,(%esp)
 365:	e8 72 01 00 00       	call   4dc <close>
  return r;
 36a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <atoi>:

int
atoi(const char *s)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 375:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 37c:	eb 21                	jmp    39f <atoi+0x30>
    n = n*10 + *s++ - '0';
 37e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 381:	89 d0                	mov    %edx,%eax
 383:	c1 e0 02             	shl    $0x2,%eax
 386:	01 d0                	add    %edx,%eax
 388:	d1 e0                	shl    %eax
 38a:	89 c2                	mov    %eax,%edx
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	8a 00                	mov    (%eax),%al
 391:	0f be c0             	movsbl %al,%eax
 394:	01 d0                	add    %edx,%eax
 396:	83 e8 30             	sub    $0x30,%eax
 399:	89 45 fc             	mov    %eax,-0x4(%ebp)
 39c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	8a 00                	mov    (%eax),%al
 3a4:	3c 2f                	cmp    $0x2f,%al
 3a6:	7e 09                	jle    3b1 <atoi+0x42>
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	8a 00                	mov    (%eax),%al
 3ad:	3c 39                	cmp    $0x39,%al
 3af:	7e cd                	jle    37e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b4:	c9                   	leave  
 3b5:	c3                   	ret    

000003b6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3b6:	55                   	push   %ebp
 3b7:	89 e5                	mov    %esp,%ebp
 3b9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3bc:	8b 45 08             	mov    0x8(%ebp),%eax
 3bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3c8:	eb 10                	jmp    3da <memmove+0x24>
    *dst++ = *src++;
 3ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3cd:	8a 10                	mov    (%eax),%dl
 3cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d2:	88 10                	mov    %dl,(%eax)
 3d4:	ff 45 fc             	incl   -0x4(%ebp)
 3d7:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 3de:	0f 9f c0             	setg   %al
 3e1:	ff 4d 10             	decl   0x10(%ebp)
 3e4:	84 c0                	test   %al,%al
 3e6:	75 e2                	jne    3ca <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3eb:	c9                   	leave  
 3ec:	c3                   	ret    

000003ed <strtok>:

char*
strtok(char *teststr, char ch)
{
 3ed:	55                   	push   %ebp
 3ee:	89 e5                	mov    %esp,%ebp
 3f0:	83 ec 24             	sub    $0x24,%esp
 3f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f6:	88 45 dc             	mov    %al,-0x24(%ebp)
    char *dummystr = NULL;
 3f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    char *start = NULL;
 400:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    char *end = NULL;
 407:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char nullch = '\0';
 40e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    char *address_of_null = &nullch;
 412:	8d 45 ef             	lea    -0x11(%ebp),%eax
 415:	89 45 f0             	mov    %eax,-0x10(%ebp)
    static char *nexttok;

    if(teststr != NULL)
 418:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 41c:	74 08                	je     426 <strtok+0x39>
    {
        dummystr = teststr;
 41e:	8b 45 08             	mov    0x8(%ebp),%eax
 421:	89 45 fc             	mov    %eax,-0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 424:	eb 75                	jmp    49b <strtok+0xae>
    {
        dummystr = teststr;
    }
    else
    {
        if(*nexttok == '\0')
 426:	a1 ac 0c 00 00       	mov    0xcac,%eax
 42b:	8a 00                	mov    (%eax),%al
 42d:	84 c0                	test   %al,%al
 42f:	75 07                	jne    438 <strtok+0x4b>
            return NULL;
 431:	b8 00 00 00 00       	mov    $0x0,%eax
 436:	eb 6f                	jmp    4a7 <strtok+0xba>
        dummystr = nexttok;
 438:	a1 ac 0c 00 00       	mov    0xcac,%eax
 43d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }


    while(dummystr != NULL)
 440:	eb 59                	jmp    49b <strtok+0xae>
    {
        //empty string
        if(*dummystr == '\0')
 442:	8b 45 fc             	mov    -0x4(%ebp),%eax
 445:	8a 00                	mov    (%eax),%al
 447:	84 c0                	test   %al,%al
 449:	74 58                	je     4a3 <strtok+0xb6>
            break;
        if(*dummystr != ch)
 44b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 44e:	8a 00                	mov    (%eax),%al
 450:	3a 45 dc             	cmp    -0x24(%ebp),%al
 453:	74 22                	je     477 <strtok+0x8a>
        {
            if(!start)
 455:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 459:	75 06                	jne    461 <strtok+0x74>
                start = dummystr;
 45b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 45e:	89 45 f8             	mov    %eax,-0x8(%ebp)

            dummystr++;
 461:	ff 45 fc             	incl   -0x4(%ebp)

            // handle the case where the delimiter is not at the end of the string.
            if(*dummystr == '\0')
 464:	8b 45 fc             	mov    -0x4(%ebp),%eax
 467:	8a 00                	mov    (%eax),%al
 469:	84 c0                	test   %al,%al
 46b:	75 2e                	jne    49b <strtok+0xae>
            {
                nexttok = dummystr;
 46d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 470:	a3 ac 0c 00 00       	mov    %eax,0xcac
                break;
 475:	eb 2d                	jmp    4a4 <strtok+0xb7>
            }
        }
        else
        {
            if(start)
 477:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 47b:	74 1b                	je     498 <strtok+0xab>
            {
                end = dummystr;
 47d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 480:	89 45 f4             	mov    %eax,-0xc(%ebp)
                nexttok = dummystr+1;
 483:	8b 45 fc             	mov    -0x4(%ebp),%eax
 486:	40                   	inc    %eax
 487:	a3 ac 0c 00 00       	mov    %eax,0xcac
                *end = *address_of_null;
 48c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 48f:	8a 10                	mov    (%eax),%dl
 491:	8b 45 f4             	mov    -0xc(%ebp),%eax
 494:	88 10                	mov    %dl,(%eax)
                break;
 496:	eb 0c                	jmp    4a4 <strtok+0xb7>
            }
            else
            {
                dummystr++;
 498:	ff 45 fc             	incl   -0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 49b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
 49f:	75 a1                	jne    442 <strtok+0x55>
 4a1:	eb 01                	jmp    4a4 <strtok+0xb7>
    {
        //empty string
        if(*dummystr == '\0')
            break;
 4a3:	90                   	nop
                dummystr++;
            }
        }
    }

    return start;
 4a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 4a7:	c9                   	leave  
 4a8:	c3                   	ret    
 4a9:	66 90                	xchg   %ax,%ax
 4ab:	90                   	nop

000004ac <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ac:	b8 01 00 00 00       	mov    $0x1,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <exit>:
SYSCALL(exit)
 4b4:	b8 02 00 00 00       	mov    $0x2,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <wait>:
SYSCALL(wait)
 4bc:	b8 03 00 00 00       	mov    $0x3,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <pipe>:
SYSCALL(pipe)
 4c4:	b8 04 00 00 00       	mov    $0x4,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <read>:
SYSCALL(read)
 4cc:	b8 05 00 00 00       	mov    $0x5,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <write>:
SYSCALL(write)
 4d4:	b8 10 00 00 00       	mov    $0x10,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <close>:
SYSCALL(close)
 4dc:	b8 15 00 00 00       	mov    $0x15,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <kill>:
SYSCALL(kill)
 4e4:	b8 06 00 00 00       	mov    $0x6,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <exec>:
SYSCALL(exec)
 4ec:	b8 07 00 00 00       	mov    $0x7,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <open>:
SYSCALL(open)
 4f4:	b8 0f 00 00 00       	mov    $0xf,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <mknod>:
SYSCALL(mknod)
 4fc:	b8 11 00 00 00       	mov    $0x11,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <unlink>:
SYSCALL(unlink)
 504:	b8 12 00 00 00       	mov    $0x12,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <fstat>:
SYSCALL(fstat)
 50c:	b8 08 00 00 00       	mov    $0x8,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <link>:
SYSCALL(link)
 514:	b8 13 00 00 00       	mov    $0x13,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <mkdir>:
SYSCALL(mkdir)
 51c:	b8 14 00 00 00       	mov    $0x14,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <chdir>:
SYSCALL(chdir)
 524:	b8 09 00 00 00       	mov    $0x9,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <dup>:
SYSCALL(dup)
 52c:	b8 0a 00 00 00       	mov    $0xa,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <getpid>:
SYSCALL(getpid)
 534:	b8 0b 00 00 00       	mov    $0xb,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <sbrk>:
SYSCALL(sbrk)
 53c:	b8 0c 00 00 00       	mov    $0xc,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <sleep>:
SYSCALL(sleep)
 544:	b8 0d 00 00 00       	mov    $0xd,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <uptime>:
SYSCALL(uptime)
 54c:	b8 0e 00 00 00       	mov    $0xe,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <add_path>:
SYSCALL(add_path)
 554:	b8 16 00 00 00       	mov    $0x16,%eax
 559:	cd 40                	int    $0x40
 55b:	c3                   	ret    

0000055c <wait2>:
SYSCALL(wait2)
 55c:	b8 17 00 00 00       	mov    $0x17,%eax
 561:	cd 40                	int    $0x40
 563:	c3                   	ret    

00000564 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 564:	55                   	push   %ebp
 565:	89 e5                	mov    %esp,%ebp
 567:	83 ec 28             	sub    $0x28,%esp
 56a:	8b 45 0c             	mov    0xc(%ebp),%eax
 56d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 570:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 577:	00 
 578:	8d 45 f4             	lea    -0xc(%ebp),%eax
 57b:	89 44 24 04          	mov    %eax,0x4(%esp)
 57f:	8b 45 08             	mov    0x8(%ebp),%eax
 582:	89 04 24             	mov    %eax,(%esp)
 585:	e8 4a ff ff ff       	call   4d4 <write>
}
 58a:	c9                   	leave  
 58b:	c3                   	ret    

0000058c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 58c:	55                   	push   %ebp
 58d:	89 e5                	mov    %esp,%ebp
 58f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 592:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 599:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 59d:	74 17                	je     5b6 <printint+0x2a>
 59f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5a3:	79 11                	jns    5b6 <printint+0x2a>
    neg = 1;
 5a5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 5af:	f7 d8                	neg    %eax
 5b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5b4:	eb 06                	jmp    5bc <printint+0x30>
  } else {
    x = xx;
 5b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c9:	ba 00 00 00 00       	mov    $0x0,%edx
 5ce:	f7 f1                	div    %ecx
 5d0:	89 d0                	mov    %edx,%eax
 5d2:	8a 80 98 0c 00 00    	mov    0xc98(%eax),%al
 5d8:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 5db:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5de:	01 ca                	add    %ecx,%edx
 5e0:	88 02                	mov    %al,(%edx)
 5e2:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 5e5:	8b 55 10             	mov    0x10(%ebp),%edx
 5e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 5eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5ee:	ba 00 00 00 00       	mov    $0x0,%edx
 5f3:	f7 75 d4             	divl   -0x2c(%ebp)
 5f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5fd:	75 c4                	jne    5c3 <printint+0x37>
  if(neg)
 5ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 603:	74 2c                	je     631 <printint+0xa5>
    buf[i++] = '-';
 605:	8d 55 dc             	lea    -0x24(%ebp),%edx
 608:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60b:	01 d0                	add    %edx,%eax
 60d:	c6 00 2d             	movb   $0x2d,(%eax)
 610:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 613:	eb 1c                	jmp    631 <printint+0xa5>
    putc(fd, buf[i]);
 615:	8d 55 dc             	lea    -0x24(%ebp),%edx
 618:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61b:	01 d0                	add    %edx,%eax
 61d:	8a 00                	mov    (%eax),%al
 61f:	0f be c0             	movsbl %al,%eax
 622:	89 44 24 04          	mov    %eax,0x4(%esp)
 626:	8b 45 08             	mov    0x8(%ebp),%eax
 629:	89 04 24             	mov    %eax,(%esp)
 62c:	e8 33 ff ff ff       	call   564 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 631:	ff 4d f4             	decl   -0xc(%ebp)
 634:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 638:	79 db                	jns    615 <printint+0x89>
    putc(fd, buf[i]);
}
 63a:	c9                   	leave  
 63b:	c3                   	ret    

0000063c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 63c:	55                   	push   %ebp
 63d:	89 e5                	mov    %esp,%ebp
 63f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 642:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 649:	8d 45 0c             	lea    0xc(%ebp),%eax
 64c:	83 c0 04             	add    $0x4,%eax
 64f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 652:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 659:	e9 78 01 00 00       	jmp    7d6 <printf+0x19a>
    c = fmt[i] & 0xff;
 65e:	8b 55 0c             	mov    0xc(%ebp),%edx
 661:	8b 45 f0             	mov    -0x10(%ebp),%eax
 664:	01 d0                	add    %edx,%eax
 666:	8a 00                	mov    (%eax),%al
 668:	0f be c0             	movsbl %al,%eax
 66b:	25 ff 00 00 00       	and    $0xff,%eax
 670:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 673:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 677:	75 2c                	jne    6a5 <printf+0x69>
      if(c == '%'){
 679:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 67d:	75 0c                	jne    68b <printf+0x4f>
        state = '%';
 67f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 686:	e9 48 01 00 00       	jmp    7d3 <printf+0x197>
      } else {
        putc(fd, c);
 68b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68e:	0f be c0             	movsbl %al,%eax
 691:	89 44 24 04          	mov    %eax,0x4(%esp)
 695:	8b 45 08             	mov    0x8(%ebp),%eax
 698:	89 04 24             	mov    %eax,(%esp)
 69b:	e8 c4 fe ff ff       	call   564 <putc>
 6a0:	e9 2e 01 00 00       	jmp    7d3 <printf+0x197>
      }
    } else if(state == '%'){
 6a5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6a9:	0f 85 24 01 00 00    	jne    7d3 <printf+0x197>
      if(c == 'd'){
 6af:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6b3:	75 2d                	jne    6e2 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 6b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b8:	8b 00                	mov    (%eax),%eax
 6ba:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 6c1:	00 
 6c2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 6c9:	00 
 6ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ce:	8b 45 08             	mov    0x8(%ebp),%eax
 6d1:	89 04 24             	mov    %eax,(%esp)
 6d4:	e8 b3 fe ff ff       	call   58c <printint>
        ap++;
 6d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6dd:	e9 ea 00 00 00       	jmp    7cc <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 6e2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6e6:	74 06                	je     6ee <printf+0xb2>
 6e8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6ec:	75 2d                	jne    71b <printf+0xdf>
        printint(fd, *ap, 16, 0);
 6ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f1:	8b 00                	mov    (%eax),%eax
 6f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6fa:	00 
 6fb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 702:	00 
 703:	89 44 24 04          	mov    %eax,0x4(%esp)
 707:	8b 45 08             	mov    0x8(%ebp),%eax
 70a:	89 04 24             	mov    %eax,(%esp)
 70d:	e8 7a fe ff ff       	call   58c <printint>
        ap++;
 712:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 716:	e9 b1 00 00 00       	jmp    7cc <printf+0x190>
      } else if(c == 's'){
 71b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 71f:	75 43                	jne    764 <printf+0x128>
        s = (char*)*ap;
 721:	8b 45 e8             	mov    -0x18(%ebp),%eax
 724:	8b 00                	mov    (%eax),%eax
 726:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 729:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 72d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 731:	75 25                	jne    758 <printf+0x11c>
          s = "(null)";
 733:	c7 45 f4 30 0a 00 00 	movl   $0xa30,-0xc(%ebp)
        while(*s != 0){
 73a:	eb 1c                	jmp    758 <printf+0x11c>
          putc(fd, *s);
 73c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73f:	8a 00                	mov    (%eax),%al
 741:	0f be c0             	movsbl %al,%eax
 744:	89 44 24 04          	mov    %eax,0x4(%esp)
 748:	8b 45 08             	mov    0x8(%ebp),%eax
 74b:	89 04 24             	mov    %eax,(%esp)
 74e:	e8 11 fe ff ff       	call   564 <putc>
          s++;
 753:	ff 45 f4             	incl   -0xc(%ebp)
 756:	eb 01                	jmp    759 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 758:	90                   	nop
 759:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75c:	8a 00                	mov    (%eax),%al
 75e:	84 c0                	test   %al,%al
 760:	75 da                	jne    73c <printf+0x100>
 762:	eb 68                	jmp    7cc <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 764:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 768:	75 1d                	jne    787 <printf+0x14b>
        putc(fd, *ap);
 76a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 76d:	8b 00                	mov    (%eax),%eax
 76f:	0f be c0             	movsbl %al,%eax
 772:	89 44 24 04          	mov    %eax,0x4(%esp)
 776:	8b 45 08             	mov    0x8(%ebp),%eax
 779:	89 04 24             	mov    %eax,(%esp)
 77c:	e8 e3 fd ff ff       	call   564 <putc>
        ap++;
 781:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 785:	eb 45                	jmp    7cc <printf+0x190>
      } else if(c == '%'){
 787:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 78b:	75 17                	jne    7a4 <printf+0x168>
        putc(fd, c);
 78d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 790:	0f be c0             	movsbl %al,%eax
 793:	89 44 24 04          	mov    %eax,0x4(%esp)
 797:	8b 45 08             	mov    0x8(%ebp),%eax
 79a:	89 04 24             	mov    %eax,(%esp)
 79d:	e8 c2 fd ff ff       	call   564 <putc>
 7a2:	eb 28                	jmp    7cc <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7a4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7ab:	00 
 7ac:	8b 45 08             	mov    0x8(%ebp),%eax
 7af:	89 04 24             	mov    %eax,(%esp)
 7b2:	e8 ad fd ff ff       	call   564 <putc>
        putc(fd, c);
 7b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ba:	0f be c0             	movsbl %al,%eax
 7bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c1:	8b 45 08             	mov    0x8(%ebp),%eax
 7c4:	89 04 24             	mov    %eax,(%esp)
 7c7:	e8 98 fd ff ff       	call   564 <putc>
      }
      state = 0;
 7cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7d3:	ff 45 f0             	incl   -0x10(%ebp)
 7d6:	8b 55 0c             	mov    0xc(%ebp),%edx
 7d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dc:	01 d0                	add    %edx,%eax
 7de:	8a 00                	mov    (%eax),%al
 7e0:	84 c0                	test   %al,%al
 7e2:	0f 85 76 fe ff ff    	jne    65e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7e8:	c9                   	leave  
 7e9:	c3                   	ret    
 7ea:	66 90                	xchg   %ax,%ax

000007ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ec:	55                   	push   %ebp
 7ed:	89 e5                	mov    %esp,%ebp
 7ef:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f2:	8b 45 08             	mov    0x8(%ebp),%eax
 7f5:	83 e8 08             	sub    $0x8,%eax
 7f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fb:	a1 b8 0c 00 00       	mov    0xcb8,%eax
 800:	89 45 fc             	mov    %eax,-0x4(%ebp)
 803:	eb 24                	jmp    829 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 805:	8b 45 fc             	mov    -0x4(%ebp),%eax
 808:	8b 00                	mov    (%eax),%eax
 80a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 80d:	77 12                	ja     821 <free+0x35>
 80f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 812:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 815:	77 24                	ja     83b <free+0x4f>
 817:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81a:	8b 00                	mov    (%eax),%eax
 81c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 81f:	77 1a                	ja     83b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 821:	8b 45 fc             	mov    -0x4(%ebp),%eax
 824:	8b 00                	mov    (%eax),%eax
 826:	89 45 fc             	mov    %eax,-0x4(%ebp)
 829:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 82f:	76 d4                	jbe    805 <free+0x19>
 831:	8b 45 fc             	mov    -0x4(%ebp),%eax
 834:	8b 00                	mov    (%eax),%eax
 836:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 839:	76 ca                	jbe    805 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 83b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83e:	8b 40 04             	mov    0x4(%eax),%eax
 841:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 848:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84b:	01 c2                	add    %eax,%edx
 84d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 850:	8b 00                	mov    (%eax),%eax
 852:	39 c2                	cmp    %eax,%edx
 854:	75 24                	jne    87a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 856:	8b 45 f8             	mov    -0x8(%ebp),%eax
 859:	8b 50 04             	mov    0x4(%eax),%edx
 85c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85f:	8b 00                	mov    (%eax),%eax
 861:	8b 40 04             	mov    0x4(%eax),%eax
 864:	01 c2                	add    %eax,%edx
 866:	8b 45 f8             	mov    -0x8(%ebp),%eax
 869:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 86c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86f:	8b 00                	mov    (%eax),%eax
 871:	8b 10                	mov    (%eax),%edx
 873:	8b 45 f8             	mov    -0x8(%ebp),%eax
 876:	89 10                	mov    %edx,(%eax)
 878:	eb 0a                	jmp    884 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 87a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87d:	8b 10                	mov    (%eax),%edx
 87f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 882:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 884:	8b 45 fc             	mov    -0x4(%ebp),%eax
 887:	8b 40 04             	mov    0x4(%eax),%eax
 88a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 891:	8b 45 fc             	mov    -0x4(%ebp),%eax
 894:	01 d0                	add    %edx,%eax
 896:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 899:	75 20                	jne    8bb <free+0xcf>
    p->s.size += bp->s.size;
 89b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89e:	8b 50 04             	mov    0x4(%eax),%edx
 8a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a4:	8b 40 04             	mov    0x4(%eax),%eax
 8a7:	01 c2                	add    %eax,%edx
 8a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ac:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b2:	8b 10                	mov    (%eax),%edx
 8b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b7:	89 10                	mov    %edx,(%eax)
 8b9:	eb 08                	jmp    8c3 <free+0xd7>
  } else
    p->s.ptr = bp;
 8bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8be:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8c1:	89 10                	mov    %edx,(%eax)
  freep = p;
 8c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c6:	a3 b8 0c 00 00       	mov    %eax,0xcb8
}
 8cb:	c9                   	leave  
 8cc:	c3                   	ret    

000008cd <morecore>:

static Header*
morecore(uint nu)
{
 8cd:	55                   	push   %ebp
 8ce:	89 e5                	mov    %esp,%ebp
 8d0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8d3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8da:	77 07                	ja     8e3 <morecore+0x16>
    nu = 4096;
 8dc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8e3:	8b 45 08             	mov    0x8(%ebp),%eax
 8e6:	c1 e0 03             	shl    $0x3,%eax
 8e9:	89 04 24             	mov    %eax,(%esp)
 8ec:	e8 4b fc ff ff       	call   53c <sbrk>
 8f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8f4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8f8:	75 07                	jne    901 <morecore+0x34>
    return 0;
 8fa:	b8 00 00 00 00       	mov    $0x0,%eax
 8ff:	eb 22                	jmp    923 <morecore+0x56>
  hp = (Header*)p;
 901:	8b 45 f4             	mov    -0xc(%ebp),%eax
 904:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 907:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90a:	8b 55 08             	mov    0x8(%ebp),%edx
 90d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 910:	8b 45 f0             	mov    -0x10(%ebp),%eax
 913:	83 c0 08             	add    $0x8,%eax
 916:	89 04 24             	mov    %eax,(%esp)
 919:	e8 ce fe ff ff       	call   7ec <free>
  return freep;
 91e:	a1 b8 0c 00 00       	mov    0xcb8,%eax
}
 923:	c9                   	leave  
 924:	c3                   	ret    

00000925 <malloc>:

void*
malloc(uint nbytes)
{
 925:	55                   	push   %ebp
 926:	89 e5                	mov    %esp,%ebp
 928:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 92b:	8b 45 08             	mov    0x8(%ebp),%eax
 92e:	83 c0 07             	add    $0x7,%eax
 931:	c1 e8 03             	shr    $0x3,%eax
 934:	40                   	inc    %eax
 935:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 938:	a1 b8 0c 00 00       	mov    0xcb8,%eax
 93d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 940:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 944:	75 23                	jne    969 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 946:	c7 45 f0 b0 0c 00 00 	movl   $0xcb0,-0x10(%ebp)
 94d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 950:	a3 b8 0c 00 00       	mov    %eax,0xcb8
 955:	a1 b8 0c 00 00       	mov    0xcb8,%eax
 95a:	a3 b0 0c 00 00       	mov    %eax,0xcb0
    base.s.size = 0;
 95f:	c7 05 b4 0c 00 00 00 	movl   $0x0,0xcb4
 966:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 969:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96c:	8b 00                	mov    (%eax),%eax
 96e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 971:	8b 45 f4             	mov    -0xc(%ebp),%eax
 974:	8b 40 04             	mov    0x4(%eax),%eax
 977:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 97a:	72 4d                	jb     9c9 <malloc+0xa4>
      if(p->s.size == nunits)
 97c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97f:	8b 40 04             	mov    0x4(%eax),%eax
 982:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 985:	75 0c                	jne    993 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 987:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98a:	8b 10                	mov    (%eax),%edx
 98c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98f:	89 10                	mov    %edx,(%eax)
 991:	eb 26                	jmp    9b9 <malloc+0x94>
      else {
        p->s.size -= nunits;
 993:	8b 45 f4             	mov    -0xc(%ebp),%eax
 996:	8b 40 04             	mov    0x4(%eax),%eax
 999:	89 c2                	mov    %eax,%edx
 99b:	2b 55 ec             	sub    -0x14(%ebp),%edx
 99e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a7:	8b 40 04             	mov    0x4(%eax),%eax
 9aa:	c1 e0 03             	shl    $0x3,%eax
 9ad:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9b6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bc:	a3 b8 0c 00 00       	mov    %eax,0xcb8
      return (void*)(p + 1);
 9c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c4:	83 c0 08             	add    $0x8,%eax
 9c7:	eb 38                	jmp    a01 <malloc+0xdc>
    }
    if(p == freep)
 9c9:	a1 b8 0c 00 00       	mov    0xcb8,%eax
 9ce:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9d1:	75 1b                	jne    9ee <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 9d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9d6:	89 04 24             	mov    %eax,(%esp)
 9d9:	e8 ef fe ff ff       	call   8cd <morecore>
 9de:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9e5:	75 07                	jne    9ee <malloc+0xc9>
        return 0;
 9e7:	b8 00 00 00 00       	mov    $0x0,%eax
 9ec:	eb 13                	jmp    a01 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f7:	8b 00                	mov    (%eax),%eax
 9f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9fc:	e9 70 ff ff ff       	jmp    971 <malloc+0x4c>
}
 a01:	c9                   	leave  
 a02:	c3                   	ret    
