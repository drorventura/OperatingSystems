//On-disk file system format.
//Both the kernel and user programs use this header file.

//Block 0 is unused.
//Block 1 is super block.
//Blocks 2 through sb.ninodes/IPB hold inodes.
//Then free bitmap blocks holding sb.size bits.
//Then sb.nblocks data blocks.
//Then sb.nlog log blocks.

#define ROOTINO 1  // root i-number
#define BSIZE 512  // block size
#define PASS_LEN 10 //part 2 - password length

// File system super block
struct superblock {
  uint size;         // Size of file system image (blocks)
  uint nblocks;      // Number of data blocks
  uint ninodes;      // Number of inodes.
  uint nlog;         // Number of log blocks
};

#define NDIRECT 12
#define NINDIRECT (BSIZE / sizeof(uint))
#define DOUBLY_INDIRECT (NINDIRECT * NINDIRECT) //part 1
#define MAXFILE (NDIRECT + NINDIRECT + DOUBLY_INDIRECT)

// On-disk inode structure
struct dinode {
  short type;           // File type
  short major;          // Major device number (T_DEV only)
  short minor;          // Minor device number (T_DEV only)
  short nlink;          // Number of links to inode in file system
  uint size;            // Size of file (bytes)
  uint passwordSet;        // part 2 -> determines if a password has been set
  char password[PASS_LEN]; // part 2 -> size of password 10 bytes
  uint addrs[NDIRECT+2];   // Data block addresses -> now addrs size is 56bytes
  char padding[42];     // part 1 -> makes total 68+60=128 bytes
};

// Inodes per block.
#define IPB           (BSIZE / sizeof(struct dinode))

// Block containing inode i
#define IBLOCK(i)     ((i) / IPB + 2)

// Bitmap bits per block
#define BPB           (BSIZE*8)

// Block containing bit for block b
#define BBLOCK(b, ninodes) (b/BPB + (ninodes)/IPB + 3)

// Directory is a file containing a sequence of dirent structures.
#define DIRSIZ 14

struct dirent {
  ushort inum;
  char name[DIRSIZ];
};

