import types
from typing import Annotated, get_type_hints

class MyAlias(types.GenericAlias):
    pass

class MyClass:
    def __class_getitem__(cls, args):
        return MyAlias(cls, args)

def func(x: MyClass['int'], y: MyClass[Annotated[int, ...]]): ...

h = get_type_hints(func)
print(type(h['x']).__name__, type(h['y']).__name__)
