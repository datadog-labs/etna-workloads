class X:
    def __hash__(self):
        return 0
class Y:
    flag = False
    def __hash__(self):
        return 0
    def __eq__(self, other):
        if not self.flag:
            self.flag = True
            s.add(X())
        return self is other

a = X()
s = set()
s.add(a)
s.add(X())
s.remove(a)
s.add(Y())
print(len(s))
print(len(repr(s)))
print(len(list(s)))
print(len(set() | s))
