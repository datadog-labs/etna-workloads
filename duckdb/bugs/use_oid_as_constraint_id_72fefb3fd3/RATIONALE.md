# use_oid_as_constraint_id_72fefb3fd3

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 72fefb3fd312258d1ed22fd29f2b3350cba72c9c ("Use OID as constraint id instead of name"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/alter/add_pk/test_add_pk.test
- test/sql/alter/add_pk/test_add_pk_naming_conflict.test
- test/sql/alter/add_unique/test_add_unique.test
- test/sql/index/art/storage/test_art_if_not_exists_constraint_name.test
