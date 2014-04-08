
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
   9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 bf 08 00 	movl   $0x8bf,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 d5 04 00 00       	call   4f8 <printf>
    exit();
  23:	e8 48 03 00 00       	call   370 <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 26                	jmp    58 <main+0x58>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 df 01 00 00       	call   22b <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 4c 03 00 00       	call   3a0 <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  54:	ff 44 24 1c          	incl   0x1c(%esp)
  58:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  5f:	7c d1                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  61:	e8 0a 03 00 00       	call   370 <exit>
  66:	66 90                	xchg   %ax,%ax

00000068 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	57                   	push   %edi
  6c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  70:	8b 55 10             	mov    0x10(%ebp),%edx
  73:	8b 45 0c             	mov    0xc(%ebp),%eax
  76:	89 cb                	mov    %ecx,%ebx
  78:	89 df                	mov    %ebx,%edi
  7a:	89 d1                	mov    %edx,%ecx
  7c:	fc                   	cld    
  7d:	f3 aa                	rep stos %al,%es:(%edi)
  7f:	89 ca                	mov    %ecx,%edx
  81:	89 fb                	mov    %edi,%ebx
  83:	89 5d 08             	mov    %ebx,0x8(%ebp)
  86:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  89:	5b                   	pop    %ebx
  8a:	5f                   	pop    %edi
  8b:	5d                   	pop    %ebp
  8c:	c3                   	ret    

0000008d <strcpy>:

#define NULL   0

char*
strcpy(char *s, char *t)
{
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  99:	90                   	nop
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	8a 10                	mov    (%eax),%dl
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	88 10                	mov    %dl,(%eax)
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	8a 00                	mov    (%eax),%al
  a9:	84 c0                	test   %al,%al
  ab:	0f 95 c0             	setne  %al
  ae:	ff 45 08             	incl   0x8(%ebp)
  b1:	ff 45 0c             	incl   0xc(%ebp)
  b4:	84 c0                	test   %al,%al
  b6:	75 e2                	jne    9a <strcpy+0xd>
    ;
  return os;
  b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bb:	c9                   	leave  
  bc:	c3                   	ret    

000000bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c0:	eb 06                	jmp    c8 <strcmp+0xb>
    p++, q++;
  c2:	ff 45 08             	incl   0x8(%ebp)
  c5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	8a 00                	mov    (%eax),%al
  cd:	84 c0                	test   %al,%al
  cf:	74 0e                	je     df <strcmp+0x22>
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	8a 10                	mov    (%eax),%dl
  d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  d9:	8a 00                	mov    (%eax),%al
  db:	38 c2                	cmp    %al,%dl
  dd:	74 e3                	je     c2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	8a 00                	mov    (%eax),%al
  e4:	0f b6 d0             	movzbl %al,%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	8a 00                	mov    (%eax),%al
  ec:	0f b6 c0             	movzbl %al,%eax
  ef:	89 d1                	mov    %edx,%ecx
  f1:	29 c1                	sub    %eax,%ecx
  f3:	89 c8                	mov    %ecx,%eax
}
  f5:	5d                   	pop    %ebp
  f6:	c3                   	ret    

000000f7 <strlen>:

uint
strlen(char *s)
{
  f7:	55                   	push   %ebp
  f8:	89 e5                	mov    %esp,%ebp
  fa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 104:	eb 03                	jmp    109 <strlen+0x12>
 106:	ff 45 fc             	incl   -0x4(%ebp)
 109:	8b 55 fc             	mov    -0x4(%ebp),%edx
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	01 d0                	add    %edx,%eax
 111:	8a 00                	mov    (%eax),%al
 113:	84 c0                	test   %al,%al
 115:	75 ef                	jne    106 <strlen+0xf>
    ;
  return n;
 117:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11a:	c9                   	leave  
 11b:	c3                   	ret    

0000011c <memset>:

void*
memset(void *dst, int c, uint n)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 122:	8b 45 10             	mov    0x10(%ebp),%eax
 125:	89 44 24 08          	mov    %eax,0x8(%esp)
 129:	8b 45 0c             	mov    0xc(%ebp),%eax
 12c:	89 44 24 04          	mov    %eax,0x4(%esp)
 130:	8b 45 08             	mov    0x8(%ebp),%eax
 133:	89 04 24             	mov    %eax,(%esp)
 136:	e8 2d ff ff ff       	call   68 <stosb>
  return dst;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 13e:	c9                   	leave  
 13f:	c3                   	ret    

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	83 ec 04             	sub    $0x4,%esp
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 14c:	eb 12                	jmp    160 <strchr+0x20>
    if(*s == c)
 14e:	8b 45 08             	mov    0x8(%ebp),%eax
 151:	8a 00                	mov    (%eax),%al
 153:	3a 45 fc             	cmp    -0x4(%ebp),%al
 156:	75 05                	jne    15d <strchr+0x1d>
      return (char*)s;
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	eb 11                	jmp    16e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 15d:	ff 45 08             	incl   0x8(%ebp)
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	8a 00                	mov    (%eax),%al
 165:	84 c0                	test   %al,%al
 167:	75 e5                	jne    14e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 169:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16e:	c9                   	leave  
 16f:	c3                   	ret    

00000170 <gets>:

char*
gets(char *buf, int max)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 176:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17d:	eb 42                	jmp    1c1 <gets+0x51>
    cc = read(0, &c, 1);
 17f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 186:	00 
 187:	8d 45 ef             	lea    -0x11(%ebp),%eax
 18a:	89 44 24 04          	mov    %eax,0x4(%esp)
 18e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 195:	e8 ee 01 00 00       	call   388 <read>
 19a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 19d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a1:	7e 29                	jle    1cc <gets+0x5c>
      break;
    buf[i++] = c;
 1a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	01 c2                	add    %eax,%edx
 1ab:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ae:	88 02                	mov    %al,(%edx)
 1b0:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1b3:	8a 45 ef             	mov    -0x11(%ebp),%al
 1b6:	3c 0a                	cmp    $0xa,%al
 1b8:	74 13                	je     1cd <gets+0x5d>
 1ba:	8a 45 ef             	mov    -0x11(%ebp),%al
 1bd:	3c 0d                	cmp    $0xd,%al
 1bf:	74 0c                	je     1cd <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c4:	40                   	inc    %eax
 1c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c8:	7c b5                	jl     17f <gets+0xf>
 1ca:	eb 01                	jmp    1cd <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1cc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <stat>:

int
stat(char *n, struct stat *st)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ea:	00 
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	89 04 24             	mov    %eax,(%esp)
 1f1:	e8 ba 01 00 00       	call   3b0 <open>
 1f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fd:	79 07                	jns    206 <stat+0x29>
    return -1;
 1ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 204:	eb 23                	jmp    229 <stat+0x4c>
  r = fstat(fd, st);
 206:	8b 45 0c             	mov    0xc(%ebp),%eax
 209:	89 44 24 04          	mov    %eax,0x4(%esp)
 20d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 210:	89 04 24             	mov    %eax,(%esp)
 213:	e8 b0 01 00 00       	call   3c8 <fstat>
 218:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21e:	89 04 24             	mov    %eax,(%esp)
 221:	e8 72 01 00 00       	call   398 <close>
  return r;
 226:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 229:	c9                   	leave  
 22a:	c3                   	ret    

0000022b <atoi>:

int
atoi(const char *s)
{
 22b:	55                   	push   %ebp
 22c:	89 e5                	mov    %esp,%ebp
 22e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 231:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 238:	eb 21                	jmp    25b <atoi+0x30>
    n = n*10 + *s++ - '0';
 23a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23d:	89 d0                	mov    %edx,%eax
 23f:	c1 e0 02             	shl    $0x2,%eax
 242:	01 d0                	add    %edx,%eax
 244:	d1 e0                	shl    %eax
 246:	89 c2                	mov    %eax,%edx
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	8a 00                	mov    (%eax),%al
 24d:	0f be c0             	movsbl %al,%eax
 250:	01 d0                	add    %edx,%eax
 252:	83 e8 30             	sub    $0x30,%eax
 255:	89 45 fc             	mov    %eax,-0x4(%ebp)
 258:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8a 00                	mov    (%eax),%al
 260:	3c 2f                	cmp    $0x2f,%al
 262:	7e 09                	jle    26d <atoi+0x42>
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	8a 00                	mov    (%eax),%al
 269:	3c 39                	cmp    $0x39,%al
 26b:	7e cd                	jle    23a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 26d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 270:	c9                   	leave  
 271:	c3                   	ret    

00000272 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 272:	55                   	push   %ebp
 273:	89 e5                	mov    %esp,%ebp
 275:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 27e:	8b 45 0c             	mov    0xc(%ebp),%eax
 281:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 284:	eb 10                	jmp    296 <memmove+0x24>
    *dst++ = *src++;
 286:	8b 45 f8             	mov    -0x8(%ebp),%eax
 289:	8a 10                	mov    (%eax),%dl
 28b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28e:	88 10                	mov    %dl,(%eax)
 290:	ff 45 fc             	incl   -0x4(%ebp)
 293:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 296:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 29a:	0f 9f c0             	setg   %al
 29d:	ff 4d 10             	decl   0x10(%ebp)
 2a0:	84 c0                	test   %al,%al
 2a2:	75 e2                	jne    286 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a7:	c9                   	leave  
 2a8:	c3                   	ret    

000002a9 <strtok>:

char*
strtok(char *teststr, char ch)
{
 2a9:	55                   	push   %ebp
 2aa:	89 e5                	mov    %esp,%ebp
 2ac:	83 ec 24             	sub    $0x24,%esp
 2af:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b2:	88 45 dc             	mov    %al,-0x24(%ebp)
    char *dummystr = NULL;
 2b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    char *start = NULL;
 2bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    char *end = NULL;
 2c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char nullch = '\0';
 2ca:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    char *address_of_null = &nullch;
 2ce:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    static char *nexttok;

    if(teststr != NULL)
 2d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2d8:	74 08                	je     2e2 <strtok+0x39>
    {
        dummystr = teststr;
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 2e0:	eb 75                	jmp    357 <strtok+0xae>
    {
        dummystr = teststr;
    }
    else
    {
        if(*nexttok == '\0')
 2e2:	a1 4c 0b 00 00       	mov    0xb4c,%eax
 2e7:	8a 00                	mov    (%eax),%al
 2e9:	84 c0                	test   %al,%al
 2eb:	75 07                	jne    2f4 <strtok+0x4b>
            return NULL;
 2ed:	b8 00 00 00 00       	mov    $0x0,%eax
 2f2:	eb 6f                	jmp    363 <strtok+0xba>
        dummystr = nexttok;
 2f4:	a1 4c 0b 00 00       	mov    0xb4c,%eax
 2f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }


    while(dummystr != NULL)
 2fc:	eb 59                	jmp    357 <strtok+0xae>
    {
        //empty string
        if(*dummystr == '\0')
 2fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 301:	8a 00                	mov    (%eax),%al
 303:	84 c0                	test   %al,%al
 305:	74 58                	je     35f <strtok+0xb6>
            break;
        if(*dummystr != ch)
 307:	8b 45 fc             	mov    -0x4(%ebp),%eax
 30a:	8a 00                	mov    (%eax),%al
 30c:	3a 45 dc             	cmp    -0x24(%ebp),%al
 30f:	74 22                	je     333 <strtok+0x8a>
        {
            if(!start)
 311:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 315:	75 06                	jne    31d <strtok+0x74>
                start = dummystr;
 317:	8b 45 fc             	mov    -0x4(%ebp),%eax
 31a:	89 45 f8             	mov    %eax,-0x8(%ebp)

            dummystr++;
 31d:	ff 45 fc             	incl   -0x4(%ebp)

            // handle the case where the delimiter is not at the end of the string.
            if(*dummystr == '\0')
 320:	8b 45 fc             	mov    -0x4(%ebp),%eax
 323:	8a 00                	mov    (%eax),%al
 325:	84 c0                	test   %al,%al
 327:	75 2e                	jne    357 <strtok+0xae>
            {
                nexttok = dummystr;
 329:	8b 45 fc             	mov    -0x4(%ebp),%eax
 32c:	a3 4c 0b 00 00       	mov    %eax,0xb4c
                break;
 331:	eb 2d                	jmp    360 <strtok+0xb7>
            }
        }
        else
        {
            if(start)
 333:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 337:	74 1b                	je     354 <strtok+0xab>
            {
                end = dummystr;
 339:	8b 45 fc             	mov    -0x4(%ebp),%eax
 33c:	89 45 f4             	mov    %eax,-0xc(%ebp)
                nexttok = dummystr+1;
 33f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 342:	40                   	inc    %eax
 343:	a3 4c 0b 00 00       	mov    %eax,0xb4c
                *end = *address_of_null;
 348:	8b 45 f0             	mov    -0x10(%ebp),%eax
 34b:	8a 10                	mov    (%eax),%dl
 34d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 350:	88 10                	mov    %dl,(%eax)
                break;
 352:	eb 0c                	jmp    360 <strtok+0xb7>
            }
            else
            {
                dummystr++;
 354:	ff 45 fc             	incl   -0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 357:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
 35b:	75 a1                	jne    2fe <strtok+0x55>
 35d:	eb 01                	jmp    360 <strtok+0xb7>
    {
        //empty string
        if(*dummystr == '\0')
            break;
 35f:	90                   	nop
                dummystr++;
            }
        }
    }

    return start;
 360:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 363:	c9                   	leave  
 364:	c3                   	ret    
 365:	66 90                	xchg   %ax,%ax
 367:	90                   	nop

00000368 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 368:	b8 01 00 00 00       	mov    $0x1,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <exit>:
SYSCALL(exit)
 370:	b8 02 00 00 00       	mov    $0x2,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <wait>:
SYSCALL(wait)
 378:	b8 03 00 00 00       	mov    $0x3,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <pipe>:
SYSCALL(pipe)
 380:	b8 04 00 00 00       	mov    $0x4,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <read>:
SYSCALL(read)
 388:	b8 05 00 00 00       	mov    $0x5,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <write>:
SYSCALL(write)
 390:	b8 10 00 00 00       	mov    $0x10,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <close>:
SYSCALL(close)
 398:	b8 15 00 00 00       	mov    $0x15,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <kill>:
SYSCALL(kill)
 3a0:	b8 06 00 00 00       	mov    $0x6,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <exec>:
SYSCALL(exec)
 3a8:	b8 07 00 00 00       	mov    $0x7,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <open>:
SYSCALL(open)
 3b0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <mknod>:
SYSCALL(mknod)
 3b8:	b8 11 00 00 00       	mov    $0x11,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <unlink>:
SYSCALL(unlink)
 3c0:	b8 12 00 00 00       	mov    $0x12,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <fstat>:
SYSCALL(fstat)
 3c8:	b8 08 00 00 00       	mov    $0x8,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <link>:
SYSCALL(link)
 3d0:	b8 13 00 00 00       	mov    $0x13,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <mkdir>:
SYSCALL(mkdir)
 3d8:	b8 14 00 00 00       	mov    $0x14,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <chdir>:
SYSCALL(chdir)
 3e0:	b8 09 00 00 00       	mov    $0x9,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <dup>:
SYSCALL(dup)
 3e8:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <getpid>:
SYSCALL(getpid)
 3f0:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <sbrk>:
SYSCALL(sbrk)
 3f8:	b8 0c 00 00 00       	mov    $0xc,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <sleep>:
SYSCALL(sleep)
 400:	b8 0d 00 00 00       	mov    $0xd,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <uptime>:
SYSCALL(uptime)
 408:	b8 0e 00 00 00       	mov    $0xe,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <add_path>:
SYSCALL(add_path)
 410:	b8 16 00 00 00       	mov    $0x16,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <wait2>:
SYSCALL(wait2)
 418:	b8 17 00 00 00       	mov    $0x17,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	83 ec 28             	sub    $0x28,%esp
 426:	8b 45 0c             	mov    0xc(%ebp),%eax
 429:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 42c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 433:	00 
 434:	8d 45 f4             	lea    -0xc(%ebp),%eax
 437:	89 44 24 04          	mov    %eax,0x4(%esp)
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
 43e:	89 04 24             	mov    %eax,(%esp)
 441:	e8 4a ff ff ff       	call   390 <write>
}
 446:	c9                   	leave  
 447:	c3                   	ret    

00000448 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 448:	55                   	push   %ebp
 449:	89 e5                	mov    %esp,%ebp
 44b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 44e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 455:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 459:	74 17                	je     472 <printint+0x2a>
 45b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 45f:	79 11                	jns    472 <printint+0x2a>
    neg = 1;
 461:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 468:	8b 45 0c             	mov    0xc(%ebp),%eax
 46b:	f7 d8                	neg    %eax
 46d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 470:	eb 06                	jmp    478 <printint+0x30>
  } else {
    x = xx;
 472:	8b 45 0c             	mov    0xc(%ebp),%eax
 475:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 478:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 47f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 482:	8b 45 ec             	mov    -0x14(%ebp),%eax
 485:	ba 00 00 00 00       	mov    $0x0,%edx
 48a:	f7 f1                	div    %ecx
 48c:	89 d0                	mov    %edx,%eax
 48e:	8a 80 38 0b 00 00    	mov    0xb38(%eax),%al
 494:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 497:	8b 55 f4             	mov    -0xc(%ebp),%edx
 49a:	01 ca                	add    %ecx,%edx
 49c:	88 02                	mov    %al,(%edx)
 49e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 4a1:	8b 55 10             	mov    0x10(%ebp),%edx
 4a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4aa:	ba 00 00 00 00       	mov    $0x0,%edx
 4af:	f7 75 d4             	divl   -0x2c(%ebp)
 4b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b9:	75 c4                	jne    47f <printint+0x37>
  if(neg)
 4bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4bf:	74 2c                	je     4ed <printint+0xa5>
    buf[i++] = '-';
 4c1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c7:	01 d0                	add    %edx,%eax
 4c9:	c6 00 2d             	movb   $0x2d,(%eax)
 4cc:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4cf:	eb 1c                	jmp    4ed <printint+0xa5>
    putc(fd, buf[i]);
 4d1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d7:	01 d0                	add    %edx,%eax
 4d9:	8a 00                	mov    (%eax),%al
 4db:	0f be c0             	movsbl %al,%eax
 4de:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e2:	8b 45 08             	mov    0x8(%ebp),%eax
 4e5:	89 04 24             	mov    %eax,(%esp)
 4e8:	e8 33 ff ff ff       	call   420 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ed:	ff 4d f4             	decl   -0xc(%ebp)
 4f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f4:	79 db                	jns    4d1 <printint+0x89>
    putc(fd, buf[i]);
}
 4f6:	c9                   	leave  
 4f7:	c3                   	ret    

000004f8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f8:	55                   	push   %ebp
 4f9:	89 e5                	mov    %esp,%ebp
 4fb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 505:	8d 45 0c             	lea    0xc(%ebp),%eax
 508:	83 c0 04             	add    $0x4,%eax
 50b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 50e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 515:	e9 78 01 00 00       	jmp    692 <printf+0x19a>
    c = fmt[i] & 0xff;
 51a:	8b 55 0c             	mov    0xc(%ebp),%edx
 51d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 520:	01 d0                	add    %edx,%eax
 522:	8a 00                	mov    (%eax),%al
 524:	0f be c0             	movsbl %al,%eax
 527:	25 ff 00 00 00       	and    $0xff,%eax
 52c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 52f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 533:	75 2c                	jne    561 <printf+0x69>
      if(c == '%'){
 535:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 539:	75 0c                	jne    547 <printf+0x4f>
        state = '%';
 53b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 542:	e9 48 01 00 00       	jmp    68f <printf+0x197>
      } else {
        putc(fd, c);
 547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54a:	0f be c0             	movsbl %al,%eax
 54d:	89 44 24 04          	mov    %eax,0x4(%esp)
 551:	8b 45 08             	mov    0x8(%ebp),%eax
 554:	89 04 24             	mov    %eax,(%esp)
 557:	e8 c4 fe ff ff       	call   420 <putc>
 55c:	e9 2e 01 00 00       	jmp    68f <printf+0x197>
      }
    } else if(state == '%'){
 561:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 565:	0f 85 24 01 00 00    	jne    68f <printf+0x197>
      if(c == 'd'){
 56b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 56f:	75 2d                	jne    59e <printf+0xa6>
        printint(fd, *ap, 10, 1);
 571:	8b 45 e8             	mov    -0x18(%ebp),%eax
 574:	8b 00                	mov    (%eax),%eax
 576:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 57d:	00 
 57e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 585:	00 
 586:	89 44 24 04          	mov    %eax,0x4(%esp)
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	89 04 24             	mov    %eax,(%esp)
 590:	e8 b3 fe ff ff       	call   448 <printint>
        ap++;
 595:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 599:	e9 ea 00 00 00       	jmp    688 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 59e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5a2:	74 06                	je     5aa <printf+0xb2>
 5a4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5a8:	75 2d                	jne    5d7 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 5aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ad:	8b 00                	mov    (%eax),%eax
 5af:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5b6:	00 
 5b7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5be:	00 
 5bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	89 04 24             	mov    %eax,(%esp)
 5c9:	e8 7a fe ff ff       	call   448 <printint>
        ap++;
 5ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d2:	e9 b1 00 00 00       	jmp    688 <printf+0x190>
      } else if(c == 's'){
 5d7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5db:	75 43                	jne    620 <printf+0x128>
        s = (char*)*ap;
 5dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e0:	8b 00                	mov    (%eax),%eax
 5e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ed:	75 25                	jne    614 <printf+0x11c>
          s = "(null)";
 5ef:	c7 45 f4 d3 08 00 00 	movl   $0x8d3,-0xc(%ebp)
        while(*s != 0){
 5f6:	eb 1c                	jmp    614 <printf+0x11c>
          putc(fd, *s);
 5f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fb:	8a 00                	mov    (%eax),%al
 5fd:	0f be c0             	movsbl %al,%eax
 600:	89 44 24 04          	mov    %eax,0x4(%esp)
 604:	8b 45 08             	mov    0x8(%ebp),%eax
 607:	89 04 24             	mov    %eax,(%esp)
 60a:	e8 11 fe ff ff       	call   420 <putc>
          s++;
 60f:	ff 45 f4             	incl   -0xc(%ebp)
 612:	eb 01                	jmp    615 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 614:	90                   	nop
 615:	8b 45 f4             	mov    -0xc(%ebp),%eax
 618:	8a 00                	mov    (%eax),%al
 61a:	84 c0                	test   %al,%al
 61c:	75 da                	jne    5f8 <printf+0x100>
 61e:	eb 68                	jmp    688 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 620:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 624:	75 1d                	jne    643 <printf+0x14b>
        putc(fd, *ap);
 626:	8b 45 e8             	mov    -0x18(%ebp),%eax
 629:	8b 00                	mov    (%eax),%eax
 62b:	0f be c0             	movsbl %al,%eax
 62e:	89 44 24 04          	mov    %eax,0x4(%esp)
 632:	8b 45 08             	mov    0x8(%ebp),%eax
 635:	89 04 24             	mov    %eax,(%esp)
 638:	e8 e3 fd ff ff       	call   420 <putc>
        ap++;
 63d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 641:	eb 45                	jmp    688 <printf+0x190>
      } else if(c == '%'){
 643:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 647:	75 17                	jne    660 <printf+0x168>
        putc(fd, c);
 649:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 64c:	0f be c0             	movsbl %al,%eax
 64f:	89 44 24 04          	mov    %eax,0x4(%esp)
 653:	8b 45 08             	mov    0x8(%ebp),%eax
 656:	89 04 24             	mov    %eax,(%esp)
 659:	e8 c2 fd ff ff       	call   420 <putc>
 65e:	eb 28                	jmp    688 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 660:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 667:	00 
 668:	8b 45 08             	mov    0x8(%ebp),%eax
 66b:	89 04 24             	mov    %eax,(%esp)
 66e:	e8 ad fd ff ff       	call   420 <putc>
        putc(fd, c);
 673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 676:	0f be c0             	movsbl %al,%eax
 679:	89 44 24 04          	mov    %eax,0x4(%esp)
 67d:	8b 45 08             	mov    0x8(%ebp),%eax
 680:	89 04 24             	mov    %eax,(%esp)
 683:	e8 98 fd ff ff       	call   420 <putc>
      }
      state = 0;
 688:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 68f:	ff 45 f0             	incl   -0x10(%ebp)
 692:	8b 55 0c             	mov    0xc(%ebp),%edx
 695:	8b 45 f0             	mov    -0x10(%ebp),%eax
 698:	01 d0                	add    %edx,%eax
 69a:	8a 00                	mov    (%eax),%al
 69c:	84 c0                	test   %al,%al
 69e:	0f 85 76 fe ff ff    	jne    51a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6a4:	c9                   	leave  
 6a5:	c3                   	ret    
 6a6:	66 90                	xchg   %ax,%ax

000006a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a8:	55                   	push   %ebp
 6a9:	89 e5                	mov    %esp,%ebp
 6ab:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ae:	8b 45 08             	mov    0x8(%ebp),%eax
 6b1:	83 e8 08             	sub    $0x8,%eax
 6b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b7:	a1 58 0b 00 00       	mov    0xb58,%eax
 6bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6bf:	eb 24                	jmp    6e5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 00                	mov    (%eax),%eax
 6c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c9:	77 12                	ja     6dd <free+0x35>
 6cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d1:	77 24                	ja     6f7 <free+0x4f>
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	8b 00                	mov    (%eax),%eax
 6d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6db:	77 1a                	ja     6f7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6eb:	76 d4                	jbe    6c1 <free+0x19>
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 00                	mov    (%eax),%eax
 6f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f5:	76 ca                	jbe    6c1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	8b 40 04             	mov    0x4(%eax),%eax
 6fd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 704:	8b 45 f8             	mov    -0x8(%ebp),%eax
 707:	01 c2                	add    %eax,%edx
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	8b 00                	mov    (%eax),%eax
 70e:	39 c2                	cmp    %eax,%edx
 710:	75 24                	jne    736 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	8b 50 04             	mov    0x4(%eax),%edx
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	8b 00                	mov    (%eax),%eax
 71d:	8b 40 04             	mov    0x4(%eax),%eax
 720:	01 c2                	add    %eax,%edx
 722:	8b 45 f8             	mov    -0x8(%ebp),%eax
 725:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 00                	mov    (%eax),%eax
 72d:	8b 10                	mov    (%eax),%edx
 72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 732:	89 10                	mov    %edx,(%eax)
 734:	eb 0a                	jmp    740 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 10                	mov    (%eax),%edx
 73b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 40 04             	mov    0x4(%eax),%eax
 746:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	01 d0                	add    %edx,%eax
 752:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 755:	75 20                	jne    777 <free+0xcf>
    p->s.size += bp->s.size;
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	8b 50 04             	mov    0x4(%eax),%edx
 75d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 760:	8b 40 04             	mov    0x4(%eax),%eax
 763:	01 c2                	add    %eax,%edx
 765:	8b 45 fc             	mov    -0x4(%ebp),%eax
 768:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 76b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76e:	8b 10                	mov    (%eax),%edx
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	89 10                	mov    %edx,(%eax)
 775:	eb 08                	jmp    77f <free+0xd7>
  } else
    p->s.ptr = bp;
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 77d:	89 10                	mov    %edx,(%eax)
  freep = p;
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	a3 58 0b 00 00       	mov    %eax,0xb58
}
 787:	c9                   	leave  
 788:	c3                   	ret    

00000789 <morecore>:

static Header*
morecore(uint nu)
{
 789:	55                   	push   %ebp
 78a:	89 e5                	mov    %esp,%ebp
 78c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 78f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 796:	77 07                	ja     79f <morecore+0x16>
    nu = 4096;
 798:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 79f:	8b 45 08             	mov    0x8(%ebp),%eax
 7a2:	c1 e0 03             	shl    $0x3,%eax
 7a5:	89 04 24             	mov    %eax,(%esp)
 7a8:	e8 4b fc ff ff       	call   3f8 <sbrk>
 7ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7b0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7b4:	75 07                	jne    7bd <morecore+0x34>
    return 0;
 7b6:	b8 00 00 00 00       	mov    $0x0,%eax
 7bb:	eb 22                	jmp    7df <morecore+0x56>
  hp = (Header*)p;
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c6:	8b 55 08             	mov    0x8(%ebp),%edx
 7c9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cf:	83 c0 08             	add    $0x8,%eax
 7d2:	89 04 24             	mov    %eax,(%esp)
 7d5:	e8 ce fe ff ff       	call   6a8 <free>
  return freep;
 7da:	a1 58 0b 00 00       	mov    0xb58,%eax
}
 7df:	c9                   	leave  
 7e0:	c3                   	ret    

000007e1 <malloc>:

void*
malloc(uint nbytes)
{
 7e1:	55                   	push   %ebp
 7e2:	89 e5                	mov    %esp,%ebp
 7e4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ea:	83 c0 07             	add    $0x7,%eax
 7ed:	c1 e8 03             	shr    $0x3,%eax
 7f0:	40                   	inc    %eax
 7f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7f4:	a1 58 0b 00 00       	mov    0xb58,%eax
 7f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 800:	75 23                	jne    825 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 802:	c7 45 f0 50 0b 00 00 	movl   $0xb50,-0x10(%ebp)
 809:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80c:	a3 58 0b 00 00       	mov    %eax,0xb58
 811:	a1 58 0b 00 00       	mov    0xb58,%eax
 816:	a3 50 0b 00 00       	mov    %eax,0xb50
    base.s.size = 0;
 81b:	c7 05 54 0b 00 00 00 	movl   $0x0,0xb54
 822:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 825:	8b 45 f0             	mov    -0x10(%ebp),%eax
 828:	8b 00                	mov    (%eax),%eax
 82a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	8b 40 04             	mov    0x4(%eax),%eax
 833:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 836:	72 4d                	jb     885 <malloc+0xa4>
      if(p->s.size == nunits)
 838:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83b:	8b 40 04             	mov    0x4(%eax),%eax
 83e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 841:	75 0c                	jne    84f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	8b 10                	mov    (%eax),%edx
 848:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84b:	89 10                	mov    %edx,(%eax)
 84d:	eb 26                	jmp    875 <malloc+0x94>
      else {
        p->s.size -= nunits;
 84f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 852:	8b 40 04             	mov    0x4(%eax),%eax
 855:	89 c2                	mov    %eax,%edx
 857:	2b 55 ec             	sub    -0x14(%ebp),%edx
 85a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 860:	8b 45 f4             	mov    -0xc(%ebp),%eax
 863:	8b 40 04             	mov    0x4(%eax),%eax
 866:	c1 e0 03             	shl    $0x3,%eax
 869:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 86c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 872:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 875:	8b 45 f0             	mov    -0x10(%ebp),%eax
 878:	a3 58 0b 00 00       	mov    %eax,0xb58
      return (void*)(p + 1);
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	83 c0 08             	add    $0x8,%eax
 883:	eb 38                	jmp    8bd <malloc+0xdc>
    }
    if(p == freep)
 885:	a1 58 0b 00 00       	mov    0xb58,%eax
 88a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 88d:	75 1b                	jne    8aa <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 88f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 892:	89 04 24             	mov    %eax,(%esp)
 895:	e8 ef fe ff ff       	call   789 <morecore>
 89a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 89d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a1:	75 07                	jne    8aa <malloc+0xc9>
        return 0;
 8a3:	b8 00 00 00 00       	mov    $0x0,%eax
 8a8:	eb 13                	jmp    8bd <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b3:	8b 00                	mov    (%eax),%eax
 8b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8b8:	e9 70 ff ff ff       	jmp    82d <malloc+0x4c>
}
 8bd:	c9                   	leave  
 8be:	c3                   	ret    
