Reproducer for bpo-32270: Popen with stdin/stdout/stderr set to fds that are also in pass_fds.
The child lists its open fds. Clean: all pass_fds are inherited (missing list is `[]`).
Buggy: the child closes the redirected fds, so they are missing (`[3, 4, 6]`) and the booleans print False.
