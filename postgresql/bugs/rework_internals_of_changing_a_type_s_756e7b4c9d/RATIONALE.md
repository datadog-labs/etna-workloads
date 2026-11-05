# Rationale

Reverses the "Rework internals of changing a type's ownership" commit by restoring the old single-function design, adapted to current code.

- `src/include/commands/typecmds.h`: drop `AlterTypeOwner_oid`, and give `AlterTypeOwnerInternal` back its `hasDependEntry` argument. This traces to the typecmds.h hunk of fix.patch.
- `src/backend/commands/typecmds.c`, `AlterTypeOwner`: this goes back to the inline composite-vs-other branch instead of calling `AlterTypeOwner_oid`. This traces to the first typecmds.c hunk.
- `src/backend/commands/typecmds.c`, `AlterTypeOwner_oid` (removed) and `AlterTypeOwnerInternal`: the shdepend update and `InvokeObjectPostAlterHook` move back into `AlterTypeOwnerInternal`, which takes `hasDependEntry`. This traces to the second and third typecmds.c hunks.
- `src/backend/commands/tablecmds.c`, `ATExecChangeOwner`: passes `relkind == RELKIND_COMPOSITE_TYPE` as `hasDependEntry` again. This traces to the tablecmds.c hunk.
- `src/backend/catalog/pg_shdepend.c`, `shdepReassignOwned_Owner`: calls `AlterTypeOwnerInternal(objid, newrole, true)` again. This traces to the pg_shdepend.c hunk.

Why this brings the bug back: `REASSIGN OWNED` on a composite type now only updates the pg_type row, because it no longer goes through `ATExecChangeOwner`. The type's pg_class entry, and the attached dependency and ACL handling, keep the old owner.

Failing oracle case: `src/test/regress||dependency`.
