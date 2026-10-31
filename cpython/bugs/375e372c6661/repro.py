import io, sys

with open("f.bin", "wb") as f:
    f.write(b"hello")

with open("f.bin", "rb", buffering=0) as raw:
    bufio = io.BufferedReader(raw, buffer_size=8)
    try:
        bufio.read1(sys.maxsize // 2 + 1)
    except MemoryError:
        print("MemoryError")
    try:
        print(repr(bufio.read1(1)))
    except RuntimeError as e:
        print('RuntimeError', e.args[0].split(' <')[0])
