# common_subplan_merging_subplans_whose_505d79bd37

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 505d79bd3788331244fdd6695249e5685b32a78b ("Fix common_subplan merging subplans whose children differ only in projection maps"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/common_subplan_projection_map.test
