import os, io, tarfile

buf = io.BytesIO()
with tarfile.open(fileobj=buf, mode="w") as tar:
    data = b"regtype content"
    ti = tarfile.TarInfo("ustar/regtype")
    ti.size = len(data)
    tar.addfile(ti, io.BytesIO(data))
    li = tarfile.TarInfo("ustar/lnktype")
    li.type = tarfile.LNKTYPE
    li.linkname = "ustar/regtype"
    tar.addfile(li)
buf.seek(0)

os.makedirs("ustar")
with open("target", "wb") as f:
    f.write(b"target")
os.symlink(os.path.abspath("target"), "ustar/lnktype")

with tarfile.open(fileobj=buf) as tar:
    try:
        tar.extract("ustar/regtype", ".", filter="data")
        tar.extract("ustar/lnktype", ".", filter="data")
    except Exception as e:
        print(type(e).__name__)
for p in ("target", "ustar/lnktype"):
    with open(p, "rb") as f:
        print(f.read())
