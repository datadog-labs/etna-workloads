# cast_over_sliced_list_reading_10b9f81cde

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 10b9f81cde173f05c5624d4b46f4b0aca79e1b74 ("Fix CAST over a sliced list reading pre-slice child elements"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/nested/list/list_cast_child_offset.test
