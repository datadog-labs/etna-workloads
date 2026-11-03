# Rationale

Fix (cl/465098): in `staticAssignInlinedCall`, skip blank params when building the
`args` substitution map. Otherwise the blank node, mapped to the arg, is substituted for
other blank nodes on the LHS of assignments in the substituted body (e.g. the inner
inlined call's `_ := S2{}`), producing an invalid IR node and an ICE.

## Changes
1. `staticinit/sched.go`: removed the `if ir.IsBlank(v) { continue }` in the `args` loop
   (direct reversal of the fix hunk). Alone this no longer reproduces: since
   `ir.Func.DeclareParams` renames blank/unnamed params to `~pN`, inlined params are never
   blank, so the guard was dead.
2. `noder/reader.go` (inlining reader, `inlvars`): for ordinary inlined calls (not synthetic
   bodies or generic wrappers, which refer to the `~pN` Dcl names), unnamed/blank params
   use the shared `ir.BlankNode` as their inline variable again. This is how blank
   params looked when the bug existed, and is the "other path" that now covers the case.
   The existing `ir.IsBlank(name)` skip of the ODCL then applies as before.

## Oracle
`test/fixedbugs/issue58325.go` fails: `internal compiler error: panic: interface
conversion: ir.Node is *ir.CompLitExpr, not *ir.Name` (the blank receiver's `S1{}` is
substituted into `_ := S2{}`). Std still builds.
