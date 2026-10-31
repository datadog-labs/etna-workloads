import _testcapi
from dataclasses import dataclass

@dataclass(slots=True)
class A(_testcapi.HeapCTypeWithDict):
    __dict__: dict = {}
print(A.__slots__)

@dataclass(slots=True)
class B(_testcapi.HeapCTypeWithWeakref):
    __dict__: dict = {}
print(B.__slots__)
