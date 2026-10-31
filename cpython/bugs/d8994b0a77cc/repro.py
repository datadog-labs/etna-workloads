class MyClass: pass

class MyStr(str):
    def __hash__(self):
        return super().__hash__()
    def __eq__(self, other):
        obj2 = MyClass()
        obj2.a = "a"
        obj2.b = "b"
        obj2.c = "c"
        return super().__eq__(other)

obj = MyClass()
obj.a = "a"
obj.b = "b"
x = {}
x[MyStr("a")] = MyStr("a")
try:
    x.update(obj.__dict__)
except RuntimeError as e:
    print("RuntimeError:", e)
print(repr(x))
