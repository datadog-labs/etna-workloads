# Rationale

## src/backend/commands/tablecmds.c, ATPrepAlterColumnType
Traces to the tablecmds.c hunk of fix_impl.patch (manual child recursion that
remaps attribute numbers in the USING expression, `if (def->cooked_default)` block).
I removed that remap block (build_attrmap_by_name + map_variable_attnos + whole-row check).
The child command now gets the parent's cooked USING expression unchanged, as
before the fix. When a child has different attribute numbers than the parent
(irregular inheritance, e.g. dropped columns or different column order), the USING
expression's Vars point at the wrong child columns, so ALTER TABLE ... SET TYPE ... USING
gives wrong results or errors.
The current code has the manual recursion loop plus a later-added inherited-column check, and
the attribute map helper is now build_attrmap_by_name, so only the remap was removed.
The tupconvert.c and header hunks are a refactor and are left alone.

## Failing oracle cases
- src/test/regress||alter_table
