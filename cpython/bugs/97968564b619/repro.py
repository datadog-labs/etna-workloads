import copy, types

class MyNS(types.SimpleNamespace):
    def __new__(cls, *args, **kwargs):
        if created:
            return 12345
        return super().__new__(cls)

created = False
ns = MyNS()
created = True
try:
    copy.replace(ns)
except TypeError as e:
    print(type(e).__name__, e)
