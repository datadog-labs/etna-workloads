# Rationale

- File/function: src/backend/utils/adt/ri_triggers.c, ri_restrict().
- Traces to the fix_impl.patch hunk in ri_restrict that passes `!is_no_action` as the new `is_restrict` argument to ri_PerformCheck.
- The `is_restrict` plumbing (ri_PerformCheck / ri_ReportViolation and the ERRCODE_RESTRICT_VIOLATION branch) still exists. I changed the ri_restrict call to pass `false`, so RESTRICT violations take the generic branch. They report ERRCODE_FOREIGN_KEY_VIOLATION and the "violates foreign key constraint" message instead of the RESTRICT error code and message.

Failing oracle cases: collate.icu.utf8, foreign_key.
