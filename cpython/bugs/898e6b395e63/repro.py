import sys
if len(sys.argv) > 5:
    x: int
else:
    y: str
print(sorted(sys.modules["__main__"].__annotations__))
try:
    exec("__conditional_annotations__ = 0\nz: int\n", {})
    print("no error")
except TypeError:
    print("TypeError")
