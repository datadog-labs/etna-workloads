repro.sql creates tables with `DEFAULT(true)`, `DEFAULT(not true)` etc. (istrue-500/510).
Clean shell accepts them and returns `1|1|1|0|0` and `99|0|1`.
Buggy shell rejects CREATE TABLE with "default value of column [c] is not constant" (the
TRUE/FALSE-in-DEFAULT conversion in exprNodeIsConstant is missing), so later statements fail too.
