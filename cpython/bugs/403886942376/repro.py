from typing import TypedDict, NotRequired, Required

class NotTotal(TypedDict, total=False):
    a: int

class Total(NotTotal):
    a: int

print(sorted(Total.__required_keys__), sorted(Total.__optional_keys__))

class Base1(TypedDict):
    a: NotRequired[int]

class Base2(TypedDict):
    a: Required[str]

class Child(Base1, Base2):
    pass

print(sorted(Child.__required_keys__), sorted(Child.__optional_keys__))
