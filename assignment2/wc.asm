
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
  31:	05 20 0d 00 00       	add    $0xd20,%eax
  36:	8a 00                	mov    (%eax),%al
  38:	3c 0a                	cmp    $0xa,%al
  3a:	75 03                	jne    3f <wc+0x3f>
        l++;
  3c:	ff 45 f0             	incl   -0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  42:	05 20 0d 00 00       	add    $0xd20,%eax
  47:	8a 00                	mov    (%eax),%al
  49:	0f be c0             	movsbl %al,%eax
  4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  50:	c7 04 24 2b 0a 00 00 	movl   $0xa2b,(%esp)
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
  8c:	c7 44 24 04 20 0d 00 	movl   $0xd20,0x4(%esp)
  93:	00 
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	89 04 24             	mov    %eax,(%esp)
  9a:	e8 55 04 00 00       	call   4f4 <read>
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
  b2:	c7 44 24 04 31 0a 00 	movl   $0xa31,0x4(%esp)
  b9:	00 
  ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c1:	e8 9e 05 00 00       	call   664 <printf>
    exit();
  c6:	e8 11 04 00 00       	call   4dc <exit>
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
  e7:	c7 44 24 04 41 0a 00 	movl   $0xa41,0x4(%esp)
  ee:	00 
  ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f6:	e8 69 05 00 00       	call   664 <printf>
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
 10c:	c7 44 24 04 4e 0a 00 	movl   $0xa4e,0x4(%esp)
 113:	00 
 114:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11b:	e8 e0 fe ff ff       	call   0 <wc>
    exit();
 120:	e8 b7 03 00 00       	call   4dc <exit>
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
 14f:	e8 c8 03 00 00       	call   51c <open>
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
 175:	c7 44 24 04 4f 0a 00 	movl   $0xa4f,0x4(%esp)
 17c:	00 
 17d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 184:	e8 db 04 00 00       	call   664 <printf>
      exit();
 189:	e8 4e 03 00 00       	call   4dc <exit>
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
 1b7:	e8 48 03 00 00       	call   504 <close>
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
 1cd:	e8 0a 03 00 00       	call   4dc <exit>
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

#define NULL   0

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
 301:	e8 ee 01 00 00       	call   4f4 <read>
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
 35d:	e8 ba 01 00 00       	call   51c <open>
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
 37f:	e8 b0 01 00 00       	call   534 <fstat>
 384:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 387:	8b 45 f4             	mov    -0xc(%ebp),%eax
 38a:	89 04 24             	mov    %eax,(%esp)
 38d:	e8 72 01 00 00       	call   504 <close>
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

00000415 <strtok>:

char*
strtok(char *teststr, char ch)
{
 415:	55                   	push   %ebp
 416:	89 e5                	mov    %esp,%ebp
 418:	83 ec 24             	sub    $0x24,%esp
 41b:	8b 45 0c             	mov    0xc(%ebp),%eax
 41e:	88 45 dc             	mov    %al,-0x24(%ebp)
    char *dummystr = NULL;
 421:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    char *start = NULL;
 428:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    char *end = NULL;
 42f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char nullch = '\0';
 436:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    char *address_of_null = &nullch;
 43a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 43d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    static char *nexttok;

    if(teststr != NULL)
 440:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 444:	74 08                	je     44e <strtok+0x39>
    {
        dummystr = teststr;
 446:	8b 45 08             	mov    0x8(%ebp),%eax
 449:	89 45 fc             	mov    %eax,-0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 44c:	eb 75                	jmp    4c3 <strtok+0xae>
    {
        dummystr = teststr;
    }
    else
    {
        if(*nexttok == '\0')
 44e:	a1 00 0d 00 00       	mov    0xd00,%eax
 453:	8a 00                	mov    (%eax),%al
 455:	84 c0                	test   %al,%al
 457:	75 07                	jne    460 <strtok+0x4b>
            return NULL;
 459:	b8 00 00 00 00       	mov    $0x0,%eax
 45e:	eb 6f                	jmp    4cf <strtok+0xba>
        dummystr = nexttok;
 460:	a1 00 0d 00 00       	mov    0xd00,%eax
 465:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }


    while(dummystr != NULL)
 468:	eb 59                	jmp    4c3 <strtok+0xae>
    {
        //empty string
        if(*dummystr == '\0')
 46a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 46d:	8a 00                	mov    (%eax),%al
 46f:	84 c0                	test   %al,%al
 471:	74 58                	je     4cb <strtok+0xb6>
            break;
        if(*dummystr != ch)
 473:	8b 45 fc             	mov    -0x4(%ebp),%eax
 476:	8a 00                	mov    (%eax),%al
 478:	3a 45 dc             	cmp    -0x24(%ebp),%al
 47b:	74 22                	je     49f <strtok+0x8a>
        {
            if(!start)
 47d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 481:	75 06                	jne    489 <strtok+0x74>
                start = dummystr;
 483:	8b 45 fc             	mov    -0x4(%ebp),%eax
 486:	89 45 f8             	mov    %eax,-0x8(%ebp)

            dummystr++;
 489:	ff 45 fc             	incl   -0x4(%ebp)

            // handle the case where the delimiter is not at the end of the string.
            if(*dummystr == '\0')
 48c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 48f:	8a 00                	mov    (%eax),%al
 491:	84 c0                	test   %al,%al
 493:	75 2e                	jne    4c3 <strtok+0xae>
            {
                nexttok = dummystr;
 495:	8b 45 fc             	mov    -0x4(%ebp),%eax
 498:	a3 00 0d 00 00       	mov    %eax,0xd00
                break;
 49d:	eb 2d                	jmp    4cc <strtok+0xb7>
            }
        }
        else
        {
            if(start)
 49f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 4a3:	74 1b                	je     4c0 <strtok+0xab>
            {
                end = dummystr;
 4a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
                nexttok = dummystr+1;
 4ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4ae:	40                   	inc    %eax
 4af:	a3 00 0d 00 00       	mov    %eax,0xd00
                *end = *address_of_null;
 4b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b7:	8a 10                	mov    (%eax),%dl
 4b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bc:	88 10                	mov    %dl,(%eax)
                break;
 4be:	eb 0c                	jmp    4cc <strtok+0xb7>
            }
            else
            {
                dummystr++;
 4c0:	ff 45 fc             	incl   -0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 4c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
 4c7:	75 a1                	jne    46a <strtok+0x55>
 4c9:	eb 01                	jmp    4cc <strtok+0xb7>
    {
        //empty string
        if(*dummystr == '\0')
            break;
 4cb:	90                   	nop
                dummystr++;
            }
        }
    }

    return start;
 4cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 4cf:	c9                   	leave  
 4d0:	c3                   	ret    
 4d1:	66 90                	xchg   %ax,%ax
 4d3:	90                   	nop

000004d4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4d4:	b8 01 00 00 00       	mov    $0x1,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <exit>:
SYSCALL(exit)
 4dc:	b8 02 00 00 00       	mov    $0x2,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <wait>:
SYSCALL(wait)
 4e4:	b8 03 00 00 00       	mov    $0x3,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <pipe>:
SYSCALL(pipe)
 4ec:	b8 04 00 00 00       	mov    $0x4,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <read>:
SYSCALL(read)
 4f4:	b8 05 00 00 00       	mov    $0x5,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <write>:
SYSCALL(write)
 4fc:	b8 10 00 00 00       	mov    $0x10,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <close>:
SYSCALL(close)
 504:	b8 15 00 00 00       	mov    $0x15,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <kill>:
SYSCALL(kill)
 50c:	b8 06 00 00 00       	mov    $0x6,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <exec>:
SYSCALL(exec)
 514:	b8 07 00 00 00       	mov    $0x7,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <open>:
SYSCALL(open)
 51c:	b8 0f 00 00 00       	mov    $0xf,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <mknod>:
SYSCALL(mknod)
 524:	b8 11 00 00 00       	mov    $0x11,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <unlink>:
SYSCALL(unlink)
 52c:	b8 12 00 00 00       	mov    $0x12,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <fstat>:
SYSCALL(fstat)
 534:	b8 08 00 00 00       	mov    $0x8,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <link>:
SYSCALL(link)
 53c:	b8 13 00 00 00       	mov    $0x13,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <mkdir>:
SYSCALL(mkdir)
 544:	b8 14 00 00 00       	mov    $0x14,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <chdir>:
SYSCALL(chdir)
 54c:	b8 09 00 00 00       	mov    $0x9,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <dup>:
SYSCALL(dup)
 554:	b8 0a 00 00 00       	mov    $0xa,%eax
 559:	cd 40                	int    $0x40
 55b:	c3                   	ret    

0000055c <getpid>:
SYSCALL(getpid)
 55c:	b8 0b 00 00 00       	mov    $0xb,%eax
 561:	cd 40                	int    $0x40
 563:	c3                   	ret    

00000564 <sbrk>:
SYSCALL(sbrk)
 564:	b8 0c 00 00 00       	mov    $0xc,%eax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret    

0000056c <sleep>:
SYSCALL(sleep)
 56c:	b8 0d 00 00 00       	mov    $0xd,%eax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret    

00000574 <uptime>:
SYSCALL(uptime)
 574:	b8 0e 00 00 00       	mov    $0xe,%eax
 579:	cd 40                	int    $0x40
 57b:	c3                   	ret    

0000057c <add_path>:
SYSCALL(add_path)
 57c:	b8 16 00 00 00       	mov    $0x16,%eax
 581:	cd 40                	int    $0x40
 583:	c3                   	ret    

00000584 <wait2>:
SYSCALL(wait2)
 584:	b8 17 00 00 00       	mov    $0x17,%eax
 589:	cd 40                	int    $0x40
 58b:	c3                   	ret    

0000058c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 58c:	55                   	push   %ebp
 58d:	89 e5                	mov    %esp,%ebp
 58f:	83 ec 28             	sub    $0x28,%esp
 592:	8b 45 0c             	mov    0xc(%ebp),%eax
 595:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 598:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 59f:	00 
 5a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a7:	8b 45 08             	mov    0x8(%ebp),%eax
 5aa:	89 04 24             	mov    %eax,(%esp)
 5ad:	e8 4a ff ff ff       	call   4fc <write>
}
 5b2:	c9                   	leave  
 5b3:	c3                   	ret    

000005b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5c1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5c5:	74 17                	je     5de <printint+0x2a>
 5c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5cb:	79 11                	jns    5de <printint+0x2a>
    neg = 1;
 5cd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d7:	f7 d8                	neg    %eax
 5d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5dc:	eb 06                	jmp    5e4 <printint+0x30>
  } else {
    x = xx;
 5de:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5f1:	ba 00 00 00 00       	mov    $0x0,%edx
 5f6:	f7 f1                	div    %ecx
 5f8:	89 d0                	mov    %edx,%eax
 5fa:	8a 80 e8 0c 00 00    	mov    0xce8(%eax),%al
 600:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 603:	8b 55 f4             	mov    -0xc(%ebp),%edx
 606:	01 ca                	add    %ecx,%edx
 608:	88 02                	mov    %al,(%edx)
 60a:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 60d:	8b 55 10             	mov    0x10(%ebp),%edx
 610:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 613:	8b 45 ec             	mov    -0x14(%ebp),%eax
 616:	ba 00 00 00 00       	mov    $0x0,%edx
 61b:	f7 75 d4             	divl   -0x2c(%ebp)
 61e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 621:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 625:	75 c4                	jne    5eb <printint+0x37>
  if(neg)
 627:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 62b:	74 2c                	je     659 <printint+0xa5>
    buf[i++] = '-';
 62d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 630:	8b 45 f4             	mov    -0xc(%ebp),%eax
 633:	01 d0                	add    %edx,%eax
 635:	c6 00 2d             	movb   $0x2d,(%eax)
 638:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 63b:	eb 1c                	jmp    659 <printint+0xa5>
    putc(fd, buf[i]);
 63d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 640:	8b 45 f4             	mov    -0xc(%ebp),%eax
 643:	01 d0                	add    %edx,%eax
 645:	8a 00                	mov    (%eax),%al
 647:	0f be c0             	movsbl %al,%eax
 64a:	89 44 24 04          	mov    %eax,0x4(%esp)
 64e:	8b 45 08             	mov    0x8(%ebp),%eax
 651:	89 04 24             	mov    %eax,(%esp)
 654:	e8 33 ff ff ff       	call   58c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 659:	ff 4d f4             	decl   -0xc(%ebp)
 65c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 660:	79 db                	jns    63d <printint+0x89>
    putc(fd, buf[i]);
}
 662:	c9                   	leave  
 663:	c3                   	ret    

00000664 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 664:	55                   	push   %ebp
 665:	89 e5                	mov    %esp,%ebp
 667:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 66a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 671:	8d 45 0c             	lea    0xc(%ebp),%eax
 674:	83 c0 04             	add    $0x4,%eax
 677:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 67a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 681:	e9 78 01 00 00       	jmp    7fe <printf+0x19a>
    c = fmt[i] & 0xff;
 686:	8b 55 0c             	mov    0xc(%ebp),%edx
 689:	8b 45 f0             	mov    -0x10(%ebp),%eax
 68c:	01 d0                	add    %edx,%eax
 68e:	8a 00                	mov    (%eax),%al
 690:	0f be c0             	movsbl %al,%eax
 693:	25 ff 00 00 00       	and    $0xff,%eax
 698:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 69b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 69f:	75 2c                	jne    6cd <printf+0x69>
      if(c == '%'){
 6a1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6a5:	75 0c                	jne    6b3 <printf+0x4f>
        state = '%';
 6a7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6ae:	e9 48 01 00 00       	jmp    7fb <printf+0x197>
      } else {
        putc(fd, c);
 6b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b6:	0f be c0             	movsbl %al,%eax
 6b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bd:	8b 45 08             	mov    0x8(%ebp),%eax
 6c0:	89 04 24             	mov    %eax,(%esp)
 6c3:	e8 c4 fe ff ff       	call   58c <putc>
 6c8:	e9 2e 01 00 00       	jmp    7fb <printf+0x197>
      }
    } else if(state == '%'){
 6cd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6d1:	0f 85 24 01 00 00    	jne    7fb <printf+0x197>
      if(c == 'd'){
 6d7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6db:	75 2d                	jne    70a <printf+0xa6>
        printint(fd, *ap, 10, 1);
 6dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 6e9:	00 
 6ea:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 6f1:	00 
 6f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f6:	8b 45 08             	mov    0x8(%ebp),%eax
 6f9:	89 04 24             	mov    %eax,(%esp)
 6fc:	e8 b3 fe ff ff       	call   5b4 <printint>
        ap++;
 701:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 705:	e9 ea 00 00 00       	jmp    7f4 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 70a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 70e:	74 06                	je     716 <printf+0xb2>
 710:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 714:	75 2d                	jne    743 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 716:	8b 45 e8             	mov    -0x18(%ebp),%eax
 719:	8b 00                	mov    (%eax),%eax
 71b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 722:	00 
 723:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 72a:	00 
 72b:	89 44 24 04          	mov    %eax,0x4(%esp)
 72f:	8b 45 08             	mov    0x8(%ebp),%eax
 732:	89 04 24             	mov    %eax,(%esp)
 735:	e8 7a fe ff ff       	call   5b4 <printint>
        ap++;
 73a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 73e:	e9 b1 00 00 00       	jmp    7f4 <printf+0x190>
      } else if(c == 's'){
 743:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 747:	75 43                	jne    78c <printf+0x128>
        s = (char*)*ap;
 749:	8b 45 e8             	mov    -0x18(%ebp),%eax
 74c:	8b 00                	mov    (%eax),%eax
 74e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 751:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 755:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 759:	75 25                	jne    780 <printf+0x11c>
          s = "(null)";
 75b:	c7 45 f4 64 0a 00 00 	movl   $0xa64,-0xc(%ebp)
        while(*s != 0){
 762:	eb 1c                	jmp    780 <printf+0x11c>
          putc(fd, *s);
 764:	8b 45 f4             	mov    -0xc(%ebp),%eax
 767:	8a 00                	mov    (%eax),%al
 769:	0f be c0             	movsbl %al,%eax
 76c:	89 44 24 04          	mov    %eax,0x4(%esp)
 770:	8b 45 08             	mov    0x8(%ebp),%eax
 773:	89 04 24             	mov    %eax,(%esp)
 776:	e8 11 fe ff ff       	call   58c <putc>
          s++;
 77b:	ff 45 f4             	incl   -0xc(%ebp)
 77e:	eb 01                	jmp    781 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 780:	90                   	nop
 781:	8b 45 f4             	mov    -0xc(%ebp),%eax
 784:	8a 00                	mov    (%eax),%al
 786:	84 c0                	test   %al,%al
 788:	75 da                	jne    764 <printf+0x100>
 78a:	eb 68                	jmp    7f4 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 78c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 790:	75 1d                	jne    7af <printf+0x14b>
        putc(fd, *ap);
 792:	8b 45 e8             	mov    -0x18(%ebp),%eax
 795:	8b 00                	mov    (%eax),%eax
 797:	0f be c0             	movsbl %al,%eax
 79a:	89 44 24 04          	mov    %eax,0x4(%esp)
 79e:	8b 45 08             	mov    0x8(%ebp),%eax
 7a1:	89 04 24             	mov    %eax,(%esp)
 7a4:	e8 e3 fd ff ff       	call   58c <putc>
        ap++;
 7a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ad:	eb 45                	jmp    7f4 <printf+0x190>
      } else if(c == '%'){
 7af:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7b3:	75 17                	jne    7cc <printf+0x168>
        putc(fd, c);
 7b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b8:	0f be c0             	movsbl %al,%eax
 7bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 7bf:	8b 45 08             	mov    0x8(%ebp),%eax
 7c2:	89 04 24             	mov    %eax,(%esp)
 7c5:	e8 c2 fd ff ff       	call   58c <putc>
 7ca:	eb 28                	jmp    7f4 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7cc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7d3:	00 
 7d4:	8b 45 08             	mov    0x8(%ebp),%eax
 7d7:	89 04 24             	mov    %eax,(%esp)
 7da:	e8 ad fd ff ff       	call   58c <putc>
        putc(fd, c);
 7df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7e2:	0f be c0             	movsbl %al,%eax
 7e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e9:	8b 45 08             	mov    0x8(%ebp),%eax
 7ec:	89 04 24             	mov    %eax,(%esp)
 7ef:	e8 98 fd ff ff       	call   58c <putc>
      }
      state = 0;
 7f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7fb:	ff 45 f0             	incl   -0x10(%ebp)
 7fe:	8b 55 0c             	mov    0xc(%ebp),%edx
 801:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804:	01 d0                	add    %edx,%eax
 806:	8a 00                	mov    (%eax),%al
 808:	84 c0                	test   %al,%al
 80a:	0f 85 76 fe ff ff    	jne    686 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 810:	c9                   	leave  
 811:	c3                   	ret    
 812:	66 90                	xchg   %ax,%ax

00000814 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 814:	55                   	push   %ebp
 815:	89 e5                	mov    %esp,%ebp
 817:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81a:	8b 45 08             	mov    0x8(%ebp),%eax
 81d:	83 e8 08             	sub    $0x8,%eax
 820:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 823:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 828:	89 45 fc             	mov    %eax,-0x4(%ebp)
 82b:	eb 24                	jmp    851 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 835:	77 12                	ja     849 <free+0x35>
 837:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 83d:	77 24                	ja     863 <free+0x4f>
 83f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 842:	8b 00                	mov    (%eax),%eax
 844:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 847:	77 1a                	ja     863 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 849:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84c:	8b 00                	mov    (%eax),%eax
 84e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 851:	8b 45 f8             	mov    -0x8(%ebp),%eax
 854:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 857:	76 d4                	jbe    82d <free+0x19>
 859:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85c:	8b 00                	mov    (%eax),%eax
 85e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 861:	76 ca                	jbe    82d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 863:	8b 45 f8             	mov    -0x8(%ebp),%eax
 866:	8b 40 04             	mov    0x4(%eax),%eax
 869:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 870:	8b 45 f8             	mov    -0x8(%ebp),%eax
 873:	01 c2                	add    %eax,%edx
 875:	8b 45 fc             	mov    -0x4(%ebp),%eax
 878:	8b 00                	mov    (%eax),%eax
 87a:	39 c2                	cmp    %eax,%edx
 87c:	75 24                	jne    8a2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 87e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 881:	8b 50 04             	mov    0x4(%eax),%edx
 884:	8b 45 fc             	mov    -0x4(%ebp),%eax
 887:	8b 00                	mov    (%eax),%eax
 889:	8b 40 04             	mov    0x4(%eax),%eax
 88c:	01 c2                	add    %eax,%edx
 88e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 891:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 894:	8b 45 fc             	mov    -0x4(%ebp),%eax
 897:	8b 00                	mov    (%eax),%eax
 899:	8b 10                	mov    (%eax),%edx
 89b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89e:	89 10                	mov    %edx,(%eax)
 8a0:	eb 0a                	jmp    8ac <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a5:	8b 10                	mov    (%eax),%edx
 8a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8aa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8af:	8b 40 04             	mov    0x4(%eax),%eax
 8b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bc:	01 d0                	add    %edx,%eax
 8be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8c1:	75 20                	jne    8e3 <free+0xcf>
    p->s.size += bp->s.size;
 8c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c6:	8b 50 04             	mov    0x4(%eax),%edx
 8c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cc:	8b 40 04             	mov    0x4(%eax),%eax
 8cf:	01 c2                	add    %eax,%edx
 8d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8da:	8b 10                	mov    (%eax),%edx
 8dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8df:	89 10                	mov    %edx,(%eax)
 8e1:	eb 08                	jmp    8eb <free+0xd7>
  } else
    p->s.ptr = bp;
 8e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8e9:	89 10                	mov    %edx,(%eax)
  freep = p;
 8eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ee:	a3 0c 0d 00 00       	mov    %eax,0xd0c
}
 8f3:	c9                   	leave  
 8f4:	c3                   	ret    

000008f5 <morecore>:

static Header*
morecore(uint nu)
{
 8f5:	55                   	push   %ebp
 8f6:	89 e5                	mov    %esp,%ebp
 8f8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8fb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 902:	77 07                	ja     90b <morecore+0x16>
    nu = 4096;
 904:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 90b:	8b 45 08             	mov    0x8(%ebp),%eax
 90e:	c1 e0 03             	shl    $0x3,%eax
 911:	89 04 24             	mov    %eax,(%esp)
 914:	e8 4b fc ff ff       	call   564 <sbrk>
 919:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 91c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 920:	75 07                	jne    929 <morecore+0x34>
    return 0;
 922:	b8 00 00 00 00       	mov    $0x0,%eax
 927:	eb 22                	jmp    94b <morecore+0x56>
  hp = (Header*)p;
 929:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 92f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 932:	8b 55 08             	mov    0x8(%ebp),%edx
 935:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 938:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93b:	83 c0 08             	add    $0x8,%eax
 93e:	89 04 24             	mov    %eax,(%esp)
 941:	e8 ce fe ff ff       	call   814 <free>
  return freep;
 946:	a1 0c 0d 00 00       	mov    0xd0c,%eax
}
 94b:	c9                   	leave  
 94c:	c3                   	ret    

0000094d <malloc>:

void*
malloc(uint nbytes)
{
 94d:	55                   	push   %ebp
 94e:	89 e5                	mov    %esp,%ebp
 950:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 953:	8b 45 08             	mov    0x8(%ebp),%eax
 956:	83 c0 07             	add    $0x7,%eax
 959:	c1 e8 03             	shr    $0x3,%eax
 95c:	40                   	inc    %eax
 95d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 960:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 965:	89 45 f0             	mov    %eax,-0x10(%ebp)
 968:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 96c:	75 23                	jne    991 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 96e:	c7 45 f0 04 0d 00 00 	movl   $0xd04,-0x10(%ebp)
 975:	8b 45 f0             	mov    -0x10(%ebp),%eax
 978:	a3 0c 0d 00 00       	mov    %eax,0xd0c
 97d:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 982:	a3 04 0d 00 00       	mov    %eax,0xd04
    base.s.size = 0;
 987:	c7 05 08 0d 00 00 00 	movl   $0x0,0xd08
 98e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 991:	8b 45 f0             	mov    -0x10(%ebp),%eax
 994:	8b 00                	mov    (%eax),%eax
 996:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 999:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99c:	8b 40 04             	mov    0x4(%eax),%eax
 99f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9a2:	72 4d                	jb     9f1 <malloc+0xa4>
      if(p->s.size == nunits)
 9a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a7:	8b 40 04             	mov    0x4(%eax),%eax
 9aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9ad:	75 0c                	jne    9bb <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 9af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b2:	8b 10                	mov    (%eax),%edx
 9b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b7:	89 10                	mov    %edx,(%eax)
 9b9:	eb 26                	jmp    9e1 <malloc+0x94>
      else {
        p->s.size -= nunits;
 9bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9be:	8b 40 04             	mov    0x4(%eax),%eax
 9c1:	89 c2                	mov    %eax,%edx
 9c3:	2b 55 ec             	sub    -0x14(%ebp),%edx
 9c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cf:	8b 40 04             	mov    0x4(%eax),%eax
 9d2:	c1 e0 03             	shl    $0x3,%eax
 9d5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9db:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9de:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e4:	a3 0c 0d 00 00       	mov    %eax,0xd0c
      return (void*)(p + 1);
 9e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ec:	83 c0 08             	add    $0x8,%eax
 9ef:	eb 38                	jmp    a29 <malloc+0xdc>
    }
    if(p == freep)
 9f1:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 9f6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9f9:	75 1b                	jne    a16 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 9fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9fe:	89 04 24             	mov    %eax,(%esp)
 a01:	e8 ef fe ff ff       	call   8f5 <morecore>
 a06:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a0d:	75 07                	jne    a16 <malloc+0xc9>
        return 0;
 a0f:	b8 00 00 00 00       	mov    $0x0,%eax
 a14:	eb 13                	jmp    a29 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a19:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1f:	8b 00                	mov    (%eax),%eax
 a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a24:	e9 70 ff ff ff       	jmp    999 <malloc+0x4c>
}
 a29:	c9                   	leave  
 a2a:	c3                   	ret    
