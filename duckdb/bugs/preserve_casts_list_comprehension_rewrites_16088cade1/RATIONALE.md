# preserve_casts_list_comprehension_rewrites_16088cade1

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 16088cade1de8fe9ff39665df5966ea37135fbdd ("fix(optimizer): preserve casts in list comprehension rewrites"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/expression/list_comprehension_casts.test
