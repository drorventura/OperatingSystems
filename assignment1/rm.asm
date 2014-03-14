
_rm:     file format elf32-i386


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

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: rm files...\n");
   f:	c7 44 24 04 1b 08 00 	movl   $0x81b,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 31 04 00 00       	call   454 <printf>
    exit();
  23:	e8 b4 02 00 00       	call   2dc <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4e                	jmp    80 <main+0x80>
    if(unlink(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 e0 02 00 00       	call   32c <unlink>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 2f 08 00 	movl   $0x82f,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 da 03 00 00       	call   454 <printf>
      break;
  7a:	eb 0d                	jmp    89 <main+0x89>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  7c:	ff 44 24 1c          	incl   0x1c(%esp)
  80:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  84:	3b 45 08             	cmp    0x8(%ebp),%eax
  87:	7c a9                	jl     32 <main+0x32>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  89:	e8 4e 02 00 00       	call   2dc <exit>
  8e:	66 90                	xchg   %ax,%ax

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld    
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	5b                   	pop    %ebx
  b2:	5f                   	pop    %edi
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c1:	90                   	nop
  c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  c5:	8a 10                	mov    (%eax),%dl
  c7:	8b 45 08             	mov    0x8(%ebp),%eax
  ca:	88 10                	mov    %dl,(%eax)
  cc:	8b 45 08             	mov    0x8(%ebp),%eax
  cf:	8a 00                	mov    (%eax),%al
  d1:	84 c0                	test   %al,%al
  d3:	0f 95 c0             	setne  %al
  d6:	ff 45 08             	incl   0x8(%ebp)
  d9:	ff 45 0c             	incl   0xc(%ebp)
  dc:	84 c0                	test   %al,%al
  de:	75 e2                	jne    c2 <strcpy+0xd>
    ;
  return os;
  e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e3:	c9                   	leave  
  e4:	c3                   	ret    

000000e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e8:	eb 06                	jmp    f0 <strcmp+0xb>
    p++, q++;
  ea:	ff 45 08             	incl   0x8(%ebp)
  ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f0:	8b 45 08             	mov    0x8(%ebp),%eax
  f3:	8a 00                	mov    (%eax),%al
  f5:	84 c0                	test   %al,%al
  f7:	74 0e                	je     107 <strcmp+0x22>
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
  fc:	8a 10                	mov    (%eax),%dl
  fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 101:	8a 00                	mov    (%eax),%al
 103:	38 c2                	cmp    %al,%dl
 105:	74 e3                	je     ea <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 107:	8b 45 08             	mov    0x8(%ebp),%eax
 10a:	8a 00                	mov    (%eax),%al
 10c:	0f b6 d0             	movzbl %al,%edx
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	8a 00                	mov    (%eax),%al
 114:	0f b6 c0             	movzbl %al,%eax
 117:	89 d1                	mov    %edx,%ecx
 119:	29 c1                	sub    %eax,%ecx
 11b:	89 c8                	mov    %ecx,%eax
}
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret    

0000011f <strlen>:

uint
strlen(char *s)
{
 11f:	55                   	push   %ebp
 120:	89 e5                	mov    %esp,%ebp
 122:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 12c:	eb 03                	jmp    131 <strlen+0x12>
 12e:	ff 45 fc             	incl   -0x4(%ebp)
 131:	8b 55 fc             	mov    -0x4(%ebp),%edx
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	01 d0                	add    %edx,%eax
 139:	8a 00                	mov    (%eax),%al
 13b:	84 c0                	test   %al,%al
 13d:	75 ef                	jne    12e <strlen+0xf>
    ;
  return n;
 13f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 142:	c9                   	leave  
 143:	c3                   	ret    

00000144 <memset>:

void*
memset(void *dst, int c, uint n)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 14a:	8b 45 10             	mov    0x10(%ebp),%eax
 14d:	89 44 24 08          	mov    %eax,0x8(%esp)
 151:	8b 45 0c             	mov    0xc(%ebp),%eax
 154:	89 44 24 04          	mov    %eax,0x4(%esp)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	89 04 24             	mov    %eax,(%esp)
 15e:	e8 2d ff ff ff       	call   90 <stosb>
  return dst;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
}
 166:	c9                   	leave  
 167:	c3                   	ret    

00000168 <strchr>:

char*
strchr(const char *s, char c)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
 16b:	83 ec 04             	sub    $0x4,%esp
 16e:	8b 45 0c             	mov    0xc(%ebp),%eax
 171:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 174:	eb 12                	jmp    188 <strchr+0x20>
    if(*s == c)
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	8a 00                	mov    (%eax),%al
 17b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17e:	75 05                	jne    185 <strchr+0x1d>
      return (char*)s;
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	eb 11                	jmp    196 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 185:	ff 45 08             	incl   0x8(%ebp)
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	8a 00                	mov    (%eax),%al
 18d:	84 c0                	test   %al,%al
 18f:	75 e5                	jne    176 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 191:	b8 00 00 00 00       	mov    $0x0,%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <gets>:

char*
gets(char *buf, int max)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a5:	eb 42                	jmp    1e9 <gets+0x51>
    cc = read(0, &c, 1);
 1a7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ae:	00 
 1af:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1bd:	e8 32 01 00 00       	call   2f4 <read>
 1c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c9:	7e 29                	jle    1f4 <gets+0x5c>
      break;
    buf[i++] = c;
 1cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	01 c2                	add    %eax,%edx
 1d3:	8a 45 ef             	mov    -0x11(%ebp),%al
 1d6:	88 02                	mov    %al,(%edx)
 1d8:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1db:	8a 45 ef             	mov    -0x11(%ebp),%al
 1de:	3c 0a                	cmp    $0xa,%al
 1e0:	74 13                	je     1f5 <gets+0x5d>
 1e2:	8a 45 ef             	mov    -0x11(%ebp),%al
 1e5:	3c 0d                	cmp    $0xd,%al
 1e7:	74 0c                	je     1f5 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ec:	40                   	inc    %eax
 1ed:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f0:	7c b5                	jl     1a7 <gets+0xf>
 1f2:	eb 01                	jmp    1f5 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f4:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
 1fb:	01 d0                	add    %edx,%eax
 1fd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 200:	8b 45 08             	mov    0x8(%ebp),%eax
}
 203:	c9                   	leave  
 204:	c3                   	ret    

00000205 <stat>:

int
stat(char *n, struct stat *st)
{
 205:	55                   	push   %ebp
 206:	89 e5                	mov    %esp,%ebp
 208:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 212:	00 
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	89 04 24             	mov    %eax,(%esp)
 219:	e8 fe 00 00 00       	call   31c <open>
 21e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 225:	79 07                	jns    22e <stat+0x29>
    return -1;
 227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22c:	eb 23                	jmp    251 <stat+0x4c>
  r = fstat(fd, st);
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	89 44 24 04          	mov    %eax,0x4(%esp)
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	89 04 24             	mov    %eax,(%esp)
 23b:	e8 f4 00 00 00       	call   334 <fstat>
 240:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 243:	8b 45 f4             	mov    -0xc(%ebp),%eax
 246:	89 04 24             	mov    %eax,(%esp)
 249:	e8 b6 00 00 00       	call   304 <close>
  return r;
 24e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 251:	c9                   	leave  
 252:	c3                   	ret    

00000253 <atoi>:

int
atoi(const char *s)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 259:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 260:	eb 21                	jmp    283 <atoi+0x30>
    n = n*10 + *s++ - '0';
 262:	8b 55 fc             	mov    -0x4(%ebp),%edx
 265:	89 d0                	mov    %edx,%eax
 267:	c1 e0 02             	shl    $0x2,%eax
 26a:	01 d0                	add    %edx,%eax
 26c:	d1 e0                	shl    %eax
 26e:	89 c2                	mov    %eax,%edx
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	8a 00                	mov    (%eax),%al
 275:	0f be c0             	movsbl %al,%eax
 278:	01 d0                	add    %edx,%eax
 27a:	83 e8 30             	sub    $0x30,%eax
 27d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 280:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	8a 00                	mov    (%eax),%al
 288:	3c 2f                	cmp    $0x2f,%al
 28a:	7e 09                	jle    295 <atoi+0x42>
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	8a 00                	mov    (%eax),%al
 291:	3c 39                	cmp    $0x39,%al
 293:	7e cd                	jle    262 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 295:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ac:	eb 10                	jmp    2be <memmove+0x24>
    *dst++ = *src++;
 2ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b1:	8a 10                	mov    (%eax),%dl
 2b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b6:	88 10                	mov    %dl,(%eax)
 2b8:	ff 45 fc             	incl   -0x4(%ebp)
 2bb:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2c2:	0f 9f c0             	setg   %al
 2c5:	ff 4d 10             	decl   0x10(%ebp)
 2c8:	84 c0                	test   %al,%al
 2ca:	75 e2                	jne    2ae <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2cf:	c9                   	leave  
 2d0:	c3                   	ret    
 2d1:	66 90                	xchg   %ax,%ax
 2d3:	90                   	nop

000002d4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d4:	b8 01 00 00 00       	mov    $0x1,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <exit>:
SYSCALL(exit)
 2dc:	b8 02 00 00 00       	mov    $0x2,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <wait>:
SYSCALL(wait)
 2e4:	b8 03 00 00 00       	mov    $0x3,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <pipe>:
SYSCALL(pipe)
 2ec:	b8 04 00 00 00       	mov    $0x4,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <read>:
SYSCALL(read)
 2f4:	b8 05 00 00 00       	mov    $0x5,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <write>:
SYSCALL(write)
 2fc:	b8 10 00 00 00       	mov    $0x10,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <close>:
SYSCALL(close)
 304:	b8 15 00 00 00       	mov    $0x15,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <kill>:
SYSCALL(kill)
 30c:	b8 06 00 00 00       	mov    $0x6,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <exec>:
SYSCALL(exec)
 314:	b8 07 00 00 00       	mov    $0x7,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <open>:
SYSCALL(open)
 31c:	b8 0f 00 00 00       	mov    $0xf,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <mknod>:
SYSCALL(mknod)
 324:	b8 11 00 00 00       	mov    $0x11,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <unlink>:
SYSCALL(unlink)
 32c:	b8 12 00 00 00       	mov    $0x12,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <fstat>:
SYSCALL(fstat)
 334:	b8 08 00 00 00       	mov    $0x8,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <link>:
SYSCALL(link)
 33c:	b8 13 00 00 00       	mov    $0x13,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <mkdir>:
SYSCALL(mkdir)
 344:	b8 14 00 00 00       	mov    $0x14,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <chdir>:
SYSCALL(chdir)
 34c:	b8 09 00 00 00       	mov    $0x9,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <dup>:
SYSCALL(dup)
 354:	b8 0a 00 00 00       	mov    $0xa,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <getpid>:
SYSCALL(getpid)
 35c:	b8 0b 00 00 00       	mov    $0xb,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <sbrk>:
SYSCALL(sbrk)
 364:	b8 0c 00 00 00       	mov    $0xc,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <sleep>:
SYSCALL(sleep)
 36c:	b8 0d 00 00 00       	mov    $0xd,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <uptime>:
SYSCALL(uptime)
 374:	b8 0e 00 00 00       	mov    $0xe,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 37c:	55                   	push   %ebp
 37d:	89 e5                	mov    %esp,%ebp
 37f:	83 ec 28             	sub    $0x28,%esp
 382:	8b 45 0c             	mov    0xc(%ebp),%eax
 385:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 388:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 38f:	00 
 390:	8d 45 f4             	lea    -0xc(%ebp),%eax
 393:	89 44 24 04          	mov    %eax,0x4(%esp)
 397:	8b 45 08             	mov    0x8(%ebp),%eax
 39a:	89 04 24             	mov    %eax,(%esp)
 39d:	e8 5a ff ff ff       	call   2fc <write>
}
 3a2:	c9                   	leave  
 3a3:	c3                   	ret    

000003a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b5:	74 17                	je     3ce <printint+0x2a>
 3b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3bb:	79 11                	jns    3ce <printint+0x2a>
    neg = 1;
 3bd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c7:	f7 d8                	neg    %eax
 3c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3cc:	eb 06                	jmp    3d4 <printint+0x30>
  } else {
    x = xx;
 3ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3db:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3de:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e1:	ba 00 00 00 00       	mov    $0x0,%edx
 3e6:	f7 f1                	div    %ecx
 3e8:	89 d0                	mov    %edx,%eax
 3ea:	8a 80 8c 0a 00 00    	mov    0xa8c(%eax),%al
 3f0:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3f6:	01 ca                	add    %ecx,%edx
 3f8:	88 02                	mov    %al,(%edx)
 3fa:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3fd:	8b 55 10             	mov    0x10(%ebp),%edx
 400:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 403:	8b 45 ec             	mov    -0x14(%ebp),%eax
 406:	ba 00 00 00 00       	mov    $0x0,%edx
 40b:	f7 75 d4             	divl   -0x2c(%ebp)
 40e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 411:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 415:	75 c4                	jne    3db <printint+0x37>
  if(neg)
 417:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 41b:	74 2c                	je     449 <printint+0xa5>
    buf[i++] = '-';
 41d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 420:	8b 45 f4             	mov    -0xc(%ebp),%eax
 423:	01 d0                	add    %edx,%eax
 425:	c6 00 2d             	movb   $0x2d,(%eax)
 428:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 42b:	eb 1c                	jmp    449 <printint+0xa5>
    putc(fd, buf[i]);
 42d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 430:	8b 45 f4             	mov    -0xc(%ebp),%eax
 433:	01 d0                	add    %edx,%eax
 435:	8a 00                	mov    (%eax),%al
 437:	0f be c0             	movsbl %al,%eax
 43a:	89 44 24 04          	mov    %eax,0x4(%esp)
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	89 04 24             	mov    %eax,(%esp)
 444:	e8 33 ff ff ff       	call   37c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 449:	ff 4d f4             	decl   -0xc(%ebp)
 44c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 450:	79 db                	jns    42d <printint+0x89>
    putc(fd, buf[i]);
}
 452:	c9                   	leave  
 453:	c3                   	ret    

00000454 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 454:	55                   	push   %ebp
 455:	89 e5                	mov    %esp,%ebp
 457:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 45a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 461:	8d 45 0c             	lea    0xc(%ebp),%eax
 464:	83 c0 04             	add    $0x4,%eax
 467:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 46a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 471:	e9 78 01 00 00       	jmp    5ee <printf+0x19a>
    c = fmt[i] & 0xff;
 476:	8b 55 0c             	mov    0xc(%ebp),%edx
 479:	8b 45 f0             	mov    -0x10(%ebp),%eax
 47c:	01 d0                	add    %edx,%eax
 47e:	8a 00                	mov    (%eax),%al
 480:	0f be c0             	movsbl %al,%eax
 483:	25 ff 00 00 00       	and    $0xff,%eax
 488:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 48b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48f:	75 2c                	jne    4bd <printf+0x69>
      if(c == '%'){
 491:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 495:	75 0c                	jne    4a3 <printf+0x4f>
        state = '%';
 497:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 49e:	e9 48 01 00 00       	jmp    5eb <printf+0x197>
      } else {
        putc(fd, c);
 4a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a6:	0f be c0             	movsbl %al,%eax
 4a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ad:	8b 45 08             	mov    0x8(%ebp),%eax
 4b0:	89 04 24             	mov    %eax,(%esp)
 4b3:	e8 c4 fe ff ff       	call   37c <putc>
 4b8:	e9 2e 01 00 00       	jmp    5eb <printf+0x197>
      }
    } else if(state == '%'){
 4bd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c1:	0f 85 24 01 00 00    	jne    5eb <printf+0x197>
      if(c == 'd'){
 4c7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4cb:	75 2d                	jne    4fa <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d0:	8b 00                	mov    (%eax),%eax
 4d2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4d9:	00 
 4da:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4e1:	00 
 4e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	89 04 24             	mov    %eax,(%esp)
 4ec:	e8 b3 fe ff ff       	call   3a4 <printint>
        ap++;
 4f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f5:	e9 ea 00 00 00       	jmp    5e4 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4fa:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4fe:	74 06                	je     506 <printf+0xb2>
 500:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 504:	75 2d                	jne    533 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 506:	8b 45 e8             	mov    -0x18(%ebp),%eax
 509:	8b 00                	mov    (%eax),%eax
 50b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 512:	00 
 513:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 51a:	00 
 51b:	89 44 24 04          	mov    %eax,0x4(%esp)
 51f:	8b 45 08             	mov    0x8(%ebp),%eax
 522:	89 04 24             	mov    %eax,(%esp)
 525:	e8 7a fe ff ff       	call   3a4 <printint>
        ap++;
 52a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52e:	e9 b1 00 00 00       	jmp    5e4 <printf+0x190>
      } else if(c == 's'){
 533:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 537:	75 43                	jne    57c <printf+0x128>
        s = (char*)*ap;
 539:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53c:	8b 00                	mov    (%eax),%eax
 53e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 541:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 545:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 549:	75 25                	jne    570 <printf+0x11c>
          s = "(null)";
 54b:	c7 45 f4 48 08 00 00 	movl   $0x848,-0xc(%ebp)
        while(*s != 0){
 552:	eb 1c                	jmp    570 <printf+0x11c>
          putc(fd, *s);
 554:	8b 45 f4             	mov    -0xc(%ebp),%eax
 557:	8a 00                	mov    (%eax),%al
 559:	0f be c0             	movsbl %al,%eax
 55c:	89 44 24 04          	mov    %eax,0x4(%esp)
 560:	8b 45 08             	mov    0x8(%ebp),%eax
 563:	89 04 24             	mov    %eax,(%esp)
 566:	e8 11 fe ff ff       	call   37c <putc>
          s++;
 56b:	ff 45 f4             	incl   -0xc(%ebp)
 56e:	eb 01                	jmp    571 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 570:	90                   	nop
 571:	8b 45 f4             	mov    -0xc(%ebp),%eax
 574:	8a 00                	mov    (%eax),%al
 576:	84 c0                	test   %al,%al
 578:	75 da                	jne    554 <printf+0x100>
 57a:	eb 68                	jmp    5e4 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 580:	75 1d                	jne    59f <printf+0x14b>
        putc(fd, *ap);
 582:	8b 45 e8             	mov    -0x18(%ebp),%eax
 585:	8b 00                	mov    (%eax),%eax
 587:	0f be c0             	movsbl %al,%eax
 58a:	89 44 24 04          	mov    %eax,0x4(%esp)
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
 591:	89 04 24             	mov    %eax,(%esp)
 594:	e8 e3 fd ff ff       	call   37c <putc>
        ap++;
 599:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59d:	eb 45                	jmp    5e4 <printf+0x190>
      } else if(c == '%'){
 59f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a3:	75 17                	jne    5bc <printf+0x168>
        putc(fd, c);
 5a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a8:	0f be c0             	movsbl %al,%eax
 5ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 5af:	8b 45 08             	mov    0x8(%ebp),%eax
 5b2:	89 04 24             	mov    %eax,(%esp)
 5b5:	e8 c2 fd ff ff       	call   37c <putc>
 5ba:	eb 28                	jmp    5e4 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5bc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5c3:	00 
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	89 04 24             	mov    %eax,(%esp)
 5ca:	e8 ad fd ff ff       	call   37c <putc>
        putc(fd, c);
 5cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d2:	0f be c0             	movsbl %al,%eax
 5d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	89 04 24             	mov    %eax,(%esp)
 5df:	e8 98 fd ff ff       	call   37c <putc>
      }
      state = 0;
 5e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5eb:	ff 45 f0             	incl   -0x10(%ebp)
 5ee:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f4:	01 d0                	add    %edx,%eax
 5f6:	8a 00                	mov    (%eax),%al
 5f8:	84 c0                	test   %al,%al
 5fa:	0f 85 76 fe ff ff    	jne    476 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 600:	c9                   	leave  
 601:	c3                   	ret    
 602:	66 90                	xchg   %ax,%ax

00000604 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 604:	55                   	push   %ebp
 605:	89 e5                	mov    %esp,%ebp
 607:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60a:	8b 45 08             	mov    0x8(%ebp),%eax
 60d:	83 e8 08             	sub    $0x8,%eax
 610:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 613:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 618:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61b:	eb 24                	jmp    641 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 625:	77 12                	ja     639 <free+0x35>
 627:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62d:	77 24                	ja     653 <free+0x4f>
 62f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 637:	77 1a                	ja     653 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 639:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63c:	8b 00                	mov    (%eax),%eax
 63e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 641:	8b 45 f8             	mov    -0x8(%ebp),%eax
 644:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 647:	76 d4                	jbe    61d <free+0x19>
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 651:	76 ca                	jbe    61d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	8b 40 04             	mov    0x4(%eax),%eax
 659:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	01 c2                	add    %eax,%edx
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	39 c2                	cmp    %eax,%edx
 66c:	75 24                	jne    692 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 66e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 671:	8b 50 04             	mov    0x4(%eax),%edx
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	8b 40 04             	mov    0x4(%eax),%eax
 67c:	01 c2                	add    %eax,%edx
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	89 10                	mov    %edx,(%eax)
 690:	eb 0a                	jmp    69c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 10                	mov    (%eax),%edx
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 40 04             	mov    0x4(%eax),%eax
 6a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	01 d0                	add    %edx,%eax
 6ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b1:	75 20                	jne    6d3 <free+0xcf>
    p->s.size += bp->s.size;
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 50 04             	mov    0x4(%eax),%edx
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	8b 40 04             	mov    0x4(%eax),%eax
 6bf:	01 c2                	add    %eax,%edx
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	8b 10                	mov    (%eax),%edx
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	89 10                	mov    %edx,(%eax)
 6d1:	eb 08                	jmp    6db <free+0xd7>
  } else
    p->s.ptr = bp;
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6d9:	89 10                	mov    %edx,(%eax)
  freep = p;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	a3 a8 0a 00 00       	mov    %eax,0xaa8
}
 6e3:	c9                   	leave  
 6e4:	c3                   	ret    

000006e5 <morecore>:

static Header*
morecore(uint nu)
{
 6e5:	55                   	push   %ebp
 6e6:	89 e5                	mov    %esp,%ebp
 6e8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6eb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f2:	77 07                	ja     6fb <morecore+0x16>
    nu = 4096;
 6f4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6fb:	8b 45 08             	mov    0x8(%ebp),%eax
 6fe:	c1 e0 03             	shl    $0x3,%eax
 701:	89 04 24             	mov    %eax,(%esp)
 704:	e8 5b fc ff ff       	call   364 <sbrk>
 709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 70c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 710:	75 07                	jne    719 <morecore+0x34>
    return 0;
 712:	b8 00 00 00 00       	mov    $0x0,%eax
 717:	eb 22                	jmp    73b <morecore+0x56>
  hp = (Header*)p;
 719:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 71f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 722:	8b 55 08             	mov    0x8(%ebp),%edx
 725:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 728:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72b:	83 c0 08             	add    $0x8,%eax
 72e:	89 04 24             	mov    %eax,(%esp)
 731:	e8 ce fe ff ff       	call   604 <free>
  return freep;
 736:	a1 a8 0a 00 00       	mov    0xaa8,%eax
}
 73b:	c9                   	leave  
 73c:	c3                   	ret    

0000073d <malloc>:

void*
malloc(uint nbytes)
{
 73d:	55                   	push   %ebp
 73e:	89 e5                	mov    %esp,%ebp
 740:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 743:	8b 45 08             	mov    0x8(%ebp),%eax
 746:	83 c0 07             	add    $0x7,%eax
 749:	c1 e8 03             	shr    $0x3,%eax
 74c:	40                   	inc    %eax
 74d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 750:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 755:	89 45 f0             	mov    %eax,-0x10(%ebp)
 758:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 75c:	75 23                	jne    781 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 75e:	c7 45 f0 a0 0a 00 00 	movl   $0xaa0,-0x10(%ebp)
 765:	8b 45 f0             	mov    -0x10(%ebp),%eax
 768:	a3 a8 0a 00 00       	mov    %eax,0xaa8
 76d:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 772:	a3 a0 0a 00 00       	mov    %eax,0xaa0
    base.s.size = 0;
 777:	c7 05 a4 0a 00 00 00 	movl   $0x0,0xaa4
 77e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 781:	8b 45 f0             	mov    -0x10(%ebp),%eax
 784:	8b 00                	mov    (%eax),%eax
 786:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	8b 40 04             	mov    0x4(%eax),%eax
 78f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 792:	72 4d                	jb     7e1 <malloc+0xa4>
      if(p->s.size == nunits)
 794:	8b 45 f4             	mov    -0xc(%ebp),%eax
 797:	8b 40 04             	mov    0x4(%eax),%eax
 79a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 79d:	75 0c                	jne    7ab <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	8b 10                	mov    (%eax),%edx
 7a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a7:	89 10                	mov    %edx,(%eax)
 7a9:	eb 26                	jmp    7d1 <malloc+0x94>
      else {
        p->s.size -= nunits;
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	8b 40 04             	mov    0x4(%eax),%eax
 7b1:	89 c2                	mov    %eax,%edx
 7b3:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	8b 40 04             	mov    0x4(%eax),%eax
 7c2:	c1 e0 03             	shl    $0x3,%eax
 7c5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ce:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d4:	a3 a8 0a 00 00       	mov    %eax,0xaa8
      return (void*)(p + 1);
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	83 c0 08             	add    $0x8,%eax
 7df:	eb 38                	jmp    819 <malloc+0xdc>
    }
    if(p == freep)
 7e1:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 7e6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7e9:	75 1b                	jne    806 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ee:	89 04 24             	mov    %eax,(%esp)
 7f1:	e8 ef fe ff ff       	call   6e5 <morecore>
 7f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7fd:	75 07                	jne    806 <malloc+0xc9>
        return 0;
 7ff:	b8 00 00 00 00       	mov    $0x0,%eax
 804:	eb 13                	jmp    819 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 00                	mov    (%eax),%eax
 811:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 814:	e9 70 ff ff ff       	jmp    789 <malloc+0x4c>
}
 819:	c9                   	leave  
 81a:	c3                   	ret    
