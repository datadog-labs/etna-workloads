Reproducer (`repro.sql`): two rowid tables t1, t3, then `SELECT rowid FROM t1, t3;`.
Clean shell: "ambiguous column name: rowid". Buggy shell: "no such column: rowid"
(the injected `cntTab==1` check rejects the ambiguous rowid with the wrong error). Mirrors rowid-16.9.
