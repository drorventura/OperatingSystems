
bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
# with %cs=0 %ip=7c00.

.code16                       # Assemble for 16-bit mode
.globl start
start:
  cli                         # BIOS enabled interrupts; disable
    7c00:	fa                   	cli    

  # Zero data segment registers DS, ES, and SS.
  xorw    %ax,%ax             # Set %ax to zero
    7c01:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c03:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c05:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c07:	8e d0                	mov    %eax,%ss

00007c09 <seta20.1>:

  # Physical address line A20 is tied to zero so that the first PCs 
  # with 2 MB would run software that assumed 1 MB.  Undo that.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c09:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c0b:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c0d:	75 fa                	jne    7c09 <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c0f:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c11:	e6 64                	out    %al,$0x64

00007c13 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c13:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c15:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c17:	75 fa                	jne    7c13 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c19:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c1b:	e6 60                	out    %al,$0x60

  # Switch from real to protected mode.  Use a bootstrap GDT that makes
  # virtual addresses map directly to physical addresses so that the
  # effective memory map doesn't change during the transition.
  lgdt    gdtdesc
    7c1d:	0f 01 16             	lgdtl  (%esi)
    7c20:	78 7c                	js     7c9e <readsect+0xc>
  movl    %cr0, %eax
    7c22:	0f 20 c0             	mov    %cr0,%eax
  orl     $CR0_PE, %eax
    7c25:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c29:	0f 22 c0             	mov    %eax,%cr0

//PAGEBREAK!
  # Complete transition to 32-bit protected mode by using long jmp
  # to reload %cs and %eip.  The segment descriptors are set up with no
  # translation, so that the mapping is still the identity mapping.
  ljmp    $(SEG_KCODE<<3), $start32
    7c2c:	ea 31 7c 08 00 66 b8 	ljmp   $0xb866,$0x87c31

00007c31 <start32>:

.code32  # Tell assembler to generate 32-bit code now.
start32:
  # Set up the protected-mode data segment registers
  movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
    7c31:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c35:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c37:	8e c0                	mov    %eax,%es
  movw    %ax, %ss                # -> SS: Stack Segment
    7c39:	8e d0                	mov    %eax,%ss
  movw    $0, %ax                 # Zero segments not ready for use
    7c3b:	66 b8 00 00          	mov    $0x0,%ax
  movw    %ax, %fs                # -> FS
    7c3f:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c41:	8e e8                	mov    %eax,%gs

  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c43:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  call    bootmain
    7c48:	e8 df 00 00 00       	call   7d2c <bootmain>

  # If bootmain returns (it shouldn't), trigger a Bochs
  # breakpoint if running under Bochs, then loop.
  movw    $0x8a00, %ax            # 0x8a00 -> port 0x8a00
    7c4d:	66 b8 00 8a          	mov    $0x8a00,%ax
  movw    %ax, %dx
    7c51:	66 89 c2             	mov    %ax,%dx
  outw    %ax, %dx
    7c54:	66 ef                	out    %ax,(%dx)
  movw    $0x8ae0, %ax            # 0x8ae0 -> port 0x8a00
    7c56:	66 b8 e0 8a          	mov    $0x8ae0,%ax
  outw    %ax, %dx
    7c5a:	66 ef                	out    %ax,(%dx)

00007c5c <spin>:
spin:
  jmp     spin
    7c5c:	eb fe                	jmp    7c5c <spin>
    7c5e:	66 90                	xchg   %ax,%ax

00007c60 <gdt>:
	...
    7c68:	ff                   	(bad)  
    7c69:	ff 00                	incl   (%eax)
    7c6b:	00 00                	add    %al,(%eax)
    7c6d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c74:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

00007c78 <gdtdesc>:
    7c78:	17                   	pop    %ss
    7c79:	00 60 7c             	add    %ah,0x7c(%eax)
    7c7c:	00 00                	add    %al,(%eax)
    7c7e:	66 90                	xchg   %ax,%ax

00007c80 <waitdisk>:
  entry();
}

void
waitdisk(void)
{
    7c80:	55                   	push   %ebp
    7c81:	89 e5                	mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
    7c83:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c88:	ec                   	in     (%dx),%al
  // Wait for disk ready.
  while((inb(0x1F7) & 0xC0) != 0x40)
    7c89:	83 e0 c0             	and    $0xffffffc0,%eax
    7c8c:	3c 40                	cmp    $0x40,%al
    7c8e:	75 f8                	jne    7c88 <waitdisk+0x8>
    ;
}
    7c90:	5d                   	pop    %ebp
    7c91:	c3                   	ret    

00007c92 <readsect>:

// Read a single sector at offset into dst.
void
readsect(void *dst, uint offset)
{
    7c92:	55                   	push   %ebp
    7c93:	89 e5                	mov    %esp,%ebp
    7c95:	57                   	push   %edi
    7c96:	53                   	push   %ebx
    7c97:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  // Issue command.
  waitdisk();
    7c9a:	e8 e1 ff ff ff       	call   7c80 <waitdisk>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
    7c9f:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7ca4:	b0 01                	mov    $0x1,%al
    7ca6:	ee                   	out    %al,(%dx)
  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    readsect(pa, offset);
}
    7ca7:	0f b6 c3             	movzbl %bl,%eax
    7caa:	b2 f3                	mov    $0xf3,%dl
    7cac:	ee                   	out    %al,(%dx)
    7cad:	0f b6 c7             	movzbl %bh,%eax
    7cb0:	b2 f4                	mov    $0xf4,%dl
    7cb2:	ee                   	out    %al,(%dx)
  // Issue command.
  waitdisk();
  outb(0x1F2, 1);   // count = 1
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
  outb(0x1F5, offset >> 16);
    7cb3:	89 d8                	mov    %ebx,%eax
    7cb5:	c1 e8 10             	shr    $0x10,%eax
  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    readsect(pa, offset);
}
    7cb8:	25 ff 00 00 00       	and    $0xff,%eax
    7cbd:	b2 f5                	mov    $0xf5,%dl
    7cbf:	ee                   	out    %al,(%dx)
    7cc0:	c1 eb 18             	shr    $0x18,%ebx
    7cc3:	89 d8                	mov    %ebx,%eax
    7cc5:	0c e0                	or     $0xe0,%al
    7cc7:	b2 f6                	mov    $0xf6,%dl
    7cc9:	ee                   	out    %al,(%dx)
    7cca:	b2 f7                	mov    $0xf7,%dl
    7ccc:	b0 20                	mov    $0x20,%al
    7cce:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
  outb(0x1F6, (offset >> 24) | 0xE0);
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
    7ccf:	e8 ac ff ff ff       	call   7c80 <waitdisk>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
    7cd4:	8b 7d 08             	mov    0x8(%ebp),%edi
    7cd7:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cdc:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7ce1:	fc                   	cld    
    7ce2:	f3 6d                	rep insl (%dx),%es:(%edi)
  insl(0x1F0, dst, SECTSIZE/4);
}
    7ce4:	5b                   	pop    %ebx
    7ce5:	5f                   	pop    %edi
    7ce6:	5d                   	pop    %ebp
    7ce7:	c3                   	ret    

00007ce8 <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.
void
readseg(uchar* pa, uint count, uint offset)
{
    7ce8:	55                   	push   %ebp
    7ce9:	89 e5                	mov    %esp,%ebp
    7ceb:	57                   	push   %edi
    7cec:	56                   	push   %esi
    7ced:	53                   	push   %ebx
    7cee:	83 ec 08             	sub    $0x8,%esp
    7cf1:	8b 5d 08             	mov    0x8(%ebp),%ebx
    7cf4:	8b 75 10             	mov    0x10(%ebp),%esi
  uchar* epa;

  epa = pa + count;
    7cf7:	89 df                	mov    %ebx,%edi
    7cf9:	03 7d 0c             	add    0xc(%ebp),%edi

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
    7cfc:	89 f0                	mov    %esi,%eax
    7cfe:	25 ff 01 00 00       	and    $0x1ff,%eax
    7d03:	29 c3                	sub    %eax,%ebx

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
    7d05:	c1 ee 09             	shr    $0x9,%esi
    7d08:	46                   	inc    %esi

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d09:	39 df                	cmp    %ebx,%edi
    7d0b:	76 17                	jbe    7d24 <readseg+0x3c>
    readsect(pa, offset);
    7d0d:	89 74 24 04          	mov    %esi,0x4(%esp)
    7d11:	89 1c 24             	mov    %ebx,(%esp)
    7d14:	e8 79 ff ff ff       	call   7c92 <readsect>
  offset = (offset / SECTSIZE) + 1;

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d19:	81 c3 00 02 00 00    	add    $0x200,%ebx
    7d1f:	46                   	inc    %esi
    7d20:	39 df                	cmp    %ebx,%edi
    7d22:	77 e9                	ja     7d0d <readseg+0x25>
    readsect(pa, offset);
}
    7d24:	83 c4 08             	add    $0x8,%esp
    7d27:	5b                   	pop    %ebx
    7d28:	5e                   	pop    %esi
    7d29:	5f                   	pop    %edi
    7d2a:	5d                   	pop    %ebp
    7d2b:	c3                   	ret    

00007d2c <bootmain>:

void readseg(uchar*, uint, uint);

void
bootmain(void)
{
    7d2c:	55                   	push   %ebp
    7d2d:	89 e5                	mov    %esp,%ebp
    7d2f:	57                   	push   %edi
    7d30:	56                   	push   %esi
    7d31:	53                   	push   %ebx
    7d32:	83 ec 1c             	sub    $0x1c,%esp
  uchar* pa;

  elf = (struct elfhdr*)0x10000;  // scratch space

  // Read 1st page off disk
  readseg((uchar*)elf, 4096, 0);
    7d35:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    7d3c:	00 
    7d3d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    7d44:	00 
    7d45:	c7 04 24 00 00 01 00 	movl   $0x10000,(%esp)
    7d4c:	e8 97 ff ff ff       	call   7ce8 <readseg>

  // Is this an ELF executable?
  if(elf->magic != ELF_MAGIC)
    7d51:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d58:	45 4c 46 
    7d5b:	75 58                	jne    7db5 <bootmain+0x89>
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
    7d5d:	8b 1d 1c 00 01 00    	mov    0x1001c,%ebx
    7d63:	81 c3 00 00 01 00    	add    $0x10000,%ebx
  eph = ph + elf->phnum;
    7d69:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
    7d70:	c1 e6 05             	shl    $0x5,%esi
    7d73:	01 de                	add    %ebx,%esi
  for(; ph < eph; ph++){
    7d75:	39 f3                	cmp    %esi,%ebx
    7d77:	73 36                	jae    7daf <bootmain+0x83>
    pa = (uchar*)ph->paddr;
    7d79:	8b 7b 0c             	mov    0xc(%ebx),%edi
    readseg(pa, ph->filesz, ph->off);
    7d7c:	8b 43 04             	mov    0x4(%ebx),%eax
    7d7f:	89 44 24 08          	mov    %eax,0x8(%esp)
    7d83:	8b 43 10             	mov    0x10(%ebx),%eax
    7d86:	89 44 24 04          	mov    %eax,0x4(%esp)
    7d8a:	89 3c 24             	mov    %edi,(%esp)
    7d8d:	e8 56 ff ff ff       	call   7ce8 <readseg>
    if(ph->memsz > ph->filesz)
    7d92:	8b 4b 14             	mov    0x14(%ebx),%ecx
    7d95:	8b 43 10             	mov    0x10(%ebx),%eax
    7d98:	39 c1                	cmp    %eax,%ecx
    7d9a:	76 0c                	jbe    7da8 <bootmain+0x7c>
      stosb(pa + ph->filesz, 0, ph->memsz - ph->filesz);
    7d9c:	01 c7                	add    %eax,%edi
    7d9e:	29 c1                	sub    %eax,%ecx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    7da0:	b8 00 00 00 00       	mov    $0x0,%eax
    7da5:	fc                   	cld    
    7da6:	f3 aa                	rep stos %al,%es:(%edi)
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
  eph = ph + elf->phnum;
  for(; ph < eph; ph++){
    7da8:	83 c3 20             	add    $0x20,%ebx
    7dab:	39 de                	cmp    %ebx,%esi
    7dad:	77 ca                	ja     7d79 <bootmain+0x4d>
  }

  // Call the entry point from the ELF header.
  // Does not return!
  entry = (void(*)(void))(elf->entry);
  entry();
    7daf:	ff 15 18 00 01 00    	call   *0x10018
}
    7db5:	83 c4 1c             	add    $0x1c,%esp
    7db8:	5b                   	pop    %ebx
    7db9:	5e                   	pop    %esi
    7dba:	5f                   	pop    %edi
    7dbb:	5d                   	pop    %ebp
    7dbc:	c3                   	ret    
