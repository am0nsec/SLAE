# Intel x86 Assembly  Basics - by Amonsec

<div id='table_of_content'></div>

### **Table** **of** **Contents**

 * 0x00 [Introduction](#introduction)
 * 0x01 [Assembly what da f*ck](#assembly_what_da_fuck)
 * 0x02 [Compiler, Linker & Loader](#compiler_linker_loader)
   *  [Compiler](#compiler)
   *  [Linker](#linker)
   *  [Loader](#loader)
 * 0x03 [Basic computer architecture (motherboard)](#basic_computer_architecture)
 * 0x04 [Central Processing Unit (CPU)](#central_processing_unit)
 * 0x05 [Registers](#registers)
   * [Data registers](#data_registers) 
   * [Pointer registers](#pointer_registers)
   * [Index registers](#index_registers)
   * [Instruction register](#instruction_register)
   * [Segments registers](#segments_registers)
   * [FLAGS register](#flags_register)
   * [EFLAGS register](#eflags_register)
 * 0x06 [The Stack](#stack)
 * 0x07 [Floating Point Unit](#floating_point_unit)
 * 0x08 [Credits & References](#credits_and_references)


----------

<div id='introduction'></div>

## **0x00** **Introduction**

Welcome to the Intel x86 Assembly world!</br>
Here you are going to find all the basics in order to understand what is going on in low level layers. This is a very basic introduction, but I'm sure it's worth it.</br>

The main purpose of this document is to share my knowledge to people around the world and to have a concentration of basic things in order to limit as much as possible the surfing time in the web to find information. Moreover, this is a good exercise for me to write what I found and what I learn in this subject.</br>

Note , for the moment it's a project and I'm not an assembly guru. It will surely have several updates, to  add content or correct errors.</br>

Feel free to send me a message on Twitter or a pull request if you found an issue or if you want to add some content. Your point of view and your knowledge are really appreciated.</br>

This documentation is under GNU General Public License v3.0, so you can reuse, share update this document as much as you want. But, in order to respect my work, It would be great to let my name as the document writer.

</br>
</br>

<div id='assembly_what_da_fuck'></div>

## **0x01** **Assembly?!** **what** **da** **f$ck**

An assembly (or assembler) language, often abbreviated *asm*, is a low-level programming language for a computer, or other programmable device, in which there is a very strong (generally one-to-one) correspondence between the language and the architecture's machine code instructions. Each assembly language is specific to a particular computer architecture. In contrast, most high-level programming languages are generally portable across multiple architectures but require interpreting or compiling. Assembly language may also be called symbolic machine code.</br>

Assembly language is converted into executable machine code by a utility program referred to as an assembler. The conversion process is referred to as assembly, or assembling the source code. Assembly time is the computational step where an assembler is run.</br>

Assembly language uses a mnemonic to represent each low-level machine instruction or opcode, typically also each architectural register, flag, etc. Many operations require one or more operands in order to form a complete instruction and most assemblers can take expressions of numbers and named constants as well as registers and labels as operands, freeing the programmer from tedious repetitive calculations. Depending on the architecture, these elements may also be combined for specific instructions or addressing modes using offsets or other data as well as fixed addresses. Many assemblers offer additional mechanisms to facilitate program development, to control the assembly process, and to aid debugging.</br>

Two architecture for assembly:

 - x86 for 32 bits system
 - x86_64 for 64 bits system

Most used assembly languages:

 - Intel 
 - ARM
 - MIPS

> Example of assembly Intel x86 code (Hello World program):

```
global _start
section .text
_start:
  mov eax, 0x04
  mov ebx, 0x01
  mov ecx, msg
  mov edx, lmsg
  int 0x80
      
  mov eax, 0x01
  int 0x80

section .data
  msg: db "Hello World!", 0x0a, 0x00
  lmsg equ $-msg
```

</br>
</br>

<div id='compiler_linker_loader'></div>

## **0x01** **Compiler**, **Linker** **&** **Loader**

<div id='compiler'></div>

#### **Compiler**

A compiler is a computer program that transforms source code written in a programming language into binary language (system/machine language), as known as object code. The most common reason for converting source code is to create an executable program.</br>
Name "compiler" is primarily used for programs that translate source code from a high-level programming language to a lower level language.

```
     Source code                                    Machine language
+-------------------+                            +-------------------+
|  mov eax, 0x04    |                            | 01101101 01101111 |
|  mov ebx, 0x01    |        +----------+        | 01110110 00100000 |
|  mov ecx, msg     | -----> | Compiler | -----> | 01100101 01100001 |
|  mov edx, lmsg    |        +----------+        | 01111000 00101100 |
|  int 0x80         |                            | 00100000 00110000 |
+-------------------+                            +-------------------+
```

> Compilation example (with your previous *helloworld* program)

Note, in our case we use the *nasm* (Netwide Assembler) compiler.

```
root@ths-amonsec:/opt# file helloworld.asm
helloworld.asm: ASCII text
root@ths-amonsec:/opt# nasm -felf32 helloworld.asm 
root@ths-amonsec:/opt# file helloworld.o
helloworld.o: ELF 32-bit LSB relocatable, Intel 80386, version 1 (SYSV), not stripped
root@ths-amonsec:/opt# 
```

<div id='linker'></div>

#### **Linker**

In computing, a linker or link editor is a computer program that takes one or more object files generated by a compiler and combines them into a single executable file, library file, or another object file.

> Linker schema:

```
+--------+  +--------+  +--------+
|  lib   |  |  obj   |  |  obj   |
+--------+  +--------+  +--------+
    |           |           |
    |           |           |
    |       +--------+      |
    +---->  | linker | <----+
            +--------+
                |
     +----------+------------+
     |     (or) |        (or)|
+--------+  +--------+  +--------+
|  lib   |  |  dll   |  |  exe   |
+--------+  +--------+  +--------+
```
> Linker example (with your previous *helloworld* program):

Note, in this case we use the official GNU linker *ld*.

```
root@ths-amonsec:/opt# ld helloworld.o -o hello
root@ths-amonsec:/opt/slae# file hello
hello: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), statically linked, not stripped
root@ths-amonsec:/opt#
```

<div id='loader'></div>

#### **Loader**

A loader is the part of an operating system that is responsible for loading programs and libraries. It is one of the essential stages in the process of starting a program, as it places programs into memory and prepares them for execution. </br>

On UNIX systems, the loader creates a process. This involves reading the file and creating an address space for the process. Page table entries for the instructions, data and program stack are created and the register set is initialized. Then the loader executes a jump instruction to the first instruction in the program. This generally causes a page fault and the first page of your instructions is brought into memory. On some systems the loader is a little more interesting. For example, on systems like Windows NT that provide support for dynamically loaded libraries (DLLs), the loader must resolve references to such libraries similar to the way a linker does. 


> Loader schema:

```                                                 
                                           (Primary memory e.g RAM)
                                             |                   |
                                             |                   |
+---------------+                            +-------------------+
|   Executable  |         +--------+         |  Process Address  | 
|      file     | ------> | loader | ------> |  Space            |
|   (elf, exe)  |         +--------+         +-------------------+
+---------------+                            |                   |
                                             |                   |
```

> Laoder example (with your previous *helloworld* program)

```
root@ths-amonsec:/opt# ./hello 
Hello World!
root@ths-amonsec:/opt# 
```

</br>
</br>

<div id='basic_computer_architecture'></div>

## **0x03 Basic computer architecture (motherboard)**

We have four distinct *blocks* in a motherboard:

 - **CPU** or **Central Processing Unit**, is build to decode an execute different instructions;
 - **Memory** (RAM) were data are temporary stored;
 - **I/O Devices**  (and I/O Controllers) such as monitors, mouse and keyboard;
 - **System Bus**, that is used to connect them all.
 
> Architecture schema:

```
                       Motherboard
+------------------------------------------------------+
|                             +--------------+         |
|                             |      CPU     |         |
|  +----------+               +--------------+         |
|  |          |                     |  |               |
|  |  Memory  |---------------------+  |               |
|  |  (RAM)   |---------------------+  | (system Bus)  |
|  |          |                     |  |               |
|  |          |                     |  |               |
|  +----------+               +--------------+         |
|                             | I/O Devices  |         |
|                             +--------------+         |
+------------------------------------------------------+
```

</br>
</br>

<div id='central_processing_unit'></div>

## **0x04 Central Processing Unit (CPU)**

A CPU is basically composed with four *blocks*:

 - **Control Unit**, charged to retrieve, decode instruction and retrieve, store data in memory;
 - **Execution Unit**, the place where instructions are executed;
 - **Registers**, internal memories *boxes*;
 - **Flags** (FLAGS, EFLAGS), contains the current state of the processor.

> CPU schema:

```
                                                 +------------+
                      +------------+ <=========> | Registers  |
+-------+             |  Execution |             +------------+
|  CPU  | <=========> |    Unit    |            
+-------+             |            |             +------------+
                      +------------+ <=========> | Flags      |
                                                 +------------+
```

</br>
</br>

<div id='registers'></div>

## **0x05 Registers**

CPU mostly involve processing data and data need to be store somewhere (RAM or HDD). However, soring every single data is a complex and slow operation, due to the fact the CPU need to travel through control buses.</br>
That's why the CPU have internal memory storages called **registers**. Registers can store data without the need to access the memory, but registers are limited, in numbers and in capacity.</br></br>

In x86 CPU architecture we have ten registers of 32-bits length and these registers can be grouped in three categories:

 - General registers;
 - Control registers;
 - Segment registers.

Moreover, general registers can be divided into three others categories:

 - Data registers;
 - Pointer registers;
 - Index registers.

> x86 Registers Table

| Registers      |\|  Common Functionality                                            | 
|:---------:     |---                                                                 |
| EAX            |\| Accumulator Register - used for storing operands and result data |
| EBX            |\| Base Register - Pointer to data                                  |
| ECX            |\|  Counter Register - Loop Operations                              | 
| EDX            |\|  Data Register - I/O Pointer                                     |
| ESI / EDI      |\|   Data Pointer Registers for memory operations                   |
| ESP            |\|  Stack Pointer Register                                          |
| EBP            |\| Stack Data Pointer Register                                      |


<div id='data_registers'></div>

#### **Data** **registers**

Data registers are primarily used for logical and arithmetical operations. We have four 32-bits registers (EAX, EBX, ECX and EDX), four 16-bites registers (AX, BX, CX and DX) and six 8-bits registers (AH, AL, BH, BL, CH, CL, DH, DL).</br>

> Data registers schema:

```
32-bits                                     8-bits                     16-bits
Registers                                   Registers                  Registers
 ||                                              ||                          ||
 \/  31                               16 15      \/     8 7              0   \/
     +----------------------------------+--------------------------------+
EAX  |                                  |        AH       |      AL      |   AX
     +----------------------------------+--------------------------------+
EBX  |                                  |        BH       |      BL      |   BX
     +----------------------------------+--------------------------------+
ECX  |                                  |        CH       |      CL      |   CX
     +----------------------------------+--------------------------------+
EDX  |                                  |        DH       |      DL      |   DX
     +----------------------------------+--------------------------------+
```

<div id='pointer_registers'></div>

#### **Pointer registers**

Pointer registers, are composed of two 32-bits register (ESP and EBP) and two 16-bits registers(SP and BP).</br>
**ESP** (Stack Pointer) referring to the current position of data or address in the stack. By default, **ESP** point to the lower offset in the stack.</br>
**EBP** (Base Pointer) are used for subroutine(s) variable(s). By default, **EBP** point to the higher offset of the subroutine in the stack.</br>
> Pointer registers schema:
```
     31(bits)                     16 15                          0
     +------------------------------+----------------------------+
ESP  |                              |              SP            | Stack Pointer
     +------------------------------+----------------------------+
EBP  |                              |              BP            | Base Pointer
     +------------------------------+----------------------------+
```

<div id='index_registers'></div>

#### **Index** **registers**

The primal usage of Index registers if for *strings manipulation*. Index registers are composed of two 32-bits registers (ESI and EDI) and two 16-bits registers (SI and DI). They are used for indexing and addressing.</br>
**ESI** is the source index for string operations.</br>
**EDI** is the destination index for string operations.</br>

> Index registers schema:

```
     31(bits)                     16 15                          0
     +------------------------------+----------------------------+
ESI  |                              |             SI             | Source Index
     +------------------------------+----------------------------+
EDI  |                              |             DI             | Destination 
     +------------------------------+----------------------------+     Index
```

<div id='instruction_register'></div>

#### **Instruction** **register**

The instruction point is the **EIP** register, mainly used for exploit development, this register indicate the offset of the next instruction to execute. It's a unique 32-bit register.

> Instruction register schema:

```
     31(bits)                     16 15                          0
     +------------------------------+----------------------------+
EIP  |                                                           | Instruction 
     +------------------------------+----------------------------+   Register
```

<div id='segments_registers'></div>

#### **Segments** **registers**

Segments registers are used to define area where we can store data, code and stack. Segments registers are composed of six 16-bits registers (CS, DS, SS, ES, FS, GS).</br>
**CS** the code segment, contain all the instructions that the Execution Unit need to execute.</br>
**DS** the data segment, contain data and constants variables.</br>
**SS** the stack segment, contain return address of subroutines and procedures.</br>
**ES**, **FS** and **GS** are used as a **DS** *extension*, for more storage.</br>
Note, segments registers are used differently depending of the memory model (Flat, segmented).

> Segments register schema:

```
   15(bits)                       0
   +------------------------------+
CS |             Code             |
   +------------------------------+
DS |             Data             |
   +------------------------------+
SS |             Stack            |
   +------------------------------+
ES |             Data             |
   +------------------------------+
FS |             Data             |
   +------------------------------+
GS |             Data             |
   +------------------------------+
```

<div id='flags_register'></div>

#### **FLAGS**  **register**

The FLAGS register is the status register that contains the current state of the processor. This register is 16-bits wide. Many operation change the value of the FLAGS register, such as mathematical operations or comparisons.

> FLAGS register table:

| Bit#    | Abbreviation   | Description              | Category   |
|:-------:|:---------------|--------------------------|:-----------|
| 0       | CF             | Carry flag               | Status     |
| 1       |                | Reserved, always 1       |            |
| 2       | PF             | Parity flag              | Status     |
| 3       |                | Reserved                 |            |
| 4       | AF             | Adjust flag              | Status     |
| 5       |                | Reserved                 |            |
| 6       | ZF             | Zero flag                | Status     |
| 7       | SF             | Sign flag                | Status     |
| 8       | TF             | ATrap flag (single step) | Control    |
| 9       | IF             | Interrupt enable flag    | Control    |
| 10      | DF             | Direction flag           | Control    |
| 11      | OF             | Overflow flag            | Status     |
| 12      | IOPL           | I/O privilege level      | System     |
| 13      | IOPL           | I/O privilege level      | System     |
| 14      | NT             | Nested task flag         | System     |
| 15      |                | Reserved                 |            |


**CF** contains the carry of the 0 or 1 from a high-order bit after an arithmetic operation. Moreover, **CF** store the contents of last bit of a *shift* *rotate* operation.</br>

**PF** contains to total of 1-bits number in an arithmetic operation. If it's a 1-bits even number the parity flag is set to 0 otherwise if it's a 1-bits odd number the parity flag is set to 1</br>

**AF** contains the carry from bit 3 to bit 4 following an arithmetic operation. The AF is set when a 1-byte arithmetic operation causes a carry from bit 3 into bit 4. </br>

**ZF** contains the result of a comparison. If the result of the comparison is zero **ZF** is set to 1, else **ZF** is set to 0.</br>

**SF** contains the sign of the result of an arithmetic operation. A positive result set **SF** to 0 and a negative result set **SF** to 0.</br>

**TF**, it allows setting the operation of the processor in single-step mode. Used for debugging purposes.</br>

**IF** is used to enable or disable external interrupts, like keyboard interruption for example. External interrupts are disabled if **IF** is set as 0 and enabled if **IF** is set as 1.</br>

**DF** is used to determine which direction to used in string data comparison. If **DF** is set as 0 the direction is left to right and if **DF** is set as 1 the direction is right to left.</br>
**OF** It indicates the overflow of a high-order bit (leftmost bit) of data after a signed arithmetic operation.</br>

**IOPL** it shows the I/O privilege level of the current program or task. The Current Privilege Level (CPL) (CPL0, CPL1, CPL2, CPL3) of the task or program must be less than or equal to the IOPL in order for the task or program to access I/O ports.</br>

**NT** is used by the processor to control chaining of interrupted and called tasks.</br> 

> FLAGS register schema:

```
(bits)
 15   14   13   12   11   10   9    8    7    6    5    4    3    2    1    0  
+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
| 0  | N  |   IOPL  | O  | D  | I  | T  | S  | Z  | 0  | A  | 0  | P  | 1  | C  |
|    | T  |         | F  | F  | F  | F  | F  | F  |    | F  | 0  | F  |    | F  |
+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+

```

<div id='eflags_register'></div>

#### **EFLAGS**  **register**

FLAGS register 32-bits successor is the **EFLAGS** register. Of course, the wider registers (like EFLAGS in our case) retain compatibility with their smaller predecessors (FLAGS register).

> Truncated EFLAGS register table:

| Bit#    | Abbreviation   | Description                   | Category   |
|:-------:|:---------------|-------------------------------|:-----------|
| 16      | RF             | Resume flag                   | System     |
| 17      | VM             | Virtual 8086 mode flag        | System     |
| 18      | AC             | Alignment check               | System     |
| 19      | VIF            | Virtual interrupt flag        | System     |
| 20      | VIP            | Virtual interrupt pending     | System     |
| 21      | ID             | Able to use CPUID instruction | System     |
| 22      |                | Reserved                      |            |
| 23      |                | Reserved                      |            |
| 24      |                | Reserved                      |            |
| 25      |                | Reserved                      |            |
| 26      |                | Reserved                      |            |
| 27      |                | Reserved                      |            |
| 28      |                | Reserved                      |            |
| 29      |                | Reserved                      |            |
| 30      |                | Reserved                      |            |
| 31      |                | Reserved                      |            |


> Truncated EFLAGS register schema:

```
(bits)
 31   30   29   28   27   26   25   24   23   22   21   20   19   18   17   16  
+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
| 0  | 0  | 0  | 0  | 0  | 0  | 0  | 0  | 0  | 0  | I  | V  | V  | A  | V  | R  |
|    |    |    |    |    |    |    |    |    |    | D  | I  | I  | C  | M  | F  |
|    |    |    |    |    |    |    |    |    |    |    | P  | F  |    |    |    |
+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
```
**RF** used to control the response of a debugging exception and ensure that the execution unit execute only once an instruction during the debugging.</br>

**VM**, armed is used to enable the virtual 8086 mode. And unarmed to retrieve the protected mode.</br>

**AC**, if armed, check if all memory references are aligned. Otherwise  no checks.</br>  

**VIF** is a virtual reference of the **IF** flag. He is used with the **VIP** flag</br>

**VIP**, if armed, indicates a interruption waiting. Otherwise, no interruption are waiting. Only programs can set / disable this flag and the CPU only reads it. </br>

**ID** used to know if a program can use the CPUID instruction.</br>

> Complete EFLAGS register schema(vertical):

```  
(Abbreviation) (bits)   (Description) (Category)
     +-------+ 31
     | 0     | -------> Reserved
     +-------+ 30
     | 0     | -------> Reserved      
     +-------+ 29
     | 0     | -------> Reserved      
     +-------+ 28
     | 0     | -------> Reserved       
     +-------+ 27
     | 0     | -------> Reserved      
     +-------+ 26
     | 0     | -------> Reserved      
     +-------+ 25
     | 0     | -------> Reserved      
     +-------+ 24
     | 0     | -------> Reserved      
     +-------+ 23
     | 0     | -------> Reserved     
     +-------+ 22
     | 0     | -------> Reserved      
     +-------+ 21
     | ID    | -------> ID Flag      
     +-------+ 20
     | VIP   | -------> Virtual Interrupt Pending      
     +-------+ 19
     | VIF   | -------> Virtual Interrupt Flag       
     +-------+ 18
     | AC    | -------> Alignment Check      
     +-------+ 17
     | VM    | -------> Virtual -8086 Mode      
     +-------+ 16
     | RF    | -------> Resume Flag      
     +-------+ 15
     | 0     | -------> Reserved      
     +-------+ 14
     | NT    | -------> Nested Task       
     +-------+ 13
     |       | -----+
     + IOPL  + 12   |-> I/O Privileges Level
     |       | -----+
     +-------+ 11
     | OF    | -------> Overflow Flag
     +-------+ 10
     | DF    | -------> Direction Flag      
     +-------+ 9
     | IF    | -------> Interrupt Enable Flag      
     +-------+ 8
     | TF    | -------> Trap Flag      
     +-------+ 7
     | SF    | -------> Sign Flag      
     +-------+ 6
     | ZF    | -------> Zero Flag
     +-------+ 5
     | 0     | -------> Reserved      
     +-------+ 4
     | AF    | -------> Auxiliary Carry Flag
     +-------+ 3
     | 0     | -------> Reserved      
     +-------+ 2
     | PF    | -------> Parity Flag      
     +-------+ 1
     | 0     | -------> Reserved      
     +-------+ 0
     | CF    | -------> Carry Flag       
     +-------+
```

</br>
</br>

<div id='stack'></div>

## **0x06** **The** **Stack**

The Stack is a sort of process memory that are allocated by the CPU for each creation of a thread and cleared at the end of the thread. The mostly known particularity of the Stack is his data structure because the Stack works LIFO, Last In First Out.</br>
The stack is fast, due to the fact he don't require complex /slow operation and due to the LIFO. Moreover, the stack size don't change and can't be change till his destruction.</br>

The Stack contains both local variables, functions calls and other temporary information. More you add stuff into the Stack, more the Stack pointer (ESP) decrement. The Stack Pointer always start from the higher address and decrement for each data pushed into the Stack.</br>

> The Stack schema:

Note, the main function is also a subroutine, called by the system by the loader.

```
                                 Top of the Stack       
                                  (lower address)       _
Stack Point (ESP) ------>   +-------------------------+  |
                            | Locals of the           |  |
                            | called subroutine       |  |
Frame Pointer(FP) ------>   +-------------------------+  |-\ Stack Frame of the 
                            | Return address          |  |_/ called subroutine
                            +-------------------------+  |
                            | Parameters for the      |  |
                            | called subroutine       |  |
                          - +-------------------------+ - 
                         |  | Locals of the main      |
                         |  | 'system' subroutine     |
    Stack Frame of the /-|  +-------------------------+
    main 'system'      \-|  | Return address          |
    subroutine           |  +-------------------------+
                         |  | Parameters for the main |
                         |  | 'system' subroutine     |
                         |_ +-------------------------+
                            |           .             |
                            |           .             |
                            |           .             |   
                               Bottom of the Stack
                                (higher address)                          

```

</br>
</br>

<div id='floating_point_unit'></div>

## **0x07** **Floating** **Point** **Unit**

The floating point unit is a part of the computer system that are design to carry out operations that use floating point number. The most basics operation, such as addition, subtraction , multiplication, division square root or bit shifting. In most cases, one ore more FPU are integrated into the execution unit.</br> 

When a CPU need to execute a program that calls for a floating point operation, there are three ways to carry it out:

 - A floating-point unit emulator (a floating-point library);
 - Add-on FPU;
 - Integrated FPU.

FPU also know as x87 registers is a NPX (Numerical Processor eXtension) that are formed with height non-strict stack structure (ST0 to ST7) and height register of 80-bits wide (R0 to R7). </br>
The x87 provides single precision, double precision and 80-bit double-extended precision binary floating-point arithmetic.</br>

Note, with the Intel 80486 model, most x86 processor implement these instruction sets in the main processor and no longer need this module.</br>

> Floating Point Unit schema (the scale is not respected):

```
                                   Data Registers
                                   
                 79 78(bits)     64 63                                           0
              +----+---------------+---------------------------------------------+
          R7  |Sign| Exponent      | Significand                                 |
              +----+---------------+---------------------------------------------+
          R6  |    |               |                                             |
              +----+---------------+---------------------------------------------+
          R5  |    |               |                                             |
              +----+---------------+---------------------------------------------+
ST(7)     R4  |    |               |                                             |
to            +----+---------------+---------------------------------------------+
ST(0)     R3  |    |               |                                             |
              +----+---------------+---------------------------------------------+
          R2  |    |               |                                             |
              +----+---------------+---------------------------------------------+
          R1  |    |               |                                             |
              +----+---------------+---------------------------------------------+
          R0  |    |               |                                             |
              +----+---------------+---------------------------------------------+   
    
 15(bits)           0              47(bits)                                      0
 +------------------+              +---------------------------------------------+ 
 | Control Register |              | Last Instruction Pointer                    |
 +------------------+              +---------------------------------------------+
 +------------------+              +---------------------------------------------+
 | Status Register  |              | Last Data (Operand) Pointer                 |
 +------------------+              +---------------------------------------------+
 +------------------+              10(bits)     0              
 | Tag Register     |              +-------------+
 +------------------+              | Opcode      |    
                                   +-------------+
``` 

</br>
</br>

<div id='credits_and_references'></div>

## **0x08** **Credits** **&** **References**

Useful references:

 - <http://x86asm.net/articles/x86-architecture/index.html>
 - <http://flint.cs.yale.edu/cs422/doc/24547112.pdf>
 - <http://www.securitytube.net/>


Credits:

 - Vivek Ramachandran (SLAE teacher)
 - Ch3rn0byl (You made me fall into the depths of the assembler )

</br>
</br>
Version: 1.0</br>
First published date: Jul 2 2017</br>
Last published date: Jul 2 2017</br>
Contact: https://twitter.com/_amonsecTHS</br>
</br>
</br>
Amonsec.
</br>
</br>
ʕ•͡ᴥ•ʔ ʕ•͡ᴥ•ʔ ʕ•͡ᴥ•ʔ 