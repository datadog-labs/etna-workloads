from enum import IntFlag
class F(IntFlag):
    def __new__(cls, c):
        value = 1 << c
        self = int.__new__(cls, value)
        self._value_ = value
        return self
    a = ord('a')
try:
    print(repr(F.a | 1))
except Exception as e:
    print(type(e).__name__, e)
