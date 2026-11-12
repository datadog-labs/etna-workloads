# geometry_textwriter_corrupting_coordinates_scientific_d78e46c619

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d78e46c6199e9d2705b3dcf6adbb8186acdd36d0 ("Fix geometry TextWriter corrupting coordinates in scientific notation"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/geo/geometry.test
