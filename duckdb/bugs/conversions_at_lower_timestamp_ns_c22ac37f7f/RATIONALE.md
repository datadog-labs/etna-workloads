# conversions_at_lower_timestamp_ns_c22ac37f7f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c22ac37f7f002c2d83ca5ecf08d2a2e09c8d3e5c ("Fix conversions at the lower `TIMESTAMP_NS` boundary"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/timestamp/timestamp_ns_lower_bound.test
