
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
80100028:	bc b0 d7 10 80       	mov    $0x8010d7b0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 13 39 10 80       	mov    $0x80103913,%eax
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
8010003a:	c7 44 24 04 f4 8c 10 	movl   $0x80108cf4,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 c0 d7 10 80 	movl   $0x8010d7c0,(%esp)
80100049:	e8 b0 55 00 00       	call   801055fe <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 f0 ec 10 80 e4 	movl   $0x8010ece4,0x8010ecf0
80100055:	ec 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 f4 ec 10 80 e4 	movl   $0x8010ece4,0x8010ecf4
8010005f:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 f4 d7 10 80 	movl   $0x8010d7f4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 f4 ec 10 80    	mov    0x8010ecf4,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c e4 ec 10 80 	movl   $0x8010ece4,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 f4 ec 10 80       	mov    0x8010ecf4,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 f4 ec 10 80       	mov    %eax,0x8010ecf4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 e4 ec 10 80 	cmpl   $0x8010ece4,-0xc(%ebp)
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
801000b6:	c7 04 24 c0 d7 10 80 	movl   $0x8010d7c0,(%esp)
801000bd:	e8 5d 55 00 00       	call   8010561f <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 f4 ec 10 80       	mov    0x8010ecf4,%eax
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
801000f3:	89 c2                	mov    %eax,%edx
801000f5:	83 ca 01             	or     $0x1,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 c0 d7 10 80 	movl   $0x8010d7c0,(%esp)
80100104:	e8 78 55 00 00       	call   80105681 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 c0 d7 10 	movl   $0x8010d7c0,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 15 52 00 00       	call   80105339 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 e4 ec 10 80 	cmpl   $0x8010ece4,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 f0 ec 10 80       	mov    0x8010ecf0,%eax
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
80100175:	c7 04 24 c0 d7 10 80 	movl   $0x8010d7c0,(%esp)
8010017c:	e8 00 55 00 00       	call   80105681 <release>
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
8010018f:	81 7d f4 e4 ec 10 80 	cmpl   $0x8010ece4,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 fb 8c 10 80 	movl   $0x80108cfb,(%esp)
8010019f:	e8 92 03 00 00       	call   80100536 <panic>
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
801001d3:	e8 01 2b 00 00       	call   80102cd9 <iderw>
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
801001ef:	c7 04 24 0c 8d 10 80 	movl   $0x80108d0c,(%esp)
801001f6:	e8 3b 03 00 00       	call   80100536 <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	89 c2                	mov    %eax,%edx
80100202:	83 ca 04             	or     $0x4,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 c4 2a 00 00       	call   80102cd9 <iderw>
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
80100229:	c7 04 24 13 8d 10 80 	movl   $0x80108d13,(%esp)
80100230:	e8 01 03 00 00       	call   80100536 <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 c0 d7 10 80 	movl   $0x8010d7c0,(%esp)
8010023c:	e8 de 53 00 00       	call   8010561f <acquire>

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
8010025f:	8b 15 f4 ec 10 80    	mov    0x8010ecf4,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c e4 ec 10 80 	movl   $0x8010ece4,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 f4 ec 10 80       	mov    0x8010ecf4,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 f4 ec 10 80       	mov    %eax,0x8010ecf4

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	89 c2                	mov    %eax,%edx
8010028f:	83 e2 fe             	and    $0xfffffffe,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 73 51 00 00       	call   80105415 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 c0 d7 10 80 	movl   $0x8010d7c0,(%esp)
801002a9:	e8 d3 53 00 00       	call   80105681 <release>
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
801002b3:	53                   	push   %ebx
801002b4:	83 ec 14             	sub    $0x14,%esp
801002b7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ba:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002be:	8b 55 e8             	mov    -0x18(%ebp),%edx
801002c1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801002c5:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
801002c9:	ec                   	in     (%dx),%al
801002ca:	88 c3                	mov    %al,%bl
801002cc:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801002cf:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801002d2:	83 c4 14             	add    $0x14,%esp
801002d5:	5b                   	pop    %ebx
801002d6:	5d                   	pop    %ebp
801002d7:	c3                   	ret    

801002d8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002d8:	55                   	push   %ebp
801002d9:	89 e5                	mov    %esp,%ebp
801002db:	83 ec 08             	sub    $0x8,%esp
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	8b 55 0c             	mov    0xc(%ebp),%edx
801002e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801002e8:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002eb:	8a 45 f8             	mov    -0x8(%ebp),%al
801002ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
801002f1:	ee                   	out    %al,(%dx)
}
801002f2:	c9                   	leave  
801002f3:	c3                   	ret    

801002f4 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002f4:	55                   	push   %ebp
801002f5:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002f7:	fa                   	cli    
}
801002f8:	5d                   	pop    %ebp
801002f9:	c3                   	ret    

801002fa <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002fa:	55                   	push   %ebp
801002fb:	89 e5                	mov    %esp,%ebp
801002fd:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100300:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100304:	74 1c                	je     80100322 <printint+0x28>
80100306:	8b 45 08             	mov    0x8(%ebp),%eax
80100309:	c1 e8 1f             	shr    $0x1f,%eax
8010030c:	0f b6 c0             	movzbl %al,%eax
8010030f:	89 45 10             	mov    %eax,0x10(%ebp)
80100312:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100316:	74 0a                	je     80100322 <printint+0x28>
    x = -xx;
80100318:	8b 45 08             	mov    0x8(%ebp),%eax
8010031b:	f7 d8                	neg    %eax
8010031d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100320:	eb 06                	jmp    80100328 <printint+0x2e>
  else
    x = xx;
80100322:	8b 45 08             	mov    0x8(%ebp),%eax
80100325:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010032f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100332:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100335:	ba 00 00 00 00       	mov    $0x0,%edx
8010033a:	f7 f1                	div    %ecx
8010033c:	89 d0                	mov    %edx,%eax
8010033e:	8a 80 04 a0 10 80    	mov    -0x7fef5ffc(%eax),%al
80100344:	8d 4d e0             	lea    -0x20(%ebp),%ecx
80100347:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010034a:	01 ca                	add    %ecx,%edx
8010034c:	88 02                	mov    %al,(%edx)
8010034e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
80100351:	8b 55 0c             	mov    0xc(%ebp),%edx
80100354:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035a:	ba 00 00 00 00       	mov    $0x0,%edx
8010035f:	f7 75 d4             	divl   -0x2c(%ebp)
80100362:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100365:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100369:	75 c4                	jne    8010032f <printint+0x35>

  if(sign)
8010036b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010036f:	74 25                	je     80100396 <printint+0x9c>
    buf[i++] = '-';
80100371:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100377:	01 d0                	add    %edx,%eax
80100379:	c6 00 2d             	movb   $0x2d,(%eax)
8010037c:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
8010037f:	eb 15                	jmp    80100396 <printint+0x9c>
    consputc(buf[i]);
80100381:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100387:	01 d0                	add    %edx,%eax
80100389:	8a 00                	mov    (%eax),%al
8010038b:	0f be c0             	movsbl %al,%eax
8010038e:	89 04 24             	mov    %eax,(%esp)
80100391:	e8 eb 03 00 00       	call   80100781 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
80100396:	ff 4d f4             	decl   -0xc(%ebp)
80100399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010039d:	79 e2                	jns    80100381 <printint+0x87>
    consputc(buf[i]);
}
8010039f:	c9                   	leave  
801003a0:	c3                   	ret    

801003a1 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a1:	55                   	push   %ebp
801003a2:	89 e5                	mov    %esp,%ebp
801003a4:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a7:	a1 f4 c5 10 80       	mov    0x8010c5f4,%eax
801003ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b3:	74 0c                	je     801003c1 <cprintf+0x20>
    acquire(&cons.lock);
801003b5:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
801003bc:	e8 5e 52 00 00       	call   8010561f <acquire>

  if (fmt == 0)
801003c1:	8b 45 08             	mov    0x8(%ebp),%eax
801003c4:	85 c0                	test   %eax,%eax
801003c6:	75 0c                	jne    801003d4 <cprintf+0x33>
    panic("null fmt");
801003c8:	c7 04 24 1a 8d 10 80 	movl   $0x80108d1a,(%esp)
801003cf:	e8 62 01 00 00       	call   80100536 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d4:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e1:	e9 1a 01 00 00       	jmp    80100500 <cprintf+0x15f>
    if(c != '%'){
801003e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003ea:	74 10                	je     801003fc <cprintf+0x5b>
      consputc(c);
801003ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ef:	89 04 24             	mov    %eax,(%esp)
801003f2:	e8 8a 03 00 00       	call   80100781 <consputc>
      continue;
801003f7:	e9 01 01 00 00       	jmp    801004fd <cprintf+0x15c>
    }
    c = fmt[++i] & 0xff;
801003fc:	8b 55 08             	mov    0x8(%ebp),%edx
801003ff:	ff 45 f4             	incl   -0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	8a 00                	mov    (%eax),%al
80100409:	0f be c0             	movsbl %al,%eax
8010040c:	25 ff 00 00 00       	and    $0xff,%eax
80100411:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100414:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100418:	0f 84 03 01 00 00    	je     80100521 <cprintf+0x180>
      break;
    switch(c){
8010041e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100421:	83 f8 70             	cmp    $0x70,%eax
80100424:	74 4d                	je     80100473 <cprintf+0xd2>
80100426:	83 f8 70             	cmp    $0x70,%eax
80100429:	7f 13                	jg     8010043e <cprintf+0x9d>
8010042b:	83 f8 25             	cmp    $0x25,%eax
8010042e:	0f 84 a3 00 00 00    	je     801004d7 <cprintf+0x136>
80100434:	83 f8 64             	cmp    $0x64,%eax
80100437:	74 14                	je     8010044d <cprintf+0xac>
80100439:	e9 a7 00 00 00       	jmp    801004e5 <cprintf+0x144>
8010043e:	83 f8 73             	cmp    $0x73,%eax
80100441:	74 53                	je     80100496 <cprintf+0xf5>
80100443:	83 f8 78             	cmp    $0x78,%eax
80100446:	74 2b                	je     80100473 <cprintf+0xd2>
80100448:	e9 98 00 00 00       	jmp    801004e5 <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010044d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100450:	8b 00                	mov    (%eax),%eax
80100452:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100456:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010045d:	00 
8010045e:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100465:	00 
80100466:	89 04 24             	mov    %eax,(%esp)
80100469:	e8 8c fe ff ff       	call   801002fa <printint>
      break;
8010046e:	e9 8a 00 00 00       	jmp    801004fd <cprintf+0x15c>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100473:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100476:	8b 00                	mov    (%eax),%eax
80100478:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
8010047c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100483:	00 
80100484:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
8010048b:	00 
8010048c:	89 04 24             	mov    %eax,(%esp)
8010048f:	e8 66 fe ff ff       	call   801002fa <printint>
      break;
80100494:	eb 67                	jmp    801004fd <cprintf+0x15c>
    case 's':
      if((s = (char*)*argp++) == 0)
80100496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100499:	8b 00                	mov    (%eax),%eax
8010049b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010049e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004a2:	0f 94 c0             	sete   %al
801004a5:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004a9:	84 c0                	test   %al,%al
801004ab:	74 1e                	je     801004cb <cprintf+0x12a>
        s = "(null)";
801004ad:	c7 45 ec 23 8d 10 80 	movl   $0x80108d23,-0x14(%ebp)
      for(; *s; s++)
801004b4:	eb 15                	jmp    801004cb <cprintf+0x12a>
        consputc(*s);
801004b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004b9:	8a 00                	mov    (%eax),%al
801004bb:	0f be c0             	movsbl %al,%eax
801004be:	89 04 24             	mov    %eax,(%esp)
801004c1:	e8 bb 02 00 00       	call   80100781 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004c6:	ff 45 ec             	incl   -0x14(%ebp)
801004c9:	eb 01                	jmp    801004cc <cprintf+0x12b>
801004cb:	90                   	nop
801004cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004cf:	8a 00                	mov    (%eax),%al
801004d1:	84 c0                	test   %al,%al
801004d3:	75 e1                	jne    801004b6 <cprintf+0x115>
        consputc(*s);
      break;
801004d5:	eb 26                	jmp    801004fd <cprintf+0x15c>
    case '%':
      consputc('%');
801004d7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004de:	e8 9e 02 00 00       	call   80100781 <consputc>
      break;
801004e3:	eb 18                	jmp    801004fd <cprintf+0x15c>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004e5:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ec:	e8 90 02 00 00       	call   80100781 <consputc>
      consputc(c);
801004f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f4:	89 04 24             	mov    %eax,(%esp)
801004f7:	e8 85 02 00 00       	call   80100781 <consputc>
      break;
801004fc:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801004fd:	ff 45 f4             	incl   -0xc(%ebp)
80100500:	8b 55 08             	mov    0x8(%ebp),%edx
80100503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100506:	01 d0                	add    %edx,%eax
80100508:	8a 00                	mov    (%eax),%al
8010050a:	0f be c0             	movsbl %al,%eax
8010050d:	25 ff 00 00 00       	and    $0xff,%eax
80100512:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100515:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100519:	0f 85 c7 fe ff ff    	jne    801003e6 <cprintf+0x45>
8010051f:	eb 01                	jmp    80100522 <cprintf+0x181>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100521:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100522:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100526:	74 0c                	je     80100534 <cprintf+0x193>
    release(&cons.lock);
80100528:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010052f:	e8 4d 51 00 00       	call   80105681 <release>
}
80100534:	c9                   	leave  
80100535:	c3                   	ret    

80100536 <panic>:

void
panic(char *s)
{
80100536:	55                   	push   %ebp
80100537:	89 e5                	mov    %esp,%ebp
80100539:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
8010053c:	e8 b3 fd ff ff       	call   801002f4 <cli>
  cons.locking = 0;
80100541:	c7 05 f4 c5 10 80 00 	movl   $0x0,0x8010c5f4
80100548:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100551:	8a 00                	mov    (%eax),%al
80100553:	0f b6 c0             	movzbl %al,%eax
80100556:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055a:	c7 04 24 2a 8d 10 80 	movl   $0x80108d2a,(%esp)
80100561:	e8 3b fe ff ff       	call   801003a1 <cprintf>
  cprintf(s);
80100566:	8b 45 08             	mov    0x8(%ebp),%eax
80100569:	89 04 24             	mov    %eax,(%esp)
8010056c:	e8 30 fe ff ff       	call   801003a1 <cprintf>
  cprintf("\n");
80100571:	c7 04 24 39 8d 10 80 	movl   $0x80108d39,(%esp)
80100578:	e8 24 fe ff ff       	call   801003a1 <cprintf>
  getcallerpcs(&s, pcs);
8010057d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100580:	89 44 24 04          	mov    %eax,0x4(%esp)
80100584:	8d 45 08             	lea    0x8(%ebp),%eax
80100587:	89 04 24             	mov    %eax,(%esp)
8010058a:	e8 41 51 00 00       	call   801056d0 <getcallerpcs>
  for(i=0; i<10; i++)
8010058f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100596:	eb 1a                	jmp    801005b2 <panic+0x7c>
    cprintf(" %p", pcs[i]);
80100598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010059b:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010059f:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a3:	c7 04 24 3b 8d 10 80 	movl   $0x80108d3b,(%esp)
801005aa:	e8 f2 fd ff ff       	call   801003a1 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005af:	ff 45 f4             	incl   -0xc(%ebp)
801005b2:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005b6:	7e e0                	jle    80100598 <panic+0x62>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005b8:	c7 05 b4 c5 10 80 01 	movl   $0x1,0x8010c5b4
801005bf:	00 00 00 
  for(;;)
    ;
801005c2:	eb fe                	jmp    801005c2 <panic+0x8c>

801005c4 <cgaputc>:
#define KEY_DN    0xE3
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005c4:	55                   	push   %ebp
801005c5:	89 e5                	mov    %esp,%ebp
801005c7:	83 ec 28             	sub    $0x28,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005ca:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d1:	00 
801005d2:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005d9:	e8 fa fc ff ff       	call   801002d8 <outb>
  pos = inb(CRTPORT+1) << 8;
801005de:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005e5:	e8 c6 fc ff ff       	call   801002b0 <inb>
801005ea:	0f b6 c0             	movzbl %al,%eax
801005ed:	c1 e0 08             	shl    $0x8,%eax
801005f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f3:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
801005fa:	00 
801005fb:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100602:	e8 d1 fc ff ff       	call   801002d8 <outb>
  pos |= inb(CRTPORT+1);
80100607:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010060e:	e8 9d fc ff ff       	call   801002b0 <inb>
80100613:	0f b6 c0             	movzbl %al,%eax
80100616:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100619:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010061d:	75 1d                	jne    8010063c <cgaputc+0x78>
    pos += 80 - pos%80;
8010061f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100622:	b9 50 00 00 00       	mov    $0x50,%ecx
80100627:	99                   	cltd   
80100628:	f7 f9                	idiv   %ecx
8010062a:	89 d0                	mov    %edx,%eax
8010062c:	ba 50 00 00 00       	mov    $0x50,%edx
80100631:	89 d1                	mov    %edx,%ecx
80100633:	29 c1                	sub    %eax,%ecx
80100635:	89 c8                	mov    %ecx,%eax
80100637:	01 45 f4             	add    %eax,-0xc(%ebp)
8010063a:	eb 53                	jmp    8010068f <cgaputc+0xcb>
  else if(c == BACKSPACE){
8010063c:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100643:	75 0b                	jne    80100650 <cgaputc+0x8c>
    if(pos > 0) --pos;
80100645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100649:	7e 44                	jle    8010068f <cgaputc+0xcb>
8010064b:	ff 4d f4             	decl   -0xc(%ebp)
8010064e:	eb 3f                	jmp    8010068f <cgaputc+0xcb>
  }
  else if(c == KEY_LF)
80100650:	81 7d 08 e4 00 00 00 	cmpl   $0xe4,0x8(%ebp)
80100657:	75 0b                	jne    80100664 <cgaputc+0xa0>
  {
    if(pos > 0) --pos;
80100659:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010065d:	7e 30                	jle    8010068f <cgaputc+0xcb>
8010065f:	ff 4d f4             	decl   -0xc(%ebp)
80100662:	eb 2b                	jmp    8010068f <cgaputc+0xcb>
  }
  else if(c == KEY_RT){
80100664:	81 7d 08 e5 00 00 00 	cmpl   $0xe5,0x8(%ebp)
8010066b:	75 05                	jne    80100672 <cgaputc+0xae>
    ++pos;
8010066d:	ff 45 f4             	incl   -0xc(%ebp)
80100670:	eb 1d                	jmp    8010068f <cgaputc+0xcb>
  }
  else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100672:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100677:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010067a:	d1 e2                	shl    %edx
8010067c:	01 c2                	add    %eax,%edx
8010067e:	8b 45 08             	mov    0x8(%ebp),%eax
80100681:	25 ff 00 00 00       	and    $0xff,%eax
80100686:	80 cc 07             	or     $0x7,%ah
80100689:	66 89 02             	mov    %ax,(%edx)
8010068c:	ff 45 f4             	incl   -0xc(%ebp)
  
  if((pos/80) >= 24){  // Scroll up.
8010068f:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100696:	7e 53                	jle    801006eb <cgaputc+0x127>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100698:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010069d:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006a3:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006a8:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006af:	00 
801006b0:	89 54 24 04          	mov    %edx,0x4(%esp)
801006b4:	89 04 24             	mov    %eax,(%esp)
801006b7:	e8 82 52 00 00       	call   8010593e <memmove>
    pos -= 80;
801006bc:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006c0:	b8 80 07 00 00       	mov    $0x780,%eax
801006c5:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c8:	d1 e0                	shl    %eax
801006ca:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
801006d0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006d3:	d1 e1                	shl    %ecx
801006d5:	01 ca                	add    %ecx,%edx
801006d7:	89 44 24 08          	mov    %eax,0x8(%esp)
801006db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006e2:	00 
801006e3:	89 14 24             	mov    %edx,(%esp)
801006e6:	e8 87 51 00 00       	call   80105872 <memset>
  }
  
  outb(CRTPORT, 14);
801006eb:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006f2:	00 
801006f3:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006fa:	e8 d9 fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT+1, pos>>8);
801006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100702:	c1 f8 08             	sar    $0x8,%eax
80100705:	0f b6 c0             	movzbl %al,%eax
80100708:	89 44 24 04          	mov    %eax,0x4(%esp)
8010070c:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100713:	e8 c0 fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT, 15);
80100718:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071f:	00 
80100720:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100727:	e8 ac fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT+1, pos);
8010072c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072f:	0f b6 c0             	movzbl %al,%eax
80100732:	89 44 24 04          	mov    %eax,0x4(%esp)
80100736:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010073d:	e8 96 fb ff ff       	call   801002d8 <outb>
  if(c == BACKSPACE)
80100742:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100749:	75 13                	jne    8010075e <cgaputc+0x19a>
    crt[pos] = ' ' | 0x0700;
8010074b:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100750:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100753:	d1 e2                	shl    %edx
80100755:	01 d0                	add    %edx,%eax
80100757:	66 c7 00 20 07       	movw   $0x720,(%eax)
8010075c:	eb 21                	jmp    8010077f <cgaputc+0x1bb>
  else
    crt[pos] = crt[pos] | 0x0700;
8010075e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100763:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100766:	d1 e2                	shl    %edx
80100768:	01 c2                	add    %eax,%edx
8010076a:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010076f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100772:	d1 e1                	shl    %ecx
80100774:	01 c8                	add    %ecx,%eax
80100776:	66 8b 00             	mov    (%eax),%ax
80100779:	80 cc 07             	or     $0x7,%ah
8010077c:	66 89 02             	mov    %ax,(%edx)
}
8010077f:	c9                   	leave  
80100780:	c3                   	ret    

80100781 <consputc>:

void
consputc(int c)
{
80100781:	55                   	push   %ebp
80100782:	89 e5                	mov    %esp,%ebp
80100784:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100787:	a1 b4 c5 10 80       	mov    0x8010c5b4,%eax
8010078c:	85 c0                	test   %eax,%eax
8010078e:	74 07                	je     80100797 <consputc+0x16>
    cli();
80100790:	e8 5f fb ff ff       	call   801002f4 <cli>
    for(;;)
      ;
80100795:	eb fe                	jmp    80100795 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100797:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010079e:	75 26                	jne    801007c6 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007a0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007a7:	e8 ce 6b 00 00       	call   8010737a <uartputc>
801007ac:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801007b3:	e8 c2 6b 00 00       	call   8010737a <uartputc>
801007b8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007bf:	e8 b6 6b 00 00       	call   8010737a <uartputc>
801007c4:	eb 1d                	jmp    801007e3 <consputc+0x62>
  }
  else if(c == KEY_LF || c == KEY_RT)
801007c6:	81 7d 08 e4 00 00 00 	cmpl   $0xe4,0x8(%ebp)
801007cd:	74 14                	je     801007e3 <consputc+0x62>
801007cf:	81 7d 08 e5 00 00 00 	cmpl   $0xe5,0x8(%ebp)
801007d6:	74 0b                	je     801007e3 <consputc+0x62>
  {

  }
  else
    uartputc(c);
801007d8:	8b 45 08             	mov    0x8(%ebp),%eax
801007db:	89 04 24             	mov    %eax,(%esp)
801007de:	e8 97 6b 00 00       	call   8010737a <uartputc>
  cgaputc(c);
801007e3:	8b 45 08             	mov    0x8(%ebp),%eax
801007e6:	89 04 24             	mov    %eax,(%esp)
801007e9:	e8 d6 fd ff ff       	call   801005c4 <cgaputc>
}
801007ee:	c9                   	leave  
801007ef:	c3                   	ret    

801007f0 <consoleintr>:

static int leftClicksCounter = 0;

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	83 ec 28             	sub    $0x28,%esp
  int c;
  int i = 0;
801007f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&input.lock);
801007fd:	c7 04 24 00 ef 10 80 	movl   $0x8010ef00,(%esp)
80100804:	e8 16 4e 00 00       	call   8010561f <acquire>
  while((c = getc()) >= 0){
80100809:	e9 2c 04 00 00       	jmp    80100c3a <consoleintr+0x44a>
    switch(c){
8010080e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100811:	83 f8 7f             	cmp    $0x7f,%eax
80100814:	0f 84 a9 00 00 00    	je     801008c3 <consoleintr+0xd3>
8010081a:	83 f8 7f             	cmp    $0x7f,%eax
8010081d:	7f 18                	jg     80100837 <consoleintr+0x47>
8010081f:	83 f8 10             	cmp    $0x10,%eax
80100822:	74 50                	je     80100874 <consoleintr+0x84>
80100824:	83 f8 15             	cmp    $0x15,%eax
80100827:	74 6e                	je     80100897 <consoleintr+0xa7>
80100829:	83 f8 08             	cmp    $0x8,%eax
8010082c:	0f 84 91 00 00 00    	je     801008c3 <consoleintr+0xd3>
80100832:	e9 3d 02 00 00       	jmp    80100a74 <consoleintr+0x284>
80100837:	3d e3 00 00 00       	cmp    $0xe3,%eax
8010083c:	0f 84 dc 01 00 00    	je     80100a1e <consoleintr+0x22e>
80100842:	3d e3 00 00 00       	cmp    $0xe3,%eax
80100847:	7f 10                	jg     80100859 <consoleintr+0x69>
80100849:	3d e2 00 00 00       	cmp    $0xe2,%eax
8010084e:	0f 84 19 01 00 00    	je     8010096d <consoleintr+0x17d>
80100854:	e9 1b 02 00 00       	jmp    80100a74 <consoleintr+0x284>
80100859:	3d e4 00 00 00       	cmp    $0xe4,%eax
8010085e:	0f 84 8e 00 00 00    	je     801008f2 <consoleintr+0x102>
80100864:	3d e5 00 00 00       	cmp    $0xe5,%eax
80100869:	0f 84 bd 00 00 00    	je     8010092c <consoleintr+0x13c>
8010086f:	e9 00 02 00 00       	jmp    80100a74 <consoleintr+0x284>
    case C('P'):  // Process listing.
      procdump();
80100874:	e8 42 4c 00 00       	call   801054bb <procdump>
      break;
80100879:	e9 bc 03 00 00       	jmp    80100c3a <consoleintr+0x44a>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010087e:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
80100883:	48                   	dec    %eax
80100884:	a3 bc ef 10 80       	mov    %eax,0x8010efbc
        consputc(BACKSPACE);
80100889:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100890:	e8 ec fe ff ff       	call   80100781 <consputc>
80100895:	eb 01                	jmp    80100898 <consoleintr+0xa8>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100897:	90                   	nop
80100898:	8b 15 bc ef 10 80    	mov    0x8010efbc,%edx
8010089e:	a1 b8 ef 10 80       	mov    0x8010efb8,%eax
801008a3:	39 c2                	cmp    %eax,%edx
801008a5:	0f 84 79 03 00 00    	je     80100c24 <consoleintr+0x434>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008ab:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
801008b0:	48                   	dec    %eax
801008b1:	83 e0 7f             	and    $0x7f,%eax
801008b4:	8a 80 34 ef 10 80    	mov    -0x7fef10cc(%eax),%al
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008ba:	3c 0a                	cmp    $0xa,%al
801008bc:	75 c0                	jne    8010087e <consoleintr+0x8e>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008be:	e9 61 03 00 00       	jmp    80100c24 <consoleintr+0x434>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w)
801008c3:	8b 15 bc ef 10 80    	mov    0x8010efbc,%edx
801008c9:	a1 b8 ef 10 80       	mov    0x8010efb8,%eax
801008ce:	39 c2                	cmp    %eax,%edx
801008d0:	0f 84 51 03 00 00    	je     80100c27 <consoleintr+0x437>
      {
        input.e--;
801008d6:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
801008db:	48                   	dec    %eax
801008dc:	a3 bc ef 10 80       	mov    %eax,0x8010efbc
        consputc(BACKSPACE);
801008e1:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801008e8:	e8 94 fe ff ff       	call   80100781 <consputc>
      }
      break;
801008ed:	e9 35 03 00 00       	jmp    80100c27 <consoleintr+0x437>
    case KEY_LF:               // left arrow
      if(input.e != input.w)
801008f2:	8b 15 bc ef 10 80    	mov    0x8010efbc,%edx
801008f8:	a1 b8 ef 10 80       	mov    0x8010efb8,%eax
801008fd:	39 c2                	cmp    %eax,%edx
801008ff:	0f 84 25 03 00 00    	je     80100c2a <consoleintr+0x43a>
      {
        consputc(KEY_LF);
80100905:	c7 04 24 e4 00 00 00 	movl   $0xe4,(%esp)
8010090c:	e8 70 fe ff ff       	call   80100781 <consputc>
        leftClicksCounter++;
80100911:	a1 f8 c5 10 80       	mov    0x8010c5f8,%eax
80100916:	40                   	inc    %eax
80100917:	a3 f8 c5 10 80       	mov    %eax,0x8010c5f8
        input.e--;
8010091c:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
80100921:	48                   	dec    %eax
80100922:	a3 bc ef 10 80       	mov    %eax,0x8010efbc
      }
      break;
80100927:	e9 fe 02 00 00       	jmp    80100c2a <consoleintr+0x43a>
    case KEY_RT:               // right arrow
      if(leftClicksCounter > 0)
8010092c:	a1 f8 c5 10 80       	mov    0x8010c5f8,%eax
80100931:	85 c0                	test   %eax,%eax
80100933:	0f 8e f4 02 00 00    	jle    80100c2d <consoleintr+0x43d>
      {
        consputc(KEY_RT);
80100939:	c7 04 24 e5 00 00 00 	movl   $0xe5,(%esp)
80100940:	e8 3c fe ff ff       	call   80100781 <consputc>
        leftClicksCounter--;
80100945:	a1 f8 c5 10 80       	mov    0x8010c5f8,%eax
8010094a:	48                   	dec    %eax
8010094b:	a3 f8 c5 10 80       	mov    %eax,0x8010c5f8
        input.e++;
80100950:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
80100955:	40                   	inc    %eax
80100956:	a3 bc ef 10 80       	mov    %eax,0x8010efbc
        input.e = input.e % INPUT_BUF;
8010095b:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
80100960:	83 e0 7f             	and    $0x7f,%eax
80100963:	a3 bc ef 10 80       	mov    %eax,0x8010efbc
      }
      break;
80100968:	e9 c0 02 00 00       	jmp    80100c2d <consoleintr+0x43d>
    case KEY_UP :

      if (historyCounter == 0)
8010096d:	a1 ac c5 10 80       	mov    0x8010c5ac,%eax
80100972:	85 c0                	test   %eax,%eax
80100974:	0f 84 b6 02 00 00    	je     80100c30 <consoleintr+0x440>
          break;
      if (!historyFlag) {
8010097a:	a1 a8 c5 10 80       	mov    0x8010c5a8,%eax
8010097f:	85 c0                	test   %eax,%eax
80100981:	75 1f                	jne    801009a2 <consoleintr+0x1b2>
          killLine();
80100983:	e8 d2 02 00 00       	call   80100c5a <killLine>
          loadHistoryToScreen(c);  
80100988:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010098b:	89 04 24             	mov    %eax,(%esp)
8010098e:	e8 0a 03 00 00       	call   80100c9d <loadHistoryToScreen>
          historyFlag= 1;
80100993:	c7 05 a8 c5 10 80 01 	movl   $0x1,0x8010c5a8
8010099a:	00 00 00 
          break;
8010099d:	e9 98 02 00 00       	jmp    80100c3a <consoleintr+0x44a>
      }
      else if (history_index_pos != 0)
801009a2:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
801009a7:	85 c0                	test   %eax,%eax
801009a9:	74 21                	je     801009cc <consoleintr+0x1dc>
      {
          history_index_pos--;
801009ab:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
801009b0:	48                   	dec    %eax
801009b1:	a3 a4 c5 10 80       	mov    %eax,0x8010c5a4
          history_index_pos = history_index_pos % MAX_HISTORY_LENGTH;
801009b6:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
801009bb:	b9 14 00 00 00       	mov    $0x14,%ecx
801009c0:	99                   	cltd   
801009c1:	f7 f9                	idiv   %ecx
801009c3:	89 d0                	mov    %edx,%eax
801009c5:	a3 a4 c5 10 80       	mov    %eax,0x8010c5a4
801009ca:	eb 3d                	jmp    80100a09 <consoleintr+0x219>

      }
      else  if (history_index_pos == 0 && 
801009cc:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
801009d1:	85 c0                	test   %eax,%eax
801009d3:	75 16                	jne    801009eb <consoleintr+0x1fb>
                 historyCounter == MAX_HISTORY_LENGTH)
801009d5:	a1 ac c5 10 80       	mov    0x8010c5ac,%eax
      {
          history_index_pos--;
          history_index_pos = history_index_pos % MAX_HISTORY_LENGTH;

      }
      else  if (history_index_pos == 0 && 
801009da:	83 f8 14             	cmp    $0x14,%eax
801009dd:	75 0c                	jne    801009eb <consoleintr+0x1fb>
                 historyCounter == MAX_HISTORY_LENGTH)
      {
          history_index_pos = MAX_HISTORY_LENGTH -1;
801009df:	c7 05 a4 c5 10 80 13 	movl   $0x13,0x8010c5a4
801009e6:	00 00 00 
801009e9:	eb 1e                	jmp    80100a09 <consoleintr+0x219>

      } else if (history_index_pos == 0 && 
801009eb:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
801009f0:	85 c0                	test   %eax,%eax
801009f2:	75 15                	jne    80100a09 <consoleintr+0x219>
                 historyCounter != MAX_HISTORY_LENGTH)
801009f4:	a1 ac c5 10 80       	mov    0x8010c5ac,%eax
      else  if (history_index_pos == 0 && 
                 historyCounter == MAX_HISTORY_LENGTH)
      {
          history_index_pos = MAX_HISTORY_LENGTH -1;

      } else if (history_index_pos == 0 && 
801009f9:	83 f8 14             	cmp    $0x14,%eax
801009fc:	74 0b                	je     80100a09 <consoleintr+0x219>
                 historyCounter != MAX_HISTORY_LENGTH)
      {
          history_index_pos = history_index -1;
801009fe:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
80100a03:	48                   	dec    %eax
80100a04:	a3 a4 c5 10 80       	mov    %eax,0x8010c5a4
      }
          killLine();
80100a09:	e8 4c 02 00 00       	call   80100c5a <killLine>
          loadHistoryToScreen(c);  
80100a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100a11:	89 04 24             	mov    %eax,(%esp)
80100a14:	e8 84 02 00 00       	call   80100c9d <loadHistoryToScreen>
      break;
80100a19:	e9 1c 02 00 00       	jmp    80100c3a <consoleintr+0x44a>
    
    case KEY_DN :
      if (historyFlag && history_index_pos != history_index - 1)
80100a1e:	a1 a8 c5 10 80       	mov    0x8010c5a8,%eax
80100a23:	85 c0                	test   %eax,%eax
80100a25:	0f 84 08 02 00 00    	je     80100c33 <consoleintr+0x443>
80100a2b:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
80100a30:	8d 50 ff             	lea    -0x1(%eax),%edx
80100a33:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
80100a38:	39 c2                	cmp    %eax,%edx
80100a3a:	0f 84 f3 01 00 00    	je     80100c33 <consoleintr+0x443>
      {
          history_index_pos++;
80100a40:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
80100a45:	40                   	inc    %eax
80100a46:	a3 a4 c5 10 80       	mov    %eax,0x8010c5a4
          history_index_pos = history_index_pos % MAX_HISTORY_LENGTH;
80100a4b:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
80100a50:	b9 14 00 00 00       	mov    $0x14,%ecx
80100a55:	99                   	cltd   
80100a56:	f7 f9                	idiv   %ecx
80100a58:	89 d0                	mov    %edx,%eax
80100a5a:	a3 a4 c5 10 80       	mov    %eax,0x8010c5a4
          killLine();
80100a5f:	e8 f6 01 00 00       	call   80100c5a <killLine>
          loadHistoryToScreen(c);  
80100a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100a67:	89 04 24             	mov    %eax,(%esp)
80100a6a:	e8 2e 02 00 00       	call   80100c9d <loadHistoryToScreen>
      }
      break;
80100a6f:	e9 bf 01 00 00       	jmp    80100c33 <consoleintr+0x443>
    
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a78:	0f 84 b8 01 00 00    	je     80100c36 <consoleintr+0x446>
80100a7e:	8b 15 bc ef 10 80    	mov    0x8010efbc,%edx
80100a84:	a1 b4 ef 10 80       	mov    0x8010efb4,%eax
80100a89:	89 d1                	mov    %edx,%ecx
80100a8b:	29 c1                	sub    %eax,%ecx
80100a8d:	89 c8                	mov    %ecx,%eax
80100a8f:	83 f8 7f             	cmp    $0x7f,%eax
80100a92:	0f 87 9e 01 00 00    	ja     80100c36 <consoleintr+0x446>
        c = (c == '\r') ? '\n' : c;
80100a98:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80100a9c:	74 05                	je     80100aa3 <consoleintr+0x2b3>
80100a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100aa1:	eb 05                	jmp    80100aa8 <consoleintr+0x2b8>
80100aa3:	b8 0a 00 00 00       	mov    $0xa,%eax
80100aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)

        if(c == '\n') //fix the input.e index when enter is pressed and resets leftCount
80100aab:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100aaf:	75 21                	jne    80100ad2 <consoleintr+0x2e2>
        {
            input.e = (input.e + leftClicksCounter) % INPUT_BUF;
80100ab1:	8b 15 bc ef 10 80    	mov    0x8010efbc,%edx
80100ab7:	a1 f8 c5 10 80       	mov    0x8010c5f8,%eax
80100abc:	01 d0                	add    %edx,%eax
80100abe:	83 e0 7f             	and    $0x7f,%eax
80100ac1:	a3 bc ef 10 80       	mov    %eax,0x8010efbc
            leftClicksCounter = 0;
80100ac6:	c7 05 f8 c5 10 80 00 	movl   $0x0,0x8010c5f8
80100acd:	00 00 00 
80100ad0:	eb 14                	jmp    80100ae6 <consoleintr+0x2f6>
        }
        else if(leftClicksCounter > 0)
80100ad2:	a1 f8 c5 10 80       	mov    0x8010c5f8,%eax
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	7e 0b                	jle    80100ae6 <consoleintr+0x2f6>
        {
            leftClicksCounter--;
80100adb:	a1 f8 c5 10 80       	mov    0x8010c5f8,%eax
80100ae0:	48                   	dec    %eax
80100ae1:	a3 f8 c5 10 80       	mov    %eax,0x8010c5f8
        }

        input.buf[input.e++ % INPUT_BUF] = c;
80100ae6:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
80100aeb:	89 c1                	mov    %eax,%ecx
80100aed:	83 e1 7f             	and    $0x7f,%ecx
80100af0:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100af3:	88 91 34 ef 10 80    	mov    %dl,-0x7fef10cc(%ecx)
80100af9:	40                   	inc    %eax
80100afa:	a3 bc ef 10 80       	mov    %eax,0x8010efbc
        consputc(c);
80100aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100b02:	89 04 24             	mov    %eax,(%esp)
80100b05:	e8 77 fc ff ff       	call   80100781 <consputc>

        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100b0a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b0e:	74 1c                	je     80100b2c <consoleintr+0x33c>
80100b10:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100b14:	74 16                	je     80100b2c <consoleintr+0x33c>
80100b16:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
80100b1b:	8b 15 b4 ef 10 80    	mov    0x8010efb4,%edx
80100b21:	83 ea 80             	sub    $0xffffff80,%edx
80100b24:	39 d0                	cmp    %edx,%eax
80100b26:	0f 85 0a 01 00 00    	jne    80100c36 <consoleintr+0x446>
            i = input.r;
80100b2c:	a1 b4 ef 10 80       	mov    0x8010efb4,%eax
80100b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
            bufIndex = 0;
80100b34:	c7 05 b0 c5 10 80 00 	movl   $0x0,0x8010c5b0
80100b3b:	00 00 00 
            while(i != input.e)
80100b3e:	eb 47                	jmp    80100b87 <consoleintr+0x397>
            {
                historyBuf[history_index % MAX_HISTORY_LENGTH][bufIndex] = input.buf[i % INPUT_BUF];
80100b40:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
80100b45:	b9 14 00 00 00       	mov    $0x14,%ecx
80100b4a:	99                   	cltd   
80100b4b:	f7 f9                	idiv   %ecx
80100b4d:	89 d1                	mov    %edx,%ecx
80100b4f:	8b 15 b0 c5 10 80    	mov    0x8010c5b0,%edx
80100b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b58:	25 7f 00 00 80       	and    $0x8000007f,%eax
80100b5d:	85 c0                	test   %eax,%eax
80100b5f:	79 05                	jns    80100b66 <consoleintr+0x376>
80100b61:	48                   	dec    %eax
80100b62:	83 c8 80             	or     $0xffffff80,%eax
80100b65:	40                   	inc    %eax
80100b66:	8a 80 34 ef 10 80    	mov    -0x7fef10cc(%eax),%al
80100b6c:	c1 e1 07             	shl    $0x7,%ecx
80100b6f:	01 ca                	add    %ecx,%edx
80100b71:	81 c2 c0 ef 10 80    	add    $0x8010efc0,%edx
80100b77:	88 02                	mov    %al,(%edx)
                i++;
80100b79:	ff 45 f4             	incl   -0xc(%ebp)
                bufIndex++;
80100b7c:	a1 b0 c5 10 80       	mov    0x8010c5b0,%eax
80100b81:	40                   	inc    %eax
80100b82:	a3 b0 c5 10 80       	mov    %eax,0x8010c5b0
        consputc(c);

        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
            i = input.r;
            bufIndex = 0;
            while(i != input.e)
80100b87:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b8a:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
80100b8f:	39 c2                	cmp    %eax,%edx
80100b91:	75 ad                	jne    80100b40 <consoleintr+0x350>
            {
                historyBuf[history_index % MAX_HISTORY_LENGTH][bufIndex] = input.buf[i % INPUT_BUF];
                i++;
                bufIndex++;
            }
          input.w = input.e;
80100b93:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
80100b98:	a3 b8 ef 10 80       	mov    %eax,0x8010efb8
          wakeup(&input.r);
80100b9d:	c7 04 24 b4 ef 10 80 	movl   $0x8010efb4,(%esp)
80100ba4:	e8 6c 48 00 00       	call   80105415 <wakeup>

          // check if user enter just NEWLINE - we dont want save in history
          if (bufIndex == 1)
80100ba9:	a1 b0 c5 10 80       	mov    0x8010c5b0,%eax
80100bae:	83 f8 01             	cmp    $0x1,%eax
80100bb1:	75 1d                	jne    80100bd0 <consoleintr+0x3e0>
          {
              if (historyBuf[history_index % MAX_HISTORY_LENGTH][0] == '\n')
80100bb3:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
80100bb8:	b9 14 00 00 00       	mov    $0x14,%ecx
80100bbd:	99                   	cltd   
80100bbe:	f7 f9                	idiv   %ecx
80100bc0:	89 d0                	mov    %edx,%eax
80100bc2:	c1 e0 07             	shl    $0x7,%eax
80100bc5:	05 c0 ef 10 80       	add    $0x8010efc0,%eax
80100bca:	8a 00                	mov    (%eax),%al
80100bcc:	3c 0a                	cmp    $0xa,%al
80100bce:	74 69                	je     80100c39 <consoleintr+0x449>
                  break;
          }

          if (historyCounter != MAX_HISTORY_LENGTH)
80100bd0:	a1 ac c5 10 80       	mov    0x8010c5ac,%eax
80100bd5:	83 f8 14             	cmp    $0x14,%eax
80100bd8:	74 0b                	je     80100be5 <consoleintr+0x3f5>
              historyCounter++;
80100bda:	a1 ac c5 10 80       	mov    0x8010c5ac,%eax
80100bdf:	40                   	inc    %eax
80100be0:	a3 ac c5 10 80       	mov    %eax,0x8010c5ac

          history_index_pos = history_index % MAX_HISTORY_LENGTH;
80100be5:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
80100bea:	b9 14 00 00 00       	mov    $0x14,%ecx
80100bef:	99                   	cltd   
80100bf0:	f7 f9                	idiv   %ecx
80100bf2:	89 d0                	mov    %edx,%eax
80100bf4:	a3 a4 c5 10 80       	mov    %eax,0x8010c5a4
          history_index++;
80100bf9:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
80100bfe:	40                   	inc    %eax
80100bff:	a3 a0 c5 10 80       	mov    %eax,0x8010c5a0
          history_index = history_index % MAX_HISTORY_LENGTH;
80100c04:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
80100c09:	b9 14 00 00 00       	mov    $0x14,%ecx
80100c0e:	99                   	cltd   
80100c0f:	f7 f9                	idiv   %ecx
80100c11:	89 d0                	mov    %edx,%eax
80100c13:	a3 a0 c5 10 80       	mov    %eax,0x8010c5a0
          historyFlag = 0;
80100c18:	c7 05 a8 c5 10 80 00 	movl   $0x0,0x8010c5a8
80100c1f:	00 00 00 
        }
      }
      break;
80100c22:	eb 12                	jmp    80100c36 <consoleintr+0x446>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100c24:	90                   	nop
80100c25:	eb 13                	jmp    80100c3a <consoleintr+0x44a>
      if(input.e != input.w)
      {
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100c27:	90                   	nop
80100c28:	eb 10                	jmp    80100c3a <consoleintr+0x44a>
      {
        consputc(KEY_LF);
        leftClicksCounter++;
        input.e--;
      }
      break;
80100c2a:	90                   	nop
80100c2b:	eb 0d                	jmp    80100c3a <consoleintr+0x44a>
        consputc(KEY_RT);
        leftClicksCounter--;
        input.e++;
        input.e = input.e % INPUT_BUF;
      }
      break;
80100c2d:	90                   	nop
80100c2e:	eb 0a                	jmp    80100c3a <consoleintr+0x44a>
    case KEY_UP :

      if (historyCounter == 0)
          break;
80100c30:	90                   	nop
80100c31:	eb 07                	jmp    80100c3a <consoleintr+0x44a>
          history_index_pos++;
          history_index_pos = history_index_pos % MAX_HISTORY_LENGTH;
          killLine();
          loadHistoryToScreen(c);  
      }
      break;
80100c33:	90                   	nop
80100c34:	eb 04                	jmp    80100c3a <consoleintr+0x44a>
          history_index++;
          history_index = history_index % MAX_HISTORY_LENGTH;
          historyFlag = 0;
        }
      }
      break;
80100c36:	90                   	nop
80100c37:	eb 01                	jmp    80100c3a <consoleintr+0x44a>

          // check if user enter just NEWLINE - we dont want save in history
          if (bufIndex == 1)
          {
              if (historyBuf[history_index % MAX_HISTORY_LENGTH][0] == '\n')
                  break;
80100c39:	90                   	nop
{
  int c;
  int i = 0;

  acquire(&input.lock);
  while((c = getc()) >= 0){
80100c3a:	8b 45 08             	mov    0x8(%ebp),%eax
80100c3d:	ff d0                	call   *%eax
80100c3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100c42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100c46:	0f 89 c2 fb ff ff    	jns    8010080e <consoleintr+0x1e>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100c4c:	c7 04 24 00 ef 10 80 	movl   $0x8010ef00,(%esp)
80100c53:	e8 29 4a 00 00       	call   80105681 <release>
}
80100c58:	c9                   	leave  
80100c59:	c3                   	ret    

80100c5a <killLine>:

//kill line
void killLine(void)
{
80100c5a:	55                   	push   %ebp
80100c5b:	89 e5                	mov    %esp,%ebp
80100c5d:	83 ec 18             	sub    $0x18,%esp

    while(input.e != input.w &&
80100c60:	eb 17                	jmp    80100c79 <killLine+0x1f>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100c62:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
80100c67:	48                   	dec    %eax
80100c68:	a3 bc ef 10 80       	mov    %eax,0x8010efbc
        consputc(BACKSPACE);
80100c6d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100c74:	e8 08 fb ff ff       	call   80100781 <consputc>

//kill line
void killLine(void)
{

    while(input.e != input.w &&
80100c79:	8b 15 bc ef 10 80    	mov    0x8010efbc,%edx
80100c7f:	a1 b8 ef 10 80       	mov    0x8010efb8,%eax
80100c84:	39 c2                	cmp    %eax,%edx
80100c86:	74 13                	je     80100c9b <killLine+0x41>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100c88:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
80100c8d:	48                   	dec    %eax
80100c8e:	83 e0 7f             	and    $0x7f,%eax
80100c91:	8a 80 34 ef 10 80    	mov    -0x7fef10cc(%eax),%al

//kill line
void killLine(void)
{

    while(input.e != input.w &&
80100c97:	3c 0a                	cmp    $0xa,%al
80100c99:	75 c7                	jne    80100c62 <killLine+0x8>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
    }
}
80100c9b:	c9                   	leave  
80100c9c:	c3                   	ret    

80100c9d <loadHistoryToScreen>:

void loadHistoryToScreen(int c)
{
80100c9d:	55                   	push   %ebp
80100c9e:	89 e5                	mov    %esp,%ebp
80100ca0:	83 ec 28             	sub    $0x28,%esp
    int i = 0;
80100ca3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while( historyBuf[history_index_pos][i] != '\n')
80100caa:	e9 aa 00 00 00       	jmp    80100d59 <loadHistoryToScreen+0xbc>
    {

        c = historyBuf[history_index_pos][i];
80100caf:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
80100cb4:	89 c2                	mov    %eax,%edx
80100cb6:	c1 e2 07             	shl    $0x7,%edx
80100cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100cbc:	01 d0                	add    %edx,%eax
80100cbe:	05 c0 ef 10 80       	add    $0x8010efc0,%eax
80100cc3:	8a 00                	mov    (%eax),%al
80100cc5:	0f be c0             	movsbl %al,%eax
80100cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(c != 0 && input.e-input.r < INPUT_BUF){
80100ccb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100ccf:	0f 84 81 00 00 00    	je     80100d56 <loadHistoryToScreen+0xb9>
80100cd5:	8b 15 bc ef 10 80    	mov    0x8010efbc,%edx
80100cdb:	a1 b4 ef 10 80       	mov    0x8010efb4,%eax
80100ce0:	89 d1                	mov    %edx,%ecx
80100ce2:	29 c1                	sub    %eax,%ecx
80100ce4:	89 c8                	mov    %ecx,%eax
80100ce6:	83 f8 7f             	cmp    $0x7f,%eax
80100ce9:	77 6b                	ja     80100d56 <loadHistoryToScreen+0xb9>
            c = (c == '\r') ? '\n' : c;
80100ceb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80100cef:	74 05                	je     80100cf6 <loadHistoryToScreen+0x59>
80100cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100cf4:	eb 05                	jmp    80100cfb <loadHistoryToScreen+0x5e>
80100cf6:	b8 0a 00 00 00       	mov    $0xa,%eax
80100cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
            input.buf[input.e++ % INPUT_BUF] = c;
80100cfe:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
80100d03:	89 c1                	mov    %eax,%ecx
80100d05:	83 e1 7f             	and    $0x7f,%ecx
80100d08:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100d0b:	88 91 34 ef 10 80    	mov    %dl,-0x7fef10cc(%ecx)
80100d11:	40                   	inc    %eax
80100d12:	a3 bc ef 10 80       	mov    %eax,0x8010efbc
            consputc(c);
80100d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100d1a:	89 04 24             	mov    %eax,(%esp)
80100d1d:	e8 5f fa ff ff       	call   80100781 <consputc>
            if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100d22:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100d26:	74 18                	je     80100d40 <loadHistoryToScreen+0xa3>
80100d28:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100d2c:	74 12                	je     80100d40 <loadHistoryToScreen+0xa3>
80100d2e:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
80100d33:	8b 15 b4 ef 10 80    	mov    0x8010efb4,%edx
80100d39:	83 ea 80             	sub    $0xffffff80,%edx
80100d3c:	39 d0                	cmp    %edx,%eax
80100d3e:	75 16                	jne    80100d56 <loadHistoryToScreen+0xb9>
                input.w = input.e;
80100d40:	a1 bc ef 10 80       	mov    0x8010efbc,%eax
80100d45:	a3 b8 ef 10 80       	mov    %eax,0x8010efb8
                wakeup(&input.r);
80100d4a:	c7 04 24 b4 ef 10 80 	movl   $0x8010efb4,(%esp)
80100d51:	e8 bf 46 00 00       	call   80105415 <wakeup>
            }
        }
        i++;
80100d56:	ff 45 f4             	incl   -0xc(%ebp)
}

void loadHistoryToScreen(int c)
{
    int i = 0;
    while( historyBuf[history_index_pos][i] != '\n')
80100d59:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
80100d5e:	89 c2                	mov    %eax,%edx
80100d60:	c1 e2 07             	shl    $0x7,%edx
80100d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100d66:	01 d0                	add    %edx,%eax
80100d68:	05 c0 ef 10 80       	add    $0x8010efc0,%eax
80100d6d:	8a 00                	mov    (%eax),%al
80100d6f:	3c 0a                	cmp    $0xa,%al
80100d71:	0f 85 38 ff ff ff    	jne    80100caf <loadHistoryToScreen+0x12>
                wakeup(&input.r);
            }
        }
        i++;
    }
}
80100d77:	c9                   	leave  
80100d78:	c3                   	ret    

80100d79 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100d79:	55                   	push   %ebp
80100d7a:	89 e5                	mov    %esp,%ebp
80100d7c:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100d7f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d82:	89 04 24             	mov    %eax,(%esp)
80100d85:	e8 5f 11 00 00       	call   80101ee9 <iunlock>
  target = n;
80100d8a:	8b 45 10             	mov    0x10(%ebp),%eax
80100d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100d90:	c7 04 24 00 ef 10 80 	movl   $0x8010ef00,(%esp)
80100d97:	e8 83 48 00 00       	call   8010561f <acquire>
  while(n > 0){
80100d9c:	e9 a1 00 00 00       	jmp    80100e42 <consoleread+0xc9>
    while(input.r == input.w){
      if(proc->killed){
80100da1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100da7:	8b 40 24             	mov    0x24(%eax),%eax
80100daa:	85 c0                	test   %eax,%eax
80100dac:	74 21                	je     80100dcf <consoleread+0x56>
        release(&input.lock);
80100dae:	c7 04 24 00 ef 10 80 	movl   $0x8010ef00,(%esp)
80100db5:	e8 c7 48 00 00       	call   80105681 <release>
        ilock(ip);
80100dba:	8b 45 08             	mov    0x8(%ebp),%eax
80100dbd:	89 04 24             	mov    %eax,(%esp)
80100dc0:	e8 d9 0f 00 00       	call   80101d9e <ilock>
        return -1;
80100dc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dca:	e9 a2 00 00 00       	jmp    80100e71 <consoleread+0xf8>
      }
      sleep(&input.r, &input.lock);
80100dcf:	c7 44 24 04 00 ef 10 	movl   $0x8010ef00,0x4(%esp)
80100dd6:	80 
80100dd7:	c7 04 24 b4 ef 10 80 	movl   $0x8010efb4,(%esp)
80100dde:	e8 56 45 00 00       	call   80105339 <sleep>
80100de3:	eb 01                	jmp    80100de6 <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100de5:	90                   	nop
80100de6:	8b 15 b4 ef 10 80    	mov    0x8010efb4,%edx
80100dec:	a1 b8 ef 10 80       	mov    0x8010efb8,%eax
80100df1:	39 c2                	cmp    %eax,%edx
80100df3:	74 ac                	je     80100da1 <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100df5:	a1 b4 ef 10 80       	mov    0x8010efb4,%eax
80100dfa:	89 c2                	mov    %eax,%edx
80100dfc:	83 e2 7f             	and    $0x7f,%edx
80100dff:	8a 92 34 ef 10 80    	mov    -0x7fef10cc(%edx),%dl
80100e05:	0f be d2             	movsbl %dl,%edx
80100e08:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100e0b:	40                   	inc    %eax
80100e0c:	a3 b4 ef 10 80       	mov    %eax,0x8010efb4
    if(c == C('D')){  // EOF
80100e11:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100e15:	75 15                	jne    80100e2c <consoleread+0xb3>
      if(n < target){
80100e17:	8b 45 10             	mov    0x10(%ebp),%eax
80100e1a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100e1d:	73 2b                	jae    80100e4a <consoleread+0xd1>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100e1f:	a1 b4 ef 10 80       	mov    0x8010efb4,%eax
80100e24:	48                   	dec    %eax
80100e25:	a3 b4 ef 10 80       	mov    %eax,0x8010efb4
      }
      break;
80100e2a:	eb 1e                	jmp    80100e4a <consoleread+0xd1>
    }
    *dst++ = c;
80100e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e2f:	88 c2                	mov    %al,%dl
80100e31:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e34:	88 10                	mov    %dl,(%eax)
80100e36:	ff 45 0c             	incl   0xc(%ebp)
    --n;
80100e39:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
80100e3c:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100e40:	74 0b                	je     80100e4d <consoleread+0xd4>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100e42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100e46:	7f 9d                	jg     80100de5 <consoleread+0x6c>
80100e48:	eb 04                	jmp    80100e4e <consoleread+0xd5>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100e4a:	90                   	nop
80100e4b:	eb 01                	jmp    80100e4e <consoleread+0xd5>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100e4d:	90                   	nop
  }
  release(&input.lock);
80100e4e:	c7 04 24 00 ef 10 80 	movl   $0x8010ef00,(%esp)
80100e55:	e8 27 48 00 00       	call   80105681 <release>
  ilock(ip);
80100e5a:	8b 45 08             	mov    0x8(%ebp),%eax
80100e5d:	89 04 24             	mov    %eax,(%esp)
80100e60:	e8 39 0f 00 00       	call   80101d9e <ilock>

  return target - n;
80100e65:	8b 45 10             	mov    0x10(%ebp),%eax
80100e68:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100e6b:	89 d1                	mov    %edx,%ecx
80100e6d:	29 c1                	sub    %eax,%ecx
80100e6f:	89 c8                	mov    %ecx,%eax
}
80100e71:	c9                   	leave  
80100e72:	c3                   	ret    

80100e73 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100e73:	55                   	push   %ebp
80100e74:	89 e5                	mov    %esp,%ebp
80100e76:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100e79:	8b 45 08             	mov    0x8(%ebp),%eax
80100e7c:	89 04 24             	mov    %eax,(%esp)
80100e7f:	e8 65 10 00 00       	call   80101ee9 <iunlock>
  acquire(&cons.lock);
80100e84:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100e8b:	e8 8f 47 00 00       	call   8010561f <acquire>
  for(i = 0; i < n; i++)
80100e90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100e97:	eb 1d                	jmp    80100eb6 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e9f:	01 d0                	add    %edx,%eax
80100ea1:	8a 00                	mov    (%eax),%al
80100ea3:	0f be c0             	movsbl %al,%eax
80100ea6:	25 ff 00 00 00       	and    $0xff,%eax
80100eab:	89 04 24             	mov    %eax,(%esp)
80100eae:	e8 ce f8 ff ff       	call   80100781 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100eb3:	ff 45 f4             	incl   -0xc(%ebp)
80100eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eb9:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ebc:	7c db                	jl     80100e99 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100ebe:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100ec5:	e8 b7 47 00 00       	call   80105681 <release>
  ilock(ip);
80100eca:	8b 45 08             	mov    0x8(%ebp),%eax
80100ecd:	89 04 24             	mov    %eax,(%esp)
80100ed0:	e8 c9 0e 00 00       	call   80101d9e <ilock>

  return n;
80100ed5:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ed8:	c9                   	leave  
80100ed9:	c3                   	ret    

80100eda <consoleinit>:

void
consoleinit(void)
{
80100eda:	55                   	push   %ebp
80100edb:	89 e5                	mov    %esp,%ebp
80100edd:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100ee0:	c7 44 24 04 3f 8d 10 	movl   $0x80108d3f,0x4(%esp)
80100ee7:	80 
80100ee8:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100eef:	e8 0a 47 00 00       	call   801055fe <initlock>
  initlock(&input.lock, "input");
80100ef4:	c7 44 24 04 47 8d 10 	movl   $0x80108d47,0x4(%esp)
80100efb:	80 
80100efc:	c7 04 24 00 ef 10 80 	movl   $0x8010ef00,(%esp)
80100f03:	e8 f6 46 00 00       	call   801055fe <initlock>

  devsw[CONSOLE].write = consolewrite;
80100f08:	c7 05 6c 08 11 80 73 	movl   $0x80100e73,0x8011086c
80100f0f:	0e 10 80 
  devsw[CONSOLE].read = consoleread;
80100f12:	c7 05 68 08 11 80 79 	movl   $0x80100d79,0x80110868
80100f19:	0d 10 80 
  cons.locking = 1;
80100f1c:	c7 05 f4 c5 10 80 01 	movl   $0x1,0x8010c5f4
80100f23:	00 00 00 

  picenable(IRQ_KBD);
80100f26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100f2d:	e8 de 30 00 00       	call   80104010 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100f32:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100f39:	00 
80100f3a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100f41:	e8 4f 1f 00 00       	call   80102e95 <ioapicenable>
}
80100f46:	c9                   	leave  
80100f47:	c3                   	ret    

80100f48 <add_path>:
//char ** pathsEnv = (char**) kalloc (MAX_PATH_ENTRIES * sizeof(char *));
//char ** pathsEnv;

int
add_path(char* path)
{
80100f48:	55                   	push   %ebp
80100f49:	89 e5                	mov    %esp,%ebp
80100f4b:	83 ec 18             	sub    $0x18,%esp
    if(nextPathPosition < MAX_PATH_ENTRIES)
80100f4e:	a1 fc c5 10 80       	mov    0x8010c5fc,%eax
80100f53:	83 f8 09             	cmp    $0x9,%eax
80100f56:	7f 3f                	jg     80100f97 <add_path+0x4f>
    {
        strncpy(pathsEnv[nextPathPosition], path , strlen(path));
80100f58:	8b 45 08             	mov    0x8(%ebp),%eax
80100f5b:	89 04 24             	mov    %eax,(%esp)
80100f5e:	e8 6a 4b 00 00       	call   80105acd <strlen>
80100f63:	8b 15 fc c5 10 80    	mov    0x8010c5fc,%edx
80100f69:	c1 e2 07             	shl    $0x7,%edx
80100f6c:	81 c2 c0 f9 10 80    	add    $0x8010f9c0,%edx
80100f72:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f76:	8b 45 08             	mov    0x8(%ebp),%eax
80100f79:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f7d:	89 14 24             	mov    %edx,(%esp)
80100f80:	e8 a5 4a 00 00       	call   80105a2a <strncpy>
        nextPathPosition++;
80100f85:	a1 fc c5 10 80       	mov    0x8010c5fc,%eax
80100f8a:	40                   	inc    %eax
80100f8b:	a3 fc c5 10 80       	mov    %eax,0x8010c5fc
        return 0;
80100f90:	b8 00 00 00 00       	mov    $0x0,%eax
80100f95:	eb 05                	jmp    80100f9c <add_path+0x54>
    }
    return -1;
80100f97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f9c:	c9                   	leave  
80100f9d:	c3                   	ret    

80100f9e <exec>:

int
exec(char *path, char **argv)
{
80100f9e:	55                   	push   %ebp
80100f9f:	89 e5                	mov    %esp,%ebp
80100fa1:	57                   	push   %edi
80100fa2:	53                   	push   %ebx
80100fa3:	81 ec b0 01 00 00    	sub    $0x1b0,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  char newPath[INPUT_BUF] = {0};
80100fa9:	8d 9d 68 fe ff ff    	lea    -0x198(%ebp),%ebx
80100faf:	b0 00                	mov    $0x0,%al
80100fb1:	ba 80 00 00 00       	mov    $0x80,%edx
80100fb6:	89 df                	mov    %ebx,%edi
80100fb8:	89 d1                	mov    %edx,%ecx
80100fba:	f3 aa                	rep stos %al,%es:(%edi)

  if((ip = namei(path)) == 0)
80100fbc:	8b 45 08             	mov    0x8(%ebp),%eax
80100fbf:	89 04 24             	mov    %eax,(%esp)
80100fc2:	e8 71 19 00 00       	call   80102938 <namei>
80100fc7:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100fca:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fce:	0f 85 8a 00 00 00    	jne    8010105e <exec+0xc0>
  {
    int i;
    for(i = 0 ; i < nextPathPosition ; i++)
80100fd4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
80100fdb:	eb 64                	jmp    80101041 <exec+0xa3>
    {
        strncpy(newPath ,pathsEnv[i], strlen(pathsEnv[i]));
80100fdd:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fe0:	c1 e0 07             	shl    $0x7,%eax
80100fe3:	05 c0 f9 10 80       	add    $0x8010f9c0,%eax
80100fe8:	89 04 24             	mov    %eax,(%esp)
80100feb:	e8 dd 4a 00 00       	call   80105acd <strlen>
80100ff0:	8b 55 d0             	mov    -0x30(%ebp),%edx
80100ff3:	c1 e2 07             	shl    $0x7,%edx
80100ff6:	81 c2 c0 f9 10 80    	add    $0x8010f9c0,%edx
80100ffc:	89 44 24 08          	mov    %eax,0x8(%esp)
80101000:	89 54 24 04          	mov    %edx,0x4(%esp)
80101004:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
8010100a:	89 04 24             	mov    %eax,(%esp)
8010100d:	e8 18 4a 00 00       	call   80105a2a <strncpy>
        strcat(newPath,path);
80101012:	8b 45 08             	mov    0x8(%ebp),%eax
80101015:	89 44 24 04          	mov    %eax,0x4(%esp)
80101019:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
8010101f:	89 04 24             	mov    %eax,(%esp)
80101022:	e8 cb 4a 00 00       	call   80105af2 <strcat>
        if((ip = namei(newPath)) != 0)
80101027:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
8010102d:	89 04 24             	mov    %eax,(%esp)
80101030:	e8 03 19 00 00       	call   80102938 <namei>
80101035:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101038:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
8010103c:	75 0f                	jne    8010104d <exec+0xaf>
  char newPath[INPUT_BUF] = {0};

  if((ip = namei(path)) == 0)
  {
    int i;
    for(i = 0 ; i < nextPathPosition ; i++)
8010103e:	ff 45 d0             	incl   -0x30(%ebp)
80101041:	a1 fc c5 10 80       	mov    0x8010c5fc,%eax
80101046:	39 45 d0             	cmp    %eax,-0x30(%ebp)
80101049:	7c 92                	jl     80100fdd <exec+0x3f>
8010104b:	eb 01                	jmp    8010104e <exec+0xb0>
    {
        strncpy(newPath ,pathsEnv[i], strlen(pathsEnv[i]));
        strcat(newPath,path);
        if((ip = namei(newPath)) != 0)
            break;
8010104d:	90                   	nop
    }
    if(!ip)
8010104e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80101052:	75 0a                	jne    8010105e <exec+0xc0>
        return -1;
80101054:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101059:	e9 ea 03 00 00       	jmp    80101448 <exec+0x4aa>
  }

  ilock(ip);
8010105e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101061:	89 04 24             	mov    %eax,(%esp)
80101064:	e8 35 0d 00 00       	call   80101d9e <ilock>
  pgdir = 0;
80101069:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)


  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80101070:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80101077:	00 
80101078:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010107f:	00 
80101080:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80101086:	89 44 24 04          	mov    %eax,0x4(%esp)
8010108a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010108d:	89 04 24             	mov    %eax,(%esp)
80101090:	e8 10 12 00 00       	call   801022a5 <readi>
80101095:	83 f8 33             	cmp    $0x33,%eax
80101098:	0f 86 64 03 00 00    	jbe    80101402 <exec+0x464>
    goto bad;
  if(elf.magic != ELF_MAGIC)
8010109e:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
801010a4:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
801010a9:	0f 85 56 03 00 00    	jne    80101405 <exec+0x467>
    goto bad;

  if((pgdir = setupkvm(kalloc)) == 0)
801010af:	c7 04 24 1b 30 10 80 	movl   $0x8010301b,(%esp)
801010b6:	e8 e5 73 00 00       	call   801084a0 <setupkvm>
801010bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801010be:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
801010c2:	0f 84 40 03 00 00    	je     80101408 <exec+0x46a>
    goto bad;

  // Load program into memory.
  sz = 0;
801010c8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph))
801010cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801010d6:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
801010dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
801010df:	e9 c4 00 00 00       	jmp    801011a8 <exec+0x20a>
  {
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801010e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801010e7:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
801010ee:	00 
801010ef:	89 44 24 08          	mov    %eax,0x8(%esp)
801010f3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
801010f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801010fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101100:	89 04 24             	mov    %eax,(%esp)
80101103:	e8 9d 11 00 00       	call   801022a5 <readi>
80101108:	83 f8 20             	cmp    $0x20,%eax
8010110b:	0f 85 fa 02 00 00    	jne    8010140b <exec+0x46d>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80101111:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80101117:	83 f8 01             	cmp    $0x1,%eax
8010111a:	75 7f                	jne    8010119b <exec+0x1fd>
      continue;
    if(ph.memsz < ph.filesz)
8010111c:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80101122:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80101128:	39 c2                	cmp    %eax,%edx
8010112a:	0f 82 de 02 00 00    	jb     8010140e <exec+0x470>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101130:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80101136:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
8010113c:	01 d0                	add    %edx,%eax
8010113e:	89 44 24 08          	mov    %eax,0x8(%esp)
80101142:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101145:	89 44 24 04          	mov    %eax,0x4(%esp)
80101149:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010114c:	89 04 24             	mov    %eax,(%esp)
8010114f:	e8 12 77 00 00       	call   80108866 <allocuvm>
80101154:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101157:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010115b:	0f 84 b0 02 00 00    	je     80101411 <exec+0x473>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101161:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80101167:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
8010116d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80101173:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80101177:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010117b:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010117e:	89 54 24 08          	mov    %edx,0x8(%esp)
80101182:	89 44 24 04          	mov    %eax,0x4(%esp)
80101186:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101189:	89 04 24             	mov    %eax,(%esp)
8010118c:	e8 e6 75 00 00       	call   80108777 <loaduvm>
80101191:	85 c0                	test   %eax,%eax
80101193:	0f 88 7b 02 00 00    	js     80101414 <exec+0x476>
80101199:	eb 01                	jmp    8010119c <exec+0x1fe>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph))
  {
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
8010119b:	90                   	nop
  if((pgdir = setupkvm(kalloc)) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph))
8010119c:	ff 45 ec             	incl   -0x14(%ebp)
8010119f:	8b 45 e8             	mov    -0x18(%ebp),%eax
801011a2:	83 c0 20             	add    $0x20,%eax
801011a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
801011a8:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
801011ae:	0f b7 c0             	movzwl %ax,%eax
801011b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801011b4:	0f 8f 2a ff ff ff    	jg     801010e4 <exec+0x146>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
801011ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011bd:	89 04 24             	mov    %eax,(%esp)
801011c0:	e8 5a 0e 00 00       	call   8010201f <iunlockput>
  ip = 0;
801011c5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
801011cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011cf:	05 ff 0f 00 00       	add    $0xfff,%eax
801011d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801011d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801011dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011df:	05 00 20 00 00       	add    $0x2000,%eax
801011e4:	89 44 24 08          	mov    %eax,0x8(%esp)
801011e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801011ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801011f2:	89 04 24             	mov    %eax,(%esp)
801011f5:	e8 6c 76 00 00       	call   80108866 <allocuvm>
801011fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101201:	0f 84 10 02 00 00    	je     80101417 <exec+0x479>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101207:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010120a:	2d 00 20 00 00       	sub    $0x2000,%eax
8010120f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101213:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101216:	89 04 24             	mov    %eax,(%esp)
80101219:	e8 77 78 00 00       	call   80108a95 <clearpteu>
  sp = sz;
8010121e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101221:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101224:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010122b:	e9 94 00 00 00       	jmp    801012c4 <exec+0x326>
    if(argc >= MAXARG)
80101230:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80101234:	0f 87 e0 01 00 00    	ja     8010141a <exec+0x47c>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010123a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010123d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101244:	8b 45 0c             	mov    0xc(%ebp),%eax
80101247:	01 d0                	add    %edx,%eax
80101249:	8b 00                	mov    (%eax),%eax
8010124b:	89 04 24             	mov    %eax,(%esp)
8010124e:	e8 7a 48 00 00       	call   80105acd <strlen>
80101253:	f7 d0                	not    %eax
80101255:	89 c2                	mov    %eax,%edx
80101257:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010125a:	01 d0                	add    %edx,%eax
8010125c:	83 e0 fc             	and    $0xfffffffc,%eax
8010125f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010126c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010126f:	01 d0                	add    %edx,%eax
80101271:	8b 00                	mov    (%eax),%eax
80101273:	89 04 24             	mov    %eax,(%esp)
80101276:	e8 52 48 00 00       	call   80105acd <strlen>
8010127b:	40                   	inc    %eax
8010127c:	89 c2                	mov    %eax,%edx
8010127e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101281:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80101288:	8b 45 0c             	mov    0xc(%ebp),%eax
8010128b:	01 c8                	add    %ecx,%eax
8010128d:	8b 00                	mov    (%eax),%eax
8010128f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80101293:	89 44 24 08          	mov    %eax,0x8(%esp)
80101297:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010129a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010129e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801012a1:	89 04 24             	mov    %eax,(%esp)
801012a4:	e8 a0 79 00 00       	call   80108c49 <copyout>
801012a9:	85 c0                	test   %eax,%eax
801012ab:	0f 88 6c 01 00 00    	js     8010141d <exec+0x47f>
      goto bad;
    ustack[3+argc] = sp;
801012b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012b4:	8d 50 03             	lea    0x3(%eax),%edx
801012b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012ba:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
801012c1:	ff 45 e4             	incl   -0x1c(%ebp)
801012c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801012ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801012d1:	01 d0                	add    %edx,%eax
801012d3:	8b 00                	mov    (%eax),%eax
801012d5:	85 c0                	test   %eax,%eax
801012d7:	0f 85 53 ff ff ff    	jne    80101230 <exec+0x292>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
801012dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012e0:	83 c0 03             	add    $0x3,%eax
801012e3:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
801012ea:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
801012ee:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
801012f5:	ff ff ff 
  ustack[1] = argc;
801012f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012fb:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101301:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101304:	40                   	inc    %eax
80101305:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010130c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010130f:	29 d0                	sub    %edx,%eax
80101311:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80101317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010131a:	83 c0 04             	add    $0x4,%eax
8010131d:	c1 e0 02             	shl    $0x2,%eax
80101320:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101326:	83 c0 04             	add    $0x4,%eax
80101329:	c1 e0 02             	shl    $0x2,%eax
8010132c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101330:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80101336:	89 44 24 08          	mov    %eax,0x8(%esp)
8010133a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010133d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101341:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101344:	89 04 24             	mov    %eax,(%esp)
80101347:	e8 fd 78 00 00       	call   80108c49 <copyout>
8010134c:	85 c0                	test   %eax,%eax
8010134e:	0f 88 cc 00 00 00    	js     80101420 <exec+0x482>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101354:	8b 45 08             	mov    0x8(%ebp),%eax
80101357:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010135a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010135d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101360:	eb 13                	jmp    80101375 <exec+0x3d7>
    if(*s == '/')
80101362:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101365:	8a 00                	mov    (%eax),%al
80101367:	3c 2f                	cmp    $0x2f,%al
80101369:	75 07                	jne    80101372 <exec+0x3d4>
      last = s+1;
8010136b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136e:	40                   	inc    %eax
8010136f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101372:	ff 45 f4             	incl   -0xc(%ebp)
80101375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101378:	8a 00                	mov    (%eax),%al
8010137a:	84 c0                	test   %al,%al
8010137c:	75 e4                	jne    80101362 <exec+0x3c4>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
8010137e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101384:	8d 50 6c             	lea    0x6c(%eax),%edx
80101387:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010138e:	00 
8010138f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101392:	89 44 24 04          	mov    %eax,0x4(%esp)
80101396:	89 14 24             	mov    %edx,(%esp)
80101399:	e8 e6 46 00 00       	call   80105a84 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
8010139e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801013a4:	8b 40 04             	mov    0x4(%eax),%eax
801013a7:	89 45 cc             	mov    %eax,-0x34(%ebp)
  proc->pgdir = pgdir;
801013aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801013b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801013b3:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
801013b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801013bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013bf:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
801013c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801013c7:	8b 40 18             	mov    0x18(%eax),%eax
801013ca:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
801013d0:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
801013d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801013d9:	8b 40 18             	mov    0x18(%eax),%eax
801013dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
801013df:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
801013e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801013e8:	89 04 24             	mov    %eax,(%esp)
801013eb:	e8 a1 71 00 00       	call   80108591 <switchuvm>
  freevm(oldpgdir);
801013f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
801013f3:	89 04 24             	mov    %eax,(%esp)
801013f6:	e8 01 76 00 00       	call   801089fc <freevm>
  return 0;
801013fb:	b8 00 00 00 00       	mov    $0x0,%eax
80101400:	eb 46                	jmp    80101448 <exec+0x4aa>
  pgdir = 0;


  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80101402:	90                   	nop
80101403:	eb 1c                	jmp    80101421 <exec+0x483>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80101405:	90                   	nop
80101406:	eb 19                	jmp    80101421 <exec+0x483>

  if((pgdir = setupkvm(kalloc)) == 0)
    goto bad;
80101408:	90                   	nop
80101409:	eb 16                	jmp    80101421 <exec+0x483>
  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph))
  {
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
8010140b:	90                   	nop
8010140c:	eb 13                	jmp    80101421 <exec+0x483>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
8010140e:	90                   	nop
8010140f:	eb 10                	jmp    80101421 <exec+0x483>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80101411:	90                   	nop
80101412:	eb 0d                	jmp    80101421 <exec+0x483>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80101414:	90                   	nop
80101415:	eb 0a                	jmp    80101421 <exec+0x483>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80101417:	90                   	nop
80101418:	eb 07                	jmp    80101421 <exec+0x483>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
8010141a:	90                   	nop
8010141b:	eb 04                	jmp    80101421 <exec+0x483>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
8010141d:	90                   	nop
8010141e:	eb 01                	jmp    80101421 <exec+0x483>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80101420:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80101421:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101425:	74 0b                	je     80101432 <exec+0x494>
    freevm(pgdir);
80101427:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010142a:	89 04 24             	mov    %eax,(%esp)
8010142d:	e8 ca 75 00 00       	call   801089fc <freevm>
  if(ip)
80101432:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80101436:	74 0b                	je     80101443 <exec+0x4a5>
    iunlockput(ip);
80101438:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010143b:	89 04 24             	mov    %eax,(%esp)
8010143e:	e8 dc 0b 00 00       	call   8010201f <iunlockput>
  return -1;
80101443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101448:	81 c4 b0 01 00 00    	add    $0x1b0,%esp
8010144e:	5b                   	pop    %ebx
8010144f:	5f                   	pop    %edi
80101450:	5d                   	pop    %ebp
80101451:	c3                   	ret    
80101452:	66 90                	xchg   %ax,%ax

80101454 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101454:	55                   	push   %ebp
80101455:	89 e5                	mov    %esp,%ebp
80101457:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
8010145a:	c7 44 24 04 4d 8d 10 	movl   $0x80108d4d,0x4(%esp)
80101461:	80 
80101462:	c7 04 24 c0 fe 10 80 	movl   $0x8010fec0,(%esp)
80101469:	e8 90 41 00 00       	call   801055fe <initlock>
}
8010146e:	c9                   	leave  
8010146f:	c3                   	ret    

80101470 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80101476:	c7 04 24 c0 fe 10 80 	movl   $0x8010fec0,(%esp)
8010147d:	e8 9d 41 00 00       	call   8010561f <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101482:	c7 45 f4 f4 fe 10 80 	movl   $0x8010fef4,-0xc(%ebp)
80101489:	eb 29                	jmp    801014b4 <filealloc+0x44>
    if(f->ref == 0){
8010148b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010148e:	8b 40 04             	mov    0x4(%eax),%eax
80101491:	85 c0                	test   %eax,%eax
80101493:	75 1b                	jne    801014b0 <filealloc+0x40>
      f->ref = 1;
80101495:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101498:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010149f:	c7 04 24 c0 fe 10 80 	movl   $0x8010fec0,(%esp)
801014a6:	e8 d6 41 00 00       	call   80105681 <release>
      return f;
801014ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014ae:	eb 1e                	jmp    801014ce <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801014b0:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
801014b4:	81 7d f4 54 08 11 80 	cmpl   $0x80110854,-0xc(%ebp)
801014bb:	72 ce                	jb     8010148b <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
801014bd:	c7 04 24 c0 fe 10 80 	movl   $0x8010fec0,(%esp)
801014c4:	e8 b8 41 00 00       	call   80105681 <release>
  return 0;
801014c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801014ce:	c9                   	leave  
801014cf:	c3                   	ret    

801014d0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801014d0:	55                   	push   %ebp
801014d1:	89 e5                	mov    %esp,%ebp
801014d3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
801014d6:	c7 04 24 c0 fe 10 80 	movl   $0x8010fec0,(%esp)
801014dd:	e8 3d 41 00 00       	call   8010561f <acquire>
  if(f->ref < 1)
801014e2:	8b 45 08             	mov    0x8(%ebp),%eax
801014e5:	8b 40 04             	mov    0x4(%eax),%eax
801014e8:	85 c0                	test   %eax,%eax
801014ea:	7f 0c                	jg     801014f8 <filedup+0x28>
    panic("filedup");
801014ec:	c7 04 24 54 8d 10 80 	movl   $0x80108d54,(%esp)
801014f3:	e8 3e f0 ff ff       	call   80100536 <panic>
  f->ref++;
801014f8:	8b 45 08             	mov    0x8(%ebp),%eax
801014fb:	8b 40 04             	mov    0x4(%eax),%eax
801014fe:	8d 50 01             	lea    0x1(%eax),%edx
80101501:	8b 45 08             	mov    0x8(%ebp),%eax
80101504:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101507:	c7 04 24 c0 fe 10 80 	movl   $0x8010fec0,(%esp)
8010150e:	e8 6e 41 00 00       	call   80105681 <release>
  return f;
80101513:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101516:	c9                   	leave  
80101517:	c3                   	ret    

80101518 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101518:	55                   	push   %ebp
80101519:	89 e5                	mov    %esp,%ebp
8010151b:	57                   	push   %edi
8010151c:	56                   	push   %esi
8010151d:	53                   	push   %ebx
8010151e:	83 ec 3c             	sub    $0x3c,%esp
  struct file ff;

  acquire(&ftable.lock);
80101521:	c7 04 24 c0 fe 10 80 	movl   $0x8010fec0,(%esp)
80101528:	e8 f2 40 00 00       	call   8010561f <acquire>
  if(f->ref < 1)
8010152d:	8b 45 08             	mov    0x8(%ebp),%eax
80101530:	8b 40 04             	mov    0x4(%eax),%eax
80101533:	85 c0                	test   %eax,%eax
80101535:	7f 0c                	jg     80101543 <fileclose+0x2b>
    panic("fileclose");
80101537:	c7 04 24 5c 8d 10 80 	movl   $0x80108d5c,(%esp)
8010153e:	e8 f3 ef ff ff       	call   80100536 <panic>
  if(--f->ref > 0){
80101543:	8b 45 08             	mov    0x8(%ebp),%eax
80101546:	8b 40 04             	mov    0x4(%eax),%eax
80101549:	8d 50 ff             	lea    -0x1(%eax),%edx
8010154c:	8b 45 08             	mov    0x8(%ebp),%eax
8010154f:	89 50 04             	mov    %edx,0x4(%eax)
80101552:	8b 45 08             	mov    0x8(%ebp),%eax
80101555:	8b 40 04             	mov    0x4(%eax),%eax
80101558:	85 c0                	test   %eax,%eax
8010155a:	7e 0e                	jle    8010156a <fileclose+0x52>
    release(&ftable.lock);
8010155c:	c7 04 24 c0 fe 10 80 	movl   $0x8010fec0,(%esp)
80101563:	e8 19 41 00 00       	call   80105681 <release>
80101568:	eb 70                	jmp    801015da <fileclose+0xc2>
    return;
  }
  ff = *f;
8010156a:	8b 45 08             	mov    0x8(%ebp),%eax
8010156d:	8d 55 d0             	lea    -0x30(%ebp),%edx
80101570:	89 c3                	mov    %eax,%ebx
80101572:	b8 06 00 00 00       	mov    $0x6,%eax
80101577:	89 d7                	mov    %edx,%edi
80101579:	89 de                	mov    %ebx,%esi
8010157b:	89 c1                	mov    %eax,%ecx
8010157d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
8010157f:	8b 45 08             	mov    0x8(%ebp),%eax
80101582:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101589:	8b 45 08             	mov    0x8(%ebp),%eax
8010158c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101592:	c7 04 24 c0 fe 10 80 	movl   $0x8010fec0,(%esp)
80101599:	e8 e3 40 00 00       	call   80105681 <release>
  
  if(ff.type == FD_PIPE)
8010159e:	8b 45 d0             	mov    -0x30(%ebp),%eax
801015a1:	83 f8 01             	cmp    $0x1,%eax
801015a4:	75 17                	jne    801015bd <fileclose+0xa5>
    pipeclose(ff.pipe, ff.writable);
801015a6:	8a 45 d9             	mov    -0x27(%ebp),%al
801015a9:	0f be d0             	movsbl %al,%edx
801015ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
801015af:	89 54 24 04          	mov    %edx,0x4(%esp)
801015b3:	89 04 24             	mov    %eax,(%esp)
801015b6:	e8 0c 2d 00 00       	call   801042c7 <pipeclose>
801015bb:	eb 1d                	jmp    801015da <fileclose+0xc2>
  else if(ff.type == FD_INODE){
801015bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
801015c0:	83 f8 02             	cmp    $0x2,%eax
801015c3:	75 15                	jne    801015da <fileclose+0xc2>
    begin_trans();
801015c5:	e8 61 21 00 00       	call   8010372b <begin_trans>
    iput(ff.ip);
801015ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
801015cd:	89 04 24             	mov    %eax,(%esp)
801015d0:	e8 79 09 00 00       	call   80101f4e <iput>
    commit_trans();
801015d5:	e8 9a 21 00 00       	call   80103774 <commit_trans>
  }
}
801015da:	83 c4 3c             	add    $0x3c,%esp
801015dd:	5b                   	pop    %ebx
801015de:	5e                   	pop    %esi
801015df:	5f                   	pop    %edi
801015e0:	5d                   	pop    %ebp
801015e1:	c3                   	ret    

801015e2 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801015e2:	55                   	push   %ebp
801015e3:	89 e5                	mov    %esp,%ebp
801015e5:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801015e8:	8b 45 08             	mov    0x8(%ebp),%eax
801015eb:	8b 00                	mov    (%eax),%eax
801015ed:	83 f8 02             	cmp    $0x2,%eax
801015f0:	75 38                	jne    8010162a <filestat+0x48>
    ilock(f->ip);
801015f2:	8b 45 08             	mov    0x8(%ebp),%eax
801015f5:	8b 40 10             	mov    0x10(%eax),%eax
801015f8:	89 04 24             	mov    %eax,(%esp)
801015fb:	e8 9e 07 00 00       	call   80101d9e <ilock>
    stati(f->ip, st);
80101600:	8b 45 08             	mov    0x8(%ebp),%eax
80101603:	8b 40 10             	mov    0x10(%eax),%eax
80101606:	8b 55 0c             	mov    0xc(%ebp),%edx
80101609:	89 54 24 04          	mov    %edx,0x4(%esp)
8010160d:	89 04 24             	mov    %eax,(%esp)
80101610:	e8 4c 0c 00 00       	call   80102261 <stati>
    iunlock(f->ip);
80101615:	8b 45 08             	mov    0x8(%ebp),%eax
80101618:	8b 40 10             	mov    0x10(%eax),%eax
8010161b:	89 04 24             	mov    %eax,(%esp)
8010161e:	e8 c6 08 00 00       	call   80101ee9 <iunlock>
    return 0;
80101623:	b8 00 00 00 00       	mov    $0x0,%eax
80101628:	eb 05                	jmp    8010162f <filestat+0x4d>
  }
  return -1;
8010162a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010162f:	c9                   	leave  
80101630:	c3                   	ret    

80101631 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101631:	55                   	push   %ebp
80101632:	89 e5                	mov    %esp,%ebp
80101634:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101637:	8b 45 08             	mov    0x8(%ebp),%eax
8010163a:	8a 40 08             	mov    0x8(%eax),%al
8010163d:	84 c0                	test   %al,%al
8010163f:	75 0a                	jne    8010164b <fileread+0x1a>
    return -1;
80101641:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101646:	e9 9f 00 00 00       	jmp    801016ea <fileread+0xb9>
  if(f->type == FD_PIPE)
8010164b:	8b 45 08             	mov    0x8(%ebp),%eax
8010164e:	8b 00                	mov    (%eax),%eax
80101650:	83 f8 01             	cmp    $0x1,%eax
80101653:	75 1e                	jne    80101673 <fileread+0x42>
    return piperead(f->pipe, addr, n);
80101655:	8b 45 08             	mov    0x8(%ebp),%eax
80101658:	8b 40 0c             	mov    0xc(%eax),%eax
8010165b:	8b 55 10             	mov    0x10(%ebp),%edx
8010165e:	89 54 24 08          	mov    %edx,0x8(%esp)
80101662:	8b 55 0c             	mov    0xc(%ebp),%edx
80101665:	89 54 24 04          	mov    %edx,0x4(%esp)
80101669:	89 04 24             	mov    %eax,(%esp)
8010166c:	e8 d8 2d 00 00       	call   80104449 <piperead>
80101671:	eb 77                	jmp    801016ea <fileread+0xb9>
  if(f->type == FD_INODE){
80101673:	8b 45 08             	mov    0x8(%ebp),%eax
80101676:	8b 00                	mov    (%eax),%eax
80101678:	83 f8 02             	cmp    $0x2,%eax
8010167b:	75 61                	jne    801016de <fileread+0xad>
    ilock(f->ip);
8010167d:	8b 45 08             	mov    0x8(%ebp),%eax
80101680:	8b 40 10             	mov    0x10(%eax),%eax
80101683:	89 04 24             	mov    %eax,(%esp)
80101686:	e8 13 07 00 00       	call   80101d9e <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010168b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010168e:	8b 45 08             	mov    0x8(%ebp),%eax
80101691:	8b 50 14             	mov    0x14(%eax),%edx
80101694:	8b 45 08             	mov    0x8(%ebp),%eax
80101697:	8b 40 10             	mov    0x10(%eax),%eax
8010169a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010169e:	89 54 24 08          	mov    %edx,0x8(%esp)
801016a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801016a5:	89 54 24 04          	mov    %edx,0x4(%esp)
801016a9:	89 04 24             	mov    %eax,(%esp)
801016ac:	e8 f4 0b 00 00       	call   801022a5 <readi>
801016b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801016b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801016b8:	7e 11                	jle    801016cb <fileread+0x9a>
      f->off += r;
801016ba:	8b 45 08             	mov    0x8(%ebp),%eax
801016bd:	8b 50 14             	mov    0x14(%eax),%edx
801016c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016c3:	01 c2                	add    %eax,%edx
801016c5:	8b 45 08             	mov    0x8(%ebp),%eax
801016c8:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801016cb:	8b 45 08             	mov    0x8(%ebp),%eax
801016ce:	8b 40 10             	mov    0x10(%eax),%eax
801016d1:	89 04 24             	mov    %eax,(%esp)
801016d4:	e8 10 08 00 00       	call   80101ee9 <iunlock>
    return r;
801016d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016dc:	eb 0c                	jmp    801016ea <fileread+0xb9>
  }
  panic("fileread");
801016de:	c7 04 24 66 8d 10 80 	movl   $0x80108d66,(%esp)
801016e5:	e8 4c ee ff ff       	call   80100536 <panic>
}
801016ea:	c9                   	leave  
801016eb:	c3                   	ret    

801016ec <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801016ec:	55                   	push   %ebp
801016ed:	89 e5                	mov    %esp,%ebp
801016ef:	53                   	push   %ebx
801016f0:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801016f3:	8b 45 08             	mov    0x8(%ebp),%eax
801016f6:	8a 40 09             	mov    0x9(%eax),%al
801016f9:	84 c0                	test   %al,%al
801016fb:	75 0a                	jne    80101707 <filewrite+0x1b>
    return -1;
801016fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101702:	e9 23 01 00 00       	jmp    8010182a <filewrite+0x13e>
  if(f->type == FD_PIPE)
80101707:	8b 45 08             	mov    0x8(%ebp),%eax
8010170a:	8b 00                	mov    (%eax),%eax
8010170c:	83 f8 01             	cmp    $0x1,%eax
8010170f:	75 21                	jne    80101732 <filewrite+0x46>
    return pipewrite(f->pipe, addr, n);
80101711:	8b 45 08             	mov    0x8(%ebp),%eax
80101714:	8b 40 0c             	mov    0xc(%eax),%eax
80101717:	8b 55 10             	mov    0x10(%ebp),%edx
8010171a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010171e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101721:	89 54 24 04          	mov    %edx,0x4(%esp)
80101725:	89 04 24             	mov    %eax,(%esp)
80101728:	e8 2c 2c 00 00       	call   80104359 <pipewrite>
8010172d:	e9 f8 00 00 00       	jmp    8010182a <filewrite+0x13e>
  if(f->type == FD_INODE){
80101732:	8b 45 08             	mov    0x8(%ebp),%eax
80101735:	8b 00                	mov    (%eax),%eax
80101737:	83 f8 02             	cmp    $0x2,%eax
8010173a:	0f 85 de 00 00 00    	jne    8010181e <filewrite+0x132>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101740:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101747:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010174e:	e9 a8 00 00 00       	jmp    801017fb <filewrite+0x10f>
      int n1 = n - i;
80101753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101756:	8b 55 10             	mov    0x10(%ebp),%edx
80101759:	89 d1                	mov    %edx,%ecx
8010175b:	29 c1                	sub    %eax,%ecx
8010175d:	89 c8                	mov    %ecx,%eax
8010175f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101762:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101765:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101768:	7e 06                	jle    80101770 <filewrite+0x84>
        n1 = max;
8010176a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010176d:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
80101770:	e8 b6 1f 00 00       	call   8010372b <begin_trans>
      ilock(f->ip);
80101775:	8b 45 08             	mov    0x8(%ebp),%eax
80101778:	8b 40 10             	mov    0x10(%eax),%eax
8010177b:	89 04 24             	mov    %eax,(%esp)
8010177e:	e8 1b 06 00 00       	call   80101d9e <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101783:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101786:	8b 45 08             	mov    0x8(%ebp),%eax
80101789:	8b 50 14             	mov    0x14(%eax),%edx
8010178c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010178f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101792:	01 c3                	add    %eax,%ebx
80101794:	8b 45 08             	mov    0x8(%ebp),%eax
80101797:	8b 40 10             	mov    0x10(%eax),%eax
8010179a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010179e:	89 54 24 08          	mov    %edx,0x8(%esp)
801017a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801017a6:	89 04 24             	mov    %eax,(%esp)
801017a9:	e8 5c 0c 00 00       	call   8010240a <writei>
801017ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
801017b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801017b5:	7e 11                	jle    801017c8 <filewrite+0xdc>
        f->off += r;
801017b7:	8b 45 08             	mov    0x8(%ebp),%eax
801017ba:	8b 50 14             	mov    0x14(%eax),%edx
801017bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801017c0:	01 c2                	add    %eax,%edx
801017c2:	8b 45 08             	mov    0x8(%ebp),%eax
801017c5:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801017c8:	8b 45 08             	mov    0x8(%ebp),%eax
801017cb:	8b 40 10             	mov    0x10(%eax),%eax
801017ce:	89 04 24             	mov    %eax,(%esp)
801017d1:	e8 13 07 00 00       	call   80101ee9 <iunlock>
      commit_trans();
801017d6:	e8 99 1f 00 00       	call   80103774 <commit_trans>

      if(r < 0)
801017db:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801017df:	78 28                	js     80101809 <filewrite+0x11d>
        break;
      if(r != n1)
801017e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801017e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801017e7:	74 0c                	je     801017f5 <filewrite+0x109>
        panic("short filewrite");
801017e9:	c7 04 24 6f 8d 10 80 	movl   $0x80108d6f,(%esp)
801017f0:	e8 41 ed ff ff       	call   80100536 <panic>
      i += r;
801017f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801017f8:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801017fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fe:	3b 45 10             	cmp    0x10(%ebp),%eax
80101801:	0f 8c 4c ff ff ff    	jl     80101753 <filewrite+0x67>
80101807:	eb 01                	jmp    8010180a <filewrite+0x11e>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
80101809:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010180a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010180d:	3b 45 10             	cmp    0x10(%ebp),%eax
80101810:	75 05                	jne    80101817 <filewrite+0x12b>
80101812:	8b 45 10             	mov    0x10(%ebp),%eax
80101815:	eb 05                	jmp    8010181c <filewrite+0x130>
80101817:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010181c:	eb 0c                	jmp    8010182a <filewrite+0x13e>
  }
  panic("filewrite");
8010181e:	c7 04 24 7f 8d 10 80 	movl   $0x80108d7f,(%esp)
80101825:	e8 0c ed ff ff       	call   80100536 <panic>
}
8010182a:	83 c4 24             	add    $0x24,%esp
8010182d:	5b                   	pop    %ebx
8010182e:	5d                   	pop    %ebp
8010182f:	c3                   	ret    

80101830 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101836:	8b 45 08             	mov    0x8(%ebp),%eax
80101839:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101840:	00 
80101841:	89 04 24             	mov    %eax,(%esp)
80101844:	e8 5d e9 ff ff       	call   801001a6 <bread>
80101849:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010184c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184f:	83 c0 18             	add    $0x18,%eax
80101852:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101859:	00 
8010185a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010185e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101861:	89 04 24             	mov    %eax,(%esp)
80101864:	e8 d5 40 00 00       	call   8010593e <memmove>
  brelse(bp);
80101869:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186c:	89 04 24             	mov    %eax,(%esp)
8010186f:	e8 a3 e9 ff ff       	call   80100217 <brelse>
}
80101874:	c9                   	leave  
80101875:	c3                   	ret    

80101876 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101876:	55                   	push   %ebp
80101877:	89 e5                	mov    %esp,%ebp
80101879:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010187c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010187f:	8b 45 08             	mov    0x8(%ebp),%eax
80101882:	89 54 24 04          	mov    %edx,0x4(%esp)
80101886:	89 04 24             	mov    %eax,(%esp)
80101889:	e8 18 e9 ff ff       	call   801001a6 <bread>
8010188e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101891:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101894:	83 c0 18             	add    $0x18,%eax
80101897:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010189e:	00 
8010189f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801018a6:	00 
801018a7:	89 04 24             	mov    %eax,(%esp)
801018aa:	e8 c3 3f 00 00       	call   80105872 <memset>
  log_write(bp);
801018af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b2:	89 04 24             	mov    %eax,(%esp)
801018b5:	e8 12 1f 00 00       	call   801037cc <log_write>
  brelse(bp);
801018ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018bd:	89 04 24             	mov    %eax,(%esp)
801018c0:	e8 52 e9 ff ff       	call   80100217 <brelse>
}
801018c5:	c9                   	leave  
801018c6:	c3                   	ret    

801018c7 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801018c7:	55                   	push   %ebp
801018c8:	89 e5                	mov    %esp,%ebp
801018ca:	53                   	push   %ebx
801018cb:	83 ec 34             	sub    $0x34,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801018ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801018d5:	8b 45 08             	mov    0x8(%ebp),%eax
801018d8:	8d 55 d8             	lea    -0x28(%ebp),%edx
801018db:	89 54 24 04          	mov    %edx,0x4(%esp)
801018df:	89 04 24             	mov    %eax,(%esp)
801018e2:	e8 49 ff ff ff       	call   80101830 <readsb>
  for(b = 0; b < sb.size; b += BPB){
801018e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801018ee:	e9 05 01 00 00       	jmp    801019f8 <balloc+0x131>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801018f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f6:	85 c0                	test   %eax,%eax
801018f8:	79 05                	jns    801018ff <balloc+0x38>
801018fa:	05 ff 0f 00 00       	add    $0xfff,%eax
801018ff:	c1 f8 0c             	sar    $0xc,%eax
80101902:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101905:	c1 ea 03             	shr    $0x3,%edx
80101908:	01 d0                	add    %edx,%eax
8010190a:	83 c0 03             	add    $0x3,%eax
8010190d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101911:	8b 45 08             	mov    0x8(%ebp),%eax
80101914:	89 04 24             	mov    %eax,(%esp)
80101917:	e8 8a e8 ff ff       	call   801001a6 <bread>
8010191c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010191f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101926:	e9 9d 00 00 00       	jmp    801019c8 <balloc+0x101>
      m = 1 << (bi % 8);
8010192b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010192e:	25 07 00 00 80       	and    $0x80000007,%eax
80101933:	85 c0                	test   %eax,%eax
80101935:	79 05                	jns    8010193c <balloc+0x75>
80101937:	48                   	dec    %eax
80101938:	83 c8 f8             	or     $0xfffffff8,%eax
8010193b:	40                   	inc    %eax
8010193c:	ba 01 00 00 00       	mov    $0x1,%edx
80101941:	89 d3                	mov    %edx,%ebx
80101943:	88 c1                	mov    %al,%cl
80101945:	d3 e3                	shl    %cl,%ebx
80101947:	89 d8                	mov    %ebx,%eax
80101949:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010194c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010194f:	85 c0                	test   %eax,%eax
80101951:	79 03                	jns    80101956 <balloc+0x8f>
80101953:	83 c0 07             	add    $0x7,%eax
80101956:	c1 f8 03             	sar    $0x3,%eax
80101959:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010195c:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
80101960:	0f b6 c0             	movzbl %al,%eax
80101963:	23 45 e8             	and    -0x18(%ebp),%eax
80101966:	85 c0                	test   %eax,%eax
80101968:	75 5b                	jne    801019c5 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
8010196a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010196d:	85 c0                	test   %eax,%eax
8010196f:	79 03                	jns    80101974 <balloc+0xad>
80101971:	83 c0 07             	add    $0x7,%eax
80101974:	c1 f8 03             	sar    $0x3,%eax
80101977:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010197a:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
8010197e:	88 d1                	mov    %dl,%cl
80101980:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101983:	09 ca                	or     %ecx,%edx
80101985:	88 d1                	mov    %dl,%cl
80101987:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010198a:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010198e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101991:	89 04 24             	mov    %eax,(%esp)
80101994:	e8 33 1e 00 00       	call   801037cc <log_write>
        brelse(bp);
80101999:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010199c:	89 04 24             	mov    %eax,(%esp)
8010199f:	e8 73 e8 ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
801019a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801019aa:	01 c2                	add    %eax,%edx
801019ac:	8b 45 08             	mov    0x8(%ebp),%eax
801019af:	89 54 24 04          	mov    %edx,0x4(%esp)
801019b3:	89 04 24             	mov    %eax,(%esp)
801019b6:	e8 bb fe ff ff       	call   80101876 <bzero>
        return b + bi;
801019bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801019c1:	01 d0                	add    %edx,%eax
801019c3:	eb 4d                	jmp    80101a12 <balloc+0x14b>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801019c5:	ff 45 f0             	incl   -0x10(%ebp)
801019c8:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801019cf:	7f 15                	jg     801019e6 <balloc+0x11f>
801019d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801019d7:	01 d0                	add    %edx,%eax
801019d9:	89 c2                	mov    %eax,%edx
801019db:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019de:	39 c2                	cmp    %eax,%edx
801019e0:	0f 82 45 ff ff ff    	jb     8010192b <balloc+0x64>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801019e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801019e9:	89 04 24             	mov    %eax,(%esp)
801019ec:	e8 26 e8 ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801019f1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801019f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801019fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019fe:	39 c2                	cmp    %eax,%edx
80101a00:	0f 82 ed fe ff ff    	jb     801018f3 <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101a06:	c7 04 24 89 8d 10 80 	movl   $0x80108d89,(%esp)
80101a0d:	e8 24 eb ff ff       	call   80100536 <panic>
}
80101a12:	83 c4 34             	add    $0x34,%esp
80101a15:	5b                   	pop    %ebx
80101a16:	5d                   	pop    %ebp
80101a17:	c3                   	ret    

80101a18 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101a18:	55                   	push   %ebp
80101a19:	89 e5                	mov    %esp,%ebp
80101a1b:	53                   	push   %ebx
80101a1c:	83 ec 34             	sub    $0x34,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101a1f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101a22:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a26:	8b 45 08             	mov    0x8(%ebp),%eax
80101a29:	89 04 24             	mov    %eax,(%esp)
80101a2c:	e8 ff fd ff ff       	call   80101830 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101a31:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a34:	89 c2                	mov    %eax,%edx
80101a36:	c1 ea 0c             	shr    $0xc,%edx
80101a39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a3c:	c1 e8 03             	shr    $0x3,%eax
80101a3f:	01 d0                	add    %edx,%eax
80101a41:	8d 50 03             	lea    0x3(%eax),%edx
80101a44:	8b 45 08             	mov    0x8(%ebp),%eax
80101a47:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a4b:	89 04 24             	mov    %eax,(%esp)
80101a4e:	e8 53 e7 ff ff       	call   801001a6 <bread>
80101a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101a56:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a59:	25 ff 0f 00 00       	and    $0xfff,%eax
80101a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a64:	25 07 00 00 80       	and    $0x80000007,%eax
80101a69:	85 c0                	test   %eax,%eax
80101a6b:	79 05                	jns    80101a72 <bfree+0x5a>
80101a6d:	48                   	dec    %eax
80101a6e:	83 c8 f8             	or     $0xfffffff8,%eax
80101a71:	40                   	inc    %eax
80101a72:	ba 01 00 00 00       	mov    $0x1,%edx
80101a77:	89 d3                	mov    %edx,%ebx
80101a79:	88 c1                	mov    %al,%cl
80101a7b:	d3 e3                	shl    %cl,%ebx
80101a7d:	89 d8                	mov    %ebx,%eax
80101a7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a85:	85 c0                	test   %eax,%eax
80101a87:	79 03                	jns    80101a8c <bfree+0x74>
80101a89:	83 c0 07             	add    $0x7,%eax
80101a8c:	c1 f8 03             	sar    $0x3,%eax
80101a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101a92:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
80101a96:	0f b6 c0             	movzbl %al,%eax
80101a99:	23 45 ec             	and    -0x14(%ebp),%eax
80101a9c:	85 c0                	test   %eax,%eax
80101a9e:	75 0c                	jne    80101aac <bfree+0x94>
    panic("freeing free block");
80101aa0:	c7 04 24 9f 8d 10 80 	movl   $0x80108d9f,(%esp)
80101aa7:	e8 8a ea ff ff       	call   80100536 <panic>
  bp->data[bi/8] &= ~m;
80101aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aaf:	85 c0                	test   %eax,%eax
80101ab1:	79 03                	jns    80101ab6 <bfree+0x9e>
80101ab3:	83 c0 07             	add    $0x7,%eax
80101ab6:	c1 f8 03             	sar    $0x3,%eax
80101ab9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101abc:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
80101ac0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101ac3:	f7 d1                	not    %ecx
80101ac5:	21 ca                	and    %ecx,%edx
80101ac7:	88 d1                	mov    %dl,%cl
80101ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101acc:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ad3:	89 04 24             	mov    %eax,(%esp)
80101ad6:	e8 f1 1c 00 00       	call   801037cc <log_write>
  brelse(bp);
80101adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ade:	89 04 24             	mov    %eax,(%esp)
80101ae1:	e8 31 e7 ff ff       	call   80100217 <brelse>
}
80101ae6:	83 c4 34             	add    $0x34,%esp
80101ae9:	5b                   	pop    %ebx
80101aea:	5d                   	pop    %ebp
80101aeb:	c3                   	ret    

80101aec <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101aec:	55                   	push   %ebp
80101aed:	89 e5                	mov    %esp,%ebp
80101aef:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
80101af2:	c7 44 24 04 b2 8d 10 	movl   $0x80108db2,0x4(%esp)
80101af9:	80 
80101afa:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80101b01:	e8 f8 3a 00 00       	call   801055fe <initlock>
}
80101b06:	c9                   	leave  
80101b07:	c3                   	ret    

80101b08 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101b08:	55                   	push   %ebp
80101b09:	89 e5                	mov    %esp,%ebp
80101b0b:	83 ec 48             	sub    $0x48,%esp
80101b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b11:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101b15:	8b 45 08             	mov    0x8(%ebp),%eax
80101b18:	8d 55 dc             	lea    -0x24(%ebp),%edx
80101b1b:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b1f:	89 04 24             	mov    %eax,(%esp)
80101b22:	e8 09 fd ff ff       	call   80101830 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
80101b27:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101b2e:	e9 95 00 00 00       	jmp    80101bc8 <ialloc+0xc0>
    bp = bread(dev, IBLOCK(inum));
80101b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b36:	c1 e8 03             	shr    $0x3,%eax
80101b39:	83 c0 02             	add    $0x2,%eax
80101b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b40:	8b 45 08             	mov    0x8(%ebp),%eax
80101b43:	89 04 24             	mov    %eax,(%esp)
80101b46:	e8 5b e6 ff ff       	call   801001a6 <bread>
80101b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b51:	8d 50 18             	lea    0x18(%eax),%edx
80101b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b57:	83 e0 07             	and    $0x7,%eax
80101b5a:	c1 e0 06             	shl    $0x6,%eax
80101b5d:	01 d0                	add    %edx,%eax
80101b5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101b62:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101b65:	8b 00                	mov    (%eax),%eax
80101b67:	66 85 c0             	test   %ax,%ax
80101b6a:	75 4e                	jne    80101bba <ialloc+0xb2>
      memset(dip, 0, sizeof(*dip));
80101b6c:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101b73:	00 
80101b74:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101b7b:	00 
80101b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101b7f:	89 04 24             	mov    %eax,(%esp)
80101b82:	e8 eb 3c 00 00       	call   80105872 <memset>
      dip->type = type;
80101b87:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101b8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101b8d:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
80101b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b93:	89 04 24             	mov    %eax,(%esp)
80101b96:	e8 31 1c 00 00       	call   801037cc <log_write>
      brelse(bp);
80101b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b9e:	89 04 24             	mov    %eax,(%esp)
80101ba1:	e8 71 e6 ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
80101ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ba9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bad:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb0:	89 04 24             	mov    %eax,(%esp)
80101bb3:	e8 e2 00 00 00       	call   80101c9a <iget>
80101bb8:	eb 28                	jmp    80101be2 <ialloc+0xda>
    }
    brelse(bp);
80101bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bbd:	89 04 24             	mov    %eax,(%esp)
80101bc0:	e8 52 e6 ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
80101bc5:	ff 45 f4             	incl   -0xc(%ebp)
80101bc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bce:	39 c2                	cmp    %eax,%edx
80101bd0:	0f 82 5d ff ff ff    	jb     80101b33 <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101bd6:	c7 04 24 b9 8d 10 80 	movl   $0x80108db9,(%esp)
80101bdd:	e8 54 e9 ff ff       	call   80100536 <panic>
}
80101be2:	c9                   	leave  
80101be3:	c3                   	ret    

80101be4 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101be4:	55                   	push   %ebp
80101be5:	89 e5                	mov    %esp,%ebp
80101be7:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
80101bea:	8b 45 08             	mov    0x8(%ebp),%eax
80101bed:	8b 40 04             	mov    0x4(%eax),%eax
80101bf0:	c1 e8 03             	shr    $0x3,%eax
80101bf3:	8d 50 02             	lea    0x2(%eax),%edx
80101bf6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf9:	8b 00                	mov    (%eax),%eax
80101bfb:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bff:	89 04 24             	mov    %eax,(%esp)
80101c02:	e8 9f e5 ff ff       	call   801001a6 <bread>
80101c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c0d:	8d 50 18             	lea    0x18(%eax),%edx
80101c10:	8b 45 08             	mov    0x8(%ebp),%eax
80101c13:	8b 40 04             	mov    0x4(%eax),%eax
80101c16:	83 e0 07             	and    $0x7,%eax
80101c19:	c1 e0 06             	shl    $0x6,%eax
80101c1c:	01 d0                	add    %edx,%eax
80101c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101c21:	8b 45 08             	mov    0x8(%ebp),%eax
80101c24:	8b 40 10             	mov    0x10(%eax),%eax
80101c27:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101c2a:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
80101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c30:	66 8b 40 12          	mov    0x12(%eax),%ax
80101c34:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101c37:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
80101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3e:	8b 40 14             	mov    0x14(%eax),%eax
80101c41:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101c44:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
80101c48:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4b:	66 8b 40 16          	mov    0x16(%eax),%ax
80101c4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101c52:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
80101c56:	8b 45 08             	mov    0x8(%ebp),%eax
80101c59:	8b 50 18             	mov    0x18(%eax),%edx
80101c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c5f:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c62:	8b 45 08             	mov    0x8(%ebp),%eax
80101c65:	8d 50 1c             	lea    0x1c(%eax),%edx
80101c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c6b:	83 c0 0c             	add    $0xc,%eax
80101c6e:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101c75:	00 
80101c76:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c7a:	89 04 24             	mov    %eax,(%esp)
80101c7d:	e8 bc 3c 00 00       	call   8010593e <memmove>
  log_write(bp);
80101c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c85:	89 04 24             	mov    %eax,(%esp)
80101c88:	e8 3f 1b 00 00       	call   801037cc <log_write>
  brelse(bp);
80101c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c90:	89 04 24             	mov    %eax,(%esp)
80101c93:	e8 7f e5 ff ff       	call   80100217 <brelse>
}
80101c98:	c9                   	leave  
80101c99:	c3                   	ret    

80101c9a <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101c9a:	55                   	push   %ebp
80101c9b:	89 e5                	mov    %esp,%ebp
80101c9d:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101ca0:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80101ca7:	e8 73 39 00 00       	call   8010561f <acquire>

  // Is the inode already cached?
  empty = 0;
80101cac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101cb3:	c7 45 f4 f4 08 11 80 	movl   $0x801108f4,-0xc(%ebp)
80101cba:	eb 59                	jmp    80101d15 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cbf:	8b 40 08             	mov    0x8(%eax),%eax
80101cc2:	85 c0                	test   %eax,%eax
80101cc4:	7e 35                	jle    80101cfb <iget+0x61>
80101cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cc9:	8b 00                	mov    (%eax),%eax
80101ccb:	3b 45 08             	cmp    0x8(%ebp),%eax
80101cce:	75 2b                	jne    80101cfb <iget+0x61>
80101cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cd3:	8b 40 04             	mov    0x4(%eax),%eax
80101cd6:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101cd9:	75 20                	jne    80101cfb <iget+0x61>
      ip->ref++;
80101cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cde:	8b 40 08             	mov    0x8(%eax),%eax
80101ce1:	8d 50 01             	lea    0x1(%eax),%edx
80101ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ce7:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101cea:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80101cf1:	e8 8b 39 00 00       	call   80105681 <release>
      return ip;
80101cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cf9:	eb 6f                	jmp    80101d6a <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101cfb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101cff:	75 10                	jne    80101d11 <iget+0x77>
80101d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d04:	8b 40 08             	mov    0x8(%eax),%eax
80101d07:	85 c0                	test   %eax,%eax
80101d09:	75 06                	jne    80101d11 <iget+0x77>
      empty = ip;
80101d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d0e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101d11:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101d15:	81 7d f4 94 18 11 80 	cmpl   $0x80111894,-0xc(%ebp)
80101d1c:	72 9e                	jb     80101cbc <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101d1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101d22:	75 0c                	jne    80101d30 <iget+0x96>
    panic("iget: no inodes");
80101d24:	c7 04 24 cb 8d 10 80 	movl   $0x80108dcb,(%esp)
80101d2b:	e8 06 e8 ff ff       	call   80100536 <panic>

  ip = empty;
80101d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d39:	8b 55 08             	mov    0x8(%ebp),%edx
80101d3c:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d41:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d44:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d4a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d54:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101d5b:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80101d62:	e8 1a 39 00 00       	call   80105681 <release>

  return ip;
80101d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101d6a:	c9                   	leave  
80101d6b:	c3                   	ret    

80101d6c <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101d6c:	55                   	push   %ebp
80101d6d:	89 e5                	mov    %esp,%ebp
80101d6f:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101d72:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80101d79:	e8 a1 38 00 00       	call   8010561f <acquire>
  ip->ref++;
80101d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d81:	8b 40 08             	mov    0x8(%eax),%eax
80101d84:	8d 50 01             	lea    0x1(%eax),%edx
80101d87:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8a:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101d8d:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80101d94:	e8 e8 38 00 00       	call   80105681 <release>
  return ip;
80101d99:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101d9c:	c9                   	leave  
80101d9d:	c3                   	ret    

80101d9e <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101d9e:	55                   	push   %ebp
80101d9f:	89 e5                	mov    %esp,%ebp
80101da1:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101da4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101da8:	74 0a                	je     80101db4 <ilock+0x16>
80101daa:	8b 45 08             	mov    0x8(%ebp),%eax
80101dad:	8b 40 08             	mov    0x8(%eax),%eax
80101db0:	85 c0                	test   %eax,%eax
80101db2:	7f 0c                	jg     80101dc0 <ilock+0x22>
    panic("ilock");
80101db4:	c7 04 24 db 8d 10 80 	movl   $0x80108ddb,(%esp)
80101dbb:	e8 76 e7 ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
80101dc0:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80101dc7:	e8 53 38 00 00       	call   8010561f <acquire>
  while(ip->flags & I_BUSY)
80101dcc:	eb 13                	jmp    80101de1 <ilock+0x43>
    sleep(ip, &icache.lock);
80101dce:	c7 44 24 04 c0 08 11 	movl   $0x801108c0,0x4(%esp)
80101dd5:	80 
80101dd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd9:	89 04 24             	mov    %eax,(%esp)
80101ddc:	e8 58 35 00 00       	call   80105339 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101de1:	8b 45 08             	mov    0x8(%ebp),%eax
80101de4:	8b 40 0c             	mov    0xc(%eax),%eax
80101de7:	83 e0 01             	and    $0x1,%eax
80101dea:	85 c0                	test   %eax,%eax
80101dec:	75 e0                	jne    80101dce <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101dee:	8b 45 08             	mov    0x8(%ebp),%eax
80101df1:	8b 40 0c             	mov    0xc(%eax),%eax
80101df4:	89 c2                	mov    %eax,%edx
80101df6:	83 ca 01             	or     $0x1,%edx
80101df9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfc:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101dff:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80101e06:	e8 76 38 00 00       	call   80105681 <release>

  if(!(ip->flags & I_VALID)){
80101e0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0e:	8b 40 0c             	mov    0xc(%eax),%eax
80101e11:	83 e0 02             	and    $0x2,%eax
80101e14:	85 c0                	test   %eax,%eax
80101e16:	0f 85 cb 00 00 00    	jne    80101ee7 <ilock+0x149>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101e1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1f:	8b 40 04             	mov    0x4(%eax),%eax
80101e22:	c1 e8 03             	shr    $0x3,%eax
80101e25:	8d 50 02             	lea    0x2(%eax),%edx
80101e28:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2b:	8b 00                	mov    (%eax),%eax
80101e2d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e31:	89 04 24             	mov    %eax,(%esp)
80101e34:	e8 6d e3 ff ff       	call   801001a6 <bread>
80101e39:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e3f:	8d 50 18             	lea    0x18(%eax),%edx
80101e42:	8b 45 08             	mov    0x8(%ebp),%eax
80101e45:	8b 40 04             	mov    0x4(%eax),%eax
80101e48:	83 e0 07             	and    $0x7,%eax
80101e4b:	c1 e0 06             	shl    $0x6,%eax
80101e4e:	01 d0                	add    %edx,%eax
80101e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101e53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e56:	8b 00                	mov    (%eax),%eax
80101e58:	8b 55 08             	mov    0x8(%ebp),%edx
80101e5b:	66 89 42 10          	mov    %ax,0x10(%edx)
    ip->major = dip->major;
80101e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e62:	66 8b 40 02          	mov    0x2(%eax),%ax
80101e66:	8b 55 08             	mov    0x8(%ebp),%edx
80101e69:	66 89 42 12          	mov    %ax,0x12(%edx)
    ip->minor = dip->minor;
80101e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e70:	8b 40 04             	mov    0x4(%eax),%eax
80101e73:	8b 55 08             	mov    0x8(%ebp),%edx
80101e76:	66 89 42 14          	mov    %ax,0x14(%edx)
    ip->nlink = dip->nlink;
80101e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e7d:	66 8b 40 06          	mov    0x6(%eax),%ax
80101e81:	8b 55 08             	mov    0x8(%ebp),%edx
80101e84:	66 89 42 16          	mov    %ax,0x16(%edx)
    ip->size = dip->size;
80101e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e8b:	8b 50 08             	mov    0x8(%eax),%edx
80101e8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e91:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e97:	8d 50 0c             	lea    0xc(%eax),%edx
80101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9d:	83 c0 1c             	add    $0x1c,%eax
80101ea0:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101ea7:	00 
80101ea8:	89 54 24 04          	mov    %edx,0x4(%esp)
80101eac:	89 04 24             	mov    %eax,(%esp)
80101eaf:	e8 8a 3a 00 00       	call   8010593e <memmove>
    brelse(bp);
80101eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eb7:	89 04 24             	mov    %eax,(%esp)
80101eba:	e8 58 e3 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
80101ebf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec2:	8b 40 0c             	mov    0xc(%eax),%eax
80101ec5:	89 c2                	mov    %eax,%edx
80101ec7:	83 ca 02             	or     $0x2,%edx
80101eca:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecd:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101ed0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed3:	8b 40 10             	mov    0x10(%eax),%eax
80101ed6:	66 85 c0             	test   %ax,%ax
80101ed9:	75 0c                	jne    80101ee7 <ilock+0x149>
      panic("ilock: no type");
80101edb:	c7 04 24 e1 8d 10 80 	movl   $0x80108de1,(%esp)
80101ee2:	e8 4f e6 ff ff       	call   80100536 <panic>
  }
}
80101ee7:	c9                   	leave  
80101ee8:	c3                   	ret    

80101ee9 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101ee9:	55                   	push   %ebp
80101eea:	89 e5                	mov    %esp,%ebp
80101eec:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101eef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101ef3:	74 17                	je     80101f0c <iunlock+0x23>
80101ef5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef8:	8b 40 0c             	mov    0xc(%eax),%eax
80101efb:	83 e0 01             	and    $0x1,%eax
80101efe:	85 c0                	test   %eax,%eax
80101f00:	74 0a                	je     80101f0c <iunlock+0x23>
80101f02:	8b 45 08             	mov    0x8(%ebp),%eax
80101f05:	8b 40 08             	mov    0x8(%eax),%eax
80101f08:	85 c0                	test   %eax,%eax
80101f0a:	7f 0c                	jg     80101f18 <iunlock+0x2f>
    panic("iunlock");
80101f0c:	c7 04 24 f0 8d 10 80 	movl   $0x80108df0,(%esp)
80101f13:	e8 1e e6 ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
80101f18:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80101f1f:	e8 fb 36 00 00       	call   8010561f <acquire>
  ip->flags &= ~I_BUSY;
80101f24:	8b 45 08             	mov    0x8(%ebp),%eax
80101f27:	8b 40 0c             	mov    0xc(%eax),%eax
80101f2a:	89 c2                	mov    %eax,%edx
80101f2c:	83 e2 fe             	and    $0xfffffffe,%edx
80101f2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f32:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101f35:	8b 45 08             	mov    0x8(%ebp),%eax
80101f38:	89 04 24             	mov    %eax,(%esp)
80101f3b:	e8 d5 34 00 00       	call   80105415 <wakeup>
  release(&icache.lock);
80101f40:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80101f47:	e8 35 37 00 00       	call   80105681 <release>
}
80101f4c:	c9                   	leave  
80101f4d:	c3                   	ret    

80101f4e <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101f4e:	55                   	push   %ebp
80101f4f:	89 e5                	mov    %esp,%ebp
80101f51:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101f54:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80101f5b:	e8 bf 36 00 00       	call   8010561f <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101f60:	8b 45 08             	mov    0x8(%ebp),%eax
80101f63:	8b 40 08             	mov    0x8(%eax),%eax
80101f66:	83 f8 01             	cmp    $0x1,%eax
80101f69:	0f 85 93 00 00 00    	jne    80102002 <iput+0xb4>
80101f6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f72:	8b 40 0c             	mov    0xc(%eax),%eax
80101f75:	83 e0 02             	and    $0x2,%eax
80101f78:	85 c0                	test   %eax,%eax
80101f7a:	0f 84 82 00 00 00    	je     80102002 <iput+0xb4>
80101f80:	8b 45 08             	mov    0x8(%ebp),%eax
80101f83:	66 8b 40 16          	mov    0x16(%eax),%ax
80101f87:	66 85 c0             	test   %ax,%ax
80101f8a:	75 76                	jne    80102002 <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101f8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8f:	8b 40 0c             	mov    0xc(%eax),%eax
80101f92:	83 e0 01             	and    $0x1,%eax
80101f95:	85 c0                	test   %eax,%eax
80101f97:	74 0c                	je     80101fa5 <iput+0x57>
      panic("iput busy");
80101f99:	c7 04 24 f8 8d 10 80 	movl   $0x80108df8,(%esp)
80101fa0:	e8 91 e5 ff ff       	call   80100536 <panic>
    ip->flags |= I_BUSY;
80101fa5:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa8:	8b 40 0c             	mov    0xc(%eax),%eax
80101fab:	89 c2                	mov    %eax,%edx
80101fad:	83 ca 01             	or     $0x1,%edx
80101fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb3:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101fb6:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80101fbd:	e8 bf 36 00 00       	call   80105681 <release>
    itrunc(ip);
80101fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc5:	89 04 24             	mov    %eax,(%esp)
80101fc8:	e8 7d 01 00 00       	call   8010214a <itrunc>
    ip->type = 0;
80101fcd:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd0:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101fd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd9:	89 04 24             	mov    %eax,(%esp)
80101fdc:	e8 03 fc ff ff       	call   80101be4 <iupdate>
    acquire(&icache.lock);
80101fe1:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80101fe8:	e8 32 36 00 00       	call   8010561f <acquire>
    ip->flags = 0;
80101fed:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffa:	89 04 24             	mov    %eax,(%esp)
80101ffd:	e8 13 34 00 00       	call   80105415 <wakeup>
  }
  ip->ref--;
80102002:	8b 45 08             	mov    0x8(%ebp),%eax
80102005:	8b 40 08             	mov    0x8(%eax),%eax
80102008:	8d 50 ff             	lea    -0x1(%eax),%edx
8010200b:	8b 45 08             	mov    0x8(%ebp),%eax
8010200e:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80102011:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80102018:	e8 64 36 00 00       	call   80105681 <release>
}
8010201d:	c9                   	leave  
8010201e:	c3                   	ret    

8010201f <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
8010201f:	55                   	push   %ebp
80102020:	89 e5                	mov    %esp,%ebp
80102022:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80102025:	8b 45 08             	mov    0x8(%ebp),%eax
80102028:	89 04 24             	mov    %eax,(%esp)
8010202b:	e8 b9 fe ff ff       	call   80101ee9 <iunlock>
  iput(ip);
80102030:	8b 45 08             	mov    0x8(%ebp),%eax
80102033:	89 04 24             	mov    %eax,(%esp)
80102036:	e8 13 ff ff ff       	call   80101f4e <iput>
}
8010203b:	c9                   	leave  
8010203c:	c3                   	ret    

8010203d <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
8010203d:	55                   	push   %ebp
8010203e:	89 e5                	mov    %esp,%ebp
80102040:	53                   	push   %ebx
80102041:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80102044:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80102048:	77 3e                	ja     80102088 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
8010204a:	8b 45 08             	mov    0x8(%ebp),%eax
8010204d:	8b 55 0c             	mov    0xc(%ebp),%edx
80102050:	83 c2 04             	add    $0x4,%edx
80102053:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80102057:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010205a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010205e:	75 20                	jne    80102080 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80102060:	8b 45 08             	mov    0x8(%ebp),%eax
80102063:	8b 00                	mov    (%eax),%eax
80102065:	89 04 24             	mov    %eax,(%esp)
80102068:	e8 5a f8 ff ff       	call   801018c7 <balloc>
8010206d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102070:	8b 45 08             	mov    0x8(%ebp),%eax
80102073:	8b 55 0c             	mov    0xc(%ebp),%edx
80102076:	8d 4a 04             	lea    0x4(%edx),%ecx
80102079:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010207c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80102080:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102083:	e9 bc 00 00 00       	jmp    80102144 <bmap+0x107>
  }
  bn -= NDIRECT;
80102088:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
8010208c:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80102090:	0f 87 a2 00 00 00    	ja     80102138 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80102096:	8b 45 08             	mov    0x8(%ebp),%eax
80102099:	8b 40 4c             	mov    0x4c(%eax),%eax
8010209c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010209f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801020a3:	75 19                	jne    801020be <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801020a5:	8b 45 08             	mov    0x8(%ebp),%eax
801020a8:	8b 00                	mov    (%eax),%eax
801020aa:	89 04 24             	mov    %eax,(%esp)
801020ad:	e8 15 f8 ff ff       	call   801018c7 <balloc>
801020b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801020b5:	8b 45 08             	mov    0x8(%ebp),%eax
801020b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801020bb:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
801020be:	8b 45 08             	mov    0x8(%ebp),%eax
801020c1:	8b 00                	mov    (%eax),%eax
801020c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801020c6:	89 54 24 04          	mov    %edx,0x4(%esp)
801020ca:	89 04 24             	mov    %eax,(%esp)
801020cd:	e8 d4 e0 ff ff       	call   801001a6 <bread>
801020d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
801020d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020d8:	83 c0 18             	add    $0x18,%eax
801020db:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
801020de:	8b 45 0c             	mov    0xc(%ebp),%eax
801020e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801020e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020eb:	01 d0                	add    %edx,%eax
801020ed:	8b 00                	mov    (%eax),%eax
801020ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
801020f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801020f6:	75 30                	jne    80102128 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
801020f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801020fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80102102:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102105:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80102108:	8b 45 08             	mov    0x8(%ebp),%eax
8010210b:	8b 00                	mov    (%eax),%eax
8010210d:	89 04 24             	mov    %eax,(%esp)
80102110:	e8 b2 f7 ff ff       	call   801018c7 <balloc>
80102115:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102118:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010211b:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
8010211d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102120:	89 04 24             	mov    %eax,(%esp)
80102123:	e8 a4 16 00 00       	call   801037cc <log_write>
    }
    brelse(bp);
80102128:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010212b:	89 04 24             	mov    %eax,(%esp)
8010212e:	e8 e4 e0 ff ff       	call   80100217 <brelse>
    return addr;
80102133:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102136:	eb 0c                	jmp    80102144 <bmap+0x107>
  }

  panic("bmap: out of range");
80102138:	c7 04 24 02 8e 10 80 	movl   $0x80108e02,(%esp)
8010213f:	e8 f2 e3 ff ff       	call   80100536 <panic>
}
80102144:	83 c4 24             	add    $0x24,%esp
80102147:	5b                   	pop    %ebx
80102148:	5d                   	pop    %ebp
80102149:	c3                   	ret    

8010214a <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
8010214a:	55                   	push   %ebp
8010214b:	89 e5                	mov    %esp,%ebp
8010214d:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102150:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102157:	eb 43                	jmp    8010219c <itrunc+0x52>
    if(ip->addrs[i]){
80102159:	8b 45 08             	mov    0x8(%ebp),%eax
8010215c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010215f:	83 c2 04             	add    $0x4,%edx
80102162:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80102166:	85 c0                	test   %eax,%eax
80102168:	74 2f                	je     80102199 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
8010216a:	8b 45 08             	mov    0x8(%ebp),%eax
8010216d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102170:	83 c2 04             	add    $0x4,%edx
80102173:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80102177:	8b 45 08             	mov    0x8(%ebp),%eax
8010217a:	8b 00                	mov    (%eax),%eax
8010217c:	89 54 24 04          	mov    %edx,0x4(%esp)
80102180:	89 04 24             	mov    %eax,(%esp)
80102183:	e8 90 f8 ff ff       	call   80101a18 <bfree>
      ip->addrs[i] = 0;
80102188:	8b 45 08             	mov    0x8(%ebp),%eax
8010218b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010218e:	83 c2 04             	add    $0x4,%edx
80102191:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80102198:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102199:	ff 45 f4             	incl   -0xc(%ebp)
8010219c:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
801021a0:	7e b7                	jle    80102159 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
801021a2:	8b 45 08             	mov    0x8(%ebp),%eax
801021a5:	8b 40 4c             	mov    0x4c(%eax),%eax
801021a8:	85 c0                	test   %eax,%eax
801021aa:	0f 84 9a 00 00 00    	je     8010224a <itrunc+0x100>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801021b0:	8b 45 08             	mov    0x8(%ebp),%eax
801021b3:	8b 50 4c             	mov    0x4c(%eax),%edx
801021b6:	8b 45 08             	mov    0x8(%ebp),%eax
801021b9:	8b 00                	mov    (%eax),%eax
801021bb:	89 54 24 04          	mov    %edx,0x4(%esp)
801021bf:	89 04 24             	mov    %eax,(%esp)
801021c2:	e8 df df ff ff       	call   801001a6 <bread>
801021c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
801021ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021cd:	83 c0 18             	add    $0x18,%eax
801021d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801021d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801021da:	eb 3a                	jmp    80102216 <itrunc+0xcc>
      if(a[j])
801021dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801021e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801021e9:	01 d0                	add    %edx,%eax
801021eb:	8b 00                	mov    (%eax),%eax
801021ed:	85 c0                	test   %eax,%eax
801021ef:	74 22                	je     80102213 <itrunc+0xc9>
        bfree(ip->dev, a[j]);
801021f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801021fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801021fe:	01 d0                	add    %edx,%eax
80102200:	8b 10                	mov    (%eax),%edx
80102202:	8b 45 08             	mov    0x8(%ebp),%eax
80102205:	8b 00                	mov    (%eax),%eax
80102207:	89 54 24 04          	mov    %edx,0x4(%esp)
8010220b:	89 04 24             	mov    %eax,(%esp)
8010220e:	e8 05 f8 ff ff       	call   80101a18 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80102213:	ff 45 f0             	incl   -0x10(%ebp)
80102216:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102219:	83 f8 7f             	cmp    $0x7f,%eax
8010221c:	76 be                	jbe    801021dc <itrunc+0x92>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
8010221e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102221:	89 04 24             	mov    %eax,(%esp)
80102224:	e8 ee df ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102229:	8b 45 08             	mov    0x8(%ebp),%eax
8010222c:	8b 50 4c             	mov    0x4c(%eax),%edx
8010222f:	8b 45 08             	mov    0x8(%ebp),%eax
80102232:	8b 00                	mov    (%eax),%eax
80102234:	89 54 24 04          	mov    %edx,0x4(%esp)
80102238:	89 04 24             	mov    %eax,(%esp)
8010223b:	e8 d8 f7 ff ff       	call   80101a18 <bfree>
    ip->addrs[NDIRECT] = 0;
80102240:	8b 45 08             	mov    0x8(%ebp),%eax
80102243:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
8010224a:	8b 45 08             	mov    0x8(%ebp),%eax
8010224d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80102254:	8b 45 08             	mov    0x8(%ebp),%eax
80102257:	89 04 24             	mov    %eax,(%esp)
8010225a:	e8 85 f9 ff ff       	call   80101be4 <iupdate>
}
8010225f:	c9                   	leave  
80102260:	c3                   	ret    

80102261 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80102261:	55                   	push   %ebp
80102262:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80102264:	8b 45 08             	mov    0x8(%ebp),%eax
80102267:	8b 00                	mov    (%eax),%eax
80102269:	89 c2                	mov    %eax,%edx
8010226b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010226e:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80102271:	8b 45 08             	mov    0x8(%ebp),%eax
80102274:	8b 50 04             	mov    0x4(%eax),%edx
80102277:	8b 45 0c             	mov    0xc(%ebp),%eax
8010227a:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
8010227d:	8b 45 08             	mov    0x8(%ebp),%eax
80102280:	8b 40 10             	mov    0x10(%eax),%eax
80102283:	8b 55 0c             	mov    0xc(%ebp),%edx
80102286:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80102289:	8b 45 08             	mov    0x8(%ebp),%eax
8010228c:	66 8b 40 16          	mov    0x16(%eax),%ax
80102290:	8b 55 0c             	mov    0xc(%ebp),%edx
80102293:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80102297:	8b 45 08             	mov    0x8(%ebp),%eax
8010229a:	8b 50 18             	mov    0x18(%eax),%edx
8010229d:	8b 45 0c             	mov    0xc(%ebp),%eax
801022a0:	89 50 10             	mov    %edx,0x10(%eax)
}
801022a3:	5d                   	pop    %ebp
801022a4:	c3                   	ret    

801022a5 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801022a5:	55                   	push   %ebp
801022a6:	89 e5                	mov    %esp,%ebp
801022a8:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801022ab:	8b 45 08             	mov    0x8(%ebp),%eax
801022ae:	8b 40 10             	mov    0x10(%eax),%eax
801022b1:	66 83 f8 03          	cmp    $0x3,%ax
801022b5:	75 60                	jne    80102317 <readi+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801022b7:	8b 45 08             	mov    0x8(%ebp),%eax
801022ba:	66 8b 40 12          	mov    0x12(%eax),%ax
801022be:	66 85 c0             	test   %ax,%ax
801022c1:	78 20                	js     801022e3 <readi+0x3e>
801022c3:	8b 45 08             	mov    0x8(%ebp),%eax
801022c6:	66 8b 40 12          	mov    0x12(%eax),%ax
801022ca:	66 83 f8 09          	cmp    $0x9,%ax
801022ce:	7f 13                	jg     801022e3 <readi+0x3e>
801022d0:	8b 45 08             	mov    0x8(%ebp),%eax
801022d3:	66 8b 40 12          	mov    0x12(%eax),%ax
801022d7:	98                   	cwtl   
801022d8:	8b 04 c5 60 08 11 80 	mov    -0x7feef7a0(,%eax,8),%eax
801022df:	85 c0                	test   %eax,%eax
801022e1:	75 0a                	jne    801022ed <readi+0x48>
      return -1;
801022e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022e8:	e9 1b 01 00 00       	jmp    80102408 <readi+0x163>
    return devsw[ip->major].read(ip, dst, n);
801022ed:	8b 45 08             	mov    0x8(%ebp),%eax
801022f0:	66 8b 40 12          	mov    0x12(%eax),%ax
801022f4:	98                   	cwtl   
801022f5:	8b 04 c5 60 08 11 80 	mov    -0x7feef7a0(,%eax,8),%eax
801022fc:	8b 55 14             	mov    0x14(%ebp),%edx
801022ff:	89 54 24 08          	mov    %edx,0x8(%esp)
80102303:	8b 55 0c             	mov    0xc(%ebp),%edx
80102306:	89 54 24 04          	mov    %edx,0x4(%esp)
8010230a:	8b 55 08             	mov    0x8(%ebp),%edx
8010230d:	89 14 24             	mov    %edx,(%esp)
80102310:	ff d0                	call   *%eax
80102312:	e9 f1 00 00 00       	jmp    80102408 <readi+0x163>
  }

  if(off > ip->size || off + n < off)
80102317:	8b 45 08             	mov    0x8(%ebp),%eax
8010231a:	8b 40 18             	mov    0x18(%eax),%eax
8010231d:	3b 45 10             	cmp    0x10(%ebp),%eax
80102320:	72 0d                	jb     8010232f <readi+0x8a>
80102322:	8b 45 14             	mov    0x14(%ebp),%eax
80102325:	8b 55 10             	mov    0x10(%ebp),%edx
80102328:	01 d0                	add    %edx,%eax
8010232a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010232d:	73 0a                	jae    80102339 <readi+0x94>
    return -1;
8010232f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102334:	e9 cf 00 00 00       	jmp    80102408 <readi+0x163>
  if(off + n > ip->size)
80102339:	8b 45 14             	mov    0x14(%ebp),%eax
8010233c:	8b 55 10             	mov    0x10(%ebp),%edx
8010233f:	01 c2                	add    %eax,%edx
80102341:	8b 45 08             	mov    0x8(%ebp),%eax
80102344:	8b 40 18             	mov    0x18(%eax),%eax
80102347:	39 c2                	cmp    %eax,%edx
80102349:	76 0c                	jbe    80102357 <readi+0xb2>
    n = ip->size - off;
8010234b:	8b 45 08             	mov    0x8(%ebp),%eax
8010234e:	8b 40 18             	mov    0x18(%eax),%eax
80102351:	2b 45 10             	sub    0x10(%ebp),%eax
80102354:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102357:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010235e:	e9 96 00 00 00       	jmp    801023f9 <readi+0x154>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102363:	8b 45 10             	mov    0x10(%ebp),%eax
80102366:	c1 e8 09             	shr    $0x9,%eax
80102369:	89 44 24 04          	mov    %eax,0x4(%esp)
8010236d:	8b 45 08             	mov    0x8(%ebp),%eax
80102370:	89 04 24             	mov    %eax,(%esp)
80102373:	e8 c5 fc ff ff       	call   8010203d <bmap>
80102378:	8b 55 08             	mov    0x8(%ebp),%edx
8010237b:	8b 12                	mov    (%edx),%edx
8010237d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102381:	89 14 24             	mov    %edx,(%esp)
80102384:	e8 1d de ff ff       	call   801001a6 <bread>
80102389:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010238c:	8b 45 10             	mov    0x10(%ebp),%eax
8010238f:	89 c2                	mov    %eax,%edx
80102391:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102397:	b8 00 02 00 00       	mov    $0x200,%eax
8010239c:	89 c1                	mov    %eax,%ecx
8010239e:	29 d1                	sub    %edx,%ecx
801023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a3:	8b 55 14             	mov    0x14(%ebp),%edx
801023a6:	29 c2                	sub    %eax,%edx
801023a8:	89 c8                	mov    %ecx,%eax
801023aa:	39 d0                	cmp    %edx,%eax
801023ac:	76 02                	jbe    801023b0 <readi+0x10b>
801023ae:	89 d0                	mov    %edx,%eax
801023b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
801023b3:	8b 45 10             	mov    0x10(%ebp),%eax
801023b6:	25 ff 01 00 00       	and    $0x1ff,%eax
801023bb:	8d 50 10             	lea    0x10(%eax),%edx
801023be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023c1:	01 d0                	add    %edx,%eax
801023c3:	8d 50 08             	lea    0x8(%eax),%edx
801023c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023c9:	89 44 24 08          	mov    %eax,0x8(%esp)
801023cd:	89 54 24 04          	mov    %edx,0x4(%esp)
801023d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801023d4:	89 04 24             	mov    %eax,(%esp)
801023d7:	e8 62 35 00 00       	call   8010593e <memmove>
    brelse(bp);
801023dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023df:	89 04 24             	mov    %eax,(%esp)
801023e2:	e8 30 de ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801023e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023ea:	01 45 f4             	add    %eax,-0xc(%ebp)
801023ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023f0:	01 45 10             	add    %eax,0x10(%ebp)
801023f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023f6:	01 45 0c             	add    %eax,0xc(%ebp)
801023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023fc:	3b 45 14             	cmp    0x14(%ebp),%eax
801023ff:	0f 82 5e ff ff ff    	jb     80102363 <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102405:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102408:	c9                   	leave  
80102409:	c3                   	ret    

8010240a <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010240a:	55                   	push   %ebp
8010240b:	89 e5                	mov    %esp,%ebp
8010240d:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102410:	8b 45 08             	mov    0x8(%ebp),%eax
80102413:	8b 40 10             	mov    0x10(%eax),%eax
80102416:	66 83 f8 03          	cmp    $0x3,%ax
8010241a:	75 60                	jne    8010247c <writei+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010241c:	8b 45 08             	mov    0x8(%ebp),%eax
8010241f:	66 8b 40 12          	mov    0x12(%eax),%ax
80102423:	66 85 c0             	test   %ax,%ax
80102426:	78 20                	js     80102448 <writei+0x3e>
80102428:	8b 45 08             	mov    0x8(%ebp),%eax
8010242b:	66 8b 40 12          	mov    0x12(%eax),%ax
8010242f:	66 83 f8 09          	cmp    $0x9,%ax
80102433:	7f 13                	jg     80102448 <writei+0x3e>
80102435:	8b 45 08             	mov    0x8(%ebp),%eax
80102438:	66 8b 40 12          	mov    0x12(%eax),%ax
8010243c:	98                   	cwtl   
8010243d:	8b 04 c5 64 08 11 80 	mov    -0x7feef79c(,%eax,8),%eax
80102444:	85 c0                	test   %eax,%eax
80102446:	75 0a                	jne    80102452 <writei+0x48>
      return -1;
80102448:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010244d:	e9 46 01 00 00       	jmp    80102598 <writei+0x18e>
    return devsw[ip->major].write(ip, src, n);
80102452:	8b 45 08             	mov    0x8(%ebp),%eax
80102455:	66 8b 40 12          	mov    0x12(%eax),%ax
80102459:	98                   	cwtl   
8010245a:	8b 04 c5 64 08 11 80 	mov    -0x7feef79c(,%eax,8),%eax
80102461:	8b 55 14             	mov    0x14(%ebp),%edx
80102464:	89 54 24 08          	mov    %edx,0x8(%esp)
80102468:	8b 55 0c             	mov    0xc(%ebp),%edx
8010246b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010246f:	8b 55 08             	mov    0x8(%ebp),%edx
80102472:	89 14 24             	mov    %edx,(%esp)
80102475:	ff d0                	call   *%eax
80102477:	e9 1c 01 00 00       	jmp    80102598 <writei+0x18e>
  }

  if(off > ip->size || off + n < off)
8010247c:	8b 45 08             	mov    0x8(%ebp),%eax
8010247f:	8b 40 18             	mov    0x18(%eax),%eax
80102482:	3b 45 10             	cmp    0x10(%ebp),%eax
80102485:	72 0d                	jb     80102494 <writei+0x8a>
80102487:	8b 45 14             	mov    0x14(%ebp),%eax
8010248a:	8b 55 10             	mov    0x10(%ebp),%edx
8010248d:	01 d0                	add    %edx,%eax
8010248f:	3b 45 10             	cmp    0x10(%ebp),%eax
80102492:	73 0a                	jae    8010249e <writei+0x94>
    return -1;
80102494:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102499:	e9 fa 00 00 00       	jmp    80102598 <writei+0x18e>
  if(off + n > MAXFILE*BSIZE)
8010249e:	8b 45 14             	mov    0x14(%ebp),%eax
801024a1:	8b 55 10             	mov    0x10(%ebp),%edx
801024a4:	01 d0                	add    %edx,%eax
801024a6:	3d 00 18 01 00       	cmp    $0x11800,%eax
801024ab:	76 0a                	jbe    801024b7 <writei+0xad>
    return -1;
801024ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024b2:	e9 e1 00 00 00       	jmp    80102598 <writei+0x18e>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801024b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801024be:	e9 a1 00 00 00       	jmp    80102564 <writei+0x15a>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801024c3:	8b 45 10             	mov    0x10(%ebp),%eax
801024c6:	c1 e8 09             	shr    $0x9,%eax
801024c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801024cd:	8b 45 08             	mov    0x8(%ebp),%eax
801024d0:	89 04 24             	mov    %eax,(%esp)
801024d3:	e8 65 fb ff ff       	call   8010203d <bmap>
801024d8:	8b 55 08             	mov    0x8(%ebp),%edx
801024db:	8b 12                	mov    (%edx),%edx
801024dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801024e1:	89 14 24             	mov    %edx,(%esp)
801024e4:	e8 bd dc ff ff       	call   801001a6 <bread>
801024e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801024ec:	8b 45 10             	mov    0x10(%ebp),%eax
801024ef:	89 c2                	mov    %eax,%edx
801024f1:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801024f7:	b8 00 02 00 00       	mov    $0x200,%eax
801024fc:	89 c1                	mov    %eax,%ecx
801024fe:	29 d1                	sub    %edx,%ecx
80102500:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102503:	8b 55 14             	mov    0x14(%ebp),%edx
80102506:	29 c2                	sub    %eax,%edx
80102508:	89 c8                	mov    %ecx,%eax
8010250a:	39 d0                	cmp    %edx,%eax
8010250c:	76 02                	jbe    80102510 <writei+0x106>
8010250e:	89 d0                	mov    %edx,%eax
80102510:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102513:	8b 45 10             	mov    0x10(%ebp),%eax
80102516:	25 ff 01 00 00       	and    $0x1ff,%eax
8010251b:	8d 50 10             	lea    0x10(%eax),%edx
8010251e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102521:	01 d0                	add    %edx,%eax
80102523:	8d 50 08             	lea    0x8(%eax),%edx
80102526:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102529:	89 44 24 08          	mov    %eax,0x8(%esp)
8010252d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102530:	89 44 24 04          	mov    %eax,0x4(%esp)
80102534:	89 14 24             	mov    %edx,(%esp)
80102537:	e8 02 34 00 00       	call   8010593e <memmove>
    log_write(bp);
8010253c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010253f:	89 04 24             	mov    %eax,(%esp)
80102542:	e8 85 12 00 00       	call   801037cc <log_write>
    brelse(bp);
80102547:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010254a:	89 04 24             	mov    %eax,(%esp)
8010254d:	e8 c5 dc ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102552:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102555:	01 45 f4             	add    %eax,-0xc(%ebp)
80102558:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010255b:	01 45 10             	add    %eax,0x10(%ebp)
8010255e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102561:	01 45 0c             	add    %eax,0xc(%ebp)
80102564:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102567:	3b 45 14             	cmp    0x14(%ebp),%eax
8010256a:	0f 82 53 ff ff ff    	jb     801024c3 <writei+0xb9>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102570:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102574:	74 1f                	je     80102595 <writei+0x18b>
80102576:	8b 45 08             	mov    0x8(%ebp),%eax
80102579:	8b 40 18             	mov    0x18(%eax),%eax
8010257c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010257f:	73 14                	jae    80102595 <writei+0x18b>
    ip->size = off;
80102581:	8b 45 08             	mov    0x8(%ebp),%eax
80102584:	8b 55 10             	mov    0x10(%ebp),%edx
80102587:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010258a:	8b 45 08             	mov    0x8(%ebp),%eax
8010258d:	89 04 24             	mov    %eax,(%esp)
80102590:	e8 4f f6 ff ff       	call   80101be4 <iupdate>
  }
  return n;
80102595:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102598:	c9                   	leave  
80102599:	c3                   	ret    

8010259a <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010259a:	55                   	push   %ebp
8010259b:	89 e5                	mov    %esp,%ebp
8010259d:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801025a0:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801025a7:	00 
801025a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801025ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801025af:	8b 45 08             	mov    0x8(%ebp),%eax
801025b2:	89 04 24             	mov    %eax,(%esp)
801025b5:	e8 20 34 00 00       	call   801059da <strncmp>
}
801025ba:	c9                   	leave  
801025bb:	c3                   	ret    

801025bc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801025bc:	55                   	push   %ebp
801025bd:	89 e5                	mov    %esp,%ebp
801025bf:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801025c2:	8b 45 08             	mov    0x8(%ebp),%eax
801025c5:	8b 40 10             	mov    0x10(%eax),%eax
801025c8:	66 83 f8 01          	cmp    $0x1,%ax
801025cc:	74 0c                	je     801025da <dirlookup+0x1e>
    panic("dirlookup not DIR");
801025ce:	c7 04 24 15 8e 10 80 	movl   $0x80108e15,(%esp)
801025d5:	e8 5c df ff ff       	call   80100536 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801025da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025e1:	e9 85 00 00 00       	jmp    8010266b <dirlookup+0xaf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801025e6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801025ed:	00 
801025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025f1:	89 44 24 08          	mov    %eax,0x8(%esp)
801025f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801025f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801025fc:	8b 45 08             	mov    0x8(%ebp),%eax
801025ff:	89 04 24             	mov    %eax,(%esp)
80102602:	e8 9e fc ff ff       	call   801022a5 <readi>
80102607:	83 f8 10             	cmp    $0x10,%eax
8010260a:	74 0c                	je     80102618 <dirlookup+0x5c>
      panic("dirlink read");
8010260c:	c7 04 24 27 8e 10 80 	movl   $0x80108e27,(%esp)
80102613:	e8 1e df ff ff       	call   80100536 <panic>
    if(de.inum == 0)
80102618:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010261b:	66 85 c0             	test   %ax,%ax
8010261e:	74 46                	je     80102666 <dirlookup+0xaa>
      continue;
    if(namecmp(name, de.name) == 0){
80102620:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102623:	83 c0 02             	add    $0x2,%eax
80102626:	89 44 24 04          	mov    %eax,0x4(%esp)
8010262a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010262d:	89 04 24             	mov    %eax,(%esp)
80102630:	e8 65 ff ff ff       	call   8010259a <namecmp>
80102635:	85 c0                	test   %eax,%eax
80102637:	75 2e                	jne    80102667 <dirlookup+0xab>
      // entry matches path element
      if(poff)
80102639:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010263d:	74 08                	je     80102647 <dirlookup+0x8b>
        *poff = off;
8010263f:	8b 45 10             	mov    0x10(%ebp),%eax
80102642:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102645:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102647:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010264a:	0f b7 c0             	movzwl %ax,%eax
8010264d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102650:	8b 45 08             	mov    0x8(%ebp),%eax
80102653:	8b 00                	mov    (%eax),%eax
80102655:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102658:	89 54 24 04          	mov    %edx,0x4(%esp)
8010265c:	89 04 24             	mov    %eax,(%esp)
8010265f:	e8 36 f6 ff ff       	call   80101c9a <iget>
80102664:	eb 19                	jmp    8010267f <dirlookup+0xc3>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102666:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102667:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010266b:	8b 45 08             	mov    0x8(%ebp),%eax
8010266e:	8b 40 18             	mov    0x18(%eax),%eax
80102671:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102674:	0f 87 6c ff ff ff    	ja     801025e6 <dirlookup+0x2a>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010267a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010267f:	c9                   	leave  
80102680:	c3                   	ret    

80102681 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102681:	55                   	push   %ebp
80102682:	89 e5                	mov    %esp,%ebp
80102684:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102687:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010268e:	00 
8010268f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102692:	89 44 24 04          	mov    %eax,0x4(%esp)
80102696:	8b 45 08             	mov    0x8(%ebp),%eax
80102699:	89 04 24             	mov    %eax,(%esp)
8010269c:	e8 1b ff ff ff       	call   801025bc <dirlookup>
801026a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801026a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801026a8:	74 15                	je     801026bf <dirlink+0x3e>
    iput(ip);
801026aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026ad:	89 04 24             	mov    %eax,(%esp)
801026b0:	e8 99 f8 ff ff       	call   80101f4e <iput>
    return -1;
801026b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026ba:	e9 b7 00 00 00       	jmp    80102776 <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801026bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026c6:	eb 43                	jmp    8010270b <dirlink+0x8a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026cb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801026d2:	00 
801026d3:	89 44 24 08          	mov    %eax,0x8(%esp)
801026d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801026da:	89 44 24 04          	mov    %eax,0x4(%esp)
801026de:	8b 45 08             	mov    0x8(%ebp),%eax
801026e1:	89 04 24             	mov    %eax,(%esp)
801026e4:	e8 bc fb ff ff       	call   801022a5 <readi>
801026e9:	83 f8 10             	cmp    $0x10,%eax
801026ec:	74 0c                	je     801026fa <dirlink+0x79>
      panic("dirlink read");
801026ee:	c7 04 24 27 8e 10 80 	movl   $0x80108e27,(%esp)
801026f5:	e8 3c de ff ff       	call   80100536 <panic>
    if(de.inum == 0)
801026fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801026fd:	66 85 c0             	test   %ax,%ax
80102700:	74 18                	je     8010271a <dirlink+0x99>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102705:	83 c0 10             	add    $0x10,%eax
80102708:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010270b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010270e:	8b 45 08             	mov    0x8(%ebp),%eax
80102711:	8b 40 18             	mov    0x18(%eax),%eax
80102714:	39 c2                	cmp    %eax,%edx
80102716:	72 b0                	jb     801026c8 <dirlink+0x47>
80102718:	eb 01                	jmp    8010271b <dirlink+0x9a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
8010271a:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
8010271b:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102722:	00 
80102723:	8b 45 0c             	mov    0xc(%ebp),%eax
80102726:	89 44 24 04          	mov    %eax,0x4(%esp)
8010272a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010272d:	83 c0 02             	add    $0x2,%eax
80102730:	89 04 24             	mov    %eax,(%esp)
80102733:	e8 f2 32 00 00       	call   80105a2a <strncpy>
  de.inum = inum;
80102738:	8b 45 10             	mov    0x10(%ebp),%eax
8010273b:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102742:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102749:	00 
8010274a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010274e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102751:	89 44 24 04          	mov    %eax,0x4(%esp)
80102755:	8b 45 08             	mov    0x8(%ebp),%eax
80102758:	89 04 24             	mov    %eax,(%esp)
8010275b:	e8 aa fc ff ff       	call   8010240a <writei>
80102760:	83 f8 10             	cmp    $0x10,%eax
80102763:	74 0c                	je     80102771 <dirlink+0xf0>
    panic("dirlink");
80102765:	c7 04 24 34 8e 10 80 	movl   $0x80108e34,(%esp)
8010276c:	e8 c5 dd ff ff       	call   80100536 <panic>
  
  return 0;
80102771:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102776:	c9                   	leave  
80102777:	c3                   	ret    

80102778 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102778:	55                   	push   %ebp
80102779:	89 e5                	mov    %esp,%ebp
8010277b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
8010277e:	eb 03                	jmp    80102783 <skipelem+0xb>
    path++;
80102780:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102783:	8b 45 08             	mov    0x8(%ebp),%eax
80102786:	8a 00                	mov    (%eax),%al
80102788:	3c 2f                	cmp    $0x2f,%al
8010278a:	74 f4                	je     80102780 <skipelem+0x8>
    path++;
  if(*path == 0)
8010278c:	8b 45 08             	mov    0x8(%ebp),%eax
8010278f:	8a 00                	mov    (%eax),%al
80102791:	84 c0                	test   %al,%al
80102793:	75 0a                	jne    8010279f <skipelem+0x27>
    return 0;
80102795:	b8 00 00 00 00       	mov    $0x0,%eax
8010279a:	e9 83 00 00 00       	jmp    80102822 <skipelem+0xaa>
  s = path;
8010279f:	8b 45 08             	mov    0x8(%ebp),%eax
801027a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801027a5:	eb 03                	jmp    801027aa <skipelem+0x32>
    path++;
801027a7:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801027aa:	8b 45 08             	mov    0x8(%ebp),%eax
801027ad:	8a 00                	mov    (%eax),%al
801027af:	3c 2f                	cmp    $0x2f,%al
801027b1:	74 09                	je     801027bc <skipelem+0x44>
801027b3:	8b 45 08             	mov    0x8(%ebp),%eax
801027b6:	8a 00                	mov    (%eax),%al
801027b8:	84 c0                	test   %al,%al
801027ba:	75 eb                	jne    801027a7 <skipelem+0x2f>
    path++;
  len = path - s;
801027bc:	8b 55 08             	mov    0x8(%ebp),%edx
801027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027c2:	89 d1                	mov    %edx,%ecx
801027c4:	29 c1                	sub    %eax,%ecx
801027c6:	89 c8                	mov    %ecx,%eax
801027c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801027cb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801027cf:	7e 1c                	jle    801027ed <skipelem+0x75>
    memmove(name, s, DIRSIZ);
801027d1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801027d8:	00 
801027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801027e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801027e3:	89 04 24             	mov    %eax,(%esp)
801027e6:	e8 53 31 00 00       	call   8010593e <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801027eb:	eb 29                	jmp    80102816 <skipelem+0x9e>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801027ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027f0:	89 44 24 08          	mov    %eax,0x8(%esp)
801027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801027fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801027fe:	89 04 24             	mov    %eax,(%esp)
80102801:	e8 38 31 00 00       	call   8010593e <memmove>
    name[len] = 0;
80102806:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102809:	8b 45 0c             	mov    0xc(%ebp),%eax
8010280c:	01 d0                	add    %edx,%eax
8010280e:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102811:	eb 03                	jmp    80102816 <skipelem+0x9e>
    path++;
80102813:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102816:	8b 45 08             	mov    0x8(%ebp),%eax
80102819:	8a 00                	mov    (%eax),%al
8010281b:	3c 2f                	cmp    $0x2f,%al
8010281d:	74 f4                	je     80102813 <skipelem+0x9b>
    path++;
  return path;
8010281f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102822:	c9                   	leave  
80102823:	c3                   	ret    

80102824 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102824:	55                   	push   %ebp
80102825:	89 e5                	mov    %esp,%ebp
80102827:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010282a:	8b 45 08             	mov    0x8(%ebp),%eax
8010282d:	8a 00                	mov    (%eax),%al
8010282f:	3c 2f                	cmp    $0x2f,%al
80102831:	75 1c                	jne    8010284f <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
80102833:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010283a:	00 
8010283b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102842:	e8 53 f4 ff ff       	call   80101c9a <iget>
80102847:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010284a:	e9 ad 00 00 00       	jmp    801028fc <namex+0xd8>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010284f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102855:	8b 40 68             	mov    0x68(%eax),%eax
80102858:	89 04 24             	mov    %eax,(%esp)
8010285b:	e8 0c f5 ff ff       	call   80101d6c <idup>
80102860:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102863:	e9 94 00 00 00       	jmp    801028fc <namex+0xd8>
    ilock(ip);
80102868:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010286b:	89 04 24             	mov    %eax,(%esp)
8010286e:	e8 2b f5 ff ff       	call   80101d9e <ilock>
    if(ip->type != T_DIR){
80102873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102876:	8b 40 10             	mov    0x10(%eax),%eax
80102879:	66 83 f8 01          	cmp    $0x1,%ax
8010287d:	74 15                	je     80102894 <namex+0x70>
      iunlockput(ip);
8010287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102882:	89 04 24             	mov    %eax,(%esp)
80102885:	e8 95 f7 ff ff       	call   8010201f <iunlockput>
      return 0;
8010288a:	b8 00 00 00 00       	mov    $0x0,%eax
8010288f:	e9 a2 00 00 00       	jmp    80102936 <namex+0x112>
    }
    if(nameiparent && *path == '\0'){
80102894:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102898:	74 1c                	je     801028b6 <namex+0x92>
8010289a:	8b 45 08             	mov    0x8(%ebp),%eax
8010289d:	8a 00                	mov    (%eax),%al
8010289f:	84 c0                	test   %al,%al
801028a1:	75 13                	jne    801028b6 <namex+0x92>
      // Stop one level early.
      iunlock(ip);
801028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028a6:	89 04 24             	mov    %eax,(%esp)
801028a9:	e8 3b f6 ff ff       	call   80101ee9 <iunlock>
      return ip;
801028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028b1:	e9 80 00 00 00       	jmp    80102936 <namex+0x112>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801028b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801028bd:	00 
801028be:	8b 45 10             	mov    0x10(%ebp),%eax
801028c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c8:	89 04 24             	mov    %eax,(%esp)
801028cb:	e8 ec fc ff ff       	call   801025bc <dirlookup>
801028d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801028d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801028d7:	75 12                	jne    801028eb <namex+0xc7>
      iunlockput(ip);
801028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028dc:	89 04 24             	mov    %eax,(%esp)
801028df:	e8 3b f7 ff ff       	call   8010201f <iunlockput>
      return 0;
801028e4:	b8 00 00 00 00       	mov    $0x0,%eax
801028e9:	eb 4b                	jmp    80102936 <namex+0x112>
    }
    iunlockput(ip);
801028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ee:	89 04 24             	mov    %eax,(%esp)
801028f1:	e8 29 f7 ff ff       	call   8010201f <iunlockput>
    ip = next;
801028f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801028fc:	8b 45 10             	mov    0x10(%ebp),%eax
801028ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80102903:	8b 45 08             	mov    0x8(%ebp),%eax
80102906:	89 04 24             	mov    %eax,(%esp)
80102909:	e8 6a fe ff ff       	call   80102778 <skipelem>
8010290e:	89 45 08             	mov    %eax,0x8(%ebp)
80102911:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102915:	0f 85 4d ff ff ff    	jne    80102868 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010291b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010291f:	74 12                	je     80102933 <namex+0x10f>
    iput(ip);
80102921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102924:	89 04 24             	mov    %eax,(%esp)
80102927:	e8 22 f6 ff ff       	call   80101f4e <iput>
    return 0;
8010292c:	b8 00 00 00 00       	mov    $0x0,%eax
80102931:	eb 03                	jmp    80102936 <namex+0x112>
  }
  return ip;
80102933:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102936:	c9                   	leave  
80102937:	c3                   	ret    

80102938 <namei>:

struct inode*
namei(char *path)
{
80102938:	55                   	push   %ebp
80102939:	89 e5                	mov    %esp,%ebp
8010293b:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010293e:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102941:	89 44 24 08          	mov    %eax,0x8(%esp)
80102945:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010294c:	00 
8010294d:	8b 45 08             	mov    0x8(%ebp),%eax
80102950:	89 04 24             	mov    %eax,(%esp)
80102953:	e8 cc fe ff ff       	call   80102824 <namex>
}
80102958:	c9                   	leave  
80102959:	c3                   	ret    

8010295a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010295a:	55                   	push   %ebp
8010295b:	89 e5                	mov    %esp,%ebp
8010295d:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102960:	8b 45 0c             	mov    0xc(%ebp),%eax
80102963:	89 44 24 08          	mov    %eax,0x8(%esp)
80102967:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010296e:	00 
8010296f:	8b 45 08             	mov    0x8(%ebp),%eax
80102972:	89 04 24             	mov    %eax,(%esp)
80102975:	e8 aa fe ff ff       	call   80102824 <namex>
}
8010297a:	c9                   	leave  
8010297b:	c3                   	ret    

8010297c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010297c:	55                   	push   %ebp
8010297d:	89 e5                	mov    %esp,%ebp
8010297f:	53                   	push   %ebx
80102980:	83 ec 14             	sub    $0x14,%esp
80102983:	8b 45 08             	mov    0x8(%ebp),%eax
80102986:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010298a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010298d:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102991:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
80102995:	ec                   	in     (%dx),%al
80102996:	88 c3                	mov    %al,%bl
80102998:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
8010299b:	8a 45 fb             	mov    -0x5(%ebp),%al
}
8010299e:	83 c4 14             	add    $0x14,%esp
801029a1:	5b                   	pop    %ebx
801029a2:	5d                   	pop    %ebp
801029a3:	c3                   	ret    

801029a4 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801029a4:	55                   	push   %ebp
801029a5:	89 e5                	mov    %esp,%ebp
801029a7:	57                   	push   %edi
801029a8:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801029a9:	8b 55 08             	mov    0x8(%ebp),%edx
801029ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029af:	8b 45 10             	mov    0x10(%ebp),%eax
801029b2:	89 cb                	mov    %ecx,%ebx
801029b4:	89 df                	mov    %ebx,%edi
801029b6:	89 c1                	mov    %eax,%ecx
801029b8:	fc                   	cld    
801029b9:	f3 6d                	rep insl (%dx),%es:(%edi)
801029bb:	89 c8                	mov    %ecx,%eax
801029bd:	89 fb                	mov    %edi,%ebx
801029bf:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801029c2:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801029c5:	5b                   	pop    %ebx
801029c6:	5f                   	pop    %edi
801029c7:	5d                   	pop    %ebp
801029c8:	c3                   	ret    

801029c9 <outb>:

static inline void
outb(ushort port, uchar data)
{
801029c9:	55                   	push   %ebp
801029ca:	89 e5                	mov    %esp,%ebp
801029cc:	83 ec 08             	sub    $0x8,%esp
801029cf:	8b 45 08             	mov    0x8(%ebp),%eax
801029d2:	8b 55 0c             	mov    0xc(%ebp),%edx
801029d5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801029d9:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029dc:	8a 45 f8             	mov    -0x8(%ebp),%al
801029df:	8b 55 fc             	mov    -0x4(%ebp),%edx
801029e2:	ee                   	out    %al,(%dx)
}
801029e3:	c9                   	leave  
801029e4:	c3                   	ret    

801029e5 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801029e5:	55                   	push   %ebp
801029e6:	89 e5                	mov    %esp,%ebp
801029e8:	56                   	push   %esi
801029e9:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801029ea:	8b 55 08             	mov    0x8(%ebp),%edx
801029ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029f0:	8b 45 10             	mov    0x10(%ebp),%eax
801029f3:	89 cb                	mov    %ecx,%ebx
801029f5:	89 de                	mov    %ebx,%esi
801029f7:	89 c1                	mov    %eax,%ecx
801029f9:	fc                   	cld    
801029fa:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801029fc:	89 c8                	mov    %ecx,%eax
801029fe:	89 f3                	mov    %esi,%ebx
80102a00:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102a03:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102a06:	5b                   	pop    %ebx
80102a07:	5e                   	pop    %esi
80102a08:	5d                   	pop    %ebp
80102a09:	c3                   	ret    

80102a0a <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102a0a:	55                   	push   %ebp
80102a0b:	89 e5                	mov    %esp,%ebp
80102a0d:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102a10:	90                   	nop
80102a11:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102a18:	e8 5f ff ff ff       	call   8010297c <inb>
80102a1d:	0f b6 c0             	movzbl %al,%eax
80102a20:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102a23:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102a26:	25 c0 00 00 00       	and    $0xc0,%eax
80102a2b:	83 f8 40             	cmp    $0x40,%eax
80102a2e:	75 e1                	jne    80102a11 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102a30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102a34:	74 11                	je     80102a47 <idewait+0x3d>
80102a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102a39:	83 e0 21             	and    $0x21,%eax
80102a3c:	85 c0                	test   %eax,%eax
80102a3e:	74 07                	je     80102a47 <idewait+0x3d>
    return -1;
80102a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102a45:	eb 05                	jmp    80102a4c <idewait+0x42>
  return 0;
80102a47:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102a4c:	c9                   	leave  
80102a4d:	c3                   	ret    

80102a4e <ideinit>:

void
ideinit(void)
{
80102a4e:	55                   	push   %ebp
80102a4f:	89 e5                	mov    %esp,%ebp
80102a51:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102a54:	c7 44 24 04 3c 8e 10 	movl   $0x80108e3c,0x4(%esp)
80102a5b:	80 
80102a5c:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80102a63:	e8 96 2b 00 00       	call   801055fe <initlock>
  picenable(IRQ_IDE);
80102a68:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102a6f:	e8 9c 15 00 00       	call   80104010 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102a74:	a1 60 1f 11 80       	mov    0x80111f60,%eax
80102a79:	48                   	dec    %eax
80102a7a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a7e:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102a85:	e8 0b 04 00 00       	call   80102e95 <ioapicenable>
  idewait(0);
80102a8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102a91:	e8 74 ff ff ff       	call   80102a0a <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102a96:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102a9d:	00 
80102a9e:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102aa5:	e8 1f ff ff ff       	call   801029c9 <outb>
  for(i=0; i<1000; i++){
80102aaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102ab1:	eb 1f                	jmp    80102ad2 <ideinit+0x84>
    if(inb(0x1f7) != 0){
80102ab3:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102aba:	e8 bd fe ff ff       	call   8010297c <inb>
80102abf:	84 c0                	test   %al,%al
80102ac1:	74 0c                	je     80102acf <ideinit+0x81>
      havedisk1 = 1;
80102ac3:	c7 05 38 c6 10 80 01 	movl   $0x1,0x8010c638
80102aca:	00 00 00 
      break;
80102acd:	eb 0c                	jmp    80102adb <ideinit+0x8d>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102acf:	ff 45 f4             	incl   -0xc(%ebp)
80102ad2:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102ad9:	7e d8                	jle    80102ab3 <ideinit+0x65>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102adb:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102ae2:	00 
80102ae3:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102aea:	e8 da fe ff ff       	call   801029c9 <outb>
}
80102aef:	c9                   	leave  
80102af0:	c3                   	ret    

80102af1 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102af1:	55                   	push   %ebp
80102af2:	89 e5                	mov    %esp,%ebp
80102af4:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102af7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102afb:	75 0c                	jne    80102b09 <idestart+0x18>
    panic("idestart");
80102afd:	c7 04 24 40 8e 10 80 	movl   $0x80108e40,(%esp)
80102b04:	e8 2d da ff ff       	call   80100536 <panic>

  idewait(0);
80102b09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102b10:	e8 f5 fe ff ff       	call   80102a0a <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102b15:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102b1c:	00 
80102b1d:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102b24:	e8 a0 fe ff ff       	call   801029c9 <outb>
  outb(0x1f2, 1);  // number of sectors
80102b29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102b30:	00 
80102b31:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102b38:	e8 8c fe ff ff       	call   801029c9 <outb>
  outb(0x1f3, b->sector & 0xff);
80102b3d:	8b 45 08             	mov    0x8(%ebp),%eax
80102b40:	8b 40 08             	mov    0x8(%eax),%eax
80102b43:	0f b6 c0             	movzbl %al,%eax
80102b46:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b4a:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102b51:	e8 73 fe ff ff       	call   801029c9 <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102b56:	8b 45 08             	mov    0x8(%ebp),%eax
80102b59:	8b 40 08             	mov    0x8(%eax),%eax
80102b5c:	c1 e8 08             	shr    $0x8,%eax
80102b5f:	0f b6 c0             	movzbl %al,%eax
80102b62:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b66:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102b6d:	e8 57 fe ff ff       	call   801029c9 <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
80102b72:	8b 45 08             	mov    0x8(%ebp),%eax
80102b75:	8b 40 08             	mov    0x8(%eax),%eax
80102b78:	c1 e8 10             	shr    $0x10,%eax
80102b7b:	0f b6 c0             	movzbl %al,%eax
80102b7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b82:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102b89:	e8 3b fe ff ff       	call   801029c9 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102b8e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b91:	8b 40 04             	mov    0x4(%eax),%eax
80102b94:	83 e0 01             	and    $0x1,%eax
80102b97:	88 c2                	mov    %al,%dl
80102b99:	c1 e2 04             	shl    $0x4,%edx
80102b9c:	8b 45 08             	mov    0x8(%ebp),%eax
80102b9f:	8b 40 08             	mov    0x8(%eax),%eax
80102ba2:	c1 e8 18             	shr    $0x18,%eax
80102ba5:	83 e0 0f             	and    $0xf,%eax
80102ba8:	09 d0                	or     %edx,%eax
80102baa:	83 c8 e0             	or     $0xffffffe0,%eax
80102bad:	0f b6 c0             	movzbl %al,%eax
80102bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bb4:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102bbb:	e8 09 fe ff ff       	call   801029c9 <outb>
  if(b->flags & B_DIRTY){
80102bc0:	8b 45 08             	mov    0x8(%ebp),%eax
80102bc3:	8b 00                	mov    (%eax),%eax
80102bc5:	83 e0 04             	and    $0x4,%eax
80102bc8:	85 c0                	test   %eax,%eax
80102bca:	74 34                	je     80102c00 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
80102bcc:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80102bd3:	00 
80102bd4:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102bdb:	e8 e9 fd ff ff       	call   801029c9 <outb>
    outsl(0x1f0, b->data, 512/4);
80102be0:	8b 45 08             	mov    0x8(%ebp),%eax
80102be3:	83 c0 18             	add    $0x18,%eax
80102be6:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102bed:	00 
80102bee:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bf2:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102bf9:	e8 e7 fd ff ff       	call   801029e5 <outsl>
80102bfe:	eb 14                	jmp    80102c14 <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102c00:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80102c07:	00 
80102c08:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102c0f:	e8 b5 fd ff ff       	call   801029c9 <outb>
  }
}
80102c14:	c9                   	leave  
80102c15:	c3                   	ret    

80102c16 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102c16:	55                   	push   %ebp
80102c17:	89 e5                	mov    %esp,%ebp
80102c19:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102c1c:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80102c23:	e8 f7 29 00 00       	call   8010561f <acquire>
  if((b = idequeue) == 0){
80102c28:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102c30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c34:	75 11                	jne    80102c47 <ideintr+0x31>
    release(&idelock);
80102c36:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80102c3d:	e8 3f 2a 00 00       	call   80105681 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102c42:	e9 90 00 00 00       	jmp    80102cd7 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c4a:	8b 40 14             	mov    0x14(%eax),%eax
80102c4d:	a3 34 c6 10 80       	mov    %eax,0x8010c634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c55:	8b 00                	mov    (%eax),%eax
80102c57:	83 e0 04             	and    $0x4,%eax
80102c5a:	85 c0                	test   %eax,%eax
80102c5c:	75 2e                	jne    80102c8c <ideintr+0x76>
80102c5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102c65:	e8 a0 fd ff ff       	call   80102a0a <idewait>
80102c6a:	85 c0                	test   %eax,%eax
80102c6c:	78 1e                	js     80102c8c <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c71:	83 c0 18             	add    $0x18,%eax
80102c74:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102c7b:	00 
80102c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c80:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102c87:	e8 18 fd ff ff       	call   801029a4 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c8f:	8b 00                	mov    (%eax),%eax
80102c91:	89 c2                	mov    %eax,%edx
80102c93:	83 ca 02             	or     $0x2,%edx
80102c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c99:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c9e:	8b 00                	mov    (%eax),%eax
80102ca0:	89 c2                	mov    %eax,%edx
80102ca2:	83 e2 fb             	and    $0xfffffffb,%edx
80102ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ca8:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cad:	89 04 24             	mov    %eax,(%esp)
80102cb0:	e8 60 27 00 00       	call   80105415 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102cb5:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102cba:	85 c0                	test   %eax,%eax
80102cbc:	74 0d                	je     80102ccb <ideintr+0xb5>
    idestart(idequeue);
80102cbe:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102cc3:	89 04 24             	mov    %eax,(%esp)
80102cc6:	e8 26 fe ff ff       	call   80102af1 <idestart>

  release(&idelock);
80102ccb:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80102cd2:	e8 aa 29 00 00       	call   80105681 <release>
}
80102cd7:	c9                   	leave  
80102cd8:	c3                   	ret    

80102cd9 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102cd9:	55                   	push   %ebp
80102cda:	89 e5                	mov    %esp,%ebp
80102cdc:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102cdf:	8b 45 08             	mov    0x8(%ebp),%eax
80102ce2:	8b 00                	mov    (%eax),%eax
80102ce4:	83 e0 01             	and    $0x1,%eax
80102ce7:	85 c0                	test   %eax,%eax
80102ce9:	75 0c                	jne    80102cf7 <iderw+0x1e>
    panic("iderw: buf not busy");
80102ceb:	c7 04 24 49 8e 10 80 	movl   $0x80108e49,(%esp)
80102cf2:	e8 3f d8 ff ff       	call   80100536 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102cf7:	8b 45 08             	mov    0x8(%ebp),%eax
80102cfa:	8b 00                	mov    (%eax),%eax
80102cfc:	83 e0 06             	and    $0x6,%eax
80102cff:	83 f8 02             	cmp    $0x2,%eax
80102d02:	75 0c                	jne    80102d10 <iderw+0x37>
    panic("iderw: nothing to do");
80102d04:	c7 04 24 5d 8e 10 80 	movl   $0x80108e5d,(%esp)
80102d0b:	e8 26 d8 ff ff       	call   80100536 <panic>
  if(b->dev != 0 && !havedisk1)
80102d10:	8b 45 08             	mov    0x8(%ebp),%eax
80102d13:	8b 40 04             	mov    0x4(%eax),%eax
80102d16:	85 c0                	test   %eax,%eax
80102d18:	74 15                	je     80102d2f <iderw+0x56>
80102d1a:	a1 38 c6 10 80       	mov    0x8010c638,%eax
80102d1f:	85 c0                	test   %eax,%eax
80102d21:	75 0c                	jne    80102d2f <iderw+0x56>
    panic("iderw: ide disk 1 not present");
80102d23:	c7 04 24 72 8e 10 80 	movl   $0x80108e72,(%esp)
80102d2a:	e8 07 d8 ff ff       	call   80100536 <panic>

  acquire(&idelock);  //DOC: acquire-lock
80102d2f:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80102d36:	e8 e4 28 00 00       	call   8010561f <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102d3b:	8b 45 08             	mov    0x8(%ebp),%eax
80102d3e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC: insert-queue
80102d45:	c7 45 f4 34 c6 10 80 	movl   $0x8010c634,-0xc(%ebp)
80102d4c:	eb 0b                	jmp    80102d59 <iderw+0x80>
80102d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d51:	8b 00                	mov    (%eax),%eax
80102d53:	83 c0 14             	add    $0x14,%eax
80102d56:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d5c:	8b 00                	mov    (%eax),%eax
80102d5e:	85 c0                	test   %eax,%eax
80102d60:	75 ec                	jne    80102d4e <iderw+0x75>
    ;
  *pp = b;
80102d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d65:	8b 55 08             	mov    0x8(%ebp),%edx
80102d68:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102d6a:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102d6f:	3b 45 08             	cmp    0x8(%ebp),%eax
80102d72:	75 22                	jne    80102d96 <iderw+0xbd>
    idestart(b);
80102d74:	8b 45 08             	mov    0x8(%ebp),%eax
80102d77:	89 04 24             	mov    %eax,(%esp)
80102d7a:	e8 72 fd ff ff       	call   80102af1 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102d7f:	eb 15                	jmp    80102d96 <iderw+0xbd>
    sleep(b, &idelock);
80102d81:	c7 44 24 04 00 c6 10 	movl   $0x8010c600,0x4(%esp)
80102d88:	80 
80102d89:	8b 45 08             	mov    0x8(%ebp),%eax
80102d8c:	89 04 24             	mov    %eax,(%esp)
80102d8f:	e8 a5 25 00 00       	call   80105339 <sleep>
80102d94:	eb 01                	jmp    80102d97 <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102d96:	90                   	nop
80102d97:	8b 45 08             	mov    0x8(%ebp),%eax
80102d9a:	8b 00                	mov    (%eax),%eax
80102d9c:	83 e0 06             	and    $0x6,%eax
80102d9f:	83 f8 02             	cmp    $0x2,%eax
80102da2:	75 dd                	jne    80102d81 <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
80102da4:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80102dab:	e8 d1 28 00 00       	call   80105681 <release>
}
80102db0:	c9                   	leave  
80102db1:	c3                   	ret    
80102db2:	66 90                	xchg   %ax,%ax

80102db4 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102db4:	55                   	push   %ebp
80102db5:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102db7:	a1 94 18 11 80       	mov    0x80111894,%eax
80102dbc:	8b 55 08             	mov    0x8(%ebp),%edx
80102dbf:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102dc1:	a1 94 18 11 80       	mov    0x80111894,%eax
80102dc6:	8b 40 10             	mov    0x10(%eax),%eax
}
80102dc9:	5d                   	pop    %ebp
80102dca:	c3                   	ret    

80102dcb <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102dcb:	55                   	push   %ebp
80102dcc:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102dce:	a1 94 18 11 80       	mov    0x80111894,%eax
80102dd3:	8b 55 08             	mov    0x8(%ebp),%edx
80102dd6:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102dd8:	a1 94 18 11 80       	mov    0x80111894,%eax
80102ddd:	8b 55 0c             	mov    0xc(%ebp),%edx
80102de0:	89 50 10             	mov    %edx,0x10(%eax)
}
80102de3:	5d                   	pop    %ebp
80102de4:	c3                   	ret    

80102de5 <ioapicinit>:

void
ioapicinit(void)
{
80102de5:	55                   	push   %ebp
80102de6:	89 e5                	mov    %esp,%ebp
80102de8:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
80102deb:	a1 64 19 11 80       	mov    0x80111964,%eax
80102df0:	85 c0                	test   %eax,%eax
80102df2:	0f 84 9a 00 00 00    	je     80102e92 <ioapicinit+0xad>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102df8:	c7 05 94 18 11 80 00 	movl   $0xfec00000,0x80111894
80102dff:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102e02:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102e09:	e8 a6 ff ff ff       	call   80102db4 <ioapicread>
80102e0e:	c1 e8 10             	shr    $0x10,%eax
80102e11:	25 ff 00 00 00       	and    $0xff,%eax
80102e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102e19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102e20:	e8 8f ff ff ff       	call   80102db4 <ioapicread>
80102e25:	c1 e8 18             	shr    $0x18,%eax
80102e28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102e2b:	a0 60 19 11 80       	mov    0x80111960,%al
80102e30:	0f b6 c0             	movzbl %al,%eax
80102e33:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102e36:	74 0c                	je     80102e44 <ioapicinit+0x5f>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102e38:	c7 04 24 90 8e 10 80 	movl   $0x80108e90,(%esp)
80102e3f:	e8 5d d5 ff ff       	call   801003a1 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102e44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102e4b:	eb 3b                	jmp    80102e88 <ioapicinit+0xa3>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e50:	83 c0 20             	add    $0x20,%eax
80102e53:	0d 00 00 01 00       	or     $0x10000,%eax
80102e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102e5b:	83 c2 08             	add    $0x8,%edx
80102e5e:	d1 e2                	shl    %edx
80102e60:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e64:	89 14 24             	mov    %edx,(%esp)
80102e67:	e8 5f ff ff ff       	call   80102dcb <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e6f:	83 c0 08             	add    $0x8,%eax
80102e72:	d1 e0                	shl    %eax
80102e74:	40                   	inc    %eax
80102e75:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e7c:	00 
80102e7d:	89 04 24             	mov    %eax,(%esp)
80102e80:	e8 46 ff ff ff       	call   80102dcb <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102e85:	ff 45 f4             	incl   -0xc(%ebp)
80102e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e8b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102e8e:	7e bd                	jle    80102e4d <ioapicinit+0x68>
80102e90:	eb 01                	jmp    80102e93 <ioapicinit+0xae>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102e92:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102e93:	c9                   	leave  
80102e94:	c3                   	ret    

80102e95 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102e95:	55                   	push   %ebp
80102e96:	89 e5                	mov    %esp,%ebp
80102e98:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102e9b:	a1 64 19 11 80       	mov    0x80111964,%eax
80102ea0:	85 c0                	test   %eax,%eax
80102ea2:	74 37                	je     80102edb <ioapicenable+0x46>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102ea4:	8b 45 08             	mov    0x8(%ebp),%eax
80102ea7:	83 c0 20             	add    $0x20,%eax
80102eaa:	8b 55 08             	mov    0x8(%ebp),%edx
80102ead:	83 c2 08             	add    $0x8,%edx
80102eb0:	d1 e2                	shl    %edx
80102eb2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102eb6:	89 14 24             	mov    %edx,(%esp)
80102eb9:	e8 0d ff ff ff       	call   80102dcb <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ec1:	c1 e0 18             	shl    $0x18,%eax
80102ec4:	8b 55 08             	mov    0x8(%ebp),%edx
80102ec7:	83 c2 08             	add    $0x8,%edx
80102eca:	d1 e2                	shl    %edx
80102ecc:	42                   	inc    %edx
80102ecd:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ed1:	89 14 24             	mov    %edx,(%esp)
80102ed4:	e8 f2 fe ff ff       	call   80102dcb <ioapicwrite>
80102ed9:	eb 01                	jmp    80102edc <ioapicenable+0x47>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102edb:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102edc:	c9                   	leave  
80102edd:	c3                   	ret    
80102ede:	66 90                	xchg   %ax,%ax

80102ee0 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80102ee6:	05 00 00 00 80       	add    $0x80000000,%eax
80102eeb:	5d                   	pop    %ebp
80102eec:	c3                   	ret    

80102eed <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102eed:	55                   	push   %ebp
80102eee:	89 e5                	mov    %esp,%ebp
80102ef0:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102ef3:	c7 44 24 04 c2 8e 10 	movl   $0x80108ec2,0x4(%esp)
80102efa:	80 
80102efb:	c7 04 24 a0 18 11 80 	movl   $0x801118a0,(%esp)
80102f02:	e8 f7 26 00 00       	call   801055fe <initlock>
  kmem.use_lock = 0;
80102f07:	c7 05 d4 18 11 80 00 	movl   $0x0,0x801118d4
80102f0e:	00 00 00 
  freerange(vstart, vend);
80102f11:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f14:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f18:	8b 45 08             	mov    0x8(%ebp),%eax
80102f1b:	89 04 24             	mov    %eax,(%esp)
80102f1e:	e8 26 00 00 00       	call   80102f49 <freerange>
}
80102f23:	c9                   	leave  
80102f24:	c3                   	ret    

80102f25 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102f25:	55                   	push   %ebp
80102f26:	89 e5                	mov    %esp,%ebp
80102f28:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f32:	8b 45 08             	mov    0x8(%ebp),%eax
80102f35:	89 04 24             	mov    %eax,(%esp)
80102f38:	e8 0c 00 00 00       	call   80102f49 <freerange>
  kmem.use_lock = 1;
80102f3d:	c7 05 d4 18 11 80 01 	movl   $0x1,0x801118d4
80102f44:	00 00 00 
}
80102f47:	c9                   	leave  
80102f48:	c3                   	ret    

80102f49 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102f49:	55                   	push   %ebp
80102f4a:	89 e5                	mov    %esp,%ebp
80102f4c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102f4f:	8b 45 08             	mov    0x8(%ebp),%eax
80102f52:	05 ff 0f 00 00       	add    $0xfff,%eax
80102f57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102f5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f5f:	eb 12                	jmp    80102f73 <freerange+0x2a>
    kfree(p);
80102f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f64:	89 04 24             	mov    %eax,(%esp)
80102f67:	e8 16 00 00 00       	call   80102f82 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f6c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f76:	05 00 10 00 00       	add    $0x1000,%eax
80102f7b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102f7e:	76 e1                	jbe    80102f61 <freerange+0x18>
    kfree(p);
}
80102f80:	c9                   	leave  
80102f81:	c3                   	ret    

80102f82 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102f82:	55                   	push   %ebp
80102f83:	89 e5                	mov    %esp,%ebp
80102f85:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102f88:	8b 45 08             	mov    0x8(%ebp),%eax
80102f8b:	25 ff 0f 00 00       	and    $0xfff,%eax
80102f90:	85 c0                	test   %eax,%eax
80102f92:	75 1b                	jne    80102faf <kfree+0x2d>
80102f94:	81 7d 08 1c 50 11 80 	cmpl   $0x8011501c,0x8(%ebp)
80102f9b:	72 12                	jb     80102faf <kfree+0x2d>
80102f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80102fa0:	89 04 24             	mov    %eax,(%esp)
80102fa3:	e8 38 ff ff ff       	call   80102ee0 <v2p>
80102fa8:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102fad:	76 0c                	jbe    80102fbb <kfree+0x39>
    panic("kfree");
80102faf:	c7 04 24 c7 8e 10 80 	movl   $0x80108ec7,(%esp)
80102fb6:	e8 7b d5 ff ff       	call   80100536 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102fbb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102fc2:	00 
80102fc3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102fca:	00 
80102fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80102fce:	89 04 24             	mov    %eax,(%esp)
80102fd1:	e8 9c 28 00 00       	call   80105872 <memset>

  if(kmem.use_lock)
80102fd6:	a1 d4 18 11 80       	mov    0x801118d4,%eax
80102fdb:	85 c0                	test   %eax,%eax
80102fdd:	74 0c                	je     80102feb <kfree+0x69>
    acquire(&kmem.lock);
80102fdf:	c7 04 24 a0 18 11 80 	movl   $0x801118a0,(%esp)
80102fe6:	e8 34 26 00 00       	call   8010561f <acquire>
  r = (struct run*)v;
80102feb:	8b 45 08             	mov    0x8(%ebp),%eax
80102fee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ff1:	8b 15 d8 18 11 80    	mov    0x801118d8,%edx
80102ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ffa:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fff:	a3 d8 18 11 80       	mov    %eax,0x801118d8
  if(kmem.use_lock)
80103004:	a1 d4 18 11 80       	mov    0x801118d4,%eax
80103009:	85 c0                	test   %eax,%eax
8010300b:	74 0c                	je     80103019 <kfree+0x97>
    release(&kmem.lock);
8010300d:	c7 04 24 a0 18 11 80 	movl   $0x801118a0,(%esp)
80103014:	e8 68 26 00 00       	call   80105681 <release>
}
80103019:	c9                   	leave  
8010301a:	c3                   	ret    

8010301b <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
8010301b:	55                   	push   %ebp
8010301c:	89 e5                	mov    %esp,%ebp
8010301e:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80103021:	a1 d4 18 11 80       	mov    0x801118d4,%eax
80103026:	85 c0                	test   %eax,%eax
80103028:	74 0c                	je     80103036 <kalloc+0x1b>
    acquire(&kmem.lock);
8010302a:	c7 04 24 a0 18 11 80 	movl   $0x801118a0,(%esp)
80103031:	e8 e9 25 00 00       	call   8010561f <acquire>
  r = kmem.freelist;
80103036:	a1 d8 18 11 80       	mov    0x801118d8,%eax
8010303b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
8010303e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103042:	74 0a                	je     8010304e <kalloc+0x33>
    kmem.freelist = r->next;
80103044:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103047:	8b 00                	mov    (%eax),%eax
80103049:	a3 d8 18 11 80       	mov    %eax,0x801118d8
  if(kmem.use_lock)
8010304e:	a1 d4 18 11 80       	mov    0x801118d4,%eax
80103053:	85 c0                	test   %eax,%eax
80103055:	74 0c                	je     80103063 <kalloc+0x48>
    release(&kmem.lock);
80103057:	c7 04 24 a0 18 11 80 	movl   $0x801118a0,(%esp)
8010305e:	e8 1e 26 00 00       	call   80105681 <release>
  return (char*)r;
80103063:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103066:	c9                   	leave  
80103067:	c3                   	ret    

80103068 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103068:	55                   	push   %ebp
80103069:	89 e5                	mov    %esp,%ebp
8010306b:	53                   	push   %ebx
8010306c:	83 ec 14             	sub    $0x14,%esp
8010306f:	8b 45 08             	mov    0x8(%ebp),%eax
80103072:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103076:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103079:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
8010307d:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
80103081:	ec                   	in     (%dx),%al
80103082:	88 c3                	mov    %al,%bl
80103084:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80103087:	8a 45 fb             	mov    -0x5(%ebp),%al
}
8010308a:	83 c4 14             	add    $0x14,%esp
8010308d:	5b                   	pop    %ebx
8010308e:	5d                   	pop    %ebp
8010308f:	c3                   	ret    

80103090 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80103090:	55                   	push   %ebp
80103091:	89 e5                	mov    %esp,%ebp
80103093:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80103096:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
8010309d:	e8 c6 ff ff ff       	call   80103068 <inb>
801030a2:	0f b6 c0             	movzbl %al,%eax
801030a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
801030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030ab:	83 e0 01             	and    $0x1,%eax
801030ae:	85 c0                	test   %eax,%eax
801030b0:	75 0a                	jne    801030bc <kbdgetc+0x2c>
    return -1;
801030b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801030b7:	e9 21 01 00 00       	jmp    801031dd <kbdgetc+0x14d>
  data = inb(KBDATAP);
801030bc:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
801030c3:	e8 a0 ff ff ff       	call   80103068 <inb>
801030c8:	0f b6 c0             	movzbl %al,%eax
801030cb:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
801030ce:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
801030d5:	75 17                	jne    801030ee <kbdgetc+0x5e>
    shift |= E0ESC;
801030d7:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
801030dc:	83 c8 40             	or     $0x40,%eax
801030df:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
    return 0;
801030e4:	b8 00 00 00 00       	mov    $0x0,%eax
801030e9:	e9 ef 00 00 00       	jmp    801031dd <kbdgetc+0x14d>
  } else if(data & 0x80){
801030ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030f1:	25 80 00 00 00       	and    $0x80,%eax
801030f6:	85 c0                	test   %eax,%eax
801030f8:	74 44                	je     8010313e <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801030fa:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
801030ff:	83 e0 40             	and    $0x40,%eax
80103102:	85 c0                	test   %eax,%eax
80103104:	75 08                	jne    8010310e <kbdgetc+0x7e>
80103106:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103109:	83 e0 7f             	and    $0x7f,%eax
8010310c:	eb 03                	jmp    80103111 <kbdgetc+0x81>
8010310e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103111:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80103114:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103117:	05 20 a0 10 80       	add    $0x8010a020,%eax
8010311c:	8a 00                	mov    (%eax),%al
8010311e:	83 c8 40             	or     $0x40,%eax
80103121:	0f b6 c0             	movzbl %al,%eax
80103124:	f7 d0                	not    %eax
80103126:	89 c2                	mov    %eax,%edx
80103128:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
8010312d:	21 d0                	and    %edx,%eax
8010312f:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
    return 0;
80103134:	b8 00 00 00 00       	mov    $0x0,%eax
80103139:	e9 9f 00 00 00       	jmp    801031dd <kbdgetc+0x14d>
  } else if(shift & E0ESC){
8010313e:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80103143:	83 e0 40             	and    $0x40,%eax
80103146:	85 c0                	test   %eax,%eax
80103148:	74 14                	je     8010315e <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010314a:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80103151:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80103156:	83 e0 bf             	and    $0xffffffbf,%eax
80103159:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  }

  shift |= shiftcode[data];
8010315e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103161:	05 20 a0 10 80       	add    $0x8010a020,%eax
80103166:	8a 00                	mov    (%eax),%al
80103168:	0f b6 d0             	movzbl %al,%edx
8010316b:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80103170:	09 d0                	or     %edx,%eax
80103172:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  shift ^= togglecode[data];
80103177:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010317a:	05 20 a1 10 80       	add    $0x8010a120,%eax
8010317f:	8a 00                	mov    (%eax),%al
80103181:	0f b6 d0             	movzbl %al,%edx
80103184:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80103189:	31 d0                	xor    %edx,%eax
8010318b:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  c = charcode[shift & (CTL | SHIFT)][data];
80103190:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80103195:	83 e0 03             	and    $0x3,%eax
80103198:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
8010319f:	8b 45 fc             	mov    -0x4(%ebp),%eax
801031a2:	01 d0                	add    %edx,%eax
801031a4:	8a 00                	mov    (%eax),%al
801031a6:	0f b6 c0             	movzbl %al,%eax
801031a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
801031ac:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
801031b1:	83 e0 08             	and    $0x8,%eax
801031b4:	85 c0                	test   %eax,%eax
801031b6:	74 22                	je     801031da <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
801031b8:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
801031bc:	76 0c                	jbe    801031ca <kbdgetc+0x13a>
801031be:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
801031c2:	77 06                	ja     801031ca <kbdgetc+0x13a>
      c += 'A' - 'a';
801031c4:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
801031c8:	eb 10                	jmp    801031da <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
801031ca:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
801031ce:	76 0a                	jbe    801031da <kbdgetc+0x14a>
801031d0:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
801031d4:	77 04                	ja     801031da <kbdgetc+0x14a>
      c += 'a' - 'A';
801031d6:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
801031da:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801031dd:	c9                   	leave  
801031de:	c3                   	ret    

801031df <kbdintr>:

void
kbdintr(void)
{
801031df:	55                   	push   %ebp
801031e0:	89 e5                	mov    %esp,%ebp
801031e2:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801031e5:	c7 04 24 90 30 10 80 	movl   $0x80103090,(%esp)
801031ec:	e8 ff d5 ff ff       	call   801007f0 <consoleintr>
}
801031f1:	c9                   	leave  
801031f2:	c3                   	ret    
801031f3:	90                   	nop

801031f4 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801031f4:	55                   	push   %ebp
801031f5:	89 e5                	mov    %esp,%ebp
801031f7:	83 ec 08             	sub    $0x8,%esp
801031fa:	8b 45 08             	mov    0x8(%ebp),%eax
801031fd:	8b 55 0c             	mov    0xc(%ebp),%edx
80103200:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103204:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103207:	8a 45 f8             	mov    -0x8(%ebp),%al
8010320a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010320d:	ee                   	out    %al,(%dx)
}
8010320e:	c9                   	leave  
8010320f:	c3                   	ret    

80103210 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	53                   	push   %ebx
80103214:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103217:	9c                   	pushf  
80103218:	5b                   	pop    %ebx
80103219:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
8010321c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010321f:	83 c4 10             	add    $0x10,%esp
80103222:	5b                   	pop    %ebx
80103223:	5d                   	pop    %ebp
80103224:	c3                   	ret    

80103225 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80103225:	55                   	push   %ebp
80103226:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80103228:	a1 dc 18 11 80       	mov    0x801118dc,%eax
8010322d:	8b 55 08             	mov    0x8(%ebp),%edx
80103230:	c1 e2 02             	shl    $0x2,%edx
80103233:	01 c2                	add    %eax,%edx
80103235:	8b 45 0c             	mov    0xc(%ebp),%eax
80103238:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
8010323a:	a1 dc 18 11 80       	mov    0x801118dc,%eax
8010323f:	83 c0 20             	add    $0x20,%eax
80103242:	8b 00                	mov    (%eax),%eax
}
80103244:	5d                   	pop    %ebp
80103245:	c3                   	ret    

80103246 <lapicinit>:
//PAGEBREAK!

void
lapicinit(int c)
{
80103246:	55                   	push   %ebp
80103247:	89 e5                	mov    %esp,%ebp
80103249:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
8010324c:	a1 dc 18 11 80       	mov    0x801118dc,%eax
80103251:	85 c0                	test   %eax,%eax
80103253:	0f 84 47 01 00 00    	je     801033a0 <lapicinit+0x15a>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80103259:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80103260:	00 
80103261:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80103268:	e8 b8 ff ff ff       	call   80103225 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
8010326d:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80103274:	00 
80103275:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
8010327c:	e8 a4 ff ff ff       	call   80103225 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80103281:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80103288:	00 
80103289:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103290:	e8 90 ff ff ff       	call   80103225 <lapicw>
  lapicw(TICR, 10000000); 
80103295:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
8010329c:	00 
8010329d:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
801032a4:	e8 7c ff ff ff       	call   80103225 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
801032a9:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801032b0:	00 
801032b1:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
801032b8:	e8 68 ff ff ff       	call   80103225 <lapicw>
  lapicw(LINT1, MASKED);
801032bd:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801032c4:	00 
801032c5:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
801032cc:	e8 54 ff ff ff       	call   80103225 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801032d1:	a1 dc 18 11 80       	mov    0x801118dc,%eax
801032d6:	83 c0 30             	add    $0x30,%eax
801032d9:	8b 00                	mov    (%eax),%eax
801032db:	c1 e8 10             	shr    $0x10,%eax
801032de:	25 ff 00 00 00       	and    $0xff,%eax
801032e3:	83 f8 03             	cmp    $0x3,%eax
801032e6:	76 14                	jbe    801032fc <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
801032e8:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801032ef:	00 
801032f0:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
801032f7:	e8 29 ff ff ff       	call   80103225 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801032fc:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80103303:	00 
80103304:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
8010330b:	e8 15 ff ff ff       	call   80103225 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103310:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103317:	00 
80103318:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
8010331f:	e8 01 ff ff ff       	call   80103225 <lapicw>
  lapicw(ESR, 0);
80103324:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010332b:	00 
8010332c:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103333:	e8 ed fe ff ff       	call   80103225 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103338:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010333f:	00 
80103340:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103347:	e8 d9 fe ff ff       	call   80103225 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
8010334c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103353:	00 
80103354:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010335b:	e8 c5 fe ff ff       	call   80103225 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103360:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80103367:	00 
80103368:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010336f:	e8 b1 fe ff ff       	call   80103225 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80103374:	90                   	nop
80103375:	a1 dc 18 11 80       	mov    0x801118dc,%eax
8010337a:	05 00 03 00 00       	add    $0x300,%eax
8010337f:	8b 00                	mov    (%eax),%eax
80103381:	25 00 10 00 00       	and    $0x1000,%eax
80103386:	85 c0                	test   %eax,%eax
80103388:	75 eb                	jne    80103375 <lapicinit+0x12f>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
8010338a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103391:	00 
80103392:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103399:	e8 87 fe ff ff       	call   80103225 <lapicw>
8010339e:	eb 01                	jmp    801033a1 <lapicinit+0x15b>

void
lapicinit(int c)
{
  if(!lapic) 
    return;
801033a0:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801033a1:	c9                   	leave  
801033a2:	c3                   	ret    

801033a3 <cpunum>:

int
cpunum(void)
{
801033a3:	55                   	push   %ebp
801033a4:	89 e5                	mov    %esp,%ebp
801033a6:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801033a9:	e8 62 fe ff ff       	call   80103210 <readeflags>
801033ae:	25 00 02 00 00       	and    $0x200,%eax
801033b3:	85 c0                	test   %eax,%eax
801033b5:	74 27                	je     801033de <cpunum+0x3b>
    static int n;
    if(n++ == 0)
801033b7:	a1 40 c6 10 80       	mov    0x8010c640,%eax
801033bc:	85 c0                	test   %eax,%eax
801033be:	0f 94 c2             	sete   %dl
801033c1:	40                   	inc    %eax
801033c2:	a3 40 c6 10 80       	mov    %eax,0x8010c640
801033c7:	84 d2                	test   %dl,%dl
801033c9:	74 13                	je     801033de <cpunum+0x3b>
      cprintf("cpu called from %x with interrupts enabled\n",
801033cb:	8b 45 04             	mov    0x4(%ebp),%eax
801033ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801033d2:	c7 04 24 d0 8e 10 80 	movl   $0x80108ed0,(%esp)
801033d9:	e8 c3 cf ff ff       	call   801003a1 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
801033de:	a1 dc 18 11 80       	mov    0x801118dc,%eax
801033e3:	85 c0                	test   %eax,%eax
801033e5:	74 0f                	je     801033f6 <cpunum+0x53>
    return lapic[ID]>>24;
801033e7:	a1 dc 18 11 80       	mov    0x801118dc,%eax
801033ec:	83 c0 20             	add    $0x20,%eax
801033ef:	8b 00                	mov    (%eax),%eax
801033f1:	c1 e8 18             	shr    $0x18,%eax
801033f4:	eb 05                	jmp    801033fb <cpunum+0x58>
  return 0;
801033f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801033fb:	c9                   	leave  
801033fc:	c3                   	ret    

801033fd <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801033fd:	55                   	push   %ebp
801033fe:	89 e5                	mov    %esp,%ebp
80103400:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80103403:	a1 dc 18 11 80       	mov    0x801118dc,%eax
80103408:	85 c0                	test   %eax,%eax
8010340a:	74 14                	je     80103420 <lapiceoi+0x23>
    lapicw(EOI, 0);
8010340c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103413:	00 
80103414:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
8010341b:	e8 05 fe ff ff       	call   80103225 <lapicw>
}
80103420:	c9                   	leave  
80103421:	c3                   	ret    

80103422 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103422:	55                   	push   %ebp
80103423:	89 e5                	mov    %esp,%ebp
}
80103425:	5d                   	pop    %ebp
80103426:	c3                   	ret    

80103427 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103427:	55                   	push   %ebp
80103428:	89 e5                	mov    %esp,%ebp
8010342a:	83 ec 1c             	sub    $0x1c,%esp
8010342d:	8b 45 08             	mov    0x8(%ebp),%eax
80103430:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80103433:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010343a:	00 
8010343b:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103442:	e8 ad fd ff ff       	call   801031f4 <outb>
  outb(IO_RTC+1, 0x0A);
80103447:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
8010344e:	00 
8010344f:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103456:	e8 99 fd ff ff       	call   801031f4 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010345b:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103462:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103465:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
8010346a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010346d:	8d 50 02             	lea    0x2(%eax),%edx
80103470:	8b 45 0c             	mov    0xc(%ebp),%eax
80103473:	c1 e8 04             	shr    $0x4,%eax
80103476:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103479:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010347d:	c1 e0 18             	shl    $0x18,%eax
80103480:	89 44 24 04          	mov    %eax,0x4(%esp)
80103484:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010348b:	e8 95 fd ff ff       	call   80103225 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103490:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80103497:	00 
80103498:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010349f:	e8 81 fd ff ff       	call   80103225 <lapicw>
  microdelay(200);
801034a4:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801034ab:	e8 72 ff ff ff       	call   80103422 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
801034b0:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
801034b7:	00 
801034b8:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801034bf:	e8 61 fd ff ff       	call   80103225 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801034c4:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
801034cb:	e8 52 ff ff ff       	call   80103422 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801034d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801034d7:	eb 3f                	jmp    80103518 <lapicstartap+0xf1>
    lapicw(ICRHI, apicid<<24);
801034d9:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801034dd:	c1 e0 18             	shl    $0x18,%eax
801034e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801034e4:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801034eb:	e8 35 fd ff ff       	call   80103225 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801034f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801034f3:	c1 e8 0c             	shr    $0xc,%eax
801034f6:	80 cc 06             	or     $0x6,%ah
801034f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801034fd:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103504:	e8 1c fd ff ff       	call   80103225 <lapicw>
    microdelay(200);
80103509:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103510:	e8 0d ff ff ff       	call   80103422 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103515:	ff 45 fc             	incl   -0x4(%ebp)
80103518:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010351c:	7e bb                	jle    801034d9 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010351e:	c9                   	leave  
8010351f:	c3                   	ret    

80103520 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103526:	c7 44 24 04 fc 8e 10 	movl   $0x80108efc,0x4(%esp)
8010352d:	80 
8010352e:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103535:	e8 c4 20 00 00       	call   801055fe <initlock>
  readsb(ROOTDEV, &sb);
8010353a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010353d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103541:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103548:	e8 e3 e2 ff ff       	call   80101830 <readsb>
  log.start = sb.size - sb.nlog;
8010354d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103550:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103553:	89 d1                	mov    %edx,%ecx
80103555:	29 c1                	sub    %eax,%ecx
80103557:	89 c8                	mov    %ecx,%eax
80103559:	a3 14 19 11 80       	mov    %eax,0x80111914
  log.size = sb.nlog;
8010355e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103561:	a3 18 19 11 80       	mov    %eax,0x80111918
  log.dev = ROOTDEV;
80103566:	c7 05 20 19 11 80 01 	movl   $0x1,0x80111920
8010356d:	00 00 00 
  recover_from_log();
80103570:	e8 95 01 00 00       	call   8010370a <recover_from_log>
}
80103575:	c9                   	leave  
80103576:	c3                   	ret    

80103577 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103577:	55                   	push   %ebp
80103578:	89 e5                	mov    %esp,%ebp
8010357a:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010357d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103584:	e9 89 00 00 00       	jmp    80103612 <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103589:	8b 15 14 19 11 80    	mov    0x80111914,%edx
8010358f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103592:	01 d0                	add    %edx,%eax
80103594:	40                   	inc    %eax
80103595:	89 c2                	mov    %eax,%edx
80103597:	a1 20 19 11 80       	mov    0x80111920,%eax
8010359c:	89 54 24 04          	mov    %edx,0x4(%esp)
801035a0:	89 04 24             	mov    %eax,(%esp)
801035a3:	e8 fe cb ff ff       	call   801001a6 <bread>
801035a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801035ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035ae:	83 c0 10             	add    $0x10,%eax
801035b1:	8b 04 85 e8 18 11 80 	mov    -0x7feee718(,%eax,4),%eax
801035b8:	89 c2                	mov    %eax,%edx
801035ba:	a1 20 19 11 80       	mov    0x80111920,%eax
801035bf:	89 54 24 04          	mov    %edx,0x4(%esp)
801035c3:	89 04 24             	mov    %eax,(%esp)
801035c6:	e8 db cb ff ff       	call   801001a6 <bread>
801035cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801035ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035d1:	8d 50 18             	lea    0x18(%eax),%edx
801035d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035d7:	83 c0 18             	add    $0x18,%eax
801035da:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801035e1:	00 
801035e2:	89 54 24 04          	mov    %edx,0x4(%esp)
801035e6:	89 04 24             	mov    %eax,(%esp)
801035e9:	e8 50 23 00 00       	call   8010593e <memmove>
    bwrite(dbuf);  // write dst to disk
801035ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035f1:	89 04 24             	mov    %eax,(%esp)
801035f4:	e8 e4 cb ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
801035f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035fc:	89 04 24             	mov    %eax,(%esp)
801035ff:	e8 13 cc ff ff       	call   80100217 <brelse>
    brelse(dbuf);
80103604:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103607:	89 04 24             	mov    %eax,(%esp)
8010360a:	e8 08 cc ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010360f:	ff 45 f4             	incl   -0xc(%ebp)
80103612:	a1 24 19 11 80       	mov    0x80111924,%eax
80103617:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010361a:	0f 8f 69 ff ff ff    	jg     80103589 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103620:	c9                   	leave  
80103621:	c3                   	ret    

80103622 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103622:	55                   	push   %ebp
80103623:	89 e5                	mov    %esp,%ebp
80103625:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103628:	a1 14 19 11 80       	mov    0x80111914,%eax
8010362d:	89 c2                	mov    %eax,%edx
8010362f:	a1 20 19 11 80       	mov    0x80111920,%eax
80103634:	89 54 24 04          	mov    %edx,0x4(%esp)
80103638:	89 04 24             	mov    %eax,(%esp)
8010363b:	e8 66 cb ff ff       	call   801001a6 <bread>
80103640:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103643:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103646:	83 c0 18             	add    $0x18,%eax
80103649:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010364c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010364f:	8b 00                	mov    (%eax),%eax
80103651:	a3 24 19 11 80       	mov    %eax,0x80111924
  for (i = 0; i < log.lh.n; i++) {
80103656:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010365d:	eb 1a                	jmp    80103679 <read_head+0x57>
    log.lh.sector[i] = lh->sector[i];
8010365f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103662:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103665:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103669:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010366c:	83 c2 10             	add    $0x10,%edx
8010366f:	89 04 95 e8 18 11 80 	mov    %eax,-0x7feee718(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103676:	ff 45 f4             	incl   -0xc(%ebp)
80103679:	a1 24 19 11 80       	mov    0x80111924,%eax
8010367e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103681:	7f dc                	jg     8010365f <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103683:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103686:	89 04 24             	mov    %eax,(%esp)
80103689:	e8 89 cb ff ff       	call   80100217 <brelse>
}
8010368e:	c9                   	leave  
8010368f:	c3                   	ret    

80103690 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103696:	a1 14 19 11 80       	mov    0x80111914,%eax
8010369b:	89 c2                	mov    %eax,%edx
8010369d:	a1 20 19 11 80       	mov    0x80111920,%eax
801036a2:	89 54 24 04          	mov    %edx,0x4(%esp)
801036a6:	89 04 24             	mov    %eax,(%esp)
801036a9:	e8 f8 ca ff ff       	call   801001a6 <bread>
801036ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801036b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036b4:	83 c0 18             	add    $0x18,%eax
801036b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801036ba:	8b 15 24 19 11 80    	mov    0x80111924,%edx
801036c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036c3:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801036c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036cc:	eb 1a                	jmp    801036e8 <write_head+0x58>
    hb->sector[i] = log.lh.sector[i];
801036ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036d1:	83 c0 10             	add    $0x10,%eax
801036d4:	8b 0c 85 e8 18 11 80 	mov    -0x7feee718(,%eax,4),%ecx
801036db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036e1:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801036e5:	ff 45 f4             	incl   -0xc(%ebp)
801036e8:	a1 24 19 11 80       	mov    0x80111924,%eax
801036ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036f0:	7f dc                	jg     801036ce <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801036f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036f5:	89 04 24             	mov    %eax,(%esp)
801036f8:	e8 e0 ca ff ff       	call   801001dd <bwrite>
  brelse(buf);
801036fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103700:	89 04 24             	mov    %eax,(%esp)
80103703:	e8 0f cb ff ff       	call   80100217 <brelse>
}
80103708:	c9                   	leave  
80103709:	c3                   	ret    

8010370a <recover_from_log>:

static void
recover_from_log(void)
{
8010370a:	55                   	push   %ebp
8010370b:	89 e5                	mov    %esp,%ebp
8010370d:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103710:	e8 0d ff ff ff       	call   80103622 <read_head>
  install_trans(); // if committed, copy from log to disk
80103715:	e8 5d fe ff ff       	call   80103577 <install_trans>
  log.lh.n = 0;
8010371a:	c7 05 24 19 11 80 00 	movl   $0x0,0x80111924
80103721:	00 00 00 
  write_head(); // clear the log
80103724:	e8 67 ff ff ff       	call   80103690 <write_head>
}
80103729:	c9                   	leave  
8010372a:	c3                   	ret    

8010372b <begin_trans>:

void
begin_trans(void)
{
8010372b:	55                   	push   %ebp
8010372c:	89 e5                	mov    %esp,%ebp
8010372e:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103731:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103738:	e8 e2 1e 00 00       	call   8010561f <acquire>
  while (log.busy) {
8010373d:	eb 14                	jmp    80103753 <begin_trans+0x28>
    sleep(&log, &log.lock);
8010373f:	c7 44 24 04 e0 18 11 	movl   $0x801118e0,0x4(%esp)
80103746:	80 
80103747:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
8010374e:	e8 e6 1b 00 00       	call   80105339 <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80103753:	a1 1c 19 11 80       	mov    0x8011191c,%eax
80103758:	85 c0                	test   %eax,%eax
8010375a:	75 e3                	jne    8010373f <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
8010375c:	c7 05 1c 19 11 80 01 	movl   $0x1,0x8011191c
80103763:	00 00 00 
  release(&log.lock);
80103766:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
8010376d:	e8 0f 1f 00 00       	call   80105681 <release>
}
80103772:	c9                   	leave  
80103773:	c3                   	ret    

80103774 <commit_trans>:

void
commit_trans(void)
{
80103774:	55                   	push   %ebp
80103775:	89 e5                	mov    %esp,%ebp
80103777:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
8010377a:	a1 24 19 11 80       	mov    0x80111924,%eax
8010377f:	85 c0                	test   %eax,%eax
80103781:	7e 19                	jle    8010379c <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103783:	e8 08 ff ff ff       	call   80103690 <write_head>
    install_trans(); // Now install writes to home locations
80103788:	e8 ea fd ff ff       	call   80103577 <install_trans>
    log.lh.n = 0; 
8010378d:	c7 05 24 19 11 80 00 	movl   $0x0,0x80111924
80103794:	00 00 00 
    write_head();    // Erase the transaction from the log
80103797:	e8 f4 fe ff ff       	call   80103690 <write_head>
  }
  
  acquire(&log.lock);
8010379c:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
801037a3:	e8 77 1e 00 00       	call   8010561f <acquire>
  log.busy = 0;
801037a8:	c7 05 1c 19 11 80 00 	movl   $0x0,0x8011191c
801037af:	00 00 00 
  wakeup(&log);
801037b2:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
801037b9:	e8 57 1c 00 00       	call   80105415 <wakeup>
  release(&log.lock);
801037be:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
801037c5:	e8 b7 1e 00 00       	call   80105681 <release>
}
801037ca:	c9                   	leave  
801037cb:	c3                   	ret    

801037cc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801037cc:	55                   	push   %ebp
801037cd:	89 e5                	mov    %esp,%ebp
801037cf:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037d2:	a1 24 19 11 80       	mov    0x80111924,%eax
801037d7:	83 f8 09             	cmp    $0x9,%eax
801037da:	7f 10                	jg     801037ec <log_write+0x20>
801037dc:	a1 24 19 11 80       	mov    0x80111924,%eax
801037e1:	8b 15 18 19 11 80    	mov    0x80111918,%edx
801037e7:	4a                   	dec    %edx
801037e8:	39 d0                	cmp    %edx,%eax
801037ea:	7c 0c                	jl     801037f8 <log_write+0x2c>
    panic("too big a transaction");
801037ec:	c7 04 24 00 8f 10 80 	movl   $0x80108f00,(%esp)
801037f3:	e8 3e cd ff ff       	call   80100536 <panic>
  if (!log.busy)
801037f8:	a1 1c 19 11 80       	mov    0x8011191c,%eax
801037fd:	85 c0                	test   %eax,%eax
801037ff:	75 0c                	jne    8010380d <log_write+0x41>
    panic("write outside of trans");
80103801:	c7 04 24 16 8f 10 80 	movl   $0x80108f16,(%esp)
80103808:	e8 29 cd ff ff       	call   80100536 <panic>

  for (i = 0; i < log.lh.n; i++) {
8010380d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103814:	eb 1c                	jmp    80103832 <log_write+0x66>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
80103816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103819:	83 c0 10             	add    $0x10,%eax
8010381c:	8b 04 85 e8 18 11 80 	mov    -0x7feee718(,%eax,4),%eax
80103823:	89 c2                	mov    %eax,%edx
80103825:	8b 45 08             	mov    0x8(%ebp),%eax
80103828:	8b 40 08             	mov    0x8(%eax),%eax
8010382b:	39 c2                	cmp    %eax,%edx
8010382d:	74 0f                	je     8010383e <log_write+0x72>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
8010382f:	ff 45 f4             	incl   -0xc(%ebp)
80103832:	a1 24 19 11 80       	mov    0x80111924,%eax
80103837:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010383a:	7f da                	jg     80103816 <log_write+0x4a>
8010383c:	eb 01                	jmp    8010383f <log_write+0x73>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
8010383e:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
8010383f:	8b 45 08             	mov    0x8(%ebp),%eax
80103842:	8b 40 08             	mov    0x8(%eax),%eax
80103845:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103848:	83 c2 10             	add    $0x10,%edx
8010384b:	89 04 95 e8 18 11 80 	mov    %eax,-0x7feee718(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103852:	8b 15 14 19 11 80    	mov    0x80111914,%edx
80103858:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010385b:	01 d0                	add    %edx,%eax
8010385d:	40                   	inc    %eax
8010385e:	89 c2                	mov    %eax,%edx
80103860:	8b 45 08             	mov    0x8(%ebp),%eax
80103863:	8b 40 04             	mov    0x4(%eax),%eax
80103866:	89 54 24 04          	mov    %edx,0x4(%esp)
8010386a:	89 04 24             	mov    %eax,(%esp)
8010386d:	e8 34 c9 ff ff       	call   801001a6 <bread>
80103872:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103875:	8b 45 08             	mov    0x8(%ebp),%eax
80103878:	8d 50 18             	lea    0x18(%eax),%edx
8010387b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010387e:	83 c0 18             	add    $0x18,%eax
80103881:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103888:	00 
80103889:	89 54 24 04          	mov    %edx,0x4(%esp)
8010388d:	89 04 24             	mov    %eax,(%esp)
80103890:	e8 a9 20 00 00       	call   8010593e <memmove>
  bwrite(lbuf);
80103895:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103898:	89 04 24             	mov    %eax,(%esp)
8010389b:	e8 3d c9 ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
801038a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a3:	89 04 24             	mov    %eax,(%esp)
801038a6:	e8 6c c9 ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
801038ab:	a1 24 19 11 80       	mov    0x80111924,%eax
801038b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038b3:	75 0b                	jne    801038c0 <log_write+0xf4>
    log.lh.n++;
801038b5:	a1 24 19 11 80       	mov    0x80111924,%eax
801038ba:	40                   	inc    %eax
801038bb:	a3 24 19 11 80       	mov    %eax,0x80111924
  b->flags |= B_DIRTY; // XXX prevent eviction
801038c0:	8b 45 08             	mov    0x8(%ebp),%eax
801038c3:	8b 00                	mov    (%eax),%eax
801038c5:	89 c2                	mov    %eax,%edx
801038c7:	83 ca 04             	or     $0x4,%edx
801038ca:	8b 45 08             	mov    0x8(%ebp),%eax
801038cd:	89 10                	mov    %edx,(%eax)
}
801038cf:	c9                   	leave  
801038d0:	c3                   	ret    
801038d1:	66 90                	xchg   %ax,%ax
801038d3:	90                   	nop

801038d4 <v2p>:
801038d4:	55                   	push   %ebp
801038d5:	89 e5                	mov    %esp,%ebp
801038d7:	8b 45 08             	mov    0x8(%ebp),%eax
801038da:	05 00 00 00 80       	add    $0x80000000,%eax
801038df:	5d                   	pop    %ebp
801038e0:	c3                   	ret    

801038e1 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801038e1:	55                   	push   %ebp
801038e2:	89 e5                	mov    %esp,%ebp
801038e4:	8b 45 08             	mov    0x8(%ebp),%eax
801038e7:	05 00 00 00 80       	add    $0x80000000,%eax
801038ec:	5d                   	pop    %ebp
801038ed:	c3                   	ret    

801038ee <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801038ee:	55                   	push   %ebp
801038ef:	89 e5                	mov    %esp,%ebp
801038f1:	53                   	push   %ebx
801038f2:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
801038f5:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801038f8:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
801038fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801038fe:	89 c3                	mov    %eax,%ebx
80103900:	89 d8                	mov    %ebx,%eax
80103902:	f0 87 02             	lock xchg %eax,(%edx)
80103905:	89 c3                	mov    %eax,%ebx
80103907:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010390a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010390d:	83 c4 10             	add    $0x10,%esp
80103910:	5b                   	pop    %ebx
80103911:	5d                   	pop    %ebp
80103912:	c3                   	ret    

80103913 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103913:	55                   	push   %ebp
80103914:	89 e5                	mov    %esp,%ebp
80103916:	83 e4 f0             	and    $0xfffffff0,%esp
80103919:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010391c:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103923:	80 
80103924:	c7 04 24 1c 50 11 80 	movl   $0x8011501c,(%esp)
8010392b:	e8 bd f5 ff ff       	call   80102eed <kinit1>
  kvmalloc();      // kernel page table
80103930:	e8 28 4c 00 00       	call   8010855d <kvmalloc>
  mpinit();        // collect info about this machine
80103935:	e8 a3 04 00 00       	call   80103ddd <mpinit>
  lapicinit(mpbcpu());
8010393a:	e8 3a 02 00 00       	call   80103b79 <mpbcpu>
8010393f:	89 04 24             	mov    %eax,(%esp)
80103942:	e8 ff f8 ff ff       	call   80103246 <lapicinit>
  seginit();       // set up segments
80103947:	e8 cd 45 00 00       	call   80107f19 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010394c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103952:	8a 00                	mov    (%eax),%al
80103954:	0f b6 c0             	movzbl %al,%eax
80103957:	89 44 24 04          	mov    %eax,0x4(%esp)
8010395b:	c7 04 24 2d 8f 10 80 	movl   $0x80108f2d,(%esp)
80103962:	e8 3a ca ff ff       	call   801003a1 <cprintf>
  picinit();       // interrupt controller
80103967:	e8 d8 06 00 00       	call   80104044 <picinit>
  ioapicinit();    // another interrupt controller
8010396c:	e8 74 f4 ff ff       	call   80102de5 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103971:	e8 64 d5 ff ff       	call   80100eda <consoleinit>
  uartinit();      // serial port
80103976:	e8 f1 38 00 00       	call   8010726c <uartinit>
  pinit();         // process table
8010397b:	e8 d7 0b 00 00       	call   80104557 <pinit>
  tvinit();        // trap vectors
80103980:	e8 54 34 00 00       	call   80106dd9 <tvinit>
  binit();         // buffer cache
80103985:	e8 aa c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010398a:	e8 c5 da ff ff       	call   80101454 <fileinit>
  iinit();         // inode cache
8010398f:	e8 58 e1 ff ff       	call   80101aec <iinit>
  ideinit();       // disk
80103994:	e8 b5 f0 ff ff       	call   80102a4e <ideinit>
  if(!ismp)
80103999:	a1 64 19 11 80       	mov    0x80111964,%eax
8010399e:	85 c0                	test   %eax,%eax
801039a0:	75 05                	jne    801039a7 <main+0x94>
    timerinit();   // uniprocessor timer
801039a2:	e8 79 33 00 00       	call   80106d20 <timerinit>
  startothers();   // start other processors
801039a7:	e8 86 00 00 00       	call   80103a32 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039ac:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801039b3:	8e 
801039b4:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801039bb:	e8 65 f5 ff ff       	call   80102f25 <kinit2>
  userinit();      // first user process
801039c0:	e8 76 0d 00 00       	call   8010473b <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801039c5:	e8 22 00 00 00       	call   801039ec <mpmain>

801039ca <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801039ca:	55                   	push   %ebp
801039cb:	89 e5                	mov    %esp,%ebp
801039cd:	83 ec 18             	sub    $0x18,%esp
  switchkvm(); 
801039d0:	e8 9f 4b 00 00       	call   80108574 <switchkvm>
  seginit();
801039d5:	e8 3f 45 00 00       	call   80107f19 <seginit>
  lapicinit(cpunum());
801039da:	e8 c4 f9 ff ff       	call   801033a3 <cpunum>
801039df:	89 04 24             	mov    %eax,(%esp)
801039e2:	e8 5f f8 ff ff       	call   80103246 <lapicinit>
  mpmain();
801039e7:	e8 00 00 00 00       	call   801039ec <mpmain>

801039ec <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801039ec:	55                   	push   %ebp
801039ed:	89 e5                	mov    %esp,%ebp
801039ef:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801039f2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801039f8:	8a 00                	mov    (%eax),%al
801039fa:	0f b6 c0             	movzbl %al,%eax
801039fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a01:	c7 04 24 44 8f 10 80 	movl   $0x80108f44,(%esp)
80103a08:	e8 94 c9 ff ff       	call   801003a1 <cprintf>
  idtinit();       // load idt register
80103a0d:	e8 24 35 00 00       	call   80106f36 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103a12:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a18:	05 a8 00 00 00       	add    $0xa8,%eax
80103a1d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103a24:	00 
80103a25:	89 04 24             	mov    %eax,(%esp)
80103a28:	e8 c1 fe ff ff       	call   801038ee <xchg>
  scheduler();     // start running processes
80103a2d:	e8 bc 14 00 00       	call   80104eee <scheduler>

80103a32 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103a32:	55                   	push   %ebp
80103a33:	89 e5                	mov    %esp,%ebp
80103a35:	53                   	push   %ebx
80103a36:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103a39:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103a40:	e8 9c fe ff ff       	call   801038e1 <p2v>
80103a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a48:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103a4d:	89 44 24 08          	mov    %eax,0x8(%esp)
80103a51:	c7 44 24 04 0c c5 10 	movl   $0x8010c50c,0x4(%esp)
80103a58:	80 
80103a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a5c:	89 04 24             	mov    %eax,(%esp)
80103a5f:	e8 da 1e 00 00       	call   8010593e <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103a64:	c7 45 f4 80 19 11 80 	movl   $0x80111980,-0xc(%ebp)
80103a6b:	e9 8f 00 00 00       	jmp    80103aff <startothers+0xcd>
    if(c == cpus+cpunum())  // We've started already.
80103a70:	e8 2e f9 ff ff       	call   801033a3 <cpunum>
80103a75:	89 c2                	mov    %eax,%edx
80103a77:	89 d0                	mov    %edx,%eax
80103a79:	d1 e0                	shl    %eax
80103a7b:	01 d0                	add    %edx,%eax
80103a7d:	c1 e0 04             	shl    $0x4,%eax
80103a80:	29 d0                	sub    %edx,%eax
80103a82:	c1 e0 02             	shl    $0x2,%eax
80103a85:	05 80 19 11 80       	add    $0x80111980,%eax
80103a8a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a8d:	74 68                	je     80103af7 <startothers+0xc5>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a8f:	e8 87 f5 ff ff       	call   8010301b <kalloc>
80103a94:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a9a:	83 e8 04             	sub    $0x4,%eax
80103a9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103aa0:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103aa6:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aab:	83 e8 08             	sub    $0x8,%eax
80103aae:	c7 00 ca 39 10 80    	movl   $0x801039ca,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ab7:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103aba:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
80103ac1:	e8 0e fe ff ff       	call   801038d4 <v2p>
80103ac6:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103acb:	89 04 24             	mov    %eax,(%esp)
80103ace:	e8 01 fe ff ff       	call   801038d4 <v2p>
80103ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ad6:	8a 12                	mov    (%edx),%dl
80103ad8:	0f b6 d2             	movzbl %dl,%edx
80103adb:	89 44 24 04          	mov    %eax,0x4(%esp)
80103adf:	89 14 24             	mov    %edx,(%esp)
80103ae2:	e8 40 f9 ff ff       	call   80103427 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103ae7:	90                   	nop
80103ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aeb:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103af1:	85 c0                	test   %eax,%eax
80103af3:	74 f3                	je     80103ae8 <startothers+0xb6>
80103af5:	eb 01                	jmp    80103af8 <startothers+0xc6>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103af7:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103af8:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103aff:	a1 60 1f 11 80       	mov    0x80111f60,%eax
80103b04:	89 c2                	mov    %eax,%edx
80103b06:	89 d0                	mov    %edx,%eax
80103b08:	d1 e0                	shl    %eax
80103b0a:	01 d0                	add    %edx,%eax
80103b0c:	c1 e0 04             	shl    $0x4,%eax
80103b0f:	29 d0                	sub    %edx,%eax
80103b11:	c1 e0 02             	shl    $0x2,%eax
80103b14:	05 80 19 11 80       	add    $0x80111980,%eax
80103b19:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b1c:	0f 87 4e ff ff ff    	ja     80103a70 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103b22:	83 c4 24             	add    $0x24,%esp
80103b25:	5b                   	pop    %ebx
80103b26:	5d                   	pop    %ebp
80103b27:	c3                   	ret    

80103b28 <p2v>:
80103b28:	55                   	push   %ebp
80103b29:	89 e5                	mov    %esp,%ebp
80103b2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103b2e:	05 00 00 00 80       	add    $0x80000000,%eax
80103b33:	5d                   	pop    %ebp
80103b34:	c3                   	ret    

80103b35 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103b35:	55                   	push   %ebp
80103b36:	89 e5                	mov    %esp,%ebp
80103b38:	53                   	push   %ebx
80103b39:	83 ec 14             	sub    $0x14,%esp
80103b3c:	8b 45 08             	mov    0x8(%ebp),%eax
80103b3f:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b43:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103b46:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80103b4a:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
80103b4e:	ec                   	in     (%dx),%al
80103b4f:	88 c3                	mov    %al,%bl
80103b51:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80103b54:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80103b57:	83 c4 14             	add    $0x14,%esp
80103b5a:	5b                   	pop    %ebx
80103b5b:	5d                   	pop    %ebp
80103b5c:	c3                   	ret    

80103b5d <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103b5d:	55                   	push   %ebp
80103b5e:	89 e5                	mov    %esp,%ebp
80103b60:	83 ec 08             	sub    $0x8,%esp
80103b63:	8b 45 08             	mov    0x8(%ebp),%eax
80103b66:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b69:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103b6d:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b70:	8a 45 f8             	mov    -0x8(%ebp),%al
80103b73:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103b76:	ee                   	out    %al,(%dx)
}
80103b77:	c9                   	leave  
80103b78:	c3                   	ret    

80103b79 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103b79:	55                   	push   %ebp
80103b7a:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103b7c:	a1 44 c6 10 80       	mov    0x8010c644,%eax
80103b81:	89 c2                	mov    %eax,%edx
80103b83:	b8 80 19 11 80       	mov    $0x80111980,%eax
80103b88:	89 d1                	mov    %edx,%ecx
80103b8a:	29 c1                	sub    %eax,%ecx
80103b8c:	89 c8                	mov    %ecx,%eax
80103b8e:	89 c2                	mov    %eax,%edx
80103b90:	c1 fa 02             	sar    $0x2,%edx
80103b93:	89 d0                	mov    %edx,%eax
80103b95:	c1 e0 03             	shl    $0x3,%eax
80103b98:	01 d0                	add    %edx,%eax
80103b9a:	c1 e0 03             	shl    $0x3,%eax
80103b9d:	01 d0                	add    %edx,%eax
80103b9f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80103ba6:	01 c8                	add    %ecx,%eax
80103ba8:	c1 e0 03             	shl    $0x3,%eax
80103bab:	01 d0                	add    %edx,%eax
80103bad:	c1 e0 03             	shl    $0x3,%eax
80103bb0:	29 d0                	sub    %edx,%eax
80103bb2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80103bb9:	01 c8                	add    %ecx,%eax
80103bbb:	c1 e0 02             	shl    $0x2,%eax
80103bbe:	01 d0                	add    %edx,%eax
80103bc0:	c1 e0 03             	shl    $0x3,%eax
80103bc3:	29 d0                	sub    %edx,%eax
80103bc5:	89 c1                	mov    %eax,%ecx
80103bc7:	c1 e1 07             	shl    $0x7,%ecx
80103bca:	01 c8                	add    %ecx,%eax
80103bcc:	d1 e0                	shl    %eax
80103bce:	01 d0                	add    %edx,%eax
}
80103bd0:	5d                   	pop    %ebp
80103bd1:	c3                   	ret    

80103bd2 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103bd2:	55                   	push   %ebp
80103bd3:	89 e5                	mov    %esp,%ebp
80103bd5:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103bd8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103bdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103be6:	eb 13                	jmp    80103bfb <sum+0x29>
    sum += addr[i];
80103be8:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103beb:	8b 45 08             	mov    0x8(%ebp),%eax
80103bee:	01 d0                	add    %edx,%eax
80103bf0:	8a 00                	mov    (%eax),%al
80103bf2:	0f b6 c0             	movzbl %al,%eax
80103bf5:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103bf8:	ff 45 fc             	incl   -0x4(%ebp)
80103bfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103bfe:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103c01:	7c e5                	jl     80103be8 <sum+0x16>
    sum += addr[i];
  return sum;
80103c03:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103c06:	c9                   	leave  
80103c07:	c3                   	ret    

80103c08 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103c08:	55                   	push   %ebp
80103c09:	89 e5                	mov    %esp,%ebp
80103c0b:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103c0e:	8b 45 08             	mov    0x8(%ebp),%eax
80103c11:	89 04 24             	mov    %eax,(%esp)
80103c14:	e8 0f ff ff ff       	call   80103b28 <p2v>
80103c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103c1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c22:	01 d0                	add    %edx,%eax
80103c24:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c2d:	eb 3f                	jmp    80103c6e <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c2f:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103c36:	00 
80103c37:	c7 44 24 04 58 8f 10 	movl   $0x80108f58,0x4(%esp)
80103c3e:	80 
80103c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c42:	89 04 24             	mov    %eax,(%esp)
80103c45:	e8 9f 1c 00 00       	call   801058e9 <memcmp>
80103c4a:	85 c0                	test   %eax,%eax
80103c4c:	75 1c                	jne    80103c6a <mpsearch1+0x62>
80103c4e:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103c55:	00 
80103c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c59:	89 04 24             	mov    %eax,(%esp)
80103c5c:	e8 71 ff ff ff       	call   80103bd2 <sum>
80103c61:	84 c0                	test   %al,%al
80103c63:	75 05                	jne    80103c6a <mpsearch1+0x62>
      return (struct mp*)p;
80103c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c68:	eb 11                	jmp    80103c7b <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103c6a:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c71:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103c74:	72 b9                	jb     80103c2f <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103c76:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103c7b:	c9                   	leave  
80103c7c:	c3                   	ret    

80103c7d <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103c7d:	55                   	push   %ebp
80103c7e:	89 e5                	mov    %esp,%ebp
80103c80:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103c83:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c8d:	83 c0 0f             	add    $0xf,%eax
80103c90:	8a 00                	mov    (%eax),%al
80103c92:	0f b6 c0             	movzbl %al,%eax
80103c95:	89 c2                	mov    %eax,%edx
80103c97:	c1 e2 08             	shl    $0x8,%edx
80103c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c9d:	83 c0 0e             	add    $0xe,%eax
80103ca0:	8a 00                	mov    (%eax),%al
80103ca2:	0f b6 c0             	movzbl %al,%eax
80103ca5:	09 d0                	or     %edx,%eax
80103ca7:	c1 e0 04             	shl    $0x4,%eax
80103caa:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103cad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103cb1:	74 21                	je     80103cd4 <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103cb3:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103cba:	00 
80103cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cbe:	89 04 24             	mov    %eax,(%esp)
80103cc1:	e8 42 ff ff ff       	call   80103c08 <mpsearch1>
80103cc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cc9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ccd:	74 4e                	je     80103d1d <mpsearch+0xa0>
      return mp;
80103ccf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103cd2:	eb 5d                	jmp    80103d31 <mpsearch+0xb4>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd7:	83 c0 14             	add    $0x14,%eax
80103cda:	8a 00                	mov    (%eax),%al
80103cdc:	0f b6 c0             	movzbl %al,%eax
80103cdf:	89 c2                	mov    %eax,%edx
80103ce1:	c1 e2 08             	shl    $0x8,%edx
80103ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ce7:	83 c0 13             	add    $0x13,%eax
80103cea:	8a 00                	mov    (%eax),%al
80103cec:	0f b6 c0             	movzbl %al,%eax
80103cef:	09 d0                	or     %edx,%eax
80103cf1:	c1 e0 0a             	shl    $0xa,%eax
80103cf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cfa:	2d 00 04 00 00       	sub    $0x400,%eax
80103cff:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103d06:	00 
80103d07:	89 04 24             	mov    %eax,(%esp)
80103d0a:	e8 f9 fe ff ff       	call   80103c08 <mpsearch1>
80103d0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d12:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d16:	74 05                	je     80103d1d <mpsearch+0xa0>
      return mp;
80103d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d1b:	eb 14                	jmp    80103d31 <mpsearch+0xb4>
  }
  return mpsearch1(0xF0000, 0x10000);
80103d1d:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103d24:	00 
80103d25:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103d2c:	e8 d7 fe ff ff       	call   80103c08 <mpsearch1>
}
80103d31:	c9                   	leave  
80103d32:	c3                   	ret    

80103d33 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103d33:	55                   	push   %ebp
80103d34:	89 e5                	mov    %esp,%ebp
80103d36:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103d39:	e8 3f ff ff ff       	call   80103c7d <mpsearch>
80103d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d45:	74 0a                	je     80103d51 <mpconfig+0x1e>
80103d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d4a:	8b 40 04             	mov    0x4(%eax),%eax
80103d4d:	85 c0                	test   %eax,%eax
80103d4f:	75 0a                	jne    80103d5b <mpconfig+0x28>
    return 0;
80103d51:	b8 00 00 00 00       	mov    $0x0,%eax
80103d56:	e9 80 00 00 00       	jmp    80103ddb <mpconfig+0xa8>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d5e:	8b 40 04             	mov    0x4(%eax),%eax
80103d61:	89 04 24             	mov    %eax,(%esp)
80103d64:	e8 bf fd ff ff       	call   80103b28 <p2v>
80103d69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103d6c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103d73:	00 
80103d74:	c7 44 24 04 5d 8f 10 	movl   $0x80108f5d,0x4(%esp)
80103d7b:	80 
80103d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d7f:	89 04 24             	mov    %eax,(%esp)
80103d82:	e8 62 1b 00 00       	call   801058e9 <memcmp>
80103d87:	85 c0                	test   %eax,%eax
80103d89:	74 07                	je     80103d92 <mpconfig+0x5f>
    return 0;
80103d8b:	b8 00 00 00 00       	mov    $0x0,%eax
80103d90:	eb 49                	jmp    80103ddb <mpconfig+0xa8>
  if(conf->version != 1 && conf->version != 4)
80103d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d95:	8a 40 06             	mov    0x6(%eax),%al
80103d98:	3c 01                	cmp    $0x1,%al
80103d9a:	74 11                	je     80103dad <mpconfig+0x7a>
80103d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d9f:	8a 40 06             	mov    0x6(%eax),%al
80103da2:	3c 04                	cmp    $0x4,%al
80103da4:	74 07                	je     80103dad <mpconfig+0x7a>
    return 0;
80103da6:	b8 00 00 00 00       	mov    $0x0,%eax
80103dab:	eb 2e                	jmp    80103ddb <mpconfig+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103db0:	8b 40 04             	mov    0x4(%eax),%eax
80103db3:	0f b7 c0             	movzwl %ax,%eax
80103db6:	89 44 24 04          	mov    %eax,0x4(%esp)
80103dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dbd:	89 04 24             	mov    %eax,(%esp)
80103dc0:	e8 0d fe ff ff       	call   80103bd2 <sum>
80103dc5:	84 c0                	test   %al,%al
80103dc7:	74 07                	je     80103dd0 <mpconfig+0x9d>
    return 0;
80103dc9:	b8 00 00 00 00       	mov    $0x0,%eax
80103dce:	eb 0b                	jmp    80103ddb <mpconfig+0xa8>
  *pmp = mp;
80103dd0:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103dd6:	89 10                	mov    %edx,(%eax)
  return conf;
80103dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103ddb:	c9                   	leave  
80103ddc:	c3                   	ret    

80103ddd <mpinit>:

void
mpinit(void)
{
80103ddd:	55                   	push   %ebp
80103dde:	89 e5                	mov    %esp,%ebp
80103de0:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103de3:	c7 05 44 c6 10 80 80 	movl   $0x80111980,0x8010c644
80103dea:	19 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103ded:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103df0:	89 04 24             	mov    %eax,(%esp)
80103df3:	e8 3b ff ff ff       	call   80103d33 <mpconfig>
80103df8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103dfb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103dff:	0f 84 a4 01 00 00    	je     80103fa9 <mpinit+0x1cc>
    return;
  ismp = 1;
80103e05:	c7 05 64 19 11 80 01 	movl   $0x1,0x80111964
80103e0c:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e12:	8b 40 24             	mov    0x24(%eax),%eax
80103e15:	a3 dc 18 11 80       	mov    %eax,0x801118dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e1d:	83 c0 2c             	add    $0x2c,%eax
80103e20:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e26:	8b 40 04             	mov    0x4(%eax),%eax
80103e29:	0f b7 d0             	movzwl %ax,%edx
80103e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e2f:	01 d0                	add    %edx,%eax
80103e31:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e34:	e9 fe 00 00 00       	jmp    80103f37 <mpinit+0x15a>
    switch(*p){
80103e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e3c:	8a 00                	mov    (%eax),%al
80103e3e:	0f b6 c0             	movzbl %al,%eax
80103e41:	83 f8 04             	cmp    $0x4,%eax
80103e44:	0f 87 cb 00 00 00    	ja     80103f15 <mpinit+0x138>
80103e4a:	8b 04 85 a0 8f 10 80 	mov    -0x7fef7060(,%eax,4),%eax
80103e51:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e56:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103e59:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e5c:	8a 40 01             	mov    0x1(%eax),%al
80103e5f:	0f b6 d0             	movzbl %al,%edx
80103e62:	a1 60 1f 11 80       	mov    0x80111f60,%eax
80103e67:	39 c2                	cmp    %eax,%edx
80103e69:	74 2c                	je     80103e97 <mpinit+0xba>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103e6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e6e:	8a 40 01             	mov    0x1(%eax),%al
80103e71:	0f b6 d0             	movzbl %al,%edx
80103e74:	a1 60 1f 11 80       	mov    0x80111f60,%eax
80103e79:	89 54 24 08          	mov    %edx,0x8(%esp)
80103e7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e81:	c7 04 24 62 8f 10 80 	movl   $0x80108f62,(%esp)
80103e88:	e8 14 c5 ff ff       	call   801003a1 <cprintf>
        ismp = 0;
80103e8d:	c7 05 64 19 11 80 00 	movl   $0x0,0x80111964
80103e94:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103e97:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e9a:	8a 40 03             	mov    0x3(%eax),%al
80103e9d:	0f b6 c0             	movzbl %al,%eax
80103ea0:	83 e0 02             	and    $0x2,%eax
80103ea3:	85 c0                	test   %eax,%eax
80103ea5:	74 1e                	je     80103ec5 <mpinit+0xe8>
        bcpu = &cpus[ncpu];
80103ea7:	8b 15 60 1f 11 80    	mov    0x80111f60,%edx
80103ead:	89 d0                	mov    %edx,%eax
80103eaf:	d1 e0                	shl    %eax
80103eb1:	01 d0                	add    %edx,%eax
80103eb3:	c1 e0 04             	shl    $0x4,%eax
80103eb6:	29 d0                	sub    %edx,%eax
80103eb8:	c1 e0 02             	shl    $0x2,%eax
80103ebb:	05 80 19 11 80       	add    $0x80111980,%eax
80103ec0:	a3 44 c6 10 80       	mov    %eax,0x8010c644
      cpus[ncpu].id = ncpu;
80103ec5:	8b 15 60 1f 11 80    	mov    0x80111f60,%edx
80103ecb:	a1 60 1f 11 80       	mov    0x80111f60,%eax
80103ed0:	88 c1                	mov    %al,%cl
80103ed2:	89 d0                	mov    %edx,%eax
80103ed4:	d1 e0                	shl    %eax
80103ed6:	01 d0                	add    %edx,%eax
80103ed8:	c1 e0 04             	shl    $0x4,%eax
80103edb:	29 d0                	sub    %edx,%eax
80103edd:	c1 e0 02             	shl    $0x2,%eax
80103ee0:	05 80 19 11 80       	add    $0x80111980,%eax
80103ee5:	88 08                	mov    %cl,(%eax)
      ncpu++;
80103ee7:	a1 60 1f 11 80       	mov    0x80111f60,%eax
80103eec:	40                   	inc    %eax
80103eed:	a3 60 1f 11 80       	mov    %eax,0x80111f60
      p += sizeof(struct mpproc);
80103ef2:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103ef6:	eb 3f                	jmp    80103f37 <mpinit+0x15a>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103efb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103efe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f01:	8a 40 01             	mov    0x1(%eax),%al
80103f04:	a2 60 19 11 80       	mov    %al,0x80111960
      p += sizeof(struct mpioapic);
80103f09:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f0d:	eb 28                	jmp    80103f37 <mpinit+0x15a>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103f0f:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f13:	eb 22                	jmp    80103f37 <mpinit+0x15a>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f18:	8a 00                	mov    (%eax),%al
80103f1a:	0f b6 c0             	movzbl %al,%eax
80103f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f21:	c7 04 24 80 8f 10 80 	movl   $0x80108f80,(%esp)
80103f28:	e8 74 c4 ff ff       	call   801003a1 <cprintf>
      ismp = 0;
80103f2d:	c7 05 64 19 11 80 00 	movl   $0x0,0x80111964
80103f34:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f3a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103f3d:	0f 82 f6 fe ff ff    	jb     80103e39 <mpinit+0x5c>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103f43:	a1 64 19 11 80       	mov    0x80111964,%eax
80103f48:	85 c0                	test   %eax,%eax
80103f4a:	75 1d                	jne    80103f69 <mpinit+0x18c>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103f4c:	c7 05 60 1f 11 80 01 	movl   $0x1,0x80111f60
80103f53:	00 00 00 
    lapic = 0;
80103f56:	c7 05 dc 18 11 80 00 	movl   $0x0,0x801118dc
80103f5d:	00 00 00 
    ioapicid = 0;
80103f60:	c6 05 60 19 11 80 00 	movb   $0x0,0x80111960
80103f67:	eb 40                	jmp    80103fa9 <mpinit+0x1cc>
    return;
  }

  if(mp->imcrp){
80103f69:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f6c:	8a 40 0c             	mov    0xc(%eax),%al
80103f6f:	84 c0                	test   %al,%al
80103f71:	74 36                	je     80103fa9 <mpinit+0x1cc>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103f73:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103f7a:	00 
80103f7b:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103f82:	e8 d6 fb ff ff       	call   80103b5d <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103f87:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103f8e:	e8 a2 fb ff ff       	call   80103b35 <inb>
80103f93:	83 c8 01             	or     $0x1,%eax
80103f96:	0f b6 c0             	movzbl %al,%eax
80103f99:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f9d:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103fa4:	e8 b4 fb ff ff       	call   80103b5d <outb>
  }
}
80103fa9:	c9                   	leave  
80103faa:	c3                   	ret    
80103fab:	90                   	nop

80103fac <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103fac:	55                   	push   %ebp
80103fad:	89 e5                	mov    %esp,%ebp
80103faf:	83 ec 08             	sub    $0x8,%esp
80103fb2:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb5:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fb8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103fbc:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103fbf:	8a 45 f8             	mov    -0x8(%ebp),%al
80103fc2:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103fc5:	ee                   	out    %al,(%dx)
}
80103fc6:	c9                   	leave  
80103fc7:	c3                   	ret    

80103fc8 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103fc8:	55                   	push   %ebp
80103fc9:	89 e5                	mov    %esp,%ebp
80103fcb:	83 ec 0c             	sub    $0xc,%esp
80103fce:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103fd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103fd8:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103fde:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103fe1:	0f b6 c0             	movzbl %al,%eax
80103fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fe8:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103fef:	e8 b8 ff ff ff       	call   80103fac <outb>
  outb(IO_PIC2+1, mask >> 8);
80103ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103ff7:	66 c1 e8 08          	shr    $0x8,%ax
80103ffb:	0f b6 c0             	movzbl %al,%eax
80103ffe:	89 44 24 04          	mov    %eax,0x4(%esp)
80104002:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80104009:	e8 9e ff ff ff       	call   80103fac <outb>
}
8010400e:	c9                   	leave  
8010400f:	c3                   	ret    

80104010 <picenable>:

void
picenable(int irq)
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	53                   	push   %ebx
80104014:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80104017:	8b 45 08             	mov    0x8(%ebp),%eax
8010401a:	ba 01 00 00 00       	mov    $0x1,%edx
8010401f:	89 d3                	mov    %edx,%ebx
80104021:	88 c1                	mov    %al,%cl
80104023:	d3 e3                	shl    %cl,%ebx
80104025:	89 d8                	mov    %ebx,%eax
80104027:	89 c2                	mov    %eax,%edx
80104029:	f7 d2                	not    %edx
8010402b:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80104031:	21 d0                	and    %edx,%eax
80104033:	0f b7 c0             	movzwl %ax,%eax
80104036:	89 04 24             	mov    %eax,(%esp)
80104039:	e8 8a ff ff ff       	call   80103fc8 <picsetmask>
}
8010403e:	83 c4 04             	add    $0x4,%esp
80104041:	5b                   	pop    %ebx
80104042:	5d                   	pop    %ebp
80104043:	c3                   	ret    

80104044 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80104044:	55                   	push   %ebp
80104045:	89 e5                	mov    %esp,%ebp
80104047:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
8010404a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80104051:	00 
80104052:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80104059:	e8 4e ff ff ff       	call   80103fac <outb>
  outb(IO_PIC2+1, 0xFF);
8010405e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80104065:	00 
80104066:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
8010406d:	e8 3a ff ff ff       	call   80103fac <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80104072:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80104079:	00 
8010407a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80104081:	e8 26 ff ff ff       	call   80103fac <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80104086:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
8010408d:	00 
8010408e:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80104095:	e8 12 ff ff ff       	call   80103fac <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
8010409a:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
801040a1:	00 
801040a2:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
801040a9:	e8 fe fe ff ff       	call   80103fac <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
801040ae:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801040b5:	00 
801040b6:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
801040bd:	e8 ea fe ff ff       	call   80103fac <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
801040c2:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
801040c9:	00 
801040ca:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
801040d1:	e8 d6 fe ff ff       	call   80103fac <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
801040d6:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
801040dd:	00 
801040de:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
801040e5:	e8 c2 fe ff ff       	call   80103fac <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
801040ea:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
801040f1:	00 
801040f2:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
801040f9:	e8 ae fe ff ff       	call   80103fac <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
801040fe:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80104105:	00 
80104106:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
8010410d:	e8 9a fe ff ff       	call   80103fac <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104112:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80104119:	00 
8010411a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80104121:	e8 86 fe ff ff       	call   80103fac <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80104126:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
8010412d:	00 
8010412e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80104135:	e8 72 fe ff ff       	call   80103fac <outb>

  outb(IO_PIC2, 0x68);             // OCW3
8010413a:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80104141:	00 
80104142:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80104149:	e8 5e fe ff ff       	call   80103fac <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
8010414e:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80104155:	00 
80104156:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
8010415d:	e8 4a fe ff ff       	call   80103fac <outb>

  if(irqmask != 0xFFFF)
80104162:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80104168:	66 83 f8 ff          	cmp    $0xffff,%ax
8010416c:	74 11                	je     8010417f <picinit+0x13b>
    picsetmask(irqmask);
8010416e:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80104174:	0f b7 c0             	movzwl %ax,%eax
80104177:	89 04 24             	mov    %eax,(%esp)
8010417a:	e8 49 fe ff ff       	call   80103fc8 <picsetmask>
}
8010417f:	c9                   	leave  
80104180:	c3                   	ret    
80104181:	66 90                	xchg   %ax,%ax
80104183:	90                   	nop

80104184 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104184:	55                   	push   %ebp
80104185:	89 e5                	mov    %esp,%ebp
80104187:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
8010418a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104191:	8b 45 0c             	mov    0xc(%ebp),%eax
80104194:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010419a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010419d:	8b 10                	mov    (%eax),%edx
8010419f:	8b 45 08             	mov    0x8(%ebp),%eax
801041a2:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801041a4:	e8 c7 d2 ff ff       	call   80101470 <filealloc>
801041a9:	8b 55 08             	mov    0x8(%ebp),%edx
801041ac:	89 02                	mov    %eax,(%edx)
801041ae:	8b 45 08             	mov    0x8(%ebp),%eax
801041b1:	8b 00                	mov    (%eax),%eax
801041b3:	85 c0                	test   %eax,%eax
801041b5:	0f 84 c8 00 00 00    	je     80104283 <pipealloc+0xff>
801041bb:	e8 b0 d2 ff ff       	call   80101470 <filealloc>
801041c0:	8b 55 0c             	mov    0xc(%ebp),%edx
801041c3:	89 02                	mov    %eax,(%edx)
801041c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801041c8:	8b 00                	mov    (%eax),%eax
801041ca:	85 c0                	test   %eax,%eax
801041cc:	0f 84 b1 00 00 00    	je     80104283 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801041d2:	e8 44 ee ff ff       	call   8010301b <kalloc>
801041d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801041da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041de:	0f 84 9e 00 00 00    	je     80104282 <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
801041e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e7:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801041ee:	00 00 00 
  p->writeopen = 1;
801041f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f4:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801041fb:	00 00 00 
  p->nwrite = 0;
801041fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104201:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104208:	00 00 00 
  p->nread = 0;
8010420b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010420e:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104215:	00 00 00 
  initlock(&p->lock, "pipe");
80104218:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010421b:	c7 44 24 04 b4 8f 10 	movl   $0x80108fb4,0x4(%esp)
80104222:	80 
80104223:	89 04 24             	mov    %eax,(%esp)
80104226:	e8 d3 13 00 00       	call   801055fe <initlock>
  (*f0)->type = FD_PIPE;
8010422b:	8b 45 08             	mov    0x8(%ebp),%eax
8010422e:	8b 00                	mov    (%eax),%eax
80104230:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104236:	8b 45 08             	mov    0x8(%ebp),%eax
80104239:	8b 00                	mov    (%eax),%eax
8010423b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010423f:	8b 45 08             	mov    0x8(%ebp),%eax
80104242:	8b 00                	mov    (%eax),%eax
80104244:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104248:	8b 45 08             	mov    0x8(%ebp),%eax
8010424b:	8b 00                	mov    (%eax),%eax
8010424d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104250:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104253:	8b 45 0c             	mov    0xc(%ebp),%eax
80104256:	8b 00                	mov    (%eax),%eax
80104258:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010425e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104261:	8b 00                	mov    (%eax),%eax
80104263:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104267:	8b 45 0c             	mov    0xc(%ebp),%eax
8010426a:	8b 00                	mov    (%eax),%eax
8010426c:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104270:	8b 45 0c             	mov    0xc(%ebp),%eax
80104273:	8b 00                	mov    (%eax),%eax
80104275:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104278:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010427b:	b8 00 00 00 00       	mov    $0x0,%eax
80104280:	eb 43                	jmp    801042c5 <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80104282:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80104283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104287:	74 0b                	je     80104294 <pipealloc+0x110>
    kfree((char*)p);
80104289:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010428c:	89 04 24             	mov    %eax,(%esp)
8010428f:	e8 ee ec ff ff       	call   80102f82 <kfree>
  if(*f0)
80104294:	8b 45 08             	mov    0x8(%ebp),%eax
80104297:	8b 00                	mov    (%eax),%eax
80104299:	85 c0                	test   %eax,%eax
8010429b:	74 0d                	je     801042aa <pipealloc+0x126>
    fileclose(*f0);
8010429d:	8b 45 08             	mov    0x8(%ebp),%eax
801042a0:	8b 00                	mov    (%eax),%eax
801042a2:	89 04 24             	mov    %eax,(%esp)
801042a5:	e8 6e d2 ff ff       	call   80101518 <fileclose>
  if(*f1)
801042aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801042ad:	8b 00                	mov    (%eax),%eax
801042af:	85 c0                	test   %eax,%eax
801042b1:	74 0d                	je     801042c0 <pipealloc+0x13c>
    fileclose(*f1);
801042b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801042b6:	8b 00                	mov    (%eax),%eax
801042b8:	89 04 24             	mov    %eax,(%esp)
801042bb:	e8 58 d2 ff ff       	call   80101518 <fileclose>
  return -1;
801042c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042c5:	c9                   	leave  
801042c6:	c3                   	ret    

801042c7 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801042c7:	55                   	push   %ebp
801042c8:	89 e5                	mov    %esp,%ebp
801042ca:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
801042cd:	8b 45 08             	mov    0x8(%ebp),%eax
801042d0:	89 04 24             	mov    %eax,(%esp)
801042d3:	e8 47 13 00 00       	call   8010561f <acquire>
  if(writable){
801042d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801042dc:	74 1f                	je     801042fd <pipeclose+0x36>
    p->writeopen = 0;
801042de:	8b 45 08             	mov    0x8(%ebp),%eax
801042e1:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801042e8:	00 00 00 
    wakeup(&p->nread);
801042eb:	8b 45 08             	mov    0x8(%ebp),%eax
801042ee:	05 34 02 00 00       	add    $0x234,%eax
801042f3:	89 04 24             	mov    %eax,(%esp)
801042f6:	e8 1a 11 00 00       	call   80105415 <wakeup>
801042fb:	eb 1d                	jmp    8010431a <pipeclose+0x53>
  } else {
    p->readopen = 0;
801042fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104300:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104307:	00 00 00 
    wakeup(&p->nwrite);
8010430a:	8b 45 08             	mov    0x8(%ebp),%eax
8010430d:	05 38 02 00 00       	add    $0x238,%eax
80104312:	89 04 24             	mov    %eax,(%esp)
80104315:	e8 fb 10 00 00       	call   80105415 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010431a:	8b 45 08             	mov    0x8(%ebp),%eax
8010431d:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104323:	85 c0                	test   %eax,%eax
80104325:	75 25                	jne    8010434c <pipeclose+0x85>
80104327:	8b 45 08             	mov    0x8(%ebp),%eax
8010432a:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104330:	85 c0                	test   %eax,%eax
80104332:	75 18                	jne    8010434c <pipeclose+0x85>
    release(&p->lock);
80104334:	8b 45 08             	mov    0x8(%ebp),%eax
80104337:	89 04 24             	mov    %eax,(%esp)
8010433a:	e8 42 13 00 00       	call   80105681 <release>
    kfree((char*)p);
8010433f:	8b 45 08             	mov    0x8(%ebp),%eax
80104342:	89 04 24             	mov    %eax,(%esp)
80104345:	e8 38 ec ff ff       	call   80102f82 <kfree>
8010434a:	eb 0b                	jmp    80104357 <pipeclose+0x90>
  } else
    release(&p->lock);
8010434c:	8b 45 08             	mov    0x8(%ebp),%eax
8010434f:	89 04 24             	mov    %eax,(%esp)
80104352:	e8 2a 13 00 00       	call   80105681 <release>
}
80104357:	c9                   	leave  
80104358:	c3                   	ret    

80104359 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104359:	55                   	push   %ebp
8010435a:	89 e5                	mov    %esp,%ebp
8010435c:	53                   	push   %ebx
8010435d:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104360:	8b 45 08             	mov    0x8(%ebp),%eax
80104363:	89 04 24             	mov    %eax,(%esp)
80104366:	e8 b4 12 00 00       	call   8010561f <acquire>
  for(i = 0; i < n; i++){
8010436b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104372:	e9 a6 00 00 00       	jmp    8010441d <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104377:	8b 45 08             	mov    0x8(%ebp),%eax
8010437a:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104380:	85 c0                	test   %eax,%eax
80104382:	74 0d                	je     80104391 <pipewrite+0x38>
80104384:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010438a:	8b 40 24             	mov    0x24(%eax),%eax
8010438d:	85 c0                	test   %eax,%eax
8010438f:	74 15                	je     801043a6 <pipewrite+0x4d>
        release(&p->lock);
80104391:	8b 45 08             	mov    0x8(%ebp),%eax
80104394:	89 04 24             	mov    %eax,(%esp)
80104397:	e8 e5 12 00 00       	call   80105681 <release>
        return -1;
8010439c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043a1:	e9 9d 00 00 00       	jmp    80104443 <pipewrite+0xea>
      }
      wakeup(&p->nread);
801043a6:	8b 45 08             	mov    0x8(%ebp),%eax
801043a9:	05 34 02 00 00       	add    $0x234,%eax
801043ae:	89 04 24             	mov    %eax,(%esp)
801043b1:	e8 5f 10 00 00       	call   80105415 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801043b6:	8b 45 08             	mov    0x8(%ebp),%eax
801043b9:	8b 55 08             	mov    0x8(%ebp),%edx
801043bc:	81 c2 38 02 00 00    	add    $0x238,%edx
801043c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801043c6:	89 14 24             	mov    %edx,(%esp)
801043c9:	e8 6b 0f 00 00       	call   80105339 <sleep>
801043ce:	eb 01                	jmp    801043d1 <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801043d0:	90                   	nop
801043d1:	8b 45 08             	mov    0x8(%ebp),%eax
801043d4:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801043da:	8b 45 08             	mov    0x8(%ebp),%eax
801043dd:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801043e3:	05 00 02 00 00       	add    $0x200,%eax
801043e8:	39 c2                	cmp    %eax,%edx
801043ea:	74 8b                	je     80104377 <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801043ec:	8b 45 08             	mov    0x8(%ebp),%eax
801043ef:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801043f5:	89 c3                	mov    %eax,%ebx
801043f7:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801043fd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104400:	8b 55 0c             	mov    0xc(%ebp),%edx
80104403:	01 ca                	add    %ecx,%edx
80104405:	8a 0a                	mov    (%edx),%cl
80104407:	8b 55 08             	mov    0x8(%ebp),%edx
8010440a:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
8010440e:	8d 50 01             	lea    0x1(%eax),%edx
80104411:	8b 45 08             	mov    0x8(%ebp),%eax
80104414:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
8010441a:	ff 45 f4             	incl   -0xc(%ebp)
8010441d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104420:	3b 45 10             	cmp    0x10(%ebp),%eax
80104423:	7c ab                	jl     801043d0 <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104425:	8b 45 08             	mov    0x8(%ebp),%eax
80104428:	05 34 02 00 00       	add    $0x234,%eax
8010442d:	89 04 24             	mov    %eax,(%esp)
80104430:	e8 e0 0f 00 00       	call   80105415 <wakeup>
  release(&p->lock);
80104435:	8b 45 08             	mov    0x8(%ebp),%eax
80104438:	89 04 24             	mov    %eax,(%esp)
8010443b:	e8 41 12 00 00       	call   80105681 <release>
  return n;
80104440:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104443:	83 c4 24             	add    $0x24,%esp
80104446:	5b                   	pop    %ebx
80104447:	5d                   	pop    %ebp
80104448:	c3                   	ret    

80104449 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104449:	55                   	push   %ebp
8010444a:	89 e5                	mov    %esp,%ebp
8010444c:	53                   	push   %ebx
8010444d:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104450:	8b 45 08             	mov    0x8(%ebp),%eax
80104453:	89 04 24             	mov    %eax,(%esp)
80104456:	e8 c4 11 00 00       	call   8010561f <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010445b:	eb 3a                	jmp    80104497 <piperead+0x4e>
    if(proc->killed){
8010445d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104463:	8b 40 24             	mov    0x24(%eax),%eax
80104466:	85 c0                	test   %eax,%eax
80104468:	74 15                	je     8010447f <piperead+0x36>
      release(&p->lock);
8010446a:	8b 45 08             	mov    0x8(%ebp),%eax
8010446d:	89 04 24             	mov    %eax,(%esp)
80104470:	e8 0c 12 00 00       	call   80105681 <release>
      return -1;
80104475:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010447a:	e9 b5 00 00 00       	jmp    80104534 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010447f:	8b 45 08             	mov    0x8(%ebp),%eax
80104482:	8b 55 08             	mov    0x8(%ebp),%edx
80104485:	81 c2 34 02 00 00    	add    $0x234,%edx
8010448b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010448f:	89 14 24             	mov    %edx,(%esp)
80104492:	e8 a2 0e 00 00       	call   80105339 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104497:	8b 45 08             	mov    0x8(%ebp),%eax
8010449a:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801044a0:	8b 45 08             	mov    0x8(%ebp),%eax
801044a3:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801044a9:	39 c2                	cmp    %eax,%edx
801044ab:	75 0d                	jne    801044ba <piperead+0x71>
801044ad:	8b 45 08             	mov    0x8(%ebp),%eax
801044b0:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801044b6:	85 c0                	test   %eax,%eax
801044b8:	75 a3                	jne    8010445d <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801044ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801044c1:	eb 48                	jmp    8010450b <piperead+0xc2>
    if(p->nread == p->nwrite)
801044c3:	8b 45 08             	mov    0x8(%ebp),%eax
801044c6:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801044cc:	8b 45 08             	mov    0x8(%ebp),%eax
801044cf:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801044d5:	39 c2                	cmp    %eax,%edx
801044d7:	74 3c                	je     80104515 <piperead+0xcc>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801044d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801044df:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801044e2:	8b 45 08             	mov    0x8(%ebp),%eax
801044e5:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801044eb:	89 c3                	mov    %eax,%ebx
801044ed:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801044f3:	8b 55 08             	mov    0x8(%ebp),%edx
801044f6:	8a 54 1a 34          	mov    0x34(%edx,%ebx,1),%dl
801044fa:	88 11                	mov    %dl,(%ecx)
801044fc:	8d 50 01             	lea    0x1(%eax),%edx
801044ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104502:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104508:	ff 45 f4             	incl   -0xc(%ebp)
8010450b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010450e:	3b 45 10             	cmp    0x10(%ebp),%eax
80104511:	7c b0                	jl     801044c3 <piperead+0x7a>
80104513:	eb 01                	jmp    80104516 <piperead+0xcd>
    if(p->nread == p->nwrite)
      break;
80104515:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104516:	8b 45 08             	mov    0x8(%ebp),%eax
80104519:	05 38 02 00 00       	add    $0x238,%eax
8010451e:	89 04 24             	mov    %eax,(%esp)
80104521:	e8 ef 0e 00 00       	call   80105415 <wakeup>
  release(&p->lock);
80104526:	8b 45 08             	mov    0x8(%ebp),%eax
80104529:	89 04 24             	mov    %eax,(%esp)
8010452c:	e8 50 11 00 00       	call   80105681 <release>
  return i;
80104531:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104534:	83 c4 24             	add    $0x24,%esp
80104537:	5b                   	pop    %ebx
80104538:	5d                   	pop    %ebp
80104539:	c3                   	ret    
8010453a:	66 90                	xchg   %ax,%ax

8010453c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010453c:	55                   	push   %ebp
8010453d:	89 e5                	mov    %esp,%ebp
8010453f:	53                   	push   %ebx
80104540:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104543:	9c                   	pushf  
80104544:	5b                   	pop    %ebx
80104545:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104548:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010454b:	83 c4 10             	add    $0x10,%esp
8010454e:	5b                   	pop    %ebx
8010454f:	5d                   	pop    %ebp
80104550:	c3                   	ret    

80104551 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104551:	55                   	push   %ebp
80104552:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104554:	fb                   	sti    
}
80104555:	5d                   	pop    %ebp
80104556:	c3                   	ret    

80104557 <pinit>:
struct proc* getNextProcessFromQueue(pQueue *queue);


void
pinit(void)
{
80104557:	55                   	push   %ebp
80104558:	89 e5                	mov    %esp,%ebp
8010455a:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
8010455d:	c7 44 24 04 b9 8f 10 	movl   $0x80108fb9,0x4(%esp)
80104564:	80 
80104565:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
8010456c:	e8 8d 10 00 00       	call   801055fe <initlock>

  initQueue(&fifoQueue);
80104571:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80104578:	e8 26 00 00 00       	call   801045a3 <initQueue>
  initQueue(&priorityQueues.high);
8010457d:	c7 04 24 80 1f 11 80 	movl   $0x80111f80,(%esp)
80104584:	e8 1a 00 00 00       	call   801045a3 <initQueue>
  initQueue(&priorityQueues.medium);
80104589:	c7 04 24 c0 20 11 80 	movl   $0x801120c0,(%esp)
80104590:	e8 0e 00 00 00       	call   801045a3 <initQueue>
  initQueue(&priorityQueues.low);
80104595:	c7 04 24 00 22 11 80 	movl   $0x80112200,(%esp)
8010459c:	e8 02 00 00 00       	call   801045a3 <initQueue>
}
801045a1:	c9                   	leave  
801045a2:	c3                   	ret    

801045a3 <initQueue>:

void
initQueue(pQueue * queue)
{
801045a3:	55                   	push   %ebp
801045a4:	89 e5                	mov    %esp,%ebp
801045a6:	83 ec 28             	sub    $0x28,%esp
  initlock(&queue->lock, "pQueue");
801045a9:	8b 45 08             	mov    0x8(%ebp),%eax
801045ac:	c7 44 24 04 c0 8f 10 	movl   $0x80108fc0,0x4(%esp)
801045b3:	80 
801045b4:	89 04 24             	mov    %eax,(%esp)
801045b7:	e8 42 10 00 00       	call   801055fe <initlock>
  int i;
      for(i = 0 ; i < NPROC ; i++)
801045bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801045c3:	eb 14                	jmp    801045d9 <initQueue+0x36>
          queue->queue[i] = 0;
801045c5:	8b 45 08             	mov    0x8(%ebp),%eax
801045c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045cb:	83 c2 0c             	add    $0xc,%edx
801045ce:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
801045d5:	00 
void
initQueue(pQueue * queue)
{
  initlock(&queue->lock, "pQueue");
  int i;
      for(i = 0 ; i < NPROC ; i++)
801045d6:	ff 45 f4             	incl   -0xc(%ebp)
801045d9:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
801045dd:	7e e6                	jle    801045c5 <initQueue+0x22>
          queue->queue[i] = 0;

  queue->first = 0;
801045df:	8b 45 08             	mov    0x8(%ebp),%eax
801045e2:	c7 80 34 01 00 00 00 	movl   $0x0,0x134(%eax)
801045e9:	00 00 00 
  queue->next  = 0;
801045ec:	8b 45 08             	mov    0x8(%ebp),%eax
801045ef:	c7 80 38 01 00 00 00 	movl   $0x0,0x138(%eax)
801045f6:	00 00 00 
  queue->numOfProcs = 0;
801045f9:	8b 45 08             	mov    0x8(%ebp),%eax
801045fc:	c7 80 3c 01 00 00 00 	movl   $0x0,0x13c(%eax)
80104603:	00 00 00 
}
80104606:	c9                   	leave  
80104607:	c3                   	ret    

80104608 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104608:	55                   	push   %ebp
80104609:	89 e5                	mov    %esp,%ebp
8010460b:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010460e:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80104615:	e8 05 10 00 00       	call   8010561f <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010461a:	c7 45 f4 74 23 11 80 	movl   $0x80112374,-0xc(%ebp)
80104621:	eb 11                	jmp    80104634 <allocproc+0x2c>
    if(p->state == UNUSED)
80104623:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104626:	8b 40 0c             	mov    0xc(%eax),%eax
80104629:	85 c0                	test   %eax,%eax
8010462b:	74 26                	je     80104653 <allocproc+0x4b>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010462d:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104634:	81 7d f4 74 47 11 80 	cmpl   $0x80114774,-0xc(%ebp)
8010463b:	72 e6                	jb     80104623 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
8010463d:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80104644:	e8 38 10 00 00       	call   80105681 <release>
  return 0;
80104649:	b8 00 00 00 00       	mov    $0x0,%eax
8010464e:	e9 e6 00 00 00       	jmp    80104739 <allocproc+0x131>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104653:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state  = EMBRYO;
80104654:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104657:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid    = nextpid++;
8010465e:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104663:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104666:	89 42 10             	mov    %eax,0x10(%edx)
80104669:	40                   	inc    %eax
8010466a:	a3 04 c0 10 80       	mov    %eax,0x8010c004
  p->ctime  = ticks;
8010466f:	8b 15 c0 4f 11 80    	mov    0x80114fc0,%edx
80104675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104678:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->etime  = 0;
8010467b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104685:	00 00 00 
  p->iotime = 0;
80104688:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104692:	00 00 00 
  p->rtime = 0;
80104695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104698:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
8010469f:	00 00 00 

#ifdef SCHED_3Q
  p->priority = MEDIUM;
#endif

  release(&ptable.lock);
801046a2:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
801046a9:	e8 d3 0f 00 00       	call   80105681 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0)
801046ae:	e8 68 e9 ff ff       	call   8010301b <kalloc>
801046b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046b6:	89 42 08             	mov    %eax,0x8(%edx)
801046b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046bc:	8b 40 08             	mov    0x8(%eax),%eax
801046bf:	85 c0                	test   %eax,%eax
801046c1:	75 11                	jne    801046d4 <allocproc+0xcc>
  {
    p->state = UNUSED;
801046c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801046cd:	b8 00 00 00 00       	mov    $0x0,%eax
801046d2:	eb 65                	jmp    80104739 <allocproc+0x131>
  }
  sp = p->kstack + KSTACKSIZE;
801046d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d7:	8b 40 08             	mov    0x8(%eax),%eax
801046da:	05 00 10 00 00       	add    $0x1000,%eax
801046df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801046e2:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801046e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046ec:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801046ef:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801046f3:	ba 90 6d 10 80       	mov    $0x80106d90,%edx
801046f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046fb:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801046fd:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104704:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104707:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010470a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010470d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104710:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104717:	00 
80104718:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010471f:	00 
80104720:	89 04 24             	mov    %eax,(%esp)
80104723:	e8 4a 11 00 00       	call   80105872 <memset>
  p->context->eip = (uint)forkret;
80104728:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010472b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010472e:	ba 0d 53 10 80       	mov    $0x8010530d,%edx
80104733:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104736:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104739:	c9                   	leave  
8010473a:	c3                   	ret    

8010473b <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010473b:	55                   	push   %ebp
8010473c:	89 e5                	mov    %esp,%ebp
8010473e:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104741:	e8 c2 fe ff ff       	call   80104608 <allocproc>
80104746:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474c:	a3 a0 c7 10 80       	mov    %eax,0x8010c7a0
  if((p->pgdir = setupkvm(kalloc)) == 0)
80104751:	c7 04 24 1b 30 10 80 	movl   $0x8010301b,(%esp)
80104758:	e8 43 3d 00 00       	call   801084a0 <setupkvm>
8010475d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104760:	89 42 04             	mov    %eax,0x4(%edx)
80104763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104766:	8b 40 04             	mov    0x4(%eax),%eax
80104769:	85 c0                	test   %eax,%eax
8010476b:	75 0c                	jne    80104779 <userinit+0x3e>
    panic("userinit: out of memory?");
8010476d:	c7 04 24 c7 8f 10 80 	movl   $0x80108fc7,(%esp)
80104774:	e8 bd bd ff ff       	call   80100536 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104779:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010477e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104781:	8b 40 04             	mov    0x4(%eax),%eax
80104784:	89 54 24 08          	mov    %edx,0x8(%esp)
80104788:	c7 44 24 04 e0 c4 10 	movl   $0x8010c4e0,0x4(%esp)
8010478f:	80 
80104790:	89 04 24             	mov    %eax,(%esp)
80104793:	e8 54 3f 00 00       	call   801086ec <inituvm>
  p->sz = PGSIZE;
80104798:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010479b:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801047a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a4:	8b 40 18             	mov    0x18(%eax),%eax
801047a7:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801047ae:	00 
801047af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801047b6:	00 
801047b7:	89 04 24             	mov    %eax,(%esp)
801047ba:	e8 b3 10 00 00       	call   80105872 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801047bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c2:	8b 40 18             	mov    0x18(%eax),%eax
801047c5:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801047cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ce:	8b 40 18             	mov    0x18(%eax),%eax
801047d1:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801047d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047da:	8b 50 18             	mov    0x18(%eax),%edx
801047dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e0:	8b 40 18             	mov    0x18(%eax),%eax
801047e3:	8b 40 2c             	mov    0x2c(%eax),%eax
801047e6:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
801047ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ed:	8b 50 18             	mov    0x18(%eax),%edx
801047f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f3:	8b 40 18             	mov    0x18(%eax),%eax
801047f6:	8b 40 2c             	mov    0x2c(%eax),%eax
801047f9:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
801047fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104800:	8b 40 18             	mov    0x18(%eax),%eax
80104803:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010480a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480d:	8b 40 18             	mov    0x18(%eax),%eax
80104810:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104817:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481a:	8b 40 18             	mov    0x18(%eax),%eax
8010481d:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104824:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104827:	83 c0 6c             	add    $0x6c,%eax
8010482a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104831:	00 
80104832:	c7 44 24 04 e0 8f 10 	movl   $0x80108fe0,0x4(%esp)
80104839:	80 
8010483a:	89 04 24             	mov    %eax,(%esp)
8010483d:	e8 42 12 00 00       	call   80105a84 <safestrcpy>
  p->cwd = namei("/");
80104842:	c7 04 24 e9 8f 10 80 	movl   $0x80108fe9,(%esp)
80104849:	e8 ea e0 ff ff       	call   80102938 <namei>
8010484e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104851:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
80104854:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104857:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  #ifdef SCHED_3Q
    // initproc console precedure is with low priority
    addProcessToQueue(&priorityQueues.low, p);
  #endif
}
8010485e:	c9                   	leave  
8010485f:	c3                   	ret    

80104860 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
80104866:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010486c:	8b 00                	mov    (%eax),%eax
8010486e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104871:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104875:	7e 34                	jle    801048ab <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104877:	8b 55 08             	mov    0x8(%ebp),%edx
8010487a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010487d:	01 c2                	add    %eax,%edx
8010487f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104885:	8b 40 04             	mov    0x4(%eax),%eax
80104888:	89 54 24 08          	mov    %edx,0x8(%esp)
8010488c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010488f:	89 54 24 04          	mov    %edx,0x4(%esp)
80104893:	89 04 24             	mov    %eax,(%esp)
80104896:	e8 cb 3f 00 00       	call   80108866 <allocuvm>
8010489b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010489e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801048a2:	75 41                	jne    801048e5 <growproc+0x85>
      return -1;
801048a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048a9:	eb 58                	jmp    80104903 <growproc+0xa3>
  } else if(n < 0){
801048ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801048af:	79 34                	jns    801048e5 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801048b1:	8b 55 08             	mov    0x8(%ebp),%edx
801048b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b7:	01 c2                	add    %eax,%edx
801048b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048bf:	8b 40 04             	mov    0x4(%eax),%eax
801048c2:	89 54 24 08          	mov    %edx,0x8(%esp)
801048c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048c9:	89 54 24 04          	mov    %edx,0x4(%esp)
801048cd:	89 04 24             	mov    %eax,(%esp)
801048d0:	e8 6b 40 00 00       	call   80108940 <deallocuvm>
801048d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801048d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801048dc:	75 07                	jne    801048e5 <growproc+0x85>
      return -1;
801048de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048e3:	eb 1e                	jmp    80104903 <growproc+0xa3>
  }
  proc->sz = sz;
801048e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048ee:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801048f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048f6:	89 04 24             	mov    %eax,(%esp)
801048f9:	e8 93 3c 00 00       	call   80108591 <switchuvm>
  return 0;
801048fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104903:	c9                   	leave  
80104904:	c3                   	ret    

80104905 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104905:	55                   	push   %ebp
80104906:	89 e5                	mov    %esp,%ebp
80104908:	57                   	push   %edi
80104909:	56                   	push   %esi
8010490a:	53                   	push   %ebx
8010490b:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010490e:	e8 f5 fc ff ff       	call   80104608 <allocproc>
80104913:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104916:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010491a:	75 0a                	jne    80104926 <fork+0x21>
    return -1;
8010491c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104921:	e9 39 01 00 00       	jmp    80104a5f <fork+0x15a>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104926:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010492c:	8b 10                	mov    (%eax),%edx
8010492e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104934:	8b 40 04             	mov    0x4(%eax),%eax
80104937:	89 54 24 04          	mov    %edx,0x4(%esp)
8010493b:	89 04 24             	mov    %eax,(%esp)
8010493e:	e8 98 41 00 00       	call   80108adb <copyuvm>
80104943:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104946:	89 42 04             	mov    %eax,0x4(%edx)
80104949:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010494c:	8b 40 04             	mov    0x4(%eax),%eax
8010494f:	85 c0                	test   %eax,%eax
80104951:	75 2c                	jne    8010497f <fork+0x7a>
    kfree(np->kstack);
80104953:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104956:	8b 40 08             	mov    0x8(%eax),%eax
80104959:	89 04 24             	mov    %eax,(%esp)
8010495c:	e8 21 e6 ff ff       	call   80102f82 <kfree>
    np->kstack = 0;
80104961:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104964:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010496b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010496e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104975:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010497a:	e9 e0 00 00 00       	jmp    80104a5f <fork+0x15a>
  }
  np->sz = proc->sz;
8010497f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104985:	8b 10                	mov    (%eax),%edx
80104987:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010498a:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010498c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104993:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104996:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104999:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010499c:	8b 50 18             	mov    0x18(%eax),%edx
8010499f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a5:	8b 40 18             	mov    0x18(%eax),%eax
801049a8:	89 c3                	mov    %eax,%ebx
801049aa:	b8 13 00 00 00       	mov    $0x13,%eax
801049af:	89 d7                	mov    %edx,%edi
801049b1:	89 de                	mov    %ebx,%esi
801049b3:	89 c1                	mov    %eax,%ecx
801049b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801049b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ba:	8b 40 18             	mov    0x18(%eax),%eax
801049bd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801049c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801049cb:	eb 3c                	jmp    80104a09 <fork+0x104>
    if(proc->ofile[i])
801049cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801049d6:	83 c2 08             	add    $0x8,%edx
801049d9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801049dd:	85 c0                	test   %eax,%eax
801049df:	74 25                	je     80104a06 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
801049e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801049ea:	83 c2 08             	add    $0x8,%edx
801049ed:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801049f1:	89 04 24             	mov    %eax,(%esp)
801049f4:	e8 d7 ca ff ff       	call   801014d0 <filedup>
801049f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
801049fc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801049ff:	83 c1 08             	add    $0x8,%ecx
80104a02:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104a06:	ff 45 e4             	incl   -0x1c(%ebp)
80104a09:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104a0d:	7e be                	jle    801049cd <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104a0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a15:	8b 40 68             	mov    0x68(%eax),%eax
80104a18:	89 04 24             	mov    %eax,(%esp)
80104a1b:	e8 4c d3 ff ff       	call   80101d6c <idup>
80104a20:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104a23:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
80104a26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a29:	8b 40 10             	mov    0x10(%eax),%eax
80104a2c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
80104a2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a32:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef SCHED_3Q
    // all new proc's priority is MEDIUM by default
    addProcessToQueue(&priorityQueues.medium, np);
  #endif

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104a39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a3f:	8d 50 6c             	lea    0x6c(%eax),%edx
80104a42:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a45:	83 c0 6c             	add    $0x6c,%eax
80104a48:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104a4f:	00 
80104a50:	89 54 24 04          	mov    %edx,0x4(%esp)
80104a54:	89 04 24             	mov    %eax,(%esp)
80104a57:	e8 28 10 00 00       	call   80105a84 <safestrcpy>
  return pid;
80104a5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104a5f:	83 c4 2c             	add    $0x2c,%esp
80104a62:	5b                   	pop    %ebx
80104a63:	5e                   	pop    %esi
80104a64:	5f                   	pop    %edi
80104a65:	5d                   	pop    %ebp
80104a66:	c3                   	ret    

80104a67 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104a67:	55                   	push   %ebp
80104a68:	89 e5                	mov    %esp,%ebp
80104a6a:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104a6d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a74:	a1 a0 c7 10 80       	mov    0x8010c7a0,%eax
80104a79:	39 c2                	cmp    %eax,%edx
80104a7b:	75 0c                	jne    80104a89 <exit+0x22>
    panic("init exiting");
80104a7d:	c7 04 24 eb 8f 10 80 	movl   $0x80108feb,(%esp)
80104a84:	e8 ad ba ff ff       	call   80100536 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104a90:	eb 43                	jmp    80104ad5 <exit+0x6e>
    if(proc->ofile[fd]){
80104a92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a98:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a9b:	83 c2 08             	add    $0x8,%edx
80104a9e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104aa2:	85 c0                	test   %eax,%eax
80104aa4:	74 2c                	je     80104ad2 <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104aa6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aac:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104aaf:	83 c2 08             	add    $0x8,%edx
80104ab2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ab6:	89 04 24             	mov    %eax,(%esp)
80104ab9:	e8 5a ca ff ff       	call   80101518 <fileclose>
      proc->ofile[fd] = 0;
80104abe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ac4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ac7:	83 c2 08             	add    $0x8,%edx
80104aca:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104ad1:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104ad2:	ff 45 f0             	incl   -0x10(%ebp)
80104ad5:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104ad9:	7e b7                	jle    80104a92 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
80104adb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae1:	8b 40 68             	mov    0x68(%eax),%eax
80104ae4:	89 04 24             	mov    %eax,(%esp)
80104ae7:	e8 62 d4 ff ff       	call   80101f4e <iput>
  proc->cwd = 0;
80104aec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af2:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104af9:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80104b00:	e8 1a 0b 00 00       	call   8010561f <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104b05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b0b:	8b 40 14             	mov    0x14(%eax),%eax
80104b0e:	89 04 24             	mov    %eax,(%esp)
80104b11:	e8 be 08 00 00       	call   801053d4 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b16:	c7 45 f4 74 23 11 80 	movl   $0x80112374,-0xc(%ebp)
80104b1d:	eb 3b                	jmp    80104b5a <exit+0xf3>
    if(p->parent == proc){
80104b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b22:	8b 50 14             	mov    0x14(%eax),%edx
80104b25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b2b:	39 c2                	cmp    %eax,%edx
80104b2d:	75 24                	jne    80104b53 <exit+0xec>
      p->parent = initproc;
80104b2f:	8b 15 a0 c7 10 80    	mov    0x8010c7a0,%edx
80104b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b38:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b3e:	8b 40 0c             	mov    0xc(%eax),%eax
80104b41:	83 f8 05             	cmp    $0x5,%eax
80104b44:	75 0d                	jne    80104b53 <exit+0xec>
        wakeup1(initproc);
80104b46:	a1 a0 c7 10 80       	mov    0x8010c7a0,%eax
80104b4b:	89 04 24             	mov    %eax,(%esp)
80104b4e:	e8 81 08 00 00       	call   801053d4 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b53:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104b5a:	81 7d f4 74 47 11 80 	cmpl   $0x80114774,-0xc(%ebp)
80104b61:	72 bc                	jb     80104b1f <exit+0xb8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->etime = ticks;
80104b63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b69:	8b 15 c0 4f 11 80    	mov    0x80114fc0,%edx
80104b6f:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  proc->state = ZOMBIE;
80104b75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b7b:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    cprintf("(%d) %p\n",i, fifoQueue.queue[i]);
  }
  cprintf("the first: %d\n",fifoQueue.first);
  cprintf("the next: %d\n",fifoQueue.next);
  cprintf("proc name: %s\n",fifoQueue.queue[fifoQueue.first]->name);*/
  sched();
80104b82:	e8 a2 06 00 00       	call   80105229 <sched>
  panic("I hate when zombie exit");
80104b87:	c7 04 24 f8 8f 10 80 	movl   $0x80108ff8,(%esp)
80104b8e:	e8 a3 b9 ff ff       	call   80100536 <panic>

80104b93 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104b93:	55                   	push   %ebp
80104b94:	89 e5                	mov    %esp,%ebp
80104b96:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104b99:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80104ba0:	e8 7a 0a 00 00       	call   8010561f <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104ba5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bac:	c7 45 f4 74 23 11 80 	movl   $0x80112374,-0xc(%ebp)
80104bb3:	e9 9d 00 00 00       	jmp    80104c55 <wait+0xc2>
      if(p->parent != proc)
80104bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbb:	8b 50 14             	mov    0x14(%eax),%edx
80104bbe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bc4:	39 c2                	cmp    %eax,%edx
80104bc6:	0f 85 81 00 00 00    	jne    80104c4d <wait+0xba>
        continue;
      havekids = 1;
80104bcc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd6:	8b 40 0c             	mov    0xc(%eax),%eax
80104bd9:	83 f8 05             	cmp    $0x5,%eax
80104bdc:	75 70                	jne    80104c4e <wait+0xbb>
        // Found one.
        pid = p->pid;
80104bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be1:	8b 40 10             	mov    0x10(%eax),%eax
80104be4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bea:	8b 40 08             	mov    0x8(%eax),%eax
80104bed:	89 04 24             	mov    %eax,(%esp)
80104bf0:	e8 8d e3 ff ff       	call   80102f82 <kfree>
        p->kstack = 0;
80104bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bf8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c02:	8b 40 04             	mov    0x4(%eax),%eax
80104c05:	89 04 24             	mov    %eax,(%esp)
80104c08:	e8 ef 3d 00 00       	call   801089fc <freevm>
        p->state = UNUSED;
80104c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c10:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c1a:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c24:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c2e:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c35:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104c3c:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80104c43:	e8 39 0a 00 00       	call   80105681 <release>
        return pid;
80104c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c4b:	eb 56                	jmp    80104ca3 <wait+0x110>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104c4d:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c4e:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104c55:	81 7d f4 74 47 11 80 	cmpl   $0x80114774,-0xc(%ebp)
80104c5c:	0f 82 56 ff ff ff    	jb     80104bb8 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104c62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c66:	74 0d                	je     80104c75 <wait+0xe2>
80104c68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c6e:	8b 40 24             	mov    0x24(%eax),%eax
80104c71:	85 c0                	test   %eax,%eax
80104c73:	74 13                	je     80104c88 <wait+0xf5>
      release(&ptable.lock);
80104c75:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80104c7c:	e8 00 0a 00 00       	call   80105681 <release>
      return -1;
80104c81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c86:	eb 1b                	jmp    80104ca3 <wait+0x110>
    }
    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104c88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c8e:	c7 44 24 04 40 23 11 	movl   $0x80112340,0x4(%esp)
80104c95:	80 
80104c96:	89 04 24             	mov    %eax,(%esp)
80104c99:	e8 9b 06 00 00       	call   80105339 <sleep>
  }
80104c9e:	e9 02 ff ff ff       	jmp    80104ba5 <wait+0x12>
}
80104ca3:	c9                   	leave  
80104ca4:	c3                   	ret    

80104ca5 <updateAllSleepingProcesses>:

void updateAllSleepingProcesses(void)
{
80104ca5:	55                   	push   %ebp
80104ca6:	89 e5                	mov    %esp,%ebp
80104ca8:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cab:	c7 45 fc 74 23 11 80 	movl   $0x80112374,-0x4(%ebp)
80104cb2:	eb 27                	jmp    80104cdb <updateAllSleepingProcesses+0x36>
    if(p->state == SLEEPING)
80104cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cb7:	8b 40 0c             	mov    0xc(%eax),%eax
80104cba:	83 f8 02             	cmp    $0x2,%eax
80104cbd:	75 15                	jne    80104cd4 <updateAllSleepingProcesses+0x2f>
      p->iotime++;
80104cbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cc2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104cc8:	8d 50 01             	lea    0x1(%eax),%edx
80104ccb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cce:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

void updateAllSleepingProcesses(void)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cd4:	81 45 fc 90 00 00 00 	addl   $0x90,-0x4(%ebp)
80104cdb:	81 7d fc 74 47 11 80 	cmpl   $0x80114774,-0x4(%ebp)
80104ce2:	72 d0                	jb     80104cb4 <updateAllSleepingProcesses+0xf>
    if(p->state == SLEEPING)
      p->iotime++;
}
80104ce4:	c9                   	leave  
80104ce5:	c3                   	ret    

80104ce6 <wait2>:

int
wait2(int *wtime, int *rtime, int *iotime)
{
80104ce6:	55                   	push   %ebp
80104ce7:	89 e5                	mov    %esp,%ebp
80104ce9:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104cec:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80104cf3:	e8 27 09 00 00       	call   8010561f <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104cf8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cff:	c7 45 f4 74 23 11 80 	movl   $0x80112374,-0xc(%ebp)
80104d06:	e9 ef 00 00 00       	jmp    80104dfa <wait2+0x114>
      if(p->parent != proc)
80104d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d0e:	8b 50 14             	mov    0x14(%eax),%edx
80104d11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d17:	39 c2                	cmp    %eax,%edx
80104d19:	0f 85 d3 00 00 00    	jne    80104df2 <wait2+0x10c>
        continue;
      havekids = 1;
80104d1f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d29:	8b 40 0c             	mov    0xc(%eax),%eax
80104d2c:	83 f8 05             	cmp    $0x5,%eax
80104d2f:	0f 85 be 00 00 00    	jne    80104df3 <wait2+0x10d>
        // Found one.
        pid = p->pid;
80104d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d38:	8b 40 10             	mov    0x10(%eax),%eax
80104d3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d41:	8b 40 08             	mov    0x8(%eax),%eax
80104d44:	89 04 24             	mov    %eax,(%esp)
80104d47:	e8 36 e2 ff ff       	call   80102f82 <kfree>
        p->kstack = 0;
80104d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d4f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d59:	8b 40 04             	mov    0x4(%eax),%eax
80104d5c:	89 04 24             	mov    %eax,(%esp)
80104d5f:	e8 98 3c 00 00       	call   801089fc <freevm>
        p->state = UNUSED;
80104d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d67:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d71:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d7b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d85:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d8c:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        *wtime = p->etime - p->ctime - p->rtime - p->iotime;
80104d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d96:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d9f:	8b 40 7c             	mov    0x7c(%eax),%eax
80104da2:	29 c2                	sub    %eax,%edx
80104da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da7:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104dad:	29 c2                	sub    %eax,%edx
80104daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104db8:	89 d1                	mov    %edx,%ecx
80104dba:	29 c1                	sub    %eax,%ecx
80104dbc:	89 c8                	mov    %ecx,%eax
80104dbe:	89 c2                	mov    %eax,%edx
80104dc0:	8b 45 08             	mov    0x8(%ebp),%eax
80104dc3:	89 10                	mov    %edx,(%eax)
        *rtime = p->rtime;
80104dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc8:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80104dce:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dd1:	89 10                	mov    %edx,(%eax)
        *iotime = p->iotime;
80104dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104ddc:	8b 45 10             	mov    0x10(%ebp),%eax
80104ddf:	89 10                	mov    %edx,(%eax)
        release(&ptable.lock);
80104de1:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80104de8:	e8 94 08 00 00       	call   80105681 <release>
        return pid;
80104ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104df0:	eb 56                	jmp    80104e48 <wait2+0x162>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104df2:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104df3:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104dfa:	81 7d f4 74 47 11 80 	cmpl   $0x80114774,-0xc(%ebp)
80104e01:	0f 82 04 ff ff ff    	jb     80104d0b <wait2+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104e07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104e0b:	74 0d                	je     80104e1a <wait2+0x134>
80104e0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e13:	8b 40 24             	mov    0x24(%eax),%eax
80104e16:	85 c0                	test   %eax,%eax
80104e18:	74 13                	je     80104e2d <wait2+0x147>
      release(&ptable.lock);
80104e1a:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80104e21:	e8 5b 08 00 00       	call   80105681 <release>
      return -1;
80104e26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e2b:	eb 1b                	jmp    80104e48 <wait2+0x162>
    }
    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104e2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e33:	c7 44 24 04 40 23 11 	movl   $0x80112340,0x4(%esp)
80104e3a:	80 
80104e3b:	89 04 24             	mov    %eax,(%esp)
80104e3e:	e8 f6 04 00 00       	call   80105339 <sleep>
  }
80104e43:	e9 b0 fe ff ff       	jmp    80104cf8 <wait2+0x12>
}
80104e48:	c9                   	leave  
80104e49:	c3                   	ret    

80104e4a <register_handler>:

void
register_handler(sighandler_t sighandler)
{
80104e4a:	55                   	push   %ebp
80104e4b:	89 e5                	mov    %esp,%ebp
80104e4d:	83 ec 28             	sub    $0x28,%esp
  char* addr = uva2ka(proc->pgdir, (char*)proc->tf->esp);
80104e50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e56:	8b 40 18             	mov    0x18(%eax),%eax
80104e59:	8b 40 44             	mov    0x44(%eax),%eax
80104e5c:	89 c2                	mov    %eax,%edx
80104e5e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e64:	8b 40 04             	mov    0x4(%eax),%eax
80104e67:	89 54 24 04          	mov    %edx,0x4(%esp)
80104e6b:	89 04 24             	mov    %eax,(%esp)
80104e6e:	e8 79 3d 00 00       	call   80108bec <uva2ka>
80104e73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if ((proc->tf->esp & 0xFFF) == 0)
80104e76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e7c:	8b 40 18             	mov    0x18(%eax),%eax
80104e7f:	8b 40 44             	mov    0x44(%eax),%eax
80104e82:	25 ff 0f 00 00       	and    $0xfff,%eax
80104e87:	85 c0                	test   %eax,%eax
80104e89:	75 0c                	jne    80104e97 <register_handler+0x4d>
    panic("esp_offset == 0");
80104e8b:	c7 04 24 10 90 10 80 	movl   $0x80109010,(%esp)
80104e92:	e8 9f b6 ff ff       	call   80100536 <panic>

    /* open a new frame */
  *(int*)(addr + ((proc->tf->esp - 4) & 0xFFF))
80104e97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e9d:	8b 40 18             	mov    0x18(%eax),%eax
80104ea0:	8b 40 44             	mov    0x44(%eax),%eax
80104ea3:	83 e8 04             	sub    $0x4,%eax
80104ea6:	89 c2                	mov    %eax,%edx
80104ea8:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80104eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb1:	01 c2                	add    %eax,%edx
          = proc->tf->eip;
80104eb3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eb9:	8b 40 18             	mov    0x18(%eax),%eax
80104ebc:	8b 40 38             	mov    0x38(%eax),%eax
80104ebf:	89 02                	mov    %eax,(%edx)
  proc->tf->esp -= 4;
80104ec1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ec7:	8b 40 18             	mov    0x18(%eax),%eax
80104eca:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ed1:	8b 52 18             	mov    0x18(%edx),%edx
80104ed4:	8b 52 44             	mov    0x44(%edx),%edx
80104ed7:	83 ea 04             	sub    $0x4,%edx
80104eda:	89 50 44             	mov    %edx,0x44(%eax)

    /* update eip */
  proc->tf->eip = (uint)sighandler;
80104edd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ee3:	8b 40 18             	mov    0x18(%eax),%eax
80104ee6:	8b 55 08             	mov    0x8(%ebp),%edx
80104ee9:	89 50 38             	mov    %edx,0x38(%eax)
}
80104eec:	c9                   	leave  
80104eed:	c3                   	ret    

80104eee <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104eee:	55                   	push   %ebp
80104eef:	89 e5                	mov    %esp,%ebp
80104ef1:	83 ec 08             	sub    $0x8,%esp
  for(;;)
  {
    #ifdef SCHED_DEFAULT
        schedulingDEFAULT();
80104ef4:	e8 4c 00 00 00       	call   80104f45 <schedulingDEFAULT>
    #endif /* FIFO */

    #ifdef SCHED_3Q
        scheduling3Q();
    #endif
  }
80104ef9:	eb f9                	jmp    80104ef4 <scheduler+0x6>

80104efb <runProc>:
}

void
runProc(struct proc *p)
{
80104efb:	55                   	push   %ebp
80104efc:	89 e5                	mov    %esp,%ebp
80104efe:	83 ec 18             	sub    $0x18,%esp
    // Switch to chosen process.  It is the process's job
    // to release ptable.lock and then reacquire it
    // before jumping back to us.
    proc = p;
80104f01:	8b 45 08             	mov    0x8(%ebp),%eax
80104f04:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
    switchuvm(p);
80104f0a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f0d:	89 04 24             	mov    %eax,(%esp)
80104f10:	e8 7c 36 00 00       	call   80108591 <switchuvm>
    p->state = RUNNING;
80104f15:	8b 45 08             	mov    0x8(%ebp),%eax
80104f18:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
    swtch(&cpu->scheduler, proc->context);
80104f1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f25:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f28:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104f2f:	83 c2 04             	add    $0x4,%edx
80104f32:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f36:	89 14 24             	mov    %edx,(%esp)
80104f39:	e8 06 0c 00 00       	call   80105b44 <swtch>
    switchkvm();
80104f3e:	e8 31 36 00 00       	call   80108574 <switchkvm>
}
80104f43:	c9                   	leave  
80104f44:	c3                   	ret    

80104f45 <schedulingDEFAULT>:

void
schedulingDEFAULT()
{
80104f45:	55                   	push   %ebp
80104f46:	89 e5                	mov    %esp,%ebp
80104f48:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    // Enable interrupts on this processor.
    sti();
80104f4b:	e8 01 f6 ff ff       	call   80104551 <sti>
    acquire(&ptable.lock);
80104f50:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80104f57:	e8 c3 06 00 00       	call   8010561f <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f5c:	c7 45 f4 74 23 11 80 	movl   $0x80112374,-0xc(%ebp)
80104f63:	eb 2b                	jmp    80104f90 <schedulingDEFAULT+0x4b>
      if(p->state != RUNNABLE)
80104f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f68:	8b 40 0c             	mov    0xc(%eax),%eax
80104f6b:	83 f8 03             	cmp    $0x3,%eax
80104f6e:	75 18                	jne    80104f88 <schedulingDEFAULT+0x43>
        continue;

      runProc(p);
80104f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f73:	89 04 24             	mov    %eax,(%esp)
80104f76:	e8 80 ff ff ff       	call   80104efb <runProc>

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        proc = 0;
80104f7b:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104f82:	00 00 00 00 
80104f86:	eb 01                	jmp    80104f89 <schedulingDEFAULT+0x44>
    // Enable interrupts on this processor.
    sti();
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104f88:	90                   	nop
{
    struct proc *p;
    // Enable interrupts on this processor.
    sti();
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f89:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104f90:	81 7d f4 74 47 11 80 	cmpl   $0x80114774,-0xc(%ebp)
80104f97:	72 cc                	jb     80104f65 <schedulingDEFAULT+0x20>

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        proc = 0;
    }
    release(&ptable.lock);
80104f99:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80104fa0:	e8 dc 06 00 00       	call   80105681 <release>
}
80104fa5:	c9                   	leave  
80104fa6:	c3                   	ret    

80104fa7 <schedulingFIFO>:

void
schedulingFIFO()
{
80104fa7:	55                   	push   %ebp
80104fa8:	89 e5                	mov    %esp,%ebp
80104faa:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;

    sti(); // need to know!
80104fad:	e8 9f f5 ff ff       	call   80104551 <sti>

    acquire(&ptable.lock);
80104fb2:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80104fb9:	e8 61 06 00 00       	call   8010561f <acquire>

    p = getNextProcessFromQueue(&fifoQueue);
80104fbe:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80104fc5:	e8 a8 01 00 00       	call   80105172 <getNextProcessFromQueue>
80104fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == 0)
80104fcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104fd1:	75 0e                	jne    80104fe1 <schedulingFIFO+0x3a>
    {
        release(&ptable.lock);
80104fd3:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80104fda:	e8 a2 06 00 00       	call   80105681 <release>
        return;
80104fdf:	eb 22                	jmp    80105003 <schedulingFIFO+0x5c>
    }

    runProc(p);
80104fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe4:	89 04 24             	mov    %eax,(%esp)
80104fe7:	e8 0f ff ff ff       	call   80104efb <runProc>

    // Process is done running for now.
    // It should have changed its p->state before coming back.
    proc = 0;
80104fec:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104ff3:	00 00 00 00 
    release(&ptable.lock);
80104ff7:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80104ffe:	e8 7e 06 00 00       	call   80105681 <release>
}
80105003:	c9                   	leave  
80105004:	c3                   	ret    

80105005 <scheduling3Q>:

void
scheduling3Q()
{
80105005:	55                   	push   %ebp
80105006:	89 e5                	mov    %esp,%ebp
80105008:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;

    pQueue *queue;

    sti(); // need to know!
8010500b:	e8 41 f5 ff ff       	call   80104551 <sti>

    acquire(&ptable.lock);
80105010:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80105017:	e8 03 06 00 00       	call   8010561f <acquire>

    if(priorityQueues.high.numOfProcs)
8010501c:	a1 bc 20 11 80       	mov    0x801120bc,%eax
80105021:	85 c0                	test   %eax,%eax
80105023:	74 09                	je     8010502e <scheduling3Q+0x29>
        queue = &priorityQueues.high;
80105025:	c7 45 f4 80 1f 11 80 	movl   $0x80111f80,-0xc(%ebp)
8010502c:	eb 19                	jmp    80105047 <scheduling3Q+0x42>
    else if(priorityQueues.medium.numOfProcs)
8010502e:	a1 fc 21 11 80       	mov    0x801121fc,%eax
80105033:	85 c0                	test   %eax,%eax
80105035:	74 09                	je     80105040 <scheduling3Q+0x3b>
        queue = &priorityQueues.medium;
80105037:	c7 45 f4 c0 20 11 80 	movl   $0x801120c0,-0xc(%ebp)
8010503e:	eb 07                	jmp    80105047 <scheduling3Q+0x42>
    else
        queue = &priorityQueues.low;
80105040:	c7 45 f4 00 22 11 80 	movl   $0x80112200,-0xc(%ebp)

    p = getNextProcessFromQueue(queue);
80105047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010504a:	89 04 24             	mov    %eax,(%esp)
8010504d:	e8 20 01 00 00       	call   80105172 <getNextProcessFromQueue>
80105052:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (p == 0)
80105055:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105059:	75 0e                	jne    80105069 <scheduling3Q+0x64>
    {
        release(&ptable.lock);
8010505b:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80105062:	e8 1a 06 00 00       	call   80105681 <release>
        return;
80105067:	eb 22                	jmp    8010508b <scheduling3Q+0x86>
    }

    runProc(p);
80105069:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010506c:	89 04 24             	mov    %eax,(%esp)
8010506f:	e8 87 fe ff ff       	call   80104efb <runProc>

    // Process is done running for now.
    // It should have changed its p->state before coming back.
    proc = 0;
80105074:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010507b:	00 00 00 00 

    release(&ptable.lock);
8010507f:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80105086:	e8 f6 05 00 00       	call   80105681 <release>
}
8010508b:	c9                   	leave  
8010508c:	c3                   	ret    

8010508d <addProcessToQueue>:

void addProcessToQueue(pQueue *queue, struct proc *proc)
{
8010508d:	55                   	push   %ebp
8010508e:	89 e5                	mov    %esp,%ebp
80105090:	83 ec 18             	sub    $0x18,%esp
    acquire(&queue->lock);
80105093:	8b 45 08             	mov    0x8(%ebp),%eax
80105096:	89 04 24             	mov    %eax,(%esp)
80105099:	e8 81 05 00 00       	call   8010561f <acquire>

    // process array is empty (full can't be)
    if (queue->first ==  queue->next)
8010509e:	8b 45 08             	mov    0x8(%ebp),%eax
801050a1:	8b 90 34 01 00 00    	mov    0x134(%eax),%edx
801050a7:	8b 45 08             	mov    0x8(%ebp),%eax
801050aa:	8b 80 38 01 00 00    	mov    0x138(%eax),%eax
801050b0:	39 c2                	cmp    %eax,%edx
801050b2:	75 4f                	jne    80105103 <addProcessToQueue+0x76>
    {
        queue->queue[queue->first] = proc;
801050b4:	8b 45 08             	mov    0x8(%ebp),%eax
801050b7:	8b 90 34 01 00 00    	mov    0x134(%eax),%edx
801050bd:	8b 45 08             	mov    0x8(%ebp),%eax
801050c0:	8d 4a 0c             	lea    0xc(%edx),%ecx
801050c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801050c6:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
        queue->next++;
801050ca:	8b 45 08             	mov    0x8(%ebp),%eax
801050cd:	8b 80 38 01 00 00    	mov    0x138(%eax),%eax
801050d3:	8d 50 01             	lea    0x1(%eax),%edx
801050d6:	8b 45 08             	mov    0x8(%ebp),%eax
801050d9:	89 90 38 01 00 00    	mov    %edx,0x138(%eax)
        queue->next = queue->next % NPROC;
801050df:	8b 45 08             	mov    0x8(%ebp),%eax
801050e2:	8b 80 38 01 00 00    	mov    0x138(%eax),%eax
801050e8:	25 3f 00 00 80       	and    $0x8000003f,%eax
801050ed:	85 c0                	test   %eax,%eax
801050ef:	79 05                	jns    801050f6 <addProcessToQueue+0x69>
801050f1:	48                   	dec    %eax
801050f2:	83 c8 c0             	or     $0xffffffc0,%eax
801050f5:	40                   	inc    %eax
801050f6:	89 c2                	mov    %eax,%edx
801050f8:	8b 45 08             	mov    0x8(%ebp),%eax
801050fb:	89 90 38 01 00 00    	mov    %edx,0x138(%eax)
80105101:	eb 4d                	jmp    80105150 <addProcessToQueue+0xc3>
    }
    else
    {
        queue->queue[queue->next] = proc;
80105103:	8b 45 08             	mov    0x8(%ebp),%eax
80105106:	8b 90 38 01 00 00    	mov    0x138(%eax),%edx
8010510c:	8b 45 08             	mov    0x8(%ebp),%eax
8010510f:	8d 4a 0c             	lea    0xc(%edx),%ecx
80105112:	8b 55 0c             	mov    0xc(%ebp),%edx
80105115:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
        queue->next++;
80105119:	8b 45 08             	mov    0x8(%ebp),%eax
8010511c:	8b 80 38 01 00 00    	mov    0x138(%eax),%eax
80105122:	8d 50 01             	lea    0x1(%eax),%edx
80105125:	8b 45 08             	mov    0x8(%ebp),%eax
80105128:	89 90 38 01 00 00    	mov    %edx,0x138(%eax)
        queue->next = queue->next % NPROC;
8010512e:	8b 45 08             	mov    0x8(%ebp),%eax
80105131:	8b 80 38 01 00 00    	mov    0x138(%eax),%eax
80105137:	25 3f 00 00 80       	and    $0x8000003f,%eax
8010513c:	85 c0                	test   %eax,%eax
8010513e:	79 05                	jns    80105145 <addProcessToQueue+0xb8>
80105140:	48                   	dec    %eax
80105141:	83 c8 c0             	or     $0xffffffc0,%eax
80105144:	40                   	inc    %eax
80105145:	89 c2                	mov    %eax,%edx
80105147:	8b 45 08             	mov    0x8(%ebp),%eax
8010514a:	89 90 38 01 00 00    	mov    %edx,0x138(%eax)
    }
    queue->numOfProcs++;
80105150:	8b 45 08             	mov    0x8(%ebp),%eax
80105153:	8b 80 3c 01 00 00    	mov    0x13c(%eax),%eax
80105159:	8d 50 01             	lea    0x1(%eax),%edx
8010515c:	8b 45 08             	mov    0x8(%ebp),%eax
8010515f:	89 90 3c 01 00 00    	mov    %edx,0x13c(%eax)
    release(&queue->lock);
80105165:	8b 45 08             	mov    0x8(%ebp),%eax
80105168:	89 04 24             	mov    %eax,(%esp)
8010516b:	e8 11 05 00 00       	call   80105681 <release>
}
80105170:	c9                   	leave  
80105171:	c3                   	ret    

80105172 <getNextProcessFromQueue>:

// return next proc pointers and remove from a given queue
struct proc* getNextProcessFromQueue(pQueue *queue)
{
80105172:	55                   	push   %ebp
80105173:	89 e5                	mov    %esp,%ebp
80105175:	83 ec 28             	sub    $0x28,%esp
    struct proc *tempProc = 0;
80105178:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    acquire(&queue->lock);
8010517f:	8b 45 08             	mov    0x8(%ebp),%eax
80105182:	89 04 24             	mov    %eax,(%esp)
80105185:	e8 95 04 00 00       	call   8010561f <acquire>

    // process array is empty (full can't be)
    if (queue->first !=  queue->next)
8010518a:	8b 45 08             	mov    0x8(%ebp),%eax
8010518d:	8b 90 34 01 00 00    	mov    0x134(%eax),%edx
80105193:	8b 45 08             	mov    0x8(%ebp),%eax
80105196:	8b 80 38 01 00 00    	mov    0x138(%eax),%eax
8010519c:	39 c2                	cmp    %eax,%edx
8010519e:	74 79                	je     80105219 <getNextProcessFromQueue+0xa7>
    {
        tempProc = queue->queue[queue->first];
801051a0:	8b 45 08             	mov    0x8(%ebp),%eax
801051a3:	8b 90 34 01 00 00    	mov    0x134(%eax),%edx
801051a9:	8b 45 08             	mov    0x8(%ebp),%eax
801051ac:	83 c2 0c             	add    $0xc,%edx
801051af:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801051b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        queue->queue[queue->first] = 0;
801051b6:	8b 45 08             	mov    0x8(%ebp),%eax
801051b9:	8b 90 34 01 00 00    	mov    0x134(%eax),%edx
801051bf:	8b 45 08             	mov    0x8(%ebp),%eax
801051c2:	83 c2 0c             	add    $0xc,%edx
801051c5:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
801051cc:	00 
        queue->first++;
801051cd:	8b 45 08             	mov    0x8(%ebp),%eax
801051d0:	8b 80 34 01 00 00    	mov    0x134(%eax),%eax
801051d6:	8d 50 01             	lea    0x1(%eax),%edx
801051d9:	8b 45 08             	mov    0x8(%ebp),%eax
801051dc:	89 90 34 01 00 00    	mov    %edx,0x134(%eax)
        queue->first = queue->first % NPROC;
801051e2:	8b 45 08             	mov    0x8(%ebp),%eax
801051e5:	8b 80 34 01 00 00    	mov    0x134(%eax),%eax
801051eb:	25 3f 00 00 80       	and    $0x8000003f,%eax
801051f0:	85 c0                	test   %eax,%eax
801051f2:	79 05                	jns    801051f9 <getNextProcessFromQueue+0x87>
801051f4:	48                   	dec    %eax
801051f5:	83 c8 c0             	or     $0xffffffc0,%eax
801051f8:	40                   	inc    %eax
801051f9:	89 c2                	mov    %eax,%edx
801051fb:	8b 45 08             	mov    0x8(%ebp),%eax
801051fe:	89 90 34 01 00 00    	mov    %edx,0x134(%eax)
        queue->numOfProcs--;
80105204:	8b 45 08             	mov    0x8(%ebp),%eax
80105207:	8b 80 3c 01 00 00    	mov    0x13c(%eax),%eax
8010520d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105210:	8b 45 08             	mov    0x8(%ebp),%eax
80105213:	89 90 3c 01 00 00    	mov    %edx,0x13c(%eax)
    }

    release(&queue->lock);
80105219:	8b 45 08             	mov    0x8(%ebp),%eax
8010521c:	89 04 24             	mov    %eax,(%esp)
8010521f:	e8 5d 04 00 00       	call   80105681 <release>

    return tempProc;
80105224:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105227:	c9                   	leave  
80105228:	c3                   	ret    

80105229 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80105229:	55                   	push   %ebp
8010522a:	89 e5                	mov    %esp,%ebp
8010522c:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
8010522f:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80105236:	e8 0c 05 00 00       	call   80105747 <holding>
8010523b:	85 c0                	test   %eax,%eax
8010523d:	75 0c                	jne    8010524b <sched+0x22>
    panic("sched ptable.lock");
8010523f:	c7 04 24 20 90 10 80 	movl   $0x80109020,(%esp)
80105246:	e8 eb b2 ff ff       	call   80100536 <panic>
  if(cpu->ncli != 1)
8010524b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105251:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105257:	83 f8 01             	cmp    $0x1,%eax
8010525a:	74 0c                	je     80105268 <sched+0x3f>
    panic("sched locks");
8010525c:	c7 04 24 32 90 10 80 	movl   $0x80109032,(%esp)
80105263:	e8 ce b2 ff ff       	call   80100536 <panic>
  if(proc->state == RUNNING)
80105268:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010526e:	8b 40 0c             	mov    0xc(%eax),%eax
80105271:	83 f8 04             	cmp    $0x4,%eax
80105274:	75 0c                	jne    80105282 <sched+0x59>
    panic("sched running");
80105276:	c7 04 24 3e 90 10 80 	movl   $0x8010903e,(%esp)
8010527d:	e8 b4 b2 ff ff       	call   80100536 <panic>
  if(readeflags()&FL_IF)
80105282:	e8 b5 f2 ff ff       	call   8010453c <readeflags>
80105287:	25 00 02 00 00       	and    $0x200,%eax
8010528c:	85 c0                	test   %eax,%eax
8010528e:	74 0c                	je     8010529c <sched+0x73>
    panic("sched interruptible");
80105290:	c7 04 24 4c 90 10 80 	movl   $0x8010904c,(%esp)
80105297:	e8 9a b2 ff ff       	call   80100536 <panic>
  intena = cpu->intena;
8010529c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052a2:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801052a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
801052ab:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052b1:	8b 40 04             	mov    0x4(%eax),%eax
801052b4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052bb:	83 c2 1c             	add    $0x1c,%edx
801052be:	89 44 24 04          	mov    %eax,0x4(%esp)
801052c2:	89 14 24             	mov    %edx,(%esp)
801052c5:	e8 7a 08 00 00       	call   80105b44 <swtch>
  cpu->intena = intena;
801052ca:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052d3:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801052d9:	c9                   	leave  
801052da:	c3                   	ret    

801052db <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801052db:	55                   	push   %ebp
801052dc:	89 e5                	mov    %esp,%ebp
801052de:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801052e1:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
801052e8:	e8 32 03 00 00       	call   8010561f <acquire>
  proc->state = RUNNABLE;
801052ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052f3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        default:
            addProcessToQueue(&priorityQueues.low, proc);
    }
  #endif

  sched();
801052fa:	e8 2a ff ff ff       	call   80105229 <sched>
  release(&ptable.lock);
801052ff:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80105306:	e8 76 03 00 00       	call   80105681 <release>
}
8010530b:	c9                   	leave  
8010530c:	c3                   	ret    

8010530d <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010530d:	55                   	push   %ebp
8010530e:	89 e5                	mov    %esp,%ebp
80105310:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80105313:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
8010531a:	e8 62 03 00 00       	call   80105681 <release>

  if (first)
8010531f:	a1 20 c0 10 80       	mov    0x8010c020,%eax
80105324:	85 c0                	test   %eax,%eax
80105326:	74 0f                	je     80105337 <forkret+0x2a>
  {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80105328:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
8010532f:	00 00 00 
    initlog();
80105332:	e8 e9 e1 ff ff       	call   80103520 <initlog>
  }
  // Return to "caller", actually trapret (see allocproc).
}
80105337:	c9                   	leave  
80105338:	c3                   	ret    

80105339 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80105339:	55                   	push   %ebp
8010533a:	89 e5                	mov    %esp,%ebp
8010533c:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
8010533f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105345:	85 c0                	test   %eax,%eax
80105347:	75 0c                	jne    80105355 <sleep+0x1c>
    panic("sleep");
80105349:	c7 04 24 60 90 10 80 	movl   $0x80109060,(%esp)
80105350:	e8 e1 b1 ff ff       	call   80100536 <panic>

  if(lk == 0)
80105355:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105359:	75 0c                	jne    80105367 <sleep+0x2e>
    panic("sleep without lk");
8010535b:	c7 04 24 66 90 10 80 	movl   $0x80109066,(%esp)
80105362:	e8 cf b1 ff ff       	call   80100536 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105367:	81 7d 0c 40 23 11 80 	cmpl   $0x80112340,0xc(%ebp)
8010536e:	74 17                	je     80105387 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80105370:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80105377:	e8 a3 02 00 00       	call   8010561f <acquire>
    release(lk);
8010537c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010537f:	89 04 24             	mov    %eax,(%esp)
80105382:	e8 fa 02 00 00       	call   80105681 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80105387:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010538d:	8b 55 08             	mov    0x8(%ebp),%edx
80105390:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80105393:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105399:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801053a0:	e8 84 fe ff ff       	call   80105229 <sched>

  // Tidy up.
  proc->chan = 0;
801053a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053ab:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801053b2:	81 7d 0c 40 23 11 80 	cmpl   $0x80112340,0xc(%ebp)
801053b9:	74 17                	je     801053d2 <sleep+0x99>
    release(&ptable.lock);
801053bb:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
801053c2:	e8 ba 02 00 00       	call   80105681 <release>
    acquire(lk);
801053c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801053ca:	89 04 24             	mov    %eax,(%esp)
801053cd:	e8 4d 02 00 00       	call   8010561f <acquire>
  }
}
801053d2:	c9                   	leave  
801053d3:	c3                   	ret    

801053d4 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801053d4:	55                   	push   %ebp
801053d5:	89 e5                	mov    %esp,%ebp
801053d7:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801053da:	c7 45 fc 74 23 11 80 	movl   $0x80112374,-0x4(%ebp)
801053e1:	eb 27                	jmp    8010540a <wakeup1+0x36>
  {
    if(p->state == SLEEPING && p->chan == chan)
801053e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053e6:	8b 40 0c             	mov    0xc(%eax),%eax
801053e9:	83 f8 02             	cmp    $0x2,%eax
801053ec:	75 15                	jne    80105403 <wakeup1+0x2f>
801053ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053f1:	8b 40 20             	mov    0x20(%eax),%eax
801053f4:	3b 45 08             	cmp    0x8(%ebp),%eax
801053f7:	75 0a                	jne    80105403 <wakeup1+0x2f>
    {
      p->state = RUNNABLE;
801053f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053fc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105403:	81 45 fc 90 00 00 00 	addl   $0x90,-0x4(%ebp)
8010540a:	81 7d fc 74 47 11 80 	cmpl   $0x80114774,-0x4(%ebp)
80105411:	72 d0                	jb     801053e3 <wakeup1+0xf>
                addProcessToQueue(&priorityQueues.high, p);
        }
      #endif
    }
  }
}
80105413:	c9                   	leave  
80105414:	c3                   	ret    

80105415 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105415:	55                   	push   %ebp
80105416:	89 e5                	mov    %esp,%ebp
80105418:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
8010541b:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80105422:	e8 f8 01 00 00       	call   8010561f <acquire>
  wakeup1(chan);
80105427:	8b 45 08             	mov    0x8(%ebp),%eax
8010542a:	89 04 24             	mov    %eax,(%esp)
8010542d:	e8 a2 ff ff ff       	call   801053d4 <wakeup1>
  release(&ptable.lock);
80105432:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
80105439:	e8 43 02 00 00       	call   80105681 <release>
}
8010543e:	c9                   	leave  
8010543f:	c3                   	ret    

80105440 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80105446:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
8010544d:	e8 cd 01 00 00       	call   8010561f <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105452:	c7 45 f4 74 23 11 80 	movl   $0x80112374,-0xc(%ebp)
80105459:	eb 44                	jmp    8010549f <kill+0x5f>
  {
    if(p->pid == pid)
8010545b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010545e:	8b 40 10             	mov    0x10(%eax),%eax
80105461:	3b 45 08             	cmp    0x8(%ebp),%eax
80105464:	75 32                	jne    80105498 <kill+0x58>
    {
      p->killed = 1;
80105466:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105469:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80105470:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105473:	8b 40 0c             	mov    0xc(%eax),%eax
80105476:	83 f8 02             	cmp    $0x2,%eax
80105479:	75 0a                	jne    80105485 <kill+0x45>
      {
        p->state = RUNNABLE;
8010547b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010547e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
                  addProcessToQueue(&priorityQueues.high, p);
          }
        #endif
      }

      release(&ptable.lock);
80105485:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
8010548c:	e8 f0 01 00 00       	call   80105681 <release>
      return 0;
80105491:	b8 00 00 00 00       	mov    $0x0,%eax
80105496:	eb 21                	jmp    801054b9 <kill+0x79>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105498:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
8010549f:	81 7d f4 74 47 11 80 	cmpl   $0x80114774,-0xc(%ebp)
801054a6:	72 b3                	jb     8010545b <kill+0x1b>

      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801054a8:	c7 04 24 40 23 11 80 	movl   $0x80112340,(%esp)
801054af:	e8 cd 01 00 00       	call   80105681 <release>
  return -1;
801054b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054b9:	c9                   	leave  
801054ba:	c3                   	ret    

801054bb <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801054bb:	55                   	push   %ebp
801054bc:	89 e5                	mov    %esp,%ebp
801054be:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801054c1:	c7 45 f0 74 23 11 80 	movl   $0x80112374,-0x10(%ebp)
801054c8:	e9 da 00 00 00       	jmp    801055a7 <procdump+0xec>
      if(p->state == UNUSED)
801054cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054d0:	8b 40 0c             	mov    0xc(%eax),%eax
801054d3:	85 c0                	test   %eax,%eax
801054d5:	0f 84 c4 00 00 00    	je     8010559f <procdump+0xe4>
          continue;
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801054db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054de:	8b 40 0c             	mov    0xc(%eax),%eax
801054e1:	83 f8 05             	cmp    $0x5,%eax
801054e4:	77 23                	ja     80105509 <procdump+0x4e>
801054e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054e9:	8b 40 0c             	mov    0xc(%eax),%eax
801054ec:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801054f3:	85 c0                	test   %eax,%eax
801054f5:	74 12                	je     80105509 <procdump+0x4e>
          state = states[p->state];
801054f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054fa:	8b 40 0c             	mov    0xc(%eax),%eax
801054fd:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80105504:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105507:	eb 07                	jmp    80105510 <procdump+0x55>
      else
          state = "???";
80105509:	c7 45 ec 77 90 10 80 	movl   $0x80109077,-0x14(%ebp)
      cprintf("%d %s %s", p->pid, state, p->name);
80105510:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105513:	8d 50 6c             	lea    0x6c(%eax),%edx
80105516:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105519:	8b 40 10             	mov    0x10(%eax),%eax
8010551c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105520:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105523:	89 54 24 08          	mov    %edx,0x8(%esp)
80105527:	89 44 24 04          	mov    %eax,0x4(%esp)
8010552b:	c7 04 24 7b 90 10 80 	movl   $0x8010907b,(%esp)
80105532:	e8 6a ae ff ff       	call   801003a1 <cprintf>
      if(p->state == SLEEPING){
80105537:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010553a:	8b 40 0c             	mov    0xc(%eax),%eax
8010553d:	83 f8 02             	cmp    $0x2,%eax
80105540:	75 4f                	jne    80105591 <procdump+0xd6>
          getcallerpcs((uint*)p->context->ebp+2, pc);
80105542:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105545:	8b 40 1c             	mov    0x1c(%eax),%eax
80105548:	8b 40 0c             	mov    0xc(%eax),%eax
8010554b:	83 c0 08             	add    $0x8,%eax
8010554e:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80105551:	89 54 24 04          	mov    %edx,0x4(%esp)
80105555:	89 04 24             	mov    %eax,(%esp)
80105558:	e8 73 01 00 00       	call   801056d0 <getcallerpcs>
          for(i=0; i<10 && pc[i] != 0; i++)
8010555d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105564:	eb 1a                	jmp    80105580 <procdump+0xc5>
              cprintf(" %p", pc[i]);
80105566:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105569:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010556d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105571:	c7 04 24 84 90 10 80 	movl   $0x80109084,(%esp)
80105578:	e8 24 ae ff ff       	call   801003a1 <cprintf>
      else
          state = "???";
      cprintf("%d %s %s", p->pid, state, p->name);
      if(p->state == SLEEPING){
          getcallerpcs((uint*)p->context->ebp+2, pc);
          for(i=0; i<10 && pc[i] != 0; i++)
8010557d:	ff 45 f4             	incl   -0xc(%ebp)
80105580:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105584:	7f 0b                	jg     80105591 <procdump+0xd6>
80105586:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105589:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010558d:	85 c0                	test   %eax,%eax
8010558f:	75 d5                	jne    80105566 <procdump+0xab>
              cprintf(" %p", pc[i]);
      }
      cprintf("\n");
80105591:	c7 04 24 88 90 10 80 	movl   $0x80109088,(%esp)
80105598:	e8 04 ae ff ff       	call   801003a1 <cprintf>
8010559d:	eb 01                	jmp    801055a0 <procdump+0xe5>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state == UNUSED)
          continue;
8010559f:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801055a0:	81 45 f0 90 00 00 00 	addl   $0x90,-0x10(%ebp)
801055a7:	81 7d f0 74 47 11 80 	cmpl   $0x80114774,-0x10(%ebp)
801055ae:	0f 82 19 ff ff ff    	jb     801054cd <procdump+0x12>
          for(i=0; i<10 && pc[i] != 0; i++)
              cprintf(" %p", pc[i]);
      }
      cprintf("\n");
  }
}
801055b4:	c9                   	leave  
801055b5:	c3                   	ret    
801055b6:	66 90                	xchg   %ax,%ax

801055b8 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801055b8:	55                   	push   %ebp
801055b9:	89 e5                	mov    %esp,%ebp
801055bb:	53                   	push   %ebx
801055bc:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801055bf:	9c                   	pushf  
801055c0:	5b                   	pop    %ebx
801055c1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
801055c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801055c7:	83 c4 10             	add    $0x10,%esp
801055ca:	5b                   	pop    %ebx
801055cb:	5d                   	pop    %ebp
801055cc:	c3                   	ret    

801055cd <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801055cd:	55                   	push   %ebp
801055ce:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801055d0:	fa                   	cli    
}
801055d1:	5d                   	pop    %ebp
801055d2:	c3                   	ret    

801055d3 <sti>:

static inline void
sti(void)
{
801055d3:	55                   	push   %ebp
801055d4:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801055d6:	fb                   	sti    
}
801055d7:	5d                   	pop    %ebp
801055d8:	c3                   	ret    

801055d9 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801055d9:	55                   	push   %ebp
801055da:	89 e5                	mov    %esp,%ebp
801055dc:	53                   	push   %ebx
801055dd:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
801055e0:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801055e3:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
801055e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801055e9:	89 c3                	mov    %eax,%ebx
801055eb:	89 d8                	mov    %ebx,%eax
801055ed:	f0 87 02             	lock xchg %eax,(%edx)
801055f0:	89 c3                	mov    %eax,%ebx
801055f2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801055f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801055f8:	83 c4 10             	add    $0x10,%esp
801055fb:	5b                   	pop    %ebx
801055fc:	5d                   	pop    %ebp
801055fd:	c3                   	ret    

801055fe <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801055fe:	55                   	push   %ebp
801055ff:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105601:	8b 45 08             	mov    0x8(%ebp),%eax
80105604:	8b 55 0c             	mov    0xc(%ebp),%edx
80105607:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010560a:	8b 45 08             	mov    0x8(%ebp),%eax
8010560d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105613:	8b 45 08             	mov    0x8(%ebp),%eax
80105616:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010561d:	5d                   	pop    %ebp
8010561e:	c3                   	ret    

8010561f <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010561f:	55                   	push   %ebp
80105620:	89 e5                	mov    %esp,%ebp
80105622:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105625:	e8 47 01 00 00       	call   80105771 <pushcli>
  if(holding(lk))
8010562a:	8b 45 08             	mov    0x8(%ebp),%eax
8010562d:	89 04 24             	mov    %eax,(%esp)
80105630:	e8 12 01 00 00       	call   80105747 <holding>
80105635:	85 c0                	test   %eax,%eax
80105637:	74 0c                	je     80105645 <acquire+0x26>
    panic("acquire");
80105639:	c7 04 24 b4 90 10 80 	movl   $0x801090b4,(%esp)
80105640:	e8 f1 ae ff ff       	call   80100536 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105645:	90                   	nop
80105646:	8b 45 08             	mov    0x8(%ebp),%eax
80105649:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105650:	00 
80105651:	89 04 24             	mov    %eax,(%esp)
80105654:	e8 80 ff ff ff       	call   801055d9 <xchg>
80105659:	85 c0                	test   %eax,%eax
8010565b:	75 e9                	jne    80105646 <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010565d:	8b 45 08             	mov    0x8(%ebp),%eax
80105660:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105667:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010566a:	8b 45 08             	mov    0x8(%ebp),%eax
8010566d:	83 c0 0c             	add    $0xc,%eax
80105670:	89 44 24 04          	mov    %eax,0x4(%esp)
80105674:	8d 45 08             	lea    0x8(%ebp),%eax
80105677:	89 04 24             	mov    %eax,(%esp)
8010567a:	e8 51 00 00 00       	call   801056d0 <getcallerpcs>
}
8010567f:	c9                   	leave  
80105680:	c3                   	ret    

80105681 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105681:	55                   	push   %ebp
80105682:	89 e5                	mov    %esp,%ebp
80105684:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80105687:	8b 45 08             	mov    0x8(%ebp),%eax
8010568a:	89 04 24             	mov    %eax,(%esp)
8010568d:	e8 b5 00 00 00       	call   80105747 <holding>
80105692:	85 c0                	test   %eax,%eax
80105694:	75 0c                	jne    801056a2 <release+0x21>
    panic("release");
80105696:	c7 04 24 bc 90 10 80 	movl   $0x801090bc,(%esp)
8010569d:	e8 94 ae ff ff       	call   80100536 <panic>

  lk->pcs[0] = 0;
801056a2:	8b 45 08             	mov    0x8(%ebp),%eax
801056a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801056ac:	8b 45 08             	mov    0x8(%ebp),%eax
801056af:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801056b6:	8b 45 08             	mov    0x8(%ebp),%eax
801056b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801056c0:	00 
801056c1:	89 04 24             	mov    %eax,(%esp)
801056c4:	e8 10 ff ff ff       	call   801055d9 <xchg>

  popcli();
801056c9:	e8 e9 00 00 00       	call   801057b7 <popcli>
}
801056ce:	c9                   	leave  
801056cf:	c3                   	ret    

801056d0 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801056d6:	8b 45 08             	mov    0x8(%ebp),%eax
801056d9:	83 e8 08             	sub    $0x8,%eax
801056dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801056df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801056e6:	eb 37                	jmp    8010571f <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801056e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801056ec:	74 51                	je     8010573f <getcallerpcs+0x6f>
801056ee:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801056f5:	76 48                	jbe    8010573f <getcallerpcs+0x6f>
801056f7:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801056fb:	74 42                	je     8010573f <getcallerpcs+0x6f>
      break;
    pcs[i] = ebp[1];     // saved %eip
801056fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105700:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105707:	8b 45 0c             	mov    0xc(%ebp),%eax
8010570a:	01 c2                	add    %eax,%edx
8010570c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010570f:	8b 40 04             	mov    0x4(%eax),%eax
80105712:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105714:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105717:	8b 00                	mov    (%eax),%eax
80105719:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010571c:	ff 45 f8             	incl   -0x8(%ebp)
8010571f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105723:	7e c3                	jle    801056e8 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105725:	eb 18                	jmp    8010573f <getcallerpcs+0x6f>
    pcs[i] = 0;
80105727:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010572a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105731:	8b 45 0c             	mov    0xc(%ebp),%eax
80105734:	01 d0                	add    %edx,%eax
80105736:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010573c:	ff 45 f8             	incl   -0x8(%ebp)
8010573f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105743:	7e e2                	jle    80105727 <getcallerpcs+0x57>
    pcs[i] = 0;
}
80105745:	c9                   	leave  
80105746:	c3                   	ret    

80105747 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105747:	55                   	push   %ebp
80105748:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010574a:	8b 45 08             	mov    0x8(%ebp),%eax
8010574d:	8b 00                	mov    (%eax),%eax
8010574f:	85 c0                	test   %eax,%eax
80105751:	74 17                	je     8010576a <holding+0x23>
80105753:	8b 45 08             	mov    0x8(%ebp),%eax
80105756:	8b 50 08             	mov    0x8(%eax),%edx
80105759:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010575f:	39 c2                	cmp    %eax,%edx
80105761:	75 07                	jne    8010576a <holding+0x23>
80105763:	b8 01 00 00 00       	mov    $0x1,%eax
80105768:	eb 05                	jmp    8010576f <holding+0x28>
8010576a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010576f:	5d                   	pop    %ebp
80105770:	c3                   	ret    

80105771 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105771:	55                   	push   %ebp
80105772:	89 e5                	mov    %esp,%ebp
80105774:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105777:	e8 3c fe ff ff       	call   801055b8 <readeflags>
8010577c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010577f:	e8 49 fe ff ff       	call   801055cd <cli>
  if(cpu->ncli++ == 0)
80105784:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010578a:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105790:	85 d2                	test   %edx,%edx
80105792:	0f 94 c1             	sete   %cl
80105795:	42                   	inc    %edx
80105796:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010579c:	84 c9                	test   %cl,%cl
8010579e:	74 15                	je     801057b5 <pushcli+0x44>
    cpu->intena = eflags & FL_IF;
801057a0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801057a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057a9:	81 e2 00 02 00 00    	and    $0x200,%edx
801057af:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801057b5:	c9                   	leave  
801057b6:	c3                   	ret    

801057b7 <popcli>:

void
popcli(void)
{
801057b7:	55                   	push   %ebp
801057b8:	89 e5                	mov    %esp,%ebp
801057ba:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
801057bd:	e8 f6 fd ff ff       	call   801055b8 <readeflags>
801057c2:	25 00 02 00 00       	and    $0x200,%eax
801057c7:	85 c0                	test   %eax,%eax
801057c9:	74 0c                	je     801057d7 <popcli+0x20>
    panic("popcli - interruptible");
801057cb:	c7 04 24 c4 90 10 80 	movl   $0x801090c4,(%esp)
801057d2:	e8 5f ad ff ff       	call   80100536 <panic>
  if(--cpu->ncli < 0)
801057d7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801057dd:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801057e3:	4a                   	dec    %edx
801057e4:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801057ea:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801057f0:	85 c0                	test   %eax,%eax
801057f2:	79 0c                	jns    80105800 <popcli+0x49>
    panic("popcli");
801057f4:	c7 04 24 db 90 10 80 	movl   $0x801090db,(%esp)
801057fb:	e8 36 ad ff ff       	call   80100536 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105800:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105806:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010580c:	85 c0                	test   %eax,%eax
8010580e:	75 15                	jne    80105825 <popcli+0x6e>
80105810:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105816:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010581c:	85 c0                	test   %eax,%eax
8010581e:	74 05                	je     80105825 <popcli+0x6e>
    sti();
80105820:	e8 ae fd ff ff       	call   801055d3 <sti>
}
80105825:	c9                   	leave  
80105826:	c3                   	ret    
80105827:	90                   	nop

80105828 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105828:	55                   	push   %ebp
80105829:	89 e5                	mov    %esp,%ebp
8010582b:	57                   	push   %edi
8010582c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010582d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105830:	8b 55 10             	mov    0x10(%ebp),%edx
80105833:	8b 45 0c             	mov    0xc(%ebp),%eax
80105836:	89 cb                	mov    %ecx,%ebx
80105838:	89 df                	mov    %ebx,%edi
8010583a:	89 d1                	mov    %edx,%ecx
8010583c:	fc                   	cld    
8010583d:	f3 aa                	rep stos %al,%es:(%edi)
8010583f:	89 ca                	mov    %ecx,%edx
80105841:	89 fb                	mov    %edi,%ebx
80105843:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105846:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105849:	5b                   	pop    %ebx
8010584a:	5f                   	pop    %edi
8010584b:	5d                   	pop    %ebp
8010584c:	c3                   	ret    

8010584d <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010584d:	55                   	push   %ebp
8010584e:	89 e5                	mov    %esp,%ebp
80105850:	57                   	push   %edi
80105851:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105852:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105855:	8b 55 10             	mov    0x10(%ebp),%edx
80105858:	8b 45 0c             	mov    0xc(%ebp),%eax
8010585b:	89 cb                	mov    %ecx,%ebx
8010585d:	89 df                	mov    %ebx,%edi
8010585f:	89 d1                	mov    %edx,%ecx
80105861:	fc                   	cld    
80105862:	f3 ab                	rep stos %eax,%es:(%edi)
80105864:	89 ca                	mov    %ecx,%edx
80105866:	89 fb                	mov    %edi,%ebx
80105868:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010586b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010586e:	5b                   	pop    %ebx
8010586f:	5f                   	pop    %edi
80105870:	5d                   	pop    %ebp
80105871:	c3                   	ret    

80105872 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105872:	55                   	push   %ebp
80105873:	89 e5                	mov    %esp,%ebp
80105875:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105878:	8b 45 08             	mov    0x8(%ebp),%eax
8010587b:	83 e0 03             	and    $0x3,%eax
8010587e:	85 c0                	test   %eax,%eax
80105880:	75 49                	jne    801058cb <memset+0x59>
80105882:	8b 45 10             	mov    0x10(%ebp),%eax
80105885:	83 e0 03             	and    $0x3,%eax
80105888:	85 c0                	test   %eax,%eax
8010588a:	75 3f                	jne    801058cb <memset+0x59>
    c &= 0xFF;
8010588c:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105893:	8b 45 10             	mov    0x10(%ebp),%eax
80105896:	c1 e8 02             	shr    $0x2,%eax
80105899:	89 c2                	mov    %eax,%edx
8010589b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010589e:	89 c1                	mov    %eax,%ecx
801058a0:	c1 e1 18             	shl    $0x18,%ecx
801058a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801058a6:	c1 e0 10             	shl    $0x10,%eax
801058a9:	09 c1                	or     %eax,%ecx
801058ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801058ae:	c1 e0 08             	shl    $0x8,%eax
801058b1:	09 c8                	or     %ecx,%eax
801058b3:	0b 45 0c             	or     0xc(%ebp),%eax
801058b6:	89 54 24 08          	mov    %edx,0x8(%esp)
801058ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801058be:	8b 45 08             	mov    0x8(%ebp),%eax
801058c1:	89 04 24             	mov    %eax,(%esp)
801058c4:	e8 84 ff ff ff       	call   8010584d <stosl>
801058c9:	eb 19                	jmp    801058e4 <memset+0x72>
  } else
    stosb(dst, c, n);
801058cb:	8b 45 10             	mov    0x10(%ebp),%eax
801058ce:	89 44 24 08          	mov    %eax,0x8(%esp)
801058d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801058d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801058d9:	8b 45 08             	mov    0x8(%ebp),%eax
801058dc:	89 04 24             	mov    %eax,(%esp)
801058df:	e8 44 ff ff ff       	call   80105828 <stosb>
  return dst;
801058e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
801058e7:	c9                   	leave  
801058e8:	c3                   	ret    

801058e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801058e9:	55                   	push   %ebp
801058ea:	89 e5                	mov    %esp,%ebp
801058ec:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801058ef:	8b 45 08             	mov    0x8(%ebp),%eax
801058f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801058f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801058f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801058fb:	eb 2c                	jmp    80105929 <memcmp+0x40>
    if(*s1 != *s2)
801058fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105900:	8a 10                	mov    (%eax),%dl
80105902:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105905:	8a 00                	mov    (%eax),%al
80105907:	38 c2                	cmp    %al,%dl
80105909:	74 18                	je     80105923 <memcmp+0x3a>
      return *s1 - *s2;
8010590b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010590e:	8a 00                	mov    (%eax),%al
80105910:	0f b6 d0             	movzbl %al,%edx
80105913:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105916:	8a 00                	mov    (%eax),%al
80105918:	0f b6 c0             	movzbl %al,%eax
8010591b:	89 d1                	mov    %edx,%ecx
8010591d:	29 c1                	sub    %eax,%ecx
8010591f:	89 c8                	mov    %ecx,%eax
80105921:	eb 19                	jmp    8010593c <memcmp+0x53>
    s1++, s2++;
80105923:	ff 45 fc             	incl   -0x4(%ebp)
80105926:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105929:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010592d:	0f 95 c0             	setne  %al
80105930:	ff 4d 10             	decl   0x10(%ebp)
80105933:	84 c0                	test   %al,%al
80105935:	75 c6                	jne    801058fd <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105937:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010593c:	c9                   	leave  
8010593d:	c3                   	ret    

8010593e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010593e:	55                   	push   %ebp
8010593f:	89 e5                	mov    %esp,%ebp
80105941:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105944:	8b 45 0c             	mov    0xc(%ebp),%eax
80105947:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010594a:	8b 45 08             	mov    0x8(%ebp),%eax
8010594d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105950:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105953:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105956:	73 4d                	jae    801059a5 <memmove+0x67>
80105958:	8b 45 10             	mov    0x10(%ebp),%eax
8010595b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010595e:	01 d0                	add    %edx,%eax
80105960:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105963:	76 40                	jbe    801059a5 <memmove+0x67>
    s += n;
80105965:	8b 45 10             	mov    0x10(%ebp),%eax
80105968:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010596b:	8b 45 10             	mov    0x10(%ebp),%eax
8010596e:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105971:	eb 10                	jmp    80105983 <memmove+0x45>
      *--d = *--s;
80105973:	ff 4d f8             	decl   -0x8(%ebp)
80105976:	ff 4d fc             	decl   -0x4(%ebp)
80105979:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010597c:	8a 10                	mov    (%eax),%dl
8010597e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105981:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105983:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105987:	0f 95 c0             	setne  %al
8010598a:	ff 4d 10             	decl   0x10(%ebp)
8010598d:	84 c0                	test   %al,%al
8010598f:	75 e2                	jne    80105973 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105991:	eb 21                	jmp    801059b4 <memmove+0x76>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80105993:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105996:	8a 10                	mov    (%eax),%dl
80105998:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010599b:	88 10                	mov    %dl,(%eax)
8010599d:	ff 45 f8             	incl   -0x8(%ebp)
801059a0:	ff 45 fc             	incl   -0x4(%ebp)
801059a3:	eb 01                	jmp    801059a6 <memmove+0x68>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801059a5:	90                   	nop
801059a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059aa:	0f 95 c0             	setne  %al
801059ad:	ff 4d 10             	decl   0x10(%ebp)
801059b0:	84 c0                	test   %al,%al
801059b2:	75 df                	jne    80105993 <memmove+0x55>
      *d++ = *s++;

  return dst;
801059b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
801059b7:	c9                   	leave  
801059b8:	c3                   	ret    

801059b9 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801059b9:	55                   	push   %ebp
801059ba:	89 e5                	mov    %esp,%ebp
801059bc:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801059bf:	8b 45 10             	mov    0x10(%ebp),%eax
801059c2:	89 44 24 08          	mov    %eax,0x8(%esp)
801059c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801059c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801059cd:	8b 45 08             	mov    0x8(%ebp),%eax
801059d0:	89 04 24             	mov    %eax,(%esp)
801059d3:	e8 66 ff ff ff       	call   8010593e <memmove>
}
801059d8:	c9                   	leave  
801059d9:	c3                   	ret    

801059da <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801059da:	55                   	push   %ebp
801059db:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801059dd:	eb 09                	jmp    801059e8 <strncmp+0xe>
    n--, p++, q++;
801059df:	ff 4d 10             	decl   0x10(%ebp)
801059e2:	ff 45 08             	incl   0x8(%ebp)
801059e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801059e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059ec:	74 17                	je     80105a05 <strncmp+0x2b>
801059ee:	8b 45 08             	mov    0x8(%ebp),%eax
801059f1:	8a 00                	mov    (%eax),%al
801059f3:	84 c0                	test   %al,%al
801059f5:	74 0e                	je     80105a05 <strncmp+0x2b>
801059f7:	8b 45 08             	mov    0x8(%ebp),%eax
801059fa:	8a 10                	mov    (%eax),%dl
801059fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801059ff:	8a 00                	mov    (%eax),%al
80105a01:	38 c2                	cmp    %al,%dl
80105a03:	74 da                	je     801059df <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105a05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a09:	75 07                	jne    80105a12 <strncmp+0x38>
    return 0;
80105a0b:	b8 00 00 00 00       	mov    $0x0,%eax
80105a10:	eb 16                	jmp    80105a28 <strncmp+0x4e>
  return (uchar)*p - (uchar)*q;
80105a12:	8b 45 08             	mov    0x8(%ebp),%eax
80105a15:	8a 00                	mov    (%eax),%al
80105a17:	0f b6 d0             	movzbl %al,%edx
80105a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a1d:	8a 00                	mov    (%eax),%al
80105a1f:	0f b6 c0             	movzbl %al,%eax
80105a22:	89 d1                	mov    %edx,%ecx
80105a24:	29 c1                	sub    %eax,%ecx
80105a26:	89 c8                	mov    %ecx,%eax
}
80105a28:	5d                   	pop    %ebp
80105a29:	c3                   	ret    

80105a2a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105a2a:	55                   	push   %ebp
80105a2b:	89 e5                	mov    %esp,%ebp
80105a2d:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105a30:	8b 45 08             	mov    0x8(%ebp),%eax
80105a33:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105a36:	90                   	nop
80105a37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a3b:	0f 9f c0             	setg   %al
80105a3e:	ff 4d 10             	decl   0x10(%ebp)
80105a41:	84 c0                	test   %al,%al
80105a43:	74 2b                	je     80105a70 <strncpy+0x46>
80105a45:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a48:	8a 10                	mov    (%eax),%dl
80105a4a:	8b 45 08             	mov    0x8(%ebp),%eax
80105a4d:	88 10                	mov    %dl,(%eax)
80105a4f:	8b 45 08             	mov    0x8(%ebp),%eax
80105a52:	8a 00                	mov    (%eax),%al
80105a54:	84 c0                	test   %al,%al
80105a56:	0f 95 c0             	setne  %al
80105a59:	ff 45 08             	incl   0x8(%ebp)
80105a5c:	ff 45 0c             	incl   0xc(%ebp)
80105a5f:	84 c0                	test   %al,%al
80105a61:	75 d4                	jne    80105a37 <strncpy+0xd>
    ;
  while(n-- > 0)
80105a63:	eb 0b                	jmp    80105a70 <strncpy+0x46>
    *s++ = 0;
80105a65:	8b 45 08             	mov    0x8(%ebp),%eax
80105a68:	c6 00 00             	movb   $0x0,(%eax)
80105a6b:	ff 45 08             	incl   0x8(%ebp)
80105a6e:	eb 01                	jmp    80105a71 <strncpy+0x47>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105a70:	90                   	nop
80105a71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a75:	0f 9f c0             	setg   %al
80105a78:	ff 4d 10             	decl   0x10(%ebp)
80105a7b:	84 c0                	test   %al,%al
80105a7d:	75 e6                	jne    80105a65 <strncpy+0x3b>
    *s++ = 0;
  return os;
80105a7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a82:	c9                   	leave  
80105a83:	c3                   	ret    

80105a84 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105a84:	55                   	push   %ebp
80105a85:	89 e5                	mov    %esp,%ebp
80105a87:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105a8a:	8b 45 08             	mov    0x8(%ebp),%eax
80105a8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105a90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a94:	7f 05                	jg     80105a9b <safestrcpy+0x17>
    return os;
80105a96:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a99:	eb 30                	jmp    80105acb <safestrcpy+0x47>
  while(--n > 0 && (*s++ = *t++) != 0)
80105a9b:	ff 4d 10             	decl   0x10(%ebp)
80105a9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105aa2:	7e 1e                	jle    80105ac2 <safestrcpy+0x3e>
80105aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aa7:	8a 10                	mov    (%eax),%dl
80105aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80105aac:	88 10                	mov    %dl,(%eax)
80105aae:	8b 45 08             	mov    0x8(%ebp),%eax
80105ab1:	8a 00                	mov    (%eax),%al
80105ab3:	84 c0                	test   %al,%al
80105ab5:	0f 95 c0             	setne  %al
80105ab8:	ff 45 08             	incl   0x8(%ebp)
80105abb:	ff 45 0c             	incl   0xc(%ebp)
80105abe:	84 c0                	test   %al,%al
80105ac0:	75 d9                	jne    80105a9b <safestrcpy+0x17>
    ;
  *s = 0;
80105ac2:	8b 45 08             	mov    0x8(%ebp),%eax
80105ac5:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105ac8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105acb:	c9                   	leave  
80105acc:	c3                   	ret    

80105acd <strlen>:

int
strlen(const char *s)
{
80105acd:	55                   	push   %ebp
80105ace:	89 e5                	mov    %esp,%ebp
80105ad0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105ad3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105ada:	eb 03                	jmp    80105adf <strlen+0x12>
80105adc:	ff 45 fc             	incl   -0x4(%ebp)
80105adf:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ae2:	8b 45 08             	mov    0x8(%ebp),%eax
80105ae5:	01 d0                	add    %edx,%eax
80105ae7:	8a 00                	mov    (%eax),%al
80105ae9:	84 c0                	test   %al,%al
80105aeb:	75 ef                	jne    80105adc <strlen+0xf>
    ;
  return n;
80105aed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105af0:	c9                   	leave  
80105af1:	c3                   	ret    

80105af2 <strcat>:

// support for appending strings was added
char*
strcat(char* dest, const char* src)
{
80105af2:	55                   	push   %ebp
80105af3:	89 e5                	mov    %esp,%ebp
80105af5:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
80105af8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  while (dest[i] != '\0')
80105aff:	eb 03                	jmp    80105b04 <strcat+0x12>
    i++;
80105b01:	ff 45 fc             	incl   -0x4(%ebp)
char*
strcat(char* dest, const char* src)
{
  int i = 0;

  while (dest[i] != '\0')
80105b04:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b07:	8b 45 08             	mov    0x8(%ebp),%eax
80105b0a:	01 d0                	add    %edx,%eax
80105b0c:	8a 00                	mov    (%eax),%al
80105b0e:	84 c0                	test   %al,%al
80105b10:	75 ef                	jne    80105b01 <strcat+0xf>
    i++;
  while (*src != '\0')
80105b12:	eb 15                	jmp    80105b29 <strcat+0x37>
    dest[i++] = *src++;
80105b14:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b17:	8b 45 08             	mov    0x8(%ebp),%eax
80105b1a:	01 c2                	add    %eax,%edx
80105b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b1f:	8a 00                	mov    (%eax),%al
80105b21:	88 02                	mov    %al,(%edx)
80105b23:	ff 45 fc             	incl   -0x4(%ebp)
80105b26:	ff 45 0c             	incl   0xc(%ebp)
{
  int i = 0;

  while (dest[i] != '\0')
    i++;
  while (*src != '\0')
80105b29:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b2c:	8a 00                	mov    (%eax),%al
80105b2e:	84 c0                	test   %al,%al
80105b30:	75 e2                	jne    80105b14 <strcat+0x22>
    dest[i++] = *src++;
  dest[i] = '\0'; //useless because already initialized with 0
80105b32:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b35:	8b 45 08             	mov    0x8(%ebp),%eax
80105b38:	01 d0                	add    %edx,%eax
80105b3a:	c6 00 00             	movb   $0x0,(%eax)
  return (dest);
80105b3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105b40:	c9                   	leave  
80105b41:	c3                   	ret    
80105b42:	66 90                	xchg   %ax,%ax

80105b44 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105b44:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105b48:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105b4c:	55                   	push   %ebp
  pushl %ebx
80105b4d:	53                   	push   %ebx
  pushl %esi
80105b4e:	56                   	push   %esi
  pushl %edi
80105b4f:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105b50:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105b52:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105b54:	5f                   	pop    %edi
  popl %esi
80105b55:	5e                   	pop    %esi
  popl %ebx
80105b56:	5b                   	pop    %ebx
  popl %ebp
80105b57:	5d                   	pop    %ebp
  ret
80105b58:	c3                   	ret    
80105b59:	66 90                	xchg   %ax,%ax
80105b5b:	90                   	nop

80105b5c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
80105b5c:	55                   	push   %ebp
80105b5d:	89 e5                	mov    %esp,%ebp
  if(addr >= p->sz || addr+4 > p->sz)
80105b5f:	8b 45 08             	mov    0x8(%ebp),%eax
80105b62:	8b 00                	mov    (%eax),%eax
80105b64:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105b67:	76 0f                	jbe    80105b78 <fetchint+0x1c>
80105b69:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b6c:	8d 50 04             	lea    0x4(%eax),%edx
80105b6f:	8b 45 08             	mov    0x8(%ebp),%eax
80105b72:	8b 00                	mov    (%eax),%eax
80105b74:	39 c2                	cmp    %eax,%edx
80105b76:	76 07                	jbe    80105b7f <fetchint+0x23>
    return -1;
80105b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b7d:	eb 0f                	jmp    80105b8e <fetchint+0x32>
  *ip = *(int*)(addr);
80105b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b82:	8b 10                	mov    (%eax),%edx
80105b84:	8b 45 10             	mov    0x10(%ebp),%eax
80105b87:	89 10                	mov    %edx,(%eax)
  return 0;
80105b89:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b8e:	5d                   	pop    %ebp
80105b8f:	c3                   	ret    

80105b90 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= p->sz)
80105b96:	8b 45 08             	mov    0x8(%ebp),%eax
80105b99:	8b 00                	mov    (%eax),%eax
80105b9b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105b9e:	77 07                	ja     80105ba7 <fetchstr+0x17>
    return -1;
80105ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ba5:	eb 43                	jmp    80105bea <fetchstr+0x5a>
  *pp = (char*)addr;
80105ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
80105baa:	8b 45 10             	mov    0x10(%ebp),%eax
80105bad:	89 10                	mov    %edx,(%eax)
  ep = (char*)p->sz;
80105baf:	8b 45 08             	mov    0x8(%ebp),%eax
80105bb2:	8b 00                	mov    (%eax),%eax
80105bb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105bb7:	8b 45 10             	mov    0x10(%ebp),%eax
80105bba:	8b 00                	mov    (%eax),%eax
80105bbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105bbf:	eb 1c                	jmp    80105bdd <fetchstr+0x4d>
    if(*s == 0)
80105bc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bc4:	8a 00                	mov    (%eax),%al
80105bc6:	84 c0                	test   %al,%al
80105bc8:	75 10                	jne    80105bda <fetchstr+0x4a>
      return s - *pp;
80105bca:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105bcd:	8b 45 10             	mov    0x10(%ebp),%eax
80105bd0:	8b 00                	mov    (%eax),%eax
80105bd2:	89 d1                	mov    %edx,%ecx
80105bd4:	29 c1                	sub    %eax,%ecx
80105bd6:	89 c8                	mov    %ecx,%eax
80105bd8:	eb 10                	jmp    80105bea <fetchstr+0x5a>

  if(addr >= p->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)p->sz;
  for(s = *pp; s < ep; s++)
80105bda:	ff 45 fc             	incl   -0x4(%ebp)
80105bdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105be0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105be3:	72 dc                	jb     80105bc1 <fetchstr+0x31>
    if(*s == 0)
      return s - *pp;
  return -1;
80105be5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bea:	c9                   	leave  
80105beb:	c3                   	ret    

80105bec <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105bec:	55                   	push   %ebp
80105bed:	89 e5                	mov    %esp,%ebp
80105bef:	83 ec 0c             	sub    $0xc,%esp
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
80105bf2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bf8:	8b 40 18             	mov    0x18(%eax),%eax
80105bfb:	8b 50 44             	mov    0x44(%eax),%edx
80105bfe:	8b 45 08             	mov    0x8(%ebp),%eax
80105c01:	c1 e0 02             	shl    $0x2,%eax
80105c04:	01 d0                	add    %edx,%eax
80105c06:	8d 48 04             	lea    0x4(%eax),%ecx
80105c09:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c12:	89 54 24 08          	mov    %edx,0x8(%esp)
80105c16:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80105c1a:	89 04 24             	mov    %eax,(%esp)
80105c1d:	e8 3a ff ff ff       	call   80105b5c <fetchint>
}
80105c22:	c9                   	leave  
80105c23:	c3                   	ret    

80105c24 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105c24:	55                   	push   %ebp
80105c25:	89 e5                	mov    %esp,%ebp
80105c27:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105c2a:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105c2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c31:	8b 45 08             	mov    0x8(%ebp),%eax
80105c34:	89 04 24             	mov    %eax,(%esp)
80105c37:	e8 b0 ff ff ff       	call   80105bec <argint>
80105c3c:	85 c0                	test   %eax,%eax
80105c3e:	79 07                	jns    80105c47 <argptr+0x23>
    return -1;
80105c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c45:	eb 3d                	jmp    80105c84 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105c47:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c4a:	89 c2                	mov    %eax,%edx
80105c4c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c52:	8b 00                	mov    (%eax),%eax
80105c54:	39 c2                	cmp    %eax,%edx
80105c56:	73 16                	jae    80105c6e <argptr+0x4a>
80105c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c5b:	89 c2                	mov    %eax,%edx
80105c5d:	8b 45 10             	mov    0x10(%ebp),%eax
80105c60:	01 c2                	add    %eax,%edx
80105c62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c68:	8b 00                	mov    (%eax),%eax
80105c6a:	39 c2                	cmp    %eax,%edx
80105c6c:	76 07                	jbe    80105c75 <argptr+0x51>
    return -1;
80105c6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c73:	eb 0f                	jmp    80105c84 <argptr+0x60>
  *pp = (char*)i;
80105c75:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c78:	89 c2                	mov    %eax,%edx
80105c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c7d:	89 10                	mov    %edx,(%eax)
  return 0;
80105c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c84:	c9                   	leave  
80105c85:	c3                   	ret    

80105c86 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105c86:	55                   	push   %ebp
80105c87:	89 e5                	mov    %esp,%ebp
80105c89:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105c8c:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c93:	8b 45 08             	mov    0x8(%ebp),%eax
80105c96:	89 04 24             	mov    %eax,(%esp)
80105c99:	e8 4e ff ff ff       	call   80105bec <argint>
80105c9e:	85 c0                	test   %eax,%eax
80105ca0:	79 07                	jns    80105ca9 <argstr+0x23>
    return -1;
80105ca2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca7:	eb 1e                	jmp    80105cc7 <argstr+0x41>
  return fetchstr(proc, addr, pp);
80105ca9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105cac:	89 c2                	mov    %eax,%edx
80105cae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105cb7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105cbb:	89 54 24 04          	mov    %edx,0x4(%esp)
80105cbf:	89 04 24             	mov    %eax,(%esp)
80105cc2:	e8 c9 fe ff ff       	call   80105b90 <fetchstr>
}
80105cc7:	c9                   	leave  
80105cc8:	c3                   	ret    

80105cc9 <syscall>:
[SYS_wait2]     sys_wait2,
};

void
syscall(void)
{
80105cc9:	55                   	push   %ebp
80105cca:	89 e5                	mov    %esp,%ebp
80105ccc:	53                   	push   %ebx
80105ccd:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105cd0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cd6:	8b 40 18             	mov    0x18(%eax),%eax
80105cd9:	8b 40 1c             	mov    0x1c(%eax),%eax
80105cdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num >= 0 && num < SYS_open && syscalls[num]) {
80105cdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ce3:	78 2e                	js     80105d13 <syscall+0x4a>
80105ce5:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
80105ce9:	7f 28                	jg     80105d13 <syscall+0x4a>
80105ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cee:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	74 1a                	je     80105d13 <syscall+0x4a>
    proc->tf->eax = syscalls[num]();
80105cf9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cff:	8b 58 18             	mov    0x18(%eax),%ebx
80105d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d05:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105d0c:	ff d0                	call   *%eax
80105d0e:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105d11:	eb 73                	jmp    80105d86 <syscall+0xbd>
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
80105d13:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
80105d17:	7e 30                	jle    80105d49 <syscall+0x80>
80105d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d1c:	83 f8 17             	cmp    $0x17,%eax
80105d1f:	77 28                	ja     80105d49 <syscall+0x80>
80105d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d24:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105d2b:	85 c0                	test   %eax,%eax
80105d2d:	74 1a                	je     80105d49 <syscall+0x80>
    proc->tf->eax = syscalls[num]();
80105d2f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d35:	8b 58 18             	mov    0x18(%eax),%ebx
80105d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d3b:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105d42:	ff d0                	call   *%eax
80105d44:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105d47:	eb 3d                	jmp    80105d86 <syscall+0xbd>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105d49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d4f:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105d52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(num >= 0 && num < SYS_open && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105d58:	8b 40 10             	mov    0x10(%eax),%eax
80105d5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d5e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105d62:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105d66:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d6a:	c7 04 24 e2 90 10 80 	movl   $0x801090e2,(%esp)
80105d71:	e8 2b a6 ff ff       	call   801003a1 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105d76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d7c:	8b 40 18             	mov    0x18(%eax),%eax
80105d7f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105d86:	83 c4 24             	add    $0x24,%esp
80105d89:	5b                   	pop    %ebx
80105d8a:	5d                   	pop    %ebp
80105d8b:	c3                   	ret    

80105d8c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105d8c:	55                   	push   %ebp
80105d8d:	89 e5                	mov    %esp,%ebp
80105d8f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105d92:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d95:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d99:	8b 45 08             	mov    0x8(%ebp),%eax
80105d9c:	89 04 24             	mov    %eax,(%esp)
80105d9f:	e8 48 fe ff ff       	call   80105bec <argint>
80105da4:	85 c0                	test   %eax,%eax
80105da6:	79 07                	jns    80105daf <argfd+0x23>
    return -1;
80105da8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dad:	eb 50                	jmp    80105dff <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db2:	85 c0                	test   %eax,%eax
80105db4:	78 21                	js     80105dd7 <argfd+0x4b>
80105db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db9:	83 f8 0f             	cmp    $0xf,%eax
80105dbc:	7f 19                	jg     80105dd7 <argfd+0x4b>
80105dbe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105dc7:	83 c2 08             	add    $0x8,%edx
80105dca:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105dd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dd5:	75 07                	jne    80105dde <argfd+0x52>
    return -1;
80105dd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ddc:	eb 21                	jmp    80105dff <argfd+0x73>
  if(pfd)
80105dde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105de2:	74 08                	je     80105dec <argfd+0x60>
    *pfd = fd;
80105de4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105de7:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dea:	89 10                	mov    %edx,(%eax)
  if(pf)
80105dec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105df0:	74 08                	je     80105dfa <argfd+0x6e>
    *pf = f;
80105df2:	8b 45 10             	mov    0x10(%ebp),%eax
80105df5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105df8:	89 10                	mov    %edx,(%eax)
  return 0;
80105dfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105dff:	c9                   	leave  
80105e00:	c3                   	ret    

80105e01 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105e01:	55                   	push   %ebp
80105e02:	89 e5                	mov    %esp,%ebp
80105e04:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105e07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105e0e:	eb 2f                	jmp    80105e3f <fdalloc+0x3e>
    if(proc->ofile[fd] == 0){
80105e10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e16:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105e19:	83 c2 08             	add    $0x8,%edx
80105e1c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105e20:	85 c0                	test   %eax,%eax
80105e22:	75 18                	jne    80105e3c <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105e24:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e2a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105e2d:	8d 4a 08             	lea    0x8(%edx),%ecx
80105e30:	8b 55 08             	mov    0x8(%ebp),%edx
80105e33:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e3a:	eb 0e                	jmp    80105e4a <fdalloc+0x49>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105e3c:	ff 45 fc             	incl   -0x4(%ebp)
80105e3f:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105e43:	7e cb                	jle    80105e10 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105e45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e4a:	c9                   	leave  
80105e4b:	c3                   	ret    

80105e4c <sys_dup>:

int
sys_dup(void)
{
80105e4c:	55                   	push   %ebp
80105e4d:	89 e5                	mov    %esp,%ebp
80105e4f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105e52:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e55:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e60:	00 
80105e61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e68:	e8 1f ff ff ff       	call   80105d8c <argfd>
80105e6d:	85 c0                	test   %eax,%eax
80105e6f:	79 07                	jns    80105e78 <sys_dup+0x2c>
    return -1;
80105e71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e76:	eb 29                	jmp    80105ea1 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e7b:	89 04 24             	mov    %eax,(%esp)
80105e7e:	e8 7e ff ff ff       	call   80105e01 <fdalloc>
80105e83:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e8a:	79 07                	jns    80105e93 <sys_dup+0x47>
    return -1;
80105e8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e91:	eb 0e                	jmp    80105ea1 <sys_dup+0x55>
  filedup(f);
80105e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e96:	89 04 24             	mov    %eax,(%esp)
80105e99:	e8 32 b6 ff ff       	call   801014d0 <filedup>
  return fd;
80105e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105ea1:	c9                   	leave  
80105ea2:	c3                   	ret    

80105ea3 <sys_read>:

int
sys_read(void)
{
80105ea3:	55                   	push   %ebp
80105ea4:	89 e5                	mov    %esp,%ebp
80105ea6:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ea9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eac:	89 44 24 08          	mov    %eax,0x8(%esp)
80105eb0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105eb7:	00 
80105eb8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ebf:	e8 c8 fe ff ff       	call   80105d8c <argfd>
80105ec4:	85 c0                	test   %eax,%eax
80105ec6:	78 35                	js     80105efd <sys_read+0x5a>
80105ec8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ecb:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ecf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105ed6:	e8 11 fd ff ff       	call   80105bec <argint>
80105edb:	85 c0                	test   %eax,%eax
80105edd:	78 1e                	js     80105efd <sys_read+0x5a>
80105edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ee2:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ee6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ef4:	e8 2b fd ff ff       	call   80105c24 <argptr>
80105ef9:	85 c0                	test   %eax,%eax
80105efb:	79 07                	jns    80105f04 <sys_read+0x61>
    return -1;
80105efd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f02:	eb 19                	jmp    80105f1d <sys_read+0x7a>
  return fileread(f, p, n);
80105f04:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105f07:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105f11:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f15:	89 04 24             	mov    %eax,(%esp)
80105f18:	e8 14 b7 ff ff       	call   80101631 <fileread>
}
80105f1d:	c9                   	leave  
80105f1e:	c3                   	ret    

80105f1f <sys_write>:

int
sys_write(void)
{
80105f1f:	55                   	push   %ebp
80105f20:	89 e5                	mov    %esp,%ebp
80105f22:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105f25:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f28:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f2c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105f33:	00 
80105f34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f3b:	e8 4c fe ff ff       	call   80105d8c <argfd>
80105f40:	85 c0                	test   %eax,%eax
80105f42:	78 35                	js     80105f79 <sys_write+0x5a>
80105f44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f47:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f4b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105f52:	e8 95 fc ff ff       	call   80105bec <argint>
80105f57:	85 c0                	test   %eax,%eax
80105f59:	78 1e                	js     80105f79 <sys_write+0x5a>
80105f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f5e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f62:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f65:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f70:	e8 af fc ff ff       	call   80105c24 <argptr>
80105f75:	85 c0                	test   %eax,%eax
80105f77:	79 07                	jns    80105f80 <sys_write+0x61>
    return -1;
80105f79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f7e:	eb 19                	jmp    80105f99 <sys_write+0x7a>
  return filewrite(f, p, n);
80105f80:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105f83:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105f8d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f91:	89 04 24             	mov    %eax,(%esp)
80105f94:	e8 53 b7 ff ff       	call   801016ec <filewrite>
}
80105f99:	c9                   	leave  
80105f9a:	c3                   	ret    

80105f9b <sys_close>:

int
sys_close(void)
{
80105f9b:	55                   	push   %ebp
80105f9c:	89 e5                	mov    %esp,%ebp
80105f9e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105fa1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fa4:	89 44 24 08          	mov    %eax,0x8(%esp)
80105fa8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fab:	89 44 24 04          	mov    %eax,0x4(%esp)
80105faf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fb6:	e8 d1 fd ff ff       	call   80105d8c <argfd>
80105fbb:	85 c0                	test   %eax,%eax
80105fbd:	79 07                	jns    80105fc6 <sys_close+0x2b>
    return -1;
80105fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc4:	eb 24                	jmp    80105fea <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105fc6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105fcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fcf:	83 c2 08             	add    $0x8,%edx
80105fd2:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105fd9:	00 
  fileclose(f);
80105fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fdd:	89 04 24             	mov    %eax,(%esp)
80105fe0:	e8 33 b5 ff ff       	call   80101518 <fileclose>
  return 0;
80105fe5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105fea:	c9                   	leave  
80105feb:	c3                   	ret    

80105fec <sys_fstat>:

int
sys_fstat(void)
{
80105fec:	55                   	push   %ebp
80105fed:	89 e5                	mov    %esp,%ebp
80105fef:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105ff2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ff5:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ff9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106000:	00 
80106001:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106008:	e8 7f fd ff ff       	call   80105d8c <argfd>
8010600d:	85 c0                	test   %eax,%eax
8010600f:	78 1f                	js     80106030 <sys_fstat+0x44>
80106011:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80106018:	00 
80106019:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010601c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106020:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106027:	e8 f8 fb ff ff       	call   80105c24 <argptr>
8010602c:	85 c0                	test   %eax,%eax
8010602e:	79 07                	jns    80106037 <sys_fstat+0x4b>
    return -1;
80106030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106035:	eb 12                	jmp    80106049 <sys_fstat+0x5d>
  return filestat(f, st);
80106037:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010603a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010603d:	89 54 24 04          	mov    %edx,0x4(%esp)
80106041:	89 04 24             	mov    %eax,(%esp)
80106044:	e8 99 b5 ff ff       	call   801015e2 <filestat>
}
80106049:	c9                   	leave  
8010604a:	c3                   	ret    

8010604b <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010604b:	55                   	push   %ebp
8010604c:	89 e5                	mov    %esp,%ebp
8010604e:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106051:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106054:	89 44 24 04          	mov    %eax,0x4(%esp)
80106058:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010605f:	e8 22 fc ff ff       	call   80105c86 <argstr>
80106064:	85 c0                	test   %eax,%eax
80106066:	78 17                	js     8010607f <sys_link+0x34>
80106068:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010606b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010606f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106076:	e8 0b fc ff ff       	call   80105c86 <argstr>
8010607b:	85 c0                	test   %eax,%eax
8010607d:	79 0a                	jns    80106089 <sys_link+0x3e>
    return -1;
8010607f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106084:	e9 37 01 00 00       	jmp    801061c0 <sys_link+0x175>
  if((ip = namei(old)) == 0)
80106089:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010608c:	89 04 24             	mov    %eax,(%esp)
8010608f:	e8 a4 c8 ff ff       	call   80102938 <namei>
80106094:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106097:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010609b:	75 0a                	jne    801060a7 <sys_link+0x5c>
    return -1;
8010609d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060a2:	e9 19 01 00 00       	jmp    801061c0 <sys_link+0x175>

  begin_trans();
801060a7:	e8 7f d6 ff ff       	call   8010372b <begin_trans>

  ilock(ip);
801060ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060af:	89 04 24             	mov    %eax,(%esp)
801060b2:	e8 e7 bc ff ff       	call   80101d9e <ilock>
  if(ip->type == T_DIR){
801060b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ba:	8b 40 10             	mov    0x10(%eax),%eax
801060bd:	66 83 f8 01          	cmp    $0x1,%ax
801060c1:	75 1a                	jne    801060dd <sys_link+0x92>
    iunlockput(ip);
801060c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c6:	89 04 24             	mov    %eax,(%esp)
801060c9:	e8 51 bf ff ff       	call   8010201f <iunlockput>
    commit_trans();
801060ce:	e8 a1 d6 ff ff       	call   80103774 <commit_trans>
    return -1;
801060d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060d8:	e9 e3 00 00 00       	jmp    801061c0 <sys_link+0x175>
  }

  ip->nlink++;
801060dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e0:	66 8b 40 16          	mov    0x16(%eax),%ax
801060e4:	40                   	inc    %eax
801060e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060e8:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
801060ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ef:	89 04 24             	mov    %eax,(%esp)
801060f2:	e8 ed ba ff ff       	call   80101be4 <iupdate>
  iunlock(ip);
801060f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060fa:	89 04 24             	mov    %eax,(%esp)
801060fd:	e8 e7 bd ff ff       	call   80101ee9 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80106102:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106105:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106108:	89 54 24 04          	mov    %edx,0x4(%esp)
8010610c:	89 04 24             	mov    %eax,(%esp)
8010610f:	e8 46 c8 ff ff       	call   8010295a <nameiparent>
80106114:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106117:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010611b:	74 68                	je     80106185 <sys_link+0x13a>
    goto bad;
  ilock(dp);
8010611d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106120:	89 04 24             	mov    %eax,(%esp)
80106123:	e8 76 bc ff ff       	call   80101d9e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106128:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010612b:	8b 10                	mov    (%eax),%edx
8010612d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106130:	8b 00                	mov    (%eax),%eax
80106132:	39 c2                	cmp    %eax,%edx
80106134:	75 20                	jne    80106156 <sys_link+0x10b>
80106136:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106139:	8b 40 04             	mov    0x4(%eax),%eax
8010613c:	89 44 24 08          	mov    %eax,0x8(%esp)
80106140:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106143:	89 44 24 04          	mov    %eax,0x4(%esp)
80106147:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010614a:	89 04 24             	mov    %eax,(%esp)
8010614d:	e8 2f c5 ff ff       	call   80102681 <dirlink>
80106152:	85 c0                	test   %eax,%eax
80106154:	79 0d                	jns    80106163 <sys_link+0x118>
    iunlockput(dp);
80106156:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106159:	89 04 24             	mov    %eax,(%esp)
8010615c:	e8 be be ff ff       	call   8010201f <iunlockput>
    goto bad;
80106161:	eb 23                	jmp    80106186 <sys_link+0x13b>
  }
  iunlockput(dp);
80106163:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106166:	89 04 24             	mov    %eax,(%esp)
80106169:	e8 b1 be ff ff       	call   8010201f <iunlockput>
  iput(ip);
8010616e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106171:	89 04 24             	mov    %eax,(%esp)
80106174:	e8 d5 bd ff ff       	call   80101f4e <iput>

  commit_trans();
80106179:	e8 f6 d5 ff ff       	call   80103774 <commit_trans>

  return 0;
8010617e:	b8 00 00 00 00       	mov    $0x0,%eax
80106183:	eb 3b                	jmp    801061c0 <sys_link+0x175>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80106185:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
80106186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106189:	89 04 24             	mov    %eax,(%esp)
8010618c:	e8 0d bc ff ff       	call   80101d9e <ilock>
  ip->nlink--;
80106191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106194:	66 8b 40 16          	mov    0x16(%eax),%ax
80106198:	48                   	dec    %eax
80106199:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010619c:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
801061a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a3:	89 04 24             	mov    %eax,(%esp)
801061a6:	e8 39 ba ff ff       	call   80101be4 <iupdate>
  iunlockput(ip);
801061ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ae:	89 04 24             	mov    %eax,(%esp)
801061b1:	e8 69 be ff ff       	call   8010201f <iunlockput>
  commit_trans();
801061b6:	e8 b9 d5 ff ff       	call   80103774 <commit_trans>
  return -1;
801061bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061c0:	c9                   	leave  
801061c1:	c3                   	ret    

801061c2 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801061c2:	55                   	push   %ebp
801061c3:	89 e5                	mov    %esp,%ebp
801061c5:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801061c8:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801061cf:	eb 4a                	jmp    8010621b <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801061d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801061db:	00 
801061dc:	89 44 24 08          	mov    %eax,0x8(%esp)
801061e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801061e7:	8b 45 08             	mov    0x8(%ebp),%eax
801061ea:	89 04 24             	mov    %eax,(%esp)
801061ed:	e8 b3 c0 ff ff       	call   801022a5 <readi>
801061f2:	83 f8 10             	cmp    $0x10,%eax
801061f5:	74 0c                	je     80106203 <isdirempty+0x41>
      panic("isdirempty: readi");
801061f7:	c7 04 24 fe 90 10 80 	movl   $0x801090fe,(%esp)
801061fe:	e8 33 a3 ff ff       	call   80100536 <panic>
    if(de.inum != 0)
80106203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106206:	66 85 c0             	test   %ax,%ax
80106209:	74 07                	je     80106212 <isdirempty+0x50>
      return 0;
8010620b:	b8 00 00 00 00       	mov    $0x0,%eax
80106210:	eb 1b                	jmp    8010622d <isdirempty+0x6b>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106212:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106215:	83 c0 10             	add    $0x10,%eax
80106218:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010621b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010621e:	8b 45 08             	mov    0x8(%ebp),%eax
80106221:	8b 40 18             	mov    0x18(%eax),%eax
80106224:	39 c2                	cmp    %eax,%edx
80106226:	72 a9                	jb     801061d1 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106228:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010622d:	c9                   	leave  
8010622e:	c3                   	ret    

8010622f <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010622f:	55                   	push   %ebp
80106230:	89 e5                	mov    %esp,%ebp
80106232:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106235:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106238:	89 44 24 04          	mov    %eax,0x4(%esp)
8010623c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106243:	e8 3e fa ff ff       	call   80105c86 <argstr>
80106248:	85 c0                	test   %eax,%eax
8010624a:	79 0a                	jns    80106256 <sys_unlink+0x27>
    return -1;
8010624c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106251:	e9 a4 01 00 00       	jmp    801063fa <sys_unlink+0x1cb>
  if((dp = nameiparent(path, name)) == 0)
80106256:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106259:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010625c:	89 54 24 04          	mov    %edx,0x4(%esp)
80106260:	89 04 24             	mov    %eax,(%esp)
80106263:	e8 f2 c6 ff ff       	call   8010295a <nameiparent>
80106268:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010626b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010626f:	75 0a                	jne    8010627b <sys_unlink+0x4c>
    return -1;
80106271:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106276:	e9 7f 01 00 00       	jmp    801063fa <sys_unlink+0x1cb>

  begin_trans();
8010627b:	e8 ab d4 ff ff       	call   8010372b <begin_trans>

  ilock(dp);
80106280:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106283:	89 04 24             	mov    %eax,(%esp)
80106286:	e8 13 bb ff ff       	call   80101d9e <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010628b:	c7 44 24 04 10 91 10 	movl   $0x80109110,0x4(%esp)
80106292:	80 
80106293:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106296:	89 04 24             	mov    %eax,(%esp)
80106299:	e8 fc c2 ff ff       	call   8010259a <namecmp>
8010629e:	85 c0                	test   %eax,%eax
801062a0:	0f 84 3f 01 00 00    	je     801063e5 <sys_unlink+0x1b6>
801062a6:	c7 44 24 04 12 91 10 	movl   $0x80109112,0x4(%esp)
801062ad:	80 
801062ae:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801062b1:	89 04 24             	mov    %eax,(%esp)
801062b4:	e8 e1 c2 ff ff       	call   8010259a <namecmp>
801062b9:	85 c0                	test   %eax,%eax
801062bb:	0f 84 24 01 00 00    	je     801063e5 <sys_unlink+0x1b6>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801062c1:	8d 45 c8             	lea    -0x38(%ebp),%eax
801062c4:	89 44 24 08          	mov    %eax,0x8(%esp)
801062c8:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801062cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801062cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d2:	89 04 24             	mov    %eax,(%esp)
801062d5:	e8 e2 c2 ff ff       	call   801025bc <dirlookup>
801062da:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062e1:	0f 84 fd 00 00 00    	je     801063e4 <sys_unlink+0x1b5>
    goto bad;
  ilock(ip);
801062e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062ea:	89 04 24             	mov    %eax,(%esp)
801062ed:	e8 ac ba ff ff       	call   80101d9e <ilock>

  if(ip->nlink < 1)
801062f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062f5:	66 8b 40 16          	mov    0x16(%eax),%ax
801062f9:	66 85 c0             	test   %ax,%ax
801062fc:	7f 0c                	jg     8010630a <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
801062fe:	c7 04 24 15 91 10 80 	movl   $0x80109115,(%esp)
80106305:	e8 2c a2 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010630a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010630d:	8b 40 10             	mov    0x10(%eax),%eax
80106310:	66 83 f8 01          	cmp    $0x1,%ax
80106314:	75 1f                	jne    80106335 <sys_unlink+0x106>
80106316:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106319:	89 04 24             	mov    %eax,(%esp)
8010631c:	e8 a1 fe ff ff       	call   801061c2 <isdirempty>
80106321:	85 c0                	test   %eax,%eax
80106323:	75 10                	jne    80106335 <sys_unlink+0x106>
    iunlockput(ip);
80106325:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106328:	89 04 24             	mov    %eax,(%esp)
8010632b:	e8 ef bc ff ff       	call   8010201f <iunlockput>
    goto bad;
80106330:	e9 b0 00 00 00       	jmp    801063e5 <sys_unlink+0x1b6>
  }

  memset(&de, 0, sizeof(de));
80106335:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010633c:	00 
8010633d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106344:	00 
80106345:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106348:	89 04 24             	mov    %eax,(%esp)
8010634b:	e8 22 f5 ff ff       	call   80105872 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106350:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106353:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010635a:	00 
8010635b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010635f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106362:	89 44 24 04          	mov    %eax,0x4(%esp)
80106366:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106369:	89 04 24             	mov    %eax,(%esp)
8010636c:	e8 99 c0 ff ff       	call   8010240a <writei>
80106371:	83 f8 10             	cmp    $0x10,%eax
80106374:	74 0c                	je     80106382 <sys_unlink+0x153>
    panic("unlink: writei");
80106376:	c7 04 24 27 91 10 80 	movl   $0x80109127,(%esp)
8010637d:	e8 b4 a1 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR){
80106382:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106385:	8b 40 10             	mov    0x10(%eax),%eax
80106388:	66 83 f8 01          	cmp    $0x1,%ax
8010638c:	75 1a                	jne    801063a8 <sys_unlink+0x179>
    dp->nlink--;
8010638e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106391:	66 8b 40 16          	mov    0x16(%eax),%ax
80106395:	48                   	dec    %eax
80106396:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106399:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
8010639d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a0:	89 04 24             	mov    %eax,(%esp)
801063a3:	e8 3c b8 ff ff       	call   80101be4 <iupdate>
  }
  iunlockput(dp);
801063a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ab:	89 04 24             	mov    %eax,(%esp)
801063ae:	e8 6c bc ff ff       	call   8010201f <iunlockput>

  ip->nlink--;
801063b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b6:	66 8b 40 16          	mov    0x16(%eax),%ax
801063ba:	48                   	dec    %eax
801063bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801063be:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
801063c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063c5:	89 04 24             	mov    %eax,(%esp)
801063c8:	e8 17 b8 ff ff       	call   80101be4 <iupdate>
  iunlockput(ip);
801063cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063d0:	89 04 24             	mov    %eax,(%esp)
801063d3:	e8 47 bc ff ff       	call   8010201f <iunlockput>

  commit_trans();
801063d8:	e8 97 d3 ff ff       	call   80103774 <commit_trans>

  return 0;
801063dd:	b8 00 00 00 00       	mov    $0x0,%eax
801063e2:	eb 16                	jmp    801063fa <sys_unlink+0x1cb>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
801063e4:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
801063e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063e8:	89 04 24             	mov    %eax,(%esp)
801063eb:	e8 2f bc ff ff       	call   8010201f <iunlockput>
  commit_trans();
801063f0:	e8 7f d3 ff ff       	call   80103774 <commit_trans>
  return -1;
801063f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063fa:	c9                   	leave  
801063fb:	c3                   	ret    

801063fc <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801063fc:	55                   	push   %ebp
801063fd:	89 e5                	mov    %esp,%ebp
801063ff:	83 ec 48             	sub    $0x48,%esp
80106402:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106405:	8b 55 10             	mov    0x10(%ebp),%edx
80106408:	8b 45 14             	mov    0x14(%ebp),%eax
8010640b:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010640f:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106413:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106417:	8d 45 de             	lea    -0x22(%ebp),%eax
8010641a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010641e:	8b 45 08             	mov    0x8(%ebp),%eax
80106421:	89 04 24             	mov    %eax,(%esp)
80106424:	e8 31 c5 ff ff       	call   8010295a <nameiparent>
80106429:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010642c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106430:	75 0a                	jne    8010643c <create+0x40>
    return 0;
80106432:	b8 00 00 00 00       	mov    $0x0,%eax
80106437:	e9 79 01 00 00       	jmp    801065b5 <create+0x1b9>
  ilock(dp);
8010643c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010643f:	89 04 24             	mov    %eax,(%esp)
80106442:	e8 57 b9 ff ff       	call   80101d9e <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80106447:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010644a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010644e:	8d 45 de             	lea    -0x22(%ebp),%eax
80106451:	89 44 24 04          	mov    %eax,0x4(%esp)
80106455:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106458:	89 04 24             	mov    %eax,(%esp)
8010645b:	e8 5c c1 ff ff       	call   801025bc <dirlookup>
80106460:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106463:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106467:	74 46                	je     801064af <create+0xb3>
    iunlockput(dp);
80106469:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010646c:	89 04 24             	mov    %eax,(%esp)
8010646f:	e8 ab bb ff ff       	call   8010201f <iunlockput>
    ilock(ip);
80106474:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106477:	89 04 24             	mov    %eax,(%esp)
8010647a:	e8 1f b9 ff ff       	call   80101d9e <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010647f:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106484:	75 14                	jne    8010649a <create+0x9e>
80106486:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106489:	8b 40 10             	mov    0x10(%eax),%eax
8010648c:	66 83 f8 02          	cmp    $0x2,%ax
80106490:	75 08                	jne    8010649a <create+0x9e>
      return ip;
80106492:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106495:	e9 1b 01 00 00       	jmp    801065b5 <create+0x1b9>
    iunlockput(ip);
8010649a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010649d:	89 04 24             	mov    %eax,(%esp)
801064a0:	e8 7a bb ff ff       	call   8010201f <iunlockput>
    return 0;
801064a5:	b8 00 00 00 00       	mov    $0x0,%eax
801064aa:	e9 06 01 00 00       	jmp    801065b5 <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801064af:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801064b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064b6:	8b 00                	mov    (%eax),%eax
801064b8:	89 54 24 04          	mov    %edx,0x4(%esp)
801064bc:	89 04 24             	mov    %eax,(%esp)
801064bf:	e8 44 b6 ff ff       	call   80101b08 <ialloc>
801064c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064cb:	75 0c                	jne    801064d9 <create+0xdd>
    panic("create: ialloc");
801064cd:	c7 04 24 36 91 10 80 	movl   $0x80109136,(%esp)
801064d4:	e8 5d a0 ff ff       	call   80100536 <panic>

  ilock(ip);
801064d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064dc:	89 04 24             	mov    %eax,(%esp)
801064df:	e8 ba b8 ff ff       	call   80101d9e <ilock>
  ip->major = major;
801064e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801064e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
801064ea:	66 89 42 12          	mov    %ax,0x12(%edx)
  ip->minor = minor;
801064ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
801064f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801064f4:	66 89 42 14          	mov    %ax,0x14(%edx)
  ip->nlink = 1;
801064f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064fb:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106501:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106504:	89 04 24             	mov    %eax,(%esp)
80106507:	e8 d8 b6 ff ff       	call   80101be4 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
8010650c:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106511:	75 68                	jne    8010657b <create+0x17f>
    dp->nlink++;  // for ".."
80106513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106516:	66 8b 40 16          	mov    0x16(%eax),%ax
8010651a:	40                   	inc    %eax
8010651b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010651e:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80106522:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106525:	89 04 24             	mov    %eax,(%esp)
80106528:	e8 b7 b6 ff ff       	call   80101be4 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010652d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106530:	8b 40 04             	mov    0x4(%eax),%eax
80106533:	89 44 24 08          	mov    %eax,0x8(%esp)
80106537:	c7 44 24 04 10 91 10 	movl   $0x80109110,0x4(%esp)
8010653e:	80 
8010653f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106542:	89 04 24             	mov    %eax,(%esp)
80106545:	e8 37 c1 ff ff       	call   80102681 <dirlink>
8010654a:	85 c0                	test   %eax,%eax
8010654c:	78 21                	js     8010656f <create+0x173>
8010654e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106551:	8b 40 04             	mov    0x4(%eax),%eax
80106554:	89 44 24 08          	mov    %eax,0x8(%esp)
80106558:	c7 44 24 04 12 91 10 	movl   $0x80109112,0x4(%esp)
8010655f:	80 
80106560:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106563:	89 04 24             	mov    %eax,(%esp)
80106566:	e8 16 c1 ff ff       	call   80102681 <dirlink>
8010656b:	85 c0                	test   %eax,%eax
8010656d:	79 0c                	jns    8010657b <create+0x17f>
      panic("create dots");
8010656f:	c7 04 24 45 91 10 80 	movl   $0x80109145,(%esp)
80106576:	e8 bb 9f ff ff       	call   80100536 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010657b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010657e:	8b 40 04             	mov    0x4(%eax),%eax
80106581:	89 44 24 08          	mov    %eax,0x8(%esp)
80106585:	8d 45 de             	lea    -0x22(%ebp),%eax
80106588:	89 44 24 04          	mov    %eax,0x4(%esp)
8010658c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010658f:	89 04 24             	mov    %eax,(%esp)
80106592:	e8 ea c0 ff ff       	call   80102681 <dirlink>
80106597:	85 c0                	test   %eax,%eax
80106599:	79 0c                	jns    801065a7 <create+0x1ab>
    panic("create: dirlink");
8010659b:	c7 04 24 51 91 10 80 	movl   $0x80109151,(%esp)
801065a2:	e8 8f 9f ff ff       	call   80100536 <panic>

  iunlockput(dp);
801065a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065aa:	89 04 24             	mov    %eax,(%esp)
801065ad:	e8 6d ba ff ff       	call   8010201f <iunlockput>

  return ip;
801065b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801065b5:	c9                   	leave  
801065b6:	c3                   	ret    

801065b7 <sys_open>:

int
sys_open(void)
{
801065b7:	55                   	push   %ebp
801065b8:	89 e5                	mov    %esp,%ebp
801065ba:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801065bd:	8d 45 e8             	lea    -0x18(%ebp),%eax
801065c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801065c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065cb:	e8 b6 f6 ff ff       	call   80105c86 <argstr>
801065d0:	85 c0                	test   %eax,%eax
801065d2:	78 17                	js     801065eb <sys_open+0x34>
801065d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801065d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801065db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801065e2:	e8 05 f6 ff ff       	call   80105bec <argint>
801065e7:	85 c0                	test   %eax,%eax
801065e9:	79 0a                	jns    801065f5 <sys_open+0x3e>
    return -1;
801065eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065f0:	e9 47 01 00 00       	jmp    8010673c <sys_open+0x185>
  if(omode & O_CREATE){
801065f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065f8:	25 00 02 00 00       	and    $0x200,%eax
801065fd:	85 c0                	test   %eax,%eax
801065ff:	74 40                	je     80106641 <sys_open+0x8a>
    begin_trans();
80106601:	e8 25 d1 ff ff       	call   8010372b <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80106606:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106609:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106610:	00 
80106611:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106618:	00 
80106619:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80106620:	00 
80106621:	89 04 24             	mov    %eax,(%esp)
80106624:	e8 d3 fd ff ff       	call   801063fc <create>
80106629:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
8010662c:	e8 43 d1 ff ff       	call   80103774 <commit_trans>
    if(ip == 0)
80106631:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106635:	75 5b                	jne    80106692 <sys_open+0xdb>
      return -1;
80106637:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010663c:	e9 fb 00 00 00       	jmp    8010673c <sys_open+0x185>
  } else {
    if((ip = namei(path)) == 0)
80106641:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106644:	89 04 24             	mov    %eax,(%esp)
80106647:	e8 ec c2 ff ff       	call   80102938 <namei>
8010664c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010664f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106653:	75 0a                	jne    8010665f <sys_open+0xa8>
      return -1;
80106655:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010665a:	e9 dd 00 00 00       	jmp    8010673c <sys_open+0x185>
    ilock(ip);
8010665f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106662:	89 04 24             	mov    %eax,(%esp)
80106665:	e8 34 b7 ff ff       	call   80101d9e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010666a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010666d:	8b 40 10             	mov    0x10(%eax),%eax
80106670:	66 83 f8 01          	cmp    $0x1,%ax
80106674:	75 1c                	jne    80106692 <sys_open+0xdb>
80106676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106679:	85 c0                	test   %eax,%eax
8010667b:	74 15                	je     80106692 <sys_open+0xdb>
      iunlockput(ip);
8010667d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106680:	89 04 24             	mov    %eax,(%esp)
80106683:	e8 97 b9 ff ff       	call   8010201f <iunlockput>
      return -1;
80106688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010668d:	e9 aa 00 00 00       	jmp    8010673c <sys_open+0x185>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106692:	e8 d9 ad ff ff       	call   80101470 <filealloc>
80106697:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010669a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010669e:	74 14                	je     801066b4 <sys_open+0xfd>
801066a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066a3:	89 04 24             	mov    %eax,(%esp)
801066a6:	e8 56 f7 ff ff       	call   80105e01 <fdalloc>
801066ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
801066ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801066b2:	79 23                	jns    801066d7 <sys_open+0x120>
    if(f)
801066b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066b8:	74 0b                	je     801066c5 <sys_open+0x10e>
      fileclose(f);
801066ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066bd:	89 04 24             	mov    %eax,(%esp)
801066c0:	e8 53 ae ff ff       	call   80101518 <fileclose>
    iunlockput(ip);
801066c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c8:	89 04 24             	mov    %eax,(%esp)
801066cb:	e8 4f b9 ff ff       	call   8010201f <iunlockput>
    return -1;
801066d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066d5:	eb 65                	jmp    8010673c <sys_open+0x185>
  }
  iunlock(ip);
801066d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066da:	89 04 24             	mov    %eax,(%esp)
801066dd:	e8 07 b8 ff ff       	call   80101ee9 <iunlock>

  f->type = FD_INODE;
801066e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066e5:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801066eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066f1:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801066f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066f7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801066fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106701:	83 e0 01             	and    $0x1,%eax
80106704:	85 c0                	test   %eax,%eax
80106706:	0f 94 c0             	sete   %al
80106709:	88 c2                	mov    %al,%dl
8010670b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010670e:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106714:	83 e0 01             	and    $0x1,%eax
80106717:	85 c0                	test   %eax,%eax
80106719:	75 0a                	jne    80106725 <sys_open+0x16e>
8010671b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010671e:	83 e0 02             	and    $0x2,%eax
80106721:	85 c0                	test   %eax,%eax
80106723:	74 07                	je     8010672c <sys_open+0x175>
80106725:	b8 01 00 00 00       	mov    $0x1,%eax
8010672a:	eb 05                	jmp    80106731 <sys_open+0x17a>
8010672c:	b8 00 00 00 00       	mov    $0x0,%eax
80106731:	88 c2                	mov    %al,%dl
80106733:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106736:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106739:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010673c:	c9                   	leave  
8010673d:	c3                   	ret    

8010673e <sys_mkdir>:

int
sys_mkdir(void)
{
8010673e:	55                   	push   %ebp
8010673f:	89 e5                	mov    %esp,%ebp
80106741:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80106744:	e8 e2 cf ff ff       	call   8010372b <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106749:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010674c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106750:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106757:	e8 2a f5 ff ff       	call   80105c86 <argstr>
8010675c:	85 c0                	test   %eax,%eax
8010675e:	78 2c                	js     8010678c <sys_mkdir+0x4e>
80106760:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106763:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010676a:	00 
8010676b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106772:	00 
80106773:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010677a:	00 
8010677b:	89 04 24             	mov    %eax,(%esp)
8010677e:	e8 79 fc ff ff       	call   801063fc <create>
80106783:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106786:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010678a:	75 0c                	jne    80106798 <sys_mkdir+0x5a>
    commit_trans();
8010678c:	e8 e3 cf ff ff       	call   80103774 <commit_trans>
    return -1;
80106791:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106796:	eb 15                	jmp    801067ad <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80106798:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010679b:	89 04 24             	mov    %eax,(%esp)
8010679e:	e8 7c b8 ff ff       	call   8010201f <iunlockput>
  commit_trans();
801067a3:	e8 cc cf ff ff       	call   80103774 <commit_trans>
  return 0;
801067a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067ad:	c9                   	leave  
801067ae:	c3                   	ret    

801067af <sys_mknod>:

int
sys_mknod(void)
{
801067af:	55                   	push   %ebp
801067b0:	89 e5                	mov    %esp,%ebp
801067b2:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
801067b5:	e8 71 cf ff ff       	call   8010372b <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
801067ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
801067bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801067c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067c8:	e8 b9 f4 ff ff       	call   80105c86 <argstr>
801067cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801067d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067d4:	78 5e                	js     80106834 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
801067d6:	8d 45 e8             	lea    -0x18(%ebp),%eax
801067d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801067dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801067e4:	e8 03 f4 ff ff       	call   80105bec <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
801067e9:	85 c0                	test   %eax,%eax
801067eb:	78 47                	js     80106834 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801067ed:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801067f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801067f4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801067fb:	e8 ec f3 ff ff       	call   80105bec <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106800:	85 c0                	test   %eax,%eax
80106802:	78 30                	js     80106834 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106804:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106807:	0f bf c8             	movswl %ax,%ecx
8010680a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010680d:	0f bf d0             	movswl %ax,%edx
80106810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106813:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106817:	89 54 24 08          	mov    %edx,0x8(%esp)
8010681b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106822:	00 
80106823:	89 04 24             	mov    %eax,(%esp)
80106826:	e8 d1 fb ff ff       	call   801063fc <create>
8010682b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010682e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106832:	75 0c                	jne    80106840 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80106834:	e8 3b cf ff ff       	call   80103774 <commit_trans>
    return -1;
80106839:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010683e:	eb 15                	jmp    80106855 <sys_mknod+0xa6>
  }
  iunlockput(ip);
80106840:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106843:	89 04 24             	mov    %eax,(%esp)
80106846:	e8 d4 b7 ff ff       	call   8010201f <iunlockput>
  commit_trans();
8010684b:	e8 24 cf ff ff       	call   80103774 <commit_trans>
  return 0;
80106850:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106855:	c9                   	leave  
80106856:	c3                   	ret    

80106857 <sys_chdir>:

int
sys_chdir(void)
{
80106857:	55                   	push   %ebp
80106858:	89 e5                	mov    %esp,%ebp
8010685a:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
8010685d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106860:	89 44 24 04          	mov    %eax,0x4(%esp)
80106864:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010686b:	e8 16 f4 ff ff       	call   80105c86 <argstr>
80106870:	85 c0                	test   %eax,%eax
80106872:	78 14                	js     80106888 <sys_chdir+0x31>
80106874:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106877:	89 04 24             	mov    %eax,(%esp)
8010687a:	e8 b9 c0 ff ff       	call   80102938 <namei>
8010687f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106882:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106886:	75 07                	jne    8010688f <sys_chdir+0x38>
    return -1;
80106888:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010688d:	eb 56                	jmp    801068e5 <sys_chdir+0x8e>
  ilock(ip);
8010688f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106892:	89 04 24             	mov    %eax,(%esp)
80106895:	e8 04 b5 ff ff       	call   80101d9e <ilock>
  if(ip->type != T_DIR){
8010689a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010689d:	8b 40 10             	mov    0x10(%eax),%eax
801068a0:	66 83 f8 01          	cmp    $0x1,%ax
801068a4:	74 12                	je     801068b8 <sys_chdir+0x61>
    iunlockput(ip);
801068a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068a9:	89 04 24             	mov    %eax,(%esp)
801068ac:	e8 6e b7 ff ff       	call   8010201f <iunlockput>
    return -1;
801068b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068b6:	eb 2d                	jmp    801068e5 <sys_chdir+0x8e>
  }
  iunlock(ip);
801068b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068bb:	89 04 24             	mov    %eax,(%esp)
801068be:	e8 26 b6 ff ff       	call   80101ee9 <iunlock>
  iput(proc->cwd);
801068c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068c9:	8b 40 68             	mov    0x68(%eax),%eax
801068cc:	89 04 24             	mov    %eax,(%esp)
801068cf:	e8 7a b6 ff ff       	call   80101f4e <iput>
  proc->cwd = ip;
801068d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068da:	8b 55 f4             	mov    -0xc(%ebp),%edx
801068dd:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801068e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068e5:	c9                   	leave  
801068e6:	c3                   	ret    

801068e7 <sys_exec>:

int
sys_exec(void)
{
801068e7:	55                   	push   %ebp
801068e8:	89 e5                	mov    %esp,%ebp
801068ea:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801068f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801068f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068fe:	e8 83 f3 ff ff       	call   80105c86 <argstr>
80106903:	85 c0                	test   %eax,%eax
80106905:	78 1a                	js     80106921 <sys_exec+0x3a>
80106907:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010690d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106911:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106918:	e8 cf f2 ff ff       	call   80105bec <argint>
8010691d:	85 c0                	test   %eax,%eax
8010691f:	79 0a                	jns    8010692b <sys_exec+0x44>
    return -1;
80106921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106926:	e9 dd 00 00 00       	jmp    80106a08 <sys_exec+0x121>
  }
  memset(argv, 0, sizeof(argv));
8010692b:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106932:	00 
80106933:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010693a:	00 
8010693b:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106941:	89 04 24             	mov    %eax,(%esp)
80106944:	e8 29 ef ff ff       	call   80105872 <memset>
  for(i=0;; i++){
80106949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106950:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106953:	83 f8 1f             	cmp    $0x1f,%eax
80106956:	76 0a                	jbe    80106962 <sys_exec+0x7b>
      return -1;
80106958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010695d:	e9 a6 00 00 00       	jmp    80106a08 <sys_exec+0x121>
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
80106962:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106965:	c1 e0 02             	shl    $0x2,%eax
80106968:	89 c2                	mov    %eax,%edx
8010696a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106970:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80106973:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106979:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
8010697f:	89 54 24 08          	mov    %edx,0x8(%esp)
80106983:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80106987:	89 04 24             	mov    %eax,(%esp)
8010698a:	e8 cd f1 ff ff       	call   80105b5c <fetchint>
8010698f:	85 c0                	test   %eax,%eax
80106991:	79 07                	jns    8010699a <sys_exec+0xb3>
      return -1;
80106993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106998:	eb 6e                	jmp    80106a08 <sys_exec+0x121>
    if(uarg == 0){
8010699a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801069a0:	85 c0                	test   %eax,%eax
801069a2:	75 26                	jne    801069ca <sys_exec+0xe3>
      argv[i] = 0;
801069a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069a7:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801069ae:	00 00 00 00 
      break;
801069b2:	90                   	nop
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801069b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069b6:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801069bc:	89 54 24 04          	mov    %edx,0x4(%esp)
801069c0:	89 04 24             	mov    %eax,(%esp)
801069c3:	e8 d6 a5 ff ff       	call   80100f9e <exec>
801069c8:	eb 3e                	jmp    80106a08 <sys_exec+0x121>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
801069ca:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801069d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069d3:	c1 e2 02             	shl    $0x2,%edx
801069d6:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
801069d9:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
801069df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069e5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801069e9:	89 54 24 04          	mov    %edx,0x4(%esp)
801069ed:	89 04 24             	mov    %eax,(%esp)
801069f0:	e8 9b f1 ff ff       	call   80105b90 <fetchstr>
801069f5:	85 c0                	test   %eax,%eax
801069f7:	79 07                	jns    80106a00 <sys_exec+0x119>
      return -1;
801069f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069fe:	eb 08                	jmp    80106a08 <sys_exec+0x121>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106a00:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
80106a03:	e9 48 ff ff ff       	jmp    80106950 <sys_exec+0x69>
  return exec(path, argv);
}
80106a08:	c9                   	leave  
80106a09:	c3                   	ret    

80106a0a <sys_pipe>:

int
sys_pipe(void)
{
80106a0a:	55                   	push   %ebp
80106a0b:	89 e5                	mov    %esp,%ebp
80106a0d:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106a10:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106a17:	00 
80106a18:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a1f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a26:	e8 f9 f1 ff ff       	call   80105c24 <argptr>
80106a2b:	85 c0                	test   %eax,%eax
80106a2d:	79 0a                	jns    80106a39 <sys_pipe+0x2f>
    return -1;
80106a2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a34:	e9 9b 00 00 00       	jmp    80106ad4 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106a39:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a40:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106a43:	89 04 24             	mov    %eax,(%esp)
80106a46:	e8 39 d7 ff ff       	call   80104184 <pipealloc>
80106a4b:	85 c0                	test   %eax,%eax
80106a4d:	79 07                	jns    80106a56 <sys_pipe+0x4c>
    return -1;
80106a4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a54:	eb 7e                	jmp    80106ad4 <sys_pipe+0xca>
  fd0 = -1;
80106a56:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106a5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106a60:	89 04 24             	mov    %eax,(%esp)
80106a63:	e8 99 f3 ff ff       	call   80105e01 <fdalloc>
80106a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a6f:	78 14                	js     80106a85 <sys_pipe+0x7b>
80106a71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a74:	89 04 24             	mov    %eax,(%esp)
80106a77:	e8 85 f3 ff ff       	call   80105e01 <fdalloc>
80106a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106a7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106a83:	79 37                	jns    80106abc <sys_pipe+0xb2>
    if(fd0 >= 0)
80106a85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a89:	78 14                	js     80106a9f <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106a8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a94:	83 c2 08             	add    $0x8,%edx
80106a97:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106a9e:	00 
    fileclose(rf);
80106a9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106aa2:	89 04 24             	mov    %eax,(%esp)
80106aa5:	e8 6e aa ff ff       	call   80101518 <fileclose>
    fileclose(wf);
80106aaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106aad:	89 04 24             	mov    %eax,(%esp)
80106ab0:	e8 63 aa ff ff       	call   80101518 <fileclose>
    return -1;
80106ab5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aba:	eb 18                	jmp    80106ad4 <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106abf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ac2:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106ac7:	8d 50 04             	lea    0x4(%eax),%edx
80106aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106acd:	89 02                	mov    %eax,(%edx)
  return 0;
80106acf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ad4:	c9                   	leave  
80106ad5:	c3                   	ret    
80106ad6:	66 90                	xchg   %ax,%ax

80106ad8 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106ad8:	55                   	push   %ebp
80106ad9:	89 e5                	mov    %esp,%ebp
80106adb:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106ade:	e8 22 de ff ff       	call   80104905 <fork>
}
80106ae3:	c9                   	leave  
80106ae4:	c3                   	ret    

80106ae5 <sys_exit>:

int
sys_exit(void)
{
80106ae5:	55                   	push   %ebp
80106ae6:	89 e5                	mov    %esp,%ebp
80106ae8:	83 ec 08             	sub    $0x8,%esp
  exit();
80106aeb:	e8 77 df ff ff       	call   80104a67 <exit>
  return 0;  // not reached
80106af0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106af5:	c9                   	leave  
80106af6:	c3                   	ret    

80106af7 <sys_wait>:

int
sys_wait(void)
{
80106af7:	55                   	push   %ebp
80106af8:	89 e5                	mov    %esp,%ebp
80106afa:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106afd:	e8 91 e0 ff ff       	call   80104b93 <wait>
}
80106b02:	c9                   	leave  
80106b03:	c3                   	ret    

80106b04 <sys_kill>:

int
sys_kill(void)
{
80106b04:	55                   	push   %ebp
80106b05:	89 e5                	mov    %esp,%ebp
80106b07:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106b0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b18:	e8 cf f0 ff ff       	call   80105bec <argint>
80106b1d:	85 c0                	test   %eax,%eax
80106b1f:	79 07                	jns    80106b28 <sys_kill+0x24>
    return -1;
80106b21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b26:	eb 0b                	jmp    80106b33 <sys_kill+0x2f>
  return kill(pid);
80106b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b2b:	89 04 24             	mov    %eax,(%esp)
80106b2e:	e8 0d e9 ff ff       	call   80105440 <kill>
}
80106b33:	c9                   	leave  
80106b34:	c3                   	ret    

80106b35 <sys_getpid>:

int
sys_getpid(void)
{
80106b35:	55                   	push   %ebp
80106b36:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106b38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b3e:	8b 40 10             	mov    0x10(%eax),%eax
}
80106b41:	5d                   	pop    %ebp
80106b42:	c3                   	ret    

80106b43 <sys_sbrk>:

int
sys_sbrk(void)
{
80106b43:	55                   	push   %ebp
80106b44:	89 e5                	mov    %esp,%ebp
80106b46:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106b49:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b57:	e8 90 f0 ff ff       	call   80105bec <argint>
80106b5c:	85 c0                	test   %eax,%eax
80106b5e:	79 07                	jns    80106b67 <sys_sbrk+0x24>
    return -1;
80106b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b65:	eb 24                	jmp    80106b8b <sys_sbrk+0x48>
  addr = proc->sz;
80106b67:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b6d:	8b 00                	mov    (%eax),%eax
80106b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b75:	89 04 24             	mov    %eax,(%esp)
80106b78:	e8 e3 dc ff ff       	call   80104860 <growproc>
80106b7d:	85 c0                	test   %eax,%eax
80106b7f:	79 07                	jns    80106b88 <sys_sbrk+0x45>
    return -1;
80106b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b86:	eb 03                	jmp    80106b8b <sys_sbrk+0x48>
  return addr;
80106b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106b8b:	c9                   	leave  
80106b8c:	c3                   	ret    

80106b8d <sys_sleep>:

int
sys_sleep(void)
{
80106b8d:	55                   	push   %ebp
80106b8e:	89 e5                	mov    %esp,%ebp
80106b90:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106b93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b96:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ba1:	e8 46 f0 ff ff       	call   80105bec <argint>
80106ba6:	85 c0                	test   %eax,%eax
80106ba8:	79 07                	jns    80106bb1 <sys_sleep+0x24>
    return -1;
80106baa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106baf:	eb 6c                	jmp    80106c1d <sys_sleep+0x90>
  acquire(&tickslock);
80106bb1:	c7 04 24 80 47 11 80 	movl   $0x80114780,(%esp)
80106bb8:	e8 62 ea ff ff       	call   8010561f <acquire>
  ticks0 = ticks;
80106bbd:	a1 c0 4f 11 80       	mov    0x80114fc0,%eax
80106bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106bc5:	eb 34                	jmp    80106bfb <sys_sleep+0x6e>
    if(proc->killed){
80106bc7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bcd:	8b 40 24             	mov    0x24(%eax),%eax
80106bd0:	85 c0                	test   %eax,%eax
80106bd2:	74 13                	je     80106be7 <sys_sleep+0x5a>
      release(&tickslock);
80106bd4:	c7 04 24 80 47 11 80 	movl   $0x80114780,(%esp)
80106bdb:	e8 a1 ea ff ff       	call   80105681 <release>
      return -1;
80106be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106be5:	eb 36                	jmp    80106c1d <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106be7:	c7 44 24 04 80 47 11 	movl   $0x80114780,0x4(%esp)
80106bee:	80 
80106bef:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
80106bf6:	e8 3e e7 ff ff       	call   80105339 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106bfb:	a1 c0 4f 11 80       	mov    0x80114fc0,%eax
80106c00:	89 c2                	mov    %eax,%edx
80106c02:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c08:	39 c2                	cmp    %eax,%edx
80106c0a:	72 bb                	jb     80106bc7 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106c0c:	c7 04 24 80 47 11 80 	movl   $0x80114780,(%esp)
80106c13:	e8 69 ea ff ff       	call   80105681 <release>
  return 0;
80106c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c1d:	c9                   	leave  
80106c1e:	c3                   	ret    

80106c1f <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106c1f:	55                   	push   %ebp
80106c20:	89 e5                	mov    %esp,%ebp
80106c22:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106c25:	c7 04 24 80 47 11 80 	movl   $0x80114780,(%esp)
80106c2c:	e8 ee e9 ff ff       	call   8010561f <acquire>
  xticks = ticks;
80106c31:	a1 c0 4f 11 80       	mov    0x80114fc0,%eax
80106c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106c39:	c7 04 24 80 47 11 80 	movl   $0x80114780,(%esp)
80106c40:	e8 3c ea ff ff       	call   80105681 <release>
  return xticks;
80106c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106c48:	c9                   	leave  
80106c49:	c3                   	ret    

80106c4a <sys_add_path>:

int
sys_add_path(void)
{
80106c4a:	55                   	push   %ebp
80106c4b:	89 e5                	mov    %esp,%ebp
80106c4d:	83 ec 28             	sub    $0x28,%esp
  char ** pathPtr = 0;
80106c50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(argstr(0,pathPtr) < 0)
80106c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c65:	e8 1c f0 ff ff       	call   80105c86 <argstr>
80106c6a:	85 c0                	test   %eax,%eax
80106c6c:	79 07                	jns    80106c75 <sys_add_path+0x2b>
    return -1;
80106c6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c73:	eb 0d                	jmp    80106c82 <sys_add_path+0x38>

  return add_path(*pathPtr);
80106c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c78:	8b 00                	mov    (%eax),%eax
80106c7a:	89 04 24             	mov    %eax,(%esp)
80106c7d:	e8 c6 a2 ff ff       	call   80100f48 <add_path>
}
80106c82:	c9                   	leave  
80106c83:	c3                   	ret    

80106c84 <sys_wait2>:

int
sys_wait2(void)
{
80106c84:	55                   	push   %ebp
80106c85:	89 e5                	mov    %esp,%ebp
80106c87:	83 ec 28             	sub    $0x28,%esp
  int wtime;
  int rtime;
  int iotime;

  if(argint(0, &wtime) < 0)
80106c8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c98:	e8 4f ef ff ff       	call   80105bec <argint>
80106c9d:	85 c0                	test   %eax,%eax
80106c9f:	79 07                	jns    80106ca8 <sys_wait2+0x24>
    return -1;
80106ca1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ca6:	eb 59                	jmp    80106d01 <sys_wait2+0x7d>
  if(argint(1, &rtime) < 0)
80106ca8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cab:	89 44 24 04          	mov    %eax,0x4(%esp)
80106caf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106cb6:	e8 31 ef ff ff       	call   80105bec <argint>
80106cbb:	85 c0                	test   %eax,%eax
80106cbd:	79 07                	jns    80106cc6 <sys_wait2+0x42>
    return -1;
80106cbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cc4:	eb 3b                	jmp    80106d01 <sys_wait2+0x7d>
  if(argint(2, &iotime) < 0)
80106cc6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106cc9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ccd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106cd4:	e8 13 ef ff ff       	call   80105bec <argint>
80106cd9:	85 c0                	test   %eax,%eax
80106cdb:	79 07                	jns    80106ce4 <sys_wait2+0x60>
    return -1;
80106cdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ce2:	eb 1d                	jmp    80106d01 <sys_wait2+0x7d>

  return wait2((int *) wtime,(int *) rtime,(int *) iotime);
80106ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106ce7:	89 c1                	mov    %eax,%ecx
80106ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cec:	89 c2                	mov    %eax,%edx
80106cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cf1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106cf5:	89 54 24 04          	mov    %edx,0x4(%esp)
80106cf9:	89 04 24             	mov    %eax,(%esp)
80106cfc:	e8 e5 df ff ff       	call   80104ce6 <wait2>
80106d01:	c9                   	leave  
80106d02:	c3                   	ret    
80106d03:	90                   	nop

80106d04 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106d04:	55                   	push   %ebp
80106d05:	89 e5                	mov    %esp,%ebp
80106d07:	83 ec 08             	sub    $0x8,%esp
80106d0a:	8b 45 08             	mov    0x8(%ebp),%eax
80106d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d10:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106d14:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d17:	8a 45 f8             	mov    -0x8(%ebp),%al
80106d1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106d1d:	ee                   	out    %al,(%dx)
}
80106d1e:	c9                   	leave  
80106d1f:	c3                   	ret    

80106d20 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106d26:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106d2d:	00 
80106d2e:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106d35:	e8 ca ff ff ff       	call   80106d04 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106d3a:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106d41:	00 
80106d42:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106d49:	e8 b6 ff ff ff       	call   80106d04 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106d4e:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106d55:	00 
80106d56:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106d5d:	e8 a2 ff ff ff       	call   80106d04 <outb>
  picenable(IRQ_TIMER);
80106d62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d69:	e8 a2 d2 ff ff       	call   80104010 <picenable>
}
80106d6e:	c9                   	leave  
80106d6f:	c3                   	ret    

80106d70 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106d70:	1e                   	push   %ds
  pushl %es
80106d71:	06                   	push   %es
  pushl %fs
80106d72:	0f a0                	push   %fs
  pushl %gs
80106d74:	0f a8                	push   %gs
  pushal
80106d76:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106d77:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106d7b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106d7d:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106d7f:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106d83:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106d85:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106d87:	54                   	push   %esp
  call trap
80106d88:	e8 c5 01 00 00       	call   80106f52 <trap>
  addl $4, %esp
80106d8d:	83 c4 04             	add    $0x4,%esp

80106d90 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106d90:	61                   	popa   
  popl %gs
80106d91:	0f a9                	pop    %gs
  popl %fs
80106d93:	0f a1                	pop    %fs
  popl %es
80106d95:	07                   	pop    %es
  popl %ds
80106d96:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106d97:	83 c4 08             	add    $0x8,%esp
  iret
80106d9a:	cf                   	iret   
80106d9b:	90                   	nop

80106d9c <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106d9c:	55                   	push   %ebp
80106d9d:	89 e5                	mov    %esp,%ebp
80106d9f:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106da2:	8b 45 0c             	mov    0xc(%ebp),%eax
80106da5:	48                   	dec    %eax
80106da6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106daa:	8b 45 08             	mov    0x8(%ebp),%eax
80106dad:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106db1:	8b 45 08             	mov    0x8(%ebp),%eax
80106db4:	c1 e8 10             	shr    $0x10,%eax
80106db7:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106dbb:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106dbe:	0f 01 18             	lidtl  (%eax)
}
80106dc1:	c9                   	leave  
80106dc2:	c3                   	ret    

80106dc3 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106dc3:	55                   	push   %ebp
80106dc4:	89 e5                	mov    %esp,%ebp
80106dc6:	53                   	push   %ebx
80106dc7:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106dca:	0f 20 d3             	mov    %cr2,%ebx
80106dcd:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
80106dd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80106dd3:	83 c4 10             	add    $0x10,%esp
80106dd6:	5b                   	pop    %ebx
80106dd7:	5d                   	pop    %ebp
80106dd8:	c3                   	ret    

80106dd9 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106dd9:	55                   	push   %ebp
80106dda:	89 e5                	mov    %esp,%ebp
80106ddc:	83 ec 28             	sub    $0x28,%esp
    int i;

    for(i = 0; i < 256; i++)
80106ddf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106de6:	e9 b8 00 00 00       	jmp    80106ea3 <tvinit+0xca>
        SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dee:	8b 04 85 a0 c0 10 80 	mov    -0x7fef3f60(,%eax,4),%eax
80106df5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106df8:	66 89 04 d5 c0 47 11 	mov    %ax,-0x7feeb840(,%edx,8)
80106dff:	80 
80106e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e03:	66 c7 04 c5 c2 47 11 	movw   $0x8,-0x7feeb83e(,%eax,8)
80106e0a:	80 08 00 
80106e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e10:	8a 14 c5 c4 47 11 80 	mov    -0x7feeb83c(,%eax,8),%dl
80106e17:	83 e2 e0             	and    $0xffffffe0,%edx
80106e1a:	88 14 c5 c4 47 11 80 	mov    %dl,-0x7feeb83c(,%eax,8)
80106e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e24:	8a 14 c5 c4 47 11 80 	mov    -0x7feeb83c(,%eax,8),%dl
80106e2b:	83 e2 1f             	and    $0x1f,%edx
80106e2e:	88 14 c5 c4 47 11 80 	mov    %dl,-0x7feeb83c(,%eax,8)
80106e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e38:	8a 14 c5 c5 47 11 80 	mov    -0x7feeb83b(,%eax,8),%dl
80106e3f:	83 e2 f0             	and    $0xfffffff0,%edx
80106e42:	83 ca 0e             	or     $0xe,%edx
80106e45:	88 14 c5 c5 47 11 80 	mov    %dl,-0x7feeb83b(,%eax,8)
80106e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e4f:	8a 14 c5 c5 47 11 80 	mov    -0x7feeb83b(,%eax,8),%dl
80106e56:	83 e2 ef             	and    $0xffffffef,%edx
80106e59:	88 14 c5 c5 47 11 80 	mov    %dl,-0x7feeb83b(,%eax,8)
80106e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e63:	8a 14 c5 c5 47 11 80 	mov    -0x7feeb83b(,%eax,8),%dl
80106e6a:	83 e2 9f             	and    $0xffffff9f,%edx
80106e6d:	88 14 c5 c5 47 11 80 	mov    %dl,-0x7feeb83b(,%eax,8)
80106e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e77:	8a 14 c5 c5 47 11 80 	mov    -0x7feeb83b(,%eax,8),%dl
80106e7e:	83 ca 80             	or     $0xffffff80,%edx
80106e81:	88 14 c5 c5 47 11 80 	mov    %dl,-0x7feeb83b(,%eax,8)
80106e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e8b:	8b 04 85 a0 c0 10 80 	mov    -0x7fef3f60(,%eax,4),%eax
80106e92:	c1 e8 10             	shr    $0x10,%eax
80106e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106e98:	66 89 04 d5 c6 47 11 	mov    %ax,-0x7feeb83a(,%edx,8)
80106e9f:	80 
void
tvinit(void)
{
    int i;

    for(i = 0; i < 256; i++)
80106ea0:	ff 45 f4             	incl   -0xc(%ebp)
80106ea3:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106eaa:	0f 8e 3b ff ff ff    	jle    80106deb <tvinit+0x12>
        SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106eb0:	a1 a0 c1 10 80       	mov    0x8010c1a0,%eax
80106eb5:	66 a3 c0 49 11 80    	mov    %ax,0x801149c0
80106ebb:	66 c7 05 c2 49 11 80 	movw   $0x8,0x801149c2
80106ec2:	08 00 
80106ec4:	a0 c4 49 11 80       	mov    0x801149c4,%al
80106ec9:	83 e0 e0             	and    $0xffffffe0,%eax
80106ecc:	a2 c4 49 11 80       	mov    %al,0x801149c4
80106ed1:	a0 c4 49 11 80       	mov    0x801149c4,%al
80106ed6:	83 e0 1f             	and    $0x1f,%eax
80106ed9:	a2 c4 49 11 80       	mov    %al,0x801149c4
80106ede:	a0 c5 49 11 80       	mov    0x801149c5,%al
80106ee3:	83 c8 0f             	or     $0xf,%eax
80106ee6:	a2 c5 49 11 80       	mov    %al,0x801149c5
80106eeb:	a0 c5 49 11 80       	mov    0x801149c5,%al
80106ef0:	83 e0 ef             	and    $0xffffffef,%eax
80106ef3:	a2 c5 49 11 80       	mov    %al,0x801149c5
80106ef8:	a0 c5 49 11 80       	mov    0x801149c5,%al
80106efd:	83 c8 60             	or     $0x60,%eax
80106f00:	a2 c5 49 11 80       	mov    %al,0x801149c5
80106f05:	a0 c5 49 11 80       	mov    0x801149c5,%al
80106f0a:	83 c8 80             	or     $0xffffff80,%eax
80106f0d:	a2 c5 49 11 80       	mov    %al,0x801149c5
80106f12:	a1 a0 c1 10 80       	mov    0x8010c1a0,%eax
80106f17:	c1 e8 10             	shr    $0x10,%eax
80106f1a:	66 a3 c6 49 11 80    	mov    %ax,0x801149c6

    initlock(&tickslock, "time");
80106f20:	c7 44 24 04 64 91 10 	movl   $0x80109164,0x4(%esp)
80106f27:	80 
80106f28:	c7 04 24 80 47 11 80 	movl   $0x80114780,(%esp)
80106f2f:	e8 ca e6 ff ff       	call   801055fe <initlock>
}
80106f34:	c9                   	leave  
80106f35:	c3                   	ret    

80106f36 <idtinit>:

void
idtinit(void)
{
80106f36:	55                   	push   %ebp
80106f37:	89 e5                	mov    %esp,%ebp
80106f39:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106f3c:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106f43:	00 
80106f44:	c7 04 24 c0 47 11 80 	movl   $0x801147c0,(%esp)
80106f4b:	e8 4c fe ff ff       	call   80106d9c <lidt>
}
80106f50:	c9                   	leave  
80106f51:	c3                   	ret    

80106f52 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106f52:	55                   	push   %ebp
80106f53:	89 e5                	mov    %esp,%ebp
80106f55:	57                   	push   %edi
80106f56:	56                   	push   %esi
80106f57:	53                   	push   %ebx
80106f58:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106f5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f5e:	8b 40 30             	mov    0x30(%eax),%eax
80106f61:	83 f8 40             	cmp    $0x40,%eax
80106f64:	75 3e                	jne    80106fa4 <trap+0x52>
    if(proc->killed)
80106f66:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f6c:	8b 40 24             	mov    0x24(%eax),%eax
80106f6f:	85 c0                	test   %eax,%eax
80106f71:	74 05                	je     80106f78 <trap+0x26>
      exit();
80106f73:	e8 ef da ff ff       	call   80104a67 <exit>
    proc->tf = tf;
80106f78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f7e:	8b 55 08             	mov    0x8(%ebp),%edx
80106f81:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106f84:	e8 40 ed ff ff       	call   80105cc9 <syscall>
    //return for IO

    if(proc->killed)
80106f89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f8f:	8b 40 24             	mov    0x24(%eax),%eax
80106f92:	85 c0                	test   %eax,%eax
80106f94:	0f 84 82 02 00 00    	je     8010721c <trap+0x2ca>
      exit();
80106f9a:	e8 c8 da ff ff       	call   80104a67 <exit>
    return;
80106f9f:	e9 78 02 00 00       	jmp    8010721c <trap+0x2ca>
  }

  switch(tf->trapno)
80106fa4:	8b 45 08             	mov    0x8(%ebp),%eax
80106fa7:	8b 40 30             	mov    0x30(%eax),%eax
80106faa:	83 e8 20             	sub    $0x20,%eax
80106fad:	83 f8 1f             	cmp    $0x1f,%eax
80106fb0:	0f 87 e7 00 00 00    	ja     8010709d <trap+0x14b>
80106fb6:	8b 04 85 0c 92 10 80 	mov    -0x7fef6df4(,%eax,4),%eax
80106fbd:	ff e0                	jmp    *%eax
  {
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106fbf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106fc5:	8a 00                	mov    (%eax),%al
80106fc7:	84 c0                	test   %al,%al
80106fc9:	75 5f                	jne    8010702a <trap+0xd8>
      acquire(&tickslock);
80106fcb:	c7 04 24 80 47 11 80 	movl   $0x80114780,(%esp)
80106fd2:	e8 48 e6 ff ff       	call   8010561f <acquire>
      if(proc && proc->state == RUNNING)
80106fd7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fdd:	85 c0                	test   %eax,%eax
80106fdf:	74 21                	je     80107002 <trap+0xb0>
80106fe1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fe7:	8b 40 0c             	mov    0xc(%eax),%eax
80106fea:	83 f8 04             	cmp    $0x4,%eax
80106fed:	75 13                	jne    80107002 <trap+0xb0>
        proc->rtime++;
80106fef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ff5:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80106ffb:	42                   	inc    %edx
80106ffc:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
      updateAllSleepingProcesses();
80107002:	e8 9e dc ff ff       	call   80104ca5 <updateAllSleepingProcesses>
      ticks++;
80107007:	a1 c0 4f 11 80       	mov    0x80114fc0,%eax
8010700c:	40                   	inc    %eax
8010700d:	a3 c0 4f 11 80       	mov    %eax,0x80114fc0
      wakeup(&ticks);
80107012:	c7 04 24 c0 4f 11 80 	movl   $0x80114fc0,(%esp)
80107019:	e8 f7 e3 ff ff       	call   80105415 <wakeup>
      release(&tickslock);
8010701e:	c7 04 24 80 47 11 80 	movl   $0x80114780,(%esp)
80107025:	e8 57 e6 ff ff       	call   80105681 <release>
    }
    lapiceoi();
8010702a:	e8 ce c3 ff ff       	call   801033fd <lapiceoi>
    break;
8010702f:	e9 3c 01 00 00       	jmp    80107170 <trap+0x21e>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107034:	e8 dd bb ff ff       	call   80102c16 <ideintr>
    lapiceoi();
80107039:	e8 bf c3 ff ff       	call   801033fd <lapiceoi>
    break;
8010703e:	e9 2d 01 00 00       	jmp    80107170 <trap+0x21e>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107043:	e8 97 c1 ff ff       	call   801031df <kbdintr>
    lapiceoi();
80107048:	e8 b0 c3 ff ff       	call   801033fd <lapiceoi>
    break;
8010704d:	e9 1e 01 00 00       	jmp    80107170 <trap+0x21e>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107052:	e8 c5 03 00 00       	call   8010741c <uartintr>
    lapiceoi();
80107057:	e8 a1 c3 ff ff       	call   801033fd <lapiceoi>
    break;
8010705c:	e9 0f 01 00 00       	jmp    80107170 <trap+0x21e>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
80107061:	8b 45 08             	mov    0x8(%ebp),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107064:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107067:	8b 45 08             	mov    0x8(%ebp),%eax
8010706a:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010706d:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107070:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107076:	8a 00                	mov    (%eax),%al
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107078:	0f b6 c0             	movzbl %al,%eax
8010707b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010707f:	89 54 24 08          	mov    %edx,0x8(%esp)
80107083:	89 44 24 04          	mov    %eax,0x4(%esp)
80107087:	c7 04 24 6c 91 10 80 	movl   $0x8010916c,(%esp)
8010708e:	e8 0e 93 ff ff       	call   801003a1 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107093:	e8 65 c3 ff ff       	call   801033fd <lapiceoi>
    break;
80107098:	e9 d3 00 00 00       	jmp    80107170 <trap+0x21e>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010709d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070a3:	85 c0                	test   %eax,%eax
801070a5:	74 10                	je     801070b7 <trap+0x165>
801070a7:	8b 45 08             	mov    0x8(%ebp),%eax
801070aa:	8b 40 3c             	mov    0x3c(%eax),%eax
801070ad:	0f b7 c0             	movzwl %ax,%eax
801070b0:	83 e0 03             	and    $0x3,%eax
801070b3:	85 c0                	test   %eax,%eax
801070b5:	75 45                	jne    801070fc <trap+0x1aa>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801070b7:	e8 07 fd ff ff       	call   80106dc3 <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
801070bc:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801070bf:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
801070c2:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801070c9:	8a 12                	mov    (%edx),%dl
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801070cb:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801070ce:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801070d1:	8b 52 30             	mov    0x30(%edx),%edx
801070d4:	89 44 24 10          	mov    %eax,0x10(%esp)
801070d8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801070dc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801070e0:	89 54 24 04          	mov    %edx,0x4(%esp)
801070e4:	c7 04 24 90 91 10 80 	movl   $0x80109190,(%esp)
801070eb:	e8 b1 92 ff ff       	call   801003a1 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801070f0:	c7 04 24 c2 91 10 80 	movl   $0x801091c2,(%esp)
801070f7:	e8 3a 94 ff ff       	call   80100536 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070fc:	e8 c2 fc ff ff       	call   80106dc3 <rcr2>
80107101:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107103:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107106:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107109:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010710f:	8a 00                	mov    (%eax),%al
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107111:	0f b6 f0             	movzbl %al,%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107114:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107117:	8b 58 34             	mov    0x34(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010711a:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010711d:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107120:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107126:	83 c0 6c             	add    $0x6c,%eax
80107129:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010712c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107132:	8b 40 10             	mov    0x10(%eax),%eax
80107135:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80107139:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010713d:	89 74 24 14          	mov    %esi,0x14(%esp)
80107141:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107145:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107149:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010714c:	89 54 24 08          	mov    %edx,0x8(%esp)
80107150:	89 44 24 04          	mov    %eax,0x4(%esp)
80107154:	c7 04 24 c8 91 10 80 	movl   $0x801091c8,(%esp)
8010715b:	e8 41 92 ff ff       	call   801003a1 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107160:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107166:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010716d:	eb 01                	jmp    80107170 <trap+0x21e>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010716f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107170:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107176:	85 c0                	test   %eax,%eax
80107178:	74 23                	je     8010719d <trap+0x24b>
8010717a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107180:	8b 40 24             	mov    0x24(%eax),%eax
80107183:	85 c0                	test   %eax,%eax
80107185:	74 16                	je     8010719d <trap+0x24b>
80107187:	8b 45 08             	mov    0x8(%ebp),%eax
8010718a:	8b 40 3c             	mov    0x3c(%eax),%eax
8010718d:	0f b7 c0             	movzwl %ax,%eax
80107190:	83 e0 03             	and    $0x3,%eax
80107193:	83 f8 03             	cmp    $0x3,%eax
80107196:	75 05                	jne    8010719d <trap+0x24b>
    exit();
80107198:	e8 ca d8 ff ff       	call   80104a67 <exit>

#ifndef SCHED_FCFS
  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010719d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071a3:	85 c0                	test   %eax,%eax
801071a5:	74 46                	je     801071ed <trap+0x29b>
801071a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071ad:	8b 40 0c             	mov    0xc(%eax),%eax
801071b0:	83 f8 04             	cmp    $0x4,%eax
801071b3:	75 38                	jne    801071ed <trap+0x29b>
801071b5:	8b 45 08             	mov    0x8(%ebp),%eax
801071b8:	8b 40 30             	mov    0x30(%eax),%eax
801071bb:	83 f8 20             	cmp    $0x20,%eax
801071be:	75 2d                	jne    801071ed <trap+0x29b>
  {
    /*if(proc->priority != LOW && (ticks - proc->ctime) % QUANTA == 0)*/
    if(proc->priority != LOW && ticks % QUANTA == 0)
801071c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071c6:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801071cc:	83 f8 02             	cmp    $0x2,%eax
801071cf:	74 1c                	je     801071ed <trap+0x29b>
801071d1:	a1 c0 4f 11 80       	mov    0x80114fc0,%eax
801071d6:	b9 05 00 00 00       	mov    $0x5,%ecx
801071db:	ba 00 00 00 00       	mov    $0x0,%edx
801071e0:	f7 f1                	div    %ecx
801071e2:	89 d0                	mov    %edx,%eax
801071e4:	85 c0                	test   %eax,%eax
801071e6:	75 05                	jne    801071ed <trap+0x29b>
        yield();
801071e8:	e8 ee e0 ff ff       	call   801052db <yield>
  }
#endif

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801071ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071f3:	85 c0                	test   %eax,%eax
801071f5:	74 26                	je     8010721d <trap+0x2cb>
801071f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071fd:	8b 40 24             	mov    0x24(%eax),%eax
80107200:	85 c0                	test   %eax,%eax
80107202:	74 19                	je     8010721d <trap+0x2cb>
80107204:	8b 45 08             	mov    0x8(%ebp),%eax
80107207:	8b 40 3c             	mov    0x3c(%eax),%eax
8010720a:	0f b7 c0             	movzwl %ax,%eax
8010720d:	83 e0 03             	and    $0x3,%eax
80107210:	83 f8 03             	cmp    $0x3,%eax
80107213:	75 08                	jne    8010721d <trap+0x2cb>
    exit();
80107215:	e8 4d d8 ff ff       	call   80104a67 <exit>
8010721a:	eb 01                	jmp    8010721d <trap+0x2cb>
    syscall();
    //return for IO

    if(proc->killed)
      exit();
    return;
8010721c:	90                   	nop
#endif

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
8010721d:	83 c4 3c             	add    $0x3c,%esp
80107220:	5b                   	pop    %ebx
80107221:	5e                   	pop    %esi
80107222:	5f                   	pop    %edi
80107223:	5d                   	pop    %ebp
80107224:	c3                   	ret    
80107225:	66 90                	xchg   %ax,%ax
80107227:	90                   	nop

80107228 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80107228:	55                   	push   %ebp
80107229:	89 e5                	mov    %esp,%ebp
8010722b:	53                   	push   %ebx
8010722c:	83 ec 14             	sub    $0x14,%esp
8010722f:	8b 45 08             	mov    0x8(%ebp),%eax
80107232:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107236:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107239:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
8010723d:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
80107241:	ec                   	in     (%dx),%al
80107242:	88 c3                	mov    %al,%bl
80107244:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80107247:	8a 45 fb             	mov    -0x5(%ebp),%al
}
8010724a:	83 c4 14             	add    $0x14,%esp
8010724d:	5b                   	pop    %ebx
8010724e:	5d                   	pop    %ebp
8010724f:	c3                   	ret    

80107250 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	83 ec 08             	sub    $0x8,%esp
80107256:	8b 45 08             	mov    0x8(%ebp),%eax
80107259:	8b 55 0c             	mov    0xc(%ebp),%edx
8010725c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107260:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107263:	8a 45 f8             	mov    -0x8(%ebp),%al
80107266:	8b 55 fc             	mov    -0x4(%ebp),%edx
80107269:	ee                   	out    %al,(%dx)
}
8010726a:	c9                   	leave  
8010726b:	c3                   	ret    

8010726c <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
8010726c:	55                   	push   %ebp
8010726d:	89 e5                	mov    %esp,%ebp
8010726f:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107272:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107279:	00 
8010727a:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80107281:	e8 ca ff ff ff       	call   80107250 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107286:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
8010728d:	00 
8010728e:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107295:	e8 b6 ff ff ff       	call   80107250 <outb>
  outb(COM1+0, 115200/9600);
8010729a:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801072a1:	00 
801072a2:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801072a9:	e8 a2 ff ff ff       	call   80107250 <outb>
  outb(COM1+1, 0);
801072ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801072b5:	00 
801072b6:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801072bd:	e8 8e ff ff ff       	call   80107250 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801072c2:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801072c9:	00 
801072ca:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801072d1:	e8 7a ff ff ff       	call   80107250 <outb>
  outb(COM1+4, 0);
801072d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801072dd:	00 
801072de:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
801072e5:	e8 66 ff ff ff       	call   80107250 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801072ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801072f1:	00 
801072f2:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801072f9:	e8 52 ff ff ff       	call   80107250 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801072fe:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107305:	e8 1e ff ff ff       	call   80107228 <inb>
8010730a:	3c ff                	cmp    $0xff,%al
8010730c:	74 69                	je     80107377 <uartinit+0x10b>
    return;
  uart = 1;
8010730e:	c7 05 a4 c7 10 80 01 	movl   $0x1,0x8010c7a4
80107315:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107318:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010731f:	e8 04 ff ff ff       	call   80107228 <inb>
  inb(COM1+0);
80107324:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010732b:	e8 f8 fe ff ff       	call   80107228 <inb>
  picenable(IRQ_COM1);
80107330:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107337:	e8 d4 cc ff ff       	call   80104010 <picenable>
  ioapicenable(IRQ_COM1, 0);
8010733c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107343:	00 
80107344:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010734b:	e8 45 bb ff ff       	call   80102e95 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107350:	c7 45 f4 8c 92 10 80 	movl   $0x8010928c,-0xc(%ebp)
80107357:	eb 13                	jmp    8010736c <uartinit+0x100>
    uartputc(*p);
80107359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010735c:	8a 00                	mov    (%eax),%al
8010735e:	0f be c0             	movsbl %al,%eax
80107361:	89 04 24             	mov    %eax,(%esp)
80107364:	e8 11 00 00 00       	call   8010737a <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107369:	ff 45 f4             	incl   -0xc(%ebp)
8010736c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010736f:	8a 00                	mov    (%eax),%al
80107371:	84 c0                	test   %al,%al
80107373:	75 e4                	jne    80107359 <uartinit+0xed>
80107375:	eb 01                	jmp    80107378 <uartinit+0x10c>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80107377:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107378:	c9                   	leave  
80107379:	c3                   	ret    

8010737a <uartputc>:

void
uartputc(int c)
{
8010737a:	55                   	push   %ebp
8010737b:	89 e5                	mov    %esp,%ebp
8010737d:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80107380:	a1 a4 c7 10 80       	mov    0x8010c7a4,%eax
80107385:	85 c0                	test   %eax,%eax
80107387:	74 4c                	je     801073d5 <uartputc+0x5b>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107389:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107390:	eb 0f                	jmp    801073a1 <uartputc+0x27>
    microdelay(10);
80107392:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80107399:	e8 84 c0 ff ff       	call   80103422 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010739e:	ff 45 f4             	incl   -0xc(%ebp)
801073a1:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801073a5:	7f 16                	jg     801073bd <uartputc+0x43>
801073a7:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801073ae:	e8 75 fe ff ff       	call   80107228 <inb>
801073b3:	0f b6 c0             	movzbl %al,%eax
801073b6:	83 e0 20             	and    $0x20,%eax
801073b9:	85 c0                	test   %eax,%eax
801073bb:	74 d5                	je     80107392 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801073bd:	8b 45 08             	mov    0x8(%ebp),%eax
801073c0:	0f b6 c0             	movzbl %al,%eax
801073c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801073c7:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801073ce:	e8 7d fe ff ff       	call   80107250 <outb>
801073d3:	eb 01                	jmp    801073d6 <uartputc+0x5c>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801073d5:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801073d6:	c9                   	leave  
801073d7:	c3                   	ret    

801073d8 <uartgetc>:

static int
uartgetc(void)
{
801073d8:	55                   	push   %ebp
801073d9:	89 e5                	mov    %esp,%ebp
801073db:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801073de:	a1 a4 c7 10 80       	mov    0x8010c7a4,%eax
801073e3:	85 c0                	test   %eax,%eax
801073e5:	75 07                	jne    801073ee <uartgetc+0x16>
    return -1;
801073e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073ec:	eb 2c                	jmp    8010741a <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
801073ee:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801073f5:	e8 2e fe ff ff       	call   80107228 <inb>
801073fa:	0f b6 c0             	movzbl %al,%eax
801073fd:	83 e0 01             	and    $0x1,%eax
80107400:	85 c0                	test   %eax,%eax
80107402:	75 07                	jne    8010740b <uartgetc+0x33>
    return -1;
80107404:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107409:	eb 0f                	jmp    8010741a <uartgetc+0x42>
  return inb(COM1+0);
8010740b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107412:	e8 11 fe ff ff       	call   80107228 <inb>
80107417:	0f b6 c0             	movzbl %al,%eax
}
8010741a:	c9                   	leave  
8010741b:	c3                   	ret    

8010741c <uartintr>:

void
uartintr(void)
{
8010741c:	55                   	push   %ebp
8010741d:	89 e5                	mov    %esp,%ebp
8010741f:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80107422:	c7 04 24 d8 73 10 80 	movl   $0x801073d8,(%esp)
80107429:	e8 c2 93 ff ff       	call   801007f0 <consoleintr>
}
8010742e:	c9                   	leave  
8010742f:	c3                   	ret    

80107430 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107430:	6a 00                	push   $0x0
  pushl $0
80107432:	6a 00                	push   $0x0
  jmp alltraps
80107434:	e9 37 f9 ff ff       	jmp    80106d70 <alltraps>

80107439 <vector1>:
.globl vector1
vector1:
  pushl $0
80107439:	6a 00                	push   $0x0
  pushl $1
8010743b:	6a 01                	push   $0x1
  jmp alltraps
8010743d:	e9 2e f9 ff ff       	jmp    80106d70 <alltraps>

80107442 <vector2>:
.globl vector2
vector2:
  pushl $0
80107442:	6a 00                	push   $0x0
  pushl $2
80107444:	6a 02                	push   $0x2
  jmp alltraps
80107446:	e9 25 f9 ff ff       	jmp    80106d70 <alltraps>

8010744b <vector3>:
.globl vector3
vector3:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $3
8010744d:	6a 03                	push   $0x3
  jmp alltraps
8010744f:	e9 1c f9 ff ff       	jmp    80106d70 <alltraps>

80107454 <vector4>:
.globl vector4
vector4:
  pushl $0
80107454:	6a 00                	push   $0x0
  pushl $4
80107456:	6a 04                	push   $0x4
  jmp alltraps
80107458:	e9 13 f9 ff ff       	jmp    80106d70 <alltraps>

8010745d <vector5>:
.globl vector5
vector5:
  pushl $0
8010745d:	6a 00                	push   $0x0
  pushl $5
8010745f:	6a 05                	push   $0x5
  jmp alltraps
80107461:	e9 0a f9 ff ff       	jmp    80106d70 <alltraps>

80107466 <vector6>:
.globl vector6
vector6:
  pushl $0
80107466:	6a 00                	push   $0x0
  pushl $6
80107468:	6a 06                	push   $0x6
  jmp alltraps
8010746a:	e9 01 f9 ff ff       	jmp    80106d70 <alltraps>

8010746f <vector7>:
.globl vector7
vector7:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $7
80107471:	6a 07                	push   $0x7
  jmp alltraps
80107473:	e9 f8 f8 ff ff       	jmp    80106d70 <alltraps>

80107478 <vector8>:
.globl vector8
vector8:
  pushl $8
80107478:	6a 08                	push   $0x8
  jmp alltraps
8010747a:	e9 f1 f8 ff ff       	jmp    80106d70 <alltraps>

8010747f <vector9>:
.globl vector9
vector9:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $9
80107481:	6a 09                	push   $0x9
  jmp alltraps
80107483:	e9 e8 f8 ff ff       	jmp    80106d70 <alltraps>

80107488 <vector10>:
.globl vector10
vector10:
  pushl $10
80107488:	6a 0a                	push   $0xa
  jmp alltraps
8010748a:	e9 e1 f8 ff ff       	jmp    80106d70 <alltraps>

8010748f <vector11>:
.globl vector11
vector11:
  pushl $11
8010748f:	6a 0b                	push   $0xb
  jmp alltraps
80107491:	e9 da f8 ff ff       	jmp    80106d70 <alltraps>

80107496 <vector12>:
.globl vector12
vector12:
  pushl $12
80107496:	6a 0c                	push   $0xc
  jmp alltraps
80107498:	e9 d3 f8 ff ff       	jmp    80106d70 <alltraps>

8010749d <vector13>:
.globl vector13
vector13:
  pushl $13
8010749d:	6a 0d                	push   $0xd
  jmp alltraps
8010749f:	e9 cc f8 ff ff       	jmp    80106d70 <alltraps>

801074a4 <vector14>:
.globl vector14
vector14:
  pushl $14
801074a4:	6a 0e                	push   $0xe
  jmp alltraps
801074a6:	e9 c5 f8 ff ff       	jmp    80106d70 <alltraps>

801074ab <vector15>:
.globl vector15
vector15:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $15
801074ad:	6a 0f                	push   $0xf
  jmp alltraps
801074af:	e9 bc f8 ff ff       	jmp    80106d70 <alltraps>

801074b4 <vector16>:
.globl vector16
vector16:
  pushl $0
801074b4:	6a 00                	push   $0x0
  pushl $16
801074b6:	6a 10                	push   $0x10
  jmp alltraps
801074b8:	e9 b3 f8 ff ff       	jmp    80106d70 <alltraps>

801074bd <vector17>:
.globl vector17
vector17:
  pushl $17
801074bd:	6a 11                	push   $0x11
  jmp alltraps
801074bf:	e9 ac f8 ff ff       	jmp    80106d70 <alltraps>

801074c4 <vector18>:
.globl vector18
vector18:
  pushl $0
801074c4:	6a 00                	push   $0x0
  pushl $18
801074c6:	6a 12                	push   $0x12
  jmp alltraps
801074c8:	e9 a3 f8 ff ff       	jmp    80106d70 <alltraps>

801074cd <vector19>:
.globl vector19
vector19:
  pushl $0
801074cd:	6a 00                	push   $0x0
  pushl $19
801074cf:	6a 13                	push   $0x13
  jmp alltraps
801074d1:	e9 9a f8 ff ff       	jmp    80106d70 <alltraps>

801074d6 <vector20>:
.globl vector20
vector20:
  pushl $0
801074d6:	6a 00                	push   $0x0
  pushl $20
801074d8:	6a 14                	push   $0x14
  jmp alltraps
801074da:	e9 91 f8 ff ff       	jmp    80106d70 <alltraps>

801074df <vector21>:
.globl vector21
vector21:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $21
801074e1:	6a 15                	push   $0x15
  jmp alltraps
801074e3:	e9 88 f8 ff ff       	jmp    80106d70 <alltraps>

801074e8 <vector22>:
.globl vector22
vector22:
  pushl $0
801074e8:	6a 00                	push   $0x0
  pushl $22
801074ea:	6a 16                	push   $0x16
  jmp alltraps
801074ec:	e9 7f f8 ff ff       	jmp    80106d70 <alltraps>

801074f1 <vector23>:
.globl vector23
vector23:
  pushl $0
801074f1:	6a 00                	push   $0x0
  pushl $23
801074f3:	6a 17                	push   $0x17
  jmp alltraps
801074f5:	e9 76 f8 ff ff       	jmp    80106d70 <alltraps>

801074fa <vector24>:
.globl vector24
vector24:
  pushl $0
801074fa:	6a 00                	push   $0x0
  pushl $24
801074fc:	6a 18                	push   $0x18
  jmp alltraps
801074fe:	e9 6d f8 ff ff       	jmp    80106d70 <alltraps>

80107503 <vector25>:
.globl vector25
vector25:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $25
80107505:	6a 19                	push   $0x19
  jmp alltraps
80107507:	e9 64 f8 ff ff       	jmp    80106d70 <alltraps>

8010750c <vector26>:
.globl vector26
vector26:
  pushl $0
8010750c:	6a 00                	push   $0x0
  pushl $26
8010750e:	6a 1a                	push   $0x1a
  jmp alltraps
80107510:	e9 5b f8 ff ff       	jmp    80106d70 <alltraps>

80107515 <vector27>:
.globl vector27
vector27:
  pushl $0
80107515:	6a 00                	push   $0x0
  pushl $27
80107517:	6a 1b                	push   $0x1b
  jmp alltraps
80107519:	e9 52 f8 ff ff       	jmp    80106d70 <alltraps>

8010751e <vector28>:
.globl vector28
vector28:
  pushl $0
8010751e:	6a 00                	push   $0x0
  pushl $28
80107520:	6a 1c                	push   $0x1c
  jmp alltraps
80107522:	e9 49 f8 ff ff       	jmp    80106d70 <alltraps>

80107527 <vector29>:
.globl vector29
vector29:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $29
80107529:	6a 1d                	push   $0x1d
  jmp alltraps
8010752b:	e9 40 f8 ff ff       	jmp    80106d70 <alltraps>

80107530 <vector30>:
.globl vector30
vector30:
  pushl $0
80107530:	6a 00                	push   $0x0
  pushl $30
80107532:	6a 1e                	push   $0x1e
  jmp alltraps
80107534:	e9 37 f8 ff ff       	jmp    80106d70 <alltraps>

80107539 <vector31>:
.globl vector31
vector31:
  pushl $0
80107539:	6a 00                	push   $0x0
  pushl $31
8010753b:	6a 1f                	push   $0x1f
  jmp alltraps
8010753d:	e9 2e f8 ff ff       	jmp    80106d70 <alltraps>

80107542 <vector32>:
.globl vector32
vector32:
  pushl $0
80107542:	6a 00                	push   $0x0
  pushl $32
80107544:	6a 20                	push   $0x20
  jmp alltraps
80107546:	e9 25 f8 ff ff       	jmp    80106d70 <alltraps>

8010754b <vector33>:
.globl vector33
vector33:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $33
8010754d:	6a 21                	push   $0x21
  jmp alltraps
8010754f:	e9 1c f8 ff ff       	jmp    80106d70 <alltraps>

80107554 <vector34>:
.globl vector34
vector34:
  pushl $0
80107554:	6a 00                	push   $0x0
  pushl $34
80107556:	6a 22                	push   $0x22
  jmp alltraps
80107558:	e9 13 f8 ff ff       	jmp    80106d70 <alltraps>

8010755d <vector35>:
.globl vector35
vector35:
  pushl $0
8010755d:	6a 00                	push   $0x0
  pushl $35
8010755f:	6a 23                	push   $0x23
  jmp alltraps
80107561:	e9 0a f8 ff ff       	jmp    80106d70 <alltraps>

80107566 <vector36>:
.globl vector36
vector36:
  pushl $0
80107566:	6a 00                	push   $0x0
  pushl $36
80107568:	6a 24                	push   $0x24
  jmp alltraps
8010756a:	e9 01 f8 ff ff       	jmp    80106d70 <alltraps>

8010756f <vector37>:
.globl vector37
vector37:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $37
80107571:	6a 25                	push   $0x25
  jmp alltraps
80107573:	e9 f8 f7 ff ff       	jmp    80106d70 <alltraps>

80107578 <vector38>:
.globl vector38
vector38:
  pushl $0
80107578:	6a 00                	push   $0x0
  pushl $38
8010757a:	6a 26                	push   $0x26
  jmp alltraps
8010757c:	e9 ef f7 ff ff       	jmp    80106d70 <alltraps>

80107581 <vector39>:
.globl vector39
vector39:
  pushl $0
80107581:	6a 00                	push   $0x0
  pushl $39
80107583:	6a 27                	push   $0x27
  jmp alltraps
80107585:	e9 e6 f7 ff ff       	jmp    80106d70 <alltraps>

8010758a <vector40>:
.globl vector40
vector40:
  pushl $0
8010758a:	6a 00                	push   $0x0
  pushl $40
8010758c:	6a 28                	push   $0x28
  jmp alltraps
8010758e:	e9 dd f7 ff ff       	jmp    80106d70 <alltraps>

80107593 <vector41>:
.globl vector41
vector41:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $41
80107595:	6a 29                	push   $0x29
  jmp alltraps
80107597:	e9 d4 f7 ff ff       	jmp    80106d70 <alltraps>

8010759c <vector42>:
.globl vector42
vector42:
  pushl $0
8010759c:	6a 00                	push   $0x0
  pushl $42
8010759e:	6a 2a                	push   $0x2a
  jmp alltraps
801075a0:	e9 cb f7 ff ff       	jmp    80106d70 <alltraps>

801075a5 <vector43>:
.globl vector43
vector43:
  pushl $0
801075a5:	6a 00                	push   $0x0
  pushl $43
801075a7:	6a 2b                	push   $0x2b
  jmp alltraps
801075a9:	e9 c2 f7 ff ff       	jmp    80106d70 <alltraps>

801075ae <vector44>:
.globl vector44
vector44:
  pushl $0
801075ae:	6a 00                	push   $0x0
  pushl $44
801075b0:	6a 2c                	push   $0x2c
  jmp alltraps
801075b2:	e9 b9 f7 ff ff       	jmp    80106d70 <alltraps>

801075b7 <vector45>:
.globl vector45
vector45:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $45
801075b9:	6a 2d                	push   $0x2d
  jmp alltraps
801075bb:	e9 b0 f7 ff ff       	jmp    80106d70 <alltraps>

801075c0 <vector46>:
.globl vector46
vector46:
  pushl $0
801075c0:	6a 00                	push   $0x0
  pushl $46
801075c2:	6a 2e                	push   $0x2e
  jmp alltraps
801075c4:	e9 a7 f7 ff ff       	jmp    80106d70 <alltraps>

801075c9 <vector47>:
.globl vector47
vector47:
  pushl $0
801075c9:	6a 00                	push   $0x0
  pushl $47
801075cb:	6a 2f                	push   $0x2f
  jmp alltraps
801075cd:	e9 9e f7 ff ff       	jmp    80106d70 <alltraps>

801075d2 <vector48>:
.globl vector48
vector48:
  pushl $0
801075d2:	6a 00                	push   $0x0
  pushl $48
801075d4:	6a 30                	push   $0x30
  jmp alltraps
801075d6:	e9 95 f7 ff ff       	jmp    80106d70 <alltraps>

801075db <vector49>:
.globl vector49
vector49:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $49
801075dd:	6a 31                	push   $0x31
  jmp alltraps
801075df:	e9 8c f7 ff ff       	jmp    80106d70 <alltraps>

801075e4 <vector50>:
.globl vector50
vector50:
  pushl $0
801075e4:	6a 00                	push   $0x0
  pushl $50
801075e6:	6a 32                	push   $0x32
  jmp alltraps
801075e8:	e9 83 f7 ff ff       	jmp    80106d70 <alltraps>

801075ed <vector51>:
.globl vector51
vector51:
  pushl $0
801075ed:	6a 00                	push   $0x0
  pushl $51
801075ef:	6a 33                	push   $0x33
  jmp alltraps
801075f1:	e9 7a f7 ff ff       	jmp    80106d70 <alltraps>

801075f6 <vector52>:
.globl vector52
vector52:
  pushl $0
801075f6:	6a 00                	push   $0x0
  pushl $52
801075f8:	6a 34                	push   $0x34
  jmp alltraps
801075fa:	e9 71 f7 ff ff       	jmp    80106d70 <alltraps>

801075ff <vector53>:
.globl vector53
vector53:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $53
80107601:	6a 35                	push   $0x35
  jmp alltraps
80107603:	e9 68 f7 ff ff       	jmp    80106d70 <alltraps>

80107608 <vector54>:
.globl vector54
vector54:
  pushl $0
80107608:	6a 00                	push   $0x0
  pushl $54
8010760a:	6a 36                	push   $0x36
  jmp alltraps
8010760c:	e9 5f f7 ff ff       	jmp    80106d70 <alltraps>

80107611 <vector55>:
.globl vector55
vector55:
  pushl $0
80107611:	6a 00                	push   $0x0
  pushl $55
80107613:	6a 37                	push   $0x37
  jmp alltraps
80107615:	e9 56 f7 ff ff       	jmp    80106d70 <alltraps>

8010761a <vector56>:
.globl vector56
vector56:
  pushl $0
8010761a:	6a 00                	push   $0x0
  pushl $56
8010761c:	6a 38                	push   $0x38
  jmp alltraps
8010761e:	e9 4d f7 ff ff       	jmp    80106d70 <alltraps>

80107623 <vector57>:
.globl vector57
vector57:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $57
80107625:	6a 39                	push   $0x39
  jmp alltraps
80107627:	e9 44 f7 ff ff       	jmp    80106d70 <alltraps>

8010762c <vector58>:
.globl vector58
vector58:
  pushl $0
8010762c:	6a 00                	push   $0x0
  pushl $58
8010762e:	6a 3a                	push   $0x3a
  jmp alltraps
80107630:	e9 3b f7 ff ff       	jmp    80106d70 <alltraps>

80107635 <vector59>:
.globl vector59
vector59:
  pushl $0
80107635:	6a 00                	push   $0x0
  pushl $59
80107637:	6a 3b                	push   $0x3b
  jmp alltraps
80107639:	e9 32 f7 ff ff       	jmp    80106d70 <alltraps>

8010763e <vector60>:
.globl vector60
vector60:
  pushl $0
8010763e:	6a 00                	push   $0x0
  pushl $60
80107640:	6a 3c                	push   $0x3c
  jmp alltraps
80107642:	e9 29 f7 ff ff       	jmp    80106d70 <alltraps>

80107647 <vector61>:
.globl vector61
vector61:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $61
80107649:	6a 3d                	push   $0x3d
  jmp alltraps
8010764b:	e9 20 f7 ff ff       	jmp    80106d70 <alltraps>

80107650 <vector62>:
.globl vector62
vector62:
  pushl $0
80107650:	6a 00                	push   $0x0
  pushl $62
80107652:	6a 3e                	push   $0x3e
  jmp alltraps
80107654:	e9 17 f7 ff ff       	jmp    80106d70 <alltraps>

80107659 <vector63>:
.globl vector63
vector63:
  pushl $0
80107659:	6a 00                	push   $0x0
  pushl $63
8010765b:	6a 3f                	push   $0x3f
  jmp alltraps
8010765d:	e9 0e f7 ff ff       	jmp    80106d70 <alltraps>

80107662 <vector64>:
.globl vector64
vector64:
  pushl $0
80107662:	6a 00                	push   $0x0
  pushl $64
80107664:	6a 40                	push   $0x40
  jmp alltraps
80107666:	e9 05 f7 ff ff       	jmp    80106d70 <alltraps>

8010766b <vector65>:
.globl vector65
vector65:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $65
8010766d:	6a 41                	push   $0x41
  jmp alltraps
8010766f:	e9 fc f6 ff ff       	jmp    80106d70 <alltraps>

80107674 <vector66>:
.globl vector66
vector66:
  pushl $0
80107674:	6a 00                	push   $0x0
  pushl $66
80107676:	6a 42                	push   $0x42
  jmp alltraps
80107678:	e9 f3 f6 ff ff       	jmp    80106d70 <alltraps>

8010767d <vector67>:
.globl vector67
vector67:
  pushl $0
8010767d:	6a 00                	push   $0x0
  pushl $67
8010767f:	6a 43                	push   $0x43
  jmp alltraps
80107681:	e9 ea f6 ff ff       	jmp    80106d70 <alltraps>

80107686 <vector68>:
.globl vector68
vector68:
  pushl $0
80107686:	6a 00                	push   $0x0
  pushl $68
80107688:	6a 44                	push   $0x44
  jmp alltraps
8010768a:	e9 e1 f6 ff ff       	jmp    80106d70 <alltraps>

8010768f <vector69>:
.globl vector69
vector69:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $69
80107691:	6a 45                	push   $0x45
  jmp alltraps
80107693:	e9 d8 f6 ff ff       	jmp    80106d70 <alltraps>

80107698 <vector70>:
.globl vector70
vector70:
  pushl $0
80107698:	6a 00                	push   $0x0
  pushl $70
8010769a:	6a 46                	push   $0x46
  jmp alltraps
8010769c:	e9 cf f6 ff ff       	jmp    80106d70 <alltraps>

801076a1 <vector71>:
.globl vector71
vector71:
  pushl $0
801076a1:	6a 00                	push   $0x0
  pushl $71
801076a3:	6a 47                	push   $0x47
  jmp alltraps
801076a5:	e9 c6 f6 ff ff       	jmp    80106d70 <alltraps>

801076aa <vector72>:
.globl vector72
vector72:
  pushl $0
801076aa:	6a 00                	push   $0x0
  pushl $72
801076ac:	6a 48                	push   $0x48
  jmp alltraps
801076ae:	e9 bd f6 ff ff       	jmp    80106d70 <alltraps>

801076b3 <vector73>:
.globl vector73
vector73:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $73
801076b5:	6a 49                	push   $0x49
  jmp alltraps
801076b7:	e9 b4 f6 ff ff       	jmp    80106d70 <alltraps>

801076bc <vector74>:
.globl vector74
vector74:
  pushl $0
801076bc:	6a 00                	push   $0x0
  pushl $74
801076be:	6a 4a                	push   $0x4a
  jmp alltraps
801076c0:	e9 ab f6 ff ff       	jmp    80106d70 <alltraps>

801076c5 <vector75>:
.globl vector75
vector75:
  pushl $0
801076c5:	6a 00                	push   $0x0
  pushl $75
801076c7:	6a 4b                	push   $0x4b
  jmp alltraps
801076c9:	e9 a2 f6 ff ff       	jmp    80106d70 <alltraps>

801076ce <vector76>:
.globl vector76
vector76:
  pushl $0
801076ce:	6a 00                	push   $0x0
  pushl $76
801076d0:	6a 4c                	push   $0x4c
  jmp alltraps
801076d2:	e9 99 f6 ff ff       	jmp    80106d70 <alltraps>

801076d7 <vector77>:
.globl vector77
vector77:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $77
801076d9:	6a 4d                	push   $0x4d
  jmp alltraps
801076db:	e9 90 f6 ff ff       	jmp    80106d70 <alltraps>

801076e0 <vector78>:
.globl vector78
vector78:
  pushl $0
801076e0:	6a 00                	push   $0x0
  pushl $78
801076e2:	6a 4e                	push   $0x4e
  jmp alltraps
801076e4:	e9 87 f6 ff ff       	jmp    80106d70 <alltraps>

801076e9 <vector79>:
.globl vector79
vector79:
  pushl $0
801076e9:	6a 00                	push   $0x0
  pushl $79
801076eb:	6a 4f                	push   $0x4f
  jmp alltraps
801076ed:	e9 7e f6 ff ff       	jmp    80106d70 <alltraps>

801076f2 <vector80>:
.globl vector80
vector80:
  pushl $0
801076f2:	6a 00                	push   $0x0
  pushl $80
801076f4:	6a 50                	push   $0x50
  jmp alltraps
801076f6:	e9 75 f6 ff ff       	jmp    80106d70 <alltraps>

801076fb <vector81>:
.globl vector81
vector81:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $81
801076fd:	6a 51                	push   $0x51
  jmp alltraps
801076ff:	e9 6c f6 ff ff       	jmp    80106d70 <alltraps>

80107704 <vector82>:
.globl vector82
vector82:
  pushl $0
80107704:	6a 00                	push   $0x0
  pushl $82
80107706:	6a 52                	push   $0x52
  jmp alltraps
80107708:	e9 63 f6 ff ff       	jmp    80106d70 <alltraps>

8010770d <vector83>:
.globl vector83
vector83:
  pushl $0
8010770d:	6a 00                	push   $0x0
  pushl $83
8010770f:	6a 53                	push   $0x53
  jmp alltraps
80107711:	e9 5a f6 ff ff       	jmp    80106d70 <alltraps>

80107716 <vector84>:
.globl vector84
vector84:
  pushl $0
80107716:	6a 00                	push   $0x0
  pushl $84
80107718:	6a 54                	push   $0x54
  jmp alltraps
8010771a:	e9 51 f6 ff ff       	jmp    80106d70 <alltraps>

8010771f <vector85>:
.globl vector85
vector85:
  pushl $0
8010771f:	6a 00                	push   $0x0
  pushl $85
80107721:	6a 55                	push   $0x55
  jmp alltraps
80107723:	e9 48 f6 ff ff       	jmp    80106d70 <alltraps>

80107728 <vector86>:
.globl vector86
vector86:
  pushl $0
80107728:	6a 00                	push   $0x0
  pushl $86
8010772a:	6a 56                	push   $0x56
  jmp alltraps
8010772c:	e9 3f f6 ff ff       	jmp    80106d70 <alltraps>

80107731 <vector87>:
.globl vector87
vector87:
  pushl $0
80107731:	6a 00                	push   $0x0
  pushl $87
80107733:	6a 57                	push   $0x57
  jmp alltraps
80107735:	e9 36 f6 ff ff       	jmp    80106d70 <alltraps>

8010773a <vector88>:
.globl vector88
vector88:
  pushl $0
8010773a:	6a 00                	push   $0x0
  pushl $88
8010773c:	6a 58                	push   $0x58
  jmp alltraps
8010773e:	e9 2d f6 ff ff       	jmp    80106d70 <alltraps>

80107743 <vector89>:
.globl vector89
vector89:
  pushl $0
80107743:	6a 00                	push   $0x0
  pushl $89
80107745:	6a 59                	push   $0x59
  jmp alltraps
80107747:	e9 24 f6 ff ff       	jmp    80106d70 <alltraps>

8010774c <vector90>:
.globl vector90
vector90:
  pushl $0
8010774c:	6a 00                	push   $0x0
  pushl $90
8010774e:	6a 5a                	push   $0x5a
  jmp alltraps
80107750:	e9 1b f6 ff ff       	jmp    80106d70 <alltraps>

80107755 <vector91>:
.globl vector91
vector91:
  pushl $0
80107755:	6a 00                	push   $0x0
  pushl $91
80107757:	6a 5b                	push   $0x5b
  jmp alltraps
80107759:	e9 12 f6 ff ff       	jmp    80106d70 <alltraps>

8010775e <vector92>:
.globl vector92
vector92:
  pushl $0
8010775e:	6a 00                	push   $0x0
  pushl $92
80107760:	6a 5c                	push   $0x5c
  jmp alltraps
80107762:	e9 09 f6 ff ff       	jmp    80106d70 <alltraps>

80107767 <vector93>:
.globl vector93
vector93:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $93
80107769:	6a 5d                	push   $0x5d
  jmp alltraps
8010776b:	e9 00 f6 ff ff       	jmp    80106d70 <alltraps>

80107770 <vector94>:
.globl vector94
vector94:
  pushl $0
80107770:	6a 00                	push   $0x0
  pushl $94
80107772:	6a 5e                	push   $0x5e
  jmp alltraps
80107774:	e9 f7 f5 ff ff       	jmp    80106d70 <alltraps>

80107779 <vector95>:
.globl vector95
vector95:
  pushl $0
80107779:	6a 00                	push   $0x0
  pushl $95
8010777b:	6a 5f                	push   $0x5f
  jmp alltraps
8010777d:	e9 ee f5 ff ff       	jmp    80106d70 <alltraps>

80107782 <vector96>:
.globl vector96
vector96:
  pushl $0
80107782:	6a 00                	push   $0x0
  pushl $96
80107784:	6a 60                	push   $0x60
  jmp alltraps
80107786:	e9 e5 f5 ff ff       	jmp    80106d70 <alltraps>

8010778b <vector97>:
.globl vector97
vector97:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $97
8010778d:	6a 61                	push   $0x61
  jmp alltraps
8010778f:	e9 dc f5 ff ff       	jmp    80106d70 <alltraps>

80107794 <vector98>:
.globl vector98
vector98:
  pushl $0
80107794:	6a 00                	push   $0x0
  pushl $98
80107796:	6a 62                	push   $0x62
  jmp alltraps
80107798:	e9 d3 f5 ff ff       	jmp    80106d70 <alltraps>

8010779d <vector99>:
.globl vector99
vector99:
  pushl $0
8010779d:	6a 00                	push   $0x0
  pushl $99
8010779f:	6a 63                	push   $0x63
  jmp alltraps
801077a1:	e9 ca f5 ff ff       	jmp    80106d70 <alltraps>

801077a6 <vector100>:
.globl vector100
vector100:
  pushl $0
801077a6:	6a 00                	push   $0x0
  pushl $100
801077a8:	6a 64                	push   $0x64
  jmp alltraps
801077aa:	e9 c1 f5 ff ff       	jmp    80106d70 <alltraps>

801077af <vector101>:
.globl vector101
vector101:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $101
801077b1:	6a 65                	push   $0x65
  jmp alltraps
801077b3:	e9 b8 f5 ff ff       	jmp    80106d70 <alltraps>

801077b8 <vector102>:
.globl vector102
vector102:
  pushl $0
801077b8:	6a 00                	push   $0x0
  pushl $102
801077ba:	6a 66                	push   $0x66
  jmp alltraps
801077bc:	e9 af f5 ff ff       	jmp    80106d70 <alltraps>

801077c1 <vector103>:
.globl vector103
vector103:
  pushl $0
801077c1:	6a 00                	push   $0x0
  pushl $103
801077c3:	6a 67                	push   $0x67
  jmp alltraps
801077c5:	e9 a6 f5 ff ff       	jmp    80106d70 <alltraps>

801077ca <vector104>:
.globl vector104
vector104:
  pushl $0
801077ca:	6a 00                	push   $0x0
  pushl $104
801077cc:	6a 68                	push   $0x68
  jmp alltraps
801077ce:	e9 9d f5 ff ff       	jmp    80106d70 <alltraps>

801077d3 <vector105>:
.globl vector105
vector105:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $105
801077d5:	6a 69                	push   $0x69
  jmp alltraps
801077d7:	e9 94 f5 ff ff       	jmp    80106d70 <alltraps>

801077dc <vector106>:
.globl vector106
vector106:
  pushl $0
801077dc:	6a 00                	push   $0x0
  pushl $106
801077de:	6a 6a                	push   $0x6a
  jmp alltraps
801077e0:	e9 8b f5 ff ff       	jmp    80106d70 <alltraps>

801077e5 <vector107>:
.globl vector107
vector107:
  pushl $0
801077e5:	6a 00                	push   $0x0
  pushl $107
801077e7:	6a 6b                	push   $0x6b
  jmp alltraps
801077e9:	e9 82 f5 ff ff       	jmp    80106d70 <alltraps>

801077ee <vector108>:
.globl vector108
vector108:
  pushl $0
801077ee:	6a 00                	push   $0x0
  pushl $108
801077f0:	6a 6c                	push   $0x6c
  jmp alltraps
801077f2:	e9 79 f5 ff ff       	jmp    80106d70 <alltraps>

801077f7 <vector109>:
.globl vector109
vector109:
  pushl $0
801077f7:	6a 00                	push   $0x0
  pushl $109
801077f9:	6a 6d                	push   $0x6d
  jmp alltraps
801077fb:	e9 70 f5 ff ff       	jmp    80106d70 <alltraps>

80107800 <vector110>:
.globl vector110
vector110:
  pushl $0
80107800:	6a 00                	push   $0x0
  pushl $110
80107802:	6a 6e                	push   $0x6e
  jmp alltraps
80107804:	e9 67 f5 ff ff       	jmp    80106d70 <alltraps>

80107809 <vector111>:
.globl vector111
vector111:
  pushl $0
80107809:	6a 00                	push   $0x0
  pushl $111
8010780b:	6a 6f                	push   $0x6f
  jmp alltraps
8010780d:	e9 5e f5 ff ff       	jmp    80106d70 <alltraps>

80107812 <vector112>:
.globl vector112
vector112:
  pushl $0
80107812:	6a 00                	push   $0x0
  pushl $112
80107814:	6a 70                	push   $0x70
  jmp alltraps
80107816:	e9 55 f5 ff ff       	jmp    80106d70 <alltraps>

8010781b <vector113>:
.globl vector113
vector113:
  pushl $0
8010781b:	6a 00                	push   $0x0
  pushl $113
8010781d:	6a 71                	push   $0x71
  jmp alltraps
8010781f:	e9 4c f5 ff ff       	jmp    80106d70 <alltraps>

80107824 <vector114>:
.globl vector114
vector114:
  pushl $0
80107824:	6a 00                	push   $0x0
  pushl $114
80107826:	6a 72                	push   $0x72
  jmp alltraps
80107828:	e9 43 f5 ff ff       	jmp    80106d70 <alltraps>

8010782d <vector115>:
.globl vector115
vector115:
  pushl $0
8010782d:	6a 00                	push   $0x0
  pushl $115
8010782f:	6a 73                	push   $0x73
  jmp alltraps
80107831:	e9 3a f5 ff ff       	jmp    80106d70 <alltraps>

80107836 <vector116>:
.globl vector116
vector116:
  pushl $0
80107836:	6a 00                	push   $0x0
  pushl $116
80107838:	6a 74                	push   $0x74
  jmp alltraps
8010783a:	e9 31 f5 ff ff       	jmp    80106d70 <alltraps>

8010783f <vector117>:
.globl vector117
vector117:
  pushl $0
8010783f:	6a 00                	push   $0x0
  pushl $117
80107841:	6a 75                	push   $0x75
  jmp alltraps
80107843:	e9 28 f5 ff ff       	jmp    80106d70 <alltraps>

80107848 <vector118>:
.globl vector118
vector118:
  pushl $0
80107848:	6a 00                	push   $0x0
  pushl $118
8010784a:	6a 76                	push   $0x76
  jmp alltraps
8010784c:	e9 1f f5 ff ff       	jmp    80106d70 <alltraps>

80107851 <vector119>:
.globl vector119
vector119:
  pushl $0
80107851:	6a 00                	push   $0x0
  pushl $119
80107853:	6a 77                	push   $0x77
  jmp alltraps
80107855:	e9 16 f5 ff ff       	jmp    80106d70 <alltraps>

8010785a <vector120>:
.globl vector120
vector120:
  pushl $0
8010785a:	6a 00                	push   $0x0
  pushl $120
8010785c:	6a 78                	push   $0x78
  jmp alltraps
8010785e:	e9 0d f5 ff ff       	jmp    80106d70 <alltraps>

80107863 <vector121>:
.globl vector121
vector121:
  pushl $0
80107863:	6a 00                	push   $0x0
  pushl $121
80107865:	6a 79                	push   $0x79
  jmp alltraps
80107867:	e9 04 f5 ff ff       	jmp    80106d70 <alltraps>

8010786c <vector122>:
.globl vector122
vector122:
  pushl $0
8010786c:	6a 00                	push   $0x0
  pushl $122
8010786e:	6a 7a                	push   $0x7a
  jmp alltraps
80107870:	e9 fb f4 ff ff       	jmp    80106d70 <alltraps>

80107875 <vector123>:
.globl vector123
vector123:
  pushl $0
80107875:	6a 00                	push   $0x0
  pushl $123
80107877:	6a 7b                	push   $0x7b
  jmp alltraps
80107879:	e9 f2 f4 ff ff       	jmp    80106d70 <alltraps>

8010787e <vector124>:
.globl vector124
vector124:
  pushl $0
8010787e:	6a 00                	push   $0x0
  pushl $124
80107880:	6a 7c                	push   $0x7c
  jmp alltraps
80107882:	e9 e9 f4 ff ff       	jmp    80106d70 <alltraps>

80107887 <vector125>:
.globl vector125
vector125:
  pushl $0
80107887:	6a 00                	push   $0x0
  pushl $125
80107889:	6a 7d                	push   $0x7d
  jmp alltraps
8010788b:	e9 e0 f4 ff ff       	jmp    80106d70 <alltraps>

80107890 <vector126>:
.globl vector126
vector126:
  pushl $0
80107890:	6a 00                	push   $0x0
  pushl $126
80107892:	6a 7e                	push   $0x7e
  jmp alltraps
80107894:	e9 d7 f4 ff ff       	jmp    80106d70 <alltraps>

80107899 <vector127>:
.globl vector127
vector127:
  pushl $0
80107899:	6a 00                	push   $0x0
  pushl $127
8010789b:	6a 7f                	push   $0x7f
  jmp alltraps
8010789d:	e9 ce f4 ff ff       	jmp    80106d70 <alltraps>

801078a2 <vector128>:
.globl vector128
vector128:
  pushl $0
801078a2:	6a 00                	push   $0x0
  pushl $128
801078a4:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801078a9:	e9 c2 f4 ff ff       	jmp    80106d70 <alltraps>

801078ae <vector129>:
.globl vector129
vector129:
  pushl $0
801078ae:	6a 00                	push   $0x0
  pushl $129
801078b0:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801078b5:	e9 b6 f4 ff ff       	jmp    80106d70 <alltraps>

801078ba <vector130>:
.globl vector130
vector130:
  pushl $0
801078ba:	6a 00                	push   $0x0
  pushl $130
801078bc:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801078c1:	e9 aa f4 ff ff       	jmp    80106d70 <alltraps>

801078c6 <vector131>:
.globl vector131
vector131:
  pushl $0
801078c6:	6a 00                	push   $0x0
  pushl $131
801078c8:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801078cd:	e9 9e f4 ff ff       	jmp    80106d70 <alltraps>

801078d2 <vector132>:
.globl vector132
vector132:
  pushl $0
801078d2:	6a 00                	push   $0x0
  pushl $132
801078d4:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801078d9:	e9 92 f4 ff ff       	jmp    80106d70 <alltraps>

801078de <vector133>:
.globl vector133
vector133:
  pushl $0
801078de:	6a 00                	push   $0x0
  pushl $133
801078e0:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801078e5:	e9 86 f4 ff ff       	jmp    80106d70 <alltraps>

801078ea <vector134>:
.globl vector134
vector134:
  pushl $0
801078ea:	6a 00                	push   $0x0
  pushl $134
801078ec:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801078f1:	e9 7a f4 ff ff       	jmp    80106d70 <alltraps>

801078f6 <vector135>:
.globl vector135
vector135:
  pushl $0
801078f6:	6a 00                	push   $0x0
  pushl $135
801078f8:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801078fd:	e9 6e f4 ff ff       	jmp    80106d70 <alltraps>

80107902 <vector136>:
.globl vector136
vector136:
  pushl $0
80107902:	6a 00                	push   $0x0
  pushl $136
80107904:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107909:	e9 62 f4 ff ff       	jmp    80106d70 <alltraps>

8010790e <vector137>:
.globl vector137
vector137:
  pushl $0
8010790e:	6a 00                	push   $0x0
  pushl $137
80107910:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107915:	e9 56 f4 ff ff       	jmp    80106d70 <alltraps>

8010791a <vector138>:
.globl vector138
vector138:
  pushl $0
8010791a:	6a 00                	push   $0x0
  pushl $138
8010791c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107921:	e9 4a f4 ff ff       	jmp    80106d70 <alltraps>

80107926 <vector139>:
.globl vector139
vector139:
  pushl $0
80107926:	6a 00                	push   $0x0
  pushl $139
80107928:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010792d:	e9 3e f4 ff ff       	jmp    80106d70 <alltraps>

80107932 <vector140>:
.globl vector140
vector140:
  pushl $0
80107932:	6a 00                	push   $0x0
  pushl $140
80107934:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107939:	e9 32 f4 ff ff       	jmp    80106d70 <alltraps>

8010793e <vector141>:
.globl vector141
vector141:
  pushl $0
8010793e:	6a 00                	push   $0x0
  pushl $141
80107940:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107945:	e9 26 f4 ff ff       	jmp    80106d70 <alltraps>

8010794a <vector142>:
.globl vector142
vector142:
  pushl $0
8010794a:	6a 00                	push   $0x0
  pushl $142
8010794c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107951:	e9 1a f4 ff ff       	jmp    80106d70 <alltraps>

80107956 <vector143>:
.globl vector143
vector143:
  pushl $0
80107956:	6a 00                	push   $0x0
  pushl $143
80107958:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010795d:	e9 0e f4 ff ff       	jmp    80106d70 <alltraps>

80107962 <vector144>:
.globl vector144
vector144:
  pushl $0
80107962:	6a 00                	push   $0x0
  pushl $144
80107964:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107969:	e9 02 f4 ff ff       	jmp    80106d70 <alltraps>

8010796e <vector145>:
.globl vector145
vector145:
  pushl $0
8010796e:	6a 00                	push   $0x0
  pushl $145
80107970:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107975:	e9 f6 f3 ff ff       	jmp    80106d70 <alltraps>

8010797a <vector146>:
.globl vector146
vector146:
  pushl $0
8010797a:	6a 00                	push   $0x0
  pushl $146
8010797c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107981:	e9 ea f3 ff ff       	jmp    80106d70 <alltraps>

80107986 <vector147>:
.globl vector147
vector147:
  pushl $0
80107986:	6a 00                	push   $0x0
  pushl $147
80107988:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010798d:	e9 de f3 ff ff       	jmp    80106d70 <alltraps>

80107992 <vector148>:
.globl vector148
vector148:
  pushl $0
80107992:	6a 00                	push   $0x0
  pushl $148
80107994:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107999:	e9 d2 f3 ff ff       	jmp    80106d70 <alltraps>

8010799e <vector149>:
.globl vector149
vector149:
  pushl $0
8010799e:	6a 00                	push   $0x0
  pushl $149
801079a0:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801079a5:	e9 c6 f3 ff ff       	jmp    80106d70 <alltraps>

801079aa <vector150>:
.globl vector150
vector150:
  pushl $0
801079aa:	6a 00                	push   $0x0
  pushl $150
801079ac:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801079b1:	e9 ba f3 ff ff       	jmp    80106d70 <alltraps>

801079b6 <vector151>:
.globl vector151
vector151:
  pushl $0
801079b6:	6a 00                	push   $0x0
  pushl $151
801079b8:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801079bd:	e9 ae f3 ff ff       	jmp    80106d70 <alltraps>

801079c2 <vector152>:
.globl vector152
vector152:
  pushl $0
801079c2:	6a 00                	push   $0x0
  pushl $152
801079c4:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801079c9:	e9 a2 f3 ff ff       	jmp    80106d70 <alltraps>

801079ce <vector153>:
.globl vector153
vector153:
  pushl $0
801079ce:	6a 00                	push   $0x0
  pushl $153
801079d0:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801079d5:	e9 96 f3 ff ff       	jmp    80106d70 <alltraps>

801079da <vector154>:
.globl vector154
vector154:
  pushl $0
801079da:	6a 00                	push   $0x0
  pushl $154
801079dc:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801079e1:	e9 8a f3 ff ff       	jmp    80106d70 <alltraps>

801079e6 <vector155>:
.globl vector155
vector155:
  pushl $0
801079e6:	6a 00                	push   $0x0
  pushl $155
801079e8:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801079ed:	e9 7e f3 ff ff       	jmp    80106d70 <alltraps>

801079f2 <vector156>:
.globl vector156
vector156:
  pushl $0
801079f2:	6a 00                	push   $0x0
  pushl $156
801079f4:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801079f9:	e9 72 f3 ff ff       	jmp    80106d70 <alltraps>

801079fe <vector157>:
.globl vector157
vector157:
  pushl $0
801079fe:	6a 00                	push   $0x0
  pushl $157
80107a00:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107a05:	e9 66 f3 ff ff       	jmp    80106d70 <alltraps>

80107a0a <vector158>:
.globl vector158
vector158:
  pushl $0
80107a0a:	6a 00                	push   $0x0
  pushl $158
80107a0c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107a11:	e9 5a f3 ff ff       	jmp    80106d70 <alltraps>

80107a16 <vector159>:
.globl vector159
vector159:
  pushl $0
80107a16:	6a 00                	push   $0x0
  pushl $159
80107a18:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107a1d:	e9 4e f3 ff ff       	jmp    80106d70 <alltraps>

80107a22 <vector160>:
.globl vector160
vector160:
  pushl $0
80107a22:	6a 00                	push   $0x0
  pushl $160
80107a24:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107a29:	e9 42 f3 ff ff       	jmp    80106d70 <alltraps>

80107a2e <vector161>:
.globl vector161
vector161:
  pushl $0
80107a2e:	6a 00                	push   $0x0
  pushl $161
80107a30:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107a35:	e9 36 f3 ff ff       	jmp    80106d70 <alltraps>

80107a3a <vector162>:
.globl vector162
vector162:
  pushl $0
80107a3a:	6a 00                	push   $0x0
  pushl $162
80107a3c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107a41:	e9 2a f3 ff ff       	jmp    80106d70 <alltraps>

80107a46 <vector163>:
.globl vector163
vector163:
  pushl $0
80107a46:	6a 00                	push   $0x0
  pushl $163
80107a48:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107a4d:	e9 1e f3 ff ff       	jmp    80106d70 <alltraps>

80107a52 <vector164>:
.globl vector164
vector164:
  pushl $0
80107a52:	6a 00                	push   $0x0
  pushl $164
80107a54:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107a59:	e9 12 f3 ff ff       	jmp    80106d70 <alltraps>

80107a5e <vector165>:
.globl vector165
vector165:
  pushl $0
80107a5e:	6a 00                	push   $0x0
  pushl $165
80107a60:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107a65:	e9 06 f3 ff ff       	jmp    80106d70 <alltraps>

80107a6a <vector166>:
.globl vector166
vector166:
  pushl $0
80107a6a:	6a 00                	push   $0x0
  pushl $166
80107a6c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107a71:	e9 fa f2 ff ff       	jmp    80106d70 <alltraps>

80107a76 <vector167>:
.globl vector167
vector167:
  pushl $0
80107a76:	6a 00                	push   $0x0
  pushl $167
80107a78:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107a7d:	e9 ee f2 ff ff       	jmp    80106d70 <alltraps>

80107a82 <vector168>:
.globl vector168
vector168:
  pushl $0
80107a82:	6a 00                	push   $0x0
  pushl $168
80107a84:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107a89:	e9 e2 f2 ff ff       	jmp    80106d70 <alltraps>

80107a8e <vector169>:
.globl vector169
vector169:
  pushl $0
80107a8e:	6a 00                	push   $0x0
  pushl $169
80107a90:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107a95:	e9 d6 f2 ff ff       	jmp    80106d70 <alltraps>

80107a9a <vector170>:
.globl vector170
vector170:
  pushl $0
80107a9a:	6a 00                	push   $0x0
  pushl $170
80107a9c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107aa1:	e9 ca f2 ff ff       	jmp    80106d70 <alltraps>

80107aa6 <vector171>:
.globl vector171
vector171:
  pushl $0
80107aa6:	6a 00                	push   $0x0
  pushl $171
80107aa8:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107aad:	e9 be f2 ff ff       	jmp    80106d70 <alltraps>

80107ab2 <vector172>:
.globl vector172
vector172:
  pushl $0
80107ab2:	6a 00                	push   $0x0
  pushl $172
80107ab4:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107ab9:	e9 b2 f2 ff ff       	jmp    80106d70 <alltraps>

80107abe <vector173>:
.globl vector173
vector173:
  pushl $0
80107abe:	6a 00                	push   $0x0
  pushl $173
80107ac0:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107ac5:	e9 a6 f2 ff ff       	jmp    80106d70 <alltraps>

80107aca <vector174>:
.globl vector174
vector174:
  pushl $0
80107aca:	6a 00                	push   $0x0
  pushl $174
80107acc:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107ad1:	e9 9a f2 ff ff       	jmp    80106d70 <alltraps>

80107ad6 <vector175>:
.globl vector175
vector175:
  pushl $0
80107ad6:	6a 00                	push   $0x0
  pushl $175
80107ad8:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107add:	e9 8e f2 ff ff       	jmp    80106d70 <alltraps>

80107ae2 <vector176>:
.globl vector176
vector176:
  pushl $0
80107ae2:	6a 00                	push   $0x0
  pushl $176
80107ae4:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107ae9:	e9 82 f2 ff ff       	jmp    80106d70 <alltraps>

80107aee <vector177>:
.globl vector177
vector177:
  pushl $0
80107aee:	6a 00                	push   $0x0
  pushl $177
80107af0:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107af5:	e9 76 f2 ff ff       	jmp    80106d70 <alltraps>

80107afa <vector178>:
.globl vector178
vector178:
  pushl $0
80107afa:	6a 00                	push   $0x0
  pushl $178
80107afc:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107b01:	e9 6a f2 ff ff       	jmp    80106d70 <alltraps>

80107b06 <vector179>:
.globl vector179
vector179:
  pushl $0
80107b06:	6a 00                	push   $0x0
  pushl $179
80107b08:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107b0d:	e9 5e f2 ff ff       	jmp    80106d70 <alltraps>

80107b12 <vector180>:
.globl vector180
vector180:
  pushl $0
80107b12:	6a 00                	push   $0x0
  pushl $180
80107b14:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107b19:	e9 52 f2 ff ff       	jmp    80106d70 <alltraps>

80107b1e <vector181>:
.globl vector181
vector181:
  pushl $0
80107b1e:	6a 00                	push   $0x0
  pushl $181
80107b20:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107b25:	e9 46 f2 ff ff       	jmp    80106d70 <alltraps>

80107b2a <vector182>:
.globl vector182
vector182:
  pushl $0
80107b2a:	6a 00                	push   $0x0
  pushl $182
80107b2c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107b31:	e9 3a f2 ff ff       	jmp    80106d70 <alltraps>

80107b36 <vector183>:
.globl vector183
vector183:
  pushl $0
80107b36:	6a 00                	push   $0x0
  pushl $183
80107b38:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107b3d:	e9 2e f2 ff ff       	jmp    80106d70 <alltraps>

80107b42 <vector184>:
.globl vector184
vector184:
  pushl $0
80107b42:	6a 00                	push   $0x0
  pushl $184
80107b44:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107b49:	e9 22 f2 ff ff       	jmp    80106d70 <alltraps>

80107b4e <vector185>:
.globl vector185
vector185:
  pushl $0
80107b4e:	6a 00                	push   $0x0
  pushl $185
80107b50:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107b55:	e9 16 f2 ff ff       	jmp    80106d70 <alltraps>

80107b5a <vector186>:
.globl vector186
vector186:
  pushl $0
80107b5a:	6a 00                	push   $0x0
  pushl $186
80107b5c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107b61:	e9 0a f2 ff ff       	jmp    80106d70 <alltraps>

80107b66 <vector187>:
.globl vector187
vector187:
  pushl $0
80107b66:	6a 00                	push   $0x0
  pushl $187
80107b68:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107b6d:	e9 fe f1 ff ff       	jmp    80106d70 <alltraps>

80107b72 <vector188>:
.globl vector188
vector188:
  pushl $0
80107b72:	6a 00                	push   $0x0
  pushl $188
80107b74:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107b79:	e9 f2 f1 ff ff       	jmp    80106d70 <alltraps>

80107b7e <vector189>:
.globl vector189
vector189:
  pushl $0
80107b7e:	6a 00                	push   $0x0
  pushl $189
80107b80:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107b85:	e9 e6 f1 ff ff       	jmp    80106d70 <alltraps>

80107b8a <vector190>:
.globl vector190
vector190:
  pushl $0
80107b8a:	6a 00                	push   $0x0
  pushl $190
80107b8c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107b91:	e9 da f1 ff ff       	jmp    80106d70 <alltraps>

80107b96 <vector191>:
.globl vector191
vector191:
  pushl $0
80107b96:	6a 00                	push   $0x0
  pushl $191
80107b98:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107b9d:	e9 ce f1 ff ff       	jmp    80106d70 <alltraps>

80107ba2 <vector192>:
.globl vector192
vector192:
  pushl $0
80107ba2:	6a 00                	push   $0x0
  pushl $192
80107ba4:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107ba9:	e9 c2 f1 ff ff       	jmp    80106d70 <alltraps>

80107bae <vector193>:
.globl vector193
vector193:
  pushl $0
80107bae:	6a 00                	push   $0x0
  pushl $193
80107bb0:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107bb5:	e9 b6 f1 ff ff       	jmp    80106d70 <alltraps>

80107bba <vector194>:
.globl vector194
vector194:
  pushl $0
80107bba:	6a 00                	push   $0x0
  pushl $194
80107bbc:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107bc1:	e9 aa f1 ff ff       	jmp    80106d70 <alltraps>

80107bc6 <vector195>:
.globl vector195
vector195:
  pushl $0
80107bc6:	6a 00                	push   $0x0
  pushl $195
80107bc8:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107bcd:	e9 9e f1 ff ff       	jmp    80106d70 <alltraps>

80107bd2 <vector196>:
.globl vector196
vector196:
  pushl $0
80107bd2:	6a 00                	push   $0x0
  pushl $196
80107bd4:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107bd9:	e9 92 f1 ff ff       	jmp    80106d70 <alltraps>

80107bde <vector197>:
.globl vector197
vector197:
  pushl $0
80107bde:	6a 00                	push   $0x0
  pushl $197
80107be0:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107be5:	e9 86 f1 ff ff       	jmp    80106d70 <alltraps>

80107bea <vector198>:
.globl vector198
vector198:
  pushl $0
80107bea:	6a 00                	push   $0x0
  pushl $198
80107bec:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107bf1:	e9 7a f1 ff ff       	jmp    80106d70 <alltraps>

80107bf6 <vector199>:
.globl vector199
vector199:
  pushl $0
80107bf6:	6a 00                	push   $0x0
  pushl $199
80107bf8:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107bfd:	e9 6e f1 ff ff       	jmp    80106d70 <alltraps>

80107c02 <vector200>:
.globl vector200
vector200:
  pushl $0
80107c02:	6a 00                	push   $0x0
  pushl $200
80107c04:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107c09:	e9 62 f1 ff ff       	jmp    80106d70 <alltraps>

80107c0e <vector201>:
.globl vector201
vector201:
  pushl $0
80107c0e:	6a 00                	push   $0x0
  pushl $201
80107c10:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107c15:	e9 56 f1 ff ff       	jmp    80106d70 <alltraps>

80107c1a <vector202>:
.globl vector202
vector202:
  pushl $0
80107c1a:	6a 00                	push   $0x0
  pushl $202
80107c1c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107c21:	e9 4a f1 ff ff       	jmp    80106d70 <alltraps>

80107c26 <vector203>:
.globl vector203
vector203:
  pushl $0
80107c26:	6a 00                	push   $0x0
  pushl $203
80107c28:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107c2d:	e9 3e f1 ff ff       	jmp    80106d70 <alltraps>

80107c32 <vector204>:
.globl vector204
vector204:
  pushl $0
80107c32:	6a 00                	push   $0x0
  pushl $204
80107c34:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107c39:	e9 32 f1 ff ff       	jmp    80106d70 <alltraps>

80107c3e <vector205>:
.globl vector205
vector205:
  pushl $0
80107c3e:	6a 00                	push   $0x0
  pushl $205
80107c40:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107c45:	e9 26 f1 ff ff       	jmp    80106d70 <alltraps>

80107c4a <vector206>:
.globl vector206
vector206:
  pushl $0
80107c4a:	6a 00                	push   $0x0
  pushl $206
80107c4c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107c51:	e9 1a f1 ff ff       	jmp    80106d70 <alltraps>

80107c56 <vector207>:
.globl vector207
vector207:
  pushl $0
80107c56:	6a 00                	push   $0x0
  pushl $207
80107c58:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107c5d:	e9 0e f1 ff ff       	jmp    80106d70 <alltraps>

80107c62 <vector208>:
.globl vector208
vector208:
  pushl $0
80107c62:	6a 00                	push   $0x0
  pushl $208
80107c64:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107c69:	e9 02 f1 ff ff       	jmp    80106d70 <alltraps>

80107c6e <vector209>:
.globl vector209
vector209:
  pushl $0
80107c6e:	6a 00                	push   $0x0
  pushl $209
80107c70:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107c75:	e9 f6 f0 ff ff       	jmp    80106d70 <alltraps>

80107c7a <vector210>:
.globl vector210
vector210:
  pushl $0
80107c7a:	6a 00                	push   $0x0
  pushl $210
80107c7c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107c81:	e9 ea f0 ff ff       	jmp    80106d70 <alltraps>

80107c86 <vector211>:
.globl vector211
vector211:
  pushl $0
80107c86:	6a 00                	push   $0x0
  pushl $211
80107c88:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107c8d:	e9 de f0 ff ff       	jmp    80106d70 <alltraps>

80107c92 <vector212>:
.globl vector212
vector212:
  pushl $0
80107c92:	6a 00                	push   $0x0
  pushl $212
80107c94:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107c99:	e9 d2 f0 ff ff       	jmp    80106d70 <alltraps>

80107c9e <vector213>:
.globl vector213
vector213:
  pushl $0
80107c9e:	6a 00                	push   $0x0
  pushl $213
80107ca0:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107ca5:	e9 c6 f0 ff ff       	jmp    80106d70 <alltraps>

80107caa <vector214>:
.globl vector214
vector214:
  pushl $0
80107caa:	6a 00                	push   $0x0
  pushl $214
80107cac:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107cb1:	e9 ba f0 ff ff       	jmp    80106d70 <alltraps>

80107cb6 <vector215>:
.globl vector215
vector215:
  pushl $0
80107cb6:	6a 00                	push   $0x0
  pushl $215
80107cb8:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107cbd:	e9 ae f0 ff ff       	jmp    80106d70 <alltraps>

80107cc2 <vector216>:
.globl vector216
vector216:
  pushl $0
80107cc2:	6a 00                	push   $0x0
  pushl $216
80107cc4:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107cc9:	e9 a2 f0 ff ff       	jmp    80106d70 <alltraps>

80107cce <vector217>:
.globl vector217
vector217:
  pushl $0
80107cce:	6a 00                	push   $0x0
  pushl $217
80107cd0:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107cd5:	e9 96 f0 ff ff       	jmp    80106d70 <alltraps>

80107cda <vector218>:
.globl vector218
vector218:
  pushl $0
80107cda:	6a 00                	push   $0x0
  pushl $218
80107cdc:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107ce1:	e9 8a f0 ff ff       	jmp    80106d70 <alltraps>

80107ce6 <vector219>:
.globl vector219
vector219:
  pushl $0
80107ce6:	6a 00                	push   $0x0
  pushl $219
80107ce8:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107ced:	e9 7e f0 ff ff       	jmp    80106d70 <alltraps>

80107cf2 <vector220>:
.globl vector220
vector220:
  pushl $0
80107cf2:	6a 00                	push   $0x0
  pushl $220
80107cf4:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107cf9:	e9 72 f0 ff ff       	jmp    80106d70 <alltraps>

80107cfe <vector221>:
.globl vector221
vector221:
  pushl $0
80107cfe:	6a 00                	push   $0x0
  pushl $221
80107d00:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107d05:	e9 66 f0 ff ff       	jmp    80106d70 <alltraps>

80107d0a <vector222>:
.globl vector222
vector222:
  pushl $0
80107d0a:	6a 00                	push   $0x0
  pushl $222
80107d0c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107d11:	e9 5a f0 ff ff       	jmp    80106d70 <alltraps>

80107d16 <vector223>:
.globl vector223
vector223:
  pushl $0
80107d16:	6a 00                	push   $0x0
  pushl $223
80107d18:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107d1d:	e9 4e f0 ff ff       	jmp    80106d70 <alltraps>

80107d22 <vector224>:
.globl vector224
vector224:
  pushl $0
80107d22:	6a 00                	push   $0x0
  pushl $224
80107d24:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107d29:	e9 42 f0 ff ff       	jmp    80106d70 <alltraps>

80107d2e <vector225>:
.globl vector225
vector225:
  pushl $0
80107d2e:	6a 00                	push   $0x0
  pushl $225
80107d30:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107d35:	e9 36 f0 ff ff       	jmp    80106d70 <alltraps>

80107d3a <vector226>:
.globl vector226
vector226:
  pushl $0
80107d3a:	6a 00                	push   $0x0
  pushl $226
80107d3c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107d41:	e9 2a f0 ff ff       	jmp    80106d70 <alltraps>

80107d46 <vector227>:
.globl vector227
vector227:
  pushl $0
80107d46:	6a 00                	push   $0x0
  pushl $227
80107d48:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107d4d:	e9 1e f0 ff ff       	jmp    80106d70 <alltraps>

80107d52 <vector228>:
.globl vector228
vector228:
  pushl $0
80107d52:	6a 00                	push   $0x0
  pushl $228
80107d54:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107d59:	e9 12 f0 ff ff       	jmp    80106d70 <alltraps>

80107d5e <vector229>:
.globl vector229
vector229:
  pushl $0
80107d5e:	6a 00                	push   $0x0
  pushl $229
80107d60:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107d65:	e9 06 f0 ff ff       	jmp    80106d70 <alltraps>

80107d6a <vector230>:
.globl vector230
vector230:
  pushl $0
80107d6a:	6a 00                	push   $0x0
  pushl $230
80107d6c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107d71:	e9 fa ef ff ff       	jmp    80106d70 <alltraps>

80107d76 <vector231>:
.globl vector231
vector231:
  pushl $0
80107d76:	6a 00                	push   $0x0
  pushl $231
80107d78:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107d7d:	e9 ee ef ff ff       	jmp    80106d70 <alltraps>

80107d82 <vector232>:
.globl vector232
vector232:
  pushl $0
80107d82:	6a 00                	push   $0x0
  pushl $232
80107d84:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107d89:	e9 e2 ef ff ff       	jmp    80106d70 <alltraps>

80107d8e <vector233>:
.globl vector233
vector233:
  pushl $0
80107d8e:	6a 00                	push   $0x0
  pushl $233
80107d90:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107d95:	e9 d6 ef ff ff       	jmp    80106d70 <alltraps>

80107d9a <vector234>:
.globl vector234
vector234:
  pushl $0
80107d9a:	6a 00                	push   $0x0
  pushl $234
80107d9c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107da1:	e9 ca ef ff ff       	jmp    80106d70 <alltraps>

80107da6 <vector235>:
.globl vector235
vector235:
  pushl $0
80107da6:	6a 00                	push   $0x0
  pushl $235
80107da8:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107dad:	e9 be ef ff ff       	jmp    80106d70 <alltraps>

80107db2 <vector236>:
.globl vector236
vector236:
  pushl $0
80107db2:	6a 00                	push   $0x0
  pushl $236
80107db4:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107db9:	e9 b2 ef ff ff       	jmp    80106d70 <alltraps>

80107dbe <vector237>:
.globl vector237
vector237:
  pushl $0
80107dbe:	6a 00                	push   $0x0
  pushl $237
80107dc0:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107dc5:	e9 a6 ef ff ff       	jmp    80106d70 <alltraps>

80107dca <vector238>:
.globl vector238
vector238:
  pushl $0
80107dca:	6a 00                	push   $0x0
  pushl $238
80107dcc:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107dd1:	e9 9a ef ff ff       	jmp    80106d70 <alltraps>

80107dd6 <vector239>:
.globl vector239
vector239:
  pushl $0
80107dd6:	6a 00                	push   $0x0
  pushl $239
80107dd8:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107ddd:	e9 8e ef ff ff       	jmp    80106d70 <alltraps>

80107de2 <vector240>:
.globl vector240
vector240:
  pushl $0
80107de2:	6a 00                	push   $0x0
  pushl $240
80107de4:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107de9:	e9 82 ef ff ff       	jmp    80106d70 <alltraps>

80107dee <vector241>:
.globl vector241
vector241:
  pushl $0
80107dee:	6a 00                	push   $0x0
  pushl $241
80107df0:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107df5:	e9 76 ef ff ff       	jmp    80106d70 <alltraps>

80107dfa <vector242>:
.globl vector242
vector242:
  pushl $0
80107dfa:	6a 00                	push   $0x0
  pushl $242
80107dfc:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107e01:	e9 6a ef ff ff       	jmp    80106d70 <alltraps>

80107e06 <vector243>:
.globl vector243
vector243:
  pushl $0
80107e06:	6a 00                	push   $0x0
  pushl $243
80107e08:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107e0d:	e9 5e ef ff ff       	jmp    80106d70 <alltraps>

80107e12 <vector244>:
.globl vector244
vector244:
  pushl $0
80107e12:	6a 00                	push   $0x0
  pushl $244
80107e14:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107e19:	e9 52 ef ff ff       	jmp    80106d70 <alltraps>

80107e1e <vector245>:
.globl vector245
vector245:
  pushl $0
80107e1e:	6a 00                	push   $0x0
  pushl $245
80107e20:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107e25:	e9 46 ef ff ff       	jmp    80106d70 <alltraps>

80107e2a <vector246>:
.globl vector246
vector246:
  pushl $0
80107e2a:	6a 00                	push   $0x0
  pushl $246
80107e2c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107e31:	e9 3a ef ff ff       	jmp    80106d70 <alltraps>

80107e36 <vector247>:
.globl vector247
vector247:
  pushl $0
80107e36:	6a 00                	push   $0x0
  pushl $247
80107e38:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107e3d:	e9 2e ef ff ff       	jmp    80106d70 <alltraps>

80107e42 <vector248>:
.globl vector248
vector248:
  pushl $0
80107e42:	6a 00                	push   $0x0
  pushl $248
80107e44:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107e49:	e9 22 ef ff ff       	jmp    80106d70 <alltraps>

80107e4e <vector249>:
.globl vector249
vector249:
  pushl $0
80107e4e:	6a 00                	push   $0x0
  pushl $249
80107e50:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107e55:	e9 16 ef ff ff       	jmp    80106d70 <alltraps>

80107e5a <vector250>:
.globl vector250
vector250:
  pushl $0
80107e5a:	6a 00                	push   $0x0
  pushl $250
80107e5c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107e61:	e9 0a ef ff ff       	jmp    80106d70 <alltraps>

80107e66 <vector251>:
.globl vector251
vector251:
  pushl $0
80107e66:	6a 00                	push   $0x0
  pushl $251
80107e68:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107e6d:	e9 fe ee ff ff       	jmp    80106d70 <alltraps>

80107e72 <vector252>:
.globl vector252
vector252:
  pushl $0
80107e72:	6a 00                	push   $0x0
  pushl $252
80107e74:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107e79:	e9 f2 ee ff ff       	jmp    80106d70 <alltraps>

80107e7e <vector253>:
.globl vector253
vector253:
  pushl $0
80107e7e:	6a 00                	push   $0x0
  pushl $253
80107e80:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107e85:	e9 e6 ee ff ff       	jmp    80106d70 <alltraps>

80107e8a <vector254>:
.globl vector254
vector254:
  pushl $0
80107e8a:	6a 00                	push   $0x0
  pushl $254
80107e8c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107e91:	e9 da ee ff ff       	jmp    80106d70 <alltraps>

80107e96 <vector255>:
.globl vector255
vector255:
  pushl $0
80107e96:	6a 00                	push   $0x0
  pushl $255
80107e98:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107e9d:	e9 ce ee ff ff       	jmp    80106d70 <alltraps>
80107ea2:	66 90                	xchg   %ax,%ax

80107ea4 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107ea4:	55                   	push   %ebp
80107ea5:	89 e5                	mov    %esp,%ebp
80107ea7:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ead:	48                   	dec    %eax
80107eae:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107eb2:	8b 45 08             	mov    0x8(%ebp),%eax
80107eb5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107eb9:	8b 45 08             	mov    0x8(%ebp),%eax
80107ebc:	c1 e8 10             	shr    $0x10,%eax
80107ebf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107ec3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107ec6:	0f 01 10             	lgdtl  (%eax)
}
80107ec9:	c9                   	leave  
80107eca:	c3                   	ret    

80107ecb <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107ecb:	55                   	push   %ebp
80107ecc:	89 e5                	mov    %esp,%ebp
80107ece:	83 ec 04             	sub    $0x4,%esp
80107ed1:	8b 45 08             	mov    0x8(%ebp),%eax
80107ed4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107ed8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107edb:	0f 00 d8             	ltr    %ax
}
80107ede:	c9                   	leave  
80107edf:	c3                   	ret    

80107ee0 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107ee0:	55                   	push   %ebp
80107ee1:	89 e5                	mov    %esp,%ebp
80107ee3:	83 ec 04             	sub    $0x4,%esp
80107ee6:	8b 45 08             	mov    0x8(%ebp),%eax
80107ee9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107ef0:	8e e8                	mov    %eax,%gs
}
80107ef2:	c9                   	leave  
80107ef3:	c3                   	ret    

80107ef4 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107ef4:	55                   	push   %ebp
80107ef5:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ef7:	8b 45 08             	mov    0x8(%ebp),%eax
80107efa:	0f 22 d8             	mov    %eax,%cr3
}
80107efd:	5d                   	pop    %ebp
80107efe:	c3                   	ret    

80107eff <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107eff:	55                   	push   %ebp
80107f00:	89 e5                	mov    %esp,%ebp
80107f02:	8b 45 08             	mov    0x8(%ebp),%eax
80107f05:	05 00 00 00 80       	add    $0x80000000,%eax
80107f0a:	5d                   	pop    %ebp
80107f0b:	c3                   	ret    

80107f0c <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107f0c:	55                   	push   %ebp
80107f0d:	89 e5                	mov    %esp,%ebp
80107f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80107f12:	05 00 00 00 80       	add    $0x80000000,%eax
80107f17:	5d                   	pop    %ebp
80107f18:	c3                   	ret    

80107f19 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107f19:	55                   	push   %ebp
80107f1a:	89 e5                	mov    %esp,%ebp
80107f1c:	53                   	push   %ebx
80107f1d:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107f20:	e8 7e b4 ff ff       	call   801033a3 <cpunum>
80107f25:	89 c2                	mov    %eax,%edx
80107f27:	89 d0                	mov    %edx,%eax
80107f29:	d1 e0                	shl    %eax
80107f2b:	01 d0                	add    %edx,%eax
80107f2d:	c1 e0 04             	shl    $0x4,%eax
80107f30:	29 d0                	sub    %edx,%eax
80107f32:	c1 e0 02             	shl    $0x2,%eax
80107f35:	05 80 19 11 80       	add    $0x80111980,%eax
80107f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f40:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f49:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f52:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f59:	8a 50 7d             	mov    0x7d(%eax),%dl
80107f5c:	83 e2 f0             	and    $0xfffffff0,%edx
80107f5f:	83 ca 0a             	or     $0xa,%edx
80107f62:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f68:	8a 50 7d             	mov    0x7d(%eax),%dl
80107f6b:	83 ca 10             	or     $0x10,%edx
80107f6e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f74:	8a 50 7d             	mov    0x7d(%eax),%dl
80107f77:	83 e2 9f             	and    $0xffffff9f,%edx
80107f7a:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f80:	8a 50 7d             	mov    0x7d(%eax),%dl
80107f83:	83 ca 80             	or     $0xffffff80,%edx
80107f86:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f8c:	8a 50 7e             	mov    0x7e(%eax),%dl
80107f8f:	83 ca 0f             	or     $0xf,%edx
80107f92:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f98:	8a 50 7e             	mov    0x7e(%eax),%dl
80107f9b:	83 e2 ef             	and    $0xffffffef,%edx
80107f9e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa4:	8a 50 7e             	mov    0x7e(%eax),%dl
80107fa7:	83 e2 df             	and    $0xffffffdf,%edx
80107faa:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb0:	8a 50 7e             	mov    0x7e(%eax),%dl
80107fb3:	83 ca 40             	or     $0x40,%edx
80107fb6:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fbc:	8a 50 7e             	mov    0x7e(%eax),%dl
80107fbf:	83 ca 80             	or     $0xffffff80,%edx
80107fc2:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc8:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fcf:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107fd6:	ff ff 
80107fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdb:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107fe2:	00 00 
80107fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe7:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff1:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107ff7:	83 e2 f0             	and    $0xfffffff0,%edx
80107ffa:	83 ca 02             	or     $0x2,%edx
80107ffd:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108003:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108006:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010800c:	83 ca 10             	or     $0x10,%edx
8010800f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108015:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108018:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010801e:	83 e2 9f             	and    $0xffffff9f,%edx
80108021:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108027:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802a:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80108030:	83 ca 80             	or     $0xffffff80,%edx
80108033:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108039:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803c:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80108042:	83 ca 0f             	or     $0xf,%edx
80108045:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010804b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804e:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80108054:	83 e2 ef             	and    $0xffffffef,%edx
80108057:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010805d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108060:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80108066:	83 e2 df             	and    $0xffffffdf,%edx
80108069:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010806f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108072:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80108078:	83 ca 40             	or     $0x40,%edx
8010807b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108084:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010808a:	83 ca 80             	or     $0xffffff80,%edx
8010808d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108093:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108096:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010809d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a0:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801080a7:	ff ff 
801080a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ac:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801080b3:	00 00 
801080b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b8:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801080bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c2:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801080c8:	83 e2 f0             	and    $0xfffffff0,%edx
801080cb:	83 ca 0a             	or     $0xa,%edx
801080ce:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801080d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d7:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801080dd:	83 ca 10             	or     $0x10,%edx
801080e0:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801080e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e9:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801080ef:	83 ca 60             	or     $0x60,%edx
801080f2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801080f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fb:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80108101:	83 ca 80             	or     $0xffffff80,%edx
80108104:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010810a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810d:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80108113:	83 ca 0f             	or     $0xf,%edx
80108116:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010811c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811f:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80108125:	83 e2 ef             	and    $0xffffffef,%edx
80108128:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010812e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108131:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80108137:	83 e2 df             	and    $0xffffffdf,%edx
8010813a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108140:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108143:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80108149:	83 ca 40             	or     $0x40,%edx
8010814c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108155:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010815b:	83 ca 80             	or     $0xffffff80,%edx
8010815e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108167:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010816e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108171:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108178:	ff ff 
8010817a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817d:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108184:	00 00 
80108186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108189:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108193:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80108199:	83 e2 f0             	and    $0xfffffff0,%edx
8010819c:	83 ca 02             	or     $0x2,%edx
8010819f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a8:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801081ae:	83 ca 10             	or     $0x10,%edx
801081b1:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ba:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801081c0:	83 ca 60             	or     $0x60,%edx
801081c3:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cc:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801081d2:	83 ca 80             	or     $0xffffff80,%edx
801081d5:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081de:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801081e4:	83 ca 0f             	or     $0xf,%edx
801081e7:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801081ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f0:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801081f6:	83 e2 ef             	and    $0xffffffef,%edx
801081f9:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801081ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108202:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80108208:	83 e2 df             	and    $0xffffffdf,%edx
8010820b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108211:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108214:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010821a:	83 ca 40             	or     $0x40,%edx
8010821d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108223:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108226:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010822c:	83 ca 80             	or     $0xffffff80,%edx
8010822f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108235:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108238:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010823f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108242:	05 b4 00 00 00       	add    $0xb4,%eax
80108247:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010824a:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80108250:	c1 ea 10             	shr    $0x10,%edx
80108253:	88 d1                	mov    %dl,%cl
80108255:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108258:	81 c2 b4 00 00 00    	add    $0xb4,%edx
8010825e:	c1 ea 18             	shr    $0x18,%edx
80108261:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80108264:	66 c7 83 88 00 00 00 	movw   $0x0,0x88(%ebx)
8010826b:	00 00 
8010826d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80108270:	66 89 83 8a 00 00 00 	mov    %ax,0x8a(%ebx)
80108277:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827a:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80108280:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108283:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80108289:	83 e1 f0             	and    $0xfffffff0,%ecx
8010828c:	83 c9 02             	or     $0x2,%ecx
8010828f:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108295:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108298:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
8010829e:	83 c9 10             	or     $0x10,%ecx
801082a1:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801082a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082aa:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801082b0:	83 e1 9f             	and    $0xffffff9f,%ecx
801082b3:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801082b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082bc:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801082c2:	83 c9 80             	or     $0xffffff80,%ecx
801082c5:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801082cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ce:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
801082d4:	83 e1 f0             	and    $0xfffffff0,%ecx
801082d7:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801082dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e0:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
801082e6:	83 e1 ef             	and    $0xffffffef,%ecx
801082e9:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801082ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f2:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
801082f8:	83 e1 df             	and    $0xffffffdf,%ecx
801082fb:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108304:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
8010830a:	83 c9 40             	or     $0x40,%ecx
8010830d:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108313:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108316:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
8010831c:	83 c9 80             	or     $0xffffff80,%ecx
8010831f:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108325:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108328:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
8010832e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108331:	83 c0 70             	add    $0x70,%eax
80108334:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
8010833b:	00 
8010833c:	89 04 24             	mov    %eax,(%esp)
8010833f:	e8 60 fb ff ff       	call   80107ea4 <lgdt>
  loadgs(SEG_KCPU << 3);
80108344:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
8010834b:	e8 90 fb ff ff       	call   80107ee0 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80108350:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108353:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108359:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108360:	00 00 00 00 
}
80108364:	83 c4 24             	add    $0x24,%esp
80108367:	5b                   	pop    %ebx
80108368:	5d                   	pop    %ebp
80108369:	c3                   	ret    

8010836a <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010836a:	55                   	push   %ebp
8010836b:	89 e5                	mov    %esp,%ebp
8010836d:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108370:	8b 45 0c             	mov    0xc(%ebp),%eax
80108373:	c1 e8 16             	shr    $0x16,%eax
80108376:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010837d:	8b 45 08             	mov    0x8(%ebp),%eax
80108380:	01 d0                	add    %edx,%eax
80108382:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108385:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108388:	8b 00                	mov    (%eax),%eax
8010838a:	83 e0 01             	and    $0x1,%eax
8010838d:	85 c0                	test   %eax,%eax
8010838f:	74 17                	je     801083a8 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108391:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108394:	8b 00                	mov    (%eax),%eax
80108396:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010839b:	89 04 24             	mov    %eax,(%esp)
8010839e:	e8 69 fb ff ff       	call   80107f0c <p2v>
801083a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801083a6:	eb 4b                	jmp    801083f3 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801083a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801083ac:	74 0e                	je     801083bc <walkpgdir+0x52>
801083ae:	e8 68 ac ff ff       	call   8010301b <kalloc>
801083b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801083b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801083ba:	75 07                	jne    801083c3 <walkpgdir+0x59>
      return 0;
801083bc:	b8 00 00 00 00       	mov    $0x0,%eax
801083c1:	eb 47                	jmp    8010840a <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801083c3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801083ca:	00 
801083cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801083d2:	00 
801083d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d6:	89 04 24             	mov    %eax,(%esp)
801083d9:	e8 94 d4 ff ff       	call   80105872 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801083de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e1:	89 04 24             	mov    %eax,(%esp)
801083e4:	e8 16 fb ff ff       	call   80107eff <v2p>
801083e9:	89 c2                	mov    %eax,%edx
801083eb:	83 ca 07             	or     $0x7,%edx
801083ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083f1:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801083f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801083f6:	c1 e8 0c             	shr    $0xc,%eax
801083f9:	25 ff 03 00 00       	and    $0x3ff,%eax
801083fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108405:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108408:	01 d0                	add    %edx,%eax
}
8010840a:	c9                   	leave  
8010840b:	c3                   	ret    

8010840c <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010840c:	55                   	push   %ebp
8010840d:	89 e5                	mov    %esp,%ebp
8010840f:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108412:	8b 45 0c             	mov    0xc(%ebp),%eax
80108415:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010841a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010841d:	8b 55 0c             	mov    0xc(%ebp),%edx
80108420:	8b 45 10             	mov    0x10(%ebp),%eax
80108423:	01 d0                	add    %edx,%eax
80108425:	48                   	dec    %eax
80108426:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010842b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010842e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80108435:	00 
80108436:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108439:	89 44 24 04          	mov    %eax,0x4(%esp)
8010843d:	8b 45 08             	mov    0x8(%ebp),%eax
80108440:	89 04 24             	mov    %eax,(%esp)
80108443:	e8 22 ff ff ff       	call   8010836a <walkpgdir>
80108448:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010844b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010844f:	75 07                	jne    80108458 <mappages+0x4c>
      return -1;
80108451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108456:	eb 46                	jmp    8010849e <mappages+0x92>
    if(*pte & PTE_P)
80108458:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010845b:	8b 00                	mov    (%eax),%eax
8010845d:	83 e0 01             	and    $0x1,%eax
80108460:	85 c0                	test   %eax,%eax
80108462:	74 0c                	je     80108470 <mappages+0x64>
      panic("remap");
80108464:	c7 04 24 94 92 10 80 	movl   $0x80109294,(%esp)
8010846b:	e8 c6 80 ff ff       	call   80100536 <panic>
    *pte = pa | perm | PTE_P;
80108470:	8b 45 18             	mov    0x18(%ebp),%eax
80108473:	0b 45 14             	or     0x14(%ebp),%eax
80108476:	89 c2                	mov    %eax,%edx
80108478:	83 ca 01             	or     $0x1,%edx
8010847b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010847e:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108480:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108483:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108486:	74 10                	je     80108498 <mappages+0x8c>
      break;
    a += PGSIZE;
80108488:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010848f:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108496:	eb 96                	jmp    8010842e <mappages+0x22>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108498:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108499:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010849e:	c9                   	leave  
8010849f:	c3                   	ret    

801084a0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm()
{
801084a0:	55                   	push   %ebp
801084a1:	89 e5                	mov    %esp,%ebp
801084a3:	53                   	push   %ebx
801084a4:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801084a7:	e8 6f ab ff ff       	call   8010301b <kalloc>
801084ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
801084af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801084b3:	75 0a                	jne    801084bf <setupkvm+0x1f>
    return 0;
801084b5:	b8 00 00 00 00       	mov    $0x0,%eax
801084ba:	e9 98 00 00 00       	jmp    80108557 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
801084bf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801084c6:	00 
801084c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801084ce:	00 
801084cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084d2:	89 04 24             	mov    %eax,(%esp)
801084d5:	e8 98 d3 ff ff       	call   80105872 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801084da:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
801084e1:	e8 26 fa ff ff       	call   80107f0c <p2v>
801084e6:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801084eb:	76 0c                	jbe    801084f9 <setupkvm+0x59>
    panic("PHYSTOP too high");
801084ed:	c7 04 24 9a 92 10 80 	movl   $0x8010929a,(%esp)
801084f4:	e8 3d 80 ff ff       	call   80100536 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801084f9:	c7 45 f4 a0 c4 10 80 	movl   $0x8010c4a0,-0xc(%ebp)
80108500:	eb 49                	jmp    8010854b <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
80108502:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108505:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108508:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010850b:	8b 50 04             	mov    0x4(%eax),%edx
8010850e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108511:	8b 58 08             	mov    0x8(%eax),%ebx
80108514:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108517:	8b 40 04             	mov    0x4(%eax),%eax
8010851a:	29 c3                	sub    %eax,%ebx
8010851c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010851f:	8b 00                	mov    (%eax),%eax
80108521:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80108525:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108529:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010852d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108531:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108534:	89 04 24             	mov    %eax,(%esp)
80108537:	e8 d0 fe ff ff       	call   8010840c <mappages>
8010853c:	85 c0                	test   %eax,%eax
8010853e:	79 07                	jns    80108547 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108540:	b8 00 00 00 00       	mov    $0x0,%eax
80108545:	eb 10                	jmp    80108557 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108547:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010854b:	81 7d f4 e0 c4 10 80 	cmpl   $0x8010c4e0,-0xc(%ebp)
80108552:	72 ae                	jb     80108502 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108554:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108557:	83 c4 34             	add    $0x34,%esp
8010855a:	5b                   	pop    %ebx
8010855b:	5d                   	pop    %ebp
8010855c:	c3                   	ret    

8010855d <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010855d:	55                   	push   %ebp
8010855e:	89 e5                	mov    %esp,%ebp
80108560:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108563:	e8 38 ff ff ff       	call   801084a0 <setupkvm>
80108568:	a3 18 50 11 80       	mov    %eax,0x80115018
  switchkvm();
8010856d:	e8 02 00 00 00       	call   80108574 <switchkvm>
}
80108572:	c9                   	leave  
80108573:	c3                   	ret    

80108574 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108574:	55                   	push   %ebp
80108575:	89 e5                	mov    %esp,%ebp
80108577:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010857a:	a1 18 50 11 80       	mov    0x80115018,%eax
8010857f:	89 04 24             	mov    %eax,(%esp)
80108582:	e8 78 f9 ff ff       	call   80107eff <v2p>
80108587:	89 04 24             	mov    %eax,(%esp)
8010858a:	e8 65 f9 ff ff       	call   80107ef4 <lcr3>
}
8010858f:	c9                   	leave  
80108590:	c3                   	ret    

80108591 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108591:	55                   	push   %ebp
80108592:	89 e5                	mov    %esp,%ebp
80108594:	53                   	push   %ebx
80108595:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80108598:	e8 d4 d1 ff ff       	call   80105771 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010859d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801085a3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801085aa:	83 c2 08             	add    $0x8,%edx
801085ad:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
801085b4:	83 c1 08             	add    $0x8,%ecx
801085b7:	c1 e9 10             	shr    $0x10,%ecx
801085ba:	88 cb                	mov    %cl,%bl
801085bc:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
801085c3:	83 c1 08             	add    $0x8,%ecx
801085c6:	c1 e9 18             	shr    $0x18,%ecx
801085c9:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801085d0:	67 00 
801085d2:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
801085d9:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801085df:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
801085e5:	83 e2 f0             	and    $0xfffffff0,%edx
801085e8:	83 ca 09             	or     $0x9,%edx
801085eb:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801085f1:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
801085f7:	83 ca 10             	or     $0x10,%edx
801085fa:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108600:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80108606:	83 e2 9f             	and    $0xffffff9f,%edx
80108609:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010860f:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80108615:	83 ca 80             	or     $0xffffff80,%edx
80108618:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010861e:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108624:	83 e2 f0             	and    $0xfffffff0,%edx
80108627:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010862d:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108633:	83 e2 ef             	and    $0xffffffef,%edx
80108636:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010863c:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108642:	83 e2 df             	and    $0xffffffdf,%edx
80108645:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010864b:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108651:	83 ca 40             	or     $0x40,%edx
80108654:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010865a:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108660:	83 e2 7f             	and    $0x7f,%edx
80108663:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108669:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010866f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108675:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010867b:	83 e2 ef             	and    $0xffffffef,%edx
8010867e:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108684:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010868a:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108690:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108696:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010869d:	8b 52 08             	mov    0x8(%edx),%edx
801086a0:	81 c2 00 10 00 00    	add    $0x1000,%edx
801086a6:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801086a9:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
801086b0:	e8 16 f8 ff ff       	call   80107ecb <ltr>
  if(p->pgdir == 0)
801086b5:	8b 45 08             	mov    0x8(%ebp),%eax
801086b8:	8b 40 04             	mov    0x4(%eax),%eax
801086bb:	85 c0                	test   %eax,%eax
801086bd:	75 0c                	jne    801086cb <switchuvm+0x13a>
    panic("switchuvm: no pgdir");
801086bf:	c7 04 24 ab 92 10 80 	movl   $0x801092ab,(%esp)
801086c6:	e8 6b 7e ff ff       	call   80100536 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801086cb:	8b 45 08             	mov    0x8(%ebp),%eax
801086ce:	8b 40 04             	mov    0x4(%eax),%eax
801086d1:	89 04 24             	mov    %eax,(%esp)
801086d4:	e8 26 f8 ff ff       	call   80107eff <v2p>
801086d9:	89 04 24             	mov    %eax,(%esp)
801086dc:	e8 13 f8 ff ff       	call   80107ef4 <lcr3>
  popcli();
801086e1:	e8 d1 d0 ff ff       	call   801057b7 <popcli>
}
801086e6:	83 c4 14             	add    $0x14,%esp
801086e9:	5b                   	pop    %ebx
801086ea:	5d                   	pop    %ebp
801086eb:	c3                   	ret    

801086ec <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801086ec:	55                   	push   %ebp
801086ed:	89 e5                	mov    %esp,%ebp
801086ef:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801086f2:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801086f9:	76 0c                	jbe    80108707 <inituvm+0x1b>
    panic("inituvm: more than a page");
801086fb:	c7 04 24 bf 92 10 80 	movl   $0x801092bf,(%esp)
80108702:	e8 2f 7e ff ff       	call   80100536 <panic>
  mem = kalloc();
80108707:	e8 0f a9 ff ff       	call   8010301b <kalloc>
8010870c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010870f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108716:	00 
80108717:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010871e:	00 
8010871f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108722:	89 04 24             	mov    %eax,(%esp)
80108725:	e8 48 d1 ff ff       	call   80105872 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010872a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010872d:	89 04 24             	mov    %eax,(%esp)
80108730:	e8 ca f7 ff ff       	call   80107eff <v2p>
80108735:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010873c:	00 
8010873d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108741:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108748:	00 
80108749:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108750:	00 
80108751:	8b 45 08             	mov    0x8(%ebp),%eax
80108754:	89 04 24             	mov    %eax,(%esp)
80108757:	e8 b0 fc ff ff       	call   8010840c <mappages>
  memmove(mem, init, sz);
8010875c:	8b 45 10             	mov    0x10(%ebp),%eax
8010875f:	89 44 24 08          	mov    %eax,0x8(%esp)
80108763:	8b 45 0c             	mov    0xc(%ebp),%eax
80108766:	89 44 24 04          	mov    %eax,0x4(%esp)
8010876a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010876d:	89 04 24             	mov    %eax,(%esp)
80108770:	e8 c9 d1 ff ff       	call   8010593e <memmove>
}
80108775:	c9                   	leave  
80108776:	c3                   	ret    

80108777 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108777:	55                   	push   %ebp
80108778:	89 e5                	mov    %esp,%ebp
8010877a:	53                   	push   %ebx
8010877b:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010877e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108781:	25 ff 0f 00 00       	and    $0xfff,%eax
80108786:	85 c0                	test   %eax,%eax
80108788:	74 0c                	je     80108796 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
8010878a:	c7 04 24 dc 92 10 80 	movl   $0x801092dc,(%esp)
80108791:	e8 a0 7d ff ff       	call   80100536 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108796:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010879d:	e9 ad 00 00 00       	jmp    8010884f <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801087a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087a5:	8b 55 0c             	mov    0xc(%ebp),%edx
801087a8:	01 d0                	add    %edx,%eax
801087aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801087b1:	00 
801087b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801087b6:	8b 45 08             	mov    0x8(%ebp),%eax
801087b9:	89 04 24             	mov    %eax,(%esp)
801087bc:	e8 a9 fb ff ff       	call   8010836a <walkpgdir>
801087c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
801087c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087c8:	75 0c                	jne    801087d6 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
801087ca:	c7 04 24 ff 92 10 80 	movl   $0x801092ff,(%esp)
801087d1:	e8 60 7d ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
801087d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087d9:	8b 00                	mov    (%eax),%eax
801087db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801087e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087e6:	8b 55 18             	mov    0x18(%ebp),%edx
801087e9:	89 d1                	mov    %edx,%ecx
801087eb:	29 c1                	sub    %eax,%ecx
801087ed:	89 c8                	mov    %ecx,%eax
801087ef:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801087f4:	77 11                	ja     80108807 <loaduvm+0x90>
      n = sz - i;
801087f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087f9:	8b 55 18             	mov    0x18(%ebp),%edx
801087fc:	89 d1                	mov    %edx,%ecx
801087fe:	29 c1                	sub    %eax,%ecx
80108800:	89 c8                	mov    %ecx,%eax
80108802:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108805:	eb 07                	jmp    8010880e <loaduvm+0x97>
    else
      n = PGSIZE;
80108807:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
8010880e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108811:	8b 55 14             	mov    0x14(%ebp),%edx
80108814:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108817:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010881a:	89 04 24             	mov    %eax,(%esp)
8010881d:	e8 ea f6 ff ff       	call   80107f0c <p2v>
80108822:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108825:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108829:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010882d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108831:	8b 45 10             	mov    0x10(%ebp),%eax
80108834:	89 04 24             	mov    %eax,(%esp)
80108837:	e8 69 9a ff ff       	call   801022a5 <readi>
8010883c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010883f:	74 07                	je     80108848 <loaduvm+0xd1>
      return -1;
80108841:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108846:	eb 18                	jmp    80108860 <loaduvm+0xe9>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108848:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010884f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108852:	3b 45 18             	cmp    0x18(%ebp),%eax
80108855:	0f 82 47 ff ff ff    	jb     801087a2 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010885b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108860:	83 c4 24             	add    $0x24,%esp
80108863:	5b                   	pop    %ebx
80108864:	5d                   	pop    %ebp
80108865:	c3                   	ret    

80108866 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108866:	55                   	push   %ebp
80108867:	89 e5                	mov    %esp,%ebp
80108869:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010886c:	8b 45 10             	mov    0x10(%ebp),%eax
8010886f:	85 c0                	test   %eax,%eax
80108871:	79 0a                	jns    8010887d <allocuvm+0x17>
    return 0;
80108873:	b8 00 00 00 00       	mov    $0x0,%eax
80108878:	e9 c1 00 00 00       	jmp    8010893e <allocuvm+0xd8>
  if(newsz < oldsz)
8010887d:	8b 45 10             	mov    0x10(%ebp),%eax
80108880:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108883:	73 08                	jae    8010888d <allocuvm+0x27>
    return oldsz;
80108885:	8b 45 0c             	mov    0xc(%ebp),%eax
80108888:	e9 b1 00 00 00       	jmp    8010893e <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
8010888d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108890:	05 ff 0f 00 00       	add    $0xfff,%eax
80108895:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010889a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010889d:	e9 8d 00 00 00       	jmp    8010892f <allocuvm+0xc9>
    mem = kalloc();
801088a2:	e8 74 a7 ff ff       	call   8010301b <kalloc>
801088a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801088aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801088ae:	75 2c                	jne    801088dc <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
801088b0:	c7 04 24 1d 93 10 80 	movl   $0x8010931d,(%esp)
801088b7:	e8 e5 7a ff ff       	call   801003a1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801088bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801088bf:	89 44 24 08          	mov    %eax,0x8(%esp)
801088c3:	8b 45 10             	mov    0x10(%ebp),%eax
801088c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801088ca:	8b 45 08             	mov    0x8(%ebp),%eax
801088cd:	89 04 24             	mov    %eax,(%esp)
801088d0:	e8 6b 00 00 00       	call   80108940 <deallocuvm>
      return 0;
801088d5:	b8 00 00 00 00       	mov    $0x0,%eax
801088da:	eb 62                	jmp    8010893e <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
801088dc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801088e3:	00 
801088e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801088eb:	00 
801088ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088ef:	89 04 24             	mov    %eax,(%esp)
801088f2:	e8 7b cf ff ff       	call   80105872 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801088f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088fa:	89 04 24             	mov    %eax,(%esp)
801088fd:	e8 fd f5 ff ff       	call   80107eff <v2p>
80108902:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108905:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010890c:	00 
8010890d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108911:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108918:	00 
80108919:	89 54 24 04          	mov    %edx,0x4(%esp)
8010891d:	8b 45 08             	mov    0x8(%ebp),%eax
80108920:	89 04 24             	mov    %eax,(%esp)
80108923:	e8 e4 fa ff ff       	call   8010840c <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108928:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010892f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108932:	3b 45 10             	cmp    0x10(%ebp),%eax
80108935:	0f 82 67 ff ff ff    	jb     801088a2 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
8010893b:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010893e:	c9                   	leave  
8010893f:	c3                   	ret    

80108940 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108940:	55                   	push   %ebp
80108941:	89 e5                	mov    %esp,%ebp
80108943:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108946:	8b 45 10             	mov    0x10(%ebp),%eax
80108949:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010894c:	72 08                	jb     80108956 <deallocuvm+0x16>
    return oldsz;
8010894e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108951:	e9 a4 00 00 00       	jmp    801089fa <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80108956:	8b 45 10             	mov    0x10(%ebp),%eax
80108959:	05 ff 0f 00 00       	add    $0xfff,%eax
8010895e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108963:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108966:	e9 80 00 00 00       	jmp    801089eb <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010896b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010896e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108975:	00 
80108976:	89 44 24 04          	mov    %eax,0x4(%esp)
8010897a:	8b 45 08             	mov    0x8(%ebp),%eax
8010897d:	89 04 24             	mov    %eax,(%esp)
80108980:	e8 e5 f9 ff ff       	call   8010836a <walkpgdir>
80108985:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108988:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010898c:	75 09                	jne    80108997 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
8010898e:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108995:	eb 4d                	jmp    801089e4 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80108997:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010899a:	8b 00                	mov    (%eax),%eax
8010899c:	83 e0 01             	and    $0x1,%eax
8010899f:	85 c0                	test   %eax,%eax
801089a1:	74 41                	je     801089e4 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
801089a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089a6:	8b 00                	mov    (%eax),%eax
801089a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801089b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801089b4:	75 0c                	jne    801089c2 <deallocuvm+0x82>
        panic("kfree");
801089b6:	c7 04 24 35 93 10 80 	movl   $0x80109335,(%esp)
801089bd:	e8 74 7b ff ff       	call   80100536 <panic>
      char *v = p2v(pa);
801089c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089c5:	89 04 24             	mov    %eax,(%esp)
801089c8:	e8 3f f5 ff ff       	call   80107f0c <p2v>
801089cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801089d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801089d3:	89 04 24             	mov    %eax,(%esp)
801089d6:	e8 a7 a5 ff ff       	call   80102f82 <kfree>
      *pte = 0;
801089db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801089e4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089f1:	0f 82 74 ff ff ff    	jb     8010896b <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801089f7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801089fa:	c9                   	leave  
801089fb:	c3                   	ret    

801089fc <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801089fc:	55                   	push   %ebp
801089fd:	89 e5                	mov    %esp,%ebp
801089ff:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108a02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108a06:	75 0c                	jne    80108a14 <freevm+0x18>
    panic("freevm: no pgdir");
80108a08:	c7 04 24 3b 93 10 80 	movl   $0x8010933b,(%esp)
80108a0f:	e8 22 7b ff ff       	call   80100536 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108a14:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108a1b:	00 
80108a1c:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108a23:	80 
80108a24:	8b 45 08             	mov    0x8(%ebp),%eax
80108a27:	89 04 24             	mov    %eax,(%esp)
80108a2a:	e8 11 ff ff ff       	call   80108940 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108a2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a36:	eb 47                	jmp    80108a7f <freevm+0x83>
    if(pgdir[i] & PTE_P){
80108a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a3b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108a42:	8b 45 08             	mov    0x8(%ebp),%eax
80108a45:	01 d0                	add    %edx,%eax
80108a47:	8b 00                	mov    (%eax),%eax
80108a49:	83 e0 01             	and    $0x1,%eax
80108a4c:	85 c0                	test   %eax,%eax
80108a4e:	74 2c                	je     80108a7c <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a53:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80108a5d:	01 d0                	add    %edx,%eax
80108a5f:	8b 00                	mov    (%eax),%eax
80108a61:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a66:	89 04 24             	mov    %eax,(%esp)
80108a69:	e8 9e f4 ff ff       	call   80107f0c <p2v>
80108a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a74:	89 04 24             	mov    %eax,(%esp)
80108a77:	e8 06 a5 ff ff       	call   80102f82 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108a7c:	ff 45 f4             	incl   -0xc(%ebp)
80108a7f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108a86:	76 b0                	jbe    80108a38 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108a88:	8b 45 08             	mov    0x8(%ebp),%eax
80108a8b:	89 04 24             	mov    %eax,(%esp)
80108a8e:	e8 ef a4 ff ff       	call   80102f82 <kfree>
}
80108a93:	c9                   	leave  
80108a94:	c3                   	ret    

80108a95 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108a95:	55                   	push   %ebp
80108a96:	89 e5                	mov    %esp,%ebp
80108a98:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108a9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108aa2:	00 
80108aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
80108aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
80108aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80108aad:	89 04 24             	mov    %eax,(%esp)
80108ab0:	e8 b5 f8 ff ff       	call   8010836a <walkpgdir>
80108ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108ab8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108abc:	75 0c                	jne    80108aca <clearpteu+0x35>
    panic("clearpteu");
80108abe:	c7 04 24 4c 93 10 80 	movl   $0x8010934c,(%esp)
80108ac5:	e8 6c 7a ff ff       	call   80100536 <panic>
  *pte &= ~PTE_U;
80108aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108acd:	8b 00                	mov    (%eax),%eax
80108acf:	89 c2                	mov    %eax,%edx
80108ad1:	83 e2 fb             	and    $0xfffffffb,%edx
80108ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad7:	89 10                	mov    %edx,(%eax)
}
80108ad9:	c9                   	leave  
80108ada:	c3                   	ret    

80108adb <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108adb:	55                   	push   %ebp
80108adc:	89 e5                	mov    %esp,%ebp
80108ade:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
80108ae1:	e8 ba f9 ff ff       	call   801084a0 <setupkvm>
80108ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108ae9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108aed:	75 0a                	jne    80108af9 <copyuvm+0x1e>
    return 0;
80108aef:	b8 00 00 00 00       	mov    $0x0,%eax
80108af4:	e9 f1 00 00 00       	jmp    80108bea <copyuvm+0x10f>
  for(i = 0; i < sz; i += PGSIZE){
80108af9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b00:	e9 c0 00 00 00       	jmp    80108bc5 <copyuvm+0xea>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b08:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108b0f:	00 
80108b10:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b14:	8b 45 08             	mov    0x8(%ebp),%eax
80108b17:	89 04 24             	mov    %eax,(%esp)
80108b1a:	e8 4b f8 ff ff       	call   8010836a <walkpgdir>
80108b1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108b22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108b26:	75 0c                	jne    80108b34 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80108b28:	c7 04 24 56 93 10 80 	movl   $0x80109356,(%esp)
80108b2f:	e8 02 7a ff ff       	call   80100536 <panic>
    if(!(*pte & PTE_P))
80108b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b37:	8b 00                	mov    (%eax),%eax
80108b39:	83 e0 01             	and    $0x1,%eax
80108b3c:	85 c0                	test   %eax,%eax
80108b3e:	75 0c                	jne    80108b4c <copyuvm+0x71>
      panic("copyuvm: page not present");
80108b40:	c7 04 24 70 93 10 80 	movl   $0x80109370,(%esp)
80108b47:	e8 ea 79 ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
80108b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b4f:	8b 00                	mov    (%eax),%eax
80108b51:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b56:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if((mem = kalloc()) == 0)
80108b59:	e8 bd a4 ff ff       	call   8010301b <kalloc>
80108b5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108b61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108b65:	74 6f                	je     80108bd6 <copyuvm+0xfb>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108b67:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b6a:	89 04 24             	mov    %eax,(%esp)
80108b6d:	e8 9a f3 ff ff       	call   80107f0c <p2v>
80108b72:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108b79:	00 
80108b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108b81:	89 04 24             	mov    %eax,(%esp)
80108b84:	e8 b5 cd ff ff       	call   8010593e <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
80108b89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108b8c:	89 04 24             	mov    %eax,(%esp)
80108b8f:	e8 6b f3 ff ff       	call   80107eff <v2p>
80108b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108b97:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108b9e:	00 
80108b9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108ba3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108baa:	00 
80108bab:	89 54 24 04          	mov    %edx,0x4(%esp)
80108baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bb2:	89 04 24             	mov    %eax,(%esp)
80108bb5:	e8 52 f8 ff ff       	call   8010840c <mappages>
80108bba:	85 c0                	test   %eax,%eax
80108bbc:	78 1b                	js     80108bd9 <copyuvm+0xfe>
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108bbe:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bc8:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108bcb:	0f 82 34 ff ff ff    	jb     80108b05 <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
  }
  return d;
80108bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bd4:	eb 14                	jmp    80108bea <copyuvm+0x10f>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108bd6:	90                   	nop
80108bd7:	eb 01                	jmp    80108bda <copyuvm+0xff>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
80108bd9:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bdd:	89 04 24             	mov    %eax,(%esp)
80108be0:	e8 17 fe ff ff       	call   801089fc <freevm>
  return 0;
80108be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108bea:	c9                   	leave  
80108beb:	c3                   	ret    

80108bec <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108bec:	55                   	push   %ebp
80108bed:	89 e5                	mov    %esp,%ebp
80108bef:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108bf2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108bf9:	00 
80108bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c01:	8b 45 08             	mov    0x8(%ebp),%eax
80108c04:	89 04 24             	mov    %eax,(%esp)
80108c07:	e8 5e f7 ff ff       	call   8010836a <walkpgdir>
80108c0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c12:	8b 00                	mov    (%eax),%eax
80108c14:	83 e0 01             	and    $0x1,%eax
80108c17:	85 c0                	test   %eax,%eax
80108c19:	75 07                	jne    80108c22 <uva2ka+0x36>
    return 0;
80108c1b:	b8 00 00 00 00       	mov    $0x0,%eax
80108c20:	eb 25                	jmp    80108c47 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c25:	8b 00                	mov    (%eax),%eax
80108c27:	83 e0 04             	and    $0x4,%eax
80108c2a:	85 c0                	test   %eax,%eax
80108c2c:	75 07                	jne    80108c35 <uva2ka+0x49>
    return 0;
80108c2e:	b8 00 00 00 00       	mov    $0x0,%eax
80108c33:	eb 12                	jmp    80108c47 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c38:	8b 00                	mov    (%eax),%eax
80108c3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c3f:	89 04 24             	mov    %eax,(%esp)
80108c42:	e8 c5 f2 ff ff       	call   80107f0c <p2v>
}
80108c47:	c9                   	leave  
80108c48:	c3                   	ret    

80108c49 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108c49:	55                   	push   %ebp
80108c4a:	89 e5                	mov    %esp,%ebp
80108c4c:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108c4f:	8b 45 10             	mov    0x10(%ebp),%eax
80108c52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108c55:	e9 89 00 00 00       	jmp    80108ce3 <copyout+0x9a>
    va0 = (uint)PGROUNDDOWN(va);
80108c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c62:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c68:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c6c:	8b 45 08             	mov    0x8(%ebp),%eax
80108c6f:	89 04 24             	mov    %eax,(%esp)
80108c72:	e8 75 ff ff ff       	call   80108bec <uva2ka>
80108c77:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108c7a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108c7e:	75 07                	jne    80108c87 <copyout+0x3e>
      return -1;
80108c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108c85:	eb 6b                	jmp    80108cf2 <copyout+0xa9>
    n = PGSIZE - (va - va0);
80108c87:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108c8d:	89 d1                	mov    %edx,%ecx
80108c8f:	29 c1                	sub    %eax,%ecx
80108c91:	89 c8                	mov    %ecx,%eax
80108c93:	05 00 10 00 00       	add    $0x1000,%eax
80108c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c9e:	3b 45 14             	cmp    0x14(%ebp),%eax
80108ca1:	76 06                	jbe    80108ca9 <copyout+0x60>
      n = len;
80108ca3:	8b 45 14             	mov    0x14(%ebp),%eax
80108ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108ca9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cac:	8b 55 0c             	mov    0xc(%ebp),%edx
80108caf:	29 c2                	sub    %eax,%edx
80108cb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108cb4:	01 c2                	add    %eax,%edx
80108cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cb9:	89 44 24 08          	mov    %eax,0x8(%esp)
80108cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
80108cc4:	89 14 24             	mov    %edx,(%esp)
80108cc7:	e8 72 cc ff ff       	call   8010593e <memmove>
    len -= n;
80108ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ccf:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cd5:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108cd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cdb:	05 00 10 00 00       	add    $0x1000,%eax
80108ce0:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108ce3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108ce7:	0f 85 6d ff ff ff    	jne    80108c5a <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108ced:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108cf2:	c9                   	leave  
80108cf3:	c3                   	ret    
