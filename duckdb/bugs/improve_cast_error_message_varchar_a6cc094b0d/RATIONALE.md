# improve_cast_error_message_varchar_a6cc094b0d

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a6cc094b0d328f244d50aef74ee71ad54d9b165d ("improve cast error message for VARCHAR -> nested type"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/cast/string_to_list_cast.test
- test/sql/cast/string_to_struct_cast.test
- test/sql/types/nested/array/array_try_cast.test
