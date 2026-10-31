class A:
    def __buffer__(self, flags):
        return memoryview(bytes(8))
    def __release_buffer__(self, view):
        pass

b = bytearray(8)
with memoryview(b):
    try:
        b.extend(A())
    except BufferError as e:
        print("BufferError", e)
