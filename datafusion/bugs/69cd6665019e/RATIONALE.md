# Rationale

## Changed hunk
`datafusion/expr/src/expr.rs`, `intersect_metadata_for_union`: 55.2.0 still contained
the fix's logic verbatim (skip empty metadata, `Option` accumulator). I restored the
pre-fix body: start from the first branch's metadata (empty if no inputs) and
`retain` keys matching in every later branch, with no skipping of empty metadata.
This reverses the sole implementation hunk of the fix. The test hunks were not touched.

## Oracle failure
`datafusion/sqllogictest/test_files/metadata.slt` fails at the new regression query
(`SELECT name FROM (SELECT id, name FROM table_with_metadata UNION ALL SELECT NULL::int, NULL::string) GROUP BY name`):
`Internal error: Physical input schema should be the same as the one converted from logical input schema`
with field/schema metadata differing (physical has metadata, logical `{}`). This is the error from issue #19049.
