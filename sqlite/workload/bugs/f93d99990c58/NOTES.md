repro.sql: triggerB-1.2. A temp view `vx` (with constant column `yy`) has an INSTEAD OF UPDATE OF y trigger that updates the base table. `UPDATE vx SET y = yy` is run.

Clean: succeeds, rows become `1|0|0`, `2|0|0`.
Buggy: the unused view column `yy` is omitted when materializing the view, so `yy` reads as NULL. This gives `NOT NULL constraint failed: x.y`, exit status 1, and the rows are unchanged.
