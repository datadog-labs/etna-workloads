import struct
# half-precision NaN with payload 0x155 (signaling, sign 0)
data = bytes.fromhex('7d55')[::-1]
v = struct.unpack('<e', data)[0]
print(struct.pack('<e', v).hex())
# double sNaN with payload packed to float32
d = bytes.fromhex('7ff0000000080001')[::-1]
print(struct.pack('<f', struct.unpack('<d', d)[0]).hex())
