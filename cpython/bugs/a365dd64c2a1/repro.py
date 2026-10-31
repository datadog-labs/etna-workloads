import copy

def state_setter(*args, **kwargs):
    print("state_setter called")

class C:
    def __reduce__(self):
        return C, (), self.__dict__, None, None, state_setter

x = C()
for f in (copy.copy, copy.deepcopy):
    try:
        print(f.__name__, repr(f(x)).split(" object")[0])
    except TypeError as e:
        print(f.__name__, "TypeError")
