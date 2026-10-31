from dataclasses import dataclass

class A:
    pass

try:
    @dataclass(slots=True, weakref_slot=True)
    class B(A):
        pass
    print(B.__slots__)
    B()
except Exception as e:
    print(type(e).__name__, e)
