import gzip
data = gzip.compress(b"hello world")
for d in (data[:-8], data[:-4]):
    try:
        print(repr(gzip.decompress(d)))
    except BaseException as e:
        print(type(e).__name__, e)
