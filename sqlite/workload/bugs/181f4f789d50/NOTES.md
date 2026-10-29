Creates an FTS3 table and runs MATCH with a chain of 2048 terms joined by AND (the FTS expression is balanced to the depth limit of 12).
Clean: query succeeds and prints 0. Buggy: the off-by-one in fts3ExprCheckDepth (`nMaxDepth==0` instead of `<0`) wrongly gives "FTS expression tree is too large (maximum depth 12)".
