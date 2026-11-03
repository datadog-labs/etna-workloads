# Rationale

Fix: dec.rules shortcuts `(StructSelect x)`, `(ArraySelect [0] x)`, `(ArrayMake1 x)`, `(StructMake x)` used `x.Type.IsPtr()` instead of `IsPtrShaped()`, so struct{map}/[1]chan/etc. were not collapsed.

## Changes
1. `_gen/dec.rules` + `rewritedec.go`: the four conditions changed back from `IsPtrShaped()` to `IsPtr()` (reverses all four fix hunks; same condition as the pre-fix code).
2. Reverting only (1) does not reproduce the bug on go1.27.3, because the later rule `(IMake _typ (StructMake ___)) => imakeOfStructMake(v)` (dec.rules and generic.rules, hand-edited in rewritedec.go / rewritegeneric.go) unwraps the one-field struct before an immediate interface is built. I removed that rule in both files; it covers the same case (immediate-interface wrapping of a pointer-shaped one-field struct) via a different path. The ArrayMake1 IMake rule is untouched.

## Oracle
`test/fixedbugs/issue63505.go` fails: `internal compiler error: 'init.0': not lowered: v6, StructMake STRUCT MAP`.
