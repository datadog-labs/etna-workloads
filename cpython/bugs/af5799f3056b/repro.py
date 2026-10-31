from annotationlib import ForwardRef, Format
fr = ForwardRef("set[undefined]")
r = fr.evaluate(format=Format.FORWARDREF)
print(repr(r))
