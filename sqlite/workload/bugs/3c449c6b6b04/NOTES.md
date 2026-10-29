`repro.sql` selects from a doubly-parenthesised subquery: `SELECT * FROM ((SELECT * FROM t2)) AS t3;`.
The clean shell prints `1|a`. The buggy shell drops the subquery when the parser collapses the extra parentheses, so it aborts with `Assertion 'pFrom->fg.isSubquery && pFrom->u4.pSubq!=0' failed` in `selectExpander` (exit status -6).
