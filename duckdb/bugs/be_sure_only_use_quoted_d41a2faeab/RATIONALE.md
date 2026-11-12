# be_sure_only_use_quoted_d41a2faeab

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d41a2faeabedad400e4a56411826d8b2c20b2e24 ("Be sure to only use the quoted part of the sniffer if there is no comment"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/17744.test
