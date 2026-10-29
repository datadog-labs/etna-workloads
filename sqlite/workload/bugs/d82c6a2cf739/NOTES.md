Selecting `max(x) AND 0`, `max(x) IN ()` or `max(x) NOT IN ()` from an empty table.
With the bug, the parser folds these to a constant and drops the aggregate, so the
query is no longer an aggregate query and returns no rows. The clean shell returns one
row each (0, 0, 1).
