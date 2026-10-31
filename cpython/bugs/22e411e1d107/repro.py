from typing import NamedTuple

class Vanilla:
    def __set_name__(self, owner, name):
        self.name = name

class Foo(NamedTuple):
    attr = Vanilla()

print(hasattr(Foo().attr, "name"))

class Annoying:
    def __set_name__(self, owner, name):
        raise ValueError

try:
    class Bar(NamedTuple):
        attr = Annoying()
except ValueError as e:
    print(repr(e), e.__notes__)
else:
    print("no error")
