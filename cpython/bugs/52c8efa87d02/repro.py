import os
for f in (os.listdir, os.scandir, os.listxattr):
    try:
        r = f(-1)
        print(f.__name__, "no error", type(r).__name__)
    except OSError as e:
        print(f.__name__, "OSError", e.errno)
