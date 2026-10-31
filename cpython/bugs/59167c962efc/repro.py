import inspect

class D:
    def __init__(self, a, b): pass
print(inspect.signature(D))
