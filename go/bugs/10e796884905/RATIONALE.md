# Rationale

Fix hunk reversed: `regalloc.go` in `allocValToReg`. The fix added a check after rematerializing a value. If the requested register mask does not overlap the rematerialized op's output register mask (for example GP vs FP), it allocates the op's own output register and wraps the result in an `OpCopy`.

In go1.27.3 the same code exists, with `mask.intersect(sourceMask).empty()` in place of `mask&sourceMask == 0`. I deleted that whole block from the `v.rematerializeable()` branch. That branch is again just `c = v.copyIntoWithXPos(s.curBlock, pos)`, which is the pre-fix code. A rematerialized op can then land in a register class that its output spec doesn't allow.

I left the `func.go` `OwnAux` hunk (and the test-only hunks) unchanged. `OwnAux` is only support code for the test, not part of the bug.

Oracle result: `TestRematerializeableRegCompatible` fails ("Expects an Copy to be issued"). The `TestDebugLines*` and `TestInlineLines` failures come from the sandbox, not from this change. Those tests print "go: warning: ignoring go.mod in system temp root" to stderr.
