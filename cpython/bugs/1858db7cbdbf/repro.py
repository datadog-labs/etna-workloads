import gzip, io, zlib
b = io.BytesIO()
message = b"important message here."
with gzip.GzipFile(fileobj=b, mode='w') as f:
    f.write(message)
    f.flush()
    partial = b.getvalue()
d = zlib.decompressobj(wbits=-zlib.MAX_WBITS)
s = io.BytesIO(partial)
gzip._read_gzip_header(s)
print(repr(d.decompress(s.read())))
