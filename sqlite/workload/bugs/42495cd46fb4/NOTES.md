Reproducer (`repro.sql`): the fts3defer-4.1/4.2 setup. It builds an FTS4 table with 32768 rows of 26 "m" tokens plus one row containing a..y, then runs a 19-token AND query (`a b c ... s`).

Clean shell: prints the single matching row, exit 0.
Buggy shell: `nLoad4` in `fts3EvalSelectDeferred` overflows 32 bits, causing a floating-point exception (SIGFPE, exit status 136) with no output.
