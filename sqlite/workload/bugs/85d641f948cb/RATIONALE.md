# Rationale

Fix hunk (src/resolve.c, resolveOrderGroupBy): replaced `(iCol & ~0xffff)!=0` with `iCol<1 || iCol>0xffff`.

In version-3.54.1 the same check sits in `resolveOrderGroupBy()` (src/resolve.c, ~line 1860), already in the fixed form.
I restored the pre-fix condition `(iCol & ~0xffff)!=0`. It only rejects values outside 0..0xffff, so an
integer ORDER BY term of 0 is no longer reported as out of range by this check (and negative values with high
bits set are still caught). The u16 cast on `iOrderByCol` then stores 0, so the term is treated as an ordinary expression.

Failing oracle cases (tkt2822.test): 7.1, 7.2.1, 7.3, 7.4, 7.9-7.13, 7.20-7.22. `ORDER BY 0` returns success
instead of "N ORDER BY term out of range - should be between 1 and 25".
Cases 7.2.2/7.2.3 (26, 65536) still pass because other code in 3.54.1 (the check against nExpr) also covers them.
