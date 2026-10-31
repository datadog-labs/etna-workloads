from annotationlib import get_annotations, Format

def f(x: range[1]):
    pass

try:
    f.__annotations__
except TypeError as e:
    print("TypeError:", e)

print({k: v.__forward_arg__ for k, v in get_annotations(f, format=Format.FORWARDREF).items()})
