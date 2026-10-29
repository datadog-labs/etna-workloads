# Ticket #3334: flattening a LIMIT subquery under an outer WHERE

Fix hunk reversed: `if( pSub->pLimit && p->pWhere ) return 0; /* Restriction (19) */` in `flattenSubquery()`.
In 3.54.1 this line is still present in `src/select.c` (about line 4443), so I deleted it. I left the restriction (19) comment alone. Nothing else covers the case, so deleting the line is enough.

Without it, `SELECT a FROM (SELECT a FROM t1 ORDER BY b LIMIT 2) WHERE a=1` is flattened. The WHERE is then applied before the LIMIT instead of after it.

Oracle cases that fail (`test/tkt3334.test`):
- tkt3334-1.1: expected `{}`, got `1 1`.
- tkt3334-1.3: expected `1`, got `1 1 1`.
