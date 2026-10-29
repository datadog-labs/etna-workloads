# Rationale

## Changed: `src/expr.c`, `case TK_IF_NULL_ROW` in `sqlite3ExprCodeTarget`

Reverses the single implementation hunk of fix 3f23ce664e (2023-03-02). In 3.54.1 the
code already used `OP_IfNullRow` with `target` as P3, then `sqlite3ExprCode(pLeft, target)`
with `assert(target==inReg)`. That is the post-fix form: defense (2), the value
must really be in `target`, is satisfied by `sqlite3ExprCode`.

I restored the pre-fix code:
- `OP_IfNullRow` is emitted with P1 only (P3 is left as 0).
- `pLeft` is coded with `sqlite3ExprCodeTarget(..., target)`, which may return a
  different register (for example a constant factored into an OP_Once subroutine,
  or an existing column register).
- After `sqlite3VdbeJumpHere`, P3 is patched to `inReg`.

So OP_IfNullRow NULLs whatever register holds the result. When that is an
OP_Once-computed register, the cached subquery value is overwritten on the
NULL row and is wrong on later rows.

## Oracle
`join2-11.1` fails. The expected result is `... 2 2 3` and the result is `... 2 2 NULL`.
The `count(*)` subquery result, computed in OP_Once, is clobbered by OP_IfNullRow.
The other 60 cases pass.
