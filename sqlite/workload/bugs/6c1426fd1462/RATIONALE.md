# Ticket #2295: IN (SELECT ... ORDER BY) affinity

Fix hunk reversed: `generateSortTail()` SRT_Set case in `src/select.c`. The fix replaced the
hard-coded `"c"` (NUMERIC) MakeRecord affinity with the real comparison affinity of the IN
operator. In 3.54.1 that affinity is `pDest->zAffSdst` (from `exprINAffinity()`); the change
restores the old behaviour by building a same-length affinity string of `SQLITE_AFF_NUMERIC`
and using it instead (P4_DYNAMIC). The other hunks (Select.affinity field, selectInnerLoop)
no longer exist in that form; the non-sorter path already uses `zAffSdst` and is left alone
(pre-fix it was correct too).

Result: when the subquery has ORDER BY, the ephemeral IN-set is built with numeric affinity,
so TEXT values like '1' are stored as integers and `b IN (...)` with TEXT column b no longer matches.

Oracle failures: subselect-4.1, 4.2, 4.3 (all return empty instead of the expected rows).
