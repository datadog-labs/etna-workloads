class Foo:
    def __bool__(self):
        raise NotImplementedError()

a = Foo()
b = Foo()

try:
    c = a or b
except NotImplementedError:
    print("caught")
