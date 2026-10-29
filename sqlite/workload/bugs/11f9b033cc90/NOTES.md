Creates a WITHOUT ROWID table and selects `rowid`, `_rowid_`, `oid` from it.
Clean shell: "no such column: ..." errors. Buggy shell: the rowid alias resolves
(no error), returning a row instead.
