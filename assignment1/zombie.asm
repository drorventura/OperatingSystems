
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

00000310 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 ec 28             	sub    $0x28,%esp
 316:	8b 45 0c             	mov    0xc(%ebp),%eax
 319:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 31c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 323:	00 
 324:	8d 45 f4             	lea    -0xc(%ebp),%eax
 327:	89 44 24 04          	mov    %eax,0x4(%esp)
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	89 04 24             	mov    %eax,(%esp)
 331:	e8 5a ff ff ff       	call   290 <write>
}
 336:	c9                   	leave  
 337:	c3                   	ret    

00000338 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 33e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 345:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 349:	74 17                	je     362 <printint+0x2a>
 34b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 34f:	79 11                	jns    362 <printint+0x2a>
    neg = 1;
 351:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 358:	8b 45 0c             	mov    0xc(%ebp),%eax
 35b:	f7 d8                	neg    %eax
 35d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 360:	eb 06                	jmp    368 <printint+0x30>
  } else {
    x = xx;
 362:	8b 45 0c             	mov    0xc(%ebp),%eax
 365:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 368:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 36f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 372:	8b 45 ec             	mov    -0x14(%ebp),%eax
 375:	ba 00 00 00 00       	mov    $0x0,%edx
 37a:	f7 f1                	div    %ecx
 37c:	89 d0                	mov    %edx,%eax
 37e:	8a 80 f4 09 00 00    	mov    0x9f4(%eax),%al
 384:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 387:	8b 55 f4             	mov    -0xc(%ebp),%edx
 38a:	01 ca                	add    %ecx,%edx
 38c:	88 02                	mov    %al,(%edx)
 38e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 391:	8b 55 10             	mov    0x10(%ebp),%edx
 394:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 397:	8b 45 ec             	mov    -0x14(%ebp),%eax
 39a:	ba 00 00 00 00       	mov    $0x0,%edx
 39f:	f7 75 d4             	divl   -0x2c(%ebp)
 3a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3a9:	75 c4                	jne    36f <printint+0x37>
  if(neg)
 3ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3af:	74 2c                	je     3dd <printint+0xa5>
    buf[i++] = '-';
 3b1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b7:	01 d0                	add    %edx,%eax
 3b9:	c6 00 2d             	movb   $0x2d,(%eax)
 3bc:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3bf:	eb 1c                	jmp    3dd <printint+0xa5>
    putc(fd, buf[i]);
 3c1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3c7:	01 d0                	add    %edx,%eax
 3c9:	8a 00                	mov    (%eax),%al
 3cb:	0f be c0             	movsbl %al,%eax
 3ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	89 04 24             	mov    %eax,(%esp)
 3d8:	e8 33 ff ff ff       	call   310 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3dd:	ff 4d f4             	decl   -0xc(%ebp)
 3e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3e4:	79 db                	jns    3c1 <printint+0x89>
    putc(fd, buf[i]);
}
 3e6:	c9                   	leave  
 3e7:	c3                   	ret    

000003e8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3e8:	55                   	push   %ebp
 3e9:	89 e5                	mov    %esp,%ebp
 3eb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 3ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 3f5:	8d 45 0c             	lea    0xc(%ebp),%eax
 3f8:	83 c0 04             	add    $0x4,%eax
 3fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 3fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 405:	e9 78 01 00 00       	jmp    582 <printf+0x19a>
    c = fmt[i] & 0xff;
 40a:	8b 55 0c             	mov    0xc(%ebp),%edx
 40d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 410:	01 d0                	add    %edx,%eax
 412:	8a 00                	mov    (%eax),%al
 414:	0f be c0             	movsbl %al,%eax
 417:	25 ff 00 00 00       	and    $0xff,%eax
 41c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 41f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 423:	75 2c                	jne    451 <printf+0x69>
      if(c == '%'){
 425:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 429:	75 0c                	jne    437 <printf+0x4f>
        state = '%';
 42b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 432:	e9 48 01 00 00       	jmp    57f <printf+0x197>
      } else {
        putc(fd, c);
 437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 43a:	0f be c0             	movsbl %al,%eax
 43d:	89 44 24 04          	mov    %eax,0x4(%esp)
 441:	8b 45 08             	mov    0x8(%ebp),%eax
 444:	89 04 24             	mov    %eax,(%esp)
 447:	e8 c4 fe ff ff       	call   310 <putc>
 44c:	e9 2e 01 00 00       	jmp    57f <printf+0x197>
      }
    } else if(state == '%'){
 451:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 455:	0f 85 24 01 00 00    	jne    57f <printf+0x197>
      if(c == 'd'){
 45b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 45f:	75 2d                	jne    48e <printf+0xa6>
        printint(fd, *ap, 10, 1);
 461:	8b 45 e8             	mov    -0x18(%ebp),%eax
 464:	8b 00                	mov    (%eax),%eax
 466:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 46d:	00 
 46e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 475:	00 
 476:	89 44 24 04          	mov    %eax,0x4(%esp)
 47a:	8b 45 08             	mov    0x8(%ebp),%eax
 47d:	89 04 24             	mov    %eax,(%esp)
 480:	e8 b3 fe ff ff       	call   338 <printint>
        ap++;
 485:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 489:	e9 ea 00 00 00       	jmp    578 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 48e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 492:	74 06                	je     49a <printf+0xb2>
 494:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 498:	75 2d                	jne    4c7 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 49a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 49d:	8b 00                	mov    (%eax),%eax
 49f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4a6:	00 
 4a7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4ae:	00 
 4af:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	89 04 24             	mov    %eax,(%esp)
 4b9:	e8 7a fe ff ff       	call   338 <printint>
        ap++;
 4be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c2:	e9 b1 00 00 00       	jmp    578 <printf+0x190>
      } else if(c == 's'){
 4c7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4cb:	75 43                	jne    510 <printf+0x128>
        s = (char*)*ap;
 4cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d0:	8b 00                	mov    (%eax),%eax
 4d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4dd:	75 25                	jne    504 <printf+0x11c>
          s = "(null)";
 4df:	c7 45 f4 af 07 00 00 	movl   $0x7af,-0xc(%ebp)
        while(*s != 0){
 4e6:	eb 1c                	jmp    504 <printf+0x11c>
          putc(fd, *s);
 4e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4eb:	8a 00                	mov    (%eax),%al
 4ed:	0f be c0             	movsbl %al,%eax
 4f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
 4f7:	89 04 24             	mov    %eax,(%esp)
 4fa:	e8 11 fe ff ff       	call   310 <putc>
          s++;
 4ff:	ff 45 f4             	incl   -0xc(%ebp)
 502:	eb 01                	jmp    505 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 504:	90                   	nop
 505:	8b 45 f4             	mov    -0xc(%ebp),%eax
 508:	8a 00                	mov    (%eax),%al
 50a:	84 c0                	test   %al,%al
 50c:	75 da                	jne    4e8 <printf+0x100>
 50e:	eb 68                	jmp    578 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 510:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 514:	75 1d                	jne    533 <printf+0x14b>
        putc(fd, *ap);
 516:	8b 45 e8             	mov    -0x18(%ebp),%eax
 519:	8b 00                	mov    (%eax),%eax
 51b:	0f be c0             	movsbl %al,%eax
 51e:	89 44 24 04          	mov    %eax,0x4(%esp)
 522:	8b 45 08             	mov    0x8(%ebp),%eax
 525:	89 04 24             	mov    %eax,(%esp)
 528:	e8 e3 fd ff ff       	call   310 <putc>
        ap++;
 52d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 531:	eb 45                	jmp    578 <printf+0x190>
      } else if(c == '%'){
 533:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 537:	75 17                	jne    550 <printf+0x168>
        putc(fd, c);
 539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 53c:	0f be c0             	movsbl %al,%eax
 53f:	89 44 24 04          	mov    %eax,0x4(%esp)
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	89 04 24             	mov    %eax,(%esp)
 549:	e8 c2 fd ff ff       	call   310 <putc>
 54e:	eb 28                	jmp    578 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 550:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 557:	00 
 558:	8b 45 08             	mov    0x8(%ebp),%eax
 55b:	89 04 24             	mov    %eax,(%esp)
 55e:	e8 ad fd ff ff       	call   310 <putc>
        putc(fd, c);
 563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 566:	0f be c0             	movsbl %al,%eax
 569:	89 44 24 04          	mov    %eax,0x4(%esp)
 56d:	8b 45 08             	mov    0x8(%ebp),%eax
 570:	89 04 24             	mov    %eax,(%esp)
 573:	e8 98 fd ff ff       	call   310 <putc>
      }
      state = 0;
 578:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 57f:	ff 45 f0             	incl   -0x10(%ebp)
 582:	8b 55 0c             	mov    0xc(%ebp),%edx
 585:	8b 45 f0             	mov    -0x10(%ebp),%eax
 588:	01 d0                	add    %edx,%eax
 58a:	8a 00                	mov    (%eax),%al
 58c:	84 c0                	test   %al,%al
 58e:	0f 85 76 fe ff ff    	jne    40a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 594:	c9                   	leave  
 595:	c3                   	ret    
 596:	66 90                	xchg   %ax,%ax

00000598 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 598:	55                   	push   %ebp
 599:	89 e5                	mov    %esp,%ebp
 59b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	83 e8 08             	sub    $0x8,%eax
 5a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a7:	a1 10 0a 00 00       	mov    0xa10,%eax
 5ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5af:	eb 24                	jmp    5d5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b4:	8b 00                	mov    (%eax),%eax
 5b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5b9:	77 12                	ja     5cd <free+0x35>
 5bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c1:	77 24                	ja     5e7 <free+0x4f>
 5c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c6:	8b 00                	mov    (%eax),%eax
 5c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5cb:	77 1a                	ja     5e7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d0:	8b 00                	mov    (%eax),%eax
 5d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5db:	76 d4                	jbe    5b1 <free+0x19>
 5dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e0:	8b 00                	mov    (%eax),%eax
 5e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5e5:	76 ca                	jbe    5b1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ea:	8b 40 04             	mov    0x4(%eax),%eax
 5ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 5f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f7:	01 c2                	add    %eax,%edx
 5f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fc:	8b 00                	mov    (%eax),%eax
 5fe:	39 c2                	cmp    %eax,%edx
 600:	75 24                	jne    626 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 602:	8b 45 f8             	mov    -0x8(%ebp),%eax
 605:	8b 50 04             	mov    0x4(%eax),%edx
 608:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	8b 40 04             	mov    0x4(%eax),%eax
 610:	01 c2                	add    %eax,%edx
 612:	8b 45 f8             	mov    -0x8(%ebp),%eax
 615:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 618:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61b:	8b 00                	mov    (%eax),%eax
 61d:	8b 10                	mov    (%eax),%edx
 61f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 622:	89 10                	mov    %edx,(%eax)
 624:	eb 0a                	jmp    630 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 626:	8b 45 fc             	mov    -0x4(%ebp),%eax
 629:	8b 10                	mov    (%eax),%edx
 62b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 630:	8b 45 fc             	mov    -0x4(%ebp),%eax
 633:	8b 40 04             	mov    0x4(%eax),%eax
 636:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	01 d0                	add    %edx,%eax
 642:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 645:	75 20                	jne    667 <free+0xcf>
    p->s.size += bp->s.size;
 647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64a:	8b 50 04             	mov    0x4(%eax),%edx
 64d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 650:	8b 40 04             	mov    0x4(%eax),%eax
 653:	01 c2                	add    %eax,%edx
 655:	8b 45 fc             	mov    -0x4(%ebp),%eax
 658:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	8b 10                	mov    (%eax),%edx
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	89 10                	mov    %edx,(%eax)
 665:	eb 08                	jmp    66f <free+0xd7>
  } else
    p->s.ptr = bp;
 667:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 66d:	89 10                	mov    %edx,(%eax)
  freep = p;
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	a3 10 0a 00 00       	mov    %eax,0xa10
}
 677:	c9                   	leave  
 678:	c3                   	ret    

00000679 <morecore>:

static Header*
morecore(uint nu)
{
 679:	55                   	push   %ebp
 67a:	89 e5                	mov    %esp,%ebp
 67c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 67f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 686:	77 07                	ja     68f <morecore+0x16>
    nu = 4096;
 688:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 68f:	8b 45 08             	mov    0x8(%ebp),%eax
 692:	c1 e0 03             	shl    $0x3,%eax
 695:	89 04 24             	mov    %eax,(%esp)
 698:	e8 5b fc ff ff       	call   2f8 <sbrk>
 69d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6a0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6a4:	75 07                	jne    6ad <morecore+0x34>
    return 0;
 6a6:	b8 00 00 00 00       	mov    $0x0,%eax
 6ab:	eb 22                	jmp    6cf <morecore+0x56>
  hp = (Header*)p;
 6ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b6:	8b 55 08             	mov    0x8(%ebp),%edx
 6b9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bf:	83 c0 08             	add    $0x8,%eax
 6c2:	89 04 24             	mov    %eax,(%esp)
 6c5:	e8 ce fe ff ff       	call   598 <free>
  return freep;
 6ca:	a1 10 0a 00 00       	mov    0xa10,%eax
}
 6cf:	c9                   	leave  
 6d0:	c3                   	ret    

000006d1 <malloc>:

void*
malloc(uint nbytes)
{
 6d1:	55                   	push   %ebp
 6d2:	89 e5                	mov    %esp,%ebp
 6d4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d7:	8b 45 08             	mov    0x8(%ebp),%eax
 6da:	83 c0 07             	add    $0x7,%eax
 6dd:	c1 e8 03             	shr    $0x3,%eax
 6e0:	40                   	inc    %eax
 6e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6e4:	a1 10 0a 00 00       	mov    0xa10,%eax
 6e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6f0:	75 23                	jne    715 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 6f2:	c7 45 f0 08 0a 00 00 	movl   $0xa08,-0x10(%ebp)
 6f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fc:	a3 10 0a 00 00       	mov    %eax,0xa10
 701:	a1 10 0a 00 00       	mov    0xa10,%eax
 706:	a3 08 0a 00 00       	mov    %eax,0xa08
    base.s.size = 0;
 70b:	c7 05 0c 0a 00 00 00 	movl   $0x0,0xa0c
 712:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 715:	8b 45 f0             	mov    -0x10(%ebp),%eax
 718:	8b 00                	mov    (%eax),%eax
 71a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 71d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 720:	8b 40 04             	mov    0x4(%eax),%eax
 723:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 726:	72 4d                	jb     775 <malloc+0xa4>
      if(p->s.size == nunits)
 728:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72b:	8b 40 04             	mov    0x4(%eax),%eax
 72e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 731:	75 0c                	jne    73f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 733:	8b 45 f4             	mov    -0xc(%ebp),%eax
 736:	8b 10                	mov    (%eax),%edx
 738:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73b:	89 10                	mov    %edx,(%eax)
 73d:	eb 26                	jmp    765 <malloc+0x94>
      else {
        p->s.size -= nunits;
 73f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 742:	8b 40 04             	mov    0x4(%eax),%eax
 745:	89 c2                	mov    %eax,%edx
 747:	2b 55 ec             	sub    -0x14(%ebp),%edx
 74a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 750:	8b 45 f4             	mov    -0xc(%ebp),%eax
 753:	8b 40 04             	mov    0x4(%eax),%eax
 756:	c1 e0 03             	shl    $0x3,%eax
 759:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 75c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 762:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 765:	8b 45 f0             	mov    -0x10(%ebp),%eax
 768:	a3 10 0a 00 00       	mov    %eax,0xa10
      return (void*)(p + 1);
 76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 770:	83 c0 08             	add    $0x8,%eax
 773:	eb 38                	jmp    7ad <malloc+0xdc>
    }
    if(p == freep)
 775:	a1 10 0a 00 00       	mov    0xa10,%eax
 77a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 77d:	75 1b                	jne    79a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 77f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 782:	89 04 24             	mov    %eax,(%esp)
 785:	e8 ef fe ff ff       	call   679 <morecore>
 78a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 78d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 791:	75 07                	jne    79a <malloc+0xc9>
        return 0;
 793:	b8 00 00 00 00       	mov    $0x0,%eax
 798:	eb 13                	jmp    7ad <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	8b 00                	mov    (%eax),%eax
 7a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7a8:	e9 70 ff ff ff       	jmp    71d <malloc+0x4c>
}
 7ad:	c9                   	leave  
 7ae:	c3                   	ret    
