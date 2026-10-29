Reproducer (repro.sql): `t LEFT JOIN generate_series(1,5) ON 1 WHERE value IS ?1` (?1 unbound = NULL).
generate_series accepts and omits the IS constraint on `value`. With the bug, the WHERE-clause IS term is
passed to the vtab on the rhs of a LEFT JOIN, so the vtab returns no rows and a bogus NULL-extended row is emitted.
Clean: no rows (value is never NULL). Buggy: one row `1|`.
