
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
  5e:	c7 04 24 c0 0e 00 00 	movl   $0xec0,(%esp)
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
  89:	05 c0 0e 00 00       	add    $0xec0,%eax
  8e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  92:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  99:	00 
  9a:	89 04 24             	mov    %eax,(%esp)
  9d:	e8 66 03 00 00       	call   408 <memset>
  return buf;
  a2:	b8 c0 0e 00 00       	mov    $0xec0,%eax
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
  c7:	e8 d0 05 00 00       	call   69c <open>
  cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d3:	79 20                	jns    f5 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  dc:	c7 44 24 04 ab 0b 00 	movl   $0xbab,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  eb:	e8 f4 06 00 00       	call   7e4 <printf>
  f0:	e9 fc 01 00 00       	jmp    2f1 <ls+0x244>
    return;
  }
  
  if(fstat(fd, &st) < 0){
  f5:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 102:	89 04 24             	mov    %eax,(%esp)
 105:	e8 aa 05 00 00       	call   6b4 <fstat>
 10a:	85 c0                	test   %eax,%eax
 10c:	79 2b                	jns    139 <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
 111:	89 44 24 08          	mov    %eax,0x8(%esp)
 115:	c7 44 24 04 bf 0b 00 	movl   $0xbbf,0x4(%esp)
 11c:	00 
 11d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 124:	e8 bb 06 00 00       	call   7e4 <printf>
    close(fd);
 129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12c:	89 04 24             	mov    %eax,(%esp)
 12f:	e8 50 05 00 00       	call   684 <close>
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
 17e:	c7 44 24 04 d3 0b 00 	movl   $0xbd3,0x4(%esp)
 185:	00 
 186:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18d:	e8 52 06 00 00       	call   7e4 <printf>
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
 1ac:	c7 44 24 04 e0 0b 00 	movl   $0xbe0,0x4(%esp)
 1b3:	00 
 1b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1bb:	e8 24 06 00 00       	call   7e4 <printf>
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
 25f:	c7 44 24 04 bf 0b 00 	movl   $0xbbf,0x4(%esp)
 266:	00 
 267:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 26e:	e8 71 05 00 00       	call   7e4 <printf>
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
 2a8:	c7 44 24 04 d3 0b 00 	movl   $0xbd3,0x4(%esp)
 2af:	00 
 2b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2b7:	e8 28 05 00 00       	call   7e4 <printf>
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
 2d7:	e8 98 03 00 00       	call   674 <read>
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
 2ec:	e8 93 03 00 00       	call   684 <close>
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
 30b:	c7 04 24 f3 0b 00 00 	movl   $0xbf3,(%esp)
 312:	e8 96 fd ff ff       	call   ad <ls>
    exit();
 317:	e8 40 03 00 00       	call   65c <exit>
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
 34d:	e8 0a 03 00 00       	call   65c <exit>
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

#define NULL   0

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
 481:	e8 ee 01 00 00       	call   674 <read>
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
 4dd:	e8 ba 01 00 00       	call   69c <open>
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
 4ff:	e8 b0 01 00 00       	call   6b4 <fstat>
 504:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 507:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50a:	89 04 24             	mov    %eax,(%esp)
 50d:	e8 72 01 00 00       	call   684 <close>
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

00000595 <strtok>:

char*
strtok(char *teststr, char ch)
{
 595:	55                   	push   %ebp
 596:	89 e5                	mov    %esp,%ebp
 598:	83 ec 24             	sub    $0x24,%esp
 59b:	8b 45 0c             	mov    0xc(%ebp),%eax
 59e:	88 45 dc             	mov    %al,-0x24(%ebp)
    char *dummystr = NULL;
 5a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    char *start = NULL;
 5a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    char *end = NULL;
 5af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char nullch = '\0';
 5b6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    char *address_of_null = &nullch;
 5ba:	8d 45 ef             	lea    -0x11(%ebp),%eax
 5bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    static char *nexttok;

    if(teststr != NULL)
 5c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 5c4:	74 08                	je     5ce <strtok+0x39>
    {
        dummystr = teststr;
 5c6:	8b 45 08             	mov    0x8(%ebp),%eax
 5c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 5cc:	eb 75                	jmp    643 <strtok+0xae>
    {
        dummystr = teststr;
    }
    else
    {
        if(*nexttok == '\0')
 5ce:	a1 d0 0e 00 00       	mov    0xed0,%eax
 5d3:	8a 00                	mov    (%eax),%al
 5d5:	84 c0                	test   %al,%al
 5d7:	75 07                	jne    5e0 <strtok+0x4b>
            return NULL;
 5d9:	b8 00 00 00 00       	mov    $0x0,%eax
 5de:	eb 6f                	jmp    64f <strtok+0xba>
        dummystr = nexttok;
 5e0:	a1 d0 0e 00 00       	mov    0xed0,%eax
 5e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }


    while(dummystr != NULL)
 5e8:	eb 59                	jmp    643 <strtok+0xae>
    {
        //empty string
        if(*dummystr == '\0')
 5ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ed:	8a 00                	mov    (%eax),%al
 5ef:	84 c0                	test   %al,%al
 5f1:	74 58                	je     64b <strtok+0xb6>
            break;
        if(*dummystr != ch)
 5f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f6:	8a 00                	mov    (%eax),%al
 5f8:	3a 45 dc             	cmp    -0x24(%ebp),%al
 5fb:	74 22                	je     61f <strtok+0x8a>
        {
            if(!start)
 5fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 601:	75 06                	jne    609 <strtok+0x74>
                start = dummystr;
 603:	8b 45 fc             	mov    -0x4(%ebp),%eax
 606:	89 45 f8             	mov    %eax,-0x8(%ebp)

            dummystr++;
 609:	ff 45 fc             	incl   -0x4(%ebp)

            // handle the case where the delimiter is not at the end of the string.
            if(*dummystr == '\0')
 60c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60f:	8a 00                	mov    (%eax),%al
 611:	84 c0                	test   %al,%al
 613:	75 2e                	jne    643 <strtok+0xae>
            {
                nexttok = dummystr;
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	a3 d0 0e 00 00       	mov    %eax,0xed0
                break;
 61d:	eb 2d                	jmp    64c <strtok+0xb7>
            }
        }
        else
        {
            if(start)
 61f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 623:	74 1b                	je     640 <strtok+0xab>
            {
                end = dummystr;
 625:	8b 45 fc             	mov    -0x4(%ebp),%eax
 628:	89 45 f4             	mov    %eax,-0xc(%ebp)
                nexttok = dummystr+1;
 62b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62e:	40                   	inc    %eax
 62f:	a3 d0 0e 00 00       	mov    %eax,0xed0
                *end = *address_of_null;
 634:	8b 45 f0             	mov    -0x10(%ebp),%eax
 637:	8a 10                	mov    (%eax),%dl
 639:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63c:	88 10                	mov    %dl,(%eax)
                break;
 63e:	eb 0c                	jmp    64c <strtok+0xb7>
            }
            else
            {
                dummystr++;
 640:	ff 45 fc             	incl   -0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 643:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
 647:	75 a1                	jne    5ea <strtok+0x55>
 649:	eb 01                	jmp    64c <strtok+0xb7>
    {
        //empty string
        if(*dummystr == '\0')
            break;
 64b:	90                   	nop
                dummystr++;
            }
        }
    }

    return start;
 64c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 64f:	c9                   	leave  
 650:	c3                   	ret    
 651:	66 90                	xchg   %ax,%ax
 653:	90                   	nop

00000654 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 654:	b8 01 00 00 00       	mov    $0x1,%eax
 659:	cd 40                	int    $0x40
 65b:	c3                   	ret    

0000065c <exit>:
SYSCALL(exit)
 65c:	b8 02 00 00 00       	mov    $0x2,%eax
 661:	cd 40                	int    $0x40
 663:	c3                   	ret    

00000664 <wait>:
SYSCALL(wait)
 664:	b8 03 00 00 00       	mov    $0x3,%eax
 669:	cd 40                	int    $0x40
 66b:	c3                   	ret    

0000066c <pipe>:
SYSCALL(pipe)
 66c:	b8 04 00 00 00       	mov    $0x4,%eax
 671:	cd 40                	int    $0x40
 673:	c3                   	ret    

00000674 <read>:
SYSCALL(read)
 674:	b8 05 00 00 00       	mov    $0x5,%eax
 679:	cd 40                	int    $0x40
 67b:	c3                   	ret    

0000067c <write>:
SYSCALL(write)
 67c:	b8 10 00 00 00       	mov    $0x10,%eax
 681:	cd 40                	int    $0x40
 683:	c3                   	ret    

00000684 <close>:
SYSCALL(close)
 684:	b8 15 00 00 00       	mov    $0x15,%eax
 689:	cd 40                	int    $0x40
 68b:	c3                   	ret    

0000068c <kill>:
SYSCALL(kill)
 68c:	b8 06 00 00 00       	mov    $0x6,%eax
 691:	cd 40                	int    $0x40
 693:	c3                   	ret    

00000694 <exec>:
SYSCALL(exec)
 694:	b8 07 00 00 00       	mov    $0x7,%eax
 699:	cd 40                	int    $0x40
 69b:	c3                   	ret    

0000069c <open>:
SYSCALL(open)
 69c:	b8 0f 00 00 00       	mov    $0xf,%eax
 6a1:	cd 40                	int    $0x40
 6a3:	c3                   	ret    

000006a4 <mknod>:
SYSCALL(mknod)
 6a4:	b8 11 00 00 00       	mov    $0x11,%eax
 6a9:	cd 40                	int    $0x40
 6ab:	c3                   	ret    

000006ac <unlink>:
SYSCALL(unlink)
 6ac:	b8 12 00 00 00       	mov    $0x12,%eax
 6b1:	cd 40                	int    $0x40
 6b3:	c3                   	ret    

000006b4 <fstat>:
SYSCALL(fstat)
 6b4:	b8 08 00 00 00       	mov    $0x8,%eax
 6b9:	cd 40                	int    $0x40
 6bb:	c3                   	ret    

000006bc <link>:
SYSCALL(link)
 6bc:	b8 13 00 00 00       	mov    $0x13,%eax
 6c1:	cd 40                	int    $0x40
 6c3:	c3                   	ret    

000006c4 <mkdir>:
SYSCALL(mkdir)
 6c4:	b8 14 00 00 00       	mov    $0x14,%eax
 6c9:	cd 40                	int    $0x40
 6cb:	c3                   	ret    

000006cc <chdir>:
SYSCALL(chdir)
 6cc:	b8 09 00 00 00       	mov    $0x9,%eax
 6d1:	cd 40                	int    $0x40
 6d3:	c3                   	ret    

000006d4 <dup>:
SYSCALL(dup)
 6d4:	b8 0a 00 00 00       	mov    $0xa,%eax
 6d9:	cd 40                	int    $0x40
 6db:	c3                   	ret    

000006dc <getpid>:
SYSCALL(getpid)
 6dc:	b8 0b 00 00 00       	mov    $0xb,%eax
 6e1:	cd 40                	int    $0x40
 6e3:	c3                   	ret    

000006e4 <sbrk>:
SYSCALL(sbrk)
 6e4:	b8 0c 00 00 00       	mov    $0xc,%eax
 6e9:	cd 40                	int    $0x40
 6eb:	c3                   	ret    

000006ec <sleep>:
SYSCALL(sleep)
 6ec:	b8 0d 00 00 00       	mov    $0xd,%eax
 6f1:	cd 40                	int    $0x40
 6f3:	c3                   	ret    

000006f4 <uptime>:
SYSCALL(uptime)
 6f4:	b8 0e 00 00 00       	mov    $0xe,%eax
 6f9:	cd 40                	int    $0x40
 6fb:	c3                   	ret    

000006fc <add_path>:
SYSCALL(add_path)
 6fc:	b8 16 00 00 00       	mov    $0x16,%eax
 701:	cd 40                	int    $0x40
 703:	c3                   	ret    

00000704 <wait2>:
SYSCALL(wait2)
 704:	b8 17 00 00 00       	mov    $0x17,%eax
 709:	cd 40                	int    $0x40
 70b:	c3                   	ret    

0000070c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 70c:	55                   	push   %ebp
 70d:	89 e5                	mov    %esp,%ebp
 70f:	83 ec 28             	sub    $0x28,%esp
 712:	8b 45 0c             	mov    0xc(%ebp),%eax
 715:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 718:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 71f:	00 
 720:	8d 45 f4             	lea    -0xc(%ebp),%eax
 723:	89 44 24 04          	mov    %eax,0x4(%esp)
 727:	8b 45 08             	mov    0x8(%ebp),%eax
 72a:	89 04 24             	mov    %eax,(%esp)
 72d:	e8 4a ff ff ff       	call   67c <write>
}
 732:	c9                   	leave  
 733:	c3                   	ret    

00000734 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 734:	55                   	push   %ebp
 735:	89 e5                	mov    %esp,%ebp
 737:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 73a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 741:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 745:	74 17                	je     75e <printint+0x2a>
 747:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 74b:	79 11                	jns    75e <printint+0x2a>
    neg = 1;
 74d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 754:	8b 45 0c             	mov    0xc(%ebp),%eax
 757:	f7 d8                	neg    %eax
 759:	89 45 ec             	mov    %eax,-0x14(%ebp)
 75c:	eb 06                	jmp    764 <printint+0x30>
  } else {
    x = xx;
 75e:	8b 45 0c             	mov    0xc(%ebp),%eax
 761:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 764:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 76b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 76e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 771:	ba 00 00 00 00       	mov    $0x0,%edx
 776:	f7 f1                	div    %ecx
 778:	89 d0                	mov    %edx,%eax
 77a:	8a 80 ac 0e 00 00    	mov    0xeac(%eax),%al
 780:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 783:	8b 55 f4             	mov    -0xc(%ebp),%edx
 786:	01 ca                	add    %ecx,%edx
 788:	88 02                	mov    %al,(%edx)
 78a:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 78d:	8b 55 10             	mov    0x10(%ebp),%edx
 790:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 793:	8b 45 ec             	mov    -0x14(%ebp),%eax
 796:	ba 00 00 00 00       	mov    $0x0,%edx
 79b:	f7 75 d4             	divl   -0x2c(%ebp)
 79e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7a5:	75 c4                	jne    76b <printint+0x37>
  if(neg)
 7a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ab:	74 2c                	je     7d9 <printint+0xa5>
    buf[i++] = '-';
 7ad:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	01 d0                	add    %edx,%eax
 7b5:	c6 00 2d             	movb   $0x2d,(%eax)
 7b8:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 7bb:	eb 1c                	jmp    7d9 <printint+0xa5>
    putc(fd, buf[i]);
 7bd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	01 d0                	add    %edx,%eax
 7c5:	8a 00                	mov    (%eax),%al
 7c7:	0f be c0             	movsbl %al,%eax
 7ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ce:	8b 45 08             	mov    0x8(%ebp),%eax
 7d1:	89 04 24             	mov    %eax,(%esp)
 7d4:	e8 33 ff ff ff       	call   70c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7d9:	ff 4d f4             	decl   -0xc(%ebp)
 7dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e0:	79 db                	jns    7bd <printint+0x89>
    putc(fd, buf[i]);
}
 7e2:	c9                   	leave  
 7e3:	c3                   	ret    

000007e4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7e4:	55                   	push   %ebp
 7e5:	89 e5                	mov    %esp,%ebp
 7e7:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7f1:	8d 45 0c             	lea    0xc(%ebp),%eax
 7f4:	83 c0 04             	add    $0x4,%eax
 7f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 801:	e9 78 01 00 00       	jmp    97e <printf+0x19a>
    c = fmt[i] & 0xff;
 806:	8b 55 0c             	mov    0xc(%ebp),%edx
 809:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80c:	01 d0                	add    %edx,%eax
 80e:	8a 00                	mov    (%eax),%al
 810:	0f be c0             	movsbl %al,%eax
 813:	25 ff 00 00 00       	and    $0xff,%eax
 818:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 81b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 81f:	75 2c                	jne    84d <printf+0x69>
      if(c == '%'){
 821:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 825:	75 0c                	jne    833 <printf+0x4f>
        state = '%';
 827:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 82e:	e9 48 01 00 00       	jmp    97b <printf+0x197>
      } else {
        putc(fd, c);
 833:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 836:	0f be c0             	movsbl %al,%eax
 839:	89 44 24 04          	mov    %eax,0x4(%esp)
 83d:	8b 45 08             	mov    0x8(%ebp),%eax
 840:	89 04 24             	mov    %eax,(%esp)
 843:	e8 c4 fe ff ff       	call   70c <putc>
 848:	e9 2e 01 00 00       	jmp    97b <printf+0x197>
      }
    } else if(state == '%'){
 84d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 851:	0f 85 24 01 00 00    	jne    97b <printf+0x197>
      if(c == 'd'){
 857:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 85b:	75 2d                	jne    88a <printf+0xa6>
        printint(fd, *ap, 10, 1);
 85d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 860:	8b 00                	mov    (%eax),%eax
 862:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 869:	00 
 86a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 871:	00 
 872:	89 44 24 04          	mov    %eax,0x4(%esp)
 876:	8b 45 08             	mov    0x8(%ebp),%eax
 879:	89 04 24             	mov    %eax,(%esp)
 87c:	e8 b3 fe ff ff       	call   734 <printint>
        ap++;
 881:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 885:	e9 ea 00 00 00       	jmp    974 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 88a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 88e:	74 06                	je     896 <printf+0xb2>
 890:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 894:	75 2d                	jne    8c3 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 896:	8b 45 e8             	mov    -0x18(%ebp),%eax
 899:	8b 00                	mov    (%eax),%eax
 89b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 8a2:	00 
 8a3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 8aa:	00 
 8ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 8af:	8b 45 08             	mov    0x8(%ebp),%eax
 8b2:	89 04 24             	mov    %eax,(%esp)
 8b5:	e8 7a fe ff ff       	call   734 <printint>
        ap++;
 8ba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8be:	e9 b1 00 00 00       	jmp    974 <printf+0x190>
      } else if(c == 's'){
 8c3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8c7:	75 43                	jne    90c <printf+0x128>
        s = (char*)*ap;
 8c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8cc:	8b 00                	mov    (%eax),%eax
 8ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d9:	75 25                	jne    900 <printf+0x11c>
          s = "(null)";
 8db:	c7 45 f4 f5 0b 00 00 	movl   $0xbf5,-0xc(%ebp)
        while(*s != 0){
 8e2:	eb 1c                	jmp    900 <printf+0x11c>
          putc(fd, *s);
 8e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e7:	8a 00                	mov    (%eax),%al
 8e9:	0f be c0             	movsbl %al,%eax
 8ec:	89 44 24 04          	mov    %eax,0x4(%esp)
 8f0:	8b 45 08             	mov    0x8(%ebp),%eax
 8f3:	89 04 24             	mov    %eax,(%esp)
 8f6:	e8 11 fe ff ff       	call   70c <putc>
          s++;
 8fb:	ff 45 f4             	incl   -0xc(%ebp)
 8fe:	eb 01                	jmp    901 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 900:	90                   	nop
 901:	8b 45 f4             	mov    -0xc(%ebp),%eax
 904:	8a 00                	mov    (%eax),%al
 906:	84 c0                	test   %al,%al
 908:	75 da                	jne    8e4 <printf+0x100>
 90a:	eb 68                	jmp    974 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 90c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 910:	75 1d                	jne    92f <printf+0x14b>
        putc(fd, *ap);
 912:	8b 45 e8             	mov    -0x18(%ebp),%eax
 915:	8b 00                	mov    (%eax),%eax
 917:	0f be c0             	movsbl %al,%eax
 91a:	89 44 24 04          	mov    %eax,0x4(%esp)
 91e:	8b 45 08             	mov    0x8(%ebp),%eax
 921:	89 04 24             	mov    %eax,(%esp)
 924:	e8 e3 fd ff ff       	call   70c <putc>
        ap++;
 929:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 92d:	eb 45                	jmp    974 <printf+0x190>
      } else if(c == '%'){
 92f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 933:	75 17                	jne    94c <printf+0x168>
        putc(fd, c);
 935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 938:	0f be c0             	movsbl %al,%eax
 93b:	89 44 24 04          	mov    %eax,0x4(%esp)
 93f:	8b 45 08             	mov    0x8(%ebp),%eax
 942:	89 04 24             	mov    %eax,(%esp)
 945:	e8 c2 fd ff ff       	call   70c <putc>
 94a:	eb 28                	jmp    974 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 94c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 953:	00 
 954:	8b 45 08             	mov    0x8(%ebp),%eax
 957:	89 04 24             	mov    %eax,(%esp)
 95a:	e8 ad fd ff ff       	call   70c <putc>
        putc(fd, c);
 95f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 962:	0f be c0             	movsbl %al,%eax
 965:	89 44 24 04          	mov    %eax,0x4(%esp)
 969:	8b 45 08             	mov    0x8(%ebp),%eax
 96c:	89 04 24             	mov    %eax,(%esp)
 96f:	e8 98 fd ff ff       	call   70c <putc>
      }
      state = 0;
 974:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 97b:	ff 45 f0             	incl   -0x10(%ebp)
 97e:	8b 55 0c             	mov    0xc(%ebp),%edx
 981:	8b 45 f0             	mov    -0x10(%ebp),%eax
 984:	01 d0                	add    %edx,%eax
 986:	8a 00                	mov    (%eax),%al
 988:	84 c0                	test   %al,%al
 98a:	0f 85 76 fe ff ff    	jne    806 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 990:	c9                   	leave  
 991:	c3                   	ret    
 992:	66 90                	xchg   %ax,%ax

00000994 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 994:	55                   	push   %ebp
 995:	89 e5                	mov    %esp,%ebp
 997:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 99a:	8b 45 08             	mov    0x8(%ebp),%eax
 99d:	83 e8 08             	sub    $0x8,%eax
 9a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a3:	a1 dc 0e 00 00       	mov    0xedc,%eax
 9a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9ab:	eb 24                	jmp    9d1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b0:	8b 00                	mov    (%eax),%eax
 9b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9b5:	77 12                	ja     9c9 <free+0x35>
 9b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9bd:	77 24                	ja     9e3 <free+0x4f>
 9bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c2:	8b 00                	mov    (%eax),%eax
 9c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9c7:	77 1a                	ja     9e3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cc:	8b 00                	mov    (%eax),%eax
 9ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9d7:	76 d4                	jbe    9ad <free+0x19>
 9d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9dc:	8b 00                	mov    (%eax),%eax
 9de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9e1:	76 ca                	jbe    9ad <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 9e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e6:	8b 40 04             	mov    0x4(%eax),%eax
 9e9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f3:	01 c2                	add    %eax,%edx
 9f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f8:	8b 00                	mov    (%eax),%eax
 9fa:	39 c2                	cmp    %eax,%edx
 9fc:	75 24                	jne    a22 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a01:	8b 50 04             	mov    0x4(%eax),%edx
 a04:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a07:	8b 00                	mov    (%eax),%eax
 a09:	8b 40 04             	mov    0x4(%eax),%eax
 a0c:	01 c2                	add    %eax,%edx
 a0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a11:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a14:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a17:	8b 00                	mov    (%eax),%eax
 a19:	8b 10                	mov    (%eax),%edx
 a1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a1e:	89 10                	mov    %edx,(%eax)
 a20:	eb 0a                	jmp    a2c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a22:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a25:	8b 10                	mov    (%eax),%edx
 a27:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a2a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2f:	8b 40 04             	mov    0x4(%eax),%eax
 a32:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a39:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a3c:	01 d0                	add    %edx,%eax
 a3e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a41:	75 20                	jne    a63 <free+0xcf>
    p->s.size += bp->s.size;
 a43:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a46:	8b 50 04             	mov    0x4(%eax),%edx
 a49:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4c:	8b 40 04             	mov    0x4(%eax),%eax
 a4f:	01 c2                	add    %eax,%edx
 a51:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a54:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a57:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a5a:	8b 10                	mov    (%eax),%edx
 a5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5f:	89 10                	mov    %edx,(%eax)
 a61:	eb 08                	jmp    a6b <free+0xd7>
  } else
    p->s.ptr = bp;
 a63:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a66:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a69:	89 10                	mov    %edx,(%eax)
  freep = p;
 a6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6e:	a3 dc 0e 00 00       	mov    %eax,0xedc
}
 a73:	c9                   	leave  
 a74:	c3                   	ret    

00000a75 <morecore>:

static Header*
morecore(uint nu)
{
 a75:	55                   	push   %ebp
 a76:	89 e5                	mov    %esp,%ebp
 a78:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a7b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a82:	77 07                	ja     a8b <morecore+0x16>
    nu = 4096;
 a84:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a8b:	8b 45 08             	mov    0x8(%ebp),%eax
 a8e:	c1 e0 03             	shl    $0x3,%eax
 a91:	89 04 24             	mov    %eax,(%esp)
 a94:	e8 4b fc ff ff       	call   6e4 <sbrk>
 a99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a9c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 aa0:	75 07                	jne    aa9 <morecore+0x34>
    return 0;
 aa2:	b8 00 00 00 00       	mov    $0x0,%eax
 aa7:	eb 22                	jmp    acb <morecore+0x56>
  hp = (Header*)p;
 aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab2:	8b 55 08             	mov    0x8(%ebp),%edx
 ab5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 abb:	83 c0 08             	add    $0x8,%eax
 abe:	89 04 24             	mov    %eax,(%esp)
 ac1:	e8 ce fe ff ff       	call   994 <free>
  return freep;
 ac6:	a1 dc 0e 00 00       	mov    0xedc,%eax
}
 acb:	c9                   	leave  
 acc:	c3                   	ret    

00000acd <malloc>:

void*
malloc(uint nbytes)
{
 acd:	55                   	push   %ebp
 ace:	89 e5                	mov    %esp,%ebp
 ad0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ad3:	8b 45 08             	mov    0x8(%ebp),%eax
 ad6:	83 c0 07             	add    $0x7,%eax
 ad9:	c1 e8 03             	shr    $0x3,%eax
 adc:	40                   	inc    %eax
 add:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ae0:	a1 dc 0e 00 00       	mov    0xedc,%eax
 ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ae8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 aec:	75 23                	jne    b11 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 aee:	c7 45 f0 d4 0e 00 00 	movl   $0xed4,-0x10(%ebp)
 af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af8:	a3 dc 0e 00 00       	mov    %eax,0xedc
 afd:	a1 dc 0e 00 00       	mov    0xedc,%eax
 b02:	a3 d4 0e 00 00       	mov    %eax,0xed4
    base.s.size = 0;
 b07:	c7 05 d8 0e 00 00 00 	movl   $0x0,0xed8
 b0e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b14:	8b 00                	mov    (%eax),%eax
 b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1c:	8b 40 04             	mov    0x4(%eax),%eax
 b1f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b22:	72 4d                	jb     b71 <malloc+0xa4>
      if(p->s.size == nunits)
 b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b27:	8b 40 04             	mov    0x4(%eax),%eax
 b2a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b2d:	75 0c                	jne    b3b <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b32:	8b 10                	mov    (%eax),%edx
 b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b37:	89 10                	mov    %edx,(%eax)
 b39:	eb 26                	jmp    b61 <malloc+0x94>
      else {
        p->s.size -= nunits;
 b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3e:	8b 40 04             	mov    0x4(%eax),%eax
 b41:	89 c2                	mov    %eax,%edx
 b43:	2b 55 ec             	sub    -0x14(%ebp),%edx
 b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b49:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4f:	8b 40 04             	mov    0x4(%eax),%eax
 b52:	c1 e0 03             	shl    $0x3,%eax
 b55:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b5e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b64:	a3 dc 0e 00 00       	mov    %eax,0xedc
      return (void*)(p + 1);
 b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b6c:	83 c0 08             	add    $0x8,%eax
 b6f:	eb 38                	jmp    ba9 <malloc+0xdc>
    }
    if(p == freep)
 b71:	a1 dc 0e 00 00       	mov    0xedc,%eax
 b76:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b79:	75 1b                	jne    b96 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b7e:	89 04 24             	mov    %eax,(%esp)
 b81:	e8 ef fe ff ff       	call   a75 <morecore>
 b86:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b8d:	75 07                	jne    b96 <malloc+0xc9>
        return 0;
 b8f:	b8 00 00 00 00       	mov    $0x0,%eax
 b94:	eb 13                	jmp    ba9 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9f:	8b 00                	mov    (%eax),%eax
 ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ba4:	e9 70 ff ff ff       	jmp    b19 <malloc+0x4c>
}
 ba9:	c9                   	leave  
 baa:	c3                   	ret    
