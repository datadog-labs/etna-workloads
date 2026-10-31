import io, zipfile
buf = io.BytesIO()
with zipfile.ZipFile(buf, "w") as z:
    z.writestr("a.txt", "x")
zf = zipfile.ZipFile(buf)
zf.filename = None
p = zipfile.Path(zf).joinpath("example")
for attr in ("suffix", "suffixes", "name", "stem"):
    try:
        print(attr, repr(getattr(p, attr)))
    except Exception as e:
        print(attr, type(e).__name__, e)
