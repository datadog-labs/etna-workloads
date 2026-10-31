from typing import Protocol, runtime_checkable

@runtime_checkable
class P[T](Protocol):
    def meth(self): ...

print(sorted(P.__protocol_attrs__))
print(sorted(P.__non_callable_proto_members__))
class C:
    def meth(self): pass
print(issubclass(C, P))
