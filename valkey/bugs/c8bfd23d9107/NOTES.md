Reproducer: stream with a tombstone (XDEL 3-0), group g1 reads all 5 entries (entries-read=5),
two more XADDs, then `XTRIM MINID = 7-0` trims everything before the group's last_id.
Then g1 reads the remaining entries and XINFO STREAM FULL is printed.

Clean: entries-read 7, lag 0. Buggy: entries-read 6, lag 1 (the read counter is
incremented incorrectly/ the lag is wrong because streamRangeHasTombstones/the first_id
check was changed).
