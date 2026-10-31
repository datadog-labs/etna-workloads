# Rationale

Fix gh-110519 made the gettext DeprecationWarning for non-integer plural values point at user code, by computing the stacklevel dynamically and adding `__name__` to the `exec` namespace. v3.15.2 has this logic in `_as_int2` (split out of `_as_int`), so the fix hunks don't reverse cleanly. I changed `Lib/gettext.py` to the pre-fix behaviour in two places:

- `_as_int2`: removed the frame-walking loop (the fix's `frame`/`stacklevel` hunk) and restored `warnings.warn(..., DeprecationWarning, 4)`. The hardcoded 4 only suits the `c2py` path through `_as_int`. For `NullTranslations.ngettext`/`npgettext`, and when `_as_int` is called from the translated `func`, the warning is attributed to a line in gettext.py or to the wrong frame.
- `c2py`: restored `ns = {'_as_int': _as_int}` (reverses the `'__name__': __name__` hunk).

The `operator` import is still needed by `_as_int2`'s `operator.index`, so I left it.

Result: 13 oracle cases fail. They are the `_test_plural_forms` tests, which assert `cm.filename == __file__`. The actual filename is `Lib/gettext.py`.
