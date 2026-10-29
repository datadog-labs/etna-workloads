repro.sql builds a table with an ANY PRIMARY KEY column containing a NULL, then marks it STRICT
via writable_schema (defensive mode turned off) and runs PRAGMA integrity_check(t1).
Clean shell reports "NULL value in t1.id"; the buggy shell reports "ok" (the NULL is missed).
