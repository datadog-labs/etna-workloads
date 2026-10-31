# Rationale

Hunk reversed: `ForwardRef.evaluate` (Lib/annotationlib.py), the non-identifier branch.
The fix added a second evaluation attempt in FORWARDREF format using a
`_StringifierDict` so that partially-defined expressions (e.g. `set[undefined]`)
evaluate to `set[ForwardRef('undefined')]`, with `transmogrify()` afterwards.
I removed that retry: if plain `eval` fails in FORWARDREF format, the method now
just returns `self` (the whole ForwardRef stays unresolved), which is the
pre-fix "FORWARDREF succeeds less often" behaviour.

Oracle cases failing: `TestForwardRefClass.test_evaluate_forwardref_format`
(`set[undefined]` returns a ForwardRef instead of `set[ForwardRef]`) and
`TestForwardRefClass.test_evaluate_undefined_generic`.
