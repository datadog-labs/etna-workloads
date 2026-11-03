# Rationale (golang/go#53456)

Changed `mapKeyTemp` in src/cmd/compile/internal/walk/order.go back to the pre-fix behaviour:

- Removed the `HasUniquePos(n)` choice; `pos := n.Pos()` is always used, so an ONAME key
  (shared node) donates its position to the generated OCONV/OCONVNOP/deref nodes. This reverses the
  `pos := outerPos; if ir.HasUniquePos(n) {...}` hunk and the three `n.Pos()` -> `pos` hunks.
- The temp-assignment uses `base.Pos` again (as before the fix) instead of `pos`.
- The `outerPos` parameter and callers are left in place (unused), which is behaviourally equal to the old signature.

Effect: map-key conversions get the line of the variable's declaration, so line-number
(is_stmt) sequences in `s.m[key]` get wrong lines; TestDebugLines_53456 style checks
(b53456.go, `(*T).Inc`, expecting 15,16,17,18) are what guard it.

## Oracle result
`./check.sh`: 9 of 2350 oracle cases fail: TestDebugLines_53456 (the fix's test), plus
TestDebugLinesConvert/Pushback/SayHi, TestInlineLines and TestDebugLines_74576*.
Caveat: the sandbox emits "go: warning: ignoring go.mod in system temp root /tmp/claude-2000" on stderr,
which by itself makes the debug-lines tests fail on "Wanted empty stderr" (as seen for 74576*), so those
failures are probably environmental and not evidence of the bug. I did not run a baseline without the change.
