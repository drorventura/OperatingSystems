
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	8b 45 08             	mov    0x8(%ebp),%eax
   a:	89 04 24             	mov    %eax,(%esp)
   d:	e8 d1 03 00 00       	call   3e3 <strlen>
  12:	8b 55 08             	mov    0x8(%ebp),%edx
  15:	01 d0                	add    %edx,%eax
  17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1a:	eb 03                	jmp    1f <fmtname+0x1f>
  1c:	ff 4d f4             	decl   -0xc(%ebp)
  1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  22:	3b 45 08             	cmp    0x8(%ebp),%eax
  25:	72 09                	jb     30 <fmtname+0x30>
  27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2a:	8a 00                	mov    (%eax),%al
  2c:	3c 2f                	cmp    $0x2f,%al
  2e:	75 ec                	jne    1c <fmtname+0x1c>
    ;
  p++;
  30:	ff 45 f4             	incl   -0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 a5 03 00 00       	call   3e3 <strlen>
  3e:	83 f8 0d             	cmp    $0xd,%eax
  41:	76 05                	jbe    48 <fmtname+0x48>
    return p;
  43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  46:	eb 5f                	jmp    a7 <fmtname+0xa7>
  memmove(buf, p, strlen(p));
  48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4b:	89 04 24             	mov    %eax,(%esp)
  4e:	e8 90 03 00 00       	call   3e3 <strlen>
  53:	89 44 24 08          	mov    %eax,0x8(%esp)
  57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  5e:	c7 04 24 dc 0d 00 00 	movl   $0xddc,(%esp)
  65:	e8 f4 04 00 00       	call   55e <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6d:	89 04 24             	mov    %eax,(%esp)
  70:	e8 6e 03 00 00       	call   3e3 <strlen>
  75:	ba 0e 00 00 00       	mov    $0xe,%edx
  7a:	89 d3                	mov    %edx,%ebx
  7c:	29 c3                	sub    %eax,%ebx
  7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  81:	89 04 24             	mov    %eax,(%esp)
  84:	e8 5a 03 00 00       	call   3e3 <strlen>
  89:	05 dc 0d 00 00       	add    $0xddc,%eax
  8e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  92:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  99:	00 
  9a:	89 04 24             	mov    %eax,(%esp)
  9d:	e8 66 03 00 00       	call   408 <memset>
  return buf;
  a2:	b8 dc 0d 00 00       	mov    $0xddc,%eax
}
  a7:	83 c4 24             	add    $0x24,%esp
  aa:	5b                   	pop    %ebx
  ab:	5d                   	pop    %ebp
  ac:	c3                   	ret    

000000ad <ls>:

void
ls(char *path)
{
  ad:	55                   	push   %ebp
  ae:	89 e5                	mov    %esp,%ebp
  b0:	57                   	push   %edi
  b1:	56                   	push   %esi
  b2:	53                   	push   %ebx
  b3:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c0:	00 
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	89 04 24             	mov    %eax,(%esp)
  c7:	e8 14 05 00 00       	call   5e0 <open>
  cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d3:	79 20                	jns    f5 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  dc:	c7 44 24 04 e7 0a 00 	movl   $0xae7,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  eb:	e8 30 06 00 00       	call   720 <printf>
  f0:	e9 fc 01 00 00       	jmp    2f1 <ls+0x244>
    return;
  }
  
  if(fstat(fd, &st) < 0){
  f5:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 102:	89 04 24             	mov    %eax,(%esp)
 105:	e8 ee 04 00 00       	call   5f8 <fstat>
 10a:	85 c0                	test   %eax,%eax
 10c:	79 2b                	jns    139 <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
 111:	89 44 24 08          	mov    %eax,0x8(%esp)
 115:	c7 44 24 04 fb 0a 00 	movl   $0xafb,0x4(%esp)
 11c:	00 
 11d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 124:	e8 f7 05 00 00       	call   720 <printf>
    close(fd);
 129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12c:	89 04 24             	mov    %eax,(%esp)
 12f:	e8 94 04 00 00       	call   5c8 <close>
 134:	e9 b8 01 00 00       	jmp    2f1 <ls+0x244>
    return;
  }
  
  switch(st.type){
 139:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
 13f:	98                   	cwtl   
 140:	83 f8 01             	cmp    $0x1,%eax
 143:	74 52                	je     197 <ls+0xea>
 145:	83 f8 02             	cmp    $0x2,%eax
 148:	0f 85 98 01 00 00    	jne    2e6 <ls+0x239>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 14e:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 154:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15a:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
 160:	0f bf d8             	movswl %ax,%ebx
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	89 04 24             	mov    %eax,(%esp)
 169:	e8 92 fe ff ff       	call   0 <fmtname>
 16e:	89 7c 24 14          	mov    %edi,0x14(%esp)
 172:	89 74 24 10          	mov    %esi,0x10(%esp)
 176:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 17a:	89 44 24 08          	mov    %eax,0x8(%esp)
 17e:	c7 44 24 04 0f 0b 00 	movl   $0xb0f,0x4(%esp)
 185:	00 
 186:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18d:	e8 8e 05 00 00       	call   720 <printf>
    break;
 192:	e9 4f 01 00 00       	jmp    2e6 <ls+0x239>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	89 04 24             	mov    %eax,(%esp)
 19d:	e8 41 02 00 00       	call   3e3 <strlen>
 1a2:	83 c0 10             	add    $0x10,%eax
 1a5:	3d 00 02 00 00       	cmp    $0x200,%eax
 1aa:	76 19                	jbe    1c5 <ls+0x118>
      printf(1, "ls: path too long\n");
 1ac:	c7 44 24 04 1c 0b 00 	movl   $0xb1c,0x4(%esp)
 1b3:	00 
 1b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1bb:	e8 60 05 00 00       	call   720 <printf>
      break;
 1c0:	e9 21 01 00 00       	jmp    2e6 <ls+0x239>
    }
    strcpy(buf, path);
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
 1c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1cc:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d2:	89 04 24             	mov    %eax,(%esp)
 1d5:	e8 9f 01 00 00       	call   379 <strcpy>
    p = buf+strlen(buf);
 1da:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e0:	89 04 24             	mov    %eax,(%esp)
 1e3:	e8 fb 01 00 00       	call   3e3 <strlen>
 1e8:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1ee:	01 d0                	add    %edx,%eax
 1f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1f6:	c6 00 2f             	movb   $0x2f,(%eax)
 1f9:	ff 45 e0             	incl   -0x20(%ebp)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1fc:	e9 be 00 00 00       	jmp    2bf <ls+0x212>
      if(de.inum == 0)
 201:	8b 85 d0 fd ff ff    	mov    -0x230(%ebp),%eax
 207:	66 85 c0             	test   %ax,%ax
 20a:	0f 84 ae 00 00 00    	je     2be <ls+0x211>
        continue;
      memmove(p, de.name, DIRSIZ);
 210:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 217:	00 
 218:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 21e:	83 c0 02             	add    $0x2,%eax
 221:	89 44 24 04          	mov    %eax,0x4(%esp)
 225:	8b 45 e0             	mov    -0x20(%ebp),%eax
 228:	89 04 24             	mov    %eax,(%esp)
 22b:	e8 2e 03 00 00       	call   55e <memmove>
      p[DIRSIZ] = 0;
 230:	8b 45 e0             	mov    -0x20(%ebp),%eax
 233:	83 c0 0e             	add    $0xe,%eax
 236:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 239:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 23f:	89 44 24 04          	mov    %eax,0x4(%esp)
 243:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 249:	89 04 24             	mov    %eax,(%esp)
 24c:	e8 78 02 00 00       	call   4c9 <stat>
 251:	85 c0                	test   %eax,%eax
 253:	79 20                	jns    275 <ls+0x1c8>
        printf(1, "ls: cannot stat %s\n", buf);
 255:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 25b:	89 44 24 08          	mov    %eax,0x8(%esp)
 25f:	c7 44 24 04 fb 0a 00 	movl   $0xafb,0x4(%esp)
 266:	00 
 267:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 26e:	e8 ad 04 00 00       	call   720 <printf>
        continue;
 273:	eb 4a                	jmp    2bf <ls+0x212>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 275:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 27b:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 281:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
 287:	0f bf d8             	movswl %ax,%ebx
 28a:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 290:	89 04 24             	mov    %eax,(%esp)
 293:	e8 68 fd ff ff       	call   0 <fmtname>
 298:	89 7c 24 14          	mov    %edi,0x14(%esp)
 29c:	89 74 24 10          	mov    %esi,0x10(%esp)
 2a0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 2a4:	89 44 24 08          	mov    %eax,0x8(%esp)
 2a8:	c7 44 24 04 0f 0b 00 	movl   $0xb0f,0x4(%esp)
 2af:	00 
 2b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2b7:	e8 64 04 00 00       	call   720 <printf>
 2bc:	eb 01                	jmp    2bf <ls+0x212>
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
 2be:	90                   	nop
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2bf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 2c6:	00 
 2c7:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2d4:	89 04 24             	mov    %eax,(%esp)
 2d7:	e8 dc 02 00 00       	call   5b8 <read>
 2dc:	83 f8 10             	cmp    $0x10,%eax
 2df:	0f 84 1c ff ff ff    	je     201 <ls+0x154>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2e5:	90                   	nop
  }
  close(fd);
 2e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2e9:	89 04 24             	mov    %eax,(%esp)
 2ec:	e8 d7 02 00 00       	call   5c8 <close>
}
 2f1:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2f7:	5b                   	pop    %ebx
 2f8:	5e                   	pop    %esi
 2f9:	5f                   	pop    %edi
 2fa:	5d                   	pop    %ebp
 2fb:	c3                   	ret    

000002fc <main>:

int
main(int argc, char *argv[])
{
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
 2ff:	83 e4 f0             	and    $0xfffffff0,%esp
 302:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
 305:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 309:	7f 11                	jg     31c <main+0x20>
    ls(".");
 30b:	c7 04 24 2f 0b 00 00 	movl   $0xb2f,(%esp)
 312:	e8 96 fd ff ff       	call   ad <ls>
    exit();
 317:	e8 84 02 00 00       	call   5a0 <exit>
  }
  for(i=1; i<argc; i++)
 31c:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 323:	00 
 324:	eb 1e                	jmp    344 <main+0x48>
    ls(argv[i]);
 326:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 32a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 331:	8b 45 0c             	mov    0xc(%ebp),%eax
 334:	01 d0                	add    %edx,%eax
 336:	8b 00                	mov    (%eax),%eax
 338:	89 04 24             	mov    %eax,(%esp)
 33b:	e8 6d fd ff ff       	call   ad <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 340:	ff 44 24 1c          	incl   0x1c(%esp)
 344:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 348:	3b 45 08             	cmp    0x8(%ebp),%eax
 34b:	7c d9                	jl     326 <main+0x2a>
    ls(argv[i]);
  exit();
 34d:	e8 4e 02 00 00       	call   5a0 <exit>
 352:	66 90                	xchg   %ax,%ax

00000354 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	57                   	push   %edi
 358:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 359:	8b 4d 08             	mov    0x8(%ebp),%ecx
 35c:	8b 55 10             	mov    0x10(%ebp),%edx
 35f:	8b 45 0c             	mov    0xc(%ebp),%eax
 362:	89 cb                	mov    %ecx,%ebx
 364:	89 df                	mov    %ebx,%edi
 366:	89 d1                	mov    %edx,%ecx
 368:	fc                   	cld    
 369:	f3 aa                	rep stos %al,%es:(%edi)
 36b:	89 ca                	mov    %ecx,%edx
 36d:	89 fb                	mov    %edi,%ebx
 36f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 372:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 375:	5b                   	pop    %ebx
 376:	5f                   	pop    %edi
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    

00000379 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 379:	55                   	push   %ebp
 37a:	89 e5                	mov    %esp,%ebp
 37c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 385:	90                   	nop
 386:	8b 45 0c             	mov    0xc(%ebp),%eax
 389:	8a 10                	mov    (%eax),%dl
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	88 10                	mov    %dl,(%eax)
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	8a 00                	mov    (%eax),%al
 395:	84 c0                	test   %al,%al
 397:	0f 95 c0             	setne  %al
 39a:	ff 45 08             	incl   0x8(%ebp)
 39d:	ff 45 0c             	incl   0xc(%ebp)
 3a0:	84 c0                	test   %al,%al
 3a2:	75 e2                	jne    386 <strcpy+0xd>
    ;
  return os;
 3a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3a7:	c9                   	leave  
 3a8:	c3                   	ret    

000003a9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3a9:	55                   	push   %ebp
 3aa:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3ac:	eb 06                	jmp    3b4 <strcmp+0xb>
    p++, q++;
 3ae:	ff 45 08             	incl   0x8(%ebp)
 3b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	8a 00                	mov    (%eax),%al
 3b9:	84 c0                	test   %al,%al
 3bb:	74 0e                	je     3cb <strcmp+0x22>
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	8a 10                	mov    (%eax),%dl
 3c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c5:	8a 00                	mov    (%eax),%al
 3c7:	38 c2                	cmp    %al,%dl
 3c9:	74 e3                	je     3ae <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3cb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ce:	8a 00                	mov    (%eax),%al
 3d0:	0f b6 d0             	movzbl %al,%edx
 3d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d6:	8a 00                	mov    (%eax),%al
 3d8:	0f b6 c0             	movzbl %al,%eax
 3db:	89 d1                	mov    %edx,%ecx
 3dd:	29 c1                	sub    %eax,%ecx
 3df:	89 c8                	mov    %ecx,%eax
}
 3e1:	5d                   	pop    %ebp
 3e2:	c3                   	ret    

000003e3 <strlen>:

uint
strlen(char *s)
{
 3e3:	55                   	push   %ebp
 3e4:	89 e5                	mov    %esp,%ebp
 3e6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3f0:	eb 03                	jmp    3f5 <strlen+0x12>
 3f2:	ff 45 fc             	incl   -0x4(%ebp)
 3f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	01 d0                	add    %edx,%eax
 3fd:	8a 00                	mov    (%eax),%al
 3ff:	84 c0                	test   %al,%al
 401:	75 ef                	jne    3f2 <strlen+0xf>
    ;
  return n;
 403:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 406:	c9                   	leave  
 407:	c3                   	ret    

00000408 <memset>:

void*
memset(void *dst, int c, uint n)
{
 408:	55                   	push   %ebp
 409:	89 e5                	mov    %esp,%ebp
 40b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 40e:	8b 45 10             	mov    0x10(%ebp),%eax
 411:	89 44 24 08          	mov    %eax,0x8(%esp)
 415:	8b 45 0c             	mov    0xc(%ebp),%eax
 418:	89 44 24 04          	mov    %eax,0x4(%esp)
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
 41f:	89 04 24             	mov    %eax,(%esp)
 422:	e8 2d ff ff ff       	call   354 <stosb>
  return dst;
 427:	8b 45 08             	mov    0x8(%ebp),%eax
}
 42a:	c9                   	leave  
 42b:	c3                   	ret    

0000042c <strchr>:

char*
strchr(const char *s, char c)
{
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	83 ec 04             	sub    $0x4,%esp
 432:	8b 45 0c             	mov    0xc(%ebp),%eax
 435:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 438:	eb 12                	jmp    44c <strchr+0x20>
    if(*s == c)
 43a:	8b 45 08             	mov    0x8(%ebp),%eax
 43d:	8a 00                	mov    (%eax),%al
 43f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 442:	75 05                	jne    449 <strchr+0x1d>
      return (char*)s;
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	eb 11                	jmp    45a <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 449:	ff 45 08             	incl   0x8(%ebp)
 44c:	8b 45 08             	mov    0x8(%ebp),%eax
 44f:	8a 00                	mov    (%eax),%al
 451:	84 c0                	test   %al,%al
 453:	75 e5                	jne    43a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 455:	b8 00 00 00 00       	mov    $0x0,%eax
}
 45a:	c9                   	leave  
 45b:	c3                   	ret    

0000045c <gets>:

char*
gets(char *buf, int max)
{
 45c:	55                   	push   %ebp
 45d:	89 e5                	mov    %esp,%ebp
 45f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 469:	eb 42                	jmp    4ad <gets+0x51>
    cc = read(0, &c, 1);
 46b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 472:	00 
 473:	8d 45 ef             	lea    -0x11(%ebp),%eax
 476:	89 44 24 04          	mov    %eax,0x4(%esp)
 47a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 481:	e8 32 01 00 00       	call   5b8 <read>
 486:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 489:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 48d:	7e 29                	jle    4b8 <gets+0x5c>
      break;
    buf[i++] = c;
 48f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 492:	8b 45 08             	mov    0x8(%ebp),%eax
 495:	01 c2                	add    %eax,%edx
 497:	8a 45 ef             	mov    -0x11(%ebp),%al
 49a:	88 02                	mov    %al,(%edx)
 49c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 49f:	8a 45 ef             	mov    -0x11(%ebp),%al
 4a2:	3c 0a                	cmp    $0xa,%al
 4a4:	74 13                	je     4b9 <gets+0x5d>
 4a6:	8a 45 ef             	mov    -0x11(%ebp),%al
 4a9:	3c 0d                	cmp    $0xd,%al
 4ab:	74 0c                	je     4b9 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b0:	40                   	inc    %eax
 4b1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4b4:	7c b5                	jl     46b <gets+0xf>
 4b6:	eb 01                	jmp    4b9 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4b8:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4bc:	8b 45 08             	mov    0x8(%ebp),%eax
 4bf:	01 d0                	add    %edx,%eax
 4c1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4c7:	c9                   	leave  
 4c8:	c3                   	ret    

000004c9 <stat>:

int
stat(char *n, struct stat *st)
{
 4c9:	55                   	push   %ebp
 4ca:	89 e5                	mov    %esp,%ebp
 4cc:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4d6:	00 
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	89 04 24             	mov    %eax,(%esp)
 4dd:	e8 fe 00 00 00       	call   5e0 <open>
 4e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e9:	79 07                	jns    4f2 <stat+0x29>
    return -1;
 4eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4f0:	eb 23                	jmp    515 <stat+0x4c>
  r = fstat(fd, st);
 4f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fc:	89 04 24             	mov    %eax,(%esp)
 4ff:	e8 f4 00 00 00       	call   5f8 <fstat>
 504:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 507:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50a:	89 04 24             	mov    %eax,(%esp)
 50d:	e8 b6 00 00 00       	call   5c8 <close>
  return r;
 512:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 515:	c9                   	leave  
 516:	c3                   	ret    

00000517 <atoi>:

int
atoi(const char *s)
{
 517:	55                   	push   %ebp
 518:	89 e5                	mov    %esp,%ebp
 51a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 51d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 524:	eb 21                	jmp    547 <atoi+0x30>
    n = n*10 + *s++ - '0';
 526:	8b 55 fc             	mov    -0x4(%ebp),%edx
 529:	89 d0                	mov    %edx,%eax
 52b:	c1 e0 02             	shl    $0x2,%eax
 52e:	01 d0                	add    %edx,%eax
 530:	d1 e0                	shl    %eax
 532:	89 c2                	mov    %eax,%edx
 534:	8b 45 08             	mov    0x8(%ebp),%eax
 537:	8a 00                	mov    (%eax),%al
 539:	0f be c0             	movsbl %al,%eax
 53c:	01 d0                	add    %edx,%eax
 53e:	83 e8 30             	sub    $0x30,%eax
 541:	89 45 fc             	mov    %eax,-0x4(%ebp)
 544:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	8a 00                	mov    (%eax),%al
 54c:	3c 2f                	cmp    $0x2f,%al
 54e:	7e 09                	jle    559 <atoi+0x42>
 550:	8b 45 08             	mov    0x8(%ebp),%eax
 553:	8a 00                	mov    (%eax),%al
 555:	3c 39                	cmp    $0x39,%al
 557:	7e cd                	jle    526 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 559:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 55c:	c9                   	leave  
 55d:	c3                   	ret    

0000055e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 55e:	55                   	push   %ebp
 55f:	89 e5                	mov    %esp,%ebp
 561:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 564:	8b 45 08             	mov    0x8(%ebp),%eax
 567:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 56a:	8b 45 0c             	mov    0xc(%ebp),%eax
 56d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 570:	eb 10                	jmp    582 <memmove+0x24>
    *dst++ = *src++;
 572:	8b 45 f8             	mov    -0x8(%ebp),%eax
 575:	8a 10                	mov    (%eax),%dl
 577:	8b 45 fc             	mov    -0x4(%ebp),%eax
 57a:	88 10                	mov    %dl,(%eax)
 57c:	ff 45 fc             	incl   -0x4(%ebp)
 57f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 582:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 586:	0f 9f c0             	setg   %al
 589:	ff 4d 10             	decl   0x10(%ebp)
 58c:	84 c0                	test   %al,%al
 58e:	75 e2                	jne    572 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 590:	8b 45 08             	mov    0x8(%ebp),%eax
}
 593:	c9                   	leave  
 594:	c3                   	ret    
 595:	66 90                	xchg   %ax,%ax
 597:	90                   	nop

00000598 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 598:	b8 01 00 00 00       	mov    $0x1,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <exit>:
SYSCALL(exit)
 5a0:	b8 02 00 00 00       	mov    $0x2,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <wait>:
SYSCALL(wait)
 5a8:	b8 03 00 00 00       	mov    $0x3,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <pipe>:
SYSCALL(pipe)
 5b0:	b8 04 00 00 00       	mov    $0x4,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <read>:
SYSCALL(read)
 5b8:	b8 05 00 00 00       	mov    $0x5,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <write>:
SYSCALL(write)
 5c0:	b8 10 00 00 00       	mov    $0x10,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <close>:
SYSCALL(close)
 5c8:	b8 15 00 00 00       	mov    $0x15,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <kill>:
SYSCALL(kill)
 5d0:	b8 06 00 00 00       	mov    $0x6,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <exec>:
SYSCALL(exec)
 5d8:	b8 07 00 00 00       	mov    $0x7,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <open>:
SYSCALL(open)
 5e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <mknod>:
SYSCALL(mknod)
 5e8:	b8 11 00 00 00       	mov    $0x11,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <unlink>:
SYSCALL(unlink)
 5f0:	b8 12 00 00 00       	mov    $0x12,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <fstat>:
SYSCALL(fstat)
 5f8:	b8 08 00 00 00       	mov    $0x8,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <link>:
SYSCALL(link)
 600:	b8 13 00 00 00       	mov    $0x13,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <mkdir>:
SYSCALL(mkdir)
 608:	b8 14 00 00 00       	mov    $0x14,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <chdir>:
SYSCALL(chdir)
 610:	b8 09 00 00 00       	mov    $0x9,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <dup>:
SYSCALL(dup)
 618:	b8 0a 00 00 00       	mov    $0xa,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <getpid>:
SYSCALL(getpid)
 620:	b8 0b 00 00 00       	mov    $0xb,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <sbrk>:
SYSCALL(sbrk)
 628:	b8 0c 00 00 00       	mov    $0xc,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <sleep>:
SYSCALL(sleep)
 630:	b8 0d 00 00 00       	mov    $0xd,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <uptime>:
SYSCALL(uptime)
 638:	b8 0e 00 00 00       	mov    $0xe,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <addpath>:
SYSCALL(addpath)
 640:	b8 16 00 00 00       	mov    $0x16,%eax
 645:	cd 40                	int    $0x40
 647:	c3                   	ret    

00000648 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 648:	55                   	push   %ebp
 649:	89 e5                	mov    %esp,%ebp
 64b:	83 ec 28             	sub    $0x28,%esp
 64e:	8b 45 0c             	mov    0xc(%ebp),%eax
 651:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 654:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 65b:	00 
 65c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 65f:	89 44 24 04          	mov    %eax,0x4(%esp)
 663:	8b 45 08             	mov    0x8(%ebp),%eax
 666:	89 04 24             	mov    %eax,(%esp)
 669:	e8 52 ff ff ff       	call   5c0 <write>
}
 66e:	c9                   	leave  
 66f:	c3                   	ret    

00000670 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 676:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 67d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 681:	74 17                	je     69a <printint+0x2a>
 683:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 687:	79 11                	jns    69a <printint+0x2a>
    neg = 1;
 689:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 690:	8b 45 0c             	mov    0xc(%ebp),%eax
 693:	f7 d8                	neg    %eax
 695:	89 45 ec             	mov    %eax,-0x14(%ebp)
 698:	eb 06                	jmp    6a0 <printint+0x30>
  } else {
    x = xx;
 69a:	8b 45 0c             	mov    0xc(%ebp),%eax
 69d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6ad:	ba 00 00 00 00       	mov    $0x0,%edx
 6b2:	f7 f1                	div    %ecx
 6b4:	89 d0                	mov    %edx,%eax
 6b6:	8a 80 c8 0d 00 00    	mov    0xdc8(%eax),%al
 6bc:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 6bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6c2:	01 ca                	add    %ecx,%edx
 6c4:	88 02                	mov    %al,(%edx)
 6c6:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 6c9:	8b 55 10             	mov    0x10(%ebp),%edx
 6cc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6d2:	ba 00 00 00 00       	mov    $0x0,%edx
 6d7:	f7 75 d4             	divl   -0x2c(%ebp)
 6da:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6e1:	75 c4                	jne    6a7 <printint+0x37>
  if(neg)
 6e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6e7:	74 2c                	je     715 <printint+0xa5>
    buf[i++] = '-';
 6e9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ef:	01 d0                	add    %edx,%eax
 6f1:	c6 00 2d             	movb   $0x2d,(%eax)
 6f4:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 6f7:	eb 1c                	jmp    715 <printint+0xa5>
    putc(fd, buf[i]);
 6f9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ff:	01 d0                	add    %edx,%eax
 701:	8a 00                	mov    (%eax),%al
 703:	0f be c0             	movsbl %al,%eax
 706:	89 44 24 04          	mov    %eax,0x4(%esp)
 70a:	8b 45 08             	mov    0x8(%ebp),%eax
 70d:	89 04 24             	mov    %eax,(%esp)
 710:	e8 33 ff ff ff       	call   648 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 715:	ff 4d f4             	decl   -0xc(%ebp)
 718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 71c:	79 db                	jns    6f9 <printint+0x89>
    putc(fd, buf[i]);
}
 71e:	c9                   	leave  
 71f:	c3                   	ret    

00000720 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 726:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 72d:	8d 45 0c             	lea    0xc(%ebp),%eax
 730:	83 c0 04             	add    $0x4,%eax
 733:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 736:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 73d:	e9 78 01 00 00       	jmp    8ba <printf+0x19a>
    c = fmt[i] & 0xff;
 742:	8b 55 0c             	mov    0xc(%ebp),%edx
 745:	8b 45 f0             	mov    -0x10(%ebp),%eax
 748:	01 d0                	add    %edx,%eax
 74a:	8a 00                	mov    (%eax),%al
 74c:	0f be c0             	movsbl %al,%eax
 74f:	25 ff 00 00 00       	and    $0xff,%eax
 754:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 757:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 75b:	75 2c                	jne    789 <printf+0x69>
      if(c == '%'){
 75d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 761:	75 0c                	jne    76f <printf+0x4f>
        state = '%';
 763:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 76a:	e9 48 01 00 00       	jmp    8b7 <printf+0x197>
      } else {
        putc(fd, c);
 76f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 772:	0f be c0             	movsbl %al,%eax
 775:	89 44 24 04          	mov    %eax,0x4(%esp)
 779:	8b 45 08             	mov    0x8(%ebp),%eax
 77c:	89 04 24             	mov    %eax,(%esp)
 77f:	e8 c4 fe ff ff       	call   648 <putc>
 784:	e9 2e 01 00 00       	jmp    8b7 <printf+0x197>
      }
    } else if(state == '%'){
 789:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 78d:	0f 85 24 01 00 00    	jne    8b7 <printf+0x197>
      if(c == 'd'){
 793:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 797:	75 2d                	jne    7c6 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 799:	8b 45 e8             	mov    -0x18(%ebp),%eax
 79c:	8b 00                	mov    (%eax),%eax
 79e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7a5:	00 
 7a6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7ad:	00 
 7ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 7b2:	8b 45 08             	mov    0x8(%ebp),%eax
 7b5:	89 04 24             	mov    %eax,(%esp)
 7b8:	e8 b3 fe ff ff       	call   670 <printint>
        ap++;
 7bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7c1:	e9 ea 00 00 00       	jmp    8b0 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 7c6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7ca:	74 06                	je     7d2 <printf+0xb2>
 7cc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7d0:	75 2d                	jne    7ff <printf+0xdf>
        printint(fd, *ap, 16, 0);
 7d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d5:	8b 00                	mov    (%eax),%eax
 7d7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7de:	00 
 7df:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 7e6:	00 
 7e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 7eb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ee:	89 04 24             	mov    %eax,(%esp)
 7f1:	e8 7a fe ff ff       	call   670 <printint>
        ap++;
 7f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7fa:	e9 b1 00 00 00       	jmp    8b0 <printf+0x190>
      } else if(c == 's'){
 7ff:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 803:	75 43                	jne    848 <printf+0x128>
        s = (char*)*ap;
 805:	8b 45 e8             	mov    -0x18(%ebp),%eax
 808:	8b 00                	mov    (%eax),%eax
 80a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 80d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 815:	75 25                	jne    83c <printf+0x11c>
          s = "(null)";
 817:	c7 45 f4 31 0b 00 00 	movl   $0xb31,-0xc(%ebp)
        while(*s != 0){
 81e:	eb 1c                	jmp    83c <printf+0x11c>
          putc(fd, *s);
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	8a 00                	mov    (%eax),%al
 825:	0f be c0             	movsbl %al,%eax
 828:	89 44 24 04          	mov    %eax,0x4(%esp)
 82c:	8b 45 08             	mov    0x8(%ebp),%eax
 82f:	89 04 24             	mov    %eax,(%esp)
 832:	e8 11 fe ff ff       	call   648 <putc>
          s++;
 837:	ff 45 f4             	incl   -0xc(%ebp)
 83a:	eb 01                	jmp    83d <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 83c:	90                   	nop
 83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 840:	8a 00                	mov    (%eax),%al
 842:	84 c0                	test   %al,%al
 844:	75 da                	jne    820 <printf+0x100>
 846:	eb 68                	jmp    8b0 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 848:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 84c:	75 1d                	jne    86b <printf+0x14b>
        putc(fd, *ap);
 84e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 851:	8b 00                	mov    (%eax),%eax
 853:	0f be c0             	movsbl %al,%eax
 856:	89 44 24 04          	mov    %eax,0x4(%esp)
 85a:	8b 45 08             	mov    0x8(%ebp),%eax
 85d:	89 04 24             	mov    %eax,(%esp)
 860:	e8 e3 fd ff ff       	call   648 <putc>
        ap++;
 865:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 869:	eb 45                	jmp    8b0 <printf+0x190>
      } else if(c == '%'){
 86b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 86f:	75 17                	jne    888 <printf+0x168>
        putc(fd, c);
 871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 874:	0f be c0             	movsbl %al,%eax
 877:	89 44 24 04          	mov    %eax,0x4(%esp)
 87b:	8b 45 08             	mov    0x8(%ebp),%eax
 87e:	89 04 24             	mov    %eax,(%esp)
 881:	e8 c2 fd ff ff       	call   648 <putc>
 886:	eb 28                	jmp    8b0 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 888:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 88f:	00 
 890:	8b 45 08             	mov    0x8(%ebp),%eax
 893:	89 04 24             	mov    %eax,(%esp)
 896:	e8 ad fd ff ff       	call   648 <putc>
        putc(fd, c);
 89b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 89e:	0f be c0             	movsbl %al,%eax
 8a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 8a5:	8b 45 08             	mov    0x8(%ebp),%eax
 8a8:	89 04 24             	mov    %eax,(%esp)
 8ab:	e8 98 fd ff ff       	call   648 <putc>
      }
      state = 0;
 8b0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8b7:	ff 45 f0             	incl   -0x10(%ebp)
 8ba:	8b 55 0c             	mov    0xc(%ebp),%edx
 8bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c0:	01 d0                	add    %edx,%eax
 8c2:	8a 00                	mov    (%eax),%al
 8c4:	84 c0                	test   %al,%al
 8c6:	0f 85 76 fe ff ff    	jne    742 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8cc:	c9                   	leave  
 8cd:	c3                   	ret    
 8ce:	66 90                	xchg   %ax,%ax

000008d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp
 8d3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8d6:	8b 45 08             	mov    0x8(%ebp),%eax
 8d9:	83 e8 08             	sub    $0x8,%eax
 8dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8df:	a1 f4 0d 00 00       	mov    0xdf4,%eax
 8e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8e7:	eb 24                	jmp    90d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ec:	8b 00                	mov    (%eax),%eax
 8ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8f1:	77 12                	ja     905 <free+0x35>
 8f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8f9:	77 24                	ja     91f <free+0x4f>
 8fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fe:	8b 00                	mov    (%eax),%eax
 900:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 903:	77 1a                	ja     91f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 905:	8b 45 fc             	mov    -0x4(%ebp),%eax
 908:	8b 00                	mov    (%eax),%eax
 90a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 90d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 910:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 913:	76 d4                	jbe    8e9 <free+0x19>
 915:	8b 45 fc             	mov    -0x4(%ebp),%eax
 918:	8b 00                	mov    (%eax),%eax
 91a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 91d:	76 ca                	jbe    8e9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 91f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 922:	8b 40 04             	mov    0x4(%eax),%eax
 925:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 92c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92f:	01 c2                	add    %eax,%edx
 931:	8b 45 fc             	mov    -0x4(%ebp),%eax
 934:	8b 00                	mov    (%eax),%eax
 936:	39 c2                	cmp    %eax,%edx
 938:	75 24                	jne    95e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 93a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93d:	8b 50 04             	mov    0x4(%eax),%edx
 940:	8b 45 fc             	mov    -0x4(%ebp),%eax
 943:	8b 00                	mov    (%eax),%eax
 945:	8b 40 04             	mov    0x4(%eax),%eax
 948:	01 c2                	add    %eax,%edx
 94a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 950:	8b 45 fc             	mov    -0x4(%ebp),%eax
 953:	8b 00                	mov    (%eax),%eax
 955:	8b 10                	mov    (%eax),%edx
 957:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95a:	89 10                	mov    %edx,(%eax)
 95c:	eb 0a                	jmp    968 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 95e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 961:	8b 10                	mov    (%eax),%edx
 963:	8b 45 f8             	mov    -0x8(%ebp),%eax
 966:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 968:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96b:	8b 40 04             	mov    0x4(%eax),%eax
 96e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 975:	8b 45 fc             	mov    -0x4(%ebp),%eax
 978:	01 d0                	add    %edx,%eax
 97a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 97d:	75 20                	jne    99f <free+0xcf>
    p->s.size += bp->s.size;
 97f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 982:	8b 50 04             	mov    0x4(%eax),%edx
 985:	8b 45 f8             	mov    -0x8(%ebp),%eax
 988:	8b 40 04             	mov    0x4(%eax),%eax
 98b:	01 c2                	add    %eax,%edx
 98d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 990:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 993:	8b 45 f8             	mov    -0x8(%ebp),%eax
 996:	8b 10                	mov    (%eax),%edx
 998:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99b:	89 10                	mov    %edx,(%eax)
 99d:	eb 08                	jmp    9a7 <free+0xd7>
  } else
    p->s.ptr = bp;
 99f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9a5:	89 10                	mov    %edx,(%eax)
  freep = p;
 9a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9aa:	a3 f4 0d 00 00       	mov    %eax,0xdf4
}
 9af:	c9                   	leave  
 9b0:	c3                   	ret    

000009b1 <morecore>:

static Header*
morecore(uint nu)
{
 9b1:	55                   	push   %ebp
 9b2:	89 e5                	mov    %esp,%ebp
 9b4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9b7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9be:	77 07                	ja     9c7 <morecore+0x16>
    nu = 4096;
 9c0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9c7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ca:	c1 e0 03             	shl    $0x3,%eax
 9cd:	89 04 24             	mov    %eax,(%esp)
 9d0:	e8 53 fc ff ff       	call   628 <sbrk>
 9d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9d8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9dc:	75 07                	jne    9e5 <morecore+0x34>
    return 0;
 9de:	b8 00 00 00 00       	mov    $0x0,%eax
 9e3:	eb 22                	jmp    a07 <morecore+0x56>
  hp = (Header*)p;
 9e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ee:	8b 55 08             	mov    0x8(%ebp),%edx
 9f1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f7:	83 c0 08             	add    $0x8,%eax
 9fa:	89 04 24             	mov    %eax,(%esp)
 9fd:	e8 ce fe ff ff       	call   8d0 <free>
  return freep;
 a02:	a1 f4 0d 00 00       	mov    0xdf4,%eax
}
 a07:	c9                   	leave  
 a08:	c3                   	ret    

00000a09 <malloc>:

void*
malloc(uint nbytes)
{
 a09:	55                   	push   %ebp
 a0a:	89 e5                	mov    %esp,%ebp
 a0c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a0f:	8b 45 08             	mov    0x8(%ebp),%eax
 a12:	83 c0 07             	add    $0x7,%eax
 a15:	c1 e8 03             	shr    $0x3,%eax
 a18:	40                   	inc    %eax
 a19:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a1c:	a1 f4 0d 00 00       	mov    0xdf4,%eax
 a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a28:	75 23                	jne    a4d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 a2a:	c7 45 f0 ec 0d 00 00 	movl   $0xdec,-0x10(%ebp)
 a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a34:	a3 f4 0d 00 00       	mov    %eax,0xdf4
 a39:	a1 f4 0d 00 00       	mov    0xdf4,%eax
 a3e:	a3 ec 0d 00 00       	mov    %eax,0xdec
    base.s.size = 0;
 a43:	c7 05 f0 0d 00 00 00 	movl   $0x0,0xdf0
 a4a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a50:	8b 00                	mov    (%eax),%eax
 a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a58:	8b 40 04             	mov    0x4(%eax),%eax
 a5b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a5e:	72 4d                	jb     aad <malloc+0xa4>
      if(p->s.size == nunits)
 a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a63:	8b 40 04             	mov    0x4(%eax),%eax
 a66:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a69:	75 0c                	jne    a77 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6e:	8b 10                	mov    (%eax),%edx
 a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a73:	89 10                	mov    %edx,(%eax)
 a75:	eb 26                	jmp    a9d <malloc+0x94>
      else {
        p->s.size -= nunits;
 a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7a:	8b 40 04             	mov    0x4(%eax),%eax
 a7d:	89 c2                	mov    %eax,%edx
 a7f:	2b 55 ec             	sub    -0x14(%ebp),%edx
 a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a85:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8b:	8b 40 04             	mov    0x4(%eax),%eax
 a8e:	c1 e0 03             	shl    $0x3,%eax
 a91:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a97:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a9a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa0:	a3 f4 0d 00 00       	mov    %eax,0xdf4
      return (void*)(p + 1);
 aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa8:	83 c0 08             	add    $0x8,%eax
 aab:	eb 38                	jmp    ae5 <malloc+0xdc>
    }
    if(p == freep)
 aad:	a1 f4 0d 00 00       	mov    0xdf4,%eax
 ab2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ab5:	75 1b                	jne    ad2 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aba:	89 04 24             	mov    %eax,(%esp)
 abd:	e8 ef fe ff ff       	call   9b1 <morecore>
 ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ac5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ac9:	75 07                	jne    ad2 <malloc+0xc9>
        return 0;
 acb:	b8 00 00 00 00       	mov    $0x0,%eax
 ad0:	eb 13                	jmp    ae5 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 adb:	8b 00                	mov    (%eax),%eax
 add:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ae0:	e9 70 ff ff ff       	jmp    a55 <malloc+0x4c>
}
 ae5:	c9                   	leave  
 ae6:	c3                   	ret    
