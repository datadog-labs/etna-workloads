import os, shutil

os.mkdir('d')
open('d/f', 'w').close()

real_unlink = os.unlink
def racing_unlink(path, *, dir_fd=None):
    real_unlink(path, dir_fd=dir_fd)  # file vanishes before our unlink
    real_unlink(path, dir_fd=dir_fd)  # -> FileNotFoundError
os.unlink = racing_unlink

errors = []
shutil.rmtree('d', onexc=lambda fn, p, e: errors.append((fn.__name__, p, type(e).__name__)))
print(errors, os.path.exists('d'))
