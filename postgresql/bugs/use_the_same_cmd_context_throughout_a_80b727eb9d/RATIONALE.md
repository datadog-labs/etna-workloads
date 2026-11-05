# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 80b727eb9deab589a8648750bc20f1623d5acd3e ("Use the same cmd_context throughout a walsender's lifetime."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/replication/walsender.c

Failing oracle cases:
- `src/test/subscription|t/100_bugs.pl|could not drop replication slot: error message`
- `src/test/subscription|t/100_bugs.pl|create and immediate drop of replication slot`
- `src/test/subscription|t/100_bugs.pl|loading unblessed output plugin fails`
- `src/test/subscription|t/100_bugs.pl|loading unblessed output plugin fails: stderr`
- `src/test/subscription|t/100_bugs.pl|peek logical changes with row filter causing division by zero throws error`
- `src/test/subscription|t/100_bugs.pl|remote_lsn has advanced for apply worker raising an exception`
- `src/test/subscription|t/100_bugs.pl|replication slot does not exist: exit code not 0`
