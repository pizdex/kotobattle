#!/usr/bin/env python3

addr = 0x9af3
chars = {}

file = '../build/kotobattle.gbc'

for line in open('../charmap.asm'):
	if line.startswith('\tcharmap '):
		line = line[9:].split(';')[0].split(',')
		if len(line) != 2:
			continue

		char = line[0].strip()[1:-1]
		byte = int(line[1].strip()[1:], 16)

		if byte not in chars:
			chars[byte] = char

file = open(file, 'rb')
file.seek(0x7EFB3)
count = 32

#print(chars)
for i in range(count):
        byte = int.from_bytes(file.read(1), 'little')
        if byte in chars:
                char = chars[byte]
                print(char, end='')
        else:
                print('#', end='')
