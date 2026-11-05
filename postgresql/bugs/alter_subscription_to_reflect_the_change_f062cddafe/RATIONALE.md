# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f062cddafe6b3dcb6d090111c7cd4afa0c7fa4b3 ("Fix the ALTER SUBSCRIPTION to reflect the change in run_as_owner option."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/subscriptioncmds.c

Failing oracle cases:
- `src/test/regress||subscription`
- `src/test/subscription|t/033_run_as_table_owner.pl|can replicate after setting run_as_owner to false`
- `src/test/subscription|t/033_run_as_table_owner.pl|table owner can do the initial data copy`
