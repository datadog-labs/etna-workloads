# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 49f7c6c44a5f6a7f7b39d140e490c9c627511893 ("Abort pgbench if script end is reached with an open pipeline"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/pgbench/pgbench.c

Failing oracle cases:
- `src/bin/pgbench|t/001_pgbench_with_server.pl|error: call \startpipeline and \syncpipeline without \endpipeline stderr /(?^:end of script reached with pipeline open)/`
- `src/bin/pgbench|t/001_pgbench_with_server.pl|error: call \startpipeline without \endpipeline in a single transaction status (got 2 vs expected 2)`
- `src/bin/pgbench|t/001_pgbench_with_server.pl|error: call \startpipeline without \endpipeline in a single transaction stderr /(?^:end of script reached with pipeline open)/`
- `src/bin/pgbench|t/001_pgbench_with_server.pl|error: call \startpipeline without \endpipeline stderr /(?^:end of script reached with pipeline open)/`
