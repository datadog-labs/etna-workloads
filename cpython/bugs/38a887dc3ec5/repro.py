from collections import OrderedDict

class Key:
    count = 0
    def __hash__(self):
        return -1
    def __eq__(self, other):
        if Key.count == 1:
            d1.clear()
        Key.count += 1
        return True

d1 = OrderedDict.fromkeys((0, Key(), 4.2))
d2 = OrderedDict.fromkeys((0, Key(), 4.2))
try:
    print(repr(d1 == d2))
except RuntimeError as e:
    print("RuntimeError:", e)
print(len(d1), len(d2))
