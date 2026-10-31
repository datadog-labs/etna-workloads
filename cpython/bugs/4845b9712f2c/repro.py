from reprlib import recursive_repr

def f(self):
    return 'X()'

g = recursive_repr()(f)
print(g.__wrapped__ is f)
