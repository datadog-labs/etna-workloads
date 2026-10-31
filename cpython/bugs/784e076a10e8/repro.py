class C:
    def __init__(self):
        self.__dict__.clear()

obj = C()
print(repr(obj.__dict__))
obj.foo = None
print(repr(obj.__dict__))
