Compound SELECT with `ORDER BY a+b COLLATE NOCASE` (an expression, not a result column).
Clean: "Parse error: 1st ORDER BY term does not match any column in the result set", exit 1.
Buggy: the ORDER BY is resolved wrongly (not moved into the converted subquery), so the
statement is accepted silently, exit 0. (selectA-5.4)
