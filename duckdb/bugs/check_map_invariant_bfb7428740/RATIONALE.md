# check_map_invariant_bfb7428740

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit bfb74287408ec10d950bb31dff1179c5194beb84 ("Check MAP invariant"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/map/map_cast.test
