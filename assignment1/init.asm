
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 aa 08 00 00 	movl   $0x8aa,(%esp)
  18:	e8 83 03 00 00       	call   3a0 <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 aa 08 00 00 	movl   $0x8aa,(%esp)
  38:	e8 6b 03 00 00       	call   3a8 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 aa 08 00 00 	movl   $0x8aa,(%esp)
  4c:	e8 4f 03 00 00       	call   3a0 <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 7b 03 00 00       	call   3d8 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 6f 03 00 00       	call   3d8 <dup>
  69:	eb 01                	jmp    6c <main+0x6c>
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
  6b:	90                   	nop
  }
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
  6c:	c7 44 24 04 b2 08 00 	movl   $0x8b2,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 60 04 00 00       	call   4e0 <printf>
    pid = fork();
  80:	e8 d3 02 00 00       	call   358 <fork>
  85:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  89:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 c5 08 00 	movl   $0x8c5,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 3c 04 00 00       	call   4e0 <printf>
      exit();
  a4:	e8 b7 02 00 00       	call   360 <exit>
    }
    if(pid == 0){
  a9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ae:	75 41                	jne    f1 <main+0xf1>
      exec("sh", argv);
  b0:	c7 44 24 04 3c 0b 00 	movl   $0xb3c,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 a7 08 00 00 	movl   $0x8a7,(%esp)
  bf:	e8 d4 02 00 00       	call   398 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 d8 08 00 	movl   $0x8d8,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 08 04 00 00       	call   4e0 <printf>
      exit();
  d8:	e8 83 02 00 00       	call   360 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  dd:	c7 44 24 04 ee 08 00 	movl   $0x8ee,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 ef 03 00 00       	call   4e0 <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f1:	e8 72 02 00 00       	call   368 <wait>
  f6:	89 44 24 18          	mov    %eax,0x18(%esp)
  fa:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  ff:	0f 88 66 ff ff ff    	js     6b <main+0x6b>
 105:	8b 44 24 18          	mov    0x18(%esp),%eax
 109:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 10d:	75 ce                	jne    dd <main+0xdd>
      printf(1, "zombie!\n");
  }
 10f:	e9 57 ff ff ff       	jmp    6b <main+0x6b>

00000114 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 119:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11c:	8b 55 10             	mov    0x10(%ebp),%edx
 11f:	8b 45 0c             	mov    0xc(%ebp),%eax
 122:	89 cb                	mov    %ecx,%ebx
 124:	89 df                	mov    %ebx,%edi
 126:	89 d1                	mov    %edx,%ecx
 128:	fc                   	cld    
 129:	f3 aa                	rep stos %al,%es:(%edi)
 12b:	89 ca                	mov    %ecx,%edx
 12d:	89 fb                	mov    %edi,%ebx
 12f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 132:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 135:	5b                   	pop    %ebx
 136:	5f                   	pop    %edi
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    

00000139 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 145:	90                   	nop
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	8a 10                	mov    (%eax),%dl
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	88 10                	mov    %dl,(%eax)
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	8a 00                	mov    (%eax),%al
 155:	84 c0                	test   %al,%al
 157:	0f 95 c0             	setne  %al
 15a:	ff 45 08             	incl   0x8(%ebp)
 15d:	ff 45 0c             	incl   0xc(%ebp)
 160:	84 c0                	test   %al,%al
 162:	75 e2                	jne    146 <strcpy+0xd>
    ;
  return os;
 164:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 167:	c9                   	leave  
 168:	c3                   	ret    

00000169 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 169:	55                   	push   %ebp
 16a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16c:	eb 06                	jmp    174 <strcmp+0xb>
    p++, q++;
 16e:	ff 45 08             	incl   0x8(%ebp)
 171:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	8a 00                	mov    (%eax),%al
 179:	84 c0                	test   %al,%al
 17b:	74 0e                	je     18b <strcmp+0x22>
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	8a 10                	mov    (%eax),%dl
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	8a 00                	mov    (%eax),%al
 187:	38 c2                	cmp    %al,%dl
 189:	74 e3                	je     16e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	8a 00                	mov    (%eax),%al
 190:	0f b6 d0             	movzbl %al,%edx
 193:	8b 45 0c             	mov    0xc(%ebp),%eax
 196:	8a 00                	mov    (%eax),%al
 198:	0f b6 c0             	movzbl %al,%eax
 19b:	89 d1                	mov    %edx,%ecx
 19d:	29 c1                	sub    %eax,%ecx
 19f:	89 c8                	mov    %ecx,%eax
}
 1a1:	5d                   	pop    %ebp
 1a2:	c3                   	ret    

000001a3 <strlen>:

uint
strlen(char *s)
{
 1a3:	55                   	push   %ebp
 1a4:	89 e5                	mov    %esp,%ebp
 1a6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b0:	eb 03                	jmp    1b5 <strlen+0x12>
 1b2:	ff 45 fc             	incl   -0x4(%ebp)
 1b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	01 d0                	add    %edx,%eax
 1bd:	8a 00                	mov    (%eax),%al
 1bf:	84 c0                	test   %al,%al
 1c1:	75 ef                	jne    1b2 <strlen+0xf>
    ;
  return n;
 1c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c6:	c9                   	leave  
 1c7:	c3                   	ret    

000001c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c8:	55                   	push   %ebp
 1c9:	89 e5                	mov    %esp,%ebp
 1cb:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1ce:	8b 45 10             	mov    0x10(%ebp),%eax
 1d1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	89 04 24             	mov    %eax,(%esp)
 1e2:	e8 2d ff ff ff       	call   114 <stosb>
  return dst;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <strchr>:

char*
strchr(const char *s, char c)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 04             	sub    $0x4,%esp
 1f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f8:	eb 12                	jmp    20c <strchr+0x20>
    if(*s == c)
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	8a 00                	mov    (%eax),%al
 1ff:	3a 45 fc             	cmp    -0x4(%ebp),%al
 202:	75 05                	jne    209 <strchr+0x1d>
      return (char*)s;
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	eb 11                	jmp    21a <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 209:	ff 45 08             	incl   0x8(%ebp)
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	8a 00                	mov    (%eax),%al
 211:	84 c0                	test   %al,%al
 213:	75 e5                	jne    1fa <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 215:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21a:	c9                   	leave  
 21b:	c3                   	ret    

0000021c <gets>:

char*
gets(char *buf, int max)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
 21f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 222:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 229:	eb 42                	jmp    26d <gets+0x51>
    cc = read(0, &c, 1);
 22b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 232:	00 
 233:	8d 45 ef             	lea    -0x11(%ebp),%eax
 236:	89 44 24 04          	mov    %eax,0x4(%esp)
 23a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 241:	e8 32 01 00 00       	call   378 <read>
 246:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 249:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 24d:	7e 29                	jle    278 <gets+0x5c>
      break;
    buf[i++] = c;
 24f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 252:	8b 45 08             	mov    0x8(%ebp),%eax
 255:	01 c2                	add    %eax,%edx
 257:	8a 45 ef             	mov    -0x11(%ebp),%al
 25a:	88 02                	mov    %al,(%edx)
 25c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 25f:	8a 45 ef             	mov    -0x11(%ebp),%al
 262:	3c 0a                	cmp    $0xa,%al
 264:	74 13                	je     279 <gets+0x5d>
 266:	8a 45 ef             	mov    -0x11(%ebp),%al
 269:	3c 0d                	cmp    $0xd,%al
 26b:	74 0c                	je     279 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 270:	40                   	inc    %eax
 271:	3b 45 0c             	cmp    0xc(%ebp),%eax
 274:	7c b5                	jl     22b <gets+0xf>
 276:	eb 01                	jmp    279 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 278:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 279:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	01 d0                	add    %edx,%eax
 281:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 284:	8b 45 08             	mov    0x8(%ebp),%eax
}
 287:	c9                   	leave  
 288:	c3                   	ret    

00000289 <stat>:

int
stat(char *n, struct stat *st)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 296:	00 
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	89 04 24             	mov    %eax,(%esp)
 29d:	e8 fe 00 00 00       	call   3a0 <open>
 2a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a9:	79 07                	jns    2b2 <stat+0x29>
    return -1;
 2ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b0:	eb 23                	jmp    2d5 <stat+0x4c>
  r = fstat(fd, st);
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bc:	89 04 24             	mov    %eax,(%esp)
 2bf:	e8 f4 00 00 00       	call   3b8 <fstat>
 2c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ca:	89 04 24             	mov    %eax,(%esp)
 2cd:	e8 b6 00 00 00       	call   388 <close>
  return r;
 2d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d5:	c9                   	leave  
 2d6:	c3                   	ret    

000002d7 <atoi>:

int
atoi(const char *s)
{
 2d7:	55                   	push   %ebp
 2d8:	89 e5                	mov    %esp,%ebp
 2da:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e4:	eb 21                	jmp    307 <atoi+0x30>
    n = n*10 + *s++ - '0';
 2e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e9:	89 d0                	mov    %edx,%eax
 2eb:	c1 e0 02             	shl    $0x2,%eax
 2ee:	01 d0                	add    %edx,%eax
 2f0:	d1 e0                	shl    %eax
 2f2:	89 c2                	mov    %eax,%edx
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	8a 00                	mov    (%eax),%al
 2f9:	0f be c0             	movsbl %al,%eax
 2fc:	01 d0                	add    %edx,%eax
 2fe:	83 e8 30             	sub    $0x30,%eax
 301:	89 45 fc             	mov    %eax,-0x4(%ebp)
 304:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	8a 00                	mov    (%eax),%al
 30c:	3c 2f                	cmp    $0x2f,%al
 30e:	7e 09                	jle    319 <atoi+0x42>
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	8a 00                	mov    (%eax),%al
 315:	3c 39                	cmp    $0x39,%al
 317:	7e cd                	jle    2e6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 319:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31c:	c9                   	leave  
 31d:	c3                   	ret    

0000031e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 31e:	55                   	push   %ebp
 31f:	89 e5                	mov    %esp,%ebp
 321:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32a:	8b 45 0c             	mov    0xc(%ebp),%eax
 32d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 330:	eb 10                	jmp    342 <memmove+0x24>
    *dst++ = *src++;
 332:	8b 45 f8             	mov    -0x8(%ebp),%eax
 335:	8a 10                	mov    (%eax),%dl
 337:	8b 45 fc             	mov    -0x4(%ebp),%eax
 33a:	88 10                	mov    %dl,(%eax)
 33c:	ff 45 fc             	incl   -0x4(%ebp)
 33f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 342:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 346:	0f 9f c0             	setg   %al
 349:	ff 4d 10             	decl   0x10(%ebp)
 34c:	84 c0                	test   %al,%al
 34e:	75 e2                	jne    332 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
}
 353:	c9                   	leave  
 354:	c3                   	ret    
 355:	66 90                	xchg   %ax,%ax
 357:	90                   	nop

00000358 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 358:	b8 01 00 00 00       	mov    $0x1,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <exit>:
SYSCALL(exit)
 360:	b8 02 00 00 00       	mov    $0x2,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <wait>:
SYSCALL(wait)
 368:	b8 03 00 00 00       	mov    $0x3,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <pipe>:
SYSCALL(pipe)
 370:	b8 04 00 00 00       	mov    $0x4,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <read>:
SYSCALL(read)
 378:	b8 05 00 00 00       	mov    $0x5,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <write>:
SYSCALL(write)
 380:	b8 10 00 00 00       	mov    $0x10,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <close>:
SYSCALL(close)
 388:	b8 15 00 00 00       	mov    $0x15,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <kill>:
SYSCALL(kill)
 390:	b8 06 00 00 00       	mov    $0x6,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <exec>:
SYSCALL(exec)
 398:	b8 07 00 00 00       	mov    $0x7,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <open>:
SYSCALL(open)
 3a0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <mknod>:
SYSCALL(mknod)
 3a8:	b8 11 00 00 00       	mov    $0x11,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <unlink>:
SYSCALL(unlink)
 3b0:	b8 12 00 00 00       	mov    $0x12,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <fstat>:
SYSCALL(fstat)
 3b8:	b8 08 00 00 00       	mov    $0x8,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <link>:
SYSCALL(link)
 3c0:	b8 13 00 00 00       	mov    $0x13,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <mkdir>:
SYSCALL(mkdir)
 3c8:	b8 14 00 00 00       	mov    $0x14,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <chdir>:
SYSCALL(chdir)
 3d0:	b8 09 00 00 00       	mov    $0x9,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <dup>:
SYSCALL(dup)
 3d8:	b8 0a 00 00 00       	mov    $0xa,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <getpid>:
SYSCALL(getpid)
 3e0:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <sbrk>:
SYSCALL(sbrk)
 3e8:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <sleep>:
SYSCALL(sleep)
 3f0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <uptime>:
SYSCALL(uptime)
 3f8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <addpath>:
SYSCALL(addpath)
 400:	b8 16 00 00 00       	mov    $0x16,%eax
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
 429:	e8 52 ff ff ff       	call   380 <write>
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
 476:	8a 80 44 0b 00 00    	mov    0xb44(%eax),%al
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
 5d7:	c7 45 f4 f7 08 00 00 	movl   $0x8f7,-0xc(%ebp)
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
 69f:	a1 60 0b 00 00       	mov    0xb60,%eax
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
 76a:	a3 60 0b 00 00       	mov    %eax,0xb60
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
 790:	e8 53 fc ff ff       	call   3e8 <sbrk>
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
 7c2:	a1 60 0b 00 00       	mov    0xb60,%eax
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
 7dc:	a1 60 0b 00 00       	mov    0xb60,%eax
 7e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e8:	75 23                	jne    80d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7ea:	c7 45 f0 58 0b 00 00 	movl   $0xb58,-0x10(%ebp)
 7f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f4:	a3 60 0b 00 00       	mov    %eax,0xb60
 7f9:	a1 60 0b 00 00       	mov    0xb60,%eax
 7fe:	a3 58 0b 00 00       	mov    %eax,0xb58
    base.s.size = 0;
 803:	c7 05 5c 0b 00 00 00 	movl   $0x0,0xb5c
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
 860:	a3 60 0b 00 00       	mov    %eax,0xb60
      return (void*)(p + 1);
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	83 c0 08             	add    $0x8,%eax
 86b:	eb 38                	jmp    8a5 <malloc+0xdc>
    }
    if(p == freep)
 86d:	a1 60 0b 00 00       	mov    0xb60,%eax
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
