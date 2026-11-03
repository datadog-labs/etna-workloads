# Rationale

Fix: go/types, types2 "use exact unification for component types" (#60460).

In go1.27.3 most of the fix is still present (assign/exact modes, exact checks
for Named/Chan/literal handling, `assign` passed from infer.go). The one piece
I reverted is in `src/cmd/compile/internal/types2/unify.go`, `nify`:

    emode := mode
    if mode&assign != 0 { emode |= exact }   // removed

This reverses the hunk that added `emode |= exact` in assign mode. Without it,
element types (func params/results, slice/map/chan elems, pointer bases, struct
fields) are unified inexactly again, even when unifying parameter vs argument
types. That restores the pre-fix behaviour: defined-vs-literal, channel
direction and interface unification are allowed for component types, which
causes the infinite recursion of #60460 (hits the unification depth limit,
and `panicAtUnificationDepthLimit` is true in this tree, so it panics).

## Oracle failures
`TestFixedbugs/issue60460.go`, `TestExamples/functions.go` (channel direction
errors differ), `issue60377.go`, `issue59740.go` and others fail; the depth limit
panic also aborts the test binary, so many later cases fail too.
