import zipfile, os, io
b = io.BytesIO()
with zipfile.ZipFile(b, "w") as z:
    z.writestr("foo.txt", b"Charge men!")
with zipfile.ZipFile(b) as z:
    with z.open("foo.txt") as fp:
        fp.read(6)
        fp.seek(1, os.SEEK_CUR)
        print(repr(fp.read(-1)))
