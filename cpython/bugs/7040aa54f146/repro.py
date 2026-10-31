import tarfile, io
S = b" "; N = tarfile.NUL
hdr = (N*100 + b"0000755"+N + b"0000001"+N + b"0000001"+N + b"\xff"*11 + S
       + N*11 + S + b"0011327"+N + tarfile.REGTYPE + N*100 + tarfile.GNU_MAGIC
       + N*32 + N*32 + N*8 + N*8 + N*167)
assert len(hdr) == 512
data = hdr + tarfile.TarInfo("filename").tobuf(tarfile.GNU_FORMAT) + tarfile.NUL*1024
try:
    with tarfile.open(fileobj=io.BytesIO(data)) as t:
        print(repr(t.getnames()))
except Exception as e:
    print(type(e).__name__, e)
