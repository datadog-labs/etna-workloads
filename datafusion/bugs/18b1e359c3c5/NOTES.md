repro.sql runs grouped first_value/last_value with an ORDER BY and a FILTER whose predicate (`b < 1`) is NULL for one row.
Clean returns NULL (no row has a true predicate); buggy treats the NULL-predicate row as passing and returns 10.
