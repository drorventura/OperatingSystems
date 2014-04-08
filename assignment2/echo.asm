
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
  1d:	b8 c3 08 00 00       	mov    $0x8c3,%eax
  22:	eb 05                	jmp    29 <main+0x29>
  24:	b8 c5 08 00 00       	mov    $0x8c5,%eax
  29:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2d:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  34:	8b 55 0c             	mov    0xc(%ebp),%edx
  37:	01 ca                	add    %ecx,%edx
  39:	8b 12                	mov    (%edx),%edx
  3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  3f:	89 54 24 08          	mov    %edx,0x8(%esp)
  43:	c7 44 24 04 c7 08 00 	movl   $0x8c7,0x4(%esp)
  4a:	00 
  4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  52:	e8 a5 04 00 00       	call   4fc <printf>
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
  64:	e8 0b 03 00 00       	call   374 <exit>
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

#define NULL   0

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
 199:	e8 ee 01 00 00       	call   38c <read>
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
 1f5:	e8 ba 01 00 00       	call   3b4 <open>
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
 217:	e8 b0 01 00 00       	call   3cc <fstat>
 21c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 222:	89 04 24             	mov    %eax,(%esp)
 225:	e8 72 01 00 00       	call   39c <close>
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

000002ad <strtok>:

char*
strtok(char *teststr, char ch)
{
 2ad:	55                   	push   %ebp
 2ae:	89 e5                	mov    %esp,%ebp
 2b0:	83 ec 24             	sub    $0x24,%esp
 2b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b6:	88 45 dc             	mov    %al,-0x24(%ebp)
    char *dummystr = NULL;
 2b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    char *start = NULL;
 2c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    char *end = NULL;
 2c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char nullch = '\0';
 2ce:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    char *address_of_null = &nullch;
 2d2:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    static char *nexttok;

    if(teststr != NULL)
 2d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2dc:	74 08                	je     2e6 <strtok+0x39>
    {
        dummystr = teststr;
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
 2e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 2e4:	eb 75                	jmp    35b <strtok+0xae>
    {
        dummystr = teststr;
    }
    else
    {
        if(*nexttok == '\0')
 2e6:	a1 44 0b 00 00       	mov    0xb44,%eax
 2eb:	8a 00                	mov    (%eax),%al
 2ed:	84 c0                	test   %al,%al
 2ef:	75 07                	jne    2f8 <strtok+0x4b>
            return NULL;
 2f1:	b8 00 00 00 00       	mov    $0x0,%eax
 2f6:	eb 6f                	jmp    367 <strtok+0xba>
        dummystr = nexttok;
 2f8:	a1 44 0b 00 00       	mov    0xb44,%eax
 2fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }


    while(dummystr != NULL)
 300:	eb 59                	jmp    35b <strtok+0xae>
    {
        //empty string
        if(*dummystr == '\0')
 302:	8b 45 fc             	mov    -0x4(%ebp),%eax
 305:	8a 00                	mov    (%eax),%al
 307:	84 c0                	test   %al,%al
 309:	74 58                	je     363 <strtok+0xb6>
            break;
        if(*dummystr != ch)
 30b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 30e:	8a 00                	mov    (%eax),%al
 310:	3a 45 dc             	cmp    -0x24(%ebp),%al
 313:	74 22                	je     337 <strtok+0x8a>
        {
            if(!start)
 315:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 319:	75 06                	jne    321 <strtok+0x74>
                start = dummystr;
 31b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 31e:	89 45 f8             	mov    %eax,-0x8(%ebp)

            dummystr++;
 321:	ff 45 fc             	incl   -0x4(%ebp)

            // handle the case where the delimiter is not at the end of the string.
            if(*dummystr == '\0')
 324:	8b 45 fc             	mov    -0x4(%ebp),%eax
 327:	8a 00                	mov    (%eax),%al
 329:	84 c0                	test   %al,%al
 32b:	75 2e                	jne    35b <strtok+0xae>
            {
                nexttok = dummystr;
 32d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 330:	a3 44 0b 00 00       	mov    %eax,0xb44
                break;
 335:	eb 2d                	jmp    364 <strtok+0xb7>
            }
        }
        else
        {
            if(start)
 337:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 33b:	74 1b                	je     358 <strtok+0xab>
            {
                end = dummystr;
 33d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 340:	89 45 f4             	mov    %eax,-0xc(%ebp)
                nexttok = dummystr+1;
 343:	8b 45 fc             	mov    -0x4(%ebp),%eax
 346:	40                   	inc    %eax
 347:	a3 44 0b 00 00       	mov    %eax,0xb44
                *end = *address_of_null;
 34c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 34f:	8a 10                	mov    (%eax),%dl
 351:	8b 45 f4             	mov    -0xc(%ebp),%eax
 354:	88 10                	mov    %dl,(%eax)
                break;
 356:	eb 0c                	jmp    364 <strtok+0xb7>
            }
            else
            {
                dummystr++;
 358:	ff 45 fc             	incl   -0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 35b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
 35f:	75 a1                	jne    302 <strtok+0x55>
 361:	eb 01                	jmp    364 <strtok+0xb7>
    {
        //empty string
        if(*dummystr == '\0')
            break;
 363:	90                   	nop
                dummystr++;
            }
        }
    }

    return start;
 364:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 367:	c9                   	leave  
 368:	c3                   	ret    
 369:	66 90                	xchg   %ax,%ax
 36b:	90                   	nop

0000036c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 36c:	b8 01 00 00 00       	mov    $0x1,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <exit>:
SYSCALL(exit)
 374:	b8 02 00 00 00       	mov    $0x2,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <wait>:
SYSCALL(wait)
 37c:	b8 03 00 00 00       	mov    $0x3,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <pipe>:
SYSCALL(pipe)
 384:	b8 04 00 00 00       	mov    $0x4,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <read>:
SYSCALL(read)
 38c:	b8 05 00 00 00       	mov    $0x5,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <write>:
SYSCALL(write)
 394:	b8 10 00 00 00       	mov    $0x10,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <close>:
SYSCALL(close)
 39c:	b8 15 00 00 00       	mov    $0x15,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <kill>:
SYSCALL(kill)
 3a4:	b8 06 00 00 00       	mov    $0x6,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <exec>:
SYSCALL(exec)
 3ac:	b8 07 00 00 00       	mov    $0x7,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <open>:
SYSCALL(open)
 3b4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <mknod>:
SYSCALL(mknod)
 3bc:	b8 11 00 00 00       	mov    $0x11,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <unlink>:
SYSCALL(unlink)
 3c4:	b8 12 00 00 00       	mov    $0x12,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <fstat>:
SYSCALL(fstat)
 3cc:	b8 08 00 00 00       	mov    $0x8,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <link>:
SYSCALL(link)
 3d4:	b8 13 00 00 00       	mov    $0x13,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <mkdir>:
SYSCALL(mkdir)
 3dc:	b8 14 00 00 00       	mov    $0x14,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <chdir>:
SYSCALL(chdir)
 3e4:	b8 09 00 00 00       	mov    $0x9,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <dup>:
SYSCALL(dup)
 3ec:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <getpid>:
SYSCALL(getpid)
 3f4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <sbrk>:
SYSCALL(sbrk)
 3fc:	b8 0c 00 00 00       	mov    $0xc,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <sleep>:
SYSCALL(sleep)
 404:	b8 0d 00 00 00       	mov    $0xd,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <uptime>:
SYSCALL(uptime)
 40c:	b8 0e 00 00 00       	mov    $0xe,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <add_path>:
SYSCALL(add_path)
 414:	b8 16 00 00 00       	mov    $0x16,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <wait2>:
SYSCALL(wait2)
 41c:	b8 17 00 00 00       	mov    $0x17,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	83 ec 28             	sub    $0x28,%esp
 42a:	8b 45 0c             	mov    0xc(%ebp),%eax
 42d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 430:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 437:	00 
 438:	8d 45 f4             	lea    -0xc(%ebp),%eax
 43b:	89 44 24 04          	mov    %eax,0x4(%esp)
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
 442:	89 04 24             	mov    %eax,(%esp)
 445:	e8 4a ff ff ff       	call   394 <write>
}
 44a:	c9                   	leave  
 44b:	c3                   	ret    

0000044c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 452:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 459:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 45d:	74 17                	je     476 <printint+0x2a>
 45f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 463:	79 11                	jns    476 <printint+0x2a>
    neg = 1;
 465:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 46c:	8b 45 0c             	mov    0xc(%ebp),%eax
 46f:	f7 d8                	neg    %eax
 471:	89 45 ec             	mov    %eax,-0x14(%ebp)
 474:	eb 06                	jmp    47c <printint+0x30>
  } else {
    x = xx;
 476:	8b 45 0c             	mov    0xc(%ebp),%eax
 479:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 47c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 483:	8b 4d 10             	mov    0x10(%ebp),%ecx
 486:	8b 45 ec             	mov    -0x14(%ebp),%eax
 489:	ba 00 00 00 00       	mov    $0x0,%edx
 48e:	f7 f1                	div    %ecx
 490:	89 d0                	mov    %edx,%eax
 492:	8a 80 30 0b 00 00    	mov    0xb30(%eax),%al
 498:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 49b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 49e:	01 ca                	add    %ecx,%edx
 4a0:	88 02                	mov    %al,(%edx)
 4a2:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 4a5:	8b 55 10             	mov    0x10(%ebp),%edx
 4a8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ae:	ba 00 00 00 00       	mov    $0x0,%edx
 4b3:	f7 75 d4             	divl   -0x2c(%ebp)
 4b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4bd:	75 c4                	jne    483 <printint+0x37>
  if(neg)
 4bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c3:	74 2c                	je     4f1 <printint+0xa5>
    buf[i++] = '-';
 4c5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cb:	01 d0                	add    %edx,%eax
 4cd:	c6 00 2d             	movb   $0x2d,(%eax)
 4d0:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4d3:	eb 1c                	jmp    4f1 <printint+0xa5>
    putc(fd, buf[i]);
 4d5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4db:	01 d0                	add    %edx,%eax
 4dd:	8a 00                	mov    (%eax),%al
 4df:	0f be c0             	movsbl %al,%eax
 4e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	89 04 24             	mov    %eax,(%esp)
 4ec:	e8 33 ff ff ff       	call   424 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4f1:	ff 4d f4             	decl   -0xc(%ebp)
 4f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f8:	79 db                	jns    4d5 <printint+0x89>
    putc(fd, buf[i]);
}
 4fa:	c9                   	leave  
 4fb:	c3                   	ret    

000004fc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4fc:	55                   	push   %ebp
 4fd:	89 e5                	mov    %esp,%ebp
 4ff:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 502:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 509:	8d 45 0c             	lea    0xc(%ebp),%eax
 50c:	83 c0 04             	add    $0x4,%eax
 50f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 512:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 519:	e9 78 01 00 00       	jmp    696 <printf+0x19a>
    c = fmt[i] & 0xff;
 51e:	8b 55 0c             	mov    0xc(%ebp),%edx
 521:	8b 45 f0             	mov    -0x10(%ebp),%eax
 524:	01 d0                	add    %edx,%eax
 526:	8a 00                	mov    (%eax),%al
 528:	0f be c0             	movsbl %al,%eax
 52b:	25 ff 00 00 00       	and    $0xff,%eax
 530:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 533:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 537:	75 2c                	jne    565 <printf+0x69>
      if(c == '%'){
 539:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 53d:	75 0c                	jne    54b <printf+0x4f>
        state = '%';
 53f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 546:	e9 48 01 00 00       	jmp    693 <printf+0x197>
      } else {
        putc(fd, c);
 54b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54e:	0f be c0             	movsbl %al,%eax
 551:	89 44 24 04          	mov    %eax,0x4(%esp)
 555:	8b 45 08             	mov    0x8(%ebp),%eax
 558:	89 04 24             	mov    %eax,(%esp)
 55b:	e8 c4 fe ff ff       	call   424 <putc>
 560:	e9 2e 01 00 00       	jmp    693 <printf+0x197>
      }
    } else if(state == '%'){
 565:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 569:	0f 85 24 01 00 00    	jne    693 <printf+0x197>
      if(c == 'd'){
 56f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 573:	75 2d                	jne    5a2 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 575:	8b 45 e8             	mov    -0x18(%ebp),%eax
 578:	8b 00                	mov    (%eax),%eax
 57a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 581:	00 
 582:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 589:	00 
 58a:	89 44 24 04          	mov    %eax,0x4(%esp)
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
 591:	89 04 24             	mov    %eax,(%esp)
 594:	e8 b3 fe ff ff       	call   44c <printint>
        ap++;
 599:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59d:	e9 ea 00 00 00       	jmp    68c <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 5a2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5a6:	74 06                	je     5ae <printf+0xb2>
 5a8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5ac:	75 2d                	jne    5db <printf+0xdf>
        printint(fd, *ap, 16, 0);
 5ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b1:	8b 00                	mov    (%eax),%eax
 5b3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5ba:	00 
 5bb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5c2:	00 
 5c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ca:	89 04 24             	mov    %eax,(%esp)
 5cd:	e8 7a fe ff ff       	call   44c <printint>
        ap++;
 5d2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d6:	e9 b1 00 00 00       	jmp    68c <printf+0x190>
      } else if(c == 's'){
 5db:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5df:	75 43                	jne    624 <printf+0x128>
        s = (char*)*ap;
 5e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e4:	8b 00                	mov    (%eax),%eax
 5e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5e9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f1:	75 25                	jne    618 <printf+0x11c>
          s = "(null)";
 5f3:	c7 45 f4 cc 08 00 00 	movl   $0x8cc,-0xc(%ebp)
        while(*s != 0){
 5fa:	eb 1c                	jmp    618 <printf+0x11c>
          putc(fd, *s);
 5fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ff:	8a 00                	mov    (%eax),%al
 601:	0f be c0             	movsbl %al,%eax
 604:	89 44 24 04          	mov    %eax,0x4(%esp)
 608:	8b 45 08             	mov    0x8(%ebp),%eax
 60b:	89 04 24             	mov    %eax,(%esp)
 60e:	e8 11 fe ff ff       	call   424 <putc>
          s++;
 613:	ff 45 f4             	incl   -0xc(%ebp)
 616:	eb 01                	jmp    619 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 618:	90                   	nop
 619:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61c:	8a 00                	mov    (%eax),%al
 61e:	84 c0                	test   %al,%al
 620:	75 da                	jne    5fc <printf+0x100>
 622:	eb 68                	jmp    68c <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 624:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 628:	75 1d                	jne    647 <printf+0x14b>
        putc(fd, *ap);
 62a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62d:	8b 00                	mov    (%eax),%eax
 62f:	0f be c0             	movsbl %al,%eax
 632:	89 44 24 04          	mov    %eax,0x4(%esp)
 636:	8b 45 08             	mov    0x8(%ebp),%eax
 639:	89 04 24             	mov    %eax,(%esp)
 63c:	e8 e3 fd ff ff       	call   424 <putc>
        ap++;
 641:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 645:	eb 45                	jmp    68c <printf+0x190>
      } else if(c == '%'){
 647:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64b:	75 17                	jne    664 <printf+0x168>
        putc(fd, c);
 64d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 650:	0f be c0             	movsbl %al,%eax
 653:	89 44 24 04          	mov    %eax,0x4(%esp)
 657:	8b 45 08             	mov    0x8(%ebp),%eax
 65a:	89 04 24             	mov    %eax,(%esp)
 65d:	e8 c2 fd ff ff       	call   424 <putc>
 662:	eb 28                	jmp    68c <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 664:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 66b:	00 
 66c:	8b 45 08             	mov    0x8(%ebp),%eax
 66f:	89 04 24             	mov    %eax,(%esp)
 672:	e8 ad fd ff ff       	call   424 <putc>
        putc(fd, c);
 677:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67a:	0f be c0             	movsbl %al,%eax
 67d:	89 44 24 04          	mov    %eax,0x4(%esp)
 681:	8b 45 08             	mov    0x8(%ebp),%eax
 684:	89 04 24             	mov    %eax,(%esp)
 687:	e8 98 fd ff ff       	call   424 <putc>
      }
      state = 0;
 68c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 693:	ff 45 f0             	incl   -0x10(%ebp)
 696:	8b 55 0c             	mov    0xc(%ebp),%edx
 699:	8b 45 f0             	mov    -0x10(%ebp),%eax
 69c:	01 d0                	add    %edx,%eax
 69e:	8a 00                	mov    (%eax),%al
 6a0:	84 c0                	test   %al,%al
 6a2:	0f 85 76 fe ff ff    	jne    51e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6a8:	c9                   	leave  
 6a9:	c3                   	ret    
 6aa:	66 90                	xchg   %ax,%ax

000006ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ac:	55                   	push   %ebp
 6ad:	89 e5                	mov    %esp,%ebp
 6af:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b2:	8b 45 08             	mov    0x8(%ebp),%eax
 6b5:	83 e8 08             	sub    $0x8,%eax
 6b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bb:	a1 50 0b 00 00       	mov    0xb50,%eax
 6c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c3:	eb 24                	jmp    6e9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 00                	mov    (%eax),%eax
 6ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cd:	77 12                	ja     6e1 <free+0x35>
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d5:	77 24                	ja     6fb <free+0x4f>
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6df:	77 1a                	ja     6fb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 00                	mov    (%eax),%eax
 6e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ef:	76 d4                	jbe    6c5 <free+0x19>
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f9:	76 ca                	jbe    6c5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	8b 40 04             	mov    0x4(%eax),%eax
 701:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 708:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70b:	01 c2                	add    %eax,%edx
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	8b 00                	mov    (%eax),%eax
 712:	39 c2                	cmp    %eax,%edx
 714:	75 24                	jne    73a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 716:	8b 45 f8             	mov    -0x8(%ebp),%eax
 719:	8b 50 04             	mov    0x4(%eax),%edx
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	8b 00                	mov    (%eax),%eax
 721:	8b 40 04             	mov    0x4(%eax),%eax
 724:	01 c2                	add    %eax,%edx
 726:	8b 45 f8             	mov    -0x8(%ebp),%eax
 729:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	8b 10                	mov    (%eax),%edx
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	89 10                	mov    %edx,(%eax)
 738:	eb 0a                	jmp    744 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 10                	mov    (%eax),%edx
 73f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 742:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 40 04             	mov    0x4(%eax),%eax
 74a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 751:	8b 45 fc             	mov    -0x4(%ebp),%eax
 754:	01 d0                	add    %edx,%eax
 756:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 759:	75 20                	jne    77b <free+0xcf>
    p->s.size += bp->s.size;
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	8b 50 04             	mov    0x4(%eax),%edx
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	8b 40 04             	mov    0x4(%eax),%eax
 767:	01 c2                	add    %eax,%edx
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	8b 10                	mov    (%eax),%edx
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	89 10                	mov    %edx,(%eax)
 779:	eb 08                	jmp    783 <free+0xd7>
  } else
    p->s.ptr = bp;
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 781:	89 10                	mov    %edx,(%eax)
  freep = p;
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	a3 50 0b 00 00       	mov    %eax,0xb50
}
 78b:	c9                   	leave  
 78c:	c3                   	ret    

0000078d <morecore>:

static Header*
morecore(uint nu)
{
 78d:	55                   	push   %ebp
 78e:	89 e5                	mov    %esp,%ebp
 790:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 793:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 79a:	77 07                	ja     7a3 <morecore+0x16>
    nu = 4096;
 79c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a3:	8b 45 08             	mov    0x8(%ebp),%eax
 7a6:	c1 e0 03             	shl    $0x3,%eax
 7a9:	89 04 24             	mov    %eax,(%esp)
 7ac:	e8 4b fc ff ff       	call   3fc <sbrk>
 7b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7b4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7b8:	75 07                	jne    7c1 <morecore+0x34>
    return 0;
 7ba:	b8 00 00 00 00       	mov    $0x0,%eax
 7bf:	eb 22                	jmp    7e3 <morecore+0x56>
  hp = (Header*)p;
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ca:	8b 55 08             	mov    0x8(%ebp),%edx
 7cd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d3:	83 c0 08             	add    $0x8,%eax
 7d6:	89 04 24             	mov    %eax,(%esp)
 7d9:	e8 ce fe ff ff       	call   6ac <free>
  return freep;
 7de:	a1 50 0b 00 00       	mov    0xb50,%eax
}
 7e3:	c9                   	leave  
 7e4:	c3                   	ret    

000007e5 <malloc>:

void*
malloc(uint nbytes)
{
 7e5:	55                   	push   %ebp
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7eb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ee:	83 c0 07             	add    $0x7,%eax
 7f1:	c1 e8 03             	shr    $0x3,%eax
 7f4:	40                   	inc    %eax
 7f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7f8:	a1 50 0b 00 00       	mov    0xb50,%eax
 7fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 800:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 804:	75 23                	jne    829 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 806:	c7 45 f0 48 0b 00 00 	movl   $0xb48,-0x10(%ebp)
 80d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 810:	a3 50 0b 00 00       	mov    %eax,0xb50
 815:	a1 50 0b 00 00       	mov    0xb50,%eax
 81a:	a3 48 0b 00 00       	mov    %eax,0xb48
    base.s.size = 0;
 81f:	c7 05 4c 0b 00 00 00 	movl   $0x0,0xb4c
 826:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 829:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82c:	8b 00                	mov    (%eax),%eax
 82e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 831:	8b 45 f4             	mov    -0xc(%ebp),%eax
 834:	8b 40 04             	mov    0x4(%eax),%eax
 837:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 83a:	72 4d                	jb     889 <malloc+0xa4>
      if(p->s.size == nunits)
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	8b 40 04             	mov    0x4(%eax),%eax
 842:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 845:	75 0c                	jne    853 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	8b 10                	mov    (%eax),%edx
 84c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84f:	89 10                	mov    %edx,(%eax)
 851:	eb 26                	jmp    879 <malloc+0x94>
      else {
        p->s.size -= nunits;
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	8b 40 04             	mov    0x4(%eax),%eax
 859:	89 c2                	mov    %eax,%edx
 85b:	2b 55 ec             	sub    -0x14(%ebp),%edx
 85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 861:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 864:	8b 45 f4             	mov    -0xc(%ebp),%eax
 867:	8b 40 04             	mov    0x4(%eax),%eax
 86a:	c1 e0 03             	shl    $0x3,%eax
 86d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	8b 55 ec             	mov    -0x14(%ebp),%edx
 876:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 879:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87c:	a3 50 0b 00 00       	mov    %eax,0xb50
      return (void*)(p + 1);
 881:	8b 45 f4             	mov    -0xc(%ebp),%eax
 884:	83 c0 08             	add    $0x8,%eax
 887:	eb 38                	jmp    8c1 <malloc+0xdc>
    }
    if(p == freep)
 889:	a1 50 0b 00 00       	mov    0xb50,%eax
 88e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 891:	75 1b                	jne    8ae <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 893:	8b 45 ec             	mov    -0x14(%ebp),%eax
 896:	89 04 24             	mov    %eax,(%esp)
 899:	e8 ef fe ff ff       	call   78d <morecore>
 89e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a5:	75 07                	jne    8ae <malloc+0xc9>
        return 0;
 8a7:	b8 00 00 00 00       	mov    $0x0,%eax
 8ac:	eb 13                	jmp    8c1 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b7:	8b 00                	mov    (%eax),%eax
 8b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8bc:	e9 70 ff ff ff       	jmp    831 <malloc+0x4c>
}
 8c1:	c9                   	leave  
 8c2:	c3                   	ret    
