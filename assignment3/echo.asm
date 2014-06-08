
_echo:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
    1009:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    1010:	00 
    1011:	eb 4b                	jmp    105e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
    1013:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1017:	83 c0 01             	add    $0x1,%eax
    101a:	3b 45 08             	cmp    0x8(%ebp),%eax
    101d:	7d 07                	jge    1026 <main+0x26>
    101f:	b8 28 18 00 00       	mov    $0x1828,%eax
    1024:	eb 05                	jmp    102b <main+0x2b>
    1026:	b8 2a 18 00 00       	mov    $0x182a,%eax
    102b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    102f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
    1036:	8b 55 0c             	mov    0xc(%ebp),%edx
    1039:	01 ca                	add    %ecx,%edx
    103b:	8b 12                	mov    (%edx),%edx
    103d:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1041:	89 54 24 08          	mov    %edx,0x8(%esp)
    1045:	c7 44 24 04 2c 18 00 	movl   $0x182c,0x4(%esp)
    104c:	00 
    104d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1054:	e8 03 04 00 00       	call   145c <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
    1059:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    105e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1062:	3b 45 08             	cmp    0x8(%ebp),%eax
    1065:	7c ac                	jl     1013 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
    1067:	e8 68 02 00 00       	call   12d4 <exit>

0000106c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    106c:	55                   	push   %ebp
    106d:	89 e5                	mov    %esp,%ebp
    106f:	57                   	push   %edi
    1070:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1071:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1074:	8b 55 10             	mov    0x10(%ebp),%edx
    1077:	8b 45 0c             	mov    0xc(%ebp),%eax
    107a:	89 cb                	mov    %ecx,%ebx
    107c:	89 df                	mov    %ebx,%edi
    107e:	89 d1                	mov    %edx,%ecx
    1080:	fc                   	cld    
    1081:	f3 aa                	rep stos %al,%es:(%edi)
    1083:	89 ca                	mov    %ecx,%edx
    1085:	89 fb                	mov    %edi,%ebx
    1087:	89 5d 08             	mov    %ebx,0x8(%ebp)
    108a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    108d:	5b                   	pop    %ebx
    108e:	5f                   	pop    %edi
    108f:	5d                   	pop    %ebp
    1090:	c3                   	ret    

00001091 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1091:	55                   	push   %ebp
    1092:	89 e5                	mov    %esp,%ebp
    1094:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1097:	8b 45 08             	mov    0x8(%ebp),%eax
    109a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    109d:	90                   	nop
    109e:	8b 45 08             	mov    0x8(%ebp),%eax
    10a1:	8d 50 01             	lea    0x1(%eax),%edx
    10a4:	89 55 08             	mov    %edx,0x8(%ebp)
    10a7:	8b 55 0c             	mov    0xc(%ebp),%edx
    10aa:	8d 4a 01             	lea    0x1(%edx),%ecx
    10ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10b0:	0f b6 12             	movzbl (%edx),%edx
    10b3:	88 10                	mov    %dl,(%eax)
    10b5:	0f b6 00             	movzbl (%eax),%eax
    10b8:	84 c0                	test   %al,%al
    10ba:	75 e2                	jne    109e <strcpy+0xd>
    ;
  return os;
    10bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10bf:	c9                   	leave  
    10c0:	c3                   	ret    

000010c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10c1:	55                   	push   %ebp
    10c2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10c4:	eb 08                	jmp    10ce <strcmp+0xd>
    p++, q++;
    10c6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10ca:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10ce:	8b 45 08             	mov    0x8(%ebp),%eax
    10d1:	0f b6 00             	movzbl (%eax),%eax
    10d4:	84 c0                	test   %al,%al
    10d6:	74 10                	je     10e8 <strcmp+0x27>
    10d8:	8b 45 08             	mov    0x8(%ebp),%eax
    10db:	0f b6 10             	movzbl (%eax),%edx
    10de:	8b 45 0c             	mov    0xc(%ebp),%eax
    10e1:	0f b6 00             	movzbl (%eax),%eax
    10e4:	38 c2                	cmp    %al,%dl
    10e6:	74 de                	je     10c6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10e8:	8b 45 08             	mov    0x8(%ebp),%eax
    10eb:	0f b6 00             	movzbl (%eax),%eax
    10ee:	0f b6 d0             	movzbl %al,%edx
    10f1:	8b 45 0c             	mov    0xc(%ebp),%eax
    10f4:	0f b6 00             	movzbl (%eax),%eax
    10f7:	0f b6 c0             	movzbl %al,%eax
    10fa:	29 c2                	sub    %eax,%edx
    10fc:	89 d0                	mov    %edx,%eax
}
    10fe:	5d                   	pop    %ebp
    10ff:	c3                   	ret    

00001100 <strlen>:

uint
strlen(char *s)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1106:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    110d:	eb 04                	jmp    1113 <strlen+0x13>
    110f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1113:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1116:	8b 45 08             	mov    0x8(%ebp),%eax
    1119:	01 d0                	add    %edx,%eax
    111b:	0f b6 00             	movzbl (%eax),%eax
    111e:	84 c0                	test   %al,%al
    1120:	75 ed                	jne    110f <strlen+0xf>
    ;
  return n;
    1122:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1125:	c9                   	leave  
    1126:	c3                   	ret    

00001127 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1127:	55                   	push   %ebp
    1128:	89 e5                	mov    %esp,%ebp
    112a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    112d:	8b 45 10             	mov    0x10(%ebp),%eax
    1130:	89 44 24 08          	mov    %eax,0x8(%esp)
    1134:	8b 45 0c             	mov    0xc(%ebp),%eax
    1137:	89 44 24 04          	mov    %eax,0x4(%esp)
    113b:	8b 45 08             	mov    0x8(%ebp),%eax
    113e:	89 04 24             	mov    %eax,(%esp)
    1141:	e8 26 ff ff ff       	call   106c <stosb>
  return dst;
    1146:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1149:	c9                   	leave  
    114a:	c3                   	ret    

0000114b <strchr>:

char*
strchr(const char *s, char c)
{
    114b:	55                   	push   %ebp
    114c:	89 e5                	mov    %esp,%ebp
    114e:	83 ec 04             	sub    $0x4,%esp
    1151:	8b 45 0c             	mov    0xc(%ebp),%eax
    1154:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1157:	eb 14                	jmp    116d <strchr+0x22>
    if(*s == c)
    1159:	8b 45 08             	mov    0x8(%ebp),%eax
    115c:	0f b6 00             	movzbl (%eax),%eax
    115f:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1162:	75 05                	jne    1169 <strchr+0x1e>
      return (char*)s;
    1164:	8b 45 08             	mov    0x8(%ebp),%eax
    1167:	eb 13                	jmp    117c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    116d:	8b 45 08             	mov    0x8(%ebp),%eax
    1170:	0f b6 00             	movzbl (%eax),%eax
    1173:	84 c0                	test   %al,%al
    1175:	75 e2                	jne    1159 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1177:	b8 00 00 00 00       	mov    $0x0,%eax
}
    117c:	c9                   	leave  
    117d:	c3                   	ret    

0000117e <gets>:

char*
gets(char *buf, int max)
{
    117e:	55                   	push   %ebp
    117f:	89 e5                	mov    %esp,%ebp
    1181:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1184:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    118b:	eb 4c                	jmp    11d9 <gets+0x5b>
    cc = read(0, &c, 1);
    118d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1194:	00 
    1195:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1198:	89 44 24 04          	mov    %eax,0x4(%esp)
    119c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11a3:	e8 44 01 00 00       	call   12ec <read>
    11a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11af:	7f 02                	jg     11b3 <gets+0x35>
      break;
    11b1:	eb 31                	jmp    11e4 <gets+0x66>
    buf[i++] = c;
    11b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11b6:	8d 50 01             	lea    0x1(%eax),%edx
    11b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11bc:	89 c2                	mov    %eax,%edx
    11be:	8b 45 08             	mov    0x8(%ebp),%eax
    11c1:	01 c2                	add    %eax,%edx
    11c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11c7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11cd:	3c 0a                	cmp    $0xa,%al
    11cf:	74 13                	je     11e4 <gets+0x66>
    11d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11d5:	3c 0d                	cmp    $0xd,%al
    11d7:	74 0b                	je     11e4 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11dc:	83 c0 01             	add    $0x1,%eax
    11df:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11e2:	7c a9                	jl     118d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11e7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ea:	01 d0                	add    %edx,%eax
    11ec:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11f2:	c9                   	leave  
    11f3:	c3                   	ret    

000011f4 <stat>:

int
stat(char *n, struct stat *st)
{
    11f4:	55                   	push   %ebp
    11f5:	89 e5                	mov    %esp,%ebp
    11f7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1201:	00 
    1202:	8b 45 08             	mov    0x8(%ebp),%eax
    1205:	89 04 24             	mov    %eax,(%esp)
    1208:	e8 07 01 00 00       	call   1314 <open>
    120d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1214:	79 07                	jns    121d <stat+0x29>
    return -1;
    1216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    121b:	eb 23                	jmp    1240 <stat+0x4c>
  r = fstat(fd, st);
    121d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1220:	89 44 24 04          	mov    %eax,0x4(%esp)
    1224:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1227:	89 04 24             	mov    %eax,(%esp)
    122a:	e8 fd 00 00 00       	call   132c <fstat>
    122f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1232:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1235:	89 04 24             	mov    %eax,(%esp)
    1238:	e8 bf 00 00 00       	call   12fc <close>
  return r;
    123d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1240:	c9                   	leave  
    1241:	c3                   	ret    

00001242 <atoi>:

int
atoi(const char *s)
{
    1242:	55                   	push   %ebp
    1243:	89 e5                	mov    %esp,%ebp
    1245:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    124f:	eb 25                	jmp    1276 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1251:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1254:	89 d0                	mov    %edx,%eax
    1256:	c1 e0 02             	shl    $0x2,%eax
    1259:	01 d0                	add    %edx,%eax
    125b:	01 c0                	add    %eax,%eax
    125d:	89 c1                	mov    %eax,%ecx
    125f:	8b 45 08             	mov    0x8(%ebp),%eax
    1262:	8d 50 01             	lea    0x1(%eax),%edx
    1265:	89 55 08             	mov    %edx,0x8(%ebp)
    1268:	0f b6 00             	movzbl (%eax),%eax
    126b:	0f be c0             	movsbl %al,%eax
    126e:	01 c8                	add    %ecx,%eax
    1270:	83 e8 30             	sub    $0x30,%eax
    1273:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1276:	8b 45 08             	mov    0x8(%ebp),%eax
    1279:	0f b6 00             	movzbl (%eax),%eax
    127c:	3c 2f                	cmp    $0x2f,%al
    127e:	7e 0a                	jle    128a <atoi+0x48>
    1280:	8b 45 08             	mov    0x8(%ebp),%eax
    1283:	0f b6 00             	movzbl (%eax),%eax
    1286:	3c 39                	cmp    $0x39,%al
    1288:	7e c7                	jle    1251 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    128a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    128d:	c9                   	leave  
    128e:	c3                   	ret    

0000128f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    128f:	55                   	push   %ebp
    1290:	89 e5                	mov    %esp,%ebp
    1292:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1295:	8b 45 08             	mov    0x8(%ebp),%eax
    1298:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    129b:	8b 45 0c             	mov    0xc(%ebp),%eax
    129e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12a1:	eb 17                	jmp    12ba <memmove+0x2b>
    *dst++ = *src++;
    12a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12a6:	8d 50 01             	lea    0x1(%eax),%edx
    12a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12af:	8d 4a 01             	lea    0x1(%edx),%ecx
    12b2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12b5:	0f b6 12             	movzbl (%edx),%edx
    12b8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12ba:	8b 45 10             	mov    0x10(%ebp),%eax
    12bd:	8d 50 ff             	lea    -0x1(%eax),%edx
    12c0:	89 55 10             	mov    %edx,0x10(%ebp)
    12c3:	85 c0                	test   %eax,%eax
    12c5:	7f dc                	jg     12a3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12ca:	c9                   	leave  
    12cb:	c3                   	ret    

000012cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12cc:	b8 01 00 00 00       	mov    $0x1,%eax
    12d1:	cd 40                	int    $0x40
    12d3:	c3                   	ret    

000012d4 <exit>:
SYSCALL(exit)
    12d4:	b8 02 00 00 00       	mov    $0x2,%eax
    12d9:	cd 40                	int    $0x40
    12db:	c3                   	ret    

000012dc <wait>:
SYSCALL(wait)
    12dc:	b8 03 00 00 00       	mov    $0x3,%eax
    12e1:	cd 40                	int    $0x40
    12e3:	c3                   	ret    

000012e4 <pipe>:
SYSCALL(pipe)
    12e4:	b8 04 00 00 00       	mov    $0x4,%eax
    12e9:	cd 40                	int    $0x40
    12eb:	c3                   	ret    

000012ec <read>:
SYSCALL(read)
    12ec:	b8 05 00 00 00       	mov    $0x5,%eax
    12f1:	cd 40                	int    $0x40
    12f3:	c3                   	ret    

000012f4 <write>:
SYSCALL(write)
    12f4:	b8 10 00 00 00       	mov    $0x10,%eax
    12f9:	cd 40                	int    $0x40
    12fb:	c3                   	ret    

000012fc <close>:
SYSCALL(close)
    12fc:	b8 15 00 00 00       	mov    $0x15,%eax
    1301:	cd 40                	int    $0x40
    1303:	c3                   	ret    

00001304 <kill>:
SYSCALL(kill)
    1304:	b8 06 00 00 00       	mov    $0x6,%eax
    1309:	cd 40                	int    $0x40
    130b:	c3                   	ret    

0000130c <exec>:
SYSCALL(exec)
    130c:	b8 07 00 00 00       	mov    $0x7,%eax
    1311:	cd 40                	int    $0x40
    1313:	c3                   	ret    

00001314 <open>:
SYSCALL(open)
    1314:	b8 0f 00 00 00       	mov    $0xf,%eax
    1319:	cd 40                	int    $0x40
    131b:	c3                   	ret    

0000131c <mknod>:
SYSCALL(mknod)
    131c:	b8 11 00 00 00       	mov    $0x11,%eax
    1321:	cd 40                	int    $0x40
    1323:	c3                   	ret    

00001324 <unlink>:
SYSCALL(unlink)
    1324:	b8 12 00 00 00       	mov    $0x12,%eax
    1329:	cd 40                	int    $0x40
    132b:	c3                   	ret    

0000132c <fstat>:
SYSCALL(fstat)
    132c:	b8 08 00 00 00       	mov    $0x8,%eax
    1331:	cd 40                	int    $0x40
    1333:	c3                   	ret    

00001334 <link>:
SYSCALL(link)
    1334:	b8 13 00 00 00       	mov    $0x13,%eax
    1339:	cd 40                	int    $0x40
    133b:	c3                   	ret    

0000133c <mkdir>:
SYSCALL(mkdir)
    133c:	b8 14 00 00 00       	mov    $0x14,%eax
    1341:	cd 40                	int    $0x40
    1343:	c3                   	ret    

00001344 <chdir>:
SYSCALL(chdir)
    1344:	b8 09 00 00 00       	mov    $0x9,%eax
    1349:	cd 40                	int    $0x40
    134b:	c3                   	ret    

0000134c <dup>:
SYSCALL(dup)
    134c:	b8 0a 00 00 00       	mov    $0xa,%eax
    1351:	cd 40                	int    $0x40
    1353:	c3                   	ret    

00001354 <getpid>:
SYSCALL(getpid)
    1354:	b8 0b 00 00 00       	mov    $0xb,%eax
    1359:	cd 40                	int    $0x40
    135b:	c3                   	ret    

0000135c <sbrk>:
SYSCALL(sbrk)
    135c:	b8 0c 00 00 00       	mov    $0xc,%eax
    1361:	cd 40                	int    $0x40
    1363:	c3                   	ret    

00001364 <sleep>:
SYSCALL(sleep)
    1364:	b8 0d 00 00 00       	mov    $0xd,%eax
    1369:	cd 40                	int    $0x40
    136b:	c3                   	ret    

0000136c <uptime>:
SYSCALL(uptime)
    136c:	b8 0e 00 00 00       	mov    $0xe,%eax
    1371:	cd 40                	int    $0x40
    1373:	c3                   	ret    

00001374 <cowfork>:
SYSCALL(cowfork) //3.4
    1374:	b8 16 00 00 00       	mov    $0x16,%eax
    1379:	cd 40                	int    $0x40
    137b:	c3                   	ret    

0000137c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    137c:	55                   	push   %ebp
    137d:	89 e5                	mov    %esp,%ebp
    137f:	83 ec 18             	sub    $0x18,%esp
    1382:	8b 45 0c             	mov    0xc(%ebp),%eax
    1385:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1388:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    138f:	00 
    1390:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1393:	89 44 24 04          	mov    %eax,0x4(%esp)
    1397:	8b 45 08             	mov    0x8(%ebp),%eax
    139a:	89 04 24             	mov    %eax,(%esp)
    139d:	e8 52 ff ff ff       	call   12f4 <write>
}
    13a2:	c9                   	leave  
    13a3:	c3                   	ret    

000013a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13a4:	55                   	push   %ebp
    13a5:	89 e5                	mov    %esp,%ebp
    13a7:	56                   	push   %esi
    13a8:	53                   	push   %ebx
    13a9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13b3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13b7:	74 17                	je     13d0 <printint+0x2c>
    13b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13bd:	79 11                	jns    13d0 <printint+0x2c>
    neg = 1;
    13bf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13c6:	8b 45 0c             	mov    0xc(%ebp),%eax
    13c9:	f7 d8                	neg    %eax
    13cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13ce:	eb 06                	jmp    13d6 <printint+0x32>
  } else {
    x = xx;
    13d0:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13dd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13e0:	8d 41 01             	lea    0x1(%ecx),%eax
    13e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13ec:	ba 00 00 00 00       	mov    $0x0,%edx
    13f1:	f7 f3                	div    %ebx
    13f3:	89 d0                	mov    %edx,%eax
    13f5:	0f b6 80 7c 2a 00 00 	movzbl 0x2a7c(%eax),%eax
    13fc:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1400:	8b 75 10             	mov    0x10(%ebp),%esi
    1403:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1406:	ba 00 00 00 00       	mov    $0x0,%edx
    140b:	f7 f6                	div    %esi
    140d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1410:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1414:	75 c7                	jne    13dd <printint+0x39>
  if(neg)
    1416:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    141a:	74 10                	je     142c <printint+0x88>
    buf[i++] = '-';
    141c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    141f:	8d 50 01             	lea    0x1(%eax),%edx
    1422:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1425:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    142a:	eb 1f                	jmp    144b <printint+0xa7>
    142c:	eb 1d                	jmp    144b <printint+0xa7>
    putc(fd, buf[i]);
    142e:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1431:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1434:	01 d0                	add    %edx,%eax
    1436:	0f b6 00             	movzbl (%eax),%eax
    1439:	0f be c0             	movsbl %al,%eax
    143c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1440:	8b 45 08             	mov    0x8(%ebp),%eax
    1443:	89 04 24             	mov    %eax,(%esp)
    1446:	e8 31 ff ff ff       	call   137c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    144b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    144f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1453:	79 d9                	jns    142e <printint+0x8a>
    putc(fd, buf[i]);
}
    1455:	83 c4 30             	add    $0x30,%esp
    1458:	5b                   	pop    %ebx
    1459:	5e                   	pop    %esi
    145a:	5d                   	pop    %ebp
    145b:	c3                   	ret    

0000145c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    145c:	55                   	push   %ebp
    145d:	89 e5                	mov    %esp,%ebp
    145f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1462:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1469:	8d 45 0c             	lea    0xc(%ebp),%eax
    146c:	83 c0 04             	add    $0x4,%eax
    146f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1479:	e9 7c 01 00 00       	jmp    15fa <printf+0x19e>
    c = fmt[i] & 0xff;
    147e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1481:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1484:	01 d0                	add    %edx,%eax
    1486:	0f b6 00             	movzbl (%eax),%eax
    1489:	0f be c0             	movsbl %al,%eax
    148c:	25 ff 00 00 00       	and    $0xff,%eax
    1491:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1494:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1498:	75 2c                	jne    14c6 <printf+0x6a>
      if(c == '%'){
    149a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    149e:	75 0c                	jne    14ac <printf+0x50>
        state = '%';
    14a0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14a7:	e9 4a 01 00 00       	jmp    15f6 <printf+0x19a>
      } else {
        putc(fd, c);
    14ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14af:	0f be c0             	movsbl %al,%eax
    14b2:	89 44 24 04          	mov    %eax,0x4(%esp)
    14b6:	8b 45 08             	mov    0x8(%ebp),%eax
    14b9:	89 04 24             	mov    %eax,(%esp)
    14bc:	e8 bb fe ff ff       	call   137c <putc>
    14c1:	e9 30 01 00 00       	jmp    15f6 <printf+0x19a>
      }
    } else if(state == '%'){
    14c6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14ca:	0f 85 26 01 00 00    	jne    15f6 <printf+0x19a>
      if(c == 'd'){
    14d0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14d4:	75 2d                	jne    1503 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14d9:	8b 00                	mov    (%eax),%eax
    14db:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14e2:	00 
    14e3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14ea:	00 
    14eb:	89 44 24 04          	mov    %eax,0x4(%esp)
    14ef:	8b 45 08             	mov    0x8(%ebp),%eax
    14f2:	89 04 24             	mov    %eax,(%esp)
    14f5:	e8 aa fe ff ff       	call   13a4 <printint>
        ap++;
    14fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14fe:	e9 ec 00 00 00       	jmp    15ef <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1503:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1507:	74 06                	je     150f <printf+0xb3>
    1509:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    150d:	75 2d                	jne    153c <printf+0xe0>
        printint(fd, *ap, 16, 0);
    150f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1512:	8b 00                	mov    (%eax),%eax
    1514:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    151b:	00 
    151c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1523:	00 
    1524:	89 44 24 04          	mov    %eax,0x4(%esp)
    1528:	8b 45 08             	mov    0x8(%ebp),%eax
    152b:	89 04 24             	mov    %eax,(%esp)
    152e:	e8 71 fe ff ff       	call   13a4 <printint>
        ap++;
    1533:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1537:	e9 b3 00 00 00       	jmp    15ef <printf+0x193>
      } else if(c == 's'){
    153c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1540:	75 45                	jne    1587 <printf+0x12b>
        s = (char*)*ap;
    1542:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1545:	8b 00                	mov    (%eax),%eax
    1547:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    154a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    154e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1552:	75 09                	jne    155d <printf+0x101>
          s = "(null)";
    1554:	c7 45 f4 31 18 00 00 	movl   $0x1831,-0xc(%ebp)
        while(*s != 0){
    155b:	eb 1e                	jmp    157b <printf+0x11f>
    155d:	eb 1c                	jmp    157b <printf+0x11f>
          putc(fd, *s);
    155f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1562:	0f b6 00             	movzbl (%eax),%eax
    1565:	0f be c0             	movsbl %al,%eax
    1568:	89 44 24 04          	mov    %eax,0x4(%esp)
    156c:	8b 45 08             	mov    0x8(%ebp),%eax
    156f:	89 04 24             	mov    %eax,(%esp)
    1572:	e8 05 fe ff ff       	call   137c <putc>
          s++;
    1577:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    157b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    157e:	0f b6 00             	movzbl (%eax),%eax
    1581:	84 c0                	test   %al,%al
    1583:	75 da                	jne    155f <printf+0x103>
    1585:	eb 68                	jmp    15ef <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1587:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    158b:	75 1d                	jne    15aa <printf+0x14e>
        putc(fd, *ap);
    158d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1590:	8b 00                	mov    (%eax),%eax
    1592:	0f be c0             	movsbl %al,%eax
    1595:	89 44 24 04          	mov    %eax,0x4(%esp)
    1599:	8b 45 08             	mov    0x8(%ebp),%eax
    159c:	89 04 24             	mov    %eax,(%esp)
    159f:	e8 d8 fd ff ff       	call   137c <putc>
        ap++;
    15a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15a8:	eb 45                	jmp    15ef <printf+0x193>
      } else if(c == '%'){
    15aa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15ae:	75 17                	jne    15c7 <printf+0x16b>
        putc(fd, c);
    15b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15b3:	0f be c0             	movsbl %al,%eax
    15b6:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ba:	8b 45 08             	mov    0x8(%ebp),%eax
    15bd:	89 04 24             	mov    %eax,(%esp)
    15c0:	e8 b7 fd ff ff       	call   137c <putc>
    15c5:	eb 28                	jmp    15ef <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15c7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15ce:	00 
    15cf:	8b 45 08             	mov    0x8(%ebp),%eax
    15d2:	89 04 24             	mov    %eax,(%esp)
    15d5:	e8 a2 fd ff ff       	call   137c <putc>
        putc(fd, c);
    15da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15dd:	0f be c0             	movsbl %al,%eax
    15e0:	89 44 24 04          	mov    %eax,0x4(%esp)
    15e4:	8b 45 08             	mov    0x8(%ebp),%eax
    15e7:	89 04 24             	mov    %eax,(%esp)
    15ea:	e8 8d fd ff ff       	call   137c <putc>
      }
      state = 0;
    15ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15f6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15fa:	8b 55 0c             	mov    0xc(%ebp),%edx
    15fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1600:	01 d0                	add    %edx,%eax
    1602:	0f b6 00             	movzbl (%eax),%eax
    1605:	84 c0                	test   %al,%al
    1607:	0f 85 71 fe ff ff    	jne    147e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    160d:	c9                   	leave  
    160e:	c3                   	ret    

0000160f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    160f:	55                   	push   %ebp
    1610:	89 e5                	mov    %esp,%ebp
    1612:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1615:	8b 45 08             	mov    0x8(%ebp),%eax
    1618:	83 e8 08             	sub    $0x8,%eax
    161b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    161e:	a1 98 2a 00 00       	mov    0x2a98,%eax
    1623:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1626:	eb 24                	jmp    164c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1628:	8b 45 fc             	mov    -0x4(%ebp),%eax
    162b:	8b 00                	mov    (%eax),%eax
    162d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1630:	77 12                	ja     1644 <free+0x35>
    1632:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1635:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1638:	77 24                	ja     165e <free+0x4f>
    163a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    163d:	8b 00                	mov    (%eax),%eax
    163f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1642:	77 1a                	ja     165e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1644:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1647:	8b 00                	mov    (%eax),%eax
    1649:	89 45 fc             	mov    %eax,-0x4(%ebp)
    164c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    164f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1652:	76 d4                	jbe    1628 <free+0x19>
    1654:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1657:	8b 00                	mov    (%eax),%eax
    1659:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    165c:	76 ca                	jbe    1628 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    165e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1661:	8b 40 04             	mov    0x4(%eax),%eax
    1664:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    166b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    166e:	01 c2                	add    %eax,%edx
    1670:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1673:	8b 00                	mov    (%eax),%eax
    1675:	39 c2                	cmp    %eax,%edx
    1677:	75 24                	jne    169d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1679:	8b 45 f8             	mov    -0x8(%ebp),%eax
    167c:	8b 50 04             	mov    0x4(%eax),%edx
    167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1682:	8b 00                	mov    (%eax),%eax
    1684:	8b 40 04             	mov    0x4(%eax),%eax
    1687:	01 c2                	add    %eax,%edx
    1689:	8b 45 f8             	mov    -0x8(%ebp),%eax
    168c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    168f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1692:	8b 00                	mov    (%eax),%eax
    1694:	8b 10                	mov    (%eax),%edx
    1696:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1699:	89 10                	mov    %edx,(%eax)
    169b:	eb 0a                	jmp    16a7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    169d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a0:	8b 10                	mov    (%eax),%edx
    16a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16aa:	8b 40 04             	mov    0x4(%eax),%eax
    16ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b7:	01 d0                	add    %edx,%eax
    16b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16bc:	75 20                	jne    16de <free+0xcf>
    p->s.size += bp->s.size;
    16be:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c1:	8b 50 04             	mov    0x4(%eax),%edx
    16c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c7:	8b 40 04             	mov    0x4(%eax),%eax
    16ca:	01 c2                	add    %eax,%edx
    16cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d5:	8b 10                	mov    (%eax),%edx
    16d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16da:	89 10                	mov    %edx,(%eax)
    16dc:	eb 08                	jmp    16e6 <free+0xd7>
  } else
    p->s.ptr = bp;
    16de:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16e4:	89 10                	mov    %edx,(%eax)
  freep = p;
    16e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e9:	a3 98 2a 00 00       	mov    %eax,0x2a98
}
    16ee:	c9                   	leave  
    16ef:	c3                   	ret    

000016f0 <morecore>:

static Header*
morecore(uint nu)
{
    16f0:	55                   	push   %ebp
    16f1:	89 e5                	mov    %esp,%ebp
    16f3:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16f6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16fd:	77 07                	ja     1706 <morecore+0x16>
    nu = 4096;
    16ff:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1706:	8b 45 08             	mov    0x8(%ebp),%eax
    1709:	c1 e0 03             	shl    $0x3,%eax
    170c:	89 04 24             	mov    %eax,(%esp)
    170f:	e8 48 fc ff ff       	call   135c <sbrk>
    1714:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1717:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    171b:	75 07                	jne    1724 <morecore+0x34>
    return 0;
    171d:	b8 00 00 00 00       	mov    $0x0,%eax
    1722:	eb 22                	jmp    1746 <morecore+0x56>
  hp = (Header*)p;
    1724:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1727:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    172a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    172d:	8b 55 08             	mov    0x8(%ebp),%edx
    1730:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1733:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1736:	83 c0 08             	add    $0x8,%eax
    1739:	89 04 24             	mov    %eax,(%esp)
    173c:	e8 ce fe ff ff       	call   160f <free>
  return freep;
    1741:	a1 98 2a 00 00       	mov    0x2a98,%eax
}
    1746:	c9                   	leave  
    1747:	c3                   	ret    

00001748 <malloc>:

void*
malloc(uint nbytes)
{
    1748:	55                   	push   %ebp
    1749:	89 e5                	mov    %esp,%ebp
    174b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    174e:	8b 45 08             	mov    0x8(%ebp),%eax
    1751:	83 c0 07             	add    $0x7,%eax
    1754:	c1 e8 03             	shr    $0x3,%eax
    1757:	83 c0 01             	add    $0x1,%eax
    175a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    175d:	a1 98 2a 00 00       	mov    0x2a98,%eax
    1762:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1765:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1769:	75 23                	jne    178e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    176b:	c7 45 f0 90 2a 00 00 	movl   $0x2a90,-0x10(%ebp)
    1772:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1775:	a3 98 2a 00 00       	mov    %eax,0x2a98
    177a:	a1 98 2a 00 00       	mov    0x2a98,%eax
    177f:	a3 90 2a 00 00       	mov    %eax,0x2a90
    base.s.size = 0;
    1784:	c7 05 94 2a 00 00 00 	movl   $0x0,0x2a94
    178b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    178e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1791:	8b 00                	mov    (%eax),%eax
    1793:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1796:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1799:	8b 40 04             	mov    0x4(%eax),%eax
    179c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    179f:	72 4d                	jb     17ee <malloc+0xa6>
      if(p->s.size == nunits)
    17a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a4:	8b 40 04             	mov    0x4(%eax),%eax
    17a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17aa:	75 0c                	jne    17b8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17af:	8b 10                	mov    (%eax),%edx
    17b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17b4:	89 10                	mov    %edx,(%eax)
    17b6:	eb 26                	jmp    17de <malloc+0x96>
      else {
        p->s.size -= nunits;
    17b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17bb:	8b 40 04             	mov    0x4(%eax),%eax
    17be:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17c1:	89 c2                	mov    %eax,%edx
    17c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17cc:	8b 40 04             	mov    0x4(%eax),%eax
    17cf:	c1 e0 03             	shl    $0x3,%eax
    17d2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17db:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17de:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17e1:	a3 98 2a 00 00       	mov    %eax,0x2a98
      return (void*)(p + 1);
    17e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e9:	83 c0 08             	add    $0x8,%eax
    17ec:	eb 38                	jmp    1826 <malloc+0xde>
    }
    if(p == freep)
    17ee:	a1 98 2a 00 00       	mov    0x2a98,%eax
    17f3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17f6:	75 1b                	jne    1813 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    17f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17fb:	89 04 24             	mov    %eax,(%esp)
    17fe:	e8 ed fe ff ff       	call   16f0 <morecore>
    1803:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1806:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    180a:	75 07                	jne    1813 <malloc+0xcb>
        return 0;
    180c:	b8 00 00 00 00       	mov    $0x0,%eax
    1811:	eb 13                	jmp    1826 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1813:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1816:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1819:	8b 45 f4             	mov    -0xc(%ebp),%eax
    181c:	8b 00                	mov    (%eax),%eax
    181e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1821:	e9 70 ff ff ff       	jmp    1796 <malloc+0x4e>
}
    1826:	c9                   	leave  
    1827:	c3                   	ret    
