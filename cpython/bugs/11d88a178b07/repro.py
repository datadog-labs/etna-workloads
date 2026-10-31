import os, shutil, tempfile

orig_close = os.close
count = 0
def close(fd):
    global count
    orig_close(fd)
    count += 1
    raise OSError

tmp = tempfile.mkdtemp()
os.makedirs(os.path.join(tmp, 'dir1', 'dir2'))
errors = []
os.close = close
try:
    shutil.rmtree(os.path.join(tmp, 'dir1'),
                  onexc=lambda *a: errors.append((a[0].__name__, a[1].replace(tmp, 'T'))))
except BaseException as e:
    print('raised', type(e).__name__)
finally:
    os.close = orig_close
print(count, errors)
print(os.path.isdir(os.path.join(tmp, 'dir1', 'dir2')))
shutil.rmtree(tmp, ignore_errors=True)
