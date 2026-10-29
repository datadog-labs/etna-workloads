# Rationale

## Changed hunk: src/expr.c, `case TK_BITNOT: case TK_NOT:` in sqlite3ExprCodeTarget

Reverses the fix hunk that added `inReg = sqlite3ExprWritableRegister(pParse, inReg, target);`
before `sqlite3VdbeAddOp1(v, op, inReg)`. The pre-fix code coded the operand with
`sqlite3ExprCodeTarget(pLeft, target)` and then applied OP_Not/OP_BitNot to the
returned register *in place*, without checking whether that register is shared
(column cache then; a register that ExprCodeTarget returns directly, e.g. a column
or a reused common subexpression, now). The fix introduced sqlite3ExprWritableRegister
for that. In 3.54.1 the column cache and that helper no longer exist; the code
uses `ExprCodeTemp` and writes the result into a separate `inReg`, which avoids
the bug. I restored the old shape: code operand via ExprCodeTarget, then
`op inReg, inReg`, modifying the operand's register in place.

The other fix hunks (CASE column-cache-disable ordering, moving usedAsColumnCache)
have no counterpart in 3.54.1 (column cache removed), so they were not reverted.

## Oracle failures
test/cse.test: cse-1.1, cse-1.7, cse-1.9 fail (`SELECT b, -b, ~b, NOT b, ...` etc.:
the plain column register is clobbered by ~/NOT, so later copies of `b` give wrong values).
