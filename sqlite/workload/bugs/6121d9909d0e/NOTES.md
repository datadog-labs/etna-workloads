repro.sql is joinI-9.4: an inner join whose ON clause is an OR (so the OR-optimization is used on t0), followed by RIGHT JOIN t2, with WHERE t1.b IS NULL.
Clean: no rows (t1.b is 1 for the only match, so the WHERE filters out the row).
Buggy: returns `||7`. The OR-optimization copies the WHERE term into the sub-loop too early, so the row is wrongly kept as a null-extended RIGHT JOIN row.
