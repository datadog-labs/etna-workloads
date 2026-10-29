repro.sh creates a zipfile vtab on test.zip, inserts a.txt and b.txt, then runs
UPDATE OR REPLACE z SET name='b.txt' FROM (VALUES(1),(2)).
The second row's replace finds no existing entry to delete. The clean shell returns
OK; the buggy shell walks off the end of the entry list (assert failure / crash).
