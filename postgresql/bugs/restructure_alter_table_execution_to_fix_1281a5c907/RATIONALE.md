# Rationale

Changed hunk: src/backend/commands/tablecmds.c, ATPrepCmd(), case AT_SetIdentity.
Traces to the fix.patch hunk that changed `pass = AT_PASS_COL_ATTRS` to
`pass = AT_PASS_MISC` ("This should run after AddIdentity, so do it in MISC pass").
Restoring AT_PASS_COL_ATTRS makes SET GENERATED/SET sequence options run before
ADD GENERATED (which runs in AT_PASS_ADD_OTHERCONSTR) in a single ALTER TABLE, so
the combined command fails or misbehaves.

Failing oracle case: src/test/regress||identity
