Reproducer: a Protocol with an annotation naming an undefined name (`x: DoesNotExist`), then `get_protocol_members`.
Clean: prints `frozenset({'x'})`. Buggy: `getattr(base, '__annotations__', {})` only swallows AttributeError, so NameError escapes.
