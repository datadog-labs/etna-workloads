Reproducer: LEFT JOIN against a table with a generated column (`c2 AS(1)`) where the
right table has no rows. The null-extended row must give c2 = NULL.
Clean shell prints `0||`; the buggy shell evaluates the generated column on the null row
and prints `0||1`.
