Reproducer for the UNION schema-metadata bug (fix: #12954).

`repro.sql` builds a view whose column has Arrow field metadata (via `with_metadata`). It then runs `UNION ALL` of that column with `NULL::string`, where the metadata-bearing input is on the left. A second query puts it in the middle of two `NULL` inputs.

- df-clean: both queries return no_bar, no_baz, no_foo, NULL.
- df-buggy: the first query fails with "Internal error: Physical input schema should be the same as the one converted from logical input schema ... field metadata at index 0 [name]: (physical) {} vs (logical) {metadata_key: ...}". The second query still succeeds.
