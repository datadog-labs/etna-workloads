import io, zipfile

buf = io.BytesIO()
with zipfile.ZipFile(buf, 'w') as zf:
    zf.writestr('foo\\bar.txt', b'data')
    zf.writestr('../up.txt', b'x')
buf.seek(0)
root = zipfile.Path(zipfile.ZipFile(buf))
print([p.name for p in root.iterdir()])
print(root.joinpath('foo\\bar.txt').exists())
