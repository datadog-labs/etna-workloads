# list_struct_cast_quoted_closing_986e89b45b

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 986e89b45b9a57a6084ed46792148a136706ae87 ("fix list of struct cast with quoted closing brace"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/cast/string_to_list_cast.test
