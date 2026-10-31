from annotationlib import get_annotations, Format

def f(x: some.module, y: some[module]):
    pass

for k, v in get_annotations(f, format=Format.FORWARDREF).items():
    print(k, type(v).__name__, v.__forward_arg__ if hasattr(v, "__forward_arg__") else repr(v))
