import annotationlib
from typing import Annotated, get_origin

def f(x: Annotated[undefined, '']): pass

ann = annotationlib.get_annotations(f, format=annotationlib.Format.FORWARDREF)
x = ann['x']
print(get_origin(x) is Annotated)
print(x.__origin__.__forward_arg__, x.__origin__.__owner__ is f)
print(repr(x.__metadata__))
