Reproducer (`repro.sql`): CASE with a row-value base expression and row-value WHEN
terms (from rowvalue8-1.1/2.1), both with a plain row value and with a row-value subquery.

Clean shell: returns the matching branches (aleph/bet/-).
Buggy shell: fails with "row value misused" and "sub-select returns 2 columns - expected 1", exit status 1.
