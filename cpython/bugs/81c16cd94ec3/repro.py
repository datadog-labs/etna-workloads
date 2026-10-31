import os, tempfile

with tempfile.TemporaryDirectory() as base:
    target = os.path.join(base, 'file1')
    open(target, 'wb').close()
    os.chmod(target, 0)
    d = tempfile.TemporaryDirectory()
    os.symlink(target, os.path.join(d.name, 'symlink'))
    os.chmod(d.name, 0o500)
    d.cleanup()
    print(os.path.exists(d.name))
    print(oct(os.stat(target).st_mode & 0o777))
