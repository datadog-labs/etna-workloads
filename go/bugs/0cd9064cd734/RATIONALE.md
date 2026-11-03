# Rationale (issue 60562)

Both changes are in tree/src/cmd/compile/internal/types2/unify.go (go/types is generated from it / not in scope).

1. `nify`: `if u.enableInterfaceInference && mode&exact == 0 {` -> `if u.enableInterfaceInference {`.
   Reverses fix hunk 1: interface inference is applied again even when exact unification is required (e.g. element types of chan/slice/func), so inference succeeds and later yields an assignment error instead of an inference failure.
2. `case *Interface:` assert `!u.enableInterfaceInference || mode&exact != 0` -> `!u.enableInterfaceInference`.
   Reverses fix hunk 2; the old assert is violated when exact-mode interfaces reach the switch.

Oracle: with interface inference on, exact-mode interface pairs now hit the assert, which panics and aborts the types2 test package (TestFixedbugs/issue60562.go and many others fail). The issue60562 cases would otherwise report the wrong error kind.
