Reproducer (`repro.sql`) is the join-32.2 case: a RIGHT JOIN query with `y IS z`, where z comes from a view.
The injection removes the check that stops the transitive-constraint optimization from using an IS term in a query with RIGHT JOIN.
Clean shell prints `NULL|NULL|123|NULL`. Buggy shell returns no rows.
