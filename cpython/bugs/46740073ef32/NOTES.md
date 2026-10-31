Executes DML prefixed by comments and checks rowcount, and runs multi-statement
strings whose trailing text looks like comments. Clean: rowcount 2 and 1, all
queries raise ProgrammingError. Buggy: comment-prefixed inserts are not detected as DML
(rowcount -1) and some trailing-junk queries are wrongly accepted.
