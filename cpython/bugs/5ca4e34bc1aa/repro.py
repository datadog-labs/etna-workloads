import copy, pickle

class A:
    def f(self): return 'A'
class B(A):
    pass

b = B()
s = super(B, b)
c = copy.copy(s)
print(c is s)
d = copy.deepcopy(s)
print(type(d), d is s, d.__self__ is b)
print(type(c))
p = pickle.loads(pickle.dumps(s))
print(type(p), p.__thisclass__, type(p.__self__))
