Reproducer: repro.sql (whereK-2.1). A NOCASE-collated indexed column x is compared in two OR terms, one commuted (`y BETWEEN 1 AND x` -> `x>=y`) and one not (`x>=y`). The buggy whereCombineDisjuncts merges them, ignoring the changed collation.
Clean prints `1` / `1`; buggy prints `1` / `0` (the second query gives a wrong count).
