
_mkdir:     file format elf32-i386


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

  if(argc < 2){
    1009:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    100d:	7f 19                	jg     1028 <main+0x28>
    printf(2, "Usage: mkdir files...\n");
    100f:	c7 44 24 04 4b 18 00 	movl   $0x184b,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    101e:	e8 5c 04 00 00       	call   147f <printf>
    exit();
    1023:	e8 cf 02 00 00       	call   12f7 <exit>
  }

  for(i = 1; i < argc; i++){
    1028:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    102f:	00 
    1030:	eb 4f                	jmp    1081 <main+0x81>
    if(mkdir(argv[i]) < 0){
    1032:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1036:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    103d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1040:	01 d0                	add    %edx,%eax
    1042:	8b 00                	mov    (%eax),%eax
    1044:	89 04 24             	mov    %eax,(%esp)
    1047:	e8 13 03 00 00       	call   135f <mkdir>
    104c:	85 c0                	test   %eax,%eax
    104e:	79 2c                	jns    107c <main+0x7c>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
    1050:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1054:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    105b:	8b 45 0c             	mov    0xc(%ebp),%eax
    105e:	01 d0                	add    %edx,%eax
    1060:	8b 00                	mov    (%eax),%eax
    1062:	89 44 24 08          	mov    %eax,0x8(%esp)
    1066:	c7 44 24 04 62 18 00 	movl   $0x1862,0x4(%esp)
    106d:	00 
    106e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1075:	e8 05 04 00 00       	call   147f <printf>
      break;
    107a:	eb 0e                	jmp    108a <main+0x8a>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
    107c:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    1081:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1085:	3b 45 08             	cmp    0x8(%ebp),%eax
    1088:	7c a8                	jl     1032 <main+0x32>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
    108a:	e8 68 02 00 00       	call   12f7 <exit>

0000108f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    108f:	55                   	push   %ebp
    1090:	89 e5                	mov    %esp,%ebp
    1092:	57                   	push   %edi
    1093:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1094:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1097:	8b 55 10             	mov    0x10(%ebp),%edx
    109a:	8b 45 0c             	mov    0xc(%ebp),%eax
    109d:	89 cb                	mov    %ecx,%ebx
    109f:	89 df                	mov    %ebx,%edi
    10a1:	89 d1                	mov    %edx,%ecx
    10a3:	fc                   	cld    
    10a4:	f3 aa                	rep stos %al,%es:(%edi)
    10a6:	89 ca                	mov    %ecx,%edx
    10a8:	89 fb                	mov    %edi,%ebx
    10aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
    10ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10b0:	5b                   	pop    %ebx
    10b1:	5f                   	pop    %edi
    10b2:	5d                   	pop    %ebp
    10b3:	c3                   	ret    

000010b4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10b4:	55                   	push   %ebp
    10b5:	89 e5                	mov    %esp,%ebp
    10b7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10ba:	8b 45 08             	mov    0x8(%ebp),%eax
    10bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10c0:	90                   	nop
    10c1:	8b 45 08             	mov    0x8(%ebp),%eax
    10c4:	8d 50 01             	lea    0x1(%eax),%edx
    10c7:	89 55 08             	mov    %edx,0x8(%ebp)
    10ca:	8b 55 0c             	mov    0xc(%ebp),%edx
    10cd:	8d 4a 01             	lea    0x1(%edx),%ecx
    10d0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10d3:	0f b6 12             	movzbl (%edx),%edx
    10d6:	88 10                	mov    %dl,(%eax)
    10d8:	0f b6 00             	movzbl (%eax),%eax
    10db:	84 c0                	test   %al,%al
    10dd:	75 e2                	jne    10c1 <strcpy+0xd>
    ;
  return os;
    10df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10e2:	c9                   	leave  
    10e3:	c3                   	ret    

000010e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10e4:	55                   	push   %ebp
    10e5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10e7:	eb 08                	jmp    10f1 <strcmp+0xd>
    p++, q++;
    10e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10ed:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10f1:	8b 45 08             	mov    0x8(%ebp),%eax
    10f4:	0f b6 00             	movzbl (%eax),%eax
    10f7:	84 c0                	test   %al,%al
    10f9:	74 10                	je     110b <strcmp+0x27>
    10fb:	8b 45 08             	mov    0x8(%ebp),%eax
    10fe:	0f b6 10             	movzbl (%eax),%edx
    1101:	8b 45 0c             	mov    0xc(%ebp),%eax
    1104:	0f b6 00             	movzbl (%eax),%eax
    1107:	38 c2                	cmp    %al,%dl
    1109:	74 de                	je     10e9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    110b:	8b 45 08             	mov    0x8(%ebp),%eax
    110e:	0f b6 00             	movzbl (%eax),%eax
    1111:	0f b6 d0             	movzbl %al,%edx
    1114:	8b 45 0c             	mov    0xc(%ebp),%eax
    1117:	0f b6 00             	movzbl (%eax),%eax
    111a:	0f b6 c0             	movzbl %al,%eax
    111d:	29 c2                	sub    %eax,%edx
    111f:	89 d0                	mov    %edx,%eax
}
    1121:	5d                   	pop    %ebp
    1122:	c3                   	ret    

00001123 <strlen>:

uint
strlen(char *s)
{
    1123:	55                   	push   %ebp
    1124:	89 e5                	mov    %esp,%ebp
    1126:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1129:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1130:	eb 04                	jmp    1136 <strlen+0x13>
    1132:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1136:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1139:	8b 45 08             	mov    0x8(%ebp),%eax
    113c:	01 d0                	add    %edx,%eax
    113e:	0f b6 00             	movzbl (%eax),%eax
    1141:	84 c0                	test   %al,%al
    1143:	75 ed                	jne    1132 <strlen+0xf>
    ;
  return n;
    1145:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1148:	c9                   	leave  
    1149:	c3                   	ret    

0000114a <memset>:

void*
memset(void *dst, int c, uint n)
{
    114a:	55                   	push   %ebp
    114b:	89 e5                	mov    %esp,%ebp
    114d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1150:	8b 45 10             	mov    0x10(%ebp),%eax
    1153:	89 44 24 08          	mov    %eax,0x8(%esp)
    1157:	8b 45 0c             	mov    0xc(%ebp),%eax
    115a:	89 44 24 04          	mov    %eax,0x4(%esp)
    115e:	8b 45 08             	mov    0x8(%ebp),%eax
    1161:	89 04 24             	mov    %eax,(%esp)
    1164:	e8 26 ff ff ff       	call   108f <stosb>
  return dst;
    1169:	8b 45 08             	mov    0x8(%ebp),%eax
}
    116c:	c9                   	leave  
    116d:	c3                   	ret    

0000116e <strchr>:

char*
strchr(const char *s, char c)
{
    116e:	55                   	push   %ebp
    116f:	89 e5                	mov    %esp,%ebp
    1171:	83 ec 04             	sub    $0x4,%esp
    1174:	8b 45 0c             	mov    0xc(%ebp),%eax
    1177:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    117a:	eb 14                	jmp    1190 <strchr+0x22>
    if(*s == c)
    117c:	8b 45 08             	mov    0x8(%ebp),%eax
    117f:	0f b6 00             	movzbl (%eax),%eax
    1182:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1185:	75 05                	jne    118c <strchr+0x1e>
      return (char*)s;
    1187:	8b 45 08             	mov    0x8(%ebp),%eax
    118a:	eb 13                	jmp    119f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    118c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1190:	8b 45 08             	mov    0x8(%ebp),%eax
    1193:	0f b6 00             	movzbl (%eax),%eax
    1196:	84 c0                	test   %al,%al
    1198:	75 e2                	jne    117c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    119a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    119f:	c9                   	leave  
    11a0:	c3                   	ret    

000011a1 <gets>:

char*
gets(char *buf, int max)
{
    11a1:	55                   	push   %ebp
    11a2:	89 e5                	mov    %esp,%ebp
    11a4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11ae:	eb 4c                	jmp    11fc <gets+0x5b>
    cc = read(0, &c, 1);
    11b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    11b7:	00 
    11b8:	8d 45 ef             	lea    -0x11(%ebp),%eax
    11bb:	89 44 24 04          	mov    %eax,0x4(%esp)
    11bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11c6:	e8 44 01 00 00       	call   130f <read>
    11cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11d2:	7f 02                	jg     11d6 <gets+0x35>
      break;
    11d4:	eb 31                	jmp    1207 <gets+0x66>
    buf[i++] = c;
    11d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11d9:	8d 50 01             	lea    0x1(%eax),%edx
    11dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11df:	89 c2                	mov    %eax,%edx
    11e1:	8b 45 08             	mov    0x8(%ebp),%eax
    11e4:	01 c2                	add    %eax,%edx
    11e6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11ea:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11f0:	3c 0a                	cmp    $0xa,%al
    11f2:	74 13                	je     1207 <gets+0x66>
    11f4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11f8:	3c 0d                	cmp    $0xd,%al
    11fa:	74 0b                	je     1207 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ff:	83 c0 01             	add    $0x1,%eax
    1202:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1205:	7c a9                	jl     11b0 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1207:	8b 55 f4             	mov    -0xc(%ebp),%edx
    120a:	8b 45 08             	mov    0x8(%ebp),%eax
    120d:	01 d0                	add    %edx,%eax
    120f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1212:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1215:	c9                   	leave  
    1216:	c3                   	ret    

00001217 <stat>:

int
stat(char *n, struct stat *st)
{
    1217:	55                   	push   %ebp
    1218:	89 e5                	mov    %esp,%ebp
    121a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    121d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1224:	00 
    1225:	8b 45 08             	mov    0x8(%ebp),%eax
    1228:	89 04 24             	mov    %eax,(%esp)
    122b:	e8 07 01 00 00       	call   1337 <open>
    1230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1237:	79 07                	jns    1240 <stat+0x29>
    return -1;
    1239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    123e:	eb 23                	jmp    1263 <stat+0x4c>
  r = fstat(fd, st);
    1240:	8b 45 0c             	mov    0xc(%ebp),%eax
    1243:	89 44 24 04          	mov    %eax,0x4(%esp)
    1247:	8b 45 f4             	mov    -0xc(%ebp),%eax
    124a:	89 04 24             	mov    %eax,(%esp)
    124d:	e8 fd 00 00 00       	call   134f <fstat>
    1252:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1255:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1258:	89 04 24             	mov    %eax,(%esp)
    125b:	e8 bf 00 00 00       	call   131f <close>
  return r;
    1260:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1263:	c9                   	leave  
    1264:	c3                   	ret    

00001265 <atoi>:

int
atoi(const char *s)
{
    1265:	55                   	push   %ebp
    1266:	89 e5                	mov    %esp,%ebp
    1268:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1272:	eb 25                	jmp    1299 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1274:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1277:	89 d0                	mov    %edx,%eax
    1279:	c1 e0 02             	shl    $0x2,%eax
    127c:	01 d0                	add    %edx,%eax
    127e:	01 c0                	add    %eax,%eax
    1280:	89 c1                	mov    %eax,%ecx
    1282:	8b 45 08             	mov    0x8(%ebp),%eax
    1285:	8d 50 01             	lea    0x1(%eax),%edx
    1288:	89 55 08             	mov    %edx,0x8(%ebp)
    128b:	0f b6 00             	movzbl (%eax),%eax
    128e:	0f be c0             	movsbl %al,%eax
    1291:	01 c8                	add    %ecx,%eax
    1293:	83 e8 30             	sub    $0x30,%eax
    1296:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1299:	8b 45 08             	mov    0x8(%ebp),%eax
    129c:	0f b6 00             	movzbl (%eax),%eax
    129f:	3c 2f                	cmp    $0x2f,%al
    12a1:	7e 0a                	jle    12ad <atoi+0x48>
    12a3:	8b 45 08             	mov    0x8(%ebp),%eax
    12a6:	0f b6 00             	movzbl (%eax),%eax
    12a9:	3c 39                	cmp    $0x39,%al
    12ab:	7e c7                	jle    1274 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    12ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    12b0:	c9                   	leave  
    12b1:	c3                   	ret    

000012b2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    12b2:	55                   	push   %ebp
    12b3:	89 e5                	mov    %esp,%ebp
    12b5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    12b8:	8b 45 08             	mov    0x8(%ebp),%eax
    12bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    12be:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12c4:	eb 17                	jmp    12dd <memmove+0x2b>
    *dst++ = *src++;
    12c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c9:	8d 50 01             	lea    0x1(%eax),%edx
    12cc:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12cf:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12d2:	8d 4a 01             	lea    0x1(%edx),%ecx
    12d5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12d8:	0f b6 12             	movzbl (%edx),%edx
    12db:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12dd:	8b 45 10             	mov    0x10(%ebp),%eax
    12e0:	8d 50 ff             	lea    -0x1(%eax),%edx
    12e3:	89 55 10             	mov    %edx,0x10(%ebp)
    12e6:	85 c0                	test   %eax,%eax
    12e8:	7f dc                	jg     12c6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12ed:	c9                   	leave  
    12ee:	c3                   	ret    

000012ef <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12ef:	b8 01 00 00 00       	mov    $0x1,%eax
    12f4:	cd 40                	int    $0x40
    12f6:	c3                   	ret    

000012f7 <exit>:
SYSCALL(exit)
    12f7:	b8 02 00 00 00       	mov    $0x2,%eax
    12fc:	cd 40                	int    $0x40
    12fe:	c3                   	ret    

000012ff <wait>:
SYSCALL(wait)
    12ff:	b8 03 00 00 00       	mov    $0x3,%eax
    1304:	cd 40                	int    $0x40
    1306:	c3                   	ret    

00001307 <pipe>:
SYSCALL(pipe)
    1307:	b8 04 00 00 00       	mov    $0x4,%eax
    130c:	cd 40                	int    $0x40
    130e:	c3                   	ret    

0000130f <read>:
SYSCALL(read)
    130f:	b8 05 00 00 00       	mov    $0x5,%eax
    1314:	cd 40                	int    $0x40
    1316:	c3                   	ret    

00001317 <write>:
SYSCALL(write)
    1317:	b8 10 00 00 00       	mov    $0x10,%eax
    131c:	cd 40                	int    $0x40
    131e:	c3                   	ret    

0000131f <close>:
SYSCALL(close)
    131f:	b8 15 00 00 00       	mov    $0x15,%eax
    1324:	cd 40                	int    $0x40
    1326:	c3                   	ret    

00001327 <kill>:
SYSCALL(kill)
    1327:	b8 06 00 00 00       	mov    $0x6,%eax
    132c:	cd 40                	int    $0x40
    132e:	c3                   	ret    

0000132f <exec>:
SYSCALL(exec)
    132f:	b8 07 00 00 00       	mov    $0x7,%eax
    1334:	cd 40                	int    $0x40
    1336:	c3                   	ret    

00001337 <open>:
SYSCALL(open)
    1337:	b8 0f 00 00 00       	mov    $0xf,%eax
    133c:	cd 40                	int    $0x40
    133e:	c3                   	ret    

0000133f <mknod>:
SYSCALL(mknod)
    133f:	b8 11 00 00 00       	mov    $0x11,%eax
    1344:	cd 40                	int    $0x40
    1346:	c3                   	ret    

00001347 <unlink>:
SYSCALL(unlink)
    1347:	b8 12 00 00 00       	mov    $0x12,%eax
    134c:	cd 40                	int    $0x40
    134e:	c3                   	ret    

0000134f <fstat>:
SYSCALL(fstat)
    134f:	b8 08 00 00 00       	mov    $0x8,%eax
    1354:	cd 40                	int    $0x40
    1356:	c3                   	ret    

00001357 <link>:
SYSCALL(link)
    1357:	b8 13 00 00 00       	mov    $0x13,%eax
    135c:	cd 40                	int    $0x40
    135e:	c3                   	ret    

0000135f <mkdir>:
SYSCALL(mkdir)
    135f:	b8 14 00 00 00       	mov    $0x14,%eax
    1364:	cd 40                	int    $0x40
    1366:	c3                   	ret    

00001367 <chdir>:
SYSCALL(chdir)
    1367:	b8 09 00 00 00       	mov    $0x9,%eax
    136c:	cd 40                	int    $0x40
    136e:	c3                   	ret    

0000136f <dup>:
SYSCALL(dup)
    136f:	b8 0a 00 00 00       	mov    $0xa,%eax
    1374:	cd 40                	int    $0x40
    1376:	c3                   	ret    

00001377 <getpid>:
SYSCALL(getpid)
    1377:	b8 0b 00 00 00       	mov    $0xb,%eax
    137c:	cd 40                	int    $0x40
    137e:	c3                   	ret    

0000137f <sbrk>:
SYSCALL(sbrk)
    137f:	b8 0c 00 00 00       	mov    $0xc,%eax
    1384:	cd 40                	int    $0x40
    1386:	c3                   	ret    

00001387 <sleep>:
SYSCALL(sleep)
    1387:	b8 0d 00 00 00       	mov    $0xd,%eax
    138c:	cd 40                	int    $0x40
    138e:	c3                   	ret    

0000138f <uptime>:
SYSCALL(uptime)
    138f:	b8 0e 00 00 00       	mov    $0xe,%eax
    1394:	cd 40                	int    $0x40
    1396:	c3                   	ret    

00001397 <cowfork>:
SYSCALL(cowfork) //3.4
    1397:	b8 16 00 00 00       	mov    $0x16,%eax
    139c:	cd 40                	int    $0x40
    139e:	c3                   	ret    

0000139f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    139f:	55                   	push   %ebp
    13a0:	89 e5                	mov    %esp,%ebp
    13a2:	83 ec 18             	sub    $0x18,%esp
    13a5:	8b 45 0c             	mov    0xc(%ebp),%eax
    13a8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    13ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13b2:	00 
    13b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
    13b6:	89 44 24 04          	mov    %eax,0x4(%esp)
    13ba:	8b 45 08             	mov    0x8(%ebp),%eax
    13bd:	89 04 24             	mov    %eax,(%esp)
    13c0:	e8 52 ff ff ff       	call   1317 <write>
}
    13c5:	c9                   	leave  
    13c6:	c3                   	ret    

000013c7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13c7:	55                   	push   %ebp
    13c8:	89 e5                	mov    %esp,%ebp
    13ca:	56                   	push   %esi
    13cb:	53                   	push   %ebx
    13cc:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13d6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13da:	74 17                	je     13f3 <printint+0x2c>
    13dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13e0:	79 11                	jns    13f3 <printint+0x2c>
    neg = 1;
    13e2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13e9:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ec:	f7 d8                	neg    %eax
    13ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13f1:	eb 06                	jmp    13f9 <printint+0x32>
  } else {
    x = xx;
    13f3:	8b 45 0c             	mov    0xc(%ebp),%eax
    13f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1400:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1403:	8d 41 01             	lea    0x1(%ecx),%eax
    1406:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1409:	8b 5d 10             	mov    0x10(%ebp),%ebx
    140c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    140f:	ba 00 00 00 00       	mov    $0x0,%edx
    1414:	f7 f3                	div    %ebx
    1416:	89 d0                	mov    %edx,%eax
    1418:	0f b6 80 cc 2a 00 00 	movzbl 0x2acc(%eax),%eax
    141f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1423:	8b 75 10             	mov    0x10(%ebp),%esi
    1426:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1429:	ba 00 00 00 00       	mov    $0x0,%edx
    142e:	f7 f6                	div    %esi
    1430:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1433:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1437:	75 c7                	jne    1400 <printint+0x39>
  if(neg)
    1439:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    143d:	74 10                	je     144f <printint+0x88>
    buf[i++] = '-';
    143f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1442:	8d 50 01             	lea    0x1(%eax),%edx
    1445:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1448:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    144d:	eb 1f                	jmp    146e <printint+0xa7>
    144f:	eb 1d                	jmp    146e <printint+0xa7>
    putc(fd, buf[i]);
    1451:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1454:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1457:	01 d0                	add    %edx,%eax
    1459:	0f b6 00             	movzbl (%eax),%eax
    145c:	0f be c0             	movsbl %al,%eax
    145f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1463:	8b 45 08             	mov    0x8(%ebp),%eax
    1466:	89 04 24             	mov    %eax,(%esp)
    1469:	e8 31 ff ff ff       	call   139f <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    146e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1472:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1476:	79 d9                	jns    1451 <printint+0x8a>
    putc(fd, buf[i]);
}
    1478:	83 c4 30             	add    $0x30,%esp
    147b:	5b                   	pop    %ebx
    147c:	5e                   	pop    %esi
    147d:	5d                   	pop    %ebp
    147e:	c3                   	ret    

0000147f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    147f:	55                   	push   %ebp
    1480:	89 e5                	mov    %esp,%ebp
    1482:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1485:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    148c:	8d 45 0c             	lea    0xc(%ebp),%eax
    148f:	83 c0 04             	add    $0x4,%eax
    1492:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1495:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    149c:	e9 7c 01 00 00       	jmp    161d <printf+0x19e>
    c = fmt[i] & 0xff;
    14a1:	8b 55 0c             	mov    0xc(%ebp),%edx
    14a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14a7:	01 d0                	add    %edx,%eax
    14a9:	0f b6 00             	movzbl (%eax),%eax
    14ac:	0f be c0             	movsbl %al,%eax
    14af:	25 ff 00 00 00       	and    $0xff,%eax
    14b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    14b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14bb:	75 2c                	jne    14e9 <printf+0x6a>
      if(c == '%'){
    14bd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14c1:	75 0c                	jne    14cf <printf+0x50>
        state = '%';
    14c3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14ca:	e9 4a 01 00 00       	jmp    1619 <printf+0x19a>
      } else {
        putc(fd, c);
    14cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14d2:	0f be c0             	movsbl %al,%eax
    14d5:	89 44 24 04          	mov    %eax,0x4(%esp)
    14d9:	8b 45 08             	mov    0x8(%ebp),%eax
    14dc:	89 04 24             	mov    %eax,(%esp)
    14df:	e8 bb fe ff ff       	call   139f <putc>
    14e4:	e9 30 01 00 00       	jmp    1619 <printf+0x19a>
      }
    } else if(state == '%'){
    14e9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14ed:	0f 85 26 01 00 00    	jne    1619 <printf+0x19a>
      if(c == 'd'){
    14f3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14f7:	75 2d                	jne    1526 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14fc:	8b 00                	mov    (%eax),%eax
    14fe:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1505:	00 
    1506:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    150d:	00 
    150e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1512:	8b 45 08             	mov    0x8(%ebp),%eax
    1515:	89 04 24             	mov    %eax,(%esp)
    1518:	e8 aa fe ff ff       	call   13c7 <printint>
        ap++;
    151d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1521:	e9 ec 00 00 00       	jmp    1612 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1526:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    152a:	74 06                	je     1532 <printf+0xb3>
    152c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1530:	75 2d                	jne    155f <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1532:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1535:	8b 00                	mov    (%eax),%eax
    1537:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    153e:	00 
    153f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1546:	00 
    1547:	89 44 24 04          	mov    %eax,0x4(%esp)
    154b:	8b 45 08             	mov    0x8(%ebp),%eax
    154e:	89 04 24             	mov    %eax,(%esp)
    1551:	e8 71 fe ff ff       	call   13c7 <printint>
        ap++;
    1556:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    155a:	e9 b3 00 00 00       	jmp    1612 <printf+0x193>
      } else if(c == 's'){
    155f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1563:	75 45                	jne    15aa <printf+0x12b>
        s = (char*)*ap;
    1565:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1568:	8b 00                	mov    (%eax),%eax
    156a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    156d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1575:	75 09                	jne    1580 <printf+0x101>
          s = "(null)";
    1577:	c7 45 f4 7e 18 00 00 	movl   $0x187e,-0xc(%ebp)
        while(*s != 0){
    157e:	eb 1e                	jmp    159e <printf+0x11f>
    1580:	eb 1c                	jmp    159e <printf+0x11f>
          putc(fd, *s);
    1582:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1585:	0f b6 00             	movzbl (%eax),%eax
    1588:	0f be c0             	movsbl %al,%eax
    158b:	89 44 24 04          	mov    %eax,0x4(%esp)
    158f:	8b 45 08             	mov    0x8(%ebp),%eax
    1592:	89 04 24             	mov    %eax,(%esp)
    1595:	e8 05 fe ff ff       	call   139f <putc>
          s++;
    159a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    159e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a1:	0f b6 00             	movzbl (%eax),%eax
    15a4:	84 c0                	test   %al,%al
    15a6:	75 da                	jne    1582 <printf+0x103>
    15a8:	eb 68                	jmp    1612 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    15aa:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    15ae:	75 1d                	jne    15cd <printf+0x14e>
        putc(fd, *ap);
    15b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15b3:	8b 00                	mov    (%eax),%eax
    15b5:	0f be c0             	movsbl %al,%eax
    15b8:	89 44 24 04          	mov    %eax,0x4(%esp)
    15bc:	8b 45 08             	mov    0x8(%ebp),%eax
    15bf:	89 04 24             	mov    %eax,(%esp)
    15c2:	e8 d8 fd ff ff       	call   139f <putc>
        ap++;
    15c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15cb:	eb 45                	jmp    1612 <printf+0x193>
      } else if(c == '%'){
    15cd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15d1:	75 17                	jne    15ea <printf+0x16b>
        putc(fd, c);
    15d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15d6:	0f be c0             	movsbl %al,%eax
    15d9:	89 44 24 04          	mov    %eax,0x4(%esp)
    15dd:	8b 45 08             	mov    0x8(%ebp),%eax
    15e0:	89 04 24             	mov    %eax,(%esp)
    15e3:	e8 b7 fd ff ff       	call   139f <putc>
    15e8:	eb 28                	jmp    1612 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15ea:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15f1:	00 
    15f2:	8b 45 08             	mov    0x8(%ebp),%eax
    15f5:	89 04 24             	mov    %eax,(%esp)
    15f8:	e8 a2 fd ff ff       	call   139f <putc>
        putc(fd, c);
    15fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1600:	0f be c0             	movsbl %al,%eax
    1603:	89 44 24 04          	mov    %eax,0x4(%esp)
    1607:	8b 45 08             	mov    0x8(%ebp),%eax
    160a:	89 04 24             	mov    %eax,(%esp)
    160d:	e8 8d fd ff ff       	call   139f <putc>
      }
      state = 0;
    1612:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1619:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    161d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1620:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1623:	01 d0                	add    %edx,%eax
    1625:	0f b6 00             	movzbl (%eax),%eax
    1628:	84 c0                	test   %al,%al
    162a:	0f 85 71 fe ff ff    	jne    14a1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1630:	c9                   	leave  
    1631:	c3                   	ret    

00001632 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1632:	55                   	push   %ebp
    1633:	89 e5                	mov    %esp,%ebp
    1635:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1638:	8b 45 08             	mov    0x8(%ebp),%eax
    163b:	83 e8 08             	sub    $0x8,%eax
    163e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1641:	a1 e8 2a 00 00       	mov    0x2ae8,%eax
    1646:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1649:	eb 24                	jmp    166f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    164b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    164e:	8b 00                	mov    (%eax),%eax
    1650:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1653:	77 12                	ja     1667 <free+0x35>
    1655:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1658:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    165b:	77 24                	ja     1681 <free+0x4f>
    165d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1660:	8b 00                	mov    (%eax),%eax
    1662:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1665:	77 1a                	ja     1681 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1667:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166a:	8b 00                	mov    (%eax),%eax
    166c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1672:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1675:	76 d4                	jbe    164b <free+0x19>
    1677:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167a:	8b 00                	mov    (%eax),%eax
    167c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    167f:	76 ca                	jbe    164b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1681:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1684:	8b 40 04             	mov    0x4(%eax),%eax
    1687:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    168e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1691:	01 c2                	add    %eax,%edx
    1693:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1696:	8b 00                	mov    (%eax),%eax
    1698:	39 c2                	cmp    %eax,%edx
    169a:	75 24                	jne    16c0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    169c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    169f:	8b 50 04             	mov    0x4(%eax),%edx
    16a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a5:	8b 00                	mov    (%eax),%eax
    16a7:	8b 40 04             	mov    0x4(%eax),%eax
    16aa:	01 c2                	add    %eax,%edx
    16ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16af:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    16b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b5:	8b 00                	mov    (%eax),%eax
    16b7:	8b 10                	mov    (%eax),%edx
    16b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16bc:	89 10                	mov    %edx,(%eax)
    16be:	eb 0a                	jmp    16ca <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    16c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c3:	8b 10                	mov    (%eax),%edx
    16c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16cd:	8b 40 04             	mov    0x4(%eax),%eax
    16d0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16da:	01 d0                	add    %edx,%eax
    16dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16df:	75 20                	jne    1701 <free+0xcf>
    p->s.size += bp->s.size;
    16e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e4:	8b 50 04             	mov    0x4(%eax),%edx
    16e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ea:	8b 40 04             	mov    0x4(%eax),%eax
    16ed:	01 c2                	add    %eax,%edx
    16ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16f8:	8b 10                	mov    (%eax),%edx
    16fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16fd:	89 10                	mov    %edx,(%eax)
    16ff:	eb 08                	jmp    1709 <free+0xd7>
  } else
    p->s.ptr = bp;
    1701:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1704:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1707:	89 10                	mov    %edx,(%eax)
  freep = p;
    1709:	8b 45 fc             	mov    -0x4(%ebp),%eax
    170c:	a3 e8 2a 00 00       	mov    %eax,0x2ae8
}
    1711:	c9                   	leave  
    1712:	c3                   	ret    

00001713 <morecore>:

static Header*
morecore(uint nu)
{
    1713:	55                   	push   %ebp
    1714:	89 e5                	mov    %esp,%ebp
    1716:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1719:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1720:	77 07                	ja     1729 <morecore+0x16>
    nu = 4096;
    1722:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1729:	8b 45 08             	mov    0x8(%ebp),%eax
    172c:	c1 e0 03             	shl    $0x3,%eax
    172f:	89 04 24             	mov    %eax,(%esp)
    1732:	e8 48 fc ff ff       	call   137f <sbrk>
    1737:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    173a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    173e:	75 07                	jne    1747 <morecore+0x34>
    return 0;
    1740:	b8 00 00 00 00       	mov    $0x0,%eax
    1745:	eb 22                	jmp    1769 <morecore+0x56>
  hp = (Header*)p;
    1747:	8b 45 f4             	mov    -0xc(%ebp),%eax
    174a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    174d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1750:	8b 55 08             	mov    0x8(%ebp),%edx
    1753:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1756:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1759:	83 c0 08             	add    $0x8,%eax
    175c:	89 04 24             	mov    %eax,(%esp)
    175f:	e8 ce fe ff ff       	call   1632 <free>
  return freep;
    1764:	a1 e8 2a 00 00       	mov    0x2ae8,%eax
}
    1769:	c9                   	leave  
    176a:	c3                   	ret    

0000176b <malloc>:

void*
malloc(uint nbytes)
{
    176b:	55                   	push   %ebp
    176c:	89 e5                	mov    %esp,%ebp
    176e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1771:	8b 45 08             	mov    0x8(%ebp),%eax
    1774:	83 c0 07             	add    $0x7,%eax
    1777:	c1 e8 03             	shr    $0x3,%eax
    177a:	83 c0 01             	add    $0x1,%eax
    177d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1780:	a1 e8 2a 00 00       	mov    0x2ae8,%eax
    1785:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1788:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    178c:	75 23                	jne    17b1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    178e:	c7 45 f0 e0 2a 00 00 	movl   $0x2ae0,-0x10(%ebp)
    1795:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1798:	a3 e8 2a 00 00       	mov    %eax,0x2ae8
    179d:	a1 e8 2a 00 00       	mov    0x2ae8,%eax
    17a2:	a3 e0 2a 00 00       	mov    %eax,0x2ae0
    base.s.size = 0;
    17a7:	c7 05 e4 2a 00 00 00 	movl   $0x0,0x2ae4
    17ae:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17b4:	8b 00                	mov    (%eax),%eax
    17b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    17b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17bc:	8b 40 04             	mov    0x4(%eax),%eax
    17bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17c2:	72 4d                	jb     1811 <malloc+0xa6>
      if(p->s.size == nunits)
    17c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c7:	8b 40 04             	mov    0x4(%eax),%eax
    17ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17cd:	75 0c                	jne    17db <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d2:	8b 10                	mov    (%eax),%edx
    17d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17d7:	89 10                	mov    %edx,(%eax)
    17d9:	eb 26                	jmp    1801 <malloc+0x96>
      else {
        p->s.size -= nunits;
    17db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17de:	8b 40 04             	mov    0x4(%eax),%eax
    17e1:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17e4:	89 c2                	mov    %eax,%edx
    17e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ef:	8b 40 04             	mov    0x4(%eax),%eax
    17f2:	c1 e0 03             	shl    $0x3,%eax
    17f5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17fe:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1801:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1804:	a3 e8 2a 00 00       	mov    %eax,0x2ae8
      return (void*)(p + 1);
    1809:	8b 45 f4             	mov    -0xc(%ebp),%eax
    180c:	83 c0 08             	add    $0x8,%eax
    180f:	eb 38                	jmp    1849 <malloc+0xde>
    }
    if(p == freep)
    1811:	a1 e8 2a 00 00       	mov    0x2ae8,%eax
    1816:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1819:	75 1b                	jne    1836 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    181b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    181e:	89 04 24             	mov    %eax,(%esp)
    1821:	e8 ed fe ff ff       	call   1713 <morecore>
    1826:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    182d:	75 07                	jne    1836 <malloc+0xcb>
        return 0;
    182f:	b8 00 00 00 00       	mov    $0x0,%eax
    1834:	eb 13                	jmp    1849 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1836:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1839:	89 45 f0             	mov    %eax,-0x10(%ebp)
    183c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    183f:	8b 00                	mov    (%eax),%eax
    1841:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1844:	e9 70 ff ff ff       	jmp    17b9 <malloc+0x4e>
}
    1849:	c9                   	leave  
    184a:	c3                   	ret    
