# Rationale

- File/function: src/bin/psql/command.c, exec_command_print (\p).
- Traces to the fix.patch hunk in exec_command_print, which added `else if (previous_buf && previous_buf->len > 0) puts(previous_buf->data);`.
  I removed that branch. With an empty query buffer, \p now prints "Query buffer is empty." instead of the previous query, so it no longer agrees with \g and \w.
  The previous_buf parameter is kept, because it is still passed in and the code stays minimal.

Failing oracle case: src/test/regress||psql
