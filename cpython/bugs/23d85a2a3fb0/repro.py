import struct
for payload in (0x80001, 0x80000000001):
    bits = (0x7ff << 52) + payload
    x = struct.unpack('<d', bits.to_bytes(8, 'little'))[0]
    print(hex(payload), struct.pack('<f', x).hex(), struct.pack('<e', x).hex())
