class pro(property):
    def __new__(typ, *args, **kwargs):
        return "abcdef"

p = property.__new__(pro)
print(repr(p.getter(None)))
