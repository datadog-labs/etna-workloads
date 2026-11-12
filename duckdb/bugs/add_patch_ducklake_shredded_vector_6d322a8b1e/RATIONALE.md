# add_patch_ducklake_shredded_vector_6d322a8b1e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 6d322a8b1e5e0019709f901d0d8bd92a690b5164 ("add patch for DuckLake and fix for 'shredded_vector' verification"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/variant/debug_shred_empty_object.test
