repro.sql: UPDATE ... FROM with an aggregate (`sum(a)`) over an empty table (upfrom1 test 3.1).
The aggregate yields one all-NULL row; the fix skips it (OP_IsNull) before writing to the ephemeral table.
Clean shell: runs fine, prints `0`. Buggy shell: assertion failure `pKey->flags & MEM_Int` in sqlite3VdbeExec (abort, exit -6).
