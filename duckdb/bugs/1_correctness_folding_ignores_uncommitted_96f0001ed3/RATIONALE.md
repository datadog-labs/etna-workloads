# 1_correctness_folding_ignores_uncommitted_96f0001ed3

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 96f0001ed3afad63f6698d56bb2cf69977e4c084 ("**1. Correctness: folding ignores uncommitted appends of the same transaction**"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/expression/enum_full_domain_behavior.test
