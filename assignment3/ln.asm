
_ln:     file format elf32-i386


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
    1006:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
    1009:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
    100d:	74 19                	je     1028 <main+0x28>
    printf(2, "Usage: ln old new\n");
    100f:	c7 44 24 04 35 18 00 	movl   $0x1835,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    101e:	e8 46 04 00 00       	call   1469 <printf>
    exit();
    1023:	e8 b9 02 00 00       	call   12e1 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
    1028:	8b 45 0c             	mov    0xc(%ebp),%eax
    102b:	83 c0 08             	add    $0x8,%eax
    102e:	8b 10                	mov    (%eax),%edx
    1030:	8b 45 0c             	mov    0xc(%ebp),%eax
    1033:	83 c0 04             	add    $0x4,%eax
    1036:	8b 00                	mov    (%eax),%eax
    1038:	89 54 24 04          	mov    %edx,0x4(%esp)
    103c:	89 04 24             	mov    %eax,(%esp)
    103f:	e8 fd 02 00 00       	call   1341 <link>
    1044:	85 c0                	test   %eax,%eax
    1046:	79 2c                	jns    1074 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
    1048:	8b 45 0c             	mov    0xc(%ebp),%eax
    104b:	83 c0 08             	add    $0x8,%eax
    104e:	8b 10                	mov    (%eax),%edx
    1050:	8b 45 0c             	mov    0xc(%ebp),%eax
    1053:	83 c0 04             	add    $0x4,%eax
    1056:	8b 00                	mov    (%eax),%eax
    1058:	89 54 24 0c          	mov    %edx,0xc(%esp)
    105c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1060:	c7 44 24 04 48 18 00 	movl   $0x1848,0x4(%esp)
    1067:	00 
    1068:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    106f:	e8 f5 03 00 00       	call   1469 <printf>
  exit();
    1074:	e8 68 02 00 00       	call   12e1 <exit>

00001079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1079:	55                   	push   %ebp
    107a:	89 e5                	mov    %esp,%ebp
    107c:	57                   	push   %edi
    107d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    107e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1081:	8b 55 10             	mov    0x10(%ebp),%edx
    1084:	8b 45 0c             	mov    0xc(%ebp),%eax
    1087:	89 cb                	mov    %ecx,%ebx
    1089:	89 df                	mov    %ebx,%edi
    108b:	89 d1                	mov    %edx,%ecx
    108d:	fc                   	cld    
    108e:	f3 aa                	rep stos %al,%es:(%edi)
    1090:	89 ca                	mov    %ecx,%edx
    1092:	89 fb                	mov    %edi,%ebx
    1094:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1097:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    109a:	5b                   	pop    %ebx
    109b:	5f                   	pop    %edi
    109c:	5d                   	pop    %ebp
    109d:	c3                   	ret    

0000109e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    109e:	55                   	push   %ebp
    109f:	89 e5                	mov    %esp,%ebp
    10a1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10a4:	8b 45 08             	mov    0x8(%ebp),%eax
    10a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10aa:	90                   	nop
    10ab:	8b 45 08             	mov    0x8(%ebp),%eax
    10ae:	8d 50 01             	lea    0x1(%eax),%edx
    10b1:	89 55 08             	mov    %edx,0x8(%ebp)
    10b4:	8b 55 0c             	mov    0xc(%ebp),%edx
    10b7:	8d 4a 01             	lea    0x1(%edx),%ecx
    10ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10bd:	0f b6 12             	movzbl (%edx),%edx
    10c0:	88 10                	mov    %dl,(%eax)
    10c2:	0f b6 00             	movzbl (%eax),%eax
    10c5:	84 c0                	test   %al,%al
    10c7:	75 e2                	jne    10ab <strcpy+0xd>
    ;
  return os;
    10c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10cc:	c9                   	leave  
    10cd:	c3                   	ret    

000010ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10ce:	55                   	push   %ebp
    10cf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10d1:	eb 08                	jmp    10db <strcmp+0xd>
    p++, q++;
    10d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10d7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10db:	8b 45 08             	mov    0x8(%ebp),%eax
    10de:	0f b6 00             	movzbl (%eax),%eax
    10e1:	84 c0                	test   %al,%al
    10e3:	74 10                	je     10f5 <strcmp+0x27>
    10e5:	8b 45 08             	mov    0x8(%ebp),%eax
    10e8:	0f b6 10             	movzbl (%eax),%edx
    10eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ee:	0f b6 00             	movzbl (%eax),%eax
    10f1:	38 c2                	cmp    %al,%dl
    10f3:	74 de                	je     10d3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10f5:	8b 45 08             	mov    0x8(%ebp),%eax
    10f8:	0f b6 00             	movzbl (%eax),%eax
    10fb:	0f b6 d0             	movzbl %al,%edx
    10fe:	8b 45 0c             	mov    0xc(%ebp),%eax
    1101:	0f b6 00             	movzbl (%eax),%eax
    1104:	0f b6 c0             	movzbl %al,%eax
    1107:	29 c2                	sub    %eax,%edx
    1109:	89 d0                	mov    %edx,%eax
}
    110b:	5d                   	pop    %ebp
    110c:	c3                   	ret    

0000110d <strlen>:

uint
strlen(char *s)
{
    110d:	55                   	push   %ebp
    110e:	89 e5                	mov    %esp,%ebp
    1110:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1113:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    111a:	eb 04                	jmp    1120 <strlen+0x13>
    111c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1120:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1123:	8b 45 08             	mov    0x8(%ebp),%eax
    1126:	01 d0                	add    %edx,%eax
    1128:	0f b6 00             	movzbl (%eax),%eax
    112b:	84 c0                	test   %al,%al
    112d:	75 ed                	jne    111c <strlen+0xf>
    ;
  return n;
    112f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1132:	c9                   	leave  
    1133:	c3                   	ret    

00001134 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1134:	55                   	push   %ebp
    1135:	89 e5                	mov    %esp,%ebp
    1137:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    113a:	8b 45 10             	mov    0x10(%ebp),%eax
    113d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1141:	8b 45 0c             	mov    0xc(%ebp),%eax
    1144:	89 44 24 04          	mov    %eax,0x4(%esp)
    1148:	8b 45 08             	mov    0x8(%ebp),%eax
    114b:	89 04 24             	mov    %eax,(%esp)
    114e:	e8 26 ff ff ff       	call   1079 <stosb>
  return dst;
    1153:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1156:	c9                   	leave  
    1157:	c3                   	ret    

00001158 <strchr>:

char*
strchr(const char *s, char c)
{
    1158:	55                   	push   %ebp
    1159:	89 e5                	mov    %esp,%ebp
    115b:	83 ec 04             	sub    $0x4,%esp
    115e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1161:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1164:	eb 14                	jmp    117a <strchr+0x22>
    if(*s == c)
    1166:	8b 45 08             	mov    0x8(%ebp),%eax
    1169:	0f b6 00             	movzbl (%eax),%eax
    116c:	3a 45 fc             	cmp    -0x4(%ebp),%al
    116f:	75 05                	jne    1176 <strchr+0x1e>
      return (char*)s;
    1171:	8b 45 08             	mov    0x8(%ebp),%eax
    1174:	eb 13                	jmp    1189 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1176:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    117a:	8b 45 08             	mov    0x8(%ebp),%eax
    117d:	0f b6 00             	movzbl (%eax),%eax
    1180:	84 c0                	test   %al,%al
    1182:	75 e2                	jne    1166 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1184:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1189:	c9                   	leave  
    118a:	c3                   	ret    

0000118b <gets>:

char*
gets(char *buf, int max)
{
    118b:	55                   	push   %ebp
    118c:	89 e5                	mov    %esp,%ebp
    118e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1191:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1198:	eb 4c                	jmp    11e6 <gets+0x5b>
    cc = read(0, &c, 1);
    119a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    11a1:	00 
    11a2:	8d 45 ef             	lea    -0x11(%ebp),%eax
    11a5:	89 44 24 04          	mov    %eax,0x4(%esp)
    11a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11b0:	e8 44 01 00 00       	call   12f9 <read>
    11b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11bc:	7f 02                	jg     11c0 <gets+0x35>
      break;
    11be:	eb 31                	jmp    11f1 <gets+0x66>
    buf[i++] = c;
    11c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11c3:	8d 50 01             	lea    0x1(%eax),%edx
    11c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11c9:	89 c2                	mov    %eax,%edx
    11cb:	8b 45 08             	mov    0x8(%ebp),%eax
    11ce:	01 c2                	add    %eax,%edx
    11d0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11d4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11d6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11da:	3c 0a                	cmp    $0xa,%al
    11dc:	74 13                	je     11f1 <gets+0x66>
    11de:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11e2:	3c 0d                	cmp    $0xd,%al
    11e4:	74 0b                	je     11f1 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11e9:	83 c0 01             	add    $0x1,%eax
    11ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11ef:	7c a9                	jl     119a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11f4:	8b 45 08             	mov    0x8(%ebp),%eax
    11f7:	01 d0                	add    %edx,%eax
    11f9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ff:	c9                   	leave  
    1200:	c3                   	ret    

00001201 <stat>:

int
stat(char *n, struct stat *st)
{
    1201:	55                   	push   %ebp
    1202:	89 e5                	mov    %esp,%ebp
    1204:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1207:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    120e:	00 
    120f:	8b 45 08             	mov    0x8(%ebp),%eax
    1212:	89 04 24             	mov    %eax,(%esp)
    1215:	e8 07 01 00 00       	call   1321 <open>
    121a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    121d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1221:	79 07                	jns    122a <stat+0x29>
    return -1;
    1223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1228:	eb 23                	jmp    124d <stat+0x4c>
  r = fstat(fd, st);
    122a:	8b 45 0c             	mov    0xc(%ebp),%eax
    122d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1231:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1234:	89 04 24             	mov    %eax,(%esp)
    1237:	e8 fd 00 00 00       	call   1339 <fstat>
    123c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    123f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1242:	89 04 24             	mov    %eax,(%esp)
    1245:	e8 bf 00 00 00       	call   1309 <close>
  return r;
    124a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    124d:	c9                   	leave  
    124e:	c3                   	ret    

0000124f <atoi>:

int
atoi(const char *s)
{
    124f:	55                   	push   %ebp
    1250:	89 e5                	mov    %esp,%ebp
    1252:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1255:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    125c:	eb 25                	jmp    1283 <atoi+0x34>
    n = n*10 + *s++ - '0';
    125e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1261:	89 d0                	mov    %edx,%eax
    1263:	c1 e0 02             	shl    $0x2,%eax
    1266:	01 d0                	add    %edx,%eax
    1268:	01 c0                	add    %eax,%eax
    126a:	89 c1                	mov    %eax,%ecx
    126c:	8b 45 08             	mov    0x8(%ebp),%eax
    126f:	8d 50 01             	lea    0x1(%eax),%edx
    1272:	89 55 08             	mov    %edx,0x8(%ebp)
    1275:	0f b6 00             	movzbl (%eax),%eax
    1278:	0f be c0             	movsbl %al,%eax
    127b:	01 c8                	add    %ecx,%eax
    127d:	83 e8 30             	sub    $0x30,%eax
    1280:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1283:	8b 45 08             	mov    0x8(%ebp),%eax
    1286:	0f b6 00             	movzbl (%eax),%eax
    1289:	3c 2f                	cmp    $0x2f,%al
    128b:	7e 0a                	jle    1297 <atoi+0x48>
    128d:	8b 45 08             	mov    0x8(%ebp),%eax
    1290:	0f b6 00             	movzbl (%eax),%eax
    1293:	3c 39                	cmp    $0x39,%al
    1295:	7e c7                	jle    125e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1297:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    129a:	c9                   	leave  
    129b:	c3                   	ret    

0000129c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    129c:	55                   	push   %ebp
    129d:	89 e5                	mov    %esp,%ebp
    129f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    12a2:	8b 45 08             	mov    0x8(%ebp),%eax
    12a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    12a8:	8b 45 0c             	mov    0xc(%ebp),%eax
    12ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12ae:	eb 17                	jmp    12c7 <memmove+0x2b>
    *dst++ = *src++;
    12b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b3:	8d 50 01             	lea    0x1(%eax),%edx
    12b6:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12bc:	8d 4a 01             	lea    0x1(%edx),%ecx
    12bf:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12c2:	0f b6 12             	movzbl (%edx),%edx
    12c5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12c7:	8b 45 10             	mov    0x10(%ebp),%eax
    12ca:	8d 50 ff             	lea    -0x1(%eax),%edx
    12cd:	89 55 10             	mov    %edx,0x10(%ebp)
    12d0:	85 c0                	test   %eax,%eax
    12d2:	7f dc                	jg     12b0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12d7:	c9                   	leave  
    12d8:	c3                   	ret    

000012d9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12d9:	b8 01 00 00 00       	mov    $0x1,%eax
    12de:	cd 40                	int    $0x40
    12e0:	c3                   	ret    

000012e1 <exit>:
SYSCALL(exit)
    12e1:	b8 02 00 00 00       	mov    $0x2,%eax
    12e6:	cd 40                	int    $0x40
    12e8:	c3                   	ret    

000012e9 <wait>:
SYSCALL(wait)
    12e9:	b8 03 00 00 00       	mov    $0x3,%eax
    12ee:	cd 40                	int    $0x40
    12f0:	c3                   	ret    

000012f1 <pipe>:
SYSCALL(pipe)
    12f1:	b8 04 00 00 00       	mov    $0x4,%eax
    12f6:	cd 40                	int    $0x40
    12f8:	c3                   	ret    

000012f9 <read>:
SYSCALL(read)
    12f9:	b8 05 00 00 00       	mov    $0x5,%eax
    12fe:	cd 40                	int    $0x40
    1300:	c3                   	ret    

00001301 <write>:
SYSCALL(write)
    1301:	b8 10 00 00 00       	mov    $0x10,%eax
    1306:	cd 40                	int    $0x40
    1308:	c3                   	ret    

00001309 <close>:
SYSCALL(close)
    1309:	b8 15 00 00 00       	mov    $0x15,%eax
    130e:	cd 40                	int    $0x40
    1310:	c3                   	ret    

00001311 <kill>:
SYSCALL(kill)
    1311:	b8 06 00 00 00       	mov    $0x6,%eax
    1316:	cd 40                	int    $0x40
    1318:	c3                   	ret    

00001319 <exec>:
SYSCALL(exec)
    1319:	b8 07 00 00 00       	mov    $0x7,%eax
    131e:	cd 40                	int    $0x40
    1320:	c3                   	ret    

00001321 <open>:
SYSCALL(open)
    1321:	b8 0f 00 00 00       	mov    $0xf,%eax
    1326:	cd 40                	int    $0x40
    1328:	c3                   	ret    

00001329 <mknod>:
SYSCALL(mknod)
    1329:	b8 11 00 00 00       	mov    $0x11,%eax
    132e:	cd 40                	int    $0x40
    1330:	c3                   	ret    

00001331 <unlink>:
SYSCALL(unlink)
    1331:	b8 12 00 00 00       	mov    $0x12,%eax
    1336:	cd 40                	int    $0x40
    1338:	c3                   	ret    

00001339 <fstat>:
SYSCALL(fstat)
    1339:	b8 08 00 00 00       	mov    $0x8,%eax
    133e:	cd 40                	int    $0x40
    1340:	c3                   	ret    

00001341 <link>:
SYSCALL(link)
    1341:	b8 13 00 00 00       	mov    $0x13,%eax
    1346:	cd 40                	int    $0x40
    1348:	c3                   	ret    

00001349 <mkdir>:
SYSCALL(mkdir)
    1349:	b8 14 00 00 00       	mov    $0x14,%eax
    134e:	cd 40                	int    $0x40
    1350:	c3                   	ret    

00001351 <chdir>:
SYSCALL(chdir)
    1351:	b8 09 00 00 00       	mov    $0x9,%eax
    1356:	cd 40                	int    $0x40
    1358:	c3                   	ret    

00001359 <dup>:
SYSCALL(dup)
    1359:	b8 0a 00 00 00       	mov    $0xa,%eax
    135e:	cd 40                	int    $0x40
    1360:	c3                   	ret    

00001361 <getpid>:
SYSCALL(getpid)
    1361:	b8 0b 00 00 00       	mov    $0xb,%eax
    1366:	cd 40                	int    $0x40
    1368:	c3                   	ret    

00001369 <sbrk>:
SYSCALL(sbrk)
    1369:	b8 0c 00 00 00       	mov    $0xc,%eax
    136e:	cd 40                	int    $0x40
    1370:	c3                   	ret    

00001371 <sleep>:
SYSCALL(sleep)
    1371:	b8 0d 00 00 00       	mov    $0xd,%eax
    1376:	cd 40                	int    $0x40
    1378:	c3                   	ret    

00001379 <uptime>:
SYSCALL(uptime)
    1379:	b8 0e 00 00 00       	mov    $0xe,%eax
    137e:	cd 40                	int    $0x40
    1380:	c3                   	ret    

00001381 <cowfork>:
SYSCALL(cowfork) //3.4
    1381:	b8 16 00 00 00       	mov    $0x16,%eax
    1386:	cd 40                	int    $0x40
    1388:	c3                   	ret    

00001389 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1389:	55                   	push   %ebp
    138a:	89 e5                	mov    %esp,%ebp
    138c:	83 ec 18             	sub    $0x18,%esp
    138f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1392:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1395:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    139c:	00 
    139d:	8d 45 f4             	lea    -0xc(%ebp),%eax
    13a0:	89 44 24 04          	mov    %eax,0x4(%esp)
    13a4:	8b 45 08             	mov    0x8(%ebp),%eax
    13a7:	89 04 24             	mov    %eax,(%esp)
    13aa:	e8 52 ff ff ff       	call   1301 <write>
}
    13af:	c9                   	leave  
    13b0:	c3                   	ret    

000013b1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13b1:	55                   	push   %ebp
    13b2:	89 e5                	mov    %esp,%ebp
    13b4:	56                   	push   %esi
    13b5:	53                   	push   %ebx
    13b6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13c0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13c4:	74 17                	je     13dd <printint+0x2c>
    13c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13ca:	79 11                	jns    13dd <printint+0x2c>
    neg = 1;
    13cc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13d3:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d6:	f7 d8                	neg    %eax
    13d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13db:	eb 06                	jmp    13e3 <printint+0x32>
  } else {
    x = xx;
    13dd:	8b 45 0c             	mov    0xc(%ebp),%eax
    13e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13ea:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13ed:	8d 41 01             	lea    0x1(%ecx),%eax
    13f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13f9:	ba 00 00 00 00       	mov    $0x0,%edx
    13fe:	f7 f3                	div    %ebx
    1400:	89 d0                	mov    %edx,%eax
    1402:	0f b6 80 a8 2a 00 00 	movzbl 0x2aa8(%eax),%eax
    1409:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    140d:	8b 75 10             	mov    0x10(%ebp),%esi
    1410:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1413:	ba 00 00 00 00       	mov    $0x0,%edx
    1418:	f7 f6                	div    %esi
    141a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    141d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1421:	75 c7                	jne    13ea <printint+0x39>
  if(neg)
    1423:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1427:	74 10                	je     1439 <printint+0x88>
    buf[i++] = '-';
    1429:	8b 45 f4             	mov    -0xc(%ebp),%eax
    142c:	8d 50 01             	lea    0x1(%eax),%edx
    142f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1432:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1437:	eb 1f                	jmp    1458 <printint+0xa7>
    1439:	eb 1d                	jmp    1458 <printint+0xa7>
    putc(fd, buf[i]);
    143b:	8d 55 dc             	lea    -0x24(%ebp),%edx
    143e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1441:	01 d0                	add    %edx,%eax
    1443:	0f b6 00             	movzbl (%eax),%eax
    1446:	0f be c0             	movsbl %al,%eax
    1449:	89 44 24 04          	mov    %eax,0x4(%esp)
    144d:	8b 45 08             	mov    0x8(%ebp),%eax
    1450:	89 04 24             	mov    %eax,(%esp)
    1453:	e8 31 ff ff ff       	call   1389 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1458:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    145c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1460:	79 d9                	jns    143b <printint+0x8a>
    putc(fd, buf[i]);
}
    1462:	83 c4 30             	add    $0x30,%esp
    1465:	5b                   	pop    %ebx
    1466:	5e                   	pop    %esi
    1467:	5d                   	pop    %ebp
    1468:	c3                   	ret    

00001469 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1469:	55                   	push   %ebp
    146a:	89 e5                	mov    %esp,%ebp
    146c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    146f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1476:	8d 45 0c             	lea    0xc(%ebp),%eax
    1479:	83 c0 04             	add    $0x4,%eax
    147c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    147f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1486:	e9 7c 01 00 00       	jmp    1607 <printf+0x19e>
    c = fmt[i] & 0xff;
    148b:	8b 55 0c             	mov    0xc(%ebp),%edx
    148e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1491:	01 d0                	add    %edx,%eax
    1493:	0f b6 00             	movzbl (%eax),%eax
    1496:	0f be c0             	movsbl %al,%eax
    1499:	25 ff 00 00 00       	and    $0xff,%eax
    149e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    14a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14a5:	75 2c                	jne    14d3 <printf+0x6a>
      if(c == '%'){
    14a7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14ab:	75 0c                	jne    14b9 <printf+0x50>
        state = '%';
    14ad:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14b4:	e9 4a 01 00 00       	jmp    1603 <printf+0x19a>
      } else {
        putc(fd, c);
    14b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14bc:	0f be c0             	movsbl %al,%eax
    14bf:	89 44 24 04          	mov    %eax,0x4(%esp)
    14c3:	8b 45 08             	mov    0x8(%ebp),%eax
    14c6:	89 04 24             	mov    %eax,(%esp)
    14c9:	e8 bb fe ff ff       	call   1389 <putc>
    14ce:	e9 30 01 00 00       	jmp    1603 <printf+0x19a>
      }
    } else if(state == '%'){
    14d3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14d7:	0f 85 26 01 00 00    	jne    1603 <printf+0x19a>
      if(c == 'd'){
    14dd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14e1:	75 2d                	jne    1510 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14e6:	8b 00                	mov    (%eax),%eax
    14e8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14ef:	00 
    14f0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14f7:	00 
    14f8:	89 44 24 04          	mov    %eax,0x4(%esp)
    14fc:	8b 45 08             	mov    0x8(%ebp),%eax
    14ff:	89 04 24             	mov    %eax,(%esp)
    1502:	e8 aa fe ff ff       	call   13b1 <printint>
        ap++;
    1507:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    150b:	e9 ec 00 00 00       	jmp    15fc <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1510:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1514:	74 06                	je     151c <printf+0xb3>
    1516:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    151a:	75 2d                	jne    1549 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    151c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    151f:	8b 00                	mov    (%eax),%eax
    1521:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1528:	00 
    1529:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1530:	00 
    1531:	89 44 24 04          	mov    %eax,0x4(%esp)
    1535:	8b 45 08             	mov    0x8(%ebp),%eax
    1538:	89 04 24             	mov    %eax,(%esp)
    153b:	e8 71 fe ff ff       	call   13b1 <printint>
        ap++;
    1540:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1544:	e9 b3 00 00 00       	jmp    15fc <printf+0x193>
      } else if(c == 's'){
    1549:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    154d:	75 45                	jne    1594 <printf+0x12b>
        s = (char*)*ap;
    154f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1552:	8b 00                	mov    (%eax),%eax
    1554:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1557:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    155b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    155f:	75 09                	jne    156a <printf+0x101>
          s = "(null)";
    1561:	c7 45 f4 5c 18 00 00 	movl   $0x185c,-0xc(%ebp)
        while(*s != 0){
    1568:	eb 1e                	jmp    1588 <printf+0x11f>
    156a:	eb 1c                	jmp    1588 <printf+0x11f>
          putc(fd, *s);
    156c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    156f:	0f b6 00             	movzbl (%eax),%eax
    1572:	0f be c0             	movsbl %al,%eax
    1575:	89 44 24 04          	mov    %eax,0x4(%esp)
    1579:	8b 45 08             	mov    0x8(%ebp),%eax
    157c:	89 04 24             	mov    %eax,(%esp)
    157f:	e8 05 fe ff ff       	call   1389 <putc>
          s++;
    1584:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1588:	8b 45 f4             	mov    -0xc(%ebp),%eax
    158b:	0f b6 00             	movzbl (%eax),%eax
    158e:	84 c0                	test   %al,%al
    1590:	75 da                	jne    156c <printf+0x103>
    1592:	eb 68                	jmp    15fc <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1594:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1598:	75 1d                	jne    15b7 <printf+0x14e>
        putc(fd, *ap);
    159a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    159d:	8b 00                	mov    (%eax),%eax
    159f:	0f be c0             	movsbl %al,%eax
    15a2:	89 44 24 04          	mov    %eax,0x4(%esp)
    15a6:	8b 45 08             	mov    0x8(%ebp),%eax
    15a9:	89 04 24             	mov    %eax,(%esp)
    15ac:	e8 d8 fd ff ff       	call   1389 <putc>
        ap++;
    15b1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15b5:	eb 45                	jmp    15fc <printf+0x193>
      } else if(c == '%'){
    15b7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15bb:	75 17                	jne    15d4 <printf+0x16b>
        putc(fd, c);
    15bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15c0:	0f be c0             	movsbl %al,%eax
    15c3:	89 44 24 04          	mov    %eax,0x4(%esp)
    15c7:	8b 45 08             	mov    0x8(%ebp),%eax
    15ca:	89 04 24             	mov    %eax,(%esp)
    15cd:	e8 b7 fd ff ff       	call   1389 <putc>
    15d2:	eb 28                	jmp    15fc <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15d4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15db:	00 
    15dc:	8b 45 08             	mov    0x8(%ebp),%eax
    15df:	89 04 24             	mov    %eax,(%esp)
    15e2:	e8 a2 fd ff ff       	call   1389 <putc>
        putc(fd, c);
    15e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15ea:	0f be c0             	movsbl %al,%eax
    15ed:	89 44 24 04          	mov    %eax,0x4(%esp)
    15f1:	8b 45 08             	mov    0x8(%ebp),%eax
    15f4:	89 04 24             	mov    %eax,(%esp)
    15f7:	e8 8d fd ff ff       	call   1389 <putc>
      }
      state = 0;
    15fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1603:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1607:	8b 55 0c             	mov    0xc(%ebp),%edx
    160a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    160d:	01 d0                	add    %edx,%eax
    160f:	0f b6 00             	movzbl (%eax),%eax
    1612:	84 c0                	test   %al,%al
    1614:	0f 85 71 fe ff ff    	jne    148b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    161a:	c9                   	leave  
    161b:	c3                   	ret    

0000161c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    161c:	55                   	push   %ebp
    161d:	89 e5                	mov    %esp,%ebp
    161f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1622:	8b 45 08             	mov    0x8(%ebp),%eax
    1625:	83 e8 08             	sub    $0x8,%eax
    1628:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    162b:	a1 c4 2a 00 00       	mov    0x2ac4,%eax
    1630:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1633:	eb 24                	jmp    1659 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1635:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1638:	8b 00                	mov    (%eax),%eax
    163a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    163d:	77 12                	ja     1651 <free+0x35>
    163f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1642:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1645:	77 24                	ja     166b <free+0x4f>
    1647:	8b 45 fc             	mov    -0x4(%ebp),%eax
    164a:	8b 00                	mov    (%eax),%eax
    164c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    164f:	77 1a                	ja     166b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1651:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1654:	8b 00                	mov    (%eax),%eax
    1656:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1659:	8b 45 f8             	mov    -0x8(%ebp),%eax
    165c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    165f:	76 d4                	jbe    1635 <free+0x19>
    1661:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1664:	8b 00                	mov    (%eax),%eax
    1666:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1669:	76 ca                	jbe    1635 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    166b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    166e:	8b 40 04             	mov    0x4(%eax),%eax
    1671:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1678:	8b 45 f8             	mov    -0x8(%ebp),%eax
    167b:	01 c2                	add    %eax,%edx
    167d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1680:	8b 00                	mov    (%eax),%eax
    1682:	39 c2                	cmp    %eax,%edx
    1684:	75 24                	jne    16aa <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1686:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1689:	8b 50 04             	mov    0x4(%eax),%edx
    168c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    168f:	8b 00                	mov    (%eax),%eax
    1691:	8b 40 04             	mov    0x4(%eax),%eax
    1694:	01 c2                	add    %eax,%edx
    1696:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1699:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    169c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169f:	8b 00                	mov    (%eax),%eax
    16a1:	8b 10                	mov    (%eax),%edx
    16a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a6:	89 10                	mov    %edx,(%eax)
    16a8:	eb 0a                	jmp    16b4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    16aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ad:	8b 10                	mov    (%eax),%edx
    16af:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b7:	8b 40 04             	mov    0x4(%eax),%eax
    16ba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c4:	01 d0                	add    %edx,%eax
    16c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16c9:	75 20                	jne    16eb <free+0xcf>
    p->s.size += bp->s.size;
    16cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ce:	8b 50 04             	mov    0x4(%eax),%edx
    16d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d4:	8b 40 04             	mov    0x4(%eax),%eax
    16d7:	01 c2                	add    %eax,%edx
    16d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16dc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16df:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16e2:	8b 10                	mov    (%eax),%edx
    16e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e7:	89 10                	mov    %edx,(%eax)
    16e9:	eb 08                	jmp    16f3 <free+0xd7>
  } else
    p->s.ptr = bp;
    16eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16f1:	89 10                	mov    %edx,(%eax)
  freep = p;
    16f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f6:	a3 c4 2a 00 00       	mov    %eax,0x2ac4
}
    16fb:	c9                   	leave  
    16fc:	c3                   	ret    

000016fd <morecore>:

static Header*
morecore(uint nu)
{
    16fd:	55                   	push   %ebp
    16fe:	89 e5                	mov    %esp,%ebp
    1700:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1703:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    170a:	77 07                	ja     1713 <morecore+0x16>
    nu = 4096;
    170c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1713:	8b 45 08             	mov    0x8(%ebp),%eax
    1716:	c1 e0 03             	shl    $0x3,%eax
    1719:	89 04 24             	mov    %eax,(%esp)
    171c:	e8 48 fc ff ff       	call   1369 <sbrk>
    1721:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1724:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1728:	75 07                	jne    1731 <morecore+0x34>
    return 0;
    172a:	b8 00 00 00 00       	mov    $0x0,%eax
    172f:	eb 22                	jmp    1753 <morecore+0x56>
  hp = (Header*)p;
    1731:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1734:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1737:	8b 45 f0             	mov    -0x10(%ebp),%eax
    173a:	8b 55 08             	mov    0x8(%ebp),%edx
    173d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1740:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1743:	83 c0 08             	add    $0x8,%eax
    1746:	89 04 24             	mov    %eax,(%esp)
    1749:	e8 ce fe ff ff       	call   161c <free>
  return freep;
    174e:	a1 c4 2a 00 00       	mov    0x2ac4,%eax
}
    1753:	c9                   	leave  
    1754:	c3                   	ret    

00001755 <malloc>:

void*
malloc(uint nbytes)
{
    1755:	55                   	push   %ebp
    1756:	89 e5                	mov    %esp,%ebp
    1758:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    175b:	8b 45 08             	mov    0x8(%ebp),%eax
    175e:	83 c0 07             	add    $0x7,%eax
    1761:	c1 e8 03             	shr    $0x3,%eax
    1764:	83 c0 01             	add    $0x1,%eax
    1767:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    176a:	a1 c4 2a 00 00       	mov    0x2ac4,%eax
    176f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1772:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1776:	75 23                	jne    179b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1778:	c7 45 f0 bc 2a 00 00 	movl   $0x2abc,-0x10(%ebp)
    177f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1782:	a3 c4 2a 00 00       	mov    %eax,0x2ac4
    1787:	a1 c4 2a 00 00       	mov    0x2ac4,%eax
    178c:	a3 bc 2a 00 00       	mov    %eax,0x2abc
    base.s.size = 0;
    1791:	c7 05 c0 2a 00 00 00 	movl   $0x0,0x2ac0
    1798:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    179b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    179e:	8b 00                	mov    (%eax),%eax
    17a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    17a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a6:	8b 40 04             	mov    0x4(%eax),%eax
    17a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17ac:	72 4d                	jb     17fb <malloc+0xa6>
      if(p->s.size == nunits)
    17ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b1:	8b 40 04             	mov    0x4(%eax),%eax
    17b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17b7:	75 0c                	jne    17c5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17bc:	8b 10                	mov    (%eax),%edx
    17be:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17c1:	89 10                	mov    %edx,(%eax)
    17c3:	eb 26                	jmp    17eb <malloc+0x96>
      else {
        p->s.size -= nunits;
    17c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c8:	8b 40 04             	mov    0x4(%eax),%eax
    17cb:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17ce:	89 c2                	mov    %eax,%edx
    17d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d9:	8b 40 04             	mov    0x4(%eax),%eax
    17dc:	c1 e0 03             	shl    $0x3,%eax
    17df:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17e8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17ee:	a3 c4 2a 00 00       	mov    %eax,0x2ac4
      return (void*)(p + 1);
    17f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f6:	83 c0 08             	add    $0x8,%eax
    17f9:	eb 38                	jmp    1833 <malloc+0xde>
    }
    if(p == freep)
    17fb:	a1 c4 2a 00 00       	mov    0x2ac4,%eax
    1800:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1803:	75 1b                	jne    1820 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1805:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1808:	89 04 24             	mov    %eax,(%esp)
    180b:	e8 ed fe ff ff       	call   16fd <morecore>
    1810:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1813:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1817:	75 07                	jne    1820 <malloc+0xcb>
        return 0;
    1819:	b8 00 00 00 00       	mov    $0x0,%eax
    181e:	eb 13                	jmp    1833 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1820:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1823:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1826:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1829:	8b 00                	mov    (%eax),%eax
    182b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    182e:	e9 70 ff ff ff       	jmp    17a3 <malloc+0x4e>
}
    1833:	c9                   	leave  
    1834:	c3                   	ret    
