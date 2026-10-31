import io

class Misbehaved(io.RawIOBase):
    def __init__(self, ret):
        self._ret = ret
    def readinto(self, b):
        return self._ret

try:
    print(repr(Misbehaved(2).read(1)))
except ValueError as e:
    print("ValueError:", e)
for n in (-1, -1000):
    try:
        print(repr(Misbehaved(n).read(1)))
    except ValueError as e:
        print("ValueError:", e)
