repro.sql runs `SELECT (SELECT y FROM (SELECT sum(x) AS y) AS t2) FROM t1;`, where the aggregate sits in a FROM-clause subquery of a sub-select of the select that owns it.
Clean shell: returns 123. Buggy shell: spurious error "misuse of aggregate: sum()" (exit status 1).
