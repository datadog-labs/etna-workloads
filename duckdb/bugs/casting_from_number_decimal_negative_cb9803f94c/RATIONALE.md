# casting_from_number_decimal_negative_cb9803f94c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit cb9803f94ceb680fff7b298ba9fada156bc83bff ("When casting from a number with a decimal and a negative exponent to an integer, keep processing the exponent until BOTH the result and the decimal part are zero"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/cast/string_to_integer_exponent_cast.test
