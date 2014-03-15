
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
  16:	bb 62 09 00 00       	mov    $0x962,%ebx
  1b:	b8 0a 00 00 00       	mov    $0xa,%eax
  20:	89 d7                	mov    %edx,%edi
  22:	89 de                	mov    %ebx,%esi
  24:	89 c1                	mov    %eax,%ecx
  26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	c7 44 24 04 3f 09 00 	movl   $0x93f,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 3c 05 00 00       	call   578 <printf>
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
  65:	e8 86 03 00 00       	call   3f0 <fork>
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
  8d:	c7 44 24 04 52 09 00 	movl   $0x952,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 d7 04 00 00       	call   578 <printf>

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
  cc:	e8 67 03 00 00       	call   438 <open>
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
  ff:	e8 14 03 00 00       	call   418 <write>

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
 11f:	e8 fc 02 00 00       	call   420 <close>

  printf(1, "read\n");
 124:	c7 44 24 04 5c 09 00 	movl   $0x95c,0x4(%esp)
 12b:	00 
 12c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 133:	e8 40 04 00 00       	call   578 <printf>

  fd = open(path, O_RDONLY);
 138:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 13f:	00 
 140:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 147:	89 04 24             	mov    %eax,(%esp)
 14a:	e8 e9 02 00 00       	call   438 <open>
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
 17d:	e8 8e 02 00 00       	call   410 <read>
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
 19d:	e8 7e 02 00 00       	call   420 <close>

  wait();
 1a2:	e8 59 02 00 00       	call   400 <wait>
  
  exit();
 1a7:	e8 4c 02 00 00       	call   3f8 <exit>

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
#include "user.h"
#include "x86.h"

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
 2d9:	e8 32 01 00 00       	call   410 <read>
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
 335:	e8 fe 00 00 00       	call   438 <open>
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
 357:	e8 f4 00 00 00       	call   450 <fstat>
 35c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 35f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 362:	89 04 24             	mov    %eax,(%esp)
 365:	e8 b6 00 00 00       	call   420 <close>
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
 3ed:	66 90                	xchg   %ax,%ax
 3ef:	90                   	nop

000003f0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3f0:	b8 01 00 00 00       	mov    $0x1,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <exit>:
SYSCALL(exit)
 3f8:	b8 02 00 00 00       	mov    $0x2,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <wait>:
SYSCALL(wait)
 400:	b8 03 00 00 00       	mov    $0x3,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <pipe>:
SYSCALL(pipe)
 408:	b8 04 00 00 00       	mov    $0x4,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <read>:
SYSCALL(read)
 410:	b8 05 00 00 00       	mov    $0x5,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <write>:
SYSCALL(write)
 418:	b8 10 00 00 00       	mov    $0x10,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <close>:
SYSCALL(close)
 420:	b8 15 00 00 00       	mov    $0x15,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <kill>:
SYSCALL(kill)
 428:	b8 06 00 00 00       	mov    $0x6,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <exec>:
SYSCALL(exec)
 430:	b8 07 00 00 00       	mov    $0x7,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <open>:
SYSCALL(open)
 438:	b8 0f 00 00 00       	mov    $0xf,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <mknod>:
SYSCALL(mknod)
 440:	b8 11 00 00 00       	mov    $0x11,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <unlink>:
SYSCALL(unlink)
 448:	b8 12 00 00 00       	mov    $0x12,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <fstat>:
SYSCALL(fstat)
 450:	b8 08 00 00 00       	mov    $0x8,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <link>:
SYSCALL(link)
 458:	b8 13 00 00 00       	mov    $0x13,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <mkdir>:
SYSCALL(mkdir)
 460:	b8 14 00 00 00       	mov    $0x14,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <chdir>:
SYSCALL(chdir)
 468:	b8 09 00 00 00       	mov    $0x9,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <dup>:
SYSCALL(dup)
 470:	b8 0a 00 00 00       	mov    $0xa,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <getpid>:
SYSCALL(getpid)
 478:	b8 0b 00 00 00       	mov    $0xb,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <sbrk>:
SYSCALL(sbrk)
 480:	b8 0c 00 00 00       	mov    $0xc,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <sleep>:
SYSCALL(sleep)
 488:	b8 0d 00 00 00       	mov    $0xd,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <uptime>:
SYSCALL(uptime)
 490:	b8 0e 00 00 00       	mov    $0xe,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <addpath>:
SYSCALL(addpath)
 498:	b8 16 00 00 00       	mov    $0x16,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	83 ec 28             	sub    $0x28,%esp
 4a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b3:	00 
 4b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	89 04 24             	mov    %eax,(%esp)
 4c1:	e8 52 ff ff ff       	call   418 <write>
}
 4c6:	c9                   	leave  
 4c7:	c3                   	ret    

000004c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c8:	55                   	push   %ebp
 4c9:	89 e5                	mov    %esp,%ebp
 4cb:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4d5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4d9:	74 17                	je     4f2 <printint+0x2a>
 4db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4df:	79 11                	jns    4f2 <printint+0x2a>
    neg = 1;
 4e1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4eb:	f7 d8                	neg    %eax
 4ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f0:	eb 06                	jmp    4f8 <printint+0x30>
  } else {
    x = xx;
 4f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
 502:	8b 45 ec             	mov    -0x14(%ebp),%eax
 505:	ba 00 00 00 00       	mov    $0x0,%edx
 50a:	f7 f1                	div    %ecx
 50c:	89 d0                	mov    %edx,%eax
 50e:	8a 80 b4 0b 00 00    	mov    0xbb4(%eax),%al
 514:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 517:	8b 55 f4             	mov    -0xc(%ebp),%edx
 51a:	01 ca                	add    %ecx,%edx
 51c:	88 02                	mov    %al,(%edx)
 51e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 521:	8b 55 10             	mov    0x10(%ebp),%edx
 524:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 527:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52a:	ba 00 00 00 00       	mov    $0x0,%edx
 52f:	f7 75 d4             	divl   -0x2c(%ebp)
 532:	89 45 ec             	mov    %eax,-0x14(%ebp)
 535:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 539:	75 c4                	jne    4ff <printint+0x37>
  if(neg)
 53b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 53f:	74 2c                	je     56d <printint+0xa5>
    buf[i++] = '-';
 541:	8d 55 dc             	lea    -0x24(%ebp),%edx
 544:	8b 45 f4             	mov    -0xc(%ebp),%eax
 547:	01 d0                	add    %edx,%eax
 549:	c6 00 2d             	movb   $0x2d,(%eax)
 54c:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 54f:	eb 1c                	jmp    56d <printint+0xa5>
    putc(fd, buf[i]);
 551:	8d 55 dc             	lea    -0x24(%ebp),%edx
 554:	8b 45 f4             	mov    -0xc(%ebp),%eax
 557:	01 d0                	add    %edx,%eax
 559:	8a 00                	mov    (%eax),%al
 55b:	0f be c0             	movsbl %al,%eax
 55e:	89 44 24 04          	mov    %eax,0x4(%esp)
 562:	8b 45 08             	mov    0x8(%ebp),%eax
 565:	89 04 24             	mov    %eax,(%esp)
 568:	e8 33 ff ff ff       	call   4a0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 56d:	ff 4d f4             	decl   -0xc(%ebp)
 570:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 574:	79 db                	jns    551 <printint+0x89>
    putc(fd, buf[i]);
}
 576:	c9                   	leave  
 577:	c3                   	ret    

00000578 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 57e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 585:	8d 45 0c             	lea    0xc(%ebp),%eax
 588:	83 c0 04             	add    $0x4,%eax
 58b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 58e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 595:	e9 78 01 00 00       	jmp    712 <printf+0x19a>
    c = fmt[i] & 0xff;
 59a:	8b 55 0c             	mov    0xc(%ebp),%edx
 59d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a0:	01 d0                	add    %edx,%eax
 5a2:	8a 00                	mov    (%eax),%al
 5a4:	0f be c0             	movsbl %al,%eax
 5a7:	25 ff 00 00 00       	and    $0xff,%eax
 5ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5b3:	75 2c                	jne    5e1 <printf+0x69>
      if(c == '%'){
 5b5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b9:	75 0c                	jne    5c7 <printf+0x4f>
        state = '%';
 5bb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5c2:	e9 48 01 00 00       	jmp    70f <printf+0x197>
      } else {
        putc(fd, c);
 5c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ca:	0f be c0             	movsbl %al,%eax
 5cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d1:	8b 45 08             	mov    0x8(%ebp),%eax
 5d4:	89 04 24             	mov    %eax,(%esp)
 5d7:	e8 c4 fe ff ff       	call   4a0 <putc>
 5dc:	e9 2e 01 00 00       	jmp    70f <printf+0x197>
      }
    } else if(state == '%'){
 5e1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5e5:	0f 85 24 01 00 00    	jne    70f <printf+0x197>
      if(c == 'd'){
 5eb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5ef:	75 2d                	jne    61e <printf+0xa6>
        printint(fd, *ap, 10, 1);
 5f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f4:	8b 00                	mov    (%eax),%eax
 5f6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5fd:	00 
 5fe:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 605:	00 
 606:	89 44 24 04          	mov    %eax,0x4(%esp)
 60a:	8b 45 08             	mov    0x8(%ebp),%eax
 60d:	89 04 24             	mov    %eax,(%esp)
 610:	e8 b3 fe ff ff       	call   4c8 <printint>
        ap++;
 615:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 619:	e9 ea 00 00 00       	jmp    708 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 61e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 622:	74 06                	je     62a <printf+0xb2>
 624:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 628:	75 2d                	jne    657 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 62a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62d:	8b 00                	mov    (%eax),%eax
 62f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 636:	00 
 637:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 63e:	00 
 63f:	89 44 24 04          	mov    %eax,0x4(%esp)
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	89 04 24             	mov    %eax,(%esp)
 649:	e8 7a fe ff ff       	call   4c8 <printint>
        ap++;
 64e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 652:	e9 b1 00 00 00       	jmp    708 <printf+0x190>
      } else if(c == 's'){
 657:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 65b:	75 43                	jne    6a0 <printf+0x128>
        s = (char*)*ap;
 65d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 665:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 66d:	75 25                	jne    694 <printf+0x11c>
          s = "(null)";
 66f:	c7 45 f4 6c 09 00 00 	movl   $0x96c,-0xc(%ebp)
        while(*s != 0){
 676:	eb 1c                	jmp    694 <printf+0x11c>
          putc(fd, *s);
 678:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67b:	8a 00                	mov    (%eax),%al
 67d:	0f be c0             	movsbl %al,%eax
 680:	89 44 24 04          	mov    %eax,0x4(%esp)
 684:	8b 45 08             	mov    0x8(%ebp),%eax
 687:	89 04 24             	mov    %eax,(%esp)
 68a:	e8 11 fe ff ff       	call   4a0 <putc>
          s++;
 68f:	ff 45 f4             	incl   -0xc(%ebp)
 692:	eb 01                	jmp    695 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 694:	90                   	nop
 695:	8b 45 f4             	mov    -0xc(%ebp),%eax
 698:	8a 00                	mov    (%eax),%al
 69a:	84 c0                	test   %al,%al
 69c:	75 da                	jne    678 <printf+0x100>
 69e:	eb 68                	jmp    708 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6a0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6a4:	75 1d                	jne    6c3 <printf+0x14b>
        putc(fd, *ap);
 6a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a9:	8b 00                	mov    (%eax),%eax
 6ab:	0f be c0             	movsbl %al,%eax
 6ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b2:	8b 45 08             	mov    0x8(%ebp),%eax
 6b5:	89 04 24             	mov    %eax,(%esp)
 6b8:	e8 e3 fd ff ff       	call   4a0 <putc>
        ap++;
 6bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c1:	eb 45                	jmp    708 <printf+0x190>
      } else if(c == '%'){
 6c3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6c7:	75 17                	jne    6e0 <printf+0x168>
        putc(fd, c);
 6c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6cc:	0f be c0             	movsbl %al,%eax
 6cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d3:	8b 45 08             	mov    0x8(%ebp),%eax
 6d6:	89 04 24             	mov    %eax,(%esp)
 6d9:	e8 c2 fd ff ff       	call   4a0 <putc>
 6de:	eb 28                	jmp    708 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6e0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6e7:	00 
 6e8:	8b 45 08             	mov    0x8(%ebp),%eax
 6eb:	89 04 24             	mov    %eax,(%esp)
 6ee:	e8 ad fd ff ff       	call   4a0 <putc>
        putc(fd, c);
 6f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f6:	0f be c0             	movsbl %al,%eax
 6f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6fd:	8b 45 08             	mov    0x8(%ebp),%eax
 700:	89 04 24             	mov    %eax,(%esp)
 703:	e8 98 fd ff ff       	call   4a0 <putc>
      }
      state = 0;
 708:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 70f:	ff 45 f0             	incl   -0x10(%ebp)
 712:	8b 55 0c             	mov    0xc(%ebp),%edx
 715:	8b 45 f0             	mov    -0x10(%ebp),%eax
 718:	01 d0                	add    %edx,%eax
 71a:	8a 00                	mov    (%eax),%al
 71c:	84 c0                	test   %al,%al
 71e:	0f 85 76 fe ff ff    	jne    59a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 724:	c9                   	leave  
 725:	c3                   	ret    
 726:	66 90                	xchg   %ax,%ax

00000728 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 728:	55                   	push   %ebp
 729:	89 e5                	mov    %esp,%ebp
 72b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72e:	8b 45 08             	mov    0x8(%ebp),%eax
 731:	83 e8 08             	sub    $0x8,%eax
 734:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 737:	a1 d0 0b 00 00       	mov    0xbd0,%eax
 73c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 73f:	eb 24                	jmp    765 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	8b 00                	mov    (%eax),%eax
 746:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 749:	77 12                	ja     75d <free+0x35>
 74b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 751:	77 24                	ja     777 <free+0x4f>
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	8b 00                	mov    (%eax),%eax
 758:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75b:	77 1a                	ja     777 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	8b 00                	mov    (%eax),%eax
 762:	89 45 fc             	mov    %eax,-0x4(%ebp)
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76b:	76 d4                	jbe    741 <free+0x19>
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	8b 00                	mov    (%eax),%eax
 772:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 775:	76 ca                	jbe    741 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	8b 40 04             	mov    0x4(%eax),%eax
 77d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 784:	8b 45 f8             	mov    -0x8(%ebp),%eax
 787:	01 c2                	add    %eax,%edx
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 00                	mov    (%eax),%eax
 78e:	39 c2                	cmp    %eax,%edx
 790:	75 24                	jne    7b6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 792:	8b 45 f8             	mov    -0x8(%ebp),%eax
 795:	8b 50 04             	mov    0x4(%eax),%edx
 798:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79b:	8b 00                	mov    (%eax),%eax
 79d:	8b 40 04             	mov    0x4(%eax),%eax
 7a0:	01 c2                	add    %eax,%edx
 7a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ab:	8b 00                	mov    (%eax),%eax
 7ad:	8b 10                	mov    (%eax),%edx
 7af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b2:	89 10                	mov    %edx,(%eax)
 7b4:	eb 0a                	jmp    7c0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b9:	8b 10                	mov    (%eax),%edx
 7bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7be:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c3:	8b 40 04             	mov    0x4(%eax),%eax
 7c6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d0:	01 d0                	add    %edx,%eax
 7d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d5:	75 20                	jne    7f7 <free+0xcf>
    p->s.size += bp->s.size;
 7d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7da:	8b 50 04             	mov    0x4(%eax),%edx
 7dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e0:	8b 40 04             	mov    0x4(%eax),%eax
 7e3:	01 c2                	add    %eax,%edx
 7e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ee:	8b 10                	mov    (%eax),%edx
 7f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f3:	89 10                	mov    %edx,(%eax)
 7f5:	eb 08                	jmp    7ff <free+0xd7>
  } else
    p->s.ptr = bp;
 7f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7fd:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	a3 d0 0b 00 00       	mov    %eax,0xbd0
}
 807:	c9                   	leave  
 808:	c3                   	ret    

00000809 <morecore>:

static Header*
morecore(uint nu)
{
 809:	55                   	push   %ebp
 80a:	89 e5                	mov    %esp,%ebp
 80c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 80f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 816:	77 07                	ja     81f <morecore+0x16>
    nu = 4096;
 818:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 81f:	8b 45 08             	mov    0x8(%ebp),%eax
 822:	c1 e0 03             	shl    $0x3,%eax
 825:	89 04 24             	mov    %eax,(%esp)
 828:	e8 53 fc ff ff       	call   480 <sbrk>
 82d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 830:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 834:	75 07                	jne    83d <morecore+0x34>
    return 0;
 836:	b8 00 00 00 00       	mov    $0x0,%eax
 83b:	eb 22                	jmp    85f <morecore+0x56>
  hp = (Header*)p;
 83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 840:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 843:	8b 45 f0             	mov    -0x10(%ebp),%eax
 846:	8b 55 08             	mov    0x8(%ebp),%edx
 849:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 84c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84f:	83 c0 08             	add    $0x8,%eax
 852:	89 04 24             	mov    %eax,(%esp)
 855:	e8 ce fe ff ff       	call   728 <free>
  return freep;
 85a:	a1 d0 0b 00 00       	mov    0xbd0,%eax
}
 85f:	c9                   	leave  
 860:	c3                   	ret    

00000861 <malloc>:

void*
malloc(uint nbytes)
{
 861:	55                   	push   %ebp
 862:	89 e5                	mov    %esp,%ebp
 864:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 867:	8b 45 08             	mov    0x8(%ebp),%eax
 86a:	83 c0 07             	add    $0x7,%eax
 86d:	c1 e8 03             	shr    $0x3,%eax
 870:	40                   	inc    %eax
 871:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 874:	a1 d0 0b 00 00       	mov    0xbd0,%eax
 879:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 880:	75 23                	jne    8a5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 882:	c7 45 f0 c8 0b 00 00 	movl   $0xbc8,-0x10(%ebp)
 889:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88c:	a3 d0 0b 00 00       	mov    %eax,0xbd0
 891:	a1 d0 0b 00 00       	mov    0xbd0,%eax
 896:	a3 c8 0b 00 00       	mov    %eax,0xbc8
    base.s.size = 0;
 89b:	c7 05 cc 0b 00 00 00 	movl   $0x0,0xbcc
 8a2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a8:	8b 00                	mov    (%eax),%eax
 8aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b0:	8b 40 04             	mov    0x4(%eax),%eax
 8b3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b6:	72 4d                	jb     905 <malloc+0xa4>
      if(p->s.size == nunits)
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	8b 40 04             	mov    0x4(%eax),%eax
 8be:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c1:	75 0c                	jne    8cf <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	8b 10                	mov    (%eax),%edx
 8c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cb:	89 10                	mov    %edx,(%eax)
 8cd:	eb 26                	jmp    8f5 <malloc+0x94>
      else {
        p->s.size -= nunits;
 8cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d2:	8b 40 04             	mov    0x4(%eax),%eax
 8d5:	89 c2                	mov    %eax,%edx
 8d7:	2b 55 ec             	sub    -0x14(%ebp),%edx
 8da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	8b 40 04             	mov    0x4(%eax),%eax
 8e6:	c1 e0 03             	shl    $0x3,%eax
 8e9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8f2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f8:	a3 d0 0b 00 00       	mov    %eax,0xbd0
      return (void*)(p + 1);
 8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 900:	83 c0 08             	add    $0x8,%eax
 903:	eb 38                	jmp    93d <malloc+0xdc>
    }
    if(p == freep)
 905:	a1 d0 0b 00 00       	mov    0xbd0,%eax
 90a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 90d:	75 1b                	jne    92a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 90f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 912:	89 04 24             	mov    %eax,(%esp)
 915:	e8 ef fe ff ff       	call   809 <morecore>
 91a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 91d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 921:	75 07                	jne    92a <malloc+0xc9>
        return 0;
 923:	b8 00 00 00 00       	mov    $0x0,%eax
 928:	eb 13                	jmp    93d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 930:	8b 45 f4             	mov    -0xc(%ebp),%eax
 933:	8b 00                	mov    (%eax),%eax
 935:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 938:	e9 70 ff ff ff       	jmp    8ad <malloc+0x4c>
}
 93d:	c9                   	leave  
 93e:	c3                   	ret    
