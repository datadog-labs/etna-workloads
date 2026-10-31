import sys
print("a" in [sys._getframe().f_locals for a in [0]][0])
print([sys._getframe().f_locals["a"] for a in [0]][0])
def f():
    return [sys._getframe().f_locals["a"] for a in [0]][0]
print(f())
class C:
    v = [sys._getframe().f_locals["a"] for a in [0]][0]
print(C.v)
