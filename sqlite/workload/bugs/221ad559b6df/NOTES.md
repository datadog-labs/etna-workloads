Reproducer (repro.sql): the first query evaluates the vector IN subquery `(b,a) IN (('z',9))` as a result column, so its subroutine is generated first.
The second query, with the same IN in the WHERE clause, reorders the terms in removeUnindexableInClauseTerms() and wrongly reuses that subroutine.
Clean shell returns the row `z|9` for the second query. Buggy shell returns no row.
This is test in7-7.6, which fails when the injected bug is present.
