# Rationale

Changed: `src/backend/commands/tablecmds.c`, `MergeAttributes()`, the loop that processes `inherited_defaults`/`cols_with_defaults`.

Traces to the fix.patch hunk in `MergeAttributes` that defers inherited defaults until `newattmap` is complete and then calls `map_variable_attnos()` (plus the whole-row check). I removed the `map_variable_attnos()` call and the whole-row-reference error. Inherited generated-column expressions are therefore copied with the parent's attnos. If the parent has dropped columns, or the child numbers columns differently, the expressions reference wrong columns. This is the bug handled by the fix (CREATE TABLE LIKE combined with inheritance of generated columns).

Failing oracle case: `src/test/regress||create_table_like`
