class A:
    def __ipow__(self, other):
        return NotImplemented

class B(A):
    def __rpow__(self, other):
        return 1

a = A()
try:
    a **= B()
    print(repr(a))
except TypeError as e:
    print("TypeError:", e)

x = None
try:
    x **= 2
except TypeError as e:
    print("TypeError:", e)
