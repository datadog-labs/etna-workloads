repro.sql runs the window2-6.2 query: a vector IN (SELECT two window functions with different frames) on a UNIQUE-indexed column.
With the bug, the IN term is used for index lookup, which drops window functions from Select.pWin, so the other window function is never rewritten.
Clean shell: no output, exit 0. Buggy shell: assertion failure `memIsValid(pRec)` in sqlite3VdbeExec (abort).
