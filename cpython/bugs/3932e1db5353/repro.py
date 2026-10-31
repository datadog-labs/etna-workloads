import inspect
obj = bytearray(b'abc')
for f in (inspect.BufferFlags.READ, inspect.BufferFlags.WRITE):
    try:
        obj.__buffer__(f)
        print("no error")
    except SystemError as e:
        print("SystemError", e)
