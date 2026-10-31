class Evil:
    def __init__(self, ba):
        self.ba = ba
    def __buffer__(self, flags):
        self.ba.clear()
        return memoryview(self.ba)
    def __release_buffer__(self, view):
        view.release()
    def __index__(self):
        self.ba.clear()
        return ord("A")

for name in ("find", "count", "index", "rindex", "rfind"):
    ba = bytearray(b"A")
    try:
        print(name, repr(getattr(ba, name)(Evil(ba))))
    except BaseException as e:
        print(name, type(e).__name__)
