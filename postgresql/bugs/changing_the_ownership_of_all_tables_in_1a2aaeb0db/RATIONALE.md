# Rationale

- File/function: src/backend/commands/publicationcmds.c, AlterPublicationOwner_internal().
- Traces to the fix_impl.patch hunk in the same function. The fix added a check that rejects a non-superuser new owner when the publication has schemas (is_schema_publication()). I removed that check (in current code it was already reworded to "FOR TABLES IN SCHEMA"). The helper function and header declaration are left in place, now unused.
- Effect: ALTER PUBLICATION ... OWNER TO a non-superuser succeeds for FOR TABLES IN SCHEMA publications, so the expected error in the publication regression test is missing.

Failing oracle case: src/test/regress||publication
