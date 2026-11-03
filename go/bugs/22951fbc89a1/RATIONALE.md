# Rationale

Changed: `src/cmd/compile/internal/types2/return.go`, `isTerminating`, `case *syntax.ForStmt`.

Fix hunk reversed: the fix added an early `break` when `s.Init` is a `*syntax.RangeClause`, so range loops are never terminating statements. In go1.27.3 the same code is still present (only the comment URL differs). I removed that check, which restores the pre-fix behaviour: `for range s {}` with no condition and no break is treated as terminating.

Oracle: `test/fixedbugs/issue49003.go` fails with "compilation succeeded unexpectedly". The expected "missing return" error is no longer reported. `TestShouldTest` still passes.
