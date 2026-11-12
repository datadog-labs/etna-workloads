# monotone_preimage_keep_full_finite_02546feb5f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 02546feb5f0b2aef6224351b71cdb76c4159e1e6 ("Monotone preimage: keep the full finite TIMESTAMP domain, render edge bounds against the infinity sentinels"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/monotone_preimage.test
- test/sql/optimizer/monotone_preimage_tz.test
