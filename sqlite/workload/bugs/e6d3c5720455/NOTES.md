Window-function group_concat() over a single empty-string input should return '' (quote -> ''), but the buggy shell returns NULL.
repro.sql runs `SELECT quote(group_concat(x) OVER ()) FROM (SELECT '' AS x);` (window1-78.1). Clean prints `''`, buggy prints `NULL`.
