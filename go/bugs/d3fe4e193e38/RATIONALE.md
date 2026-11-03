# Rationale (issue 51437: range-clause scoping)

Only file changed: `tree/src/cmd/compile/internal/types2/range.go` (`rangeStmt`).
In go1.27.3 the range logic lives here, not in `stmt.go`, and `stmt.go`'s ForStmt case no longer opens the scope for range loops.

- Fix hunk "open scope in ForStmt before the range branch / move it after the range clause":
  reversed by opening the scope at the top of `rangeStmt`, before the range expression is checked,
  and removing the later `openScope(..., "range")`. Iteration variables are then declared in a scope that
  is already visible while the range expression (e.g. a func literal) is checked.
- Fix hunk `scopePos := s.Body.Pos()`: reverted to `syntax.EndPos(rangeVar)` (the old `EndPos(rclause.X)`).

## Oracle failures
`TestFixedbugs` and `TestFixedbugs/issue51437.go` in types2 fail. The test is the func-literal range
expression that uses `x` (the parameter) while the range clause redeclares `x`.
