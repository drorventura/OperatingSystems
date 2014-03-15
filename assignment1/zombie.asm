
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 5a 02 00 00       	call   268 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 e2 02 00 00       	call   300 <sleep>
  exit();
  1e:	e8 4d 02 00 00       	call   270 <exit>
  23:	90                   	nop

00000024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	57                   	push   %edi
  28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 10             	mov    0x10(%ebp),%edx
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	89 cb                	mov    %ecx,%ebx
  34:	89 df                	mov    %ebx,%edi
  36:	89 d1                	mov    %edx,%ecx
  38:	fc                   	cld    
  39:	f3 aa                	rep stos %al,%es:(%edi)
  3b:	89 ca                	mov    %ecx,%edx
  3d:	89 fb                	mov    %edi,%ebx
  3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  45:	5b                   	pop    %ebx
  46:	5f                   	pop    %edi
  47:	5d                   	pop    %ebp
  48:	c3                   	ret    

00000049 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  49:	55                   	push   %ebp
  4a:	89 e5                	mov    %esp,%ebp
  4c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4f:	8b 45 08             	mov    0x8(%ebp),%eax
  52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  55:	90                   	nop
  56:	8b 45 0c             	mov    0xc(%ebp),%eax
  59:	8a 10                	mov    (%eax),%dl
  5b:	8b 45 08             	mov    0x8(%ebp),%eax
  5e:	88 10                	mov    %dl,(%eax)
  60:	8b 45 08             	mov    0x8(%ebp),%eax
  63:	8a 00                	mov    (%eax),%al
  65:	84 c0                	test   %al,%al
  67:	0f 95 c0             	setne  %al
  6a:	ff 45 08             	incl   0x8(%ebp)
  6d:	ff 45 0c             	incl   0xc(%ebp)
  70:	84 c0                	test   %al,%al
  72:	75 e2                	jne    56 <strcpy+0xd>
    ;
  return os;
  74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  77:	c9                   	leave  
  78:	c3                   	ret    

00000079 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7c:	eb 06                	jmp    84 <strcmp+0xb>
    p++, q++;
  7e:	ff 45 08             	incl   0x8(%ebp)
  81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  84:	8b 45 08             	mov    0x8(%ebp),%eax
  87:	8a 00                	mov    (%eax),%al
  89:	84 c0                	test   %al,%al
  8b:	74 0e                	je     9b <strcmp+0x22>
  8d:	8b 45 08             	mov    0x8(%ebp),%eax
  90:	8a 10                	mov    (%eax),%dl
  92:	8b 45 0c             	mov    0xc(%ebp),%eax
  95:	8a 00                	mov    (%eax),%al
  97:	38 c2                	cmp    %al,%dl
  99:	74 e3                	je     7e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  9b:	8b 45 08             	mov    0x8(%ebp),%eax
  9e:	8a 00                	mov    (%eax),%al
  a0:	0f b6 d0             	movzbl %al,%edx
  a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  a6:	8a 00                	mov    (%eax),%al
  a8:	0f b6 c0             	movzbl %al,%eax
  ab:	89 d1                	mov    %edx,%ecx
  ad:	29 c1                	sub    %eax,%ecx
  af:	89 c8                	mov    %ecx,%eax
}
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    

000000b3 <strlen>:

uint
strlen(char *s)
{
  b3:	55                   	push   %ebp
  b4:	89 e5                	mov    %esp,%ebp
  b6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c0:	eb 03                	jmp    c5 <strlen+0x12>
  c2:	ff 45 fc             	incl   -0x4(%ebp)
  c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	01 d0                	add    %edx,%eax
  cd:	8a 00                	mov    (%eax),%al
  cf:	84 c0                	test   %al,%al
  d1:	75 ef                	jne    c2 <strlen+0xf>
    ;
  return n;
  d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d6:	c9                   	leave  
  d7:	c3                   	ret    

000000d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d8:	55                   	push   %ebp
  d9:	89 e5                	mov    %esp,%ebp
  db:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  de:	8b 45 10             	mov    0x10(%ebp),%eax
  e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	89 04 24             	mov    %eax,(%esp)
  f2:	e8 2d ff ff ff       	call   24 <stosb>
  return dst;
  f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  fa:	c9                   	leave  
  fb:	c3                   	ret    

000000fc <strchr>:

char*
strchr(const char *s, char c)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	83 ec 04             	sub    $0x4,%esp
 102:	8b 45 0c             	mov    0xc(%ebp),%eax
 105:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 108:	eb 12                	jmp    11c <strchr+0x20>
    if(*s == c)
 10a:	8b 45 08             	mov    0x8(%ebp),%eax
 10d:	8a 00                	mov    (%eax),%al
 10f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 112:	75 05                	jne    119 <strchr+0x1d>
      return (char*)s;
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	eb 11                	jmp    12a <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 119:	ff 45 08             	incl   0x8(%ebp)
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	8a 00                	mov    (%eax),%al
 121:	84 c0                	test   %al,%al
 123:	75 e5                	jne    10a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 125:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12a:	c9                   	leave  
 12b:	c3                   	ret    

0000012c <gets>:

char*
gets(char *buf, int max)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 132:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 139:	eb 42                	jmp    17d <gets+0x51>
    cc = read(0, &c, 1);
 13b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 142:	00 
 143:	8d 45 ef             	lea    -0x11(%ebp),%eax
 146:	89 44 24 04          	mov    %eax,0x4(%esp)
 14a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 151:	e8 32 01 00 00       	call   288 <read>
 156:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 159:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15d:	7e 29                	jle    188 <gets+0x5c>
      break;
    buf[i++] = c;
 15f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	01 c2                	add    %eax,%edx
 167:	8a 45 ef             	mov    -0x11(%ebp),%al
 16a:	88 02                	mov    %al,(%edx)
 16c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 16f:	8a 45 ef             	mov    -0x11(%ebp),%al
 172:	3c 0a                	cmp    $0xa,%al
 174:	74 13                	je     189 <gets+0x5d>
 176:	8a 45 ef             	mov    -0x11(%ebp),%al
 179:	3c 0d                	cmp    $0xd,%al
 17b:	74 0c                	je     189 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 180:	40                   	inc    %eax
 181:	3b 45 0c             	cmp    0xc(%ebp),%eax
 184:	7c b5                	jl     13b <gets+0xf>
 186:	eb 01                	jmp    189 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 188:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 189:	8b 55 f4             	mov    -0xc(%ebp),%edx
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	01 d0                	add    %edx,%eax
 191:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 194:	8b 45 08             	mov    0x8(%ebp),%eax
}
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <stat>:

int
stat(char *n, struct stat *st)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1a6:	00 
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	89 04 24             	mov    %eax,(%esp)
 1ad:	e8 fe 00 00 00       	call   2b0 <open>
 1b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b9:	79 07                	jns    1c2 <stat+0x29>
    return -1;
 1bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c0:	eb 23                	jmp    1e5 <stat+0x4c>
  r = fstat(fd, st);
 1c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cc:	89 04 24             	mov    %eax,(%esp)
 1cf:	e8 f4 00 00 00       	call   2c8 <fstat>
 1d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1da:	89 04 24             	mov    %eax,(%esp)
 1dd:	e8 b6 00 00 00       	call   298 <close>
  return r;
 1e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e5:	c9                   	leave  
 1e6:	c3                   	ret    

000001e7 <atoi>:

int
atoi(const char *s)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1f4:	eb 21                	jmp    217 <atoi+0x30>
    n = n*10 + *s++ - '0';
 1f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f9:	89 d0                	mov    %edx,%eax
 1fb:	c1 e0 02             	shl    $0x2,%eax
 1fe:	01 d0                	add    %edx,%eax
 200:	d1 e0                	shl    %eax
 202:	89 c2                	mov    %eax,%edx
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	8a 00                	mov    (%eax),%al
 209:	0f be c0             	movsbl %al,%eax
 20c:	01 d0                	add    %edx,%eax
 20e:	83 e8 30             	sub    $0x30,%eax
 211:	89 45 fc             	mov    %eax,-0x4(%ebp)
 214:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	8a 00                	mov    (%eax),%al
 21c:	3c 2f                	cmp    $0x2f,%al
 21e:	7e 09                	jle    229 <atoi+0x42>
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	8a 00                	mov    (%eax),%al
 225:	3c 39                	cmp    $0x39,%al
 227:	7e cd                	jle    1f6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 229:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22c:	c9                   	leave  
 22d:	c3                   	ret    

0000022e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
 231:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 23a:	8b 45 0c             	mov    0xc(%ebp),%eax
 23d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 240:	eb 10                	jmp    252 <memmove+0x24>
    *dst++ = *src++;
 242:	8b 45 f8             	mov    -0x8(%ebp),%eax
 245:	8a 10                	mov    (%eax),%dl
 247:	8b 45 fc             	mov    -0x4(%ebp),%eax
 24a:	88 10                	mov    %dl,(%eax)
 24c:	ff 45 fc             	incl   -0x4(%ebp)
 24f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 252:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 256:	0f 9f c0             	setg   %al
 259:	ff 4d 10             	decl   0x10(%ebp)
 25c:	84 c0                	test   %al,%al
 25e:	75 e2                	jne    242 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 260:	8b 45 08             	mov    0x8(%ebp),%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    
 265:	66 90                	xchg   %ax,%ax
 267:	90                   	nop

00000268 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 268:	b8 01 00 00 00       	mov    $0x1,%eax
 26d:	cd 40                	int    $0x40
 26f:	c3                   	ret    

00000270 <exit>:
SYSCALL(exit)
 270:	b8 02 00 00 00       	mov    $0x2,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <wait>:
SYSCALL(wait)
 278:	b8 03 00 00 00       	mov    $0x3,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <pipe>:
SYSCALL(pipe)
 280:	b8 04 00 00 00       	mov    $0x4,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <read>:
SYSCALL(read)
 288:	b8 05 00 00 00       	mov    $0x5,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <write>:
SYSCALL(write)
 290:	b8 10 00 00 00       	mov    $0x10,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <close>:
SYSCALL(close)
 298:	b8 15 00 00 00       	mov    $0x15,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <kill>:
SYSCALL(kill)
 2a0:	b8 06 00 00 00       	mov    $0x6,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <exec>:
SYSCALL(exec)
 2a8:	b8 07 00 00 00       	mov    $0x7,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <open>:
SYSCALL(open)
 2b0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <mknod>:
SYSCALL(mknod)
 2b8:	b8 11 00 00 00       	mov    $0x11,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <unlink>:
SYSCALL(unlink)
 2c0:	b8 12 00 00 00       	mov    $0x12,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <fstat>:
SYSCALL(fstat)
 2c8:	b8 08 00 00 00       	mov    $0x8,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <link>:
SYSCALL(link)
 2d0:	b8 13 00 00 00       	mov    $0x13,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <mkdir>:
SYSCALL(mkdir)
 2d8:	b8 14 00 00 00       	mov    $0x14,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <chdir>:
SYSCALL(chdir)
 2e0:	b8 09 00 00 00       	mov    $0x9,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <dup>:
SYSCALL(dup)
 2e8:	b8 0a 00 00 00       	mov    $0xa,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <getpid>:
SYSCALL(getpid)
 2f0:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <sbrk>:
SYSCALL(sbrk)
 2f8:	b8 0c 00 00 00       	mov    $0xc,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <sleep>:
SYSCALL(sleep)
 300:	b8 0d 00 00 00       	mov    $0xd,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <uptime>:
SYSCALL(uptime)
 308:	b8 0e 00 00 00       	mov    $0xe,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <addpath>:
SYSCALL(addpath)
 310:	b8 16 00 00 00       	mov    $0x16,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 318:	55                   	push   %ebp
 319:	89 e5                	mov    %esp,%ebp
 31b:	83 ec 28             	sub    $0x28,%esp
 31e:	8b 45 0c             	mov    0xc(%ebp),%eax
 321:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 324:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 32b:	00 
 32c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 32f:	89 44 24 04          	mov    %eax,0x4(%esp)
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	89 04 24             	mov    %eax,(%esp)
 339:	e8 52 ff ff ff       	call   290 <write>
}
 33e:	c9                   	leave  
 33f:	c3                   	ret    

00000340 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 346:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 34d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 351:	74 17                	je     36a <printint+0x2a>
 353:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 357:	79 11                	jns    36a <printint+0x2a>
    neg = 1;
 359:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 360:	8b 45 0c             	mov    0xc(%ebp),%eax
 363:	f7 d8                	neg    %eax
 365:	89 45 ec             	mov    %eax,-0x14(%ebp)
 368:	eb 06                	jmp    370 <printint+0x30>
  } else {
    x = xx;
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 370:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 377:	8b 4d 10             	mov    0x10(%ebp),%ecx
 37a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 37d:	ba 00 00 00 00       	mov    $0x0,%edx
 382:	f7 f1                	div    %ecx
 384:	89 d0                	mov    %edx,%eax
 386:	8a 80 fc 09 00 00    	mov    0x9fc(%eax),%al
 38c:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 38f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 392:	01 ca                	add    %ecx,%edx
 394:	88 02                	mov    %al,(%edx)
 396:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 399:	8b 55 10             	mov    0x10(%ebp),%edx
 39c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 39f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a2:	ba 00 00 00 00       	mov    $0x0,%edx
 3a7:	f7 75 d4             	divl   -0x2c(%ebp)
 3aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3b1:	75 c4                	jne    377 <printint+0x37>
  if(neg)
 3b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3b7:	74 2c                	je     3e5 <printint+0xa5>
    buf[i++] = '-';
 3b9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3bf:	01 d0                	add    %edx,%eax
 3c1:	c6 00 2d             	movb   $0x2d,(%eax)
 3c4:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3c7:	eb 1c                	jmp    3e5 <printint+0xa5>
    putc(fd, buf[i]);
 3c9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3cf:	01 d0                	add    %edx,%eax
 3d1:	8a 00                	mov    (%eax),%al
 3d3:	0f be c0             	movsbl %al,%eax
 3d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 3da:	8b 45 08             	mov    0x8(%ebp),%eax
 3dd:	89 04 24             	mov    %eax,(%esp)
 3e0:	e8 33 ff ff ff       	call   318 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3e5:	ff 4d f4             	decl   -0xc(%ebp)
 3e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3ec:	79 db                	jns    3c9 <printint+0x89>
    putc(fd, buf[i]);
}
 3ee:	c9                   	leave  
 3ef:	c3                   	ret    

000003f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 3f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 3fd:	8d 45 0c             	lea    0xc(%ebp),%eax
 400:	83 c0 04             	add    $0x4,%eax
 403:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 406:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 40d:	e9 78 01 00 00       	jmp    58a <printf+0x19a>
    c = fmt[i] & 0xff;
 412:	8b 55 0c             	mov    0xc(%ebp),%edx
 415:	8b 45 f0             	mov    -0x10(%ebp),%eax
 418:	01 d0                	add    %edx,%eax
 41a:	8a 00                	mov    (%eax),%al
 41c:	0f be c0             	movsbl %al,%eax
 41f:	25 ff 00 00 00       	and    $0xff,%eax
 424:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 427:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 42b:	75 2c                	jne    459 <printf+0x69>
      if(c == '%'){
 42d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 431:	75 0c                	jne    43f <printf+0x4f>
        state = '%';
 433:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 43a:	e9 48 01 00 00       	jmp    587 <printf+0x197>
      } else {
        putc(fd, c);
 43f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 442:	0f be c0             	movsbl %al,%eax
 445:	89 44 24 04          	mov    %eax,0x4(%esp)
 449:	8b 45 08             	mov    0x8(%ebp),%eax
 44c:	89 04 24             	mov    %eax,(%esp)
 44f:	e8 c4 fe ff ff       	call   318 <putc>
 454:	e9 2e 01 00 00       	jmp    587 <printf+0x197>
      }
    } else if(state == '%'){
 459:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 45d:	0f 85 24 01 00 00    	jne    587 <printf+0x197>
      if(c == 'd'){
 463:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 467:	75 2d                	jne    496 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 469:	8b 45 e8             	mov    -0x18(%ebp),%eax
 46c:	8b 00                	mov    (%eax),%eax
 46e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 475:	00 
 476:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 47d:	00 
 47e:	89 44 24 04          	mov    %eax,0x4(%esp)
 482:	8b 45 08             	mov    0x8(%ebp),%eax
 485:	89 04 24             	mov    %eax,(%esp)
 488:	e8 b3 fe ff ff       	call   340 <printint>
        ap++;
 48d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 491:	e9 ea 00 00 00       	jmp    580 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 496:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 49a:	74 06                	je     4a2 <printf+0xb2>
 49c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4a0:	75 2d                	jne    4cf <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a5:	8b 00                	mov    (%eax),%eax
 4a7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4ae:	00 
 4af:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4b6:	00 
 4b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	89 04 24             	mov    %eax,(%esp)
 4c1:	e8 7a fe ff ff       	call   340 <printint>
        ap++;
 4c6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ca:	e9 b1 00 00 00       	jmp    580 <printf+0x190>
      } else if(c == 's'){
 4cf:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4d3:	75 43                	jne    518 <printf+0x128>
        s = (char*)*ap;
 4d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d8:	8b 00                	mov    (%eax),%eax
 4da:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e5:	75 25                	jne    50c <printf+0x11c>
          s = "(null)";
 4e7:	c7 45 f4 b7 07 00 00 	movl   $0x7b7,-0xc(%ebp)
        while(*s != 0){
 4ee:	eb 1c                	jmp    50c <printf+0x11c>
          putc(fd, *s);
 4f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f3:	8a 00                	mov    (%eax),%al
 4f5:	0f be c0             	movsbl %al,%eax
 4f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fc:	8b 45 08             	mov    0x8(%ebp),%eax
 4ff:	89 04 24             	mov    %eax,(%esp)
 502:	e8 11 fe ff ff       	call   318 <putc>
          s++;
 507:	ff 45 f4             	incl   -0xc(%ebp)
 50a:	eb 01                	jmp    50d <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 50c:	90                   	nop
 50d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 510:	8a 00                	mov    (%eax),%al
 512:	84 c0                	test   %al,%al
 514:	75 da                	jne    4f0 <printf+0x100>
 516:	eb 68                	jmp    580 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 518:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 51c:	75 1d                	jne    53b <printf+0x14b>
        putc(fd, *ap);
 51e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 521:	8b 00                	mov    (%eax),%eax
 523:	0f be c0             	movsbl %al,%eax
 526:	89 44 24 04          	mov    %eax,0x4(%esp)
 52a:	8b 45 08             	mov    0x8(%ebp),%eax
 52d:	89 04 24             	mov    %eax,(%esp)
 530:	e8 e3 fd ff ff       	call   318 <putc>
        ap++;
 535:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 539:	eb 45                	jmp    580 <printf+0x190>
      } else if(c == '%'){
 53b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 53f:	75 17                	jne    558 <printf+0x168>
        putc(fd, c);
 541:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 544:	0f be c0             	movsbl %al,%eax
 547:	89 44 24 04          	mov    %eax,0x4(%esp)
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	89 04 24             	mov    %eax,(%esp)
 551:	e8 c2 fd ff ff       	call   318 <putc>
 556:	eb 28                	jmp    580 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 558:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 55f:	00 
 560:	8b 45 08             	mov    0x8(%ebp),%eax
 563:	89 04 24             	mov    %eax,(%esp)
 566:	e8 ad fd ff ff       	call   318 <putc>
        putc(fd, c);
 56b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56e:	0f be c0             	movsbl %al,%eax
 571:	89 44 24 04          	mov    %eax,0x4(%esp)
 575:	8b 45 08             	mov    0x8(%ebp),%eax
 578:	89 04 24             	mov    %eax,(%esp)
 57b:	e8 98 fd ff ff       	call   318 <putc>
      }
      state = 0;
 580:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 587:	ff 45 f0             	incl   -0x10(%ebp)
 58a:	8b 55 0c             	mov    0xc(%ebp),%edx
 58d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 590:	01 d0                	add    %edx,%eax
 592:	8a 00                	mov    (%eax),%al
 594:	84 c0                	test   %al,%al
 596:	0f 85 76 fe ff ff    	jne    412 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 59c:	c9                   	leave  
 59d:	c3                   	ret    
 59e:	66 90                	xchg   %ax,%ax

000005a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5a6:	8b 45 08             	mov    0x8(%ebp),%eax
 5a9:	83 e8 08             	sub    $0x8,%eax
 5ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5af:	a1 18 0a 00 00       	mov    0xa18,%eax
 5b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5b7:	eb 24                	jmp    5dd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5bc:	8b 00                	mov    (%eax),%eax
 5be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c1:	77 12                	ja     5d5 <free+0x35>
 5c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c9:	77 24                	ja     5ef <free+0x4f>
 5cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ce:	8b 00                	mov    (%eax),%eax
 5d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5d3:	77 1a                	ja     5ef <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d8:	8b 00                	mov    (%eax),%eax
 5da:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e3:	76 d4                	jbe    5b9 <free+0x19>
 5e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e8:	8b 00                	mov    (%eax),%eax
 5ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ed:	76 ca                	jbe    5b9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f2:	8b 40 04             	mov    0x4(%eax),%eax
 5f5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 5fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ff:	01 c2                	add    %eax,%edx
 601:	8b 45 fc             	mov    -0x4(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	39 c2                	cmp    %eax,%edx
 608:	75 24                	jne    62e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 60a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60d:	8b 50 04             	mov    0x4(%eax),%edx
 610:	8b 45 fc             	mov    -0x4(%ebp),%eax
 613:	8b 00                	mov    (%eax),%eax
 615:	8b 40 04             	mov    0x4(%eax),%eax
 618:	01 c2                	add    %eax,%edx
 61a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 620:	8b 45 fc             	mov    -0x4(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	8b 10                	mov    (%eax),%edx
 627:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62a:	89 10                	mov    %edx,(%eax)
 62c:	eb 0a                	jmp    638 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 62e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 631:	8b 10                	mov    (%eax),%edx
 633:	8b 45 f8             	mov    -0x8(%ebp),%eax
 636:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 638:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63b:	8b 40 04             	mov    0x4(%eax),%eax
 63e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	01 d0                	add    %edx,%eax
 64a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64d:	75 20                	jne    66f <free+0xcf>
    p->s.size += bp->s.size;
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 50 04             	mov    0x4(%eax),%edx
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	8b 40 04             	mov    0x4(%eax),%eax
 65b:	01 c2                	add    %eax,%edx
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	8b 10                	mov    (%eax),%edx
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	89 10                	mov    %edx,(%eax)
 66d:	eb 08                	jmp    677 <free+0xd7>
  } else
    p->s.ptr = bp;
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	8b 55 f8             	mov    -0x8(%ebp),%edx
 675:	89 10                	mov    %edx,(%eax)
  freep = p;
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	a3 18 0a 00 00       	mov    %eax,0xa18
}
 67f:	c9                   	leave  
 680:	c3                   	ret    

00000681 <morecore>:

static Header*
morecore(uint nu)
{
 681:	55                   	push   %ebp
 682:	89 e5                	mov    %esp,%ebp
 684:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 687:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 68e:	77 07                	ja     697 <morecore+0x16>
    nu = 4096;
 690:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 697:	8b 45 08             	mov    0x8(%ebp),%eax
 69a:	c1 e0 03             	shl    $0x3,%eax
 69d:	89 04 24             	mov    %eax,(%esp)
 6a0:	e8 53 fc ff ff       	call   2f8 <sbrk>
 6a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6a8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6ac:	75 07                	jne    6b5 <morecore+0x34>
    return 0;
 6ae:	b8 00 00 00 00       	mov    $0x0,%eax
 6b3:	eb 22                	jmp    6d7 <morecore+0x56>
  hp = (Header*)p;
 6b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6be:	8b 55 08             	mov    0x8(%ebp),%edx
 6c1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c7:	83 c0 08             	add    $0x8,%eax
 6ca:	89 04 24             	mov    %eax,(%esp)
 6cd:	e8 ce fe ff ff       	call   5a0 <free>
  return freep;
 6d2:	a1 18 0a 00 00       	mov    0xa18,%eax
}
 6d7:	c9                   	leave  
 6d8:	c3                   	ret    

000006d9 <malloc>:

void*
malloc(uint nbytes)
{
 6d9:	55                   	push   %ebp
 6da:	89 e5                	mov    %esp,%ebp
 6dc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6df:	8b 45 08             	mov    0x8(%ebp),%eax
 6e2:	83 c0 07             	add    $0x7,%eax
 6e5:	c1 e8 03             	shr    $0x3,%eax
 6e8:	40                   	inc    %eax
 6e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6ec:	a1 18 0a 00 00       	mov    0xa18,%eax
 6f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6f8:	75 23                	jne    71d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 6fa:	c7 45 f0 10 0a 00 00 	movl   $0xa10,-0x10(%ebp)
 701:	8b 45 f0             	mov    -0x10(%ebp),%eax
 704:	a3 18 0a 00 00       	mov    %eax,0xa18
 709:	a1 18 0a 00 00       	mov    0xa18,%eax
 70e:	a3 10 0a 00 00       	mov    %eax,0xa10
    base.s.size = 0;
 713:	c7 05 14 0a 00 00 00 	movl   $0x0,0xa14
 71a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 71d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 720:	8b 00                	mov    (%eax),%eax
 722:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 725:	8b 45 f4             	mov    -0xc(%ebp),%eax
 728:	8b 40 04             	mov    0x4(%eax),%eax
 72b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 72e:	72 4d                	jb     77d <malloc+0xa4>
      if(p->s.size == nunits)
 730:	8b 45 f4             	mov    -0xc(%ebp),%eax
 733:	8b 40 04             	mov    0x4(%eax),%eax
 736:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 739:	75 0c                	jne    747 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 73b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73e:	8b 10                	mov    (%eax),%edx
 740:	8b 45 f0             	mov    -0x10(%ebp),%eax
 743:	89 10                	mov    %edx,(%eax)
 745:	eb 26                	jmp    76d <malloc+0x94>
      else {
        p->s.size -= nunits;
 747:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74a:	8b 40 04             	mov    0x4(%eax),%eax
 74d:	89 c2                	mov    %eax,%edx
 74f:	2b 55 ec             	sub    -0x14(%ebp),%edx
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 758:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75b:	8b 40 04             	mov    0x4(%eax),%eax
 75e:	c1 e0 03             	shl    $0x3,%eax
 761:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 764:	8b 45 f4             	mov    -0xc(%ebp),%eax
 767:	8b 55 ec             	mov    -0x14(%ebp),%edx
 76a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 76d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 770:	a3 18 0a 00 00       	mov    %eax,0xa18
      return (void*)(p + 1);
 775:	8b 45 f4             	mov    -0xc(%ebp),%eax
 778:	83 c0 08             	add    $0x8,%eax
 77b:	eb 38                	jmp    7b5 <malloc+0xdc>
    }
    if(p == freep)
 77d:	a1 18 0a 00 00       	mov    0xa18,%eax
 782:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 785:	75 1b                	jne    7a2 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 787:	8b 45 ec             	mov    -0x14(%ebp),%eax
 78a:	89 04 24             	mov    %eax,(%esp)
 78d:	e8 ef fe ff ff       	call   681 <morecore>
 792:	89 45 f4             	mov    %eax,-0xc(%ebp)
 795:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 799:	75 07                	jne    7a2 <malloc+0xc9>
        return 0;
 79b:	b8 00 00 00 00       	mov    $0x0,%eax
 7a0:	eb 13                	jmp    7b5 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ab:	8b 00                	mov    (%eax),%eax
 7ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7b0:	e9 70 ff ff ff       	jmp    725 <malloc+0x4c>
}
 7b5:	c9                   	leave  
 7b6:	c3                   	ret    
