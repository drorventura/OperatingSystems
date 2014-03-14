
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 48                	jmp    5b <main+0x5b>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	40                   	inc    %eax
  18:	3b 45 08             	cmp    0x8(%ebp),%eax
  1b:	7d 07                	jge    24 <main+0x24>
  1d:	b8 f7 07 00 00       	mov    $0x7f7,%eax
  22:	eb 05                	jmp    29 <main+0x29>
  24:	b8 f9 07 00 00       	mov    $0x7f9,%eax
  29:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2d:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  34:	8b 55 0c             	mov    0xc(%ebp),%edx
  37:	01 ca                	add    %ecx,%edx
  39:	8b 12                	mov    (%edx),%edx
  3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  3f:	89 54 24 08          	mov    %edx,0x8(%esp)
  43:	c7 44 24 04 fb 07 00 	movl   $0x7fb,0x4(%esp)
  4a:	00 
  4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  52:	e8 d9 03 00 00       	call   430 <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  57:	ff 44 24 1c          	incl   0x1c(%esp)
  5b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5f:	3b 45 08             	cmp    0x8(%ebp),%eax
  62:	7c af                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  64:	e8 4f 02 00 00       	call   2b8 <exit>
  69:	66 90                	xchg   %ax,%ax
  6b:	90                   	nop

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9d:	90                   	nop
  9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  a1:	8a 10                	mov    (%eax),%dl
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	88 10                	mov    %dl,(%eax)
  a8:	8b 45 08             	mov    0x8(%ebp),%eax
  ab:	8a 00                	mov    (%eax),%al
  ad:	84 c0                	test   %al,%al
  af:	0f 95 c0             	setne  %al
  b2:	ff 45 08             	incl   0x8(%ebp)
  b5:	ff 45 0c             	incl   0xc(%ebp)
  b8:	84 c0                	test   %al,%al
  ba:	75 e2                	jne    9e <strcpy+0xd>
    ;
  return os;
  bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bf:	c9                   	leave  
  c0:	c3                   	ret    

000000c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c4:	eb 06                	jmp    cc <strcmp+0xb>
    p++, q++;
  c6:	ff 45 08             	incl   0x8(%ebp)
  c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  cc:	8b 45 08             	mov    0x8(%ebp),%eax
  cf:	8a 00                	mov    (%eax),%al
  d1:	84 c0                	test   %al,%al
  d3:	74 0e                	je     e3 <strcmp+0x22>
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	8a 10                	mov    (%eax),%dl
  da:	8b 45 0c             	mov    0xc(%ebp),%eax
  dd:	8a 00                	mov    (%eax),%al
  df:	38 c2                	cmp    %al,%dl
  e1:	74 e3                	je     c6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	8a 00                	mov    (%eax),%al
  e8:	0f b6 d0             	movzbl %al,%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	8a 00                	mov    (%eax),%al
  f0:	0f b6 c0             	movzbl %al,%eax
  f3:	89 d1                	mov    %edx,%ecx
  f5:	29 c1                	sub    %eax,%ecx
  f7:	89 c8                	mov    %ecx,%eax
}
  f9:	5d                   	pop    %ebp
  fa:	c3                   	ret    

000000fb <strlen>:

uint
strlen(char *s)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 108:	eb 03                	jmp    10d <strlen+0x12>
 10a:	ff 45 fc             	incl   -0x4(%ebp)
 10d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	01 d0                	add    %edx,%eax
 115:	8a 00                	mov    (%eax),%al
 117:	84 c0                	test   %al,%al
 119:	75 ef                	jne    10a <strlen+0xf>
    ;
  return n;
 11b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11e:	c9                   	leave  
 11f:	c3                   	ret    

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 126:	8b 45 10             	mov    0x10(%ebp),%eax
 129:	89 44 24 08          	mov    %eax,0x8(%esp)
 12d:	8b 45 0c             	mov    0xc(%ebp),%eax
 130:	89 44 24 04          	mov    %eax,0x4(%esp)
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	89 04 24             	mov    %eax,(%esp)
 13a:	e8 2d ff ff ff       	call   6c <stosb>
  return dst;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 142:	c9                   	leave  
 143:	c3                   	ret    

00000144 <strchr>:

char*
strchr(const char *s, char c)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	83 ec 04             	sub    $0x4,%esp
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 150:	eb 12                	jmp    164 <strchr+0x20>
    if(*s == c)
 152:	8b 45 08             	mov    0x8(%ebp),%eax
 155:	8a 00                	mov    (%eax),%al
 157:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15a:	75 05                	jne    161 <strchr+0x1d>
      return (char*)s;
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	eb 11                	jmp    172 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 161:	ff 45 08             	incl   0x8(%ebp)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	8a 00                	mov    (%eax),%al
 169:	84 c0                	test   %al,%al
 16b:	75 e5                	jne    152 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 16d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 172:	c9                   	leave  
 173:	c3                   	ret    

00000174 <gets>:

char*
gets(char *buf, int max)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 181:	eb 42                	jmp    1c5 <gets+0x51>
    cc = read(0, &c, 1);
 183:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 18a:	00 
 18b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 18e:	89 44 24 04          	mov    %eax,0x4(%esp)
 192:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 199:	e8 32 01 00 00       	call   2d0 <read>
 19e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a5:	7e 29                	jle    1d0 <gets+0x5c>
      break;
    buf[i++] = c;
 1a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1aa:	8b 45 08             	mov    0x8(%ebp),%eax
 1ad:	01 c2                	add    %eax,%edx
 1af:	8a 45 ef             	mov    -0x11(%ebp),%al
 1b2:	88 02                	mov    %al,(%edx)
 1b4:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1b7:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ba:	3c 0a                	cmp    $0xa,%al
 1bc:	74 13                	je     1d1 <gets+0x5d>
 1be:	8a 45 ef             	mov    -0x11(%ebp),%al
 1c1:	3c 0d                	cmp    $0xd,%al
 1c3:	74 0c                	je     1d1 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c8:	40                   	inc    %eax
 1c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1cc:	7c b5                	jl     183 <gets+0xf>
 1ce:	eb 01                	jmp    1d1 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	01 d0                	add    %edx,%eax
 1d9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1df:	c9                   	leave  
 1e0:	c3                   	ret    

000001e1 <stat>:

int
stat(char *n, struct stat *st)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ee:	00 
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	89 04 24             	mov    %eax,(%esp)
 1f5:	e8 fe 00 00 00       	call   2f8 <open>
 1fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 201:	79 07                	jns    20a <stat+0x29>
    return -1;
 203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 208:	eb 23                	jmp    22d <stat+0x4c>
  r = fstat(fd, st);
 20a:	8b 45 0c             	mov    0xc(%ebp),%eax
 20d:	89 44 24 04          	mov    %eax,0x4(%esp)
 211:	8b 45 f4             	mov    -0xc(%ebp),%eax
 214:	89 04 24             	mov    %eax,(%esp)
 217:	e8 f4 00 00 00       	call   310 <fstat>
 21c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 222:	89 04 24             	mov    %eax,(%esp)
 225:	e8 b6 00 00 00       	call   2e0 <close>
  return r;
 22a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 22d:	c9                   	leave  
 22e:	c3                   	ret    

0000022f <atoi>:

int
atoi(const char *s)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 235:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 23c:	eb 21                	jmp    25f <atoi+0x30>
    n = n*10 + *s++ - '0';
 23e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 241:	89 d0                	mov    %edx,%eax
 243:	c1 e0 02             	shl    $0x2,%eax
 246:	01 d0                	add    %edx,%eax
 248:	d1 e0                	shl    %eax
 24a:	89 c2                	mov    %eax,%edx
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	8a 00                	mov    (%eax),%al
 251:	0f be c0             	movsbl %al,%eax
 254:	01 d0                	add    %edx,%eax
 256:	83 e8 30             	sub    $0x30,%eax
 259:	89 45 fc             	mov    %eax,-0x4(%ebp)
 25c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	8a 00                	mov    (%eax),%al
 264:	3c 2f                	cmp    $0x2f,%al
 266:	7e 09                	jle    271 <atoi+0x42>
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	8a 00                	mov    (%eax),%al
 26d:	3c 39                	cmp    $0x39,%al
 26f:	7e cd                	jle    23e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 271:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 274:	c9                   	leave  
 275:	c3                   	ret    

00000276 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 282:	8b 45 0c             	mov    0xc(%ebp),%eax
 285:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 288:	eb 10                	jmp    29a <memmove+0x24>
    *dst++ = *src++;
 28a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 28d:	8a 10                	mov    (%eax),%dl
 28f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 292:	88 10                	mov    %dl,(%eax)
 294:	ff 45 fc             	incl   -0x4(%ebp)
 297:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 29e:	0f 9f c0             	setg   %al
 2a1:	ff 4d 10             	decl   0x10(%ebp)
 2a4:	84 c0                	test   %al,%al
 2a6:	75 e2                	jne    28a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ab:	c9                   	leave  
 2ac:	c3                   	ret    
 2ad:	66 90                	xchg   %ax,%ax
 2af:	90                   	nop

000002b0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b0:	b8 01 00 00 00       	mov    $0x1,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <exit>:
SYSCALL(exit)
 2b8:	b8 02 00 00 00       	mov    $0x2,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <wait>:
SYSCALL(wait)
 2c0:	b8 03 00 00 00       	mov    $0x3,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <pipe>:
SYSCALL(pipe)
 2c8:	b8 04 00 00 00       	mov    $0x4,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <read>:
SYSCALL(read)
 2d0:	b8 05 00 00 00       	mov    $0x5,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <write>:
SYSCALL(write)
 2d8:	b8 10 00 00 00       	mov    $0x10,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <close>:
SYSCALL(close)
 2e0:	b8 15 00 00 00       	mov    $0x15,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <kill>:
SYSCALL(kill)
 2e8:	b8 06 00 00 00       	mov    $0x6,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <exec>:
SYSCALL(exec)
 2f0:	b8 07 00 00 00       	mov    $0x7,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <open>:
SYSCALL(open)
 2f8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <mknod>:
SYSCALL(mknod)
 300:	b8 11 00 00 00       	mov    $0x11,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <unlink>:
SYSCALL(unlink)
 308:	b8 12 00 00 00       	mov    $0x12,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <fstat>:
SYSCALL(fstat)
 310:	b8 08 00 00 00       	mov    $0x8,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <link>:
SYSCALL(link)
 318:	b8 13 00 00 00       	mov    $0x13,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <mkdir>:
SYSCALL(mkdir)
 320:	b8 14 00 00 00       	mov    $0x14,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <chdir>:
SYSCALL(chdir)
 328:	b8 09 00 00 00       	mov    $0x9,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <dup>:
SYSCALL(dup)
 330:	b8 0a 00 00 00       	mov    $0xa,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <getpid>:
SYSCALL(getpid)
 338:	b8 0b 00 00 00       	mov    $0xb,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <sbrk>:
SYSCALL(sbrk)
 340:	b8 0c 00 00 00       	mov    $0xc,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <sleep>:
SYSCALL(sleep)
 348:	b8 0d 00 00 00       	mov    $0xd,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <uptime>:
SYSCALL(uptime)
 350:	b8 0e 00 00 00       	mov    $0xe,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	83 ec 28             	sub    $0x28,%esp
 35e:	8b 45 0c             	mov    0xc(%ebp),%eax
 361:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 364:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 36b:	00 
 36c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 36f:	89 44 24 04          	mov    %eax,0x4(%esp)
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	89 04 24             	mov    %eax,(%esp)
 379:	e8 5a ff ff ff       	call   2d8 <write>
}
 37e:	c9                   	leave  
 37f:	c3                   	ret    

00000380 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 386:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 38d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 391:	74 17                	je     3aa <printint+0x2a>
 393:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 397:	79 11                	jns    3aa <printint+0x2a>
    neg = 1;
 399:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a3:	f7 d8                	neg    %eax
 3a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a8:	eb 06                	jmp    3b0 <printint+0x30>
  } else {
    x = xx;
 3aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3bd:	ba 00 00 00 00       	mov    $0x0,%edx
 3c2:	f7 f1                	div    %ecx
 3c4:	89 d0                	mov    %edx,%eax
 3c6:	8a 80 44 0a 00 00    	mov    0xa44(%eax),%al
 3cc:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3d2:	01 ca                	add    %ecx,%edx
 3d4:	88 02                	mov    %al,(%edx)
 3d6:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3d9:	8b 55 10             	mov    0x10(%ebp),%edx
 3dc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e2:	ba 00 00 00 00       	mov    $0x0,%edx
 3e7:	f7 75 d4             	divl   -0x2c(%ebp)
 3ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f1:	75 c4                	jne    3b7 <printint+0x37>
  if(neg)
 3f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f7:	74 2c                	je     425 <printint+0xa5>
    buf[i++] = '-';
 3f9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ff:	01 d0                	add    %edx,%eax
 401:	c6 00 2d             	movb   $0x2d,(%eax)
 404:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 407:	eb 1c                	jmp    425 <printint+0xa5>
    putc(fd, buf[i]);
 409:	8d 55 dc             	lea    -0x24(%ebp),%edx
 40c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40f:	01 d0                	add    %edx,%eax
 411:	8a 00                	mov    (%eax),%al
 413:	0f be c0             	movsbl %al,%eax
 416:	89 44 24 04          	mov    %eax,0x4(%esp)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	89 04 24             	mov    %eax,(%esp)
 420:	e8 33 ff ff ff       	call   358 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 425:	ff 4d f4             	decl   -0xc(%ebp)
 428:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 42c:	79 db                	jns    409 <printint+0x89>
    putc(fd, buf[i]);
}
 42e:	c9                   	leave  
 42f:	c3                   	ret    

00000430 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 436:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 43d:	8d 45 0c             	lea    0xc(%ebp),%eax
 440:	83 c0 04             	add    $0x4,%eax
 443:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 446:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 44d:	e9 78 01 00 00       	jmp    5ca <printf+0x19a>
    c = fmt[i] & 0xff;
 452:	8b 55 0c             	mov    0xc(%ebp),%edx
 455:	8b 45 f0             	mov    -0x10(%ebp),%eax
 458:	01 d0                	add    %edx,%eax
 45a:	8a 00                	mov    (%eax),%al
 45c:	0f be c0             	movsbl %al,%eax
 45f:	25 ff 00 00 00       	and    $0xff,%eax
 464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 467:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 46b:	75 2c                	jne    499 <printf+0x69>
      if(c == '%'){
 46d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 471:	75 0c                	jne    47f <printf+0x4f>
        state = '%';
 473:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 47a:	e9 48 01 00 00       	jmp    5c7 <printf+0x197>
      } else {
        putc(fd, c);
 47f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 482:	0f be c0             	movsbl %al,%eax
 485:	89 44 24 04          	mov    %eax,0x4(%esp)
 489:	8b 45 08             	mov    0x8(%ebp),%eax
 48c:	89 04 24             	mov    %eax,(%esp)
 48f:	e8 c4 fe ff ff       	call   358 <putc>
 494:	e9 2e 01 00 00       	jmp    5c7 <printf+0x197>
      }
    } else if(state == '%'){
 499:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 49d:	0f 85 24 01 00 00    	jne    5c7 <printf+0x197>
      if(c == 'd'){
 4a3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4a7:	75 2d                	jne    4d6 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ac:	8b 00                	mov    (%eax),%eax
 4ae:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4b5:	00 
 4b6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4bd:	00 
 4be:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c2:	8b 45 08             	mov    0x8(%ebp),%eax
 4c5:	89 04 24             	mov    %eax,(%esp)
 4c8:	e8 b3 fe ff ff       	call   380 <printint>
        ap++;
 4cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d1:	e9 ea 00 00 00       	jmp    5c0 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4d6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4da:	74 06                	je     4e2 <printf+0xb2>
 4dc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e0:	75 2d                	jne    50f <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e5:	8b 00                	mov    (%eax),%eax
 4e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4ee:	00 
 4ef:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4f6:	00 
 4f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fb:	8b 45 08             	mov    0x8(%ebp),%eax
 4fe:	89 04 24             	mov    %eax,(%esp)
 501:	e8 7a fe ff ff       	call   380 <printint>
        ap++;
 506:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50a:	e9 b1 00 00 00       	jmp    5c0 <printf+0x190>
      } else if(c == 's'){
 50f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 513:	75 43                	jne    558 <printf+0x128>
        s = (char*)*ap;
 515:	8b 45 e8             	mov    -0x18(%ebp),%eax
 518:	8b 00                	mov    (%eax),%eax
 51a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 51d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 521:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 525:	75 25                	jne    54c <printf+0x11c>
          s = "(null)";
 527:	c7 45 f4 00 08 00 00 	movl   $0x800,-0xc(%ebp)
        while(*s != 0){
 52e:	eb 1c                	jmp    54c <printf+0x11c>
          putc(fd, *s);
 530:	8b 45 f4             	mov    -0xc(%ebp),%eax
 533:	8a 00                	mov    (%eax),%al
 535:	0f be c0             	movsbl %al,%eax
 538:	89 44 24 04          	mov    %eax,0x4(%esp)
 53c:	8b 45 08             	mov    0x8(%ebp),%eax
 53f:	89 04 24             	mov    %eax,(%esp)
 542:	e8 11 fe ff ff       	call   358 <putc>
          s++;
 547:	ff 45 f4             	incl   -0xc(%ebp)
 54a:	eb 01                	jmp    54d <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 54c:	90                   	nop
 54d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 550:	8a 00                	mov    (%eax),%al
 552:	84 c0                	test   %al,%al
 554:	75 da                	jne    530 <printf+0x100>
 556:	eb 68                	jmp    5c0 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 558:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 55c:	75 1d                	jne    57b <printf+0x14b>
        putc(fd, *ap);
 55e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 561:	8b 00                	mov    (%eax),%eax
 563:	0f be c0             	movsbl %al,%eax
 566:	89 44 24 04          	mov    %eax,0x4(%esp)
 56a:	8b 45 08             	mov    0x8(%ebp),%eax
 56d:	89 04 24             	mov    %eax,(%esp)
 570:	e8 e3 fd ff ff       	call   358 <putc>
        ap++;
 575:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 579:	eb 45                	jmp    5c0 <printf+0x190>
      } else if(c == '%'){
 57b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57f:	75 17                	jne    598 <printf+0x168>
        putc(fd, c);
 581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 584:	0f be c0             	movsbl %al,%eax
 587:	89 44 24 04          	mov    %eax,0x4(%esp)
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	89 04 24             	mov    %eax,(%esp)
 591:	e8 c2 fd ff ff       	call   358 <putc>
 596:	eb 28                	jmp    5c0 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 598:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 59f:	00 
 5a0:	8b 45 08             	mov    0x8(%ebp),%eax
 5a3:	89 04 24             	mov    %eax,(%esp)
 5a6:	e8 ad fd ff ff       	call   358 <putc>
        putc(fd, c);
 5ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ae:	0f be c0             	movsbl %al,%eax
 5b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b5:	8b 45 08             	mov    0x8(%ebp),%eax
 5b8:	89 04 24             	mov    %eax,(%esp)
 5bb:	e8 98 fd ff ff       	call   358 <putc>
      }
      state = 0;
 5c0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c7:	ff 45 f0             	incl   -0x10(%ebp)
 5ca:	8b 55 0c             	mov    0xc(%ebp),%edx
 5cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d0:	01 d0                	add    %edx,%eax
 5d2:	8a 00                	mov    (%eax),%al
 5d4:	84 c0                	test   %al,%al
 5d6:	0f 85 76 fe ff ff    	jne    452 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5dc:	c9                   	leave  
 5dd:	c3                   	ret    
 5de:	66 90                	xchg   %ax,%ax

000005e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5e6:	8b 45 08             	mov    0x8(%ebp),%eax
 5e9:	83 e8 08             	sub    $0x8,%eax
 5ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ef:	a1 60 0a 00 00       	mov    0xa60,%eax
 5f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f7:	eb 24                	jmp    61d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fc:	8b 00                	mov    (%eax),%eax
 5fe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 601:	77 12                	ja     615 <free+0x35>
 603:	8b 45 f8             	mov    -0x8(%ebp),%eax
 606:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 609:	77 24                	ja     62f <free+0x4f>
 60b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60e:	8b 00                	mov    (%eax),%eax
 610:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 613:	77 1a                	ja     62f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 620:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 623:	76 d4                	jbe    5f9 <free+0x19>
 625:	8b 45 fc             	mov    -0x4(%ebp),%eax
 628:	8b 00                	mov    (%eax),%eax
 62a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62d:	76 ca                	jbe    5f9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 62f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 632:	8b 40 04             	mov    0x4(%eax),%eax
 635:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 63c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63f:	01 c2                	add    %eax,%edx
 641:	8b 45 fc             	mov    -0x4(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	39 c2                	cmp    %eax,%edx
 648:	75 24                	jne    66e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 64a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64d:	8b 50 04             	mov    0x4(%eax),%edx
 650:	8b 45 fc             	mov    -0x4(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	8b 40 04             	mov    0x4(%eax),%eax
 658:	01 c2                	add    %eax,%edx
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	8b 00                	mov    (%eax),%eax
 665:	8b 10                	mov    (%eax),%edx
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	89 10                	mov    %edx,(%eax)
 66c:	eb 0a                	jmp    678 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 10                	mov    (%eax),%edx
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 40 04             	mov    0x4(%eax),%eax
 67e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	01 d0                	add    %edx,%eax
 68a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68d:	75 20                	jne    6af <free+0xcf>
    p->s.size += bp->s.size;
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 50 04             	mov    0x4(%eax),%edx
 695:	8b 45 f8             	mov    -0x8(%ebp),%eax
 698:	8b 40 04             	mov    0x4(%eax),%eax
 69b:	01 c2                	add    %eax,%edx
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	8b 10                	mov    (%eax),%edx
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	89 10                	mov    %edx,(%eax)
 6ad:	eb 08                	jmp    6b7 <free+0xd7>
  } else
    p->s.ptr = bp;
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b5:	89 10                	mov    %edx,(%eax)
  freep = p;
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 6bf:	c9                   	leave  
 6c0:	c3                   	ret    

000006c1 <morecore>:

static Header*
morecore(uint nu)
{
 6c1:	55                   	push   %ebp
 6c2:	89 e5                	mov    %esp,%ebp
 6c4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6c7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ce:	77 07                	ja     6d7 <morecore+0x16>
    nu = 4096;
 6d0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6d7:	8b 45 08             	mov    0x8(%ebp),%eax
 6da:	c1 e0 03             	shl    $0x3,%eax
 6dd:	89 04 24             	mov    %eax,(%esp)
 6e0:	e8 5b fc ff ff       	call   340 <sbrk>
 6e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6e8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6ec:	75 07                	jne    6f5 <morecore+0x34>
    return 0;
 6ee:	b8 00 00 00 00       	mov    $0x0,%eax
 6f3:	eb 22                	jmp    717 <morecore+0x56>
  hp = (Header*)p;
 6f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fe:	8b 55 08             	mov    0x8(%ebp),%edx
 701:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 704:	8b 45 f0             	mov    -0x10(%ebp),%eax
 707:	83 c0 08             	add    $0x8,%eax
 70a:	89 04 24             	mov    %eax,(%esp)
 70d:	e8 ce fe ff ff       	call   5e0 <free>
  return freep;
 712:	a1 60 0a 00 00       	mov    0xa60,%eax
}
 717:	c9                   	leave  
 718:	c3                   	ret    

00000719 <malloc>:

void*
malloc(uint nbytes)
{
 719:	55                   	push   %ebp
 71a:	89 e5                	mov    %esp,%ebp
 71c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71f:	8b 45 08             	mov    0x8(%ebp),%eax
 722:	83 c0 07             	add    $0x7,%eax
 725:	c1 e8 03             	shr    $0x3,%eax
 728:	40                   	inc    %eax
 729:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 72c:	a1 60 0a 00 00       	mov    0xa60,%eax
 731:	89 45 f0             	mov    %eax,-0x10(%ebp)
 734:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 738:	75 23                	jne    75d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 73a:	c7 45 f0 58 0a 00 00 	movl   $0xa58,-0x10(%ebp)
 741:	8b 45 f0             	mov    -0x10(%ebp),%eax
 744:	a3 60 0a 00 00       	mov    %eax,0xa60
 749:	a1 60 0a 00 00       	mov    0xa60,%eax
 74e:	a3 58 0a 00 00       	mov    %eax,0xa58
    base.s.size = 0;
 753:	c7 05 5c 0a 00 00 00 	movl   $0x0,0xa5c
 75a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 760:	8b 00                	mov    (%eax),%eax
 762:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 765:	8b 45 f4             	mov    -0xc(%ebp),%eax
 768:	8b 40 04             	mov    0x4(%eax),%eax
 76b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76e:	72 4d                	jb     7bd <malloc+0xa4>
      if(p->s.size == nunits)
 770:	8b 45 f4             	mov    -0xc(%ebp),%eax
 773:	8b 40 04             	mov    0x4(%eax),%eax
 776:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 779:	75 0c                	jne    787 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 77b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77e:	8b 10                	mov    (%eax),%edx
 780:	8b 45 f0             	mov    -0x10(%ebp),%eax
 783:	89 10                	mov    %edx,(%eax)
 785:	eb 26                	jmp    7ad <malloc+0x94>
      else {
        p->s.size -= nunits;
 787:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78a:	8b 40 04             	mov    0x4(%eax),%eax
 78d:	89 c2                	mov    %eax,%edx
 78f:	2b 55 ec             	sub    -0x14(%ebp),%edx
 792:	8b 45 f4             	mov    -0xc(%ebp),%eax
 795:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 798:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79b:	8b 40 04             	mov    0x4(%eax),%eax
 79e:	c1 e0 03             	shl    $0x3,%eax
 7a1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7aa:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b0:	a3 60 0a 00 00       	mov    %eax,0xa60
      return (void*)(p + 1);
 7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b8:	83 c0 08             	add    $0x8,%eax
 7bb:	eb 38                	jmp    7f5 <malloc+0xdc>
    }
    if(p == freep)
 7bd:	a1 60 0a 00 00       	mov    0xa60,%eax
 7c2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7c5:	75 1b                	jne    7e2 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ca:	89 04 24             	mov    %eax,(%esp)
 7cd:	e8 ef fe ff ff       	call   6c1 <morecore>
 7d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d9:	75 07                	jne    7e2 <malloc+0xc9>
        return 0;
 7db:	b8 00 00 00 00       	mov    $0x0,%eax
 7e0:	eb 13                	jmp    7f5 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	8b 00                	mov    (%eax),%eax
 7ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7f0:	e9 70 ff ff ff       	jmp    765 <malloc+0x4c>
}
 7f5:	c9                   	leave  
 7f6:	c3                   	ret    
