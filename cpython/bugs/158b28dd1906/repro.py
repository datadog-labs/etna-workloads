from typing import TypeVar, Protocol, Generic
T1 = TypeVar('T1'); T2 = TypeVar('T2'); S = TypeVar('S')
class A(Protocol[T1]): pass
class B2(A[T2], Protocol[T1, T2]): pass
print(B2.__parameters__)
try:
    class X(A[S], Protocol[T1, T2]): pass
    print("no error")
except TypeError as e:
    print(e)
