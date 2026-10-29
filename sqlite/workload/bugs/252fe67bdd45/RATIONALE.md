# Rationale

## src/vdbeapi.c, sqlite3_bind_value(), `case SQLITE_FLOAT`
Reverses the fix hunk that replaced `pValue->u.r` with `sqlite3VdbeRealValue((Mem*)pValue)`.
In 3.54.1 the equivalent code is `(pValue->flags & MEM_Real) ? pValue->u.r : (double)pValue->u.i`,
which handles MEM_IntReal values (integer stored in a REAL column). I restored the pre-fix
`sqlite3_bind_double(pStmt, i, pValue->u.r)`, which reads the union as a double even when
the value is an MEM_IntReal holding an integer in `u.i`. The assert above it is left unchanged.

## Oracle
test/bind2.test: bind2-1.2 fails (preupdate old/new values). Expected `42.0 43.0`, got
`42.0 2.1244822771173601e-322` (the integer 43 reinterpreted as a double bit pattern).
bind2-1.0 and 1.1 still pass.
