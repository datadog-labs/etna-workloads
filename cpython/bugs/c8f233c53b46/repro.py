from annotationlib import get_annotations, Format
def f(x: undef1[str, undef2]):
    pass
print(get_annotations(f, format=Format.STRING))
fwd = get_annotations(f, format=Format.FORWARDREF)["x"]
print(repr(fwd.evaluate(globals={"undef1": dict, "undef2": float})))
