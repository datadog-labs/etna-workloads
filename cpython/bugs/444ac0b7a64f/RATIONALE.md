# Rationale

Reintroduces gh-118285 (wrong signatures of operator.attrgetter/itemgetter/methodcaller).

Changes (all in Lib/):
- `Lib/inspect.py`, `_signature_from_callable`: removed the `obj.__text_signature__` check for
  callable instances (reverses the inspect.py hunk). Instances of the C types
  (whose `common_getset` still provides `__text_signature__`) and any custom
  callable with `__text_signature__` now get the signature of `__call__` instead.
- `Lib/operator.py`: dropped the `/` markers from `attrgetter.__init__`, `__call__`,
  `itemgetter.__init__`, `__call__` and `methodcaller.__call__` (reverses the operator.py hunks).
  `methodcaller.__init__` already had `/` before the fix, so it is unchanged.

The C getset hunk in Modules/_operator.c was left alone; with the inspect change it is ignored.

Oracle: `./check.sh` -> 6 failures in test_operator (attr/item/methodcaller signature tests,
Py and C variants), e.g. `'(obj)' != '(obj, /)'`. The new inspect test
(`test_signature_on_callable_objects_with_text_signature_attr`) also fails.
