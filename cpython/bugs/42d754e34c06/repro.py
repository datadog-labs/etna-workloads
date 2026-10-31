import io, tarfile
for fmt in (tarfile.GNU_FORMAT, tarfile.PAX_FORMAT):
    buf = io.BytesIO()
    with tarfile.open(mode='w', fileobj=buf, format=fmt) as tar:
        ti = tarfile.TarInfo()
        ti.type = tarfile.AREGTYPE
        ti.name = 'a' * 99 + '/' + 'b' * 3
        tar.addfile(ti)
    buf.seek(0)
    with tarfile.open(mode='r', fileobj=buf) as tar:
        print(fmt, [(t.name[-5:], t.type) for t in tar.getmembers()])
