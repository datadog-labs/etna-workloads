# bind_positional_reference_that_reaches_d674683ba0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d674683ba0da3b792407e4fd9f7a90380bd29aa8 ("Bind a positional reference that reaches a binder from an inner scope as a correlated reference"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/select/test_positional_reference.test
