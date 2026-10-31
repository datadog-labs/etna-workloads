from annotationlib import get_annotations, Format

class C:
    x: global_alias[int]

evaluated = get_annotations(C, format=Format.FORWARDREF)["x"].evaluate(format=Format.FORWARDREF)
global_alias = list
print(repr(evaluated.evaluate()))
