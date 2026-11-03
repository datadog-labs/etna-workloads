# Rationale

## Hunk: src/cmd/compile/internal/ssagen/ssa.go, OSLICE2ARRPTR in (*state).expr
Reverses the fix hunk that changed the result type of `OpSlicePtrUnchecked` from
`types.Types[types.TINT]` to `n.Type()`. In go1.27.3 the code picks `op`
(OpSlicePtr, or OpSlicePtrUnchecked for zero-length arrays) and returns
`s.newValue1(op, n.Type(), v)`. I put back the original wrong type
(`types.Types[types.TINT]`) on that return, so the pointer-producing value is typed `int`
instead of `*[N]T`.

## Oracle failures
test/fixedbugs/issue46907.go (both cases) fails: the compiler hits an internal
compiler error, "bad type in slice int". The build also ICEs while compiling
crypto/internal/fips140/drbg (ctrdrbg.go:78), which slices a converted array
pointer, so the whole testdir build fails. That is the same bad-type symptom the fix guards against.
