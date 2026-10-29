repro.sql: a BEFORE UPDATE trigger logs new.y, while the UPDATE sets y=random().
With the fix, the expression is evaluated once, so the logged value equals the
stored value and the final count is 1. With the bug, it is evaluated twice
(once for the trigger, once for the row), the values differ, and the count is 0.
