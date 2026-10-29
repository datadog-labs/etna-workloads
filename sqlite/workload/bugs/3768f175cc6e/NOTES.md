repro.sql creates t3(a INTEGER PRIMARY KEY, b) and runs `SELECT * FROM t3 WHERE a=b AND a='5'` (the transitive1-810 case).
Clean shell prints `5|5`. The buggy shell, which drops the loop that skips terms with prereqRight != 0 in whereShortCut(), aborts with the assertion `pTerm->prereqRight==0` (exit status -6).
