# precision_loss_float_decimal_casts_eb0ff93e30

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit eb0ff93e30b1a64a59fda9f925451b562007d727 ("Fix precision loss in FLOAT to DECIMAL casts"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_appender_api.cpp::Test appending to a decimal column
- test/sql/types/decimal/cast_to_decimal.test
