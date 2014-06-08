
_kill:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
    1009:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    100d:	7f 19                	jg     1028 <main+0x28>
    printf(2, "usage: kill pid...\n");
    100f:	c7 44 24 04 23 18 00 	movl   $0x1823,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    101e:	e8 34 04 00 00       	call   1457 <printf>
    exit();
    1023:	e8 a7 02 00 00       	call   12cf <exit>
  }
  for(i=1; i<argc; i++)
    1028:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    102f:	00 
    1030:	eb 27                	jmp    1059 <main+0x59>
    kill(atoi(argv[i]));
    1032:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1036:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    103d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1040:	01 d0                	add    %edx,%eax
    1042:	8b 00                	mov    (%eax),%eax
    1044:	89 04 24             	mov    %eax,(%esp)
    1047:	e8 f1 01 00 00       	call   123d <atoi>
    104c:	89 04 24             	mov    %eax,(%esp)
    104f:	e8 ab 02 00 00       	call   12ff <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    1054:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    1059:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    105d:	3b 45 08             	cmp    0x8(%ebp),%eax
    1060:	7c d0                	jl     1032 <main+0x32>
    kill(atoi(argv[i]));
  exit();
    1062:	e8 68 02 00 00       	call   12cf <exit>

00001067 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1067:	55                   	push   %ebp
    1068:	89 e5                	mov    %esp,%ebp
    106a:	57                   	push   %edi
    106b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    106c:	8b 4d 08             	mov    0x8(%ebp),%ecx
    106f:	8b 55 10             	mov    0x10(%ebp),%edx
    1072:	8b 45 0c             	mov    0xc(%ebp),%eax
    1075:	89 cb                	mov    %ecx,%ebx
    1077:	89 df                	mov    %ebx,%edi
    1079:	89 d1                	mov    %edx,%ecx
    107b:	fc                   	cld    
    107c:	f3 aa                	rep stos %al,%es:(%edi)
    107e:	89 ca                	mov    %ecx,%edx
    1080:	89 fb                	mov    %edi,%ebx
    1082:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1085:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1088:	5b                   	pop    %ebx
    1089:	5f                   	pop    %edi
    108a:	5d                   	pop    %ebp
    108b:	c3                   	ret    

0000108c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    108c:	55                   	push   %ebp
    108d:	89 e5                	mov    %esp,%ebp
    108f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1092:	8b 45 08             	mov    0x8(%ebp),%eax
    1095:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1098:	90                   	nop
    1099:	8b 45 08             	mov    0x8(%ebp),%eax
    109c:	8d 50 01             	lea    0x1(%eax),%edx
    109f:	89 55 08             	mov    %edx,0x8(%ebp)
    10a2:	8b 55 0c             	mov    0xc(%ebp),%edx
    10a5:	8d 4a 01             	lea    0x1(%edx),%ecx
    10a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10ab:	0f b6 12             	movzbl (%edx),%edx
    10ae:	88 10                	mov    %dl,(%eax)
    10b0:	0f b6 00             	movzbl (%eax),%eax
    10b3:	84 c0                	test   %al,%al
    10b5:	75 e2                	jne    1099 <strcpy+0xd>
    ;
  return os;
    10b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10ba:	c9                   	leave  
    10bb:	c3                   	ret    

000010bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10bc:	55                   	push   %ebp
    10bd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10bf:	eb 08                	jmp    10c9 <strcmp+0xd>
    p++, q++;
    10c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10c9:	8b 45 08             	mov    0x8(%ebp),%eax
    10cc:	0f b6 00             	movzbl (%eax),%eax
    10cf:	84 c0                	test   %al,%al
    10d1:	74 10                	je     10e3 <strcmp+0x27>
    10d3:	8b 45 08             	mov    0x8(%ebp),%eax
    10d6:	0f b6 10             	movzbl (%eax),%edx
    10d9:	8b 45 0c             	mov    0xc(%ebp),%eax
    10dc:	0f b6 00             	movzbl (%eax),%eax
    10df:	38 c2                	cmp    %al,%dl
    10e1:	74 de                	je     10c1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10e3:	8b 45 08             	mov    0x8(%ebp),%eax
    10e6:	0f b6 00             	movzbl (%eax),%eax
    10e9:	0f b6 d0             	movzbl %al,%edx
    10ec:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ef:	0f b6 00             	movzbl (%eax),%eax
    10f2:	0f b6 c0             	movzbl %al,%eax
    10f5:	29 c2                	sub    %eax,%edx
    10f7:	89 d0                	mov    %edx,%eax
}
    10f9:	5d                   	pop    %ebp
    10fa:	c3                   	ret    

000010fb <strlen>:

uint
strlen(char *s)
{
    10fb:	55                   	push   %ebp
    10fc:	89 e5                	mov    %esp,%ebp
    10fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1108:	eb 04                	jmp    110e <strlen+0x13>
    110a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    110e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1111:	8b 45 08             	mov    0x8(%ebp),%eax
    1114:	01 d0                	add    %edx,%eax
    1116:	0f b6 00             	movzbl (%eax),%eax
    1119:	84 c0                	test   %al,%al
    111b:	75 ed                	jne    110a <strlen+0xf>
    ;
  return n;
    111d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1120:	c9                   	leave  
    1121:	c3                   	ret    

00001122 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1122:	55                   	push   %ebp
    1123:	89 e5                	mov    %esp,%ebp
    1125:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1128:	8b 45 10             	mov    0x10(%ebp),%eax
    112b:	89 44 24 08          	mov    %eax,0x8(%esp)
    112f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1132:	89 44 24 04          	mov    %eax,0x4(%esp)
    1136:	8b 45 08             	mov    0x8(%ebp),%eax
    1139:	89 04 24             	mov    %eax,(%esp)
    113c:	e8 26 ff ff ff       	call   1067 <stosb>
  return dst;
    1141:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1144:	c9                   	leave  
    1145:	c3                   	ret    

00001146 <strchr>:

char*
strchr(const char *s, char c)
{
    1146:	55                   	push   %ebp
    1147:	89 e5                	mov    %esp,%ebp
    1149:	83 ec 04             	sub    $0x4,%esp
    114c:	8b 45 0c             	mov    0xc(%ebp),%eax
    114f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1152:	eb 14                	jmp    1168 <strchr+0x22>
    if(*s == c)
    1154:	8b 45 08             	mov    0x8(%ebp),%eax
    1157:	0f b6 00             	movzbl (%eax),%eax
    115a:	3a 45 fc             	cmp    -0x4(%ebp),%al
    115d:	75 05                	jne    1164 <strchr+0x1e>
      return (char*)s;
    115f:	8b 45 08             	mov    0x8(%ebp),%eax
    1162:	eb 13                	jmp    1177 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1164:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1168:	8b 45 08             	mov    0x8(%ebp),%eax
    116b:	0f b6 00             	movzbl (%eax),%eax
    116e:	84 c0                	test   %al,%al
    1170:	75 e2                	jne    1154 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1172:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1177:	c9                   	leave  
    1178:	c3                   	ret    

00001179 <gets>:

char*
gets(char *buf, int max)
{
    1179:	55                   	push   %ebp
    117a:	89 e5                	mov    %esp,%ebp
    117c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    117f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1186:	eb 4c                	jmp    11d4 <gets+0x5b>
    cc = read(0, &c, 1);
    1188:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    118f:	00 
    1190:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1193:	89 44 24 04          	mov    %eax,0x4(%esp)
    1197:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    119e:	e8 44 01 00 00       	call   12e7 <read>
    11a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11aa:	7f 02                	jg     11ae <gets+0x35>
      break;
    11ac:	eb 31                	jmp    11df <gets+0x66>
    buf[i++] = c;
    11ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11b1:	8d 50 01             	lea    0x1(%eax),%edx
    11b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11b7:	89 c2                	mov    %eax,%edx
    11b9:	8b 45 08             	mov    0x8(%ebp),%eax
    11bc:	01 c2                	add    %eax,%edx
    11be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11c2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11c8:	3c 0a                	cmp    $0xa,%al
    11ca:	74 13                	je     11df <gets+0x66>
    11cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11d0:	3c 0d                	cmp    $0xd,%al
    11d2:	74 0b                	je     11df <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11d7:	83 c0 01             	add    $0x1,%eax
    11da:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11dd:	7c a9                	jl     1188 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11df:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11e2:	8b 45 08             	mov    0x8(%ebp),%eax
    11e5:	01 d0                	add    %edx,%eax
    11e7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ed:	c9                   	leave  
    11ee:	c3                   	ret    

000011ef <stat>:

int
stat(char *n, struct stat *st)
{
    11ef:	55                   	push   %ebp
    11f0:	89 e5                	mov    %esp,%ebp
    11f2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11fc:	00 
    11fd:	8b 45 08             	mov    0x8(%ebp),%eax
    1200:	89 04 24             	mov    %eax,(%esp)
    1203:	e8 07 01 00 00       	call   130f <open>
    1208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    120b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    120f:	79 07                	jns    1218 <stat+0x29>
    return -1;
    1211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1216:	eb 23                	jmp    123b <stat+0x4c>
  r = fstat(fd, st);
    1218:	8b 45 0c             	mov    0xc(%ebp),%eax
    121b:	89 44 24 04          	mov    %eax,0x4(%esp)
    121f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1222:	89 04 24             	mov    %eax,(%esp)
    1225:	e8 fd 00 00 00       	call   1327 <fstat>
    122a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    122d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1230:	89 04 24             	mov    %eax,(%esp)
    1233:	e8 bf 00 00 00       	call   12f7 <close>
  return r;
    1238:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    123b:	c9                   	leave  
    123c:	c3                   	ret    

0000123d <atoi>:

int
atoi(const char *s)
{
    123d:	55                   	push   %ebp
    123e:	89 e5                	mov    %esp,%ebp
    1240:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    124a:	eb 25                	jmp    1271 <atoi+0x34>
    n = n*10 + *s++ - '0';
    124c:	8b 55 fc             	mov    -0x4(%ebp),%edx
    124f:	89 d0                	mov    %edx,%eax
    1251:	c1 e0 02             	shl    $0x2,%eax
    1254:	01 d0                	add    %edx,%eax
    1256:	01 c0                	add    %eax,%eax
    1258:	89 c1                	mov    %eax,%ecx
    125a:	8b 45 08             	mov    0x8(%ebp),%eax
    125d:	8d 50 01             	lea    0x1(%eax),%edx
    1260:	89 55 08             	mov    %edx,0x8(%ebp)
    1263:	0f b6 00             	movzbl (%eax),%eax
    1266:	0f be c0             	movsbl %al,%eax
    1269:	01 c8                	add    %ecx,%eax
    126b:	83 e8 30             	sub    $0x30,%eax
    126e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1271:	8b 45 08             	mov    0x8(%ebp),%eax
    1274:	0f b6 00             	movzbl (%eax),%eax
    1277:	3c 2f                	cmp    $0x2f,%al
    1279:	7e 0a                	jle    1285 <atoi+0x48>
    127b:	8b 45 08             	mov    0x8(%ebp),%eax
    127e:	0f b6 00             	movzbl (%eax),%eax
    1281:	3c 39                	cmp    $0x39,%al
    1283:	7e c7                	jle    124c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1285:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1288:	c9                   	leave  
    1289:	c3                   	ret    

0000128a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    128a:	55                   	push   %ebp
    128b:	89 e5                	mov    %esp,%ebp
    128d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1290:	8b 45 08             	mov    0x8(%ebp),%eax
    1293:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1296:	8b 45 0c             	mov    0xc(%ebp),%eax
    1299:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    129c:	eb 17                	jmp    12b5 <memmove+0x2b>
    *dst++ = *src++;
    129e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12a1:	8d 50 01             	lea    0x1(%eax),%edx
    12a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12aa:	8d 4a 01             	lea    0x1(%edx),%ecx
    12ad:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12b0:	0f b6 12             	movzbl (%edx),%edx
    12b3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12b5:	8b 45 10             	mov    0x10(%ebp),%eax
    12b8:	8d 50 ff             	lea    -0x1(%eax),%edx
    12bb:	89 55 10             	mov    %edx,0x10(%ebp)
    12be:	85 c0                	test   %eax,%eax
    12c0:	7f dc                	jg     129e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12c5:	c9                   	leave  
    12c6:	c3                   	ret    

000012c7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12c7:	b8 01 00 00 00       	mov    $0x1,%eax
    12cc:	cd 40                	int    $0x40
    12ce:	c3                   	ret    

000012cf <exit>:
SYSCALL(exit)
    12cf:	b8 02 00 00 00       	mov    $0x2,%eax
    12d4:	cd 40                	int    $0x40
    12d6:	c3                   	ret    

000012d7 <wait>:
SYSCALL(wait)
    12d7:	b8 03 00 00 00       	mov    $0x3,%eax
    12dc:	cd 40                	int    $0x40
    12de:	c3                   	ret    

000012df <pipe>:
SYSCALL(pipe)
    12df:	b8 04 00 00 00       	mov    $0x4,%eax
    12e4:	cd 40                	int    $0x40
    12e6:	c3                   	ret    

000012e7 <read>:
SYSCALL(read)
    12e7:	b8 05 00 00 00       	mov    $0x5,%eax
    12ec:	cd 40                	int    $0x40
    12ee:	c3                   	ret    

000012ef <write>:
SYSCALL(write)
    12ef:	b8 10 00 00 00       	mov    $0x10,%eax
    12f4:	cd 40                	int    $0x40
    12f6:	c3                   	ret    

000012f7 <close>:
SYSCALL(close)
    12f7:	b8 15 00 00 00       	mov    $0x15,%eax
    12fc:	cd 40                	int    $0x40
    12fe:	c3                   	ret    

000012ff <kill>:
SYSCALL(kill)
    12ff:	b8 06 00 00 00       	mov    $0x6,%eax
    1304:	cd 40                	int    $0x40
    1306:	c3                   	ret    

00001307 <exec>:
SYSCALL(exec)
    1307:	b8 07 00 00 00       	mov    $0x7,%eax
    130c:	cd 40                	int    $0x40
    130e:	c3                   	ret    

0000130f <open>:
SYSCALL(open)
    130f:	b8 0f 00 00 00       	mov    $0xf,%eax
    1314:	cd 40                	int    $0x40
    1316:	c3                   	ret    

00001317 <mknod>:
SYSCALL(mknod)
    1317:	b8 11 00 00 00       	mov    $0x11,%eax
    131c:	cd 40                	int    $0x40
    131e:	c3                   	ret    

0000131f <unlink>:
SYSCALL(unlink)
    131f:	b8 12 00 00 00       	mov    $0x12,%eax
    1324:	cd 40                	int    $0x40
    1326:	c3                   	ret    

00001327 <fstat>:
SYSCALL(fstat)
    1327:	b8 08 00 00 00       	mov    $0x8,%eax
    132c:	cd 40                	int    $0x40
    132e:	c3                   	ret    

0000132f <link>:
SYSCALL(link)
    132f:	b8 13 00 00 00       	mov    $0x13,%eax
    1334:	cd 40                	int    $0x40
    1336:	c3                   	ret    

00001337 <mkdir>:
SYSCALL(mkdir)
    1337:	b8 14 00 00 00       	mov    $0x14,%eax
    133c:	cd 40                	int    $0x40
    133e:	c3                   	ret    

0000133f <chdir>:
SYSCALL(chdir)
    133f:	b8 09 00 00 00       	mov    $0x9,%eax
    1344:	cd 40                	int    $0x40
    1346:	c3                   	ret    

00001347 <dup>:
SYSCALL(dup)
    1347:	b8 0a 00 00 00       	mov    $0xa,%eax
    134c:	cd 40                	int    $0x40
    134e:	c3                   	ret    

0000134f <getpid>:
SYSCALL(getpid)
    134f:	b8 0b 00 00 00       	mov    $0xb,%eax
    1354:	cd 40                	int    $0x40
    1356:	c3                   	ret    

00001357 <sbrk>:
SYSCALL(sbrk)
    1357:	b8 0c 00 00 00       	mov    $0xc,%eax
    135c:	cd 40                	int    $0x40
    135e:	c3                   	ret    

0000135f <sleep>:
SYSCALL(sleep)
    135f:	b8 0d 00 00 00       	mov    $0xd,%eax
    1364:	cd 40                	int    $0x40
    1366:	c3                   	ret    

00001367 <uptime>:
SYSCALL(uptime)
    1367:	b8 0e 00 00 00       	mov    $0xe,%eax
    136c:	cd 40                	int    $0x40
    136e:	c3                   	ret    

0000136f <cowfork>:
SYSCALL(cowfork) //3.4
    136f:	b8 16 00 00 00       	mov    $0x16,%eax
    1374:	cd 40                	int    $0x40
    1376:	c3                   	ret    

00001377 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1377:	55                   	push   %ebp
    1378:	89 e5                	mov    %esp,%ebp
    137a:	83 ec 18             	sub    $0x18,%esp
    137d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1380:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1383:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    138a:	00 
    138b:	8d 45 f4             	lea    -0xc(%ebp),%eax
    138e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1392:	8b 45 08             	mov    0x8(%ebp),%eax
    1395:	89 04 24             	mov    %eax,(%esp)
    1398:	e8 52 ff ff ff       	call   12ef <write>
}
    139d:	c9                   	leave  
    139e:	c3                   	ret    

0000139f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    139f:	55                   	push   %ebp
    13a0:	89 e5                	mov    %esp,%ebp
    13a2:	56                   	push   %esi
    13a3:	53                   	push   %ebx
    13a4:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13ae:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13b2:	74 17                	je     13cb <printint+0x2c>
    13b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13b8:	79 11                	jns    13cb <printint+0x2c>
    neg = 1;
    13ba:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13c1:	8b 45 0c             	mov    0xc(%ebp),%eax
    13c4:	f7 d8                	neg    %eax
    13c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13c9:	eb 06                	jmp    13d1 <printint+0x32>
  } else {
    x = xx;
    13cb:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13d8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13db:	8d 41 01             	lea    0x1(%ecx),%eax
    13de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13e7:	ba 00 00 00 00       	mov    $0x0,%edx
    13ec:	f7 f3                	div    %ebx
    13ee:	89 d0                	mov    %edx,%eax
    13f0:	0f b6 80 84 2a 00 00 	movzbl 0x2a84(%eax),%eax
    13f7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    13fb:	8b 75 10             	mov    0x10(%ebp),%esi
    13fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1401:	ba 00 00 00 00       	mov    $0x0,%edx
    1406:	f7 f6                	div    %esi
    1408:	89 45 ec             	mov    %eax,-0x14(%ebp)
    140b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    140f:	75 c7                	jne    13d8 <printint+0x39>
  if(neg)
    1411:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1415:	74 10                	je     1427 <printint+0x88>
    buf[i++] = '-';
    1417:	8b 45 f4             	mov    -0xc(%ebp),%eax
    141a:	8d 50 01             	lea    0x1(%eax),%edx
    141d:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1420:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1425:	eb 1f                	jmp    1446 <printint+0xa7>
    1427:	eb 1d                	jmp    1446 <printint+0xa7>
    putc(fd, buf[i]);
    1429:	8d 55 dc             	lea    -0x24(%ebp),%edx
    142c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    142f:	01 d0                	add    %edx,%eax
    1431:	0f b6 00             	movzbl (%eax),%eax
    1434:	0f be c0             	movsbl %al,%eax
    1437:	89 44 24 04          	mov    %eax,0x4(%esp)
    143b:	8b 45 08             	mov    0x8(%ebp),%eax
    143e:	89 04 24             	mov    %eax,(%esp)
    1441:	e8 31 ff ff ff       	call   1377 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1446:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    144a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    144e:	79 d9                	jns    1429 <printint+0x8a>
    putc(fd, buf[i]);
}
    1450:	83 c4 30             	add    $0x30,%esp
    1453:	5b                   	pop    %ebx
    1454:	5e                   	pop    %esi
    1455:	5d                   	pop    %ebp
    1456:	c3                   	ret    

00001457 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1457:	55                   	push   %ebp
    1458:	89 e5                	mov    %esp,%ebp
    145a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    145d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1464:	8d 45 0c             	lea    0xc(%ebp),%eax
    1467:	83 c0 04             	add    $0x4,%eax
    146a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    146d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1474:	e9 7c 01 00 00       	jmp    15f5 <printf+0x19e>
    c = fmt[i] & 0xff;
    1479:	8b 55 0c             	mov    0xc(%ebp),%edx
    147c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    147f:	01 d0                	add    %edx,%eax
    1481:	0f b6 00             	movzbl (%eax),%eax
    1484:	0f be c0             	movsbl %al,%eax
    1487:	25 ff 00 00 00       	and    $0xff,%eax
    148c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    148f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1493:	75 2c                	jne    14c1 <printf+0x6a>
      if(c == '%'){
    1495:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1499:	75 0c                	jne    14a7 <printf+0x50>
        state = '%';
    149b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14a2:	e9 4a 01 00 00       	jmp    15f1 <printf+0x19a>
      } else {
        putc(fd, c);
    14a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14aa:	0f be c0             	movsbl %al,%eax
    14ad:	89 44 24 04          	mov    %eax,0x4(%esp)
    14b1:	8b 45 08             	mov    0x8(%ebp),%eax
    14b4:	89 04 24             	mov    %eax,(%esp)
    14b7:	e8 bb fe ff ff       	call   1377 <putc>
    14bc:	e9 30 01 00 00       	jmp    15f1 <printf+0x19a>
      }
    } else if(state == '%'){
    14c1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14c5:	0f 85 26 01 00 00    	jne    15f1 <printf+0x19a>
      if(c == 'd'){
    14cb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14cf:	75 2d                	jne    14fe <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14d4:	8b 00                	mov    (%eax),%eax
    14d6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14dd:	00 
    14de:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14e5:	00 
    14e6:	89 44 24 04          	mov    %eax,0x4(%esp)
    14ea:	8b 45 08             	mov    0x8(%ebp),%eax
    14ed:	89 04 24             	mov    %eax,(%esp)
    14f0:	e8 aa fe ff ff       	call   139f <printint>
        ap++;
    14f5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14f9:	e9 ec 00 00 00       	jmp    15ea <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    14fe:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1502:	74 06                	je     150a <printf+0xb3>
    1504:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1508:	75 2d                	jne    1537 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    150a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    150d:	8b 00                	mov    (%eax),%eax
    150f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1516:	00 
    1517:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    151e:	00 
    151f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1523:	8b 45 08             	mov    0x8(%ebp),%eax
    1526:	89 04 24             	mov    %eax,(%esp)
    1529:	e8 71 fe ff ff       	call   139f <printint>
        ap++;
    152e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1532:	e9 b3 00 00 00       	jmp    15ea <printf+0x193>
      } else if(c == 's'){
    1537:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    153b:	75 45                	jne    1582 <printf+0x12b>
        s = (char*)*ap;
    153d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1540:	8b 00                	mov    (%eax),%eax
    1542:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1545:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    154d:	75 09                	jne    1558 <printf+0x101>
          s = "(null)";
    154f:	c7 45 f4 37 18 00 00 	movl   $0x1837,-0xc(%ebp)
        while(*s != 0){
    1556:	eb 1e                	jmp    1576 <printf+0x11f>
    1558:	eb 1c                	jmp    1576 <printf+0x11f>
          putc(fd, *s);
    155a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155d:	0f b6 00             	movzbl (%eax),%eax
    1560:	0f be c0             	movsbl %al,%eax
    1563:	89 44 24 04          	mov    %eax,0x4(%esp)
    1567:	8b 45 08             	mov    0x8(%ebp),%eax
    156a:	89 04 24             	mov    %eax,(%esp)
    156d:	e8 05 fe ff ff       	call   1377 <putc>
          s++;
    1572:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1576:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1579:	0f b6 00             	movzbl (%eax),%eax
    157c:	84 c0                	test   %al,%al
    157e:	75 da                	jne    155a <printf+0x103>
    1580:	eb 68                	jmp    15ea <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1582:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1586:	75 1d                	jne    15a5 <printf+0x14e>
        putc(fd, *ap);
    1588:	8b 45 e8             	mov    -0x18(%ebp),%eax
    158b:	8b 00                	mov    (%eax),%eax
    158d:	0f be c0             	movsbl %al,%eax
    1590:	89 44 24 04          	mov    %eax,0x4(%esp)
    1594:	8b 45 08             	mov    0x8(%ebp),%eax
    1597:	89 04 24             	mov    %eax,(%esp)
    159a:	e8 d8 fd ff ff       	call   1377 <putc>
        ap++;
    159f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15a3:	eb 45                	jmp    15ea <printf+0x193>
      } else if(c == '%'){
    15a5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15a9:	75 17                	jne    15c2 <printf+0x16b>
        putc(fd, c);
    15ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15ae:	0f be c0             	movsbl %al,%eax
    15b1:	89 44 24 04          	mov    %eax,0x4(%esp)
    15b5:	8b 45 08             	mov    0x8(%ebp),%eax
    15b8:	89 04 24             	mov    %eax,(%esp)
    15bb:	e8 b7 fd ff ff       	call   1377 <putc>
    15c0:	eb 28                	jmp    15ea <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15c2:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15c9:	00 
    15ca:	8b 45 08             	mov    0x8(%ebp),%eax
    15cd:	89 04 24             	mov    %eax,(%esp)
    15d0:	e8 a2 fd ff ff       	call   1377 <putc>
        putc(fd, c);
    15d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15d8:	0f be c0             	movsbl %al,%eax
    15db:	89 44 24 04          	mov    %eax,0x4(%esp)
    15df:	8b 45 08             	mov    0x8(%ebp),%eax
    15e2:	89 04 24             	mov    %eax,(%esp)
    15e5:	e8 8d fd ff ff       	call   1377 <putc>
      }
      state = 0;
    15ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15f1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15f5:	8b 55 0c             	mov    0xc(%ebp),%edx
    15f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15fb:	01 d0                	add    %edx,%eax
    15fd:	0f b6 00             	movzbl (%eax),%eax
    1600:	84 c0                	test   %al,%al
    1602:	0f 85 71 fe ff ff    	jne    1479 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1608:	c9                   	leave  
    1609:	c3                   	ret    

0000160a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    160a:	55                   	push   %ebp
    160b:	89 e5                	mov    %esp,%ebp
    160d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1610:	8b 45 08             	mov    0x8(%ebp),%eax
    1613:	83 e8 08             	sub    $0x8,%eax
    1616:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1619:	a1 a0 2a 00 00       	mov    0x2aa0,%eax
    161e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1621:	eb 24                	jmp    1647 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1623:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1626:	8b 00                	mov    (%eax),%eax
    1628:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    162b:	77 12                	ja     163f <free+0x35>
    162d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1630:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1633:	77 24                	ja     1659 <free+0x4f>
    1635:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1638:	8b 00                	mov    (%eax),%eax
    163a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    163d:	77 1a                	ja     1659 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    163f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1642:	8b 00                	mov    (%eax),%eax
    1644:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1647:	8b 45 f8             	mov    -0x8(%ebp),%eax
    164a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    164d:	76 d4                	jbe    1623 <free+0x19>
    164f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1652:	8b 00                	mov    (%eax),%eax
    1654:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1657:	76 ca                	jbe    1623 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1659:	8b 45 f8             	mov    -0x8(%ebp),%eax
    165c:	8b 40 04             	mov    0x4(%eax),%eax
    165f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1666:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1669:	01 c2                	add    %eax,%edx
    166b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166e:	8b 00                	mov    (%eax),%eax
    1670:	39 c2                	cmp    %eax,%edx
    1672:	75 24                	jne    1698 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1674:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1677:	8b 50 04             	mov    0x4(%eax),%edx
    167a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167d:	8b 00                	mov    (%eax),%eax
    167f:	8b 40 04             	mov    0x4(%eax),%eax
    1682:	01 c2                	add    %eax,%edx
    1684:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1687:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    168a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    168d:	8b 00                	mov    (%eax),%eax
    168f:	8b 10                	mov    (%eax),%edx
    1691:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1694:	89 10                	mov    %edx,(%eax)
    1696:	eb 0a                	jmp    16a2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1698:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169b:	8b 10                	mov    (%eax),%edx
    169d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a5:	8b 40 04             	mov    0x4(%eax),%eax
    16a8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16af:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b2:	01 d0                	add    %edx,%eax
    16b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16b7:	75 20                	jne    16d9 <free+0xcf>
    p->s.size += bp->s.size;
    16b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16bc:	8b 50 04             	mov    0x4(%eax),%edx
    16bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c2:	8b 40 04             	mov    0x4(%eax),%eax
    16c5:	01 c2                	add    %eax,%edx
    16c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ca:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d0:	8b 10                	mov    (%eax),%edx
    16d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d5:	89 10                	mov    %edx,(%eax)
    16d7:	eb 08                	jmp    16e1 <free+0xd7>
  } else
    p->s.ptr = bp;
    16d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16dc:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16df:	89 10                	mov    %edx,(%eax)
  freep = p;
    16e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e4:	a3 a0 2a 00 00       	mov    %eax,0x2aa0
}
    16e9:	c9                   	leave  
    16ea:	c3                   	ret    

000016eb <morecore>:

static Header*
morecore(uint nu)
{
    16eb:	55                   	push   %ebp
    16ec:	89 e5                	mov    %esp,%ebp
    16ee:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16f1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16f8:	77 07                	ja     1701 <morecore+0x16>
    nu = 4096;
    16fa:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1701:	8b 45 08             	mov    0x8(%ebp),%eax
    1704:	c1 e0 03             	shl    $0x3,%eax
    1707:	89 04 24             	mov    %eax,(%esp)
    170a:	e8 48 fc ff ff       	call   1357 <sbrk>
    170f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1712:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1716:	75 07                	jne    171f <morecore+0x34>
    return 0;
    1718:	b8 00 00 00 00       	mov    $0x0,%eax
    171d:	eb 22                	jmp    1741 <morecore+0x56>
  hp = (Header*)p;
    171f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1722:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1725:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1728:	8b 55 08             	mov    0x8(%ebp),%edx
    172b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    172e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1731:	83 c0 08             	add    $0x8,%eax
    1734:	89 04 24             	mov    %eax,(%esp)
    1737:	e8 ce fe ff ff       	call   160a <free>
  return freep;
    173c:	a1 a0 2a 00 00       	mov    0x2aa0,%eax
}
    1741:	c9                   	leave  
    1742:	c3                   	ret    

00001743 <malloc>:

void*
malloc(uint nbytes)
{
    1743:	55                   	push   %ebp
    1744:	89 e5                	mov    %esp,%ebp
    1746:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1749:	8b 45 08             	mov    0x8(%ebp),%eax
    174c:	83 c0 07             	add    $0x7,%eax
    174f:	c1 e8 03             	shr    $0x3,%eax
    1752:	83 c0 01             	add    $0x1,%eax
    1755:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1758:	a1 a0 2a 00 00       	mov    0x2aa0,%eax
    175d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1760:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1764:	75 23                	jne    1789 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1766:	c7 45 f0 98 2a 00 00 	movl   $0x2a98,-0x10(%ebp)
    176d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1770:	a3 a0 2a 00 00       	mov    %eax,0x2aa0
    1775:	a1 a0 2a 00 00       	mov    0x2aa0,%eax
    177a:	a3 98 2a 00 00       	mov    %eax,0x2a98
    base.s.size = 0;
    177f:	c7 05 9c 2a 00 00 00 	movl   $0x0,0x2a9c
    1786:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1789:	8b 45 f0             	mov    -0x10(%ebp),%eax
    178c:	8b 00                	mov    (%eax),%eax
    178e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1791:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1794:	8b 40 04             	mov    0x4(%eax),%eax
    1797:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    179a:	72 4d                	jb     17e9 <malloc+0xa6>
      if(p->s.size == nunits)
    179c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    179f:	8b 40 04             	mov    0x4(%eax),%eax
    17a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17a5:	75 0c                	jne    17b3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17aa:	8b 10                	mov    (%eax),%edx
    17ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17af:	89 10                	mov    %edx,(%eax)
    17b1:	eb 26                	jmp    17d9 <malloc+0x96>
      else {
        p->s.size -= nunits;
    17b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b6:	8b 40 04             	mov    0x4(%eax),%eax
    17b9:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17bc:	89 c2                	mov    %eax,%edx
    17be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c7:	8b 40 04             	mov    0x4(%eax),%eax
    17ca:	c1 e0 03             	shl    $0x3,%eax
    17cd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17d6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17dc:	a3 a0 2a 00 00       	mov    %eax,0x2aa0
      return (void*)(p + 1);
    17e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e4:	83 c0 08             	add    $0x8,%eax
    17e7:	eb 38                	jmp    1821 <malloc+0xde>
    }
    if(p == freep)
    17e9:	a1 a0 2a 00 00       	mov    0x2aa0,%eax
    17ee:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17f1:	75 1b                	jne    180e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    17f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17f6:	89 04 24             	mov    %eax,(%esp)
    17f9:	e8 ed fe ff ff       	call   16eb <morecore>
    17fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1801:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1805:	75 07                	jne    180e <malloc+0xcb>
        return 0;
    1807:	b8 00 00 00 00       	mov    $0x0,%eax
    180c:	eb 13                	jmp    1821 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1811:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1814:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1817:	8b 00                	mov    (%eax),%eax
    1819:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    181c:	e9 70 ff ff ff       	jmp    1791 <malloc+0x4e>
}
    1821:	c9                   	leave  
    1822:	c3                   	ret    
