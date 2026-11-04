Reproducer: `repro.sql` calls `strpos` with integer arguments (`strpos(12345, 34)` and mixed string/integer forms).

Clean build: each statement fails with a planning error ("Function 'strpos' requires String, but received Int64").
Buggy build: the signature implicitly coerces any type to string, so the queries succeed and return 3.
