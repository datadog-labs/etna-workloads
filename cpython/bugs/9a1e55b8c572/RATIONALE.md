# Rationale

Hunk reversed: `Lib/importlib/util.py`, `_LazyModule.__getattribute__`. The fix
changed the reentrancy guard from
`if loader_state['is_loading'] and attr.startswith('__') and attr.endswith('__')`
to plain `if loader_state['is_loading']`. I restored the dunder-only condition
and the old comment. The surrounding code (`__class__.__getattribute__`) is
unchanged, so the code is otherwise equivalent to pre-fix.

Effect: during a load, a reentrant non-dunder attribute access from the same
thread (e.g. `json/__init__.py` importing `.decoder`, which accesses `json.X`)
triggers the load again instead of returning.

Failing oracle case: `test_lazy_self_referential_modules`. It fails with
ImportError (circular import, `cannot import name 'JSONDecoder' from partially
initialized module 'json.decoder'`). The other 14 cases pass.
