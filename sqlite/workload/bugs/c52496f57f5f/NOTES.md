repro.sql: LEFT JOIN whose ON clause is a row-value comparison `(a,b)=(x,y)` with no matching row.
Clean shell returns `1|2|||x` (NULL-extended row). Buggy shell loses the left-join markings on the decomposed
terms, so the term is treated as a WHERE constraint and the row is dropped (empty result).
