from enum import Enum, EnumMeta
class _EnumSuperClass(metaclass=EnumMeta):
    pass
class E(_EnumSuperClass, Enum):
    A = 1
print(repr(E.A))
