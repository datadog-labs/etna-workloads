import os, tarfile

class P:
    def __fspath__(self):
        return "stream.tar.gz"

try:
    with tarfile.open(P(), "w|gz") as tar:
        print(repr(tar.fileobj.name))
except Exception as e:
    print(type(e).__name__, e)
