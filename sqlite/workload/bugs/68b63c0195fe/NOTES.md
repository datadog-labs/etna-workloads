Reproducer for zipfile-17.1: zipfile() called with extreme mtime values
(INT64 min/max). The buggy zipfileMtime() disagrees with zipfileMtimeToDos(),
so the buggy shell aborts with an assertion failure (zipfileMtimeToDos,
exit 134). The clean shell prints `blob`.
