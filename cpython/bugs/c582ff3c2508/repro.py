created = frozendict(x=1)
class Sub(frozendict):
    def __new__(self, *args):
        return created

fd = Sub.fromkeys("abc")
print(repr(fd), type(fd).__name__)
print(repr(created))
