# throw_user_facing_error_thread_81eb9f4bc3

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 81eb9f4bc34940850b8788ff7be0d7bb0b453667 ("Fix #25018: Throw user-facing error when thread settings are NULL"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/settings/setting_threads.test
