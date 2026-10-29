repro.sql is e_changes-5.2: after inserting 3 rows into t2, `UPDATE t1 SET b = changes()`
with an AFTER UPDATE trigger that logs changes(). Clean: b=3 in every row and the log shows
Clean: b=3 in every row and the log shows "c = 3" each time (db->nChange is restored when the
trigger frame exits). Buggy: the restore is missing, so rows 2 and 3 get b=0 and the log shows "c = 0".
