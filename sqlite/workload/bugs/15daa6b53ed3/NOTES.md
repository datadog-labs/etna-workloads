repro.sh creates a zipfile virtual table and inserts rows in the same transaction, then reads them back (zipfile-8.0.1, plus a DELETE as in 8.0.2).
Clean shell: returns the inserted data (`a.txt|1`, `b.txt|2`, ...). Buggy shell: the data column is garbage (`P`) because the entry's data offset isn't recorded.
