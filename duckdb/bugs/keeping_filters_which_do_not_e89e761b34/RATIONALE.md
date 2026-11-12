# keeping_filters_which_do_not_e89e761b34

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e89e761b344b08e50a8d138e3b53353551189c27 ("Keeping the filters which do not remove NULL values and add them back in the middle return"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/pushdown/issue_17042.test
