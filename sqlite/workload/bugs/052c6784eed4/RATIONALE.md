# Rationale

Fix hunk (src/vdbemem.c, valueFromExpr, TK_UMINUS of SMALLEST_INT64): pre-fix code
did `flags &= MEM_Int; flags |= MEM_Real;` (leaving MEM_Int set alongside MEM_Real);
the fix changed it to `&= ~MEM_Int`.

In 3.54.1 the same branch is in `valueFromExpr` (src/vdbemem.c ~1903) and uses
`MemSetTypeFlag(pVal, MEM_Real)`, which correctly clears the other type flags.
I replaced that call with the pre-fix two lines `pVal->flags &= MEM_Int; pVal->flags |= MEM_Real;`.
The value assignment (-(double)SMALLEST_INT64 == 2^63, same double as the old
(double)LARGEST_INT64) is left as is; only the flag bug is restored.

## Oracle failure
alter4-9.3 (ALTER TABLE ADD COLUMN c INTEGER DEFAULT (-(-9223372036854775808)))
aborts with assertion `ISPOWEROF2(p->flags & (MEM_Int|MEM_Real|MEM_IntReal))`
in sqlite3VdbeCheckMemInvariants, since the Mem is both Int and Real.
