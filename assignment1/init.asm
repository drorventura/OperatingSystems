
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
  11:	c7 04 24 a2 08 00 00 	movl   $0x8a2,(%esp)
  18:	e8 83 03 00 00       	call   3a0 <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 a2 08 00 00 	movl   $0x8a2,(%esp)
  38:	e8 6b 03 00 00       	call   3a8 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 a2 08 00 00 	movl   $0x8a2,(%esp)
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
  6c:	c7 44 24 04 aa 08 00 	movl   $0x8aa,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 58 04 00 00       	call   4d8 <printf>
    pid = fork();
  80:	e8 d3 02 00 00       	call   358 <fork>
  85:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  89:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 bd 08 00 	movl   $0x8bd,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 34 04 00 00       	call   4d8 <printf>
      exit();
  a4:	e8 b7 02 00 00       	call   360 <exit>
    }
    if(pid == 0){
  a9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ae:	75 41                	jne    f1 <main+0xf1>
      exec("sh", argv);
  b0:	c7 44 24 04 34 0b 00 	movl   $0xb34,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 9f 08 00 00 	movl   $0x89f,(%esp)
  bf:	e8 d4 02 00 00       	call   398 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 d0 08 00 	movl   $0x8d0,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 00 04 00 00       	call   4d8 <printf>
      exit();
  d8:	e8 83 02 00 00       	call   360 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  dd:	c7 44 24 04 e6 08 00 	movl   $0x8e6,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 e7 03 00 00       	call   4d8 <printf>
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

00000400 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	83 ec 28             	sub    $0x28,%esp
 406:	8b 45 0c             	mov    0xc(%ebp),%eax
 409:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 40c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 413:	00 
 414:	8d 45 f4             	lea    -0xc(%ebp),%eax
 417:	89 44 24 04          	mov    %eax,0x4(%esp)
 41b:	8b 45 08             	mov    0x8(%ebp),%eax
 41e:	89 04 24             	mov    %eax,(%esp)
 421:	e8 5a ff ff ff       	call   380 <write>
}
 426:	c9                   	leave  
 427:	c3                   	ret    

00000428 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 428:	55                   	push   %ebp
 429:	89 e5                	mov    %esp,%ebp
 42b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 42e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 435:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 439:	74 17                	je     452 <printint+0x2a>
 43b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 43f:	79 11                	jns    452 <printint+0x2a>
    neg = 1;
 441:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 448:	8b 45 0c             	mov    0xc(%ebp),%eax
 44b:	f7 d8                	neg    %eax
 44d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 450:	eb 06                	jmp    458 <printint+0x30>
  } else {
    x = xx;
 452:	8b 45 0c             	mov    0xc(%ebp),%eax
 455:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 458:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 45f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 462:	8b 45 ec             	mov    -0x14(%ebp),%eax
 465:	ba 00 00 00 00       	mov    $0x0,%edx
 46a:	f7 f1                	div    %ecx
 46c:	89 d0                	mov    %edx,%eax
 46e:	8a 80 3c 0b 00 00    	mov    0xb3c(%eax),%al
 474:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 477:	8b 55 f4             	mov    -0xc(%ebp),%edx
 47a:	01 ca                	add    %ecx,%edx
 47c:	88 02                	mov    %al,(%edx)
 47e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 481:	8b 55 10             	mov    0x10(%ebp),%edx
 484:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 487:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48a:	ba 00 00 00 00       	mov    $0x0,%edx
 48f:	f7 75 d4             	divl   -0x2c(%ebp)
 492:	89 45 ec             	mov    %eax,-0x14(%ebp)
 495:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 499:	75 c4                	jne    45f <printint+0x37>
  if(neg)
 49b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 49f:	74 2c                	je     4cd <printint+0xa5>
    buf[i++] = '-';
 4a1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a7:	01 d0                	add    %edx,%eax
 4a9:	c6 00 2d             	movb   $0x2d,(%eax)
 4ac:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4af:	eb 1c                	jmp    4cd <printint+0xa5>
    putc(fd, buf[i]);
 4b1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b7:	01 d0                	add    %edx,%eax
 4b9:	8a 00                	mov    (%eax),%al
 4bb:	0f be c0             	movsbl %al,%eax
 4be:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c2:	8b 45 08             	mov    0x8(%ebp),%eax
 4c5:	89 04 24             	mov    %eax,(%esp)
 4c8:	e8 33 ff ff ff       	call   400 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4cd:	ff 4d f4             	decl   -0xc(%ebp)
 4d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d4:	79 db                	jns    4b1 <printint+0x89>
    putc(fd, buf[i]);
}
 4d6:	c9                   	leave  
 4d7:	c3                   	ret    

000004d8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d8:	55                   	push   %ebp
 4d9:	89 e5                	mov    %esp,%ebp
 4db:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e5:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e8:	83 c0 04             	add    $0x4,%eax
 4eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f5:	e9 78 01 00 00       	jmp    672 <printf+0x19a>
    c = fmt[i] & 0xff;
 4fa:	8b 55 0c             	mov    0xc(%ebp),%edx
 4fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 500:	01 d0                	add    %edx,%eax
 502:	8a 00                	mov    (%eax),%al
 504:	0f be c0             	movsbl %al,%eax
 507:	25 ff 00 00 00       	and    $0xff,%eax
 50c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 50f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 513:	75 2c                	jne    541 <printf+0x69>
      if(c == '%'){
 515:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 519:	75 0c                	jne    527 <printf+0x4f>
        state = '%';
 51b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 522:	e9 48 01 00 00       	jmp    66f <printf+0x197>
      } else {
        putc(fd, c);
 527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52a:	0f be c0             	movsbl %al,%eax
 52d:	89 44 24 04          	mov    %eax,0x4(%esp)
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	89 04 24             	mov    %eax,(%esp)
 537:	e8 c4 fe ff ff       	call   400 <putc>
 53c:	e9 2e 01 00 00       	jmp    66f <printf+0x197>
      }
    } else if(state == '%'){
 541:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 545:	0f 85 24 01 00 00    	jne    66f <printf+0x197>
      if(c == 'd'){
 54b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 54f:	75 2d                	jne    57e <printf+0xa6>
        printint(fd, *ap, 10, 1);
 551:	8b 45 e8             	mov    -0x18(%ebp),%eax
 554:	8b 00                	mov    (%eax),%eax
 556:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 55d:	00 
 55e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 565:	00 
 566:	89 44 24 04          	mov    %eax,0x4(%esp)
 56a:	8b 45 08             	mov    0x8(%ebp),%eax
 56d:	89 04 24             	mov    %eax,(%esp)
 570:	e8 b3 fe ff ff       	call   428 <printint>
        ap++;
 575:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 579:	e9 ea 00 00 00       	jmp    668 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 57e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 582:	74 06                	je     58a <printf+0xb2>
 584:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 588:	75 2d                	jne    5b7 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 58a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58d:	8b 00                	mov    (%eax),%eax
 58f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 596:	00 
 597:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 59e:	00 
 59f:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a3:	8b 45 08             	mov    0x8(%ebp),%eax
 5a6:	89 04 24             	mov    %eax,(%esp)
 5a9:	e8 7a fe ff ff       	call   428 <printint>
        ap++;
 5ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b2:	e9 b1 00 00 00       	jmp    668 <printf+0x190>
      } else if(c == 's'){
 5b7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5bb:	75 43                	jne    600 <printf+0x128>
        s = (char*)*ap;
 5bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c0:	8b 00                	mov    (%eax),%eax
 5c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5cd:	75 25                	jne    5f4 <printf+0x11c>
          s = "(null)";
 5cf:	c7 45 f4 ef 08 00 00 	movl   $0x8ef,-0xc(%ebp)
        while(*s != 0){
 5d6:	eb 1c                	jmp    5f4 <printf+0x11c>
          putc(fd, *s);
 5d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5db:	8a 00                	mov    (%eax),%al
 5dd:	0f be c0             	movsbl %al,%eax
 5e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e4:	8b 45 08             	mov    0x8(%ebp),%eax
 5e7:	89 04 24             	mov    %eax,(%esp)
 5ea:	e8 11 fe ff ff       	call   400 <putc>
          s++;
 5ef:	ff 45 f4             	incl   -0xc(%ebp)
 5f2:	eb 01                	jmp    5f5 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f4:	90                   	nop
 5f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f8:	8a 00                	mov    (%eax),%al
 5fa:	84 c0                	test   %al,%al
 5fc:	75 da                	jne    5d8 <printf+0x100>
 5fe:	eb 68                	jmp    668 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 600:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 604:	75 1d                	jne    623 <printf+0x14b>
        putc(fd, *ap);
 606:	8b 45 e8             	mov    -0x18(%ebp),%eax
 609:	8b 00                	mov    (%eax),%eax
 60b:	0f be c0             	movsbl %al,%eax
 60e:	89 44 24 04          	mov    %eax,0x4(%esp)
 612:	8b 45 08             	mov    0x8(%ebp),%eax
 615:	89 04 24             	mov    %eax,(%esp)
 618:	e8 e3 fd ff ff       	call   400 <putc>
        ap++;
 61d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 621:	eb 45                	jmp    668 <printf+0x190>
      } else if(c == '%'){
 623:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 627:	75 17                	jne    640 <printf+0x168>
        putc(fd, c);
 629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62c:	0f be c0             	movsbl %al,%eax
 62f:	89 44 24 04          	mov    %eax,0x4(%esp)
 633:	8b 45 08             	mov    0x8(%ebp),%eax
 636:	89 04 24             	mov    %eax,(%esp)
 639:	e8 c2 fd ff ff       	call   400 <putc>
 63e:	eb 28                	jmp    668 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 640:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 647:	00 
 648:	8b 45 08             	mov    0x8(%ebp),%eax
 64b:	89 04 24             	mov    %eax,(%esp)
 64e:	e8 ad fd ff ff       	call   400 <putc>
        putc(fd, c);
 653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 656:	0f be c0             	movsbl %al,%eax
 659:	89 44 24 04          	mov    %eax,0x4(%esp)
 65d:	8b 45 08             	mov    0x8(%ebp),%eax
 660:	89 04 24             	mov    %eax,(%esp)
 663:	e8 98 fd ff ff       	call   400 <putc>
      }
      state = 0;
 668:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 66f:	ff 45 f0             	incl   -0x10(%ebp)
 672:	8b 55 0c             	mov    0xc(%ebp),%edx
 675:	8b 45 f0             	mov    -0x10(%ebp),%eax
 678:	01 d0                	add    %edx,%eax
 67a:	8a 00                	mov    (%eax),%al
 67c:	84 c0                	test   %al,%al
 67e:	0f 85 76 fe ff ff    	jne    4fa <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 684:	c9                   	leave  
 685:	c3                   	ret    
 686:	66 90                	xchg   %ax,%ax

00000688 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 688:	55                   	push   %ebp
 689:	89 e5                	mov    %esp,%ebp
 68b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68e:	8b 45 08             	mov    0x8(%ebp),%eax
 691:	83 e8 08             	sub    $0x8,%eax
 694:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 697:	a1 58 0b 00 00       	mov    0xb58,%eax
 69c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69f:	eb 24                	jmp    6c5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a9:	77 12                	ja     6bd <free+0x35>
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b1:	77 24                	ja     6d7 <free+0x4f>
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 00                	mov    (%eax),%eax
 6b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bb:	77 1a                	ja     6d7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cb:	76 d4                	jbe    6a1 <free+0x19>
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d5:	76 ca                	jbe    6a1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6da:	8b 40 04             	mov    0x4(%eax),%eax
 6dd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	01 c2                	add    %eax,%edx
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	39 c2                	cmp    %eax,%edx
 6f0:	75 24                	jne    716 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	8b 50 04             	mov    0x4(%eax),%edx
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	8b 00                	mov    (%eax),%eax
 6fd:	8b 40 04             	mov    0x4(%eax),%eax
 700:	01 c2                	add    %eax,%edx
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 00                	mov    (%eax),%eax
 70d:	8b 10                	mov    (%eax),%edx
 70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 712:	89 10                	mov    %edx,(%eax)
 714:	eb 0a                	jmp    720 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	8b 10                	mov    (%eax),%edx
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 40 04             	mov    0x4(%eax),%eax
 726:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	01 d0                	add    %edx,%eax
 732:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 735:	75 20                	jne    757 <free+0xcf>
    p->s.size += bp->s.size;
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	8b 50 04             	mov    0x4(%eax),%edx
 73d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 740:	8b 40 04             	mov    0x4(%eax),%eax
 743:	01 c2                	add    %eax,%edx
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 74b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74e:	8b 10                	mov    (%eax),%edx
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	89 10                	mov    %edx,(%eax)
 755:	eb 08                	jmp    75f <free+0xd7>
  } else
    p->s.ptr = bp;
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 75d:	89 10                	mov    %edx,(%eax)
  freep = p;
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	a3 58 0b 00 00       	mov    %eax,0xb58
}
 767:	c9                   	leave  
 768:	c3                   	ret    

00000769 <morecore>:

static Header*
morecore(uint nu)
{
 769:	55                   	push   %ebp
 76a:	89 e5                	mov    %esp,%ebp
 76c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 76f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 776:	77 07                	ja     77f <morecore+0x16>
    nu = 4096;
 778:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 77f:	8b 45 08             	mov    0x8(%ebp),%eax
 782:	c1 e0 03             	shl    $0x3,%eax
 785:	89 04 24             	mov    %eax,(%esp)
 788:	e8 5b fc ff ff       	call   3e8 <sbrk>
 78d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 790:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 794:	75 07                	jne    79d <morecore+0x34>
    return 0;
 796:	b8 00 00 00 00       	mov    $0x0,%eax
 79b:	eb 22                	jmp    7bf <morecore+0x56>
  hp = (Header*)p;
 79d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a6:	8b 55 08             	mov    0x8(%ebp),%edx
 7a9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7af:	83 c0 08             	add    $0x8,%eax
 7b2:	89 04 24             	mov    %eax,(%esp)
 7b5:	e8 ce fe ff ff       	call   688 <free>
  return freep;
 7ba:	a1 58 0b 00 00       	mov    0xb58,%eax
}
 7bf:	c9                   	leave  
 7c0:	c3                   	ret    

000007c1 <malloc>:

void*
malloc(uint nbytes)
{
 7c1:	55                   	push   %ebp
 7c2:	89 e5                	mov    %esp,%ebp
 7c4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ca:	83 c0 07             	add    $0x7,%eax
 7cd:	c1 e8 03             	shr    $0x3,%eax
 7d0:	40                   	inc    %eax
 7d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7d4:	a1 58 0b 00 00       	mov    0xb58,%eax
 7d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e0:	75 23                	jne    805 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7e2:	c7 45 f0 50 0b 00 00 	movl   $0xb50,-0x10(%ebp)
 7e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ec:	a3 58 0b 00 00       	mov    %eax,0xb58
 7f1:	a1 58 0b 00 00       	mov    0xb58,%eax
 7f6:	a3 50 0b 00 00       	mov    %eax,0xb50
    base.s.size = 0;
 7fb:	c7 05 54 0b 00 00 00 	movl   $0x0,0xb54
 802:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 805:	8b 45 f0             	mov    -0x10(%ebp),%eax
 808:	8b 00                	mov    (%eax),%eax
 80a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	8b 40 04             	mov    0x4(%eax),%eax
 813:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 816:	72 4d                	jb     865 <malloc+0xa4>
      if(p->s.size == nunits)
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	8b 40 04             	mov    0x4(%eax),%eax
 81e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 821:	75 0c                	jne    82f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	8b 10                	mov    (%eax),%edx
 828:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82b:	89 10                	mov    %edx,(%eax)
 82d:	eb 26                	jmp    855 <malloc+0x94>
      else {
        p->s.size -= nunits;
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	8b 40 04             	mov    0x4(%eax),%eax
 835:	89 c2                	mov    %eax,%edx
 837:	2b 55 ec             	sub    -0x14(%ebp),%edx
 83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	8b 40 04             	mov    0x4(%eax),%eax
 846:	c1 e0 03             	shl    $0x3,%eax
 849:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 852:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 855:	8b 45 f0             	mov    -0x10(%ebp),%eax
 858:	a3 58 0b 00 00       	mov    %eax,0xb58
      return (void*)(p + 1);
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	83 c0 08             	add    $0x8,%eax
 863:	eb 38                	jmp    89d <malloc+0xdc>
    }
    if(p == freep)
 865:	a1 58 0b 00 00       	mov    0xb58,%eax
 86a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 86d:	75 1b                	jne    88a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 86f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 872:	89 04 24             	mov    %eax,(%esp)
 875:	e8 ef fe ff ff       	call   769 <morecore>
 87a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 87d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 881:	75 07                	jne    88a <malloc+0xc9>
        return 0;
 883:	b8 00 00 00 00       	mov    $0x0,%eax
 888:	eb 13                	jmp    89d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 890:	8b 45 f4             	mov    -0xc(%ebp),%eax
 893:	8b 00                	mov    (%eax),%eax
 895:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 898:	e9 70 ff ff ff       	jmp    80d <malloc+0x4c>
}
 89d:	c9                   	leave  
 89e:	c3                   	ret    
