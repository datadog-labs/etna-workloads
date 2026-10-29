Reproducer (repro.sql): windowB-3.9 from the fix. It runs json_group_object(if(id<>1,k),v) as a
sliding window (ROWS 1 PRECEDING AND 1 FOLLOWING), so the first row's key is NULL.

Clean: row 2 gives {"b":2,"c":3}, row 3 gives {"b":2,"c":3,"d":4}, and so on.
Buggy: jsonGroupInverse() miscounts the NULL entry, so it removes the wrong entry. Row 3 gives {"c":3,"d":4}, which is missing "b", and every later row is wrong too.
