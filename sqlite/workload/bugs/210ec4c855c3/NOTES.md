Reproducer (`repro.sql`): an FTS5 table joined with `t1 LEFT JOIN vt ON (vt MATCH 'abc')`
(fts5leftjoin-1.2).

Clean shell returns `1|abc` and `2|abc`. The buggy shell fails with
"unable to use function MATCH in the requested context", exit status 1. The injection removes
the code that copies the EP_OuterON property to the virtual MATCH term that
the optimizer generates for the ON-clause constraint.
