class A:
    @staticmethod
    def some(cls, *args, **kwargs):
        return ("A", args, kwargs)

class B(A):
    def some(cls, *args, **kwargs):
        return super().some(cls, *args, **kwargs)

class C(B):
    @staticmethod
    def some(cls):
        return super().some(cls)

for _ in range(200):
    r = C.some(C)
print(repr(r))
