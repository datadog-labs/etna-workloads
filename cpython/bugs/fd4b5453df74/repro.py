import posixpath
open('file', 'w').close()
for p in ['file/x', 'file/', 'file/../x']:
    try:
        r = posixpath.realpath(p, strict=True)
        print('returned', posixpath.relpath(r))
    except OSError as e:
        print(type(e).__name__, e.errno)
