# add_location_back_d0db353ff6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d0db353ff64cfcc570bdca1c1ccbb0e9361cf9c0 ("Add location back in"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/peg_parser/unterminated_literals.test
