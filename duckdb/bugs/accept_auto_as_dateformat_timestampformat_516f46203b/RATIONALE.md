# accept_auto_as_dateformat_timestampformat_516f46203b

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 516f46203b981b739194715a21706581595a82e3 ("Accept auto as a dateformat/timestampformat option"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/test_auto_date.test
