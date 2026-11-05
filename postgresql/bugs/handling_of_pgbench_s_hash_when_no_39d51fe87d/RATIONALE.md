# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 39d51fe87dae843574fa2349128679800bfe7ccd ("Fix handling of pgbench's hash when no argument is provided"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/bin/pgbench/exprparse.y

Failing oracle cases:
- `src/bin/pgbench|t/002_pgbench_no_server.pl|pgbench option error: not enough arguments for hash stderr /(?^:unexpected number of arguments \(hash\))/`
