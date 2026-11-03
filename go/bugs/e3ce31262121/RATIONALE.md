# Rationale

Fix: closure struct fields were named after the captured variables (and `.F` in the captured vars' package) instead of generated `F`/`X<i>` names in LocalPkg.

## Changes
- `src/cmd/compile/internal/typecheck/func.go` `ClosureType`: reverses the func.go hunk. Restores the package computation from the ClosureVars, the `pkg.Lookup(".F")` field, and uses `n.Sym()` (the captured variable's symbol) as field name instead of `LocalPkg.LookupNum("X", i)`. (The loop now goes through `NewClosureStructIter`, as in current code, which yields the same variables.)
- `src/cmd/compile/internal/types/fmt.go` `fldconv`: reverses the fmt.go hunk, restoring the `.F` -> `F` name hack.

## Oracle
`test/fixedbugs/issue62498.go` fails: two closures from different packages capturing a variable `L` get closure structs that are not identical but have equal LinkStrings, giving
`internal compiler error: expected struct { F uintptr; L any } value to have type struct { F uintptr; L any }`.
