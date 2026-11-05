# Rationale

Changed file: src/backend/rewrite/rewriteHandler.c

- `ApplyRetrieveRule`: removed the check that raises "access to non-system view ... is restricted" when `restrict_nonsystem_relation_kind` includes `view`. This traces to the rewriteHandler.c hunk in `ApplyRetrieveRule` in fix.patch.
- `rewriteTargetView`: removed the same check. This traces to the second rewriteHandler.c hunk.

With the checks gone, the GUC can still be set, but non-system views are expanded anyway. That is the bug the fix addressed: pg_dump's restriction on view expansion has no effect.

Failing oracle case: src/test/regress||create_view
