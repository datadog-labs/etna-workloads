import sys

class Unhashable(str):
    __hash__ = None

def f(obj):
    x = 1
    proxy = sys._getframe().f_locals
    try:
        proxy[obj] = 0
    except TypeError:
        print('TypeError')
    else:
        print('no error')

f(Unhashable('x'))

class StrSub(str):
    pass

def g(obj):
    x = 1
    proxy = sys._getframe().f_locals
    proxy[obj] = 2
    return list(proxy.keys())

print(g(StrSub('x')))
