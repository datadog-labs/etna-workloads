# Rationale

Fix hunk: in `typecheck/iimport.go` `typAt`, add `types.CheckSize(t)` after reading an imported type, so imported types have their size calculated during typechecking (not later during SSA, when CalcSize is disabled).

In go1.27.3 the iimport reader is gone; imports go through the unified IR reader (`noder/reader.go`). The equivalent code is the tail of `(*reader).typWrapped`, which calls `types.CheckSize(typ)` on every non-untyped type read from export data. I removed that call (`noder/reader.go`), restoring the pre-fix state where imported types may lack a computed size.

Oracle: `test/fixedbugs/issue44732.go` (runindir; imports foo.Foo with a func field via bar) now fails (2 of 2 oracle cases, including TestShouldTest) under `./check.sh`.
