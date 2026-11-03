# Rationale

Fix hunk reversed: `types2/call.go` `Checker.selector` — the fix replaced `if x.mode == invalid` with a
`switch` that reports "cannot select on <builtin>" when the operand `x` of `x.sel` is a built-in.
In go1.27.3 this switch has the `case builtin:` error ("invalid use of %s in selector expression");
I removed that case, restoring the pre-fix `if x.mode() == invalid { goto Error }`.
Built-ins have an invalid type, so later errors are suppressed and `len.Println` is accepted silently.

Not changed: the index.go hunk (only an error position adjustment), and go/types (outside src/cmd/compile).

Oracle failing: `TestFixedbugs` and `TestFixedbugs/issue51360.go` (types2): the expected
"cannot select on len"-style errors for `len.Println` are no longer reported.
