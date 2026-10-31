array = bytearray(b',')
def iterator():
    array.clear()
    yield b'A'
    yield b'B'
try:
    print(repr(array.join(iterator())))
except BufferError as e:
    print("BufferError", e)
