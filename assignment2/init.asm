
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
  11:	c7 04 24 6e 09 00 00 	movl   $0x96e,(%esp)
  18:	e8 3f 04 00 00       	call   45c <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 6e 09 00 00 	movl   $0x96e,(%esp)
  38:	e8 27 04 00 00       	call   464 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 6e 09 00 00 	movl   $0x96e,(%esp)
  4c:	e8 0b 04 00 00       	call   45c <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 37 04 00 00       	call   494 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 2b 04 00 00       	call   494 <dup>
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
  6c:	c7 44 24 04 76 09 00 	movl   $0x976,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 24 05 00 00       	call   5a4 <printf>
    pid = fork();
  80:	e8 8f 03 00 00       	call   414 <fork>
  85:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  89:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 89 09 00 	movl   $0x989,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 00 05 00 00       	call   5a4 <printf>
      exit();
  a4:	e8 73 03 00 00       	call   41c <exit>
    }
    if(pid == 0){
  a9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ae:	75 41                	jne    f1 <main+0xf1>
      exec("sh", argv);
  b0:	c7 44 24 04 20 0c 00 	movl   $0xc20,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 6b 09 00 00 	movl   $0x96b,(%esp)
  bf:	e8 90 03 00 00       	call   454 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 9c 09 00 	movl   $0x99c,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 cc 04 00 00       	call   5a4 <printf>
      exit();
  d8:	e8 3f 03 00 00       	call   41c <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  dd:	c7 44 24 04 b2 09 00 	movl   $0x9b2,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 b3 04 00 00       	call   5a4 <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f1:	e8 2e 03 00 00       	call   424 <wait>
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

#define NULL   0

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
 241:	e8 ee 01 00 00       	call   434 <read>
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
 29d:	e8 ba 01 00 00       	call   45c <open>
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
 2bf:	e8 b0 01 00 00       	call   474 <fstat>
 2c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ca:	89 04 24             	mov    %eax,(%esp)
 2cd:	e8 72 01 00 00       	call   444 <close>
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

00000355 <strtok>:

char*
strtok(char *teststr, char ch)
{
 355:	55                   	push   %ebp
 356:	89 e5                	mov    %esp,%ebp
 358:	83 ec 24             	sub    $0x24,%esp
 35b:	8b 45 0c             	mov    0xc(%ebp),%eax
 35e:	88 45 dc             	mov    %al,-0x24(%ebp)
    char *dummystr = NULL;
 361:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    char *start = NULL;
 368:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    char *end = NULL;
 36f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char nullch = '\0';
 376:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    char *address_of_null = &nullch;
 37a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 37d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    static char *nexttok;

    if(teststr != NULL)
 380:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 384:	74 08                	je     38e <strtok+0x39>
    {
        dummystr = teststr;
 386:	8b 45 08             	mov    0x8(%ebp),%eax
 389:	89 45 fc             	mov    %eax,-0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 38c:	eb 75                	jmp    403 <strtok+0xae>
    {
        dummystr = teststr;
    }
    else
    {
        if(*nexttok == '\0')
 38e:	a1 3c 0c 00 00       	mov    0xc3c,%eax
 393:	8a 00                	mov    (%eax),%al
 395:	84 c0                	test   %al,%al
 397:	75 07                	jne    3a0 <strtok+0x4b>
            return NULL;
 399:	b8 00 00 00 00       	mov    $0x0,%eax
 39e:	eb 6f                	jmp    40f <strtok+0xba>
        dummystr = nexttok;
 3a0:	a1 3c 0c 00 00       	mov    0xc3c,%eax
 3a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }


    while(dummystr != NULL)
 3a8:	eb 59                	jmp    403 <strtok+0xae>
    {
        //empty string
        if(*dummystr == '\0')
 3aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ad:	8a 00                	mov    (%eax),%al
 3af:	84 c0                	test   %al,%al
 3b1:	74 58                	je     40b <strtok+0xb6>
            break;
        if(*dummystr != ch)
 3b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3b6:	8a 00                	mov    (%eax),%al
 3b8:	3a 45 dc             	cmp    -0x24(%ebp),%al
 3bb:	74 22                	je     3df <strtok+0x8a>
        {
            if(!start)
 3bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 3c1:	75 06                	jne    3c9 <strtok+0x74>
                start = dummystr;
 3c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3c6:	89 45 f8             	mov    %eax,-0x8(%ebp)

            dummystr++;
 3c9:	ff 45 fc             	incl   -0x4(%ebp)

            // handle the case where the delimiter is not at the end of the string.
            if(*dummystr == '\0')
 3cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3cf:	8a 00                	mov    (%eax),%al
 3d1:	84 c0                	test   %al,%al
 3d3:	75 2e                	jne    403 <strtok+0xae>
            {
                nexttok = dummystr;
 3d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d8:	a3 3c 0c 00 00       	mov    %eax,0xc3c
                break;
 3dd:	eb 2d                	jmp    40c <strtok+0xb7>
            }
        }
        else
        {
            if(start)
 3df:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 3e3:	74 1b                	je     400 <strtok+0xab>
            {
                end = dummystr;
 3e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
                nexttok = dummystr+1;
 3eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ee:	40                   	inc    %eax
 3ef:	a3 3c 0c 00 00       	mov    %eax,0xc3c
                *end = *address_of_null;
 3f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3f7:	8a 10                	mov    (%eax),%dl
 3f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fc:	88 10                	mov    %dl,(%eax)
                break;
 3fe:	eb 0c                	jmp    40c <strtok+0xb7>
            }
            else
            {
                dummystr++;
 400:	ff 45 fc             	incl   -0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 403:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
 407:	75 a1                	jne    3aa <strtok+0x55>
 409:	eb 01                	jmp    40c <strtok+0xb7>
    {
        //empty string
        if(*dummystr == '\0')
            break;
 40b:	90                   	nop
                dummystr++;
            }
        }
    }

    return start;
 40c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 40f:	c9                   	leave  
 410:	c3                   	ret    
 411:	66 90                	xchg   %ax,%ax
 413:	90                   	nop

00000414 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 414:	b8 01 00 00 00       	mov    $0x1,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <exit>:
SYSCALL(exit)
 41c:	b8 02 00 00 00       	mov    $0x2,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <wait>:
SYSCALL(wait)
 424:	b8 03 00 00 00       	mov    $0x3,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <pipe>:
SYSCALL(pipe)
 42c:	b8 04 00 00 00       	mov    $0x4,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <read>:
SYSCALL(read)
 434:	b8 05 00 00 00       	mov    $0x5,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <write>:
SYSCALL(write)
 43c:	b8 10 00 00 00       	mov    $0x10,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <close>:
SYSCALL(close)
 444:	b8 15 00 00 00       	mov    $0x15,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <kill>:
SYSCALL(kill)
 44c:	b8 06 00 00 00       	mov    $0x6,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <exec>:
SYSCALL(exec)
 454:	b8 07 00 00 00       	mov    $0x7,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <open>:
SYSCALL(open)
 45c:	b8 0f 00 00 00       	mov    $0xf,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <mknod>:
SYSCALL(mknod)
 464:	b8 11 00 00 00       	mov    $0x11,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <unlink>:
SYSCALL(unlink)
 46c:	b8 12 00 00 00       	mov    $0x12,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <fstat>:
SYSCALL(fstat)
 474:	b8 08 00 00 00       	mov    $0x8,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <link>:
SYSCALL(link)
 47c:	b8 13 00 00 00       	mov    $0x13,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <mkdir>:
SYSCALL(mkdir)
 484:	b8 14 00 00 00       	mov    $0x14,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <chdir>:
SYSCALL(chdir)
 48c:	b8 09 00 00 00       	mov    $0x9,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <dup>:
SYSCALL(dup)
 494:	b8 0a 00 00 00       	mov    $0xa,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <getpid>:
SYSCALL(getpid)
 49c:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <sbrk>:
SYSCALL(sbrk)
 4a4:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <sleep>:
SYSCALL(sleep)
 4ac:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <uptime>:
SYSCALL(uptime)
 4b4:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <add_path>:
SYSCALL(add_path)
 4bc:	b8 16 00 00 00       	mov    $0x16,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <wait2>:
SYSCALL(wait2)
 4c4:	b8 17 00 00 00       	mov    $0x17,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4cc:	55                   	push   %ebp
 4cd:	89 e5                	mov    %esp,%ebp
 4cf:	83 ec 28             	sub    $0x28,%esp
 4d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4df:	00 
 4e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ea:	89 04 24             	mov    %eax,(%esp)
 4ed:	e8 4a ff ff ff       	call   43c <write>
}
 4f2:	c9                   	leave  
 4f3:	c3                   	ret    

000004f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f4:	55                   	push   %ebp
 4f5:	89 e5                	mov    %esp,%ebp
 4f7:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 501:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 505:	74 17                	je     51e <printint+0x2a>
 507:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 50b:	79 11                	jns    51e <printint+0x2a>
    neg = 1;
 50d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 514:	8b 45 0c             	mov    0xc(%ebp),%eax
 517:	f7 d8                	neg    %eax
 519:	89 45 ec             	mov    %eax,-0x14(%ebp)
 51c:	eb 06                	jmp    524 <printint+0x30>
  } else {
    x = xx;
 51e:	8b 45 0c             	mov    0xc(%ebp),%eax
 521:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 52b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 52e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 531:	ba 00 00 00 00       	mov    $0x0,%edx
 536:	f7 f1                	div    %ecx
 538:	89 d0                	mov    %edx,%eax
 53a:	8a 80 28 0c 00 00    	mov    0xc28(%eax),%al
 540:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 543:	8b 55 f4             	mov    -0xc(%ebp),%edx
 546:	01 ca                	add    %ecx,%edx
 548:	88 02                	mov    %al,(%edx)
 54a:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 54d:	8b 55 10             	mov    0x10(%ebp),%edx
 550:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 553:	8b 45 ec             	mov    -0x14(%ebp),%eax
 556:	ba 00 00 00 00       	mov    $0x0,%edx
 55b:	f7 75 d4             	divl   -0x2c(%ebp)
 55e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 561:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 565:	75 c4                	jne    52b <printint+0x37>
  if(neg)
 567:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 56b:	74 2c                	je     599 <printint+0xa5>
    buf[i++] = '-';
 56d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 570:	8b 45 f4             	mov    -0xc(%ebp),%eax
 573:	01 d0                	add    %edx,%eax
 575:	c6 00 2d             	movb   $0x2d,(%eax)
 578:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 57b:	eb 1c                	jmp    599 <printint+0xa5>
    putc(fd, buf[i]);
 57d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 580:	8b 45 f4             	mov    -0xc(%ebp),%eax
 583:	01 d0                	add    %edx,%eax
 585:	8a 00                	mov    (%eax),%al
 587:	0f be c0             	movsbl %al,%eax
 58a:	89 44 24 04          	mov    %eax,0x4(%esp)
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
 591:	89 04 24             	mov    %eax,(%esp)
 594:	e8 33 ff ff ff       	call   4cc <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 599:	ff 4d f4             	decl   -0xc(%ebp)
 59c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a0:	79 db                	jns    57d <printint+0x89>
    putc(fd, buf[i]);
}
 5a2:	c9                   	leave  
 5a3:	c3                   	ret    

000005a4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a4:	55                   	push   %ebp
 5a5:	89 e5                	mov    %esp,%ebp
 5a7:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5b1:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b4:	83 c0 04             	add    $0x4,%eax
 5b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5c1:	e9 78 01 00 00       	jmp    73e <printf+0x19a>
    c = fmt[i] & 0xff;
 5c6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5cc:	01 d0                	add    %edx,%eax
 5ce:	8a 00                	mov    (%eax),%al
 5d0:	0f be c0             	movsbl %al,%eax
 5d3:	25 ff 00 00 00       	and    $0xff,%eax
 5d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5df:	75 2c                	jne    60d <printf+0x69>
      if(c == '%'){
 5e1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e5:	75 0c                	jne    5f3 <printf+0x4f>
        state = '%';
 5e7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ee:	e9 48 01 00 00       	jmp    73b <printf+0x197>
      } else {
        putc(fd, c);
 5f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f6:	0f be c0             	movsbl %al,%eax
 5f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fd:	8b 45 08             	mov    0x8(%ebp),%eax
 600:	89 04 24             	mov    %eax,(%esp)
 603:	e8 c4 fe ff ff       	call   4cc <putc>
 608:	e9 2e 01 00 00       	jmp    73b <printf+0x197>
      }
    } else if(state == '%'){
 60d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 611:	0f 85 24 01 00 00    	jne    73b <printf+0x197>
      if(c == 'd'){
 617:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 61b:	75 2d                	jne    64a <printf+0xa6>
        printint(fd, *ap, 10, 1);
 61d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 629:	00 
 62a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 631:	00 
 632:	89 44 24 04          	mov    %eax,0x4(%esp)
 636:	8b 45 08             	mov    0x8(%ebp),%eax
 639:	89 04 24             	mov    %eax,(%esp)
 63c:	e8 b3 fe ff ff       	call   4f4 <printint>
        ap++;
 641:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 645:	e9 ea 00 00 00       	jmp    734 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 64a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 64e:	74 06                	je     656 <printf+0xb2>
 650:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 654:	75 2d                	jne    683 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 656:	8b 45 e8             	mov    -0x18(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 662:	00 
 663:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 66a:	00 
 66b:	89 44 24 04          	mov    %eax,0x4(%esp)
 66f:	8b 45 08             	mov    0x8(%ebp),%eax
 672:	89 04 24             	mov    %eax,(%esp)
 675:	e8 7a fe ff ff       	call   4f4 <printint>
        ap++;
 67a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67e:	e9 b1 00 00 00       	jmp    734 <printf+0x190>
      } else if(c == 's'){
 683:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 687:	75 43                	jne    6cc <printf+0x128>
        s = (char*)*ap;
 689:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 691:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 695:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 699:	75 25                	jne    6c0 <printf+0x11c>
          s = "(null)";
 69b:	c7 45 f4 bb 09 00 00 	movl   $0x9bb,-0xc(%ebp)
        while(*s != 0){
 6a2:	eb 1c                	jmp    6c0 <printf+0x11c>
          putc(fd, *s);
 6a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a7:	8a 00                	mov    (%eax),%al
 6a9:	0f be c0             	movsbl %al,%eax
 6ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b0:	8b 45 08             	mov    0x8(%ebp),%eax
 6b3:	89 04 24             	mov    %eax,(%esp)
 6b6:	e8 11 fe ff ff       	call   4cc <putc>
          s++;
 6bb:	ff 45 f4             	incl   -0xc(%ebp)
 6be:	eb 01                	jmp    6c1 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6c0:	90                   	nop
 6c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c4:	8a 00                	mov    (%eax),%al
 6c6:	84 c0                	test   %al,%al
 6c8:	75 da                	jne    6a4 <printf+0x100>
 6ca:	eb 68                	jmp    734 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6cc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6d0:	75 1d                	jne    6ef <printf+0x14b>
        putc(fd, *ap);
 6d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d5:	8b 00                	mov    (%eax),%eax
 6d7:	0f be c0             	movsbl %al,%eax
 6da:	89 44 24 04          	mov    %eax,0x4(%esp)
 6de:	8b 45 08             	mov    0x8(%ebp),%eax
 6e1:	89 04 24             	mov    %eax,(%esp)
 6e4:	e8 e3 fd ff ff       	call   4cc <putc>
        ap++;
 6e9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ed:	eb 45                	jmp    734 <printf+0x190>
      } else if(c == '%'){
 6ef:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6f3:	75 17                	jne    70c <printf+0x168>
        putc(fd, c);
 6f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f8:	0f be c0             	movsbl %al,%eax
 6fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ff:	8b 45 08             	mov    0x8(%ebp),%eax
 702:	89 04 24             	mov    %eax,(%esp)
 705:	e8 c2 fd ff ff       	call   4cc <putc>
 70a:	eb 28                	jmp    734 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 70c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 713:	00 
 714:	8b 45 08             	mov    0x8(%ebp),%eax
 717:	89 04 24             	mov    %eax,(%esp)
 71a:	e8 ad fd ff ff       	call   4cc <putc>
        putc(fd, c);
 71f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 722:	0f be c0             	movsbl %al,%eax
 725:	89 44 24 04          	mov    %eax,0x4(%esp)
 729:	8b 45 08             	mov    0x8(%ebp),%eax
 72c:	89 04 24             	mov    %eax,(%esp)
 72f:	e8 98 fd ff ff       	call   4cc <putc>
      }
      state = 0;
 734:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 73b:	ff 45 f0             	incl   -0x10(%ebp)
 73e:	8b 55 0c             	mov    0xc(%ebp),%edx
 741:	8b 45 f0             	mov    -0x10(%ebp),%eax
 744:	01 d0                	add    %edx,%eax
 746:	8a 00                	mov    (%eax),%al
 748:	84 c0                	test   %al,%al
 74a:	0f 85 76 fe ff ff    	jne    5c6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 750:	c9                   	leave  
 751:	c3                   	ret    
 752:	66 90                	xchg   %ax,%ax

00000754 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 754:	55                   	push   %ebp
 755:	89 e5                	mov    %esp,%ebp
 757:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75a:	8b 45 08             	mov    0x8(%ebp),%eax
 75d:	83 e8 08             	sub    $0x8,%eax
 760:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 763:	a1 48 0c 00 00       	mov    0xc48,%eax
 768:	89 45 fc             	mov    %eax,-0x4(%ebp)
 76b:	eb 24                	jmp    791 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	8b 00                	mov    (%eax),%eax
 772:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 775:	77 12                	ja     789 <free+0x35>
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 77d:	77 24                	ja     7a3 <free+0x4f>
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 00                	mov    (%eax),%eax
 784:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 787:	77 1a                	ja     7a3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 00                	mov    (%eax),%eax
 78e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 791:	8b 45 f8             	mov    -0x8(%ebp),%eax
 794:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 797:	76 d4                	jbe    76d <free+0x19>
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	8b 00                	mov    (%eax),%eax
 79e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a1:	76 ca                	jbe    76d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a6:	8b 40 04             	mov    0x4(%eax),%eax
 7a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b3:	01 c2                	add    %eax,%edx
 7b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b8:	8b 00                	mov    (%eax),%eax
 7ba:	39 c2                	cmp    %eax,%edx
 7bc:	75 24                	jne    7e2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	8b 50 04             	mov    0x4(%eax),%edx
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	8b 00                	mov    (%eax),%eax
 7c9:	8b 40 04             	mov    0x4(%eax),%eax
 7cc:	01 c2                	add    %eax,%edx
 7ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	8b 10                	mov    (%eax),%edx
 7db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7de:	89 10                	mov    %edx,(%eax)
 7e0:	eb 0a                	jmp    7ec <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	8b 10                	mov    (%eax),%edx
 7e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ea:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ef:	8b 40 04             	mov    0x4(%eax),%eax
 7f2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	01 d0                	add    %edx,%eax
 7fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 801:	75 20                	jne    823 <free+0xcf>
    p->s.size += bp->s.size;
 803:	8b 45 fc             	mov    -0x4(%ebp),%eax
 806:	8b 50 04             	mov    0x4(%eax),%edx
 809:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80c:	8b 40 04             	mov    0x4(%eax),%eax
 80f:	01 c2                	add    %eax,%edx
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 817:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81a:	8b 10                	mov    (%eax),%edx
 81c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81f:	89 10                	mov    %edx,(%eax)
 821:	eb 08                	jmp    82b <free+0xd7>
  } else
    p->s.ptr = bp;
 823:	8b 45 fc             	mov    -0x4(%ebp),%eax
 826:	8b 55 f8             	mov    -0x8(%ebp),%edx
 829:	89 10                	mov    %edx,(%eax)
  freep = p;
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	a3 48 0c 00 00       	mov    %eax,0xc48
}
 833:	c9                   	leave  
 834:	c3                   	ret    

00000835 <morecore>:

static Header*
morecore(uint nu)
{
 835:	55                   	push   %ebp
 836:	89 e5                	mov    %esp,%ebp
 838:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 83b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 842:	77 07                	ja     84b <morecore+0x16>
    nu = 4096;
 844:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 84b:	8b 45 08             	mov    0x8(%ebp),%eax
 84e:	c1 e0 03             	shl    $0x3,%eax
 851:	89 04 24             	mov    %eax,(%esp)
 854:	e8 4b fc ff ff       	call   4a4 <sbrk>
 859:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 85c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 860:	75 07                	jne    869 <morecore+0x34>
    return 0;
 862:	b8 00 00 00 00       	mov    $0x0,%eax
 867:	eb 22                	jmp    88b <morecore+0x56>
  hp = (Header*)p;
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 86f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 872:	8b 55 08             	mov    0x8(%ebp),%edx
 875:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 878:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87b:	83 c0 08             	add    $0x8,%eax
 87e:	89 04 24             	mov    %eax,(%esp)
 881:	e8 ce fe ff ff       	call   754 <free>
  return freep;
 886:	a1 48 0c 00 00       	mov    0xc48,%eax
}
 88b:	c9                   	leave  
 88c:	c3                   	ret    

0000088d <malloc>:

void*
malloc(uint nbytes)
{
 88d:	55                   	push   %ebp
 88e:	89 e5                	mov    %esp,%ebp
 890:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 893:	8b 45 08             	mov    0x8(%ebp),%eax
 896:	83 c0 07             	add    $0x7,%eax
 899:	c1 e8 03             	shr    $0x3,%eax
 89c:	40                   	inc    %eax
 89d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a0:	a1 48 0c 00 00       	mov    0xc48,%eax
 8a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8ac:	75 23                	jne    8d1 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 8ae:	c7 45 f0 40 0c 00 00 	movl   $0xc40,-0x10(%ebp)
 8b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b8:	a3 48 0c 00 00       	mov    %eax,0xc48
 8bd:	a1 48 0c 00 00       	mov    0xc48,%eax
 8c2:	a3 40 0c 00 00       	mov    %eax,0xc40
    base.s.size = 0;
 8c7:	c7 05 44 0c 00 00 00 	movl   $0x0,0xc44
 8ce:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d4:	8b 00                	mov    (%eax),%eax
 8d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dc:	8b 40 04             	mov    0x4(%eax),%eax
 8df:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e2:	72 4d                	jb     931 <malloc+0xa4>
      if(p->s.size == nunits)
 8e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e7:	8b 40 04             	mov    0x4(%eax),%eax
 8ea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ed:	75 0c                	jne    8fb <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 8ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f2:	8b 10                	mov    (%eax),%edx
 8f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f7:	89 10                	mov    %edx,(%eax)
 8f9:	eb 26                	jmp    921 <malloc+0x94>
      else {
        p->s.size -= nunits;
 8fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fe:	8b 40 04             	mov    0x4(%eax),%eax
 901:	89 c2                	mov    %eax,%edx
 903:	2b 55 ec             	sub    -0x14(%ebp),%edx
 906:	8b 45 f4             	mov    -0xc(%ebp),%eax
 909:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90f:	8b 40 04             	mov    0x4(%eax),%eax
 912:	c1 e0 03             	shl    $0x3,%eax
 915:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 918:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 91e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 921:	8b 45 f0             	mov    -0x10(%ebp),%eax
 924:	a3 48 0c 00 00       	mov    %eax,0xc48
      return (void*)(p + 1);
 929:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92c:	83 c0 08             	add    $0x8,%eax
 92f:	eb 38                	jmp    969 <malloc+0xdc>
    }
    if(p == freep)
 931:	a1 48 0c 00 00       	mov    0xc48,%eax
 936:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 939:	75 1b                	jne    956 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 93b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 93e:	89 04 24             	mov    %eax,(%esp)
 941:	e8 ef fe ff ff       	call   835 <morecore>
 946:	89 45 f4             	mov    %eax,-0xc(%ebp)
 949:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 94d:	75 07                	jne    956 <malloc+0xc9>
        return 0;
 94f:	b8 00 00 00 00       	mov    $0x0,%eax
 954:	eb 13                	jmp    969 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 956:	8b 45 f4             	mov    -0xc(%ebp),%eax
 959:	89 45 f0             	mov    %eax,-0x10(%ebp)
 95c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95f:	8b 00                	mov    (%eax),%eax
 961:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 964:	e9 70 ff ff ff       	jmp    8d9 <malloc+0x4c>
}
 969:	c9                   	leave  
 96a:	c3                   	ret    
