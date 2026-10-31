# Rationale

Changed: `Lib/annotationlib.py`, `ForwardRef.evaluate`.

Fix hunks reversed: the fix stopped copying `globals` to inject type params
(`globals = dict(globals)`) and used a separate `type_param_scope` instead.
In v3.15.2 type params were instead injected into `locals` via `setdefault`.
I restored the old approach: when `type_params is not None`, copy `globals`
and add the type params to the copy. This replaces the `locals.setdefault` loop.

Why this is the bug: classes have `__type_params__ == ()`, which is not
`None`, so `globals` is snapshotted. The `_Stringifier` ForwardRefs created in
the FORWARDREF fallback keep that snapshot. A name defined in the real module
globals after the first evaluation is therefore never seen on re-evaluation.

Oracle case failing: `TestForwardRefClass.test_re_evaluate_generics`. After
`global_alias = list`, `evaluated.evaluate()` raises or returns a ForwardRef
instead of `list[int]`. The other 119 cases still pass.
