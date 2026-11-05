# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 530f89e648da3a5505920322dcd4e00e15559f66 ("pgbench: fix misprocessing of some nested \if constructs."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/pgbench/pgbench.c

Failing oracle cases:
- `src/bin/pgbench|t/001_pgbench_with_server.pl|nested ifs status (got 0 vs expected 0)`
- `src/bin/pgbench|t/001_pgbench_with_server.pl|nested ifs stderr /(?^:^$)/`
- `src/bin/pgbench|t/001_pgbench_with_server.pl|nested ifs stdout /(?^:actually processed)/`
