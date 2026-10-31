import annotationlib
from annotationlib import Format

def annotate(format, /, __Format=Format, __NIE=NotImplementedError):
    if format == __Format.VALUE:
        return {"x": str}
    raise __NIE(format)

try:
    print(repr(annotationlib.call_annotate_function(annotate, Format.STRING)))
except BaseException as e:
    print(type(e).__name__, e)
