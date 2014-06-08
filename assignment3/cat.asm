
_cat:     file format elf32-i386


Disassembly of section .text:

00001000 <cat>:

char buf[512];

void
cat(int fd)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    1006:	eb 1b                	jmp    1023 <cat+0x23>
    write(1, buf, n);
    1008:	8b 45 f4             	mov    -0xc(%ebp),%eax
    100b:	89 44 24 08          	mov    %eax,0x8(%esp)
    100f:	c7 44 24 04 a0 2b 00 	movl   $0x2ba0,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    101e:	e8 82 03 00 00       	call   13a5 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    1023:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    102a:	00 
    102b:	c7 44 24 04 a0 2b 00 	movl   $0x2ba0,0x4(%esp)
    1032:	00 
    1033:	8b 45 08             	mov    0x8(%ebp),%eax
    1036:	89 04 24             	mov    %eax,(%esp)
    1039:	e8 5f 03 00 00       	call   139d <read>
    103e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1041:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1045:	7f c1                	jg     1008 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
    1047:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    104b:	79 19                	jns    1066 <cat+0x66>
    printf(1, "cat: read error\n");
    104d:	c7 44 24 04 d9 18 00 	movl   $0x18d9,0x4(%esp)
    1054:	00 
    1055:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    105c:	e8 ac 04 00 00       	call   150d <printf>
    exit();
    1061:	e8 1f 03 00 00       	call   1385 <exit>
  }
}
    1066:	c9                   	leave  
    1067:	c3                   	ret    

00001068 <main>:

int
main(int argc, char *argv[])
{
    1068:	55                   	push   %ebp
    1069:	89 e5                	mov    %esp,%ebp
    106b:	83 e4 f0             	and    $0xfffffff0,%esp
    106e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
    1071:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1075:	7f 11                	jg     1088 <main+0x20>
    cat(0);
    1077:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    107e:	e8 7d ff ff ff       	call   1000 <cat>
    exit();
    1083:	e8 fd 02 00 00       	call   1385 <exit>
  }

  for(i = 1; i < argc; i++){
    1088:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    108f:	00 
    1090:	eb 79                	jmp    110b <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
    1092:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1096:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    109d:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a0:	01 d0                	add    %edx,%eax
    10a2:	8b 00                	mov    (%eax),%eax
    10a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10ab:	00 
    10ac:	89 04 24             	mov    %eax,(%esp)
    10af:	e8 11 03 00 00       	call   13c5 <open>
    10b4:	89 44 24 18          	mov    %eax,0x18(%esp)
    10b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    10bd:	79 2f                	jns    10ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
    10bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    10c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    10ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    10cd:	01 d0                	add    %edx,%eax
    10cf:	8b 00                	mov    (%eax),%eax
    10d1:	89 44 24 08          	mov    %eax,0x8(%esp)
    10d5:	c7 44 24 04 ea 18 00 	movl   $0x18ea,0x4(%esp)
    10dc:	00 
    10dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10e4:	e8 24 04 00 00       	call   150d <printf>
      exit();
    10e9:	e8 97 02 00 00       	call   1385 <exit>
    }
    cat(fd);
    10ee:	8b 44 24 18          	mov    0x18(%esp),%eax
    10f2:	89 04 24             	mov    %eax,(%esp)
    10f5:	e8 06 ff ff ff       	call   1000 <cat>
    close(fd);
    10fa:	8b 44 24 18          	mov    0x18(%esp),%eax
    10fe:	89 04 24             	mov    %eax,(%esp)
    1101:	e8 a7 02 00 00       	call   13ad <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    1106:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    110b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    110f:	3b 45 08             	cmp    0x8(%ebp),%eax
    1112:	0f 8c 7a ff ff ff    	jl     1092 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
    1118:	e8 68 02 00 00       	call   1385 <exit>

0000111d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    111d:	55                   	push   %ebp
    111e:	89 e5                	mov    %esp,%ebp
    1120:	57                   	push   %edi
    1121:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1122:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1125:	8b 55 10             	mov    0x10(%ebp),%edx
    1128:	8b 45 0c             	mov    0xc(%ebp),%eax
    112b:	89 cb                	mov    %ecx,%ebx
    112d:	89 df                	mov    %ebx,%edi
    112f:	89 d1                	mov    %edx,%ecx
    1131:	fc                   	cld    
    1132:	f3 aa                	rep stos %al,%es:(%edi)
    1134:	89 ca                	mov    %ecx,%edx
    1136:	89 fb                	mov    %edi,%ebx
    1138:	89 5d 08             	mov    %ebx,0x8(%ebp)
    113b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    113e:	5b                   	pop    %ebx
    113f:	5f                   	pop    %edi
    1140:	5d                   	pop    %ebp
    1141:	c3                   	ret    

00001142 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1142:	55                   	push   %ebp
    1143:	89 e5                	mov    %esp,%ebp
    1145:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1148:	8b 45 08             	mov    0x8(%ebp),%eax
    114b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    114e:	90                   	nop
    114f:	8b 45 08             	mov    0x8(%ebp),%eax
    1152:	8d 50 01             	lea    0x1(%eax),%edx
    1155:	89 55 08             	mov    %edx,0x8(%ebp)
    1158:	8b 55 0c             	mov    0xc(%ebp),%edx
    115b:	8d 4a 01             	lea    0x1(%edx),%ecx
    115e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1161:	0f b6 12             	movzbl (%edx),%edx
    1164:	88 10                	mov    %dl,(%eax)
    1166:	0f b6 00             	movzbl (%eax),%eax
    1169:	84 c0                	test   %al,%al
    116b:	75 e2                	jne    114f <strcpy+0xd>
    ;
  return os;
    116d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1170:	c9                   	leave  
    1171:	c3                   	ret    

00001172 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1172:	55                   	push   %ebp
    1173:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1175:	eb 08                	jmp    117f <strcmp+0xd>
    p++, q++;
    1177:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    117b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    117f:	8b 45 08             	mov    0x8(%ebp),%eax
    1182:	0f b6 00             	movzbl (%eax),%eax
    1185:	84 c0                	test   %al,%al
    1187:	74 10                	je     1199 <strcmp+0x27>
    1189:	8b 45 08             	mov    0x8(%ebp),%eax
    118c:	0f b6 10             	movzbl (%eax),%edx
    118f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1192:	0f b6 00             	movzbl (%eax),%eax
    1195:	38 c2                	cmp    %al,%dl
    1197:	74 de                	je     1177 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1199:	8b 45 08             	mov    0x8(%ebp),%eax
    119c:	0f b6 00             	movzbl (%eax),%eax
    119f:	0f b6 d0             	movzbl %al,%edx
    11a2:	8b 45 0c             	mov    0xc(%ebp),%eax
    11a5:	0f b6 00             	movzbl (%eax),%eax
    11a8:	0f b6 c0             	movzbl %al,%eax
    11ab:	29 c2                	sub    %eax,%edx
    11ad:	89 d0                	mov    %edx,%eax
}
    11af:	5d                   	pop    %ebp
    11b0:	c3                   	ret    

000011b1 <strlen>:

uint
strlen(char *s)
{
    11b1:	55                   	push   %ebp
    11b2:	89 e5                	mov    %esp,%ebp
    11b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11be:	eb 04                	jmp    11c4 <strlen+0x13>
    11c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11c7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ca:	01 d0                	add    %edx,%eax
    11cc:	0f b6 00             	movzbl (%eax),%eax
    11cf:	84 c0                	test   %al,%al
    11d1:	75 ed                	jne    11c0 <strlen+0xf>
    ;
  return n;
    11d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11d6:	c9                   	leave  
    11d7:	c3                   	ret    

000011d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11d8:	55                   	push   %ebp
    11d9:	89 e5                	mov    %esp,%ebp
    11db:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11de:	8b 45 10             	mov    0x10(%ebp),%eax
    11e1:	89 44 24 08          	mov    %eax,0x8(%esp)
    11e5:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e8:	89 44 24 04          	mov    %eax,0x4(%esp)
    11ec:	8b 45 08             	mov    0x8(%ebp),%eax
    11ef:	89 04 24             	mov    %eax,(%esp)
    11f2:	e8 26 ff ff ff       	call   111d <stosb>
  return dst;
    11f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11fa:	c9                   	leave  
    11fb:	c3                   	ret    

000011fc <strchr>:

char*
strchr(const char *s, char c)
{
    11fc:	55                   	push   %ebp
    11fd:	89 e5                	mov    %esp,%ebp
    11ff:	83 ec 04             	sub    $0x4,%esp
    1202:	8b 45 0c             	mov    0xc(%ebp),%eax
    1205:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1208:	eb 14                	jmp    121e <strchr+0x22>
    if(*s == c)
    120a:	8b 45 08             	mov    0x8(%ebp),%eax
    120d:	0f b6 00             	movzbl (%eax),%eax
    1210:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1213:	75 05                	jne    121a <strchr+0x1e>
      return (char*)s;
    1215:	8b 45 08             	mov    0x8(%ebp),%eax
    1218:	eb 13                	jmp    122d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    121a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    121e:	8b 45 08             	mov    0x8(%ebp),%eax
    1221:	0f b6 00             	movzbl (%eax),%eax
    1224:	84 c0                	test   %al,%al
    1226:	75 e2                	jne    120a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1228:	b8 00 00 00 00       	mov    $0x0,%eax
}
    122d:	c9                   	leave  
    122e:	c3                   	ret    

0000122f <gets>:

char*
gets(char *buf, int max)
{
    122f:	55                   	push   %ebp
    1230:	89 e5                	mov    %esp,%ebp
    1232:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    123c:	eb 4c                	jmp    128a <gets+0x5b>
    cc = read(0, &c, 1);
    123e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1245:	00 
    1246:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1249:	89 44 24 04          	mov    %eax,0x4(%esp)
    124d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1254:	e8 44 01 00 00       	call   139d <read>
    1259:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    125c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1260:	7f 02                	jg     1264 <gets+0x35>
      break;
    1262:	eb 31                	jmp    1295 <gets+0x66>
    buf[i++] = c;
    1264:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1267:	8d 50 01             	lea    0x1(%eax),%edx
    126a:	89 55 f4             	mov    %edx,-0xc(%ebp)
    126d:	89 c2                	mov    %eax,%edx
    126f:	8b 45 08             	mov    0x8(%ebp),%eax
    1272:	01 c2                	add    %eax,%edx
    1274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1278:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    127a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    127e:	3c 0a                	cmp    $0xa,%al
    1280:	74 13                	je     1295 <gets+0x66>
    1282:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1286:	3c 0d                	cmp    $0xd,%al
    1288:	74 0b                	je     1295 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    128a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    128d:	83 c0 01             	add    $0x1,%eax
    1290:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1293:	7c a9                	jl     123e <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1295:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1298:	8b 45 08             	mov    0x8(%ebp),%eax
    129b:	01 d0                	add    %edx,%eax
    129d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    12a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12a3:	c9                   	leave  
    12a4:	c3                   	ret    

000012a5 <stat>:

int
stat(char *n, struct stat *st)
{
    12a5:	55                   	push   %ebp
    12a6:	89 e5                	mov    %esp,%ebp
    12a8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12b2:	00 
    12b3:	8b 45 08             	mov    0x8(%ebp),%eax
    12b6:	89 04 24             	mov    %eax,(%esp)
    12b9:	e8 07 01 00 00       	call   13c5 <open>
    12be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12c5:	79 07                	jns    12ce <stat+0x29>
    return -1;
    12c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12cc:	eb 23                	jmp    12f1 <stat+0x4c>
  r = fstat(fd, st);
    12ce:	8b 45 0c             	mov    0xc(%ebp),%eax
    12d1:	89 44 24 04          	mov    %eax,0x4(%esp)
    12d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d8:	89 04 24             	mov    %eax,(%esp)
    12db:	e8 fd 00 00 00       	call   13dd <fstat>
    12e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12e6:	89 04 24             	mov    %eax,(%esp)
    12e9:	e8 bf 00 00 00       	call   13ad <close>
  return r;
    12ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12f1:	c9                   	leave  
    12f2:	c3                   	ret    

000012f3 <atoi>:

int
atoi(const char *s)
{
    12f3:	55                   	push   %ebp
    12f4:	89 e5                	mov    %esp,%ebp
    12f6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1300:	eb 25                	jmp    1327 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1302:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1305:	89 d0                	mov    %edx,%eax
    1307:	c1 e0 02             	shl    $0x2,%eax
    130a:	01 d0                	add    %edx,%eax
    130c:	01 c0                	add    %eax,%eax
    130e:	89 c1                	mov    %eax,%ecx
    1310:	8b 45 08             	mov    0x8(%ebp),%eax
    1313:	8d 50 01             	lea    0x1(%eax),%edx
    1316:	89 55 08             	mov    %edx,0x8(%ebp)
    1319:	0f b6 00             	movzbl (%eax),%eax
    131c:	0f be c0             	movsbl %al,%eax
    131f:	01 c8                	add    %ecx,%eax
    1321:	83 e8 30             	sub    $0x30,%eax
    1324:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1327:	8b 45 08             	mov    0x8(%ebp),%eax
    132a:	0f b6 00             	movzbl (%eax),%eax
    132d:	3c 2f                	cmp    $0x2f,%al
    132f:	7e 0a                	jle    133b <atoi+0x48>
    1331:	8b 45 08             	mov    0x8(%ebp),%eax
    1334:	0f b6 00             	movzbl (%eax),%eax
    1337:	3c 39                	cmp    $0x39,%al
    1339:	7e c7                	jle    1302 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    133b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    133e:	c9                   	leave  
    133f:	c3                   	ret    

00001340 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1340:	55                   	push   %ebp
    1341:	89 e5                	mov    %esp,%ebp
    1343:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1346:	8b 45 08             	mov    0x8(%ebp),%eax
    1349:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    134c:	8b 45 0c             	mov    0xc(%ebp),%eax
    134f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1352:	eb 17                	jmp    136b <memmove+0x2b>
    *dst++ = *src++;
    1354:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1357:	8d 50 01             	lea    0x1(%eax),%edx
    135a:	89 55 fc             	mov    %edx,-0x4(%ebp)
    135d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1360:	8d 4a 01             	lea    0x1(%edx),%ecx
    1363:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1366:	0f b6 12             	movzbl (%edx),%edx
    1369:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    136b:	8b 45 10             	mov    0x10(%ebp),%eax
    136e:	8d 50 ff             	lea    -0x1(%eax),%edx
    1371:	89 55 10             	mov    %edx,0x10(%ebp)
    1374:	85 c0                	test   %eax,%eax
    1376:	7f dc                	jg     1354 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1378:	8b 45 08             	mov    0x8(%ebp),%eax
}
    137b:	c9                   	leave  
    137c:	c3                   	ret    

0000137d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    137d:	b8 01 00 00 00       	mov    $0x1,%eax
    1382:	cd 40                	int    $0x40
    1384:	c3                   	ret    

00001385 <exit>:
SYSCALL(exit)
    1385:	b8 02 00 00 00       	mov    $0x2,%eax
    138a:	cd 40                	int    $0x40
    138c:	c3                   	ret    

0000138d <wait>:
SYSCALL(wait)
    138d:	b8 03 00 00 00       	mov    $0x3,%eax
    1392:	cd 40                	int    $0x40
    1394:	c3                   	ret    

00001395 <pipe>:
SYSCALL(pipe)
    1395:	b8 04 00 00 00       	mov    $0x4,%eax
    139a:	cd 40                	int    $0x40
    139c:	c3                   	ret    

0000139d <read>:
SYSCALL(read)
    139d:	b8 05 00 00 00       	mov    $0x5,%eax
    13a2:	cd 40                	int    $0x40
    13a4:	c3                   	ret    

000013a5 <write>:
SYSCALL(write)
    13a5:	b8 10 00 00 00       	mov    $0x10,%eax
    13aa:	cd 40                	int    $0x40
    13ac:	c3                   	ret    

000013ad <close>:
SYSCALL(close)
    13ad:	b8 15 00 00 00       	mov    $0x15,%eax
    13b2:	cd 40                	int    $0x40
    13b4:	c3                   	ret    

000013b5 <kill>:
SYSCALL(kill)
    13b5:	b8 06 00 00 00       	mov    $0x6,%eax
    13ba:	cd 40                	int    $0x40
    13bc:	c3                   	ret    

000013bd <exec>:
SYSCALL(exec)
    13bd:	b8 07 00 00 00       	mov    $0x7,%eax
    13c2:	cd 40                	int    $0x40
    13c4:	c3                   	ret    

000013c5 <open>:
SYSCALL(open)
    13c5:	b8 0f 00 00 00       	mov    $0xf,%eax
    13ca:	cd 40                	int    $0x40
    13cc:	c3                   	ret    

000013cd <mknod>:
SYSCALL(mknod)
    13cd:	b8 11 00 00 00       	mov    $0x11,%eax
    13d2:	cd 40                	int    $0x40
    13d4:	c3                   	ret    

000013d5 <unlink>:
SYSCALL(unlink)
    13d5:	b8 12 00 00 00       	mov    $0x12,%eax
    13da:	cd 40                	int    $0x40
    13dc:	c3                   	ret    

000013dd <fstat>:
SYSCALL(fstat)
    13dd:	b8 08 00 00 00       	mov    $0x8,%eax
    13e2:	cd 40                	int    $0x40
    13e4:	c3                   	ret    

000013e5 <link>:
SYSCALL(link)
    13e5:	b8 13 00 00 00       	mov    $0x13,%eax
    13ea:	cd 40                	int    $0x40
    13ec:	c3                   	ret    

000013ed <mkdir>:
SYSCALL(mkdir)
    13ed:	b8 14 00 00 00       	mov    $0x14,%eax
    13f2:	cd 40                	int    $0x40
    13f4:	c3                   	ret    

000013f5 <chdir>:
SYSCALL(chdir)
    13f5:	b8 09 00 00 00       	mov    $0x9,%eax
    13fa:	cd 40                	int    $0x40
    13fc:	c3                   	ret    

000013fd <dup>:
SYSCALL(dup)
    13fd:	b8 0a 00 00 00       	mov    $0xa,%eax
    1402:	cd 40                	int    $0x40
    1404:	c3                   	ret    

00001405 <getpid>:
SYSCALL(getpid)
    1405:	b8 0b 00 00 00       	mov    $0xb,%eax
    140a:	cd 40                	int    $0x40
    140c:	c3                   	ret    

0000140d <sbrk>:
SYSCALL(sbrk)
    140d:	b8 0c 00 00 00       	mov    $0xc,%eax
    1412:	cd 40                	int    $0x40
    1414:	c3                   	ret    

00001415 <sleep>:
SYSCALL(sleep)
    1415:	b8 0d 00 00 00       	mov    $0xd,%eax
    141a:	cd 40                	int    $0x40
    141c:	c3                   	ret    

0000141d <uptime>:
SYSCALL(uptime)
    141d:	b8 0e 00 00 00       	mov    $0xe,%eax
    1422:	cd 40                	int    $0x40
    1424:	c3                   	ret    

00001425 <cowfork>:
SYSCALL(cowfork) //3.4
    1425:	b8 16 00 00 00       	mov    $0x16,%eax
    142a:	cd 40                	int    $0x40
    142c:	c3                   	ret    

0000142d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    142d:	55                   	push   %ebp
    142e:	89 e5                	mov    %esp,%ebp
    1430:	83 ec 18             	sub    $0x18,%esp
    1433:	8b 45 0c             	mov    0xc(%ebp),%eax
    1436:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1439:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1440:	00 
    1441:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1444:	89 44 24 04          	mov    %eax,0x4(%esp)
    1448:	8b 45 08             	mov    0x8(%ebp),%eax
    144b:	89 04 24             	mov    %eax,(%esp)
    144e:	e8 52 ff ff ff       	call   13a5 <write>
}
    1453:	c9                   	leave  
    1454:	c3                   	ret    

00001455 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1455:	55                   	push   %ebp
    1456:	89 e5                	mov    %esp,%ebp
    1458:	56                   	push   %esi
    1459:	53                   	push   %ebx
    145a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    145d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1464:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1468:	74 17                	je     1481 <printint+0x2c>
    146a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    146e:	79 11                	jns    1481 <printint+0x2c>
    neg = 1;
    1470:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1477:	8b 45 0c             	mov    0xc(%ebp),%eax
    147a:	f7 d8                	neg    %eax
    147c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    147f:	eb 06                	jmp    1487 <printint+0x32>
  } else {
    x = xx;
    1481:	8b 45 0c             	mov    0xc(%ebp),%eax
    1484:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1487:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    148e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1491:	8d 41 01             	lea    0x1(%ecx),%eax
    1494:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1497:	8b 5d 10             	mov    0x10(%ebp),%ebx
    149a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    149d:	ba 00 00 00 00       	mov    $0x0,%edx
    14a2:	f7 f3                	div    %ebx
    14a4:	89 d0                	mov    %edx,%eax
    14a6:	0f b6 80 6c 2b 00 00 	movzbl 0x2b6c(%eax),%eax
    14ad:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14b1:	8b 75 10             	mov    0x10(%ebp),%esi
    14b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14b7:	ba 00 00 00 00       	mov    $0x0,%edx
    14bc:	f7 f6                	div    %esi
    14be:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14c5:	75 c7                	jne    148e <printint+0x39>
  if(neg)
    14c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14cb:	74 10                	je     14dd <printint+0x88>
    buf[i++] = '-';
    14cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d0:	8d 50 01             	lea    0x1(%eax),%edx
    14d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14d6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    14db:	eb 1f                	jmp    14fc <printint+0xa7>
    14dd:	eb 1d                	jmp    14fc <printint+0xa7>
    putc(fd, buf[i]);
    14df:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e5:	01 d0                	add    %edx,%eax
    14e7:	0f b6 00             	movzbl (%eax),%eax
    14ea:	0f be c0             	movsbl %al,%eax
    14ed:	89 44 24 04          	mov    %eax,0x4(%esp)
    14f1:	8b 45 08             	mov    0x8(%ebp),%eax
    14f4:	89 04 24             	mov    %eax,(%esp)
    14f7:	e8 31 ff ff ff       	call   142d <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    14fc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1500:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1504:	79 d9                	jns    14df <printint+0x8a>
    putc(fd, buf[i]);
}
    1506:	83 c4 30             	add    $0x30,%esp
    1509:	5b                   	pop    %ebx
    150a:	5e                   	pop    %esi
    150b:	5d                   	pop    %ebp
    150c:	c3                   	ret    

0000150d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    150d:	55                   	push   %ebp
    150e:	89 e5                	mov    %esp,%ebp
    1510:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1513:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    151a:	8d 45 0c             	lea    0xc(%ebp),%eax
    151d:	83 c0 04             	add    $0x4,%eax
    1520:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1523:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    152a:	e9 7c 01 00 00       	jmp    16ab <printf+0x19e>
    c = fmt[i] & 0xff;
    152f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1532:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1535:	01 d0                	add    %edx,%eax
    1537:	0f b6 00             	movzbl (%eax),%eax
    153a:	0f be c0             	movsbl %al,%eax
    153d:	25 ff 00 00 00       	and    $0xff,%eax
    1542:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1545:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1549:	75 2c                	jne    1577 <printf+0x6a>
      if(c == '%'){
    154b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    154f:	75 0c                	jne    155d <printf+0x50>
        state = '%';
    1551:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1558:	e9 4a 01 00 00       	jmp    16a7 <printf+0x19a>
      } else {
        putc(fd, c);
    155d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1560:	0f be c0             	movsbl %al,%eax
    1563:	89 44 24 04          	mov    %eax,0x4(%esp)
    1567:	8b 45 08             	mov    0x8(%ebp),%eax
    156a:	89 04 24             	mov    %eax,(%esp)
    156d:	e8 bb fe ff ff       	call   142d <putc>
    1572:	e9 30 01 00 00       	jmp    16a7 <printf+0x19a>
      }
    } else if(state == '%'){
    1577:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    157b:	0f 85 26 01 00 00    	jne    16a7 <printf+0x19a>
      if(c == 'd'){
    1581:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1585:	75 2d                	jne    15b4 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1587:	8b 45 e8             	mov    -0x18(%ebp),%eax
    158a:	8b 00                	mov    (%eax),%eax
    158c:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1593:	00 
    1594:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    159b:	00 
    159c:	89 44 24 04          	mov    %eax,0x4(%esp)
    15a0:	8b 45 08             	mov    0x8(%ebp),%eax
    15a3:	89 04 24             	mov    %eax,(%esp)
    15a6:	e8 aa fe ff ff       	call   1455 <printint>
        ap++;
    15ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15af:	e9 ec 00 00 00       	jmp    16a0 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    15b4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15b8:	74 06                	je     15c0 <printf+0xb3>
    15ba:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15be:	75 2d                	jne    15ed <printf+0xe0>
        printint(fd, *ap, 16, 0);
    15c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15c3:	8b 00                	mov    (%eax),%eax
    15c5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    15cc:	00 
    15cd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    15d4:	00 
    15d5:	89 44 24 04          	mov    %eax,0x4(%esp)
    15d9:	8b 45 08             	mov    0x8(%ebp),%eax
    15dc:	89 04 24             	mov    %eax,(%esp)
    15df:	e8 71 fe ff ff       	call   1455 <printint>
        ap++;
    15e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15e8:	e9 b3 00 00 00       	jmp    16a0 <printf+0x193>
      } else if(c == 's'){
    15ed:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    15f1:	75 45                	jne    1638 <printf+0x12b>
        s = (char*)*ap;
    15f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15f6:	8b 00                	mov    (%eax),%eax
    15f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    15fb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    15ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1603:	75 09                	jne    160e <printf+0x101>
          s = "(null)";
    1605:	c7 45 f4 ff 18 00 00 	movl   $0x18ff,-0xc(%ebp)
        while(*s != 0){
    160c:	eb 1e                	jmp    162c <printf+0x11f>
    160e:	eb 1c                	jmp    162c <printf+0x11f>
          putc(fd, *s);
    1610:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1613:	0f b6 00             	movzbl (%eax),%eax
    1616:	0f be c0             	movsbl %al,%eax
    1619:	89 44 24 04          	mov    %eax,0x4(%esp)
    161d:	8b 45 08             	mov    0x8(%ebp),%eax
    1620:	89 04 24             	mov    %eax,(%esp)
    1623:	e8 05 fe ff ff       	call   142d <putc>
          s++;
    1628:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    162f:	0f b6 00             	movzbl (%eax),%eax
    1632:	84 c0                	test   %al,%al
    1634:	75 da                	jne    1610 <printf+0x103>
    1636:	eb 68                	jmp    16a0 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1638:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    163c:	75 1d                	jne    165b <printf+0x14e>
        putc(fd, *ap);
    163e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1641:	8b 00                	mov    (%eax),%eax
    1643:	0f be c0             	movsbl %al,%eax
    1646:	89 44 24 04          	mov    %eax,0x4(%esp)
    164a:	8b 45 08             	mov    0x8(%ebp),%eax
    164d:	89 04 24             	mov    %eax,(%esp)
    1650:	e8 d8 fd ff ff       	call   142d <putc>
        ap++;
    1655:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1659:	eb 45                	jmp    16a0 <printf+0x193>
      } else if(c == '%'){
    165b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    165f:	75 17                	jne    1678 <printf+0x16b>
        putc(fd, c);
    1661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1664:	0f be c0             	movsbl %al,%eax
    1667:	89 44 24 04          	mov    %eax,0x4(%esp)
    166b:	8b 45 08             	mov    0x8(%ebp),%eax
    166e:	89 04 24             	mov    %eax,(%esp)
    1671:	e8 b7 fd ff ff       	call   142d <putc>
    1676:	eb 28                	jmp    16a0 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1678:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    167f:	00 
    1680:	8b 45 08             	mov    0x8(%ebp),%eax
    1683:	89 04 24             	mov    %eax,(%esp)
    1686:	e8 a2 fd ff ff       	call   142d <putc>
        putc(fd, c);
    168b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    168e:	0f be c0             	movsbl %al,%eax
    1691:	89 44 24 04          	mov    %eax,0x4(%esp)
    1695:	8b 45 08             	mov    0x8(%ebp),%eax
    1698:	89 04 24             	mov    %eax,(%esp)
    169b:	e8 8d fd ff ff       	call   142d <putc>
      }
      state = 0;
    16a0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    16a7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16ab:	8b 55 0c             	mov    0xc(%ebp),%edx
    16ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16b1:	01 d0                	add    %edx,%eax
    16b3:	0f b6 00             	movzbl (%eax),%eax
    16b6:	84 c0                	test   %al,%al
    16b8:	0f 85 71 fe ff ff    	jne    152f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    16be:	c9                   	leave  
    16bf:	c3                   	ret    

000016c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16c0:	55                   	push   %ebp
    16c1:	89 e5                	mov    %esp,%ebp
    16c3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16c6:	8b 45 08             	mov    0x8(%ebp),%eax
    16c9:	83 e8 08             	sub    $0x8,%eax
    16cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16cf:	a1 88 2b 00 00       	mov    0x2b88,%eax
    16d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16d7:	eb 24                	jmp    16fd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16dc:	8b 00                	mov    (%eax),%eax
    16de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16e1:	77 12                	ja     16f5 <free+0x35>
    16e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16e9:	77 24                	ja     170f <free+0x4f>
    16eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ee:	8b 00                	mov    (%eax),%eax
    16f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16f3:	77 1a                	ja     170f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f8:	8b 00                	mov    (%eax),%eax
    16fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1700:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1703:	76 d4                	jbe    16d9 <free+0x19>
    1705:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1708:	8b 00                	mov    (%eax),%eax
    170a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    170d:	76 ca                	jbe    16d9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    170f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1712:	8b 40 04             	mov    0x4(%eax),%eax
    1715:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    171c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    171f:	01 c2                	add    %eax,%edx
    1721:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1724:	8b 00                	mov    (%eax),%eax
    1726:	39 c2                	cmp    %eax,%edx
    1728:	75 24                	jne    174e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    172a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    172d:	8b 50 04             	mov    0x4(%eax),%edx
    1730:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1733:	8b 00                	mov    (%eax),%eax
    1735:	8b 40 04             	mov    0x4(%eax),%eax
    1738:	01 c2                	add    %eax,%edx
    173a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    173d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1740:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1743:	8b 00                	mov    (%eax),%eax
    1745:	8b 10                	mov    (%eax),%edx
    1747:	8b 45 f8             	mov    -0x8(%ebp),%eax
    174a:	89 10                	mov    %edx,(%eax)
    174c:	eb 0a                	jmp    1758 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    174e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1751:	8b 10                	mov    (%eax),%edx
    1753:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1756:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1758:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175b:	8b 40 04             	mov    0x4(%eax),%eax
    175e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1765:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1768:	01 d0                	add    %edx,%eax
    176a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    176d:	75 20                	jne    178f <free+0xcf>
    p->s.size += bp->s.size;
    176f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1772:	8b 50 04             	mov    0x4(%eax),%edx
    1775:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1778:	8b 40 04             	mov    0x4(%eax),%eax
    177b:	01 c2                	add    %eax,%edx
    177d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1780:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1783:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1786:	8b 10                	mov    (%eax),%edx
    1788:	8b 45 fc             	mov    -0x4(%ebp),%eax
    178b:	89 10                	mov    %edx,(%eax)
    178d:	eb 08                	jmp    1797 <free+0xd7>
  } else
    p->s.ptr = bp;
    178f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1792:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1795:	89 10                	mov    %edx,(%eax)
  freep = p;
    1797:	8b 45 fc             	mov    -0x4(%ebp),%eax
    179a:	a3 88 2b 00 00       	mov    %eax,0x2b88
}
    179f:	c9                   	leave  
    17a0:	c3                   	ret    

000017a1 <morecore>:

static Header*
morecore(uint nu)
{
    17a1:	55                   	push   %ebp
    17a2:	89 e5                	mov    %esp,%ebp
    17a4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17a7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    17ae:	77 07                	ja     17b7 <morecore+0x16>
    nu = 4096;
    17b0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17b7:	8b 45 08             	mov    0x8(%ebp),%eax
    17ba:	c1 e0 03             	shl    $0x3,%eax
    17bd:	89 04 24             	mov    %eax,(%esp)
    17c0:	e8 48 fc ff ff       	call   140d <sbrk>
    17c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17c8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17cc:	75 07                	jne    17d5 <morecore+0x34>
    return 0;
    17ce:	b8 00 00 00 00       	mov    $0x0,%eax
    17d3:	eb 22                	jmp    17f7 <morecore+0x56>
  hp = (Header*)p;
    17d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    17db:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17de:	8b 55 08             	mov    0x8(%ebp),%edx
    17e1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    17e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17e7:	83 c0 08             	add    $0x8,%eax
    17ea:	89 04 24             	mov    %eax,(%esp)
    17ed:	e8 ce fe ff ff       	call   16c0 <free>
  return freep;
    17f2:	a1 88 2b 00 00       	mov    0x2b88,%eax
}
    17f7:	c9                   	leave  
    17f8:	c3                   	ret    

000017f9 <malloc>:

void*
malloc(uint nbytes)
{
    17f9:	55                   	push   %ebp
    17fa:	89 e5                	mov    %esp,%ebp
    17fc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1802:	83 c0 07             	add    $0x7,%eax
    1805:	c1 e8 03             	shr    $0x3,%eax
    1808:	83 c0 01             	add    $0x1,%eax
    180b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    180e:	a1 88 2b 00 00       	mov    0x2b88,%eax
    1813:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1816:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    181a:	75 23                	jne    183f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    181c:	c7 45 f0 80 2b 00 00 	movl   $0x2b80,-0x10(%ebp)
    1823:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1826:	a3 88 2b 00 00       	mov    %eax,0x2b88
    182b:	a1 88 2b 00 00       	mov    0x2b88,%eax
    1830:	a3 80 2b 00 00       	mov    %eax,0x2b80
    base.s.size = 0;
    1835:	c7 05 84 2b 00 00 00 	movl   $0x0,0x2b84
    183c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    183f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1842:	8b 00                	mov    (%eax),%eax
    1844:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1847:	8b 45 f4             	mov    -0xc(%ebp),%eax
    184a:	8b 40 04             	mov    0x4(%eax),%eax
    184d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1850:	72 4d                	jb     189f <malloc+0xa6>
      if(p->s.size == nunits)
    1852:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1855:	8b 40 04             	mov    0x4(%eax),%eax
    1858:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    185b:	75 0c                	jne    1869 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    185d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1860:	8b 10                	mov    (%eax),%edx
    1862:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1865:	89 10                	mov    %edx,(%eax)
    1867:	eb 26                	jmp    188f <malloc+0x96>
      else {
        p->s.size -= nunits;
    1869:	8b 45 f4             	mov    -0xc(%ebp),%eax
    186c:	8b 40 04             	mov    0x4(%eax),%eax
    186f:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1872:	89 c2                	mov    %eax,%edx
    1874:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1877:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    187a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187d:	8b 40 04             	mov    0x4(%eax),%eax
    1880:	c1 e0 03             	shl    $0x3,%eax
    1883:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1886:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1889:	8b 55 ec             	mov    -0x14(%ebp),%edx
    188c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    188f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1892:	a3 88 2b 00 00       	mov    %eax,0x2b88
      return (void*)(p + 1);
    1897:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189a:	83 c0 08             	add    $0x8,%eax
    189d:	eb 38                	jmp    18d7 <malloc+0xde>
    }
    if(p == freep)
    189f:	a1 88 2b 00 00       	mov    0x2b88,%eax
    18a4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18a7:	75 1b                	jne    18c4 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    18a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    18ac:	89 04 24             	mov    %eax,(%esp)
    18af:	e8 ed fe ff ff       	call   17a1 <morecore>
    18b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18bb:	75 07                	jne    18c4 <malloc+0xcb>
        return 0;
    18bd:	b8 00 00 00 00       	mov    $0x0,%eax
    18c2:	eb 13                	jmp    18d7 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18cd:	8b 00                	mov    (%eax),%eax
    18cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    18d2:	e9 70 ff ff ff       	jmp    1847 <malloc+0x4e>
}
    18d7:	c9                   	leave  
    18d8:	c3                   	ret    
