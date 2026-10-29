# Rationale

Fix aa92c76cd4: comparison opcodes (OP_Eq/Ne/Lt/Le/Gt/Ge) must not change the
datatype of their operands (applyNumericAffinity on a TEXT register leaves it INTEGER).

## Changed hunk
`src/vdbe.c`, OP_Ne..OP_Ge: removed the block "Undo any changes made by applyAffinity()
to the input registers" (`pIn3->flags = flags3; pIn1->flags = flags1;`). This reverses
the fix's vdbe.c hunk that added flags1/flags3 save and restore after the comparison.
In 3.54.1 the saved flags are already kept (used elsewhere), so only the restore is removed.

The expr.c hunk (removing sqlite3ExprCacheAffinityChange in codeCompare) is not applicable:
the register cache no longer exists. The utf16 hunks are unrelated refactoring.

## Oracle failure
select7-7.7: `SELECT typeof(a), a FROM t5 GROUP BY a HAVING a<b` returns `integer 123`
instead of `text 123`, since the comparison converted the TEXT register to INTEGER.
