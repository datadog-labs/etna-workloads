# Rationale

File: src/backend/parser/parse_utilcmd.c, function transformTableLikeClause (the CREATE_TABLE_LIKE_DEFAULTS/GENERATED block that builds AT_CookedColumnDefault commands).

Traces to the first hunk of fix_impl.patch. The fix replaced
`DEFAULTS || GENERATED` with a split test: generated columns obey only INCLUDING GENERATED, plain defaults only INCLUDING DEFAULTS.
I restored the old condition, so INCLUDING DEFAULTS alone also copies the generation expression of a generated column.
Because the column is marked GENERATED only under INCLUDING GENERATED (current code, earlier in the function), the copied expression ends up as a plain default on a non-generated column.

The other fix hunk (def->generated assignment) has no counterpart in the current code, since the marking is done in a separate place that is already conditional. I left it unchanged.

Failing oracle case: src/test/regress||create_table_like
