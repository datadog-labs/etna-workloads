import weakref

class MyConfig(dict):
    def __getattr__(self, x):
        return self[x]

obj = MyConfig(offset=5)
r = weakref.ref(obj)
try:
    print('MyConfig' in repr(r))
except BaseException as e:
    print(type(e).__name__, e)
