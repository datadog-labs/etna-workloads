repro.sql: a partial index has WHERE c0=json_quote(1). A query with the same term
and `json_array(c0)='[1]'` substitutes the index expression for c0. The buggy shell
leaves json_quote's JSON subtype on that value, so json_array(c0) embeds it as JSON
and returns the row. The clean shell clears the subtype, so json_array(c0) gives
`["1"]` and no row is returned (empty output).
