Creates an FTS3 (non-FTS4) table, runs `merge=1` (which creates the %_stat table), then inserts a row and reads %_stat.
Clean: %_stat stays empty for FTS3 (doc totals only kept when bFts4). Buggy: the injection keys doc-total updates on bHasStat, so a stat row is written (`0|<blob>`).
