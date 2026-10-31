# Rationale

Fix: gh-132064 (annotationlib.get_annotations uses `__annotate__` if only it is present; raises TypeError for objects without annotations).

## Change (Lib/annotationlib.py, `_get_dunder_annotations`)
Reverses the fix hunk that changed `return {}` to `return None` (both the static-type AttributeError path and the `getattr(..., None) is None` path). The current `get_annotations` already contains the `ann is None` handling the fix added, so reverting the helper's sentinel alone restores the pre-fix behaviour: a missing `__annotations__` looks like an empty dict, so
- VALUE never falls back to `__annotate__`,
- FORWARDREF returns `{}` instead of calling `__annotate__`,
- the final `ann is None` -> TypeError path is never reached (objects with no annotations return `{}`).

## Failing oracle cases
test_functools `test_get_annotations_with_forwardref` / `test_get_annotations` for lru_cache wrappers (FORWARDREF gives `{}`); test_annotationlib `test_only_annotate` and `test_no_annotations` are expected to fail likewise.
