import _io, io
b = _io._TextIOBase.read.__get__(io.StringIO())
print(type(b).__name__)
