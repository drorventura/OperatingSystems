
_wc:     file format elf32-i386


Disassembly of section .text:

00001000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
    1006:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    100d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1010:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1013:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
    1019:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1020:	eb 68                	jmp    108a <wc+0x8a>
    for(i=0; i<n; i++){
    1022:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1029:	eb 57                	jmp    1082 <wc+0x82>
      c++;
    102b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
    102f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1032:	05 80 2c 00 00       	add    $0x2c80,%eax
    1037:	0f b6 00             	movzbl (%eax),%eax
    103a:	3c 0a                	cmp    $0xa,%al
    103c:	75 04                	jne    1042 <wc+0x42>
        l++;
    103e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
    1042:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1045:	05 80 2c 00 00       	add    $0x2c80,%eax
    104a:	0f b6 00             	movzbl (%eax),%eax
    104d:	0f be c0             	movsbl %al,%eax
    1050:	89 44 24 04          	mov    %eax,0x4(%esp)
    1054:	c7 04 24 95 19 00 00 	movl   $0x1995,(%esp)
    105b:	e8 58 02 00 00       	call   12b8 <strchr>
    1060:	85 c0                	test   %eax,%eax
    1062:	74 09                	je     106d <wc+0x6d>
        inword = 0;
    1064:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    106b:	eb 11                	jmp    107e <wc+0x7e>
      else if(!inword){
    106d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1071:	75 0b                	jne    107e <wc+0x7e>
        w++;
    1073:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
    1077:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
    107e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1082:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1085:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    1088:	7c a1                	jl     102b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    108a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    1091:	00 
    1092:	c7 44 24 04 80 2c 00 	movl   $0x2c80,0x4(%esp)
    1099:	00 
    109a:	8b 45 08             	mov    0x8(%ebp),%eax
    109d:	89 04 24             	mov    %eax,(%esp)
    10a0:	e8 b4 03 00 00       	call   1459 <read>
    10a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    10a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10ac:	0f 8f 70 ff ff ff    	jg     1022 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
    10b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10b6:	79 19                	jns    10d1 <wc+0xd1>
    printf(1, "wc: read error\n");
    10b8:	c7 44 24 04 9b 19 00 	movl   $0x199b,0x4(%esp)
    10bf:	00 
    10c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10c7:	e8 fd 04 00 00       	call   15c9 <printf>
    exit();
    10cc:	e8 70 03 00 00       	call   1441 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
    10d1:	8b 45 0c             	mov    0xc(%ebp),%eax
    10d4:	89 44 24 14          	mov    %eax,0x14(%esp)
    10d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10db:	89 44 24 10          	mov    %eax,0x10(%esp)
    10df:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
    10e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10e9:	89 44 24 08          	mov    %eax,0x8(%esp)
    10ed:	c7 44 24 04 ab 19 00 	movl   $0x19ab,0x4(%esp)
    10f4:	00 
    10f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10fc:	e8 c8 04 00 00       	call   15c9 <printf>
}
    1101:	c9                   	leave  
    1102:	c3                   	ret    

00001103 <main>:

int
main(int argc, char *argv[])
{
    1103:	55                   	push   %ebp
    1104:	89 e5                	mov    %esp,%ebp
    1106:	83 e4 f0             	and    $0xfffffff0,%esp
    1109:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
    110c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1110:	7f 19                	jg     112b <main+0x28>
    wc(0, "");
    1112:	c7 44 24 04 b8 19 00 	movl   $0x19b8,0x4(%esp)
    1119:	00 
    111a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1121:	e8 da fe ff ff       	call   1000 <wc>
    exit();
    1126:	e8 16 03 00 00       	call   1441 <exit>
  }

  for(i = 1; i < argc; i++){
    112b:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    1132:	00 
    1133:	e9 8f 00 00 00       	jmp    11c7 <main+0xc4>
    if((fd = open(argv[i], 0)) < 0){
    1138:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    113c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1143:	8b 45 0c             	mov    0xc(%ebp),%eax
    1146:	01 d0                	add    %edx,%eax
    1148:	8b 00                	mov    (%eax),%eax
    114a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1151:	00 
    1152:	89 04 24             	mov    %eax,(%esp)
    1155:	e8 27 03 00 00       	call   1481 <open>
    115a:	89 44 24 18          	mov    %eax,0x18(%esp)
    115e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    1163:	79 2f                	jns    1194 <main+0x91>
      printf(1, "cat: cannot open %s\n", argv[i]);
    1165:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1170:	8b 45 0c             	mov    0xc(%ebp),%eax
    1173:	01 d0                	add    %edx,%eax
    1175:	8b 00                	mov    (%eax),%eax
    1177:	89 44 24 08          	mov    %eax,0x8(%esp)
    117b:	c7 44 24 04 b9 19 00 	movl   $0x19b9,0x4(%esp)
    1182:	00 
    1183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    118a:	e8 3a 04 00 00       	call   15c9 <printf>
      exit();
    118f:	e8 ad 02 00 00       	call   1441 <exit>
    }
    wc(fd, argv[i]);
    1194:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1198:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    119f:	8b 45 0c             	mov    0xc(%ebp),%eax
    11a2:	01 d0                	add    %edx,%eax
    11a4:	8b 00                	mov    (%eax),%eax
    11a6:	89 44 24 04          	mov    %eax,0x4(%esp)
    11aa:	8b 44 24 18          	mov    0x18(%esp),%eax
    11ae:	89 04 24             	mov    %eax,(%esp)
    11b1:	e8 4a fe ff ff       	call   1000 <wc>
    close(fd);
    11b6:	8b 44 24 18          	mov    0x18(%esp),%eax
    11ba:	89 04 24             	mov    %eax,(%esp)
    11bd:	e8 a7 02 00 00       	call   1469 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
    11c2:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    11c7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    11cb:	3b 45 08             	cmp    0x8(%ebp),%eax
    11ce:	0f 8c 64 ff ff ff    	jl     1138 <main+0x35>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
    11d4:	e8 68 02 00 00       	call   1441 <exit>

000011d9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11d9:	55                   	push   %ebp
    11da:	89 e5                	mov    %esp,%ebp
    11dc:	57                   	push   %edi
    11dd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    11de:	8b 4d 08             	mov    0x8(%ebp),%ecx
    11e1:	8b 55 10             	mov    0x10(%ebp),%edx
    11e4:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e7:	89 cb                	mov    %ecx,%ebx
    11e9:	89 df                	mov    %ebx,%edi
    11eb:	89 d1                	mov    %edx,%ecx
    11ed:	fc                   	cld    
    11ee:	f3 aa                	rep stos %al,%es:(%edi)
    11f0:	89 ca                	mov    %ecx,%edx
    11f2:	89 fb                	mov    %edi,%ebx
    11f4:	89 5d 08             	mov    %ebx,0x8(%ebp)
    11f7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11fa:	5b                   	pop    %ebx
    11fb:	5f                   	pop    %edi
    11fc:	5d                   	pop    %ebp
    11fd:	c3                   	ret    

000011fe <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11fe:	55                   	push   %ebp
    11ff:	89 e5                	mov    %esp,%ebp
    1201:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1204:	8b 45 08             	mov    0x8(%ebp),%eax
    1207:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    120a:	90                   	nop
    120b:	8b 45 08             	mov    0x8(%ebp),%eax
    120e:	8d 50 01             	lea    0x1(%eax),%edx
    1211:	89 55 08             	mov    %edx,0x8(%ebp)
    1214:	8b 55 0c             	mov    0xc(%ebp),%edx
    1217:	8d 4a 01             	lea    0x1(%edx),%ecx
    121a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    121d:	0f b6 12             	movzbl (%edx),%edx
    1220:	88 10                	mov    %dl,(%eax)
    1222:	0f b6 00             	movzbl (%eax),%eax
    1225:	84 c0                	test   %al,%al
    1227:	75 e2                	jne    120b <strcpy+0xd>
    ;
  return os;
    1229:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    122c:	c9                   	leave  
    122d:	c3                   	ret    

0000122e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    122e:	55                   	push   %ebp
    122f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1231:	eb 08                	jmp    123b <strcmp+0xd>
    p++, q++;
    1233:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1237:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    123b:	8b 45 08             	mov    0x8(%ebp),%eax
    123e:	0f b6 00             	movzbl (%eax),%eax
    1241:	84 c0                	test   %al,%al
    1243:	74 10                	je     1255 <strcmp+0x27>
    1245:	8b 45 08             	mov    0x8(%ebp),%eax
    1248:	0f b6 10             	movzbl (%eax),%edx
    124b:	8b 45 0c             	mov    0xc(%ebp),%eax
    124e:	0f b6 00             	movzbl (%eax),%eax
    1251:	38 c2                	cmp    %al,%dl
    1253:	74 de                	je     1233 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1255:	8b 45 08             	mov    0x8(%ebp),%eax
    1258:	0f b6 00             	movzbl (%eax),%eax
    125b:	0f b6 d0             	movzbl %al,%edx
    125e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1261:	0f b6 00             	movzbl (%eax),%eax
    1264:	0f b6 c0             	movzbl %al,%eax
    1267:	29 c2                	sub    %eax,%edx
    1269:	89 d0                	mov    %edx,%eax
}
    126b:	5d                   	pop    %ebp
    126c:	c3                   	ret    

0000126d <strlen>:

uint
strlen(char *s)
{
    126d:	55                   	push   %ebp
    126e:	89 e5                	mov    %esp,%ebp
    1270:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1273:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    127a:	eb 04                	jmp    1280 <strlen+0x13>
    127c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1280:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1283:	8b 45 08             	mov    0x8(%ebp),%eax
    1286:	01 d0                	add    %edx,%eax
    1288:	0f b6 00             	movzbl (%eax),%eax
    128b:	84 c0                	test   %al,%al
    128d:	75 ed                	jne    127c <strlen+0xf>
    ;
  return n;
    128f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1292:	c9                   	leave  
    1293:	c3                   	ret    

00001294 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1294:	55                   	push   %ebp
    1295:	89 e5                	mov    %esp,%ebp
    1297:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    129a:	8b 45 10             	mov    0x10(%ebp),%eax
    129d:	89 44 24 08          	mov    %eax,0x8(%esp)
    12a1:	8b 45 0c             	mov    0xc(%ebp),%eax
    12a4:	89 44 24 04          	mov    %eax,0x4(%esp)
    12a8:	8b 45 08             	mov    0x8(%ebp),%eax
    12ab:	89 04 24             	mov    %eax,(%esp)
    12ae:	e8 26 ff ff ff       	call   11d9 <stosb>
  return dst;
    12b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12b6:	c9                   	leave  
    12b7:	c3                   	ret    

000012b8 <strchr>:

char*
strchr(const char *s, char c)
{
    12b8:	55                   	push   %ebp
    12b9:	89 e5                	mov    %esp,%ebp
    12bb:	83 ec 04             	sub    $0x4,%esp
    12be:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    12c4:	eb 14                	jmp    12da <strchr+0x22>
    if(*s == c)
    12c6:	8b 45 08             	mov    0x8(%ebp),%eax
    12c9:	0f b6 00             	movzbl (%eax),%eax
    12cc:	3a 45 fc             	cmp    -0x4(%ebp),%al
    12cf:	75 05                	jne    12d6 <strchr+0x1e>
      return (char*)s;
    12d1:	8b 45 08             	mov    0x8(%ebp),%eax
    12d4:	eb 13                	jmp    12e9 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    12d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12da:	8b 45 08             	mov    0x8(%ebp),%eax
    12dd:	0f b6 00             	movzbl (%eax),%eax
    12e0:	84 c0                	test   %al,%al
    12e2:	75 e2                	jne    12c6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    12e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12e9:	c9                   	leave  
    12ea:	c3                   	ret    

000012eb <gets>:

char*
gets(char *buf, int max)
{
    12eb:	55                   	push   %ebp
    12ec:	89 e5                	mov    %esp,%ebp
    12ee:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12f8:	eb 4c                	jmp    1346 <gets+0x5b>
    cc = read(0, &c, 1);
    12fa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1301:	00 
    1302:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1305:	89 44 24 04          	mov    %eax,0x4(%esp)
    1309:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1310:	e8 44 01 00 00       	call   1459 <read>
    1315:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1318:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    131c:	7f 02                	jg     1320 <gets+0x35>
      break;
    131e:	eb 31                	jmp    1351 <gets+0x66>
    buf[i++] = c;
    1320:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1323:	8d 50 01             	lea    0x1(%eax),%edx
    1326:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1329:	89 c2                	mov    %eax,%edx
    132b:	8b 45 08             	mov    0x8(%ebp),%eax
    132e:	01 c2                	add    %eax,%edx
    1330:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1334:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1336:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    133a:	3c 0a                	cmp    $0xa,%al
    133c:	74 13                	je     1351 <gets+0x66>
    133e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1342:	3c 0d                	cmp    $0xd,%al
    1344:	74 0b                	je     1351 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1346:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1349:	83 c0 01             	add    $0x1,%eax
    134c:	3b 45 0c             	cmp    0xc(%ebp),%eax
    134f:	7c a9                	jl     12fa <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1351:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1354:	8b 45 08             	mov    0x8(%ebp),%eax
    1357:	01 d0                	add    %edx,%eax
    1359:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    135c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    135f:	c9                   	leave  
    1360:	c3                   	ret    

00001361 <stat>:

int
stat(char *n, struct stat *st)
{
    1361:	55                   	push   %ebp
    1362:	89 e5                	mov    %esp,%ebp
    1364:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1367:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    136e:	00 
    136f:	8b 45 08             	mov    0x8(%ebp),%eax
    1372:	89 04 24             	mov    %eax,(%esp)
    1375:	e8 07 01 00 00       	call   1481 <open>
    137a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    137d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1381:	79 07                	jns    138a <stat+0x29>
    return -1;
    1383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1388:	eb 23                	jmp    13ad <stat+0x4c>
  r = fstat(fd, st);
    138a:	8b 45 0c             	mov    0xc(%ebp),%eax
    138d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1391:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1394:	89 04 24             	mov    %eax,(%esp)
    1397:	e8 fd 00 00 00       	call   1499 <fstat>
    139c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    139f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13a2:	89 04 24             	mov    %eax,(%esp)
    13a5:	e8 bf 00 00 00       	call   1469 <close>
  return r;
    13aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    13ad:	c9                   	leave  
    13ae:	c3                   	ret    

000013af <atoi>:

int
atoi(const char *s)
{
    13af:	55                   	push   %ebp
    13b0:	89 e5                	mov    %esp,%ebp
    13b2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    13b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    13bc:	eb 25                	jmp    13e3 <atoi+0x34>
    n = n*10 + *s++ - '0';
    13be:	8b 55 fc             	mov    -0x4(%ebp),%edx
    13c1:	89 d0                	mov    %edx,%eax
    13c3:	c1 e0 02             	shl    $0x2,%eax
    13c6:	01 d0                	add    %edx,%eax
    13c8:	01 c0                	add    %eax,%eax
    13ca:	89 c1                	mov    %eax,%ecx
    13cc:	8b 45 08             	mov    0x8(%ebp),%eax
    13cf:	8d 50 01             	lea    0x1(%eax),%edx
    13d2:	89 55 08             	mov    %edx,0x8(%ebp)
    13d5:	0f b6 00             	movzbl (%eax),%eax
    13d8:	0f be c0             	movsbl %al,%eax
    13db:	01 c8                	add    %ecx,%eax
    13dd:	83 e8 30             	sub    $0x30,%eax
    13e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    13e3:	8b 45 08             	mov    0x8(%ebp),%eax
    13e6:	0f b6 00             	movzbl (%eax),%eax
    13e9:	3c 2f                	cmp    $0x2f,%al
    13eb:	7e 0a                	jle    13f7 <atoi+0x48>
    13ed:	8b 45 08             	mov    0x8(%ebp),%eax
    13f0:	0f b6 00             	movzbl (%eax),%eax
    13f3:	3c 39                	cmp    $0x39,%al
    13f5:	7e c7                	jle    13be <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    13f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13fa:	c9                   	leave  
    13fb:	c3                   	ret    

000013fc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    13fc:	55                   	push   %ebp
    13fd:	89 e5                	mov    %esp,%ebp
    13ff:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1402:	8b 45 08             	mov    0x8(%ebp),%eax
    1405:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1408:	8b 45 0c             	mov    0xc(%ebp),%eax
    140b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    140e:	eb 17                	jmp    1427 <memmove+0x2b>
    *dst++ = *src++;
    1410:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1413:	8d 50 01             	lea    0x1(%eax),%edx
    1416:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1419:	8b 55 f8             	mov    -0x8(%ebp),%edx
    141c:	8d 4a 01             	lea    0x1(%edx),%ecx
    141f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1422:	0f b6 12             	movzbl (%edx),%edx
    1425:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1427:	8b 45 10             	mov    0x10(%ebp),%eax
    142a:	8d 50 ff             	lea    -0x1(%eax),%edx
    142d:	89 55 10             	mov    %edx,0x10(%ebp)
    1430:	85 c0                	test   %eax,%eax
    1432:	7f dc                	jg     1410 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1434:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1437:	c9                   	leave  
    1438:	c3                   	ret    

00001439 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1439:	b8 01 00 00 00       	mov    $0x1,%eax
    143e:	cd 40                	int    $0x40
    1440:	c3                   	ret    

00001441 <exit>:
SYSCALL(exit)
    1441:	b8 02 00 00 00       	mov    $0x2,%eax
    1446:	cd 40                	int    $0x40
    1448:	c3                   	ret    

00001449 <wait>:
SYSCALL(wait)
    1449:	b8 03 00 00 00       	mov    $0x3,%eax
    144e:	cd 40                	int    $0x40
    1450:	c3                   	ret    

00001451 <pipe>:
SYSCALL(pipe)
    1451:	b8 04 00 00 00       	mov    $0x4,%eax
    1456:	cd 40                	int    $0x40
    1458:	c3                   	ret    

00001459 <read>:
SYSCALL(read)
    1459:	b8 05 00 00 00       	mov    $0x5,%eax
    145e:	cd 40                	int    $0x40
    1460:	c3                   	ret    

00001461 <write>:
SYSCALL(write)
    1461:	b8 10 00 00 00       	mov    $0x10,%eax
    1466:	cd 40                	int    $0x40
    1468:	c3                   	ret    

00001469 <close>:
SYSCALL(close)
    1469:	b8 15 00 00 00       	mov    $0x15,%eax
    146e:	cd 40                	int    $0x40
    1470:	c3                   	ret    

00001471 <kill>:
SYSCALL(kill)
    1471:	b8 06 00 00 00       	mov    $0x6,%eax
    1476:	cd 40                	int    $0x40
    1478:	c3                   	ret    

00001479 <exec>:
SYSCALL(exec)
    1479:	b8 07 00 00 00       	mov    $0x7,%eax
    147e:	cd 40                	int    $0x40
    1480:	c3                   	ret    

00001481 <open>:
SYSCALL(open)
    1481:	b8 0f 00 00 00       	mov    $0xf,%eax
    1486:	cd 40                	int    $0x40
    1488:	c3                   	ret    

00001489 <mknod>:
SYSCALL(mknod)
    1489:	b8 11 00 00 00       	mov    $0x11,%eax
    148e:	cd 40                	int    $0x40
    1490:	c3                   	ret    

00001491 <unlink>:
SYSCALL(unlink)
    1491:	b8 12 00 00 00       	mov    $0x12,%eax
    1496:	cd 40                	int    $0x40
    1498:	c3                   	ret    

00001499 <fstat>:
SYSCALL(fstat)
    1499:	b8 08 00 00 00       	mov    $0x8,%eax
    149e:	cd 40                	int    $0x40
    14a0:	c3                   	ret    

000014a1 <link>:
SYSCALL(link)
    14a1:	b8 13 00 00 00       	mov    $0x13,%eax
    14a6:	cd 40                	int    $0x40
    14a8:	c3                   	ret    

000014a9 <mkdir>:
SYSCALL(mkdir)
    14a9:	b8 14 00 00 00       	mov    $0x14,%eax
    14ae:	cd 40                	int    $0x40
    14b0:	c3                   	ret    

000014b1 <chdir>:
SYSCALL(chdir)
    14b1:	b8 09 00 00 00       	mov    $0x9,%eax
    14b6:	cd 40                	int    $0x40
    14b8:	c3                   	ret    

000014b9 <dup>:
SYSCALL(dup)
    14b9:	b8 0a 00 00 00       	mov    $0xa,%eax
    14be:	cd 40                	int    $0x40
    14c0:	c3                   	ret    

000014c1 <getpid>:
SYSCALL(getpid)
    14c1:	b8 0b 00 00 00       	mov    $0xb,%eax
    14c6:	cd 40                	int    $0x40
    14c8:	c3                   	ret    

000014c9 <sbrk>:
SYSCALL(sbrk)
    14c9:	b8 0c 00 00 00       	mov    $0xc,%eax
    14ce:	cd 40                	int    $0x40
    14d0:	c3                   	ret    

000014d1 <sleep>:
SYSCALL(sleep)
    14d1:	b8 0d 00 00 00       	mov    $0xd,%eax
    14d6:	cd 40                	int    $0x40
    14d8:	c3                   	ret    

000014d9 <uptime>:
SYSCALL(uptime)
    14d9:	b8 0e 00 00 00       	mov    $0xe,%eax
    14de:	cd 40                	int    $0x40
    14e0:	c3                   	ret    

000014e1 <cowfork>:
SYSCALL(cowfork) //3.4
    14e1:	b8 16 00 00 00       	mov    $0x16,%eax
    14e6:	cd 40                	int    $0x40
    14e8:	c3                   	ret    

000014e9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    14e9:	55                   	push   %ebp
    14ea:	89 e5                	mov    %esp,%ebp
    14ec:	83 ec 18             	sub    $0x18,%esp
    14ef:	8b 45 0c             	mov    0xc(%ebp),%eax
    14f2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    14f5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    14fc:	00 
    14fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1500:	89 44 24 04          	mov    %eax,0x4(%esp)
    1504:	8b 45 08             	mov    0x8(%ebp),%eax
    1507:	89 04 24             	mov    %eax,(%esp)
    150a:	e8 52 ff ff ff       	call   1461 <write>
}
    150f:	c9                   	leave  
    1510:	c3                   	ret    

00001511 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1511:	55                   	push   %ebp
    1512:	89 e5                	mov    %esp,%ebp
    1514:	56                   	push   %esi
    1515:	53                   	push   %ebx
    1516:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1519:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1520:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1524:	74 17                	je     153d <printint+0x2c>
    1526:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    152a:	79 11                	jns    153d <printint+0x2c>
    neg = 1;
    152c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1533:	8b 45 0c             	mov    0xc(%ebp),%eax
    1536:	f7 d8                	neg    %eax
    1538:	89 45 ec             	mov    %eax,-0x14(%ebp)
    153b:	eb 06                	jmp    1543 <printint+0x32>
  } else {
    x = xx;
    153d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1540:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1543:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    154a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    154d:	8d 41 01             	lea    0x1(%ecx),%eax
    1550:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1553:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1556:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1559:	ba 00 00 00 00       	mov    $0x0,%edx
    155e:	f7 f3                	div    %ebx
    1560:	89 d0                	mov    %edx,%eax
    1562:	0f b6 80 3c 2c 00 00 	movzbl 0x2c3c(%eax),%eax
    1569:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    156d:	8b 75 10             	mov    0x10(%ebp),%esi
    1570:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1573:	ba 00 00 00 00       	mov    $0x0,%edx
    1578:	f7 f6                	div    %esi
    157a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    157d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1581:	75 c7                	jne    154a <printint+0x39>
  if(neg)
    1583:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1587:	74 10                	je     1599 <printint+0x88>
    buf[i++] = '-';
    1589:	8b 45 f4             	mov    -0xc(%ebp),%eax
    158c:	8d 50 01             	lea    0x1(%eax),%edx
    158f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1592:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1597:	eb 1f                	jmp    15b8 <printint+0xa7>
    1599:	eb 1d                	jmp    15b8 <printint+0xa7>
    putc(fd, buf[i]);
    159b:	8d 55 dc             	lea    -0x24(%ebp),%edx
    159e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a1:	01 d0                	add    %edx,%eax
    15a3:	0f b6 00             	movzbl (%eax),%eax
    15a6:	0f be c0             	movsbl %al,%eax
    15a9:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ad:	8b 45 08             	mov    0x8(%ebp),%eax
    15b0:	89 04 24             	mov    %eax,(%esp)
    15b3:	e8 31 ff ff ff       	call   14e9 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    15b8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    15bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15c0:	79 d9                	jns    159b <printint+0x8a>
    putc(fd, buf[i]);
}
    15c2:	83 c4 30             	add    $0x30,%esp
    15c5:	5b                   	pop    %ebx
    15c6:	5e                   	pop    %esi
    15c7:	5d                   	pop    %ebp
    15c8:	c3                   	ret    

000015c9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    15c9:	55                   	push   %ebp
    15ca:	89 e5                	mov    %esp,%ebp
    15cc:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    15cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    15d6:	8d 45 0c             	lea    0xc(%ebp),%eax
    15d9:	83 c0 04             	add    $0x4,%eax
    15dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    15df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    15e6:	e9 7c 01 00 00       	jmp    1767 <printf+0x19e>
    c = fmt[i] & 0xff;
    15eb:	8b 55 0c             	mov    0xc(%ebp),%edx
    15ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15f1:	01 d0                	add    %edx,%eax
    15f3:	0f b6 00             	movzbl (%eax),%eax
    15f6:	0f be c0             	movsbl %al,%eax
    15f9:	25 ff 00 00 00       	and    $0xff,%eax
    15fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1601:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1605:	75 2c                	jne    1633 <printf+0x6a>
      if(c == '%'){
    1607:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    160b:	75 0c                	jne    1619 <printf+0x50>
        state = '%';
    160d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1614:	e9 4a 01 00 00       	jmp    1763 <printf+0x19a>
      } else {
        putc(fd, c);
    1619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    161c:	0f be c0             	movsbl %al,%eax
    161f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1623:	8b 45 08             	mov    0x8(%ebp),%eax
    1626:	89 04 24             	mov    %eax,(%esp)
    1629:	e8 bb fe ff ff       	call   14e9 <putc>
    162e:	e9 30 01 00 00       	jmp    1763 <printf+0x19a>
      }
    } else if(state == '%'){
    1633:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1637:	0f 85 26 01 00 00    	jne    1763 <printf+0x19a>
      if(c == 'd'){
    163d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1641:	75 2d                	jne    1670 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1643:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1646:	8b 00                	mov    (%eax),%eax
    1648:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    164f:	00 
    1650:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1657:	00 
    1658:	89 44 24 04          	mov    %eax,0x4(%esp)
    165c:	8b 45 08             	mov    0x8(%ebp),%eax
    165f:	89 04 24             	mov    %eax,(%esp)
    1662:	e8 aa fe ff ff       	call   1511 <printint>
        ap++;
    1667:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    166b:	e9 ec 00 00 00       	jmp    175c <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1670:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1674:	74 06                	je     167c <printf+0xb3>
    1676:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    167a:	75 2d                	jne    16a9 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    167c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    167f:	8b 00                	mov    (%eax),%eax
    1681:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1688:	00 
    1689:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1690:	00 
    1691:	89 44 24 04          	mov    %eax,0x4(%esp)
    1695:	8b 45 08             	mov    0x8(%ebp),%eax
    1698:	89 04 24             	mov    %eax,(%esp)
    169b:	e8 71 fe ff ff       	call   1511 <printint>
        ap++;
    16a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16a4:	e9 b3 00 00 00       	jmp    175c <printf+0x193>
      } else if(c == 's'){
    16a9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    16ad:	75 45                	jne    16f4 <printf+0x12b>
        s = (char*)*ap;
    16af:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16b2:	8b 00                	mov    (%eax),%eax
    16b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    16b7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    16bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16bf:	75 09                	jne    16ca <printf+0x101>
          s = "(null)";
    16c1:	c7 45 f4 ce 19 00 00 	movl   $0x19ce,-0xc(%ebp)
        while(*s != 0){
    16c8:	eb 1e                	jmp    16e8 <printf+0x11f>
    16ca:	eb 1c                	jmp    16e8 <printf+0x11f>
          putc(fd, *s);
    16cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16cf:	0f b6 00             	movzbl (%eax),%eax
    16d2:	0f be c0             	movsbl %al,%eax
    16d5:	89 44 24 04          	mov    %eax,0x4(%esp)
    16d9:	8b 45 08             	mov    0x8(%ebp),%eax
    16dc:	89 04 24             	mov    %eax,(%esp)
    16df:	e8 05 fe ff ff       	call   14e9 <putc>
          s++;
    16e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    16e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16eb:	0f b6 00             	movzbl (%eax),%eax
    16ee:	84 c0                	test   %al,%al
    16f0:	75 da                	jne    16cc <printf+0x103>
    16f2:	eb 68                	jmp    175c <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    16f4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    16f8:	75 1d                	jne    1717 <printf+0x14e>
        putc(fd, *ap);
    16fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16fd:	8b 00                	mov    (%eax),%eax
    16ff:	0f be c0             	movsbl %al,%eax
    1702:	89 44 24 04          	mov    %eax,0x4(%esp)
    1706:	8b 45 08             	mov    0x8(%ebp),%eax
    1709:	89 04 24             	mov    %eax,(%esp)
    170c:	e8 d8 fd ff ff       	call   14e9 <putc>
        ap++;
    1711:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1715:	eb 45                	jmp    175c <printf+0x193>
      } else if(c == '%'){
    1717:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    171b:	75 17                	jne    1734 <printf+0x16b>
        putc(fd, c);
    171d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1720:	0f be c0             	movsbl %al,%eax
    1723:	89 44 24 04          	mov    %eax,0x4(%esp)
    1727:	8b 45 08             	mov    0x8(%ebp),%eax
    172a:	89 04 24             	mov    %eax,(%esp)
    172d:	e8 b7 fd ff ff       	call   14e9 <putc>
    1732:	eb 28                	jmp    175c <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1734:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    173b:	00 
    173c:	8b 45 08             	mov    0x8(%ebp),%eax
    173f:	89 04 24             	mov    %eax,(%esp)
    1742:	e8 a2 fd ff ff       	call   14e9 <putc>
        putc(fd, c);
    1747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    174a:	0f be c0             	movsbl %al,%eax
    174d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1751:	8b 45 08             	mov    0x8(%ebp),%eax
    1754:	89 04 24             	mov    %eax,(%esp)
    1757:	e8 8d fd ff ff       	call   14e9 <putc>
      }
      state = 0;
    175c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1763:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1767:	8b 55 0c             	mov    0xc(%ebp),%edx
    176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    176d:	01 d0                	add    %edx,%eax
    176f:	0f b6 00             	movzbl (%eax),%eax
    1772:	84 c0                	test   %al,%al
    1774:	0f 85 71 fe ff ff    	jne    15eb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    177a:	c9                   	leave  
    177b:	c3                   	ret    

0000177c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    177c:	55                   	push   %ebp
    177d:	89 e5                	mov    %esp,%ebp
    177f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1782:	8b 45 08             	mov    0x8(%ebp),%eax
    1785:	83 e8 08             	sub    $0x8,%eax
    1788:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    178b:	a1 68 2c 00 00       	mov    0x2c68,%eax
    1790:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1793:	eb 24                	jmp    17b9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1795:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1798:	8b 00                	mov    (%eax),%eax
    179a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    179d:	77 12                	ja     17b1 <free+0x35>
    179f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17a2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17a5:	77 24                	ja     17cb <free+0x4f>
    17a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17aa:	8b 00                	mov    (%eax),%eax
    17ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17af:	77 1a                	ja     17cb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b4:	8b 00                	mov    (%eax),%eax
    17b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    17b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17bc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17bf:	76 d4                	jbe    1795 <free+0x19>
    17c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c4:	8b 00                	mov    (%eax),%eax
    17c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17c9:	76 ca                	jbe    1795 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    17cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17ce:	8b 40 04             	mov    0x4(%eax),%eax
    17d1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17db:	01 c2                	add    %eax,%edx
    17dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17e0:	8b 00                	mov    (%eax),%eax
    17e2:	39 c2                	cmp    %eax,%edx
    17e4:	75 24                	jne    180a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    17e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17e9:	8b 50 04             	mov    0x4(%eax),%edx
    17ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ef:	8b 00                	mov    (%eax),%eax
    17f1:	8b 40 04             	mov    0x4(%eax),%eax
    17f4:	01 c2                	add    %eax,%edx
    17f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17f9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    17fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ff:	8b 00                	mov    (%eax),%eax
    1801:	8b 10                	mov    (%eax),%edx
    1803:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1806:	89 10                	mov    %edx,(%eax)
    1808:	eb 0a                	jmp    1814 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    180a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    180d:	8b 10                	mov    (%eax),%edx
    180f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1812:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1814:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1817:	8b 40 04             	mov    0x4(%eax),%eax
    181a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1821:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1824:	01 d0                	add    %edx,%eax
    1826:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1829:	75 20                	jne    184b <free+0xcf>
    p->s.size += bp->s.size;
    182b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    182e:	8b 50 04             	mov    0x4(%eax),%edx
    1831:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1834:	8b 40 04             	mov    0x4(%eax),%eax
    1837:	01 c2                	add    %eax,%edx
    1839:	8b 45 fc             	mov    -0x4(%ebp),%eax
    183c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    183f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1842:	8b 10                	mov    (%eax),%edx
    1844:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1847:	89 10                	mov    %edx,(%eax)
    1849:	eb 08                	jmp    1853 <free+0xd7>
  } else
    p->s.ptr = bp;
    184b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    184e:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1851:	89 10                	mov    %edx,(%eax)
  freep = p;
    1853:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1856:	a3 68 2c 00 00       	mov    %eax,0x2c68
}
    185b:	c9                   	leave  
    185c:	c3                   	ret    

0000185d <morecore>:

static Header*
morecore(uint nu)
{
    185d:	55                   	push   %ebp
    185e:	89 e5                	mov    %esp,%ebp
    1860:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1863:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    186a:	77 07                	ja     1873 <morecore+0x16>
    nu = 4096;
    186c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1873:	8b 45 08             	mov    0x8(%ebp),%eax
    1876:	c1 e0 03             	shl    $0x3,%eax
    1879:	89 04 24             	mov    %eax,(%esp)
    187c:	e8 48 fc ff ff       	call   14c9 <sbrk>
    1881:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1884:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1888:	75 07                	jne    1891 <morecore+0x34>
    return 0;
    188a:	b8 00 00 00 00       	mov    $0x0,%eax
    188f:	eb 22                	jmp    18b3 <morecore+0x56>
  hp = (Header*)p;
    1891:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1894:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1897:	8b 45 f0             	mov    -0x10(%ebp),%eax
    189a:	8b 55 08             	mov    0x8(%ebp),%edx
    189d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    18a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18a3:	83 c0 08             	add    $0x8,%eax
    18a6:	89 04 24             	mov    %eax,(%esp)
    18a9:	e8 ce fe ff ff       	call   177c <free>
  return freep;
    18ae:	a1 68 2c 00 00       	mov    0x2c68,%eax
}
    18b3:	c9                   	leave  
    18b4:	c3                   	ret    

000018b5 <malloc>:

void*
malloc(uint nbytes)
{
    18b5:	55                   	push   %ebp
    18b6:	89 e5                	mov    %esp,%ebp
    18b8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18bb:	8b 45 08             	mov    0x8(%ebp),%eax
    18be:	83 c0 07             	add    $0x7,%eax
    18c1:	c1 e8 03             	shr    $0x3,%eax
    18c4:	83 c0 01             	add    $0x1,%eax
    18c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    18ca:	a1 68 2c 00 00       	mov    0x2c68,%eax
    18cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    18d6:	75 23                	jne    18fb <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    18d8:	c7 45 f0 60 2c 00 00 	movl   $0x2c60,-0x10(%ebp)
    18df:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18e2:	a3 68 2c 00 00       	mov    %eax,0x2c68
    18e7:	a1 68 2c 00 00       	mov    0x2c68,%eax
    18ec:	a3 60 2c 00 00       	mov    %eax,0x2c60
    base.s.size = 0;
    18f1:	c7 05 64 2c 00 00 00 	movl   $0x0,0x2c64
    18f8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18fe:	8b 00                	mov    (%eax),%eax
    1900:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1903:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1906:	8b 40 04             	mov    0x4(%eax),%eax
    1909:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    190c:	72 4d                	jb     195b <malloc+0xa6>
      if(p->s.size == nunits)
    190e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1911:	8b 40 04             	mov    0x4(%eax),%eax
    1914:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1917:	75 0c                	jne    1925 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1919:	8b 45 f4             	mov    -0xc(%ebp),%eax
    191c:	8b 10                	mov    (%eax),%edx
    191e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1921:	89 10                	mov    %edx,(%eax)
    1923:	eb 26                	jmp    194b <malloc+0x96>
      else {
        p->s.size -= nunits;
    1925:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1928:	8b 40 04             	mov    0x4(%eax),%eax
    192b:	2b 45 ec             	sub    -0x14(%ebp),%eax
    192e:	89 c2                	mov    %eax,%edx
    1930:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1933:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1936:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1939:	8b 40 04             	mov    0x4(%eax),%eax
    193c:	c1 e0 03             	shl    $0x3,%eax
    193f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1942:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1945:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1948:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    194b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    194e:	a3 68 2c 00 00       	mov    %eax,0x2c68
      return (void*)(p + 1);
    1953:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1956:	83 c0 08             	add    $0x8,%eax
    1959:	eb 38                	jmp    1993 <malloc+0xde>
    }
    if(p == freep)
    195b:	a1 68 2c 00 00       	mov    0x2c68,%eax
    1960:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1963:	75 1b                	jne    1980 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1965:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1968:	89 04 24             	mov    %eax,(%esp)
    196b:	e8 ed fe ff ff       	call   185d <morecore>
    1970:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1973:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1977:	75 07                	jne    1980 <malloc+0xcb>
        return 0;
    1979:	b8 00 00 00 00       	mov    $0x0,%eax
    197e:	eb 13                	jmp    1993 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1980:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1983:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1986:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1989:	8b 00                	mov    (%eax),%eax
    198b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    198e:	e9 70 ff ff ff       	jmp    1903 <malloc+0x4e>
}
    1993:	c9                   	leave  
    1994:	c3                   	ret    
