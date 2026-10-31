import io

try:
    io.TextIOBase.read.__get__(io.StringIO(), "not_a_type")
except TypeError as e:
    print(repr(str(e)))
