
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
   9:	e8 16 03 00 00       	call   324 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 9e 03 00 00       	call   3bc <sleep>
  exit();
  1e:	e8 09 03 00 00       	call   32c <exit>
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

#define NULL   0

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
 151:	e8 ee 01 00 00       	call   344 <read>
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
 1ad:	e8 ba 01 00 00       	call   36c <open>
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
 1cf:	e8 b0 01 00 00       	call   384 <fstat>
 1d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1da:	89 04 24             	mov    %eax,(%esp)
 1dd:	e8 72 01 00 00       	call   354 <close>
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

00000265 <strtok>:

char*
strtok(char *teststr, char ch)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	83 ec 24             	sub    $0x24,%esp
 26b:	8b 45 0c             	mov    0xc(%ebp),%eax
 26e:	88 45 dc             	mov    %al,-0x24(%ebp)
    char *dummystr = NULL;
 271:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    char *start = NULL;
 278:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    char *end = NULL;
 27f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char nullch = '\0';
 286:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    char *address_of_null = &nullch;
 28a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 28d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    static char *nexttok;

    if(teststr != NULL)
 290:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 294:	74 08                	je     29e <strtok+0x39>
    {
        dummystr = teststr;
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	89 45 fc             	mov    %eax,-0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 29c:	eb 75                	jmp    313 <strtok+0xae>
    {
        dummystr = teststr;
    }
    else
    {
        if(*nexttok == '\0')
 29e:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 2a3:	8a 00                	mov    (%eax),%al
 2a5:	84 c0                	test   %al,%al
 2a7:	75 07                	jne    2b0 <strtok+0x4b>
            return NULL;
 2a9:	b8 00 00 00 00       	mov    $0x0,%eax
 2ae:	eb 6f                	jmp    31f <strtok+0xba>
        dummystr = nexttok;
 2b0:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 2b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }


    while(dummystr != NULL)
 2b8:	eb 59                	jmp    313 <strtok+0xae>
    {
        //empty string
        if(*dummystr == '\0')
 2ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2bd:	8a 00                	mov    (%eax),%al
 2bf:	84 c0                	test   %al,%al
 2c1:	74 58                	je     31b <strtok+0xb6>
            break;
        if(*dummystr != ch)
 2c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c6:	8a 00                	mov    (%eax),%al
 2c8:	3a 45 dc             	cmp    -0x24(%ebp),%al
 2cb:	74 22                	je     2ef <strtok+0x8a>
        {
            if(!start)
 2cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 2d1:	75 06                	jne    2d9 <strtok+0x74>
                start = dummystr;
 2d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d6:	89 45 f8             	mov    %eax,-0x8(%ebp)

            dummystr++;
 2d9:	ff 45 fc             	incl   -0x4(%ebp)

            // handle the case where the delimiter is not at the end of the string.
            if(*dummystr == '\0')
 2dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2df:	8a 00                	mov    (%eax),%al
 2e1:	84 c0                	test   %al,%al
 2e3:	75 2e                	jne    313 <strtok+0xae>
            {
                nexttok = dummystr;
 2e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e8:	a3 f4 0a 00 00       	mov    %eax,0xaf4
                break;
 2ed:	eb 2d                	jmp    31c <strtok+0xb7>
            }
        }
        else
        {
            if(start)
 2ef:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 2f3:	74 1b                	je     310 <strtok+0xab>
            {
                end = dummystr;
 2f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
                nexttok = dummystr+1;
 2fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2fe:	40                   	inc    %eax
 2ff:	a3 f4 0a 00 00       	mov    %eax,0xaf4
                *end = *address_of_null;
 304:	8b 45 f0             	mov    -0x10(%ebp),%eax
 307:	8a 10                	mov    (%eax),%dl
 309:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30c:	88 10                	mov    %dl,(%eax)
                break;
 30e:	eb 0c                	jmp    31c <strtok+0xb7>
            }
            else
            {
                dummystr++;
 310:	ff 45 fc             	incl   -0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 313:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
 317:	75 a1                	jne    2ba <strtok+0x55>
 319:	eb 01                	jmp    31c <strtok+0xb7>
    {
        //empty string
        if(*dummystr == '\0')
            break;
 31b:	90                   	nop
                dummystr++;
            }
        }
    }

    return start;
 31c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    
 321:	66 90                	xchg   %ax,%ax
 323:	90                   	nop

00000324 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 324:	b8 01 00 00 00       	mov    $0x1,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <exit>:
SYSCALL(exit)
 32c:	b8 02 00 00 00       	mov    $0x2,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <wait>:
SYSCALL(wait)
 334:	b8 03 00 00 00       	mov    $0x3,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <pipe>:
SYSCALL(pipe)
 33c:	b8 04 00 00 00       	mov    $0x4,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <read>:
SYSCALL(read)
 344:	b8 05 00 00 00       	mov    $0x5,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <write>:
SYSCALL(write)
 34c:	b8 10 00 00 00       	mov    $0x10,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <close>:
SYSCALL(close)
 354:	b8 15 00 00 00       	mov    $0x15,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <kill>:
SYSCALL(kill)
 35c:	b8 06 00 00 00       	mov    $0x6,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <exec>:
SYSCALL(exec)
 364:	b8 07 00 00 00       	mov    $0x7,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <open>:
SYSCALL(open)
 36c:	b8 0f 00 00 00       	mov    $0xf,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <mknod>:
SYSCALL(mknod)
 374:	b8 11 00 00 00       	mov    $0x11,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <unlink>:
SYSCALL(unlink)
 37c:	b8 12 00 00 00       	mov    $0x12,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <fstat>:
SYSCALL(fstat)
 384:	b8 08 00 00 00       	mov    $0x8,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <link>:
SYSCALL(link)
 38c:	b8 13 00 00 00       	mov    $0x13,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <mkdir>:
SYSCALL(mkdir)
 394:	b8 14 00 00 00       	mov    $0x14,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <chdir>:
SYSCALL(chdir)
 39c:	b8 09 00 00 00       	mov    $0x9,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <dup>:
SYSCALL(dup)
 3a4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <getpid>:
SYSCALL(getpid)
 3ac:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <sbrk>:
SYSCALL(sbrk)
 3b4:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <sleep>:
SYSCALL(sleep)
 3bc:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <uptime>:
SYSCALL(uptime)
 3c4:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <add_path>:
SYSCALL(add_path)
 3cc:	b8 16 00 00 00       	mov    $0x16,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <wait2>:
SYSCALL(wait2)
 3d4:	b8 17 00 00 00       	mov    $0x17,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3dc:	55                   	push   %ebp
 3dd:	89 e5                	mov    %esp,%ebp
 3df:	83 ec 28             	sub    $0x28,%esp
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ef:	00 
 3f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	89 04 24             	mov    %eax,(%esp)
 3fd:	e8 4a ff ff ff       	call   34c <write>
}
 402:	c9                   	leave  
 403:	c3                   	ret    

00000404 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 40a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 411:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 415:	74 17                	je     42e <printint+0x2a>
 417:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 41b:	79 11                	jns    42e <printint+0x2a>
    neg = 1;
 41d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 424:	8b 45 0c             	mov    0xc(%ebp),%eax
 427:	f7 d8                	neg    %eax
 429:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42c:	eb 06                	jmp    434 <printint+0x30>
  } else {
    x = xx;
 42e:	8b 45 0c             	mov    0xc(%ebp),%eax
 431:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 434:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 43b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 43e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 441:	ba 00 00 00 00       	mov    $0x0,%edx
 446:	f7 f1                	div    %ecx
 448:	89 d0                	mov    %edx,%eax
 44a:	8a 80 e0 0a 00 00    	mov    0xae0(%eax),%al
 450:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 453:	8b 55 f4             	mov    -0xc(%ebp),%edx
 456:	01 ca                	add    %ecx,%edx
 458:	88 02                	mov    %al,(%edx)
 45a:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 45d:	8b 55 10             	mov    0x10(%ebp),%edx
 460:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 463:	8b 45 ec             	mov    -0x14(%ebp),%eax
 466:	ba 00 00 00 00       	mov    $0x0,%edx
 46b:	f7 75 d4             	divl   -0x2c(%ebp)
 46e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 471:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 475:	75 c4                	jne    43b <printint+0x37>
  if(neg)
 477:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 47b:	74 2c                	je     4a9 <printint+0xa5>
    buf[i++] = '-';
 47d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 480:	8b 45 f4             	mov    -0xc(%ebp),%eax
 483:	01 d0                	add    %edx,%eax
 485:	c6 00 2d             	movb   $0x2d,(%eax)
 488:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 48b:	eb 1c                	jmp    4a9 <printint+0xa5>
    putc(fd, buf[i]);
 48d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 490:	8b 45 f4             	mov    -0xc(%ebp),%eax
 493:	01 d0                	add    %edx,%eax
 495:	8a 00                	mov    (%eax),%al
 497:	0f be c0             	movsbl %al,%eax
 49a:	89 44 24 04          	mov    %eax,0x4(%esp)
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
 4a1:	89 04 24             	mov    %eax,(%esp)
 4a4:	e8 33 ff ff ff       	call   3dc <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4a9:	ff 4d f4             	decl   -0xc(%ebp)
 4ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b0:	79 db                	jns    48d <printint+0x89>
    putc(fd, buf[i]);
}
 4b2:	c9                   	leave  
 4b3:	c3                   	ret    

000004b4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4b4:	55                   	push   %ebp
 4b5:	89 e5                	mov    %esp,%ebp
 4b7:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4c1:	8d 45 0c             	lea    0xc(%ebp),%eax
 4c4:	83 c0 04             	add    $0x4,%eax
 4c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4d1:	e9 78 01 00 00       	jmp    64e <printf+0x19a>
    c = fmt[i] & 0xff;
 4d6:	8b 55 0c             	mov    0xc(%ebp),%edx
 4d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4dc:	01 d0                	add    %edx,%eax
 4de:	8a 00                	mov    (%eax),%al
 4e0:	0f be c0             	movsbl %al,%eax
 4e3:	25 ff 00 00 00       	and    $0xff,%eax
 4e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ef:	75 2c                	jne    51d <printf+0x69>
      if(c == '%'){
 4f1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4f5:	75 0c                	jne    503 <printf+0x4f>
        state = '%';
 4f7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4fe:	e9 48 01 00 00       	jmp    64b <printf+0x197>
      } else {
        putc(fd, c);
 503:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 506:	0f be c0             	movsbl %al,%eax
 509:	89 44 24 04          	mov    %eax,0x4(%esp)
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	89 04 24             	mov    %eax,(%esp)
 513:	e8 c4 fe ff ff       	call   3dc <putc>
 518:	e9 2e 01 00 00       	jmp    64b <printf+0x197>
      }
    } else if(state == '%'){
 51d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 521:	0f 85 24 01 00 00    	jne    64b <printf+0x197>
      if(c == 'd'){
 527:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 52b:	75 2d                	jne    55a <printf+0xa6>
        printint(fd, *ap, 10, 1);
 52d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 530:	8b 00                	mov    (%eax),%eax
 532:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 539:	00 
 53a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 541:	00 
 542:	89 44 24 04          	mov    %eax,0x4(%esp)
 546:	8b 45 08             	mov    0x8(%ebp),%eax
 549:	89 04 24             	mov    %eax,(%esp)
 54c:	e8 b3 fe ff ff       	call   404 <printint>
        ap++;
 551:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 555:	e9 ea 00 00 00       	jmp    644 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 55a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 55e:	74 06                	je     566 <printf+0xb2>
 560:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 564:	75 2d                	jne    593 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 566:	8b 45 e8             	mov    -0x18(%ebp),%eax
 569:	8b 00                	mov    (%eax),%eax
 56b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 572:	00 
 573:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 57a:	00 
 57b:	89 44 24 04          	mov    %eax,0x4(%esp)
 57f:	8b 45 08             	mov    0x8(%ebp),%eax
 582:	89 04 24             	mov    %eax,(%esp)
 585:	e8 7a fe ff ff       	call   404 <printint>
        ap++;
 58a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58e:	e9 b1 00 00 00       	jmp    644 <printf+0x190>
      } else if(c == 's'){
 593:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 597:	75 43                	jne    5dc <printf+0x128>
        s = (char*)*ap;
 599:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59c:	8b 00                	mov    (%eax),%eax
 59e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a9:	75 25                	jne    5d0 <printf+0x11c>
          s = "(null)";
 5ab:	c7 45 f4 7b 08 00 00 	movl   $0x87b,-0xc(%ebp)
        while(*s != 0){
 5b2:	eb 1c                	jmp    5d0 <printf+0x11c>
          putc(fd, *s);
 5b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b7:	8a 00                	mov    (%eax),%al
 5b9:	0f be c0             	movsbl %al,%eax
 5bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c0:	8b 45 08             	mov    0x8(%ebp),%eax
 5c3:	89 04 24             	mov    %eax,(%esp)
 5c6:	e8 11 fe ff ff       	call   3dc <putc>
          s++;
 5cb:	ff 45 f4             	incl   -0xc(%ebp)
 5ce:	eb 01                	jmp    5d1 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d0:	90                   	nop
 5d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d4:	8a 00                	mov    (%eax),%al
 5d6:	84 c0                	test   %al,%al
 5d8:	75 da                	jne    5b4 <printf+0x100>
 5da:	eb 68                	jmp    644 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5dc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e0:	75 1d                	jne    5ff <printf+0x14b>
        putc(fd, *ap);
 5e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e5:	8b 00                	mov    (%eax),%eax
 5e7:	0f be c0             	movsbl %al,%eax
 5ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ee:	8b 45 08             	mov    0x8(%ebp),%eax
 5f1:	89 04 24             	mov    %eax,(%esp)
 5f4:	e8 e3 fd ff ff       	call   3dc <putc>
        ap++;
 5f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fd:	eb 45                	jmp    644 <printf+0x190>
      } else if(c == '%'){
 5ff:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 603:	75 17                	jne    61c <printf+0x168>
        putc(fd, c);
 605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 608:	0f be c0             	movsbl %al,%eax
 60b:	89 44 24 04          	mov    %eax,0x4(%esp)
 60f:	8b 45 08             	mov    0x8(%ebp),%eax
 612:	89 04 24             	mov    %eax,(%esp)
 615:	e8 c2 fd ff ff       	call   3dc <putc>
 61a:	eb 28                	jmp    644 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 61c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 623:	00 
 624:	8b 45 08             	mov    0x8(%ebp),%eax
 627:	89 04 24             	mov    %eax,(%esp)
 62a:	e8 ad fd ff ff       	call   3dc <putc>
        putc(fd, c);
 62f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 632:	0f be c0             	movsbl %al,%eax
 635:	89 44 24 04          	mov    %eax,0x4(%esp)
 639:	8b 45 08             	mov    0x8(%ebp),%eax
 63c:	89 04 24             	mov    %eax,(%esp)
 63f:	e8 98 fd ff ff       	call   3dc <putc>
      }
      state = 0;
 644:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 64b:	ff 45 f0             	incl   -0x10(%ebp)
 64e:	8b 55 0c             	mov    0xc(%ebp),%edx
 651:	8b 45 f0             	mov    -0x10(%ebp),%eax
 654:	01 d0                	add    %edx,%eax
 656:	8a 00                	mov    (%eax),%al
 658:	84 c0                	test   %al,%al
 65a:	0f 85 76 fe ff ff    	jne    4d6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 660:	c9                   	leave  
 661:	c3                   	ret    
 662:	66 90                	xchg   %ax,%ax

00000664 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 664:	55                   	push   %ebp
 665:	89 e5                	mov    %esp,%ebp
 667:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66a:	8b 45 08             	mov    0x8(%ebp),%eax
 66d:	83 e8 08             	sub    $0x8,%eax
 670:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 673:	a1 00 0b 00 00       	mov    0xb00,%eax
 678:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67b:	eb 24                	jmp    6a1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 00                	mov    (%eax),%eax
 682:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 685:	77 12                	ja     699 <free+0x35>
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68d:	77 24                	ja     6b3 <free+0x4f>
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 697:	77 1a                	ja     6b3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a7:	76 d4                	jbe    67d <free+0x19>
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b1:	76 ca                	jbe    67d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	8b 40 04             	mov    0x4(%eax),%eax
 6b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c3:	01 c2                	add    %eax,%edx
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 00                	mov    (%eax),%eax
 6ca:	39 c2                	cmp    %eax,%edx
 6cc:	75 24                	jne    6f2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d1:	8b 50 04             	mov    0x4(%eax),%edx
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	8b 00                	mov    (%eax),%eax
 6d9:	8b 40 04             	mov    0x4(%eax),%eax
 6dc:	01 c2                	add    %eax,%edx
 6de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 00                	mov    (%eax),%eax
 6e9:	8b 10                	mov    (%eax),%edx
 6eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ee:	89 10                	mov    %edx,(%eax)
 6f0:	eb 0a                	jmp    6fc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	8b 10                	mov    (%eax),%edx
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 40 04             	mov    0x4(%eax),%eax
 702:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	01 d0                	add    %edx,%eax
 70e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 711:	75 20                	jne    733 <free+0xcf>
    p->s.size += bp->s.size;
 713:	8b 45 fc             	mov    -0x4(%ebp),%eax
 716:	8b 50 04             	mov    0x4(%eax),%edx
 719:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71c:	8b 40 04             	mov    0x4(%eax),%eax
 71f:	01 c2                	add    %eax,%edx
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	8b 10                	mov    (%eax),%edx
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	89 10                	mov    %edx,(%eax)
 731:	eb 08                	jmp    73b <free+0xd7>
  } else
    p->s.ptr = bp;
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	8b 55 f8             	mov    -0x8(%ebp),%edx
 739:	89 10                	mov    %edx,(%eax)
  freep = p;
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	a3 00 0b 00 00       	mov    %eax,0xb00
}
 743:	c9                   	leave  
 744:	c3                   	ret    

00000745 <morecore>:

static Header*
morecore(uint nu)
{
 745:	55                   	push   %ebp
 746:	89 e5                	mov    %esp,%ebp
 748:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 74b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 752:	77 07                	ja     75b <morecore+0x16>
    nu = 4096;
 754:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 75b:	8b 45 08             	mov    0x8(%ebp),%eax
 75e:	c1 e0 03             	shl    $0x3,%eax
 761:	89 04 24             	mov    %eax,(%esp)
 764:	e8 4b fc ff ff       	call   3b4 <sbrk>
 769:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 76c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 770:	75 07                	jne    779 <morecore+0x34>
    return 0;
 772:	b8 00 00 00 00       	mov    $0x0,%eax
 777:	eb 22                	jmp    79b <morecore+0x56>
  hp = (Header*)p;
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 77f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 782:	8b 55 08             	mov    0x8(%ebp),%edx
 785:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 788:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78b:	83 c0 08             	add    $0x8,%eax
 78e:	89 04 24             	mov    %eax,(%esp)
 791:	e8 ce fe ff ff       	call   664 <free>
  return freep;
 796:	a1 00 0b 00 00       	mov    0xb00,%eax
}
 79b:	c9                   	leave  
 79c:	c3                   	ret    

0000079d <malloc>:

void*
malloc(uint nbytes)
{
 79d:	55                   	push   %ebp
 79e:	89 e5                	mov    %esp,%ebp
 7a0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a3:	8b 45 08             	mov    0x8(%ebp),%eax
 7a6:	83 c0 07             	add    $0x7,%eax
 7a9:	c1 e8 03             	shr    $0x3,%eax
 7ac:	40                   	inc    %eax
 7ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7b0:	a1 00 0b 00 00       	mov    0xb00,%eax
 7b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7bc:	75 23                	jne    7e1 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7be:	c7 45 f0 f8 0a 00 00 	movl   $0xaf8,-0x10(%ebp)
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	a3 00 0b 00 00       	mov    %eax,0xb00
 7cd:	a1 00 0b 00 00       	mov    0xb00,%eax
 7d2:	a3 f8 0a 00 00       	mov    %eax,0xaf8
    base.s.size = 0;
 7d7:	c7 05 fc 0a 00 00 00 	movl   $0x0,0xafc
 7de:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e4:	8b 00                	mov    (%eax),%eax
 7e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	8b 40 04             	mov    0x4(%eax),%eax
 7ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f2:	72 4d                	jb     841 <malloc+0xa4>
      if(p->s.size == nunits)
 7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f7:	8b 40 04             	mov    0x4(%eax),%eax
 7fa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7fd:	75 0c                	jne    80b <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	8b 10                	mov    (%eax),%edx
 804:	8b 45 f0             	mov    -0x10(%ebp),%eax
 807:	89 10                	mov    %edx,(%eax)
 809:	eb 26                	jmp    831 <malloc+0x94>
      else {
        p->s.size -= nunits;
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	8b 40 04             	mov    0x4(%eax),%eax
 811:	89 c2                	mov    %eax,%edx
 813:	2b 55 ec             	sub    -0x14(%ebp),%edx
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 81c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81f:	8b 40 04             	mov    0x4(%eax),%eax
 822:	c1 e0 03             	shl    $0x3,%eax
 825:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 82e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 831:	8b 45 f0             	mov    -0x10(%ebp),%eax
 834:	a3 00 0b 00 00       	mov    %eax,0xb00
      return (void*)(p + 1);
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	83 c0 08             	add    $0x8,%eax
 83f:	eb 38                	jmp    879 <malloc+0xdc>
    }
    if(p == freep)
 841:	a1 00 0b 00 00       	mov    0xb00,%eax
 846:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 849:	75 1b                	jne    866 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 84b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 84e:	89 04 24             	mov    %eax,(%esp)
 851:	e8 ef fe ff ff       	call   745 <morecore>
 856:	89 45 f4             	mov    %eax,-0xc(%ebp)
 859:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 85d:	75 07                	jne    866 <malloc+0xc9>
        return 0;
 85f:	b8 00 00 00 00       	mov    $0x0,%eax
 864:	eb 13                	jmp    879 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	89 45 f0             	mov    %eax,-0x10(%ebp)
 86c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86f:	8b 00                	mov    (%eax),%eax
 871:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 874:	e9 70 ff ff ff       	jmp    7e9 <malloc+0x4c>
}
 879:	c9                   	leave  
 87a:	c3                   	ret    
