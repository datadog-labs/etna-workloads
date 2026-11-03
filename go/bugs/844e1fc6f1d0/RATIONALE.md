# Rationale

Fix hunk: typecheckaste jumped to `invalidddd` when `...` was passed to a non-variadic
function, before the argument-count check. The old typechecker is gone; the equivalent in
go1.27.3 is `Checker.arguments` in `src/cmd/compile/internal/types2/call.go`, in the
`else` (non-variadic) branch, which reports "cannot use ... in call to non-variadic" and returns.

Change: removed that `if ddd { errorf; return }` block, so a `...` call to a non-variadic
function falls through to the argument-count check (the pre-fix behaviour: the `...` check is
skipped and count mismatches are reported instead).

Oracle: test/fixedbugs/issue45913.go fails. `f([2]string{"a","b"}...)` now yields
"not enough arguments in call to f" instead of the invalid-use-of-`...` error.
(test/ddd1.go still passes; its expectations are met by other errors.)
