import io, zipfile
data = io.BytesIO()
with zipfile.ZipFile(data, mode="w", allowZip64=True) as zf:
    with zf.open("text.txt", mode="w", force_zip64=True) as zi:
        zi.write(b"_")
b = data.getvalue()
# local header: version needed (offset 4), sizes (offset 18, 22)
print(int.from_bytes(b[4:6], "little"), hex(int.from_bytes(b[18:22], "little")), hex(int.from_bytes(b[22:26], "little")))
