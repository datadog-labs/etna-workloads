CREATE TABLE ... AS SELECT from a subquery whose column is aliased (`SELECT BBb FROM (SELECT aaa AS Bbb ...)`).
The buggy build runs the SELECT (coroutine) before computing the result-set column names, so the new table's column is named `aaa` instead of `Bbb`.
Clean prints `Bbb`; buggy prints `aaa` (colname-9.320).
