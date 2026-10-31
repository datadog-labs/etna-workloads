# Rationale

Fix hunk (Python/compile.c, `push_inlined_comprehension_state`): removed the
`if (outsc == LOCAL || outsc == CELL || outsc == FREE)` guard around isolating
comprehension-bound names (LOAD_FAST_AND_CLEAR / MAKE_CELL / pushed_locals).

Changed: `codegen_push_inlined_comprehension_locals` in Python/codegen.c, where
that logic now lives. I restored the guard. In v3.15.2 the outer symbol table is
already overridden by `_PyCompile_TweakInlinedComprehensionScopes` before this
function runs, so `outsc` would be read post-tweak; to match the original
pre-tweak `outsc`, I read the original outer symbol back from
`state->temp_symbols` (where the tweak saves it) when present.

Oracle failure: `test_no_leakage_to_locals` fails. With the outer name `b` global
in the enclosing function, it is no longer isolated, so the comprehension's `b`
leaks into the outer `locals()` (`['b'] != []`).
