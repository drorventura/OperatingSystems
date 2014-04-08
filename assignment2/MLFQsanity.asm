
_MLFQsanity:     file format elf32-i386


Disassembly of section .text:

00000000 <mlfqSanity>:

int Fibonacci(int n);

    void
mlfqSanity()
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	81 ec f0 01 00 00    	sub    $0x1f0,%esp
        int turnArroundTime;
    };

    struct childData childPid[20];

    int i,j,l,t=0;
   b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    int AVGwTime = 0;
  12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    int AVGrTime = 0;
  19:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    int AVGturnAroungTime = 0;
  20:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

    int AVGwTimeG0 = 0;
  27:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
    int AVGrTimeG0 = 0;
  2e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    int AVGturnAroungTimeG0 = 0;
  35:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)

    int AVGwTimeG1 = 0;
  3c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
    int AVGrTimeG1 = 0;
  43:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
    int AVGturnAroungTimeG1 = 0;
  4a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)


    for(i = 0 ; i < 20 ; i++)
  51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  58:	e9 94 00 00 00       	jmp    f1 <mlfqSanity+0xf1>
    {
        if(!fork())
  5d:	e8 d6 08 00 00       	call   938 <fork>
  62:	85 c0                	test   %eax,%eax
  64:	0f 85 84 00 00 00    	jne    ee <mlfqSanity+0xee>
        {
            if (getpid() % 2 == 0){         // time-consuming
  6a:	e8 51 09 00 00       	call   9c0 <getpid>
  6f:	83 e0 01             	and    $0x1,%eax
  72:	85 c0                	test   %eax,%eax
  74:	75 0e                	jne    84 <mlfqSanity+0x84>
                Fibonacci(20);}
  76:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
  7d:	e8 61 05 00 00       	call   5e3 <Fibonacci>
  82:	eb 2c                	jmp    b0 <mlfqSanity+0xb0>

            else {if (getpid() % 2 == 1)    // I/O system call
  84:	e8 37 09 00 00       	call   9c0 <getpid>
  89:	25 01 00 00 80       	and    $0x80000001,%eax
  8e:	85 c0                	test   %eax,%eax
  90:	79 05                	jns    97 <mlfqSanity+0x97>
  92:	48                   	dec    %eax
  93:	83 c8 fe             	or     $0xfffffffe,%eax
  96:	40                   	inc    %eax
  97:	83 f8 01             	cmp    $0x1,%eax
  9a:	75 14                	jne    b0 <mlfqSanity+0xb0>
                printf(2,"Calling I/O system call...\n");
  9c:	c7 44 24 04 90 0e 00 	movl   $0xe90,0x4(%esp)
  a3:	00 
  a4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  ab:	e8 18 0a 00 00       	call   ac8 <printf>
            }

            // 500 printing for each child
            for(j = 0 ; j < N ; j++){
  b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  b7:	eb 27                	jmp    e0 <mlfqSanity+0xe0>
                printf(2, "child <%d> prints for the <%d> time\n", getpid(), j);
  b9:	e8 02 09 00 00       	call   9c0 <getpid>
  be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  c1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  c9:	c7 44 24 04 ac 0e 00 	movl   $0xeac,0x4(%esp)
  d0:	00 
  d1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  d8:	e8 eb 09 00 00       	call   ac8 <printf>
            else {if (getpid() % 2 == 1)    // I/O system call
                printf(2,"Calling I/O system call...\n");
            }

            // 500 printing for each child
            for(j = 0 ; j < N ; j++){
  dd:	ff 45 f0             	incl   -0x10(%ebp)
  e0:	81 7d f0 f3 01 00 00 	cmpl   $0x1f3,-0x10(%ebp)
  e7:	7e d0                	jle    b9 <mlfqSanity+0xb9>
                printf(2, "child <%d> prints for the <%d> time\n", getpid(), j);
            }
            exit();
  e9:	e8 52 08 00 00       	call   940 <exit>
    int AVGwTimeG1 = 0;
    int AVGrTimeG1 = 0;
    int AVGturnAroungTimeG1 = 0;


    for(i = 0 ; i < 20 ; i++)
  ee:	ff 45 f4             	incl   -0xc(%ebp)
  f1:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  f5:	0f 8e 62 ff ff ff    	jle    5d <mlfqSanity+0x5d>
            exit();
        }
    }

    // update to all children thire data
    while((childPid[t].pid = wait2( &(childPid[t].wTime),
  fb:	e9 b8 01 00 00       	jmp    2b8 <mlfqSanity+0x2b8>
                    &(childPid[t].rTime),
                    &(childPid[t].ioTime))) > 0)
    {
        // updating turnArroundTime for a child
        childPid[t].turnArroundTime =   childPid[t].wTime + 
 100:	8b 55 e8             	mov    -0x18(%ebp),%edx
 103:	89 d0                	mov    %edx,%eax
 105:	c1 e0 02             	shl    $0x2,%eax
 108:	01 d0                	add    %edx,%eax
 10a:	c1 e0 02             	shl    $0x2,%eax
 10d:	8d 55 f8             	lea    -0x8(%ebp),%edx
 110:	01 d0                	add    %edx,%eax
 112:	2d c0 01 00 00       	sub    $0x1c0,%eax
 117:	8b 08                	mov    (%eax),%ecx
            childPid[t].rTime + 
 119:	8b 55 e8             	mov    -0x18(%ebp),%edx
 11c:	89 d0                	mov    %edx,%eax
 11e:	c1 e0 02             	shl    $0x2,%eax
 121:	01 d0                	add    %edx,%eax
 123:	c1 e0 02             	shl    $0x2,%eax
 126:	8d 75 f8             	lea    -0x8(%ebp),%esi
 129:	01 f0                	add    %esi,%eax
 12b:	2d bc 01 00 00       	sub    $0x1bc,%eax
 130:	8b 00                	mov    (%eax),%eax
    while((childPid[t].pid = wait2( &(childPid[t].wTime),
                    &(childPid[t].rTime),
                    &(childPid[t].ioTime))) > 0)
    {
        // updating turnArroundTime for a child
        childPid[t].turnArroundTime =   childPid[t].wTime + 
 132:	01 c1                	add    %eax,%ecx
            childPid[t].rTime + 
            childPid[t].ioTime;
 134:	8b 55 e8             	mov    -0x18(%ebp),%edx
 137:	89 d0                	mov    %edx,%eax
 139:	c1 e0 02             	shl    $0x2,%eax
 13c:	01 d0                	add    %edx,%eax
 13e:	c1 e0 02             	shl    $0x2,%eax
 141:	8d 55 f8             	lea    -0x8(%ebp),%edx
 144:	01 d0                	add    %edx,%eax
 146:	2d b8 01 00 00       	sub    $0x1b8,%eax
 14b:	8b 00                	mov    (%eax),%eax
                    &(childPid[t].rTime),
                    &(childPid[t].ioTime))) > 0)
    {
        // updating turnArroundTime for a child
        childPid[t].turnArroundTime =   childPid[t].wTime + 
            childPid[t].rTime + 
 14d:	01 c1                	add    %eax,%ecx
    while((childPid[t].pid = wait2( &(childPid[t].wTime),
                    &(childPid[t].rTime),
                    &(childPid[t].ioTime))) > 0)
    {
        // updating turnArroundTime for a child
        childPid[t].turnArroundTime =   childPid[t].wTime + 
 14f:	8b 55 e8             	mov    -0x18(%ebp),%edx
 152:	89 d0                	mov    %edx,%eax
 154:	c1 e0 02             	shl    $0x2,%eax
 157:	01 d0                	add    %edx,%eax
 159:	c1 e0 02             	shl    $0x2,%eax
 15c:	8d 75 f8             	lea    -0x8(%ebp),%esi
 15f:	01 f0                	add    %esi,%eax
 161:	2d b4 01 00 00       	sub    $0x1b4,%eax
 166:	89 08                	mov    %ecx,(%eax)
            childPid[t].rTime + 
            childPid[t].ioTime;

        // updating Averege data to all Childrens
        AVGwTime            += childPid[t].wTime;
 168:	8b 55 e8             	mov    -0x18(%ebp),%edx
 16b:	89 d0                	mov    %edx,%eax
 16d:	c1 e0 02             	shl    $0x2,%eax
 170:	01 d0                	add    %edx,%eax
 172:	c1 e0 02             	shl    $0x2,%eax
 175:	8d 55 f8             	lea    -0x8(%ebp),%edx
 178:	01 d0                	add    %edx,%eax
 17a:	2d c0 01 00 00       	sub    $0x1c0,%eax
 17f:	8b 00                	mov    (%eax),%eax
 181:	01 45 e4             	add    %eax,-0x1c(%ebp)
        AVGrTime            += childPid[t].rTime;
 184:	8b 55 e8             	mov    -0x18(%ebp),%edx
 187:	89 d0                	mov    %edx,%eax
 189:	c1 e0 02             	shl    $0x2,%eax
 18c:	01 d0                	add    %edx,%eax
 18e:	c1 e0 02             	shl    $0x2,%eax
 191:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 194:	01 c8                	add    %ecx,%eax
 196:	2d bc 01 00 00       	sub    $0x1bc,%eax
 19b:	8b 00                	mov    (%eax),%eax
 19d:	01 45 e0             	add    %eax,-0x20(%ebp)
        AVGturnAroungTime   += childPid[t].turnArroundTime;
 1a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
 1a3:	89 d0                	mov    %edx,%eax
 1a5:	c1 e0 02             	shl    $0x2,%eax
 1a8:	01 d0                	add    %edx,%eax
 1aa:	c1 e0 02             	shl    $0x2,%eax
 1ad:	8d 75 f8             	lea    -0x8(%ebp),%esi
 1b0:	01 f0                	add    %esi,%eax
 1b2:	2d b4 01 00 00       	sub    $0x1b4,%eax
 1b7:	8b 00                	mov    (%eax),%eax
 1b9:	01 45 dc             	add    %eax,-0x24(%ebp)

        // updating Averege data per % Group
        if(childPid[t].pid % 2 == 0)
 1bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
 1bf:	89 d0                	mov    %edx,%eax
 1c1:	c1 e0 02             	shl    $0x2,%eax
 1c4:	01 d0                	add    %edx,%eax
 1c6:	c1 e0 02             	shl    $0x2,%eax
 1c9:	8d 55 f8             	lea    -0x8(%ebp),%edx
 1cc:	01 d0                	add    %edx,%eax
 1ce:	2d c4 01 00 00       	sub    $0x1c4,%eax
 1d3:	8b 00                	mov    (%eax),%eax
 1d5:	83 e0 01             	and    $0x1,%eax
 1d8:	85 c0                	test   %eax,%eax
 1da:	75 59                	jne    235 <mlfqSanity+0x235>
        {
            AVGwTimeG0            += childPid[t].wTime;
 1dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
 1df:	89 d0                	mov    %edx,%eax
 1e1:	c1 e0 02             	shl    $0x2,%eax
 1e4:	01 d0                	add    %edx,%eax
 1e6:	c1 e0 02             	shl    $0x2,%eax
 1e9:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 1ec:	01 c8                	add    %ecx,%eax
 1ee:	2d c0 01 00 00       	sub    $0x1c0,%eax
 1f3:	8b 00                	mov    (%eax),%eax
 1f5:	01 45 d8             	add    %eax,-0x28(%ebp)
            AVGrTimeG0            += childPid[t].rTime;
 1f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
 1fb:	89 d0                	mov    %edx,%eax
 1fd:	c1 e0 02             	shl    $0x2,%eax
 200:	01 d0                	add    %edx,%eax
 202:	c1 e0 02             	shl    $0x2,%eax
 205:	8d 75 f8             	lea    -0x8(%ebp),%esi
 208:	01 f0                	add    %esi,%eax
 20a:	2d bc 01 00 00       	sub    $0x1bc,%eax
 20f:	8b 00                	mov    (%eax),%eax
 211:	01 45 d4             	add    %eax,-0x2c(%ebp)
            AVGturnAroungTimeG0   += childPid[t].turnArroundTime;
 214:	8b 55 e8             	mov    -0x18(%ebp),%edx
 217:	89 d0                	mov    %edx,%eax
 219:	c1 e0 02             	shl    $0x2,%eax
 21c:	01 d0                	add    %edx,%eax
 21e:	c1 e0 02             	shl    $0x2,%eax
 221:	8d 55 f8             	lea    -0x8(%ebp),%edx
 224:	01 d0                	add    %edx,%eax
 226:	2d b4 01 00 00       	sub    $0x1b4,%eax
 22b:	8b 00                	mov    (%eax),%eax
 22d:	01 45 d0             	add    %eax,-0x30(%ebp)
 230:	e9 80 00 00 00       	jmp    2b5 <mlfqSanity+0x2b5>
        }
        else if (childPid[t].pid % 2 == 1)
 235:	8b 55 e8             	mov    -0x18(%ebp),%edx
 238:	89 d0                	mov    %edx,%eax
 23a:	c1 e0 02             	shl    $0x2,%eax
 23d:	01 d0                	add    %edx,%eax
 23f:	c1 e0 02             	shl    $0x2,%eax
 242:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 245:	01 c8                	add    %ecx,%eax
 247:	2d c4 01 00 00       	sub    $0x1c4,%eax
 24c:	8b 00                	mov    (%eax),%eax
 24e:	25 01 00 00 80       	and    $0x80000001,%eax
 253:	85 c0                	test   %eax,%eax
 255:	79 05                	jns    25c <mlfqSanity+0x25c>
 257:	48                   	dec    %eax
 258:	83 c8 fe             	or     $0xfffffffe,%eax
 25b:	40                   	inc    %eax
 25c:	83 f8 01             	cmp    $0x1,%eax
 25f:	75 54                	jne    2b5 <mlfqSanity+0x2b5>
        {
            AVGwTimeG1            += childPid[t].wTime;
 261:	8b 55 e8             	mov    -0x18(%ebp),%edx
 264:	89 d0                	mov    %edx,%eax
 266:	c1 e0 02             	shl    $0x2,%eax
 269:	01 d0                	add    %edx,%eax
 26b:	c1 e0 02             	shl    $0x2,%eax
 26e:	8d 75 f8             	lea    -0x8(%ebp),%esi
 271:	01 f0                	add    %esi,%eax
 273:	2d c0 01 00 00       	sub    $0x1c0,%eax
 278:	8b 00                	mov    (%eax),%eax
 27a:	01 45 cc             	add    %eax,-0x34(%ebp)
            AVGrTimeG1            += childPid[t].rTime;
 27d:	8b 55 e8             	mov    -0x18(%ebp),%edx
 280:	89 d0                	mov    %edx,%eax
 282:	c1 e0 02             	shl    $0x2,%eax
 285:	01 d0                	add    %edx,%eax
 287:	c1 e0 02             	shl    $0x2,%eax
 28a:	8d 55 f8             	lea    -0x8(%ebp),%edx
 28d:	01 d0                	add    %edx,%eax
 28f:	2d bc 01 00 00       	sub    $0x1bc,%eax
 294:	8b 00                	mov    (%eax),%eax
 296:	01 45 c8             	add    %eax,-0x38(%ebp)
            AVGturnAroungTimeG1   += childPid[t].turnArroundTime;
 299:	8b 55 e8             	mov    -0x18(%ebp),%edx
 29c:	89 d0                	mov    %edx,%eax
 29e:	c1 e0 02             	shl    $0x2,%eax
 2a1:	01 d0                	add    %edx,%eax
 2a3:	c1 e0 02             	shl    $0x2,%eax
 2a6:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 2a9:	01 c8                	add    %ecx,%eax
 2ab:	2d b4 01 00 00       	sub    $0x1b4,%eax
 2b0:	8b 00                	mov    (%eax),%eax
 2b2:	01 45 c4             	add    %eax,-0x3c(%ebp)
        }
        t++;
 2b5:	ff 45 e8             	incl   -0x18(%ebp)
            exit();
        }
    }

    // update to all children thire data
    while((childPid[t].pid = wait2( &(childPid[t].wTime),
 2b8:	8d 8d 34 fe ff ff    	lea    -0x1cc(%ebp),%ecx
 2be:	8b 55 e8             	mov    -0x18(%ebp),%edx
 2c1:	89 d0                	mov    %edx,%eax
 2c3:	c1 e0 02             	shl    $0x2,%eax
 2c6:	01 d0                	add    %edx,%eax
 2c8:	c1 e0 02             	shl    $0x2,%eax
 2cb:	01 c8                	add    %ecx,%eax
 2cd:	8d 58 0c             	lea    0xc(%eax),%ebx
 2d0:	8d 8d 34 fe ff ff    	lea    -0x1cc(%ebp),%ecx
 2d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
 2d9:	89 d0                	mov    %edx,%eax
 2db:	c1 e0 02             	shl    $0x2,%eax
 2de:	01 d0                	add    %edx,%eax
 2e0:	c1 e0 02             	shl    $0x2,%eax
 2e3:	01 c8                	add    %ecx,%eax
 2e5:	8d 48 08             	lea    0x8(%eax),%ecx
 2e8:	8d b5 34 fe ff ff    	lea    -0x1cc(%ebp),%esi
 2ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
 2f1:	89 d0                	mov    %edx,%eax
 2f3:	c1 e0 02             	shl    $0x2,%eax
 2f6:	01 d0                	add    %edx,%eax
 2f8:	c1 e0 02             	shl    $0x2,%eax
 2fb:	01 f0                	add    %esi,%eax
 2fd:	83 c0 04             	add    $0x4,%eax
 300:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 304:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 308:	89 04 24             	mov    %eax,(%esp)
 30b:	e8 d8 06 00 00       	call   9e8 <wait2>
 310:	89 c2                	mov    %eax,%edx
 312:	8b 4d e8             	mov    -0x18(%ebp),%ecx
 315:	89 c8                	mov    %ecx,%eax
 317:	c1 e0 02             	shl    $0x2,%eax
 31a:	01 c8                	add    %ecx,%eax
 31c:	c1 e0 02             	shl    $0x2,%eax
 31f:	8d 75 f8             	lea    -0x8(%ebp),%esi
 322:	01 f0                	add    %esi,%eax
 324:	2d c4 01 00 00       	sub    $0x1c4,%eax
 329:	89 10                	mov    %edx,(%eax)
 32b:	8b 55 e8             	mov    -0x18(%ebp),%edx
 32e:	89 d0                	mov    %edx,%eax
 330:	c1 e0 02             	shl    $0x2,%eax
 333:	01 d0                	add    %edx,%eax
 335:	c1 e0 02             	shl    $0x2,%eax
 338:	8d 55 f8             	lea    -0x8(%ebp),%edx
 33b:	01 d0                	add    %edx,%eax
 33d:	2d c4 01 00 00       	sub    $0x1c4,%eax
 342:	8b 00                	mov    (%eax),%eax
 344:	85 c0                	test   %eax,%eax
 346:	0f 8f b4 fd ff ff    	jg     100 <mlfqSanity+0x100>
        }
        t++;
    }


    printf(2,"____________________________________________________\n");
 34c:	c7 44 24 04 d4 0e 00 	movl   $0xed4,0x4(%esp)
 353:	00 
 354:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 35b:	e8 68 07 00 00       	call   ac8 <printf>
    printf(2, "\n *** Averege Time Of All My Childrens ***\n ");
 360:	c7 44 24 04 0c 0f 00 	movl   $0xf0c,0x4(%esp)
 367:	00 
 368:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 36f:	e8 54 07 00 00       	call   ac8 <printf>
    printf(2, " wTime: %d , rTime: %d , turnArroundTime: %d \n",
 374:	8b 4d dc             	mov    -0x24(%ebp),%ecx
 377:	ba 67 66 66 66       	mov    $0x66666667,%edx
 37c:	89 c8                	mov    %ecx,%eax
 37e:	f7 ea                	imul   %edx
 380:	c1 fa 03             	sar    $0x3,%edx
 383:	89 c8                	mov    %ecx,%eax
 385:	c1 f8 1f             	sar    $0x1f,%eax
 388:	89 d6                	mov    %edx,%esi
 38a:	29 c6                	sub    %eax,%esi
 38c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 38f:	ba 67 66 66 66       	mov    $0x66666667,%edx
 394:	89 c8                	mov    %ecx,%eax
 396:	f7 ea                	imul   %edx
 398:	c1 fa 03             	sar    $0x3,%edx
 39b:	89 c8                	mov    %ecx,%eax
 39d:	c1 f8 1f             	sar    $0x1f,%eax
 3a0:	89 d3                	mov    %edx,%ebx
 3a2:	29 c3                	sub    %eax,%ebx
 3a4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 3a7:	ba 67 66 66 66       	mov    $0x66666667,%edx
 3ac:	89 c8                	mov    %ecx,%eax
 3ae:	f7 ea                	imul   %edx
 3b0:	c1 fa 03             	sar    $0x3,%edx
 3b3:	89 c8                	mov    %ecx,%eax
 3b5:	c1 f8 1f             	sar    $0x1f,%eax
 3b8:	89 d1                	mov    %edx,%ecx
 3ba:	29 c1                	sub    %eax,%ecx
 3bc:	89 c8                	mov    %ecx,%eax
 3be:	89 74 24 10          	mov    %esi,0x10(%esp)
 3c2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 3c6:	89 44 24 08          	mov    %eax,0x8(%esp)
 3ca:	c7 44 24 04 3c 0f 00 	movl   $0xf3c,0x4(%esp)
 3d1:	00 
 3d2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 3d9:	e8 ea 06 00 00       	call   ac8 <printf>
            AVGwTime/20,
            AVGrTime/20,
            AVGturnAroungTime/20);
    printf(2,"____________________________________________________\n");
 3de:	c7 44 24 04 d4 0e 00 	movl   $0xed4,0x4(%esp)
 3e5:	00 
 3e6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 3ed:	e8 d6 06 00 00       	call   ac8 <printf>

    printf(2, "\n *** Averege Time By \% Group  *** \n");
 3f2:	c7 44 24 04 6c 0f 00 	movl   $0xf6c,0x4(%esp)
 3f9:	00 
 3fa:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 401:	e8 c2 06 00 00       	call   ac8 <printf>

    printf(2, "   ***   Group cid % 2 == 0      *** \n");
 406:	c7 44 24 04 94 0f 00 	movl   $0xf94,0x4(%esp)
 40d:	00 
 40e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 415:	e8 ae 06 00 00       	call   ac8 <printf>
    printf(2, " wTime: %d , rTime: %d , turnArroundTime: %d \n",
 41a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 41d:	ba 67 66 66 66       	mov    $0x66666667,%edx
 422:	89 c8                	mov    %ecx,%eax
 424:	f7 ea                	imul   %edx
 426:	c1 fa 03             	sar    $0x3,%edx
 429:	89 c8                	mov    %ecx,%eax
 42b:	c1 f8 1f             	sar    $0x1f,%eax
 42e:	89 d6                	mov    %edx,%esi
 430:	29 c6                	sub    %eax,%esi
 432:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 435:	ba 67 66 66 66       	mov    $0x66666667,%edx
 43a:	89 c8                	mov    %ecx,%eax
 43c:	f7 ea                	imul   %edx
 43e:	c1 fa 03             	sar    $0x3,%edx
 441:	89 c8                	mov    %ecx,%eax
 443:	c1 f8 1f             	sar    $0x1f,%eax
 446:	89 d3                	mov    %edx,%ebx
 448:	29 c3                	sub    %eax,%ebx
 44a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
 44d:	ba 67 66 66 66       	mov    $0x66666667,%edx
 452:	89 c8                	mov    %ecx,%eax
 454:	f7 ea                	imul   %edx
 456:	c1 fa 03             	sar    $0x3,%edx
 459:	89 c8                	mov    %ecx,%eax
 45b:	c1 f8 1f             	sar    $0x1f,%eax
 45e:	89 d1                	mov    %edx,%ecx
 460:	29 c1                	sub    %eax,%ecx
 462:	89 c8                	mov    %ecx,%eax
 464:	89 74 24 10          	mov    %esi,0x10(%esp)
 468:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 46c:	89 44 24 08          	mov    %eax,0x8(%esp)
 470:	c7 44 24 04 3c 0f 00 	movl   $0xf3c,0x4(%esp)
 477:	00 
 478:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 47f:	e8 44 06 00 00       	call   ac8 <printf>
            AVGwTimeG0/20, 
            AVGrTimeG0/20, 
            AVGturnAroungTimeG0/20);

    printf(2, "\n ***   Group cid % 2 == 1      *** \n");
 484:	c7 44 24 04 bc 0f 00 	movl   $0xfbc,0x4(%esp)
 48b:	00 
 48c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 493:	e8 30 06 00 00       	call   ac8 <printf>
    printf(2,"  wTime: %d , Averege rTime: %d , Averege turnArroundTime: %d.\n",
            AVGwTimeG1/20,
            AVGrTimeG1/20,
            (AVGturnAroungTime - AVGturnAroungTimeG0)/20);
 498:	8b 45 d0             	mov    -0x30(%ebp),%eax
 49b:	8b 55 dc             	mov    -0x24(%ebp),%edx
 49e:	89 d1                	mov    %edx,%ecx
 4a0:	29 c1                	sub    %eax,%ecx
            AVGwTimeG0/20, 
            AVGrTimeG0/20, 
            AVGturnAroungTimeG0/20);

    printf(2, "\n ***   Group cid % 2 == 1      *** \n");
    printf(2,"  wTime: %d , Averege rTime: %d , Averege turnArroundTime: %d.\n",
 4a2:	ba 67 66 66 66       	mov    $0x66666667,%edx
 4a7:	89 c8                	mov    %ecx,%eax
 4a9:	f7 ea                	imul   %edx
 4ab:	c1 fa 03             	sar    $0x3,%edx
 4ae:	89 c8                	mov    %ecx,%eax
 4b0:	c1 f8 1f             	sar    $0x1f,%eax
 4b3:	89 d6                	mov    %edx,%esi
 4b5:	29 c6                	sub    %eax,%esi
 4b7:	8b 4d c8             	mov    -0x38(%ebp),%ecx
 4ba:	ba 67 66 66 66       	mov    $0x66666667,%edx
 4bf:	89 c8                	mov    %ecx,%eax
 4c1:	f7 ea                	imul   %edx
 4c3:	c1 fa 03             	sar    $0x3,%edx
 4c6:	89 c8                	mov    %ecx,%eax
 4c8:	c1 f8 1f             	sar    $0x1f,%eax
 4cb:	89 d3                	mov    %edx,%ebx
 4cd:	29 c3                	sub    %eax,%ebx
 4cf:	8b 4d cc             	mov    -0x34(%ebp),%ecx
 4d2:	ba 67 66 66 66       	mov    $0x66666667,%edx
 4d7:	89 c8                	mov    %ecx,%eax
 4d9:	f7 ea                	imul   %edx
 4db:	c1 fa 03             	sar    $0x3,%edx
 4de:	89 c8                	mov    %ecx,%eax
 4e0:	c1 f8 1f             	sar    $0x1f,%eax
 4e3:	89 d1                	mov    %edx,%ecx
 4e5:	29 c1                	sub    %eax,%ecx
 4e7:	89 c8                	mov    %ecx,%eax
 4e9:	89 74 24 10          	mov    %esi,0x10(%esp)
 4ed:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 4f1:	89 44 24 08          	mov    %eax,0x8(%esp)
 4f5:	c7 44 24 04 e4 0f 00 	movl   $0xfe4,0x4(%esp)
 4fc:	00 
 4fd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 504:	e8 bf 05 00 00       	call   ac8 <printf>
            AVGwTimeG1/20,
            AVGrTimeG1/20,
            (AVGturnAroungTime - AVGturnAroungTimeG0)/20);

    printf(2,"____________________________________________________\n");
 509:	c7 44 24 04 d4 0e 00 	movl   $0xed4,0x4(%esp)
 510:	00 
 511:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 518:	e8 ab 05 00 00       	call   ac8 <printf>

    printf(2, "\n *** My childrens Data  ***\n ");
 51d:	c7 44 24 04 24 10 00 	movl   $0x1024,0x4(%esp)
 524:	00 
 525:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 52c:	e8 97 05 00 00       	call   ac8 <printf>
    for(l = 0 ; l < 20 ; l++)
 531:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 538:	e9 92 00 00 00       	jmp    5cf <mlfqSanity+0x5cf>
    {
        printf(2,"%d) chlidPid: %d - waitTime: %d , runTime: %d , turnArroundTime: %d\n",
 53d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 540:	89 d0                	mov    %edx,%eax
 542:	c1 e0 02             	shl    $0x2,%eax
 545:	01 d0                	add    %edx,%eax
 547:	c1 e0 02             	shl    $0x2,%eax
 54a:	8d 75 f8             	lea    -0x8(%ebp),%esi
 54d:	01 f0                	add    %esi,%eax
 54f:	2d b4 01 00 00       	sub    $0x1b4,%eax
 554:	8b 18                	mov    (%eax),%ebx
 556:	8b 55 ec             	mov    -0x14(%ebp),%edx
 559:	89 d0                	mov    %edx,%eax
 55b:	c1 e0 02             	shl    $0x2,%eax
 55e:	01 d0                	add    %edx,%eax
 560:	c1 e0 02             	shl    $0x2,%eax
 563:	8d 55 f8             	lea    -0x8(%ebp),%edx
 566:	01 d0                	add    %edx,%eax
 568:	2d bc 01 00 00       	sub    $0x1bc,%eax
 56d:	8b 08                	mov    (%eax),%ecx
 56f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 572:	89 d0                	mov    %edx,%eax
 574:	c1 e0 02             	shl    $0x2,%eax
 577:	01 d0                	add    %edx,%eax
 579:	c1 e0 02             	shl    $0x2,%eax
 57c:	8d 75 f8             	lea    -0x8(%ebp),%esi
 57f:	01 f0                	add    %esi,%eax
 581:	2d c0 01 00 00       	sub    $0x1c0,%eax
 586:	8b 10                	mov    (%eax),%edx
 588:	8b 75 ec             	mov    -0x14(%ebp),%esi
 58b:	89 f0                	mov    %esi,%eax
 58d:	c1 e0 02             	shl    $0x2,%eax
 590:	01 f0                	add    %esi,%eax
 592:	c1 e0 02             	shl    $0x2,%eax
 595:	8d 75 f8             	lea    -0x8(%ebp),%esi
 598:	01 f0                	add    %esi,%eax
 59a:	2d c4 01 00 00       	sub    $0x1c4,%eax
 59f:	8b 00                	mov    (%eax),%eax
 5a1:	89 5c 24 18          	mov    %ebx,0x18(%esp)
 5a5:	89 4c 24 14          	mov    %ecx,0x14(%esp)
 5a9:	89 54 24 10          	mov    %edx,0x10(%esp)
 5ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
 5b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b4:	89 44 24 08          	mov    %eax,0x8(%esp)
 5b8:	c7 44 24 04 44 10 00 	movl   $0x1044,0x4(%esp)
 5bf:	00 
 5c0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 5c7:	e8 fc 04 00 00       	call   ac8 <printf>
            (AVGturnAroungTime - AVGturnAroungTimeG0)/20);

    printf(2,"____________________________________________________\n");

    printf(2, "\n *** My childrens Data  ***\n ");
    for(l = 0 ; l < 20 ; l++)
 5cc:	ff 45 ec             	incl   -0x14(%ebp)
 5cf:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
 5d3:	0f 8e 64 ff ff ff    	jle    53d <mlfqSanity+0x53d>
                childPid[l].pid,
                childPid[l].wTime,
                childPid[l].rTime,
                childPid[l].turnArroundTime);
    }
}
 5d9:	81 c4 f0 01 00 00    	add    $0x1f0,%esp
 5df:	5b                   	pop    %ebx
 5e0:	5e                   	pop    %esi
 5e1:	5d                   	pop    %ebp
 5e2:	c3                   	ret    

000005e3 <Fibonacci>:

int Fibonacci(int n)
{
 5e3:	55                   	push   %ebp
 5e4:	89 e5                	mov    %esp,%ebp
 5e6:	53                   	push   %ebx
 5e7:	83 ec 14             	sub    $0x14,%esp
    if ( n == 0 )
 5ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 5ee:	75 07                	jne    5f7 <Fibonacci+0x14>
        return 0;
 5f0:	b8 00 00 00 00       	mov    $0x0,%eax
 5f5:	eb 2b                	jmp    622 <Fibonacci+0x3f>
    else if ( n == 1 )
 5f7:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 5fb:	75 07                	jne    604 <Fibonacci+0x21>
        return 1;
 5fd:	b8 01 00 00 00       	mov    $0x1,%eax
 602:	eb 1e                	jmp    622 <Fibonacci+0x3f>
    else
        return ( Fibonacci(n-1) + Fibonacci(n-2) );
 604:	8b 45 08             	mov    0x8(%ebp),%eax
 607:	48                   	dec    %eax
 608:	89 04 24             	mov    %eax,(%esp)
 60b:	e8 d3 ff ff ff       	call   5e3 <Fibonacci>
 610:	89 c3                	mov    %eax,%ebx
 612:	8b 45 08             	mov    0x8(%ebp),%eax
 615:	83 e8 02             	sub    $0x2,%eax
 618:	89 04 24             	mov    %eax,(%esp)
 61b:	e8 c3 ff ff ff       	call   5e3 <Fibonacci>
 620:	01 d8                	add    %ebx,%eax
} 
 622:	83 c4 14             	add    $0x14,%esp
 625:	5b                   	pop    %ebx
 626:	5d                   	pop    %ebp
 627:	c3                   	ret    

00000628 <main>:

    int
main(void)
{
 628:	55                   	push   %ebp
 629:	89 e5                	mov    %esp,%ebp
 62b:	83 e4 f0             	and    $0xfffffff0,%esp
    mlfqSanity();
 62e:	e8 cd f9 ff ff       	call   0 <mlfqSanity>
    exit();
 633:	e8 08 03 00 00       	call   940 <exit>

00000638 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 638:	55                   	push   %ebp
 639:	89 e5                	mov    %esp,%ebp
 63b:	57                   	push   %edi
 63c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 63d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 640:	8b 55 10             	mov    0x10(%ebp),%edx
 643:	8b 45 0c             	mov    0xc(%ebp),%eax
 646:	89 cb                	mov    %ecx,%ebx
 648:	89 df                	mov    %ebx,%edi
 64a:	89 d1                	mov    %edx,%ecx
 64c:	fc                   	cld    
 64d:	f3 aa                	rep stos %al,%es:(%edi)
 64f:	89 ca                	mov    %ecx,%edx
 651:	89 fb                	mov    %edi,%ebx
 653:	89 5d 08             	mov    %ebx,0x8(%ebp)
 656:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 659:	5b                   	pop    %ebx
 65a:	5f                   	pop    %edi
 65b:	5d                   	pop    %ebp
 65c:	c3                   	ret    

0000065d <strcpy>:

#define NULL   0

char*
strcpy(char *s, char *t)
{
 65d:	55                   	push   %ebp
 65e:	89 e5                	mov    %esp,%ebp
 660:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 663:	8b 45 08             	mov    0x8(%ebp),%eax
 666:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 669:	90                   	nop
 66a:	8b 45 0c             	mov    0xc(%ebp),%eax
 66d:	8a 10                	mov    (%eax),%dl
 66f:	8b 45 08             	mov    0x8(%ebp),%eax
 672:	88 10                	mov    %dl,(%eax)
 674:	8b 45 08             	mov    0x8(%ebp),%eax
 677:	8a 00                	mov    (%eax),%al
 679:	84 c0                	test   %al,%al
 67b:	0f 95 c0             	setne  %al
 67e:	ff 45 08             	incl   0x8(%ebp)
 681:	ff 45 0c             	incl   0xc(%ebp)
 684:	84 c0                	test   %al,%al
 686:	75 e2                	jne    66a <strcpy+0xd>
    ;
  return os;
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 68b:	c9                   	leave  
 68c:	c3                   	ret    

0000068d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 68d:	55                   	push   %ebp
 68e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 690:	eb 06                	jmp    698 <strcmp+0xb>
    p++, q++;
 692:	ff 45 08             	incl   0x8(%ebp)
 695:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 698:	8b 45 08             	mov    0x8(%ebp),%eax
 69b:	8a 00                	mov    (%eax),%al
 69d:	84 c0                	test   %al,%al
 69f:	74 0e                	je     6af <strcmp+0x22>
 6a1:	8b 45 08             	mov    0x8(%ebp),%eax
 6a4:	8a 10                	mov    (%eax),%dl
 6a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a9:	8a 00                	mov    (%eax),%al
 6ab:	38 c2                	cmp    %al,%dl
 6ad:	74 e3                	je     692 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 6af:	8b 45 08             	mov    0x8(%ebp),%eax
 6b2:	8a 00                	mov    (%eax),%al
 6b4:	0f b6 d0             	movzbl %al,%edx
 6b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ba:	8a 00                	mov    (%eax),%al
 6bc:	0f b6 c0             	movzbl %al,%eax
 6bf:	89 d1                	mov    %edx,%ecx
 6c1:	29 c1                	sub    %eax,%ecx
 6c3:	89 c8                	mov    %ecx,%eax
}
 6c5:	5d                   	pop    %ebp
 6c6:	c3                   	ret    

000006c7 <strlen>:

uint
strlen(char *s)
{
 6c7:	55                   	push   %ebp
 6c8:	89 e5                	mov    %esp,%ebp
 6ca:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 6cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 6d4:	eb 03                	jmp    6d9 <strlen+0x12>
 6d6:	ff 45 fc             	incl   -0x4(%ebp)
 6d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6dc:	8b 45 08             	mov    0x8(%ebp),%eax
 6df:	01 d0                	add    %edx,%eax
 6e1:	8a 00                	mov    (%eax),%al
 6e3:	84 c0                	test   %al,%al
 6e5:	75 ef                	jne    6d6 <strlen+0xf>
    ;
  return n;
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6ea:	c9                   	leave  
 6eb:	c3                   	ret    

000006ec <memset>:

void*
memset(void *dst, int c, uint n)
{
 6ec:	55                   	push   %ebp
 6ed:	89 e5                	mov    %esp,%ebp
 6ef:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 6f2:	8b 45 10             	mov    0x10(%ebp),%eax
 6f5:	89 44 24 08          	mov    %eax,0x8(%esp)
 6f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 6fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 700:	8b 45 08             	mov    0x8(%ebp),%eax
 703:	89 04 24             	mov    %eax,(%esp)
 706:	e8 2d ff ff ff       	call   638 <stosb>
  return dst;
 70b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 70e:	c9                   	leave  
 70f:	c3                   	ret    

00000710 <strchr>:

char*
strchr(const char *s, char c)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	83 ec 04             	sub    $0x4,%esp
 716:	8b 45 0c             	mov    0xc(%ebp),%eax
 719:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 71c:	eb 12                	jmp    730 <strchr+0x20>
    if(*s == c)
 71e:	8b 45 08             	mov    0x8(%ebp),%eax
 721:	8a 00                	mov    (%eax),%al
 723:	3a 45 fc             	cmp    -0x4(%ebp),%al
 726:	75 05                	jne    72d <strchr+0x1d>
      return (char*)s;
 728:	8b 45 08             	mov    0x8(%ebp),%eax
 72b:	eb 11                	jmp    73e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 72d:	ff 45 08             	incl   0x8(%ebp)
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	8a 00                	mov    (%eax),%al
 735:	84 c0                	test   %al,%al
 737:	75 e5                	jne    71e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 739:	b8 00 00 00 00       	mov    $0x0,%eax
}
 73e:	c9                   	leave  
 73f:	c3                   	ret    

00000740 <gets>:

char*
gets(char *buf, int max)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 746:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 74d:	eb 42                	jmp    791 <gets+0x51>
    cc = read(0, &c, 1);
 74f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 756:	00 
 757:	8d 45 ef             	lea    -0x11(%ebp),%eax
 75a:	89 44 24 04          	mov    %eax,0x4(%esp)
 75e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 765:	e8 ee 01 00 00       	call   958 <read>
 76a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 76d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 771:	7e 29                	jle    79c <gets+0x5c>
      break;
    buf[i++] = c;
 773:	8b 55 f4             	mov    -0xc(%ebp),%edx
 776:	8b 45 08             	mov    0x8(%ebp),%eax
 779:	01 c2                	add    %eax,%edx
 77b:	8a 45 ef             	mov    -0x11(%ebp),%al
 77e:	88 02                	mov    %al,(%edx)
 780:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 783:	8a 45 ef             	mov    -0x11(%ebp),%al
 786:	3c 0a                	cmp    $0xa,%al
 788:	74 13                	je     79d <gets+0x5d>
 78a:	8a 45 ef             	mov    -0x11(%ebp),%al
 78d:	3c 0d                	cmp    $0xd,%al
 78f:	74 0c                	je     79d <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 791:	8b 45 f4             	mov    -0xc(%ebp),%eax
 794:	40                   	inc    %eax
 795:	3b 45 0c             	cmp    0xc(%ebp),%eax
 798:	7c b5                	jl     74f <gets+0xf>
 79a:	eb 01                	jmp    79d <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 79c:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 79d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7a0:	8b 45 08             	mov    0x8(%ebp),%eax
 7a3:	01 d0                	add    %edx,%eax
 7a5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 7a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7ab:	c9                   	leave  
 7ac:	c3                   	ret    

000007ad <stat>:

int
stat(char *n, struct stat *st)
{
 7ad:	55                   	push   %ebp
 7ae:	89 e5                	mov    %esp,%ebp
 7b0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7b3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 7ba:	00 
 7bb:	8b 45 08             	mov    0x8(%ebp),%eax
 7be:	89 04 24             	mov    %eax,(%esp)
 7c1:	e8 ba 01 00 00       	call   980 <open>
 7c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7cd:	79 07                	jns    7d6 <stat+0x29>
    return -1;
 7cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7d4:	eb 23                	jmp    7f9 <stat+0x4c>
  r = fstat(fd, st);
 7d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	89 04 24             	mov    %eax,(%esp)
 7e3:	e8 b0 01 00 00       	call   998 <fstat>
 7e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	89 04 24             	mov    %eax,(%esp)
 7f1:	e8 72 01 00 00       	call   968 <close>
  return r;
 7f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7f9:	c9                   	leave  
 7fa:	c3                   	ret    

000007fb <atoi>:

int
atoi(const char *s)
{
 7fb:	55                   	push   %ebp
 7fc:	89 e5                	mov    %esp,%ebp
 7fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 801:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 808:	eb 21                	jmp    82b <atoi+0x30>
    n = n*10 + *s++ - '0';
 80a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 80d:	89 d0                	mov    %edx,%eax
 80f:	c1 e0 02             	shl    $0x2,%eax
 812:	01 d0                	add    %edx,%eax
 814:	d1 e0                	shl    %eax
 816:	89 c2                	mov    %eax,%edx
 818:	8b 45 08             	mov    0x8(%ebp),%eax
 81b:	8a 00                	mov    (%eax),%al
 81d:	0f be c0             	movsbl %al,%eax
 820:	01 d0                	add    %edx,%eax
 822:	83 e8 30             	sub    $0x30,%eax
 825:	89 45 fc             	mov    %eax,-0x4(%ebp)
 828:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 82b:	8b 45 08             	mov    0x8(%ebp),%eax
 82e:	8a 00                	mov    (%eax),%al
 830:	3c 2f                	cmp    $0x2f,%al
 832:	7e 09                	jle    83d <atoi+0x42>
 834:	8b 45 08             	mov    0x8(%ebp),%eax
 837:	8a 00                	mov    (%eax),%al
 839:	3c 39                	cmp    $0x39,%al
 83b:	7e cd                	jle    80a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 83d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 840:	c9                   	leave  
 841:	c3                   	ret    

00000842 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 842:	55                   	push   %ebp
 843:	89 e5                	mov    %esp,%ebp
 845:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 848:	8b 45 08             	mov    0x8(%ebp),%eax
 84b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 84e:	8b 45 0c             	mov    0xc(%ebp),%eax
 851:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 854:	eb 10                	jmp    866 <memmove+0x24>
    *dst++ = *src++;
 856:	8b 45 f8             	mov    -0x8(%ebp),%eax
 859:	8a 10                	mov    (%eax),%dl
 85b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85e:	88 10                	mov    %dl,(%eax)
 860:	ff 45 fc             	incl   -0x4(%ebp)
 863:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 866:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 86a:	0f 9f c0             	setg   %al
 86d:	ff 4d 10             	decl   0x10(%ebp)
 870:	84 c0                	test   %al,%al
 872:	75 e2                	jne    856 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 874:	8b 45 08             	mov    0x8(%ebp),%eax
}
 877:	c9                   	leave  
 878:	c3                   	ret    

00000879 <strtok>:

char*
strtok(char *teststr, char ch)
{
 879:	55                   	push   %ebp
 87a:	89 e5                	mov    %esp,%ebp
 87c:	83 ec 24             	sub    $0x24,%esp
 87f:	8b 45 0c             	mov    0xc(%ebp),%eax
 882:	88 45 dc             	mov    %al,-0x24(%ebp)
    char *dummystr = NULL;
 885:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    char *start = NULL;
 88c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    char *end = NULL;
 893:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char nullch = '\0';
 89a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    char *address_of_null = &nullch;
 89e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 8a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    static char *nexttok;

    if(teststr != NULL)
 8a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8a8:	74 08                	je     8b2 <strtok+0x39>
    {
        dummystr = teststr;
 8aa:	8b 45 08             	mov    0x8(%ebp),%eax
 8ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 8b0:	eb 75                	jmp    927 <strtok+0xae>
    {
        dummystr = teststr;
    }
    else
    {
        if(*nexttok == '\0')
 8b2:	a1 50 13 00 00       	mov    0x1350,%eax
 8b7:	8a 00                	mov    (%eax),%al
 8b9:	84 c0                	test   %al,%al
 8bb:	75 07                	jne    8c4 <strtok+0x4b>
            return NULL;
 8bd:	b8 00 00 00 00       	mov    $0x0,%eax
 8c2:	eb 6f                	jmp    933 <strtok+0xba>
        dummystr = nexttok;
 8c4:	a1 50 13 00 00       	mov    0x1350,%eax
 8c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }


    while(dummystr != NULL)
 8cc:	eb 59                	jmp    927 <strtok+0xae>
    {
        //empty string
        if(*dummystr == '\0')
 8ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d1:	8a 00                	mov    (%eax),%al
 8d3:	84 c0                	test   %al,%al
 8d5:	74 58                	je     92f <strtok+0xb6>
            break;
        if(*dummystr != ch)
 8d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8da:	8a 00                	mov    (%eax),%al
 8dc:	3a 45 dc             	cmp    -0x24(%ebp),%al
 8df:	74 22                	je     903 <strtok+0x8a>
        {
            if(!start)
 8e1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 8e5:	75 06                	jne    8ed <strtok+0x74>
                start = dummystr;
 8e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ea:	89 45 f8             	mov    %eax,-0x8(%ebp)

            dummystr++;
 8ed:	ff 45 fc             	incl   -0x4(%ebp)

            // handle the case where the delimiter is not at the end of the string.
            if(*dummystr == '\0')
 8f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f3:	8a 00                	mov    (%eax),%al
 8f5:	84 c0                	test   %al,%al
 8f7:	75 2e                	jne    927 <strtok+0xae>
            {
                nexttok = dummystr;
 8f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fc:	a3 50 13 00 00       	mov    %eax,0x1350
                break;
 901:	eb 2d                	jmp    930 <strtok+0xb7>
            }
        }
        else
        {
            if(start)
 903:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 907:	74 1b                	je     924 <strtok+0xab>
            {
                end = dummystr;
 909:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90c:	89 45 f4             	mov    %eax,-0xc(%ebp)
                nexttok = dummystr+1;
 90f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 912:	40                   	inc    %eax
 913:	a3 50 13 00 00       	mov    %eax,0x1350
                *end = *address_of_null;
 918:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91b:	8a 10                	mov    (%eax),%dl
 91d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 920:	88 10                	mov    %dl,(%eax)
                break;
 922:	eb 0c                	jmp    930 <strtok+0xb7>
            }
            else
            {
                dummystr++;
 924:	ff 45 fc             	incl   -0x4(%ebp)
            return NULL;
        dummystr = nexttok;
    }


    while(dummystr != NULL)
 927:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
 92b:	75 a1                	jne    8ce <strtok+0x55>
 92d:	eb 01                	jmp    930 <strtok+0xb7>
    {
        //empty string
        if(*dummystr == '\0')
            break;
 92f:	90                   	nop
                dummystr++;
            }
        }
    }

    return start;
 930:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 933:	c9                   	leave  
 934:	c3                   	ret    
 935:	66 90                	xchg   %ax,%ax
 937:	90                   	nop

00000938 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 938:	b8 01 00 00 00       	mov    $0x1,%eax
 93d:	cd 40                	int    $0x40
 93f:	c3                   	ret    

00000940 <exit>:
SYSCALL(exit)
 940:	b8 02 00 00 00       	mov    $0x2,%eax
 945:	cd 40                	int    $0x40
 947:	c3                   	ret    

00000948 <wait>:
SYSCALL(wait)
 948:	b8 03 00 00 00       	mov    $0x3,%eax
 94d:	cd 40                	int    $0x40
 94f:	c3                   	ret    

00000950 <pipe>:
SYSCALL(pipe)
 950:	b8 04 00 00 00       	mov    $0x4,%eax
 955:	cd 40                	int    $0x40
 957:	c3                   	ret    

00000958 <read>:
SYSCALL(read)
 958:	b8 05 00 00 00       	mov    $0x5,%eax
 95d:	cd 40                	int    $0x40
 95f:	c3                   	ret    

00000960 <write>:
SYSCALL(write)
 960:	b8 10 00 00 00       	mov    $0x10,%eax
 965:	cd 40                	int    $0x40
 967:	c3                   	ret    

00000968 <close>:
SYSCALL(close)
 968:	b8 15 00 00 00       	mov    $0x15,%eax
 96d:	cd 40                	int    $0x40
 96f:	c3                   	ret    

00000970 <kill>:
SYSCALL(kill)
 970:	b8 06 00 00 00       	mov    $0x6,%eax
 975:	cd 40                	int    $0x40
 977:	c3                   	ret    

00000978 <exec>:
SYSCALL(exec)
 978:	b8 07 00 00 00       	mov    $0x7,%eax
 97d:	cd 40                	int    $0x40
 97f:	c3                   	ret    

00000980 <open>:
SYSCALL(open)
 980:	b8 0f 00 00 00       	mov    $0xf,%eax
 985:	cd 40                	int    $0x40
 987:	c3                   	ret    

00000988 <mknod>:
SYSCALL(mknod)
 988:	b8 11 00 00 00       	mov    $0x11,%eax
 98d:	cd 40                	int    $0x40
 98f:	c3                   	ret    

00000990 <unlink>:
SYSCALL(unlink)
 990:	b8 12 00 00 00       	mov    $0x12,%eax
 995:	cd 40                	int    $0x40
 997:	c3                   	ret    

00000998 <fstat>:
SYSCALL(fstat)
 998:	b8 08 00 00 00       	mov    $0x8,%eax
 99d:	cd 40                	int    $0x40
 99f:	c3                   	ret    

000009a0 <link>:
SYSCALL(link)
 9a0:	b8 13 00 00 00       	mov    $0x13,%eax
 9a5:	cd 40                	int    $0x40
 9a7:	c3                   	ret    

000009a8 <mkdir>:
SYSCALL(mkdir)
 9a8:	b8 14 00 00 00       	mov    $0x14,%eax
 9ad:	cd 40                	int    $0x40
 9af:	c3                   	ret    

000009b0 <chdir>:
SYSCALL(chdir)
 9b0:	b8 09 00 00 00       	mov    $0x9,%eax
 9b5:	cd 40                	int    $0x40
 9b7:	c3                   	ret    

000009b8 <dup>:
SYSCALL(dup)
 9b8:	b8 0a 00 00 00       	mov    $0xa,%eax
 9bd:	cd 40                	int    $0x40
 9bf:	c3                   	ret    

000009c0 <getpid>:
SYSCALL(getpid)
 9c0:	b8 0b 00 00 00       	mov    $0xb,%eax
 9c5:	cd 40                	int    $0x40
 9c7:	c3                   	ret    

000009c8 <sbrk>:
SYSCALL(sbrk)
 9c8:	b8 0c 00 00 00       	mov    $0xc,%eax
 9cd:	cd 40                	int    $0x40
 9cf:	c3                   	ret    

000009d0 <sleep>:
SYSCALL(sleep)
 9d0:	b8 0d 00 00 00       	mov    $0xd,%eax
 9d5:	cd 40                	int    $0x40
 9d7:	c3                   	ret    

000009d8 <uptime>:
SYSCALL(uptime)
 9d8:	b8 0e 00 00 00       	mov    $0xe,%eax
 9dd:	cd 40                	int    $0x40
 9df:	c3                   	ret    

000009e0 <add_path>:
SYSCALL(add_path)
 9e0:	b8 16 00 00 00       	mov    $0x16,%eax
 9e5:	cd 40                	int    $0x40
 9e7:	c3                   	ret    

000009e8 <wait2>:
SYSCALL(wait2)
 9e8:	b8 17 00 00 00       	mov    $0x17,%eax
 9ed:	cd 40                	int    $0x40
 9ef:	c3                   	ret    

000009f0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 9f0:	55                   	push   %ebp
 9f1:	89 e5                	mov    %esp,%ebp
 9f3:	83 ec 28             	sub    $0x28,%esp
 9f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 9f9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 9fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 a03:	00 
 a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
 a07:	89 44 24 04          	mov    %eax,0x4(%esp)
 a0b:	8b 45 08             	mov    0x8(%ebp),%eax
 a0e:	89 04 24             	mov    %eax,(%esp)
 a11:	e8 4a ff ff ff       	call   960 <write>
}
 a16:	c9                   	leave  
 a17:	c3                   	ret    

00000a18 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a18:	55                   	push   %ebp
 a19:	89 e5                	mov    %esp,%ebp
 a1b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 a1e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 a25:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 a29:	74 17                	je     a42 <printint+0x2a>
 a2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 a2f:	79 11                	jns    a42 <printint+0x2a>
    neg = 1;
 a31:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 a38:	8b 45 0c             	mov    0xc(%ebp),%eax
 a3b:	f7 d8                	neg    %eax
 a3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a40:	eb 06                	jmp    a48 <printint+0x30>
  } else {
    x = xx;
 a42:	8b 45 0c             	mov    0xc(%ebp),%eax
 a45:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 a48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 a4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 a52:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a55:	ba 00 00 00 00       	mov    $0x0,%edx
 a5a:	f7 f1                	div    %ecx
 a5c:	89 d0                	mov    %edx,%eax
 a5e:	8a 80 3c 13 00 00    	mov    0x133c(%eax),%al
 a64:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 a67:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a6a:	01 ca                	add    %ecx,%edx
 a6c:	88 02                	mov    %al,(%edx)
 a6e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 a71:	8b 55 10             	mov    0x10(%ebp),%edx
 a74:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a7a:	ba 00 00 00 00       	mov    $0x0,%edx
 a7f:	f7 75 d4             	divl   -0x2c(%ebp)
 a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a89:	75 c4                	jne    a4f <printint+0x37>
  if(neg)
 a8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a8f:	74 2c                	je     abd <printint+0xa5>
    buf[i++] = '-';
 a91:	8d 55 dc             	lea    -0x24(%ebp),%edx
 a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a97:	01 d0                	add    %edx,%eax
 a99:	c6 00 2d             	movb   $0x2d,(%eax)
 a9c:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 a9f:	eb 1c                	jmp    abd <printint+0xa5>
    putc(fd, buf[i]);
 aa1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa7:	01 d0                	add    %edx,%eax
 aa9:	8a 00                	mov    (%eax),%al
 aab:	0f be c0             	movsbl %al,%eax
 aae:	89 44 24 04          	mov    %eax,0x4(%esp)
 ab2:	8b 45 08             	mov    0x8(%ebp),%eax
 ab5:	89 04 24             	mov    %eax,(%esp)
 ab8:	e8 33 ff ff ff       	call   9f0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 abd:	ff 4d f4             	decl   -0xc(%ebp)
 ac0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ac4:	79 db                	jns    aa1 <printint+0x89>
    putc(fd, buf[i]);
}
 ac6:	c9                   	leave  
 ac7:	c3                   	ret    

00000ac8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 ac8:	55                   	push   %ebp
 ac9:	89 e5                	mov    %esp,%ebp
 acb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 ace:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 ad5:	8d 45 0c             	lea    0xc(%ebp),%eax
 ad8:	83 c0 04             	add    $0x4,%eax
 adb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 ade:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 ae5:	e9 78 01 00 00       	jmp    c62 <printf+0x19a>
    c = fmt[i] & 0xff;
 aea:	8b 55 0c             	mov    0xc(%ebp),%edx
 aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af0:	01 d0                	add    %edx,%eax
 af2:	8a 00                	mov    (%eax),%al
 af4:	0f be c0             	movsbl %al,%eax
 af7:	25 ff 00 00 00       	and    $0xff,%eax
 afc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 aff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b03:	75 2c                	jne    b31 <printf+0x69>
      if(c == '%'){
 b05:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b09:	75 0c                	jne    b17 <printf+0x4f>
        state = '%';
 b0b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 b12:	e9 48 01 00 00       	jmp    c5f <printf+0x197>
      } else {
        putc(fd, c);
 b17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b1a:	0f be c0             	movsbl %al,%eax
 b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
 b21:	8b 45 08             	mov    0x8(%ebp),%eax
 b24:	89 04 24             	mov    %eax,(%esp)
 b27:	e8 c4 fe ff ff       	call   9f0 <putc>
 b2c:	e9 2e 01 00 00       	jmp    c5f <printf+0x197>
      }
    } else if(state == '%'){
 b31:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 b35:	0f 85 24 01 00 00    	jne    c5f <printf+0x197>
      if(c == 'd'){
 b3b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 b3f:	75 2d                	jne    b6e <printf+0xa6>
        printint(fd, *ap, 10, 1);
 b41:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b44:	8b 00                	mov    (%eax),%eax
 b46:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 b4d:	00 
 b4e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 b55:	00 
 b56:	89 44 24 04          	mov    %eax,0x4(%esp)
 b5a:	8b 45 08             	mov    0x8(%ebp),%eax
 b5d:	89 04 24             	mov    %eax,(%esp)
 b60:	e8 b3 fe ff ff       	call   a18 <printint>
        ap++;
 b65:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b69:	e9 ea 00 00 00       	jmp    c58 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 b6e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 b72:	74 06                	je     b7a <printf+0xb2>
 b74:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 b78:	75 2d                	jne    ba7 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 b7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b7d:	8b 00                	mov    (%eax),%eax
 b7f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 b86:	00 
 b87:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 b8e:	00 
 b8f:	89 44 24 04          	mov    %eax,0x4(%esp)
 b93:	8b 45 08             	mov    0x8(%ebp),%eax
 b96:	89 04 24             	mov    %eax,(%esp)
 b99:	e8 7a fe ff ff       	call   a18 <printint>
        ap++;
 b9e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ba2:	e9 b1 00 00 00       	jmp    c58 <printf+0x190>
      } else if(c == 's'){
 ba7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 bab:	75 43                	jne    bf0 <printf+0x128>
        s = (char*)*ap;
 bad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bb0:	8b 00                	mov    (%eax),%eax
 bb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 bb5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 bb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bbd:	75 25                	jne    be4 <printf+0x11c>
          s = "(null)";
 bbf:	c7 45 f4 89 10 00 00 	movl   $0x1089,-0xc(%ebp)
        while(*s != 0){
 bc6:	eb 1c                	jmp    be4 <printf+0x11c>
          putc(fd, *s);
 bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bcb:	8a 00                	mov    (%eax),%al
 bcd:	0f be c0             	movsbl %al,%eax
 bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
 bd4:	8b 45 08             	mov    0x8(%ebp),%eax
 bd7:	89 04 24             	mov    %eax,(%esp)
 bda:	e8 11 fe ff ff       	call   9f0 <putc>
          s++;
 bdf:	ff 45 f4             	incl   -0xc(%ebp)
 be2:	eb 01                	jmp    be5 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 be4:	90                   	nop
 be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be8:	8a 00                	mov    (%eax),%al
 bea:	84 c0                	test   %al,%al
 bec:	75 da                	jne    bc8 <printf+0x100>
 bee:	eb 68                	jmp    c58 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 bf0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 bf4:	75 1d                	jne    c13 <printf+0x14b>
        putc(fd, *ap);
 bf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bf9:	8b 00                	mov    (%eax),%eax
 bfb:	0f be c0             	movsbl %al,%eax
 bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
 c02:	8b 45 08             	mov    0x8(%ebp),%eax
 c05:	89 04 24             	mov    %eax,(%esp)
 c08:	e8 e3 fd ff ff       	call   9f0 <putc>
        ap++;
 c0d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c11:	eb 45                	jmp    c58 <printf+0x190>
      } else if(c == '%'){
 c13:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 c17:	75 17                	jne    c30 <printf+0x168>
        putc(fd, c);
 c19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c1c:	0f be c0             	movsbl %al,%eax
 c1f:	89 44 24 04          	mov    %eax,0x4(%esp)
 c23:	8b 45 08             	mov    0x8(%ebp),%eax
 c26:	89 04 24             	mov    %eax,(%esp)
 c29:	e8 c2 fd ff ff       	call   9f0 <putc>
 c2e:	eb 28                	jmp    c58 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 c30:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 c37:	00 
 c38:	8b 45 08             	mov    0x8(%ebp),%eax
 c3b:	89 04 24             	mov    %eax,(%esp)
 c3e:	e8 ad fd ff ff       	call   9f0 <putc>
        putc(fd, c);
 c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c46:	0f be c0             	movsbl %al,%eax
 c49:	89 44 24 04          	mov    %eax,0x4(%esp)
 c4d:	8b 45 08             	mov    0x8(%ebp),%eax
 c50:	89 04 24             	mov    %eax,(%esp)
 c53:	e8 98 fd ff ff       	call   9f0 <putc>
      }
      state = 0;
 c58:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c5f:	ff 45 f0             	incl   -0x10(%ebp)
 c62:	8b 55 0c             	mov    0xc(%ebp),%edx
 c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c68:	01 d0                	add    %edx,%eax
 c6a:	8a 00                	mov    (%eax),%al
 c6c:	84 c0                	test   %al,%al
 c6e:	0f 85 76 fe ff ff    	jne    aea <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 c74:	c9                   	leave  
 c75:	c3                   	ret    
 c76:	66 90                	xchg   %ax,%ax

00000c78 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c78:	55                   	push   %ebp
 c79:	89 e5                	mov    %esp,%ebp
 c7b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c7e:	8b 45 08             	mov    0x8(%ebp),%eax
 c81:	83 e8 08             	sub    $0x8,%eax
 c84:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c87:	a1 5c 13 00 00       	mov    0x135c,%eax
 c8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c8f:	eb 24                	jmp    cb5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c94:	8b 00                	mov    (%eax),%eax
 c96:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c99:	77 12                	ja     cad <free+0x35>
 c9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c9e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ca1:	77 24                	ja     cc7 <free+0x4f>
 ca3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ca6:	8b 00                	mov    (%eax),%eax
 ca8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 cab:	77 1a                	ja     cc7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cb0:	8b 00                	mov    (%eax),%eax
 cb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 cb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cb8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 cbb:	76 d4                	jbe    c91 <free+0x19>
 cbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cc0:	8b 00                	mov    (%eax),%eax
 cc2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 cc5:	76 ca                	jbe    c91 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 cc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cca:	8b 40 04             	mov    0x4(%eax),%eax
 ccd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 cd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cd7:	01 c2                	add    %eax,%edx
 cd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cdc:	8b 00                	mov    (%eax),%eax
 cde:	39 c2                	cmp    %eax,%edx
 ce0:	75 24                	jne    d06 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 ce2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ce5:	8b 50 04             	mov    0x4(%eax),%edx
 ce8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ceb:	8b 00                	mov    (%eax),%eax
 ced:	8b 40 04             	mov    0x4(%eax),%eax
 cf0:	01 c2                	add    %eax,%edx
 cf2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cf5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 cf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cfb:	8b 00                	mov    (%eax),%eax
 cfd:	8b 10                	mov    (%eax),%edx
 cff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d02:	89 10                	mov    %edx,(%eax)
 d04:	eb 0a                	jmp    d10 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 d06:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d09:	8b 10                	mov    (%eax),%edx
 d0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d0e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d13:	8b 40 04             	mov    0x4(%eax),%eax
 d16:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d20:	01 d0                	add    %edx,%eax
 d22:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d25:	75 20                	jne    d47 <free+0xcf>
    p->s.size += bp->s.size;
 d27:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d2a:	8b 50 04             	mov    0x4(%eax),%edx
 d2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d30:	8b 40 04             	mov    0x4(%eax),%eax
 d33:	01 c2                	add    %eax,%edx
 d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d38:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d3e:	8b 10                	mov    (%eax),%edx
 d40:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d43:	89 10                	mov    %edx,(%eax)
 d45:	eb 08                	jmp    d4f <free+0xd7>
  } else
    p->s.ptr = bp;
 d47:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d4a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 d4d:	89 10                	mov    %edx,(%eax)
  freep = p;
 d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d52:	a3 5c 13 00 00       	mov    %eax,0x135c
}
 d57:	c9                   	leave  
 d58:	c3                   	ret    

00000d59 <morecore>:

static Header*
morecore(uint nu)
{
 d59:	55                   	push   %ebp
 d5a:	89 e5                	mov    %esp,%ebp
 d5c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 d5f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 d66:	77 07                	ja     d6f <morecore+0x16>
    nu = 4096;
 d68:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 d6f:	8b 45 08             	mov    0x8(%ebp),%eax
 d72:	c1 e0 03             	shl    $0x3,%eax
 d75:	89 04 24             	mov    %eax,(%esp)
 d78:	e8 4b fc ff ff       	call   9c8 <sbrk>
 d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 d80:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 d84:	75 07                	jne    d8d <morecore+0x34>
    return 0;
 d86:	b8 00 00 00 00       	mov    $0x0,%eax
 d8b:	eb 22                	jmp    daf <morecore+0x56>
  hp = (Header*)p;
 d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d96:	8b 55 08             	mov    0x8(%ebp),%edx
 d99:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d9f:	83 c0 08             	add    $0x8,%eax
 da2:	89 04 24             	mov    %eax,(%esp)
 da5:	e8 ce fe ff ff       	call   c78 <free>
  return freep;
 daa:	a1 5c 13 00 00       	mov    0x135c,%eax
}
 daf:	c9                   	leave  
 db0:	c3                   	ret    

00000db1 <malloc>:

void*
malloc(uint nbytes)
{
 db1:	55                   	push   %ebp
 db2:	89 e5                	mov    %esp,%ebp
 db4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 db7:	8b 45 08             	mov    0x8(%ebp),%eax
 dba:	83 c0 07             	add    $0x7,%eax
 dbd:	c1 e8 03             	shr    $0x3,%eax
 dc0:	40                   	inc    %eax
 dc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 dc4:	a1 5c 13 00 00       	mov    0x135c,%eax
 dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 dcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 dd0:	75 23                	jne    df5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 dd2:	c7 45 f0 54 13 00 00 	movl   $0x1354,-0x10(%ebp)
 dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ddc:	a3 5c 13 00 00       	mov    %eax,0x135c
 de1:	a1 5c 13 00 00       	mov    0x135c,%eax
 de6:	a3 54 13 00 00       	mov    %eax,0x1354
    base.s.size = 0;
 deb:	c7 05 58 13 00 00 00 	movl   $0x0,0x1358
 df2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 df8:	8b 00                	mov    (%eax),%eax
 dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e00:	8b 40 04             	mov    0x4(%eax),%eax
 e03:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e06:	72 4d                	jb     e55 <malloc+0xa4>
      if(p->s.size == nunits)
 e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e0b:	8b 40 04             	mov    0x4(%eax),%eax
 e0e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e11:	75 0c                	jne    e1f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e16:	8b 10                	mov    (%eax),%edx
 e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e1b:	89 10                	mov    %edx,(%eax)
 e1d:	eb 26                	jmp    e45 <malloc+0x94>
      else {
        p->s.size -= nunits;
 e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e22:	8b 40 04             	mov    0x4(%eax),%eax
 e25:	89 c2                	mov    %eax,%edx
 e27:	2b 55 ec             	sub    -0x14(%ebp),%edx
 e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e2d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e33:	8b 40 04             	mov    0x4(%eax),%eax
 e36:	c1 e0 03             	shl    $0x3,%eax
 e39:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 e42:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e48:	a3 5c 13 00 00       	mov    %eax,0x135c
      return (void*)(p + 1);
 e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e50:	83 c0 08             	add    $0x8,%eax
 e53:	eb 38                	jmp    e8d <malloc+0xdc>
    }
    if(p == freep)
 e55:	a1 5c 13 00 00       	mov    0x135c,%eax
 e5a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 e5d:	75 1b                	jne    e7a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 e5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 e62:	89 04 24             	mov    %eax,(%esp)
 e65:	e8 ef fe ff ff       	call   d59 <morecore>
 e6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 e6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e71:	75 07                	jne    e7a <malloc+0xc9>
        return 0;
 e73:	b8 00 00 00 00       	mov    $0x0,%eax
 e78:	eb 13                	jmp    e8d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e83:	8b 00                	mov    (%eax),%eax
 e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 e88:	e9 70 ff ff ff       	jmp    dfd <malloc+0x4c>
}
 e8d:	c9                   	leave  
 e8e:	c3                   	ret    
