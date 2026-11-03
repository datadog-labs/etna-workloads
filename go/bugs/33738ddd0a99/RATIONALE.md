# Rationale

Fix hunk reversed: the `closureInitLSym` helper and its call in `mkinlcall` (inline/inl.go).
In go1.27.3 it lives in `src/cmd/compile/internal/inline/inl.go` (with an OCONVNOP-skipping tweak and
`clo.Func.IsClosure()` instead of `IsTrivialClosure`). I removed the whole helper and its call, so a
directly called, non-trivial closure that gets inlined no longer gets its LSym created via
`ir.InitLSym`. The closure is hidden from walk, so it never gets an LSym/FuncInfo, which is the
original bug (linker "missing FuncInfo" for inlined functions).

The other hunks (moving InitLSym to ir) were refactoring and are not reverted.
The deadlocals kludge calls InitLSym only for closures assigned to dead locals, not direct calls,
so it does not cover this case.

Oracle: test/fixedbugs/issue54959.go (both oracle cases) fail.
