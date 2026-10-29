repro.sql: UPDATE OR REPLACE on a table whose AFTER DELETE trigger (with recursive_triggers on) deletes all rows.
The buggy shell proceeds with the UPDATE after the trigger deleted the row (no reseek of the cursor), so it
succeeds and leaves a row `0|1`. The clean shell fails with "constraint failed" and leaves the rows `1|` and `0|`
untouched (the expected result in the 3.54.1 conflict3.test 13.1.1/13.1.3).
