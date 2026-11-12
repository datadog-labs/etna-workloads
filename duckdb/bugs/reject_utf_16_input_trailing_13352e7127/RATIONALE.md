# reject_utf_16_input_trailing_13352e7127

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 13352e71274c771fab6c5fad35b6bd6bb6643654 ("Reject UTF-16 input with a trailing odd byte, and fix get_bit/set_bit bound check"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/test_utf16_odd_length.test
