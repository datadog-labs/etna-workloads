# Rationale

Fix (issue 57778) added `ir.EditChildrenWithHidden` and switched static-init inlining
(`staticinit/sched.go`, the `edit` closure that substitutes parameters) to use it, so that
hidden RType fields (`mknode:"-"`) also get dictionary parameters substituted.

In go1.27.3 the helper still exists, so the revert is one line in
`src/cmd/compile/internal/staticinit/sched.go`: `ir.EditChildrenWithHidden(x, edit)` ->
`ir.EditChildren(x, edit)`. This reverses the fix's sched.go hunk exactly; the ir hunks remain
(unused helper), as before the fix's callers existed.

Oracle: test/fixedbugs/issue57778.go fails with
`internal compiler error: 'init': value .dict (nil) incorrectly live at entry`,
since the unsubstituted dictionary parameter leaks into the inlined init code.
