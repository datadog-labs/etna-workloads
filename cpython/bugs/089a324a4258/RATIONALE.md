# Rationale

Fix hunk reversed: `Lib/annotationlib.py` `ForwardRef.evaluate` type_params handling.

v3.15.2 injects type params with `locals.setdefault(name, param)`, which gives the
correct scoping. I restored the pre-fix code in its place: copy globals and locals, and for each
type param put it in `globals` (only if not `is_class` or name not already in globals) and pop
the name from `locals`. This brings back both defects: type params shadow class-scope names
(is_class=False), and in class mode a module-level name overrides a type param.

The `typing.py` hunks of the fix (`_add_type_params_to_scope`) are left as they are.

Failing oracle cases: `TestForwardRefClass.test_evaluate_with_type_params_and_scope_conflict`
(`TypeParamsAlias1` resolves to `int` instead of the type param) and 2 other
failures/errors in test_annotationlib (e.g. type-param evaluation tests).
