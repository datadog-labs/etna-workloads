# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a5d4c04150d4c5a946702734917222af7364204b ("Fix self-deadlock during DROP SUBSCRIPTION."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/subscriptioncmds.c, src/backend/replication/logical/worker.c

Failing oracle cases:
- `src/test/subscription|t/100_bugs.pl|2x3000 rows in t`
- `src/test/subscription|t/100_bugs.pl|2x3000 rows in t2`
- `src/test/subscription|t/100_bugs.pl|check data in subscriber sch1.t1 after schema rename`
- `src/test/subscription|t/100_bugs.pl|check data in subscriber sch2.t1 after schema rename`
- `src/test/subscription|t/100_bugs.pl|check initial data on subscriber`
- `src/test/subscription|t/100_bugs.pl|check replicated update on subscriber`
- `src/test/subscription|t/100_bugs.pl|check snapshot on subscriber`
- `src/test/subscription|t/100_bugs.pl|could not drop replication slot: error message`
- `src/test/subscription|t/100_bugs.pl|create and immediate drop of replication slot`
- `src/test/subscription|t/100_bugs.pl|index predicates do not cause crash`
- `src/test/subscription|t/100_bugs.pl|loading unblessed output plugin fails`
- `src/test/subscription|t/100_bugs.pl|loading unblessed output plugin fails: stderr`
- `src/test/subscription|t/100_bugs.pl|no data yet in subscriber sch2.t1 after schema rename`
- `src/test/subscription|t/100_bugs.pl|peek logical changes with row filter causing division by zero throws error`
- `src/test/subscription|t/100_bugs.pl|remote_lsn has advanced for apply worker raising an exception`
- `src/test/subscription|t/100_bugs.pl|replication slot does not exist: exit code not 0`
- `src/test/subscription|t/100_bugs.pl|replication with RI FULL and dropped columns`
- `src/test/subscription|t/100_bugs.pl|update to temporary table without replica identity with FOR ALL TABLES publication`
- `src/test/subscription|t/100_bugs.pl|update to unlogged table without replica identity with FOR ALL TABLES publication`
- `src/test/subscription|t/100_bugs.pl|update works with REPLICA IDENTITY`
