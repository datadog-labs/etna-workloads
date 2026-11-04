Reproducer: LEFT JOIN with `WHERE NOT ((t2.col > 150) IS TRUE)` (and `IS FALSE`).
These predicates accept NULL-padded rows, but the buggy EliminateOuterJoin treats
IS TRUE/IS FALSE nested under NOT as null-rejecting and converts the LEFT JOIN to
an INNER join. df-buggy drops the NULL-padded rows (c, d); df-clean returns them.
