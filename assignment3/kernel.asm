
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d3 33 10 80       	mov    $0x801033d3,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 5c 8b 10 	movl   $0x80108b5c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 05 4f 00 00       	call   80104f53 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 b0 eb 10 80 a4 	movl   $0x8010eba4,0x8010ebb0
80100055:	eb 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 b4 eb 10 80 a4 	movl   $0x8010eba4,0x8010ebb4
8010005f:	eb 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 b4 eb 10 80    	mov    0x8010ebb4,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c a4 eb 10 80 	movl   $0x8010eba4,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 b4 eb 10 80       	mov    %eax,0x8010ebb4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801000bd:	e8 b2 4e 00 00       	call   80104f74 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	83 c8 01             	or     $0x1,%eax
801000f6:	89 c2                	mov    %eax,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100104:	e8 cd 4e 00 00       	call   80104fd6 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 d6 10 	movl   $0x8010d680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 5d 47 00 00       	call   80104881 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 b0 eb 10 80       	mov    0x8010ebb0,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010017c:	e8 55 4e 00 00       	call   80104fd6 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 63 8b 10 80 	movl   $0x80108b63,(%esp)
8010019f:	e8 96 03 00 00       	call   8010053a <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 d7 25 00 00       	call   801027af <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 74 8b 10 80 	movl   $0x80108b74,(%esp)
801001f6:	e8 3f 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	83 c8 04             	or     $0x4,%eax
80100203:	89 c2                	mov    %eax,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 9a 25 00 00       	call   801027af <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 7b 8b 10 80 	movl   $0x80108b7b,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010023c:	e8 33 4d 00 00       	call   80104f74 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 b4 eb 10 80    	mov    0x8010ebb4,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c a4 eb 10 80 	movl   $0x8010eba4,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 b4 eb 10 80       	mov    %eax,0x8010ebb4

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	83 e0 fe             	and    $0xfffffffe,%eax
80100290:	89 c2                	mov    %eax,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 b8 46 00 00       	call   8010495a <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002a9:	e8 28 4d 00 00       	call   80104fd6 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	83 ec 14             	sub    $0x14,%esp
801002b6:	8b 45 08             	mov    0x8(%ebp),%eax
801002b9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c1:	89 c2                	mov    %eax,%edx
801002c3:	ec                   	in     (%dx),%al
801002c4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002c7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cb:	c9                   	leave  
801002cc:	c3                   	ret    

801002cd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002cd:	55                   	push   %ebp
801002ce:	89 e5                	mov    %esp,%ebp
801002d0:	83 ec 08             	sub    $0x8,%esp
801002d3:	8b 55 08             	mov    0x8(%ebp),%edx
801002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002d9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002dd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002e8:	ee                   	out    %al,(%dx)
}
801002e9:	c9                   	leave  
801002ea:	c3                   	ret    

801002eb <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002eb:	55                   	push   %ebp
801002ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002ee:	fa                   	cli    
}
801002ef:	5d                   	pop    %ebp
801002f0:	c3                   	ret    

801002f1 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	56                   	push   %esi
801002f5:	53                   	push   %ebx
801002f6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801002fd:	74 1c                	je     8010031b <printint+0x2a>
801002ff:	8b 45 08             	mov    0x8(%ebp),%eax
80100302:	c1 e8 1f             	shr    $0x1f,%eax
80100305:	0f b6 c0             	movzbl %al,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x2a>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100319:	eb 06                	jmp    80100321 <printint+0x30>
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100321:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010032b:	8d 41 01             	lea    0x1(%ecx),%eax
8010032e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100334:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100337:	ba 00 00 00 00       	mov    $0x0,%edx
8010033c:	f7 f3                	div    %ebx
8010033e:	89 d0                	mov    %edx,%eax
80100340:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
80100347:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010034b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100351:	ba 00 00 00 00       	mov    $0x0,%edx
80100356:	f7 f6                	div    %esi
80100358:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010035b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010035f:	75 c7                	jne    80100328 <printint+0x37>

  if(sign)
80100361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100365:	74 10                	je     80100377 <printint+0x86>
    buf[i++] = '-';
80100367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010036a:	8d 50 01             	lea    0x1(%eax),%edx
8010036d:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100370:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100375:	eb 18                	jmp    8010038f <printint+0x9e>
80100377:	eb 16                	jmp    8010038f <printint+0x9e>
    consputc(buf[i]);
80100379:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037f:	01 d0                	add    %edx,%eax
80100381:	0f b6 00             	movzbl (%eax),%eax
80100384:	0f be c0             	movsbl %al,%eax
80100387:	89 04 24             	mov    %eax,(%esp)
8010038a:	e8 c1 03 00 00       	call   80100750 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100397:	79 e0                	jns    80100379 <printint+0x88>
    consputc(buf[i]);
}
80100399:	83 c4 30             	add    $0x30,%esp
8010039c:	5b                   	pop    %ebx
8010039d:	5e                   	pop    %esi
8010039e:	5d                   	pop    %ebp
8010039f:	c3                   	ret    

801003a0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a6:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
801003bb:	e8 b4 4b 00 00       	call   80104f74 <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 82 8b 10 80 	movl   $0x80108b82,(%esp)
801003ce:	e8 67 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e0:	e9 21 01 00 00       	jmp    80100506 <cprintf+0x166>
    if(c != '%'){
801003e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5b>
      consputc(c);
801003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 5a 03 00 00       	call   80100750 <consputc>
      continue;
801003f6:	e9 07 01 00 00       	jmp    80100502 <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	0f b6 00             	movzbl (%eax),%eax
8010040a:	0f be c0             	movsbl %al,%eax
8010040d:	25 ff 00 00 00       	and    $0xff,%eax
80100412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100415:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100419:	75 05                	jne    80100420 <cprintf+0x80>
      break;
8010041b:	e9 06 01 00 00       	jmp    80100526 <cprintf+0x186>
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4f                	je     80100477 <cprintf+0xd7>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa0>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13c>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xaf>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14a>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 57                	je     8010049c <cprintf+0xfc>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2d                	je     80100477 <cprintf+0xd7>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8d 50 04             	lea    0x4(%eax),%edx
80100455:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100458:	8b 00                	mov    (%eax),%eax
8010045a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100461:	00 
80100462:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100469:	00 
8010046a:	89 04 24             	mov    %eax,(%esp)
8010046d:	e8 7f fe ff ff       	call   801002f1 <printint>
      break;
80100472:	e9 8b 00 00 00       	jmp    80100502 <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 57 fe ff ff       	call   801002f1 <printint>
      break;
8010049a:	eb 66                	jmp    80100502 <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ae:	75 09                	jne    801004b9 <cprintf+0x119>
        s = "(null)";
801004b0:	c7 45 ec 8b 8b 10 80 	movl   $0x80108b8b,-0x14(%ebp)
      for(; *s; s++)
801004b7:	eb 17                	jmp    801004d0 <cprintf+0x130>
801004b9:	eb 15                	jmp    801004d0 <cprintf+0x130>
        consputc(*s);
801004bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004be:	0f b6 00             	movzbl (%eax),%eax
801004c1:	0f be c0             	movsbl %al,%eax
801004c4:	89 04 24             	mov    %eax,(%esp)
801004c7:	e8 84 02 00 00       	call   80100750 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004cc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 e1                	jne    801004bb <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x162>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 68 02 00 00       	call   80100750 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 5a 02 00 00       	call   80100750 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 4f 02 00 00       	call   80100750 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x198>
    release(&cons.lock);
8010052c:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100533:	e8 9e 4a 00 00       	call   80104fd6 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 a6 fd ff ff       	call   801002eb <cli>
  cons.locking = 0;
80100545:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 92 8b 10 80 	movl   $0x80108b92,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 a1 8b 10 80 	movl   $0x80108ba1,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 91 4a 00 00       	call   80105025 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 a3 8b 10 80 	movl   $0x80108ba3,(%esp)
801005af:	e8 ec fd ff ff       	call   801003a0 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 e9 fc ff ff       	call   801002cd <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c0 fc ff ff       	call   801002b0 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c0 fc ff ff       	call   801002cd <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 97 fc ff ff       	call   801002b0 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	29 c1                	sub    %eax,%ecx
80100647:	89 ca                	mov    %ecx,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 35                	jmp    8010068a <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 26                	jle    8010068a <cgaputc+0xc0>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 20                	jmp    8010068a <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
80100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100673:	8d 50 01             	lea    0x1(%eax),%edx
80100676:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100679:	01 c0                	add    %eax,%eax
8010067b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067e:	8b 45 08             	mov    0x8(%ebp),%eax
80100681:	0f b6 c0             	movzbl %al,%eax
80100684:	80 cc 07             	or     $0x7,%ah
80100687:	66 89 02             	mov    %ax,(%edx)
  
  if((pos/80) >= 24){  // Scroll up.
8010068a:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100691:	7e 53                	jle    801006e6 <cgaputc+0x11c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100693:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 e0 4b 00 00       	call   80105297 <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c6:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 c8                	add    %ecx,%eax
801006d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 04 24             	mov    %eax,(%esp)
801006e1:	e8 e2 4a 00 00       	call   801051c8 <memset>
  }
  
  outb(CRTPORT, 14);
801006e6:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006ed:	00 
801006ee:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f5:	e8 d3 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos>>8);
801006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fd:	c1 f8 08             	sar    $0x8,%eax
80100700:	0f b6 c0             	movzbl %al,%eax
80100703:	89 44 24 04          	mov    %eax,0x4(%esp)
80100707:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070e:	e8 ba fb ff ff       	call   801002cd <outb>
  outb(CRTPORT, 15);
80100713:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071a:	00 
8010071b:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100722:	e8 a6 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos);
80100727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072a:	0f b6 c0             	movzbl %al,%eax
8010072d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100731:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100738:	e8 90 fb ff ff       	call   801002cd <outb>
  crt[pos] = ' ' | 0x0700;
8010073d:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100742:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100745:	01 d2                	add    %edx,%edx
80100747:	01 d0                	add    %edx,%eax
80100749:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074e:	c9                   	leave  
8010074f:	c3                   	ret    

80100750 <consputc>:

void
consputc(int c)
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100756:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
8010075b:	85 c0                	test   %eax,%eax
8010075d:	74 07                	je     80100766 <consputc+0x16>
    cli();
8010075f:	e8 87 fb ff ff       	call   801002eb <cli>
    for(;;)
      ;
80100764:	eb fe                	jmp    80100764 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100766:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076d:	75 26                	jne    80100795 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100776:	e8 58 64 00 00       	call   80106bd3 <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 4c 64 00 00       	call   80106bd3 <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 40 64 00 00       	call   80106bd3 <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 33 64 00 00       	call   80106bd3 <uartputc>
  cgaputc(c);
801007a0:	8b 45 08             	mov    0x8(%ebp),%eax
801007a3:	89 04 24             	mov    %eax,(%esp)
801007a6:	e8 1f fe ff ff       	call   801005ca <cgaputc>
}
801007ab:	c9                   	leave  
801007ac:	c3                   	ret    

801007ad <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ad:	55                   	push   %ebp
801007ae:	89 e5                	mov    %esp,%ebp
801007b0:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b3:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
801007ba:	e8 b5 47 00 00       	call   80104f74 <acquire>
  while((c = getc()) >= 0){
801007bf:	e9 37 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    switch(c){
801007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c7:	83 f8 10             	cmp    $0x10,%eax
801007ca:	74 1e                	je     801007ea <consoleintr+0x3d>
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	7f 0a                	jg     801007db <consoleintr+0x2e>
801007d1:	83 f8 08             	cmp    $0x8,%eax
801007d4:	74 64                	je     8010083a <consoleintr+0x8d>
801007d6:	e9 91 00 00 00       	jmp    8010086c <consoleintr+0xbf>
801007db:	83 f8 15             	cmp    $0x15,%eax
801007de:	74 2f                	je     8010080f <consoleintr+0x62>
801007e0:	83 f8 7f             	cmp    $0x7f,%eax
801007e3:	74 55                	je     8010083a <consoleintr+0x8d>
801007e5:	e9 82 00 00 00       	jmp    8010086c <consoleintr+0xbf>
    case C('P'):  // Process listing.
      procdump();
801007ea:	e8 0e 42 00 00       	call   801049fd <procdump>
      break;
801007ef:	e9 07 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 7c ee 10 80       	mov    %eax,0x8010ee7c
        consputc(BACKSPACE);
80100801:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100808:	e8 43 ff ff ff       	call   80100750 <consputc>
8010080d:	eb 01                	jmp    80100810 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080f:	90                   	nop
80100810:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
80100816:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	74 16                	je     80100835 <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
80100824:	83 e8 01             	sub    $0x1,%eax
80100827:	83 e0 7f             	and    $0x7f,%eax
8010082a:	0f b6 80 f4 ed 10 80 	movzbl -0x7fef120c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100831:	3c 0a                	cmp    $0xa,%al
80100833:	75 bf                	jne    801007f4 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100835:	e9 c1 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083a:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
80100840:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 1e                	je     80100867 <consoleintr+0xba>
        input.e--;
80100849:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 7c ee 10 80       	mov    %eax,0x8010ee7c
        consputc(BACKSPACE);
80100856:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010085d:	e8 ee fe ff ff       	call   80100750 <consputc>
      }
      break;
80100862:	e9 94 00 00 00       	jmp    801008fb <consoleintr+0x14e>
80100867:	e9 8f 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100870:	0f 84 84 00 00 00    	je     801008fa <consoleintr+0x14d>
80100876:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
8010087c:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
80100881:	29 c2                	sub    %eax,%edx
80100883:	89 d0                	mov    %edx,%eax
80100885:	83 f8 7f             	cmp    $0x7f,%eax
80100888:	77 70                	ja     801008fa <consoleintr+0x14d>
        c = (c == '\r') ? '\n' : c;
8010088a:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010088e:	74 05                	je     80100895 <consoleintr+0xe8>
80100890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100893:	eb 05                	jmp    8010089a <consoleintr+0xed>
80100895:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010089d:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801008a2:	8d 50 01             	lea    0x1(%eax),%edx
801008a5:	89 15 7c ee 10 80    	mov    %edx,0x8010ee7c
801008ab:	83 e0 7f             	and    $0x7f,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b3:	88 82 f4 ed 10 80    	mov    %al,-0x7fef120c(%edx)
        consputc(c);
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	89 04 24             	mov    %eax,(%esp)
801008bf:	e8 8c fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008c8:	74 18                	je     801008e2 <consoleintr+0x135>
801008ca:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008ce:	74 12                	je     801008e2 <consoleintr+0x135>
801008d0:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801008d5:	8b 15 74 ee 10 80    	mov    0x8010ee74,%edx
801008db:	83 ea 80             	sub    $0xffffff80,%edx
801008de:	39 d0                	cmp    %edx,%eax
801008e0:	75 18                	jne    801008fa <consoleintr+0x14d>
          input.w = input.e;
801008e2:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801008e7:	a3 78 ee 10 80       	mov    %eax,0x8010ee78
          wakeup(&input.r);
801008ec:	c7 04 24 74 ee 10 80 	movl   $0x8010ee74,(%esp)
801008f3:	e8 62 40 00 00       	call   8010495a <wakeup>
        }
      }
      break;
801008f8:	eb 00                	jmp    801008fa <consoleintr+0x14d>
801008fa:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801008fb:	8b 45 08             	mov    0x8(%ebp),%eax
801008fe:	ff d0                	call   *%eax
80100900:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100907:	0f 89 b7 fe ff ff    	jns    801007c4 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010090d:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100914:	e8 bd 46 00 00       	call   80104fd6 <release>
}
80100919:	c9                   	leave  
8010091a:	c3                   	ret    

8010091b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010091b:	55                   	push   %ebp
8010091c:	89 e5                	mov    %esp,%ebp
8010091e:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100921:	8b 45 08             	mov    0x8(%ebp),%eax
80100924:	89 04 24             	mov    %eax,(%esp)
80100927:	e8 8b 10 00 00       	call   801019b7 <iunlock>
  target = n;
8010092c:	8b 45 10             	mov    0x10(%ebp),%eax
8010092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100932:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100939:	e8 36 46 00 00       	call   80104f74 <acquire>
  while(n > 0){
8010093e:	e9 aa 00 00 00       	jmp    801009ed <consoleread+0xd2>
    while(input.r == input.w){
80100943:	eb 42                	jmp    80100987 <consoleread+0x6c>
      if(proc->killed){
80100945:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010094b:	8b 40 24             	mov    0x24(%eax),%eax
8010094e:	85 c0                	test   %eax,%eax
80100950:	74 21                	je     80100973 <consoleread+0x58>
        release(&input.lock);
80100952:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100959:	e8 78 46 00 00       	call   80104fd6 <release>
        ilock(ip);
8010095e:	8b 45 08             	mov    0x8(%ebp),%eax
80100961:	89 04 24             	mov    %eax,(%esp)
80100964:	e8 00 0f 00 00       	call   80101869 <ilock>
        return -1;
80100969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096e:	e9 a5 00 00 00       	jmp    80100a18 <consoleread+0xfd>
      }
      sleep(&input.r, &input.lock);
80100973:	c7 44 24 04 c0 ed 10 	movl   $0x8010edc0,0x4(%esp)
8010097a:	80 
8010097b:	c7 04 24 74 ee 10 80 	movl   $0x8010ee74,(%esp)
80100982:	e8 fa 3e 00 00       	call   80104881 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100987:	8b 15 74 ee 10 80    	mov    0x8010ee74,%edx
8010098d:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
80100992:	39 c2                	cmp    %eax,%edx
80100994:	74 af                	je     80100945 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100996:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
8010099b:	8d 50 01             	lea    0x1(%eax),%edx
8010099e:	89 15 74 ee 10 80    	mov    %edx,0x8010ee74
801009a4:	83 e0 7f             	and    $0x7f,%eax
801009a7:	0f b6 80 f4 ed 10 80 	movzbl -0x7fef120c(%eax),%eax
801009ae:	0f be c0             	movsbl %al,%eax
801009b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009b4:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009b8:	75 19                	jne    801009d3 <consoleread+0xb8>
      if(n < target){
801009ba:	8b 45 10             	mov    0x10(%ebp),%eax
801009bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009c0:	73 0f                	jae    801009d1 <consoleread+0xb6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c2:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
801009c7:	83 e8 01             	sub    $0x1,%eax
801009ca:	a3 74 ee 10 80       	mov    %eax,0x8010ee74
      }
      break;
801009cf:	eb 26                	jmp    801009f7 <consoleread+0xdc>
801009d1:	eb 24                	jmp    801009f7 <consoleread+0xdc>
    }
    *dst++ = c;
801009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801009d6:	8d 50 01             	lea    0x1(%eax),%edx
801009d9:	89 55 0c             	mov    %edx,0xc(%ebp)
801009dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009df:	88 10                	mov    %dl,(%eax)
    --n;
801009e1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009e5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009e9:	75 02                	jne    801009ed <consoleread+0xd2>
      break;
801009eb:	eb 0a                	jmp    801009f7 <consoleread+0xdc>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f1:	0f 8f 4c ff ff ff    	jg     80100943 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
801009f7:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
801009fe:	e8 d3 45 00 00       	call   80104fd6 <release>
  ilock(ip);
80100a03:	8b 45 08             	mov    0x8(%ebp),%eax
80100a06:	89 04 24             	mov    %eax,(%esp)
80100a09:	e8 5b 0e 00 00       	call   80101869 <ilock>

  return target - n;
80100a0e:	8b 45 10             	mov    0x10(%ebp),%eax
80100a11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a14:	29 c2                	sub    %eax,%edx
80100a16:	89 d0                	mov    %edx,%eax
}
80100a18:	c9                   	leave  
80100a19:	c3                   	ret    

80100a1a <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a1a:	55                   	push   %ebp
80100a1b:	89 e5                	mov    %esp,%ebp
80100a1d:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a20:	8b 45 08             	mov    0x8(%ebp),%eax
80100a23:	89 04 24             	mov    %eax,(%esp)
80100a26:	e8 8c 0f 00 00       	call   801019b7 <iunlock>
  acquire(&cons.lock);
80100a2b:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a32:	e8 3d 45 00 00       	call   80104f74 <acquire>
  for(i = 0; i < n; i++)
80100a37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a3e:	eb 1d                	jmp    80100a5d <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a43:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a46:	01 d0                	add    %edx,%eax
80100a48:	0f b6 00             	movzbl (%eax),%eax
80100a4b:	0f be c0             	movsbl %al,%eax
80100a4e:	0f b6 c0             	movzbl %al,%eax
80100a51:	89 04 24             	mov    %eax,(%esp)
80100a54:	e8 f7 fc ff ff       	call   80100750 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a60:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a63:	7c db                	jl     80100a40 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a65:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a6c:	e8 65 45 00 00       	call   80104fd6 <release>
  ilock(ip);
80100a71:	8b 45 08             	mov    0x8(%ebp),%eax
80100a74:	89 04 24             	mov    %eax,(%esp)
80100a77:	e8 ed 0d 00 00       	call   80101869 <ilock>

  return n;
80100a7c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a7f:	c9                   	leave  
80100a80:	c3                   	ret    

80100a81 <consoleinit>:

void
consoleinit(void)
{
80100a81:	55                   	push   %ebp
80100a82:	89 e5                	mov    %esp,%ebp
80100a84:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a87:	c7 44 24 04 a7 8b 10 	movl   $0x80108ba7,0x4(%esp)
80100a8e:	80 
80100a8f:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a96:	e8 b8 44 00 00       	call   80104f53 <initlock>
  initlock(&input.lock, "input");
80100a9b:	c7 44 24 04 af 8b 10 	movl   $0x80108baf,0x4(%esp)
80100aa2:	80 
80100aa3:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100aaa:	e8 a4 44 00 00       	call   80104f53 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aaf:	c7 05 2c f8 10 80 1a 	movl   $0x80100a1a,0x8010f82c
80100ab6:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab9:	c7 05 28 f8 10 80 1b 	movl   $0x8010091b,0x8010f828
80100ac0:	09 10 80 
  cons.locking = 1;
80100ac3:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100aca:	00 00 00 

  picenable(IRQ_KBD);
80100acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad4:	e8 a7 2f 00 00       	call   80103a80 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ad9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae0:	00 
80100ae1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ae8:	e8 7e 1e 00 00       	call   8010296b <ioapicenable>
}
80100aed:	c9                   	leave  
80100aee:	c3                   	ret    

80100aef <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100aef:	55                   	push   %ebp
80100af0:	89 e5                	mov    %esp,%ebp
80100af2:	53                   	push   %ebx
80100af3:	81 ec 34 01 00 00    	sub    $0x134,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100af9:	8b 45 08             	mov    0x8(%ebp),%eax
80100afc:	89 04 24             	mov    %eax,(%esp)
80100aff:	e8 10 19 00 00       	call   80102414 <namei>
80100b04:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b07:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b0b:	75 0a                	jne    80100b17 <exec+0x28>
    return -1;
80100b0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b12:	e9 f8 03 00 00       	jmp    80100f0f <exec+0x420>
  ilock(ip);
80100b17:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b1a:	89 04 24             	mov    %eax,(%esp)
80100b1d:	e8 47 0d 00 00       	call   80101869 <ilock>
  pgdir = 0;
80100b22:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b29:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b30:	00 
80100b31:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b38:	00 
80100b39:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b43:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b46:	89 04 24             	mov    %eax,(%esp)
80100b49:	e8 28 12 00 00       	call   80101d76 <readi>
80100b4e:	83 f8 33             	cmp    $0x33,%eax
80100b51:	77 05                	ja     80100b58 <exec+0x69>
    goto bad;
80100b53:	e9 90 03 00 00       	jmp    80100ee8 <exec+0x3f9>
  if(elf.magic != ELF_MAGIC)
80100b58:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100b5e:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b63:	74 05                	je     80100b6a <exec+0x7b>
    goto bad;
80100b65:	e9 7e 03 00 00       	jmp    80100ee8 <exec+0x3f9>

  if((pgdir = setupkvm(kalloc)) == 0)
80100b6a:	c7 04 24 f0 2a 10 80 	movl   $0x80102af0,(%esp)
80100b71:	e8 fb 71 00 00       	call   80107d71 <setupkvm>
80100b76:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b79:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b7d:	75 05                	jne    80100b84 <exec+0x95>
    goto bad;
80100b7f:	e9 64 03 00 00       	jmp    80100ee8 <exec+0x3f9>

  // Load program into memory.
  /*sz = 0*/
  sz = PGSIZE - 1; //3.2
80100b84:	c7 45 e0 ff 0f 00 00 	movl   $0xfff,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b8b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b92:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100b98:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100b9b:	e9 de 00 00 00       	jmp    80100c7e <exec+0x18f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ba0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ba3:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100baa:	00 
80100bab:	89 44 24 08          	mov    %eax,0x8(%esp)
80100baf:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100bb5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bbc:	89 04 24             	mov    %eax,(%esp)
80100bbf:	e8 b2 11 00 00       	call   80101d76 <readi>
80100bc4:	83 f8 20             	cmp    $0x20,%eax
80100bc7:	74 05                	je     80100bce <exec+0xdf>
      goto bad;
80100bc9:	e9 1a 03 00 00       	jmp    80100ee8 <exec+0x3f9>
    if(ph.type != ELF_PROG_LOAD)
80100bce:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100bd4:	83 f8 01             	cmp    $0x1,%eax
80100bd7:	74 05                	je     80100bde <exec+0xef>
      continue;
80100bd9:	e9 93 00 00 00       	jmp    80100c71 <exec+0x182>
    if(ph.memsz < ph.filesz)
80100bde:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100be4:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100bea:	39 c2                	cmp    %eax,%edx
80100bec:	73 05                	jae    80100bf3 <exec+0x104>
      goto bad;
80100bee:	e9 f5 02 00 00       	jmp    80100ee8 <exec+0x3f9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bf3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100bf9:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bff:	01 d0                	add    %edx,%eax
80100c01:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c08:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 42 75 00 00       	call   80108159 <allocuvm>
80100c17:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c1a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c1e:	75 05                	jne    80100c25 <exec+0x136>
      goto bad;
80100c20:	e9 c3 02 00 00       	jmp    80100ee8 <exec+0x3f9>

    uint flagWriteELF = ph.flags & ELF_PROG_FLAG_WRITE; //3.3
80100c25:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c2b:	83 e0 02             	and    $0x2,%eax
80100c2e:	89 45 d0             	mov    %eax,-0x30(%ebp)
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz,flagWriteELF) < 0)
80100c31:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80100c37:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100c3d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c43:	8b 5d d0             	mov    -0x30(%ebp),%ebx
80100c46:	89 5c 24 14          	mov    %ebx,0x14(%esp)
80100c4a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c4e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c52:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c55:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c59:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c5d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c60:	89 04 24             	mov    %eax,(%esp)
80100c63:	e8 ec 73 00 00       	call   80108054 <loaduvm>
80100c68:	85 c0                	test   %eax,%eax
80100c6a:	79 05                	jns    80100c71 <exec+0x182>
      goto bad;
80100c6c:	e9 77 02 00 00       	jmp    80100ee8 <exec+0x3f9>
    goto bad;

  // Load program into memory.
  /*sz = 0*/
  sz = PGSIZE - 1; //3.2
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c71:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c75:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c78:	83 c0 20             	add    $0x20,%eax
80100c7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c7e:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100c85:	0f b7 c0             	movzwl %ax,%eax
80100c88:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c8b:	0f 8f 0f ff ff ff    	jg     80100ba0 <exec+0xb1>

    uint flagWriteELF = ph.flags & ELF_PROG_FLAG_WRITE; //3.3
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz,flagWriteELF) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c91:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c94:	89 04 24             	mov    %eax,(%esp)
80100c97:	e8 51 0e 00 00       	call   80101aed <iunlockput>
  ip = 0;
80100c9c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100ca3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ca6:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb6:	05 00 20 00 00       	add    $0x2000,%eax
80100cbb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cc9:	89 04 24             	mov    %eax,(%esp)
80100ccc:	e8 88 74 00 00       	call   80108159 <allocuvm>
80100cd1:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cd4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cd8:	75 05                	jne    80100cdf <exec+0x1f0>
    goto bad;
80100cda:	e9 09 02 00 00       	jmp    80100ee8 <exec+0x3f9>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cdf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce2:	2d 00 20 00 00       	sub    $0x2000,%eax
80100ce7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ceb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 7e 78 00 00       	call   80108574 <clearpteu>
  sp = sz;
80100cf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cf9:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cfc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d03:	e9 9a 00 00 00       	jmp    80100da2 <exec+0x2b3>
    if(argc >= MAXARG)
80100d08:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d0c:	76 05                	jbe    80100d13 <exec+0x224>
      goto bad;
80100d0e:	e9 d5 01 00 00       	jmp    80100ee8 <exec+0x3f9>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d20:	01 d0                	add    %edx,%eax
80100d22:	8b 00                	mov    (%eax),%eax
80100d24:	89 04 24             	mov    %eax,(%esp)
80100d27:	e8 06 47 00 00       	call   80105432 <strlen>
80100d2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d2f:	29 c2                	sub    %eax,%edx
80100d31:	89 d0                	mov    %edx,%eax
80100d33:	83 e8 01             	sub    $0x1,%eax
80100d36:	83 e0 fc             	and    $0xfffffffc,%eax
80100d39:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d46:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d49:	01 d0                	add    %edx,%eax
80100d4b:	8b 00                	mov    (%eax),%eax
80100d4d:	89 04 24             	mov    %eax,(%esp)
80100d50:	e8 dd 46 00 00       	call   80105432 <strlen>
80100d55:	83 c0 01             	add    $0x1,%eax
80100d58:	89 c2                	mov    %eax,%edx
80100d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d5d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d64:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d67:	01 c8                	add    %ecx,%eax
80100d69:	8b 00                	mov    (%eax),%eax
80100d6b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d6f:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d73:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d76:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d7d:	89 04 24             	mov    %eax,(%esp)
80100d80:	e8 e9 79 00 00       	call   8010876e <copyout>
80100d85:	85 c0                	test   %eax,%eax
80100d87:	79 05                	jns    80100d8e <exec+0x29f>
      goto bad;
80100d89:	e9 5a 01 00 00       	jmp    80100ee8 <exec+0x3f9>
    ustack[3+argc] = sp;
80100d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d91:	8d 50 03             	lea    0x3(%eax),%edx
80100d94:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d97:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d9e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100da2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dac:	8b 45 0c             	mov    0xc(%ebp),%eax
80100daf:	01 d0                	add    %edx,%eax
80100db1:	8b 00                	mov    (%eax),%eax
80100db3:	85 c0                	test   %eax,%eax
80100db5:	0f 85 4d ff ff ff    	jne    80100d08 <exec+0x219>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dbe:	83 c0 03             	add    $0x3,%eax
80100dc1:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100dc8:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dcc:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100dd3:	ff ff ff 
  ustack[1] = argc;
80100dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd9:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de2:	83 c0 01             	add    $0x1,%eax
80100de5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dec:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100def:	29 d0                	sub    %edx,%eax
80100df1:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfa:	83 c0 04             	add    $0x4,%eax
80100dfd:	c1 e0 02             	shl    $0x2,%eax
80100e00:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e06:	83 c0 04             	add    $0x4,%eax
80100e09:	c1 e0 02             	shl    $0x2,%eax
80100e0c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e10:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100e16:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e24:	89 04 24             	mov    %eax,(%esp)
80100e27:	e8 42 79 00 00       	call   8010876e <copyout>
80100e2c:	85 c0                	test   %eax,%eax
80100e2e:	79 05                	jns    80100e35 <exec+0x346>
    goto bad;
80100e30:	e9 b3 00 00 00       	jmp    80100ee8 <exec+0x3f9>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e35:	8b 45 08             	mov    0x8(%ebp),%eax
80100e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e41:	eb 17                	jmp    80100e5a <exec+0x36b>
    if(*s == '/')
80100e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e46:	0f b6 00             	movzbl (%eax),%eax
80100e49:	3c 2f                	cmp    $0x2f,%al
80100e4b:	75 09                	jne    80100e56 <exec+0x367>
      last = s+1;
80100e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e50:	83 c0 01             	add    $0x1,%eax
80100e53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e56:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e5d:	0f b6 00             	movzbl (%eax),%eax
80100e60:	84 c0                	test   %al,%al
80100e62:	75 df                	jne    80100e43 <exec+0x354>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e6a:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e6d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e74:	00 
80100e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e78:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e7c:	89 14 24             	mov    %edx,(%esp)
80100e7f:	e8 64 45 00 00       	call   801053e8 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e8a:	8b 40 04             	mov    0x4(%eax),%eax
80100e8d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  proc->pgdir = pgdir;
80100e90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e96:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e99:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea2:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ea5:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ea7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ead:	8b 40 18             	mov    0x18(%eax),%eax
80100eb0:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100eb6:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100eb9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebf:	8b 40 18             	mov    0x18(%eax),%eax
80100ec2:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ec5:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ec8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ece:	89 04 24             	mov    %eax,(%esp)
80100ed1:	e8 8c 6f 00 00       	call   80107e62 <switchuvm>
  freevm(oldpgdir);
80100ed6:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100ed9:	89 04 24             	mov    %eax,(%esp)
80100edc:	e8 f9 75 00 00       	call   801084da <freevm>
  return 0;
80100ee1:	b8 00 00 00 00       	mov    $0x0,%eax
80100ee6:	eb 27                	jmp    80100f0f <exec+0x420>

 bad:
  if(pgdir)
80100ee8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100eec:	74 0b                	je     80100ef9 <exec+0x40a>
    freevm(pgdir);
80100eee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ef1:	89 04 24             	mov    %eax,(%esp)
80100ef4:	e8 e1 75 00 00       	call   801084da <freevm>
  if(ip)
80100ef9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100efd:	74 0b                	je     80100f0a <exec+0x41b>
    iunlockput(ip);
80100eff:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 e3 0b 00 00       	call   80101aed <iunlockput>
  return -1;
80100f0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f0f:	81 c4 34 01 00 00    	add    $0x134,%esp
80100f15:	5b                   	pop    %ebx
80100f16:	5d                   	pop    %ebp
80100f17:	c3                   	ret    

80100f18 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f18:	55                   	push   %ebp
80100f19:	89 e5                	mov    %esp,%ebp
80100f1b:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f1e:	c7 44 24 04 b5 8b 10 	movl   $0x80108bb5,0x4(%esp)
80100f25:	80 
80100f26:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f2d:	e8 21 40 00 00       	call   80104f53 <initlock>
}
80100f32:	c9                   	leave  
80100f33:	c3                   	ret    

80100f34 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f34:	55                   	push   %ebp
80100f35:	89 e5                	mov    %esp,%ebp
80100f37:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f3a:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f41:	e8 2e 40 00 00       	call   80104f74 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f46:	c7 45 f4 b4 ee 10 80 	movl   $0x8010eeb4,-0xc(%ebp)
80100f4d:	eb 29                	jmp    80100f78 <filealloc+0x44>
    if(f->ref == 0){
80100f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f52:	8b 40 04             	mov    0x4(%eax),%eax
80100f55:	85 c0                	test   %eax,%eax
80100f57:	75 1b                	jne    80100f74 <filealloc+0x40>
      f->ref = 1;
80100f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f5c:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f63:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f6a:	e8 67 40 00 00       	call   80104fd6 <release>
      return f;
80100f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f72:	eb 1e                	jmp    80100f92 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f74:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f78:	81 7d f4 14 f8 10 80 	cmpl   $0x8010f814,-0xc(%ebp)
80100f7f:	72 ce                	jb     80100f4f <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f81:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f88:	e8 49 40 00 00       	call   80104fd6 <release>
  return 0;
80100f8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f92:	c9                   	leave  
80100f93:	c3                   	ret    

80100f94 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f94:	55                   	push   %ebp
80100f95:	89 e5                	mov    %esp,%ebp
80100f97:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f9a:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100fa1:	e8 ce 3f 00 00       	call   80104f74 <acquire>
  if(f->ref < 1)
80100fa6:	8b 45 08             	mov    0x8(%ebp),%eax
80100fa9:	8b 40 04             	mov    0x4(%eax),%eax
80100fac:	85 c0                	test   %eax,%eax
80100fae:	7f 0c                	jg     80100fbc <filedup+0x28>
    panic("filedup");
80100fb0:	c7 04 24 bc 8b 10 80 	movl   $0x80108bbc,(%esp)
80100fb7:	e8 7e f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fbc:	8b 45 08             	mov    0x8(%ebp),%eax
80100fbf:	8b 40 04             	mov    0x4(%eax),%eax
80100fc2:	8d 50 01             	lea    0x1(%eax),%edx
80100fc5:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc8:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fcb:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100fd2:	e8 ff 3f 00 00       	call   80104fd6 <release>
  return f;
80100fd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fda:	c9                   	leave  
80100fdb:	c3                   	ret    

80100fdc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fdc:	55                   	push   %ebp
80100fdd:	89 e5                	mov    %esp,%ebp
80100fdf:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fe2:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100fe9:	e8 86 3f 00 00       	call   80104f74 <acquire>
  if(f->ref < 1)
80100fee:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff1:	8b 40 04             	mov    0x4(%eax),%eax
80100ff4:	85 c0                	test   %eax,%eax
80100ff6:	7f 0c                	jg     80101004 <fileclose+0x28>
    panic("fileclose");
80100ff8:	c7 04 24 c4 8b 10 80 	movl   $0x80108bc4,(%esp)
80100fff:	e8 36 f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80101004:	8b 45 08             	mov    0x8(%ebp),%eax
80101007:	8b 40 04             	mov    0x4(%eax),%eax
8010100a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010100d:	8b 45 08             	mov    0x8(%ebp),%eax
80101010:	89 50 04             	mov    %edx,0x4(%eax)
80101013:	8b 45 08             	mov    0x8(%ebp),%eax
80101016:	8b 40 04             	mov    0x4(%eax),%eax
80101019:	85 c0                	test   %eax,%eax
8010101b:	7e 11                	jle    8010102e <fileclose+0x52>
    release(&ftable.lock);
8010101d:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80101024:	e8 ad 3f 00 00       	call   80104fd6 <release>
80101029:	e9 82 00 00 00       	jmp    801010b0 <fileclose+0xd4>
    return;
  }
  ff = *f;
8010102e:	8b 45 08             	mov    0x8(%ebp),%eax
80101031:	8b 10                	mov    (%eax),%edx
80101033:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101036:	8b 50 04             	mov    0x4(%eax),%edx
80101039:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010103c:	8b 50 08             	mov    0x8(%eax),%edx
8010103f:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101042:	8b 50 0c             	mov    0xc(%eax),%edx
80101045:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101048:	8b 50 10             	mov    0x10(%eax),%edx
8010104b:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010104e:	8b 40 14             	mov    0x14(%eax),%eax
80101051:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101054:	8b 45 08             	mov    0x8(%ebp),%eax
80101057:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010105e:	8b 45 08             	mov    0x8(%ebp),%eax
80101061:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101067:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
8010106e:	e8 63 3f 00 00       	call   80104fd6 <release>
  
  if(ff.type == FD_PIPE)
80101073:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101076:	83 f8 01             	cmp    $0x1,%eax
80101079:	75 18                	jne    80101093 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
8010107b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010107f:	0f be d0             	movsbl %al,%edx
80101082:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101085:	89 54 24 04          	mov    %edx,0x4(%esp)
80101089:	89 04 24             	mov    %eax,(%esp)
8010108c:	e8 9f 2c 00 00       	call   80103d30 <pipeclose>
80101091:	eb 1d                	jmp    801010b0 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
80101093:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101096:	83 f8 02             	cmp    $0x2,%eax
80101099:	75 15                	jne    801010b0 <fileclose+0xd4>
    begin_trans();
8010109b:	e8 53 21 00 00       	call   801031f3 <begin_trans>
    iput(ff.ip);
801010a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010a3:	89 04 24             	mov    %eax,(%esp)
801010a6:	e8 71 09 00 00       	call   80101a1c <iput>
    commit_trans();
801010ab:	e8 8c 21 00 00       	call   8010323c <commit_trans>
  }
}
801010b0:	c9                   	leave  
801010b1:	c3                   	ret    

801010b2 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010b2:	55                   	push   %ebp
801010b3:	89 e5                	mov    %esp,%ebp
801010b5:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010b8:	8b 45 08             	mov    0x8(%ebp),%eax
801010bb:	8b 00                	mov    (%eax),%eax
801010bd:	83 f8 02             	cmp    $0x2,%eax
801010c0:	75 38                	jne    801010fa <filestat+0x48>
    ilock(f->ip);
801010c2:	8b 45 08             	mov    0x8(%ebp),%eax
801010c5:	8b 40 10             	mov    0x10(%eax),%eax
801010c8:	89 04 24             	mov    %eax,(%esp)
801010cb:	e8 99 07 00 00       	call   80101869 <ilock>
    stati(f->ip, st);
801010d0:	8b 45 08             	mov    0x8(%ebp),%eax
801010d3:	8b 40 10             	mov    0x10(%eax),%eax
801010d6:	8b 55 0c             	mov    0xc(%ebp),%edx
801010d9:	89 54 24 04          	mov    %edx,0x4(%esp)
801010dd:	89 04 24             	mov    %eax,(%esp)
801010e0:	e8 4c 0c 00 00       	call   80101d31 <stati>
    iunlock(f->ip);
801010e5:	8b 45 08             	mov    0x8(%ebp),%eax
801010e8:	8b 40 10             	mov    0x10(%eax),%eax
801010eb:	89 04 24             	mov    %eax,(%esp)
801010ee:	e8 c4 08 00 00       	call   801019b7 <iunlock>
    return 0;
801010f3:	b8 00 00 00 00       	mov    $0x0,%eax
801010f8:	eb 05                	jmp    801010ff <filestat+0x4d>
  }
  return -1;
801010fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010ff:	c9                   	leave  
80101100:	c3                   	ret    

80101101 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101101:	55                   	push   %ebp
80101102:	89 e5                	mov    %esp,%ebp
80101104:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101107:	8b 45 08             	mov    0x8(%ebp),%eax
8010110a:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010110e:	84 c0                	test   %al,%al
80101110:	75 0a                	jne    8010111c <fileread+0x1b>
    return -1;
80101112:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101117:	e9 9f 00 00 00       	jmp    801011bb <fileread+0xba>
  if(f->type == FD_PIPE)
8010111c:	8b 45 08             	mov    0x8(%ebp),%eax
8010111f:	8b 00                	mov    (%eax),%eax
80101121:	83 f8 01             	cmp    $0x1,%eax
80101124:	75 1e                	jne    80101144 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101126:	8b 45 08             	mov    0x8(%ebp),%eax
80101129:	8b 40 0c             	mov    0xc(%eax),%eax
8010112c:	8b 55 10             	mov    0x10(%ebp),%edx
8010112f:	89 54 24 08          	mov    %edx,0x8(%esp)
80101133:	8b 55 0c             	mov    0xc(%ebp),%edx
80101136:	89 54 24 04          	mov    %edx,0x4(%esp)
8010113a:	89 04 24             	mov    %eax,(%esp)
8010113d:	e8 6f 2d 00 00       	call   80103eb1 <piperead>
80101142:	eb 77                	jmp    801011bb <fileread+0xba>
  if(f->type == FD_INODE){
80101144:	8b 45 08             	mov    0x8(%ebp),%eax
80101147:	8b 00                	mov    (%eax),%eax
80101149:	83 f8 02             	cmp    $0x2,%eax
8010114c:	75 61                	jne    801011af <fileread+0xae>
    ilock(f->ip);
8010114e:	8b 45 08             	mov    0x8(%ebp),%eax
80101151:	8b 40 10             	mov    0x10(%eax),%eax
80101154:	89 04 24             	mov    %eax,(%esp)
80101157:	e8 0d 07 00 00       	call   80101869 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010115c:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010115f:	8b 45 08             	mov    0x8(%ebp),%eax
80101162:	8b 50 14             	mov    0x14(%eax),%edx
80101165:	8b 45 08             	mov    0x8(%ebp),%eax
80101168:	8b 40 10             	mov    0x10(%eax),%eax
8010116b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010116f:	89 54 24 08          	mov    %edx,0x8(%esp)
80101173:	8b 55 0c             	mov    0xc(%ebp),%edx
80101176:	89 54 24 04          	mov    %edx,0x4(%esp)
8010117a:	89 04 24             	mov    %eax,(%esp)
8010117d:	e8 f4 0b 00 00       	call   80101d76 <readi>
80101182:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101185:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101189:	7e 11                	jle    8010119c <fileread+0x9b>
      f->off += r;
8010118b:	8b 45 08             	mov    0x8(%ebp),%eax
8010118e:	8b 50 14             	mov    0x14(%eax),%edx
80101191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101194:	01 c2                	add    %eax,%edx
80101196:	8b 45 08             	mov    0x8(%ebp),%eax
80101199:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010119c:	8b 45 08             	mov    0x8(%ebp),%eax
8010119f:	8b 40 10             	mov    0x10(%eax),%eax
801011a2:	89 04 24             	mov    %eax,(%esp)
801011a5:	e8 0d 08 00 00       	call   801019b7 <iunlock>
    return r;
801011aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ad:	eb 0c                	jmp    801011bb <fileread+0xba>
  }
  panic("fileread");
801011af:	c7 04 24 ce 8b 10 80 	movl   $0x80108bce,(%esp)
801011b6:	e8 7f f3 ff ff       	call   8010053a <panic>
}
801011bb:	c9                   	leave  
801011bc:	c3                   	ret    

801011bd <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011bd:	55                   	push   %ebp
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	53                   	push   %ebx
801011c1:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011c4:	8b 45 08             	mov    0x8(%ebp),%eax
801011c7:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011cb:	84 c0                	test   %al,%al
801011cd:	75 0a                	jne    801011d9 <filewrite+0x1c>
    return -1;
801011cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011d4:	e9 20 01 00 00       	jmp    801012f9 <filewrite+0x13c>
  if(f->type == FD_PIPE)
801011d9:	8b 45 08             	mov    0x8(%ebp),%eax
801011dc:	8b 00                	mov    (%eax),%eax
801011de:	83 f8 01             	cmp    $0x1,%eax
801011e1:	75 21                	jne    80101204 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011e3:	8b 45 08             	mov    0x8(%ebp),%eax
801011e6:	8b 40 0c             	mov    0xc(%eax),%eax
801011e9:	8b 55 10             	mov    0x10(%ebp),%edx
801011ec:	89 54 24 08          	mov    %edx,0x8(%esp)
801011f0:	8b 55 0c             	mov    0xc(%ebp),%edx
801011f3:	89 54 24 04          	mov    %edx,0x4(%esp)
801011f7:	89 04 24             	mov    %eax,(%esp)
801011fa:	e8 c3 2b 00 00       	call   80103dc2 <pipewrite>
801011ff:	e9 f5 00 00 00       	jmp    801012f9 <filewrite+0x13c>
  if(f->type == FD_INODE){
80101204:	8b 45 08             	mov    0x8(%ebp),%eax
80101207:	8b 00                	mov    (%eax),%eax
80101209:	83 f8 02             	cmp    $0x2,%eax
8010120c:	0f 85 db 00 00 00    	jne    801012ed <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101212:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101219:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101220:	e9 a8 00 00 00       	jmp    801012cd <filewrite+0x110>
      int n1 = n - i;
80101225:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101228:	8b 55 10             	mov    0x10(%ebp),%edx
8010122b:	29 c2                	sub    %eax,%edx
8010122d:	89 d0                	mov    %edx,%eax
8010122f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101232:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101235:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101238:	7e 06                	jle    80101240 <filewrite+0x83>
        n1 = max;
8010123a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010123d:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
80101240:	e8 ae 1f 00 00       	call   801031f3 <begin_trans>
      ilock(f->ip);
80101245:	8b 45 08             	mov    0x8(%ebp),%eax
80101248:	8b 40 10             	mov    0x10(%eax),%eax
8010124b:	89 04 24             	mov    %eax,(%esp)
8010124e:	e8 16 06 00 00       	call   80101869 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101253:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101256:	8b 45 08             	mov    0x8(%ebp),%eax
80101259:	8b 50 14             	mov    0x14(%eax),%edx
8010125c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010125f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101262:	01 c3                	add    %eax,%ebx
80101264:	8b 45 08             	mov    0x8(%ebp),%eax
80101267:	8b 40 10             	mov    0x10(%eax),%eax
8010126a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010126e:	89 54 24 08          	mov    %edx,0x8(%esp)
80101272:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101276:	89 04 24             	mov    %eax,(%esp)
80101279:	e8 5c 0c 00 00       	call   80101eda <writei>
8010127e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101281:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101285:	7e 11                	jle    80101298 <filewrite+0xdb>
        f->off += r;
80101287:	8b 45 08             	mov    0x8(%ebp),%eax
8010128a:	8b 50 14             	mov    0x14(%eax),%edx
8010128d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101290:	01 c2                	add    %eax,%edx
80101292:	8b 45 08             	mov    0x8(%ebp),%eax
80101295:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101298:	8b 45 08             	mov    0x8(%ebp),%eax
8010129b:	8b 40 10             	mov    0x10(%eax),%eax
8010129e:	89 04 24             	mov    %eax,(%esp)
801012a1:	e8 11 07 00 00       	call   801019b7 <iunlock>
      commit_trans();
801012a6:	e8 91 1f 00 00       	call   8010323c <commit_trans>

      if(r < 0)
801012ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012af:	79 02                	jns    801012b3 <filewrite+0xf6>
        break;
801012b1:	eb 26                	jmp    801012d9 <filewrite+0x11c>
      if(r != n1)
801012b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012b6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012b9:	74 0c                	je     801012c7 <filewrite+0x10a>
        panic("short filewrite");
801012bb:	c7 04 24 d7 8b 10 80 	movl   $0x80108bd7,(%esp)
801012c2:	e8 73 f2 ff ff       	call   8010053a <panic>
      i += r;
801012c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012ca:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012d0:	3b 45 10             	cmp    0x10(%ebp),%eax
801012d3:	0f 8c 4c ff ff ff    	jl     80101225 <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012dc:	3b 45 10             	cmp    0x10(%ebp),%eax
801012df:	75 05                	jne    801012e6 <filewrite+0x129>
801012e1:	8b 45 10             	mov    0x10(%ebp),%eax
801012e4:	eb 05                	jmp    801012eb <filewrite+0x12e>
801012e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012eb:	eb 0c                	jmp    801012f9 <filewrite+0x13c>
  }
  panic("filewrite");
801012ed:	c7 04 24 e7 8b 10 80 	movl   $0x80108be7,(%esp)
801012f4:	e8 41 f2 ff ff       	call   8010053a <panic>
}
801012f9:	83 c4 24             	add    $0x24,%esp
801012fc:	5b                   	pop    %ebx
801012fd:	5d                   	pop    %ebp
801012fe:	c3                   	ret    

801012ff <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012ff:	55                   	push   %ebp
80101300:	89 e5                	mov    %esp,%ebp
80101302:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101305:	8b 45 08             	mov    0x8(%ebp),%eax
80101308:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010130f:	00 
80101310:	89 04 24             	mov    %eax,(%esp)
80101313:	e8 8e ee ff ff       	call   801001a6 <bread>
80101318:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010131b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010131e:	83 c0 18             	add    $0x18,%eax
80101321:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101328:	00 
80101329:	89 44 24 04          	mov    %eax,0x4(%esp)
8010132d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101330:	89 04 24             	mov    %eax,(%esp)
80101333:	e8 5f 3f 00 00       	call   80105297 <memmove>
  brelse(bp);
80101338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010133b:	89 04 24             	mov    %eax,(%esp)
8010133e:	e8 d4 ee ff ff       	call   80100217 <brelse>
}
80101343:	c9                   	leave  
80101344:	c3                   	ret    

80101345 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101345:	55                   	push   %ebp
80101346:	89 e5                	mov    %esp,%ebp
80101348:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010134b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010134e:	8b 45 08             	mov    0x8(%ebp),%eax
80101351:	89 54 24 04          	mov    %edx,0x4(%esp)
80101355:	89 04 24             	mov    %eax,(%esp)
80101358:	e8 49 ee ff ff       	call   801001a6 <bread>
8010135d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101360:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101363:	83 c0 18             	add    $0x18,%eax
80101366:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010136d:	00 
8010136e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101375:	00 
80101376:	89 04 24             	mov    %eax,(%esp)
80101379:	e8 4a 3e 00 00       	call   801051c8 <memset>
  log_write(bp);
8010137e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101381:	89 04 24             	mov    %eax,(%esp)
80101384:	e8 0b 1f 00 00       	call   80103294 <log_write>
  brelse(bp);
80101389:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010138c:	89 04 24             	mov    %eax,(%esp)
8010138f:	e8 83 ee ff ff       	call   80100217 <brelse>
}
80101394:	c9                   	leave  
80101395:	c3                   	ret    

80101396 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101396:	55                   	push   %ebp
80101397:	89 e5                	mov    %esp,%ebp
80101399:	83 ec 38             	sub    $0x38,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
8010139c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013a3:	8b 45 08             	mov    0x8(%ebp),%eax
801013a6:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801013ad:	89 04 24             	mov    %eax,(%esp)
801013b0:	e8 4a ff ff ff       	call   801012ff <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013bc:	e9 07 01 00 00       	jmp    801014c8 <balloc+0x132>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c4:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013ca:	85 c0                	test   %eax,%eax
801013cc:	0f 48 c2             	cmovs  %edx,%eax
801013cf:	c1 f8 0c             	sar    $0xc,%eax
801013d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013d5:	c1 ea 03             	shr    $0x3,%edx
801013d8:	01 d0                	add    %edx,%eax
801013da:	83 c0 03             	add    $0x3,%eax
801013dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801013e1:	8b 45 08             	mov    0x8(%ebp),%eax
801013e4:	89 04 24             	mov    %eax,(%esp)
801013e7:	e8 ba ed ff ff       	call   801001a6 <bread>
801013ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013f6:	e9 9d 00 00 00       	jmp    80101498 <balloc+0x102>
      m = 1 << (bi % 8);
801013fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013fe:	99                   	cltd   
801013ff:	c1 ea 1d             	shr    $0x1d,%edx
80101402:	01 d0                	add    %edx,%eax
80101404:	83 e0 07             	and    $0x7,%eax
80101407:	29 d0                	sub    %edx,%eax
80101409:	ba 01 00 00 00       	mov    $0x1,%edx
8010140e:	89 c1                	mov    %eax,%ecx
80101410:	d3 e2                	shl    %cl,%edx
80101412:	89 d0                	mov    %edx,%eax
80101414:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101417:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010141a:	8d 50 07             	lea    0x7(%eax),%edx
8010141d:	85 c0                	test   %eax,%eax
8010141f:	0f 48 c2             	cmovs  %edx,%eax
80101422:	c1 f8 03             	sar    $0x3,%eax
80101425:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101428:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010142d:	0f b6 c0             	movzbl %al,%eax
80101430:	23 45 e8             	and    -0x18(%ebp),%eax
80101433:	85 c0                	test   %eax,%eax
80101435:	75 5d                	jne    80101494 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
80101437:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010143a:	8d 50 07             	lea    0x7(%eax),%edx
8010143d:	85 c0                	test   %eax,%eax
8010143f:	0f 48 c2             	cmovs  %edx,%eax
80101442:	c1 f8 03             	sar    $0x3,%eax
80101445:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101448:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010144d:	89 d1                	mov    %edx,%ecx
8010144f:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101452:	09 ca                	or     %ecx,%edx
80101454:	89 d1                	mov    %edx,%ecx
80101456:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101459:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010145d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101460:	89 04 24             	mov    %eax,(%esp)
80101463:	e8 2c 1e 00 00       	call   80103294 <log_write>
        brelse(bp);
80101468:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010146b:	89 04 24             	mov    %eax,(%esp)
8010146e:	e8 a4 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101473:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101476:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101479:	01 c2                	add    %eax,%edx
8010147b:	8b 45 08             	mov    0x8(%ebp),%eax
8010147e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101482:	89 04 24             	mov    %eax,(%esp)
80101485:	e8 bb fe ff ff       	call   80101345 <bzero>
        return b + bi;
8010148a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101490:	01 d0                	add    %edx,%eax
80101492:	eb 4e                	jmp    801014e2 <balloc+0x14c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101494:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101498:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010149f:	7f 15                	jg     801014b6 <balloc+0x120>
801014a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014a7:	01 d0                	add    %edx,%eax
801014a9:	89 c2                	mov    %eax,%edx
801014ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014ae:	39 c2                	cmp    %eax,%edx
801014b0:	0f 82 45 ff ff ff    	jb     801013fb <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014b9:	89 04 24             	mov    %eax,(%esp)
801014bc:	e8 56 ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014c1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014ce:	39 c2                	cmp    %eax,%edx
801014d0:	0f 82 eb fe ff ff    	jb     801013c1 <balloc+0x2b>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014d6:	c7 04 24 f1 8b 10 80 	movl   $0x80108bf1,(%esp)
801014dd:	e8 58 f0 ff ff       	call   8010053a <panic>
}
801014e2:	c9                   	leave  
801014e3:	c3                   	ret    

801014e4 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014e4:	55                   	push   %ebp
801014e5:	89 e5                	mov    %esp,%ebp
801014e7:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014ea:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801014f1:	8b 45 08             	mov    0x8(%ebp),%eax
801014f4:	89 04 24             	mov    %eax,(%esp)
801014f7:	e8 03 fe ff ff       	call   801012ff <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
801014fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801014ff:	c1 e8 0c             	shr    $0xc,%eax
80101502:	89 c2                	mov    %eax,%edx
80101504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101507:	c1 e8 03             	shr    $0x3,%eax
8010150a:	01 d0                	add    %edx,%eax
8010150c:	8d 50 03             	lea    0x3(%eax),%edx
8010150f:	8b 45 08             	mov    0x8(%ebp),%eax
80101512:	89 54 24 04          	mov    %edx,0x4(%esp)
80101516:	89 04 24             	mov    %eax,(%esp)
80101519:	e8 88 ec ff ff       	call   801001a6 <bread>
8010151e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101521:	8b 45 0c             	mov    0xc(%ebp),%eax
80101524:	25 ff 0f 00 00       	and    $0xfff,%eax
80101529:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010152c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010152f:	99                   	cltd   
80101530:	c1 ea 1d             	shr    $0x1d,%edx
80101533:	01 d0                	add    %edx,%eax
80101535:	83 e0 07             	and    $0x7,%eax
80101538:	29 d0                	sub    %edx,%eax
8010153a:	ba 01 00 00 00       	mov    $0x1,%edx
8010153f:	89 c1                	mov    %eax,%ecx
80101541:	d3 e2                	shl    %cl,%edx
80101543:	89 d0                	mov    %edx,%eax
80101545:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101548:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154b:	8d 50 07             	lea    0x7(%eax),%edx
8010154e:	85 c0                	test   %eax,%eax
80101550:	0f 48 c2             	cmovs  %edx,%eax
80101553:	c1 f8 03             	sar    $0x3,%eax
80101556:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101559:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010155e:	0f b6 c0             	movzbl %al,%eax
80101561:	23 45 ec             	and    -0x14(%ebp),%eax
80101564:	85 c0                	test   %eax,%eax
80101566:	75 0c                	jne    80101574 <bfree+0x90>
    panic("freeing free block");
80101568:	c7 04 24 07 8c 10 80 	movl   $0x80108c07,(%esp)
8010156f:	e8 c6 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
80101574:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101577:	8d 50 07             	lea    0x7(%eax),%edx
8010157a:	85 c0                	test   %eax,%eax
8010157c:	0f 48 c2             	cmovs  %edx,%eax
8010157f:	c1 f8 03             	sar    $0x3,%eax
80101582:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101585:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010158a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010158d:	f7 d1                	not    %ecx
8010158f:	21 ca                	and    %ecx,%edx
80101591:	89 d1                	mov    %edx,%ecx
80101593:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101596:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010159d:	89 04 24             	mov    %eax,(%esp)
801015a0:	e8 ef 1c 00 00       	call   80103294 <log_write>
  brelse(bp);
801015a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015a8:	89 04 24             	mov    %eax,(%esp)
801015ab:	e8 67 ec ff ff       	call   80100217 <brelse>
}
801015b0:	c9                   	leave  
801015b1:	c3                   	ret    

801015b2 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015b2:	55                   	push   %ebp
801015b3:	89 e5                	mov    %esp,%ebp
801015b5:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015b8:	c7 44 24 04 1a 8c 10 	movl   $0x80108c1a,0x4(%esp)
801015bf:	80 
801015c0:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801015c7:	e8 87 39 00 00       	call   80104f53 <initlock>
}
801015cc:	c9                   	leave  
801015cd:	c3                   	ret    

801015ce <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015ce:	55                   	push   %ebp
801015cf:	89 e5                	mov    %esp,%ebp
801015d1:	83 ec 38             	sub    $0x38,%esp
801015d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801015d7:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015db:	8b 45 08             	mov    0x8(%ebp),%eax
801015de:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015e1:	89 54 24 04          	mov    %edx,0x4(%esp)
801015e5:	89 04 24             	mov    %eax,(%esp)
801015e8:	e8 12 fd ff ff       	call   801012ff <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015ed:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801015f4:	e9 98 00 00 00       	jmp    80101691 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
801015f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015fc:	c1 e8 03             	shr    $0x3,%eax
801015ff:	83 c0 02             	add    $0x2,%eax
80101602:	89 44 24 04          	mov    %eax,0x4(%esp)
80101606:	8b 45 08             	mov    0x8(%ebp),%eax
80101609:	89 04 24             	mov    %eax,(%esp)
8010160c:	e8 95 eb ff ff       	call   801001a6 <bread>
80101611:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101614:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101617:	8d 50 18             	lea    0x18(%eax),%edx
8010161a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010161d:	83 e0 07             	and    $0x7,%eax
80101620:	c1 e0 06             	shl    $0x6,%eax
80101623:	01 d0                	add    %edx,%eax
80101625:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101628:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010162b:	0f b7 00             	movzwl (%eax),%eax
8010162e:	66 85 c0             	test   %ax,%ax
80101631:	75 4f                	jne    80101682 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101633:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010163a:	00 
8010163b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101642:	00 
80101643:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101646:	89 04 24             	mov    %eax,(%esp)
80101649:	e8 7a 3b 00 00       	call   801051c8 <memset>
      dip->type = type;
8010164e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101651:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101655:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101658:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165b:	89 04 24             	mov    %eax,(%esp)
8010165e:	e8 31 1c 00 00       	call   80103294 <log_write>
      brelse(bp);
80101663:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101666:	89 04 24             	mov    %eax,(%esp)
80101669:	e8 a9 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
8010166e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101671:	89 44 24 04          	mov    %eax,0x4(%esp)
80101675:	8b 45 08             	mov    0x8(%ebp),%eax
80101678:	89 04 24             	mov    %eax,(%esp)
8010167b:	e8 e5 00 00 00       	call   80101765 <iget>
80101680:	eb 29                	jmp    801016ab <ialloc+0xdd>
    }
    brelse(bp);
80101682:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101685:	89 04 24             	mov    %eax,(%esp)
80101688:	e8 8a eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
8010168d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101691:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101697:	39 c2                	cmp    %eax,%edx
80101699:	0f 82 5a ff ff ff    	jb     801015f9 <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010169f:	c7 04 24 21 8c 10 80 	movl   $0x80108c21,(%esp)
801016a6:	e8 8f ee ff ff       	call   8010053a <panic>
}
801016ab:	c9                   	leave  
801016ac:	c3                   	ret    

801016ad <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016ad:	55                   	push   %ebp
801016ae:	89 e5                	mov    %esp,%ebp
801016b0:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016b3:	8b 45 08             	mov    0x8(%ebp),%eax
801016b6:	8b 40 04             	mov    0x4(%eax),%eax
801016b9:	c1 e8 03             	shr    $0x3,%eax
801016bc:	8d 50 02             	lea    0x2(%eax),%edx
801016bf:	8b 45 08             	mov    0x8(%ebp),%eax
801016c2:	8b 00                	mov    (%eax),%eax
801016c4:	89 54 24 04          	mov    %edx,0x4(%esp)
801016c8:	89 04 24             	mov    %eax,(%esp)
801016cb:	e8 d6 ea ff ff       	call   801001a6 <bread>
801016d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016d6:	8d 50 18             	lea    0x18(%eax),%edx
801016d9:	8b 45 08             	mov    0x8(%ebp),%eax
801016dc:	8b 40 04             	mov    0x4(%eax),%eax
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	01 d0                	add    %edx,%eax
801016e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016ea:	8b 45 08             	mov    0x8(%ebp),%eax
801016ed:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801016f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f4:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016f7:	8b 45 08             	mov    0x8(%ebp),%eax
801016fa:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801016fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101701:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101705:	8b 45 08             	mov    0x8(%ebp),%eax
80101708:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010170c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010170f:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101713:	8b 45 08             	mov    0x8(%ebp),%eax
80101716:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010171a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010171d:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101721:	8b 45 08             	mov    0x8(%ebp),%eax
80101724:	8b 50 18             	mov    0x18(%eax),%edx
80101727:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010172a:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	8b 45 08             	mov    0x8(%ebp),%eax
80101730:	8d 50 1c             	lea    0x1c(%eax),%edx
80101733:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101736:	83 c0 0c             	add    $0xc,%eax
80101739:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101740:	00 
80101741:	89 54 24 04          	mov    %edx,0x4(%esp)
80101745:	89 04 24             	mov    %eax,(%esp)
80101748:	e8 4a 3b 00 00       	call   80105297 <memmove>
  log_write(bp);
8010174d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101750:	89 04 24             	mov    %eax,(%esp)
80101753:	e8 3c 1b 00 00       	call   80103294 <log_write>
  brelse(bp);
80101758:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010175b:	89 04 24             	mov    %eax,(%esp)
8010175e:	e8 b4 ea ff ff       	call   80100217 <brelse>
}
80101763:	c9                   	leave  
80101764:	c3                   	ret    

80101765 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101765:	55                   	push   %ebp
80101766:	89 e5                	mov    %esp,%ebp
80101768:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010176b:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101772:	e8 fd 37 00 00       	call   80104f74 <acquire>

  // Is the inode already cached?
  empty = 0;
80101777:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010177e:	c7 45 f4 b4 f8 10 80 	movl   $0x8010f8b4,-0xc(%ebp)
80101785:	eb 59                	jmp    801017e0 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101787:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010178a:	8b 40 08             	mov    0x8(%eax),%eax
8010178d:	85 c0                	test   %eax,%eax
8010178f:	7e 35                	jle    801017c6 <iget+0x61>
80101791:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101794:	8b 00                	mov    (%eax),%eax
80101796:	3b 45 08             	cmp    0x8(%ebp),%eax
80101799:	75 2b                	jne    801017c6 <iget+0x61>
8010179b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179e:	8b 40 04             	mov    0x4(%eax),%eax
801017a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017a4:	75 20                	jne    801017c6 <iget+0x61>
      ip->ref++;
801017a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a9:	8b 40 08             	mov    0x8(%eax),%eax
801017ac:	8d 50 01             	lea    0x1(%eax),%edx
801017af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b2:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017b5:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801017bc:	e8 15 38 00 00       	call   80104fd6 <release>
      return ip;
801017c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c4:	eb 6f                	jmp    80101835 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017ca:	75 10                	jne    801017dc <iget+0x77>
801017cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017cf:	8b 40 08             	mov    0x8(%eax),%eax
801017d2:	85 c0                	test   %eax,%eax
801017d4:	75 06                	jne    801017dc <iget+0x77>
      empty = ip;
801017d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d9:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017dc:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017e0:	81 7d f4 54 08 11 80 	cmpl   $0x80110854,-0xc(%ebp)
801017e7:	72 9e                	jb     80101787 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017ed:	75 0c                	jne    801017fb <iget+0x96>
    panic("iget: no inodes");
801017ef:	c7 04 24 33 8c 10 80 	movl   $0x80108c33,(%esp)
801017f6:	e8 3f ed ff ff       	call   8010053a <panic>

  ip = empty;
801017fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101801:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101804:	8b 55 08             	mov    0x8(%ebp),%edx
80101807:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010180c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010180f:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101812:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101815:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010181f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101826:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010182d:	e8 a4 37 00 00       	call   80104fd6 <release>

  return ip;
80101832:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101835:	c9                   	leave  
80101836:	c3                   	ret    

80101837 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101837:	55                   	push   %ebp
80101838:	89 e5                	mov    %esp,%ebp
8010183a:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010183d:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101844:	e8 2b 37 00 00       	call   80104f74 <acquire>
  ip->ref++;
80101849:	8b 45 08             	mov    0x8(%ebp),%eax
8010184c:	8b 40 08             	mov    0x8(%eax),%eax
8010184f:	8d 50 01             	lea    0x1(%eax),%edx
80101852:	8b 45 08             	mov    0x8(%ebp),%eax
80101855:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101858:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010185f:	e8 72 37 00 00       	call   80104fd6 <release>
  return ip;
80101864:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101867:	c9                   	leave  
80101868:	c3                   	ret    

80101869 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101869:	55                   	push   %ebp
8010186a:	89 e5                	mov    %esp,%ebp
8010186c:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010186f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101873:	74 0a                	je     8010187f <ilock+0x16>
80101875:	8b 45 08             	mov    0x8(%ebp),%eax
80101878:	8b 40 08             	mov    0x8(%eax),%eax
8010187b:	85 c0                	test   %eax,%eax
8010187d:	7f 0c                	jg     8010188b <ilock+0x22>
    panic("ilock");
8010187f:	c7 04 24 43 8c 10 80 	movl   $0x80108c43,(%esp)
80101886:	e8 af ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
8010188b:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101892:	e8 dd 36 00 00       	call   80104f74 <acquire>
  while(ip->flags & I_BUSY)
80101897:	eb 13                	jmp    801018ac <ilock+0x43>
    sleep(ip, &icache.lock);
80101899:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
801018a0:	80 
801018a1:	8b 45 08             	mov    0x8(%ebp),%eax
801018a4:	89 04 24             	mov    %eax,(%esp)
801018a7:	e8 d5 2f 00 00       	call   80104881 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018ac:	8b 45 08             	mov    0x8(%ebp),%eax
801018af:	8b 40 0c             	mov    0xc(%eax),%eax
801018b2:	83 e0 01             	and    $0x1,%eax
801018b5:	85 c0                	test   %eax,%eax
801018b7:	75 e0                	jne    80101899 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018b9:	8b 45 08             	mov    0x8(%ebp),%eax
801018bc:	8b 40 0c             	mov    0xc(%eax),%eax
801018bf:	83 c8 01             	or     $0x1,%eax
801018c2:	89 c2                	mov    %eax,%edx
801018c4:	8b 45 08             	mov    0x8(%ebp),%eax
801018c7:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018ca:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801018d1:	e8 00 37 00 00       	call   80104fd6 <release>

  if(!(ip->flags & I_VALID)){
801018d6:	8b 45 08             	mov    0x8(%ebp),%eax
801018d9:	8b 40 0c             	mov    0xc(%eax),%eax
801018dc:	83 e0 02             	and    $0x2,%eax
801018df:	85 c0                	test   %eax,%eax
801018e1:	0f 85 ce 00 00 00    	jne    801019b5 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018e7:	8b 45 08             	mov    0x8(%ebp),%eax
801018ea:	8b 40 04             	mov    0x4(%eax),%eax
801018ed:	c1 e8 03             	shr    $0x3,%eax
801018f0:	8d 50 02             	lea    0x2(%eax),%edx
801018f3:	8b 45 08             	mov    0x8(%ebp),%eax
801018f6:	8b 00                	mov    (%eax),%eax
801018f8:	89 54 24 04          	mov    %edx,0x4(%esp)
801018fc:	89 04 24             	mov    %eax,(%esp)
801018ff:	e8 a2 e8 ff ff       	call   801001a6 <bread>
80101904:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190a:	8d 50 18             	lea    0x18(%eax),%edx
8010190d:	8b 45 08             	mov    0x8(%ebp),%eax
80101910:	8b 40 04             	mov    0x4(%eax),%eax
80101913:	83 e0 07             	and    $0x7,%eax
80101916:	c1 e0 06             	shl    $0x6,%eax
80101919:	01 d0                	add    %edx,%eax
8010191b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
8010191e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101921:	0f b7 10             	movzwl (%eax),%edx
80101924:	8b 45 08             	mov    0x8(%ebp),%eax
80101927:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010192b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010192e:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101932:	8b 45 08             	mov    0x8(%ebp),%eax
80101935:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101939:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010193c:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101940:	8b 45 08             	mov    0x8(%ebp),%eax
80101943:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101947:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010194a:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010194e:	8b 45 08             	mov    0x8(%ebp),%eax
80101951:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101955:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101958:	8b 50 08             	mov    0x8(%eax),%edx
8010195b:	8b 45 08             	mov    0x8(%ebp),%eax
8010195e:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101961:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101964:	8d 50 0c             	lea    0xc(%eax),%edx
80101967:	8b 45 08             	mov    0x8(%ebp),%eax
8010196a:	83 c0 1c             	add    $0x1c,%eax
8010196d:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101974:	00 
80101975:	89 54 24 04          	mov    %edx,0x4(%esp)
80101979:	89 04 24             	mov    %eax,(%esp)
8010197c:	e8 16 39 00 00       	call   80105297 <memmove>
    brelse(bp);
80101981:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101984:	89 04 24             	mov    %eax,(%esp)
80101987:	e8 8b e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
8010198c:	8b 45 08             	mov    0x8(%ebp),%eax
8010198f:	8b 40 0c             	mov    0xc(%eax),%eax
80101992:	83 c8 02             	or     $0x2,%eax
80101995:	89 c2                	mov    %eax,%edx
80101997:	8b 45 08             	mov    0x8(%ebp),%eax
8010199a:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
8010199d:	8b 45 08             	mov    0x8(%ebp),%eax
801019a0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019a4:	66 85 c0             	test   %ax,%ax
801019a7:	75 0c                	jne    801019b5 <ilock+0x14c>
      panic("ilock: no type");
801019a9:	c7 04 24 49 8c 10 80 	movl   $0x80108c49,(%esp)
801019b0:	e8 85 eb ff ff       	call   8010053a <panic>
  }
}
801019b5:	c9                   	leave  
801019b6:	c3                   	ret    

801019b7 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019b7:	55                   	push   %ebp
801019b8:	89 e5                	mov    %esp,%ebp
801019ba:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019c1:	74 17                	je     801019da <iunlock+0x23>
801019c3:	8b 45 08             	mov    0x8(%ebp),%eax
801019c6:	8b 40 0c             	mov    0xc(%eax),%eax
801019c9:	83 e0 01             	and    $0x1,%eax
801019cc:	85 c0                	test   %eax,%eax
801019ce:	74 0a                	je     801019da <iunlock+0x23>
801019d0:	8b 45 08             	mov    0x8(%ebp),%eax
801019d3:	8b 40 08             	mov    0x8(%eax),%eax
801019d6:	85 c0                	test   %eax,%eax
801019d8:	7f 0c                	jg     801019e6 <iunlock+0x2f>
    panic("iunlock");
801019da:	c7 04 24 58 8c 10 80 	movl   $0x80108c58,(%esp)
801019e1:	e8 54 eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019e6:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801019ed:	e8 82 35 00 00       	call   80104f74 <acquire>
  ip->flags &= ~I_BUSY;
801019f2:	8b 45 08             	mov    0x8(%ebp),%eax
801019f5:	8b 40 0c             	mov    0xc(%eax),%eax
801019f8:	83 e0 fe             	and    $0xfffffffe,%eax
801019fb:	89 c2                	mov    %eax,%edx
801019fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101a00:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a03:	8b 45 08             	mov    0x8(%ebp),%eax
80101a06:	89 04 24             	mov    %eax,(%esp)
80101a09:	e8 4c 2f 00 00       	call   8010495a <wakeup>
  release(&icache.lock);
80101a0e:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101a15:	e8 bc 35 00 00       	call   80104fd6 <release>
}
80101a1a:	c9                   	leave  
80101a1b:	c3                   	ret    

80101a1c <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a1c:	55                   	push   %ebp
80101a1d:	89 e5                	mov    %esp,%ebp
80101a1f:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a22:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101a29:	e8 46 35 00 00       	call   80104f74 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a31:	8b 40 08             	mov    0x8(%eax),%eax
80101a34:	83 f8 01             	cmp    $0x1,%eax
80101a37:	0f 85 93 00 00 00    	jne    80101ad0 <iput+0xb4>
80101a3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a40:	8b 40 0c             	mov    0xc(%eax),%eax
80101a43:	83 e0 02             	and    $0x2,%eax
80101a46:	85 c0                	test   %eax,%eax
80101a48:	0f 84 82 00 00 00    	je     80101ad0 <iput+0xb4>
80101a4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a51:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a55:	66 85 c0             	test   %ax,%ax
80101a58:	75 76                	jne    80101ad0 <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5d:	8b 40 0c             	mov    0xc(%eax),%eax
80101a60:	83 e0 01             	and    $0x1,%eax
80101a63:	85 c0                	test   %eax,%eax
80101a65:	74 0c                	je     80101a73 <iput+0x57>
      panic("iput busy");
80101a67:	c7 04 24 60 8c 10 80 	movl   $0x80108c60,(%esp)
80101a6e:	e8 c7 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a73:	8b 45 08             	mov    0x8(%ebp),%eax
80101a76:	8b 40 0c             	mov    0xc(%eax),%eax
80101a79:	83 c8 01             	or     $0x1,%eax
80101a7c:	89 c2                	mov    %eax,%edx
80101a7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a81:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a84:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101a8b:	e8 46 35 00 00       	call   80104fd6 <release>
    itrunc(ip);
80101a90:	8b 45 08             	mov    0x8(%ebp),%eax
80101a93:	89 04 24             	mov    %eax,(%esp)
80101a96:	e8 7d 01 00 00       	call   80101c18 <itrunc>
    ip->type = 0;
80101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9e:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa7:	89 04 24             	mov    %eax,(%esp)
80101aaa:	e8 fe fb ff ff       	call   801016ad <iupdate>
    acquire(&icache.lock);
80101aaf:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101ab6:	e8 b9 34 00 00       	call   80104f74 <acquire>
    ip->flags = 0;
80101abb:	8b 45 08             	mov    0x8(%ebp),%eax
80101abe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac8:	89 04 24             	mov    %eax,(%esp)
80101acb:	e8 8a 2e 00 00       	call   8010495a <wakeup>
  }
  ip->ref--;
80101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad3:	8b 40 08             	mov    0x8(%eax),%eax
80101ad6:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80101adc:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101adf:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101ae6:	e8 eb 34 00 00       	call   80104fd6 <release>
}
80101aeb:	c9                   	leave  
80101aec:	c3                   	ret    

80101aed <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101aed:	55                   	push   %ebp
80101aee:	89 e5                	mov    %esp,%ebp
80101af0:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101af3:	8b 45 08             	mov    0x8(%ebp),%eax
80101af6:	89 04 24             	mov    %eax,(%esp)
80101af9:	e8 b9 fe ff ff       	call   801019b7 <iunlock>
  iput(ip);
80101afe:	8b 45 08             	mov    0x8(%ebp),%eax
80101b01:	89 04 24             	mov    %eax,(%esp)
80101b04:	e8 13 ff ff ff       	call   80101a1c <iput>
}
80101b09:	c9                   	leave  
80101b0a:	c3                   	ret    

80101b0b <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b0b:	55                   	push   %ebp
80101b0c:	89 e5                	mov    %esp,%ebp
80101b0e:	53                   	push   %ebx
80101b0f:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b12:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b16:	77 3e                	ja     80101b56 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b18:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b1e:	83 c2 04             	add    $0x4,%edx
80101b21:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b2c:	75 20                	jne    80101b4e <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b31:	8b 00                	mov    (%eax),%eax
80101b33:	89 04 24             	mov    %eax,(%esp)
80101b36:	e8 5b f8 ff ff       	call   80101396 <balloc>
80101b3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b41:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b44:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b47:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b4a:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b51:	e9 bc 00 00 00       	jmp    80101c12 <bmap+0x107>
  }
  bn -= NDIRECT;
80101b56:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b5a:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b5e:	0f 87 a2 00 00 00    	ja     80101c06 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b64:	8b 45 08             	mov    0x8(%ebp),%eax
80101b67:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b71:	75 19                	jne    80101b8c <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b73:	8b 45 08             	mov    0x8(%ebp),%eax
80101b76:	8b 00                	mov    (%eax),%eax
80101b78:	89 04 24             	mov    %eax,(%esp)
80101b7b:	e8 16 f8 ff ff       	call   80101396 <balloc>
80101b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b83:	8b 45 08             	mov    0x8(%ebp),%eax
80101b86:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b89:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8f:	8b 00                	mov    (%eax),%eax
80101b91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b94:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b98:	89 04 24             	mov    %eax,(%esp)
80101b9b:	e8 06 e6 ff ff       	call   801001a6 <bread>
80101ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ba6:	83 c0 18             	add    $0x18,%eax
80101ba9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101bac:	8b 45 0c             	mov    0xc(%ebp),%eax
80101baf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bb9:	01 d0                	add    %edx,%eax
80101bbb:	8b 00                	mov    (%eax),%eax
80101bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bc4:	75 30                	jne    80101bf6 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bc9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bd3:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd9:	8b 00                	mov    (%eax),%eax
80101bdb:	89 04 24             	mov    %eax,(%esp)
80101bde:	e8 b3 f7 ff ff       	call   80101396 <balloc>
80101be3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101be9:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bee:	89 04 24             	mov    %eax,(%esp)
80101bf1:	e8 9e 16 00 00       	call   80103294 <log_write>
    }
    brelse(bp);
80101bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bf9:	89 04 24             	mov    %eax,(%esp)
80101bfc:	e8 16 e6 ff ff       	call   80100217 <brelse>
    return addr;
80101c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c04:	eb 0c                	jmp    80101c12 <bmap+0x107>
  }

  panic("bmap: out of range");
80101c06:	c7 04 24 6a 8c 10 80 	movl   $0x80108c6a,(%esp)
80101c0d:	e8 28 e9 ff ff       	call   8010053a <panic>
}
80101c12:	83 c4 24             	add    $0x24,%esp
80101c15:	5b                   	pop    %ebx
80101c16:	5d                   	pop    %ebp
80101c17:	c3                   	ret    

80101c18 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c18:	55                   	push   %ebp
80101c19:	89 e5                	mov    %esp,%ebp
80101c1b:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c25:	eb 44                	jmp    80101c6b <itrunc+0x53>
    if(ip->addrs[i]){
80101c27:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c2d:	83 c2 04             	add    $0x4,%edx
80101c30:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c34:	85 c0                	test   %eax,%eax
80101c36:	74 2f                	je     80101c67 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c38:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c3e:	83 c2 04             	add    $0x4,%edx
80101c41:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c45:	8b 45 08             	mov    0x8(%ebp),%eax
80101c48:	8b 00                	mov    (%eax),%eax
80101c4a:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c4e:	89 04 24             	mov    %eax,(%esp)
80101c51:	e8 8e f8 ff ff       	call   801014e4 <bfree>
      ip->addrs[i] = 0;
80101c56:	8b 45 08             	mov    0x8(%ebp),%eax
80101c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c5c:	83 c2 04             	add    $0x4,%edx
80101c5f:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c66:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c6b:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c6f:	7e b6                	jle    80101c27 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c71:	8b 45 08             	mov    0x8(%ebp),%eax
80101c74:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c77:	85 c0                	test   %eax,%eax
80101c79:	0f 84 9b 00 00 00    	je     80101d1a <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c82:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c85:	8b 45 08             	mov    0x8(%ebp),%eax
80101c88:	8b 00                	mov    (%eax),%eax
80101c8a:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c8e:	89 04 24             	mov    %eax,(%esp)
80101c91:	e8 10 e5 ff ff       	call   801001a6 <bread>
80101c96:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c9c:	83 c0 18             	add    $0x18,%eax
80101c9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ca2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101ca9:	eb 3b                	jmp    80101ce6 <itrunc+0xce>
      if(a[j])
80101cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cb8:	01 d0                	add    %edx,%eax
80101cba:	8b 00                	mov    (%eax),%eax
80101cbc:	85 c0                	test   %eax,%eax
80101cbe:	74 22                	je     80101ce2 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cc3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cca:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ccd:	01 d0                	add    %edx,%eax
80101ccf:	8b 10                	mov    (%eax),%edx
80101cd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd4:	8b 00                	mov    (%eax),%eax
80101cd6:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cda:	89 04 24             	mov    %eax,(%esp)
80101cdd:	e8 02 f8 ff ff       	call   801014e4 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101ce2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ce9:	83 f8 7f             	cmp    $0x7f,%eax
80101cec:	76 bd                	jbe    80101cab <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101cee:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cf1:	89 04 24             	mov    %eax,(%esp)
80101cf4:	e8 1e e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101cf9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfc:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cff:	8b 45 08             	mov    0x8(%ebp),%eax
80101d02:	8b 00                	mov    (%eax),%eax
80101d04:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d08:	89 04 24             	mov    %eax,(%esp)
80101d0b:	e8 d4 f7 ff ff       	call   801014e4 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d10:	8b 45 08             	mov    0x8(%ebp),%eax
80101d13:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d24:	8b 45 08             	mov    0x8(%ebp),%eax
80101d27:	89 04 24             	mov    %eax,(%esp)
80101d2a:	e8 7e f9 ff ff       	call   801016ad <iupdate>
}
80101d2f:	c9                   	leave  
80101d30:	c3                   	ret    

80101d31 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d31:	55                   	push   %ebp
80101d32:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d34:	8b 45 08             	mov    0x8(%ebp),%eax
80101d37:	8b 00                	mov    (%eax),%eax
80101d39:	89 c2                	mov    %eax,%edx
80101d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d3e:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d41:	8b 45 08             	mov    0x8(%ebp),%eax
80101d44:	8b 50 04             	mov    0x4(%eax),%edx
80101d47:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d4a:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d50:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d54:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d57:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5d:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d61:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d64:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d68:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6b:	8b 50 18             	mov    0x18(%eax),%edx
80101d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d71:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d74:	5d                   	pop    %ebp
80101d75:	c3                   	ret    

80101d76 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d76:	55                   	push   %ebp
80101d77:	89 e5                	mov    %esp,%ebp
80101d79:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d83:	66 83 f8 03          	cmp    $0x3,%ax
80101d87:	75 60                	jne    80101de9 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d89:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d90:	66 85 c0             	test   %ax,%ax
80101d93:	78 20                	js     80101db5 <readi+0x3f>
80101d95:	8b 45 08             	mov    0x8(%ebp),%eax
80101d98:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d9c:	66 83 f8 09          	cmp    $0x9,%ax
80101da0:	7f 13                	jg     80101db5 <readi+0x3f>
80101da2:	8b 45 08             	mov    0x8(%ebp),%eax
80101da5:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101da9:	98                   	cwtl   
80101daa:	8b 04 c5 20 f8 10 80 	mov    -0x7fef07e0(,%eax,8),%eax
80101db1:	85 c0                	test   %eax,%eax
80101db3:	75 0a                	jne    80101dbf <readi+0x49>
      return -1;
80101db5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dba:	e9 19 01 00 00       	jmp    80101ed8 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101dbf:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc2:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dc6:	98                   	cwtl   
80101dc7:	8b 04 c5 20 f8 10 80 	mov    -0x7fef07e0(,%eax,8),%eax
80101dce:	8b 55 14             	mov    0x14(%ebp),%edx
80101dd1:	89 54 24 08          	mov    %edx,0x8(%esp)
80101dd5:	8b 55 0c             	mov    0xc(%ebp),%edx
80101dd8:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ddc:	8b 55 08             	mov    0x8(%ebp),%edx
80101ddf:	89 14 24             	mov    %edx,(%esp)
80101de2:	ff d0                	call   *%eax
80101de4:	e9 ef 00 00 00       	jmp    80101ed8 <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101de9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dec:	8b 40 18             	mov    0x18(%eax),%eax
80101def:	3b 45 10             	cmp    0x10(%ebp),%eax
80101df2:	72 0d                	jb     80101e01 <readi+0x8b>
80101df4:	8b 45 14             	mov    0x14(%ebp),%eax
80101df7:	8b 55 10             	mov    0x10(%ebp),%edx
80101dfa:	01 d0                	add    %edx,%eax
80101dfc:	3b 45 10             	cmp    0x10(%ebp),%eax
80101dff:	73 0a                	jae    80101e0b <readi+0x95>
    return -1;
80101e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e06:	e9 cd 00 00 00       	jmp    80101ed8 <readi+0x162>
  if(off + n > ip->size)
80101e0b:	8b 45 14             	mov    0x14(%ebp),%eax
80101e0e:	8b 55 10             	mov    0x10(%ebp),%edx
80101e11:	01 c2                	add    %eax,%edx
80101e13:	8b 45 08             	mov    0x8(%ebp),%eax
80101e16:	8b 40 18             	mov    0x18(%eax),%eax
80101e19:	39 c2                	cmp    %eax,%edx
80101e1b:	76 0c                	jbe    80101e29 <readi+0xb3>
    n = ip->size - off;
80101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e20:	8b 40 18             	mov    0x18(%eax),%eax
80101e23:	2b 45 10             	sub    0x10(%ebp),%eax
80101e26:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e30:	e9 94 00 00 00       	jmp    80101ec9 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e35:	8b 45 10             	mov    0x10(%ebp),%eax
80101e38:	c1 e8 09             	shr    $0x9,%eax
80101e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e42:	89 04 24             	mov    %eax,(%esp)
80101e45:	e8 c1 fc ff ff       	call   80101b0b <bmap>
80101e4a:	8b 55 08             	mov    0x8(%ebp),%edx
80101e4d:	8b 12                	mov    (%edx),%edx
80101e4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e53:	89 14 24             	mov    %edx,(%esp)
80101e56:	e8 4b e3 ff ff       	call   801001a6 <bread>
80101e5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e5e:	8b 45 10             	mov    0x10(%ebp),%eax
80101e61:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e66:	89 c2                	mov    %eax,%edx
80101e68:	b8 00 02 00 00       	mov    $0x200,%eax
80101e6d:	29 d0                	sub    %edx,%eax
80101e6f:	89 c2                	mov    %eax,%edx
80101e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e74:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e77:	29 c1                	sub    %eax,%ecx
80101e79:	89 c8                	mov    %ecx,%eax
80101e7b:	39 c2                	cmp    %eax,%edx
80101e7d:	0f 46 c2             	cmovbe %edx,%eax
80101e80:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e83:	8b 45 10             	mov    0x10(%ebp),%eax
80101e86:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e8b:	8d 50 10             	lea    0x10(%eax),%edx
80101e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e91:	01 d0                	add    %edx,%eax
80101e93:	8d 50 08             	lea    0x8(%eax),%edx
80101e96:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e99:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e9d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea4:	89 04 24             	mov    %eax,(%esp)
80101ea7:	e8 eb 33 00 00       	call   80105297 <memmove>
    brelse(bp);
80101eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eaf:	89 04 24             	mov    %eax,(%esp)
80101eb2:	e8 60 e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101eb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eba:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ebd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ec0:	01 45 10             	add    %eax,0x10(%ebp)
80101ec3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ec6:	01 45 0c             	add    %eax,0xc(%ebp)
80101ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ecc:	3b 45 14             	cmp    0x14(%ebp),%eax
80101ecf:	0f 82 60 ff ff ff    	jb     80101e35 <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101ed5:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101ed8:	c9                   	leave  
80101ed9:	c3                   	ret    

80101eda <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101eda:	55                   	push   %ebp
80101edb:	89 e5                	mov    %esp,%ebp
80101edd:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ee0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ee7:	66 83 f8 03          	cmp    $0x3,%ax
80101eeb:	75 60                	jne    80101f4d <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101eed:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ef4:	66 85 c0             	test   %ax,%ax
80101ef7:	78 20                	js     80101f19 <writei+0x3f>
80101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
80101efc:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f00:	66 83 f8 09          	cmp    $0x9,%ax
80101f04:	7f 13                	jg     80101f19 <writei+0x3f>
80101f06:	8b 45 08             	mov    0x8(%ebp),%eax
80101f09:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f0d:	98                   	cwtl   
80101f0e:	8b 04 c5 24 f8 10 80 	mov    -0x7fef07dc(,%eax,8),%eax
80101f15:	85 c0                	test   %eax,%eax
80101f17:	75 0a                	jne    80101f23 <writei+0x49>
      return -1;
80101f19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f1e:	e9 44 01 00 00       	jmp    80102067 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f23:	8b 45 08             	mov    0x8(%ebp),%eax
80101f26:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f2a:	98                   	cwtl   
80101f2b:	8b 04 c5 24 f8 10 80 	mov    -0x7fef07dc(,%eax,8),%eax
80101f32:	8b 55 14             	mov    0x14(%ebp),%edx
80101f35:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f39:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f3c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f40:	8b 55 08             	mov    0x8(%ebp),%edx
80101f43:	89 14 24             	mov    %edx,(%esp)
80101f46:	ff d0                	call   *%eax
80101f48:	e9 1a 01 00 00       	jmp    80102067 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101f4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f50:	8b 40 18             	mov    0x18(%eax),%eax
80101f53:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f56:	72 0d                	jb     80101f65 <writei+0x8b>
80101f58:	8b 45 14             	mov    0x14(%ebp),%eax
80101f5b:	8b 55 10             	mov    0x10(%ebp),%edx
80101f5e:	01 d0                	add    %edx,%eax
80101f60:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f63:	73 0a                	jae    80101f6f <writei+0x95>
    return -1;
80101f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f6a:	e9 f8 00 00 00       	jmp    80102067 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101f6f:	8b 45 14             	mov    0x14(%ebp),%eax
80101f72:	8b 55 10             	mov    0x10(%ebp),%edx
80101f75:	01 d0                	add    %edx,%eax
80101f77:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f7c:	76 0a                	jbe    80101f88 <writei+0xae>
    return -1;
80101f7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f83:	e9 df 00 00 00       	jmp    80102067 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f8f:	e9 9f 00 00 00       	jmp    80102033 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f94:	8b 45 10             	mov    0x10(%ebp),%eax
80101f97:	c1 e8 09             	shr    $0x9,%eax
80101f9a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa1:	89 04 24             	mov    %eax,(%esp)
80101fa4:	e8 62 fb ff ff       	call   80101b0b <bmap>
80101fa9:	8b 55 08             	mov    0x8(%ebp),%edx
80101fac:	8b 12                	mov    (%edx),%edx
80101fae:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fb2:	89 14 24             	mov    %edx,(%esp)
80101fb5:	e8 ec e1 ff ff       	call   801001a6 <bread>
80101fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fbd:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc0:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fc5:	89 c2                	mov    %eax,%edx
80101fc7:	b8 00 02 00 00       	mov    $0x200,%eax
80101fcc:	29 d0                	sub    %edx,%eax
80101fce:	89 c2                	mov    %eax,%edx
80101fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fd3:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fd6:	29 c1                	sub    %eax,%ecx
80101fd8:	89 c8                	mov    %ecx,%eax
80101fda:	39 c2                	cmp    %eax,%edx
80101fdc:	0f 46 c2             	cmovbe %edx,%eax
80101fdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101fe2:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe5:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fea:	8d 50 10             	lea    0x10(%eax),%edx
80101fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff0:	01 d0                	add    %edx,%eax
80101ff2:	8d 50 08             	lea    0x8(%eax),%edx
80101ff5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ff8:	89 44 24 08          	mov    %eax,0x8(%esp)
80101ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fff:	89 44 24 04          	mov    %eax,0x4(%esp)
80102003:	89 14 24             	mov    %edx,(%esp)
80102006:	e8 8c 32 00 00       	call   80105297 <memmove>
    log_write(bp);
8010200b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010200e:	89 04 24             	mov    %eax,(%esp)
80102011:	e8 7e 12 00 00       	call   80103294 <log_write>
    brelse(bp);
80102016:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102019:	89 04 24             	mov    %eax,(%esp)
8010201c:	e8 f6 e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102021:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102024:	01 45 f4             	add    %eax,-0xc(%ebp)
80102027:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010202a:	01 45 10             	add    %eax,0x10(%ebp)
8010202d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102030:	01 45 0c             	add    %eax,0xc(%ebp)
80102033:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102036:	3b 45 14             	cmp    0x14(%ebp),%eax
80102039:	0f 82 55 ff ff ff    	jb     80101f94 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010203f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102043:	74 1f                	je     80102064 <writei+0x18a>
80102045:	8b 45 08             	mov    0x8(%ebp),%eax
80102048:	8b 40 18             	mov    0x18(%eax),%eax
8010204b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010204e:	73 14                	jae    80102064 <writei+0x18a>
    ip->size = off;
80102050:	8b 45 08             	mov    0x8(%ebp),%eax
80102053:	8b 55 10             	mov    0x10(%ebp),%edx
80102056:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102059:	8b 45 08             	mov    0x8(%ebp),%eax
8010205c:	89 04 24             	mov    %eax,(%esp)
8010205f:	e8 49 f6 ff ff       	call   801016ad <iupdate>
  }
  return n;
80102064:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102067:	c9                   	leave  
80102068:	c3                   	ret    

80102069 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102069:	55                   	push   %ebp
8010206a:	89 e5                	mov    %esp,%ebp
8010206c:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
8010206f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102076:	00 
80102077:	8b 45 0c             	mov    0xc(%ebp),%eax
8010207a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010207e:	8b 45 08             	mov    0x8(%ebp),%eax
80102081:	89 04 24             	mov    %eax,(%esp)
80102084:	e8 b1 32 00 00       	call   8010533a <strncmp>
}
80102089:	c9                   	leave  
8010208a:	c3                   	ret    

8010208b <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010208b:	55                   	push   %ebp
8010208c:	89 e5                	mov    %esp,%ebp
8010208e:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102091:	8b 45 08             	mov    0x8(%ebp),%eax
80102094:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102098:	66 83 f8 01          	cmp    $0x1,%ax
8010209c:	74 0c                	je     801020aa <dirlookup+0x1f>
    panic("dirlookup not DIR");
8010209e:	c7 04 24 7d 8c 10 80 	movl   $0x80108c7d,(%esp)
801020a5:	e8 90 e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020b1:	e9 88 00 00 00       	jmp    8010213e <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020b6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020bd:	00 
801020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020c1:	89 44 24 08          	mov    %eax,0x8(%esp)
801020c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801020cc:	8b 45 08             	mov    0x8(%ebp),%eax
801020cf:	89 04 24             	mov    %eax,(%esp)
801020d2:	e8 9f fc ff ff       	call   80101d76 <readi>
801020d7:	83 f8 10             	cmp    $0x10,%eax
801020da:	74 0c                	je     801020e8 <dirlookup+0x5d>
      panic("dirlink read");
801020dc:	c7 04 24 8f 8c 10 80 	movl   $0x80108c8f,(%esp)
801020e3:	e8 52 e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801020e8:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020ec:	66 85 c0             	test   %ax,%ax
801020ef:	75 02                	jne    801020f3 <dirlookup+0x68>
      continue;
801020f1:	eb 47                	jmp    8010213a <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
801020f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020f6:	83 c0 02             	add    $0x2,%eax
801020f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801020fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80102100:	89 04 24             	mov    %eax,(%esp)
80102103:	e8 61 ff ff ff       	call   80102069 <namecmp>
80102108:	85 c0                	test   %eax,%eax
8010210a:	75 2e                	jne    8010213a <dirlookup+0xaf>
      // entry matches path element
      if(poff)
8010210c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102110:	74 08                	je     8010211a <dirlookup+0x8f>
        *poff = off;
80102112:	8b 45 10             	mov    0x10(%ebp),%eax
80102115:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102118:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010211a:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010211e:	0f b7 c0             	movzwl %ax,%eax
80102121:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102124:	8b 45 08             	mov    0x8(%ebp),%eax
80102127:	8b 00                	mov    (%eax),%eax
80102129:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010212c:	89 54 24 04          	mov    %edx,0x4(%esp)
80102130:	89 04 24             	mov    %eax,(%esp)
80102133:	e8 2d f6 ff ff       	call   80101765 <iget>
80102138:	eb 18                	jmp    80102152 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010213a:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010213e:	8b 45 08             	mov    0x8(%ebp),%eax
80102141:	8b 40 18             	mov    0x18(%eax),%eax
80102144:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102147:	0f 87 69 ff ff ff    	ja     801020b6 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010214d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102152:	c9                   	leave  
80102153:	c3                   	ret    

80102154 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010215a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102161:	00 
80102162:	8b 45 0c             	mov    0xc(%ebp),%eax
80102165:	89 44 24 04          	mov    %eax,0x4(%esp)
80102169:	8b 45 08             	mov    0x8(%ebp),%eax
8010216c:	89 04 24             	mov    %eax,(%esp)
8010216f:	e8 17 ff ff ff       	call   8010208b <dirlookup>
80102174:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102177:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010217b:	74 15                	je     80102192 <dirlink+0x3e>
    iput(ip);
8010217d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102180:	89 04 24             	mov    %eax,(%esp)
80102183:	e8 94 f8 ff ff       	call   80101a1c <iput>
    return -1;
80102188:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010218d:	e9 b7 00 00 00       	jmp    80102249 <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102192:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102199:	eb 46                	jmp    801021e1 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010219e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021a5:	00 
801021a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801021aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801021b1:	8b 45 08             	mov    0x8(%ebp),%eax
801021b4:	89 04 24             	mov    %eax,(%esp)
801021b7:	e8 ba fb ff ff       	call   80101d76 <readi>
801021bc:	83 f8 10             	cmp    $0x10,%eax
801021bf:	74 0c                	je     801021cd <dirlink+0x79>
      panic("dirlink read");
801021c1:	c7 04 24 8f 8c 10 80 	movl   $0x80108c8f,(%esp)
801021c8:	e8 6d e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801021cd:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021d1:	66 85 c0             	test   %ax,%ax
801021d4:	75 02                	jne    801021d8 <dirlink+0x84>
      break;
801021d6:	eb 16                	jmp    801021ee <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021db:	83 c0 10             	add    $0x10,%eax
801021de:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021e4:	8b 45 08             	mov    0x8(%ebp),%eax
801021e7:	8b 40 18             	mov    0x18(%eax),%eax
801021ea:	39 c2                	cmp    %eax,%edx
801021ec:	72 ad                	jb     8010219b <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801021ee:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021f5:	00 
801021f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801021f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801021fd:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102200:	83 c0 02             	add    $0x2,%eax
80102203:	89 04 24             	mov    %eax,(%esp)
80102206:	e8 85 31 00 00       	call   80105390 <strncpy>
  de.inum = inum;
8010220b:	8b 45 10             	mov    0x10(%ebp),%eax
8010220e:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102212:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102215:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010221c:	00 
8010221d:	89 44 24 08          	mov    %eax,0x8(%esp)
80102221:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102224:	89 44 24 04          	mov    %eax,0x4(%esp)
80102228:	8b 45 08             	mov    0x8(%ebp),%eax
8010222b:	89 04 24             	mov    %eax,(%esp)
8010222e:	e8 a7 fc ff ff       	call   80101eda <writei>
80102233:	83 f8 10             	cmp    $0x10,%eax
80102236:	74 0c                	je     80102244 <dirlink+0xf0>
    panic("dirlink");
80102238:	c7 04 24 9c 8c 10 80 	movl   $0x80108c9c,(%esp)
8010223f:	e8 f6 e2 ff ff       	call   8010053a <panic>
  
  return 0;
80102244:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102249:	c9                   	leave  
8010224a:	c3                   	ret    

8010224b <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010224b:	55                   	push   %ebp
8010224c:	89 e5                	mov    %esp,%ebp
8010224e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102251:	eb 04                	jmp    80102257 <skipelem+0xc>
    path++;
80102253:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102257:	8b 45 08             	mov    0x8(%ebp),%eax
8010225a:	0f b6 00             	movzbl (%eax),%eax
8010225d:	3c 2f                	cmp    $0x2f,%al
8010225f:	74 f2                	je     80102253 <skipelem+0x8>
    path++;
  if(*path == 0)
80102261:	8b 45 08             	mov    0x8(%ebp),%eax
80102264:	0f b6 00             	movzbl (%eax),%eax
80102267:	84 c0                	test   %al,%al
80102269:	75 0a                	jne    80102275 <skipelem+0x2a>
    return 0;
8010226b:	b8 00 00 00 00       	mov    $0x0,%eax
80102270:	e9 86 00 00 00       	jmp    801022fb <skipelem+0xb0>
  s = path;
80102275:	8b 45 08             	mov    0x8(%ebp),%eax
80102278:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010227b:	eb 04                	jmp    80102281 <skipelem+0x36>
    path++;
8010227d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102281:	8b 45 08             	mov    0x8(%ebp),%eax
80102284:	0f b6 00             	movzbl (%eax),%eax
80102287:	3c 2f                	cmp    $0x2f,%al
80102289:	74 0a                	je     80102295 <skipelem+0x4a>
8010228b:	8b 45 08             	mov    0x8(%ebp),%eax
8010228e:	0f b6 00             	movzbl (%eax),%eax
80102291:	84 c0                	test   %al,%al
80102293:	75 e8                	jne    8010227d <skipelem+0x32>
    path++;
  len = path - s;
80102295:	8b 55 08             	mov    0x8(%ebp),%edx
80102298:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010229b:	29 c2                	sub    %eax,%edx
8010229d:	89 d0                	mov    %edx,%eax
8010229f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022a2:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801022a6:	7e 1c                	jle    801022c4 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
801022a8:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022af:	00 
801022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801022b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801022ba:	89 04 24             	mov    %eax,(%esp)
801022bd:	e8 d5 2f 00 00       	call   80105297 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022c2:	eb 2a                	jmp    801022ee <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022c7:	89 44 24 08          	mov    %eax,0x8(%esp)
801022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801022d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801022d5:	89 04 24             	mov    %eax,(%esp)
801022d8:	e8 ba 2f 00 00       	call   80105297 <memmove>
    name[len] = 0;
801022dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801022e3:	01 d0                	add    %edx,%eax
801022e5:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022e8:	eb 04                	jmp    801022ee <skipelem+0xa3>
    path++;
801022ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022ee:	8b 45 08             	mov    0x8(%ebp),%eax
801022f1:	0f b6 00             	movzbl (%eax),%eax
801022f4:	3c 2f                	cmp    $0x2f,%al
801022f6:	74 f2                	je     801022ea <skipelem+0x9f>
    path++;
  return path;
801022f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022fb:	c9                   	leave  
801022fc:	c3                   	ret    

801022fd <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801022fd:	55                   	push   %ebp
801022fe:	89 e5                	mov    %esp,%ebp
80102300:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102303:	8b 45 08             	mov    0x8(%ebp),%eax
80102306:	0f b6 00             	movzbl (%eax),%eax
80102309:	3c 2f                	cmp    $0x2f,%al
8010230b:	75 1c                	jne    80102329 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
8010230d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102314:	00 
80102315:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010231c:	e8 44 f4 ff ff       	call   80101765 <iget>
80102321:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102324:	e9 af 00 00 00       	jmp    801023d8 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80102329:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010232f:	8b 40 68             	mov    0x68(%eax),%eax
80102332:	89 04 24             	mov    %eax,(%esp)
80102335:	e8 fd f4 ff ff       	call   80101837 <idup>
8010233a:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010233d:	e9 96 00 00 00       	jmp    801023d8 <namex+0xdb>
    ilock(ip);
80102342:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102345:	89 04 24             	mov    %eax,(%esp)
80102348:	e8 1c f5 ff ff       	call   80101869 <ilock>
    if(ip->type != T_DIR){
8010234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102350:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102354:	66 83 f8 01          	cmp    $0x1,%ax
80102358:	74 15                	je     8010236f <namex+0x72>
      iunlockput(ip);
8010235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010235d:	89 04 24             	mov    %eax,(%esp)
80102360:	e8 88 f7 ff ff       	call   80101aed <iunlockput>
      return 0;
80102365:	b8 00 00 00 00       	mov    $0x0,%eax
8010236a:	e9 a3 00 00 00       	jmp    80102412 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
8010236f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102373:	74 1d                	je     80102392 <namex+0x95>
80102375:	8b 45 08             	mov    0x8(%ebp),%eax
80102378:	0f b6 00             	movzbl (%eax),%eax
8010237b:	84 c0                	test   %al,%al
8010237d:	75 13                	jne    80102392 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
8010237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102382:	89 04 24             	mov    %eax,(%esp)
80102385:	e8 2d f6 ff ff       	call   801019b7 <iunlock>
      return ip;
8010238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010238d:	e9 80 00 00 00       	jmp    80102412 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102392:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102399:	00 
8010239a:	8b 45 10             	mov    0x10(%ebp),%eax
8010239d:	89 44 24 04          	mov    %eax,0x4(%esp)
801023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a4:	89 04 24             	mov    %eax,(%esp)
801023a7:	e8 df fc ff ff       	call   8010208b <dirlookup>
801023ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023b3:	75 12                	jne    801023c7 <namex+0xca>
      iunlockput(ip);
801023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b8:	89 04 24             	mov    %eax,(%esp)
801023bb:	e8 2d f7 ff ff       	call   80101aed <iunlockput>
      return 0;
801023c0:	b8 00 00 00 00       	mov    $0x0,%eax
801023c5:	eb 4b                	jmp    80102412 <namex+0x115>
    }
    iunlockput(ip);
801023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ca:	89 04 24             	mov    %eax,(%esp)
801023cd:	e8 1b f7 ff ff       	call   80101aed <iunlockput>
    ip = next;
801023d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023d8:	8b 45 10             	mov    0x10(%ebp),%eax
801023db:	89 44 24 04          	mov    %eax,0x4(%esp)
801023df:	8b 45 08             	mov    0x8(%ebp),%eax
801023e2:	89 04 24             	mov    %eax,(%esp)
801023e5:	e8 61 fe ff ff       	call   8010224b <skipelem>
801023ea:	89 45 08             	mov    %eax,0x8(%ebp)
801023ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801023f1:	0f 85 4b ff ff ff    	jne    80102342 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023fb:	74 12                	je     8010240f <namex+0x112>
    iput(ip);
801023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102400:	89 04 24             	mov    %eax,(%esp)
80102403:	e8 14 f6 ff ff       	call   80101a1c <iput>
    return 0;
80102408:	b8 00 00 00 00       	mov    $0x0,%eax
8010240d:	eb 03                	jmp    80102412 <namex+0x115>
  }
  return ip;
8010240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102412:	c9                   	leave  
80102413:	c3                   	ret    

80102414 <namei>:

struct inode*
namei(char *path)
{
80102414:	55                   	push   %ebp
80102415:	89 e5                	mov    %esp,%ebp
80102417:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010241a:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010241d:	89 44 24 08          	mov    %eax,0x8(%esp)
80102421:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102428:	00 
80102429:	8b 45 08             	mov    0x8(%ebp),%eax
8010242c:	89 04 24             	mov    %eax,(%esp)
8010242f:	e8 c9 fe ff ff       	call   801022fd <namex>
}
80102434:	c9                   	leave  
80102435:	c3                   	ret    

80102436 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102436:	55                   	push   %ebp
80102437:	89 e5                	mov    %esp,%ebp
80102439:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010243c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010243f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102443:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010244a:	00 
8010244b:	8b 45 08             	mov    0x8(%ebp),%eax
8010244e:	89 04 24             	mov    %eax,(%esp)
80102451:	e8 a7 fe ff ff       	call   801022fd <namex>
}
80102456:	c9                   	leave  
80102457:	c3                   	ret    

80102458 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102458:	55                   	push   %ebp
80102459:	89 e5                	mov    %esp,%ebp
8010245b:	83 ec 14             	sub    $0x14,%esp
8010245e:	8b 45 08             	mov    0x8(%ebp),%eax
80102461:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102465:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102469:	89 c2                	mov    %eax,%edx
8010246b:	ec                   	in     (%dx),%al
8010246c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010246f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102473:	c9                   	leave  
80102474:	c3                   	ret    

80102475 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102475:	55                   	push   %ebp
80102476:	89 e5                	mov    %esp,%ebp
80102478:	57                   	push   %edi
80102479:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010247a:	8b 55 08             	mov    0x8(%ebp),%edx
8010247d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102480:	8b 45 10             	mov    0x10(%ebp),%eax
80102483:	89 cb                	mov    %ecx,%ebx
80102485:	89 df                	mov    %ebx,%edi
80102487:	89 c1                	mov    %eax,%ecx
80102489:	fc                   	cld    
8010248a:	f3 6d                	rep insl (%dx),%es:(%edi)
8010248c:	89 c8                	mov    %ecx,%eax
8010248e:	89 fb                	mov    %edi,%ebx
80102490:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102493:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102496:	5b                   	pop    %ebx
80102497:	5f                   	pop    %edi
80102498:	5d                   	pop    %ebp
80102499:	c3                   	ret    

8010249a <outb>:

static inline void
outb(ushort port, uchar data)
{
8010249a:	55                   	push   %ebp
8010249b:	89 e5                	mov    %esp,%ebp
8010249d:	83 ec 08             	sub    $0x8,%esp
801024a0:	8b 55 08             	mov    0x8(%ebp),%edx
801024a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801024a6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024aa:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024ad:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024b1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024b5:	ee                   	out    %al,(%dx)
}
801024b6:	c9                   	leave  
801024b7:	c3                   	ret    

801024b8 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024b8:	55                   	push   %ebp
801024b9:	89 e5                	mov    %esp,%ebp
801024bb:	56                   	push   %esi
801024bc:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024bd:	8b 55 08             	mov    0x8(%ebp),%edx
801024c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024c3:	8b 45 10             	mov    0x10(%ebp),%eax
801024c6:	89 cb                	mov    %ecx,%ebx
801024c8:	89 de                	mov    %ebx,%esi
801024ca:	89 c1                	mov    %eax,%ecx
801024cc:	fc                   	cld    
801024cd:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024cf:	89 c8                	mov    %ecx,%eax
801024d1:	89 f3                	mov    %esi,%ebx
801024d3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024d6:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024d9:	5b                   	pop    %ebx
801024da:	5e                   	pop    %esi
801024db:	5d                   	pop    %ebp
801024dc:	c3                   	ret    

801024dd <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024dd:	55                   	push   %ebp
801024de:	89 e5                	mov    %esp,%ebp
801024e0:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024e3:	90                   	nop
801024e4:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024eb:	e8 68 ff ff ff       	call   80102458 <inb>
801024f0:	0f b6 c0             	movzbl %al,%eax
801024f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
801024f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024f9:	25 c0 00 00 00       	and    $0xc0,%eax
801024fe:	83 f8 40             	cmp    $0x40,%eax
80102501:	75 e1                	jne    801024e4 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102503:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102507:	74 11                	je     8010251a <idewait+0x3d>
80102509:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010250c:	83 e0 21             	and    $0x21,%eax
8010250f:	85 c0                	test   %eax,%eax
80102511:	74 07                	je     8010251a <idewait+0x3d>
    return -1;
80102513:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102518:	eb 05                	jmp    8010251f <idewait+0x42>
  return 0;
8010251a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010251f:	c9                   	leave  
80102520:	c3                   	ret    

80102521 <ideinit>:

void
ideinit(void)
{
80102521:	55                   	push   %ebp
80102522:	89 e5                	mov    %esp,%ebp
80102524:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102527:	c7 44 24 04 a4 8c 10 	movl   $0x80108ca4,0x4(%esp)
8010252e:	80 
8010252f:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102536:	e8 18 2a 00 00       	call   80104f53 <initlock>
  picenable(IRQ_IDE);
8010253b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102542:	e8 39 15 00 00       	call   80103a80 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102547:	a1 20 0f 11 80       	mov    0x80110f20,%eax
8010254c:	83 e8 01             	sub    $0x1,%eax
8010254f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102553:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010255a:	e8 0c 04 00 00       	call   8010296b <ioapicenable>
  idewait(0);
8010255f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102566:	e8 72 ff ff ff       	call   801024dd <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010256b:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102572:	00 
80102573:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010257a:	e8 1b ff ff ff       	call   8010249a <outb>
  for(i=0; i<1000; i++){
8010257f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102586:	eb 20                	jmp    801025a8 <ideinit+0x87>
    if(inb(0x1f7) != 0){
80102588:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010258f:	e8 c4 fe ff ff       	call   80102458 <inb>
80102594:	84 c0                	test   %al,%al
80102596:	74 0c                	je     801025a4 <ideinit+0x83>
      havedisk1 = 1;
80102598:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
8010259f:	00 00 00 
      break;
801025a2:	eb 0d                	jmp    801025b1 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025a8:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025af:	7e d7                	jle    80102588 <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025b1:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025b8:	00 
801025b9:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025c0:	e8 d5 fe ff ff       	call   8010249a <outb>
}
801025c5:	c9                   	leave  
801025c6:	c3                   	ret    

801025c7 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025c7:	55                   	push   %ebp
801025c8:	89 e5                	mov    %esp,%ebp
801025ca:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025d1:	75 0c                	jne    801025df <idestart+0x18>
    panic("idestart");
801025d3:	c7 04 24 a8 8c 10 80 	movl   $0x80108ca8,(%esp)
801025da:	e8 5b df ff ff       	call   8010053a <panic>

  idewait(0);
801025df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025e6:	e8 f2 fe ff ff       	call   801024dd <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801025f2:	00 
801025f3:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801025fa:	e8 9b fe ff ff       	call   8010249a <outb>
  outb(0x1f2, 1);  // number of sectors
801025ff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102606:	00 
80102607:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
8010260e:	e8 87 fe ff ff       	call   8010249a <outb>
  outb(0x1f3, b->sector & 0xff);
80102613:	8b 45 08             	mov    0x8(%ebp),%eax
80102616:	8b 40 08             	mov    0x8(%eax),%eax
80102619:	0f b6 c0             	movzbl %al,%eax
8010261c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102620:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102627:	e8 6e fe ff ff       	call   8010249a <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
8010262c:	8b 45 08             	mov    0x8(%ebp),%eax
8010262f:	8b 40 08             	mov    0x8(%eax),%eax
80102632:	c1 e8 08             	shr    $0x8,%eax
80102635:	0f b6 c0             	movzbl %al,%eax
80102638:	89 44 24 04          	mov    %eax,0x4(%esp)
8010263c:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102643:	e8 52 fe ff ff       	call   8010249a <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
80102648:	8b 45 08             	mov    0x8(%ebp),%eax
8010264b:	8b 40 08             	mov    0x8(%eax),%eax
8010264e:	c1 e8 10             	shr    $0x10,%eax
80102651:	0f b6 c0             	movzbl %al,%eax
80102654:	89 44 24 04          	mov    %eax,0x4(%esp)
80102658:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
8010265f:	e8 36 fe ff ff       	call   8010249a <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102664:	8b 45 08             	mov    0x8(%ebp),%eax
80102667:	8b 40 04             	mov    0x4(%eax),%eax
8010266a:	83 e0 01             	and    $0x1,%eax
8010266d:	c1 e0 04             	shl    $0x4,%eax
80102670:	89 c2                	mov    %eax,%edx
80102672:	8b 45 08             	mov    0x8(%ebp),%eax
80102675:	8b 40 08             	mov    0x8(%eax),%eax
80102678:	c1 e8 18             	shr    $0x18,%eax
8010267b:	83 e0 0f             	and    $0xf,%eax
8010267e:	09 d0                	or     %edx,%eax
80102680:	83 c8 e0             	or     $0xffffffe0,%eax
80102683:	0f b6 c0             	movzbl %al,%eax
80102686:	89 44 24 04          	mov    %eax,0x4(%esp)
8010268a:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102691:	e8 04 fe ff ff       	call   8010249a <outb>
  if(b->flags & B_DIRTY){
80102696:	8b 45 08             	mov    0x8(%ebp),%eax
80102699:	8b 00                	mov    (%eax),%eax
8010269b:	83 e0 04             	and    $0x4,%eax
8010269e:	85 c0                	test   %eax,%eax
801026a0:	74 34                	je     801026d6 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026a2:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026a9:	00 
801026aa:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026b1:	e8 e4 fd ff ff       	call   8010249a <outb>
    outsl(0x1f0, b->data, 512/4);
801026b6:	8b 45 08             	mov    0x8(%ebp),%eax
801026b9:	83 c0 18             	add    $0x18,%eax
801026bc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026c3:	00 
801026c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801026c8:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026cf:	e8 e4 fd ff ff       	call   801024b8 <outsl>
801026d4:	eb 14                	jmp    801026ea <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026d6:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026dd:	00 
801026de:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026e5:	e8 b0 fd ff ff       	call   8010249a <outb>
  }
}
801026ea:	c9                   	leave  
801026eb:	c3                   	ret    

801026ec <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026ec:	55                   	push   %ebp
801026ed:	89 e5                	mov    %esp,%ebp
801026ef:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026f2:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801026f9:	e8 76 28 00 00       	call   80104f74 <acquire>
  if((b = idequeue) == 0){
801026fe:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102703:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102706:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010270a:	75 11                	jne    8010271d <ideintr+0x31>
    release(&idelock);
8010270c:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102713:	e8 be 28 00 00       	call   80104fd6 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102718:	e9 90 00 00 00       	jmp    801027ad <ideintr+0xc1>
  }
  idequeue = b->qnext;
8010271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102720:	8b 40 14             	mov    0x14(%eax),%eax
80102723:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102728:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010272b:	8b 00                	mov    (%eax),%eax
8010272d:	83 e0 04             	and    $0x4,%eax
80102730:	85 c0                	test   %eax,%eax
80102732:	75 2e                	jne    80102762 <ideintr+0x76>
80102734:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010273b:	e8 9d fd ff ff       	call   801024dd <idewait>
80102740:	85 c0                	test   %eax,%eax
80102742:	78 1e                	js     80102762 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102744:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102747:	83 c0 18             	add    $0x18,%eax
8010274a:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102751:	00 
80102752:	89 44 24 04          	mov    %eax,0x4(%esp)
80102756:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010275d:	e8 13 fd ff ff       	call   80102475 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102765:	8b 00                	mov    (%eax),%eax
80102767:	83 c8 02             	or     $0x2,%eax
8010276a:	89 c2                	mov    %eax,%edx
8010276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010276f:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102774:	8b 00                	mov    (%eax),%eax
80102776:	83 e0 fb             	and    $0xfffffffb,%eax
80102779:	89 c2                	mov    %eax,%edx
8010277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010277e:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102783:	89 04 24             	mov    %eax,(%esp)
80102786:	e8 cf 21 00 00       	call   8010495a <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010278b:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102790:	85 c0                	test   %eax,%eax
80102792:	74 0d                	je     801027a1 <ideintr+0xb5>
    idestart(idequeue);
80102794:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102799:	89 04 24             	mov    %eax,(%esp)
8010279c:	e8 26 fe ff ff       	call   801025c7 <idestart>

  release(&idelock);
801027a1:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801027a8:	e8 29 28 00 00       	call   80104fd6 <release>
}
801027ad:	c9                   	leave  
801027ae:	c3                   	ret    

801027af <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027af:	55                   	push   %ebp
801027b0:	89 e5                	mov    %esp,%ebp
801027b2:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027b5:	8b 45 08             	mov    0x8(%ebp),%eax
801027b8:	8b 00                	mov    (%eax),%eax
801027ba:	83 e0 01             	and    $0x1,%eax
801027bd:	85 c0                	test   %eax,%eax
801027bf:	75 0c                	jne    801027cd <iderw+0x1e>
    panic("iderw: buf not busy");
801027c1:	c7 04 24 b1 8c 10 80 	movl   $0x80108cb1,(%esp)
801027c8:	e8 6d dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027cd:	8b 45 08             	mov    0x8(%ebp),%eax
801027d0:	8b 00                	mov    (%eax),%eax
801027d2:	83 e0 06             	and    $0x6,%eax
801027d5:	83 f8 02             	cmp    $0x2,%eax
801027d8:	75 0c                	jne    801027e6 <iderw+0x37>
    panic("iderw: nothing to do");
801027da:	c7 04 24 c5 8c 10 80 	movl   $0x80108cc5,(%esp)
801027e1:	e8 54 dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027e6:	8b 45 08             	mov    0x8(%ebp),%eax
801027e9:	8b 40 04             	mov    0x4(%eax),%eax
801027ec:	85 c0                	test   %eax,%eax
801027ee:	74 15                	je     80102805 <iderw+0x56>
801027f0:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	75 0c                	jne    80102805 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027f9:	c7 04 24 da 8c 10 80 	movl   $0x80108cda,(%esp)
80102800:	e8 35 dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC: acquire-lock
80102805:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010280c:	e8 63 27 00 00       	call   80104f74 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102811:	8b 45 08             	mov    0x8(%ebp),%eax
80102814:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC: insert-queue
8010281b:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
80102822:	eb 0b                	jmp    8010282f <iderw+0x80>
80102824:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102827:	8b 00                	mov    (%eax),%eax
80102829:	83 c0 14             	add    $0x14,%eax
8010282c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102832:	8b 00                	mov    (%eax),%eax
80102834:	85 c0                	test   %eax,%eax
80102836:	75 ec                	jne    80102824 <iderw+0x75>
    ;
  *pp = b;
80102838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010283b:	8b 55 08             	mov    0x8(%ebp),%edx
8010283e:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102840:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102845:	3b 45 08             	cmp    0x8(%ebp),%eax
80102848:	75 0d                	jne    80102857 <iderw+0xa8>
    idestart(b);
8010284a:	8b 45 08             	mov    0x8(%ebp),%eax
8010284d:	89 04 24             	mov    %eax,(%esp)
80102850:	e8 72 fd ff ff       	call   801025c7 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102855:	eb 15                	jmp    8010286c <iderw+0xbd>
80102857:	eb 13                	jmp    8010286c <iderw+0xbd>
    sleep(b, &idelock);
80102859:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
80102860:	80 
80102861:	8b 45 08             	mov    0x8(%ebp),%eax
80102864:	89 04 24             	mov    %eax,(%esp)
80102867:	e8 15 20 00 00       	call   80104881 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010286c:	8b 45 08             	mov    0x8(%ebp),%eax
8010286f:	8b 00                	mov    (%eax),%eax
80102871:	83 e0 06             	and    $0x6,%eax
80102874:	83 f8 02             	cmp    $0x2,%eax
80102877:	75 e0                	jne    80102859 <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
80102879:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102880:	e8 51 27 00 00       	call   80104fd6 <release>
}
80102885:	c9                   	leave  
80102886:	c3                   	ret    

80102887 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102887:	55                   	push   %ebp
80102888:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010288a:	a1 54 08 11 80       	mov    0x80110854,%eax
8010288f:	8b 55 08             	mov    0x8(%ebp),%edx
80102892:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102894:	a1 54 08 11 80       	mov    0x80110854,%eax
80102899:	8b 40 10             	mov    0x10(%eax),%eax
}
8010289c:	5d                   	pop    %ebp
8010289d:	c3                   	ret    

8010289e <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
8010289e:	55                   	push   %ebp
8010289f:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028a1:	a1 54 08 11 80       	mov    0x80110854,%eax
801028a6:	8b 55 08             	mov    0x8(%ebp),%edx
801028a9:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028ab:	a1 54 08 11 80       	mov    0x80110854,%eax
801028b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801028b3:	89 50 10             	mov    %edx,0x10(%eax)
}
801028b6:	5d                   	pop    %ebp
801028b7:	c3                   	ret    

801028b8 <ioapicinit>:

void
ioapicinit(void)
{
801028b8:	55                   	push   %ebp
801028b9:	89 e5                	mov    %esp,%ebp
801028bb:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028be:	a1 24 09 11 80       	mov    0x80110924,%eax
801028c3:	85 c0                	test   %eax,%eax
801028c5:	75 05                	jne    801028cc <ioapicinit+0x14>
    return;
801028c7:	e9 9d 00 00 00       	jmp    80102969 <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028cc:	c7 05 54 08 11 80 00 	movl   $0xfec00000,0x80110854
801028d3:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028dd:	e8 a5 ff ff ff       	call   80102887 <ioapicread>
801028e2:	c1 e8 10             	shr    $0x10,%eax
801028e5:	25 ff 00 00 00       	and    $0xff,%eax
801028ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028f4:	e8 8e ff ff ff       	call   80102887 <ioapicread>
801028f9:	c1 e8 18             	shr    $0x18,%eax
801028fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801028ff:	0f b6 05 20 09 11 80 	movzbl 0x80110920,%eax
80102906:	0f b6 c0             	movzbl %al,%eax
80102909:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010290c:	74 0c                	je     8010291a <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010290e:	c7 04 24 f8 8c 10 80 	movl   $0x80108cf8,(%esp)
80102915:	e8 86 da ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010291a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102921:	eb 3e                	jmp    80102961 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102923:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102926:	83 c0 20             	add    $0x20,%eax
80102929:	0d 00 00 01 00       	or     $0x10000,%eax
8010292e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102931:	83 c2 08             	add    $0x8,%edx
80102934:	01 d2                	add    %edx,%edx
80102936:	89 44 24 04          	mov    %eax,0x4(%esp)
8010293a:	89 14 24             	mov    %edx,(%esp)
8010293d:	e8 5c ff ff ff       	call   8010289e <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102942:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102945:	83 c0 08             	add    $0x8,%eax
80102948:	01 c0                	add    %eax,%eax
8010294a:	83 c0 01             	add    $0x1,%eax
8010294d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102954:	00 
80102955:	89 04 24             	mov    %eax,(%esp)
80102958:	e8 41 ff ff ff       	call   8010289e <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010295d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102961:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102964:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102967:	7e ba                	jle    80102923 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102969:	c9                   	leave  
8010296a:	c3                   	ret    

8010296b <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
8010296b:	55                   	push   %ebp
8010296c:	89 e5                	mov    %esp,%ebp
8010296e:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102971:	a1 24 09 11 80       	mov    0x80110924,%eax
80102976:	85 c0                	test   %eax,%eax
80102978:	75 02                	jne    8010297c <ioapicenable+0x11>
    return;
8010297a:	eb 37                	jmp    801029b3 <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010297c:	8b 45 08             	mov    0x8(%ebp),%eax
8010297f:	83 c0 20             	add    $0x20,%eax
80102982:	8b 55 08             	mov    0x8(%ebp),%edx
80102985:	83 c2 08             	add    $0x8,%edx
80102988:	01 d2                	add    %edx,%edx
8010298a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010298e:	89 14 24             	mov    %edx,(%esp)
80102991:	e8 08 ff ff ff       	call   8010289e <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102996:	8b 45 0c             	mov    0xc(%ebp),%eax
80102999:	c1 e0 18             	shl    $0x18,%eax
8010299c:	8b 55 08             	mov    0x8(%ebp),%edx
8010299f:	83 c2 08             	add    $0x8,%edx
801029a2:	01 d2                	add    %edx,%edx
801029a4:	83 c2 01             	add    $0x1,%edx
801029a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801029ab:	89 14 24             	mov    %edx,(%esp)
801029ae:	e8 eb fe ff ff       	call   8010289e <ioapicwrite>
}
801029b3:	c9                   	leave  
801029b4:	c3                   	ret    

801029b5 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029b5:	55                   	push   %ebp
801029b6:	89 e5                	mov    %esp,%ebp
801029b8:	8b 45 08             	mov    0x8(%ebp),%eax
801029bb:	05 00 00 00 80       	add    $0x80000000,%eax
801029c0:	5d                   	pop    %ebp
801029c1:	c3                   	ret    

801029c2 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029c2:	55                   	push   %ebp
801029c3:	89 e5                	mov    %esp,%ebp
801029c5:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029c8:	c7 44 24 04 2a 8d 10 	movl   $0x80108d2a,0x4(%esp)
801029cf:	80 
801029d0:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
801029d7:	e8 77 25 00 00       	call   80104f53 <initlock>
  kmem.use_lock = 0;
801029dc:	c7 05 94 08 11 80 00 	movl   $0x0,0x80110894
801029e3:	00 00 00 
  freerange(vstart, vend);
801029e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801029e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801029ed:	8b 45 08             	mov    0x8(%ebp),%eax
801029f0:	89 04 24             	mov    %eax,(%esp)
801029f3:	e8 26 00 00 00       	call   80102a1e <freerange>
}
801029f8:	c9                   	leave  
801029f9:	c3                   	ret    

801029fa <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801029fa:	55                   	push   %ebp
801029fb:	89 e5                	mov    %esp,%ebp
801029fd:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a00:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a03:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a07:	8b 45 08             	mov    0x8(%ebp),%eax
80102a0a:	89 04 24             	mov    %eax,(%esp)
80102a0d:	e8 0c 00 00 00       	call   80102a1e <freerange>
  kmem.use_lock = 1;
80102a12:	c7 05 94 08 11 80 01 	movl   $0x1,0x80110894
80102a19:	00 00 00 
}
80102a1c:	c9                   	leave  
80102a1d:	c3                   	ret    

80102a1e <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a1e:	55                   	push   %ebp
80102a1f:	89 e5                	mov    %esp,%ebp
80102a21:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a24:	8b 45 08             	mov    0x8(%ebp),%eax
80102a27:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a34:	eb 12                	jmp    80102a48 <freerange+0x2a>
    kfree(p);
80102a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a39:	89 04 24             	mov    %eax,(%esp)
80102a3c:	e8 16 00 00 00       	call   80102a57 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a41:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a4b:	05 00 10 00 00       	add    $0x1000,%eax
80102a50:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a53:	76 e1                	jbe    80102a36 <freerange+0x18>
    kfree(p);
}
80102a55:	c9                   	leave  
80102a56:	c3                   	ret    

80102a57 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a57:	55                   	push   %ebp
80102a58:	89 e5                	mov    %esp,%ebp
80102a5a:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a5d:	8b 45 08             	mov    0x8(%ebp),%eax
80102a60:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a65:	85 c0                	test   %eax,%eax
80102a67:	75 1b                	jne    80102a84 <kfree+0x2d>
80102a69:	81 7d 08 54 b7 14 80 	cmpl   $0x8014b754,0x8(%ebp)
80102a70:	72 12                	jb     80102a84 <kfree+0x2d>
80102a72:	8b 45 08             	mov    0x8(%ebp),%eax
80102a75:	89 04 24             	mov    %eax,(%esp)
80102a78:	e8 38 ff ff ff       	call   801029b5 <v2p>
80102a7d:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a82:	76 0c                	jbe    80102a90 <kfree+0x39>
    panic("kfree");
80102a84:	c7 04 24 2f 8d 10 80 	movl   $0x80108d2f,(%esp)
80102a8b:	e8 aa da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a90:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a97:	00 
80102a98:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a9f:	00 
80102aa0:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa3:	89 04 24             	mov    %eax,(%esp)
80102aa6:	e8 1d 27 00 00       	call   801051c8 <memset>

  if(kmem.use_lock)
80102aab:	a1 94 08 11 80       	mov    0x80110894,%eax
80102ab0:	85 c0                	test   %eax,%eax
80102ab2:	74 0c                	je     80102ac0 <kfree+0x69>
    acquire(&kmem.lock);
80102ab4:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102abb:	e8 b4 24 00 00       	call   80104f74 <acquire>
  r = (struct run*)v;
80102ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ac6:	8b 15 98 08 11 80    	mov    0x80110898,%edx
80102acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102acf:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad4:	a3 98 08 11 80       	mov    %eax,0x80110898
  if(kmem.use_lock)
80102ad9:	a1 94 08 11 80       	mov    0x80110894,%eax
80102ade:	85 c0                	test   %eax,%eax
80102ae0:	74 0c                	je     80102aee <kfree+0x97>
    release(&kmem.lock);
80102ae2:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102ae9:	e8 e8 24 00 00       	call   80104fd6 <release>
}
80102aee:	c9                   	leave  
80102aef:	c3                   	ret    

80102af0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102af0:	55                   	push   %ebp
80102af1:	89 e5                	mov    %esp,%ebp
80102af3:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102af6:	a1 94 08 11 80       	mov    0x80110894,%eax
80102afb:	85 c0                	test   %eax,%eax
80102afd:	74 0c                	je     80102b0b <kalloc+0x1b>
    acquire(&kmem.lock);
80102aff:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102b06:	e8 69 24 00 00       	call   80104f74 <acquire>
  r = kmem.freelist;
80102b0b:	a1 98 08 11 80       	mov    0x80110898,%eax
80102b10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b17:	74 0a                	je     80102b23 <kalloc+0x33>
    kmem.freelist = r->next;
80102b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1c:	8b 00                	mov    (%eax),%eax
80102b1e:	a3 98 08 11 80       	mov    %eax,0x80110898
  if(kmem.use_lock)
80102b23:	a1 94 08 11 80       	mov    0x80110894,%eax
80102b28:	85 c0                	test   %eax,%eax
80102b2a:	74 0c                	je     80102b38 <kalloc+0x48>
    release(&kmem.lock);
80102b2c:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102b33:	e8 9e 24 00 00       	call   80104fd6 <release>
  return (char*)r;
80102b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b3b:	c9                   	leave  
80102b3c:	c3                   	ret    

80102b3d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b3d:	55                   	push   %ebp
80102b3e:	89 e5                	mov    %esp,%ebp
80102b40:	83 ec 14             	sub    $0x14,%esp
80102b43:	8b 45 08             	mov    0x8(%ebp),%eax
80102b46:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b4e:	89 c2                	mov    %eax,%edx
80102b50:	ec                   	in     (%dx),%al
80102b51:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b54:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b58:	c9                   	leave  
80102b59:	c3                   	ret    

80102b5a <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b5a:	55                   	push   %ebp
80102b5b:	89 e5                	mov    %esp,%ebp
80102b5d:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b60:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b67:	e8 d1 ff ff ff       	call   80102b3d <inb>
80102b6c:	0f b6 c0             	movzbl %al,%eax
80102b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b75:	83 e0 01             	and    $0x1,%eax
80102b78:	85 c0                	test   %eax,%eax
80102b7a:	75 0a                	jne    80102b86 <kbdgetc+0x2c>
    return -1;
80102b7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b81:	e9 25 01 00 00       	jmp    80102cab <kbdgetc+0x151>
  data = inb(KBDATAP);
80102b86:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102b8d:	e8 ab ff ff ff       	call   80102b3d <inb>
80102b92:	0f b6 c0             	movzbl %al,%eax
80102b95:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102b98:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102b9f:	75 17                	jne    80102bb8 <kbdgetc+0x5e>
    shift |= E0ESC;
80102ba1:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ba6:	83 c8 40             	or     $0x40,%eax
80102ba9:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102bae:	b8 00 00 00 00       	mov    $0x0,%eax
80102bb3:	e9 f3 00 00 00       	jmp    80102cab <kbdgetc+0x151>
  } else if(data & 0x80){
80102bb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bbb:	25 80 00 00 00       	and    $0x80,%eax
80102bc0:	85 c0                	test   %eax,%eax
80102bc2:	74 45                	je     80102c09 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bc4:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102bc9:	83 e0 40             	and    $0x40,%eax
80102bcc:	85 c0                	test   %eax,%eax
80102bce:	75 08                	jne    80102bd8 <kbdgetc+0x7e>
80102bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bd3:	83 e0 7f             	and    $0x7f,%eax
80102bd6:	eb 03                	jmp    80102bdb <kbdgetc+0x81>
80102bd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102bde:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102be1:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102be6:	0f b6 00             	movzbl (%eax),%eax
80102be9:	83 c8 40             	or     $0x40,%eax
80102bec:	0f b6 c0             	movzbl %al,%eax
80102bef:	f7 d0                	not    %eax
80102bf1:	89 c2                	mov    %eax,%edx
80102bf3:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102bf8:	21 d0                	and    %edx,%eax
80102bfa:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102bff:	b8 00 00 00 00       	mov    $0x0,%eax
80102c04:	e9 a2 00 00 00       	jmp    80102cab <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102c09:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c0e:	83 e0 40             	and    $0x40,%eax
80102c11:	85 c0                	test   %eax,%eax
80102c13:	74 14                	je     80102c29 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c15:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c1c:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c21:	83 e0 bf             	and    $0xffffffbf,%eax
80102c24:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102c29:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c2c:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c31:	0f b6 00             	movzbl (%eax),%eax
80102c34:	0f b6 d0             	movzbl %al,%edx
80102c37:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c3c:	09 d0                	or     %edx,%eax
80102c3e:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102c43:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c46:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102c4b:	0f b6 00             	movzbl (%eax),%eax
80102c4e:	0f b6 d0             	movzbl %al,%edx
80102c51:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c56:	31 d0                	xor    %edx,%eax
80102c58:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c5d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c62:	83 e0 03             	and    $0x3,%eax
80102c65:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102c6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c6f:	01 d0                	add    %edx,%eax
80102c71:	0f b6 00             	movzbl (%eax),%eax
80102c74:	0f b6 c0             	movzbl %al,%eax
80102c77:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c7a:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c7f:	83 e0 08             	and    $0x8,%eax
80102c82:	85 c0                	test   %eax,%eax
80102c84:	74 22                	je     80102ca8 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102c86:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102c8a:	76 0c                	jbe    80102c98 <kbdgetc+0x13e>
80102c8c:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102c90:	77 06                	ja     80102c98 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102c92:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102c96:	eb 10                	jmp    80102ca8 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102c98:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102c9c:	76 0a                	jbe    80102ca8 <kbdgetc+0x14e>
80102c9e:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102ca2:	77 04                	ja     80102ca8 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102ca4:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102ca8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102cab:	c9                   	leave  
80102cac:	c3                   	ret    

80102cad <kbdintr>:

void
kbdintr(void)
{
80102cad:	55                   	push   %ebp
80102cae:	89 e5                	mov    %esp,%ebp
80102cb0:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102cb3:	c7 04 24 5a 2b 10 80 	movl   $0x80102b5a,(%esp)
80102cba:	e8 ee da ff ff       	call   801007ad <consoleintr>
}
80102cbf:	c9                   	leave  
80102cc0:	c3                   	ret    

80102cc1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102cc1:	55                   	push   %ebp
80102cc2:	89 e5                	mov    %esp,%ebp
80102cc4:	83 ec 08             	sub    $0x8,%esp
80102cc7:	8b 55 08             	mov    0x8(%ebp),%edx
80102cca:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ccd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102cd1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102cd8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102cdc:	ee                   	out    %al,(%dx)
}
80102cdd:	c9                   	leave  
80102cde:	c3                   	ret    

80102cdf <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102cdf:	55                   	push   %ebp
80102ce0:	89 e5                	mov    %esp,%ebp
80102ce2:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102ce5:	9c                   	pushf  
80102ce6:	58                   	pop    %eax
80102ce7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102ced:	c9                   	leave  
80102cee:	c3                   	ret    

80102cef <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102cef:	55                   	push   %ebp
80102cf0:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102cf2:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102cf7:	8b 55 08             	mov    0x8(%ebp),%edx
80102cfa:	c1 e2 02             	shl    $0x2,%edx
80102cfd:	01 c2                	add    %eax,%edx
80102cff:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d02:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d04:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102d09:	83 c0 20             	add    $0x20,%eax
80102d0c:	8b 00                	mov    (%eax),%eax
}
80102d0e:	5d                   	pop    %ebp
80102d0f:	c3                   	ret    

80102d10 <lapicinit>:
//PAGEBREAK!

void
lapicinit(int c)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d16:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102d1b:	85 c0                	test   %eax,%eax
80102d1d:	75 05                	jne    80102d24 <lapicinit+0x14>
    return;
80102d1f:	e9 43 01 00 00       	jmp    80102e67 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d24:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d2b:	00 
80102d2c:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d33:	e8 b7 ff ff ff       	call   80102cef <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d38:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d3f:	00 
80102d40:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d47:	e8 a3 ff ff ff       	call   80102cef <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d4c:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d53:	00 
80102d54:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d5b:	e8 8f ff ff ff       	call   80102cef <lapicw>
  lapicw(TICR, 10000000); 
80102d60:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d67:	00 
80102d68:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d6f:	e8 7b ff ff ff       	call   80102cef <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d74:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d7b:	00 
80102d7c:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102d83:	e8 67 ff ff ff       	call   80102cef <lapicw>
  lapicw(LINT1, MASKED);
80102d88:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d8f:	00 
80102d90:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102d97:	e8 53 ff ff ff       	call   80102cef <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102d9c:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102da1:	83 c0 30             	add    $0x30,%eax
80102da4:	8b 00                	mov    (%eax),%eax
80102da6:	c1 e8 10             	shr    $0x10,%eax
80102da9:	0f b6 c0             	movzbl %al,%eax
80102dac:	83 f8 03             	cmp    $0x3,%eax
80102daf:	76 14                	jbe    80102dc5 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102db1:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102db8:	00 
80102db9:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102dc0:	e8 2a ff ff ff       	call   80102cef <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102dc5:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102dcc:	00 
80102dcd:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102dd4:	e8 16 ff ff ff       	call   80102cef <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102dd9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102de0:	00 
80102de1:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102de8:	e8 02 ff ff ff       	call   80102cef <lapicw>
  lapicw(ESR, 0);
80102ded:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102df4:	00 
80102df5:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102dfc:	e8 ee fe ff ff       	call   80102cef <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e01:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e08:	00 
80102e09:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e10:	e8 da fe ff ff       	call   80102cef <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e15:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e1c:	00 
80102e1d:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e24:	e8 c6 fe ff ff       	call   80102cef <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e29:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e30:	00 
80102e31:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e38:	e8 b2 fe ff ff       	call   80102cef <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e3d:	90                   	nop
80102e3e:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102e43:	05 00 03 00 00       	add    $0x300,%eax
80102e48:	8b 00                	mov    (%eax),%eax
80102e4a:	25 00 10 00 00       	and    $0x1000,%eax
80102e4f:	85 c0                	test   %eax,%eax
80102e51:	75 eb                	jne    80102e3e <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e53:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e5a:	00 
80102e5b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e62:	e8 88 fe ff ff       	call   80102cef <lapicw>
}
80102e67:	c9                   	leave  
80102e68:	c3                   	ret    

80102e69 <cpunum>:

int
cpunum(void)
{
80102e69:	55                   	push   %ebp
80102e6a:	89 e5                	mov    %esp,%ebp
80102e6c:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e6f:	e8 6b fe ff ff       	call   80102cdf <readeflags>
80102e74:	25 00 02 00 00       	and    $0x200,%eax
80102e79:	85 c0                	test   %eax,%eax
80102e7b:	74 25                	je     80102ea2 <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102e7d:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102e82:	8d 50 01             	lea    0x1(%eax),%edx
80102e85:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80102e8b:	85 c0                	test   %eax,%eax
80102e8d:	75 13                	jne    80102ea2 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102e8f:	8b 45 04             	mov    0x4(%ebp),%eax
80102e92:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e96:	c7 04 24 38 8d 10 80 	movl   $0x80108d38,(%esp)
80102e9d:	e8 fe d4 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102ea2:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102ea7:	85 c0                	test   %eax,%eax
80102ea9:	74 0f                	je     80102eba <cpunum+0x51>
    return lapic[ID]>>24;
80102eab:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102eb0:	83 c0 20             	add    $0x20,%eax
80102eb3:	8b 00                	mov    (%eax),%eax
80102eb5:	c1 e8 18             	shr    $0x18,%eax
80102eb8:	eb 05                	jmp    80102ebf <cpunum+0x56>
  return 0;
80102eba:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ebf:	c9                   	leave  
80102ec0:	c3                   	ret    

80102ec1 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ec1:	55                   	push   %ebp
80102ec2:	89 e5                	mov    %esp,%ebp
80102ec4:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102ec7:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102ecc:	85 c0                	test   %eax,%eax
80102ece:	74 14                	je     80102ee4 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102ed0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ed7:	00 
80102ed8:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102edf:	e8 0b fe ff ff       	call   80102cef <lapicw>
}
80102ee4:	c9                   	leave  
80102ee5:	c3                   	ret    

80102ee6 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ee6:	55                   	push   %ebp
80102ee7:	89 e5                	mov    %esp,%ebp
}
80102ee9:	5d                   	pop    %ebp
80102eea:	c3                   	ret    

80102eeb <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102eeb:	55                   	push   %ebp
80102eec:	89 e5                	mov    %esp,%ebp
80102eee:	83 ec 1c             	sub    $0x1c,%esp
80102ef1:	8b 45 08             	mov    0x8(%ebp),%eax
80102ef4:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102ef7:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102efe:	00 
80102eff:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f06:	e8 b6 fd ff ff       	call   80102cc1 <outb>
  outb(IO_RTC+1, 0x0A);
80102f0b:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f12:	00 
80102f13:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f1a:	e8 a2 fd ff ff       	call   80102cc1 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f1f:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f29:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f31:	8d 50 02             	lea    0x2(%eax),%edx
80102f34:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f37:	c1 e8 04             	shr    $0x4,%eax
80102f3a:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f3d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f41:	c1 e0 18             	shl    $0x18,%eax
80102f44:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f48:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f4f:	e8 9b fd ff ff       	call   80102cef <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f54:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f5b:	00 
80102f5c:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f63:	e8 87 fd ff ff       	call   80102cef <lapicw>
  microdelay(200);
80102f68:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f6f:	e8 72 ff ff ff       	call   80102ee6 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f74:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102f7b:	00 
80102f7c:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f83:	e8 67 fd ff ff       	call   80102cef <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102f88:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102f8f:	e8 52 ff ff ff       	call   80102ee6 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102f94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102f9b:	eb 40                	jmp    80102fdd <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102f9d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fa1:	c1 e0 18             	shl    $0x18,%eax
80102fa4:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fa8:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102faf:	e8 3b fd ff ff       	call   80102cef <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fb7:	c1 e8 0c             	shr    $0xc,%eax
80102fba:	80 cc 06             	or     $0x6,%ah
80102fbd:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fc1:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fc8:	e8 22 fd ff ff       	call   80102cef <lapicw>
    microdelay(200);
80102fcd:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fd4:	e8 0d ff ff ff       	call   80102ee6 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fd9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102fdd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102fe1:	7e ba                	jle    80102f9d <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102fe3:	c9                   	leave  
80102fe4:	c3                   	ret    

80102fe5 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80102fe5:	55                   	push   %ebp
80102fe6:	89 e5                	mov    %esp,%ebp
80102fe8:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102feb:	c7 44 24 04 64 8d 10 	movl   $0x80108d64,0x4(%esp)
80102ff2:	80 
80102ff3:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80102ffa:	e8 54 1f 00 00       	call   80104f53 <initlock>
  readsb(ROOTDEV, &sb);
80102fff:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103002:	89 44 24 04          	mov    %eax,0x4(%esp)
80103006:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010300d:	e8 ed e2 ff ff       	call   801012ff <readsb>
  log.start = sb.size - sb.nlog;
80103012:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103015:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103018:	29 c2                	sub    %eax,%edx
8010301a:	89 d0                	mov    %edx,%eax
8010301c:	a3 d4 08 11 80       	mov    %eax,0x801108d4
  log.size = sb.nlog;
80103021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103024:	a3 d8 08 11 80       	mov    %eax,0x801108d8
  log.dev = ROOTDEV;
80103029:	c7 05 e0 08 11 80 01 	movl   $0x1,0x801108e0
80103030:	00 00 00 
  recover_from_log();
80103033:	e8 9a 01 00 00       	call   801031d2 <recover_from_log>
}
80103038:	c9                   	leave  
80103039:	c3                   	ret    

8010303a <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010303a:	55                   	push   %ebp
8010303b:	89 e5                	mov    %esp,%ebp
8010303d:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103040:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103047:	e9 8c 00 00 00       	jmp    801030d8 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010304c:	8b 15 d4 08 11 80    	mov    0x801108d4,%edx
80103052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103055:	01 d0                	add    %edx,%eax
80103057:	83 c0 01             	add    $0x1,%eax
8010305a:	89 c2                	mov    %eax,%edx
8010305c:	a1 e0 08 11 80       	mov    0x801108e0,%eax
80103061:	89 54 24 04          	mov    %edx,0x4(%esp)
80103065:	89 04 24             	mov    %eax,(%esp)
80103068:	e8 39 d1 ff ff       	call   801001a6 <bread>
8010306d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103070:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103073:	83 c0 10             	add    $0x10,%eax
80103076:	8b 04 85 a8 08 11 80 	mov    -0x7feef758(,%eax,4),%eax
8010307d:	89 c2                	mov    %eax,%edx
8010307f:	a1 e0 08 11 80       	mov    0x801108e0,%eax
80103084:	89 54 24 04          	mov    %edx,0x4(%esp)
80103088:	89 04 24             	mov    %eax,(%esp)
8010308b:	e8 16 d1 ff ff       	call   801001a6 <bread>
80103090:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103093:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103096:	8d 50 18             	lea    0x18(%eax),%edx
80103099:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010309c:	83 c0 18             	add    $0x18,%eax
8010309f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801030a6:	00 
801030a7:	89 54 24 04          	mov    %edx,0x4(%esp)
801030ab:	89 04 24             	mov    %eax,(%esp)
801030ae:	e8 e4 21 00 00       	call   80105297 <memmove>
    bwrite(dbuf);  // write dst to disk
801030b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030b6:	89 04 24             	mov    %eax,(%esp)
801030b9:	e8 1f d1 ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
801030be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030c1:	89 04 24             	mov    %eax,(%esp)
801030c4:	e8 4e d1 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801030c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030cc:	89 04 24             	mov    %eax,(%esp)
801030cf:	e8 43 d1 ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801030d8:	a1 e4 08 11 80       	mov    0x801108e4,%eax
801030dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801030e0:	0f 8f 66 ff ff ff    	jg     8010304c <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801030e6:	c9                   	leave  
801030e7:	c3                   	ret    

801030e8 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801030e8:	55                   	push   %ebp
801030e9:	89 e5                	mov    %esp,%ebp
801030eb:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801030ee:	a1 d4 08 11 80       	mov    0x801108d4,%eax
801030f3:	89 c2                	mov    %eax,%edx
801030f5:	a1 e0 08 11 80       	mov    0x801108e0,%eax
801030fa:	89 54 24 04          	mov    %edx,0x4(%esp)
801030fe:	89 04 24             	mov    %eax,(%esp)
80103101:	e8 a0 d0 ff ff       	call   801001a6 <bread>
80103106:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103109:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010310c:	83 c0 18             	add    $0x18,%eax
8010310f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103112:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103115:	8b 00                	mov    (%eax),%eax
80103117:	a3 e4 08 11 80       	mov    %eax,0x801108e4
  for (i = 0; i < log.lh.n; i++) {
8010311c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103123:	eb 1b                	jmp    80103140 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
80103125:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103128:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010312b:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010312f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103132:	83 c2 10             	add    $0x10,%edx
80103135:	89 04 95 a8 08 11 80 	mov    %eax,-0x7feef758(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010313c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103140:	a1 e4 08 11 80       	mov    0x801108e4,%eax
80103145:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103148:	7f db                	jg     80103125 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
8010314a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010314d:	89 04 24             	mov    %eax,(%esp)
80103150:	e8 c2 d0 ff ff       	call   80100217 <brelse>
}
80103155:	c9                   	leave  
80103156:	c3                   	ret    

80103157 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103157:	55                   	push   %ebp
80103158:	89 e5                	mov    %esp,%ebp
8010315a:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010315d:	a1 d4 08 11 80       	mov    0x801108d4,%eax
80103162:	89 c2                	mov    %eax,%edx
80103164:	a1 e0 08 11 80       	mov    0x801108e0,%eax
80103169:	89 54 24 04          	mov    %edx,0x4(%esp)
8010316d:	89 04 24             	mov    %eax,(%esp)
80103170:	e8 31 d0 ff ff       	call   801001a6 <bread>
80103175:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103178:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010317b:	83 c0 18             	add    $0x18,%eax
8010317e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103181:	8b 15 e4 08 11 80    	mov    0x801108e4,%edx
80103187:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010318a:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010318c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103193:	eb 1b                	jmp    801031b0 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
80103195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103198:	83 c0 10             	add    $0x10,%eax
8010319b:	8b 0c 85 a8 08 11 80 	mov    -0x7feef758(,%eax,4),%ecx
801031a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031a8:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801031ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031b0:	a1 e4 08 11 80       	mov    0x801108e4,%eax
801031b5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031b8:	7f db                	jg     80103195 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801031ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031bd:	89 04 24             	mov    %eax,(%esp)
801031c0:	e8 18 d0 ff ff       	call   801001dd <bwrite>
  brelse(buf);
801031c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031c8:	89 04 24             	mov    %eax,(%esp)
801031cb:	e8 47 d0 ff ff       	call   80100217 <brelse>
}
801031d0:	c9                   	leave  
801031d1:	c3                   	ret    

801031d2 <recover_from_log>:

static void
recover_from_log(void)
{
801031d2:	55                   	push   %ebp
801031d3:	89 e5                	mov    %esp,%ebp
801031d5:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801031d8:	e8 0b ff ff ff       	call   801030e8 <read_head>
  install_trans(); // if committed, copy from log to disk
801031dd:	e8 58 fe ff ff       	call   8010303a <install_trans>
  log.lh.n = 0;
801031e2:	c7 05 e4 08 11 80 00 	movl   $0x0,0x801108e4
801031e9:	00 00 00 
  write_head(); // clear the log
801031ec:	e8 66 ff ff ff       	call   80103157 <write_head>
}
801031f1:	c9                   	leave  
801031f2:	c3                   	ret    

801031f3 <begin_trans>:

void
begin_trans(void)
{
801031f3:	55                   	push   %ebp
801031f4:	89 e5                	mov    %esp,%ebp
801031f6:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801031f9:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80103200:	e8 6f 1d 00 00       	call   80104f74 <acquire>
  while (log.busy) {
80103205:	eb 14                	jmp    8010321b <begin_trans+0x28>
    sleep(&log, &log.lock);
80103207:	c7 44 24 04 a0 08 11 	movl   $0x801108a0,0x4(%esp)
8010320e:	80 
8010320f:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80103216:	e8 66 16 00 00       	call   80104881 <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
8010321b:	a1 dc 08 11 80       	mov    0x801108dc,%eax
80103220:	85 c0                	test   %eax,%eax
80103222:	75 e3                	jne    80103207 <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
80103224:	c7 05 dc 08 11 80 01 	movl   $0x1,0x801108dc
8010322b:	00 00 00 
  release(&log.lock);
8010322e:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80103235:	e8 9c 1d 00 00       	call   80104fd6 <release>
}
8010323a:	c9                   	leave  
8010323b:	c3                   	ret    

8010323c <commit_trans>:

void
commit_trans(void)
{
8010323c:	55                   	push   %ebp
8010323d:	89 e5                	mov    %esp,%ebp
8010323f:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
80103242:	a1 e4 08 11 80       	mov    0x801108e4,%eax
80103247:	85 c0                	test   %eax,%eax
80103249:	7e 19                	jle    80103264 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
8010324b:	e8 07 ff ff ff       	call   80103157 <write_head>
    install_trans(); // Now install writes to home locations
80103250:	e8 e5 fd ff ff       	call   8010303a <install_trans>
    log.lh.n = 0; 
80103255:	c7 05 e4 08 11 80 00 	movl   $0x0,0x801108e4
8010325c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010325f:	e8 f3 fe ff ff       	call   80103157 <write_head>
  }
  
  acquire(&log.lock);
80103264:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
8010326b:	e8 04 1d 00 00       	call   80104f74 <acquire>
  log.busy = 0;
80103270:	c7 05 dc 08 11 80 00 	movl   $0x0,0x801108dc
80103277:	00 00 00 
  wakeup(&log);
8010327a:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80103281:	e8 d4 16 00 00       	call   8010495a <wakeup>
  release(&log.lock);
80103286:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
8010328d:	e8 44 1d 00 00       	call   80104fd6 <release>
}
80103292:	c9                   	leave  
80103293:	c3                   	ret    

80103294 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103294:	55                   	push   %ebp
80103295:	89 e5                	mov    %esp,%ebp
80103297:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010329a:	a1 e4 08 11 80       	mov    0x801108e4,%eax
8010329f:	83 f8 09             	cmp    $0x9,%eax
801032a2:	7f 12                	jg     801032b6 <log_write+0x22>
801032a4:	a1 e4 08 11 80       	mov    0x801108e4,%eax
801032a9:	8b 15 d8 08 11 80    	mov    0x801108d8,%edx
801032af:	83 ea 01             	sub    $0x1,%edx
801032b2:	39 d0                	cmp    %edx,%eax
801032b4:	7c 0c                	jl     801032c2 <log_write+0x2e>
    panic("too big a transaction");
801032b6:	c7 04 24 68 8d 10 80 	movl   $0x80108d68,(%esp)
801032bd:	e8 78 d2 ff ff       	call   8010053a <panic>
  if (!log.busy)
801032c2:	a1 dc 08 11 80       	mov    0x801108dc,%eax
801032c7:	85 c0                	test   %eax,%eax
801032c9:	75 0c                	jne    801032d7 <log_write+0x43>
    panic("write outside of trans");
801032cb:	c7 04 24 7e 8d 10 80 	movl   $0x80108d7e,(%esp)
801032d2:	e8 63 d2 ff ff       	call   8010053a <panic>

  for (i = 0; i < log.lh.n; i++) {
801032d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032de:	eb 1f                	jmp    801032ff <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801032e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032e3:	83 c0 10             	add    $0x10,%eax
801032e6:	8b 04 85 a8 08 11 80 	mov    -0x7feef758(,%eax,4),%eax
801032ed:	89 c2                	mov    %eax,%edx
801032ef:	8b 45 08             	mov    0x8(%ebp),%eax
801032f2:	8b 40 08             	mov    0x8(%eax),%eax
801032f5:	39 c2                	cmp    %eax,%edx
801032f7:	75 02                	jne    801032fb <log_write+0x67>
      break;
801032f9:	eb 0e                	jmp    80103309 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
801032fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801032ff:	a1 e4 08 11 80       	mov    0x801108e4,%eax
80103304:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103307:	7f d7                	jg     801032e0 <log_write+0x4c>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
  }
  log.lh.sector[i] = b->sector;
80103309:	8b 45 08             	mov    0x8(%ebp),%eax
8010330c:	8b 40 08             	mov    0x8(%eax),%eax
8010330f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103312:	83 c2 10             	add    $0x10,%edx
80103315:	89 04 95 a8 08 11 80 	mov    %eax,-0x7feef758(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
8010331c:	8b 15 d4 08 11 80    	mov    0x801108d4,%edx
80103322:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103325:	01 d0                	add    %edx,%eax
80103327:	83 c0 01             	add    $0x1,%eax
8010332a:	89 c2                	mov    %eax,%edx
8010332c:	8b 45 08             	mov    0x8(%ebp),%eax
8010332f:	8b 40 04             	mov    0x4(%eax),%eax
80103332:	89 54 24 04          	mov    %edx,0x4(%esp)
80103336:	89 04 24             	mov    %eax,(%esp)
80103339:	e8 68 ce ff ff       	call   801001a6 <bread>
8010333e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103341:	8b 45 08             	mov    0x8(%ebp),%eax
80103344:	8d 50 18             	lea    0x18(%eax),%edx
80103347:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010334a:	83 c0 18             	add    $0x18,%eax
8010334d:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103354:	00 
80103355:	89 54 24 04          	mov    %edx,0x4(%esp)
80103359:	89 04 24             	mov    %eax,(%esp)
8010335c:	e8 36 1f 00 00       	call   80105297 <memmove>
  bwrite(lbuf);
80103361:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103364:	89 04 24             	mov    %eax,(%esp)
80103367:	e8 71 ce ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
8010336c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010336f:	89 04 24             	mov    %eax,(%esp)
80103372:	e8 a0 ce ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
80103377:	a1 e4 08 11 80       	mov    0x801108e4,%eax
8010337c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010337f:	75 0d                	jne    8010338e <log_write+0xfa>
    log.lh.n++;
80103381:	a1 e4 08 11 80       	mov    0x801108e4,%eax
80103386:	83 c0 01             	add    $0x1,%eax
80103389:	a3 e4 08 11 80       	mov    %eax,0x801108e4
  b->flags |= B_DIRTY; // XXX prevent eviction
8010338e:	8b 45 08             	mov    0x8(%ebp),%eax
80103391:	8b 00                	mov    (%eax),%eax
80103393:	83 c8 04             	or     $0x4,%eax
80103396:	89 c2                	mov    %eax,%edx
80103398:	8b 45 08             	mov    0x8(%ebp),%eax
8010339b:	89 10                	mov    %edx,(%eax)
}
8010339d:	c9                   	leave  
8010339e:	c3                   	ret    

8010339f <v2p>:
8010339f:	55                   	push   %ebp
801033a0:	89 e5                	mov    %esp,%ebp
801033a2:	8b 45 08             	mov    0x8(%ebp),%eax
801033a5:	05 00 00 00 80       	add    $0x80000000,%eax
801033aa:	5d                   	pop    %ebp
801033ab:	c3                   	ret    

801033ac <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801033ac:	55                   	push   %ebp
801033ad:	89 e5                	mov    %esp,%ebp
801033af:	8b 45 08             	mov    0x8(%ebp),%eax
801033b2:	05 00 00 00 80       	add    $0x80000000,%eax
801033b7:	5d                   	pop    %ebp
801033b8:	c3                   	ret    

801033b9 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801033b9:	55                   	push   %ebp
801033ba:	89 e5                	mov    %esp,%ebp
801033bc:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033bf:	8b 55 08             	mov    0x8(%ebp),%edx
801033c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801033c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
801033c8:	f0 87 02             	lock xchg %eax,(%edx)
801033cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801033ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801033d1:	c9                   	leave  
801033d2:	c3                   	ret    

801033d3 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801033d3:	55                   	push   %ebp
801033d4:	89 e5                	mov    %esp,%ebp
801033d6:	83 e4 f0             	and    $0xfffffff0,%esp
801033d9:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033dc:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801033e3:	80 
801033e4:	c7 04 24 54 b7 14 80 	movl   $0x8014b754,(%esp)
801033eb:	e8 d2 f5 ff ff       	call   801029c2 <kinit1>
  kvmalloc();      // kernel page table
801033f0:	e8 39 4a 00 00       	call   80107e2e <kvmalloc>
  mpinit();        // collect info about this machine
801033f5:	e8 56 04 00 00       	call   80103850 <mpinit>
  lapicinit(mpbcpu());
801033fa:	e8 1f 02 00 00       	call   8010361e <mpbcpu>
801033ff:	89 04 24             	mov    %eax,(%esp)
80103402:	e8 09 f9 ff ff       	call   80102d10 <lapicinit>
  seginit();       // set up segments
80103407:	e8 79 43 00 00       	call   80107785 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010340c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103412:	0f b6 00             	movzbl (%eax),%eax
80103415:	0f b6 c0             	movzbl %al,%eax
80103418:	89 44 24 04          	mov    %eax,0x4(%esp)
8010341c:	c7 04 24 95 8d 10 80 	movl   $0x80108d95,(%esp)
80103423:	e8 78 cf ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
80103428:	e8 81 06 00 00       	call   80103aae <picinit>
  ioapicinit();    // another interrupt controller
8010342d:	e8 86 f4 ff ff       	call   801028b8 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103432:	e8 4a d6 ff ff       	call   80100a81 <consoleinit>
  uartinit();      // serial port
80103437:	e8 87 36 00 00       	call   80106ac3 <uartinit>
  pinit();         // process table
8010343c:	e8 84 0b 00 00       	call   80103fc5 <pinit>
  tvinit();        // trap vectors
80103441:	e8 0a 32 00 00       	call   80106650 <tvinit>
  binit();         // buffer cache
80103446:	e8 e9 cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010344b:	e8 c8 da ff ff       	call   80100f18 <fileinit>
  iinit();         // inode cache
80103450:	e8 5d e1 ff ff       	call   801015b2 <iinit>
  ideinit();       // disk
80103455:	e8 c7 f0 ff ff       	call   80102521 <ideinit>
  if(!ismp)
8010345a:	a1 24 09 11 80       	mov    0x80110924,%eax
8010345f:	85 c0                	test   %eax,%eax
80103461:	75 05                	jne    80103468 <main+0x95>
    timerinit();   // uniprocessor timer
80103463:	e8 33 31 00 00       	call   8010659b <timerinit>
  startothers();   // start other processors
80103468:	e8 87 00 00 00       	call   801034f4 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010346d:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103474:	8e 
80103475:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
8010347c:	e8 79 f5 ff ff       	call   801029fa <kinit2>
  userinit();      // first user process
80103481:	e8 5a 0c 00 00       	call   801040e0 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103486:	e8 22 00 00 00       	call   801034ad <mpmain>

8010348b <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010348b:	55                   	push   %ebp
8010348c:	89 e5                	mov    %esp,%ebp
8010348e:	83 ec 18             	sub    $0x18,%esp
  switchkvm(); 
80103491:	e8 af 49 00 00       	call   80107e45 <switchkvm>
  seginit();
80103496:	e8 ea 42 00 00       	call   80107785 <seginit>
  lapicinit(cpunum());
8010349b:	e8 c9 f9 ff ff       	call   80102e69 <cpunum>
801034a0:	89 04 24             	mov    %eax,(%esp)
801034a3:	e8 68 f8 ff ff       	call   80102d10 <lapicinit>
  mpmain();
801034a8:	e8 00 00 00 00       	call   801034ad <mpmain>

801034ad <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034ad:	55                   	push   %ebp
801034ae:	89 e5                	mov    %esp,%ebp
801034b0:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801034b3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034b9:	0f b6 00             	movzbl (%eax),%eax
801034bc:	0f b6 c0             	movzbl %al,%eax
801034bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801034c3:	c7 04 24 ac 8d 10 80 	movl   $0x80108dac,(%esp)
801034ca:	e8 d1 ce ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
801034cf:	e8 f0 32 00 00       	call   801067c4 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034d4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034da:	05 a8 00 00 00       	add    $0xa8,%eax
801034df:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034e6:	00 
801034e7:	89 04 24             	mov    %eax,(%esp)
801034ea:	e8 ca fe ff ff       	call   801033b9 <xchg>
  scheduler();     // start running processes
801034ef:	e8 e5 11 00 00       	call   801046d9 <scheduler>

801034f4 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801034f4:	55                   	push   %ebp
801034f5:	89 e5                	mov    %esp,%ebp
801034f7:	53                   	push   %ebx
801034f8:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801034fb:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103502:	e8 a5 fe ff ff       	call   801033ac <p2v>
80103507:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010350a:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010350f:	89 44 24 08          	mov    %eax,0x8(%esp)
80103513:	c7 44 24 04 2c c5 10 	movl   $0x8010c52c,0x4(%esp)
8010351a:	80 
8010351b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010351e:	89 04 24             	mov    %eax,(%esp)
80103521:	e8 71 1d 00 00       	call   80105297 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103526:	c7 45 f4 40 09 11 80 	movl   $0x80110940,-0xc(%ebp)
8010352d:	e9 85 00 00 00       	jmp    801035b7 <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
80103532:	e8 32 f9 ff ff       	call   80102e69 <cpunum>
80103537:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010353d:	05 40 09 11 80       	add    $0x80110940,%eax
80103542:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103545:	75 02                	jne    80103549 <startothers+0x55>
      continue;
80103547:	eb 67                	jmp    801035b0 <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103549:	e8 a2 f5 ff ff       	call   80102af0 <kalloc>
8010354e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103551:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103554:	83 e8 04             	sub    $0x4,%eax
80103557:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010355a:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103560:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103562:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103565:	83 e8 08             	sub    $0x8,%eax
80103568:	c7 00 8b 34 10 80    	movl   $0x8010348b,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
8010356e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103571:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103574:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
8010357b:	e8 1f fe ff ff       	call   8010339f <v2p>
80103580:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103582:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103585:	89 04 24             	mov    %eax,(%esp)
80103588:	e8 12 fe ff ff       	call   8010339f <v2p>
8010358d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103590:	0f b6 12             	movzbl (%edx),%edx
80103593:	0f b6 d2             	movzbl %dl,%edx
80103596:	89 44 24 04          	mov    %eax,0x4(%esp)
8010359a:	89 14 24             	mov    %edx,(%esp)
8010359d:	e8 49 f9 ff ff       	call   80102eeb <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035a2:	90                   	nop
801035a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035a6:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801035ac:	85 c0                	test   %eax,%eax
801035ae:	74 f3                	je     801035a3 <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801035b0:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801035b7:	a1 20 0f 11 80       	mov    0x80110f20,%eax
801035bc:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801035c2:	05 40 09 11 80       	add    $0x80110940,%eax
801035c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035ca:	0f 87 62 ff ff ff    	ja     80103532 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801035d0:	83 c4 24             	add    $0x24,%esp
801035d3:	5b                   	pop    %ebx
801035d4:	5d                   	pop    %ebp
801035d5:	c3                   	ret    

801035d6 <p2v>:
801035d6:	55                   	push   %ebp
801035d7:	89 e5                	mov    %esp,%ebp
801035d9:	8b 45 08             	mov    0x8(%ebp),%eax
801035dc:	05 00 00 00 80       	add    $0x80000000,%eax
801035e1:	5d                   	pop    %ebp
801035e2:	c3                   	ret    

801035e3 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801035e3:	55                   	push   %ebp
801035e4:	89 e5                	mov    %esp,%ebp
801035e6:	83 ec 14             	sub    $0x14,%esp
801035e9:	8b 45 08             	mov    0x8(%ebp),%eax
801035ec:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035f0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801035f4:	89 c2                	mov    %eax,%edx
801035f6:	ec                   	in     (%dx),%al
801035f7:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801035fa:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801035fe:	c9                   	leave  
801035ff:	c3                   	ret    

80103600 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	83 ec 08             	sub    $0x8,%esp
80103606:	8b 55 08             	mov    0x8(%ebp),%edx
80103609:	8b 45 0c             	mov    0xc(%ebp),%eax
8010360c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103610:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103613:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103617:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010361b:	ee                   	out    %al,(%dx)
}
8010361c:	c9                   	leave  
8010361d:	c3                   	ret    

8010361e <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
8010361e:	55                   	push   %ebp
8010361f:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103621:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103626:	89 c2                	mov    %eax,%edx
80103628:	b8 40 09 11 80       	mov    $0x80110940,%eax
8010362d:	29 c2                	sub    %eax,%edx
8010362f:	89 d0                	mov    %edx,%eax
80103631:	c1 f8 02             	sar    $0x2,%eax
80103634:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
8010363a:	5d                   	pop    %ebp
8010363b:	c3                   	ret    

8010363c <sum>:

static uchar
sum(uchar *addr, int len)
{
8010363c:	55                   	push   %ebp
8010363d:	89 e5                	mov    %esp,%ebp
8010363f:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103642:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103649:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103650:	eb 15                	jmp    80103667 <sum+0x2b>
    sum += addr[i];
80103652:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103655:	8b 45 08             	mov    0x8(%ebp),%eax
80103658:	01 d0                	add    %edx,%eax
8010365a:	0f b6 00             	movzbl (%eax),%eax
8010365d:	0f b6 c0             	movzbl %al,%eax
80103660:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103663:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103667:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010366a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010366d:	7c e3                	jl     80103652 <sum+0x16>
    sum += addr[i];
  return sum;
8010366f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103672:	c9                   	leave  
80103673:	c3                   	ret    

80103674 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103674:	55                   	push   %ebp
80103675:	89 e5                	mov    %esp,%ebp
80103677:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
8010367a:	8b 45 08             	mov    0x8(%ebp),%eax
8010367d:	89 04 24             	mov    %eax,(%esp)
80103680:	e8 51 ff ff ff       	call   801035d6 <p2v>
80103685:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103688:	8b 55 0c             	mov    0xc(%ebp),%edx
8010368b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010368e:	01 d0                	add    %edx,%eax
80103690:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103693:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103696:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103699:	eb 3f                	jmp    801036da <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010369b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801036a2:	00 
801036a3:	c7 44 24 04 c0 8d 10 	movl   $0x80108dc0,0x4(%esp)
801036aa:	80 
801036ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ae:	89 04 24             	mov    %eax,(%esp)
801036b1:	e8 89 1b 00 00       	call   8010523f <memcmp>
801036b6:	85 c0                	test   %eax,%eax
801036b8:	75 1c                	jne    801036d6 <mpsearch1+0x62>
801036ba:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801036c1:	00 
801036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036c5:	89 04 24             	mov    %eax,(%esp)
801036c8:	e8 6f ff ff ff       	call   8010363c <sum>
801036cd:	84 c0                	test   %al,%al
801036cf:	75 05                	jne    801036d6 <mpsearch1+0x62>
      return (struct mp*)p;
801036d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036d4:	eb 11                	jmp    801036e7 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801036d6:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801036da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036dd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801036e0:	72 b9                	jb     8010369b <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801036e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801036e7:	c9                   	leave  
801036e8:	c3                   	ret    

801036e9 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801036e9:	55                   	push   %ebp
801036ea:	89 e5                	mov    %esp,%ebp
801036ec:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801036ef:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036f9:	83 c0 0f             	add    $0xf,%eax
801036fc:	0f b6 00             	movzbl (%eax),%eax
801036ff:	0f b6 c0             	movzbl %al,%eax
80103702:	c1 e0 08             	shl    $0x8,%eax
80103705:	89 c2                	mov    %eax,%edx
80103707:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010370a:	83 c0 0e             	add    $0xe,%eax
8010370d:	0f b6 00             	movzbl (%eax),%eax
80103710:	0f b6 c0             	movzbl %al,%eax
80103713:	09 d0                	or     %edx,%eax
80103715:	c1 e0 04             	shl    $0x4,%eax
80103718:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010371b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010371f:	74 21                	je     80103742 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103721:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103728:	00 
80103729:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010372c:	89 04 24             	mov    %eax,(%esp)
8010372f:	e8 40 ff ff ff       	call   80103674 <mpsearch1>
80103734:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103737:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010373b:	74 50                	je     8010378d <mpsearch+0xa4>
      return mp;
8010373d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103740:	eb 5f                	jmp    801037a1 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103745:	83 c0 14             	add    $0x14,%eax
80103748:	0f b6 00             	movzbl (%eax),%eax
8010374b:	0f b6 c0             	movzbl %al,%eax
8010374e:	c1 e0 08             	shl    $0x8,%eax
80103751:	89 c2                	mov    %eax,%edx
80103753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103756:	83 c0 13             	add    $0x13,%eax
80103759:	0f b6 00             	movzbl (%eax),%eax
8010375c:	0f b6 c0             	movzbl %al,%eax
8010375f:	09 d0                	or     %edx,%eax
80103761:	c1 e0 0a             	shl    $0xa,%eax
80103764:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103767:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010376a:	2d 00 04 00 00       	sub    $0x400,%eax
8010376f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103776:	00 
80103777:	89 04 24             	mov    %eax,(%esp)
8010377a:	e8 f5 fe ff ff       	call   80103674 <mpsearch1>
8010377f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103782:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103786:	74 05                	je     8010378d <mpsearch+0xa4>
      return mp;
80103788:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010378b:	eb 14                	jmp    801037a1 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
8010378d:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103794:	00 
80103795:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
8010379c:	e8 d3 fe ff ff       	call   80103674 <mpsearch1>
}
801037a1:	c9                   	leave  
801037a2:	c3                   	ret    

801037a3 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
801037a3:	55                   	push   %ebp
801037a4:	89 e5                	mov    %esp,%ebp
801037a6:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037a9:	e8 3b ff ff ff       	call   801036e9 <mpsearch>
801037ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037b5:	74 0a                	je     801037c1 <mpconfig+0x1e>
801037b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ba:	8b 40 04             	mov    0x4(%eax),%eax
801037bd:	85 c0                	test   %eax,%eax
801037bf:	75 0a                	jne    801037cb <mpconfig+0x28>
    return 0;
801037c1:	b8 00 00 00 00       	mov    $0x0,%eax
801037c6:	e9 83 00 00 00       	jmp    8010384e <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801037cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ce:	8b 40 04             	mov    0x4(%eax),%eax
801037d1:	89 04 24             	mov    %eax,(%esp)
801037d4:	e8 fd fd ff ff       	call   801035d6 <p2v>
801037d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801037dc:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801037e3:	00 
801037e4:	c7 44 24 04 c5 8d 10 	movl   $0x80108dc5,0x4(%esp)
801037eb:	80 
801037ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037ef:	89 04 24             	mov    %eax,(%esp)
801037f2:	e8 48 1a 00 00       	call   8010523f <memcmp>
801037f7:	85 c0                	test   %eax,%eax
801037f9:	74 07                	je     80103802 <mpconfig+0x5f>
    return 0;
801037fb:	b8 00 00 00 00       	mov    $0x0,%eax
80103800:	eb 4c                	jmp    8010384e <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103802:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103805:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103809:	3c 01                	cmp    $0x1,%al
8010380b:	74 12                	je     8010381f <mpconfig+0x7c>
8010380d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103810:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103814:	3c 04                	cmp    $0x4,%al
80103816:	74 07                	je     8010381f <mpconfig+0x7c>
    return 0;
80103818:	b8 00 00 00 00       	mov    $0x0,%eax
8010381d:	eb 2f                	jmp    8010384e <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
8010381f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103822:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103826:	0f b7 c0             	movzwl %ax,%eax
80103829:	89 44 24 04          	mov    %eax,0x4(%esp)
8010382d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103830:	89 04 24             	mov    %eax,(%esp)
80103833:	e8 04 fe ff ff       	call   8010363c <sum>
80103838:	84 c0                	test   %al,%al
8010383a:	74 07                	je     80103843 <mpconfig+0xa0>
    return 0;
8010383c:	b8 00 00 00 00       	mov    $0x0,%eax
80103841:	eb 0b                	jmp    8010384e <mpconfig+0xab>
  *pmp = mp;
80103843:	8b 45 08             	mov    0x8(%ebp),%eax
80103846:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103849:	89 10                	mov    %edx,(%eax)
  return conf;
8010384b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010384e:	c9                   	leave  
8010384f:	c3                   	ret    

80103850 <mpinit>:

void
mpinit(void)
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103856:	c7 05 64 c6 10 80 40 	movl   $0x80110940,0x8010c664
8010385d:	09 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103860:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103863:	89 04 24             	mov    %eax,(%esp)
80103866:	e8 38 ff ff ff       	call   801037a3 <mpconfig>
8010386b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010386e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103872:	75 05                	jne    80103879 <mpinit+0x29>
    return;
80103874:	e9 9c 01 00 00       	jmp    80103a15 <mpinit+0x1c5>
  ismp = 1;
80103879:	c7 05 24 09 11 80 01 	movl   $0x1,0x80110924
80103880:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103883:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103886:	8b 40 24             	mov    0x24(%eax),%eax
80103889:	a3 9c 08 11 80       	mov    %eax,0x8011089c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010388e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103891:	83 c0 2c             	add    $0x2c,%eax
80103894:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103897:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010389a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010389e:	0f b7 d0             	movzwl %ax,%edx
801038a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a4:	01 d0                	add    %edx,%eax
801038a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801038a9:	e9 f4 00 00 00       	jmp    801039a2 <mpinit+0x152>
    switch(*p){
801038ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038b1:	0f b6 00             	movzbl (%eax),%eax
801038b4:	0f b6 c0             	movzbl %al,%eax
801038b7:	83 f8 04             	cmp    $0x4,%eax
801038ba:	0f 87 bf 00 00 00    	ja     8010397f <mpinit+0x12f>
801038c0:	8b 04 85 08 8e 10 80 	mov    -0x7fef71f8(,%eax,4),%eax
801038c7:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801038c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801038cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038d2:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038d6:	0f b6 d0             	movzbl %al,%edx
801038d9:	a1 20 0f 11 80       	mov    0x80110f20,%eax
801038de:	39 c2                	cmp    %eax,%edx
801038e0:	74 2d                	je     8010390f <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801038e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038e5:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038e9:	0f b6 d0             	movzbl %al,%edx
801038ec:	a1 20 0f 11 80       	mov    0x80110f20,%eax
801038f1:	89 54 24 08          	mov    %edx,0x8(%esp)
801038f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801038f9:	c7 04 24 ca 8d 10 80 	movl   $0x80108dca,(%esp)
80103900:	e8 9b ca ff ff       	call   801003a0 <cprintf>
        ismp = 0;
80103905:	c7 05 24 09 11 80 00 	movl   $0x0,0x80110924
8010390c:	00 00 00 
      }
      if(proc->flags & MPBOOT)
8010390f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103912:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103916:	0f b6 c0             	movzbl %al,%eax
80103919:	83 e0 02             	and    $0x2,%eax
8010391c:	85 c0                	test   %eax,%eax
8010391e:	74 15                	je     80103935 <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103920:	a1 20 0f 11 80       	mov    0x80110f20,%eax
80103925:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010392b:	05 40 09 11 80       	add    $0x80110940,%eax
80103930:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103935:	8b 15 20 0f 11 80    	mov    0x80110f20,%edx
8010393b:	a1 20 0f 11 80       	mov    0x80110f20,%eax
80103940:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103946:	81 c2 40 09 11 80    	add    $0x80110940,%edx
8010394c:	88 02                	mov    %al,(%edx)
      ncpu++;
8010394e:	a1 20 0f 11 80       	mov    0x80110f20,%eax
80103953:	83 c0 01             	add    $0x1,%eax
80103956:	a3 20 0f 11 80       	mov    %eax,0x80110f20
      p += sizeof(struct mpproc);
8010395b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
8010395f:	eb 41                	jmp    801039a2 <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103961:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103964:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010396a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010396e:	a2 20 09 11 80       	mov    %al,0x80110920
      p += sizeof(struct mpioapic);
80103973:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103977:	eb 29                	jmp    801039a2 <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103979:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010397d:	eb 23                	jmp    801039a2 <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
8010397f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103982:	0f b6 00             	movzbl (%eax),%eax
80103985:	0f b6 c0             	movzbl %al,%eax
80103988:	89 44 24 04          	mov    %eax,0x4(%esp)
8010398c:	c7 04 24 e8 8d 10 80 	movl   $0x80108de8,(%esp)
80103993:	e8 08 ca ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103998:	c7 05 24 09 11 80 00 	movl   $0x0,0x80110924
8010399f:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039a5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039a8:	0f 82 00 ff ff ff    	jb     801038ae <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801039ae:	a1 24 09 11 80       	mov    0x80110924,%eax
801039b3:	85 c0                	test   %eax,%eax
801039b5:	75 1d                	jne    801039d4 <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039b7:	c7 05 20 0f 11 80 01 	movl   $0x1,0x80110f20
801039be:	00 00 00 
    lapic = 0;
801039c1:	c7 05 9c 08 11 80 00 	movl   $0x0,0x8011089c
801039c8:	00 00 00 
    ioapicid = 0;
801039cb:	c6 05 20 09 11 80 00 	movb   $0x0,0x80110920
    return;
801039d2:	eb 41                	jmp    80103a15 <mpinit+0x1c5>
  }

  if(mp->imcrp){
801039d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801039d7:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801039db:	84 c0                	test   %al,%al
801039dd:	74 36                	je     80103a15 <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801039df:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
801039e6:	00 
801039e7:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
801039ee:	e8 0d fc ff ff       	call   80103600 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039f3:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
801039fa:	e8 e4 fb ff ff       	call   801035e3 <inb>
801039ff:	83 c8 01             	or     $0x1,%eax
80103a02:	0f b6 c0             	movzbl %al,%eax
80103a05:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a09:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a10:	e8 eb fb ff ff       	call   80103600 <outb>
  }
}
80103a15:	c9                   	leave  
80103a16:	c3                   	ret    

80103a17 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a17:	55                   	push   %ebp
80103a18:	89 e5                	mov    %esp,%ebp
80103a1a:	83 ec 08             	sub    $0x8,%esp
80103a1d:	8b 55 08             	mov    0x8(%ebp),%edx
80103a20:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a23:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a27:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a2a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a2e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a32:	ee                   	out    %al,(%dx)
}
80103a33:	c9                   	leave  
80103a34:	c3                   	ret    

80103a35 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a35:	55                   	push   %ebp
80103a36:	89 e5                	mov    %esp,%ebp
80103a38:	83 ec 0c             	sub    $0xc,%esp
80103a3b:	8b 45 08             	mov    0x8(%ebp),%eax
80103a3e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a42:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a46:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103a4c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a50:	0f b6 c0             	movzbl %al,%eax
80103a53:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a57:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a5e:	e8 b4 ff ff ff       	call   80103a17 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103a63:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a67:	66 c1 e8 08          	shr    $0x8,%ax
80103a6b:	0f b6 c0             	movzbl %al,%eax
80103a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a72:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103a79:	e8 99 ff ff ff       	call   80103a17 <outb>
}
80103a7e:	c9                   	leave  
80103a7f:	c3                   	ret    

80103a80 <picenable>:

void
picenable(int irq)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103a86:	8b 45 08             	mov    0x8(%ebp),%eax
80103a89:	ba 01 00 00 00       	mov    $0x1,%edx
80103a8e:	89 c1                	mov    %eax,%ecx
80103a90:	d3 e2                	shl    %cl,%edx
80103a92:	89 d0                	mov    %edx,%eax
80103a94:	f7 d0                	not    %eax
80103a96:	89 c2                	mov    %eax,%edx
80103a98:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103a9f:	21 d0                	and    %edx,%eax
80103aa1:	0f b7 c0             	movzwl %ax,%eax
80103aa4:	89 04 24             	mov    %eax,(%esp)
80103aa7:	e8 89 ff ff ff       	call   80103a35 <picsetmask>
}
80103aac:	c9                   	leave  
80103aad:	c3                   	ret    

80103aae <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103aae:	55                   	push   %ebp
80103aaf:	89 e5                	mov    %esp,%ebp
80103ab1:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ab4:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103abb:	00 
80103abc:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ac3:	e8 4f ff ff ff       	call   80103a17 <outb>
  outb(IO_PIC2+1, 0xFF);
80103ac8:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103acf:	00 
80103ad0:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ad7:	e8 3b ff ff ff       	call   80103a17 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103adc:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103ae3:	00 
80103ae4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103aeb:	e8 27 ff ff ff       	call   80103a17 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103af0:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103af7:	00 
80103af8:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103aff:	e8 13 ff ff ff       	call   80103a17 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103b04:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103b0b:	00 
80103b0c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b13:	e8 ff fe ff ff       	call   80103a17 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103b18:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b1f:	00 
80103b20:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b27:	e8 eb fe ff ff       	call   80103a17 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b2c:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b33:	00 
80103b34:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b3b:	e8 d7 fe ff ff       	call   80103a17 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b40:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103b47:	00 
80103b48:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b4f:	e8 c3 fe ff ff       	call   80103a17 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b54:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103b5b:	00 
80103b5c:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b63:	e8 af fe ff ff       	call   80103a17 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103b68:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b6f:	00 
80103b70:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b77:	e8 9b fe ff ff       	call   80103a17 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103b7c:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103b83:	00 
80103b84:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b8b:	e8 87 fe ff ff       	call   80103a17 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103b90:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103b97:	00 
80103b98:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b9f:	e8 73 fe ff ff       	call   80103a17 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103ba4:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bab:	00 
80103bac:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bb3:	e8 5f fe ff ff       	call   80103a17 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103bb8:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103bbf:	00 
80103bc0:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bc7:	e8 4b fe ff ff       	call   80103a17 <outb>

  if(irqmask != 0xFFFF)
80103bcc:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103bd3:	66 83 f8 ff          	cmp    $0xffff,%ax
80103bd7:	74 12                	je     80103beb <picinit+0x13d>
    picsetmask(irqmask);
80103bd9:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103be0:	0f b7 c0             	movzwl %ax,%eax
80103be3:	89 04 24             	mov    %eax,(%esp)
80103be6:	e8 4a fe ff ff       	call   80103a35 <picsetmask>
}
80103beb:	c9                   	leave  
80103bec:	c3                   	ret    

80103bed <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103bed:	55                   	push   %ebp
80103bee:	89 e5                	mov    %esp,%ebp
80103bf0:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103bf3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
80103bfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c03:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c06:	8b 10                	mov    (%eax),%edx
80103c08:	8b 45 08             	mov    0x8(%ebp),%eax
80103c0b:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c0d:	e8 22 d3 ff ff       	call   80100f34 <filealloc>
80103c12:	8b 55 08             	mov    0x8(%ebp),%edx
80103c15:	89 02                	mov    %eax,(%edx)
80103c17:	8b 45 08             	mov    0x8(%ebp),%eax
80103c1a:	8b 00                	mov    (%eax),%eax
80103c1c:	85 c0                	test   %eax,%eax
80103c1e:	0f 84 c8 00 00 00    	je     80103cec <pipealloc+0xff>
80103c24:	e8 0b d3 ff ff       	call   80100f34 <filealloc>
80103c29:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c2c:	89 02                	mov    %eax,(%edx)
80103c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c31:	8b 00                	mov    (%eax),%eax
80103c33:	85 c0                	test   %eax,%eax
80103c35:	0f 84 b1 00 00 00    	je     80103cec <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c3b:	e8 b0 ee ff ff       	call   80102af0 <kalloc>
80103c40:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c47:	75 05                	jne    80103c4e <pipealloc+0x61>
    goto bad;
80103c49:	e9 9e 00 00 00       	jmp    80103cec <pipealloc+0xff>
  p->readopen = 1;
80103c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c51:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c58:	00 00 00 
  p->writeopen = 1;
80103c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c65:	00 00 00 
  p->nwrite = 0;
80103c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c6b:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c72:	00 00 00 
  p->nread = 0;
80103c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c78:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103c7f:	00 00 00 
  initlock(&p->lock, "pipe");
80103c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c85:	c7 44 24 04 1c 8e 10 	movl   $0x80108e1c,0x4(%esp)
80103c8c:	80 
80103c8d:	89 04 24             	mov    %eax,(%esp)
80103c90:	e8 be 12 00 00       	call   80104f53 <initlock>
  (*f0)->type = FD_PIPE;
80103c95:	8b 45 08             	mov    0x8(%ebp),%eax
80103c98:	8b 00                	mov    (%eax),%eax
80103c9a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ca3:	8b 00                	mov    (%eax),%eax
80103ca5:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80103cac:	8b 00                	mov    (%eax),%eax
80103cae:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cb2:	8b 45 08             	mov    0x8(%ebp),%eax
80103cb5:	8b 00                	mov    (%eax),%eax
80103cb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cba:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cc0:	8b 00                	mov    (%eax),%eax
80103cc2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ccb:	8b 00                	mov    (%eax),%eax
80103ccd:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cd4:	8b 00                	mov    (%eax),%eax
80103cd6:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103cda:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cdd:	8b 00                	mov    (%eax),%eax
80103cdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ce2:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103ce5:	b8 00 00 00 00       	mov    $0x0,%eax
80103cea:	eb 42                	jmp    80103d2e <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103cec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cf0:	74 0b                	je     80103cfd <pipealloc+0x110>
    kfree((char*)p);
80103cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf5:	89 04 24             	mov    %eax,(%esp)
80103cf8:	e8 5a ed ff ff       	call   80102a57 <kfree>
  if(*f0)
80103cfd:	8b 45 08             	mov    0x8(%ebp),%eax
80103d00:	8b 00                	mov    (%eax),%eax
80103d02:	85 c0                	test   %eax,%eax
80103d04:	74 0d                	je     80103d13 <pipealloc+0x126>
    fileclose(*f0);
80103d06:	8b 45 08             	mov    0x8(%ebp),%eax
80103d09:	8b 00                	mov    (%eax),%eax
80103d0b:	89 04 24             	mov    %eax,(%esp)
80103d0e:	e8 c9 d2 ff ff       	call   80100fdc <fileclose>
  if(*f1)
80103d13:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d16:	8b 00                	mov    (%eax),%eax
80103d18:	85 c0                	test   %eax,%eax
80103d1a:	74 0d                	je     80103d29 <pipealloc+0x13c>
    fileclose(*f1);
80103d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d1f:	8b 00                	mov    (%eax),%eax
80103d21:	89 04 24             	mov    %eax,(%esp)
80103d24:	e8 b3 d2 ff ff       	call   80100fdc <fileclose>
  return -1;
80103d29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d2e:	c9                   	leave  
80103d2f:	c3                   	ret    

80103d30 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103d36:	8b 45 08             	mov    0x8(%ebp),%eax
80103d39:	89 04 24             	mov    %eax,(%esp)
80103d3c:	e8 33 12 00 00       	call   80104f74 <acquire>
  if(writable){
80103d41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d45:	74 1f                	je     80103d66 <pipeclose+0x36>
    p->writeopen = 0;
80103d47:	8b 45 08             	mov    0x8(%ebp),%eax
80103d4a:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d51:	00 00 00 
    wakeup(&p->nread);
80103d54:	8b 45 08             	mov    0x8(%ebp),%eax
80103d57:	05 34 02 00 00       	add    $0x234,%eax
80103d5c:	89 04 24             	mov    %eax,(%esp)
80103d5f:	e8 f6 0b 00 00       	call   8010495a <wakeup>
80103d64:	eb 1d                	jmp    80103d83 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103d66:	8b 45 08             	mov    0x8(%ebp),%eax
80103d69:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103d70:	00 00 00 
    wakeup(&p->nwrite);
80103d73:	8b 45 08             	mov    0x8(%ebp),%eax
80103d76:	05 38 02 00 00       	add    $0x238,%eax
80103d7b:	89 04 24             	mov    %eax,(%esp)
80103d7e:	e8 d7 0b 00 00       	call   8010495a <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d83:	8b 45 08             	mov    0x8(%ebp),%eax
80103d86:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103d8c:	85 c0                	test   %eax,%eax
80103d8e:	75 25                	jne    80103db5 <pipeclose+0x85>
80103d90:	8b 45 08             	mov    0x8(%ebp),%eax
80103d93:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103d99:	85 c0                	test   %eax,%eax
80103d9b:	75 18                	jne    80103db5 <pipeclose+0x85>
    release(&p->lock);
80103d9d:	8b 45 08             	mov    0x8(%ebp),%eax
80103da0:	89 04 24             	mov    %eax,(%esp)
80103da3:	e8 2e 12 00 00       	call   80104fd6 <release>
    kfree((char*)p);
80103da8:	8b 45 08             	mov    0x8(%ebp),%eax
80103dab:	89 04 24             	mov    %eax,(%esp)
80103dae:	e8 a4 ec ff ff       	call   80102a57 <kfree>
80103db3:	eb 0b                	jmp    80103dc0 <pipeclose+0x90>
  } else
    release(&p->lock);
80103db5:	8b 45 08             	mov    0x8(%ebp),%eax
80103db8:	89 04 24             	mov    %eax,(%esp)
80103dbb:	e8 16 12 00 00       	call   80104fd6 <release>
}
80103dc0:	c9                   	leave  
80103dc1:	c3                   	ret    

80103dc2 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103dc2:	55                   	push   %ebp
80103dc3:	89 e5                	mov    %esp,%ebp
80103dc5:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103dc8:	8b 45 08             	mov    0x8(%ebp),%eax
80103dcb:	89 04 24             	mov    %eax,(%esp)
80103dce:	e8 a1 11 00 00       	call   80104f74 <acquire>
  for(i = 0; i < n; i++){
80103dd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103dda:	e9 a6 00 00 00       	jmp    80103e85 <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ddf:	eb 57                	jmp    80103e38 <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
80103de1:	8b 45 08             	mov    0x8(%ebp),%eax
80103de4:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103dea:	85 c0                	test   %eax,%eax
80103dec:	74 0d                	je     80103dfb <pipewrite+0x39>
80103dee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103df4:	8b 40 24             	mov    0x24(%eax),%eax
80103df7:	85 c0                	test   %eax,%eax
80103df9:	74 15                	je     80103e10 <pipewrite+0x4e>
        release(&p->lock);
80103dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dfe:	89 04 24             	mov    %eax,(%esp)
80103e01:	e8 d0 11 00 00       	call   80104fd6 <release>
        return -1;
80103e06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e0b:	e9 9f 00 00 00       	jmp    80103eaf <pipewrite+0xed>
      }
      wakeup(&p->nread);
80103e10:	8b 45 08             	mov    0x8(%ebp),%eax
80103e13:	05 34 02 00 00       	add    $0x234,%eax
80103e18:	89 04 24             	mov    %eax,(%esp)
80103e1b:	e8 3a 0b 00 00       	call   8010495a <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e20:	8b 45 08             	mov    0x8(%ebp),%eax
80103e23:	8b 55 08             	mov    0x8(%ebp),%edx
80103e26:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e30:	89 14 24             	mov    %edx,(%esp)
80103e33:	e8 49 0a 00 00       	call   80104881 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e38:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3b:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e41:	8b 45 08             	mov    0x8(%ebp),%eax
80103e44:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e4a:	05 00 02 00 00       	add    $0x200,%eax
80103e4f:	39 c2                	cmp    %eax,%edx
80103e51:	74 8e                	je     80103de1 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e53:	8b 45 08             	mov    0x8(%ebp),%eax
80103e56:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103e5c:	8d 48 01             	lea    0x1(%eax),%ecx
80103e5f:	8b 55 08             	mov    0x8(%ebp),%edx
80103e62:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103e68:	25 ff 01 00 00       	and    $0x1ff,%eax
80103e6d:	89 c1                	mov    %eax,%ecx
80103e6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e72:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e75:	01 d0                	add    %edx,%eax
80103e77:	0f b6 10             	movzbl (%eax),%edx
80103e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7d:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103e81:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e88:	3b 45 10             	cmp    0x10(%ebp),%eax
80103e8b:	0f 8c 4e ff ff ff    	jl     80103ddf <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e91:	8b 45 08             	mov    0x8(%ebp),%eax
80103e94:	05 34 02 00 00       	add    $0x234,%eax
80103e99:	89 04 24             	mov    %eax,(%esp)
80103e9c:	e8 b9 0a 00 00       	call   8010495a <wakeup>
  release(&p->lock);
80103ea1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea4:	89 04 24             	mov    %eax,(%esp)
80103ea7:	e8 2a 11 00 00       	call   80104fd6 <release>
  return n;
80103eac:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103eaf:	c9                   	leave  
80103eb0:	c3                   	ret    

80103eb1 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103eb1:	55                   	push   %ebp
80103eb2:	89 e5                	mov    %esp,%ebp
80103eb4:	53                   	push   %ebx
80103eb5:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ebb:	89 04 24             	mov    %eax,(%esp)
80103ebe:	e8 b1 10 00 00       	call   80104f74 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ec3:	eb 3a                	jmp    80103eff <piperead+0x4e>
    if(proc->killed){
80103ec5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ecb:	8b 40 24             	mov    0x24(%eax),%eax
80103ece:	85 c0                	test   %eax,%eax
80103ed0:	74 15                	je     80103ee7 <piperead+0x36>
      release(&p->lock);
80103ed2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed5:	89 04 24             	mov    %eax,(%esp)
80103ed8:	e8 f9 10 00 00       	call   80104fd6 <release>
      return -1;
80103edd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ee2:	e9 b5 00 00 00       	jmp    80103f9c <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ee7:	8b 45 08             	mov    0x8(%ebp),%eax
80103eea:	8b 55 08             	mov    0x8(%ebp),%edx
80103eed:	81 c2 34 02 00 00    	add    $0x234,%edx
80103ef3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ef7:	89 14 24             	mov    %edx,(%esp)
80103efa:	e8 82 09 00 00       	call   80104881 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103eff:	8b 45 08             	mov    0x8(%ebp),%eax
80103f02:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f08:	8b 45 08             	mov    0x8(%ebp),%eax
80103f0b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f11:	39 c2                	cmp    %eax,%edx
80103f13:	75 0d                	jne    80103f22 <piperead+0x71>
80103f15:	8b 45 08             	mov    0x8(%ebp),%eax
80103f18:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f1e:	85 c0                	test   %eax,%eax
80103f20:	75 a3                	jne    80103ec5 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f29:	eb 4b                	jmp    80103f76 <piperead+0xc5>
    if(p->nread == p->nwrite)
80103f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f2e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f34:	8b 45 08             	mov    0x8(%ebp),%eax
80103f37:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f3d:	39 c2                	cmp    %eax,%edx
80103f3f:	75 02                	jne    80103f43 <piperead+0x92>
      break;
80103f41:	eb 3b                	jmp    80103f7e <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f46:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f49:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80103f4c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4f:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f55:	8d 48 01             	lea    0x1(%eax),%ecx
80103f58:	8b 55 08             	mov    0x8(%ebp),%edx
80103f5b:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80103f61:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f66:	89 c2                	mov    %eax,%edx
80103f68:	8b 45 08             	mov    0x8(%ebp),%eax
80103f6b:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80103f70:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f72:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f79:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f7c:	7c ad                	jl     80103f2b <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f7e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f81:	05 38 02 00 00       	add    $0x238,%eax
80103f86:	89 04 24             	mov    %eax,(%esp)
80103f89:	e8 cc 09 00 00       	call   8010495a <wakeup>
  release(&p->lock);
80103f8e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f91:	89 04 24             	mov    %eax,(%esp)
80103f94:	e8 3d 10 00 00       	call   80104fd6 <release>
  return i;
80103f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103f9c:	83 c4 24             	add    $0x24,%esp
80103f9f:	5b                   	pop    %ebx
80103fa0:	5d                   	pop    %ebp
80103fa1:	c3                   	ret    

80103fa2 <p2v>:
80103fa2:	55                   	push   %ebp
80103fa3:	89 e5                	mov    %esp,%ebp
80103fa5:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa8:	05 00 00 00 80       	add    $0x80000000,%eax
80103fad:	5d                   	pop    %ebp
80103fae:	c3                   	ret    

80103faf <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103faf:	55                   	push   %ebp
80103fb0:	89 e5                	mov    %esp,%ebp
80103fb2:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fb5:	9c                   	pushf  
80103fb6:	58                   	pop    %eax
80103fb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103fba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103fbd:	c9                   	leave  
80103fbe:	c3                   	ret    

80103fbf <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80103fbf:	55                   	push   %ebp
80103fc0:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103fc2:	fb                   	sti    
}
80103fc3:	5d                   	pop    %ebp
80103fc4:	c3                   	ret    

80103fc5 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103fc5:	55                   	push   %ebp
80103fc6:	89 e5                	mov    %esp,%ebp
80103fc8:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103fcb:	c7 44 24 04 24 8e 10 	movl   $0x80108e24,0x4(%esp)
80103fd2:	80 
80103fd3:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80103fda:	e8 74 0f 00 00       	call   80104f53 <initlock>
}
80103fdf:	c9                   	leave  
80103fe0:	c3                   	ret    

80103fe1 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103fe1:	55                   	push   %ebp
80103fe2:	89 e5                	mov    %esp,%ebp
80103fe4:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103fe7:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80103fee:	e8 81 0f 00 00       	call   80104f74 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ff3:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
80103ffa:	eb 50                	jmp    8010404c <allocproc+0x6b>
    if(p->state == UNUSED)
80103ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fff:	8b 40 0c             	mov    0xc(%eax),%eax
80104002:	85 c0                	test   %eax,%eax
80104004:	75 42                	jne    80104048 <allocproc+0x67>
      goto found;
80104006:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104007:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010400a:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104011:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104016:	8d 50 01             	lea    0x1(%eax),%edx
80104019:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010401f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104022:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
80104025:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
8010402c:	e8 a5 0f 00 00       	call   80104fd6 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104031:	e8 ba ea ff ff       	call   80102af0 <kalloc>
80104036:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104039:	89 42 08             	mov    %eax,0x8(%edx)
8010403c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010403f:	8b 40 08             	mov    0x8(%eax),%eax
80104042:	85 c0                	test   %eax,%eax
80104044:	75 33                	jne    80104079 <allocproc+0x98>
80104046:	eb 20                	jmp    80104068 <allocproc+0x87>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104048:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010404c:	81 7d f4 74 2e 11 80 	cmpl   $0x80112e74,-0xc(%ebp)
80104053:	72 a7                	jb     80103ffc <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104055:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
8010405c:	e8 75 0f 00 00       	call   80104fd6 <release>
  return 0;
80104061:	b8 00 00 00 00       	mov    $0x0,%eax
80104066:	eb 76                	jmp    801040de <allocproc+0xfd>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80104068:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104072:	b8 00 00 00 00       	mov    $0x0,%eax
80104077:	eb 65                	jmp    801040de <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
80104079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010407c:	8b 40 08             	mov    0x8(%eax),%eax
8010407f:	05 00 10 00 00       	add    $0x1000,%eax
80104084:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104087:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010408b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010408e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104091:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104094:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104098:	ba 0b 66 10 80       	mov    $0x8010660b,%edx
8010409d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040a0:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801040a2:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801040a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040ac:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801040af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040b2:	8b 40 1c             	mov    0x1c(%eax),%eax
801040b5:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801040bc:	00 
801040bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801040c4:	00 
801040c5:	89 04 24             	mov    %eax,(%esp)
801040c8:	e8 fb 10 00 00       	call   801051c8 <memset>
  p->context->eip = (uint)forkret;
801040cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d0:	8b 40 1c             	mov    0x1c(%eax),%eax
801040d3:	ba 55 48 10 80       	mov    $0x80104855,%edx
801040d8:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801040db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801040de:	c9                   	leave  
801040df:	c3                   	ret    

801040e0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801040e6:	e8 f6 fe ff ff       	call   80103fe1 <allocproc>
801040eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801040ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f1:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm(kalloc)) == 0)
801040f6:	c7 04 24 f0 2a 10 80 	movl   $0x80102af0,(%esp)
801040fd:	e8 6f 3c 00 00       	call   80107d71 <setupkvm>
80104102:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104105:	89 42 04             	mov    %eax,0x4(%edx)
80104108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010410b:	8b 40 04             	mov    0x4(%eax),%eax
8010410e:	85 c0                	test   %eax,%eax
80104110:	75 0c                	jne    8010411e <userinit+0x3e>
    panic("userinit: out of memory?");
80104112:	c7 04 24 2b 8e 10 80 	movl   $0x80108e2b,(%esp)
80104119:	e8 1c c4 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010411e:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104123:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104126:	8b 40 04             	mov    0x4(%eax),%eax
80104129:	89 54 24 08          	mov    %edx,0x8(%esp)
8010412d:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
80104134:	80 
80104135:	89 04 24             	mov    %eax,(%esp)
80104138:	e8 8c 3e 00 00       	call   80107fc9 <inituvm>
  p->sz = PGSIZE;
8010413d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104140:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104146:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104149:	8b 40 18             	mov    0x18(%eax),%eax
8010414c:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104153:	00 
80104154:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010415b:	00 
8010415c:	89 04 24             	mov    %eax,(%esp)
8010415f:	e8 64 10 00 00       	call   801051c8 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104167:	8b 40 18             	mov    0x18(%eax),%eax
8010416a:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104170:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104173:	8b 40 18             	mov    0x18(%eax),%eax
80104176:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010417c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010417f:	8b 40 18             	mov    0x18(%eax),%eax
80104182:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104185:	8b 52 18             	mov    0x18(%edx),%edx
80104188:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010418c:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104193:	8b 40 18             	mov    0x18(%eax),%eax
80104196:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104199:	8b 52 18             	mov    0x18(%edx),%edx
8010419c:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801041a0:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801041a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a7:	8b 40 18             	mov    0x18(%eax),%eax
801041aa:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801041b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b4:	8b 40 18             	mov    0x18(%eax),%eax
801041b7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801041be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c1:	8b 40 18             	mov    0x18(%eax),%eax
801041c4:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801041cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ce:	83 c0 6c             	add    $0x6c,%eax
801041d1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801041d8:	00 
801041d9:	c7 44 24 04 44 8e 10 	movl   $0x80108e44,0x4(%esp)
801041e0:	80 
801041e1:	89 04 24             	mov    %eax,(%esp)
801041e4:	e8 ff 11 00 00       	call   801053e8 <safestrcpy>
  p->cwd = namei("/");
801041e9:	c7 04 24 4d 8e 10 80 	movl   $0x80108e4d,(%esp)
801041f0:	e8 1f e2 ff ff       	call   80102414 <namei>
801041f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041f8:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
801041fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041fe:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104205:	c9                   	leave  
80104206:	c3                   	ret    

80104207 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104207:	55                   	push   %ebp
80104208:	89 e5                	mov    %esp,%ebp
8010420a:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
8010420d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104213:	8b 00                	mov    (%eax),%eax
80104215:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104218:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010421c:	7e 34                	jle    80104252 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010421e:	8b 55 08             	mov    0x8(%ebp),%edx
80104221:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104224:	01 c2                	add    %eax,%edx
80104226:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010422c:	8b 40 04             	mov    0x4(%eax),%eax
8010422f:	89 54 24 08          	mov    %edx,0x8(%esp)
80104233:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104236:	89 54 24 04          	mov    %edx,0x4(%esp)
8010423a:	89 04 24             	mov    %eax,(%esp)
8010423d:	e8 17 3f 00 00       	call   80108159 <allocuvm>
80104242:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104245:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104249:	75 41                	jne    8010428c <growproc+0x85>
      return -1;
8010424b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104250:	eb 58                	jmp    801042aa <growproc+0xa3>
  } else if(n < 0){
80104252:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104256:	79 34                	jns    8010428c <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104258:	8b 55 08             	mov    0x8(%ebp),%edx
8010425b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010425e:	01 c2                	add    %eax,%edx
80104260:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104266:	8b 40 04             	mov    0x4(%eax),%eax
80104269:	89 54 24 08          	mov    %edx,0x8(%esp)
8010426d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104270:	89 54 24 04          	mov    %edx,0x4(%esp)
80104274:	89 04 24             	mov    %eax,(%esp)
80104277:	e8 b7 3f 00 00       	call   80108233 <deallocuvm>
8010427c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010427f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104283:	75 07                	jne    8010428c <growproc+0x85>
      return -1;
80104285:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010428a:	eb 1e                	jmp    801042aa <growproc+0xa3>
  }
  proc->sz = sz;
8010428c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104292:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104295:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104297:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010429d:	89 04 24             	mov    %eax,(%esp)
801042a0:	e8 bd 3b 00 00       	call   80107e62 <switchuvm>
  return 0;
801042a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801042aa:	c9                   	leave  
801042ab:	c3                   	ret    

801042ac <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801042ac:	55                   	push   %ebp
801042ad:	89 e5                	mov    %esp,%ebp
801042af:	57                   	push   %edi
801042b0:	56                   	push   %esi
801042b1:	53                   	push   %ebx
801042b2:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801042b5:	e8 27 fd ff ff       	call   80103fe1 <allocproc>
801042ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801042bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801042c1:	75 0a                	jne    801042cd <fork+0x21>
    return -1;
801042c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042c8:	e9 3a 01 00 00       	jmp    80104407 <fork+0x15b>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801042cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042d3:	8b 10                	mov    (%eax),%edx
801042d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042db:	8b 40 04             	mov    0x4(%eax),%eax
801042de:	89 54 24 04          	mov    %edx,0x4(%esp)
801042e2:	89 04 24             	mov    %eax,(%esp)
801042e5:	e8 d0 42 00 00       	call   801085ba <copyuvm>
801042ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
801042ed:	89 42 04             	mov    %eax,0x4(%edx)
801042f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042f3:	8b 40 04             	mov    0x4(%eax),%eax
801042f6:	85 c0                	test   %eax,%eax
801042f8:	75 2c                	jne    80104326 <fork+0x7a>
    kfree(np->kstack);
801042fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042fd:	8b 40 08             	mov    0x8(%eax),%eax
80104300:	89 04 24             	mov    %eax,(%esp)
80104303:	e8 4f e7 ff ff       	call   80102a57 <kfree>
    np->kstack = 0;
80104308:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010430b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104312:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104315:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010431c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104321:	e9 e1 00 00 00       	jmp    80104407 <fork+0x15b>
  }
  np->sz = proc->sz;
80104326:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010432c:	8b 10                	mov    (%eax),%edx
8010432e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104331:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104333:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010433a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010433d:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104340:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104343:	8b 50 18             	mov    0x18(%eax),%edx
80104346:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010434c:	8b 40 18             	mov    0x18(%eax),%eax
8010434f:	89 c3                	mov    %eax,%ebx
80104351:	b8 13 00 00 00       	mov    $0x13,%eax
80104356:	89 d7                	mov    %edx,%edi
80104358:	89 de                	mov    %ebx,%esi
8010435a:	89 c1                	mov    %eax,%ecx
8010435c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010435e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104361:	8b 40 18             	mov    0x18(%eax),%eax
80104364:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010436b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104372:	eb 3d                	jmp    801043b1 <fork+0x105>
    if(proc->ofile[i])
80104374:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010437a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010437d:	83 c2 08             	add    $0x8,%edx
80104380:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104384:	85 c0                	test   %eax,%eax
80104386:	74 25                	je     801043ad <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
80104388:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010438e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104391:	83 c2 08             	add    $0x8,%edx
80104394:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104398:	89 04 24             	mov    %eax,(%esp)
8010439b:	e8 f4 cb ff ff       	call   80100f94 <filedup>
801043a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801043a3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801043a6:	83 c1 08             	add    $0x8,%ecx
801043a9:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801043ad:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801043b1:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801043b5:	7e bd                	jle    80104374 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801043b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043bd:	8b 40 68             	mov    0x68(%eax),%eax
801043c0:	89 04 24             	mov    %eax,(%esp)
801043c3:	e8 6f d4 ff ff       	call   80101837 <idup>
801043c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801043cb:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
801043ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043d1:	8b 40 10             	mov    0x10(%eax),%eax
801043d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
801043d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043da:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
801043e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043e7:	8d 50 6c             	lea    0x6c(%eax),%edx
801043ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043ed:	83 c0 6c             	add    $0x6c,%eax
801043f0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801043f7:	00 
801043f8:	89 54 24 04          	mov    %edx,0x4(%esp)
801043fc:	89 04 24             	mov    %eax,(%esp)
801043ff:	e8 e4 0f 00 00       	call   801053e8 <safestrcpy>
  return pid;
80104404:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104407:	83 c4 2c             	add    $0x2c,%esp
8010440a:	5b                   	pop    %ebx
8010440b:	5e                   	pop    %esi
8010440c:	5f                   	pop    %edi
8010440d:	5d                   	pop    %ebp
8010440e:	c3                   	ret    

8010440f <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010440f:	55                   	push   %ebp
80104410:	89 e5                	mov    %esp,%ebp
80104412:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104415:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010441c:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104421:	39 c2                	cmp    %eax,%edx
80104423:	75 0c                	jne    80104431 <exit+0x22>
    panic("init exiting");
80104425:	c7 04 24 4f 8e 10 80 	movl   $0x80108e4f,(%esp)
8010442c:	e8 09 c1 ff ff       	call   8010053a <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104431:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104438:	eb 44                	jmp    8010447e <exit+0x6f>
    if(proc->ofile[fd]){
8010443a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104440:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104443:	83 c2 08             	add    $0x8,%edx
80104446:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010444a:	85 c0                	test   %eax,%eax
8010444c:	74 2c                	je     8010447a <exit+0x6b>
      fileclose(proc->ofile[fd]);
8010444e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104454:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104457:	83 c2 08             	add    $0x8,%edx
8010445a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010445e:	89 04 24             	mov    %eax,(%esp)
80104461:	e8 76 cb ff ff       	call   80100fdc <fileclose>
      proc->ofile[fd] = 0;
80104466:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010446c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010446f:	83 c2 08             	add    $0x8,%edx
80104472:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104479:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010447a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010447e:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104482:	7e b6                	jle    8010443a <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
80104484:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010448a:	8b 40 68             	mov    0x68(%eax),%eax
8010448d:	89 04 24             	mov    %eax,(%esp)
80104490:	e8 87 d5 ff ff       	call   80101a1c <iput>
  proc->cwd = 0;
80104495:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010449b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801044a2:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801044a9:	e8 c6 0a 00 00       	call   80104f74 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801044ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044b4:	8b 40 14             	mov    0x14(%eax),%eax
801044b7:	89 04 24             	mov    %eax,(%esp)
801044ba:	e8 5d 04 00 00       	call   8010491c <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044bf:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
801044c6:	eb 38                	jmp    80104500 <exit+0xf1>
    if(p->parent == proc){
801044c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044cb:	8b 50 14             	mov    0x14(%eax),%edx
801044ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044d4:	39 c2                	cmp    %eax,%edx
801044d6:	75 24                	jne    801044fc <exit+0xed>
      p->parent = initproc;
801044d8:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
801044de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e1:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801044e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e7:	8b 40 0c             	mov    0xc(%eax),%eax
801044ea:	83 f8 05             	cmp    $0x5,%eax
801044ed:	75 0d                	jne    801044fc <exit+0xed>
        wakeup1(initproc);
801044ef:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801044f4:	89 04 24             	mov    %eax,(%esp)
801044f7:	e8 20 04 00 00       	call   8010491c <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044fc:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104500:	81 7d f4 74 2e 11 80 	cmpl   $0x80112e74,-0xc(%ebp)
80104507:	72 bf                	jb     801044c8 <exit+0xb9>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104509:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010450f:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104516:	e8 56 02 00 00       	call   80104771 <sched>
  panic("zombie exit");
8010451b:	c7 04 24 5c 8e 10 80 	movl   $0x80108e5c,(%esp)
80104522:	e8 13 c0 ff ff       	call   8010053a <panic>

80104527 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104527:	55                   	push   %ebp
80104528:	89 e5                	mov    %esp,%ebp
8010452a:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
8010452d:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104534:	e8 3b 0a 00 00       	call   80104f74 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104540:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
80104547:	e9 9a 00 00 00       	jmp    801045e6 <wait+0xbf>
      if(p->parent != proc)
8010454c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454f:	8b 50 14             	mov    0x14(%eax),%edx
80104552:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104558:	39 c2                	cmp    %eax,%edx
8010455a:	74 05                	je     80104561 <wait+0x3a>
        continue;
8010455c:	e9 81 00 00 00       	jmp    801045e2 <wait+0xbb>
      havekids = 1;
80104561:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104568:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010456b:	8b 40 0c             	mov    0xc(%eax),%eax
8010456e:	83 f8 05             	cmp    $0x5,%eax
80104571:	75 6f                	jne    801045e2 <wait+0xbb>
        // Found one.
        pid = p->pid;
80104573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104576:	8b 40 10             	mov    0x10(%eax),%eax
80104579:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
8010457c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010457f:	8b 40 08             	mov    0x8(%eax),%eax
80104582:	89 04 24             	mov    %eax,(%esp)
80104585:	e8 cd e4 ff ff       	call   80102a57 <kfree>
        p->kstack = 0;
8010458a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104594:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104597:	8b 40 04             	mov    0x4(%eax),%eax
8010459a:	89 04 24             	mov    %eax,(%esp)
8010459d:	e8 38 3f 00 00       	call   801084da <freevm>
        p->state = UNUSED;
801045a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
801045ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045af:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801045b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801045c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c3:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801045c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ca:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
801045d1:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801045d8:	e8 f9 09 00 00       	call   80104fd6 <release>
        return pid;
801045dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045e0:	eb 52                	jmp    80104634 <wait+0x10d>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045e2:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801045e6:	81 7d f4 74 2e 11 80 	cmpl   $0x80112e74,-0xc(%ebp)
801045ed:	0f 82 59 ff ff ff    	jb     8010454c <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801045f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801045f7:	74 0d                	je     80104606 <wait+0xdf>
801045f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045ff:	8b 40 24             	mov    0x24(%eax),%eax
80104602:	85 c0                	test   %eax,%eax
80104604:	74 13                	je     80104619 <wait+0xf2>
      release(&ptable.lock);
80104606:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
8010460d:	e8 c4 09 00 00       	call   80104fd6 <release>
      return -1;
80104612:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104617:	eb 1b                	jmp    80104634 <wait+0x10d>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104619:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010461f:	c7 44 24 04 40 0f 11 	movl   $0x80110f40,0x4(%esp)
80104626:	80 
80104627:	89 04 24             	mov    %eax,(%esp)
8010462a:	e8 52 02 00 00       	call   80104881 <sleep>
  }
8010462f:	e9 05 ff ff ff       	jmp    80104539 <wait+0x12>
}
80104634:	c9                   	leave  
80104635:	c3                   	ret    

80104636 <register_handler>:

void
register_handler(sighandler_t sighandler)
{
80104636:	55                   	push   %ebp
80104637:	89 e5                	mov    %esp,%ebp
80104639:	83 ec 28             	sub    $0x28,%esp
  char* addr = uva2ka(proc->pgdir, (char*)proc->tf->esp);
8010463c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104642:	8b 40 18             	mov    0x18(%eax),%eax
80104645:	8b 40 44             	mov    0x44(%eax),%eax
80104648:	89 c2                	mov    %eax,%edx
8010464a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104650:	8b 40 04             	mov    0x4(%eax),%eax
80104653:	89 54 24 04          	mov    %edx,0x4(%esp)
80104657:	89 04 24             	mov    %eax,(%esp)
8010465a:	e8 b2 40 00 00       	call   80108711 <uva2ka>
8010465f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if ((proc->tf->esp & 0xFFF) == 0)
80104662:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104668:	8b 40 18             	mov    0x18(%eax),%eax
8010466b:	8b 40 44             	mov    0x44(%eax),%eax
8010466e:	25 ff 0f 00 00       	and    $0xfff,%eax
80104673:	85 c0                	test   %eax,%eax
80104675:	75 0c                	jne    80104683 <register_handler+0x4d>
    panic("esp_offset == 0");
80104677:	c7 04 24 68 8e 10 80 	movl   $0x80108e68,(%esp)
8010467e:	e8 b7 be ff ff       	call   8010053a <panic>

    /* open a new frame */
  *(int*)(addr + ((proc->tf->esp - 4) & 0xFFF))
80104683:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104689:	8b 40 18             	mov    0x18(%eax),%eax
8010468c:	8b 40 44             	mov    0x44(%eax),%eax
8010468f:	83 e8 04             	sub    $0x4,%eax
80104692:	25 ff 0f 00 00       	and    $0xfff,%eax
80104697:	89 c2                	mov    %eax,%edx
80104699:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010469c:	01 c2                	add    %eax,%edx
          = proc->tf->eip;
8010469e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046a4:	8b 40 18             	mov    0x18(%eax),%eax
801046a7:	8b 40 38             	mov    0x38(%eax),%eax
801046aa:	89 02                	mov    %eax,(%edx)
  proc->tf->esp -= 4;
801046ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b2:	8b 40 18             	mov    0x18(%eax),%eax
801046b5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801046bc:	8b 52 18             	mov    0x18(%edx),%edx
801046bf:	8b 52 44             	mov    0x44(%edx),%edx
801046c2:	83 ea 04             	sub    $0x4,%edx
801046c5:	89 50 44             	mov    %edx,0x44(%eax)

    /* update eip */
  proc->tf->eip = (uint)sighandler;
801046c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ce:	8b 40 18             	mov    0x18(%eax),%eax
801046d1:	8b 55 08             	mov    0x8(%ebp),%edx
801046d4:	89 50 38             	mov    %edx,0x38(%eax)
}
801046d7:	c9                   	leave  
801046d8:	c3                   	ret    

801046d9 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801046d9:	55                   	push   %ebp
801046da:	89 e5                	mov    %esp,%ebp
801046dc:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
801046df:	e8 db f8 ff ff       	call   80103fbf <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801046e4:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801046eb:	e8 84 08 00 00       	call   80104f74 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046f0:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
801046f7:	eb 5e                	jmp    80104757 <scheduler+0x7e>
      if(p->state != RUNNABLE)
801046f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046fc:	8b 40 0c             	mov    0xc(%eax),%eax
801046ff:	83 f8 03             	cmp    $0x3,%eax
80104702:	74 02                	je     80104706 <scheduler+0x2d>
        continue;
80104704:	eb 4d                	jmp    80104753 <scheduler+0x7a>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104706:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104709:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
8010470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104712:	89 04 24             	mov    %eax,(%esp)
80104715:	e8 48 37 00 00       	call   80107e62 <switchuvm>
      p->state = RUNNING;
8010471a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010471d:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104724:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010472a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010472d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104734:	83 c2 04             	add    $0x4,%edx
80104737:	89 44 24 04          	mov    %eax,0x4(%esp)
8010473b:	89 14 24             	mov    %edx,(%esp)
8010473e:	e8 16 0d 00 00       	call   80105459 <swtch>
      switchkvm();
80104743:	e8 fd 36 00 00       	call   80107e45 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104748:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010474f:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104753:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104757:	81 7d f4 74 2e 11 80 	cmpl   $0x80112e74,-0xc(%ebp)
8010475e:	72 99                	jb     801046f9 <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104760:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104767:	e8 6a 08 00 00       	call   80104fd6 <release>

  }
8010476c:	e9 6e ff ff ff       	jmp    801046df <scheduler+0x6>

80104771 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104771:	55                   	push   %ebp
80104772:	89 e5                	mov    %esp,%ebp
80104774:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104777:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
8010477e:	e8 1b 09 00 00       	call   8010509e <holding>
80104783:	85 c0                	test   %eax,%eax
80104785:	75 0c                	jne    80104793 <sched+0x22>
    panic("sched ptable.lock");
80104787:	c7 04 24 78 8e 10 80 	movl   $0x80108e78,(%esp)
8010478e:	e8 a7 bd ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
80104793:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104799:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010479f:	83 f8 01             	cmp    $0x1,%eax
801047a2:	74 0c                	je     801047b0 <sched+0x3f>
    panic("sched locks");
801047a4:	c7 04 24 8a 8e 10 80 	movl   $0x80108e8a,(%esp)
801047ab:	e8 8a bd ff ff       	call   8010053a <panic>
  if(proc->state == RUNNING)
801047b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b6:	8b 40 0c             	mov    0xc(%eax),%eax
801047b9:	83 f8 04             	cmp    $0x4,%eax
801047bc:	75 0c                	jne    801047ca <sched+0x59>
    panic("sched running");
801047be:	c7 04 24 96 8e 10 80 	movl   $0x80108e96,(%esp)
801047c5:	e8 70 bd ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
801047ca:	e8 e0 f7 ff ff       	call   80103faf <readeflags>
801047cf:	25 00 02 00 00       	and    $0x200,%eax
801047d4:	85 c0                	test   %eax,%eax
801047d6:	74 0c                	je     801047e4 <sched+0x73>
    panic("sched interruptible");
801047d8:	c7 04 24 a4 8e 10 80 	movl   $0x80108ea4,(%esp)
801047df:	e8 56 bd ff ff       	call   8010053a <panic>
  intena = cpu->intena;
801047e4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801047ea:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801047f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
801047f3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801047f9:	8b 40 04             	mov    0x4(%eax),%eax
801047fc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104803:	83 c2 1c             	add    $0x1c,%edx
80104806:	89 44 24 04          	mov    %eax,0x4(%esp)
8010480a:	89 14 24             	mov    %edx,(%esp)
8010480d:	e8 47 0c 00 00       	call   80105459 <swtch>
  cpu->intena = intena;
80104812:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104818:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010481b:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104821:	c9                   	leave  
80104822:	c3                   	ret    

80104823 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104823:	55                   	push   %ebp
80104824:	89 e5                	mov    %esp,%ebp
80104826:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104829:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104830:	e8 3f 07 00 00       	call   80104f74 <acquire>
  proc->state = RUNNABLE;
80104835:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010483b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104842:	e8 2a ff ff ff       	call   80104771 <sched>
  release(&ptable.lock);
80104847:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
8010484e:	e8 83 07 00 00       	call   80104fd6 <release>
}
80104853:	c9                   	leave  
80104854:	c3                   	ret    

80104855 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104855:	55                   	push   %ebp
80104856:	89 e5                	mov    %esp,%ebp
80104858:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010485b:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104862:	e8 6f 07 00 00       	call   80104fd6 <release>

  if (first) {
80104867:	a1 08 c0 10 80       	mov    0x8010c008,%eax
8010486c:	85 c0                	test   %eax,%eax
8010486e:	74 0f                	je     8010487f <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104870:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104877:	00 00 00 
    initlog();
8010487a:	e8 66 e7 ff ff       	call   80102fe5 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
8010487f:	c9                   	leave  
80104880:	c3                   	ret    

80104881 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104881:	55                   	push   %ebp
80104882:	89 e5                	mov    %esp,%ebp
80104884:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104887:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010488d:	85 c0                	test   %eax,%eax
8010488f:	75 0c                	jne    8010489d <sleep+0x1c>
    panic("sleep");
80104891:	c7 04 24 b8 8e 10 80 	movl   $0x80108eb8,(%esp)
80104898:	e8 9d bc ff ff       	call   8010053a <panic>

  if(lk == 0)
8010489d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801048a1:	75 0c                	jne    801048af <sleep+0x2e>
    panic("sleep without lk");
801048a3:	c7 04 24 be 8e 10 80 	movl   $0x80108ebe,(%esp)
801048aa:	e8 8b bc ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801048af:	81 7d 0c 40 0f 11 80 	cmpl   $0x80110f40,0xc(%ebp)
801048b6:	74 17                	je     801048cf <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
801048b8:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801048bf:	e8 b0 06 00 00       	call   80104f74 <acquire>
    release(lk);
801048c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801048c7:	89 04 24             	mov    %eax,(%esp)
801048ca:	e8 07 07 00 00       	call   80104fd6 <release>
  }

  // Go to sleep.
  proc->chan = chan;
801048cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d5:	8b 55 08             	mov    0x8(%ebp),%edx
801048d8:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
801048db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e1:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801048e8:	e8 84 fe ff ff       	call   80104771 <sched>

  // Tidy up.
  proc->chan = 0;
801048ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048f3:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801048fa:	81 7d 0c 40 0f 11 80 	cmpl   $0x80110f40,0xc(%ebp)
80104901:	74 17                	je     8010491a <sleep+0x99>
    release(&ptable.lock);
80104903:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
8010490a:	e8 c7 06 00 00       	call   80104fd6 <release>
    acquire(lk);
8010490f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104912:	89 04 24             	mov    %eax,(%esp)
80104915:	e8 5a 06 00 00       	call   80104f74 <acquire>
  }
}
8010491a:	c9                   	leave  
8010491b:	c3                   	ret    

8010491c <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
8010491c:	55                   	push   %ebp
8010491d:	89 e5                	mov    %esp,%ebp
8010491f:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104922:	c7 45 fc 74 0f 11 80 	movl   $0x80110f74,-0x4(%ebp)
80104929:	eb 24                	jmp    8010494f <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
8010492b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010492e:	8b 40 0c             	mov    0xc(%eax),%eax
80104931:	83 f8 02             	cmp    $0x2,%eax
80104934:	75 15                	jne    8010494b <wakeup1+0x2f>
80104936:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104939:	8b 40 20             	mov    0x20(%eax),%eax
8010493c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010493f:	75 0a                	jne    8010494b <wakeup1+0x2f>
      p->state = RUNNABLE;
80104941:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104944:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010494b:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
8010494f:	81 7d fc 74 2e 11 80 	cmpl   $0x80112e74,-0x4(%ebp)
80104956:	72 d3                	jb     8010492b <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104958:	c9                   	leave  
80104959:	c3                   	ret    

8010495a <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010495a:	55                   	push   %ebp
8010495b:	89 e5                	mov    %esp,%ebp
8010495d:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104960:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104967:	e8 08 06 00 00       	call   80104f74 <acquire>
  wakeup1(chan);
8010496c:	8b 45 08             	mov    0x8(%ebp),%eax
8010496f:	89 04 24             	mov    %eax,(%esp)
80104972:	e8 a5 ff ff ff       	call   8010491c <wakeup1>
  release(&ptable.lock);
80104977:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
8010497e:	e8 53 06 00 00       	call   80104fd6 <release>
}
80104983:	c9                   	leave  
80104984:	c3                   	ret    

80104985 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104985:	55                   	push   %ebp
80104986:	89 e5                	mov    %esp,%ebp
80104988:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010498b:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104992:	e8 dd 05 00 00       	call   80104f74 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104997:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
8010499e:	eb 41                	jmp    801049e1 <kill+0x5c>
    if(p->pid == pid){
801049a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a3:	8b 40 10             	mov    0x10(%eax),%eax
801049a6:	3b 45 08             	cmp    0x8(%ebp),%eax
801049a9:	75 32                	jne    801049dd <kill+0x58>
      p->killed = 1;
801049ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ae:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801049b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b8:	8b 40 0c             	mov    0xc(%eax),%eax
801049bb:	83 f8 02             	cmp    $0x2,%eax
801049be:	75 0a                	jne    801049ca <kill+0x45>
        p->state = RUNNABLE;
801049c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801049ca:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801049d1:	e8 00 06 00 00       	call   80104fd6 <release>
      return 0;
801049d6:	b8 00 00 00 00       	mov    $0x0,%eax
801049db:	eb 1e                	jmp    801049fb <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049dd:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801049e1:	81 7d f4 74 2e 11 80 	cmpl   $0x80112e74,-0xc(%ebp)
801049e8:	72 b6                	jb     801049a0 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801049ea:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801049f1:	e8 e0 05 00 00       	call   80104fd6 <release>
  return -1;
801049f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049fb:	c9                   	leave  
801049fc:	c3                   	ret    

801049fd <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801049fd:	55                   	push   %ebp
801049fe:	89 e5                	mov    %esp,%ebp
80104a00:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  cprintf("\n------------------------------procdump-----------------------------------\n");
80104a06:	c7 04 24 d0 8e 10 80 	movl   $0x80108ed0,(%esp)
80104a0d:	e8 8e b9 ff ff       	call   801003a0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a12:	c7 45 f0 74 0f 11 80 	movl   $0x80110f74,-0x10(%ebp)
80104a19:	e9 8d 03 00 00       	jmp    80104dab <procdump+0x3ae>
      if(p->state == UNUSED)
80104a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a21:	8b 40 0c             	mov    0xc(%eax),%eax
80104a24:	85 c0                	test   %eax,%eax
80104a26:	75 05                	jne    80104a2d <procdump+0x30>
          continue;
80104a28:	e9 7a 03 00 00       	jmp    80104da7 <procdump+0x3aa>
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a30:	8b 40 0c             	mov    0xc(%eax),%eax
80104a33:	83 f8 05             	cmp    $0x5,%eax
80104a36:	77 23                	ja     80104a5b <procdump+0x5e>
80104a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a3b:	8b 40 0c             	mov    0xc(%eax),%eax
80104a3e:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104a45:	85 c0                	test   %eax,%eax
80104a47:	74 12                	je     80104a5b <procdump+0x5e>
          state = states[p->state];
80104a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a4c:	8b 40 0c             	mov    0xc(%eax),%eax
80104a4f:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104a56:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104a59:	eb 07                	jmp    80104a62 <procdump+0x65>
      else
          state = "???";
80104a5b:	c7 45 ec 1c 8f 10 80 	movl   $0x80108f1c,-0x14(%ebp)
      cprintf("%d %s %s", p->pid, state, p->name);
80104a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a65:	8d 50 6c             	lea    0x6c(%eax),%edx
80104a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a6b:	8b 40 10             	mov    0x10(%eax),%eax
80104a6e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104a72:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104a75:	89 54 24 08          	mov    %edx,0x8(%esp)
80104a79:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a7d:	c7 04 24 20 8f 10 80 	movl   $0x80108f20,(%esp)
80104a84:	e8 17 b9 ff ff       	call   801003a0 <cprintf>
      if(p->state == SLEEPING || p->state == RUNNABLE || p->state == RUNNING){
80104a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a8c:	8b 40 0c             	mov    0xc(%eax),%eax
80104a8f:	83 f8 02             	cmp    $0x2,%eax
80104a92:	74 1a                	je     80104aae <procdump+0xb1>
80104a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a97:	8b 40 0c             	mov    0xc(%eax),%eax
80104a9a:	83 f8 03             	cmp    $0x3,%eax
80104a9d:	74 0f                	je     80104aae <procdump+0xb1>
80104a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aa2:	8b 40 0c             	mov    0xc(%eax),%eax
80104aa5:	83 f8 04             	cmp    $0x4,%eax
80104aa8:	0f 85 ed 02 00 00    	jne    80104d9b <procdump+0x39e>
          getcallerpcs((uint*)p->context->ebp+2, pc);
80104aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ab1:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ab4:	8b 40 0c             	mov    0xc(%eax),%eax
80104ab7:	83 c0 08             	add    $0x8,%eax
80104aba:	8d 55 80             	lea    -0x80(%ebp),%edx
80104abd:	89 54 24 04          	mov    %edx,0x4(%esp)
80104ac1:	89 04 24             	mov    %eax,(%esp)
80104ac4:	e8 5c 05 00 00       	call   80105025 <getcallerpcs>
          for(i=0; i<10 && pc[i] != 0; i++)
80104ac9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104ad0:	eb 1b                	jmp    80104aed <procdump+0xf0>
              cprintf(" %p", pc[i]);
80104ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad5:	8b 44 85 80          	mov    -0x80(%ebp,%eax,4),%eax
80104ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
80104add:	c7 04 24 29 8f 10 80 	movl   $0x80108f29,(%esp)
80104ae4:	e8 b7 b8 ff ff       	call   801003a0 <cprintf>
      else
          state = "???";
      cprintf("%d %s %s", p->pid, state, p->name);
      if(p->state == SLEEPING || p->state == RUNNABLE || p->state == RUNNING){
          getcallerpcs((uint*)p->context->ebp+2, pc);
          for(i=0; i<10 && pc[i] != 0; i++)
80104ae9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104aed:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104af1:	7f 0b                	jg     80104afe <procdump+0x101>
80104af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af6:	8b 44 85 80          	mov    -0x80(%ebp,%eax,4),%eax
80104afa:	85 c0                	test   %eax,%eax
80104afc:	75 d4                	jne    80104ad2 <procdump+0xd5>
              cprintf(" %p", pc[i]);
          //3.1
          cprintf("\n*Page tables:\n");
80104afe:	c7 04 24 2d 8f 10 80 	movl   $0x80108f2d,(%esp)
80104b05:	e8 96 b8 ff ff       	call   801003a0 <cprintf>
          cprintf("memory location of page directory = %d\n",p->pgdir);
80104b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b0d:	8b 40 04             	mov    0x4(%eax),%eax
80104b10:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b14:	c7 04 24 40 8f 10 80 	movl   $0x80108f40,(%esp)
80104b1b:	e8 80 b8 ff ff       	call   801003a0 <cprintf>
          int n = 1;
80104b20:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
          for(i=0 ; i < NPDENTRIES ;i++) {
80104b27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104b2e:	e9 20 01 00 00       	jmp    80104c53 <procdump+0x256>
              //1.3
              int j;
              pde_t *pde = &p->pgdir[i];              // page drivetory entry
80104b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b36:	8b 40 04             	mov    0x4(%eax),%eax
80104b39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b3c:	c1 e2 02             	shl    $0x2,%edx
80104b3f:	01 d0                	add    %edx,%eax
80104b41:	89 45 d4             	mov    %eax,-0x2c(%ebp)
              pte_t *pgtab;                           // page table address
              pde_t *pte;                             // page table entry

              if((*pde & PTE_P) && (*pde & PTE_U) && (*pde & PTE_A)) {
80104b44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104b47:	8b 00                	mov    (%eax),%eax
80104b49:	83 e0 01             	and    $0x1,%eax
80104b4c:	85 c0                	test   %eax,%eax
80104b4e:	0f 84 fb 00 00 00    	je     80104c4f <procdump+0x252>
80104b54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104b57:	8b 00                	mov    (%eax),%eax
80104b59:	83 e0 04             	and    $0x4,%eax
80104b5c:	85 c0                	test   %eax,%eax
80104b5e:	0f 84 eb 00 00 00    	je     80104c4f <procdump+0x252>
80104b64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104b67:	8b 00                	mov    (%eax),%eax
80104b69:	83 e0 20             	and    $0x20,%eax
80104b6c:	85 c0                	test   %eax,%eax
80104b6e:	0f 84 db 00 00 00    	je     80104c4f <procdump+0x252>
                  uint pde_ppn    =  PTE_ADDR(*pde);          // 20 MSBs in pgdir entry.
80104b74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104b77:	8b 00                	mov    (%eax),%eax
80104b79:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80104b7e:	89 45 d0             	mov    %eax,-0x30(%ebp)
                  pgtab = (pte_t*)p2v(pde_ppn);               // address of relevant page table
80104b81:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104b84:	89 04 24             	mov    %eax,(%esp)
80104b87:	e8 16 f4 ff ff       	call   80103fa2 <p2v>
80104b8c:	89 45 cc             	mov    %eax,-0x34(%ebp)
                  uint phyppn;
                  uint pte_ppn;

                  cprintf("\n%d) pdir PTE %d, %p \n",n,i,pde_ppn);
80104b8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104b92:	89 44 24 0c          	mov    %eax,0xc(%esp)
80104b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b99:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ba4:	c7 04 24 68 8f 10 80 	movl   $0x80108f68,(%esp)
80104bab:	e8 f0 b7 ff ff       	call   801003a0 <cprintf>
                  n++;
80104bb0:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
                  cprintf("memory location of page table = %p\n",pgtab);
80104bb4:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bbb:	c7 04 24 80 8f 10 80 	movl   $0x80108f80,(%esp)
80104bc2:	e8 d9 b7 ff ff       	call   801003a0 <cprintf>
                  for(j=0 ; j < NPTENTRIES ; j++) {
80104bc7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104bce:	eb 76                	jmp    80104c46 <procdump+0x249>
                      pte = &pgtab[j];
80104bd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104bd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104bda:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104bdd:	01 d0                	add    %edx,%eax
80104bdf:	89 45 c8             	mov    %eax,-0x38(%ebp)

                      if((*pte & PTE_P) && (*pte & PTE_U) && (*pte & PTE_A)) {
80104be2:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104be5:	8b 00                	mov    (%eax),%eax
80104be7:	83 e0 01             	and    $0x1,%eax
80104bea:	85 c0                	test   %eax,%eax
80104bec:	74 54                	je     80104c42 <procdump+0x245>
80104bee:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104bf1:	8b 00                	mov    (%eax),%eax
80104bf3:	83 e0 04             	and    $0x4,%eax
80104bf6:	85 c0                	test   %eax,%eax
80104bf8:	74 48                	je     80104c42 <procdump+0x245>
80104bfa:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104bfd:	8b 00                	mov    (%eax),%eax
80104bff:	83 e0 20             	and    $0x20,%eax
80104c02:	85 c0                	test   %eax,%eax
80104c04:	74 3c                	je     80104c42 <procdump+0x245>
                          pte_ppn = PTE_ADDR(*pte);
80104c06:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104c09:	8b 00                	mov    (%eax),%eax
80104c0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80104c10:	89 45 c4             	mov    %eax,-0x3c(%ebp)
                          phyppn = (pte_t)p2v(pte_ppn);
80104c13:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104c16:	89 04 24             	mov    %eax,(%esp)
80104c19:	e8 84 f3 ff ff       	call   80103fa2 <p2v>
80104c1e:	89 45 c0             	mov    %eax,-0x40(%ebp)
                          cprintf("    |__ptble PTE %d, %d, %p\n",j,pte_ppn,phyppn);
80104c21:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104c24:	89 44 24 0c          	mov    %eax,0xc(%esp)
80104c28:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104c2b:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104c32:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c36:	c7 04 24 a4 8f 10 80 	movl   $0x80108fa4,(%esp)
80104c3d:	e8 5e b7 ff ff       	call   801003a0 <cprintf>
                  uint pte_ppn;

                  cprintf("\n%d) pdir PTE %d, %p \n",n,i,pde_ppn);
                  n++;
                  cprintf("memory location of page table = %p\n",pgtab);
                  for(j=0 ; j < NPTENTRIES ; j++) {
80104c42:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104c46:	81 7d e4 ff 03 00 00 	cmpl   $0x3ff,-0x1c(%ebp)
80104c4d:	7e 81                	jle    80104bd0 <procdump+0x1d3>
              cprintf(" %p", pc[i]);
          //3.1
          cprintf("\n*Page tables:\n");
          cprintf("memory location of page directory = %d\n",p->pgdir);
          int n = 1;
          for(i=0 ; i < NPDENTRIES ;i++) {
80104c4f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104c53:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80104c5a:	0f 8e d3 fe ff ff    	jle    80104b33 <procdump+0x136>
                          cprintf("    |__ptble PTE %d, %d, %p\n",j,pte_ppn,phyppn);
                      }
                  }
              }
          }
          cprintf("\n\n**Page mapping**\n"); 
80104c60:	c7 04 24 c1 8f 10 80 	movl   $0x80108fc1,(%esp)
80104c67:	e8 34 b7 ff ff       	call   801003a0 <cprintf>
          for(i=0 ; i < NPDENTRIES ;i++) {
80104c6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104c73:	e9 16 01 00 00       	jmp    80104d8e <procdump+0x391>
              //1.3
              int j;
              pde_t *pde = &p->pgdir[i];              // page drivetory entry
80104c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c7b:	8b 40 04             	mov    0x4(%eax),%eax
80104c7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c81:	c1 e2 02             	shl    $0x2,%edx
80104c84:	01 d0                	add    %edx,%eax
80104c86:	89 45 bc             	mov    %eax,-0x44(%ebp)
              pte_t *pgtab;                           // page table address
              pde_t *pte;                             // page table entry

              if((*pde & PTE_P) && (*pde & PTE_U)  ) {
80104c89:	8b 45 bc             	mov    -0x44(%ebp),%eax
80104c8c:	8b 00                	mov    (%eax),%eax
80104c8e:	83 e0 01             	and    $0x1,%eax
80104c91:	85 c0                	test   %eax,%eax
80104c93:	0f 84 f1 00 00 00    	je     80104d8a <procdump+0x38d>
80104c99:	8b 45 bc             	mov    -0x44(%ebp),%eax
80104c9c:	8b 00                	mov    (%eax),%eax
80104c9e:	83 e0 04             	and    $0x4,%eax
80104ca1:	85 c0                	test   %eax,%eax
80104ca3:	0f 84 e1 00 00 00    	je     80104d8a <procdump+0x38d>
                  uint pde_ppn    =  PTE_ADDR(*pde);          // 20 MSBs in pgdir entry.
80104ca9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80104cac:	8b 00                	mov    (%eax),%eax
80104cae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80104cb3:	89 45 b8             	mov    %eax,-0x48(%ebp)
                  pgtab = (pte_t*)p2v(pde_ppn);               // address of relevant page table
80104cb6:	8b 45 b8             	mov    -0x48(%ebp),%eax
80104cb9:	89 04 24             	mov    %eax,(%esp)
80104cbc:	e8 e1 f2 ff ff       	call   80103fa2 <p2v>
80104cc1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
                  uint virppn;
                  uint pte_ppn;

                  for(j=0 ; j < NPTENTRIES ; j++) {
80104cc4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80104ccb:	e9 ad 00 00 00       	jmp    80104d7d <procdump+0x380>
                      pte = &pgtab[j];
80104cd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104cd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104cda:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104cdd:	01 d0                	add    %edx,%eax
80104cdf:	89 45 b0             	mov    %eax,-0x50(%ebp)

                      if((*pte & PTE_P) && (*pte & PTE_U) ) {
80104ce2:	8b 45 b0             	mov    -0x50(%ebp),%eax
80104ce5:	8b 00                	mov    (%eax),%eax
80104ce7:	83 e0 01             	and    $0x1,%eax
80104cea:	85 c0                	test   %eax,%eax
80104cec:	0f 84 87 00 00 00    	je     80104d79 <procdump+0x37c>
80104cf2:	8b 45 b0             	mov    -0x50(%ebp),%eax
80104cf5:	8b 00                	mov    (%eax),%eax
80104cf7:	83 e0 04             	and    $0x4,%eax
80104cfa:	85 c0                	test   %eax,%eax
80104cfc:	74 7b                	je     80104d79 <procdump+0x37c>
                          pte_ppn = PTE_ADDR(*pte);
80104cfe:	8b 45 b0             	mov    -0x50(%ebp),%eax
80104d01:	8b 00                	mov    (%eax),%eax
80104d03:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80104d08:	89 45 ac             	mov    %eax,-0x54(%ebp)
                          virppn = (pte_t)p2v(pte_ppn);
80104d0b:	8b 45 ac             	mov    -0x54(%ebp),%eax
80104d0e:	89 04 24             	mov    %eax,(%esp)
80104d11:	e8 8c f2 ff ff       	call   80103fa2 <p2v>
80104d16:	89 45 a8             	mov    %eax,-0x58(%ebp)

                          char *readOnly = "n";
80104d19:	c7 45 dc d5 8f 10 80 	movl   $0x80108fd5,-0x24(%ebp)
                          char *shared   = "n";
80104d20:	c7 45 d8 d5 8f 10 80 	movl   $0x80108fd5,-0x28(%ebp)
                          
                          if((*pte & PTE_SHARED)) {
80104d27:	8b 45 b0             	mov    -0x50(%ebp),%eax
80104d2a:	8b 00                	mov    (%eax),%eax
80104d2c:	25 00 02 00 00       	and    $0x200,%eax
80104d31:	85 c0                	test   %eax,%eax
80104d33:	74 09                	je     80104d3e <procdump+0x341>
                              shared = "y";
80104d35:	c7 45 d8 d7 8f 10 80 	movl   $0x80108fd7,-0x28(%ebp)
80104d3c:	eb 13                	jmp    80104d51 <procdump+0x354>
                          } else if (!(*pte & PTE_W)) {
80104d3e:	8b 45 b0             	mov    -0x50(%ebp),%eax
80104d41:	8b 00                	mov    (%eax),%eax
80104d43:	83 e0 02             	and    $0x2,%eax
80104d46:	85 c0                	test   %eax,%eax
80104d48:	75 07                	jne    80104d51 <procdump+0x354>
                              readOnly = "y";
80104d4a:	c7 45 dc d7 8f 10 80 	movl   $0x80108fd7,-0x24(%ebp)
                          }
                          cprintf("%d -> %d , %s , %s \n",virppn,pte_ppn,readOnly,shared);
80104d51:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104d54:	89 44 24 10          	mov    %eax,0x10(%esp)
80104d58:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104d5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
80104d5f:	8b 45 ac             	mov    -0x54(%ebp),%eax
80104d62:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d66:	8b 45 a8             	mov    -0x58(%ebp),%eax
80104d69:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d6d:	c7 04 24 d9 8f 10 80 	movl   $0x80108fd9,(%esp)
80104d74:	e8 27 b6 ff ff       	call   801003a0 <cprintf>
                  uint pde_ppn    =  PTE_ADDR(*pde);          // 20 MSBs in pgdir entry.
                  pgtab = (pte_t*)p2v(pde_ppn);               // address of relevant page table
                  uint virppn;
                  uint pte_ppn;

                  for(j=0 ; j < NPTENTRIES ; j++) {
80104d79:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80104d7d:	81 7d e0 ff 03 00 00 	cmpl   $0x3ff,-0x20(%ebp)
80104d84:	0f 8e 46 ff ff ff    	jle    80104cd0 <procdump+0x2d3>
                      }
                  }
              }
          }
          cprintf("\n\n**Page mapping**\n"); 
          for(i=0 ; i < NPDENTRIES ;i++) {
80104d8a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104d8e:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80104d95:	0f 8e dd fe ff ff    	jle    80104c78 <procdump+0x27b>
                      }
                  }
              }
          }
      }
    cprintf("-------------------------------------------------------------------------\n");
80104d9b:	c7 04 24 f0 8f 10 80 	movl   $0x80108ff0,(%esp)
80104da2:	e8 f9 b5 ff ff       	call   801003a0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104da7:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104dab:	81 7d f0 74 2e 11 80 	cmpl   $0x80112e74,-0x10(%ebp)
80104db2:	0f 82 66 fc ff ff    	jb     80104a1e <procdump+0x21>
              }
          }
      }
    cprintf("-------------------------------------------------------------------------\n");
  }
}
80104db8:	c9                   	leave  
80104db9:	c3                   	ret    

80104dba <cowfork>:
// 3.4 Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
cowfork(void)
{
80104dba:	55                   	push   %ebp
80104dbb:	89 e5                	mov    %esp,%ebp
80104dbd:	57                   	push   %edi
80104dbe:	56                   	push   %esi
80104dbf:	53                   	push   %ebx
80104dc0:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104dc3:	e8 19 f2 ff ff       	call   80103fe1 <allocproc>
80104dc8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104dcb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104dcf:	75 0a                	jne    80104ddb <cowfork+0x21>
    return -1;
80104dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd6:	e9 3a 01 00 00       	jmp    80104f15 <cowfork+0x15b>

  // Copy process state from p.
  if((np->pgdir = copyuvm_cow(proc->pgdir, proc->sz)) == 0){
80104ddb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de1:	8b 10                	mov    (%eax),%edx
80104de3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de9:	8b 40 04             	mov    0x4(%eax),%eax
80104dec:	89 54 24 04          	mov    %edx,0x4(%esp)
80104df0:	89 04 24             	mov    %eax,(%esp)
80104df3:	e8 1f 3a 00 00       	call   80108817 <copyuvm_cow>
80104df8:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104dfb:	89 42 04             	mov    %eax,0x4(%edx)
80104dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e01:	8b 40 04             	mov    0x4(%eax),%eax
80104e04:	85 c0                	test   %eax,%eax
80104e06:	75 2c                	jne    80104e34 <cowfork+0x7a>
    kfree(np->kstack);
80104e08:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e0b:	8b 40 08             	mov    0x8(%eax),%eax
80104e0e:	89 04 24             	mov    %eax,(%esp)
80104e11:	e8 41 dc ff ff       	call   80102a57 <kfree>
    np->kstack = 0;
80104e16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e19:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104e20:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e23:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104e2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e2f:	e9 e1 00 00 00       	jmp    80104f15 <cowfork+0x15b>
  }
  np->sz = proc->sz;
80104e34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e3a:	8b 10                	mov    (%eax),%edx
80104e3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e3f:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104e41:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e4b:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104e4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e51:	8b 50 18             	mov    0x18(%eax),%edx
80104e54:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e5a:	8b 40 18             	mov    0x18(%eax),%eax
80104e5d:	89 c3                	mov    %eax,%ebx
80104e5f:	b8 13 00 00 00       	mov    $0x13,%eax
80104e64:	89 d7                	mov    %edx,%edi
80104e66:	89 de                	mov    %ebx,%esi
80104e68:	89 c1                	mov    %eax,%ecx
80104e6a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104e6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e6f:	8b 40 18             	mov    0x18(%eax),%eax
80104e72:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104e79:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104e80:	eb 3d                	jmp    80104ebf <cowfork+0x105>
    if(proc->ofile[i])
80104e82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104e8b:	83 c2 08             	add    $0x8,%edx
80104e8e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104e92:	85 c0                	test   %eax,%eax
80104e94:	74 25                	je     80104ebb <cowfork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
80104e96:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104e9f:	83 c2 08             	add    $0x8,%edx
80104ea2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ea6:	89 04 24             	mov    %eax,(%esp)
80104ea9:	e8 e6 c0 ff ff       	call   80100f94 <filedup>
80104eae:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104eb1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104eb4:	83 c1 08             	add    $0x8,%ecx
80104eb7:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104ebb:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104ebf:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104ec3:	7e bd                	jle    80104e82 <cowfork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104ec5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ecb:	8b 40 68             	mov    0x68(%eax),%eax
80104ece:	89 04 24             	mov    %eax,(%esp)
80104ed1:	e8 61 c9 ff ff       	call   80101837 <idup>
80104ed6:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104ed9:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
80104edc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104edf:	8b 40 10             	mov    0x10(%eax),%eax
80104ee2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
80104ee5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ee8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104eef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ef5:	8d 50 6c             	lea    0x6c(%eax),%edx
80104ef8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104efb:	83 c0 6c             	add    $0x6c,%eax
80104efe:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104f05:	00 
80104f06:	89 54 24 04          	mov    %edx,0x4(%esp)
80104f0a:	89 04 24             	mov    %eax,(%esp)
80104f0d:	e8 d6 04 00 00       	call   801053e8 <safestrcpy>
  return pid;
80104f12:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104f15:	83 c4 2c             	add    $0x2c,%esp
80104f18:	5b                   	pop    %ebx
80104f19:	5e                   	pop    %esi
80104f1a:	5f                   	pop    %edi
80104f1b:	5d                   	pop    %ebp
80104f1c:	c3                   	ret    

80104f1d <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104f1d:	55                   	push   %ebp
80104f1e:	89 e5                	mov    %esp,%ebp
80104f20:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f23:	9c                   	pushf  
80104f24:	58                   	pop    %eax
80104f25:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104f28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f2b:	c9                   	leave  
80104f2c:	c3                   	ret    

80104f2d <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104f2d:	55                   	push   %ebp
80104f2e:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104f30:	fa                   	cli    
}
80104f31:	5d                   	pop    %ebp
80104f32:	c3                   	ret    

80104f33 <sti>:

static inline void
sti(void)
{
80104f33:	55                   	push   %ebp
80104f34:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104f36:	fb                   	sti    
}
80104f37:	5d                   	pop    %ebp
80104f38:	c3                   	ret    

80104f39 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104f39:	55                   	push   %ebp
80104f3a:	89 e5                	mov    %esp,%ebp
80104f3c:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f3f:	8b 55 08             	mov    0x8(%ebp),%edx
80104f42:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f45:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f48:	f0 87 02             	lock xchg %eax,(%edx)
80104f4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f51:	c9                   	leave  
80104f52:	c3                   	ret    

80104f53 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f53:	55                   	push   %ebp
80104f54:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104f56:	8b 45 08             	mov    0x8(%ebp),%eax
80104f59:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f5c:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104f5f:	8b 45 08             	mov    0x8(%ebp),%eax
80104f62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104f68:	8b 45 08             	mov    0x8(%ebp),%eax
80104f6b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f72:	5d                   	pop    %ebp
80104f73:	c3                   	ret    

80104f74 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104f74:	55                   	push   %ebp
80104f75:	89 e5                	mov    %esp,%ebp
80104f77:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104f7a:	e8 49 01 00 00       	call   801050c8 <pushcli>
  if(holding(lk))
80104f7f:	8b 45 08             	mov    0x8(%ebp),%eax
80104f82:	89 04 24             	mov    %eax,(%esp)
80104f85:	e8 14 01 00 00       	call   8010509e <holding>
80104f8a:	85 c0                	test   %eax,%eax
80104f8c:	74 0c                	je     80104f9a <acquire+0x26>
    panic("acquire");
80104f8e:	c7 04 24 65 90 10 80 	movl   $0x80109065,(%esp)
80104f95:	e8 a0 b5 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104f9a:	90                   	nop
80104f9b:	8b 45 08             	mov    0x8(%ebp),%eax
80104f9e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104fa5:	00 
80104fa6:	89 04 24             	mov    %eax,(%esp)
80104fa9:	e8 8b ff ff ff       	call   80104f39 <xchg>
80104fae:	85 c0                	test   %eax,%eax
80104fb0:	75 e9                	jne    80104f9b <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104fb2:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104fbc:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc2:	83 c0 0c             	add    $0xc,%eax
80104fc5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fc9:	8d 45 08             	lea    0x8(%ebp),%eax
80104fcc:	89 04 24             	mov    %eax,(%esp)
80104fcf:	e8 51 00 00 00       	call   80105025 <getcallerpcs>
}
80104fd4:	c9                   	leave  
80104fd5:	c3                   	ret    

80104fd6 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104fd6:	55                   	push   %ebp
80104fd7:	89 e5                	mov    %esp,%ebp
80104fd9:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104fdc:	8b 45 08             	mov    0x8(%ebp),%eax
80104fdf:	89 04 24             	mov    %eax,(%esp)
80104fe2:	e8 b7 00 00 00       	call   8010509e <holding>
80104fe7:	85 c0                	test   %eax,%eax
80104fe9:	75 0c                	jne    80104ff7 <release+0x21>
    panic("release");
80104feb:	c7 04 24 6d 90 10 80 	movl   $0x8010906d,(%esp)
80104ff2:	e8 43 b5 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80104ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80104ffa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105001:	8b 45 08             	mov    0x8(%ebp),%eax
80105004:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010500b:	8b 45 08             	mov    0x8(%ebp),%eax
8010500e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105015:	00 
80105016:	89 04 24             	mov    %eax,(%esp)
80105019:	e8 1b ff ff ff       	call   80104f39 <xchg>

  popcli();
8010501e:	e8 e9 00 00 00       	call   8010510c <popcli>
}
80105023:	c9                   	leave  
80105024:	c3                   	ret    

80105025 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105025:	55                   	push   %ebp
80105026:	89 e5                	mov    %esp,%ebp
80105028:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010502b:	8b 45 08             	mov    0x8(%ebp),%eax
8010502e:	83 e8 08             	sub    $0x8,%eax
80105031:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105034:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010503b:	eb 38                	jmp    80105075 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010503d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105041:	74 38                	je     8010507b <getcallerpcs+0x56>
80105043:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010504a:	76 2f                	jbe    8010507b <getcallerpcs+0x56>
8010504c:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105050:	74 29                	je     8010507b <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105052:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105055:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010505c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010505f:	01 c2                	add    %eax,%edx
80105061:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105064:	8b 40 04             	mov    0x4(%eax),%eax
80105067:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105069:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010506c:	8b 00                	mov    (%eax),%eax
8010506e:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105071:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105075:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105079:	7e c2                	jle    8010503d <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010507b:	eb 19                	jmp    80105096 <getcallerpcs+0x71>
    pcs[i] = 0;
8010507d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105080:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105087:	8b 45 0c             	mov    0xc(%ebp),%eax
8010508a:	01 d0                	add    %edx,%eax
8010508c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105092:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105096:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010509a:	7e e1                	jle    8010507d <getcallerpcs+0x58>
    pcs[i] = 0;
}
8010509c:	c9                   	leave  
8010509d:	c3                   	ret    

8010509e <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010509e:	55                   	push   %ebp
8010509f:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801050a1:	8b 45 08             	mov    0x8(%ebp),%eax
801050a4:	8b 00                	mov    (%eax),%eax
801050a6:	85 c0                	test   %eax,%eax
801050a8:	74 17                	je     801050c1 <holding+0x23>
801050aa:	8b 45 08             	mov    0x8(%ebp),%eax
801050ad:	8b 50 08             	mov    0x8(%eax),%edx
801050b0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050b6:	39 c2                	cmp    %eax,%edx
801050b8:	75 07                	jne    801050c1 <holding+0x23>
801050ba:	b8 01 00 00 00       	mov    $0x1,%eax
801050bf:	eb 05                	jmp    801050c6 <holding+0x28>
801050c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050c6:	5d                   	pop    %ebp
801050c7:	c3                   	ret    

801050c8 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801050c8:	55                   	push   %ebp
801050c9:	89 e5                	mov    %esp,%ebp
801050cb:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801050ce:	e8 4a fe ff ff       	call   80104f1d <readeflags>
801050d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801050d6:	e8 52 fe ff ff       	call   80104f2d <cli>
  if(cpu->ncli++ == 0)
801050db:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801050e2:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801050e8:	8d 48 01             	lea    0x1(%eax),%ecx
801050eb:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801050f1:	85 c0                	test   %eax,%eax
801050f3:	75 15                	jne    8010510a <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801050f5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
801050fe:	81 e2 00 02 00 00    	and    $0x200,%edx
80105104:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010510a:	c9                   	leave  
8010510b:	c3                   	ret    

8010510c <popcli>:

void
popcli(void)
{
8010510c:	55                   	push   %ebp
8010510d:	89 e5                	mov    %esp,%ebp
8010510f:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105112:	e8 06 fe ff ff       	call   80104f1d <readeflags>
80105117:	25 00 02 00 00       	and    $0x200,%eax
8010511c:	85 c0                	test   %eax,%eax
8010511e:	74 0c                	je     8010512c <popcli+0x20>
    panic("popcli - interruptible");
80105120:	c7 04 24 75 90 10 80 	movl   $0x80109075,(%esp)
80105127:	e8 0e b4 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
8010512c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105132:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105138:	83 ea 01             	sub    $0x1,%edx
8010513b:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105141:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105147:	85 c0                	test   %eax,%eax
80105149:	79 0c                	jns    80105157 <popcli+0x4b>
    panic("popcli");
8010514b:	c7 04 24 8c 90 10 80 	movl   $0x8010908c,(%esp)
80105152:	e8 e3 b3 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105157:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010515d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105163:	85 c0                	test   %eax,%eax
80105165:	75 15                	jne    8010517c <popcli+0x70>
80105167:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010516d:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105173:	85 c0                	test   %eax,%eax
80105175:	74 05                	je     8010517c <popcli+0x70>
    sti();
80105177:	e8 b7 fd ff ff       	call   80104f33 <sti>
}
8010517c:	c9                   	leave  
8010517d:	c3                   	ret    

8010517e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010517e:	55                   	push   %ebp
8010517f:	89 e5                	mov    %esp,%ebp
80105181:	57                   	push   %edi
80105182:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105183:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105186:	8b 55 10             	mov    0x10(%ebp),%edx
80105189:	8b 45 0c             	mov    0xc(%ebp),%eax
8010518c:	89 cb                	mov    %ecx,%ebx
8010518e:	89 df                	mov    %ebx,%edi
80105190:	89 d1                	mov    %edx,%ecx
80105192:	fc                   	cld    
80105193:	f3 aa                	rep stos %al,%es:(%edi)
80105195:	89 ca                	mov    %ecx,%edx
80105197:	89 fb                	mov    %edi,%ebx
80105199:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010519c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010519f:	5b                   	pop    %ebx
801051a0:	5f                   	pop    %edi
801051a1:	5d                   	pop    %ebp
801051a2:	c3                   	ret    

801051a3 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801051a3:	55                   	push   %ebp
801051a4:	89 e5                	mov    %esp,%ebp
801051a6:	57                   	push   %edi
801051a7:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801051a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051ab:	8b 55 10             	mov    0x10(%ebp),%edx
801051ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801051b1:	89 cb                	mov    %ecx,%ebx
801051b3:	89 df                	mov    %ebx,%edi
801051b5:	89 d1                	mov    %edx,%ecx
801051b7:	fc                   	cld    
801051b8:	f3 ab                	rep stos %eax,%es:(%edi)
801051ba:	89 ca                	mov    %ecx,%edx
801051bc:	89 fb                	mov    %edi,%ebx
801051be:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051c1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801051c4:	5b                   	pop    %ebx
801051c5:	5f                   	pop    %edi
801051c6:	5d                   	pop    %ebp
801051c7:	c3                   	ret    

801051c8 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801051c8:	55                   	push   %ebp
801051c9:	89 e5                	mov    %esp,%ebp
801051cb:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801051ce:	8b 45 08             	mov    0x8(%ebp),%eax
801051d1:	83 e0 03             	and    $0x3,%eax
801051d4:	85 c0                	test   %eax,%eax
801051d6:	75 49                	jne    80105221 <memset+0x59>
801051d8:	8b 45 10             	mov    0x10(%ebp),%eax
801051db:	83 e0 03             	and    $0x3,%eax
801051de:	85 c0                	test   %eax,%eax
801051e0:	75 3f                	jne    80105221 <memset+0x59>
    c &= 0xFF;
801051e2:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801051e9:	8b 45 10             	mov    0x10(%ebp),%eax
801051ec:	c1 e8 02             	shr    $0x2,%eax
801051ef:	89 c2                	mov    %eax,%edx
801051f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801051f4:	c1 e0 18             	shl    $0x18,%eax
801051f7:	89 c1                	mov    %eax,%ecx
801051f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801051fc:	c1 e0 10             	shl    $0x10,%eax
801051ff:	09 c1                	or     %eax,%ecx
80105201:	8b 45 0c             	mov    0xc(%ebp),%eax
80105204:	c1 e0 08             	shl    $0x8,%eax
80105207:	09 c8                	or     %ecx,%eax
80105209:	0b 45 0c             	or     0xc(%ebp),%eax
8010520c:	89 54 24 08          	mov    %edx,0x8(%esp)
80105210:	89 44 24 04          	mov    %eax,0x4(%esp)
80105214:	8b 45 08             	mov    0x8(%ebp),%eax
80105217:	89 04 24             	mov    %eax,(%esp)
8010521a:	e8 84 ff ff ff       	call   801051a3 <stosl>
8010521f:	eb 19                	jmp    8010523a <memset+0x72>
  } else
    stosb(dst, c, n);
80105221:	8b 45 10             	mov    0x10(%ebp),%eax
80105224:	89 44 24 08          	mov    %eax,0x8(%esp)
80105228:	8b 45 0c             	mov    0xc(%ebp),%eax
8010522b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010522f:	8b 45 08             	mov    0x8(%ebp),%eax
80105232:	89 04 24             	mov    %eax,(%esp)
80105235:	e8 44 ff ff ff       	call   8010517e <stosb>
  return dst;
8010523a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010523d:	c9                   	leave  
8010523e:	c3                   	ret    

8010523f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010523f:	55                   	push   %ebp
80105240:	89 e5                	mov    %esp,%ebp
80105242:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105245:	8b 45 08             	mov    0x8(%ebp),%eax
80105248:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010524b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010524e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105251:	eb 30                	jmp    80105283 <memcmp+0x44>
    if(*s1 != *s2)
80105253:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105256:	0f b6 10             	movzbl (%eax),%edx
80105259:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010525c:	0f b6 00             	movzbl (%eax),%eax
8010525f:	38 c2                	cmp    %al,%dl
80105261:	74 18                	je     8010527b <memcmp+0x3c>
      return *s1 - *s2;
80105263:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105266:	0f b6 00             	movzbl (%eax),%eax
80105269:	0f b6 d0             	movzbl %al,%edx
8010526c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010526f:	0f b6 00             	movzbl (%eax),%eax
80105272:	0f b6 c0             	movzbl %al,%eax
80105275:	29 c2                	sub    %eax,%edx
80105277:	89 d0                	mov    %edx,%eax
80105279:	eb 1a                	jmp    80105295 <memcmp+0x56>
    s1++, s2++;
8010527b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010527f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105283:	8b 45 10             	mov    0x10(%ebp),%eax
80105286:	8d 50 ff             	lea    -0x1(%eax),%edx
80105289:	89 55 10             	mov    %edx,0x10(%ebp)
8010528c:	85 c0                	test   %eax,%eax
8010528e:	75 c3                	jne    80105253 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105290:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105295:	c9                   	leave  
80105296:	c3                   	ret    

80105297 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105297:	55                   	push   %ebp
80105298:	89 e5                	mov    %esp,%ebp
8010529a:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010529d:	8b 45 0c             	mov    0xc(%ebp),%eax
801052a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801052a3:	8b 45 08             	mov    0x8(%ebp),%eax
801052a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801052a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052af:	73 3d                	jae    801052ee <memmove+0x57>
801052b1:	8b 45 10             	mov    0x10(%ebp),%eax
801052b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052b7:	01 d0                	add    %edx,%eax
801052b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052bc:	76 30                	jbe    801052ee <memmove+0x57>
    s += n;
801052be:	8b 45 10             	mov    0x10(%ebp),%eax
801052c1:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801052c4:	8b 45 10             	mov    0x10(%ebp),%eax
801052c7:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801052ca:	eb 13                	jmp    801052df <memmove+0x48>
      *--d = *--s;
801052cc:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801052d0:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801052d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052d7:	0f b6 10             	movzbl (%eax),%edx
801052da:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052dd:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801052df:	8b 45 10             	mov    0x10(%ebp),%eax
801052e2:	8d 50 ff             	lea    -0x1(%eax),%edx
801052e5:	89 55 10             	mov    %edx,0x10(%ebp)
801052e8:	85 c0                	test   %eax,%eax
801052ea:	75 e0                	jne    801052cc <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801052ec:	eb 26                	jmp    80105314 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801052ee:	eb 17                	jmp    80105307 <memmove+0x70>
      *d++ = *s++;
801052f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052f3:	8d 50 01             	lea    0x1(%eax),%edx
801052f6:	89 55 f8             	mov    %edx,-0x8(%ebp)
801052f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052fc:	8d 4a 01             	lea    0x1(%edx),%ecx
801052ff:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105302:	0f b6 12             	movzbl (%edx),%edx
80105305:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105307:	8b 45 10             	mov    0x10(%ebp),%eax
8010530a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010530d:	89 55 10             	mov    %edx,0x10(%ebp)
80105310:	85 c0                	test   %eax,%eax
80105312:	75 dc                	jne    801052f0 <memmove+0x59>
      *d++ = *s++;

  return dst;
80105314:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105317:	c9                   	leave  
80105318:	c3                   	ret    

80105319 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105319:	55                   	push   %ebp
8010531a:	89 e5                	mov    %esp,%ebp
8010531c:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
8010531f:	8b 45 10             	mov    0x10(%ebp),%eax
80105322:	89 44 24 08          	mov    %eax,0x8(%esp)
80105326:	8b 45 0c             	mov    0xc(%ebp),%eax
80105329:	89 44 24 04          	mov    %eax,0x4(%esp)
8010532d:	8b 45 08             	mov    0x8(%ebp),%eax
80105330:	89 04 24             	mov    %eax,(%esp)
80105333:	e8 5f ff ff ff       	call   80105297 <memmove>
}
80105338:	c9                   	leave  
80105339:	c3                   	ret    

8010533a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010533a:	55                   	push   %ebp
8010533b:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010533d:	eb 0c                	jmp    8010534b <strncmp+0x11>
    n--, p++, q++;
8010533f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105343:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105347:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010534b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010534f:	74 1a                	je     8010536b <strncmp+0x31>
80105351:	8b 45 08             	mov    0x8(%ebp),%eax
80105354:	0f b6 00             	movzbl (%eax),%eax
80105357:	84 c0                	test   %al,%al
80105359:	74 10                	je     8010536b <strncmp+0x31>
8010535b:	8b 45 08             	mov    0x8(%ebp),%eax
8010535e:	0f b6 10             	movzbl (%eax),%edx
80105361:	8b 45 0c             	mov    0xc(%ebp),%eax
80105364:	0f b6 00             	movzbl (%eax),%eax
80105367:	38 c2                	cmp    %al,%dl
80105369:	74 d4                	je     8010533f <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010536b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010536f:	75 07                	jne    80105378 <strncmp+0x3e>
    return 0;
80105371:	b8 00 00 00 00       	mov    $0x0,%eax
80105376:	eb 16                	jmp    8010538e <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105378:	8b 45 08             	mov    0x8(%ebp),%eax
8010537b:	0f b6 00             	movzbl (%eax),%eax
8010537e:	0f b6 d0             	movzbl %al,%edx
80105381:	8b 45 0c             	mov    0xc(%ebp),%eax
80105384:	0f b6 00             	movzbl (%eax),%eax
80105387:	0f b6 c0             	movzbl %al,%eax
8010538a:	29 c2                	sub    %eax,%edx
8010538c:	89 d0                	mov    %edx,%eax
}
8010538e:	5d                   	pop    %ebp
8010538f:	c3                   	ret    

80105390 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105396:	8b 45 08             	mov    0x8(%ebp),%eax
80105399:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010539c:	90                   	nop
8010539d:	8b 45 10             	mov    0x10(%ebp),%eax
801053a0:	8d 50 ff             	lea    -0x1(%eax),%edx
801053a3:	89 55 10             	mov    %edx,0x10(%ebp)
801053a6:	85 c0                	test   %eax,%eax
801053a8:	7e 1e                	jle    801053c8 <strncpy+0x38>
801053aa:	8b 45 08             	mov    0x8(%ebp),%eax
801053ad:	8d 50 01             	lea    0x1(%eax),%edx
801053b0:	89 55 08             	mov    %edx,0x8(%ebp)
801053b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801053b6:	8d 4a 01             	lea    0x1(%edx),%ecx
801053b9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801053bc:	0f b6 12             	movzbl (%edx),%edx
801053bf:	88 10                	mov    %dl,(%eax)
801053c1:	0f b6 00             	movzbl (%eax),%eax
801053c4:	84 c0                	test   %al,%al
801053c6:	75 d5                	jne    8010539d <strncpy+0xd>
    ;
  while(n-- > 0)
801053c8:	eb 0c                	jmp    801053d6 <strncpy+0x46>
    *s++ = 0;
801053ca:	8b 45 08             	mov    0x8(%ebp),%eax
801053cd:	8d 50 01             	lea    0x1(%eax),%edx
801053d0:	89 55 08             	mov    %edx,0x8(%ebp)
801053d3:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801053d6:	8b 45 10             	mov    0x10(%ebp),%eax
801053d9:	8d 50 ff             	lea    -0x1(%eax),%edx
801053dc:	89 55 10             	mov    %edx,0x10(%ebp)
801053df:	85 c0                	test   %eax,%eax
801053e1:	7f e7                	jg     801053ca <strncpy+0x3a>
    *s++ = 0;
  return os;
801053e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053e6:	c9                   	leave  
801053e7:	c3                   	ret    

801053e8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053e8:	55                   	push   %ebp
801053e9:	89 e5                	mov    %esp,%ebp
801053eb:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801053ee:	8b 45 08             	mov    0x8(%ebp),%eax
801053f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801053f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053f8:	7f 05                	jg     801053ff <safestrcpy+0x17>
    return os;
801053fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053fd:	eb 31                	jmp    80105430 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801053ff:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105403:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105407:	7e 1e                	jle    80105427 <safestrcpy+0x3f>
80105409:	8b 45 08             	mov    0x8(%ebp),%eax
8010540c:	8d 50 01             	lea    0x1(%eax),%edx
8010540f:	89 55 08             	mov    %edx,0x8(%ebp)
80105412:	8b 55 0c             	mov    0xc(%ebp),%edx
80105415:	8d 4a 01             	lea    0x1(%edx),%ecx
80105418:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010541b:	0f b6 12             	movzbl (%edx),%edx
8010541e:	88 10                	mov    %dl,(%eax)
80105420:	0f b6 00             	movzbl (%eax),%eax
80105423:	84 c0                	test   %al,%al
80105425:	75 d8                	jne    801053ff <safestrcpy+0x17>
    ;
  *s = 0;
80105427:	8b 45 08             	mov    0x8(%ebp),%eax
8010542a:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010542d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105430:	c9                   	leave  
80105431:	c3                   	ret    

80105432 <strlen>:

int
strlen(const char *s)
{
80105432:	55                   	push   %ebp
80105433:	89 e5                	mov    %esp,%ebp
80105435:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105438:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010543f:	eb 04                	jmp    80105445 <strlen+0x13>
80105441:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105445:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105448:	8b 45 08             	mov    0x8(%ebp),%eax
8010544b:	01 d0                	add    %edx,%eax
8010544d:	0f b6 00             	movzbl (%eax),%eax
80105450:	84 c0                	test   %al,%al
80105452:	75 ed                	jne    80105441 <strlen+0xf>
    ;
  return n;
80105454:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105457:	c9                   	leave  
80105458:	c3                   	ret    

80105459 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105459:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010545d:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105461:	55                   	push   %ebp
  pushl %ebx
80105462:	53                   	push   %ebx
  pushl %esi
80105463:	56                   	push   %esi
  pushl %edi
80105464:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105465:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105467:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105469:	5f                   	pop    %edi
  popl %esi
8010546a:	5e                   	pop    %esi
  popl %ebx
8010546b:	5b                   	pop    %ebx
  popl %ebp
8010546c:	5d                   	pop    %ebp
  ret
8010546d:	c3                   	ret    

8010546e <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
8010546e:	55                   	push   %ebp
8010546f:	89 e5                	mov    %esp,%ebp
  if(addr >= p->sz || addr+4 > p->sz)
80105471:	8b 45 08             	mov    0x8(%ebp),%eax
80105474:	8b 00                	mov    (%eax),%eax
80105476:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105479:	76 0f                	jbe    8010548a <fetchint+0x1c>
8010547b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010547e:	8d 50 04             	lea    0x4(%eax),%edx
80105481:	8b 45 08             	mov    0x8(%ebp),%eax
80105484:	8b 00                	mov    (%eax),%eax
80105486:	39 c2                	cmp    %eax,%edx
80105488:	76 07                	jbe    80105491 <fetchint+0x23>
    return -1;
8010548a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010548f:	eb 0f                	jmp    801054a0 <fetchint+0x32>
  *ip = *(int*)(addr);
80105491:	8b 45 0c             	mov    0xc(%ebp),%eax
80105494:	8b 10                	mov    (%eax),%edx
80105496:	8b 45 10             	mov    0x10(%ebp),%eax
80105499:	89 10                	mov    %edx,(%eax)
  return 0;
8010549b:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054a0:	5d                   	pop    %ebp
801054a1:	c3                   	ret    

801054a2 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
801054a2:	55                   	push   %ebp
801054a3:	89 e5                	mov    %esp,%ebp
801054a5:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= p->sz)
801054a8:	8b 45 08             	mov    0x8(%ebp),%eax
801054ab:	8b 00                	mov    (%eax),%eax
801054ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
801054b0:	77 07                	ja     801054b9 <fetchstr+0x17>
    return -1;
801054b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b7:	eb 43                	jmp    801054fc <fetchstr+0x5a>
  *pp = (char*)addr;
801054b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801054bc:	8b 45 10             	mov    0x10(%ebp),%eax
801054bf:	89 10                	mov    %edx,(%eax)
  ep = (char*)p->sz;
801054c1:	8b 45 08             	mov    0x8(%ebp),%eax
801054c4:	8b 00                	mov    (%eax),%eax
801054c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801054c9:	8b 45 10             	mov    0x10(%ebp),%eax
801054cc:	8b 00                	mov    (%eax),%eax
801054ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
801054d1:	eb 1c                	jmp    801054ef <fetchstr+0x4d>
    if(*s == 0)
801054d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054d6:	0f b6 00             	movzbl (%eax),%eax
801054d9:	84 c0                	test   %al,%al
801054db:	75 0e                	jne    801054eb <fetchstr+0x49>
      return s - *pp;
801054dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054e0:	8b 45 10             	mov    0x10(%ebp),%eax
801054e3:	8b 00                	mov    (%eax),%eax
801054e5:	29 c2                	sub    %eax,%edx
801054e7:	89 d0                	mov    %edx,%eax
801054e9:	eb 11                	jmp    801054fc <fetchstr+0x5a>

  if(addr >= p->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)p->sz;
  for(s = *pp; s < ep; s++)
801054eb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801054ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801054f5:	72 dc                	jb     801054d3 <fetchstr+0x31>
    if(*s == 0)
      return s - *pp;
  return -1;
801054f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054fc:	c9                   	leave  
801054fd:	c3                   	ret    

801054fe <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801054fe:	55                   	push   %ebp
801054ff:	89 e5                	mov    %esp,%ebp
80105501:	83 ec 0c             	sub    $0xc,%esp
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
80105504:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010550a:	8b 40 18             	mov    0x18(%eax),%eax
8010550d:	8b 50 44             	mov    0x44(%eax),%edx
80105510:	8b 45 08             	mov    0x8(%ebp),%eax
80105513:	c1 e0 02             	shl    $0x2,%eax
80105516:	01 d0                	add    %edx,%eax
80105518:	8d 48 04             	lea    0x4(%eax),%ecx
8010551b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105521:	8b 55 0c             	mov    0xc(%ebp),%edx
80105524:	89 54 24 08          	mov    %edx,0x8(%esp)
80105528:	89 4c 24 04          	mov    %ecx,0x4(%esp)
8010552c:	89 04 24             	mov    %eax,(%esp)
8010552f:	e8 3a ff ff ff       	call   8010546e <fetchint>
}
80105534:	c9                   	leave  
80105535:	c3                   	ret    

80105536 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105536:	55                   	push   %ebp
80105537:	89 e5                	mov    %esp,%ebp
80105539:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
8010553c:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010553f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105543:	8b 45 08             	mov    0x8(%ebp),%eax
80105546:	89 04 24             	mov    %eax,(%esp)
80105549:	e8 b0 ff ff ff       	call   801054fe <argint>
8010554e:	85 c0                	test   %eax,%eax
80105550:	79 07                	jns    80105559 <argptr+0x23>
    return -1;
80105552:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105557:	eb 3d                	jmp    80105596 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105559:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010555c:	89 c2                	mov    %eax,%edx
8010555e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105564:	8b 00                	mov    (%eax),%eax
80105566:	39 c2                	cmp    %eax,%edx
80105568:	73 16                	jae    80105580 <argptr+0x4a>
8010556a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010556d:	89 c2                	mov    %eax,%edx
8010556f:	8b 45 10             	mov    0x10(%ebp),%eax
80105572:	01 c2                	add    %eax,%edx
80105574:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010557a:	8b 00                	mov    (%eax),%eax
8010557c:	39 c2                	cmp    %eax,%edx
8010557e:	76 07                	jbe    80105587 <argptr+0x51>
    return -1;
80105580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105585:	eb 0f                	jmp    80105596 <argptr+0x60>
  *pp = (char*)i;
80105587:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010558a:	89 c2                	mov    %eax,%edx
8010558c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010558f:	89 10                	mov    %edx,(%eax)
  return 0;
80105591:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105596:	c9                   	leave  
80105597:	c3                   	ret    

80105598 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105598:	55                   	push   %ebp
80105599:	89 e5                	mov    %esp,%ebp
8010559b:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010559e:	8d 45 fc             	lea    -0x4(%ebp),%eax
801055a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801055a5:	8b 45 08             	mov    0x8(%ebp),%eax
801055a8:	89 04 24             	mov    %eax,(%esp)
801055ab:	e8 4e ff ff ff       	call   801054fe <argint>
801055b0:	85 c0                	test   %eax,%eax
801055b2:	79 07                	jns    801055bb <argstr+0x23>
    return -1;
801055b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b9:	eb 1e                	jmp    801055d9 <argstr+0x41>
  return fetchstr(proc, addr, pp);
801055bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055be:	89 c2                	mov    %eax,%edx
801055c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801055c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801055cd:	89 54 24 04          	mov    %edx,0x4(%esp)
801055d1:	89 04 24             	mov    %eax,(%esp)
801055d4:	e8 c9 fe ff ff       	call   801054a2 <fetchstr>
}
801055d9:	c9                   	leave  
801055da:	c3                   	ret    

801055db <syscall>:
[SYS_cowfork]   sys_cowfork,
};

void
syscall(void)
{
801055db:	55                   	push   %ebp
801055dc:	89 e5                	mov    %esp,%ebp
801055de:	53                   	push   %ebx
801055df:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
801055e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e8:	8b 40 18             	mov    0x18(%eax),%eax
801055eb:	8b 40 1c             	mov    0x1c(%eax),%eax
801055ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num >= 0 && num < SYS_open && syscalls[num]) {
801055f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055f5:	78 2e                	js     80105625 <syscall+0x4a>
801055f7:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
801055fb:	7f 28                	jg     80105625 <syscall+0x4a>
801055fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105600:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105607:	85 c0                	test   %eax,%eax
80105609:	74 1a                	je     80105625 <syscall+0x4a>
    proc->tf->eax = syscalls[num]();
8010560b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105611:	8b 58 18             	mov    0x18(%eax),%ebx
80105614:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105617:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
8010561e:	ff d0                	call   *%eax
80105620:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105623:	eb 73                	jmp    80105698 <syscall+0xbd>
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
80105625:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
80105629:	7e 30                	jle    8010565b <syscall+0x80>
8010562b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010562e:	83 f8 16             	cmp    $0x16,%eax
80105631:	77 28                	ja     8010565b <syscall+0x80>
80105633:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105636:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
8010563d:	85 c0                	test   %eax,%eax
8010563f:	74 1a                	je     8010565b <syscall+0x80>
    proc->tf->eax = syscalls[num]();
80105641:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105647:	8b 58 18             	mov    0x18(%eax),%ebx
8010564a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010564d:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105654:	ff d0                	call   *%eax
80105656:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105659:	eb 3d                	jmp    80105698 <syscall+0xbd>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
8010565b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105661:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105664:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(num >= 0 && num < SYS_open && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010566a:	8b 40 10             	mov    0x10(%eax),%eax
8010566d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105670:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105674:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105678:	89 44 24 04          	mov    %eax,0x4(%esp)
8010567c:	c7 04 24 93 90 10 80 	movl   $0x80109093,(%esp)
80105683:	e8 18 ad ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105688:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010568e:	8b 40 18             	mov    0x18(%eax),%eax
80105691:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105698:	83 c4 24             	add    $0x24,%esp
8010569b:	5b                   	pop    %ebx
8010569c:	5d                   	pop    %ebp
8010569d:	c3                   	ret    

8010569e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010569e:	55                   	push   %ebp
8010569f:	89 e5                	mov    %esp,%ebp
801056a1:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801056a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801056ab:	8b 45 08             	mov    0x8(%ebp),%eax
801056ae:	89 04 24             	mov    %eax,(%esp)
801056b1:	e8 48 fe ff ff       	call   801054fe <argint>
801056b6:	85 c0                	test   %eax,%eax
801056b8:	79 07                	jns    801056c1 <argfd+0x23>
    return -1;
801056ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056bf:	eb 50                	jmp    80105711 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801056c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056c4:	85 c0                	test   %eax,%eax
801056c6:	78 21                	js     801056e9 <argfd+0x4b>
801056c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056cb:	83 f8 0f             	cmp    $0xf,%eax
801056ce:	7f 19                	jg     801056e9 <argfd+0x4b>
801056d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056d9:	83 c2 08             	add    $0x8,%edx
801056dc:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801056e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056e7:	75 07                	jne    801056f0 <argfd+0x52>
    return -1;
801056e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ee:	eb 21                	jmp    80105711 <argfd+0x73>
  if(pfd)
801056f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801056f4:	74 08                	je     801056fe <argfd+0x60>
    *pfd = fd;
801056f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801056fc:	89 10                	mov    %edx,(%eax)
  if(pf)
801056fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105702:	74 08                	je     8010570c <argfd+0x6e>
    *pf = f;
80105704:	8b 45 10             	mov    0x10(%ebp),%eax
80105707:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010570a:	89 10                	mov    %edx,(%eax)
  return 0;
8010570c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105711:	c9                   	leave  
80105712:	c3                   	ret    

80105713 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105713:	55                   	push   %ebp
80105714:	89 e5                	mov    %esp,%ebp
80105716:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105719:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105720:	eb 30                	jmp    80105752 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105722:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105728:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010572b:	83 c2 08             	add    $0x8,%edx
8010572e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105732:	85 c0                	test   %eax,%eax
80105734:	75 18                	jne    8010574e <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105736:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010573c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010573f:	8d 4a 08             	lea    0x8(%edx),%ecx
80105742:	8b 55 08             	mov    0x8(%ebp),%edx
80105745:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105749:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010574c:	eb 0f                	jmp    8010575d <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010574e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105752:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105756:	7e ca                	jle    80105722 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105758:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010575d:	c9                   	leave  
8010575e:	c3                   	ret    

8010575f <sys_dup>:

int
sys_dup(void)
{
8010575f:	55                   	push   %ebp
80105760:	89 e5                	mov    %esp,%ebp
80105762:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105765:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105768:	89 44 24 08          	mov    %eax,0x8(%esp)
8010576c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105773:	00 
80105774:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010577b:	e8 1e ff ff ff       	call   8010569e <argfd>
80105780:	85 c0                	test   %eax,%eax
80105782:	79 07                	jns    8010578b <sys_dup+0x2c>
    return -1;
80105784:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105789:	eb 29                	jmp    801057b4 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010578b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010578e:	89 04 24             	mov    %eax,(%esp)
80105791:	e8 7d ff ff ff       	call   80105713 <fdalloc>
80105796:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105799:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010579d:	79 07                	jns    801057a6 <sys_dup+0x47>
    return -1;
8010579f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a4:	eb 0e                	jmp    801057b4 <sys_dup+0x55>
  filedup(f);
801057a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057a9:	89 04 24             	mov    %eax,(%esp)
801057ac:	e8 e3 b7 ff ff       	call   80100f94 <filedup>
  return fd;
801057b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801057b4:	c9                   	leave  
801057b5:	c3                   	ret    

801057b6 <sys_read>:

int
sys_read(void)
{
801057b6:	55                   	push   %ebp
801057b7:	89 e5                	mov    %esp,%ebp
801057b9:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057bf:	89 44 24 08          	mov    %eax,0x8(%esp)
801057c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801057ca:	00 
801057cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057d2:	e8 c7 fe ff ff       	call   8010569e <argfd>
801057d7:	85 c0                	test   %eax,%eax
801057d9:	78 35                	js     80105810 <sys_read+0x5a>
801057db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057de:	89 44 24 04          	mov    %eax,0x4(%esp)
801057e2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801057e9:	e8 10 fd ff ff       	call   801054fe <argint>
801057ee:	85 c0                	test   %eax,%eax
801057f0:	78 1e                	js     80105810 <sys_read+0x5a>
801057f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057f5:	89 44 24 08          	mov    %eax,0x8(%esp)
801057f9:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105800:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105807:	e8 2a fd ff ff       	call   80105536 <argptr>
8010580c:	85 c0                	test   %eax,%eax
8010580e:	79 07                	jns    80105817 <sys_read+0x61>
    return -1;
80105810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105815:	eb 19                	jmp    80105830 <sys_read+0x7a>
  return fileread(f, p, n);
80105817:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010581a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010581d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105820:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105824:	89 54 24 04          	mov    %edx,0x4(%esp)
80105828:	89 04 24             	mov    %eax,(%esp)
8010582b:	e8 d1 b8 ff ff       	call   80101101 <fileread>
}
80105830:	c9                   	leave  
80105831:	c3                   	ret    

80105832 <sys_write>:

int
sys_write(void)
{
80105832:	55                   	push   %ebp
80105833:	89 e5                	mov    %esp,%ebp
80105835:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105838:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010583b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010583f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105846:	00 
80105847:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010584e:	e8 4b fe ff ff       	call   8010569e <argfd>
80105853:	85 c0                	test   %eax,%eax
80105855:	78 35                	js     8010588c <sys_write+0x5a>
80105857:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010585a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010585e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105865:	e8 94 fc ff ff       	call   801054fe <argint>
8010586a:	85 c0                	test   %eax,%eax
8010586c:	78 1e                	js     8010588c <sys_write+0x5a>
8010586e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105871:	89 44 24 08          	mov    %eax,0x8(%esp)
80105875:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105878:	89 44 24 04          	mov    %eax,0x4(%esp)
8010587c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105883:	e8 ae fc ff ff       	call   80105536 <argptr>
80105888:	85 c0                	test   %eax,%eax
8010588a:	79 07                	jns    80105893 <sys_write+0x61>
    return -1;
8010588c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105891:	eb 19                	jmp    801058ac <sys_write+0x7a>
  return filewrite(f, p, n);
80105893:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105896:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105899:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010589c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801058a0:	89 54 24 04          	mov    %edx,0x4(%esp)
801058a4:	89 04 24             	mov    %eax,(%esp)
801058a7:	e8 11 b9 ff ff       	call   801011bd <filewrite>
}
801058ac:	c9                   	leave  
801058ad:	c3                   	ret    

801058ae <sys_close>:

int
sys_close(void)
{
801058ae:	55                   	push   %ebp
801058af:	89 e5                	mov    %esp,%ebp
801058b1:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801058b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058b7:	89 44 24 08          	mov    %eax,0x8(%esp)
801058bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058be:	89 44 24 04          	mov    %eax,0x4(%esp)
801058c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058c9:	e8 d0 fd ff ff       	call   8010569e <argfd>
801058ce:	85 c0                	test   %eax,%eax
801058d0:	79 07                	jns    801058d9 <sys_close+0x2b>
    return -1;
801058d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d7:	eb 24                	jmp    801058fd <sys_close+0x4f>
  proc->ofile[fd] = 0;
801058d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058e2:	83 c2 08             	add    $0x8,%edx
801058e5:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801058ec:	00 
  fileclose(f);
801058ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058f0:	89 04 24             	mov    %eax,(%esp)
801058f3:	e8 e4 b6 ff ff       	call   80100fdc <fileclose>
  return 0;
801058f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058fd:	c9                   	leave  
801058fe:	c3                   	ret    

801058ff <sys_fstat>:

int
sys_fstat(void)
{
801058ff:	55                   	push   %ebp
80105900:	89 e5                	mov    %esp,%ebp
80105902:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105905:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105908:	89 44 24 08          	mov    %eax,0x8(%esp)
8010590c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105913:	00 
80105914:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010591b:	e8 7e fd ff ff       	call   8010569e <argfd>
80105920:	85 c0                	test   %eax,%eax
80105922:	78 1f                	js     80105943 <sys_fstat+0x44>
80105924:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010592b:	00 
8010592c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010592f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105933:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010593a:	e8 f7 fb ff ff       	call   80105536 <argptr>
8010593f:	85 c0                	test   %eax,%eax
80105941:	79 07                	jns    8010594a <sys_fstat+0x4b>
    return -1;
80105943:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105948:	eb 12                	jmp    8010595c <sys_fstat+0x5d>
  return filestat(f, st);
8010594a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010594d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105950:	89 54 24 04          	mov    %edx,0x4(%esp)
80105954:	89 04 24             	mov    %eax,(%esp)
80105957:	e8 56 b7 ff ff       	call   801010b2 <filestat>
}
8010595c:	c9                   	leave  
8010595d:	c3                   	ret    

8010595e <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010595e:	55                   	push   %ebp
8010595f:	89 e5                	mov    %esp,%ebp
80105961:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105964:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105967:	89 44 24 04          	mov    %eax,0x4(%esp)
8010596b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105972:	e8 21 fc ff ff       	call   80105598 <argstr>
80105977:	85 c0                	test   %eax,%eax
80105979:	78 17                	js     80105992 <sys_link+0x34>
8010597b:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010597e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105982:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105989:	e8 0a fc ff ff       	call   80105598 <argstr>
8010598e:	85 c0                	test   %eax,%eax
80105990:	79 0a                	jns    8010599c <sys_link+0x3e>
    return -1;
80105992:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105997:	e9 3d 01 00 00       	jmp    80105ad9 <sys_link+0x17b>
  if((ip = namei(old)) == 0)
8010599c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010599f:	89 04 24             	mov    %eax,(%esp)
801059a2:	e8 6d ca ff ff       	call   80102414 <namei>
801059a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059ae:	75 0a                	jne    801059ba <sys_link+0x5c>
    return -1;
801059b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059b5:	e9 1f 01 00 00       	jmp    80105ad9 <sys_link+0x17b>

  begin_trans();
801059ba:	e8 34 d8 ff ff       	call   801031f3 <begin_trans>

  ilock(ip);
801059bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c2:	89 04 24             	mov    %eax,(%esp)
801059c5:	e8 9f be ff ff       	call   80101869 <ilock>
  if(ip->type == T_DIR){
801059ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059cd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801059d1:	66 83 f8 01          	cmp    $0x1,%ax
801059d5:	75 1a                	jne    801059f1 <sys_link+0x93>
    iunlockput(ip);
801059d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059da:	89 04 24             	mov    %eax,(%esp)
801059dd:	e8 0b c1 ff ff       	call   80101aed <iunlockput>
    commit_trans();
801059e2:	e8 55 d8 ff ff       	call   8010323c <commit_trans>
    return -1;
801059e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ec:	e9 e8 00 00 00       	jmp    80105ad9 <sys_link+0x17b>
  }

  ip->nlink++;
801059f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801059f8:	8d 50 01             	lea    0x1(%eax),%edx
801059fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059fe:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a05:	89 04 24             	mov    %eax,(%esp)
80105a08:	e8 a0 bc ff ff       	call   801016ad <iupdate>
  iunlock(ip);
80105a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a10:	89 04 24             	mov    %eax,(%esp)
80105a13:	e8 9f bf ff ff       	call   801019b7 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105a18:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a1b:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105a1e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a22:	89 04 24             	mov    %eax,(%esp)
80105a25:	e8 0c ca ff ff       	call   80102436 <nameiparent>
80105a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a31:	75 02                	jne    80105a35 <sys_link+0xd7>
    goto bad;
80105a33:	eb 68                	jmp    80105a9d <sys_link+0x13f>
  ilock(dp);
80105a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a38:	89 04 24             	mov    %eax,(%esp)
80105a3b:	e8 29 be ff ff       	call   80101869 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a43:	8b 10                	mov    (%eax),%edx
80105a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a48:	8b 00                	mov    (%eax),%eax
80105a4a:	39 c2                	cmp    %eax,%edx
80105a4c:	75 20                	jne    80105a6e <sys_link+0x110>
80105a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a51:	8b 40 04             	mov    0x4(%eax),%eax
80105a54:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a58:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a62:	89 04 24             	mov    %eax,(%esp)
80105a65:	e8 ea c6 ff ff       	call   80102154 <dirlink>
80105a6a:	85 c0                	test   %eax,%eax
80105a6c:	79 0d                	jns    80105a7b <sys_link+0x11d>
    iunlockput(dp);
80105a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a71:	89 04 24             	mov    %eax,(%esp)
80105a74:	e8 74 c0 ff ff       	call   80101aed <iunlockput>
    goto bad;
80105a79:	eb 22                	jmp    80105a9d <sys_link+0x13f>
  }
  iunlockput(dp);
80105a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a7e:	89 04 24             	mov    %eax,(%esp)
80105a81:	e8 67 c0 ff ff       	call   80101aed <iunlockput>
  iput(ip);
80105a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a89:	89 04 24             	mov    %eax,(%esp)
80105a8c:	e8 8b bf ff ff       	call   80101a1c <iput>

  commit_trans();
80105a91:	e8 a6 d7 ff ff       	call   8010323c <commit_trans>

  return 0;
80105a96:	b8 00 00 00 00       	mov    $0x0,%eax
80105a9b:	eb 3c                	jmp    80105ad9 <sys_link+0x17b>

bad:
  ilock(ip);
80105a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa0:	89 04 24             	mov    %eax,(%esp)
80105aa3:	e8 c1 bd ff ff       	call   80101869 <ilock>
  ip->nlink--;
80105aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aab:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105aaf:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab5:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105abc:	89 04 24             	mov    %eax,(%esp)
80105abf:	e8 e9 bb ff ff       	call   801016ad <iupdate>
  iunlockput(ip);
80105ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac7:	89 04 24             	mov    %eax,(%esp)
80105aca:	e8 1e c0 ff ff       	call   80101aed <iunlockput>
  commit_trans();
80105acf:	e8 68 d7 ff ff       	call   8010323c <commit_trans>
  return -1;
80105ad4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ad9:	c9                   	leave  
80105ada:	c3                   	ret    

80105adb <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105adb:	55                   	push   %ebp
80105adc:	89 e5                	mov    %esp,%ebp
80105ade:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ae1:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105ae8:	eb 4b                	jmp    80105b35 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aed:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105af4:	00 
80105af5:	89 44 24 08          	mov    %eax,0x8(%esp)
80105af9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105afc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b00:	8b 45 08             	mov    0x8(%ebp),%eax
80105b03:	89 04 24             	mov    %eax,(%esp)
80105b06:	e8 6b c2 ff ff       	call   80101d76 <readi>
80105b0b:	83 f8 10             	cmp    $0x10,%eax
80105b0e:	74 0c                	je     80105b1c <isdirempty+0x41>
      panic("isdirempty: readi");
80105b10:	c7 04 24 af 90 10 80 	movl   $0x801090af,(%esp)
80105b17:	e8 1e aa ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80105b1c:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105b20:	66 85 c0             	test   %ax,%ax
80105b23:	74 07                	je     80105b2c <isdirempty+0x51>
      return 0;
80105b25:	b8 00 00 00 00       	mov    $0x0,%eax
80105b2a:	eb 1b                	jmp    80105b47 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b2f:	83 c0 10             	add    $0x10,%eax
80105b32:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b38:	8b 45 08             	mov    0x8(%ebp),%eax
80105b3b:	8b 40 18             	mov    0x18(%eax),%eax
80105b3e:	39 c2                	cmp    %eax,%edx
80105b40:	72 a8                	jb     80105aea <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105b42:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b47:	c9                   	leave  
80105b48:	c3                   	ret    

80105b49 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b49:	55                   	push   %ebp
80105b4a:	89 e5                	mov    %esp,%ebp
80105b4c:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b4f:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105b52:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b5d:	e8 36 fa ff ff       	call   80105598 <argstr>
80105b62:	85 c0                	test   %eax,%eax
80105b64:	79 0a                	jns    80105b70 <sys_unlink+0x27>
    return -1;
80105b66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6b:	e9 aa 01 00 00       	jmp    80105d1a <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
80105b70:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105b73:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105b76:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b7a:	89 04 24             	mov    %eax,(%esp)
80105b7d:	e8 b4 c8 ff ff       	call   80102436 <nameiparent>
80105b82:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b89:	75 0a                	jne    80105b95 <sys_unlink+0x4c>
    return -1;
80105b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b90:	e9 85 01 00 00       	jmp    80105d1a <sys_unlink+0x1d1>

  begin_trans();
80105b95:	e8 59 d6 ff ff       	call   801031f3 <begin_trans>

  ilock(dp);
80105b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b9d:	89 04 24             	mov    %eax,(%esp)
80105ba0:	e8 c4 bc ff ff       	call   80101869 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105ba5:	c7 44 24 04 c1 90 10 	movl   $0x801090c1,0x4(%esp)
80105bac:	80 
80105bad:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105bb0:	89 04 24             	mov    %eax,(%esp)
80105bb3:	e8 b1 c4 ff ff       	call   80102069 <namecmp>
80105bb8:	85 c0                	test   %eax,%eax
80105bba:	0f 84 45 01 00 00    	je     80105d05 <sys_unlink+0x1bc>
80105bc0:	c7 44 24 04 c3 90 10 	movl   $0x801090c3,0x4(%esp)
80105bc7:	80 
80105bc8:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105bcb:	89 04 24             	mov    %eax,(%esp)
80105bce:	e8 96 c4 ff ff       	call   80102069 <namecmp>
80105bd3:	85 c0                	test   %eax,%eax
80105bd5:	0f 84 2a 01 00 00    	je     80105d05 <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105bdb:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105bde:	89 44 24 08          	mov    %eax,0x8(%esp)
80105be2:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105be5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bec:	89 04 24             	mov    %eax,(%esp)
80105bef:	e8 97 c4 ff ff       	call   8010208b <dirlookup>
80105bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105bf7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105bfb:	75 05                	jne    80105c02 <sys_unlink+0xb9>
    goto bad;
80105bfd:	e9 03 01 00 00       	jmp    80105d05 <sys_unlink+0x1bc>
  ilock(ip);
80105c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c05:	89 04 24             	mov    %eax,(%esp)
80105c08:	e8 5c bc ff ff       	call   80101869 <ilock>

  if(ip->nlink < 1)
80105c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c10:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c14:	66 85 c0             	test   %ax,%ax
80105c17:	7f 0c                	jg     80105c25 <sys_unlink+0xdc>
    panic("unlink: nlink < 1");
80105c19:	c7 04 24 c6 90 10 80 	movl   $0x801090c6,(%esp)
80105c20:	e8 15 a9 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c28:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c2c:	66 83 f8 01          	cmp    $0x1,%ax
80105c30:	75 1f                	jne    80105c51 <sys_unlink+0x108>
80105c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c35:	89 04 24             	mov    %eax,(%esp)
80105c38:	e8 9e fe ff ff       	call   80105adb <isdirempty>
80105c3d:	85 c0                	test   %eax,%eax
80105c3f:	75 10                	jne    80105c51 <sys_unlink+0x108>
    iunlockput(ip);
80105c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c44:	89 04 24             	mov    %eax,(%esp)
80105c47:	e8 a1 be ff ff       	call   80101aed <iunlockput>
    goto bad;
80105c4c:	e9 b4 00 00 00       	jmp    80105d05 <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
80105c51:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105c58:	00 
80105c59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c60:	00 
80105c61:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c64:	89 04 24             	mov    %eax,(%esp)
80105c67:	e8 5c f5 ff ff       	call   801051c8 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c6c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105c6f:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105c76:	00 
80105c77:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c7b:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c85:	89 04 24             	mov    %eax,(%esp)
80105c88:	e8 4d c2 ff ff       	call   80101eda <writei>
80105c8d:	83 f8 10             	cmp    $0x10,%eax
80105c90:	74 0c                	je     80105c9e <sys_unlink+0x155>
    panic("unlink: writei");
80105c92:	c7 04 24 d8 90 10 80 	movl   $0x801090d8,(%esp)
80105c99:	e8 9c a8 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80105c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ca5:	66 83 f8 01          	cmp    $0x1,%ax
80105ca9:	75 1c                	jne    80105cc7 <sys_unlink+0x17e>
    dp->nlink--;
80105cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cae:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105cb2:	8d 50 ff             	lea    -0x1(%eax),%edx
80105cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb8:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cbf:	89 04 24             	mov    %eax,(%esp)
80105cc2:	e8 e6 b9 ff ff       	call   801016ad <iupdate>
  }
  iunlockput(dp);
80105cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cca:	89 04 24             	mov    %eax,(%esp)
80105ccd:	e8 1b be ff ff       	call   80101aed <iunlockput>

  ip->nlink--;
80105cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cd5:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105cd9:	8d 50 ff             	lea    -0x1(%eax),%edx
80105cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cdf:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ce6:	89 04 24             	mov    %eax,(%esp)
80105ce9:	e8 bf b9 ff ff       	call   801016ad <iupdate>
  iunlockput(ip);
80105cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf1:	89 04 24             	mov    %eax,(%esp)
80105cf4:	e8 f4 bd ff ff       	call   80101aed <iunlockput>

  commit_trans();
80105cf9:	e8 3e d5 ff ff       	call   8010323c <commit_trans>

  return 0;
80105cfe:	b8 00 00 00 00       	mov    $0x0,%eax
80105d03:	eb 15                	jmp    80105d1a <sys_unlink+0x1d1>

bad:
  iunlockput(dp);
80105d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d08:	89 04 24             	mov    %eax,(%esp)
80105d0b:	e8 dd bd ff ff       	call   80101aed <iunlockput>
  commit_trans();
80105d10:	e8 27 d5 ff ff       	call   8010323c <commit_trans>
  return -1;
80105d15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d1a:	c9                   	leave  
80105d1b:	c3                   	ret    

80105d1c <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105d1c:	55                   	push   %ebp
80105d1d:	89 e5                	mov    %esp,%ebp
80105d1f:	83 ec 48             	sub    $0x48,%esp
80105d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105d25:	8b 55 10             	mov    0x10(%ebp),%edx
80105d28:	8b 45 14             	mov    0x14(%ebp),%eax
80105d2b:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105d2f:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105d33:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d37:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d3e:	8b 45 08             	mov    0x8(%ebp),%eax
80105d41:	89 04 24             	mov    %eax,(%esp)
80105d44:	e8 ed c6 ff ff       	call   80102436 <nameiparent>
80105d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d50:	75 0a                	jne    80105d5c <create+0x40>
    return 0;
80105d52:	b8 00 00 00 00       	mov    $0x0,%eax
80105d57:	e9 7e 01 00 00       	jmp    80105eda <create+0x1be>
  ilock(dp);
80105d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d5f:	89 04 24             	mov    %eax,(%esp)
80105d62:	e8 02 bb ff ff       	call   80101869 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105d67:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d6a:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d6e:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d71:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d78:	89 04 24             	mov    %eax,(%esp)
80105d7b:	e8 0b c3 ff ff       	call   8010208b <dirlookup>
80105d80:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d87:	74 47                	je     80105dd0 <create+0xb4>
    iunlockput(dp);
80105d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d8c:	89 04 24             	mov    %eax,(%esp)
80105d8f:	e8 59 bd ff ff       	call   80101aed <iunlockput>
    ilock(ip);
80105d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d97:	89 04 24             	mov    %eax,(%esp)
80105d9a:	e8 ca ba ff ff       	call   80101869 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105d9f:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105da4:	75 15                	jne    80105dbb <create+0x9f>
80105da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105dad:	66 83 f8 02          	cmp    $0x2,%ax
80105db1:	75 08                	jne    80105dbb <create+0x9f>
      return ip;
80105db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db6:	e9 1f 01 00 00       	jmp    80105eda <create+0x1be>
    iunlockput(ip);
80105dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dbe:	89 04 24             	mov    %eax,(%esp)
80105dc1:	e8 27 bd ff ff       	call   80101aed <iunlockput>
    return 0;
80105dc6:	b8 00 00 00 00       	mov    $0x0,%eax
80105dcb:	e9 0a 01 00 00       	jmp    80105eda <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105dd0:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd7:	8b 00                	mov    (%eax),%eax
80105dd9:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ddd:	89 04 24             	mov    %eax,(%esp)
80105de0:	e8 e9 b7 ff ff       	call   801015ce <ialloc>
80105de5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105de8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105dec:	75 0c                	jne    80105dfa <create+0xde>
    panic("create: ialloc");
80105dee:	c7 04 24 e7 90 10 80 	movl   $0x801090e7,(%esp)
80105df5:	e8 40 a7 ff ff       	call   8010053a <panic>

  ilock(ip);
80105dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dfd:	89 04 24             	mov    %eax,(%esp)
80105e00:	e8 64 ba ff ff       	call   80101869 <ilock>
  ip->major = major;
80105e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e08:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105e0c:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e13:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105e17:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e1e:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e27:	89 04 24             	mov    %eax,(%esp)
80105e2a:	e8 7e b8 ff ff       	call   801016ad <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105e2f:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105e34:	75 6a                	jne    80105ea0 <create+0x184>
    dp->nlink++;  // for ".."
80105e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e39:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e3d:	8d 50 01             	lea    0x1(%eax),%edx
80105e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e43:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e4a:	89 04 24             	mov    %eax,(%esp)
80105e4d:	e8 5b b8 ff ff       	call   801016ad <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e55:	8b 40 04             	mov    0x4(%eax),%eax
80105e58:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e5c:	c7 44 24 04 c1 90 10 	movl   $0x801090c1,0x4(%esp)
80105e63:	80 
80105e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e67:	89 04 24             	mov    %eax,(%esp)
80105e6a:	e8 e5 c2 ff ff       	call   80102154 <dirlink>
80105e6f:	85 c0                	test   %eax,%eax
80105e71:	78 21                	js     80105e94 <create+0x178>
80105e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e76:	8b 40 04             	mov    0x4(%eax),%eax
80105e79:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e7d:	c7 44 24 04 c3 90 10 	movl   $0x801090c3,0x4(%esp)
80105e84:	80 
80105e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e88:	89 04 24             	mov    %eax,(%esp)
80105e8b:	e8 c4 c2 ff ff       	call   80102154 <dirlink>
80105e90:	85 c0                	test   %eax,%eax
80105e92:	79 0c                	jns    80105ea0 <create+0x184>
      panic("create dots");
80105e94:	c7 04 24 f6 90 10 80 	movl   $0x801090f6,(%esp)
80105e9b:	e8 9a a6 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea3:	8b 40 04             	mov    0x4(%eax),%eax
80105ea6:	89 44 24 08          	mov    %eax,0x8(%esp)
80105eaa:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ead:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb4:	89 04 24             	mov    %eax,(%esp)
80105eb7:	e8 98 c2 ff ff       	call   80102154 <dirlink>
80105ebc:	85 c0                	test   %eax,%eax
80105ebe:	79 0c                	jns    80105ecc <create+0x1b0>
    panic("create: dirlink");
80105ec0:	c7 04 24 02 91 10 80 	movl   $0x80109102,(%esp)
80105ec7:	e8 6e a6 ff ff       	call   8010053a <panic>

  iunlockput(dp);
80105ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ecf:	89 04 24             	mov    %eax,(%esp)
80105ed2:	e8 16 bc ff ff       	call   80101aed <iunlockput>

  return ip;
80105ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105eda:	c9                   	leave  
80105edb:	c3                   	ret    

80105edc <sys_open>:

int
sys_open(void)
{
80105edc:	55                   	push   %ebp
80105edd:	89 e5                	mov    %esp,%ebp
80105edf:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ee2:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105ee5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ee9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ef0:	e8 a3 f6 ff ff       	call   80105598 <argstr>
80105ef5:	85 c0                	test   %eax,%eax
80105ef7:	78 17                	js     80105f10 <sys_open+0x34>
80105ef9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105efc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f07:	e8 f2 f5 ff ff       	call   801054fe <argint>
80105f0c:	85 c0                	test   %eax,%eax
80105f0e:	79 0a                	jns    80105f1a <sys_open+0x3e>
    return -1;
80105f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f15:	e9 48 01 00 00       	jmp    80106062 <sys_open+0x186>
  if(omode & O_CREATE){
80105f1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f1d:	25 00 02 00 00       	and    $0x200,%eax
80105f22:	85 c0                	test   %eax,%eax
80105f24:	74 40                	je     80105f66 <sys_open+0x8a>
    begin_trans();
80105f26:	e8 c8 d2 ff ff       	call   801031f3 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105f2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f2e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105f35:	00 
80105f36:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105f3d:	00 
80105f3e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105f45:	00 
80105f46:	89 04 24             	mov    %eax,(%esp)
80105f49:	e8 ce fd ff ff       	call   80105d1c <create>
80105f4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105f51:	e8 e6 d2 ff ff       	call   8010323c <commit_trans>
    if(ip == 0)
80105f56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f5a:	75 5c                	jne    80105fb8 <sys_open+0xdc>
      return -1;
80105f5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f61:	e9 fc 00 00 00       	jmp    80106062 <sys_open+0x186>
  } else {
    if((ip = namei(path)) == 0)
80105f66:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f69:	89 04 24             	mov    %eax,(%esp)
80105f6c:	e8 a3 c4 ff ff       	call   80102414 <namei>
80105f71:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f78:	75 0a                	jne    80105f84 <sys_open+0xa8>
      return -1;
80105f7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f7f:	e9 de 00 00 00       	jmp    80106062 <sys_open+0x186>
    ilock(ip);
80105f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f87:	89 04 24             	mov    %eax,(%esp)
80105f8a:	e8 da b8 ff ff       	call   80101869 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f92:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f96:	66 83 f8 01          	cmp    $0x1,%ax
80105f9a:	75 1c                	jne    80105fb8 <sys_open+0xdc>
80105f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f9f:	85 c0                	test   %eax,%eax
80105fa1:	74 15                	je     80105fb8 <sys_open+0xdc>
      iunlockput(ip);
80105fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fa6:	89 04 24             	mov    %eax,(%esp)
80105fa9:	e8 3f bb ff ff       	call   80101aed <iunlockput>
      return -1;
80105fae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb3:	e9 aa 00 00 00       	jmp    80106062 <sys_open+0x186>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105fb8:	e8 77 af ff ff       	call   80100f34 <filealloc>
80105fbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fc4:	74 14                	je     80105fda <sys_open+0xfe>
80105fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc9:	89 04 24             	mov    %eax,(%esp)
80105fcc:	e8 42 f7 ff ff       	call   80105713 <fdalloc>
80105fd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105fd4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105fd8:	79 23                	jns    80105ffd <sys_open+0x121>
    if(f)
80105fda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fde:	74 0b                	je     80105feb <sys_open+0x10f>
      fileclose(f);
80105fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe3:	89 04 24             	mov    %eax,(%esp)
80105fe6:	e8 f1 af ff ff       	call   80100fdc <fileclose>
    iunlockput(ip);
80105feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fee:	89 04 24             	mov    %eax,(%esp)
80105ff1:	e8 f7 ba ff ff       	call   80101aed <iunlockput>
    return -1;
80105ff6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ffb:	eb 65                	jmp    80106062 <sys_open+0x186>
  }
  iunlock(ip);
80105ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106000:	89 04 24             	mov    %eax,(%esp)
80106003:	e8 af b9 ff ff       	call   801019b7 <iunlock>

  f->type = FD_INODE;
80106008:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010600b:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106011:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106014:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106017:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010601a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010601d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106024:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106027:	83 e0 01             	and    $0x1,%eax
8010602a:	85 c0                	test   %eax,%eax
8010602c:	0f 94 c0             	sete   %al
8010602f:	89 c2                	mov    %eax,%edx
80106031:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106034:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106037:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010603a:	83 e0 01             	and    $0x1,%eax
8010603d:	85 c0                	test   %eax,%eax
8010603f:	75 0a                	jne    8010604b <sys_open+0x16f>
80106041:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106044:	83 e0 02             	and    $0x2,%eax
80106047:	85 c0                	test   %eax,%eax
80106049:	74 07                	je     80106052 <sys_open+0x176>
8010604b:	b8 01 00 00 00       	mov    $0x1,%eax
80106050:	eb 05                	jmp    80106057 <sys_open+0x17b>
80106052:	b8 00 00 00 00       	mov    $0x0,%eax
80106057:	89 c2                	mov    %eax,%edx
80106059:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010605c:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010605f:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106062:	c9                   	leave  
80106063:	c3                   	ret    

80106064 <sys_mkdir>:

int
sys_mkdir(void)
{
80106064:	55                   	push   %ebp
80106065:	89 e5                	mov    %esp,%ebp
80106067:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
8010606a:	e8 84 d1 ff ff       	call   801031f3 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010606f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106072:	89 44 24 04          	mov    %eax,0x4(%esp)
80106076:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010607d:	e8 16 f5 ff ff       	call   80105598 <argstr>
80106082:	85 c0                	test   %eax,%eax
80106084:	78 2c                	js     801060b2 <sys_mkdir+0x4e>
80106086:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106089:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106090:	00 
80106091:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106098:	00 
80106099:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801060a0:	00 
801060a1:	89 04 24             	mov    %eax,(%esp)
801060a4:	e8 73 fc ff ff       	call   80105d1c <create>
801060a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060b0:	75 0c                	jne    801060be <sys_mkdir+0x5a>
    commit_trans();
801060b2:	e8 85 d1 ff ff       	call   8010323c <commit_trans>
    return -1;
801060b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060bc:	eb 15                	jmp    801060d3 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801060be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c1:	89 04 24             	mov    %eax,(%esp)
801060c4:	e8 24 ba ff ff       	call   80101aed <iunlockput>
  commit_trans();
801060c9:	e8 6e d1 ff ff       	call   8010323c <commit_trans>
  return 0;
801060ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060d3:	c9                   	leave  
801060d4:	c3                   	ret    

801060d5 <sys_mknod>:

int
sys_mknod(void)
{
801060d5:	55                   	push   %ebp
801060d6:	89 e5                	mov    %esp,%ebp
801060d8:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
801060db:	e8 13 d1 ff ff       	call   801031f3 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
801060e0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801060e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060ee:	e8 a5 f4 ff ff       	call   80105598 <argstr>
801060f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060fa:	78 5e                	js     8010615a <sys_mknod+0x85>
     argint(1, &major) < 0 ||
801060fc:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80106103:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010610a:	e8 ef f3 ff ff       	call   801054fe <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
8010610f:	85 c0                	test   %eax,%eax
80106111:	78 47                	js     8010615a <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106113:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106116:	89 44 24 04          	mov    %eax,0x4(%esp)
8010611a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106121:	e8 d8 f3 ff ff       	call   801054fe <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106126:	85 c0                	test   %eax,%eax
80106128:	78 30                	js     8010615a <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010612a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010612d:	0f bf c8             	movswl %ax,%ecx
80106130:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106133:	0f bf d0             	movswl %ax,%edx
80106136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106139:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010613d:	89 54 24 08          	mov    %edx,0x8(%esp)
80106141:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106148:	00 
80106149:	89 04 24             	mov    %eax,(%esp)
8010614c:	e8 cb fb ff ff       	call   80105d1c <create>
80106151:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106154:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106158:	75 0c                	jne    80106166 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
8010615a:	e8 dd d0 ff ff       	call   8010323c <commit_trans>
    return -1;
8010615f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106164:	eb 15                	jmp    8010617b <sys_mknod+0xa6>
  }
  iunlockput(ip);
80106166:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106169:	89 04 24             	mov    %eax,(%esp)
8010616c:	e8 7c b9 ff ff       	call   80101aed <iunlockput>
  commit_trans();
80106171:	e8 c6 d0 ff ff       	call   8010323c <commit_trans>
  return 0;
80106176:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010617b:	c9                   	leave  
8010617c:	c3                   	ret    

8010617d <sys_chdir>:

int
sys_chdir(void)
{
8010617d:	55                   	push   %ebp
8010617e:	89 e5                	mov    %esp,%ebp
80106180:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80106183:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106186:	89 44 24 04          	mov    %eax,0x4(%esp)
8010618a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106191:	e8 02 f4 ff ff       	call   80105598 <argstr>
80106196:	85 c0                	test   %eax,%eax
80106198:	78 14                	js     801061ae <sys_chdir+0x31>
8010619a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010619d:	89 04 24             	mov    %eax,(%esp)
801061a0:	e8 6f c2 ff ff       	call   80102414 <namei>
801061a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061ac:	75 07                	jne    801061b5 <sys_chdir+0x38>
    return -1;
801061ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061b3:	eb 57                	jmp    8010620c <sys_chdir+0x8f>
  ilock(ip);
801061b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b8:	89 04 24             	mov    %eax,(%esp)
801061bb:	e8 a9 b6 ff ff       	call   80101869 <ilock>
  if(ip->type != T_DIR){
801061c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801061c7:	66 83 f8 01          	cmp    $0x1,%ax
801061cb:	74 12                	je     801061df <sys_chdir+0x62>
    iunlockput(ip);
801061cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d0:	89 04 24             	mov    %eax,(%esp)
801061d3:	e8 15 b9 ff ff       	call   80101aed <iunlockput>
    return -1;
801061d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061dd:	eb 2d                	jmp    8010620c <sys_chdir+0x8f>
  }
  iunlock(ip);
801061df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e2:	89 04 24             	mov    %eax,(%esp)
801061e5:	e8 cd b7 ff ff       	call   801019b7 <iunlock>
  iput(proc->cwd);
801061ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061f0:	8b 40 68             	mov    0x68(%eax),%eax
801061f3:	89 04 24             	mov    %eax,(%esp)
801061f6:	e8 21 b8 ff ff       	call   80101a1c <iput>
  proc->cwd = ip;
801061fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106201:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106204:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106207:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010620c:	c9                   	leave  
8010620d:	c3                   	ret    

8010620e <sys_exec>:

int
sys_exec(void)
{
8010620e:	55                   	push   %ebp
8010620f:	89 e5                	mov    %esp,%ebp
80106211:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106217:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010621a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010621e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106225:	e8 6e f3 ff ff       	call   80105598 <argstr>
8010622a:	85 c0                	test   %eax,%eax
8010622c:	78 1a                	js     80106248 <sys_exec+0x3a>
8010622e:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106234:	89 44 24 04          	mov    %eax,0x4(%esp)
80106238:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010623f:	e8 ba f2 ff ff       	call   801054fe <argint>
80106244:	85 c0                	test   %eax,%eax
80106246:	79 0a                	jns    80106252 <sys_exec+0x44>
    return -1;
80106248:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010624d:	e9 de 00 00 00       	jmp    80106330 <sys_exec+0x122>
  }
  memset(argv, 0, sizeof(argv));
80106252:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106259:	00 
8010625a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106261:	00 
80106262:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106268:	89 04 24             	mov    %eax,(%esp)
8010626b:	e8 58 ef ff ff       	call   801051c8 <memset>
  for(i=0;; i++){
80106270:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106277:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010627a:	83 f8 1f             	cmp    $0x1f,%eax
8010627d:	76 0a                	jbe    80106289 <sys_exec+0x7b>
      return -1;
8010627f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106284:	e9 a7 00 00 00       	jmp    80106330 <sys_exec+0x122>
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
80106289:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010628c:	c1 e0 02             	shl    $0x2,%eax
8010628f:	89 c2                	mov    %eax,%edx
80106291:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106297:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
8010629a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062a0:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
801062a6:	89 54 24 08          	mov    %edx,0x8(%esp)
801062aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801062ae:	89 04 24             	mov    %eax,(%esp)
801062b1:	e8 b8 f1 ff ff       	call   8010546e <fetchint>
801062b6:	85 c0                	test   %eax,%eax
801062b8:	79 07                	jns    801062c1 <sys_exec+0xb3>
      return -1;
801062ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062bf:	eb 6f                	jmp    80106330 <sys_exec+0x122>
    if(uarg == 0){
801062c1:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801062c7:	85 c0                	test   %eax,%eax
801062c9:	75 26                	jne    801062f1 <sys_exec+0xe3>
      argv[i] = 0;
801062cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ce:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801062d5:	00 00 00 00 
      break;
801062d9:	90                   	nop
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801062da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062dd:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801062e3:	89 54 24 04          	mov    %edx,0x4(%esp)
801062e7:	89 04 24             	mov    %eax,(%esp)
801062ea:	e8 00 a8 ff ff       	call   80100aef <exec>
801062ef:	eb 3f                	jmp    80106330 <sys_exec+0x122>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
801062f1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801062f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062fa:	c1 e2 02             	shl    $0x2,%edx
801062fd:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
80106300:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
80106306:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010630c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106310:	89 54 24 04          	mov    %edx,0x4(%esp)
80106314:	89 04 24             	mov    %eax,(%esp)
80106317:	e8 86 f1 ff ff       	call   801054a2 <fetchstr>
8010631c:	85 c0                	test   %eax,%eax
8010631e:	79 07                	jns    80106327 <sys_exec+0x119>
      return -1;
80106320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106325:	eb 09                	jmp    80106330 <sys_exec+0x122>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106327:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
8010632b:	e9 47 ff ff ff       	jmp    80106277 <sys_exec+0x69>
  return exec(path, argv);
}
80106330:	c9                   	leave  
80106331:	c3                   	ret    

80106332 <sys_pipe>:

int
sys_pipe(void)
{
80106332:	55                   	push   %ebp
80106333:	89 e5                	mov    %esp,%ebp
80106335:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106338:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
8010633f:	00 
80106340:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106343:	89 44 24 04          	mov    %eax,0x4(%esp)
80106347:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010634e:	e8 e3 f1 ff ff       	call   80105536 <argptr>
80106353:	85 c0                	test   %eax,%eax
80106355:	79 0a                	jns    80106361 <sys_pipe+0x2f>
    return -1;
80106357:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010635c:	e9 9b 00 00 00       	jmp    801063fc <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106361:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106364:	89 44 24 04          	mov    %eax,0x4(%esp)
80106368:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010636b:	89 04 24             	mov    %eax,(%esp)
8010636e:	e8 7a d8 ff ff       	call   80103bed <pipealloc>
80106373:	85 c0                	test   %eax,%eax
80106375:	79 07                	jns    8010637e <sys_pipe+0x4c>
    return -1;
80106377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010637c:	eb 7e                	jmp    801063fc <sys_pipe+0xca>
  fd0 = -1;
8010637e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106385:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106388:	89 04 24             	mov    %eax,(%esp)
8010638b:	e8 83 f3 ff ff       	call   80105713 <fdalloc>
80106390:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106397:	78 14                	js     801063ad <sys_pipe+0x7b>
80106399:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010639c:	89 04 24             	mov    %eax,(%esp)
8010639f:	e8 6f f3 ff ff       	call   80105713 <fdalloc>
801063a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063ab:	79 37                	jns    801063e4 <sys_pipe+0xb2>
    if(fd0 >= 0)
801063ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063b1:	78 14                	js     801063c7 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
801063b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063bc:	83 c2 08             	add    $0x8,%edx
801063bf:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801063c6:	00 
    fileclose(rf);
801063c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063ca:	89 04 24             	mov    %eax,(%esp)
801063cd:	e8 0a ac ff ff       	call   80100fdc <fileclose>
    fileclose(wf);
801063d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063d5:	89 04 24             	mov    %eax,(%esp)
801063d8:	e8 ff ab ff ff       	call   80100fdc <fileclose>
    return -1;
801063dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063e2:	eb 18                	jmp    801063fc <sys_pipe+0xca>
  }
  fd[0] = fd0;
801063e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801063e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063ea:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801063ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
801063ef:	8d 50 04             	lea    0x4(%eax),%edx
801063f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063f5:	89 02                	mov    %eax,(%edx)
  return 0;
801063f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063fc:	c9                   	leave  
801063fd:	c3                   	ret    

801063fe <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801063fe:	55                   	push   %ebp
801063ff:	89 e5                	mov    %esp,%ebp
80106401:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106404:	e8 a3 de ff ff       	call   801042ac <fork>
}
80106409:	c9                   	leave  
8010640a:	c3                   	ret    

8010640b <sys_exit>:

int
sys_exit(void)
{
8010640b:	55                   	push   %ebp
8010640c:	89 e5                	mov    %esp,%ebp
8010640e:	83 ec 08             	sub    $0x8,%esp
  exit();
80106411:	e8 f9 df ff ff       	call   8010440f <exit>
  return 0;  // not reached
80106416:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010641b:	c9                   	leave  
8010641c:	c3                   	ret    

8010641d <sys_wait>:

int
sys_wait(void)
{
8010641d:	55                   	push   %ebp
8010641e:	89 e5                	mov    %esp,%ebp
80106420:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106423:	e8 ff e0 ff ff       	call   80104527 <wait>
}
80106428:	c9                   	leave  
80106429:	c3                   	ret    

8010642a <sys_kill>:

int
sys_kill(void)
{
8010642a:	55                   	push   %ebp
8010642b:	89 e5                	mov    %esp,%ebp
8010642d:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106430:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106433:	89 44 24 04          	mov    %eax,0x4(%esp)
80106437:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010643e:	e8 bb f0 ff ff       	call   801054fe <argint>
80106443:	85 c0                	test   %eax,%eax
80106445:	79 07                	jns    8010644e <sys_kill+0x24>
    return -1;
80106447:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010644c:	eb 0b                	jmp    80106459 <sys_kill+0x2f>
  return kill(pid);
8010644e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106451:	89 04 24             	mov    %eax,(%esp)
80106454:	e8 2c e5 ff ff       	call   80104985 <kill>
}
80106459:	c9                   	leave  
8010645a:	c3                   	ret    

8010645b <sys_getpid>:

int
sys_getpid(void)
{
8010645b:	55                   	push   %ebp
8010645c:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010645e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106464:	8b 40 10             	mov    0x10(%eax),%eax
}
80106467:	5d                   	pop    %ebp
80106468:	c3                   	ret    

80106469 <sys_sbrk>:

int
sys_sbrk(void)
{
80106469:	55                   	push   %ebp
8010646a:	89 e5                	mov    %esp,%ebp
8010646c:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010646f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106472:	89 44 24 04          	mov    %eax,0x4(%esp)
80106476:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010647d:	e8 7c f0 ff ff       	call   801054fe <argint>
80106482:	85 c0                	test   %eax,%eax
80106484:	79 07                	jns    8010648d <sys_sbrk+0x24>
    return -1;
80106486:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010648b:	eb 24                	jmp    801064b1 <sys_sbrk+0x48>
  addr = proc->sz;
8010648d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106493:	8b 00                	mov    (%eax),%eax
80106495:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106498:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010649b:	89 04 24             	mov    %eax,(%esp)
8010649e:	e8 64 dd ff ff       	call   80104207 <growproc>
801064a3:	85 c0                	test   %eax,%eax
801064a5:	79 07                	jns    801064ae <sys_sbrk+0x45>
    return -1;
801064a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ac:	eb 03                	jmp    801064b1 <sys_sbrk+0x48>
  return addr;
801064ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801064b1:	c9                   	leave  
801064b2:	c3                   	ret    

801064b3 <sys_sleep>:

int
sys_sleep(void)
{
801064b3:	55                   	push   %ebp
801064b4:	89 e5                	mov    %esp,%ebp
801064b6:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801064b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801064c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064c7:	e8 32 f0 ff ff       	call   801054fe <argint>
801064cc:	85 c0                	test   %eax,%eax
801064ce:	79 07                	jns    801064d7 <sys_sleep+0x24>
    return -1;
801064d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064d5:	eb 6c                	jmp    80106543 <sys_sleep+0x90>
  acquire(&tickslock);
801064d7:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
801064de:	e8 91 ea ff ff       	call   80104f74 <acquire>
  ticks0 = ticks;
801064e3:	a1 c0 36 11 80       	mov    0x801136c0,%eax
801064e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801064eb:	eb 34                	jmp    80106521 <sys_sleep+0x6e>
    if(proc->killed){
801064ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064f3:	8b 40 24             	mov    0x24(%eax),%eax
801064f6:	85 c0                	test   %eax,%eax
801064f8:	74 13                	je     8010650d <sys_sleep+0x5a>
      release(&tickslock);
801064fa:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
80106501:	e8 d0 ea ff ff       	call   80104fd6 <release>
      return -1;
80106506:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010650b:	eb 36                	jmp    80106543 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
8010650d:	c7 44 24 04 80 2e 11 	movl   $0x80112e80,0x4(%esp)
80106514:	80 
80106515:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
8010651c:	e8 60 e3 ff ff       	call   80104881 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106521:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80106526:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106529:	89 c2                	mov    %eax,%edx
8010652b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010652e:	39 c2                	cmp    %eax,%edx
80106530:	72 bb                	jb     801064ed <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106532:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
80106539:	e8 98 ea ff ff       	call   80104fd6 <release>
  return 0;
8010653e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106543:	c9                   	leave  
80106544:	c3                   	ret    

80106545 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106545:	55                   	push   %ebp
80106546:	89 e5                	mov    %esp,%ebp
80106548:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
8010654b:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
80106552:	e8 1d ea ff ff       	call   80104f74 <acquire>
  xticks = ticks;
80106557:	a1 c0 36 11 80       	mov    0x801136c0,%eax
8010655c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010655f:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
80106566:	e8 6b ea ff ff       	call   80104fd6 <release>
  return xticks;
8010656b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010656e:	c9                   	leave  
8010656f:	c3                   	ret    

80106570 <sys_cowfork>:

//3.4
int
sys_cowfork(void)
{
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	83 ec 08             	sub    $0x8,%esp
  return cowfork();
80106576:	e8 3f e8 ff ff       	call   80104dba <cowfork>
}
8010657b:	c9                   	leave  
8010657c:	c3                   	ret    

8010657d <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010657d:	55                   	push   %ebp
8010657e:	89 e5                	mov    %esp,%ebp
80106580:	83 ec 08             	sub    $0x8,%esp
80106583:	8b 55 08             	mov    0x8(%ebp),%edx
80106586:	8b 45 0c             	mov    0xc(%ebp),%eax
80106589:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010658d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106590:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106594:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106598:	ee                   	out    %al,(%dx)
}
80106599:	c9                   	leave  
8010659a:	c3                   	ret    

8010659b <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010659b:	55                   	push   %ebp
8010659c:	89 e5                	mov    %esp,%ebp
8010659e:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801065a1:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801065a8:	00 
801065a9:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801065b0:	e8 c8 ff ff ff       	call   8010657d <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801065b5:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
801065bc:	00 
801065bd:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801065c4:	e8 b4 ff ff ff       	call   8010657d <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801065c9:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
801065d0:	00 
801065d1:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801065d8:	e8 a0 ff ff ff       	call   8010657d <outb>
  picenable(IRQ_TIMER);
801065dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065e4:	e8 97 d4 ff ff       	call   80103a80 <picenable>
}
801065e9:	c9                   	leave  
801065ea:	c3                   	ret    

801065eb <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801065eb:	1e                   	push   %ds
  pushl %es
801065ec:	06                   	push   %es
  pushl %fs
801065ed:	0f a0                	push   %fs
  pushl %gs
801065ef:	0f a8                	push   %gs
  pushal
801065f1:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801065f2:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801065f6:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801065f8:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801065fa:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801065fe:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106600:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106602:	54                   	push   %esp
  call trap
80106603:	e8 d8 01 00 00       	call   801067e0 <trap>
  addl $4, %esp
80106608:	83 c4 04             	add    $0x4,%esp

8010660b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010660b:	61                   	popa   
  popl %gs
8010660c:	0f a9                	pop    %gs
  popl %fs
8010660e:	0f a1                	pop    %fs
  popl %es
80106610:	07                   	pop    %es
  popl %ds
80106611:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106612:	83 c4 08             	add    $0x8,%esp
  iret
80106615:	cf                   	iret   

80106616 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106616:	55                   	push   %ebp
80106617:	89 e5                	mov    %esp,%ebp
80106619:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010661c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010661f:	83 e8 01             	sub    $0x1,%eax
80106622:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106626:	8b 45 08             	mov    0x8(%ebp),%eax
80106629:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010662d:	8b 45 08             	mov    0x8(%ebp),%eax
80106630:	c1 e8 10             	shr    $0x10,%eax
80106633:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106637:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010663a:	0f 01 18             	lidtl  (%eax)
}
8010663d:	c9                   	leave  
8010663e:	c3                   	ret    

8010663f <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010663f:	55                   	push   %ebp
80106640:	89 e5                	mov    %esp,%ebp
80106642:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106645:	0f 20 d0             	mov    %cr2,%eax
80106648:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010664b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010664e:	c9                   	leave  
8010664f:	c3                   	ret    

80106650 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106650:	55                   	push   %ebp
80106651:	89 e5                	mov    %esp,%ebp
80106653:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106656:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010665d:	e9 c3 00 00 00       	jmp    80106725 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106662:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106665:	8b 04 85 9c c0 10 80 	mov    -0x7fef3f64(,%eax,4),%eax
8010666c:	89 c2                	mov    %eax,%edx
8010666e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106671:	66 89 14 c5 c0 2e 11 	mov    %dx,-0x7feed140(,%eax,8)
80106678:	80 
80106679:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010667c:	66 c7 04 c5 c2 2e 11 	movw   $0x8,-0x7feed13e(,%eax,8)
80106683:	80 08 00 
80106686:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106689:	0f b6 14 c5 c4 2e 11 	movzbl -0x7feed13c(,%eax,8),%edx
80106690:	80 
80106691:	83 e2 e0             	and    $0xffffffe0,%edx
80106694:	88 14 c5 c4 2e 11 80 	mov    %dl,-0x7feed13c(,%eax,8)
8010669b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010669e:	0f b6 14 c5 c4 2e 11 	movzbl -0x7feed13c(,%eax,8),%edx
801066a5:	80 
801066a6:	83 e2 1f             	and    $0x1f,%edx
801066a9:	88 14 c5 c4 2e 11 80 	mov    %dl,-0x7feed13c(,%eax,8)
801066b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066b3:	0f b6 14 c5 c5 2e 11 	movzbl -0x7feed13b(,%eax,8),%edx
801066ba:	80 
801066bb:	83 e2 f0             	and    $0xfffffff0,%edx
801066be:	83 ca 0e             	or     $0xe,%edx
801066c1:	88 14 c5 c5 2e 11 80 	mov    %dl,-0x7feed13b(,%eax,8)
801066c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066cb:	0f b6 14 c5 c5 2e 11 	movzbl -0x7feed13b(,%eax,8),%edx
801066d2:	80 
801066d3:	83 e2 ef             	and    $0xffffffef,%edx
801066d6:	88 14 c5 c5 2e 11 80 	mov    %dl,-0x7feed13b(,%eax,8)
801066dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066e0:	0f b6 14 c5 c5 2e 11 	movzbl -0x7feed13b(,%eax,8),%edx
801066e7:	80 
801066e8:	83 e2 9f             	and    $0xffffff9f,%edx
801066eb:	88 14 c5 c5 2e 11 80 	mov    %dl,-0x7feed13b(,%eax,8)
801066f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066f5:	0f b6 14 c5 c5 2e 11 	movzbl -0x7feed13b(,%eax,8),%edx
801066fc:	80 
801066fd:	83 ca 80             	or     $0xffffff80,%edx
80106700:	88 14 c5 c5 2e 11 80 	mov    %dl,-0x7feed13b(,%eax,8)
80106707:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010670a:	8b 04 85 9c c0 10 80 	mov    -0x7fef3f64(,%eax,4),%eax
80106711:	c1 e8 10             	shr    $0x10,%eax
80106714:	89 c2                	mov    %eax,%edx
80106716:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106719:	66 89 14 c5 c6 2e 11 	mov    %dx,-0x7feed13a(,%eax,8)
80106720:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106721:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106725:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010672c:	0f 8e 30 ff ff ff    	jle    80106662 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106732:	a1 9c c1 10 80       	mov    0x8010c19c,%eax
80106737:	66 a3 c0 30 11 80    	mov    %ax,0x801130c0
8010673d:	66 c7 05 c2 30 11 80 	movw   $0x8,0x801130c2
80106744:	08 00 
80106746:	0f b6 05 c4 30 11 80 	movzbl 0x801130c4,%eax
8010674d:	83 e0 e0             	and    $0xffffffe0,%eax
80106750:	a2 c4 30 11 80       	mov    %al,0x801130c4
80106755:	0f b6 05 c4 30 11 80 	movzbl 0x801130c4,%eax
8010675c:	83 e0 1f             	and    $0x1f,%eax
8010675f:	a2 c4 30 11 80       	mov    %al,0x801130c4
80106764:	0f b6 05 c5 30 11 80 	movzbl 0x801130c5,%eax
8010676b:	83 c8 0f             	or     $0xf,%eax
8010676e:	a2 c5 30 11 80       	mov    %al,0x801130c5
80106773:	0f b6 05 c5 30 11 80 	movzbl 0x801130c5,%eax
8010677a:	83 e0 ef             	and    $0xffffffef,%eax
8010677d:	a2 c5 30 11 80       	mov    %al,0x801130c5
80106782:	0f b6 05 c5 30 11 80 	movzbl 0x801130c5,%eax
80106789:	83 c8 60             	or     $0x60,%eax
8010678c:	a2 c5 30 11 80       	mov    %al,0x801130c5
80106791:	0f b6 05 c5 30 11 80 	movzbl 0x801130c5,%eax
80106798:	83 c8 80             	or     $0xffffff80,%eax
8010679b:	a2 c5 30 11 80       	mov    %al,0x801130c5
801067a0:	a1 9c c1 10 80       	mov    0x8010c19c,%eax
801067a5:	c1 e8 10             	shr    $0x10,%eax
801067a8:	66 a3 c6 30 11 80    	mov    %ax,0x801130c6
  
  initlock(&tickslock, "time");
801067ae:	c7 44 24 04 14 91 10 	movl   $0x80109114,0x4(%esp)
801067b5:	80 
801067b6:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
801067bd:	e8 91 e7 ff ff       	call   80104f53 <initlock>
}
801067c2:	c9                   	leave  
801067c3:	c3                   	ret    

801067c4 <idtinit>:

void
idtinit(void)
{
801067c4:	55                   	push   %ebp
801067c5:	89 e5                	mov    %esp,%ebp
801067c7:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801067ca:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801067d1:	00 
801067d2:	c7 04 24 c0 2e 11 80 	movl   $0x80112ec0,(%esp)
801067d9:	e8 38 fe ff ff       	call   80106616 <lidt>
}
801067de:	c9                   	leave  
801067df:	c3                   	ret    

801067e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801067e0:	55                   	push   %ebp
801067e1:	89 e5                	mov    %esp,%ebp
801067e3:	57                   	push   %edi
801067e4:	56                   	push   %esi
801067e5:	53                   	push   %ebx
801067e6:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
801067e9:	8b 45 08             	mov    0x8(%ebp),%eax
801067ec:	8b 40 30             	mov    0x30(%eax),%eax
801067ef:	83 f8 40             	cmp    $0x40,%eax
801067f2:	75 3f                	jne    80106833 <trap+0x53>
    if(proc->killed)
801067f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067fa:	8b 40 24             	mov    0x24(%eax),%eax
801067fd:	85 c0                	test   %eax,%eax
801067ff:	74 05                	je     80106806 <trap+0x26>
      exit();
80106801:	e8 09 dc ff ff       	call   8010440f <exit>
    proc->tf = tf;
80106806:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010680c:	8b 55 08             	mov    0x8(%ebp),%edx
8010680f:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106812:	e8 c4 ed ff ff       	call   801055db <syscall>
    if(proc->killed)
80106817:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010681d:	8b 40 24             	mov    0x24(%eax),%eax
80106820:	85 c0                	test   %eax,%eax
80106822:	74 0a                	je     8010682e <trap+0x4e>
      exit();
80106824:	e8 e6 db ff ff       	call   8010440f <exit>
    return;
80106829:	e9 52 02 00 00       	jmp    80106a80 <trap+0x2a0>
8010682e:	e9 4d 02 00 00       	jmp    80106a80 <trap+0x2a0>
  }

  if( tf->trapno == T_PGFLT ) // 3.4
80106833:	8b 45 08             	mov    0x8(%ebp),%eax
80106836:	8b 40 30             	mov    0x30(%eax),%eax
80106839:	83 f8 0e             	cmp    $0xe,%eax
8010683c:	75 1a                	jne    80106858 <trap+0x78>
  {
	  proc->tf = tf ;
8010683e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106844:	8b 55 08             	mov    0x8(%ebp),%edx
80106847:	89 50 18             	mov    %edx,0x18(%eax)
	  if(handler_pgflt()) {
8010684a:	e8 70 21 00 00       	call   801089bf <handler_pgflt>
8010684f:	85 c0                	test   %eax,%eax
80106851:	74 05                	je     80106858 <trap+0x78>
		  return;
80106853:	e9 28 02 00 00       	jmp    80106a80 <trap+0x2a0>
	  }
  }
  switch(tf->trapno){
80106858:	8b 45 08             	mov    0x8(%ebp),%eax
8010685b:	8b 40 30             	mov    0x30(%eax),%eax
8010685e:	83 e8 20             	sub    $0x20,%eax
80106861:	83 f8 1f             	cmp    $0x1f,%eax
80106864:	0f 87 bc 00 00 00    	ja     80106926 <trap+0x146>
8010686a:	8b 04 85 bc 91 10 80 	mov    -0x7fef6e44(,%eax,4),%eax
80106871:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106873:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106879:	0f b6 00             	movzbl (%eax),%eax
8010687c:	84 c0                	test   %al,%al
8010687e:	75 31                	jne    801068b1 <trap+0xd1>
      acquire(&tickslock);
80106880:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
80106887:	e8 e8 e6 ff ff       	call   80104f74 <acquire>
      ticks++;
8010688c:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80106891:	83 c0 01             	add    $0x1,%eax
80106894:	a3 c0 36 11 80       	mov    %eax,0x801136c0
      wakeup(&ticks);
80106899:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
801068a0:	e8 b5 e0 ff ff       	call   8010495a <wakeup>
      release(&tickslock);
801068a5:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
801068ac:	e8 25 e7 ff ff       	call   80104fd6 <release>
    }
    lapiceoi();
801068b1:	e8 0b c6 ff ff       	call   80102ec1 <lapiceoi>
    break;
801068b6:	e9 41 01 00 00       	jmp    801069fc <trap+0x21c>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801068bb:	e8 2c be ff ff       	call   801026ec <ideintr>
    lapiceoi();
801068c0:	e8 fc c5 ff ff       	call   80102ec1 <lapiceoi>
    break;
801068c5:	e9 32 01 00 00       	jmp    801069fc <trap+0x21c>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801068ca:	e8 de c3 ff ff       	call   80102cad <kbdintr>
    lapiceoi();
801068cf:	e8 ed c5 ff ff       	call   80102ec1 <lapiceoi>
    break;
801068d4:	e9 23 01 00 00       	jmp    801069fc <trap+0x21c>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801068d9:	e8 97 03 00 00       	call   80106c75 <uartintr>
    lapiceoi();
801068de:	e8 de c5 ff ff       	call   80102ec1 <lapiceoi>
    break;
801068e3:	e9 14 01 00 00       	jmp    801069fc <trap+0x21c>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801068e8:	8b 45 08             	mov    0x8(%ebp),%eax
801068eb:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801068ee:	8b 45 08             	mov    0x8(%ebp),%eax
801068f1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801068f5:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801068f8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801068fe:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106901:	0f b6 c0             	movzbl %al,%eax
80106904:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106908:	89 54 24 08          	mov    %edx,0x8(%esp)
8010690c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106910:	c7 04 24 1c 91 10 80 	movl   $0x8010911c,(%esp)
80106917:	e8 84 9a ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
8010691c:	e8 a0 c5 ff ff       	call   80102ec1 <lapiceoi>
    break;
80106921:	e9 d6 00 00 00       	jmp    801069fc <trap+0x21c>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106926:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010692c:	85 c0                	test   %eax,%eax
8010692e:	74 11                	je     80106941 <trap+0x161>
80106930:	8b 45 08             	mov    0x8(%ebp),%eax
80106933:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106937:	0f b7 c0             	movzwl %ax,%eax
8010693a:	83 e0 03             	and    $0x3,%eax
8010693d:	85 c0                	test   %eax,%eax
8010693f:	75 46                	jne    80106987 <trap+0x1a7>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106941:	e8 f9 fc ff ff       	call   8010663f <rcr2>
80106946:	8b 55 08             	mov    0x8(%ebp),%edx
80106949:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010694c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106953:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106956:	0f b6 ca             	movzbl %dl,%ecx
80106959:	8b 55 08             	mov    0x8(%ebp),%edx
8010695c:	8b 52 30             	mov    0x30(%edx),%edx
8010695f:	89 44 24 10          	mov    %eax,0x10(%esp)
80106963:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106967:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010696b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010696f:	c7 04 24 40 91 10 80 	movl   $0x80109140,(%esp)
80106976:	e8 25 9a ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
8010697b:	c7 04 24 72 91 10 80 	movl   $0x80109172,(%esp)
80106982:	e8 b3 9b ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106987:	e8 b3 fc ff ff       	call   8010663f <rcr2>
8010698c:	89 c2                	mov    %eax,%edx
8010698e:	8b 45 08             	mov    0x8(%ebp),%eax
80106991:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106994:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010699a:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010699d:	0f b6 f0             	movzbl %al,%esi
801069a0:	8b 45 08             	mov    0x8(%ebp),%eax
801069a3:	8b 58 34             	mov    0x34(%eax),%ebx
801069a6:	8b 45 08             	mov    0x8(%ebp),%eax
801069a9:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801069ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069b2:	83 c0 6c             	add    $0x6c,%eax
801069b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069be:	8b 40 10             	mov    0x10(%eax),%eax
801069c1:	89 54 24 1c          	mov    %edx,0x1c(%esp)
801069c5:	89 7c 24 18          	mov    %edi,0x18(%esp)
801069c9:	89 74 24 14          	mov    %esi,0x14(%esp)
801069cd:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801069d1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801069d5:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801069d8:	89 74 24 08          	mov    %esi,0x8(%esp)
801069dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801069e0:	c7 04 24 78 91 10 80 	movl   $0x80109178,(%esp)
801069e7:	e8 b4 99 ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801069ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069f2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801069f9:	eb 01                	jmp    801069fc <trap+0x21c>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801069fb:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801069fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a02:	85 c0                	test   %eax,%eax
80106a04:	74 24                	je     80106a2a <trap+0x24a>
80106a06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a0c:	8b 40 24             	mov    0x24(%eax),%eax
80106a0f:	85 c0                	test   %eax,%eax
80106a11:	74 17                	je     80106a2a <trap+0x24a>
80106a13:	8b 45 08             	mov    0x8(%ebp),%eax
80106a16:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a1a:	0f b7 c0             	movzwl %ax,%eax
80106a1d:	83 e0 03             	and    $0x3,%eax
80106a20:	83 f8 03             	cmp    $0x3,%eax
80106a23:	75 05                	jne    80106a2a <trap+0x24a>
    exit();
80106a25:	e8 e5 d9 ff ff       	call   8010440f <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106a2a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a30:	85 c0                	test   %eax,%eax
80106a32:	74 1e                	je     80106a52 <trap+0x272>
80106a34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a3a:	8b 40 0c             	mov    0xc(%eax),%eax
80106a3d:	83 f8 04             	cmp    $0x4,%eax
80106a40:	75 10                	jne    80106a52 <trap+0x272>
80106a42:	8b 45 08             	mov    0x8(%ebp),%eax
80106a45:	8b 40 30             	mov    0x30(%eax),%eax
80106a48:	83 f8 20             	cmp    $0x20,%eax
80106a4b:	75 05                	jne    80106a52 <trap+0x272>
    yield();
80106a4d:	e8 d1 dd ff ff       	call   80104823 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106a52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a58:	85 c0                	test   %eax,%eax
80106a5a:	74 24                	je     80106a80 <trap+0x2a0>
80106a5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a62:	8b 40 24             	mov    0x24(%eax),%eax
80106a65:	85 c0                	test   %eax,%eax
80106a67:	74 17                	je     80106a80 <trap+0x2a0>
80106a69:	8b 45 08             	mov    0x8(%ebp),%eax
80106a6c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a70:	0f b7 c0             	movzwl %ax,%eax
80106a73:	83 e0 03             	and    $0x3,%eax
80106a76:	83 f8 03             	cmp    $0x3,%eax
80106a79:	75 05                	jne    80106a80 <trap+0x2a0>
    exit();
80106a7b:	e8 8f d9 ff ff       	call   8010440f <exit>
}
80106a80:	83 c4 3c             	add    $0x3c,%esp
80106a83:	5b                   	pop    %ebx
80106a84:	5e                   	pop    %esi
80106a85:	5f                   	pop    %edi
80106a86:	5d                   	pop    %ebp
80106a87:	c3                   	ret    

80106a88 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106a88:	55                   	push   %ebp
80106a89:	89 e5                	mov    %esp,%ebp
80106a8b:	83 ec 14             	sub    $0x14,%esp
80106a8e:	8b 45 08             	mov    0x8(%ebp),%eax
80106a91:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a95:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106a99:	89 c2                	mov    %eax,%edx
80106a9b:	ec                   	in     (%dx),%al
80106a9c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106a9f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106aa3:	c9                   	leave  
80106aa4:	c3                   	ret    

80106aa5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106aa5:	55                   	push   %ebp
80106aa6:	89 e5                	mov    %esp,%ebp
80106aa8:	83 ec 08             	sub    $0x8,%esp
80106aab:	8b 55 08             	mov    0x8(%ebp),%edx
80106aae:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ab1:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106ab5:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106ab8:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106abc:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106ac0:	ee                   	out    %al,(%dx)
}
80106ac1:	c9                   	leave  
80106ac2:	c3                   	ret    

80106ac3 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106ac3:	55                   	push   %ebp
80106ac4:	89 e5                	mov    %esp,%ebp
80106ac6:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106ac9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ad0:	00 
80106ad1:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106ad8:	e8 c8 ff ff ff       	call   80106aa5 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106add:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106ae4:	00 
80106ae5:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106aec:	e8 b4 ff ff ff       	call   80106aa5 <outb>
  outb(COM1+0, 115200/9600);
80106af1:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106af8:	00 
80106af9:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b00:	e8 a0 ff ff ff       	call   80106aa5 <outb>
  outb(COM1+1, 0);
80106b05:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b0c:	00 
80106b0d:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106b14:	e8 8c ff ff ff       	call   80106aa5 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106b19:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106b20:	00 
80106b21:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106b28:	e8 78 ff ff ff       	call   80106aa5 <outb>
  outb(COM1+4, 0);
80106b2d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b34:	00 
80106b35:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106b3c:	e8 64 ff ff ff       	call   80106aa5 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106b41:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106b48:	00 
80106b49:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106b50:	e8 50 ff ff ff       	call   80106aa5 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106b55:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106b5c:	e8 27 ff ff ff       	call   80106a88 <inb>
80106b61:	3c ff                	cmp    $0xff,%al
80106b63:	75 02                	jne    80106b67 <uartinit+0xa4>
    return;
80106b65:	eb 6a                	jmp    80106bd1 <uartinit+0x10e>
  uart = 1;
80106b67:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80106b6e:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106b71:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106b78:	e8 0b ff ff ff       	call   80106a88 <inb>
  inb(COM1+0);
80106b7d:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b84:	e8 ff fe ff ff       	call   80106a88 <inb>
  picenable(IRQ_COM1);
80106b89:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106b90:	e8 eb ce ff ff       	call   80103a80 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106b95:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b9c:	00 
80106b9d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106ba4:	e8 c2 bd ff ff       	call   8010296b <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106ba9:	c7 45 f4 3c 92 10 80 	movl   $0x8010923c,-0xc(%ebp)
80106bb0:	eb 15                	jmp    80106bc7 <uartinit+0x104>
    uartputc(*p);
80106bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bb5:	0f b6 00             	movzbl (%eax),%eax
80106bb8:	0f be c0             	movsbl %al,%eax
80106bbb:	89 04 24             	mov    %eax,(%esp)
80106bbe:	e8 10 00 00 00       	call   80106bd3 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106bc3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bca:	0f b6 00             	movzbl (%eax),%eax
80106bcd:	84 c0                	test   %al,%al
80106bcf:	75 e1                	jne    80106bb2 <uartinit+0xef>
    uartputc(*p);
}
80106bd1:	c9                   	leave  
80106bd2:	c3                   	ret    

80106bd3 <uartputc>:

void
uartputc(int c)
{
80106bd3:	55                   	push   %ebp
80106bd4:	89 e5                	mov    %esp,%ebp
80106bd6:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106bd9:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80106bde:	85 c0                	test   %eax,%eax
80106be0:	75 02                	jne    80106be4 <uartputc+0x11>
    return;
80106be2:	eb 4b                	jmp    80106c2f <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106be4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106beb:	eb 10                	jmp    80106bfd <uartputc+0x2a>
    microdelay(10);
80106bed:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106bf4:	e8 ed c2 ff ff       	call   80102ee6 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106bf9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106bfd:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106c01:	7f 16                	jg     80106c19 <uartputc+0x46>
80106c03:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106c0a:	e8 79 fe ff ff       	call   80106a88 <inb>
80106c0f:	0f b6 c0             	movzbl %al,%eax
80106c12:	83 e0 20             	and    $0x20,%eax
80106c15:	85 c0                	test   %eax,%eax
80106c17:	74 d4                	je     80106bed <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106c19:	8b 45 08             	mov    0x8(%ebp),%eax
80106c1c:	0f b6 c0             	movzbl %al,%eax
80106c1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c23:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c2a:	e8 76 fe ff ff       	call   80106aa5 <outb>
}
80106c2f:	c9                   	leave  
80106c30:	c3                   	ret    

80106c31 <uartgetc>:

static int
uartgetc(void)
{
80106c31:	55                   	push   %ebp
80106c32:	89 e5                	mov    %esp,%ebp
80106c34:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106c37:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80106c3c:	85 c0                	test   %eax,%eax
80106c3e:	75 07                	jne    80106c47 <uartgetc+0x16>
    return -1;
80106c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c45:	eb 2c                	jmp    80106c73 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106c47:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106c4e:	e8 35 fe ff ff       	call   80106a88 <inb>
80106c53:	0f b6 c0             	movzbl %al,%eax
80106c56:	83 e0 01             	and    $0x1,%eax
80106c59:	85 c0                	test   %eax,%eax
80106c5b:	75 07                	jne    80106c64 <uartgetc+0x33>
    return -1;
80106c5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c62:	eb 0f                	jmp    80106c73 <uartgetc+0x42>
  return inb(COM1+0);
80106c64:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c6b:	e8 18 fe ff ff       	call   80106a88 <inb>
80106c70:	0f b6 c0             	movzbl %al,%eax
}
80106c73:	c9                   	leave  
80106c74:	c3                   	ret    

80106c75 <uartintr>:

void
uartintr(void)
{
80106c75:	55                   	push   %ebp
80106c76:	89 e5                	mov    %esp,%ebp
80106c78:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106c7b:	c7 04 24 31 6c 10 80 	movl   $0x80106c31,(%esp)
80106c82:	e8 26 9b ff ff       	call   801007ad <consoleintr>
}
80106c87:	c9                   	leave  
80106c88:	c3                   	ret    

80106c89 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106c89:	6a 00                	push   $0x0
  pushl $0
80106c8b:	6a 00                	push   $0x0
  jmp alltraps
80106c8d:	e9 59 f9 ff ff       	jmp    801065eb <alltraps>

80106c92 <vector1>:
.globl vector1
vector1:
  pushl $0
80106c92:	6a 00                	push   $0x0
  pushl $1
80106c94:	6a 01                	push   $0x1
  jmp alltraps
80106c96:	e9 50 f9 ff ff       	jmp    801065eb <alltraps>

80106c9b <vector2>:
.globl vector2
vector2:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $2
80106c9d:	6a 02                	push   $0x2
  jmp alltraps
80106c9f:	e9 47 f9 ff ff       	jmp    801065eb <alltraps>

80106ca4 <vector3>:
.globl vector3
vector3:
  pushl $0
80106ca4:	6a 00                	push   $0x0
  pushl $3
80106ca6:	6a 03                	push   $0x3
  jmp alltraps
80106ca8:	e9 3e f9 ff ff       	jmp    801065eb <alltraps>

80106cad <vector4>:
.globl vector4
vector4:
  pushl $0
80106cad:	6a 00                	push   $0x0
  pushl $4
80106caf:	6a 04                	push   $0x4
  jmp alltraps
80106cb1:	e9 35 f9 ff ff       	jmp    801065eb <alltraps>

80106cb6 <vector5>:
.globl vector5
vector5:
  pushl $0
80106cb6:	6a 00                	push   $0x0
  pushl $5
80106cb8:	6a 05                	push   $0x5
  jmp alltraps
80106cba:	e9 2c f9 ff ff       	jmp    801065eb <alltraps>

80106cbf <vector6>:
.globl vector6
vector6:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $6
80106cc1:	6a 06                	push   $0x6
  jmp alltraps
80106cc3:	e9 23 f9 ff ff       	jmp    801065eb <alltraps>

80106cc8 <vector7>:
.globl vector7
vector7:
  pushl $0
80106cc8:	6a 00                	push   $0x0
  pushl $7
80106cca:	6a 07                	push   $0x7
  jmp alltraps
80106ccc:	e9 1a f9 ff ff       	jmp    801065eb <alltraps>

80106cd1 <vector8>:
.globl vector8
vector8:
  pushl $8
80106cd1:	6a 08                	push   $0x8
  jmp alltraps
80106cd3:	e9 13 f9 ff ff       	jmp    801065eb <alltraps>

80106cd8 <vector9>:
.globl vector9
vector9:
  pushl $0
80106cd8:	6a 00                	push   $0x0
  pushl $9
80106cda:	6a 09                	push   $0x9
  jmp alltraps
80106cdc:	e9 0a f9 ff ff       	jmp    801065eb <alltraps>

80106ce1 <vector10>:
.globl vector10
vector10:
  pushl $10
80106ce1:	6a 0a                	push   $0xa
  jmp alltraps
80106ce3:	e9 03 f9 ff ff       	jmp    801065eb <alltraps>

80106ce8 <vector11>:
.globl vector11
vector11:
  pushl $11
80106ce8:	6a 0b                	push   $0xb
  jmp alltraps
80106cea:	e9 fc f8 ff ff       	jmp    801065eb <alltraps>

80106cef <vector12>:
.globl vector12
vector12:
  pushl $12
80106cef:	6a 0c                	push   $0xc
  jmp alltraps
80106cf1:	e9 f5 f8 ff ff       	jmp    801065eb <alltraps>

80106cf6 <vector13>:
.globl vector13
vector13:
  pushl $13
80106cf6:	6a 0d                	push   $0xd
  jmp alltraps
80106cf8:	e9 ee f8 ff ff       	jmp    801065eb <alltraps>

80106cfd <vector14>:
.globl vector14
vector14:
  pushl $14
80106cfd:	6a 0e                	push   $0xe
  jmp alltraps
80106cff:	e9 e7 f8 ff ff       	jmp    801065eb <alltraps>

80106d04 <vector15>:
.globl vector15
vector15:
  pushl $0
80106d04:	6a 00                	push   $0x0
  pushl $15
80106d06:	6a 0f                	push   $0xf
  jmp alltraps
80106d08:	e9 de f8 ff ff       	jmp    801065eb <alltraps>

80106d0d <vector16>:
.globl vector16
vector16:
  pushl $0
80106d0d:	6a 00                	push   $0x0
  pushl $16
80106d0f:	6a 10                	push   $0x10
  jmp alltraps
80106d11:	e9 d5 f8 ff ff       	jmp    801065eb <alltraps>

80106d16 <vector17>:
.globl vector17
vector17:
  pushl $17
80106d16:	6a 11                	push   $0x11
  jmp alltraps
80106d18:	e9 ce f8 ff ff       	jmp    801065eb <alltraps>

80106d1d <vector18>:
.globl vector18
vector18:
  pushl $0
80106d1d:	6a 00                	push   $0x0
  pushl $18
80106d1f:	6a 12                	push   $0x12
  jmp alltraps
80106d21:	e9 c5 f8 ff ff       	jmp    801065eb <alltraps>

80106d26 <vector19>:
.globl vector19
vector19:
  pushl $0
80106d26:	6a 00                	push   $0x0
  pushl $19
80106d28:	6a 13                	push   $0x13
  jmp alltraps
80106d2a:	e9 bc f8 ff ff       	jmp    801065eb <alltraps>

80106d2f <vector20>:
.globl vector20
vector20:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $20
80106d31:	6a 14                	push   $0x14
  jmp alltraps
80106d33:	e9 b3 f8 ff ff       	jmp    801065eb <alltraps>

80106d38 <vector21>:
.globl vector21
vector21:
  pushl $0
80106d38:	6a 00                	push   $0x0
  pushl $21
80106d3a:	6a 15                	push   $0x15
  jmp alltraps
80106d3c:	e9 aa f8 ff ff       	jmp    801065eb <alltraps>

80106d41 <vector22>:
.globl vector22
vector22:
  pushl $0
80106d41:	6a 00                	push   $0x0
  pushl $22
80106d43:	6a 16                	push   $0x16
  jmp alltraps
80106d45:	e9 a1 f8 ff ff       	jmp    801065eb <alltraps>

80106d4a <vector23>:
.globl vector23
vector23:
  pushl $0
80106d4a:	6a 00                	push   $0x0
  pushl $23
80106d4c:	6a 17                	push   $0x17
  jmp alltraps
80106d4e:	e9 98 f8 ff ff       	jmp    801065eb <alltraps>

80106d53 <vector24>:
.globl vector24
vector24:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $24
80106d55:	6a 18                	push   $0x18
  jmp alltraps
80106d57:	e9 8f f8 ff ff       	jmp    801065eb <alltraps>

80106d5c <vector25>:
.globl vector25
vector25:
  pushl $0
80106d5c:	6a 00                	push   $0x0
  pushl $25
80106d5e:	6a 19                	push   $0x19
  jmp alltraps
80106d60:	e9 86 f8 ff ff       	jmp    801065eb <alltraps>

80106d65 <vector26>:
.globl vector26
vector26:
  pushl $0
80106d65:	6a 00                	push   $0x0
  pushl $26
80106d67:	6a 1a                	push   $0x1a
  jmp alltraps
80106d69:	e9 7d f8 ff ff       	jmp    801065eb <alltraps>

80106d6e <vector27>:
.globl vector27
vector27:
  pushl $0
80106d6e:	6a 00                	push   $0x0
  pushl $27
80106d70:	6a 1b                	push   $0x1b
  jmp alltraps
80106d72:	e9 74 f8 ff ff       	jmp    801065eb <alltraps>

80106d77 <vector28>:
.globl vector28
vector28:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $28
80106d79:	6a 1c                	push   $0x1c
  jmp alltraps
80106d7b:	e9 6b f8 ff ff       	jmp    801065eb <alltraps>

80106d80 <vector29>:
.globl vector29
vector29:
  pushl $0
80106d80:	6a 00                	push   $0x0
  pushl $29
80106d82:	6a 1d                	push   $0x1d
  jmp alltraps
80106d84:	e9 62 f8 ff ff       	jmp    801065eb <alltraps>

80106d89 <vector30>:
.globl vector30
vector30:
  pushl $0
80106d89:	6a 00                	push   $0x0
  pushl $30
80106d8b:	6a 1e                	push   $0x1e
  jmp alltraps
80106d8d:	e9 59 f8 ff ff       	jmp    801065eb <alltraps>

80106d92 <vector31>:
.globl vector31
vector31:
  pushl $0
80106d92:	6a 00                	push   $0x0
  pushl $31
80106d94:	6a 1f                	push   $0x1f
  jmp alltraps
80106d96:	e9 50 f8 ff ff       	jmp    801065eb <alltraps>

80106d9b <vector32>:
.globl vector32
vector32:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $32
80106d9d:	6a 20                	push   $0x20
  jmp alltraps
80106d9f:	e9 47 f8 ff ff       	jmp    801065eb <alltraps>

80106da4 <vector33>:
.globl vector33
vector33:
  pushl $0
80106da4:	6a 00                	push   $0x0
  pushl $33
80106da6:	6a 21                	push   $0x21
  jmp alltraps
80106da8:	e9 3e f8 ff ff       	jmp    801065eb <alltraps>

80106dad <vector34>:
.globl vector34
vector34:
  pushl $0
80106dad:	6a 00                	push   $0x0
  pushl $34
80106daf:	6a 22                	push   $0x22
  jmp alltraps
80106db1:	e9 35 f8 ff ff       	jmp    801065eb <alltraps>

80106db6 <vector35>:
.globl vector35
vector35:
  pushl $0
80106db6:	6a 00                	push   $0x0
  pushl $35
80106db8:	6a 23                	push   $0x23
  jmp alltraps
80106dba:	e9 2c f8 ff ff       	jmp    801065eb <alltraps>

80106dbf <vector36>:
.globl vector36
vector36:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $36
80106dc1:	6a 24                	push   $0x24
  jmp alltraps
80106dc3:	e9 23 f8 ff ff       	jmp    801065eb <alltraps>

80106dc8 <vector37>:
.globl vector37
vector37:
  pushl $0
80106dc8:	6a 00                	push   $0x0
  pushl $37
80106dca:	6a 25                	push   $0x25
  jmp alltraps
80106dcc:	e9 1a f8 ff ff       	jmp    801065eb <alltraps>

80106dd1 <vector38>:
.globl vector38
vector38:
  pushl $0
80106dd1:	6a 00                	push   $0x0
  pushl $38
80106dd3:	6a 26                	push   $0x26
  jmp alltraps
80106dd5:	e9 11 f8 ff ff       	jmp    801065eb <alltraps>

80106dda <vector39>:
.globl vector39
vector39:
  pushl $0
80106dda:	6a 00                	push   $0x0
  pushl $39
80106ddc:	6a 27                	push   $0x27
  jmp alltraps
80106dde:	e9 08 f8 ff ff       	jmp    801065eb <alltraps>

80106de3 <vector40>:
.globl vector40
vector40:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $40
80106de5:	6a 28                	push   $0x28
  jmp alltraps
80106de7:	e9 ff f7 ff ff       	jmp    801065eb <alltraps>

80106dec <vector41>:
.globl vector41
vector41:
  pushl $0
80106dec:	6a 00                	push   $0x0
  pushl $41
80106dee:	6a 29                	push   $0x29
  jmp alltraps
80106df0:	e9 f6 f7 ff ff       	jmp    801065eb <alltraps>

80106df5 <vector42>:
.globl vector42
vector42:
  pushl $0
80106df5:	6a 00                	push   $0x0
  pushl $42
80106df7:	6a 2a                	push   $0x2a
  jmp alltraps
80106df9:	e9 ed f7 ff ff       	jmp    801065eb <alltraps>

80106dfe <vector43>:
.globl vector43
vector43:
  pushl $0
80106dfe:	6a 00                	push   $0x0
  pushl $43
80106e00:	6a 2b                	push   $0x2b
  jmp alltraps
80106e02:	e9 e4 f7 ff ff       	jmp    801065eb <alltraps>

80106e07 <vector44>:
.globl vector44
vector44:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $44
80106e09:	6a 2c                	push   $0x2c
  jmp alltraps
80106e0b:	e9 db f7 ff ff       	jmp    801065eb <alltraps>

80106e10 <vector45>:
.globl vector45
vector45:
  pushl $0
80106e10:	6a 00                	push   $0x0
  pushl $45
80106e12:	6a 2d                	push   $0x2d
  jmp alltraps
80106e14:	e9 d2 f7 ff ff       	jmp    801065eb <alltraps>

80106e19 <vector46>:
.globl vector46
vector46:
  pushl $0
80106e19:	6a 00                	push   $0x0
  pushl $46
80106e1b:	6a 2e                	push   $0x2e
  jmp alltraps
80106e1d:	e9 c9 f7 ff ff       	jmp    801065eb <alltraps>

80106e22 <vector47>:
.globl vector47
vector47:
  pushl $0
80106e22:	6a 00                	push   $0x0
  pushl $47
80106e24:	6a 2f                	push   $0x2f
  jmp alltraps
80106e26:	e9 c0 f7 ff ff       	jmp    801065eb <alltraps>

80106e2b <vector48>:
.globl vector48
vector48:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $48
80106e2d:	6a 30                	push   $0x30
  jmp alltraps
80106e2f:	e9 b7 f7 ff ff       	jmp    801065eb <alltraps>

80106e34 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e34:	6a 00                	push   $0x0
  pushl $49
80106e36:	6a 31                	push   $0x31
  jmp alltraps
80106e38:	e9 ae f7 ff ff       	jmp    801065eb <alltraps>

80106e3d <vector50>:
.globl vector50
vector50:
  pushl $0
80106e3d:	6a 00                	push   $0x0
  pushl $50
80106e3f:	6a 32                	push   $0x32
  jmp alltraps
80106e41:	e9 a5 f7 ff ff       	jmp    801065eb <alltraps>

80106e46 <vector51>:
.globl vector51
vector51:
  pushl $0
80106e46:	6a 00                	push   $0x0
  pushl $51
80106e48:	6a 33                	push   $0x33
  jmp alltraps
80106e4a:	e9 9c f7 ff ff       	jmp    801065eb <alltraps>

80106e4f <vector52>:
.globl vector52
vector52:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $52
80106e51:	6a 34                	push   $0x34
  jmp alltraps
80106e53:	e9 93 f7 ff ff       	jmp    801065eb <alltraps>

80106e58 <vector53>:
.globl vector53
vector53:
  pushl $0
80106e58:	6a 00                	push   $0x0
  pushl $53
80106e5a:	6a 35                	push   $0x35
  jmp alltraps
80106e5c:	e9 8a f7 ff ff       	jmp    801065eb <alltraps>

80106e61 <vector54>:
.globl vector54
vector54:
  pushl $0
80106e61:	6a 00                	push   $0x0
  pushl $54
80106e63:	6a 36                	push   $0x36
  jmp alltraps
80106e65:	e9 81 f7 ff ff       	jmp    801065eb <alltraps>

80106e6a <vector55>:
.globl vector55
vector55:
  pushl $0
80106e6a:	6a 00                	push   $0x0
  pushl $55
80106e6c:	6a 37                	push   $0x37
  jmp alltraps
80106e6e:	e9 78 f7 ff ff       	jmp    801065eb <alltraps>

80106e73 <vector56>:
.globl vector56
vector56:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $56
80106e75:	6a 38                	push   $0x38
  jmp alltraps
80106e77:	e9 6f f7 ff ff       	jmp    801065eb <alltraps>

80106e7c <vector57>:
.globl vector57
vector57:
  pushl $0
80106e7c:	6a 00                	push   $0x0
  pushl $57
80106e7e:	6a 39                	push   $0x39
  jmp alltraps
80106e80:	e9 66 f7 ff ff       	jmp    801065eb <alltraps>

80106e85 <vector58>:
.globl vector58
vector58:
  pushl $0
80106e85:	6a 00                	push   $0x0
  pushl $58
80106e87:	6a 3a                	push   $0x3a
  jmp alltraps
80106e89:	e9 5d f7 ff ff       	jmp    801065eb <alltraps>

80106e8e <vector59>:
.globl vector59
vector59:
  pushl $0
80106e8e:	6a 00                	push   $0x0
  pushl $59
80106e90:	6a 3b                	push   $0x3b
  jmp alltraps
80106e92:	e9 54 f7 ff ff       	jmp    801065eb <alltraps>

80106e97 <vector60>:
.globl vector60
vector60:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $60
80106e99:	6a 3c                	push   $0x3c
  jmp alltraps
80106e9b:	e9 4b f7 ff ff       	jmp    801065eb <alltraps>

80106ea0 <vector61>:
.globl vector61
vector61:
  pushl $0
80106ea0:	6a 00                	push   $0x0
  pushl $61
80106ea2:	6a 3d                	push   $0x3d
  jmp alltraps
80106ea4:	e9 42 f7 ff ff       	jmp    801065eb <alltraps>

80106ea9 <vector62>:
.globl vector62
vector62:
  pushl $0
80106ea9:	6a 00                	push   $0x0
  pushl $62
80106eab:	6a 3e                	push   $0x3e
  jmp alltraps
80106ead:	e9 39 f7 ff ff       	jmp    801065eb <alltraps>

80106eb2 <vector63>:
.globl vector63
vector63:
  pushl $0
80106eb2:	6a 00                	push   $0x0
  pushl $63
80106eb4:	6a 3f                	push   $0x3f
  jmp alltraps
80106eb6:	e9 30 f7 ff ff       	jmp    801065eb <alltraps>

80106ebb <vector64>:
.globl vector64
vector64:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $64
80106ebd:	6a 40                	push   $0x40
  jmp alltraps
80106ebf:	e9 27 f7 ff ff       	jmp    801065eb <alltraps>

80106ec4 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ec4:	6a 00                	push   $0x0
  pushl $65
80106ec6:	6a 41                	push   $0x41
  jmp alltraps
80106ec8:	e9 1e f7 ff ff       	jmp    801065eb <alltraps>

80106ecd <vector66>:
.globl vector66
vector66:
  pushl $0
80106ecd:	6a 00                	push   $0x0
  pushl $66
80106ecf:	6a 42                	push   $0x42
  jmp alltraps
80106ed1:	e9 15 f7 ff ff       	jmp    801065eb <alltraps>

80106ed6 <vector67>:
.globl vector67
vector67:
  pushl $0
80106ed6:	6a 00                	push   $0x0
  pushl $67
80106ed8:	6a 43                	push   $0x43
  jmp alltraps
80106eda:	e9 0c f7 ff ff       	jmp    801065eb <alltraps>

80106edf <vector68>:
.globl vector68
vector68:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $68
80106ee1:	6a 44                	push   $0x44
  jmp alltraps
80106ee3:	e9 03 f7 ff ff       	jmp    801065eb <alltraps>

80106ee8 <vector69>:
.globl vector69
vector69:
  pushl $0
80106ee8:	6a 00                	push   $0x0
  pushl $69
80106eea:	6a 45                	push   $0x45
  jmp alltraps
80106eec:	e9 fa f6 ff ff       	jmp    801065eb <alltraps>

80106ef1 <vector70>:
.globl vector70
vector70:
  pushl $0
80106ef1:	6a 00                	push   $0x0
  pushl $70
80106ef3:	6a 46                	push   $0x46
  jmp alltraps
80106ef5:	e9 f1 f6 ff ff       	jmp    801065eb <alltraps>

80106efa <vector71>:
.globl vector71
vector71:
  pushl $0
80106efa:	6a 00                	push   $0x0
  pushl $71
80106efc:	6a 47                	push   $0x47
  jmp alltraps
80106efe:	e9 e8 f6 ff ff       	jmp    801065eb <alltraps>

80106f03 <vector72>:
.globl vector72
vector72:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $72
80106f05:	6a 48                	push   $0x48
  jmp alltraps
80106f07:	e9 df f6 ff ff       	jmp    801065eb <alltraps>

80106f0c <vector73>:
.globl vector73
vector73:
  pushl $0
80106f0c:	6a 00                	push   $0x0
  pushl $73
80106f0e:	6a 49                	push   $0x49
  jmp alltraps
80106f10:	e9 d6 f6 ff ff       	jmp    801065eb <alltraps>

80106f15 <vector74>:
.globl vector74
vector74:
  pushl $0
80106f15:	6a 00                	push   $0x0
  pushl $74
80106f17:	6a 4a                	push   $0x4a
  jmp alltraps
80106f19:	e9 cd f6 ff ff       	jmp    801065eb <alltraps>

80106f1e <vector75>:
.globl vector75
vector75:
  pushl $0
80106f1e:	6a 00                	push   $0x0
  pushl $75
80106f20:	6a 4b                	push   $0x4b
  jmp alltraps
80106f22:	e9 c4 f6 ff ff       	jmp    801065eb <alltraps>

80106f27 <vector76>:
.globl vector76
vector76:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $76
80106f29:	6a 4c                	push   $0x4c
  jmp alltraps
80106f2b:	e9 bb f6 ff ff       	jmp    801065eb <alltraps>

80106f30 <vector77>:
.globl vector77
vector77:
  pushl $0
80106f30:	6a 00                	push   $0x0
  pushl $77
80106f32:	6a 4d                	push   $0x4d
  jmp alltraps
80106f34:	e9 b2 f6 ff ff       	jmp    801065eb <alltraps>

80106f39 <vector78>:
.globl vector78
vector78:
  pushl $0
80106f39:	6a 00                	push   $0x0
  pushl $78
80106f3b:	6a 4e                	push   $0x4e
  jmp alltraps
80106f3d:	e9 a9 f6 ff ff       	jmp    801065eb <alltraps>

80106f42 <vector79>:
.globl vector79
vector79:
  pushl $0
80106f42:	6a 00                	push   $0x0
  pushl $79
80106f44:	6a 4f                	push   $0x4f
  jmp alltraps
80106f46:	e9 a0 f6 ff ff       	jmp    801065eb <alltraps>

80106f4b <vector80>:
.globl vector80
vector80:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $80
80106f4d:	6a 50                	push   $0x50
  jmp alltraps
80106f4f:	e9 97 f6 ff ff       	jmp    801065eb <alltraps>

80106f54 <vector81>:
.globl vector81
vector81:
  pushl $0
80106f54:	6a 00                	push   $0x0
  pushl $81
80106f56:	6a 51                	push   $0x51
  jmp alltraps
80106f58:	e9 8e f6 ff ff       	jmp    801065eb <alltraps>

80106f5d <vector82>:
.globl vector82
vector82:
  pushl $0
80106f5d:	6a 00                	push   $0x0
  pushl $82
80106f5f:	6a 52                	push   $0x52
  jmp alltraps
80106f61:	e9 85 f6 ff ff       	jmp    801065eb <alltraps>

80106f66 <vector83>:
.globl vector83
vector83:
  pushl $0
80106f66:	6a 00                	push   $0x0
  pushl $83
80106f68:	6a 53                	push   $0x53
  jmp alltraps
80106f6a:	e9 7c f6 ff ff       	jmp    801065eb <alltraps>

80106f6f <vector84>:
.globl vector84
vector84:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $84
80106f71:	6a 54                	push   $0x54
  jmp alltraps
80106f73:	e9 73 f6 ff ff       	jmp    801065eb <alltraps>

80106f78 <vector85>:
.globl vector85
vector85:
  pushl $0
80106f78:	6a 00                	push   $0x0
  pushl $85
80106f7a:	6a 55                	push   $0x55
  jmp alltraps
80106f7c:	e9 6a f6 ff ff       	jmp    801065eb <alltraps>

80106f81 <vector86>:
.globl vector86
vector86:
  pushl $0
80106f81:	6a 00                	push   $0x0
  pushl $86
80106f83:	6a 56                	push   $0x56
  jmp alltraps
80106f85:	e9 61 f6 ff ff       	jmp    801065eb <alltraps>

80106f8a <vector87>:
.globl vector87
vector87:
  pushl $0
80106f8a:	6a 00                	push   $0x0
  pushl $87
80106f8c:	6a 57                	push   $0x57
  jmp alltraps
80106f8e:	e9 58 f6 ff ff       	jmp    801065eb <alltraps>

80106f93 <vector88>:
.globl vector88
vector88:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $88
80106f95:	6a 58                	push   $0x58
  jmp alltraps
80106f97:	e9 4f f6 ff ff       	jmp    801065eb <alltraps>

80106f9c <vector89>:
.globl vector89
vector89:
  pushl $0
80106f9c:	6a 00                	push   $0x0
  pushl $89
80106f9e:	6a 59                	push   $0x59
  jmp alltraps
80106fa0:	e9 46 f6 ff ff       	jmp    801065eb <alltraps>

80106fa5 <vector90>:
.globl vector90
vector90:
  pushl $0
80106fa5:	6a 00                	push   $0x0
  pushl $90
80106fa7:	6a 5a                	push   $0x5a
  jmp alltraps
80106fa9:	e9 3d f6 ff ff       	jmp    801065eb <alltraps>

80106fae <vector91>:
.globl vector91
vector91:
  pushl $0
80106fae:	6a 00                	push   $0x0
  pushl $91
80106fb0:	6a 5b                	push   $0x5b
  jmp alltraps
80106fb2:	e9 34 f6 ff ff       	jmp    801065eb <alltraps>

80106fb7 <vector92>:
.globl vector92
vector92:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $92
80106fb9:	6a 5c                	push   $0x5c
  jmp alltraps
80106fbb:	e9 2b f6 ff ff       	jmp    801065eb <alltraps>

80106fc0 <vector93>:
.globl vector93
vector93:
  pushl $0
80106fc0:	6a 00                	push   $0x0
  pushl $93
80106fc2:	6a 5d                	push   $0x5d
  jmp alltraps
80106fc4:	e9 22 f6 ff ff       	jmp    801065eb <alltraps>

80106fc9 <vector94>:
.globl vector94
vector94:
  pushl $0
80106fc9:	6a 00                	push   $0x0
  pushl $94
80106fcb:	6a 5e                	push   $0x5e
  jmp alltraps
80106fcd:	e9 19 f6 ff ff       	jmp    801065eb <alltraps>

80106fd2 <vector95>:
.globl vector95
vector95:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $95
80106fd4:	6a 5f                	push   $0x5f
  jmp alltraps
80106fd6:	e9 10 f6 ff ff       	jmp    801065eb <alltraps>

80106fdb <vector96>:
.globl vector96
vector96:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $96
80106fdd:	6a 60                	push   $0x60
  jmp alltraps
80106fdf:	e9 07 f6 ff ff       	jmp    801065eb <alltraps>

80106fe4 <vector97>:
.globl vector97
vector97:
  pushl $0
80106fe4:	6a 00                	push   $0x0
  pushl $97
80106fe6:	6a 61                	push   $0x61
  jmp alltraps
80106fe8:	e9 fe f5 ff ff       	jmp    801065eb <alltraps>

80106fed <vector98>:
.globl vector98
vector98:
  pushl $0
80106fed:	6a 00                	push   $0x0
  pushl $98
80106fef:	6a 62                	push   $0x62
  jmp alltraps
80106ff1:	e9 f5 f5 ff ff       	jmp    801065eb <alltraps>

80106ff6 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ff6:	6a 00                	push   $0x0
  pushl $99
80106ff8:	6a 63                	push   $0x63
  jmp alltraps
80106ffa:	e9 ec f5 ff ff       	jmp    801065eb <alltraps>

80106fff <vector100>:
.globl vector100
vector100:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $100
80107001:	6a 64                	push   $0x64
  jmp alltraps
80107003:	e9 e3 f5 ff ff       	jmp    801065eb <alltraps>

80107008 <vector101>:
.globl vector101
vector101:
  pushl $0
80107008:	6a 00                	push   $0x0
  pushl $101
8010700a:	6a 65                	push   $0x65
  jmp alltraps
8010700c:	e9 da f5 ff ff       	jmp    801065eb <alltraps>

80107011 <vector102>:
.globl vector102
vector102:
  pushl $0
80107011:	6a 00                	push   $0x0
  pushl $102
80107013:	6a 66                	push   $0x66
  jmp alltraps
80107015:	e9 d1 f5 ff ff       	jmp    801065eb <alltraps>

8010701a <vector103>:
.globl vector103
vector103:
  pushl $0
8010701a:	6a 00                	push   $0x0
  pushl $103
8010701c:	6a 67                	push   $0x67
  jmp alltraps
8010701e:	e9 c8 f5 ff ff       	jmp    801065eb <alltraps>

80107023 <vector104>:
.globl vector104
vector104:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $104
80107025:	6a 68                	push   $0x68
  jmp alltraps
80107027:	e9 bf f5 ff ff       	jmp    801065eb <alltraps>

8010702c <vector105>:
.globl vector105
vector105:
  pushl $0
8010702c:	6a 00                	push   $0x0
  pushl $105
8010702e:	6a 69                	push   $0x69
  jmp alltraps
80107030:	e9 b6 f5 ff ff       	jmp    801065eb <alltraps>

80107035 <vector106>:
.globl vector106
vector106:
  pushl $0
80107035:	6a 00                	push   $0x0
  pushl $106
80107037:	6a 6a                	push   $0x6a
  jmp alltraps
80107039:	e9 ad f5 ff ff       	jmp    801065eb <alltraps>

8010703e <vector107>:
.globl vector107
vector107:
  pushl $0
8010703e:	6a 00                	push   $0x0
  pushl $107
80107040:	6a 6b                	push   $0x6b
  jmp alltraps
80107042:	e9 a4 f5 ff ff       	jmp    801065eb <alltraps>

80107047 <vector108>:
.globl vector108
vector108:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $108
80107049:	6a 6c                	push   $0x6c
  jmp alltraps
8010704b:	e9 9b f5 ff ff       	jmp    801065eb <alltraps>

80107050 <vector109>:
.globl vector109
vector109:
  pushl $0
80107050:	6a 00                	push   $0x0
  pushl $109
80107052:	6a 6d                	push   $0x6d
  jmp alltraps
80107054:	e9 92 f5 ff ff       	jmp    801065eb <alltraps>

80107059 <vector110>:
.globl vector110
vector110:
  pushl $0
80107059:	6a 00                	push   $0x0
  pushl $110
8010705b:	6a 6e                	push   $0x6e
  jmp alltraps
8010705d:	e9 89 f5 ff ff       	jmp    801065eb <alltraps>

80107062 <vector111>:
.globl vector111
vector111:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $111
80107064:	6a 6f                	push   $0x6f
  jmp alltraps
80107066:	e9 80 f5 ff ff       	jmp    801065eb <alltraps>

8010706b <vector112>:
.globl vector112
vector112:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $112
8010706d:	6a 70                	push   $0x70
  jmp alltraps
8010706f:	e9 77 f5 ff ff       	jmp    801065eb <alltraps>

80107074 <vector113>:
.globl vector113
vector113:
  pushl $0
80107074:	6a 00                	push   $0x0
  pushl $113
80107076:	6a 71                	push   $0x71
  jmp alltraps
80107078:	e9 6e f5 ff ff       	jmp    801065eb <alltraps>

8010707d <vector114>:
.globl vector114
vector114:
  pushl $0
8010707d:	6a 00                	push   $0x0
  pushl $114
8010707f:	6a 72                	push   $0x72
  jmp alltraps
80107081:	e9 65 f5 ff ff       	jmp    801065eb <alltraps>

80107086 <vector115>:
.globl vector115
vector115:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $115
80107088:	6a 73                	push   $0x73
  jmp alltraps
8010708a:	e9 5c f5 ff ff       	jmp    801065eb <alltraps>

8010708f <vector116>:
.globl vector116
vector116:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $116
80107091:	6a 74                	push   $0x74
  jmp alltraps
80107093:	e9 53 f5 ff ff       	jmp    801065eb <alltraps>

80107098 <vector117>:
.globl vector117
vector117:
  pushl $0
80107098:	6a 00                	push   $0x0
  pushl $117
8010709a:	6a 75                	push   $0x75
  jmp alltraps
8010709c:	e9 4a f5 ff ff       	jmp    801065eb <alltraps>

801070a1 <vector118>:
.globl vector118
vector118:
  pushl $0
801070a1:	6a 00                	push   $0x0
  pushl $118
801070a3:	6a 76                	push   $0x76
  jmp alltraps
801070a5:	e9 41 f5 ff ff       	jmp    801065eb <alltraps>

801070aa <vector119>:
.globl vector119
vector119:
  pushl $0
801070aa:	6a 00                	push   $0x0
  pushl $119
801070ac:	6a 77                	push   $0x77
  jmp alltraps
801070ae:	e9 38 f5 ff ff       	jmp    801065eb <alltraps>

801070b3 <vector120>:
.globl vector120
vector120:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $120
801070b5:	6a 78                	push   $0x78
  jmp alltraps
801070b7:	e9 2f f5 ff ff       	jmp    801065eb <alltraps>

801070bc <vector121>:
.globl vector121
vector121:
  pushl $0
801070bc:	6a 00                	push   $0x0
  pushl $121
801070be:	6a 79                	push   $0x79
  jmp alltraps
801070c0:	e9 26 f5 ff ff       	jmp    801065eb <alltraps>

801070c5 <vector122>:
.globl vector122
vector122:
  pushl $0
801070c5:	6a 00                	push   $0x0
  pushl $122
801070c7:	6a 7a                	push   $0x7a
  jmp alltraps
801070c9:	e9 1d f5 ff ff       	jmp    801065eb <alltraps>

801070ce <vector123>:
.globl vector123
vector123:
  pushl $0
801070ce:	6a 00                	push   $0x0
  pushl $123
801070d0:	6a 7b                	push   $0x7b
  jmp alltraps
801070d2:	e9 14 f5 ff ff       	jmp    801065eb <alltraps>

801070d7 <vector124>:
.globl vector124
vector124:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $124
801070d9:	6a 7c                	push   $0x7c
  jmp alltraps
801070db:	e9 0b f5 ff ff       	jmp    801065eb <alltraps>

801070e0 <vector125>:
.globl vector125
vector125:
  pushl $0
801070e0:	6a 00                	push   $0x0
  pushl $125
801070e2:	6a 7d                	push   $0x7d
  jmp alltraps
801070e4:	e9 02 f5 ff ff       	jmp    801065eb <alltraps>

801070e9 <vector126>:
.globl vector126
vector126:
  pushl $0
801070e9:	6a 00                	push   $0x0
  pushl $126
801070eb:	6a 7e                	push   $0x7e
  jmp alltraps
801070ed:	e9 f9 f4 ff ff       	jmp    801065eb <alltraps>

801070f2 <vector127>:
.globl vector127
vector127:
  pushl $0
801070f2:	6a 00                	push   $0x0
  pushl $127
801070f4:	6a 7f                	push   $0x7f
  jmp alltraps
801070f6:	e9 f0 f4 ff ff       	jmp    801065eb <alltraps>

801070fb <vector128>:
.globl vector128
vector128:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $128
801070fd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107102:	e9 e4 f4 ff ff       	jmp    801065eb <alltraps>

80107107 <vector129>:
.globl vector129
vector129:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $129
80107109:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010710e:	e9 d8 f4 ff ff       	jmp    801065eb <alltraps>

80107113 <vector130>:
.globl vector130
vector130:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $130
80107115:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010711a:	e9 cc f4 ff ff       	jmp    801065eb <alltraps>

8010711f <vector131>:
.globl vector131
vector131:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $131
80107121:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107126:	e9 c0 f4 ff ff       	jmp    801065eb <alltraps>

8010712b <vector132>:
.globl vector132
vector132:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $132
8010712d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107132:	e9 b4 f4 ff ff       	jmp    801065eb <alltraps>

80107137 <vector133>:
.globl vector133
vector133:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $133
80107139:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010713e:	e9 a8 f4 ff ff       	jmp    801065eb <alltraps>

80107143 <vector134>:
.globl vector134
vector134:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $134
80107145:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010714a:	e9 9c f4 ff ff       	jmp    801065eb <alltraps>

8010714f <vector135>:
.globl vector135
vector135:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $135
80107151:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107156:	e9 90 f4 ff ff       	jmp    801065eb <alltraps>

8010715b <vector136>:
.globl vector136
vector136:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $136
8010715d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107162:	e9 84 f4 ff ff       	jmp    801065eb <alltraps>

80107167 <vector137>:
.globl vector137
vector137:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $137
80107169:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010716e:	e9 78 f4 ff ff       	jmp    801065eb <alltraps>

80107173 <vector138>:
.globl vector138
vector138:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $138
80107175:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010717a:	e9 6c f4 ff ff       	jmp    801065eb <alltraps>

8010717f <vector139>:
.globl vector139
vector139:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $139
80107181:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107186:	e9 60 f4 ff ff       	jmp    801065eb <alltraps>

8010718b <vector140>:
.globl vector140
vector140:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $140
8010718d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107192:	e9 54 f4 ff ff       	jmp    801065eb <alltraps>

80107197 <vector141>:
.globl vector141
vector141:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $141
80107199:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010719e:	e9 48 f4 ff ff       	jmp    801065eb <alltraps>

801071a3 <vector142>:
.globl vector142
vector142:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $142
801071a5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801071aa:	e9 3c f4 ff ff       	jmp    801065eb <alltraps>

801071af <vector143>:
.globl vector143
vector143:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $143
801071b1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801071b6:	e9 30 f4 ff ff       	jmp    801065eb <alltraps>

801071bb <vector144>:
.globl vector144
vector144:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $144
801071bd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801071c2:	e9 24 f4 ff ff       	jmp    801065eb <alltraps>

801071c7 <vector145>:
.globl vector145
vector145:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $145
801071c9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801071ce:	e9 18 f4 ff ff       	jmp    801065eb <alltraps>

801071d3 <vector146>:
.globl vector146
vector146:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $146
801071d5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801071da:	e9 0c f4 ff ff       	jmp    801065eb <alltraps>

801071df <vector147>:
.globl vector147
vector147:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $147
801071e1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801071e6:	e9 00 f4 ff ff       	jmp    801065eb <alltraps>

801071eb <vector148>:
.globl vector148
vector148:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $148
801071ed:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801071f2:	e9 f4 f3 ff ff       	jmp    801065eb <alltraps>

801071f7 <vector149>:
.globl vector149
vector149:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $149
801071f9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801071fe:	e9 e8 f3 ff ff       	jmp    801065eb <alltraps>

80107203 <vector150>:
.globl vector150
vector150:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $150
80107205:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010720a:	e9 dc f3 ff ff       	jmp    801065eb <alltraps>

8010720f <vector151>:
.globl vector151
vector151:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $151
80107211:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107216:	e9 d0 f3 ff ff       	jmp    801065eb <alltraps>

8010721b <vector152>:
.globl vector152
vector152:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $152
8010721d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107222:	e9 c4 f3 ff ff       	jmp    801065eb <alltraps>

80107227 <vector153>:
.globl vector153
vector153:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $153
80107229:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010722e:	e9 b8 f3 ff ff       	jmp    801065eb <alltraps>

80107233 <vector154>:
.globl vector154
vector154:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $154
80107235:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010723a:	e9 ac f3 ff ff       	jmp    801065eb <alltraps>

8010723f <vector155>:
.globl vector155
vector155:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $155
80107241:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107246:	e9 a0 f3 ff ff       	jmp    801065eb <alltraps>

8010724b <vector156>:
.globl vector156
vector156:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $156
8010724d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107252:	e9 94 f3 ff ff       	jmp    801065eb <alltraps>

80107257 <vector157>:
.globl vector157
vector157:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $157
80107259:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010725e:	e9 88 f3 ff ff       	jmp    801065eb <alltraps>

80107263 <vector158>:
.globl vector158
vector158:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $158
80107265:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010726a:	e9 7c f3 ff ff       	jmp    801065eb <alltraps>

8010726f <vector159>:
.globl vector159
vector159:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $159
80107271:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107276:	e9 70 f3 ff ff       	jmp    801065eb <alltraps>

8010727b <vector160>:
.globl vector160
vector160:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $160
8010727d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107282:	e9 64 f3 ff ff       	jmp    801065eb <alltraps>

80107287 <vector161>:
.globl vector161
vector161:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $161
80107289:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010728e:	e9 58 f3 ff ff       	jmp    801065eb <alltraps>

80107293 <vector162>:
.globl vector162
vector162:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $162
80107295:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010729a:	e9 4c f3 ff ff       	jmp    801065eb <alltraps>

8010729f <vector163>:
.globl vector163
vector163:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $163
801072a1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801072a6:	e9 40 f3 ff ff       	jmp    801065eb <alltraps>

801072ab <vector164>:
.globl vector164
vector164:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $164
801072ad:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801072b2:	e9 34 f3 ff ff       	jmp    801065eb <alltraps>

801072b7 <vector165>:
.globl vector165
vector165:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $165
801072b9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801072be:	e9 28 f3 ff ff       	jmp    801065eb <alltraps>

801072c3 <vector166>:
.globl vector166
vector166:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $166
801072c5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801072ca:	e9 1c f3 ff ff       	jmp    801065eb <alltraps>

801072cf <vector167>:
.globl vector167
vector167:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $167
801072d1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801072d6:	e9 10 f3 ff ff       	jmp    801065eb <alltraps>

801072db <vector168>:
.globl vector168
vector168:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $168
801072dd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801072e2:	e9 04 f3 ff ff       	jmp    801065eb <alltraps>

801072e7 <vector169>:
.globl vector169
vector169:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $169
801072e9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801072ee:	e9 f8 f2 ff ff       	jmp    801065eb <alltraps>

801072f3 <vector170>:
.globl vector170
vector170:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $170
801072f5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801072fa:	e9 ec f2 ff ff       	jmp    801065eb <alltraps>

801072ff <vector171>:
.globl vector171
vector171:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $171
80107301:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107306:	e9 e0 f2 ff ff       	jmp    801065eb <alltraps>

8010730b <vector172>:
.globl vector172
vector172:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $172
8010730d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107312:	e9 d4 f2 ff ff       	jmp    801065eb <alltraps>

80107317 <vector173>:
.globl vector173
vector173:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $173
80107319:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010731e:	e9 c8 f2 ff ff       	jmp    801065eb <alltraps>

80107323 <vector174>:
.globl vector174
vector174:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $174
80107325:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010732a:	e9 bc f2 ff ff       	jmp    801065eb <alltraps>

8010732f <vector175>:
.globl vector175
vector175:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $175
80107331:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107336:	e9 b0 f2 ff ff       	jmp    801065eb <alltraps>

8010733b <vector176>:
.globl vector176
vector176:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $176
8010733d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107342:	e9 a4 f2 ff ff       	jmp    801065eb <alltraps>

80107347 <vector177>:
.globl vector177
vector177:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $177
80107349:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010734e:	e9 98 f2 ff ff       	jmp    801065eb <alltraps>

80107353 <vector178>:
.globl vector178
vector178:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $178
80107355:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010735a:	e9 8c f2 ff ff       	jmp    801065eb <alltraps>

8010735f <vector179>:
.globl vector179
vector179:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $179
80107361:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107366:	e9 80 f2 ff ff       	jmp    801065eb <alltraps>

8010736b <vector180>:
.globl vector180
vector180:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $180
8010736d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107372:	e9 74 f2 ff ff       	jmp    801065eb <alltraps>

80107377 <vector181>:
.globl vector181
vector181:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $181
80107379:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010737e:	e9 68 f2 ff ff       	jmp    801065eb <alltraps>

80107383 <vector182>:
.globl vector182
vector182:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $182
80107385:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010738a:	e9 5c f2 ff ff       	jmp    801065eb <alltraps>

8010738f <vector183>:
.globl vector183
vector183:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $183
80107391:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107396:	e9 50 f2 ff ff       	jmp    801065eb <alltraps>

8010739b <vector184>:
.globl vector184
vector184:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $184
8010739d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801073a2:	e9 44 f2 ff ff       	jmp    801065eb <alltraps>

801073a7 <vector185>:
.globl vector185
vector185:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $185
801073a9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801073ae:	e9 38 f2 ff ff       	jmp    801065eb <alltraps>

801073b3 <vector186>:
.globl vector186
vector186:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $186
801073b5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801073ba:	e9 2c f2 ff ff       	jmp    801065eb <alltraps>

801073bf <vector187>:
.globl vector187
vector187:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $187
801073c1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801073c6:	e9 20 f2 ff ff       	jmp    801065eb <alltraps>

801073cb <vector188>:
.globl vector188
vector188:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $188
801073cd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801073d2:	e9 14 f2 ff ff       	jmp    801065eb <alltraps>

801073d7 <vector189>:
.globl vector189
vector189:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $189
801073d9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801073de:	e9 08 f2 ff ff       	jmp    801065eb <alltraps>

801073e3 <vector190>:
.globl vector190
vector190:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $190
801073e5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801073ea:	e9 fc f1 ff ff       	jmp    801065eb <alltraps>

801073ef <vector191>:
.globl vector191
vector191:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $191
801073f1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801073f6:	e9 f0 f1 ff ff       	jmp    801065eb <alltraps>

801073fb <vector192>:
.globl vector192
vector192:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $192
801073fd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107402:	e9 e4 f1 ff ff       	jmp    801065eb <alltraps>

80107407 <vector193>:
.globl vector193
vector193:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $193
80107409:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010740e:	e9 d8 f1 ff ff       	jmp    801065eb <alltraps>

80107413 <vector194>:
.globl vector194
vector194:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $194
80107415:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010741a:	e9 cc f1 ff ff       	jmp    801065eb <alltraps>

8010741f <vector195>:
.globl vector195
vector195:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $195
80107421:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107426:	e9 c0 f1 ff ff       	jmp    801065eb <alltraps>

8010742b <vector196>:
.globl vector196
vector196:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $196
8010742d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107432:	e9 b4 f1 ff ff       	jmp    801065eb <alltraps>

80107437 <vector197>:
.globl vector197
vector197:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $197
80107439:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010743e:	e9 a8 f1 ff ff       	jmp    801065eb <alltraps>

80107443 <vector198>:
.globl vector198
vector198:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $198
80107445:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010744a:	e9 9c f1 ff ff       	jmp    801065eb <alltraps>

8010744f <vector199>:
.globl vector199
vector199:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $199
80107451:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107456:	e9 90 f1 ff ff       	jmp    801065eb <alltraps>

8010745b <vector200>:
.globl vector200
vector200:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $200
8010745d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107462:	e9 84 f1 ff ff       	jmp    801065eb <alltraps>

80107467 <vector201>:
.globl vector201
vector201:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $201
80107469:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010746e:	e9 78 f1 ff ff       	jmp    801065eb <alltraps>

80107473 <vector202>:
.globl vector202
vector202:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $202
80107475:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010747a:	e9 6c f1 ff ff       	jmp    801065eb <alltraps>

8010747f <vector203>:
.globl vector203
vector203:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $203
80107481:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107486:	e9 60 f1 ff ff       	jmp    801065eb <alltraps>

8010748b <vector204>:
.globl vector204
vector204:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $204
8010748d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107492:	e9 54 f1 ff ff       	jmp    801065eb <alltraps>

80107497 <vector205>:
.globl vector205
vector205:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $205
80107499:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010749e:	e9 48 f1 ff ff       	jmp    801065eb <alltraps>

801074a3 <vector206>:
.globl vector206
vector206:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $206
801074a5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801074aa:	e9 3c f1 ff ff       	jmp    801065eb <alltraps>

801074af <vector207>:
.globl vector207
vector207:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $207
801074b1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801074b6:	e9 30 f1 ff ff       	jmp    801065eb <alltraps>

801074bb <vector208>:
.globl vector208
vector208:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $208
801074bd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801074c2:	e9 24 f1 ff ff       	jmp    801065eb <alltraps>

801074c7 <vector209>:
.globl vector209
vector209:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $209
801074c9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801074ce:	e9 18 f1 ff ff       	jmp    801065eb <alltraps>

801074d3 <vector210>:
.globl vector210
vector210:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $210
801074d5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801074da:	e9 0c f1 ff ff       	jmp    801065eb <alltraps>

801074df <vector211>:
.globl vector211
vector211:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $211
801074e1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801074e6:	e9 00 f1 ff ff       	jmp    801065eb <alltraps>

801074eb <vector212>:
.globl vector212
vector212:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $212
801074ed:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801074f2:	e9 f4 f0 ff ff       	jmp    801065eb <alltraps>

801074f7 <vector213>:
.globl vector213
vector213:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $213
801074f9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801074fe:	e9 e8 f0 ff ff       	jmp    801065eb <alltraps>

80107503 <vector214>:
.globl vector214
vector214:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $214
80107505:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010750a:	e9 dc f0 ff ff       	jmp    801065eb <alltraps>

8010750f <vector215>:
.globl vector215
vector215:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $215
80107511:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107516:	e9 d0 f0 ff ff       	jmp    801065eb <alltraps>

8010751b <vector216>:
.globl vector216
vector216:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $216
8010751d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107522:	e9 c4 f0 ff ff       	jmp    801065eb <alltraps>

80107527 <vector217>:
.globl vector217
vector217:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $217
80107529:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010752e:	e9 b8 f0 ff ff       	jmp    801065eb <alltraps>

80107533 <vector218>:
.globl vector218
vector218:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $218
80107535:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010753a:	e9 ac f0 ff ff       	jmp    801065eb <alltraps>

8010753f <vector219>:
.globl vector219
vector219:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $219
80107541:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107546:	e9 a0 f0 ff ff       	jmp    801065eb <alltraps>

8010754b <vector220>:
.globl vector220
vector220:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $220
8010754d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107552:	e9 94 f0 ff ff       	jmp    801065eb <alltraps>

80107557 <vector221>:
.globl vector221
vector221:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $221
80107559:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010755e:	e9 88 f0 ff ff       	jmp    801065eb <alltraps>

80107563 <vector222>:
.globl vector222
vector222:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $222
80107565:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010756a:	e9 7c f0 ff ff       	jmp    801065eb <alltraps>

8010756f <vector223>:
.globl vector223
vector223:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $223
80107571:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107576:	e9 70 f0 ff ff       	jmp    801065eb <alltraps>

8010757b <vector224>:
.globl vector224
vector224:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $224
8010757d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107582:	e9 64 f0 ff ff       	jmp    801065eb <alltraps>

80107587 <vector225>:
.globl vector225
vector225:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $225
80107589:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010758e:	e9 58 f0 ff ff       	jmp    801065eb <alltraps>

80107593 <vector226>:
.globl vector226
vector226:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $226
80107595:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010759a:	e9 4c f0 ff ff       	jmp    801065eb <alltraps>

8010759f <vector227>:
.globl vector227
vector227:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $227
801075a1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801075a6:	e9 40 f0 ff ff       	jmp    801065eb <alltraps>

801075ab <vector228>:
.globl vector228
vector228:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $228
801075ad:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801075b2:	e9 34 f0 ff ff       	jmp    801065eb <alltraps>

801075b7 <vector229>:
.globl vector229
vector229:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $229
801075b9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801075be:	e9 28 f0 ff ff       	jmp    801065eb <alltraps>

801075c3 <vector230>:
.globl vector230
vector230:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $230
801075c5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801075ca:	e9 1c f0 ff ff       	jmp    801065eb <alltraps>

801075cf <vector231>:
.globl vector231
vector231:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $231
801075d1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801075d6:	e9 10 f0 ff ff       	jmp    801065eb <alltraps>

801075db <vector232>:
.globl vector232
vector232:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $232
801075dd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801075e2:	e9 04 f0 ff ff       	jmp    801065eb <alltraps>

801075e7 <vector233>:
.globl vector233
vector233:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $233
801075e9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801075ee:	e9 f8 ef ff ff       	jmp    801065eb <alltraps>

801075f3 <vector234>:
.globl vector234
vector234:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $234
801075f5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801075fa:	e9 ec ef ff ff       	jmp    801065eb <alltraps>

801075ff <vector235>:
.globl vector235
vector235:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $235
80107601:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107606:	e9 e0 ef ff ff       	jmp    801065eb <alltraps>

8010760b <vector236>:
.globl vector236
vector236:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $236
8010760d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107612:	e9 d4 ef ff ff       	jmp    801065eb <alltraps>

80107617 <vector237>:
.globl vector237
vector237:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $237
80107619:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010761e:	e9 c8 ef ff ff       	jmp    801065eb <alltraps>

80107623 <vector238>:
.globl vector238
vector238:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $238
80107625:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010762a:	e9 bc ef ff ff       	jmp    801065eb <alltraps>

8010762f <vector239>:
.globl vector239
vector239:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $239
80107631:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107636:	e9 b0 ef ff ff       	jmp    801065eb <alltraps>

8010763b <vector240>:
.globl vector240
vector240:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $240
8010763d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107642:	e9 a4 ef ff ff       	jmp    801065eb <alltraps>

80107647 <vector241>:
.globl vector241
vector241:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $241
80107649:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010764e:	e9 98 ef ff ff       	jmp    801065eb <alltraps>

80107653 <vector242>:
.globl vector242
vector242:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $242
80107655:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010765a:	e9 8c ef ff ff       	jmp    801065eb <alltraps>

8010765f <vector243>:
.globl vector243
vector243:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $243
80107661:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107666:	e9 80 ef ff ff       	jmp    801065eb <alltraps>

8010766b <vector244>:
.globl vector244
vector244:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $244
8010766d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107672:	e9 74 ef ff ff       	jmp    801065eb <alltraps>

80107677 <vector245>:
.globl vector245
vector245:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $245
80107679:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010767e:	e9 68 ef ff ff       	jmp    801065eb <alltraps>

80107683 <vector246>:
.globl vector246
vector246:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $246
80107685:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010768a:	e9 5c ef ff ff       	jmp    801065eb <alltraps>

8010768f <vector247>:
.globl vector247
vector247:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $247
80107691:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107696:	e9 50 ef ff ff       	jmp    801065eb <alltraps>

8010769b <vector248>:
.globl vector248
vector248:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $248
8010769d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801076a2:	e9 44 ef ff ff       	jmp    801065eb <alltraps>

801076a7 <vector249>:
.globl vector249
vector249:
  pushl $0
801076a7:	6a 00                	push   $0x0
  pushl $249
801076a9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801076ae:	e9 38 ef ff ff       	jmp    801065eb <alltraps>

801076b3 <vector250>:
.globl vector250
vector250:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $250
801076b5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801076ba:	e9 2c ef ff ff       	jmp    801065eb <alltraps>

801076bf <vector251>:
.globl vector251
vector251:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $251
801076c1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801076c6:	e9 20 ef ff ff       	jmp    801065eb <alltraps>

801076cb <vector252>:
.globl vector252
vector252:
  pushl $0
801076cb:	6a 00                	push   $0x0
  pushl $252
801076cd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801076d2:	e9 14 ef ff ff       	jmp    801065eb <alltraps>

801076d7 <vector253>:
.globl vector253
vector253:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $253
801076d9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801076de:	e9 08 ef ff ff       	jmp    801065eb <alltraps>

801076e3 <vector254>:
.globl vector254
vector254:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $254
801076e5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801076ea:	e9 fc ee ff ff       	jmp    801065eb <alltraps>

801076ef <vector255>:
.globl vector255
vector255:
  pushl $0
801076ef:	6a 00                	push   $0x0
  pushl $255
801076f1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801076f6:	e9 f0 ee ff ff       	jmp    801065eb <alltraps>

801076fb <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801076fb:	55                   	push   %ebp
801076fc:	89 e5                	mov    %esp,%ebp
801076fe:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107701:	8b 45 0c             	mov    0xc(%ebp),%eax
80107704:	83 e8 01             	sub    $0x1,%eax
80107707:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010770b:	8b 45 08             	mov    0x8(%ebp),%eax
8010770e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107712:	8b 45 08             	mov    0x8(%ebp),%eax
80107715:	c1 e8 10             	shr    $0x10,%eax
80107718:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010771c:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010771f:	0f 01 10             	lgdtl  (%eax)
}
80107722:	c9                   	leave  
80107723:	c3                   	ret    

80107724 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107724:	55                   	push   %ebp
80107725:	89 e5                	mov    %esp,%ebp
80107727:	83 ec 04             	sub    $0x4,%esp
8010772a:	8b 45 08             	mov    0x8(%ebp),%eax
8010772d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107731:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107735:	0f 00 d8             	ltr    %ax
}
80107738:	c9                   	leave  
80107739:	c3                   	ret    

8010773a <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
8010773a:	55                   	push   %ebp
8010773b:	89 e5                	mov    %esp,%ebp
8010773d:	83 ec 04             	sub    $0x4,%esp
80107740:	8b 45 08             	mov    0x8(%ebp),%eax
80107743:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107747:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010774b:	8e e8                	mov    %eax,%gs
}
8010774d:	c9                   	leave  
8010774e:	c3                   	ret    

8010774f <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010774f:	55                   	push   %ebp
80107750:	89 e5                	mov    %esp,%ebp
80107752:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107755:	0f 20 d0             	mov    %cr2,%eax
80107758:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010775b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010775e:	c9                   	leave  
8010775f:	c3                   	ret    

80107760 <lcr3>:

static inline void
lcr3(uint val) 
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107763:	8b 45 08             	mov    0x8(%ebp),%eax
80107766:	0f 22 d8             	mov    %eax,%cr3
}
80107769:	5d                   	pop    %ebp
8010776a:	c3                   	ret    

8010776b <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010776b:	55                   	push   %ebp
8010776c:	89 e5                	mov    %esp,%ebp
8010776e:	8b 45 08             	mov    0x8(%ebp),%eax
80107771:	05 00 00 00 80       	add    $0x80000000,%eax
80107776:	5d                   	pop    %ebp
80107777:	c3                   	ret    

80107778 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107778:	55                   	push   %ebp
80107779:	89 e5                	mov    %esp,%ebp
8010777b:	8b 45 08             	mov    0x8(%ebp),%eax
8010777e:	05 00 00 00 80       	add    $0x80000000,%eax
80107783:	5d                   	pop    %ebp
80107784:	c3                   	ret    

80107785 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107785:	55                   	push   %ebp
80107786:	89 e5                	mov    %esp,%ebp
80107788:	53                   	push   %ebx
80107789:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010778c:	e8 d8 b6 ff ff       	call   80102e69 <cpunum>
80107791:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107797:	05 40 09 11 80       	add    $0x80110940,%eax
8010779c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010779f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077a2:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801077a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077ab:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801077b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077b4:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801077b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077bb:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077bf:	83 e2 f0             	and    $0xfffffff0,%edx
801077c2:	83 ca 0a             	or     $0xa,%edx
801077c5:	88 50 7d             	mov    %dl,0x7d(%eax)
801077c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077cb:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077cf:	83 ca 10             	or     $0x10,%edx
801077d2:	88 50 7d             	mov    %dl,0x7d(%eax)
801077d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077d8:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077dc:	83 e2 9f             	and    $0xffffff9f,%edx
801077df:	88 50 7d             	mov    %dl,0x7d(%eax)
801077e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077e5:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077e9:	83 ca 80             	or     $0xffffff80,%edx
801077ec:	88 50 7d             	mov    %dl,0x7d(%eax)
801077ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077f2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077f6:	83 ca 0f             	or     $0xf,%edx
801077f9:	88 50 7e             	mov    %dl,0x7e(%eax)
801077fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077ff:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107803:	83 e2 ef             	and    $0xffffffef,%edx
80107806:	88 50 7e             	mov    %dl,0x7e(%eax)
80107809:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010780c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107810:	83 e2 df             	and    $0xffffffdf,%edx
80107813:	88 50 7e             	mov    %dl,0x7e(%eax)
80107816:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107819:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010781d:	83 ca 40             	or     $0x40,%edx
80107820:	88 50 7e             	mov    %dl,0x7e(%eax)
80107823:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107826:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010782a:	83 ca 80             	or     $0xffffff80,%edx
8010782d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107830:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107833:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107837:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010783a:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107841:	ff ff 
80107843:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107846:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010784d:	00 00 
8010784f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107852:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107859:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010785c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107863:	83 e2 f0             	and    $0xfffffff0,%edx
80107866:	83 ca 02             	or     $0x2,%edx
80107869:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010786f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107872:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107879:	83 ca 10             	or     $0x10,%edx
8010787c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107882:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107885:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010788c:	83 e2 9f             	and    $0xffffff9f,%edx
8010788f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107895:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107898:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010789f:	83 ca 80             	or     $0xffffff80,%edx
801078a2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078ab:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078b2:	83 ca 0f             	or     $0xf,%edx
801078b5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078be:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078c5:	83 e2 ef             	and    $0xffffffef,%edx
801078c8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078d1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078d8:	83 e2 df             	and    $0xffffffdf,%edx
801078db:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078e4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078eb:	83 ca 40             	or     $0x40,%edx
801078ee:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078f7:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078fe:	83 ca 80             	or     $0xffffff80,%edx
80107901:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107907:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010790a:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107911:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107914:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010791b:	ff ff 
8010791d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107920:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107927:	00 00 
80107929:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010792c:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107933:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107936:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010793d:	83 e2 f0             	and    $0xfffffff0,%edx
80107940:	83 ca 0a             	or     $0xa,%edx
80107943:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107949:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010794c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107953:	83 ca 10             	or     $0x10,%edx
80107956:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010795c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010795f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107966:	83 ca 60             	or     $0x60,%edx
80107969:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010796f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107972:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107979:	83 ca 80             	or     $0xffffff80,%edx
8010797c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107982:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107985:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010798c:	83 ca 0f             	or     $0xf,%edx
8010798f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107995:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107998:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010799f:	83 e2 ef             	and    $0xffffffef,%edx
801079a2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079ab:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079b2:	83 e2 df             	and    $0xffffffdf,%edx
801079b5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079be:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079c5:	83 ca 40             	or     $0x40,%edx
801079c8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079d1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079d8:	83 ca 80             	or     $0xffffff80,%edx
801079db:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079e4:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801079eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079ee:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801079f5:	ff ff 
801079f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079fa:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107a01:	00 00 
80107a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a06:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a10:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a17:	83 e2 f0             	and    $0xfffffff0,%edx
80107a1a:	83 ca 02             	or     $0x2,%edx
80107a1d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a26:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a2d:	83 ca 10             	or     $0x10,%edx
80107a30:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a39:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a40:	83 ca 60             	or     $0x60,%edx
80107a43:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a4c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a53:	83 ca 80             	or     $0xffffff80,%edx
80107a56:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a5f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a66:	83 ca 0f             	or     $0xf,%edx
80107a69:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a72:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a79:	83 e2 ef             	and    $0xffffffef,%edx
80107a7c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a85:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a8c:	83 e2 df             	and    $0xffffffdf,%edx
80107a8f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a98:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a9f:	83 ca 40             	or     $0x40,%edx
80107aa2:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107aab:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ab2:	83 ca 80             	or     $0xffffff80,%edx
80107ab5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107abe:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ac8:	05 b4 00 00 00       	add    $0xb4,%eax
80107acd:	89 c3                	mov    %eax,%ebx
80107acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ad2:	05 b4 00 00 00       	add    $0xb4,%eax
80107ad7:	c1 e8 10             	shr    $0x10,%eax
80107ada:	89 c1                	mov    %eax,%ecx
80107adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107adf:	05 b4 00 00 00       	add    $0xb4,%eax
80107ae4:	c1 e8 18             	shr    $0x18,%eax
80107ae7:	89 c2                	mov    %eax,%edx
80107ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107aec:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107af3:	00 00 
80107af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107af8:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b02:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b0b:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107b12:	83 e1 f0             	and    $0xfffffff0,%ecx
80107b15:	83 c9 02             	or     $0x2,%ecx
80107b18:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b21:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107b28:	83 c9 10             	or     $0x10,%ecx
80107b2b:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b34:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107b3b:	83 e1 9f             	and    $0xffffff9f,%ecx
80107b3e:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b47:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107b4e:	83 c9 80             	or     $0xffffff80,%ecx
80107b51:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b5a:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107b61:	83 e1 f0             	and    $0xfffffff0,%ecx
80107b64:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b6d:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107b74:	83 e1 ef             	and    $0xffffffef,%ecx
80107b77:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b80:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107b87:	83 e1 df             	and    $0xffffffdf,%ecx
80107b8a:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b93:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107b9a:	83 c9 40             	or     $0x40,%ecx
80107b9d:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ba6:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107bad:	83 c9 80             	or     $0xffffff80,%ecx
80107bb0:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bb9:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bc2:	83 c0 70             	add    $0x70,%eax
80107bc5:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107bcc:	00 
80107bcd:	89 04 24             	mov    %eax,(%esp)
80107bd0:	e8 26 fb ff ff       	call   801076fb <lgdt>
  loadgs(SEG_KCPU << 3);
80107bd5:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107bdc:	e8 59 fb ff ff       	call   8010773a <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107be4:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107bea:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107bf1:	00 00 00 00 

  //3.4
  int i;
  initlock(&counterStruct.lock, "init_counter_lock"); // lock in counter struct
80107bf5:	c7 44 24 04 44 92 10 	movl   $0x80109244,0x4(%esp)
80107bfc:	80 
80107bfd:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80107c04:	e8 4a d3 ff ff       	call   80104f53 <initlock>

  for(i = 0; i < allPhysPageSize; i++) // init all array to zero pages 
80107c09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107c10:	eb 15                	jmp    80107c27 <seginit+0x4a2>
      counterStruct.pageCounter[i] = 0;
80107c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c15:	83 c0 0c             	add    $0xc,%eax
80107c18:	c7 04 85 24 37 11 80 	movl   $0x0,-0x7feec8dc(,%eax,4)
80107c1f:	00 00 00 00 

  //3.4
  int i;
  initlock(&counterStruct.lock, "init_counter_lock"); // lock in counter struct

  for(i = 0; i < allPhysPageSize; i++) // init all array to zero pages 
80107c23:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107c27:	a1 a0 c4 10 80       	mov    0x8010c4a0,%eax
80107c2c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80107c2f:	7c e1                	jl     80107c12 <seginit+0x48d>
      counterStruct.pageCounter[i] = 0;
}
80107c31:	83 c4 24             	add    $0x24,%esp
80107c34:	5b                   	pop    %ebx
80107c35:	5d                   	pop    %ebp
80107c36:	c3                   	ret    

80107c37 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107c37:	55                   	push   %ebp
80107c38:	89 e5                	mov    %esp,%ebp
80107c3a:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c40:	c1 e8 16             	shr    $0x16,%eax
80107c43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107c4a:	8b 45 08             	mov    0x8(%ebp),%eax
80107c4d:	01 d0                	add    %edx,%eax
80107c4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c55:	8b 00                	mov    (%eax),%eax
80107c57:	83 e0 01             	and    $0x1,%eax
80107c5a:	85 c0                	test   %eax,%eax
80107c5c:	74 17                	je     80107c75 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c61:	8b 00                	mov    (%eax),%eax
80107c63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c68:	89 04 24             	mov    %eax,(%esp)
80107c6b:	e8 08 fb ff ff       	call   80107778 <p2v>
80107c70:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c73:	eb 4b                	jmp    80107cc0 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107c75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107c79:	74 0e                	je     80107c89 <walkpgdir+0x52>
80107c7b:	e8 70 ae ff ff       	call   80102af0 <kalloc>
80107c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c87:	75 07                	jne    80107c90 <walkpgdir+0x59>
      return 0;
80107c89:	b8 00 00 00 00       	mov    $0x0,%eax
80107c8e:	eb 47                	jmp    80107cd7 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107c90:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c97:	00 
80107c98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c9f:	00 
80107ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca3:	89 04 24             	mov    %eax,(%esp)
80107ca6:	e8 1d d5 ff ff       	call   801051c8 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cae:	89 04 24             	mov    %eax,(%esp)
80107cb1:	e8 b5 fa ff ff       	call   8010776b <v2p>
80107cb6:	83 c8 07             	or     $0x7,%eax
80107cb9:	89 c2                	mov    %eax,%edx
80107cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cbe:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cc3:	c1 e8 0c             	shr    $0xc,%eax
80107cc6:	25 ff 03 00 00       	and    $0x3ff,%eax
80107ccb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd5:	01 d0                	add    %edx,%eax
}
80107cd7:	c9                   	leave  
80107cd8:	c3                   	ret    

80107cd9 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107cd9:	55                   	push   %ebp
80107cda:	89 e5                	mov    %esp,%ebp
80107cdc:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ce2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107cea:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ced:	8b 45 10             	mov    0x10(%ebp),%eax
80107cf0:	01 d0                	add    %edx,%eax
80107cf2:	83 e8 01             	sub    $0x1,%eax
80107cf5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107cfd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107d04:	00 
80107d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d08:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d0c:	8b 45 08             	mov    0x8(%ebp),%eax
80107d0f:	89 04 24             	mov    %eax,(%esp)
80107d12:	e8 20 ff ff ff       	call   80107c37 <walkpgdir>
80107d17:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107d1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107d1e:	75 07                	jne    80107d27 <mappages+0x4e>
      return -1;
80107d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d25:	eb 48                	jmp    80107d6f <mappages+0x96>
    if(*pte & PTE_P)
80107d27:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d2a:	8b 00                	mov    (%eax),%eax
80107d2c:	83 e0 01             	and    $0x1,%eax
80107d2f:	85 c0                	test   %eax,%eax
80107d31:	74 0c                	je     80107d3f <mappages+0x66>
      panic("remap");
80107d33:	c7 04 24 56 92 10 80 	movl   $0x80109256,(%esp)
80107d3a:	e8 fb 87 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80107d3f:	8b 45 18             	mov    0x18(%ebp),%eax
80107d42:	0b 45 14             	or     0x14(%ebp),%eax
80107d45:	83 c8 01             	or     $0x1,%eax
80107d48:	89 c2                	mov    %eax,%edx
80107d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d4d:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107d55:	75 08                	jne    80107d5f <mappages+0x86>
      break;
80107d57:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107d58:	b8 00 00 00 00       	mov    $0x0,%eax
80107d5d:	eb 10                	jmp    80107d6f <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107d5f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107d66:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107d6d:	eb 8e                	jmp    80107cfd <mappages+0x24>
  return 0;
}
80107d6f:	c9                   	leave  
80107d70:	c3                   	ret    

80107d71 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm()
{
80107d71:	55                   	push   %ebp
80107d72:	89 e5                	mov    %esp,%ebp
80107d74:	53                   	push   %ebx
80107d75:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107d78:	e8 73 ad ff ff       	call   80102af0 <kalloc>
80107d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d84:	75 0a                	jne    80107d90 <setupkvm+0x1f>
    return 0;
80107d86:	b8 00 00 00 00       	mov    $0x0,%eax
80107d8b:	e9 98 00 00 00       	jmp    80107e28 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80107d90:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d97:	00 
80107d98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107d9f:	00 
80107da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107da3:	89 04 24             	mov    %eax,(%esp)
80107da6:	e8 1d d4 ff ff       	call   801051c8 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107dab:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107db2:	e8 c1 f9 ff ff       	call   80107778 <p2v>
80107db7:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107dbc:	76 0c                	jbe    80107dca <setupkvm+0x59>
    panic("PHYSTOP too high");
80107dbe:	c7 04 24 5c 92 10 80 	movl   $0x8010925c,(%esp)
80107dc5:	e8 70 87 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107dca:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80107dd1:	eb 49                	jmp    80107e1c <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd6:	8b 48 0c             	mov    0xc(%eax),%ecx
80107dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ddc:	8b 50 04             	mov    0x4(%eax),%edx
80107ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de2:	8b 58 08             	mov    0x8(%eax),%ebx
80107de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de8:	8b 40 04             	mov    0x4(%eax),%eax
80107deb:	29 c3                	sub    %eax,%ebx
80107ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df0:	8b 00                	mov    (%eax),%eax
80107df2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107df6:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107dfa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107dfe:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e05:	89 04 24             	mov    %eax,(%esp)
80107e08:	e8 cc fe ff ff       	call   80107cd9 <mappages>
80107e0d:	85 c0                	test   %eax,%eax
80107e0f:	79 07                	jns    80107e18 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107e11:	b8 00 00 00 00       	mov    $0x0,%eax
80107e16:	eb 10                	jmp    80107e28 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e18:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107e1c:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80107e23:	72 ae                	jb     80107dd3 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107e28:	83 c4 34             	add    $0x34,%esp
80107e2b:	5b                   	pop    %ebx
80107e2c:	5d                   	pop    %ebp
80107e2d:	c3                   	ret    

80107e2e <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107e2e:	55                   	push   %ebp
80107e2f:	89 e5                	mov    %esp,%ebp
80107e31:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107e34:	e8 38 ff ff ff       	call   80107d71 <setupkvm>
80107e39:	a3 18 37 11 80       	mov    %eax,0x80113718
  switchkvm();
80107e3e:	e8 02 00 00 00       	call   80107e45 <switchkvm>
}
80107e43:	c9                   	leave  
80107e44:	c3                   	ret    

80107e45 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107e45:	55                   	push   %ebp
80107e46:	89 e5                	mov    %esp,%ebp
80107e48:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107e4b:	a1 18 37 11 80       	mov    0x80113718,%eax
80107e50:	89 04 24             	mov    %eax,(%esp)
80107e53:	e8 13 f9 ff ff       	call   8010776b <v2p>
80107e58:	89 04 24             	mov    %eax,(%esp)
80107e5b:	e8 00 f9 ff ff       	call   80107760 <lcr3>
}
80107e60:	c9                   	leave  
80107e61:	c3                   	ret    

80107e62 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107e62:	55                   	push   %ebp
80107e63:	89 e5                	mov    %esp,%ebp
80107e65:	53                   	push   %ebx
80107e66:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107e69:	e8 5a d2 ff ff       	call   801050c8 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107e6e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e74:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e7b:	83 c2 08             	add    $0x8,%edx
80107e7e:	89 d3                	mov    %edx,%ebx
80107e80:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e87:	83 c2 08             	add    $0x8,%edx
80107e8a:	c1 ea 10             	shr    $0x10,%edx
80107e8d:	89 d1                	mov    %edx,%ecx
80107e8f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e96:	83 c2 08             	add    $0x8,%edx
80107e99:	c1 ea 18             	shr    $0x18,%edx
80107e9c:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107ea3:	67 00 
80107ea5:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107eac:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107eb2:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107eb9:	83 e1 f0             	and    $0xfffffff0,%ecx
80107ebc:	83 c9 09             	or     $0x9,%ecx
80107ebf:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107ec5:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107ecc:	83 c9 10             	or     $0x10,%ecx
80107ecf:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107ed5:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107edc:	83 e1 9f             	and    $0xffffff9f,%ecx
80107edf:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107ee5:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107eec:	83 c9 80             	or     $0xffffff80,%ecx
80107eef:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107ef5:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107efc:	83 e1 f0             	and    $0xfffffff0,%ecx
80107eff:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107f05:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107f0c:	83 e1 ef             	and    $0xffffffef,%ecx
80107f0f:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107f15:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107f1c:	83 e1 df             	and    $0xffffffdf,%ecx
80107f1f:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107f25:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107f2c:	83 c9 40             	or     $0x40,%ecx
80107f2f:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107f35:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107f3c:	83 e1 7f             	and    $0x7f,%ecx
80107f3f:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107f45:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107f4b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f51:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107f58:	83 e2 ef             	and    $0xffffffef,%edx
80107f5b:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107f61:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f67:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107f6d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f73:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107f7a:	8b 52 08             	mov    0x8(%edx),%edx
80107f7d:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107f83:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107f86:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107f8d:	e8 92 f7 ff ff       	call   80107724 <ltr>
  if(p->pgdir == 0)
80107f92:	8b 45 08             	mov    0x8(%ebp),%eax
80107f95:	8b 40 04             	mov    0x4(%eax),%eax
80107f98:	85 c0                	test   %eax,%eax
80107f9a:	75 0c                	jne    80107fa8 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80107f9c:	c7 04 24 6d 92 10 80 	movl   $0x8010926d,(%esp)
80107fa3:	e8 92 85 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80107fab:	8b 40 04             	mov    0x4(%eax),%eax
80107fae:	89 04 24             	mov    %eax,(%esp)
80107fb1:	e8 b5 f7 ff ff       	call   8010776b <v2p>
80107fb6:	89 04 24             	mov    %eax,(%esp)
80107fb9:	e8 a2 f7 ff ff       	call   80107760 <lcr3>
  popcli();
80107fbe:	e8 49 d1 ff ff       	call   8010510c <popcli>
}
80107fc3:	83 c4 14             	add    $0x14,%esp
80107fc6:	5b                   	pop    %ebx
80107fc7:	5d                   	pop    %ebp
80107fc8:	c3                   	ret    

80107fc9 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107fc9:	55                   	push   %ebp
80107fca:	89 e5                	mov    %esp,%ebp
80107fcc:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107fcf:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107fd6:	76 0c                	jbe    80107fe4 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107fd8:	c7 04 24 81 92 10 80 	movl   $0x80109281,(%esp)
80107fdf:	e8 56 85 ff ff       	call   8010053a <panic>
  mem = kalloc();
80107fe4:	e8 07 ab ff ff       	call   80102af0 <kalloc>
80107fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107fec:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ff3:	00 
80107ff4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107ffb:	00 
80107ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fff:	89 04 24             	mov    %eax,(%esp)
80108002:	e8 c1 d1 ff ff       	call   801051c8 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108007:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800a:	89 04 24             	mov    %eax,(%esp)
8010800d:	e8 59 f7 ff ff       	call   8010776b <v2p>
80108012:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108019:	00 
8010801a:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010801e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108025:	00 
80108026:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010802d:	00 
8010802e:	8b 45 08             	mov    0x8(%ebp),%eax
80108031:	89 04 24             	mov    %eax,(%esp)
80108034:	e8 a0 fc ff ff       	call   80107cd9 <mappages>
  memmove(mem, init, sz);
80108039:	8b 45 10             	mov    0x10(%ebp),%eax
8010803c:	89 44 24 08          	mov    %eax,0x8(%esp)
80108040:	8b 45 0c             	mov    0xc(%ebp),%eax
80108043:	89 44 24 04          	mov    %eax,0x4(%esp)
80108047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804a:	89 04 24             	mov    %eax,(%esp)
8010804d:	e8 45 d2 ff ff       	call   80105297 <memmove>
}
80108052:	c9                   	leave  
80108053:	c3                   	ret    

80108054 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz,uint flagWriteELF) //
{
80108054:	55                   	push   %ebp
80108055:	89 e5                	mov    %esp,%ebp
80108057:	53                   	push   %ebx
80108058:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  for(i = 0; i < sz; i += PGSIZE){
8010805b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108062:	e9 db 00 00 00       	jmp    80108142 <loaduvm+0xee>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108067:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010806d:	01 d0                	add    %edx,%eax
8010806f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108076:	00 
80108077:	89 44 24 04          	mov    %eax,0x4(%esp)
8010807b:	8b 45 08             	mov    0x8(%ebp),%eax
8010807e:	89 04 24             	mov    %eax,(%esp)
80108081:	e8 b1 fb ff ff       	call   80107c37 <walkpgdir>
80108086:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108089:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010808d:	75 0c                	jne    8010809b <loaduvm+0x47>
      panic("loaduvm: address should exist");
8010808f:	c7 04 24 9b 92 10 80 	movl   $0x8010929b,(%esp)
80108096:	e8 9f 84 ff ff       	call   8010053a <panic>
    
    if( flagWriteELF == 0 ) { //3.3
8010809b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
8010809f:	75 11                	jne    801080b2 <loaduvm+0x5e>
    	*pte = *pte & ~PTE_W ; 
801080a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080a4:	8b 00                	mov    (%eax),%eax
801080a6:	83 e0 fd             	and    $0xfffffffd,%eax
801080a9:	89 c2                	mov    %eax,%edx
801080ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080ae:	89 10                	mov    %edx,(%eax)
801080b0:	eb 0f                	jmp    801080c1 <loaduvm+0x6d>
    } else {
        *pte = *pte | PTE_W ;
801080b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080b5:	8b 00                	mov    (%eax),%eax
801080b7:	83 c8 02             	or     $0x2,%eax
801080ba:	89 c2                	mov    %eax,%edx
801080bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080bf:	89 10                	mov    %edx,(%eax)
    }

    pa = PTE_ADDR(*pte) + ((uint)addr % PGSIZE);
801080c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080c4:	8b 00                	mov    (%eax),%eax
801080c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080cb:	89 c2                	mov    %eax,%edx
801080cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801080d0:	25 ff 0f 00 00       	and    $0xfff,%eax
801080d5:	01 d0                	add    %edx,%eax
801080d7:	89 45 e8             	mov    %eax,-0x18(%ebp)

    if(sz - i < PGSIZE)
801080da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080dd:	8b 55 18             	mov    0x18(%ebp),%edx
801080e0:	29 c2                	sub    %eax,%edx
801080e2:	89 d0                	mov    %edx,%eax
801080e4:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801080e9:	77 0f                	ja     801080fa <loaduvm+0xa6>
      n = sz - i;
801080eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ee:	8b 55 18             	mov    0x18(%ebp),%edx
801080f1:	29 c2                	sub    %eax,%edx
801080f3:	89 d0                	mov    %edx,%eax
801080f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801080f8:	eb 07                	jmp    80108101 <loaduvm+0xad>
    else
      n = PGSIZE;
801080fa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108101:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108104:	8b 55 14             	mov    0x14(%ebp),%edx
80108107:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010810a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010810d:	89 04 24             	mov    %eax,(%esp)
80108110:	e8 63 f6 ff ff       	call   80107778 <p2v>
80108115:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108118:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010811c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108120:	89 44 24 04          	mov    %eax,0x4(%esp)
80108124:	8b 45 10             	mov    0x10(%ebp),%eax
80108127:	89 04 24             	mov    %eax,(%esp)
8010812a:	e8 47 9c ff ff       	call   80101d76 <readi>
8010812f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108132:	74 07                	je     8010813b <loaduvm+0xe7>
      return -1;
80108134:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108139:	eb 18                	jmp    80108153 <loaduvm+0xff>
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz,uint flagWriteELF) //
{
  uint i, pa, n;
  pte_t *pte;

  for(i = 0; i < sz; i += PGSIZE){
8010813b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108145:	3b 45 18             	cmp    0x18(%ebp),%eax
80108148:	0f 82 19 ff ff ff    	jb     80108067 <loaduvm+0x13>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010814e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108153:	83 c4 24             	add    $0x24,%esp
80108156:	5b                   	pop    %ebx
80108157:	5d                   	pop    %ebp
80108158:	c3                   	ret    

80108159 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108159:	55                   	push   %ebp
8010815a:	89 e5                	mov    %esp,%ebp
8010815c:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010815f:	8b 45 10             	mov    0x10(%ebp),%eax
80108162:	85 c0                	test   %eax,%eax
80108164:	79 0a                	jns    80108170 <allocuvm+0x17>
    return 0;
80108166:	b8 00 00 00 00       	mov    $0x0,%eax
8010816b:	e9 c1 00 00 00       	jmp    80108231 <allocuvm+0xd8>
  if(newsz < oldsz)
80108170:	8b 45 10             	mov    0x10(%ebp),%eax
80108173:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108176:	73 08                	jae    80108180 <allocuvm+0x27>
    return oldsz;
80108178:	8b 45 0c             	mov    0xc(%ebp),%eax
8010817b:	e9 b1 00 00 00       	jmp    80108231 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80108180:	8b 45 0c             	mov    0xc(%ebp),%eax
80108183:	05 ff 0f 00 00       	add    $0xfff,%eax
80108188:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010818d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108190:	e9 8d 00 00 00       	jmp    80108222 <allocuvm+0xc9>
    mem = kalloc();
80108195:	e8 56 a9 ff ff       	call   80102af0 <kalloc>
8010819a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010819d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081a1:	75 2c                	jne    801081cf <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
801081a3:	c7 04 24 b9 92 10 80 	movl   $0x801092b9,(%esp)
801081aa:	e8 f1 81 ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801081af:	8b 45 0c             	mov    0xc(%ebp),%eax
801081b2:	89 44 24 08          	mov    %eax,0x8(%esp)
801081b6:	8b 45 10             	mov    0x10(%ebp),%eax
801081b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801081bd:	8b 45 08             	mov    0x8(%ebp),%eax
801081c0:	89 04 24             	mov    %eax,(%esp)
801081c3:	e8 6b 00 00 00       	call   80108233 <deallocuvm>
      return 0;
801081c8:	b8 00 00 00 00       	mov    $0x0,%eax
801081cd:	eb 62                	jmp    80108231 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
801081cf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801081d6:	00 
801081d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801081de:	00 
801081df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081e2:	89 04 24             	mov    %eax,(%esp)
801081e5:	e8 de cf ff ff       	call   801051c8 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801081ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081ed:	89 04 24             	mov    %eax,(%esp)
801081f0:	e8 76 f5 ff ff       	call   8010776b <v2p>
801081f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801081f8:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801081ff:	00 
80108200:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108204:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010820b:	00 
8010820c:	89 54 24 04          	mov    %edx,0x4(%esp)
80108210:	8b 45 08             	mov    0x8(%ebp),%eax
80108213:	89 04 24             	mov    %eax,(%esp)
80108216:	e8 be fa ff ff       	call   80107cd9 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010821b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108222:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108225:	3b 45 10             	cmp    0x10(%ebp),%eax
80108228:	0f 82 67 ff ff ff    	jb     80108195 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
8010822e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108231:	c9                   	leave  
80108232:	c3                   	ret    

80108233 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108233:	55                   	push   %ebp
80108234:	89 e5                	mov    %esp,%ebp
80108236:	83 ec 38             	sub    $0x38,%esp
    pte_t *pte;
    uint a, pa;

    if(newsz >= oldsz)
80108239:	8b 45 10             	mov    0x10(%ebp),%eax
8010823c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010823f:	72 08                	jb     80108249 <deallocuvm+0x16>
        return oldsz;
80108241:	8b 45 0c             	mov    0xc(%ebp),%eax
80108244:	e9 b7 01 00 00       	jmp    80108400 <deallocuvm+0x1cd>

    a = PGROUNDUP(newsz);
80108249:	8b 45 10             	mov    0x10(%ebp),%eax
8010824c:	05 ff 0f 00 00       	add    $0xfff,%eax
80108251:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108256:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(; a  < oldsz; a += PGSIZE){
80108259:	e9 93 01 00 00       	jmp    801083f1 <deallocuvm+0x1be>
        pte = walkpgdir(pgdir, (char*)a, 0);
8010825e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108261:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108268:	00 
80108269:	89 44 24 04          	mov    %eax,0x4(%esp)
8010826d:	8b 45 08             	mov    0x8(%ebp),%eax
80108270:	89 04 24             	mov    %eax,(%esp)
80108273:	e8 bf f9 ff ff       	call   80107c37 <walkpgdir>
80108278:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(!pte)
8010827b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010827f:	75 0c                	jne    8010828d <deallocuvm+0x5a>
            a += (NPTENTRIES - 1) * PGSIZE;
80108281:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108288:	e9 5d 01 00 00       	jmp    801083ea <deallocuvm+0x1b7>

        else if((*pte & PTE_P) != 0) {
8010828d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108290:	8b 00                	mov    (%eax),%eax
80108292:	83 e0 01             	and    $0x1,%eax
80108295:	85 c0                	test   %eax,%eax
80108297:	0f 84 4d 01 00 00    	je     801083ea <deallocuvm+0x1b7>
            pa = PTE_ADDR(*pte);
8010829d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082a0:	8b 00                	mov    (%eax),%eax
801082a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082a7:	89 45 ec             	mov    %eax,-0x14(%ebp)

            acquire(&counterStruct.lock);
801082aa:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801082b1:	e8 be cc ff ff       	call   80104f74 <acquire>

            if(counterStruct.pageCounter[pa/PGSIZE] == 1) {
801082b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082b9:	c1 e8 0c             	shr    $0xc,%eax
801082bc:	83 c0 0c             	add    $0xc,%eax
801082bf:	8b 04 85 24 37 11 80 	mov    -0x7feec8dc(,%eax,4),%eax
801082c6:	83 f8 01             	cmp    $0x1,%eax
801082c9:	75 59                	jne    80108324 <deallocuvm+0xf1>
                counterStruct.pageCounter[pa/PGSIZE] = 0;
801082cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082ce:	c1 e8 0c             	shr    $0xc,%eax
801082d1:	83 c0 0c             	add    $0xc,%eax
801082d4:	c7 04 85 24 37 11 80 	movl   $0x0,-0x7feec8dc(,%eax,4)
801082db:	00 00 00 00 
                release(&counterStruct.lock);
801082df:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801082e6:	e8 eb cc ff ff       	call   80104fd6 <release>
                if(pa == 0)
801082eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801082ef:	75 0c                	jne    801082fd <deallocuvm+0xca>
                    panic("kfree");
801082f1:	c7 04 24 d1 92 10 80 	movl   $0x801092d1,(%esp)
801082f8:	e8 3d 82 ff ff       	call   8010053a <panic>
                char *v = p2v(pa);
801082fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108300:	89 04 24             	mov    %eax,(%esp)
80108303:	e8 70 f4 ff ff       	call   80107778 <p2v>
80108308:	89 45 e8             	mov    %eax,-0x18(%ebp)
                kfree(v);
8010830b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010830e:	89 04 24             	mov    %eax,(%esp)
80108311:	e8 41 a7 ff ff       	call   80102a57 <kfree>
                *pte = 0;
80108316:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108319:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010831f:	e9 c6 00 00 00       	jmp    801083ea <deallocuvm+0x1b7>
            } else {
                if(counterStruct.pageCounter[pa/PGSIZE] == 0) {
80108324:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108327:	c1 e8 0c             	shr    $0xc,%eax
8010832a:	83 c0 0c             	add    $0xc,%eax
8010832d:	8b 04 85 24 37 11 80 	mov    -0x7feec8dc(,%eax,4),%eax
80108334:	85 c0                	test   %eax,%eax
80108336:	75 48                	jne    80108380 <deallocuvm+0x14d>
                    if(pa == 0)
80108338:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010833c:	75 0c                	jne    8010834a <deallocuvm+0x117>
                        panic("kfree");
8010833e:	c7 04 24 d1 92 10 80 	movl   $0x801092d1,(%esp)
80108345:	e8 f0 81 ff ff       	call   8010053a <panic>
                    char *v = p2v(pa);
8010834a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010834d:	89 04 24             	mov    %eax,(%esp)
80108350:	e8 23 f4 ff ff       	call   80107778 <p2v>
80108355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    kfree(v);
80108358:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010835b:	89 04 24             	mov    %eax,(%esp)
8010835e:	e8 f4 a6 ff ff       	call   80102a57 <kfree>
                    *pte = 0;
80108363:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108366:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    release(&counterStruct.lock);
8010836c:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80108373:	e8 5e cc ff ff       	call   80104fd6 <release>
                    return newsz;
80108378:	8b 45 10             	mov    0x10(%ebp),%eax
8010837b:	e9 80 00 00 00       	jmp    80108400 <deallocuvm+0x1cd>
                } else {
                    counterStruct.pageCounter[pa/PGSIZE]--;
80108380:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108383:	c1 e8 0c             	shr    $0xc,%eax
80108386:	8d 50 0c             	lea    0xc(%eax),%edx
80108389:	8b 14 95 24 37 11 80 	mov    -0x7feec8dc(,%edx,4),%edx
80108390:	83 ea 01             	sub    $0x1,%edx
80108393:	83 c0 0c             	add    $0xc,%eax
80108396:	89 14 85 24 37 11 80 	mov    %edx,-0x7feec8dc(,%eax,4)
                    if(counterStruct.pageCounter[pa/PGSIZE] == 1) {
8010839d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083a0:	c1 e8 0c             	shr    $0xc,%eax
801083a3:	83 c0 0c             	add    $0xc,%eax
801083a6:	8b 04 85 24 37 11 80 	mov    -0x7feec8dc(,%eax,4),%eax
801083ad:	83 f8 01             	cmp    $0x1,%eax
801083b0:	75 2c                	jne    801083de <deallocuvm+0x1ab>
                        if((*pte & PTE_SHARED) != 0) {
801083b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083b5:	8b 00                	mov    (%eax),%eax
801083b7:	25 00 02 00 00       	and    $0x200,%eax
801083bc:	85 c0                	test   %eax,%eax
801083be:	74 1e                	je     801083de <deallocuvm+0x1ab>
                            *pte = *pte & ~PTE_SHARED;
801083c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083c3:	8b 00                	mov    (%eax),%eax
801083c5:	80 e4 fd             	and    $0xfd,%ah
801083c8:	89 c2                	mov    %eax,%edx
801083ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083cd:	89 10                	mov    %edx,(%eax)
                            *pte = *pte | PTE_W ;
801083cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083d2:	8b 00                	mov    (%eax),%eax
801083d4:	83 c8 02             	or     $0x2,%eax
801083d7:	89 c2                	mov    %eax,%edx
801083d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083dc:	89 10                	mov    %edx,(%eax)
                        }
                    }
                }
                    release(&counterStruct.lock);
801083de:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801083e5:	e8 ec cb ff ff       	call   80104fd6 <release>

    if(newsz >= oldsz)
        return oldsz;

    a = PGROUNDUP(newsz);
    for(; a  < oldsz; a += PGSIZE){
801083ea:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801083f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801083f7:	0f 82 61 fe ff ff    	jb     8010825e <deallocuvm+0x2b>
                kfree(v);
                *pte = 0;
            }*/
        }
    }
    return newsz;
801083fd:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108400:	c9                   	leave  
80108401:	c3                   	ret    

80108402 <removePageFromCounter>:

// 3.4 get pa in remove from page counter struct
// True - only onw page in counter
int 
removePageFromCounter(uint pa,pte_t* pte)
{
80108402:	55                   	push   %ebp
80108403:	89 e5                	mov    %esp,%ebp
80108405:	83 ec 28             	sub    $0x28,%esp
    acquire(&counterStruct.lock);
80108408:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
8010840f:	e8 60 cb ff ff       	call   80104f74 <acquire>

    int pageIndex = pa / PGSIZE;
80108414:	8b 45 08             	mov    0x8(%ebp),%eax
80108417:	c1 e8 0c             	shr    $0xc,%eax
8010841a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int *pce = &(counterStruct.pageCounter[pageIndex]);
8010841d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108420:	83 c0 0c             	add    $0xc,%eax
80108423:	c1 e0 02             	shl    $0x2,%eax
80108426:	05 20 37 11 80       	add    $0x80113720,%eax
8010842b:	83 c0 04             	add    $0x4,%eax
8010842e:	89 45 f0             	mov    %eax,-0x10(%ebp)

    switch((*pce)) {
80108431:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108434:	8b 00                	mov    (%eax),%eax
80108436:	83 f8 01             	cmp    $0x1,%eax
80108439:	74 15                	je     80108450 <removePageFromCounter+0x4e>
8010843b:	83 f8 02             	cmp    $0x2,%eax
8010843e:	74 2c                	je     8010846c <removePageFromCounter+0x6a>
80108440:	85 c0                	test   %eax,%eax
80108442:	75 76                	jne    801084ba <removePageFromCounter+0xb8>

        case 0: 
            panic("Error: removePageFromCounter(); counter entry is 0"); 
80108444:	c7 04 24 d8 92 10 80 	movl   $0x801092d8,(%esp)
8010844b:	e8 ea 80 ff ff       	call   8010053a <panic>
            release(&counterStruct.lock);
            break;
        
        case 1:  // will kfree page for shizel!
            (*pce) = 0;
80108450:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108453:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            release(&counterStruct.lock);
80108459:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80108460:	e8 71 cb ff ff       	call   80104fd6 <release>
            return 1;
80108465:	b8 01 00 00 00       	mov    $0x1,%eax
8010846a:	eb 6c                	jmp    801084d8 <removePageFromCounter+0xd6>
            break;

        case 2: 
            (*pce) = (*pce) - 1;
8010846c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010846f:	8b 00                	mov    (%eax),%eax
80108471:	8d 50 ff             	lea    -0x1(%eax),%edx
80108474:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108477:	89 10                	mov    %edx,(%eax)
            if((*pte & PTE_SHARED) != 0) {
80108479:	8b 45 0c             	mov    0xc(%ebp),%eax
8010847c:	8b 00                	mov    (%eax),%eax
8010847e:	25 00 02 00 00       	and    $0x200,%eax
80108483:	85 c0                	test   %eax,%eax
80108485:	74 20                	je     801084a7 <removePageFromCounter+0xa5>
                (*pte) = (*pte) & PTE_SHARED; //TODO
80108487:	8b 45 0c             	mov    0xc(%ebp),%eax
8010848a:	8b 00                	mov    (%eax),%eax
8010848c:	25 00 02 00 00       	and    $0x200,%eax
80108491:	89 c2                	mov    %eax,%edx
80108493:	8b 45 0c             	mov    0xc(%ebp),%eax
80108496:	89 10                	mov    %edx,(%eax)
                (*pte) = (*pte) | PTE_W;
80108498:	8b 45 0c             	mov    0xc(%ebp),%eax
8010849b:	8b 00                	mov    (%eax),%eax
8010849d:	83 c8 02             	or     $0x2,%eax
801084a0:	89 c2                	mov    %eax,%edx
801084a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801084a5:	89 10                	mov    %edx,(%eax)
            }
            release(&counterStruct.lock);
801084a7:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801084ae:	e8 23 cb ff ff       	call   80104fd6 <release>
            return 0;
801084b3:	b8 00 00 00 00       	mov    $0x0,%eax
801084b8:	eb 1e                	jmp    801084d8 <removePageFromCounter+0xd6>
            break;

        default:
            (*pce) = (*pce) - 1;
801084ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084bd:	8b 00                	mov    (%eax),%eax
801084bf:	8d 50 ff             	lea    -0x1(%eax),%edx
801084c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084c5:	89 10                	mov    %edx,(%eax)
            release(&counterStruct.lock);
801084c7:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801084ce:	e8 03 cb ff ff       	call   80104fd6 <release>
            return 0;
801084d3:	b8 00 00 00 00       	mov    $0x0,%eax
            break;
    }
    return 0;
}
801084d8:	c9                   	leave  
801084d9:	c3                   	ret    

801084da <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801084da:	55                   	push   %ebp
801084db:	89 e5                	mov    %esp,%ebp
801084dd:	83 ec 28             	sub    $0x28,%esp
    uint i;

    if(pgdir == 0)
801084e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801084e4:	75 0c                	jne    801084f2 <freevm+0x18>
        panic("freevm: no pgdir");
801084e6:	c7 04 24 0b 93 10 80 	movl   $0x8010930b,(%esp)
801084ed:	e8 48 80 ff ff       	call   8010053a <panic>
    deallocuvm(pgdir, KERNBASE, 0);
801084f2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801084f9:	00 
801084fa:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108501:	80 
80108502:	8b 45 08             	mov    0x8(%ebp),%eax
80108505:	89 04 24             	mov    %eax,(%esp)
80108508:	e8 26 fd ff ff       	call   80108233 <deallocuvm>
    for(i = 0; i < NPDENTRIES; i++){
8010850d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108514:	eb 48                	jmp    8010855e <freevm+0x84>
        if(pgdir[i] & PTE_P){
80108516:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108519:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108520:	8b 45 08             	mov    0x8(%ebp),%eax
80108523:	01 d0                	add    %edx,%eax
80108525:	8b 00                	mov    (%eax),%eax
80108527:	83 e0 01             	and    $0x1,%eax
8010852a:	85 c0                	test   %eax,%eax
8010852c:	74 2c                	je     8010855a <freevm+0x80>
            char * v = p2v(PTE_ADDR(pgdir[i]));
8010852e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108531:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108538:	8b 45 08             	mov    0x8(%ebp),%eax
8010853b:	01 d0                	add    %edx,%eax
8010853d:	8b 00                	mov    (%eax),%eax
8010853f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108544:	89 04 24             	mov    %eax,(%esp)
80108547:	e8 2c f2 ff ff       	call   80107778 <p2v>
8010854c:	89 45 f0             	mov    %eax,-0x10(%ebp)
            kfree(v);
8010854f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108552:	89 04 24             	mov    %eax,(%esp)
80108555:	e8 fd a4 ff ff       	call   80102a57 <kfree>
    uint i;

    if(pgdir == 0)
        panic("freevm: no pgdir");
    deallocuvm(pgdir, KERNBASE, 0);
    for(i = 0; i < NPDENTRIES; i++){
8010855a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010855e:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108565:	76 af                	jbe    80108516 <freevm+0x3c>
        if(pgdir[i] & PTE_P){
            char * v = p2v(PTE_ADDR(pgdir[i]));
            kfree(v);
        }
    }
    kfree((char*)pgdir);
80108567:	8b 45 08             	mov    0x8(%ebp),%eax
8010856a:	89 04 24             	mov    %eax,(%esp)
8010856d:	e8 e5 a4 ff ff       	call   80102a57 <kfree>
}
80108572:	c9                   	leave  
80108573:	c3                   	ret    

80108574 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108574:	55                   	push   %ebp
80108575:	89 e5                	mov    %esp,%ebp
80108577:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010857a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108581:	00 
80108582:	8b 45 0c             	mov    0xc(%ebp),%eax
80108585:	89 44 24 04          	mov    %eax,0x4(%esp)
80108589:	8b 45 08             	mov    0x8(%ebp),%eax
8010858c:	89 04 24             	mov    %eax,(%esp)
8010858f:	e8 a3 f6 ff ff       	call   80107c37 <walkpgdir>
80108594:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010859b:	75 0c                	jne    801085a9 <clearpteu+0x35>
    panic("clearpteu");
8010859d:	c7 04 24 1c 93 10 80 	movl   $0x8010931c,(%esp)
801085a4:	e8 91 7f ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
801085a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ac:	8b 00                	mov    (%eax),%eax
801085ae:	83 e0 fb             	and    $0xfffffffb,%eax
801085b1:	89 c2                	mov    %eax,%edx
801085b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085b6:	89 10                	mov    %edx,(%eax)
}
801085b8:	c9                   	leave  
801085b9:	c3                   	ret    

801085ba <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801085ba:	55                   	push   %ebp
801085bb:	89 e5                	mov    %esp,%ebp
801085bd:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
801085c0:	e8 ac f7 ff ff       	call   80107d71 <setupkvm>
801085c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801085c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801085cc:	75 0a                	jne    801085d8 <copyuvm+0x1e>
    return 0;
801085ce:	b8 00 00 00 00       	mov    $0x0,%eax
801085d3:	e9 37 01 00 00       	jmp    8010870f <copyuvm+0x155>
  for(i = PGSIZE; i < sz; i += PGSIZE){
801085d8:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
801085df:	e9 0a 01 00 00       	jmp    801086ee <copyuvm+0x134>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801085e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801085ee:	00 
801085ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801085f3:	8b 45 08             	mov    0x8(%ebp),%eax
801085f6:	89 04 24             	mov    %eax,(%esp)
801085f9:	e8 39 f6 ff ff       	call   80107c37 <walkpgdir>
801085fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108601:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108605:	75 0c                	jne    80108613 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80108607:	c7 04 24 26 93 10 80 	movl   $0x80109326,(%esp)
8010860e:	e8 27 7f ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
80108613:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108616:	8b 00                	mov    (%eax),%eax
80108618:	83 e0 01             	and    $0x1,%eax
8010861b:	85 c0                	test   %eax,%eax
8010861d:	75 0c                	jne    8010862b <copyuvm+0x71>
      panic("copyuvm: page not present");
8010861f:	c7 04 24 40 93 10 80 	movl   $0x80109340,(%esp)
80108626:	e8 0f 7f ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
8010862b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010862e:	8b 00                	mov    (%eax),%eax
80108630:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108635:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if((mem = kalloc()) == 0)
80108638:	e8 b3 a4 ff ff       	call   80102af0 <kalloc>
8010863d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108640:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108644:	75 05                	jne    8010864b <copyuvm+0x91>
      goto bad;
80108646:	e9 b4 00 00 00       	jmp    801086ff <copyuvm+0x145>
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010864b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010864e:	89 04 24             	mov    %eax,(%esp)
80108651:	e8 22 f1 ff ff       	call   80107778 <p2v>
80108656:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010865d:	00 
8010865e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108665:	89 04 24             	mov    %eax,(%esp)
80108668:	e8 2a cc ff ff       	call   80105297 <memmove>
   //3.3 
    if( (*pte & PTE_W )!= 0 ) {
8010866d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108670:	8b 00                	mov    (%eax),%eax
80108672:	83 e0 02             	and    $0x2,%eax
80108675:	85 c0                	test   %eax,%eax
80108677:	74 37                	je     801086b0 <copyuvm+0xf6>
    	if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
80108679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010867c:	89 04 24             	mov    %eax,(%esp)
8010867f:	e8 e7 f0 ff ff       	call   8010776b <v2p>
80108684:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108687:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010868e:	00 
8010868f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108693:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010869a:	00 
8010869b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010869f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086a2:	89 04 24             	mov    %eax,(%esp)
801086a5:	e8 2f f6 ff ff       	call   80107cd9 <mappages>
801086aa:	85 c0                	test   %eax,%eax
801086ac:	79 39                	jns    801086e7 <copyuvm+0x12d>
    		goto bad;
801086ae:	eb 4f                	jmp    801086ff <copyuvm+0x145>
    } else {
        if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_U) < 0)
801086b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801086b3:	89 04 24             	mov    %eax,(%esp)
801086b6:	e8 b0 f0 ff ff       	call   8010776b <v2p>
801086bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801086be:	c7 44 24 10 04 00 00 	movl   $0x4,0x10(%esp)
801086c5:	00 
801086c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
801086ca:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801086d1:	00 
801086d2:	89 54 24 04          	mov    %edx,0x4(%esp)
801086d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086d9:	89 04 24             	mov    %eax,(%esp)
801086dc:	e8 f8 f5 ff ff       	call   80107cd9 <mappages>
801086e1:	85 c0                	test   %eax,%eax
801086e3:	79 02                	jns    801086e7 <copyuvm+0x12d>
        	goto bad;
801086e5:	eb 18                	jmp    801086ff <copyuvm+0x145>
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = PGSIZE; i < sz; i += PGSIZE){
801086e7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801086ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086f4:	0f 82 ea fe ff ff    	jb     801085e4 <copyuvm+0x2a>
    } else {
        if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_U) < 0)
        	goto bad;
    }
  }
  return d;
801086fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086fd:	eb 10                	jmp    8010870f <copyuvm+0x155>

bad:
  freevm(d);
801086ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108702:	89 04 24             	mov    %eax,(%esp)
80108705:	e8 d0 fd ff ff       	call   801084da <freevm>
  return 0;
8010870a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010870f:	c9                   	leave  
80108710:	c3                   	ret    

80108711 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108711:	55                   	push   %ebp
80108712:	89 e5                	mov    %esp,%ebp
80108714:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108717:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010871e:	00 
8010871f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108722:	89 44 24 04          	mov    %eax,0x4(%esp)
80108726:	8b 45 08             	mov    0x8(%ebp),%eax
80108729:	89 04 24             	mov    %eax,(%esp)
8010872c:	e8 06 f5 ff ff       	call   80107c37 <walkpgdir>
80108731:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108737:	8b 00                	mov    (%eax),%eax
80108739:	83 e0 01             	and    $0x1,%eax
8010873c:	85 c0                	test   %eax,%eax
8010873e:	75 07                	jne    80108747 <uva2ka+0x36>
    return 0;
80108740:	b8 00 00 00 00       	mov    $0x0,%eax
80108745:	eb 25                	jmp    8010876c <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010874a:	8b 00                	mov    (%eax),%eax
8010874c:	83 e0 04             	and    $0x4,%eax
8010874f:	85 c0                	test   %eax,%eax
80108751:	75 07                	jne    8010875a <uva2ka+0x49>
    return 0;
80108753:	b8 00 00 00 00       	mov    $0x0,%eax
80108758:	eb 12                	jmp    8010876c <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
8010875a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010875d:	8b 00                	mov    (%eax),%eax
8010875f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108764:	89 04 24             	mov    %eax,(%esp)
80108767:	e8 0c f0 ff ff       	call   80107778 <p2v>
}
8010876c:	c9                   	leave  
8010876d:	c3                   	ret    

8010876e <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010876e:	55                   	push   %ebp
8010876f:	89 e5                	mov    %esp,%ebp
80108771:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108774:	8b 45 10             	mov    0x10(%ebp),%eax
80108777:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010877a:	e9 87 00 00 00       	jmp    80108806 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
8010877f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108782:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108787:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010878a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010878d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108791:	8b 45 08             	mov    0x8(%ebp),%eax
80108794:	89 04 24             	mov    %eax,(%esp)
80108797:	e8 75 ff ff ff       	call   80108711 <uva2ka>
8010879c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010879f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801087a3:	75 07                	jne    801087ac <copyout+0x3e>
      return -1;
801087a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801087aa:	eb 69                	jmp    80108815 <copyout+0xa7>
    n = PGSIZE - (va - va0);
801087ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801087af:	8b 55 ec             	mov    -0x14(%ebp),%edx
801087b2:	29 c2                	sub    %eax,%edx
801087b4:	89 d0                	mov    %edx,%eax
801087b6:	05 00 10 00 00       	add    $0x1000,%eax
801087bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801087be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087c1:	3b 45 14             	cmp    0x14(%ebp),%eax
801087c4:	76 06                	jbe    801087cc <copyout+0x5e>
      n = len;
801087c6:	8b 45 14             	mov    0x14(%ebp),%eax
801087c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801087cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087cf:	8b 55 0c             	mov    0xc(%ebp),%edx
801087d2:	29 c2                	sub    %eax,%edx
801087d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801087d7:	01 c2                	add    %eax,%edx
801087d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087dc:	89 44 24 08          	mov    %eax,0x8(%esp)
801087e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801087e7:	89 14 24             	mov    %edx,(%esp)
801087ea:	e8 a8 ca ff ff       	call   80105297 <memmove>
    len -= n;
801087ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087f2:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801087f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087f8:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801087fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087fe:	05 00 10 00 00       	add    $0x1000,%eax
80108803:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108806:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010880a:	0f 85 6f ff ff ff    	jne    8010877f <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108810:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108815:	c9                   	leave  
80108816:	c3                   	ret    

80108817 <copyuvm_cow>:

// 3.4
pde_t*
copyuvm_cow(pde_t *pgdir, uint sz)
{
80108817:	55                   	push   %ebp
80108818:	89 e5                	mov    %esp,%ebp
8010881a:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i;

  if((d = setupkvm()) == 0)
8010881d:	e8 4f f5 ff ff       	call   80107d71 <setupkvm>
80108822:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108825:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108829:	75 0a                	jne    80108835 <copyuvm_cow+0x1e>
    return 0;
8010882b:	b8 00 00 00 00       	mov    $0x0,%eax
80108830:	e9 88 01 00 00       	jmp    801089bd <copyuvm_cow+0x1a6>

  for(i = PGSIZE; i < sz; i += PGSIZE) {
80108835:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
8010883c:	e9 55 01 00 00       	jmp    80108996 <copyuvm_cow+0x17f>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108844:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010884b:	00 
8010884c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108850:	8b 45 08             	mov    0x8(%ebp),%eax
80108853:	89 04 24             	mov    %eax,(%esp)
80108856:	e8 dc f3 ff ff       	call   80107c37 <walkpgdir>
8010885b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010885e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108862:	75 0c                	jne    80108870 <copyuvm_cow+0x59>
      panic("cowcopyuvm: pte should exist");
80108864:	c7 04 24 5a 93 10 80 	movl   $0x8010935a,(%esp)
8010886b:	e8 ca 7c ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
80108870:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108873:	8b 00                	mov    (%eax),%eax
80108875:	83 e0 01             	and    $0x1,%eax
80108878:	85 c0                	test   %eax,%eax
8010887a:	75 0c                	jne    80108888 <copyuvm_cow+0x71>
      panic("cowcopyuvm: page not present");
8010887c:	c7 04 24 77 93 10 80 	movl   $0x80109377,(%esp)
80108883:	e8 b2 7c ff ff       	call   8010053a <panic>

    pa = PTE_ADDR(*pte);
80108888:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010888b:	8b 00                	mov    (%eax),%eax
8010888d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108892:	89 45 e8             	mov    %eax,-0x18(%ebp)
    *pte = *pte | PTE_PCOUNT; // 3.4 indicate page belong to counter 
80108895:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108898:	8b 00                	mov    (%eax),%eax
8010889a:	80 cc 04             	or     $0x4,%ah
8010889d:	89 c2                	mov    %eax,%edx
8010889f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088a2:	89 10                	mov    %edx,(%eax)

	if((*pte & PTE_W) || (*pte & PTE_SHARED)) {
801088a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088a7:	8b 00                	mov    (%eax),%eax
801088a9:	83 e0 02             	and    $0x2,%eax
801088ac:	85 c0                	test   %eax,%eax
801088ae:	75 0e                	jne    801088be <copyuvm_cow+0xa7>
801088b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088b3:	8b 00                	mov    (%eax),%eax
801088b5:	25 00 02 00 00       	and    $0x200,%eax
801088ba:	85 c0                	test   %eax,%eax
801088bc:	74 52                	je     80108910 <copyuvm_cow+0xf9>
		if( mappages(d, (void*)i, PGSIZE, pa, PTE_SHARED | PTE_U) < 0 ) // insure page to be read only
801088be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088c1:	c7 44 24 10 04 02 00 	movl   $0x204,0x10(%esp)
801088c8:	00 
801088c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
801088cc:	89 54 24 0c          	mov    %edx,0xc(%esp)
801088d0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801088d7:	00 
801088d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801088dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088df:	89 04 24             	mov    %eax,(%esp)
801088e2:	e8 f2 f3 ff ff       	call   80107cd9 <mappages>
801088e7:	85 c0                	test   %eax,%eax
801088e9:	79 05                	jns    801088f0 <copyuvm_cow+0xd9>
			goto bad;
801088eb:	e9 bd 00 00 00       	jmp    801089ad <copyuvm_cow+0x196>
		*pte = *pte & ~PTE_W ; 
801088f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088f3:	8b 00                	mov    (%eax),%eax
801088f5:	83 e0 fd             	and    $0xfffffffd,%eax
801088f8:	89 c2                	mov    %eax,%edx
801088fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088fd:	89 10                	mov    %edx,(%eax)
        *pte = *pte | PTE_SHARED;
801088ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108902:	8b 00                	mov    (%eax),%eax
80108904:	80 cc 02             	or     $0x2,%ah
80108907:	89 c2                	mov    %eax,%edx
80108909:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010890c:	89 10                	mov    %edx,(%eax)
8010890e:	eb 2f                	jmp    8010893f <copyuvm_cow+0x128>
        

    } else { // page is already read only
		if(mappages(d, (void*)i, PGSIZE, pa , PTE_RONLY | PTE_U) < 0)
80108910:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108913:	c7 44 24 10 04 08 00 	movl   $0x804,0x10(%esp)
8010891a:	00 
8010891b:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010891e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108922:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108929:	00 
8010892a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010892e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108931:	89 04 24             	mov    %eax,(%esp)
80108934:	e8 a0 f3 ff ff       	call   80107cd9 <mappages>
80108939:	85 c0                	test   %eax,%eax
8010893b:	79 02                	jns    8010893f <copyuvm_cow+0x128>
			goto bad;
8010893d:	eb 6e                	jmp    801089ad <copyuvm_cow+0x196>
    }
        //////////////////////////////////
        // updating counter struct with new pointed page
        acquire(&counterStruct.lock);
8010893f:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80108946:	e8 29 c6 ff ff       	call   80104f74 <acquire>
        int *pce = &(counterStruct.pageCounter[pa/PGSIZE]); // Page Counter Enry \m/
8010894b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010894e:	c1 e8 0c             	shr    $0xc,%eax
80108951:	83 c0 0c             	add    $0xc,%eax
80108954:	c1 e0 02             	shl    $0x2,%eax
80108957:	05 20 37 11 80       	add    $0x80113720,%eax
8010895c:	83 c0 04             	add    $0x4,%eax
8010895f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

            if( (*pce) == 0) {
80108962:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108965:	8b 00                	mov    (%eax),%eax
80108967:	85 c0                	test   %eax,%eax
80108969:	75 0b                	jne    80108976 <copyuvm_cow+0x15f>
                *pce = 2; // first Initialize father and son pointing to page
8010896b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010896e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
80108974:	eb 0d                	jmp    80108983 <copyuvm_cow+0x16c>
            } else {
                (*pce) = (*pce) + 1;
80108976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108979:	8b 00                	mov    (%eax),%eax
8010897b:	8d 50 01             	lea    0x1(%eax),%edx
8010897e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108981:	89 10                	mov    %edx,(%eax)
            }
        release(&counterStruct.lock);
80108983:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
8010898a:	e8 47 c6 ff ff       	call   80104fd6 <release>
  uint pa, i;

  if((d = setupkvm()) == 0)
    return 0;

  for(i = PGSIZE; i < sz; i += PGSIZE) {
8010898f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108996:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108999:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010899c:	0f 82 9f fe ff ff    	jb     80108841 <copyuvm_cow+0x2a>
            }
        release(&counterStruct.lock);
        ///////////////////////////////////
        
  }
	asm("movl %cr3,%eax");
801089a2:	0f 20 d8             	mov    %cr3,%eax
	asm("movl %eax,%cr3");
801089a5:	0f 22 d8             	mov    %eax,%cr3
    return d;
801089a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089ab:	eb 10                	jmp    801089bd <copyuvm_cow+0x1a6>

bad:
  freevm(d);
801089ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089b0:	89 04 24             	mov    %eax,(%esp)
801089b3:	e8 22 fb ff ff       	call   801084da <freevm>
  return 0;
801089b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801089bd:	c9                   	leave  
801089be:	c3                   	ret    

801089bf <handler_pgflt>:

int
handler_pgflt() 
{
801089bf:	55                   	push   %ebp
801089c0:	89 e5                	mov    %esp,%ebp
801089c2:	83 ec 38             	sub    $0x38,%esp
	pte_t *pte ;
	char* mem;
	uint pa;
	void* fault_addr = (void*)rcr2();
801089c5:	e8 85 ed ff ff       	call   8010774f <rcr2>
801089ca:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if((pte = walkpgdir(proc->pgdir, (void *) fault_addr , 0)) == 0)
801089cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801089d3:	8b 40 04             	mov    0x4(%eax),%eax
801089d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801089dd:	00 
801089de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801089e1:	89 54 24 04          	mov    %edx,0x4(%esp)
801089e5:	89 04 24             	mov    %eax,(%esp)
801089e8:	e8 4a f2 ff ff       	call   80107c37 <walkpgdir>
801089ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
801089f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801089f4:	75 0c                	jne    80108a02 <handler_pgflt+0x43>
    	panic("pageFaultHandler: pte should exist");
801089f6:	c7 04 24 94 93 10 80 	movl   $0x80109394,(%esp)
801089fd:	e8 38 7b ff ff       	call   8010053a <panic>

    if(( (*pte & PTE_RONLY) != 0) ) {
80108a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a05:	8b 00                	mov    (%eax),%eax
80108a07:	25 00 08 00 00       	and    $0x800,%eax
80108a0c:	85 c0                	test   %eax,%eax
80108a0e:	74 0c                	je     80108a1c <handler_pgflt+0x5d>
        panic("try to write to READ ONLY");
80108a10:	c7 04 24 b7 93 10 80 	movl   $0x801093b7,(%esp)
80108a17:	e8 1e 7b ff ff       	call   8010053a <panic>
        return 0;
    }

    if(((*pte & PTE_SHARED) != 0)) { 
80108a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a1f:	8b 00                	mov    (%eax),%eax
80108a21:	25 00 02 00 00       	and    $0x200,%eax
80108a26:	85 c0                	test   %eax,%eax
80108a28:	0f 84 cf 00 00 00    	je     80108afd <handler_pgflt+0x13e>

		pa = PTE_ADDR(*pte);
80108a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a31:	8b 00                	mov    (%eax),%eax
80108a33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a38:	89 45 ec             	mov    %eax,-0x14(%ebp)

        acquire(&counterStruct.lock);
80108a3b:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80108a42:	e8 2d c5 ff ff       	call   80104f74 <acquire>
        int *pce = &(counterStruct.pageCounter[pa/PGSIZE]);
80108a47:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a4a:	c1 e8 0c             	shr    $0xc,%eax
80108a4d:	83 c0 0c             	add    $0xc,%eax
80108a50:	c1 e0 02             	shl    $0x2,%eax
80108a53:	05 20 37 11 80       	add    $0x80113720,%eax
80108a58:	83 c0 04             	add    $0x4,%eax
80108a5b:	89 45 e8             	mov    %eax,-0x18(%ebp)

        (*pce) = (*pce) - 1;
80108a5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a61:	8b 00                	mov    (%eax),%eax
80108a63:	8d 50 ff             	lea    -0x1(%eax),%edx
80108a66:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a69:	89 10                	mov    %edx,(%eax)
        if((*pce) == 1) {
80108a6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a6e:	8b 00                	mov    (%eax),%eax
80108a70:	83 f8 01             	cmp    $0x1,%eax
80108a73:	75 1e                	jne    80108a93 <handler_pgflt+0xd4>
            *pte = *pte & ~PTE_SHARED;
80108a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a78:	8b 00                	mov    (%eax),%eax
80108a7a:	80 e4 fd             	and    $0xfd,%ah
80108a7d:	89 c2                	mov    %eax,%edx
80108a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a82:	89 10                	mov    %edx,(%eax)
            *pte = *pte | PTE_W;
80108a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a87:	8b 00                	mov    (%eax),%eax
80108a89:	83 c8 02             	or     $0x2,%eax
80108a8c:	89 c2                	mov    %eax,%edx
80108a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a91:	89 10                	mov    %edx,(%eax)
        } 
        release(&counterStruct.lock);
80108a93:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80108a9a:	e8 37 c5 ff ff       	call   80104fd6 <release>

        if((mem = kalloc()) == 0)
80108a9f:	e8 4c a0 ff ff       	call   80102af0 <kalloc>
80108aa4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108aa7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108aab:	75 0c                	jne    80108ab9 <handler_pgflt+0xfa>
            panic("pageFaultHandler: can't kalloc mem\n");
80108aad:	c7 04 24 d4 93 10 80 	movl   $0x801093d4,(%esp)
80108ab4:	e8 81 7a ff ff       	call   8010053a <panic>

		memmove(mem, (char*)p2v(pa), PGSIZE);
80108ab9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108abc:	89 04 24             	mov    %eax,(%esp)
80108abf:	e8 b4 ec ff ff       	call   80107778 <p2v>
80108ac4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108acb:	00 
80108acc:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108ad3:	89 04 24             	mov    %eax,(%esp)
80108ad6:	e8 bc c7 ff ff       	call   80105297 <memmove>

		*pte = v2p(mem) | PTE_W | PTE_P | PTE_U; 
80108adb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108ade:	89 04 24             	mov    %eax,(%esp)
80108ae1:	e8 85 ec ff ff       	call   8010776b <v2p>
80108ae6:	83 c8 07             	or     $0x7,%eax
80108ae9:	89 c2                	mov    %eax,%edx
80108aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108aee:	89 10                	mov    %edx,(%eax)

		asm("movl %cr3,%eax");
80108af0:	0f 20 d8             	mov    %cr3,%eax
		asm("movl %eax,%cr3");
80108af3:	0f 22 d8             	mov    %eax,%cr3

		return 1;
80108af6:	b8 01 00 00 00       	mov    $0x1,%eax
80108afb:	eb 05                	jmp    80108b02 <handler_pgflt+0x143>

    } else {
    	return 0;
80108afd:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
80108b02:	c9                   	leave  
80108b03:	c3                   	ret    

80108b04 <printCounter>:

void
printCounter() 
{
80108b04:	55                   	push   %ebp
80108b05:	89 e5                	mov    %esp,%ebp
80108b07:	83 ec 28             	sub    $0x28,%esp
    int i; 
    for(i = 0 ; i < allPhysPageSize ; i++) {
80108b0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b11:	eb 3b                	jmp    80108b4e <printCounter+0x4a>
        if(counterStruct.pageCounter[i] == 0)
80108b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b16:	83 c0 0c             	add    $0xc,%eax
80108b19:	8b 04 85 24 37 11 80 	mov    -0x7feec8dc(,%eax,4),%eax
80108b20:	85 c0                	test   %eax,%eax
80108b22:	75 02                	jne    80108b26 <printCounter+0x22>
            continue;
80108b24:	eb 24                	jmp    80108b4a <printCounter+0x46>
        cprintf("pageCounter[%d] = %d\n",i,counterStruct.pageCounter[i]);
80108b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b29:	83 c0 0c             	add    $0xc,%eax
80108b2c:	8b 04 85 24 37 11 80 	mov    -0x7feec8dc(,%eax,4),%eax
80108b33:	89 44 24 08          	mov    %eax,0x8(%esp)
80108b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b3e:	c7 04 24 f8 93 10 80 	movl   $0x801093f8,(%esp)
80108b45:	e8 56 78 ff ff       	call   801003a0 <cprintf>

void
printCounter() 
{
    int i; 
    for(i = 0 ; i < allPhysPageSize ; i++) {
80108b4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108b4e:	a1 a0 c4 10 80       	mov    0x8010c4a0,%eax
80108b53:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80108b56:	7c bb                	jl     80108b13 <printCounter+0xf>
        if(counterStruct.pageCounter[i] == 0)
            continue;
        cprintf("pageCounter[%d] = %d\n",i,counterStruct.pageCounter[i]);
    }
}
80108b58:	c9                   	leave  
80108b59:	c3                   	ret    
