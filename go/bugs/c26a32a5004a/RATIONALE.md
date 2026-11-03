# Rationale

Changed: `src/cmd/compile/internal/reflectdata/reflect.go`, `MarkUsedIfaceMethod`.

Fix hunk reversed: the `ityp.HasShape()` branch that emits a name-only
relocation (the fix's `R_USEGENERICIFACEMETHOD`, now `R_USENAMEDMETHOD` in
go1.27.3). The `AddRel` call is removed, so the branch just returns. The now-unused
`staticdata` import is dropped. Before the fix, calls on shape-typed interfaces
recorded no method-use information (walk skipped marking them), so the linker's
deadcode pass had no record of the called method name. That is the same
behaviour as here. The linker, `reloctype`, and `walk/expr.go` were left alone
(the linker and `reloctype` are outside the allowed scope).

Failing oracle case: `Test/typeparam/issue49049.go`. `a.m` is called through
`A[T]` inside a generic function. Nothing marks `(*Z).m` as reachable, so the
linker drops it and the program crashes at run time (fatal runtime error).
