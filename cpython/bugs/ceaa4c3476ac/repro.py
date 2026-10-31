import mmap

m = mmap.mmap(-1, 16)


class EvilIndex:
    def __index__(self):
        m.close()
        return 0


try:
    result = m.find(b"a", EvilIndex())
    print("no exception:", repr(result))
except ValueError as e:
    print("ValueError:", e)
