repro.py creates `_testcapi.ManagedDictType()` (an extension type with a managed dict), sets `obj.__dict__ = {'bar': 3}`, then reads `obj.bar`.

Clean: prints `{'foo': 42}`, `{'bar': 3}`, `3`.
Buggy: the injected `PyObject_GenericSetDict` writes through `_PyObject_GetDictPtr` rather than `_PyObject_SetDict`, so the new dict isn't used for attribute lookup. `obj.bar` raises AttributeError (exit status 1).

I ran both interpreters directly. `./check.sh` fails in this sandbox with a bwrap error about a missing `.claude/launch.json`, so I didn't get its comparison.
