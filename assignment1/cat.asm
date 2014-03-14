
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 80 0b 00 	movl   $0xb80,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 65 03 00 00       	call   388 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 80 0b 00 	movl   $0xb80,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 42 03 00 00       	call   380 <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 a7 08 00 	movl   $0x8a7,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 7f 04 00 00       	call   4e0 <printf>
    exit();
  61:	e8 02 03 00 00       	call   368 <exit>
  }
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:

int
main(int argc, char *argv[])
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  71:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  75:	7f 11                	jg     88 <main+0x20>
    cat(0);
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 7d ff ff ff       	call   0 <cat>
    exit();
  83:	e8 e0 02 00 00       	call   368 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8f:	00 
  90:	eb 78                	jmp    10a <main+0xa2>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
  a2:	8b 00                	mov    (%eax),%eax
  a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ab:	00 
  ac:	89 04 24             	mov    %eax,(%esp)
  af:	e8 f4 02 00 00       	call   3a8 <open>
  b4:	89 44 24 18          	mov    %eax,0x18(%esp)
  b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  bd:	79 2f                	jns    ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	01 d0                	add    %edx,%eax
  cf:	8b 00                	mov    (%eax),%eax
  d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  d5:	c7 44 24 04 b8 08 00 	movl   $0x8b8,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 f7 03 00 00       	call   4e0 <printf>
      exit();
  e9:	e8 7a 02 00 00       	call   368 <exit>
    }
    cat(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 06 ff ff ff       	call   0 <cat>
    close(fd);
  fa:	8b 44 24 18          	mov    0x18(%esp),%eax
  fe:	89 04 24             	mov    %eax,(%esp)
 101:	e8 8a 02 00 00       	call   390 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
 106:	ff 44 24 1c          	incl   0x1c(%esp)
 10a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10e:	3b 45 08             	cmp    0x8(%ebp),%eax
 111:	0f 8c 7b ff ff ff    	jl     92 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 117:	e8 4c 02 00 00       	call   368 <exit>

0000011c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	57                   	push   %edi
 120:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 121:	8b 4d 08             	mov    0x8(%ebp),%ecx
 124:	8b 55 10             	mov    0x10(%ebp),%edx
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	89 cb                	mov    %ecx,%ebx
 12c:	89 df                	mov    %ebx,%edi
 12e:	89 d1                	mov    %edx,%ecx
 130:	fc                   	cld    
 131:	f3 aa                	rep stos %al,%es:(%edi)
 133:	89 ca                	mov    %ecx,%edx
 135:	89 fb                	mov    %edi,%ebx
 137:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13d:	5b                   	pop    %ebx
 13e:	5f                   	pop    %edi
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    

00000141 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14d:	90                   	nop
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	8a 10                	mov    (%eax),%dl
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	88 10                	mov    %dl,(%eax)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	8a 00                	mov    (%eax),%al
 15d:	84 c0                	test   %al,%al
 15f:	0f 95 c0             	setne  %al
 162:	ff 45 08             	incl   0x8(%ebp)
 165:	ff 45 0c             	incl   0xc(%ebp)
 168:	84 c0                	test   %al,%al
 16a:	75 e2                	jne    14e <strcpy+0xd>
    ;
  return os;
 16c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16f:	c9                   	leave  
 170:	c3                   	ret    

00000171 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 171:	55                   	push   %ebp
 172:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 174:	eb 06                	jmp    17c <strcmp+0xb>
    p++, q++;
 176:	ff 45 08             	incl   0x8(%ebp)
 179:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	8a 00                	mov    (%eax),%al
 181:	84 c0                	test   %al,%al
 183:	74 0e                	je     193 <strcmp+0x22>
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	8a 10                	mov    (%eax),%dl
 18a:	8b 45 0c             	mov    0xc(%ebp),%eax
 18d:	8a 00                	mov    (%eax),%al
 18f:	38 c2                	cmp    %al,%dl
 191:	74 e3                	je     176 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	8a 00                	mov    (%eax),%al
 198:	0f b6 d0             	movzbl %al,%edx
 19b:	8b 45 0c             	mov    0xc(%ebp),%eax
 19e:	8a 00                	mov    (%eax),%al
 1a0:	0f b6 c0             	movzbl %al,%eax
 1a3:	89 d1                	mov    %edx,%ecx
 1a5:	29 c1                	sub    %eax,%ecx
 1a7:	89 c8                	mov    %ecx,%eax
}
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    

000001ab <strlen>:

uint
strlen(char *s)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b8:	eb 03                	jmp    1bd <strlen+0x12>
 1ba:	ff 45 fc             	incl   -0x4(%ebp)
 1bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	01 d0                	add    %edx,%eax
 1c5:	8a 00                	mov    (%eax),%al
 1c7:	84 c0                	test   %al,%al
 1c9:	75 ef                	jne    1ba <strlen+0xf>
    ;
  return n;
 1cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ce:	c9                   	leave  
 1cf:	c3                   	ret    

000001d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d6:	8b 45 10             	mov    0x10(%ebp),%eax
 1d9:	89 44 24 08          	mov    %eax,0x8(%esp)
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	89 04 24             	mov    %eax,(%esp)
 1ea:	e8 2d ff ff ff       	call   11c <stosb>
  return dst;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f2:	c9                   	leave  
 1f3:	c3                   	ret    

000001f4 <strchr>:

char*
strchr(const char *s, char c)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	83 ec 04             	sub    $0x4,%esp
 1fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 200:	eb 12                	jmp    214 <strchr+0x20>
    if(*s == c)
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	8a 00                	mov    (%eax),%al
 207:	3a 45 fc             	cmp    -0x4(%ebp),%al
 20a:	75 05                	jne    211 <strchr+0x1d>
      return (char*)s;
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	eb 11                	jmp    222 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 211:	ff 45 08             	incl   0x8(%ebp)
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	8a 00                	mov    (%eax),%al
 219:	84 c0                	test   %al,%al
 21b:	75 e5                	jne    202 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 222:	c9                   	leave  
 223:	c3                   	ret    

00000224 <gets>:

char*
gets(char *buf, int max)
{
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 231:	eb 42                	jmp    275 <gets+0x51>
    cc = read(0, &c, 1);
 233:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 23a:	00 
 23b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23e:	89 44 24 04          	mov    %eax,0x4(%esp)
 242:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 249:	e8 32 01 00 00       	call   380 <read>
 24e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 251:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 255:	7e 29                	jle    280 <gets+0x5c>
      break;
    buf[i++] = c;
 257:	8b 55 f4             	mov    -0xc(%ebp),%edx
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	01 c2                	add    %eax,%edx
 25f:	8a 45 ef             	mov    -0x11(%ebp),%al
 262:	88 02                	mov    %al,(%edx)
 264:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 267:	8a 45 ef             	mov    -0x11(%ebp),%al
 26a:	3c 0a                	cmp    $0xa,%al
 26c:	74 13                	je     281 <gets+0x5d>
 26e:	8a 45 ef             	mov    -0x11(%ebp),%al
 271:	3c 0d                	cmp    $0xd,%al
 273:	74 0c                	je     281 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 275:	8b 45 f4             	mov    -0xc(%ebp),%eax
 278:	40                   	inc    %eax
 279:	3b 45 0c             	cmp    0xc(%ebp),%eax
 27c:	7c b5                	jl     233 <gets+0xf>
 27e:	eb 01                	jmp    281 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 280:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 281:	8b 55 f4             	mov    -0xc(%ebp),%edx
 284:	8b 45 08             	mov    0x8(%ebp),%eax
 287:	01 d0                	add    %edx,%eax
 289:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28f:	c9                   	leave  
 290:	c3                   	ret    

00000291 <stat>:

int
stat(char *n, struct stat *st)
{
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
 294:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 297:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 29e:	00 
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	89 04 24             	mov    %eax,(%esp)
 2a5:	e8 fe 00 00 00       	call   3a8 <open>
 2aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b1:	79 07                	jns    2ba <stat+0x29>
    return -1;
 2b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b8:	eb 23                	jmp    2dd <stat+0x4c>
  r = fstat(fd, st);
 2ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c4:	89 04 24             	mov    %eax,(%esp)
 2c7:	e8 f4 00 00 00       	call   3c0 <fstat>
 2cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d2:	89 04 24             	mov    %eax,(%esp)
 2d5:	e8 b6 00 00 00       	call   390 <close>
  return r;
 2da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2dd:	c9                   	leave  
 2de:	c3                   	ret    

000002df <atoi>:

int
atoi(const char *s)
{
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp
 2e2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ec:	eb 21                	jmp    30f <atoi+0x30>
    n = n*10 + *s++ - '0';
 2ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f1:	89 d0                	mov    %edx,%eax
 2f3:	c1 e0 02             	shl    $0x2,%eax
 2f6:	01 d0                	add    %edx,%eax
 2f8:	d1 e0                	shl    %eax
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	8a 00                	mov    (%eax),%al
 301:	0f be c0             	movsbl %al,%eax
 304:	01 d0                	add    %edx,%eax
 306:	83 e8 30             	sub    $0x30,%eax
 309:	89 45 fc             	mov    %eax,-0x4(%ebp)
 30c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	8a 00                	mov    (%eax),%al
 314:	3c 2f                	cmp    $0x2f,%al
 316:	7e 09                	jle    321 <atoi+0x42>
 318:	8b 45 08             	mov    0x8(%ebp),%eax
 31b:	8a 00                	mov    (%eax),%al
 31d:	3c 39                	cmp    $0x39,%al
 31f:	7e cd                	jle    2ee <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 321:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 324:	c9                   	leave  
 325:	c3                   	ret    

00000326 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 326:	55                   	push   %ebp
 327:	89 e5                	mov    %esp,%ebp
 329:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 332:	8b 45 0c             	mov    0xc(%ebp),%eax
 335:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 338:	eb 10                	jmp    34a <memmove+0x24>
    *dst++ = *src++;
 33a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 33d:	8a 10                	mov    (%eax),%dl
 33f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 342:	88 10                	mov    %dl,(%eax)
 344:	ff 45 fc             	incl   -0x4(%ebp)
 347:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 34a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 34e:	0f 9f c0             	setg   %al
 351:	ff 4d 10             	decl   0x10(%ebp)
 354:	84 c0                	test   %al,%al
 356:	75 e2                	jne    33a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 358:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35b:	c9                   	leave  
 35c:	c3                   	ret    
 35d:	66 90                	xchg   %ax,%ax
 35f:	90                   	nop

00000360 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 360:	b8 01 00 00 00       	mov    $0x1,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <exit>:
SYSCALL(exit)
 368:	b8 02 00 00 00       	mov    $0x2,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <wait>:
SYSCALL(wait)
 370:	b8 03 00 00 00       	mov    $0x3,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <pipe>:
SYSCALL(pipe)
 378:	b8 04 00 00 00       	mov    $0x4,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <read>:
SYSCALL(read)
 380:	b8 05 00 00 00       	mov    $0x5,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <write>:
SYSCALL(write)
 388:	b8 10 00 00 00       	mov    $0x10,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <close>:
SYSCALL(close)
 390:	b8 15 00 00 00       	mov    $0x15,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <kill>:
SYSCALL(kill)
 398:	b8 06 00 00 00       	mov    $0x6,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <exec>:
SYSCALL(exec)
 3a0:	b8 07 00 00 00       	mov    $0x7,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <open>:
SYSCALL(open)
 3a8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <mknod>:
SYSCALL(mknod)
 3b0:	b8 11 00 00 00       	mov    $0x11,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <unlink>:
SYSCALL(unlink)
 3b8:	b8 12 00 00 00       	mov    $0x12,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <fstat>:
SYSCALL(fstat)
 3c0:	b8 08 00 00 00       	mov    $0x8,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <link>:
SYSCALL(link)
 3c8:	b8 13 00 00 00       	mov    $0x13,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <mkdir>:
SYSCALL(mkdir)
 3d0:	b8 14 00 00 00       	mov    $0x14,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <chdir>:
SYSCALL(chdir)
 3d8:	b8 09 00 00 00       	mov    $0x9,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <dup>:
SYSCALL(dup)
 3e0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <getpid>:
SYSCALL(getpid)
 3e8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <sbrk>:
SYSCALL(sbrk)
 3f0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <sleep>:
SYSCALL(sleep)
 3f8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <uptime>:
SYSCALL(uptime)
 400:	b8 0e 00 00 00       	mov    $0xe,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 408:	55                   	push   %ebp
 409:	89 e5                	mov    %esp,%ebp
 40b:	83 ec 28             	sub    $0x28,%esp
 40e:	8b 45 0c             	mov    0xc(%ebp),%eax
 411:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 414:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 41b:	00 
 41c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 41f:	89 44 24 04          	mov    %eax,0x4(%esp)
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	89 04 24             	mov    %eax,(%esp)
 429:	e8 5a ff ff ff       	call   388 <write>
}
 42e:	c9                   	leave  
 42f:	c3                   	ret    

00000430 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 436:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 43d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 441:	74 17                	je     45a <printint+0x2a>
 443:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 447:	79 11                	jns    45a <printint+0x2a>
    neg = 1;
 449:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 450:	8b 45 0c             	mov    0xc(%ebp),%eax
 453:	f7 d8                	neg    %eax
 455:	89 45 ec             	mov    %eax,-0x14(%ebp)
 458:	eb 06                	jmp    460 <printint+0x30>
  } else {
    x = xx;
 45a:	8b 45 0c             	mov    0xc(%ebp),%eax
 45d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 460:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 467:	8b 4d 10             	mov    0x10(%ebp),%ecx
 46a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46d:	ba 00 00 00 00       	mov    $0x0,%edx
 472:	f7 f1                	div    %ecx
 474:	89 d0                	mov    %edx,%eax
 476:	8a 80 30 0b 00 00    	mov    0xb30(%eax),%al
 47c:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 47f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 482:	01 ca                	add    %ecx,%edx
 484:	88 02                	mov    %al,(%edx)
 486:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 489:	8b 55 10             	mov    0x10(%ebp),%edx
 48c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 48f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 492:	ba 00 00 00 00       	mov    $0x0,%edx
 497:	f7 75 d4             	divl   -0x2c(%ebp)
 49a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 49d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a1:	75 c4                	jne    467 <printint+0x37>
  if(neg)
 4a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a7:	74 2c                	je     4d5 <printint+0xa5>
    buf[i++] = '-';
 4a9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4af:	01 d0                	add    %edx,%eax
 4b1:	c6 00 2d             	movb   $0x2d,(%eax)
 4b4:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4b7:	eb 1c                	jmp    4d5 <printint+0xa5>
    putc(fd, buf[i]);
 4b9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bf:	01 d0                	add    %edx,%eax
 4c1:	8a 00                	mov    (%eax),%al
 4c3:	0f be c0             	movsbl %al,%eax
 4c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ca:	8b 45 08             	mov    0x8(%ebp),%eax
 4cd:	89 04 24             	mov    %eax,(%esp)
 4d0:	e8 33 ff ff ff       	call   408 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4d5:	ff 4d f4             	decl   -0xc(%ebp)
 4d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4dc:	79 db                	jns    4b9 <printint+0x89>
    putc(fd, buf[i]);
}
 4de:	c9                   	leave  
 4df:	c3                   	ret    

000004e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ed:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f0:	83 c0 04             	add    $0x4,%eax
 4f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4fd:	e9 78 01 00 00       	jmp    67a <printf+0x19a>
    c = fmt[i] & 0xff;
 502:	8b 55 0c             	mov    0xc(%ebp),%edx
 505:	8b 45 f0             	mov    -0x10(%ebp),%eax
 508:	01 d0                	add    %edx,%eax
 50a:	8a 00                	mov    (%eax),%al
 50c:	0f be c0             	movsbl %al,%eax
 50f:	25 ff 00 00 00       	and    $0xff,%eax
 514:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 517:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 51b:	75 2c                	jne    549 <printf+0x69>
      if(c == '%'){
 51d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 521:	75 0c                	jne    52f <printf+0x4f>
        state = '%';
 523:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 52a:	e9 48 01 00 00       	jmp    677 <printf+0x197>
      } else {
        putc(fd, c);
 52f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 532:	0f be c0             	movsbl %al,%eax
 535:	89 44 24 04          	mov    %eax,0x4(%esp)
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	89 04 24             	mov    %eax,(%esp)
 53f:	e8 c4 fe ff ff       	call   408 <putc>
 544:	e9 2e 01 00 00       	jmp    677 <printf+0x197>
      }
    } else if(state == '%'){
 549:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 54d:	0f 85 24 01 00 00    	jne    677 <printf+0x197>
      if(c == 'd'){
 553:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 557:	75 2d                	jne    586 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 559:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55c:	8b 00                	mov    (%eax),%eax
 55e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 565:	00 
 566:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 56d:	00 
 56e:	89 44 24 04          	mov    %eax,0x4(%esp)
 572:	8b 45 08             	mov    0x8(%ebp),%eax
 575:	89 04 24             	mov    %eax,(%esp)
 578:	e8 b3 fe ff ff       	call   430 <printint>
        ap++;
 57d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 581:	e9 ea 00 00 00       	jmp    670 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 586:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 58a:	74 06                	je     592 <printf+0xb2>
 58c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 590:	75 2d                	jne    5bf <printf+0xdf>
        printint(fd, *ap, 16, 0);
 592:	8b 45 e8             	mov    -0x18(%ebp),%eax
 595:	8b 00                	mov    (%eax),%eax
 597:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 59e:	00 
 59f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5a6:	00 
 5a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ab:	8b 45 08             	mov    0x8(%ebp),%eax
 5ae:	89 04 24             	mov    %eax,(%esp)
 5b1:	e8 7a fe ff ff       	call   430 <printint>
        ap++;
 5b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ba:	e9 b1 00 00 00       	jmp    670 <printf+0x190>
      } else if(c == 's'){
 5bf:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5c3:	75 43                	jne    608 <printf+0x128>
        s = (char*)*ap;
 5c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c8:	8b 00                	mov    (%eax),%eax
 5ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d5:	75 25                	jne    5fc <printf+0x11c>
          s = "(null)";
 5d7:	c7 45 f4 cd 08 00 00 	movl   $0x8cd,-0xc(%ebp)
        while(*s != 0){
 5de:	eb 1c                	jmp    5fc <printf+0x11c>
          putc(fd, *s);
 5e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e3:	8a 00                	mov    (%eax),%al
 5e5:	0f be c0             	movsbl %al,%eax
 5e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ec:	8b 45 08             	mov    0x8(%ebp),%eax
 5ef:	89 04 24             	mov    %eax,(%esp)
 5f2:	e8 11 fe ff ff       	call   408 <putc>
          s++;
 5f7:	ff 45 f4             	incl   -0xc(%ebp)
 5fa:	eb 01                	jmp    5fd <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5fc:	90                   	nop
 5fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 600:	8a 00                	mov    (%eax),%al
 602:	84 c0                	test   %al,%al
 604:	75 da                	jne    5e0 <printf+0x100>
 606:	eb 68                	jmp    670 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 608:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 60c:	75 1d                	jne    62b <printf+0x14b>
        putc(fd, *ap);
 60e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 611:	8b 00                	mov    (%eax),%eax
 613:	0f be c0             	movsbl %al,%eax
 616:	89 44 24 04          	mov    %eax,0x4(%esp)
 61a:	8b 45 08             	mov    0x8(%ebp),%eax
 61d:	89 04 24             	mov    %eax,(%esp)
 620:	e8 e3 fd ff ff       	call   408 <putc>
        ap++;
 625:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 629:	eb 45                	jmp    670 <printf+0x190>
      } else if(c == '%'){
 62b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 62f:	75 17                	jne    648 <printf+0x168>
        putc(fd, c);
 631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 634:	0f be c0             	movsbl %al,%eax
 637:	89 44 24 04          	mov    %eax,0x4(%esp)
 63b:	8b 45 08             	mov    0x8(%ebp),%eax
 63e:	89 04 24             	mov    %eax,(%esp)
 641:	e8 c2 fd ff ff       	call   408 <putc>
 646:	eb 28                	jmp    670 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 648:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 64f:	00 
 650:	8b 45 08             	mov    0x8(%ebp),%eax
 653:	89 04 24             	mov    %eax,(%esp)
 656:	e8 ad fd ff ff       	call   408 <putc>
        putc(fd, c);
 65b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65e:	0f be c0             	movsbl %al,%eax
 661:	89 44 24 04          	mov    %eax,0x4(%esp)
 665:	8b 45 08             	mov    0x8(%ebp),%eax
 668:	89 04 24             	mov    %eax,(%esp)
 66b:	e8 98 fd ff ff       	call   408 <putc>
      }
      state = 0;
 670:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 677:	ff 45 f0             	incl   -0x10(%ebp)
 67a:	8b 55 0c             	mov    0xc(%ebp),%edx
 67d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 680:	01 d0                	add    %edx,%eax
 682:	8a 00                	mov    (%eax),%al
 684:	84 c0                	test   %al,%al
 686:	0f 85 76 fe ff ff    	jne    502 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 68c:	c9                   	leave  
 68d:	c3                   	ret    
 68e:	66 90                	xchg   %ax,%ax

00000690 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 696:	8b 45 08             	mov    0x8(%ebp),%eax
 699:	83 e8 08             	sub    $0x8,%eax
 69c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69f:	a1 68 0b 00 00       	mov    0xb68,%eax
 6a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a7:	eb 24                	jmp    6cd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b1:	77 12                	ja     6c5 <free+0x35>
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b9:	77 24                	ja     6df <free+0x4f>
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 00                	mov    (%eax),%eax
 6c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c3:	77 1a                	ja     6df <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 00                	mov    (%eax),%eax
 6ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d3:	76 d4                	jbe    6a9 <free+0x19>
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6dd:	76 ca                	jbe    6a9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e2:	8b 40 04             	mov    0x4(%eax),%eax
 6e5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ef:	01 c2                	add    %eax,%edx
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	39 c2                	cmp    %eax,%edx
 6f8:	75 24                	jne    71e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	8b 50 04             	mov    0x4(%eax),%edx
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	8b 00                	mov    (%eax),%eax
 705:	8b 40 04             	mov    0x4(%eax),%eax
 708:	01 c2                	add    %eax,%edx
 70a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 00                	mov    (%eax),%eax
 715:	8b 10                	mov    (%eax),%edx
 717:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71a:	89 10                	mov    %edx,(%eax)
 71c:	eb 0a                	jmp    728 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 10                	mov    (%eax),%edx
 723:	8b 45 f8             	mov    -0x8(%ebp),%eax
 726:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 40 04             	mov    0x4(%eax),%eax
 72e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	01 d0                	add    %edx,%eax
 73a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73d:	75 20                	jne    75f <free+0xcf>
    p->s.size += bp->s.size;
 73f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 742:	8b 50 04             	mov    0x4(%eax),%edx
 745:	8b 45 f8             	mov    -0x8(%ebp),%eax
 748:	8b 40 04             	mov    0x4(%eax),%eax
 74b:	01 c2                	add    %eax,%edx
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	8b 10                	mov    (%eax),%edx
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	89 10                	mov    %edx,(%eax)
 75d:	eb 08                	jmp    767 <free+0xd7>
  } else
    p->s.ptr = bp;
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 55 f8             	mov    -0x8(%ebp),%edx
 765:	89 10                	mov    %edx,(%eax)
  freep = p;
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	a3 68 0b 00 00       	mov    %eax,0xb68
}
 76f:	c9                   	leave  
 770:	c3                   	ret    

00000771 <morecore>:

static Header*
morecore(uint nu)
{
 771:	55                   	push   %ebp
 772:	89 e5                	mov    %esp,%ebp
 774:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 777:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 77e:	77 07                	ja     787 <morecore+0x16>
    nu = 4096;
 780:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 787:	8b 45 08             	mov    0x8(%ebp),%eax
 78a:	c1 e0 03             	shl    $0x3,%eax
 78d:	89 04 24             	mov    %eax,(%esp)
 790:	e8 5b fc ff ff       	call   3f0 <sbrk>
 795:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 798:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 79c:	75 07                	jne    7a5 <morecore+0x34>
    return 0;
 79e:	b8 00 00 00 00       	mov    $0x0,%eax
 7a3:	eb 22                	jmp    7c7 <morecore+0x56>
  hp = (Header*)p;
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	8b 55 08             	mov    0x8(%ebp),%edx
 7b1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b7:	83 c0 08             	add    $0x8,%eax
 7ba:	89 04 24             	mov    %eax,(%esp)
 7bd:	e8 ce fe ff ff       	call   690 <free>
  return freep;
 7c2:	a1 68 0b 00 00       	mov    0xb68,%eax
}
 7c7:	c9                   	leave  
 7c8:	c3                   	ret    

000007c9 <malloc>:

void*
malloc(uint nbytes)
{
 7c9:	55                   	push   %ebp
 7ca:	89 e5                	mov    %esp,%ebp
 7cc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7cf:	8b 45 08             	mov    0x8(%ebp),%eax
 7d2:	83 c0 07             	add    $0x7,%eax
 7d5:	c1 e8 03             	shr    $0x3,%eax
 7d8:	40                   	inc    %eax
 7d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7dc:	a1 68 0b 00 00       	mov    0xb68,%eax
 7e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e8:	75 23                	jne    80d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7ea:	c7 45 f0 60 0b 00 00 	movl   $0xb60,-0x10(%ebp)
 7f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f4:	a3 68 0b 00 00       	mov    %eax,0xb68
 7f9:	a1 68 0b 00 00       	mov    0xb68,%eax
 7fe:	a3 60 0b 00 00       	mov    %eax,0xb60
    base.s.size = 0;
 803:	c7 05 64 0b 00 00 00 	movl   $0x0,0xb64
 80a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 810:	8b 00                	mov    (%eax),%eax
 812:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 815:	8b 45 f4             	mov    -0xc(%ebp),%eax
 818:	8b 40 04             	mov    0x4(%eax),%eax
 81b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 81e:	72 4d                	jb     86d <malloc+0xa4>
      if(p->s.size == nunits)
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	8b 40 04             	mov    0x4(%eax),%eax
 826:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 829:	75 0c                	jne    837 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 82b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82e:	8b 10                	mov    (%eax),%edx
 830:	8b 45 f0             	mov    -0x10(%ebp),%eax
 833:	89 10                	mov    %edx,(%eax)
 835:	eb 26                	jmp    85d <malloc+0x94>
      else {
        p->s.size -= nunits;
 837:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83a:	8b 40 04             	mov    0x4(%eax),%eax
 83d:	89 c2                	mov    %eax,%edx
 83f:	2b 55 ec             	sub    -0x14(%ebp),%edx
 842:	8b 45 f4             	mov    -0xc(%ebp),%eax
 845:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 848:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84b:	8b 40 04             	mov    0x4(%eax),%eax
 84e:	c1 e0 03             	shl    $0x3,%eax
 851:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 854:	8b 45 f4             	mov    -0xc(%ebp),%eax
 857:	8b 55 ec             	mov    -0x14(%ebp),%edx
 85a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 85d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 860:	a3 68 0b 00 00       	mov    %eax,0xb68
      return (void*)(p + 1);
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	83 c0 08             	add    $0x8,%eax
 86b:	eb 38                	jmp    8a5 <malloc+0xdc>
    }
    if(p == freep)
 86d:	a1 68 0b 00 00       	mov    0xb68,%eax
 872:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 875:	75 1b                	jne    892 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 877:	8b 45 ec             	mov    -0x14(%ebp),%eax
 87a:	89 04 24             	mov    %eax,(%esp)
 87d:	e8 ef fe ff ff       	call   771 <morecore>
 882:	89 45 f4             	mov    %eax,-0xc(%ebp)
 885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 889:	75 07                	jne    892 <malloc+0xc9>
        return 0;
 88b:	b8 00 00 00 00       	mov    $0x0,%eax
 890:	eb 13                	jmp    8a5 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	89 45 f0             	mov    %eax,-0x10(%ebp)
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	8b 00                	mov    (%eax),%eax
 89d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8a0:	e9 70 ff ff ff       	jmp    815 <malloc+0x4c>
}
 8a5:	c9                   	leave  
 8a6:	c3                   	ret    
