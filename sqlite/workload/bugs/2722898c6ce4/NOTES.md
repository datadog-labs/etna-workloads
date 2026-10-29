repro.sql: creates an 8-column table and runs `UPDATE t6 SET rowid=rowid+100` with the shell's `.auth ON` authorizer tracing.
Clean shell prints the authorizer calls (READ/UPDATE with column "ROWID") and updates the row.
Buggy shell passes aCol[-1].zCnName to the authorizer, so it crashes (SIGSEGV, exit -11) with no output.
