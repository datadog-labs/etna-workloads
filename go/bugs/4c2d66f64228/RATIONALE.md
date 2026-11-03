# Rationale

Fix (CL 277713) part: issue #6428 — a struct-literal key (`S{T: 0}`) must not count as a
use of a dot-imported identifier `T`, so `import . "testing"` is reported "imported and not used".
The old compiler resolved the key ident through the dot-import and marked the package used;
the fix (typecheckcomplit hunk + checkDotImports) stopped that.

Change: `src/cmd/compile/internal/types2/literals.go`, struct-literal key loop. Added a lookup of the
key name in scope and, if it is a dot-imported object, mark `check.usedPkgNames[pkgName]`
(the same marking `Checker.ident` does). This reintroduces the pre-fix behaviour where a field key
spuriously counts as a use of the dot import.

Oracle failure: `test/fixedbugs/issue6428.go` fails with "compilation succeeded unexpectedly"
(expected error `imported and not used` is no longer reported).
