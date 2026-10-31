import tarfile, io, os
buf = io.BytesIO()
with tarfile.open(fileobj=buf, mode='w') as tar:
    ti = tarfile.TarInfo('sub/link')
    ti.type = tarfile.SYMTYPE
    ti.linkname = '../target'
    tar.addfile(ti)
buf.seek(0)
os.mkdir('out')
with tarfile.open(fileobj=buf) as tar:
    try:
        tar.extractall('out', filter='data')
        print('ok', os.readlink('out/sub/link'))
    except Exception as e:
        print(type(e).__name__, e)
