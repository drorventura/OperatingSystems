
_zombie:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
    1009:	e8 75 02 00 00       	call   1283 <fork>
    100e:	85 c0                	test   %eax,%eax
    1010:	7e 0c                	jle    101e <main+0x1e>
    sleep(5);  // Let child exit before parent.
    1012:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
    1019:	e8 fd 02 00 00       	call   131b <sleep>
  exit();
    101e:	e8 68 02 00 00       	call   128b <exit>

00001023 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1023:	55                   	push   %ebp
    1024:	89 e5                	mov    %esp,%ebp
    1026:	57                   	push   %edi
    1027:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1028:	8b 4d 08             	mov    0x8(%ebp),%ecx
    102b:	8b 55 10             	mov    0x10(%ebp),%edx
    102e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1031:	89 cb                	mov    %ecx,%ebx
    1033:	89 df                	mov    %ebx,%edi
    1035:	89 d1                	mov    %edx,%ecx
    1037:	fc                   	cld    
    1038:	f3 aa                	rep stos %al,%es:(%edi)
    103a:	89 ca                	mov    %ecx,%edx
    103c:	89 fb                	mov    %edi,%ebx
    103e:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1041:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1044:	5b                   	pop    %ebx
    1045:	5f                   	pop    %edi
    1046:	5d                   	pop    %ebp
    1047:	c3                   	ret    

00001048 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1048:	55                   	push   %ebp
    1049:	89 e5                	mov    %esp,%ebp
    104b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    104e:	8b 45 08             	mov    0x8(%ebp),%eax
    1051:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1054:	90                   	nop
    1055:	8b 45 08             	mov    0x8(%ebp),%eax
    1058:	8d 50 01             	lea    0x1(%eax),%edx
    105b:	89 55 08             	mov    %edx,0x8(%ebp)
    105e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1061:	8d 4a 01             	lea    0x1(%edx),%ecx
    1064:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1067:	0f b6 12             	movzbl (%edx),%edx
    106a:	88 10                	mov    %dl,(%eax)
    106c:	0f b6 00             	movzbl (%eax),%eax
    106f:	84 c0                	test   %al,%al
    1071:	75 e2                	jne    1055 <strcpy+0xd>
    ;
  return os;
    1073:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1076:	c9                   	leave  
    1077:	c3                   	ret    

00001078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1078:	55                   	push   %ebp
    1079:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    107b:	eb 08                	jmp    1085 <strcmp+0xd>
    p++, q++;
    107d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1081:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1085:	8b 45 08             	mov    0x8(%ebp),%eax
    1088:	0f b6 00             	movzbl (%eax),%eax
    108b:	84 c0                	test   %al,%al
    108d:	74 10                	je     109f <strcmp+0x27>
    108f:	8b 45 08             	mov    0x8(%ebp),%eax
    1092:	0f b6 10             	movzbl (%eax),%edx
    1095:	8b 45 0c             	mov    0xc(%ebp),%eax
    1098:	0f b6 00             	movzbl (%eax),%eax
    109b:	38 c2                	cmp    %al,%dl
    109d:	74 de                	je     107d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    109f:	8b 45 08             	mov    0x8(%ebp),%eax
    10a2:	0f b6 00             	movzbl (%eax),%eax
    10a5:	0f b6 d0             	movzbl %al,%edx
    10a8:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ab:	0f b6 00             	movzbl (%eax),%eax
    10ae:	0f b6 c0             	movzbl %al,%eax
    10b1:	29 c2                	sub    %eax,%edx
    10b3:	89 d0                	mov    %edx,%eax
}
    10b5:	5d                   	pop    %ebp
    10b6:	c3                   	ret    

000010b7 <strlen>:

uint
strlen(char *s)
{
    10b7:	55                   	push   %ebp
    10b8:	89 e5                	mov    %esp,%ebp
    10ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    10c4:	eb 04                	jmp    10ca <strlen+0x13>
    10c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    10ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10cd:	8b 45 08             	mov    0x8(%ebp),%eax
    10d0:	01 d0                	add    %edx,%eax
    10d2:	0f b6 00             	movzbl (%eax),%eax
    10d5:	84 c0                	test   %al,%al
    10d7:	75 ed                	jne    10c6 <strlen+0xf>
    ;
  return n;
    10d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10dc:	c9                   	leave  
    10dd:	c3                   	ret    

000010de <memset>:

void*
memset(void *dst, int c, uint n)
{
    10de:	55                   	push   %ebp
    10df:	89 e5                	mov    %esp,%ebp
    10e1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    10e4:	8b 45 10             	mov    0x10(%ebp),%eax
    10e7:	89 44 24 08          	mov    %eax,0x8(%esp)
    10eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ee:	89 44 24 04          	mov    %eax,0x4(%esp)
    10f2:	8b 45 08             	mov    0x8(%ebp),%eax
    10f5:	89 04 24             	mov    %eax,(%esp)
    10f8:	e8 26 ff ff ff       	call   1023 <stosb>
  return dst;
    10fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1100:	c9                   	leave  
    1101:	c3                   	ret    

00001102 <strchr>:

char*
strchr(const char *s, char c)
{
    1102:	55                   	push   %ebp
    1103:	89 e5                	mov    %esp,%ebp
    1105:	83 ec 04             	sub    $0x4,%esp
    1108:	8b 45 0c             	mov    0xc(%ebp),%eax
    110b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    110e:	eb 14                	jmp    1124 <strchr+0x22>
    if(*s == c)
    1110:	8b 45 08             	mov    0x8(%ebp),%eax
    1113:	0f b6 00             	movzbl (%eax),%eax
    1116:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1119:	75 05                	jne    1120 <strchr+0x1e>
      return (char*)s;
    111b:	8b 45 08             	mov    0x8(%ebp),%eax
    111e:	eb 13                	jmp    1133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1124:	8b 45 08             	mov    0x8(%ebp),%eax
    1127:	0f b6 00             	movzbl (%eax),%eax
    112a:	84 c0                	test   %al,%al
    112c:	75 e2                	jne    1110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    112e:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1133:	c9                   	leave  
    1134:	c3                   	ret    

00001135 <gets>:

char*
gets(char *buf, int max)
{
    1135:	55                   	push   %ebp
    1136:	89 e5                	mov    %esp,%ebp
    1138:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1142:	eb 4c                	jmp    1190 <gets+0x5b>
    cc = read(0, &c, 1);
    1144:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    114b:	00 
    114c:	8d 45 ef             	lea    -0x11(%ebp),%eax
    114f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    115a:	e8 44 01 00 00       	call   12a3 <read>
    115f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1166:	7f 02                	jg     116a <gets+0x35>
      break;
    1168:	eb 31                	jmp    119b <gets+0x66>
    buf[i++] = c;
    116a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    116d:	8d 50 01             	lea    0x1(%eax),%edx
    1170:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1173:	89 c2                	mov    %eax,%edx
    1175:	8b 45 08             	mov    0x8(%ebp),%eax
    1178:	01 c2                	add    %eax,%edx
    117a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    117e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1180:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1184:	3c 0a                	cmp    $0xa,%al
    1186:	74 13                	je     119b <gets+0x66>
    1188:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    118c:	3c 0d                	cmp    $0xd,%al
    118e:	74 0b                	je     119b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1190:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1193:	83 c0 01             	add    $0x1,%eax
    1196:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1199:	7c a9                	jl     1144 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    119b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    119e:	8b 45 08             	mov    0x8(%ebp),%eax
    11a1:	01 d0                	add    %edx,%eax
    11a3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11a9:	c9                   	leave  
    11aa:	c3                   	ret    

000011ab <stat>:

int
stat(char *n, struct stat *st)
{
    11ab:	55                   	push   %ebp
    11ac:	89 e5                	mov    %esp,%ebp
    11ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11b8:	00 
    11b9:	8b 45 08             	mov    0x8(%ebp),%eax
    11bc:	89 04 24             	mov    %eax,(%esp)
    11bf:	e8 07 01 00 00       	call   12cb <open>
    11c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11cb:	79 07                	jns    11d4 <stat+0x29>
    return -1;
    11cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11d2:	eb 23                	jmp    11f7 <stat+0x4c>
  r = fstat(fd, st);
    11d4:	8b 45 0c             	mov    0xc(%ebp),%eax
    11d7:	89 44 24 04          	mov    %eax,0x4(%esp)
    11db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11de:	89 04 24             	mov    %eax,(%esp)
    11e1:	e8 fd 00 00 00       	call   12e3 <fstat>
    11e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    11e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ec:	89 04 24             	mov    %eax,(%esp)
    11ef:	e8 bf 00 00 00       	call   12b3 <close>
  return r;
    11f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    11f7:	c9                   	leave  
    11f8:	c3                   	ret    

000011f9 <atoi>:

int
atoi(const char *s)
{
    11f9:	55                   	push   %ebp
    11fa:	89 e5                	mov    %esp,%ebp
    11fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    11ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1206:	eb 25                	jmp    122d <atoi+0x34>
    n = n*10 + *s++ - '0';
    1208:	8b 55 fc             	mov    -0x4(%ebp),%edx
    120b:	89 d0                	mov    %edx,%eax
    120d:	c1 e0 02             	shl    $0x2,%eax
    1210:	01 d0                	add    %edx,%eax
    1212:	01 c0                	add    %eax,%eax
    1214:	89 c1                	mov    %eax,%ecx
    1216:	8b 45 08             	mov    0x8(%ebp),%eax
    1219:	8d 50 01             	lea    0x1(%eax),%edx
    121c:	89 55 08             	mov    %edx,0x8(%ebp)
    121f:	0f b6 00             	movzbl (%eax),%eax
    1222:	0f be c0             	movsbl %al,%eax
    1225:	01 c8                	add    %ecx,%eax
    1227:	83 e8 30             	sub    $0x30,%eax
    122a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    122d:	8b 45 08             	mov    0x8(%ebp),%eax
    1230:	0f b6 00             	movzbl (%eax),%eax
    1233:	3c 2f                	cmp    $0x2f,%al
    1235:	7e 0a                	jle    1241 <atoi+0x48>
    1237:	8b 45 08             	mov    0x8(%ebp),%eax
    123a:	0f b6 00             	movzbl (%eax),%eax
    123d:	3c 39                	cmp    $0x39,%al
    123f:	7e c7                	jle    1208 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1241:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1244:	c9                   	leave  
    1245:	c3                   	ret    

00001246 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1246:	55                   	push   %ebp
    1247:	89 e5                	mov    %esp,%ebp
    1249:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    124c:	8b 45 08             	mov    0x8(%ebp),%eax
    124f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1252:	8b 45 0c             	mov    0xc(%ebp),%eax
    1255:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1258:	eb 17                	jmp    1271 <memmove+0x2b>
    *dst++ = *src++;
    125a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    125d:	8d 50 01             	lea    0x1(%eax),%edx
    1260:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1263:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1266:	8d 4a 01             	lea    0x1(%edx),%ecx
    1269:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    126c:	0f b6 12             	movzbl (%edx),%edx
    126f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1271:	8b 45 10             	mov    0x10(%ebp),%eax
    1274:	8d 50 ff             	lea    -0x1(%eax),%edx
    1277:	89 55 10             	mov    %edx,0x10(%ebp)
    127a:	85 c0                	test   %eax,%eax
    127c:	7f dc                	jg     125a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    127e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1281:	c9                   	leave  
    1282:	c3                   	ret    

00001283 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1283:	b8 01 00 00 00       	mov    $0x1,%eax
    1288:	cd 40                	int    $0x40
    128a:	c3                   	ret    

0000128b <exit>:
SYSCALL(exit)
    128b:	b8 02 00 00 00       	mov    $0x2,%eax
    1290:	cd 40                	int    $0x40
    1292:	c3                   	ret    

00001293 <wait>:
SYSCALL(wait)
    1293:	b8 03 00 00 00       	mov    $0x3,%eax
    1298:	cd 40                	int    $0x40
    129a:	c3                   	ret    

0000129b <pipe>:
SYSCALL(pipe)
    129b:	b8 04 00 00 00       	mov    $0x4,%eax
    12a0:	cd 40                	int    $0x40
    12a2:	c3                   	ret    

000012a3 <read>:
SYSCALL(read)
    12a3:	b8 05 00 00 00       	mov    $0x5,%eax
    12a8:	cd 40                	int    $0x40
    12aa:	c3                   	ret    

000012ab <write>:
SYSCALL(write)
    12ab:	b8 10 00 00 00       	mov    $0x10,%eax
    12b0:	cd 40                	int    $0x40
    12b2:	c3                   	ret    

000012b3 <close>:
SYSCALL(close)
    12b3:	b8 15 00 00 00       	mov    $0x15,%eax
    12b8:	cd 40                	int    $0x40
    12ba:	c3                   	ret    

000012bb <kill>:
SYSCALL(kill)
    12bb:	b8 06 00 00 00       	mov    $0x6,%eax
    12c0:	cd 40                	int    $0x40
    12c2:	c3                   	ret    

000012c3 <exec>:
SYSCALL(exec)
    12c3:	b8 07 00 00 00       	mov    $0x7,%eax
    12c8:	cd 40                	int    $0x40
    12ca:	c3                   	ret    

000012cb <open>:
SYSCALL(open)
    12cb:	b8 0f 00 00 00       	mov    $0xf,%eax
    12d0:	cd 40                	int    $0x40
    12d2:	c3                   	ret    

000012d3 <mknod>:
SYSCALL(mknod)
    12d3:	b8 11 00 00 00       	mov    $0x11,%eax
    12d8:	cd 40                	int    $0x40
    12da:	c3                   	ret    

000012db <unlink>:
SYSCALL(unlink)
    12db:	b8 12 00 00 00       	mov    $0x12,%eax
    12e0:	cd 40                	int    $0x40
    12e2:	c3                   	ret    

000012e3 <fstat>:
SYSCALL(fstat)
    12e3:	b8 08 00 00 00       	mov    $0x8,%eax
    12e8:	cd 40                	int    $0x40
    12ea:	c3                   	ret    

000012eb <link>:
SYSCALL(link)
    12eb:	b8 13 00 00 00       	mov    $0x13,%eax
    12f0:	cd 40                	int    $0x40
    12f2:	c3                   	ret    

000012f3 <mkdir>:
SYSCALL(mkdir)
    12f3:	b8 14 00 00 00       	mov    $0x14,%eax
    12f8:	cd 40                	int    $0x40
    12fa:	c3                   	ret    

000012fb <chdir>:
SYSCALL(chdir)
    12fb:	b8 09 00 00 00       	mov    $0x9,%eax
    1300:	cd 40                	int    $0x40
    1302:	c3                   	ret    

00001303 <dup>:
SYSCALL(dup)
    1303:	b8 0a 00 00 00       	mov    $0xa,%eax
    1308:	cd 40                	int    $0x40
    130a:	c3                   	ret    

0000130b <getpid>:
SYSCALL(getpid)
    130b:	b8 0b 00 00 00       	mov    $0xb,%eax
    1310:	cd 40                	int    $0x40
    1312:	c3                   	ret    

00001313 <sbrk>:
SYSCALL(sbrk)
    1313:	b8 0c 00 00 00       	mov    $0xc,%eax
    1318:	cd 40                	int    $0x40
    131a:	c3                   	ret    

0000131b <sleep>:
SYSCALL(sleep)
    131b:	b8 0d 00 00 00       	mov    $0xd,%eax
    1320:	cd 40                	int    $0x40
    1322:	c3                   	ret    

00001323 <uptime>:
SYSCALL(uptime)
    1323:	b8 0e 00 00 00       	mov    $0xe,%eax
    1328:	cd 40                	int    $0x40
    132a:	c3                   	ret    

0000132b <cowfork>:
SYSCALL(cowfork) //3.4
    132b:	b8 16 00 00 00       	mov    $0x16,%eax
    1330:	cd 40                	int    $0x40
    1332:	c3                   	ret    

00001333 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1333:	55                   	push   %ebp
    1334:	89 e5                	mov    %esp,%ebp
    1336:	83 ec 18             	sub    $0x18,%esp
    1339:	8b 45 0c             	mov    0xc(%ebp),%eax
    133c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    133f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1346:	00 
    1347:	8d 45 f4             	lea    -0xc(%ebp),%eax
    134a:	89 44 24 04          	mov    %eax,0x4(%esp)
    134e:	8b 45 08             	mov    0x8(%ebp),%eax
    1351:	89 04 24             	mov    %eax,(%esp)
    1354:	e8 52 ff ff ff       	call   12ab <write>
}
    1359:	c9                   	leave  
    135a:	c3                   	ret    

0000135b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    135b:	55                   	push   %ebp
    135c:	89 e5                	mov    %esp,%ebp
    135e:	56                   	push   %esi
    135f:	53                   	push   %ebx
    1360:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1363:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    136a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    136e:	74 17                	je     1387 <printint+0x2c>
    1370:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1374:	79 11                	jns    1387 <printint+0x2c>
    neg = 1;
    1376:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    137d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1380:	f7 d8                	neg    %eax
    1382:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1385:	eb 06                	jmp    138d <printint+0x32>
  } else {
    x = xx;
    1387:	8b 45 0c             	mov    0xc(%ebp),%eax
    138a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    138d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1394:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1397:	8d 41 01             	lea    0x1(%ecx),%eax
    139a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    139d:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13a3:	ba 00 00 00 00       	mov    $0x0,%edx
    13a8:	f7 f3                	div    %ebx
    13aa:	89 d0                	mov    %edx,%eax
    13ac:	0f b6 80 2c 2a 00 00 	movzbl 0x2a2c(%eax),%eax
    13b3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    13b7:	8b 75 10             	mov    0x10(%ebp),%esi
    13ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13bd:	ba 00 00 00 00       	mov    $0x0,%edx
    13c2:	f7 f6                	div    %esi
    13c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13cb:	75 c7                	jne    1394 <printint+0x39>
  if(neg)
    13cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13d1:	74 10                	je     13e3 <printint+0x88>
    buf[i++] = '-';
    13d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13d6:	8d 50 01             	lea    0x1(%eax),%edx
    13d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
    13dc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    13e1:	eb 1f                	jmp    1402 <printint+0xa7>
    13e3:	eb 1d                	jmp    1402 <printint+0xa7>
    putc(fd, buf[i]);
    13e5:	8d 55 dc             	lea    -0x24(%ebp),%edx
    13e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13eb:	01 d0                	add    %edx,%eax
    13ed:	0f b6 00             	movzbl (%eax),%eax
    13f0:	0f be c0             	movsbl %al,%eax
    13f3:	89 44 24 04          	mov    %eax,0x4(%esp)
    13f7:	8b 45 08             	mov    0x8(%ebp),%eax
    13fa:	89 04 24             	mov    %eax,(%esp)
    13fd:	e8 31 ff ff ff       	call   1333 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1402:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    140a:	79 d9                	jns    13e5 <printint+0x8a>
    putc(fd, buf[i]);
}
    140c:	83 c4 30             	add    $0x30,%esp
    140f:	5b                   	pop    %ebx
    1410:	5e                   	pop    %esi
    1411:	5d                   	pop    %ebp
    1412:	c3                   	ret    

00001413 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1413:	55                   	push   %ebp
    1414:	89 e5                	mov    %esp,%ebp
    1416:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1419:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1420:	8d 45 0c             	lea    0xc(%ebp),%eax
    1423:	83 c0 04             	add    $0x4,%eax
    1426:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1429:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1430:	e9 7c 01 00 00       	jmp    15b1 <printf+0x19e>
    c = fmt[i] & 0xff;
    1435:	8b 55 0c             	mov    0xc(%ebp),%edx
    1438:	8b 45 f0             	mov    -0x10(%ebp),%eax
    143b:	01 d0                	add    %edx,%eax
    143d:	0f b6 00             	movzbl (%eax),%eax
    1440:	0f be c0             	movsbl %al,%eax
    1443:	25 ff 00 00 00       	and    $0xff,%eax
    1448:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    144b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    144f:	75 2c                	jne    147d <printf+0x6a>
      if(c == '%'){
    1451:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1455:	75 0c                	jne    1463 <printf+0x50>
        state = '%';
    1457:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    145e:	e9 4a 01 00 00       	jmp    15ad <printf+0x19a>
      } else {
        putc(fd, c);
    1463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1466:	0f be c0             	movsbl %al,%eax
    1469:	89 44 24 04          	mov    %eax,0x4(%esp)
    146d:	8b 45 08             	mov    0x8(%ebp),%eax
    1470:	89 04 24             	mov    %eax,(%esp)
    1473:	e8 bb fe ff ff       	call   1333 <putc>
    1478:	e9 30 01 00 00       	jmp    15ad <printf+0x19a>
      }
    } else if(state == '%'){
    147d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1481:	0f 85 26 01 00 00    	jne    15ad <printf+0x19a>
      if(c == 'd'){
    1487:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    148b:	75 2d                	jne    14ba <printf+0xa7>
        printint(fd, *ap, 10, 1);
    148d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1490:	8b 00                	mov    (%eax),%eax
    1492:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1499:	00 
    149a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14a1:	00 
    14a2:	89 44 24 04          	mov    %eax,0x4(%esp)
    14a6:	8b 45 08             	mov    0x8(%ebp),%eax
    14a9:	89 04 24             	mov    %eax,(%esp)
    14ac:	e8 aa fe ff ff       	call   135b <printint>
        ap++;
    14b1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14b5:	e9 ec 00 00 00       	jmp    15a6 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    14ba:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14be:	74 06                	je     14c6 <printf+0xb3>
    14c0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14c4:	75 2d                	jne    14f3 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    14c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14c9:	8b 00                	mov    (%eax),%eax
    14cb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    14d2:	00 
    14d3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    14da:	00 
    14db:	89 44 24 04          	mov    %eax,0x4(%esp)
    14df:	8b 45 08             	mov    0x8(%ebp),%eax
    14e2:	89 04 24             	mov    %eax,(%esp)
    14e5:	e8 71 fe ff ff       	call   135b <printint>
        ap++;
    14ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14ee:	e9 b3 00 00 00       	jmp    15a6 <printf+0x193>
      } else if(c == 's'){
    14f3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    14f7:	75 45                	jne    153e <printf+0x12b>
        s = (char*)*ap;
    14f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14fc:	8b 00                	mov    (%eax),%eax
    14fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1501:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1509:	75 09                	jne    1514 <printf+0x101>
          s = "(null)";
    150b:	c7 45 f4 df 17 00 00 	movl   $0x17df,-0xc(%ebp)
        while(*s != 0){
    1512:	eb 1e                	jmp    1532 <printf+0x11f>
    1514:	eb 1c                	jmp    1532 <printf+0x11f>
          putc(fd, *s);
    1516:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1519:	0f b6 00             	movzbl (%eax),%eax
    151c:	0f be c0             	movsbl %al,%eax
    151f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1523:	8b 45 08             	mov    0x8(%ebp),%eax
    1526:	89 04 24             	mov    %eax,(%esp)
    1529:	e8 05 fe ff ff       	call   1333 <putc>
          s++;
    152e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1532:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1535:	0f b6 00             	movzbl (%eax),%eax
    1538:	84 c0                	test   %al,%al
    153a:	75 da                	jne    1516 <printf+0x103>
    153c:	eb 68                	jmp    15a6 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    153e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1542:	75 1d                	jne    1561 <printf+0x14e>
        putc(fd, *ap);
    1544:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1547:	8b 00                	mov    (%eax),%eax
    1549:	0f be c0             	movsbl %al,%eax
    154c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1550:	8b 45 08             	mov    0x8(%ebp),%eax
    1553:	89 04 24             	mov    %eax,(%esp)
    1556:	e8 d8 fd ff ff       	call   1333 <putc>
        ap++;
    155b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    155f:	eb 45                	jmp    15a6 <printf+0x193>
      } else if(c == '%'){
    1561:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1565:	75 17                	jne    157e <printf+0x16b>
        putc(fd, c);
    1567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    156a:	0f be c0             	movsbl %al,%eax
    156d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1571:	8b 45 08             	mov    0x8(%ebp),%eax
    1574:	89 04 24             	mov    %eax,(%esp)
    1577:	e8 b7 fd ff ff       	call   1333 <putc>
    157c:	eb 28                	jmp    15a6 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    157e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1585:	00 
    1586:	8b 45 08             	mov    0x8(%ebp),%eax
    1589:	89 04 24             	mov    %eax,(%esp)
    158c:	e8 a2 fd ff ff       	call   1333 <putc>
        putc(fd, c);
    1591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1594:	0f be c0             	movsbl %al,%eax
    1597:	89 44 24 04          	mov    %eax,0x4(%esp)
    159b:	8b 45 08             	mov    0x8(%ebp),%eax
    159e:	89 04 24             	mov    %eax,(%esp)
    15a1:	e8 8d fd ff ff       	call   1333 <putc>
      }
      state = 0;
    15a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15ad:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15b1:	8b 55 0c             	mov    0xc(%ebp),%edx
    15b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15b7:	01 d0                	add    %edx,%eax
    15b9:	0f b6 00             	movzbl (%eax),%eax
    15bc:	84 c0                	test   %al,%al
    15be:	0f 85 71 fe ff ff    	jne    1435 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15c4:	c9                   	leave  
    15c5:	c3                   	ret    

000015c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15c6:	55                   	push   %ebp
    15c7:	89 e5                	mov    %esp,%ebp
    15c9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15cc:	8b 45 08             	mov    0x8(%ebp),%eax
    15cf:	83 e8 08             	sub    $0x8,%eax
    15d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15d5:	a1 48 2a 00 00       	mov    0x2a48,%eax
    15da:	89 45 fc             	mov    %eax,-0x4(%ebp)
    15dd:	eb 24                	jmp    1603 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15df:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15e2:	8b 00                	mov    (%eax),%eax
    15e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15e7:	77 12                	ja     15fb <free+0x35>
    15e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15ef:	77 24                	ja     1615 <free+0x4f>
    15f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15f4:	8b 00                	mov    (%eax),%eax
    15f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    15f9:	77 1a                	ja     1615 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15fe:	8b 00                	mov    (%eax),%eax
    1600:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1603:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1606:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1609:	76 d4                	jbe    15df <free+0x19>
    160b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    160e:	8b 00                	mov    (%eax),%eax
    1610:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1613:	76 ca                	jbe    15df <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1615:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1618:	8b 40 04             	mov    0x4(%eax),%eax
    161b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1622:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1625:	01 c2                	add    %eax,%edx
    1627:	8b 45 fc             	mov    -0x4(%ebp),%eax
    162a:	8b 00                	mov    (%eax),%eax
    162c:	39 c2                	cmp    %eax,%edx
    162e:	75 24                	jne    1654 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1630:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1633:	8b 50 04             	mov    0x4(%eax),%edx
    1636:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1639:	8b 00                	mov    (%eax),%eax
    163b:	8b 40 04             	mov    0x4(%eax),%eax
    163e:	01 c2                	add    %eax,%edx
    1640:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1643:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1646:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1649:	8b 00                	mov    (%eax),%eax
    164b:	8b 10                	mov    (%eax),%edx
    164d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1650:	89 10                	mov    %edx,(%eax)
    1652:	eb 0a                	jmp    165e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1654:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1657:	8b 10                	mov    (%eax),%edx
    1659:	8b 45 f8             	mov    -0x8(%ebp),%eax
    165c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    165e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1661:	8b 40 04             	mov    0x4(%eax),%eax
    1664:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    166b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166e:	01 d0                	add    %edx,%eax
    1670:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1673:	75 20                	jne    1695 <free+0xcf>
    p->s.size += bp->s.size;
    1675:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1678:	8b 50 04             	mov    0x4(%eax),%edx
    167b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    167e:	8b 40 04             	mov    0x4(%eax),%eax
    1681:	01 c2                	add    %eax,%edx
    1683:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1686:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1689:	8b 45 f8             	mov    -0x8(%ebp),%eax
    168c:	8b 10                	mov    (%eax),%edx
    168e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1691:	89 10                	mov    %edx,(%eax)
    1693:	eb 08                	jmp    169d <free+0xd7>
  } else
    p->s.ptr = bp;
    1695:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1698:	8b 55 f8             	mov    -0x8(%ebp),%edx
    169b:	89 10                	mov    %edx,(%eax)
  freep = p;
    169d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a0:	a3 48 2a 00 00       	mov    %eax,0x2a48
}
    16a5:	c9                   	leave  
    16a6:	c3                   	ret    

000016a7 <morecore>:

static Header*
morecore(uint nu)
{
    16a7:	55                   	push   %ebp
    16a8:	89 e5                	mov    %esp,%ebp
    16aa:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16ad:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16b4:	77 07                	ja     16bd <morecore+0x16>
    nu = 4096;
    16b6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    16bd:	8b 45 08             	mov    0x8(%ebp),%eax
    16c0:	c1 e0 03             	shl    $0x3,%eax
    16c3:	89 04 24             	mov    %eax,(%esp)
    16c6:	e8 48 fc ff ff       	call   1313 <sbrk>
    16cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    16ce:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    16d2:	75 07                	jne    16db <morecore+0x34>
    return 0;
    16d4:	b8 00 00 00 00       	mov    $0x0,%eax
    16d9:	eb 22                	jmp    16fd <morecore+0x56>
  hp = (Header*)p;
    16db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    16e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16e4:	8b 55 08             	mov    0x8(%ebp),%edx
    16e7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    16ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16ed:	83 c0 08             	add    $0x8,%eax
    16f0:	89 04 24             	mov    %eax,(%esp)
    16f3:	e8 ce fe ff ff       	call   15c6 <free>
  return freep;
    16f8:	a1 48 2a 00 00       	mov    0x2a48,%eax
}
    16fd:	c9                   	leave  
    16fe:	c3                   	ret    

000016ff <malloc>:

void*
malloc(uint nbytes)
{
    16ff:	55                   	push   %ebp
    1700:	89 e5                	mov    %esp,%ebp
    1702:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1705:	8b 45 08             	mov    0x8(%ebp),%eax
    1708:	83 c0 07             	add    $0x7,%eax
    170b:	c1 e8 03             	shr    $0x3,%eax
    170e:	83 c0 01             	add    $0x1,%eax
    1711:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1714:	a1 48 2a 00 00       	mov    0x2a48,%eax
    1719:	89 45 f0             	mov    %eax,-0x10(%ebp)
    171c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1720:	75 23                	jne    1745 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1722:	c7 45 f0 40 2a 00 00 	movl   $0x2a40,-0x10(%ebp)
    1729:	8b 45 f0             	mov    -0x10(%ebp),%eax
    172c:	a3 48 2a 00 00       	mov    %eax,0x2a48
    1731:	a1 48 2a 00 00       	mov    0x2a48,%eax
    1736:	a3 40 2a 00 00       	mov    %eax,0x2a40
    base.s.size = 0;
    173b:	c7 05 44 2a 00 00 00 	movl   $0x0,0x2a44
    1742:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1745:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1748:	8b 00                	mov    (%eax),%eax
    174a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    174d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1750:	8b 40 04             	mov    0x4(%eax),%eax
    1753:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1756:	72 4d                	jb     17a5 <malloc+0xa6>
      if(p->s.size == nunits)
    1758:	8b 45 f4             	mov    -0xc(%ebp),%eax
    175b:	8b 40 04             	mov    0x4(%eax),%eax
    175e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1761:	75 0c                	jne    176f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1763:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1766:	8b 10                	mov    (%eax),%edx
    1768:	8b 45 f0             	mov    -0x10(%ebp),%eax
    176b:	89 10                	mov    %edx,(%eax)
    176d:	eb 26                	jmp    1795 <malloc+0x96>
      else {
        p->s.size -= nunits;
    176f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1772:	8b 40 04             	mov    0x4(%eax),%eax
    1775:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1778:	89 c2                	mov    %eax,%edx
    177a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    177d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1780:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1783:	8b 40 04             	mov    0x4(%eax),%eax
    1786:	c1 e0 03             	shl    $0x3,%eax
    1789:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    178c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    178f:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1792:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1795:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1798:	a3 48 2a 00 00       	mov    %eax,0x2a48
      return (void*)(p + 1);
    179d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a0:	83 c0 08             	add    $0x8,%eax
    17a3:	eb 38                	jmp    17dd <malloc+0xde>
    }
    if(p == freep)
    17a5:	a1 48 2a 00 00       	mov    0x2a48,%eax
    17aa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17ad:	75 1b                	jne    17ca <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    17af:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17b2:	89 04 24             	mov    %eax,(%esp)
    17b5:	e8 ed fe ff ff       	call   16a7 <morecore>
    17ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17c1:	75 07                	jne    17ca <malloc+0xcb>
        return 0;
    17c3:	b8 00 00 00 00       	mov    $0x0,%eax
    17c8:	eb 13                	jmp    17dd <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d3:	8b 00                	mov    (%eax),%eax
    17d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    17d8:	e9 70 ff ff ff       	jmp    174d <malloc+0x4e>
}
    17dd:	c9                   	leave  
    17de:	c3                   	ret    
