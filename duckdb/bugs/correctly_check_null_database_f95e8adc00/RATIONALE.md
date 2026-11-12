# correctly_check_null_database_f95e8adc00

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f95e8adc0040c928c7b66a096057322bcbce0c05 ("Correctly check for NULL in database"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/fuzzer/duckfuzz/null_checkpoint.test
