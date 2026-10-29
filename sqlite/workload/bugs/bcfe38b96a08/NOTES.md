Reproducer: an fts5 table LEFT JOINed to a plain table with `ON t0.b MATCH '1'`.
The clean shell reports `Parse error: no query solution`, because the MATCH
term is not evaluated early. The buggy shell lacks `| extraRight` in
`prereqRight` of the auxiliary term, so the MATCH is evaluated too early and
the result differs (see check.sh output).
