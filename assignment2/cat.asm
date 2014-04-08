
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
   f:	c7 44 24 04 60 0c 00 	movl   $0xc60,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 21 04 00 00       	call   444 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 60 0c 00 	movl   $0xc60,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 fe 03 00 00       	call   43c <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 73 09 00 	movl   $0x973,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 4b 05 00 00       	call   5ac <printf>
    exit();
  61:	e8 be 03 00 00       	call   424 <exit>
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
  83:	e8 9c 03 00 00       	call   424 <exit>
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
  af:	e8 b0 03 00 00       	call   464 <open>
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
  d5:	c7 44 24 04 84 09 00 	movl   $0x984,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 c3 04 00 00       	call   5ac <printf>
      exit();
  e9:	e8 36 03 00 00       	call   424 <exit>
    }
    cat(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 06 ff ff ff       	call   0 <cat>
    close(fd);
  fa:	8b 44 24 18          	mov    0x18(%esp),%eax
  fe:	89 04 24             	mov    %eax,(%esp)
 101:	e8 46 03 00 00       	call   44c <close>
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
 117:	e8 08 03 00 00       	call   424 <exit>

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

#define NULL   0

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
 249:	e8 ee 01 00 00       	call   43c <read>
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
 2a5:	e8 ba 01 00 00       	call   464 <open>
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
 2c7:	e8 b0 01 00 00       	call   47c <fstat>
 2cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d2:	89 04 24             	mov    %eax,(%esp)
 2d5:	e8 72 01 00 00       	call   44c <close>
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

0000035d <strtok>:

char*
strtok(char *teststr, char ch)
{
 35d:	55                   	push   %ebp
 35e:	89 e5                	mov    %esp,%ebp
 360:	83 ec 24             	sub    $0x24,%esp
 363:	8b 45 0c             	mov    0xc(%ebp),%eax
 366:	88 45 dc             	mov    %al,-0x24(%ebp)
    char *dummystr = NULL;
 369:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    char *start = NULL;
 370:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    char *end = NULL;
 377:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char nullch = '\0';
 37e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    char *address_of_null = &nullch;
 382:	8d 45 ef             	lea    -0x11(%ebp),%eax
 385:	89 45 f0             	mov    %eax,-0x10(%ebp)
    static char *nexttok;

    if(teststr != NULL)
 388:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 38c:	74 08                	je     396 <strtok+0x39>
    {
        dummystr = teststr;
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	89 45 fc             	mov    %eax,-0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 394:	eb 75                	jmp    40b <strtok+0xae>
    {
        dummystr = teststr;
    }
    else
    {
        if(*nexttok == '\0')
 396:	a1 40 0c 00 00       	mov    0xc40,%eax
 39b:	8a 00                	mov    (%eax),%al
 39d:	84 c0                	test   %al,%al
 39f:	75 07                	jne    3a8 <strtok+0x4b>
            return NULL;
 3a1:	b8 00 00 00 00       	mov    $0x0,%eax
 3a6:	eb 6f                	jmp    417 <strtok+0xba>
        dummystr = nexttok;
 3a8:	a1 40 0c 00 00       	mov    0xc40,%eax
 3ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }


    while(dummystr != NULL)
 3b0:	eb 59                	jmp    40b <strtok+0xae>
    {
        //empty string
        if(*dummystr == '\0')
 3b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3b5:	8a 00                	mov    (%eax),%al
 3b7:	84 c0                	test   %al,%al
 3b9:	74 58                	je     413 <strtok+0xb6>
            break;
        if(*dummystr != ch)
 3bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3be:	8a 00                	mov    (%eax),%al
 3c0:	3a 45 dc             	cmp    -0x24(%ebp),%al
 3c3:	74 22                	je     3e7 <strtok+0x8a>
        {
            if(!start)
 3c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 3c9:	75 06                	jne    3d1 <strtok+0x74>
                start = dummystr;
 3cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ce:	89 45 f8             	mov    %eax,-0x8(%ebp)

            dummystr++;
 3d1:	ff 45 fc             	incl   -0x4(%ebp)

            // handle the case where the delimiter is not at the end of the string.
            if(*dummystr == '\0')
 3d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d7:	8a 00                	mov    (%eax),%al
 3d9:	84 c0                	test   %al,%al
 3db:	75 2e                	jne    40b <strtok+0xae>
            {
                nexttok = dummystr;
 3dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3e0:	a3 40 0c 00 00       	mov    %eax,0xc40
                break;
 3e5:	eb 2d                	jmp    414 <strtok+0xb7>
            }
        }
        else
        {
            if(start)
 3e7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 3eb:	74 1b                	je     408 <strtok+0xab>
            {
                end = dummystr;
 3ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
                nexttok = dummystr+1;
 3f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3f6:	40                   	inc    %eax
 3f7:	a3 40 0c 00 00       	mov    %eax,0xc40
                *end = *address_of_null;
 3fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3ff:	8a 10                	mov    (%eax),%dl
 401:	8b 45 f4             	mov    -0xc(%ebp),%eax
 404:	88 10                	mov    %dl,(%eax)
                break;
 406:	eb 0c                	jmp    414 <strtok+0xb7>
            }
            else
            {
                dummystr++;
 408:	ff 45 fc             	incl   -0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 40b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
 40f:	75 a1                	jne    3b2 <strtok+0x55>
 411:	eb 01                	jmp    414 <strtok+0xb7>
    {
        //empty string
        if(*dummystr == '\0')
            break;
 413:	90                   	nop
                dummystr++;
            }
        }
    }

    return start;
 414:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 417:	c9                   	leave  
 418:	c3                   	ret    
 419:	66 90                	xchg   %ax,%ax
 41b:	90                   	nop

0000041c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 41c:	b8 01 00 00 00       	mov    $0x1,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <exit>:
SYSCALL(exit)
 424:	b8 02 00 00 00       	mov    $0x2,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <wait>:
SYSCALL(wait)
 42c:	b8 03 00 00 00       	mov    $0x3,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <pipe>:
SYSCALL(pipe)
 434:	b8 04 00 00 00       	mov    $0x4,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <read>:
SYSCALL(read)
 43c:	b8 05 00 00 00       	mov    $0x5,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <write>:
SYSCALL(write)
 444:	b8 10 00 00 00       	mov    $0x10,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <close>:
SYSCALL(close)
 44c:	b8 15 00 00 00       	mov    $0x15,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <kill>:
SYSCALL(kill)
 454:	b8 06 00 00 00       	mov    $0x6,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <exec>:
SYSCALL(exec)
 45c:	b8 07 00 00 00       	mov    $0x7,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <open>:
SYSCALL(open)
 464:	b8 0f 00 00 00       	mov    $0xf,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <mknod>:
SYSCALL(mknod)
 46c:	b8 11 00 00 00       	mov    $0x11,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <unlink>:
SYSCALL(unlink)
 474:	b8 12 00 00 00       	mov    $0x12,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <fstat>:
SYSCALL(fstat)
 47c:	b8 08 00 00 00       	mov    $0x8,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <link>:
SYSCALL(link)
 484:	b8 13 00 00 00       	mov    $0x13,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <mkdir>:
SYSCALL(mkdir)
 48c:	b8 14 00 00 00       	mov    $0x14,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <chdir>:
SYSCALL(chdir)
 494:	b8 09 00 00 00       	mov    $0x9,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <dup>:
SYSCALL(dup)
 49c:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <getpid>:
SYSCALL(getpid)
 4a4:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <sbrk>:
SYSCALL(sbrk)
 4ac:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <sleep>:
SYSCALL(sleep)
 4b4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <uptime>:
SYSCALL(uptime)
 4bc:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <add_path>:
SYSCALL(add_path)
 4c4:	b8 16 00 00 00       	mov    $0x16,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <wait2>:
SYSCALL(wait2)
 4cc:	b8 17 00 00 00       	mov    $0x17,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4d4:	55                   	push   %ebp
 4d5:	89 e5                	mov    %esp,%ebp
 4d7:	83 ec 28             	sub    $0x28,%esp
 4da:	8b 45 0c             	mov    0xc(%ebp),%eax
 4dd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4e0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4e7:	00 
 4e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ef:	8b 45 08             	mov    0x8(%ebp),%eax
 4f2:	89 04 24             	mov    %eax,(%esp)
 4f5:	e8 4a ff ff ff       	call   444 <write>
}
 4fa:	c9                   	leave  
 4fb:	c3                   	ret    

000004fc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4fc:	55                   	push   %ebp
 4fd:	89 e5                	mov    %esp,%ebp
 4ff:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 502:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 509:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 50d:	74 17                	je     526 <printint+0x2a>
 50f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 513:	79 11                	jns    526 <printint+0x2a>
    neg = 1;
 515:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 51c:	8b 45 0c             	mov    0xc(%ebp),%eax
 51f:	f7 d8                	neg    %eax
 521:	89 45 ec             	mov    %eax,-0x14(%ebp)
 524:	eb 06                	jmp    52c <printint+0x30>
  } else {
    x = xx;
 526:	8b 45 0c             	mov    0xc(%ebp),%eax
 529:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 52c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 533:	8b 4d 10             	mov    0x10(%ebp),%ecx
 536:	8b 45 ec             	mov    -0x14(%ebp),%eax
 539:	ba 00 00 00 00       	mov    $0x0,%edx
 53e:	f7 f1                	div    %ecx
 540:	89 d0                	mov    %edx,%eax
 542:	8a 80 1c 0c 00 00    	mov    0xc1c(%eax),%al
 548:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 54b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 54e:	01 ca                	add    %ecx,%edx
 550:	88 02                	mov    %al,(%edx)
 552:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 555:	8b 55 10             	mov    0x10(%ebp),%edx
 558:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 55b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 55e:	ba 00 00 00 00       	mov    $0x0,%edx
 563:	f7 75 d4             	divl   -0x2c(%ebp)
 566:	89 45 ec             	mov    %eax,-0x14(%ebp)
 569:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 56d:	75 c4                	jne    533 <printint+0x37>
  if(neg)
 56f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 573:	74 2c                	je     5a1 <printint+0xa5>
    buf[i++] = '-';
 575:	8d 55 dc             	lea    -0x24(%ebp),%edx
 578:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57b:	01 d0                	add    %edx,%eax
 57d:	c6 00 2d             	movb   $0x2d,(%eax)
 580:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 583:	eb 1c                	jmp    5a1 <printint+0xa5>
    putc(fd, buf[i]);
 585:	8d 55 dc             	lea    -0x24(%ebp),%edx
 588:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58b:	01 d0                	add    %edx,%eax
 58d:	8a 00                	mov    (%eax),%al
 58f:	0f be c0             	movsbl %al,%eax
 592:	89 44 24 04          	mov    %eax,0x4(%esp)
 596:	8b 45 08             	mov    0x8(%ebp),%eax
 599:	89 04 24             	mov    %eax,(%esp)
 59c:	e8 33 ff ff ff       	call   4d4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5a1:	ff 4d f4             	decl   -0xc(%ebp)
 5a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a8:	79 db                	jns    585 <printint+0x89>
    putc(fd, buf[i]);
}
 5aa:	c9                   	leave  
 5ab:	c3                   	ret    

000005ac <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5ac:	55                   	push   %ebp
 5ad:	89 e5                	mov    %esp,%ebp
 5af:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5b2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5b9:	8d 45 0c             	lea    0xc(%ebp),%eax
 5bc:	83 c0 04             	add    $0x4,%eax
 5bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5c9:	e9 78 01 00 00       	jmp    746 <printf+0x19a>
    c = fmt[i] & 0xff;
 5ce:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d4:	01 d0                	add    %edx,%eax
 5d6:	8a 00                	mov    (%eax),%al
 5d8:	0f be c0             	movsbl %al,%eax
 5db:	25 ff 00 00 00       	and    $0xff,%eax
 5e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e7:	75 2c                	jne    615 <printf+0x69>
      if(c == '%'){
 5e9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ed:	75 0c                	jne    5fb <printf+0x4f>
        state = '%';
 5ef:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5f6:	e9 48 01 00 00       	jmp    743 <printf+0x197>
      } else {
        putc(fd, c);
 5fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fe:	0f be c0             	movsbl %al,%eax
 601:	89 44 24 04          	mov    %eax,0x4(%esp)
 605:	8b 45 08             	mov    0x8(%ebp),%eax
 608:	89 04 24             	mov    %eax,(%esp)
 60b:	e8 c4 fe ff ff       	call   4d4 <putc>
 610:	e9 2e 01 00 00       	jmp    743 <printf+0x197>
      }
    } else if(state == '%'){
 615:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 619:	0f 85 24 01 00 00    	jne    743 <printf+0x197>
      if(c == 'd'){
 61f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 623:	75 2d                	jne    652 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 625:	8b 45 e8             	mov    -0x18(%ebp),%eax
 628:	8b 00                	mov    (%eax),%eax
 62a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 631:	00 
 632:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 639:	00 
 63a:	89 44 24 04          	mov    %eax,0x4(%esp)
 63e:	8b 45 08             	mov    0x8(%ebp),%eax
 641:	89 04 24             	mov    %eax,(%esp)
 644:	e8 b3 fe ff ff       	call   4fc <printint>
        ap++;
 649:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64d:	e9 ea 00 00 00       	jmp    73c <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 652:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 656:	74 06                	je     65e <printf+0xb2>
 658:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 65c:	75 2d                	jne    68b <printf+0xdf>
        printint(fd, *ap, 16, 0);
 65e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 661:	8b 00                	mov    (%eax),%eax
 663:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 66a:	00 
 66b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 672:	00 
 673:	89 44 24 04          	mov    %eax,0x4(%esp)
 677:	8b 45 08             	mov    0x8(%ebp),%eax
 67a:	89 04 24             	mov    %eax,(%esp)
 67d:	e8 7a fe ff ff       	call   4fc <printint>
        ap++;
 682:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 686:	e9 b1 00 00 00       	jmp    73c <printf+0x190>
      } else if(c == 's'){
 68b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 68f:	75 43                	jne    6d4 <printf+0x128>
        s = (char*)*ap;
 691:	8b 45 e8             	mov    -0x18(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 699:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 69d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6a1:	75 25                	jne    6c8 <printf+0x11c>
          s = "(null)";
 6a3:	c7 45 f4 99 09 00 00 	movl   $0x999,-0xc(%ebp)
        while(*s != 0){
 6aa:	eb 1c                	jmp    6c8 <printf+0x11c>
          putc(fd, *s);
 6ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6af:	8a 00                	mov    (%eax),%al
 6b1:	0f be c0             	movsbl %al,%eax
 6b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b8:	8b 45 08             	mov    0x8(%ebp),%eax
 6bb:	89 04 24             	mov    %eax,(%esp)
 6be:	e8 11 fe ff ff       	call   4d4 <putc>
          s++;
 6c3:	ff 45 f4             	incl   -0xc(%ebp)
 6c6:	eb 01                	jmp    6c9 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6c8:	90                   	nop
 6c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6cc:	8a 00                	mov    (%eax),%al
 6ce:	84 c0                	test   %al,%al
 6d0:	75 da                	jne    6ac <printf+0x100>
 6d2:	eb 68                	jmp    73c <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6d8:	75 1d                	jne    6f7 <printf+0x14b>
        putc(fd, *ap);
 6da:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6dd:	8b 00                	mov    (%eax),%eax
 6df:	0f be c0             	movsbl %al,%eax
 6e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e6:	8b 45 08             	mov    0x8(%ebp),%eax
 6e9:	89 04 24             	mov    %eax,(%esp)
 6ec:	e8 e3 fd ff ff       	call   4d4 <putc>
        ap++;
 6f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f5:	eb 45                	jmp    73c <printf+0x190>
      } else if(c == '%'){
 6f7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6fb:	75 17                	jne    714 <printf+0x168>
        putc(fd, c);
 6fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 700:	0f be c0             	movsbl %al,%eax
 703:	89 44 24 04          	mov    %eax,0x4(%esp)
 707:	8b 45 08             	mov    0x8(%ebp),%eax
 70a:	89 04 24             	mov    %eax,(%esp)
 70d:	e8 c2 fd ff ff       	call   4d4 <putc>
 712:	eb 28                	jmp    73c <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 714:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 71b:	00 
 71c:	8b 45 08             	mov    0x8(%ebp),%eax
 71f:	89 04 24             	mov    %eax,(%esp)
 722:	e8 ad fd ff ff       	call   4d4 <putc>
        putc(fd, c);
 727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72a:	0f be c0             	movsbl %al,%eax
 72d:	89 44 24 04          	mov    %eax,0x4(%esp)
 731:	8b 45 08             	mov    0x8(%ebp),%eax
 734:	89 04 24             	mov    %eax,(%esp)
 737:	e8 98 fd ff ff       	call   4d4 <putc>
      }
      state = 0;
 73c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 743:	ff 45 f0             	incl   -0x10(%ebp)
 746:	8b 55 0c             	mov    0xc(%ebp),%edx
 749:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74c:	01 d0                	add    %edx,%eax
 74e:	8a 00                	mov    (%eax),%al
 750:	84 c0                	test   %al,%al
 752:	0f 85 76 fe ff ff    	jne    5ce <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 758:	c9                   	leave  
 759:	c3                   	ret    
 75a:	66 90                	xchg   %ax,%ax

0000075c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75c:	55                   	push   %ebp
 75d:	89 e5                	mov    %esp,%ebp
 75f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 762:	8b 45 08             	mov    0x8(%ebp),%eax
 765:	83 e8 08             	sub    $0x8,%eax
 768:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76b:	a1 4c 0c 00 00       	mov    0xc4c,%eax
 770:	89 45 fc             	mov    %eax,-0x4(%ebp)
 773:	eb 24                	jmp    799 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	8b 00                	mov    (%eax),%eax
 77a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 77d:	77 12                	ja     791 <free+0x35>
 77f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 782:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 785:	77 24                	ja     7ab <free+0x4f>
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	8b 00                	mov    (%eax),%eax
 78c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78f:	77 1a                	ja     7ab <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 00                	mov    (%eax),%eax
 796:	89 45 fc             	mov    %eax,-0x4(%ebp)
 799:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79f:	76 d4                	jbe    775 <free+0x19>
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a9:	76 ca                	jbe    775 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ae:	8b 40 04             	mov    0x4(%eax),%eax
 7b1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bb:	01 c2                	add    %eax,%edx
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	39 c2                	cmp    %eax,%edx
 7c4:	75 24                	jne    7ea <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c9:	8b 50 04             	mov    0x4(%eax),%edx
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8b 00                	mov    (%eax),%eax
 7d1:	8b 40 04             	mov    0x4(%eax),%eax
 7d4:	01 c2                	add    %eax,%edx
 7d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	8b 00                	mov    (%eax),%eax
 7e1:	8b 10                	mov    (%eax),%edx
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e6:	89 10                	mov    %edx,(%eax)
 7e8:	eb 0a                	jmp    7f4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ed:	8b 10                	mov    (%eax),%edx
 7ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f7:	8b 40 04             	mov    0x4(%eax),%eax
 7fa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 801:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804:	01 d0                	add    %edx,%eax
 806:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 809:	75 20                	jne    82b <free+0xcf>
    p->s.size += bp->s.size;
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	8b 50 04             	mov    0x4(%eax),%edx
 811:	8b 45 f8             	mov    -0x8(%ebp),%eax
 814:	8b 40 04             	mov    0x4(%eax),%eax
 817:	01 c2                	add    %eax,%edx
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 81f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 822:	8b 10                	mov    (%eax),%edx
 824:	8b 45 fc             	mov    -0x4(%ebp),%eax
 827:	89 10                	mov    %edx,(%eax)
 829:	eb 08                	jmp    833 <free+0xd7>
  } else
    p->s.ptr = bp;
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 831:	89 10                	mov    %edx,(%eax)
  freep = p;
 833:	8b 45 fc             	mov    -0x4(%ebp),%eax
 836:	a3 4c 0c 00 00       	mov    %eax,0xc4c
}
 83b:	c9                   	leave  
 83c:	c3                   	ret    

0000083d <morecore>:

static Header*
morecore(uint nu)
{
 83d:	55                   	push   %ebp
 83e:	89 e5                	mov    %esp,%ebp
 840:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 843:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 84a:	77 07                	ja     853 <morecore+0x16>
    nu = 4096;
 84c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 853:	8b 45 08             	mov    0x8(%ebp),%eax
 856:	c1 e0 03             	shl    $0x3,%eax
 859:	89 04 24             	mov    %eax,(%esp)
 85c:	e8 4b fc ff ff       	call   4ac <sbrk>
 861:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 864:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 868:	75 07                	jne    871 <morecore+0x34>
    return 0;
 86a:	b8 00 00 00 00       	mov    $0x0,%eax
 86f:	eb 22                	jmp    893 <morecore+0x56>
  hp = (Header*)p;
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 877:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87a:	8b 55 08             	mov    0x8(%ebp),%edx
 87d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 880:	8b 45 f0             	mov    -0x10(%ebp),%eax
 883:	83 c0 08             	add    $0x8,%eax
 886:	89 04 24             	mov    %eax,(%esp)
 889:	e8 ce fe ff ff       	call   75c <free>
  return freep;
 88e:	a1 4c 0c 00 00       	mov    0xc4c,%eax
}
 893:	c9                   	leave  
 894:	c3                   	ret    

00000895 <malloc>:

void*
malloc(uint nbytes)
{
 895:	55                   	push   %ebp
 896:	89 e5                	mov    %esp,%ebp
 898:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 89b:	8b 45 08             	mov    0x8(%ebp),%eax
 89e:	83 c0 07             	add    $0x7,%eax
 8a1:	c1 e8 03             	shr    $0x3,%eax
 8a4:	40                   	inc    %eax
 8a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a8:	a1 4c 0c 00 00       	mov    0xc4c,%eax
 8ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8b4:	75 23                	jne    8d9 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 8b6:	c7 45 f0 44 0c 00 00 	movl   $0xc44,-0x10(%ebp)
 8bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c0:	a3 4c 0c 00 00       	mov    %eax,0xc4c
 8c5:	a1 4c 0c 00 00       	mov    0xc4c,%eax
 8ca:	a3 44 0c 00 00       	mov    %eax,0xc44
    base.s.size = 0;
 8cf:	c7 05 48 0c 00 00 00 	movl   $0x0,0xc48
 8d6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8dc:	8b 00                	mov    (%eax),%eax
 8de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e4:	8b 40 04             	mov    0x4(%eax),%eax
 8e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ea:	72 4d                	jb     939 <malloc+0xa4>
      if(p->s.size == nunits)
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	8b 40 04             	mov    0x4(%eax),%eax
 8f2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f5:	75 0c                	jne    903 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fa:	8b 10                	mov    (%eax),%edx
 8fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ff:	89 10                	mov    %edx,(%eax)
 901:	eb 26                	jmp    929 <malloc+0x94>
      else {
        p->s.size -= nunits;
 903:	8b 45 f4             	mov    -0xc(%ebp),%eax
 906:	8b 40 04             	mov    0x4(%eax),%eax
 909:	89 c2                	mov    %eax,%edx
 90b:	2b 55 ec             	sub    -0x14(%ebp),%edx
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	8b 40 04             	mov    0x4(%eax),%eax
 91a:	c1 e0 03             	shl    $0x3,%eax
 91d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 920:	8b 45 f4             	mov    -0xc(%ebp),%eax
 923:	8b 55 ec             	mov    -0x14(%ebp),%edx
 926:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 929:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92c:	a3 4c 0c 00 00       	mov    %eax,0xc4c
      return (void*)(p + 1);
 931:	8b 45 f4             	mov    -0xc(%ebp),%eax
 934:	83 c0 08             	add    $0x8,%eax
 937:	eb 38                	jmp    971 <malloc+0xdc>
    }
    if(p == freep)
 939:	a1 4c 0c 00 00       	mov    0xc4c,%eax
 93e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 941:	75 1b                	jne    95e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 943:	8b 45 ec             	mov    -0x14(%ebp),%eax
 946:	89 04 24             	mov    %eax,(%esp)
 949:	e8 ef fe ff ff       	call   83d <morecore>
 94e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 955:	75 07                	jne    95e <malloc+0xc9>
        return 0;
 957:	b8 00 00 00 00       	mov    $0x0,%eax
 95c:	eb 13                	jmp    971 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	89 45 f0             	mov    %eax,-0x10(%ebp)
 964:	8b 45 f4             	mov    -0xc(%ebp),%eax
 967:	8b 00                	mov    (%eax),%eax
 969:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 96c:	e9 70 ff ff ff       	jmp    8e1 <malloc+0x4c>
}
 971:	c9                   	leave  
 972:	c3                   	ret    
