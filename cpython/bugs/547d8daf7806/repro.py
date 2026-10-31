class MyStr(str): pass
class MyClass: pass
obj = MyClass()
obj.attr = 1
obj.__dict__[MyStr('attr')] = 2
print(obj.attr)
