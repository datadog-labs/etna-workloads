repro.sh builds a module with package a exporting an empty generic func `F[T any]() {}` and a main that calls `a.F[int]()`.
Without the fix, the stenciled body is empty (nil), so the compiler treats it as a bodyless declaration (no code generated, only ABI wrappers) and the build fails; the clean toolchain prints "ok".

Observed difference: clean prints "ok", exit 0. Buggy fails while compiling package runtime (the injection drops the nonempty-body guarantee in the unified-IR reader, so the runtime's own empty-body functions break), with "write barrier prohibited" errors and exit 1. Since the runtime build is affected, any program fails on the buggy toolchain; the program is just the upstream test's shape (empty generic function called cross-package).
