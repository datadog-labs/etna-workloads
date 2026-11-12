# windows_a95a5ccc9a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a95a5ccc9ab4d44f2b928048eb8b037c09af709f ("Fix windows"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/17738.test
