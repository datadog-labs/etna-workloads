class Outer:
    x: int
    def method(self, x: int):
        pass
def f() -> None:
    def nested() -> None: pass
    return nested
print(Outer.method.__annotate__.__qualname__)
print(f.__annotate__.__qualname__)
print(f().__annotate__.__qualname__)
print(Outer.__annotate__.__qualname__)
