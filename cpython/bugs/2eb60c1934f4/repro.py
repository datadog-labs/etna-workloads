import gzip, io
b = io.BytesIO()
message = b"important message here."
with gzip.GzipFile(fileobj=b, mode='w') as f:
    f.write(message)
    f.seek(len(message))
    f.write(message)
print(repr(gzip.decompress(b.getvalue())))
