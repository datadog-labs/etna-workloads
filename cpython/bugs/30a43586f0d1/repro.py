from collections import UserDict

class A(UserDict):
    def __missing__(self, key):
        return 456

print(repr(A()[123]))
print(repr(A().get(123)))
