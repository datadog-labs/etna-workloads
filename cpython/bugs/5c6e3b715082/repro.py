from dataclasses import dataclass

@dataclass(slots=True)
class A:
    x: int = 1
    def f(self):
        return super().__repr__() is not None

try:
    print(A().f())
except TypeError as e:
    print("TypeError:", e)
