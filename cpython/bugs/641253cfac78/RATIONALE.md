# Rationale

Change is in `Lib/traceback.py`, `_compute_suggestion_error`, NameError branch.

1. Fix hunk: `try: has_wrong_name = hasattr(self, wrong_name) / except Exception: has_wrong_name = False`
   -> reverted to a bare `if hasattr(self, wrong_name):`. A `__getattr__` that raises
   something other than AttributeError (e.g. ValueError) propagates out of the
   suggestion computation.

2. Other path covering the same case: in v3.15.2 the whole NameError branch is
   wrapped in `try: ... except Exception: return None`, which would swallow the
   exception from `hasattr` and hide the bug (the oracle test still passes, since
   `'spam'` is in the plain NameError message). I removed that wrapper (dedented
   the body, no logic change), restoring the pre-fix structure where the `hasattr`
   call was unguarded.

## Oracle failures
`test_unbound_local_error_with_side_effect` (CPythonSuggestionFormattingTests and
PurePythonSuggestionFormattingTests): `A().baz()` with `__getattr__` raising
ValueError('spam') now makes traceback formatting raise ValueError.

(Other failures in check output, `test_import_from_*`, are sandbox read-only-filesystem
errors unrelated to this change.)
