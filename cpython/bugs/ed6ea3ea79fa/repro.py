from typing import Protocol, get_protocol_members, runtime_checkable

class classproperty:
    def __get__(self, instance, type):
        raise RuntimeError("NO")

try:
    class Commentable(Protocol):
        evil = classproperty()
    print(sorted(get_protocol_members(Commentable)))
except BaseException as e:
    print("nonruntime:", type(e).__name__, e)

try:
    @runtime_checkable
    class C2(Protocol):
        evil = classproperty()
except BaseException as e:
    print("runtime:", type(e).__name__, e, type(e.__cause__).__name__)
