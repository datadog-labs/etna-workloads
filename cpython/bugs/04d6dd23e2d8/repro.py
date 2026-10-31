import reprlib

class list:
    def __repr__(self):
        return "not builtins.list"

print(reprlib.repr(list()))
