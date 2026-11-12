# prohibit_options_delim_sep_same_a256de1f75

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a256de1f75fa8d1e9a305998499d87648580b666 ("[CSV Reader] Prohibit options delim and sep in same read_csv call"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/csv_names.test
