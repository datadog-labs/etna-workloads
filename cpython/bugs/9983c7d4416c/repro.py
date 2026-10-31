import io, os, tarfile

bio = io.BytesIO()
with tarfile.TarFile(mode='w', fileobj=bio, encoding='ascii', errors='surrogateescape') as w:
    ti = tarfile.TarInfo('\udced\udca0\udc80')
    w.addfile(ti)

for level in (1, 0):
    bio.seek(0)
    tar = tarfile.TarFile(fileobj=bio, encoding='utf-8', errors='surrogatepass',
                          errorlevel=level, debug=1)
    print(tar.getnames())
    try:
        tar.extractall()
        print('no exception')
    except Exception as e:
        print(type(e).__name__)
    print(os.listdir())
