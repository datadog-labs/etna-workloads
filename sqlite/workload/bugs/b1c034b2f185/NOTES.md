Reproducer for the fts3 assert() re-added by injection.patch (fts3corrupt4-53.1).
repro.sql loads the corrupt FTS4 database from test 53.0 via `.open --hexdb`, then runs
a MATCH query (the test's query rewritten in standard syntax, since the shell lacks
sqlite_fts3_enable_parentheses).
Clean: returns the row `0|ATE 2:P`. Buggy: aborts with
`fts3EvalTestExpr: Assertion 'pExpr->bDeferred || pPhrase->doclist.bFreeList==0' failed`.
