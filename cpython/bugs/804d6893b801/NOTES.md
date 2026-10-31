repro.py calls types.GenericAlias(bad=float). Clean raises TypeError (prints message); buggy build hits assert in _PyArg_NoKwnames (kwds is a dict, not tuple) and aborts (SIGABRT).
