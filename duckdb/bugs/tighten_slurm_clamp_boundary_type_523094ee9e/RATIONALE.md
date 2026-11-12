# tighten_slurm_clamp_boundary_type_523094ee9e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 523094ee9eab6dd95ccd73250e3864239a1b5fd5 ("Tighten SLURM clamp boundary, type ALP pack buffer"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_parse_memory_limit_slurm.cpp::Test ParseMemoryLimitSlurm
