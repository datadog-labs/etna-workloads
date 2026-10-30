repro.sh queues SET, GEOADD, EXPIRE in a MULTI, runs EXEC, then prints the per-command stats from INFO commandstats (calls only).
Clean build: multi, exec, set, expire and geoadd each show calls=1.
Buggy build: exec shows calls=4, and set, expire and geoadd are missing. The injection stops EXEC from restoring realcmd for the queued commands, so their stats are charged to EXEC.
