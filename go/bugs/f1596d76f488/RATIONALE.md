# Rationale

Fix hunk reversed: `typecheck/expr.go` `tcConv` — the `OBYTES2STR` and `ORUNES2STR` cases that insert an
`OCONVNOP` from `[]B` to `[]byte`/`[]rune` for user-defined byte/rune element types. They are removed
in `src/cmd/compile/internal/typecheck/expr.go`, which restores the pre-fix code.

The `noder/transform.go` hunk (`transformConv`) has no counterpart in go1.27.3: the file and the old
typechecker path are gone, so only the `tcConv` path was reverted.

Result: walk's call to `runtime.slicebytetostring`/`slicerunetostring` gets a `[]MyByte`/`[]MyRune`
argument and fails to typecheck. Both oracle cases fail (`test/fixedbugs/issue23536.go` and
`test/typeparam/issue23536.go`) with "cannot use z (type []MyRune) as type []rune in argument to
runtime.slicerunetostring" and the matching `[]MyByte` error.
