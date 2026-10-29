# Rationale

Fix hunk reversed: the `src/vdbe.c` hunk in OP_Eq/Ne/Lt/Le/Gt/Ge (text-affinity branch). The fix added, for each of
`pIn1` and `pIn3`, `if( flags & MEM_Str ) pIn->flags &= ~(MEM_Int|MEM_Real|MEM_IntReal);`, so a value with both a
string and a numeric type is compared only as a string. In 3.54.1 the code has the same structure (`src/vdbe.c`, ~line 2432),
so I restored the pre-fix conditions verbatim: `if( (flagsN & MEM_Str)==0 && (flagsN&(MEM_Int|MEM_Real|MEM_IntReal))!=0 )`
for both operands. A value that is TEXT plus INT/REAL keeps its numeric flag, and sqlite3MemCompare then
compares it numerically.

The other fix hunks only add test helpers (test1.c, noop.c) and the test, and are already present, so I left them unchanged.

Oracle cases that fail: types3-3.2 (`NOT x=add_text_type(1)` returns 1 instead of nothing) and
types3-3.5 (`add_text_type(1.25)` returns 1.25 instead of nothing).
