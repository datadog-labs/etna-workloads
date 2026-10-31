import weakref
from typing import TypeVar, ParamSpec, TypeVarTuple
P = ParamSpec('P')
for name, obj in [('TypeVar', TypeVar('T')), ('ParamSpec', P), ('args', P.args),
                  ('kwargs', P.kwargs), ('TypeVarTuple', TypeVarTuple('Ts'))]:
    try:
        weakref.ref(obj)
        print(name, 'ok')
    except TypeError as e:
        print(name, 'TypeError', e)
