import warnings
from warnings import deprecated

@deprecated("A will go away soon")
class A:
    pass

class B:
    def __init_subclass__(cls, x):
        super().__init_subclass__()
        cls.inited = x

warnings.simplefilter("ignore")
for bases in [(A, B), (B, A)]:
    try:
        C = type("C", bases, {}, x=42)
        print(repr(C.inited))
    except Exception as e:
        print(type(e).__name__, e)
