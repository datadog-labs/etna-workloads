repro.sql writes a header-only CSV (COPY of a zero-row query with header), registers it as an external table,
and lists the inferred column types from information_schema.columns.
Clean: c1,c2,c3 are `Null`. Buggy: they are `Utf8` (no types inferred -> Utf8 instead of Null).
Exit status is 0 on both; only the data_type column differs.
