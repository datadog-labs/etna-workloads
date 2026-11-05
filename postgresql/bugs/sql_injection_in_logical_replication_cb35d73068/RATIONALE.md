# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit cb35d730689546dd7334437f2954a6670fbb967e ("Fix SQL injection in logical replication origin checks."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/subscriptioncmds.c

Failing oracle cases:
- `src/test/subscription|t/030_origin.pl|Create subscription with origin = none and copy_data when the publisher's ancestor is subscribing from different origin`
- `src/test/subscription|t/030_origin.pl|Create subscription with origin = none and copy_data when the publisher's partition is subscribing from different origin`
- `src/test/subscription|t/030_origin.pl|Refresh publication when the publisher has subscribed for the new table, but the subscriber-side wants origin = none`
