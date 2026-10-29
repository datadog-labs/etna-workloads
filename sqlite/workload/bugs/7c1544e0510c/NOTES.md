repro.sql runs the join-14.3 query: a LEFT JOIN against a nested subquery whose
result column is an expression (cc+222) over a flattened subquery.
Clean shell prints `111|555|333`. Buggy shell aborts with an assertion
failure (`sqlite3VdbeExec: Assertion 'pC!=0' failed`, exit status -6), because
substExpr no longer descends into the children of TK_IF_NULL_ROW.
