import inspect
class D:
    def __get__(self, *_): pass
    def __delete__(self, *_): pass
print(inspect.ismethoddescriptor(D()))
