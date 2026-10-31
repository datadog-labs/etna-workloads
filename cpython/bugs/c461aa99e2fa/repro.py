import _pyio

class B:
    count = 0
    def __buffer__(self, flags):
        self.count += 1
        if self.count == 1:
            return memoryview(b"AAA")
        return memoryview(b"BBBBBBBBB")

memio = _pyio.BytesIO(b'0123456789')
memio.seek(2)
b = B()
n = memio.write(b)
print(b.count, n, memio.getvalue(), memio.tell())
