def check_byte(byte):
    # check 7th bit
    if((byte >> 7) & 1) == 1:
        # check 6th bit
        if((byte >> 6) & 1) == 1:
            return '11'
        else:
            return '10'
    else:
        # check 6th bit
        if((byte >> 6) & 1) == 1:
            return '01'
        else:
            return '00'

def Func_0ef6(byte):
    #print("Func_0ef6")
    # Copy bytes directly
    length = (byte & 0x3f) + 1
    length, cf = length >> 1, length & 1
    #print("Length: $%02x, Carry %d" % (length, cf))

    if(cf == 1):
        #print("Copying 1 more byte (carry)")
        data.append(int.from_bytes(baserom.read(1), 'little'))
    if(length == 0):
        #print("goto next byte")
        return

    # Start copying here
    #print("Copying $%02x bytes" % (length * 2))
    while length != 0:
        data.append(int.from_bytes(baserom.read(1), 'little'))
        data.append(int.from_bytes(baserom.read(1), 'little'))
        length -= 1
    #print("goto next byte")

def Func_0f34(byte):
    #print("Func_0f34")
    # Re-copy already processed bytes
    length = byte & 0x3f
    jump1 = -abs(0x100 - int.from_bytes(baserom.read(1), 'little'))
    jump2 = abs(0x100 - int.from_bytes(baserom.read(1), 'little')) - 1
    jump1 = jump1 - (jump2 * 0x100)
    #print("jump1 %02x, jump2 %02x" % (jump1, jump2))

    #print("Copying 4 bytes")
    for i in range(4):
        data.append(data[jump1:(jump1 + 1)][0])

    length, cf = length >> 1, length & 1
    #print("Length: $%02x, Carry %d" % (length, cf))
    if(cf == 1):
        #print("Copying 1 more byte (carry)")
        data.append(data[jump1:(jump1 + 1)][0])
    if(length == 0):
        #print("goto next byte")
        return

    # Keep copying from prev bytes
    #print("Copying $%02x more bytes" % (length * 2))
    while length != 0:
        data.append(data[jump1:(jump1 + 1)][0])
        data.append(data[jump1:(jump1 + 1)][0])
        length -= 1
    #print("goto next byte")

def asm_0fc0(byte):
    #print("asm_0fc0")
    length = (byte & 0x3f) + 1
    #print("Length: $%02x" % length)

    byte1 = int.from_bytes(baserom.read(1), 'little')
    byte2 = int.from_bytes(baserom.read(1), 'little')
    for i in range(2):
        data.append(byte1)
        data.append(byte2)
    while length != 0:
        data.append(byte1)
        data.append(byte2)
        length -= 1
    #print("goto next byte")

def asm_0f94(byte):
    # Repeat byte number of times
    #print('asm_0f94')

    length = byte & 0x3f
    if(length == 0):
        print("TODO: LENGTH IS ZERO I THINK WE EXIT HERE")
        return

    byte1 = int.from_bytes(baserom.read(1), 'little')
    data.append(byte1)
    data.append(byte1)

    length, cf = length >> 1, length & 1
    if(cf == 1):
        data.append(byte1)
    if(length == 0):
        #print("goto next byte")
        return

    while length != 0:
        data.append(byte1)
        data.append(byte1)
        length -= 1

    #print("goto next byte")

global data
data = []

print("Reading encoded data...")
baserom = open('../build/kotobattle.gbc', 'rb')

bank = 0x7f
addr = 0x5e2d
baserom.seek((bank * 0x4000) + (addr - 0x4000))

start_addr = baserom.tell()
print("Start address: $%04x" % start_addr)

while True:
    #print("Address: 0x%04x" % baserom.tell())
    byte = int.from_bytes(baserom.read(1), 'little')
    #print("Byte: $%02x" % byte)
    if byte == 0x00:
        break

    #print("Top bits: %s" % check_byte(byte))
    if check_byte(byte) == '11':
        Func_0ef6(byte)
        #print()
    elif check_byte(byte) == '10':
        Func_0f34(byte)
        #print()
    elif check_byte(byte) == '01':
        asm_0fc0(byte)
        #print()
    elif check_byte(byte) == '00':
        asm_0f94(byte)
        #print()

end_addr = baserom.tell()
print("End address: $%04x" % end_addr)

print("Writing encoded file...")
with open("../gfx/encoded/encoded_%02x_%04x.kb" % (bank, addr), "wb") as ofile:
        baserom.seek(start_addr)
        ofile.write(baserom.read(end_addr - start_addr))

baserom.close()
with open("../gfx/decoded/decoded_%02x_%04x.w128.2bpp" % (bank, addr), "wb") as f:
        print("Writing 2bpp data...")
        f.write(bytearray(data))

print("Done!")

