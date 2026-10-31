class SymbolicBool:
    def __bool__(self):
        raise TypeError("no bool")

class Symbol:
    def __gt__(self, other):
        return SymbolicBool()

def f():
    x = Symbol()
    try:
        if x > 0:
            return "true"
        return "false"
    except TypeError as e:
        return repr(e)

for _ in range(3):
    print(f())
