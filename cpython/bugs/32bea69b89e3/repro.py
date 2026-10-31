import os, tempfile
path = tempfile.mkdtemp(dir=".")
print(os.path.isabs(path))
os.rmdir(path)
