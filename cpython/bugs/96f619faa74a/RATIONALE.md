# Rationale

The fix wrapped `_BASE_GET_ANNOTATE(obj)` in `get_annotate_function()` with
`except AttributeError: return None`, because the type descriptor raises
AttributeError for static types (`object`, `int`). In v3.15.2
`get_annotate_function` and `_BASE_GET_ANNOTATE` no longer exist. The same
defect is in `_get_dunder_annotations()` in `Lib/annotationlib.py`, which
handles static types in the same way (`_BASE_GET_ANNOTATIONS` descriptor
raising AttributeError).

## Change
`Lib/annotationlib.py`, `_get_dunder_annotations`: removed the
`try/except AttributeError: return None` around `_BASE_GET_ANNOTATIONS(obj)`.
This reverses the fix's hunk, which added that guard for static types.

## Failures
`./check.sh`: test_typing fails with 30 errors, including
`test_get_type_hints_generic`. `get_type_hints` calls
`annotationlib.get_annotations(object)`, which raises
`AttributeError: type object 'object' has no attribute '__annotations__'`.
Static types such as `object` and `int` hit the same error in
`get_annotations`.
