# add_prompt_58bec461ce

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 58bec461cedd097c464e72640fec9ed291909a12 ("add prompt"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/csv_dtypes.test
