Reproducer: NULL IN / NOT IN an empty table or subquery; clean gives 0 / 1, buggy returns NULL (empty-set RHS handling in sqlite3ExprCodeIN). Output differs between the shells.
