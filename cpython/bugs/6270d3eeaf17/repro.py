import os, tempfile

class P:
    def __init__(self, p): self.p = p
    def __fspath__(self): return self.p

d = os.getcwd()
for args in [(P(b'/'),), (P('/'),), ('', P(b''))]:
    try:
        print(tempfile._infer_return_type(*args))
    except TypeError as e:
        print('TypeError', e)
fd, name = tempfile.mkstemp(dir=P(os.fsencode(d)))
os.close(fd)
print(type(name))
os.remove(name)
