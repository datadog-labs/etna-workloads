from annotationlib import get_annotations, Format

def f():
    class Demo:
        nonlocal sequence_b
        x: sequence_b
        y: sequence_b[int]

    fwdrefs = get_annotations(Demo, format=Format.FORWARDREF)
    sequence_b = list
    print(repr(fwdrefs["x"].evaluate()))
    print(repr(fwdrefs["y"].evaluate()))
    sequence_b = None

f()
