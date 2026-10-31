print(memoryview(b'\0\2\0').cast('?').tolist())
print(memoryview(b'\0\4\0').cast('?').tolist())
print(memoryview(bytes(range(256))).cast('?').tolist().count(True))
print(memoryview(b'\1\3\5').cast('?') == memoryview(b'\2\4\6').cast('?'))
