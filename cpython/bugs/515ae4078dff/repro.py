import struct
S = struct.Struct.__new__(struct.Struct)
print(S.size)
try:
    S.unpack(b' ')
except RuntimeError as e:
    print("RuntimeError", e)
