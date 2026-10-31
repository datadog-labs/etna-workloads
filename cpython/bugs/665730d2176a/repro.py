import bz2
d = bz2.BZ2Decompressor.__new__(bz2.BZ2Decompressor)
print(repr(d.decompress(bytes())))
