# do_not_push_down_extract_8ca33cd87e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 8ca33cd87e89f960dd0758b35252f9122547f949 ("Do not push down an extract on an already extracted column"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/pushdown_extract_reapplied.test
