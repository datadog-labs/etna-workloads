import io

class B:
    def __buffer__(self, flags):
        memio.close()
        return memoryview(b"A")

memio = io.BytesIO()
try:
    print(memio.write(B()))
except Exception as e:
    print(type(e).__name__, e)
