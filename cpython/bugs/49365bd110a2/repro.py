from enum import Flag, auto

class X(Flag):
    A = auto()
    B = auto()
    C = A | B
    D = ~A

print(list(X))
print(repr(X.D), X.D.value)
print(repr(~X.A))
