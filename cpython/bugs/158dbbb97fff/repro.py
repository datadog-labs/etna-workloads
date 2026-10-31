from annotationlib import get_annotations, Format

def f(a: unknown | str | int | list[str] | tuple[int, ...]): ...

fr = get_annotations(f, format=Format.FORWARDREF)['a']
print(repr(fr).split(", owner")[0])
print(fr.evaluate(format=Format.STRING))
