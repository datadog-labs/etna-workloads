import io, zipfile
buf = io.BytesIO()
with zipfile.ZipFile(buf, "w") as zf:
    zf.writestr("a.txt", "x")
    zf.writestr("b/c.txt", "y")
    zf.writestr("g/h/i.txt", "z")
root = zipfile.Path(zipfile.ZipFile(buf))
for pat in ("b", "b*", "g/h", "g*/h*"):
    print(pat, [p.at for p in root.glob(pat)])
