# Rationale

Fix: gh-101293 (inspect.Signature.from_callable with custom callables/descriptors).

Changed only `_signature_get_user_defined_method` in `Lib/inspect.py`:

- The fix replaced `getattr(cls, name)` with `getattr_static` for everything except `__new__`.
  Reverted: `getattr(cls, method_name, None)` is used for all names again (the pre-fix lookup).
- The fix added `meth = _descriptor_get(meth, cls)` for non-`__new__` methods, which
  binds the statically-found attribute. Removed, since the plain `getattr` already
  runs descriptors (the pre-fix behaviour). `_descriptor_get` is still used by the
  `__call__`-on-instance path, left unchanged.

The v3.15.2 additions (`follow_wrapper_chains`, unwrap handling) are unrelated and kept.

## Failing oracle cases
11 failures in test_inspect, in the new tests for classes with `__init__` / metaclass
`__call__` / instance `__call__` set to classmethod, partialmethod, etc. Example:
a classmethod/partialmethod `__init__` or metaclass `__call__` now yields a signature
including `self`, or the wrong one, instead of `(b)` / `(a)`.
