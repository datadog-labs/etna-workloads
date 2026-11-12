# shredded_variant_cast_reading_wrong_c18926303a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c18926303a39567ce593a14eb537f0d66f876222 ("Fix shredded VARIANT cast reading the wrong struct child"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/types/variant/variant_shredded_top_level_array_cast.test
