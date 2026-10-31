import gzip
for mtime in (0, 42):
    c = gzip.compress(b"hello world", compresslevel=1, mtime=mtime)
    print(mtime, c[4:8].hex(), c[9])
