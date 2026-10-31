repro.py tries weakref.ref() on TypeVar, ParamSpec, ParamSpec.args/.kwargs and TypeVarTuple. Clean: all succeed. Buggy: each raises TypeError (the injection removes weakref support from these types).
