# generate_correct_uuid_v7_e95f8e6edb

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e95f8e6edb3d3effbe2b33059120b66fa01e98d2 ("Generate correct UUID v7"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/uuid/test_uuid_function.test
