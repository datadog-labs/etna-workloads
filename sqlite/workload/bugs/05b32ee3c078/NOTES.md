Reproducer (repro.sql): with trusted_schema=OFF, creates a TEMP table whose CHECK
constraint uses base64(), a deterministic SQLITE_DIRECTONLY function (stands in for
the test's `f3`). Fixed behaviour: TEMP schema objects may use such functions, so the
insert and select succeed (prints `1|x` and `x|y`). Buggy shell: EP_FromDDL is set on
any self-referencing function node, so CREATE TEMP TABLE fails with
"unsafe use of base64()" and the following statements fail with "no such table".
