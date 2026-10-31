from dataclasses import dataclass

def maker():
    if False:
        __class__ = 42

    def method(self):
        return __class__
    return method

@dataclass(slots=True)
class X:
    a: int
    meth = maker()

try:
    X(1).meth()
except NameError as e:
    print("NameError", e)
