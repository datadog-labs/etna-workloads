# Reintroduced bug: LIKE post-processing runs after FK creation

The fix made LIKE clauses that need post-processing go into a separate `likeclauses` list. That list was appended to `alist` after the index statements and before the FK statements. The expanded sub-statements were then run before the remaining statements. I undid both changes.

## Hunks
1. `src/backend/parser/parse_utilcmd.c`, `transformTableLikeClause`.
   - Traces to the `cxt->likeclauses = lappend(...)` hunk in fix.patch.
   - The LIKE clause goes back into `cxt->alist` directly.
2. `src/backend/parser/parse_utilcmd.c`, `transformCreateStmt`.
   - Traces to the hunk that added `cxt.alist = list_concat(cxt.alist, cxt.likeclauses)`.
   - I removed that concat.
   - The `likeclauses` struct field and its initializations are still there but are never used. I left them in, but they could be removed too.
3. `src/backend/tcop/utility.c`, `ProcessUtilitySlow`, `T_CreateStmt` case.
   - Traces to the hunk that changed `list_concat(stmts, morestmts)` to `list_concat(morestmts, stmts)`.
   - The statements from `expandTableLikeClause` are appended to the end of the list again.
   - I did not restore the old `foreach` loop. The current `while` loop already tolerates list changes, so the append is safe.

## Why this brings back the bug
The ALTER TABLE ADD FOREIGN KEY statements now run before the LIKE-generated indexes, because the expansions land at the end of the list. A self-referential FK combined with `LIKE ... INCLUDING INDEXES` therefore fails. The referenced primary key or unique index does not exist yet when the FK is created.

## Failing oracle cases
- `src/test/regress||create_table_like`
