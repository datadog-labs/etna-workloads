# Rationale

Changed hunk: `src/backend/rewrite/rewriteHandler.c`, `rewriteTargetView()`.
It traces to the fix.patch hunk that adds the "For INSERT .. ON CONFLICT .. DO UPDATE" block in `rewriteTargetView`.

I removed that whole block. The block did three things:
- It remapped the resnos in `onConflictSet` to base-relation columns.
- It built a new EXCLUDED RTE and `exclRelTlist` for the base rel.
- It rewrote the Vars in the ON CONFLICT clause that referenced the view's EXCLUDED.

Without it, INSERT ON CONFLICT UPDATE through a view that isn't just `SELECT *` keeps view-column numbering. The update targets and EXCLUDED references then point at the wrong columns, or fail with an error.

I did not touch the other hunks of the fix: the `fireRIRrules` skip for the EXCLUDED RTE, the `BuildOnConflictExcludedTargetlist` refactor, and the `heap_close` move. They don't cause the bug by themselves.

Failing oracle case: `src/test/regress||updatable_views`
