# Rationale

File: src/backend/commands/indexcmds.c, function DefineIndex (partition-child recursive DefineIndex call).
Traces to the single hunk of fix_impl.patch: the fix changed the `false` argument to `skip_build`.
Reverted: the recursive call passes `false` instead of `skip_build`, so when ALTER TABLE recreates
indexes with skip_build=true (reusing old relfilenumbers), partition children build the index anyway,
hitting the assertion/crash on oldNumber handling.

Failing oracle case: src/test/regress||indexing
