import tarfile, io, os

buf = io.BytesIO()
with tarfile.open(fileobj=buf, mode='w') as tar:
    # "a" points into a subdirectory; "a/../x" is normalized to "x" by the
    # data filter, but realpath would follow "a" first and land elsewhere.
    for name, typ, link in [('d', tarfile.DIRTYPE, ''),
                            ('d/sub', tarfile.DIRTYPE, ''),
                            ('d/a', tarfile.SYMTYPE, 'sub'),
                            ('d/esc', tarfile.SYMTYPE, 'a/../../outside')]:
        ti = tarfile.TarInfo(name)
        ti.type = typ
        ti.linkname = link
        tar.addfile(ti)
buf.seek(0)
os.mkdir('dest')
with tarfile.open(fileobj=buf) as tar:
    for m in tar:
        try:
            f = tarfile.data_filter(m, 'dest')
            print(m.name, repr(f.linkname) if f.issym() else 'ok')
        except Exception as e:
            print(m.name, type(e).__name__)
