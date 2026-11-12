# remove_redundant_constant_or_null_a3ad1ff746

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a3ad1ff746ce687ed5a53199a9d6857d266e056d ("Remove redundant constant_or_null conjuncts in statistics propagation"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/statistics/constant_or_null_conjunction.test
