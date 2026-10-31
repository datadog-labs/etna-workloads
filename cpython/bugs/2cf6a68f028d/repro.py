import annotationlib

def f(x: int): pass
f.__wrapped__ = f
print(annotationlib.get_annotations(f, eval_str=True))
