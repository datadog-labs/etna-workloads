# Rationale

Fix hunk (src/wherecode.c, codeAllEqualityTerms): the fix made `x IN (SELECT ...)`
terms look at the affinity of the SELECT's result column and degrade zAff[j] to
BLOB when the comparison affinity is BLOB. Before the fix, WO_IN terms were skipped
entirely (`(eOperator & (WO_ISNULL|WO_IN))==0`), so the index column's affinity was
applied to the IN-subquery value.

In 3.54.1 the logic was rewritten: IN-SELECT terms set `zAff[j]=SQLITE_AFF_BLOB`
unconditionally. I restored the pre-fix form: the branch condition is again
`(eOperator & (WO_ISNULL|WO_IN))==0`, so IN terms never touch zAff and the index
column affinity (e.g. TEXT) is applied to a BLOB-affinity value from the subquery
(1 becomes '1' and falsely matches).

Failing oracle cases: rowvalue9-1.6.1, 2.5, 3.3, 4.3.1, 4.3.2, 4.5.x, 4.6.x, 4.7.x
(IN-SELECT with an index returns rows that the non-indexed query correctly omits).
