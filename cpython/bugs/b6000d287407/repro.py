from dataclasses import dataclass

@dataclass
class NotFrozen:
    pass

@dataclass(frozen=True)
class Frozen:
    pass

try:
    @dataclass(frozen=True)
    class Child(NotFrozen, Frozen):
        pass
    print("no error")
except TypeError as e:
    print("TypeError:", e)
