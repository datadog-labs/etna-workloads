Reproducer: `INSERT ... RETURNING t1.*` on a simple table.

Clean shell: `Parse error near line 2: RETURNING may not use "TABLE.*" wildcards`, exit 1.
Buggy shell: the isAsteriskTerm() check is gone, so the `TABLE.*` term reaches
sqlite3ExpandReturning and hits `Assertion '0' failed`, so the shell aborts (exit -6).
