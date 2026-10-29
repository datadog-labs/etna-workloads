repro.sh builds a db with a table whose column uses an unknown collation (made by
rewriting sqlite_master with defensive off + writable_schema), then reopens it and
runs ALTER TABLE RENAME (table and column).
Clean: renames succeed, the sql in sqlite_master is updated.
Buggy: "error in table idx: no such collation sequence: nosuchcoll" and the renames fail.
