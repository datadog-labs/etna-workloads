# Rationale

Fix reversed: "defer transitive inlining until after AST is edited" (#54632).
The old inliner expanded the nested calls of an inlined body (`ir.EditChildren(res, edit)`)
inside mkinlcall, before the inlined call had been stored into the caller's AST.
In go1.27.3 inlining is driven by `inline/interleaved/interleaved.go`, which
already assigns `paren.X = inlinedCall` before marking/resolving nested calls.

Change (interleaved.go): new `inlClosureState.inline`, used in both the package-wide
loop and `fixpoint`. It marks the inlined body's calls, then immediately resolves and
inlines them (recursively), and only afterwards stores `paren.X = inlinedCall`. This is
the pre-fix order (transitive inlining before the AST edit). `ir.StaticValue`/`Reassigned`
then scan the caller body without the inlined body's reassignments, giving false positives
for indirect calls.

Oracle: test/fixedbugs/issue54632.go fails: bug1 inlined, `fn = pass` ... `fn()` in
bug2 (inlined into main) resolves to `fail`, so the program panics "FAIL".
TestShouldTest passes.
