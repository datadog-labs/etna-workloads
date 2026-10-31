import io, tarfile

buf = io.BytesIO()
with tarfile.open(fileobj=buf, mode="w") as t:
    ti = tarfile.TarInfo("a")
    ti.size = 3
    t.addfile(ti, io.BytesIO(b"abc"))
f = io.BytesIO(buf.getvalue())
print(tarfile.is_tarfile(f))
print(f.tell())
