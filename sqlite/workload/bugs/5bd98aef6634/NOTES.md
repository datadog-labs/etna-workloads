repro.sh feeds the shell a LIKE pattern whose first byte is 0xFF (`x LIKE '\xff%'`, written with printf) on an indexed TEXT column.
Clean: the 0xFF prefix is rejected for the LIKE range optimization, so the query plan is a SCAN and the query returns a row.
Buggy: injection.patch lets the 0xFF through, so the shell aborts with `Assertion '*pC!=0xFF' failed` in exprAnalyze (exit 134).
