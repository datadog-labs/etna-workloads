import collections
class MyEG(ExceptionGroup):
    pass
excs = [ValueError(1), TypeError(2)]
eg = MyEG('test', excs)
print(repr(eg))
excs.clear()
print(repr(eg))
print(eg.args)
d = collections.deque([ValueError(1), TypeError(2)])
eg = ExceptionGroup('test', d)
d.clear()
print(repr(eg))
