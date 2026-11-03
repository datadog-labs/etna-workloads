# Rationale

Fix hunk: `walk.go` `mayCall` added `ir.OSLICE2ARRPTR` to the list of ops that might panic.

In go1.27.3 the case is `ir.OSLICE2ARR, ir.OSLICE2ARRPTR:` in `src/cmd/compile/internal/walk/walk.go`.
I removed `ir.OSLICE2ARRPTR` from it, restoring the pre-fix list. (`OSLICE2ARR` was added later and is left alone.)
The op now reaches the `default:` case, which calls `base.FatalfAt("mayCall ...")`, so the compiler crashes as in #46720.

Oracle: `test/fixedbugs/issue46720.go` (both cases) fails. The compiler hits an ICE `mayCall` on `SLICE2ARRPTR` for `g((*[24]byte)(nonce))`.
The ICE also occurs while building std packages (crypto/internal/entropy, crypto/internal/fips140/aes), so the testdir build fails.
