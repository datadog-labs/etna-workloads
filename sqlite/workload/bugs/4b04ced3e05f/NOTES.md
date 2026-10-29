Reproducer: `SELECT format('%.30f',1.0000000000000000076e-50);` (repro.sql).
The injection removes the clamp of leading zeros to the precision in printf's %f path.
Clean shell prints 0.000000000000000000000000000000 (exit 0); buggy shell hits
assertion `length <= szBufNeeded` in sqlite3_str_vappendf and aborts (exit -6).
