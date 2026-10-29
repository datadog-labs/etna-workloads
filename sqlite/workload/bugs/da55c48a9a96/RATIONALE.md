# Ticket #3522: table.* expansion on USING / NATURAL joins

Fix hunk (select.c, selectExpander): `if( i>0 )` became `if( i>0 && zTName==0 )`, so
that the "omit USING/NATURAL columns from the right-hand table" logic is skipped
when the star is qualified (`tbl.*`).

In 3.54.1 NATURAL joins are rewritten to USING, and the equivalent check is at
`src/select.c` ~line 6376: `if( i>0 && zTName==0 && (selFlags & SF_NestedFrom)==0 )`.
I removed the `zTName==0` term, restoring the pre-fix behaviour: `t2.*` on a
USING/NATURAL join drops the join columns of the right-hand table.

Oracle failures: join-1.3.7..1.3.10, 1.4.7, 2.1.3, 36.2, 36.3 give wrong column
lists; tkt3522-1.1 hits the assertion `p->pEList!=0` in sqlite3Select (all columns
omitted -> empty result list), and tkt3522-1.2 fails after that crash.
