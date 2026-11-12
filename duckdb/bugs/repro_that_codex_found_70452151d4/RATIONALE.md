# repro_that_codex_found_70452151d4

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 70452151d4389953a1b5fb1bb176f5c011fd5010 ("fix repro that codex found"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/monotone_preimage.test
