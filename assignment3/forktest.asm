
_forktest:     file format elf32-i386


Disassembly of section .text:

00001000 <printf>:

#define N  100

void
printf(int fd, char *s, ...)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 18             	sub    $0x18,%esp
  write(fd, s, strlen(s));
    1006:	8b 45 0c             	mov    0xc(%ebp),%eax
    1009:	89 04 24             	mov    %eax,(%esp)
    100c:	e8 92 01 00 00       	call   11a3 <strlen>
    1011:	89 44 24 08          	mov    %eax,0x8(%esp)
    1015:	8b 45 0c             	mov    0xc(%ebp),%eax
    1018:	89 44 24 04          	mov    %eax,0x4(%esp)
    101c:	8b 45 08             	mov    0x8(%ebp),%eax
    101f:	89 04 24             	mov    %eax,(%esp)
    1022:	e8 70 03 00 00       	call   1397 <write>
}
    1027:	c9                   	leave  
    1028:	c3                   	ret    

00001029 <forktest>:

void
forktest(void)
{
    1029:	55                   	push   %ebp
    102a:	89 e5                	mov    %esp,%ebp
    102c:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    102f:	c7 44 24 04 20 14 00 	movl   $0x1420,0x4(%esp)
    1036:	00 
    1037:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    103e:	e8 bd ff ff ff       	call   1000 <printf>

  for(n=0; n<N; n++) {
    1043:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    104a:	eb 1f                	jmp    106b <forktest+0x42>
    pid = cowfork();
    104c:	e8 c6 03 00 00       	call   1417 <cowfork>
    1051:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    1054:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1058:	79 02                	jns    105c <forktest+0x33>
      break;
    105a:	eb 15                	jmp    1071 <forktest+0x48>
    if(pid == 0)
    105c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1060:	75 05                	jne    1067 <forktest+0x3e>
      exit();
    1062:	e8 10 03 00 00       	call   1377 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++) {
    1067:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    106b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    106f:	7e db                	jle    104c <forktest+0x23>
      break;
    if(pid == 0)
      exit();
  }
  
  if(n == N) {
    1071:	83 7d f4 64          	cmpl   $0x64,-0xc(%ebp)
    1075:	75 21                	jne    1098 <forktest+0x6f>
    printf(1, "fork claimed to work N times!\n", N);
    1077:	c7 44 24 08 64 00 00 	movl   $0x64,0x8(%esp)
    107e:	00 
    107f:	c7 44 24 04 2c 14 00 	movl   $0x142c,0x4(%esp)
    1086:	00 
    1087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    108e:	e8 6d ff ff ff       	call   1000 <printf>
    exit();
    1093:	e8 df 02 00 00       	call   1377 <exit>
  }
  
  for(; n > 0; n--) {
    1098:	eb 26                	jmp    10c0 <forktest+0x97>
    if(wait() < 0){
    109a:	e8 e0 02 00 00       	call   137f <wait>
    109f:	85 c0                	test   %eax,%eax
    10a1:	79 19                	jns    10bc <forktest+0x93>
      printf(1, "wait stopped early\n");
    10a3:	c7 44 24 04 4b 14 00 	movl   $0x144b,0x4(%esp)
    10aa:	00 
    10ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10b2:	e8 49 ff ff ff       	call   1000 <printf>
      exit();
    10b7:	e8 bb 02 00 00       	call   1377 <exit>
  if(n == N) {
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }
  
  for(; n > 0; n--) {
    10bc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    10c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10c4:	7f d4                	jg     109a <forktest+0x71>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1) {
    10c6:	e8 b4 02 00 00       	call   137f <wait>
    10cb:	83 f8 ff             	cmp    $0xffffffff,%eax
    10ce:	74 19                	je     10e9 <forktest+0xc0>
    printf(1, "wait got too many\n");
    10d0:	c7 44 24 04 5f 14 00 	movl   $0x145f,0x4(%esp)
    10d7:	00 
    10d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10df:	e8 1c ff ff ff       	call   1000 <printf>
    exit();
    10e4:	e8 8e 02 00 00       	call   1377 <exit>
  }
  
  printf(1, "fork test OK\n");
    10e9:	c7 44 24 04 72 14 00 	movl   $0x1472,0x4(%esp)
    10f0:	00 
    10f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10f8:	e8 03 ff ff ff       	call   1000 <printf>
}
    10fd:	c9                   	leave  
    10fe:	c3                   	ret    

000010ff <main>:

int
main(void)
{
    10ff:	55                   	push   %ebp
    1100:	89 e5                	mov    %esp,%ebp
    1102:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
    1105:	e8 1f ff ff ff       	call   1029 <forktest>
  exit();
    110a:	e8 68 02 00 00       	call   1377 <exit>

0000110f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    110f:	55                   	push   %ebp
    1110:	89 e5                	mov    %esp,%ebp
    1112:	57                   	push   %edi
    1113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1114:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1117:	8b 55 10             	mov    0x10(%ebp),%edx
    111a:	8b 45 0c             	mov    0xc(%ebp),%eax
    111d:	89 cb                	mov    %ecx,%ebx
    111f:	89 df                	mov    %ebx,%edi
    1121:	89 d1                	mov    %edx,%ecx
    1123:	fc                   	cld    
    1124:	f3 aa                	rep stos %al,%es:(%edi)
    1126:	89 ca                	mov    %ecx,%edx
    1128:	89 fb                	mov    %edi,%ebx
    112a:	89 5d 08             	mov    %ebx,0x8(%ebp)
    112d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1130:	5b                   	pop    %ebx
    1131:	5f                   	pop    %edi
    1132:	5d                   	pop    %ebp
    1133:	c3                   	ret    

00001134 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1134:	55                   	push   %ebp
    1135:	89 e5                	mov    %esp,%ebp
    1137:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    113a:	8b 45 08             	mov    0x8(%ebp),%eax
    113d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1140:	90                   	nop
    1141:	8b 45 08             	mov    0x8(%ebp),%eax
    1144:	8d 50 01             	lea    0x1(%eax),%edx
    1147:	89 55 08             	mov    %edx,0x8(%ebp)
    114a:	8b 55 0c             	mov    0xc(%ebp),%edx
    114d:	8d 4a 01             	lea    0x1(%edx),%ecx
    1150:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1153:	0f b6 12             	movzbl (%edx),%edx
    1156:	88 10                	mov    %dl,(%eax)
    1158:	0f b6 00             	movzbl (%eax),%eax
    115b:	84 c0                	test   %al,%al
    115d:	75 e2                	jne    1141 <strcpy+0xd>
    ;
  return os;
    115f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1162:	c9                   	leave  
    1163:	c3                   	ret    

00001164 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1164:	55                   	push   %ebp
    1165:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1167:	eb 08                	jmp    1171 <strcmp+0xd>
    p++, q++;
    1169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    116d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1171:	8b 45 08             	mov    0x8(%ebp),%eax
    1174:	0f b6 00             	movzbl (%eax),%eax
    1177:	84 c0                	test   %al,%al
    1179:	74 10                	je     118b <strcmp+0x27>
    117b:	8b 45 08             	mov    0x8(%ebp),%eax
    117e:	0f b6 10             	movzbl (%eax),%edx
    1181:	8b 45 0c             	mov    0xc(%ebp),%eax
    1184:	0f b6 00             	movzbl (%eax),%eax
    1187:	38 c2                	cmp    %al,%dl
    1189:	74 de                	je     1169 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    118b:	8b 45 08             	mov    0x8(%ebp),%eax
    118e:	0f b6 00             	movzbl (%eax),%eax
    1191:	0f b6 d0             	movzbl %al,%edx
    1194:	8b 45 0c             	mov    0xc(%ebp),%eax
    1197:	0f b6 00             	movzbl (%eax),%eax
    119a:	0f b6 c0             	movzbl %al,%eax
    119d:	29 c2                	sub    %eax,%edx
    119f:	89 d0                	mov    %edx,%eax
}
    11a1:	5d                   	pop    %ebp
    11a2:	c3                   	ret    

000011a3 <strlen>:

uint
strlen(char *s)
{
    11a3:	55                   	push   %ebp
    11a4:	89 e5                	mov    %esp,%ebp
    11a6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11b0:	eb 04                	jmp    11b6 <strlen+0x13>
    11b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11b9:	8b 45 08             	mov    0x8(%ebp),%eax
    11bc:	01 d0                	add    %edx,%eax
    11be:	0f b6 00             	movzbl (%eax),%eax
    11c1:	84 c0                	test   %al,%al
    11c3:	75 ed                	jne    11b2 <strlen+0xf>
    ;
  return n;
    11c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11c8:	c9                   	leave  
    11c9:	c3                   	ret    

000011ca <memset>:

void*
memset(void *dst, int c, uint n)
{
    11ca:	55                   	push   %ebp
    11cb:	89 e5                	mov    %esp,%ebp
    11cd:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11d0:	8b 45 10             	mov    0x10(%ebp),%eax
    11d3:	89 44 24 08          	mov    %eax,0x8(%esp)
    11d7:	8b 45 0c             	mov    0xc(%ebp),%eax
    11da:	89 44 24 04          	mov    %eax,0x4(%esp)
    11de:	8b 45 08             	mov    0x8(%ebp),%eax
    11e1:	89 04 24             	mov    %eax,(%esp)
    11e4:	e8 26 ff ff ff       	call   110f <stosb>
  return dst;
    11e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ec:	c9                   	leave  
    11ed:	c3                   	ret    

000011ee <strchr>:

char*
strchr(const char *s, char c)
{
    11ee:	55                   	push   %ebp
    11ef:	89 e5                	mov    %esp,%ebp
    11f1:	83 ec 04             	sub    $0x4,%esp
    11f4:	8b 45 0c             	mov    0xc(%ebp),%eax
    11f7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11fa:	eb 14                	jmp    1210 <strchr+0x22>
    if(*s == c)
    11fc:	8b 45 08             	mov    0x8(%ebp),%eax
    11ff:	0f b6 00             	movzbl (%eax),%eax
    1202:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1205:	75 05                	jne    120c <strchr+0x1e>
      return (char*)s;
    1207:	8b 45 08             	mov    0x8(%ebp),%eax
    120a:	eb 13                	jmp    121f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    120c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1210:	8b 45 08             	mov    0x8(%ebp),%eax
    1213:	0f b6 00             	movzbl (%eax),%eax
    1216:	84 c0                	test   %al,%al
    1218:	75 e2                	jne    11fc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    121a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    121f:	c9                   	leave  
    1220:	c3                   	ret    

00001221 <gets>:

char*
gets(char *buf, int max)
{
    1221:	55                   	push   %ebp
    1222:	89 e5                	mov    %esp,%ebp
    1224:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1227:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    122e:	eb 4c                	jmp    127c <gets+0x5b>
    cc = read(0, &c, 1);
    1230:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1237:	00 
    1238:	8d 45 ef             	lea    -0x11(%ebp),%eax
    123b:	89 44 24 04          	mov    %eax,0x4(%esp)
    123f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1246:	e8 44 01 00 00       	call   138f <read>
    124b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    124e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1252:	7f 02                	jg     1256 <gets+0x35>
      break;
    1254:	eb 31                	jmp    1287 <gets+0x66>
    buf[i++] = c;
    1256:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1259:	8d 50 01             	lea    0x1(%eax),%edx
    125c:	89 55 f4             	mov    %edx,-0xc(%ebp)
    125f:	89 c2                	mov    %eax,%edx
    1261:	8b 45 08             	mov    0x8(%ebp),%eax
    1264:	01 c2                	add    %eax,%edx
    1266:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    126a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    126c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1270:	3c 0a                	cmp    $0xa,%al
    1272:	74 13                	je     1287 <gets+0x66>
    1274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1278:	3c 0d                	cmp    $0xd,%al
    127a:	74 0b                	je     1287 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    127c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    127f:	83 c0 01             	add    $0x1,%eax
    1282:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1285:	7c a9                	jl     1230 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1287:	8b 55 f4             	mov    -0xc(%ebp),%edx
    128a:	8b 45 08             	mov    0x8(%ebp),%eax
    128d:	01 d0                	add    %edx,%eax
    128f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1292:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1295:	c9                   	leave  
    1296:	c3                   	ret    

00001297 <stat>:

int
stat(char *n, struct stat *st)
{
    1297:	55                   	push   %ebp
    1298:	89 e5                	mov    %esp,%ebp
    129a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    129d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12a4:	00 
    12a5:	8b 45 08             	mov    0x8(%ebp),%eax
    12a8:	89 04 24             	mov    %eax,(%esp)
    12ab:	e8 07 01 00 00       	call   13b7 <open>
    12b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12b7:	79 07                	jns    12c0 <stat+0x29>
    return -1;
    12b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12be:	eb 23                	jmp    12e3 <stat+0x4c>
  r = fstat(fd, st);
    12c0:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c3:	89 44 24 04          	mov    %eax,0x4(%esp)
    12c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ca:	89 04 24             	mov    %eax,(%esp)
    12cd:	e8 fd 00 00 00       	call   13cf <fstat>
    12d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d8:	89 04 24             	mov    %eax,(%esp)
    12db:	e8 bf 00 00 00       	call   139f <close>
  return r;
    12e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12e3:	c9                   	leave  
    12e4:	c3                   	ret    

000012e5 <atoi>:

int
atoi(const char *s)
{
    12e5:	55                   	push   %ebp
    12e6:	89 e5                	mov    %esp,%ebp
    12e8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12f2:	eb 25                	jmp    1319 <atoi+0x34>
    n = n*10 + *s++ - '0';
    12f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12f7:	89 d0                	mov    %edx,%eax
    12f9:	c1 e0 02             	shl    $0x2,%eax
    12fc:	01 d0                	add    %edx,%eax
    12fe:	01 c0                	add    %eax,%eax
    1300:	89 c1                	mov    %eax,%ecx
    1302:	8b 45 08             	mov    0x8(%ebp),%eax
    1305:	8d 50 01             	lea    0x1(%eax),%edx
    1308:	89 55 08             	mov    %edx,0x8(%ebp)
    130b:	0f b6 00             	movzbl (%eax),%eax
    130e:	0f be c0             	movsbl %al,%eax
    1311:	01 c8                	add    %ecx,%eax
    1313:	83 e8 30             	sub    $0x30,%eax
    1316:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1319:	8b 45 08             	mov    0x8(%ebp),%eax
    131c:	0f b6 00             	movzbl (%eax),%eax
    131f:	3c 2f                	cmp    $0x2f,%al
    1321:	7e 0a                	jle    132d <atoi+0x48>
    1323:	8b 45 08             	mov    0x8(%ebp),%eax
    1326:	0f b6 00             	movzbl (%eax),%eax
    1329:	3c 39                	cmp    $0x39,%al
    132b:	7e c7                	jle    12f4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    132d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1330:	c9                   	leave  
    1331:	c3                   	ret    

00001332 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1332:	55                   	push   %ebp
    1333:	89 e5                	mov    %esp,%ebp
    1335:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1338:	8b 45 08             	mov    0x8(%ebp),%eax
    133b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    133e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1341:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1344:	eb 17                	jmp    135d <memmove+0x2b>
    *dst++ = *src++;
    1346:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1349:	8d 50 01             	lea    0x1(%eax),%edx
    134c:	89 55 fc             	mov    %edx,-0x4(%ebp)
    134f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1352:	8d 4a 01             	lea    0x1(%edx),%ecx
    1355:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1358:	0f b6 12             	movzbl (%edx),%edx
    135b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    135d:	8b 45 10             	mov    0x10(%ebp),%eax
    1360:	8d 50 ff             	lea    -0x1(%eax),%edx
    1363:	89 55 10             	mov    %edx,0x10(%ebp)
    1366:	85 c0                	test   %eax,%eax
    1368:	7f dc                	jg     1346 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    136a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    136d:	c9                   	leave  
    136e:	c3                   	ret    

0000136f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    136f:	b8 01 00 00 00       	mov    $0x1,%eax
    1374:	cd 40                	int    $0x40
    1376:	c3                   	ret    

00001377 <exit>:
SYSCALL(exit)
    1377:	b8 02 00 00 00       	mov    $0x2,%eax
    137c:	cd 40                	int    $0x40
    137e:	c3                   	ret    

0000137f <wait>:
SYSCALL(wait)
    137f:	b8 03 00 00 00       	mov    $0x3,%eax
    1384:	cd 40                	int    $0x40
    1386:	c3                   	ret    

00001387 <pipe>:
SYSCALL(pipe)
    1387:	b8 04 00 00 00       	mov    $0x4,%eax
    138c:	cd 40                	int    $0x40
    138e:	c3                   	ret    

0000138f <read>:
SYSCALL(read)
    138f:	b8 05 00 00 00       	mov    $0x5,%eax
    1394:	cd 40                	int    $0x40
    1396:	c3                   	ret    

00001397 <write>:
SYSCALL(write)
    1397:	b8 10 00 00 00       	mov    $0x10,%eax
    139c:	cd 40                	int    $0x40
    139e:	c3                   	ret    

0000139f <close>:
SYSCALL(close)
    139f:	b8 15 00 00 00       	mov    $0x15,%eax
    13a4:	cd 40                	int    $0x40
    13a6:	c3                   	ret    

000013a7 <kill>:
SYSCALL(kill)
    13a7:	b8 06 00 00 00       	mov    $0x6,%eax
    13ac:	cd 40                	int    $0x40
    13ae:	c3                   	ret    

000013af <exec>:
SYSCALL(exec)
    13af:	b8 07 00 00 00       	mov    $0x7,%eax
    13b4:	cd 40                	int    $0x40
    13b6:	c3                   	ret    

000013b7 <open>:
SYSCALL(open)
    13b7:	b8 0f 00 00 00       	mov    $0xf,%eax
    13bc:	cd 40                	int    $0x40
    13be:	c3                   	ret    

000013bf <mknod>:
SYSCALL(mknod)
    13bf:	b8 11 00 00 00       	mov    $0x11,%eax
    13c4:	cd 40                	int    $0x40
    13c6:	c3                   	ret    

000013c7 <unlink>:
SYSCALL(unlink)
    13c7:	b8 12 00 00 00       	mov    $0x12,%eax
    13cc:	cd 40                	int    $0x40
    13ce:	c3                   	ret    

000013cf <fstat>:
SYSCALL(fstat)
    13cf:	b8 08 00 00 00       	mov    $0x8,%eax
    13d4:	cd 40                	int    $0x40
    13d6:	c3                   	ret    

000013d7 <link>:
SYSCALL(link)
    13d7:	b8 13 00 00 00       	mov    $0x13,%eax
    13dc:	cd 40                	int    $0x40
    13de:	c3                   	ret    

000013df <mkdir>:
SYSCALL(mkdir)
    13df:	b8 14 00 00 00       	mov    $0x14,%eax
    13e4:	cd 40                	int    $0x40
    13e6:	c3                   	ret    

000013e7 <chdir>:
SYSCALL(chdir)
    13e7:	b8 09 00 00 00       	mov    $0x9,%eax
    13ec:	cd 40                	int    $0x40
    13ee:	c3                   	ret    

000013ef <dup>:
SYSCALL(dup)
    13ef:	b8 0a 00 00 00       	mov    $0xa,%eax
    13f4:	cd 40                	int    $0x40
    13f6:	c3                   	ret    

000013f7 <getpid>:
SYSCALL(getpid)
    13f7:	b8 0b 00 00 00       	mov    $0xb,%eax
    13fc:	cd 40                	int    $0x40
    13fe:	c3                   	ret    

000013ff <sbrk>:
SYSCALL(sbrk)
    13ff:	b8 0c 00 00 00       	mov    $0xc,%eax
    1404:	cd 40                	int    $0x40
    1406:	c3                   	ret    

00001407 <sleep>:
SYSCALL(sleep)
    1407:	b8 0d 00 00 00       	mov    $0xd,%eax
    140c:	cd 40                	int    $0x40
    140e:	c3                   	ret    

0000140f <uptime>:
SYSCALL(uptime)
    140f:	b8 0e 00 00 00       	mov    $0xe,%eax
    1414:	cd 40                	int    $0x40
    1416:	c3                   	ret    

00001417 <cowfork>:
SYSCALL(cowfork) //3.4
    1417:	b8 16 00 00 00       	mov    $0x16,%eax
    141c:	cd 40                	int    $0x40
    141e:	c3                   	ret    
