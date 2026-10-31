import tarfile, io
with open("f.txt", "wb") as f:
    f.write(b"hello")
tar = tarfile.open(fileobj=io.BytesIO(), mode="w")
ti = tar.gettarinfo("f.txt")
try:
    tar.addfile(ti)
    print("no error")
except ValueError as e:
    print("ValueError:", e)
