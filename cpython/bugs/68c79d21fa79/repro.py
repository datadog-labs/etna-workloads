import inspect
print(inspect.unwrap(staticmethod) is staticmethod)
print(inspect.unwrap(classmethod) is classmethod)
print(inspect.unwrap(staticmethod(classmethod)) is classmethod)
