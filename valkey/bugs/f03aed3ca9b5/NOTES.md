Reproducer: runs MULTI / SET / EXPIRE / EXEC on one connection, then prints `INFO commandstats` call counts.
Clean: exec, expire, multi and set each show calls=1.
Buggy: stats are credited to `c->lastcmd` instead of the executed command. EXEC shows calls=3 and set/expire are missing.
