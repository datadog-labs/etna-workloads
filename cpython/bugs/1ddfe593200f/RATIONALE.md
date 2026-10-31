# Rationale

Two hunks, each reversing a hunk of fix.patch:

1. `Python/sysmodule.c` (`sys_remote_exec_impl`): removed the
   `PySys_Audit("sys.remote_exec", "iO", pid, script)` call, which the fix added
   (the error path is now `goto error` rather than `return NULL`, but the call
   is the same). `sys.remote_exec()` no longer emits an audit event in the caller.
2. `Python/ceval_gil.c` (`run_remote_debugger_script`): event name changed
   back from `cpython.remote_debugger_script` to `remote_debugger_script`.

Failing oracle cases:
- `test_audit.AuditTest.test_sys_remote_exec`: no `sys.remote_exec` or
  `cpython.remote_debugger_script` event is seen.
- `test_sys.TestRemoteExec.test_remote_exec_raises_audit_event`: the expected
  `cpython.remote_debugger_script` event is missing; the old name is emitted instead.
