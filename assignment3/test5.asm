
_test5:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	53                   	push   %ebx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	83 ec 20             	sub    $0x20,%esp
    int pid;

	printf(1,"allocationg a value in parent\n",getpid());
    100a:	e8 f4 06 00 00       	call   1703 <getpid>
    100f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1013:	c7 44 24 04 d8 1b 00 	movl   $0x1bd8,0x4(%esp)
    101a:	00 
    101b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1022:	e8 e4 07 00 00       	call   180b <printf>
	int* value = malloc(sizeof(int));
    1027:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
    102e:	e8 c4 0a 00 00       	call   1af7 <malloc>
    1033:	89 44 24 1c          	mov    %eax,0x1c(%esp)
	*value = 99999;
    1037:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    103b:	c7 00 9f 86 01 00    	movl   $0x1869f,(%eax)
	printf(1,"value's address: %p\n", value);
    1041:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1045:	89 44 24 08          	mov    %eax,0x8(%esp)
    1049:	c7 44 24 04 f7 1b 00 	movl   $0x1bf7,0x4(%esp)
    1050:	00 
    1051:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1058:	e8 ae 07 00 00       	call   180b <printf>
	printf(1,"value = %d\n",*value);
    105d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1061:	8b 00                	mov    (%eax),%eax
    1063:	89 44 24 08          	mov    %eax,0x8(%esp)
    1067:	c7 44 24 04 0c 1c 00 	movl   $0x1c0c,0x4(%esp)
    106e:	00 
    106f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1076:	e8 90 07 00 00       	call   180b <printf>

	printf(1,"Parent %d is forking a child using fork()\n",getpid());
    107b:	e8 83 06 00 00       	call   1703 <getpid>
    1080:	89 44 24 08          	mov    %eax,0x8(%esp)
    1084:	c7 44 24 04 18 1c 00 	movl   $0x1c18,0x4(%esp)
    108b:	00 
    108c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1093:	e8 73 07 00 00       	call   180b <printf>
	if (fork() == 0) {
    1098:	e8 de 05 00 00       	call   167b <fork>
    109d:	85 c0                	test   %eax,%eax
    109f:	75 53                	jne    10f4 <main+0xf4>
		printf(1, "child %d value's address is: %p\n", getpid(), value);
    10a1:	e8 5d 06 00 00       	call   1703 <getpid>
    10a6:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    10aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
    10ae:	89 44 24 08          	mov    %eax,0x8(%esp)
    10b2:	c7 44 24 04 44 1c 00 	movl   $0x1c44,0x4(%esp)
    10b9:	00 
    10ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10c1:	e8 45 07 00 00       	call   180b <printf>
		printf(1, "child %d is only sleeping, press ^p\n", getpid());
    10c6:	e8 38 06 00 00       	call   1703 <getpid>
    10cb:	89 44 24 08          	mov    %eax,0x8(%esp)
    10cf:	c7 44 24 04 68 1c 00 	movl   $0x1c68,0x4(%esp)
    10d6:	00 
    10d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10de:	e8 28 07 00 00       	call   180b <printf>
		sleep(500);
    10e3:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
    10ea:	e8 24 06 00 00       	call   1713 <sleep>
		/*goto done;*/
        exit();
    10ef:	e8 8f 05 00 00       	call   1683 <exit>
	} 

    pid = wait();
    10f4:	e8 92 05 00 00       	call   168b <wait>
    10f9:	89 44 24 18          	mov    %eax,0x18(%esp)
    printf(1,"\nchild %d is dead, let's continue\n\n",pid);
    10fd:	8b 44 24 18          	mov    0x18(%esp),%eax
    1101:	89 44 24 08          	mov    %eax,0x8(%esp)
    1105:	c7 44 24 04 90 1c 00 	movl   $0x1c90,0x4(%esp)
    110c:	00 
    110d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1114:	e8 f2 06 00 00       	call   180b <printf>
    sleep(100);
    1119:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
    1120:	e8 ee 05 00 00       	call   1713 <sleep>

    printf(1,"Parent %d is forking another child using cowfork()\n",getpid());
    1125:	e8 d9 05 00 00       	call   1703 <getpid>
    112a:	89 44 24 08          	mov    %eax,0x8(%esp)
    112e:	c7 44 24 04 b4 1c 00 	movl   $0x1cb4,0x4(%esp)
    1135:	00 
    1136:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    113d:	e8 c9 06 00 00       	call   180b <printf>
    if (cowfork() == 0) {
    1142:	e8 dc 05 00 00       	call   1723 <cowfork>
    1147:	85 c0                	test   %eax,%eax
    1149:	75 53                	jne    119e <main+0x19e>
        printf(1, "child %d value's address is: %p\n", getpid(), value);
    114b:	e8 b3 05 00 00       	call   1703 <getpid>
    1150:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    1154:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1158:	89 44 24 08          	mov    %eax,0x8(%esp)
    115c:	c7 44 24 04 44 1c 00 	movl   $0x1c44,0x4(%esp)
    1163:	00 
    1164:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    116b:	e8 9b 06 00 00       	call   180b <printf>
        printf(1, "child %d is only sleeping, press ^p\n", getpid());
    1170:	e8 8e 05 00 00       	call   1703 <getpid>
    1175:	89 44 24 08          	mov    %eax,0x8(%esp)
    1179:	c7 44 24 04 68 1c 00 	movl   $0x1c68,0x4(%esp)
    1180:	00 
    1181:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1188:	e8 7e 06 00 00       	call   180b <printf>
        sleep(500);
    118d:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
    1194:	e8 7a 05 00 00       	call   1713 <sleep>
        /*goto done;*/
        exit();
    1199:	e8 e5 04 00 00       	call   1683 <exit>
    }

    pid = wait();
    119e:	e8 e8 04 00 00       	call   168b <wait>
    11a3:	89 44 24 18          	mov    %eax,0x18(%esp)
    printf(1,"\nchild %d is dead, let's continue\n\n",pid);
    11a7:	8b 44 24 18          	mov    0x18(%esp),%eax
    11ab:	89 44 24 08          	mov    %eax,0x8(%esp)
    11af:	c7 44 24 04 90 1c 00 	movl   $0x1c90,0x4(%esp)
    11b6:	00 
    11b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11be:	e8 48 06 00 00       	call   180b <printf>
    sleep(100);
    11c3:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
    11ca:	e8 44 05 00 00       	call   1713 <sleep>

    printf(1,"Parent %d is forking another child using cowfork()\n",getpid());
    11cf:	e8 2f 05 00 00       	call   1703 <getpid>
    11d4:	89 44 24 08          	mov    %eax,0x8(%esp)
    11d8:	c7 44 24 04 b4 1c 00 	movl   $0x1cb4,0x4(%esp)
    11df:	00 
    11e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11e7:	e8 1f 06 00 00       	call   180b <printf>
    if (cowfork() == 0) {
    11ec:	e8 32 05 00 00       	call   1723 <cowfork>
    11f1:	85 c0                	test   %eax,%eax
    11f3:	0f 85 a9 00 00 00    	jne    12a2 <main+0x2a2>
        printf(1, "child %d value's address is: %p\n", getpid(), value);
    11f9:	e8 05 05 00 00       	call   1703 <getpid>
    11fe:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    1202:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1206:	89 44 24 08          	mov    %eax,0x8(%esp)
    120a:	c7 44 24 04 44 1c 00 	movl   $0x1c44,0x4(%esp)
    1211:	00 
    1212:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1219:	e8 ed 05 00 00       	call   180b <printf>
        *value = 11111;
    121e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1222:	c7 00 67 2b 00 00    	movl   $0x2b67,(%eax)
        printf(1, "child %d changed the value, now value = %d\n", getpid(),*value);
    1228:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    122c:	8b 18                	mov    (%eax),%ebx
    122e:	e8 d0 04 00 00       	call   1703 <getpid>
    1233:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    1237:	89 44 24 08          	mov    %eax,0x8(%esp)
    123b:	c7 44 24 04 e8 1c 00 	movl   $0x1ce8,0x4(%esp)
    1242:	00 
    1243:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    124a:	e8 bc 05 00 00       	call   180b <printf>
        printf(1, "child %d value's address is: %p\n", getpid(), value);
    124f:	e8 af 04 00 00       	call   1703 <getpid>
    1254:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    1258:	89 54 24 0c          	mov    %edx,0xc(%esp)
    125c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1260:	c7 44 24 04 44 1c 00 	movl   $0x1c44,0x4(%esp)
    1267:	00 
    1268:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    126f:	e8 97 05 00 00       	call   180b <printf>
        printf(1, "child %d is now sleeping, press ^p\n", getpid());
    1274:	e8 8a 04 00 00       	call   1703 <getpid>
    1279:	89 44 24 08          	mov    %eax,0x8(%esp)
    127d:	c7 44 24 04 14 1d 00 	movl   $0x1d14,0x4(%esp)
    1284:	00 
    1285:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    128c:	e8 7a 05 00 00       	call   180b <printf>
        sleep(500);
    1291:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
    1298:	e8 76 04 00 00       	call   1713 <sleep>
        /*goto done;*/
        exit();
    129d:	e8 e1 03 00 00       	call   1683 <exit>
    }

    pid = wait();
    12a2:	e8 e4 03 00 00       	call   168b <wait>
    12a7:	89 44 24 18          	mov    %eax,0x18(%esp)

    printf(1,"\nchild %d is dead, let's continue\n",pid);
    12ab:	8b 44 24 18          	mov    0x18(%esp),%eax
    12af:	89 44 24 08          	mov    %eax,0x8(%esp)
    12b3:	c7 44 24 04 38 1d 00 	movl   $0x1d38,0x4(%esp)
    12ba:	00 
    12bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12c2:	e8 44 05 00 00       	call   180b <printf>
    printf(1,"******Parent %d is forking 2 childs using cowfork()******\n",getpid());
    12c7:	e8 37 04 00 00       	call   1703 <getpid>
    12cc:	89 44 24 08          	mov    %eax,0x8(%esp)
    12d0:	c7 44 24 04 5c 1d 00 	movl   $0x1d5c,0x4(%esp)
    12d7:	00 
    12d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12df:	e8 27 05 00 00       	call   180b <printf>

    if ((pid = cowfork()) == 0) {
    12e4:	e8 3a 04 00 00       	call   1723 <cowfork>
    12e9:	89 44 24 18          	mov    %eax,0x18(%esp)
    12ed:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    12f2:	75 7d                	jne    1371 <main+0x371>
        printf(1, "child %d value's address is: %p\n", getpid(), value);
    12f4:	e8 0a 04 00 00       	call   1703 <getpid>
    12f9:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    12fd:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1301:	89 44 24 08          	mov    %eax,0x8(%esp)
    1305:	c7 44 24 04 44 1c 00 	movl   $0x1c44,0x4(%esp)
    130c:	00 
    130d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1314:	e8 f2 04 00 00       	call   180b <printf>
        *value = 22222;
    1319:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    131d:	c7 00 ce 56 00 00    	movl   $0x56ce,(%eax)
        printf(1, "child %d changed the value, now value = %d\n", getpid(),*value);
    1323:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1327:	8b 18                	mov    (%eax),%ebx
    1329:	e8 d5 03 00 00       	call   1703 <getpid>
    132e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    1332:	89 44 24 08          	mov    %eax,0x8(%esp)
    1336:	c7 44 24 04 e8 1c 00 	movl   $0x1ce8,0x4(%esp)
    133d:	00 
    133e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1345:	e8 c1 04 00 00       	call   180b <printf>
        printf(1, "child %d value's address is: %p\n", getpid(), value);
    134a:	e8 b4 03 00 00       	call   1703 <getpid>
    134f:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    1353:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1357:	89 44 24 08          	mov    %eax,0x8(%esp)
    135b:	c7 44 24 04 44 1c 00 	movl   $0x1c44,0x4(%esp)
    1362:	00 
    1363:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    136a:	e8 9c 04 00 00       	call   180b <printf>
        while(1)
        {}
    136f:	eb fe                	jmp    136f <main+0x36f>
        exit();
    }
    if (cowfork() == 0) {
    1371:	e8 ad 03 00 00       	call   1723 <cowfork>
    1376:	85 c0                	test   %eax,%eax
    1378:	75 3a                	jne    13b4 <main+0x3b4>

        printf(1, "child %d is now sleeping, press ^p\n", getpid());
    137a:	e8 84 03 00 00       	call   1703 <getpid>
    137f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1383:	c7 44 24 04 14 1d 00 	movl   $0x1d14,0x4(%esp)
    138a:	00 
    138b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1392:	e8 74 04 00 00       	call   180b <printf>
        sleep(500);
    1397:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
    139e:	e8 70 03 00 00       	call   1713 <sleep>
        kill(pid);
    13a3:	8b 44 24 18          	mov    0x18(%esp),%eax
    13a7:	89 04 24             	mov    %eax,(%esp)
    13aa:	e8 04 03 00 00       	call   16b3 <kill>
        exit();
    13af:	e8 cf 02 00 00       	call   1683 <exit>
    } 
    printf(1,"\nparent %d is wating for nothing\n",pid);
    13b4:	8b 44 24 18          	mov    0x18(%esp),%eax
    13b8:	89 44 24 08          	mov    %eax,0x8(%esp)
    13bc:	c7 44 24 04 98 1d 00 	movl   $0x1d98,0x4(%esp)
    13c3:	00 
    13c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13cb:	e8 3b 04 00 00       	call   180b <printf>
    wait();
    13d0:	e8 b6 02 00 00       	call   168b <wait>
    wait();
    13d5:	e8 b1 02 00 00       	call   168b <wait>

    printf(1,"\nchild %d is dead, let's finish\n",pid);
    13da:	8b 44 24 18          	mov    0x18(%esp),%eax
    13de:	89 44 24 08          	mov    %eax,0x8(%esp)
    13e2:	c7 44 24 04 bc 1d 00 	movl   $0x1dbc,0x4(%esp)
    13e9:	00 
    13ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13f1:	e8 15 04 00 00       	call   180b <printf>
    printf(1,"all kids are dead");
    13f6:	c7 44 24 04 dd 1d 00 	movl   $0x1ddd,0x4(%esp)
    13fd:	00 
    13fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1405:	e8 01 04 00 00       	call   180b <printf>
    sleep(200);
    140a:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
    1411:	e8 fd 02 00 00       	call   1713 <sleep>

    exit();
    1416:	e8 68 02 00 00       	call   1683 <exit>

0000141b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    141b:	55                   	push   %ebp
    141c:	89 e5                	mov    %esp,%ebp
    141e:	57                   	push   %edi
    141f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1420:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1423:	8b 55 10             	mov    0x10(%ebp),%edx
    1426:	8b 45 0c             	mov    0xc(%ebp),%eax
    1429:	89 cb                	mov    %ecx,%ebx
    142b:	89 df                	mov    %ebx,%edi
    142d:	89 d1                	mov    %edx,%ecx
    142f:	fc                   	cld    
    1430:	f3 aa                	rep stos %al,%es:(%edi)
    1432:	89 ca                	mov    %ecx,%edx
    1434:	89 fb                	mov    %edi,%ebx
    1436:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1439:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    143c:	5b                   	pop    %ebx
    143d:	5f                   	pop    %edi
    143e:	5d                   	pop    %ebp
    143f:	c3                   	ret    

00001440 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1440:	55                   	push   %ebp
    1441:	89 e5                	mov    %esp,%ebp
    1443:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1446:	8b 45 08             	mov    0x8(%ebp),%eax
    1449:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    144c:	90                   	nop
    144d:	8b 45 08             	mov    0x8(%ebp),%eax
    1450:	8d 50 01             	lea    0x1(%eax),%edx
    1453:	89 55 08             	mov    %edx,0x8(%ebp)
    1456:	8b 55 0c             	mov    0xc(%ebp),%edx
    1459:	8d 4a 01             	lea    0x1(%edx),%ecx
    145c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    145f:	0f b6 12             	movzbl (%edx),%edx
    1462:	88 10                	mov    %dl,(%eax)
    1464:	0f b6 00             	movzbl (%eax),%eax
    1467:	84 c0                	test   %al,%al
    1469:	75 e2                	jne    144d <strcpy+0xd>
    ;
  return os;
    146b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    146e:	c9                   	leave  
    146f:	c3                   	ret    

00001470 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1470:	55                   	push   %ebp
    1471:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1473:	eb 08                	jmp    147d <strcmp+0xd>
    p++, q++;
    1475:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1479:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    147d:	8b 45 08             	mov    0x8(%ebp),%eax
    1480:	0f b6 00             	movzbl (%eax),%eax
    1483:	84 c0                	test   %al,%al
    1485:	74 10                	je     1497 <strcmp+0x27>
    1487:	8b 45 08             	mov    0x8(%ebp),%eax
    148a:	0f b6 10             	movzbl (%eax),%edx
    148d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1490:	0f b6 00             	movzbl (%eax),%eax
    1493:	38 c2                	cmp    %al,%dl
    1495:	74 de                	je     1475 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1497:	8b 45 08             	mov    0x8(%ebp),%eax
    149a:	0f b6 00             	movzbl (%eax),%eax
    149d:	0f b6 d0             	movzbl %al,%edx
    14a0:	8b 45 0c             	mov    0xc(%ebp),%eax
    14a3:	0f b6 00             	movzbl (%eax),%eax
    14a6:	0f b6 c0             	movzbl %al,%eax
    14a9:	29 c2                	sub    %eax,%edx
    14ab:	89 d0                	mov    %edx,%eax
}
    14ad:	5d                   	pop    %ebp
    14ae:	c3                   	ret    

000014af <strlen>:

uint
strlen(char *s)
{
    14af:	55                   	push   %ebp
    14b0:	89 e5                	mov    %esp,%ebp
    14b2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    14b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    14bc:	eb 04                	jmp    14c2 <strlen+0x13>
    14be:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    14c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
    14c5:	8b 45 08             	mov    0x8(%ebp),%eax
    14c8:	01 d0                	add    %edx,%eax
    14ca:	0f b6 00             	movzbl (%eax),%eax
    14cd:	84 c0                	test   %al,%al
    14cf:	75 ed                	jne    14be <strlen+0xf>
    ;
  return n;
    14d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    14d4:	c9                   	leave  
    14d5:	c3                   	ret    

000014d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
    14d6:	55                   	push   %ebp
    14d7:	89 e5                	mov    %esp,%ebp
    14d9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    14dc:	8b 45 10             	mov    0x10(%ebp),%eax
    14df:	89 44 24 08          	mov    %eax,0x8(%esp)
    14e3:	8b 45 0c             	mov    0xc(%ebp),%eax
    14e6:	89 44 24 04          	mov    %eax,0x4(%esp)
    14ea:	8b 45 08             	mov    0x8(%ebp),%eax
    14ed:	89 04 24             	mov    %eax,(%esp)
    14f0:	e8 26 ff ff ff       	call   141b <stosb>
  return dst;
    14f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14f8:	c9                   	leave  
    14f9:	c3                   	ret    

000014fa <strchr>:

char*
strchr(const char *s, char c)
{
    14fa:	55                   	push   %ebp
    14fb:	89 e5                	mov    %esp,%ebp
    14fd:	83 ec 04             	sub    $0x4,%esp
    1500:	8b 45 0c             	mov    0xc(%ebp),%eax
    1503:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1506:	eb 14                	jmp    151c <strchr+0x22>
    if(*s == c)
    1508:	8b 45 08             	mov    0x8(%ebp),%eax
    150b:	0f b6 00             	movzbl (%eax),%eax
    150e:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1511:	75 05                	jne    1518 <strchr+0x1e>
      return (char*)s;
    1513:	8b 45 08             	mov    0x8(%ebp),%eax
    1516:	eb 13                	jmp    152b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1518:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    151c:	8b 45 08             	mov    0x8(%ebp),%eax
    151f:	0f b6 00             	movzbl (%eax),%eax
    1522:	84 c0                	test   %al,%al
    1524:	75 e2                	jne    1508 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1526:	b8 00 00 00 00       	mov    $0x0,%eax
}
    152b:	c9                   	leave  
    152c:	c3                   	ret    

0000152d <gets>:

char*
gets(char *buf, int max)
{
    152d:	55                   	push   %ebp
    152e:	89 e5                	mov    %esp,%ebp
    1530:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1533:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    153a:	eb 4c                	jmp    1588 <gets+0x5b>
    cc = read(0, &c, 1);
    153c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1543:	00 
    1544:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1547:	89 44 24 04          	mov    %eax,0x4(%esp)
    154b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1552:	e8 44 01 00 00       	call   169b <read>
    1557:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    155a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    155e:	7f 02                	jg     1562 <gets+0x35>
      break;
    1560:	eb 31                	jmp    1593 <gets+0x66>
    buf[i++] = c;
    1562:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1565:	8d 50 01             	lea    0x1(%eax),%edx
    1568:	89 55 f4             	mov    %edx,-0xc(%ebp)
    156b:	89 c2                	mov    %eax,%edx
    156d:	8b 45 08             	mov    0x8(%ebp),%eax
    1570:	01 c2                	add    %eax,%edx
    1572:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1576:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1578:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    157c:	3c 0a                	cmp    $0xa,%al
    157e:	74 13                	je     1593 <gets+0x66>
    1580:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1584:	3c 0d                	cmp    $0xd,%al
    1586:	74 0b                	je     1593 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1588:	8b 45 f4             	mov    -0xc(%ebp),%eax
    158b:	83 c0 01             	add    $0x1,%eax
    158e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1591:	7c a9                	jl     153c <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1593:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1596:	8b 45 08             	mov    0x8(%ebp),%eax
    1599:	01 d0                	add    %edx,%eax
    159b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    159e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    15a1:	c9                   	leave  
    15a2:	c3                   	ret    

000015a3 <stat>:

int
stat(char *n, struct stat *st)
{
    15a3:	55                   	push   %ebp
    15a4:	89 e5                	mov    %esp,%ebp
    15a6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    15a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    15b0:	00 
    15b1:	8b 45 08             	mov    0x8(%ebp),%eax
    15b4:	89 04 24             	mov    %eax,(%esp)
    15b7:	e8 07 01 00 00       	call   16c3 <open>
    15bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    15bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15c3:	79 07                	jns    15cc <stat+0x29>
    return -1;
    15c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    15ca:	eb 23                	jmp    15ef <stat+0x4c>
  r = fstat(fd, st);
    15cc:	8b 45 0c             	mov    0xc(%ebp),%eax
    15cf:	89 44 24 04          	mov    %eax,0x4(%esp)
    15d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15d6:	89 04 24             	mov    %eax,(%esp)
    15d9:	e8 fd 00 00 00       	call   16db <fstat>
    15de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    15e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15e4:	89 04 24             	mov    %eax,(%esp)
    15e7:	e8 bf 00 00 00       	call   16ab <close>
  return r;
    15ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    15ef:	c9                   	leave  
    15f0:	c3                   	ret    

000015f1 <atoi>:

int
atoi(const char *s)
{
    15f1:	55                   	push   %ebp
    15f2:	89 e5                	mov    %esp,%ebp
    15f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    15f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    15fe:	eb 25                	jmp    1625 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1600:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1603:	89 d0                	mov    %edx,%eax
    1605:	c1 e0 02             	shl    $0x2,%eax
    1608:	01 d0                	add    %edx,%eax
    160a:	01 c0                	add    %eax,%eax
    160c:	89 c1                	mov    %eax,%ecx
    160e:	8b 45 08             	mov    0x8(%ebp),%eax
    1611:	8d 50 01             	lea    0x1(%eax),%edx
    1614:	89 55 08             	mov    %edx,0x8(%ebp)
    1617:	0f b6 00             	movzbl (%eax),%eax
    161a:	0f be c0             	movsbl %al,%eax
    161d:	01 c8                	add    %ecx,%eax
    161f:	83 e8 30             	sub    $0x30,%eax
    1622:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1625:	8b 45 08             	mov    0x8(%ebp),%eax
    1628:	0f b6 00             	movzbl (%eax),%eax
    162b:	3c 2f                	cmp    $0x2f,%al
    162d:	7e 0a                	jle    1639 <atoi+0x48>
    162f:	8b 45 08             	mov    0x8(%ebp),%eax
    1632:	0f b6 00             	movzbl (%eax),%eax
    1635:	3c 39                	cmp    $0x39,%al
    1637:	7e c7                	jle    1600 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1639:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    163c:	c9                   	leave  
    163d:	c3                   	ret    

0000163e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    163e:	55                   	push   %ebp
    163f:	89 e5                	mov    %esp,%ebp
    1641:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1644:	8b 45 08             	mov    0x8(%ebp),%eax
    1647:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    164a:	8b 45 0c             	mov    0xc(%ebp),%eax
    164d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1650:	eb 17                	jmp    1669 <memmove+0x2b>
    *dst++ = *src++;
    1652:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1655:	8d 50 01             	lea    0x1(%eax),%edx
    1658:	89 55 fc             	mov    %edx,-0x4(%ebp)
    165b:	8b 55 f8             	mov    -0x8(%ebp),%edx
    165e:	8d 4a 01             	lea    0x1(%edx),%ecx
    1661:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1664:	0f b6 12             	movzbl (%edx),%edx
    1667:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1669:	8b 45 10             	mov    0x10(%ebp),%eax
    166c:	8d 50 ff             	lea    -0x1(%eax),%edx
    166f:	89 55 10             	mov    %edx,0x10(%ebp)
    1672:	85 c0                	test   %eax,%eax
    1674:	7f dc                	jg     1652 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1676:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1679:	c9                   	leave  
    167a:	c3                   	ret    

0000167b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    167b:	b8 01 00 00 00       	mov    $0x1,%eax
    1680:	cd 40                	int    $0x40
    1682:	c3                   	ret    

00001683 <exit>:
SYSCALL(exit)
    1683:	b8 02 00 00 00       	mov    $0x2,%eax
    1688:	cd 40                	int    $0x40
    168a:	c3                   	ret    

0000168b <wait>:
SYSCALL(wait)
    168b:	b8 03 00 00 00       	mov    $0x3,%eax
    1690:	cd 40                	int    $0x40
    1692:	c3                   	ret    

00001693 <pipe>:
SYSCALL(pipe)
    1693:	b8 04 00 00 00       	mov    $0x4,%eax
    1698:	cd 40                	int    $0x40
    169a:	c3                   	ret    

0000169b <read>:
SYSCALL(read)
    169b:	b8 05 00 00 00       	mov    $0x5,%eax
    16a0:	cd 40                	int    $0x40
    16a2:	c3                   	ret    

000016a3 <write>:
SYSCALL(write)
    16a3:	b8 10 00 00 00       	mov    $0x10,%eax
    16a8:	cd 40                	int    $0x40
    16aa:	c3                   	ret    

000016ab <close>:
SYSCALL(close)
    16ab:	b8 15 00 00 00       	mov    $0x15,%eax
    16b0:	cd 40                	int    $0x40
    16b2:	c3                   	ret    

000016b3 <kill>:
SYSCALL(kill)
    16b3:	b8 06 00 00 00       	mov    $0x6,%eax
    16b8:	cd 40                	int    $0x40
    16ba:	c3                   	ret    

000016bb <exec>:
SYSCALL(exec)
    16bb:	b8 07 00 00 00       	mov    $0x7,%eax
    16c0:	cd 40                	int    $0x40
    16c2:	c3                   	ret    

000016c3 <open>:
SYSCALL(open)
    16c3:	b8 0f 00 00 00       	mov    $0xf,%eax
    16c8:	cd 40                	int    $0x40
    16ca:	c3                   	ret    

000016cb <mknod>:
SYSCALL(mknod)
    16cb:	b8 11 00 00 00       	mov    $0x11,%eax
    16d0:	cd 40                	int    $0x40
    16d2:	c3                   	ret    

000016d3 <unlink>:
SYSCALL(unlink)
    16d3:	b8 12 00 00 00       	mov    $0x12,%eax
    16d8:	cd 40                	int    $0x40
    16da:	c3                   	ret    

000016db <fstat>:
SYSCALL(fstat)
    16db:	b8 08 00 00 00       	mov    $0x8,%eax
    16e0:	cd 40                	int    $0x40
    16e2:	c3                   	ret    

000016e3 <link>:
SYSCALL(link)
    16e3:	b8 13 00 00 00       	mov    $0x13,%eax
    16e8:	cd 40                	int    $0x40
    16ea:	c3                   	ret    

000016eb <mkdir>:
SYSCALL(mkdir)
    16eb:	b8 14 00 00 00       	mov    $0x14,%eax
    16f0:	cd 40                	int    $0x40
    16f2:	c3                   	ret    

000016f3 <chdir>:
SYSCALL(chdir)
    16f3:	b8 09 00 00 00       	mov    $0x9,%eax
    16f8:	cd 40                	int    $0x40
    16fa:	c3                   	ret    

000016fb <dup>:
SYSCALL(dup)
    16fb:	b8 0a 00 00 00       	mov    $0xa,%eax
    1700:	cd 40                	int    $0x40
    1702:	c3                   	ret    

00001703 <getpid>:
SYSCALL(getpid)
    1703:	b8 0b 00 00 00       	mov    $0xb,%eax
    1708:	cd 40                	int    $0x40
    170a:	c3                   	ret    

0000170b <sbrk>:
SYSCALL(sbrk)
    170b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1710:	cd 40                	int    $0x40
    1712:	c3                   	ret    

00001713 <sleep>:
SYSCALL(sleep)
    1713:	b8 0d 00 00 00       	mov    $0xd,%eax
    1718:	cd 40                	int    $0x40
    171a:	c3                   	ret    

0000171b <uptime>:
SYSCALL(uptime)
    171b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1720:	cd 40                	int    $0x40
    1722:	c3                   	ret    

00001723 <cowfork>:
SYSCALL(cowfork) //3.4
    1723:	b8 16 00 00 00       	mov    $0x16,%eax
    1728:	cd 40                	int    $0x40
    172a:	c3                   	ret    

0000172b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    172b:	55                   	push   %ebp
    172c:	89 e5                	mov    %esp,%ebp
    172e:	83 ec 18             	sub    $0x18,%esp
    1731:	8b 45 0c             	mov    0xc(%ebp),%eax
    1734:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1737:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    173e:	00 
    173f:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1742:	89 44 24 04          	mov    %eax,0x4(%esp)
    1746:	8b 45 08             	mov    0x8(%ebp),%eax
    1749:	89 04 24             	mov    %eax,(%esp)
    174c:	e8 52 ff ff ff       	call   16a3 <write>
}
    1751:	c9                   	leave  
    1752:	c3                   	ret    

00001753 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1753:	55                   	push   %ebp
    1754:	89 e5                	mov    %esp,%ebp
    1756:	56                   	push   %esi
    1757:	53                   	push   %ebx
    1758:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    175b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1762:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1766:	74 17                	je     177f <printint+0x2c>
    1768:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    176c:	79 11                	jns    177f <printint+0x2c>
    neg = 1;
    176e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1775:	8b 45 0c             	mov    0xc(%ebp),%eax
    1778:	f7 d8                	neg    %eax
    177a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    177d:	eb 06                	jmp    1785 <printint+0x32>
  } else {
    x = xx;
    177f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1782:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1785:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    178c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    178f:	8d 41 01             	lea    0x1(%ecx),%eax
    1792:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1795:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1798:	8b 45 ec             	mov    -0x14(%ebp),%eax
    179b:	ba 00 00 00 00       	mov    $0x0,%edx
    17a0:	f7 f3                	div    %ebx
    17a2:	89 d0                	mov    %edx,%eax
    17a4:	0f b6 80 3c 30 00 00 	movzbl 0x303c(%eax),%eax
    17ab:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    17af:	8b 75 10             	mov    0x10(%ebp),%esi
    17b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17b5:	ba 00 00 00 00       	mov    $0x0,%edx
    17ba:	f7 f6                	div    %esi
    17bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    17bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    17c3:	75 c7                	jne    178c <printint+0x39>
  if(neg)
    17c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    17c9:	74 10                	je     17db <printint+0x88>
    buf[i++] = '-';
    17cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ce:	8d 50 01             	lea    0x1(%eax),%edx
    17d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
    17d4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    17d9:	eb 1f                	jmp    17fa <printint+0xa7>
    17db:	eb 1d                	jmp    17fa <printint+0xa7>
    putc(fd, buf[i]);
    17dd:	8d 55 dc             	lea    -0x24(%ebp),%edx
    17e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e3:	01 d0                	add    %edx,%eax
    17e5:	0f b6 00             	movzbl (%eax),%eax
    17e8:	0f be c0             	movsbl %al,%eax
    17eb:	89 44 24 04          	mov    %eax,0x4(%esp)
    17ef:	8b 45 08             	mov    0x8(%ebp),%eax
    17f2:	89 04 24             	mov    %eax,(%esp)
    17f5:	e8 31 ff ff ff       	call   172b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    17fa:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    17fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1802:	79 d9                	jns    17dd <printint+0x8a>
    putc(fd, buf[i]);
}
    1804:	83 c4 30             	add    $0x30,%esp
    1807:	5b                   	pop    %ebx
    1808:	5e                   	pop    %esi
    1809:	5d                   	pop    %ebp
    180a:	c3                   	ret    

0000180b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    180b:	55                   	push   %ebp
    180c:	89 e5                	mov    %esp,%ebp
    180e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1811:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1818:	8d 45 0c             	lea    0xc(%ebp),%eax
    181b:	83 c0 04             	add    $0x4,%eax
    181e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1821:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1828:	e9 7c 01 00 00       	jmp    19a9 <printf+0x19e>
    c = fmt[i] & 0xff;
    182d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1830:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1833:	01 d0                	add    %edx,%eax
    1835:	0f b6 00             	movzbl (%eax),%eax
    1838:	0f be c0             	movsbl %al,%eax
    183b:	25 ff 00 00 00       	and    $0xff,%eax
    1840:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1843:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1847:	75 2c                	jne    1875 <printf+0x6a>
      if(c == '%'){
    1849:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    184d:	75 0c                	jne    185b <printf+0x50>
        state = '%';
    184f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1856:	e9 4a 01 00 00       	jmp    19a5 <printf+0x19a>
      } else {
        putc(fd, c);
    185b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    185e:	0f be c0             	movsbl %al,%eax
    1861:	89 44 24 04          	mov    %eax,0x4(%esp)
    1865:	8b 45 08             	mov    0x8(%ebp),%eax
    1868:	89 04 24             	mov    %eax,(%esp)
    186b:	e8 bb fe ff ff       	call   172b <putc>
    1870:	e9 30 01 00 00       	jmp    19a5 <printf+0x19a>
      }
    } else if(state == '%'){
    1875:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1879:	0f 85 26 01 00 00    	jne    19a5 <printf+0x19a>
      if(c == 'd'){
    187f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1883:	75 2d                	jne    18b2 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1885:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1888:	8b 00                	mov    (%eax),%eax
    188a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1891:	00 
    1892:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1899:	00 
    189a:	89 44 24 04          	mov    %eax,0x4(%esp)
    189e:	8b 45 08             	mov    0x8(%ebp),%eax
    18a1:	89 04 24             	mov    %eax,(%esp)
    18a4:	e8 aa fe ff ff       	call   1753 <printint>
        ap++;
    18a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    18ad:	e9 ec 00 00 00       	jmp    199e <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    18b2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    18b6:	74 06                	je     18be <printf+0xb3>
    18b8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    18bc:	75 2d                	jne    18eb <printf+0xe0>
        printint(fd, *ap, 16, 0);
    18be:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18c1:	8b 00                	mov    (%eax),%eax
    18c3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    18ca:	00 
    18cb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    18d2:	00 
    18d3:	89 44 24 04          	mov    %eax,0x4(%esp)
    18d7:	8b 45 08             	mov    0x8(%ebp),%eax
    18da:	89 04 24             	mov    %eax,(%esp)
    18dd:	e8 71 fe ff ff       	call   1753 <printint>
        ap++;
    18e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    18e6:	e9 b3 00 00 00       	jmp    199e <printf+0x193>
      } else if(c == 's'){
    18eb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    18ef:	75 45                	jne    1936 <printf+0x12b>
        s = (char*)*ap;
    18f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18f4:	8b 00                	mov    (%eax),%eax
    18f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    18f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    18fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1901:	75 09                	jne    190c <printf+0x101>
          s = "(null)";
    1903:	c7 45 f4 ef 1d 00 00 	movl   $0x1def,-0xc(%ebp)
        while(*s != 0){
    190a:	eb 1e                	jmp    192a <printf+0x11f>
    190c:	eb 1c                	jmp    192a <printf+0x11f>
          putc(fd, *s);
    190e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1911:	0f b6 00             	movzbl (%eax),%eax
    1914:	0f be c0             	movsbl %al,%eax
    1917:	89 44 24 04          	mov    %eax,0x4(%esp)
    191b:	8b 45 08             	mov    0x8(%ebp),%eax
    191e:	89 04 24             	mov    %eax,(%esp)
    1921:	e8 05 fe ff ff       	call   172b <putc>
          s++;
    1926:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    192a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    192d:	0f b6 00             	movzbl (%eax),%eax
    1930:	84 c0                	test   %al,%al
    1932:	75 da                	jne    190e <printf+0x103>
    1934:	eb 68                	jmp    199e <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1936:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    193a:	75 1d                	jne    1959 <printf+0x14e>
        putc(fd, *ap);
    193c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    193f:	8b 00                	mov    (%eax),%eax
    1941:	0f be c0             	movsbl %al,%eax
    1944:	89 44 24 04          	mov    %eax,0x4(%esp)
    1948:	8b 45 08             	mov    0x8(%ebp),%eax
    194b:	89 04 24             	mov    %eax,(%esp)
    194e:	e8 d8 fd ff ff       	call   172b <putc>
        ap++;
    1953:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1957:	eb 45                	jmp    199e <printf+0x193>
      } else if(c == '%'){
    1959:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    195d:	75 17                	jne    1976 <printf+0x16b>
        putc(fd, c);
    195f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1962:	0f be c0             	movsbl %al,%eax
    1965:	89 44 24 04          	mov    %eax,0x4(%esp)
    1969:	8b 45 08             	mov    0x8(%ebp),%eax
    196c:	89 04 24             	mov    %eax,(%esp)
    196f:	e8 b7 fd ff ff       	call   172b <putc>
    1974:	eb 28                	jmp    199e <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1976:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    197d:	00 
    197e:	8b 45 08             	mov    0x8(%ebp),%eax
    1981:	89 04 24             	mov    %eax,(%esp)
    1984:	e8 a2 fd ff ff       	call   172b <putc>
        putc(fd, c);
    1989:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    198c:	0f be c0             	movsbl %al,%eax
    198f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1993:	8b 45 08             	mov    0x8(%ebp),%eax
    1996:	89 04 24             	mov    %eax,(%esp)
    1999:	e8 8d fd ff ff       	call   172b <putc>
      }
      state = 0;
    199e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    19a5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    19a9:	8b 55 0c             	mov    0xc(%ebp),%edx
    19ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19af:	01 d0                	add    %edx,%eax
    19b1:	0f b6 00             	movzbl (%eax),%eax
    19b4:	84 c0                	test   %al,%al
    19b6:	0f 85 71 fe ff ff    	jne    182d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    19bc:	c9                   	leave  
    19bd:	c3                   	ret    

000019be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    19be:	55                   	push   %ebp
    19bf:	89 e5                	mov    %esp,%ebp
    19c1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    19c4:	8b 45 08             	mov    0x8(%ebp),%eax
    19c7:	83 e8 08             	sub    $0x8,%eax
    19ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    19cd:	a1 58 30 00 00       	mov    0x3058,%eax
    19d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    19d5:	eb 24                	jmp    19fb <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    19d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19da:	8b 00                	mov    (%eax),%eax
    19dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    19df:	77 12                	ja     19f3 <free+0x35>
    19e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    19e7:	77 24                	ja     1a0d <free+0x4f>
    19e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19ec:	8b 00                	mov    (%eax),%eax
    19ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19f1:	77 1a                	ja     1a0d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    19f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19f6:	8b 00                	mov    (%eax),%eax
    19f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    19fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19fe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1a01:	76 d4                	jbe    19d7 <free+0x19>
    1a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a06:	8b 00                	mov    (%eax),%eax
    1a08:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1a0b:	76 ca                	jbe    19d7 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1a0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a10:	8b 40 04             	mov    0x4(%eax),%eax
    1a13:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1a1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a1d:	01 c2                	add    %eax,%edx
    1a1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a22:	8b 00                	mov    (%eax),%eax
    1a24:	39 c2                	cmp    %eax,%edx
    1a26:	75 24                	jne    1a4c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1a28:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a2b:	8b 50 04             	mov    0x4(%eax),%edx
    1a2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a31:	8b 00                	mov    (%eax),%eax
    1a33:	8b 40 04             	mov    0x4(%eax),%eax
    1a36:	01 c2                	add    %eax,%edx
    1a38:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a3b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1a3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a41:	8b 00                	mov    (%eax),%eax
    1a43:	8b 10                	mov    (%eax),%edx
    1a45:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a48:	89 10                	mov    %edx,(%eax)
    1a4a:	eb 0a                	jmp    1a56 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1a4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a4f:	8b 10                	mov    (%eax),%edx
    1a51:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a54:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1a56:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a59:	8b 40 04             	mov    0x4(%eax),%eax
    1a5c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1a63:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a66:	01 d0                	add    %edx,%eax
    1a68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1a6b:	75 20                	jne    1a8d <free+0xcf>
    p->s.size += bp->s.size;
    1a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a70:	8b 50 04             	mov    0x4(%eax),%edx
    1a73:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a76:	8b 40 04             	mov    0x4(%eax),%eax
    1a79:	01 c2                	add    %eax,%edx
    1a7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a7e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1a81:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a84:	8b 10                	mov    (%eax),%edx
    1a86:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a89:	89 10                	mov    %edx,(%eax)
    1a8b:	eb 08                	jmp    1a95 <free+0xd7>
  } else
    p->s.ptr = bp;
    1a8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a90:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1a93:	89 10                	mov    %edx,(%eax)
  freep = p;
    1a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a98:	a3 58 30 00 00       	mov    %eax,0x3058
}
    1a9d:	c9                   	leave  
    1a9e:	c3                   	ret    

00001a9f <morecore>:

static Header*
morecore(uint nu)
{
    1a9f:	55                   	push   %ebp
    1aa0:	89 e5                	mov    %esp,%ebp
    1aa2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1aa5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1aac:	77 07                	ja     1ab5 <morecore+0x16>
    nu = 4096;
    1aae:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1ab5:	8b 45 08             	mov    0x8(%ebp),%eax
    1ab8:	c1 e0 03             	shl    $0x3,%eax
    1abb:	89 04 24             	mov    %eax,(%esp)
    1abe:	e8 48 fc ff ff       	call   170b <sbrk>
    1ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1ac6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1aca:	75 07                	jne    1ad3 <morecore+0x34>
    return 0;
    1acc:	b8 00 00 00 00       	mov    $0x0,%eax
    1ad1:	eb 22                	jmp    1af5 <morecore+0x56>
  hp = (Header*)p;
    1ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1adc:	8b 55 08             	mov    0x8(%ebp),%edx
    1adf:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ae5:	83 c0 08             	add    $0x8,%eax
    1ae8:	89 04 24             	mov    %eax,(%esp)
    1aeb:	e8 ce fe ff ff       	call   19be <free>
  return freep;
    1af0:	a1 58 30 00 00       	mov    0x3058,%eax
}
    1af5:	c9                   	leave  
    1af6:	c3                   	ret    

00001af7 <malloc>:

void*
malloc(uint nbytes)
{
    1af7:	55                   	push   %ebp
    1af8:	89 e5                	mov    %esp,%ebp
    1afa:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1afd:	8b 45 08             	mov    0x8(%ebp),%eax
    1b00:	83 c0 07             	add    $0x7,%eax
    1b03:	c1 e8 03             	shr    $0x3,%eax
    1b06:	83 c0 01             	add    $0x1,%eax
    1b09:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1b0c:	a1 58 30 00 00       	mov    0x3058,%eax
    1b11:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1b14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1b18:	75 23                	jne    1b3d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1b1a:	c7 45 f0 50 30 00 00 	movl   $0x3050,-0x10(%ebp)
    1b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b24:	a3 58 30 00 00       	mov    %eax,0x3058
    1b29:	a1 58 30 00 00       	mov    0x3058,%eax
    1b2e:	a3 50 30 00 00       	mov    %eax,0x3050
    base.s.size = 0;
    1b33:	c7 05 54 30 00 00 00 	movl   $0x0,0x3054
    1b3a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b40:	8b 00                	mov    (%eax),%eax
    1b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b48:	8b 40 04             	mov    0x4(%eax),%eax
    1b4b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1b4e:	72 4d                	jb     1b9d <malloc+0xa6>
      if(p->s.size == nunits)
    1b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b53:	8b 40 04             	mov    0x4(%eax),%eax
    1b56:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1b59:	75 0c                	jne    1b67 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b5e:	8b 10                	mov    (%eax),%edx
    1b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b63:	89 10                	mov    %edx,(%eax)
    1b65:	eb 26                	jmp    1b8d <malloc+0x96>
      else {
        p->s.size -= nunits;
    1b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b6a:	8b 40 04             	mov    0x4(%eax),%eax
    1b6d:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1b70:	89 c2                	mov    %eax,%edx
    1b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b75:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b7b:	8b 40 04             	mov    0x4(%eax),%eax
    1b7e:	c1 e0 03             	shl    $0x3,%eax
    1b81:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b87:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1b8a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b90:	a3 58 30 00 00       	mov    %eax,0x3058
      return (void*)(p + 1);
    1b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b98:	83 c0 08             	add    $0x8,%eax
    1b9b:	eb 38                	jmp    1bd5 <malloc+0xde>
    }
    if(p == freep)
    1b9d:	a1 58 30 00 00       	mov    0x3058,%eax
    1ba2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1ba5:	75 1b                	jne    1bc2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1baa:	89 04 24             	mov    %eax,(%esp)
    1bad:	e8 ed fe ff ff       	call   1a9f <morecore>
    1bb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1bb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1bb9:	75 07                	jne    1bc2 <malloc+0xcb>
        return 0;
    1bbb:	b8 00 00 00 00       	mov    $0x0,%eax
    1bc0:	eb 13                	jmp    1bd5 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bcb:	8b 00                	mov    (%eax),%eax
    1bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1bd0:	e9 70 ff ff ff       	jmp    1b45 <malloc+0x4e>
}
    1bd5:	c9                   	leave  
    1bd6:	c3                   	ret    
