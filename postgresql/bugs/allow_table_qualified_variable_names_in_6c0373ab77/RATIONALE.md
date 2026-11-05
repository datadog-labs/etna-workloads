# Rationale

Changed: src/backend/parser/parse_clause.c, transformOnConflictArbiter().
Traces to the parse_clause.c hunk of fix_impl.patch (reversed): the fix removed the code that
saved p_namespace, replaced it with only the target table (unqualified refs only, addNSItemToQuery with
addToRelNameSpace=false), and restored it afterwards. I re-added that block around arbiter
expression / WHERE processing. Table-qualified names (e.g. ON CONFLICT (...) WHERE tab.col > 0)
are again rejected, as the target is only visible as unqualified column names.

The analyze.c hunks (namespace ordering in transformInsertStmt/transformOnConflictClause) were not
needed to reproduce the failure in current code, so left unchanged.

Failing oracle case: src/test/regress||insert_conflict
