from dataclasses import dataclass

@dataclass
class C:
    recursive: object = ...

c = C()
c.recursive = c
try:
    print(c == c)
except RecursionError:
    print("RecursionError")
