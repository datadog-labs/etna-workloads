repro.sql binds `$xyzzy='a*'` via `.parameter set`, then runs `SELECT ... WHERE x GLOB $xyzzy` with `.trace stdout`.
Binding a parameter used by GLOB marks the statement expired before its first sqlite3_step(), so step re-prepares it.
Clean shell: the trace line for the SELECT is printed. Buggy shell: the SELECT is never traced (only the internal parameter lookup is), though the result `def` is the same.
