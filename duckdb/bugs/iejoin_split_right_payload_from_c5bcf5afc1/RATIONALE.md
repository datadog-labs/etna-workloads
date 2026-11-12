# iejoin_split_right_payload_from_c5bcf5afc1

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c5bcf5afc11a875fb016dca186bcf4e7903f4e3e ("IEJoin: split the right payload from the right columns of the merged chunk"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/join/iejoin/iejoin_semi_anti_residual_payload.test
