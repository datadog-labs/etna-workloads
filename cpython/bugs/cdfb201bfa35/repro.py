from typing import Protocol, runtime_checkable

class C:
    def x(self): pass

@runtime_checkable
class EmptyProtocol(Protocol): pass

print(issubclass(object, Protocol))
print(isinstance(object(), Protocol))
print(issubclass(C, Protocol))
print(issubclass(object, EmptyProtocol))
print(issubclass(object, Protocol))
print(isinstance(object(), Protocol))
