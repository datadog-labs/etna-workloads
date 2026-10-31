from typing import no_type_check

class C:
    @classmethod
    def cm(cls, x: int) -> int: ...
    @staticmethod
    def sm(x: int) -> int: ...
    def im(self, x: int) -> int: ...

no_type_check(C)
print(getattr(C.cm.__func__, '__no_type_check__', None))
print(getattr(C.sm, '__no_type_check__', None))
print(getattr(C.im, '__no_type_check__', None))
