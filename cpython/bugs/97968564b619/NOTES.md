`copy.replace()` on a SimpleNamespace subclass whose `__new__` returns an int.
Clean: raises TypeError "expect types.SimpleNamespace type, but ...MyNS() returned 'int' object".
Buggy: the type check is missing, so `namespace_replace` treats the int as a namespace (crash/assert or garbage).
