@staticmethod
def f(x) -> int: pass
print('__annotations__' in f.__dict__)
print(f.__annotations__)
print('__annotations__' in f.__dict__)
