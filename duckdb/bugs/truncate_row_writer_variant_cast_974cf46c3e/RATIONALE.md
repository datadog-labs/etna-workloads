# truncate_row_writer_variant_cast_974cf46c3e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 974cf46c3e565e9ae61c170ce67ec602ca6f1b67 ("Truncate the row writer when a VARIANT cast bails mid-loop"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/variant/try_cast_nested_list_writer.test
