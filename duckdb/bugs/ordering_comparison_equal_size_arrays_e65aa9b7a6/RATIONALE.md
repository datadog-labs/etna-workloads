# ordering_comparison_equal_size_arrays_e65aa9b7a6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e65aa9b7a632b6310412f1c8ad86004578eca8e3 ("Fix ordering comparison of equal fixed-size arrays"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/nested/array/array_value_comparison.test
