import functools

class A:
    def __eq__(self, other):
        return True
    def __hash__(self):
        return 1
    @functools.singledispatchmethod
    def t(self, arg):
        return self

a = A()
b = A()
print(a.t(1) is a)
print(b.t(2) is b)

class B:
    def __eq__(self, other):
        raise AssertionError
    def __hash__(self):
        raise AssertionError
    @functools.singledispatchmethod
    def t(self, arg):
        pass

try:
    B().t(1)
    hash(B().t)
    B().t == B().t
    print("ok")
except BaseException as e:
    print(type(e).__name__)
