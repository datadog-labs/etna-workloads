import functools

class C:
    @functools.singledispatchmethod
    def generic(self, x: object):
        return "generic"

    @generic.register
    def special1(self, x: int):
        return "special1"

    @generic.register
    @staticmethod
    def special3(x: complex):
        return "special3"

for arg in ("foo", 1, 3j):
    try:
        print(repr(C.generic(C(), arg)))
    except Exception as e:
        print(type(e).__name__, e)
