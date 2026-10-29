# Rationale

Fix: 08af1fe27e, "subtype of a value should not propagate across a subquery boundary".

## Hunks changed
- `src/expr.c`, `sqlite3ExprCodeTarget`, `case TK_COLLATE`.
  This reverses the fix's expr.c hunk. In 3.54.1 the fix lives on as a "soft collate" branch
  (a TK_COLLATE without EP_Collate, added by WHERE-clause push-down) that codes the operand and emits
  `OP_ClrSubtype`. I restored the pre-fix form, where TK_COLLATE shares the TK_SPAN/TK_UPLUS
  pass-through (`pExpr = pExpr->pLeft; goto expr_code_doover`). Push-down constraints therefore no longer
  clear the subtype, and a subtype leaks into a flattened or pushed-down subquery.
- `src/vdbe.c`: `OP_ClrSubtype` is left in place. Other callers still use it
  (scalar subquery results, indexed expressions), and the opcode itself is not the defect.

## Oracle results
`./check.sh` reports failures in subtype1-220, subtype1-300 and subtype1-320.
subtype1-220 is the case the fix added: `SELECT * FROM t2, t1 WHERE NOT json_quote(b)` over a view
returning `json(TRUE)`. The subtype now crosses the view boundary, so the result is wrong.
