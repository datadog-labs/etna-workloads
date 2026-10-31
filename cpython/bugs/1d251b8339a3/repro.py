import inspect
from dataclasses import dataclass

@dataclass
class C:
    x: undefined
    y: list[undefined2] = None

print(repr(C.__doc__))
print(inspect.formatannotation(__import__('annotationlib').ForwardRef('Foo')))
