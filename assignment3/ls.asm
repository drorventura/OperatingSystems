
_ls:     file format elf32-i386


Disassembly of section .text:

00001000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	53                   	push   %ebx
    1004:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    1007:	8b 45 08             	mov    0x8(%ebp),%eax
    100a:	89 04 24             	mov    %eax,(%esp)
    100d:	e8 dd 03 00 00       	call   13ef <strlen>
    1012:	8b 55 08             	mov    0x8(%ebp),%edx
    1015:	01 d0                	add    %edx,%eax
    1017:	89 45 f4             	mov    %eax,-0xc(%ebp)
    101a:	eb 04                	jmp    1020 <fmtname+0x20>
    101c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1020:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1023:	3b 45 08             	cmp    0x8(%ebp),%eax
    1026:	72 0a                	jb     1032 <fmtname+0x32>
    1028:	8b 45 f4             	mov    -0xc(%ebp),%eax
    102b:	0f b6 00             	movzbl (%eax),%eax
    102e:	3c 2f                	cmp    $0x2f,%al
    1030:	75 ea                	jne    101c <fmtname+0x1c>
    ;
  p++;
    1032:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    1036:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1039:	89 04 24             	mov    %eax,(%esp)
    103c:	e8 ae 03 00 00       	call   13ef <strlen>
    1041:	83 f8 0d             	cmp    $0xd,%eax
    1044:	76 05                	jbe    104b <fmtname+0x4b>
    return p;
    1046:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1049:	eb 5f                	jmp    10aa <fmtname+0xaa>
  memmove(buf, p, strlen(p));
    104b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    104e:	89 04 24             	mov    %eax,(%esp)
    1051:	e8 99 03 00 00       	call   13ef <strlen>
    1056:	89 44 24 08          	mov    %eax,0x8(%esp)
    105a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    105d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1061:	c7 04 24 14 2e 00 00 	movl   $0x2e14,(%esp)
    1068:	e8 11 05 00 00       	call   157e <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
    106d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1070:	89 04 24             	mov    %eax,(%esp)
    1073:	e8 77 03 00 00       	call   13ef <strlen>
    1078:	ba 0e 00 00 00       	mov    $0xe,%edx
    107d:	89 d3                	mov    %edx,%ebx
    107f:	29 c3                	sub    %eax,%ebx
    1081:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1084:	89 04 24             	mov    %eax,(%esp)
    1087:	e8 63 03 00 00       	call   13ef <strlen>
    108c:	05 14 2e 00 00       	add    $0x2e14,%eax
    1091:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    1095:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
    109c:	00 
    109d:	89 04 24             	mov    %eax,(%esp)
    10a0:	e8 71 03 00 00       	call   1416 <memset>
  return buf;
    10a5:	b8 14 2e 00 00       	mov    $0x2e14,%eax
}
    10aa:	83 c4 24             	add    $0x24,%esp
    10ad:	5b                   	pop    %ebx
    10ae:	5d                   	pop    %ebp
    10af:	c3                   	ret    

000010b0 <ls>:

void
ls(char *path)
{
    10b0:	55                   	push   %ebp
    10b1:	89 e5                	mov    %esp,%ebp
    10b3:	57                   	push   %edi
    10b4:	56                   	push   %esi
    10b5:	53                   	push   %ebx
    10b6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
    10bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10c3:	00 
    10c4:	8b 45 08             	mov    0x8(%ebp),%eax
    10c7:	89 04 24             	mov    %eax,(%esp)
    10ca:	e8 34 05 00 00       	call   1603 <open>
    10cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    10d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    10d6:	79 20                	jns    10f8 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
    10d8:	8b 45 08             	mov    0x8(%ebp),%eax
    10db:	89 44 24 08          	mov    %eax,0x8(%esp)
    10df:	c7 44 24 04 17 1b 00 	movl   $0x1b17,0x4(%esp)
    10e6:	00 
    10e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    10ee:	e8 58 06 00 00       	call   174b <printf>
    return;
    10f3:	e9 01 02 00 00       	jmp    12f9 <ls+0x249>
  }
  
  if(fstat(fd, &st) < 0){
    10f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
    10fe:	89 44 24 04          	mov    %eax,0x4(%esp)
    1102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1105:	89 04 24             	mov    %eax,(%esp)
    1108:	e8 0e 05 00 00       	call   161b <fstat>
    110d:	85 c0                	test   %eax,%eax
    110f:	79 2b                	jns    113c <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
    1111:	8b 45 08             	mov    0x8(%ebp),%eax
    1114:	89 44 24 08          	mov    %eax,0x8(%esp)
    1118:	c7 44 24 04 2b 1b 00 	movl   $0x1b2b,0x4(%esp)
    111f:	00 
    1120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1127:	e8 1f 06 00 00       	call   174b <printf>
    close(fd);
    112c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    112f:	89 04 24             	mov    %eax,(%esp)
    1132:	e8 b4 04 00 00       	call   15eb <close>
    return;
    1137:	e9 bd 01 00 00       	jmp    12f9 <ls+0x249>
  }
  
  switch(st.type){
    113c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
    1143:	98                   	cwtl   
    1144:	83 f8 01             	cmp    $0x1,%eax
    1147:	74 53                	je     119c <ls+0xec>
    1149:	83 f8 02             	cmp    $0x2,%eax
    114c:	0f 85 9c 01 00 00    	jne    12ee <ls+0x23e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    1152:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
    1158:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
    115e:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
    1165:	0f bf d8             	movswl %ax,%ebx
    1168:	8b 45 08             	mov    0x8(%ebp),%eax
    116b:	89 04 24             	mov    %eax,(%esp)
    116e:	e8 8d fe ff ff       	call   1000 <fmtname>
    1173:	89 7c 24 14          	mov    %edi,0x14(%esp)
    1177:	89 74 24 10          	mov    %esi,0x10(%esp)
    117b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    117f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1183:	c7 44 24 04 3f 1b 00 	movl   $0x1b3f,0x4(%esp)
    118a:	00 
    118b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1192:	e8 b4 05 00 00       	call   174b <printf>
    break;
    1197:	e9 52 01 00 00       	jmp    12ee <ls+0x23e>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
    119c:	8b 45 08             	mov    0x8(%ebp),%eax
    119f:	89 04 24             	mov    %eax,(%esp)
    11a2:	e8 48 02 00 00       	call   13ef <strlen>
    11a7:	83 c0 10             	add    $0x10,%eax
    11aa:	3d 00 02 00 00       	cmp    $0x200,%eax
    11af:	76 19                	jbe    11ca <ls+0x11a>
      printf(1, "ls: path too long\n");
    11b1:	c7 44 24 04 4c 1b 00 	movl   $0x1b4c,0x4(%esp)
    11b8:	00 
    11b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11c0:	e8 86 05 00 00       	call   174b <printf>
      break;
    11c5:	e9 24 01 00 00       	jmp    12ee <ls+0x23e>
    }
    strcpy(buf, path);
    11ca:	8b 45 08             	mov    0x8(%ebp),%eax
    11cd:	89 44 24 04          	mov    %eax,0x4(%esp)
    11d1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    11d7:	89 04 24             	mov    %eax,(%esp)
    11da:	e8 a1 01 00 00       	call   1380 <strcpy>
    p = buf+strlen(buf);
    11df:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    11e5:	89 04 24             	mov    %eax,(%esp)
    11e8:	e8 02 02 00 00       	call   13ef <strlen>
    11ed:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
    11f3:	01 d0                	add    %edx,%eax
    11f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
    11f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11fb:	8d 50 01             	lea    0x1(%eax),%edx
    11fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
    1201:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    1204:	e9 be 00 00 00       	jmp    12c7 <ls+0x217>
      if(de.inum == 0)
    1209:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
    1210:	66 85 c0             	test   %ax,%ax
    1213:	75 05                	jne    121a <ls+0x16a>
        continue;
    1215:	e9 ad 00 00 00       	jmp    12c7 <ls+0x217>
      memmove(p, de.name, DIRSIZ);
    121a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
    1221:	00 
    1222:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
    1228:	83 c0 02             	add    $0x2,%eax
    122b:	89 44 24 04          	mov    %eax,0x4(%esp)
    122f:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1232:	89 04 24             	mov    %eax,(%esp)
    1235:	e8 44 03 00 00       	call   157e <memmove>
      p[DIRSIZ] = 0;
    123a:	8b 45 e0             	mov    -0x20(%ebp),%eax
    123d:	83 c0 0e             	add    $0xe,%eax
    1240:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
    1243:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
    1249:	89 44 24 04          	mov    %eax,0x4(%esp)
    124d:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    1253:	89 04 24             	mov    %eax,(%esp)
    1256:	e8 88 02 00 00       	call   14e3 <stat>
    125b:	85 c0                	test   %eax,%eax
    125d:	79 20                	jns    127f <ls+0x1cf>
        printf(1, "ls: cannot stat %s\n", buf);
    125f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    1265:	89 44 24 08          	mov    %eax,0x8(%esp)
    1269:	c7 44 24 04 2b 1b 00 	movl   $0x1b2b,0x4(%esp)
    1270:	00 
    1271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1278:	e8 ce 04 00 00       	call   174b <printf>
        continue;
    127d:	eb 48                	jmp    12c7 <ls+0x217>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    127f:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
    1285:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
    128b:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
    1292:	0f bf d8             	movswl %ax,%ebx
    1295:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    129b:	89 04 24             	mov    %eax,(%esp)
    129e:	e8 5d fd ff ff       	call   1000 <fmtname>
    12a3:	89 7c 24 14          	mov    %edi,0x14(%esp)
    12a7:	89 74 24 10          	mov    %esi,0x10(%esp)
    12ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    12af:	89 44 24 08          	mov    %eax,0x8(%esp)
    12b3:	c7 44 24 04 3f 1b 00 	movl   $0x1b3f,0x4(%esp)
    12ba:	00 
    12bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12c2:	e8 84 04 00 00       	call   174b <printf>
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    12c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    12ce:	00 
    12cf:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
    12d5:	89 44 24 04          	mov    %eax,0x4(%esp)
    12d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12dc:	89 04 24             	mov    %eax,(%esp)
    12df:	e8 f7 02 00 00       	call   15db <read>
    12e4:	83 f8 10             	cmp    $0x10,%eax
    12e7:	0f 84 1c ff ff ff    	je     1209 <ls+0x159>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
    12ed:	90                   	nop
  }
  close(fd);
    12ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12f1:	89 04 24             	mov    %eax,(%esp)
    12f4:	e8 f2 02 00 00       	call   15eb <close>
}
    12f9:	81 c4 5c 02 00 00    	add    $0x25c,%esp
    12ff:	5b                   	pop    %ebx
    1300:	5e                   	pop    %esi
    1301:	5f                   	pop    %edi
    1302:	5d                   	pop    %ebp
    1303:	c3                   	ret    

00001304 <main>:

int
main(int argc, char *argv[])
{
    1304:	55                   	push   %ebp
    1305:	89 e5                	mov    %esp,%ebp
    1307:	83 e4 f0             	and    $0xfffffff0,%esp
    130a:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
    130d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1311:	7f 11                	jg     1324 <main+0x20>
    ls(".");
    1313:	c7 04 24 5f 1b 00 00 	movl   $0x1b5f,(%esp)
    131a:	e8 91 fd ff ff       	call   10b0 <ls>
    exit();
    131f:	e8 9f 02 00 00       	call   15c3 <exit>
  }
  for(i=1; i<argc; i++)
    1324:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    132b:	00 
    132c:	eb 1f                	jmp    134d <main+0x49>
    ls(argv[i]);
    132e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1339:	8b 45 0c             	mov    0xc(%ebp),%eax
    133c:	01 d0                	add    %edx,%eax
    133e:	8b 00                	mov    (%eax),%eax
    1340:	89 04 24             	mov    %eax,(%esp)
    1343:	e8 68 fd ff ff       	call   10b0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    1348:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    134d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1351:	3b 45 08             	cmp    0x8(%ebp),%eax
    1354:	7c d8                	jl     132e <main+0x2a>
    ls(argv[i]);
  exit();
    1356:	e8 68 02 00 00       	call   15c3 <exit>

0000135b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    135b:	55                   	push   %ebp
    135c:	89 e5                	mov    %esp,%ebp
    135e:	57                   	push   %edi
    135f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1360:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1363:	8b 55 10             	mov    0x10(%ebp),%edx
    1366:	8b 45 0c             	mov    0xc(%ebp),%eax
    1369:	89 cb                	mov    %ecx,%ebx
    136b:	89 df                	mov    %ebx,%edi
    136d:	89 d1                	mov    %edx,%ecx
    136f:	fc                   	cld    
    1370:	f3 aa                	rep stos %al,%es:(%edi)
    1372:	89 ca                	mov    %ecx,%edx
    1374:	89 fb                	mov    %edi,%ebx
    1376:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1379:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    137c:	5b                   	pop    %ebx
    137d:	5f                   	pop    %edi
    137e:	5d                   	pop    %ebp
    137f:	c3                   	ret    

00001380 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1380:	55                   	push   %ebp
    1381:	89 e5                	mov    %esp,%ebp
    1383:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1386:	8b 45 08             	mov    0x8(%ebp),%eax
    1389:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    138c:	90                   	nop
    138d:	8b 45 08             	mov    0x8(%ebp),%eax
    1390:	8d 50 01             	lea    0x1(%eax),%edx
    1393:	89 55 08             	mov    %edx,0x8(%ebp)
    1396:	8b 55 0c             	mov    0xc(%ebp),%edx
    1399:	8d 4a 01             	lea    0x1(%edx),%ecx
    139c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    139f:	0f b6 12             	movzbl (%edx),%edx
    13a2:	88 10                	mov    %dl,(%eax)
    13a4:	0f b6 00             	movzbl (%eax),%eax
    13a7:	84 c0                	test   %al,%al
    13a9:	75 e2                	jne    138d <strcpy+0xd>
    ;
  return os;
    13ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13ae:	c9                   	leave  
    13af:	c3                   	ret    

000013b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    13b0:	55                   	push   %ebp
    13b1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    13b3:	eb 08                	jmp    13bd <strcmp+0xd>
    p++, q++;
    13b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    13b9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    13bd:	8b 45 08             	mov    0x8(%ebp),%eax
    13c0:	0f b6 00             	movzbl (%eax),%eax
    13c3:	84 c0                	test   %al,%al
    13c5:	74 10                	je     13d7 <strcmp+0x27>
    13c7:	8b 45 08             	mov    0x8(%ebp),%eax
    13ca:	0f b6 10             	movzbl (%eax),%edx
    13cd:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d0:	0f b6 00             	movzbl (%eax),%eax
    13d3:	38 c2                	cmp    %al,%dl
    13d5:	74 de                	je     13b5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    13d7:	8b 45 08             	mov    0x8(%ebp),%eax
    13da:	0f b6 00             	movzbl (%eax),%eax
    13dd:	0f b6 d0             	movzbl %al,%edx
    13e0:	8b 45 0c             	mov    0xc(%ebp),%eax
    13e3:	0f b6 00             	movzbl (%eax),%eax
    13e6:	0f b6 c0             	movzbl %al,%eax
    13e9:	29 c2                	sub    %eax,%edx
    13eb:	89 d0                	mov    %edx,%eax
}
    13ed:	5d                   	pop    %ebp
    13ee:	c3                   	ret    

000013ef <strlen>:

uint
strlen(char *s)
{
    13ef:	55                   	push   %ebp
    13f0:	89 e5                	mov    %esp,%ebp
    13f2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    13f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    13fc:	eb 04                	jmp    1402 <strlen+0x13>
    13fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1402:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1405:	8b 45 08             	mov    0x8(%ebp),%eax
    1408:	01 d0                	add    %edx,%eax
    140a:	0f b6 00             	movzbl (%eax),%eax
    140d:	84 c0                	test   %al,%al
    140f:	75 ed                	jne    13fe <strlen+0xf>
    ;
  return n;
    1411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1414:	c9                   	leave  
    1415:	c3                   	ret    

00001416 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1416:	55                   	push   %ebp
    1417:	89 e5                	mov    %esp,%ebp
    1419:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    141c:	8b 45 10             	mov    0x10(%ebp),%eax
    141f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1423:	8b 45 0c             	mov    0xc(%ebp),%eax
    1426:	89 44 24 04          	mov    %eax,0x4(%esp)
    142a:	8b 45 08             	mov    0x8(%ebp),%eax
    142d:	89 04 24             	mov    %eax,(%esp)
    1430:	e8 26 ff ff ff       	call   135b <stosb>
  return dst;
    1435:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1438:	c9                   	leave  
    1439:	c3                   	ret    

0000143a <strchr>:

char*
strchr(const char *s, char c)
{
    143a:	55                   	push   %ebp
    143b:	89 e5                	mov    %esp,%ebp
    143d:	83 ec 04             	sub    $0x4,%esp
    1440:	8b 45 0c             	mov    0xc(%ebp),%eax
    1443:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1446:	eb 14                	jmp    145c <strchr+0x22>
    if(*s == c)
    1448:	8b 45 08             	mov    0x8(%ebp),%eax
    144b:	0f b6 00             	movzbl (%eax),%eax
    144e:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1451:	75 05                	jne    1458 <strchr+0x1e>
      return (char*)s;
    1453:	8b 45 08             	mov    0x8(%ebp),%eax
    1456:	eb 13                	jmp    146b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1458:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    145c:	8b 45 08             	mov    0x8(%ebp),%eax
    145f:	0f b6 00             	movzbl (%eax),%eax
    1462:	84 c0                	test   %al,%al
    1464:	75 e2                	jne    1448 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1466:	b8 00 00 00 00       	mov    $0x0,%eax
}
    146b:	c9                   	leave  
    146c:	c3                   	ret    

0000146d <gets>:

char*
gets(char *buf, int max)
{
    146d:	55                   	push   %ebp
    146e:	89 e5                	mov    %esp,%ebp
    1470:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1473:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    147a:	eb 4c                	jmp    14c8 <gets+0x5b>
    cc = read(0, &c, 1);
    147c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1483:	00 
    1484:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1487:	89 44 24 04          	mov    %eax,0x4(%esp)
    148b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1492:	e8 44 01 00 00       	call   15db <read>
    1497:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    149a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    149e:	7f 02                	jg     14a2 <gets+0x35>
      break;
    14a0:	eb 31                	jmp    14d3 <gets+0x66>
    buf[i++] = c;
    14a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a5:	8d 50 01             	lea    0x1(%eax),%edx
    14a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14ab:	89 c2                	mov    %eax,%edx
    14ad:	8b 45 08             	mov    0x8(%ebp),%eax
    14b0:	01 c2                	add    %eax,%edx
    14b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14b6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    14b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14bc:	3c 0a                	cmp    $0xa,%al
    14be:	74 13                	je     14d3 <gets+0x66>
    14c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14c4:	3c 0d                	cmp    $0xd,%al
    14c6:	74 0b                	je     14d3 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    14c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14cb:	83 c0 01             	add    $0x1,%eax
    14ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
    14d1:	7c a9                	jl     147c <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    14d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14d6:	8b 45 08             	mov    0x8(%ebp),%eax
    14d9:	01 d0                	add    %edx,%eax
    14db:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    14de:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14e1:	c9                   	leave  
    14e2:	c3                   	ret    

000014e3 <stat>:

int
stat(char *n, struct stat *st)
{
    14e3:	55                   	push   %ebp
    14e4:	89 e5                	mov    %esp,%ebp
    14e6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    14e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14f0:	00 
    14f1:	8b 45 08             	mov    0x8(%ebp),%eax
    14f4:	89 04 24             	mov    %eax,(%esp)
    14f7:	e8 07 01 00 00       	call   1603 <open>
    14fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    14ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1503:	79 07                	jns    150c <stat+0x29>
    return -1;
    1505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    150a:	eb 23                	jmp    152f <stat+0x4c>
  r = fstat(fd, st);
    150c:	8b 45 0c             	mov    0xc(%ebp),%eax
    150f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1513:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1516:	89 04 24             	mov    %eax,(%esp)
    1519:	e8 fd 00 00 00       	call   161b <fstat>
    151e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1521:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1524:	89 04 24             	mov    %eax,(%esp)
    1527:	e8 bf 00 00 00       	call   15eb <close>
  return r;
    152c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    152f:	c9                   	leave  
    1530:	c3                   	ret    

00001531 <atoi>:

int
atoi(const char *s)
{
    1531:	55                   	push   %ebp
    1532:	89 e5                	mov    %esp,%ebp
    1534:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1537:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    153e:	eb 25                	jmp    1565 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1540:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1543:	89 d0                	mov    %edx,%eax
    1545:	c1 e0 02             	shl    $0x2,%eax
    1548:	01 d0                	add    %edx,%eax
    154a:	01 c0                	add    %eax,%eax
    154c:	89 c1                	mov    %eax,%ecx
    154e:	8b 45 08             	mov    0x8(%ebp),%eax
    1551:	8d 50 01             	lea    0x1(%eax),%edx
    1554:	89 55 08             	mov    %edx,0x8(%ebp)
    1557:	0f b6 00             	movzbl (%eax),%eax
    155a:	0f be c0             	movsbl %al,%eax
    155d:	01 c8                	add    %ecx,%eax
    155f:	83 e8 30             	sub    $0x30,%eax
    1562:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1565:	8b 45 08             	mov    0x8(%ebp),%eax
    1568:	0f b6 00             	movzbl (%eax),%eax
    156b:	3c 2f                	cmp    $0x2f,%al
    156d:	7e 0a                	jle    1579 <atoi+0x48>
    156f:	8b 45 08             	mov    0x8(%ebp),%eax
    1572:	0f b6 00             	movzbl (%eax),%eax
    1575:	3c 39                	cmp    $0x39,%al
    1577:	7e c7                	jle    1540 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1579:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    157c:	c9                   	leave  
    157d:	c3                   	ret    

0000157e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    157e:	55                   	push   %ebp
    157f:	89 e5                	mov    %esp,%ebp
    1581:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1584:	8b 45 08             	mov    0x8(%ebp),%eax
    1587:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    158a:	8b 45 0c             	mov    0xc(%ebp),%eax
    158d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1590:	eb 17                	jmp    15a9 <memmove+0x2b>
    *dst++ = *src++;
    1592:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1595:	8d 50 01             	lea    0x1(%eax),%edx
    1598:	89 55 fc             	mov    %edx,-0x4(%ebp)
    159b:	8b 55 f8             	mov    -0x8(%ebp),%edx
    159e:	8d 4a 01             	lea    0x1(%edx),%ecx
    15a1:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    15a4:	0f b6 12             	movzbl (%edx),%edx
    15a7:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    15a9:	8b 45 10             	mov    0x10(%ebp),%eax
    15ac:	8d 50 ff             	lea    -0x1(%eax),%edx
    15af:	89 55 10             	mov    %edx,0x10(%ebp)
    15b2:	85 c0                	test   %eax,%eax
    15b4:	7f dc                	jg     1592 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    15b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
    15b9:	c9                   	leave  
    15ba:	c3                   	ret    

000015bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    15bb:	b8 01 00 00 00       	mov    $0x1,%eax
    15c0:	cd 40                	int    $0x40
    15c2:	c3                   	ret    

000015c3 <exit>:
SYSCALL(exit)
    15c3:	b8 02 00 00 00       	mov    $0x2,%eax
    15c8:	cd 40                	int    $0x40
    15ca:	c3                   	ret    

000015cb <wait>:
SYSCALL(wait)
    15cb:	b8 03 00 00 00       	mov    $0x3,%eax
    15d0:	cd 40                	int    $0x40
    15d2:	c3                   	ret    

000015d3 <pipe>:
SYSCALL(pipe)
    15d3:	b8 04 00 00 00       	mov    $0x4,%eax
    15d8:	cd 40                	int    $0x40
    15da:	c3                   	ret    

000015db <read>:
SYSCALL(read)
    15db:	b8 05 00 00 00       	mov    $0x5,%eax
    15e0:	cd 40                	int    $0x40
    15e2:	c3                   	ret    

000015e3 <write>:
SYSCALL(write)
    15e3:	b8 10 00 00 00       	mov    $0x10,%eax
    15e8:	cd 40                	int    $0x40
    15ea:	c3                   	ret    

000015eb <close>:
SYSCALL(close)
    15eb:	b8 15 00 00 00       	mov    $0x15,%eax
    15f0:	cd 40                	int    $0x40
    15f2:	c3                   	ret    

000015f3 <kill>:
SYSCALL(kill)
    15f3:	b8 06 00 00 00       	mov    $0x6,%eax
    15f8:	cd 40                	int    $0x40
    15fa:	c3                   	ret    

000015fb <exec>:
SYSCALL(exec)
    15fb:	b8 07 00 00 00       	mov    $0x7,%eax
    1600:	cd 40                	int    $0x40
    1602:	c3                   	ret    

00001603 <open>:
SYSCALL(open)
    1603:	b8 0f 00 00 00       	mov    $0xf,%eax
    1608:	cd 40                	int    $0x40
    160a:	c3                   	ret    

0000160b <mknod>:
SYSCALL(mknod)
    160b:	b8 11 00 00 00       	mov    $0x11,%eax
    1610:	cd 40                	int    $0x40
    1612:	c3                   	ret    

00001613 <unlink>:
SYSCALL(unlink)
    1613:	b8 12 00 00 00       	mov    $0x12,%eax
    1618:	cd 40                	int    $0x40
    161a:	c3                   	ret    

0000161b <fstat>:
SYSCALL(fstat)
    161b:	b8 08 00 00 00       	mov    $0x8,%eax
    1620:	cd 40                	int    $0x40
    1622:	c3                   	ret    

00001623 <link>:
SYSCALL(link)
    1623:	b8 13 00 00 00       	mov    $0x13,%eax
    1628:	cd 40                	int    $0x40
    162a:	c3                   	ret    

0000162b <mkdir>:
SYSCALL(mkdir)
    162b:	b8 14 00 00 00       	mov    $0x14,%eax
    1630:	cd 40                	int    $0x40
    1632:	c3                   	ret    

00001633 <chdir>:
SYSCALL(chdir)
    1633:	b8 09 00 00 00       	mov    $0x9,%eax
    1638:	cd 40                	int    $0x40
    163a:	c3                   	ret    

0000163b <dup>:
SYSCALL(dup)
    163b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1640:	cd 40                	int    $0x40
    1642:	c3                   	ret    

00001643 <getpid>:
SYSCALL(getpid)
    1643:	b8 0b 00 00 00       	mov    $0xb,%eax
    1648:	cd 40                	int    $0x40
    164a:	c3                   	ret    

0000164b <sbrk>:
SYSCALL(sbrk)
    164b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1650:	cd 40                	int    $0x40
    1652:	c3                   	ret    

00001653 <sleep>:
SYSCALL(sleep)
    1653:	b8 0d 00 00 00       	mov    $0xd,%eax
    1658:	cd 40                	int    $0x40
    165a:	c3                   	ret    

0000165b <uptime>:
SYSCALL(uptime)
    165b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1660:	cd 40                	int    $0x40
    1662:	c3                   	ret    

00001663 <cowfork>:
SYSCALL(cowfork) //3.4
    1663:	b8 16 00 00 00       	mov    $0x16,%eax
    1668:	cd 40                	int    $0x40
    166a:	c3                   	ret    

0000166b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    166b:	55                   	push   %ebp
    166c:	89 e5                	mov    %esp,%ebp
    166e:	83 ec 18             	sub    $0x18,%esp
    1671:	8b 45 0c             	mov    0xc(%ebp),%eax
    1674:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1677:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    167e:	00 
    167f:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1682:	89 44 24 04          	mov    %eax,0x4(%esp)
    1686:	8b 45 08             	mov    0x8(%ebp),%eax
    1689:	89 04 24             	mov    %eax,(%esp)
    168c:	e8 52 ff ff ff       	call   15e3 <write>
}
    1691:	c9                   	leave  
    1692:	c3                   	ret    

00001693 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1693:	55                   	push   %ebp
    1694:	89 e5                	mov    %esp,%ebp
    1696:	56                   	push   %esi
    1697:	53                   	push   %ebx
    1698:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    169b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    16a2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    16a6:	74 17                	je     16bf <printint+0x2c>
    16a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    16ac:	79 11                	jns    16bf <printint+0x2c>
    neg = 1;
    16ae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    16b5:	8b 45 0c             	mov    0xc(%ebp),%eax
    16b8:	f7 d8                	neg    %eax
    16ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16bd:	eb 06                	jmp    16c5 <printint+0x32>
  } else {
    x = xx;
    16bf:	8b 45 0c             	mov    0xc(%ebp),%eax
    16c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    16c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    16cc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16cf:	8d 41 01             	lea    0x1(%ecx),%eax
    16d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    16d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
    16d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16db:	ba 00 00 00 00       	mov    $0x0,%edx
    16e0:	f7 f3                	div    %ebx
    16e2:	89 d0                	mov    %edx,%eax
    16e4:	0f b6 80 00 2e 00 00 	movzbl 0x2e00(%eax),%eax
    16eb:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    16ef:	8b 75 10             	mov    0x10(%ebp),%esi
    16f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16f5:	ba 00 00 00 00       	mov    $0x0,%edx
    16fa:	f7 f6                	div    %esi
    16fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1703:	75 c7                	jne    16cc <printint+0x39>
  if(neg)
    1705:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1709:	74 10                	je     171b <printint+0x88>
    buf[i++] = '-';
    170b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    170e:	8d 50 01             	lea    0x1(%eax),%edx
    1711:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1714:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1719:	eb 1f                	jmp    173a <printint+0xa7>
    171b:	eb 1d                	jmp    173a <printint+0xa7>
    putc(fd, buf[i]);
    171d:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1720:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1723:	01 d0                	add    %edx,%eax
    1725:	0f b6 00             	movzbl (%eax),%eax
    1728:	0f be c0             	movsbl %al,%eax
    172b:	89 44 24 04          	mov    %eax,0x4(%esp)
    172f:	8b 45 08             	mov    0x8(%ebp),%eax
    1732:	89 04 24             	mov    %eax,(%esp)
    1735:	e8 31 ff ff ff       	call   166b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    173a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    173e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1742:	79 d9                	jns    171d <printint+0x8a>
    putc(fd, buf[i]);
}
    1744:	83 c4 30             	add    $0x30,%esp
    1747:	5b                   	pop    %ebx
    1748:	5e                   	pop    %esi
    1749:	5d                   	pop    %ebp
    174a:	c3                   	ret    

0000174b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    174b:	55                   	push   %ebp
    174c:	89 e5                	mov    %esp,%ebp
    174e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1751:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1758:	8d 45 0c             	lea    0xc(%ebp),%eax
    175b:	83 c0 04             	add    $0x4,%eax
    175e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1761:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1768:	e9 7c 01 00 00       	jmp    18e9 <printf+0x19e>
    c = fmt[i] & 0xff;
    176d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1770:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1773:	01 d0                	add    %edx,%eax
    1775:	0f b6 00             	movzbl (%eax),%eax
    1778:	0f be c0             	movsbl %al,%eax
    177b:	25 ff 00 00 00       	and    $0xff,%eax
    1780:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1783:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1787:	75 2c                	jne    17b5 <printf+0x6a>
      if(c == '%'){
    1789:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    178d:	75 0c                	jne    179b <printf+0x50>
        state = '%';
    178f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1796:	e9 4a 01 00 00       	jmp    18e5 <printf+0x19a>
      } else {
        putc(fd, c);
    179b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    179e:	0f be c0             	movsbl %al,%eax
    17a1:	89 44 24 04          	mov    %eax,0x4(%esp)
    17a5:	8b 45 08             	mov    0x8(%ebp),%eax
    17a8:	89 04 24             	mov    %eax,(%esp)
    17ab:	e8 bb fe ff ff       	call   166b <putc>
    17b0:	e9 30 01 00 00       	jmp    18e5 <printf+0x19a>
      }
    } else if(state == '%'){
    17b5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    17b9:	0f 85 26 01 00 00    	jne    18e5 <printf+0x19a>
      if(c == 'd'){
    17bf:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    17c3:	75 2d                	jne    17f2 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    17c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17c8:	8b 00                	mov    (%eax),%eax
    17ca:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    17d1:	00 
    17d2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    17d9:	00 
    17da:	89 44 24 04          	mov    %eax,0x4(%esp)
    17de:	8b 45 08             	mov    0x8(%ebp),%eax
    17e1:	89 04 24             	mov    %eax,(%esp)
    17e4:	e8 aa fe ff ff       	call   1693 <printint>
        ap++;
    17e9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17ed:	e9 ec 00 00 00       	jmp    18de <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    17f2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    17f6:	74 06                	je     17fe <printf+0xb3>
    17f8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    17fc:	75 2d                	jne    182b <printf+0xe0>
        printint(fd, *ap, 16, 0);
    17fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1801:	8b 00                	mov    (%eax),%eax
    1803:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    180a:	00 
    180b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1812:	00 
    1813:	89 44 24 04          	mov    %eax,0x4(%esp)
    1817:	8b 45 08             	mov    0x8(%ebp),%eax
    181a:	89 04 24             	mov    %eax,(%esp)
    181d:	e8 71 fe ff ff       	call   1693 <printint>
        ap++;
    1822:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1826:	e9 b3 00 00 00       	jmp    18de <printf+0x193>
      } else if(c == 's'){
    182b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    182f:	75 45                	jne    1876 <printf+0x12b>
        s = (char*)*ap;
    1831:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1834:	8b 00                	mov    (%eax),%eax
    1836:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1839:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    183d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1841:	75 09                	jne    184c <printf+0x101>
          s = "(null)";
    1843:	c7 45 f4 61 1b 00 00 	movl   $0x1b61,-0xc(%ebp)
        while(*s != 0){
    184a:	eb 1e                	jmp    186a <printf+0x11f>
    184c:	eb 1c                	jmp    186a <printf+0x11f>
          putc(fd, *s);
    184e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1851:	0f b6 00             	movzbl (%eax),%eax
    1854:	0f be c0             	movsbl %al,%eax
    1857:	89 44 24 04          	mov    %eax,0x4(%esp)
    185b:	8b 45 08             	mov    0x8(%ebp),%eax
    185e:	89 04 24             	mov    %eax,(%esp)
    1861:	e8 05 fe ff ff       	call   166b <putc>
          s++;
    1866:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    186a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    186d:	0f b6 00             	movzbl (%eax),%eax
    1870:	84 c0                	test   %al,%al
    1872:	75 da                	jne    184e <printf+0x103>
    1874:	eb 68                	jmp    18de <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1876:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    187a:	75 1d                	jne    1899 <printf+0x14e>
        putc(fd, *ap);
    187c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    187f:	8b 00                	mov    (%eax),%eax
    1881:	0f be c0             	movsbl %al,%eax
    1884:	89 44 24 04          	mov    %eax,0x4(%esp)
    1888:	8b 45 08             	mov    0x8(%ebp),%eax
    188b:	89 04 24             	mov    %eax,(%esp)
    188e:	e8 d8 fd ff ff       	call   166b <putc>
        ap++;
    1893:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1897:	eb 45                	jmp    18de <printf+0x193>
      } else if(c == '%'){
    1899:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    189d:	75 17                	jne    18b6 <printf+0x16b>
        putc(fd, c);
    189f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18a2:	0f be c0             	movsbl %al,%eax
    18a5:	89 44 24 04          	mov    %eax,0x4(%esp)
    18a9:	8b 45 08             	mov    0x8(%ebp),%eax
    18ac:	89 04 24             	mov    %eax,(%esp)
    18af:	e8 b7 fd ff ff       	call   166b <putc>
    18b4:	eb 28                	jmp    18de <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    18b6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    18bd:	00 
    18be:	8b 45 08             	mov    0x8(%ebp),%eax
    18c1:	89 04 24             	mov    %eax,(%esp)
    18c4:	e8 a2 fd ff ff       	call   166b <putc>
        putc(fd, c);
    18c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18cc:	0f be c0             	movsbl %al,%eax
    18cf:	89 44 24 04          	mov    %eax,0x4(%esp)
    18d3:	8b 45 08             	mov    0x8(%ebp),%eax
    18d6:	89 04 24             	mov    %eax,(%esp)
    18d9:	e8 8d fd ff ff       	call   166b <putc>
      }
      state = 0;
    18de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    18e5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    18e9:	8b 55 0c             	mov    0xc(%ebp),%edx
    18ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18ef:	01 d0                	add    %edx,%eax
    18f1:	0f b6 00             	movzbl (%eax),%eax
    18f4:	84 c0                	test   %al,%al
    18f6:	0f 85 71 fe ff ff    	jne    176d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    18fc:	c9                   	leave  
    18fd:	c3                   	ret    

000018fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    18fe:	55                   	push   %ebp
    18ff:	89 e5                	mov    %esp,%ebp
    1901:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1904:	8b 45 08             	mov    0x8(%ebp),%eax
    1907:	83 e8 08             	sub    $0x8,%eax
    190a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    190d:	a1 2c 2e 00 00       	mov    0x2e2c,%eax
    1912:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1915:	eb 24                	jmp    193b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1917:	8b 45 fc             	mov    -0x4(%ebp),%eax
    191a:	8b 00                	mov    (%eax),%eax
    191c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    191f:	77 12                	ja     1933 <free+0x35>
    1921:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1924:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1927:	77 24                	ja     194d <free+0x4f>
    1929:	8b 45 fc             	mov    -0x4(%ebp),%eax
    192c:	8b 00                	mov    (%eax),%eax
    192e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1931:	77 1a                	ja     194d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1933:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1936:	8b 00                	mov    (%eax),%eax
    1938:	89 45 fc             	mov    %eax,-0x4(%ebp)
    193b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    193e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1941:	76 d4                	jbe    1917 <free+0x19>
    1943:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1946:	8b 00                	mov    (%eax),%eax
    1948:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    194b:	76 ca                	jbe    1917 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1950:	8b 40 04             	mov    0x4(%eax),%eax
    1953:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    195a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    195d:	01 c2                	add    %eax,%edx
    195f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1962:	8b 00                	mov    (%eax),%eax
    1964:	39 c2                	cmp    %eax,%edx
    1966:	75 24                	jne    198c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1968:	8b 45 f8             	mov    -0x8(%ebp),%eax
    196b:	8b 50 04             	mov    0x4(%eax),%edx
    196e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1971:	8b 00                	mov    (%eax),%eax
    1973:	8b 40 04             	mov    0x4(%eax),%eax
    1976:	01 c2                	add    %eax,%edx
    1978:	8b 45 f8             	mov    -0x8(%ebp),%eax
    197b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    197e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1981:	8b 00                	mov    (%eax),%eax
    1983:	8b 10                	mov    (%eax),%edx
    1985:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1988:	89 10                	mov    %edx,(%eax)
    198a:	eb 0a                	jmp    1996 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    198c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    198f:	8b 10                	mov    (%eax),%edx
    1991:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1994:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1996:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1999:	8b 40 04             	mov    0x4(%eax),%eax
    199c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    19a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19a6:	01 d0                	add    %edx,%eax
    19a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19ab:	75 20                	jne    19cd <free+0xcf>
    p->s.size += bp->s.size;
    19ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19b0:	8b 50 04             	mov    0x4(%eax),%edx
    19b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19b6:	8b 40 04             	mov    0x4(%eax),%eax
    19b9:	01 c2                	add    %eax,%edx
    19bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19be:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    19c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19c4:	8b 10                	mov    (%eax),%edx
    19c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19c9:	89 10                	mov    %edx,(%eax)
    19cb:	eb 08                	jmp    19d5 <free+0xd7>
  } else
    p->s.ptr = bp;
    19cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
    19d3:	89 10                	mov    %edx,(%eax)
  freep = p;
    19d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19d8:	a3 2c 2e 00 00       	mov    %eax,0x2e2c
}
    19dd:	c9                   	leave  
    19de:	c3                   	ret    

000019df <morecore>:

static Header*
morecore(uint nu)
{
    19df:	55                   	push   %ebp
    19e0:	89 e5                	mov    %esp,%ebp
    19e2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    19e5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    19ec:	77 07                	ja     19f5 <morecore+0x16>
    nu = 4096;
    19ee:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    19f5:	8b 45 08             	mov    0x8(%ebp),%eax
    19f8:	c1 e0 03             	shl    $0x3,%eax
    19fb:	89 04 24             	mov    %eax,(%esp)
    19fe:	e8 48 fc ff ff       	call   164b <sbrk>
    1a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1a06:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1a0a:	75 07                	jne    1a13 <morecore+0x34>
    return 0;
    1a0c:	b8 00 00 00 00       	mov    $0x0,%eax
    1a11:	eb 22                	jmp    1a35 <morecore+0x56>
  hp = (Header*)p;
    1a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a1c:	8b 55 08             	mov    0x8(%ebp),%edx
    1a1f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a25:	83 c0 08             	add    $0x8,%eax
    1a28:	89 04 24             	mov    %eax,(%esp)
    1a2b:	e8 ce fe ff ff       	call   18fe <free>
  return freep;
    1a30:	a1 2c 2e 00 00       	mov    0x2e2c,%eax
}
    1a35:	c9                   	leave  
    1a36:	c3                   	ret    

00001a37 <malloc>:

void*
malloc(uint nbytes)
{
    1a37:	55                   	push   %ebp
    1a38:	89 e5                	mov    %esp,%ebp
    1a3a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1a3d:	8b 45 08             	mov    0x8(%ebp),%eax
    1a40:	83 c0 07             	add    $0x7,%eax
    1a43:	c1 e8 03             	shr    $0x3,%eax
    1a46:	83 c0 01             	add    $0x1,%eax
    1a49:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a4c:	a1 2c 2e 00 00       	mov    0x2e2c,%eax
    1a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a58:	75 23                	jne    1a7d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1a5a:	c7 45 f0 24 2e 00 00 	movl   $0x2e24,-0x10(%ebp)
    1a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a64:	a3 2c 2e 00 00       	mov    %eax,0x2e2c
    1a69:	a1 2c 2e 00 00       	mov    0x2e2c,%eax
    1a6e:	a3 24 2e 00 00       	mov    %eax,0x2e24
    base.s.size = 0;
    1a73:	c7 05 28 2e 00 00 00 	movl   $0x0,0x2e28
    1a7a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a80:	8b 00                	mov    (%eax),%eax
    1a82:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a88:	8b 40 04             	mov    0x4(%eax),%eax
    1a8b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a8e:	72 4d                	jb     1add <malloc+0xa6>
      if(p->s.size == nunits)
    1a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a93:	8b 40 04             	mov    0x4(%eax),%eax
    1a96:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a99:	75 0c                	jne    1aa7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a9e:	8b 10                	mov    (%eax),%edx
    1aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1aa3:	89 10                	mov    %edx,(%eax)
    1aa5:	eb 26                	jmp    1acd <malloc+0x96>
      else {
        p->s.size -= nunits;
    1aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aaa:	8b 40 04             	mov    0x4(%eax),%eax
    1aad:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1ab0:	89 c2                	mov    %eax,%edx
    1ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ab5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1abb:	8b 40 04             	mov    0x4(%eax),%eax
    1abe:	c1 e0 03             	shl    $0x3,%eax
    1ac1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac7:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1aca:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ad0:	a3 2c 2e 00 00       	mov    %eax,0x2e2c
      return (void*)(p + 1);
    1ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad8:	83 c0 08             	add    $0x8,%eax
    1adb:	eb 38                	jmp    1b15 <malloc+0xde>
    }
    if(p == freep)
    1add:	a1 2c 2e 00 00       	mov    0x2e2c,%eax
    1ae2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1ae5:	75 1b                	jne    1b02 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1aea:	89 04 24             	mov    %eax,(%esp)
    1aed:	e8 ed fe ff ff       	call   19df <morecore>
    1af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1af5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1af9:	75 07                	jne    1b02 <malloc+0xcb>
        return 0;
    1afb:	b8 00 00 00 00       	mov    $0x0,%eax
    1b00:	eb 13                	jmp    1b15 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b05:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b0b:	8b 00                	mov    (%eax),%eax
    1b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1b10:	e9 70 ff ff ff       	jmp    1a85 <malloc+0x4e>
}
    1b15:	c9                   	leave  
    1b16:	c3                   	ret    
