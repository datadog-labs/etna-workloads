repro.sql seeks a rowid table with a non-integer real bound (`rowid >= 4.5`, `rowid < 4.5 ... DESC`) where the
integer approximation (4) is smaller than the real. The fix makes OP_SeekGE/OP_SeekLT become SeekGT/SeekLE in that case.
Clean prints `5` then `4`. Buggy lacks the adjustment, so it prints `4` (wrongly included by >=) then `5` (wrongly included by <, DESC order).
