class A:
    @property
    def __bases__(self):
        return (int, )

class B:
    def __init__(self):
        self.x = 1

    @property
    def __bases__(self):
        return (A(), )

print(repr(issubclass(B(), int)))
