# also_have_do_line_checking_4a29b210e7

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 4a29b210e7d082dc3689548df698d268e485f9d8 ("Also have to do the line checking after unquoted values"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/parallel/csv_parallel_new_line.test_slow
