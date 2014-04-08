
_export:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

#define NULL   0

int
main(int argc, char* argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
    if(argc < 2)
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    {
        printf(1, "export: not enough arguments where given\n");
   f:	c7 44 24 04 2c 09 00 	movl   $0x92c,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 41 05 00 00       	call   564 <printf>
        exit();
  23:	e8 b4 03 00 00       	call   3dc <exit>
    }
    char *path;
    int error = 0;
  28:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  2f:	00 

    path = strtok(argv[1], ':');
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  3f:	00 
  40:	89 04 24             	mov    %eax,(%esp)
  43:	e8 cd 02 00 00       	call   315 <strtok>
  48:	89 44 24 1c          	mov    %eax,0x1c(%esp)

    error = add_path(path);
  4c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  50:	89 04 24             	mov    %eax,(%esp)
  53:	e8 24 04 00 00       	call   47c <add_path>
  58:	89 44 24 18          	mov    %eax,0x18(%esp)
    if(error)
  5c:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  61:	74 65                	je     c8 <main+0xc8>
    {
        printf(1, "export: PATH evironment varialbe is full\n");
  63:	c7 44 24 04 58 09 00 	movl   $0x958,0x4(%esp)
  6a:	00 
  6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  72:	e8 ed 04 00 00       	call   564 <printf>
        exit();
  77:	e8 60 03 00 00       	call   3dc <exit>
    }

    while(path != NULL)
    {
        path = strtok(NULL, ':');
  7c:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  83:	00 
  84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8b:	e8 85 02 00 00       	call   315 <strtok>
  90:	89 44 24 1c          	mov    %eax,0x1c(%esp)
        if(path)
  94:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  99:	74 10                	je     ab <main+0xab>
            error = add_path(path);
  9b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  9f:	89 04 24             	mov    %eax,(%esp)
  a2:	e8 d5 03 00 00       	call   47c <add_path>
  a7:	89 44 24 18          	mov    %eax,0x18(%esp)
        if(error)
  ab:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  b0:	74 16                	je     c8 <main+0xc8>
        {
            printf(1, "export: PATH evironment varialbe is full\n PATH = %s and the rest were not included");
  b2:	c7 44 24 04 84 09 00 	movl   $0x984,0x4(%esp)
  b9:	00 
  ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c1:	e8 9e 04 00 00       	call   564 <printf>
            break;
  c6:	eb 07                	jmp    cf <main+0xcf>
    {
        printf(1, "export: PATH evironment varialbe is full\n");
        exit();
    }

    while(path != NULL)
  c8:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  cd:	75 ad                	jne    7c <main+0x7c>
            printf(1, "export: PATH evironment varialbe is full\n PATH = %s and the rest were not included");
            break;
        }
    }

    exit();
  cf:	e8 08 03 00 00       	call   3dc <exit>

000000d4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	57                   	push   %edi
  d8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  dc:	8b 55 10             	mov    0x10(%ebp),%edx
  df:	8b 45 0c             	mov    0xc(%ebp),%eax
  e2:	89 cb                	mov    %ecx,%ebx
  e4:	89 df                	mov    %ebx,%edi
  e6:	89 d1                	mov    %edx,%ecx
  e8:	fc                   	cld    
  e9:	f3 aa                	rep stos %al,%es:(%edi)
  eb:	89 ca                	mov    %ecx,%edx
  ed:	89 fb                	mov    %edi,%ebx
  ef:	89 5d 08             	mov    %ebx,0x8(%ebp)
  f2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  f5:	5b                   	pop    %ebx
  f6:	5f                   	pop    %edi
  f7:	5d                   	pop    %ebp
  f8:	c3                   	ret    

000000f9 <strcpy>:

#define NULL   0

char*
strcpy(char *s, char *t)
{
  f9:	55                   	push   %ebp
  fa:	89 e5                	mov    %esp,%ebp
  fc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 105:	90                   	nop
 106:	8b 45 0c             	mov    0xc(%ebp),%eax
 109:	8a 10                	mov    (%eax),%dl
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	88 10                	mov    %dl,(%eax)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	8a 00                	mov    (%eax),%al
 115:	84 c0                	test   %al,%al
 117:	0f 95 c0             	setne  %al
 11a:	ff 45 08             	incl   0x8(%ebp)
 11d:	ff 45 0c             	incl   0xc(%ebp)
 120:	84 c0                	test   %al,%al
 122:	75 e2                	jne    106 <strcpy+0xd>
    ;
  return os;
 124:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 127:	c9                   	leave  
 128:	c3                   	ret    

00000129 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 129:	55                   	push   %ebp
 12a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 12c:	eb 06                	jmp    134 <strcmp+0xb>
    p++, q++;
 12e:	ff 45 08             	incl   0x8(%ebp)
 131:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	8a 00                	mov    (%eax),%al
 139:	84 c0                	test   %al,%al
 13b:	74 0e                	je     14b <strcmp+0x22>
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	8a 10                	mov    (%eax),%dl
 142:	8b 45 0c             	mov    0xc(%ebp),%eax
 145:	8a 00                	mov    (%eax),%al
 147:	38 c2                	cmp    %al,%dl
 149:	74 e3                	je     12e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	8a 00                	mov    (%eax),%al
 150:	0f b6 d0             	movzbl %al,%edx
 153:	8b 45 0c             	mov    0xc(%ebp),%eax
 156:	8a 00                	mov    (%eax),%al
 158:	0f b6 c0             	movzbl %al,%eax
 15b:	89 d1                	mov    %edx,%ecx
 15d:	29 c1                	sub    %eax,%ecx
 15f:	89 c8                	mov    %ecx,%eax
}
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    

00000163 <strlen>:

uint
strlen(char *s)
{
 163:	55                   	push   %ebp
 164:	89 e5                	mov    %esp,%ebp
 166:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 169:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 170:	eb 03                	jmp    175 <strlen+0x12>
 172:	ff 45 fc             	incl   -0x4(%ebp)
 175:	8b 55 fc             	mov    -0x4(%ebp),%edx
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	01 d0                	add    %edx,%eax
 17d:	8a 00                	mov    (%eax),%al
 17f:	84 c0                	test   %al,%al
 181:	75 ef                	jne    172 <strlen+0xf>
    ;
  return n;
 183:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 186:	c9                   	leave  
 187:	c3                   	ret    

00000188 <memset>:

void*
memset(void *dst, int c, uint n)
{
 188:	55                   	push   %ebp
 189:	89 e5                	mov    %esp,%ebp
 18b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 18e:	8b 45 10             	mov    0x10(%ebp),%eax
 191:	89 44 24 08          	mov    %eax,0x8(%esp)
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	89 44 24 04          	mov    %eax,0x4(%esp)
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	89 04 24             	mov    %eax,(%esp)
 1a2:	e8 2d ff ff ff       	call   d4 <stosb>
  return dst;
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1aa:	c9                   	leave  
 1ab:	c3                   	ret    

000001ac <strchr>:

char*
strchr(const char *s, char c)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	83 ec 04             	sub    $0x4,%esp
 1b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b8:	eb 12                	jmp    1cc <strchr+0x20>
    if(*s == c)
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	8a 00                	mov    (%eax),%al
 1bf:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1c2:	75 05                	jne    1c9 <strchr+0x1d>
      return (char*)s;
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	eb 11                	jmp    1da <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1c9:	ff 45 08             	incl   0x8(%ebp)
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	8a 00                	mov    (%eax),%al
 1d1:	84 c0                	test   %al,%al
 1d3:	75 e5                	jne    1ba <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1da:	c9                   	leave  
 1db:	c3                   	ret    

000001dc <gets>:

char*
gets(char *buf, int max)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1e9:	eb 42                	jmp    22d <gets+0x51>
    cc = read(0, &c, 1);
 1eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1f2:	00 
 1f3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 201:	e8 ee 01 00 00       	call   3f4 <read>
 206:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 209:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 20d:	7e 29                	jle    238 <gets+0x5c>
      break;
    buf[i++] = c;
 20f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 212:	8b 45 08             	mov    0x8(%ebp),%eax
 215:	01 c2                	add    %eax,%edx
 217:	8a 45 ef             	mov    -0x11(%ebp),%al
 21a:	88 02                	mov    %al,(%edx)
 21c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 21f:	8a 45 ef             	mov    -0x11(%ebp),%al
 222:	3c 0a                	cmp    $0xa,%al
 224:	74 13                	je     239 <gets+0x5d>
 226:	8a 45 ef             	mov    -0x11(%ebp),%al
 229:	3c 0d                	cmp    $0xd,%al
 22b:	74 0c                	je     239 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 230:	40                   	inc    %eax
 231:	3b 45 0c             	cmp    0xc(%ebp),%eax
 234:	7c b5                	jl     1eb <gets+0xf>
 236:	eb 01                	jmp    239 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 238:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 239:	8b 55 f4             	mov    -0xc(%ebp),%edx
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	01 d0                	add    %edx,%eax
 241:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 244:	8b 45 08             	mov    0x8(%ebp),%eax
}
 247:	c9                   	leave  
 248:	c3                   	ret    

00000249 <stat>:

int
stat(char *n, struct stat *st)
{
 249:	55                   	push   %ebp
 24a:	89 e5                	mov    %esp,%ebp
 24c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 256:	00 
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	89 04 24             	mov    %eax,(%esp)
 25d:	e8 ba 01 00 00       	call   41c <open>
 262:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 265:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 269:	79 07                	jns    272 <stat+0x29>
    return -1;
 26b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 270:	eb 23                	jmp    295 <stat+0x4c>
  r = fstat(fd, st);
 272:	8b 45 0c             	mov    0xc(%ebp),%eax
 275:	89 44 24 04          	mov    %eax,0x4(%esp)
 279:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27c:	89 04 24             	mov    %eax,(%esp)
 27f:	e8 b0 01 00 00       	call   434 <fstat>
 284:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 287:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28a:	89 04 24             	mov    %eax,(%esp)
 28d:	e8 72 01 00 00       	call   404 <close>
  return r;
 292:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 295:	c9                   	leave  
 296:	c3                   	ret    

00000297 <atoi>:

int
atoi(const char *s)
{
 297:	55                   	push   %ebp
 298:	89 e5                	mov    %esp,%ebp
 29a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 29d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2a4:	eb 21                	jmp    2c7 <atoi+0x30>
    n = n*10 + *s++ - '0';
 2a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2a9:	89 d0                	mov    %edx,%eax
 2ab:	c1 e0 02             	shl    $0x2,%eax
 2ae:	01 d0                	add    %edx,%eax
 2b0:	d1 e0                	shl    %eax
 2b2:	89 c2                	mov    %eax,%edx
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	8a 00                	mov    (%eax),%al
 2b9:	0f be c0             	movsbl %al,%eax
 2bc:	01 d0                	add    %edx,%eax
 2be:	83 e8 30             	sub    $0x30,%eax
 2c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 2c4:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	8a 00                	mov    (%eax),%al
 2cc:	3c 2f                	cmp    $0x2f,%al
 2ce:	7e 09                	jle    2d9 <atoi+0x42>
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	8a 00                	mov    (%eax),%al
 2d5:	3c 39                	cmp    $0x39,%al
 2d7:	7e cd                	jle    2a6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2dc:	c9                   	leave  
 2dd:	c3                   	ret    

000002de <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2f0:	eb 10                	jmp    302 <memmove+0x24>
    *dst++ = *src++;
 2f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2f5:	8a 10                	mov    (%eax),%dl
 2f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2fa:	88 10                	mov    %dl,(%eax)
 2fc:	ff 45 fc             	incl   -0x4(%ebp)
 2ff:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 302:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 306:	0f 9f c0             	setg   %al
 309:	ff 4d 10             	decl   0x10(%ebp)
 30c:	84 c0                	test   %al,%al
 30e:	75 e2                	jne    2f2 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 310:	8b 45 08             	mov    0x8(%ebp),%eax
}
 313:	c9                   	leave  
 314:	c3                   	ret    

00000315 <strtok>:

char*
strtok(char *teststr, char ch)
{
 315:	55                   	push   %ebp
 316:	89 e5                	mov    %esp,%ebp
 318:	83 ec 24             	sub    $0x24,%esp
 31b:	8b 45 0c             	mov    0xc(%ebp),%eax
 31e:	88 45 dc             	mov    %al,-0x24(%ebp)
    char *dummystr = NULL;
 321:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    char *start = NULL;
 328:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    char *end = NULL;
 32f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char nullch = '\0';
 336:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    char *address_of_null = &nullch;
 33a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 33d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    static char *nexttok;

    if(teststr != NULL)
 340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 344:	74 08                	je     34e <strtok+0x39>
    {
        dummystr = teststr;
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	89 45 fc             	mov    %eax,-0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 34c:	eb 75                	jmp    3c3 <strtok+0xae>
    {
        dummystr = teststr;
    }
    else
    {
        if(*nexttok == '\0')
 34e:	a1 50 0c 00 00       	mov    0xc50,%eax
 353:	8a 00                	mov    (%eax),%al
 355:	84 c0                	test   %al,%al
 357:	75 07                	jne    360 <strtok+0x4b>
            return NULL;
 359:	b8 00 00 00 00       	mov    $0x0,%eax
 35e:	eb 6f                	jmp    3cf <strtok+0xba>
        dummystr = nexttok;
 360:	a1 50 0c 00 00       	mov    0xc50,%eax
 365:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }


    while(dummystr != NULL)
 368:	eb 59                	jmp    3c3 <strtok+0xae>
    {
        //empty string
        if(*dummystr == '\0')
 36a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 36d:	8a 00                	mov    (%eax),%al
 36f:	84 c0                	test   %al,%al
 371:	74 58                	je     3cb <strtok+0xb6>
            break;
        if(*dummystr != ch)
 373:	8b 45 fc             	mov    -0x4(%ebp),%eax
 376:	8a 00                	mov    (%eax),%al
 378:	3a 45 dc             	cmp    -0x24(%ebp),%al
 37b:	74 22                	je     39f <strtok+0x8a>
        {
            if(!start)
 37d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 381:	75 06                	jne    389 <strtok+0x74>
                start = dummystr;
 383:	8b 45 fc             	mov    -0x4(%ebp),%eax
 386:	89 45 f8             	mov    %eax,-0x8(%ebp)

            dummystr++;
 389:	ff 45 fc             	incl   -0x4(%ebp)

            // handle the case where the delimiter is not at the end of the string.
            if(*dummystr == '\0')
 38c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 38f:	8a 00                	mov    (%eax),%al
 391:	84 c0                	test   %al,%al
 393:	75 2e                	jne    3c3 <strtok+0xae>
            {
                nexttok = dummystr;
 395:	8b 45 fc             	mov    -0x4(%ebp),%eax
 398:	a3 50 0c 00 00       	mov    %eax,0xc50
                break;
 39d:	eb 2d                	jmp    3cc <strtok+0xb7>
            }
        }
        else
        {
            if(start)
 39f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 3a3:	74 1b                	je     3c0 <strtok+0xab>
            {
                end = dummystr;
 3a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
                nexttok = dummystr+1;
 3ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ae:	40                   	inc    %eax
 3af:	a3 50 0c 00 00       	mov    %eax,0xc50
                *end = *address_of_null;
 3b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3b7:	8a 10                	mov    (%eax),%dl
 3b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3bc:	88 10                	mov    %dl,(%eax)
                break;
 3be:	eb 0c                	jmp    3cc <strtok+0xb7>
            }
            else
            {
                dummystr++;
 3c0:	ff 45 fc             	incl   -0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 3c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
 3c7:	75 a1                	jne    36a <strtok+0x55>
 3c9:	eb 01                	jmp    3cc <strtok+0xb7>
    {
        //empty string
        if(*dummystr == '\0')
            break;
 3cb:	90                   	nop
                dummystr++;
            }
        }
    }

    return start;
 3cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 3cf:	c9                   	leave  
 3d0:	c3                   	ret    
 3d1:	66 90                	xchg   %ax,%ax
 3d3:	90                   	nop

000003d4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3d4:	b8 01 00 00 00       	mov    $0x1,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <exit>:
SYSCALL(exit)
 3dc:	b8 02 00 00 00       	mov    $0x2,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <wait>:
SYSCALL(wait)
 3e4:	b8 03 00 00 00       	mov    $0x3,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <pipe>:
SYSCALL(pipe)
 3ec:	b8 04 00 00 00       	mov    $0x4,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <read>:
SYSCALL(read)
 3f4:	b8 05 00 00 00       	mov    $0x5,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <write>:
SYSCALL(write)
 3fc:	b8 10 00 00 00       	mov    $0x10,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <close>:
SYSCALL(close)
 404:	b8 15 00 00 00       	mov    $0x15,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <kill>:
SYSCALL(kill)
 40c:	b8 06 00 00 00       	mov    $0x6,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <exec>:
SYSCALL(exec)
 414:	b8 07 00 00 00       	mov    $0x7,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <open>:
SYSCALL(open)
 41c:	b8 0f 00 00 00       	mov    $0xf,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <mknod>:
SYSCALL(mknod)
 424:	b8 11 00 00 00       	mov    $0x11,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <unlink>:
SYSCALL(unlink)
 42c:	b8 12 00 00 00       	mov    $0x12,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <fstat>:
SYSCALL(fstat)
 434:	b8 08 00 00 00       	mov    $0x8,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <link>:
SYSCALL(link)
 43c:	b8 13 00 00 00       	mov    $0x13,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <mkdir>:
SYSCALL(mkdir)
 444:	b8 14 00 00 00       	mov    $0x14,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <chdir>:
SYSCALL(chdir)
 44c:	b8 09 00 00 00       	mov    $0x9,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <dup>:
SYSCALL(dup)
 454:	b8 0a 00 00 00       	mov    $0xa,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <getpid>:
SYSCALL(getpid)
 45c:	b8 0b 00 00 00       	mov    $0xb,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <sbrk>:
SYSCALL(sbrk)
 464:	b8 0c 00 00 00       	mov    $0xc,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <sleep>:
SYSCALL(sleep)
 46c:	b8 0d 00 00 00       	mov    $0xd,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <uptime>:
SYSCALL(uptime)
 474:	b8 0e 00 00 00       	mov    $0xe,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <add_path>:
SYSCALL(add_path)
 47c:	b8 16 00 00 00       	mov    $0x16,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <wait2>:
SYSCALL(wait2)
 484:	b8 17 00 00 00       	mov    $0x17,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 48c:	55                   	push   %ebp
 48d:	89 e5                	mov    %esp,%ebp
 48f:	83 ec 28             	sub    $0x28,%esp
 492:	8b 45 0c             	mov    0xc(%ebp),%eax
 495:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 498:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 49f:	00 
 4a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a7:	8b 45 08             	mov    0x8(%ebp),%eax
 4aa:	89 04 24             	mov    %eax,(%esp)
 4ad:	e8 4a ff ff ff       	call   3fc <write>
}
 4b2:	c9                   	leave  
 4b3:	c3                   	ret    

000004b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b4:	55                   	push   %ebp
 4b5:	89 e5                	mov    %esp,%ebp
 4b7:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4c1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4c5:	74 17                	je     4de <printint+0x2a>
 4c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4cb:	79 11                	jns    4de <printint+0x2a>
    neg = 1;
 4cd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d7:	f7 d8                	neg    %eax
 4d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4dc:	eb 06                	jmp    4e4 <printint+0x30>
  } else {
    x = xx;
 4de:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f1:	ba 00 00 00 00       	mov    $0x0,%edx
 4f6:	f7 f1                	div    %ecx
 4f8:	89 d0                	mov    %edx,%eax
 4fa:	8a 80 3c 0c 00 00    	mov    0xc3c(%eax),%al
 500:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 503:	8b 55 f4             	mov    -0xc(%ebp),%edx
 506:	01 ca                	add    %ecx,%edx
 508:	88 02                	mov    %al,(%edx)
 50a:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 50d:	8b 55 10             	mov    0x10(%ebp),%edx
 510:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 513:	8b 45 ec             	mov    -0x14(%ebp),%eax
 516:	ba 00 00 00 00       	mov    $0x0,%edx
 51b:	f7 75 d4             	divl   -0x2c(%ebp)
 51e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 521:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 525:	75 c4                	jne    4eb <printint+0x37>
  if(neg)
 527:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 52b:	74 2c                	je     559 <printint+0xa5>
    buf[i++] = '-';
 52d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 530:	8b 45 f4             	mov    -0xc(%ebp),%eax
 533:	01 d0                	add    %edx,%eax
 535:	c6 00 2d             	movb   $0x2d,(%eax)
 538:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 53b:	eb 1c                	jmp    559 <printint+0xa5>
    putc(fd, buf[i]);
 53d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 540:	8b 45 f4             	mov    -0xc(%ebp),%eax
 543:	01 d0                	add    %edx,%eax
 545:	8a 00                	mov    (%eax),%al
 547:	0f be c0             	movsbl %al,%eax
 54a:	89 44 24 04          	mov    %eax,0x4(%esp)
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	89 04 24             	mov    %eax,(%esp)
 554:	e8 33 ff ff ff       	call   48c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 559:	ff 4d f4             	decl   -0xc(%ebp)
 55c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 560:	79 db                	jns    53d <printint+0x89>
    putc(fd, buf[i]);
}
 562:	c9                   	leave  
 563:	c3                   	ret    

00000564 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 564:	55                   	push   %ebp
 565:	89 e5                	mov    %esp,%ebp
 567:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 56a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 571:	8d 45 0c             	lea    0xc(%ebp),%eax
 574:	83 c0 04             	add    $0x4,%eax
 577:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 57a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 581:	e9 78 01 00 00       	jmp    6fe <printf+0x19a>
    c = fmt[i] & 0xff;
 586:	8b 55 0c             	mov    0xc(%ebp),%edx
 589:	8b 45 f0             	mov    -0x10(%ebp),%eax
 58c:	01 d0                	add    %edx,%eax
 58e:	8a 00                	mov    (%eax),%al
 590:	0f be c0             	movsbl %al,%eax
 593:	25 ff 00 00 00       	and    $0xff,%eax
 598:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 59b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 59f:	75 2c                	jne    5cd <printf+0x69>
      if(c == '%'){
 5a1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a5:	75 0c                	jne    5b3 <printf+0x4f>
        state = '%';
 5a7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ae:	e9 48 01 00 00       	jmp    6fb <printf+0x197>
      } else {
        putc(fd, c);
 5b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b6:	0f be c0             	movsbl %al,%eax
 5b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bd:	8b 45 08             	mov    0x8(%ebp),%eax
 5c0:	89 04 24             	mov    %eax,(%esp)
 5c3:	e8 c4 fe ff ff       	call   48c <putc>
 5c8:	e9 2e 01 00 00       	jmp    6fb <printf+0x197>
      }
    } else if(state == '%'){
 5cd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5d1:	0f 85 24 01 00 00    	jne    6fb <printf+0x197>
      if(c == 'd'){
 5d7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5db:	75 2d                	jne    60a <printf+0xa6>
        printint(fd, *ap, 10, 1);
 5dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e0:	8b 00                	mov    (%eax),%eax
 5e2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5e9:	00 
 5ea:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5f1:	00 
 5f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f6:	8b 45 08             	mov    0x8(%ebp),%eax
 5f9:	89 04 24             	mov    %eax,(%esp)
 5fc:	e8 b3 fe ff ff       	call   4b4 <printint>
        ap++;
 601:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 605:	e9 ea 00 00 00       	jmp    6f4 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 60a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 60e:	74 06                	je     616 <printf+0xb2>
 610:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 614:	75 2d                	jne    643 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 616:	8b 45 e8             	mov    -0x18(%ebp),%eax
 619:	8b 00                	mov    (%eax),%eax
 61b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 622:	00 
 623:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 62a:	00 
 62b:	89 44 24 04          	mov    %eax,0x4(%esp)
 62f:	8b 45 08             	mov    0x8(%ebp),%eax
 632:	89 04 24             	mov    %eax,(%esp)
 635:	e8 7a fe ff ff       	call   4b4 <printint>
        ap++;
 63a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63e:	e9 b1 00 00 00       	jmp    6f4 <printf+0x190>
      } else if(c == 's'){
 643:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 647:	75 43                	jne    68c <printf+0x128>
        s = (char*)*ap;
 649:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 651:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 655:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 659:	75 25                	jne    680 <printf+0x11c>
          s = "(null)";
 65b:	c7 45 f4 d7 09 00 00 	movl   $0x9d7,-0xc(%ebp)
        while(*s != 0){
 662:	eb 1c                	jmp    680 <printf+0x11c>
          putc(fd, *s);
 664:	8b 45 f4             	mov    -0xc(%ebp),%eax
 667:	8a 00                	mov    (%eax),%al
 669:	0f be c0             	movsbl %al,%eax
 66c:	89 44 24 04          	mov    %eax,0x4(%esp)
 670:	8b 45 08             	mov    0x8(%ebp),%eax
 673:	89 04 24             	mov    %eax,(%esp)
 676:	e8 11 fe ff ff       	call   48c <putc>
          s++;
 67b:	ff 45 f4             	incl   -0xc(%ebp)
 67e:	eb 01                	jmp    681 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 680:	90                   	nop
 681:	8b 45 f4             	mov    -0xc(%ebp),%eax
 684:	8a 00                	mov    (%eax),%al
 686:	84 c0                	test   %al,%al
 688:	75 da                	jne    664 <printf+0x100>
 68a:	eb 68                	jmp    6f4 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 68c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 690:	75 1d                	jne    6af <printf+0x14b>
        putc(fd, *ap);
 692:	8b 45 e8             	mov    -0x18(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	0f be c0             	movsbl %al,%eax
 69a:	89 44 24 04          	mov    %eax,0x4(%esp)
 69e:	8b 45 08             	mov    0x8(%ebp),%eax
 6a1:	89 04 24             	mov    %eax,(%esp)
 6a4:	e8 e3 fd ff ff       	call   48c <putc>
        ap++;
 6a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ad:	eb 45                	jmp    6f4 <printf+0x190>
      } else if(c == '%'){
 6af:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b3:	75 17                	jne    6cc <printf+0x168>
        putc(fd, c);
 6b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b8:	0f be c0             	movsbl %al,%eax
 6bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bf:	8b 45 08             	mov    0x8(%ebp),%eax
 6c2:	89 04 24             	mov    %eax,(%esp)
 6c5:	e8 c2 fd ff ff       	call   48c <putc>
 6ca:	eb 28                	jmp    6f4 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6cc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6d3:	00 
 6d4:	8b 45 08             	mov    0x8(%ebp),%eax
 6d7:	89 04 24             	mov    %eax,(%esp)
 6da:	e8 ad fd ff ff       	call   48c <putc>
        putc(fd, c);
 6df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e2:	0f be c0             	movsbl %al,%eax
 6e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ec:	89 04 24             	mov    %eax,(%esp)
 6ef:	e8 98 fd ff ff       	call   48c <putc>
      }
      state = 0;
 6f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6fb:	ff 45 f0             	incl   -0x10(%ebp)
 6fe:	8b 55 0c             	mov    0xc(%ebp),%edx
 701:	8b 45 f0             	mov    -0x10(%ebp),%eax
 704:	01 d0                	add    %edx,%eax
 706:	8a 00                	mov    (%eax),%al
 708:	84 c0                	test   %al,%al
 70a:	0f 85 76 fe ff ff    	jne    586 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 710:	c9                   	leave  
 711:	c3                   	ret    
 712:	66 90                	xchg   %ax,%ax

00000714 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 714:	55                   	push   %ebp
 715:	89 e5                	mov    %esp,%ebp
 717:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71a:	8b 45 08             	mov    0x8(%ebp),%eax
 71d:	83 e8 08             	sub    $0x8,%eax
 720:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 723:	a1 5c 0c 00 00       	mov    0xc5c,%eax
 728:	89 45 fc             	mov    %eax,-0x4(%ebp)
 72b:	eb 24                	jmp    751 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 735:	77 12                	ja     749 <free+0x35>
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73d:	77 24                	ja     763 <free+0x4f>
 73f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 742:	8b 00                	mov    (%eax),%eax
 744:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 747:	77 1a                	ja     763 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 749:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74c:	8b 00                	mov    (%eax),%eax
 74e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 751:	8b 45 f8             	mov    -0x8(%ebp),%eax
 754:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 757:	76 d4                	jbe    72d <free+0x19>
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	8b 00                	mov    (%eax),%eax
 75e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 761:	76 ca                	jbe    72d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	8b 40 04             	mov    0x4(%eax),%eax
 769:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 770:	8b 45 f8             	mov    -0x8(%ebp),%eax
 773:	01 c2                	add    %eax,%edx
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	8b 00                	mov    (%eax),%eax
 77a:	39 c2                	cmp    %eax,%edx
 77c:	75 24                	jne    7a2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 77e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 781:	8b 50 04             	mov    0x4(%eax),%edx
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	8b 00                	mov    (%eax),%eax
 789:	8b 40 04             	mov    0x4(%eax),%eax
 78c:	01 c2                	add    %eax,%edx
 78e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 791:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	8b 00                	mov    (%eax),%eax
 799:	8b 10                	mov    (%eax),%edx
 79b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79e:	89 10                	mov    %edx,(%eax)
 7a0:	eb 0a                	jmp    7ac <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a5:	8b 10                	mov    (%eax),%edx
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7aa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	01 d0                	add    %edx,%eax
 7be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c1:	75 20                	jne    7e3 <free+0xcf>
    p->s.size += bp->s.size;
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	8b 50 04             	mov    0x4(%eax),%edx
 7c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cc:	8b 40 04             	mov    0x4(%eax),%eax
 7cf:	01 c2                	add    %eax,%edx
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7da:	8b 10                	mov    (%eax),%edx
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	89 10                	mov    %edx,(%eax)
 7e1:	eb 08                	jmp    7eb <free+0xd7>
  } else
    p->s.ptr = bp;
 7e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e9:	89 10                	mov    %edx,(%eax)
  freep = p;
 7eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ee:	a3 5c 0c 00 00       	mov    %eax,0xc5c
}
 7f3:	c9                   	leave  
 7f4:	c3                   	ret    

000007f5 <morecore>:

static Header*
morecore(uint nu)
{
 7f5:	55                   	push   %ebp
 7f6:	89 e5                	mov    %esp,%ebp
 7f8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7fb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 802:	77 07                	ja     80b <morecore+0x16>
    nu = 4096;
 804:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 80b:	8b 45 08             	mov    0x8(%ebp),%eax
 80e:	c1 e0 03             	shl    $0x3,%eax
 811:	89 04 24             	mov    %eax,(%esp)
 814:	e8 4b fc ff ff       	call   464 <sbrk>
 819:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 81c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 820:	75 07                	jne    829 <morecore+0x34>
    return 0;
 822:	b8 00 00 00 00       	mov    $0x0,%eax
 827:	eb 22                	jmp    84b <morecore+0x56>
  hp = (Header*)p;
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 82f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 832:	8b 55 08             	mov    0x8(%ebp),%edx
 835:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 838:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83b:	83 c0 08             	add    $0x8,%eax
 83e:	89 04 24             	mov    %eax,(%esp)
 841:	e8 ce fe ff ff       	call   714 <free>
  return freep;
 846:	a1 5c 0c 00 00       	mov    0xc5c,%eax
}
 84b:	c9                   	leave  
 84c:	c3                   	ret    

0000084d <malloc>:

void*
malloc(uint nbytes)
{
 84d:	55                   	push   %ebp
 84e:	89 e5                	mov    %esp,%ebp
 850:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 853:	8b 45 08             	mov    0x8(%ebp),%eax
 856:	83 c0 07             	add    $0x7,%eax
 859:	c1 e8 03             	shr    $0x3,%eax
 85c:	40                   	inc    %eax
 85d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 860:	a1 5c 0c 00 00       	mov    0xc5c,%eax
 865:	89 45 f0             	mov    %eax,-0x10(%ebp)
 868:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 86c:	75 23                	jne    891 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 86e:	c7 45 f0 54 0c 00 00 	movl   $0xc54,-0x10(%ebp)
 875:	8b 45 f0             	mov    -0x10(%ebp),%eax
 878:	a3 5c 0c 00 00       	mov    %eax,0xc5c
 87d:	a1 5c 0c 00 00       	mov    0xc5c,%eax
 882:	a3 54 0c 00 00       	mov    %eax,0xc54
    base.s.size = 0;
 887:	c7 05 58 0c 00 00 00 	movl   $0x0,0xc58
 88e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 891:	8b 45 f0             	mov    -0x10(%ebp),%eax
 894:	8b 00                	mov    (%eax),%eax
 896:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	8b 40 04             	mov    0x4(%eax),%eax
 89f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a2:	72 4d                	jb     8f1 <malloc+0xa4>
      if(p->s.size == nunits)
 8a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a7:	8b 40 04             	mov    0x4(%eax),%eax
 8aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ad:	75 0c                	jne    8bb <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 8af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b2:	8b 10                	mov    (%eax),%edx
 8b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b7:	89 10                	mov    %edx,(%eax)
 8b9:	eb 26                	jmp    8e1 <malloc+0x94>
      else {
        p->s.size -= nunits;
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	8b 40 04             	mov    0x4(%eax),%eax
 8c1:	89 c2                	mov    %eax,%edx
 8c3:	2b 55 ec             	sub    -0x14(%ebp),%edx
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cf:	8b 40 04             	mov    0x4(%eax),%eax
 8d2:	c1 e0 03             	shl    $0x3,%eax
 8d5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8de:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e4:	a3 5c 0c 00 00       	mov    %eax,0xc5c
      return (void*)(p + 1);
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	83 c0 08             	add    $0x8,%eax
 8ef:	eb 38                	jmp    929 <malloc+0xdc>
    }
    if(p == freep)
 8f1:	a1 5c 0c 00 00       	mov    0xc5c,%eax
 8f6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8f9:	75 1b                	jne    916 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 8fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8fe:	89 04 24             	mov    %eax,(%esp)
 901:	e8 ef fe ff ff       	call   7f5 <morecore>
 906:	89 45 f4             	mov    %eax,-0xc(%ebp)
 909:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 90d:	75 07                	jne    916 <malloc+0xc9>
        return 0;
 90f:	b8 00 00 00 00       	mov    $0x0,%eax
 914:	eb 13                	jmp    929 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	89 45 f0             	mov    %eax,-0x10(%ebp)
 91c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91f:	8b 00                	mov    (%eax),%eax
 921:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 924:	e9 70 ff ff ff       	jmp    899 <malloc+0x4c>
}
 929:	c9                   	leave  
 92a:	c3                   	ret    
