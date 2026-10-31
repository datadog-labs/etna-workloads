from annotationlib import get_annotations, Format

def make():
    class A:
        def one(_) -> C1:
            pass
        def two(_) -> C1 | C2:
            pass
        one1 = get_annotations(one, format=Format.FORWARDREF)["return"]
        one2 = get_annotations(one, format=Format.FORWARDREF)["return"]
        two1 = get_annotations(two, format=Format.FORWARDREF)["return"]
        two2 = get_annotations(two, format=Format.FORWARDREF)["return"]
    type C1 = None
    type C2 = None
    return A

A = make()
for name, r1, r2 in (("one", A.one1, A.one2), ("two", A.two1, A.two2)):
    print(name, r1 == r2)
    try:
        print(name, hash(r1) == hash(r2))
    except TypeError as e:
        print(name, "TypeError", e)
