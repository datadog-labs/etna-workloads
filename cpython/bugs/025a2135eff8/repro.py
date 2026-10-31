import inspect, functools

def identity_wrapper(func):
    @functools.wraps(func)
    def wrapped(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapped

class C:
    @classmethod
    @identity_wrapper
    def __init__(cls, b):
        pass

print(inspect.signature(C))
