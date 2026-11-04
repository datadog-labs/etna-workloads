repro.sql calls array_resize with huge target sizes (i64::MAX on List and LargeList, and 6e17 on LargeList(Utf8)).
Clean build: each returns "Execution error: array_resize: resulting array of N elements exceeds the maximum array size".
Buggy build (size guard removed): panics with "capacity overflow", exit status 101.
