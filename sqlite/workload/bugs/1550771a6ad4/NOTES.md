Creates a trigger whose body calls a nonexistent aggregate (group_conct) with an ORDER BY
containing a subquery that has an error (VALUES rows of differing width), then runs
ALTER TABLE RENAME. Clean shell reports "error in trigger AFTER: all VALUES must have the
same number of terms"; the buggy shell fails an assert() in the ALTER TABLE.
