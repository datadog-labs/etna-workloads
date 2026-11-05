# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5b8728cd7f9d3d93b6ff9b48887084fdf0a46e4f ("Fix NULLIF()'s handling of read-write expanded objects."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execExpr.c, src/backend/executor/execExprInterp.c, src/backend/jit/llvm/llvmjit_expr.c, src/include/executor/execExpr.h

Failing oracle cases:
- `src/test/regress||case`
