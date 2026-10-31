import io, sys
m = io.BytesIO()
print(m.seek(sys.maxsize))
b = bytearray(2)
print(m.readinto(b))
print(repr(m.read(4)))
