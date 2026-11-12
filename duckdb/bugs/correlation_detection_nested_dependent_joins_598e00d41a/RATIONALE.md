# correlation_detection_nested_dependent_joins_598e00d41a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 598e00d41aeabf3cf02513d6b190f9cee2078e8b ("Fix correlation detection for nested dependent joins"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_23860.test
