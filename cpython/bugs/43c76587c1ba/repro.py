class MyStr(str): pass
class MyClass: pass

obj = MyClass()
obj.attr1 = 1

obj2 = MyClass()
d = obj2.__dict__
d[MyStr("attr1")] = 2
print(repr(list(d)), type(list(d)[0]).__name__, d)
