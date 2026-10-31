class C:
    pass
class D:
    pass
d = C.__dict__['__dict__']
print(d.__objclass__)
print(D.__dict__['__dict__'] is d)
print(d)
w = C.__dict__['__weakref__']
print(w.__objclass__, D.__dict__['__weakref__'] is w)
