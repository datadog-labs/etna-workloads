Reproducer: EXPLAIN of regex/LIKE operators on a Utf8View column plus a query. Clean build keeps Utf8View in the plan; buggy build coerces to CAST(... AS Utf8).
