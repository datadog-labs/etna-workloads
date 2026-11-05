# Rationale

File: src/backend/parser/parse_utilcmd.c, function expandTableLikeClause (defaults/generated loop).

Traces to the fix.patch hunks in transformTableLikeClause that moved attmap construction into a
separate up-front loop (and removed the incremental `attmap->attnums[...] = list_length(cxt->columns)`).
In current code the default/generated expressions are mapped in expandTableLikeClause using a
by-name attmap that is complete. I reintroduced the incremental mapping: a `defmap` is filled one
column at a time inside the per-column loop and used in map_variable_attnos for default/generated
expressions. A generated column referring to a column with a higher attribute number (bug #16342)
therefore hits an unmapped (zero) entry and fails.

Failing oracle case: src/test/regress||create_table_like
