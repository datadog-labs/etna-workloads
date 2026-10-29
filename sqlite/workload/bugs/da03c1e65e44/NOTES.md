Reproducer: LEFT JOIN with an empty right table and `WHERE NOT(a IS FALSE)`.
The buggy shell treats `a IS FALSE` as implying `a` is non-null, so it turns the
LEFT JOIN into an inner join and returns no rows. The clean shell returns `1|`
(join-18.3).
