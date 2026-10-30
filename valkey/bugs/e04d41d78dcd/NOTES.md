Reproducer: sends 300 Lua `server.error_reply` calls, each with a distinct custom error prefix, then inspects `INFO errorstats`.

Clean build: after 128 entries, new custom errors are folded into `errorstat_ERRORSTATS_OVERFLOW`, so the entry count stays at or below 129.
Buggy build: the overflow check is removed. There is no `ERRORSTATS_OVERFLOW` entry, and the errorstats table grows without bound (300 entries).
