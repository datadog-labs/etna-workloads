repro.py evaluates ForwardRefs whose owner is a generic class. Its type params are named like a
module global (TypeParamsAlias1) and a class attribute (TypeParamsAlias2).
Clean: the type param wins over the global, and the class attribute wins over the type param,
for both is_class=False and True.
Buggy: with is_class=False, the type param overrides the class attribute (TypeParamsAlias2 gives the TypeVar).
With is_class=True, the global `int` overrides the type param (TypeParamsAlias1 gives int), and
TypeParamsAlias2 still gives the TypeVar instead of `str`.
