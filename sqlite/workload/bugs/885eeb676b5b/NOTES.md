repro.sql: creates a table with redundant UNIQUE/PRIMARY KEY constraints on one column and renames that column.
Clean shell: the rename works and all three constraints show the new name `bbb`.
Buggy shell: aborts with assertion failure in renameTokenCheckAll (exit -6).
