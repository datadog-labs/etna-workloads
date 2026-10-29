# Rationale

Fix e99fa2af (ticket #3541) changed `~` and `NOT` from one-address (in-place)
VDBE ops to two-address ops (`OP_Not P1 P2`), and in `sqlite3ExprCodeTarget`
replaced "code operand, then modify that register in place" with
"code operand into a temp, write result to target".

In 3.54.1 the opcodes are already two-address (vdbe.c unchanged), and
`sqlite3ExprWritableRegister` no longer exists, so the fix hunks do not reverse cleanly.

## Change: src/expr.c, `case TK_BITNOT / TK_NOT` in sqlite3ExprCodeTarget
Reverses the expr.c hunk: the operand is coded with `sqlite3ExprCodeTarget(pLeft, target)`
and the op is applied to the returned register in place (`OP_Not inReg,inReg`),
instead of `sqlite3ExprCodeTemp` + writing to `inReg=target`. When the operand's
register is not `target` (e.g. an aggregate result register, as in
`CASE ~max(x) WHEN min(x) ...`), the operand's register is overwritten, so later
uses of it see the complemented value. The vdbe.c hunk needs no change: P1==P2
makes the two-address op behave like the old one-address in-place op.

## Oracle failures
- tkt3541-1.1 (`CASE ~max(x) WHEN min(x) THEN 1 ELSE max(x) END`): returns NULL/empty instead of 123.
- tkt3541-1.2 (`CASE NOT max(x) ...`): returns 0 instead of 123.
