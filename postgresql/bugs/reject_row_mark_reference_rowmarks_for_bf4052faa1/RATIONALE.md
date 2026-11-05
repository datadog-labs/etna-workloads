# Rationale

Hunk: src/backend/executor/execMain.c, `CheckValidRowMarkRel()`, `case RELKIND_MATVIEW`.
Traces to the fix.patch hunk of the same function. The fix allowed ROW_MARK_REFERENCE on matviews and errored only for real locking clauses. Reversed, it again unconditionally errors "cannot lock rows in materialized view". Queries that reference a matview with a ROW_MARK_REFERENCE rowmark (e.g. an UPDATE/DELETE joining a matview) now fail.

Failing oracle case: src/test/regress||matview
