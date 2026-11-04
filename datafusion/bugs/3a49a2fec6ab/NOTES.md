Reproducer: `EXEC();` (EXECUTE with no statement name).
Clean build: returns a planning error "EXECUTE statement requires a name".
Buggy build: planner calls `name.unwrap()` on None and panics.
