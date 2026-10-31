from collections import Counter

c = Counter()
key = object()

class Evil(int):
    def __add__(self, other):
        c.clear()
        return NotImplemented

c[key] = Evil()
c.update([key])
print(repr(c[key]))
