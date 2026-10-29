repro.sql: a multi-row VALUES scalar subquery in a correlated query. The first row calls max(substr('abc',1,1),x), which uses the outer column x.

Clean shell prints `xyz`. The buggy shell fails with "no such column: x".

Cause: exprNodeIsConstantFunction() returns WRC_Abort even when the function is constant. The walk then stops before it reaches the column argument.
