
_ln:     file format elf32-i386


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
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 d3 08 00 	movl   $0x8d3,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 e9 04 00 00       	call   50c <printf>
    exit();
  23:	e8 5c 03 00 00       	call   384 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 a0 03 00 00       	call   3e4 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 e6 08 00 	movl   $0x8e6,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 98 04 00 00       	call   50c <printf>
  exit();
  74:	e8 0b 03 00 00       	call   384 <exit>
  79:	66 90                	xchg   %ax,%ax
  7b:	90                   	nop

0000007c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	57                   	push   %edi
  80:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  84:	8b 55 10             	mov    0x10(%ebp),%edx
  87:	8b 45 0c             	mov    0xc(%ebp),%eax
  8a:	89 cb                	mov    %ecx,%ebx
  8c:	89 df                	mov    %ebx,%edi
  8e:	89 d1                	mov    %edx,%ecx
  90:	fc                   	cld    
  91:	f3 aa                	rep stos %al,%es:(%edi)
  93:	89 ca                	mov    %ecx,%edx
  95:	89 fb                	mov    %edi,%ebx
  97:	89 5d 08             	mov    %ebx,0x8(%ebp)
  9a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9d:	5b                   	pop    %ebx
  9e:	5f                   	pop    %edi
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    

000000a1 <strcpy>:

#define NULL   0

char*
strcpy(char *s, char *t)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ad:	90                   	nop
  ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  b1:	8a 10                	mov    (%eax),%dl
  b3:	8b 45 08             	mov    0x8(%ebp),%eax
  b6:	88 10                	mov    %dl,(%eax)
  b8:	8b 45 08             	mov    0x8(%ebp),%eax
  bb:	8a 00                	mov    (%eax),%al
  bd:	84 c0                	test   %al,%al
  bf:	0f 95 c0             	setne  %al
  c2:	ff 45 08             	incl   0x8(%ebp)
  c5:	ff 45 0c             	incl   0xc(%ebp)
  c8:	84 c0                	test   %al,%al
  ca:	75 e2                	jne    ae <strcpy+0xd>
    ;
  return os;
  cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  cf:	c9                   	leave  
  d0:	c3                   	ret    

000000d1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d1:	55                   	push   %ebp
  d2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d4:	eb 06                	jmp    dc <strcmp+0xb>
    p++, q++;
  d6:	ff 45 08             	incl   0x8(%ebp)
  d9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	8a 00                	mov    (%eax),%al
  e1:	84 c0                	test   %al,%al
  e3:	74 0e                	je     f3 <strcmp+0x22>
  e5:	8b 45 08             	mov    0x8(%ebp),%eax
  e8:	8a 10                	mov    (%eax),%dl
  ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  ed:	8a 00                	mov    (%eax),%al
  ef:	38 c2                	cmp    %al,%dl
  f1:	74 e3                	je     d6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	8a 00                	mov    (%eax),%al
  f8:	0f b6 d0             	movzbl %al,%edx
  fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  fe:	8a 00                	mov    (%eax),%al
 100:	0f b6 c0             	movzbl %al,%eax
 103:	89 d1                	mov    %edx,%ecx
 105:	29 c1                	sub    %eax,%ecx
 107:	89 c8                	mov    %ecx,%eax
}
 109:	5d                   	pop    %ebp
 10a:	c3                   	ret    

0000010b <strlen>:

uint
strlen(char *s)
{
 10b:	55                   	push   %ebp
 10c:	89 e5                	mov    %esp,%ebp
 10e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 111:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 118:	eb 03                	jmp    11d <strlen+0x12>
 11a:	ff 45 fc             	incl   -0x4(%ebp)
 11d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	01 d0                	add    %edx,%eax
 125:	8a 00                	mov    (%eax),%al
 127:	84 c0                	test   %al,%al
 129:	75 ef                	jne    11a <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 136:	8b 45 10             	mov    0x10(%ebp),%eax
 139:	89 44 24 08          	mov    %eax,0x8(%esp)
 13d:	8b 45 0c             	mov    0xc(%ebp),%eax
 140:	89 44 24 04          	mov    %eax,0x4(%esp)
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	89 04 24             	mov    %eax,(%esp)
 14a:	e8 2d ff ff ff       	call   7c <stosb>
  return dst;
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <strchr>:

char*
strchr(const char *s, char c)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	83 ec 04             	sub    $0x4,%esp
 15a:	8b 45 0c             	mov    0xc(%ebp),%eax
 15d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 160:	eb 12                	jmp    174 <strchr+0x20>
    if(*s == c)
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	8a 00                	mov    (%eax),%al
 167:	3a 45 fc             	cmp    -0x4(%ebp),%al
 16a:	75 05                	jne    171 <strchr+0x1d>
      return (char*)s;
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	eb 11                	jmp    182 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 171:	ff 45 08             	incl   0x8(%ebp)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	8a 00                	mov    (%eax),%al
 179:	84 c0                	test   %al,%al
 17b:	75 e5                	jne    162 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 17d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 182:	c9                   	leave  
 183:	c3                   	ret    

00000184 <gets>:

char*
gets(char *buf, int max)
{
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 191:	eb 42                	jmp    1d5 <gets+0x51>
    cc = read(0, &c, 1);
 193:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 19a:	00 
 19b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 19e:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a9:	e8 ee 01 00 00       	call   39c <read>
 1ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b5:	7e 29                	jle    1e0 <gets+0x5c>
      break;
    buf[i++] = c;
 1b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 c2                	add    %eax,%edx
 1bf:	8a 45 ef             	mov    -0x11(%ebp),%al
 1c2:	88 02                	mov    %al,(%edx)
 1c4:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1c7:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ca:	3c 0a                	cmp    $0xa,%al
 1cc:	74 13                	je     1e1 <gets+0x5d>
 1ce:	8a 45 ef             	mov    -0x11(%ebp),%al
 1d1:	3c 0d                	cmp    $0xd,%al
 1d3:	74 0c                	je     1e1 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d8:	40                   	inc    %eax
 1d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1dc:	7c b5                	jl     193 <gets+0xf>
 1de:	eb 01                	jmp    1e1 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1e0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	01 d0                	add    %edx,%eax
 1e9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <stat>:

int
stat(char *n, struct stat *st)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1fe:	00 
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	89 04 24             	mov    %eax,(%esp)
 205:	e8 ba 01 00 00       	call   3c4 <open>
 20a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 20d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 211:	79 07                	jns    21a <stat+0x29>
    return -1;
 213:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 218:	eb 23                	jmp    23d <stat+0x4c>
  r = fstat(fd, st);
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	89 44 24 04          	mov    %eax,0x4(%esp)
 221:	8b 45 f4             	mov    -0xc(%ebp),%eax
 224:	89 04 24             	mov    %eax,(%esp)
 227:	e8 b0 01 00 00       	call   3dc <fstat>
 22c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 22f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 232:	89 04 24             	mov    %eax,(%esp)
 235:	e8 72 01 00 00       	call   3ac <close>
  return r;
 23a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23d:	c9                   	leave  
 23e:	c3                   	ret    

0000023f <atoi>:

int
atoi(const char *s)
{
 23f:	55                   	push   %ebp
 240:	89 e5                	mov    %esp,%ebp
 242:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24c:	eb 21                	jmp    26f <atoi+0x30>
    n = n*10 + *s++ - '0';
 24e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 251:	89 d0                	mov    %edx,%eax
 253:	c1 e0 02             	shl    $0x2,%eax
 256:	01 d0                	add    %edx,%eax
 258:	d1 e0                	shl    %eax
 25a:	89 c2                	mov    %eax,%edx
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	8a 00                	mov    (%eax),%al
 261:	0f be c0             	movsbl %al,%eax
 264:	01 d0                	add    %edx,%eax
 266:	83 e8 30             	sub    $0x30,%eax
 269:	89 45 fc             	mov    %eax,-0x4(%ebp)
 26c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	8a 00                	mov    (%eax),%al
 274:	3c 2f                	cmp    $0x2f,%al
 276:	7e 09                	jle    281 <atoi+0x42>
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	8a 00                	mov    (%eax),%al
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e cd                	jle    24e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 298:	eb 10                	jmp    2aa <memmove+0x24>
    *dst++ = *src++;
 29a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 29d:	8a 10                	mov    (%eax),%dl
 29f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a2:	88 10                	mov    %dl,(%eax)
 2a4:	ff 45 fc             	incl   -0x4(%ebp)
 2a7:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2ae:	0f 9f c0             	setg   %al
 2b1:	ff 4d 10             	decl   0x10(%ebp)
 2b4:	84 c0                	test   %al,%al
 2b6:	75 e2                	jne    29a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bb:	c9                   	leave  
 2bc:	c3                   	ret    

000002bd <strtok>:

char*
strtok(char *teststr, char ch)
{
 2bd:	55                   	push   %ebp
 2be:	89 e5                	mov    %esp,%ebp
 2c0:	83 ec 24             	sub    $0x24,%esp
 2c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c6:	88 45 dc             	mov    %al,-0x24(%ebp)
    char *dummystr = NULL;
 2c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    char *start = NULL;
 2d0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    char *end = NULL;
 2d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char nullch = '\0';
 2de:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    char *address_of_null = &nullch;
 2e2:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    static char *nexttok;

    if(teststr != NULL)
 2e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2ec:	74 08                	je     2f6 <strtok+0x39>
    {
        dummystr = teststr;
 2ee:	8b 45 08             	mov    0x8(%ebp),%eax
 2f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 2f4:	eb 75                	jmp    36b <strtok+0xae>
    {
        dummystr = teststr;
    }
    else
    {
        if(*nexttok == '\0')
 2f6:	a1 74 0b 00 00       	mov    0xb74,%eax
 2fb:	8a 00                	mov    (%eax),%al
 2fd:	84 c0                	test   %al,%al
 2ff:	75 07                	jne    308 <strtok+0x4b>
            return NULL;
 301:	b8 00 00 00 00       	mov    $0x0,%eax
 306:	eb 6f                	jmp    377 <strtok+0xba>
        dummystr = nexttok;
 308:	a1 74 0b 00 00       	mov    0xb74,%eax
 30d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }


    while(dummystr != NULL)
 310:	eb 59                	jmp    36b <strtok+0xae>
    {
        //empty string
        if(*dummystr == '\0')
 312:	8b 45 fc             	mov    -0x4(%ebp),%eax
 315:	8a 00                	mov    (%eax),%al
 317:	84 c0                	test   %al,%al
 319:	74 58                	je     373 <strtok+0xb6>
            break;
        if(*dummystr != ch)
 31b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 31e:	8a 00                	mov    (%eax),%al
 320:	3a 45 dc             	cmp    -0x24(%ebp),%al
 323:	74 22                	je     347 <strtok+0x8a>
        {
            if(!start)
 325:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 329:	75 06                	jne    331 <strtok+0x74>
                start = dummystr;
 32b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 32e:	89 45 f8             	mov    %eax,-0x8(%ebp)

            dummystr++;
 331:	ff 45 fc             	incl   -0x4(%ebp)

            // handle the case where the delimiter is not at the end of the string.
            if(*dummystr == '\0')
 334:	8b 45 fc             	mov    -0x4(%ebp),%eax
 337:	8a 00                	mov    (%eax),%al
 339:	84 c0                	test   %al,%al
 33b:	75 2e                	jne    36b <strtok+0xae>
            {
                nexttok = dummystr;
 33d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 340:	a3 74 0b 00 00       	mov    %eax,0xb74
                break;
 345:	eb 2d                	jmp    374 <strtok+0xb7>
            }
        }
        else
        {
            if(start)
 347:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 34b:	74 1b                	je     368 <strtok+0xab>
            {
                end = dummystr;
 34d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 350:	89 45 f4             	mov    %eax,-0xc(%ebp)
                nexttok = dummystr+1;
 353:	8b 45 fc             	mov    -0x4(%ebp),%eax
 356:	40                   	inc    %eax
 357:	a3 74 0b 00 00       	mov    %eax,0xb74
                *end = *address_of_null;
 35c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 35f:	8a 10                	mov    (%eax),%dl
 361:	8b 45 f4             	mov    -0xc(%ebp),%eax
 364:	88 10                	mov    %dl,(%eax)
                break;
 366:	eb 0c                	jmp    374 <strtok+0xb7>
            }
            else
            {
                dummystr++;
 368:	ff 45 fc             	incl   -0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 36b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
 36f:	75 a1                	jne    312 <strtok+0x55>
 371:	eb 01                	jmp    374 <strtok+0xb7>
    {
        //empty string
        if(*dummystr == '\0')
            break;
 373:	90                   	nop
                dummystr++;
            }
        }
    }

    return start;
 374:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 377:	c9                   	leave  
 378:	c3                   	ret    
 379:	66 90                	xchg   %ax,%ax
 37b:	90                   	nop

0000037c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37c:	b8 01 00 00 00       	mov    $0x1,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <exit>:
SYSCALL(exit)
 384:	b8 02 00 00 00       	mov    $0x2,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <wait>:
SYSCALL(wait)
 38c:	b8 03 00 00 00       	mov    $0x3,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <pipe>:
SYSCALL(pipe)
 394:	b8 04 00 00 00       	mov    $0x4,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <read>:
SYSCALL(read)
 39c:	b8 05 00 00 00       	mov    $0x5,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <write>:
SYSCALL(write)
 3a4:	b8 10 00 00 00       	mov    $0x10,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <close>:
SYSCALL(close)
 3ac:	b8 15 00 00 00       	mov    $0x15,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <kill>:
SYSCALL(kill)
 3b4:	b8 06 00 00 00       	mov    $0x6,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <exec>:
SYSCALL(exec)
 3bc:	b8 07 00 00 00       	mov    $0x7,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <open>:
SYSCALL(open)
 3c4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <mknod>:
SYSCALL(mknod)
 3cc:	b8 11 00 00 00       	mov    $0x11,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <unlink>:
SYSCALL(unlink)
 3d4:	b8 12 00 00 00       	mov    $0x12,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <fstat>:
SYSCALL(fstat)
 3dc:	b8 08 00 00 00       	mov    $0x8,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <link>:
SYSCALL(link)
 3e4:	b8 13 00 00 00       	mov    $0x13,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <mkdir>:
SYSCALL(mkdir)
 3ec:	b8 14 00 00 00       	mov    $0x14,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <chdir>:
SYSCALL(chdir)
 3f4:	b8 09 00 00 00       	mov    $0x9,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <dup>:
SYSCALL(dup)
 3fc:	b8 0a 00 00 00       	mov    $0xa,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <getpid>:
SYSCALL(getpid)
 404:	b8 0b 00 00 00       	mov    $0xb,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <sbrk>:
SYSCALL(sbrk)
 40c:	b8 0c 00 00 00       	mov    $0xc,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <sleep>:
SYSCALL(sleep)
 414:	b8 0d 00 00 00       	mov    $0xd,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <uptime>:
SYSCALL(uptime)
 41c:	b8 0e 00 00 00       	mov    $0xe,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <add_path>:
SYSCALL(add_path)
 424:	b8 16 00 00 00       	mov    $0x16,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <wait2>:
SYSCALL(wait2)
 42c:	b8 17 00 00 00       	mov    $0x17,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 28             	sub    $0x28,%esp
 43a:	8b 45 0c             	mov    0xc(%ebp),%eax
 43d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 440:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 447:	00 
 448:	8d 45 f4             	lea    -0xc(%ebp),%eax
 44b:	89 44 24 04          	mov    %eax,0x4(%esp)
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	89 04 24             	mov    %eax,(%esp)
 455:	e8 4a ff ff ff       	call   3a4 <write>
}
 45a:	c9                   	leave  
 45b:	c3                   	ret    

0000045c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45c:	55                   	push   %ebp
 45d:	89 e5                	mov    %esp,%ebp
 45f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 462:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 469:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 46d:	74 17                	je     486 <printint+0x2a>
 46f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 473:	79 11                	jns    486 <printint+0x2a>
    neg = 1;
 475:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 47c:	8b 45 0c             	mov    0xc(%ebp),%eax
 47f:	f7 d8                	neg    %eax
 481:	89 45 ec             	mov    %eax,-0x14(%ebp)
 484:	eb 06                	jmp    48c <printint+0x30>
  } else {
    x = xx;
 486:	8b 45 0c             	mov    0xc(%ebp),%eax
 489:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 48c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 493:	8b 4d 10             	mov    0x10(%ebp),%ecx
 496:	8b 45 ec             	mov    -0x14(%ebp),%eax
 499:	ba 00 00 00 00       	mov    $0x0,%edx
 49e:	f7 f1                	div    %ecx
 4a0:	89 d0                	mov    %edx,%eax
 4a2:	8a 80 60 0b 00 00    	mov    0xb60(%eax),%al
 4a8:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 4ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4ae:	01 ca                	add    %ecx,%edx
 4b0:	88 02                	mov    %al,(%edx)
 4b2:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 4b5:	8b 55 10             	mov    0x10(%ebp),%edx
 4b8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4be:	ba 00 00 00 00       	mov    $0x0,%edx
 4c3:	f7 75 d4             	divl   -0x2c(%ebp)
 4c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4cd:	75 c4                	jne    493 <printint+0x37>
  if(neg)
 4cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4d3:	74 2c                	je     501 <printint+0xa5>
    buf[i++] = '-';
 4d5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4db:	01 d0                	add    %edx,%eax
 4dd:	c6 00 2d             	movb   $0x2d,(%eax)
 4e0:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4e3:	eb 1c                	jmp    501 <printint+0xa5>
    putc(fd, buf[i]);
 4e5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4eb:	01 d0                	add    %edx,%eax
 4ed:	8a 00                	mov    (%eax),%al
 4ef:	0f be c0             	movsbl %al,%eax
 4f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f6:	8b 45 08             	mov    0x8(%ebp),%eax
 4f9:	89 04 24             	mov    %eax,(%esp)
 4fc:	e8 33 ff ff ff       	call   434 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 501:	ff 4d f4             	decl   -0xc(%ebp)
 504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 508:	79 db                	jns    4e5 <printint+0x89>
    putc(fd, buf[i]);
}
 50a:	c9                   	leave  
 50b:	c3                   	ret    

0000050c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 50c:	55                   	push   %ebp
 50d:	89 e5                	mov    %esp,%ebp
 50f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 512:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 519:	8d 45 0c             	lea    0xc(%ebp),%eax
 51c:	83 c0 04             	add    $0x4,%eax
 51f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 522:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 529:	e9 78 01 00 00       	jmp    6a6 <printf+0x19a>
    c = fmt[i] & 0xff;
 52e:	8b 55 0c             	mov    0xc(%ebp),%edx
 531:	8b 45 f0             	mov    -0x10(%ebp),%eax
 534:	01 d0                	add    %edx,%eax
 536:	8a 00                	mov    (%eax),%al
 538:	0f be c0             	movsbl %al,%eax
 53b:	25 ff 00 00 00       	and    $0xff,%eax
 540:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 543:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 547:	75 2c                	jne    575 <printf+0x69>
      if(c == '%'){
 549:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 54d:	75 0c                	jne    55b <printf+0x4f>
        state = '%';
 54f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 556:	e9 48 01 00 00       	jmp    6a3 <printf+0x197>
      } else {
        putc(fd, c);
 55b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55e:	0f be c0             	movsbl %al,%eax
 561:	89 44 24 04          	mov    %eax,0x4(%esp)
 565:	8b 45 08             	mov    0x8(%ebp),%eax
 568:	89 04 24             	mov    %eax,(%esp)
 56b:	e8 c4 fe ff ff       	call   434 <putc>
 570:	e9 2e 01 00 00       	jmp    6a3 <printf+0x197>
      }
    } else if(state == '%'){
 575:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 579:	0f 85 24 01 00 00    	jne    6a3 <printf+0x197>
      if(c == 'd'){
 57f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 583:	75 2d                	jne    5b2 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 585:	8b 45 e8             	mov    -0x18(%ebp),%eax
 588:	8b 00                	mov    (%eax),%eax
 58a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 591:	00 
 592:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 599:	00 
 59a:	89 44 24 04          	mov    %eax,0x4(%esp)
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	89 04 24             	mov    %eax,(%esp)
 5a4:	e8 b3 fe ff ff       	call   45c <printint>
        ap++;
 5a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ad:	e9 ea 00 00 00       	jmp    69c <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 5b2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5b6:	74 06                	je     5be <printf+0xb2>
 5b8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5bc:	75 2d                	jne    5eb <printf+0xdf>
        printint(fd, *ap, 16, 0);
 5be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c1:	8b 00                	mov    (%eax),%eax
 5c3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5ca:	00 
 5cb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5d2:	00 
 5d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d7:	8b 45 08             	mov    0x8(%ebp),%eax
 5da:	89 04 24             	mov    %eax,(%esp)
 5dd:	e8 7a fe ff ff       	call   45c <printint>
        ap++;
 5e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e6:	e9 b1 00 00 00       	jmp    69c <printf+0x190>
      } else if(c == 's'){
 5eb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5ef:	75 43                	jne    634 <printf+0x128>
        s = (char*)*ap;
 5f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f4:	8b 00                	mov    (%eax),%eax
 5f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 601:	75 25                	jne    628 <printf+0x11c>
          s = "(null)";
 603:	c7 45 f4 fa 08 00 00 	movl   $0x8fa,-0xc(%ebp)
        while(*s != 0){
 60a:	eb 1c                	jmp    628 <printf+0x11c>
          putc(fd, *s);
 60c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60f:	8a 00                	mov    (%eax),%al
 611:	0f be c0             	movsbl %al,%eax
 614:	89 44 24 04          	mov    %eax,0x4(%esp)
 618:	8b 45 08             	mov    0x8(%ebp),%eax
 61b:	89 04 24             	mov    %eax,(%esp)
 61e:	e8 11 fe ff ff       	call   434 <putc>
          s++;
 623:	ff 45 f4             	incl   -0xc(%ebp)
 626:	eb 01                	jmp    629 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 628:	90                   	nop
 629:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62c:	8a 00                	mov    (%eax),%al
 62e:	84 c0                	test   %al,%al
 630:	75 da                	jne    60c <printf+0x100>
 632:	eb 68                	jmp    69c <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 634:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 638:	75 1d                	jne    657 <printf+0x14b>
        putc(fd, *ap);
 63a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63d:	8b 00                	mov    (%eax),%eax
 63f:	0f be c0             	movsbl %al,%eax
 642:	89 44 24 04          	mov    %eax,0x4(%esp)
 646:	8b 45 08             	mov    0x8(%ebp),%eax
 649:	89 04 24             	mov    %eax,(%esp)
 64c:	e8 e3 fd ff ff       	call   434 <putc>
        ap++;
 651:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 655:	eb 45                	jmp    69c <printf+0x190>
      } else if(c == '%'){
 657:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 65b:	75 17                	jne    674 <printf+0x168>
        putc(fd, c);
 65d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 660:	0f be c0             	movsbl %al,%eax
 663:	89 44 24 04          	mov    %eax,0x4(%esp)
 667:	8b 45 08             	mov    0x8(%ebp),%eax
 66a:	89 04 24             	mov    %eax,(%esp)
 66d:	e8 c2 fd ff ff       	call   434 <putc>
 672:	eb 28                	jmp    69c <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 674:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 67b:	00 
 67c:	8b 45 08             	mov    0x8(%ebp),%eax
 67f:	89 04 24             	mov    %eax,(%esp)
 682:	e8 ad fd ff ff       	call   434 <putc>
        putc(fd, c);
 687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68a:	0f be c0             	movsbl %al,%eax
 68d:	89 44 24 04          	mov    %eax,0x4(%esp)
 691:	8b 45 08             	mov    0x8(%ebp),%eax
 694:	89 04 24             	mov    %eax,(%esp)
 697:	e8 98 fd ff ff       	call   434 <putc>
      }
      state = 0;
 69c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6a3:	ff 45 f0             	incl   -0x10(%ebp)
 6a6:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ac:	01 d0                	add    %edx,%eax
 6ae:	8a 00                	mov    (%eax),%al
 6b0:	84 c0                	test   %al,%al
 6b2:	0f 85 76 fe ff ff    	jne    52e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6b8:	c9                   	leave  
 6b9:	c3                   	ret    
 6ba:	66 90                	xchg   %ax,%ax

000006bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6bc:	55                   	push   %ebp
 6bd:	89 e5                	mov    %esp,%ebp
 6bf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c2:	8b 45 08             	mov    0x8(%ebp),%eax
 6c5:	83 e8 08             	sub    $0x8,%eax
 6c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6cb:	a1 80 0b 00 00       	mov    0xb80,%eax
 6d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d3:	eb 24                	jmp    6f9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6dd:	77 12                	ja     6f1 <free+0x35>
 6df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e5:	77 24                	ja     70b <free+0x4f>
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 00                	mov    (%eax),%eax
 6ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ef:	77 1a                	ja     70b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ff:	76 d4                	jbe    6d5 <free+0x19>
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 709:	76 ca                	jbe    6d5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 70b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70e:	8b 40 04             	mov    0x4(%eax),%eax
 711:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 718:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71b:	01 c2                	add    %eax,%edx
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 00                	mov    (%eax),%eax
 722:	39 c2                	cmp    %eax,%edx
 724:	75 24                	jne    74a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 726:	8b 45 f8             	mov    -0x8(%ebp),%eax
 729:	8b 50 04             	mov    0x4(%eax),%edx
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	8b 40 04             	mov    0x4(%eax),%eax
 734:	01 c2                	add    %eax,%edx
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	8b 10                	mov    (%eax),%edx
 743:	8b 45 f8             	mov    -0x8(%ebp),%eax
 746:	89 10                	mov    %edx,(%eax)
 748:	eb 0a                	jmp    754 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	8b 10                	mov    (%eax),%edx
 74f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 752:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 40 04             	mov    0x4(%eax),%eax
 75a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 761:	8b 45 fc             	mov    -0x4(%ebp),%eax
 764:	01 d0                	add    %edx,%eax
 766:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 769:	75 20                	jne    78b <free+0xcf>
    p->s.size += bp->s.size;
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	8b 50 04             	mov    0x4(%eax),%edx
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	8b 40 04             	mov    0x4(%eax),%eax
 777:	01 c2                	add    %eax,%edx
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 77f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 782:	8b 10                	mov    (%eax),%edx
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	89 10                	mov    %edx,(%eax)
 789:	eb 08                	jmp    793 <free+0xd7>
  } else
    p->s.ptr = bp;
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 791:	89 10                	mov    %edx,(%eax)
  freep = p;
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	a3 80 0b 00 00       	mov    %eax,0xb80
}
 79b:	c9                   	leave  
 79c:	c3                   	ret    

0000079d <morecore>:

static Header*
morecore(uint nu)
{
 79d:	55                   	push   %ebp
 79e:	89 e5                	mov    %esp,%ebp
 7a0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7a3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7aa:	77 07                	ja     7b3 <morecore+0x16>
    nu = 4096;
 7ac:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7b3:	8b 45 08             	mov    0x8(%ebp),%eax
 7b6:	c1 e0 03             	shl    $0x3,%eax
 7b9:	89 04 24             	mov    %eax,(%esp)
 7bc:	e8 4b fc ff ff       	call   40c <sbrk>
 7c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7c4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c8:	75 07                	jne    7d1 <morecore+0x34>
    return 0;
 7ca:	b8 00 00 00 00       	mov    $0x0,%eax
 7cf:	eb 22                	jmp    7f3 <morecore+0x56>
  hp = (Header*)p;
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7da:	8b 55 08             	mov    0x8(%ebp),%edx
 7dd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e3:	83 c0 08             	add    $0x8,%eax
 7e6:	89 04 24             	mov    %eax,(%esp)
 7e9:	e8 ce fe ff ff       	call   6bc <free>
  return freep;
 7ee:	a1 80 0b 00 00       	mov    0xb80,%eax
}
 7f3:	c9                   	leave  
 7f4:	c3                   	ret    

000007f5 <malloc>:

void*
malloc(uint nbytes)
{
 7f5:	55                   	push   %ebp
 7f6:	89 e5                	mov    %esp,%ebp
 7f8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fb:	8b 45 08             	mov    0x8(%ebp),%eax
 7fe:	83 c0 07             	add    $0x7,%eax
 801:	c1 e8 03             	shr    $0x3,%eax
 804:	40                   	inc    %eax
 805:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 808:	a1 80 0b 00 00       	mov    0xb80,%eax
 80d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 810:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 814:	75 23                	jne    839 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 816:	c7 45 f0 78 0b 00 00 	movl   $0xb78,-0x10(%ebp)
 81d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 820:	a3 80 0b 00 00       	mov    %eax,0xb80
 825:	a1 80 0b 00 00       	mov    0xb80,%eax
 82a:	a3 78 0b 00 00       	mov    %eax,0xb78
    base.s.size = 0;
 82f:	c7 05 7c 0b 00 00 00 	movl   $0x0,0xb7c
 836:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 839:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83c:	8b 00                	mov    (%eax),%eax
 83e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 841:	8b 45 f4             	mov    -0xc(%ebp),%eax
 844:	8b 40 04             	mov    0x4(%eax),%eax
 847:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 84a:	72 4d                	jb     899 <malloc+0xa4>
      if(p->s.size == nunits)
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	8b 40 04             	mov    0x4(%eax),%eax
 852:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 855:	75 0c                	jne    863 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 857:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85a:	8b 10                	mov    (%eax),%edx
 85c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85f:	89 10                	mov    %edx,(%eax)
 861:	eb 26                	jmp    889 <malloc+0x94>
      else {
        p->s.size -= nunits;
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	8b 40 04             	mov    0x4(%eax),%eax
 869:	89 c2                	mov    %eax,%edx
 86b:	2b 55 ec             	sub    -0x14(%ebp),%edx
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	8b 40 04             	mov    0x4(%eax),%eax
 87a:	c1 e0 03             	shl    $0x3,%eax
 87d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	8b 55 ec             	mov    -0x14(%ebp),%edx
 886:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 889:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88c:	a3 80 0b 00 00       	mov    %eax,0xb80
      return (void*)(p + 1);
 891:	8b 45 f4             	mov    -0xc(%ebp),%eax
 894:	83 c0 08             	add    $0x8,%eax
 897:	eb 38                	jmp    8d1 <malloc+0xdc>
    }
    if(p == freep)
 899:	a1 80 0b 00 00       	mov    0xb80,%eax
 89e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a1:	75 1b                	jne    8be <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 8a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8a6:	89 04 24             	mov    %eax,(%esp)
 8a9:	e8 ef fe ff ff       	call   79d <morecore>
 8ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b5:	75 07                	jne    8be <malloc+0xc9>
        return 0;
 8b7:	b8 00 00 00 00       	mov    $0x0,%eax
 8bc:	eb 13                	jmp    8d1 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	8b 00                	mov    (%eax),%eax
 8c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8cc:	e9 70 ff ff ff       	jmp    841 <malloc+0x4c>
}
 8d1:	c9                   	leave  
 8d2:	c3                   	ret    
