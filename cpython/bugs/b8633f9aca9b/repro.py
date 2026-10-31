import inspect, functools
from warnings import deprecated

def identity(func):
    @functools.wraps(func)
    def wrapped(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapped

class Foo:
    @identity
    def __new__(cls, a, b):
        pass

print(inspect.signature(Foo))

class Cls:
    def __init__(self, x, y):
        pass

print(inspect.signature(Cls))
print(inspect.signature(deprecated("depr")(Cls)))
