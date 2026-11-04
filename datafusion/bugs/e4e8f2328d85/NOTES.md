`repro.sql` calls `array_remove_n(make_array(1,2,2,1,1), 2, NULL)`, for both List and LargeList. These are the records the fix added to array_remove.slt.

The clean build returns NULL, because a NULL `max` argument gives a NULL result. The buggy build returns the unchanged array `[1, 2, 2, 1, 1]`.

`./check.sh` shows the outputs differ. Both builds exit with status 0.
