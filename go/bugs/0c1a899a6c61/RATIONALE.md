# Rationale

Go 1.27.3 no longer has `typecheck.lookdot`. Method selection is checked by types2, in `lookupFieldOrMethod` (`src/cmd/compile/internal/types2/lookup.go`). That function discards a method found through a defined pointer type's underlying pointer.

## Change
In `lookupFieldOrMethod`, the discard now applies only when the defined pointer type is declared in the package block (`t.Obj().Parent() == t.Obj().Pkg().Scope()`).

This reverses the fix hunk that replaced the old check
`ll.Type().Sym().Def != nil && ir.AsNode(ll.Type().Sym().Def).Op() == ir.OTYPE`
with a check that covers every defined pointer type. The old check only recognised defined pointers declared in the package block. Locally declared ones were missed (issue 43384). The restored condition has the same effect: local defined pointer types are no longer rejected.

I did not restore the other half of the old bug, where only the innermost selector or dereference was inspected. types2 has no equivalent code path for it.

## Oracle
`test/fixedbugs/issue43384.go` fails. The function-local types `P7` and `P8` (`*struct{T}` and `*struct{*T}`) now accept `p.Mv()`, `(&p).Mv()`, `(*&p).Mv()` and the `Mp` equivalents. The test's `// ERROR "undefined"` lines then report "missing error" (lines 96, 98, 102, 104, 111, 113, 117, 119). The package-level `P3` and `P4` cases still pass.
