import io
with open("t.txt", "wb") as f:
    f.write(b'line1\r')
with open("t.txt", "r") as f:
    print(repr(f.readline()))
    pos = f.tell()
    print(type(pos).__name__)
    f.seek(pos)
    print(repr(f.read()))
