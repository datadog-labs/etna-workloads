class A:
    def __anext__(self):
        raise ValueError("custom")

try:
    anext(A(), 1)
except ValueError as e:
    print("ok", repr(e))
