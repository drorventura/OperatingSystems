
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 62                	jmp    84 <wc+0x84>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 51                	jmp    7c <wc+0x7c>
      c++;
  2b:	ff 45 e8             	incl   -0x18(%ebp)
      if(buf[i] == '\n')
  2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  31:	05 40 0c 00 00       	add    $0xc40,%eax
  36:	8a 00                	mov    (%eax),%al
  38:	3c 0a                	cmp    $0xa,%al
  3a:	75 03                	jne    3f <wc+0x3f>
        l++;
  3c:	ff 45 f0             	incl   -0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  42:	05 40 0c 00 00       	add    $0xc40,%eax
  47:	8a 00                	mov    (%eax),%al
  49:	0f be c0             	movsbl %al,%eax
  4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  50:	c7 04 24 67 09 00 00 	movl   $0x967,(%esp)
  57:	e8 50 02 00 00       	call   2ac <strchr>
  5c:	85 c0                	test   %eax,%eax
  5e:	74 09                	je     69 <wc+0x69>
        inword = 0;
  60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  67:	eb 10                	jmp    79 <wc+0x79>
      else if(!inword){
  69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  6d:	75 0a                	jne    79 <wc+0x79>
        w++;
  6f:	ff 45 ec             	incl   -0x14(%ebp)
        inword = 1;
  72:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  79:	ff 45 f4             	incl   -0xc(%ebp)
  7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  7f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  82:	7c a7                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  84:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8b:	00 
  8c:	c7 44 24 04 40 0c 00 	movl   $0xc40,0x4(%esp)
  93:	00 
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	89 04 24             	mov    %eax,(%esp)
  9a:	e8 99 03 00 00       	call   438 <read>
  9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  a6:	0f 8f 76 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b0:	79 19                	jns    cb <wc+0xcb>
    printf(1, "wc: read error\n");
  b2:	c7 44 24 04 6d 09 00 	movl   $0x96d,0x4(%esp)
  b9:	00 
  ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c1:	e8 da 04 00 00       	call   5a0 <printf>
    exit();
  c6:	e8 55 03 00 00       	call   420 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ce:	89 44 24 14          	mov    %eax,0x14(%esp)
  d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  e7:	c7 44 24 04 7d 09 00 	movl   $0x97d,0x4(%esp)
  ee:	00 
  ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f6:	e8 a5 04 00 00       	call   5a0 <printf>
}
  fb:	c9                   	leave  
  fc:	c3                   	ret    

000000fd <main>:

int
main(int argc, char *argv[])
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	83 e4 f0             	and    $0xfffffff0,%esp
 103:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 106:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 10a:	7f 19                	jg     125 <main+0x28>
    wc(0, "");
 10c:	c7 44 24 04 8a 09 00 	movl   $0x98a,0x4(%esp)
 113:	00 
 114:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11b:	e8 e0 fe ff ff       	call   0 <wc>
    exit();
 120:	e8 fb 02 00 00       	call   420 <exit>
  }

  for(i = 1; i < argc; i++){
 125:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 12c:	00 
 12d:	e9 8e 00 00 00       	jmp    1c0 <main+0xc3>
    if((fd = open(argv[i], 0)) < 0){
 132:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 136:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 13d:	8b 45 0c             	mov    0xc(%ebp),%eax
 140:	01 d0                	add    %edx,%eax
 142:	8b 00                	mov    (%eax),%eax
 144:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 14b:	00 
 14c:	89 04 24             	mov    %eax,(%esp)
 14f:	e8 0c 03 00 00       	call   460 <open>
 154:	89 44 24 18          	mov    %eax,0x18(%esp)
 158:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 15d:	79 2f                	jns    18e <main+0x91>
      printf(1, "cat: cannot open %s\n", argv[i]);
 15f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 163:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	01 d0                	add    %edx,%eax
 16f:	8b 00                	mov    (%eax),%eax
 171:	89 44 24 08          	mov    %eax,0x8(%esp)
 175:	c7 44 24 04 8b 09 00 	movl   $0x98b,0x4(%esp)
 17c:	00 
 17d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 184:	e8 17 04 00 00       	call   5a0 <printf>
      exit();
 189:	e8 92 02 00 00       	call   420 <exit>
    }
    wc(fd, argv[i]);
 18e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 192:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 199:	8b 45 0c             	mov    0xc(%ebp),%eax
 19c:	01 d0                	add    %edx,%eax
 19e:	8b 00                	mov    (%eax),%eax
 1a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a4:	8b 44 24 18          	mov    0x18(%esp),%eax
 1a8:	89 04 24             	mov    %eax,(%esp)
 1ab:	e8 50 fe ff ff       	call   0 <wc>
    close(fd);
 1b0:	8b 44 24 18          	mov    0x18(%esp),%eax
 1b4:	89 04 24             	mov    %eax,(%esp)
 1b7:	e8 8c 02 00 00       	call   448 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1bc:	ff 44 24 1c          	incl   0x1c(%esp)
 1c0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1c4:	3b 45 08             	cmp    0x8(%ebp),%eax
 1c7:	0f 8c 65 ff ff ff    	jl     132 <main+0x35>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1cd:	e8 4e 02 00 00       	call   420 <exit>
 1d2:	66 90                	xchg   %ax,%ax

000001d4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	57                   	push   %edi
 1d8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1dc:	8b 55 10             	mov    0x10(%ebp),%edx
 1df:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e2:	89 cb                	mov    %ecx,%ebx
 1e4:	89 df                	mov    %ebx,%edi
 1e6:	89 d1                	mov    %edx,%ecx
 1e8:	fc                   	cld    
 1e9:	f3 aa                	rep stos %al,%es:(%edi)
 1eb:	89 ca                	mov    %ecx,%edx
 1ed:	89 fb                	mov    %edi,%ebx
 1ef:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1f2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1f5:	5b                   	pop    %ebx
 1f6:	5f                   	pop    %edi
 1f7:	5d                   	pop    %ebp
 1f8:	c3                   	ret    

000001f9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 205:	90                   	nop
 206:	8b 45 0c             	mov    0xc(%ebp),%eax
 209:	8a 10                	mov    (%eax),%dl
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	88 10                	mov    %dl,(%eax)
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	8a 00                	mov    (%eax),%al
 215:	84 c0                	test   %al,%al
 217:	0f 95 c0             	setne  %al
 21a:	ff 45 08             	incl   0x8(%ebp)
 21d:	ff 45 0c             	incl   0xc(%ebp)
 220:	84 c0                	test   %al,%al
 222:	75 e2                	jne    206 <strcpy+0xd>
    ;
  return os;
 224:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 227:	c9                   	leave  
 228:	c3                   	ret    

00000229 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 22c:	eb 06                	jmp    234 <strcmp+0xb>
    p++, q++;
 22e:	ff 45 08             	incl   0x8(%ebp)
 231:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	8a 00                	mov    (%eax),%al
 239:	84 c0                	test   %al,%al
 23b:	74 0e                	je     24b <strcmp+0x22>
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	8a 10                	mov    (%eax),%dl
 242:	8b 45 0c             	mov    0xc(%ebp),%eax
 245:	8a 00                	mov    (%eax),%al
 247:	38 c2                	cmp    %al,%dl
 249:	74 e3                	je     22e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	8a 00                	mov    (%eax),%al
 250:	0f b6 d0             	movzbl %al,%edx
 253:	8b 45 0c             	mov    0xc(%ebp),%eax
 256:	8a 00                	mov    (%eax),%al
 258:	0f b6 c0             	movzbl %al,%eax
 25b:	89 d1                	mov    %edx,%ecx
 25d:	29 c1                	sub    %eax,%ecx
 25f:	89 c8                	mov    %ecx,%eax
}
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    

00000263 <strlen>:

uint
strlen(char *s)
{
 263:	55                   	push   %ebp
 264:	89 e5                	mov    %esp,%ebp
 266:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 270:	eb 03                	jmp    275 <strlen+0x12>
 272:	ff 45 fc             	incl   -0x4(%ebp)
 275:	8b 55 fc             	mov    -0x4(%ebp),%edx
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	01 d0                	add    %edx,%eax
 27d:	8a 00                	mov    (%eax),%al
 27f:	84 c0                	test   %al,%al
 281:	75 ef                	jne    272 <strlen+0xf>
    ;
  return n;
 283:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 286:	c9                   	leave  
 287:	c3                   	ret    

00000288 <memset>:

void*
memset(void *dst, int c, uint n)
{
 288:	55                   	push   %ebp
 289:	89 e5                	mov    %esp,%ebp
 28b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 28e:	8b 45 10             	mov    0x10(%ebp),%eax
 291:	89 44 24 08          	mov    %eax,0x8(%esp)
 295:	8b 45 0c             	mov    0xc(%ebp),%eax
 298:	89 44 24 04          	mov    %eax,0x4(%esp)
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	89 04 24             	mov    %eax,(%esp)
 2a2:	e8 2d ff ff ff       	call   1d4 <stosb>
  return dst;
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2aa:	c9                   	leave  
 2ab:	c3                   	ret    

000002ac <strchr>:

char*
strchr(const char *s, char c)
{
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
 2af:	83 ec 04             	sub    $0x4,%esp
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2b8:	eb 12                	jmp    2cc <strchr+0x20>
    if(*s == c)
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	8a 00                	mov    (%eax),%al
 2bf:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2c2:	75 05                	jne    2c9 <strchr+0x1d>
      return (char*)s;
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	eb 11                	jmp    2da <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2c9:	ff 45 08             	incl   0x8(%ebp)
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	8a 00                	mov    (%eax),%al
 2d1:	84 c0                	test   %al,%al
 2d3:	75 e5                	jne    2ba <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2da:	c9                   	leave  
 2db:	c3                   	ret    

000002dc <gets>:

char*
gets(char *buf, int max)
{
 2dc:	55                   	push   %ebp
 2dd:	89 e5                	mov    %esp,%ebp
 2df:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2e9:	eb 42                	jmp    32d <gets+0x51>
    cc = read(0, &c, 1);
 2eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2f2:	00 
 2f3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 2fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 301:	e8 32 01 00 00       	call   438 <read>
 306:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 309:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 30d:	7e 29                	jle    338 <gets+0x5c>
      break;
    buf[i++] = c;
 30f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	01 c2                	add    %eax,%edx
 317:	8a 45 ef             	mov    -0x11(%ebp),%al
 31a:	88 02                	mov    %al,(%edx)
 31c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 31f:	8a 45 ef             	mov    -0x11(%ebp),%al
 322:	3c 0a                	cmp    $0xa,%al
 324:	74 13                	je     339 <gets+0x5d>
 326:	8a 45 ef             	mov    -0x11(%ebp),%al
 329:	3c 0d                	cmp    $0xd,%al
 32b:	74 0c                	je     339 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 330:	40                   	inc    %eax
 331:	3b 45 0c             	cmp    0xc(%ebp),%eax
 334:	7c b5                	jl     2eb <gets+0xf>
 336:	eb 01                	jmp    339 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 338:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 339:	8b 55 f4             	mov    -0xc(%ebp),%edx
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	01 d0                	add    %edx,%eax
 341:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 344:	8b 45 08             	mov    0x8(%ebp),%eax
}
 347:	c9                   	leave  
 348:	c3                   	ret    

00000349 <stat>:

int
stat(char *n, struct stat *st)
{
 349:	55                   	push   %ebp
 34a:	89 e5                	mov    %esp,%ebp
 34c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 34f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 356:	00 
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	89 04 24             	mov    %eax,(%esp)
 35d:	e8 fe 00 00 00       	call   460 <open>
 362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 369:	79 07                	jns    372 <stat+0x29>
    return -1;
 36b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 370:	eb 23                	jmp    395 <stat+0x4c>
  r = fstat(fd, st);
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	89 44 24 04          	mov    %eax,0x4(%esp)
 379:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37c:	89 04 24             	mov    %eax,(%esp)
 37f:	e8 f4 00 00 00       	call   478 <fstat>
 384:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 387:	8b 45 f4             	mov    -0xc(%ebp),%eax
 38a:	89 04 24             	mov    %eax,(%esp)
 38d:	e8 b6 00 00 00       	call   448 <close>
  return r;
 392:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 395:	c9                   	leave  
 396:	c3                   	ret    

00000397 <atoi>:

int
atoi(const char *s)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 39d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3a4:	eb 21                	jmp    3c7 <atoi+0x30>
    n = n*10 + *s++ - '0';
 3a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a9:	89 d0                	mov    %edx,%eax
 3ab:	c1 e0 02             	shl    $0x2,%eax
 3ae:	01 d0                	add    %edx,%eax
 3b0:	d1 e0                	shl    %eax
 3b2:	89 c2                	mov    %eax,%edx
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	8a 00                	mov    (%eax),%al
 3b9:	0f be c0             	movsbl %al,%eax
 3bc:	01 d0                	add    %edx,%eax
 3be:	83 e8 30             	sub    $0x30,%eax
 3c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3c4:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	8a 00                	mov    (%eax),%al
 3cc:	3c 2f                	cmp    $0x2f,%al
 3ce:	7e 09                	jle    3d9 <atoi+0x42>
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	8a 00                	mov    (%eax),%al
 3d5:	3c 39                	cmp    $0x39,%al
 3d7:	7e cd                	jle    3a6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3dc:	c9                   	leave  
 3dd:	c3                   	ret    

000003de <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3de:	55                   	push   %ebp
 3df:	89 e5                	mov    %esp,%ebp
 3e1:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3e4:	8b 45 08             	mov    0x8(%ebp),%eax
 3e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3f0:	eb 10                	jmp    402 <memmove+0x24>
    *dst++ = *src++;
 3f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3f5:	8a 10                	mov    (%eax),%dl
 3f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3fa:	88 10                	mov    %dl,(%eax)
 3fc:	ff 45 fc             	incl   -0x4(%ebp)
 3ff:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 402:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 406:	0f 9f c0             	setg   %al
 409:	ff 4d 10             	decl   0x10(%ebp)
 40c:	84 c0                	test   %al,%al
 40e:	75 e2                	jne    3f2 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 410:	8b 45 08             	mov    0x8(%ebp),%eax
}
 413:	c9                   	leave  
 414:	c3                   	ret    
 415:	66 90                	xchg   %ax,%ax
 417:	90                   	nop

00000418 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 418:	b8 01 00 00 00       	mov    $0x1,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <exit>:
SYSCALL(exit)
 420:	b8 02 00 00 00       	mov    $0x2,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <wait>:
SYSCALL(wait)
 428:	b8 03 00 00 00       	mov    $0x3,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <pipe>:
SYSCALL(pipe)
 430:	b8 04 00 00 00       	mov    $0x4,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <read>:
SYSCALL(read)
 438:	b8 05 00 00 00       	mov    $0x5,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <write>:
SYSCALL(write)
 440:	b8 10 00 00 00       	mov    $0x10,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <close>:
SYSCALL(close)
 448:	b8 15 00 00 00       	mov    $0x15,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <kill>:
SYSCALL(kill)
 450:	b8 06 00 00 00       	mov    $0x6,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <exec>:
SYSCALL(exec)
 458:	b8 07 00 00 00       	mov    $0x7,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <open>:
SYSCALL(open)
 460:	b8 0f 00 00 00       	mov    $0xf,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <mknod>:
SYSCALL(mknod)
 468:	b8 11 00 00 00       	mov    $0x11,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <unlink>:
SYSCALL(unlink)
 470:	b8 12 00 00 00       	mov    $0x12,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <fstat>:
SYSCALL(fstat)
 478:	b8 08 00 00 00       	mov    $0x8,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <link>:
SYSCALL(link)
 480:	b8 13 00 00 00       	mov    $0x13,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <mkdir>:
SYSCALL(mkdir)
 488:	b8 14 00 00 00       	mov    $0x14,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <chdir>:
SYSCALL(chdir)
 490:	b8 09 00 00 00       	mov    $0x9,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <dup>:
SYSCALL(dup)
 498:	b8 0a 00 00 00       	mov    $0xa,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <getpid>:
SYSCALL(getpid)
 4a0:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <sbrk>:
SYSCALL(sbrk)
 4a8:	b8 0c 00 00 00       	mov    $0xc,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <sleep>:
SYSCALL(sleep)
 4b0:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <uptime>:
SYSCALL(uptime)
 4b8:	b8 0e 00 00 00       	mov    $0xe,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <addpath>:
SYSCALL(addpath)
 4c0:	b8 16 00 00 00       	mov    $0x16,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4c8:	55                   	push   %ebp
 4c9:	89 e5                	mov    %esp,%ebp
 4cb:	83 ec 28             	sub    $0x28,%esp
 4ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4db:	00 
 4dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4df:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	89 04 24             	mov    %eax,(%esp)
 4e9:	e8 52 ff ff ff       	call   440 <write>
}
 4ee:	c9                   	leave  
 4ef:	c3                   	ret    

000004f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4fd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 501:	74 17                	je     51a <printint+0x2a>
 503:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 507:	79 11                	jns    51a <printint+0x2a>
    neg = 1;
 509:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 510:	8b 45 0c             	mov    0xc(%ebp),%eax
 513:	f7 d8                	neg    %eax
 515:	89 45 ec             	mov    %eax,-0x14(%ebp)
 518:	eb 06                	jmp    520 <printint+0x30>
  } else {
    x = xx;
 51a:	8b 45 0c             	mov    0xc(%ebp),%eax
 51d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 527:	8b 4d 10             	mov    0x10(%ebp),%ecx
 52a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52d:	ba 00 00 00 00       	mov    $0x0,%edx
 532:	f7 f1                	div    %ecx
 534:	89 d0                	mov    %edx,%eax
 536:	8a 80 04 0c 00 00    	mov    0xc04(%eax),%al
 53c:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 53f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 542:	01 ca                	add    %ecx,%edx
 544:	88 02                	mov    %al,(%edx)
 546:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 549:	8b 55 10             	mov    0x10(%ebp),%edx
 54c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 54f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 552:	ba 00 00 00 00       	mov    $0x0,%edx
 557:	f7 75 d4             	divl   -0x2c(%ebp)
 55a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 55d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 561:	75 c4                	jne    527 <printint+0x37>
  if(neg)
 563:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 567:	74 2c                	je     595 <printint+0xa5>
    buf[i++] = '-';
 569:	8d 55 dc             	lea    -0x24(%ebp),%edx
 56c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56f:	01 d0                	add    %edx,%eax
 571:	c6 00 2d             	movb   $0x2d,(%eax)
 574:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 577:	eb 1c                	jmp    595 <printint+0xa5>
    putc(fd, buf[i]);
 579:	8d 55 dc             	lea    -0x24(%ebp),%edx
 57c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57f:	01 d0                	add    %edx,%eax
 581:	8a 00                	mov    (%eax),%al
 583:	0f be c0             	movsbl %al,%eax
 586:	89 44 24 04          	mov    %eax,0x4(%esp)
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	89 04 24             	mov    %eax,(%esp)
 590:	e8 33 ff ff ff       	call   4c8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 595:	ff 4d f4             	decl   -0xc(%ebp)
 598:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59c:	79 db                	jns    579 <printint+0x89>
    putc(fd, buf[i]);
}
 59e:	c9                   	leave  
 59f:	c3                   	ret    

000005a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ad:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b0:	83 c0 04             	add    $0x4,%eax
 5b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5bd:	e9 78 01 00 00       	jmp    73a <printf+0x19a>
    c = fmt[i] & 0xff;
 5c2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c8:	01 d0                	add    %edx,%eax
 5ca:	8a 00                	mov    (%eax),%al
 5cc:	0f be c0             	movsbl %al,%eax
 5cf:	25 ff 00 00 00       	and    $0xff,%eax
 5d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5db:	75 2c                	jne    609 <printf+0x69>
      if(c == '%'){
 5dd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e1:	75 0c                	jne    5ef <printf+0x4f>
        state = '%';
 5e3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ea:	e9 48 01 00 00       	jmp    737 <printf+0x197>
      } else {
        putc(fd, c);
 5ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f2:	0f be c0             	movsbl %al,%eax
 5f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f9:	8b 45 08             	mov    0x8(%ebp),%eax
 5fc:	89 04 24             	mov    %eax,(%esp)
 5ff:	e8 c4 fe ff ff       	call   4c8 <putc>
 604:	e9 2e 01 00 00       	jmp    737 <printf+0x197>
      }
    } else if(state == '%'){
 609:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 60d:	0f 85 24 01 00 00    	jne    737 <printf+0x197>
      if(c == 'd'){
 613:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 617:	75 2d                	jne    646 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 619:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61c:	8b 00                	mov    (%eax),%eax
 61e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 625:	00 
 626:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 62d:	00 
 62e:	89 44 24 04          	mov    %eax,0x4(%esp)
 632:	8b 45 08             	mov    0x8(%ebp),%eax
 635:	89 04 24             	mov    %eax,(%esp)
 638:	e8 b3 fe ff ff       	call   4f0 <printint>
        ap++;
 63d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 641:	e9 ea 00 00 00       	jmp    730 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 646:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 64a:	74 06                	je     652 <printf+0xb2>
 64c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 650:	75 2d                	jne    67f <printf+0xdf>
        printint(fd, *ap, 16, 0);
 652:	8b 45 e8             	mov    -0x18(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 65e:	00 
 65f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 666:	00 
 667:	89 44 24 04          	mov    %eax,0x4(%esp)
 66b:	8b 45 08             	mov    0x8(%ebp),%eax
 66e:	89 04 24             	mov    %eax,(%esp)
 671:	e8 7a fe ff ff       	call   4f0 <printint>
        ap++;
 676:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67a:	e9 b1 00 00 00       	jmp    730 <printf+0x190>
      } else if(c == 's'){
 67f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 683:	75 43                	jne    6c8 <printf+0x128>
        s = (char*)*ap;
 685:	8b 45 e8             	mov    -0x18(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 68d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 691:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 695:	75 25                	jne    6bc <printf+0x11c>
          s = "(null)";
 697:	c7 45 f4 a0 09 00 00 	movl   $0x9a0,-0xc(%ebp)
        while(*s != 0){
 69e:	eb 1c                	jmp    6bc <printf+0x11c>
          putc(fd, *s);
 6a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a3:	8a 00                	mov    (%eax),%al
 6a5:	0f be c0             	movsbl %al,%eax
 6a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
 6af:	89 04 24             	mov    %eax,(%esp)
 6b2:	e8 11 fe ff ff       	call   4c8 <putc>
          s++;
 6b7:	ff 45 f4             	incl   -0xc(%ebp)
 6ba:	eb 01                	jmp    6bd <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6bc:	90                   	nop
 6bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c0:	8a 00                	mov    (%eax),%al
 6c2:	84 c0                	test   %al,%al
 6c4:	75 da                	jne    6a0 <printf+0x100>
 6c6:	eb 68                	jmp    730 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6c8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6cc:	75 1d                	jne    6eb <printf+0x14b>
        putc(fd, *ap);
 6ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d1:	8b 00                	mov    (%eax),%eax
 6d3:	0f be c0             	movsbl %al,%eax
 6d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6da:	8b 45 08             	mov    0x8(%ebp),%eax
 6dd:	89 04 24             	mov    %eax,(%esp)
 6e0:	e8 e3 fd ff ff       	call   4c8 <putc>
        ap++;
 6e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e9:	eb 45                	jmp    730 <printf+0x190>
      } else if(c == '%'){
 6eb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ef:	75 17                	jne    708 <printf+0x168>
        putc(fd, c);
 6f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f4:	0f be c0             	movsbl %al,%eax
 6f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6fb:	8b 45 08             	mov    0x8(%ebp),%eax
 6fe:	89 04 24             	mov    %eax,(%esp)
 701:	e8 c2 fd ff ff       	call   4c8 <putc>
 706:	eb 28                	jmp    730 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 708:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 70f:	00 
 710:	8b 45 08             	mov    0x8(%ebp),%eax
 713:	89 04 24             	mov    %eax,(%esp)
 716:	e8 ad fd ff ff       	call   4c8 <putc>
        putc(fd, c);
 71b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71e:	0f be c0             	movsbl %al,%eax
 721:	89 44 24 04          	mov    %eax,0x4(%esp)
 725:	8b 45 08             	mov    0x8(%ebp),%eax
 728:	89 04 24             	mov    %eax,(%esp)
 72b:	e8 98 fd ff ff       	call   4c8 <putc>
      }
      state = 0;
 730:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 737:	ff 45 f0             	incl   -0x10(%ebp)
 73a:	8b 55 0c             	mov    0xc(%ebp),%edx
 73d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 740:	01 d0                	add    %edx,%eax
 742:	8a 00                	mov    (%eax),%al
 744:	84 c0                	test   %al,%al
 746:	0f 85 76 fe ff ff    	jne    5c2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 74c:	c9                   	leave  
 74d:	c3                   	ret    
 74e:	66 90                	xchg   %ax,%ax

00000750 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 756:	8b 45 08             	mov    0x8(%ebp),%eax
 759:	83 e8 08             	sub    $0x8,%eax
 75c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75f:	a1 28 0c 00 00       	mov    0xc28,%eax
 764:	89 45 fc             	mov    %eax,-0x4(%ebp)
 767:	eb 24                	jmp    78d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 00                	mov    (%eax),%eax
 76e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 771:	77 12                	ja     785 <free+0x35>
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 779:	77 24                	ja     79f <free+0x4f>
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 783:	77 1a                	ja     79f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 78d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 790:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 793:	76 d4                	jbe    769 <free+0x19>
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	8b 00                	mov    (%eax),%eax
 79a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79d:	76 ca                	jbe    769 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 79f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7af:	01 c2                	add    %eax,%edx
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 00                	mov    (%eax),%eax
 7b6:	39 c2                	cmp    %eax,%edx
 7b8:	75 24                	jne    7de <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bd:	8b 50 04             	mov    0x4(%eax),%edx
 7c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c3:	8b 00                	mov    (%eax),%eax
 7c5:	8b 40 04             	mov    0x4(%eax),%eax
 7c8:	01 c2                	add    %eax,%edx
 7ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d3:	8b 00                	mov    (%eax),%eax
 7d5:	8b 10                	mov    (%eax),%edx
 7d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7da:	89 10                	mov    %edx,(%eax)
 7dc:	eb 0a                	jmp    7e8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e1:	8b 10                	mov    (%eax),%edx
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	8b 40 04             	mov    0x4(%eax),%eax
 7ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f8:	01 d0                	add    %edx,%eax
 7fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7fd:	75 20                	jne    81f <free+0xcf>
    p->s.size += bp->s.size;
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	8b 50 04             	mov    0x4(%eax),%edx
 805:	8b 45 f8             	mov    -0x8(%ebp),%eax
 808:	8b 40 04             	mov    0x4(%eax),%eax
 80b:	01 c2                	add    %eax,%edx
 80d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 810:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 813:	8b 45 f8             	mov    -0x8(%ebp),%eax
 816:	8b 10                	mov    (%eax),%edx
 818:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81b:	89 10                	mov    %edx,(%eax)
 81d:	eb 08                	jmp    827 <free+0xd7>
  } else
    p->s.ptr = bp;
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	8b 55 f8             	mov    -0x8(%ebp),%edx
 825:	89 10                	mov    %edx,(%eax)
  freep = p;
 827:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82a:	a3 28 0c 00 00       	mov    %eax,0xc28
}
 82f:	c9                   	leave  
 830:	c3                   	ret    

00000831 <morecore>:

static Header*
morecore(uint nu)
{
 831:	55                   	push   %ebp
 832:	89 e5                	mov    %esp,%ebp
 834:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 837:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 83e:	77 07                	ja     847 <morecore+0x16>
    nu = 4096;
 840:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 847:	8b 45 08             	mov    0x8(%ebp),%eax
 84a:	c1 e0 03             	shl    $0x3,%eax
 84d:	89 04 24             	mov    %eax,(%esp)
 850:	e8 53 fc ff ff       	call   4a8 <sbrk>
 855:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 858:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 85c:	75 07                	jne    865 <morecore+0x34>
    return 0;
 85e:	b8 00 00 00 00       	mov    $0x0,%eax
 863:	eb 22                	jmp    887 <morecore+0x56>
  hp = (Header*)p;
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 86b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86e:	8b 55 08             	mov    0x8(%ebp),%edx
 871:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 874:	8b 45 f0             	mov    -0x10(%ebp),%eax
 877:	83 c0 08             	add    $0x8,%eax
 87a:	89 04 24             	mov    %eax,(%esp)
 87d:	e8 ce fe ff ff       	call   750 <free>
  return freep;
 882:	a1 28 0c 00 00       	mov    0xc28,%eax
}
 887:	c9                   	leave  
 888:	c3                   	ret    

00000889 <malloc>:

void*
malloc(uint nbytes)
{
 889:	55                   	push   %ebp
 88a:	89 e5                	mov    %esp,%ebp
 88c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88f:	8b 45 08             	mov    0x8(%ebp),%eax
 892:	83 c0 07             	add    $0x7,%eax
 895:	c1 e8 03             	shr    $0x3,%eax
 898:	40                   	inc    %eax
 899:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 89c:	a1 28 0c 00 00       	mov    0xc28,%eax
 8a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8a8:	75 23                	jne    8cd <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 8aa:	c7 45 f0 20 0c 00 00 	movl   $0xc20,-0x10(%ebp)
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	a3 28 0c 00 00       	mov    %eax,0xc28
 8b9:	a1 28 0c 00 00       	mov    0xc28,%eax
 8be:	a3 20 0c 00 00       	mov    %eax,0xc20
    base.s.size = 0;
 8c3:	c7 05 24 0c 00 00 00 	movl   $0x0,0xc24
 8ca:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d0:	8b 00                	mov    (%eax),%eax
 8d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	8b 40 04             	mov    0x4(%eax),%eax
 8db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8de:	72 4d                	jb     92d <malloc+0xa4>
      if(p->s.size == nunits)
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	8b 40 04             	mov    0x4(%eax),%eax
 8e6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e9:	75 0c                	jne    8f7 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 8eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ee:	8b 10                	mov    (%eax),%edx
 8f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f3:	89 10                	mov    %edx,(%eax)
 8f5:	eb 26                	jmp    91d <malloc+0x94>
      else {
        p->s.size -= nunits;
 8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fa:	8b 40 04             	mov    0x4(%eax),%eax
 8fd:	89 c2                	mov    %eax,%edx
 8ff:	2b 55 ec             	sub    -0x14(%ebp),%edx
 902:	8b 45 f4             	mov    -0xc(%ebp),%eax
 905:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 908:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90b:	8b 40 04             	mov    0x4(%eax),%eax
 90e:	c1 e0 03             	shl    $0x3,%eax
 911:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	8b 55 ec             	mov    -0x14(%ebp),%edx
 91a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 91d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 920:	a3 28 0c 00 00       	mov    %eax,0xc28
      return (void*)(p + 1);
 925:	8b 45 f4             	mov    -0xc(%ebp),%eax
 928:	83 c0 08             	add    $0x8,%eax
 92b:	eb 38                	jmp    965 <malloc+0xdc>
    }
    if(p == freep)
 92d:	a1 28 0c 00 00       	mov    0xc28,%eax
 932:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 935:	75 1b                	jne    952 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 937:	8b 45 ec             	mov    -0x14(%ebp),%eax
 93a:	89 04 24             	mov    %eax,(%esp)
 93d:	e8 ef fe ff ff       	call   831 <morecore>
 942:	89 45 f4             	mov    %eax,-0xc(%ebp)
 945:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 949:	75 07                	jne    952 <malloc+0xc9>
        return 0;
 94b:	b8 00 00 00 00       	mov    $0x0,%eax
 950:	eb 13                	jmp    965 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 952:	8b 45 f4             	mov    -0xc(%ebp),%eax
 955:	89 45 f0             	mov    %eax,-0x10(%ebp)
 958:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95b:	8b 00                	mov    (%eax),%eax
 95d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 960:	e9 70 ff ff ff       	jmp    8d5 <malloc+0x4c>
}
 965:	c9                   	leave  
 966:	c3                   	ret    
