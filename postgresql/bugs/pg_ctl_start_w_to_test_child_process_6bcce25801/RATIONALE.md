# Rationale

File/function: src/bin/pg_ctl/pg_ctl.c, start_postmaster() (Unix branch).

Traces to the fix.patch hunk in start_postmaster() that replaced `"... &"` run via system()
with fork + `exec "..."`, so the postmaster has the same PID as the forked child and
pg_ctl can waitpid() on it directly. I reverted the shell command: the `exec` is dropped and
a trailing `&` is restored. The forked child is now a shell that backgrounds the postmaster
and exits at once, so the PID pg_ctl tracks is no longer the postmaster's. Today's
wait_for_postmaster_start() therefore sees its "child" exit immediately and reports
failure, and its `pmpid == pm_pid` check cannot match either. That is the bug the fix removed:
pg_ctl -w was not testing the postmaster's own process status.

Failing oracle cases (src/bin/pg_ctl|t/001_start_stop.pl):
- pg_ctl restart with server not running
- pg_ctl restart with server running
- pg_ctl start: exit code 0
- pg_ctl start: matches
- pg_ctl start: no stderr
- start server to check group permissions
