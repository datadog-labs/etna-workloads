import io

class Raw(io.RawIOBase):
    def writable(self): return True
    def write(self, b): return len(b)

class ClosedRaises(Raw):
    @property
    def closed(self):
        raise ValueError("test")

class NonBool(Raw):
    closed = NotImplemented

for cls in (ClosedRaises, NonBool):
    b = io.BufferedWriter(cls())
    for name, f in (("write", lambda: b.write(b"")), ("flush", b.flush), ("close", b.close)):
        try:
            print(cls.__name__, name, repr(f()))
        except BaseException as e:
            print(cls.__name__, name, type(e).__name__, e)
