smuggled = None

class C(bytearray):
    def __release_buffer__(s, buffer):
        global smuggled
        for f in (lambda: memoryview(buffer), lambda: buffer.cast("b"),
                  lambda: buffer.toreadonly(), lambda: buffer[:1],
                  lambda: buffer.__buffer__(0)):
            try:
                f()
                print("no error")
            except ValueError as e:
                print("ValueError", e)
        smuggled = buffer
        super().__release_buffer__(buffer)

c = C(b"hello")
with memoryview(c) as mv:
    pass
c.clear()
try:
    print(smuggled.tobytes())
except ValueError as e:
    print("ValueError", e)
