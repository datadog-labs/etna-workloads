import os, tarfile
os.mkdir("sub")
tarfile.open("sub/out.tar.gz", "w|gz").close()
with open("sub/out.tar.gz", "rb") as f:
    print(b"sub" in f.read())
