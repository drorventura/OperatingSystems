
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 77 34 10 80       	mov    $0x80103477,%eax
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
8010003a:	c7 44 24 04 3c 82 10 	movl   $0x8010823c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 e0 4b 00 00       	call   80104c2e <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 90 db 10 80 84 	movl   $0x8010db84,0x8010db90
80100055:	db 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 94 db 10 80 84 	movl   $0x8010db84,0x8010db94
8010005f:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 94 db 10 80       	mov    0x8010db94,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 94 db 10 80       	mov    %eax,0x8010db94

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
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
801000b6:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000bd:	e8 8d 4b 00 00       	call   80104c4f <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 94 db 10 80       	mov    0x8010db94,%eax
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
801000fd:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100104:	e8 a8 4b 00 00       	call   80104cb1 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 4f 48 00 00       	call   80104973 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 90 db 10 80       	mov    0x8010db90,%eax
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
80100175:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017c:	e8 30 4b 00 00       	call   80104cb1 <release>
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
8010018f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 43 82 10 80 	movl   $0x80108243,(%esp)
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
801001d3:	e8 65 26 00 00       	call   8010283d <iderw>
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
801001ef:	c7 04 24 54 82 10 80 	movl   $0x80108254,(%esp)
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
80100210:	e8 28 26 00 00       	call   8010283d <iderw>
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
80100229:	c7 04 24 5b 82 10 80 	movl   $0x8010825b,(%esp)
80100230:	e8 01 03 00 00       	call   80100536 <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023c:	e8 0e 4a 00 00       	call   80104c4f <acquire>

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
8010025f:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 94 db 10 80       	mov    0x8010db94,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 94 db 10 80       	mov    %eax,0x8010db94

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
8010029d:	e8 aa 47 00 00       	call   80104a4c <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002a9:	e8 03 4a 00 00       	call   80104cb1 <release>
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
8010033e:	8a 80 04 90 10 80    	mov    -0x7fef6ffc(%eax),%al
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
80100391:	e8 9d 03 00 00       	call   80100733 <consputc>
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
801003a7:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b3:	74 0c                	je     801003c1 <cprintf+0x20>
    acquire(&cons.lock);
801003b5:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003bc:	e8 8e 48 00 00       	call   80104c4f <acquire>

  if (fmt == 0)
801003c1:	8b 45 08             	mov    0x8(%ebp),%eax
801003c4:	85 c0                	test   %eax,%eax
801003c6:	75 0c                	jne    801003d4 <cprintf+0x33>
    panic("null fmt");
801003c8:	c7 04 24 62 82 10 80 	movl   $0x80108262,(%esp)
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
801003f2:	e8 3c 03 00 00       	call   80100733 <consputc>
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
801004ad:	c7 45 ec 6b 82 10 80 	movl   $0x8010826b,-0x14(%ebp)
      for(; *s; s++)
801004b4:	eb 15                	jmp    801004cb <cprintf+0x12a>
        consputc(*s);
801004b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004b9:	8a 00                	mov    (%eax),%al
801004bb:	0f be c0             	movsbl %al,%eax
801004be:	89 04 24             	mov    %eax,(%esp)
801004c1:	e8 6d 02 00 00       	call   80100733 <consputc>
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
801004de:	e8 50 02 00 00       	call   80100733 <consputc>
      break;
801004e3:	eb 18                	jmp    801004fd <cprintf+0x15c>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004e5:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ec:	e8 42 02 00 00       	call   80100733 <consputc>
      consputc(c);
801004f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f4:	89 04 24             	mov    %eax,(%esp)
801004f7:	e8 37 02 00 00       	call   80100733 <consputc>
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
80100528:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010052f:	e8 7d 47 00 00       	call   80104cb1 <release>
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
80100541:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
80100548:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100551:	8a 00                	mov    (%eax),%al
80100553:	0f b6 c0             	movzbl %al,%eax
80100556:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055a:	c7 04 24 72 82 10 80 	movl   $0x80108272,(%esp)
80100561:	e8 3b fe ff ff       	call   801003a1 <cprintf>
  cprintf(s);
80100566:	8b 45 08             	mov    0x8(%ebp),%eax
80100569:	89 04 24             	mov    %eax,(%esp)
8010056c:	e8 30 fe ff ff       	call   801003a1 <cprintf>
  cprintf("\n");
80100571:	c7 04 24 81 82 10 80 	movl   $0x80108281,(%esp)
80100578:	e8 24 fe ff ff       	call   801003a1 <cprintf>
  getcallerpcs(&s, pcs);
8010057d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100580:	89 44 24 04          	mov    %eax,0x4(%esp)
80100584:	8d 45 08             	lea    0x8(%ebp),%eax
80100587:	89 04 24             	mov    %eax,(%esp)
8010058a:	e8 71 47 00 00       	call   80104d00 <getcallerpcs>
  for(i=0; i<10; i++)
8010058f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100596:	eb 1a                	jmp    801005b2 <panic+0x7c>
    cprintf(" %p", pcs[i]);
80100598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010059b:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010059f:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a3:	c7 04 24 83 82 10 80 	movl   $0x80108283,(%esp)
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
801005b8:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005bf:	00 00 00 
  for(;;)
    ;
801005c2:	eb fe                	jmp    801005c2 <panic+0x8c>

801005c4 <cgaputc>:
#define CRTPORT 0x3d4
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
8010063a:	eb 31                	jmp    8010066d <cgaputc+0xa9>
  else if(c == BACKSPACE){
8010063c:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100643:	75 0b                	jne    80100650 <cgaputc+0x8c>
    if(pos > 0) --pos;
80100645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100649:	7e 22                	jle    8010066d <cgaputc+0xa9>
8010064b:	ff 4d f4             	decl   -0xc(%ebp)
8010064e:	eb 1d                	jmp    8010066d <cgaputc+0xa9>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100650:	a1 00 90 10 80       	mov    0x80109000,%eax
80100655:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100658:	d1 e2                	shl    %edx
8010065a:	01 c2                	add    %eax,%edx
8010065c:	8b 45 08             	mov    0x8(%ebp),%eax
8010065f:	25 ff 00 00 00       	and    $0xff,%eax
80100664:	80 cc 07             	or     $0x7,%ah
80100667:	66 89 02             	mov    %ax,(%edx)
8010066a:	ff 45 f4             	incl   -0xc(%ebp)
  
  if((pos/80) >= 24){  // Scroll up.
8010066d:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100674:	7e 53                	jle    801006c9 <cgaputc+0x105>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100676:	a1 00 90 10 80       	mov    0x80109000,%eax
8010067b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100681:	a1 00 90 10 80       	mov    0x80109000,%eax
80100686:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
8010068d:	00 
8010068e:	89 54 24 04          	mov    %edx,0x4(%esp)
80100692:	89 04 24             	mov    %eax,(%esp)
80100695:	e8 d4 48 00 00       	call   80104f6e <memmove>
    pos -= 80;
8010069a:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010069e:	b8 80 07 00 00       	mov    $0x780,%eax
801006a3:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006a6:	d1 e0                	shl    %eax
801006a8:	8b 15 00 90 10 80    	mov    0x80109000,%edx
801006ae:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006b1:	d1 e1                	shl    %ecx
801006b3:	01 ca                	add    %ecx,%edx
801006b5:	89 44 24 08          	mov    %eax,0x8(%esp)
801006b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006c0:	00 
801006c1:	89 14 24             	mov    %edx,(%esp)
801006c4:	e8 d9 47 00 00       	call   80104ea2 <memset>
  }
  
  outb(CRTPORT, 14);
801006c9:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006d0:	00 
801006d1:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006d8:	e8 fb fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT+1, pos>>8);
801006dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006e0:	c1 f8 08             	sar    $0x8,%eax
801006e3:	0f b6 c0             	movzbl %al,%eax
801006e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801006ea:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801006f1:	e8 e2 fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT, 15);
801006f6:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
801006fd:	00 
801006fe:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100705:	e8 ce fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT+1, pos);
8010070a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010070d:	0f b6 c0             	movzbl %al,%eax
80100710:	89 44 24 04          	mov    %eax,0x4(%esp)
80100714:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010071b:	e8 b8 fb ff ff       	call   801002d8 <outb>
  crt[pos] = ' ' | 0x0700;
80100720:	a1 00 90 10 80       	mov    0x80109000,%eax
80100725:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100728:	d1 e2                	shl    %edx
8010072a:	01 d0                	add    %edx,%eax
8010072c:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100731:	c9                   	leave  
80100732:	c3                   	ret    

80100733 <consputc>:

void
consputc(int c)
{
80100733:	55                   	push   %ebp
80100734:	89 e5                	mov    %esp,%ebp
80100736:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100739:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
8010073e:	85 c0                	test   %eax,%eax
80100740:	74 07                	je     80100749 <consputc+0x16>
    cli();
80100742:	e8 ad fb ff ff       	call   801002f4 <cli>
    for(;;)
      ;
80100747:	eb fe                	jmp    80100747 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100749:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100750:	75 26                	jne    80100778 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100752:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100759:	e8 64 61 00 00       	call   801068c2 <uartputc>
8010075e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100765:	e8 58 61 00 00       	call   801068c2 <uartputc>
8010076a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100771:	e8 4c 61 00 00       	call   801068c2 <uartputc>
80100776:	eb 0b                	jmp    80100783 <consputc+0x50>
  } else
    uartputc(c);
80100778:	8b 45 08             	mov    0x8(%ebp),%eax
8010077b:	89 04 24             	mov    %eax,(%esp)
8010077e:	e8 3f 61 00 00       	call   801068c2 <uartputc>
  cgaputc(c);
80100783:	8b 45 08             	mov    0x8(%ebp),%eax
80100786:	89 04 24             	mov    %eax,(%esp)
80100789:	e8 36 fe ff ff       	call   801005c4 <cgaputc>
}
8010078e:	c9                   	leave  
8010078f:	c3                   	ret    

80100790 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100790:	55                   	push   %ebp
80100791:	89 e5                	mov    %esp,%ebp
80100793:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
80100796:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
8010079d:	e8 ad 44 00 00       	call   80104c4f <acquire>
  while((c = getc()) >= 0){
801007a2:	e9 35 01 00 00       	jmp    801008dc <consoleintr+0x14c>
    switch(c){
801007a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007aa:	83 f8 10             	cmp    $0x10,%eax
801007ad:	74 1b                	je     801007ca <consoleintr+0x3a>
801007af:	83 f8 10             	cmp    $0x10,%eax
801007b2:	7f 0a                	jg     801007be <consoleintr+0x2e>
801007b4:	83 f8 08             	cmp    $0x8,%eax
801007b7:	74 60                	je     80100819 <consoleintr+0x89>
801007b9:	e9 8a 00 00 00       	jmp    80100848 <consoleintr+0xb8>
801007be:	83 f8 15             	cmp    $0x15,%eax
801007c1:	74 2a                	je     801007ed <consoleintr+0x5d>
801007c3:	83 f8 7f             	cmp    $0x7f,%eax
801007c6:	74 51                	je     80100819 <consoleintr+0x89>
801007c8:	eb 7e                	jmp    80100848 <consoleintr+0xb8>
    case C('P'):  // Process listing.
      procdump();
801007ca:	e8 20 43 00 00       	call   80104aef <procdump>
      break;
801007cf:	e9 08 01 00 00       	jmp    801008dc <consoleintr+0x14c>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007d4:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801007d9:	48                   	dec    %eax
801007da:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
801007df:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801007e6:	e8 48 ff ff ff       	call   80100733 <consputc>
801007eb:	eb 01                	jmp    801007ee <consoleintr+0x5e>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801007ed:	90                   	nop
801007ee:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
801007f4:	a1 58 de 10 80       	mov    0x8010de58,%eax
801007f9:	39 c2                	cmp    %eax,%edx
801007fb:	0f 84 d4 00 00 00    	je     801008d5 <consoleintr+0x145>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100801:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100806:	48                   	dec    %eax
80100807:	83 e0 7f             	and    $0x7f,%eax
8010080a:	8a 80 d4 dd 10 80    	mov    -0x7fef222c(%eax),%al
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100810:	3c 0a                	cmp    $0xa,%al
80100812:	75 c0                	jne    801007d4 <consoleintr+0x44>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100814:	e9 bc 00 00 00       	jmp    801008d5 <consoleintr+0x145>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100819:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010081f:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100824:	39 c2                	cmp    %eax,%edx
80100826:	0f 84 ac 00 00 00    	je     801008d8 <consoleintr+0x148>
        input.e--;
8010082c:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100831:	48                   	dec    %eax
80100832:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
80100837:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010083e:	e8 f0 fe ff ff       	call   80100733 <consputc>
      }
      break;
80100843:	e9 90 00 00 00       	jmp    801008d8 <consoleintr+0x148>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100848:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010084c:	0f 84 89 00 00 00    	je     801008db <consoleintr+0x14b>
80100852:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100858:	a1 54 de 10 80       	mov    0x8010de54,%eax
8010085d:	89 d1                	mov    %edx,%ecx
8010085f:	29 c1                	sub    %eax,%ecx
80100861:	89 c8                	mov    %ecx,%eax
80100863:	83 f8 7f             	cmp    $0x7f,%eax
80100866:	77 73                	ja     801008db <consoleintr+0x14b>
        c = (c == '\r') ? '\n' : c;
80100868:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010086c:	74 05                	je     80100873 <consoleintr+0xe3>
8010086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100871:	eb 05                	jmp    80100878 <consoleintr+0xe8>
80100873:	b8 0a 00 00 00       	mov    $0xa,%eax
80100878:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010087b:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100880:	89 c1                	mov    %eax,%ecx
80100882:	83 e1 7f             	and    $0x7f,%ecx
80100885:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100888:	88 91 d4 dd 10 80    	mov    %dl,-0x7fef222c(%ecx)
8010088e:	40                   	inc    %eax
8010088f:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(c);
80100894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100897:	89 04 24             	mov    %eax,(%esp)
8010089a:	e8 94 fe ff ff       	call   80100733 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010089f:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008a3:	74 18                	je     801008bd <consoleintr+0x12d>
801008a5:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008a9:	74 12                	je     801008bd <consoleintr+0x12d>
801008ab:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008b0:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801008b6:	83 ea 80             	sub    $0xffffff80,%edx
801008b9:	39 d0                	cmp    %edx,%eax
801008bb:	75 1e                	jne    801008db <consoleintr+0x14b>
          input.w = input.e;
801008bd:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008c2:	a3 58 de 10 80       	mov    %eax,0x8010de58
          wakeup(&input.r);
801008c7:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
801008ce:	e8 79 41 00 00       	call   80104a4c <wakeup>
        }
      }
      break;
801008d3:	eb 06                	jmp    801008db <consoleintr+0x14b>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008d5:	90                   	nop
801008d6:	eb 04                	jmp    801008dc <consoleintr+0x14c>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008d8:	90                   	nop
801008d9:	eb 01                	jmp    801008dc <consoleintr+0x14c>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
801008db:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801008dc:	8b 45 08             	mov    0x8(%ebp),%eax
801008df:	ff d0                	call   *%eax
801008e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801008e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801008e8:	0f 89 b9 fe ff ff    	jns    801007a7 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
801008ee:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801008f5:	e8 b7 43 00 00       	call   80104cb1 <release>
}
801008fa:	c9                   	leave  
801008fb:	c3                   	ret    

801008fc <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801008fc:	55                   	push   %ebp
801008fd:	89 e5                	mov    %esp,%ebp
801008ff:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100902:	8b 45 08             	mov    0x8(%ebp),%eax
80100905:	89 04 24             	mov    %eax,(%esp)
80100908:	e8 40 11 00 00       	call   80101a4d <iunlock>
  target = n;
8010090d:	8b 45 10             	mov    0x10(%ebp),%eax
80100910:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100913:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
8010091a:	e8 30 43 00 00       	call   80104c4f <acquire>
  while(n > 0){
8010091f:	e9 a1 00 00 00       	jmp    801009c5 <consoleread+0xc9>
    while(input.r == input.w){
      if(proc->killed){
80100924:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010092a:	8b 40 24             	mov    0x24(%eax),%eax
8010092d:	85 c0                	test   %eax,%eax
8010092f:	74 21                	je     80100952 <consoleread+0x56>
        release(&input.lock);
80100931:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100938:	e8 74 43 00 00       	call   80104cb1 <release>
        ilock(ip);
8010093d:	8b 45 08             	mov    0x8(%ebp),%eax
80100940:	89 04 24             	mov    %eax,(%esp)
80100943:	e8 ba 0f 00 00       	call   80101902 <ilock>
        return -1;
80100948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010094d:	e9 a2 00 00 00       	jmp    801009f4 <consoleread+0xf8>
      }
      sleep(&input.r, &input.lock);
80100952:	c7 44 24 04 a0 dd 10 	movl   $0x8010dda0,0x4(%esp)
80100959:	80 
8010095a:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
80100961:	e8 0d 40 00 00       	call   80104973 <sleep>
80100966:	eb 01                	jmp    80100969 <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100968:	90                   	nop
80100969:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
8010096f:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100974:	39 c2                	cmp    %eax,%edx
80100976:	74 ac                	je     80100924 <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100978:	a1 54 de 10 80       	mov    0x8010de54,%eax
8010097d:	89 c2                	mov    %eax,%edx
8010097f:	83 e2 7f             	and    $0x7f,%edx
80100982:	8a 92 d4 dd 10 80    	mov    -0x7fef222c(%edx),%dl
80100988:	0f be d2             	movsbl %dl,%edx
8010098b:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010098e:	40                   	inc    %eax
8010098f:	a3 54 de 10 80       	mov    %eax,0x8010de54
    if(c == C('D')){  // EOF
80100994:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100998:	75 15                	jne    801009af <consoleread+0xb3>
      if(n < target){
8010099a:	8b 45 10             	mov    0x10(%ebp),%eax
8010099d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009a0:	73 2b                	jae    801009cd <consoleread+0xd1>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009a2:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009a7:	48                   	dec    %eax
801009a8:	a3 54 de 10 80       	mov    %eax,0x8010de54
      }
      break;
801009ad:	eb 1e                	jmp    801009cd <consoleread+0xd1>
    }
    *dst++ = c;
801009af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009b2:	88 c2                	mov    %al,%dl
801009b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801009b7:	88 10                	mov    %dl,(%eax)
801009b9:	ff 45 0c             	incl   0xc(%ebp)
    --n;
801009bc:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
801009bf:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009c3:	74 0b                	je     801009d0 <consoleread+0xd4>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009c9:	7f 9d                	jg     80100968 <consoleread+0x6c>
801009cb:	eb 04                	jmp    801009d1 <consoleread+0xd5>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
801009cd:	90                   	nop
801009ce:	eb 01                	jmp    801009d1 <consoleread+0xd5>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
801009d0:	90                   	nop
  }
  release(&input.lock);
801009d1:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801009d8:	e8 d4 42 00 00       	call   80104cb1 <release>
  ilock(ip);
801009dd:	8b 45 08             	mov    0x8(%ebp),%eax
801009e0:	89 04 24             	mov    %eax,(%esp)
801009e3:	e8 1a 0f 00 00       	call   80101902 <ilock>

  return target - n;
801009e8:	8b 45 10             	mov    0x10(%ebp),%eax
801009eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801009ee:	89 d1                	mov    %edx,%ecx
801009f0:	29 c1                	sub    %eax,%ecx
801009f2:	89 c8                	mov    %ecx,%eax
}
801009f4:	c9                   	leave  
801009f5:	c3                   	ret    

801009f6 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801009f6:	55                   	push   %ebp
801009f7:	89 e5                	mov    %esp,%ebp
801009f9:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
801009fc:	8b 45 08             	mov    0x8(%ebp),%eax
801009ff:	89 04 24             	mov    %eax,(%esp)
80100a02:	e8 46 10 00 00       	call   80101a4d <iunlock>
  acquire(&cons.lock);
80100a07:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a0e:	e8 3c 42 00 00       	call   80104c4f <acquire>
  for(i = 0; i < n; i++)
80100a13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a1a:	eb 1d                	jmp    80100a39 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a22:	01 d0                	add    %edx,%eax
80100a24:	8a 00                	mov    (%eax),%al
80100a26:	0f be c0             	movsbl %al,%eax
80100a29:	25 ff 00 00 00       	and    $0xff,%eax
80100a2e:	89 04 24             	mov    %eax,(%esp)
80100a31:	e8 fd fc ff ff       	call   80100733 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a36:	ff 45 f4             	incl   -0xc(%ebp)
80100a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a3c:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a3f:	7c db                	jl     80100a1c <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a41:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a48:	e8 64 42 00 00       	call   80104cb1 <release>
  ilock(ip);
80100a4d:	8b 45 08             	mov    0x8(%ebp),%eax
80100a50:	89 04 24             	mov    %eax,(%esp)
80100a53:	e8 aa 0e 00 00       	call   80101902 <ilock>

  return n;
80100a58:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a5b:	c9                   	leave  
80100a5c:	c3                   	ret    

80100a5d <consoleinit>:

void
consoleinit(void)
{
80100a5d:	55                   	push   %ebp
80100a5e:	89 e5                	mov    %esp,%ebp
80100a60:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a63:	c7 44 24 04 87 82 10 	movl   $0x80108287,0x4(%esp)
80100a6a:	80 
80100a6b:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a72:	e8 b7 41 00 00       	call   80104c2e <initlock>
  initlock(&input.lock, "input");
80100a77:	c7 44 24 04 8f 82 10 	movl   $0x8010828f,0x4(%esp)
80100a7e:	80 
80100a7f:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100a86:	e8 a3 41 00 00       	call   80104c2e <initlock>

  devsw[CONSOLE].write = consolewrite;
80100a8b:	c7 05 2c ed 10 80 f6 	movl   $0x801009f6,0x8010ed2c
80100a92:	09 10 80 
  devsw[CONSOLE].read = consoleread;
80100a95:	c7 05 28 ed 10 80 fc 	movl   $0x801008fc,0x8010ed28
80100a9c:	08 10 80 
  cons.locking = 1;
80100a9f:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100aa6:	00 00 00 

  picenable(IRQ_KBD);
80100aa9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ab0:	e8 bf 30 00 00       	call   80103b74 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ab5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100abc:	00 
80100abd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ac4:	e8 30 1f 00 00       	call   801029f9 <ioapicenable>
}
80100ac9:	c9                   	leave  
80100aca:	c3                   	ret    
80100acb:	90                   	nop

80100acc <exec>:
char pathsEnv[MAX_PATH_ENTRIES][INPUT_BUF];
int nextPathPosition;

int 
exec(char *path, char **argv)
{
80100acc:	55                   	push   %ebp
80100acd:	89 e5                	mov    %esp,%ebp
80100acf:	81 ec 38 01 00 00    	sub    $0x138,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  char *newPath = "";
80100ad5:	c7 45 d0 95 82 10 80 	movl   $0x80108295,-0x30(%ebp)


  if((ip = namei(path)) == 0){
80100adc:	8b 45 08             	mov    0x8(%ebp),%eax
80100adf:	89 04 24             	mov    %eax,(%esp)
80100ae2:	e8 b5 19 00 00       	call   8010249c <namei>
80100ae7:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100aea:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100aee:	0f 85 81 00 00 00    	jne    80100b75 <exec+0xa9>
      // iterate all pathsEnv array to append and check if program exists
      for( i=0 ; i < nextPathPosition ; i++)
80100af4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100afb:	eb 5b                	jmp    80100b58 <exec+0x8c>
      {
          strncpy(newPath, pathsEnv[i], strlen(pathsEnv[i]));
80100afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100b00:	c1 e0 07             	shl    $0x7,%eax
80100b03:	05 60 de 10 80       	add    $0x8010de60,%eax
80100b08:	89 04 24             	mov    %eax,(%esp)
80100b0b:	e8 ed 45 00 00       	call   801050fd <strlen>
80100b10:	8b 55 ec             	mov    -0x14(%ebp),%edx
80100b13:	c1 e2 07             	shl    $0x7,%edx
80100b16:	81 c2 60 de 10 80    	add    $0x8010de60,%edx
80100b1c:	89 44 24 08          	mov    %eax,0x8(%esp)
80100b20:	89 54 24 04          	mov    %edx,0x4(%esp)
80100b24:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100b27:	89 04 24             	mov    %eax,(%esp)
80100b2a:	e8 2b 45 00 00       	call   8010505a <strncpy>
          strcat(newPath,path);
80100b2f:	8b 45 08             	mov    0x8(%ebp),%eax
80100b32:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b36:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100b39:	89 04 24             	mov    %eax,(%esp)
80100b3c:	e8 e1 45 00 00       	call   80105122 <strcat>
          if(( ip = namei(newPath)) != 0)
80100b41:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100b44:	89 04 24             	mov    %eax,(%esp)
80100b47:	e8 50 19 00 00       	call   8010249c <namei>
80100b4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b4f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b53:	75 0f                	jne    80100b64 <exec+0x98>
  char *newPath = "";


  if((ip = namei(path)) == 0){
      // iterate all pathsEnv array to append and check if program exists
      for( i=0 ; i < nextPathPosition ; i++)
80100b55:	ff 45 ec             	incl   -0x14(%ebp)
80100b58:	a1 60 e3 10 80       	mov    0x8010e360,%eax
80100b5d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100b60:	7c 9b                	jl     80100afd <exec+0x31>
80100b62:	eb 01                	jmp    80100b65 <exec+0x99>
      {
          strncpy(newPath, pathsEnv[i], strlen(pathsEnv[i]));
          strcat(newPath,path);
          if(( ip = namei(newPath)) != 0)
              break;
80100b64:	90                   	nop
      }
      if(!ip) return -1;
80100b65:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b69:	75 0a                	jne    80100b75 <exec+0xa9>
80100b6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b70:	e9 ea 03 00 00       	jmp    80100f5f <exec+0x493>
  }
  ilock(ip);
80100b75:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b78:	89 04 24             	mov    %eax,(%esp)
80100b7b:	e8 82 0d 00 00       	call   80101902 <ilock>
  pgdir = 0;
80100b80:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b87:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b8e:	00 
80100b8f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b96:	00 
80100b97:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ba1:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ba4:	89 04 24             	mov    %eax,(%esp)
80100ba7:	e8 5d 12 00 00       	call   80101e09 <readi>
80100bac:	83 f8 33             	cmp    $0x33,%eax
80100baf:	0f 86 64 03 00 00    	jbe    80100f19 <exec+0x44d>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100bb5:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100bbb:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bc0:	0f 85 56 03 00 00    	jne    80100f1c <exec+0x450>
    goto bad;

  if((pgdir = setupkvm(kalloc)) == 0)
80100bc6:	c7 04 24 7f 2b 10 80 	movl   $0x80102b7f,(%esp)
80100bcd:	e8 16 6e 00 00       	call   801079e8 <setupkvm>
80100bd2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bd5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bd9:	0f 84 40 03 00 00    	je     80100f1f <exec+0x453>
    goto bad;

  // Load program into memory.
  sz = 0;
80100bdf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bed:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100bf3:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100bf6:	e9 c4 00 00 00       	jmp    80100cbf <exec+0x1f3>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bfe:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100c05:	00 
80100c06:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c0a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c10:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c14:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c17:	89 04 24             	mov    %eax,(%esp)
80100c1a:	e8 ea 11 00 00       	call   80101e09 <readi>
80100c1f:	83 f8 20             	cmp    $0x20,%eax
80100c22:	0f 85 fa 02 00 00    	jne    80100f22 <exec+0x456>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c28:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100c2e:	83 f8 01             	cmp    $0x1,%eax
80100c31:	75 7f                	jne    80100cb2 <exec+0x1e6>
      continue;
    if(ph.memsz < ph.filesz)
80100c33:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c39:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c3f:	39 c2                	cmp    %eax,%edx
80100c41:	0f 82 de 02 00 00    	jb     80100f25 <exec+0x459>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c47:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c4d:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c53:	01 d0                	add    %edx,%eax
80100c55:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c59:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c63:	89 04 24             	mov    %eax,(%esp)
80100c66:	e8 43 71 00 00       	call   80107dae <allocuvm>
80100c6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c6e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c72:	0f 84 b0 02 00 00    	je     80100f28 <exec+0x45c>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c78:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80100c7e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100c84:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c8a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c8e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c92:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c95:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c99:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ca0:	89 04 24             	mov    %eax,(%esp)
80100ca3:	e8 17 70 00 00       	call   80107cbf <loaduvm>
80100ca8:	85 c0                	test   %eax,%eax
80100caa:	0f 88 7b 02 00 00    	js     80100f2b <exec+0x45f>
80100cb0:	eb 01                	jmp    80100cb3 <exec+0x1e7>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100cb2:	90                   	nop
  if((pgdir = setupkvm(kalloc)) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cb3:	ff 45 ec             	incl   -0x14(%ebp)
80100cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cb9:	83 c0 20             	add    $0x20,%eax
80100cbc:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cbf:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
80100cc5:	0f b7 c0             	movzwl %ax,%eax
80100cc8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100ccb:	0f 8f 2a ff ff ff    	jg     80100bfb <exec+0x12f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cd1:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cd4:	89 04 24             	mov    %eax,(%esp)
80100cd7:	e8 a7 0e 00 00       	call   80101b83 <iunlockput>
  ip = 0;
80100cdc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100ce3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce6:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ceb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cf0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cf6:	05 00 20 00 00       	add    $0x2000,%eax
80100cfb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d02:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d09:	89 04 24             	mov    %eax,(%esp)
80100d0c:	e8 9d 70 00 00       	call   80107dae <allocuvm>
80100d11:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d14:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d18:	0f 84 10 02 00 00    	je     80100f2e <exec+0x462>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d21:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d26:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d2d:	89 04 24             	mov    %eax,(%esp)
80100d30:	e8 a8 72 00 00       	call   80107fdd <clearpteu>
  sp = sz;
80100d35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d38:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d3b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d42:	e9 94 00 00 00       	jmp    80100ddb <exec+0x30f>
    if(argc >= MAXARG)
80100d47:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d4b:	0f 87 e0 01 00 00    	ja     80100f31 <exec+0x465>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d5e:	01 d0                	add    %edx,%eax
80100d60:	8b 00                	mov    (%eax),%eax
80100d62:	89 04 24             	mov    %eax,(%esp)
80100d65:	e8 93 43 00 00       	call   801050fd <strlen>
80100d6a:	f7 d0                	not    %eax
80100d6c:	89 c2                	mov    %eax,%edx
80100d6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d71:	01 d0                	add    %edx,%eax
80100d73:	83 e0 fc             	and    $0xfffffffc,%eax
80100d76:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d7c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d83:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d86:	01 d0                	add    %edx,%eax
80100d88:	8b 00                	mov    (%eax),%eax
80100d8a:	89 04 24             	mov    %eax,(%esp)
80100d8d:	e8 6b 43 00 00       	call   801050fd <strlen>
80100d92:	40                   	inc    %eax
80100d93:	89 c2                	mov    %eax,%edx
80100d95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d98:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da2:	01 c8                	add    %ecx,%eax
80100da4:	8b 00                	mov    (%eax),%eax
80100da6:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100daa:	89 44 24 08          	mov    %eax,0x8(%esp)
80100dae:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100db1:	89 44 24 04          	mov    %eax,0x4(%esp)
80100db5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100db8:	89 04 24             	mov    %eax,(%esp)
80100dbb:	e8 d1 73 00 00       	call   80108191 <copyout>
80100dc0:	85 c0                	test   %eax,%eax
80100dc2:	0f 88 6c 01 00 00    	js     80100f34 <exec+0x468>
      goto bad;
    ustack[3+argc] = sp;
80100dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dcb:	8d 50 03             	lea    0x3(%eax),%edx
80100dce:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dd1:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dd8:	ff 45 e4             	incl   -0x1c(%ebp)
80100ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dde:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100de8:	01 d0                	add    %edx,%eax
80100dea:	8b 00                	mov    (%eax),%eax
80100dec:	85 c0                	test   %eax,%eax
80100dee:	0f 85 53 ff ff ff    	jne    80100d47 <exec+0x27b>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df7:	83 c0 03             	add    $0x3,%eax
80100dfa:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100e01:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e05:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100e0c:	ff ff ff 
  ustack[1] = argc;
80100e0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e12:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e1b:	40                   	inc    %eax
80100e1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e23:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e26:	29 d0                	sub    %edx,%eax
80100e28:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e31:	83 c0 04             	add    $0x4,%eax
80100e34:	c1 e0 02             	shl    $0x2,%eax
80100e37:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e3d:	83 c0 04             	add    $0x4,%eax
80100e40:	c1 e0 02             	shl    $0x2,%eax
80100e43:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e47:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100e4d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e51:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e54:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e5b:	89 04 24             	mov    %eax,(%esp)
80100e5e:	e8 2e 73 00 00       	call   80108191 <copyout>
80100e63:	85 c0                	test   %eax,%eax
80100e65:	0f 88 cc 00 00 00    	js     80100f37 <exec+0x46b>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80100e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e74:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e77:	eb 13                	jmp    80100e8c <exec+0x3c0>
    if(*s == '/')
80100e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e7c:	8a 00                	mov    (%eax),%al
80100e7e:	3c 2f                	cmp    $0x2f,%al
80100e80:	75 07                	jne    80100e89 <exec+0x3bd>
      last = s+1;
80100e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e85:	40                   	inc    %eax
80100e86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e89:	ff 45 f4             	incl   -0xc(%ebp)
80100e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e8f:	8a 00                	mov    (%eax),%al
80100e91:	84 c0                	test   %al,%al
80100e93:	75 e4                	jne    80100e79 <exec+0x3ad>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e9b:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e9e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ea5:	00 
80100ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ead:	89 14 24             	mov    %edx,(%esp)
80100eb0:	e8 ff 41 00 00       	call   801050b4 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100eb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebb:	8b 40 04             	mov    0x4(%eax),%eax
80100ebe:	89 45 cc             	mov    %eax,-0x34(%ebp)
  proc->pgdir = pgdir;
80100ec1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100eca:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ecd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed3:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ed6:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ed8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ede:	8b 40 18             	mov    0x18(%eax),%eax
80100ee1:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100ee7:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100eea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef0:	8b 40 18             	mov    0x18(%eax),%eax
80100ef3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ef6:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ef9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eff:	89 04 24             	mov    %eax,(%esp)
80100f02:	e8 d2 6b 00 00       	call   80107ad9 <switchuvm>
  freevm(oldpgdir);
80100f07:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100f0a:	89 04 24             	mov    %eax,(%esp)
80100f0d:	e8 32 70 00 00       	call   80107f44 <freevm>
  return 0;
80100f12:	b8 00 00 00 00       	mov    $0x0,%eax
80100f17:	eb 46                	jmp    80100f5f <exec+0x493>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100f19:	90                   	nop
80100f1a:	eb 1c                	jmp    80100f38 <exec+0x46c>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100f1c:	90                   	nop
80100f1d:	eb 19                	jmp    80100f38 <exec+0x46c>

  if((pgdir = setupkvm(kalloc)) == 0)
    goto bad;
80100f1f:	90                   	nop
80100f20:	eb 16                	jmp    80100f38 <exec+0x46c>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100f22:	90                   	nop
80100f23:	eb 13                	jmp    80100f38 <exec+0x46c>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100f25:	90                   	nop
80100f26:	eb 10                	jmp    80100f38 <exec+0x46c>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100f28:	90                   	nop
80100f29:	eb 0d                	jmp    80100f38 <exec+0x46c>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100f2b:	90                   	nop
80100f2c:	eb 0a                	jmp    80100f38 <exec+0x46c>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100f2e:	90                   	nop
80100f2f:	eb 07                	jmp    80100f38 <exec+0x46c>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100f31:	90                   	nop
80100f32:	eb 04                	jmp    80100f38 <exec+0x46c>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100f34:	90                   	nop
80100f35:	eb 01                	jmp    80100f38 <exec+0x46c>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100f37:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100f38:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f3c:	74 0b                	je     80100f49 <exec+0x47d>
    freevm(pgdir);
80100f3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f41:	89 04 24             	mov    %eax,(%esp)
80100f44:	e8 fb 6f 00 00       	call   80107f44 <freevm>
  if(ip)
80100f49:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f4d:	74 0b                	je     80100f5a <exec+0x48e>
    iunlockput(ip);
80100f4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f52:	89 04 24             	mov    %eax,(%esp)
80100f55:	e8 29 0c 00 00       	call   80101b83 <iunlockput>
  return -1;
80100f5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f5f:	c9                   	leave  
80100f60:	c3                   	ret    

80100f61 <add_path>:

int
add_path(char* path)
{
80100f61:	55                   	push   %ebp
80100f62:	89 e5                	mov    %esp,%ebp
80100f64:	83 ec 18             	sub    $0x18,%esp
    if(nextPathPosition < MAX_PATH_ENTRIES)
80100f67:	a1 60 e3 10 80       	mov    0x8010e360,%eax
80100f6c:	83 f8 09             	cmp    $0x9,%eax
80100f6f:	7f 3f                	jg     80100fb0 <add_path+0x4f>
    {
        strncpy(pathsEnv[nextPathPosition], path, strlen(path));
80100f71:	8b 45 08             	mov    0x8(%ebp),%eax
80100f74:	89 04 24             	mov    %eax,(%esp)
80100f77:	e8 81 41 00 00       	call   801050fd <strlen>
80100f7c:	8b 15 60 e3 10 80    	mov    0x8010e360,%edx
80100f82:	c1 e2 07             	shl    $0x7,%edx
80100f85:	81 c2 60 de 10 80    	add    $0x8010de60,%edx
80100f8b:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f8f:	8b 45 08             	mov    0x8(%ebp),%eax
80100f92:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f96:	89 14 24             	mov    %edx,(%esp)
80100f99:	e8 bc 40 00 00       	call   8010505a <strncpy>
        nextPathPosition++;
80100f9e:	a1 60 e3 10 80       	mov    0x8010e360,%eax
80100fa3:	40                   	inc    %eax
80100fa4:	a3 60 e3 10 80       	mov    %eax,0x8010e360
        return 1;
80100fa9:	b8 01 00 00 00       	mov    $0x1,%eax
80100fae:	eb 05                	jmp    80100fb5 <add_path+0x54>
    }
    return -1;
80100fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fb5:	c9                   	leave  
80100fb6:	c3                   	ret    
80100fb7:	90                   	nop

80100fb8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fb8:	55                   	push   %ebp
80100fb9:	89 e5                	mov    %esp,%ebp
80100fbb:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100fbe:	c7 44 24 04 96 82 10 	movl   $0x80108296,0x4(%esp)
80100fc5:	80 
80100fc6:	c7 04 24 80 e3 10 80 	movl   $0x8010e380,(%esp)
80100fcd:	e8 5c 3c 00 00       	call   80104c2e <initlock>
}
80100fd2:	c9                   	leave  
80100fd3:	c3                   	ret    

80100fd4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fd4:	55                   	push   %ebp
80100fd5:	89 e5                	mov    %esp,%ebp
80100fd7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fda:	c7 04 24 80 e3 10 80 	movl   $0x8010e380,(%esp)
80100fe1:	e8 69 3c 00 00       	call   80104c4f <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fe6:	c7 45 f4 b4 e3 10 80 	movl   $0x8010e3b4,-0xc(%ebp)
80100fed:	eb 29                	jmp    80101018 <filealloc+0x44>
    if(f->ref == 0){
80100fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ff2:	8b 40 04             	mov    0x4(%eax),%eax
80100ff5:	85 c0                	test   %eax,%eax
80100ff7:	75 1b                	jne    80101014 <filealloc+0x40>
      f->ref = 1;
80100ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ffc:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101003:	c7 04 24 80 e3 10 80 	movl   $0x8010e380,(%esp)
8010100a:	e8 a2 3c 00 00       	call   80104cb1 <release>
      return f;
8010100f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101012:	eb 1e                	jmp    80101032 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101014:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101018:	81 7d f4 14 ed 10 80 	cmpl   $0x8010ed14,-0xc(%ebp)
8010101f:	72 ce                	jb     80100fef <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101021:	c7 04 24 80 e3 10 80 	movl   $0x8010e380,(%esp)
80101028:	e8 84 3c 00 00       	call   80104cb1 <release>
  return 0;
8010102d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101032:	c9                   	leave  
80101033:	c3                   	ret    

80101034 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101034:	55                   	push   %ebp
80101035:	89 e5                	mov    %esp,%ebp
80101037:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
8010103a:	c7 04 24 80 e3 10 80 	movl   $0x8010e380,(%esp)
80101041:	e8 09 3c 00 00       	call   80104c4f <acquire>
  if(f->ref < 1)
80101046:	8b 45 08             	mov    0x8(%ebp),%eax
80101049:	8b 40 04             	mov    0x4(%eax),%eax
8010104c:	85 c0                	test   %eax,%eax
8010104e:	7f 0c                	jg     8010105c <filedup+0x28>
    panic("filedup");
80101050:	c7 04 24 9d 82 10 80 	movl   $0x8010829d,(%esp)
80101057:	e8 da f4 ff ff       	call   80100536 <panic>
  f->ref++;
8010105c:	8b 45 08             	mov    0x8(%ebp),%eax
8010105f:	8b 40 04             	mov    0x4(%eax),%eax
80101062:	8d 50 01             	lea    0x1(%eax),%edx
80101065:	8b 45 08             	mov    0x8(%ebp),%eax
80101068:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010106b:	c7 04 24 80 e3 10 80 	movl   $0x8010e380,(%esp)
80101072:	e8 3a 3c 00 00       	call   80104cb1 <release>
  return f;
80101077:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010107a:	c9                   	leave  
8010107b:	c3                   	ret    

8010107c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010107c:	55                   	push   %ebp
8010107d:	89 e5                	mov    %esp,%ebp
8010107f:	57                   	push   %edi
80101080:	56                   	push   %esi
80101081:	53                   	push   %ebx
80101082:	83 ec 3c             	sub    $0x3c,%esp
  struct file ff;

  acquire(&ftable.lock);
80101085:	c7 04 24 80 e3 10 80 	movl   $0x8010e380,(%esp)
8010108c:	e8 be 3b 00 00       	call   80104c4f <acquire>
  if(f->ref < 1)
80101091:	8b 45 08             	mov    0x8(%ebp),%eax
80101094:	8b 40 04             	mov    0x4(%eax),%eax
80101097:	85 c0                	test   %eax,%eax
80101099:	7f 0c                	jg     801010a7 <fileclose+0x2b>
    panic("fileclose");
8010109b:	c7 04 24 a5 82 10 80 	movl   $0x801082a5,(%esp)
801010a2:	e8 8f f4 ff ff       	call   80100536 <panic>
  if(--f->ref > 0){
801010a7:	8b 45 08             	mov    0x8(%ebp),%eax
801010aa:	8b 40 04             	mov    0x4(%eax),%eax
801010ad:	8d 50 ff             	lea    -0x1(%eax),%edx
801010b0:	8b 45 08             	mov    0x8(%ebp),%eax
801010b3:	89 50 04             	mov    %edx,0x4(%eax)
801010b6:	8b 45 08             	mov    0x8(%ebp),%eax
801010b9:	8b 40 04             	mov    0x4(%eax),%eax
801010bc:	85 c0                	test   %eax,%eax
801010be:	7e 0e                	jle    801010ce <fileclose+0x52>
    release(&ftable.lock);
801010c0:	c7 04 24 80 e3 10 80 	movl   $0x8010e380,(%esp)
801010c7:	e8 e5 3b 00 00       	call   80104cb1 <release>
801010cc:	eb 70                	jmp    8010113e <fileclose+0xc2>
    return;
  }
  ff = *f;
801010ce:	8b 45 08             	mov    0x8(%ebp),%eax
801010d1:	8d 55 d0             	lea    -0x30(%ebp),%edx
801010d4:	89 c3                	mov    %eax,%ebx
801010d6:	b8 06 00 00 00       	mov    $0x6,%eax
801010db:	89 d7                	mov    %edx,%edi
801010dd:	89 de                	mov    %ebx,%esi
801010df:	89 c1                	mov    %eax,%ecx
801010e1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
801010e3:	8b 45 08             	mov    0x8(%ebp),%eax
801010e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010ed:	8b 45 08             	mov    0x8(%ebp),%eax
801010f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010f6:	c7 04 24 80 e3 10 80 	movl   $0x8010e380,(%esp)
801010fd:	e8 af 3b 00 00       	call   80104cb1 <release>
  
  if(ff.type == FD_PIPE)
80101102:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101105:	83 f8 01             	cmp    $0x1,%eax
80101108:	75 17                	jne    80101121 <fileclose+0xa5>
    pipeclose(ff.pipe, ff.writable);
8010110a:	8a 45 d9             	mov    -0x27(%ebp),%al
8010110d:	0f be d0             	movsbl %al,%edx
80101110:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101113:	89 54 24 04          	mov    %edx,0x4(%esp)
80101117:	89 04 24             	mov    %eax,(%esp)
8010111a:	e8 0c 2d 00 00       	call   80103e2b <pipeclose>
8010111f:	eb 1d                	jmp    8010113e <fileclose+0xc2>
  else if(ff.type == FD_INODE){
80101121:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101124:	83 f8 02             	cmp    $0x2,%eax
80101127:	75 15                	jne    8010113e <fileclose+0xc2>
    begin_trans();
80101129:	e8 61 21 00 00       	call   8010328f <begin_trans>
    iput(ff.ip);
8010112e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101131:	89 04 24             	mov    %eax,(%esp)
80101134:	e8 79 09 00 00       	call   80101ab2 <iput>
    commit_trans();
80101139:	e8 9a 21 00 00       	call   801032d8 <commit_trans>
  }
}
8010113e:	83 c4 3c             	add    $0x3c,%esp
80101141:	5b                   	pop    %ebx
80101142:	5e                   	pop    %esi
80101143:	5f                   	pop    %edi
80101144:	5d                   	pop    %ebp
80101145:	c3                   	ret    

80101146 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101146:	55                   	push   %ebp
80101147:	89 e5                	mov    %esp,%ebp
80101149:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
8010114c:	8b 45 08             	mov    0x8(%ebp),%eax
8010114f:	8b 00                	mov    (%eax),%eax
80101151:	83 f8 02             	cmp    $0x2,%eax
80101154:	75 38                	jne    8010118e <filestat+0x48>
    ilock(f->ip);
80101156:	8b 45 08             	mov    0x8(%ebp),%eax
80101159:	8b 40 10             	mov    0x10(%eax),%eax
8010115c:	89 04 24             	mov    %eax,(%esp)
8010115f:	e8 9e 07 00 00       	call   80101902 <ilock>
    stati(f->ip, st);
80101164:	8b 45 08             	mov    0x8(%ebp),%eax
80101167:	8b 40 10             	mov    0x10(%eax),%eax
8010116a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010116d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101171:	89 04 24             	mov    %eax,(%esp)
80101174:	e8 4c 0c 00 00       	call   80101dc5 <stati>
    iunlock(f->ip);
80101179:	8b 45 08             	mov    0x8(%ebp),%eax
8010117c:	8b 40 10             	mov    0x10(%eax),%eax
8010117f:	89 04 24             	mov    %eax,(%esp)
80101182:	e8 c6 08 00 00       	call   80101a4d <iunlock>
    return 0;
80101187:	b8 00 00 00 00       	mov    $0x0,%eax
8010118c:	eb 05                	jmp    80101193 <filestat+0x4d>
  }
  return -1;
8010118e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101193:	c9                   	leave  
80101194:	c3                   	ret    

80101195 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101195:	55                   	push   %ebp
80101196:	89 e5                	mov    %esp,%ebp
80101198:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010119b:	8b 45 08             	mov    0x8(%ebp),%eax
8010119e:	8a 40 08             	mov    0x8(%eax),%al
801011a1:	84 c0                	test   %al,%al
801011a3:	75 0a                	jne    801011af <fileread+0x1a>
    return -1;
801011a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011aa:	e9 9f 00 00 00       	jmp    8010124e <fileread+0xb9>
  if(f->type == FD_PIPE)
801011af:	8b 45 08             	mov    0x8(%ebp),%eax
801011b2:	8b 00                	mov    (%eax),%eax
801011b4:	83 f8 01             	cmp    $0x1,%eax
801011b7:	75 1e                	jne    801011d7 <fileread+0x42>
    return piperead(f->pipe, addr, n);
801011b9:	8b 45 08             	mov    0x8(%ebp),%eax
801011bc:	8b 40 0c             	mov    0xc(%eax),%eax
801011bf:	8b 55 10             	mov    0x10(%ebp),%edx
801011c2:	89 54 24 08          	mov    %edx,0x8(%esp)
801011c6:	8b 55 0c             	mov    0xc(%ebp),%edx
801011c9:	89 54 24 04          	mov    %edx,0x4(%esp)
801011cd:	89 04 24             	mov    %eax,(%esp)
801011d0:	e8 d8 2d 00 00       	call   80103fad <piperead>
801011d5:	eb 77                	jmp    8010124e <fileread+0xb9>
  if(f->type == FD_INODE){
801011d7:	8b 45 08             	mov    0x8(%ebp),%eax
801011da:	8b 00                	mov    (%eax),%eax
801011dc:	83 f8 02             	cmp    $0x2,%eax
801011df:	75 61                	jne    80101242 <fileread+0xad>
    ilock(f->ip);
801011e1:	8b 45 08             	mov    0x8(%ebp),%eax
801011e4:	8b 40 10             	mov    0x10(%eax),%eax
801011e7:	89 04 24             	mov    %eax,(%esp)
801011ea:	e8 13 07 00 00       	call   80101902 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011f2:	8b 45 08             	mov    0x8(%ebp),%eax
801011f5:	8b 50 14             	mov    0x14(%eax),%edx
801011f8:	8b 45 08             	mov    0x8(%ebp),%eax
801011fb:	8b 40 10             	mov    0x10(%eax),%eax
801011fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101202:	89 54 24 08          	mov    %edx,0x8(%esp)
80101206:	8b 55 0c             	mov    0xc(%ebp),%edx
80101209:	89 54 24 04          	mov    %edx,0x4(%esp)
8010120d:	89 04 24             	mov    %eax,(%esp)
80101210:	e8 f4 0b 00 00       	call   80101e09 <readi>
80101215:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101218:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010121c:	7e 11                	jle    8010122f <fileread+0x9a>
      f->off += r;
8010121e:	8b 45 08             	mov    0x8(%ebp),%eax
80101221:	8b 50 14             	mov    0x14(%eax),%edx
80101224:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101227:	01 c2                	add    %eax,%edx
80101229:	8b 45 08             	mov    0x8(%ebp),%eax
8010122c:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010122f:	8b 45 08             	mov    0x8(%ebp),%eax
80101232:	8b 40 10             	mov    0x10(%eax),%eax
80101235:	89 04 24             	mov    %eax,(%esp)
80101238:	e8 10 08 00 00       	call   80101a4d <iunlock>
    return r;
8010123d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101240:	eb 0c                	jmp    8010124e <fileread+0xb9>
  }
  panic("fileread");
80101242:	c7 04 24 af 82 10 80 	movl   $0x801082af,(%esp)
80101249:	e8 e8 f2 ff ff       	call   80100536 <panic>
}
8010124e:	c9                   	leave  
8010124f:	c3                   	ret    

80101250 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	53                   	push   %ebx
80101254:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
80101257:	8b 45 08             	mov    0x8(%ebp),%eax
8010125a:	8a 40 09             	mov    0x9(%eax),%al
8010125d:	84 c0                	test   %al,%al
8010125f:	75 0a                	jne    8010126b <filewrite+0x1b>
    return -1;
80101261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101266:	e9 23 01 00 00       	jmp    8010138e <filewrite+0x13e>
  if(f->type == FD_PIPE)
8010126b:	8b 45 08             	mov    0x8(%ebp),%eax
8010126e:	8b 00                	mov    (%eax),%eax
80101270:	83 f8 01             	cmp    $0x1,%eax
80101273:	75 21                	jne    80101296 <filewrite+0x46>
    return pipewrite(f->pipe, addr, n);
80101275:	8b 45 08             	mov    0x8(%ebp),%eax
80101278:	8b 40 0c             	mov    0xc(%eax),%eax
8010127b:	8b 55 10             	mov    0x10(%ebp),%edx
8010127e:	89 54 24 08          	mov    %edx,0x8(%esp)
80101282:	8b 55 0c             	mov    0xc(%ebp),%edx
80101285:	89 54 24 04          	mov    %edx,0x4(%esp)
80101289:	89 04 24             	mov    %eax,(%esp)
8010128c:	e8 2c 2c 00 00       	call   80103ebd <pipewrite>
80101291:	e9 f8 00 00 00       	jmp    8010138e <filewrite+0x13e>
  if(f->type == FD_INODE){
80101296:	8b 45 08             	mov    0x8(%ebp),%eax
80101299:	8b 00                	mov    (%eax),%eax
8010129b:	83 f8 02             	cmp    $0x2,%eax
8010129e:	0f 85 de 00 00 00    	jne    80101382 <filewrite+0x132>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801012a4:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
801012ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012b2:	e9 a8 00 00 00       	jmp    8010135f <filewrite+0x10f>
      int n1 = n - i;
801012b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ba:	8b 55 10             	mov    0x10(%ebp),%edx
801012bd:	89 d1                	mov    %edx,%ecx
801012bf:	29 c1                	sub    %eax,%ecx
801012c1:	89 c8                	mov    %ecx,%eax
801012c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012cc:	7e 06                	jle    801012d4 <filewrite+0x84>
        n1 = max;
801012ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012d1:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
801012d4:	e8 b6 1f 00 00       	call   8010328f <begin_trans>
      ilock(f->ip);
801012d9:	8b 45 08             	mov    0x8(%ebp),%eax
801012dc:	8b 40 10             	mov    0x10(%eax),%eax
801012df:	89 04 24             	mov    %eax,(%esp)
801012e2:	e8 1b 06 00 00       	call   80101902 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012e7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012ea:	8b 45 08             	mov    0x8(%ebp),%eax
801012ed:	8b 50 14             	mov    0x14(%eax),%edx
801012f0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801012f6:	01 c3                	add    %eax,%ebx
801012f8:	8b 45 08             	mov    0x8(%ebp),%eax
801012fb:	8b 40 10             	mov    0x10(%eax),%eax
801012fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101302:	89 54 24 08          	mov    %edx,0x8(%esp)
80101306:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010130a:	89 04 24             	mov    %eax,(%esp)
8010130d:	e8 5c 0c 00 00       	call   80101f6e <writei>
80101312:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101315:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101319:	7e 11                	jle    8010132c <filewrite+0xdc>
        f->off += r;
8010131b:	8b 45 08             	mov    0x8(%ebp),%eax
8010131e:	8b 50 14             	mov    0x14(%eax),%edx
80101321:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101324:	01 c2                	add    %eax,%edx
80101326:	8b 45 08             	mov    0x8(%ebp),%eax
80101329:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010132c:	8b 45 08             	mov    0x8(%ebp),%eax
8010132f:	8b 40 10             	mov    0x10(%eax),%eax
80101332:	89 04 24             	mov    %eax,(%esp)
80101335:	e8 13 07 00 00       	call   80101a4d <iunlock>
      commit_trans();
8010133a:	e8 99 1f 00 00       	call   801032d8 <commit_trans>

      if(r < 0)
8010133f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101343:	78 28                	js     8010136d <filewrite+0x11d>
        break;
      if(r != n1)
80101345:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101348:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010134b:	74 0c                	je     80101359 <filewrite+0x109>
        panic("short filewrite");
8010134d:	c7 04 24 b8 82 10 80 	movl   $0x801082b8,(%esp)
80101354:	e8 dd f1 ff ff       	call   80100536 <panic>
      i += r;
80101359:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010135c:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010135f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101362:	3b 45 10             	cmp    0x10(%ebp),%eax
80101365:	0f 8c 4c ff ff ff    	jl     801012b7 <filewrite+0x67>
8010136b:	eb 01                	jmp    8010136e <filewrite+0x11e>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
8010136d:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010136e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101371:	3b 45 10             	cmp    0x10(%ebp),%eax
80101374:	75 05                	jne    8010137b <filewrite+0x12b>
80101376:	8b 45 10             	mov    0x10(%ebp),%eax
80101379:	eb 05                	jmp    80101380 <filewrite+0x130>
8010137b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101380:	eb 0c                	jmp    8010138e <filewrite+0x13e>
  }
  panic("filewrite");
80101382:	c7 04 24 c8 82 10 80 	movl   $0x801082c8,(%esp)
80101389:	e8 a8 f1 ff ff       	call   80100536 <panic>
}
8010138e:	83 c4 24             	add    $0x24,%esp
80101391:	5b                   	pop    %ebx
80101392:	5d                   	pop    %ebp
80101393:	c3                   	ret    

80101394 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101394:	55                   	push   %ebp
80101395:	89 e5                	mov    %esp,%ebp
80101397:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010139a:	8b 45 08             	mov    0x8(%ebp),%eax
8010139d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013a4:	00 
801013a5:	89 04 24             	mov    %eax,(%esp)
801013a8:	e8 f9 ed ff ff       	call   801001a6 <bread>
801013ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b3:	83 c0 18             	add    $0x18,%eax
801013b6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801013bd:	00 
801013be:	89 44 24 04          	mov    %eax,0x4(%esp)
801013c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801013c5:	89 04 24             	mov    %eax,(%esp)
801013c8:	e8 a1 3b 00 00       	call   80104f6e <memmove>
  brelse(bp);
801013cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013d0:	89 04 24             	mov    %eax,(%esp)
801013d3:	e8 3f ee ff ff       	call   80100217 <brelse>
}
801013d8:	c9                   	leave  
801013d9:	c3                   	ret    

801013da <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013da:	55                   	push   %ebp
801013db:	89 e5                	mov    %esp,%ebp
801013dd:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013e0:	8b 55 0c             	mov    0xc(%ebp),%edx
801013e3:	8b 45 08             	mov    0x8(%ebp),%eax
801013e6:	89 54 24 04          	mov    %edx,0x4(%esp)
801013ea:	89 04 24             	mov    %eax,(%esp)
801013ed:	e8 b4 ed ff ff       	call   801001a6 <bread>
801013f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f8:	83 c0 18             	add    $0x18,%eax
801013fb:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101402:	00 
80101403:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010140a:	00 
8010140b:	89 04 24             	mov    %eax,(%esp)
8010140e:	e8 8f 3a 00 00       	call   80104ea2 <memset>
  log_write(bp);
80101413:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101416:	89 04 24             	mov    %eax,(%esp)
80101419:	e8 12 1f 00 00       	call   80103330 <log_write>
  brelse(bp);
8010141e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101421:	89 04 24             	mov    %eax,(%esp)
80101424:	e8 ee ed ff ff       	call   80100217 <brelse>
}
80101429:	c9                   	leave  
8010142a:	c3                   	ret    

8010142b <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010142b:	55                   	push   %ebp
8010142c:	89 e5                	mov    %esp,%ebp
8010142e:	53                   	push   %ebx
8010142f:	83 ec 34             	sub    $0x34,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
80101432:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
80101439:	8b 45 08             	mov    0x8(%ebp),%eax
8010143c:	8d 55 d8             	lea    -0x28(%ebp),%edx
8010143f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101443:	89 04 24             	mov    %eax,(%esp)
80101446:	e8 49 ff ff ff       	call   80101394 <readsb>
  for(b = 0; b < sb.size; b += BPB){
8010144b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101452:	e9 05 01 00 00       	jmp    8010155c <balloc+0x131>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
80101457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010145a:	85 c0                	test   %eax,%eax
8010145c:	79 05                	jns    80101463 <balloc+0x38>
8010145e:	05 ff 0f 00 00       	add    $0xfff,%eax
80101463:	c1 f8 0c             	sar    $0xc,%eax
80101466:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101469:	c1 ea 03             	shr    $0x3,%edx
8010146c:	01 d0                	add    %edx,%eax
8010146e:	83 c0 03             	add    $0x3,%eax
80101471:	89 44 24 04          	mov    %eax,0x4(%esp)
80101475:	8b 45 08             	mov    0x8(%ebp),%eax
80101478:	89 04 24             	mov    %eax,(%esp)
8010147b:	e8 26 ed ff ff       	call   801001a6 <bread>
80101480:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101483:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010148a:	e9 9d 00 00 00       	jmp    8010152c <balloc+0x101>
      m = 1 << (bi % 8);
8010148f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101492:	25 07 00 00 80       	and    $0x80000007,%eax
80101497:	85 c0                	test   %eax,%eax
80101499:	79 05                	jns    801014a0 <balloc+0x75>
8010149b:	48                   	dec    %eax
8010149c:	83 c8 f8             	or     $0xfffffff8,%eax
8010149f:	40                   	inc    %eax
801014a0:	ba 01 00 00 00       	mov    $0x1,%edx
801014a5:	89 d3                	mov    %edx,%ebx
801014a7:	88 c1                	mov    %al,%cl
801014a9:	d3 e3                	shl    %cl,%ebx
801014ab:	89 d8                	mov    %ebx,%eax
801014ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b3:	85 c0                	test   %eax,%eax
801014b5:	79 03                	jns    801014ba <balloc+0x8f>
801014b7:	83 c0 07             	add    $0x7,%eax
801014ba:	c1 f8 03             	sar    $0x3,%eax
801014bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014c0:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
801014c4:	0f b6 c0             	movzbl %al,%eax
801014c7:	23 45 e8             	and    -0x18(%ebp),%eax
801014ca:	85 c0                	test   %eax,%eax
801014cc:	75 5b                	jne    80101529 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
801014ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d1:	85 c0                	test   %eax,%eax
801014d3:	79 03                	jns    801014d8 <balloc+0xad>
801014d5:	83 c0 07             	add    $0x7,%eax
801014d8:	c1 f8 03             	sar    $0x3,%eax
801014db:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014de:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
801014e2:	88 d1                	mov    %dl,%cl
801014e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014e7:	09 ca                	or     %ecx,%edx
801014e9:	88 d1                	mov    %dl,%cl
801014eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014ee:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014f5:	89 04 24             	mov    %eax,(%esp)
801014f8:	e8 33 1e 00 00       	call   80103330 <log_write>
        brelse(bp);
801014fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101500:	89 04 24             	mov    %eax,(%esp)
80101503:	e8 0f ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101508:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010150b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010150e:	01 c2                	add    %eax,%edx
80101510:	8b 45 08             	mov    0x8(%ebp),%eax
80101513:	89 54 24 04          	mov    %edx,0x4(%esp)
80101517:	89 04 24             	mov    %eax,(%esp)
8010151a:	e8 bb fe ff ff       	call   801013da <bzero>
        return b + bi;
8010151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101522:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101525:	01 d0                	add    %edx,%eax
80101527:	eb 4d                	jmp    80101576 <balloc+0x14b>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101529:	ff 45 f0             	incl   -0x10(%ebp)
8010152c:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101533:	7f 15                	jg     8010154a <balloc+0x11f>
80101535:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101538:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010153b:	01 d0                	add    %edx,%eax
8010153d:	89 c2                	mov    %eax,%edx
8010153f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101542:	39 c2                	cmp    %eax,%edx
80101544:	0f 82 45 ff ff ff    	jb     8010148f <balloc+0x64>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010154a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010154d:	89 04 24             	mov    %eax,(%esp)
80101550:	e8 c2 ec ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
80101555:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010155c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010155f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101562:	39 c2                	cmp    %eax,%edx
80101564:	0f 82 ed fe ff ff    	jb     80101457 <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010156a:	c7 04 24 d2 82 10 80 	movl   $0x801082d2,(%esp)
80101571:	e8 c0 ef ff ff       	call   80100536 <panic>
}
80101576:	83 c4 34             	add    $0x34,%esp
80101579:	5b                   	pop    %ebx
8010157a:	5d                   	pop    %ebp
8010157b:	c3                   	ret    

8010157c <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010157c:	55                   	push   %ebp
8010157d:	89 e5                	mov    %esp,%ebp
8010157f:	53                   	push   %ebx
80101580:	83 ec 34             	sub    $0x34,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101583:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101586:	89 44 24 04          	mov    %eax,0x4(%esp)
8010158a:	8b 45 08             	mov    0x8(%ebp),%eax
8010158d:	89 04 24             	mov    %eax,(%esp)
80101590:	e8 ff fd ff ff       	call   80101394 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101595:	8b 45 0c             	mov    0xc(%ebp),%eax
80101598:	89 c2                	mov    %eax,%edx
8010159a:	c1 ea 0c             	shr    $0xc,%edx
8010159d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801015a0:	c1 e8 03             	shr    $0x3,%eax
801015a3:	01 d0                	add    %edx,%eax
801015a5:	8d 50 03             	lea    0x3(%eax),%edx
801015a8:	8b 45 08             	mov    0x8(%ebp),%eax
801015ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801015af:	89 04 24             	mov    %eax,(%esp)
801015b2:	e8 ef eb ff ff       	call   801001a6 <bread>
801015b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801015bd:	25 ff 0f 00 00       	and    $0xfff,%eax
801015c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015c8:	25 07 00 00 80       	and    $0x80000007,%eax
801015cd:	85 c0                	test   %eax,%eax
801015cf:	79 05                	jns    801015d6 <bfree+0x5a>
801015d1:	48                   	dec    %eax
801015d2:	83 c8 f8             	or     $0xfffffff8,%eax
801015d5:	40                   	inc    %eax
801015d6:	ba 01 00 00 00       	mov    $0x1,%edx
801015db:	89 d3                	mov    %edx,%ebx
801015dd:	88 c1                	mov    %al,%cl
801015df:	d3 e3                	shl    %cl,%ebx
801015e1:	89 d8                	mov    %ebx,%eax
801015e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015e9:	85 c0                	test   %eax,%eax
801015eb:	79 03                	jns    801015f0 <bfree+0x74>
801015ed:	83 c0 07             	add    $0x7,%eax
801015f0:	c1 f8 03             	sar    $0x3,%eax
801015f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015f6:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
801015fa:	0f b6 c0             	movzbl %al,%eax
801015fd:	23 45 ec             	and    -0x14(%ebp),%eax
80101600:	85 c0                	test   %eax,%eax
80101602:	75 0c                	jne    80101610 <bfree+0x94>
    panic("freeing free block");
80101604:	c7 04 24 e8 82 10 80 	movl   $0x801082e8,(%esp)
8010160b:	e8 26 ef ff ff       	call   80100536 <panic>
  bp->data[bi/8] &= ~m;
80101610:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101613:	85 c0                	test   %eax,%eax
80101615:	79 03                	jns    8010161a <bfree+0x9e>
80101617:	83 c0 07             	add    $0x7,%eax
8010161a:	c1 f8 03             	sar    $0x3,%eax
8010161d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101620:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
80101624:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101627:	f7 d1                	not    %ecx
80101629:	21 ca                	and    %ecx,%edx
8010162b:	88 d1                	mov    %dl,%cl
8010162d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101630:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101634:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101637:	89 04 24             	mov    %eax,(%esp)
8010163a:	e8 f1 1c 00 00       	call   80103330 <log_write>
  brelse(bp);
8010163f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101642:	89 04 24             	mov    %eax,(%esp)
80101645:	e8 cd eb ff ff       	call   80100217 <brelse>
}
8010164a:	83 c4 34             	add    $0x34,%esp
8010164d:	5b                   	pop    %ebx
8010164e:	5d                   	pop    %ebp
8010164f:	c3                   	ret    

80101650 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
80101656:	c7 44 24 04 fb 82 10 	movl   $0x801082fb,0x4(%esp)
8010165d:	80 
8010165e:	c7 04 24 80 ed 10 80 	movl   $0x8010ed80,(%esp)
80101665:	e8 c4 35 00 00       	call   80104c2e <initlock>
}
8010166a:	c9                   	leave  
8010166b:	c3                   	ret    

8010166c <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010166c:	55                   	push   %ebp
8010166d:	89 e5                	mov    %esp,%ebp
8010166f:	83 ec 48             	sub    $0x48,%esp
80101672:	8b 45 0c             	mov    0xc(%ebp),%eax
80101675:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101679:	8b 45 08             	mov    0x8(%ebp),%eax
8010167c:	8d 55 dc             	lea    -0x24(%ebp),%edx
8010167f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101683:	89 04 24             	mov    %eax,(%esp)
80101686:	e8 09 fd ff ff       	call   80101394 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
8010168b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101692:	e9 95 00 00 00       	jmp    8010172c <ialloc+0xc0>
    bp = bread(dev, IBLOCK(inum));
80101697:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010169a:	c1 e8 03             	shr    $0x3,%eax
8010169d:	83 c0 02             	add    $0x2,%eax
801016a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801016a4:	8b 45 08             	mov    0x8(%ebp),%eax
801016a7:	89 04 24             	mov    %eax,(%esp)
801016aa:	e8 f7 ea ff ff       	call   801001a6 <bread>
801016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016b5:	8d 50 18             	lea    0x18(%eax),%edx
801016b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016bb:	83 e0 07             	and    $0x7,%eax
801016be:	c1 e0 06             	shl    $0x6,%eax
801016c1:	01 d0                	add    %edx,%eax
801016c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801016c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016c9:	8b 00                	mov    (%eax),%eax
801016cb:	66 85 c0             	test   %ax,%ax
801016ce:	75 4e                	jne    8010171e <ialloc+0xb2>
      memset(dip, 0, sizeof(*dip));
801016d0:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801016d7:	00 
801016d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801016df:	00 
801016e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016e3:	89 04 24             	mov    %eax,(%esp)
801016e6:	e8 b7 37 00 00       	call   80104ea2 <memset>
      dip->type = type;
801016eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801016f1:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
801016f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f7:	89 04 24             	mov    %eax,(%esp)
801016fa:	e8 31 1c 00 00       	call   80103330 <log_write>
      brelse(bp);
801016ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101702:	89 04 24             	mov    %eax,(%esp)
80101705:	e8 0d eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
8010170a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010170d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101711:	8b 45 08             	mov    0x8(%ebp),%eax
80101714:	89 04 24             	mov    %eax,(%esp)
80101717:	e8 e2 00 00 00       	call   801017fe <iget>
8010171c:	eb 28                	jmp    80101746 <ialloc+0xda>
    }
    brelse(bp);
8010171e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101721:	89 04 24             	mov    %eax,(%esp)
80101724:	e8 ee ea ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
80101729:	ff 45 f4             	incl   -0xc(%ebp)
8010172c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010172f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101732:	39 c2                	cmp    %eax,%edx
80101734:	0f 82 5d ff ff ff    	jb     80101697 <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010173a:	c7 04 24 02 83 10 80 	movl   $0x80108302,(%esp)
80101741:	e8 f0 ed ff ff       	call   80100536 <panic>
}
80101746:	c9                   	leave  
80101747:	c3                   	ret    

80101748 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101748:	55                   	push   %ebp
80101749:	89 e5                	mov    %esp,%ebp
8010174b:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
8010174e:	8b 45 08             	mov    0x8(%ebp),%eax
80101751:	8b 40 04             	mov    0x4(%eax),%eax
80101754:	c1 e8 03             	shr    $0x3,%eax
80101757:	8d 50 02             	lea    0x2(%eax),%edx
8010175a:	8b 45 08             	mov    0x8(%ebp),%eax
8010175d:	8b 00                	mov    (%eax),%eax
8010175f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101763:	89 04 24             	mov    %eax,(%esp)
80101766:	e8 3b ea ff ff       	call   801001a6 <bread>
8010176b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010176e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101771:	8d 50 18             	lea    0x18(%eax),%edx
80101774:	8b 45 08             	mov    0x8(%ebp),%eax
80101777:	8b 40 04             	mov    0x4(%eax),%eax
8010177a:	83 e0 07             	and    $0x7,%eax
8010177d:	c1 e0 06             	shl    $0x6,%eax
80101780:	01 d0                	add    %edx,%eax
80101782:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101785:	8b 45 08             	mov    0x8(%ebp),%eax
80101788:	8b 40 10             	mov    0x10(%eax),%eax
8010178b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010178e:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
80101791:	8b 45 08             	mov    0x8(%ebp),%eax
80101794:	66 8b 40 12          	mov    0x12(%eax),%ax
80101798:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010179b:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
8010179f:	8b 45 08             	mov    0x8(%ebp),%eax
801017a2:	8b 40 14             	mov    0x14(%eax),%eax
801017a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801017a8:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
801017ac:	8b 45 08             	mov    0x8(%ebp),%eax
801017af:	66 8b 40 16          	mov    0x16(%eax),%ax
801017b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801017b6:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
801017ba:	8b 45 08             	mov    0x8(%ebp),%eax
801017bd:	8b 50 18             	mov    0x18(%eax),%edx
801017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c3:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017c6:	8b 45 08             	mov    0x8(%ebp),%eax
801017c9:	8d 50 1c             	lea    0x1c(%eax),%edx
801017cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017cf:	83 c0 0c             	add    $0xc,%eax
801017d2:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801017d9:	00 
801017da:	89 54 24 04          	mov    %edx,0x4(%esp)
801017de:	89 04 24             	mov    %eax,(%esp)
801017e1:	e8 88 37 00 00       	call   80104f6e <memmove>
  log_write(bp);
801017e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e9:	89 04 24             	mov    %eax,(%esp)
801017ec:	e8 3f 1b 00 00       	call   80103330 <log_write>
  brelse(bp);
801017f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f4:	89 04 24             	mov    %eax,(%esp)
801017f7:	e8 1b ea ff ff       	call   80100217 <brelse>
}
801017fc:	c9                   	leave  
801017fd:	c3                   	ret    

801017fe <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017fe:	55                   	push   %ebp
801017ff:	89 e5                	mov    %esp,%ebp
80101801:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101804:	c7 04 24 80 ed 10 80 	movl   $0x8010ed80,(%esp)
8010180b:	e8 3f 34 00 00       	call   80104c4f <acquire>

  // Is the inode already cached?
  empty = 0;
80101810:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101817:	c7 45 f4 b4 ed 10 80 	movl   $0x8010edb4,-0xc(%ebp)
8010181e:	eb 59                	jmp    80101879 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101820:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101823:	8b 40 08             	mov    0x8(%eax),%eax
80101826:	85 c0                	test   %eax,%eax
80101828:	7e 35                	jle    8010185f <iget+0x61>
8010182a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182d:	8b 00                	mov    (%eax),%eax
8010182f:	3b 45 08             	cmp    0x8(%ebp),%eax
80101832:	75 2b                	jne    8010185f <iget+0x61>
80101834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101837:	8b 40 04             	mov    0x4(%eax),%eax
8010183a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010183d:	75 20                	jne    8010185f <iget+0x61>
      ip->ref++;
8010183f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101842:	8b 40 08             	mov    0x8(%eax),%eax
80101845:	8d 50 01             	lea    0x1(%eax),%edx
80101848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184b:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010184e:	c7 04 24 80 ed 10 80 	movl   $0x8010ed80,(%esp)
80101855:	e8 57 34 00 00       	call   80104cb1 <release>
      return ip;
8010185a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185d:	eb 6f                	jmp    801018ce <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010185f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101863:	75 10                	jne    80101875 <iget+0x77>
80101865:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101868:	8b 40 08             	mov    0x8(%eax),%eax
8010186b:	85 c0                	test   %eax,%eax
8010186d:	75 06                	jne    80101875 <iget+0x77>
      empty = ip;
8010186f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101872:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101875:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101879:	81 7d f4 54 fd 10 80 	cmpl   $0x8010fd54,-0xc(%ebp)
80101880:	72 9e                	jb     80101820 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101882:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101886:	75 0c                	jne    80101894 <iget+0x96>
    panic("iget: no inodes");
80101888:	c7 04 24 14 83 10 80 	movl   $0x80108314,(%esp)
8010188f:	e8 a2 ec ff ff       	call   80100536 <panic>

  ip = empty;
80101894:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101897:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010189a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010189d:	8b 55 08             	mov    0x8(%ebp),%edx
801018a0:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a5:	8b 55 0c             	mov    0xc(%ebp),%edx
801018a8:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ae:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801018bf:	c7 04 24 80 ed 10 80 	movl   $0x8010ed80,(%esp)
801018c6:	e8 e6 33 00 00       	call   80104cb1 <release>

  return ip;
801018cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801018ce:	c9                   	leave  
801018cf:	c3                   	ret    

801018d0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
801018d6:	c7 04 24 80 ed 10 80 	movl   $0x8010ed80,(%esp)
801018dd:	e8 6d 33 00 00       	call   80104c4f <acquire>
  ip->ref++;
801018e2:	8b 45 08             	mov    0x8(%ebp),%eax
801018e5:	8b 40 08             	mov    0x8(%eax),%eax
801018e8:	8d 50 01             	lea    0x1(%eax),%edx
801018eb:	8b 45 08             	mov    0x8(%ebp),%eax
801018ee:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018f1:	c7 04 24 80 ed 10 80 	movl   $0x8010ed80,(%esp)
801018f8:	e8 b4 33 00 00       	call   80104cb1 <release>
  return ip;
801018fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101900:	c9                   	leave  
80101901:	c3                   	ret    

80101902 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101902:	55                   	push   %ebp
80101903:	89 e5                	mov    %esp,%ebp
80101905:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101908:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010190c:	74 0a                	je     80101918 <ilock+0x16>
8010190e:	8b 45 08             	mov    0x8(%ebp),%eax
80101911:	8b 40 08             	mov    0x8(%eax),%eax
80101914:	85 c0                	test   %eax,%eax
80101916:	7f 0c                	jg     80101924 <ilock+0x22>
    panic("ilock");
80101918:	c7 04 24 24 83 10 80 	movl   $0x80108324,(%esp)
8010191f:	e8 12 ec ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
80101924:	c7 04 24 80 ed 10 80 	movl   $0x8010ed80,(%esp)
8010192b:	e8 1f 33 00 00       	call   80104c4f <acquire>
  while(ip->flags & I_BUSY)
80101930:	eb 13                	jmp    80101945 <ilock+0x43>
    sleep(ip, &icache.lock);
80101932:	c7 44 24 04 80 ed 10 	movl   $0x8010ed80,0x4(%esp)
80101939:	80 
8010193a:	8b 45 08             	mov    0x8(%ebp),%eax
8010193d:	89 04 24             	mov    %eax,(%esp)
80101940:	e8 2e 30 00 00       	call   80104973 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101945:	8b 45 08             	mov    0x8(%ebp),%eax
80101948:	8b 40 0c             	mov    0xc(%eax),%eax
8010194b:	83 e0 01             	and    $0x1,%eax
8010194e:	85 c0                	test   %eax,%eax
80101950:	75 e0                	jne    80101932 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101952:	8b 45 08             	mov    0x8(%ebp),%eax
80101955:	8b 40 0c             	mov    0xc(%eax),%eax
80101958:	89 c2                	mov    %eax,%edx
8010195a:	83 ca 01             	or     $0x1,%edx
8010195d:	8b 45 08             	mov    0x8(%ebp),%eax
80101960:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101963:	c7 04 24 80 ed 10 80 	movl   $0x8010ed80,(%esp)
8010196a:	e8 42 33 00 00       	call   80104cb1 <release>

  if(!(ip->flags & I_VALID)){
8010196f:	8b 45 08             	mov    0x8(%ebp),%eax
80101972:	8b 40 0c             	mov    0xc(%eax),%eax
80101975:	83 e0 02             	and    $0x2,%eax
80101978:	85 c0                	test   %eax,%eax
8010197a:	0f 85 cb 00 00 00    	jne    80101a4b <ilock+0x149>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101980:	8b 45 08             	mov    0x8(%ebp),%eax
80101983:	8b 40 04             	mov    0x4(%eax),%eax
80101986:	c1 e8 03             	shr    $0x3,%eax
80101989:	8d 50 02             	lea    0x2(%eax),%edx
8010198c:	8b 45 08             	mov    0x8(%ebp),%eax
8010198f:	8b 00                	mov    (%eax),%eax
80101991:	89 54 24 04          	mov    %edx,0x4(%esp)
80101995:	89 04 24             	mov    %eax,(%esp)
80101998:	e8 09 e8 ff ff       	call   801001a6 <bread>
8010199d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a3:	8d 50 18             	lea    0x18(%eax),%edx
801019a6:	8b 45 08             	mov    0x8(%ebp),%eax
801019a9:	8b 40 04             	mov    0x4(%eax),%eax
801019ac:	83 e0 07             	and    $0x7,%eax
801019af:	c1 e0 06             	shl    $0x6,%eax
801019b2:	01 d0                	add    %edx,%eax
801019b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ba:	8b 00                	mov    (%eax),%eax
801019bc:	8b 55 08             	mov    0x8(%ebp),%edx
801019bf:	66 89 42 10          	mov    %ax,0x10(%edx)
    ip->major = dip->major;
801019c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019c6:	66 8b 40 02          	mov    0x2(%eax),%ax
801019ca:	8b 55 08             	mov    0x8(%ebp),%edx
801019cd:	66 89 42 12          	mov    %ax,0x12(%edx)
    ip->minor = dip->minor;
801019d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019d4:	8b 40 04             	mov    0x4(%eax),%eax
801019d7:	8b 55 08             	mov    0x8(%ebp),%edx
801019da:	66 89 42 14          	mov    %ax,0x14(%edx)
    ip->nlink = dip->nlink;
801019de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019e1:	66 8b 40 06          	mov    0x6(%eax),%ax
801019e5:	8b 55 08             	mov    0x8(%ebp),%edx
801019e8:	66 89 42 16          	mov    %ax,0x16(%edx)
    ip->size = dip->size;
801019ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ef:	8b 50 08             	mov    0x8(%eax),%edx
801019f2:	8b 45 08             	mov    0x8(%ebp),%eax
801019f5:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019fb:	8d 50 0c             	lea    0xc(%eax),%edx
801019fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101a01:	83 c0 1c             	add    $0x1c,%eax
80101a04:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101a0b:	00 
80101a0c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a10:	89 04 24             	mov    %eax,(%esp)
80101a13:	e8 56 35 00 00       	call   80104f6e <memmove>
    brelse(bp);
80101a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a1b:	89 04 24             	mov    %eax,(%esp)
80101a1e:	e8 f4 e7 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
80101a23:	8b 45 08             	mov    0x8(%ebp),%eax
80101a26:	8b 40 0c             	mov    0xc(%eax),%eax
80101a29:	89 c2                	mov    %eax,%edx
80101a2b:	83 ca 02             	or     $0x2,%edx
80101a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a31:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a34:	8b 45 08             	mov    0x8(%ebp),%eax
80101a37:	8b 40 10             	mov    0x10(%eax),%eax
80101a3a:	66 85 c0             	test   %ax,%ax
80101a3d:	75 0c                	jne    80101a4b <ilock+0x149>
      panic("ilock: no type");
80101a3f:	c7 04 24 2a 83 10 80 	movl   $0x8010832a,(%esp)
80101a46:	e8 eb ea ff ff       	call   80100536 <panic>
  }
}
80101a4b:	c9                   	leave  
80101a4c:	c3                   	ret    

80101a4d <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a4d:	55                   	push   %ebp
80101a4e:	89 e5                	mov    %esp,%ebp
80101a50:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a57:	74 17                	je     80101a70 <iunlock+0x23>
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 40 0c             	mov    0xc(%eax),%eax
80101a5f:	83 e0 01             	and    $0x1,%eax
80101a62:	85 c0                	test   %eax,%eax
80101a64:	74 0a                	je     80101a70 <iunlock+0x23>
80101a66:	8b 45 08             	mov    0x8(%ebp),%eax
80101a69:	8b 40 08             	mov    0x8(%eax),%eax
80101a6c:	85 c0                	test   %eax,%eax
80101a6e:	7f 0c                	jg     80101a7c <iunlock+0x2f>
    panic("iunlock");
80101a70:	c7 04 24 39 83 10 80 	movl   $0x80108339,(%esp)
80101a77:	e8 ba ea ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
80101a7c:	c7 04 24 80 ed 10 80 	movl   $0x8010ed80,(%esp)
80101a83:	e8 c7 31 00 00       	call   80104c4f <acquire>
  ip->flags &= ~I_BUSY;
80101a88:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8b:	8b 40 0c             	mov    0xc(%eax),%eax
80101a8e:	89 c2                	mov    %eax,%edx
80101a90:	83 e2 fe             	and    $0xfffffffe,%edx
80101a93:	8b 45 08             	mov    0x8(%ebp),%eax
80101a96:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	89 04 24             	mov    %eax,(%esp)
80101a9f:	e8 a8 2f 00 00       	call   80104a4c <wakeup>
  release(&icache.lock);
80101aa4:	c7 04 24 80 ed 10 80 	movl   $0x8010ed80,(%esp)
80101aab:	e8 01 32 00 00       	call   80104cb1 <release>
}
80101ab0:	c9                   	leave  
80101ab1:	c3                   	ret    

80101ab2 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101ab2:	55                   	push   %ebp
80101ab3:	89 e5                	mov    %esp,%ebp
80101ab5:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101ab8:	c7 04 24 80 ed 10 80 	movl   $0x8010ed80,(%esp)
80101abf:	e8 8b 31 00 00       	call   80104c4f <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac7:	8b 40 08             	mov    0x8(%eax),%eax
80101aca:	83 f8 01             	cmp    $0x1,%eax
80101acd:	0f 85 93 00 00 00    	jne    80101b66 <iput+0xb4>
80101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad6:	8b 40 0c             	mov    0xc(%eax),%eax
80101ad9:	83 e0 02             	and    $0x2,%eax
80101adc:	85 c0                	test   %eax,%eax
80101ade:	0f 84 82 00 00 00    	je     80101b66 <iput+0xb4>
80101ae4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae7:	66 8b 40 16          	mov    0x16(%eax),%ax
80101aeb:	66 85 c0             	test   %ax,%ax
80101aee:	75 76                	jne    80101b66 <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101af0:	8b 45 08             	mov    0x8(%ebp),%eax
80101af3:	8b 40 0c             	mov    0xc(%eax),%eax
80101af6:	83 e0 01             	and    $0x1,%eax
80101af9:	85 c0                	test   %eax,%eax
80101afb:	74 0c                	je     80101b09 <iput+0x57>
      panic("iput busy");
80101afd:	c7 04 24 41 83 10 80 	movl   $0x80108341,(%esp)
80101b04:	e8 2d ea ff ff       	call   80100536 <panic>
    ip->flags |= I_BUSY;
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0c:	8b 40 0c             	mov    0xc(%eax),%eax
80101b0f:	89 c2                	mov    %eax,%edx
80101b11:	83 ca 01             	or     $0x1,%edx
80101b14:	8b 45 08             	mov    0x8(%ebp),%eax
80101b17:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b1a:	c7 04 24 80 ed 10 80 	movl   $0x8010ed80,(%esp)
80101b21:	e8 8b 31 00 00       	call   80104cb1 <release>
    itrunc(ip);
80101b26:	8b 45 08             	mov    0x8(%ebp),%eax
80101b29:	89 04 24             	mov    %eax,(%esp)
80101b2c:	e8 7d 01 00 00       	call   80101cae <itrunc>
    ip->type = 0;
80101b31:	8b 45 08             	mov    0x8(%ebp),%eax
80101b34:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3d:	89 04 24             	mov    %eax,(%esp)
80101b40:	e8 03 fc ff ff       	call   80101748 <iupdate>
    acquire(&icache.lock);
80101b45:	c7 04 24 80 ed 10 80 	movl   $0x8010ed80,(%esp)
80101b4c:	e8 fe 30 00 00       	call   80104c4f <acquire>
    ip->flags = 0;
80101b51:	8b 45 08             	mov    0x8(%ebp),%eax
80101b54:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5e:	89 04 24             	mov    %eax,(%esp)
80101b61:	e8 e6 2e 00 00       	call   80104a4c <wakeup>
  }
  ip->ref--;
80101b66:	8b 45 08             	mov    0x8(%ebp),%eax
80101b69:	8b 40 08             	mov    0x8(%eax),%eax
80101b6c:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b72:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b75:	c7 04 24 80 ed 10 80 	movl   $0x8010ed80,(%esp)
80101b7c:	e8 30 31 00 00       	call   80104cb1 <release>
}
80101b81:	c9                   	leave  
80101b82:	c3                   	ret    

80101b83 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b83:	55                   	push   %ebp
80101b84:	89 e5                	mov    %esp,%ebp
80101b86:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b89:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8c:	89 04 24             	mov    %eax,(%esp)
80101b8f:	e8 b9 fe ff ff       	call   80101a4d <iunlock>
  iput(ip);
80101b94:	8b 45 08             	mov    0x8(%ebp),%eax
80101b97:	89 04 24             	mov    %eax,(%esp)
80101b9a:	e8 13 ff ff ff       	call   80101ab2 <iput>
}
80101b9f:	c9                   	leave  
80101ba0:	c3                   	ret    

80101ba1 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ba1:	55                   	push   %ebp
80101ba2:	89 e5                	mov    %esp,%ebp
80101ba4:	53                   	push   %ebx
80101ba5:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101ba8:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101bac:	77 3e                	ja     80101bec <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101bae:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bb4:	83 c2 04             	add    $0x4,%edx
80101bb7:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101bbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bc2:	75 20                	jne    80101be4 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101bc4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc7:	8b 00                	mov    (%eax),%eax
80101bc9:	89 04 24             	mov    %eax,(%esp)
80101bcc:	e8 5a f8 ff ff       	call   8010142b <balloc>
80101bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd7:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bda:	8d 4a 04             	lea    0x4(%edx),%ecx
80101bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101be0:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101be7:	e9 bc 00 00 00       	jmp    80101ca8 <bmap+0x107>
  }
  bn -= NDIRECT;
80101bec:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101bf0:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101bf4:	0f 87 a2 00 00 00    	ja     80101c9c <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfd:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c07:	75 19                	jne    80101c22 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c09:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0c:	8b 00                	mov    (%eax),%eax
80101c0e:	89 04 24             	mov    %eax,(%esp)
80101c11:	e8 15 f8 ff ff       	call   8010142b <balloc>
80101c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c19:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c1f:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c22:	8b 45 08             	mov    0x8(%ebp),%eax
80101c25:	8b 00                	mov    (%eax),%eax
80101c27:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c2a:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c2e:	89 04 24             	mov    %eax,(%esp)
80101c31:	e8 70 e5 ff ff       	call   801001a6 <bread>
80101c36:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c3c:	83 c0 18             	add    $0x18,%eax
80101c3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c45:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c4f:	01 d0                	add    %edx,%eax
80101c51:	8b 00                	mov    (%eax),%eax
80101c53:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c5a:	75 30                	jne    80101c8c <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c66:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c69:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6f:	8b 00                	mov    (%eax),%eax
80101c71:	89 04 24             	mov    %eax,(%esp)
80101c74:	e8 b2 f7 ff ff       	call   8010142b <balloc>
80101c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c7f:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c84:	89 04 24             	mov    %eax,(%esp)
80101c87:	e8 a4 16 00 00       	call   80103330 <log_write>
    }
    brelse(bp);
80101c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c8f:	89 04 24             	mov    %eax,(%esp)
80101c92:	e8 80 e5 ff ff       	call   80100217 <brelse>
    return addr;
80101c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c9a:	eb 0c                	jmp    80101ca8 <bmap+0x107>
  }

  panic("bmap: out of range");
80101c9c:	c7 04 24 4b 83 10 80 	movl   $0x8010834b,(%esp)
80101ca3:	e8 8e e8 ff ff       	call   80100536 <panic>
}
80101ca8:	83 c4 24             	add    $0x24,%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5d                   	pop    %ebp
80101cad:	c3                   	ret    

80101cae <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101cae:	55                   	push   %ebp
80101caf:	89 e5                	mov    %esp,%ebp
80101cb1:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101cbb:	eb 43                	jmp    80101d00 <itrunc+0x52>
    if(ip->addrs[i]){
80101cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cc3:	83 c2 04             	add    $0x4,%edx
80101cc6:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cca:	85 c0                	test   %eax,%eax
80101ccc:	74 2f                	je     80101cfd <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101cce:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cd4:	83 c2 04             	add    $0x4,%edx
80101cd7:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101cdb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cde:	8b 00                	mov    (%eax),%eax
80101ce0:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ce4:	89 04 24             	mov    %eax,(%esp)
80101ce7:	e8 90 f8 ff ff       	call   8010157c <bfree>
      ip->addrs[i] = 0;
80101cec:	8b 45 08             	mov    0x8(%ebp),%eax
80101cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cf2:	83 c2 04             	add    $0x4,%edx
80101cf5:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101cfc:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cfd:	ff 45 f4             	incl   -0xc(%ebp)
80101d00:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d04:	7e b7                	jle    80101cbd <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d06:	8b 45 08             	mov    0x8(%ebp),%eax
80101d09:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d0c:	85 c0                	test   %eax,%eax
80101d0e:	0f 84 9a 00 00 00    	je     80101dae <itrunc+0x100>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d14:	8b 45 08             	mov    0x8(%ebp),%eax
80101d17:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1d:	8b 00                	mov    (%eax),%eax
80101d1f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d23:	89 04 24             	mov    %eax,(%esp)
80101d26:	e8 7b e4 ff ff       	call   801001a6 <bread>
80101d2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d31:	83 c0 18             	add    $0x18,%eax
80101d34:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d37:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d3e:	eb 3a                	jmp    80101d7a <itrunc+0xcc>
      if(a[j])
80101d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d4d:	01 d0                	add    %edx,%eax
80101d4f:	8b 00                	mov    (%eax),%eax
80101d51:	85 c0                	test   %eax,%eax
80101d53:	74 22                	je     80101d77 <itrunc+0xc9>
        bfree(ip->dev, a[j]);
80101d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d62:	01 d0                	add    %edx,%eax
80101d64:	8b 10                	mov    (%eax),%edx
80101d66:	8b 45 08             	mov    0x8(%ebp),%eax
80101d69:	8b 00                	mov    (%eax),%eax
80101d6b:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d6f:	89 04 24             	mov    %eax,(%esp)
80101d72:	e8 05 f8 ff ff       	call   8010157c <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d77:	ff 45 f0             	incl   -0x10(%ebp)
80101d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d7d:	83 f8 7f             	cmp    $0x7f,%eax
80101d80:	76 be                	jbe    80101d40 <itrunc+0x92>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d85:	89 04 24             	mov    %eax,(%esp)
80101d88:	e8 8a e4 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d90:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d93:	8b 45 08             	mov    0x8(%ebp),%eax
80101d96:	8b 00                	mov    (%eax),%eax
80101d98:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d9c:	89 04 24             	mov    %eax,(%esp)
80101d9f:	e8 d8 f7 ff ff       	call   8010157c <bfree>
    ip->addrs[NDIRECT] = 0;
80101da4:	8b 45 08             	mov    0x8(%ebp),%eax
80101da7:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101dae:	8b 45 08             	mov    0x8(%ebp),%eax
80101db1:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101db8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbb:	89 04 24             	mov    %eax,(%esp)
80101dbe:	e8 85 f9 ff ff       	call   80101748 <iupdate>
}
80101dc3:	c9                   	leave  
80101dc4:	c3                   	ret    

80101dc5 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101dc5:	55                   	push   %ebp
80101dc6:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101dc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcb:	8b 00                	mov    (%eax),%eax
80101dcd:	89 c2                	mov    %eax,%edx
80101dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dd2:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101dd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd8:	8b 50 04             	mov    0x4(%eax),%edx
80101ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dde:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101de1:	8b 45 08             	mov    0x8(%ebp),%eax
80101de4:	8b 40 10             	mov    0x10(%eax),%eax
80101de7:	8b 55 0c             	mov    0xc(%ebp),%edx
80101dea:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80101ded:	8b 45 08             	mov    0x8(%ebp),%eax
80101df0:	66 8b 40 16          	mov    0x16(%eax),%ax
80101df4:	8b 55 0c             	mov    0xc(%ebp),%edx
80101df7:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80101dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfe:	8b 50 18             	mov    0x18(%eax),%edx
80101e01:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e04:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e07:	5d                   	pop    %ebp
80101e08:	c3                   	ret    

80101e09 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e09:	55                   	push   %ebp
80101e0a:	89 e5                	mov    %esp,%ebp
80101e0c:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e12:	8b 40 10             	mov    0x10(%eax),%eax
80101e15:	66 83 f8 03          	cmp    $0x3,%ax
80101e19:	75 60                	jne    80101e7b <readi+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1e:	66 8b 40 12          	mov    0x12(%eax),%ax
80101e22:	66 85 c0             	test   %ax,%ax
80101e25:	78 20                	js     80101e47 <readi+0x3e>
80101e27:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2a:	66 8b 40 12          	mov    0x12(%eax),%ax
80101e2e:	66 83 f8 09          	cmp    $0x9,%ax
80101e32:	7f 13                	jg     80101e47 <readi+0x3e>
80101e34:	8b 45 08             	mov    0x8(%ebp),%eax
80101e37:	66 8b 40 12          	mov    0x12(%eax),%ax
80101e3b:	98                   	cwtl   
80101e3c:	8b 04 c5 20 ed 10 80 	mov    -0x7fef12e0(,%eax,8),%eax
80101e43:	85 c0                	test   %eax,%eax
80101e45:	75 0a                	jne    80101e51 <readi+0x48>
      return -1;
80101e47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e4c:	e9 1b 01 00 00       	jmp    80101f6c <readi+0x163>
    return devsw[ip->major].read(ip, dst, n);
80101e51:	8b 45 08             	mov    0x8(%ebp),%eax
80101e54:	66 8b 40 12          	mov    0x12(%eax),%ax
80101e58:	98                   	cwtl   
80101e59:	8b 04 c5 20 ed 10 80 	mov    -0x7fef12e0(,%eax,8),%eax
80101e60:	8b 55 14             	mov    0x14(%ebp),%edx
80101e63:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e67:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e6a:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e6e:	8b 55 08             	mov    0x8(%ebp),%edx
80101e71:	89 14 24             	mov    %edx,(%esp)
80101e74:	ff d0                	call   *%eax
80101e76:	e9 f1 00 00 00       	jmp    80101f6c <readi+0x163>
  }

  if(off > ip->size || off + n < off)
80101e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7e:	8b 40 18             	mov    0x18(%eax),%eax
80101e81:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e84:	72 0d                	jb     80101e93 <readi+0x8a>
80101e86:	8b 45 14             	mov    0x14(%ebp),%eax
80101e89:	8b 55 10             	mov    0x10(%ebp),%edx
80101e8c:	01 d0                	add    %edx,%eax
80101e8e:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e91:	73 0a                	jae    80101e9d <readi+0x94>
    return -1;
80101e93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e98:	e9 cf 00 00 00       	jmp    80101f6c <readi+0x163>
  if(off + n > ip->size)
80101e9d:	8b 45 14             	mov    0x14(%ebp),%eax
80101ea0:	8b 55 10             	mov    0x10(%ebp),%edx
80101ea3:	01 c2                	add    %eax,%edx
80101ea5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea8:	8b 40 18             	mov    0x18(%eax),%eax
80101eab:	39 c2                	cmp    %eax,%edx
80101ead:	76 0c                	jbe    80101ebb <readi+0xb2>
    n = ip->size - off;
80101eaf:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb2:	8b 40 18             	mov    0x18(%eax),%eax
80101eb5:	2b 45 10             	sub    0x10(%ebp),%eax
80101eb8:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ebb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ec2:	e9 96 00 00 00       	jmp    80101f5d <readi+0x154>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ec7:	8b 45 10             	mov    0x10(%ebp),%eax
80101eca:	c1 e8 09             	shr    $0x9,%eax
80101ecd:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ed1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed4:	89 04 24             	mov    %eax,(%esp)
80101ed7:	e8 c5 fc ff ff       	call   80101ba1 <bmap>
80101edc:	8b 55 08             	mov    0x8(%ebp),%edx
80101edf:	8b 12                	mov    (%edx),%edx
80101ee1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ee5:	89 14 24             	mov    %edx,(%esp)
80101ee8:	e8 b9 e2 ff ff       	call   801001a6 <bread>
80101eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ef0:	8b 45 10             	mov    0x10(%ebp),%eax
80101ef3:	89 c2                	mov    %eax,%edx
80101ef5:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101efb:	b8 00 02 00 00       	mov    $0x200,%eax
80101f00:	89 c1                	mov    %eax,%ecx
80101f02:	29 d1                	sub    %edx,%ecx
80101f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f07:	8b 55 14             	mov    0x14(%ebp),%edx
80101f0a:	29 c2                	sub    %eax,%edx
80101f0c:	89 c8                	mov    %ecx,%eax
80101f0e:	39 d0                	cmp    %edx,%eax
80101f10:	76 02                	jbe    80101f14 <readi+0x10b>
80101f12:	89 d0                	mov    %edx,%eax
80101f14:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f17:	8b 45 10             	mov    0x10(%ebp),%eax
80101f1a:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f1f:	8d 50 10             	lea    0x10(%eax),%edx
80101f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f25:	01 d0                	add    %edx,%eax
80101f27:	8d 50 08             	lea    0x8(%eax),%edx
80101f2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f2d:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f31:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f35:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f38:	89 04 24             	mov    %eax,(%esp)
80101f3b:	e8 2e 30 00 00       	call   80104f6e <memmove>
    brelse(bp);
80101f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f43:	89 04 24             	mov    %eax,(%esp)
80101f46:	e8 cc e2 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f4e:	01 45 f4             	add    %eax,-0xc(%ebp)
80101f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f54:	01 45 10             	add    %eax,0x10(%ebp)
80101f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f5a:	01 45 0c             	add    %eax,0xc(%ebp)
80101f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f60:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f63:	0f 82 5e ff ff ff    	jb     80101ec7 <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f69:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f6c:	c9                   	leave  
80101f6d:	c3                   	ret    

80101f6e <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f6e:	55                   	push   %ebp
80101f6f:	89 e5                	mov    %esp,%ebp
80101f71:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f74:	8b 45 08             	mov    0x8(%ebp),%eax
80101f77:	8b 40 10             	mov    0x10(%eax),%eax
80101f7a:	66 83 f8 03          	cmp    $0x3,%ax
80101f7e:	75 60                	jne    80101fe0 <writei+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f80:	8b 45 08             	mov    0x8(%ebp),%eax
80101f83:	66 8b 40 12          	mov    0x12(%eax),%ax
80101f87:	66 85 c0             	test   %ax,%ax
80101f8a:	78 20                	js     80101fac <writei+0x3e>
80101f8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8f:	66 8b 40 12          	mov    0x12(%eax),%ax
80101f93:	66 83 f8 09          	cmp    $0x9,%ax
80101f97:	7f 13                	jg     80101fac <writei+0x3e>
80101f99:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9c:	66 8b 40 12          	mov    0x12(%eax),%ax
80101fa0:	98                   	cwtl   
80101fa1:	8b 04 c5 24 ed 10 80 	mov    -0x7fef12dc(,%eax,8),%eax
80101fa8:	85 c0                	test   %eax,%eax
80101faa:	75 0a                	jne    80101fb6 <writei+0x48>
      return -1;
80101fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fb1:	e9 46 01 00 00       	jmp    801020fc <writei+0x18e>
    return devsw[ip->major].write(ip, src, n);
80101fb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb9:	66 8b 40 12          	mov    0x12(%eax),%ax
80101fbd:	98                   	cwtl   
80101fbe:	8b 04 c5 24 ed 10 80 	mov    -0x7fef12dc(,%eax,8),%eax
80101fc5:	8b 55 14             	mov    0x14(%ebp),%edx
80101fc8:	89 54 24 08          	mov    %edx,0x8(%esp)
80101fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fcf:	89 54 24 04          	mov    %edx,0x4(%esp)
80101fd3:	8b 55 08             	mov    0x8(%ebp),%edx
80101fd6:	89 14 24             	mov    %edx,(%esp)
80101fd9:	ff d0                	call   *%eax
80101fdb:	e9 1c 01 00 00       	jmp    801020fc <writei+0x18e>
  }

  if(off > ip->size || off + n < off)
80101fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe3:	8b 40 18             	mov    0x18(%eax),%eax
80101fe6:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fe9:	72 0d                	jb     80101ff8 <writei+0x8a>
80101feb:	8b 45 14             	mov    0x14(%ebp),%eax
80101fee:	8b 55 10             	mov    0x10(%ebp),%edx
80101ff1:	01 d0                	add    %edx,%eax
80101ff3:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ff6:	73 0a                	jae    80102002 <writei+0x94>
    return -1;
80101ff8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ffd:	e9 fa 00 00 00       	jmp    801020fc <writei+0x18e>
  if(off + n > MAXFILE*BSIZE)
80102002:	8b 45 14             	mov    0x14(%ebp),%eax
80102005:	8b 55 10             	mov    0x10(%ebp),%edx
80102008:	01 d0                	add    %edx,%eax
8010200a:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010200f:	76 0a                	jbe    8010201b <writei+0xad>
    return -1;
80102011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102016:	e9 e1 00 00 00       	jmp    801020fc <writei+0x18e>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010201b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102022:	e9 a1 00 00 00       	jmp    801020c8 <writei+0x15a>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102027:	8b 45 10             	mov    0x10(%ebp),%eax
8010202a:	c1 e8 09             	shr    $0x9,%eax
8010202d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102031:	8b 45 08             	mov    0x8(%ebp),%eax
80102034:	89 04 24             	mov    %eax,(%esp)
80102037:	e8 65 fb ff ff       	call   80101ba1 <bmap>
8010203c:	8b 55 08             	mov    0x8(%ebp),%edx
8010203f:	8b 12                	mov    (%edx),%edx
80102041:	89 44 24 04          	mov    %eax,0x4(%esp)
80102045:	89 14 24             	mov    %edx,(%esp)
80102048:	e8 59 e1 ff ff       	call   801001a6 <bread>
8010204d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102050:	8b 45 10             	mov    0x10(%ebp),%eax
80102053:	89 c2                	mov    %eax,%edx
80102055:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010205b:	b8 00 02 00 00       	mov    $0x200,%eax
80102060:	89 c1                	mov    %eax,%ecx
80102062:	29 d1                	sub    %edx,%ecx
80102064:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102067:	8b 55 14             	mov    0x14(%ebp),%edx
8010206a:	29 c2                	sub    %eax,%edx
8010206c:	89 c8                	mov    %ecx,%eax
8010206e:	39 d0                	cmp    %edx,%eax
80102070:	76 02                	jbe    80102074 <writei+0x106>
80102072:	89 d0                	mov    %edx,%eax
80102074:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102077:	8b 45 10             	mov    0x10(%ebp),%eax
8010207a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010207f:	8d 50 10             	lea    0x10(%eax),%edx
80102082:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102085:	01 d0                	add    %edx,%eax
80102087:	8d 50 08             	lea    0x8(%eax),%edx
8010208a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010208d:	89 44 24 08          	mov    %eax,0x8(%esp)
80102091:	8b 45 0c             	mov    0xc(%ebp),%eax
80102094:	89 44 24 04          	mov    %eax,0x4(%esp)
80102098:	89 14 24             	mov    %edx,(%esp)
8010209b:	e8 ce 2e 00 00       	call   80104f6e <memmove>
    log_write(bp);
801020a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020a3:	89 04 24             	mov    %eax,(%esp)
801020a6:	e8 85 12 00 00       	call   80103330 <log_write>
    brelse(bp);
801020ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020ae:	89 04 24             	mov    %eax,(%esp)
801020b1:	e8 61 e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020b9:	01 45 f4             	add    %eax,-0xc(%ebp)
801020bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020bf:	01 45 10             	add    %eax,0x10(%ebp)
801020c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020c5:	01 45 0c             	add    %eax,0xc(%ebp)
801020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020cb:	3b 45 14             	cmp    0x14(%ebp),%eax
801020ce:	0f 82 53 ff ff ff    	jb     80102027 <writei+0xb9>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801020d4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801020d8:	74 1f                	je     801020f9 <writei+0x18b>
801020da:	8b 45 08             	mov    0x8(%ebp),%eax
801020dd:	8b 40 18             	mov    0x18(%eax),%eax
801020e0:	3b 45 10             	cmp    0x10(%ebp),%eax
801020e3:	73 14                	jae    801020f9 <writei+0x18b>
    ip->size = off;
801020e5:	8b 45 08             	mov    0x8(%ebp),%eax
801020e8:	8b 55 10             	mov    0x10(%ebp),%edx
801020eb:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801020ee:	8b 45 08             	mov    0x8(%ebp),%eax
801020f1:	89 04 24             	mov    %eax,(%esp)
801020f4:	e8 4f f6 ff ff       	call   80101748 <iupdate>
  }
  return n;
801020f9:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020fc:	c9                   	leave  
801020fd:	c3                   	ret    

801020fe <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020fe:	55                   	push   %ebp
801020ff:	89 e5                	mov    %esp,%ebp
80102101:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102104:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010210b:	00 
8010210c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010210f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102113:	8b 45 08             	mov    0x8(%ebp),%eax
80102116:	89 04 24             	mov    %eax,(%esp)
80102119:	e8 ec 2e 00 00       	call   8010500a <strncmp>
}
8010211e:	c9                   	leave  
8010211f:	c3                   	ret    

80102120 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102126:	8b 45 08             	mov    0x8(%ebp),%eax
80102129:	8b 40 10             	mov    0x10(%eax),%eax
8010212c:	66 83 f8 01          	cmp    $0x1,%ax
80102130:	74 0c                	je     8010213e <dirlookup+0x1e>
    panic("dirlookup not DIR");
80102132:	c7 04 24 5e 83 10 80 	movl   $0x8010835e,(%esp)
80102139:	e8 f8 e3 ff ff       	call   80100536 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010213e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102145:	e9 85 00 00 00       	jmp    801021cf <dirlookup+0xaf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010214a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102151:	00 
80102152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102155:	89 44 24 08          	mov    %eax,0x8(%esp)
80102159:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010215c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102160:	8b 45 08             	mov    0x8(%ebp),%eax
80102163:	89 04 24             	mov    %eax,(%esp)
80102166:	e8 9e fc ff ff       	call   80101e09 <readi>
8010216b:	83 f8 10             	cmp    $0x10,%eax
8010216e:	74 0c                	je     8010217c <dirlookup+0x5c>
      panic("dirlink read");
80102170:	c7 04 24 70 83 10 80 	movl   $0x80108370,(%esp)
80102177:	e8 ba e3 ff ff       	call   80100536 <panic>
    if(de.inum == 0)
8010217c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010217f:	66 85 c0             	test   %ax,%ax
80102182:	74 46                	je     801021ca <dirlookup+0xaa>
      continue;
    if(namecmp(name, de.name) == 0){
80102184:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102187:	83 c0 02             	add    $0x2,%eax
8010218a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010218e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102191:	89 04 24             	mov    %eax,(%esp)
80102194:	e8 65 ff ff ff       	call   801020fe <namecmp>
80102199:	85 c0                	test   %eax,%eax
8010219b:	75 2e                	jne    801021cb <dirlookup+0xab>
      // entry matches path element
      if(poff)
8010219d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021a1:	74 08                	je     801021ab <dirlookup+0x8b>
        *poff = off;
801021a3:	8b 45 10             	mov    0x10(%ebp),%eax
801021a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021a9:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801021ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801021ae:	0f b7 c0             	movzwl %ax,%eax
801021b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801021b4:	8b 45 08             	mov    0x8(%ebp),%eax
801021b7:	8b 00                	mov    (%eax),%eax
801021b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801021bc:	89 54 24 04          	mov    %edx,0x4(%esp)
801021c0:	89 04 24             	mov    %eax,(%esp)
801021c3:	e8 36 f6 ff ff       	call   801017fe <iget>
801021c8:	eb 19                	jmp    801021e3 <dirlookup+0xc3>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
801021ca:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021cb:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801021cf:	8b 45 08             	mov    0x8(%ebp),%eax
801021d2:	8b 40 18             	mov    0x18(%eax),%eax
801021d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801021d8:	0f 87 6c ff ff ff    	ja     8010214a <dirlookup+0x2a>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801021de:	b8 00 00 00 00       	mov    $0x0,%eax
}
801021e3:	c9                   	leave  
801021e4:	c3                   	ret    

801021e5 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021e5:	55                   	push   %ebp
801021e6:	89 e5                	mov    %esp,%ebp
801021e8:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801021f2:	00 
801021f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801021f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801021fa:	8b 45 08             	mov    0x8(%ebp),%eax
801021fd:	89 04 24             	mov    %eax,(%esp)
80102200:	e8 1b ff ff ff       	call   80102120 <dirlookup>
80102205:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102208:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010220c:	74 15                	je     80102223 <dirlink+0x3e>
    iput(ip);
8010220e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102211:	89 04 24             	mov    %eax,(%esp)
80102214:	e8 99 f8 ff ff       	call   80101ab2 <iput>
    return -1;
80102219:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010221e:	e9 b7 00 00 00       	jmp    801022da <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102223:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010222a:	eb 43                	jmp    8010226f <dirlink+0x8a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010222c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010222f:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102236:	00 
80102237:	89 44 24 08          	mov    %eax,0x8(%esp)
8010223b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010223e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102242:	8b 45 08             	mov    0x8(%ebp),%eax
80102245:	89 04 24             	mov    %eax,(%esp)
80102248:	e8 bc fb ff ff       	call   80101e09 <readi>
8010224d:	83 f8 10             	cmp    $0x10,%eax
80102250:	74 0c                	je     8010225e <dirlink+0x79>
      panic("dirlink read");
80102252:	c7 04 24 70 83 10 80 	movl   $0x80108370,(%esp)
80102259:	e8 d8 e2 ff ff       	call   80100536 <panic>
    if(de.inum == 0)
8010225e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102261:	66 85 c0             	test   %ax,%ax
80102264:	74 18                	je     8010227e <dirlink+0x99>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102266:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102269:	83 c0 10             	add    $0x10,%eax
8010226c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010226f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102272:	8b 45 08             	mov    0x8(%ebp),%eax
80102275:	8b 40 18             	mov    0x18(%eax),%eax
80102278:	39 c2                	cmp    %eax,%edx
8010227a:	72 b0                	jb     8010222c <dirlink+0x47>
8010227c:	eb 01                	jmp    8010227f <dirlink+0x9a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
8010227e:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
8010227f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102286:	00 
80102287:	8b 45 0c             	mov    0xc(%ebp),%eax
8010228a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010228e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102291:	83 c0 02             	add    $0x2,%eax
80102294:	89 04 24             	mov    %eax,(%esp)
80102297:	e8 be 2d 00 00       	call   8010505a <strncpy>
  de.inum = inum;
8010229c:	8b 45 10             	mov    0x10(%ebp),%eax
8010229f:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022a6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801022ad:	00 
801022ae:	89 44 24 08          	mov    %eax,0x8(%esp)
801022b2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801022b9:	8b 45 08             	mov    0x8(%ebp),%eax
801022bc:	89 04 24             	mov    %eax,(%esp)
801022bf:	e8 aa fc ff ff       	call   80101f6e <writei>
801022c4:	83 f8 10             	cmp    $0x10,%eax
801022c7:	74 0c                	je     801022d5 <dirlink+0xf0>
    panic("dirlink");
801022c9:	c7 04 24 7d 83 10 80 	movl   $0x8010837d,(%esp)
801022d0:	e8 61 e2 ff ff       	call   80100536 <panic>
  
  return 0;
801022d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022da:	c9                   	leave  
801022db:	c3                   	ret    

801022dc <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022dc:	55                   	push   %ebp
801022dd:	89 e5                	mov    %esp,%ebp
801022df:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
801022e2:	eb 03                	jmp    801022e7 <skipelem+0xb>
    path++;
801022e4:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801022e7:	8b 45 08             	mov    0x8(%ebp),%eax
801022ea:	8a 00                	mov    (%eax),%al
801022ec:	3c 2f                	cmp    $0x2f,%al
801022ee:	74 f4                	je     801022e4 <skipelem+0x8>
    path++;
  if(*path == 0)
801022f0:	8b 45 08             	mov    0x8(%ebp),%eax
801022f3:	8a 00                	mov    (%eax),%al
801022f5:	84 c0                	test   %al,%al
801022f7:	75 0a                	jne    80102303 <skipelem+0x27>
    return 0;
801022f9:	b8 00 00 00 00       	mov    $0x0,%eax
801022fe:	e9 83 00 00 00       	jmp    80102386 <skipelem+0xaa>
  s = path;
80102303:	8b 45 08             	mov    0x8(%ebp),%eax
80102306:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102309:	eb 03                	jmp    8010230e <skipelem+0x32>
    path++;
8010230b:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010230e:	8b 45 08             	mov    0x8(%ebp),%eax
80102311:	8a 00                	mov    (%eax),%al
80102313:	3c 2f                	cmp    $0x2f,%al
80102315:	74 09                	je     80102320 <skipelem+0x44>
80102317:	8b 45 08             	mov    0x8(%ebp),%eax
8010231a:	8a 00                	mov    (%eax),%al
8010231c:	84 c0                	test   %al,%al
8010231e:	75 eb                	jne    8010230b <skipelem+0x2f>
    path++;
  len = path - s;
80102320:	8b 55 08             	mov    0x8(%ebp),%edx
80102323:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102326:	89 d1                	mov    %edx,%ecx
80102328:	29 c1                	sub    %eax,%ecx
8010232a:	89 c8                	mov    %ecx,%eax
8010232c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010232f:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102333:	7e 1c                	jle    80102351 <skipelem+0x75>
    memmove(name, s, DIRSIZ);
80102335:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010233c:	00 
8010233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102340:	89 44 24 04          	mov    %eax,0x4(%esp)
80102344:	8b 45 0c             	mov    0xc(%ebp),%eax
80102347:	89 04 24             	mov    %eax,(%esp)
8010234a:	e8 1f 2c 00 00       	call   80104f6e <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010234f:	eb 29                	jmp    8010237a <skipelem+0x9e>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102351:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102354:	89 44 24 08          	mov    %eax,0x8(%esp)
80102358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010235b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010235f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102362:	89 04 24             	mov    %eax,(%esp)
80102365:	e8 04 2c 00 00       	call   80104f6e <memmove>
    name[len] = 0;
8010236a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010236d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102370:	01 d0                	add    %edx,%eax
80102372:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102375:	eb 03                	jmp    8010237a <skipelem+0x9e>
    path++;
80102377:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010237a:	8b 45 08             	mov    0x8(%ebp),%eax
8010237d:	8a 00                	mov    (%eax),%al
8010237f:	3c 2f                	cmp    $0x2f,%al
80102381:	74 f4                	je     80102377 <skipelem+0x9b>
    path++;
  return path;
80102383:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102386:	c9                   	leave  
80102387:	c3                   	ret    

80102388 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102388:	55                   	push   %ebp
80102389:	89 e5                	mov    %esp,%ebp
8010238b:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010238e:	8b 45 08             	mov    0x8(%ebp),%eax
80102391:	8a 00                	mov    (%eax),%al
80102393:	3c 2f                	cmp    $0x2f,%al
80102395:	75 1c                	jne    801023b3 <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
80102397:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010239e:	00 
8010239f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801023a6:	e8 53 f4 ff ff       	call   801017fe <iget>
801023ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023ae:	e9 ad 00 00 00       	jmp    80102460 <namex+0xd8>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
801023b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023b9:	8b 40 68             	mov    0x68(%eax),%eax
801023bc:	89 04 24             	mov    %eax,(%esp)
801023bf:	e8 0c f5 ff ff       	call   801018d0 <idup>
801023c4:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023c7:	e9 94 00 00 00       	jmp    80102460 <namex+0xd8>
    ilock(ip);
801023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023cf:	89 04 24             	mov    %eax,(%esp)
801023d2:	e8 2b f5 ff ff       	call   80101902 <ilock>
    if(ip->type != T_DIR){
801023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023da:	8b 40 10             	mov    0x10(%eax),%eax
801023dd:	66 83 f8 01          	cmp    $0x1,%ax
801023e1:	74 15                	je     801023f8 <namex+0x70>
      iunlockput(ip);
801023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023e6:	89 04 24             	mov    %eax,(%esp)
801023e9:	e8 95 f7 ff ff       	call   80101b83 <iunlockput>
      return 0;
801023ee:	b8 00 00 00 00       	mov    $0x0,%eax
801023f3:	e9 a2 00 00 00       	jmp    8010249a <namex+0x112>
    }
    if(nameiparent && *path == '\0'){
801023f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023fc:	74 1c                	je     8010241a <namex+0x92>
801023fe:	8b 45 08             	mov    0x8(%ebp),%eax
80102401:	8a 00                	mov    (%eax),%al
80102403:	84 c0                	test   %al,%al
80102405:	75 13                	jne    8010241a <namex+0x92>
      // Stop one level early.
      iunlock(ip);
80102407:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010240a:	89 04 24             	mov    %eax,(%esp)
8010240d:	e8 3b f6 ff ff       	call   80101a4d <iunlock>
      return ip;
80102412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102415:	e9 80 00 00 00       	jmp    8010249a <namex+0x112>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010241a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102421:	00 
80102422:	8b 45 10             	mov    0x10(%ebp),%eax
80102425:	89 44 24 04          	mov    %eax,0x4(%esp)
80102429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010242c:	89 04 24             	mov    %eax,(%esp)
8010242f:	e8 ec fc ff ff       	call   80102120 <dirlookup>
80102434:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102437:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010243b:	75 12                	jne    8010244f <namex+0xc7>
      iunlockput(ip);
8010243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102440:	89 04 24             	mov    %eax,(%esp)
80102443:	e8 3b f7 ff ff       	call   80101b83 <iunlockput>
      return 0;
80102448:	b8 00 00 00 00       	mov    $0x0,%eax
8010244d:	eb 4b                	jmp    8010249a <namex+0x112>
    }
    iunlockput(ip);
8010244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102452:	89 04 24             	mov    %eax,(%esp)
80102455:	e8 29 f7 ff ff       	call   80101b83 <iunlockput>
    ip = next;
8010245a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010245d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102460:	8b 45 10             	mov    0x10(%ebp),%eax
80102463:	89 44 24 04          	mov    %eax,0x4(%esp)
80102467:	8b 45 08             	mov    0x8(%ebp),%eax
8010246a:	89 04 24             	mov    %eax,(%esp)
8010246d:	e8 6a fe ff ff       	call   801022dc <skipelem>
80102472:	89 45 08             	mov    %eax,0x8(%ebp)
80102475:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102479:	0f 85 4d ff ff ff    	jne    801023cc <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010247f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102483:	74 12                	je     80102497 <namex+0x10f>
    iput(ip);
80102485:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102488:	89 04 24             	mov    %eax,(%esp)
8010248b:	e8 22 f6 ff ff       	call   80101ab2 <iput>
    return 0;
80102490:	b8 00 00 00 00       	mov    $0x0,%eax
80102495:	eb 03                	jmp    8010249a <namex+0x112>
  }
  return ip;
80102497:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010249a:	c9                   	leave  
8010249b:	c3                   	ret    

8010249c <namei>:

struct inode*
namei(char *path)
{
8010249c:	55                   	push   %ebp
8010249d:	89 e5                	mov    %esp,%ebp
8010249f:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024a2:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024a5:	89 44 24 08          	mov    %eax,0x8(%esp)
801024a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801024b0:	00 
801024b1:	8b 45 08             	mov    0x8(%ebp),%eax
801024b4:	89 04 24             	mov    %eax,(%esp)
801024b7:	e8 cc fe ff ff       	call   80102388 <namex>
}
801024bc:	c9                   	leave  
801024bd:	c3                   	ret    

801024be <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024be:	55                   	push   %ebp
801024bf:	89 e5                	mov    %esp,%ebp
801024c1:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
801024c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801024c7:	89 44 24 08          	mov    %eax,0x8(%esp)
801024cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801024d2:	00 
801024d3:	8b 45 08             	mov    0x8(%ebp),%eax
801024d6:	89 04 24             	mov    %eax,(%esp)
801024d9:	e8 aa fe ff ff       	call   80102388 <namex>
}
801024de:	c9                   	leave  
801024df:	c3                   	ret    

801024e0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
801024e4:	83 ec 14             	sub    $0x14,%esp
801024e7:	8b 45 08             	mov    0x8(%ebp),%eax
801024ea:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
801024f1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801024f5:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
801024f9:	ec                   	in     (%dx),%al
801024fa:	88 c3                	mov    %al,%bl
801024fc:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801024ff:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80102502:	83 c4 14             	add    $0x14,%esp
80102505:	5b                   	pop    %ebx
80102506:	5d                   	pop    %ebp
80102507:	c3                   	ret    

80102508 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102508:	55                   	push   %ebp
80102509:	89 e5                	mov    %esp,%ebp
8010250b:	57                   	push   %edi
8010250c:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010250d:	8b 55 08             	mov    0x8(%ebp),%edx
80102510:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102513:	8b 45 10             	mov    0x10(%ebp),%eax
80102516:	89 cb                	mov    %ecx,%ebx
80102518:	89 df                	mov    %ebx,%edi
8010251a:	89 c1                	mov    %eax,%ecx
8010251c:	fc                   	cld    
8010251d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010251f:	89 c8                	mov    %ecx,%eax
80102521:	89 fb                	mov    %edi,%ebx
80102523:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102526:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102529:	5b                   	pop    %ebx
8010252a:	5f                   	pop    %edi
8010252b:	5d                   	pop    %ebp
8010252c:	c3                   	ret    

8010252d <outb>:

static inline void
outb(ushort port, uchar data)
{
8010252d:	55                   	push   %ebp
8010252e:	89 e5                	mov    %esp,%ebp
80102530:	83 ec 08             	sub    $0x8,%esp
80102533:	8b 45 08             	mov    0x8(%ebp),%eax
80102536:	8b 55 0c             	mov    0xc(%ebp),%edx
80102539:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010253d:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102540:	8a 45 f8             	mov    -0x8(%ebp),%al
80102543:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102546:	ee                   	out    %al,(%dx)
}
80102547:	c9                   	leave  
80102548:	c3                   	ret    

80102549 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102549:	55                   	push   %ebp
8010254a:	89 e5                	mov    %esp,%ebp
8010254c:	56                   	push   %esi
8010254d:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010254e:	8b 55 08             	mov    0x8(%ebp),%edx
80102551:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102554:	8b 45 10             	mov    0x10(%ebp),%eax
80102557:	89 cb                	mov    %ecx,%ebx
80102559:	89 de                	mov    %ebx,%esi
8010255b:	89 c1                	mov    %eax,%ecx
8010255d:	fc                   	cld    
8010255e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102560:	89 c8                	mov    %ecx,%eax
80102562:	89 f3                	mov    %esi,%ebx
80102564:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102567:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010256a:	5b                   	pop    %ebx
8010256b:	5e                   	pop    %esi
8010256c:	5d                   	pop    %ebp
8010256d:	c3                   	ret    

8010256e <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010256e:	55                   	push   %ebp
8010256f:	89 e5                	mov    %esp,%ebp
80102571:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102574:	90                   	nop
80102575:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010257c:	e8 5f ff ff ff       	call   801024e0 <inb>
80102581:	0f b6 c0             	movzbl %al,%eax
80102584:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102587:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010258a:	25 c0 00 00 00       	and    $0xc0,%eax
8010258f:	83 f8 40             	cmp    $0x40,%eax
80102592:	75 e1                	jne    80102575 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102594:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102598:	74 11                	je     801025ab <idewait+0x3d>
8010259a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010259d:	83 e0 21             	and    $0x21,%eax
801025a0:	85 c0                	test   %eax,%eax
801025a2:	74 07                	je     801025ab <idewait+0x3d>
    return -1;
801025a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025a9:	eb 05                	jmp    801025b0 <idewait+0x42>
  return 0;
801025ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025b0:	c9                   	leave  
801025b1:	c3                   	ret    

801025b2 <ideinit>:

void
ideinit(void)
{
801025b2:	55                   	push   %ebp
801025b3:	89 e5                	mov    %esp,%ebp
801025b5:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
801025b8:	c7 44 24 04 85 83 10 	movl   $0x80108385,0x4(%esp)
801025bf:	80 
801025c0:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801025c7:	e8 62 26 00 00       	call   80104c2e <initlock>
  picenable(IRQ_IDE);
801025cc:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025d3:	e8 9c 15 00 00       	call   80103b74 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
801025d8:	a1 20 04 11 80       	mov    0x80110420,%eax
801025dd:	48                   	dec    %eax
801025de:	89 44 24 04          	mov    %eax,0x4(%esp)
801025e2:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025e9:	e8 0b 04 00 00       	call   801029f9 <ioapicenable>
  idewait(0);
801025ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025f5:	e8 74 ff ff ff       	call   8010256e <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025fa:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102601:	00 
80102602:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102609:	e8 1f ff ff ff       	call   8010252d <outb>
  for(i=0; i<1000; i++){
8010260e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102615:	eb 1f                	jmp    80102636 <ideinit+0x84>
    if(inb(0x1f7) != 0){
80102617:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010261e:	e8 bd fe ff ff       	call   801024e0 <inb>
80102623:	84 c0                	test   %al,%al
80102625:	74 0c                	je     80102633 <ideinit+0x81>
      havedisk1 = 1;
80102627:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
8010262e:	00 00 00 
      break;
80102631:	eb 0c                	jmp    8010263f <ideinit+0x8d>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102633:	ff 45 f4             	incl   -0xc(%ebp)
80102636:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010263d:	7e d8                	jle    80102617 <ideinit+0x65>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010263f:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102646:	00 
80102647:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010264e:	e8 da fe ff ff       	call   8010252d <outb>
}
80102653:	c9                   	leave  
80102654:	c3                   	ret    

80102655 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102655:	55                   	push   %ebp
80102656:	89 e5                	mov    %esp,%ebp
80102658:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010265b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010265f:	75 0c                	jne    8010266d <idestart+0x18>
    panic("idestart");
80102661:	c7 04 24 89 83 10 80 	movl   $0x80108389,(%esp)
80102668:	e8 c9 de ff ff       	call   80100536 <panic>

  idewait(0);
8010266d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102674:	e8 f5 fe ff ff       	call   8010256e <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102679:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102680:	00 
80102681:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102688:	e8 a0 fe ff ff       	call   8010252d <outb>
  outb(0x1f2, 1);  // number of sectors
8010268d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102694:	00 
80102695:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
8010269c:	e8 8c fe ff ff       	call   8010252d <outb>
  outb(0x1f3, b->sector & 0xff);
801026a1:	8b 45 08             	mov    0x8(%ebp),%eax
801026a4:	8b 40 08             	mov    0x8(%eax),%eax
801026a7:	0f b6 c0             	movzbl %al,%eax
801026aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801026ae:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
801026b5:	e8 73 fe ff ff       	call   8010252d <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
801026ba:	8b 45 08             	mov    0x8(%ebp),%eax
801026bd:	8b 40 08             	mov    0x8(%eax),%eax
801026c0:	c1 e8 08             	shr    $0x8,%eax
801026c3:	0f b6 c0             	movzbl %al,%eax
801026c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801026ca:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
801026d1:	e8 57 fe ff ff       	call   8010252d <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
801026d6:	8b 45 08             	mov    0x8(%ebp),%eax
801026d9:	8b 40 08             	mov    0x8(%eax),%eax
801026dc:	c1 e8 10             	shr    $0x10,%eax
801026df:	0f b6 c0             	movzbl %al,%eax
801026e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801026e6:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
801026ed:	e8 3b fe ff ff       	call   8010252d <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
801026f2:	8b 45 08             	mov    0x8(%ebp),%eax
801026f5:	8b 40 04             	mov    0x4(%eax),%eax
801026f8:	83 e0 01             	and    $0x1,%eax
801026fb:	88 c2                	mov    %al,%dl
801026fd:	c1 e2 04             	shl    $0x4,%edx
80102700:	8b 45 08             	mov    0x8(%ebp),%eax
80102703:	8b 40 08             	mov    0x8(%eax),%eax
80102706:	c1 e8 18             	shr    $0x18,%eax
80102709:	83 e0 0f             	and    $0xf,%eax
8010270c:	09 d0                	or     %edx,%eax
8010270e:	83 c8 e0             	or     $0xffffffe0,%eax
80102711:	0f b6 c0             	movzbl %al,%eax
80102714:	89 44 24 04          	mov    %eax,0x4(%esp)
80102718:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010271f:	e8 09 fe ff ff       	call   8010252d <outb>
  if(b->flags & B_DIRTY){
80102724:	8b 45 08             	mov    0x8(%ebp),%eax
80102727:	8b 00                	mov    (%eax),%eax
80102729:	83 e0 04             	and    $0x4,%eax
8010272c:	85 c0                	test   %eax,%eax
8010272e:	74 34                	je     80102764 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
80102730:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80102737:	00 
80102738:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010273f:	e8 e9 fd ff ff       	call   8010252d <outb>
    outsl(0x1f0, b->data, 512/4);
80102744:	8b 45 08             	mov    0x8(%ebp),%eax
80102747:	83 c0 18             	add    $0x18,%eax
8010274a:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102751:	00 
80102752:	89 44 24 04          	mov    %eax,0x4(%esp)
80102756:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010275d:	e8 e7 fd ff ff       	call   80102549 <outsl>
80102762:	eb 14                	jmp    80102778 <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102764:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
8010276b:	00 
8010276c:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102773:	e8 b5 fd ff ff       	call   8010252d <outb>
  }
}
80102778:	c9                   	leave  
80102779:	c3                   	ret    

8010277a <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010277a:	55                   	push   %ebp
8010277b:	89 e5                	mov    %esp,%ebp
8010277d:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102780:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102787:	e8 c3 24 00 00       	call   80104c4f <acquire>
  if((b = idequeue) == 0){
8010278c:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102791:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102794:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102798:	75 11                	jne    801027ab <ideintr+0x31>
    release(&idelock);
8010279a:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027a1:	e8 0b 25 00 00       	call   80104cb1 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
801027a6:	e9 90 00 00 00       	jmp    8010283b <ideintr+0xc1>
  }
  idequeue = b->qnext;
801027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ae:	8b 40 14             	mov    0x14(%eax),%eax
801027b1:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027b9:	8b 00                	mov    (%eax),%eax
801027bb:	83 e0 04             	and    $0x4,%eax
801027be:	85 c0                	test   %eax,%eax
801027c0:	75 2e                	jne    801027f0 <ideintr+0x76>
801027c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801027c9:	e8 a0 fd ff ff       	call   8010256e <idewait>
801027ce:	85 c0                	test   %eax,%eax
801027d0:	78 1e                	js     801027f0 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
801027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d5:	83 c0 18             	add    $0x18,%eax
801027d8:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801027df:	00 
801027e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801027e4:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801027eb:	e8 18 fd ff ff       	call   80102508 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f3:	8b 00                	mov    (%eax),%eax
801027f5:	89 c2                	mov    %eax,%edx
801027f7:	83 ca 02             	or     $0x2,%edx
801027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fd:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102802:	8b 00                	mov    (%eax),%eax
80102804:	89 c2                	mov    %eax,%edx
80102806:	83 e2 fb             	and    $0xfffffffb,%edx
80102809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010280c:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102811:	89 04 24             	mov    %eax,(%esp)
80102814:	e8 33 22 00 00       	call   80104a4c <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102819:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010281e:	85 c0                	test   %eax,%eax
80102820:	74 0d                	je     8010282f <ideintr+0xb5>
    idestart(idequeue);
80102822:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102827:	89 04 24             	mov    %eax,(%esp)
8010282a:	e8 26 fe ff ff       	call   80102655 <idestart>

  release(&idelock);
8010282f:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102836:	e8 76 24 00 00       	call   80104cb1 <release>
}
8010283b:	c9                   	leave  
8010283c:	c3                   	ret    

8010283d <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010283d:	55                   	push   %ebp
8010283e:	89 e5                	mov    %esp,%ebp
80102840:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102843:	8b 45 08             	mov    0x8(%ebp),%eax
80102846:	8b 00                	mov    (%eax),%eax
80102848:	83 e0 01             	and    $0x1,%eax
8010284b:	85 c0                	test   %eax,%eax
8010284d:	75 0c                	jne    8010285b <iderw+0x1e>
    panic("iderw: buf not busy");
8010284f:	c7 04 24 92 83 10 80 	movl   $0x80108392,(%esp)
80102856:	e8 db dc ff ff       	call   80100536 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010285b:	8b 45 08             	mov    0x8(%ebp),%eax
8010285e:	8b 00                	mov    (%eax),%eax
80102860:	83 e0 06             	and    $0x6,%eax
80102863:	83 f8 02             	cmp    $0x2,%eax
80102866:	75 0c                	jne    80102874 <iderw+0x37>
    panic("iderw: nothing to do");
80102868:	c7 04 24 a6 83 10 80 	movl   $0x801083a6,(%esp)
8010286f:	e8 c2 dc ff ff       	call   80100536 <panic>
  if(b->dev != 0 && !havedisk1)
80102874:	8b 45 08             	mov    0x8(%ebp),%eax
80102877:	8b 40 04             	mov    0x4(%eax),%eax
8010287a:	85 c0                	test   %eax,%eax
8010287c:	74 15                	je     80102893 <iderw+0x56>
8010287e:	a1 38 b6 10 80       	mov    0x8010b638,%eax
80102883:	85 c0                	test   %eax,%eax
80102885:	75 0c                	jne    80102893 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
80102887:	c7 04 24 bb 83 10 80 	movl   $0x801083bb,(%esp)
8010288e:	e8 a3 dc ff ff       	call   80100536 <panic>

  acquire(&idelock);  //DOC: acquire-lock
80102893:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010289a:	e8 b0 23 00 00       	call   80104c4f <acquire>

  // Append b to idequeue.
  b->qnext = 0;
8010289f:	8b 45 08             	mov    0x8(%ebp),%eax
801028a2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC: insert-queue
801028a9:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
801028b0:	eb 0b                	jmp    801028bd <iderw+0x80>
801028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028b5:	8b 00                	mov    (%eax),%eax
801028b7:	83 c0 14             	add    $0x14,%eax
801028ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c0:	8b 00                	mov    (%eax),%eax
801028c2:	85 c0                	test   %eax,%eax
801028c4:	75 ec                	jne    801028b2 <iderw+0x75>
    ;
  *pp = b;
801028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c9:	8b 55 08             	mov    0x8(%ebp),%edx
801028cc:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801028ce:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801028d3:	3b 45 08             	cmp    0x8(%ebp),%eax
801028d6:	75 22                	jne    801028fa <iderw+0xbd>
    idestart(b);
801028d8:	8b 45 08             	mov    0x8(%ebp),%eax
801028db:	89 04 24             	mov    %eax,(%esp)
801028de:	e8 72 fd ff ff       	call   80102655 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028e3:	eb 15                	jmp    801028fa <iderw+0xbd>
    sleep(b, &idelock);
801028e5:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
801028ec:	80 
801028ed:	8b 45 08             	mov    0x8(%ebp),%eax
801028f0:	89 04 24             	mov    %eax,(%esp)
801028f3:	e8 7b 20 00 00       	call   80104973 <sleep>
801028f8:	eb 01                	jmp    801028fb <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028fa:	90                   	nop
801028fb:	8b 45 08             	mov    0x8(%ebp),%eax
801028fe:	8b 00                	mov    (%eax),%eax
80102900:	83 e0 06             	and    $0x6,%eax
80102903:	83 f8 02             	cmp    $0x2,%eax
80102906:	75 dd                	jne    801028e5 <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
80102908:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010290f:	e8 9d 23 00 00       	call   80104cb1 <release>
}
80102914:	c9                   	leave  
80102915:	c3                   	ret    
80102916:	66 90                	xchg   %ax,%ax

80102918 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102918:	55                   	push   %ebp
80102919:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010291b:	a1 54 fd 10 80       	mov    0x8010fd54,%eax
80102920:	8b 55 08             	mov    0x8(%ebp),%edx
80102923:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102925:	a1 54 fd 10 80       	mov    0x8010fd54,%eax
8010292a:	8b 40 10             	mov    0x10(%eax),%eax
}
8010292d:	5d                   	pop    %ebp
8010292e:	c3                   	ret    

8010292f <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
8010292f:	55                   	push   %ebp
80102930:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102932:	a1 54 fd 10 80       	mov    0x8010fd54,%eax
80102937:	8b 55 08             	mov    0x8(%ebp),%edx
8010293a:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010293c:	a1 54 fd 10 80       	mov    0x8010fd54,%eax
80102941:	8b 55 0c             	mov    0xc(%ebp),%edx
80102944:	89 50 10             	mov    %edx,0x10(%eax)
}
80102947:	5d                   	pop    %ebp
80102948:	c3                   	ret    

80102949 <ioapicinit>:

void
ioapicinit(void)
{
80102949:	55                   	push   %ebp
8010294a:	89 e5                	mov    %esp,%ebp
8010294c:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
8010294f:	a1 24 fe 10 80       	mov    0x8010fe24,%eax
80102954:	85 c0                	test   %eax,%eax
80102956:	0f 84 9a 00 00 00    	je     801029f6 <ioapicinit+0xad>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
8010295c:	c7 05 54 fd 10 80 00 	movl   $0xfec00000,0x8010fd54
80102963:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102966:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010296d:	e8 a6 ff ff ff       	call   80102918 <ioapicread>
80102972:	c1 e8 10             	shr    $0x10,%eax
80102975:	25 ff 00 00 00       	and    $0xff,%eax
8010297a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
8010297d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102984:	e8 8f ff ff ff       	call   80102918 <ioapicread>
80102989:	c1 e8 18             	shr    $0x18,%eax
8010298c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
8010298f:	a0 20 fe 10 80       	mov    0x8010fe20,%al
80102994:	0f b6 c0             	movzbl %al,%eax
80102997:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010299a:	74 0c                	je     801029a8 <ioapicinit+0x5f>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010299c:	c7 04 24 dc 83 10 80 	movl   $0x801083dc,(%esp)
801029a3:	e8 f9 d9 ff ff       	call   801003a1 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029af:	eb 3b                	jmp    801029ec <ioapicinit+0xa3>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029b4:	83 c0 20             	add    $0x20,%eax
801029b7:	0d 00 00 01 00       	or     $0x10000,%eax
801029bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801029bf:	83 c2 08             	add    $0x8,%edx
801029c2:	d1 e2                	shl    %edx
801029c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c8:	89 14 24             	mov    %edx,(%esp)
801029cb:	e8 5f ff ff ff       	call   8010292f <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
801029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029d3:	83 c0 08             	add    $0x8,%eax
801029d6:	d1 e0                	shl    %eax
801029d8:	40                   	inc    %eax
801029d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801029e0:	00 
801029e1:	89 04 24             	mov    %eax,(%esp)
801029e4:	e8 46 ff ff ff       	call   8010292f <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029e9:	ff 45 f4             	incl   -0xc(%ebp)
801029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801029f2:	7e bd                	jle    801029b1 <ioapicinit+0x68>
801029f4:	eb 01                	jmp    801029f7 <ioapicinit+0xae>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
801029f6:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029f7:	c9                   	leave  
801029f8:	c3                   	ret    

801029f9 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801029f9:	55                   	push   %ebp
801029fa:	89 e5                	mov    %esp,%ebp
801029fc:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
801029ff:	a1 24 fe 10 80       	mov    0x8010fe24,%eax
80102a04:	85 c0                	test   %eax,%eax
80102a06:	74 37                	je     80102a3f <ioapicenable+0x46>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a08:	8b 45 08             	mov    0x8(%ebp),%eax
80102a0b:	83 c0 20             	add    $0x20,%eax
80102a0e:	8b 55 08             	mov    0x8(%ebp),%edx
80102a11:	83 c2 08             	add    $0x8,%edx
80102a14:	d1 e2                	shl    %edx
80102a16:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a1a:	89 14 24             	mov    %edx,(%esp)
80102a1d:	e8 0d ff ff ff       	call   8010292f <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a22:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a25:	c1 e0 18             	shl    $0x18,%eax
80102a28:	8b 55 08             	mov    0x8(%ebp),%edx
80102a2b:	83 c2 08             	add    $0x8,%edx
80102a2e:	d1 e2                	shl    %edx
80102a30:	42                   	inc    %edx
80102a31:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a35:	89 14 24             	mov    %edx,(%esp)
80102a38:	e8 f2 fe ff ff       	call   8010292f <ioapicwrite>
80102a3d:	eb 01                	jmp    80102a40 <ioapicenable+0x47>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102a3f:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102a40:	c9                   	leave  
80102a41:	c3                   	ret    
80102a42:	66 90                	xchg   %ax,%ax

80102a44 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a44:	55                   	push   %ebp
80102a45:	89 e5                	mov    %esp,%ebp
80102a47:	8b 45 08             	mov    0x8(%ebp),%eax
80102a4a:	05 00 00 00 80       	add    $0x80000000,%eax
80102a4f:	5d                   	pop    %ebp
80102a50:	c3                   	ret    

80102a51 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a51:	55                   	push   %ebp
80102a52:	89 e5                	mov    %esp,%ebp
80102a54:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a57:	c7 44 24 04 0e 84 10 	movl   $0x8010840e,0x4(%esp)
80102a5e:	80 
80102a5f:	c7 04 24 60 fd 10 80 	movl   $0x8010fd60,(%esp)
80102a66:	e8 c3 21 00 00       	call   80104c2e <initlock>
  kmem.use_lock = 0;
80102a6b:	c7 05 94 fd 10 80 00 	movl   $0x0,0x8010fd94
80102a72:	00 00 00 
  freerange(vstart, vend);
80102a75:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a78:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a7f:	89 04 24             	mov    %eax,(%esp)
80102a82:	e8 26 00 00 00       	call   80102aad <freerange>
}
80102a87:	c9                   	leave  
80102a88:	c3                   	ret    

80102a89 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a89:	55                   	push   %ebp
80102a8a:	89 e5                	mov    %esp,%ebp
80102a8c:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a92:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a96:	8b 45 08             	mov    0x8(%ebp),%eax
80102a99:	89 04 24             	mov    %eax,(%esp)
80102a9c:	e8 0c 00 00 00       	call   80102aad <freerange>
  kmem.use_lock = 1;
80102aa1:	c7 05 94 fd 10 80 01 	movl   $0x1,0x8010fd94
80102aa8:	00 00 00 
}
80102aab:	c9                   	leave  
80102aac:	c3                   	ret    

80102aad <freerange>:

void
freerange(void *vstart, void *vend)
{
80102aad:	55                   	push   %ebp
80102aae:	89 e5                	mov    %esp,%ebp
80102ab0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102ab3:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab6:	05 ff 0f 00 00       	add    $0xfff,%eax
80102abb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ac3:	eb 12                	jmp    80102ad7 <freerange+0x2a>
    kfree(p);
80102ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac8:	89 04 24             	mov    %eax,(%esp)
80102acb:	e8 16 00 00 00       	call   80102ae6 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ad0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ada:	05 00 10 00 00       	add    $0x1000,%eax
80102adf:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102ae2:	76 e1                	jbe    80102ac5 <freerange+0x18>
    kfree(p);
}
80102ae4:	c9                   	leave  
80102ae5:	c3                   	ret    

80102ae6 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102ae6:	55                   	push   %ebp
80102ae7:	89 e5                	mov    %esp,%ebp
80102ae9:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102aec:	8b 45 08             	mov    0x8(%ebp),%eax
80102aef:	25 ff 0f 00 00       	and    $0xfff,%eax
80102af4:	85 c0                	test   %eax,%eax
80102af6:	75 1b                	jne    80102b13 <kfree+0x2d>
80102af8:	81 7d 08 1c 2c 11 80 	cmpl   $0x80112c1c,0x8(%ebp)
80102aff:	72 12                	jb     80102b13 <kfree+0x2d>
80102b01:	8b 45 08             	mov    0x8(%ebp),%eax
80102b04:	89 04 24             	mov    %eax,(%esp)
80102b07:	e8 38 ff ff ff       	call   80102a44 <v2p>
80102b0c:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b11:	76 0c                	jbe    80102b1f <kfree+0x39>
    panic("kfree");
80102b13:	c7 04 24 13 84 10 80 	movl   $0x80108413,(%esp)
80102b1a:	e8 17 da ff ff       	call   80100536 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b1f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102b26:	00 
80102b27:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102b2e:	00 
80102b2f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b32:	89 04 24             	mov    %eax,(%esp)
80102b35:	e8 68 23 00 00       	call   80104ea2 <memset>

  if(kmem.use_lock)
80102b3a:	a1 94 fd 10 80       	mov    0x8010fd94,%eax
80102b3f:	85 c0                	test   %eax,%eax
80102b41:	74 0c                	je     80102b4f <kfree+0x69>
    acquire(&kmem.lock);
80102b43:	c7 04 24 60 fd 10 80 	movl   $0x8010fd60,(%esp)
80102b4a:	e8 00 21 00 00       	call   80104c4f <acquire>
  r = (struct run*)v;
80102b4f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b55:	8b 15 98 fd 10 80    	mov    0x8010fd98,%edx
80102b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b5e:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b63:	a3 98 fd 10 80       	mov    %eax,0x8010fd98
  if(kmem.use_lock)
80102b68:	a1 94 fd 10 80       	mov    0x8010fd94,%eax
80102b6d:	85 c0                	test   %eax,%eax
80102b6f:	74 0c                	je     80102b7d <kfree+0x97>
    release(&kmem.lock);
80102b71:	c7 04 24 60 fd 10 80 	movl   $0x8010fd60,(%esp)
80102b78:	e8 34 21 00 00       	call   80104cb1 <release>
}
80102b7d:	c9                   	leave  
80102b7e:	c3                   	ret    

80102b7f <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b7f:	55                   	push   %ebp
80102b80:	89 e5                	mov    %esp,%ebp
80102b82:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b85:	a1 94 fd 10 80       	mov    0x8010fd94,%eax
80102b8a:	85 c0                	test   %eax,%eax
80102b8c:	74 0c                	je     80102b9a <kalloc+0x1b>
    acquire(&kmem.lock);
80102b8e:	c7 04 24 60 fd 10 80 	movl   $0x8010fd60,(%esp)
80102b95:	e8 b5 20 00 00       	call   80104c4f <acquire>
  r = kmem.freelist;
80102b9a:	a1 98 fd 10 80       	mov    0x8010fd98,%eax
80102b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102ba2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102ba6:	74 0a                	je     80102bb2 <kalloc+0x33>
    kmem.freelist = r->next;
80102ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bab:	8b 00                	mov    (%eax),%eax
80102bad:	a3 98 fd 10 80       	mov    %eax,0x8010fd98
  if(kmem.use_lock)
80102bb2:	a1 94 fd 10 80       	mov    0x8010fd94,%eax
80102bb7:	85 c0                	test   %eax,%eax
80102bb9:	74 0c                	je     80102bc7 <kalloc+0x48>
    release(&kmem.lock);
80102bbb:	c7 04 24 60 fd 10 80 	movl   $0x8010fd60,(%esp)
80102bc2:	e8 ea 20 00 00       	call   80104cb1 <release>
  return (char*)r;
80102bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102bca:	c9                   	leave  
80102bcb:	c3                   	ret    

80102bcc <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102bcc:	55                   	push   %ebp
80102bcd:	89 e5                	mov    %esp,%ebp
80102bcf:	53                   	push   %ebx
80102bd0:	83 ec 14             	sub    $0x14,%esp
80102bd3:	8b 45 08             	mov    0x8(%ebp),%eax
80102bd6:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bda:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102bdd:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102be1:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
80102be5:	ec                   	in     (%dx),%al
80102be6:	88 c3                	mov    %al,%bl
80102be8:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102beb:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80102bee:	83 c4 14             	add    $0x14,%esp
80102bf1:	5b                   	pop    %ebx
80102bf2:	5d                   	pop    %ebp
80102bf3:	c3                   	ret    

80102bf4 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102bf4:	55                   	push   %ebp
80102bf5:	89 e5                	mov    %esp,%ebp
80102bf7:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102bfa:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102c01:	e8 c6 ff ff ff       	call   80102bcc <inb>
80102c06:	0f b6 c0             	movzbl %al,%eax
80102c09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c0f:	83 e0 01             	and    $0x1,%eax
80102c12:	85 c0                	test   %eax,%eax
80102c14:	75 0a                	jne    80102c20 <kbdgetc+0x2c>
    return -1;
80102c16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c1b:	e9 21 01 00 00       	jmp    80102d41 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102c20:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102c27:	e8 a0 ff ff ff       	call   80102bcc <inb>
80102c2c:	0f b6 c0             	movzbl %al,%eax
80102c2f:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c32:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c39:	75 17                	jne    80102c52 <kbdgetc+0x5e>
    shift |= E0ESC;
80102c3b:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c40:	83 c8 40             	or     $0x40,%eax
80102c43:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c48:	b8 00 00 00 00       	mov    $0x0,%eax
80102c4d:	e9 ef 00 00 00       	jmp    80102d41 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102c52:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c55:	25 80 00 00 00       	and    $0x80,%eax
80102c5a:	85 c0                	test   %eax,%eax
80102c5c:	74 44                	je     80102ca2 <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c5e:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c63:	83 e0 40             	and    $0x40,%eax
80102c66:	85 c0                	test   %eax,%eax
80102c68:	75 08                	jne    80102c72 <kbdgetc+0x7e>
80102c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c6d:	83 e0 7f             	and    $0x7f,%eax
80102c70:	eb 03                	jmp    80102c75 <kbdgetc+0x81>
80102c72:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c75:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c78:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c7b:	05 20 90 10 80       	add    $0x80109020,%eax
80102c80:	8a 00                	mov    (%eax),%al
80102c82:	83 c8 40             	or     $0x40,%eax
80102c85:	0f b6 c0             	movzbl %al,%eax
80102c88:	f7 d0                	not    %eax
80102c8a:	89 c2                	mov    %eax,%edx
80102c8c:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c91:	21 d0                	and    %edx,%eax
80102c93:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c98:	b8 00 00 00 00       	mov    $0x0,%eax
80102c9d:	e9 9f 00 00 00       	jmp    80102d41 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102ca2:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102ca7:	83 e0 40             	and    $0x40,%eax
80102caa:	85 c0                	test   %eax,%eax
80102cac:	74 14                	je     80102cc2 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102cae:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102cb5:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cba:	83 e0 bf             	and    $0xffffffbf,%eax
80102cbd:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cc5:	05 20 90 10 80       	add    $0x80109020,%eax
80102cca:	8a 00                	mov    (%eax),%al
80102ccc:	0f b6 d0             	movzbl %al,%edx
80102ccf:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cd4:	09 d0                	or     %edx,%eax
80102cd6:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102cdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cde:	05 20 91 10 80       	add    $0x80109120,%eax
80102ce3:	8a 00                	mov    (%eax),%al
80102ce5:	0f b6 d0             	movzbl %al,%edx
80102ce8:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102ced:	31 d0                	xor    %edx,%eax
80102cef:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102cf4:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cf9:	83 e0 03             	and    $0x3,%eax
80102cfc:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102d03:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d06:	01 d0                	add    %edx,%eax
80102d08:	8a 00                	mov    (%eax),%al
80102d0a:	0f b6 c0             	movzbl %al,%eax
80102d0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d10:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d15:	83 e0 08             	and    $0x8,%eax
80102d18:	85 c0                	test   %eax,%eax
80102d1a:	74 22                	je     80102d3e <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102d1c:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d20:	76 0c                	jbe    80102d2e <kbdgetc+0x13a>
80102d22:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d26:	77 06                	ja     80102d2e <kbdgetc+0x13a>
      c += 'A' - 'a';
80102d28:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d2c:	eb 10                	jmp    80102d3e <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102d2e:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d32:	76 0a                	jbe    80102d3e <kbdgetc+0x14a>
80102d34:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d38:	77 04                	ja     80102d3e <kbdgetc+0x14a>
      c += 'a' - 'A';
80102d3a:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d41:	c9                   	leave  
80102d42:	c3                   	ret    

80102d43 <kbdintr>:

void
kbdintr(void)
{
80102d43:	55                   	push   %ebp
80102d44:	89 e5                	mov    %esp,%ebp
80102d46:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102d49:	c7 04 24 f4 2b 10 80 	movl   $0x80102bf4,(%esp)
80102d50:	e8 3b da ff ff       	call   80100790 <consoleintr>
}
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	90                   	nop

80102d58 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d58:	55                   	push   %ebp
80102d59:	89 e5                	mov    %esp,%ebp
80102d5b:	83 ec 08             	sub    $0x8,%esp
80102d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80102d61:	8b 55 0c             	mov    0xc(%ebp),%edx
80102d64:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102d68:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d6b:	8a 45 f8             	mov    -0x8(%ebp),%al
80102d6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102d71:	ee                   	out    %al,(%dx)
}
80102d72:	c9                   	leave  
80102d73:	c3                   	ret    

80102d74 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d74:	55                   	push   %ebp
80102d75:	89 e5                	mov    %esp,%ebp
80102d77:	53                   	push   %ebx
80102d78:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d7b:	9c                   	pushf  
80102d7c:	5b                   	pop    %ebx
80102d7d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80102d80:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d83:	83 c4 10             	add    $0x10,%esp
80102d86:	5b                   	pop    %ebx
80102d87:	5d                   	pop    %ebp
80102d88:	c3                   	ret    

80102d89 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d89:	55                   	push   %ebp
80102d8a:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d8c:	a1 9c fd 10 80       	mov    0x8010fd9c,%eax
80102d91:	8b 55 08             	mov    0x8(%ebp),%edx
80102d94:	c1 e2 02             	shl    $0x2,%edx
80102d97:	01 c2                	add    %eax,%edx
80102d99:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d9c:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d9e:	a1 9c fd 10 80       	mov    0x8010fd9c,%eax
80102da3:	83 c0 20             	add    $0x20,%eax
80102da6:	8b 00                	mov    (%eax),%eax
}
80102da8:	5d                   	pop    %ebp
80102da9:	c3                   	ret    

80102daa <lapicinit>:
//PAGEBREAK!

void
lapicinit(int c)
{
80102daa:	55                   	push   %ebp
80102dab:	89 e5                	mov    %esp,%ebp
80102dad:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102db0:	a1 9c fd 10 80       	mov    0x8010fd9c,%eax
80102db5:	85 c0                	test   %eax,%eax
80102db7:	0f 84 47 01 00 00    	je     80102f04 <lapicinit+0x15a>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102dbd:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102dc4:	00 
80102dc5:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102dcc:	e8 b8 ff ff ff       	call   80102d89 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102dd1:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102dd8:	00 
80102dd9:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102de0:	e8 a4 ff ff ff       	call   80102d89 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102de5:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102dec:	00 
80102ded:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102df4:	e8 90 ff ff ff       	call   80102d89 <lapicw>
  lapicw(TICR, 10000000); 
80102df9:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102e00:	00 
80102e01:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e08:	e8 7c ff ff ff       	call   80102d89 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e0d:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e14:	00 
80102e15:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e1c:	e8 68 ff ff ff       	call   80102d89 <lapicw>
  lapicw(LINT1, MASKED);
80102e21:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e28:	00 
80102e29:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102e30:	e8 54 ff ff ff       	call   80102d89 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e35:	a1 9c fd 10 80       	mov    0x8010fd9c,%eax
80102e3a:	83 c0 30             	add    $0x30,%eax
80102e3d:	8b 00                	mov    (%eax),%eax
80102e3f:	c1 e8 10             	shr    $0x10,%eax
80102e42:	25 ff 00 00 00       	and    $0xff,%eax
80102e47:	83 f8 03             	cmp    $0x3,%eax
80102e4a:	76 14                	jbe    80102e60 <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102e4c:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e53:	00 
80102e54:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e5b:	e8 29 ff ff ff       	call   80102d89 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e60:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e67:	00 
80102e68:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102e6f:	e8 15 ff ff ff       	call   80102d89 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e74:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e7b:	00 
80102e7c:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e83:	e8 01 ff ff ff       	call   80102d89 <lapicw>
  lapicw(ESR, 0);
80102e88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e8f:	00 
80102e90:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e97:	e8 ed fe ff ff       	call   80102d89 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e9c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ea3:	00 
80102ea4:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102eab:	e8 d9 fe ff ff       	call   80102d89 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102eb0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eb7:	00 
80102eb8:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102ebf:	e8 c5 fe ff ff       	call   80102d89 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ec4:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102ecb:	00 
80102ecc:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102ed3:	e8 b1 fe ff ff       	call   80102d89 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102ed8:	90                   	nop
80102ed9:	a1 9c fd 10 80       	mov    0x8010fd9c,%eax
80102ede:	05 00 03 00 00       	add    $0x300,%eax
80102ee3:	8b 00                	mov    (%eax),%eax
80102ee5:	25 00 10 00 00       	and    $0x1000,%eax
80102eea:	85 c0                	test   %eax,%eax
80102eec:	75 eb                	jne    80102ed9 <lapicinit+0x12f>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102eee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ef5:	00 
80102ef6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102efd:	e8 87 fe ff ff       	call   80102d89 <lapicw>
80102f02:	eb 01                	jmp    80102f05 <lapicinit+0x15b>

void
lapicinit(int c)
{
  if(!lapic) 
    return;
80102f04:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f05:	c9                   	leave  
80102f06:	c3                   	ret    

80102f07 <cpunum>:

int
cpunum(void)
{
80102f07:	55                   	push   %ebp
80102f08:	89 e5                	mov    %esp,%ebp
80102f0a:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f0d:	e8 62 fe ff ff       	call   80102d74 <readeflags>
80102f12:	25 00 02 00 00       	and    $0x200,%eax
80102f17:	85 c0                	test   %eax,%eax
80102f19:	74 27                	je     80102f42 <cpunum+0x3b>
    static int n;
    if(n++ == 0)
80102f1b:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102f20:	85 c0                	test   %eax,%eax
80102f22:	0f 94 c2             	sete   %dl
80102f25:	40                   	inc    %eax
80102f26:	a3 40 b6 10 80       	mov    %eax,0x8010b640
80102f2b:	84 d2                	test   %dl,%dl
80102f2d:	74 13                	je     80102f42 <cpunum+0x3b>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f2f:	8b 45 04             	mov    0x4(%ebp),%eax
80102f32:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f36:	c7 04 24 1c 84 10 80 	movl   $0x8010841c,(%esp)
80102f3d:	e8 5f d4 ff ff       	call   801003a1 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102f42:	a1 9c fd 10 80       	mov    0x8010fd9c,%eax
80102f47:	85 c0                	test   %eax,%eax
80102f49:	74 0f                	je     80102f5a <cpunum+0x53>
    return lapic[ID]>>24;
80102f4b:	a1 9c fd 10 80       	mov    0x8010fd9c,%eax
80102f50:	83 c0 20             	add    $0x20,%eax
80102f53:	8b 00                	mov    (%eax),%eax
80102f55:	c1 e8 18             	shr    $0x18,%eax
80102f58:	eb 05                	jmp    80102f5f <cpunum+0x58>
  return 0;
80102f5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f5f:	c9                   	leave  
80102f60:	c3                   	ret    

80102f61 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f61:	55                   	push   %ebp
80102f62:	89 e5                	mov    %esp,%ebp
80102f64:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f67:	a1 9c fd 10 80       	mov    0x8010fd9c,%eax
80102f6c:	85 c0                	test   %eax,%eax
80102f6e:	74 14                	je     80102f84 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102f70:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f77:	00 
80102f78:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f7f:	e8 05 fe ff ff       	call   80102d89 <lapicw>
}
80102f84:	c9                   	leave  
80102f85:	c3                   	ret    

80102f86 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f86:	55                   	push   %ebp
80102f87:	89 e5                	mov    %esp,%ebp
}
80102f89:	5d                   	pop    %ebp
80102f8a:	c3                   	ret    

80102f8b <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f8b:	55                   	push   %ebp
80102f8c:	89 e5                	mov    %esp,%ebp
80102f8e:	83 ec 1c             	sub    $0x1c,%esp
80102f91:	8b 45 08             	mov    0x8(%ebp),%eax
80102f94:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102f97:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f9e:	00 
80102f9f:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102fa6:	e8 ad fd ff ff       	call   80102d58 <outb>
  outb(IO_RTC+1, 0x0A);
80102fab:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102fb2:	00 
80102fb3:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102fba:	e8 99 fd ff ff       	call   80102d58 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102fbf:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fc9:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102fce:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fd1:	8d 50 02             	lea    0x2(%eax),%edx
80102fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fd7:	c1 e8 04             	shr    $0x4,%eax
80102fda:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fdd:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fe1:	c1 e0 18             	shl    $0x18,%eax
80102fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fe8:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fef:	e8 95 fd ff ff       	call   80102d89 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102ff4:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102ffb:	00 
80102ffc:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103003:	e8 81 fd ff ff       	call   80102d89 <lapicw>
  microdelay(200);
80103008:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010300f:	e8 72 ff ff ff       	call   80102f86 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80103014:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
8010301b:	00 
8010301c:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103023:	e8 61 fd ff ff       	call   80102d89 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103028:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
8010302f:	e8 52 ff ff ff       	call   80102f86 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103034:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010303b:	eb 3f                	jmp    8010307c <lapicstartap+0xf1>
    lapicw(ICRHI, apicid<<24);
8010303d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103041:	c1 e0 18             	shl    $0x18,%eax
80103044:	89 44 24 04          	mov    %eax,0x4(%esp)
80103048:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010304f:	e8 35 fd ff ff       	call   80102d89 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80103054:	8b 45 0c             	mov    0xc(%ebp),%eax
80103057:	c1 e8 0c             	shr    $0xc,%eax
8010305a:	80 cc 06             	or     $0x6,%ah
8010305d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103061:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103068:	e8 1c fd ff ff       	call   80102d89 <lapicw>
    microdelay(200);
8010306d:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103074:	e8 0d ff ff ff       	call   80102f86 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103079:	ff 45 fc             	incl   -0x4(%ebp)
8010307c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103080:	7e bb                	jle    8010303d <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103082:	c9                   	leave  
80103083:	c3                   	ret    

80103084 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80103084:	55                   	push   %ebp
80103085:	89 e5                	mov    %esp,%ebp
80103087:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010308a:	c7 44 24 04 48 84 10 	movl   $0x80108448,0x4(%esp)
80103091:	80 
80103092:	c7 04 24 a0 fd 10 80 	movl   $0x8010fda0,(%esp)
80103099:	e8 90 1b 00 00       	call   80104c2e <initlock>
  readsb(ROOTDEV, &sb);
8010309e:	8d 45 e8             	lea    -0x18(%ebp),%eax
801030a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801030a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801030ac:	e8 e3 e2 ff ff       	call   80101394 <readsb>
  log.start = sb.size - sb.nlog;
801030b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
801030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030b7:	89 d1                	mov    %edx,%ecx
801030b9:	29 c1                	sub    %eax,%ecx
801030bb:	89 c8                	mov    %ecx,%eax
801030bd:	a3 d4 fd 10 80       	mov    %eax,0x8010fdd4
  log.size = sb.nlog;
801030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030c5:	a3 d8 fd 10 80       	mov    %eax,0x8010fdd8
  log.dev = ROOTDEV;
801030ca:	c7 05 e0 fd 10 80 01 	movl   $0x1,0x8010fde0
801030d1:	00 00 00 
  recover_from_log();
801030d4:	e8 95 01 00 00       	call   8010326e <recover_from_log>
}
801030d9:	c9                   	leave  
801030da:	c3                   	ret    

801030db <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801030db:	55                   	push   %ebp
801030dc:	89 e5                	mov    %esp,%ebp
801030de:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801030e8:	e9 89 00 00 00       	jmp    80103176 <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801030ed:	8b 15 d4 fd 10 80    	mov    0x8010fdd4,%edx
801030f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030f6:	01 d0                	add    %edx,%eax
801030f8:	40                   	inc    %eax
801030f9:	89 c2                	mov    %eax,%edx
801030fb:	a1 e0 fd 10 80       	mov    0x8010fde0,%eax
80103100:	89 54 24 04          	mov    %edx,0x4(%esp)
80103104:	89 04 24             	mov    %eax,(%esp)
80103107:	e8 9a d0 ff ff       	call   801001a6 <bread>
8010310c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
8010310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103112:	83 c0 10             	add    $0x10,%eax
80103115:	8b 04 85 a8 fd 10 80 	mov    -0x7fef0258(,%eax,4),%eax
8010311c:	89 c2                	mov    %eax,%edx
8010311e:	a1 e0 fd 10 80       	mov    0x8010fde0,%eax
80103123:	89 54 24 04          	mov    %edx,0x4(%esp)
80103127:	89 04 24             	mov    %eax,(%esp)
8010312a:	e8 77 d0 ff ff       	call   801001a6 <bread>
8010312f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103132:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103135:	8d 50 18             	lea    0x18(%eax),%edx
80103138:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010313b:	83 c0 18             	add    $0x18,%eax
8010313e:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103145:	00 
80103146:	89 54 24 04          	mov    %edx,0x4(%esp)
8010314a:	89 04 24             	mov    %eax,(%esp)
8010314d:	e8 1c 1e 00 00       	call   80104f6e <memmove>
    bwrite(dbuf);  // write dst to disk
80103152:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103155:	89 04 24             	mov    %eax,(%esp)
80103158:	e8 80 d0 ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
8010315d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103160:	89 04 24             	mov    %eax,(%esp)
80103163:	e8 af d0 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
80103168:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010316b:	89 04 24             	mov    %eax,(%esp)
8010316e:	e8 a4 d0 ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103173:	ff 45 f4             	incl   -0xc(%ebp)
80103176:	a1 e4 fd 10 80       	mov    0x8010fde4,%eax
8010317b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010317e:	0f 8f 69 ff ff ff    	jg     801030ed <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103184:	c9                   	leave  
80103185:	c3                   	ret    

80103186 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103186:	55                   	push   %ebp
80103187:	89 e5                	mov    %esp,%ebp
80103189:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010318c:	a1 d4 fd 10 80       	mov    0x8010fdd4,%eax
80103191:	89 c2                	mov    %eax,%edx
80103193:	a1 e0 fd 10 80       	mov    0x8010fde0,%eax
80103198:	89 54 24 04          	mov    %edx,0x4(%esp)
8010319c:	89 04 24             	mov    %eax,(%esp)
8010319f:	e8 02 d0 ff ff       	call   801001a6 <bread>
801031a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801031a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031aa:	83 c0 18             	add    $0x18,%eax
801031ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801031b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031b3:	8b 00                	mov    (%eax),%eax
801031b5:	a3 e4 fd 10 80       	mov    %eax,0x8010fde4
  for (i = 0; i < log.lh.n; i++) {
801031ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031c1:	eb 1a                	jmp    801031dd <read_head+0x57>
    log.lh.sector[i] = lh->sector[i];
801031c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031c9:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801031cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031d0:	83 c2 10             	add    $0x10,%edx
801031d3:	89 04 95 a8 fd 10 80 	mov    %eax,-0x7fef0258(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801031da:	ff 45 f4             	incl   -0xc(%ebp)
801031dd:	a1 e4 fd 10 80       	mov    0x8010fde4,%eax
801031e2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031e5:	7f dc                	jg     801031c3 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
801031e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031ea:	89 04 24             	mov    %eax,(%esp)
801031ed:	e8 25 d0 ff ff       	call   80100217 <brelse>
}
801031f2:	c9                   	leave  
801031f3:	c3                   	ret    

801031f4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801031f4:	55                   	push   %ebp
801031f5:	89 e5                	mov    %esp,%ebp
801031f7:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801031fa:	a1 d4 fd 10 80       	mov    0x8010fdd4,%eax
801031ff:	89 c2                	mov    %eax,%edx
80103201:	a1 e0 fd 10 80       	mov    0x8010fde0,%eax
80103206:	89 54 24 04          	mov    %edx,0x4(%esp)
8010320a:	89 04 24             	mov    %eax,(%esp)
8010320d:	e8 94 cf ff ff       	call   801001a6 <bread>
80103212:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103215:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103218:	83 c0 18             	add    $0x18,%eax
8010321b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010321e:	8b 15 e4 fd 10 80    	mov    0x8010fde4,%edx
80103224:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103227:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103229:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103230:	eb 1a                	jmp    8010324c <write_head+0x58>
    hb->sector[i] = log.lh.sector[i];
80103232:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103235:	83 c0 10             	add    $0x10,%eax
80103238:	8b 0c 85 a8 fd 10 80 	mov    -0x7fef0258(,%eax,4),%ecx
8010323f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103242:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103245:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103249:	ff 45 f4             	incl   -0xc(%ebp)
8010324c:	a1 e4 fd 10 80       	mov    0x8010fde4,%eax
80103251:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103254:	7f dc                	jg     80103232 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
80103256:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103259:	89 04 24             	mov    %eax,(%esp)
8010325c:	e8 7c cf ff ff       	call   801001dd <bwrite>
  brelse(buf);
80103261:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103264:	89 04 24             	mov    %eax,(%esp)
80103267:	e8 ab cf ff ff       	call   80100217 <brelse>
}
8010326c:	c9                   	leave  
8010326d:	c3                   	ret    

8010326e <recover_from_log>:

static void
recover_from_log(void)
{
8010326e:	55                   	push   %ebp
8010326f:	89 e5                	mov    %esp,%ebp
80103271:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103274:	e8 0d ff ff ff       	call   80103186 <read_head>
  install_trans(); // if committed, copy from log to disk
80103279:	e8 5d fe ff ff       	call   801030db <install_trans>
  log.lh.n = 0;
8010327e:	c7 05 e4 fd 10 80 00 	movl   $0x0,0x8010fde4
80103285:	00 00 00 
  write_head(); // clear the log
80103288:	e8 67 ff ff ff       	call   801031f4 <write_head>
}
8010328d:	c9                   	leave  
8010328e:	c3                   	ret    

8010328f <begin_trans>:

void
begin_trans(void)
{
8010328f:	55                   	push   %ebp
80103290:	89 e5                	mov    %esp,%ebp
80103292:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103295:	c7 04 24 a0 fd 10 80 	movl   $0x8010fda0,(%esp)
8010329c:	e8 ae 19 00 00       	call   80104c4f <acquire>
  while (log.busy) {
801032a1:	eb 14                	jmp    801032b7 <begin_trans+0x28>
    sleep(&log, &log.lock);
801032a3:	c7 44 24 04 a0 fd 10 	movl   $0x8010fda0,0x4(%esp)
801032aa:	80 
801032ab:	c7 04 24 a0 fd 10 80 	movl   $0x8010fda0,(%esp)
801032b2:	e8 bc 16 00 00       	call   80104973 <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
801032b7:	a1 dc fd 10 80       	mov    0x8010fddc,%eax
801032bc:	85 c0                	test   %eax,%eax
801032be:	75 e3                	jne    801032a3 <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
801032c0:	c7 05 dc fd 10 80 01 	movl   $0x1,0x8010fddc
801032c7:	00 00 00 
  release(&log.lock);
801032ca:	c7 04 24 a0 fd 10 80 	movl   $0x8010fda0,(%esp)
801032d1:	e8 db 19 00 00       	call   80104cb1 <release>
}
801032d6:	c9                   	leave  
801032d7:	c3                   	ret    

801032d8 <commit_trans>:

void
commit_trans(void)
{
801032d8:	55                   	push   %ebp
801032d9:	89 e5                	mov    %esp,%ebp
801032db:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
801032de:	a1 e4 fd 10 80       	mov    0x8010fde4,%eax
801032e3:	85 c0                	test   %eax,%eax
801032e5:	7e 19                	jle    80103300 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
801032e7:	e8 08 ff ff ff       	call   801031f4 <write_head>
    install_trans(); // Now install writes to home locations
801032ec:	e8 ea fd ff ff       	call   801030db <install_trans>
    log.lh.n = 0; 
801032f1:	c7 05 e4 fd 10 80 00 	movl   $0x0,0x8010fde4
801032f8:	00 00 00 
    write_head();    // Erase the transaction from the log
801032fb:	e8 f4 fe ff ff       	call   801031f4 <write_head>
  }
  
  acquire(&log.lock);
80103300:	c7 04 24 a0 fd 10 80 	movl   $0x8010fda0,(%esp)
80103307:	e8 43 19 00 00       	call   80104c4f <acquire>
  log.busy = 0;
8010330c:	c7 05 dc fd 10 80 00 	movl   $0x0,0x8010fddc
80103313:	00 00 00 
  wakeup(&log);
80103316:	c7 04 24 a0 fd 10 80 	movl   $0x8010fda0,(%esp)
8010331d:	e8 2a 17 00 00       	call   80104a4c <wakeup>
  release(&log.lock);
80103322:	c7 04 24 a0 fd 10 80 	movl   $0x8010fda0,(%esp)
80103329:	e8 83 19 00 00       	call   80104cb1 <release>
}
8010332e:	c9                   	leave  
8010332f:	c3                   	ret    

80103330 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103336:	a1 e4 fd 10 80       	mov    0x8010fde4,%eax
8010333b:	83 f8 09             	cmp    $0x9,%eax
8010333e:	7f 10                	jg     80103350 <log_write+0x20>
80103340:	a1 e4 fd 10 80       	mov    0x8010fde4,%eax
80103345:	8b 15 d8 fd 10 80    	mov    0x8010fdd8,%edx
8010334b:	4a                   	dec    %edx
8010334c:	39 d0                	cmp    %edx,%eax
8010334e:	7c 0c                	jl     8010335c <log_write+0x2c>
    panic("too big a transaction");
80103350:	c7 04 24 4c 84 10 80 	movl   $0x8010844c,(%esp)
80103357:	e8 da d1 ff ff       	call   80100536 <panic>
  if (!log.busy)
8010335c:	a1 dc fd 10 80       	mov    0x8010fddc,%eax
80103361:	85 c0                	test   %eax,%eax
80103363:	75 0c                	jne    80103371 <log_write+0x41>
    panic("write outside of trans");
80103365:	c7 04 24 62 84 10 80 	movl   $0x80108462,(%esp)
8010336c:	e8 c5 d1 ff ff       	call   80100536 <panic>

  for (i = 0; i < log.lh.n; i++) {
80103371:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103378:	eb 1c                	jmp    80103396 <log_write+0x66>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
8010337a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010337d:	83 c0 10             	add    $0x10,%eax
80103380:	8b 04 85 a8 fd 10 80 	mov    -0x7fef0258(,%eax,4),%eax
80103387:	89 c2                	mov    %eax,%edx
80103389:	8b 45 08             	mov    0x8(%ebp),%eax
8010338c:	8b 40 08             	mov    0x8(%eax),%eax
8010338f:	39 c2                	cmp    %eax,%edx
80103391:	74 0f                	je     801033a2 <log_write+0x72>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80103393:	ff 45 f4             	incl   -0xc(%ebp)
80103396:	a1 e4 fd 10 80       	mov    0x8010fde4,%eax
8010339b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010339e:	7f da                	jg     8010337a <log_write+0x4a>
801033a0:	eb 01                	jmp    801033a3 <log_write+0x73>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
801033a2:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
801033a3:	8b 45 08             	mov    0x8(%ebp),%eax
801033a6:	8b 40 08             	mov    0x8(%eax),%eax
801033a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033ac:	83 c2 10             	add    $0x10,%edx
801033af:	89 04 95 a8 fd 10 80 	mov    %eax,-0x7fef0258(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
801033b6:	8b 15 d4 fd 10 80    	mov    0x8010fdd4,%edx
801033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033bf:	01 d0                	add    %edx,%eax
801033c1:	40                   	inc    %eax
801033c2:	89 c2                	mov    %eax,%edx
801033c4:	8b 45 08             	mov    0x8(%ebp),%eax
801033c7:	8b 40 04             	mov    0x4(%eax),%eax
801033ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801033ce:	89 04 24             	mov    %eax,(%esp)
801033d1:	e8 d0 cd ff ff       	call   801001a6 <bread>
801033d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
801033d9:	8b 45 08             	mov    0x8(%ebp),%eax
801033dc:	8d 50 18             	lea    0x18(%eax),%edx
801033df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033e2:	83 c0 18             	add    $0x18,%eax
801033e5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801033ec:	00 
801033ed:	89 54 24 04          	mov    %edx,0x4(%esp)
801033f1:	89 04 24             	mov    %eax,(%esp)
801033f4:	e8 75 1b 00 00       	call   80104f6e <memmove>
  bwrite(lbuf);
801033f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033fc:	89 04 24             	mov    %eax,(%esp)
801033ff:	e8 d9 cd ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
80103404:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103407:	89 04 24             	mov    %eax,(%esp)
8010340a:	e8 08 ce ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
8010340f:	a1 e4 fd 10 80       	mov    0x8010fde4,%eax
80103414:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103417:	75 0b                	jne    80103424 <log_write+0xf4>
    log.lh.n++;
80103419:	a1 e4 fd 10 80       	mov    0x8010fde4,%eax
8010341e:	40                   	inc    %eax
8010341f:	a3 e4 fd 10 80       	mov    %eax,0x8010fde4
  b->flags |= B_DIRTY; // XXX prevent eviction
80103424:	8b 45 08             	mov    0x8(%ebp),%eax
80103427:	8b 00                	mov    (%eax),%eax
80103429:	89 c2                	mov    %eax,%edx
8010342b:	83 ca 04             	or     $0x4,%edx
8010342e:	8b 45 08             	mov    0x8(%ebp),%eax
80103431:	89 10                	mov    %edx,(%eax)
}
80103433:	c9                   	leave  
80103434:	c3                   	ret    
80103435:	66 90                	xchg   %ax,%ax
80103437:	90                   	nop

80103438 <v2p>:
80103438:	55                   	push   %ebp
80103439:	89 e5                	mov    %esp,%ebp
8010343b:	8b 45 08             	mov    0x8(%ebp),%eax
8010343e:	05 00 00 00 80       	add    $0x80000000,%eax
80103443:	5d                   	pop    %ebp
80103444:	c3                   	ret    

80103445 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103445:	55                   	push   %ebp
80103446:	89 e5                	mov    %esp,%ebp
80103448:	8b 45 08             	mov    0x8(%ebp),%eax
8010344b:	05 00 00 00 80       	add    $0x80000000,%eax
80103450:	5d                   	pop    %ebp
80103451:	c3                   	ret    

80103452 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103452:	55                   	push   %ebp
80103453:	89 e5                	mov    %esp,%ebp
80103455:	53                   	push   %ebx
80103456:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
80103459:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010345c:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
8010345f:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103462:	89 c3                	mov    %eax,%ebx
80103464:	89 d8                	mov    %ebx,%eax
80103466:	f0 87 02             	lock xchg %eax,(%edx)
80103469:	89 c3                	mov    %eax,%ebx
8010346b:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010346e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103471:	83 c4 10             	add    $0x10,%esp
80103474:	5b                   	pop    %ebx
80103475:	5d                   	pop    %ebp
80103476:	c3                   	ret    

80103477 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103477:	55                   	push   %ebp
80103478:	89 e5                	mov    %esp,%ebp
8010347a:	83 e4 f0             	and    $0xfffffff0,%esp
8010347d:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103480:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103487:	80 
80103488:	c7 04 24 1c 2c 11 80 	movl   $0x80112c1c,(%esp)
8010348f:	e8 bd f5 ff ff       	call   80102a51 <kinit1>
  kvmalloc();      // kernel page table
80103494:	e8 0c 46 00 00       	call   80107aa5 <kvmalloc>
  mpinit();        // collect info about this machine
80103499:	e8 a3 04 00 00       	call   80103941 <mpinit>
  lapicinit(mpbcpu());
8010349e:	e8 3a 02 00 00       	call   801036dd <mpbcpu>
801034a3:	89 04 24             	mov    %eax,(%esp)
801034a6:	e8 ff f8 ff ff       	call   80102daa <lapicinit>
  seginit();       // set up segments
801034ab:	e8 b1 3f 00 00       	call   80107461 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801034b0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034b6:	8a 00                	mov    (%eax),%al
801034b8:	0f b6 c0             	movzbl %al,%eax
801034bb:	89 44 24 04          	mov    %eax,0x4(%esp)
801034bf:	c7 04 24 79 84 10 80 	movl   $0x80108479,(%esp)
801034c6:	e8 d6 ce ff ff       	call   801003a1 <cprintf>
  picinit();       // interrupt controller
801034cb:	e8 d8 06 00 00       	call   80103ba8 <picinit>
  ioapicinit();    // another interrupt controller
801034d0:	e8 74 f4 ff ff       	call   80102949 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801034d5:	e8 83 d5 ff ff       	call   80100a5d <consoleinit>
  uartinit();      // serial port
801034da:	e8 d5 32 00 00       	call   801067b4 <uartinit>
  pinit();         // process table
801034df:	e8 d7 0b 00 00       	call   801040bb <pinit>
  tvinit();        // trap vectors
801034e4:	e8 90 2e 00 00       	call   80106379 <tvinit>
  binit();         // buffer cache
801034e9:	e8 46 cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
801034ee:	e8 c5 da ff ff       	call   80100fb8 <fileinit>
  iinit();         // inode cache
801034f3:	e8 58 e1 ff ff       	call   80101650 <iinit>
  ideinit();       // disk
801034f8:	e8 b5 f0 ff ff       	call   801025b2 <ideinit>
  if(!ismp)
801034fd:	a1 24 fe 10 80       	mov    0x8010fe24,%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	75 05                	jne    8010350b <main+0x94>
    timerinit();   // uniprocessor timer
80103506:	e8 b5 2d 00 00       	call   801062c0 <timerinit>
  startothers();   // start other processors
8010350b:	e8 86 00 00 00       	call   80103596 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103510:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103517:	8e 
80103518:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
8010351f:	e8 65 f5 ff ff       	call   80102a89 <kinit2>
  userinit();      // first user process
80103524:	e8 ab 0c 00 00       	call   801041d4 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103529:	e8 22 00 00 00       	call   80103550 <mpmain>

8010352e <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010352e:	55                   	push   %ebp
8010352f:	89 e5                	mov    %esp,%ebp
80103531:	83 ec 18             	sub    $0x18,%esp
  switchkvm(); 
80103534:	e8 83 45 00 00       	call   80107abc <switchkvm>
  seginit();
80103539:	e8 23 3f 00 00       	call   80107461 <seginit>
  lapicinit(cpunum());
8010353e:	e8 c4 f9 ff ff       	call   80102f07 <cpunum>
80103543:	89 04 24             	mov    %eax,(%esp)
80103546:	e8 5f f8 ff ff       	call   80102daa <lapicinit>
  mpmain();
8010354b:	e8 00 00 00 00       	call   80103550 <mpmain>

80103550 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103556:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010355c:	8a 00                	mov    (%eax),%al
8010355e:	0f b6 c0             	movzbl %al,%eax
80103561:	89 44 24 04          	mov    %eax,0x4(%esp)
80103565:	c7 04 24 90 84 10 80 	movl   $0x80108490,(%esp)
8010356c:	e8 30 ce ff ff       	call   801003a1 <cprintf>
  idtinit();       // load idt register
80103571:	e8 60 2f 00 00       	call   801064d6 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103576:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010357c:	05 a8 00 00 00       	add    $0xa8,%eax
80103581:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103588:	00 
80103589:	89 04 24             	mov    %eax,(%esp)
8010358c:	e8 c1 fe ff ff       	call   80103452 <xchg>
  scheduler();     // start running processes
80103591:	e8 34 12 00 00       	call   801047ca <scheduler>

80103596 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103596:	55                   	push   %ebp
80103597:	89 e5                	mov    %esp,%ebp
80103599:	53                   	push   %ebx
8010359a:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
8010359d:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
801035a4:	e8 9c fe ff ff       	call   80103445 <p2v>
801035a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801035ac:	b8 8a 00 00 00       	mov    $0x8a,%eax
801035b1:	89 44 24 08          	mov    %eax,0x8(%esp)
801035b5:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
801035bc:	80 
801035bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035c0:	89 04 24             	mov    %eax,(%esp)
801035c3:	e8 a6 19 00 00       	call   80104f6e <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801035c8:	c7 45 f4 40 fe 10 80 	movl   $0x8010fe40,-0xc(%ebp)
801035cf:	e9 8f 00 00 00       	jmp    80103663 <startothers+0xcd>
    if(c == cpus+cpunum())  // We've started already.
801035d4:	e8 2e f9 ff ff       	call   80102f07 <cpunum>
801035d9:	89 c2                	mov    %eax,%edx
801035db:	89 d0                	mov    %edx,%eax
801035dd:	d1 e0                	shl    %eax
801035df:	01 d0                	add    %edx,%eax
801035e1:	c1 e0 04             	shl    $0x4,%eax
801035e4:	29 d0                	sub    %edx,%eax
801035e6:	c1 e0 02             	shl    $0x2,%eax
801035e9:	05 40 fe 10 80       	add    $0x8010fe40,%eax
801035ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035f1:	74 68                	je     8010365b <startothers+0xc5>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801035f3:	e8 87 f5 ff ff       	call   80102b7f <kalloc>
801035f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801035fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035fe:	83 e8 04             	sub    $0x4,%eax
80103601:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103604:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010360a:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010360c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010360f:	83 e8 08             	sub    $0x8,%eax
80103612:	c7 00 2e 35 10 80    	movl   $0x8010352e,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103618:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010361b:	8d 58 f4             	lea    -0xc(%eax),%ebx
8010361e:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
80103625:	e8 0e fe ff ff       	call   80103438 <v2p>
8010362a:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
8010362c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010362f:	89 04 24             	mov    %eax,(%esp)
80103632:	e8 01 fe ff ff       	call   80103438 <v2p>
80103637:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010363a:	8a 12                	mov    (%edx),%dl
8010363c:	0f b6 d2             	movzbl %dl,%edx
8010363f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103643:	89 14 24             	mov    %edx,(%esp)
80103646:	e8 40 f9 ff ff       	call   80102f8b <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010364b:	90                   	nop
8010364c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010364f:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103655:	85 c0                	test   %eax,%eax
80103657:	74 f3                	je     8010364c <startothers+0xb6>
80103659:	eb 01                	jmp    8010365c <startothers+0xc6>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
8010365b:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010365c:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103663:	a1 20 04 11 80       	mov    0x80110420,%eax
80103668:	89 c2                	mov    %eax,%edx
8010366a:	89 d0                	mov    %edx,%eax
8010366c:	d1 e0                	shl    %eax
8010366e:	01 d0                	add    %edx,%eax
80103670:	c1 e0 04             	shl    $0x4,%eax
80103673:	29 d0                	sub    %edx,%eax
80103675:	c1 e0 02             	shl    $0x2,%eax
80103678:	05 40 fe 10 80       	add    $0x8010fe40,%eax
8010367d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103680:	0f 87 4e ff ff ff    	ja     801035d4 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103686:	83 c4 24             	add    $0x24,%esp
80103689:	5b                   	pop    %ebx
8010368a:	5d                   	pop    %ebp
8010368b:	c3                   	ret    

8010368c <p2v>:
8010368c:	55                   	push   %ebp
8010368d:	89 e5                	mov    %esp,%ebp
8010368f:	8b 45 08             	mov    0x8(%ebp),%eax
80103692:	05 00 00 00 80       	add    $0x80000000,%eax
80103697:	5d                   	pop    %ebp
80103698:	c3                   	ret    

80103699 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103699:	55                   	push   %ebp
8010369a:	89 e5                	mov    %esp,%ebp
8010369c:	53                   	push   %ebx
8010369d:	83 ec 14             	sub    $0x14,%esp
801036a0:	8b 45 08             	mov    0x8(%ebp),%eax
801036a3:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801036a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
801036aa:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801036ae:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
801036b2:	ec                   	in     (%dx),%al
801036b3:	88 c3                	mov    %al,%bl
801036b5:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801036b8:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801036bb:	83 c4 14             	add    $0x14,%esp
801036be:	5b                   	pop    %ebx
801036bf:	5d                   	pop    %ebp
801036c0:	c3                   	ret    

801036c1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801036c1:	55                   	push   %ebp
801036c2:	89 e5                	mov    %esp,%ebp
801036c4:	83 ec 08             	sub    $0x8,%esp
801036c7:	8b 45 08             	mov    0x8(%ebp),%eax
801036ca:	8b 55 0c             	mov    0xc(%ebp),%edx
801036cd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801036d1:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801036d4:	8a 45 f8             	mov    -0x8(%ebp),%al
801036d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801036da:	ee                   	out    %al,(%dx)
}
801036db:	c9                   	leave  
801036dc:	c3                   	ret    

801036dd <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
801036dd:	55                   	push   %ebp
801036de:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
801036e0:	a1 44 b6 10 80       	mov    0x8010b644,%eax
801036e5:	89 c2                	mov    %eax,%edx
801036e7:	b8 40 fe 10 80       	mov    $0x8010fe40,%eax
801036ec:	89 d1                	mov    %edx,%ecx
801036ee:	29 c1                	sub    %eax,%ecx
801036f0:	89 c8                	mov    %ecx,%eax
801036f2:	89 c2                	mov    %eax,%edx
801036f4:	c1 fa 02             	sar    $0x2,%edx
801036f7:	89 d0                	mov    %edx,%eax
801036f9:	c1 e0 03             	shl    $0x3,%eax
801036fc:	01 d0                	add    %edx,%eax
801036fe:	c1 e0 03             	shl    $0x3,%eax
80103701:	01 d0                	add    %edx,%eax
80103703:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
8010370a:	01 c8                	add    %ecx,%eax
8010370c:	c1 e0 03             	shl    $0x3,%eax
8010370f:	01 d0                	add    %edx,%eax
80103711:	c1 e0 03             	shl    $0x3,%eax
80103714:	29 d0                	sub    %edx,%eax
80103716:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
8010371d:	01 c8                	add    %ecx,%eax
8010371f:	c1 e0 02             	shl    $0x2,%eax
80103722:	01 d0                	add    %edx,%eax
80103724:	c1 e0 03             	shl    $0x3,%eax
80103727:	29 d0                	sub    %edx,%eax
80103729:	89 c1                	mov    %eax,%ecx
8010372b:	c1 e1 07             	shl    $0x7,%ecx
8010372e:	01 c8                	add    %ecx,%eax
80103730:	d1 e0                	shl    %eax
80103732:	01 d0                	add    %edx,%eax
}
80103734:	5d                   	pop    %ebp
80103735:	c3                   	ret    

80103736 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103736:	55                   	push   %ebp
80103737:	89 e5                	mov    %esp,%ebp
80103739:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
8010373c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103743:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010374a:	eb 13                	jmp    8010375f <sum+0x29>
    sum += addr[i];
8010374c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010374f:	8b 45 08             	mov    0x8(%ebp),%eax
80103752:	01 d0                	add    %edx,%eax
80103754:	8a 00                	mov    (%eax),%al
80103756:	0f b6 c0             	movzbl %al,%eax
80103759:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
8010375c:	ff 45 fc             	incl   -0x4(%ebp)
8010375f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103762:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103765:	7c e5                	jl     8010374c <sum+0x16>
    sum += addr[i];
  return sum;
80103767:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010376a:	c9                   	leave  
8010376b:	c3                   	ret    

8010376c <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010376c:	55                   	push   %ebp
8010376d:	89 e5                	mov    %esp,%ebp
8010376f:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103772:	8b 45 08             	mov    0x8(%ebp),%eax
80103775:	89 04 24             	mov    %eax,(%esp)
80103778:	e8 0f ff ff ff       	call   8010368c <p2v>
8010377d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103780:	8b 55 0c             	mov    0xc(%ebp),%edx
80103783:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103786:	01 d0                	add    %edx,%eax
80103788:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
8010378b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010378e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103791:	eb 3f                	jmp    801037d2 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103793:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010379a:	00 
8010379b:	c7 44 24 04 a4 84 10 	movl   $0x801084a4,0x4(%esp)
801037a2:	80 
801037a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037a6:	89 04 24             	mov    %eax,(%esp)
801037a9:	e8 6b 17 00 00       	call   80104f19 <memcmp>
801037ae:	85 c0                	test   %eax,%eax
801037b0:	75 1c                	jne    801037ce <mpsearch1+0x62>
801037b2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801037b9:	00 
801037ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037bd:	89 04 24             	mov    %eax,(%esp)
801037c0:	e8 71 ff ff ff       	call   80103736 <sum>
801037c5:	84 c0                	test   %al,%al
801037c7:	75 05                	jne    801037ce <mpsearch1+0x62>
      return (struct mp*)p;
801037c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037cc:	eb 11                	jmp    801037df <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801037ce:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801037d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801037d8:	72 b9                	jb     80103793 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801037da:	b8 00 00 00 00       	mov    $0x0,%eax
}
801037df:	c9                   	leave  
801037e0:	c3                   	ret    

801037e1 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801037e1:	55                   	push   %ebp
801037e2:	89 e5                	mov    %esp,%ebp
801037e4:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801037e7:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801037ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037f1:	83 c0 0f             	add    $0xf,%eax
801037f4:	8a 00                	mov    (%eax),%al
801037f6:	0f b6 c0             	movzbl %al,%eax
801037f9:	89 c2                	mov    %eax,%edx
801037fb:	c1 e2 08             	shl    $0x8,%edx
801037fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103801:	83 c0 0e             	add    $0xe,%eax
80103804:	8a 00                	mov    (%eax),%al
80103806:	0f b6 c0             	movzbl %al,%eax
80103809:	09 d0                	or     %edx,%eax
8010380b:	c1 e0 04             	shl    $0x4,%eax
8010380e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103811:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103815:	74 21                	je     80103838 <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103817:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
8010381e:	00 
8010381f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103822:	89 04 24             	mov    %eax,(%esp)
80103825:	e8 42 ff ff ff       	call   8010376c <mpsearch1>
8010382a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010382d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103831:	74 4e                	je     80103881 <mpsearch+0xa0>
      return mp;
80103833:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103836:	eb 5d                	jmp    80103895 <mpsearch+0xb4>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010383b:	83 c0 14             	add    $0x14,%eax
8010383e:	8a 00                	mov    (%eax),%al
80103840:	0f b6 c0             	movzbl %al,%eax
80103843:	89 c2                	mov    %eax,%edx
80103845:	c1 e2 08             	shl    $0x8,%edx
80103848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010384b:	83 c0 13             	add    $0x13,%eax
8010384e:	8a 00                	mov    (%eax),%al
80103850:	0f b6 c0             	movzbl %al,%eax
80103853:	09 d0                	or     %edx,%eax
80103855:	c1 e0 0a             	shl    $0xa,%eax
80103858:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
8010385b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010385e:	2d 00 04 00 00       	sub    $0x400,%eax
80103863:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
8010386a:	00 
8010386b:	89 04 24             	mov    %eax,(%esp)
8010386e:	e8 f9 fe ff ff       	call   8010376c <mpsearch1>
80103873:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103876:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010387a:	74 05                	je     80103881 <mpsearch+0xa0>
      return mp;
8010387c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010387f:	eb 14                	jmp    80103895 <mpsearch+0xb4>
  }
  return mpsearch1(0xF0000, 0x10000);
80103881:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103888:	00 
80103889:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103890:	e8 d7 fe ff ff       	call   8010376c <mpsearch1>
}
80103895:	c9                   	leave  
80103896:	c3                   	ret    

80103897 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103897:	55                   	push   %ebp
80103898:	89 e5                	mov    %esp,%ebp
8010389a:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010389d:	e8 3f ff ff ff       	call   801037e1 <mpsearch>
801038a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801038a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801038a9:	74 0a                	je     801038b5 <mpconfig+0x1e>
801038ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038ae:	8b 40 04             	mov    0x4(%eax),%eax
801038b1:	85 c0                	test   %eax,%eax
801038b3:	75 0a                	jne    801038bf <mpconfig+0x28>
    return 0;
801038b5:	b8 00 00 00 00       	mov    $0x0,%eax
801038ba:	e9 80 00 00 00       	jmp    8010393f <mpconfig+0xa8>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801038bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038c2:	8b 40 04             	mov    0x4(%eax),%eax
801038c5:	89 04 24             	mov    %eax,(%esp)
801038c8:	e8 bf fd ff ff       	call   8010368c <p2v>
801038cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801038d0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801038d7:	00 
801038d8:	c7 44 24 04 a9 84 10 	movl   $0x801084a9,0x4(%esp)
801038df:	80 
801038e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038e3:	89 04 24             	mov    %eax,(%esp)
801038e6:	e8 2e 16 00 00       	call   80104f19 <memcmp>
801038eb:	85 c0                	test   %eax,%eax
801038ed:	74 07                	je     801038f6 <mpconfig+0x5f>
    return 0;
801038ef:	b8 00 00 00 00       	mov    $0x0,%eax
801038f4:	eb 49                	jmp    8010393f <mpconfig+0xa8>
  if(conf->version != 1 && conf->version != 4)
801038f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038f9:	8a 40 06             	mov    0x6(%eax),%al
801038fc:	3c 01                	cmp    $0x1,%al
801038fe:	74 11                	je     80103911 <mpconfig+0x7a>
80103900:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103903:	8a 40 06             	mov    0x6(%eax),%al
80103906:	3c 04                	cmp    $0x4,%al
80103908:	74 07                	je     80103911 <mpconfig+0x7a>
    return 0;
8010390a:	b8 00 00 00 00       	mov    $0x0,%eax
8010390f:	eb 2e                	jmp    8010393f <mpconfig+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103911:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103914:	8b 40 04             	mov    0x4(%eax),%eax
80103917:	0f b7 c0             	movzwl %ax,%eax
8010391a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010391e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103921:	89 04 24             	mov    %eax,(%esp)
80103924:	e8 0d fe ff ff       	call   80103736 <sum>
80103929:	84 c0                	test   %al,%al
8010392b:	74 07                	je     80103934 <mpconfig+0x9d>
    return 0;
8010392d:	b8 00 00 00 00       	mov    $0x0,%eax
80103932:	eb 0b                	jmp    8010393f <mpconfig+0xa8>
  *pmp = mp;
80103934:	8b 45 08             	mov    0x8(%ebp),%eax
80103937:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010393a:	89 10                	mov    %edx,(%eax)
  return conf;
8010393c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010393f:	c9                   	leave  
80103940:	c3                   	ret    

80103941 <mpinit>:

void
mpinit(void)
{
80103941:	55                   	push   %ebp
80103942:	89 e5                	mov    %esp,%ebp
80103944:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103947:	c7 05 44 b6 10 80 40 	movl   $0x8010fe40,0x8010b644
8010394e:	fe 10 80 
  if((conf = mpconfig(&mp)) == 0)
80103951:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103954:	89 04 24             	mov    %eax,(%esp)
80103957:	e8 3b ff ff ff       	call   80103897 <mpconfig>
8010395c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010395f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103963:	0f 84 a4 01 00 00    	je     80103b0d <mpinit+0x1cc>
    return;
  ismp = 1;
80103969:	c7 05 24 fe 10 80 01 	movl   $0x1,0x8010fe24
80103970:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103973:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103976:	8b 40 24             	mov    0x24(%eax),%eax
80103979:	a3 9c fd 10 80       	mov    %eax,0x8010fd9c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010397e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103981:	83 c0 2c             	add    $0x2c,%eax
80103984:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103987:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010398a:	8b 40 04             	mov    0x4(%eax),%eax
8010398d:	0f b7 d0             	movzwl %ax,%edx
80103990:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103993:	01 d0                	add    %edx,%eax
80103995:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103998:	e9 fe 00 00 00       	jmp    80103a9b <mpinit+0x15a>
    switch(*p){
8010399d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039a0:	8a 00                	mov    (%eax),%al
801039a2:	0f b6 c0             	movzbl %al,%eax
801039a5:	83 f8 04             	cmp    $0x4,%eax
801039a8:	0f 87 cb 00 00 00    	ja     80103a79 <mpinit+0x138>
801039ae:	8b 04 85 ec 84 10 80 	mov    -0x7fef7b14(,%eax,4),%eax
801039b5:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801039b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801039bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801039c0:	8a 40 01             	mov    0x1(%eax),%al
801039c3:	0f b6 d0             	movzbl %al,%edx
801039c6:	a1 20 04 11 80       	mov    0x80110420,%eax
801039cb:	39 c2                	cmp    %eax,%edx
801039cd:	74 2c                	je     801039fb <mpinit+0xba>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801039cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801039d2:	8a 40 01             	mov    0x1(%eax),%al
801039d5:	0f b6 d0             	movzbl %al,%edx
801039d8:	a1 20 04 11 80       	mov    0x80110420,%eax
801039dd:	89 54 24 08          	mov    %edx,0x8(%esp)
801039e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801039e5:	c7 04 24 ae 84 10 80 	movl   $0x801084ae,(%esp)
801039ec:	e8 b0 c9 ff ff       	call   801003a1 <cprintf>
        ismp = 0;
801039f1:	c7 05 24 fe 10 80 00 	movl   $0x0,0x8010fe24
801039f8:	00 00 00 
      }
      if(proc->flags & MPBOOT)
801039fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801039fe:	8a 40 03             	mov    0x3(%eax),%al
80103a01:	0f b6 c0             	movzbl %al,%eax
80103a04:	83 e0 02             	and    $0x2,%eax
80103a07:	85 c0                	test   %eax,%eax
80103a09:	74 1e                	je     80103a29 <mpinit+0xe8>
        bcpu = &cpus[ncpu];
80103a0b:	8b 15 20 04 11 80    	mov    0x80110420,%edx
80103a11:	89 d0                	mov    %edx,%eax
80103a13:	d1 e0                	shl    %eax
80103a15:	01 d0                	add    %edx,%eax
80103a17:	c1 e0 04             	shl    $0x4,%eax
80103a1a:	29 d0                	sub    %edx,%eax
80103a1c:	c1 e0 02             	shl    $0x2,%eax
80103a1f:	05 40 fe 10 80       	add    $0x8010fe40,%eax
80103a24:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103a29:	8b 15 20 04 11 80    	mov    0x80110420,%edx
80103a2f:	a1 20 04 11 80       	mov    0x80110420,%eax
80103a34:	88 c1                	mov    %al,%cl
80103a36:	89 d0                	mov    %edx,%eax
80103a38:	d1 e0                	shl    %eax
80103a3a:	01 d0                	add    %edx,%eax
80103a3c:	c1 e0 04             	shl    $0x4,%eax
80103a3f:	29 d0                	sub    %edx,%eax
80103a41:	c1 e0 02             	shl    $0x2,%eax
80103a44:	05 40 fe 10 80       	add    $0x8010fe40,%eax
80103a49:	88 08                	mov    %cl,(%eax)
      ncpu++;
80103a4b:	a1 20 04 11 80       	mov    0x80110420,%eax
80103a50:	40                   	inc    %eax
80103a51:	a3 20 04 11 80       	mov    %eax,0x80110420
      p += sizeof(struct mpproc);
80103a56:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103a5a:	eb 3f                	jmp    80103a9b <mpinit+0x15a>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a65:	8a 40 01             	mov    0x1(%eax),%al
80103a68:	a2 20 fe 10 80       	mov    %al,0x8010fe20
      p += sizeof(struct mpioapic);
80103a6d:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103a71:	eb 28                	jmp    80103a9b <mpinit+0x15a>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103a73:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103a77:	eb 22                	jmp    80103a9b <mpinit+0x15a>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a7c:	8a 00                	mov    (%eax),%al
80103a7e:	0f b6 c0             	movzbl %al,%eax
80103a81:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a85:	c7 04 24 cc 84 10 80 	movl   $0x801084cc,(%esp)
80103a8c:	e8 10 c9 ff ff       	call   801003a1 <cprintf>
      ismp = 0;
80103a91:	c7 05 24 fe 10 80 00 	movl   $0x0,0x8010fe24
80103a98:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a9e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103aa1:	0f 82 f6 fe ff ff    	jb     8010399d <mpinit+0x5c>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103aa7:	a1 24 fe 10 80       	mov    0x8010fe24,%eax
80103aac:	85 c0                	test   %eax,%eax
80103aae:	75 1d                	jne    80103acd <mpinit+0x18c>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103ab0:	c7 05 20 04 11 80 01 	movl   $0x1,0x80110420
80103ab7:	00 00 00 
    lapic = 0;
80103aba:	c7 05 9c fd 10 80 00 	movl   $0x0,0x8010fd9c
80103ac1:	00 00 00 
    ioapicid = 0;
80103ac4:	c6 05 20 fe 10 80 00 	movb   $0x0,0x8010fe20
80103acb:	eb 40                	jmp    80103b0d <mpinit+0x1cc>
    return;
  }

  if(mp->imcrp){
80103acd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ad0:	8a 40 0c             	mov    0xc(%eax),%al
80103ad3:	84 c0                	test   %al,%al
80103ad5:	74 36                	je     80103b0d <mpinit+0x1cc>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103ad7:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103ade:	00 
80103adf:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103ae6:	e8 d6 fb ff ff       	call   801036c1 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103aeb:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103af2:	e8 a2 fb ff ff       	call   80103699 <inb>
80103af7:	83 c8 01             	or     $0x1,%eax
80103afa:	0f b6 c0             	movzbl %al,%eax
80103afd:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b01:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103b08:	e8 b4 fb ff ff       	call   801036c1 <outb>
  }
}
80103b0d:	c9                   	leave  
80103b0e:	c3                   	ret    
80103b0f:	90                   	nop

80103b10 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	83 ec 08             	sub    $0x8,%esp
80103b16:	8b 45 08             	mov    0x8(%ebp),%eax
80103b19:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b1c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103b20:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b23:	8a 45 f8             	mov    -0x8(%ebp),%al
80103b26:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103b29:	ee                   	out    %al,(%dx)
}
80103b2a:	c9                   	leave  
80103b2b:	c3                   	ret    

80103b2c <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103b2c:	55                   	push   %ebp
80103b2d:	89 e5                	mov    %esp,%ebp
80103b2f:	83 ec 0c             	sub    $0xc,%esp
80103b32:	8b 45 08             	mov    0x8(%ebp),%eax
80103b35:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103b3c:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103b42:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103b45:	0f b6 c0             	movzbl %al,%eax
80103b48:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b4c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b53:	e8 b8 ff ff ff       	call   80103b10 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103b58:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103b5b:	66 c1 e8 08          	shr    $0x8,%ax
80103b5f:	0f b6 c0             	movzbl %al,%eax
80103b62:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b66:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b6d:	e8 9e ff ff ff       	call   80103b10 <outb>
}
80103b72:	c9                   	leave  
80103b73:	c3                   	ret    

80103b74 <picenable>:

void
picenable(int irq)
{
80103b74:	55                   	push   %ebp
80103b75:	89 e5                	mov    %esp,%ebp
80103b77:	53                   	push   %ebx
80103b78:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103b7b:	8b 45 08             	mov    0x8(%ebp),%eax
80103b7e:	ba 01 00 00 00       	mov    $0x1,%edx
80103b83:	89 d3                	mov    %edx,%ebx
80103b85:	88 c1                	mov    %al,%cl
80103b87:	d3 e3                	shl    %cl,%ebx
80103b89:	89 d8                	mov    %ebx,%eax
80103b8b:	89 c2                	mov    %eax,%edx
80103b8d:	f7 d2                	not    %edx
80103b8f:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
80103b95:	21 d0                	and    %edx,%eax
80103b97:	0f b7 c0             	movzwl %ax,%eax
80103b9a:	89 04 24             	mov    %eax,(%esp)
80103b9d:	e8 8a ff ff ff       	call   80103b2c <picsetmask>
}
80103ba2:	83 c4 04             	add    $0x4,%esp
80103ba5:	5b                   	pop    %ebx
80103ba6:	5d                   	pop    %ebp
80103ba7:	c3                   	ret    

80103ba8 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ba8:	55                   	push   %ebp
80103ba9:	89 e5                	mov    %esp,%ebp
80103bab:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103bae:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103bb5:	00 
80103bb6:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103bbd:	e8 4e ff ff ff       	call   80103b10 <outb>
  outb(IO_PIC2+1, 0xFF);
80103bc2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103bc9:	00 
80103bca:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bd1:	e8 3a ff ff ff       	call   80103b10 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103bd6:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103bdd:	00 
80103bde:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103be5:	e8 26 ff ff ff       	call   80103b10 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103bea:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103bf1:	00 
80103bf2:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103bf9:	e8 12 ff ff ff       	call   80103b10 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103bfe:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103c05:	00 
80103c06:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103c0d:	e8 fe fe ff ff       	call   80103b10 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103c12:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103c19:	00 
80103c1a:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103c21:	e8 ea fe ff ff       	call   80103b10 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103c26:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103c2d:	00 
80103c2e:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c35:	e8 d6 fe ff ff       	call   80103b10 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103c3a:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103c41:	00 
80103c42:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103c49:	e8 c2 fe ff ff       	call   80103b10 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103c4e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103c55:	00 
80103c56:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103c5d:	e8 ae fe ff ff       	call   80103b10 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103c62:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103c69:	00 
80103c6a:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103c71:	e8 9a fe ff ff       	call   80103b10 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103c76:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103c7d:	00 
80103c7e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103c85:	e8 86 fe ff ff       	call   80103b10 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103c8a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103c91:	00 
80103c92:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103c99:	e8 72 fe ff ff       	call   80103b10 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103c9e:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103ca5:	00 
80103ca6:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103cad:	e8 5e fe ff ff       	call   80103b10 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103cb2:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103cb9:	00 
80103cba:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103cc1:	e8 4a fe ff ff       	call   80103b10 <outb>

  if(irqmask != 0xFFFF)
80103cc6:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
80103ccc:	66 83 f8 ff          	cmp    $0xffff,%ax
80103cd0:	74 11                	je     80103ce3 <picinit+0x13b>
    picsetmask(irqmask);
80103cd2:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
80103cd8:	0f b7 c0             	movzwl %ax,%eax
80103cdb:	89 04 24             	mov    %eax,(%esp)
80103cde:	e8 49 fe ff ff       	call   80103b2c <picsetmask>
}
80103ce3:	c9                   	leave  
80103ce4:	c3                   	ret    
80103ce5:	66 90                	xchg   %ax,%ax
80103ce7:	90                   	nop

80103ce8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103ce8:	55                   	push   %ebp
80103ce9:	89 e5                	mov    %esp,%ebp
80103ceb:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103cee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cf8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d01:	8b 10                	mov    (%eax),%edx
80103d03:	8b 45 08             	mov    0x8(%ebp),%eax
80103d06:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103d08:	e8 c7 d2 ff ff       	call   80100fd4 <filealloc>
80103d0d:	8b 55 08             	mov    0x8(%ebp),%edx
80103d10:	89 02                	mov    %eax,(%edx)
80103d12:	8b 45 08             	mov    0x8(%ebp),%eax
80103d15:	8b 00                	mov    (%eax),%eax
80103d17:	85 c0                	test   %eax,%eax
80103d19:	0f 84 c8 00 00 00    	je     80103de7 <pipealloc+0xff>
80103d1f:	e8 b0 d2 ff ff       	call   80100fd4 <filealloc>
80103d24:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d27:	89 02                	mov    %eax,(%edx)
80103d29:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d2c:	8b 00                	mov    (%eax),%eax
80103d2e:	85 c0                	test   %eax,%eax
80103d30:	0f 84 b1 00 00 00    	je     80103de7 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103d36:	e8 44 ee ff ff       	call   80102b7f <kalloc>
80103d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d42:	0f 84 9e 00 00 00    	je     80103de6 <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
80103d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d4b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103d52:	00 00 00 
  p->writeopen = 1;
80103d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d58:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103d5f:	00 00 00 
  p->nwrite = 0;
80103d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d65:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103d6c:	00 00 00 
  p->nread = 0;
80103d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d72:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d79:	00 00 00 
  initlock(&p->lock, "pipe");
80103d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d7f:	c7 44 24 04 00 85 10 	movl   $0x80108500,0x4(%esp)
80103d86:	80 
80103d87:	89 04 24             	mov    %eax,(%esp)
80103d8a:	e8 9f 0e 00 00       	call   80104c2e <initlock>
  (*f0)->type = FD_PIPE;
80103d8f:	8b 45 08             	mov    0x8(%ebp),%eax
80103d92:	8b 00                	mov    (%eax),%eax
80103d94:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9d:	8b 00                	mov    (%eax),%eax
80103d9f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103da3:	8b 45 08             	mov    0x8(%ebp),%eax
80103da6:	8b 00                	mov    (%eax),%eax
80103da8:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103dac:	8b 45 08             	mov    0x8(%ebp),%eax
80103daf:	8b 00                	mov    (%eax),%eax
80103db1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103db4:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103db7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dba:	8b 00                	mov    (%eax),%eax
80103dbc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dc5:	8b 00                	mov    (%eax),%eax
80103dc7:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dce:	8b 00                	mov    (%eax),%eax
80103dd0:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dd7:	8b 00                	mov    (%eax),%eax
80103dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ddc:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103ddf:	b8 00 00 00 00       	mov    $0x0,%eax
80103de4:	eb 43                	jmp    80103e29 <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80103de6:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80103de7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103deb:	74 0b                	je     80103df8 <pipealloc+0x110>
    kfree((char*)p);
80103ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103df0:	89 04 24             	mov    %eax,(%esp)
80103df3:	e8 ee ec ff ff       	call   80102ae6 <kfree>
  if(*f0)
80103df8:	8b 45 08             	mov    0x8(%ebp),%eax
80103dfb:	8b 00                	mov    (%eax),%eax
80103dfd:	85 c0                	test   %eax,%eax
80103dff:	74 0d                	je     80103e0e <pipealloc+0x126>
    fileclose(*f0);
80103e01:	8b 45 08             	mov    0x8(%ebp),%eax
80103e04:	8b 00                	mov    (%eax),%eax
80103e06:	89 04 24             	mov    %eax,(%esp)
80103e09:	e8 6e d2 ff ff       	call   8010107c <fileclose>
  if(*f1)
80103e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e11:	8b 00                	mov    (%eax),%eax
80103e13:	85 c0                	test   %eax,%eax
80103e15:	74 0d                	je     80103e24 <pipealloc+0x13c>
    fileclose(*f1);
80103e17:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e1a:	8b 00                	mov    (%eax),%eax
80103e1c:	89 04 24             	mov    %eax,(%esp)
80103e1f:	e8 58 d2 ff ff       	call   8010107c <fileclose>
  return -1;
80103e24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e29:	c9                   	leave  
80103e2a:	c3                   	ret    

80103e2b <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103e2b:	55                   	push   %ebp
80103e2c:	89 e5                	mov    %esp,%ebp
80103e2e:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103e31:	8b 45 08             	mov    0x8(%ebp),%eax
80103e34:	89 04 24             	mov    %eax,(%esp)
80103e37:	e8 13 0e 00 00       	call   80104c4f <acquire>
  if(writable){
80103e3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103e40:	74 1f                	je     80103e61 <pipeclose+0x36>
    p->writeopen = 0;
80103e42:	8b 45 08             	mov    0x8(%ebp),%eax
80103e45:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103e4c:	00 00 00 
    wakeup(&p->nread);
80103e4f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e52:	05 34 02 00 00       	add    $0x234,%eax
80103e57:	89 04 24             	mov    %eax,(%esp)
80103e5a:	e8 ed 0b 00 00       	call   80104a4c <wakeup>
80103e5f:	eb 1d                	jmp    80103e7e <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103e61:	8b 45 08             	mov    0x8(%ebp),%eax
80103e64:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103e6b:	00 00 00 
    wakeup(&p->nwrite);
80103e6e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e71:	05 38 02 00 00       	add    $0x238,%eax
80103e76:	89 04 24             	mov    %eax,(%esp)
80103e79:	e8 ce 0b 00 00       	call   80104a4c <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103e7e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e81:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e87:	85 c0                	test   %eax,%eax
80103e89:	75 25                	jne    80103eb0 <pipeclose+0x85>
80103e8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103e94:	85 c0                	test   %eax,%eax
80103e96:	75 18                	jne    80103eb0 <pipeclose+0x85>
    release(&p->lock);
80103e98:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9b:	89 04 24             	mov    %eax,(%esp)
80103e9e:	e8 0e 0e 00 00       	call   80104cb1 <release>
    kfree((char*)p);
80103ea3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea6:	89 04 24             	mov    %eax,(%esp)
80103ea9:	e8 38 ec ff ff       	call   80102ae6 <kfree>
80103eae:	eb 0b                	jmp    80103ebb <pipeclose+0x90>
  } else
    release(&p->lock);
80103eb0:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb3:	89 04 24             	mov    %eax,(%esp)
80103eb6:	e8 f6 0d 00 00       	call   80104cb1 <release>
}
80103ebb:	c9                   	leave  
80103ebc:	c3                   	ret    

80103ebd <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103ebd:	55                   	push   %ebp
80103ebe:	89 e5                	mov    %esp,%ebp
80103ec0:	53                   	push   %ebx
80103ec1:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103ec4:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec7:	89 04 24             	mov    %eax,(%esp)
80103eca:	e8 80 0d 00 00       	call   80104c4f <acquire>
  for(i = 0; i < n; i++){
80103ecf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103ed6:	e9 a6 00 00 00       	jmp    80103f81 <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103edb:	8b 45 08             	mov    0x8(%ebp),%eax
80103ede:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103ee4:	85 c0                	test   %eax,%eax
80103ee6:	74 0d                	je     80103ef5 <pipewrite+0x38>
80103ee8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103eee:	8b 40 24             	mov    0x24(%eax),%eax
80103ef1:	85 c0                	test   %eax,%eax
80103ef3:	74 15                	je     80103f0a <pipewrite+0x4d>
        release(&p->lock);
80103ef5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef8:	89 04 24             	mov    %eax,(%esp)
80103efb:	e8 b1 0d 00 00       	call   80104cb1 <release>
        return -1;
80103f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f05:	e9 9d 00 00 00       	jmp    80103fa7 <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103f0a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f0d:	05 34 02 00 00       	add    $0x234,%eax
80103f12:	89 04 24             	mov    %eax,(%esp)
80103f15:	e8 32 0b 00 00       	call   80104a4c <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f1a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f1d:	8b 55 08             	mov    0x8(%ebp),%edx
80103f20:	81 c2 38 02 00 00    	add    $0x238,%edx
80103f26:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f2a:	89 14 24             	mov    %edx,(%esp)
80103f2d:	e8 41 0a 00 00       	call   80104973 <sleep>
80103f32:	eb 01                	jmp    80103f35 <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f34:	90                   	nop
80103f35:	8b 45 08             	mov    0x8(%ebp),%eax
80103f38:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103f3e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f41:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f47:	05 00 02 00 00       	add    $0x200,%eax
80103f4c:	39 c2                	cmp    %eax,%edx
80103f4e:	74 8b                	je     80103edb <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f50:	8b 45 08             	mov    0x8(%ebp),%eax
80103f53:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f59:	89 c3                	mov    %eax,%ebx
80103f5b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103f61:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103f64:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f67:	01 ca                	add    %ecx,%edx
80103f69:	8a 0a                	mov    (%edx),%cl
80103f6b:	8b 55 08             	mov    0x8(%ebp),%edx
80103f6e:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80103f72:	8d 50 01             	lea    0x1(%eax),%edx
80103f75:	8b 45 08             	mov    0x8(%ebp),%eax
80103f78:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103f7e:	ff 45 f4             	incl   -0xc(%ebp)
80103f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f84:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f87:	7c ab                	jl     80103f34 <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f89:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8c:	05 34 02 00 00       	add    $0x234,%eax
80103f91:	89 04 24             	mov    %eax,(%esp)
80103f94:	e8 b3 0a 00 00       	call   80104a4c <wakeup>
  release(&p->lock);
80103f99:	8b 45 08             	mov    0x8(%ebp),%eax
80103f9c:	89 04 24             	mov    %eax,(%esp)
80103f9f:	e8 0d 0d 00 00       	call   80104cb1 <release>
  return n;
80103fa4:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103fa7:	83 c4 24             	add    $0x24,%esp
80103faa:	5b                   	pop    %ebx
80103fab:	5d                   	pop    %ebp
80103fac:	c3                   	ret    

80103fad <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103fad:	55                   	push   %ebp
80103fae:	89 e5                	mov    %esp,%ebp
80103fb0:	53                   	push   %ebx
80103fb1:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb7:	89 04 24             	mov    %eax,(%esp)
80103fba:	e8 90 0c 00 00       	call   80104c4f <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fbf:	eb 3a                	jmp    80103ffb <piperead+0x4e>
    if(proc->killed){
80103fc1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103fc7:	8b 40 24             	mov    0x24(%eax),%eax
80103fca:	85 c0                	test   %eax,%eax
80103fcc:	74 15                	je     80103fe3 <piperead+0x36>
      release(&p->lock);
80103fce:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd1:	89 04 24             	mov    %eax,(%esp)
80103fd4:	e8 d8 0c 00 00       	call   80104cb1 <release>
      return -1;
80103fd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fde:	e9 b5 00 00 00       	jmp    80104098 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103fe3:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe6:	8b 55 08             	mov    0x8(%ebp),%edx
80103fe9:	81 c2 34 02 00 00    	add    $0x234,%edx
80103fef:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ff3:	89 14 24             	mov    %edx,(%esp)
80103ff6:	e8 78 09 00 00       	call   80104973 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80103ffe:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104004:	8b 45 08             	mov    0x8(%ebp),%eax
80104007:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010400d:	39 c2                	cmp    %eax,%edx
8010400f:	75 0d                	jne    8010401e <piperead+0x71>
80104011:	8b 45 08             	mov    0x8(%ebp),%eax
80104014:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010401a:	85 c0                	test   %eax,%eax
8010401c:	75 a3                	jne    80103fc1 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010401e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104025:	eb 48                	jmp    8010406f <piperead+0xc2>
    if(p->nread == p->nwrite)
80104027:	8b 45 08             	mov    0x8(%ebp),%eax
8010402a:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104030:	8b 45 08             	mov    0x8(%ebp),%eax
80104033:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104039:	39 c2                	cmp    %eax,%edx
8010403b:	74 3c                	je     80104079 <piperead+0xcc>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010403d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104040:	8b 45 0c             	mov    0xc(%ebp),%eax
80104043:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80104046:	8b 45 08             	mov    0x8(%ebp),%eax
80104049:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010404f:	89 c3                	mov    %eax,%ebx
80104051:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80104057:	8b 55 08             	mov    0x8(%ebp),%edx
8010405a:	8a 54 1a 34          	mov    0x34(%edx,%ebx,1),%dl
8010405e:	88 11                	mov    %dl,(%ecx)
80104060:	8d 50 01             	lea    0x1(%eax),%edx
80104063:	8b 45 08             	mov    0x8(%ebp),%eax
80104066:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010406c:	ff 45 f4             	incl   -0xc(%ebp)
8010406f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104072:	3b 45 10             	cmp    0x10(%ebp),%eax
80104075:	7c b0                	jl     80104027 <piperead+0x7a>
80104077:	eb 01                	jmp    8010407a <piperead+0xcd>
    if(p->nread == p->nwrite)
      break;
80104079:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010407a:	8b 45 08             	mov    0x8(%ebp),%eax
8010407d:	05 38 02 00 00       	add    $0x238,%eax
80104082:	89 04 24             	mov    %eax,(%esp)
80104085:	e8 c2 09 00 00       	call   80104a4c <wakeup>
  release(&p->lock);
8010408a:	8b 45 08             	mov    0x8(%ebp),%eax
8010408d:	89 04 24             	mov    %eax,(%esp)
80104090:	e8 1c 0c 00 00       	call   80104cb1 <release>
  return i;
80104095:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104098:	83 c4 24             	add    $0x24,%esp
8010409b:	5b                   	pop    %ebx
8010409c:	5d                   	pop    %ebp
8010409d:	c3                   	ret    
8010409e:	66 90                	xchg   %ax,%ax

801040a0 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040a7:	9c                   	pushf  
801040a8:	5b                   	pop    %ebx
801040a9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
801040ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801040af:	83 c4 10             	add    $0x10,%esp
801040b2:	5b                   	pop    %ebx
801040b3:	5d                   	pop    %ebp
801040b4:	c3                   	ret    

801040b5 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801040b5:	55                   	push   %ebp
801040b6:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801040b8:	fb                   	sti    
}
801040b9:	5d                   	pop    %ebp
801040ba:	c3                   	ret    

801040bb <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801040bb:	55                   	push   %ebp
801040bc:	89 e5                	mov    %esp,%ebp
801040be:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801040c1:	c7 44 24 04 05 85 10 	movl   $0x80108505,0x4(%esp)
801040c8:	80 
801040c9:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
801040d0:	e8 59 0b 00 00       	call   80104c2e <initlock>
}
801040d5:	c9                   	leave  
801040d6:	c3                   	ret    

801040d7 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801040d7:	55                   	push   %ebp
801040d8:	89 e5                	mov    %esp,%ebp
801040da:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801040dd:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
801040e4:	e8 66 0b 00 00       	call   80104c4f <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040e9:	c7 45 f4 74 04 11 80 	movl   $0x80110474,-0xc(%ebp)
801040f0:	eb 0e                	jmp    80104100 <allocproc+0x29>
    if(p->state == UNUSED)
801040f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f5:	8b 40 0c             	mov    0xc(%eax),%eax
801040f8:	85 c0                	test   %eax,%eax
801040fa:	74 23                	je     8010411f <allocproc+0x48>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040fc:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104100:	81 7d f4 74 23 11 80 	cmpl   $0x80112374,-0xc(%ebp)
80104107:	72 e9                	jb     801040f2 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104109:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
80104110:	e8 9c 0b 00 00       	call   80104cb1 <release>
  return 0;
80104115:	b8 00 00 00 00       	mov    $0x0,%eax
8010411a:	e9 b3 00 00 00       	jmp    801041d2 <allocproc+0xfb>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
8010411f:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104120:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104123:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010412a:	a1 04 b0 10 80       	mov    0x8010b004,%eax
8010412f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104132:	89 42 10             	mov    %eax,0x10(%edx)
80104135:	40                   	inc    %eax
80104136:	a3 04 b0 10 80       	mov    %eax,0x8010b004
  release(&ptable.lock);
8010413b:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
80104142:	e8 6a 0b 00 00       	call   80104cb1 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104147:	e8 33 ea ff ff       	call   80102b7f <kalloc>
8010414c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010414f:	89 42 08             	mov    %eax,0x8(%edx)
80104152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104155:	8b 40 08             	mov    0x8(%eax),%eax
80104158:	85 c0                	test   %eax,%eax
8010415a:	75 11                	jne    8010416d <allocproc+0x96>
    p->state = UNUSED;
8010415c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010415f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104166:	b8 00 00 00 00       	mov    $0x0,%eax
8010416b:	eb 65                	jmp    801041d2 <allocproc+0xfb>
  }
  sp = p->kstack + KSTACKSIZE;
8010416d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104170:	8b 40 08             	mov    0x8(%eax),%eax
80104173:	05 00 10 00 00       	add    $0x1000,%eax
80104178:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010417b:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010417f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104182:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104185:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104188:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010418c:	ba 30 63 10 80       	mov    $0x80106330,%edx
80104191:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104194:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104196:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010419a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010419d:	8b 55 f0             	mov    -0x10(%ebp),%edx
801041a0:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801041a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a6:	8b 40 1c             	mov    0x1c(%eax),%eax
801041a9:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801041b0:	00 
801041b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801041b8:	00 
801041b9:	89 04 24             	mov    %eax,(%esp)
801041bc:	e8 e1 0c 00 00       	call   80104ea2 <memset>
  p->context->eip = (uint)forkret;
801041c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c4:	8b 40 1c             	mov    0x1c(%eax),%eax
801041c7:	ba 47 49 10 80       	mov    $0x80104947,%edx
801041cc:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801041cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801041d2:	c9                   	leave  
801041d3:	c3                   	ret    

801041d4 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801041d4:	55                   	push   %ebp
801041d5:	89 e5                	mov    %esp,%ebp
801041d7:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801041da:	e8 f8 fe ff ff       	call   801040d7 <allocproc>
801041df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801041e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e5:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm(kalloc)) == 0)
801041ea:	c7 04 24 7f 2b 10 80 	movl   $0x80102b7f,(%esp)
801041f1:	e8 f2 37 00 00       	call   801079e8 <setupkvm>
801041f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041f9:	89 42 04             	mov    %eax,0x4(%edx)
801041fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ff:	8b 40 04             	mov    0x4(%eax),%eax
80104202:	85 c0                	test   %eax,%eax
80104204:	75 0c                	jne    80104212 <userinit+0x3e>
    panic("userinit: out of memory?");
80104206:	c7 04 24 0c 85 10 80 	movl   $0x8010850c,(%esp)
8010420d:	e8 24 c3 ff ff       	call   80100536 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104212:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104217:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010421a:	8b 40 04             	mov    0x4(%eax),%eax
8010421d:	89 54 24 08          	mov    %edx,0x8(%esp)
80104221:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
80104228:	80 
80104229:	89 04 24             	mov    %eax,(%esp)
8010422c:	e8 03 3a 00 00       	call   80107c34 <inituvm>
  p->sz = PGSIZE;
80104231:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104234:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010423a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010423d:	8b 40 18             	mov    0x18(%eax),%eax
80104240:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104247:	00 
80104248:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010424f:	00 
80104250:	89 04 24             	mov    %eax,(%esp)
80104253:	e8 4a 0c 00 00       	call   80104ea2 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104258:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010425b:	8b 40 18             	mov    0x18(%eax),%eax
8010425e:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104264:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104267:	8b 40 18             	mov    0x18(%eax),%eax
8010426a:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104270:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104273:	8b 50 18             	mov    0x18(%eax),%edx
80104276:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104279:	8b 40 18             	mov    0x18(%eax),%eax
8010427c:	8b 40 2c             	mov    0x2c(%eax),%eax
8010427f:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
80104283:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104286:	8b 50 18             	mov    0x18(%eax),%edx
80104289:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010428c:	8b 40 18             	mov    0x18(%eax),%eax
8010428f:	8b 40 2c             	mov    0x2c(%eax),%eax
80104292:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
80104296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104299:	8b 40 18             	mov    0x18(%eax),%eax
8010429c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801042a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a6:	8b 40 18             	mov    0x18(%eax),%eax
801042a9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801042b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b3:	8b 40 18             	mov    0x18(%eax),%eax
801042b6:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801042bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c0:	83 c0 6c             	add    $0x6c,%eax
801042c3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801042ca:	00 
801042cb:	c7 44 24 04 25 85 10 	movl   $0x80108525,0x4(%esp)
801042d2:	80 
801042d3:	89 04 24             	mov    %eax,(%esp)
801042d6:	e8 d9 0d 00 00       	call   801050b4 <safestrcpy>
  p->cwd = namei("/");
801042db:	c7 04 24 2e 85 10 80 	movl   $0x8010852e,(%esp)
801042e2:	e8 b5 e1 ff ff       	call   8010249c <namei>
801042e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042ea:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
801042ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
801042f7:	c9                   	leave  
801042f8:	c3                   	ret    

801042f9 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801042f9:	55                   	push   %ebp
801042fa:	89 e5                	mov    %esp,%ebp
801042fc:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
801042ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104305:	8b 00                	mov    (%eax),%eax
80104307:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010430a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010430e:	7e 34                	jle    80104344 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104310:	8b 55 08             	mov    0x8(%ebp),%edx
80104313:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104316:	01 c2                	add    %eax,%edx
80104318:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010431e:	8b 40 04             	mov    0x4(%eax),%eax
80104321:	89 54 24 08          	mov    %edx,0x8(%esp)
80104325:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104328:	89 54 24 04          	mov    %edx,0x4(%esp)
8010432c:	89 04 24             	mov    %eax,(%esp)
8010432f:	e8 7a 3a 00 00       	call   80107dae <allocuvm>
80104334:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104337:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010433b:	75 41                	jne    8010437e <growproc+0x85>
      return -1;
8010433d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104342:	eb 58                	jmp    8010439c <growproc+0xa3>
  } else if(n < 0){
80104344:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104348:	79 34                	jns    8010437e <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010434a:	8b 55 08             	mov    0x8(%ebp),%edx
8010434d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104350:	01 c2                	add    %eax,%edx
80104352:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104358:	8b 40 04             	mov    0x4(%eax),%eax
8010435b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010435f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104362:	89 54 24 04          	mov    %edx,0x4(%esp)
80104366:	89 04 24             	mov    %eax,(%esp)
80104369:	e8 1a 3b 00 00       	call   80107e88 <deallocuvm>
8010436e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104375:	75 07                	jne    8010437e <growproc+0x85>
      return -1;
80104377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010437c:	eb 1e                	jmp    8010439c <growproc+0xa3>
  }
  proc->sz = sz;
8010437e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104384:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104387:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104389:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010438f:	89 04 24             	mov    %eax,(%esp)
80104392:	e8 42 37 00 00       	call   80107ad9 <switchuvm>
  return 0;
80104397:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010439c:	c9                   	leave  
8010439d:	c3                   	ret    

8010439e <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010439e:	55                   	push   %ebp
8010439f:	89 e5                	mov    %esp,%ebp
801043a1:	57                   	push   %edi
801043a2:	56                   	push   %esi
801043a3:	53                   	push   %ebx
801043a4:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801043a7:	e8 2b fd ff ff       	call   801040d7 <allocproc>
801043ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
801043af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801043b3:	75 0a                	jne    801043bf <fork+0x21>
    return -1;
801043b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043ba:	e9 39 01 00 00       	jmp    801044f8 <fork+0x15a>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801043bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043c5:	8b 10                	mov    (%eax),%edx
801043c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043cd:	8b 40 04             	mov    0x4(%eax),%eax
801043d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801043d4:	89 04 24             	mov    %eax,(%esp)
801043d7:	e8 47 3c 00 00       	call   80108023 <copyuvm>
801043dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801043df:	89 42 04             	mov    %eax,0x4(%edx)
801043e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043e5:	8b 40 04             	mov    0x4(%eax),%eax
801043e8:	85 c0                	test   %eax,%eax
801043ea:	75 2c                	jne    80104418 <fork+0x7a>
    kfree(np->kstack);
801043ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043ef:	8b 40 08             	mov    0x8(%eax),%eax
801043f2:	89 04 24             	mov    %eax,(%esp)
801043f5:	e8 ec e6 ff ff       	call   80102ae6 <kfree>
    np->kstack = 0;
801043fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104404:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104407:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010440e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104413:	e9 e0 00 00 00       	jmp    801044f8 <fork+0x15a>
  }
  np->sz = proc->sz;
80104418:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010441e:	8b 10                	mov    (%eax),%edx
80104420:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104423:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104425:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010442c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010442f:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104432:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104435:	8b 50 18             	mov    0x18(%eax),%edx
80104438:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010443e:	8b 40 18             	mov    0x18(%eax),%eax
80104441:	89 c3                	mov    %eax,%ebx
80104443:	b8 13 00 00 00       	mov    $0x13,%eax
80104448:	89 d7                	mov    %edx,%edi
8010444a:	89 de                	mov    %ebx,%esi
8010444c:	89 c1                	mov    %eax,%ecx
8010444e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104450:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104453:	8b 40 18             	mov    0x18(%eax),%eax
80104456:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010445d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104464:	eb 3c                	jmp    801044a2 <fork+0x104>
    if(proc->ofile[i])
80104466:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010446c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010446f:	83 c2 08             	add    $0x8,%edx
80104472:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104476:	85 c0                	test   %eax,%eax
80104478:	74 25                	je     8010449f <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
8010447a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104480:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104483:	83 c2 08             	add    $0x8,%edx
80104486:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010448a:	89 04 24             	mov    %eax,(%esp)
8010448d:	e8 a2 cb ff ff       	call   80101034 <filedup>
80104492:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104495:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104498:	83 c1 08             	add    $0x8,%ecx
8010449b:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010449f:	ff 45 e4             	incl   -0x1c(%ebp)
801044a2:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801044a6:	7e be                	jle    80104466 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801044a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044ae:	8b 40 68             	mov    0x68(%eax),%eax
801044b1:	89 04 24             	mov    %eax,(%esp)
801044b4:	e8 17 d4 ff ff       	call   801018d0 <idup>
801044b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
801044bc:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
801044bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044c2:	8b 40 10             	mov    0x10(%eax),%eax
801044c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
801044c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044cb:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
801044d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044d8:	8d 50 6c             	lea    0x6c(%eax),%edx
801044db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044de:	83 c0 6c             	add    $0x6c,%eax
801044e1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801044e8:	00 
801044e9:	89 54 24 04          	mov    %edx,0x4(%esp)
801044ed:	89 04 24             	mov    %eax,(%esp)
801044f0:	e8 bf 0b 00 00       	call   801050b4 <safestrcpy>
  return pid;
801044f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801044f8:	83 c4 2c             	add    $0x2c,%esp
801044fb:	5b                   	pop    %ebx
801044fc:	5e                   	pop    %esi
801044fd:	5f                   	pop    %edi
801044fe:	5d                   	pop    %ebp
801044ff:	c3                   	ret    

80104500 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104506:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010450d:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104512:	39 c2                	cmp    %eax,%edx
80104514:	75 0c                	jne    80104522 <exit+0x22>
    panic("init exiting");
80104516:	c7 04 24 30 85 10 80 	movl   $0x80108530,(%esp)
8010451d:	e8 14 c0 ff ff       	call   80100536 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104522:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104529:	eb 43                	jmp    8010456e <exit+0x6e>
    if(proc->ofile[fd]){
8010452b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104531:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104534:	83 c2 08             	add    $0x8,%edx
80104537:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010453b:	85 c0                	test   %eax,%eax
8010453d:	74 2c                	je     8010456b <exit+0x6b>
      fileclose(proc->ofile[fd]);
8010453f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104545:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104548:	83 c2 08             	add    $0x8,%edx
8010454b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010454f:	89 04 24             	mov    %eax,(%esp)
80104552:	e8 25 cb ff ff       	call   8010107c <fileclose>
      proc->ofile[fd] = 0;
80104557:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010455d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104560:	83 c2 08             	add    $0x8,%edx
80104563:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010456a:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010456b:	ff 45 f0             	incl   -0x10(%ebp)
8010456e:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104572:	7e b7                	jle    8010452b <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
80104574:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010457a:	8b 40 68             	mov    0x68(%eax),%eax
8010457d:	89 04 24             	mov    %eax,(%esp)
80104580:	e8 2d d5 ff ff       	call   80101ab2 <iput>
  proc->cwd = 0;
80104585:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010458b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104592:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
80104599:	e8 b1 06 00 00       	call   80104c4f <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
8010459e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045a4:	8b 40 14             	mov    0x14(%eax),%eax
801045a7:	89 04 24             	mov    %eax,(%esp)
801045aa:	e8 5f 04 00 00       	call   80104a0e <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045af:	c7 45 f4 74 04 11 80 	movl   $0x80110474,-0xc(%ebp)
801045b6:	eb 38                	jmp    801045f0 <exit+0xf0>
    if(p->parent == proc){
801045b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045bb:	8b 50 14             	mov    0x14(%eax),%edx
801045be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045c4:	39 c2                	cmp    %eax,%edx
801045c6:	75 24                	jne    801045ec <exit+0xec>
      p->parent = initproc;
801045c8:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
801045ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d1:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801045d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d7:	8b 40 0c             	mov    0xc(%eax),%eax
801045da:	83 f8 05             	cmp    $0x5,%eax
801045dd:	75 0d                	jne    801045ec <exit+0xec>
        wakeup1(initproc);
801045df:	a1 48 b6 10 80       	mov    0x8010b648,%eax
801045e4:	89 04 24             	mov    %eax,(%esp)
801045e7:	e8 22 04 00 00       	call   80104a0e <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045ec:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801045f0:	81 7d f4 74 23 11 80 	cmpl   $0x80112374,-0xc(%ebp)
801045f7:	72 bf                	jb     801045b8 <exit+0xb8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801045f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045ff:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104606:	e8 58 02 00 00       	call   80104863 <sched>
  panic("zombie exit");
8010460b:	c7 04 24 3d 85 10 80 	movl   $0x8010853d,(%esp)
80104612:	e8 1f bf ff ff       	call   80100536 <panic>

80104617 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104617:	55                   	push   %ebp
80104618:	89 e5                	mov    %esp,%ebp
8010461a:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
8010461d:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
80104624:	e8 26 06 00 00       	call   80104c4f <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104629:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104630:	c7 45 f4 74 04 11 80 	movl   $0x80110474,-0xc(%ebp)
80104637:	e9 9a 00 00 00       	jmp    801046d6 <wait+0xbf>
      if(p->parent != proc)
8010463c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463f:	8b 50 14             	mov    0x14(%eax),%edx
80104642:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104648:	39 c2                	cmp    %eax,%edx
8010464a:	0f 85 81 00 00 00    	jne    801046d1 <wait+0xba>
        continue;
      havekids = 1;
80104650:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104657:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465a:	8b 40 0c             	mov    0xc(%eax),%eax
8010465d:	83 f8 05             	cmp    $0x5,%eax
80104660:	75 70                	jne    801046d2 <wait+0xbb>
        // Found one.
        pid = p->pid;
80104662:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104665:	8b 40 10             	mov    0x10(%eax),%eax
80104668:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
8010466b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466e:	8b 40 08             	mov    0x8(%eax),%eax
80104671:	89 04 24             	mov    %eax,(%esp)
80104674:	e8 6d e4 ff ff       	call   80102ae6 <kfree>
        p->kstack = 0;
80104679:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104683:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104686:	8b 40 04             	mov    0x4(%eax),%eax
80104689:	89 04 24             	mov    %eax,(%esp)
8010468c:	e8 b3 38 00 00       	call   80107f44 <freevm>
        p->state = UNUSED;
80104691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104694:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
8010469b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010469e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801046a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801046af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b2:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801046b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b9:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
801046c0:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
801046c7:	e8 e5 05 00 00       	call   80104cb1 <release>
        return pid;
801046cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046cf:	eb 53                	jmp    80104724 <wait+0x10d>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
801046d1:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046d2:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801046d6:	81 7d f4 74 23 11 80 	cmpl   $0x80112374,-0xc(%ebp)
801046dd:	0f 82 59 ff ff ff    	jb     8010463c <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801046e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801046e7:	74 0d                	je     801046f6 <wait+0xdf>
801046e9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ef:	8b 40 24             	mov    0x24(%eax),%eax
801046f2:	85 c0                	test   %eax,%eax
801046f4:	74 13                	je     80104709 <wait+0xf2>
      release(&ptable.lock);
801046f6:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
801046fd:	e8 af 05 00 00       	call   80104cb1 <release>
      return -1;
80104702:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104707:	eb 1b                	jmp    80104724 <wait+0x10d>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104709:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010470f:	c7 44 24 04 40 04 11 	movl   $0x80110440,0x4(%esp)
80104716:	80 
80104717:	89 04 24             	mov    %eax,(%esp)
8010471a:	e8 54 02 00 00       	call   80104973 <sleep>
  }
8010471f:	e9 05 ff ff ff       	jmp    80104629 <wait+0x12>
}
80104724:	c9                   	leave  
80104725:	c3                   	ret    

80104726 <register_handler>:

void
register_handler(sighandler_t sighandler)
{
80104726:	55                   	push   %ebp
80104727:	89 e5                	mov    %esp,%ebp
80104729:	83 ec 28             	sub    $0x28,%esp
  char* addr = uva2ka(proc->pgdir, (char*)proc->tf->esp);
8010472c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104732:	8b 40 18             	mov    0x18(%eax),%eax
80104735:	8b 40 44             	mov    0x44(%eax),%eax
80104738:	89 c2                	mov    %eax,%edx
8010473a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104740:	8b 40 04             	mov    0x4(%eax),%eax
80104743:	89 54 24 04          	mov    %edx,0x4(%esp)
80104747:	89 04 24             	mov    %eax,(%esp)
8010474a:	e8 e5 39 00 00       	call   80108134 <uva2ka>
8010474f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if ((proc->tf->esp & 0xFFF) == 0)
80104752:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104758:	8b 40 18             	mov    0x18(%eax),%eax
8010475b:	8b 40 44             	mov    0x44(%eax),%eax
8010475e:	25 ff 0f 00 00       	and    $0xfff,%eax
80104763:	85 c0                	test   %eax,%eax
80104765:	75 0c                	jne    80104773 <register_handler+0x4d>
    panic("esp_offset == 0");
80104767:	c7 04 24 49 85 10 80 	movl   $0x80108549,(%esp)
8010476e:	e8 c3 bd ff ff       	call   80100536 <panic>

    /* open a new frame */
  *(int*)(addr + ((proc->tf->esp - 4) & 0xFFF))
80104773:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104779:	8b 40 18             	mov    0x18(%eax),%eax
8010477c:	8b 40 44             	mov    0x44(%eax),%eax
8010477f:	83 e8 04             	sub    $0x4,%eax
80104782:	89 c2                	mov    %eax,%edx
80104784:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
8010478a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478d:	01 c2                	add    %eax,%edx
          = proc->tf->eip;
8010478f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104795:	8b 40 18             	mov    0x18(%eax),%eax
80104798:	8b 40 38             	mov    0x38(%eax),%eax
8010479b:	89 02                	mov    %eax,(%edx)
  proc->tf->esp -= 4;
8010479d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a3:	8b 40 18             	mov    0x18(%eax),%eax
801047a6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047ad:	8b 52 18             	mov    0x18(%edx),%edx
801047b0:	8b 52 44             	mov    0x44(%edx),%edx
801047b3:	83 ea 04             	sub    $0x4,%edx
801047b6:	89 50 44             	mov    %edx,0x44(%eax)

    /* update eip */
  proc->tf->eip = (uint)sighandler;
801047b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047bf:	8b 40 18             	mov    0x18(%eax),%eax
801047c2:	8b 55 08             	mov    0x8(%ebp),%edx
801047c5:	89 50 38             	mov    %edx,0x38(%eax)
}
801047c8:	c9                   	leave  
801047c9:	c3                   	ret    

801047ca <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801047ca:	55                   	push   %ebp
801047cb:	89 e5                	mov    %esp,%ebp
801047cd:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
801047d0:	e8 e0 f8 ff ff       	call   801040b5 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801047d5:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
801047dc:	e8 6e 04 00 00       	call   80104c4f <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047e1:	c7 45 f4 74 04 11 80 	movl   $0x80110474,-0xc(%ebp)
801047e8:	eb 5f                	jmp    80104849 <scheduler+0x7f>
      if(p->state != RUNNABLE)
801047ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ed:	8b 40 0c             	mov    0xc(%eax),%eax
801047f0:	83 f8 03             	cmp    $0x3,%eax
801047f3:	75 4f                	jne    80104844 <scheduler+0x7a>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
801047f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f8:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
801047fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104801:	89 04 24             	mov    %eax,(%esp)
80104804:	e8 d0 32 00 00       	call   80107ad9 <switchuvm>
      p->state = RUNNING;
80104809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480c:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104813:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104819:	8b 40 1c             	mov    0x1c(%eax),%eax
8010481c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104823:	83 c2 04             	add    $0x4,%edx
80104826:	89 44 24 04          	mov    %eax,0x4(%esp)
8010482a:	89 14 24             	mov    %edx,(%esp)
8010482d:	e8 2e 09 00 00       	call   80105160 <swtch>
      switchkvm();
80104832:	e8 85 32 00 00       	call   80107abc <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104837:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010483e:	00 00 00 00 
80104842:	eb 01                	jmp    80104845 <scheduler+0x7b>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104844:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104845:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104849:	81 7d f4 74 23 11 80 	cmpl   $0x80112374,-0xc(%ebp)
80104850:	72 98                	jb     801047ea <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104852:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
80104859:	e8 53 04 00 00       	call   80104cb1 <release>

  }
8010485e:	e9 6d ff ff ff       	jmp    801047d0 <scheduler+0x6>

80104863 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104863:	55                   	push   %ebp
80104864:	89 e5                	mov    %esp,%ebp
80104866:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104869:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
80104870:	e8 02 05 00 00       	call   80104d77 <holding>
80104875:	85 c0                	test   %eax,%eax
80104877:	75 0c                	jne    80104885 <sched+0x22>
    panic("sched ptable.lock");
80104879:	c7 04 24 59 85 10 80 	movl   $0x80108559,(%esp)
80104880:	e8 b1 bc ff ff       	call   80100536 <panic>
  if(cpu->ncli != 1)
80104885:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010488b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104891:	83 f8 01             	cmp    $0x1,%eax
80104894:	74 0c                	je     801048a2 <sched+0x3f>
    panic("sched locks");
80104896:	c7 04 24 6b 85 10 80 	movl   $0x8010856b,(%esp)
8010489d:	e8 94 bc ff ff       	call   80100536 <panic>
  if(proc->state == RUNNING)
801048a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a8:	8b 40 0c             	mov    0xc(%eax),%eax
801048ab:	83 f8 04             	cmp    $0x4,%eax
801048ae:	75 0c                	jne    801048bc <sched+0x59>
    panic("sched running");
801048b0:	c7 04 24 77 85 10 80 	movl   $0x80108577,(%esp)
801048b7:	e8 7a bc ff ff       	call   80100536 <panic>
  if(readeflags()&FL_IF)
801048bc:	e8 df f7 ff ff       	call   801040a0 <readeflags>
801048c1:	25 00 02 00 00       	and    $0x200,%eax
801048c6:	85 c0                	test   %eax,%eax
801048c8:	74 0c                	je     801048d6 <sched+0x73>
    panic("sched interruptible");
801048ca:	c7 04 24 85 85 10 80 	movl   $0x80108585,(%esp)
801048d1:	e8 60 bc ff ff       	call   80100536 <panic>
  intena = cpu->intena;
801048d6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801048dc:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801048e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
801048e5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801048eb:	8b 40 04             	mov    0x4(%eax),%eax
801048ee:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048f5:	83 c2 1c             	add    $0x1c,%edx
801048f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801048fc:	89 14 24             	mov    %edx,(%esp)
801048ff:	e8 5c 08 00 00       	call   80105160 <swtch>
  cpu->intena = intena;
80104904:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010490a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010490d:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104913:	c9                   	leave  
80104914:	c3                   	ret    

80104915 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104915:	55                   	push   %ebp
80104916:	89 e5                	mov    %esp,%ebp
80104918:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010491b:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
80104922:	e8 28 03 00 00       	call   80104c4f <acquire>
  proc->state = RUNNABLE;
80104927:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010492d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104934:	e8 2a ff ff ff       	call   80104863 <sched>
  release(&ptable.lock);
80104939:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
80104940:	e8 6c 03 00 00       	call   80104cb1 <release>
}
80104945:	c9                   	leave  
80104946:	c3                   	ret    

80104947 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104947:	55                   	push   %ebp
80104948:	89 e5                	mov    %esp,%ebp
8010494a:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010494d:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
80104954:	e8 58 03 00 00       	call   80104cb1 <release>

  if (first) {
80104959:	a1 20 b0 10 80       	mov    0x8010b020,%eax
8010495e:	85 c0                	test   %eax,%eax
80104960:	74 0f                	je     80104971 <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104962:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
80104969:	00 00 00 
    initlog();
8010496c:	e8 13 e7 ff ff       	call   80103084 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104971:	c9                   	leave  
80104972:	c3                   	ret    

80104973 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104973:	55                   	push   %ebp
80104974:	89 e5                	mov    %esp,%ebp
80104976:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104979:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010497f:	85 c0                	test   %eax,%eax
80104981:	75 0c                	jne    8010498f <sleep+0x1c>
    panic("sleep");
80104983:	c7 04 24 99 85 10 80 	movl   $0x80108599,(%esp)
8010498a:	e8 a7 bb ff ff       	call   80100536 <panic>

  if(lk == 0)
8010498f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104993:	75 0c                	jne    801049a1 <sleep+0x2e>
    panic("sleep without lk");
80104995:	c7 04 24 9f 85 10 80 	movl   $0x8010859f,(%esp)
8010499c:	e8 95 bb ff ff       	call   80100536 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801049a1:	81 7d 0c 40 04 11 80 	cmpl   $0x80110440,0xc(%ebp)
801049a8:	74 17                	je     801049c1 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
801049aa:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
801049b1:	e8 99 02 00 00       	call   80104c4f <acquire>
    release(lk);
801049b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801049b9:	89 04 24             	mov    %eax,(%esp)
801049bc:	e8 f0 02 00 00       	call   80104cb1 <release>
  }

  // Go to sleep.
  proc->chan = chan;
801049c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c7:	8b 55 08             	mov    0x8(%ebp),%edx
801049ca:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
801049cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049d3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801049da:	e8 84 fe ff ff       	call   80104863 <sched>

  // Tidy up.
  proc->chan = 0;
801049df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e5:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801049ec:	81 7d 0c 40 04 11 80 	cmpl   $0x80110440,0xc(%ebp)
801049f3:	74 17                	je     80104a0c <sleep+0x99>
    release(&ptable.lock);
801049f5:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
801049fc:	e8 b0 02 00 00       	call   80104cb1 <release>
    acquire(lk);
80104a01:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a04:	89 04 24             	mov    %eax,(%esp)
80104a07:	e8 43 02 00 00       	call   80104c4f <acquire>
  }
}
80104a0c:	c9                   	leave  
80104a0d:	c3                   	ret    

80104a0e <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104a0e:	55                   	push   %ebp
80104a0f:	89 e5                	mov    %esp,%ebp
80104a11:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a14:	c7 45 fc 74 04 11 80 	movl   $0x80110474,-0x4(%ebp)
80104a1b:	eb 24                	jmp    80104a41 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104a1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a20:	8b 40 0c             	mov    0xc(%eax),%eax
80104a23:	83 f8 02             	cmp    $0x2,%eax
80104a26:	75 15                	jne    80104a3d <wakeup1+0x2f>
80104a28:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a2b:	8b 40 20             	mov    0x20(%eax),%eax
80104a2e:	3b 45 08             	cmp    0x8(%ebp),%eax
80104a31:	75 0a                	jne    80104a3d <wakeup1+0x2f>
      p->state = RUNNABLE;
80104a33:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a36:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a3d:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104a41:	81 7d fc 74 23 11 80 	cmpl   $0x80112374,-0x4(%ebp)
80104a48:	72 d3                	jb     80104a1d <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104a4a:	c9                   	leave  
80104a4b:	c3                   	ret    

80104a4c <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104a4c:	55                   	push   %ebp
80104a4d:	89 e5                	mov    %esp,%ebp
80104a4f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104a52:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
80104a59:	e8 f1 01 00 00       	call   80104c4f <acquire>
  wakeup1(chan);
80104a5e:	8b 45 08             	mov    0x8(%ebp),%eax
80104a61:	89 04 24             	mov    %eax,(%esp)
80104a64:	e8 a5 ff ff ff       	call   80104a0e <wakeup1>
  release(&ptable.lock);
80104a69:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
80104a70:	e8 3c 02 00 00       	call   80104cb1 <release>
}
80104a75:	c9                   	leave  
80104a76:	c3                   	ret    

80104a77 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104a77:	55                   	push   %ebp
80104a78:	89 e5                	mov    %esp,%ebp
80104a7a:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104a7d:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
80104a84:	e8 c6 01 00 00       	call   80104c4f <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a89:	c7 45 f4 74 04 11 80 	movl   $0x80110474,-0xc(%ebp)
80104a90:	eb 41                	jmp    80104ad3 <kill+0x5c>
    if(p->pid == pid){
80104a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a95:	8b 40 10             	mov    0x10(%eax),%eax
80104a98:	3b 45 08             	cmp    0x8(%ebp),%eax
80104a9b:	75 32                	jne    80104acf <kill+0x58>
      p->killed = 1;
80104a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa0:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aaa:	8b 40 0c             	mov    0xc(%eax),%eax
80104aad:	83 f8 02             	cmp    $0x2,%eax
80104ab0:	75 0a                	jne    80104abc <kill+0x45>
        p->state = RUNNABLE;
80104ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104abc:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
80104ac3:	e8 e9 01 00 00       	call   80104cb1 <release>
      return 0;
80104ac8:	b8 00 00 00 00       	mov    $0x0,%eax
80104acd:	eb 1e                	jmp    80104aed <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104acf:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104ad3:	81 7d f4 74 23 11 80 	cmpl   $0x80112374,-0xc(%ebp)
80104ada:	72 b6                	jb     80104a92 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104adc:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
80104ae3:	e8 c9 01 00 00       	call   80104cb1 <release>
  return -1;
80104ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104aed:	c9                   	leave  
80104aee:	c3                   	ret    

80104aef <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104aef:	55                   	push   %ebp
80104af0:	89 e5                	mov    %esp,%ebp
80104af2:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104af5:	c7 45 f0 74 04 11 80 	movl   $0x80110474,-0x10(%ebp)
80104afc:	e9 d7 00 00 00       	jmp    80104bd8 <procdump+0xe9>
    if(p->state == UNUSED)
80104b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b04:	8b 40 0c             	mov    0xc(%eax),%eax
80104b07:	85 c0                	test   %eax,%eax
80104b09:	0f 84 c4 00 00 00    	je     80104bd3 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b12:	8b 40 0c             	mov    0xc(%eax),%eax
80104b15:	83 f8 05             	cmp    $0x5,%eax
80104b18:	77 23                	ja     80104b3d <procdump+0x4e>
80104b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b1d:	8b 40 0c             	mov    0xc(%eax),%eax
80104b20:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104b27:	85 c0                	test   %eax,%eax
80104b29:	74 12                	je     80104b3d <procdump+0x4e>
      state = states[p->state];
80104b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b2e:	8b 40 0c             	mov    0xc(%eax),%eax
80104b31:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104b38:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104b3b:	eb 07                	jmp    80104b44 <procdump+0x55>
    else
      state = "???";
80104b3d:	c7 45 ec b0 85 10 80 	movl   $0x801085b0,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b47:	8d 50 6c             	lea    0x6c(%eax),%edx
80104b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b4d:	8b 40 10             	mov    0x10(%eax),%eax
80104b50:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104b54:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104b57:	89 54 24 08          	mov    %edx,0x8(%esp)
80104b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b5f:	c7 04 24 b4 85 10 80 	movl   $0x801085b4,(%esp)
80104b66:	e8 36 b8 ff ff       	call   801003a1 <cprintf>
    if(p->state == SLEEPING){
80104b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b6e:	8b 40 0c             	mov    0xc(%eax),%eax
80104b71:	83 f8 02             	cmp    $0x2,%eax
80104b74:	75 4f                	jne    80104bc5 <procdump+0xd6>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b79:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b7c:	8b 40 0c             	mov    0xc(%eax),%eax
80104b7f:	83 c0 08             	add    $0x8,%eax
80104b82:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104b85:	89 54 24 04          	mov    %edx,0x4(%esp)
80104b89:	89 04 24             	mov    %eax,(%esp)
80104b8c:	e8 6f 01 00 00       	call   80104d00 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104b98:	eb 1a                	jmp    80104bb4 <procdump+0xc5>
        cprintf(" %p", pc[i]);
80104b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b9d:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ba5:	c7 04 24 bd 85 10 80 	movl   $0x801085bd,(%esp)
80104bac:	e8 f0 b7 ff ff       	call   801003a1 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104bb1:	ff 45 f4             	incl   -0xc(%ebp)
80104bb4:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104bb8:	7f 0b                	jg     80104bc5 <procdump+0xd6>
80104bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbd:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104bc1:	85 c0                	test   %eax,%eax
80104bc3:	75 d5                	jne    80104b9a <procdump+0xab>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104bc5:	c7 04 24 c1 85 10 80 	movl   $0x801085c1,(%esp)
80104bcc:	e8 d0 b7 ff ff       	call   801003a1 <cprintf>
80104bd1:	eb 01                	jmp    80104bd4 <procdump+0xe5>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104bd3:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bd4:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104bd8:	81 7d f0 74 23 11 80 	cmpl   $0x80112374,-0x10(%ebp)
80104bdf:	0f 82 1c ff ff ff    	jb     80104b01 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104be5:	c9                   	leave  
80104be6:	c3                   	ret    
80104be7:	90                   	nop

80104be8 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104be8:	55                   	push   %ebp
80104be9:	89 e5                	mov    %esp,%ebp
80104beb:	53                   	push   %ebx
80104bec:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bef:	9c                   	pushf  
80104bf0:	5b                   	pop    %ebx
80104bf1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104bf4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104bf7:	83 c4 10             	add    $0x10,%esp
80104bfa:	5b                   	pop    %ebx
80104bfb:	5d                   	pop    %ebp
80104bfc:	c3                   	ret    

80104bfd <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104bfd:	55                   	push   %ebp
80104bfe:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104c00:	fa                   	cli    
}
80104c01:	5d                   	pop    %ebp
80104c02:	c3                   	ret    

80104c03 <sti>:

static inline void
sti(void)
{
80104c03:	55                   	push   %ebp
80104c04:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104c06:	fb                   	sti    
}
80104c07:	5d                   	pop    %ebp
80104c08:	c3                   	ret    

80104c09 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104c09:	55                   	push   %ebp
80104c0a:	89 e5                	mov    %esp,%ebp
80104c0c:	53                   	push   %ebx
80104c0d:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
80104c10:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104c13:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80104c16:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104c19:	89 c3                	mov    %eax,%ebx
80104c1b:	89 d8                	mov    %ebx,%eax
80104c1d:	f0 87 02             	lock xchg %eax,(%edx)
80104c20:	89 c3                	mov    %eax,%ebx
80104c22:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104c25:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104c28:	83 c4 10             	add    $0x10,%esp
80104c2b:	5b                   	pop    %ebx
80104c2c:	5d                   	pop    %ebp
80104c2d:	c3                   	ret    

80104c2e <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c2e:	55                   	push   %ebp
80104c2f:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104c31:	8b 45 08             	mov    0x8(%ebp),%eax
80104c34:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c37:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104c3a:	8b 45 08             	mov    0x8(%ebp),%eax
80104c3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104c43:	8b 45 08             	mov    0x8(%ebp),%eax
80104c46:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c4d:	5d                   	pop    %ebp
80104c4e:	c3                   	ret    

80104c4f <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104c4f:	55                   	push   %ebp
80104c50:	89 e5                	mov    %esp,%ebp
80104c52:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104c55:	e8 47 01 00 00       	call   80104da1 <pushcli>
  if(holding(lk))
80104c5a:	8b 45 08             	mov    0x8(%ebp),%eax
80104c5d:	89 04 24             	mov    %eax,(%esp)
80104c60:	e8 12 01 00 00       	call   80104d77 <holding>
80104c65:	85 c0                	test   %eax,%eax
80104c67:	74 0c                	je     80104c75 <acquire+0x26>
    panic("acquire");
80104c69:	c7 04 24 ed 85 10 80 	movl   $0x801085ed,(%esp)
80104c70:	e8 c1 b8 ff ff       	call   80100536 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104c75:	90                   	nop
80104c76:	8b 45 08             	mov    0x8(%ebp),%eax
80104c79:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104c80:	00 
80104c81:	89 04 24             	mov    %eax,(%esp)
80104c84:	e8 80 ff ff ff       	call   80104c09 <xchg>
80104c89:	85 c0                	test   %eax,%eax
80104c8b:	75 e9                	jne    80104c76 <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104c8d:	8b 45 08             	mov    0x8(%ebp),%eax
80104c90:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c97:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104c9a:	8b 45 08             	mov    0x8(%ebp),%eax
80104c9d:	83 c0 0c             	add    $0xc,%eax
80104ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ca4:	8d 45 08             	lea    0x8(%ebp),%eax
80104ca7:	89 04 24             	mov    %eax,(%esp)
80104caa:	e8 51 00 00 00       	call   80104d00 <getcallerpcs>
}
80104caf:	c9                   	leave  
80104cb0:	c3                   	ret    

80104cb1 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104cb1:	55                   	push   %ebp
80104cb2:	89 e5                	mov    %esp,%ebp
80104cb4:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104cb7:	8b 45 08             	mov    0x8(%ebp),%eax
80104cba:	89 04 24             	mov    %eax,(%esp)
80104cbd:	e8 b5 00 00 00       	call   80104d77 <holding>
80104cc2:	85 c0                	test   %eax,%eax
80104cc4:	75 0c                	jne    80104cd2 <release+0x21>
    panic("release");
80104cc6:	c7 04 24 f5 85 10 80 	movl   $0x801085f5,(%esp)
80104ccd:	e8 64 b8 ff ff       	call   80100536 <panic>

  lk->pcs[0] = 0;
80104cd2:	8b 45 08             	mov    0x8(%ebp),%eax
80104cd5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104cdc:	8b 45 08             	mov    0x8(%ebp),%eax
80104cdf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104cf0:	00 
80104cf1:	89 04 24             	mov    %eax,(%esp)
80104cf4:	e8 10 ff ff ff       	call   80104c09 <xchg>

  popcli();
80104cf9:	e8 e9 00 00 00       	call   80104de7 <popcli>
}
80104cfe:	c9                   	leave  
80104cff:	c3                   	ret    

80104d00 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104d06:	8b 45 08             	mov    0x8(%ebp),%eax
80104d09:	83 e8 08             	sub    $0x8,%eax
80104d0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104d0f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104d16:	eb 37                	jmp    80104d4f <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d18:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104d1c:	74 51                	je     80104d6f <getcallerpcs+0x6f>
80104d1e:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104d25:	76 48                	jbe    80104d6f <getcallerpcs+0x6f>
80104d27:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104d2b:	74 42                	je     80104d6f <getcallerpcs+0x6f>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104d37:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d3a:	01 c2                	add    %eax,%edx
80104d3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d3f:	8b 40 04             	mov    0x4(%eax),%eax
80104d42:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104d44:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d47:	8b 00                	mov    (%eax),%eax
80104d49:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d4c:	ff 45 f8             	incl   -0x8(%ebp)
80104d4f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104d53:	7e c3                	jle    80104d18 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104d55:	eb 18                	jmp    80104d6f <getcallerpcs+0x6f>
    pcs[i] = 0;
80104d57:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d5a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104d61:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d64:	01 d0                	add    %edx,%eax
80104d66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104d6c:	ff 45 f8             	incl   -0x8(%ebp)
80104d6f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104d73:	7e e2                	jle    80104d57 <getcallerpcs+0x57>
    pcs[i] = 0;
}
80104d75:	c9                   	leave  
80104d76:	c3                   	ret    

80104d77 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104d77:	55                   	push   %ebp
80104d78:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104d7a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d7d:	8b 00                	mov    (%eax),%eax
80104d7f:	85 c0                	test   %eax,%eax
80104d81:	74 17                	je     80104d9a <holding+0x23>
80104d83:	8b 45 08             	mov    0x8(%ebp),%eax
80104d86:	8b 50 08             	mov    0x8(%eax),%edx
80104d89:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d8f:	39 c2                	cmp    %eax,%edx
80104d91:	75 07                	jne    80104d9a <holding+0x23>
80104d93:	b8 01 00 00 00       	mov    $0x1,%eax
80104d98:	eb 05                	jmp    80104d9f <holding+0x28>
80104d9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d9f:	5d                   	pop    %ebp
80104da0:	c3                   	ret    

80104da1 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104da1:	55                   	push   %ebp
80104da2:	89 e5                	mov    %esp,%ebp
80104da4:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104da7:	e8 3c fe ff ff       	call   80104be8 <readeflags>
80104dac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104daf:	e8 49 fe ff ff       	call   80104bfd <cli>
  if(cpu->ncli++ == 0)
80104db4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dba:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104dc0:	85 d2                	test   %edx,%edx
80104dc2:	0f 94 c1             	sete   %cl
80104dc5:	42                   	inc    %edx
80104dc6:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104dcc:	84 c9                	test   %cl,%cl
80104dce:	74 15                	je     80104de5 <pushcli+0x44>
    cpu->intena = eflags & FL_IF;
80104dd0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dd6:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104dd9:	81 e2 00 02 00 00    	and    $0x200,%edx
80104ddf:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104de5:	c9                   	leave  
80104de6:	c3                   	ret    

80104de7 <popcli>:

void
popcli(void)
{
80104de7:	55                   	push   %ebp
80104de8:	89 e5                	mov    %esp,%ebp
80104dea:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104ded:	e8 f6 fd ff ff       	call   80104be8 <readeflags>
80104df2:	25 00 02 00 00       	and    $0x200,%eax
80104df7:	85 c0                	test   %eax,%eax
80104df9:	74 0c                	je     80104e07 <popcli+0x20>
    panic("popcli - interruptible");
80104dfb:	c7 04 24 fd 85 10 80 	movl   $0x801085fd,(%esp)
80104e02:	e8 2f b7 ff ff       	call   80100536 <panic>
  if(--cpu->ncli < 0)
80104e07:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e0d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104e13:	4a                   	dec    %edx
80104e14:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104e1a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e20:	85 c0                	test   %eax,%eax
80104e22:	79 0c                	jns    80104e30 <popcli+0x49>
    panic("popcli");
80104e24:	c7 04 24 14 86 10 80 	movl   $0x80108614,(%esp)
80104e2b:	e8 06 b7 ff ff       	call   80100536 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104e30:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e36:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e3c:	85 c0                	test   %eax,%eax
80104e3e:	75 15                	jne    80104e55 <popcli+0x6e>
80104e40:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e46:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104e4c:	85 c0                	test   %eax,%eax
80104e4e:	74 05                	je     80104e55 <popcli+0x6e>
    sti();
80104e50:	e8 ae fd ff ff       	call   80104c03 <sti>
}
80104e55:	c9                   	leave  
80104e56:	c3                   	ret    
80104e57:	90                   	nop

80104e58 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80104e58:	55                   	push   %ebp
80104e59:	89 e5                	mov    %esp,%ebp
80104e5b:	57                   	push   %edi
80104e5c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104e5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e60:	8b 55 10             	mov    0x10(%ebp),%edx
80104e63:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e66:	89 cb                	mov    %ecx,%ebx
80104e68:	89 df                	mov    %ebx,%edi
80104e6a:	89 d1                	mov    %edx,%ecx
80104e6c:	fc                   	cld    
80104e6d:	f3 aa                	rep stos %al,%es:(%edi)
80104e6f:	89 ca                	mov    %ecx,%edx
80104e71:	89 fb                	mov    %edi,%ebx
80104e73:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104e76:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104e79:	5b                   	pop    %ebx
80104e7a:	5f                   	pop    %edi
80104e7b:	5d                   	pop    %ebp
80104e7c:	c3                   	ret    

80104e7d <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80104e7d:	55                   	push   %ebp
80104e7e:	89 e5                	mov    %esp,%ebp
80104e80:	57                   	push   %edi
80104e81:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104e82:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e85:	8b 55 10             	mov    0x10(%ebp),%edx
80104e88:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e8b:	89 cb                	mov    %ecx,%ebx
80104e8d:	89 df                	mov    %ebx,%edi
80104e8f:	89 d1                	mov    %edx,%ecx
80104e91:	fc                   	cld    
80104e92:	f3 ab                	rep stos %eax,%es:(%edi)
80104e94:	89 ca                	mov    %ecx,%edx
80104e96:	89 fb                	mov    %edi,%ebx
80104e98:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104e9b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104e9e:	5b                   	pop    %ebx
80104e9f:	5f                   	pop    %edi
80104ea0:	5d                   	pop    %ebp
80104ea1:	c3                   	ret    

80104ea2 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ea2:	55                   	push   %ebp
80104ea3:	89 e5                	mov    %esp,%ebp
80104ea5:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80104ea8:	8b 45 08             	mov    0x8(%ebp),%eax
80104eab:	83 e0 03             	and    $0x3,%eax
80104eae:	85 c0                	test   %eax,%eax
80104eb0:	75 49                	jne    80104efb <memset+0x59>
80104eb2:	8b 45 10             	mov    0x10(%ebp),%eax
80104eb5:	83 e0 03             	and    $0x3,%eax
80104eb8:	85 c0                	test   %eax,%eax
80104eba:	75 3f                	jne    80104efb <memset+0x59>
    c &= 0xFF;
80104ebc:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104ec3:	8b 45 10             	mov    0x10(%ebp),%eax
80104ec6:	c1 e8 02             	shr    $0x2,%eax
80104ec9:	89 c2                	mov    %eax,%edx
80104ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ece:	89 c1                	mov    %eax,%ecx
80104ed0:	c1 e1 18             	shl    $0x18,%ecx
80104ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ed6:	c1 e0 10             	shl    $0x10,%eax
80104ed9:	09 c1                	or     %eax,%ecx
80104edb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ede:	c1 e0 08             	shl    $0x8,%eax
80104ee1:	09 c8                	or     %ecx,%eax
80104ee3:	0b 45 0c             	or     0xc(%ebp),%eax
80104ee6:	89 54 24 08          	mov    %edx,0x8(%esp)
80104eea:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eee:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef1:	89 04 24             	mov    %eax,(%esp)
80104ef4:	e8 84 ff ff ff       	call   80104e7d <stosl>
80104ef9:	eb 19                	jmp    80104f14 <memset+0x72>
  } else
    stosb(dst, c, n);
80104efb:	8b 45 10             	mov    0x10(%ebp),%eax
80104efe:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f02:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f05:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f09:	8b 45 08             	mov    0x8(%ebp),%eax
80104f0c:	89 04 24             	mov    %eax,(%esp)
80104f0f:	e8 44 ff ff ff       	call   80104e58 <stosb>
  return dst;
80104f14:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104f17:	c9                   	leave  
80104f18:	c3                   	ret    

80104f19 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f19:	55                   	push   %ebp
80104f1a:	89 e5                	mov    %esp,%ebp
80104f1c:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80104f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80104f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104f25:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f28:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104f2b:	eb 2c                	jmp    80104f59 <memcmp+0x40>
    if(*s1 != *s2)
80104f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f30:	8a 10                	mov    (%eax),%dl
80104f32:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f35:	8a 00                	mov    (%eax),%al
80104f37:	38 c2                	cmp    %al,%dl
80104f39:	74 18                	je     80104f53 <memcmp+0x3a>
      return *s1 - *s2;
80104f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f3e:	8a 00                	mov    (%eax),%al
80104f40:	0f b6 d0             	movzbl %al,%edx
80104f43:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f46:	8a 00                	mov    (%eax),%al
80104f48:	0f b6 c0             	movzbl %al,%eax
80104f4b:	89 d1                	mov    %edx,%ecx
80104f4d:	29 c1                	sub    %eax,%ecx
80104f4f:	89 c8                	mov    %ecx,%eax
80104f51:	eb 19                	jmp    80104f6c <memcmp+0x53>
    s1++, s2++;
80104f53:	ff 45 fc             	incl   -0x4(%ebp)
80104f56:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f5d:	0f 95 c0             	setne  %al
80104f60:	ff 4d 10             	decl   0x10(%ebp)
80104f63:	84 c0                	test   %al,%al
80104f65:	75 c6                	jne    80104f2d <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104f67:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f6c:	c9                   	leave  
80104f6d:	c3                   	ret    

80104f6e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f6e:	55                   	push   %ebp
80104f6f:	89 e5                	mov    %esp,%ebp
80104f71:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104f74:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f77:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104f7a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f7d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f83:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104f86:	73 4d                	jae    80104fd5 <memmove+0x67>
80104f88:	8b 45 10             	mov    0x10(%ebp),%eax
80104f8b:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104f8e:	01 d0                	add    %edx,%eax
80104f90:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104f93:	76 40                	jbe    80104fd5 <memmove+0x67>
    s += n;
80104f95:	8b 45 10             	mov    0x10(%ebp),%eax
80104f98:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104f9b:	8b 45 10             	mov    0x10(%ebp),%eax
80104f9e:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104fa1:	eb 10                	jmp    80104fb3 <memmove+0x45>
      *--d = *--s;
80104fa3:	ff 4d f8             	decl   -0x8(%ebp)
80104fa6:	ff 4d fc             	decl   -0x4(%ebp)
80104fa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fac:	8a 10                	mov    (%eax),%dl
80104fae:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fb1:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fb7:	0f 95 c0             	setne  %al
80104fba:	ff 4d 10             	decl   0x10(%ebp)
80104fbd:	84 c0                	test   %al,%al
80104fbf:	75 e2                	jne    80104fa3 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104fc1:	eb 21                	jmp    80104fe4 <memmove+0x76>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80104fc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fc6:	8a 10                	mov    (%eax),%dl
80104fc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fcb:	88 10                	mov    %dl,(%eax)
80104fcd:	ff 45 f8             	incl   -0x8(%ebp)
80104fd0:	ff 45 fc             	incl   -0x4(%ebp)
80104fd3:	eb 01                	jmp    80104fd6 <memmove+0x68>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104fd5:	90                   	nop
80104fd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fda:	0f 95 c0             	setne  %al
80104fdd:	ff 4d 10             	decl   0x10(%ebp)
80104fe0:	84 c0                	test   %al,%al
80104fe2:	75 df                	jne    80104fc3 <memmove+0x55>
      *d++ = *s++;

  return dst;
80104fe4:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104fe7:	c9                   	leave  
80104fe8:	c3                   	ret    

80104fe9 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104fe9:	55                   	push   %ebp
80104fea:	89 e5                	mov    %esp,%ebp
80104fec:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80104fef:	8b 45 10             	mov    0x10(%ebp),%eax
80104ff2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ff9:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ffd:	8b 45 08             	mov    0x8(%ebp),%eax
80105000:	89 04 24             	mov    %eax,(%esp)
80105003:	e8 66 ff ff ff       	call   80104f6e <memmove>
}
80105008:	c9                   	leave  
80105009:	c3                   	ret    

8010500a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010500a:	55                   	push   %ebp
8010500b:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010500d:	eb 09                	jmp    80105018 <strncmp+0xe>
    n--, p++, q++;
8010500f:	ff 4d 10             	decl   0x10(%ebp)
80105012:	ff 45 08             	incl   0x8(%ebp)
80105015:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105018:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010501c:	74 17                	je     80105035 <strncmp+0x2b>
8010501e:	8b 45 08             	mov    0x8(%ebp),%eax
80105021:	8a 00                	mov    (%eax),%al
80105023:	84 c0                	test   %al,%al
80105025:	74 0e                	je     80105035 <strncmp+0x2b>
80105027:	8b 45 08             	mov    0x8(%ebp),%eax
8010502a:	8a 10                	mov    (%eax),%dl
8010502c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010502f:	8a 00                	mov    (%eax),%al
80105031:	38 c2                	cmp    %al,%dl
80105033:	74 da                	je     8010500f <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105035:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105039:	75 07                	jne    80105042 <strncmp+0x38>
    return 0;
8010503b:	b8 00 00 00 00       	mov    $0x0,%eax
80105040:	eb 16                	jmp    80105058 <strncmp+0x4e>
  return (uchar)*p - (uchar)*q;
80105042:	8b 45 08             	mov    0x8(%ebp),%eax
80105045:	8a 00                	mov    (%eax),%al
80105047:	0f b6 d0             	movzbl %al,%edx
8010504a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010504d:	8a 00                	mov    (%eax),%al
8010504f:	0f b6 c0             	movzbl %al,%eax
80105052:	89 d1                	mov    %edx,%ecx
80105054:	29 c1                	sub    %eax,%ecx
80105056:	89 c8                	mov    %ecx,%eax
}
80105058:	5d                   	pop    %ebp
80105059:	c3                   	ret    

8010505a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010505a:	55                   	push   %ebp
8010505b:	89 e5                	mov    %esp,%ebp
8010505d:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105060:	8b 45 08             	mov    0x8(%ebp),%eax
80105063:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105066:	90                   	nop
80105067:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010506b:	0f 9f c0             	setg   %al
8010506e:	ff 4d 10             	decl   0x10(%ebp)
80105071:	84 c0                	test   %al,%al
80105073:	74 2b                	je     801050a0 <strncpy+0x46>
80105075:	8b 45 0c             	mov    0xc(%ebp),%eax
80105078:	8a 10                	mov    (%eax),%dl
8010507a:	8b 45 08             	mov    0x8(%ebp),%eax
8010507d:	88 10                	mov    %dl,(%eax)
8010507f:	8b 45 08             	mov    0x8(%ebp),%eax
80105082:	8a 00                	mov    (%eax),%al
80105084:	84 c0                	test   %al,%al
80105086:	0f 95 c0             	setne  %al
80105089:	ff 45 08             	incl   0x8(%ebp)
8010508c:	ff 45 0c             	incl   0xc(%ebp)
8010508f:	84 c0                	test   %al,%al
80105091:	75 d4                	jne    80105067 <strncpy+0xd>
    ;
  while(n-- > 0)
80105093:	eb 0b                	jmp    801050a0 <strncpy+0x46>
    *s++ = 0;
80105095:	8b 45 08             	mov    0x8(%ebp),%eax
80105098:	c6 00 00             	movb   $0x0,(%eax)
8010509b:	ff 45 08             	incl   0x8(%ebp)
8010509e:	eb 01                	jmp    801050a1 <strncpy+0x47>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801050a0:	90                   	nop
801050a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050a5:	0f 9f c0             	setg   %al
801050a8:	ff 4d 10             	decl   0x10(%ebp)
801050ab:	84 c0                	test   %al,%al
801050ad:	75 e6                	jne    80105095 <strncpy+0x3b>
    *s++ = 0;
  return os;
801050af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801050b2:	c9                   	leave  
801050b3:	c3                   	ret    

801050b4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801050b4:	55                   	push   %ebp
801050b5:	89 e5                	mov    %esp,%ebp
801050b7:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801050ba:	8b 45 08             	mov    0x8(%ebp),%eax
801050bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801050c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050c4:	7f 05                	jg     801050cb <safestrcpy+0x17>
    return os;
801050c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050c9:	eb 30                	jmp    801050fb <safestrcpy+0x47>
  while(--n > 0 && (*s++ = *t++) != 0)
801050cb:	ff 4d 10             	decl   0x10(%ebp)
801050ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050d2:	7e 1e                	jle    801050f2 <safestrcpy+0x3e>
801050d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801050d7:	8a 10                	mov    (%eax),%dl
801050d9:	8b 45 08             	mov    0x8(%ebp),%eax
801050dc:	88 10                	mov    %dl,(%eax)
801050de:	8b 45 08             	mov    0x8(%ebp),%eax
801050e1:	8a 00                	mov    (%eax),%al
801050e3:	84 c0                	test   %al,%al
801050e5:	0f 95 c0             	setne  %al
801050e8:	ff 45 08             	incl   0x8(%ebp)
801050eb:	ff 45 0c             	incl   0xc(%ebp)
801050ee:	84 c0                	test   %al,%al
801050f0:	75 d9                	jne    801050cb <safestrcpy+0x17>
    ;
  *s = 0;
801050f2:	8b 45 08             	mov    0x8(%ebp),%eax
801050f5:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801050f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801050fb:	c9                   	leave  
801050fc:	c3                   	ret    

801050fd <strlen>:

int
strlen(const char *s)
{
801050fd:	55                   	push   %ebp
801050fe:	89 e5                	mov    %esp,%ebp
80105100:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105103:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010510a:	eb 03                	jmp    8010510f <strlen+0x12>
8010510c:	ff 45 fc             	incl   -0x4(%ebp)
8010510f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105112:	8b 45 08             	mov    0x8(%ebp),%eax
80105115:	01 d0                	add    %edx,%eax
80105117:	8a 00                	mov    (%eax),%al
80105119:	84 c0                	test   %al,%al
8010511b:	75 ef                	jne    8010510c <strlen+0xf>
    ;
  return n;
8010511d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105120:	c9                   	leave  
80105121:	c3                   	ret    

80105122 <strcat>:

char *
strcat(char *dest, const char *src)
{
80105122:	55                   	push   %ebp
80105123:	89 e5                	mov    %esp,%ebp
80105125:	83 ec 10             	sub    $0x10,%esp
    char *rdest = dest;
80105128:	8b 45 08             	mov    0x8(%ebp),%eax
8010512b:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (*dest)
8010512e:	eb 03                	jmp    80105133 <strcat+0x11>
      dest++;
80105130:	ff 45 08             	incl   0x8(%ebp)
char *
strcat(char *dest, const char *src)
{
    char *rdest = dest;

    while (*dest)
80105133:	8b 45 08             	mov    0x8(%ebp),%eax
80105136:	8a 00                	mov    (%eax),%al
80105138:	84 c0                	test   %al,%al
8010513a:	75 f4                	jne    80105130 <strcat+0xe>
      dest++;
    while ((*dest++ = *src++))
8010513c:	90                   	nop
8010513d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105140:	8a 10                	mov    (%eax),%dl
80105142:	8b 45 08             	mov    0x8(%ebp),%eax
80105145:	88 10                	mov    %dl,(%eax)
80105147:	8b 45 08             	mov    0x8(%ebp),%eax
8010514a:	8a 00                	mov    (%eax),%al
8010514c:	84 c0                	test   %al,%al
8010514e:	0f 95 c0             	setne  %al
80105151:	ff 45 08             	incl   0x8(%ebp)
80105154:	ff 45 0c             	incl   0xc(%ebp)
80105157:	84 c0                	test   %al,%al
80105159:	75 e2                	jne    8010513d <strcat+0x1b>
      ;
    return rdest;
8010515b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010515e:	c9                   	leave  
8010515f:	c3                   	ret    

80105160 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105160:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105164:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105168:	55                   	push   %ebp
  pushl %ebx
80105169:	53                   	push   %ebx
  pushl %esi
8010516a:	56                   	push   %esi
  pushl %edi
8010516b:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010516c:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010516e:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105170:	5f                   	pop    %edi
  popl %esi
80105171:	5e                   	pop    %esi
  popl %ebx
80105172:	5b                   	pop    %ebx
  popl %ebp
80105173:	5d                   	pop    %ebp
  ret
80105174:	c3                   	ret    
80105175:	66 90                	xchg   %ax,%ax
80105177:	90                   	nop

80105178 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
80105178:	55                   	push   %ebp
80105179:	89 e5                	mov    %esp,%ebp
  if(addr >= p->sz || addr+4 > p->sz)
8010517b:	8b 45 08             	mov    0x8(%ebp),%eax
8010517e:	8b 00                	mov    (%eax),%eax
80105180:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105183:	76 0f                	jbe    80105194 <fetchint+0x1c>
80105185:	8b 45 0c             	mov    0xc(%ebp),%eax
80105188:	8d 50 04             	lea    0x4(%eax),%edx
8010518b:	8b 45 08             	mov    0x8(%ebp),%eax
8010518e:	8b 00                	mov    (%eax),%eax
80105190:	39 c2                	cmp    %eax,%edx
80105192:	76 07                	jbe    8010519b <fetchint+0x23>
    return -1;
80105194:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105199:	eb 0f                	jmp    801051aa <fetchint+0x32>
  *ip = *(int*)(addr);
8010519b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010519e:	8b 10                	mov    (%eax),%edx
801051a0:	8b 45 10             	mov    0x10(%ebp),%eax
801051a3:	89 10                	mov    %edx,(%eax)
  return 0;
801051a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801051aa:	5d                   	pop    %ebp
801051ab:	c3                   	ret    

801051ac <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
801051ac:	55                   	push   %ebp
801051ad:	89 e5                	mov    %esp,%ebp
801051af:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= p->sz)
801051b2:	8b 45 08             	mov    0x8(%ebp),%eax
801051b5:	8b 00                	mov    (%eax),%eax
801051b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
801051ba:	77 07                	ja     801051c3 <fetchstr+0x17>
    return -1;
801051bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c1:	eb 43                	jmp    80105206 <fetchstr+0x5a>
  *pp = (char*)addr;
801051c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801051c6:	8b 45 10             	mov    0x10(%ebp),%eax
801051c9:	89 10                	mov    %edx,(%eax)
  ep = (char*)p->sz;
801051cb:	8b 45 08             	mov    0x8(%ebp),%eax
801051ce:	8b 00                	mov    (%eax),%eax
801051d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801051d3:	8b 45 10             	mov    0x10(%ebp),%eax
801051d6:	8b 00                	mov    (%eax),%eax
801051d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
801051db:	eb 1c                	jmp    801051f9 <fetchstr+0x4d>
    if(*s == 0)
801051dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051e0:	8a 00                	mov    (%eax),%al
801051e2:	84 c0                	test   %al,%al
801051e4:	75 10                	jne    801051f6 <fetchstr+0x4a>
      return s - *pp;
801051e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801051e9:	8b 45 10             	mov    0x10(%ebp),%eax
801051ec:	8b 00                	mov    (%eax),%eax
801051ee:	89 d1                	mov    %edx,%ecx
801051f0:	29 c1                	sub    %eax,%ecx
801051f2:	89 c8                	mov    %ecx,%eax
801051f4:	eb 10                	jmp    80105206 <fetchstr+0x5a>

  if(addr >= p->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)p->sz;
  for(s = *pp; s < ep; s++)
801051f6:	ff 45 fc             	incl   -0x4(%ebp)
801051f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801051ff:	72 dc                	jb     801051dd <fetchstr+0x31>
    if(*s == 0)
      return s - *pp;
  return -1;
80105201:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105206:	c9                   	leave  
80105207:	c3                   	ret    

80105208 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105208:	55                   	push   %ebp
80105209:	89 e5                	mov    %esp,%ebp
8010520b:	83 ec 0c             	sub    $0xc,%esp
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
8010520e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105214:	8b 40 18             	mov    0x18(%eax),%eax
80105217:	8b 50 44             	mov    0x44(%eax),%edx
8010521a:	8b 45 08             	mov    0x8(%ebp),%eax
8010521d:	c1 e0 02             	shl    $0x2,%eax
80105220:	01 d0                	add    %edx,%eax
80105222:	8d 48 04             	lea    0x4(%eax),%ecx
80105225:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010522b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010522e:	89 54 24 08          	mov    %edx,0x8(%esp)
80105232:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80105236:	89 04 24             	mov    %eax,(%esp)
80105239:	e8 3a ff ff ff       	call   80105178 <fetchint>
}
8010523e:	c9                   	leave  
8010523f:	c3                   	ret    

80105240 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105246:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105249:	89 44 24 04          	mov    %eax,0x4(%esp)
8010524d:	8b 45 08             	mov    0x8(%ebp),%eax
80105250:	89 04 24             	mov    %eax,(%esp)
80105253:	e8 b0 ff ff ff       	call   80105208 <argint>
80105258:	85 c0                	test   %eax,%eax
8010525a:	79 07                	jns    80105263 <argptr+0x23>
    return -1;
8010525c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105261:	eb 3d                	jmp    801052a0 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105263:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105266:	89 c2                	mov    %eax,%edx
80105268:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010526e:	8b 00                	mov    (%eax),%eax
80105270:	39 c2                	cmp    %eax,%edx
80105272:	73 16                	jae    8010528a <argptr+0x4a>
80105274:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105277:	89 c2                	mov    %eax,%edx
80105279:	8b 45 10             	mov    0x10(%ebp),%eax
8010527c:	01 c2                	add    %eax,%edx
8010527e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105284:	8b 00                	mov    (%eax),%eax
80105286:	39 c2                	cmp    %eax,%edx
80105288:	76 07                	jbe    80105291 <argptr+0x51>
    return -1;
8010528a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528f:	eb 0f                	jmp    801052a0 <argptr+0x60>
  *pp = (char*)i;
80105291:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105294:	89 c2                	mov    %eax,%edx
80105296:	8b 45 0c             	mov    0xc(%ebp),%eax
80105299:	89 10                	mov    %edx,(%eax)
  return 0;
8010529b:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052a0:	c9                   	leave  
801052a1:	c3                   	ret    

801052a2 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801052a2:	55                   	push   %ebp
801052a3:	89 e5                	mov    %esp,%ebp
801052a5:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  if(argint(n, &addr) < 0)
801052a8:	8d 45 fc             	lea    -0x4(%ebp),%eax
801052ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801052af:	8b 45 08             	mov    0x8(%ebp),%eax
801052b2:	89 04 24             	mov    %eax,(%esp)
801052b5:	e8 4e ff ff ff       	call   80105208 <argint>
801052ba:	85 c0                	test   %eax,%eax
801052bc:	79 07                	jns    801052c5 <argstr+0x23>
    return -1;
801052be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052c3:	eb 1e                	jmp    801052e3 <argstr+0x41>
  return fetchstr(proc, addr, pp);
801052c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052c8:	89 c2                	mov    %eax,%edx
801052ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801052d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801052d7:	89 54 24 04          	mov    %edx,0x4(%esp)
801052db:	89 04 24             	mov    %eax,(%esp)
801052de:	e8 c9 fe ff ff       	call   801051ac <fetchstr>
}
801052e3:	c9                   	leave  
801052e4:	c3                   	ret    

801052e5 <syscall>:
};


void
syscall(void)
{
801052e5:	55                   	push   %ebp
801052e6:	89 e5                	mov    %esp,%ebp
801052e8:	53                   	push   %ebx
801052e9:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
801052ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052f2:	8b 40 18             	mov    0x18(%eax),%eax
801052f5:	8b 40 1c             	mov    0x1c(%eax),%eax
801052f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num >= 0 && num < SYS_open && syscalls[num]) {
801052fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801052ff:	78 2e                	js     8010532f <syscall+0x4a>
80105301:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
80105305:	7f 28                	jg     8010532f <syscall+0x4a>
80105307:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010530a:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105311:	85 c0                	test   %eax,%eax
80105313:	74 1a                	je     8010532f <syscall+0x4a>
    proc->tf->eax = syscalls[num]();
80105315:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010531b:	8b 58 18             	mov    0x18(%eax),%ebx
8010531e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105321:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105328:	ff d0                	call   *%eax
8010532a:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010532d:	eb 73                	jmp    801053a2 <syscall+0xbd>
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
8010532f:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
80105333:	7e 30                	jle    80105365 <syscall+0x80>
80105335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105338:	83 f8 16             	cmp    $0x16,%eax
8010533b:	77 28                	ja     80105365 <syscall+0x80>
8010533d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105340:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105347:	85 c0                	test   %eax,%eax
80105349:	74 1a                	je     80105365 <syscall+0x80>
    proc->tf->eax = syscalls[num]();
8010534b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105351:	8b 58 18             	mov    0x18(%eax),%ebx
80105354:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105357:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010535e:	ff d0                	call   *%eax
80105360:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105363:	eb 3d                	jmp    801053a2 <syscall+0xbd>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105365:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010536b:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010536e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(num >= 0 && num < SYS_open && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105374:	8b 40 10             	mov    0x10(%eax),%eax
80105377:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010537a:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010537e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105382:	89 44 24 04          	mov    %eax,0x4(%esp)
80105386:	c7 04 24 1b 86 10 80 	movl   $0x8010861b,(%esp)
8010538d:	e8 0f b0 ff ff       	call   801003a1 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105392:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105398:	8b 40 18             	mov    0x18(%eax),%eax
8010539b:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801053a2:	83 c4 24             	add    $0x24,%esp
801053a5:	5b                   	pop    %ebx
801053a6:	5d                   	pop    %ebp
801053a7:	c3                   	ret    

801053a8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801053a8:	55                   	push   %ebp
801053a9:	89 e5                	mov    %esp,%ebp
801053ab:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801053ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801053b5:	8b 45 08             	mov    0x8(%ebp),%eax
801053b8:	89 04 24             	mov    %eax,(%esp)
801053bb:	e8 48 fe ff ff       	call   80105208 <argint>
801053c0:	85 c0                	test   %eax,%eax
801053c2:	79 07                	jns    801053cb <argfd+0x23>
    return -1;
801053c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c9:	eb 50                	jmp    8010541b <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801053cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053ce:	85 c0                	test   %eax,%eax
801053d0:	78 21                	js     801053f3 <argfd+0x4b>
801053d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053d5:	83 f8 0f             	cmp    $0xf,%eax
801053d8:	7f 19                	jg     801053f3 <argfd+0x4b>
801053da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801053e3:	83 c2 08             	add    $0x8,%edx
801053e6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801053ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
801053ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801053f1:	75 07                	jne    801053fa <argfd+0x52>
    return -1;
801053f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053f8:	eb 21                	jmp    8010541b <argfd+0x73>
  if(pfd)
801053fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801053fe:	74 08                	je     80105408 <argfd+0x60>
    *pfd = fd;
80105400:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105403:	8b 45 0c             	mov    0xc(%ebp),%eax
80105406:	89 10                	mov    %edx,(%eax)
  if(pf)
80105408:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010540c:	74 08                	je     80105416 <argfd+0x6e>
    *pf = f;
8010540e:	8b 45 10             	mov    0x10(%ebp),%eax
80105411:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105414:	89 10                	mov    %edx,(%eax)
  return 0;
80105416:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010541b:	c9                   	leave  
8010541c:	c3                   	ret    

8010541d <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010541d:	55                   	push   %ebp
8010541e:	89 e5                	mov    %esp,%ebp
80105420:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105423:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010542a:	eb 2f                	jmp    8010545b <fdalloc+0x3e>
    if(proc->ofile[fd] == 0){
8010542c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105432:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105435:	83 c2 08             	add    $0x8,%edx
80105438:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010543c:	85 c0                	test   %eax,%eax
8010543e:	75 18                	jne    80105458 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105440:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105446:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105449:	8d 4a 08             	lea    0x8(%edx),%ecx
8010544c:	8b 55 08             	mov    0x8(%ebp),%edx
8010544f:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105453:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105456:	eb 0e                	jmp    80105466 <fdalloc+0x49>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105458:	ff 45 fc             	incl   -0x4(%ebp)
8010545b:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
8010545f:	7e cb                	jle    8010542c <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105466:	c9                   	leave  
80105467:	c3                   	ret    

80105468 <sys_dup>:

int
sys_dup(void)
{
80105468:	55                   	push   %ebp
80105469:	89 e5                	mov    %esp,%ebp
8010546b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010546e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105471:	89 44 24 08          	mov    %eax,0x8(%esp)
80105475:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010547c:	00 
8010547d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105484:	e8 1f ff ff ff       	call   801053a8 <argfd>
80105489:	85 c0                	test   %eax,%eax
8010548b:	79 07                	jns    80105494 <sys_dup+0x2c>
    return -1;
8010548d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105492:	eb 29                	jmp    801054bd <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105494:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105497:	89 04 24             	mov    %eax,(%esp)
8010549a:	e8 7e ff ff ff       	call   8010541d <fdalloc>
8010549f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801054a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801054a6:	79 07                	jns    801054af <sys_dup+0x47>
    return -1;
801054a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ad:	eb 0e                	jmp    801054bd <sys_dup+0x55>
  filedup(f);
801054af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054b2:	89 04 24             	mov    %eax,(%esp)
801054b5:	e8 7a bb ff ff       	call   80101034 <filedup>
  return fd;
801054ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801054bd:	c9                   	leave  
801054be:	c3                   	ret    

801054bf <sys_read>:

int
sys_read(void)
{
801054bf:	55                   	push   %ebp
801054c0:	89 e5                	mov    %esp,%ebp
801054c2:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054c8:	89 44 24 08          	mov    %eax,0x8(%esp)
801054cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801054d3:	00 
801054d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054db:	e8 c8 fe ff ff       	call   801053a8 <argfd>
801054e0:	85 c0                	test   %eax,%eax
801054e2:	78 35                	js     80105519 <sys_read+0x5a>
801054e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801054eb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801054f2:	e8 11 fd ff ff       	call   80105208 <argint>
801054f7:	85 c0                	test   %eax,%eax
801054f9:	78 1e                	js     80105519 <sys_read+0x5a>
801054fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054fe:	89 44 24 08          	mov    %eax,0x8(%esp)
80105502:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105505:	89 44 24 04          	mov    %eax,0x4(%esp)
80105509:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105510:	e8 2b fd ff ff       	call   80105240 <argptr>
80105515:	85 c0                	test   %eax,%eax
80105517:	79 07                	jns    80105520 <sys_read+0x61>
    return -1;
80105519:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551e:	eb 19                	jmp    80105539 <sys_read+0x7a>
  return fileread(f, p, n);
80105520:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105523:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105526:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105529:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010552d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105531:	89 04 24             	mov    %eax,(%esp)
80105534:	e8 5c bc ff ff       	call   80101195 <fileread>
}
80105539:	c9                   	leave  
8010553a:	c3                   	ret    

8010553b <sys_write>:

int
sys_write(void)
{
8010553b:	55                   	push   %ebp
8010553c:	89 e5                	mov    %esp,%ebp
8010553e:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105541:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105544:	89 44 24 08          	mov    %eax,0x8(%esp)
80105548:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010554f:	00 
80105550:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105557:	e8 4c fe ff ff       	call   801053a8 <argfd>
8010555c:	85 c0                	test   %eax,%eax
8010555e:	78 35                	js     80105595 <sys_write+0x5a>
80105560:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105563:	89 44 24 04          	mov    %eax,0x4(%esp)
80105567:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010556e:	e8 95 fc ff ff       	call   80105208 <argint>
80105573:	85 c0                	test   %eax,%eax
80105575:	78 1e                	js     80105595 <sys_write+0x5a>
80105577:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010557a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010557e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105581:	89 44 24 04          	mov    %eax,0x4(%esp)
80105585:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010558c:	e8 af fc ff ff       	call   80105240 <argptr>
80105591:	85 c0                	test   %eax,%eax
80105593:	79 07                	jns    8010559c <sys_write+0x61>
    return -1;
80105595:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010559a:	eb 19                	jmp    801055b5 <sys_write+0x7a>
  return filewrite(f, p, n);
8010559c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010559f:	8b 55 ec             	mov    -0x14(%ebp),%edx
801055a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055a5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801055a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801055ad:	89 04 24             	mov    %eax,(%esp)
801055b0:	e8 9b bc ff ff       	call   80101250 <filewrite>
}
801055b5:	c9                   	leave  
801055b6:	c3                   	ret    

801055b7 <sys_close>:

int
sys_close(void)
{
801055b7:	55                   	push   %ebp
801055b8:	89 e5                	mov    %esp,%ebp
801055ba:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801055bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055c0:	89 44 24 08          	mov    %eax,0x8(%esp)
801055c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801055cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055d2:	e8 d1 fd ff ff       	call   801053a8 <argfd>
801055d7:	85 c0                	test   %eax,%eax
801055d9:	79 07                	jns    801055e2 <sys_close+0x2b>
    return -1;
801055db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e0:	eb 24                	jmp    80105606 <sys_close+0x4f>
  proc->ofile[fd] = 0;
801055e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055eb:	83 c2 08             	add    $0x8,%edx
801055ee:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801055f5:	00 
  fileclose(f);
801055f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055f9:	89 04 24             	mov    %eax,(%esp)
801055fc:	e8 7b ba ff ff       	call   8010107c <fileclose>
  return 0;
80105601:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105606:	c9                   	leave  
80105607:	c3                   	ret    

80105608 <sys_fstat>:

int
sys_fstat(void)
{
80105608:	55                   	push   %ebp
80105609:	89 e5                	mov    %esp,%ebp
8010560b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010560e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105611:	89 44 24 08          	mov    %eax,0x8(%esp)
80105615:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010561c:	00 
8010561d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105624:	e8 7f fd ff ff       	call   801053a8 <argfd>
80105629:	85 c0                	test   %eax,%eax
8010562b:	78 1f                	js     8010564c <sys_fstat+0x44>
8010562d:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105634:	00 
80105635:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105638:	89 44 24 04          	mov    %eax,0x4(%esp)
8010563c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105643:	e8 f8 fb ff ff       	call   80105240 <argptr>
80105648:	85 c0                	test   %eax,%eax
8010564a:	79 07                	jns    80105653 <sys_fstat+0x4b>
    return -1;
8010564c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105651:	eb 12                	jmp    80105665 <sys_fstat+0x5d>
  return filestat(f, st);
80105653:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105656:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105659:	89 54 24 04          	mov    %edx,0x4(%esp)
8010565d:	89 04 24             	mov    %eax,(%esp)
80105660:	e8 e1 ba ff ff       	call   80101146 <filestat>
}
80105665:	c9                   	leave  
80105666:	c3                   	ret    

80105667 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105667:	55                   	push   %ebp
80105668:	89 e5                	mov    %esp,%ebp
8010566a:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010566d:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105670:	89 44 24 04          	mov    %eax,0x4(%esp)
80105674:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010567b:	e8 22 fc ff ff       	call   801052a2 <argstr>
80105680:	85 c0                	test   %eax,%eax
80105682:	78 17                	js     8010569b <sys_link+0x34>
80105684:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105687:	89 44 24 04          	mov    %eax,0x4(%esp)
8010568b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105692:	e8 0b fc ff ff       	call   801052a2 <argstr>
80105697:	85 c0                	test   %eax,%eax
80105699:	79 0a                	jns    801056a5 <sys_link+0x3e>
    return -1;
8010569b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a0:	e9 37 01 00 00       	jmp    801057dc <sys_link+0x175>
  if((ip = namei(old)) == 0)
801056a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
801056a8:	89 04 24             	mov    %eax,(%esp)
801056ab:	e8 ec cd ff ff       	call   8010249c <namei>
801056b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056b7:	75 0a                	jne    801056c3 <sys_link+0x5c>
    return -1;
801056b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056be:	e9 19 01 00 00       	jmp    801057dc <sys_link+0x175>

  begin_trans();
801056c3:	e8 c7 db ff ff       	call   8010328f <begin_trans>

  ilock(ip);
801056c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056cb:	89 04 24             	mov    %eax,(%esp)
801056ce:	e8 2f c2 ff ff       	call   80101902 <ilock>
  if(ip->type == T_DIR){
801056d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056d6:	8b 40 10             	mov    0x10(%eax),%eax
801056d9:	66 83 f8 01          	cmp    $0x1,%ax
801056dd:	75 1a                	jne    801056f9 <sys_link+0x92>
    iunlockput(ip);
801056df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056e2:	89 04 24             	mov    %eax,(%esp)
801056e5:	e8 99 c4 ff ff       	call   80101b83 <iunlockput>
    commit_trans();
801056ea:	e8 e9 db ff ff       	call   801032d8 <commit_trans>
    return -1;
801056ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f4:	e9 e3 00 00 00       	jmp    801057dc <sys_link+0x175>
  }

  ip->nlink++;
801056f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056fc:	66 8b 40 16          	mov    0x16(%eax),%ax
80105700:	40                   	inc    %eax
80105701:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105704:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105708:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010570b:	89 04 24             	mov    %eax,(%esp)
8010570e:	e8 35 c0 ff ff       	call   80101748 <iupdate>
  iunlock(ip);
80105713:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105716:	89 04 24             	mov    %eax,(%esp)
80105719:	e8 2f c3 ff ff       	call   80101a4d <iunlock>

  if((dp = nameiparent(new, name)) == 0)
8010571e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105721:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105724:	89 54 24 04          	mov    %edx,0x4(%esp)
80105728:	89 04 24             	mov    %eax,(%esp)
8010572b:	e8 8e cd ff ff       	call   801024be <nameiparent>
80105730:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105733:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105737:	74 68                	je     801057a1 <sys_link+0x13a>
    goto bad;
  ilock(dp);
80105739:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010573c:	89 04 24             	mov    %eax,(%esp)
8010573f:	e8 be c1 ff ff       	call   80101902 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105744:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105747:	8b 10                	mov    (%eax),%edx
80105749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010574c:	8b 00                	mov    (%eax),%eax
8010574e:	39 c2                	cmp    %eax,%edx
80105750:	75 20                	jne    80105772 <sys_link+0x10b>
80105752:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105755:	8b 40 04             	mov    0x4(%eax),%eax
80105758:	89 44 24 08          	mov    %eax,0x8(%esp)
8010575c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010575f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105763:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105766:	89 04 24             	mov    %eax,(%esp)
80105769:	e8 77 ca ff ff       	call   801021e5 <dirlink>
8010576e:	85 c0                	test   %eax,%eax
80105770:	79 0d                	jns    8010577f <sys_link+0x118>
    iunlockput(dp);
80105772:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105775:	89 04 24             	mov    %eax,(%esp)
80105778:	e8 06 c4 ff ff       	call   80101b83 <iunlockput>
    goto bad;
8010577d:	eb 23                	jmp    801057a2 <sys_link+0x13b>
  }
  iunlockput(dp);
8010577f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105782:	89 04 24             	mov    %eax,(%esp)
80105785:	e8 f9 c3 ff ff       	call   80101b83 <iunlockput>
  iput(ip);
8010578a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010578d:	89 04 24             	mov    %eax,(%esp)
80105790:	e8 1d c3 ff ff       	call   80101ab2 <iput>

  commit_trans();
80105795:	e8 3e db ff ff       	call   801032d8 <commit_trans>

  return 0;
8010579a:	b8 00 00 00 00       	mov    $0x0,%eax
8010579f:	eb 3b                	jmp    801057dc <sys_link+0x175>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
801057a1:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
801057a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057a5:	89 04 24             	mov    %eax,(%esp)
801057a8:	e8 55 c1 ff ff       	call   80101902 <ilock>
  ip->nlink--;
801057ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b0:	66 8b 40 16          	mov    0x16(%eax),%ax
801057b4:	48                   	dec    %eax
801057b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057b8:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
801057bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057bf:	89 04 24             	mov    %eax,(%esp)
801057c2:	e8 81 bf ff ff       	call   80101748 <iupdate>
  iunlockput(ip);
801057c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ca:	89 04 24             	mov    %eax,(%esp)
801057cd:	e8 b1 c3 ff ff       	call   80101b83 <iunlockput>
  commit_trans();
801057d2:	e8 01 db ff ff       	call   801032d8 <commit_trans>
  return -1;
801057d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057dc:	c9                   	leave  
801057dd:	c3                   	ret    

801057de <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801057de:	55                   	push   %ebp
801057df:	89 e5                	mov    %esp,%ebp
801057e1:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057e4:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801057eb:	eb 4a                	jmp    80105837 <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801057f7:	00 
801057f8:	89 44 24 08          	mov    %eax,0x8(%esp)
801057fc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80105803:	8b 45 08             	mov    0x8(%ebp),%eax
80105806:	89 04 24             	mov    %eax,(%esp)
80105809:	e8 fb c5 ff ff       	call   80101e09 <readi>
8010580e:	83 f8 10             	cmp    $0x10,%eax
80105811:	74 0c                	je     8010581f <isdirempty+0x41>
      panic("isdirempty: readi");
80105813:	c7 04 24 37 86 10 80 	movl   $0x80108637,(%esp)
8010581a:	e8 17 ad ff ff       	call   80100536 <panic>
    if(de.inum != 0)
8010581f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105822:	66 85 c0             	test   %ax,%ax
80105825:	74 07                	je     8010582e <isdirempty+0x50>
      return 0;
80105827:	b8 00 00 00 00       	mov    $0x0,%eax
8010582c:	eb 1b                	jmp    80105849 <isdirempty+0x6b>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010582e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105831:	83 c0 10             	add    $0x10,%eax
80105834:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105837:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010583a:	8b 45 08             	mov    0x8(%ebp),%eax
8010583d:	8b 40 18             	mov    0x18(%eax),%eax
80105840:	39 c2                	cmp    %eax,%edx
80105842:	72 a9                	jb     801057ed <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105844:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105849:	c9                   	leave  
8010584a:	c3                   	ret    

8010584b <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010584b:	55                   	push   %ebp
8010584c:	89 e5                	mov    %esp,%ebp
8010584e:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105851:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105854:	89 44 24 04          	mov    %eax,0x4(%esp)
80105858:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010585f:	e8 3e fa ff ff       	call   801052a2 <argstr>
80105864:	85 c0                	test   %eax,%eax
80105866:	79 0a                	jns    80105872 <sys_unlink+0x27>
    return -1;
80105868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010586d:	e9 a4 01 00 00       	jmp    80105a16 <sys_unlink+0x1cb>
  if((dp = nameiparent(path, name)) == 0)
80105872:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105875:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105878:	89 54 24 04          	mov    %edx,0x4(%esp)
8010587c:	89 04 24             	mov    %eax,(%esp)
8010587f:	e8 3a cc ff ff       	call   801024be <nameiparent>
80105884:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105887:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010588b:	75 0a                	jne    80105897 <sys_unlink+0x4c>
    return -1;
8010588d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105892:	e9 7f 01 00 00       	jmp    80105a16 <sys_unlink+0x1cb>

  begin_trans();
80105897:	e8 f3 d9 ff ff       	call   8010328f <begin_trans>

  ilock(dp);
8010589c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010589f:	89 04 24             	mov    %eax,(%esp)
801058a2:	e8 5b c0 ff ff       	call   80101902 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058a7:	c7 44 24 04 49 86 10 	movl   $0x80108649,0x4(%esp)
801058ae:	80 
801058af:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801058b2:	89 04 24             	mov    %eax,(%esp)
801058b5:	e8 44 c8 ff ff       	call   801020fe <namecmp>
801058ba:	85 c0                	test   %eax,%eax
801058bc:	0f 84 3f 01 00 00    	je     80105a01 <sys_unlink+0x1b6>
801058c2:	c7 44 24 04 4b 86 10 	movl   $0x8010864b,0x4(%esp)
801058c9:	80 
801058ca:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801058cd:	89 04 24             	mov    %eax,(%esp)
801058d0:	e8 29 c8 ff ff       	call   801020fe <namecmp>
801058d5:	85 c0                	test   %eax,%eax
801058d7:	0f 84 24 01 00 00    	je     80105a01 <sys_unlink+0x1b6>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801058dd:	8d 45 c8             	lea    -0x38(%ebp),%eax
801058e0:	89 44 24 08          	mov    %eax,0x8(%esp)
801058e4:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801058e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801058eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ee:	89 04 24             	mov    %eax,(%esp)
801058f1:	e8 2a c8 ff ff       	call   80102120 <dirlookup>
801058f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801058f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058fd:	0f 84 fd 00 00 00    	je     80105a00 <sys_unlink+0x1b5>
    goto bad;
  ilock(ip);
80105903:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105906:	89 04 24             	mov    %eax,(%esp)
80105909:	e8 f4 bf ff ff       	call   80101902 <ilock>

  if(ip->nlink < 1)
8010590e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105911:	66 8b 40 16          	mov    0x16(%eax),%ax
80105915:	66 85 c0             	test   %ax,%ax
80105918:	7f 0c                	jg     80105926 <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
8010591a:	c7 04 24 4e 86 10 80 	movl   $0x8010864e,(%esp)
80105921:	e8 10 ac ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105926:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105929:	8b 40 10             	mov    0x10(%eax),%eax
8010592c:	66 83 f8 01          	cmp    $0x1,%ax
80105930:	75 1f                	jne    80105951 <sys_unlink+0x106>
80105932:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105935:	89 04 24             	mov    %eax,(%esp)
80105938:	e8 a1 fe ff ff       	call   801057de <isdirempty>
8010593d:	85 c0                	test   %eax,%eax
8010593f:	75 10                	jne    80105951 <sys_unlink+0x106>
    iunlockput(ip);
80105941:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105944:	89 04 24             	mov    %eax,(%esp)
80105947:	e8 37 c2 ff ff       	call   80101b83 <iunlockput>
    goto bad;
8010594c:	e9 b0 00 00 00       	jmp    80105a01 <sys_unlink+0x1b6>
  }

  memset(&de, 0, sizeof(de));
80105951:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105958:	00 
80105959:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105960:	00 
80105961:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105964:	89 04 24             	mov    %eax,(%esp)
80105967:	e8 36 f5 ff ff       	call   80104ea2 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010596c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010596f:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105976:	00 
80105977:	89 44 24 08          	mov    %eax,0x8(%esp)
8010597b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010597e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105985:	89 04 24             	mov    %eax,(%esp)
80105988:	e8 e1 c5 ff ff       	call   80101f6e <writei>
8010598d:	83 f8 10             	cmp    $0x10,%eax
80105990:	74 0c                	je     8010599e <sys_unlink+0x153>
    panic("unlink: writei");
80105992:	c7 04 24 60 86 10 80 	movl   $0x80108660,(%esp)
80105999:	e8 98 ab ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR){
8010599e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059a1:	8b 40 10             	mov    0x10(%eax),%eax
801059a4:	66 83 f8 01          	cmp    $0x1,%ax
801059a8:	75 1a                	jne    801059c4 <sys_unlink+0x179>
    dp->nlink--;
801059aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ad:	66 8b 40 16          	mov    0x16(%eax),%ax
801059b1:	48                   	dec    %eax
801059b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059b5:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
801059b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059bc:	89 04 24             	mov    %eax,(%esp)
801059bf:	e8 84 bd ff ff       	call   80101748 <iupdate>
  }
  iunlockput(dp);
801059c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c7:	89 04 24             	mov    %eax,(%esp)
801059ca:	e8 b4 c1 ff ff       	call   80101b83 <iunlockput>

  ip->nlink--;
801059cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d2:	66 8b 40 16          	mov    0x16(%eax),%ax
801059d6:	48                   	dec    %eax
801059d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801059da:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
801059de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059e1:	89 04 24             	mov    %eax,(%esp)
801059e4:	e8 5f bd ff ff       	call   80101748 <iupdate>
  iunlockput(ip);
801059e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059ec:	89 04 24             	mov    %eax,(%esp)
801059ef:	e8 8f c1 ff ff       	call   80101b83 <iunlockput>

  commit_trans();
801059f4:	e8 df d8 ff ff       	call   801032d8 <commit_trans>

  return 0;
801059f9:	b8 00 00 00 00       	mov    $0x0,%eax
801059fe:	eb 16                	jmp    80105a16 <sys_unlink+0x1cb>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105a00:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
80105a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a04:	89 04 24             	mov    %eax,(%esp)
80105a07:	e8 77 c1 ff ff       	call   80101b83 <iunlockput>
  commit_trans();
80105a0c:	e8 c7 d8 ff ff       	call   801032d8 <commit_trans>
  return -1;
80105a11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a16:	c9                   	leave  
80105a17:	c3                   	ret    

80105a18 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105a18:	55                   	push   %ebp
80105a19:	89 e5                	mov    %esp,%ebp
80105a1b:	83 ec 48             	sub    $0x48,%esp
80105a1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105a21:	8b 55 10             	mov    0x10(%ebp),%edx
80105a24:	8b 45 14             	mov    0x14(%ebp),%eax
80105a27:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105a2b:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105a2f:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105a33:	8d 45 de             	lea    -0x22(%ebp),%eax
80105a36:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a3a:	8b 45 08             	mov    0x8(%ebp),%eax
80105a3d:	89 04 24             	mov    %eax,(%esp)
80105a40:	e8 79 ca ff ff       	call   801024be <nameiparent>
80105a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a4c:	75 0a                	jne    80105a58 <create+0x40>
    return 0;
80105a4e:	b8 00 00 00 00       	mov    $0x0,%eax
80105a53:	e9 79 01 00 00       	jmp    80105bd1 <create+0x1b9>
  ilock(dp);
80105a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a5b:	89 04 24             	mov    %eax,(%esp)
80105a5e:	e8 9f be ff ff       	call   80101902 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105a63:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a66:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a6a:	8d 45 de             	lea    -0x22(%ebp),%eax
80105a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a74:	89 04 24             	mov    %eax,(%esp)
80105a77:	e8 a4 c6 ff ff       	call   80102120 <dirlookup>
80105a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a83:	74 46                	je     80105acb <create+0xb3>
    iunlockput(dp);
80105a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a88:	89 04 24             	mov    %eax,(%esp)
80105a8b:	e8 f3 c0 ff ff       	call   80101b83 <iunlockput>
    ilock(ip);
80105a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a93:	89 04 24             	mov    %eax,(%esp)
80105a96:	e8 67 be ff ff       	call   80101902 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105a9b:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105aa0:	75 14                	jne    80105ab6 <create+0x9e>
80105aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aa5:	8b 40 10             	mov    0x10(%eax),%eax
80105aa8:	66 83 f8 02          	cmp    $0x2,%ax
80105aac:	75 08                	jne    80105ab6 <create+0x9e>
      return ip;
80105aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab1:	e9 1b 01 00 00       	jmp    80105bd1 <create+0x1b9>
    iunlockput(ip);
80105ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab9:	89 04 24             	mov    %eax,(%esp)
80105abc:	e8 c2 c0 ff ff       	call   80101b83 <iunlockput>
    return 0;
80105ac1:	b8 00 00 00 00       	mov    $0x0,%eax
80105ac6:	e9 06 01 00 00       	jmp    80105bd1 <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105acb:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad2:	8b 00                	mov    (%eax),%eax
80105ad4:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ad8:	89 04 24             	mov    %eax,(%esp)
80105adb:	e8 8c bb ff ff       	call   8010166c <ialloc>
80105ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ae3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ae7:	75 0c                	jne    80105af5 <create+0xdd>
    panic("create: ialloc");
80105ae9:	c7 04 24 6f 86 10 80 	movl   $0x8010866f,(%esp)
80105af0:	e8 41 aa ff ff       	call   80100536 <panic>

  ilock(ip);
80105af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af8:	89 04 24             	mov    %eax,(%esp)
80105afb:	e8 02 be ff ff       	call   80101902 <ilock>
  ip->major = major;
80105b00:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b03:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105b06:	66 89 42 12          	mov    %ax,0x12(%edx)
  ip->minor = minor;
80105b0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b0d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105b10:	66 89 42 14          	mov    %ax,0x14(%edx)
  ip->nlink = 1;
80105b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b17:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b20:	89 04 24             	mov    %eax,(%esp)
80105b23:	e8 20 bc ff ff       	call   80101748 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105b28:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105b2d:	75 68                	jne    80105b97 <create+0x17f>
    dp->nlink++;  // for ".."
80105b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b32:	66 8b 40 16          	mov    0x16(%eax),%ax
80105b36:	40                   	inc    %eax
80105b37:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b3a:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80105b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b41:	89 04 24             	mov    %eax,(%esp)
80105b44:	e8 ff bb ff ff       	call   80101748 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b4c:	8b 40 04             	mov    0x4(%eax),%eax
80105b4f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b53:	c7 44 24 04 49 86 10 	movl   $0x80108649,0x4(%esp)
80105b5a:	80 
80105b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b5e:	89 04 24             	mov    %eax,(%esp)
80105b61:	e8 7f c6 ff ff       	call   801021e5 <dirlink>
80105b66:	85 c0                	test   %eax,%eax
80105b68:	78 21                	js     80105b8b <create+0x173>
80105b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6d:	8b 40 04             	mov    0x4(%eax),%eax
80105b70:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b74:	c7 44 24 04 4b 86 10 	movl   $0x8010864b,0x4(%esp)
80105b7b:	80 
80105b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b7f:	89 04 24             	mov    %eax,(%esp)
80105b82:	e8 5e c6 ff ff       	call   801021e5 <dirlink>
80105b87:	85 c0                	test   %eax,%eax
80105b89:	79 0c                	jns    80105b97 <create+0x17f>
      panic("create dots");
80105b8b:	c7 04 24 7e 86 10 80 	movl   $0x8010867e,(%esp)
80105b92:	e8 9f a9 ff ff       	call   80100536 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b9a:	8b 40 04             	mov    0x4(%eax),%eax
80105b9d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ba1:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bab:	89 04 24             	mov    %eax,(%esp)
80105bae:	e8 32 c6 ff ff       	call   801021e5 <dirlink>
80105bb3:	85 c0                	test   %eax,%eax
80105bb5:	79 0c                	jns    80105bc3 <create+0x1ab>
    panic("create: dirlink");
80105bb7:	c7 04 24 8a 86 10 80 	movl   $0x8010868a,(%esp)
80105bbe:	e8 73 a9 ff ff       	call   80100536 <panic>

  iunlockput(dp);
80105bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc6:	89 04 24             	mov    %eax,(%esp)
80105bc9:	e8 b5 bf ff ff       	call   80101b83 <iunlockput>

  return ip;
80105bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105bd1:	c9                   	leave  
80105bd2:	c3                   	ret    

80105bd3 <sys_open>:

int
sys_open(void)
{
80105bd3:	55                   	push   %ebp
80105bd4:	89 e5                	mov    %esp,%ebp
80105bd6:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105bd9:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105be0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105be7:	e8 b6 f6 ff ff       	call   801052a2 <argstr>
80105bec:	85 c0                	test   %eax,%eax
80105bee:	78 17                	js     80105c07 <sys_open+0x34>
80105bf0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bf7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105bfe:	e8 05 f6 ff ff       	call   80105208 <argint>
80105c03:	85 c0                	test   %eax,%eax
80105c05:	79 0a                	jns    80105c11 <sys_open+0x3e>
    return -1;
80105c07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c0c:	e9 47 01 00 00       	jmp    80105d58 <sys_open+0x185>
  if(omode & O_CREATE){
80105c11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c14:	25 00 02 00 00       	and    $0x200,%eax
80105c19:	85 c0                	test   %eax,%eax
80105c1b:	74 40                	je     80105c5d <sys_open+0x8a>
    begin_trans();
80105c1d:	e8 6d d6 ff ff       	call   8010328f <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105c22:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c25:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105c2c:	00 
80105c2d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105c34:	00 
80105c35:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105c3c:	00 
80105c3d:	89 04 24             	mov    %eax,(%esp)
80105c40:	e8 d3 fd ff ff       	call   80105a18 <create>
80105c45:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105c48:	e8 8b d6 ff ff       	call   801032d8 <commit_trans>
    if(ip == 0)
80105c4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c51:	75 5b                	jne    80105cae <sys_open+0xdb>
      return -1;
80105c53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c58:	e9 fb 00 00 00       	jmp    80105d58 <sys_open+0x185>
  } else {
    if((ip = namei(path)) == 0)
80105c5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c60:	89 04 24             	mov    %eax,(%esp)
80105c63:	e8 34 c8 ff ff       	call   8010249c <namei>
80105c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c6f:	75 0a                	jne    80105c7b <sys_open+0xa8>
      return -1;
80105c71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c76:	e9 dd 00 00 00       	jmp    80105d58 <sys_open+0x185>
    ilock(ip);
80105c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c7e:	89 04 24             	mov    %eax,(%esp)
80105c81:	e8 7c bc ff ff       	call   80101902 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c89:	8b 40 10             	mov    0x10(%eax),%eax
80105c8c:	66 83 f8 01          	cmp    $0x1,%ax
80105c90:	75 1c                	jne    80105cae <sys_open+0xdb>
80105c92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c95:	85 c0                	test   %eax,%eax
80105c97:	74 15                	je     80105cae <sys_open+0xdb>
      iunlockput(ip);
80105c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c9c:	89 04 24             	mov    %eax,(%esp)
80105c9f:	e8 df be ff ff       	call   80101b83 <iunlockput>
      return -1;
80105ca4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca9:	e9 aa 00 00 00       	jmp    80105d58 <sys_open+0x185>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105cae:	e8 21 b3 ff ff       	call   80100fd4 <filealloc>
80105cb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cba:	74 14                	je     80105cd0 <sys_open+0xfd>
80105cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cbf:	89 04 24             	mov    %eax,(%esp)
80105cc2:	e8 56 f7 ff ff       	call   8010541d <fdalloc>
80105cc7:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105cca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105cce:	79 23                	jns    80105cf3 <sys_open+0x120>
    if(f)
80105cd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cd4:	74 0b                	je     80105ce1 <sys_open+0x10e>
      fileclose(f);
80105cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cd9:	89 04 24             	mov    %eax,(%esp)
80105cdc:	e8 9b b3 ff ff       	call   8010107c <fileclose>
    iunlockput(ip);
80105ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce4:	89 04 24             	mov    %eax,(%esp)
80105ce7:	e8 97 be ff ff       	call   80101b83 <iunlockput>
    return -1;
80105cec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cf1:	eb 65                	jmp    80105d58 <sys_open+0x185>
  }
  iunlock(ip);
80105cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cf6:	89 04 24             	mov    %eax,(%esp)
80105cf9:	e8 4f bd ff ff       	call   80101a4d <iunlock>

  f->type = FD_INODE;
80105cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d01:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d0d:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d13:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105d1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d1d:	83 e0 01             	and    $0x1,%eax
80105d20:	85 c0                	test   %eax,%eax
80105d22:	0f 94 c0             	sete   %al
80105d25:	88 c2                	mov    %al,%dl
80105d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d2a:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d30:	83 e0 01             	and    $0x1,%eax
80105d33:	85 c0                	test   %eax,%eax
80105d35:	75 0a                	jne    80105d41 <sys_open+0x16e>
80105d37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d3a:	83 e0 02             	and    $0x2,%eax
80105d3d:	85 c0                	test   %eax,%eax
80105d3f:	74 07                	je     80105d48 <sys_open+0x175>
80105d41:	b8 01 00 00 00       	mov    $0x1,%eax
80105d46:	eb 05                	jmp    80105d4d <sys_open+0x17a>
80105d48:	b8 00 00 00 00       	mov    $0x0,%eax
80105d4d:	88 c2                	mov    %al,%dl
80105d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d52:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105d58:	c9                   	leave  
80105d59:	c3                   	ret    

80105d5a <sys_mkdir>:

int
sys_mkdir(void)
{
80105d5a:	55                   	push   %ebp
80105d5b:	89 e5                	mov    %esp,%ebp
80105d5d:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105d60:	e8 2a d5 ff ff       	call   8010328f <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105d65:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d68:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d73:	e8 2a f5 ff ff       	call   801052a2 <argstr>
80105d78:	85 c0                	test   %eax,%eax
80105d7a:	78 2c                	js     80105da8 <sys_mkdir+0x4e>
80105d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d7f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105d86:	00 
80105d87:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105d8e:	00 
80105d8f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105d96:	00 
80105d97:	89 04 24             	mov    %eax,(%esp)
80105d9a:	e8 79 fc ff ff       	call   80105a18 <create>
80105d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105da2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105da6:	75 0c                	jne    80105db4 <sys_mkdir+0x5a>
    commit_trans();
80105da8:	e8 2b d5 ff ff       	call   801032d8 <commit_trans>
    return -1;
80105dad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105db2:	eb 15                	jmp    80105dc9 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db7:	89 04 24             	mov    %eax,(%esp)
80105dba:	e8 c4 bd ff ff       	call   80101b83 <iunlockput>
  commit_trans();
80105dbf:	e8 14 d5 ff ff       	call   801032d8 <commit_trans>
  return 0;
80105dc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105dc9:	c9                   	leave  
80105dca:	c3                   	ret    

80105dcb <sys_mknod>:

int
sys_mknod(void)
{
80105dcb:	55                   	push   %ebp
80105dcc:	89 e5                	mov    %esp,%ebp
80105dce:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80105dd1:	e8 b9 d4 ff ff       	call   8010328f <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80105dd6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ddd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105de4:	e8 b9 f4 ff ff       	call   801052a2 <argstr>
80105de9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105dec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105df0:	78 5e                	js     80105e50 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80105df2:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105df5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105df9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e00:	e8 03 f4 ff ff       	call   80105208 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105e05:	85 c0                	test   %eax,%eax
80105e07:	78 47                	js     80105e50 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105e09:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e10:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105e17:	e8 ec f3 ff ff       	call   80105208 <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105e1c:	85 c0                	test   %eax,%eax
80105e1e:	78 30                	js     80105e50 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e23:	0f bf c8             	movswl %ax,%ecx
80105e26:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e29:	0f bf d0             	movswl %ax,%edx
80105e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105e2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105e33:	89 54 24 08          	mov    %edx,0x8(%esp)
80105e37:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105e3e:	00 
80105e3f:	89 04 24             	mov    %eax,(%esp)
80105e42:	e8 d1 fb ff ff       	call   80105a18 <create>
80105e47:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e4e:	75 0c                	jne    80105e5c <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80105e50:	e8 83 d4 ff ff       	call   801032d8 <commit_trans>
    return -1;
80105e55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e5a:	eb 15                	jmp    80105e71 <sys_mknod+0xa6>
  }
  iunlockput(ip);
80105e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5f:	89 04 24             	mov    %eax,(%esp)
80105e62:	e8 1c bd ff ff       	call   80101b83 <iunlockput>
  commit_trans();
80105e67:	e8 6c d4 ff ff       	call   801032d8 <commit_trans>
  return 0;
80105e6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e71:	c9                   	leave  
80105e72:	c3                   	ret    

80105e73 <sys_chdir>:

int
sys_chdir(void)
{
80105e73:	55                   	push   %ebp
80105e74:	89 e5                	mov    %esp,%ebp
80105e76:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105e79:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e87:	e8 16 f4 ff ff       	call   801052a2 <argstr>
80105e8c:	85 c0                	test   %eax,%eax
80105e8e:	78 14                	js     80105ea4 <sys_chdir+0x31>
80105e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e93:	89 04 24             	mov    %eax,(%esp)
80105e96:	e8 01 c6 ff ff       	call   8010249c <namei>
80105e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ea2:	75 07                	jne    80105eab <sys_chdir+0x38>
    return -1;
80105ea4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ea9:	eb 56                	jmp    80105f01 <sys_chdir+0x8e>
  ilock(ip);
80105eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eae:	89 04 24             	mov    %eax,(%esp)
80105eb1:	e8 4c ba ff ff       	call   80101902 <ilock>
  if(ip->type != T_DIR){
80105eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb9:	8b 40 10             	mov    0x10(%eax),%eax
80105ebc:	66 83 f8 01          	cmp    $0x1,%ax
80105ec0:	74 12                	je     80105ed4 <sys_chdir+0x61>
    iunlockput(ip);
80105ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ec5:	89 04 24             	mov    %eax,(%esp)
80105ec8:	e8 b6 bc ff ff       	call   80101b83 <iunlockput>
    return -1;
80105ecd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ed2:	eb 2d                	jmp    80105f01 <sys_chdir+0x8e>
  }
  iunlock(ip);
80105ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed7:	89 04 24             	mov    %eax,(%esp)
80105eda:	e8 6e bb ff ff       	call   80101a4d <iunlock>
  iput(proc->cwd);
80105edf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ee5:	8b 40 68             	mov    0x68(%eax),%eax
80105ee8:	89 04 24             	mov    %eax,(%esp)
80105eeb:	e8 c2 bb ff ff       	call   80101ab2 <iput>
  proc->cwd = ip;
80105ef0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ef6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ef9:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105efc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f01:	c9                   	leave  
80105f02:	c3                   	ret    

80105f03 <sys_exec>:

int
sys_exec(void)
{
80105f03:	55                   	push   %ebp
80105f04:	89 e5                	mov    %esp,%ebp
80105f06:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f0c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f1a:	e8 83 f3 ff ff       	call   801052a2 <argstr>
80105f1f:	85 c0                	test   %eax,%eax
80105f21:	78 1a                	js     80105f3d <sys_exec+0x3a>
80105f23:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105f29:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f34:	e8 cf f2 ff ff       	call   80105208 <argint>
80105f39:	85 c0                	test   %eax,%eax
80105f3b:	79 0a                	jns    80105f47 <sys_exec+0x44>
    return -1;
80105f3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f42:	e9 dd 00 00 00       	jmp    80106024 <sys_exec+0x121>
  }
  memset(argv, 0, sizeof(argv));
80105f47:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105f4e:	00 
80105f4f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105f56:	00 
80105f57:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105f5d:	89 04 24             	mov    %eax,(%esp)
80105f60:	e8 3d ef ff ff       	call   80104ea2 <memset>
  for(i=0;; i++){
80105f65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f6f:	83 f8 1f             	cmp    $0x1f,%eax
80105f72:	76 0a                	jbe    80105f7e <sys_exec+0x7b>
      return -1;
80105f74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f79:	e9 a6 00 00 00       	jmp    80106024 <sys_exec+0x121>
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
80105f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f81:	c1 e0 02             	shl    $0x2,%eax
80105f84:	89 c2                	mov    %eax,%edx
80105f86:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105f8c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80105f8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f95:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
80105f9b:	89 54 24 08          	mov    %edx,0x8(%esp)
80105f9f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80105fa3:	89 04 24             	mov    %eax,(%esp)
80105fa6:	e8 cd f1 ff ff       	call   80105178 <fetchint>
80105fab:	85 c0                	test   %eax,%eax
80105fad:	79 07                	jns    80105fb6 <sys_exec+0xb3>
      return -1;
80105faf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb4:	eb 6e                	jmp    80106024 <sys_exec+0x121>
    if(uarg == 0){
80105fb6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105fbc:	85 c0                	test   %eax,%eax
80105fbe:	75 26                	jne    80105fe6 <sys_exec+0xe3>
      argv[i] = 0;
80105fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc3:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105fca:	00 00 00 00 
      break;
80105fce:	90                   	nop
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fd2:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105fd8:	89 54 24 04          	mov    %edx,0x4(%esp)
80105fdc:	89 04 24             	mov    %eax,(%esp)
80105fdf:	e8 e8 aa ff ff       	call   80100acc <exec>
80105fe4:	eb 3e                	jmp    80106024 <sys_exec+0x121>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
80105fe6:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105fec:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fef:	c1 e2 02             	shl    $0x2,%edx
80105ff2:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
80105ff5:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
80105ffb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106001:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106005:	89 54 24 04          	mov    %edx,0x4(%esp)
80106009:	89 04 24             	mov    %eax,(%esp)
8010600c:	e8 9b f1 ff ff       	call   801051ac <fetchstr>
80106011:	85 c0                	test   %eax,%eax
80106013:	79 07                	jns    8010601c <sys_exec+0x119>
      return -1;
80106015:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010601a:	eb 08                	jmp    80106024 <sys_exec+0x121>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
8010601c:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
8010601f:	e9 48 ff ff ff       	jmp    80105f6c <sys_exec+0x69>
  return exec(path, argv);
}
80106024:	c9                   	leave  
80106025:	c3                   	ret    

80106026 <sys_pipe>:

int
sys_pipe(void)
{
80106026:	55                   	push   %ebp
80106027:	89 e5                	mov    %esp,%ebp
80106029:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010602c:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106033:	00 
80106034:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106037:	89 44 24 04          	mov    %eax,0x4(%esp)
8010603b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106042:	e8 f9 f1 ff ff       	call   80105240 <argptr>
80106047:	85 c0                	test   %eax,%eax
80106049:	79 0a                	jns    80106055 <sys_pipe+0x2f>
    return -1;
8010604b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106050:	e9 9b 00 00 00       	jmp    801060f0 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106055:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106058:	89 44 24 04          	mov    %eax,0x4(%esp)
8010605c:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010605f:	89 04 24             	mov    %eax,(%esp)
80106062:	e8 81 dc ff ff       	call   80103ce8 <pipealloc>
80106067:	85 c0                	test   %eax,%eax
80106069:	79 07                	jns    80106072 <sys_pipe+0x4c>
    return -1;
8010606b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106070:	eb 7e                	jmp    801060f0 <sys_pipe+0xca>
  fd0 = -1;
80106072:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106079:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010607c:	89 04 24             	mov    %eax,(%esp)
8010607f:	e8 99 f3 ff ff       	call   8010541d <fdalloc>
80106084:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106087:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010608b:	78 14                	js     801060a1 <sys_pipe+0x7b>
8010608d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106090:	89 04 24             	mov    %eax,(%esp)
80106093:	e8 85 f3 ff ff       	call   8010541d <fdalloc>
80106098:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010609b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010609f:	79 37                	jns    801060d8 <sys_pipe+0xb2>
    if(fd0 >= 0)
801060a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060a5:	78 14                	js     801060bb <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
801060a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801060ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060b0:	83 c2 08             	add    $0x8,%edx
801060b3:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801060ba:	00 
    fileclose(rf);
801060bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060be:	89 04 24             	mov    %eax,(%esp)
801060c1:	e8 b6 af ff ff       	call   8010107c <fileclose>
    fileclose(wf);
801060c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060c9:	89 04 24             	mov    %eax,(%esp)
801060cc:	e8 ab af ff ff       	call   8010107c <fileclose>
    return -1;
801060d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060d6:	eb 18                	jmp    801060f0 <sys_pipe+0xca>
  }
  fd[0] = fd0;
801060d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801060db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060de:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801060e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801060e3:	8d 50 04             	lea    0x4(%eax),%edx
801060e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060e9:	89 02                	mov    %eax,(%edx)
  return 0;
801060eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060f0:	c9                   	leave  
801060f1:	c3                   	ret    
801060f2:	66 90                	xchg   %ax,%ax

801060f4 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801060f4:	55                   	push   %ebp
801060f5:	89 e5                	mov    %esp,%ebp
801060f7:	83 ec 08             	sub    $0x8,%esp
  return fork();
801060fa:	e8 9f e2 ff ff       	call   8010439e <fork>
}
801060ff:	c9                   	leave  
80106100:	c3                   	ret    

80106101 <sys_exit>:

int
sys_exit(void)
{
80106101:	55                   	push   %ebp
80106102:	89 e5                	mov    %esp,%ebp
80106104:	83 ec 08             	sub    $0x8,%esp
  exit();
80106107:	e8 f4 e3 ff ff       	call   80104500 <exit>
  return 0;  // not reached
8010610c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106111:	c9                   	leave  
80106112:	c3                   	ret    

80106113 <sys_wait>:

int
sys_wait(void)
{
80106113:	55                   	push   %ebp
80106114:	89 e5                	mov    %esp,%ebp
80106116:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106119:	e8 f9 e4 ff ff       	call   80104617 <wait>
}
8010611e:	c9                   	leave  
8010611f:	c3                   	ret    

80106120 <sys_kill>:

int
sys_kill(void)
{
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106126:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106129:	89 44 24 04          	mov    %eax,0x4(%esp)
8010612d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106134:	e8 cf f0 ff ff       	call   80105208 <argint>
80106139:	85 c0                	test   %eax,%eax
8010613b:	79 07                	jns    80106144 <sys_kill+0x24>
    return -1;
8010613d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106142:	eb 0b                	jmp    8010614f <sys_kill+0x2f>
  return kill(pid);
80106144:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106147:	89 04 24             	mov    %eax,(%esp)
8010614a:	e8 28 e9 ff ff       	call   80104a77 <kill>
}
8010614f:	c9                   	leave  
80106150:	c3                   	ret    

80106151 <sys_getpid>:

int
sys_getpid(void)
{
80106151:	55                   	push   %ebp
80106152:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106154:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010615a:	8b 40 10             	mov    0x10(%eax),%eax
}
8010615d:	5d                   	pop    %ebp
8010615e:	c3                   	ret    

8010615f <sys_sbrk>:

int
sys_sbrk(void)
{
8010615f:	55                   	push   %ebp
80106160:	89 e5                	mov    %esp,%ebp
80106162:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106165:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106168:	89 44 24 04          	mov    %eax,0x4(%esp)
8010616c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106173:	e8 90 f0 ff ff       	call   80105208 <argint>
80106178:	85 c0                	test   %eax,%eax
8010617a:	79 07                	jns    80106183 <sys_sbrk+0x24>
    return -1;
8010617c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106181:	eb 24                	jmp    801061a7 <sys_sbrk+0x48>
  addr = proc->sz;
80106183:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106189:	8b 00                	mov    (%eax),%eax
8010618b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
8010618e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106191:	89 04 24             	mov    %eax,(%esp)
80106194:	e8 60 e1 ff ff       	call   801042f9 <growproc>
80106199:	85 c0                	test   %eax,%eax
8010619b:	79 07                	jns    801061a4 <sys_sbrk+0x45>
    return -1;
8010619d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061a2:	eb 03                	jmp    801061a7 <sys_sbrk+0x48>
  return addr;
801061a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801061a7:	c9                   	leave  
801061a8:	c3                   	ret    

801061a9 <sys_sleep>:

int
sys_sleep(void)
{
801061a9:	55                   	push   %ebp
801061aa:	89 e5                	mov    %esp,%ebp
801061ac:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801061af:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801061b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061bd:	e8 46 f0 ff ff       	call   80105208 <argint>
801061c2:	85 c0                	test   %eax,%eax
801061c4:	79 07                	jns    801061cd <sys_sleep+0x24>
    return -1;
801061c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061cb:	eb 6c                	jmp    80106239 <sys_sleep+0x90>
  acquire(&tickslock);
801061cd:	c7 04 24 80 23 11 80 	movl   $0x80112380,(%esp)
801061d4:	e8 76 ea ff ff       	call   80104c4f <acquire>
  ticks0 = ticks;
801061d9:	a1 c0 2b 11 80       	mov    0x80112bc0,%eax
801061de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801061e1:	eb 34                	jmp    80106217 <sys_sleep+0x6e>
    if(proc->killed){
801061e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061e9:	8b 40 24             	mov    0x24(%eax),%eax
801061ec:	85 c0                	test   %eax,%eax
801061ee:	74 13                	je     80106203 <sys_sleep+0x5a>
      release(&tickslock);
801061f0:	c7 04 24 80 23 11 80 	movl   $0x80112380,(%esp)
801061f7:	e8 b5 ea ff ff       	call   80104cb1 <release>
      return -1;
801061fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106201:	eb 36                	jmp    80106239 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106203:	c7 44 24 04 80 23 11 	movl   $0x80112380,0x4(%esp)
8010620a:	80 
8010620b:	c7 04 24 c0 2b 11 80 	movl   $0x80112bc0,(%esp)
80106212:	e8 5c e7 ff ff       	call   80104973 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106217:	a1 c0 2b 11 80       	mov    0x80112bc0,%eax
8010621c:	89 c2                	mov    %eax,%edx
8010621e:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106221:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106224:	39 c2                	cmp    %eax,%edx
80106226:	72 bb                	jb     801061e3 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106228:	c7 04 24 80 23 11 80 	movl   $0x80112380,(%esp)
8010622f:	e8 7d ea ff ff       	call   80104cb1 <release>
  return 0;
80106234:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106239:	c9                   	leave  
8010623a:	c3                   	ret    

8010623b <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010623b:	55                   	push   %ebp
8010623c:	89 e5                	mov    %esp,%ebp
8010623e:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106241:	c7 04 24 80 23 11 80 	movl   $0x80112380,(%esp)
80106248:	e8 02 ea ff ff       	call   80104c4f <acquire>
  xticks = ticks;
8010624d:	a1 c0 2b 11 80       	mov    0x80112bc0,%eax
80106252:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106255:	c7 04 24 80 23 11 80 	movl   $0x80112380,(%esp)
8010625c:	e8 50 ea ff ff       	call   80104cb1 <release>
  return xticks;
80106261:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106264:	c9                   	leave  
80106265:	c3                   	ret    

80106266 <sys_addpath>:

//This system call adds the path entry to the existing environment variable path. The system
//call returns 0 upon success and -1 upon failure (all path entries in use).
int sys_addpath(char* path)
{
80106266:	55                   	push   %ebp
80106267:	89 e5                	mov    %esp,%ebp
80106269:	83 ec 28             	sub    $0x28,%esp
   char ** pathPtr = 0;
8010626c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
   if (argstr(0,pathPtr) < -1)
80106273:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106276:	89 44 24 04          	mov    %eax,0x4(%esp)
8010627a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106281:	e8 1c f0 ff ff       	call   801052a2 <argstr>
80106286:	83 f8 ff             	cmp    $0xffffffff,%eax
80106289:	7d 07                	jge    80106292 <sys_addpath+0x2c>
       return -1;
8010628b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106290:	eb 0d                	jmp    8010629f <sys_addpath+0x39>
    return add_path(*pathPtr);
80106292:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106295:	8b 00                	mov    (%eax),%eax
80106297:	89 04 24             	mov    %eax,(%esp)
8010629a:	e8 c2 ac ff ff       	call   80100f61 <add_path>
}
8010629f:	c9                   	leave  
801062a0:	c3                   	ret    
801062a1:	66 90                	xchg   %ax,%ax
801062a3:	90                   	nop

801062a4 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801062a4:	55                   	push   %ebp
801062a5:	89 e5                	mov    %esp,%ebp
801062a7:	83 ec 08             	sub    $0x8,%esp
801062aa:	8b 45 08             	mov    0x8(%ebp),%eax
801062ad:	8b 55 0c             	mov    0xc(%ebp),%edx
801062b0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801062b4:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062b7:	8a 45 f8             	mov    -0x8(%ebp),%al
801062ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
801062bd:	ee                   	out    %al,(%dx)
}
801062be:	c9                   	leave  
801062bf:	c3                   	ret    

801062c0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801062c6:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801062cd:	00 
801062ce:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801062d5:	e8 ca ff ff ff       	call   801062a4 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801062da:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
801062e1:	00 
801062e2:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801062e9:	e8 b6 ff ff ff       	call   801062a4 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801062ee:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
801062f5:	00 
801062f6:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801062fd:	e8 a2 ff ff ff       	call   801062a4 <outb>
  picenable(IRQ_TIMER);
80106302:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106309:	e8 66 d8 ff ff       	call   80103b74 <picenable>
}
8010630e:	c9                   	leave  
8010630f:	c3                   	ret    

80106310 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106310:	1e                   	push   %ds
  pushl %es
80106311:	06                   	push   %es
  pushl %fs
80106312:	0f a0                	push   %fs
  pushl %gs
80106314:	0f a8                	push   %gs
  pushal
80106316:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106317:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010631b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010631d:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010631f:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106323:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106325:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106327:	54                   	push   %esp
  call trap
80106328:	e8 c5 01 00 00       	call   801064f2 <trap>
  addl $4, %esp
8010632d:	83 c4 04             	add    $0x4,%esp

80106330 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106330:	61                   	popa   
  popl %gs
80106331:	0f a9                	pop    %gs
  popl %fs
80106333:	0f a1                	pop    %fs
  popl %es
80106335:	07                   	pop    %es
  popl %ds
80106336:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106337:	83 c4 08             	add    $0x8,%esp
  iret
8010633a:	cf                   	iret   
8010633b:	90                   	nop

8010633c <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
8010633c:	55                   	push   %ebp
8010633d:	89 e5                	mov    %esp,%ebp
8010633f:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106342:	8b 45 0c             	mov    0xc(%ebp),%eax
80106345:	48                   	dec    %eax
80106346:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010634a:	8b 45 08             	mov    0x8(%ebp),%eax
8010634d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106351:	8b 45 08             	mov    0x8(%ebp),%eax
80106354:	c1 e8 10             	shr    $0x10,%eax
80106357:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010635b:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010635e:	0f 01 18             	lidtl  (%eax)
}
80106361:	c9                   	leave  
80106362:	c3                   	ret    

80106363 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106363:	55                   	push   %ebp
80106364:	89 e5                	mov    %esp,%ebp
80106366:	53                   	push   %ebx
80106367:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010636a:	0f 20 d3             	mov    %cr2,%ebx
8010636d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
80106370:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80106373:	83 c4 10             	add    $0x10,%esp
80106376:	5b                   	pop    %ebx
80106377:	5d                   	pop    %ebp
80106378:	c3                   	ret    

80106379 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106379:	55                   	push   %ebp
8010637a:	89 e5                	mov    %esp,%ebp
8010637c:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010637f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106386:	e9 b8 00 00 00       	jmp    80106443 <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010638b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010638e:	8b 04 85 9c b0 10 80 	mov    -0x7fef4f64(,%eax,4),%eax
80106395:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106398:	66 89 04 d5 c0 23 11 	mov    %ax,-0x7feedc40(,%edx,8)
8010639f:	80 
801063a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a3:	66 c7 04 c5 c2 23 11 	movw   $0x8,-0x7feedc3e(,%eax,8)
801063aa:	80 08 00 
801063ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b0:	8a 14 c5 c4 23 11 80 	mov    -0x7feedc3c(,%eax,8),%dl
801063b7:	83 e2 e0             	and    $0xffffffe0,%edx
801063ba:	88 14 c5 c4 23 11 80 	mov    %dl,-0x7feedc3c(,%eax,8)
801063c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063c4:	8a 14 c5 c4 23 11 80 	mov    -0x7feedc3c(,%eax,8),%dl
801063cb:	83 e2 1f             	and    $0x1f,%edx
801063ce:	88 14 c5 c4 23 11 80 	mov    %dl,-0x7feedc3c(,%eax,8)
801063d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d8:	8a 14 c5 c5 23 11 80 	mov    -0x7feedc3b(,%eax,8),%dl
801063df:	83 e2 f0             	and    $0xfffffff0,%edx
801063e2:	83 ca 0e             	or     $0xe,%edx
801063e5:	88 14 c5 c5 23 11 80 	mov    %dl,-0x7feedc3b(,%eax,8)
801063ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ef:	8a 14 c5 c5 23 11 80 	mov    -0x7feedc3b(,%eax,8),%dl
801063f6:	83 e2 ef             	and    $0xffffffef,%edx
801063f9:	88 14 c5 c5 23 11 80 	mov    %dl,-0x7feedc3b(,%eax,8)
80106400:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106403:	8a 14 c5 c5 23 11 80 	mov    -0x7feedc3b(,%eax,8),%dl
8010640a:	83 e2 9f             	and    $0xffffff9f,%edx
8010640d:	88 14 c5 c5 23 11 80 	mov    %dl,-0x7feedc3b(,%eax,8)
80106414:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106417:	8a 14 c5 c5 23 11 80 	mov    -0x7feedc3b(,%eax,8),%dl
8010641e:	83 ca 80             	or     $0xffffff80,%edx
80106421:	88 14 c5 c5 23 11 80 	mov    %dl,-0x7feedc3b(,%eax,8)
80106428:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010642b:	8b 04 85 9c b0 10 80 	mov    -0x7fef4f64(,%eax,4),%eax
80106432:	c1 e8 10             	shr    $0x10,%eax
80106435:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106438:	66 89 04 d5 c6 23 11 	mov    %ax,-0x7feedc3a(,%edx,8)
8010643f:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106440:	ff 45 f4             	incl   -0xc(%ebp)
80106443:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010644a:	0f 8e 3b ff ff ff    	jle    8010638b <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106450:	a1 9c b1 10 80       	mov    0x8010b19c,%eax
80106455:	66 a3 c0 25 11 80    	mov    %ax,0x801125c0
8010645b:	66 c7 05 c2 25 11 80 	movw   $0x8,0x801125c2
80106462:	08 00 
80106464:	a0 c4 25 11 80       	mov    0x801125c4,%al
80106469:	83 e0 e0             	and    $0xffffffe0,%eax
8010646c:	a2 c4 25 11 80       	mov    %al,0x801125c4
80106471:	a0 c4 25 11 80       	mov    0x801125c4,%al
80106476:	83 e0 1f             	and    $0x1f,%eax
80106479:	a2 c4 25 11 80       	mov    %al,0x801125c4
8010647e:	a0 c5 25 11 80       	mov    0x801125c5,%al
80106483:	83 c8 0f             	or     $0xf,%eax
80106486:	a2 c5 25 11 80       	mov    %al,0x801125c5
8010648b:	a0 c5 25 11 80       	mov    0x801125c5,%al
80106490:	83 e0 ef             	and    $0xffffffef,%eax
80106493:	a2 c5 25 11 80       	mov    %al,0x801125c5
80106498:	a0 c5 25 11 80       	mov    0x801125c5,%al
8010649d:	83 c8 60             	or     $0x60,%eax
801064a0:	a2 c5 25 11 80       	mov    %al,0x801125c5
801064a5:	a0 c5 25 11 80       	mov    0x801125c5,%al
801064aa:	83 c8 80             	or     $0xffffff80,%eax
801064ad:	a2 c5 25 11 80       	mov    %al,0x801125c5
801064b2:	a1 9c b1 10 80       	mov    0x8010b19c,%eax
801064b7:	c1 e8 10             	shr    $0x10,%eax
801064ba:	66 a3 c6 25 11 80    	mov    %ax,0x801125c6
  
  initlock(&tickslock, "time");
801064c0:	c7 44 24 04 9c 86 10 	movl   $0x8010869c,0x4(%esp)
801064c7:	80 
801064c8:	c7 04 24 80 23 11 80 	movl   $0x80112380,(%esp)
801064cf:	e8 5a e7 ff ff       	call   80104c2e <initlock>
}
801064d4:	c9                   	leave  
801064d5:	c3                   	ret    

801064d6 <idtinit>:

void
idtinit(void)
{
801064d6:	55                   	push   %ebp
801064d7:	89 e5                	mov    %esp,%ebp
801064d9:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801064dc:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801064e3:	00 
801064e4:	c7 04 24 c0 23 11 80 	movl   $0x801123c0,(%esp)
801064eb:	e8 4c fe ff ff       	call   8010633c <lidt>
}
801064f0:	c9                   	leave  
801064f1:	c3                   	ret    

801064f2 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801064f2:	55                   	push   %ebp
801064f3:	89 e5                	mov    %esp,%ebp
801064f5:	57                   	push   %edi
801064f6:	56                   	push   %esi
801064f7:	53                   	push   %ebx
801064f8:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
801064fb:	8b 45 08             	mov    0x8(%ebp),%eax
801064fe:	8b 40 30             	mov    0x30(%eax),%eax
80106501:	83 f8 40             	cmp    $0x40,%eax
80106504:	75 3e                	jne    80106544 <trap+0x52>
    if(proc->killed)
80106506:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010650c:	8b 40 24             	mov    0x24(%eax),%eax
8010650f:	85 c0                	test   %eax,%eax
80106511:	74 05                	je     80106518 <trap+0x26>
      exit();
80106513:	e8 e8 df ff ff       	call   80104500 <exit>
    proc->tf = tf;
80106518:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010651e:	8b 55 08             	mov    0x8(%ebp),%edx
80106521:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106524:	e8 bc ed ff ff       	call   801052e5 <syscall>
    if(proc->killed)
80106529:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010652f:	8b 40 24             	mov    0x24(%eax),%eax
80106532:	85 c0                	test   %eax,%eax
80106534:	0f 84 2a 02 00 00    	je     80106764 <trap+0x272>
      exit();
8010653a:	e8 c1 df ff ff       	call   80104500 <exit>
    return;
8010653f:	e9 20 02 00 00       	jmp    80106764 <trap+0x272>
  }

  switch(tf->trapno){
80106544:	8b 45 08             	mov    0x8(%ebp),%eax
80106547:	8b 40 30             	mov    0x30(%eax),%eax
8010654a:	83 e8 20             	sub    $0x20,%eax
8010654d:	83 f8 1f             	cmp    $0x1f,%eax
80106550:	0f 87 b7 00 00 00    	ja     8010660d <trap+0x11b>
80106556:	8b 04 85 44 87 10 80 	mov    -0x7fef78bc(,%eax,4),%eax
8010655d:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
8010655f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106565:	8a 00                	mov    (%eax),%al
80106567:	84 c0                	test   %al,%al
80106569:	75 2f                	jne    8010659a <trap+0xa8>
      acquire(&tickslock);
8010656b:	c7 04 24 80 23 11 80 	movl   $0x80112380,(%esp)
80106572:	e8 d8 e6 ff ff       	call   80104c4f <acquire>
      ticks++;
80106577:	a1 c0 2b 11 80       	mov    0x80112bc0,%eax
8010657c:	40                   	inc    %eax
8010657d:	a3 c0 2b 11 80       	mov    %eax,0x80112bc0
      wakeup(&ticks);
80106582:	c7 04 24 c0 2b 11 80 	movl   $0x80112bc0,(%esp)
80106589:	e8 be e4 ff ff       	call   80104a4c <wakeup>
      release(&tickslock);
8010658e:	c7 04 24 80 23 11 80 	movl   $0x80112380,(%esp)
80106595:	e8 17 e7 ff ff       	call   80104cb1 <release>
    }
    lapiceoi();
8010659a:	e8 c2 c9 ff ff       	call   80102f61 <lapiceoi>
    break;
8010659f:	e9 3c 01 00 00       	jmp    801066e0 <trap+0x1ee>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801065a4:	e8 d1 c1 ff ff       	call   8010277a <ideintr>
    lapiceoi();
801065a9:	e8 b3 c9 ff ff       	call   80102f61 <lapiceoi>
    break;
801065ae:	e9 2d 01 00 00       	jmp    801066e0 <trap+0x1ee>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801065b3:	e8 8b c7 ff ff       	call   80102d43 <kbdintr>
    lapiceoi();
801065b8:	e8 a4 c9 ff ff       	call   80102f61 <lapiceoi>
    break;
801065bd:	e9 1e 01 00 00       	jmp    801066e0 <trap+0x1ee>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801065c2:	e8 9d 03 00 00       	call   80106964 <uartintr>
    lapiceoi();
801065c7:	e8 95 c9 ff ff       	call   80102f61 <lapiceoi>
    break;
801065cc:	e9 0f 01 00 00       	jmp    801066e0 <trap+0x1ee>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
801065d1:	8b 45 08             	mov    0x8(%ebp),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801065d4:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801065d7:	8b 45 08             	mov    0x8(%ebp),%eax
801065da:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801065dd:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801065e0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801065e6:	8a 00                	mov    (%eax),%al
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801065e8:	0f b6 c0             	movzbl %al,%eax
801065eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801065ef:	89 54 24 08          	mov    %edx,0x8(%esp)
801065f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801065f7:	c7 04 24 a4 86 10 80 	movl   $0x801086a4,(%esp)
801065fe:	e8 9e 9d ff ff       	call   801003a1 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106603:	e8 59 c9 ff ff       	call   80102f61 <lapiceoi>
    break;
80106608:	e9 d3 00 00 00       	jmp    801066e0 <trap+0x1ee>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010660d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106613:	85 c0                	test   %eax,%eax
80106615:	74 10                	je     80106627 <trap+0x135>
80106617:	8b 45 08             	mov    0x8(%ebp),%eax
8010661a:	8b 40 3c             	mov    0x3c(%eax),%eax
8010661d:	0f b7 c0             	movzwl %ax,%eax
80106620:	83 e0 03             	and    $0x3,%eax
80106623:	85 c0                	test   %eax,%eax
80106625:	75 45                	jne    8010666c <trap+0x17a>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106627:	e8 37 fd ff ff       	call   80106363 <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
8010662c:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010662f:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106632:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106639:	8a 12                	mov    (%edx),%dl
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010663b:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010663e:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106641:	8b 52 30             	mov    0x30(%edx),%edx
80106644:	89 44 24 10          	mov    %eax,0x10(%esp)
80106648:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010664c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106650:	89 54 24 04          	mov    %edx,0x4(%esp)
80106654:	c7 04 24 c8 86 10 80 	movl   $0x801086c8,(%esp)
8010665b:	e8 41 9d ff ff       	call   801003a1 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106660:	c7 04 24 fa 86 10 80 	movl   $0x801086fa,(%esp)
80106667:	e8 ca 9e ff ff       	call   80100536 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010666c:	e8 f2 fc ff ff       	call   80106363 <rcr2>
80106671:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106673:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106676:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106679:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010667f:	8a 00                	mov    (%eax),%al
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106681:	0f b6 f0             	movzbl %al,%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106684:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106687:	8b 58 34             	mov    0x34(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010668a:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010668d:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106690:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106696:	83 c0 6c             	add    $0x6c,%eax
80106699:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010669c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066a2:	8b 40 10             	mov    0x10(%eax),%eax
801066a5:	89 54 24 1c          	mov    %edx,0x1c(%esp)
801066a9:	89 7c 24 18          	mov    %edi,0x18(%esp)
801066ad:	89 74 24 14          	mov    %esi,0x14(%esp)
801066b1:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801066b5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801066b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801066bc:	89 54 24 08          	mov    %edx,0x8(%esp)
801066c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801066c4:	c7 04 24 00 87 10 80 	movl   $0x80108700,(%esp)
801066cb:	e8 d1 9c ff ff       	call   801003a1 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801066d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066d6:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801066dd:	eb 01                	jmp    801066e0 <trap+0x1ee>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801066df:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801066e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066e6:	85 c0                	test   %eax,%eax
801066e8:	74 23                	je     8010670d <trap+0x21b>
801066ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066f0:	8b 40 24             	mov    0x24(%eax),%eax
801066f3:	85 c0                	test   %eax,%eax
801066f5:	74 16                	je     8010670d <trap+0x21b>
801066f7:	8b 45 08             	mov    0x8(%ebp),%eax
801066fa:	8b 40 3c             	mov    0x3c(%eax),%eax
801066fd:	0f b7 c0             	movzwl %ax,%eax
80106700:	83 e0 03             	and    $0x3,%eax
80106703:	83 f8 03             	cmp    $0x3,%eax
80106706:	75 05                	jne    8010670d <trap+0x21b>
    exit();
80106708:	e8 f3 dd ff ff       	call   80104500 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010670d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106713:	85 c0                	test   %eax,%eax
80106715:	74 1e                	je     80106735 <trap+0x243>
80106717:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010671d:	8b 40 0c             	mov    0xc(%eax),%eax
80106720:	83 f8 04             	cmp    $0x4,%eax
80106723:	75 10                	jne    80106735 <trap+0x243>
80106725:	8b 45 08             	mov    0x8(%ebp),%eax
80106728:	8b 40 30             	mov    0x30(%eax),%eax
8010672b:	83 f8 20             	cmp    $0x20,%eax
8010672e:	75 05                	jne    80106735 <trap+0x243>
    yield();
80106730:	e8 e0 e1 ff ff       	call   80104915 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106735:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010673b:	85 c0                	test   %eax,%eax
8010673d:	74 26                	je     80106765 <trap+0x273>
8010673f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106745:	8b 40 24             	mov    0x24(%eax),%eax
80106748:	85 c0                	test   %eax,%eax
8010674a:	74 19                	je     80106765 <trap+0x273>
8010674c:	8b 45 08             	mov    0x8(%ebp),%eax
8010674f:	8b 40 3c             	mov    0x3c(%eax),%eax
80106752:	0f b7 c0             	movzwl %ax,%eax
80106755:	83 e0 03             	and    $0x3,%eax
80106758:	83 f8 03             	cmp    $0x3,%eax
8010675b:	75 08                	jne    80106765 <trap+0x273>
    exit();
8010675d:	e8 9e dd ff ff       	call   80104500 <exit>
80106762:	eb 01                	jmp    80106765 <trap+0x273>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106764:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106765:	83 c4 3c             	add    $0x3c,%esp
80106768:	5b                   	pop    %ebx
80106769:	5e                   	pop    %esi
8010676a:	5f                   	pop    %edi
8010676b:	5d                   	pop    %ebp
8010676c:	c3                   	ret    
8010676d:	66 90                	xchg   %ax,%ax
8010676f:	90                   	nop

80106770 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
80106773:	53                   	push   %ebx
80106774:	83 ec 14             	sub    $0x14,%esp
80106777:	8b 45 08             	mov    0x8(%ebp),%eax
8010677a:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010677e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80106781:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80106785:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
80106789:	ec                   	in     (%dx),%al
8010678a:	88 c3                	mov    %al,%bl
8010678c:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
8010678f:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80106792:	83 c4 14             	add    $0x14,%esp
80106795:	5b                   	pop    %ebx
80106796:	5d                   	pop    %ebp
80106797:	c3                   	ret    

80106798 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106798:	55                   	push   %ebp
80106799:	89 e5                	mov    %esp,%ebp
8010679b:	83 ec 08             	sub    $0x8,%esp
8010679e:	8b 45 08             	mov    0x8(%ebp),%eax
801067a1:	8b 55 0c             	mov    0xc(%ebp),%edx
801067a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801067a8:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801067ab:	8a 45 f8             	mov    -0x8(%ebp),%al
801067ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
801067b1:	ee                   	out    %al,(%dx)
}
801067b2:	c9                   	leave  
801067b3:	c3                   	ret    

801067b4 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801067b4:	55                   	push   %ebp
801067b5:	89 e5                	mov    %esp,%ebp
801067b7:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801067ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067c1:	00 
801067c2:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801067c9:	e8 ca ff ff ff       	call   80106798 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801067ce:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801067d5:	00 
801067d6:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801067dd:	e8 b6 ff ff ff       	call   80106798 <outb>
  outb(COM1+0, 115200/9600);
801067e2:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801067e9:	00 
801067ea:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801067f1:	e8 a2 ff ff ff       	call   80106798 <outb>
  outb(COM1+1, 0);
801067f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067fd:	00 
801067fe:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106805:	e8 8e ff ff ff       	call   80106798 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010680a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106811:	00 
80106812:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106819:	e8 7a ff ff ff       	call   80106798 <outb>
  outb(COM1+4, 0);
8010681e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106825:	00 
80106826:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
8010682d:	e8 66 ff ff ff       	call   80106798 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106832:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106839:	00 
8010683a:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106841:	e8 52 ff ff ff       	call   80106798 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106846:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010684d:	e8 1e ff ff ff       	call   80106770 <inb>
80106852:	3c ff                	cmp    $0xff,%al
80106854:	74 69                	je     801068bf <uartinit+0x10b>
    return;
  uart = 1;
80106856:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
8010685d:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106860:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106867:	e8 04 ff ff ff       	call   80106770 <inb>
  inb(COM1+0);
8010686c:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106873:	e8 f8 fe ff ff       	call   80106770 <inb>
  picenable(IRQ_COM1);
80106878:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010687f:	e8 f0 d2 ff ff       	call   80103b74 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106884:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010688b:	00 
8010688c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106893:	e8 61 c1 ff ff       	call   801029f9 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106898:	c7 45 f4 c4 87 10 80 	movl   $0x801087c4,-0xc(%ebp)
8010689f:	eb 13                	jmp    801068b4 <uartinit+0x100>
    uartputc(*p);
801068a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068a4:	8a 00                	mov    (%eax),%al
801068a6:	0f be c0             	movsbl %al,%eax
801068a9:	89 04 24             	mov    %eax,(%esp)
801068ac:	e8 11 00 00 00       	call   801068c2 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801068b1:	ff 45 f4             	incl   -0xc(%ebp)
801068b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b7:	8a 00                	mov    (%eax),%al
801068b9:	84 c0                	test   %al,%al
801068bb:	75 e4                	jne    801068a1 <uartinit+0xed>
801068bd:	eb 01                	jmp    801068c0 <uartinit+0x10c>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
801068bf:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
801068c0:	c9                   	leave  
801068c1:	c3                   	ret    

801068c2 <uartputc>:

void
uartputc(int c)
{
801068c2:	55                   	push   %ebp
801068c3:	89 e5                	mov    %esp,%ebp
801068c5:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
801068c8:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
801068cd:	85 c0                	test   %eax,%eax
801068cf:	74 4c                	je     8010691d <uartputc+0x5b>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801068d8:	eb 0f                	jmp    801068e9 <uartputc+0x27>
    microdelay(10);
801068da:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801068e1:	e8 a0 c6 ff ff       	call   80102f86 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068e6:	ff 45 f4             	incl   -0xc(%ebp)
801068e9:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801068ed:	7f 16                	jg     80106905 <uartputc+0x43>
801068ef:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801068f6:	e8 75 fe ff ff       	call   80106770 <inb>
801068fb:	0f b6 c0             	movzbl %al,%eax
801068fe:	83 e0 20             	and    $0x20,%eax
80106901:	85 c0                	test   %eax,%eax
80106903:	74 d5                	je     801068da <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106905:	8b 45 08             	mov    0x8(%ebp),%eax
80106908:	0f b6 c0             	movzbl %al,%eax
8010690b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010690f:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106916:	e8 7d fe ff ff       	call   80106798 <outb>
8010691b:	eb 01                	jmp    8010691e <uartputc+0x5c>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
8010691d:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
8010691e:	c9                   	leave  
8010691f:	c3                   	ret    

80106920 <uartgetc>:

static int
uartgetc(void)
{
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106926:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
8010692b:	85 c0                	test   %eax,%eax
8010692d:	75 07                	jne    80106936 <uartgetc+0x16>
    return -1;
8010692f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106934:	eb 2c                	jmp    80106962 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106936:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010693d:	e8 2e fe ff ff       	call   80106770 <inb>
80106942:	0f b6 c0             	movzbl %al,%eax
80106945:	83 e0 01             	and    $0x1,%eax
80106948:	85 c0                	test   %eax,%eax
8010694a:	75 07                	jne    80106953 <uartgetc+0x33>
    return -1;
8010694c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106951:	eb 0f                	jmp    80106962 <uartgetc+0x42>
  return inb(COM1+0);
80106953:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010695a:	e8 11 fe ff ff       	call   80106770 <inb>
8010695f:	0f b6 c0             	movzbl %al,%eax
}
80106962:	c9                   	leave  
80106963:	c3                   	ret    

80106964 <uartintr>:

void
uartintr(void)
{
80106964:	55                   	push   %ebp
80106965:	89 e5                	mov    %esp,%ebp
80106967:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
8010696a:	c7 04 24 20 69 10 80 	movl   $0x80106920,(%esp)
80106971:	e8 1a 9e ff ff       	call   80100790 <consoleintr>
}
80106976:	c9                   	leave  
80106977:	c3                   	ret    

80106978 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106978:	6a 00                	push   $0x0
  pushl $0
8010697a:	6a 00                	push   $0x0
  jmp alltraps
8010697c:	e9 8f f9 ff ff       	jmp    80106310 <alltraps>

80106981 <vector1>:
.globl vector1
vector1:
  pushl $0
80106981:	6a 00                	push   $0x0
  pushl $1
80106983:	6a 01                	push   $0x1
  jmp alltraps
80106985:	e9 86 f9 ff ff       	jmp    80106310 <alltraps>

8010698a <vector2>:
.globl vector2
vector2:
  pushl $0
8010698a:	6a 00                	push   $0x0
  pushl $2
8010698c:	6a 02                	push   $0x2
  jmp alltraps
8010698e:	e9 7d f9 ff ff       	jmp    80106310 <alltraps>

80106993 <vector3>:
.globl vector3
vector3:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $3
80106995:	6a 03                	push   $0x3
  jmp alltraps
80106997:	e9 74 f9 ff ff       	jmp    80106310 <alltraps>

8010699c <vector4>:
.globl vector4
vector4:
  pushl $0
8010699c:	6a 00                	push   $0x0
  pushl $4
8010699e:	6a 04                	push   $0x4
  jmp alltraps
801069a0:	e9 6b f9 ff ff       	jmp    80106310 <alltraps>

801069a5 <vector5>:
.globl vector5
vector5:
  pushl $0
801069a5:	6a 00                	push   $0x0
  pushl $5
801069a7:	6a 05                	push   $0x5
  jmp alltraps
801069a9:	e9 62 f9 ff ff       	jmp    80106310 <alltraps>

801069ae <vector6>:
.globl vector6
vector6:
  pushl $0
801069ae:	6a 00                	push   $0x0
  pushl $6
801069b0:	6a 06                	push   $0x6
  jmp alltraps
801069b2:	e9 59 f9 ff ff       	jmp    80106310 <alltraps>

801069b7 <vector7>:
.globl vector7
vector7:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $7
801069b9:	6a 07                	push   $0x7
  jmp alltraps
801069bb:	e9 50 f9 ff ff       	jmp    80106310 <alltraps>

801069c0 <vector8>:
.globl vector8
vector8:
  pushl $8
801069c0:	6a 08                	push   $0x8
  jmp alltraps
801069c2:	e9 49 f9 ff ff       	jmp    80106310 <alltraps>

801069c7 <vector9>:
.globl vector9
vector9:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $9
801069c9:	6a 09                	push   $0x9
  jmp alltraps
801069cb:	e9 40 f9 ff ff       	jmp    80106310 <alltraps>

801069d0 <vector10>:
.globl vector10
vector10:
  pushl $10
801069d0:	6a 0a                	push   $0xa
  jmp alltraps
801069d2:	e9 39 f9 ff ff       	jmp    80106310 <alltraps>

801069d7 <vector11>:
.globl vector11
vector11:
  pushl $11
801069d7:	6a 0b                	push   $0xb
  jmp alltraps
801069d9:	e9 32 f9 ff ff       	jmp    80106310 <alltraps>

801069de <vector12>:
.globl vector12
vector12:
  pushl $12
801069de:	6a 0c                	push   $0xc
  jmp alltraps
801069e0:	e9 2b f9 ff ff       	jmp    80106310 <alltraps>

801069e5 <vector13>:
.globl vector13
vector13:
  pushl $13
801069e5:	6a 0d                	push   $0xd
  jmp alltraps
801069e7:	e9 24 f9 ff ff       	jmp    80106310 <alltraps>

801069ec <vector14>:
.globl vector14
vector14:
  pushl $14
801069ec:	6a 0e                	push   $0xe
  jmp alltraps
801069ee:	e9 1d f9 ff ff       	jmp    80106310 <alltraps>

801069f3 <vector15>:
.globl vector15
vector15:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $15
801069f5:	6a 0f                	push   $0xf
  jmp alltraps
801069f7:	e9 14 f9 ff ff       	jmp    80106310 <alltraps>

801069fc <vector16>:
.globl vector16
vector16:
  pushl $0
801069fc:	6a 00                	push   $0x0
  pushl $16
801069fe:	6a 10                	push   $0x10
  jmp alltraps
80106a00:	e9 0b f9 ff ff       	jmp    80106310 <alltraps>

80106a05 <vector17>:
.globl vector17
vector17:
  pushl $17
80106a05:	6a 11                	push   $0x11
  jmp alltraps
80106a07:	e9 04 f9 ff ff       	jmp    80106310 <alltraps>

80106a0c <vector18>:
.globl vector18
vector18:
  pushl $0
80106a0c:	6a 00                	push   $0x0
  pushl $18
80106a0e:	6a 12                	push   $0x12
  jmp alltraps
80106a10:	e9 fb f8 ff ff       	jmp    80106310 <alltraps>

80106a15 <vector19>:
.globl vector19
vector19:
  pushl $0
80106a15:	6a 00                	push   $0x0
  pushl $19
80106a17:	6a 13                	push   $0x13
  jmp alltraps
80106a19:	e9 f2 f8 ff ff       	jmp    80106310 <alltraps>

80106a1e <vector20>:
.globl vector20
vector20:
  pushl $0
80106a1e:	6a 00                	push   $0x0
  pushl $20
80106a20:	6a 14                	push   $0x14
  jmp alltraps
80106a22:	e9 e9 f8 ff ff       	jmp    80106310 <alltraps>

80106a27 <vector21>:
.globl vector21
vector21:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $21
80106a29:	6a 15                	push   $0x15
  jmp alltraps
80106a2b:	e9 e0 f8 ff ff       	jmp    80106310 <alltraps>

80106a30 <vector22>:
.globl vector22
vector22:
  pushl $0
80106a30:	6a 00                	push   $0x0
  pushl $22
80106a32:	6a 16                	push   $0x16
  jmp alltraps
80106a34:	e9 d7 f8 ff ff       	jmp    80106310 <alltraps>

80106a39 <vector23>:
.globl vector23
vector23:
  pushl $0
80106a39:	6a 00                	push   $0x0
  pushl $23
80106a3b:	6a 17                	push   $0x17
  jmp alltraps
80106a3d:	e9 ce f8 ff ff       	jmp    80106310 <alltraps>

80106a42 <vector24>:
.globl vector24
vector24:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $24
80106a44:	6a 18                	push   $0x18
  jmp alltraps
80106a46:	e9 c5 f8 ff ff       	jmp    80106310 <alltraps>

80106a4b <vector25>:
.globl vector25
vector25:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $25
80106a4d:	6a 19                	push   $0x19
  jmp alltraps
80106a4f:	e9 bc f8 ff ff       	jmp    80106310 <alltraps>

80106a54 <vector26>:
.globl vector26
vector26:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $26
80106a56:	6a 1a                	push   $0x1a
  jmp alltraps
80106a58:	e9 b3 f8 ff ff       	jmp    80106310 <alltraps>

80106a5d <vector27>:
.globl vector27
vector27:
  pushl $0
80106a5d:	6a 00                	push   $0x0
  pushl $27
80106a5f:	6a 1b                	push   $0x1b
  jmp alltraps
80106a61:	e9 aa f8 ff ff       	jmp    80106310 <alltraps>

80106a66 <vector28>:
.globl vector28
vector28:
  pushl $0
80106a66:	6a 00                	push   $0x0
  pushl $28
80106a68:	6a 1c                	push   $0x1c
  jmp alltraps
80106a6a:	e9 a1 f8 ff ff       	jmp    80106310 <alltraps>

80106a6f <vector29>:
.globl vector29
vector29:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $29
80106a71:	6a 1d                	push   $0x1d
  jmp alltraps
80106a73:	e9 98 f8 ff ff       	jmp    80106310 <alltraps>

80106a78 <vector30>:
.globl vector30
vector30:
  pushl $0
80106a78:	6a 00                	push   $0x0
  pushl $30
80106a7a:	6a 1e                	push   $0x1e
  jmp alltraps
80106a7c:	e9 8f f8 ff ff       	jmp    80106310 <alltraps>

80106a81 <vector31>:
.globl vector31
vector31:
  pushl $0
80106a81:	6a 00                	push   $0x0
  pushl $31
80106a83:	6a 1f                	push   $0x1f
  jmp alltraps
80106a85:	e9 86 f8 ff ff       	jmp    80106310 <alltraps>

80106a8a <vector32>:
.globl vector32
vector32:
  pushl $0
80106a8a:	6a 00                	push   $0x0
  pushl $32
80106a8c:	6a 20                	push   $0x20
  jmp alltraps
80106a8e:	e9 7d f8 ff ff       	jmp    80106310 <alltraps>

80106a93 <vector33>:
.globl vector33
vector33:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $33
80106a95:	6a 21                	push   $0x21
  jmp alltraps
80106a97:	e9 74 f8 ff ff       	jmp    80106310 <alltraps>

80106a9c <vector34>:
.globl vector34
vector34:
  pushl $0
80106a9c:	6a 00                	push   $0x0
  pushl $34
80106a9e:	6a 22                	push   $0x22
  jmp alltraps
80106aa0:	e9 6b f8 ff ff       	jmp    80106310 <alltraps>

80106aa5 <vector35>:
.globl vector35
vector35:
  pushl $0
80106aa5:	6a 00                	push   $0x0
  pushl $35
80106aa7:	6a 23                	push   $0x23
  jmp alltraps
80106aa9:	e9 62 f8 ff ff       	jmp    80106310 <alltraps>

80106aae <vector36>:
.globl vector36
vector36:
  pushl $0
80106aae:	6a 00                	push   $0x0
  pushl $36
80106ab0:	6a 24                	push   $0x24
  jmp alltraps
80106ab2:	e9 59 f8 ff ff       	jmp    80106310 <alltraps>

80106ab7 <vector37>:
.globl vector37
vector37:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $37
80106ab9:	6a 25                	push   $0x25
  jmp alltraps
80106abb:	e9 50 f8 ff ff       	jmp    80106310 <alltraps>

80106ac0 <vector38>:
.globl vector38
vector38:
  pushl $0
80106ac0:	6a 00                	push   $0x0
  pushl $38
80106ac2:	6a 26                	push   $0x26
  jmp alltraps
80106ac4:	e9 47 f8 ff ff       	jmp    80106310 <alltraps>

80106ac9 <vector39>:
.globl vector39
vector39:
  pushl $0
80106ac9:	6a 00                	push   $0x0
  pushl $39
80106acb:	6a 27                	push   $0x27
  jmp alltraps
80106acd:	e9 3e f8 ff ff       	jmp    80106310 <alltraps>

80106ad2 <vector40>:
.globl vector40
vector40:
  pushl $0
80106ad2:	6a 00                	push   $0x0
  pushl $40
80106ad4:	6a 28                	push   $0x28
  jmp alltraps
80106ad6:	e9 35 f8 ff ff       	jmp    80106310 <alltraps>

80106adb <vector41>:
.globl vector41
vector41:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $41
80106add:	6a 29                	push   $0x29
  jmp alltraps
80106adf:	e9 2c f8 ff ff       	jmp    80106310 <alltraps>

80106ae4 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ae4:	6a 00                	push   $0x0
  pushl $42
80106ae6:	6a 2a                	push   $0x2a
  jmp alltraps
80106ae8:	e9 23 f8 ff ff       	jmp    80106310 <alltraps>

80106aed <vector43>:
.globl vector43
vector43:
  pushl $0
80106aed:	6a 00                	push   $0x0
  pushl $43
80106aef:	6a 2b                	push   $0x2b
  jmp alltraps
80106af1:	e9 1a f8 ff ff       	jmp    80106310 <alltraps>

80106af6 <vector44>:
.globl vector44
vector44:
  pushl $0
80106af6:	6a 00                	push   $0x0
  pushl $44
80106af8:	6a 2c                	push   $0x2c
  jmp alltraps
80106afa:	e9 11 f8 ff ff       	jmp    80106310 <alltraps>

80106aff <vector45>:
.globl vector45
vector45:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $45
80106b01:	6a 2d                	push   $0x2d
  jmp alltraps
80106b03:	e9 08 f8 ff ff       	jmp    80106310 <alltraps>

80106b08 <vector46>:
.globl vector46
vector46:
  pushl $0
80106b08:	6a 00                	push   $0x0
  pushl $46
80106b0a:	6a 2e                	push   $0x2e
  jmp alltraps
80106b0c:	e9 ff f7 ff ff       	jmp    80106310 <alltraps>

80106b11 <vector47>:
.globl vector47
vector47:
  pushl $0
80106b11:	6a 00                	push   $0x0
  pushl $47
80106b13:	6a 2f                	push   $0x2f
  jmp alltraps
80106b15:	e9 f6 f7 ff ff       	jmp    80106310 <alltraps>

80106b1a <vector48>:
.globl vector48
vector48:
  pushl $0
80106b1a:	6a 00                	push   $0x0
  pushl $48
80106b1c:	6a 30                	push   $0x30
  jmp alltraps
80106b1e:	e9 ed f7 ff ff       	jmp    80106310 <alltraps>

80106b23 <vector49>:
.globl vector49
vector49:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $49
80106b25:	6a 31                	push   $0x31
  jmp alltraps
80106b27:	e9 e4 f7 ff ff       	jmp    80106310 <alltraps>

80106b2c <vector50>:
.globl vector50
vector50:
  pushl $0
80106b2c:	6a 00                	push   $0x0
  pushl $50
80106b2e:	6a 32                	push   $0x32
  jmp alltraps
80106b30:	e9 db f7 ff ff       	jmp    80106310 <alltraps>

80106b35 <vector51>:
.globl vector51
vector51:
  pushl $0
80106b35:	6a 00                	push   $0x0
  pushl $51
80106b37:	6a 33                	push   $0x33
  jmp alltraps
80106b39:	e9 d2 f7 ff ff       	jmp    80106310 <alltraps>

80106b3e <vector52>:
.globl vector52
vector52:
  pushl $0
80106b3e:	6a 00                	push   $0x0
  pushl $52
80106b40:	6a 34                	push   $0x34
  jmp alltraps
80106b42:	e9 c9 f7 ff ff       	jmp    80106310 <alltraps>

80106b47 <vector53>:
.globl vector53
vector53:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $53
80106b49:	6a 35                	push   $0x35
  jmp alltraps
80106b4b:	e9 c0 f7 ff ff       	jmp    80106310 <alltraps>

80106b50 <vector54>:
.globl vector54
vector54:
  pushl $0
80106b50:	6a 00                	push   $0x0
  pushl $54
80106b52:	6a 36                	push   $0x36
  jmp alltraps
80106b54:	e9 b7 f7 ff ff       	jmp    80106310 <alltraps>

80106b59 <vector55>:
.globl vector55
vector55:
  pushl $0
80106b59:	6a 00                	push   $0x0
  pushl $55
80106b5b:	6a 37                	push   $0x37
  jmp alltraps
80106b5d:	e9 ae f7 ff ff       	jmp    80106310 <alltraps>

80106b62 <vector56>:
.globl vector56
vector56:
  pushl $0
80106b62:	6a 00                	push   $0x0
  pushl $56
80106b64:	6a 38                	push   $0x38
  jmp alltraps
80106b66:	e9 a5 f7 ff ff       	jmp    80106310 <alltraps>

80106b6b <vector57>:
.globl vector57
vector57:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $57
80106b6d:	6a 39                	push   $0x39
  jmp alltraps
80106b6f:	e9 9c f7 ff ff       	jmp    80106310 <alltraps>

80106b74 <vector58>:
.globl vector58
vector58:
  pushl $0
80106b74:	6a 00                	push   $0x0
  pushl $58
80106b76:	6a 3a                	push   $0x3a
  jmp alltraps
80106b78:	e9 93 f7 ff ff       	jmp    80106310 <alltraps>

80106b7d <vector59>:
.globl vector59
vector59:
  pushl $0
80106b7d:	6a 00                	push   $0x0
  pushl $59
80106b7f:	6a 3b                	push   $0x3b
  jmp alltraps
80106b81:	e9 8a f7 ff ff       	jmp    80106310 <alltraps>

80106b86 <vector60>:
.globl vector60
vector60:
  pushl $0
80106b86:	6a 00                	push   $0x0
  pushl $60
80106b88:	6a 3c                	push   $0x3c
  jmp alltraps
80106b8a:	e9 81 f7 ff ff       	jmp    80106310 <alltraps>

80106b8f <vector61>:
.globl vector61
vector61:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $61
80106b91:	6a 3d                	push   $0x3d
  jmp alltraps
80106b93:	e9 78 f7 ff ff       	jmp    80106310 <alltraps>

80106b98 <vector62>:
.globl vector62
vector62:
  pushl $0
80106b98:	6a 00                	push   $0x0
  pushl $62
80106b9a:	6a 3e                	push   $0x3e
  jmp alltraps
80106b9c:	e9 6f f7 ff ff       	jmp    80106310 <alltraps>

80106ba1 <vector63>:
.globl vector63
vector63:
  pushl $0
80106ba1:	6a 00                	push   $0x0
  pushl $63
80106ba3:	6a 3f                	push   $0x3f
  jmp alltraps
80106ba5:	e9 66 f7 ff ff       	jmp    80106310 <alltraps>

80106baa <vector64>:
.globl vector64
vector64:
  pushl $0
80106baa:	6a 00                	push   $0x0
  pushl $64
80106bac:	6a 40                	push   $0x40
  jmp alltraps
80106bae:	e9 5d f7 ff ff       	jmp    80106310 <alltraps>

80106bb3 <vector65>:
.globl vector65
vector65:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $65
80106bb5:	6a 41                	push   $0x41
  jmp alltraps
80106bb7:	e9 54 f7 ff ff       	jmp    80106310 <alltraps>

80106bbc <vector66>:
.globl vector66
vector66:
  pushl $0
80106bbc:	6a 00                	push   $0x0
  pushl $66
80106bbe:	6a 42                	push   $0x42
  jmp alltraps
80106bc0:	e9 4b f7 ff ff       	jmp    80106310 <alltraps>

80106bc5 <vector67>:
.globl vector67
vector67:
  pushl $0
80106bc5:	6a 00                	push   $0x0
  pushl $67
80106bc7:	6a 43                	push   $0x43
  jmp alltraps
80106bc9:	e9 42 f7 ff ff       	jmp    80106310 <alltraps>

80106bce <vector68>:
.globl vector68
vector68:
  pushl $0
80106bce:	6a 00                	push   $0x0
  pushl $68
80106bd0:	6a 44                	push   $0x44
  jmp alltraps
80106bd2:	e9 39 f7 ff ff       	jmp    80106310 <alltraps>

80106bd7 <vector69>:
.globl vector69
vector69:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $69
80106bd9:	6a 45                	push   $0x45
  jmp alltraps
80106bdb:	e9 30 f7 ff ff       	jmp    80106310 <alltraps>

80106be0 <vector70>:
.globl vector70
vector70:
  pushl $0
80106be0:	6a 00                	push   $0x0
  pushl $70
80106be2:	6a 46                	push   $0x46
  jmp alltraps
80106be4:	e9 27 f7 ff ff       	jmp    80106310 <alltraps>

80106be9 <vector71>:
.globl vector71
vector71:
  pushl $0
80106be9:	6a 00                	push   $0x0
  pushl $71
80106beb:	6a 47                	push   $0x47
  jmp alltraps
80106bed:	e9 1e f7 ff ff       	jmp    80106310 <alltraps>

80106bf2 <vector72>:
.globl vector72
vector72:
  pushl $0
80106bf2:	6a 00                	push   $0x0
  pushl $72
80106bf4:	6a 48                	push   $0x48
  jmp alltraps
80106bf6:	e9 15 f7 ff ff       	jmp    80106310 <alltraps>

80106bfb <vector73>:
.globl vector73
vector73:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $73
80106bfd:	6a 49                	push   $0x49
  jmp alltraps
80106bff:	e9 0c f7 ff ff       	jmp    80106310 <alltraps>

80106c04 <vector74>:
.globl vector74
vector74:
  pushl $0
80106c04:	6a 00                	push   $0x0
  pushl $74
80106c06:	6a 4a                	push   $0x4a
  jmp alltraps
80106c08:	e9 03 f7 ff ff       	jmp    80106310 <alltraps>

80106c0d <vector75>:
.globl vector75
vector75:
  pushl $0
80106c0d:	6a 00                	push   $0x0
  pushl $75
80106c0f:	6a 4b                	push   $0x4b
  jmp alltraps
80106c11:	e9 fa f6 ff ff       	jmp    80106310 <alltraps>

80106c16 <vector76>:
.globl vector76
vector76:
  pushl $0
80106c16:	6a 00                	push   $0x0
  pushl $76
80106c18:	6a 4c                	push   $0x4c
  jmp alltraps
80106c1a:	e9 f1 f6 ff ff       	jmp    80106310 <alltraps>

80106c1f <vector77>:
.globl vector77
vector77:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $77
80106c21:	6a 4d                	push   $0x4d
  jmp alltraps
80106c23:	e9 e8 f6 ff ff       	jmp    80106310 <alltraps>

80106c28 <vector78>:
.globl vector78
vector78:
  pushl $0
80106c28:	6a 00                	push   $0x0
  pushl $78
80106c2a:	6a 4e                	push   $0x4e
  jmp alltraps
80106c2c:	e9 df f6 ff ff       	jmp    80106310 <alltraps>

80106c31 <vector79>:
.globl vector79
vector79:
  pushl $0
80106c31:	6a 00                	push   $0x0
  pushl $79
80106c33:	6a 4f                	push   $0x4f
  jmp alltraps
80106c35:	e9 d6 f6 ff ff       	jmp    80106310 <alltraps>

80106c3a <vector80>:
.globl vector80
vector80:
  pushl $0
80106c3a:	6a 00                	push   $0x0
  pushl $80
80106c3c:	6a 50                	push   $0x50
  jmp alltraps
80106c3e:	e9 cd f6 ff ff       	jmp    80106310 <alltraps>

80106c43 <vector81>:
.globl vector81
vector81:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $81
80106c45:	6a 51                	push   $0x51
  jmp alltraps
80106c47:	e9 c4 f6 ff ff       	jmp    80106310 <alltraps>

80106c4c <vector82>:
.globl vector82
vector82:
  pushl $0
80106c4c:	6a 00                	push   $0x0
  pushl $82
80106c4e:	6a 52                	push   $0x52
  jmp alltraps
80106c50:	e9 bb f6 ff ff       	jmp    80106310 <alltraps>

80106c55 <vector83>:
.globl vector83
vector83:
  pushl $0
80106c55:	6a 00                	push   $0x0
  pushl $83
80106c57:	6a 53                	push   $0x53
  jmp alltraps
80106c59:	e9 b2 f6 ff ff       	jmp    80106310 <alltraps>

80106c5e <vector84>:
.globl vector84
vector84:
  pushl $0
80106c5e:	6a 00                	push   $0x0
  pushl $84
80106c60:	6a 54                	push   $0x54
  jmp alltraps
80106c62:	e9 a9 f6 ff ff       	jmp    80106310 <alltraps>

80106c67 <vector85>:
.globl vector85
vector85:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $85
80106c69:	6a 55                	push   $0x55
  jmp alltraps
80106c6b:	e9 a0 f6 ff ff       	jmp    80106310 <alltraps>

80106c70 <vector86>:
.globl vector86
vector86:
  pushl $0
80106c70:	6a 00                	push   $0x0
  pushl $86
80106c72:	6a 56                	push   $0x56
  jmp alltraps
80106c74:	e9 97 f6 ff ff       	jmp    80106310 <alltraps>

80106c79 <vector87>:
.globl vector87
vector87:
  pushl $0
80106c79:	6a 00                	push   $0x0
  pushl $87
80106c7b:	6a 57                	push   $0x57
  jmp alltraps
80106c7d:	e9 8e f6 ff ff       	jmp    80106310 <alltraps>

80106c82 <vector88>:
.globl vector88
vector88:
  pushl $0
80106c82:	6a 00                	push   $0x0
  pushl $88
80106c84:	6a 58                	push   $0x58
  jmp alltraps
80106c86:	e9 85 f6 ff ff       	jmp    80106310 <alltraps>

80106c8b <vector89>:
.globl vector89
vector89:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $89
80106c8d:	6a 59                	push   $0x59
  jmp alltraps
80106c8f:	e9 7c f6 ff ff       	jmp    80106310 <alltraps>

80106c94 <vector90>:
.globl vector90
vector90:
  pushl $0
80106c94:	6a 00                	push   $0x0
  pushl $90
80106c96:	6a 5a                	push   $0x5a
  jmp alltraps
80106c98:	e9 73 f6 ff ff       	jmp    80106310 <alltraps>

80106c9d <vector91>:
.globl vector91
vector91:
  pushl $0
80106c9d:	6a 00                	push   $0x0
  pushl $91
80106c9f:	6a 5b                	push   $0x5b
  jmp alltraps
80106ca1:	e9 6a f6 ff ff       	jmp    80106310 <alltraps>

80106ca6 <vector92>:
.globl vector92
vector92:
  pushl $0
80106ca6:	6a 00                	push   $0x0
  pushl $92
80106ca8:	6a 5c                	push   $0x5c
  jmp alltraps
80106caa:	e9 61 f6 ff ff       	jmp    80106310 <alltraps>

80106caf <vector93>:
.globl vector93
vector93:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $93
80106cb1:	6a 5d                	push   $0x5d
  jmp alltraps
80106cb3:	e9 58 f6 ff ff       	jmp    80106310 <alltraps>

80106cb8 <vector94>:
.globl vector94
vector94:
  pushl $0
80106cb8:	6a 00                	push   $0x0
  pushl $94
80106cba:	6a 5e                	push   $0x5e
  jmp alltraps
80106cbc:	e9 4f f6 ff ff       	jmp    80106310 <alltraps>

80106cc1 <vector95>:
.globl vector95
vector95:
  pushl $0
80106cc1:	6a 00                	push   $0x0
  pushl $95
80106cc3:	6a 5f                	push   $0x5f
  jmp alltraps
80106cc5:	e9 46 f6 ff ff       	jmp    80106310 <alltraps>

80106cca <vector96>:
.globl vector96
vector96:
  pushl $0
80106cca:	6a 00                	push   $0x0
  pushl $96
80106ccc:	6a 60                	push   $0x60
  jmp alltraps
80106cce:	e9 3d f6 ff ff       	jmp    80106310 <alltraps>

80106cd3 <vector97>:
.globl vector97
vector97:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $97
80106cd5:	6a 61                	push   $0x61
  jmp alltraps
80106cd7:	e9 34 f6 ff ff       	jmp    80106310 <alltraps>

80106cdc <vector98>:
.globl vector98
vector98:
  pushl $0
80106cdc:	6a 00                	push   $0x0
  pushl $98
80106cde:	6a 62                	push   $0x62
  jmp alltraps
80106ce0:	e9 2b f6 ff ff       	jmp    80106310 <alltraps>

80106ce5 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ce5:	6a 00                	push   $0x0
  pushl $99
80106ce7:	6a 63                	push   $0x63
  jmp alltraps
80106ce9:	e9 22 f6 ff ff       	jmp    80106310 <alltraps>

80106cee <vector100>:
.globl vector100
vector100:
  pushl $0
80106cee:	6a 00                	push   $0x0
  pushl $100
80106cf0:	6a 64                	push   $0x64
  jmp alltraps
80106cf2:	e9 19 f6 ff ff       	jmp    80106310 <alltraps>

80106cf7 <vector101>:
.globl vector101
vector101:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $101
80106cf9:	6a 65                	push   $0x65
  jmp alltraps
80106cfb:	e9 10 f6 ff ff       	jmp    80106310 <alltraps>

80106d00 <vector102>:
.globl vector102
vector102:
  pushl $0
80106d00:	6a 00                	push   $0x0
  pushl $102
80106d02:	6a 66                	push   $0x66
  jmp alltraps
80106d04:	e9 07 f6 ff ff       	jmp    80106310 <alltraps>

80106d09 <vector103>:
.globl vector103
vector103:
  pushl $0
80106d09:	6a 00                	push   $0x0
  pushl $103
80106d0b:	6a 67                	push   $0x67
  jmp alltraps
80106d0d:	e9 fe f5 ff ff       	jmp    80106310 <alltraps>

80106d12 <vector104>:
.globl vector104
vector104:
  pushl $0
80106d12:	6a 00                	push   $0x0
  pushl $104
80106d14:	6a 68                	push   $0x68
  jmp alltraps
80106d16:	e9 f5 f5 ff ff       	jmp    80106310 <alltraps>

80106d1b <vector105>:
.globl vector105
vector105:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $105
80106d1d:	6a 69                	push   $0x69
  jmp alltraps
80106d1f:	e9 ec f5 ff ff       	jmp    80106310 <alltraps>

80106d24 <vector106>:
.globl vector106
vector106:
  pushl $0
80106d24:	6a 00                	push   $0x0
  pushl $106
80106d26:	6a 6a                	push   $0x6a
  jmp alltraps
80106d28:	e9 e3 f5 ff ff       	jmp    80106310 <alltraps>

80106d2d <vector107>:
.globl vector107
vector107:
  pushl $0
80106d2d:	6a 00                	push   $0x0
  pushl $107
80106d2f:	6a 6b                	push   $0x6b
  jmp alltraps
80106d31:	e9 da f5 ff ff       	jmp    80106310 <alltraps>

80106d36 <vector108>:
.globl vector108
vector108:
  pushl $0
80106d36:	6a 00                	push   $0x0
  pushl $108
80106d38:	6a 6c                	push   $0x6c
  jmp alltraps
80106d3a:	e9 d1 f5 ff ff       	jmp    80106310 <alltraps>

80106d3f <vector109>:
.globl vector109
vector109:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $109
80106d41:	6a 6d                	push   $0x6d
  jmp alltraps
80106d43:	e9 c8 f5 ff ff       	jmp    80106310 <alltraps>

80106d48 <vector110>:
.globl vector110
vector110:
  pushl $0
80106d48:	6a 00                	push   $0x0
  pushl $110
80106d4a:	6a 6e                	push   $0x6e
  jmp alltraps
80106d4c:	e9 bf f5 ff ff       	jmp    80106310 <alltraps>

80106d51 <vector111>:
.globl vector111
vector111:
  pushl $0
80106d51:	6a 00                	push   $0x0
  pushl $111
80106d53:	6a 6f                	push   $0x6f
  jmp alltraps
80106d55:	e9 b6 f5 ff ff       	jmp    80106310 <alltraps>

80106d5a <vector112>:
.globl vector112
vector112:
  pushl $0
80106d5a:	6a 00                	push   $0x0
  pushl $112
80106d5c:	6a 70                	push   $0x70
  jmp alltraps
80106d5e:	e9 ad f5 ff ff       	jmp    80106310 <alltraps>

80106d63 <vector113>:
.globl vector113
vector113:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $113
80106d65:	6a 71                	push   $0x71
  jmp alltraps
80106d67:	e9 a4 f5 ff ff       	jmp    80106310 <alltraps>

80106d6c <vector114>:
.globl vector114
vector114:
  pushl $0
80106d6c:	6a 00                	push   $0x0
  pushl $114
80106d6e:	6a 72                	push   $0x72
  jmp alltraps
80106d70:	e9 9b f5 ff ff       	jmp    80106310 <alltraps>

80106d75 <vector115>:
.globl vector115
vector115:
  pushl $0
80106d75:	6a 00                	push   $0x0
  pushl $115
80106d77:	6a 73                	push   $0x73
  jmp alltraps
80106d79:	e9 92 f5 ff ff       	jmp    80106310 <alltraps>

80106d7e <vector116>:
.globl vector116
vector116:
  pushl $0
80106d7e:	6a 00                	push   $0x0
  pushl $116
80106d80:	6a 74                	push   $0x74
  jmp alltraps
80106d82:	e9 89 f5 ff ff       	jmp    80106310 <alltraps>

80106d87 <vector117>:
.globl vector117
vector117:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $117
80106d89:	6a 75                	push   $0x75
  jmp alltraps
80106d8b:	e9 80 f5 ff ff       	jmp    80106310 <alltraps>

80106d90 <vector118>:
.globl vector118
vector118:
  pushl $0
80106d90:	6a 00                	push   $0x0
  pushl $118
80106d92:	6a 76                	push   $0x76
  jmp alltraps
80106d94:	e9 77 f5 ff ff       	jmp    80106310 <alltraps>

80106d99 <vector119>:
.globl vector119
vector119:
  pushl $0
80106d99:	6a 00                	push   $0x0
  pushl $119
80106d9b:	6a 77                	push   $0x77
  jmp alltraps
80106d9d:	e9 6e f5 ff ff       	jmp    80106310 <alltraps>

80106da2 <vector120>:
.globl vector120
vector120:
  pushl $0
80106da2:	6a 00                	push   $0x0
  pushl $120
80106da4:	6a 78                	push   $0x78
  jmp alltraps
80106da6:	e9 65 f5 ff ff       	jmp    80106310 <alltraps>

80106dab <vector121>:
.globl vector121
vector121:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $121
80106dad:	6a 79                	push   $0x79
  jmp alltraps
80106daf:	e9 5c f5 ff ff       	jmp    80106310 <alltraps>

80106db4 <vector122>:
.globl vector122
vector122:
  pushl $0
80106db4:	6a 00                	push   $0x0
  pushl $122
80106db6:	6a 7a                	push   $0x7a
  jmp alltraps
80106db8:	e9 53 f5 ff ff       	jmp    80106310 <alltraps>

80106dbd <vector123>:
.globl vector123
vector123:
  pushl $0
80106dbd:	6a 00                	push   $0x0
  pushl $123
80106dbf:	6a 7b                	push   $0x7b
  jmp alltraps
80106dc1:	e9 4a f5 ff ff       	jmp    80106310 <alltraps>

80106dc6 <vector124>:
.globl vector124
vector124:
  pushl $0
80106dc6:	6a 00                	push   $0x0
  pushl $124
80106dc8:	6a 7c                	push   $0x7c
  jmp alltraps
80106dca:	e9 41 f5 ff ff       	jmp    80106310 <alltraps>

80106dcf <vector125>:
.globl vector125
vector125:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $125
80106dd1:	6a 7d                	push   $0x7d
  jmp alltraps
80106dd3:	e9 38 f5 ff ff       	jmp    80106310 <alltraps>

80106dd8 <vector126>:
.globl vector126
vector126:
  pushl $0
80106dd8:	6a 00                	push   $0x0
  pushl $126
80106dda:	6a 7e                	push   $0x7e
  jmp alltraps
80106ddc:	e9 2f f5 ff ff       	jmp    80106310 <alltraps>

80106de1 <vector127>:
.globl vector127
vector127:
  pushl $0
80106de1:	6a 00                	push   $0x0
  pushl $127
80106de3:	6a 7f                	push   $0x7f
  jmp alltraps
80106de5:	e9 26 f5 ff ff       	jmp    80106310 <alltraps>

80106dea <vector128>:
.globl vector128
vector128:
  pushl $0
80106dea:	6a 00                	push   $0x0
  pushl $128
80106dec:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106df1:	e9 1a f5 ff ff       	jmp    80106310 <alltraps>

80106df6 <vector129>:
.globl vector129
vector129:
  pushl $0
80106df6:	6a 00                	push   $0x0
  pushl $129
80106df8:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106dfd:	e9 0e f5 ff ff       	jmp    80106310 <alltraps>

80106e02 <vector130>:
.globl vector130
vector130:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $130
80106e04:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106e09:	e9 02 f5 ff ff       	jmp    80106310 <alltraps>

80106e0e <vector131>:
.globl vector131
vector131:
  pushl $0
80106e0e:	6a 00                	push   $0x0
  pushl $131
80106e10:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106e15:	e9 f6 f4 ff ff       	jmp    80106310 <alltraps>

80106e1a <vector132>:
.globl vector132
vector132:
  pushl $0
80106e1a:	6a 00                	push   $0x0
  pushl $132
80106e1c:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106e21:	e9 ea f4 ff ff       	jmp    80106310 <alltraps>

80106e26 <vector133>:
.globl vector133
vector133:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $133
80106e28:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106e2d:	e9 de f4 ff ff       	jmp    80106310 <alltraps>

80106e32 <vector134>:
.globl vector134
vector134:
  pushl $0
80106e32:	6a 00                	push   $0x0
  pushl $134
80106e34:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106e39:	e9 d2 f4 ff ff       	jmp    80106310 <alltraps>

80106e3e <vector135>:
.globl vector135
vector135:
  pushl $0
80106e3e:	6a 00                	push   $0x0
  pushl $135
80106e40:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106e45:	e9 c6 f4 ff ff       	jmp    80106310 <alltraps>

80106e4a <vector136>:
.globl vector136
vector136:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $136
80106e4c:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106e51:	e9 ba f4 ff ff       	jmp    80106310 <alltraps>

80106e56 <vector137>:
.globl vector137
vector137:
  pushl $0
80106e56:	6a 00                	push   $0x0
  pushl $137
80106e58:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106e5d:	e9 ae f4 ff ff       	jmp    80106310 <alltraps>

80106e62 <vector138>:
.globl vector138
vector138:
  pushl $0
80106e62:	6a 00                	push   $0x0
  pushl $138
80106e64:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106e69:	e9 a2 f4 ff ff       	jmp    80106310 <alltraps>

80106e6e <vector139>:
.globl vector139
vector139:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $139
80106e70:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106e75:	e9 96 f4 ff ff       	jmp    80106310 <alltraps>

80106e7a <vector140>:
.globl vector140
vector140:
  pushl $0
80106e7a:	6a 00                	push   $0x0
  pushl $140
80106e7c:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106e81:	e9 8a f4 ff ff       	jmp    80106310 <alltraps>

80106e86 <vector141>:
.globl vector141
vector141:
  pushl $0
80106e86:	6a 00                	push   $0x0
  pushl $141
80106e88:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106e8d:	e9 7e f4 ff ff       	jmp    80106310 <alltraps>

80106e92 <vector142>:
.globl vector142
vector142:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $142
80106e94:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106e99:	e9 72 f4 ff ff       	jmp    80106310 <alltraps>

80106e9e <vector143>:
.globl vector143
vector143:
  pushl $0
80106e9e:	6a 00                	push   $0x0
  pushl $143
80106ea0:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ea5:	e9 66 f4 ff ff       	jmp    80106310 <alltraps>

80106eaa <vector144>:
.globl vector144
vector144:
  pushl $0
80106eaa:	6a 00                	push   $0x0
  pushl $144
80106eac:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106eb1:	e9 5a f4 ff ff       	jmp    80106310 <alltraps>

80106eb6 <vector145>:
.globl vector145
vector145:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $145
80106eb8:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106ebd:	e9 4e f4 ff ff       	jmp    80106310 <alltraps>

80106ec2 <vector146>:
.globl vector146
vector146:
  pushl $0
80106ec2:	6a 00                	push   $0x0
  pushl $146
80106ec4:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106ec9:	e9 42 f4 ff ff       	jmp    80106310 <alltraps>

80106ece <vector147>:
.globl vector147
vector147:
  pushl $0
80106ece:	6a 00                	push   $0x0
  pushl $147
80106ed0:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ed5:	e9 36 f4 ff ff       	jmp    80106310 <alltraps>

80106eda <vector148>:
.globl vector148
vector148:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $148
80106edc:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ee1:	e9 2a f4 ff ff       	jmp    80106310 <alltraps>

80106ee6 <vector149>:
.globl vector149
vector149:
  pushl $0
80106ee6:	6a 00                	push   $0x0
  pushl $149
80106ee8:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106eed:	e9 1e f4 ff ff       	jmp    80106310 <alltraps>

80106ef2 <vector150>:
.globl vector150
vector150:
  pushl $0
80106ef2:	6a 00                	push   $0x0
  pushl $150
80106ef4:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ef9:	e9 12 f4 ff ff       	jmp    80106310 <alltraps>

80106efe <vector151>:
.globl vector151
vector151:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $151
80106f00:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106f05:	e9 06 f4 ff ff       	jmp    80106310 <alltraps>

80106f0a <vector152>:
.globl vector152
vector152:
  pushl $0
80106f0a:	6a 00                	push   $0x0
  pushl $152
80106f0c:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106f11:	e9 fa f3 ff ff       	jmp    80106310 <alltraps>

80106f16 <vector153>:
.globl vector153
vector153:
  pushl $0
80106f16:	6a 00                	push   $0x0
  pushl $153
80106f18:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106f1d:	e9 ee f3 ff ff       	jmp    80106310 <alltraps>

80106f22 <vector154>:
.globl vector154
vector154:
  pushl $0
80106f22:	6a 00                	push   $0x0
  pushl $154
80106f24:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106f29:	e9 e2 f3 ff ff       	jmp    80106310 <alltraps>

80106f2e <vector155>:
.globl vector155
vector155:
  pushl $0
80106f2e:	6a 00                	push   $0x0
  pushl $155
80106f30:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106f35:	e9 d6 f3 ff ff       	jmp    80106310 <alltraps>

80106f3a <vector156>:
.globl vector156
vector156:
  pushl $0
80106f3a:	6a 00                	push   $0x0
  pushl $156
80106f3c:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106f41:	e9 ca f3 ff ff       	jmp    80106310 <alltraps>

80106f46 <vector157>:
.globl vector157
vector157:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $157
80106f48:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106f4d:	e9 be f3 ff ff       	jmp    80106310 <alltraps>

80106f52 <vector158>:
.globl vector158
vector158:
  pushl $0
80106f52:	6a 00                	push   $0x0
  pushl $158
80106f54:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106f59:	e9 b2 f3 ff ff       	jmp    80106310 <alltraps>

80106f5e <vector159>:
.globl vector159
vector159:
  pushl $0
80106f5e:	6a 00                	push   $0x0
  pushl $159
80106f60:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106f65:	e9 a6 f3 ff ff       	jmp    80106310 <alltraps>

80106f6a <vector160>:
.globl vector160
vector160:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $160
80106f6c:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106f71:	e9 9a f3 ff ff       	jmp    80106310 <alltraps>

80106f76 <vector161>:
.globl vector161
vector161:
  pushl $0
80106f76:	6a 00                	push   $0x0
  pushl $161
80106f78:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106f7d:	e9 8e f3 ff ff       	jmp    80106310 <alltraps>

80106f82 <vector162>:
.globl vector162
vector162:
  pushl $0
80106f82:	6a 00                	push   $0x0
  pushl $162
80106f84:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106f89:	e9 82 f3 ff ff       	jmp    80106310 <alltraps>

80106f8e <vector163>:
.globl vector163
vector163:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $163
80106f90:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106f95:	e9 76 f3 ff ff       	jmp    80106310 <alltraps>

80106f9a <vector164>:
.globl vector164
vector164:
  pushl $0
80106f9a:	6a 00                	push   $0x0
  pushl $164
80106f9c:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106fa1:	e9 6a f3 ff ff       	jmp    80106310 <alltraps>

80106fa6 <vector165>:
.globl vector165
vector165:
  pushl $0
80106fa6:	6a 00                	push   $0x0
  pushl $165
80106fa8:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106fad:	e9 5e f3 ff ff       	jmp    80106310 <alltraps>

80106fb2 <vector166>:
.globl vector166
vector166:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $166
80106fb4:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106fb9:	e9 52 f3 ff ff       	jmp    80106310 <alltraps>

80106fbe <vector167>:
.globl vector167
vector167:
  pushl $0
80106fbe:	6a 00                	push   $0x0
  pushl $167
80106fc0:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106fc5:	e9 46 f3 ff ff       	jmp    80106310 <alltraps>

80106fca <vector168>:
.globl vector168
vector168:
  pushl $0
80106fca:	6a 00                	push   $0x0
  pushl $168
80106fcc:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106fd1:	e9 3a f3 ff ff       	jmp    80106310 <alltraps>

80106fd6 <vector169>:
.globl vector169
vector169:
  pushl $0
80106fd6:	6a 00                	push   $0x0
  pushl $169
80106fd8:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106fdd:	e9 2e f3 ff ff       	jmp    80106310 <alltraps>

80106fe2 <vector170>:
.globl vector170
vector170:
  pushl $0
80106fe2:	6a 00                	push   $0x0
  pushl $170
80106fe4:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106fe9:	e9 22 f3 ff ff       	jmp    80106310 <alltraps>

80106fee <vector171>:
.globl vector171
vector171:
  pushl $0
80106fee:	6a 00                	push   $0x0
  pushl $171
80106ff0:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ff5:	e9 16 f3 ff ff       	jmp    80106310 <alltraps>

80106ffa <vector172>:
.globl vector172
vector172:
  pushl $0
80106ffa:	6a 00                	push   $0x0
  pushl $172
80106ffc:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107001:	e9 0a f3 ff ff       	jmp    80106310 <alltraps>

80107006 <vector173>:
.globl vector173
vector173:
  pushl $0
80107006:	6a 00                	push   $0x0
  pushl $173
80107008:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010700d:	e9 fe f2 ff ff       	jmp    80106310 <alltraps>

80107012 <vector174>:
.globl vector174
vector174:
  pushl $0
80107012:	6a 00                	push   $0x0
  pushl $174
80107014:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107019:	e9 f2 f2 ff ff       	jmp    80106310 <alltraps>

8010701e <vector175>:
.globl vector175
vector175:
  pushl $0
8010701e:	6a 00                	push   $0x0
  pushl $175
80107020:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107025:	e9 e6 f2 ff ff       	jmp    80106310 <alltraps>

8010702a <vector176>:
.globl vector176
vector176:
  pushl $0
8010702a:	6a 00                	push   $0x0
  pushl $176
8010702c:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107031:	e9 da f2 ff ff       	jmp    80106310 <alltraps>

80107036 <vector177>:
.globl vector177
vector177:
  pushl $0
80107036:	6a 00                	push   $0x0
  pushl $177
80107038:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010703d:	e9 ce f2 ff ff       	jmp    80106310 <alltraps>

80107042 <vector178>:
.globl vector178
vector178:
  pushl $0
80107042:	6a 00                	push   $0x0
  pushl $178
80107044:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107049:	e9 c2 f2 ff ff       	jmp    80106310 <alltraps>

8010704e <vector179>:
.globl vector179
vector179:
  pushl $0
8010704e:	6a 00                	push   $0x0
  pushl $179
80107050:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107055:	e9 b6 f2 ff ff       	jmp    80106310 <alltraps>

8010705a <vector180>:
.globl vector180
vector180:
  pushl $0
8010705a:	6a 00                	push   $0x0
  pushl $180
8010705c:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107061:	e9 aa f2 ff ff       	jmp    80106310 <alltraps>

80107066 <vector181>:
.globl vector181
vector181:
  pushl $0
80107066:	6a 00                	push   $0x0
  pushl $181
80107068:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010706d:	e9 9e f2 ff ff       	jmp    80106310 <alltraps>

80107072 <vector182>:
.globl vector182
vector182:
  pushl $0
80107072:	6a 00                	push   $0x0
  pushl $182
80107074:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107079:	e9 92 f2 ff ff       	jmp    80106310 <alltraps>

8010707e <vector183>:
.globl vector183
vector183:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $183
80107080:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107085:	e9 86 f2 ff ff       	jmp    80106310 <alltraps>

8010708a <vector184>:
.globl vector184
vector184:
  pushl $0
8010708a:	6a 00                	push   $0x0
  pushl $184
8010708c:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107091:	e9 7a f2 ff ff       	jmp    80106310 <alltraps>

80107096 <vector185>:
.globl vector185
vector185:
  pushl $0
80107096:	6a 00                	push   $0x0
  pushl $185
80107098:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010709d:	e9 6e f2 ff ff       	jmp    80106310 <alltraps>

801070a2 <vector186>:
.globl vector186
vector186:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $186
801070a4:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801070a9:	e9 62 f2 ff ff       	jmp    80106310 <alltraps>

801070ae <vector187>:
.globl vector187
vector187:
  pushl $0
801070ae:	6a 00                	push   $0x0
  pushl $187
801070b0:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801070b5:	e9 56 f2 ff ff       	jmp    80106310 <alltraps>

801070ba <vector188>:
.globl vector188
vector188:
  pushl $0
801070ba:	6a 00                	push   $0x0
  pushl $188
801070bc:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801070c1:	e9 4a f2 ff ff       	jmp    80106310 <alltraps>

801070c6 <vector189>:
.globl vector189
vector189:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $189
801070c8:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801070cd:	e9 3e f2 ff ff       	jmp    80106310 <alltraps>

801070d2 <vector190>:
.globl vector190
vector190:
  pushl $0
801070d2:	6a 00                	push   $0x0
  pushl $190
801070d4:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801070d9:	e9 32 f2 ff ff       	jmp    80106310 <alltraps>

801070de <vector191>:
.globl vector191
vector191:
  pushl $0
801070de:	6a 00                	push   $0x0
  pushl $191
801070e0:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801070e5:	e9 26 f2 ff ff       	jmp    80106310 <alltraps>

801070ea <vector192>:
.globl vector192
vector192:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $192
801070ec:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801070f1:	e9 1a f2 ff ff       	jmp    80106310 <alltraps>

801070f6 <vector193>:
.globl vector193
vector193:
  pushl $0
801070f6:	6a 00                	push   $0x0
  pushl $193
801070f8:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801070fd:	e9 0e f2 ff ff       	jmp    80106310 <alltraps>

80107102 <vector194>:
.globl vector194
vector194:
  pushl $0
80107102:	6a 00                	push   $0x0
  pushl $194
80107104:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107109:	e9 02 f2 ff ff       	jmp    80106310 <alltraps>

8010710e <vector195>:
.globl vector195
vector195:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $195
80107110:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107115:	e9 f6 f1 ff ff       	jmp    80106310 <alltraps>

8010711a <vector196>:
.globl vector196
vector196:
  pushl $0
8010711a:	6a 00                	push   $0x0
  pushl $196
8010711c:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107121:	e9 ea f1 ff ff       	jmp    80106310 <alltraps>

80107126 <vector197>:
.globl vector197
vector197:
  pushl $0
80107126:	6a 00                	push   $0x0
  pushl $197
80107128:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010712d:	e9 de f1 ff ff       	jmp    80106310 <alltraps>

80107132 <vector198>:
.globl vector198
vector198:
  pushl $0
80107132:	6a 00                	push   $0x0
  pushl $198
80107134:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107139:	e9 d2 f1 ff ff       	jmp    80106310 <alltraps>

8010713e <vector199>:
.globl vector199
vector199:
  pushl $0
8010713e:	6a 00                	push   $0x0
  pushl $199
80107140:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107145:	e9 c6 f1 ff ff       	jmp    80106310 <alltraps>

8010714a <vector200>:
.globl vector200
vector200:
  pushl $0
8010714a:	6a 00                	push   $0x0
  pushl $200
8010714c:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107151:	e9 ba f1 ff ff       	jmp    80106310 <alltraps>

80107156 <vector201>:
.globl vector201
vector201:
  pushl $0
80107156:	6a 00                	push   $0x0
  pushl $201
80107158:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010715d:	e9 ae f1 ff ff       	jmp    80106310 <alltraps>

80107162 <vector202>:
.globl vector202
vector202:
  pushl $0
80107162:	6a 00                	push   $0x0
  pushl $202
80107164:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107169:	e9 a2 f1 ff ff       	jmp    80106310 <alltraps>

8010716e <vector203>:
.globl vector203
vector203:
  pushl $0
8010716e:	6a 00                	push   $0x0
  pushl $203
80107170:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107175:	e9 96 f1 ff ff       	jmp    80106310 <alltraps>

8010717a <vector204>:
.globl vector204
vector204:
  pushl $0
8010717a:	6a 00                	push   $0x0
  pushl $204
8010717c:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107181:	e9 8a f1 ff ff       	jmp    80106310 <alltraps>

80107186 <vector205>:
.globl vector205
vector205:
  pushl $0
80107186:	6a 00                	push   $0x0
  pushl $205
80107188:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010718d:	e9 7e f1 ff ff       	jmp    80106310 <alltraps>

80107192 <vector206>:
.globl vector206
vector206:
  pushl $0
80107192:	6a 00                	push   $0x0
  pushl $206
80107194:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107199:	e9 72 f1 ff ff       	jmp    80106310 <alltraps>

8010719e <vector207>:
.globl vector207
vector207:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $207
801071a0:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801071a5:	e9 66 f1 ff ff       	jmp    80106310 <alltraps>

801071aa <vector208>:
.globl vector208
vector208:
  pushl $0
801071aa:	6a 00                	push   $0x0
  pushl $208
801071ac:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801071b1:	e9 5a f1 ff ff       	jmp    80106310 <alltraps>

801071b6 <vector209>:
.globl vector209
vector209:
  pushl $0
801071b6:	6a 00                	push   $0x0
  pushl $209
801071b8:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801071bd:	e9 4e f1 ff ff       	jmp    80106310 <alltraps>

801071c2 <vector210>:
.globl vector210
vector210:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $210
801071c4:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801071c9:	e9 42 f1 ff ff       	jmp    80106310 <alltraps>

801071ce <vector211>:
.globl vector211
vector211:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $211
801071d0:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801071d5:	e9 36 f1 ff ff       	jmp    80106310 <alltraps>

801071da <vector212>:
.globl vector212
vector212:
  pushl $0
801071da:	6a 00                	push   $0x0
  pushl $212
801071dc:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801071e1:	e9 2a f1 ff ff       	jmp    80106310 <alltraps>

801071e6 <vector213>:
.globl vector213
vector213:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $213
801071e8:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801071ed:	e9 1e f1 ff ff       	jmp    80106310 <alltraps>

801071f2 <vector214>:
.globl vector214
vector214:
  pushl $0
801071f2:	6a 00                	push   $0x0
  pushl $214
801071f4:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801071f9:	e9 12 f1 ff ff       	jmp    80106310 <alltraps>

801071fe <vector215>:
.globl vector215
vector215:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $215
80107200:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107205:	e9 06 f1 ff ff       	jmp    80106310 <alltraps>

8010720a <vector216>:
.globl vector216
vector216:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $216
8010720c:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107211:	e9 fa f0 ff ff       	jmp    80106310 <alltraps>

80107216 <vector217>:
.globl vector217
vector217:
  pushl $0
80107216:	6a 00                	push   $0x0
  pushl $217
80107218:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010721d:	e9 ee f0 ff ff       	jmp    80106310 <alltraps>

80107222 <vector218>:
.globl vector218
vector218:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $218
80107224:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107229:	e9 e2 f0 ff ff       	jmp    80106310 <alltraps>

8010722e <vector219>:
.globl vector219
vector219:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $219
80107230:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107235:	e9 d6 f0 ff ff       	jmp    80106310 <alltraps>

8010723a <vector220>:
.globl vector220
vector220:
  pushl $0
8010723a:	6a 00                	push   $0x0
  pushl $220
8010723c:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107241:	e9 ca f0 ff ff       	jmp    80106310 <alltraps>

80107246 <vector221>:
.globl vector221
vector221:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $221
80107248:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010724d:	e9 be f0 ff ff       	jmp    80106310 <alltraps>

80107252 <vector222>:
.globl vector222
vector222:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $222
80107254:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107259:	e9 b2 f0 ff ff       	jmp    80106310 <alltraps>

8010725e <vector223>:
.globl vector223
vector223:
  pushl $0
8010725e:	6a 00                	push   $0x0
  pushl $223
80107260:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107265:	e9 a6 f0 ff ff       	jmp    80106310 <alltraps>

8010726a <vector224>:
.globl vector224
vector224:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $224
8010726c:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107271:	e9 9a f0 ff ff       	jmp    80106310 <alltraps>

80107276 <vector225>:
.globl vector225
vector225:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $225
80107278:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010727d:	e9 8e f0 ff ff       	jmp    80106310 <alltraps>

80107282 <vector226>:
.globl vector226
vector226:
  pushl $0
80107282:	6a 00                	push   $0x0
  pushl $226
80107284:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107289:	e9 82 f0 ff ff       	jmp    80106310 <alltraps>

8010728e <vector227>:
.globl vector227
vector227:
  pushl $0
8010728e:	6a 00                	push   $0x0
  pushl $227
80107290:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107295:	e9 76 f0 ff ff       	jmp    80106310 <alltraps>

8010729a <vector228>:
.globl vector228
vector228:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $228
8010729c:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801072a1:	e9 6a f0 ff ff       	jmp    80106310 <alltraps>

801072a6 <vector229>:
.globl vector229
vector229:
  pushl $0
801072a6:	6a 00                	push   $0x0
  pushl $229
801072a8:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801072ad:	e9 5e f0 ff ff       	jmp    80106310 <alltraps>

801072b2 <vector230>:
.globl vector230
vector230:
  pushl $0
801072b2:	6a 00                	push   $0x0
  pushl $230
801072b4:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801072b9:	e9 52 f0 ff ff       	jmp    80106310 <alltraps>

801072be <vector231>:
.globl vector231
vector231:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $231
801072c0:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801072c5:	e9 46 f0 ff ff       	jmp    80106310 <alltraps>

801072ca <vector232>:
.globl vector232
vector232:
  pushl $0
801072ca:	6a 00                	push   $0x0
  pushl $232
801072cc:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801072d1:	e9 3a f0 ff ff       	jmp    80106310 <alltraps>

801072d6 <vector233>:
.globl vector233
vector233:
  pushl $0
801072d6:	6a 00                	push   $0x0
  pushl $233
801072d8:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801072dd:	e9 2e f0 ff ff       	jmp    80106310 <alltraps>

801072e2 <vector234>:
.globl vector234
vector234:
  pushl $0
801072e2:	6a 00                	push   $0x0
  pushl $234
801072e4:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801072e9:	e9 22 f0 ff ff       	jmp    80106310 <alltraps>

801072ee <vector235>:
.globl vector235
vector235:
  pushl $0
801072ee:	6a 00                	push   $0x0
  pushl $235
801072f0:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801072f5:	e9 16 f0 ff ff       	jmp    80106310 <alltraps>

801072fa <vector236>:
.globl vector236
vector236:
  pushl $0
801072fa:	6a 00                	push   $0x0
  pushl $236
801072fc:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107301:	e9 0a f0 ff ff       	jmp    80106310 <alltraps>

80107306 <vector237>:
.globl vector237
vector237:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $237
80107308:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010730d:	e9 fe ef ff ff       	jmp    80106310 <alltraps>

80107312 <vector238>:
.globl vector238
vector238:
  pushl $0
80107312:	6a 00                	push   $0x0
  pushl $238
80107314:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107319:	e9 f2 ef ff ff       	jmp    80106310 <alltraps>

8010731e <vector239>:
.globl vector239
vector239:
  pushl $0
8010731e:	6a 00                	push   $0x0
  pushl $239
80107320:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107325:	e9 e6 ef ff ff       	jmp    80106310 <alltraps>

8010732a <vector240>:
.globl vector240
vector240:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $240
8010732c:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107331:	e9 da ef ff ff       	jmp    80106310 <alltraps>

80107336 <vector241>:
.globl vector241
vector241:
  pushl $0
80107336:	6a 00                	push   $0x0
  pushl $241
80107338:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010733d:	e9 ce ef ff ff       	jmp    80106310 <alltraps>

80107342 <vector242>:
.globl vector242
vector242:
  pushl $0
80107342:	6a 00                	push   $0x0
  pushl $242
80107344:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107349:	e9 c2 ef ff ff       	jmp    80106310 <alltraps>

8010734e <vector243>:
.globl vector243
vector243:
  pushl $0
8010734e:	6a 00                	push   $0x0
  pushl $243
80107350:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107355:	e9 b6 ef ff ff       	jmp    80106310 <alltraps>

8010735a <vector244>:
.globl vector244
vector244:
  pushl $0
8010735a:	6a 00                	push   $0x0
  pushl $244
8010735c:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107361:	e9 aa ef ff ff       	jmp    80106310 <alltraps>

80107366 <vector245>:
.globl vector245
vector245:
  pushl $0
80107366:	6a 00                	push   $0x0
  pushl $245
80107368:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010736d:	e9 9e ef ff ff       	jmp    80106310 <alltraps>

80107372 <vector246>:
.globl vector246
vector246:
  pushl $0
80107372:	6a 00                	push   $0x0
  pushl $246
80107374:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107379:	e9 92 ef ff ff       	jmp    80106310 <alltraps>

8010737e <vector247>:
.globl vector247
vector247:
  pushl $0
8010737e:	6a 00                	push   $0x0
  pushl $247
80107380:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107385:	e9 86 ef ff ff       	jmp    80106310 <alltraps>

8010738a <vector248>:
.globl vector248
vector248:
  pushl $0
8010738a:	6a 00                	push   $0x0
  pushl $248
8010738c:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107391:	e9 7a ef ff ff       	jmp    80106310 <alltraps>

80107396 <vector249>:
.globl vector249
vector249:
  pushl $0
80107396:	6a 00                	push   $0x0
  pushl $249
80107398:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010739d:	e9 6e ef ff ff       	jmp    80106310 <alltraps>

801073a2 <vector250>:
.globl vector250
vector250:
  pushl $0
801073a2:	6a 00                	push   $0x0
  pushl $250
801073a4:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801073a9:	e9 62 ef ff ff       	jmp    80106310 <alltraps>

801073ae <vector251>:
.globl vector251
vector251:
  pushl $0
801073ae:	6a 00                	push   $0x0
  pushl $251
801073b0:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801073b5:	e9 56 ef ff ff       	jmp    80106310 <alltraps>

801073ba <vector252>:
.globl vector252
vector252:
  pushl $0
801073ba:	6a 00                	push   $0x0
  pushl $252
801073bc:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801073c1:	e9 4a ef ff ff       	jmp    80106310 <alltraps>

801073c6 <vector253>:
.globl vector253
vector253:
  pushl $0
801073c6:	6a 00                	push   $0x0
  pushl $253
801073c8:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801073cd:	e9 3e ef ff ff       	jmp    80106310 <alltraps>

801073d2 <vector254>:
.globl vector254
vector254:
  pushl $0
801073d2:	6a 00                	push   $0x0
  pushl $254
801073d4:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801073d9:	e9 32 ef ff ff       	jmp    80106310 <alltraps>

801073de <vector255>:
.globl vector255
vector255:
  pushl $0
801073de:	6a 00                	push   $0x0
  pushl $255
801073e0:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801073e5:	e9 26 ef ff ff       	jmp    80106310 <alltraps>
801073ea:	66 90                	xchg   %ax,%ax

801073ec <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801073ec:	55                   	push   %ebp
801073ed:	89 e5                	mov    %esp,%ebp
801073ef:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801073f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801073f5:	48                   	dec    %eax
801073f6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801073fa:	8b 45 08             	mov    0x8(%ebp),%eax
801073fd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107401:	8b 45 08             	mov    0x8(%ebp),%eax
80107404:	c1 e8 10             	shr    $0x10,%eax
80107407:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010740b:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010740e:	0f 01 10             	lgdtl  (%eax)
}
80107411:	c9                   	leave  
80107412:	c3                   	ret    

80107413 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107413:	55                   	push   %ebp
80107414:	89 e5                	mov    %esp,%ebp
80107416:	83 ec 04             	sub    $0x4,%esp
80107419:	8b 45 08             	mov    0x8(%ebp),%eax
8010741c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107420:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107423:	0f 00 d8             	ltr    %ax
}
80107426:	c9                   	leave  
80107427:	c3                   	ret    

80107428 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107428:	55                   	push   %ebp
80107429:	89 e5                	mov    %esp,%ebp
8010742b:	83 ec 04             	sub    $0x4,%esp
8010742e:	8b 45 08             	mov    0x8(%ebp),%eax
80107431:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107435:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107438:	8e e8                	mov    %eax,%gs
}
8010743a:	c9                   	leave  
8010743b:	c3                   	ret    

8010743c <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
8010743c:	55                   	push   %ebp
8010743d:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010743f:	8b 45 08             	mov    0x8(%ebp),%eax
80107442:	0f 22 d8             	mov    %eax,%cr3
}
80107445:	5d                   	pop    %ebp
80107446:	c3                   	ret    

80107447 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107447:	55                   	push   %ebp
80107448:	89 e5                	mov    %esp,%ebp
8010744a:	8b 45 08             	mov    0x8(%ebp),%eax
8010744d:	05 00 00 00 80       	add    $0x80000000,%eax
80107452:	5d                   	pop    %ebp
80107453:	c3                   	ret    

80107454 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107454:	55                   	push   %ebp
80107455:	89 e5                	mov    %esp,%ebp
80107457:	8b 45 08             	mov    0x8(%ebp),%eax
8010745a:	05 00 00 00 80       	add    $0x80000000,%eax
8010745f:	5d                   	pop    %ebp
80107460:	c3                   	ret    

80107461 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107461:	55                   	push   %ebp
80107462:	89 e5                	mov    %esp,%ebp
80107464:	53                   	push   %ebx
80107465:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107468:	e8 9a ba ff ff       	call   80102f07 <cpunum>
8010746d:	89 c2                	mov    %eax,%edx
8010746f:	89 d0                	mov    %edx,%eax
80107471:	d1 e0                	shl    %eax
80107473:	01 d0                	add    %edx,%eax
80107475:	c1 e0 04             	shl    $0x4,%eax
80107478:	29 d0                	sub    %edx,%eax
8010747a:	c1 e0 02             	shl    $0x2,%eax
8010747d:	05 40 fe 10 80       	add    $0x8010fe40,%eax
80107482:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107485:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107488:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010748e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107491:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107497:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010749a:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010749e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a1:	8a 50 7d             	mov    0x7d(%eax),%dl
801074a4:	83 e2 f0             	and    $0xfffffff0,%edx
801074a7:	83 ca 0a             	or     $0xa,%edx
801074aa:	88 50 7d             	mov    %dl,0x7d(%eax)
801074ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b0:	8a 50 7d             	mov    0x7d(%eax),%dl
801074b3:	83 ca 10             	or     $0x10,%edx
801074b6:	88 50 7d             	mov    %dl,0x7d(%eax)
801074b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074bc:	8a 50 7d             	mov    0x7d(%eax),%dl
801074bf:	83 e2 9f             	and    $0xffffff9f,%edx
801074c2:	88 50 7d             	mov    %dl,0x7d(%eax)
801074c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c8:	8a 50 7d             	mov    0x7d(%eax),%dl
801074cb:	83 ca 80             	or     $0xffffff80,%edx
801074ce:	88 50 7d             	mov    %dl,0x7d(%eax)
801074d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d4:	8a 50 7e             	mov    0x7e(%eax),%dl
801074d7:	83 ca 0f             	or     $0xf,%edx
801074da:	88 50 7e             	mov    %dl,0x7e(%eax)
801074dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e0:	8a 50 7e             	mov    0x7e(%eax),%dl
801074e3:	83 e2 ef             	and    $0xffffffef,%edx
801074e6:	88 50 7e             	mov    %dl,0x7e(%eax)
801074e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ec:	8a 50 7e             	mov    0x7e(%eax),%dl
801074ef:	83 e2 df             	and    $0xffffffdf,%edx
801074f2:	88 50 7e             	mov    %dl,0x7e(%eax)
801074f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f8:	8a 50 7e             	mov    0x7e(%eax),%dl
801074fb:	83 ca 40             	or     $0x40,%edx
801074fe:	88 50 7e             	mov    %dl,0x7e(%eax)
80107501:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107504:	8a 50 7e             	mov    0x7e(%eax),%dl
80107507:	83 ca 80             	or     $0xffffff80,%edx
8010750a:	88 50 7e             	mov    %dl,0x7e(%eax)
8010750d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107510:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107514:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107517:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010751e:	ff ff 
80107520:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107523:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010752a:	00 00 
8010752c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010752f:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107536:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107539:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010753f:	83 e2 f0             	and    $0xfffffff0,%edx
80107542:	83 ca 02             	or     $0x2,%edx
80107545:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010754b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010754e:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107554:	83 ca 10             	or     $0x10,%edx
80107557:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010755d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107560:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107566:	83 e2 9f             	and    $0xffffff9f,%edx
80107569:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010756f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107572:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107578:	83 ca 80             	or     $0xffffff80,%edx
8010757b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107581:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107584:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010758a:	83 ca 0f             	or     $0xf,%edx
8010758d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107593:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107596:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010759c:	83 e2 ef             	and    $0xffffffef,%edx
8010759f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075a8:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801075ae:	83 e2 df             	and    $0xffffffdf,%edx
801075b1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ba:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801075c0:	83 ca 40             	or     $0x40,%edx
801075c3:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075cc:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801075d2:	83 ca 80             	or     $0xffffff80,%edx
801075d5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075de:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801075e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e8:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801075ef:	ff ff 
801075f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f4:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801075fb:	00 00 
801075fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107600:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107607:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010760a:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107610:	83 e2 f0             	and    $0xfffffff0,%edx
80107613:	83 ca 0a             	or     $0xa,%edx
80107616:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010761c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010761f:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107625:	83 ca 10             	or     $0x10,%edx
80107628:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010762e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107631:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107637:	83 ca 60             	or     $0x60,%edx
8010763a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107640:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107643:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107649:	83 ca 80             	or     $0xffffff80,%edx
8010764c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107652:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107655:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010765b:	83 ca 0f             	or     $0xf,%edx
8010765e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107664:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107667:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010766d:	83 e2 ef             	and    $0xffffffef,%edx
80107670:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107679:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010767f:	83 e2 df             	and    $0xffffffdf,%edx
80107682:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107688:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010768b:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107691:	83 ca 40             	or     $0x40,%edx
80107694:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010769a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010769d:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801076a3:	83 ca 80             	or     $0xffffff80,%edx
801076a6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076af:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801076b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b9:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801076c0:	ff ff 
801076c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c5:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801076cc:	00 00 
801076ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d1:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801076d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076db:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801076e1:	83 e2 f0             	and    $0xfffffff0,%edx
801076e4:	83 ca 02             	or     $0x2,%edx
801076e7:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801076ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076f0:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801076f6:	83 ca 10             	or     $0x10,%edx
801076f9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801076ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107702:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107708:	83 ca 60             	or     $0x60,%edx
8010770b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107711:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107714:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
8010771a:	83 ca 80             	or     $0xffffff80,%edx
8010771d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107723:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107726:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010772c:	83 ca 0f             	or     $0xf,%edx
8010772f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107735:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107738:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010773e:	83 e2 ef             	and    $0xffffffef,%edx
80107741:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774a:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107750:	83 e2 df             	and    $0xffffffdf,%edx
80107753:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010775c:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107762:	83 ca 40             	or     $0x40,%edx
80107765:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010776b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010776e:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107774:	83 ca 80             	or     $0xffffff80,%edx
80107777:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010777d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107780:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107787:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010778a:	05 b4 00 00 00       	add    $0xb4,%eax
8010778f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107792:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80107798:	c1 ea 10             	shr    $0x10,%edx
8010779b:	88 d1                	mov    %dl,%cl
8010779d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801077a0:	81 c2 b4 00 00 00    	add    $0xb4,%edx
801077a6:	c1 ea 18             	shr    $0x18,%edx
801077a9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801077ac:	66 c7 83 88 00 00 00 	movw   $0x0,0x88(%ebx)
801077b3:	00 00 
801077b5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801077b8:	66 89 83 8a 00 00 00 	mov    %ax,0x8a(%ebx)
801077bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c2:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801077c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077cb:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801077d1:	83 e1 f0             	and    $0xfffffff0,%ecx
801077d4:	83 c9 02             	or     $0x2,%ecx
801077d7:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801077dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e0:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801077e6:	83 c9 10             	or     $0x10,%ecx
801077e9:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801077ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f2:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801077f8:	83 e1 9f             	and    $0xffffff9f,%ecx
801077fb:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107801:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107804:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
8010780a:	83 c9 80             	or     $0xffffff80,%ecx
8010780d:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107816:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
8010781c:	83 e1 f0             	and    $0xfffffff0,%ecx
8010781f:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107828:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
8010782e:	83 e1 ef             	and    $0xffffffef,%ecx
80107831:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010783a:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107840:	83 e1 df             	and    $0xffffffdf,%ecx
80107843:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107849:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010784c:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107852:	83 c9 40             	or     $0x40,%ecx
80107855:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010785b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010785e:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107864:	83 c9 80             	or     $0xffffff80,%ecx
80107867:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010786d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107870:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107876:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107879:	83 c0 70             	add    $0x70,%eax
8010787c:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107883:	00 
80107884:	89 04 24             	mov    %eax,(%esp)
80107887:	e8 60 fb ff ff       	call   801073ec <lgdt>
  loadgs(SEG_KCPU << 3);
8010788c:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107893:	e8 90 fb ff ff       	call   80107428 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107898:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010789b:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801078a1:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801078a8:	00 00 00 00 
}
801078ac:	83 c4 24             	add    $0x24,%esp
801078af:	5b                   	pop    %ebx
801078b0:	5d                   	pop    %ebp
801078b1:	c3                   	ret    

801078b2 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801078b2:	55                   	push   %ebp
801078b3:	89 e5                	mov    %esp,%ebp
801078b5:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801078b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801078bb:	c1 e8 16             	shr    $0x16,%eax
801078be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801078c5:	8b 45 08             	mov    0x8(%ebp),%eax
801078c8:	01 d0                	add    %edx,%eax
801078ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801078cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078d0:	8b 00                	mov    (%eax),%eax
801078d2:	83 e0 01             	and    $0x1,%eax
801078d5:	85 c0                	test   %eax,%eax
801078d7:	74 17                	je     801078f0 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801078d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078dc:	8b 00                	mov    (%eax),%eax
801078de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801078e3:	89 04 24             	mov    %eax,(%esp)
801078e6:	e8 69 fb ff ff       	call   80107454 <p2v>
801078eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801078ee:	eb 4b                	jmp    8010793b <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801078f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801078f4:	74 0e                	je     80107904 <walkpgdir+0x52>
801078f6:	e8 84 b2 ff ff       	call   80102b7f <kalloc>
801078fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801078fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107902:	75 07                	jne    8010790b <walkpgdir+0x59>
      return 0;
80107904:	b8 00 00 00 00       	mov    $0x0,%eax
80107909:	eb 47                	jmp    80107952 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010790b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107912:	00 
80107913:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010791a:	00 
8010791b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791e:	89 04 24             	mov    %eax,(%esp)
80107921:	e8 7c d5 ff ff       	call   80104ea2 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107926:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107929:	89 04 24             	mov    %eax,(%esp)
8010792c:	e8 16 fb ff ff       	call   80107447 <v2p>
80107931:	89 c2                	mov    %eax,%edx
80107933:	83 ca 07             	or     $0x7,%edx
80107936:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107939:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010793b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010793e:	c1 e8 0c             	shr    $0xc,%eax
80107941:	25 ff 03 00 00       	and    $0x3ff,%eax
80107946:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010794d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107950:	01 d0                	add    %edx,%eax
}
80107952:	c9                   	leave  
80107953:	c3                   	ret    

80107954 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107954:	55                   	push   %ebp
80107955:	89 e5                	mov    %esp,%ebp
80107957:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010795a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010795d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107962:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107965:	8b 55 0c             	mov    0xc(%ebp),%edx
80107968:	8b 45 10             	mov    0x10(%ebp),%eax
8010796b:	01 d0                	add    %edx,%eax
8010796d:	48                   	dec    %eax
8010796e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107973:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107976:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010797d:	00 
8010797e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107981:	89 44 24 04          	mov    %eax,0x4(%esp)
80107985:	8b 45 08             	mov    0x8(%ebp),%eax
80107988:	89 04 24             	mov    %eax,(%esp)
8010798b:	e8 22 ff ff ff       	call   801078b2 <walkpgdir>
80107990:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107993:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107997:	75 07                	jne    801079a0 <mappages+0x4c>
      return -1;
80107999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010799e:	eb 46                	jmp    801079e6 <mappages+0x92>
    if(*pte & PTE_P)
801079a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801079a3:	8b 00                	mov    (%eax),%eax
801079a5:	83 e0 01             	and    $0x1,%eax
801079a8:	85 c0                	test   %eax,%eax
801079aa:	74 0c                	je     801079b8 <mappages+0x64>
      panic("remap");
801079ac:	c7 04 24 cc 87 10 80 	movl   $0x801087cc,(%esp)
801079b3:	e8 7e 8b ff ff       	call   80100536 <panic>
    *pte = pa | perm | PTE_P;
801079b8:	8b 45 18             	mov    0x18(%ebp),%eax
801079bb:	0b 45 14             	or     0x14(%ebp),%eax
801079be:	89 c2                	mov    %eax,%edx
801079c0:	83 ca 01             	or     $0x1,%edx
801079c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801079c6:	89 10                	mov    %edx,(%eax)
    if(a == last)
801079c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801079ce:	74 10                	je     801079e0 <mappages+0x8c>
      break;
    a += PGSIZE;
801079d0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801079d7:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801079de:	eb 96                	jmp    80107976 <mappages+0x22>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801079e0:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801079e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801079e6:	c9                   	leave  
801079e7:	c3                   	ret    

801079e8 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm()
{
801079e8:	55                   	push   %ebp
801079e9:	89 e5                	mov    %esp,%ebp
801079eb:	53                   	push   %ebx
801079ec:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801079ef:	e8 8b b1 ff ff       	call   80102b7f <kalloc>
801079f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801079f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801079fb:	75 0a                	jne    80107a07 <setupkvm+0x1f>
    return 0;
801079fd:	b8 00 00 00 00       	mov    $0x0,%eax
80107a02:	e9 98 00 00 00       	jmp    80107a9f <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80107a07:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107a0e:	00 
80107a0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107a16:	00 
80107a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a1a:	89 04 24             	mov    %eax,(%esp)
80107a1d:	e8 80 d4 ff ff       	call   80104ea2 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107a22:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107a29:	e8 26 fa ff ff       	call   80107454 <p2v>
80107a2e:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107a33:	76 0c                	jbe    80107a41 <setupkvm+0x59>
    panic("PHYSTOP too high");
80107a35:	c7 04 24 d2 87 10 80 	movl   $0x801087d2,(%esp)
80107a3c:	e8 f5 8a ff ff       	call   80100536 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a41:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107a48:	eb 49                	jmp    80107a93 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
80107a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107a4d:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80107a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107a53:	8b 50 04             	mov    0x4(%eax),%edx
80107a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a59:	8b 58 08             	mov    0x8(%eax),%ebx
80107a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a5f:	8b 40 04             	mov    0x4(%eax),%eax
80107a62:	29 c3                	sub    %eax,%ebx
80107a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a67:	8b 00                	mov    (%eax),%eax
80107a69:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107a6d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107a71:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107a75:	89 44 24 04          	mov    %eax,0x4(%esp)
80107a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a7c:	89 04 24             	mov    %eax,(%esp)
80107a7f:	e8 d0 fe ff ff       	call   80107954 <mappages>
80107a84:	85 c0                	test   %eax,%eax
80107a86:	79 07                	jns    80107a8f <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107a88:	b8 00 00 00 00       	mov    $0x0,%eax
80107a8d:	eb 10                	jmp    80107a9f <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a8f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107a93:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107a9a:	72 ae                	jb     80107a4a <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107a9f:	83 c4 34             	add    $0x34,%esp
80107aa2:	5b                   	pop    %ebx
80107aa3:	5d                   	pop    %ebp
80107aa4:	c3                   	ret    

80107aa5 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107aa5:	55                   	push   %ebp
80107aa6:	89 e5                	mov    %esp,%ebp
80107aa8:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107aab:	e8 38 ff ff ff       	call   801079e8 <setupkvm>
80107ab0:	a3 18 2c 11 80       	mov    %eax,0x80112c18
  switchkvm();
80107ab5:	e8 02 00 00 00       	call   80107abc <switchkvm>
}
80107aba:	c9                   	leave  
80107abb:	c3                   	ret    

80107abc <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107abc:	55                   	push   %ebp
80107abd:	89 e5                	mov    %esp,%ebp
80107abf:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107ac2:	a1 18 2c 11 80       	mov    0x80112c18,%eax
80107ac7:	89 04 24             	mov    %eax,(%esp)
80107aca:	e8 78 f9 ff ff       	call   80107447 <v2p>
80107acf:	89 04 24             	mov    %eax,(%esp)
80107ad2:	e8 65 f9 ff ff       	call   8010743c <lcr3>
}
80107ad7:	c9                   	leave  
80107ad8:	c3                   	ret    

80107ad9 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107ad9:	55                   	push   %ebp
80107ada:	89 e5                	mov    %esp,%ebp
80107adc:	53                   	push   %ebx
80107add:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107ae0:	e8 bc d2 ff ff       	call   80104da1 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107ae5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107aeb:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107af2:	83 c2 08             	add    $0x8,%edx
80107af5:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80107afc:	83 c1 08             	add    $0x8,%ecx
80107aff:	c1 e9 10             	shr    $0x10,%ecx
80107b02:	88 cb                	mov    %cl,%bl
80107b04:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80107b0b:	83 c1 08             	add    $0x8,%ecx
80107b0e:	c1 e9 18             	shr    $0x18,%ecx
80107b11:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107b18:	67 00 
80107b1a:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80107b21:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80107b27:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107b2d:	83 e2 f0             	and    $0xfffffff0,%edx
80107b30:	83 ca 09             	or     $0x9,%edx
80107b33:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107b39:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107b3f:	83 ca 10             	or     $0x10,%edx
80107b42:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107b48:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107b4e:	83 e2 9f             	and    $0xffffff9f,%edx
80107b51:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107b57:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107b5d:	83 ca 80             	or     $0xffffff80,%edx
80107b60:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107b66:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107b6c:	83 e2 f0             	and    $0xfffffff0,%edx
80107b6f:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107b75:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107b7b:	83 e2 ef             	and    $0xffffffef,%edx
80107b7e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107b84:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107b8a:	83 e2 df             	and    $0xffffffdf,%edx
80107b8d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107b93:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107b99:	83 ca 40             	or     $0x40,%edx
80107b9c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107ba2:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107ba8:	83 e2 7f             	and    $0x7f,%edx
80107bab:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107bb1:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107bb7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107bbd:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107bc3:	83 e2 ef             	and    $0xffffffef,%edx
80107bc6:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107bcc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107bd2:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107bd8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107bde:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107be5:	8b 52 08             	mov    0x8(%edx),%edx
80107be8:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107bee:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107bf1:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107bf8:	e8 16 f8 ff ff       	call   80107413 <ltr>
  if(p->pgdir == 0)
80107bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80107c00:	8b 40 04             	mov    0x4(%eax),%eax
80107c03:	85 c0                	test   %eax,%eax
80107c05:	75 0c                	jne    80107c13 <switchuvm+0x13a>
    panic("switchuvm: no pgdir");
80107c07:	c7 04 24 e3 87 10 80 	movl   $0x801087e3,(%esp)
80107c0e:	e8 23 89 ff ff       	call   80100536 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107c13:	8b 45 08             	mov    0x8(%ebp),%eax
80107c16:	8b 40 04             	mov    0x4(%eax),%eax
80107c19:	89 04 24             	mov    %eax,(%esp)
80107c1c:	e8 26 f8 ff ff       	call   80107447 <v2p>
80107c21:	89 04 24             	mov    %eax,(%esp)
80107c24:	e8 13 f8 ff ff       	call   8010743c <lcr3>
  popcli();
80107c29:	e8 b9 d1 ff ff       	call   80104de7 <popcli>
}
80107c2e:	83 c4 14             	add    $0x14,%esp
80107c31:	5b                   	pop    %ebx
80107c32:	5d                   	pop    %ebp
80107c33:	c3                   	ret    

80107c34 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107c34:	55                   	push   %ebp
80107c35:	89 e5                	mov    %esp,%ebp
80107c37:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107c3a:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107c41:	76 0c                	jbe    80107c4f <inituvm+0x1b>
    panic("inituvm: more than a page");
80107c43:	c7 04 24 f7 87 10 80 	movl   $0x801087f7,(%esp)
80107c4a:	e8 e7 88 ff ff       	call   80100536 <panic>
  mem = kalloc();
80107c4f:	e8 2b af ff ff       	call   80102b7f <kalloc>
80107c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107c57:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c5e:	00 
80107c5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c66:	00 
80107c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6a:	89 04 24             	mov    %eax,(%esp)
80107c6d:	e8 30 d2 ff ff       	call   80104ea2 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c75:	89 04 24             	mov    %eax,(%esp)
80107c78:	e8 ca f7 ff ff       	call   80107447 <v2p>
80107c7d:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107c84:	00 
80107c85:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107c89:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c90:	00 
80107c91:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c98:	00 
80107c99:	8b 45 08             	mov    0x8(%ebp),%eax
80107c9c:	89 04 24             	mov    %eax,(%esp)
80107c9f:	e8 b0 fc ff ff       	call   80107954 <mappages>
  memmove(mem, init, sz);
80107ca4:	8b 45 10             	mov    0x10(%ebp),%eax
80107ca7:	89 44 24 08          	mov    %eax,0x8(%esp)
80107cab:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cae:	89 44 24 04          	mov    %eax,0x4(%esp)
80107cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb5:	89 04 24             	mov    %eax,(%esp)
80107cb8:	e8 b1 d2 ff ff       	call   80104f6e <memmove>
}
80107cbd:	c9                   	leave  
80107cbe:	c3                   	ret    

80107cbf <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107cbf:	55                   	push   %ebp
80107cc0:	89 e5                	mov    %esp,%ebp
80107cc2:	53                   	push   %ebx
80107cc3:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cc9:	25 ff 0f 00 00       	and    $0xfff,%eax
80107cce:	85 c0                	test   %eax,%eax
80107cd0:	74 0c                	je     80107cde <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107cd2:	c7 04 24 14 88 10 80 	movl   $0x80108814,(%esp)
80107cd9:	e8 58 88 ff ff       	call   80100536 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107cde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107ce5:	e9 ad 00 00 00       	jmp    80107d97 <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ced:	8b 55 0c             	mov    0xc(%ebp),%edx
80107cf0:	01 d0                	add    %edx,%eax
80107cf2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107cf9:	00 
80107cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80107cfe:	8b 45 08             	mov    0x8(%ebp),%eax
80107d01:	89 04 24             	mov    %eax,(%esp)
80107d04:	e8 a9 fb ff ff       	call   801078b2 <walkpgdir>
80107d09:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107d0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107d10:	75 0c                	jne    80107d1e <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80107d12:	c7 04 24 37 88 10 80 	movl   $0x80108837,(%esp)
80107d19:	e8 18 88 ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
80107d1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d21:	8b 00                	mov    (%eax),%eax
80107d23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d28:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2e:	8b 55 18             	mov    0x18(%ebp),%edx
80107d31:	89 d1                	mov    %edx,%ecx
80107d33:	29 c1                	sub    %eax,%ecx
80107d35:	89 c8                	mov    %ecx,%eax
80107d37:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107d3c:	77 11                	ja     80107d4f <loaduvm+0x90>
      n = sz - i;
80107d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d41:	8b 55 18             	mov    0x18(%ebp),%edx
80107d44:	89 d1                	mov    %edx,%ecx
80107d46:	29 c1                	sub    %eax,%ecx
80107d48:	89 c8                	mov    %ecx,%eax
80107d4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d4d:	eb 07                	jmp    80107d56 <loaduvm+0x97>
    else
      n = PGSIZE;
80107d4f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d59:	8b 55 14             	mov    0x14(%ebp),%edx
80107d5c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107d5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d62:	89 04 24             	mov    %eax,(%esp)
80107d65:	e8 ea f6 ff ff       	call   80107454 <p2v>
80107d6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107d6d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107d71:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107d75:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d79:	8b 45 10             	mov    0x10(%ebp),%eax
80107d7c:	89 04 24             	mov    %eax,(%esp)
80107d7f:	e8 85 a0 ff ff       	call   80101e09 <readi>
80107d84:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107d87:	74 07                	je     80107d90 <loaduvm+0xd1>
      return -1;
80107d89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d8e:	eb 18                	jmp    80107da8 <loaduvm+0xe9>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107d90:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9a:	3b 45 18             	cmp    0x18(%ebp),%eax
80107d9d:	0f 82 47 ff ff ff    	jb     80107cea <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107da8:	83 c4 24             	add    $0x24,%esp
80107dab:	5b                   	pop    %ebx
80107dac:	5d                   	pop    %ebp
80107dad:	c3                   	ret    

80107dae <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107dae:	55                   	push   %ebp
80107daf:	89 e5                	mov    %esp,%ebp
80107db1:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107db4:	8b 45 10             	mov    0x10(%ebp),%eax
80107db7:	85 c0                	test   %eax,%eax
80107db9:	79 0a                	jns    80107dc5 <allocuvm+0x17>
    return 0;
80107dbb:	b8 00 00 00 00       	mov    $0x0,%eax
80107dc0:	e9 c1 00 00 00       	jmp    80107e86 <allocuvm+0xd8>
  if(newsz < oldsz)
80107dc5:	8b 45 10             	mov    0x10(%ebp),%eax
80107dc8:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107dcb:	73 08                	jae    80107dd5 <allocuvm+0x27>
    return oldsz;
80107dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dd0:	e9 b1 00 00 00       	jmp    80107e86 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80107dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dd8:	05 ff 0f 00 00       	add    $0xfff,%eax
80107ddd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107de2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107de5:	e9 8d 00 00 00       	jmp    80107e77 <allocuvm+0xc9>
    mem = kalloc();
80107dea:	e8 90 ad ff ff       	call   80102b7f <kalloc>
80107def:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107df2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107df6:	75 2c                	jne    80107e24 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80107df8:	c7 04 24 55 88 10 80 	movl   $0x80108855,(%esp)
80107dff:	e8 9d 85 ff ff       	call   801003a1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107e04:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e07:	89 44 24 08          	mov    %eax,0x8(%esp)
80107e0b:	8b 45 10             	mov    0x10(%ebp),%eax
80107e0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e12:	8b 45 08             	mov    0x8(%ebp),%eax
80107e15:	89 04 24             	mov    %eax,(%esp)
80107e18:	e8 6b 00 00 00       	call   80107e88 <deallocuvm>
      return 0;
80107e1d:	b8 00 00 00 00       	mov    $0x0,%eax
80107e22:	eb 62                	jmp    80107e86 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80107e24:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e2b:	00 
80107e2c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107e33:	00 
80107e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e37:	89 04 24             	mov    %eax,(%esp)
80107e3a:	e8 63 d0 ff ff       	call   80104ea2 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e42:	89 04 24             	mov    %eax,(%esp)
80107e45:	e8 fd f5 ff ff       	call   80107447 <v2p>
80107e4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107e4d:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107e54:	00 
80107e55:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107e59:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e60:	00 
80107e61:	89 54 24 04          	mov    %edx,0x4(%esp)
80107e65:	8b 45 08             	mov    0x8(%ebp),%eax
80107e68:	89 04 24             	mov    %eax,(%esp)
80107e6b:	e8 e4 fa ff ff       	call   80107954 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107e70:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7a:	3b 45 10             	cmp    0x10(%ebp),%eax
80107e7d:	0f 82 67 ff ff ff    	jb     80107dea <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80107e83:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107e86:	c9                   	leave  
80107e87:	c3                   	ret    

80107e88 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107e88:	55                   	push   %ebp
80107e89:	89 e5                	mov    %esp,%ebp
80107e8b:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107e8e:	8b 45 10             	mov    0x10(%ebp),%eax
80107e91:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e94:	72 08                	jb     80107e9e <deallocuvm+0x16>
    return oldsz;
80107e96:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e99:	e9 a4 00 00 00       	jmp    80107f42 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80107e9e:	8b 45 10             	mov    0x10(%ebp),%eax
80107ea1:	05 ff 0f 00 00       	add    $0xfff,%eax
80107ea6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107eae:	e9 80 00 00 00       	jmp    80107f33 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107ebd:	00 
80107ebe:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ec2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ec5:	89 04 24             	mov    %eax,(%esp)
80107ec8:	e8 e5 f9 ff ff       	call   801078b2 <walkpgdir>
80107ecd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107ed0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107ed4:	75 09                	jne    80107edf <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80107ed6:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80107edd:	eb 4d                	jmp    80107f2c <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80107edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ee2:	8b 00                	mov    (%eax),%eax
80107ee4:	83 e0 01             	and    $0x1,%eax
80107ee7:	85 c0                	test   %eax,%eax
80107ee9:	74 41                	je     80107f2c <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80107eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107eee:	8b 00                	mov    (%eax),%eax
80107ef0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ef5:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107ef8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107efc:	75 0c                	jne    80107f0a <deallocuvm+0x82>
        panic("kfree");
80107efe:	c7 04 24 6d 88 10 80 	movl   $0x8010886d,(%esp)
80107f05:	e8 2c 86 ff ff       	call   80100536 <panic>
      char *v = p2v(pa);
80107f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f0d:	89 04 24             	mov    %eax,(%esp)
80107f10:	e8 3f f5 ff ff       	call   80107454 <p2v>
80107f15:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107f18:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f1b:	89 04 24             	mov    %eax,(%esp)
80107f1e:	e8 c3 ab ff ff       	call   80102ae6 <kfree>
      *pte = 0;
80107f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107f2c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f36:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107f39:	0f 82 74 ff ff ff    	jb     80107eb3 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80107f3f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107f42:	c9                   	leave  
80107f43:	c3                   	ret    

80107f44 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107f44:	55                   	push   %ebp
80107f45:	89 e5                	mov    %esp,%ebp
80107f47:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80107f4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107f4e:	75 0c                	jne    80107f5c <freevm+0x18>
    panic("freevm: no pgdir");
80107f50:	c7 04 24 73 88 10 80 	movl   $0x80108873,(%esp)
80107f57:	e8 da 85 ff ff       	call   80100536 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107f5c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f63:	00 
80107f64:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80107f6b:	80 
80107f6c:	8b 45 08             	mov    0x8(%ebp),%eax
80107f6f:	89 04 24             	mov    %eax,(%esp)
80107f72:	e8 11 ff ff ff       	call   80107e88 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107f77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f7e:	eb 47                	jmp    80107fc7 <freevm+0x83>
    if(pgdir[i] & PTE_P){
80107f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107f8a:	8b 45 08             	mov    0x8(%ebp),%eax
80107f8d:	01 d0                	add    %edx,%eax
80107f8f:	8b 00                	mov    (%eax),%eax
80107f91:	83 e0 01             	and    $0x1,%eax
80107f94:	85 c0                	test   %eax,%eax
80107f96:	74 2c                	je     80107fc4 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80107f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107fa2:	8b 45 08             	mov    0x8(%ebp),%eax
80107fa5:	01 d0                	add    %edx,%eax
80107fa7:	8b 00                	mov    (%eax),%eax
80107fa9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fae:	89 04 24             	mov    %eax,(%esp)
80107fb1:	e8 9e f4 ff ff       	call   80107454 <p2v>
80107fb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fbc:	89 04 24             	mov    %eax,(%esp)
80107fbf:	e8 22 ab ff ff       	call   80102ae6 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107fc4:	ff 45 f4             	incl   -0xc(%ebp)
80107fc7:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107fce:	76 b0                	jbe    80107f80 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107fd0:	8b 45 08             	mov    0x8(%ebp),%eax
80107fd3:	89 04 24             	mov    %eax,(%esp)
80107fd6:	e8 0b ab ff ff       	call   80102ae6 <kfree>
}
80107fdb:	c9                   	leave  
80107fdc:	c3                   	ret    

80107fdd <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107fdd:	55                   	push   %ebp
80107fde:	89 e5                	mov    %esp,%ebp
80107fe0:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107fe3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107fea:	00 
80107feb:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fee:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ff2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ff5:	89 04 24             	mov    %eax,(%esp)
80107ff8:	e8 b5 f8 ff ff       	call   801078b2 <walkpgdir>
80107ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108000:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108004:	75 0c                	jne    80108012 <clearpteu+0x35>
    panic("clearpteu");
80108006:	c7 04 24 84 88 10 80 	movl   $0x80108884,(%esp)
8010800d:	e8 24 85 ff ff       	call   80100536 <panic>
  *pte &= ~PTE_U;
80108012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108015:	8b 00                	mov    (%eax),%eax
80108017:	89 c2                	mov    %eax,%edx
80108019:	83 e2 fb             	and    $0xfffffffb,%edx
8010801c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801f:	89 10                	mov    %edx,(%eax)
}
80108021:	c9                   	leave  
80108022:	c3                   	ret    

80108023 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108023:	55                   	push   %ebp
80108024:	89 e5                	mov    %esp,%ebp
80108026:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
80108029:	e8 ba f9 ff ff       	call   801079e8 <setupkvm>
8010802e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108031:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108035:	75 0a                	jne    80108041 <copyuvm+0x1e>
    return 0;
80108037:	b8 00 00 00 00       	mov    $0x0,%eax
8010803c:	e9 f1 00 00 00       	jmp    80108132 <copyuvm+0x10f>
  for(i = 0; i < sz; i += PGSIZE){
80108041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108048:	e9 c0 00 00 00       	jmp    8010810d <copyuvm+0xea>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010804d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108050:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108057:	00 
80108058:	89 44 24 04          	mov    %eax,0x4(%esp)
8010805c:	8b 45 08             	mov    0x8(%ebp),%eax
8010805f:	89 04 24             	mov    %eax,(%esp)
80108062:	e8 4b f8 ff ff       	call   801078b2 <walkpgdir>
80108067:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010806a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010806e:	75 0c                	jne    8010807c <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80108070:	c7 04 24 8e 88 10 80 	movl   $0x8010888e,(%esp)
80108077:	e8 ba 84 ff ff       	call   80100536 <panic>
    if(!(*pte & PTE_P))
8010807c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010807f:	8b 00                	mov    (%eax),%eax
80108081:	83 e0 01             	and    $0x1,%eax
80108084:	85 c0                	test   %eax,%eax
80108086:	75 0c                	jne    80108094 <copyuvm+0x71>
      panic("copyuvm: page not present");
80108088:	c7 04 24 a8 88 10 80 	movl   $0x801088a8,(%esp)
8010808f:	e8 a2 84 ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
80108094:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108097:	8b 00                	mov    (%eax),%eax
80108099:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010809e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if((mem = kalloc()) == 0)
801080a1:	e8 d9 aa ff ff       	call   80102b7f <kalloc>
801080a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801080a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801080ad:	74 6f                	je     8010811e <copyuvm+0xfb>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801080af:	8b 45 e8             	mov    -0x18(%ebp),%eax
801080b2:	89 04 24             	mov    %eax,(%esp)
801080b5:	e8 9a f3 ff ff       	call   80107454 <p2v>
801080ba:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080c1:	00 
801080c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801080c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080c9:	89 04 24             	mov    %eax,(%esp)
801080cc:	e8 9d ce ff ff       	call   80104f6e <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
801080d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080d4:	89 04 24             	mov    %eax,(%esp)
801080d7:	e8 6b f3 ff ff       	call   80107447 <v2p>
801080dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801080df:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801080e6:	00 
801080e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
801080eb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080f2:	00 
801080f3:	89 54 24 04          	mov    %edx,0x4(%esp)
801080f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080fa:	89 04 24             	mov    %eax,(%esp)
801080fd:	e8 52 f8 ff ff       	call   80107954 <mappages>
80108102:	85 c0                	test   %eax,%eax
80108104:	78 1b                	js     80108121 <copyuvm+0xfe>
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108106:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010810d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108110:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108113:	0f 82 34 ff ff ff    	jb     8010804d <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
  }
  return d;
80108119:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010811c:	eb 14                	jmp    80108132 <copyuvm+0x10f>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
8010811e:	90                   	nop
8010811f:	eb 01                	jmp    80108122 <copyuvm+0xff>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
80108121:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108122:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108125:	89 04 24             	mov    %eax,(%esp)
80108128:	e8 17 fe ff ff       	call   80107f44 <freevm>
  return 0;
8010812d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108132:	c9                   	leave  
80108133:	c3                   	ret    

80108134 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108134:	55                   	push   %ebp
80108135:	89 e5                	mov    %esp,%ebp
80108137:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010813a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108141:	00 
80108142:	8b 45 0c             	mov    0xc(%ebp),%eax
80108145:	89 44 24 04          	mov    %eax,0x4(%esp)
80108149:	8b 45 08             	mov    0x8(%ebp),%eax
8010814c:	89 04 24             	mov    %eax,(%esp)
8010814f:	e8 5e f7 ff ff       	call   801078b2 <walkpgdir>
80108154:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108157:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010815a:	8b 00                	mov    (%eax),%eax
8010815c:	83 e0 01             	and    $0x1,%eax
8010815f:	85 c0                	test   %eax,%eax
80108161:	75 07                	jne    8010816a <uva2ka+0x36>
    return 0;
80108163:	b8 00 00 00 00       	mov    $0x0,%eax
80108168:	eb 25                	jmp    8010818f <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
8010816a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816d:	8b 00                	mov    (%eax),%eax
8010816f:	83 e0 04             	and    $0x4,%eax
80108172:	85 c0                	test   %eax,%eax
80108174:	75 07                	jne    8010817d <uva2ka+0x49>
    return 0;
80108176:	b8 00 00 00 00       	mov    $0x0,%eax
8010817b:	eb 12                	jmp    8010818f <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
8010817d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108180:	8b 00                	mov    (%eax),%eax
80108182:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108187:	89 04 24             	mov    %eax,(%esp)
8010818a:	e8 c5 f2 ff ff       	call   80107454 <p2v>
}
8010818f:	c9                   	leave  
80108190:	c3                   	ret    

80108191 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108191:	55                   	push   %ebp
80108192:	89 e5                	mov    %esp,%ebp
80108194:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108197:	8b 45 10             	mov    0x10(%ebp),%eax
8010819a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010819d:	e9 89 00 00 00       	jmp    8010822b <copyout+0x9a>
    va0 = (uint)PGROUNDDOWN(va);
801081a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801081a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801081ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801081b4:	8b 45 08             	mov    0x8(%ebp),%eax
801081b7:	89 04 24             	mov    %eax,(%esp)
801081ba:	e8 75 ff ff ff       	call   80108134 <uva2ka>
801081bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801081c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801081c6:	75 07                	jne    801081cf <copyout+0x3e>
      return -1;
801081c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801081cd:	eb 6b                	jmp    8010823a <copyout+0xa9>
    n = PGSIZE - (va - va0);
801081cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801081d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801081d5:	89 d1                	mov    %edx,%ecx
801081d7:	29 c1                	sub    %eax,%ecx
801081d9:	89 c8                	mov    %ecx,%eax
801081db:	05 00 10 00 00       	add    $0x1000,%eax
801081e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801081e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081e6:	3b 45 14             	cmp    0x14(%ebp),%eax
801081e9:	76 06                	jbe    801081f1 <copyout+0x60>
      n = len;
801081eb:	8b 45 14             	mov    0x14(%ebp),%eax
801081ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801081f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081f4:	8b 55 0c             	mov    0xc(%ebp),%edx
801081f7:	29 c2                	sub    %eax,%edx
801081f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801081fc:	01 c2                	add    %eax,%edx
801081fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108201:	89 44 24 08          	mov    %eax,0x8(%esp)
80108205:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108208:	89 44 24 04          	mov    %eax,0x4(%esp)
8010820c:	89 14 24             	mov    %edx,(%esp)
8010820f:	e8 5a cd ff ff       	call   80104f6e <memmove>
    len -= n;
80108214:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108217:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010821a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010821d:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108220:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108223:	05 00 10 00 00       	add    $0x1000,%eax
80108228:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010822b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010822f:	0f 85 6d ff ff ff    	jne    801081a2 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108235:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010823a:	c9                   	leave  
8010823b:	c3                   	ret    
