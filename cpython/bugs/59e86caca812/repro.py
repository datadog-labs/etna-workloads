import struct, zipfile
s = struct.Struct("<HH")
a = s.pack(1, 1) + b"a"
b = s.pack(2, 2) + b"bb"
c = s.pack(3, 3) + b"ccc"
print(repr(zipfile._Extra.strip(a+b+c, (1,))))
print(repr(zipfile._Extra.strip(b+a+c, (1,))))
print(repr(zipfile._Extra.strip(a+a+b"z", (1,))))
