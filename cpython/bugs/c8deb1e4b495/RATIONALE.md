# Rationale

Fix hunk reversed: in `push_inlined_comprehension_state` (now
`_PyCompile_TweakInlinedComprehensionScopes` in Python/compile.c) the fix moved
the "name has different scope inside than outside the comprehension" handling
(temp_symbols save/override) out of the `DEF_LOCAL && !DEF_NONLOCAL` / class-block
guard, so it applies to every name in the comprehension's symbols.

Change: the scope-override `if` is again additionally guarded by
`(symbol & DEF_LOCAL && !(symbol & DEF_NONLOCAL)) || in_class_block`, as before
the fix. A name that is only read (implicit global) in a comprehension no longer
gets its scope overridden, so the enclosing function's scope for `x` (local,
because a sibling comprehension binds it) leaks into it -> LOAD_FAST instead of LOAD_GLOBAL.

Oracle failure: `test_multiple_comprehension_name_reuse` (scope='function') fails with
`UnboundLocalError: cannot access local variable 'x'`, matching the NEWS entry.
