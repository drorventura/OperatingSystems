
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
   f:	c7 44 24 04 fb 07 00 	movl   $0x7fb,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 11 04 00 00       	call   434 <printf>
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

00000354 <addpath>:
SYSCALL(addpath)
 354:	b8 16 00 00 00       	mov    $0x16,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	83 ec 28             	sub    $0x28,%esp
 362:	8b 45 0c             	mov    0xc(%ebp),%eax
 365:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 368:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 36f:	00 
 370:	8d 45 f4             	lea    -0xc(%ebp),%eax
 373:	89 44 24 04          	mov    %eax,0x4(%esp)
 377:	8b 45 08             	mov    0x8(%ebp),%eax
 37a:	89 04 24             	mov    %eax,(%esp)
 37d:	e8 52 ff ff ff       	call   2d4 <write>
}
 382:	c9                   	leave  
 383:	c3                   	ret    

00000384 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 38a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 391:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 395:	74 17                	je     3ae <printint+0x2a>
 397:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 39b:	79 11                	jns    3ae <printint+0x2a>
    neg = 1;
 39d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a7:	f7 d8                	neg    %eax
 3a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ac:	eb 06                	jmp    3b4 <printint+0x30>
  } else {
    x = xx;
 3ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3be:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c1:	ba 00 00 00 00       	mov    $0x0,%edx
 3c6:	f7 f1                	div    %ecx
 3c8:	89 d0                	mov    %edx,%eax
 3ca:	8a 80 54 0a 00 00    	mov    0xa54(%eax),%al
 3d0:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3d6:	01 ca                	add    %ecx,%edx
 3d8:	88 02                	mov    %al,(%edx)
 3da:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3dd:	8b 55 10             	mov    0x10(%ebp),%edx
 3e0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e6:	ba 00 00 00 00       	mov    $0x0,%edx
 3eb:	f7 75 d4             	divl   -0x2c(%ebp)
 3ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f5:	75 c4                	jne    3bb <printint+0x37>
  if(neg)
 3f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3fb:	74 2c                	je     429 <printint+0xa5>
    buf[i++] = '-';
 3fd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 400:	8b 45 f4             	mov    -0xc(%ebp),%eax
 403:	01 d0                	add    %edx,%eax
 405:	c6 00 2d             	movb   $0x2d,(%eax)
 408:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 40b:	eb 1c                	jmp    429 <printint+0xa5>
    putc(fd, buf[i]);
 40d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 410:	8b 45 f4             	mov    -0xc(%ebp),%eax
 413:	01 d0                	add    %edx,%eax
 415:	8a 00                	mov    (%eax),%al
 417:	0f be c0             	movsbl %al,%eax
 41a:	89 44 24 04          	mov    %eax,0x4(%esp)
 41e:	8b 45 08             	mov    0x8(%ebp),%eax
 421:	89 04 24             	mov    %eax,(%esp)
 424:	e8 33 ff ff ff       	call   35c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 429:	ff 4d f4             	decl   -0xc(%ebp)
 42c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 430:	79 db                	jns    40d <printint+0x89>
    putc(fd, buf[i]);
}
 432:	c9                   	leave  
 433:	c3                   	ret    

00000434 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 43a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 441:	8d 45 0c             	lea    0xc(%ebp),%eax
 444:	83 c0 04             	add    $0x4,%eax
 447:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 44a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 451:	e9 78 01 00 00       	jmp    5ce <printf+0x19a>
    c = fmt[i] & 0xff;
 456:	8b 55 0c             	mov    0xc(%ebp),%edx
 459:	8b 45 f0             	mov    -0x10(%ebp),%eax
 45c:	01 d0                	add    %edx,%eax
 45e:	8a 00                	mov    (%eax),%al
 460:	0f be c0             	movsbl %al,%eax
 463:	25 ff 00 00 00       	and    $0xff,%eax
 468:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 46b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 46f:	75 2c                	jne    49d <printf+0x69>
      if(c == '%'){
 471:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 475:	75 0c                	jne    483 <printf+0x4f>
        state = '%';
 477:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 47e:	e9 48 01 00 00       	jmp    5cb <printf+0x197>
      } else {
        putc(fd, c);
 483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 486:	0f be c0             	movsbl %al,%eax
 489:	89 44 24 04          	mov    %eax,0x4(%esp)
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	89 04 24             	mov    %eax,(%esp)
 493:	e8 c4 fe ff ff       	call   35c <putc>
 498:	e9 2e 01 00 00       	jmp    5cb <printf+0x197>
      }
    } else if(state == '%'){
 49d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a1:	0f 85 24 01 00 00    	jne    5cb <printf+0x197>
      if(c == 'd'){
 4a7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ab:	75 2d                	jne    4da <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b0:	8b 00                	mov    (%eax),%eax
 4b2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4b9:	00 
 4ba:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4c1:	00 
 4c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c6:	8b 45 08             	mov    0x8(%ebp),%eax
 4c9:	89 04 24             	mov    %eax,(%esp)
 4cc:	e8 b3 fe ff ff       	call   384 <printint>
        ap++;
 4d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d5:	e9 ea 00 00 00       	jmp    5c4 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4da:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4de:	74 06                	je     4e6 <printf+0xb2>
 4e0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e4:	75 2d                	jne    513 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e9:	8b 00                	mov    (%eax),%eax
 4eb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4f2:	00 
 4f3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4fa:	00 
 4fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ff:	8b 45 08             	mov    0x8(%ebp),%eax
 502:	89 04 24             	mov    %eax,(%esp)
 505:	e8 7a fe ff ff       	call   384 <printint>
        ap++;
 50a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50e:	e9 b1 00 00 00       	jmp    5c4 <printf+0x190>
      } else if(c == 's'){
 513:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 517:	75 43                	jne    55c <printf+0x128>
        s = (char*)*ap;
 519:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51c:	8b 00                	mov    (%eax),%eax
 51e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 521:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 525:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 529:	75 25                	jne    550 <printf+0x11c>
          s = "(null)";
 52b:	c7 45 f4 0f 08 00 00 	movl   $0x80f,-0xc(%ebp)
        while(*s != 0){
 532:	eb 1c                	jmp    550 <printf+0x11c>
          putc(fd, *s);
 534:	8b 45 f4             	mov    -0xc(%ebp),%eax
 537:	8a 00                	mov    (%eax),%al
 539:	0f be c0             	movsbl %al,%eax
 53c:	89 44 24 04          	mov    %eax,0x4(%esp)
 540:	8b 45 08             	mov    0x8(%ebp),%eax
 543:	89 04 24             	mov    %eax,(%esp)
 546:	e8 11 fe ff ff       	call   35c <putc>
          s++;
 54b:	ff 45 f4             	incl   -0xc(%ebp)
 54e:	eb 01                	jmp    551 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 550:	90                   	nop
 551:	8b 45 f4             	mov    -0xc(%ebp),%eax
 554:	8a 00                	mov    (%eax),%al
 556:	84 c0                	test   %al,%al
 558:	75 da                	jne    534 <printf+0x100>
 55a:	eb 68                	jmp    5c4 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 55c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 560:	75 1d                	jne    57f <printf+0x14b>
        putc(fd, *ap);
 562:	8b 45 e8             	mov    -0x18(%ebp),%eax
 565:	8b 00                	mov    (%eax),%eax
 567:	0f be c0             	movsbl %al,%eax
 56a:	89 44 24 04          	mov    %eax,0x4(%esp)
 56e:	8b 45 08             	mov    0x8(%ebp),%eax
 571:	89 04 24             	mov    %eax,(%esp)
 574:	e8 e3 fd ff ff       	call   35c <putc>
        ap++;
 579:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57d:	eb 45                	jmp    5c4 <printf+0x190>
      } else if(c == '%'){
 57f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 583:	75 17                	jne    59c <printf+0x168>
        putc(fd, c);
 585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 588:	0f be c0             	movsbl %al,%eax
 58b:	89 44 24 04          	mov    %eax,0x4(%esp)
 58f:	8b 45 08             	mov    0x8(%ebp),%eax
 592:	89 04 24             	mov    %eax,(%esp)
 595:	e8 c2 fd ff ff       	call   35c <putc>
 59a:	eb 28                	jmp    5c4 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 59c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5a3:	00 
 5a4:	8b 45 08             	mov    0x8(%ebp),%eax
 5a7:	89 04 24             	mov    %eax,(%esp)
 5aa:	e8 ad fd ff ff       	call   35c <putc>
        putc(fd, c);
 5af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b2:	0f be c0             	movsbl %al,%eax
 5b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b9:	8b 45 08             	mov    0x8(%ebp),%eax
 5bc:	89 04 24             	mov    %eax,(%esp)
 5bf:	e8 98 fd ff ff       	call   35c <putc>
      }
      state = 0;
 5c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5cb:	ff 45 f0             	incl   -0x10(%ebp)
 5ce:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d4:	01 d0                	add    %edx,%eax
 5d6:	8a 00                	mov    (%eax),%al
 5d8:	84 c0                	test   %al,%al
 5da:	0f 85 76 fe ff ff    	jne    456 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5e0:	c9                   	leave  
 5e1:	c3                   	ret    
 5e2:	66 90                	xchg   %ax,%ax

000005e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e4:	55                   	push   %ebp
 5e5:	89 e5                	mov    %esp,%ebp
 5e7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ea:	8b 45 08             	mov    0x8(%ebp),%eax
 5ed:	83 e8 08             	sub    $0x8,%eax
 5f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f3:	a1 70 0a 00 00       	mov    0xa70,%eax
 5f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5fb:	eb 24                	jmp    621 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 600:	8b 00                	mov    (%eax),%eax
 602:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 605:	77 12                	ja     619 <free+0x35>
 607:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60d:	77 24                	ja     633 <free+0x4f>
 60f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 612:	8b 00                	mov    (%eax),%eax
 614:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 617:	77 1a                	ja     633 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 619:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61c:	8b 00                	mov    (%eax),%eax
 61e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 621:	8b 45 f8             	mov    -0x8(%ebp),%eax
 624:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 627:	76 d4                	jbe    5fd <free+0x19>
 629:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62c:	8b 00                	mov    (%eax),%eax
 62e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 631:	76 ca                	jbe    5fd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 633:	8b 45 f8             	mov    -0x8(%ebp),%eax
 636:	8b 40 04             	mov    0x4(%eax),%eax
 639:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 640:	8b 45 f8             	mov    -0x8(%ebp),%eax
 643:	01 c2                	add    %eax,%edx
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	39 c2                	cmp    %eax,%edx
 64c:	75 24                	jne    672 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	8b 50 04             	mov    0x4(%eax),%edx
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 00                	mov    (%eax),%eax
 659:	8b 40 04             	mov    0x4(%eax),%eax
 65c:	01 c2                	add    %eax,%edx
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	8b 10                	mov    (%eax),%edx
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	89 10                	mov    %edx,(%eax)
 670:	eb 0a                	jmp    67c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 10                	mov    (%eax),%edx
 677:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 40 04             	mov    0x4(%eax),%eax
 682:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	01 d0                	add    %edx,%eax
 68e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 691:	75 20                	jne    6b3 <free+0xcf>
    p->s.size += bp->s.size;
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	8b 50 04             	mov    0x4(%eax),%edx
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	8b 40 04             	mov    0x4(%eax),%eax
 69f:	01 c2                	add    %eax,%edx
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	8b 10                	mov    (%eax),%edx
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	89 10                	mov    %edx,(%eax)
 6b1:	eb 08                	jmp    6bb <free+0xd7>
  } else
    p->s.ptr = bp;
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b9:	89 10                	mov    %edx,(%eax)
  freep = p;
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	a3 70 0a 00 00       	mov    %eax,0xa70
}
 6c3:	c9                   	leave  
 6c4:	c3                   	ret    

000006c5 <morecore>:

static Header*
morecore(uint nu)
{
 6c5:	55                   	push   %ebp
 6c6:	89 e5                	mov    %esp,%ebp
 6c8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6cb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d2:	77 07                	ja     6db <morecore+0x16>
    nu = 4096;
 6d4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6db:	8b 45 08             	mov    0x8(%ebp),%eax
 6de:	c1 e0 03             	shl    $0x3,%eax
 6e1:	89 04 24             	mov    %eax,(%esp)
 6e4:	e8 53 fc ff ff       	call   33c <sbrk>
 6e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6ec:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6f0:	75 07                	jne    6f9 <morecore+0x34>
    return 0;
 6f2:	b8 00 00 00 00       	mov    $0x0,%eax
 6f7:	eb 22                	jmp    71b <morecore+0x56>
  hp = (Header*)p;
 6f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 702:	8b 55 08             	mov    0x8(%ebp),%edx
 705:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 708:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70b:	83 c0 08             	add    $0x8,%eax
 70e:	89 04 24             	mov    %eax,(%esp)
 711:	e8 ce fe ff ff       	call   5e4 <free>
  return freep;
 716:	a1 70 0a 00 00       	mov    0xa70,%eax
}
 71b:	c9                   	leave  
 71c:	c3                   	ret    

0000071d <malloc>:

void*
malloc(uint nbytes)
{
 71d:	55                   	push   %ebp
 71e:	89 e5                	mov    %esp,%ebp
 720:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 723:	8b 45 08             	mov    0x8(%ebp),%eax
 726:	83 c0 07             	add    $0x7,%eax
 729:	c1 e8 03             	shr    $0x3,%eax
 72c:	40                   	inc    %eax
 72d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 730:	a1 70 0a 00 00       	mov    0xa70,%eax
 735:	89 45 f0             	mov    %eax,-0x10(%ebp)
 738:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 73c:	75 23                	jne    761 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 73e:	c7 45 f0 68 0a 00 00 	movl   $0xa68,-0x10(%ebp)
 745:	8b 45 f0             	mov    -0x10(%ebp),%eax
 748:	a3 70 0a 00 00       	mov    %eax,0xa70
 74d:	a1 70 0a 00 00       	mov    0xa70,%eax
 752:	a3 68 0a 00 00       	mov    %eax,0xa68
    base.s.size = 0;
 757:	c7 05 6c 0a 00 00 00 	movl   $0x0,0xa6c
 75e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 761:	8b 45 f0             	mov    -0x10(%ebp),%eax
 764:	8b 00                	mov    (%eax),%eax
 766:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 769:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76c:	8b 40 04             	mov    0x4(%eax),%eax
 76f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 772:	72 4d                	jb     7c1 <malloc+0xa4>
      if(p->s.size == nunits)
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	8b 40 04             	mov    0x4(%eax),%eax
 77a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 77d:	75 0c                	jne    78b <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	8b 10                	mov    (%eax),%edx
 784:	8b 45 f0             	mov    -0x10(%ebp),%eax
 787:	89 10                	mov    %edx,(%eax)
 789:	eb 26                	jmp    7b1 <malloc+0x94>
      else {
        p->s.size -= nunits;
 78b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78e:	8b 40 04             	mov    0x4(%eax),%eax
 791:	89 c2                	mov    %eax,%edx
 793:	2b 55 ec             	sub    -0x14(%ebp),%edx
 796:	8b 45 f4             	mov    -0xc(%ebp),%eax
 799:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 79c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79f:	8b 40 04             	mov    0x4(%eax),%eax
 7a2:	c1 e0 03             	shl    $0x3,%eax
 7a5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ae:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	a3 70 0a 00 00       	mov    %eax,0xa70
      return (void*)(p + 1);
 7b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bc:	83 c0 08             	add    $0x8,%eax
 7bf:	eb 38                	jmp    7f9 <malloc+0xdc>
    }
    if(p == freep)
 7c1:	a1 70 0a 00 00       	mov    0xa70,%eax
 7c6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7c9:	75 1b                	jne    7e6 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ce:	89 04 24             	mov    %eax,(%esp)
 7d1:	e8 ef fe ff ff       	call   6c5 <morecore>
 7d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7dd:	75 07                	jne    7e6 <malloc+0xc9>
        return 0;
 7df:	b8 00 00 00 00       	mov    $0x0,%eax
 7e4:	eb 13                	jmp    7f9 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	8b 00                	mov    (%eax),%eax
 7f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7f4:	e9 70 ff ff ff       	jmp    769 <malloc+0x4c>
}
 7f9:	c9                   	leave  
 7fa:	c3                   	ret    
