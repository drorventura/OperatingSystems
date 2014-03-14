
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
   9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 f3 07 00 	movl   $0x7f3,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 09 04 00 00       	call   42c <printf>
    exit();
  23:	e8 8c 02 00 00       	call   2b4 <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 26                	jmp    58 <main+0x58>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 df 01 00 00       	call   22b <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 90 02 00 00       	call   2e4 <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  54:	ff 44 24 1c          	incl   0x1c(%esp)
  58:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  5f:	7c d1                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  61:	e8 4e 02 00 00       	call   2b4 <exit>
  66:	66 90                	xchg   %ax,%ax

00000068 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	57                   	push   %edi
  6c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  70:	8b 55 10             	mov    0x10(%ebp),%edx
  73:	8b 45 0c             	mov    0xc(%ebp),%eax
  76:	89 cb                	mov    %ecx,%ebx
  78:	89 df                	mov    %ebx,%edi
  7a:	89 d1                	mov    %edx,%ecx
  7c:	fc                   	cld    
  7d:	f3 aa                	rep stos %al,%es:(%edi)
  7f:	89 ca                	mov    %ecx,%edx
  81:	89 fb                	mov    %edi,%ebx
  83:	89 5d 08             	mov    %ebx,0x8(%ebp)
  86:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  89:	5b                   	pop    %ebx
  8a:	5f                   	pop    %edi
  8b:	5d                   	pop    %ebp
  8c:	c3                   	ret    

0000008d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  99:	90                   	nop
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	8a 10                	mov    (%eax),%dl
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	88 10                	mov    %dl,(%eax)
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	8a 00                	mov    (%eax),%al
  a9:	84 c0                	test   %al,%al
  ab:	0f 95 c0             	setne  %al
  ae:	ff 45 08             	incl   0x8(%ebp)
  b1:	ff 45 0c             	incl   0xc(%ebp)
  b4:	84 c0                	test   %al,%al
  b6:	75 e2                	jne    9a <strcpy+0xd>
    ;
  return os;
  b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bb:	c9                   	leave  
  bc:	c3                   	ret    

000000bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c0:	eb 06                	jmp    c8 <strcmp+0xb>
    p++, q++;
  c2:	ff 45 08             	incl   0x8(%ebp)
  c5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	8a 00                	mov    (%eax),%al
  cd:	84 c0                	test   %al,%al
  cf:	74 0e                	je     df <strcmp+0x22>
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	8a 10                	mov    (%eax),%dl
  d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  d9:	8a 00                	mov    (%eax),%al
  db:	38 c2                	cmp    %al,%dl
  dd:	74 e3                	je     c2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	8a 00                	mov    (%eax),%al
  e4:	0f b6 d0             	movzbl %al,%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	8a 00                	mov    (%eax),%al
  ec:	0f b6 c0             	movzbl %al,%eax
  ef:	89 d1                	mov    %edx,%ecx
  f1:	29 c1                	sub    %eax,%ecx
  f3:	89 c8                	mov    %ecx,%eax
}
  f5:	5d                   	pop    %ebp
  f6:	c3                   	ret    

000000f7 <strlen>:

uint
strlen(char *s)
{
  f7:	55                   	push   %ebp
  f8:	89 e5                	mov    %esp,%ebp
  fa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 104:	eb 03                	jmp    109 <strlen+0x12>
 106:	ff 45 fc             	incl   -0x4(%ebp)
 109:	8b 55 fc             	mov    -0x4(%ebp),%edx
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	01 d0                	add    %edx,%eax
 111:	8a 00                	mov    (%eax),%al
 113:	84 c0                	test   %al,%al
 115:	75 ef                	jne    106 <strlen+0xf>
    ;
  return n;
 117:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11a:	c9                   	leave  
 11b:	c3                   	ret    

0000011c <memset>:

void*
memset(void *dst, int c, uint n)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 122:	8b 45 10             	mov    0x10(%ebp),%eax
 125:	89 44 24 08          	mov    %eax,0x8(%esp)
 129:	8b 45 0c             	mov    0xc(%ebp),%eax
 12c:	89 44 24 04          	mov    %eax,0x4(%esp)
 130:	8b 45 08             	mov    0x8(%ebp),%eax
 133:	89 04 24             	mov    %eax,(%esp)
 136:	e8 2d ff ff ff       	call   68 <stosb>
  return dst;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 13e:	c9                   	leave  
 13f:	c3                   	ret    

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	83 ec 04             	sub    $0x4,%esp
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 14c:	eb 12                	jmp    160 <strchr+0x20>
    if(*s == c)
 14e:	8b 45 08             	mov    0x8(%ebp),%eax
 151:	8a 00                	mov    (%eax),%al
 153:	3a 45 fc             	cmp    -0x4(%ebp),%al
 156:	75 05                	jne    15d <strchr+0x1d>
      return (char*)s;
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	eb 11                	jmp    16e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 15d:	ff 45 08             	incl   0x8(%ebp)
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	8a 00                	mov    (%eax),%al
 165:	84 c0                	test   %al,%al
 167:	75 e5                	jne    14e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 169:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16e:	c9                   	leave  
 16f:	c3                   	ret    

00000170 <gets>:

char*
gets(char *buf, int max)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 176:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17d:	eb 42                	jmp    1c1 <gets+0x51>
    cc = read(0, &c, 1);
 17f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 186:	00 
 187:	8d 45 ef             	lea    -0x11(%ebp),%eax
 18a:	89 44 24 04          	mov    %eax,0x4(%esp)
 18e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 195:	e8 32 01 00 00       	call   2cc <read>
 19a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 19d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a1:	7e 29                	jle    1cc <gets+0x5c>
      break;
    buf[i++] = c;
 1a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	01 c2                	add    %eax,%edx
 1ab:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ae:	88 02                	mov    %al,(%edx)
 1b0:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1b3:	8a 45 ef             	mov    -0x11(%ebp),%al
 1b6:	3c 0a                	cmp    $0xa,%al
 1b8:	74 13                	je     1cd <gets+0x5d>
 1ba:	8a 45 ef             	mov    -0x11(%ebp),%al
 1bd:	3c 0d                	cmp    $0xd,%al
 1bf:	74 0c                	je     1cd <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c4:	40                   	inc    %eax
 1c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c8:	7c b5                	jl     17f <gets+0xf>
 1ca:	eb 01                	jmp    1cd <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1cc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <stat>:

int
stat(char *n, struct stat *st)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ea:	00 
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	89 04 24             	mov    %eax,(%esp)
 1f1:	e8 fe 00 00 00       	call   2f4 <open>
 1f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fd:	79 07                	jns    206 <stat+0x29>
    return -1;
 1ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 204:	eb 23                	jmp    229 <stat+0x4c>
  r = fstat(fd, st);
 206:	8b 45 0c             	mov    0xc(%ebp),%eax
 209:	89 44 24 04          	mov    %eax,0x4(%esp)
 20d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 210:	89 04 24             	mov    %eax,(%esp)
 213:	e8 f4 00 00 00       	call   30c <fstat>
 218:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21e:	89 04 24             	mov    %eax,(%esp)
 221:	e8 b6 00 00 00       	call   2dc <close>
  return r;
 226:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 229:	c9                   	leave  
 22a:	c3                   	ret    

0000022b <atoi>:

int
atoi(const char *s)
{
 22b:	55                   	push   %ebp
 22c:	89 e5                	mov    %esp,%ebp
 22e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 231:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 238:	eb 21                	jmp    25b <atoi+0x30>
    n = n*10 + *s++ - '0';
 23a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23d:	89 d0                	mov    %edx,%eax
 23f:	c1 e0 02             	shl    $0x2,%eax
 242:	01 d0                	add    %edx,%eax
 244:	d1 e0                	shl    %eax
 246:	89 c2                	mov    %eax,%edx
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	8a 00                	mov    (%eax),%al
 24d:	0f be c0             	movsbl %al,%eax
 250:	01 d0                	add    %edx,%eax
 252:	83 e8 30             	sub    $0x30,%eax
 255:	89 45 fc             	mov    %eax,-0x4(%ebp)
 258:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8a 00                	mov    (%eax),%al
 260:	3c 2f                	cmp    $0x2f,%al
 262:	7e 09                	jle    26d <atoi+0x42>
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	8a 00                	mov    (%eax),%al
 269:	3c 39                	cmp    $0x39,%al
 26b:	7e cd                	jle    23a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 26d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 270:	c9                   	leave  
 271:	c3                   	ret    

00000272 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 272:	55                   	push   %ebp
 273:	89 e5                	mov    %esp,%ebp
 275:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 27e:	8b 45 0c             	mov    0xc(%ebp),%eax
 281:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 284:	eb 10                	jmp    296 <memmove+0x24>
    *dst++ = *src++;
 286:	8b 45 f8             	mov    -0x8(%ebp),%eax
 289:	8a 10                	mov    (%eax),%dl
 28b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28e:	88 10                	mov    %dl,(%eax)
 290:	ff 45 fc             	incl   -0x4(%ebp)
 293:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 296:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 29a:	0f 9f c0             	setg   %al
 29d:	ff 4d 10             	decl   0x10(%ebp)
 2a0:	84 c0                	test   %al,%al
 2a2:	75 e2                	jne    286 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a7:	c9                   	leave  
 2a8:	c3                   	ret    
 2a9:	66 90                	xchg   %ax,%ax
 2ab:	90                   	nop

000002ac <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ac:	b8 01 00 00 00       	mov    $0x1,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <exit>:
SYSCALL(exit)
 2b4:	b8 02 00 00 00       	mov    $0x2,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <wait>:
SYSCALL(wait)
 2bc:	b8 03 00 00 00       	mov    $0x3,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <pipe>:
SYSCALL(pipe)
 2c4:	b8 04 00 00 00       	mov    $0x4,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <read>:
SYSCALL(read)
 2cc:	b8 05 00 00 00       	mov    $0x5,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <write>:
SYSCALL(write)
 2d4:	b8 10 00 00 00       	mov    $0x10,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <close>:
SYSCALL(close)
 2dc:	b8 15 00 00 00       	mov    $0x15,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <kill>:
SYSCALL(kill)
 2e4:	b8 06 00 00 00       	mov    $0x6,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <exec>:
SYSCALL(exec)
 2ec:	b8 07 00 00 00       	mov    $0x7,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <open>:
SYSCALL(open)
 2f4:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <mknod>:
SYSCALL(mknod)
 2fc:	b8 11 00 00 00       	mov    $0x11,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <unlink>:
SYSCALL(unlink)
 304:	b8 12 00 00 00       	mov    $0x12,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <fstat>:
SYSCALL(fstat)
 30c:	b8 08 00 00 00       	mov    $0x8,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <link>:
SYSCALL(link)
 314:	b8 13 00 00 00       	mov    $0x13,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <mkdir>:
SYSCALL(mkdir)
 31c:	b8 14 00 00 00       	mov    $0x14,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <chdir>:
SYSCALL(chdir)
 324:	b8 09 00 00 00       	mov    $0x9,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <dup>:
SYSCALL(dup)
 32c:	b8 0a 00 00 00       	mov    $0xa,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <getpid>:
SYSCALL(getpid)
 334:	b8 0b 00 00 00       	mov    $0xb,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <sbrk>:
SYSCALL(sbrk)
 33c:	b8 0c 00 00 00       	mov    $0xc,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <sleep>:
SYSCALL(sleep)
 344:	b8 0d 00 00 00       	mov    $0xd,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <uptime>:
SYSCALL(uptime)
 34c:	b8 0e 00 00 00       	mov    $0xe,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	83 ec 28             	sub    $0x28,%esp
 35a:	8b 45 0c             	mov    0xc(%ebp),%eax
 35d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 360:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 367:	00 
 368:	8d 45 f4             	lea    -0xc(%ebp),%eax
 36b:	89 44 24 04          	mov    %eax,0x4(%esp)
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	89 04 24             	mov    %eax,(%esp)
 375:	e8 5a ff ff ff       	call   2d4 <write>
}
 37a:	c9                   	leave  
 37b:	c3                   	ret    

0000037c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37c:	55                   	push   %ebp
 37d:	89 e5                	mov    %esp,%ebp
 37f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 382:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 389:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 38d:	74 17                	je     3a6 <printint+0x2a>
 38f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 393:	79 11                	jns    3a6 <printint+0x2a>
    neg = 1;
 395:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 39c:	8b 45 0c             	mov    0xc(%ebp),%eax
 39f:	f7 d8                	neg    %eax
 3a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a4:	eb 06                	jmp    3ac <printint+0x30>
  } else {
    x = xx;
 3a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b9:	ba 00 00 00 00       	mov    $0x0,%edx
 3be:	f7 f1                	div    %ecx
 3c0:	89 d0                	mov    %edx,%eax
 3c2:	8a 80 4c 0a 00 00    	mov    0xa4c(%eax),%al
 3c8:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3ce:	01 ca                	add    %ecx,%edx
 3d0:	88 02                	mov    %al,(%edx)
 3d2:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3d5:	8b 55 10             	mov    0x10(%ebp),%edx
 3d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3db:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3de:	ba 00 00 00 00       	mov    $0x0,%edx
 3e3:	f7 75 d4             	divl   -0x2c(%ebp)
 3e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3ed:	75 c4                	jne    3b3 <printint+0x37>
  if(neg)
 3ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f3:	74 2c                	je     421 <printint+0xa5>
    buf[i++] = '-';
 3f5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fb:	01 d0                	add    %edx,%eax
 3fd:	c6 00 2d             	movb   $0x2d,(%eax)
 400:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 403:	eb 1c                	jmp    421 <printint+0xa5>
    putc(fd, buf[i]);
 405:	8d 55 dc             	lea    -0x24(%ebp),%edx
 408:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40b:	01 d0                	add    %edx,%eax
 40d:	8a 00                	mov    (%eax),%al
 40f:	0f be c0             	movsbl %al,%eax
 412:	89 44 24 04          	mov    %eax,0x4(%esp)
 416:	8b 45 08             	mov    0x8(%ebp),%eax
 419:	89 04 24             	mov    %eax,(%esp)
 41c:	e8 33 ff ff ff       	call   354 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 421:	ff 4d f4             	decl   -0xc(%ebp)
 424:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 428:	79 db                	jns    405 <printint+0x89>
    putc(fd, buf[i]);
}
 42a:	c9                   	leave  
 42b:	c3                   	ret    

0000042c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 432:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 439:	8d 45 0c             	lea    0xc(%ebp),%eax
 43c:	83 c0 04             	add    $0x4,%eax
 43f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 442:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 449:	e9 78 01 00 00       	jmp    5c6 <printf+0x19a>
    c = fmt[i] & 0xff;
 44e:	8b 55 0c             	mov    0xc(%ebp),%edx
 451:	8b 45 f0             	mov    -0x10(%ebp),%eax
 454:	01 d0                	add    %edx,%eax
 456:	8a 00                	mov    (%eax),%al
 458:	0f be c0             	movsbl %al,%eax
 45b:	25 ff 00 00 00       	and    $0xff,%eax
 460:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 463:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 467:	75 2c                	jne    495 <printf+0x69>
      if(c == '%'){
 469:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 46d:	75 0c                	jne    47b <printf+0x4f>
        state = '%';
 46f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 476:	e9 48 01 00 00       	jmp    5c3 <printf+0x197>
      } else {
        putc(fd, c);
 47b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 47e:	0f be c0             	movsbl %al,%eax
 481:	89 44 24 04          	mov    %eax,0x4(%esp)
 485:	8b 45 08             	mov    0x8(%ebp),%eax
 488:	89 04 24             	mov    %eax,(%esp)
 48b:	e8 c4 fe ff ff       	call   354 <putc>
 490:	e9 2e 01 00 00       	jmp    5c3 <printf+0x197>
      }
    } else if(state == '%'){
 495:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 499:	0f 85 24 01 00 00    	jne    5c3 <printf+0x197>
      if(c == 'd'){
 49f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4a3:	75 2d                	jne    4d2 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a8:	8b 00                	mov    (%eax),%eax
 4aa:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4b1:	00 
 4b2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4b9:	00 
 4ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 4be:	8b 45 08             	mov    0x8(%ebp),%eax
 4c1:	89 04 24             	mov    %eax,(%esp)
 4c4:	e8 b3 fe ff ff       	call   37c <printint>
        ap++;
 4c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4cd:	e9 ea 00 00 00       	jmp    5bc <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4d2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4d6:	74 06                	je     4de <printf+0xb2>
 4d8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4dc:	75 2d                	jne    50b <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e1:	8b 00                	mov    (%eax),%eax
 4e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4ea:	00 
 4eb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4f2:	00 
 4f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f7:	8b 45 08             	mov    0x8(%ebp),%eax
 4fa:	89 04 24             	mov    %eax,(%esp)
 4fd:	e8 7a fe ff ff       	call   37c <printint>
        ap++;
 502:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 506:	e9 b1 00 00 00       	jmp    5bc <printf+0x190>
      } else if(c == 's'){
 50b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 50f:	75 43                	jne    554 <printf+0x128>
        s = (char*)*ap;
 511:	8b 45 e8             	mov    -0x18(%ebp),%eax
 514:	8b 00                	mov    (%eax),%eax
 516:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 519:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 51d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 521:	75 25                	jne    548 <printf+0x11c>
          s = "(null)";
 523:	c7 45 f4 07 08 00 00 	movl   $0x807,-0xc(%ebp)
        while(*s != 0){
 52a:	eb 1c                	jmp    548 <printf+0x11c>
          putc(fd, *s);
 52c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52f:	8a 00                	mov    (%eax),%al
 531:	0f be c0             	movsbl %al,%eax
 534:	89 44 24 04          	mov    %eax,0x4(%esp)
 538:	8b 45 08             	mov    0x8(%ebp),%eax
 53b:	89 04 24             	mov    %eax,(%esp)
 53e:	e8 11 fe ff ff       	call   354 <putc>
          s++;
 543:	ff 45 f4             	incl   -0xc(%ebp)
 546:	eb 01                	jmp    549 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 548:	90                   	nop
 549:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54c:	8a 00                	mov    (%eax),%al
 54e:	84 c0                	test   %al,%al
 550:	75 da                	jne    52c <printf+0x100>
 552:	eb 68                	jmp    5bc <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 554:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 558:	75 1d                	jne    577 <printf+0x14b>
        putc(fd, *ap);
 55a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55d:	8b 00                	mov    (%eax),%eax
 55f:	0f be c0             	movsbl %al,%eax
 562:	89 44 24 04          	mov    %eax,0x4(%esp)
 566:	8b 45 08             	mov    0x8(%ebp),%eax
 569:	89 04 24             	mov    %eax,(%esp)
 56c:	e8 e3 fd ff ff       	call   354 <putc>
        ap++;
 571:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 575:	eb 45                	jmp    5bc <printf+0x190>
      } else if(c == '%'){
 577:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57b:	75 17                	jne    594 <printf+0x168>
        putc(fd, c);
 57d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 580:	0f be c0             	movsbl %al,%eax
 583:	89 44 24 04          	mov    %eax,0x4(%esp)
 587:	8b 45 08             	mov    0x8(%ebp),%eax
 58a:	89 04 24             	mov    %eax,(%esp)
 58d:	e8 c2 fd ff ff       	call   354 <putc>
 592:	eb 28                	jmp    5bc <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 594:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 59b:	00 
 59c:	8b 45 08             	mov    0x8(%ebp),%eax
 59f:	89 04 24             	mov    %eax,(%esp)
 5a2:	e8 ad fd ff ff       	call   354 <putc>
        putc(fd, c);
 5a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5aa:	0f be c0             	movsbl %al,%eax
 5ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b1:	8b 45 08             	mov    0x8(%ebp),%eax
 5b4:	89 04 24             	mov    %eax,(%esp)
 5b7:	e8 98 fd ff ff       	call   354 <putc>
      }
      state = 0;
 5bc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c3:	ff 45 f0             	incl   -0x10(%ebp)
 5c6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5cc:	01 d0                	add    %edx,%eax
 5ce:	8a 00                	mov    (%eax),%al
 5d0:	84 c0                	test   %al,%al
 5d2:	0f 85 76 fe ff ff    	jne    44e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5d8:	c9                   	leave  
 5d9:	c3                   	ret    
 5da:	66 90                	xchg   %ax,%ax

000005dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5dc:	55                   	push   %ebp
 5dd:	89 e5                	mov    %esp,%ebp
 5df:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5e2:	8b 45 08             	mov    0x8(%ebp),%eax
 5e5:	83 e8 08             	sub    $0x8,%eax
 5e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5eb:	a1 68 0a 00 00       	mov    0xa68,%eax
 5f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f3:	eb 24                	jmp    619 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f8:	8b 00                	mov    (%eax),%eax
 5fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5fd:	77 12                	ja     611 <free+0x35>
 5ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 602:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 605:	77 24                	ja     62b <free+0x4f>
 607:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 60f:	77 1a                	ja     62b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	8b 45 fc             	mov    -0x4(%ebp),%eax
 614:	8b 00                	mov    (%eax),%eax
 616:	89 45 fc             	mov    %eax,-0x4(%ebp)
 619:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61f:	76 d4                	jbe    5f5 <free+0x19>
 621:	8b 45 fc             	mov    -0x4(%ebp),%eax
 624:	8b 00                	mov    (%eax),%eax
 626:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 629:	76 ca                	jbe    5f5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 62b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62e:	8b 40 04             	mov    0x4(%eax),%eax
 631:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 638:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63b:	01 c2                	add    %eax,%edx
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	39 c2                	cmp    %eax,%edx
 644:	75 24                	jne    66a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 646:	8b 45 f8             	mov    -0x8(%ebp),%eax
 649:	8b 50 04             	mov    0x4(%eax),%edx
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	8b 40 04             	mov    0x4(%eax),%eax
 654:	01 c2                	add    %eax,%edx
 656:	8b 45 f8             	mov    -0x8(%ebp),%eax
 659:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 65c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65f:	8b 00                	mov    (%eax),%eax
 661:	8b 10                	mov    (%eax),%edx
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	89 10                	mov    %edx,(%eax)
 668:	eb 0a                	jmp    674 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	8b 10                	mov    (%eax),%edx
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 40 04             	mov    0x4(%eax),%eax
 67a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	01 d0                	add    %edx,%eax
 686:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 689:	75 20                	jne    6ab <free+0xcf>
    p->s.size += bp->s.size;
 68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68e:	8b 50 04             	mov    0x4(%eax),%edx
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	8b 40 04             	mov    0x4(%eax),%eax
 697:	01 c2                	add    %eax,%edx
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	8b 10                	mov    (%eax),%edx
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	89 10                	mov    %edx,(%eax)
 6a9:	eb 08                	jmp    6b3 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b1:	89 10                	mov    %edx,(%eax)
  freep = p;
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	a3 68 0a 00 00       	mov    %eax,0xa68
}
 6bb:	c9                   	leave  
 6bc:	c3                   	ret    

000006bd <morecore>:

static Header*
morecore(uint nu)
{
 6bd:	55                   	push   %ebp
 6be:	89 e5                	mov    %esp,%ebp
 6c0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6c3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ca:	77 07                	ja     6d3 <morecore+0x16>
    nu = 4096;
 6cc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6d3:	8b 45 08             	mov    0x8(%ebp),%eax
 6d6:	c1 e0 03             	shl    $0x3,%eax
 6d9:	89 04 24             	mov    %eax,(%esp)
 6dc:	e8 5b fc ff ff       	call   33c <sbrk>
 6e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6e4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6e8:	75 07                	jne    6f1 <morecore+0x34>
    return 0;
 6ea:	b8 00 00 00 00       	mov    $0x0,%eax
 6ef:	eb 22                	jmp    713 <morecore+0x56>
  hp = (Header*)p;
 6f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fa:	8b 55 08             	mov    0x8(%ebp),%edx
 6fd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 700:	8b 45 f0             	mov    -0x10(%ebp),%eax
 703:	83 c0 08             	add    $0x8,%eax
 706:	89 04 24             	mov    %eax,(%esp)
 709:	e8 ce fe ff ff       	call   5dc <free>
  return freep;
 70e:	a1 68 0a 00 00       	mov    0xa68,%eax
}
 713:	c9                   	leave  
 714:	c3                   	ret    

00000715 <malloc>:

void*
malloc(uint nbytes)
{
 715:	55                   	push   %ebp
 716:	89 e5                	mov    %esp,%ebp
 718:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71b:	8b 45 08             	mov    0x8(%ebp),%eax
 71e:	83 c0 07             	add    $0x7,%eax
 721:	c1 e8 03             	shr    $0x3,%eax
 724:	40                   	inc    %eax
 725:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 728:	a1 68 0a 00 00       	mov    0xa68,%eax
 72d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 730:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 734:	75 23                	jne    759 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 736:	c7 45 f0 60 0a 00 00 	movl   $0xa60,-0x10(%ebp)
 73d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 740:	a3 68 0a 00 00       	mov    %eax,0xa68
 745:	a1 68 0a 00 00       	mov    0xa68,%eax
 74a:	a3 60 0a 00 00       	mov    %eax,0xa60
    base.s.size = 0;
 74f:	c7 05 64 0a 00 00 00 	movl   $0x0,0xa64
 756:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 759:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75c:	8b 00                	mov    (%eax),%eax
 75e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 761:	8b 45 f4             	mov    -0xc(%ebp),%eax
 764:	8b 40 04             	mov    0x4(%eax),%eax
 767:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76a:	72 4d                	jb     7b9 <malloc+0xa4>
      if(p->s.size == nunits)
 76c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76f:	8b 40 04             	mov    0x4(%eax),%eax
 772:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 775:	75 0c                	jne    783 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	8b 10                	mov    (%eax),%edx
 77c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77f:	89 10                	mov    %edx,(%eax)
 781:	eb 26                	jmp    7a9 <malloc+0x94>
      else {
        p->s.size -= nunits;
 783:	8b 45 f4             	mov    -0xc(%ebp),%eax
 786:	8b 40 04             	mov    0x4(%eax),%eax
 789:	89 c2                	mov    %eax,%edx
 78b:	2b 55 ec             	sub    -0x14(%ebp),%edx
 78e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 791:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 794:	8b 45 f4             	mov    -0xc(%ebp),%eax
 797:	8b 40 04             	mov    0x4(%eax),%eax
 79a:	c1 e0 03             	shl    $0x3,%eax
 79d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ac:	a3 68 0a 00 00       	mov    %eax,0xa68
      return (void*)(p + 1);
 7b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b4:	83 c0 08             	add    $0x8,%eax
 7b7:	eb 38                	jmp    7f1 <malloc+0xdc>
    }
    if(p == freep)
 7b9:	a1 68 0a 00 00       	mov    0xa68,%eax
 7be:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7c1:	75 1b                	jne    7de <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c6:	89 04 24             	mov    %eax,(%esp)
 7c9:	e8 ef fe ff ff       	call   6bd <morecore>
 7ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d5:	75 07                	jne    7de <malloc+0xc9>
        return 0;
 7d7:	b8 00 00 00 00       	mov    $0x0,%eax
 7dc:	eb 13                	jmp    7f1 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e7:	8b 00                	mov    (%eax),%eax
 7e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7ec:	e9 70 ff ff ff       	jmp    761 <malloc+0x4c>
}
 7f1:	c9                   	leave  
 7f2:	c3                   	ret    
