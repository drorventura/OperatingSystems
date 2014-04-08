
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 bb 00 00 00       	jmp    cd <grep+0xcd>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 00 0f 00 00 	movl   $0xf00,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 4f                	jmp    70 <grep+0x70>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  2e:	8b 45 08             	mov    0x8(%ebp),%eax
  31:	89 04 24             	mov    %eax,(%esp)
  34:	e8 bd 01 00 00       	call   1f6 <match>
  39:	85 c0                	test   %eax,%eax
  3b:	74 2c                	je     69 <grep+0x69>
        *q = '\n';
  3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  40:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  46:	40                   	inc    %eax
  47:	89 c2                	mov    %eax,%edx
  49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4c:	89 d1                	mov    %edx,%ecx
  4e:	29 c1                	sub    %eax,%ecx
  50:	89 c8                	mov    %ecx,%eax
  52:	89 44 24 08          	mov    %eax,0x8(%esp)
  56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  59:	89 44 24 04          	mov    %eax,0x4(%esp)
  5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  64:	e8 07 06 00 00       	call   670 <write>
      }
      p = q+1;
  69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6c:	40                   	inc    %eax
  6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  70:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  77:	00 
  78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  7b:	89 04 24             	mov    %eax,(%esp)
  7e:	e8 9d 03 00 00       	call   420 <strchr>
  83:	89 45 e8             	mov    %eax,-0x18(%ebp)
  86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8a:	75 95                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  8c:	81 7d f0 00 0f 00 00 	cmpl   $0xf00,-0x10(%ebp)
  93:	75 07                	jne    9c <grep+0x9c>
      m = 0;
  95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a0:	7e 2b                	jle    cd <grep+0xcd>
      m -= p - buf;
  a2:	ba 00 0f 00 00       	mov    $0xf00,%edx
  a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  aa:	89 d1                	mov    %edx,%ecx
  ac:	29 c1                	sub    %eax,%ecx
  ae:	89 c8                	mov    %ecx,%eax
  b0:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  c1:	c7 04 24 00 0f 00 00 	movl   $0xf00,(%esp)
  c8:	e8 85 04 00 00       	call   552 <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d0:	ba 00 04 00 00       	mov    $0x400,%edx
  d5:	89 d1                	mov    %edx,%ecx
  d7:	29 c1                	sub    %eax,%ecx
  d9:	89 c8                	mov    %ecx,%eax
  db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  de:	81 c2 00 0f 00 00    	add    $0xf00,%edx
  e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  ef:	89 04 24             	mov    %eax,(%esp)
  f2:	e8 71 05 00 00       	call   668 <read>
  f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  fe:	0f 8f 0e ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 104:	c9                   	leave  
 105:	c3                   	ret    

00000106 <main>:

int
main(int argc, char *argv[])
{
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 e4 f0             	and    $0xfffffff0,%esp
 10c:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 10f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 113:	7f 19                	jg     12e <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 115:	c7 44 24 04 a0 0b 00 	movl   $0xba0,0x4(%esp)
 11c:	00 
 11d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 124:	e8 af 06 00 00       	call   7d8 <printf>
    exit();
 129:	e8 22 05 00 00       	call   650 <exit>
  }
  pattern = argv[1];
 12e:	8b 45 0c             	mov    0xc(%ebp),%eax
 131:	8b 40 04             	mov    0x4(%eax),%eax
 134:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
 138:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 13c:	7f 19                	jg     157 <main+0x51>
    grep(pattern, 0);
 13e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 145:	00 
 146:	8b 44 24 18          	mov    0x18(%esp),%eax
 14a:	89 04 24             	mov    %eax,(%esp)
 14d:	e8 ae fe ff ff       	call   0 <grep>
    exit();
 152:	e8 f9 04 00 00       	call   650 <exit>
  }

  for(i = 2; i < argc; i++){
 157:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 15e:	00 
 15f:	e9 80 00 00 00       	jmp    1e4 <main+0xde>
    if((fd = open(argv[i], 0)) < 0){
 164:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 16f:	8b 45 0c             	mov    0xc(%ebp),%eax
 172:	01 d0                	add    %edx,%eax
 174:	8b 00                	mov    (%eax),%eax
 176:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 17d:	00 
 17e:	89 04 24             	mov    %eax,(%esp)
 181:	e8 0a 05 00 00       	call   690 <open>
 186:	89 44 24 14          	mov    %eax,0x14(%esp)
 18a:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 18f:	79 2f                	jns    1c0 <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
 191:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 195:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 19c:	8b 45 0c             	mov    0xc(%ebp),%eax
 19f:	01 d0                	add    %edx,%eax
 1a1:	8b 00                	mov    (%eax),%eax
 1a3:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a7:	c7 44 24 04 c0 0b 00 	movl   $0xbc0,0x4(%esp)
 1ae:	00 
 1af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b6:	e8 1d 06 00 00       	call   7d8 <printf>
      exit();
 1bb:	e8 90 04 00 00       	call   650 <exit>
    }
    grep(pattern, fd);
 1c0:	8b 44 24 14          	mov    0x14(%esp),%eax
 1c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c8:	8b 44 24 18          	mov    0x18(%esp),%eax
 1cc:	89 04 24             	mov    %eax,(%esp)
 1cf:	e8 2c fe ff ff       	call   0 <grep>
    close(fd);
 1d4:	8b 44 24 14          	mov    0x14(%esp),%eax
 1d8:	89 04 24             	mov    %eax,(%esp)
 1db:	e8 98 04 00 00       	call   678 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1e0:	ff 44 24 1c          	incl   0x1c(%esp)
 1e4:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1e8:	3b 45 08             	cmp    0x8(%ebp),%eax
 1eb:	0f 8c 73 ff ff ff    	jl     164 <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1f1:	e8 5a 04 00 00       	call   650 <exit>

000001f6 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	8a 00                	mov    (%eax),%al
 201:	3c 5e                	cmp    $0x5e,%al
 203:	75 17                	jne    21c <match+0x26>
    return matchhere(re+1, text);
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	8d 50 01             	lea    0x1(%eax),%edx
 20b:	8b 45 0c             	mov    0xc(%ebp),%eax
 20e:	89 44 24 04          	mov    %eax,0x4(%esp)
 212:	89 14 24             	mov    %edx,(%esp)
 215:	e8 37 00 00 00       	call   251 <matchhere>
 21a:	eb 33                	jmp    24f <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
 21c:	8b 45 0c             	mov    0xc(%ebp),%eax
 21f:	89 44 24 04          	mov    %eax,0x4(%esp)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	89 04 24             	mov    %eax,(%esp)
 229:	e8 23 00 00 00       	call   251 <matchhere>
 22e:	85 c0                	test   %eax,%eax
 230:	74 07                	je     239 <match+0x43>
      return 1;
 232:	b8 01 00 00 00       	mov    $0x1,%eax
 237:	eb 16                	jmp    24f <match+0x59>
  }while(*text++ != '\0');
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	8a 00                	mov    (%eax),%al
 23e:	84 c0                	test   %al,%al
 240:	0f 95 c0             	setne  %al
 243:	ff 45 0c             	incl   0xc(%ebp)
 246:	84 c0                	test   %al,%al
 248:	75 d2                	jne    21c <match+0x26>
  return 0;
 24a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24f:	c9                   	leave  
 250:	c3                   	ret    

00000251 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 251:	55                   	push   %ebp
 252:	89 e5                	mov    %esp,%ebp
 254:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	8a 00                	mov    (%eax),%al
 25c:	84 c0                	test   %al,%al
 25e:	75 0a                	jne    26a <matchhere+0x19>
    return 1;
 260:	b8 01 00 00 00       	mov    $0x1,%eax
 265:	e9 8c 00 00 00       	jmp    2f6 <matchhere+0xa5>
  if(re[1] == '*')
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	40                   	inc    %eax
 26e:	8a 00                	mov    (%eax),%al
 270:	3c 2a                	cmp    $0x2a,%al
 272:	75 23                	jne    297 <matchhere+0x46>
    return matchstar(re[0], re+2, text);
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	8d 48 02             	lea    0x2(%eax),%ecx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	8a 00                	mov    (%eax),%al
 27f:	0f be c0             	movsbl %al,%eax
 282:	8b 55 0c             	mov    0xc(%ebp),%edx
 285:	89 54 24 08          	mov    %edx,0x8(%esp)
 289:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 28d:	89 04 24             	mov    %eax,(%esp)
 290:	e8 63 00 00 00       	call   2f8 <matchstar>
 295:	eb 5f                	jmp    2f6 <matchhere+0xa5>
  if(re[0] == '$' && re[1] == '\0')
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	8a 00                	mov    (%eax),%al
 29c:	3c 24                	cmp    $0x24,%al
 29e:	75 19                	jne    2b9 <matchhere+0x68>
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	40                   	inc    %eax
 2a4:	8a 00                	mov    (%eax),%al
 2a6:	84 c0                	test   %al,%al
 2a8:	75 0f                	jne    2b9 <matchhere+0x68>
    return *text == '\0';
 2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ad:	8a 00                	mov    (%eax),%al
 2af:	84 c0                	test   %al,%al
 2b1:	0f 94 c0             	sete   %al
 2b4:	0f b6 c0             	movzbl %al,%eax
 2b7:	eb 3d                	jmp    2f6 <matchhere+0xa5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bc:	8a 00                	mov    (%eax),%al
 2be:	84 c0                	test   %al,%al
 2c0:	74 2f                	je     2f1 <matchhere+0xa0>
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	8a 00                	mov    (%eax),%al
 2c7:	3c 2e                	cmp    $0x2e,%al
 2c9:	74 0e                	je     2d9 <matchhere+0x88>
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	8a 10                	mov    (%eax),%dl
 2d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d3:	8a 00                	mov    (%eax),%al
 2d5:	38 c2                	cmp    %al,%dl
 2d7:	75 18                	jne    2f1 <matchhere+0xa0>
    return matchhere(re+1, text+1);
 2d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2dc:	8d 50 01             	lea    0x1(%eax),%edx
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	40                   	inc    %eax
 2e3:	89 54 24 04          	mov    %edx,0x4(%esp)
 2e7:	89 04 24             	mov    %eax,(%esp)
 2ea:	e8 62 ff ff ff       	call   251 <matchhere>
 2ef:	eb 05                	jmp    2f6 <matchhere+0xa5>
  return 0;
 2f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f6:	c9                   	leave  
 2f7:	c3                   	ret    

000002f8 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2f8:	55                   	push   %ebp
 2f9:	89 e5                	mov    %esp,%ebp
 2fb:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2fe:	8b 45 10             	mov    0x10(%ebp),%eax
 301:	89 44 24 04          	mov    %eax,0x4(%esp)
 305:	8b 45 0c             	mov    0xc(%ebp),%eax
 308:	89 04 24             	mov    %eax,(%esp)
 30b:	e8 41 ff ff ff       	call   251 <matchhere>
 310:	85 c0                	test   %eax,%eax
 312:	74 07                	je     31b <matchstar+0x23>
      return 1;
 314:	b8 01 00 00 00       	mov    $0x1,%eax
 319:	eb 29                	jmp    344 <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
 31b:	8b 45 10             	mov    0x10(%ebp),%eax
 31e:	8a 00                	mov    (%eax),%al
 320:	84 c0                	test   %al,%al
 322:	74 1b                	je     33f <matchstar+0x47>
 324:	8b 45 10             	mov    0x10(%ebp),%eax
 327:	8a 00                	mov    (%eax),%al
 329:	0f be c0             	movsbl %al,%eax
 32c:	3b 45 08             	cmp    0x8(%ebp),%eax
 32f:	0f 94 c0             	sete   %al
 332:	ff 45 10             	incl   0x10(%ebp)
 335:	84 c0                	test   %al,%al
 337:	75 c5                	jne    2fe <matchstar+0x6>
 339:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 33d:	74 bf                	je     2fe <matchstar+0x6>
  return 0;
 33f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 344:	c9                   	leave  
 345:	c3                   	ret    
 346:	66 90                	xchg   %ax,%ax

00000348 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	57                   	push   %edi
 34c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 34d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 350:	8b 55 10             	mov    0x10(%ebp),%edx
 353:	8b 45 0c             	mov    0xc(%ebp),%eax
 356:	89 cb                	mov    %ecx,%ebx
 358:	89 df                	mov    %ebx,%edi
 35a:	89 d1                	mov    %edx,%ecx
 35c:	fc                   	cld    
 35d:	f3 aa                	rep stos %al,%es:(%edi)
 35f:	89 ca                	mov    %ecx,%edx
 361:	89 fb                	mov    %edi,%ebx
 363:	89 5d 08             	mov    %ebx,0x8(%ebp)
 366:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 369:	5b                   	pop    %ebx
 36a:	5f                   	pop    %edi
 36b:	5d                   	pop    %ebp
 36c:	c3                   	ret    

0000036d <strcpy>:

#define NULL   0

char*
strcpy(char *s, char *t)
{
 36d:	55                   	push   %ebp
 36e:	89 e5                	mov    %esp,%ebp
 370:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 379:	90                   	nop
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	8a 10                	mov    (%eax),%dl
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	88 10                	mov    %dl,(%eax)
 384:	8b 45 08             	mov    0x8(%ebp),%eax
 387:	8a 00                	mov    (%eax),%al
 389:	84 c0                	test   %al,%al
 38b:	0f 95 c0             	setne  %al
 38e:	ff 45 08             	incl   0x8(%ebp)
 391:	ff 45 0c             	incl   0xc(%ebp)
 394:	84 c0                	test   %al,%al
 396:	75 e2                	jne    37a <strcpy+0xd>
    ;
  return os;
 398:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 39b:	c9                   	leave  
 39c:	c3                   	ret    

0000039d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39d:	55                   	push   %ebp
 39e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3a0:	eb 06                	jmp    3a8 <strcmp+0xb>
    p++, q++;
 3a2:	ff 45 08             	incl   0x8(%ebp)
 3a5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	8a 00                	mov    (%eax),%al
 3ad:	84 c0                	test   %al,%al
 3af:	74 0e                	je     3bf <strcmp+0x22>
 3b1:	8b 45 08             	mov    0x8(%ebp),%eax
 3b4:	8a 10                	mov    (%eax),%dl
 3b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b9:	8a 00                	mov    (%eax),%al
 3bb:	38 c2                	cmp    %al,%dl
 3bd:	74 e3                	je     3a2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
 3c2:	8a 00                	mov    (%eax),%al
 3c4:	0f b6 d0             	movzbl %al,%edx
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	8a 00                	mov    (%eax),%al
 3cc:	0f b6 c0             	movzbl %al,%eax
 3cf:	89 d1                	mov    %edx,%ecx
 3d1:	29 c1                	sub    %eax,%ecx
 3d3:	89 c8                	mov    %ecx,%eax
}
 3d5:	5d                   	pop    %ebp
 3d6:	c3                   	ret    

000003d7 <strlen>:

uint
strlen(char *s)
{
 3d7:	55                   	push   %ebp
 3d8:	89 e5                	mov    %esp,%ebp
 3da:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3e4:	eb 03                	jmp    3e9 <strlen+0x12>
 3e6:	ff 45 fc             	incl   -0x4(%ebp)
 3e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3ec:	8b 45 08             	mov    0x8(%ebp),%eax
 3ef:	01 d0                	add    %edx,%eax
 3f1:	8a 00                	mov    (%eax),%al
 3f3:	84 c0                	test   %al,%al
 3f5:	75 ef                	jne    3e6 <strlen+0xf>
    ;
  return n;
 3f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3fa:	c9                   	leave  
 3fb:	c3                   	ret    

000003fc <memset>:

void*
memset(void *dst, int c, uint n)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 402:	8b 45 10             	mov    0x10(%ebp),%eax
 405:	89 44 24 08          	mov    %eax,0x8(%esp)
 409:	8b 45 0c             	mov    0xc(%ebp),%eax
 40c:	89 44 24 04          	mov    %eax,0x4(%esp)
 410:	8b 45 08             	mov    0x8(%ebp),%eax
 413:	89 04 24             	mov    %eax,(%esp)
 416:	e8 2d ff ff ff       	call   348 <stosb>
  return dst;
 41b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41e:	c9                   	leave  
 41f:	c3                   	ret    

00000420 <strchr>:

char*
strchr(const char *s, char c)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	83 ec 04             	sub    $0x4,%esp
 426:	8b 45 0c             	mov    0xc(%ebp),%eax
 429:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 42c:	eb 12                	jmp    440 <strchr+0x20>
    if(*s == c)
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	8a 00                	mov    (%eax),%al
 433:	3a 45 fc             	cmp    -0x4(%ebp),%al
 436:	75 05                	jne    43d <strchr+0x1d>
      return (char*)s;
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	eb 11                	jmp    44e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 43d:	ff 45 08             	incl   0x8(%ebp)
 440:	8b 45 08             	mov    0x8(%ebp),%eax
 443:	8a 00                	mov    (%eax),%al
 445:	84 c0                	test   %al,%al
 447:	75 e5                	jne    42e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 449:	b8 00 00 00 00       	mov    $0x0,%eax
}
 44e:	c9                   	leave  
 44f:	c3                   	ret    

00000450 <gets>:

char*
gets(char *buf, int max)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 456:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 45d:	eb 42                	jmp    4a1 <gets+0x51>
    cc = read(0, &c, 1);
 45f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 466:	00 
 467:	8d 45 ef             	lea    -0x11(%ebp),%eax
 46a:	89 44 24 04          	mov    %eax,0x4(%esp)
 46e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 475:	e8 ee 01 00 00       	call   668 <read>
 47a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 47d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 481:	7e 29                	jle    4ac <gets+0x5c>
      break;
    buf[i++] = c;
 483:	8b 55 f4             	mov    -0xc(%ebp),%edx
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	01 c2                	add    %eax,%edx
 48b:	8a 45 ef             	mov    -0x11(%ebp),%al
 48e:	88 02                	mov    %al,(%edx)
 490:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 493:	8a 45 ef             	mov    -0x11(%ebp),%al
 496:	3c 0a                	cmp    $0xa,%al
 498:	74 13                	je     4ad <gets+0x5d>
 49a:	8a 45 ef             	mov    -0x11(%ebp),%al
 49d:	3c 0d                	cmp    $0xd,%al
 49f:	74 0c                	je     4ad <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a4:	40                   	inc    %eax
 4a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4a8:	7c b5                	jl     45f <gets+0xf>
 4aa:	eb 01                	jmp    4ad <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4ac:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	01 d0                	add    %edx,%eax
 4b5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4bb:	c9                   	leave  
 4bc:	c3                   	ret    

000004bd <stat>:

int
stat(char *n, struct stat *st)
{
 4bd:	55                   	push   %ebp
 4be:	89 e5                	mov    %esp,%ebp
 4c0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4ca:	00 
 4cb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ce:	89 04 24             	mov    %eax,(%esp)
 4d1:	e8 ba 01 00 00       	call   690 <open>
 4d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4dd:	79 07                	jns    4e6 <stat+0x29>
    return -1;
 4df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4e4:	eb 23                	jmp    509 <stat+0x4c>
  r = fstat(fd, st);
 4e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f0:	89 04 24             	mov    %eax,(%esp)
 4f3:	e8 b0 01 00 00       	call   6a8 <fstat>
 4f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fe:	89 04 24             	mov    %eax,(%esp)
 501:	e8 72 01 00 00       	call   678 <close>
  return r;
 506:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 509:	c9                   	leave  
 50a:	c3                   	ret    

0000050b <atoi>:

int
atoi(const char *s)
{
 50b:	55                   	push   %ebp
 50c:	89 e5                	mov    %esp,%ebp
 50e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 511:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 518:	eb 21                	jmp    53b <atoi+0x30>
    n = n*10 + *s++ - '0';
 51a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 51d:	89 d0                	mov    %edx,%eax
 51f:	c1 e0 02             	shl    $0x2,%eax
 522:	01 d0                	add    %edx,%eax
 524:	d1 e0                	shl    %eax
 526:	89 c2                	mov    %eax,%edx
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	8a 00                	mov    (%eax),%al
 52d:	0f be c0             	movsbl %al,%eax
 530:	01 d0                	add    %edx,%eax
 532:	83 e8 30             	sub    $0x30,%eax
 535:	89 45 fc             	mov    %eax,-0x4(%ebp)
 538:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 53b:	8b 45 08             	mov    0x8(%ebp),%eax
 53e:	8a 00                	mov    (%eax),%al
 540:	3c 2f                	cmp    $0x2f,%al
 542:	7e 09                	jle    54d <atoi+0x42>
 544:	8b 45 08             	mov    0x8(%ebp),%eax
 547:	8a 00                	mov    (%eax),%al
 549:	3c 39                	cmp    $0x39,%al
 54b:	7e cd                	jle    51a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 54d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 550:	c9                   	leave  
 551:	c3                   	ret    

00000552 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 552:	55                   	push   %ebp
 553:	89 e5                	mov    %esp,%ebp
 555:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 558:	8b 45 08             	mov    0x8(%ebp),%eax
 55b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 55e:	8b 45 0c             	mov    0xc(%ebp),%eax
 561:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 564:	eb 10                	jmp    576 <memmove+0x24>
    *dst++ = *src++;
 566:	8b 45 f8             	mov    -0x8(%ebp),%eax
 569:	8a 10                	mov    (%eax),%dl
 56b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 56e:	88 10                	mov    %dl,(%eax)
 570:	ff 45 fc             	incl   -0x4(%ebp)
 573:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 576:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 57a:	0f 9f c0             	setg   %al
 57d:	ff 4d 10             	decl   0x10(%ebp)
 580:	84 c0                	test   %al,%al
 582:	75 e2                	jne    566 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 584:	8b 45 08             	mov    0x8(%ebp),%eax
}
 587:	c9                   	leave  
 588:	c3                   	ret    

00000589 <strtok>:

char*
strtok(char *teststr, char ch)
{
 589:	55                   	push   %ebp
 58a:	89 e5                	mov    %esp,%ebp
 58c:	83 ec 24             	sub    $0x24,%esp
 58f:	8b 45 0c             	mov    0xc(%ebp),%eax
 592:	88 45 dc             	mov    %al,-0x24(%ebp)
    char *dummystr = NULL;
 595:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    char *start = NULL;
 59c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    char *end = NULL;
 5a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char nullch = '\0';
 5aa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    char *address_of_null = &nullch;
 5ae:	8d 45 ef             	lea    -0x11(%ebp),%eax
 5b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    static char *nexttok;

    if(teststr != NULL)
 5b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 5b8:	74 08                	je     5c2 <strtok+0x39>
    {
        dummystr = teststr;
 5ba:	8b 45 08             	mov    0x8(%ebp),%eax
 5bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 5c0:	eb 75                	jmp    637 <strtok+0xae>
    {
        dummystr = teststr;
    }
    else
    {
        if(*nexttok == '\0')
 5c2:	a1 e0 0e 00 00       	mov    0xee0,%eax
 5c7:	8a 00                	mov    (%eax),%al
 5c9:	84 c0                	test   %al,%al
 5cb:	75 07                	jne    5d4 <strtok+0x4b>
            return NULL;
 5cd:	b8 00 00 00 00       	mov    $0x0,%eax
 5d2:	eb 6f                	jmp    643 <strtok+0xba>
        dummystr = nexttok;
 5d4:	a1 e0 0e 00 00       	mov    0xee0,%eax
 5d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }


    while(dummystr != NULL)
 5dc:	eb 59                	jmp    637 <strtok+0xae>
    {
        //empty string
        if(*dummystr == '\0')
 5de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e1:	8a 00                	mov    (%eax),%al
 5e3:	84 c0                	test   %al,%al
 5e5:	74 58                	je     63f <strtok+0xb6>
            break;
        if(*dummystr != ch)
 5e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ea:	8a 00                	mov    (%eax),%al
 5ec:	3a 45 dc             	cmp    -0x24(%ebp),%al
 5ef:	74 22                	je     613 <strtok+0x8a>
        {
            if(!start)
 5f1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 5f5:	75 06                	jne    5fd <strtok+0x74>
                start = dummystr;
 5f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fa:	89 45 f8             	mov    %eax,-0x8(%ebp)

            dummystr++;
 5fd:	ff 45 fc             	incl   -0x4(%ebp)

            // handle the case where the delimiter is not at the end of the string.
            if(*dummystr == '\0')
 600:	8b 45 fc             	mov    -0x4(%ebp),%eax
 603:	8a 00                	mov    (%eax),%al
 605:	84 c0                	test   %al,%al
 607:	75 2e                	jne    637 <strtok+0xae>
            {
                nexttok = dummystr;
 609:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60c:	a3 e0 0e 00 00       	mov    %eax,0xee0
                break;
 611:	eb 2d                	jmp    640 <strtok+0xb7>
            }
        }
        else
        {
            if(start)
 613:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 617:	74 1b                	je     634 <strtok+0xab>
            {
                end = dummystr;
 619:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61c:	89 45 f4             	mov    %eax,-0xc(%ebp)
                nexttok = dummystr+1;
 61f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 622:	40                   	inc    %eax
 623:	a3 e0 0e 00 00       	mov    %eax,0xee0
                *end = *address_of_null;
 628:	8b 45 f0             	mov    -0x10(%ebp),%eax
 62b:	8a 10                	mov    (%eax),%dl
 62d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 630:	88 10                	mov    %dl,(%eax)
                break;
 632:	eb 0c                	jmp    640 <strtok+0xb7>
            }
            else
            {
                dummystr++;
 634:	ff 45 fc             	incl   -0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 637:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
 63b:	75 a1                	jne    5de <strtok+0x55>
 63d:	eb 01                	jmp    640 <strtok+0xb7>
    {
        //empty string
        if(*dummystr == '\0')
            break;
 63f:	90                   	nop
                dummystr++;
            }
        }
    }

    return start;
 640:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 643:	c9                   	leave  
 644:	c3                   	ret    
 645:	66 90                	xchg   %ax,%ax
 647:	90                   	nop

00000648 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 648:	b8 01 00 00 00       	mov    $0x1,%eax
 64d:	cd 40                	int    $0x40
 64f:	c3                   	ret    

00000650 <exit>:
SYSCALL(exit)
 650:	b8 02 00 00 00       	mov    $0x2,%eax
 655:	cd 40                	int    $0x40
 657:	c3                   	ret    

00000658 <wait>:
SYSCALL(wait)
 658:	b8 03 00 00 00       	mov    $0x3,%eax
 65d:	cd 40                	int    $0x40
 65f:	c3                   	ret    

00000660 <pipe>:
SYSCALL(pipe)
 660:	b8 04 00 00 00       	mov    $0x4,%eax
 665:	cd 40                	int    $0x40
 667:	c3                   	ret    

00000668 <read>:
SYSCALL(read)
 668:	b8 05 00 00 00       	mov    $0x5,%eax
 66d:	cd 40                	int    $0x40
 66f:	c3                   	ret    

00000670 <write>:
SYSCALL(write)
 670:	b8 10 00 00 00       	mov    $0x10,%eax
 675:	cd 40                	int    $0x40
 677:	c3                   	ret    

00000678 <close>:
SYSCALL(close)
 678:	b8 15 00 00 00       	mov    $0x15,%eax
 67d:	cd 40                	int    $0x40
 67f:	c3                   	ret    

00000680 <kill>:
SYSCALL(kill)
 680:	b8 06 00 00 00       	mov    $0x6,%eax
 685:	cd 40                	int    $0x40
 687:	c3                   	ret    

00000688 <exec>:
SYSCALL(exec)
 688:	b8 07 00 00 00       	mov    $0x7,%eax
 68d:	cd 40                	int    $0x40
 68f:	c3                   	ret    

00000690 <open>:
SYSCALL(open)
 690:	b8 0f 00 00 00       	mov    $0xf,%eax
 695:	cd 40                	int    $0x40
 697:	c3                   	ret    

00000698 <mknod>:
SYSCALL(mknod)
 698:	b8 11 00 00 00       	mov    $0x11,%eax
 69d:	cd 40                	int    $0x40
 69f:	c3                   	ret    

000006a0 <unlink>:
SYSCALL(unlink)
 6a0:	b8 12 00 00 00       	mov    $0x12,%eax
 6a5:	cd 40                	int    $0x40
 6a7:	c3                   	ret    

000006a8 <fstat>:
SYSCALL(fstat)
 6a8:	b8 08 00 00 00       	mov    $0x8,%eax
 6ad:	cd 40                	int    $0x40
 6af:	c3                   	ret    

000006b0 <link>:
SYSCALL(link)
 6b0:	b8 13 00 00 00       	mov    $0x13,%eax
 6b5:	cd 40                	int    $0x40
 6b7:	c3                   	ret    

000006b8 <mkdir>:
SYSCALL(mkdir)
 6b8:	b8 14 00 00 00       	mov    $0x14,%eax
 6bd:	cd 40                	int    $0x40
 6bf:	c3                   	ret    

000006c0 <chdir>:
SYSCALL(chdir)
 6c0:	b8 09 00 00 00       	mov    $0x9,%eax
 6c5:	cd 40                	int    $0x40
 6c7:	c3                   	ret    

000006c8 <dup>:
SYSCALL(dup)
 6c8:	b8 0a 00 00 00       	mov    $0xa,%eax
 6cd:	cd 40                	int    $0x40
 6cf:	c3                   	ret    

000006d0 <getpid>:
SYSCALL(getpid)
 6d0:	b8 0b 00 00 00       	mov    $0xb,%eax
 6d5:	cd 40                	int    $0x40
 6d7:	c3                   	ret    

000006d8 <sbrk>:
SYSCALL(sbrk)
 6d8:	b8 0c 00 00 00       	mov    $0xc,%eax
 6dd:	cd 40                	int    $0x40
 6df:	c3                   	ret    

000006e0 <sleep>:
SYSCALL(sleep)
 6e0:	b8 0d 00 00 00       	mov    $0xd,%eax
 6e5:	cd 40                	int    $0x40
 6e7:	c3                   	ret    

000006e8 <uptime>:
SYSCALL(uptime)
 6e8:	b8 0e 00 00 00       	mov    $0xe,%eax
 6ed:	cd 40                	int    $0x40
 6ef:	c3                   	ret    

000006f0 <add_path>:
SYSCALL(add_path)
 6f0:	b8 16 00 00 00       	mov    $0x16,%eax
 6f5:	cd 40                	int    $0x40
 6f7:	c3                   	ret    

000006f8 <wait2>:
SYSCALL(wait2)
 6f8:	b8 17 00 00 00       	mov    $0x17,%eax
 6fd:	cd 40                	int    $0x40
 6ff:	c3                   	ret    

00000700 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	83 ec 28             	sub    $0x28,%esp
 706:	8b 45 0c             	mov    0xc(%ebp),%eax
 709:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 70c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 713:	00 
 714:	8d 45 f4             	lea    -0xc(%ebp),%eax
 717:	89 44 24 04          	mov    %eax,0x4(%esp)
 71b:	8b 45 08             	mov    0x8(%ebp),%eax
 71e:	89 04 24             	mov    %eax,(%esp)
 721:	e8 4a ff ff ff       	call   670 <write>
}
 726:	c9                   	leave  
 727:	c3                   	ret    

00000728 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 728:	55                   	push   %ebp
 729:	89 e5                	mov    %esp,%ebp
 72b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 72e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 735:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 739:	74 17                	je     752 <printint+0x2a>
 73b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 73f:	79 11                	jns    752 <printint+0x2a>
    neg = 1;
 741:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 748:	8b 45 0c             	mov    0xc(%ebp),%eax
 74b:	f7 d8                	neg    %eax
 74d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 750:	eb 06                	jmp    758 <printint+0x30>
  } else {
    x = xx;
 752:	8b 45 0c             	mov    0xc(%ebp),%eax
 755:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 758:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 75f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 762:	8b 45 ec             	mov    -0x14(%ebp),%eax
 765:	ba 00 00 00 00       	mov    $0x0,%edx
 76a:	f7 f1                	div    %ecx
 76c:	89 d0                	mov    %edx,%eax
 76e:	8a 80 bc 0e 00 00    	mov    0xebc(%eax),%al
 774:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 777:	8b 55 f4             	mov    -0xc(%ebp),%edx
 77a:	01 ca                	add    %ecx,%edx
 77c:	88 02                	mov    %al,(%edx)
 77e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 781:	8b 55 10             	mov    0x10(%ebp),%edx
 784:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 787:	8b 45 ec             	mov    -0x14(%ebp),%eax
 78a:	ba 00 00 00 00       	mov    $0x0,%edx
 78f:	f7 75 d4             	divl   -0x2c(%ebp)
 792:	89 45 ec             	mov    %eax,-0x14(%ebp)
 795:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 799:	75 c4                	jne    75f <printint+0x37>
  if(neg)
 79b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 79f:	74 2c                	je     7cd <printint+0xa5>
    buf[i++] = '-';
 7a1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	01 d0                	add    %edx,%eax
 7a9:	c6 00 2d             	movb   $0x2d,(%eax)
 7ac:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 7af:	eb 1c                	jmp    7cd <printint+0xa5>
    putc(fd, buf[i]);
 7b1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	01 d0                	add    %edx,%eax
 7b9:	8a 00                	mov    (%eax),%al
 7bb:	0f be c0             	movsbl %al,%eax
 7be:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c2:	8b 45 08             	mov    0x8(%ebp),%eax
 7c5:	89 04 24             	mov    %eax,(%esp)
 7c8:	e8 33 ff ff ff       	call   700 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7cd:	ff 4d f4             	decl   -0xc(%ebp)
 7d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d4:	79 db                	jns    7b1 <printint+0x89>
    putc(fd, buf[i]);
}
 7d6:	c9                   	leave  
 7d7:	c3                   	ret    

000007d8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7d8:	55                   	push   %ebp
 7d9:	89 e5                	mov    %esp,%ebp
 7db:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7e5:	8d 45 0c             	lea    0xc(%ebp),%eax
 7e8:	83 c0 04             	add    $0x4,%eax
 7eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7f5:	e9 78 01 00 00       	jmp    972 <printf+0x19a>
    c = fmt[i] & 0xff;
 7fa:	8b 55 0c             	mov    0xc(%ebp),%edx
 7fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 800:	01 d0                	add    %edx,%eax
 802:	8a 00                	mov    (%eax),%al
 804:	0f be c0             	movsbl %al,%eax
 807:	25 ff 00 00 00       	and    $0xff,%eax
 80c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 80f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 813:	75 2c                	jne    841 <printf+0x69>
      if(c == '%'){
 815:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 819:	75 0c                	jne    827 <printf+0x4f>
        state = '%';
 81b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 822:	e9 48 01 00 00       	jmp    96f <printf+0x197>
      } else {
        putc(fd, c);
 827:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 82a:	0f be c0             	movsbl %al,%eax
 82d:	89 44 24 04          	mov    %eax,0x4(%esp)
 831:	8b 45 08             	mov    0x8(%ebp),%eax
 834:	89 04 24             	mov    %eax,(%esp)
 837:	e8 c4 fe ff ff       	call   700 <putc>
 83c:	e9 2e 01 00 00       	jmp    96f <printf+0x197>
      }
    } else if(state == '%'){
 841:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 845:	0f 85 24 01 00 00    	jne    96f <printf+0x197>
      if(c == 'd'){
 84b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 84f:	75 2d                	jne    87e <printf+0xa6>
        printint(fd, *ap, 10, 1);
 851:	8b 45 e8             	mov    -0x18(%ebp),%eax
 854:	8b 00                	mov    (%eax),%eax
 856:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 85d:	00 
 85e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 865:	00 
 866:	89 44 24 04          	mov    %eax,0x4(%esp)
 86a:	8b 45 08             	mov    0x8(%ebp),%eax
 86d:	89 04 24             	mov    %eax,(%esp)
 870:	e8 b3 fe ff ff       	call   728 <printint>
        ap++;
 875:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 879:	e9 ea 00 00 00       	jmp    968 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 87e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 882:	74 06                	je     88a <printf+0xb2>
 884:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 888:	75 2d                	jne    8b7 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 88a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 88d:	8b 00                	mov    (%eax),%eax
 88f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 896:	00 
 897:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 89e:	00 
 89f:	89 44 24 04          	mov    %eax,0x4(%esp)
 8a3:	8b 45 08             	mov    0x8(%ebp),%eax
 8a6:	89 04 24             	mov    %eax,(%esp)
 8a9:	e8 7a fe ff ff       	call   728 <printint>
        ap++;
 8ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8b2:	e9 b1 00 00 00       	jmp    968 <printf+0x190>
      } else if(c == 's'){
 8b7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8bb:	75 43                	jne    900 <printf+0x128>
        s = (char*)*ap;
 8bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8c0:	8b 00                	mov    (%eax),%eax
 8c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8cd:	75 25                	jne    8f4 <printf+0x11c>
          s = "(null)";
 8cf:	c7 45 f4 d6 0b 00 00 	movl   $0xbd6,-0xc(%ebp)
        while(*s != 0){
 8d6:	eb 1c                	jmp    8f4 <printf+0x11c>
          putc(fd, *s);
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	8a 00                	mov    (%eax),%al
 8dd:	0f be c0             	movsbl %al,%eax
 8e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e4:	8b 45 08             	mov    0x8(%ebp),%eax
 8e7:	89 04 24             	mov    %eax,(%esp)
 8ea:	e8 11 fe ff ff       	call   700 <putc>
          s++;
 8ef:	ff 45 f4             	incl   -0xc(%ebp)
 8f2:	eb 01                	jmp    8f5 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8f4:	90                   	nop
 8f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f8:	8a 00                	mov    (%eax),%al
 8fa:	84 c0                	test   %al,%al
 8fc:	75 da                	jne    8d8 <printf+0x100>
 8fe:	eb 68                	jmp    968 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 900:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 904:	75 1d                	jne    923 <printf+0x14b>
        putc(fd, *ap);
 906:	8b 45 e8             	mov    -0x18(%ebp),%eax
 909:	8b 00                	mov    (%eax),%eax
 90b:	0f be c0             	movsbl %al,%eax
 90e:	89 44 24 04          	mov    %eax,0x4(%esp)
 912:	8b 45 08             	mov    0x8(%ebp),%eax
 915:	89 04 24             	mov    %eax,(%esp)
 918:	e8 e3 fd ff ff       	call   700 <putc>
        ap++;
 91d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 921:	eb 45                	jmp    968 <printf+0x190>
      } else if(c == '%'){
 923:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 927:	75 17                	jne    940 <printf+0x168>
        putc(fd, c);
 929:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 92c:	0f be c0             	movsbl %al,%eax
 92f:	89 44 24 04          	mov    %eax,0x4(%esp)
 933:	8b 45 08             	mov    0x8(%ebp),%eax
 936:	89 04 24             	mov    %eax,(%esp)
 939:	e8 c2 fd ff ff       	call   700 <putc>
 93e:	eb 28                	jmp    968 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 940:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 947:	00 
 948:	8b 45 08             	mov    0x8(%ebp),%eax
 94b:	89 04 24             	mov    %eax,(%esp)
 94e:	e8 ad fd ff ff       	call   700 <putc>
        putc(fd, c);
 953:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 956:	0f be c0             	movsbl %al,%eax
 959:	89 44 24 04          	mov    %eax,0x4(%esp)
 95d:	8b 45 08             	mov    0x8(%ebp),%eax
 960:	89 04 24             	mov    %eax,(%esp)
 963:	e8 98 fd ff ff       	call   700 <putc>
      }
      state = 0;
 968:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 96f:	ff 45 f0             	incl   -0x10(%ebp)
 972:	8b 55 0c             	mov    0xc(%ebp),%edx
 975:	8b 45 f0             	mov    -0x10(%ebp),%eax
 978:	01 d0                	add    %edx,%eax
 97a:	8a 00                	mov    (%eax),%al
 97c:	84 c0                	test   %al,%al
 97e:	0f 85 76 fe ff ff    	jne    7fa <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 984:	c9                   	leave  
 985:	c3                   	ret    
 986:	66 90                	xchg   %ax,%ax

00000988 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 988:	55                   	push   %ebp
 989:	89 e5                	mov    %esp,%ebp
 98b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 98e:	8b 45 08             	mov    0x8(%ebp),%eax
 991:	83 e8 08             	sub    $0x8,%eax
 994:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 997:	a1 ec 0e 00 00       	mov    0xeec,%eax
 99c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 99f:	eb 24                	jmp    9c5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a4:	8b 00                	mov    (%eax),%eax
 9a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9a9:	77 12                	ja     9bd <free+0x35>
 9ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9b1:	77 24                	ja     9d7 <free+0x4f>
 9b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b6:	8b 00                	mov    (%eax),%eax
 9b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9bb:	77 1a                	ja     9d7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c0:	8b 00                	mov    (%eax),%eax
 9c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9cb:	76 d4                	jbe    9a1 <free+0x19>
 9cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d0:	8b 00                	mov    (%eax),%eax
 9d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9d5:	76 ca                	jbe    9a1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 9d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9da:	8b 40 04             	mov    0x4(%eax),%eax
 9dd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e7:	01 c2                	add    %eax,%edx
 9e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ec:	8b 00                	mov    (%eax),%eax
 9ee:	39 c2                	cmp    %eax,%edx
 9f0:	75 24                	jne    a16 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f5:	8b 50 04             	mov    0x4(%eax),%edx
 9f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fb:	8b 00                	mov    (%eax),%eax
 9fd:	8b 40 04             	mov    0x4(%eax),%eax
 a00:	01 c2                	add    %eax,%edx
 a02:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a05:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a08:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0b:	8b 00                	mov    (%eax),%eax
 a0d:	8b 10                	mov    (%eax),%edx
 a0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a12:	89 10                	mov    %edx,(%eax)
 a14:	eb 0a                	jmp    a20 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a19:	8b 10                	mov    (%eax),%edx
 a1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a1e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a23:	8b 40 04             	mov    0x4(%eax),%eax
 a26:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a30:	01 d0                	add    %edx,%eax
 a32:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a35:	75 20                	jne    a57 <free+0xcf>
    p->s.size += bp->s.size;
 a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a3a:	8b 50 04             	mov    0x4(%eax),%edx
 a3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a40:	8b 40 04             	mov    0x4(%eax),%eax
 a43:	01 c2                	add    %eax,%edx
 a45:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a48:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4e:	8b 10                	mov    (%eax),%edx
 a50:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a53:	89 10                	mov    %edx,(%eax)
 a55:	eb 08                	jmp    a5f <free+0xd7>
  } else
    p->s.ptr = bp;
 a57:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a5d:	89 10                	mov    %edx,(%eax)
  freep = p;
 a5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a62:	a3 ec 0e 00 00       	mov    %eax,0xeec
}
 a67:	c9                   	leave  
 a68:	c3                   	ret    

00000a69 <morecore>:

static Header*
morecore(uint nu)
{
 a69:	55                   	push   %ebp
 a6a:	89 e5                	mov    %esp,%ebp
 a6c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a6f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a76:	77 07                	ja     a7f <morecore+0x16>
    nu = 4096;
 a78:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a7f:	8b 45 08             	mov    0x8(%ebp),%eax
 a82:	c1 e0 03             	shl    $0x3,%eax
 a85:	89 04 24             	mov    %eax,(%esp)
 a88:	e8 4b fc ff ff       	call   6d8 <sbrk>
 a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a90:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a94:	75 07                	jne    a9d <morecore+0x34>
    return 0;
 a96:	b8 00 00 00 00       	mov    $0x0,%eax
 a9b:	eb 22                	jmp    abf <morecore+0x56>
  hp = (Header*)p;
 a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa6:	8b 55 08             	mov    0x8(%ebp),%edx
 aa9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aaf:	83 c0 08             	add    $0x8,%eax
 ab2:	89 04 24             	mov    %eax,(%esp)
 ab5:	e8 ce fe ff ff       	call   988 <free>
  return freep;
 aba:	a1 ec 0e 00 00       	mov    0xeec,%eax
}
 abf:	c9                   	leave  
 ac0:	c3                   	ret    

00000ac1 <malloc>:

void*
malloc(uint nbytes)
{
 ac1:	55                   	push   %ebp
 ac2:	89 e5                	mov    %esp,%ebp
 ac4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ac7:	8b 45 08             	mov    0x8(%ebp),%eax
 aca:	83 c0 07             	add    $0x7,%eax
 acd:	c1 e8 03             	shr    $0x3,%eax
 ad0:	40                   	inc    %eax
 ad1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ad4:	a1 ec 0e 00 00       	mov    0xeec,%eax
 ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 adc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ae0:	75 23                	jne    b05 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 ae2:	c7 45 f0 e4 0e 00 00 	movl   $0xee4,-0x10(%ebp)
 ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aec:	a3 ec 0e 00 00       	mov    %eax,0xeec
 af1:	a1 ec 0e 00 00       	mov    0xeec,%eax
 af6:	a3 e4 0e 00 00       	mov    %eax,0xee4
    base.s.size = 0;
 afb:	c7 05 e8 0e 00 00 00 	movl   $0x0,0xee8
 b02:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b08:	8b 00                	mov    (%eax),%eax
 b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b10:	8b 40 04             	mov    0x4(%eax),%eax
 b13:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b16:	72 4d                	jb     b65 <malloc+0xa4>
      if(p->s.size == nunits)
 b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1b:	8b 40 04             	mov    0x4(%eax),%eax
 b1e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b21:	75 0c                	jne    b2f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b26:	8b 10                	mov    (%eax),%edx
 b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b2b:	89 10                	mov    %edx,(%eax)
 b2d:	eb 26                	jmp    b55 <malloc+0x94>
      else {
        p->s.size -= nunits;
 b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b32:	8b 40 04             	mov    0x4(%eax),%eax
 b35:	89 c2                	mov    %eax,%edx
 b37:	2b 55 ec             	sub    -0x14(%ebp),%edx
 b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b43:	8b 40 04             	mov    0x4(%eax),%eax
 b46:	c1 e0 03             	shl    $0x3,%eax
 b49:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b52:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b58:	a3 ec 0e 00 00       	mov    %eax,0xeec
      return (void*)(p + 1);
 b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b60:	83 c0 08             	add    $0x8,%eax
 b63:	eb 38                	jmp    b9d <malloc+0xdc>
    }
    if(p == freep)
 b65:	a1 ec 0e 00 00       	mov    0xeec,%eax
 b6a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b6d:	75 1b                	jne    b8a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b72:	89 04 24             	mov    %eax,(%esp)
 b75:	e8 ef fe ff ff       	call   a69 <morecore>
 b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b81:	75 07                	jne    b8a <malloc+0xc9>
        return 0;
 b83:	b8 00 00 00 00       	mov    $0x0,%eax
 b88:	eb 13                	jmp    b9d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b93:	8b 00                	mov    (%eax),%eax
 b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b98:	e9 70 ff ff ff       	jmp    b0d <malloc+0x4c>
}
 b9d:	c9                   	leave  
 b9e:	c3                   	ret    
