import os, errno, pathlib
from unittest import mock

def raiser(err):
    def f(*a, **k):
        raise OSError(err, os.strerror(err))
    return f

pathlib.Path('src').write_text('hello')
with mock.patch('fcntl.ioctl', raiser(errno.EXDEV)), \
     mock.patch('os.copy_file_range', raiser(errno.EXDEV)), \
     mock.patch('os.sendfile', raiser(errno.ENOTSOCK)):
    try:
        pathlib.Path('src').copy('dst')
        print(repr(pathlib.Path('dst').read_text()))
    except Exception as e:
        print(type(e).__name__, e)
