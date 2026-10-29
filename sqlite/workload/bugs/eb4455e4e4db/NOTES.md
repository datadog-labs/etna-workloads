repro.sql is the pushdown-5.0 query from test/pushdown.test: a RIGHT JOIN whose left side has an `ON null` clause, followed by a LEFT JOIN to a subjoin, with `WHERE e>0`.

Clean shell: returns one row, `-|-|3|4|5`.
Buggy shell: returns no rows. The ON-clause term from the left of the RIGHT JOIN is wrongly treated as a single-table constraint (restriction 6 of sqlite3ExprIsSingleTableConstraint is missing), so it is moved to the other side of the RIGHT JOIN.
