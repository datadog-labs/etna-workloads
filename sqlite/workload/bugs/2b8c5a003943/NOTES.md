repro.sql runs `SELECT c.* FROM (a,b) AS c;` where tables a and b do not exist.
Clean shell: "no such table: a" error, exit 1.
Buggy shell: selectExpander ignores the FROM-clause error and the "*" expander hits assertion `pNestedFrom->nExpr==pTab->nCol` (abort, exit -6).
