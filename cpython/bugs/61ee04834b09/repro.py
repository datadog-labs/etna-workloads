fmt = bytearray(b"%a end")

class S:
    def __repr__(self):
        fmt.clear()
        return "E"

try:
    print(repr(fmt.__mod__(S())))
except BufferError as e:
    print("BufferError", e)
