def make_special_dict():
    class A:
        pass
    a = A()
    a.a = 1
    a.b = 2
    d = a.__dict__.copy()
    del d['a']
    del d['b']
    d['b'] = "value"
    return d

class NoInlineAorB:
    pass
for i in range(ord('c'), ord('z')):
    setattr(NoInlineAorB(), chr(i), i)

c = NoInlineAorB()
c.a = 0
c.b = 1

def f(o, n):
    for i in range(n):
        o.b = i
f(c, 100)

test_obj = NoInlineAorB()
test_obj.__dict__ = make_special_dict()
print(test_obj.b)
f(test_obj, 1)
print(test_obj.b)
