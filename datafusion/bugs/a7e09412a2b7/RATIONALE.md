# Rationale

Changed `datafusion/spark/src/function/url/parse_url.rs`, `ParseUrl::parse`.

Reverses the first hunk of the fix: for a schemeless value (`RelativeUrlWithoutBase`, no `://`), the manual
relative-URI parsing (path/query/fragment split) is replaced by the pre-fix `Ok(None)`. So `parse_url('notaurl','PATH')`
and `'FILE'` return NULL instead of the input string, and QUERY/REF on schemeless input also give NULL.

The `has_key_arg` NULL-key hunks were left alone (a separate behaviour). 55.2.0 has `query_value`, which only
the removed code used for the schemeless path; the other path still uses it.

Oracle: `parse_url.slt` and `try_parse_url.slt` fail on the schemeless cases (PATH/FILE/QUERY/REF on
`notaurl`, `notaurl?key=value`, `notaurl#reference`, ...): expected `notaurl`, actual `NULL`.
