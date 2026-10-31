import warnings

@warnings.deprecated("MyMeta will go away soon")
class MyMeta(type):
    def __new__(mcs, name, bases, attrs, cls=None):
        print("cls =", repr(cls))
        return super().__new__(mcs, name, bases, attrs)

warnings.simplefilter("ignore")
try:
    class Foo(metaclass=MyMeta, cls='haha'):
        pass
except TypeError as e:
    print("TypeError:", e)
