from types import GenericAlias

lst = []
class X:
    def __repr__(self):
        lst.clear()
        return "x"

lst += [X(), 1]
ga = GenericAlias(int, lst)
try:
    repr(ga)
    print("no exception")
except IndexError as e:
    print("IndexError:", e)
