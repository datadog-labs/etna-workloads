# keep_non_null_elements_9723eb0bdf

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9723eb0bdfde8fe79d612c966b591e6ff0438e52 ("keep non-NULL elements"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/contains_to_in_clause.test
