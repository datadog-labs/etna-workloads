# Rationale

Fix: PR#5332 (GADT pattern matching, Jacques Garrigue, 2011-08-09).

## Hunk changed: ocaml/typing/parmatch.ml, `list_satisfying_vectors`
(the `Construct _` branch of the non-full-match case)

The fix hunk `@@ -1060,7 +1063,7 @@ let combinations f lst lst'` changed
`iter2 x lst'` to `iter2 x lst' @ iter xs`. The old code kept only the combinations
for the first element and dropped the rest. The `combinations` function and
`build_other_gadt` no longer exist in 5.5. Their job is now done by
`build_other_constrs`, which returns an or-pattern of the missing constructors,
and by `list_satisfying_vectors`, which uses that or-pattern as a witness.
The change keeps only the first alternative of that or-pattern. It does so only when
the second alternative is a GADT constructor with arguments, so the rest of the
alternatives are lost. The compiler then reports `Tint, Tvar Zero`-style
refutations as unreachable. The same applies to the extra alternatives in
`(Tint, Tbool | Tvar _)`. The `_ -> .` case in pr5332.ml is accepted without
the "could not be refuted" error.

The other hunks of fix.diff are not reversed. They are tests, a debug comment
(`build_other_gadt`, `pats` binding) and formatting in `Conv`.

Several narrower or broader variants broke the compiler's own build (false
unreachable-case warnings in types.ml etc.), so the condition above is
what keeps the bootstrap working.

## Commands
`make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
pr5332.ml => failed (expected error missing), test.ml => passed.
