import io, zipfile, os
txt = b'0123456789' * 2000
bio = io.BytesIO()
with zipfile.ZipFile(bio, "w", compression=zipfile.ZIP_STORED) as z:
    z.writestr("foo.txt", txt)
with zipfile.ZipFile(bio) as z:
    with z.open("foo.txt") as fp:
        fp.seek(10002, os.SEEK_CUR)
        print(fp._left, fp._compress_left)
        fp.seek(-5003, os.SEEK_CUR)
        print(fp.tell(), fp._left, fp._compress_left)
        fp.seek(0, os.SEEK_END)
        fp.seek(12345)
        print(fp.read(100) == txt[12345:12445])
