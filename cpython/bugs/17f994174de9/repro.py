class WeirdMapping(dict):
    def __missing__(self, key):
        if key == "T":
            raise RuntimeError
        raise KeyError(key)

class Meta(type):
    def __prepare__(name, bases):
        return WeirdMapping()

try:
    class MyClass[V](metaclass=Meta):
        class Inner[U](T):
            pass
except RuntimeError:
    print("RuntimeError")
