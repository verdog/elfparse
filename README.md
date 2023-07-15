# elfparse

A very basic program to parse ELF executable files that I made as a learning exercise.

## Build

```
zig build
```

## Run

```
./zig-out/bin/elfparse <binary>
```

## Examples vs. readelf

### elfparse

```
[josh@lowhp elfparse]$ ./zig-out/bin/elfparse ./zig-out/bin/elfparse
Entry point: 0x209020
Section header list:
                        : 0x0
                 .rodata: 0x200200
                   .text: 0x209020
                   .tbss: 0x24b458
                    .got: 0x24c458
                   .data: 0x24d460
                    .bss: 0x24f000
              .debug_loc: 0x0
           .debug_abbrev: 0x0
             .debug_info: 0x0
           .debug_ranges: 0x0
              .debug_str: 0x0
         .debug_pubnames: 0x0
         .debug_pubtypes: 0x0
            .debug_frame: 0x0
             .debug_line: 0x0
                .comment: 0x0
                 .symtab: 0x0
               .shstrtab: 0x0
                 .strtab: 0x0
Program header list:
                    phdr: 0x200040
            text segment: 0x200000
            data segment: 0x209020
            data segment: 0x24c458
            data segment: 0x24d460
                  PT_TLS: (not parsed)
            PT_GNU_RELRO: (not parsed)
            PT_GNU_STACK: (not parsed)
```

```
[josh@lowhp elfparse]$ readelf -Sl ./zig-out/bin/elfparse 
There are 20 section headers, starting at offset 0xc07d8:

Section Headers:
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  [ 0]                   NULL             0000000000000000  00000000
       0000000000000000  0000000000000000           0     0     0
  [ 1] .rodata           PROGBITS         0000000000200200  00000200
       0000000000007e1c  0000000000000000 AMS       0     0     32
  [ 2] .text             PROGBITS         0000000000209020  00008020
       0000000000042432  0000000000000000  AX       0     0     16
  [ 3] .tbss             NOBITS           000000000024b458  0004a458
       0000000000000010  0000000000000000 WAT       0     0     8
  [ 4] .got              PROGBITS         000000000024c458  0004a458
       0000000000000008  0000000000000000  WA       0     0     8
  [ 5] .data             PROGBITS         000000000024d460  0004a460
       00000000000012b8  0000000000000000  WA       0     0     8
  [ 6] .bss              NOBITS           000000000024f000  0004b718
       0000000000003190  0000000000000000  WA       0     0     4096
  [ 7] .debug_loc        PROGBITS         0000000000000000  0004b718
       0000000000008365  0000000000000000           0     0     1
  [ 8] .debug_abbrev     PROGBITS         0000000000000000  00053a7d
       00000000000002a9  0000000000000000           0     0     1
  [ 9] .debug_info       PROGBITS         0000000000000000  00053d26
       0000000000019110  0000000000000000           0     0     1
  [10] .debug_ranges     PROGBITS         0000000000000000  0006ce36
       0000000000001020  0000000000000000           0     0     1
  [11] .debug_str        PROGBITS         0000000000000000  0006de56
       0000000000018325  0000000000000001  MS       0     0     1
  [12] .debug_pubnames   PROGBITS         0000000000000000  0008617b
       0000000000007f20  0000000000000000           0     0     1
  [13] .debug_pubtypes   PROGBITS         0000000000000000  0008e09b
       000000000000327e  0000000000000000           0     0     1
  [14] .debug_frame      PROGBITS         0000000000000000  00091320
       0000000000008e38  0000000000000000           0     0     8
  [15] .debug_line       PROGBITS         0000000000000000  0009a158
       0000000000013a85  0000000000000000           0     0     1
  [16] .comment          PROGBITS         0000000000000000  000adbdd
       0000000000000013  0000000000000001  MS       0     0     1
  [17] .symtab           SYMTAB           0000000000000000  000adbf0
       0000000000005f58  0000000000000018          19   1012     8
  [18] .shstrtab         STRTAB           0000000000000000  000b3b48
       00000000000000bf  0000000000000000           0     0     1
  [19] .strtab           STRTAB           0000000000000000  000b3c07
       000000000000cbcd  0000000000000000           0     0     1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), l (large), p (processor specific)

Elf file type is EXEC (Executable file)
Entry point 0x209020
There are 8 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  PHDR           0x0000000000000040 0x0000000000200040 0x0000000000200040
                 0x00000000000001c0 0x00000000000001c0  R      0x8
  LOAD           0x0000000000000000 0x0000000000200000 0x0000000000200000
                 0x000000000000801c 0x000000000000801c  R      0x1000
  LOAD           0x0000000000008020 0x0000000000209020 0x0000000000209020
                 0x0000000000042432 0x0000000000042432  R E    0x1000
  LOAD           0x000000000004a458 0x000000000024c458 0x000000000024c458
                 0x0000000000000008 0x0000000000000008  RW     0x1000
  LOAD           0x000000000004a460 0x000000000024d460 0x000000000024d460
                 0x00000000000012b8 0x0000000000004d30  RW     0x1000
  TLS            0x000000000004a458 0x000000000024b458 0x000000000024b458
                 0x0000000000000000 0x0000000000000010  R      0x8
  GNU_RELRO      0x000000000004a458 0x000000000024c458 0x000000000024c458
                 0x0000000000000008 0x0000000000000ba8  R      0x1
  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000001000000  RW     0x0

 Section to Segment mapping:
  Segment Sections...
   00     
   01     .rodata 
   02     .text 
   03     .got 
   04     .data .bss 
   05     .tbss 
   06     .got 
   07     .bss 
```

## zig

```
[josh@lowhp elfparse]$ ./zig-out/bin/elfparse ~/.local/bin/zig 
Entry point: 0x33c6fc0
Section header list:
                        : 0x0
                 .rodata: 0x200240
       .gcc_except_table: 0x29c3280
           .eh_frame_hdr: 0x29c4bb0
               .eh_frame: 0x2b0b570
                   .text: 0x33c6fc0
                   .init: 0x85aad6e
                   .fini: 0x85aad71
                  .tdata: 0x85abd78
                   .tbss: 0x85abd80
            .data.rel.ro: 0x85abd80
             .init_array: 0x8f12390
                    .got: 0x8f135b8
                   .data: 0x8f14760
                    .bss: 0x8f5d9b0
                .comment: 0x0
               .shstrtab: 0x0
Program header list:
                    phdr: 0x200040
            text segment: 0x200000
            data segment: 0x33c6fc0
            data segment: 0x85abd78
            data segment: 0x8f14760
                  PT_TLS: (not parsed)
            PT_GNU_RELRO: (not parsed)
         PT_GNU_EH_FRAME: (not parsed)
            PT_GNU_STACK: (not parsed)
```

```
[josh@lowhp elfparse]$ readelf -Sl ~/.local/bin/zig 
There are 17 section headers, starting at offset 0x8d5aac0:

Section Headers:
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  [ 0]                   NULL             0000000000000000  00000000
       0000000000000000  0000000000000000           0     0     0
  [ 1] .rodata           PROGBITS         0000000000200240  00000240
       00000000027c3040  0000000000000000 AMS       0     0     64
  [ 2] .gcc_except_table PROGBITS         00000000029c3280  027c3280
       0000000000001930  0000000000000000   A       0     0     4
  [ 3] .eh_frame_hdr     PROGBITS         00000000029c4bb0  027c4bb0
       00000000001469bc  0000000000000000   A       0     0     4
  [ 4] .eh_frame         PROGBITS         0000000002b0b570  0290b570
       00000000008baa44  0000000000000000   A       0     0     8
  [ 5] .text             PROGBITS         00000000033c6fc0  031c5fc0
       00000000051e3dae  0000000000000000  AX       0     0     64
  [ 6] .init             PROGBITS         00000000085aad6e  083a9d6e
       0000000000000003  0000000000000000  AX       0     0     1
  [ 7] .fini             PROGBITS         00000000085aad71  083a9d71
       0000000000000003  0000000000000000  AX       0     0     1
  [ 8] .tdata            PROGBITS         00000000085abd78  083a9d78
       0000000000000008  0000000000000000 WAT       0     0     8
  [ 9] .tbss             NOBITS           00000000085abd80  083a9d80
       0000000000000208  0000000000000000 WAT       0     0     8
  [10] .data.rel.ro      PROGBITS         00000000085abd80  083a9d80
       0000000000966610  0000000000000000  WA       0     0     16
  [11] .init_array       INIT_ARRAY       0000000008f12390  08d10390
       0000000000001228  0000000000000000  WA       0     0     8
  [12] .got              PROGBITS         0000000008f135b8  08d115b8
       00000000000001a8  0000000000000000  WA       0     0     8
  [13] .data             PROGBITS         0000000008f14760  08d11760
       0000000000049250  0000000000000000  WA       0     0     16
  [14] .bss              NOBITS           0000000008f5d9b0  08d5a9b0
       0000000000087cf0  0000000000000000 WAo       0     0     16
  [15] .comment          PROGBITS         0000000000000000  08d5a9b0
       000000000000007c  0000000000000001  MS       0     0     1
  [16] .shstrtab         STRTAB           0000000000000000  08d5aa2c
       000000000000008e  0000000000000000           0     0     1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), l (large), p (processor specific)

Elf file type is EXEC (Executable file)
Entry point 0x33c6fc0
There are 9 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  PHDR           0x0000000000000040 0x0000000000200040 0x0000000000200040
                 0x00000000000001f8 0x00000000000001f8  R      0x8
  LOAD           0x0000000000000000 0x0000000000200000 0x0000000000200000
                 0x00000000031c5fb4 0x00000000031c5fb4  R      0x1000
  LOAD           0x00000000031c5fc0 0x00000000033c6fc0 0x00000000033c6fc0
                 0x00000000051e3db4 0x00000000051e3db4  R E    0x1000
  LOAD           0x00000000083a9d78 0x00000000085abd78 0x00000000085abd78
                 0x00000000009679e8 0x00000000009679e8  RW     0x1000
  LOAD           0x0000000008d11760 0x0000000008f14760 0x0000000008f14760
                 0x0000000000049250 0x00000000000d0f40  RW     0x1000
  TLS            0x00000000083a9d78 0x00000000085abd78 0x00000000085abd78
                 0x0000000000000008 0x0000000000000210  R      0x8
  GNU_RELRO      0x00000000083a9d78 0x00000000085abd78 0x00000000085abd78
                 0x00000000009679e8 0x0000000000968288  R      0x1
  GNU_EH_FRAME   0x00000000027c4bb0 0x00000000029c4bb0 0x00000000029c4bb0
                 0x00000000001469bc 0x00000000001469bc  R      0x4
  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000002000000  RW     0x0

 Section to Segment mapping:
  Segment Sections...
   00     
   01     .rodata .gcc_except_table .eh_frame_hdr .eh_frame 
   02     .text .init .fini 
   03     .tdata .data.rel.ro .init_array .got 
   04     .data .bss 
   05     .tdata .tbss 
   06     .tdata .data.rel.ro .init_array .got 
   07     .eh_frame_hdr 
   08     
```
