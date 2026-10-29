Reproducer (repro.sql): a view returns `json(TRUE)`, and a query on it filters with `WHERE NOT json_quote(b)`. This is subtype1-220.

The subtype of `json(TRUE)` leaks through the flattened subquery. `json_quote(b)` then sees a JSON-subtype value and returns `1` unchanged, so the row passes the filter.

The clean shell prints `1|x`. The buggy shell returns no rows. Both exit 0.
