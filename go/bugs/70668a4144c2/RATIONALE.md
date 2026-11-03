# Rationale

Fix (issue 52915) added cycle detection to `hasVarSize` (a `seen` map keyed on
`*Named`) so that invalid recursive generic types such as
`type T[P any] struct{ T[P] }` do not cause infinite recursion in
`unsafe.Sizeof`/`Offsetof`/`Alignof`.

In go1.27.3 the `seen` map was replaced by `Checker.objPath`/`objPathIdx`
inside `(*Checker).hasVarSize` in `src/cmd/compile/internal/types2/builtins.go`.
Change: removed the `objPathIdx` cycle check (and the matching `push`/`pop`)
in the `*Named` case. This is equivalent to the pre-fix code, which had no
cycle detection: a cyclic Named type recurses forever through its RHS.
(go/types is not under src/cmd/compile, so it is untouched.)

Oracle: the types2 package tests fail (369 of 592 cases) because the
checker recurses infinitely (stack overflow crash) on the issue52915 testdata
(`unsafe.Sizeof(T[int]{})`), taking down the test binary and the cases with it.
