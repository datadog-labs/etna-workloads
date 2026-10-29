Reproducer for the 2019-08-30 ticket 40812aea1fde9594 (affinity2-601).

repro.sql creates a table with a REAL UNIQUE column holding 3175546974276630385, then evaluates `3175546974276630385 < c0` both as an expression and as a WHERE term that uses the index.

The clean shell returns 1 for both queries. The buggy shell keeps REAL affinity on the index column, so the index lookup loses precision and the WHERE query returns no row, which disagrees with the expression result.
