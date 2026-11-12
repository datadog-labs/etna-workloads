# do_not_treat_narrowing_integer_b94130c889

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b94130c889513788966f105e23ca55f0fada05c4 ("Do not treat a narrowing integer cast as invertible"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/narrowing_cast_not_invertible.test
