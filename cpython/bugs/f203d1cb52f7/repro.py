class Spam:
    def __new__(cls, x, y):
        pass
obj = Spam.__dict__['__new__']
try:
    del obj.__annotations__
except AttributeError as e:
    print("AttributeError", e)
print(repr(obj.__annotations__))
