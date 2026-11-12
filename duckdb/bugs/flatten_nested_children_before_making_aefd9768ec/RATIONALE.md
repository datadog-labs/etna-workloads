# flatten_nested_children_before_making_aefd9768ec

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit aefd9768ecf40c98e736833cbd421d75aaf7f069 ("Flatten nested children before making a string cast result constant"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/cast/string_to_struct_variant_child.test
