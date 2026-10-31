import io, tarfile

buf = io.BytesIO()
with tarfile.open(mode='w', fileobj=buf, format=tarfile.GNU_FORMAT) as tar:
    ti = tarfile.TarInfo(('a' * 101) + '/')
    ti.type = tarfile.DIRTYPE
    tar.addfile(ti)
buf.seek(0)
with tarfile.open(fileobj=buf) as tar:
    print(tar.getnames())
    print(tar.getmember('a' * 101).isdir())
