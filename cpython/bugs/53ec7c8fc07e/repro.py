import annotationlib
from dataclasses import dataclass

try:
    @dataclass(slots=True, init=False)
    class F:
        x: int
    f = F()
    f.x = 10
    print(f.x, hasattr(F.__init__, "__annotate__"))
except Exception as e:
    print(type(e).__name__, e)

@dataclass
class C:
    "doc"
    x: int

C.__annotate__ = lambda _: {}
try:
    print(annotationlib.get_annotations(C.__init__))
except Exception as e:
    print(type(e).__name__, e)
