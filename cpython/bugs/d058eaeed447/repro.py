class A:
    def meth(self):
        return self

class B:
    pass

a = A()
b = B()
b.meth = a.meth.__get__(b, B)
print(b.meth() is a)
