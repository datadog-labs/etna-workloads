Reproducer: translation of test_issubclass_refcount_handling (bpo-39382).
issubclass(B(), int) walks a single-inheritance chain of objects whose
`__bases__` properties build fresh tuples/objects. The injected bug drops the
`bases` tuple reference before `derived` (borrowed from it) is used, giving a
use-after-free (and a leak when derived == cls). Clean prints `True`; buggy
differs (crash/assert/wrong result) per check.sh.
