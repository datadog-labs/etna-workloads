Reproducer: inserts/updates/deletes rows in an rtree virtual table and prints changes(). Clean prints 1,1,1 (each statement succeeds); buggy prints 0 because OP_VUpdate no longer increments nChange.
