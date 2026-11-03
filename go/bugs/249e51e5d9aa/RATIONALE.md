# Rationale

## Changed: src/cmd/compile/internal/staticinit/sched.go, staticAssignInlinedCall

The fix added a check that bails out when the inlined return expression contains a
non-trivial closure (which captures the param, so arg-for-param substitution is invalid).
In go1.27.3 this check exists as `hasClosure` (`clo.Func.IsClosure()`) plus
`if hasClosure { return false }`. I removed both, restoring the pre-fix loop that only
counts param uses. This is the same defect: closures capturing params get substituted.

## Oracle
test/fixedbugs/issue56778.go fails with
`internal compiler error: 'init': value a.i (nil) incorrectly live at entry`.
