# preserve_scan_estimates_predicates_proven_6ded11a5bd

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 6ded11a5bd4381cd4a51cd7e29d4f29072271195 ("Preserve scan estimates for predicates proven always true"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/joins/always_true_scan_filter_estimate.test
