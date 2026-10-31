from annotationlib import get_annotations, Format

def f(x: int):
    pass

class OnlyAnnotate:
    @property
    def __annotate__(self):
        return f.__annotate__

oa = OnlyAnnotate()
for fmt in (Format.VALUE, Format.FORWARDREF, Format.STRING):
    try:
        print(get_annotations(oa, format=fmt))
    except Exception as e:
        print(type(e).__name__, e)
