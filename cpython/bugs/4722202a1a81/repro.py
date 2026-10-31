import traceback

class M(type):
    def __dir__(cls):
        return [None, "fox"]

class C0:
    def __dir__(self):
        return [..., "bluch"]

class C1(C0, metaclass=M):
    pass

def sug(obj, name):
    try:
        getattr(obj, name)
    except AttributeError as e:
        return "".join(traceback.TracebackException.from_exception(e).format_exception_only())

print(sug(C0, "blach"))
print(sug(C0(), "blach"))
print(sug(C1, "foo"))
print(sug(C1(), "foo"))
