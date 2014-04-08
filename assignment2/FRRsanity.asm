
_FRRsanity:     file format elf32-i386


Disassembly of section .text:

00000000 <frrSanity>:

#define N  1000

void
frrSanity()
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	81 ec d4 00 00 00    	sub    $0xd4,%esp
    int childPid[10];
    int wTime[10];
    int rTime[10];
    int ioTime[10];
    int i,j,k = 0;
   a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

    for(i = 0 ; i < 10 ; i++)
  11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  18:	eb 4a                	jmp    64 <frrSanity+0x64>
    {
        if(!fork())
  1a:	e8 29 04 00 00       	call   448 <fork>
  1f:	85 c0                	test   %eax,%eax
  21:	75 3e                	jne    61 <frrSanity+0x61>
        {
            for(j = 0 ; j < N ; j++)
  23:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  2a:	eb 27                	jmp    53 <frrSanity+0x53>
            {
                printf(1, "child <%d> prints for the <%d> time\n", getpid(), j);
  2c:	e8 9f 04 00 00       	call   4d0 <getpid>
  31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  34:	89 54 24 0c          	mov    %edx,0xc(%esp)
  38:	89 44 24 08          	mov    %eax,0x8(%esp)
  3c:	c7 44 24 04 a0 09 00 	movl   $0x9a0,0x4(%esp)
  43:	00 
  44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4b:	e8 88 05 00 00       	call   5d8 <printf>

    for(i = 0 ; i < 10 ; i++)
    {
        if(!fork())
        {
            for(j = 0 ; j < N ; j++)
  50:	ff 45 f0             	incl   -0x10(%ebp)
  53:	81 7d f0 e7 03 00 00 	cmpl   $0x3e7,-0x10(%ebp)
  5a:	7e d0                	jle    2c <frrSanity+0x2c>
            {
                printf(1, "child <%d> prints for the <%d> time\n", getpid(), j);
            }
            exit();
  5c:	e8 ef 03 00 00       	call   450 <exit>
    int wTime[10];
    int rTime[10];
    int ioTime[10];
    int i,j,k = 0;

    for(i = 0 ; i < 10 ; i++)
  61:	ff 45 f4             	incl   -0xc(%ebp)
  64:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  68:	7e b0                	jle    1a <frrSanity+0x1a>
                printf(1, "child <%d> prints for the <%d> time\n", getpid(), j);
            }
            exit();
        }
    }
    while((childPid[k] = wait2(&wTime[k],&rTime[k],&ioTime[k])) > 0)
  6a:	eb 03                	jmp    6f <frrSanity+0x6f>
    {
        k++;
  6c:	ff 45 ec             	incl   -0x14(%ebp)
                printf(1, "child <%d> prints for the <%d> time\n", getpid(), j);
            }
            exit();
        }
    }
    while((childPid[k] = wait2(&wTime[k],&rTime[k],&ioTime[k])) > 0)
  6f:	8d 85 48 ff ff ff    	lea    -0xb8(%ebp),%eax
  75:	8b 55 ec             	mov    -0x14(%ebp),%edx
  78:	c1 e2 02             	shl    $0x2,%edx
  7b:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  7e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  84:	8b 55 ec             	mov    -0x14(%ebp),%edx
  87:	c1 e2 02             	shl    $0x2,%edx
  8a:	01 c2                	add    %eax,%edx
  8c:	8d 45 98             	lea    -0x68(%ebp),%eax
  8f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  92:	c1 e3 02             	shl    $0x2,%ebx
  95:	01 d8                	add    %ebx,%eax
  97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  9b:	89 54 24 04          	mov    %edx,0x4(%esp)
  9f:	89 04 24             	mov    %eax,(%esp)
  a2:	e8 51 04 00 00       	call   4f8 <wait2>
  a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  aa:	89 44 95 c0          	mov    %eax,-0x40(%ebp,%edx,4)
  ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  b1:	8b 44 85 c0          	mov    -0x40(%ebp,%eax,4),%eax
  b5:	85 c0                	test   %eax,%eax
  b7:	7f b3                	jg     6c <frrSanity+0x6c>
    {
        k++;
    }

    for(i = 0 ; i < 10 ; i++)
  b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  c0:	eb 64                	jmp    126 <frrSanity+0x126>
    {
        int turnArroundTime =  wTime[i] + rTime[i] + ioTime[i];
  c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c5:	8b 54 85 98          	mov    -0x68(%ebp,%eax,4),%edx
  c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  cc:	8b 84 85 70 ff ff ff 	mov    -0x90(%ebp,%eax,4),%eax
  d3:	01 c2                	add    %eax,%edx
  d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d8:	8b 84 85 48 ff ff ff 	mov    -0xb8(%ebp,%eax,4),%eax
  df:	01 d0                	add    %edx,%eax
  e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        printf(2, "chlidPid: %d - waitTime: %d , runTime: %d , turnArroundTime: %d\n",  childPid[i],
  e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  e7:	8b 8c 85 70 ff ff ff 	mov    -0x90(%ebp,%eax,4),%ecx
  ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  f1:	8b 54 85 98          	mov    -0x68(%ebp,%eax,4),%edx
  f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  f8:	8b 44 85 c0          	mov    -0x40(%ebp,%eax,4),%eax
  fc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  ff:	89 5c 24 14          	mov    %ebx,0x14(%esp)
 103:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 107:	89 54 24 0c          	mov    %edx,0xc(%esp)
 10b:	89 44 24 08          	mov    %eax,0x8(%esp)
 10f:	c7 44 24 04 c8 09 00 	movl   $0x9c8,0x4(%esp)
 116:	00 
 117:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 11e:	e8 b5 04 00 00       	call   5d8 <printf>
    while((childPid[k] = wait2(&wTime[k],&rTime[k],&ioTime[k])) > 0)
    {
        k++;
    }

    for(i = 0 ; i < 10 ; i++)
 123:	ff 45 f4             	incl   -0xc(%ebp)
 126:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 12a:	7e 96                	jle    c2 <frrSanity+0xc2>
        printf(2, "chlidPid: %d - waitTime: %d , runTime: %d , turnArroundTime: %d\n",  childPid[i],
                                                                                        wTime[i],
                                                                                        rTime[i],
                                                                                        turnArroundTime);
    }
}
 12c:	81 c4 d4 00 00 00    	add    $0xd4,%esp
 132:	5b                   	pop    %ebx
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <main>:

int
main(void)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 e4 f0             	and    $0xfffffff0,%esp
  frrSanity();
 13b:	e8 c0 fe ff ff       	call   0 <frrSanity>
  exit();
 140:	e8 0b 03 00 00       	call   450 <exit>
 145:	66 90                	xchg   %ax,%ax
 147:	90                   	nop

00000148 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	57                   	push   %edi
 14c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 14d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 150:	8b 55 10             	mov    0x10(%ebp),%edx
 153:	8b 45 0c             	mov    0xc(%ebp),%eax
 156:	89 cb                	mov    %ecx,%ebx
 158:	89 df                	mov    %ebx,%edi
 15a:	89 d1                	mov    %edx,%ecx
 15c:	fc                   	cld    
 15d:	f3 aa                	rep stos %al,%es:(%edi)
 15f:	89 ca                	mov    %ecx,%edx
 161:	89 fb                	mov    %edi,%ebx
 163:	89 5d 08             	mov    %ebx,0x8(%ebp)
 166:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 169:	5b                   	pop    %ebx
 16a:	5f                   	pop    %edi
 16b:	5d                   	pop    %ebp
 16c:	c3                   	ret    

0000016d <strcpy>:

#define NULL   0

char*
strcpy(char *s, char *t)
{
 16d:	55                   	push   %ebp
 16e:	89 e5                	mov    %esp,%ebp
 170:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 179:	90                   	nop
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	8a 10                	mov    (%eax),%dl
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	88 10                	mov    %dl,(%eax)
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	8a 00                	mov    (%eax),%al
 189:	84 c0                	test   %al,%al
 18b:	0f 95 c0             	setne  %al
 18e:	ff 45 08             	incl   0x8(%ebp)
 191:	ff 45 0c             	incl   0xc(%ebp)
 194:	84 c0                	test   %al,%al
 196:	75 e2                	jne    17a <strcpy+0xd>
    ;
  return os;
 198:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 19b:	c9                   	leave  
 19c:	c3                   	ret    

0000019d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 19d:	55                   	push   %ebp
 19e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1a0:	eb 06                	jmp    1a8 <strcmp+0xb>
    p++, q++;
 1a2:	ff 45 08             	incl   0x8(%ebp)
 1a5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	8a 00                	mov    (%eax),%al
 1ad:	84 c0                	test   %al,%al
 1af:	74 0e                	je     1bf <strcmp+0x22>
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	8a 10                	mov    (%eax),%dl
 1b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b9:	8a 00                	mov    (%eax),%al
 1bb:	38 c2                	cmp    %al,%dl
 1bd:	74 e3                	je     1a2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	8a 00                	mov    (%eax),%al
 1c4:	0f b6 d0             	movzbl %al,%edx
 1c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ca:	8a 00                	mov    (%eax),%al
 1cc:	0f b6 c0             	movzbl %al,%eax
 1cf:	89 d1                	mov    %edx,%ecx
 1d1:	29 c1                	sub    %eax,%ecx
 1d3:	89 c8                	mov    %ecx,%eax
}
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    

000001d7 <strlen>:

uint
strlen(char *s)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1e4:	eb 03                	jmp    1e9 <strlen+0x12>
 1e6:	ff 45 fc             	incl   -0x4(%ebp)
 1e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
 1ef:	01 d0                	add    %edx,%eax
 1f1:	8a 00                	mov    (%eax),%al
 1f3:	84 c0                	test   %al,%al
 1f5:	75 ef                	jne    1e6 <strlen+0xf>
    ;
  return n;
 1f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1fa:	c9                   	leave  
 1fb:	c3                   	ret    

000001fc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 202:	8b 45 10             	mov    0x10(%ebp),%eax
 205:	89 44 24 08          	mov    %eax,0x8(%esp)
 209:	8b 45 0c             	mov    0xc(%ebp),%eax
 20c:	89 44 24 04          	mov    %eax,0x4(%esp)
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	89 04 24             	mov    %eax,(%esp)
 216:	e8 2d ff ff ff       	call   148 <stosb>
  return dst;
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21e:	c9                   	leave  
 21f:	c3                   	ret    

00000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 04             	sub    $0x4,%esp
 226:	8b 45 0c             	mov    0xc(%ebp),%eax
 229:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 22c:	eb 12                	jmp    240 <strchr+0x20>
    if(*s == c)
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	8a 00                	mov    (%eax),%al
 233:	3a 45 fc             	cmp    -0x4(%ebp),%al
 236:	75 05                	jne    23d <strchr+0x1d>
      return (char*)s;
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	eb 11                	jmp    24e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 23d:	ff 45 08             	incl   0x8(%ebp)
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	8a 00                	mov    (%eax),%al
 245:	84 c0                	test   %al,%al
 247:	75 e5                	jne    22e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 249:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <gets>:

char*
gets(char *buf, int max)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 25d:	eb 42                	jmp    2a1 <gets+0x51>
    cc = read(0, &c, 1);
 25f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 266:	00 
 267:	8d 45 ef             	lea    -0x11(%ebp),%eax
 26a:	89 44 24 04          	mov    %eax,0x4(%esp)
 26e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 275:	e8 ee 01 00 00       	call   468 <read>
 27a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 27d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 281:	7e 29                	jle    2ac <gets+0x5c>
      break;
    buf[i++] = c;
 283:	8b 55 f4             	mov    -0xc(%ebp),%edx
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	01 c2                	add    %eax,%edx
 28b:	8a 45 ef             	mov    -0x11(%ebp),%al
 28e:	88 02                	mov    %al,(%edx)
 290:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 293:	8a 45 ef             	mov    -0x11(%ebp),%al
 296:	3c 0a                	cmp    $0xa,%al
 298:	74 13                	je     2ad <gets+0x5d>
 29a:	8a 45 ef             	mov    -0x11(%ebp),%al
 29d:	3c 0d                	cmp    $0xd,%al
 29f:	74 0c                	je     2ad <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a4:	40                   	inc    %eax
 2a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2a8:	7c b5                	jl     25f <gets+0xf>
 2aa:	eb 01                	jmp    2ad <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2ac:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	01 d0                	add    %edx,%eax
 2b5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bb:	c9                   	leave  
 2bc:	c3                   	ret    

000002bd <stat>:

int
stat(char *n, struct stat *st)
{
 2bd:	55                   	push   %ebp
 2be:	89 e5                	mov    %esp,%ebp
 2c0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2ca:	00 
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	89 04 24             	mov    %eax,(%esp)
 2d1:	e8 ba 01 00 00       	call   490 <open>
 2d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2dd:	79 07                	jns    2e6 <stat+0x29>
    return -1;
 2df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e4:	eb 23                	jmp    309 <stat+0x4c>
  r = fstat(fd, st);
 2e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f0:	89 04 24             	mov    %eax,(%esp)
 2f3:	e8 b0 01 00 00       	call   4a8 <fstat>
 2f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2fe:	89 04 24             	mov    %eax,(%esp)
 301:	e8 72 01 00 00       	call   478 <close>
  return r;
 306:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 309:	c9                   	leave  
 30a:	c3                   	ret    

0000030b <atoi>:

int
atoi(const char *s)
{
 30b:	55                   	push   %ebp
 30c:	89 e5                	mov    %esp,%ebp
 30e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 311:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 318:	eb 21                	jmp    33b <atoi+0x30>
    n = n*10 + *s++ - '0';
 31a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 31d:	89 d0                	mov    %edx,%eax
 31f:	c1 e0 02             	shl    $0x2,%eax
 322:	01 d0                	add    %edx,%eax
 324:	d1 e0                	shl    %eax
 326:	89 c2                	mov    %eax,%edx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	8a 00                	mov    (%eax),%al
 32d:	0f be c0             	movsbl %al,%eax
 330:	01 d0                	add    %edx,%eax
 332:	83 e8 30             	sub    $0x30,%eax
 335:	89 45 fc             	mov    %eax,-0x4(%ebp)
 338:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	8a 00                	mov    (%eax),%al
 340:	3c 2f                	cmp    $0x2f,%al
 342:	7e 09                	jle    34d <atoi+0x42>
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	8a 00                	mov    (%eax),%al
 349:	3c 39                	cmp    $0x39,%al
 34b:	7e cd                	jle    31a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 34d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 350:	c9                   	leave  
 351:	c3                   	ret    

00000352 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 352:	55                   	push   %ebp
 353:	89 e5                	mov    %esp,%ebp
 355:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 358:	8b 45 08             	mov    0x8(%ebp),%eax
 35b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 35e:	8b 45 0c             	mov    0xc(%ebp),%eax
 361:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 364:	eb 10                	jmp    376 <memmove+0x24>
    *dst++ = *src++;
 366:	8b 45 f8             	mov    -0x8(%ebp),%eax
 369:	8a 10                	mov    (%eax),%dl
 36b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 36e:	88 10                	mov    %dl,(%eax)
 370:	ff 45 fc             	incl   -0x4(%ebp)
 373:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 376:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 37a:	0f 9f c0             	setg   %al
 37d:	ff 4d 10             	decl   0x10(%ebp)
 380:	84 c0                	test   %al,%al
 382:	75 e2                	jne    366 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 384:	8b 45 08             	mov    0x8(%ebp),%eax
}
 387:	c9                   	leave  
 388:	c3                   	ret    

00000389 <strtok>:

char*
strtok(char *teststr, char ch)
{
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	83 ec 24             	sub    $0x24,%esp
 38f:	8b 45 0c             	mov    0xc(%ebp),%eax
 392:	88 45 dc             	mov    %al,-0x24(%ebp)
    char *dummystr = NULL;
 395:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    char *start = NULL;
 39c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    char *end = NULL;
 3a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char nullch = '\0';
 3aa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    char *address_of_null = &nullch;
 3ae:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    static char *nexttok;

    if(teststr != NULL)
 3b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3b8:	74 08                	je     3c2 <strtok+0x39>
    {
        dummystr = teststr;
 3ba:	8b 45 08             	mov    0x8(%ebp),%eax
 3bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 3c0:	eb 75                	jmp    437 <strtok+0xae>
    {
        dummystr = teststr;
    }
    else
    {
        if(*nexttok == '\0')
 3c2:	a1 a8 0c 00 00       	mov    0xca8,%eax
 3c7:	8a 00                	mov    (%eax),%al
 3c9:	84 c0                	test   %al,%al
 3cb:	75 07                	jne    3d4 <strtok+0x4b>
            return NULL;
 3cd:	b8 00 00 00 00       	mov    $0x0,%eax
 3d2:	eb 6f                	jmp    443 <strtok+0xba>
        dummystr = nexttok;
 3d4:	a1 a8 0c 00 00       	mov    0xca8,%eax
 3d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }


    while(dummystr != NULL)
 3dc:	eb 59                	jmp    437 <strtok+0xae>
    {
        //empty string
        if(*dummystr == '\0')
 3de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3e1:	8a 00                	mov    (%eax),%al
 3e3:	84 c0                	test   %al,%al
 3e5:	74 58                	je     43f <strtok+0xb6>
            break;
        if(*dummystr != ch)
 3e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ea:	8a 00                	mov    (%eax),%al
 3ec:	3a 45 dc             	cmp    -0x24(%ebp),%al
 3ef:	74 22                	je     413 <strtok+0x8a>
        {
            if(!start)
 3f1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 3f5:	75 06                	jne    3fd <strtok+0x74>
                start = dummystr;
 3f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3fa:	89 45 f8             	mov    %eax,-0x8(%ebp)

            dummystr++;
 3fd:	ff 45 fc             	incl   -0x4(%ebp)

            // handle the case where the delimiter is not at the end of the string.
            if(*dummystr == '\0')
 400:	8b 45 fc             	mov    -0x4(%ebp),%eax
 403:	8a 00                	mov    (%eax),%al
 405:	84 c0                	test   %al,%al
 407:	75 2e                	jne    437 <strtok+0xae>
            {
                nexttok = dummystr;
 409:	8b 45 fc             	mov    -0x4(%ebp),%eax
 40c:	a3 a8 0c 00 00       	mov    %eax,0xca8
                break;
 411:	eb 2d                	jmp    440 <strtok+0xb7>
            }
        }
        else
        {
            if(start)
 413:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 417:	74 1b                	je     434 <strtok+0xab>
            {
                end = dummystr;
 419:	8b 45 fc             	mov    -0x4(%ebp),%eax
 41c:	89 45 f4             	mov    %eax,-0xc(%ebp)
                nexttok = dummystr+1;
 41f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 422:	40                   	inc    %eax
 423:	a3 a8 0c 00 00       	mov    %eax,0xca8
                *end = *address_of_null;
 428:	8b 45 f0             	mov    -0x10(%ebp),%eax
 42b:	8a 10                	mov    (%eax),%dl
 42d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 430:	88 10                	mov    %dl,(%eax)
                break;
 432:	eb 0c                	jmp    440 <strtok+0xb7>
            }
            else
            {
                dummystr++;
 434:	ff 45 fc             	incl   -0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 437:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
 43b:	75 a1                	jne    3de <strtok+0x55>
 43d:	eb 01                	jmp    440 <strtok+0xb7>
    {
        //empty string
        if(*dummystr == '\0')
            break;
 43f:	90                   	nop
                dummystr++;
            }
        }
    }

    return start;
 440:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 443:	c9                   	leave  
 444:	c3                   	ret    
 445:	66 90                	xchg   %ax,%ax
 447:	90                   	nop

00000448 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 448:	b8 01 00 00 00       	mov    $0x1,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <exit>:
SYSCALL(exit)
 450:	b8 02 00 00 00       	mov    $0x2,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <wait>:
SYSCALL(wait)
 458:	b8 03 00 00 00       	mov    $0x3,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <pipe>:
SYSCALL(pipe)
 460:	b8 04 00 00 00       	mov    $0x4,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <read>:
SYSCALL(read)
 468:	b8 05 00 00 00       	mov    $0x5,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <write>:
SYSCALL(write)
 470:	b8 10 00 00 00       	mov    $0x10,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <close>:
SYSCALL(close)
 478:	b8 15 00 00 00       	mov    $0x15,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <kill>:
SYSCALL(kill)
 480:	b8 06 00 00 00       	mov    $0x6,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <exec>:
SYSCALL(exec)
 488:	b8 07 00 00 00       	mov    $0x7,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <open>:
SYSCALL(open)
 490:	b8 0f 00 00 00       	mov    $0xf,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <mknod>:
SYSCALL(mknod)
 498:	b8 11 00 00 00       	mov    $0x11,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <unlink>:
SYSCALL(unlink)
 4a0:	b8 12 00 00 00       	mov    $0x12,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <fstat>:
SYSCALL(fstat)
 4a8:	b8 08 00 00 00       	mov    $0x8,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <link>:
SYSCALL(link)
 4b0:	b8 13 00 00 00       	mov    $0x13,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <mkdir>:
SYSCALL(mkdir)
 4b8:	b8 14 00 00 00       	mov    $0x14,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <chdir>:
SYSCALL(chdir)
 4c0:	b8 09 00 00 00       	mov    $0x9,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <dup>:
SYSCALL(dup)
 4c8:	b8 0a 00 00 00       	mov    $0xa,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <getpid>:
SYSCALL(getpid)
 4d0:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <sbrk>:
SYSCALL(sbrk)
 4d8:	b8 0c 00 00 00       	mov    $0xc,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <sleep>:
SYSCALL(sleep)
 4e0:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <uptime>:
SYSCALL(uptime)
 4e8:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <add_path>:
SYSCALL(add_path)
 4f0:	b8 16 00 00 00       	mov    $0x16,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <wait2>:
SYSCALL(wait2)
 4f8:	b8 17 00 00 00       	mov    $0x17,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	83 ec 28             	sub    $0x28,%esp
 506:	8b 45 0c             	mov    0xc(%ebp),%eax
 509:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 50c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 513:	00 
 514:	8d 45 f4             	lea    -0xc(%ebp),%eax
 517:	89 44 24 04          	mov    %eax,0x4(%esp)
 51b:	8b 45 08             	mov    0x8(%ebp),%eax
 51e:	89 04 24             	mov    %eax,(%esp)
 521:	e8 4a ff ff ff       	call   470 <write>
}
 526:	c9                   	leave  
 527:	c3                   	ret    

00000528 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 528:	55                   	push   %ebp
 529:	89 e5                	mov    %esp,%ebp
 52b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 52e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 535:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 539:	74 17                	je     552 <printint+0x2a>
 53b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 53f:	79 11                	jns    552 <printint+0x2a>
    neg = 1;
 541:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 548:	8b 45 0c             	mov    0xc(%ebp),%eax
 54b:	f7 d8                	neg    %eax
 54d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 550:	eb 06                	jmp    558 <printint+0x30>
  } else {
    x = xx;
 552:	8b 45 0c             	mov    0xc(%ebp),%eax
 555:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 558:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 55f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 562:	8b 45 ec             	mov    -0x14(%ebp),%eax
 565:	ba 00 00 00 00       	mov    $0x0,%edx
 56a:	f7 f1                	div    %ecx
 56c:	89 d0                	mov    %edx,%eax
 56e:	8a 80 94 0c 00 00    	mov    0xc94(%eax),%al
 574:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 577:	8b 55 f4             	mov    -0xc(%ebp),%edx
 57a:	01 ca                	add    %ecx,%edx
 57c:	88 02                	mov    %al,(%edx)
 57e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 581:	8b 55 10             	mov    0x10(%ebp),%edx
 584:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 587:	8b 45 ec             	mov    -0x14(%ebp),%eax
 58a:	ba 00 00 00 00       	mov    $0x0,%edx
 58f:	f7 75 d4             	divl   -0x2c(%ebp)
 592:	89 45 ec             	mov    %eax,-0x14(%ebp)
 595:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 599:	75 c4                	jne    55f <printint+0x37>
  if(neg)
 59b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 59f:	74 2c                	je     5cd <printint+0xa5>
    buf[i++] = '-';
 5a1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a7:	01 d0                	add    %edx,%eax
 5a9:	c6 00 2d             	movb   $0x2d,(%eax)
 5ac:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 5af:	eb 1c                	jmp    5cd <printint+0xa5>
    putc(fd, buf[i]);
 5b1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b7:	01 d0                	add    %edx,%eax
 5b9:	8a 00                	mov    (%eax),%al
 5bb:	0f be c0             	movsbl %al,%eax
 5be:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c2:	8b 45 08             	mov    0x8(%ebp),%eax
 5c5:	89 04 24             	mov    %eax,(%esp)
 5c8:	e8 33 ff ff ff       	call   500 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5cd:	ff 4d f4             	decl   -0xc(%ebp)
 5d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d4:	79 db                	jns    5b1 <printint+0x89>
    putc(fd, buf[i]);
}
 5d6:	c9                   	leave  
 5d7:	c3                   	ret    

000005d8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5d8:	55                   	push   %ebp
 5d9:	89 e5                	mov    %esp,%ebp
 5db:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5e5:	8d 45 0c             	lea    0xc(%ebp),%eax
 5e8:	83 c0 04             	add    $0x4,%eax
 5eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5f5:	e9 78 01 00 00       	jmp    772 <printf+0x19a>
    c = fmt[i] & 0xff;
 5fa:	8b 55 0c             	mov    0xc(%ebp),%edx
 5fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 600:	01 d0                	add    %edx,%eax
 602:	8a 00                	mov    (%eax),%al
 604:	0f be c0             	movsbl %al,%eax
 607:	25 ff 00 00 00       	and    $0xff,%eax
 60c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 60f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 613:	75 2c                	jne    641 <printf+0x69>
      if(c == '%'){
 615:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 619:	75 0c                	jne    627 <printf+0x4f>
        state = '%';
 61b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 622:	e9 48 01 00 00       	jmp    76f <printf+0x197>
      } else {
        putc(fd, c);
 627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62a:	0f be c0             	movsbl %al,%eax
 62d:	89 44 24 04          	mov    %eax,0x4(%esp)
 631:	8b 45 08             	mov    0x8(%ebp),%eax
 634:	89 04 24             	mov    %eax,(%esp)
 637:	e8 c4 fe ff ff       	call   500 <putc>
 63c:	e9 2e 01 00 00       	jmp    76f <printf+0x197>
      }
    } else if(state == '%'){
 641:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 645:	0f 85 24 01 00 00    	jne    76f <printf+0x197>
      if(c == 'd'){
 64b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 64f:	75 2d                	jne    67e <printf+0xa6>
        printint(fd, *ap, 10, 1);
 651:	8b 45 e8             	mov    -0x18(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 65d:	00 
 65e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 665:	00 
 666:	89 44 24 04          	mov    %eax,0x4(%esp)
 66a:	8b 45 08             	mov    0x8(%ebp),%eax
 66d:	89 04 24             	mov    %eax,(%esp)
 670:	e8 b3 fe ff ff       	call   528 <printint>
        ap++;
 675:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 679:	e9 ea 00 00 00       	jmp    768 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 67e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 682:	74 06                	je     68a <printf+0xb2>
 684:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 688:	75 2d                	jne    6b7 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 68a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 696:	00 
 697:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 69e:	00 
 69f:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a3:	8b 45 08             	mov    0x8(%ebp),%eax
 6a6:	89 04 24             	mov    %eax,(%esp)
 6a9:	e8 7a fe ff ff       	call   528 <printint>
        ap++;
 6ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6b2:	e9 b1 00 00 00       	jmp    768 <printf+0x190>
      } else if(c == 's'){
 6b7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6bb:	75 43                	jne    700 <printf+0x128>
        s = (char*)*ap;
 6bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6cd:	75 25                	jne    6f4 <printf+0x11c>
          s = "(null)";
 6cf:	c7 45 f4 09 0a 00 00 	movl   $0xa09,-0xc(%ebp)
        while(*s != 0){
 6d6:	eb 1c                	jmp    6f4 <printf+0x11c>
          putc(fd, *s);
 6d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6db:	8a 00                	mov    (%eax),%al
 6dd:	0f be c0             	movsbl %al,%eax
 6e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e4:	8b 45 08             	mov    0x8(%ebp),%eax
 6e7:	89 04 24             	mov    %eax,(%esp)
 6ea:	e8 11 fe ff ff       	call   500 <putc>
          s++;
 6ef:	ff 45 f4             	incl   -0xc(%ebp)
 6f2:	eb 01                	jmp    6f5 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6f4:	90                   	nop
 6f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f8:	8a 00                	mov    (%eax),%al
 6fa:	84 c0                	test   %al,%al
 6fc:	75 da                	jne    6d8 <printf+0x100>
 6fe:	eb 68                	jmp    768 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 700:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 704:	75 1d                	jne    723 <printf+0x14b>
        putc(fd, *ap);
 706:	8b 45 e8             	mov    -0x18(%ebp),%eax
 709:	8b 00                	mov    (%eax),%eax
 70b:	0f be c0             	movsbl %al,%eax
 70e:	89 44 24 04          	mov    %eax,0x4(%esp)
 712:	8b 45 08             	mov    0x8(%ebp),%eax
 715:	89 04 24             	mov    %eax,(%esp)
 718:	e8 e3 fd ff ff       	call   500 <putc>
        ap++;
 71d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 721:	eb 45                	jmp    768 <printf+0x190>
      } else if(c == '%'){
 723:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 727:	75 17                	jne    740 <printf+0x168>
        putc(fd, c);
 729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72c:	0f be c0             	movsbl %al,%eax
 72f:	89 44 24 04          	mov    %eax,0x4(%esp)
 733:	8b 45 08             	mov    0x8(%ebp),%eax
 736:	89 04 24             	mov    %eax,(%esp)
 739:	e8 c2 fd ff ff       	call   500 <putc>
 73e:	eb 28                	jmp    768 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 740:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 747:	00 
 748:	8b 45 08             	mov    0x8(%ebp),%eax
 74b:	89 04 24             	mov    %eax,(%esp)
 74e:	e8 ad fd ff ff       	call   500 <putc>
        putc(fd, c);
 753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 756:	0f be c0             	movsbl %al,%eax
 759:	89 44 24 04          	mov    %eax,0x4(%esp)
 75d:	8b 45 08             	mov    0x8(%ebp),%eax
 760:	89 04 24             	mov    %eax,(%esp)
 763:	e8 98 fd ff ff       	call   500 <putc>
      }
      state = 0;
 768:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 76f:	ff 45 f0             	incl   -0x10(%ebp)
 772:	8b 55 0c             	mov    0xc(%ebp),%edx
 775:	8b 45 f0             	mov    -0x10(%ebp),%eax
 778:	01 d0                	add    %edx,%eax
 77a:	8a 00                	mov    (%eax),%al
 77c:	84 c0                	test   %al,%al
 77e:	0f 85 76 fe ff ff    	jne    5fa <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 784:	c9                   	leave  
 785:	c3                   	ret    
 786:	66 90                	xchg   %ax,%ax

00000788 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 788:	55                   	push   %ebp
 789:	89 e5                	mov    %esp,%ebp
 78b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78e:	8b 45 08             	mov    0x8(%ebp),%eax
 791:	83 e8 08             	sub    $0x8,%eax
 794:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 797:	a1 b4 0c 00 00       	mov    0xcb4,%eax
 79c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 79f:	eb 24                	jmp    7c5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a9:	77 12                	ja     7bd <free+0x35>
 7ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b1:	77 24                	ja     7d7 <free+0x4f>
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	8b 00                	mov    (%eax),%eax
 7b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7bb:	77 1a                	ja     7d7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7cb:	76 d4                	jbe    7a1 <free+0x19>
 7cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d0:	8b 00                	mov    (%eax),%eax
 7d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d5:	76 ca                	jbe    7a1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7da:	8b 40 04             	mov    0x4(%eax),%eax
 7dd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e7:	01 c2                	add    %eax,%edx
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	8b 00                	mov    (%eax),%eax
 7ee:	39 c2                	cmp    %eax,%edx
 7f0:	75 24                	jne    816 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f5:	8b 50 04             	mov    0x4(%eax),%edx
 7f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fb:	8b 00                	mov    (%eax),%eax
 7fd:	8b 40 04             	mov    0x4(%eax),%eax
 800:	01 c2                	add    %eax,%edx
 802:	8b 45 f8             	mov    -0x8(%ebp),%eax
 805:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 808:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80b:	8b 00                	mov    (%eax),%eax
 80d:	8b 10                	mov    (%eax),%edx
 80f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 812:	89 10                	mov    %edx,(%eax)
 814:	eb 0a                	jmp    820 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	8b 10                	mov    (%eax),%edx
 81b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 820:	8b 45 fc             	mov    -0x4(%ebp),%eax
 823:	8b 40 04             	mov    0x4(%eax),%eax
 826:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	01 d0                	add    %edx,%eax
 832:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 835:	75 20                	jne    857 <free+0xcf>
    p->s.size += bp->s.size;
 837:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83a:	8b 50 04             	mov    0x4(%eax),%edx
 83d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 840:	8b 40 04             	mov    0x4(%eax),%eax
 843:	01 c2                	add    %eax,%edx
 845:	8b 45 fc             	mov    -0x4(%ebp),%eax
 848:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 84b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84e:	8b 10                	mov    (%eax),%edx
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	89 10                	mov    %edx,(%eax)
 855:	eb 08                	jmp    85f <free+0xd7>
  } else
    p->s.ptr = bp;
 857:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 85d:	89 10                	mov    %edx,(%eax)
  freep = p;
 85f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 862:	a3 b4 0c 00 00       	mov    %eax,0xcb4
}
 867:	c9                   	leave  
 868:	c3                   	ret    

00000869 <morecore>:

static Header*
morecore(uint nu)
{
 869:	55                   	push   %ebp
 86a:	89 e5                	mov    %esp,%ebp
 86c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 86f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 876:	77 07                	ja     87f <morecore+0x16>
    nu = 4096;
 878:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 87f:	8b 45 08             	mov    0x8(%ebp),%eax
 882:	c1 e0 03             	shl    $0x3,%eax
 885:	89 04 24             	mov    %eax,(%esp)
 888:	e8 4b fc ff ff       	call   4d8 <sbrk>
 88d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 890:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 894:	75 07                	jne    89d <morecore+0x34>
    return 0;
 896:	b8 00 00 00 00       	mov    $0x0,%eax
 89b:	eb 22                	jmp    8bf <morecore+0x56>
  hp = (Header*)p;
 89d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a6:	8b 55 08             	mov    0x8(%ebp),%edx
 8a9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8af:	83 c0 08             	add    $0x8,%eax
 8b2:	89 04 24             	mov    %eax,(%esp)
 8b5:	e8 ce fe ff ff       	call   788 <free>
  return freep;
 8ba:	a1 b4 0c 00 00       	mov    0xcb4,%eax
}
 8bf:	c9                   	leave  
 8c0:	c3                   	ret    

000008c1 <malloc>:

void*
malloc(uint nbytes)
{
 8c1:	55                   	push   %ebp
 8c2:	89 e5                	mov    %esp,%ebp
 8c4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ca:	83 c0 07             	add    $0x7,%eax
 8cd:	c1 e8 03             	shr    $0x3,%eax
 8d0:	40                   	inc    %eax
 8d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8d4:	a1 b4 0c 00 00       	mov    0xcb4,%eax
 8d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e0:	75 23                	jne    905 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 8e2:	c7 45 f0 ac 0c 00 00 	movl   $0xcac,-0x10(%ebp)
 8e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ec:	a3 b4 0c 00 00       	mov    %eax,0xcb4
 8f1:	a1 b4 0c 00 00       	mov    0xcb4,%eax
 8f6:	a3 ac 0c 00 00       	mov    %eax,0xcac
    base.s.size = 0;
 8fb:	c7 05 b0 0c 00 00 00 	movl   $0x0,0xcb0
 902:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 905:	8b 45 f0             	mov    -0x10(%ebp),%eax
 908:	8b 00                	mov    (%eax),%eax
 90a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 90d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 910:	8b 40 04             	mov    0x4(%eax),%eax
 913:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 916:	72 4d                	jb     965 <malloc+0xa4>
      if(p->s.size == nunits)
 918:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91b:	8b 40 04             	mov    0x4(%eax),%eax
 91e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 921:	75 0c                	jne    92f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 923:	8b 45 f4             	mov    -0xc(%ebp),%eax
 926:	8b 10                	mov    (%eax),%edx
 928:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92b:	89 10                	mov    %edx,(%eax)
 92d:	eb 26                	jmp    955 <malloc+0x94>
      else {
        p->s.size -= nunits;
 92f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 932:	8b 40 04             	mov    0x4(%eax),%eax
 935:	89 c2                	mov    %eax,%edx
 937:	2b 55 ec             	sub    -0x14(%ebp),%edx
 93a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 940:	8b 45 f4             	mov    -0xc(%ebp),%eax
 943:	8b 40 04             	mov    0x4(%eax),%eax
 946:	c1 e0 03             	shl    $0x3,%eax
 949:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 94c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 952:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 955:	8b 45 f0             	mov    -0x10(%ebp),%eax
 958:	a3 b4 0c 00 00       	mov    %eax,0xcb4
      return (void*)(p + 1);
 95d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 960:	83 c0 08             	add    $0x8,%eax
 963:	eb 38                	jmp    99d <malloc+0xdc>
    }
    if(p == freep)
 965:	a1 b4 0c 00 00       	mov    0xcb4,%eax
 96a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 96d:	75 1b                	jne    98a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 96f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 972:	89 04 24             	mov    %eax,(%esp)
 975:	e8 ef fe ff ff       	call   869 <morecore>
 97a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 97d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 981:	75 07                	jne    98a <malloc+0xc9>
        return 0;
 983:	b8 00 00 00 00       	mov    $0x0,%eax
 988:	eb 13                	jmp    99d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 990:	8b 45 f4             	mov    -0xc(%ebp),%eax
 993:	8b 00                	mov    (%eax),%eax
 995:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 998:	e9 70 ff ff ff       	jmp    90d <malloc+0x4c>
}
 99d:	c9                   	leave  
 99e:	c3                   	ret    
