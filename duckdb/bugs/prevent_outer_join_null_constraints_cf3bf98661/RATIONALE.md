# prevent_outer_join_null_constraints_cf3bf98661

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit cf3bf9866154c35b47c93e0e80ef1727c2ff56a9 ("Prevent outer-join NULL constraints from propagating through LIMIT and TOP_N by using isolated optimizer visitors"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_24542.test
