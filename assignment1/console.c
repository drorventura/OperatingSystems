// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

#define MAX_HISTORY_LENGTH 20
#define INPUT_BUF 128

char historyBuf[MAX_HISTORY_LENGTH][INPUT_BUF];
int history_index = 0;
int history_index_pos = 0;
int historyFlag = 0;
int historyCounter = 0;
int bufIndex = 0;

static void consputc(int);

static int panicked = 0;
void fixPrintWhenLeftKeyIsPressed();
void killLine(void);
void loadHistoryToScreen(int c);

static struct {
  struct spinlock lock;
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i]);
}
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
{
  int i;
  uint pcs[10];
  
  cli();
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

//PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT   0x3d4
#define KEY_LF    0xE4
#define KEY_RT    0xE5
#define KEY_UP    0xE2
#define KEY_DN    0xE3
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
  }
  else if(c == KEY_LF)
  {
    if(pos > 0) --pos;
  }
  else if(c == KEY_RT){
    ++pos;
  }
  else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }
  
  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  if(c != KEY_LF && c != KEY_RT)
    crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
  if(panicked){
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  }
  else if(c == KEY_LF || c == KEY_RT)
  {

  }
  else
    uartputc(c);
  cgaputc(c);
}

#define INPUT_BUF 128
struct {
  struct spinlock lock;
  char buf[INPUT_BUF];
  uint r;  // Read index
  uint w;  // Write index
  uint e;  // Edit index
} input;

#define C(x)  ((x)-'@')  // Control-x

static int leftClicksCounter = 0;

void
consoleintr(int (*getc)(void))
{
  int c;
  int i = 0;
  

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w)
      {
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case KEY_LF:               // left arrow
      if(input.e != input.w)
      {
        consputc(KEY_LF);
        leftClicksCounter++;
        input.e--;
      }
      break;
    case KEY_RT:               // right arrow
      if(leftClicksCounter > 0)
      {
        consputc(KEY_RT);
        leftClicksCounter--;
        input.e++;
      }
      break;
    case (KEY_UP) :
      if (historyCounter == 0)
          break;
      if (!historyFlag) {
          killLine();
          loadHistoryToScreen(c);  
          historyFlag= 1;
          break;
      }
      else if (history_index_pos != 0)
      {
          history_index_pos--;
          history_index_pos = history_index_pos % MAX_HISTORY_LENGTH;

      }
      else  if (history_index_pos == 0 && 
                 historyCounter == MAX_HISTORY_LENGTH)
      {
          history_index_pos = MAX_HISTORY_LENGTH -1;

      } else if (history_index_pos == 0 && 
                 historyCounter != MAX_HISTORY_LENGTH)
      {
          history_index_pos = history_index -1;
      }
          killLine();
          loadHistoryToScreen(c);  
      break;
    
    case (KEY_DN) :
      if (historyFlag && history_index_pos != history_index - 1)
      {
          history_index_pos++;
          history_index_pos = history_index_pos % MAX_HISTORY_LENGTH;
          killLine();
          loadHistoryToScreen(c);  
      }
      break;
    
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;

        if(c == '\n') //fix the input.e index when enter is pressed and resets leftCount
        {
            input.e = (input.e + leftClicksCounter) % INPUT_BUF;
            leftClicksCounter = 0;
        }

        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        fixPrintWhenLeftKeyIsPressed();

        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
            i = input.r;
            bufIndex = 0;
            while(i != input.e)
            {
                historyBuf[history_index % MAX_HISTORY_LENGTH][bufIndex] = input.buf[i % INPUT_BUF];
                i++;
                bufIndex++;
            }
          input.w = input.e;
          wakeup(&input.r);

          // check if user enter just NEWLINE - we dont want save in history
          if (bufIndex == 1)
          {
              if (historyBuf[history_index % MAX_HISTORY_LENGTH][0] == '\n')
                  break;
          }

          if (historyCounter != MAX_HISTORY_LENGTH)
              historyCounter++;

          history_index_pos = history_index % MAX_HISTORY_LENGTH;
          history_index++;
          history_index = history_index % MAX_HISTORY_LENGTH;
          historyFlag = 0;
        }
      }
      break;
    }
  }
  release(&input.lock);
}

//fix print after leftKey is pressed
void fixPrintWhenLeftKeyIsPressed()
{
    int i;
    for(i = leftClicksCounter ; i > 0 ; i--)
    {
        consputc(input.buf[input.e++ % INPUT_BUF]);
    }
    for(i = leftClicksCounter ; i > 0 ; i--)
    {
        consputc(KEY_LF);
    }
    input.e = (input.e - leftClicksCounter) % INPUT_BUF;
}

//kill line
void killLine(void)
{

    while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
    }
}

void loadHistoryToScreen(int c)
{
    int i = 0;
    while( historyBuf[history_index_pos][i] != '\n')
    {

        c = historyBuf[history_index_pos][i];
        if(c != 0 && input.e-input.r < INPUT_BUF){
            c = (c == '\r') ? '\n' : c;
            input.buf[input.e++ % INPUT_BUF] = c;
            consputc(c);
            if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
                input.w = input.e;
                wakeup(&input.r);
            }
        }
        i++;
    }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
  ilock(ip);

  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void
consoleinit(void)
{
  initlock(&cons.lock, "console");
  initlock(&input.lock, "input");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
  ioapicenable(IRQ_KBD, 0);
}

