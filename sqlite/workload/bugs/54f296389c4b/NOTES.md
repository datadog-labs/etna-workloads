Reproducer: `repro.sql` runs generate_series with a LIMIT/OFFSET larger than the series
(`generate_series(11,1,-1) LIMIT 100 OFFSET 9223372036854775807`, plus `(1,11,2) OFFSET 6`).
Clean shell: empty results, exit 0. Buggy shell: the offset-overrun check in seriesFilter was
removed, so it aborts with an assertion failure in seriesSteps (exit 134); without asserts the
base would overflow and return wrong rows.
