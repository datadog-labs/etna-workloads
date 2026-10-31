from annotationlib import get_annotations, Format

class C:
    x: alias[int, undef]

g = get_annotations(C, format=Format.FORWARDREF)["x"].evaluate(
    format=Format.FORWARDREF, globals={"alias": dict})
print(repr(g))
