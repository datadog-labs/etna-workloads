# Rationale
File: src/backend/storage/ipc/signalfuncs.c, function pg_signal_backend().
Traces to the fix.patch hunk that added `!OidIsValid(proc->roleId) ||` to the superuser-owned-backend check.
The reverted code only applies the superuser protection to processes with a superuser role (plus no-role autovacuum workers, which the later pg_signal_autovacuum_worker feature requires). Other role-less backends (checkpointer, bgwriter, walwriter, etc.) are no longer protected, so a pg_signal_backend member can signal them.
Failing oracle case: src/test/regress||privileges
