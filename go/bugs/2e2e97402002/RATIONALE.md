# Rationale

Changed: `tree/src/cmd/compile/internal/types2/instantiate.go`, `Instantiate`.

The fix hunk replaced `assert(len(tparams) > 0)` with an error return for
non-generic types. In go1.27.3 the check already returned an error, but with a
different message ("cannot instantiate non-generic ..."), so the hunk could not
be reversed directly. I put the pre-fix `assert(len(tparams) > 0)` back in place
of that `if len(tparams) == 0 { return nil, fmt.Errorf(...) }` block.

Calling `Instantiate(..., validate=true)` on a non-generic type now panics with
an assertion failure instead of returning an error. The go/types copy is
outside the compile tree, so I did not touch it.

Oracle: TestIssue72978 fails because `Instantiate` panics on the `G1` case. The
panic aborts the test binary, so the other tests that run after it
(TestObjectString, TestSelf and so on) are reported failing too.
